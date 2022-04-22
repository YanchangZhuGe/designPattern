package com.example.apifox.demo.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.apifox.demo.entity.User;

import javax.annotation.Resource;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/4/8 10:11
 */
@Resource
public interface UserDao extends BaseMapper<User> {
}
