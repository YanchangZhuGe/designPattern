package com.example.utils.file.demo.entity;

import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/4/8 10:07
 */

@TableName("TEXT_WUYC")
public class User {

    private String id;
    private String code;
    private String name;
    private Integer age;
    private String sex;
    private String remarkText;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getRemarkText() {
        return remarkText;
    }

    public void setRemarkText(String remarkText) {
        this.remarkText = remarkText;
    }

    @Override
    public String toString() {
        return "User{" +
                "id='" + id + '\'' +
                ", code='" + code + '\'' +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", sex='" + sex + '\'' +
                ", remarkText='" + remarkText + '\'' +
                '}';
    }
}
