package com.bgd.api.common.propety;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.Properties;

/**
 * 描述: 个性定制配置参数类
 *
 * @author WuYanchang
 * @date 2022/1/12 10:41
 */
public class GxdzApiService {
    private final String filePath = "/config/gxdzApiService.properties";
    private final String time_out = "60000";
    private Map<String, Map> gd = new HashedMap();
    private Map zsSys = new HashedMap();
    private Map url = new HashedMap();
    private Map timeout = new HashedMap();

    public GxdzApiService() throws IOException
    {
        // 获取配置文件流
        InputStream resourceAsStream = this.getClass().getResourceAsStream(filePath);
        // 创建配置对象
        Properties properties = new Properties();
        // 加载文件映射
        properties.load(resourceAsStream);
        // 初始化变量
        this.zsSys.put("appId", properties.getProperty("gd.zsSys.appId"));
        this.zsSys.put("secret", properties.getProperty("gd.zsSys.secret"));
        this.zsSys.put("url", properties.getProperty("gd.zsSys.url"));

        this.url.put("Yhls", properties.getProperty("gd.url.Yhls"));

        String socket = properties.getProperty("gd.timeout.socket");
        String connect = properties.getProperty("gd.timeout.connect");
        String token = properties.getProperty("gd.timeout.token");

        this.timeout.put("socket", StringUtils.hasText(socket) ? socket : time_out);
        this.timeout.put("connect", StringUtils.hasText(connect) ? connect : time_out);
        this.timeout.put("token", StringUtils.hasText(token) ? token : "600000");

        this.gd.put("zsSys", this.zsSys);
        this.gd.put("url", this.url);
        this.gd.put("timeout", this.timeout);
    }

    public Map getGd()
    {
        return gd;
    }
}
