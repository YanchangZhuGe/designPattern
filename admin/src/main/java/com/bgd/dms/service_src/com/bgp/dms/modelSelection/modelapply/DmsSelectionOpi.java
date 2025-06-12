package com.bgp.dms.modelSelection.modelapply;

import java.io.Serializable;

public class DmsSelectionOpi implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private String opi_id; 			// 产品ID
	private String opi_name; 		// 产品名称型号
	private String brand; 			// 商标
	private String production; 		// 生产单位
	private String last_year_yield; 	// 上年产量
	private String main_user_object; 	// 主要用户对象
	private String product_info; 		// 产品简介
	private String skill_parameter; 	// 技术参数
	private String test_using_report; 	// 测试使用报告
	private String user_prove; 			// 应用证明
	private String production_unit_aptitude; 		// 生产单位资质
	private String other; 				// 其他附件
	private String applystate; 			// 申请状态
	private String apply_unit_code; 	// 申请单位代码
	private String apply_unit; 			// 申请单位
	private String apply_unit_reason;	// 申请单位理由
	private String apply_unit_idea; 	// 申请单位意见
	private String principal; 			// 负责人
	private String approve_date; 		// 批准时间
	private String review_confirms; 	// 附件(评审证明)
	private String panel_idea; 			// 专家组意见
	private String panel_principal; 	// 专家组负责人
	private String panel_review_date; 	// 专家组评审日期
	private String equipment_idea; 		// 设备物资处意见
	private String equipment_principal; 	// 设备物资处负责人
	private String equipment_review_date; 	// 设备物资处评审日期
	private String review_result; 		// 评审结果
	private String review_prove; 		// 评审证明
	private String apply_date; 			// 申请时间
	private String review_state; 		// 评审状态
	private String creater; 			// 创建人
	private String create_date; 		// 创建时间
	private String update_tor; 			// 更新人
	private String modify_date; 		// 更新时间
	private String bsflag; 				// 删除标记
	public String getOpi_id() {
		return opi_id;
	}
	public void setOpi_id(String opi_id) {
		this.opi_id = opi_id;
	}
	public String getOpi_name() {
		return opi_name;
	}
	public void setOpi_name(String opi_name) {
		this.opi_name = opi_name;
	}
	public String getBrand() {
		return brand;
	}
	public void setBrand(String brand) {
		this.brand = brand;
	}
	public String getProduction() {
		return production;
	}
	public void setProduction(String production) {
		this.production = production;
	}
	public String getLast_year_yield() {
		return last_year_yield;
	}
	public void setLast_year_yield(String last_year_yield) {
		this.last_year_yield = last_year_yield;
	}
	public String getMain_user_object() {
		return main_user_object;
	}
	public void setMain_user_object(String main_user_object) {
		this.main_user_object = main_user_object;
	}
	public String getProduct_info() {
		return product_info;
	}
	public void setProduct_info(String product_info) {
		this.product_info = product_info;
	}
	public String getSkill_parameter() {
		return skill_parameter;
	}
	public void setSkill_parameter(String skill_parameter) {
		this.skill_parameter = skill_parameter;
	}
	public String getTest_using_report() {
		return test_using_report;
	}
	public void setTest_using_report(String test_using_report) {
		this.test_using_report = test_using_report;
	}
	public String getUser_prove() {
		return user_prove;
	}
	public void setUser_prove(String user_prove) {
		this.user_prove = user_prove;
	}
	public String getProduction_unit_aptitude() {
		return production_unit_aptitude;
	}
	public void setProduction_unit_aptitude(String production_unit_aptitude) {
		this.production_unit_aptitude = production_unit_aptitude;
	}
	public String getOther() {
		return other;
	}
	public void setOther(String other) {
		this.other = other;
	}
	public String getApplystate() {
		return applystate;
	}
	public void setApplystate(String applystate) {
		this.applystate = applystate;
	}
	public String getApply_unit_code() {
		return apply_unit_code;
	}
	public void setApply_unit_code(String apply_unit_code) {
		this.apply_unit_code = apply_unit_code;
	}
	public String getApply_unit() {
		return apply_unit;
	}
	public void setApply_unit(String apply_unit) {
		this.apply_unit = apply_unit;
	}
	public String getApply_unit_reason() {
		return apply_unit_reason;
	}
	public void setApply_unit_reason(String apply_unit_reason) {
		this.apply_unit_reason = apply_unit_reason;
	}
	public String getApply_unit_idea() {
		return apply_unit_idea;
	}
	public void setApply_unit_idea(String apply_unit_idea) {
		this.apply_unit_idea = apply_unit_idea;
	}
	public String getPrincipal() {
		return principal;
	}
	public void setPrincipal(String principal) {
		this.principal = principal;
	}
	public String getApprove_date() {
		return approve_date;
	}
	public void setApprove_date(String approve_date) {
		this.approve_date = approve_date;
	}
	public String getReview_confirms() {
		return review_confirms;
	}
	public void setReview_confirms(String review_confirms) {
		this.review_confirms = review_confirms;
	}
	public String getPanel_idea() {
		return panel_idea;
	}
	public void setPanel_idea(String panel_idea) {
		this.panel_idea = panel_idea;
	}
	public String getPanel_principal() {
		return panel_principal;
	}
	public void setPanel_principal(String panel_principal) {
		this.panel_principal = panel_principal;
	}
	public String getPanel_review_date() {
		return panel_review_date;
	}
	public void setPanel_review_date(String panel_review_date) {
		this.panel_review_date = panel_review_date;
	}
	public String getEquipment_idea() {
		return equipment_idea;
	}
	public void setEquipment_idea(String equipment_idea) {
		this.equipment_idea = equipment_idea;
	}
	public String getEquipment_principal() {
		return equipment_principal;
	}
	public void setEquipment_principal(String equipment_principal) {
		this.equipment_principal = equipment_principal;
	}
	public String getEquipment_review_date() {
		return equipment_review_date;
	}
	public void setEquipment_review_date(String equipment_review_date) {
		this.equipment_review_date = equipment_review_date;
	}
	public String getReview_result() {
		return review_result;
	}
	public void setReview_result(String review_result) {
		this.review_result = review_result;
	}
	public String getReview_prove() {
		return review_prove;
	}
	public void setReview_prove(String review_prove) {
		this.review_prove = review_prove;
	}
	public String getApply_date() {
		return apply_date;
	}
	public void setApply_date(String apply_date) {
		this.apply_date = apply_date;
	}
	public String getReview_state() {
		return review_state;
	}
	public void setReview_state(String review_state) {
		this.review_state = review_state;
	}
	public String getCreater() {
		return creater;
	}
	public void setCreater(String creater) {
		this.creater = creater;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	public String getUpdate_tor() {
		return update_tor;
	}
	public void setUpdate_tor(String update_tor) {
		this.update_tor = update_tor;
	}
	public String getModify_date() {
		return modify_date;
	}
	public void setModify_date(String modify_date) {
		this.modify_date = modify_date;
	}
	public String getBsflag() {
		return bsflag;
	}
	public void setBsflag(String bsflag) {
		this.bsflag = bsflag;
	}
	public DmsSelectionOpi() {
		super();
	}
	

}
