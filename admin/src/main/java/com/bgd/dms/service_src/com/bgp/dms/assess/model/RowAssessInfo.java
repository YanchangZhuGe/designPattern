package com.bgp.dms.assess.model;

import java.util.List;
/**
 * excel�����ݶ���
 * @author ������
 *
 */
public class RowAssessInfo {
	private Object rowHeadAssess;//�����ݱ�ͷ����
	private List<AssessInfo> rowAssessList;//����������
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
