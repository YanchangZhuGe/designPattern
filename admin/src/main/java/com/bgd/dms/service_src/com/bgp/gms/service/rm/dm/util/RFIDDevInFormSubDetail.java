package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;

/**
 * 入库单子表明细对象
 * @author liyongfeng
 *
 */
public class RFIDDevInFormSubDetail implements Serializable {

	static final long serialVersionUID = -9010660470025148714L;
	
	private String detail_id;//id
	private String bill_id;//入库单id
	private String sub_id;//入库单子表id
	private String batch_id;//
	private String dev_acc_id;//设备id
	private String dev_sign;//设备标识号
	private int type_seq;//类别序列号
	//private int dev_seq;//设备序列号
	private String device_id;//批量设备类别id
	private String project_info_no;//项目id
	private String project_info_name;//项目名称
	private int server_flag;//
	private int saved_flag;//
	
	private String epc;
	
	public String getEpc() {
		return epc;
	}
	public void setEpc(String epc) {
		this.epc = epc;
	}
	public String getDetail_id() {
		return detail_id;
	}
	public void setDetail_id(String detail_id) {
		this.detail_id = detail_id;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
	}
	public String getSub_id() {
		return sub_id;
	}
	public void setSub_id(String sub_id) {
		this.sub_id = sub_id;
	}
	public String getBatch_id() {
		return batch_id;
	}
	public void setBatch_id(String batch_id) {
		this.batch_id = batch_id;
	}
	public String getDev_acc_id() {
		return dev_acc_id;
	}
	public void setDev_acc_id(String dev_acc_id) {
		this.dev_acc_id = dev_acc_id;
	}
	public String getDev_sign() {
		return dev_sign;
	}
	public void setDev_sign(String dev_sign) {
		this.dev_sign = dev_sign;
	}
	public int getType_seq() {
		return type_seq;
	}
	public void setType_seq(int type_seq) {
		this.type_seq = type_seq;
	}
	/*public int getDev_seq() {
		return dev_seq;
	}
	public void setDev_seq(int dev_seq) {
		this.dev_seq = dev_seq;
	}*/
	public String getDevice_id() {
		return device_id;
	}
	public void setDevice_id(String device_id) {
		this.device_id = device_id;
	}
	public String getProject_info_no() {
		return project_info_no;
	}
	public void setProject_info_no(String project_info_no) {
		this.project_info_no = project_info_no;
	}
	public String getProject_info_name() {
		return project_info_name;
	}
	public void setProject_info_name(String project_info_name) {
		this.project_info_name = project_info_name;
	}
	public int getServer_flag() {
		return server_flag;
	}
	public void setServer_flag(int server_flag) {
		this.server_flag = server_flag;
	}
	public int getSaved_flag() {
		return saved_flag;
	}
	public void setSaved_flag(int saved_flag) {
		this.saved_flag = saved_flag;
	}
}
