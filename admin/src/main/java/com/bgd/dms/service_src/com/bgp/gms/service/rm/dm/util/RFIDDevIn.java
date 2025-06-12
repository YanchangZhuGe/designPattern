package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;

public class RFIDDevIn implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1477638782033669561L;
	private String id;
	private String device_coll_mixinfo_id;//返还调配单ID
	private String device_coll_backdet_id;//返还调配单子表ID
	private String dev_acc_id;//设备ID
	private String device_id;//批量类型ID
	private String dev_sign;//实物标识号
	private int type_seq;//类型序列号
	//private int dev_seq;//设备序列号
	
	private String epc;
	
	
	public String getEpc() {
		return epc;
	}
	public void setEpc(String epc) {
		this.epc = epc;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getDevice_coll_mixinfo_id() {
		return device_coll_mixinfo_id;
	}
	public void setDevice_coll_mixinfo_id(String device_coll_mixinfo_id) {
		this.device_coll_mixinfo_id = device_coll_mixinfo_id;
	}
	public String getDevice_coll_backdet_id() {
		return device_coll_backdet_id;
	}
	public void setDevice_coll_backdet_id(String device_coll_backdet_id) {
		this.device_coll_backdet_id = device_coll_backdet_id;
	}
	public String getDev_acc_id() {
		return dev_acc_id;
	}
	public void setDev_acc_id(String dev_acc_id) {
		this.dev_acc_id = dev_acc_id;
	}
	public String getDevice_id() {
		return device_id;
	}
	public void setDevice_id(String device_id) {
		this.device_id = device_id;
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
}
