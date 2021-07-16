package com.ops.designpattern.util;

import java.awt.*;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/16 13:42
 */

public class Gotourl {
    /**
     * ip地址保存在数组中,每个数组保存10个ip地址，防止连接过多。
     */
    static String[] ip1 = {"http://blog.csdn.net/dove_knowledge/article/details/70992852",
            "http://blog.csdn.net/dove_knowledge/article/details/70948557",
            "http://blog.csdn.net/dove_knowledge/article/details/53729291",
            "http://blog.csdn.net/dove_knowledge/article/details/71077028",
            "http://blog.csdn.net/dove_knowledge/article/details/71056479",
            "http://blog.csdn.net/dove_knowledge/article/details/71006028",
            "http://blog.csdn.net/dove_knowledge/article/details/70049187",
            "http://blog.csdn.net/dove_knowledge/article/details/69661085",
            "http://blog.csdn.net/dove_knowledge/article/details/69660717",
            "http://blog.csdn.net/dove_knowledge/article/details/65627869"};
    static String[] ip2 = {"http://blog.csdn.net/dove_knowledge/article/details/53339813",
            "http://blog.csdn.net/dove_knowledge/article/details/53318095",
            "http://blog.csdn.net/dove_knowledge/article/details/53149590",
            "http://blog.csdn.net/dove_knowledge/article/details/53149490",
            "http://blog.csdn.net/dove_knowledge/article/details/53149440",
            "http://blog.csdn.net/dove_knowledge/article/details/53354491",
            "http://blog.csdn.net/dove_knowledge/article/details/71439702",
            "http://blog.csdn.net/dove_knowledge/article/details/71434960",
            "http://blog.csdn.net/dove_knowledge/article/details/71425108",
            "http://blog.csdn.net/dove_knowledge/article/details/71424507"};
    static String[] ip3 = {"http://blog.csdn.net/dove_knowledge/article/details/71171471",
            "http://blog.csdn.net/dove_knowledge/article/details/71158686",
            "http://blog.csdn.net/dove_knowledge/article/details/71156269",
            "http://blog.csdn.net/dove_knowledge/article/details/71082704",
            "http://blog.csdn.net/dove_knowledge/article/details/71077512",
            "http://blog.csdn.net/dove_knowledge/article/details/71077034",
            "http://blog.csdn.net/dove_knowledge/article/details/71050893",
            "http://blog.csdn.net/dove_knowledge/article/details/71050198",
            "http://blog.csdn.net/dove_knowledge/article/details/71038511",
            "http://blog.csdn.net/dove_knowledge/article/details/71036057"};
    static String[] ip4 = {"http://blog.csdn.net/dove_knowledge/article/details/71027170",
            "http://blog.csdn.net/dove_knowledge/article/details/71023512",
            "http://blog.csdn.net/dove_knowledge/article/details/71023324",
            "http://blog.csdn.net/dove_knowledge/article/details/71006081",
            "http://blog.csdn.net/dove_knowledge/article/details/71006053",
            "http://blog.csdn.net/dove_knowledge/article/details/70947241",
            "http://blog.csdn.net/dove_knowledge/article/details/70947158",
            "http://blog.csdn.net/dove_knowledge/article/details/70946015",
            "http://blog.csdn.net/dove_knowledge/article/details/70945911",
            "http://blog.csdn.net/dove_knowledge/article/details/70194788"};
    static String[] ip5 = {"http://blog.csdn.net/dove_knowledge/article/details/69715913",
            "http://blog.csdn.net/dove_knowledge/article/details/67632784",
            "http://blog.csdn.net/dove_knowledge/article/details/61615235",
            "http://blog.csdn.net/dove_knowledge/article/details/53410482",
            "http://blog.csdn.net/dove_knowledge/article/details/53285810",
            "http://blog.csdn.net/dove_knowledge/article/details/53264119",
            "http://blog.csdn.net/dove_knowledge/article/details/53167930",
            "http://blog.csdn.net/dove_knowledge/article/details/53167888",
            "http://blog.csdn.net/dove_knowledge/article/details/52334056",
            "http://blog.csdn.net/dove_knowledge/article/details/53493501"};
    static String[] ip6 = {"http://blog.csdn.net/dove_knowledge/article/details/53167801",
            "http://blog.csdn.net/dove_knowledge/article/details/53156660",
            "http://blog.csdn.net/dove_knowledge/article/details/53156601",
            "http://blog.csdn.net/dove_knowledge/article/details/53156549",
            "http://blog.csdn.net/dove_knowledge/article/details/60464369",
            "http://blog.csdn.net/dove_knowledge/article/details/64906439",
            "http://blog.csdn.net/dove_knowledge/article/details/64906423",
            "http://blog.csdn.net/dove_knowledge/article/details/64906405",
            "http://blog.csdn.net/dove_knowledge/article/details/64906374",
            "http://blog.csdn.net/dove_knowledge/article/details/64906337"};
    static String[] ip7 = {"http://blog.csdn.net/dove_knowledge/article/details/64906312",
            "http://blog.csdn.net/dove_knowledge/article/details/64906287",
            "http://blog.csdn.net/dove_knowledge/article/details/64906202",
            "http://blog.csdn.net/dove_knowledge/article/details/64439340",
            "http://blog.csdn.net/dove_knowledge/article/details/64439257",
            "http://blog.csdn.net/dove_knowledge/article/details/64439235",
            "http://blog.csdn.net/dove_knowledge/article/details/64439235",
            "http://blog.csdn.net/dove_knowledge/article/details/64439218",
            "http://blog.csdn.net/dove_knowledge/article/details/64439200",
            "http://blog.csdn.net/dove_knowledge/article/details/64439184"};
    static String[] ip8 = {"http://blog.csdn.net/dove_knowledge/article/details/64439164",
            "http://blog.csdn.net/dove_knowledge/article/details/64439125",
            "http://blog.csdn.net/dove_knowledge/article/details/70321632",
            "http://blog.csdn.net/dove_knowledge/article/details/70316575",
            "http://blog.csdn.net/dove_knowledge/article/details/70308434",
            "http://blog.csdn.net/dove_knowledge/article/details/70269998",
            "http://blog.csdn.net/dove_knowledge/article/details/70255531",
            "http://blog.csdn.net/dove_knowledge/article/details/70255161",
            "http://blog.csdn.net/dove_knowledge/article/details/70254805",
            "http://blog.csdn.net/dove_knowledge/article/details/70237667"};
    static String[] ip9 = {"http://blog.csdn.net/dove_knowledge/article/details/70237442",
            "http://blog.csdn.net/dove_knowledge/article/details/70237151",
            "http://blog.csdn.net/dove_knowledge/article/details/70236946",
            "http://blog.csdn.net/dove_knowledge/article/details/70230431",
            "http://blog.csdn.net/dove_knowledge/article/details/70229659",
            "http://blog.csdn.net/dove_knowledge/article/details/70229527",
            "http://blog.csdn.net/dove_knowledge/article/details/58066964",
            "http://blog.csdn.net/dove_knowledge/article/details/70994875",
            "http://blog.csdn.net/dove_knowledge/article/details/70947139",
            "http://blog.csdn.net/dove_knowledge/article/details/70946058"};
    static String[] ip10 = {"http://blog.csdn.net/dove_knowledge/article/details/66968383",
            "http://blog.csdn.net/dove_knowledge/article/details/53304544",
            "http://blog.csdn.net/dove_knowledge/article/details/70194748",
            "http://blog.csdn.net/dove_knowledge/article/details/70048438",
            "http://blog.csdn.net/dove_knowledge/article/details/71056435",
            "http://blog.csdn.net/dove_knowledge/article/details/71053900",
            "http://blog.csdn.net/dove_knowledge/article/details/71053385",
            "http://blog.csdn.net/dove_knowledge/article/details/71053156",
            "http://blog.csdn.net/dove_knowledge/article/details/71052988",
            "http://blog.csdn.net/dove_knowledge/article/details/71052170"};
    static String[] ip11 = {"http://blog.csdn.net/dove_knowledge/article/details/71271518",
            "http://blog.csdn.net/dove_knowledge/article/details/71270921",
            "http://blog.csdn.net/dove_knowledge/article/details/71248789",
            "http://blog.csdn.net/dove_knowledge/article/details/71235772",
            "http://blog.csdn.net/dove_knowledge/article/details/71211808",
            "http://blog.csdn.net/dove_knowledge/article/details/71077020",
            "http://blog.csdn.net/dove_knowledge/article/details/70224939",
            "http://blog.csdn.net/dove_knowledge/article/details/70196360",
            "http://blog.csdn.net/dove_knowledge/article/details/70195808",
            "http://blog.csdn.net/dove_knowledge/article/details/70170289"};
    static String[] ip12 = {"http://blog.csdn.net/dove_knowledge/article/details/70169823",//spring31
            "http://blog.csdn.net/dove_knowledge/article/details/70162030",
            "http://blog.csdn.net/dove_knowledge/article/details/70161776",
            "http://blog.csdn.net/dove_knowledge/article/details/70161741",
            "http://blog.csdn.net/dove_knowledge/article/details/70161230",
            "http://blog.csdn.net/dove_knowledge/article/details/70160879",
            "http://blog.csdn.net/dove_knowledge/article/details/70160663",
            "http://blog.csdn.net/dove_knowledge/article/details/70159305",
            "http://blog.csdn.net/dove_knowledge/article/details/70158909",
            "http://blog.csdn.net/dove_knowledge/article/details/70158045"};//spring22
    static String[] ip13 = {"http://blog.csdn.net/dove_knowledge/article/details/70156926",
            "http://blog.csdn.net/dove_knowledge/article/details/70140239",
            "http://blog.csdn.net/dove_knowledge/article/details/70053881",
            "http://blog.csdn.net/dove_knowledge/article/details/70052647",
            "http://blog.csdn.net/dove_knowledge/article/details/68924003",
            "http://blog.csdn.net/dove_knowledge/article/details/68923091",
            "http://blog.csdn.net/dove_knowledge/article/details/68922660",
            "http://blog.csdn.net/dove_knowledge/article/details/68921925",
            "http://blog.csdn.net/dove_knowledge/article/details/68490401",
            "http://blog.csdn.net/dove_knowledge/article/details/68488231"};
    static String[] ip14 = {"http://blog.csdn.net/dove_knowledge/article/details/68488031",
            "http://blog.csdn.net/dove_knowledge/article/details/68065366",
            "http://blog.csdn.net/dove_knowledge/article/details/68063796",
            "http://blog.csdn.net/dove_knowledge/article/details/66969340",
            "http://blog.csdn.net/dove_knowledge/article/details/66968533",
            "http://blog.csdn.net/dove_knowledge/article/details/66478396",
            "http://blog.csdn.net/dove_knowledge/article/details/66478273",
            "http://blog.csdn.net/dove_knowledge/article/details/66476647",
            "http://blog.csdn.net/dove_knowledge/article/details/66476490",
            "http://blog.csdn.net/dove_knowledge/article/details/66472765"};
    static String[] ip15 = {"http://blog.csdn.net/dove_knowledge/article/details/66472668"};

    /**
     * 打开IE浏览器访问页面
     */
    public static void openIEBrowser() throws IOException {
        //启用cmd运行IE的方式来打开网址。
        for (int i = 1; i < 10; i++) {
            String str = "cmd /c start iexplore " + ip1[i];
            try {
                Runtime.getRuntime().exec(str);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 打开默认浏览器访问页面
     *
     * @throws IOException
     * @throws InterruptedException
     */
    public static void openDefaultBrowser() throws IOException, InterruptedException {

        //启用系统默认浏览器来打开网址。
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip1[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip2[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip3[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip4[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip5[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip6[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip7[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip8[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip9[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip10[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip11[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip12[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 10; i++) {
            try {
                URI uri = new URI(ip13[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
        for (int i = 0; i < 1; i++) {
            try {
                URI uri = new URI(ip14[i]);
                Desktop.getDesktop().browse(uri);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if (i == 9) {
                Thread.sleep(10000);
                Runtime.getRuntime().exec("taskkill /F /IM chrome.exe");
            }
        }
    }

    public static void main(String[] args) throws IOException, InterruptedException {
//        openIEBrowser();
        for (int i = 0; i < 20; i++) {
            openDefaultBrowser();
        }
    }
}
