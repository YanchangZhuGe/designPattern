package com.bgp.dms.assess.IServ;

import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.dao.PageModel;

public interface IElementServ {
	public void saveElement(Map<String, Object> map);
	public void updateElement(Map<String, Object> map);
	public void deleteElement(String id);
	public Map<String, Object> findElementByID(String id);
	public List<Map<String, Object>> findElementByModelID(String modelID, String assessname,PageModel page);
	public List<Map<String, Object>> findElementDetailByEleID(String eleID);
}
