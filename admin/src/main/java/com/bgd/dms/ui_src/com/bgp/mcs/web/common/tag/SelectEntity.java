package com.bgp.mcs.web.common.tag;

import java.io.Serializable;

public class SelectEntity implements Serializable {

	private static final long serialVersionUID = 7886352798833830179L;
	private String dictkey;//字典类型的key值
	private String dictdesc;//字典的汉字名称
	private String optionvalue;//字典列表可取的值
	private String optiondesc;//字典列表可取的值对应的汉字
	private int displayorder;//排序
	public String getDictkey() {
		return dictkey;
	}
	public void setDictkey(String dictkey) {
		this.dictkey = dictkey;
	}
	public String getDictdesc() {
		return dictdesc;
	}
	public void setDictdesc(String dictdesc) {
		this.dictdesc = dictdesc;
	}
	public String getOptionvalue() {
		return optionvalue;
	}
	public void setOptionvalue(String optionvalue) {
		this.optionvalue = optionvalue;
	}
	public String getOptiondesc() {
		return optiondesc;
	}
	public void setOptiondesc(String optiondesc) {
		this.optiondesc = optiondesc;
	}
	public int getDisplayorder() {
		return displayorder;
	}
	public void setDisplayorder(int displayorder) {
		this.displayorder = displayorder;
	}
}
