package com.bgp.gms.service.rm.dm.util;

import java.io.Serializable;
import java.util.Date;
/**
 * ����ά�޵���ϸ
 * @author liug
 *
 */
public class GmsDeviceCollRepairSub implements Serializable {

	/** serialVersionUID*/
	private static final long serialVersionUID = 1L;
	/**id*/
	private String id;
	/**ά�޵�id*/
	private String repairform_id;
	/**�豸���Ψһ���к�*/
	private int type_seq;
	/**�豸����*/
	private String epc;
	/**̨��id*/
	private String dev_acc_id;
	/**�������0�޹��ϡ�1��ͨ��2����*/
	private String error_type;
	/**��������0�޹��ϡ�1��ͨ��2������3��վ��4��첻����5����ͨ��6������ͨ��7��ģ��8������9��ʼ��������10©�硢11���䲻����12���߲�ͨ��13��·��14������15��ģ����*/
	private String error_desc;
	/**�豸״̬  0����  1����  2�޷�ά��  3ά����� 4����ά��*/
	private String dev_status;
	/**��ע*/
	private String remark;
	/**�豸����*/
	private String dev_name;
	/**����ͺ�*/
	private String dev_model;
	/**ʵ���ʶ��*/
	private String dev_sign;
	/**ɾ�����*/
    private String bsflag;
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
