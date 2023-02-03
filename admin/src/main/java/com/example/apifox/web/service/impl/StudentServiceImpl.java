package com.example.apifox.web.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gv.ops.web.entity.Student;
import com.gv.ops.web.mapper.StudentMapper;
import com.gv.ops.web.service.StudentService;
import org.springframework.stereotype.Service;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/4/28 15:42
 */

@Service
public class StudentServiceImpl extends ServiceImpl<StudentMapper, Student> implements StudentService {

}
