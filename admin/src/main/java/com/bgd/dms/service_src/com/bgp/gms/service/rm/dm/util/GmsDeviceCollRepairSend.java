package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;
import java.util.Date;
/**
 * ����ά�޵�
 * @author liug
 *
 */
public class GmsDeviceCollRepairSend implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/**id*/
	private String id;
	/**����ά�޵���*/
    private String repair_form_no;
    /**��������*/
    private Date apply_date;
    /**������Ŀ      (������ʾ����)*/
    private String own_project;
    /**���޵�λ  (������ʾ����)*/
    private String apply_org;
    /**ά�޵�λ*/
    private String service_company;
    /**����  (������ʾ����)*/
    private String currency;
    /**����*/
    private double rate;
    /**Ԥ��ԭ�ҽ��*/
    private double buget_our;
    /**Ԥ�Ʊ��ҽ��*/
    private double buget_local;
    /**����״̬0���ơ�1��Ч��2����*/
    private String status;
    /**��ע*/
    private String remark;
    /**ɾ�����*/
    private String bsflag;
    /**������ (������ʾ����)*/
    private String creator;
    /**����ʱ��*/
    private Date create_date;
    /**�޸��� (������ʾ����)*/
    private String modifier;
    /**�޸�ʱ��*/
    private Date modifi_date;
    /**���޵�����*/
    private String  repair_form_name;
    
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
	public String getRepair_form_no() {
		return repair_form_no;
	}
	public void setRepair_form_no(String repair_form_no) {
		this.repair_form_no = repair_form_no;
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
	public String getApply_org() {
		return apply_org;
	}
	public void setApply_org(String apply_org) {
		this.apply_org = apply_org;
	}
	public String getService_company() {
		return service_company;
	}
	public void setService_company(String service_company) {
		this.service_company = service_company;
	}
	public String getCurrency() {
		return currency;
	}
	public void setCurrency(String currency) {
		this.currency = currency;
	}
	public double getRate() {
		return rate;
	}
	public void setRate(double rate) {
		this.rate = rate;
	}
	public double getBuget_our() {
		return buget_our;
	}
	public void setBuget_our(double buget_our) {
		this.buget_our = buget_our;
	}
	public double getBuget_local() {
		return buget_local;
	}
	public void setBuget_local(double buget_local) {
		this.buget_local = buget_local;
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
	public String getRepair_form_name() {
		return repair_form_name;
	}
	public void setRepair_form_name(String repair_form_name) {
		this.repair_form_name = repair_form_name;
	} 
    
}
