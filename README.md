# apollo
Apollo Oracle 版本



基于携程[Apollo](https://github.com/apolloconfig/apollo) 2025-06-15 master分支改造;


# 版本信息

| 中间件    | 版本                                                        |
| :----- | :-------------------------------------------------------- |
| JDK    | Java(TM) SE Runtime Environment (build 1.8.0\_371-b11)    |
| Oracle | Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 |

# 部署步骤

## 1. 建库（Oracle）

> ⚠️ `scripts/sql/src/` 下的是 **Oracle 脚本**，可直接执行；
> `scripts/sql/mysql/` 下的才是 **MySQL 方言的母版**，仅供 `apollo-build-sql-converter`
> 生成 `scripts/sql/profiles/{mysql-default,mysql-database-not-specified,h2-default}` 使用，在 Oracle 上执行会报
> `ORA-00911: invalid character`。

Oracle DDL 就在 `scripts/sql/src/` 下，两个库各一个文件，执行顺序为：
**表空间 + 用户** → **表/索引/触发器** → **自定义函数**（脚本内已按此顺序编排）。

```bash
# 用业务账号（表空间属主）直接执行
sqlplus APOLLO_CONFIG/******@//host:1521/orclpdb @scripts/sql/src/apolloconfigdb.sql
sqlplus APOLLO_PORTAL/******@//host:1521/orclpdb @scripts/sql/src/apolloportaldb.sql
```

注意：

- 脚本开头的 `CREATE TABLESPACE` / `CREATE USER` / `GRANT` **默认已注释**（以业务账号执行时需要权限），
  需要新建表空间/用户时用 DBA 身份取消注释后执行，并修改数据文件路径；
- 脚本不包含 `DROP TABLE`，重复执行会报 "table already exists"；
- 必须执行到脚本末尾的 `UNIX_TIMESTAMP_MILLIS` 函数（软删除逻辑会用到它）；
- 脚本中的建表语句与实体映射一致（包括 `"AUDIT"`、`"CLUSTER"`、`"COMMENT"`、`"NAME"`、`"MODE"` 等 Oracle 保留字，已加双引号）。

## 2. 应用配置

使用 `github` profile（已配置 Oracle 数据源）：

```properties
# apollo-configservice / apollo-adminservice
spring.datasource.url=jdbc:oracle:thin:@//host:2001/orclpdb
spring.datasource.username=apollo_config
spring.datasource.password=******

# apollo-portal
spring.datasource.url=jdbc:oracle:thin:@//host:2001/orclpdb
spring.datasource.username=apollo_portal
spring.datasource.password=******
```

## 3. 本地开发（H2）

`apollo-assembly` 的 `github` profile 使用 H2 内存库，建表脚本由 `scripts/sql/profiles/h2-default/` 提供，
它由 MySQL 母版 `scripts/sql/mysql/**` 生成，修改后需重新生成：

```bash
mvn compile -pl apollo-build-sql-converter -Psql-converter
```
