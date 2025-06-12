package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;

/**
 * 用户信息
 * @author liyongfeng
 *
 */
public class UserInfo implements Serializable {

	private static final long serialVersionUID = -9161690559282991417L;
	private String user_name;//用户姓名
	private String user_id;//用户id
	private String org_id;//用户所在机构id
	private String org_name;//用户所在机构名称
	private String org_type;//机构类型
	private String org_abbreviation;//机构简称
	private String org_desc;//机构描述
	private String org_level;//机构层级
	private String locked_if;
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getOrg_id() {
		return org_id;
	}
	public void setOrg_id(String org_id) {
		this.org_id = org_id;
	}
	public String getOrg_name() {
		return org_name;
	}
	public void setOrg_name(String org_name) {
		this.org_name = org_name;
	}
	public String getOrg_type() {
		return org_type;
	}
	public void setOrg_type(String org_type) {
		this.org_type = org_type;
	}
	public String getOrg_abbreviation() {
		return org_abbreviation;
	}
	public void setOrg_abbreviation(String org_abbreviation) {
		this.org_abbreviation = org_abbreviation;
	}
	public String getOrg_desc() {
		return org_desc;
	}
	public void setOrg_desc(String org_desc) {
		this.org_desc = org_desc;
	}
	public String getOrg_level() {
		return org_level;
	}
	public void setOrg_level(String org_level) {
		this.org_level = org_level;
	}
	public String getLocked_if() {
		return locked_if;
	}
	public void setLocked_if(String locked_if) {
		this.locked_if = locked_if;
	}
}
