package com.cnpc.sais.ibp.auth.util;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.IAutoRunBean;
import com.cnpc.jcdp.dao.BaseDao;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.soa.exception.ServiceException;
import com.cnpc.sais.ibp.auth.pojo.AuthParam;
import com.cnpc.sais.ibp.auth.pojo.PAuthCsst;
import com.cnpc.sais.ibp.auth.pojo.PAuthFunction;
import com.cnpc.sais.ibp.auth.pojo.PAuthRole;

/**
 * Project£ºCNLC OMS(Service)
 * 
 * Creator£ºrechete
 * 
 * Creator Time:2008-5-4 ÉÏÎç10:17:47
 * 
 * Description£ºAuth Init
 * 
 * Revision history£º
 * 
 * 
 * 
 */
public class AuthInitializor implements IAutoRunBean {
	private ILog log = LogFactory.getLogger(AuthInitializor.class);
	private IBaseDao baseDao = BeanFactory.getBaseDao();
	private IPureJdbcDao jdbcDao = BeanFactory.getPureJdbcDAO();
	public  static AuthParam param = new AuthParam();
	public void run() {
		log.info("AuthInitializor.init()...");

		// loadAllFunctions
		List funcs = baseDao.getAll(PAuthFunction.class);
		FunctionUtil.addAll(funcs);

		// load all menus
		MenuUtil.loadAllMenus();

		// loadAllRoles
		List roles = baseDao.getAll(PAuthRole.class);
		RoleUtil.addAll(roles);

		List<PAuthCsst> csstList = baseDao.getAll(PAuthCsst.class);
		BusiCsstUtil.addAllBusiCsst(csstList);
		loadAuthParams();
	}

	private void loadAuthParams() {
		List<Map> recs = jdbcDao
				.queryRecords("SELECT * FROM ic_ep_cfg WHERE CFG_GROUP='ICG_AUTH'");
		DataPermProcessor.initParams(recs);
	}
	

}
