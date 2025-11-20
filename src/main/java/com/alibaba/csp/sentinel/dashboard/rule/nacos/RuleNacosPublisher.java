package com.alibaba.csp.sentinel.dashboard.rule.nacos;

import com.alibaba.nacos.api.config.ConfigService;
import com.alibaba.nacos.api.exception.NacosException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author gdLiu
 * @date 2025/11/18 18:22
 */
@Component
public class RuleNacosPublisher {
    @Autowired
    private ConfigService configService;

    public void publish(String dataId, String rules) {
        try {
            if (rules == null) {
                return;
            }
            configService.publishConfig(dataId, NacosConfigUtil.GROUP_ID, rules);
        } catch (NacosException e) {
            throw new RuntimeException(e);
        }
    }

}
