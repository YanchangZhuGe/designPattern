package com.cnpc.sais.ibp.auth2.util;

import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.IAutoRunBean;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.sais.ibp.auth.pojo.AuthParam;
import com.cnpc.sais.ibp.auth.pojo.PAuthCsst;
import com.cnpc.sais.ibp.auth.pojo.PAuthFunction;
import com.cnpc.sais.ibp.auth.pojo.PAuthRole;

@SuppressWarnings("unchecked")
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
