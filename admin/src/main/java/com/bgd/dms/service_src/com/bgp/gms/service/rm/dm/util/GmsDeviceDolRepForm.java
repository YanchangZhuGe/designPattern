package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;
import java.util.Date;
/**
 * ά�޷�����
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
	/**���޵�id*/
	private String send_id;
    /**������λID  (������ʾ����)*/
	private String back_org_id;
    /**����������*/
	private String backapp_name;
    /**����ʱ��*/
	private Date backdate;
    /**������ID   (������ʾ����)*/
	private String back_employee_id;
    /**��ע*/
	private String remark;
    /**������֯����ID*/
	private String org_id;
    /**���յ�λ����*/
	private String org_name;
    /**������֯��������ID*/
	private String org_subjection_id;
    /**ɾ����־0��1��*/
	private String bsflag;
    /**�޸�����*/
	private Date create_date;
    /**������id  (������ʾ����)*/
	private String creator_id;
    /**��������*/
	private Date modifi_date;
    /**�޸���id    (������ʾ����)*/
	private String updator_id;
    /**ά�޵����� 0����ά��  1����ά  (������ʾ����)*/
	private String rep_type;
    /**���������*/
	private String backapp_no;
    /**״̬0���ơ�1��Ч��2����*/
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
