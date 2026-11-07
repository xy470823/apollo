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

import com.ctrip.framework.apollo.core.utils.StringUtils;
import com.ctrip.framework.apollo.portal.component.LoginOrgHolder;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

/**
 * 登录成功处理器：把登录表单里选择的部门（orgId）写入 session，
 * 供后续应用列表按部门过滤使用。
 *
 * <p>登录时必须选择部门，未选择部门时直接重定向回登录页（带 error 参数），
 * 不抛出自定义异常（自定义异常会被 spring-session 序列化到数据库，反序列化时
 * 因不在 allowlist 中而触发 500）。</p>
 */
public class ApolloAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

  private final LoginOrgHolder loginOrgHolder;

  public ApolloAuthenticationSuccessHandler(LoginOrgHolder loginOrgHolder) {
    this.loginOrgHolder = loginOrgHolder;
    // 登录成功后强制跳转到首页
    setDefaultTargetUrl("/");
    setAlwaysUseDefaultTargetUrl(true);
  }

  @Override
  public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
      Authentication authentication) throws IOException, ServletException {
    String orgId = request.getParameter("orgId");
    if (StringUtils.isEmpty(orgId)) {
      // 登录必须选择部门：清空认证信息并重定向回登录页，而不是抛异常
      request.getSession().invalidate();
      response.sendRedirect(request.getContextPath() + "/signin#/error");
      return;
    }
    loginOrgHolder.setLoginOrgId(request, orgId);
    super.onAuthenticationSuccess(request, response, authentication);
  }
}
