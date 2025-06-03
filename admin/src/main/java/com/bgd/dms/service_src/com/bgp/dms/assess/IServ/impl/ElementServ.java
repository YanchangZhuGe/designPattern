package com.bgp.dms.assess.IServ.impl;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.bgp.dms.assess.IServ.IElementServ;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;

public class ElementServ implements IElementServ {
	ILog log = null;
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	public ElementServ() {
		log = LogFactory.getLogger(ElementServ.class);
	}
	@Override
	public void saveElement(Map<String, Object> map) {
		// TODO Auto-generated method stub

	}

	@Override
	public void updateElement(Map<String, Object> map) {
		// TODO Auto-generated method stub

	}

	@Override
	public void deleteElement(String id) {
		// TODO Auto-generated method stub

	}

	@Override
	public Map<String, Object> findElementByID(String id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Map<String, Object>> findElementByModelID(String modelID, String assessname,PageModel page) {
		// TODO Auto-generated method stub
		String sql = "";
		StringBuffer querySql = new StringBuffer();
		querySql.append("select dms.ASSESS_ID as assess_id,dms.ASSESS_NAME as assess_name,");
		querySql.append(" info.org_name as create_org_name,");
		querySql.append(" emp.employee_name as creator_name,dms.create_date,");
		querySql.append("dms.ASSESS_CONTENT assess_content  ");
		querySql.append(" from dms_assess_plat_element dms ");
		querySql.append(" left join comm_org_information info ");
		querySql.append(" on dms.create_org_id = info.org_id and info.bsflag = '0' ");
		querySql.append(" left join comm_human_employee emp ");
		querySql.append("on dms.CREATOR = emp.employee_id and emp.bsflag = '0'");
		querySql.append(" where dms.ASSESS_MODEL_ID = '");
		querySql.append(modelID).append("'");
		// Ö¸±êÃû³Æ
		if (StringUtils.isNotBlank(assessname)) {
			querySql.append(" and dms.ASSESS_NAME like '%" + assessname + "%'");
		}
		querySql.append(" order by dms.ASSESS_SEQ");
		sql = querySql.toString();
		//log.info("sql = " + sql);
		page = pureDao.queryRecordsBySQL(sql, page);
		List list = page.getData();
		
		return list;
	}

	@Override
	public List<Map<String, Object>> findElementDetailByEleID(String eleID) {
		// TODO Auto-generated method stub
		return null;
	}

}
