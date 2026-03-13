package com.alibaba.csp.sentinel.dashboard.rule.nacos;


import com.alibaba.nacos.api.config.ConfigService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @author gdLiu
 * @date 2026/3/12 14:37
 */
@Component
public class RuleNacosProvider {

    @Autowired
    private ConfigService configService;

    public String getRules(String dataId) throws Exception {
        // 将服务名称设置为GroupId
        return configService.getConfig(dataId, NacosConfigUtil.GROUP_ID, 3000);
    }
}
