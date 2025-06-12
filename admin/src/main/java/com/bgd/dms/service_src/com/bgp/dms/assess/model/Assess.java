package com.bgp.dms.assess.model;

public class Assess {
	private String assessID;
	private String columnID;
	private String lineID;
	private String content;
	public String getColumnID() {
		return columnID;
	}
	public void setColumnID(String columnID) {
		this.columnID = columnID;
	}
	public String getLineID() {
		return lineID;
	}
	public void setLineID(String lineID) {
		this.lineID = lineID;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getAssessID() {
		return assessID;
	}
	public void setAssessID(String assessID) {
		this.assessID = assessID;
	}
	
}
