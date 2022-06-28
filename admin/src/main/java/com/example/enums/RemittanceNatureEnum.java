package com.example.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>Title: </p>
 *
 * <p>Description: </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author zhangruichen
 * @since：2020-7-2 下午03:04:55
 */
public enum RemittanceNatureEnum {
	/**
	 * 保税区
	 */
	RemittanceNature00("0", "保税区"),
	/**
	 * 出口加工区
	 */
	RemittanceNature01("1", "出口加工区"),
	/**
	 * 钻石交易所
	 */
	RemittanceNature02("2", "钻石交易所"),
	/**
	 * 深加工结转
	 */
	RemittanceNature03("3", "深加工结转"),
	/**
	 * 其他
	 */
	RemittanceNature04("4", "其他"),
	/**
	 * 结汇交易
	 */
	RemittanceNature05("5", "结汇交易");

	private RemittanceNatureEnum(String value, String name) {
		this.value = value;
		this.name = name;
	}

	public static List<Map<String, Object>> getRemittanceNatureList() {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		for (RemittanceNatureEnum p : values()) {
			Map<String, Object> map = new HashMap<String, Object>();
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

	public void setValue(String value) {
		this.value = value;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}
