/**
 * 数据权限处理类
 */
package com.cnpc.sais.ibp.auth2.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.DataPermission;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.util.JavaBeanUtils;
import com.cnpc.jcdp.util.StringUtil;

/**
 * @author rechete
 * 
 */
@SuppressWarnings("unchecked")
public class DataPermProcessor implements
		com.cnpc.jcdp.common.IDataPermProcessor {
	private static ILog log = LogFactory.getLogger(DataPermProcessor.class);

	private IPureJdbcDao jdbcDao = BeanFactory.getPureJdbcDAO();

	public static void initParams(List<Map> params) {
		if (params == null)
			return;

		for (int i = 0; i < params.size(); i++)
			try {
				String key = StringUtil.getStrFromMap(params.get(i), "cfg_key");
				String value = StringUtil.getStrFromMap(params.get(i),
						"cfg_value");
				if (key != null && value != null)
					JavaBeanUtils.updatePojoField(AuthInitializor.param, key,
							value);
				// JavaBeanUtils.setDeclaredProperty(param, key, value);
			} catch (Exception ex) {
				log.error(ex);
			}
	}

	public DataPermission getDataPermission(UserToken user, String funcCode,
			String sql) {
		if (funcCode == null) {
			return null;
		}
		// 查询功能对应的数据权限
		String querySql = "SELECT ff.* FROM p_auth_func_filter_dms ff,P_AUTH_FUNCTION_DMS f "
				+ "WHERE f.func_code='"
				+ funcCode
				+ "' AND f.func_id=ff.func_id";
		Map<String, String> funcFilter = jdbcDao.queryRecordBySQL(querySql);
		if (funcFilter == null) {
			// funcFilter = new HashMap<String, String>();
			// funcFilter.put("filter_type", "0");
			// funcFilter.put("entity_id", "");
			// funcFilter.put("filter_data_item", "");
			return null;
		}

		DataPermission dp = new DataPermission();

		dp.setFilteredSql(processScope(sql, funcFilter, user));
		dp.setFilteredItems(processDataItem(funcFilter, user));

		return dp;
	}


	public DataPermission getDataPermission_WT(UserToken user, String funcCode,
			String sql) {
		if (funcCode == null) {
			return null;
		}
		// 查询功能对应的数据权限
		String querySql = "SELECT ff.* FROM p_auth_func_filter_dms ff,P_AUTH_FUNCTION_DMS f "
				+ "WHERE f.func_code='"
				+ funcCode
				+ "' AND f.func_id=ff.func_id";
		Map<String, String> funcFilter = jdbcDao.queryRecordBySQL(querySql);
		if (funcFilter == null) {
			// funcFilter = new HashMap<String, String>();
			// funcFilter.put("filter_type", "0");
			// funcFilter.put("entity_id", "");
			// funcFilter.put("filter_data_item", "");
			return null;
		}

		DataPermission dp = new DataPermission();

		dp.setFilteredSql(processScope_WT(sql, funcFilter, user));
		dp.setFilteredItems(processDataItem(funcFilter, user));

		return dp;
	}
	
	/**
	 * 数据项权限设置
	 * 
	 * @param funcFilter
	 * @param user
	 * @return List<String>要限制查看的数据项
	 */
	private List<String> processDataItem(Map<String, String> funcFilter,
			UserToken user) {
		List<String> fdis = new ArrayList<String>();

		// 该功能未定义数据项限制
		String filterDataItem = funcFilter.get("filter_data_item");
		if ("".equals(filterDataItem.trim())) {
			return fdis;
		}

		// 查询用户的数据项限制解除字符串
		String querySql = "SELECT ANTI_FILTER_DI FROM p_auth_filter_item WHERE FILTER_ID=':fId' AND USER_ID=':uId'";
		Map<String, String> params = new HashMap<String, String>();
		params.put("userId", user.getUserId());
		params.put("filterId", funcFilter.get("entity_id"));
		Map map = jdbcDao.queryRecordByParamSQL(querySql, params);
		// 根据用户的的数据项限制解除字符串 处理功能的数据项限制字符串
		String[] fdiArray = filterDataItem.split(",");
		if (map != null) {
			String antiFdi = (String) map.get("anti_filter_di");
			antiFdi = "," + antiFdi + ",";
			for (int i = 0; i < fdiArray.length; i++) {
				if (antiFdi.indexOf(fdiArray[i]) < 0)
					fdis.add(fdiArray[i]);
			}
		} else {
			for (int i = 0; i < fdiArray.length; i++)
				fdis.add(fdiArray[i]);
		}

		return fdis;
	}
	
	private String processScope_WT(String sql, Map<String, String> funcFilter,
			UserToken user) {
		String orderStr = null;
		if (sql.indexOf("ORDER BY") > 0) {
			orderStr = sql.substring(sql.indexOf("ORDER BY"));
			sql = sql.substring(0, sql.indexOf("ORDER BY"));
		}

		// 查询用户的数据范围权限
		String querySql = null;
		if ("1".equals(funcFilter.get("filter_type"))) {// 按项目过滤
			querySql = "SELECT fs.*"
					+ " FROM p_auth_filter_scope_dms fs"
					+ " WHERE FILTER_ID=':filterId'";
		} else if ("2".equals(funcFilter.get("filter_type"))) {// 按创建者过滤
			querySql = "SELECT fs.*"
					+ " FROM p_auth_filter_scope_dms fs"
					+ " WHERE FILTER_ID=':filterId'";
		} else {// 按组织机构过滤
			querySql = "SELECT fs.*,o."
					+ AuthInitializor.param.getOrgCodeColumn()
					+ " as ORG_CODE FROM p_auth_filter_scope_dms fs,"
					+ AuthInitializor.param.getOrgTable()
					+ " o WHERE FILTER_ID=':filterId' AND fs.ORG_ID=o."
					+ AuthInitializor.param.getOrgIdColumn();
		}
		Map<String, String> params = new HashMap<String, String>();
		params.put("filterId", funcFilter.get("entity_id"));
		List<Map<String, String>> scopes = jdbcDao.queryRecordsByParamSQL(
				querySql, params).getData();

		for (int i = scopes.size() - 1; i >= 0; i--) {
			Map<String, String> scope = scopes.get(i);
			if ("0".equals(scope.get("filter_type"))) {// 用户级定义
				if (!user.getUserId().equals(scope.get("user_id"))) {
					scopes.remove(i);
				}
			} else if ("1".equals(scope.get("filter_type"))) {// 角色级定义
				if (!(user.getRoleIds().contains(scope.get("role_id")))) {
					scopes.remove(i);
				}
			} else { // 组织机构级定义
				if (!user.getOrgId().equals(scope.get("dept_id"))) { // 去掉当前用户不适用的过滤规则
					scopes.remove(i);
				}
			}
		}

		// 确定过滤字段名称
		String filterColumnName = "org_id"; // 默认情况下按照组织机构过滤
		if ("1".equals(funcFilter.get("filter_type"))) {// 按项目过滤
			filterColumnName = "project_id";
		} else if ("2".equals(funcFilter.get("filter_type"))) {// 按用户过滤
			filterColumnName = "creator";
		}
		String fcn = funcFilter.get("filter_column_name");
		filterColumnName = (fcn == null || fcn.length() == 0) ? filterColumnName
				: fcn;

		StringBuffer ftSb = new StringBuffer(
				"SELECT distinct dataAuthView.* FROM (" + sql);

		if ("1".equals(funcFilter.get("filter_type"))) {// 按项目过滤
			ftSb.append(") dataAuthView ");
			String rtable = funcFilter.get("r_tablename");// 关联表名称
			String rfc = funcFilter.get("rt_f_col"); // 过滤字段(关联表)
			String rrc = funcFilter.get("rt_r_col"); // 关联字段(关联表)
			if (scopes.isEmpty()) {
				ftSb.append("," + rtable + " dataAuthOr2g");
				ftSb.append(" WHERE dataAuthView." + filterColumnName
						+ "=dataAuthOrg." + rrc + " AND " + rfc + "='"
						+ user.getUserId() + "' ");
			}
		} else if ("2".equals(funcFilter.get("filter_type"))) {// 按用户过滤
			ftSb.delete(0, ftSb.length());
			ftSb.append("select * from (" + sql + ")dataAuthView ");
			if (scopes.isEmpty()) {

				ftSb.append(" where  dataAuthView." + filterColumnName + "='"
						+ user.getUserId() + "'");
			}
		} else {// 按组织机构过滤
			ftSb.append(")dataAuthView," + AuthInitializor.param.getOrgTable()
					+ " dataAuthOrg");
			ftSb.append(" WHERE dataAuthView." + filterColumnName
					+ " like  '%'||dataAuthOrg." + AuthInitializor.param.getOrgIdColumn()
					+ "||'%'  AND (");
			if (scopes == null || scopes.isEmpty()) {// 按用户组织机构权限过滤
				ftSb.append(" dataAuthOrg."
						+ AuthInitializor.param.getOrgCodeColumn() + " LIKE '"
						+ user.getOrgCode() + "%' ");
			} else {// 按p_auth_filter_scope_dms表的条件过滤
				for (int i = 0; i < scopes.size(); i++) {
					if (i > 0)
						ftSb.append(" OR ");
					ftSb.append(" dataAuthOrg."+ AuthInitializor.param.getOrgCodeColumn());
					String orgCode = scopes.get(i).get("org_code"),isCascade = scopes.get(i).get("is_cascade");
					if("1".equals(isCascade)){
						ftSb.append(" like '"+orgCode+"%'");
					}else{
						ftSb.append(" = '"+orgCode+"'");
					}
				}
			}
			ftSb.append(")");
		}

		String filterSql = ftSb.toString();
		// System.out.println("**************************************");
		// System.out.println(filterSql);
		// System.out.println("**************************************");
		if (orderStr != null)
			filterSql += replaceOrderStr(orderStr);
		return filterSql;
	}

	/**
	 * 数据范围权限设置
	 */
	private String processScope(String sql, Map<String, String> funcFilter,
			UserToken user) {
		String orderStr = null;
		if (sql.indexOf("ORDER BY") > 0) {
			orderStr = sql.substring(sql.indexOf("ORDER BY"));
			sql = sql.substring(0, sql.indexOf("ORDER BY"));
		}

		// 查询用户的数据范围权限
		String querySql = null;
		if ("1".equals(funcFilter.get("filter_type"))) {// 按项目过滤
			querySql = "SELECT fs.*"
					+ " FROM p_auth_filter_scope_dms  fs"
					+ " WHERE FILTER_ID=':filterId'";
		} else if ("2".equals(funcFilter.get("filter_type"))) {// 按创建者过滤
			querySql = "SELECT fs.*"
					+ " FROM p_auth_filter_scope_dms fs"
					+ " WHERE FILTER_ID=':filterId'";
		} else {// 按组织机构过滤
			querySql = "SELECT fs.*,o."
					+ AuthInitializor.param.getOrgCodeColumn()
					+ " as ORG_CODE FROM p_auth_filter_scope_dms fs,"
					+ AuthInitializor.param.getOrgTable()
					+ " o WHERE FILTER_ID=':filterId' AND fs.ORG_ID=o."
					+ AuthInitializor.param.getOrgIdColumn();
		}
		Map<String, String> params = new HashMap<String, String>();
		params.put("filterId", funcFilter.get("entity_id"));
		List<Map<String, String>> scopes = jdbcDao.queryRecordsByParamSQL(
				querySql, params).getData();

		for (int i = scopes.size() - 1; i >= 0; i--) {
			Map<String, String> scope = scopes.get(i);
			if ("0".equals(scope.get("filter_type"))) {// 用户级定义
				if (!user.getUserId().equals(scope.get("user_id"))) {
					scopes.remove(i);
				}
			} else if ("1".equals(scope.get("filter_type"))) {// 角色级定义
				if (!(user.getRoleIds().contains(scope.get("role_id")))) {
					scopes.remove(i);
				}
			} else { // 组织机构级定义
				if (!user.getOrgId().equals(scope.get("dept_id"))) { // 去掉当前用户不适用的过滤规则
					scopes.remove(i);
				}
			}
		}

		// 确定过滤字段名称
		String filterColumnName = "org_id"; // 默认情况下按照组织机构过滤
		if ("1".equals(funcFilter.get("filter_type"))) {// 按项目过滤
			filterColumnName = "project_id";
		} else if ("2".equals(funcFilter.get("filter_type"))) {// 按用户过滤
			filterColumnName = "creator";
		}
		String fcn = funcFilter.get("filter_column_name");
		filterColumnName = (fcn == null || fcn.length() == 0) ? filterColumnName
				: fcn;

		StringBuffer ftSb = new StringBuffer(
				"SELECT distinct dataAuthView.* FROM (" + sql);

		if ("1".equals(funcFilter.get("filter_type"))) {// 按项目过滤
			ftSb.append(") dataAuthView ");
			String rtable = funcFilter.get("r_tablename");// 关联表名称
			String rfc = funcFilter.get("rt_f_col"); // 过滤字段(关联表)
			String rrc = funcFilter.get("rt_r_col"); // 关联字段(关联表)
			if (scopes.isEmpty()) {
				ftSb.append("," + rtable + " dataAuthOr2g");
				ftSb.append(" WHERE dataAuthView." + filterColumnName
						+ "=dataAuthOrg." + rrc + " AND " + rfc + "='"
						+ user.getUserId() + "' ");
			}
		} else if ("2".equals(funcFilter.get("filter_type"))) {// 按用户过滤
			ftSb.delete(0, ftSb.length());
			ftSb.append("select * from (" + sql + ")dataAuthView ");
			if (scopes.isEmpty()) {

				ftSb.append(" where  dataAuthView." + filterColumnName + "='"
						+ user.getUserId() + "'");
			}
		} else {// 按组织机构过滤
			ftSb.append(")dataAuthView," + AuthInitializor.param.getOrgTable()
					+ " dataAuthOrg");
			ftSb.append(" WHERE dataAuthView." + filterColumnName
					+ "=dataAuthOrg." + AuthInitializor.param.getOrgIdColumn()
					+ " AND (");
			if (scopes == null || scopes.isEmpty()) {// 按用户组织机构权限过滤
				ftSb.append(" dataAuthOrg."
						+ AuthInitializor.param.getOrgCodeColumn() + " LIKE '"
						+ user.getOrgCode() + "%' ");
			} else {// 按p_auth_filter_scope_dms表的条件过滤
				for (int i = 0; i < scopes.size(); i++) {
					if (i > 0)
						ftSb.append(" OR ");
					ftSb.append(" dataAuthOrg."+ AuthInitializor.param.getOrgCodeColumn());
					String orgCode = scopes.get(i).get("org_code"),isCascade = scopes.get(i).get("is_cascade");
					if("1".equals(isCascade)){
						ftSb.append(" like '"+orgCode+"%'");
					}else{
						ftSb.append(" = '"+orgCode+"'");
					}
				}
			}
			ftSb.append(")");
		}

		String filterSql = ftSb.toString();
		// System.out.println("**************************************");
		// System.out.println(filterSql);
		// System.out.println("**************************************");
		if (orderStr != null)
			filterSql += replaceOrderStr(orderStr);
		return filterSql;
	}

	/**
	 * 将ORDER BY RWBI.MODIFY_TIME DESC转为ORDER BY dataAuthView.MODIFY_TIME DESC
	 * 
	 * @param orderStr
	 * @return
	 */
	private static String replaceOrderStr(String orderStr) {
		Pattern pattern = Pattern.compile(" (\\w+)\\u002E");
		Matcher matcher = pattern.matcher(orderStr);
		while (matcher.find()) {
			String table = matcher.group();
			orderStr = orderStr.replaceFirst(table, " dataAuthView.");
		}
		return orderStr;
	}
}
