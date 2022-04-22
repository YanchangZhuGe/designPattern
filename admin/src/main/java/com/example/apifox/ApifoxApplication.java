package com.example.apifox;

//import com.alibaba.nacos.spring.context.annotation.config.NacosPropertySource;
//import com.alibaba.nacos.spring.context.annotation.EnableNacos;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication(scanBasePackages = {"com.nstc","com.example.apifox"})
//@NacosPropertySource(dataId = "wuyc-text", autoRefreshed = true)
@MapperScan("com.example.apifox.demo.dao")
@EnableDiscoveryClient

public class ApifoxApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApifoxApplication.class, args);
    }

}
