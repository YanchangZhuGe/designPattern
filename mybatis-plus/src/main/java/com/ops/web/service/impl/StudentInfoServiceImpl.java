package com.ops.web.service.impl;

import com.ops.web.entity.StudentInfoDO;
import com.ops.web.mapper.StudentInfoMapper;
import com.ops.web.service.IStudentInfoService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author wyc
 * @since 2022-05-06
 */
@Service
public class StudentInfoServiceImpl extends ServiceImpl<StudentInfoMapper, StudentInfoDO> implements IStudentInfoService {

}
