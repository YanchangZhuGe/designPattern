package com.ops.designpattern.util;

import com.alibaba.fastjson.JSONArray;

import java.awt.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/16 13:45
 */

public class CSDN {
    private String urlHead = "https://blog.csdn.net/qq_34462698/article/details/";

    private String[] url = {
            "116998715", "118786141", "118702237", "118610560", "118385548", "118380917", "118001111", "115326129",
            "117697413", "117927083", "117807038", "117790170", "115380647", "117287184", "117287720", "117287360",
            "117023633", "116942493", "115373466", "114627023", "114605352", "114551323", "114549461", "114501771",
            "114380346", "114371034", "114341518", "113768189", "113732430", "113614668", "113130100", "113116090",
            "113126160", "113125318", "113124796", "112763607", "112505565", "112363527", "112171009", "111830547",
            "111273921", "111246277", "111151486", "111149908", "111034347", "111031606", "111025878", "111020556",
            "111013760", "111010152", "110943514", "110917215", "110911337", "110905121", "110877575", "110045614",
            "108614556", "108601700", "108601577", "108601560", "108397521", "108397242", "108397203", "108387574",
            "102909067"};

    /**
     * 打开IE浏览器访问页面
     */
    public void openIEBrowser() throws IOException {
        JSONArray urlList = new JSONArray();

        //启用cmd运行IE的方式来打开网址。
        int num = (int) (Math.random() * 5) + 1;
        for (int j = 0; j < num; j++) {
            int i = getI();
            String urlString = urlHead + url[i];
            urlList.add(url[i]);

            String str = "cmd /c start iexplore " + urlString;
            Runtime.getRuntime().exec(str);
        }

        saveLog(urlList.toString());
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
    public void saveLog(String text) throws IOException {

        SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String fileName = sdf.format(new Date());

        StringBuffer path = new StringBuffer();
        path.append("C:" + File.separator);
        path.append("Users" + File.separator);
        path.append("admin" + File.separator);
        path.append("Desktop" + File.separator);
        path.append("java" + File.separator);
        path.append(fileName + ".txt");

        File file = new File(path.toString());
//        File file = new File("D:" + File.separator + fileName + ".txt");
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
}
