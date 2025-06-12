package com.cnpc.sais.ibp.auth2.util;

import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import com.cnpc.sais.ibp.auth.pojo.PAuthCsst;
import com.cnpc.sais.ibp.auth.pojo.PAuthFunction;

public class BusiCsstUtil {

	private static Map<String, PAuthCsst> busiCsst = new Hashtable<String, PAuthCsst>();
//	private static String sql = "select * from p_auth_function where func_id ='";
//	private static IPureJdbcDao jdbcDao = BeanFactory.getPureJdbcDAO();

	public static void addAllBusiCsst(List<PAuthCsst> list) {
		busiCsst.clear();
		for (int i = 0; i < list.size(); i++) {
/*			String func_id = list.get(i).getFunc_id();
			sql = sql + func_id + "'";
			Map funcMap = jdbcDao.queryRecordBySQL(sql);*/
			PAuthFunction func = FunctionUtil.getPAuthFunction(list.get(i).getFunc_id());
			busiCsst.put(func.getFuncCode(), list.get(i));
		}
	}

	public static PAuthCsst getPAuthCsst(String func_code) {
		PAuthCsst csst = busiCsst.get(func_code);
		return csst;
	}
}
