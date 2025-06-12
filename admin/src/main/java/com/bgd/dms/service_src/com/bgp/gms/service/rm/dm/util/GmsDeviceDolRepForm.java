package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;
import java.util.Date;
/**
 * 维修返还单
 * @author liug
 *
 */
public class GmsDeviceDolRepForm implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/**id*/
	private String id;
	/**送修单id*/
	private String send_id;
    /**返还单位ID  (联表显示名称)*/
	private String back_org_id;
    /**返还单名称*/
	private String backapp_name;
    /**申请时间*/
	private Date backdate;
    /**申请人ID   (联表显示名称)*/
	private String back_employee_id;
    /**备注*/
	private String remark;
    /**接收组织机构ID*/
	private String org_id;
    /**接收单位名称*/
	private String org_name;
    /**接收组织机构隶属ID*/
	private String org_subjection_id;
    /**删除标志0否1是*/
	private String bsflag;
    /**修改日期*/
	private Date create_date;
    /**创建人id  (联表显示名称)*/
	private String creator_id;
    /**创建日期*/
	private Date modifi_date;
    /**修改人id    (联表显示名称)*/
	private String updator_id;
    /**维修单类型 0送内维修  1送外维  (联表显示名称)*/
	private String rep_type;
    /**返还单编号*/
	private String backapp_no;
    /**状态0编制、1生效、2作废*/
	private String status;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getSend_id() {
		return send_id;
	}
	public void setSend_id(String send_id) {
		this.send_id = send_id;
	}
	public String getBack_org_id() {
		return back_org_id;
	}
	public void setBack_org_id(String back_org_id) {
		this.back_org_id = back_org_id;
	}
	public String getBackapp_name() {
		return backapp_name;
	}
	public void setBackapp_name(String backapp_name) {
		this.backapp_name = backapp_name;
	}
	public Date getBackdate() {
		return backdate;
	}
	public void setBackdate(Date backdate) {
		this.backdate = backdate;
	}
	public String getBack_employee_id() {
		return back_employee_id;
	}
	public void setBack_employee_id(String back_employee_id) {
		this.back_employee_id = back_employee_id;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
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
	public String getOrg_subjection_id() {
		return org_subjection_id;
	}
	public void setOrg_subjection_id(String org_subjection_id) {
		this.org_subjection_id = org_subjection_id;
	}
	public String getBsflag() {
		return bsflag;
	}
	public void setBsflag(String bsflag) {
		this.bsflag = bsflag;
	}
	public Date getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}
	public String getCreator_id() {
		return creator_id;
	}
	public void setCreator_id(String creator_id) {
		this.creator_id = creator_id;
	}
	public Date getModifi_date() {
		return modifi_date;
	}
	public void setModifi_date(Date modifi_date) {
		this.modifi_date = modifi_date;
	}
	public String getUpdator_id() {
		return updator_id;
	}
	public void setUpdator_id(String updator_id) {
		this.updator_id = updator_id;
	}
	public String getRep_type() {
		return rep_type;
	}
	public void setRep_type(String rep_type) {
		this.rep_type = rep_type;
	}
	public String getBackapp_no() {
		return backapp_no;
	}
	public void setBackapp_no(String backapp_no) {
		this.backapp_no = backapp_no;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
}
