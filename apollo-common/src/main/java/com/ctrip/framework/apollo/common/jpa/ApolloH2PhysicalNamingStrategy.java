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
package com.ctrip.framework.apollo.common.jpa;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import org.hibernate.boot.model.naming.Identifier;
import org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl;
import org.hibernate.engine.jdbc.env.spi.JdbcEnvironment;

/**
 * Physical naming strategy for the H2 profiles.
 *
 * <p>H2 treats {@code KEY} and {@code VALUE} as reserved words, so columns with such names
 * can not be created with an unquoted identifier. Upstream Apollo works around this for
 * MySQL by quoting the column with backticks, which is not valid for Oracle. This strategy
 * quotes the column with the standard double quotes instead, which is accepted by H2 and
 * does not affect the other databases, because it is only enabled for the H2 profiles.
 */
public class ApolloH2PhysicalNamingStrategy extends PhysicalNamingStrategyStandardImpl {

  /**
   * Column names that are reserved words in H2 and therefore have to be quoted.
   * KEY and VALUE are reserved in H2 (and in MySQL KEY is reserved as well).
   */
  private static final Set<String> RESERVED_COLUMN_NAMES = new HashSet<>(Arrays.asList("Key", "Value"));

  @Override
  public Identifier toPhysicalColumnName(Identifier logicalName, JdbcEnvironment jdbcEnvironment) {
    Identifier physicalName = super.toPhysicalColumnName(logicalName, jdbcEnvironment);
    if (physicalName != null && RESERVED_COLUMN_NAMES.contains(physicalName.getText())) {
      return Identifier.toIdentifier("\"" + physicalName.getText() + "\"", physicalName.isQuoted());
    }
    return physicalName;
  }
}
