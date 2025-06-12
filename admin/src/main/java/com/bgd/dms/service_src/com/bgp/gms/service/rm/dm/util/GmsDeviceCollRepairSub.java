package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;
import java.util.Date;
/**
 * 送内维修单明细
 * @author liug
 *
 */
public class GmsDeviceCollRepairSub implements Serializable {

	/** serialVersionUID*/
	private static final long serialVersionUID = 1L;
	/**id*/
	private String id;
	/**维修单id*/
	private String repairform_id;
	/**设备类别唯一序列号*/
	private int type_seq;
	/**设备序列*/
	private String epc;
	/**台账id*/
	private String dev_acc_id;
	/**故障类别0无故障、1普通、2特殊*/
	private String error_type;
	/**故障现象0无故障、1不通、2数传、3死站、4年检不过、5单边通、6本道不通、7共模、8本道、9初始化不过、10漏电、11畸变不过、12单边不通、13短路、14物理损坏15共模不过*/
	private String error_desc;
	/**设备状态  0待修  1在修  2无法维修  3维修完成 4不需维修*/
	private String dev_status;
	/**备注*/
	private String remark;
	/**设备名称*/
	private String dev_name;
	/**规格型号*/
	private String dev_model;
	/**实物标识号*/
	private String dev_sign;
	/**删除标记*/
    private String bsflag;
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
	public String getRepairform_id() {
		return repairform_id;
	}
	public void setRepairform_id(String repairform_id) {
		this.repairform_id = repairform_id;
	}
	public int getType_seq() {
		return type_seq;
	}
	public void setType_seq(int type_seq) {
		this.type_seq = type_seq;
	}
	
	public String getEpc() {
		return epc;
	}
	public void setEpc(String epc) {
		this.epc = epc;
	}
	public String getDev_acc_id() {
		return dev_acc_id;
	}
	public void setDev_acc_id(String dev_acc_id) {
		this.dev_acc_id = dev_acc_id;
	}
	public String getError_type() {
		return error_type;
	}
	public void setError_type(String error_type) {
		this.error_type = error_type;
	}
	public String getError_desc() {
		return error_desc;
	}
	public void setError_desc(String error_desc) {
		this.error_desc = error_desc;
	}
	public String getDev_status() {
		return dev_status;
	}
	public void setDev_status(String dev_status) {
		this.dev_status = dev_status;
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
