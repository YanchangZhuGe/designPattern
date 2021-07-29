package com.ops.designpattern.util;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.ops.designpattern.util.enums.OpenTypeEnum;
import com.ops.designpattern.util.vo.ArticleVO;
import org.apache.http.Consts;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClientBuilder;
import org.springframework.util.StringUtils;

import java.awt.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/16 13:45
 */

public class CSDN {

    /**
     * 打开IE浏览器访问页面
     */
    public void openIEBrowser(String type) throws IOException {
        JSONArray urlList = new JSONArray();

        //启用cmd运行IE的方式来打开网址。
        if (OpenTypeEnum.ARTICLE.getType().equals(type)) {
            int num = (int) (Math.random() * 5) + 1;
            for (int j = 0; j < num; j++) {
                int i = getI();
                String urlString = Comment.getArticleList().get(i).getUrl();
                urlList.add(urlString);

                openBrowser(urlString);
            }
        } else if (OpenTypeEnum.TITLE.getType().equals(type)) {
            for (int j = 0; j < 6; j++) {
                int i = getI();
                String title = Comment.getArticleList().get(i).getTitle();
                String urlString = "http://www.baidu.com/s?wd=诸葛延昌的博客-CSDN-" + title + "&usm=3&rsv_idx=2&rsv_page=1";
                urlString = urlString.replace(" ", "");
                urlList.add(urlString);

                openBrowser(urlString);
            }
        } else {
            urlList.add("空白页面");
        }

        saveLog(type + ": " + urlList.toString());
    }

    /**
     * 打开浏览器
     */
    public void openBrowser(String url) {
//  String str = "cmd /c start iexplore " + url;
        String str = "cmd /c start chrome " + url;
        try {
            Runtime.getRuntime().exec(str);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 关闭浏览器
     */
    public void closeIEBrowser() throws IOException {
//        Runtime.getRuntime().exec("taskkill /F /IM iexplorer.exe");
//        Runtime.getRuntime().exec("cmd /c taskkill /f /im iexplore.exe");
        Runtime.getRuntime().exec("cmd /c taskkill /f /im chrome.exe");
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

    /**
     * 仿浏览器
     */
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
        int length = Comment.getArticleList().size();
        int num = (int) (Math.random() * 100);
        if (num < length) {
            i = num;
        } else {
            i = num - length;
        }
        return i;
    }

    //取到内容 但阅读数不变
//    public static void main(String[] args) {
//        CSDN c = new CSDN();
//        String body = "";
//        String url = "https://blog.csdn.net/community/home-api/v1/get-business-list?page=1&size=200&businessType=blog&orderby=&noMore=false&username=qq_34462698";
//
//        HttpClient httpClient = HttpClientBuilder.create().build();
//        HttpGet httpGet = new HttpGet(url);
//        try{
//            HttpResponse httpResponse = httpClient.execute(httpGet);
//            HttpEntity httpEntity = httpResponse.getEntity();
////            body = EntityUtits.toString(httpEntity, Consts.UTF_8);
//            System.out.println(httpResponse);
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

    /**
     * 保存日志
     */
    public void saveLog(String text) throws IOException {

        SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String fileName = sdf.format(new Date());
        String path = Comment.getPath() + fileName + ".txt";
        File file = new File(path);
        //如果文件不存在，则自动生成文件；
        if (!file.exists()) {
            file.getParentFile().mkdirs();
            file.createNewFile();
        }

        String nextLine = System.getProperty("line.separator");
        String outS = sd.format(new Date()) + ": " + text;
        byte[] bytes = outS.getBytes("UTF-8");//因为中文可能会乱码，这里使用了转码，转成UTF-8

        OutputStream outPutStream = new FileOutputStream(file, true);
        outPutStream.write(nextLine.getBytes());
        outPutStream.write(bytes);
        outPutStream.write(nextLine.getBytes());
        outPutStream.close();//一定要关闭输出流；
    }

    public void getNewArticle() throws IOException {
        String url = "https://blog.csdn.net/community/home-api/v1/get-business-list?page=1&size=200&businessType=blog&orderby=&noMore=false&username=qq_34462698";
        //下载资源
        URL url1 = new URL(url);
        InputStream is = url1.openStream();
        BufferedReader br = new BufferedReader(new InputStreamReader(is, "utf-8"));
        StringBuffer allString = new StringBuffer();
        String msg = null;
        while (null != (msg = br.readLine())) {
            allString.append(msg);
        }
        br.close();

        if (StringUtils.hasText(allString.toString())) {
            String path = Comment.getPath() + "all.json";
            File file = new File(path);
            //如果文件不存在，则自动生成文件；
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }
            byte[] bytes = allString.toString().getBytes("UTF-8");//因为中文可能会乱码，这里使用了转码，转成UTF-8
            OutputStream outPutStream = new FileOutputStream(file);
            outPutStream.write(bytes);
            outPutStream.close();//一定要关闭输出流；
        }

    }

    public static void main(String[] args) {
        CSDN csdn = new CSDN();
        try {
            csdn.getNewArticle();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
