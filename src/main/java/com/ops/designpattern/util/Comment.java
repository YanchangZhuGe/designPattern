package com.ops.designpattern.util;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.ops.designpattern.util.vo.ArticleVO;
import com.ops.designpattern.util.vo.ParseJsonField;
import com.ops.designpattern.util.vo.ParseObj;

import java.io.*;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

/**
 * 描述:
 *
 * @author WuYanchang
 * @date 2021/7/21 14:03
 */

public class Comment {

    public static String getPath() {

        String localPath = "D:" + File.separator + "demo" + File.separator;

        StringBuffer path = new StringBuffer();
        path.append("C:" + File.separator);
        path.append("Users" + File.separator);
        path.append("admin" + File.separator);
        path.append("Desktop" + File.separator);
        path.append("java" + File.separator);

        if (true) {
            return localPath;
        } else {
            return path.toString();
        }
    }

    public static String getFile(String path) {
        String jsonStr = "";
        try {
            File jsonFile = new File(path);
            FileReader fileReader = new FileReader(jsonFile);
            Reader reader = new InputStreamReader(new FileInputStream(jsonFile), "utf-8");
            int ch = 0;
            StringBuffer sb = new StringBuffer();
            while ((ch = reader.read()) != -1) {
                sb.append((char) ch);
            }
            fileReader.close();
            reader.close();
            jsonStr = sb.toString();
            return jsonStr;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }

//        JSONObject JsonData= data.getJSONObject(JsonStr);
//        ParseObj parseObj = new ParseObj();
//        readJson(JsonData, parseObj, "Main");
//        tryUpdate(Obj, parseObj);
    }

    public static List<ArticleVO> getArticleList() {
        String path = Comment.getPath();
        String json = Comment.getFile(path + "all.json");
        JSONObject jobj = JSON.parseObject(json);
        JSONObject data = (JSONObject) jobj.get("data");
        JSONArray list = (JSONArray) data.get("list");
        List<ArticleVO> articleVOS = list.toJavaList(ArticleVO.class);
        Integer articleId = articleVOS.get(0).getArticleId();
        return articleVOS;
    }

    public static <T> void readJson(JSONObject jsonObject, T toObj, String type) {
        //读取辅助类所有字段名
        Field[] f2 = toObj.getClass().getDeclaredFields();
        //循环遍历所有字段
        for (Field field : f2) {
            //禁用安全检查
            field.setAccessible(true);
            try {
                //检查是否有注解
                if (field.isAnnotationPresent(ParseJsonField.class)) {
                    //读取当前注解
                    ParseJsonField JsonField = field.getAnnotation(ParseJsonField.class);
                    //匹配当前json对象
                    if (type.equals(JsonField.type())) {
                        //读取json对象属性值
                        Object valueObject = jsonObject.get(JsonField.value());
                        // 获取属性的类型
                        String Attrtype = field.getGenericType().toString();
                        String valueObject_str = String.valueOf(valueObject);
                        if (valueObject != null && valueObject_str.length() > 0) {
                            if (Attrtype.equals("class java.sql.Timestamp")) {
                                if (valueObject_str.length() <= 10) {
                                    valueObject_str = valueObject_str + " 00:00:00";
                                }
                                field.set(toObj, Timestamp.valueOf(valueObject_str));
                            } else if (Attrtype.equals("class java.lang.String")) {
                                field.set(toObj, String.valueOf(valueObject));
                            } else if (Attrtype.equals("class java.lang.Integer")) {
                                field.set(toObj, Integer.parseInt(valueObject_str));//
                            } else if (Attrtype.equals("class java.math.BigDecimal")) {
                                field.set(toObj, new BigDecimal(valueObject_str));//
                            } else {
                                field.set(toObj, valueObject);
                            }
                        }
                    }
                }
            } catch (IllegalArgumentException | IllegalAccessException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();

            } catch (SecurityException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
                System.out.print(toObj);
            }
        }
    }

    //读取辅助类数据到保存类 toObj 辅助类  fromObj 保存类
    public static <T1, T2> void tryUpdate(T1 formObj, T2 toObj) {
        // TODO Auto-generated method stub
        //读取辅助类所有字段名
        Field[] f2 = toObj.getClass().getDeclaredFields();
        //循环遍历所有字段
        for (Field field : f2) {
            //禁用安全检查
            field.setAccessible(true);
            try {
                //读取辅助类对象属性值
                Object valueObject = field.get(toObj);
                if (valueObject != null) {
                    //获取保存类字段对象
                    Field formField = formObj.getClass().getDeclaredField(field.getName());
                    //禁用安全检查
                    formField.setAccessible(true);
                    //保存类的值
                    formField.set(formObj, valueObject);
                }
            } catch (IllegalArgumentException | IllegalAccessException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } catch (NoSuchFieldException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } catch (SecurityException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

        }
    }
}
