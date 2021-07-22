package com.ops.designpattern.util.vo;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/22 10:40
 */

public class ParseObj {
    @ParseJsonField(type = "Main", value = "appliName")
    private String voteName;
    @ParseJsonField(type = "Main", value = "TestNo")
    private String DanNo;
}
