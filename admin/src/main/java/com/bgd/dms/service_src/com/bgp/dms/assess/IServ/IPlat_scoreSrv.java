package com.bgp.dms.assess.IServ;

import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.cnpc.jcdp.dao.PageModel;

public interface IPlat_scoreSrv {
	/**
	 * ����ģ�弶�����¼
	 * @param scoreMap
	 * @return ģ�弶�����¼ID
	 */
	public String saveScore(Map scoreMap);
	/**
	 * ����Ԫ�ؼ������¼
	 * @param elementMap
	 * @return Ԫ�ؼ������¼����
	 */
	public String saveElementScore(Map elementMap);
	/**
	 * ������Ԫ�ؼ������¼
	 * @param detailMap
	 */
	public void saveDetailScore(Map detailMap);
	/**
	 * ����Ԫ�ؼ������¼
	 * @param assess Ԫ��json����
	 * @param scoreMap ҳ�����
	 * @param plat_score_id
	 * @return
	 */
	public String saveElementScore(JSONObject assess,Map scoreMap,String plat_score_id);
	/**
	 * ������Ԫ�ؼ������¼
	 * @param detail ��Ԫ��json����
	 * @param scoreMap ҳ�����
	 * @param elementReportID
	 */
	public void saveDetailScore(JSONObject detail,Map scoreMap,String elementReportID);
	/**
	 * �������ֽ��
	 * @param scoreID ���ֽ������
	 * @param page
	 * @return
	 */
	public Map<String, Object> findScoreReportByID(String scoreID);
	/**
	 * 
	 * @param scoreID ģ�弶�����¼ID
	 * @param page
	 * @return
	 */
	public List<Map<String, Object>> findElementScoreList(String scoreID,PageModel page);
	public List<Map<String, Object>> findElementDetailScoreByEleID(String eleScoreID,String DETAIL_FLAG,PageModel page);
	
	/**
	 * ���������嵥
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
