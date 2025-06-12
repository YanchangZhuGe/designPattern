package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;
import java.util.Date;

public class RFIDDevInFormDTO implements Serializable {
	
	private static final long serialVersionUID = -1521044114387063829L;
	
	private String bill_id;//��ⵥ����id
	private String bill_no;//��ⵥ���
	private String project_info_id;//��Ŀid
	private String project_info_name;//��Ŀ����
	private String backapp_name;//����������
	private Date backdate;//��������
	private String back_employee;//����������
	private Date create_date;//������������
	private String creator;//��������������
	private Date modifi_date;//�����޸�ʱ��
	private String updator;//�����޸�������
	private String org;//����������������
	private String receive_org;//�豸���յ�λ����
	private String backmix_org;//�豸���䵥λ����
	private String backmix_username;//�豸����������
	private String remark;//���
	
	private String out_org;//�豸�黹��λ����
	private String mixapp_name;//���䵥����
	
	
	public String getMixapp_name() {
		return mixapp_name;
	}
	public void setMixapp_name(String mixapp_name) {
		this.mixapp_name = mixapp_name;
	}
	public String getOut_org() {
		return out_org;
	}
	public void setOut_org(String out_org) {
		this.out_org = out_org;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}
	public String getBill_no() {
		return bill_no;
	}
	public void setBill_no(String bill_no) {
		this.bill_no = bill_no;
	}
	public String getProject_info_id() {
		return project_info_id;
	}
	public void setProject_info_id(String project_info_id) {
		this.project_info_id = project_info_id;
	}
	public String getProject_info_name() {
		return project_info_name;
	}
	public void setProject_info_name(String project_info_name) {
		this.project_info_name = project_info_name;
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
	public String getBack_employee() {
		return back_employee;
	}
	public void setBack_employee(String back_employee) {
		this.back_employee = back_employee;
	}
	public Date getCreate_date() {
		return create_date;
	}
	public void setCreate_date(Date create_date) {
		this.create_date = create_date;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public Date getModifi_date() {
		return modifi_date;
	}
	public void setModifi_date(Date modifi_date) {
		this.modifi_date = modifi_date;
	}
	public String getUpdator() {
		return updator;
	}
	public void setUpdator(String updator) {
		this.updator = updator;
	}
	public String getOrg() {
		return org;
	}
	public void setOrg(String org) {
		this.org = org;
	}
	public String getReceive_org() {
		return receive_org;
	}
	public void setReceive_org(String receive_org) {
		this.receive_org = receive_org;
	}
	public String getBackmix_org() {
		return backmix_org;
	}
	public void setBackmix_org(String backmix_org) {
		this.backmix_org = backmix_org;
	}
	public String getBackmix_username() {
		return backmix_username;
	}
	public void setBackmix_username(String backmix_username) {
		this.backmix_username = backmix_username;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
}
