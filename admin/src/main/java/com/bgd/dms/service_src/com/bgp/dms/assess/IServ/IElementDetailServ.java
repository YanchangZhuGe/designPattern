package com.bgp.dms.assess.IServ;

import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.dao.PageModel;

public interface IElementDetailServ {
	public void saveElementDetail(Map<String, Object> map);
	public void updateElementDetail(Map<String, Object> map);
	public void deleteElementDetailByID(String id);
	public Map<String, Object> findElementDetailByID(String id);
	public List<Map<String, Object>> findElementDetailByEleID(String eleId,String chk_name,PageModel page,String DETAIL_FLAG);
	/**
	 * 
	 * @param eleId
	 * @param types 0：评分标准  1：集团检查项目
	 * @return
	 */
	public int getTotalScoreByEleID(String eleId,String DETAIL_FLAG);
	//修改
	public List findAllDetailsByModelID(String flag,String modelID);
	//新增
	public List findAllDetailsByModelID(String flag,String modelID,String orgId);
	public List getTotalDetailsScoresByModelID(String DETAIL_FLAG,String modelID);
}
