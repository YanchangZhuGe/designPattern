package com.bgd.api.common.utils;

import com.alibaba.fastjson.JSON;
import org.apache.http.HttpEntity;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;

/**
 * 描述: Http请求工具类
 *
 * @author WuYanchang
 * @date 2022/1/11 15:11
 */

public class HttpRequstUtil {

    /**
     * http请求方法
     *
     * @param message        查询条件
     * @param url            查询地址
     * @param token          身份验证token
     * @param socketTimeout  socket 响应时间
     * @param connectTimeout 超时时间
     * @return 返回字符串
     */
    public static String queryResultToString(JSON message, String url, String token, int socketTimeout, int connectTimeout)
    {
        System.out.println("->开始http请求");
        System.out.println("请求参数>>>" + message.toString());
        System.out.println("请求链接>>>" + url);
        System.out.println("请求token>>>" + token);
        System.out.println("超时配置socketTimeout-connectTimeout>>>" + socketTimeout + "-" + connectTimeout);
        String result = "";

        // 转码 将发送的数据转为字符串实体
        StringEntity outEntity = new StringEntity(message.toString(), "UTF-8");
        outEntity.setContentType("application/json");
        System.out.println("请求数据转码>>>" + outEntity.toString());

        // 配置请求项
        RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(socketTimeout).setConnectTimeout(connectTimeout).build();
        System.out.println("请求配置项>>>" + requestConfig.toString());

        // 配置请求头
        HttpPost httpPost = new HttpPost(url);
        httpPost.addHeader("Content-Type", "application/json");
        httpPost.addHeader("Accept", "application/json");
        httpPost.addHeader("X-Aa-Token", token);
        httpPost.setEntity(outEntity);
        httpPost.setConfig(requestConfig);
        System.out.println("http请求信息>>>" + httpPost.toString());

        //执行一个http请求，传递HttpGet或HttpPost参数
        CloseableHttpClient httpclient = null;
        httpclient = HttpClients.createDefault();

        try
        {
            CloseableHttpResponse response = httpclient.execute(httpPost);

            //判断接口是否调用成功
            int statusCode = response.getStatusLine().getStatusCode();
            if (200 != statusCode)
            {
                System.out.println("连接失败");
            }
            else
            {
                System.out.println("发起请求->连接成功");
                HttpEntity entity = response.getEntity();
                result = EntityUtils.toString(entity, "UTF-8");

                //关闭资源
                EntityUtils.consume(entity);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        } finally
        {
            try
            {
                httpclient.close();
            } catch (IOException e)
            {
                e.printStackTrace();
            }
        }
        return result;
    }
}
