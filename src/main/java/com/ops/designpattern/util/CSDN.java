package com.ops.designpattern.util;

import java.awt.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/16 13:45
 */

public class CSDN {
    private String[] url = {"https://blog.csdn.net/qq_34462698/article/details/116998715",
            "https://blog.csdn.net/qq_34462698/article/details/118786141",
            "https://blog.csdn.net/qq_34462698/article/details/118702237",
            "https://blog.csdn.net/qq_34462698/article/details/118610560",
            "https://blog.csdn.net/qq_34462698/article/details/118385548",
            "https://blog.csdn.net/qq_34462698/article/details/118380917",
            "https://blog.csdn.net/qq_34462698/article/details/118001111",
            "https://blog.csdn.net/qq_34462698/article/details/115326129",
            "https://blog.csdn.net/qq_34462698/article/details/117697413",
            "https://blog.csdn.net/qq_34462698/article/details/117927083",
            "https://blog.csdn.net/qq_34462698/article/details/117807038",
            "https://blog.csdn.net/qq_34462698/article/details/117790170",
            "https://blog.csdn.net/qq_34462698/article/details/115380647",
            "https://blog.csdn.net/qq_34462698/article/details/117287184",
            "https://blog.csdn.net/qq_34462698/article/details/117287720",
            "https://blog.csdn.net/qq_34462698/article/details/117287360",
            "https://blog.csdn.net/qq_34462698/article/details/117023633",
            "https://blog.csdn.net/qq_34462698/article/details/116942493",
            "https://blog.csdn.net/qq_34462698/article/details/115373466",
            "https://blog.csdn.net/qq_34462698/article/details/114627023",
            "https://blog.csdn.net/qq_34462698/article/details/114605352",
            "https://blog.csdn.net/qq_34462698/article/details/114551323",
            "https://blog.csdn.net/qq_34462698/article/details/114549461",
            "https://blog.csdn.net/qq_34462698/article/details/114501771",
            "https://blog.csdn.net/qq_34462698/article/details/114380346",
            "https://blog.csdn.net/qq_34462698/article/details/114371034",
            "https://blog.csdn.net/qq_34462698/article/details/114341518",
            "https://blog.csdn.net/qq_34462698/article/details/113768189",
            "https://blog.csdn.net/qq_34462698/article/details/113732430",
            "https://blog.csdn.net/qq_34462698/article/details/113614668",
            "https://blog.csdn.net/qq_34462698/article/details/113130100",
            "https://blog.csdn.net/qq_34462698/article/details/113116090",
            "https://blog.csdn.net/qq_34462698/article/details/113126160",
            "https://blog.csdn.net/qq_34462698/article/details/113125318",
            "https://blog.csdn.net/qq_34462698/article/details/113124796",
            "https://blog.csdn.net/qq_34462698/article/details/112763607",
            "https://blog.csdn.net/qq_34462698/article/details/112505565",
            "https://blog.csdn.net/qq_34462698/article/details/112363527",
            "https://blog.csdn.net/qq_34462698/article/details/112171009",
            "https://blog.csdn.net/qq_34462698/article/details/111830547",
            "https://blog.csdn.net/qq_34462698/article/details/111273921",
            "https://blog.csdn.net/qq_34462698/article/details/111246277",
            "https://blog.csdn.net/qq_34462698/article/details/111151486",
            "https://blog.csdn.net/qq_34462698/article/details/111149908",
            "https://blog.csdn.net/qq_34462698/article/details/111034347",
            "https://blog.csdn.net/qq_34462698/article/details/111031606",
            "https://blog.csdn.net/qq_34462698/article/details/111025878",
            "https://blog.csdn.net/qq_34462698/article/details/111020556",
            "https://blog.csdn.net/qq_34462698/article/details/111013760",
            "https://blog.csdn.net/qq_34462698/article/details/111010152",
            "https://blog.csdn.net/qq_34462698/article/details/110943514",
            "https://blog.csdn.net/qq_34462698/article/details/110917215",
            "https://blog.csdn.net/qq_34462698/article/details/110911337",
            "https://blog.csdn.net/qq_34462698/article/details/110905121",
            "https://blog.csdn.net/qq_34462698/article/details/110877575",
            "https://blog.csdn.net/qq_34462698/article/details/110045614",
            "https://blog.csdn.net/qq_34462698/article/details/108614556",
            "https://blog.csdn.net/qq_34462698/article/details/108601700",
            "https://blog.csdn.net/qq_34462698/article/details/108601577",
            "https://blog.csdn.net/qq_34462698/article/details/108601560",
            "https://blog.csdn.net/qq_34462698/article/details/108397521",
            "https://blog.csdn.net/qq_34462698/article/details/108397242",
            "https://blog.csdn.net/qq_34462698/article/details/108397203",
            "https://blog.csdn.net/qq_34462698/article/details/108387574",
            "https://blog.csdn.net/qq_34462698/article/details/102909067"};

    /**
     * 打开IE浏览器访问页面
     */
    public void openIEBrowser() throws IOException {
        //启用cmd运行IE的方式来打开网址。
        int num = (int) (Math.random() * 5) + 1;
        for (int j = 0; j < num; j++) {
            int i = getI();

            String str = "cmd /c start iexplore " + url[i];

            Runtime.getRuntime().exec(str);
        }
    }

    public void closeIEBrowser() throws IOException {
//        Runtime.getRuntime().exec("taskkill /F /IM iexplorer.exe");
        Runtime.getRuntime().exec("cmd /c taskkill /f /im iexplore.exe");
    }


    /**
     * 打开默认浏览器访问页面
     */
    public void openDefaultBrowser(String url) throws IOException, InterruptedException {
        //启用系统默认浏览器来打开网址。
        int i = getI();
        try {
            URI uri = new URI(url);
            Desktop.getDesktop().browse(uri);
        } catch (URISyntaxException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

//        Thread.sleep(10000);
//        Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");

        //Runtime.getRuntime().exec("taskkill /F /IM iexplorer.exe");
        //Runtime.getRuntime().exec("taskkill /F /IM firefox.exe");
        //Runtime.getRuntime().exec("taskkill /F /IM safari.exe");
        //Runtime.getRuntime().exec("taskkill /F /IM opera.exe");

    }

    public void openHttp() throws IOException {
        HttpURLConnection conn = null;
        String url = "http://www.baidu.com";
        URL realUrl = new URL(url);
        conn = (HttpURLConnection) realUrl.openConnection();
        conn.setRequestMethod("POST");
        conn.setUseCaches(false);
        conn.setReadTimeout(8000);
        conn.setConnectTimeout(8000);
        conn.setInstanceFollowRedirects(false);
        conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; WOW64; rv:46.0) Gecko/20100101 Firefox/46.0");
        int code = conn.getResponseCode();
        if (code == 200) {
            InputStream is = conn.getInputStream();
            BufferedReader in = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            StringBuffer buffer = new StringBuffer();
            String line = "";
            while ((line = in.readLine()) != null) {
                buffer.append(line);
            }
            String result = buffer.toString();
            //subscriber是观察者，在本代码中可以理解成发送数据给activity
            System.out.println(result);
        }

    }

    /**
     * 获取随机数
     */
    public int getI() {
        int i = 0;
        int length = url.length;
        int num = (int) (Math.random() * 100);
        if (num < length) {
            i = num;
        } else {
            i = num - length;
        }
        return i;
    }

    public static void main(String[] args) {
        CSDN c = new CSDN();
        try {
            c.openDefaultBrowser("https://blog.csdn.net/qq_34462698/article/details/108601560");
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    //取到内容 但阅读数不变
//    public static void main(String[] args) {
//        CSDN c = new CSDN();
//        String body = "";
//        HttpClient httpClient = HttpClientBuilder.create().build();
//        HttpGet httpGet = new HttpGet("https://blog.csdn.net/qq_34462698/article/details/108601560");
//        try{
//            HttpResponse httpResponse = httpClient.execute(httpGet);
//            //HttpEntity httpEntity = httpResponse.getEntity();
//            //body = EntityUtits.toString(httpEntity, Consts.UTF_8);
//            System.out.println(httpClient);
//            //释放连接
//            httpGet.releaseConnection();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }


//    public static void main(String[] args) throws IOException {
//        //获取url
//        URL url = new URL("https://blog.csdn.net/qq_34462698/article/details/102909067");
//        //下载资源
//        InputStream is = url.openStream();
//        BufferedReader br = new BufferedReader(new InputStreamReader(is,"utf-8"));
//        String msg = null;
//        while (null != (msg = br.readLine())){
//            System.out.println(msg);
//        }
//        br.close();
//    }
}
