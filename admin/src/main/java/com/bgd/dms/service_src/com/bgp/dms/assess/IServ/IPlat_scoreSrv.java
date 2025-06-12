package com.bgp.dms.assess.IServ;

import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.cnpc.jcdp.dao.PageModel;

public interface IPlat_scoreSrv {
	/**
	 * 保存模板级评审记录
	 * @param scoreMap
	 * @return 模板级评审记录ID
	 */
	public String saveScore(Map scoreMap);
	/**
	 * 保存元素级评审记录
	 * @param elementMap
	 * @return 元素级评审记录主键
	 */
	public String saveElementScore(Map elementMap);
	/**
	 * 保存子元素级评审记录
	 * @param detailMap
	 */
	public void saveDetailScore(Map detailMap);
	/**
	 * 保存元素级评审记录
	 * @param assess 元素json对象
	 * @param scoreMap 页面参数
	 * @param plat_score_id
	 * @return
	 */
	public String saveElementScore(JSONObject assess,Map scoreMap,String plat_score_id);
	/**
	 * 保存子元素级评审记录
	 * @param detail 子元素json对象
	 * @param scoreMap 页面参数
	 * @param elementReportID
	 */
	public void saveDetailScore(JSONObject detail,Map scoreMap,String elementReportID);
	/**
	 * 查找评分结果
	 * @param scoreID 评分结果主键
	 * @param page
	 * @return
	 */
	public Map<String, Object> findScoreReportByID(String scoreID);
	/**
	 * 
	 * @param scoreID 模板级评审记录ID
	 * @param page
	 * @return
	 */
	public List<Map<String, Object>> findElementScoreList(String scoreID,PageModel page);
	public List<Map<String, Object>> findElementDetailScoreByEleID(String eleScoreID,String DETAIL_FLAG,PageModel page);
	
	/**
	 * 保存问题清单
	 * @param eleScoreIDs
	 * @param platID
	 * @return
	 */
	public List<Map<String, Object>> saveScoreMarkList(String eleScoreIDs,String platID);
	public String updateScore(Map scoreMap);
	public String updateElementScore(JSONObject assess, Map scoreMap,
			String plat_score_id);
	public void updateDetailScore(JSONObject detail, Map scoreMap,
			String elementReportID);
	public List findMarkedElementScoreList(String scoreID, PageModel page);
	public List findAllDetailScoreListByPlatScoreID(String flag,String scoreID);
	public String addSuggestionForElementScore(JSONObject assess,
			Map<String, Object> params, String scoreID);
	public String addSuggestionForPlatScore(Map<String, Object> params);
}
