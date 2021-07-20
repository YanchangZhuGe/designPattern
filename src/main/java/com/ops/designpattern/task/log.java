package com.ops.designpattern.task;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

import java.time.LocalDateTime;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/20 16:34
 */

@Configuration
@EnableScheduling
public class log {
    @Scheduled(cron = "0/5 * * * * ?")
    public void soutLog() {
        System.out.println(LocalDateTime.now());
    }
}
