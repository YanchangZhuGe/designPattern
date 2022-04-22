package com.example.apifox.demo.job;

import com.nstc.nsosp.job.core.context.NSospJobHelper;
import com.nstc.nsosp.job.core.handler.annotation.NSospJob;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/4/11 12:00
 */

@Configuration
public class DemoJob {

    @NSospJob(jobId = "demoJobHandler",jobName = "demoJobHandler",scheduMode = "2",jobCron = "0/2 * * * * ? *"
            ,moduleName = "wuyc-job")
    public void demoJobHandler() throws Exception {
        NSospJobHelper.log("XXL-JOB, Hello World.");
        System.out.println("XXL-JOB, Hello World.");

        for (int i = 0; i < 5; i++) {
            NSospJobHelper.log("beat at:" + i);
            System.out.println("beat at:" + i);
            TimeUnit.SECONDS.sleep(2);
        }
        // default success
    }
}
