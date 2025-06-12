package com.bgp.mcs.service.common.excelIE.util;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;

import com.bgp.mcs.service.common.CodeSelectOptionsUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IJdbcDao;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：邱庆豹
 * 
 * 描述：数据批量保存处理类
 */
@SuppressWarnings("rawtypes")
public class ExcelDataInteractive {

	private static IJdbcDao queryJdbcDao = BeanFactory.getQueryJdbcDAO();

	/*
	 * 利用spring批量保存机制，设置BatchPreparedStatementSetter对象
	 */
	public static BatchPreparedStatementSetter getFormatSetterObject(final List dataFinalList) {
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				List listColumns = null;
				try {
					listColumns = (List) dataFinalList.get(i);
				} catch (Exception e) {
					e.printStackTrace();
				}
				for (int col = 0; col < listColumns.size(); col++) {
					setPsValue(ps, col, listColumns);
				}
			}

			public int getBatchSize() {
				return dataFinalList.size();
			}

		};
		return setter;
	}

	/*
	 * 填充setPsValue方法
	 */
	private static void setPsValue(PreparedStatement ps, int col, List listColumns) {
		Map map = (Map) listColumns.get(col);
		col = col + 1;
		String dataType = (String) (map.get("dataType") == null ? "" : map.get("dataType"));
		try {
			if (dataType.equals("pkValue")||dataType.equals("projectInfoNo")) {
				ps.setString(col, (String) map.get("value"));
			} 
			else if (dataType.equals("fkValue")) {
				String fkSql = (String) map.get("fkSql");
				fkSql = fkSql.replaceAll("\\?", (String) map.get("value"));
				Map mapCode = queryJdbcDao.queryRecordBySQL(fkSql);
				if (mapCode != null && mapCode.get("data") != null) {
					ps.setString(col, (String) mapCode.get("data"));
				} else {
					ps.setString(col, null);
				}
			} else if (dataType.equals("coding")) {

				if (map.get("codeAffordType") != null && !"".equals(map.get("codeAffordType"))) {
					String codeAffordType = (String) map.get("codeAffordType");
					String value = CodeSelectOptionsUtil.getValueByOptionAndName(codeAffordType, (String) map.get("value"));
					ps.setString(col, value);
				} else {
					ps.setString(col, null);
				}
			} else if (dataType.equals("date")) {
				if (map.get("value") != null&&!"".equals(map.get("value"))) {

					ps.setDate(col, new java.sql.Date(((java.util.Date) map.get("value")).getTime()));
				} else {
					ps.setDate(col, null);
				}
			} else if (dataType.equals("string")) {
				String value = (String) map.get("value");
				ps.setString(col, value);
			} else if (dataType.equals("float")) {
				if (map.get("value") == null) {
					ps.setDate(col, null);
				} else {
					ps.setFloat(col, (Float) map.get("value"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
