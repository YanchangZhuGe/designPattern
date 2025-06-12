package com.bgp.dms.assess.IServ;

import java.util.List;

import com.bgp.dms.assess.model.RowAssessInfo;
import com.bgp.dms.assess.model.TemplateInfo;

/**
 * ����ģ��ӿ�
 * @author ������
 *
 */
public interface ITemplateServ {
		/**
		 * ����ģ��
		 * @param templateInfo ģ�����
		 */
	   public void saveTemplateInfo(TemplateInfo templateInfo);
	   /**
	    * ����ģ��
	    * @param templateInfo ģ�����
	    */
	   public void updateTemplateInfo(TemplateInfo templateInfo);
	   /**
	    * ����ģ��
	    * @param templateInfoID ģ����
	    * @return
	    */
	   public TemplateInfo getTemplateInfoByID(String templateInfoID);
	   /**
	    * ɾ��ģ��
	    * @param templateInfoID ģ����
	    */
	   public void deleteTemplateInfoByID(String templateInfoID);
	   /**
	    * ��ȡ����ģ��
	    * @param templateInfoID ģ����
	    */
	   public List<TemplateInfo> getAllTemplateInfoList();
	   /**
	    * ���ݿ������ݸ����ڵ����ģ�弯��
	    * @param assessInfoRootID  ���ݸ����ڵ�
	    * @return
	    */
	   public List<TemplateInfo> getTemplateInfoListByRootID(String assessInfoRootID);
	   /**
	    * ��ȡģ��������Ҷ�����˶���
	    * @param templateInfoID ģ����
	    * @return
	    */
	   public List<TemplateInfo> getLeafListByTemplateInfoID(String templateInfoID);
	   /**
	    * ����ģ�崴��excel��ͷ����
	    * @param templateInfoID ģ����
	    * @return
	    */
	   public List<TemplateInfo> createColHeaderListByTemplateInfoID(String templateInfoID);
	   /**
	    * ����ģ�崴��excel��ͷ����
	    * @param sheetID sheet�����˽ڵ���
	    * @return
	    */
	   public List<TemplateInfo> createColHeaderListBySheetID(String sheetID);
	   /**
	    * ����ģ�崴��excel��������
	    * @param templateInfoID ģ����
	    * @return
	    */
	   public List<RowAssessInfo> createRowAssessInfoListByTemplateInfoID(String templateInfoID);
	   /**
	    * ����ģ�崴��excel��������
	    * @param sheetID sheet�����˽ڵ���
	    * @return
	    */
	   public List<RowAssessInfo> createRowAssessInfoListBySheetID(String sheetID);
	}
