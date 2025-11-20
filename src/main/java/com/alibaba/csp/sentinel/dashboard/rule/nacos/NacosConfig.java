package com.alibaba.csp.sentinel.dashboard.rule.nacos;

import com.alibaba.nacos.api.PropertyKeyConst;
import com.alibaba.nacos.api.config.ConfigFactory;
import com.alibaba.nacos.api.config.ConfigService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Properties;

/**
 * @author gdLiu
 * @date 2025/11/18 18:18
 */
@Configuration
public class NacosConfig {

    /**
     * 从环境变量或配置文件中读取配置，并设置默认值
     */
    @Value("${NACOS_SERVER_ADDR:localhost:8848}")
    private String serverAddr;

    @Value("${NACOS_NAMESPACE:public}")
    private String namespace;

    @Value("${NACOS_USERNAME:nacos}")
    private String username;

    @Value("${NACOS_PASSWORD:nacos}")
    private String password;

    @Bean
    public ConfigService nacosConfigService() throws Exception {
        Properties properties = new Properties();
        properties.put(PropertyKeyConst.SERVER_ADDR, serverAddr);
        properties.put(PropertyKeyConst.NAMESPACE, namespace);
        properties.put(PropertyKeyConst.USERNAME, username);
        properties.put(PropertyKeyConst.PASSWORD, password);
        return ConfigFactory.createConfigService(properties);
    }

}
