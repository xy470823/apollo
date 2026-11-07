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

import com.ctrip.framework.apollo.common.exception.BadRequestException;
import com.ctrip.framework.apollo.core.utils.StringUtils;
import com.ctrip.framework.apollo.portal.component.LoginOrgHolder;
import com.ctrip.framework.apollo.portal.entity.bo.UserInfo;
import com.ctrip.framework.apollo.portal.entity.po.UserPO;
import com.ctrip.framework.apollo.portal.entity.vo.ChangePasswordRequest;
import com.ctrip.framework.apollo.portal.spi.LogoutHandler;
import com.ctrip.framework.apollo.portal.spi.UserInfoHolder;
import com.ctrip.framework.apollo.portal.spi.UserService;
import com.ctrip.framework.apollo.portal.spi.springsecurity.SpringSecurityUserService;
import com.ctrip.framework.apollo.portal.util.checker.AuthUserPasswordChecker;
import com.ctrip.framework.apollo.portal.util.checker.CheckResult;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserInfoController {

  private final UserInfoHolder userInfoHolder;
  private final LogoutHandler logoutHandler;
  private final UserService userService;
  private final AuthUserPasswordChecker passwordChecker;
  private final LoginOrgHolder loginOrgHolder;

  public UserInfoController(
      final UserInfoHolder userInfoHolder,
      final LogoutHandler logoutHandler,
      final UserService userService,
      final AuthUserPasswordChecker passwordChecker,
      final LoginOrgHolder loginOrgHolder) {
    this.userInfoHolder = userInfoHolder;
    this.logoutHandler = logoutHandler;
    this.userService = userService;
    this.passwordChecker = passwordChecker;
    this.loginOrgHolder = loginOrgHolder;
  }

  @PreAuthorize(value = "@userPermissionValidator.isSuperAdmin()")
  @PostMapping("/users")
  public void createOrUpdateUser(
      @RequestParam(value = "isCreate", defaultValue = "false") boolean isCreate,
      @RequestBody UserPO user) {
    if (StringUtils.isEmpty(user.getUsername())) {
      throw new BadRequestException("Username can not be empty.");
    }

    // 创建时密码必填；修改时密码可空（为空则保留原密码）
    boolean passwordEmpty = StringUtils.isEmpty(user.getPassword());
    if (isCreate && passwordEmpty) {
      throw new BadRequestException("Username and password can not be empty.");
    }

    // 除 apollo 外，其他用户添加/修改时必须选择部门
    if (!"apollo".equals(user.getUsername())
        && (user.getOrgIds() == null || user.getOrgIds().isEmpty())) {
      throw new BadRequestException("请选择用户所属部门");
    }

    // 仅在密码非空时校验密码强度
    if (!passwordEmpty) {
      CheckResult pwdCheckRes = passwordChecker.checkWeakPassword(user.getPassword());
      if (!pwdCheckRes.isSuccess()) {
        throw new BadRequestException(pwdCheckRes.getMessage());
      }
    }

    if (userService instanceof SpringSecurityUserService) {
      if (isCreate) {
        ((SpringSecurityUserService) userService).create(user);
      } else {
        ((SpringSecurityUserService) userService).update(user);
      }
    } else {
      throw new UnsupportedOperationException("Create or update user operation is unsupported");
    }
  }

  @PreAuthorize(value = "@userPermissionValidator.isSuperAdmin()")
  @PutMapping("/users/enabled")
  public void changeUserEnabled(@RequestBody UserPO user) {
    if (userService instanceof SpringSecurityUserService) {
      ((SpringSecurityUserService) userService).changeEnabled(user);
    } else {
      throw new UnsupportedOperationException("change user enabled is unsupported");
    }
  }

  /**
   * 修改当前登录用户本人的密码，任何已登录用户都可以调用，无需管理员权限。
   * 用户名只从会话中取，不接受请求体传入，避免越权改他人密码。
   */
  @PutMapping("/users/password")
  public void changeOwnPassword(@RequestBody ChangePasswordRequest request) {
    UserInfo currentUser = userInfoHolder.getUser();
    if (currentUser == null) {
      throw new BadRequestException("User is not logged in.");
    }

    if (StringUtils.isContainEmpty(request.getOldPassword(), request.getNewPassword())) {
      throw new BadRequestException("Old password and new password can not be empty.");
    }

    CheckResult pwdCheckRes = passwordChecker.checkWeakPassword(request.getNewPassword());
    if (!pwdCheckRes.isSuccess()) {
      throw new BadRequestException(pwdCheckRes.getMessage());
    }

    if (userService instanceof SpringSecurityUserService) {
      ((SpringSecurityUserService) userService).changePassword(currentUser.getUserId(),
          request.getOldPassword(), request.getNewPassword());
    } else {
      throw new UnsupportedOperationException("change password is unsupported");
    }
  }

  @GetMapping("/user")
  public UserInfo getCurrentUserName() {
    return userInfoHolder.getUser();
  }

  /**
   * 查询当前登录用户在本次会话中选择的部门（orgId）。
   */
  @GetMapping("/user/current-org")
  public Map<String, String> getCurrentLoginOrg() {
    Map<String, String> result = new HashMap<>();
    result.put("orgId", loginOrgHolder.getLoginOrgId());
    return result;
  }

  /**
   * 切换当前登录用户在本次会话中的部门（orgId），用于首页按部门切换应用列表。
   */
  @PutMapping("/user/current-org")
  public void switchLoginOrg(@RequestBody Map<String, String> body) {
    String orgId = body == null ? null : body.get("orgId");
    UserInfo currentUser = userInfoHolder.getUser();
    if (currentUser == null) {
      throw new BadRequestException("User is not logged in.");
    }
    if (StringUtils.isEmpty(orgId)) {
      throw new BadRequestException("orgId can not be empty.");
    }
    // 校验该用户确实属于该部门
    List<String> userOrgs = currentUser.getOrgIds();
    if (userOrgs == null || !userOrgs.contains(orgId)) {
      throw new BadRequestException("User does not belong to the organization: " + orgId);
    }
    loginOrgHolder.setLoginOrgId(orgId);
  }

  @GetMapping("/user/logout")
  public void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
    logoutHandler.logout(request, response);
  }

  @GetMapping("/users")
  public List<UserInfo> searchUsersByKeyword(@RequestParam(value = "keyword", required = false) String keyword,
      @RequestParam(value = "includeInactiveUsers", defaultValue = "false") boolean includeInactiveUsers,
      @RequestParam(value = "offset", defaultValue = "0") int offset,
      @RequestParam(value = "limit", defaultValue = "10") int limit) {
    // 若为 Spring Security 用户服务，按当前登录部门过滤用户，仅展示同部门的用户
    if (userService instanceof SpringSecurityUserService) {
      String loginOrgId = loginOrgHolder.getLoginOrgId();
      return ((SpringSecurityUserService) userService)
          .searchUsersByOrgId(loginOrgId, keyword, includeInactiveUsers);
    }
    return userService.searchUsers(keyword, offset, limit, includeInactiveUsers);
  }

  @GetMapping("/users/{userId}")
  public UserInfo getUserByUserId(@PathVariable String userId) {
    return userService.findByUserId(userId);
  }

}
