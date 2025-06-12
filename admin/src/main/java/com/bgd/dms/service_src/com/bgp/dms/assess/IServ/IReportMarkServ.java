package com.bgp.dms.assess.IServ;

import java.util.List;

import com.bgp.dms.assess.model.ReportItem;
import com.bgp.dms.assess.model.ReportMark;
/**
 * 异常报告清单接口
 * @author 高云鹏
 *
 */
public interface IReportMarkServ {
	/**
	 * 报错异常报告
	 * @param reportMark
	 */
	public void saveReportMark(ReportMark reportMark);
	/**
	 * 获取异常报告
	 * @param reportMarkID
	 * @return
	 */
	public ReportMark getReportMarkByID(String reportMarkID);
	/**
	 * 获取考核报告的异常报告结果集
	 * @param reportID 所属考核报告
	 * @return
	 */
	public List<ReportMark> getReportMarkListByReportID(String reportID);
	
	/**
	 * 获取组织机构的所有异常报告
	 * @param orgID
	 * @return
	 */
	public List<ReportMark> getReportMarkListByOrgID(String orgID);
	/**
	 * 获取组织机构使用对应的考核模板生成的异常报告
	 * @param orgID
	 * @param TemplateID
	 * @return
	 */
	public List<ReportMark> getReportMarkListByTemplateID(String orgID,String TemplateID);
	/**
	 * 获取异常报告明细
	 * @param reportMarkID
	 * @return
	 */
	public List<ReportItem> getReportItemByMarkID(String reportMarkID);
	
}
