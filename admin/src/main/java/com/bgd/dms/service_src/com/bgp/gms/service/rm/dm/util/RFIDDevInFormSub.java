package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;

/**
 * 入库单子表对象
 * @author liyongfeng
 *
 */
public class RFIDDevInFormSub implements Serializable {

	private static final long serialVersionUID = -8550168154699560738L;
	
	private String sub_id;//入库单子表id
	private String bill_id;//入库单id
	private String device_id;//批量设备类型id
	private String device_name;//批量设备名称
	private String device_model;//批量设备类型
	private int bill_count;//调配入库数量
	private int out_count;//小队目前在帐数量(小队还应该归还仓库的设备数量)
	
	private String unitName;//单位名称
	
	public String getUnitName() {
		return unitName;
	}
	public void setUnitName(String unitName) {
		this.unitName = unitName;
	}
	public String getSub_id() {
		return sub_id;
	}
	public void setSub_id(String sub_id) {
		this.sub_id = sub_id;
	}
	public String getBill_id() {
		return bill_id;
	}
	public void setBill_id(String bill_id) {
		this.bill_id = bill_id;
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
	public int getBill_count() {
		return bill_count;
	}
	public void setBill_count(int bill_count) {
		this.bill_count = bill_count;
	}
	public int getOut_count() {
		return out_count;
	}
	public void setOut_count(int out_count) {
		this.out_count = out_count;
	}
}
