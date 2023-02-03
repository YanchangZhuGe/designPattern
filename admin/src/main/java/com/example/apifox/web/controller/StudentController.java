package com.example.apifox.web.controller;

import com.gv.ops.web.entity.Student;
import com.gv.ops.web.service.StudentService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/4/28 14:10
 */

@RestController
@RequestMapping("/web/student")
@Api(tags = "学生模块")
public class StudentController {

    @Autowired
    private StudentService studentService;

    @Value("${text.success}")
    private String port;

    @GetMapping("/get1")
    @ApiOperation("suoyou")
    public String textGet(){
        return "success get " + port;
    }

    @PostMapping(("/post"))
    public String textPost(){
        return "success post" + port;
    }

    @GetMapping("/list")
    public List<Student> list(){
        List<Student> list = studentService.list();
        return list;
    }
}
