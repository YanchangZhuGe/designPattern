package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;

public class RFIDDevOutFormDTO implements Serializable {

	private static final long serialVersionUID = -1083517425523189979L;
	
	private String org;
	private String in_org;
	private String out_org;
	private String project_info_no;
	private String project_name;
	private String bill_id;
	private String outinfo_no;
	private String state;
	private String opr_state;
	private String devouttype;
	private String create_date;
	private String creator_id;
	private String modifi_date;
	private String updator_id;
	private String bsflag;
	
	
	public String getBsflag() {
		return bsflag;
	}
	public void setBsflag(String bsflag) {
		this.bsflag = bsflag;
	}
	public String getOrg() {
		return org;
	}
	public void setOrg(String org) {
		this.org = org;
	}
	public String getIn_org() {
		return in_org;
	}
	public void setIn_org(String in_org) {
		this.in_org = in_org;
	}
	public String getOut_org() {
		return out_org;
	}
	public void setOut_org(String out_org) {
		this.out_org = out_org;
	}
	public String getProject_info_no() {
		return project_info_no;
	}
	public void setProject_info_no(String project_info_no) {
		this.project_info_no = project_info_no;
	}
	public String getProject_name() {
		return project_name;
	}
	public void setProject_name(String project_name) {
		this.project_name = project_name;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}
	public String getOutinfo_no() {
		return outinfo_no;
	}
	public void setOutinfo_no(String outinfo_no) {
		this.outinfo_no = outinfo_no;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getOpr_state() {
		return opr_state;
	}
	public void setOpr_state(String opr_state) {
		this.opr_state = opr_state;
	}
	public String getDevouttype() {
		return devouttype;
	}
	public void setDevouttype(String devouttype) {
		this.devouttype = devouttype;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	public String getCreator_id() {
		return creator_id;
	}
	public void setCreator_id(String creator_id) {
		this.creator_id = creator_id;
	}
	public String getModifi_date() {
		return modifi_date;
	}
	public void setModifi_date(String modifi_date) {
		this.modifi_date = modifi_date;
	}
	public String getUpdator_id() {
		return updator_id;
	}
	public void setUpdator_id(String updator_id) {
		this.updator_id = updator_id;
	}
}
