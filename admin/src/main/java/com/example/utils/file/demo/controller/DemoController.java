package com.example.utils.file.demo.controller;

import com.example.utils.file.demo.entity.User;
import com.example.utils.file.demo.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2022/4/8 09:40
 */

@RestController
@RequestMapping("/demo")
@Api(value = "用户信息接口", tags = "用户管理相关的接口", description = "用户测试接口")
public class DemoController {

    @Autowired(required=true)
    private UserService userService;

    @GetMapping("/get")
    @ApiOperation(value = "测试get请求",notes = "get请求")
    public String textGet(){
        return "get success";
    }

    @PostMapping("/post")
    public String textPost(){
        return "post success";
    }

    @PostMapping("/select")
    @ApiOperation(value = "查询",notes = "查询用户")
    public List<User> getAll(){
        List<User> list = userService.list();
//        List<User> maps = userService.listMaps();
        return list;
    }

    @PostMapping("insert")
    @ApiImplicitParam(name = "user",value = "新增用户")
    @ApiOperation(value = "添加",notes = "添加用户")
    public List<User> insert(@RequestBody User user) {

        Boolean save = userService.saveOrUpdate(user);
        return getAll();
    }

    @PostMapping("/delete")
    @ApiImplicitParam(name = "code",value = "删除用户")
    @ApiOperation(value = "删除",notes = "删除用户")
    public List<User> delete(@RequestParam(value = "code") String code){
        Map<String, Object> map = new HashMap<>();
        map.put("code",code);

        boolean b = userService.removeByMap(map);
        return getAll();
    }

    @PostMapping("/update")
    @ApiImplicitParam(name = "user",value = "更新用户")
    @ApiOperation(value = "更新",notes = "更新用户")
    public List<User> update (@RequestBody User user){
        userService.saveOrUpdate(user);
        return getAll();
    }

}
