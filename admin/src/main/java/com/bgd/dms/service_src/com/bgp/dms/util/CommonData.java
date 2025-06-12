package com.bgp.dms.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.ResultSetExtractor;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class CommonData {
	
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	IBaseDao baseDao = BeanFactory.getBaseDao();
	
	public List getData(String dataName,String sqlArgs){
		String querySql = "";
		String sql="select data_sql,data_param from DMS_COMM_GETDATA where data_name='"+dataName+"' and bsflag='0' ";
		Map tmp1= jdbcDao.queryRecordBySQL(sql);
		String dataParam="";
		if(tmp1!=null ){
			querySql=(String)tmp1.get("data_sql");
			dataParam=(String)tmp1.get("data_param");
		}else{
			return new ArrayList();
		}
		String currentPage = "1";
		String pageSize = "10";
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		String[] args=sqlArgs.split(",");
		String[] pars=dataParam.split(",");
		
		Map<String,String> args1=new HashMap<String,String>();
		for (int i =0;i<args.length;i++){
			args1.put(pars[i], args[i]);
		}

		//page = pureJdbcDao.queryRecordsBySQL(querySql, page);
		//List result = jdbcDao.getJdbcTemplate().queryForList(querySql, args, Map.class);
		page = pureJdbcDao.queryRecordsByParamSQL(querySql, args1, page);
		List result =page.getData();
		if(result==null)result=new ArrayList();
		return result;
	}

}
