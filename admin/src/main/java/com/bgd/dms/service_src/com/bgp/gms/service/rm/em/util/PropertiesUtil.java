package com.bgp.gms.service.rm.em.util;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.xml.soap.SOAPException;

import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;

/**
 * 
 * 标题：物探生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司：中油瑞飞
 * 
 * 作者：邱庆豹，2010-8-10
 * 
 * 描述：工具类用来实现将javabean转换为map来方便数据库CRU操作如projectInfoNo->project_info_no
 * 
 * 说明功能类似于apche-commonUtil中的beanUtil类
 */

@SuppressWarnings({ "rawtypes", "unchecked" })
public class PropertiesUtil {

	public static Map describe(Object ob) {

		Map map = new HashMap();
		if (ob != null) {
			Method[] ml = ob.getClass().getMethods();
			for (int i = 0; i < ml.length; i++) {
				try {

					String mehthodName = ml[i].getName();
					if (mehthodName.startsWith("get") && !"getClass".equals(mehthodName)) {
						if (ml[i].invoke(ob) != null && !"".equals(ml[i].invoke(ob))) {

							String field = mehthodName.substring(3, 4).toLowerCase() + mehthodName.substring(4);

							String toField = "";
							int k = 0;
							for (int j = 0; j < field.length(); j++) {
								char a = field.charAt(j);
								if (a >= 'A' && a <= 'Z') {
									toField += field.substring(k, j) + "_" + String.valueOf(a).toLowerCase();
									k = j + 1;
								}
							}
							toField += field.substring(k);

							map.put(toField, ml[i].invoke(ob));
						}
					}
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
			}
		}
		return map;
	}

	/*
	 * 从ISrvMsg里读取信息到javabean
	 */
	public static void msgToPojo(String frontFlag, ISrvMsg reqDTO, Object ob) {
		if (reqDTO != null) {
			Method[] ml = ob.getClass().getMethods();
			for (int i = 0; i < ml.length; i++) {
				try {

					String mehthodName = ml[i].getName();
					if (mehthodName.startsWith("set")) {
						String field = mehthodName.substring(3, 4).toLowerCase() + mehthodName.substring(4);
						String fieldValue = reqDTO.getValue(frontFlag + field);
						if (fieldValue != null) {
							ml[i].invoke(ob, fieldValue);
						}
					}
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				} catch (SOAPException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	/*
	 * 从ISrvMsg里读取信息到javabean
	 */
	public static void msgToPojoEnd(String endFlag, ISrvMsg reqDTO, Object ob) {
		if (reqDTO != null) {
			Method[] ml = ob.getClass().getMethods();
			for (int i = 0; i < ml.length; i++) {
				try {

					String mehthodName = ml[i].getName();
					if (mehthodName.startsWith("set")) {
						String field = mehthodName.substring(3, 4).toLowerCase() + mehthodName.substring(4);
						String fieldValue = reqDTO.getValue(field+endFlag);
						if (fieldValue != null) {
							ml[i].invoke(ob, fieldValue);
						}
					}
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				} catch (SOAPException e) {
					e.printStackTrace();
				}
			}
		}
	}

	public static void msgToPojo(ISrvMsg reqDTO, Object ob) {

		msgToPojo("", reqDTO, ob);
	}

	/*
	 * map to map projectInfoNo ->project_info_no
	 */
	public static Map describeMap(Map ob) {
		Map map = new HashMap();
		if (ob == null) {
			return map;
		} else {
			for (Iterator it = ob.keySet().iterator(); it.hasNext();) {
				String keyValue = it.next().toString();

				String toField = "";
				int k = 0;
				for (int j = 0; j < keyValue.length(); j++) {
					char a = keyValue.charAt(j);
					if (a >= 'A' && a <= 'Z') {
						toField += keyValue.substring(k, j) + "_" + String.valueOf(a).toLowerCase();
						k = j + 1;
					}
				}
				toField += keyValue.substring(k);

				map.put(toField, ob.get(keyValue));
			}
		}
		return map;
	}

	/*
	 * list<msgElements> to list<Map)
	 */
	public static List<Map> getListMapFromListMsgElement(List<MsgElement> mg) {
		List<Map> returnList = new ArrayList<Map>();
		if (mg != null) {
			for (int i = 0; i < mg.size(); i++) {
				try {
					Map map = mg.get(i).toMap();
					returnList.add(map);
				} catch (Exception e) {
					return returnList;
				}
			}
			return returnList;
		} else {
			return returnList;
		}
	}
}
