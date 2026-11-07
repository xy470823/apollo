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
package com.ctrip.framework.apollo.portal.component;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * 持有当前登录用户在本次会话中所选择的部门（orgId）。
 *
 * <p>登录成功后由认证成功处理器写入，应用列表、创建应用等业务按该部门过滤数据。</p>
 */
@Component
public class LoginOrgHolder {

  private static final String LOGIN_ORG_SESSION_KEY = "APOLLO_LOGIN_ORG_ID";

  public void setLoginOrgId(String orgId) {
    HttpSession session = getSession(false);
    if (session != null) {
      session.setAttribute(LOGIN_ORG_SESSION_KEY, orgId);
    }
  }

  /**
   * 直接基于给定的 request 写入当前登录部门，用于认证成功处理器中（此时 RequestContextHolder
   * 可能尚未绑定请求上下文，但 request 参数中已有已创建的 session）。
   */
  public void setLoginOrgId(HttpServletRequest request, String orgId) {
    if (request == null) {
      return;
    }
    HttpSession session = request.getSession(false);
    if (session == null) {
      session = request.getSession(true);
    }
    session.setAttribute(LOGIN_ORG_SESSION_KEY, orgId);
  }

  public String getLoginOrgId() {
    HttpSession session = getSession(false);
    if (session == null) {
      return null;
    }
    Object value = session.getAttribute(LOGIN_ORG_SESSION_KEY);
    return value == null ? null : String.valueOf(value);
  }

  public void clear() {
    HttpSession session = getSession(false);
    if (session != null) {
      session.removeAttribute(LOGIN_ORG_SESSION_KEY);
    }
  }

  private HttpSession getSession(boolean create) {
    ServletRequestAttributes attributes =
        (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
    if (attributes == null) {
      return null;
    }
    HttpServletRequest request = attributes.getRequest();
    if (request == null) {
      return null;
    }
    return request.getSession(create);
  }
}
