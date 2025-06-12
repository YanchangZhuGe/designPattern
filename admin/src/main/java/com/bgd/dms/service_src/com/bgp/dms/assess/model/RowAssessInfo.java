package com.bgp.dms.assess.model;

import java.util.List;
/**
 * excel行数据对象
 * @author 高云鹏
 *
 */
public class RowAssessInfo {
	private Object rowHeadAssess;//行数据表头对象
	private List<AssessInfo> rowAssessList;//行数据内容
	public Object getRowHeadAssess() {
		return rowHeadAssess;
	}
	public void setRowHeadAssess(Object rowHeadAssess) {
		this.rowHeadAssess = rowHeadAssess;
	}
	public List<AssessInfo> getRowAssessList() {
		return rowAssessList;
	}
	public void setRowAssessList(List<AssessInfo> rowAssessList) {
		this.rowAssessList = rowAssessList;
	}
	
}
