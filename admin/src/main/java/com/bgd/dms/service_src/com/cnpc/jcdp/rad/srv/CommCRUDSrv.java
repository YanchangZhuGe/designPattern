package com.cnpc.jcdp.rad.srv;

import java.io.Serializable;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.DataPermission;
import com.cnpc.jcdp.common.IDataPermProcessor;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.dao.Record2ColMap;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.rad.util.RADConst;
import com.cnpc.jcdp.rad.util.RadUtil;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.FileUtil;
import com.cnpc.jcdp.util.JsonUtil;


@SuppressWarnings({"unchecked","deprecation"})
public class CommCRUDSrv extends BaseService {
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	private String SQL_LIKE_PERCENT = "#gmslike#";

	/**
	 * 单条记录查询
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRecord(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String sql = reqMsg.getValue("querySql");
		if (sql.indexOf("%") >= 0)
			sql = URLDecoder.decode(sql, "UTF-8");
		Map ret = jdbcDao.queryRecordBySQL(sql);
		retMsg.setValue("data", ret);
		return retMsg;
	}

	/**
	 * 列表查询
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRecords(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String sql = reqMsg.getValue("querySql");
		
		if(sql.indexOf("+")>=0) sql = sql.replace("+","%2B");
		if (sql.indexOf("%") >= 0)
			sql = URLDecoder.decode(sql, "UTF-8");
		
		//处理sql语句中like查询待%的参数
		if(sql.indexOf(SQL_LIKE_PERCENT)>=0)sql = sql.replace(SQL_LIKE_PERCENT,"%");
				
		String currentPage = reqMsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqMsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel param = new PageModel();
		param.setCurrPage(Integer.parseInt(currentPage));
		param.setPageSize(Integer.parseInt(pageSize));
		param.setRowMapper(Record2ColMap.instance);

		// 增加数据权限
		String funcCode = reqMsg.getValue("EP_DATA_AUTH_funcCode");
		if (funcCode != null) {
			IDataPermProcessor dpProc = (IDataPermProcessor) BeanFactory
					.getBean("ICGDataPermProcessor");
			DataPermission dp = dpProc.getDataPermission(reqMsg.getUserToken(),
					funcCode, sql);
			if(dp != null){
				sql = dp.getFilteredSql();
			}
		}

		PageModel model = jdbcDao.queryRecordsBySQL(sql, param);

		retMsg.setValue("datas", model.getData());
		retMsg.setValue("totalRows", model.getTotalRow());
		return retMsg;
	}

	/**
	 * 查看一条记录
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryEntity(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String table = reqMsg.getValue("table");
		String id = reqMsg.getValue("id");
		Map map = jdbcDao.queryEntity(table, id);
		retMsg.setValue("entity", map);
		return retMsg;
	}

	public ISrvMsg updateEntity(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		Map params = reqMsg.toMap();
		RadUtil.decodeParams(params);
		jdbcDao.updateEntity(params, RADConst.TABLE_NAME_KEY,
				RADConst.TABLE_ID_KEY);

		return retMsg;
	}

	public ISrvMsg deleteEntities(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String deleteSql = reqMsg.getValue("deleteSql");
		String[] sqls = deleteSql.split(";");
		String ids = reqMsg.getValue("ids");
		String[] idAr = ids.split(",");
		for (int i = 0; i < idAr.length; i++)
			for (int j = 0; j < sqls.length; j++) {
				String sql = sqls[j].replaceAll("\\u007Bid}", idAr[i]);
				jdbcDao.executeUpdate(sql);
			}

		return retMsg;
	}

	public ISrvMsg updateEntitiesBySql(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String sqlParam = reqMsg.getValue("sql");
		String[] sqls = sqlParam.split(";");
		String ids = reqMsg.getValue("ids");
		String[] idAr = ids.split(",");
		for (int i = 0; i < idAr.length; i++)
			for (int j = 0; j < sqls.length; j++) {
				String sql = sqls[j].replaceAll("\\u007Bid}", idAr[i]);
				jdbcDao.executeUpdate(URLDecoder.decode(sql,"UTF-8"));
			}

		return retMsg;
	}

	/**
	 * 判断是否有重复记录
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryEntityNum(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		Map params = reqMsg.toMap();
		RadUtil.decodeParams(params);
		int totalRows = jdbcDao.queryEntityNum(params, RADConst.TABLE_NAME_KEY,
				RADConst.TABLE_ID_KEY);
		retMsg.setValue("totalRows", totalRows);
		return retMsg;
	}

	public ISrvMsg queryRelationedIds(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		retMsg.setValue("relationedIds", queryIds(reqMsg));
		return retMsg;
	}

	private String queryIds(ISrvMsg reqMsg) throws Exception {
		String rlColumnName = reqMsg.getValue("rlColumnName");
		String rlColumnValue = reqMsg.getValue("rlColumnValue");
		String rlTableName = reqMsg.getValue("rlTableName");
		String toSelColumnName = reqMsg.getValue("toSelColumnName");
		String sql = "SELECT " + toSelColumnName + " FROM " + rlTableName
				+ " WHERE " + rlColumnName + "='" + rlColumnValue + "'";
		List<Map> maps = jdbcDao.queryRecords(sql);
		String ids = ",";
		for (int i = 0; i < maps.size(); i++) {
			Map map = maps.get(i);
			ids += map.values().toArray()[0] + ",";
		}
		return ids;
	}

	/**
	 * 增加关系表数据
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */

	public ISrvMsg addSelectedIds(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String selectedIds = reqMsg.getValue("selectedIds");
		String[] newSelIds = selectedIds.split(",");
		String originIds = reqMsg.getValue("originIds");
		if (originIds == null)
			originIds = "";
		String[] oldSelIds = originIds.split(",");

		Map params = new HashMap();
		params.put(RADConst.TABLE_NAME_KEY, reqMsg.getValue("rlTableName"));
		params.put(reqMsg.getValue("rlColumnName"), reqMsg
				.getValue("rlColumnValue"));
		String toSelColumnName = reqMsg.getValue("toSelColumnName");
		for (int i = 0; i < newSelIds.length; i++) {
			if (originIds.indexOf(newSelIds[i]) >= 0)
				continue;
			params.put(toSelColumnName, newSelIds[i]);
			jdbcDao.insertEntity(params, RADConst.TABLE_NAME_KEY);
		}

		String sql = "DELETE FROM " + params.get(RADConst.TABLE_NAME_KEY);
		String rlColumnName = reqMsg.getValue("rlColumnName");
		if (jdbcDao.isOracleDialect()) {
			rlColumnName = rlColumnName.toUpperCase();
			toSelColumnName = toSelColumnName.toUpperCase();
		}
		sql += " WHERE " + rlColumnName + "='"
				+ reqMsg.getValue("rlColumnValue") + "'";
		sql += " AND " + toSelColumnName + "='";
		for (int i = 0; i < oldSelIds.length; i++) {
			if (selectedIds.indexOf(oldSelIds[i]) < 0) {
				String delSql = sql + oldSelIds[i] + "'";
				jdbcDao.executeUpdate(delSql);
			}
		}

		retMsg.setValue("relationedIds", queryIds(reqMsg));
		return retMsg;
	}

	/**
	 * 新增或修改多条记录
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addOrUpdateEntities(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String tableName = reqMsg.getValue("tableName");
		String rowParams = reqMsg.getValue("rowParams");

		JSONArray rowParamArray = JSONArray.fromString(rowParams);
		for (int i = 0; i < rowParamArray.length(); i++) {
			JSONObject rowParam = rowParamArray.getJSONObject(i);
			Object[] keys = rowParam.keySet().toArray();
			Map params = new HashMap();
			for (int j = 0; j < keys.length; j++)
				params.put(keys[j], rowParam.get(keys[j]));
			RadUtil.decodeParams(params);
			jdbcDao.saveOrUpdateEntity(params, tableName);
		}

		return retMsg;
	}

	private WSFile selectFile(List<WSFile> files, String fieldName) {
		for (int i = 0; i < files.size(); i++) {
			if (files.get(i).getKey().equals(fieldName))
				return files.get(i);
		}
		return null;
	}

	private List<WSFile> selectFileList(List<WSFile> files, String fieldName) {
		List fileList = new ArrayList();
		for (int i = 0; i < files.size(); i++) {
			if (files.get(i).getKey().indexOf(fieldName) != -1) {
				WSFile file_ = files.get(i);
				if (file_.getFileData().length > 0) {
					fileList.add(file_);
				}

			}
		}
		return fileList;
	}

	/**
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addOrUpdateEntity(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);

		Map params = reqMsg.toMap();
		RadUtil.decodeParams(params);
		Object fileId = new Object(); 
		String tableName = params.get(RADConst.TABLE_NAME_KEY).toString();
		
		String fileMsgId = reqMsg.getValue("fileMsgId");
		if (fileMsgId != null) {
			List<WSFile> files = FileUtil.popFiles(fileMsgId);
			String fileFieldsIndex = reqMsg.getValue("fileFieldsIndex");
			JSONArray fileFields = JSONArray.fromString(fileFieldsIndex);
			for (int i = 0; i < fileFields.length(); i++) {
				JSONObject ff = fileFields.getJSONObject(i);
				if ("FILE".equals(ff.get("type"))) {
					Map fileParam = new HashMap();
					fileId = params.get(ff.get("name"));
					if (fileId != null)
						fileParam.put("file_id", fileId);
					WSFile file = selectFile(files, ff.get("name").toString());
					RadUtil.fillFileParam(fileParam, file);
					fileId = jdbcDao.saveOrUpdateEntity(fileParam,
							"p_file_content");
					params.put(ff.get("name"), fileId);
				} else if ("FILES".equals(ff.get("type"))) {
					String tableId = params.get(RADConst.TABLE_ID_KEY)==null?"":params.get(RADConst.TABLE_ID_KEY).toString();
					Map fileParam = new HashMap();
					if(tableId!=""){
						Map map = jdbcDao.queryEntity(tableName, tableId);
						fileId = map.get(ff.get("name"));
						if(fileId !=""){
							fileParam.put("info_id", fileId);
						}else{
							// 在p_file_index表中插入一条记录
							Map fileIndexMap = new HashMap();
							fileIndexMap.put("file_name", "");
							fileIndexMap.put("info_type", "");
							fileIndexMap.put("org_id", "");
							fileIndexMap.put("tableKey", "p_file_index");

							fileId = jdbcDao.insertEntity(fileIndexMap,
									"TABLEKEY").toString();
							fileParam.put("info_id", fileId);
						}
					}else{
					// 在p_file_index表中插入一条记录
					Map fileIndexMap = new HashMap();
					fileIndexMap.put("file_name", "");
					fileIndexMap.put("info_type", "");
					fileIndexMap.put("org_id", "");
					fileIndexMap.put("tableKey", "p_file_index");

					fileId = jdbcDao.insertEntity(fileIndexMap,
							"TABLEKEY").toString();
					fileParam.put("info_id", fileId);
					}
					List<WSFile> files_ = selectFileList(files, ff.get("name")
							.toString());
					for (int j = 0; j < files_.size(); j++) {
						WSFile file_ = files_.get(j);
						RadUtil.fillFileParam(fileParam, file_);
						jdbcDao.saveOrUpdateEntity(fileParam,
								"p_file_content");
						params.put(ff.get("name"), fileId);
					}

				}
			}
		}

		Serializable id = jdbcDao.saveOrUpdateEntity(params, tableName);
		retMsg.setValue("entity_id", id);
		List sqls = reqMsg.getCheckBoxValues("RADSQL");
		if (sqls != null)
			for (int i = 0; i < sqls.size(); i++)
				jdbcDao.executeUpdate(sqls.get(i).toString());
		return retMsg;
	}

	public ISrvMsg addOrUpdateCmpxEntity(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		// 增加主表
		String entityParam = reqMsg.getValue("entityParam");
		JSONObject entity = JSONObject.fromString(entityParam);
		Map params = JsonUtil.jsonObject2Map(entity);
		RadUtil.decodeParams(params);
		String tableName = params.get(RADConst.TABLE_NAME_KEY).toString();
		String entityId = (String) jdbcDao
				.saveOrUpdateEntity(params, tableName);

		// 增加子表
		String itemsParam = reqMsg.getValue("itemsParam");
		String itemTableName = reqMsg.getValue("itemTableName");
		String itemTableFk = reqMsg.getValue("itemTableFk");
		String itemTablePk = jdbcDao.getTablePrimaryKey(itemTableName);
		String sql = "SELECT " + itemTablePk + " FROM " + itemTableName
				+ " WHERE " + itemTableFk + "='" + entityId + "'";
		List<Map> pkList = jdbcDao.queryRecords(sql);
		JSONArray rowParamArray = JSONArray.fromString(itemsParam);
		for (int i = 0; i < rowParamArray.length(); i++) {
			JSONObject rowParam = rowParamArray.getJSONObject(i);
			params = JsonUtil.jsonObject2Map(rowParam);
			params.put(itemTableFk, entityId);
			RadUtil.decodeParams(params);
			Object pk = jdbcDao.saveOrUpdateEntity(params, itemTableName);
			for (int j = 0; j < pkList.size(); j++) {
				String pkValue = pkList.get(j).get(itemTablePk.toLowerCase()).toString();
				if (pkValue.equals(pk)) {
					pkList.remove(j);
					break;
				}
			}
		}
		for (int i = 0; i < pkList.size(); i++) {
			jdbcDao.deleteEntity(itemTableName, pkList.get(i).get(itemTablePk.toLowerCase())
					.toString());
		}
		return retMsg;
	}

	/**
	 * 查询主子表信息
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCmpxEntity(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String sql = reqMsg.getValue("querySql");
		if (sql.indexOf("%") >= 0)
			sql = URLDecoder.decode(sql, "UTF-8");
		Map entity = jdbcDao.queryRecordBySQL(sql);

		sql = reqMsg.getValue("queryItemsSql");
		if (sql.indexOf("%") >= 0)
			sql = URLDecoder.decode(sql, "UTF-8");
		List<Map> items = jdbcDao.queryRecords(sql);

		retMsg.setValue("entity", entity);
		retMsg.setValue("items", items);
		return retMsg;
	}

	/**
	 * 新增或编辑实体时判断某个字段值是否唯一
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg isUniqueEntity(ISrvMsg reqMsg) throws Exception {
		
		Map params = reqMsg.toMap();
		RadUtil.decodeParams(params);
		
		boolean isUnique = true; 
		//处理带条件的唯一性验证
		String tableName = (String)params.get("JCDP_TABLE_NAME");
		
		if("p_auth_user".equals(tableName)){ 
			params.put("user_status", "0");
		} 
		isUnique = jdbcDao.isUniqueEntity(params);
		 
 
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		retMsg.setValue("isUnique", isUnique);
		return retMsg;
	}

	/**
	 * 新增或修改多表数据
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addOrUpdateMultiTableDatas(ISrvMsg reqMsg) throws Exception {
		ISrvMsg retMsg = SrvMsgUtil.createResponseMsg(reqMsg);
		String tables = reqMsg.getValue("jcdp_tables");
		Map tableKey = new HashMap();
		JSONArray tableArray = JSONArray.fromString(tables);
		for (int i = 0; i < tableArray.length(); i++) {
			JSONArray tableCfg = tableArray.getJSONArray(i);
			String tableName = tableCfg.get(0).toString();
			String tableParam = reqMsg.getValue(tableName);
			Map map = JsonUtil
					.jsonObject2Map(JSONObject.fromString(tableParam));
			if (tableCfg.length() == 2) {
				String relation = tableCfg.get(1).toString();
				String[] relArray = relation.split(",");
				for (int j = 0; j < relArray.length; j++) {
					String[] fdValue = relArray[j].split("=");
					map.put(fdValue[0], tableKey.get(fdValue[1]));
				}
			}
			RadUtil.decodeParams(map);
			Serializable id = jdbcDao.saveOrUpdateEntity(map, tableName);
			tableKey.put(tableName, id);
		}

		return retMsg;
	}
}
