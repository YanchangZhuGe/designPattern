/*================================================================================
* LedgerDirEnum.java
* 生成日期：2015-9-24 下午04:39:27 
* 作          者：zhanghonghui
* 项          目：GWMS-Service
* (C)COPYRIGHT BY NSTC.
* ================================================================================
*/
package com.example.apifox.enums;

/**
 * <p>
 * Title:
 * </p>
 * 
 * <p>
 * Description:
 * </p>
 * 
 * <p>
 * Company: 北京九恒星科技股份有限公司
 * </p>
 * 
 * @author zhanghonghui
 * 
 * @since：2015-9-24 下午04:39:27
 * 
 * @version 1.0
 */
public enum LedgerDirEnum {
	/**
	 * 占用
	 */
	PLUS("+","占用", "1"),
	/**
	 * 释放
	 */
	MINUS("-","释放", "-1");
	private String value;
	private String name;
	private String dir;

    LedgerDirEnum(String value, String name, String dir) {
        this.value = value;
        this.name = name;
        this.dir = dir;
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

    public String getDir() {
        return dir;
    }

    public void setDir(String dir) {
        this.dir = dir;
    }
}
