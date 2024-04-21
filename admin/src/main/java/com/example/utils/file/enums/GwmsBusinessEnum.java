package com.example.utils.file.enums;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>Title: BusinessEnum.java</p>
 * 2021.09.25之后禁用，应该以主数据的数据字典数据为准
 * <p>Description:业务品种类型(从授信copy的) </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author wt
 * 
 * @since：2018-10-29 上午08:39:45
 * 
 */
@Deprecated
public enum GwmsBusinessEnum implements TypeEnum {
	/** 中长期债券*/
	BUS_00("0","中长期债券"),
	/** 短期债券 */
	BUS_01("1","短期债券"),
	/** 私募债券 */
	BUS_02("2","私募债券"),
	/** 人民币贷款 */
	BUS_03("3","人民币贷款"),
	/** 外币债券 */
	BUS_04("4","外币债券"),
	/** 外币贷款 */
	BUS_05("5","外币贷款"),
	/** 股权融资*/
	BUS_06("6","股权融资");

	private String value;
	private String name;

	/**
	 * @Description:获取枚举的列表
	 * @return
	 * @return List<Map<String,String>>
	 * @author wt
	 * @since：2018-10-29 上午09:34:14
	 */
	public static List<Map<String,String>> getList(){
		List<Map<String,String>> list=new ArrayList<Map<String,String>>();
		for(GwmsBusinessEnum e:values()){
			Map<String,String> map=new HashMap<String,String>();
			map.put("name", e.getName());
			map.put("value", e.getValue());
			list.add(map);
		}
		return list;
	}

	/**
	 * @Description:通过value获取name
	 * @param value
	 * @return
	 * @return BusinessEnum
	 * @author wt
	 * @since：2018-10-29 上午09:33:50
	 */
	public static String getNameByValue(String value) {
		for (GwmsBusinessEnum bussTypeEnum : values()) {
			if (bussTypeEnum.getValue().equals(value)) {
				return bussTypeEnum.getName();
			}
		}
		return null;
	}

	private GwmsBusinessEnum(String value, String name) {
		this.value = value;
		this.name = name;
	}

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
