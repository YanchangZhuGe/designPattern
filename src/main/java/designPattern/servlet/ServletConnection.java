package designPattern.servlet;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * 描述: 测试servlet接口
 *
 * @author WuYanchang
 * @date 2021/5/14 14:38
 */

public class ServletConnection {
    public static void main(String[] args) {
        HttpURLConnection servletConnection = null;
        URL uploadServlet = null;

        try {
            uploadServlet = new URL("http://192.168.1.192:8082/SjsbStatusHttpServlet");
            servletConnection = (HttpURLConnection)uploadServlet.openConnection();
            servletConnection.setConnectTimeout(10000);
            servletConnection.setReadTimeout(10000);
            servletConnection.setRequestMethod("POST");
            servletConnection.setDoOutput(true);
            servletConnection.setDoInput(true);
            servletConnection.setAllowUserInteraction(true);

            OutputStream output = servletConnection.getOutputStream();
//            encode = this.util.buildStatusRequestXML(ipConfigMap);
//            String zipStr = this.util.zip(encode);
//            output.write(zipStr.getBytes("GBK"));
            output.flush();
            output.close();
//            responseCode = servletConnection.getResponseCode();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
