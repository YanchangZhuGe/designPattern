package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;

/**
 * 标签绑定接口
 * @author liyongfeng
 *
 */
public class RFIDBind implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1362930383953835201L;
	
	private String id;
	private String epc_code;
	private String tagid;
	private String dev_type;//设备类型(小类)
	private int type_seq;//类型序列号
	//private int dev_seq;//设备序列号
	private String dev_sign;
	private String rfid_desc;//描述信息
	private String creator;
	private String modifier;
	private String dev_acc_id;
	private String saved_flag;//1:绑定 2：解除绑定
	
	/**
	 * 创建台账表需要字段2015/05/12 添加
	 * 赵洋
	 * @return
	 */
	private String dev_name;   //设备名称
	
	private String dev_model;  //设备类型

	
	
	
	public String getDev_name() {
		return dev_name;
	}
	public void setDev_name(String devName) {
		dev_name = devName;
	}
	public String getDev_model() {
		return dev_model;
	}
	public void setDev_model(String devModel) {
		dev_model = devModel;
	}
	public String getSaved_flag() {
		return saved_flag;
	}
	public void setSaved_flag(String saved_flag) {
		this.saved_flag = saved_flag;
	}
	public String getDev_acc_id() {
		return dev_acc_id;
	}
	public void setDev_acc_id(String dev_acc_id) {
		this.dev_acc_id = dev_acc_id;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getEpc_code() {
		return epc_code;
	}
	public void setEpc_code(String epc_code) {
		this.epc_code = epc_code;
	}
	public String getTagid() {
		return tagid;
	}
	public void setTagid(String tagid) {
		this.tagid = tagid;
	}
	public String getDev_type() {
		return dev_type;
	}
	public void setDev_type(String dev_type) {
		this.dev_type = dev_type;
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
	public String getDev_sign() {
		return dev_sign;
	}
	public void setDev_sign(String dev_sign) {
		this.dev_sign = dev_sign;
	}
	public String getRfid_desc() {
		return rfid_desc;
	}
	public void setRfid_desc(String rfid_desc) {
		this.rfid_desc = rfid_desc;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String getModifier() {
		return modifier;
	}
	public void setModifier(String modifier) {
		this.modifier = modifier;
	}
	@Override
	public String toString() {
		return "RFIDBind [creator=" + creator + ", dev_acc_id=" + dev_acc_id
				+ ", dev_model=" + dev_model + ", dev_name=" + dev_name
				+ ", dev_sign=" + dev_sign + ", dev_type=" + dev_type
				+ ", epc_code=" + epc_code + ", id=" + id + ", modifier="
				+ modifier + ", rfid_desc=" + rfid_desc + ", saved_flag="
				+ saved_flag + ", tagid=" + tagid + ", type_seq=" + type_seq
				+ "]";
	}
	
	
}
