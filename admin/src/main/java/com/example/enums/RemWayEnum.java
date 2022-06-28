package com.example.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 汇款去向枚举类
 */
public enum RemWayEnum {
    REMWAY_01(1, "境外-电汇(swift方式)"),
    REMWAY_02(2, "港澳台-电汇(swift方式)"),
    REMWAY_03(3, "境内-系统内同城"),
    REMWAY_04(4, "境内-系统外同城"),
    REMWAY_05(5, "境内-系统内异地"),
    REMWAY_06(6, "境内-系统外异地"),
    ;


    private Integer value;
    private String name;

    public static List<Map<String, Object>> getTerritoryRemWayList() {
        List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
        for (RemWayEnum p : values()) {
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("value", p.getValue());
            map.put("name", p.getName());
            list.add(map);
        }
        return list;
    }

    RemWayEnum(Integer value, String name) {
        this.value = value;
        this.name = name;
    }

    public Integer getValue() {
        return value;
    }

    public void setValue(Integer value) {
        this.value = value;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
