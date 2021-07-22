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

    @Scheduled(cron = "45 * * * * ?")
    private void open() {

        System.err.println("打开: " + LocalDateTime.now());
        try {
            csdn.openIEBrowser(OpenTypeEnum.ARTICLE.getType());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "55 * * * * ?")
    private void close() {

        System.err.println("关闭: " + LocalDateTime.now());
        try {
            csdn.closeIEBrowser();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "5 * * * * ?")
    private void open5() {

        try {
            csdn.openIEBrowser(OpenTypeEnum.TITLE.getType());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "12 * * * * ?")
    private void close12() {

        System.err.println("关闭: " + LocalDateTime.now());
        try {
            csdn.closeIEBrowser();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "15 * * * * ?")
    private void open15() {

        try {
            csdn.openIEBrowser(OpenTypeEnum.TITLE.getType());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "22 * * * * ?")
    private void close22() {

        System.err.println("关闭: " + LocalDateTime.now());
        try {
            csdn.closeIEBrowser();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "25 * * * * ?")
    private void open25() {

        try {
            csdn.openIEBrowser(OpenTypeEnum.TITLE.getType());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "32 * * * * ?")
    private void close32() {

        System.err.println("关闭: " + LocalDateTime.now());
        try {
            csdn.closeIEBrowser();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "35 * * * * ?")
    private void open35() {

        try {
            csdn.openIEBrowser(OpenTypeEnum.TITLE.getType());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "42 * * * * ?")
    private void close42() {

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