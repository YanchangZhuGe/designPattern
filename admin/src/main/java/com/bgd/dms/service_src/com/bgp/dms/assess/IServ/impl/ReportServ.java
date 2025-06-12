package com.bgp.dms.assess.IServ.impl;

import java.util.List;

import com.bgp.dms.assess.IServ.IReportServ;
import com.bgp.dms.assess.model.ReportInfo;
import com.bgp.dms.assess.model.ReportItem;
import com.bgp.dms.assess.model.TemplateInfo;

public class ReportServ implements IReportServ {

	@Override
	public void saveReportInfo(TemplateInfo templateInfo,
			List<ReportItem> reportItemList, String orgID) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<ReportInfo> getItemReportList(TemplateInfo templateInfo,
			String orgID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ReportInfo getReportInfoByID(String reportID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ReportInfo deleteReportInfoByID(String reportID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ReportInfo> getItemReportListByOrgID(String orgID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ReportInfo> getReportListByTemplateInfoID(String templateInfoID) {
		// TODO Auto-generated method stub
		return null;
	}

}
