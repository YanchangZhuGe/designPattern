package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;
import java.util.Date;
/**
 * ����ά�޵�  
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
	/**���޵����*/
	private String repair_form_code;
    /**���޵�����*/
	private String repair_form_name;
    /**��������*/
	private Date apply_date;
    /**������Ŀ     (������ʾ����)*/
	private String own_project;
    /**���޵�λ    (������ʾ����)*/
	private String req_comp;
    /**ά�޵�λ    (������ʾ����)*/
	private String todo_comp;
    /**������    (������ʾ����)*/
	private String req_user;
    /**��������*/
	private Date req_date;
    /**����״̬ 0���ơ�1��Ч��2����*/
	private String status ;
    /**��ע*/
	private String remark;
    /**ɾ�����*/
	private String bsflag;
    /**������     (������ʾ����)*/
	private String creator;
    /**����ʱ��*/
	private Date create_date;
    /**�޸���    (������ʾ����)*/
	private String modifier;
    /**�޸�ʱ��*/
	private Date modifi_date;
    /** 0������   1������   2�ѽ���*/
	private String process_stat;
	
	/**2015/03/11���0:δ����  1:�ѷ���**/
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
