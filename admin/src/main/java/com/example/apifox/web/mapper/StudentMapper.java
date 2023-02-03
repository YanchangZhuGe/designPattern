package com.example.apifox.web.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.gv.ops.web.entity.Student;
import org.apache.ibatis.annotations.Mapper;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/4/28 15:44
 */

@Mapper
public interface StudentMapper extends BaseMapper<Student> {
}
