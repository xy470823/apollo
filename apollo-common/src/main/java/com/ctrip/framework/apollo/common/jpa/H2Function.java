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

/**
 * @author nisiyong
 */
public class H2Function {

  public static long unixTimestamp(java.sql.Timestamp timestamp) {
    return timestamp.getTime() / 1000L;
  }

  /**
   * H2 equivalent of the oracle UNIX_TIMESTAMP_MILLIS function, which converts a timestamp
   * into the number of milliseconds since 1970-01-01 00:00:00 UTC.
   */
  public static long unixTimestampMillis(java.sql.Timestamp timestamp) {
    return timestamp.getTime();
  }
}
