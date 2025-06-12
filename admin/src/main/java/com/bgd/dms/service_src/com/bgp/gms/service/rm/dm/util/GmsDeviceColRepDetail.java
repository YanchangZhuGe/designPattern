package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;
import java.util.Date;
/**
 * ά�޷�������ϸ
 * @author liug
 *
 */
public class GmsDeviceColRepDetail implements Serializable {

	/** serialVersionUID*/
	private static final long serialVersionUID = 1L;
	/**id*/
	private String id;
	/**ά�޷�����id*/
	private String rep_return_id;
    /**ά�޵�id*/
	private String repairform_id;
    /**̨��id*/
	private String dev_acc_id;
    /**dev_seq*/
	private String epc;
    /**�������0��ͨ��1����*/
	private String error_level;
    /**��������0��ģ������1��ͨ��2������3��վ��4��첻����5����ͨ��6������ͨ��7��ģ��8������9��ʼ��������10©�硢11���䲻����12���߲�ͨ��13��·��14������*/
	private String error_type;
    /**��ע*/
	private String remark;
    /**���޵���ϸid*/
	private String rep_form_det_id;
	/**�豸����*/
	private String dev_name;
	/**����ͺ�*/
	private String dev_model;
	/**ʵ���ʶ��*/
	private String dev_sign;
    /**ɾ�����*/
	private String bsflag;
	/**ά����ϸ����  2015-03-10 **/
	private String rep_type;
	
	public String getrep_type() {
		return rep_type;
	}
	public void setrep_type(String rep_type) {
		this.rep_type = rep_type;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getRep_return_id() {
		return rep_return_id;
	}
	public void setRep_return_id(String rep_return_id) {
		this.rep_return_id = rep_return_id;
	}
	public String getRepairform_id() {
		return repairform_id;
	}
	public void setRepairform_id(String repairform_id) {
		this.repairform_id = repairform_id;
	}
	public String getDev_acc_id() {
		return dev_acc_id;
	}
	public void setDev_acc_id(String dev_acc_id) {
		this.dev_acc_id = dev_acc_id;
	}
	
	public String getEpc() {
		return epc;
	}
	public void setEpc(String epc) {
		this.epc = epc;
	}
	public String getError_level() {
		return error_level;
	}
	public void setError_level(String error_level) {
		this.error_level = error_level;
	}
	public String getError_type() {
		return error_type;
	}
	public void setError_type(String error_type) {
		this.error_type = error_type;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getRep_form_det_id() {
		return rep_form_det_id;
	}
	public void setRep_form_det_id(String rep_form_det_id) {
		this.rep_form_det_id = rep_form_det_id;
	}
	public String getBsflag() {
		return bsflag;
	}
	public void setBsflag(String bsflag) {
		this.bsflag = bsflag;
	}
	public String getDev_name() {
		return dev_name;
	}
	public void setDev_name(String dev_name) {
		this.dev_name = dev_name;
	}
	public String getDev_model() {
		return dev_model;
	}
	public void setDev_model(String dev_model) {
		this.dev_model = dev_model;
	}
	public String getDev_sign() {
		return dev_sign;
	}
	public void setDev_sign(String dev_sign) {
		this.dev_sign = dev_sign;
	}
	
}
