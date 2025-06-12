package com.primavera.ws.p6.project;

import java.util.Date;

/**
 * 
 * 标题：中石油集团公司生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：李俊强，Jan 13, 2012
 * 
 * 描述：
 * 
 * 说明:
 */
public class ProjectExtends {
	
	private String projectInfoNo;
	private Project project;
	private Date modifiDate;
	private String bsflag;
	
	public ProjectExtends(Project project) {
		super();
		this.project = project;
		this.projectInfoNo = "";
		this.modifiDate = new Date();
		this.bsflag = "0";
	}

	public ProjectExtends(String projectInfoNo, Project project, Date modifiDate, String bsflag) {
		super();
		this.projectInfoNo = projectInfoNo;
		this.project = project;
		this.modifiDate = modifiDate;
		this.bsflag = bsflag;
	}

	public ProjectExtends() {
		super();
		this.project = new Project();
		this.projectInfoNo = "";
		this.modifiDate = new Date();
		this.bsflag = "0";
	}

	public String getProjectInfoNo() {
		return projectInfoNo;
	}

	public void setProjectInfoNo(String projectInfoNo) {
		this.projectInfoNo = projectInfoNo;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public Date getModifiDate() {
		return modifiDate;
	}

	public void setModifiDate(Date modifiDate) {
		this.modifiDate = modifiDate;
	}

	public String getBsflag() {
		return bsflag;
	}

	public void setBsflag(String bsflag) {
		this.bsflag = bsflag;
	}
}
