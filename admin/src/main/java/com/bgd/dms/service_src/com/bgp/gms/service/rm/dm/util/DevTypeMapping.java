package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;

/**
 * 类型映射对象
 * @author liyongfeng
 *
 */
public class DevTypeMapping implements Serializable {

	private static final long serialVersionUID = -624345758997355327L;
	
	private int type_seq;
	private String dev_type_id;
	private String dev_type_name;
	private String device_id;
	private String device_name;
	private String device_model;
	
	//get,set
	public int getType_seq() {
		return type_seq;
	}
	public void setType_seq(int type_seq) {
		this.type_seq = type_seq;
	}
	public String getDev_type_id() {
		return dev_type_id;
	}
	public void setDev_type_id(String dev_type_id) {
		this.dev_type_id = dev_type_id;
	}
	public String getDev_type_name() {
		return dev_type_name;
	}
	public void setDev_type_name(String dev_type_name) {
		this.dev_type_name = dev_type_name;
	}
	public String getDevice_id() {
		return device_id;
	}
	public void setDevice_id(String device_id) {
		this.device_id = device_id;
	}
	public String getDevice_name() {
		return device_name;
	}
	public void setDevice_name(String device_name) {
		this.device_name = device_name;
	}
	public String getDevice_model() {
		return device_model;
	}
	public void setDevice_model(String device_model) {
		this.device_model = device_model;
	}
}
