# Sentinel v1.8.8 控制台(Nacos 数据源)

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
        docker build -t sentinel-dashboard-nacos:1.8.8 .
    ```
4. 运行docker镜像
    ```shell
        docker run -e NACOS_SERVER_ADDR=192.168.11.10:8848 \
           -e NACOS_NAMESPACE=shop \
           -e NACOS_USERNAME=nacos \
           -e NACOS_PASSWORD=nacos \
           -e SERVER_PORT=8080 \
           -p 8080:8080 \
           sentinel-dashboard-nacos:1.8.8
    ```
   
原始README: [Sentinel 控制台启动和客户端接入](./original_readme.md)
