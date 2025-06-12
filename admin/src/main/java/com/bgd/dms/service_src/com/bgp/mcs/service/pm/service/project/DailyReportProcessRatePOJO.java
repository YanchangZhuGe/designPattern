package com.bgp.mcs.service.pm.service.project;

import java.io.Serializable;

public class DailyReportProcessRatePOJO implements Serializable{
	
	//生产日期
	private String productDate ;
	//施工状态
	private String if_build;
	
	//采集日完成炮数
	private String collShotNum ;
	//采集累计完成点数
	private String collFinishedSpNum;
	//采集完成%	
	private String collFinishedRate;

	//钻井日完成炮点数
	private String drillShotNum ;
	//钻井累计完成点数
	private String drillFinishedSpNum;
	//钻井完成%
	private String drillFinishedRate;
	
	//表层日完成点数
	private String surfacePointNo;
	//表层累计完成点数
	private String surfaceFinishedSpNum;
	//表层完成%
	private String surfaceFinishedRate;
	
	//测量日完成炮点数
	private String surveyShotNum;
	//测量日完成检波点数
	private String surveyGeophoneNum;
	//测量累计完成点数
	private String surveyFinishedSpNum;
	//测量完成%
	private String surveyFinishedRate;
	
	//备注
	private String notes;
    //队伍名称
    private String orgName;
    //队伍编号
    private String orgId;
    
    //日完成试验炮
    private String testShotNum;
    //日消耗炸药
    private String powderComsumpt;
    //日消耗雷管
    private String exploderComsumpt;
    //日消耗汽油
    private String oilComsumpt;
    //日消耗柴油
    private String gasolineComsumpt;
    
	public String getOrgId() {
		return orgId;
	}
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	public String getCollFinishedRate() {
		return collFinishedRate;
	}
	public void setCollFinishedRate(String collFinishedRate) {
		this.collFinishedRate = collFinishedRate;
	}
	public String getCollFinishedSpNum() {
		return collFinishedSpNum;
	}
	public void setCollFinishedSpNum(String collFinishedSpNum) {
		this.collFinishedSpNum = collFinishedSpNum;
	}
	public String getCollShotNum() {
		return collShotNum;
	}
	public void setCollShotNum(String collShotNum) {
		this.collShotNum = collShotNum;
	}
	public String getDrillFinishedRate() {
		return drillFinishedRate;
	}
	public void setDrillFinishedRate(String drillFinishedRate) {
		this.drillFinishedRate = drillFinishedRate;
	}
	public String getDrillFinishedSpNum() {
		return drillFinishedSpNum;
	}
	public void setDrillFinishedSpNum(String drillFinishedSpNum) {
		this.drillFinishedSpNum = drillFinishedSpNum;
	}
	public String getDrillShotNum() {
		return drillShotNum;
	}
	public void setDrillShotNum(String drillShotNum) {
		this.drillShotNum = drillShotNum;
	}
	public String getNotes() {
		return notes;
	}
	public void setNotes(String notes) {
		this.notes = notes;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	public String getProductDate() {
		return productDate;
	}
	public void setProductDate(String productDate) {
		this.productDate = productDate;
	}
	public String getSurfaceFinishedRate() {
		return surfaceFinishedRate;
	}
	public void setSurfaceFinishedRate(String surfaceFinishedRate) {
		this.surfaceFinishedRate = surfaceFinishedRate;
	}
	public String getSurfaceFinishedSpNum() {
		return surfaceFinishedSpNum;
	}
	public void setSurfaceFinishedSpNum(String surfaceFinishedSpNum) {
		this.surfaceFinishedSpNum = surfaceFinishedSpNum;
	}
	public String getSurfacePointNo() {
		return surfacePointNo;
	}
	public void setSurfacePointNo(String surfacePointNo) {
		this.surfacePointNo = surfacePointNo;
	}
	public String getSurveyFinishedRate() {
		return surveyFinishedRate;
	}
	public void setSurveyFinishedRate(String surveyFinishedRate) {
		this.surveyFinishedRate = surveyFinishedRate;
	}
	public String getSurveyFinishedSpNum() {
		return surveyFinishedSpNum;
	}
	public void setSurveyFinishedSpNum(String surveyFinishedSpNum) {
		this.surveyFinishedSpNum = surveyFinishedSpNum;
	}
	public String getSurveyGeophoneNum() {
		return surveyGeophoneNum;
	}
	public void setSurveyGeophoneNum(String surveyGeophoneNum) {
		this.surveyGeophoneNum = surveyGeophoneNum;
	}
	public String getSurveyShotNum() {
		return surveyShotNum;
	}
	public void setSurveyShotNum(String surveyShotNum) {
		this.surveyShotNum = surveyShotNum;
	}
	public String getIf_build() {
		return if_build;
	}
	public void setIf_build(String if_build) {
		this.if_build = if_build;
	}
	public String getTestShotNum() {
		return testShotNum;
	}
	public void setTestShotNum(String testShotNum) {
		this.testShotNum = testShotNum;
	}
	public String getPowderComsumpt() {
		return powderComsumpt;
	}
	public void setPowderComsumpt(String powderComsumpt) {
		this.powderComsumpt = powderComsumpt;
	}
	public String getExploderComsumpt() {
		return exploderComsumpt;
	}
	public void setExploderComsumpt(String exploderComsumpt) {
		this.exploderComsumpt = exploderComsumpt;
	}
	public String getOilComsumpt() {
		return oilComsumpt;
	}
	public void setOilComsumpt(String oilComsumpt) {
		this.oilComsumpt = oilComsumpt;
	}
	public String getGasolineComsumpt() {
		return gasolineComsumpt;
	}
	public void setGasolineComsumpt(String gasolineComsumpt) {
		this.gasolineComsumpt = gasolineComsumpt;
	}
}

