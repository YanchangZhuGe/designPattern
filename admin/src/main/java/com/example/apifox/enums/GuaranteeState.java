/*================================================================================
* GuaranteeState.java
* 生成日期：2015-9-22 下午03:54:43 
* 作          者：zhanghonghui
* 项          目：GWMS-Service
* (C)COPYRIGHT BY NSTC.
* ================================================================================
*/
package com.example.apifox.enums;

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
 * Description:担保合同状态
 * </p>
 * 
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 * 
 * @author zhanghonghui
 * 
 * @since：2015-9-22 下午03:54:43
 * 
 * @version 1.0
 */
public enum GuaranteeState implements TypeEnum{
	/**
	 * 已生效
	 */
	NORMAL(new Integer(0),"正常"),
	/**
	 * 已废弃
	 */
	CANCEL(new Integer(8),"废弃"),
	/**
	 * 已结项
	 */
	FINISH(new Integer(9),"结项");
	
	private Integer value;
	private String name;
	GuaranteeState(Integer value,String name){
		this.name = name;
		this.value = value;
	}
	
	public static String getStateName(Integer state){
		if (state == null) {
			return null;
		}
		for(GuaranteeState s : values()){
			if(s.getValue().equals(state)){
				return s.getName();
			}
		}
		return null;
	}
	
	/**
	 * 
	 * @Description:获取状态的列表
	 * @return
	 * @return List<Map<String,Object>>
	 * @author wangshenglang
	 * @since：2018-9-25 下午05:13:19
	 */
	public static List<Map<String, Object>> getList(){
		List<Map<String, Object>> states = new ArrayList<Map<String,Object>>();
		for(GuaranteeState s : values()){
			Map<String, Object> state = new HashMap<String, Object>();
			state.put(s.getValue().toString(), s.getName());
			states.add(state);
		}
		return states;
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
