/*================================================================================
* UmFormLogStepEnum.java
* 生成日期：2015-9-28 下午03:17:41 
* 作          者：zhanghonghui
* 项          目：GWMS-Service
* (C)COPYRIGHT BY NSTC.
* ================================================================================
*/
package com.example.utils.file.enums;

/**
 * <p>
 * Title:
 * </p>
 * 
 * <p>
 * Description:工单日志步骤枚举
 * </p>
 * 
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 * 
 * @author zhanghonghui
 * 
 * @since：2015-9-28 下午03:17:41
 * 
 * @version 1.0
 */
public enum UmFormLogStepEnum {
	/**
	 * 保存
	 */
	SAVE(new Integer(0),"保存"),
	/**
	 * 提交
	 */
	SUBMIT(new Integer(1),"提交"),
	/**
	 * 审批通过
	 */
	PASS(new Integer(2),"审批通过"),
	/**
	 * 审批驳回
	 */
	REJECT(new Integer(3),"审批驳回"),
	/**
	 * 审批生效
	 */
	EFFECT(new Integer(4),"审批生效");
	private Integer value;
	private String name;
	UmFormLogStepEnum(Integer value,String name){
		this.value = value;
		this.name = name;
	}
	/**
	 * 
	 * @Description:取步骤名称
	 * @param value
	 * @return
	 * @author zhanghonghui
	 * @since 2015-9-28 下午03:19:28
	 */
	public static String getStepName(Integer value){
		for(UmFormLogStepEnum s : values()){
			if(s.getValue().equals(value)){
				return s.getName();
			}
		}
		return "";
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
