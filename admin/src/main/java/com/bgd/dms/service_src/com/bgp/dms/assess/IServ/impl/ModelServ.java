package com.bgp.dms.assess.IServ.impl;

import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.assess.IServ.IModelServ;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class ModelServ implements IModelServ {
	ILog log = null;

	public ModelServ() {
		log = LogFactory.getLogger(AssessNodeServ.class);
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	@Override
	public void saveModel(Map<String, Object> map) {
		// TODO Auto-generated method stub

	}

	@Override
	public void updateModel(Map<String, Object> map) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public Map<String, Object> findModelByID(String id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void deleteModel(String id) {
		// TODO Auto-generated method stub

	}

	@Override
	public List<Map<String, Object>> findAllModel() {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		log.info("findAllModel");
		String sql = "";
		StringBuffer buffer = new StringBuffer();
		buffer.append("select MODEL_ID as id,MODEL_NAME as modelname, ");
		buffer.append("MODEL_TYPE as modeltype,MODEL_TITLE as modeltitle, ");
		buffer.append("MODEL_VERSION as modelversion,CREATOR as modelcreator, ");
		buffer.append("CREATE_ORG_ID as modelorgid, CREATE_DATE as createdate");
		buffer.append(" from dms_assess_plat_model ");
		buffer.append("order by CREATE_DATE desc");
		sql = buffer.toString();
		List<Map<String, Object>> list = jdbcTemplate.queryForList(sql);
		return list;
	}

	@Override
	public List<Map<String, Object>> findAllModelByInput(String input) {
		// TODO Auto-generated method stub
		log.info("findAllModelByInput");
		String sql = "";
		StringBuffer buffer = new StringBuffer();
		buffer.append("select * from dms_assess_plat_model ");
		buffer.append("order by ");
		return null;
	}

}
