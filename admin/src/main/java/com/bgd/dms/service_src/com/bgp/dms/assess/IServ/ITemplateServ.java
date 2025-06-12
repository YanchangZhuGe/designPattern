package com.bgp.dms.assess.IServ;

import java.util.List;

import com.bgp.dms.assess.model.RowAssessInfo;
import com.bgp.dms.assess.model.TemplateInfo;

/**
 * 考核模板接口
 * @author 高云鹏
 *
 */
public interface ITemplateServ {
		/**
		 * 新增模板
		 * @param templateInfo 模板对象
		 */
	   public void saveTemplateInfo(TemplateInfo templateInfo);
	   /**
	    * 保存模板
	    * @param templateInfo 模板对象
	    */
	   public void updateTemplateInfo(TemplateInfo templateInfo);
	   /**
	    * 查找模板
	    * @param templateInfoID 模板编号
	    * @return
	    */
	   public TemplateInfo getTemplateInfoByID(String templateInfoID);
	   /**
	    * 删除模板
	    * @param templateInfoID 模板编号
	    */
	   public void deleteTemplateInfoByID(String templateInfoID);
	   /**
	    * 获取所有模板
	    * @param templateInfoID 模板编号
	    */
	   public List<TemplateInfo> getAllTemplateInfoList();
	   /**
	    * 根据考核数据根级节点查找模板集合
	    * @param assessInfoRootID  数据根级节点
	    * @return
	    */
	   public List<TemplateInfo> getTemplateInfoListByRootID(String assessInfoRootID);
	   /**
	    * 获取模板下所有叶级考核对象
	    * @param templateInfoID 模板编号
	    * @return
	    */
	   public List<TemplateInfo> getLeafListByTemplateInfoID(String templateInfoID);
	   /**
	    * 根据模板创建excel的头数据
	    * @param templateInfoID 模板编号
	    * @return
	    */
	   public List<TemplateInfo> createColHeaderListByTemplateInfoID(String templateInfoID);
	   /**
	    * 根据模板创建excel的头数据
	    * @param sheetID sheet级考核节点编号
	    * @return
	    */
	   public List<TemplateInfo> createColHeaderListBySheetID(String sheetID);
	   /**
	    * 根据模板创建excel的行数据
	    * @param templateInfoID 模板编号
	    * @return
	    */
	   public List<RowAssessInfo> createRowAssessInfoListByTemplateInfoID(String templateInfoID);
	   /**
	    * 根据模板创建excel的行数据
	    * @param sheetID sheet级考核节点编号
	    * @return
	    */
	   public List<RowAssessInfo> createRowAssessInfoListBySheetID(String sheetID);
	}
