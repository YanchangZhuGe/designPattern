/*================================================================================
* BizFlowExecType.java
* 生成日期：2015-1-26 上午10:24:49
* 作          者：zhanghonghui
* 项          目：TSS-Service
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
 * Description:工作流操作类型
 * </p>
 *
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 *
 * @author zhanghonghui
 *
 * @since：2015-1-26 上午10:24:49
 *
 * @version 1.0
 */
public enum BizFlowExecType {
	/**推进*/
	APPROVE(1,"推进"),
	/**驳回*/
	REJECT(2,"驳回"),
	/**撤销*/
	CANCEL(3,"撤销");

	private Integer value;
	private String name;
	private BizFlowExecType(Integer value,String name){
		this.value = value;
		this.name  = name;
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
