package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;

/**
 * �����豸��ϸ
 * @author liyongfeng
 *
 */
public class RFIDDevOut implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6342824224817344218L;
	
	private String id;
	private String device_outinfo_id;//���ⵥid
	private String device_oif_subid;//���ⵥ�ӱ�id
	private String dev_acc_id;//�豸id
	private String device_id;//��������id
	private String dev_sign;//ʵ���ʶ��
	private int type_seq;//�������к�
	//private int dev_seq;//�豸���к�
	//private String creator;
	//private Date create_date;
	
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
	public String getDevice_outinfo_id() {
		return device_outinfo_id;
	}
	public void setDevice_outinfo_id(String device_outinfo_id) {
		this.device_outinfo_id = device_outinfo_id;
	}
	public String getDevice_oif_subid() {
		return device_oif_subid;
	}
	public void setDevice_oif_subid(String device_oif_subid) {
		this.device_oif_subid = device_oif_subid;
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
