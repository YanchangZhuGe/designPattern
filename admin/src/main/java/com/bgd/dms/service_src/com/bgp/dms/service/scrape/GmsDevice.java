package com.bgp.dms.service.scrape;
/**�豸��**/
public class GmsDevice {
	private String scrape_detailed_id;// ����id ,
	private String dev_name   ;// �豸����,
	private String dev_model  ;// ����ͺ�,
	private String dev_type   ;// �豸���,
	private String asset_value;// ԭֵ,
	private String net_value;// ԭֵ,
	private String scrape_date;// ��������,
	private String scrape_type;//��������,0����������1��������̭2�����3���̿�
	private String bak;//��ע
	private String dispose_method_flag;//���÷�ʽ
	private String batch_number;//���ı��
	private String dev_coding;//ERP�豸����
	private String asset_coding;//Amis�ʲ�����
	public String getScrape_detailed_id() {
		return scrape_detailed_id;
	}
	public void setScrape_detailed_id(String scrape_detailed_id) {
		this.scrape_detailed_id = scrape_detailed_id;
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
	public String getDev_type() {
		return dev_type;
	}
	public void setDev_type(String dev_type) {
		this.dev_type = dev_type;
	}
	public String getAsset_value() {
		return asset_value;
	}
	public void setAsset_value(String asset_value) {
		this.asset_value = asset_value;
	}
	public String getScrape_date() {
		return scrape_date;
	}
	public void setScrape_date(String scrape_date) {
		this.scrape_date = scrape_date;
	}
	public String getScrape_type() {
		return scrape_type;
	}
	public void setScrape_type(String scrape_type) {
		this.scrape_type = scrape_type;
	}
	public String getBak() {
		return bak;
	}
	public void setBak(String bak) {
		this.bak = bak;
	}
	public String getDispose_method_flag() {
		return dispose_method_flag;
	}
	public void setDispose_method_flag(String dispose_method_flag) {
		this.dispose_method_flag = dispose_method_flag;
	}
	public String getBatch_number() {
		return batch_number;
	}
	public void setBatch_number(String batch_number) {
		this.batch_number = batch_number;
	}
	public String getDev_coding() {
		return dev_coding;
	}
	public void setDev_coding(String dev_coding) {
		this.dev_coding = dev_coding;
	}
	public String getAsset_coding() {
		return asset_coding;
	}
	public void setAsset_coding(String asset_coding) {
		this.asset_coding = asset_coding;
	}
	public String getNet_value() {
		return net_value;
	}
	public void setNet_value(String net_value) {
		this.net_value = net_value;
	}
}
