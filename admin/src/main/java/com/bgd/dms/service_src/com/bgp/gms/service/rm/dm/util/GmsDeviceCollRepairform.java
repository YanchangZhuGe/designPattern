package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;
import java.util.Date;
/**
 * 送内维修单  
 * @author liug
 *
 */
public class GmsDeviceCollRepairform implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/**id*/
	private String id;
	/**送修单编号*/
	private String repair_form_code;
    /**送修单名称*/
	private String repair_form_name;
    /**申请日期*/
	private Date apply_date;
    /**所属项目     (联表显示名称)*/
	private String own_project;
    /**送修单位    (联表显示名称)*/
	private String req_comp;
    /**维修单位    (联表显示名称)*/
	private String todo_comp;
    /**送修人    (联表显示名称)*/
	private String req_user;
    /**送修日期*/
	private Date req_date;
    /**单据状态 0编制、1生效、2作废*/
	private String status ;
    /**备注*/
	private String remark;
    /**删除标记*/
	private String bsflag;
    /**创建者     (联表显示名称)*/
	private String creator;
    /**创建时间*/
	private Date create_date;
    /**修改者    (联表显示名称)*/
	private String modifier;
    /**修改时间*/
	private Date modifi_date;
    /** 0待接收   1接收中   2已接收*/
	private String process_stat;
	
	/**2015/03/11添加0:未返还  1:已返还**/
    private String return_flg;
    
    public String getReturn_flg() {
		return return_flg;
	}
	public void setReturn_flg(String returnFlg) {
		return_flg = returnFlg;
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getRepair_form_code() {
		return repair_form_code;
	}
	public void setRepair_form_code(String repair_form_code) {
		this.repair_form_code = repair_form_code;
	}
	public String getRepair_form_name() {
		return repair_form_name;
	}
	public void setRepair_form_name(String repair_form_name) {
		this.repair_form_name = repair_form_name;
	}
	public Date getApply_date() {
		return apply_date;
	}
	public void setApply_date(Date apply_date) {
		this.apply_date = apply_date;
	}
	public String getOwn_project() {
		return own_project;
	}
	public void setOwn_project(String own_project) {
		this.own_project = own_project;
	}
	public String getReq_comp() {
		return req_comp;
	}
	public void setReq_comp(String req_comp) {
		this.req_comp = req_comp;
	}
	public String getTodo_comp() {
		return todo_comp;
	}
	public void setTodo_comp(String todo_comp) {
		this.todo_comp = todo_comp;
	}
	public String getReq_user() {
		return req_user;
	}
	public void setReq_user(String req_user) {
		this.req_user = req_user;
	}
	public Date getReq_date() {
		return req_date;
	}
	public void setReq_date(Date req_date) {
		this.req_date = req_date;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getBsflag() {
		return bsflag;
	}
	public void setBsflag(String bsflag) {
		this.bsflag = bsflag;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public Date getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}
	public String getModifier() {
		return modifier;
	}
	public void setModifier(String modifier) {
		this.modifier = modifier;
	}
	public Date getModifi_date() {
		return modifi_date;
	}
	public void setModifi_date(Date modifi_date) {
		this.modifi_date = modifi_date;
	}
	public String getProcess_stat() {
		return process_stat;
	}
	public void setProcess_stat(String process_stat) {
		this.process_stat = process_stat;
	}
	
}
