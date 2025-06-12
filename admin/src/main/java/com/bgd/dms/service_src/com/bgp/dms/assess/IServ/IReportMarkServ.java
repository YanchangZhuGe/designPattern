package com.bgp.dms.assess.IServ;

import java.util.List;

import com.bgp.dms.assess.model.ReportItem;
import com.bgp.dms.assess.model.ReportMark;
/**
 * �쳣�����嵥�ӿ�
 * @author ������
 *
 */
public interface IReportMarkServ {
	/**
	 * �����쳣����
	 * @param reportMark
	 */
	public void saveReportMark(ReportMark reportMark);
	/**
	 * ��ȡ�쳣����
	 * @param reportMarkID
	 * @return
	 */
	public ReportMark getReportMarkByID(String reportMarkID);
	/**
	 * ��ȡ���˱�����쳣��������
	 * @param reportID �������˱���
	 * @return
	 */
	public List<ReportMark> getReportMarkListByReportID(String reportID);
	
	/**
	 * ��ȡ��֯�����������쳣����
	 * @param orgID
	 * @return
	 */
	public List<ReportMark> getReportMarkListByOrgID(String orgID);
	/**
	 * ��ȡ��֯����ʹ�ö�Ӧ�Ŀ���ģ�����ɵ��쳣����
	 * @param orgID
	 * @param TemplateID
	 * @return
	 */
	public List<ReportMark> getReportMarkListByTemplateID(String orgID,String TemplateID);
	/**
	 * ��ȡ�쳣������ϸ
	 * @param reportMarkID
	 * @return
	 */
	public List<ReportItem> getReportItemByMarkID(String reportMarkID);
	
}
