package com.bgp.gms.service.rm.dm;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.MessageFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.jsoup.helper.StringUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.bgp.mcs.service.common.excelIE.util.ExcelExceptionHandler;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.mat.util.ExcelEIResolvingUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;

/**
 * project: 东方物探项目管理系统
 * 
 * @author 张建波 * description:设备模块保养维修部分设置总成件保养项目
 * 
 */
@Service("DevZcjByItemSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class DevZcjByItemSrv extends BaseService {

	public DevZcjByItemSrv() {
		log = LogFactory.getLogger(DevZcjByItemSrv.class);
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
/**
 * 保存总成件类型
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg savezcjModel(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// 项目编号
	String projectInfoNo = user.getProjectInfoNo();
	String zcj_id = msg.getValue("zcj_id");
	String zcj_model_name = msg.getValue("zcj_model_name");
	String zcj_model_code = msg.getValue("zcj_model_code");
	String zcj_model_id = msg.getValue("zcj_model_id");
	String item_id = msg.getValue("item_id");
	Map<String, Object> dataMap = new HashMap<String, Object>();
	// 如果总成件型号id为空则为新增，else为修改
	if(zcj_model_id.equals("null")){
		dataMap.put("zcj_id", zcj_id);
		dataMap.put("zcj_model_name", zcj_model_name);
		dataMap.put("zcj_model_code", zcj_model_code);
		dataMap.put("bsflag", "0");
		dataMap.put("creator", user.getUserId());
		dataMap.put("create_date", new Date());
		dataMap.put("modifier", user.getUserId());
		dataMap.put("modifi_date", new Date());
	}else{
		dataMap.put("zcj_id", zcj_id);
		dataMap.put("zcj_model_id", zcj_model_id);
		dataMap.put("zcj_model_name", zcj_model_name);
		dataMap.put("zcj_model_code", zcj_model_code);
		dataMap.put("bsflag", "0");
		dataMap.put("modifier", user.getUserId());
		dataMap.put("modifi_date", new Date());
	}
	zcj_model_id= jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_zy_zcj_model").toString();
	if(!item_id.equals("")){
		this.saveZcjByItem(msg, item_id, zcj_model_id);
	}
	//回写成功消息
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * 查询总成件型号
 * **/
@SuppressWarnings("rawtypes")
public ISrvMsg getzcjModelInfo(ISrvMsg msg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	String zcj_model_id = msg.getValue("zcj_model_id");
	String zcj_id = msg.getValue("zcj_id");
	String queryBySql = "select * from gms_device_zy_zcj_model t where t.bsflag=0 "
			+ " and t.zcj_model_id='"+ zcj_model_id + "' "
			+ " and t.zcj_id='"+ zcj_id + "' ";
	Map map = jdbcDao.queryRecordBySQL(queryBySql);
	responseDTO.setValue("datas", map);
	return responseDTO;
}
/**
 * 删除总成件类型
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg deletezcjModel(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// 项目编号
	String projectInfoNo = user.getProjectInfoNo();
	String zcj_model_id = msg.getValue("zcj_model_id");
	String querysgllSql = "update gms_device_zy_zcj_model z set bsflag='1'  where z.zcj_model_id in("
			+ zcj_model_id + ") ";
	jdbcDao.executeUpdate(querysgllSql);
	//回写成功消息
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * 根据总成件id查询总成件型号
 * **/
@SuppressWarnings("rawtypes")
public ISrvMsg queryzcjModelList(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	UserToken user = isrvmsg.getUserToken();
	//获取当前页
	String currentPage = isrvmsg.getValue("currentPage");
	if (currentPage == null || currentPage.trim().equals(""))
		currentPage = "1";
	String pageSize = isrvmsg.getValue("pageSize");
	if (pageSize == null || pageSize.trim().equals("")) {
		ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
		pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
	}
	PageModel page = new PageModel();
	page.setCurrPage(Integer.parseInt(currentPage));
	page.setPageSize(Integer.parseInt(pageSize));
	String zcj_id = isrvmsg.getValue("zcj_id");
	String queryBySql = "select t.*,d.coding_name from gms_device_zy_zcj_model t left join (select * from comm_coding_sort_detail detail where coding_sort_id = '5110000187' and bsflag = '0') d on d.coding_code_id = t.zcj_id where t.bsflag = 0 ";
	//if(!zcj_id.equals("null")){
		queryBySql += " and t.zcj_id='"+ zcj_id + "' ";
	//}
	page = pureJdbcDao.queryRecordsBySQL(queryBySql, page);
	List docList = page.getData();
	responseDTO.setValue("datas", docList);
	responseDTO.setValue("totalRows", page.getTotalRow());
	responseDTO.setValue("pageSize", pageSize);
	return responseDTO;
}
/**
 * 查询总成件保养检查项目
 */
@SuppressWarnings("rawtypes")
public ISrvMsg getZcjByItem(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	String wx_ids=isrvmsg.getValue("zcj_model_id");// 保养表标识
	String sql = "select  b.* from gms_device_zy_zcj_byitem zcj,gms_device_zy_byitem b where b.bsflag='0' and b.item_id=zcj.item_id and zcj.zcj_model_id='"+wx_ids+"'";
	List<Map> byItemList = jdbcDao.queryRecords(sql);
	if(byItemList!=null){
		responseDTO.setValue("byItemList", byItemList);
	}
	return responseDTO;
}
/**
 * 保存总成件保养检查项
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg saveZcjByItem(ISrvMsg msg,String item_id,final String zcj_model_id) throws Exception {
	final UserToken user = msg.getUserToken();
	// 项目编号
	String projectInfoNo = user.getProjectInfoNo();
	Map<String, Object> dataMap = new HashMap<String, Object>();
	// 先清除所有的该总成件型号的下的保养检查项
	String deleteSql = "delete from gms_device_zy_zcj_byitem t where t.zcj_model_id='"+ zcj_model_id + "'";
	jdbcDao.executeUpdate(deleteSql);
	//保存新的总成件型号的保养检查项，可能是批量操作
	final String[] item_ids = item_id.split(",");
	String insMixDetSql = "insert into gms_device_zy_zcj_byitem(item_id,zcj_model_id,bsflag,creator,create_date,modifier,modifi_date)values(?,?,?,?,?,?,?)";
	jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
	new BatchPreparedStatementSetter() {
		@Override
		public void setValues(PreparedStatement ps, int i)
				throws SQLException {
			ps.setString(1, item_ids[i]);
			ps.setString(2, zcj_model_id);
			ps.setString(3, "0");
			ps.setString(4, user.getUserId());
			ps.setDate(5, new java.sql.Date(new Date().getTime()));
			ps.setString(6, user.getUserId());
			ps.setDate(7,  new java.sql.Date(new Date().getTime()));
		}
		@Override
		public int getBatchSize() {
			return item_ids.length;
		}
	});
	//回写成功消息
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * 查询BCD类保养检查项目
 */
@SuppressWarnings("rawtypes")
public ISrvMsg getByItemNotInZcj(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	String zcj_model_id=isrvmsg.getValue("zcj_model_id");// 报废申请单ID
	String sql = " select p.item_name as itemName,p.item_id as itemId,p.item_code as itemCode,p.by_level as bylevel from gms_device_zy_byitem p where p.bsflag='0' ";
	if(!zcj_model_id.equals("null")){
		sql += "and p.item_id not in(select  b.item_id from gms_device_zy_zcj_byitem zcj,gms_device_zy_byitem b where b.bsflag='0' and b.item_id=zcj.item_id "
				+ "and zcj.zcj_model_id='"+zcj_model_id+"')";
	}		
	sql += "  order by p.item_code";
	List<Map> byItemList = jdbcDao.queryRecords(sql);
	if(byItemList!=null){
		responseDTO.setValue("byItemList", byItemList);
	}
	return responseDTO;
}
/**
 * 异步查询节点下的设备编码类别和编码
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("rawtypes")
public ISrvMsg getKkzyTreeAjax(ISrvMsg reqDTO) throws Exception {
	// 1. 节点的ID信息，钻取时需要使用它
	String node = reqDTO.getValue("node");
	DeviceMCSBean deviceBean = new DeviceMCSBean();
	// 2. 第一次进来
	if (node == null || "root".equals(node)) {
		// 查询根节点
		String sql = "select dev_ct_id||'~'||dev_ct_code as id,dev_ct_id||'~'||dev_ct_code as DeviceId,dev_ct_name as name,'false' as leaf,"
				+ "dev_ct_code as Code,'Y' as isDeviceCode,'Y' as isRoot from gms_device_codetype ct where ct.dev_level = 3 and  ct.dev_ct_code='062301'";

		List list = jdbcDao.queryRecords(sql.toString());

		Map map = (Map) list.get(0);
		JSONArray jsonArray = JSONArray.fromObject(map);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		if (jsonArray == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", jsonArray.toString());
		}

		return msg;
	} else {
		String[] nodeinfos = node.split("~", -1);
		// 3. 分级加载：根据传入的nodeid得到下一级的设备类别和设备编码
		String sql = "select dev_ct_id||'~'||dev_ct_code as id,dev_ct_id||'~'||dev_ct_code as deviceid,dev_ct_name as name,'false' as leaf,"
				+
				// "dev_ct_code as code,'Y' as isdevicecode,'N' as isroot from gms_device_codetype ct where ct.parent_dev_ct_id='"+nodeinfos[0]+"' and ct.dev_ct_code not like '0899%'and ct.dev_ct_code not like '0809%'and ct.dev_ct_code not like '0808%'and ct.dev_ct_code not like '0807%' "+
				"dev_ct_code as code,'Y' as isdevicecode,'N' as isroot from gms_device_codetype ct where ct.parent_dev_ct_id='"
				+ nodeinfos[0]
				+ "' "
				+ " union all "
				+ "select dev_ci_id as id,dev_ci_id as deviceid,dev_ci_name||'('||dev_ci_model||')' as name,'true' as leaf,"
				+ "dev_ci_code as code,'N' as isdevicecode,'N' as isroot from gms_device_codeinfo ci where ci.dev_ct_code='"
				+ nodeinfos[1] + "' ";

		List list = jdbcDao.queryRecords(sql.toString());

		JSONArray retJson = JSONArray.fromObject(list);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		if (retJson == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", retJson.toString());
		}

		return msg;
	}
}
/**
 * 异步查询节点下的总成件编码类别和编码
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("rawtypes")
public ISrvMsg getZcjTreeAjax(ISrvMsg reqDTO) throws Exception {
	// 1. 节点的ID信息，钻取时需要使用它
	String node = reqDTO.getValue("node");
	DeviceMCSBean deviceBean = new DeviceMCSBean();
	// 2. 第一次进来
	if (node == null || "root".equals(node)) {
		// 查询根节点
		String sql = "select '5110000187' as id,'5110000187' as DeviceId,'总成件' as name,'false' as leaf,'5110000187' as code,'Y' as isDeviceCode,'Y' as isRoot from dual";

		List list = jdbcDao.queryRecords(sql.toString());

		Map map = (Map) list.get(0);
		JSONArray jsonArray = JSONArray.fromObject(map);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		if (jsonArray == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", jsonArray.toString());
		}

		return msg;
	} else {
		String[] nodeinfos = node.split("~", -1);
		// 3. 分级加载：根据传入的nodeid得到下一级的设备类别和设备编码
		String sql = "select d.coding_code_id as id, d.coding_code_id as deviceId,d.coding_name as name,'true' as leaf,"
				+ "d.coding_code_id as code,'N' as isDeviceCode,'N' as isRoot from comm_coding_sort_detail d where "
				+ "coding_sort_id='"+ nodeinfos[0] + "' and bsflag='0' and coding_code_id in ('5110000187000000001','5110000187000000002','5110000187000000004','5110000187000000015','5110000187000000017')";

		List list = jdbcDao.queryRecords(sql.toString());

		JSONArray retJson = JSONArray.fromObject(list);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		if (retJson == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", retJson.toString());
		}

		return msg;
	}
}
/**
 * 查询设备总成件信息
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public ISrvMsg getDevZcjInfo(ISrvMsg msg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	UserToken user = msg.getUserToken();
	String projectInfoNo = user.getProjectInfoNo();
	String dev_acc_id = msg.getValue("dev_acc_id");
	String querysgllSql = "select models.*,decode(zcjmodel.zcj_model_id,null,'false','true') as checked,'true' as OPen from "
			+ "(select d.coding_code_id as id,d.coding_name as name,'0' as pid, 'true' as nocheck from comm_coding_sort_detail d where coding_code_id in ('5110000187000000001','5110000187000000002','5110000187000000004','5110000187000000015','5110000187000000017') and coding_sort_id='5110000187' and bsflag='0' union all   select del.zcj_model_id as id,del.zcj_model_name as name,del.zcj_id as pid,'false' as nocheck from gms_device_zy_zcj_model del where del.zcj_id in ('5110000187000000001','5110000187000000002','5110000187000000004','5110000187000000015','5110000187000000017')) models  "
			+ " left join (select model.zcj_model_id,acc.dev_acc_id from gms_device_acc_re_zcjmodel model,gms_device_account acc where acc.dev_acc_id = model.dev_acc_id and acc.dev_acc_id ='"+ dev_acc_id + "') zcjmodel "
			+ " on zcjmodel.zcj_model_id = models.id order by models.id";
	List<Map> list = new ArrayList<Map>();
	list = jdbcDao.queryRecords(querysgllSql);
	JSONArray retJson = JSONArray.fromObject(list);
	responseDTO.setValue("json", retJson.toString());
	return responseDTO;
}
/**
 * 可控震源设备与总成件关联设置
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg saveDevZcjModel(ISrvMsg msg) throws Exception {
	final UserToken user = msg.getUserToken();
	// 项目编号
	String projectInfoNo = user.getProjectInfoNo();
	final String dev_acc_id = msg.getValue("dev_acc_id");
	String zcj_model_id = msg.getValue("zcj_model_id");
	String zcj_id = msg.getValue("zcj_id");
	// 先清除所有的该总成件型号的下的保养检查项
	String deleteSql = "delete from gms_device_acc_re_zcjmodel t where t.dev_acc_id='"+ dev_acc_id + "'";
	jdbcDao.executeUpdate(deleteSql);
	//保存新的总成件型号的保养检查项，可能是批量操作
	final String[] zcj_model_ids = zcj_model_id.split(",");
	final String[] zcj_ids =  zcj_id.split(",");
	String insMixDetSql = "insert into gms_device_acc_re_zcjmodel(id,dev_acc_id,zcj_model_id,bsflag,zcj_id,creator,create_date,modifier,modifi_date)values(?,?,?,?,?,?,?,?,?)";
	jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
	new BatchPreparedStatementSetter() {
		@Override
		public void setValues(PreparedStatement ps, int i)
				throws SQLException {
			ps.setString(1, jdbcDao.generateUUID());
			ps.setString(2, dev_acc_id);
			ps.setString(3, zcj_model_ids[i]);
			ps.setString(4, "0");
			ps.setString(5, zcj_ids[i]);
			ps.setString(6, user.getUserId());
			ps.setDate(7, new java.sql.Date(new Date().getTime()));
			ps.setString(8, user.getUserId());
			ps.setDate(9,  new java.sql.Date(new Date().getTime()));
		}
		@Override
		public int getBatchSize() {
			return zcj_model_ids.length;
		}
	});
	//回写成功消息
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * 更新-以更换备件为入口
 * 控震源设备与总成件关联设置
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg updateDevZcjModel(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// 项目编号
	String projectInfoNo = user.getProjectInfoNo();
	final String dev_acc_id = msg.getValue("dev_acc_id");//设备id
	String wz_sequences = msg.getValue("wz_sequences");//总成件系列号
	String zcj_model_id = msg.getValue("zcj_model_id");//总成件型号id
	String querysgllSql ="select update gms_device_acc_re_zcjmodel arz "
			+ " set arz.zcj_model_id ='"+zcj_model_id+"' where arz.zcj_id in(select model.zcj_id from GMS_DEVICE_ZY_ZCJ_Model model,GMS_DEVICE_ZY_ZCJ_MODEL_SEQ seq where seq.zcj_model_id = model.zcj_model_id and "
					+ " seq.zcj_model_sequences='"+wz_sequences + "') and arz.dev_acc_id ='"+dev_acc_id+"'";
	jdbcDao.executeUpdate(querysgllSql);
	//回写成功消息
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * 保存总成件型号下的的系列号
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg saveZcjModelSeq(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// 选中的条数
	int count = Integer.parseInt(msg.getValue("count"));
	// 存储
	String[] lineinfos = msg.getValue("line_infos").split("~", -1);
	String[] zcj_model_sequences = msg.getValue("sequences").split("~", -1);
	String[] zcj_model_ids = msg.getValue("modelIds").split("~", -1);
	String[] ids = msg.getValue("ids").split("~", -1);
	List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
	for (int i = 0; i < count; i++) {
		Map<String, Object> dataMap = new HashMap<String, Object>();
		String keyid = lineinfos[i];
		if (ids[i] != "" && ids[i] != "undefined") {//更新
			dataMap.put("id", ids[i]);
			dataMap.put("zcj_model_sequences", zcj_model_sequences[i]);
			dataMap.put("zcj_model_id", zcj_model_ids[i]);
			dataMap.put("bsflag", "0");
			dataMap.put("modifier", user.getUserId());
			dataMap.put("modifi_date", new Date());
			jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_ZY_ZCJ_MODEL_SEQ");
		} else {//新增
			dataMap.put("zcj_model_sequences", zcj_model_sequences[i]);
			dataMap.put("zcj_model_id", zcj_model_ids[i]);
			dataMap.put("bsflag", "0");
			dataMap.put("creator", user.getUserId());
			dataMap.put("create_date", new Date());
			dataMap.put("modifier", user.getUserId());
			dataMap.put("modifi_date", new Date());
			jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_ZY_ZCJ_MODEL_SEQ");
		}
	}
	// 5.回写成功消息
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}

/**
 * 删除总成件型号下的系列号
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg deleteZcjModelSeq(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// 项目编号
	String projectInfoNo = user.getProjectInfoNo();
	String id = msg.getValue("id");
	// 先清除所有的该总成件型号的下的保养检查项
		String deleteSql = "delete from GMS_DEVICE_ZY_ZCJ_MODEL_SEQ seq where seq.id in ("+id+")" ;
		jdbcDao.executeUpdate(deleteSql);
	//回写成功消息
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * 删除总成件型号下的系列号
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg updateZcjModelSeq(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// 项目编号
	String projectInfoNo = user.getProjectInfoNo();
	String self_num = msg.getValue("self_num");//设备id
	String wz_sequences = msg.getValue("wz_sequences");//系列号id,2016年6月23日16:51:26 此次修改系列号已经作废了，依据总成件型号作为更换对象
	String zcj_code_id = msg.getValue("zcj_code_id");//总成件id
	String zcj_model_id = msg.getValue("zcj_model_id");//总成件型号id
	// 先清除所有的该总成件型号的下的保养检查项
	String updateSql = "update gms_device_acc_re_zcjmodel zcjmodel "
			+ "set zcjmodel.zcj_model_id ='+zcj_model_id+'"
			+ "where zcjmodel.bsflag=0 and "
			+ "zcjmodel.dev_acc_id=(select dev_acc_id from gms_device_account ac where ac.self_num ='"+self_num+"') and "
			+ "zcjmodel.zcj_id = '"+zcj_code_id+"'" ;
		jdbcDao.executeUpdate(updateSql);
	//回写成功消息
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * 查询总成件型号下的系列号
 */
public ISrvMsg getZcjModelSeq(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	String zcj_model_id=isrvmsg.getValue("zcj_model_id");
	String sql = "select seq.* from GMS_DEVICE_ZY_ZCJ_MODEL_SEQ seq where "
			+ " seq.zcj_model_id='"+zcj_model_id+"' order by seq.id";
	List<Map> zcjModelSeqList = jdbcDao.queryRecords(sql);
	if(zcjModelSeqList!=null){
		responseDTO.setValue("zcjModelSeqList", zcjModelSeqList);
	}
	return responseDTO;
}
/**
 * 查询BCD类保养检查项目
 * 2016年5月31日11:02:09 zjb
 */
public ISrvMsg getByItem(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	String by_level=isrvmsg.getValue("by_level");//保养等级
	String dev_acc_id=isrvmsg.getValue("dev_acc_id");//保养设备id
	if(by_level.equals("B")){
		by_level ="'B'";
	}else if(by_level.equals("C")){
		by_level ="'B','C'";
	}else{
		by_level ="'B','C','D'";
	}
	String sql = " select p.item_name as itemName,p.item_id as itemId,p.item_code as itemCode from gms_device_zy_byitem p where "
			+ " p.item_id in (select byitem.item_id from GMS_DEVICE_ZY_ZCJ_BYITEM byitem where byitem.zcj_model_id in(select zcj_model_id from gms_device_acc_re_zcjmodel re where re.dev_acc_id=( select d.fk_dev_acc_id from gms_device_account_dui d where d.dev_acc_id = '"+dev_acc_id+"'))) "
			+ " and p.bsflag='0' and p.by_level in ("+by_level+")  order by p.item_code";
	List<Map> byItemList = jdbcDao.queryRecords(sql);
	if(byItemList!=null){
		responseDTO.setValue("byItemList", byItemList);
	}
	return responseDTO;
}
/**
 * 根据系列号查询总成件型号下的系列号是否存在
 * 
 * @param isrvmsg
 * @return
 * @throws Exception
 */
public ISrvMsg getZySeq(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	String wz_sequences = isrvmsg.getValue("wz_sequences");
	String querySql = "select * from  GMS_DEVICE_ZY_ZCJ_MODEL_SEQ seq where seq.zcj_model_sequences = '"
			+ wz_sequences + "' ";
	Map bjMap = this.jdbcDao.queryRecordBySQL(querySql);
	responseDTO.setValue("data", bjMap);
	return responseDTO;
}
/**
 * 多项目查询可控震源ID 根据实物标识号 ajax
 * 
 * @param isrvmsg
 * @return
 * @throws Exception
 */
public ISrvMsg getZyInfoForDevSigns(ISrvMsg isrvmsg) throws Exception {

	UserToken user = isrvmsg.getUserToken();
	String projectInfoNo = user.getProjectInfoNo();
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	StringBuffer sqlBuffer = new StringBuffer();
	String dev_sign = isrvmsg.getValue("dev_sign");
	String querySql = "select dui.dev_acc_id,dui.dev_sign,dui.self_num,(case when trim(bys.by_nexthours) is not null then bys.by_nexthours else '无' end) by_nexthours,(case when trim(bys.bysx) is not null then substr(bys.bysx,0,1) else '无' end) as yjbyjb from gms_device_account dui "
			+ "left join gms_device_zy_by bys on bys.dev_acc_id = dui.dev_acc_id and  bys.bsflag ='0' and bys.isnewbymsg='0' "
			+ "where dui.dev_type like 'S062301%' and "
			+ "(dui.account_stat='0110000013000000003' or dui.account_stat='0110000013000000006') and "
			+ "dui.dev_sign='"
			+ dev_sign + "' ";
	Map bjMap = this.jdbcDao.queryRecordBySQL(querySql);
	responseDTO.setValue("data", bjMap);
	return responseDTO;
}
/**
 * 查询可控震源ID 根据自编号 ajax
 * 
 * @param isrvmsg
 * @return
 * @throws Exception
 */
public ISrvMsg getZyInfoForSelfNums(ISrvMsg isrvmsg) throws Exception {

	UserToken user = isrvmsg.getUserToken();
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	StringBuffer sqlBuffer = new StringBuffer();
	String self_num = isrvmsg.getValue("self_num");
	// String querySql =
	// "select dev_acc_id from gms_device_account dui where dui.owning_sub_id like '"
	// + user.getOrgSubjectionId()
	// +
	// "%' and  dui.account_stat='0110000013000000003' and dui.dev_type like 'S062301%' and dui.self_num='"
	// + self_num + "' ";

	/*String querySql = "select dev_acc_id from gms_device_account dui where  "
			+ "   dui.account_stat='0110000013000000003' and dui.dev_type like 'S062301%' and dui.self_num='"
			+ self_num + "' ";*/
	String querySql = "select dui.dev_acc_id,dui.dev_sign,dui.self_num,(case when trim(bys.by_nexthours) is not null then bys.by_nexthours else '无' end) by_nexthours,(case when trim(bys.bysx) is not null then substr(bys.bysx,0,1) else '无' end) as yjbyjb from gms_device_account dui "
			+ "left join gms_device_zy_by bys on bys.dev_acc_id = dui.dev_acc_id and  bys.bsflag ='0' and bys.isnewbymsg='0' "
			+ "where dui.dev_type like 'S062301%' and dui.self_num='"
			+ self_num + "' ";
	Map bjMap = this.jdbcDao.queryRecordBySQL(querySql);
	responseDTO.setValue("data", bjMap);
	return responseDTO;
}
/**
 * 查询维修保养计划记录单项目
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public ISrvMsg getwxbyInfo(ISrvMsg msg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	UserToken user = msg.getUserToken();
	String projectInfoNo = user.getProjectInfoNo();
	String wx_id = msg.getValue("wx_ids");
	String querysgllSql = "select  l.bywx_type,l.zcj_type, l.usemat_id, l.bywx_id,l.bywx_date,l.work_hours,l.falut_desc,l.falut_reason,l.falut_case,l.maintenance_level,l.maintenance_desc,l.performance_desc,l.legacy,l.repair_unit,l.repair_men,l.bak, dui.self_num, dui.dev_acc_id,dui.dev_model,dui.dev_name,dui.dev_sign,d.deal_name from gms_device_zy_bywx l "
			+ "left join gms_device_account dui on dui.dev_acc_id = l.dev_acc_id  "
			+ "left join (select fa.usemat_id,listagg(de.deal_name,',') within group ( order by fa.usemat_id ) as deal_name from GMS_DEVICE_ZY_FALUT_DEAL de ,gms_device_zy_falut fa left join gms_device_zy_bywx bywx on fa.usemat_id=bywx.usemat_id where fa.falut_desc = de.deal_id and  fa.bsflag='0' and fa.FALUT_DEAL_FLAG = '0' group by fa.usemat_id)d on l.usemat_id = d.usemat_id "
			+ "where l.bywx_id='"
			+ wx_id + "'";
	List<Map> list = new ArrayList<Map>();
	list = jdbcDao.queryRecords(querysgllSql);
	responseDTO.setValue("datas", list);
	return responseDTO;
}
/**
 * 查询可控震源信息-多项目
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public ISrvMsg getdeviceZyInfo(ISrvMsg msg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	UserToken user = msg.getUserToken();
	String projectInfoNo = user.getProjectInfoNo();
	String wz_id = msg.getValue("wz_id");
	String querysgllSql = "select  dui.self_num, dui.dev_acc_id,dui.dev_name,dui.dev_sign,(case when trim(bys.by_nexthours) is not null then bys.by_nexthours else '无' end) as by_nexthours,(case when trim(bys.bysx) is not null then substr(bys.bysx,0,1) else '无' end) as yjbyjb from gms_device_account  dui "
			+ "left join gms_device_zy_by bys on bys.dev_acc_id = dui.dev_acc_id and  bys.bsflag ='0' and bys.isnewbymsg='0' and 1=1 "
			+ "where   dui.dev_acc_id in("
			+ wz_id + ") ";
	List<Map> list = new ArrayList<Map>();
	list = jdbcDao.queryRecords(querysgllSql);
	responseDTO.setValue("datas", list);
	return responseDTO;
}
/**
 * 更换备件页面查询的备件，不再区分单项目、多项目**/
public ISrvMsg getwxbyMatInfos(ISrvMsg msg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	UserToken user = msg.getUserToken();
	//获取当前页
	String currentPage = msg.getValue("currentPage");
	if (currentPage == null || currentPage.trim().equals(""))
		currentPage = "1";
	String pageSize = msg.getValue("pageSize");
	if (pageSize == null || pageSize.trim().equals("")) {
		ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
		pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
	}
	PageModel page = new PageModel();
	page.setCurrPage(Integer.parseInt(currentPage));
	page.setPageSize(Integer.parseInt(pageSize));
	String wz_name = msg.getValue("wz_name");
	if (wz_name==null) {
		wz_name = "";
	}
	String querysgllSql = "select i.*, c.code_name,tt.postion, tt.stock_num,tt.actual_price,tt.wz_sequence from (select  t.wz_id,t.wz_sequence,t.stock_num, t.actual_price,t.postion  from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '3'   and wz_sequence is  null   and t.project_info_id is null and t.org_subjection_id like '"
			+ user.getSubOrgIDofAffordOrg()
			+ "%' ) tt inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0' ) on tt.wz_id=i.wz_id   where i.wz_name like '%"
			+ wz_name
			+ "%' order by tt.postion asc,i.coding_code_id asc ,i.wz_id asc";

	page = jdbcDao.queryRecordsBySQL(querysgllSql.toString(),page);
	List docList = page.getData();
	responseDTO.setValue("datas", docList);
	responseDTO.setValue("totalRows", page.getTotalRow());
	responseDTO.setValue("pageSize", pageSize);
	return responseDTO;
}
/**
 * 更换备件页面查询的备件，不再区分单项目、多项目
 * 修改：数据不再取gms_mat_recyclemat_info表，直接取gms_mat_infomation
 * by:张建波 
 * **/
public ISrvMsg getwxbyMatInfosNew(ISrvMsg msg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	UserToken user = msg.getUserToken();
	//获取当前页
	String currentPage = msg.getValue("currentPage");
	if (currentPage == null || currentPage.trim().equals(""))
		currentPage = "1";
	String pageSize = msg.getValue("pageSize");
	if (pageSize == null || pageSize.trim().equals("")) {
		ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
		pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
	}
	PageModel page = new PageModel();
	page.setCurrPage(Integer.parseInt(currentPage));
	page.setPageSize(Integer.parseInt(pageSize));
	String wz_name = msg.getValue("wz_name");
	if (wz_name==null) {
		wz_name = "";
	}
	String querysgllSql = "select i.*,c.code_name from gms_mat_infomation i,gms_mat_coding_code c "
			+ "where i.coding_code_id = c.coding_code_id "
			+ "and i.bsflag = '0' "
			+ "and c.bsflag = '0' "
			+ "and i.coding_code_id='51012201' "
			+ "and i.wz_name like '%"+ wz_name+ "%' "
			+ "order by i.coding_code_id asc ,i.wz_id asc";

	page = jdbcDao.queryRecordsBySQL(querysgllSql.toString(),page);
	List docList = page.getData();
	responseDTO.setValue("datas", docList);
	responseDTO.setValue("totalRows", page.getTotalRow());
	responseDTO.setValue("pageSize", pageSize);
	return responseDTO;
}
/**
 * 查询多项目BCD类保养检查项目
 * 2016年6月21日11:02:09 zjb
 */
public ISrvMsg getByItemMuti(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	String by_level=isrvmsg.getValue("by_level");//保养等级
	String dev_acc_id=isrvmsg.getValue("dev_acc_id");//保养设备id
	if(by_level.equals("B")){
		by_level ="'B'";
	}else if(by_level.equals("C")){
		by_level ="'B','C'";
	}else{
		by_level ="'B','C','D'";
	}
	String sql = " select p.item_name as itemName,p.item_id as itemId,p.item_code as itemCode from gms_device_zy_byitem p where "
			+ " p.item_id in (select byitem.item_id from GMS_DEVICE_ZY_ZCJ_BYITEM byitem where byitem.zcj_model_id in(select zcj_model_id from gms_device_acc_re_zcjmodel re where re.dev_acc_id=( select d.dev_acc_id from gms_device_account d where d.dev_acc_id = '"+dev_acc_id+"'))) "
			+ " and p.bsflag='0' and p.by_level in ("+by_level+")  order by p.item_code";
	List<Map> byItemList = jdbcDao.queryRecords(sql);
	if(byItemList!=null){
		responseDTO.setValue("byItemList", byItemList);
	}
	return responseDTO;
}
/**
 * 查询总成件型号根据总成件id
 * **/
@SuppressWarnings("rawtypes")
public ISrvMsg getZcjModel(ISrvMsg msg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	String zcj_id = msg.getValue("zcj_id");
	String queryBySql = "select * from gms_device_zy_zcj_model t where t.bsflag=0 "
			+ " and t.zcj_id='"+ zcj_id + "' ";
	List<Map> list = new ArrayList<Map>();
	list = jdbcDao.queryRecords(queryBySql);
	responseDTO.setValue("datas", list);
	return responseDTO;
}
/**
 * 多项目强制保养excel导入数据库
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
public ISrvMsg saveExcelQzby(ISrvMsg reqDTO) throws Exception {
	JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
	UserToken user = reqDTO.getUserToken();
	String projectInfoId = user.getProjectInfoNo();
	MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
	String errorMessage = null;
	/**
	 * 读取excel中的数据
	 */
	List<WSFile> files = mqMsg.getFiles();
	List<Map> columnList = new ArrayList<Map>();
	List<Map> dataList = new ArrayList();
	if (files != null && !files.isEmpty()) {
		for (int i = 0; i < files.size(); i++) {
			WSFile file = files.get(i);
			dataList = ExcelEIResolvingUtil
					.getQzbyExcelDataByWSFile(file);
		}
	}
	if(dataList.size()>0){
		for(Map map : dataList){
			String dev_name = map.get("dev_name") != null ? map.get("dev_name").toString() : "";
			// 规格型号
			String dev_model = map.get("dev_model")!= null ? map.get("dev_model").toString() : "";
			// 自编号
			String self_num = map.get("self_num")!= null ? map.get("self_num").toString() : "";
			// 实物标识号
			String dev_sign = map.get("dev_sign")!= null ? map.get("dev_sign").toString() : "";
			// 牌照号
			String license_num = map.get("license_num")!= null ? map.get("license_num").toString() : "";
			// erp设备编号
			String dev_coding = map.get("dev_coding")!= null ? map.get("dev_coding").toString() : "";
			// 送修日期
			String repair_start_date = map.get("repair_start_date")!= null ? new DevUtil().returnDateStringSimple(map.get("repair_start_date").toString()) : "";
			// 竣工日期
			String repair_end_date = map.get("repair_end_date")!= null ? new DevUtil().returnDateStringSimple(map.get("repair_end_date").toString()) : "";
			// 工时
			String work_hour = map.get("work_hour")!= null ? map.get("work_hour").toString() : "";
			// 工时费
			String human_cost = map.get("human_cost")!= null ? map.get("human_cost").toString() : "";
			// 本次保养行驶里程(公里)
			String mileage_total = map.get("mileage_total")!= null ? map.get("mileage_total").toString() : "";
			//钻井进尺
			String drilling_footage_total = map.get("drilling_footage_total")!= null ? map.get("drilling_footage_total").toString() : "";
			// 工作小时
			String work_hour_total = map.get("work_hour_total")!= null ? map.get("work_hour_total").toString() : "";
			// 承修人
			String repairer = map.get("repairer")!= null ? map.get("repairer").toString() : "";
			// 验收人
			String accepter = map.get("accepter")!= null ? map.get("accepter").toString() : "";
			// 保养内容
			String repair_detail = map.get("repair_detail")!= null ? map.get("repair_detail").toString() : "";
			// 保养项目
			String repair_item = map.get("repair_item")!= null ? map.get("repair_item").toString() : "";
			// 物资编码
			String wz_id = map.get("wz_id")!= null ? map.get("wz_id").toString() : "";
			// 物资名称
			String wz_name = map.get("wz_name")!= null ? map.get("wz_name").toString() : "";
			// 物资单位
			String wz_prickie = map.get("wz_prickie")!= null ? map.get("wz_prickie").toString() : "";
			// 物资单价
			String wz_price = map.get("wz_price")!= null ? map.get("wz_price").toString() : "0";
			// 消耗数量
			String use_num = map.get("use_num")!= null ? map.get("use_num").toString() : "0";
			// 总价
			Double total_charge = Double.parseDouble(wz_price)*Double.parseDouble(use_num);

			//获取设备id
			Map devmap =  this.getDeviceId(dev_model, self_num, dev_sign, license_num, dev_coding);
 			//主表数据
 			Map maps =  this.getRepairInfo("0110000037000000002", "0110000038000000015", "", "", repair_start_date, 
 					repair_end_date, dev_model, self_num, dev_sign, license_num, dev_coding);
			if (maps != null) {//如果有值，说明已存在该设备的本次维修,只更新主表的费用字段
				String repair_info = maps.get("repair_info").toString();
				String material_cost = maps.get("material_cost").toString();
					if(devmap != null){
						StringBuffer sql = new StringBuffer();
						sql.append("update BGP_COMM_DEVICE_REPAIR_INFO set material_cost=? where repair_info = ?");
						jdbcDao.getJdbcTemplate().update(sql.toString(),
								new Object[] {
									total_charge+Integer.parseInt(material_cost),repair_info});
						//2、保存物资子表
						this.saveRepairDetail(repair_info, wz_name, wz_id, 
								wz_prickie, wz_price, use_num, total_charge, user);
						//0110000038000000015 保养得时候执行如下操作
						this.saveDevMaintain(repair_start_date, devmap.get("dev_acc_id").toString());
						//3、保存保养项目（需先清除所有的已保存过的保养项目）
						this.saveItemDetail(repair_item, repair_info, user);
					}
				//更新从表数据
			}else{//没有同一个设备
				if(devmap != null){
					String repair_info = UUID.randomUUID().toString().replaceAll("-", "");
					StringBuffer sql = new StringBuffer();
					sql.append("insert  into BGP_COMM_DEVICE_REPAIR_INFO(");
					sql.append("repair_info,device_account_id,repair_type,repair_item,repair_start_date,repair_end_date,"
							+ "human_cost,mileage_total,drilling_footage_total,work_hour_total,material_cost,"
							+ "creator,repairer,accepter,work_hour,repair_detail,bsflag)");
					sql.append("values(?,?,?,?,to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd'),?,?,?,?,?,?,?,?,?,?,?)");
					jdbcDao.getJdbcTemplate().update(sql.toString(),
							new Object[] {
								repair_info,devmap.get("dev_acc_id"),"0110000037000000002","0110000038000000015",repair_start_date,repair_end_date,
								human_cost,mileage_total,drilling_footage_total,work_hour_total,total_charge,
								user.getUserId(),repairer,accepter,work_hour,repair_detail,"0"});
					//2、保存物资子表
					this.saveRepairDetail(repair_info, wz_name, wz_id, 
							wz_prickie, wz_price, use_num, total_charge, user);
					//0110000038000000015 保养得时候执行如下操作
					this.saveDevMaintain(repair_start_date, devmap.get("dev_acc_id").toString());
					//3、保存保养项目（需先清除所有的已保存过的保养项目）
					this.saveItemDetail(repair_item, repair_info, user);
				}
			}
		}
	}
	reqMsg.setValue("message", "success");
	return reqMsg;
}
public void saveDevMaintain(String repair_start_date,String dev_acc_id){
	Map map2 = new HashMap();
	map2.put("NEXT_MAINTAIN_DATE",repair_start_date);
	map2.put("DEVICE_ACCOUNT_ID", dev_acc_id);
	jdbcDao.saveOrUpdateEntity(map2, "BGP_COMM_DEVICE_MAINTAIN");
}
public void saveRepairDetail(String repair_info,String wz_name,String wz_id,
		String wz_prickie,String wz_price,String use_num,Double total_charge,UserToken user){
	try{
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String repair_detail_id = UUID.randomUUID().toString().replaceAll("-", "");
		StringBuffer detailsql = new StringBuffer();
		detailsql.append("insert  into BGP_COMM_DEVICE_REPAIR_DETAIL(");
		detailsql.append("repair_detail_id,repair_info,creator,create_date,teammat_out_id,"
				+ "material_spec,material_name,material_coding,material_unit,unit_price,"
				+ "material_amout,out_num,total_charge)");
		detailsql.append("values(?,?,?,?,?,?,?,?,?,?,?,?,?)");
		jdbcDao.getJdbcTemplate().update(detailsql.toString(),
				new Object[] {
					repair_detail_id,repair_info,user.getUserId(),new Date(),"",
					"",wz_name,wz_id,wz_prickie,wz_price,
					use_num,"",total_charge});
	} catch (Exception e) {
		Map<String, Object> reason = new HashMap<String, Object>();
		reason.put("happentime", new Date());
		reason.put("content", "保存材料消耗明细有问题:"+e.getMessage());
		this.jdbcDao.saveOrUpdateEntity(reason,
				"GMS_DEVICE_ZY_DRFAIL");
	}
}
 public void saveItemDetail(String repair_item,String repair_info,UserToken user){
	try{	
	 String sqldeltype = "delete from BGP_COMM_DEVICE_REPAIR_TYPE where repair_info='"
				+ repair_info + "'";
		jdbcDao.executeUpdate(sqldeltype);
	} catch (Exception e) {
		Map<String, Object> reason = new HashMap<String, Object>();
		reason.put("happentime", new Date());
		reason.put("content", "删除保养项目有问题:"+e.getMessage());
		this.jdbcDao.saveOrUpdateEntity(reason,
				"GMS_DEVICE_ZY_DRFAIL");
	}
	List<Map> zcjStoreList = new ArrayList<Map>();
		try{
			String coding_names = (repair_item.replace("；", ";")).replace(";", "','");
			String projectsql = "select d.coding_sort_id,d.coding_code_id,d.coding_name from COMM_CODING_SORT_DETAIL d where "
					+ "d.CODING_SORT_ID = '5110000159' "
					+ "and d.bsflag = '0' "
					+ "and d.coding_name in('"+coding_names+"')";
			zcjStoreList = this.jdbcDao.queryRecords(projectsql);
			if (zcjStoreList != null) {
				if(zcjStoreList.size()>0){
					String[] updateSql = new String[zcjStoreList.size()];
					for (int j = 0; j < zcjStoreList.size(); j++) {
						String insertsql = "insert into BGP_COMM_DEVICE_REPAIR_TYPE (repair_detail_id,repair_info,creator_id,create_date,updator_id,modifi_date,bsflag,type_id) "
								+ "values((select sys_guid() from dual),'"
								+ repair_info
								+ "','"
								+ user.getUserId()
								+ "',sysdate,'"
								+ user.getUserId()
								+ "',sysdate,'0','" + zcjStoreList.get(j).get("coding_code_id") + "')";
						updateSql[j] = insertsql;
					}
					jdbcDao.getJdbcTemplate().batchUpdate(updateSql);
				}
			}
		} catch (Exception e) {
			Map<String, Object> reason = new HashMap<String, Object>();
			reason.put("happentime", new Date());
			reason.put("content", "保存保养项目有问题:"+e.getMessage());
			this.jdbcDao.saveOrUpdateEntity(reason,"GMS_DEVICE_ZY_DRFAIL");
		}
 }
 /**对时间字符串的处理,尽量多的把各个情况考虑进来**/
 public String returnDateString(String x) {
	 	//时间格式是Fri Dec 18 00:00:00 CST 2015普通时间格式
		SimpleDateFormat sdf1 = new SimpleDateFormat("EEE MMM dd HH:mm:ss Z yyyy", Locale.UK);
		Date date;
		try {
			date = sdf1.parse(x);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			x = sdf.format(date);
		} catch (ParseException e) {
		}
		//返回时，ok，如果参数是普通时间类型，我们处理后再返回，如果不是，直接返回
		return x;
	}
 /**
  * 多项目强制保养excel导入数据库
  * 
  * @param reqDTO
  * @return
  * @throws Exception
  */
 public ISrvMsg saveExcelSbwx(ISrvMsg reqDTO) throws Exception {
 	JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
 	ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
 	UserToken user = reqDTO.getUserToken();
 	String projectInfoId = user.getProjectInfoNo();
 	MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
 	String errorMessage = null;
 	/**
 	 * 读取excel中的数据
 	 */
 	List<WSFile> files = mqMsg.getFiles();
 	List<Map> columnList = new ArrayList<Map>();
 	List<Map> dataList = new ArrayList();
 	if (files != null && !files.isEmpty()) {
 		for (int i = 0; i < files.size(); i++) {
 			WSFile file = files.get(i);
 			dataList = ExcelEIResolvingUtil
 					.getSbwxExcelDataByWSFile(file);
 		}
 	}
 	if(dataList.size()>0){
 		for(Map map : dataList){
 			String dev_name = map.get("dev_name") != null ? map.get("dev_name").toString() : "";
 			// 规格型号
 			String dev_model = map.get("dev_model")!= null ? map.get("dev_model").toString() : "";
 			// 自编号
 			String self_num = map.get("self_num")!= null ? map.get("self_num").toString() : "";
 			// 实物标识号
 			String dev_sign = map.get("dev_sign")!= null ? map.get("dev_sign").toString() : "";
 			// 牌照号
 			String license_num = map.get("license_num")!= null ? map.get("license_num").toString() : "";
 			// erp设备编号
 			String dev_coding = map.get("dev_coding")!= null ? map.get("dev_coding").toString() : "";
 			// 送修日期
 			String repair_start_date = map.get("repair_start_date")!= null ? new DevUtil().returnDateStringSimple(map.get("repair_start_date").toString()) : "";
 			// 承修人
 			String repairer = map.get("repairer")!= null ? map.get("repairer").toString() : "";
 			// 修理类别
 			String repair_type = map.get("repair_type")!= null ? map.get("repair_type").toString() : "";
 			// 修理项目
 			String repair_item = map.get("repair_item")!= null ? map.get("repair_item").toString() : "";
 			// 修理级别
 			String repair_level = map.get("repair_level")!= null ? map.get("repair_level").toString() : "";
 			// 工时费
 			String human_cost = map.get("human_cost")!= null ? map.get("human_cost").toString() : "";
 			// 竣工日期
 			String repair_end_date = map.get("repair_end_date")!= null ? new DevUtil().returnDateStringSimple(map.get("repair_end_date").toString()) : "";
 			// 验收人
 			String accepter = map.get("accepter")!= null ? map.get("accepter").toString() : "";
 			// 维修状态
 			String record_status = map.get("record_status")!= null ? map.get("record_status").toString() : "";
 			//技术状况
 			String tech_stat = map.get("tech_stat")!= null ? map.get("tech_stat").toString() : "";
 			// 保养内容
 			String repair_detail = map.get("repair_detail")!= null ? map.get("repair_detail").toString() : "";
 			// 物资编码
 			String wz_id = map.get("wz_id")!= null ? map.get("wz_id").toString() : "";
 			// 物资名称
 			String wz_name = map.get("wz_name")!= null ? map.get("wz_name").toString() : "";
 			// 物资单位
 			String wz_prickie = map.get("wz_prickie")!= null ? map.get("wz_prickie").toString() : "";
 			// 物资单价
 			String wz_price = map.get("wz_price")!= null ? map.get("wz_price").toString() : "0";
 			// 消耗数量
 			String use_num = map.get("use_num")!= null ? map.get("use_num").toString() : "0";
 			// 总价
 			Double total_charge = Double.parseDouble(wz_price)*Double.parseDouble(use_num);
 			//修理类别
			if(repair_type.equals("内修")){
				repair_type = "0100400027000000001";
			}else if(repair_type.equals("自修")){
				repair_type = "100400027000000003";
			}else if(repair_type.equals("外修")){
				repair_type = "0100400027000000002";
			}
			//从数据库查询并复制
			String sortsql = "select coding_code_id,coding_name from comm_coding_sort_detail where coding_sort_id='5110000024' and bsflag='0' and coding_name='"+repair_item+"'";
			Map sortMap = this.jdbcDao.queryRecordBySQL(sortsql);
			if(sortsql!=null){
				repair_item  = sortMap.get("coding_code_id").toString();
			}
			//修理级别
			if(repair_level.equals("项修")){
				repair_level = "5110000197000000001";
			}else if(repair_level.equals("二级保养")){
				repair_level = "5110000197000000002";
			}else if(repair_level.equals("三级保养")){
				repair_level = "5110000197000000003";
			}else if(repair_level.equals("总成大修")){
				repair_level = "5110000197000000004";
			}
			//维修状态
			if(record_status.equals("维修中")){
				record_status = "0";
			}else if(record_status.equals("维修完")){
				record_status = "1";
			}
			//技术状况tech_stat
			if(tech_stat.equals("在修")){
				tech_stat = "0110000006000000007";
			}else if(tech_stat.equals("完好")){
				tech_stat = "0110000006000000001";
			}else if(tech_stat.equals("待报废")){
				tech_stat = "0110000006000000005";
			}
			//获取设备id
			Map devmap =  this.getDeviceId(dev_model, self_num, dev_sign, license_num, dev_coding);
 			//主表数据
 			Map maps =  this.getRepairInfo(repair_type, repair_item, repair_level, record_status, repair_start_date, 
 					repair_end_date, dev_model, self_num, dev_sign, license_num, dev_coding);
 			
 			if (maps != null) {//如果有值，说明已存在该设备的本次维修,只更新主表的费用字段
 				String repair_info = maps.get("repair_info").toString();
 				String material_cost = maps.get("material_cost").toString();
 				
 					if(devmap != null){
 						StringBuffer sql = new StringBuffer();
 						sql.append("update BGP_COMM_DEVICE_REPAIR_INFO set material_cost=? where repair_info = ?");
 						jdbcDao.getJdbcTemplate().update(sql.toString(),
 								new Object[] {
 									total_charge+Integer.parseInt(material_cost),repair_info});
 						//2、保存物资子表
 						this.saveRepairDetail(repair_info, wz_name, wz_id, 
 								wz_prickie, wz_price, use_num, total_charge, user);
 						//3、更新主台账表状态
 	 					this.updateAccountStuts(tech_stat, devmap.get("dev_acc_id").toString());
 					}
 				//更新从表数据
 			}else{//没有同一个设备
 				if(devmap != null){
 					//repair_type、repair_item、repair_level、record_status、tech_stat
 					String repair_info = UUID.randomUUID().toString().replaceAll("-", "");
 					StringBuffer sql = new StringBuffer();
 					sql.append("insert  into BGP_COMM_DEVICE_REPAIR_INFO(");
 					sql.append("repair_info,device_account_id,repair_type,repair_item,repair_start_date,repair_end_date,"
 							+ "human_cost,repair_level,record_status,material_cost,"
 							+ "creator,repairer,accepter,repair_detail,bsflag,datafrom)");
 					sql.append("values(?,?,?,?,to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd'),?,?,?,?,?,?,?,?,?,?)");
 					jdbcDao.getJdbcTemplate().update(sql.toString(),
 							new Object[] {
 								repair_info,devmap.get("dev_acc_id"),repair_type,repair_item,repair_start_date,repair_end_date,
 								human_cost,repair_level,record_status,total_charge,
 								user.getUserId(),repairer,accepter,repair_detail,"0","WTSC"});
 					//2、保存物资子表
 					this.saveRepairDetail(repair_info, wz_name, wz_id, 
 							wz_prickie, wz_price, use_num, total_charge, user);
 					this.saveDevMaintain(repair_start_date, devmap.get("dev_acc_id").toString());
 					//3、更新主台账表状态
 					this.updateAccountStuts(tech_stat, devmap.get("dev_acc_id").toString());
 				}
 			}
 		}
 	}
 	reqMsg.setValue("message", "success");
 	return reqMsg;
 }
 public void updateAccountStuts(String tech_stat,String dev_acc_id){
	try{	
	 // 修理完更新台帐中的技术状况及使用状况 完好
		if (StringUtils.isNotBlank(tech_stat)
				&& tech_stat.equals("0110000006000000001")) {
			String updateAccountInfo = "update gms_device_account account set account.tech_stat='0110000006000000001' , account.USING_STAT='0110000007000000002' where account.dev_acc_id='"
					+ dev_acc_id + "' ";
			jdbcDao.executeUpdate(updateAccountInfo);
		}
		// 在修 更新台帐的使用状态为其他 技术状态为在修
		if (StringUtils.isNotBlank(tech_stat)
				&& tech_stat.equals("0110000006000000007")) {
			String updateAccountInfo = "update gms_device_account account set account.tech_stat='0110000006000000007' , account.USING_STAT='0110000007000000006' where account.dev_acc_id='"
					+ dev_acc_id + "' ";
			jdbcDao.executeUpdate(updateAccountInfo);
		}
		// 待报废 更新台帐的使用状态为其他 技术状态为在修
		if (StringUtils.isNotBlank(tech_stat)
				&& tech_stat.equals("0110000006000000005")) {
			String updateAccountInfo = "update gms_device_account account set account.tech_stat='0110000006000000005' , account.USING_STAT='0110000007000000006' where account.dev_acc_id='"
					+ dev_acc_id + "' ";
			jdbcDao.executeUpdate(updateAccountInfo);
		}
	} catch (Exception e) {
		Map<String, Object> reason = new HashMap<String, Object>();
		reason.put("happentime", new Date());
		reason.put("content", "更新台账技术状况及使用状况有问题:"+e.getMessage());
		this.jdbcDao.saveOrUpdateEntity(reason,
				"GMS_DEVICE_ZY_DRFAIL");
	}
 }
//获取设备id
 public Map getDeviceId(String dev_model,String self_num,String dev_sign,String license_num,String dev_coding){
	 String devSql = "select acc.dev_acc_id from gms_device_account acc where 1=1 ";
		if(!dev_model.equals("")){
			devSql += "and acc.dev_model='"+dev_model+"' ";
		}
		if(!self_num.equals("")){
			devSql += "and acc.self_num='"+self_num+"' ";
		}
		if(!dev_sign.equals("")){
			devSql += "and acc.dev_sign='"+dev_sign+"' ";
		}
		if(!license_num.equals("")){
			devSql += "and acc.license_num='"+license_num+"' ";
		}
		if(!dev_coding.equals("")){
			devSql += "and acc.dev_coding = '"+dev_coding+"' ";
		}
		Map devmap =  jdbcDao.queryRecordBySQL(devSql);
		
		return devmap;
 }
 
 /**
 先根据Erp编码等获取BGP_COMM_DEVICE_REPAIR_INFO 主表数据
 修理类别：0110000037000000002 保养
 */
 public Map getRepairInfo(String repair_type,String repair_item,String repair_level,String record_status,
		 String repair_start_date,String repair_end_date,String dev_model,String self_num,
		 String dev_sign,String license_num,String dev_coding){
	
		String checksql ="select t.repair_info,t.material_cost from BGP_COMM_DEVICE_REPAIR_INFO t where "
				+ "t.repair_type = '"+repair_type+"' "
				+ "and t.repair_item = '"+repair_item+"' "
				+ "and t.bsflag = '0' "
				+ "and t.repair_start_date = to_date('"+repair_start_date+"', 'yyyy-mm-dd') "
				+ "and t.repair_end_date = to_date('"+repair_end_date+"', 'yyyy-mm-dd') "
				+ "and t.device_account_id in (select acc.dev_acc_id from gms_device_account acc where 1=1 ";
		if(!dev_model.equals("")){
			checksql += "and acc.dev_model='"+dev_model+"'";
		}
		if(!self_num.equals("")){
			checksql += "and acc.self_num='"+self_num+"'";
		}
		if(!dev_sign.equals("")){
			checksql += "and acc.dev_sign='"+dev_sign+"'";
		}
		if(!license_num.equals("")){
			checksql += "and acc.license_num='"+license_num+"'";
		}
		if(!dev_coding.equals("")){
			checksql += "and acc.dev_coding = '"+dev_coding+"' ";
		}
		checksql +=")";
		Map maps =  jdbcDao.queryRecordBySQL(checksql);
		return maps;
 }
 /**
  * 单项目外租设备excel导入数据库
  * 
  * @param reqDTO
  * @return
  * @throws Exception
  */
 public ISrvMsg saveExcelWzsb(ISrvMsg reqDTO) throws Exception {
 	JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
 	ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
 	UserToken user = reqDTO.getUserToken();
 	String projectInfoId = user.getProjectInfoNo();
 	MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
 	String errorMessage = null;
 	/**
 	 * 读取excel中的数据
 	 */
 	List<WSFile> files = mqMsg.getFiles();
 	List<Map> columnList = new ArrayList<Map>();
 	List<Map> dataList = new ArrayList();
 	if (files != null && !files.isEmpty()) {
 		for (int i = 0; i < files.size(); i++) {
 			WSFile file = files.get(i);
 			dataList = ExcelEIResolvingUtil
 					.getWzsbExcelDataByWSFile(file);
 		}
 	}
 	if(dataList.size()>0){
 		for(Map map : dataList){
 			String 	dev_coding= map.get("dev_coding")!=null?map.get("dev_coding").toString():"";//设备编号
 			String 	dev_name= map.get("dev_name")!=null?map.get("dev_name").toString():"";//设备名称
 			String 	asset_stat= map.get("asset_stat")!=null?map.get("asset_stat").toString():"";//资产状态  不在账 报废
 			if(asset_stat.equals("不在账")){
 				asset_stat = "0110000013000000006";
			}else if(asset_stat.equals("报废")){
				asset_stat = "0110000013000000001";
			}
 			String 	dev_model= map.get("dev_model")!=null?map.get("dev_model").toString():"";//设备类型
 			String 	self_num= map.get("self_num")!=null?map.get("self_num").toString():"";//自编号
 			String 	dev_sign= map.get("dev_sign")!=null?map.get("dev_sign").toString():"";//实物标识号
 			String 	dev_type= map.get("dev_type")!=null?map.get("dev_type").toString():"";//设备编码
 			String 	dev_unit= map.get("dev_unit")!=null?map.get("dev_unit").toString():"";//计量单位
 			String 	asset_coding= map.get("asset_coding")!=null?map.get("asset_coding").toString():"";//资产编号(ERP)
 			String 	turn_num= map.get("turn_num")!=null?map.get("turn_num").toString():"";//转资单号
 			String 	order_num= map.get("order_num")!=null?map.get("order_num").toString():"";//采购订单号
 			String 	requ_num= map.get("requ_num")!=null?map.get("requ_num").toString():"";//调拨单号
 			String 	asset_value= map.get("asset_value")!=null?map.get("asset_value").toString():"";//资产原值
 			String 	net_value= map.get("net_value")!=null?map.get("net_value").toString():"";//资产净值
 			String 	cont_num= map.get("cont_num")!=null?map.get("cont_num").toString():"";//合同号
 			String 	currency= map.get("currency")!=null?map.get("currency").toString():"";//币种
 			String 	tech_stat= map.get("tech_stat")!=null?map.get("tech_stat").toString():"";//技术状态 完好
 			if(tech_stat.equals("完好")){
 				tech_stat = "0110000006000000001";
			}
 			String 	using_stat= map.get("using_stat")!=null?map.get("using_stat").toString():"";//使用状态 闲置、其他
 			if(using_stat.equals("闲置")){
 				using_stat = "0110000007000000002";
			}else if(using_stat.equals("其他")){
				using_stat = "0110000007000000006";
			}
 			String 	capital_source= map.get("capital_source")!=null?map.get("capital_source").toString():"";//资金来源
 			String 	owning_org_id= map.get("owning_org_id")!=null?map.get("owning_org_id").toString():"";//所属单位
 			String 	owning_org_name= map.get("owning_org_name")!=null?map.get("owning_org_name").toString():"";//所属单位名称
 			String 	owning_sub_id= map.get("owning_sub_id")!=null?map.get("owning_sub_id").toString():"";//所属单位隶属关系
 			String 	usage_org_id= map.get("usage_org_id")!=null?map.get("usage_org_id").toString():"";//所在单位
 			String 	usage_org_name= map.get("usage_org_name")!=null?map.get("usage_org_name").toString():"";//所在单位名称
 			String 	usage_sub_id= map.get("usage_sub_id")!=null?map.get("usage_sub_id").toString():"";//所在单位隶属关系
 			String 	dev_position= map.get("dev_position")!=null?map.get("dev_position").toString():"";//所在位置
 			String 	manu_factur= map.get("manu_factur")!=null?map.get("manu_factur").toString():"";//制造商
 			String 	producting_date= map.get("producting_date")!=null?new DevUtil().returnDateStringSimple(map.get("producting_date").toString()):"";//投产日期
 			String 	account_stat= map.get("account_stat")!=null?map.get("account_stat").toString():"";//在帐状态
 			String 	license_num= map.get("license_num")!=null?map.get("license_num").toString():"";//牌照号
 			String 	chassis_num= map.get("chassis_num")!=null?map.get("chassis_num").toString():"";//底盘号
 			String 	engine_num= map.get("engine_num")!=null?map.get("engine_num").toString():"";//发动机号
 			String 	remark= map.get("remark")!=null?map.get("remark").toString():"";//备注
 			String 	planning_in_time= map.get("planning_in_time")!=null?new DevUtil().returnDateStringSimple(map.get("planning_in_time").toString()):"";//计划开始时间
 			String 	planning_out_time= map.get("planning_out_time")!=null?new DevUtil().returnDateStringSimple(map.get("planning_out_time").toString()):"";//计划结束时间
 			String 	actual_in_time= map.get("actual_in_time")!=null?new DevUtil().returnDateStringSimple(map.get("actual_in_time").toString()):"";//实际开始时间
 			String 	actual_out_time= map.get("actual_out_time")!=null?new DevUtil().returnDateStringSimple(map.get("actual_out_time").toString()):"";//实际结束时间
 			String 	fk_dev_acc_id= map.get("fk_dev_acc_id")!=null?map.get("fk_dev_acc_id").toString():"";//设备总台帐主键
 			String 	project_info_id= projectInfoId;//项目ID
 			String 	out_org_id= map.get("out_org_id")!=null?map.get("out_org_id").toString():"";//出库单位
 			String 	in_org_id= map.get("in_org_id")!=null?map.get("in_org_id").toString():"";//入库单为
 			String 	is_leaving= map.get("is_leaving")!=null?map.get("is_leaving").toString():"";//离队标识 0-未离场  1-已离队
 			if(is_leaving.equals("未离场")){
 				is_leaving = "0";
			}else if(is_leaving.equals("已离队")){
				is_leaving = "1";
			}
 			String 	fk_device_appmix_id= map.get("fk_device_appmix_id")!=null?map.get("fk_device_appmix_id").toString():"";//出库单主键  转移设备单主键
 			String 	search_id= map.get("search_id")!=null?map.get("search_id").toString():"";//查询主键
 			String 	dev_team= map.get("dev_team")!=null?map.get("dev_team").toString():"";//班组
 			String 	stop_date= map.get("stop_date")!=null?new DevUtil().returnDateStringSimple(map.get("stop_date").toString()):"";//报停日期
 			String 	restart_date= map.get("restart_date")!=null?new DevUtil().returnDateStringSimple(map.get("restart_date").toString()):"";//启动日期
 			String 	mix_type_id= map.get("mix_type_id")!=null?map.get("mix_type_id").toString():"";//调配类型
 			String 	check_time= map.get("check_time")!=null?new DevUtil().returnDateStringSimple(map.get("check_time").toString()):"";//检查时间
 			String 	receive_state= map.get("receive_state")!=null?map.get("receive_state").toString():"";//验收状态1:合格;0:不合格
 			if(receive_state.equals("不合格")){
 				receive_state = "0";
			}else if(receive_state.equals("合格")){
				receive_state = "1";
			}
 			String 	transfer_state= map.get("transfer_state")!=null?map.get("transfer_state").toString():"";//井中设备转移状态 0：已转入  1：已转出  2：转出中  3：转入已返还  4：转出已返还
 			if(transfer_state.equals("已转入")){
 				transfer_state = "0";
			}else if(transfer_state.equals("已转出")){
				transfer_state = "1";
			}else if(transfer_state.equals("转出中")){
				transfer_state = "2";
			}else if(transfer_state.equals("转入已返还")){
				transfer_state = "3";
			}else if(transfer_state.equals("转出已返还")){
				transfer_state = "4";
			}
 			String 	fk_wells_transfer_id= map.get("fk_wells_transfer_id")!=null?map.get("fk_wells_transfer_id").toString():"";//井中转移设备单主键
 			String 	repair_state= map.get("repair_state")!=null?map.get("repair_state").toString():"";//井中设备送修：  1：井中设备已送修  2:送修返还
 			if(repair_state.equals("井中设备已送修")){
 				repair_state = "1";
			}else if(repair_state.equals("送修返还")){
				repair_state = "2";
			}
 			String 	repair_wells_back_id= map.get("repair_wells_back_id")!=null?map.get("repair_wells_back_id").toString():"";//井中设备送修单主键
 			String 	transfer_type= map.get("transfer_type")!=null?map.get("transfer_type").toString():"";
 			//设备转移类型  0:单项目设备转移  1:多项目井中项目设备转移 2:多项目井中设备分中心设备转移
 			if(repair_state.equals("单项目设备转移")){
 				repair_state = "0";
			}else if(repair_state.equals("多项目井中项目设备转移")){
				repair_state = "1";
			}else if(repair_state.equals("多项目井中设备分中心设备转移")){
				repair_state = "2";
			}
 			String 	position_id= map.get("position_id")!=null?map.get("position_id").toString():"";//设备存放地编码

			//获取设备id
			Map devmap =  this.getDeviceDuiId(dev_model, self_num, dev_sign, license_num, dev_coding, project_info_id);
			if(devmap != null){
				continue;
			}else{
				//repair_type、repair_item、repair_level、record_status、tech_stat
				String device_account_id = UUID.randomUUID().toString().replaceAll("-", "");
				StringBuffer sql = new StringBuffer();
				sql.append("insert  into gms_device_account_dui(");
				sql.append("dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,"
						+ "turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,"
						+ "owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,"
						+ "license_num,chassis_num,engine_num,remark,planning_in_time,planning_out_time,actual_in_time,actual_out_time,fk_dev_acc_id,project_info_id,"
						+ "out_org_id,in_org_id,is_leaving,fk_device_appmix_id,search_id,dev_team,stop_date,restart_date,mix_type_id,check_time,"
						+ "receive_state,transfer_state,fk_wells_transfer_id,repair_state,repair_wells_back_id,transfer_type,position_id,bsflag)");
				sql.append("values(?,?,?,?,?,?,?,?,?,?,"
						+ "?,?,?,?,?,?,?,?,?,?,"
						+ "?,?,?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),?,"
						+ "?,?,?,?,to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd'),?,?,"
						+ "?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),to_date(?,'yyyy-mm-dd'),?,to_date(?,'yyyy-mm-dd'),"
						+ "?,?,?,?,?,?,?,?)");
				jdbcDao.getJdbcTemplate().update(sql.toString(),
					new Object[] {
						device_account_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,
						turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,
						owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,
						license_num,chassis_num,engine_num,remark,planning_in_time,planning_out_time,actual_in_time,actual_out_time,fk_dev_acc_id,project_info_id,
						out_org_id,in_org_id,is_leaving,fk_device_appmix_id,search_id,dev_team,stop_date,restart_date,mix_type_id,check_time,
						receive_state,transfer_state,fk_wells_transfer_id,repair_state,repair_wells_back_id,transfer_type,position_id,"0"});
			}
 		}
 	}
 	reqMsg.setValue("message", "success");
 	return reqMsg;
 }
//获取单项目设备id
public Map getDeviceDuiId(String dev_model,String self_num,String dev_sign,String license_num,String dev_coding,String project_info_id){
	 String devSql = "select dui.dev_acc_id from gms_device_account_dui dui where bsflag=0 and project_info_id = '"+project_info_id+"' ";
		if(!dev_model.equals("")){
			devSql += "and dui.dev_model='"+dev_model+"'";
		}
		if(!self_num.equals("")){
			devSql += "and dui.self_num='"+self_num+"'";
		}
		if(!dev_sign.equals("")){
			devSql += "and dui.dev_sign='"+dev_sign+"'";
		}
		if(!license_num.equals("")){
			devSql += "and dui.license_num='"+license_num+"'";
		}
		if(!dev_coding.equals("")){
			devSql += "and dui.dev_coding = '"+dev_coding+"' ";
		}
		Map devmap =  jdbcDao.queryRecordBySQL(devSql);
		
		return devmap;
	}
/**
 * 大港设备台账数据导入
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 * @author zjb
 * update 修改删除所属单位和所属单位隶属关系及制造商字段，所属单位名称按下拉框解析并以‘-’区分名称与编码
 */
public ISrvMsg saveDevExcelDg(ISrvMsg reqDTO) throws Exception {
	ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
	String currentdate = DateUtil.convertDateToString(
			DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
	UserToken user = reqDTO.getUserToken();
	MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
	// 获得excel信息
	List<WSFile> files = mqMsg.getFiles();
	List dataList = new ArrayList();
	List<Map> mapLista = new ArrayList();
	List<Map> mapListb = new ArrayList();
	if (files != null && !files.isEmpty()) {
		for (int i = 0; i < files.size(); i++) {
			WSFile file = files.get(i);
			dataList = ExcelEIResolvingUtil.getDEVExcelDataDgByWSFile(file);
		}
		// 遍历dataList，操作数据库
		for (int i = 0; i < dataList.size(); i++) {
			Map dataMap = (Map) dataList.get(i);
			Map kqMap = new HashMap();
			kqMap.put("dev_coding", dataMap.get("dev_coding"));
			kqMap.put("dev_name", dataMap.get("dev_name"));
			kqMap.put("dev_model", dataMap.get("dev_model"));
			kqMap.put("dev_type", dataMap.get("dev_type"));
			if (dataMap.get("account_stat").equals("在账")) {
				kqMap.put("account_stat", "0110000013000000003");
			} else if (dataMap.get("account_stat").equals("报废")) {
				kqMap.put("account_stat", "0110000013000000001");
			} else if(dataMap.get("account_stat").equals("不在账")){
				kqMap.put("account_stat", "0110000013000000006");
			}else{
				kqMap.put("account_stat", "0110000013000000006");
			}
			kqMap.put("dev_sign", dataMap.get("dev_sign"));
			kqMap.put("asset_coding", dataMap.get("asset_coding"));
			kqMap.put("self_num", dataMap.get("self_num"));
			kqMap.put("license_num", dataMap.get("license_num"));
			kqMap.put("engine_num", dataMap.get("engine_num"));
			kqMap.put("chassis_num", dataMap.get("chassis_num"));
			if (dataMap.get("using_stat") == null) {
				kqMap.put("using_stat", "0110000007000000002");
			} else {
				if (dataMap.get("using_stat").equals("其他")) {
					kqMap.put("using_stat", "0110000007000000006");
				} else if (dataMap.get("using_stat").equals("在用")) {
					kqMap.put("using_stat", "0110000007000000001");
				} else if (dataMap.get("using_stat").equals("停用")) {
					kqMap.put("using_stat", "0110000007000000003");
				}else{
					kqMap.put("using_stat", "0110000007000000002");
				}
			}
			kqMap.put("cont_num", dataMap.get("cont_num"));
			if (dataMap.get("tech_stat") == null) {
				kqMap.put("tech_stat", "");
			} else {
				if (dataMap.get("tech_stat").equals("待报废")) {
					kqMap.put("tech_stat", "0110000006000000005");
				} else if (dataMap.get("tech_stat").equals("待修")) {
					kqMap.put("tech_stat", "0110000006000000006");
				} else if (dataMap.get("tech_stat").equals("在修")) {
					kqMap.put("tech_stat", "0110000006000000007");
				} else if (dataMap.get("tech_stat").equals("验收")) {
					kqMap.put("tech_stat", "0110000006000000013");
				} else {
					kqMap.put("tech_stat", "0110000006000000001");
				}
			}
		    kqMap.put("indiv_dev_type", dataMap.get("indiv_dev_type"));
			//kqMap.put("owning_sub_id", dataMap.get("owning_sub_id"));
			kqMap.put("owning_org_id", dataMap.get("owning_org_id"));
			kqMap.put("owning_org_name", dataMap.get("owning_org_name"));
			kqMap.put("create_date", currentdate);
			kqMap.put("ifcountry", "国内");
			kqMap.put("bsflag", "0");
			kqMap.put("spare4", "1");// 物探处手工录入设备
			kqMap.put("manu_factur", "");
			if(kqMap.get("indiv_dev_type").equals("G02")||kqMap.get("indiv_dev_type").equals("G03")){//G02、G03是采集设备，需存储到批量表
				mapListb.add(kqMap);
			}else{
				mapLista.add(kqMap);
			}
			
		}
		final List<Map> mapList1  = mapListb;//批量数据
		if (mapList1 != null) {
			if(mapList1.size()>0){
				String insMixDetSql = "insert into gms_device_account_b(dev_acc_id,dev_coding,dev_name,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,asset_value,"
						+ "net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,"
						+ "usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,license_num,chassis_num,engine_num,remark,"
						+ "indiv_dev_type,ifcountry,bsflag,spare4)values(?,?,?,?,?,?,?,?,?,?,"
						+ "?,?,?,?,?,?,?,?,?,?,"
						+ "?,?,?,?,to_date(?,'yyyy-mm-dd'),?,?,?,?,?,"
						+ "?,?,?,?)";
				jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2,mapList1.get(i).get("dev_coding")!=null?mapList1.get(i).get("dev_coding").toString():"");
						ps.setString(3,mapList1.get(i).get("dev_name")!=null?mapList1.get(i).get("dev_name").toString():"");
						ps.setString(4,mapList1.get(i).get("dev_model")!=null?mapList1.get(i).get("dev_model").toString():"");
						ps.setString(5,mapList1.get(i).get("self_num")!=null?mapList1.get(i).get("self_num").toString():"");
						ps.setString(6,mapList1.get(i).get("dev_sign")!=null?mapList1.get(i).get("dev_sign").toString():"");
						ps.setString(7,mapList1.get(i).get("dev_type")!=null?mapList1.get(i).get("dev_type").toString():"");
						ps.setString(8,mapList1.get(i).get("dev_unit")!=null?mapList1.get(i).get("dev_unit").toString():"");
						ps.setString(9,mapList1.get(i).get("asset_coding")!=null?mapList1.get(i).get("asset_coding").toString():"");
						ps.setString(10,mapList1.get(i).get("asset_value")!=null?mapList1.get(i).get("asset_value").toString():"");
						ps.setString(11,mapList1.get(i).get("net_value")!=null?mapList1.get(i).get("net_value").toString():"");
						ps.setString(12,mapList1.get(i).get("cont_num")!=null?mapList1.get(i).get("cont_num").toString():"");
						ps.setString(13,mapList1.get(i).get("currency")!=null?mapList1.get(i).get("currency").toString():"");
						ps.setString(14,mapList1.get(i).get("tech_stat")!=null?mapList1.get(i).get("tech_stat").toString():"");
						ps.setString(15,mapList1.get(i).get("using_stat")!=null?mapList1.get(i).get("using_stat").toString():"");
						ps.setString(16,mapList1.get(i).get("capital_source")!=null?mapList1.get(i).get("capital_source").toString():"");
						ps.setString(17,mapList1.get(i).get("owning_org_id")!=null?mapList1.get(i).get("owning_org_id").toString():"");
						ps.setString(18,mapList1.get(i).get("owning_org_name")!=null?mapList1.get(i).get("owning_org_name").toString():"");
						ps.setString(19,mapList1.get(i).get("owning_sub_id")!=null?mapList1.get(i).get("owning_sub_id").toString():"");
						ps.setString(20,mapList1.get(i).get("usage_org_id")!=null?mapList1.get(i).get("usage_org_id").toString():"");
						ps.setString(21,mapList1.get(i).get("usage_org_name")!=null?mapList1.get(i).get("usage_org_name").toString():"");
						ps.setString(22,mapList1.get(i).get("usage_sub_id")!=null?mapList1.get(i).get("usage_sub_id").toString():"");
						ps.setString(23,mapList1.get(i).get("dev_position")!=null?mapList1.get(i).get("dev_position").toString():"");
						ps.setString(24,mapList1.get(i).get("manu_factur")!=null?mapList1.get(i).get("manu_factur").toString():"");
						ps.setString(25,mapList1.get(i).get("producting_date")!=null?mapList1.get(i).get("producting_date").toString():"");
						ps.setString(26,mapList1.get(i).get("account_stat")!=null?mapList1.get(i).get("account_stat").toString():"");
						ps.setString(27,mapList1.get(i).get("license_num")!=null?mapList1.get(i).get("license_num").toString():"");
						ps.setString(28,mapList1.get(i).get("chassis_num")!=null?mapList1.get(i).get("chassis_num").toString():"");
						ps.setString(29,mapList1.get(i).get("engine_num")!=null?mapList1.get(i).get("engine_num").toString():"");
						ps.setString(30,mapList1.get(i).get("remark")!=null?mapList1.get(i).get("remark").toString():"");
						ps.setString(31,mapList1.get(i).get("indiv_dev_type")!=null?mapList1.get(i).get("indiv_dev_type").toString():"");
						ps.setString(32,mapList1.get(i).get("ifcountry")!=null?mapList1.get(i).get("ifcountry").toString():"");
						ps.setString(33,mapList1.get(i).get("bsflag")!=null?mapList1.get(i).get("bsflag").toString():"");
						ps.setString(34,mapList1.get(i).get("spare4")!=null?mapList1.get(i).get("spare4").toString():"");// 物探处手工录入设备
					}
					@Override
					public int getBatchSize() {
						return mapList1.size();
					}
				});
			}
		}
		final List<Map> mapList  = mapLista;
		if (mapList != null) {
			if(mapList.size()>0){
				String insMixDetSql = "insert into gms_device_account(dev_acc_id,dev_coding,dev_name,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,asset_value,"
						+ "net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,"
						+ "usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,license_num,chassis_num,engine_num,remark,"
						+ "indiv_dev_type,ifcountry,bsflag,spare4)values(?,?,?,?,?,?,?,?,?,?,"
						+ "?,?,?,?,?,?,?,?,?,?,"
						+ "?,?,?,?,to_date(?,'yyyy-mm-dd'),?,?,?,?,?,"
						+ "?,?,?,?)";
				jdbcDao.getJdbcTemplate().batchUpdate(insMixDetSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2,mapList.get(i).get("dev_coding")!=null?mapList.get(i).get("dev_coding").toString():"");
						ps.setString(3,mapList.get(i).get("dev_name")!=null?mapList.get(i).get("dev_name").toString():"");
						ps.setString(4,mapList.get(i).get("dev_model")!=null?mapList.get(i).get("dev_model").toString():"");
						ps.setString(5,mapList.get(i).get("self_num")!=null?mapList.get(i).get("self_num").toString():"");
						ps.setString(6,mapList.get(i).get("dev_sign")!=null?mapList.get(i).get("dev_sign").toString():"");
						ps.setString(7,mapList.get(i).get("dev_type")!=null?mapList.get(i).get("dev_type").toString():"");
						ps.setString(8,mapList.get(i).get("dev_unit")!=null?mapList.get(i).get("dev_unit").toString():"");
						ps.setString(9,mapList.get(i).get("asset_coding")!=null?mapList.get(i).get("asset_coding").toString():"");
						ps.setString(10,mapList.get(i).get("asset_value")!=null?mapList.get(i).get("asset_value").toString():"");
						ps.setString(11,mapList.get(i).get("net_value")!=null?mapList.get(i).get("net_value").toString():"");
						ps.setString(12,mapList.get(i).get("cont_num")!=null?mapList.get(i).get("cont_num").toString():"");
						ps.setString(13,mapList.get(i).get("currency")!=null?mapList.get(i).get("currency").toString():"");
						ps.setString(14,mapList.get(i).get("tech_stat")!=null?mapList.get(i).get("tech_stat").toString():"");
						ps.setString(15,mapList.get(i).get("using_stat")!=null?mapList.get(i).get("using_stat").toString():"");
						ps.setString(16,mapList.get(i).get("capital_source")!=null?mapList.get(i).get("capital_source").toString():"");
						ps.setString(17,mapList.get(i).get("owning_org_id")!=null?mapList.get(i).get("owning_org_id").toString():"");
						ps.setString(18,mapList.get(i).get("owning_org_name")!=null?mapList.get(i).get("owning_org_name").toString():"");
						ps.setString(19,mapList.get(i).get("owning_sub_id")!=null?mapList.get(i).get("owning_sub_id").toString():"");
						ps.setString(20,mapList.get(i).get("usage_org_id")!=null?mapList.get(i).get("usage_org_id").toString():"");
						ps.setString(21,mapList.get(i).get("usage_org_name")!=null?mapList.get(i).get("usage_org_name").toString():"");
						ps.setString(22,mapList.get(i).get("usage_sub_id")!=null?mapList.get(i).get("usage_sub_id").toString():"");
						ps.setString(23,mapList.get(i).get("dev_position")!=null?mapList.get(i).get("dev_position").toString():"");
						ps.setString(24,mapList.get(i).get("manu_factur")!=null?mapList.get(i).get("manu_factur").toString():"");
						ps.setString(25,mapList.get(i).get("producting_date")!=null?mapList.get(i).get("producting_date").toString():"");
						ps.setString(26,mapList.get(i).get("account_stat")!=null?mapList.get(i).get("account_stat").toString():"");
						ps.setString(27,mapList.get(i).get("license_num")!=null?mapList.get(i).get("license_num").toString():"");
						ps.setString(28,mapList.get(i).get("chassis_num")!=null?mapList.get(i).get("chassis_num").toString():"");
						ps.setString(29,mapList.get(i).get("engine_num")!=null?mapList.get(i).get("engine_num").toString():"");
						ps.setString(30,mapList.get(i).get("remark")!=null?mapList.get(i).get("remark").toString():"");
						ps.setString(31,mapList.get(i).get("indiv_dev_type")!=null?mapList.get(i).get("indiv_dev_type").toString():"");
						ps.setString(32,mapList.get(i).get("ifcountry")!=null?mapList.get(i).get("ifcountry").toString():"");
						ps.setString(33,mapList.get(i).get("bsflag")!=null?mapList.get(i).get("bsflag").toString():"");
						ps.setString(34,mapList.get(i).get("spare4")!=null?mapList.get(i).get("spare4").toString():"");// 物探处手工录入设备
					}
					@Override
					public int getBatchSize() {
						return mapList.size();
					}
				});
			}
		}
	}
	reqMsg.setValue("message", "success");
	return reqMsg;
	}
}