package com.bgp.dms.assess.IServ;

import java.util.List;

import com.bgp.dms.assess.model.ReportInfo;
import com.bgp.dms.assess.model.ReportItem;
import com.bgp.dms.assess.model.TemplateInfo;
/**
 * ���˽������
 * @author ������
 *
 */
public interface IReportServ {
	   /**
	    * ����������
	    * @param templateInfo ����ģ��
	    * @param orgID ���˶���
	    */
	   public void saveReportInfo(TemplateInfo templateInfo,List<ReportItem> reportItemList,String orgID);
	   /**
	    * ��ȡ���˶��� �����п��˽��
	    * @param templateInfo ����ģ��
	    * @param orgID ���˶���
	    * @return
	    */
	   public List<ReportInfo> getItemReportList(TemplateInfo templateInfo,String orgID);
	   /**
	    * ��ȡ���˱���
	    * @param reportID ���˱�����
	    * @return
	    */
	   public ReportInfo getReportInfoByID(String reportID);
	   /**
	    * ɾ�����˱���
	    * @param reportID
	    * @return
	    */
	   public ReportInfo deleteReportInfoByID(String reportID);
	   /**
	    * ��ȡ���˶�������п�����ϸ
	    * @param orgID ���˶���
	    * @return
	    */
	   public List<ReportInfo> getItemReportListByOrgID(String orgID);
	   /**
	    * ��ȡʹ�ÿ���ģ����п��˵����п��˱���
	    * @param templateInfoID ����ģ��
	    * @return
	    */
	   public List<ReportInfo> getReportListByTemplateInfoID(String templateInfoID);

	}