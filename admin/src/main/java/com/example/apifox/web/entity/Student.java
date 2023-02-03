package com.example.apifox.web.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/4/28 15:44
 */

@Data
@TableName("student_info")
public class Student {

    @TableId("id")
    private String id;
    @TableField("code")
    private String code;
    @TableField("name")
    private String name;
    @TableField("class_id")
    private String classId;
    @TableField("sex")
    private Integer sex;
}
