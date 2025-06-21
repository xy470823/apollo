/*
 * Copyright 2024 Apollo Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package com.ctrip.framework.apollo.biz.service;

import com.ctrip.framework.apollo.biz.config.BizConfig;
import com.ctrip.framework.apollo.biz.entity.Audit;
import com.ctrip.framework.apollo.biz.entity.Item;
import com.ctrip.framework.apollo.biz.entity.Namespace;
import com.ctrip.framework.apollo.biz.utils.ConfigChangeContentBuilder;
import com.ctrip.framework.apollo.common.dto.ItemChangeSets;
import com.ctrip.framework.apollo.common.dto.ItemDTO;
import com.ctrip.framework.apollo.common.exception.BadRequestException;
import com.ctrip.framework.apollo.common.exception.NotFoundException;
import com.ctrip.framework.apollo.common.utils.BeanUtils;
import com.ctrip.framework.apollo.core.utils.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.util.*;
import java.util.stream.Collectors;


@Service
public class ItemSetService {

  private final AuditService auditService;
  private final CommitService commitService;
  private final ItemService itemService;
  private final NamespaceService namespaceService;
  private final BizConfig bizConfig;

  public ItemSetService(
      final AuditService auditService,
      final CommitService commitService,
      final ItemService itemService,
      final NamespaceService namespaceService,
      final BizConfig bizConfig) {
    this.auditService = auditService;
    this.commitService = commitService;
    this.itemService = itemService;
    this.namespaceService = namespaceService;
    this.bizConfig = bizConfig;
  }

  @Transactional
  public ItemChangeSets updateSet(Namespace namespace, ItemChangeSets changeSets) {
    return updateSet(namespace.getAppId(), namespace.getClusterName(), namespace.getNamespaceName(), changeSets);
  }

  @Transactional
  public ItemChangeSets updateSet(String appId, String clusterName, String namespaceName, ItemChangeSets changeSet) {
    String operator = changeSet.getDataChangeLastModifiedBy();
    if (changeSet.isEmpty()) {
      //删除历史注释重复的数据
      deleteComments(appId, clusterName, namespaceName,operator);
      return changeSet;
    }
    List<ItemDTO> nullList = changeSet.getCreateItems().stream()
            .filter(item -> StringUtils.isBlank(item.getKey())
                    && StringUtils.isBlank(item.getValue())
                    && StringUtils.isBlank(item.getComment()))
            .collect(Collectors.toList());
    if (!nullList.isEmpty()) {
      throw new BadRequestException("第" + nullList.get(0).getLineNum() + "行 无数据;请确认");
    }
    Namespace namespace = namespaceService.findOne(appId, clusterName, namespaceName);
    if (namespace == null) {
      throw NotFoundException.namespaceNotFound(appId, clusterName, namespaceName);
    }

    if (bizConfig.isItemNumLimitEnabled()) {
      int itemCount = itemService.findNonEmptyItemCount(namespace.getId());
      int createItemCount = (int) changeSet.getCreateItems().stream().filter(item -> !StringUtils.isEmpty(item.getKey())).count();
      int deleteItemCount = (int) changeSet.getDeleteItems().stream().filter(item -> !StringUtils.isEmpty(item.getKey())).count();
      itemCount = itemCount + createItemCount - deleteItemCount;
      if (itemCount > bizConfig.itemNumLimit()) {
        throw new BadRequestException("The maximum number of items (" + bizConfig.itemNumLimit() + ") for this namespace has been reached. Current item count is " + itemCount + ".");
      }
    }

    ConfigChangeContentBuilder configChangeContentBuilder = new ConfigChangeContentBuilder();
    if (!CollectionUtils.isEmpty(changeSet.getCreateItems())) {
      //注释去重之后的数据
      List<ItemDTO> createItemList =distinctComments(changeSet.getCreateItems());
      //添加去重后的数据
      changeSet.setCreateItems(createItemList);
      this.doCreateItems(changeSet.getCreateItems(), namespace, operator, configChangeContentBuilder);
      auditService.audit("ItemSet", null, Audit.OP.INSERT, operator);
    }
    if (!CollectionUtils.isEmpty(changeSet.getUpdateItems())) {
      this.doUpdateItems(changeSet.getUpdateItems(), namespace, operator, configChangeContentBuilder);
      auditService.audit("ItemSet", null, Audit.OP.UPDATE, operator);
    }
    if (!CollectionUtils.isEmpty(changeSet.getDeleteItems())) {
      this.doDeleteItems(changeSet.getDeleteItems(), namespace, operator, configChangeContentBuilder);
      auditService.audit("ItemSet", null, Audit.OP.DELETE, operator);
    }
    //删除历史注释重复的数据
    deleteComments(appId, clusterName, namespaceName,operator);
    if (configChangeContentBuilder.hasContent()) {
      commitService.createCommit(appId, clusterName, namespaceName, configChangeContentBuilder.build(),
                                 changeSet.getDataChangeLastModifiedBy());
    }

    return changeSet;
  }

  public static List<ItemDTO>  distinctComments(List<ItemDTO> itemDTOList) {
    if (CollectionUtils.isEmpty(itemDTOList)) {
      return itemDTOList;
    }
    // 使用 LinkedHashMap 保留顺序并去重
    Map<String, ItemDTO> distinctComments = new LinkedHashMap<>();
    List<ItemDTO> filteredList = new ArrayList<>();
    for (ItemDTO item : itemDTOList) {
      if (org.apache.commons.lang3.StringUtils.isAllBlank(item.getKey(), item.getValue())) {
        String comment = item.getComment();
        // 只保留首次出现的 comment，不为 null 才去重
        if (!distinctComments.containsKey(comment)) {
          distinctComments.put(comment, item);
          continue;
        }
        throw new RuntimeException("第" + item.getLineNum() + "与第" + distinctComments.get(comment).getLineNum() + "行数据重复");
      }
      filteredList.add(item); // 非空项直接保留
    }
    // 添加去重后的空白项
    filteredList.addAll(distinctComments.values());
    return filteredList;
  }

  private void deleteComments(String appId, String clusterName, String namespaceName,String operator){
    //获取所有数据
    List<Item> allList = itemService.findItemsWithOrdered(appId, clusterName, namespaceName);
    //筛选出所有的注释数据
    List<Item> allCommentsList = allList.stream()
            .filter(item -> org.apache.commons.lang3.StringUtils.isAllBlank(item.getKey(), item.getValue()))
            .collect(Collectors.toList());
    List<Item> deleteList = new ArrayList<>(allCommentsList.stream()
            // 过滤掉 COMMENT 为 null 的项
            .filter(item -> item.getComment() != null)
            // 按 COMMENT 分组并取最新时间
            .collect(Collectors.toMap(
                    Item::getComment,
                    item -> item,
                    // 当两个相同 COMMENT 出现时，保留时间更大的
                    (existing, replacement) ->
                            existing.getDataChangeLastModifiedTime().compareTo(replacement.getDataChangeLastModifiedTime()) > 0
                                    ? existing : replacement
            ))
            .values());
    //对数据库重复的注释数据进行删除
    allCommentsList.removeAll(deleteList);
    allCommentsList.forEach(item -> itemService.delete(item.getId(),operator));
  }

  private void deleteComments(String appId, String clusterName, String namespaceName,List<ItemDTO> createItemList,String operator){
    //获取所有数据
    List<Item> allList = itemService.findItemsWithOrdered(appId, clusterName, namespaceName);
    //筛选出所有的注释数据
    List<Item> allCommentsList = allList.stream()
            .filter(item -> org.apache.commons.lang3.StringUtils.isAllBlank(item.getKey(), item.getValue()))
            .collect(Collectors.toList());
    //筛选出本次需要新建的注释数据
    List<ItemDTO> newCommentsList = createItemList.stream()
            .filter(item -> org.apache.commons.lang3.StringUtils.isAllBlank(item.getKey(), item.getValue()))
            .collect(Collectors.toList());
    Set<String> newCommentKeys = newCommentsList.stream()
            .map(ItemDTO::getComment)
            .filter(org.apache.commons.lang3.StringUtils::isNotBlank)
            .collect(Collectors.toSet());
    //筛选出数据库注释与本次新增注释重复的数据
    List<Item> deleteList = allCommentsList.stream()
            .filter(item -> newCommentKeys.contains(item.getComment()))
            .collect(Collectors.toList());
    //对数据库重复的注释数据进行删除
    deleteList.forEach(item -> itemService.delete(item.getId(),operator));

  }


  private void doDeleteItems(List<ItemDTO> toDeleteItems, Namespace namespace, String operator,
                             ConfigChangeContentBuilder configChangeContentBuilder) {

    for (ItemDTO item : toDeleteItems) {
      Item deletedItem = itemService.delete(item.getId(), operator);
      if (deletedItem.getNamespaceId() != namespace.getId()) {
        throw BadRequestException.namespaceNotMatch();
      }

      configChangeContentBuilder.deleteItem(deletedItem);
    }
  }

  private void doUpdateItems(List<ItemDTO> toUpdateItems, Namespace namespace, String operator,
                             ConfigChangeContentBuilder configChangeContentBuilder) {

    for (ItemDTO item : toUpdateItems) {
      Item entity = BeanUtils.transform(Item.class, item);

      Item managedItem = itemService.findOne(entity.getId());
      if (managedItem == null) {
        throw NotFoundException.itemNotFound(entity.getKey());
      }
      if (managedItem.getNamespaceId() != namespace.getId()) {
        throw BadRequestException.namespaceNotMatch();
      }
      Item beforeUpdateItem = BeanUtils.transform(Item.class, managedItem);

      //protect. only value,type,comment,lastModifiedBy can be modified
      managedItem.setType(entity.getType());
      managedItem.setValue(entity.getValue());
      managedItem.setComment(entity.getComment());
      managedItem.setLineNum(entity.getLineNum());
      managedItem.setDataChangeLastModifiedBy(operator);

      Item updatedItem = itemService.update(managedItem);
      configChangeContentBuilder.updateItem(beforeUpdateItem, updatedItem);
    }
  }

  private void doCreateItems(List<ItemDTO> toCreateItems, Namespace namespace, String operator,
                             ConfigChangeContentBuilder configChangeContentBuilder) {

    for (ItemDTO item : toCreateItems) {
      if (item.getNamespaceId() != namespace.getId()) {
        throw BadRequestException.namespaceNotMatch();
      }

      Item entity = BeanUtils.transform(Item.class, item);
      entity.setDataChangeCreatedBy(operator);
      entity.setDataChangeLastModifiedBy(operator);
      Item createdItem = itemService.save(entity);
      configChangeContentBuilder.createItem(createdItem);
    }
  }

}
