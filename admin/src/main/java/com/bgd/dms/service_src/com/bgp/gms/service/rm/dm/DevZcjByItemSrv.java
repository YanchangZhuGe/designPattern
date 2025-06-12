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
 * project: ������̽��Ŀ����ϵͳ
 * 
 * @author �Ž��� * description:�豸ģ�鱣��ά�޲��������ܳɼ�������Ŀ
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
 * �����ܳɼ�����
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg savezcjModel(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// ��Ŀ���
	String projectInfoNo = user.getProjectInfoNo();
	String zcj_id = msg.getValue("zcj_id");
	String zcj_model_name = msg.getValue("zcj_model_name");
	String zcj_model_code = msg.getValue("zcj_model_code");
	String zcj_model_id = msg.getValue("zcj_model_id");
	String item_id = msg.getValue("item_id");
	Map<String, Object> dataMap = new HashMap<String, Object>();
	// ����ܳɼ��ͺ�idΪ����Ϊ������elseΪ�޸�
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
	//��д�ɹ���Ϣ
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * ��ѯ�ܳɼ��ͺ�
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
 * ɾ���ܳɼ�����
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg deletezcjModel(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// ��Ŀ���
	String projectInfoNo = user.getProjectInfoNo();
	String zcj_model_id = msg.getValue("zcj_model_id");
	String querysgllSql = "update gms_device_zy_zcj_model z set bsflag='1'  where z.zcj_model_id in("
			+ zcj_model_id + ") ";
	jdbcDao.executeUpdate(querysgllSql);
	//��д�ɹ���Ϣ
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * �����ܳɼ�id��ѯ�ܳɼ��ͺ�
 * **/
@SuppressWarnings("rawtypes")
public ISrvMsg queryzcjModelList(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	UserToken user = isrvmsg.getUserToken();
	//��ȡ��ǰҳ
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
 * ��ѯ�ܳɼ����������Ŀ
 */
@SuppressWarnings("rawtypes")
public ISrvMsg getZcjByItem(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	String wx_ids=isrvmsg.getValue("zcj_model_id");// �������ʶ
	String sql = "select  b.* from gms_device_zy_zcj_byitem zcj,gms_device_zy_byitem b where b.bsflag='0' and b.item_id=zcj.item_id and zcj.zcj_model_id='"+wx_ids+"'";
	List<Map> byItemList = jdbcDao.queryRecords(sql);
	if(byItemList!=null){
		responseDTO.setValue("byItemList", byItemList);
	}
	return responseDTO;
}
/**
 * �����ܳɼ����������
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg saveZcjByItem(ISrvMsg msg,String item_id,final String zcj_model_id) throws Exception {
	final UserToken user = msg.getUserToken();
	// ��Ŀ���
	String projectInfoNo = user.getProjectInfoNo();
	Map<String, Object> dataMap = new HashMap<String, Object>();
	// ��������еĸ��ܳɼ��ͺŵ��µı��������
	String deleteSql = "delete from gms_device_zy_zcj_byitem t where t.zcj_model_id='"+ zcj_model_id + "'";
	jdbcDao.executeUpdate(deleteSql);
	//�����µ��ܳɼ��ͺŵı���������������������
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
	//��д�ɹ���Ϣ
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * ��ѯBCD�ౣ�������Ŀ
 */
@SuppressWarnings("rawtypes")
public ISrvMsg getByItemNotInZcj(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	String zcj_model_id=isrvmsg.getValue("zcj_model_id");// �������뵥ID
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
 * �첽��ѯ�ڵ��µ��豸�������ͱ���
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("rawtypes")
public ISrvMsg getKkzyTreeAjax(ISrvMsg reqDTO) throws Exception {
	// 1. �ڵ��ID��Ϣ����ȡʱ��Ҫʹ����
	String node = reqDTO.getValue("node");
	DeviceMCSBean deviceBean = new DeviceMCSBean();
	// 2. ��һ�ν���
	if (node == null || "root".equals(node)) {
		// ��ѯ���ڵ�
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
		// 3. �ּ����أ����ݴ����nodeid�õ���һ�����豸�����豸����
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
 * �첽��ѯ�ڵ��µ��ܳɼ��������ͱ���
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 */
@SuppressWarnings("rawtypes")
public ISrvMsg getZcjTreeAjax(ISrvMsg reqDTO) throws Exception {
	// 1. �ڵ��ID��Ϣ����ȡʱ��Ҫʹ����
	String node = reqDTO.getValue("node");
	DeviceMCSBean deviceBean = new DeviceMCSBean();
	// 2. ��һ�ν���
	if (node == null || "root".equals(node)) {
		// ��ѯ���ڵ�
		String sql = "select '5110000187' as id,'5110000187' as DeviceId,'�ܳɼ�' as name,'false' as leaf,'5110000187' as code,'Y' as isDeviceCode,'Y' as isRoot from dual";

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
		// 3. �ּ����أ����ݴ����nodeid�õ���һ�����豸�����豸����
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
 * ��ѯ�豸�ܳɼ���Ϣ
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
 * �ɿ���Դ�豸���ܳɼ���������
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg saveDevZcjModel(ISrvMsg msg) throws Exception {
	final UserToken user = msg.getUserToken();
	// ��Ŀ���
	String projectInfoNo = user.getProjectInfoNo();
	final String dev_acc_id = msg.getValue("dev_acc_id");
	String zcj_model_id = msg.getValue("zcj_model_id");
	String zcj_id = msg.getValue("zcj_id");
	// ��������еĸ��ܳɼ��ͺŵ��µı��������
	String deleteSql = "delete from gms_device_acc_re_zcjmodel t where t.dev_acc_id='"+ dev_acc_id + "'";
	jdbcDao.executeUpdate(deleteSql);
	//�����µ��ܳɼ��ͺŵı���������������������
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
	//��д�ɹ���Ϣ
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * ����-�Ը�������Ϊ���
 * ����Դ�豸���ܳɼ���������
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg updateDevZcjModel(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// ��Ŀ���
	String projectInfoNo = user.getProjectInfoNo();
	final String dev_acc_id = msg.getValue("dev_acc_id");//�豸id
	String wz_sequences = msg.getValue("wz_sequences");//�ܳɼ�ϵ�к�
	String zcj_model_id = msg.getValue("zcj_model_id");//�ܳɼ��ͺ�id
	String querysgllSql ="select update gms_device_acc_re_zcjmodel arz "
			+ " set arz.zcj_model_id ='"+zcj_model_id+"' where arz.zcj_id in(select model.zcj_id from GMS_DEVICE_ZY_ZCJ_Model model,GMS_DEVICE_ZY_ZCJ_MODEL_SEQ seq where seq.zcj_model_id = model.zcj_model_id and "
					+ " seq.zcj_model_sequences='"+wz_sequences + "') and arz.dev_acc_id ='"+dev_acc_id+"'";
	jdbcDao.executeUpdate(querysgllSql);
	//��д�ɹ���Ϣ
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * �����ܳɼ��ͺ��µĵ�ϵ�к�
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg saveZcjModelSeq(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// ѡ�е�����
	int count = Integer.parseInt(msg.getValue("count"));
	// �洢
	String[] lineinfos = msg.getValue("line_infos").split("~", -1);
	String[] zcj_model_sequences = msg.getValue("sequences").split("~", -1);
	String[] zcj_model_ids = msg.getValue("modelIds").split("~", -1);
	String[] ids = msg.getValue("ids").split("~", -1);
	List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
	for (int i = 0; i < count; i++) {
		Map<String, Object> dataMap = new HashMap<String, Object>();
		String keyid = lineinfos[i];
		if (ids[i] != "" && ids[i] != "undefined") {//����
			dataMap.put("id", ids[i]);
			dataMap.put("zcj_model_sequences", zcj_model_sequences[i]);
			dataMap.put("zcj_model_id", zcj_model_ids[i]);
			dataMap.put("bsflag", "0");
			dataMap.put("modifier", user.getUserId());
			dataMap.put("modifi_date", new Date());
			jdbcDao.saveOrUpdateEntity(dataMap, "GMS_DEVICE_ZY_ZCJ_MODEL_SEQ");
		} else {//����
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
	// 5.��д�ɹ���Ϣ
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}

/**
 * ɾ���ܳɼ��ͺ��µ�ϵ�к�
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg deleteZcjModelSeq(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// ��Ŀ���
	String projectInfoNo = user.getProjectInfoNo();
	String id = msg.getValue("id");
	// ��������еĸ��ܳɼ��ͺŵ��µı��������
		String deleteSql = "delete from GMS_DEVICE_ZY_ZCJ_MODEL_SEQ seq where seq.id in ("+id+")" ;
		jdbcDao.executeUpdate(deleteSql);
	//��д�ɹ���Ϣ
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * ɾ���ܳɼ��ͺ��µ�ϵ�к�
 * 
 * @param msg
 * @return
 * @throws Exception
 */
public ISrvMsg updateZcjModelSeq(ISrvMsg msg) throws Exception {
	UserToken user = msg.getUserToken();
	// ��Ŀ���
	String projectInfoNo = user.getProjectInfoNo();
	String self_num = msg.getValue("self_num");//�豸id
	String wz_sequences = msg.getValue("wz_sequences");//ϵ�к�id,2016��6��23��16:51:26 �˴��޸�ϵ�к��Ѿ������ˣ������ܳɼ��ͺ���Ϊ��������
	String zcj_code_id = msg.getValue("zcj_code_id");//�ܳɼ�id
	String zcj_model_id = msg.getValue("zcj_model_id");//�ܳɼ��ͺ�id
	// ��������еĸ��ܳɼ��ͺŵ��µı��������
	String updateSql = "update gms_device_acc_re_zcjmodel zcjmodel "
			+ "set zcjmodel.zcj_model_id ='+zcj_model_id+'"
			+ "where zcjmodel.bsflag=0 and "
			+ "zcjmodel.dev_acc_id=(select dev_acc_id from gms_device_account ac where ac.self_num ='"+self_num+"') and "
			+ "zcjmodel.zcj_id = '"+zcj_code_id+"'" ;
		jdbcDao.executeUpdate(updateSql);
	//��д�ɹ���Ϣ
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	return responseDTO;
}
/**
 * ��ѯ�ܳɼ��ͺ��µ�ϵ�к�
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
 * ��ѯBCD�ౣ�������Ŀ
 * 2016��5��31��11:02:09 zjb
 */
public ISrvMsg getByItem(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	String by_level=isrvmsg.getValue("by_level");//�����ȼ�
	String dev_acc_id=isrvmsg.getValue("dev_acc_id");//�����豸id
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
 * ����ϵ�кŲ�ѯ�ܳɼ��ͺ��µ�ϵ�к��Ƿ����
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
 * ����Ŀ��ѯ�ɿ���ԴID ����ʵ���ʶ�� ajax
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
	String querySql = "select dui.dev_acc_id,dui.dev_sign,dui.self_num,(case when trim(bys.by_nexthours) is not null then bys.by_nexthours else '��' end) by_nexthours,(case when trim(bys.bysx) is not null then substr(bys.bysx,0,1) else '��' end) as yjbyjb from gms_device_account dui "
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
 * ��ѯ�ɿ���ԴID �����Ա�� ajax
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
	String querySql = "select dui.dev_acc_id,dui.dev_sign,dui.self_num,(case when trim(bys.by_nexthours) is not null then bys.by_nexthours else '��' end) by_nexthours,(case when trim(bys.bysx) is not null then substr(bys.bysx,0,1) else '��' end) as yjbyjb from gms_device_account dui "
			+ "left join gms_device_zy_by bys on bys.dev_acc_id = dui.dev_acc_id and  bys.bsflag ='0' and bys.isnewbymsg='0' "
			+ "where dui.dev_type like 'S062301%' and dui.self_num='"
			+ self_num + "' ";
	Map bjMap = this.jdbcDao.queryRecordBySQL(querySql);
	responseDTO.setValue("data", bjMap);
	return responseDTO;
}
/**
 * ��ѯά�ޱ����ƻ���¼����Ŀ
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
 * ��ѯ�ɿ���Դ��Ϣ-����Ŀ
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
	String querysgllSql = "select  dui.self_num, dui.dev_acc_id,dui.dev_name,dui.dev_sign,(case when trim(bys.by_nexthours) is not null then bys.by_nexthours else '��' end) as by_nexthours,(case when trim(bys.bysx) is not null then substr(bys.bysx,0,1) else '��' end) as yjbyjb from gms_device_account  dui "
			+ "left join gms_device_zy_by bys on bys.dev_acc_id = dui.dev_acc_id and  bys.bsflag ='0' and bys.isnewbymsg='0' and 1=1 "
			+ "where   dui.dev_acc_id in("
			+ wz_id + ") ";
	List<Map> list = new ArrayList<Map>();
	list = jdbcDao.queryRecords(querysgllSql);
	responseDTO.setValue("datas", list);
	return responseDTO;
}
/**
 * ��������ҳ���ѯ�ı������������ֵ���Ŀ������Ŀ**/
public ISrvMsg getwxbyMatInfos(ISrvMsg msg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	UserToken user = msg.getUserToken();
	//��ȡ��ǰҳ
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
 * ��������ҳ���ѯ�ı������������ֵ���Ŀ������Ŀ
 * �޸ģ����ݲ���ȡgms_mat_recyclemat_info��ֱ��ȡgms_mat_infomation
 * by:�Ž��� 
 * **/
public ISrvMsg getwxbyMatInfosNew(ISrvMsg msg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
	UserToken user = msg.getUserToken();
	//��ȡ��ǰҳ
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
 * ��ѯ����ĿBCD�ౣ�������Ŀ
 * 2016��6��21��11:02:09 zjb
 */
public ISrvMsg getByItemMuti(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	String by_level=isrvmsg.getValue("by_level");//�����ȼ�
	String dev_acc_id=isrvmsg.getValue("dev_acc_id");//�����豸id
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
 * ��ѯ�ܳɼ��ͺŸ����ܳɼ�id
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
 * ����Ŀǿ�Ʊ���excel�������ݿ�
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
	 * ��ȡexcel�е�����
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
			// ����ͺ�
			String dev_model = map.get("dev_model")!= null ? map.get("dev_model").toString() : "";
			// �Ա��
			String self_num = map.get("self_num")!= null ? map.get("self_num").toString() : "";
			// ʵ���ʶ��
			String dev_sign = map.get("dev_sign")!= null ? map.get("dev_sign").toString() : "";
			// ���պ�
			String license_num = map.get("license_num")!= null ? map.get("license_num").toString() : "";
			// erp�豸���
			String dev_coding = map.get("dev_coding")!= null ? map.get("dev_coding").toString() : "";
			// ��������
			String repair_start_date = map.get("repair_start_date")!= null ? new DevUtil().returnDateStringSimple(map.get("repair_start_date").toString()) : "";
			// ��������
			String repair_end_date = map.get("repair_end_date")!= null ? new DevUtil().returnDateStringSimple(map.get("repair_end_date").toString()) : "";
			// ��ʱ
			String work_hour = map.get("work_hour")!= null ? map.get("work_hour").toString() : "";
			// ��ʱ��
			String human_cost = map.get("human_cost")!= null ? map.get("human_cost").toString() : "";
			// ���α�����ʻ���(����)
			String mileage_total = map.get("mileage_total")!= null ? map.get("mileage_total").toString() : "";
			//�꾮����
			String drilling_footage_total = map.get("drilling_footage_total")!= null ? map.get("drilling_footage_total").toString() : "";
			// ����Сʱ
			String work_hour_total = map.get("work_hour_total")!= null ? map.get("work_hour_total").toString() : "";
			// ������
			String repairer = map.get("repairer")!= null ? map.get("repairer").toString() : "";
			// ������
			String accepter = map.get("accepter")!= null ? map.get("accepter").toString() : "";
			// ��������
			String repair_detail = map.get("repair_detail")!= null ? map.get("repair_detail").toString() : "";
			// ������Ŀ
			String repair_item = map.get("repair_item")!= null ? map.get("repair_item").toString() : "";
			// ���ʱ���
			String wz_id = map.get("wz_id")!= null ? map.get("wz_id").toString() : "";
			// ��������
			String wz_name = map.get("wz_name")!= null ? map.get("wz_name").toString() : "";
			// ���ʵ�λ
			String wz_prickie = map.get("wz_prickie")!= null ? map.get("wz_prickie").toString() : "";
			// ���ʵ���
			String wz_price = map.get("wz_price")!= null ? map.get("wz_price").toString() : "0";
			// ��������
			String use_num = map.get("use_num")!= null ? map.get("use_num").toString() : "0";
			// �ܼ�
			Double total_charge = Double.parseDouble(wz_price)*Double.parseDouble(use_num);

			//��ȡ�豸id
			Map devmap =  this.getDeviceId(dev_model, self_num, dev_sign, license_num, dev_coding);
 			//��������
 			Map maps =  this.getRepairInfo("0110000037000000002", "0110000038000000015", "", "", repair_start_date, 
 					repair_end_date, dev_model, self_num, dev_sign, license_num, dev_coding);
			if (maps != null) {//�����ֵ��˵���Ѵ��ڸ��豸�ı���ά��,ֻ��������ķ����ֶ�
				String repair_info = maps.get("repair_info").toString();
				String material_cost = maps.get("material_cost").toString();
					if(devmap != null){
						StringBuffer sql = new StringBuffer();
						sql.append("update BGP_COMM_DEVICE_REPAIR_INFO set material_cost=? where repair_info = ?");
						jdbcDao.getJdbcTemplate().update(sql.toString(),
								new Object[] {
									total_charge+Integer.parseInt(material_cost),repair_info});
						//2�����������ӱ�
						this.saveRepairDetail(repair_info, wz_name, wz_id, 
								wz_prickie, wz_price, use_num, total_charge, user);
						//0110000038000000015 ������ʱ��ִ�����²���
						this.saveDevMaintain(repair_start_date, devmap.get("dev_acc_id").toString());
						//3�����汣����Ŀ������������е��ѱ�����ı�����Ŀ��
						this.saveItemDetail(repair_item, repair_info, user);
					}
				//���´ӱ�����
			}else{//û��ͬһ���豸
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
					//2�����������ӱ�
					this.saveRepairDetail(repair_info, wz_name, wz_id, 
							wz_prickie, wz_price, use_num, total_charge, user);
					//0110000038000000015 ������ʱ��ִ�����²���
					this.saveDevMaintain(repair_start_date, devmap.get("dev_acc_id").toString());
					//3�����汣����Ŀ������������е��ѱ�����ı�����Ŀ��
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
		reason.put("content", "�������������ϸ������:"+e.getMessage());
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
		reason.put("content", "ɾ��������Ŀ������:"+e.getMessage());
		this.jdbcDao.saveOrUpdateEntity(reason,
				"GMS_DEVICE_ZY_DRFAIL");
	}
	List<Map> zcjStoreList = new ArrayList<Map>();
		try{
			String coding_names = (repair_item.replace("��", ";")).replace(";", "','");
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
			reason.put("content", "���汣����Ŀ������:"+e.getMessage());
			this.jdbcDao.saveOrUpdateEntity(reason,"GMS_DEVICE_ZY_DRFAIL");
		}
 }
 /**��ʱ���ַ����Ĵ���,������İѸ���������ǽ���**/
 public String returnDateString(String x) {
	 	//ʱ���ʽ��Fri Dec 18 00:00:00 CST 2015��ͨʱ���ʽ
		SimpleDateFormat sdf1 = new SimpleDateFormat("EEE MMM dd HH:mm:ss Z yyyy", Locale.UK);
		Date date;
		try {
			date = sdf1.parse(x);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			x = sdf.format(date);
		} catch (ParseException e) {
		}
		//����ʱ��ok�������������ͨʱ�����ͣ����Ǵ�����ٷ��أ�������ǣ�ֱ�ӷ���
		return x;
	}
 /**
  * ����Ŀǿ�Ʊ���excel�������ݿ�
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
 	 * ��ȡexcel�е�����
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
 			// ����ͺ�
 			String dev_model = map.get("dev_model")!= null ? map.get("dev_model").toString() : "";
 			// �Ա��
 			String self_num = map.get("self_num")!= null ? map.get("self_num").toString() : "";
 			// ʵ���ʶ��
 			String dev_sign = map.get("dev_sign")!= null ? map.get("dev_sign").toString() : "";
 			// ���պ�
 			String license_num = map.get("license_num")!= null ? map.get("license_num").toString() : "";
 			// erp�豸���
 			String dev_coding = map.get("dev_coding")!= null ? map.get("dev_coding").toString() : "";
 			// ��������
 			String repair_start_date = map.get("repair_start_date")!= null ? new DevUtil().returnDateStringSimple(map.get("repair_start_date").toString()) : "";
 			// ������
 			String repairer = map.get("repairer")!= null ? map.get("repairer").toString() : "";
 			// �������
 			String repair_type = map.get("repair_type")!= null ? map.get("repair_type").toString() : "";
 			// ������Ŀ
 			String repair_item = map.get("repair_item")!= null ? map.get("repair_item").toString() : "";
 			// ������
 			String repair_level = map.get("repair_level")!= null ? map.get("repair_level").toString() : "";
 			// ��ʱ��
 			String human_cost = map.get("human_cost")!= null ? map.get("human_cost").toString() : "";
 			// ��������
 			String repair_end_date = map.get("repair_end_date")!= null ? new DevUtil().returnDateStringSimple(map.get("repair_end_date").toString()) : "";
 			// ������
 			String accepter = map.get("accepter")!= null ? map.get("accepter").toString() : "";
 			// ά��״̬
 			String record_status = map.get("record_status")!= null ? map.get("record_status").toString() : "";
 			//����״��
 			String tech_stat = map.get("tech_stat")!= null ? map.get("tech_stat").toString() : "";
 			// ��������
 			String repair_detail = map.get("repair_detail")!= null ? map.get("repair_detail").toString() : "";
 			// ���ʱ���
 			String wz_id = map.get("wz_id")!= null ? map.get("wz_id").toString() : "";
 			// ��������
 			String wz_name = map.get("wz_name")!= null ? map.get("wz_name").toString() : "";
 			// ���ʵ�λ
 			String wz_prickie = map.get("wz_prickie")!= null ? map.get("wz_prickie").toString() : "";
 			// ���ʵ���
 			String wz_price = map.get("wz_price")!= null ? map.get("wz_price").toString() : "0";
 			// ��������
 			String use_num = map.get("use_num")!= null ? map.get("use_num").toString() : "0";
 			// �ܼ�
 			Double total_charge = Double.parseDouble(wz_price)*Double.parseDouble(use_num);
 			//�������
			if(repair_type.equals("����")){
				repair_type = "0100400027000000001";
			}else if(repair_type.equals("����")){
				repair_type = "100400027000000003";
			}else if(repair_type.equals("����")){
				repair_type = "0100400027000000002";
			}
			//�����ݿ��ѯ������
			String sortsql = "select coding_code_id,coding_name from comm_coding_sort_detail where coding_sort_id='5110000024' and bsflag='0' and coding_name='"+repair_item+"'";
			Map sortMap = this.jdbcDao.queryRecordBySQL(sortsql);
			if(sortsql!=null){
				repair_item  = sortMap.get("coding_code_id").toString();
			}
			//������
			if(repair_level.equals("����")){
				repair_level = "5110000197000000001";
			}else if(repair_level.equals("��������")){
				repair_level = "5110000197000000002";
			}else if(repair_level.equals("��������")){
				repair_level = "5110000197000000003";
			}else if(repair_level.equals("�ܳɴ���")){
				repair_level = "5110000197000000004";
			}
			//ά��״̬
			if(record_status.equals("ά����")){
				record_status = "0";
			}else if(record_status.equals("ά����")){
				record_status = "1";
			}
			//����״��tech_stat
			if(tech_stat.equals("����")){
				tech_stat = "0110000006000000007";
			}else if(tech_stat.equals("���")){
				tech_stat = "0110000006000000001";
			}else if(tech_stat.equals("������")){
				tech_stat = "0110000006000000005";
			}
			//��ȡ�豸id
			Map devmap =  this.getDeviceId(dev_model, self_num, dev_sign, license_num, dev_coding);
 			//��������
 			Map maps =  this.getRepairInfo(repair_type, repair_item, repair_level, record_status, repair_start_date, 
 					repair_end_date, dev_model, self_num, dev_sign, license_num, dev_coding);
 			
 			if (maps != null) {//�����ֵ��˵���Ѵ��ڸ��豸�ı���ά��,ֻ��������ķ����ֶ�
 				String repair_info = maps.get("repair_info").toString();
 				String material_cost = maps.get("material_cost").toString();
 				
 					if(devmap != null){
 						StringBuffer sql = new StringBuffer();
 						sql.append("update BGP_COMM_DEVICE_REPAIR_INFO set material_cost=? where repair_info = ?");
 						jdbcDao.getJdbcTemplate().update(sql.toString(),
 								new Object[] {
 									total_charge+Integer.parseInt(material_cost),repair_info});
 						//2�����������ӱ�
 						this.saveRepairDetail(repair_info, wz_name, wz_id, 
 								wz_prickie, wz_price, use_num, total_charge, user);
 						//3��������̨�˱�״̬
 	 					this.updateAccountStuts(tech_stat, devmap.get("dev_acc_id").toString());
 					}
 				//���´ӱ�����
 			}else{//û��ͬһ���豸
 				if(devmap != null){
 					//repair_type��repair_item��repair_level��record_status��tech_stat
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
 					//2�����������ӱ�
 					this.saveRepairDetail(repair_info, wz_name, wz_id, 
 							wz_prickie, wz_price, use_num, total_charge, user);
 					this.saveDevMaintain(repair_start_date, devmap.get("dev_acc_id").toString());
 					//3��������̨�˱�״̬
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
	 // ���������̨���еļ���״����ʹ��״�� ���
		if (StringUtils.isNotBlank(tech_stat)
				&& tech_stat.equals("0110000006000000001")) {
			String updateAccountInfo = "update gms_device_account account set account.tech_stat='0110000006000000001' , account.USING_STAT='0110000007000000002' where account.dev_acc_id='"
					+ dev_acc_id + "' ";
			jdbcDao.executeUpdate(updateAccountInfo);
		}
		// ���� ����̨�ʵ�ʹ��״̬Ϊ���� ����״̬Ϊ����
		if (StringUtils.isNotBlank(tech_stat)
				&& tech_stat.equals("0110000006000000007")) {
			String updateAccountInfo = "update gms_device_account account set account.tech_stat='0110000006000000007' , account.USING_STAT='0110000007000000006' where account.dev_acc_id='"
					+ dev_acc_id + "' ";
			jdbcDao.executeUpdate(updateAccountInfo);
		}
		// ������ ����̨�ʵ�ʹ��״̬Ϊ���� ����״̬Ϊ����
		if (StringUtils.isNotBlank(tech_stat)
				&& tech_stat.equals("0110000006000000005")) {
			String updateAccountInfo = "update gms_device_account account set account.tech_stat='0110000006000000005' , account.USING_STAT='0110000007000000006' where account.dev_acc_id='"
					+ dev_acc_id + "' ";
			jdbcDao.executeUpdate(updateAccountInfo);
		}
	} catch (Exception e) {
		Map<String, Object> reason = new HashMap<String, Object>();
		reason.put("happentime", new Date());
		reason.put("content", "����̨�˼���״����ʹ��״��������:"+e.getMessage());
		this.jdbcDao.saveOrUpdateEntity(reason,
				"GMS_DEVICE_ZY_DRFAIL");
	}
 }
//��ȡ�豸id
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
 �ȸ���Erp����Ȼ�ȡBGP_COMM_DEVICE_REPAIR_INFO ��������
 �������0110000037000000002 ����
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
  * ����Ŀ�����豸excel�������ݿ�
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
 	 * ��ȡexcel�е�����
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
 			String 	dev_coding= map.get("dev_coding")!=null?map.get("dev_coding").toString():"";//�豸���
 			String 	dev_name= map.get("dev_name")!=null?map.get("dev_name").toString():"";//�豸����
 			String 	asset_stat= map.get("asset_stat")!=null?map.get("asset_stat").toString():"";//�ʲ�״̬  ������ ����
 			if(asset_stat.equals("������")){
 				asset_stat = "0110000013000000006";
			}else if(asset_stat.equals("����")){
				asset_stat = "0110000013000000001";
			}
 			String 	dev_model= map.get("dev_model")!=null?map.get("dev_model").toString():"";//�豸����
 			String 	self_num= map.get("self_num")!=null?map.get("self_num").toString():"";//�Ա��
 			String 	dev_sign= map.get("dev_sign")!=null?map.get("dev_sign").toString():"";//ʵ���ʶ��
 			String 	dev_type= map.get("dev_type")!=null?map.get("dev_type").toString():"";//�豸����
 			String 	dev_unit= map.get("dev_unit")!=null?map.get("dev_unit").toString():"";//������λ
 			String 	asset_coding= map.get("asset_coding")!=null?map.get("asset_coding").toString():"";//�ʲ����(ERP)
 			String 	turn_num= map.get("turn_num")!=null?map.get("turn_num").toString():"";//ת�ʵ���
 			String 	order_num= map.get("order_num")!=null?map.get("order_num").toString():"";//�ɹ�������
 			String 	requ_num= map.get("requ_num")!=null?map.get("requ_num").toString():"";//��������
 			String 	asset_value= map.get("asset_value")!=null?map.get("asset_value").toString():"";//�ʲ�ԭֵ
 			String 	net_value= map.get("net_value")!=null?map.get("net_value").toString():"";//�ʲ���ֵ
 			String 	cont_num= map.get("cont_num")!=null?map.get("cont_num").toString():"";//��ͬ��
 			String 	currency= map.get("currency")!=null?map.get("currency").toString():"";//����
 			String 	tech_stat= map.get("tech_stat")!=null?map.get("tech_stat").toString():"";//����״̬ ���
 			if(tech_stat.equals("���")){
 				tech_stat = "0110000006000000001";
			}
 			String 	using_stat= map.get("using_stat")!=null?map.get("using_stat").toString():"";//ʹ��״̬ ���á�����
 			if(using_stat.equals("����")){
 				using_stat = "0110000007000000002";
			}else if(using_stat.equals("����")){
				using_stat = "0110000007000000006";
			}
 			String 	capital_source= map.get("capital_source")!=null?map.get("capital_source").toString():"";//�ʽ���Դ
 			String 	owning_org_id= map.get("owning_org_id")!=null?map.get("owning_org_id").toString():"";//������λ
 			String 	owning_org_name= map.get("owning_org_name")!=null?map.get("owning_org_name").toString():"";//������λ����
 			String 	owning_sub_id= map.get("owning_sub_id")!=null?map.get("owning_sub_id").toString():"";//������λ������ϵ
 			String 	usage_org_id= map.get("usage_org_id")!=null?map.get("usage_org_id").toString():"";//���ڵ�λ
 			String 	usage_org_name= map.get("usage_org_name")!=null?map.get("usage_org_name").toString():"";//���ڵ�λ����
 			String 	usage_sub_id= map.get("usage_sub_id")!=null?map.get("usage_sub_id").toString():"";//���ڵ�λ������ϵ
 			String 	dev_position= map.get("dev_position")!=null?map.get("dev_position").toString():"";//����λ��
 			String 	manu_factur= map.get("manu_factur")!=null?map.get("manu_factur").toString():"";//������
 			String 	producting_date= map.get("producting_date")!=null?new DevUtil().returnDateStringSimple(map.get("producting_date").toString()):"";//Ͷ������
 			String 	account_stat= map.get("account_stat")!=null?map.get("account_stat").toString():"";//����״̬
 			String 	license_num= map.get("license_num")!=null?map.get("license_num").toString():"";//���պ�
 			String 	chassis_num= map.get("chassis_num")!=null?map.get("chassis_num").toString():"";//���̺�
 			String 	engine_num= map.get("engine_num")!=null?map.get("engine_num").toString():"";//��������
 			String 	remark= map.get("remark")!=null?map.get("remark").toString():"";//��ע
 			String 	planning_in_time= map.get("planning_in_time")!=null?new DevUtil().returnDateStringSimple(map.get("planning_in_time").toString()):"";//�ƻ���ʼʱ��
 			String 	planning_out_time= map.get("planning_out_time")!=null?new DevUtil().returnDateStringSimple(map.get("planning_out_time").toString()):"";//�ƻ�����ʱ��
 			String 	actual_in_time= map.get("actual_in_time")!=null?new DevUtil().returnDateStringSimple(map.get("actual_in_time").toString()):"";//ʵ�ʿ�ʼʱ��
 			String 	actual_out_time= map.get("actual_out_time")!=null?new DevUtil().returnDateStringSimple(map.get("actual_out_time").toString()):"";//ʵ�ʽ���ʱ��
 			String 	fk_dev_acc_id= map.get("fk_dev_acc_id")!=null?map.get("fk_dev_acc_id").toString():"";//�豸��̨������
 			String 	project_info_id= projectInfoId;//��ĿID
 			String 	out_org_id= map.get("out_org_id")!=null?map.get("out_org_id").toString():"";//���ⵥλ
 			String 	in_org_id= map.get("in_org_id")!=null?map.get("in_org_id").toString():"";//��ⵥΪ
 			String 	is_leaving= map.get("is_leaving")!=null?map.get("is_leaving").toString():"";//��ӱ�ʶ 0-δ�볡  1-�����
 			if(is_leaving.equals("δ�볡")){
 				is_leaving = "0";
			}else if(is_leaving.equals("�����")){
				is_leaving = "1";
			}
 			String 	fk_device_appmix_id= map.get("fk_device_appmix_id")!=null?map.get("fk_device_appmix_id").toString():"";//���ⵥ����  ת���豸������
 			String 	search_id= map.get("search_id")!=null?map.get("search_id").toString():"";//��ѯ����
 			String 	dev_team= map.get("dev_team")!=null?map.get("dev_team").toString():"";//����
 			String 	stop_date= map.get("stop_date")!=null?new DevUtil().returnDateStringSimple(map.get("stop_date").toString()):"";//��ͣ����
 			String 	restart_date= map.get("restart_date")!=null?new DevUtil().returnDateStringSimple(map.get("restart_date").toString()):"";//��������
 			String 	mix_type_id= map.get("mix_type_id")!=null?map.get("mix_type_id").toString():"";//��������
 			String 	check_time= map.get("check_time")!=null?new DevUtil().returnDateStringSimple(map.get("check_time").toString()):"";//���ʱ��
 			String 	receive_state= map.get("receive_state")!=null?map.get("receive_state").toString():"";//����״̬1:�ϸ�;0:���ϸ�
 			if(receive_state.equals("���ϸ�")){
 				receive_state = "0";
			}else if(receive_state.equals("�ϸ�")){
				receive_state = "1";
			}
 			String 	transfer_state= map.get("transfer_state")!=null?map.get("transfer_state").toString():"";//�����豸ת��״̬ 0����ת��  1����ת��  2��ת����  3��ת���ѷ���  4��ת���ѷ���
 			if(transfer_state.equals("��ת��")){
 				transfer_state = "0";
			}else if(transfer_state.equals("��ת��")){
				transfer_state = "1";
			}else if(transfer_state.equals("ת����")){
				transfer_state = "2";
			}else if(transfer_state.equals("ת���ѷ���")){
				transfer_state = "3";
			}else if(transfer_state.equals("ת���ѷ���")){
				transfer_state = "4";
			}
 			String 	fk_wells_transfer_id= map.get("fk_wells_transfer_id")!=null?map.get("fk_wells_transfer_id").toString():"";//����ת���豸������
 			String 	repair_state= map.get("repair_state")!=null?map.get("repair_state").toString():"";//�����豸���ޣ�  1�������豸������  2:���޷���
 			if(repair_state.equals("�����豸������")){
 				repair_state = "1";
			}else if(repair_state.equals("���޷���")){
				repair_state = "2";
			}
 			String 	repair_wells_back_id= map.get("repair_wells_back_id")!=null?map.get("repair_wells_back_id").toString():"";//�����豸���޵�����
 			String 	transfer_type= map.get("transfer_type")!=null?map.get("transfer_type").toString():"";
 			//�豸ת������  0:����Ŀ�豸ת��  1:����Ŀ������Ŀ�豸ת�� 2:����Ŀ�����豸�������豸ת��
 			if(repair_state.equals("����Ŀ�豸ת��")){
 				repair_state = "0";
			}else if(repair_state.equals("����Ŀ������Ŀ�豸ת��")){
				repair_state = "1";
			}else if(repair_state.equals("����Ŀ�����豸�������豸ת��")){
				repair_state = "2";
			}
 			String 	position_id= map.get("position_id")!=null?map.get("position_id").toString():"";//�豸��ŵر���

			//��ȡ�豸id
			Map devmap =  this.getDeviceDuiId(dev_model, self_num, dev_sign, license_num, dev_coding, project_info_id);
			if(devmap != null){
				continue;
			}else{
				//repair_type��repair_item��repair_level��record_status��tech_stat
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
//��ȡ����Ŀ�豸id
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
 * ����豸̨�����ݵ���
 * 
 * @param reqDTO
 * @return
 * @throws Exception
 * @author zjb
 * update �޸�ɾ��������λ��������λ������ϵ���������ֶΣ�������λ���ư�������������ԡ�-���������������
 */
public ISrvMsg saveDevExcelDg(ISrvMsg reqDTO) throws Exception {
	ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
	String currentdate = DateUtil.convertDateToString(
			DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
	UserToken user = reqDTO.getUserToken();
	MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
	// ���excel��Ϣ
	List<WSFile> files = mqMsg.getFiles();
	List dataList = new ArrayList();
	List<Map> mapLista = new ArrayList();
	List<Map> mapListb = new ArrayList();
	if (files != null && !files.isEmpty()) {
		for (int i = 0; i < files.size(); i++) {
			WSFile file = files.get(i);
			dataList = ExcelEIResolvingUtil.getDEVExcelDataDgByWSFile(file);
		}
		// ����dataList���������ݿ�
		for (int i = 0; i < dataList.size(); i++) {
			Map dataMap = (Map) dataList.get(i);
			Map kqMap = new HashMap();
			kqMap.put("dev_coding", dataMap.get("dev_coding"));
			kqMap.put("dev_name", dataMap.get("dev_name"));
			kqMap.put("dev_model", dataMap.get("dev_model"));
			kqMap.put("dev_type", dataMap.get("dev_type"));
			if (dataMap.get("account_stat").equals("����")) {
				kqMap.put("account_stat", "0110000013000000003");
			} else if (dataMap.get("account_stat").equals("����")) {
				kqMap.put("account_stat", "0110000013000000001");
			} else if(dataMap.get("account_stat").equals("������")){
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
				if (dataMap.get("using_stat").equals("����")) {
					kqMap.put("using_stat", "0110000007000000006");
				} else if (dataMap.get("using_stat").equals("����")) {
					kqMap.put("using_stat", "0110000007000000001");
				} else if (dataMap.get("using_stat").equals("ͣ��")) {
					kqMap.put("using_stat", "0110000007000000003");
				}else{
					kqMap.put("using_stat", "0110000007000000002");
				}
			}
			kqMap.put("cont_num", dataMap.get("cont_num"));
			if (dataMap.get("tech_stat") == null) {
				kqMap.put("tech_stat", "");
			} else {
				if (dataMap.get("tech_stat").equals("������")) {
					kqMap.put("tech_stat", "0110000006000000005");
				} else if (dataMap.get("tech_stat").equals("����")) {
					kqMap.put("tech_stat", "0110000006000000006");
				} else if (dataMap.get("tech_stat").equals("����")) {
					kqMap.put("tech_stat", "0110000006000000007");
				} else if (dataMap.get("tech_stat").equals("����")) {
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
			kqMap.put("ifcountry", "����");
			kqMap.put("bsflag", "0");
			kqMap.put("spare4", "1");// ��̽���ֹ�¼���豸
			kqMap.put("manu_factur", "");
			if(kqMap.get("indiv_dev_type").equals("G02")||kqMap.get("indiv_dev_type").equals("G03")){//G02��G03�ǲɼ��豸����洢��������
				mapListb.add(kqMap);
			}else{
				mapLista.add(kqMap);
			}
			
		}
		final List<Map> mapList1  = mapListb;//��������
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
						ps.setString(34,mapList1.get(i).get("spare4")!=null?mapList1.get(i).get("spare4").toString():"");// ��̽���ֹ�¼���豸
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
						ps.setString(34,mapList.get(i).get("spare4")!=null?mapList.get(i).get("spare4").toString():"");// ��̽���ֹ�¼���豸
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