package com.example.utils.file.demo.service.Impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.utils.file.demo.dao.UserDao;
import com.example.utils.file.demo.entity.User;
import com.example.utils.file.demo.service.UserService;
import org.springframework.stereotype.Service;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/4/8 10:15
 */

@Service
public class UserServiceImpl extends ServiceImpl<UserDao, User> implements UserService {

}
