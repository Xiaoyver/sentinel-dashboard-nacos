# Sentinel 控制台

## 0. 概述

Sentinel 控制台是流量控制、熔断降级规则统一配置和管理的入口，它为用户提供了机器自发现、簇点链路自发现、监控、规则配置等功能。在 Sentinel 控制台上，我们可以配置规则并实时查看流量控制效果。

## 1. 编译和启动

### 1.1 如何编译

使用如下命令将代码打包成一个 fat jar:

```bash
mvn clean package
```

### 1.2 如何启动

使用如下命令启动编译后的控制台：

```bash
java -Dserver.port=8080 \
-Dcsp.sentinel.dashboard.server=localhost:8080 \
-Dproject.name=sentinel-dashboard \
-jar target/sentinel-dashboard.jar
```

上述命令中我们指定几个 JVM 参数，其中 `-Dserver.port=8080` 是 Spring Boot 的参数，
用于指定 Spring Boot 服务端启动端口为 `8080`。其余几个是 Sentinel 客户端的参数。

为便于演示，我们对控制台本身加入了流量控制功能，具体做法是引入 Sentinel 提供的 `CommonFilter` 这个 Servlet Filter。
上述 JVM 参数的含义是：

| 参数 | 作用 |
|--------|--------|
|`-Dcsp.sentinel.dashboard.server=localhost:8080`|向 Sentinel 接入端指定控制台的地址|
|`-Dproject.name=sentinel-dashboard`|向 Sentinel 指定应用名称，比如上面对应的应用名称就为 `sentinel-dashboard`|

全部的配置项可以参考 [启动配置项文档](https://github.com/alibaba/Sentinel/wiki/%E5%90%AF%E5%8A%A8%E9%85%8D%E7%BD%AE%E9%A1%B9)。

经过上述配置，控制台启动后会自动向自己发送心跳。程序启动后浏览器访问 `localhost:8080` 即可访问 Sentinel 控制台。

从 Sentinel 1.6.0 开始，Sentinel 控制台支持简单的**登录**功能，默认用户名和密码都是 `sentinel`。用户可以通过如下参数进行配置：

- `-Dsentinel.dashboard.auth.username=sentinel` 用于指定控制台的登录用户名为 `sentinel`；
- `-Dsentinel.dashboard.auth.password=123456` 用于指定控制台的登录密码为 `123456`；如果省略这两个参数，默认用户和密码均为 `sentinel`；
- `-Dserver.servlet.session.timeout=7200` 用于指定 Spring Boot 服务端 session 的过期时间，如 `7200` 表示 7200 秒；`60m` 表示 60 分钟，默认为 30 分钟；

## 2. 客户端接入

选择合适的方式接入 Sentinel，然后在应用启动时加入 JVM 参数 `-Dcsp.sentinel.dashboard.server=consoleIp:port` 指定控制台地址和端口。
确保客户端有访问量，**Sentinel 会在客户端首次调用的时候进行初始化，开始向控制台发送心跳包**，将客户端纳入到控制台的管辖之下。

客户端接入的详细步骤请参考 [Wiki 文档](https://github.com/alibaba/Sentinel/wiki/%E6%8E%A7%E5%88%B6%E5%8F%B0#3-%E5%AE%A2%E6%88%B7%E7%AB%AF%E6%8E%A5%E5%85%A5%E6%8E%A7%E5%88%B6%E5%8F%B0)。

## 3. 验证是否接入成功

客户端正确配置并启动后，会**在初次调用后**主动向控制台发送心跳包，汇报自己的存在；
控制台收到客户端心跳包之后，会在左侧导航栏中显示该客户端信息。如果控制台能够看到客户端的机器信息，则表明客户端接入成功了。

## 6. 构建Docker镜像

```bash
docker build --build-arg SENTINEL_VERSION=1.8.9 -t ${REGISTRY}/sentinel-dashboard:v1.8.9 .
```

*注意：Sentinel 控制台目前仅支持单机部署。Sentinel 控制台项目提供 Sentinel 功能全集示例，不作为开箱即用的生产环境控制台，不提供安全可靠保障。若希望在生产环境使用请根据[文档](https://github.com/alibaba/Sentinel/wiki/%E5%9C%A8%E7%94%9F%E4%BA%A7%E7%8E%AF%E5%A2%83%E4%B8%AD%E4%BD%BF%E7%94%A8-Sentinel)自行进行定制和改造。*

更多：[控制台功能介绍](./Sentinel_Dashboard_Feature.md)。
# Sentinel v1.8.9 控制台(Nacos 数据源)

> 支持 Dashboard 页面新增/编辑/删除 Sentinel 配置,同步到 Nacos 配置中心
>

## 介绍
1. 新增了4个文件

- `NacosConfig`
- `NacosConfigUtil`
- `RuleNacosProvider`
- `RuleNacosPublisher`

2. 修改了多个`controller`文件

- `AuthorityRuleController`
- `DegradeRuleController`
- `FlowRuleControllerV1`
- `FlowRuleControllerV2`
- `GatewayApiController`
- `ParamFlowRuleController`
- `SystemController`

3. 修改了`Dockerfile` 文件
4. 注意
    - Group默认是`SENTINEL_GROUP`(有需要可自行修改代码,我这边默认用的这个)
    - Nacos记得要开启
    - 项目启动后,请求一下才会在Dashboard上显示
    - `NacosConfigUtil`建议看一下,配置dataId的时候会用到里面的后缀
5. 集成示例
    ```xml
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-bootstrap</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba.cloud</groupId>
            <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
        </dependency>
        <dependency>
            <groupId>com.alibaba.csp</groupId>
            <artifactId>sentinel-datasource-nacos</artifactId>
        </dependency>
   ```
    ```yaml
    server:
      port: 8888
    
    spring:
      application:
        name: shop-test-service
    
      cloud:
        inetutils:
          preferred-networks: 192.168.11 # 优先启动该前缀的IP
        nacos:
          discovery:
            username: nacos
            password: nacos
            namespace: shop
            group: DEFAULT_GROUP
            weight: 10
            cluster-name: shopCluster
          server-addr: 192.168.11.10:8848
        openfeign:
          client:
            config:
              default:
                connectTimeout: 5000
                readTimeout: 10000
        sentinel:
          transport:
            dashboard: 192.168.11.10:18081 #配置Sentinel dashboard地址
            port: 10000 #默认8719端口，假如被占用会自动从8719开始依次+1扫描,直至找到未被占用的端口
          web-context-unify: false # controller层的方法对service层调用不认为是同一个根链路
          datasource:
            #名字自定义即可,配置流控规则
            ds1:
              nacos:
                server-addr: 192.168.11.10:8848
                username: nacos
                password: nacos
                rule-type: flow
                groupId: SENTINEL_GROUP
                data-type: json
                namespace: shop
                dataId: shop-test-service-flow-rules
            #名字自定义即可,配置熔断规则 
            ds2:
              nacos:
                server-addr: 192.168.11.10:8848
                username: nacos
                password: nacos
                rule-type: degrade
                groupId: SENTINEL_GROUP
                data-type: json
                namespace: shop
                dataId: shop-test-service-degrade-rules
    
    #设置日志级别,ERROR/WARN/INFO/DEBUG,默认是INFO以上才显示
    logging:
      level:
        root: INFO
        com.alibaba.nacos.client.config.impl: WARN
      config: classpath:logConfig/logback-spring-dev.xml
      file:
        path: ./logs/test-log
    
    ```

## 自行打包镜像

1. 下载文件
2. 进入目录打包
    ```shell
        mvn clean -DskipTests=true package
    ```
3. 打包docker镜像
    ```shell
        docker build -t sentinel-dashboard-nacos:1.8.9 .
    ```
4. 运行docker镜像
    ```shell
        docker run -e NACOS_SERVER_ADDR=192.168.11.10:8848 \
           -e NACOS_NAMESPACE=shop \
           -e NACOS_USERNAME=nacos \
           -e NACOS_PASSWORD=nacos \
           -e SERVER_PORT=8080 \
           -p 8080:8080 \
           sentinel-dashboard-nacos:1.8.9
    ```