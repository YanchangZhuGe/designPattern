package com.bgp.dms.assess.IServ;

import java.util.List;
import java.util.Map;

public interface IModelServ {
	public void saveModel(Map<String, Object> map);
	public void updateModel(Map<String, Object> map);
	public Map<String, Object> findModelByID(String id);
	public void deleteModel(String id);
	public List<Map<String, Object>> findAllModel();
	public List<Map<String, Object>> findAllModelByInput(String input);
}
