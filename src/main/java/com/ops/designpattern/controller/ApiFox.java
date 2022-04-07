package com.ops.designpattern.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Vector;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/4/7 17:51
 */

@RestController
public class ApiFox {

    @GetMapping("/text")
    public String text(){

        return "success";
    }
}
