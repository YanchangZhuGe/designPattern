package com.bgp.dms.assess.IServ;

import java.util.List;
import java.util.Map;

import com.bgp.dms.assess.model.AssessBorad;
import com.bgp.dms.assess.model.AssessInfo;

/**
 * 基础考核数据维护接口定义
 * 
 * @author 高云鹏
 * 
 */
public interface IAssessNodeServ {
	public Map<String, Object> findHeadByID(String headID);
	public AssessBorad createBoradBySheetID(String sheetID);
	public AssessInfo findAssessBySheetID(AssessInfo assessInfo);
	/**
	 * 创建考核数据
	 * 
	 * @param assessInfo
	 *            考核数据
	 */
	public void saveAssess(AssessInfo assessInfo);

	/**
	 * 更新考核数据
	 * 
	 * @param assessInfo
	 *            考核数据
	 */
	public void updateAssess(AssessInfo assessInfo);

	/**
	 * 逻辑删除考核数据
	 * 并同时逻辑删除其子节点
	 * @param assessInfoID
	 *            考核数据编号
	 */
	public void deleteAssesById(String assessInfoID);

	/**
	 * 查询考核数据
	 * 并查找此节点的上级节点集合、下级节点集合
	 * @return
	 */
	public AssessInfo findAssessByID(String assessInfoID);

	/**
	 * 根据父节点查询下级考核数据节点集
	 * 
	 * @param superiorID
	 * @return
	 */
	public List<AssessInfo> findChildAssessListByID(String assessInfoID);
	public List<AssessInfo> findChildAssessListByName(String assessName);

	/**
	 * 查询下级考核数据节点集
	 * 
	 * @param superiorID
	 *            上级考核数据编号
	 * @return
	 */
	public List<AssessInfo> findLeafListBySuperiorID(String superiorID);

	/**
	 * 查询模板对应的叶级考核节点集合
	 * 
	 * @param templateId
	 *            模板编号
	 * @return
	 */
	public List<AssessInfo> findLeafListByTemplateId(String templateID);

	/**
	 * 查询所有考核根节点
	 * 
	 * @return
	 */
	public List<AssessInfo> findRootList();

	/**
	 * 判断是否为叶级节点
	 * 
	 * @param assessInfo
	 * @return
	 */
	public boolean checkIsLeaf(AssessInfo assessInfo);

	/**
	 * 判断是否为根基节点
	 * 
	 * @param assessInfo
	 * @return
	 */
	public boolean checkIsRoot(AssessInfo assessInfo);

	/**
	 * 判断是否为行属性头结点
	 * 
	 * @param assessInfo
	 * @return
	 */
	public boolean checkIsRowHeader(AssessInfo assessInfo);

	/**
	 * 判断是否为excel维度的列属性头结点
	 * 
	 * @param assessInfo
	 * @return
	 */
	public boolean checkIsColHeader(AssessInfo assessInfo);

	/**
	 * 判断是否为excel维度的sheet级节点
	 * 
	 * @param assessInfo
	 * @return
	 */
	public boolean checkIsSheetHeader(AssessInfo assessInfo);

	/**
	 * 查询根目录下所有excel维度的sheet节点集合
	 * 
	 * @param rootID
	 * @return
	 */
	public List<AssessInfo> getSheetListByRootID(String rootID);

	/**
	 * 生成考核节点编号
	 * 
	 * @param assessInfo
	 * @return
	 */
	public String createAssessNodeCode(List<AssessInfo> superiorNodes, int nodeLevel);

	/**
	 * 获取excel维度的行属性上级目录
	 * 
	 * @param assessInfoID
	 * @return
	 */
	public AssessInfo findSuperiorRowHeaderInfoByID(String assessInfoID);

	/**
	 * 判断是否存在excel维度的行属性上级目录
	 * 
	 * @param assessInfoID
	 * @return
	 */
	public boolean isExistSuperiorRowHeaderInfoByID(String assessInfoID);

	/**
	 * 获取excel维度的列属性上级目录
	 * 
	 * @param assessInfoID
	 * @return
	 */
	public AssessInfo findSuperiorColHeaderInfoByID(String assessInfoID);

	/**
	 * 判断是否存在excel维度的列属性上级目录
	 * 
	 * @param assessInfoID
	 * @return
	 */
	public boolean isExistSuperiorColHeaderInfoByID(String assessInfoID);

	/**
	 * 按考核节点名称查询考核节点
	 * 
	 * @param assessInfoName
	 * @param level TODO
	 * @return
	 */
	public AssessInfo findAssessByName(String assessInfoName, int level);

	/**
	 * 叶级节点添加下级目录后，就变为支级节点
	 * 
	 * @param assessInfoID
	 */
	public void changeLeafToBranch(String assessInfoID);

	/**
	 * 支级节点下所有叶级节点删除后，就变成了叶级节点
	 * 
	 * @param assessInfoID
	 */
	public void changeBranchToLeaf(String assessInfoID);

	/**
	 * 根据根节点查找根级节点
	 * 
	 * @param rootID
	 * @return
	 */
	public AssessInfo findRootAssess(String rootID);

	/**
	 * 查找所有sheet级节点，即nodetypes为 s 节点
	 * 
	 * @return
	 */
	public List<AssessInfo> findAllSheetList();

	/**
	 * 根据根级节点id查找此根级节点下所有sheet级节点
	 * 
	 * @param rootID
	 * @return
	 */
	public List<AssessInfo> findAllSheetListByRootID(String rootID);

	/**
	 * 根据sheet级节点查找该sheet级节点下所有列属性头节点
	 * 
	 * @param sheetID
	 * @return
	 */
	public List<AssessInfo> findAllColHeadListBysheetID(String sheetID);

	/**
	 * 根据sheet级节点查找该sheet级节点下所有行属性头节点
	 * 
	 * @param sheetID
	 * @return
	 */
	public List<AssessInfo> findAllRowHeadListBysheetID(String sheetID);

	/**
	 * 根据sheet级节点查找该sheet级节点
	 * 
	 * @param sheetID
	 * @return
	 */
	public AssessInfo findSheetAssessByID(String sheetID);

	public AssessInfo findColHeaderByID(String colHeaderID);

	public AssessInfo findRowHeaderByID(String rowHeaderID);

	/**
	 * 根据中间表对应关系，查找父节点结果集
	 * @param assessInfoID
	 * @return
	 */
	public List<AssessInfo> findSuperiorAssessInfosByID(String assessInfoID);
	/**
	 * 根据中间表对应关系，查找父节点结果集
	 * @param assessInfoID
	 * @return
	 */
	public List<AssessInfo> findSuperiorAssessInfosByName(String assessInfoID);
	/**
	 * 创建跟节点编码
	 * @return
	 */
	public String createRootNodeCode();
	public List findContentByLineID(String lineID);
}