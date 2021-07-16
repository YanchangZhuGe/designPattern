package com.ops.designpattern.task;

import com.ops.designpattern.util.CSDN;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import java.io.IOException;
import java.time.LocalDateTime;

@Configuration      //1.主要用于标记配置类，兼备Component的效果。
@EnableScheduling   // 2.开启定时任务
public class SaticScheduleTask {
    CSDN csdn = new CSDN();

    @Scheduled(cron = "5 * * * * ?")
    private void open() {

        System.err.println("打开: " + LocalDateTime.now());
        try {
            csdn.openIEBrowser();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Scheduled(cron = "45 * * * * ?")
    private void close() {

        System.err.println("关闭: " + LocalDateTime.now());
        try {
            csdn.closeIEBrowser();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}