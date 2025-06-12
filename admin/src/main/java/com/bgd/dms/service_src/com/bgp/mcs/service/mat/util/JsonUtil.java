package com.bgp.mcs.service.mat.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


/**
 * 
 * 标题：
 * 
 * 作者：邱庆豹，2012 6 8
 * 
 * 描述：Json操作工具类
 * 
 * 说明: 提取json公共操作，服务于各业务
 */

public class JsonUtil {

	
	/*
	 * 用于将一个list 转换为tree List，便于	前台树的生成
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
