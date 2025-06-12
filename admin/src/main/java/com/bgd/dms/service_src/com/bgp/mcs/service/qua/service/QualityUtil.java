package com.bgp.mcs.service.qua.service;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import java.util.regex.*;


import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.*;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

/**
 * 
 * ���⣺
 * 
 * ���ߣ������꣬2013-10-31
 * 
 * �����������������������
 * 
 * ˵��: 
 */
public class QualityUtil {

	private static JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	private static RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	private static ILog log = LogFactory.getLogger(QualityUtil.class);
	/*��������� 2013-10-31 �����Ŀ�Ŀ�̽��������Ҫ���ۺ��ﻯ̽��Ŀ��*/
	public static List getExplorationMethod(String project_info_no) {
		List list = new ArrayList();
		String exploration_method = "";
		/*��Ŀ�ľ��忱̽����,�ַ�ƴ�ӷ�ʽ*/
		StringBuffer sb = new StringBuffer("select t.* from gp_task_project t where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'");
		Map map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sb.toString());
		exploration_method = map ==null || map.get("exploration_method")==null?"":(String)map.get("exploration_method");
		exploration_method = exploration_method.replaceAll(",", "','");
		sb = new StringBuffer();
		/*�ɿ�̽�������ַ�ƴ�ӷ�ʽ���õ�List*/
		sb.append(" select d.coding_code_id,d.coding_name from comm_coding_sort_detail d where d.bsflag ='0' ")
		.append(" and d.coding_sort_id ='5110000056' and d.coding_code_id in('"+exploration_method+"') order by d.coding_show_id ");
		list = BeanFactory.getPureJdbcDAO().queryRecords(sb.toString());
		log.info(list);
		return list;
	}
	/*��������� 2013-12-18 �����ĿС�ӵ���֯����*/
	public static String getProjectSubjectionId(String project_info_no) {
		String org_subjection_id = "";
		StringBuffer sb = new StringBuffer("select d.org_subjection_id from gp_task_project_dynamic d where d.bsflag ='0' and d.project_info_no ='"+project_info_no+"' and rownum =1");
		Map map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sb.toString());
		org_subjection_id = map ==null || map.get("org_subjection_id")==null?"":(String)map.get("org_subjection_id");
		return org_subjection_id;
	}
}
