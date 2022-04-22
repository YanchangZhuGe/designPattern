package com.bgd.api.jcyh;

import com.bgd.api.common.exceptions.ApiException;
import com.bgd.api.common.security.arithmetic.EncDecUtils;
import com.bgd.api.common.utils.JSONUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.http.HttpEntity;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.UUID;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/5 16:14
 */

class Test {
    public static void main(String[] args) {
        System.out.println("监测银行接口测试");
        JSONObject message = new JSONObject();
        JSONObject head = new JSONObject();
        JSONArray data = new JSONArray();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        SimpleDateFormat lopDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        head.put("TIMESTAMP", sdf.format(new Date()));

        Test.yhzh(head); // 银行账户信息
//        Test.zhqr(head, data, lopDate); // 银行账户信息确认
//        Test.zjsz(head, data, lopDate); // 资金收支信息
//        Test.wgyd(head, data, lopDate); // 违规疑点信息

        try {
            String encDataStr = EncDecUtils.getEncString("test", "AES", data.toString());
            message.put("HEAD", head);
            message.put("DATA", encDataStr);
        } catch (Exception e) {
            e.printStackTrace();
        }
        //请求url
        String url = "http://192.168.1.192:8080/api/v1/jcyh/receiveService";
//        String url = "http://192.168.2.112:8014/api/v1/jcyh/receiveService";
//        String url = "http://192.168.232.130:8080/api/v1/jcyh/receiveService";
//        String url = "http://192.168.232.133:8080/api/v1/jcyh/apiTest";
        //配置超时
        RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(60000).setConnectTimeout(60000).build();
        HttpPost httpPost = new HttpPost(url);
        httpPost.addHeader("Content-Type", "application/json");
        httpPost.addHeader("Accept", "application/json");
        //将发送的数据转为字符串实体
        StringEntity outEntity = new StringEntity(message.toString(), "UTF-8");
        outEntity.setContentType("application/json");
        httpPost.setEntity(outEntity);
        httpPost.setConfig(requestConfig);
        //执行一个http请求，传递HttpGet或HttpPost参数
        CloseableHttpClient httpclient = null;
        httpclient = HttpClients.createDefault();
        JSONObject responseMessage;
        try {
            CloseableHttpResponse response = httpclient.execute(httpPost);
            //判断接口是否调用成功
            int statusCode = response.getStatusLine().getStatusCode();
            if (200 != statusCode) {
                System.out.println("连接失败");
            } else {
                System.out.println("连接成功");
                HttpEntity entity = response.getEntity();
                responseMessage = JSONObject.fromObject(EntityUtils.toString(entity, "UTF-8"));
                //报文解密
                if (JSONUtil.containsKey(responseMessage, "DATA")) {
                    try {
                        String dataJson = JSONUtil.getString(responseMessage, "DATA");
                        // debt_t_api_access_user ENC_SF/ENC_KEY
                        String decData = EncDecUtils.getDecString("test", "AES", dataJson);
                        JSONUtil.updateIfExists(responseMessage, "DATA", decData);

                        System.out.println(responseMessage.toString());
                    } catch (Exception e) {
                        throw new ApiException("报文解密失败！", e);
                    }
                }
                //关闭资源
                EntityUtils.consume(entity);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                httpclient.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }

    public static void yhzh(JSONObject head) {
        head.put("GUID", "205A382D92057E523E11D62440FFE205");
        head.put("XCH_CODE", "1001"); //报文编码-区分业务类型
        head.put("USER_CODE", "wuyc");
        head.put("PSD", "000000");

//        head.put("SRC", "2");
//        head.put("AD_CODE", "13");
//        head.put("USERNAME", "wuyc");
//        head.put("EXP_TYPE", "1");
//        head.put("PAGE", "1");
//        head.put("TPAGE", "2");
//        head.put("ROWCOUNT", "200");
    }

    public static void zhqr(JSONObject head, JSONArray data, SimpleDateFormat lopDate) {
        String[] col = {"YHZH_ID", "MOF_DIV_CODE", "MOF_DIV_NAME", "AGENCY_ID", "XM_ID","tile", "ACC_NAME", "ACC_NO", "WRO_CODE", "CHECK_RES_REMARK"};

        head.put("GUID", UUID.randomUUID().toString().replace("-", ""));
        head.put("XCH_CODE", "1004"); //报文编码-区分业务类型
        head.put("USER_CODE", "wuyc");
        head.put("PSD", "000000");

        for (int i = 0; i < 10; i++) {
            JSONObject dataMap = new JSONObject();
            dataMap.put("DATA_ID", UUID.randomUUID().toString().replace("-", ""));
            dataMap.put("CHECK_RES", new Integer(1));
            dataMap.put("CREATE_TIME", lopDate.format(new Date()));
            dataMap.put("UPDATE_TIME", lopDate.format(new Date()));
            dataMap.put("IS_DELETED", new Integer(2));
            dataMap.put("IS_SYNC", new Integer(0));

            for (String s : col) {
                dataMap.put(s, (int) (Math.random() * 100));
            }
            data.add(dataMap);
        }
    }

    public static void zjsz(JSONObject head, JSONArray data, SimpleDateFormat lopDate) {
        String[] col = {"RECORD_DETAIL_ID", "RECORD_YEAR", "RECORD_CODE", "REFNBR", "ACC_NO", "ACC_NAME", "ACC_BANK_CODE", "ACC_BANK_NAME", "BKHB", "BKHB_NAME", "ETYDAT", "CCYNBR", "RPYACC", "RPYNAM", "RPYBBN", "EXPTYPE", "NUSAGE", "REMARK", "PSTSCP"};

        head.put("GUID", UUID.randomUUID().toString().replace("-", ""));
        head.put("XCH_CODE", "1002"); //报文编码-区分业务类型
        head.put("USER_CODE", "wuyc");
        head.put("PSD", "000000");

        for (int i = 0; i < 10; i++) {
            JSONObject dataMap = new JSONObject();
            dataMap.put("DATA_ID", UUID.randomUUID().toString().replace("-", ""));
            dataMap.put("TSDAMT", new Double(1100));
            dataMap.put("CREATE_TIME", lopDate.format(new Date()));
            dataMap.put("UPDATE_TIME", lopDate.format(new Date()));
            dataMap.put("IS_DELETED", new Integer(2));
            dataMap.put("IS_SYNC", new Integer(0));

            for (String s : col) {
                dataMap.put(s, (int) (Math.random() * 100));
            }
            data.add(dataMap);
        }
    }

    public static void wgyd(JSONObject head, JSONArray data, SimpleDateFormat lopDate) {
        // 生成随机数的列
        String[] col = {"ACC_NO", "VIOLATIONS_ID", "VIOLATIONS_TYPE", "VIOLATIONS_LEVEL", "VIOLATIONS_DESC", "VIOLATIONS_STATUS", "VIOLATIONS_HANDLE_DATE", "VIOLATIONS_HANDLE_OPINION", "VIOLATIONS_HANDLE_USER"};

        head.put("GUID", UUID.randomUUID().toString().replace("-", ""));
        head.put("XCH_CODE", "1003"); //报文编码-区分业务类型
        head.put("USER_CODE", "wuyc");
        head.put("PSD", "000000");

        for (int i = 0; i < 10; i++) {
            JSONObject dataMap = new JSONObject();
            dataMap.put("DATA_ID", UUID.randomUUID().toString().replace("-", ""));
            dataMap.put("CREATE_TIME", lopDate.format(new Date()));
            dataMap.put("UPDATE_TIME", lopDate.format(new Date()));
            dataMap.put("IS_DELETED", new Integer(2));
            dataMap.put("IS_SYNC", new Integer(0));

            for (String s : col) {
                dataMap.put(s, (int) (Math.random() * 100));
            }
            data.add(dataMap);
        }
    }
}

class a {
    public static void main(String[] args)  throws Exception {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cd= Calendar.getInstance();//获取一个Calendar对象
        Calendar cd1= Calendar.getInstance();//获取一个Calendar对象

        String start = "2021-07-07";
        Date parse = null;
        Date now = new Date();
        now.setHours(0);
        now.setMinutes(0);
        now.setSeconds(0);
        cd1.setTime(now);//设置calendar日期
        Integer sum = new Integer(0);
        String shms = "1 +1 +0 ";
        String[] split = shms.trim().split("\\+");
        for (String s : split) {
            String trim = s.trim();
            sum += Integer.valueOf(trim);
            cd.setTime(sdf.parse(start));//设置calendar日期
            cd.add(Calendar.YEAR,sum);//增加n年

            long l = (cd.getTimeInMillis() - cd1.getTimeInMillis()) / (24*3600*1000);
            System.out.println(l);


        }
    }
}
