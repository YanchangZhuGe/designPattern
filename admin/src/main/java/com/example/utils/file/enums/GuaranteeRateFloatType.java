
package com.example.utils.file.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 
 * <p>Description: 担保费率浮动方式</p>
 *
 * @author hsw
 * 
 * @since：2018年1月26日 下午4:15:25 
 * 
 */
public enum GuaranteeRateFloatType implements TypeEnum {
	
	/**
	 * 上浮
	 */
	TYPE_01(new Integer(1), "上浮"),
	/**
	 * 下浮
	 */
	TYPE_02(new Integer(2), "下浮"),
	/**
	 * 不变
	 */
	TYPE_03(new Integer(3),"不变");

	private Integer value;
	private String name;
	GuaranteeRateFloatType(Integer value,String name){
		this.value = value;
		this.name = name;
	}
	public static String getTypeName(Integer value){
		for(GuaranteeRateFloatType p :values()){
			if(p.getValue().equals(value)){
				return p.getName();
			}
		}
		return "";
	}
	public static List<Map<String,Object>> getList(){
		List<Map<String,Object>> list=new ArrayList<Map<String,Object>>();
		for(GuaranteeRateFloatType temp:GuaranteeRateFloatType.values()){
			Map<String,Object> map=new HashMap<String, Object>();
			map.put("value",temp.value);
			map.put("name",temp.name);
			list.add(map);
		}
		return list;
	}
	/**
	 * @return Integer
	 */
	public Integer getValue() {
		return value;
	}
	/**
	 * @param value Integer
	 */
	public void setValue(Integer value) {
		this.value = value;
	}
	/**
	 * @return String
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name String
	 */
	public void setName(String name) {
		this.name = name;
	}

}
