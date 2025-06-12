package com.bgp.dms.assess.model;

import java.util.List;
import java.util.Map;

public class AssessBorad {
	private String sheetid;
	private List<Map<String, Object>> columnHeadList;
	private List<Map<String, List>> lineList;
	public List<Map<String, Object>> getColumnHeadList() {
		return columnHeadList;
	}
	public void setColumnHeadList(List<Map<String, Object>> columnHeadList) {
		this.columnHeadList = columnHeadList;
	}
	public List<Map<String, List>> getLineList() {
		return lineList;
	}
	public void setLineList(List<Map<String, List>> lineList) {
		this.lineList = lineList;
	}
	public String getSheetid() {
		return sheetid;
	}
	public void setSheetid(String sheetid) {
		this.sheetid = sheetid;
	}
}
