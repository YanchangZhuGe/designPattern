package com.bgp.mcs.service.mat.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


/**
 * 
 * ���⣺
 * 
 * ���ߣ����챪��2012 6 8
 * 
 * ������Json����������
 * 
 * ˵��: ��ȡjson���������������ڸ�ҵ��
 */

public class JsonUtil {

	
	/*
	 * ���ڽ�һ��list ת��Ϊtree List������	ǰ̨��������
	 */
	public static Map convertListTreeToJson(List list,String idName,String parentIdName,Map  rootMap){
		for(int i=0;list!=null&&i<list.size();i++){
			Map map=(Map) list.get(i);
			String id=(String) map.get(idName);
			List subList=new ArrayList();
			for(int j=0;list!=null&&j<list.size();j++){
				Map subMap=(Map)list.get(j);
				if(id.equals(subMap.get(parentIdName))){
					subList.add(subMap);
				}
			}
			map.put("children", subList);
		}
		List rootSubList=new ArrayList();
		for(int i=0;list!=null&&i<list.size();i++){
			Map map=(Map) list.get(i);
			if(map.get(parentIdName).equals(rootMap.get(idName))){
				rootSubList.add(map);
			}
		}
		rootMap.put("children", rootSubList);
		return rootMap;
	}
}
