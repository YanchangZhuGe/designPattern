package com.ops.designpattern.task;

import com.ops.designpattern.util.CSDN;
import com.ops.designpattern.util.enums.OpenTypeEnum;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import java.io.IOException;
import java.time.LocalDateTime;

@Configuration      //1.主要用于标记配置类，兼备Component的效果。
@EnableScheduling   // 2.开启定时任务
public class SaticScheduleTask {
    CSDN csdn = new CSDN();

    @Scheduled(cron = "02 * * * * ?")
    private void open() {

        System.err.println("打开: " + LocalDateTime.now());
        try {
            csdn.openIEBrowser(OpenTypeEnum.ARTICLE.getType());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "20 * * * * ?")
    private void close() {

        System.err.println("关闭: " + LocalDateTime.now());
        try {
            csdn.closeIEBrowser();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "22 * * * * ?")
    private void open2() {

        System.err.println("打开: " + LocalDateTime.now());
        try {
            csdn.openIEBrowser(OpenTypeEnum.ARTICLE.getType());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "40 * * * * ?")
    private void close2() {

        System.err.println("关闭: " + LocalDateTime.now());
        try {
            csdn.closeIEBrowser();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "42 * * * * ?")
    private void open3() {

        System.err.println("打开: " + LocalDateTime.now());
        try {
            csdn.openIEBrowser(OpenTypeEnum.ARTICLE.getType());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "59 * * * * ?")
    private void close3() {

        System.err.println("关闭: " + LocalDateTime.now());
        try {
            csdn.closeIEBrowser();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //    @Scheduled(cron = "0/5 * * * * ?")
    public void soutLog() {
        System.out.println(LocalDateTime.now());
        try {
            csdn.saveLog("cwshi");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}