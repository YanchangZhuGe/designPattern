package com.bgp.dms.assess.IServ;

import java.util.List;

import com.bgp.dms.assess.model.ReportInfo;
import com.bgp.dms.assess.model.ReportItem;
import com.bgp.dms.assess.model.TemplateInfo;
/**
 * 考核结果报告
 * @author 高云鹏
 *
 */
public interface IReportServ {
	   /**
	    * 保存结果报告
	    * @param templateInfo 考核模板
	    * @param orgID 考核对象
	    */
	   public void saveReportInfo(TemplateInfo templateInfo,List<ReportItem> reportItemList,String orgID);
	   /**
	    * 获取考核对象 的所有考核结果
	    * @param templateInfo 考核模板
	    * @param orgID 考核对象
	    * @return
	    */
	   public List<ReportInfo> getItemReportList(TemplateInfo templateInfo,String orgID);
	   /**
	    * 获取考核报告
	    * @param reportID 考核报告编号
	    * @return
	    */
	   public ReportInfo getReportInfoByID(String reportID);
	   /**
	    * 删除考核报告
	    * @param reportID
	    * @return
	    */
	   public ReportInfo deleteReportInfoByID(String reportID);
	   /**
	    * 获取考核对象的所有考核明细
	    * @param orgID 考核对象
	    * @return
	    */
	   public List<ReportInfo> getItemReportListByOrgID(String orgID);
	   /**
	    * 获取使用考核模板进行考核的所有考核报告
	    * @param templateInfoID 考核模板
	    * @return
	    */
	   public List<ReportInfo> getReportListByTemplateInfoID(String templateInfoID);

	}