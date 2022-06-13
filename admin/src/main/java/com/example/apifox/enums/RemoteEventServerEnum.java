/**
 * 
 */
package com.example.apifox.enums;

import com.nstc.gwms.constants.RemoteConstants;

/**
 * <p>Title: </p>
 *
 * <p>Description: 对外接口bizcode维护</p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author yangliye
 * 
 * @since：2016年8月26日 上午11:46:14
 * 
 */
/**
 * @author Administrator
 *
 */
public enum RemoteEventServerEnum {
	HTFSEDJ(RemoteConstants.HTFSEDJ, "合同发生额登记", 0),
	HTFSEDJSC(RemoteConstants.HTFSEDJSC, "合同发生额登记删除", 1);
	private String code;
	private String describtion;
	private int index;//索引
	private RemoteEventServerEnum(String code, String describtion, int index) {
		this.code = code;
		this.describtion = describtion;
		this.index = index;
	}
	/**
	 * @return the code
	 */
	public String getCode() {
		return code;
	}
	/**
	 * @param code the code to set
	 */
	public void setCode(String code) {
		this.code = code;
	}
	/**
	 * @return the describtion
	 */
	public String getDescribtion() {
		return describtion;
	}
	/**
	 * @param describtion the describtion to set
	 */
	public void setDescribtion(String describtion) {
		this.describtion = describtion;
	}
	/**
	 * @return the index
	 */
	public int getIndex() {
		return index;
	}
	/**
	 * @param index the index to set
	 */
	public void setIndex(int index) {
		this.index = index;
	}
	/**
	 * 
	 * @Description:通过code获取索引(支持switch选择语句，条件判断不多时不使用)
	 * @param code
	 * @return
	 * @author yangliye
	 * @since：2016年8月26日 上午11:51:59
	 */
	public static int getIndexByCode(String code) {
		for (RemoteEventServerEnum tempEnum : values()) {
			if (tempEnum.getCode().equals(code)) {
				return tempEnum.getIndex();
			}
		}
		return Integer.MIN_VALUE;
	}
}
