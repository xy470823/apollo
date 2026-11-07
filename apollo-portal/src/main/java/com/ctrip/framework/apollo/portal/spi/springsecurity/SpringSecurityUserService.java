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
package com.ctrip.framework.apollo.portal.spi.springsecurity;

import com.ctrip.framework.apollo.common.exception.BadRequestException;
import com.ctrip.framework.apollo.core.utils.StringUtils;
import com.ctrip.framework.apollo.portal.entity.bo.UserInfo;
import com.ctrip.framework.apollo.portal.entity.po.Authority;
import com.ctrip.framework.apollo.portal.entity.po.UserOrg;
import com.ctrip.framework.apollo.portal.entity.po.UserPO;
import com.ctrip.framework.apollo.portal.repository.AuthorityRepository;
import com.ctrip.framework.apollo.portal.repository.UserOrgRepository;
import com.ctrip.framework.apollo.portal.repository.UserRepository;
import com.ctrip.framework.apollo.portal.spi.UserService;

import java.util.HashMap;
import java.util.Map;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author lepdou 2017-03-10
 */
public class SpringSecurityUserService implements UserService {

  private final PasswordEncoder passwordEncoder;

  private final UserRepository userRepository;

  private final AuthorityRepository authorityRepository;

  private final UserOrgRepository userOrgRepository;

  public SpringSecurityUserService(
      PasswordEncoder passwordEncoder,
      UserRepository userRepository,
      AuthorityRepository authorityRepository,
      UserOrgRepository userOrgRepository) {
    this.passwordEncoder = passwordEncoder;
    this.userRepository = userRepository;
    this.authorityRepository = authorityRepository;
    this.userOrgRepository = userOrgRepository;
  }

  @Transactional
  public void create(UserPO user) {
    String username = user.getUsername();
    String newPassword = passwordEncoder.encode(user.getPassword());
    UserPO managedUser = userRepository.findByUsername(username);
    if (managedUser != null) {
      throw BadRequestException.userAlreadyExists(username);
    }
    //create
    user.setPassword(newPassword);
    user.setEnabled(user.getEnabled());
    userRepository.save(user);

    //save authorities
    Authority authority = new Authority();
    authority.setUsername(username);
    authority.setAuthority("ROLE_user");
    authorityRepository.save(authority);

    //save user orgs
    saveUserOrgs(username, user.getOrgIds());
  }

  @Transactional
  public void update(UserPO user) {
    String username = user.getUsername();
    UserPO managedUser = userRepository.findByUsername(username);
    if (managedUser == null) {
      throw BadRequestException.userNotExists(username);
    }
    // 密码为空则不修改密码
    if (!StringUtils.isEmpty(user.getPassword())) {
      managedUser.setPassword(passwordEncoder.encode(user.getPassword()));
    }
    managedUser.setEmail(user.getEmail());
    managedUser.setUserDisplayName(user.getUserDisplayName());
    managedUser.setEnabled(user.getEnabled());
    userRepository.save(managedUser);

    //update user orgs
    userOrgRepository.deleteByUsername(username);
    saveUserOrgs(username, user.getOrgIds());
  }

  @Transactional
  public void changeEnabled(UserPO user) {
    String username = user.getUsername();
    UserPO managedUser = userRepository.findByUsername(username);
    managedUser.setEnabled(user.getEnabled());
    userRepository.save(managedUser);
  }

  /**
   * 用户修改本人密码：先校验旧密码，再写入新密码。
   */
  @Transactional
  public void changePassword(String username, String oldPassword, String newPassword) {
    UserPO managedUser = userRepository.findByUsername(username);
    if (managedUser == null) {
      throw BadRequestException.userNotExists(username);
    }
    if (!passwordEncoder.matches(oldPassword, managedUser.getPassword())) {
      throw new BadRequestException("The old password is incorrect");
    }
    if (passwordEncoder.matches(newPassword, managedUser.getPassword())) {
      throw new BadRequestException("The new password must be different from the old password");
    }
    managedUser.setPassword(passwordEncoder.encode(newPassword));
    userRepository.save(managedUser);
  }

  @Override
  public List<UserInfo> searchUsers(String keyword, int offset, int limit,
      boolean includeInactiveUsers) {
    List<UserPO> users = this.findUsers(keyword, includeInactiveUsers);
    if (CollectionUtils.isEmpty(users)) {
      return Collections.emptyList();
    }
    return users.stream().map(this::toUserInfoWithOrgs)
        .collect(Collectors.toList());
  }

  /**
   * 按部门搜索用户：仅返回属于指定部门的用户，并支持按 keyword 过滤。
   * 用于创建应用选择负责人/管理员时，只展示当前登录部门的用户。
   */
  public List<UserInfo> searchUsersByOrgId(String orgId, String keyword, boolean includeInactiveUsers) {
    if (StringUtils.isEmpty(orgId)) {
      return searchUsers(keyword, 0, 100, includeInactiveUsers);
    }
    List<UserOrg> userOrgs = userOrgRepository.findByOrgId(orgId);
    if (CollectionUtils.isEmpty(userOrgs)) {
      return Collections.emptyList();
    }
    List<String> usernames = userOrgs.stream()
        .map(UserOrg::getUsername)
        .distinct()
        .collect(Collectors.toList());
    List<UserPO> users = userRepository.findByUsernameIn(usernames);
    if (CollectionUtils.isEmpty(users)) {
      return Collections.emptyList();
    }
    // 非活跃用户过滤
    if (!includeInactiveUsers) {
      users = users.stream().filter(u -> u.getEnabled() == 1).collect(Collectors.toList());
    }
    // keyword 过滤（按用户名或显示名）
    if (!StringUtils.isEmpty(keyword)) {
      String kw = keyword.toLowerCase();
      users = users.stream()
          .filter(u -> u.getUsername().toLowerCase().contains(kw)
              || (u.getUserDisplayName() != null && u.getUserDisplayName().toLowerCase().contains(kw)))
          .collect(Collectors.toList());
    }
    return users.stream().map(this::toUserInfoWithOrgs).collect(Collectors.toList());
  }

  private List<UserPO> findUsers(String keyword, boolean includeInactiveUsers) {
    Map<Long, UserPO> users = new HashMap<>();
    List<UserPO> byUsername;
    List<UserPO> byUserDisplayName;
    if (includeInactiveUsers) {
      if (StringUtils.isEmpty(keyword)) {
        return (List<UserPO>) userRepository.findAll();
      }
      byUsername = userRepository.findByUsernameLike("%" + keyword + "%");
      byUserDisplayName = userRepository.findByUserDisplayNameLike("%" + keyword + "%");
    } else {
      if (StringUtils.isEmpty(keyword)) {
        return userRepository.findFirst20ByEnabled(1);
      }
      byUsername = userRepository.findByUsernameLikeAndEnabled("%" + keyword + "%", 1);
      byUserDisplayName = userRepository
          .findByUserDisplayNameLikeAndEnabled("%" + keyword + "%", 1);
    }
    if (!CollectionUtils.isEmpty(byUsername)) {
      for (UserPO user : byUsername) {
        users.put(user.getId(), user);
      }
    }
    if (!CollectionUtils.isEmpty(byUserDisplayName)) {
      for (UserPO user : byUserDisplayName) {
        users.put(user.getId(), user);
      }
    }
    return new ArrayList<>(users.values());
  }

  @Override
  public UserInfo findByUserId(String userId) {
    UserPO userPO = userRepository.findByUsername(userId);
    return userPO == null ? null : toUserInfoWithOrgs(userPO);
  }

  @Override
  public List<UserInfo> findByUserIds(List<String> userIds) {
    List<UserPO> users = userRepository.findByUsernameIn(userIds);

    if (CollectionUtils.isEmpty(users)) {
      return Collections.emptyList();
    }

    return users.stream().map(this::toUserInfoWithOrgs).collect(Collectors.toList());
  }

  private UserInfo toUserInfoWithOrgs(UserPO userPO) {
    UserInfo userInfo = userPO.toUserInfo();
    userInfo.setOrgIds(findOrgIdsByUsername(userPO.getUsername()));
    return userInfo;
  }

  private List<String> findOrgIdsByUsername(String username) {
    List<UserOrg> userOrgs = userOrgRepository.findByUsername(username);
    if (CollectionUtils.isEmpty(userOrgs)) {
      return Collections.emptyList();
    }
    return userOrgs.stream().map(UserOrg::getOrgId).collect(Collectors.toList());
  }

  private void saveUserOrgs(String username, List<String> orgIds) {
    if (CollectionUtils.isEmpty(orgIds)) {
      return;
    }
    for (String orgId : orgIds) {
      if (StringUtils.isEmpty(orgId)) {
        continue;
      }
      UserOrg userOrg = new UserOrg();
      userOrg.setUsername(username);
      userOrg.setOrgId(orgId);
      userOrgRepository.save(userOrg);
    }
  }
}
