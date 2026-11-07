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
package com.ctrip.framework.apollo.portal.controller;

import com.google.common.collect.Lists;

import com.ctrip.framework.apollo.common.dto.NamespaceDTO;
import com.ctrip.framework.apollo.common.dto.PageDTO;
import com.ctrip.framework.apollo.common.entity.App;
import com.ctrip.framework.apollo.portal.component.LoginOrgHolder;
import com.ctrip.framework.apollo.portal.component.PortalSettings;
import com.ctrip.framework.apollo.portal.component.config.PortalConfig;
import com.ctrip.framework.apollo.portal.environment.Env;
import com.ctrip.framework.apollo.portal.service.AppService;
import com.ctrip.framework.apollo.portal.service.NamespaceService;

import org.springframework.data.domain.Pageable;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

/**
 * @author lepdou 2021-09-13
 */
@RestController("/app")
public class SearchController {

  private AppService       appService;
  private PortalSettings   portalSettings;
  private NamespaceService namespaceService;
  private PortalConfig     portalConfig;
  private LoginOrgHolder   loginOrgHolder;

  public SearchController(final AppService appService,
                          final PortalSettings portalSettings,
                          final PortalConfig portalConfig,
                          final NamespaceService namespaceService,
                          final LoginOrgHolder loginOrgHolder) {
    this.appService = appService;
    this.portalConfig = portalConfig;
    this.portalSettings = portalSettings;
    this.namespaceService = namespaceService;
    this.loginOrgHolder = loginOrgHolder;
  }

  @GetMapping("/apps/search/by-appid-or-name")
  public PageDTO<App> search(@RequestParam(value = "query", required = false) String query, Pageable pageable) {
    String loginOrgId = loginOrgHolder.getLoginOrgId();

    // 未选择登录部门时返回空，避免跨部门搜索
    if (StringUtils.isEmpty(loginOrgId)) {
      return new PageDTO<>(Lists.newLinkedList(), pageable, 0);
    }

    if (StringUtils.isEmpty(query)) {
      return appService.searchByOrgIdAndAppIdOrName(loginOrgId, "", pageable);
    }

    //search app，仅限当前登录部门
    PageDTO<App> appPageDTO = appService.searchByOrgIdAndAppIdOrName(loginOrgId, query, pageable);
    if (appPageDTO.hasContent()) {
      return appPageDTO;
    }

    if (!portalConfig.supportSearchByItem()) {
      return new PageDTO<>(Lists.newLinkedList(), pageable, 0);
    }

    //search item
    return searchByItem(query, pageable);
  }

  private PageDTO<App> searchByItem(String itemKey, Pageable pageable) {
    List<App> result = Lists.newLinkedList();

    if (StringUtils.isEmpty(itemKey)) {
      return new PageDTO<>(result, pageable, 0);
    }

    //use the env witch has the most namespace as page index.
    final AtomicLong maxTotal = new AtomicLong(0);

    List<Env> activeEnvs = portalSettings.getActiveEnvs();

    activeEnvs.forEach(env -> {
      PageDTO<NamespaceDTO> namespacePage = namespaceService.findNamespacesByItem(env, itemKey, pageable);
      if (!namespacePage.hasContent()) {
        return;
      }

      long currentEnvNSTotal = namespacePage.getTotal();
      if (currentEnvNSTotal > maxTotal.get()) {
        maxTotal.set(namespacePage.getTotal());
      }

      List<NamespaceDTO> namespaceDTOS = namespacePage.getContent();

      namespaceDTOS.forEach(namespaceDTO -> {
        String cluster = namespaceDTO.getClusterName();
        String namespaceName = namespaceDTO.getNamespaceName();

        App app = new App();
        app.setAppId(namespaceDTO.getAppId());
        app.setName(env.getName() + " / " + cluster + " / " + namespaceName);
        app.setOrgId(env.getName() + "+" + cluster + "+" + namespaceName);
        app.setOrgName("SearchByItem" + "+" + itemKey);

        result.add(app);
      });
    });

    return new PageDTO<>(result, pageable, maxTotal.get());
  }

}
