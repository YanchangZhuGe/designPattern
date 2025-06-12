package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;
import java.util.Date;
/**
 * 维修返还单明细
 * @author liug
 *
 */
public class GmsDeviceColRepDetail implements Serializable {

	/** serialVersionUID*/
	private static final long serialVersionUID = 1L;
	/**id*/
	private String id;
	/**维修返还单id*/
	private String rep_return_id;
    /**维修单id*/
	private String repairform_id;
    /**台账id*/
	private String dev_acc_id;
    /**dev_seq*/
	private String epc;
    /**故障类别0普通、1特殊*/
	private String error_level;
    /**故障现象0共模不过、1不通、2数传、3死站、4年检不过、5单边通、6本道不通、7共模、8本道、9初始化不过、10漏电、11畸变不过、12单边不通、13短路、14物理损坏*/
	private String error_type;
    /**备注*/
	private String remark;
    /**送修单明细id*/
	private String rep_form_det_id;
	/**设备名称*/
	private String dev_name;
	/**规格型号*/
	private String dev_model;
	/**实物标识号*/
	private String dev_sign;
    /**删除标记*/
	private String bsflag;
	/**维修明细类型  2015-03-10 **/
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
