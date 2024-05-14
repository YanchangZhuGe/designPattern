package com.example.utils.file.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public enum MoneyUnitEnums {
	TEN_THOUSANDS(10000, "万元"),
	UNIT(1, "元"),
	THOUSANDS(1000, "千元"),
	MILLIONS(1000000, "百万元"),
	HUNDRED_MILLIONS(100000000, "亿元");
	
	
	private Integer value;
	private String name;
	
	private MoneyUnitEnums(Integer value, String name) {
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
	
	public static List<Map<String, Object>> getList() {
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		for (MoneyUnitEnums au : values()) {
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("value", au.getValue());
			map.put("name", au.getName());
			list.add(map);
		}
		return list;
	}
}
