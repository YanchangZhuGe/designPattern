package com.bgd.api.common.utils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * @author guodg
 * @date 2021/1/19 19:31
 * @description json数据工具类
 */
public class JSONUtil {
    /**
     * 根据路径，获取string 元素
     *
     * @param jsonObject
     * @param path
     * @return
     */
    public static String getString(JSONObject jsonObject, String[] path) {
        Object jObject = doFind(jsonObject, path);
        return jObject == null ? "" : jObject.toString();
    }

    /**
     * 根据key，获取string元素
     *
     * @param jsonObject
     * @param key
     * @return
     */
    public static String getString(JSONObject jsonObject, String key) {
        Object jObject = doFind(jsonObject, key);
        return jObject == null ? "" : jObject.toString();
    }


    /**
     * 根据路径，获取map 元素
     *
     * @param jsonObject
     * @param path
     * @return
     */
    public static Map getMap(JSONObject jsonObject, String[] path) {
        Object jObject = doFind(jsonObject, path);
        if (jObject instanceof JSONObject) {
            return (Map) jObject;
        }
        return null;
    }

    /**
     * 根据路径，根据key,获取map 元素
     *
     * @param jsonObject
     * @param key
     * @return
     */
    public static Map getMap(JSONObject jsonObject, String key) {
        Object jObject = doFind(jsonObject, key);
        if (jObject instanceof JSONObject) {
            return (Map) jObject;
        }
        return null;
    }

    /**
     * 获取list集合，集合中的元素为map
     *
     * @param jsonObject
     * @param path
     * @return
     */
    public static List<Map> getMapList(JSONObject jsonObject, String[] path) {
        Object jObject = doFind(jsonObject, path);
        return toMapList(jObject);
    }

    /**
     * 根据key,获取list集合，集合中的元素为map
     *
     * @param jsonObject
     * @param key
     * @return
     */
    public static List<Map> getMapList(JSONObject jsonObject, String key) {
        Object jObject = doFind(jsonObject, key);
        return toMapList(jObject);
    }

    /**
     * 递归遍历，jsonObject对象中的所有key，若匹配则返回true，否则false
     *
     * @param jsonObject
     * @param key
     * @return
     */
    public static boolean containsKey(JSONObject jsonObject, String key) {
        // 递归出口
        if (jsonObject.containsKey(key)) {
            return true;
        }
        // 遍历所有value，查找下一个jsonObject
        Iterator iterator = jsonObject.values().iterator();
        while (iterator.hasNext()) {
            Object next = iterator.next();
            if (next instanceof JSONObject) {
                return containsKey(JSONObject.fromObject(next), key);
            }
        }
        return false;
    }

    /**
     * 递归遍历，为jsonObject中的key重新赋值为value，若存在重复的key,则只会为第一个key赋值
     *
     * @param jsonObject 操作对象
     * @param key
     * @param value
     * @return 返回旧值
     */
    public static JSONObject updateIfExists(JSONObject jsonObject, String key, Object value) {
        // 递归出口
        if (jsonObject.containsKey(key)) {
            // 为key重新赋值为value,并返回赋值成功的后jsonObject
            return jsonObject.element(key, value);
        }
        // 遍历所有value，查找下一个jsonObject
        Iterator keys = jsonObject.keys();
        while (keys.hasNext()) {
            Object jKey = keys.next();
            Object jValue = jsonObject.get(jKey);
            if (jValue instanceof JSONObject) {
                // 获得修改后的jsonObject,并更新到当前jsonObject对应的key上
                JSONObject updatedJValue = updateIfExists(JSONObject.fromObject(jValue), key, value);
                jsonObject.put(jKey, updatedJValue);
            }
        }
        return jsonObject;
    }

    /**
     * 根据获取路径数组，获取JSONObject对象中的值
     *
     * @param message 操作对象
     * @param path    获取路径，数组形式，从外到内依次排列
     * @return
     */
    private static Object doFind(JSONObject message, String[] path) {
        Object value = null;
        for (String key : path) {
            value = message.get(key);
            if (value instanceof JSONObject) {
                message = (JSONObject) value;
            } else {
                return value;
            }
        }
        return value;
    }

    /**
     * 递归遍历，匹配给定的key，返回key对应的value
     *
     * @param jsonObject
     * @param key
     * @return
     */
    private static Object doFind(JSONObject jsonObject, String key) {
        // 递归出口
        if (jsonObject.containsKey(key)) {
            return jsonObject.get(key);
        }
        // 遍历所有value，查找下一个jsonObject
        Iterator iterator = jsonObject.values().iterator();
        while (iterator.hasNext()) {
            Object next = iterator.next();
            if (next instanceof JSONObject) {
                return doFind(JSONObject.fromObject(next), key);
            }
        }
        return null;
    }

    /**
     * 判断jsonArray对象，转为集合对象
     *
     * @param object
     * @return
     */
    private static List<Map> toMapList(Object object) {
        if (object instanceof JSONArray) {
            JSONArray jsonArray = JSONArray.fromObject(object);
            List<Map> mapList = (List<Map>) JSONArray.toCollection(jsonArray, Map.class);
            return mapList;
        }
        return null;
    }
}
