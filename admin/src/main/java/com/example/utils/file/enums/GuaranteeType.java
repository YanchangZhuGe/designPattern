/*================================================================================
* BussType.java
* 生成日期：2015-9-22 上午10:59:45 
* 作          者：zhanghonghui
* 项          目：GWMS-Service
* (C)COPYRIGHT BY NSTC.
* ================================================================================
*/
package com.example.utils.file.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * Title:
 * </p>
 * 
 * <p>
 * Description:担保方式
 * </p>
 * 
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 * 
 * @author zhanghonghui
 * 
 * @since：2015-9-22 上午10:59:45
 * 
 * @version 1.0
 */
public enum GuaranteeType implements TypeEnum {
	/***保证金担保**/
//	G_01("G01","保证金担保"),
	/***质押担保**/
	G_02("G02","质押担保"),
	/***抵押担保**/
	G_03("G03","抵押担保"),
	/***第三方保证担保**/
	G_04("G04","第三方保证担保"),
	/***信用担保**/
//	G_05("G05","信用担保"),
	/***保证担保**/
	G_06("G06","保证担保"),
	/***第三方抵押担保**/
	G_07("G07","第三方抵押担保"),
	/***第三方质押担保**/
	G_08("G08","第三方质押担保");

	private String value;
	private String name;
	
	GuaranteeType(String value,String name){
		this.value = value;
		this.name = name;
	}
	/**
	 *  
	 * @Description:担保类型名称
	 * @param value
	 * @return
	 * @author zhanghonghui
	 * @since 2015-9-22 上午11:05:10
	 */
	public static String getTypeName(String value){
		for(GuaranteeType t : values()){
			if(t.getValue().equals(value)){
				return t.getName();
			}
		}
		return "";
	}
	/**
	 * 将枚举转换成list-map
	* @Description：
	* @return
	* @author xiongyong
	* @since：2018年2月1日 下午5:30:20
	 */
	public static List<Map<String,String>> getTypeOfListMap() {
	 List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		for (GuaranteeType typeEnum : values()) {
			Map<String,String> map = new HashMap<String,String>();
			map.put("value",typeEnum.getValue());
			map.put("name", typeEnum.getName());
			list.add(map);
		}
		return list;
	}
	/**
	 * 将枚举转换成list-map 去除第三方和信用,保证金
	* @Description：
	* @return
	* @author xiongyong
	* @since：2018年2月1日 下午5:29:43
	 */
	public static List<Map<String,String>> getTypeOfListMapLess() {
		 List<Map<String,String>> list = new ArrayList<Map<String,String>>();
			for (GuaranteeType typeEnum : values()) {
				if (typeEnum.getValue().equals("G02")
				    || typeEnum.getValue().equals("G03")
					|| typeEnum.getValue().equals("G06")) {
					
					Map<String,String> map = new HashMap<String,String>();
					map.put("value",typeEnum.getValue());
					map.put("name", typeEnum.getName());
					list.add(map);
				}
			}
			return list;
	}
	
	
	/**
	 * 
	 * @Description：将枚举转换成list-map 去除第三方和保证担保
	 * @return
	 * @author hsw
	 * @since：2018年2月1日 下午5:29:43
	 */
	public static List<Map<String,String>> toListMapRemoveDsf() {
		 List<Map<String,String>> list = new ArrayList<Map<String,String>>();
			for (GuaranteeType typeEnum : values()) {
				if (typeEnum.getValue().equals("G06")) { 
					continue;
				}
				Map<String,String> map = new HashMap<String,String>();
				map.put("value",typeEnum.getValue());
				map.put("name", typeEnum.getName());
				list.add(map);
			}
			return list;
	}
	/**
	 * 
	 * @Description：将枚举转换成list-map 去除第三方和保证担保
	 * @return
	 * @author hsw
	 * @since：2018年2月1日 下午5:29:43
	 */
	public static List<Map<String,String>> toListMapRemoveDsf(String guaranteeTypes) {
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		for (GuaranteeType typeEnum : values()) {
			if (typeEnum.getValue().equals("G06")) { 
				continue;
			}
			if(guaranteeTypes.contains(typeEnum.getValue())) {
				Map<String,String> map = new HashMap<String,String>();
				map.put("value",typeEnum.getValue());
				map.put("name", typeEnum.getName());
				list.add(map);
			}
		}
		return list;
	}

	public static List<Map<String,String>> getListByGuaTypes(String guaTypes) {
		List<Map<String,String>> list = new ArrayList<Map<String,String>>();
		for (GuaranteeType typeEnum : values()) {
			if(guaTypes != null){
				if (guaTypes.contains(typeEnum.getValue())) {
					Map<String,String> map = new HashMap<String,String>();
					map.put("value",typeEnum.getValue());
					map.put("name", typeEnum.getName());
					list.add(map);
				}
			}else{
				return toListMapRemoveDsf();
			}

		}
		return list;
	}

	/**
	 * 提供担保的担保方式
	 * @return
	 */
	public static List<Map<String, Object>> getGuaranteeTypeOfPro() {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		for (GuaranteeType typeEnum : values()) {
			if (typeEnum.getValue().equals("G02")
					|| typeEnum.getValue().equals("G03")
					|| typeEnum.getValue().equals("G04")
					|| typeEnum.getValue().equals("G07")
					|| typeEnum.getValue().equals("G08")
			) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("value",typeEnum.getValue());
				map.put("label", typeEnum.getName());
				list.add(map);
			}
		}
		return list;
	}

	/**
	 * 获得担保的担保方式
	 * @return
	 */
	public static List<Map<String, Object>> getGuaranteeTypeOfGet() {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		for (GuaranteeType typeEnum : values()) {
			if (typeEnum.getValue().equals("G02")
					|| typeEnum.getValue().equals("G03")
					|| typeEnum.getValue().equals("G06")
			) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("value",typeEnum.getValue());
				map.put("label", typeEnum.getName());
				list.add(map);
			}
		}
		return list;
	}

	/**
	 * @return String
	 */
	public String getValue() {
		return value;
	}

	/**
	 * @param value String
	 */
	public void setValue(String value) {
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
