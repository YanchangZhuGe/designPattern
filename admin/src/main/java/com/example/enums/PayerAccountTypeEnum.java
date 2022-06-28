package com.example.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>Title: </p>
 *
 * <p>Description: 付款账户类型</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author wujianchao
 * @since：2021-4-19 下午05:38:42
 */
public enum PayerAccountTypeEnum {
	AA01("01", "结售汇户"),
	DD00("D0", "现汇户"),
	DD01("D1", "待核查户"),
	DD02("D2", "资本户"),
	DD03("D3", "外债户"),
	DD04("D4", "外债户1"),
	DD05("D5", "外债户2"),
	DD06("D6", "外债户3"),
	DD07("D7", "保证金户"),
	DD08("D8", "贷款专户"),
	G5("G5", "其他账户");

	private PayerAccountTypeEnum(String value, String name) {
		this.value = value;
		this.name = name;
	}

	public static List<Map<String, Object>> getPayerAccountType() {
		List<Map<String, Object>> list = new ArrayList<>();
		for (PayerAccountTypeEnum p : values()) {
			Map<String, Object> map = new HashMap<>();
			map.put("value", p.getValue());
			map.put("name", p.getName());
			list.add(map);
		}
		return list;
	}

	private String value;
	private String name;

	public String getValue() {
		return value;
	}

	public String getName() {
		return name;
	}
}
