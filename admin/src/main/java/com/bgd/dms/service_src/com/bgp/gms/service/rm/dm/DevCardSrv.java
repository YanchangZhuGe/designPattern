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
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.cxf.binding.corba.wsdl.Array;
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

import com.bgp.dms.util.CommonConstants;
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
import com.cnpc.jcdp.mvc.taglib.html.ImgTag;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;
import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;

/**
 * project: 东方物探生产管理系统
 * 
 * creator: dz
 * 
 * creator time:2016-5-9
 * 
 * description:设备模块证照、操作证相关查看、维护服务
 * 
 */
@Service("DevCardSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class DevCardSrv extends BaseService {

	public DevCardSrv() {
		log = LogFactory.getLogger(DevCardSrv.class);
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	
	public ISrvMsg getGZLInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getGZLInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String procinst_id = isrvmsg.getValue("apply_id");// 准许操作设备，类型列表
		String sql = "";
		List<Map> list = jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * 操作证审核流程信息 多个ID
	 */
	public ISrvMsg getTaskinsts(ISrvMsg isrvmsg) throws Exception {
		log.info("getTaskinst");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String procinst_ids = isrvmsg.getValue("procinst_ids");// 准许操作设备，类型列表

		String sql = "select t4.entity_id,"
				+ " t4.proc_name,"
				+ " t4.create_user_name,"
				+ " t3.node_name,"
				+ " decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState,"
				+ " t2.examine_user_name," + " t2.examine_start_date,"
				+ " subStr(t2.examine_end_date, 0, 11) examine_end_date,"
				+ " t1.is_open," + " t2.examine_info"
				+ " from wf_r_taskinst t1"
				+ " inner join (select max(taskinst_id) taskinst_id,"
				+ "  wmsys.wm_concat(examine_user_name) examine_user_name,"
				+ "  max(examine_start_date) examine_start_date,"
				+ "    max(examine_end_date) examine_end_date,"
				+ "   max(examine_info) examine_info"
				+ "  from wf_r_examineinst"
				+ " group by procinst_id, node_id) t2"
				+ " on t1.entity_id = t2.taskinst_id"
				+ " and t1.procinst_id in (" + procinst_ids + ")"
				+ " inner join wf_d_node t3" + "  on t1.node_id = t3.entity_id"
				+ " inner join wf_r_procinst t4"
				+ " on t1.procinst_id = t4.entity_id"
				+ " order by t2.examine_end_date asc";
		List<Map> list = jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * 删除申请单信息
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delApplyInfoByID(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String apply_id = isrvmsg.getValue("apply_id");// 准许操作设备，类型列表
		if (StringUtils.isNotBlank(apply_id) && !apply_id.equals("null")) {
			String deleteSql = "update dms_device_opcardapply set BSFLAG='1' where apply_id='"
					+ apply_id + "'";
			String deleteSql1 = "update dms_device_opcardapply_details set BSFLAG='1' where apply_id='"
					+ apply_id + "'";
			// String deleteSql2 =
			// "update dms_device_opcardapply_dinfo set BSFLAG='1' where apply_id='"+apply_id+"'";
			jdbcDao.executeUpdate(deleteSql);
			jdbcDao.executeUpdate(deleteSql1);
			// jdbcDao.executeUpdate(deleteSql2);
			responseDTO.setValue("result", "1");
		}
		return responseDTO;
	}

	/**
	 * 操作证审核流程信息 单个ID
	 */
	public ISrvMsg getTaskinst(ISrvMsg isrvmsg) throws Exception {
		log.info("getTaskinst");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String procinst_id = isrvmsg.getValue("procinst_id");// 准许操作设备，类型列表

		String sql = "select t4.entity_id,"
				+ " t4.proc_name,"
				+ " t4.create_user_name,"
				+ " t3.node_name,"
				+ " decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState,"
				+ " t2.examine_user_name," + " t2.examine_start_date,"
				+ " subStr(t2.examine_end_date, 0, 11) examine_end_date,"
				+ " t1.is_open," + " t2.examine_info"
				+ " from wf_r_taskinst t1"
				+ " inner join (select max(taskinst_id) taskinst_id,"
				+ "  wmsys.wm_concat(examine_user_name) examine_user_name,"
				+ "  max(examine_start_date) examine_start_date,"
				+ "    max(examine_end_date) examine_end_date,"
				+ "   max(examine_info) examine_info"
				+ "  from wf_r_examineinst"
				+ " group by procinst_id, node_id) t2"
				+ " on t1.entity_id = t2.taskinst_id"
				+ " and t1.procinst_id = '" + procinst_id + "'"
				+ " inner join wf_d_node t3" + "  on t1.node_id = t3.entity_id"
				+ " inner join wf_r_procinst t4"
				+ " on t1.procinst_id = t4.entity_id"
				+ " order by t2.examine_end_date asc";
		List<Map> list = jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * 操作证副页信息
	 */
	public ISrvMsg getApplyInfoByEmployee_idFY(ISrvMsg isrvmsg)
			throws Exception {
		log.info("getApplyInfoByEmployee_idFY");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String employee_id = isrvmsg.getValue("employee_id");// 准许操作设备，类型列表

		String sql = "select t1.*,t2.* from (   select row_number() over(order by wfmiddle.modifi_date desc ) rowno,devapp.apply_id,dinfo.type,dinfo.name, nvl(wfmiddle.proc_status, '') as proc_status ,wfmiddle.modifi_date, wfmiddle.proc_inst_id    from (select t1.* from dms_device_opcardapply t1,dms_device_opcardapply_details t2 where t1.bsflag='0' and t2.bsflag='0' and t1.apply_id=t2.apply_id and t2.employee_id='"
				+ employee_id
				+ "' "
				+ "  ) devapp   "
				+ "  left join common_busi_wf_middle wfmiddle on devapp.apply_id = wfmiddle.business_id inner join dms_device_opcardapply_dinfo dinfo on devapp.apply_id=dinfo.apply_id  order by wfmiddle.modifi_date desc   nulls last ) t1 ,";

		String sqlqq = "(select t4.entity_id,"
				+ " t4.proc_name,"
				+ " t4.create_user_name,"
				+ " t3.node_name,"
				+ " decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState,"
				+ " t2.examine_user_name,"
				+ " t2.examine_start_date,"
				+ " subStr(t2.examine_end_date, 0, 11) examine_end_date,"
				+ " t1.is_open,"
				+ " t2.examine_info"
				+ "  ,t1.procinst_id "
				+ " from wf_r_taskinst t1"
				+ " inner join (select max(taskinst_id) taskinst_id,"
				+ "  wmsys.wm_concat(examine_user_name) examine_user_name,"
				+ "  max(examine_start_date) examine_start_date,"
				+ "    max(examine_end_date) examine_end_date,"
				+ "   max(examine_info) examine_info"
				+ "  from wf_r_examineinst"
				+ " group by procinst_id, node_id) t2"
				+ " on t1.entity_id = t2.taskinst_id"

				+ " inner join wf_d_node t3"
				+ "  on t1.node_id = t3.entity_id"
				+ " inner join wf_r_procinst t4"
				+ " on t1.procinst_id = t4.entity_id"
				+ " order by t2.examine_end_date asc ) t2 where t1.proc_inst_id=t2.procinst_id";
		List<Map> list = jdbcDao.queryRecords(sql + sqlqq);
		//查询审验类型
		String sql1="select t1.approving_person, t3.*";
		sql1+=" from dms_device_opcardsy       t1,";
		sql1+="     dms_device_opcardsy_details t2,";
		sql1+="      dms_device_opcardsy_dinfo t3";
		sql1+="    where t1.bsflag = '0'";
		sql1+="    and t2.bsflag = '0'";
		sql1+="    and t1.approving_date_id = t2.approv_id";
		sql1+="    and t2.employee_id = '"+employee_id+"'";
		sql1+="    and t1.approving_date_id = t3.approv_id";
		List<Map> list1 = jdbcDao.queryRecords(sql1);
		List<Map> listnew =new ArrayList<Map>();
		for (Map map1 : list1) {
			boolean flag=true;
			for(Map map : list){
			 
				if(map1.get("name").equals(map.get("name"))){
					map.put("examine_user_name", map1.get("approving_person"));
					map.put("examine_end_date", map1.get("approving_date"));
					flag=false;
					break;
				}
			}	
			if(flag){
				Map  maptemp=new HashMap();
				maptemp.put("type",map1.get("type"));
				maptemp.put("name",map1.get("name"));
				maptemp.put("curstate","审核通过");
				maptemp.put("examine_end_date",map1.get("approving_date"));
				maptemp.put("examine_user_name",map1.get("approving_person"));
				listnew.add(maptemp);
				
			}
		}
		list.addAll(listnew);
		log.info(list);
		responseDTO.setValue("datas", list);

		return responseDTO;
	}

	/**
	 *   
	 */
	public ISrvMsg getApplyInfoByEmployee_id(ISrvMsg isrvmsg) throws Exception {
		log.info("getApplyInfoByEmployee_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String employee_id = isrvmsg.getValue("employee_id");// 准许操作设备，类型列表

		String sql = "  select row_number() over(order by wfmiddle.modifi_date desc ) rowno,devapp.*, nvl(wfmiddle.proc_status, '') as proc_status ,wfmiddle.modifi_date modifi_date1   from (select t1.*,t3.file_id,t3.file_name,t3.relation_id from dms_device_opcardapply t1 left join dms_device_opcardapply_details t2 on t1.apply_id=t2.apply_id left join bgp_doc_gms_file t3 on t3.relation_id=t1.apply_id where t1.BSFLAG='0'     and t2.BSFLAG='0'    and t2.employee_id='"
				+ employee_id
				+ "' "
				+ " ) devapp"
				+ " left join common_busi_wf_middle wfmiddle on devapp.apply_id = wfmiddle.business_id   order by wfmiddle.modifi_date desc nulls last";
		List<Map> list = jdbcDao.queryRecords(sql);

		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * 查询操作证准许操作设备，类型 by employee_id
	 */
	public ISrvMsg getApplyDeviceInfoByEmployee_id(ISrvMsg isrvmsg)
			throws Exception {
		log.info("getApplyDeviceInfoByEmployee_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String employee_id = isrvmsg.getValue("employee_id");// 准许操作设备，类型列表

		String sql = "select  wm_concat(info.type) type, wm_concat(info.name) name "
				+ " from DMS_DEVICE_OPCARDAPPLY_DINFO info, dms_device_opcardapply_details d, ( select devapp.apply_id, nvl(wfmiddle.proc_status, '') as proc_status ,wfmiddle.modifi_date   from dms_device_opcardapply devapp "  
	 
			 	+" left join common_busi_wf_middle wfmiddle on devapp.apply_id = wfmiddle.business_id where 1=1 )  newtable "
				+ " where   d.bsflag='0' and info.apply_id = d.apply_id and newtable.apply_id=info.apply_id and newtable.proc_status='3' and d.employee_id = '"
				+ employee_id + "'";
		Map list = jdbcDao.queryRecordBySQL(sql);

		responseDTO.setValue("data", list);
		return responseDTO;
	}
	
	public ISrvMsg getApplyDeviceInfoByApply_idOfEdit(ISrvMsg isrvmsg)
			throws Exception {
		log.info("getApplyDeviceInfoByApply_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String apply_id = isrvmsg.getValue("apply_id");// 准许操作设备，类型列表

		String sql = "select   wm_concat(type) type ,wm_concat(type_id) type_id, wm_concat(name) name,wm_concat(name_id) name_id from DMS_DEVICE_OPCARDAPPLY_DINFO where apply_id='"
				+ apply_id + "'";
		Map list = jdbcDao.queryRecordBySQL(sql);

		responseDTO.setValue("data", list);
		return responseDTO;
	}

	/**
	 * 查询操作证准许操作设备，类型 by apply_id
	 */
	public ISrvMsg getApplyDeviceInfoByApply_id(ISrvMsg isrvmsg)
			throws Exception {
		log.info("getApplyDeviceInfoByApply_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String apply_id = isrvmsg.getValue("apply_id");// 准许操作设备，类型列表

		String sql = "select   wm_concat(type) type , wm_concat(name) name from DMS_DEVICE_OPCARDAPPLY_DINFO where apply_id='"
				+ apply_id + "'";
		Map list = jdbcDao.queryRecordBySQL(sql);

		responseDTO.setValue("data", list);
		return responseDTO;
	}
	/**
	 * 查询操作证准许操作设备，类型 by arrpoving_id
	 */
	public ISrvMsg getApplyDeviceInfoByApproving_id(ISrvMsg isrvmsg)
			throws Exception {
		log.info("getApplyDeviceInfoByApproving_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String approving_id = isrvmsg.getValue("approving_id");// 准许操作设备，类型列表

		String sql = "select   wm_concat(type) type , wm_concat(name) name from dms_device_opcardsy_dinfo where APPROV_ID='"
				+ approving_id + "'";
		Map list = jdbcDao.queryRecordBySQL(sql);

		responseDTO.setValue("data", list);
		return responseDTO;
	}
	/**
	 * 查询操作证申请单状态
	 */
	public ISrvMsg getApplyDeviceInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getApplyDeviceInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String devicelist = isrvmsg.getValue("dev_type_id");// 准许操作设备，类型列表
		String[] devicelists = {};
		if (StringUtils.isNotBlank(devicelist)) {
			if (devicelist.indexOf(",") != -1) {
				devicelists = devicelist.split(",");
				devicelist = "";
				for (int i = 0; i < devicelists.length; i++) {
					if (i != devicelists.length - 1) {
						devicelist += "'" + devicelists[i] + "',";
					} else {
						devicelist += "'" + devicelists[i] + "'";
					}
				}
			} else {
				devicelist = "'" + devicelist + "'";
			}

		}
		String sql = " select t1.dev_tree_id,  t1.device_name||t1.device_type name from dms_device_tree_opcard t1 where t1.dev_tree_id in ("
				+ devicelist + ")";
		List<Map> list = jdbcDao.queryRecords(sql);
		log.info(list);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}

	/**
	 * 查询操作证申请单状态
	 */
	public ISrvMsg getScrapeState(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String apply_id = isrvmsg.getValue("apply_id");// 操作证申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql
				.append("select devapp.apply_id, nvl(wfmiddle.proc_status, '') as proc_status ,wfmiddle.modifi_date   from dms_device_opcardapply devapp ");
		queryScrapeInfoSql
				.append(" left join common_busi_wf_middle wfmiddle on devapp.apply_id = wfmiddle.business_id where 1=1 ");
		// 申请单ID
		if (StringUtils.isNotBlank(apply_id)) {
			queryScrapeInfoSql.append(" and apply_id  = '" + apply_id + "'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql
				.toString());
		if (deviceappMap != null) {
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}

	/**
	 * 查询设备操作证申请单列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOp_cardListOfPerson(ISrvMsg isrvmsg) throws Exception {
		log.info("queryOp_cardListOfPerson");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
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
		String employee_id_code_no = isrvmsg.getValue("employee_id");
		String employee_name = isrvmsg.getValue("employee_name");
		String apply_id = isrvmsg.getValue("apply_id");
		String org_name=isrvmsg.getValue("owning_org_name");
		String type=isrvmsg.getValue("dev_type_name"); 
		String start_time=isrvmsg.getValue("start_time"); 
		String end_time=isrvmsg.getValue("end_time"); 
		String sql = "  select * from (SELECT t1.*, t2.modifi_date1,(select  wm_concat(info.type) type from DMS_DEVICE_OPCARDAPPLY_DINFO info, dms_device_opcardapply_details d, ( select devapp.apply_id, nvl(wfmiddle.proc_status, '') as proc_status ,wfmiddle.modifi_date   from dms_device_opcardapply devapp  left join common_busi_wf_middle wfmiddle on devapp.apply_id = wfmiddle.business_id where 1=1 )  newtable  where   d.bsflag='0' and info.apply_id = d.apply_id and newtable.apply_id=info.apply_id and newtable.proc_status='3' and d.employee_id = t1.employee_id_code_no " 
				+"  ) type from  ( select row_number() over(order by tt.work_date desc) rowno,tt.* ,b.file_id  from ( select * from (select *"
				+ "  from (select distinct l.*,"

				+ " d3.coding_name post"
				+ " from (select distinct  "
				+ " '' employee_cd,"
				+ "  l.employee_id_code_no,"
				+ " to_char(l.create_date, 'yyyy-MM-dd')  work_date,"
				+ "  '' org_id,"
				+ "   l.employee_name,"
				+ "   decode(l.employee_gender, '0', '女', '1', '男') employee_gender,"
				+ "   nvl(t1.post, l.post) set_postw,"
				+ "   nvl(t1.apply_team, l.apply_team) set_teamw,"
				+ "   (select i.org_abbreviation from comm_org_information i where i.org_id=owning_org_id) org_name"
				+ "  from bgp_comm_human_labor l"
				+ "  left join (select lt.labor_id, count(1) nu"
				+ "  from bgp_comm_human_labor_list lt"
				+ "  left join bgp_comm_human_labor l"
				+ "     on l.labor_id = lt.labor_id"
				+ "   where lt.bsflag = '0'"
				+ "     and l.bsflag = '0'"
				+ "   group by lt.labor_id) lt"
				+ " on l.labor_id = lt.labor_id"
				+ " left join (select d2.*"
				+ "  from (select d1.*"
				+ "    from (select d.apply_team,"
				+ "                  d.post,"
				+ "                  l1.labor_id,"
				+ "                  row_number() over(partition by l1.labor_id order by d.start_date desc) numa"
				+ "             from bgp_comm_human_deploy_detail d"
				+ "             left join bgp_comm_human_labor_deploy l1"
				+ "               on d.labor_deploy_id ="
				+ "                  l1.labor_deploy_id"
				+ "           where d.bsflag = '0') d1"
				+ "    where d1.numa = 1) d2) t1"
				+ " on l.labor_id = t1.labor_id"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on l.employee_nation = d1.coding_code_id"
				+ "  left join comm_coding_sort_detail d2"
				+ "    on l.employee_education_level = d2.coding_code_id"
				+ " left join (select count(distinct"
				+ "                       to_char(t.start_date, 'yyyy')) years,"
				+ "                 t.labor_id"
				+ "            from bgp_comm_human_labor_deploy t"
				+ "           group by t.labor_id) t"
				+ "  on l.labor_id = t.labor_id"
				+ "  left join bgp_comm_human_certificate cft"
				+ "    on cft.employee_id = l.labor_id"
				+ "    and cft.bsflag = '0'"
				+ "   where l.bsflag = '0'"
				+ "    and l.owning_subjection_org_id like '%C105%') l"
				+ " left join comm_coding_sort_detail d3"
				+ "   on l.set_postw = d3.coding_code_id"
				+ "  left join comm_coding_sort_detail d4"
				+ "    on l.set_teamw = d4.coding_code_id) t"
				+ "   union all "
				+ "   select t.*"
				+ "  from (select h.employee_cd,"
				+ "  e.employee_id_code_no,"
				+ "   to_char(h.work_date, 'yyyy-MM-dd') work_date,"
				+ "   e.org_id,"
				+ "   e.employee_name,"
				+ "   decode(employee_gender, '0', '女', '1', '男') employee_gender,"
				+ "   nvl(phr.work_post, h.set_post) set_postw,"
				+ "   nvl(phr.team, h.set_team) set_teamw,"
				+ "   i.org_name org_name,"
				+ "   h.post"
				+ "  from comm_human_employee e"
				+ " inner join comm_human_employee_hr h"
				+ "    on e.employee_id = h.employee_id"
				+ "  left join comm_org_subjection s"
				+ "    on e.org_id = s.org_id"
				+ "   and s.bsflag = '0'"
				+ "  left join comm_org_information i"
				+ "   on e.org_id = i.org_id"
				+ "  and i.bsflag = '0'"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on h.post_level = d1.coding_code_id"
				+ "  and d1.bsflag = '0'"
				+ "   left join comm_coding_sort_detail d2"
				+ "    on e.employee_education_level = d2.coding_code_id"
				+ "    and d2.bsflag = '0'"
				+ "   left join (select d2.*"
				+ "             from (select d1.*"
				+ "                     from (select hr.team,"
				+ "                                 hr.work_post,"
				+ "                               hr.employee_id,"
				+ "                                 hr.actual_start_date,"
				+ "                               hr.actual_end_date,"
				+ "                               row_number() over(partition by hr.employee_id order by hr.actual_end_date desc) numa"
				+ "                          from bgp_project_human_relation hr"
				+ "                         where hr.bsflag = '0'"
				+ "                         and hr.locked_if = '1') d1"
				+ "                 where d1.numa = 1) d2) phr"
				+ "     on e.employee_id = phr.employee_id"
				+ "  left join comm_coding_sort_detail d13"
				+ "    on h.present_state = d13.coding_code_id"
				+ "  left join comm_org_subjection pin"
				+ "    on h.pin_unit = pin.org_subjection_id"
				+ "   and pin.bsflag = '0'"
				+ "  left join bgp_comm_org_hr_gms pin1"
				+ "    on pin1.org_gms_id = pin.org_id"
				+ "  left join bgp_comm_org_hr pin2"
				+ "   on pin2.org_hr_id = pin1.org_hr_id"
				+ "  where e.bsflag = '0'"
				+ "    and h.bsflag = '0'"
				+ "   order by e.modifi_date desc, e.employee_name desc) t"
				+ " left join comm_coding_sort_detail d11"
				+ "    on t.set_teamw = d11.coding_code_id"
				+ "  left join comm_coding_sort_detail d12"
				+ "   on t.set_postw = d12.coding_code_id) temp   where temp.employee_id_code_no in(select distinct EMPLOYEE_ID from dms_device_opcardapply_details where  sfcz='0' and bsflag='0' ";
		if (StringUtils.isNotBlank(apply_id)) {
			sql += " and apply_id='" + apply_id + "'";
		}
		sql += " )  union all ";

		sql += " select   employee_cd,employee_id employee_id_code_no,to_char(work_date, 'yyyy-MM-dd')  work_date, '' org_id,employee_name,EMPLOYEE_GENDER,'' set_postw ,'' set_teamw, org_name ,post  from dms_device_opcardapply_details where  sfcz='1'";
		if (StringUtils.isNotBlank(apply_id)) {
			sql += " and apply_id='" + apply_id + "'";
		}
		sql += " ) tt left join BGP_DOC_GMS_FILE  b on b.relation_id=employee_id_code_no    where 1=1 ";
		if (StringUtils.isNotBlank(employee_id_code_no)) {
			sql += " and  employee_id_code_no='" + employee_id_code_no + "'";
		}
		if (StringUtils.isNotBlank(employee_name)) {
			sql += " and tt.employee_name='" + employee_name + "'";
		}
		sql += " ) t1, (select row_number() over(order by wfmiddle.modifi_date desc) rowno, devapp.*, ";
		sql += " nvl(wfmiddle.proc_status, '') as proc_status,";
		sql += " wfmiddle.modifi_date modifi_date1";
		sql += " from (select t1.*,t2.employee_id";
		sql += "  from dms_device_opcardapply t1, dms_device_opcardapply_details t2";
		sql += "  where t1.BSFLAG = '0'";
		sql += " and t2.BSFLAG = '0'";
		sql += "    and t1.apply_id = t2.apply_id";
		sql += "  ) devapp";
		sql += " inner join common_busi_wf_middle wfmiddle";
		sql += "  on devapp.apply_id = wfmiddle.business_id";
		sql += " and wfmiddle.PROC_STATUS='3' ";
		sql += " order by wfmiddle.modifi_date desc nulls last) t2";
		sql += " where t2.employee_id=t1.employee_id_code_no ) t4    where  1=1";
		if(StringUtils.isNotBlank(org_name)){
		 sql+=" and org_name like '%"+org_name+"%'";
		}  
		if(StringUtils.isNotBlank(type)){
		sql+=" and type like '%"+type+"%'";
		}
		if(StringUtils.isNotBlank(start_time)){
			sql+=" and modifi_date1 >= to_date('"+start_time+"','yyyy-MM-dd')";
		}
		if(StringUtils.isNotBlank(end_time)){
			sql+=" and modifi_date1 <= to_date('"+end_time+"','yyyy-MM-dd')";
		}
		page = pureJdbcDao.queryRecordsBySQL(sql, page);
		List docList = page.getData();
		 for  ( int  i  =   0 ; i  <  docList.size()  -   1 ; i ++ )  {  
		      for  ( int  j  =  docList.size()  -   1 ; j  >  i; j -- )  
            {
            	Map ii=(Map) docList.get(i);
            	Map jj=(Map) docList.get(j);
                if ( ii.get("employee_id_code_no").equals(jj.get("employee_id_code_no")))
                {
                	docList.remove(j);
                }

            }
        }
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询设备操作证审验单列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOp_cardApprovingList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryOp_cardApprovingList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
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
		String arrroving_no = isrvmsg.getValue("q_approving_no");// 申请单号
		String approving_person = isrvmsg.getValue("q_approving_person");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.approving_date_id,t.approving_unit,t.approving_date,t.train_content,t.train_teacher,t.train_startdate,t.train_enddate,t.approving_no,t.approving_person from dms_device_opcardsy t  where 1=1 and t.BSFLAG='0' ");
		// 申请单号
		if (StringUtils.isNotBlank(arrroving_no)) {
			querySql.append(" and APPROVING_NO='" + arrroving_no + "'");
		} 
		if (StringUtils.isNotBlank(approving_person)) {
			querySql.append(" and approving_person='" + approving_person + "'");
		}
		querySql.append(" order by approving_date desc ");
		log.info(querySql);
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询设备操作证申请单列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOp_cardList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryOp_cardList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
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
		String apply_no = isrvmsg.getValue("apply_no");// 申请单号
		String status = isrvmsg.getValue("status");// 审核状态
		String apply_id = isrvmsg.getValue("apply_id");
		String start_time=isrvmsg.getValue("start_time");
		String end_time=isrvmsg.getValue("end_time");
		String dev_type_name=isrvmsg.getValue("dev_type_name");//设备类型
		String owning_org_name=isrvmsg.getValue("owning_org_name");//组织机构
		StringBuffer querySql = new StringBuffer();
		querySql.append("select * from (select   t.apply_id, (select  wm_concat(info.type) type from DMS_DEVICE_OPCARDAPPLY_DINFO info, dms_device_opcardapply_details d, ( select devapp.apply_id, nvl(wfmiddle.proc_status, '') as proc_status ,wfmiddle.modifi_date   from dms_device_opcardapply devapp  left join common_busi_wf_middle wfmiddle on devapp.apply_id = wfmiddle.business_id where 1=1 )  newtable  where   d.bsflag='0' and info.apply_id = d.apply_id and newtable.apply_id=info.apply_id and newtable.proc_status='3' and info.apply_id=t.apply_id) type,  (select count(*) from dms_device_opcardapply_details where apply_id=t.apply_id) persons,t.apply_unit,t.apply_date,op_type,t.op_model,t.train_content,t.train_teacher,t.train_startdate,t.train_enddate,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as status,t.apply_no,t.apply_person,t.status_date from DMS_DEVICE_OPCARDAPPLY t left join common_busi_wf_middle t2 on apply_id = business_id and t2.bsflag = '0' where 1=1 and t.BSFLAG='0' ");
		// 申请单号
		if (StringUtils.isNotBlank(apply_no)) {
			querySql.append(" and apply_no='" + apply_no + "'");
		}
		// 申请单位
		if (StringUtils.isNotBlank(owning_org_name)) {
					querySql.append(" and apply_unit like '%"+owning_org_name+"%' ");
		} 
		// 申请时间
		if (StringUtils.isNotBlank(start_time)) {
			querySql.append("      and apply_date >= to_date('"+start_time+"','yyyy-MM-dd')");
		} 
		// 申请时间
		if (StringUtils.isNotBlank(end_time)) {
			querySql.append("     and apply_date <= to_date('"+end_time+"','yyyy-MM-dd')");
		} 
		// 审核状态
		if (StringUtils.isNotBlank(status)) {
			if(status.equals("0")){
				querySql.append(" and proc_status is null");
			}else{
				querySql.append(" and proc_status='" + status + "'");
			}
		
		}
		if (StringUtils.isNotBlank(apply_id)) {
			querySql.append(" and apply_id='" + apply_id + "'");
		}
		querySql.append(" order by decode(status, '未提交',1,'待审批',2,'审批通过',3,'审批不通过',4),apply_date desc,apply_unit  desc  )  where 1=1    ");
		if(StringUtils.isNotBlank(dev_type_name)){
			querySql.append(" and type like '%"+dev_type_name+"%'");
		}
		log.info(querySql);
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * 保存设备操作申请表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUdateOp_cardApply(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUdateOp_cardApply");
		 List<String> detailsList = new ArrayList<String>();
		 List<String> infoList = new ArrayList<String>();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		Map map = new HashMap();
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String nosql = "select devtypeseq.nextval as no from dual";
		Map nomap = pureDao.queryRecordBySQL(nosql);
		String flag = isrvmsg.getValue("flag");
		String apply_id = isrvmsg.getValue("apply_id");
		String devicelist = isrvmsg.getValue("dev_type_id");// 准许操作设备，类型列表
		String[] devicelists = {};
		if (StringUtils.isNotBlank(devicelist)) {
			if (devicelist.indexOf(",") != -1) {
				devicelists = devicelist.split(",");
				devicelist = "";
				for (int i = 0; i < devicelists.length; i++) {
					if (i != devicelists.length - 1) {
						devicelist += "'" + devicelists[i] + "',";
					} else {
						devicelist += "'" + devicelists[i] + "'";
					}
				}
			} else {
				devicelist = "'" + devicelist + "'";
			}

		}

		if (StringUtils.isNotBlank(apply_id) && !apply_id.equals("null")) {
			map.put("APPLY_ID", apply_id);
		}
		map.put("APPLY_NO", nomap.get("no"));
		map.put("APPLY_PERSON", user.getUserName());
		map.put("APPLY_UNIT", isrvmsg.getValue("org_name"));
		map.put("APPLY_DATE", isrvmsg.getValue("apply_date"));
		// map.put("OP_TYPE", );
		// map.put("OP_MODEL", isrvmsg.getValue("dev_model"));
		map.put("TRAIN_CONTENT", isrvmsg.getValue("train_content"));
		map.put("TRAIN_TEACHER", isrvmsg.getValue("train_teacher"));
		map.put("TRAIN_STARTDATE", isrvmsg.getValue("start_time"));
		map.put("TRAIN_ENDDATE", isrvmsg.getValue("end_time"));
		map.put("BSFLAG", DevConstants.BSFLAG_NORMAL);
		map.put("CREATOR", user.getEmpId());
		map.put("CREATE_DATE", DevUtil.getCurrentTime());
		// map.put("CREATOR", value)
		// map.put("MODIFIER", value)
		// map.put(MODIFI_DATE, value)
		// map.put("STATUS", "0");
		log.info(map);
		Serializable id = jdbcDao.saveOrUpdateEntity(map,
				"DMS_DEVICE_OPCARDAPPLY");
		String apply_deviceinfosql = "select t1.dev_tree_id id,( case when t1.device_type is null then t1.device_name else t1.device_name||'('||t1.device_type||')' end)as name,(select device_name from dms_device_tree_opcard where dev_tree_id= substr(t1.dev_tree_id,0,length(t1.dev_tree_id)-3) ) type,t1.device_code from dms_device_tree_opcard t1 where t1.dev_tree_id in ("
				+ devicelist + ") order by t1.code_order   ";
		List<Map> apply_deviceinfomap = pureDao
				.queryRecords(apply_deviceinfosql);
		for (Map map2 : apply_deviceinfomap) {
			map2.put("type_id", map2.get("id").toString().substring(0, 4));
			map2.put("name_id", map2.get("id"));
			map2.remove("id");
			if(map2.get("name").equals("其他")){
				map2.put("name",isrvmsg.getValue("dev_model") );
			}
			map2.remove("device_code");
			map2.put("apply_id", id);
			String inserinfoSql="insert into dms_device_opcardapply_dinfo (APPLY_DEVICEINFOID, APPLY_ID, TYPE, NAME)"+
							"values ('"+jdbcDao.generateUUID()+"','"+map2.get("apply_id")+"','"+map2.get("type")+"','"+map2.get("name")+"')";
			// map2.put("BSFLAG", "0");
			//jdbcDao.saveEntity(map2, "DMS_DEVICE_OPCARDAPPLY_DINFO");// 保存申请单准许操作设备类别，型号
			infoList.add(inserinfoSql);
		}
		String [] inserinfoSql= infoList.toArray(new String[infoList.size()]);
		if(inserinfoSql.length!=0){
			jdbcDao.getJdbcTemplate().batchUpdate(inserinfoSql);
		}
		
		int peoplecount = Integer.parseInt(isrvmsg.getValue("peoplecount"));// 申请人员数
		String[] peopleids = isrvmsg.getValue("peopleids").split(",");// 参加培训人id

		String[] peopleidss = {};// 参加培训人id
		String[] noimg = {};
		if (StringUtils.isNotBlank(isrvmsg.getValue("peopleidss"))) {
			peopleidss = isrvmsg.getValue("peopleidss").split(",");
		}
		if (StringUtils.isNotBlank(isrvmsg.getValue("noimg"))) {
			noimg = isrvmsg.getValue("noimg").split(",");// 需要保存图片用户
		}

		// 附件上传
		Boolean filesAssetflag = false;
		MQMsgImpl mqMsgAsset = (MQMsgImpl) isrvmsg;
		List<WSFile> filesAsset = mqMsgAsset.getFiles();
		// String [] ids=isrvmsg.getValue("ids").split(",");//参加培训人已保存id
		boolean temp = true;
		for (String string : peopleids) {
			Map userinfo = new HashMap();
			userinfo.put("APPLY_ID", id);
			userinfo.put("EMPLOYEE_ID",
					isrvmsg.getValue("employee_id" + string));
			for (String string1 : peopleidss) {
				if (string.equals(string1)) {
					userinfo.put("SFCZ", "0");
					temp = false;
					break;
				}
			}
			if (temp) {
				userinfo.put("EMPLOYEE_NAME",
						isrvmsg.getValue("employee_name" + string));
				userinfo.put("ORG_NAME", isrvmsg.getValue("work_part" + string));
				userinfo.put("POST", isrvmsg.getValue("org_name" + string));
				userinfo.put("WORK_DATE",
						null);
				userinfo.put("SFCZ", "1");
				userinfo.put("EMPLOYEE_CD", isrvmsg.getValue("employee_cd"+string));
				userinfo.put("EMPLOYEE_GENDER",
						isrvmsg.getValue("sex" + string));
			}
			String employee_id = isrvmsg.getValue("employee_id" + string);
			// 如果身份证为空不执行保存信息，附件操作
			if (!StringUtils.isNotBlank(employee_id)) {
				continue;
			}
			userinfo.put("BSFLAG", DevConstants.BSFLAG_NORMAL);
			userinfo.put("CREATOR", user.getEmpId());
			userinfo.put("CREATE_DATE", DevUtil.getCurrentTime());
			
			if (temp) {
				detailsList.add("insert into dms_device_opcardapply_details (APPLY_DETAILS_ID, APPLY_ID, EMPLOYEE_ID, EMPLOYEE_NAME, ORG_NAME, POST, WORK_DATE, SFCZ, EMPLOYEE_GENDER, BSFLAG, CREATOR, CREATE_DATE,EMPLOYEE_CD)"+
				"values ('"+jdbcDao.generateUUID()+"','"+userinfo.get("APPLY_ID")+"','"+userinfo.get("EMPLOYEE_ID")+"','"+userinfo.get("EMPLOYEE_NAME")+"','"+userinfo.get("ORG_NAME")+"','"+userinfo.get("POST")+"',null,'"+userinfo.get("SFCZ")+"','"+userinfo.get("EMPLOYEE_GENDER")+"','"+userinfo.get("BSFLAG")+"','"+userinfo.get("CREATOR")+"',to_date('"+userinfo.get("CREATE_DATE")+"', 'yyyy-mm-dd hh24:mi:ss'),"+userinfo.get("EMPLOYEE_CD")+")");
			}else{
				detailsList.add("insert into dms_device_opcardapply_details (APPLY_DETAILS_ID, APPLY_ID, EMPLOYEE_ID, SFCZ, BSFLAG, CREATOR, CREATE_DATE)"+
						"values ('"+jdbcDao.generateUUID()+"','"+userinfo.get("APPLY_ID")+"','"+userinfo.get("EMPLOYEE_ID")+"','"+userinfo.get("SFCZ")+"','"+userinfo.get("BSFLAG")+"','"+userinfo.get("CREATOR")+"',to_date('"+userinfo.get("CREATE_DATE")+"', 'yyyy-mm-dd hh24:mi:ss'))");
			}
			//Serializable idd = jdbcDao.saveEntity(userinfo,
					//"DMS_DEVICE_OPCARDAPPLY_DETAILS");

			try {
				// 处理附件
				for (WSFile file : filesAsset) {
					String fileOrder = file.getKey().toString();
					if (fileOrder.equals("excel_content_public" + string)) {

						MyUcm ucm = new MyUcm();
						String ucmDocId = ucm.uploadFile(file.getFilename(),
								file.getFileData());
						Map doc = new HashMap();
						doc.put("file_name", file.getFilename());
						doc.put("file_type", file.getKey().toString());
						doc.put("ucm_id", ucmDocId);
						doc.put("is_file", "1");
						doc.put("relation_id",
								isrvmsg.getValue("employee_id" + string));
						doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
						doc.put("create_date", currentdate);
						doc.put("creator_id", user.getUserId());
						doc.put("org_id", user.getOrgId());
						doc.put("org_subjection_id",
								user.getSubOrgIDofAffordOrg());
						String sql="select * from BGP_DOC_GMS_FILE where relation_id='"+isrvmsg.getValue("employee_id" + string)+"'";
						Map docmap=	jdbcDao.queryRecordBySQL(sql);
						if(docmap==null){
						String docId = (String) jdbcDao.saveOrUpdateEntity(doc,
								"BGP_DOC_GMS_FILE");
						ucm.docVersion(docId, "1.0", ucmDocId,
								user.getUserId(), user.getUserId(),
								user.getCodeAffordOrgID(),
								user.getSubOrgIDofAffordOrg(),
								file.getFilename());
						ucm.docLog(docId, "1.0", 1, user.getUserId(),
								user.getUserId(), user.getUserId(),
								user.getCodeAffordOrgID(),
								user.getSubOrgIDofAffordOrg(),
								file.getFilename());
						}
						break;
					}
				}

			} catch (Exception e) {

			}
			temp = true;
		}
		String [] insertSql= detailsList.toArray(new String[detailsList.size()]);
		if(insertSql.length!=0){
		jdbcDao.getJdbcTemplate().batchUpdate(insertSql);
		}
//保存用户信息结束
		try {
			// 处理附件
			for (WSFile file : filesAsset) {
				String fileOrder = file.getKey().toString();
				if (fileOrder.equals("excel_content_public")) {
					MyUcm ucm = new MyUcm();
					String ucmDocId = ucm.uploadFile(file.getFilename(),
							file.getFileData());
					Map doc = new HashMap();
					doc.put("file_name", file.getFilename());
					doc.put("file_type", file.getKey().toString());
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", id);
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("create_date", currentdate);
					doc.put("creator_id", user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					String docId = (String) jdbcDao.saveOrUpdateEntity(doc,
							"BGP_DOC_GMS_FILE");
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(),
							user.getUserId(), user.getCodeAffordOrgID(),
							user.getSubOrgIDofAffordOrg(), file.getFilename());
					ucm.docLog(docId, "1.0", 1, user.getUserId(),
							user.getUserId(), user.getUserId(),
							user.getCodeAffordOrgID(),
							user.getSubOrgIDofAffordOrg(), file.getFilename());
					break;
				}
			}

		} catch (Exception e) {

		}
		String sftj = isrvmsg.getValue("sftj");
		if ("yes".equals(sftj)) {

			responseDTO.setValue("apply_id", id);
		} else {
			responseDTO.setValue("apply_id", "fasle");

		}

		// 附件上传
		responseDTO.setValue("result", "1");
		return responseDTO;
	}

	/**
	 * 保存设备操作审验表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUdateOp_cardApproving(ISrvMsg isrvmsg)
			throws Exception {
		log.info("saveOrUdateOp_cardApproving");

		List<Map<String, Object>> noopcard = new ArrayList<Map<String, Object>>();// 没有办过操作证人员集合
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		Map map = new HashMap();
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String nosql = "select devtypeseq.nextval as no from dual";
		Map nomap = pureDao.queryRecordBySQL(nosql);
		String flag = isrvmsg.getValue("flag");
		String apply_id = isrvmsg.getValue("apply_id");
		String devicelist = isrvmsg.getValue("dev_type_id");// 准许操作设备，类型列表
		String[] devicelists = {};
		if (StringUtils.isNotBlank(devicelist)) {
			if (devicelist.indexOf(",") != -1) {
				devicelists = devicelist.split(",");
				devicelist = "";
				for (int i = 0; i < devicelists.length; i++) {
					if (i != devicelists.length - 1) {
						devicelist += "'" + devicelists[i] + "',";
					} else {
						devicelist += "'" + devicelists[i] + "'";
					}
				}
			} else {
				devicelist = "'" + devicelist + "'";
			}

		}

		if (StringUtils.isNotBlank(apply_id) && !apply_id.equals("null")) {
			map.put("APPLY_ID", apply_id);
		}
		map.put("APPROVING_NO", nomap.get("no"));
		map.put("APPROVING_PERSON", user.getUserName());
		map.put("APPROVING_UNIT", isrvmsg.getValue("org_name"));
		map.put("APPROVING_DATE", isrvmsg.getValue("apply_date"));
		// map.put("OP_TYPE", );
		// map.put("OP_MODEL", isrvmsg.getValue("dev_model"));
		map.put("TRAIN_CONTENT", isrvmsg.getValue("train_content"));
		map.put("TRAIN_TEACHER", isrvmsg.getValue("train_teacher"));
		map.put("TRAIN_STARTDATE", isrvmsg.getValue("start_time"));
		map.put("TRAIN_ENDDATE", isrvmsg.getValue("end_time"));
		map.put("BSFLAG", DevConstants.BSFLAG_NORMAL);
		map.put("CREATOR", user.getEmpId());
		map.put("CREATE_DATE", DevUtil.getCurrentTime());
		// map.put("CREATOR", value)
		// map.put("MODIFIER", value)
		// map.put(MODIFI_DATE, value)
		// map.put("STATUS", "0");
		log.info(map);
		Serializable id = jdbcDao
				.saveOrUpdateEntity(map, "dms_device_opcardsy");
		String apply_deviceinfosql = "select t1.dev_tree_id id,( case when t1.device_type is null then t1.device_name else t1.device_name||'('||t1.device_type||')' end)as name,(select device_name from dms_device_tree_opcard where dev_tree_id= substr(t1.dev_tree_id,0,length(t1.dev_tree_id)-3) ) type,t1.device_code from dms_device_tree_opcard t1 where t1.dev_tree_id in ("
				+ devicelist + ") order by t1.code_order   ";
		List<Map> apply_deviceinfomap = pureDao
				.queryRecords(apply_deviceinfosql);
		for (Map map2 : apply_deviceinfomap) {
			map2.put("type_id", map2.get("id").toString().substring(0, 4));
			map2.put("name_id", map2.get("id"));
			map2.remove("id");
			map2.remove("device_code");
			if(map2.get("name").equals("其他")){
				map2.put("name",isrvmsg.getValue("dev_model") );
			}
			map2.put("APPROV_ID", id);
			map2.put("APPROVING_DATE", DevUtil.getCurrentTime());
			// map2.put("BSFLAG", "0");
			jdbcDao.saveEntity(map2, "dms_device_opcardsy_dinfo");// 保存申请单准许操作设备类别，型号
		}
		int peoplecount = Integer.parseInt(isrvmsg.getValue("peoplecount"));// 申请人员数
		String[] peopleids = isrvmsg.getValue("peopleids").split(",");// 参加培训人id

		String[] peopleidss = {};// 参加培训人id
		String[] noimg = {};
		if (StringUtils.isNotBlank(isrvmsg.getValue("peopleidss"))) {
			peopleidss = isrvmsg.getValue("peopleidss").split(",");
		}
		if (StringUtils.isNotBlank(isrvmsg.getValue("noimg"))) {
			noimg = isrvmsg.getValue("noimg").split(",");// 需要保存图片用户
		}

		// 附件上传
		Boolean filesAssetflag = false;
		MQMsgImpl mqMsgAsset = (MQMsgImpl) isrvmsg;
		List<WSFile> filesAsset = mqMsgAsset.getFiles();
		// String [] ids=isrvmsg.getValue("ids").split(",");//参加培训人已保存id
		boolean temp = true;
		for (String string : peopleids) {
			Map userinfo = new HashMap();
			userinfo.put("APPROV_ID", id);
			userinfo.put("EMPLOYEE_ID",
					isrvmsg.getValue("employee_id" + string));
			for (String string1 : peopleidss) {
				if (string.equals(string1)) {
					userinfo.put("SFCZ", "0");
					temp = false;
					break;
				}
			}
			if (temp) {
				userinfo.put("EMPLOYEE_NAME",
						isrvmsg.getValue("employee_name" + string));
				userinfo.put("ORG_NAME", isrvmsg.getValue("work_part" + string));
				userinfo.put("POST", isrvmsg.getValue("org_name" + string));
				userinfo.put("WORK_DATE",
						isrvmsg.getValue("start_work_date" + string));
				userinfo.put("SFCZ", "1");

				userinfo.put("EMPLOYEE_GENDER",
						isrvmsg.getValue("sex" + string));
			}
			String employee_id = isrvmsg.getValue("employee_id" + string);
			// 如果身份证为空不执行保存信息，附件操作
			if (!StringUtils.isNotBlank(employee_id)) {
				continue;
			}
			userinfo.put("BSFLAG", DevConstants.BSFLAG_NORMAL);
			userinfo.put("CREATOR", user.getEmpId());
			userinfo.put("CREATE_DATE", DevUtil.getCurrentTime());

			// 判断是否办过操作证，如果办过更新审验时间，如果没有添加一条申请信息
			String employeesql = "select * from dms_device_opcardapply_details where employee_id='"
					+ employee_id + "'";
			Map employeemap = pureDao.queryRecordBySQL(employeesql);
			if (employeemap != null) {
				Serializable idd = jdbcDao.saveEntity(userinfo,
						"dms_device_opcardsy_details");
			} else {
				noopcard.add(userinfo);
			}
			try {
				// 处理附件
				for (WSFile file : filesAsset) {
					String fileOrder = file.getKey().toString();
					if (fileOrder.equals("excel_content_public" + string)) {

						MyUcm ucm = new MyUcm();
						String ucmDocId = ucm.uploadFile(file.getFilename(),
								file.getFileData());
						Map doc = new HashMap();
						doc.put("file_name", file.getFilename());
						doc.put("file_type", file.getKey().toString());
						doc.put("ucm_id", ucmDocId);
						doc.put("is_file", "1");
						doc.put("relation_id",
								isrvmsg.getValue("employee_id" + string));
						doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
						doc.put("create_date", currentdate);
						doc.put("creator_id", user.getUserId());
						doc.put("org_id", user.getOrgId());
						doc.put("org_subjection_id",
								user.getSubOrgIDofAffordOrg());
						String sql="select * from BGP_DOC_GMS_FILE where relation_id='"+isrvmsg.getValue("employee_id" + string)+"'";
						Map docmap=	jdbcDao.queryRecordBySQL(sql);
						if(docmap==null){
							String docId = (String) jdbcDao.saveOrUpdateEntity(doc,
									"BGP_DOC_GMS_FILE");
							ucm.docVersion(docId, "1.0", ucmDocId,
									user.getUserId(), user.getUserId(),
									user.getCodeAffordOrgID(),
									user.getSubOrgIDofAffordOrg(),
									file.getFilename());
							ucm.docLog(docId, "1.0", 1, user.getUserId(),
									user.getUserId(), user.getUserId(),
									user.getCodeAffordOrgID(),
									user.getSubOrgIDofAffordOrg(),
									file.getFilename());
						}
						
						break;
					}
				}

			} catch (Exception e) {

			}
			temp = true;
		}

		try {
			// 处理附件
			for (WSFile file : filesAsset) {
				String fileOrder = file.getKey().toString();
				if (fileOrder.equals("excel_content_public")) {
					MyUcm ucm = new MyUcm();
					String ucmDocId = ucm.uploadFile(file.getFilename(),
							file.getFileData());
					Map doc = new HashMap();
					doc.put("file_name", file.getFilename());
					doc.put("file_type", file.getKey().toString());
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", id);
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("create_date", currentdate);
					doc.put("creator_id", user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					String docId = (String) jdbcDao.saveOrUpdateEntity(doc,
							"BGP_DOC_GMS_FILE");
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(),
							user.getUserId(), user.getCodeAffordOrgID(),
							user.getSubOrgIDofAffordOrg(), file.getFilename());
					ucm.docLog(docId, "1.0", 1, user.getUserId(),
							user.getUserId(), user.getUserId(),
							user.getCodeAffordOrgID(),
							user.getSubOrgIDofAffordOrg(), file.getFilename());
					break;
				}
			}
			// 如果没有办过操作证用户 统一添加一个申请单
			if (noopcard.size() != 0) {
				map.put("APPLY_NO", nomap.get("no"));
				map.put("APPLY_PERSON", user.getUserName());
				map.put("APPLY_UNIT", isrvmsg.getValue("org_name"));
				map.put("APPLY_DATE", isrvmsg.getValue("apply_date"));
				// map.put("OP_TYPE", );
				// map.put("OP_MODEL", isrvmsg.getValue("dev_model"));
				map.put("TRAIN_CONTENT", isrvmsg.getValue("train_content"));
				map.put("TRAIN_TEACHER", isrvmsg.getValue("train_teacher"));
				map.put("TRAIN_STARTDATE", isrvmsg.getValue("start_time"));
				map.put("TRAIN_ENDDATE", isrvmsg.getValue("end_time"));
				map.put("BSFLAG", DevConstants.BSFLAG_NORMAL);
				map.put("CREATOR", user.getEmpId());
				map.put("CREATE_DATE", DevUtil.getCurrentTime());
				// map.put("CREATOR", value)
				// map.put("MODIFIER", value)
				// map.put(MODIFI_DATE, value)
				// map.put("STATUS", "0");
				log.info(map);
				// 添加申请单id
				Serializable id1 = jdbcDao.saveOrUpdateEntity(map,
						"DMS_DEVICE_OPCARDAPPLY");
				String apply_deviceinfosql1 = "select t1.dev_tree_id id,( case when t1.device_type is null then t1.device_name else t1.device_name||'('||t1.device_type||')' end)as name,(select device_name from dms_device_tree_opcard where dev_tree_id= substr(t1.dev_tree_id,0,4) ) type,t1.device_code from dms_device_tree_opcard t1 where t1.dev_tree_id in ("
						+ devicelist + ") order by t1.code_order   ";
				List<Map> apply_deviceinfomap1 = pureDao
						.queryRecords(apply_deviceinfosql1);
				log.info(apply_deviceinfomap1);
				for (Map map2 : apply_deviceinfomap1) {
					map2.put("type_id",
							map2.get("id").toString().substring(0, 4));
					map2.put("name_id", map2.get("id"));
					map2.remove("id");
					map2.remove("device_code");
					map2.put("apply_id", id1);
					// map2.put("BSFLAG", "0");
					jdbcDao.saveEntity(map2, "DMS_DEVICE_OPCARDAPPLY_DINFO");// 保存申请单准许操作设备类别，型号
				}
				for (Map userinfo : noopcard) {
					userinfo.put("apply_id", id1);
					jdbcDao.saveEntity(userinfo,
							"dms_device_opcardapply_details");// 保存申请单准许操作设备类别，型号
				}
				// 处理附件
				for (WSFile file : filesAsset) {
					String fileOrder = file.getKey().toString();
					if (fileOrder.equals("excel_content_public")) {
						MyUcm ucm = new MyUcm();
						String ucmDocId = ucm.uploadFile(file.getFilename(),
								file.getFileData());
						Map doc = new HashMap();
						doc.put("file_name", file.getFilename());
						doc.put("file_type", file.getKey().toString());
						doc.put("ucm_id", ucmDocId);
						doc.put("is_file", "1");
						doc.put("relation_id", id1);
						doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
						doc.put("create_date", currentdate);
						doc.put("creator_id", user.getUserId());
						doc.put("org_id", user.getOrgId());
						doc.put("org_subjection_id",
								user.getSubOrgIDofAffordOrg());
						String docId = (String) jdbcDao.saveOrUpdateEntity(doc,
								"BGP_DOC_GMS_FILE");
						ucm.docVersion(docId, "1.0", ucmDocId,
								user.getUserId(), user.getUserId(),
								user.getCodeAffordOrgID(),
								user.getSubOrgIDofAffordOrg(),
								file.getFilename());
						ucm.docLog(docId, "1.0", 1, user.getUserId(),
								user.getUserId(), user.getUserId(),
								user.getCodeAffordOrgID(),
								user.getSubOrgIDofAffordOrg(),
								file.getFilename());
						break;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 附件上传
		responseDTO.setValue("result", "1");
		return responseDTO;
	}
	  
	public ISrvMsg loadEmployeeInfoByApprovingID(ISrvMsg iSrvMsg) throws Exception {
		String approving_id = iSrvMsg.getValue("approving_id");
		String employee_id_code_no = iSrvMsg.getValue("employee_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(iSrvMsg);
		String sql = " select row_number() over(order by tt.work_date desc) rowno,tt.* ,b.file_id from ( select * from (select *"
				+ " from (select distinct l.*,"
				+ " d3.coding_name post"
				+ " from (select distinct  "
				+ " '' employee_cd,"
				+ "  l.employee_id_code_no,"
				+ " to_char(l.create_date, 'yyyy-MM-dd')  work_date,"
				+ "  '' org_id,"
				+ "   l.employee_name,"
				+ "   decode(l.employee_gender, '0', '女', '1', '男') employee_gender,"
				+ "   nvl(t1.post, l.post) set_postw,"
				+ "   nvl(t1.apply_team, l.apply_team) set_teamw,"
				+ "   (select org_name from comm_org_information i where i.org_id=owning_org_id) org_name"
				+ "  from bgp_comm_human_labor l"
				+ "  left join (select lt.labor_id, count(1) nu"
				+ "  from bgp_comm_human_labor_list lt"
				+ "  left join bgp_comm_human_labor l"
				+ "     on l.labor_id = lt.labor_id"
				+ "   where lt.bsflag = '0'"
				+ "     and l.bsflag = '0'"
				+ "   group by lt.labor_id) lt"
				+ " on l.labor_id = lt.labor_id"
				+ " left join (select d2.*"
				+ "  from (select d1.*"
				+ "    from (select d.apply_team,"
				+ "                  d.post,"
				+ "                  l1.labor_id,"
				+ "                  row_number() over(partition by l1.labor_id order by d.start_date desc) numa"
				+ "             from bgp_comm_human_deploy_detail d"
				+ "             left join bgp_comm_human_labor_deploy l1"
				+ "               on d.labor_deploy_id ="
				+ "                  l1.labor_deploy_id"
				+ "           where d.bsflag = '0') d1"
				+ "    where d1.numa = 1) d2) t1"
				+ " on l.labor_id = t1.labor_id"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on l.employee_nation = d1.coding_code_id"
				+ "  left join comm_coding_sort_detail d2"
				+ "    on l.employee_education_level = d2.coding_code_id"
				+ " left join (select count(distinct"
				+ "                       to_char(t.start_date, 'yyyy')) years,"
				+ "                 t.labor_id"
				+ "            from bgp_comm_human_labor_deploy t"
				+ "           group by t.labor_id) t"
				+ "  on l.labor_id = t.labor_id"
				+ "  left join bgp_comm_human_certificate cft"
				+ "    on cft.employee_id = l.labor_id"
				+ "    and cft.bsflag = '0'"
				+ "   where l.bsflag = '0'"
				+ "    and l.owning_subjection_org_id like '%C105%') l"
				+ " left join comm_coding_sort_detail d3"
				+ "   on l.set_postw = d3.coding_code_id"
				+ "  left join comm_coding_sort_detail d4"
				+ "    on l.set_teamw = d4.coding_code_id) t"
				+ "   union all "
				+ "   select t.*"
				+ "  from (select h.employee_cd,"
				+ "  e.employee_id_code_no,"
				+ "   to_char(h.work_date, 'yyyy-MM-dd') work_date,"
				+ "   e.org_id,"
				+ "   e.employee_name,"
				+ "   decode(e.employee_gender, '0', '女', '1', '男') employee_gender,"
				+ "   nvl(phr.work_post, h.set_post) set_postw,"
				+ "   nvl(phr.team, h.set_team) set_teamw,"
				+ "   i.org_name org_name,"
				+ "   h.post"
				+ "  from comm_human_employee e"
				+ " inner join comm_human_employee_hr h"
				+ "    on e.employee_id = h.employee_id"
				+ "  left join comm_org_subjection s"
				+ "    on e.org_id = s.org_id"
				+ "   and s.bsflag = '0'"
				+ "  left join comm_org_information i"
				+ "   on e.org_id = i.org_id"
				+ "  and i.bsflag = '0'"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on h.post_level = d1.coding_code_id"
				+ "  and d1.bsflag = '0'"
				+ "   left join comm_coding_sort_detail d2"
				+ "    on e.employee_education_level = d2.coding_code_id"
				+ "    and d2.bsflag = '0'"
				+ "   left join (select d2.*"
				+ "             from (select d1.*"
				+ "                     from (select hr.team,"
				+ "                                 hr.work_post,"
				+ "                               hr.employee_id,"
				+ "                                 hr.actual_start_date,"
				+ "                               hr.actual_end_date,"
				+ "                               row_number() over(partition by hr.employee_id order by hr.actual_end_date desc) numa"
				+ "                          from bgp_project_human_relation hr"
				+ "                         where hr.bsflag = '0'"
				+ "                         and hr.locked_if = '1') d1"
				+ "                 where d1.numa = 1) d2) phr"
				+ "     on e.employee_id = phr.employee_id"
				+ "  left join comm_coding_sort_detail d13"
				+ "    on h.present_state = d13.coding_code_id"
				+ "  left join comm_org_subjection pin"
				+ "    on h.pin_unit = pin.org_subjection_id"
				+ "   and pin.bsflag = '0'"
				+ "  left join bgp_comm_org_hr_gms pin1"
				+ "    on pin1.org_gms_id = pin.org_id"
				+ "  left join bgp_comm_org_hr pin2"
				+ "   on pin2.org_hr_id = pin1.org_hr_id"
				+ "  where e.bsflag = '0'"
				+ "    and h.bsflag = '0'"
				+ "   order by e.modifi_date desc, e.employee_name desc) t"
				+ " left join comm_coding_sort_detail d11"
				+ "    on t.set_teamw = d11.coding_code_id"
				+ "  left join comm_coding_sort_detail d12"
				+ "   on t.set_postw = d12.coding_code_id) temp   where temp.employee_id_code_no in(select EMPLOYEE_ID from dms_device_opcardsy_details where  sfcz='0' ";
		if (StringUtils.isNotBlank(approving_id)) {
			sql += " and APPROV_ID='" + approving_id + "'";
		}
		sql += " )  union all ";

		sql += " select  '' employee_cd,employee_id employee_id_code_no,to_char(work_date, 'yyyy-MM-dd')  work_date, '' org_id,employee_name,    employee_gender,'' set_postw ,'' set_teamw, org_name ,post  from dms_device_opcardsy_details where  sfcz='1'";
		if (StringUtils.isNotBlank(approving_id)) {
			sql += " and APPROV_ID='" + approving_id + "'";
		}
		sql += " ) tt left join BGP_DOC_GMS_FILE  b on b.relation_id=employee_id_code_no  where 1=1 ";
		if (StringUtils.isNotBlank(employee_id_code_no)) {
			sql += "and  employee_id_code_no='" + employee_id_code_no + "'";
		}
		List<Map> maps = pureDao.queryRecords(sql);
		log.info("执行sql:" + sql);
		responseDTO.setValue("datas", maps);
		return responseDTO;
	}

	
	public ISrvMsg loadEmployeeInfoByApplID(ISrvMsg iSrvMsg) throws Exception {
		String apply_id = iSrvMsg.getValue("apply_id");
		String employee_id_code_no = iSrvMsg.getValue("employee_id");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(iSrvMsg);
		String sql = " select row_number() over(order by tt.work_date desc) rowno,tt.* ,decode(tt.post,'null','',tt.post) post1,b.file_id from ( select * from (select *"
				+ " from (select distinct l.*,"
				+ " d3.coding_name post"
				+ " from (select distinct  "
				+ " '' employee_cd,"
				+ "  l.employee_id_code_no,"
				+ " to_char(l.create_date, 'yyyy-MM-dd')  work_date,"
				+ "  '' org_id,"
				+ "   l.employee_name,"
				+ "   decode(l.employee_gender, '0', '女', '1', '男') employee_gender,"
				+ "   nvl(t1.post, l.post) set_postw,"
				+ "   nvl(t1.apply_team, l.apply_team) set_teamw,"
				+ "   (select org_name from comm_org_information i where i.org_id=owning_org_id) org_name"
				+ "  from bgp_comm_human_labor l"
				+ "  left join (select lt.labor_id, count(1) nu"
				+ "  from bgp_comm_human_labor_list lt"
				+ "  left join bgp_comm_human_labor l"
				+ "     on l.labor_id = lt.labor_id"
				+ "   where lt.bsflag = '0'"
				+ "     and l.bsflag = '0'"
				+ "   group by lt.labor_id) lt"
				+ " on l.labor_id = lt.labor_id"
				+ " left join (select d2.*"
				+ "  from (select d1.*"
				+ "    from (select d.apply_team,"
				+ "                  d.post,"
				+ "                  l1.labor_id,"
				+ "                  row_number() over(partition by l1.labor_id order by d.start_date desc) numa"
				+ "             from bgp_comm_human_deploy_detail d"
				+ "             left join bgp_comm_human_labor_deploy l1"
				+ "               on d.labor_deploy_id ="
				+ "                  l1.labor_deploy_id"
				+ "           where d.bsflag = '0') d1"
				+ "    where d1.numa = 1) d2) t1"
				+ " on l.labor_id = t1.labor_id"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on l.employee_nation = d1.coding_code_id"
				+ "  left join comm_coding_sort_detail d2"
				+ "    on l.employee_education_level = d2.coding_code_id"
				+ " left join (select count(distinct"
				+ "                       to_char(t.start_date, 'yyyy')) years,"
				+ "                 t.labor_id"
				+ "            from bgp_comm_human_labor_deploy t"
				+ "           group by t.labor_id) t"
				+ "  on l.labor_id = t.labor_id"
				+ "  left join bgp_comm_human_certificate cft"
				+ "    on cft.employee_id = l.labor_id"
				+ "    and cft.bsflag = '0'"
				+ "   where l.bsflag = '0'"
				+ "    and l.owning_subjection_org_id like '%C105%') l"
				+ " left join comm_coding_sort_detail d3"
				+ "   on l.set_postw = d3.coding_code_id"
				+ "  left join comm_coding_sort_detail d4"
				+ "    on l.set_teamw = d4.coding_code_id) t"
				+ "   union all "
				+ "   select t.*"
				+ "  from (select h.employee_cd,"
				+ "  e.employee_id_code_no,"
				+ "   to_char(h.work_date, 'yyyy-MM-dd') work_date,"
				+ "   e.org_id,"
				+ "   e.employee_name,"
				+ "   decode(e.employee_gender, '0', '女', '1', '男') employee_gender,"
				+ "   nvl(phr.work_post, h.set_post) set_postw,"
				+ "   nvl(phr.team, h.set_team) set_teamw,"
				+ "   i.org_name org_name,"
				+ "   h.post"
				+ "  from comm_human_employee e"
				+ " inner join comm_human_employee_hr h"
				+ "    on e.employee_id = h.employee_id"
				+ "  left join comm_org_subjection s"
				+ "    on e.org_id = s.org_id"
				+ "   and s.bsflag = '0'"
				+ "  left join comm_org_information i"
				+ "   on e.org_id = i.org_id"
				+ "  and i.bsflag = '0'"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on h.post_level = d1.coding_code_id"
				+ "  and d1.bsflag = '0'"
				+ "   left join comm_coding_sort_detail d2"
				+ "    on e.employee_education_level = d2.coding_code_id"
				+ "    and d2.bsflag = '0'"
				+ "   left join (select d2.*"
				+ "             from (select d1.*"
				+ "                     from (select hr.team,"
				+ "                                 hr.work_post,"
				+ "                               hr.employee_id,"
				+ "                                 hr.actual_start_date,"
				+ "                               hr.actual_end_date,"
				+ "                               row_number() over(partition by hr.employee_id order by hr.actual_end_date desc) numa"
				+ "                          from bgp_project_human_relation hr"
				+ "                         where hr.bsflag = '0'"
				+ "                         and hr.locked_if = '1') d1"
				+ "                 where d1.numa = 1) d2) phr"
				+ "     on e.employee_id = phr.employee_id"
				+ "  left join comm_coding_sort_detail d13"
				+ "    on h.present_state = d13.coding_code_id"
				+ "  left join comm_org_subjection pin"
				+ "    on h.pin_unit = pin.org_subjection_id"
				+ "   and pin.bsflag = '0'"
				+ "  left join bgp_comm_org_hr_gms pin1"
				+ "    on pin1.org_gms_id = pin.org_id"
				+ "  left join bgp_comm_org_hr pin2"
				+ "   on pin2.org_hr_id = pin1.org_hr_id"
				+ "  where e.bsflag = '0'"
				+ "    and h.bsflag = '0'"
				+ "   order by e.modifi_date desc, e.employee_name desc) t"
				+ " left join comm_coding_sort_detail d11"
				+ "    on t.set_teamw = d11.coding_code_id"
				+ "  left join comm_coding_sort_detail d12"
				+ "   on t.set_postw = d12.coding_code_id) temp   where temp.employee_id_code_no in(select EMPLOYEE_ID from dms_device_opcardapply_details where  sfcz='0' ";
		if (StringUtils.isNotBlank(apply_id)) {
			sql += " and apply_id='" + apply_id + "'";
		}
		sql += " )  union all ";

		sql += " select   employee_cd,employee_id employee_id_code_no,to_char(work_date, 'yyyy-MM-dd')  work_date, '' org_id,employee_name,    employee_gender,'' set_postw ,'' set_teamw, org_name ,post  from dms_device_opcardapply_details where  sfcz='1'";
		if (StringUtils.isNotBlank(apply_id)) {
			sql += " and apply_id='" + apply_id + "'";
		}
		sql += " ) tt left join BGP_DOC_GMS_FILE  b on b.relation_id=employee_id_code_no  where 1=1 ";
		if (StringUtils.isNotBlank(employee_id_code_no)) {
			sql += "and  employee_id_code_no='" + employee_id_code_no + "'";
		}
		List<Map> maps = pureDao.queryRecords(sql);
		log.info("执行sql:" + sql);
		responseDTO.setValue("datas", maps);
		return responseDTO;
	}

	/**
	 * 申请设备操作证用户信息
	 * 
	 * @param id
	 *            身份证号
	 * @return
	 */
	public ISrvMsg loadEmployeeInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String id = isrvmsg.getValue("employee_id");
		log.info("loadEmployeeInfo");
		String sql = "select * from (select *"
				+ " from (select distinct l.*,"
				+ " d3.coding_name post"
				+ " from (select distinct  "
				+ " '' employee_cd,"
				+ "  l.employee_id_code_no,"
				+ " to_char(l.create_date, 'yyyy-MM-dd')  work_date,"
				+ "  '' org_id,"
				+ "   l.employee_name,"
				+ "   decode(l.employee_gender, '0', '女', '1', '男') employee_gender,"
				+ "   nvl(t1.post, l.post) set_postw,"
				+ "   nvl(t1.apply_team, l.apply_team) set_teamw,"
				+ "   (select org_name from comm_org_information i where i.org_id=owning_org_id) org_name"
				+ "  from bgp_comm_human_labor l"
				+ "  left join (select lt.labor_id, count(1) nu"
				+ "  from bgp_comm_human_labor_list lt"
				+ "  left join bgp_comm_human_labor l"
				+ "     on l.labor_id = lt.labor_id"
				+ "   where lt.bsflag = '0'"
				+ "     and l.bsflag = '0'"
				+ "   group by lt.labor_id) lt"
				+ " on l.labor_id = lt.labor_id"
				+ " left join (select d2.*"
				+ "  from (select d1.*"
				+ "    from (select d.apply_team,"
				+ "                  d.post,"
				+ "                  l1.labor_id,"
				+ "                  row_number() over(partition by l1.labor_id order by d.start_date desc) numa"
				+ "             from bgp_comm_human_deploy_detail d"
				+ "             left join bgp_comm_human_labor_deploy l1"
				+ "               on d.labor_deploy_id ="
				+ "                  l1.labor_deploy_id"
				+ "           where d.bsflag = '0') d1"
				+ "    where d1.numa = 1) d2) t1"
				+ " on l.labor_id = t1.labor_id"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on l.employee_nation = d1.coding_code_id"
				+ "  left join comm_coding_sort_detail d2"
				+ "    on l.employee_education_level = d2.coding_code_id"
				+ " left join (select count(distinct"
				+ "                       to_char(t.start_date, 'yyyy')) years,"
				+ "                 t.labor_id"
				+ "            from bgp_comm_human_labor_deploy t"
				+ "           group by t.labor_id) t"
				+ "  on l.labor_id = t.labor_id"
				+ "  left join bgp_comm_human_certificate cft"
				+ "    on cft.employee_id = l.labor_id"
				+ "    and cft.bsflag = '0'"
				+ "   where l.bsflag = '0'"
				+ "    and l.owning_subjection_org_id like '%C105%') l"
				+ " left join comm_coding_sort_detail d3"
				+ "   on l.set_postw = d3.coding_code_id"
				+ "  left join comm_coding_sort_detail d4"
				+ "    on l.set_teamw = d4.coding_code_id) t"
				+ "   union all "
				+ "   select t.*"
				+ "  from (select h.employee_cd,"
				+ "  e.employee_id_code_no,"
				+ "   to_char(h.work_date, 'yyyy-MM-dd') work_date,"
				+ "   e.org_id,"
				+ "   e.employee_name,"
				+ "   decode(e.employee_gender, '0', '女', '1', '男') employee_gender,"
				+ "   nvl(phr.work_post, h.set_post) set_postw,"
				+ "   nvl(phr.team, h.set_team) set_teamw,"
				+ "   i.org_name org_name,"
				+ "   h.post"
				+ "  from comm_human_employee e"
				+ " inner join comm_human_employee_hr h"
				+ "    on e.employee_id = h.employee_id"
				+ "  left join comm_org_subjection s"
				+ "    on e.org_id = s.org_id"
				+ "   and s.bsflag = '0'"
				+ "  left join comm_org_information i"
				+ "   on e.org_id = i.org_id"
				+ "  and i.bsflag = '0'"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on h.post_level = d1.coding_code_id"
				+ "  and d1.bsflag = '0'"
				+ "   left join comm_coding_sort_detail d2"
				+ "    on e.employee_education_level = d2.coding_code_id"
				+ "    and d2.bsflag = '0'"
				+ "   left join (select d2.*"
				+ "             from (select d1.*"
				+ "                     from (select hr.team,"
				+ "                                 hr.work_post,"
				+ "                               hr.employee_id,"
				+ "                                 hr.actual_start_date,"
				+ "                               hr.actual_end_date,"
				+ "                               row_number() over(partition by hr.employee_id order by hr.actual_end_date desc) numa"
				+ "                          from bgp_project_human_relation hr"
				+ "                         where hr.bsflag = '0'"
				+ "                         and hr.locked_if = '1') d1"
				+ "                 where d1.numa = 1) d2) phr"
				+ "     on e.employee_id = phr.employee_id"
				+ "  left join comm_coding_sort_detail d13"
				+ "    on h.present_state = d13.coding_code_id"
				+ "  left join comm_org_subjection pin"
				+ "    on h.pin_unit = pin.org_subjection_id"
				+ "   and pin.bsflag = '0'"
				+ "  left join bgp_comm_org_hr_gms pin1"
				+ "    on pin1.org_gms_id = pin.org_id"
				+ "  left join bgp_comm_org_hr pin2"
				+ "   on pin2.org_hr_id = pin1.org_hr_id"
				+ "  where e.bsflag = '0'"
				+ "    and h.bsflag = '0'"
				+ "   order by e.modifi_date desc, e.employee_name desc) t"
				+ " left join comm_coding_sort_detail d11"
				+ "    on t.set_teamw = d11.coding_code_id"
				+ "  left join comm_coding_sort_detail d12"
				+ "   on t.set_postw = d12.coding_code_id) temp   where temp.employee_id_code_no='"
				+ id + "'";

		Map map = pureDao.queryRecordBySQL(sql);
		log.info("执行sql:" + sql);
		responseDTO.setValue("data", map);
		return responseDTO;

	}

	/**
	 * NEWMETHOD 车辆证照信息显示
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevLicInfo(ISrvMsg msg) throws Exception {
		log.info("queryDevLicInfo");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
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
		String devname = msg.getValue("devname");
		String devmodel = msg.getValue("devmodel");
		String licensetype = msg.getValue("licensetype");
		String licensenum = msg.getValue("licensenum");
		String devsign = msg.getValue("devsign");
		String validday = msg.getValue("validday");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select case when valid_day <= 30 then 'red' when valid_day <= 90 then 'yellow' else 'green' end as warn,"
				+ " tmp.* from(select row_number() over(partition by gdl.dev_acc_id, gdl.license_type order by gdl.dev_end_date desc) rn,"
				+ " dev.dev_sign,dev.dev_acc_id,dev.dev_name,dev.dev_model,dev.license_num,dev.dev_coding,"
				+ " dev.asset_coding,dev.usage_org_id,gdl.dev_license_id,gdl.dev_reg_date,gdl.license_type,"
				+ " gdl.dev_start_date,gdl.dev_end_date,gdl.dev_cgs_name,gdl.dev_user_name,gdl.dev_zs_no,"
				+ " case gdl.license_type when '001' then '车辆行驶证' when '002' then '车辆道路运输证' when '003' then '危货运输车辆检测' when '004' then  '危险品运输证' "
				+ " when '005' then '车辆二级维护' end as license_type_name,gdl.last_audit_date,"
				+ " case when round(to_number(gdl.dev_end_date - trunc(sysdate))) < 0 then 0 else round(to_number(gdl.dev_end_date - trunc(sysdate))) end as valid_day "
				+ " from gms_device_account dev join gms_device_license gdl on gdl.dev_acc_id = dev.dev_acc_id and gdl.bsflag = '0'"
				+ " where dev.bsflag = '0' and dev.account_stat = '"
				+ DevConstants.DEV_ACCOUNT_ZAIZHANG
				+ "' and dev.owning_sub_id like '"
				+ user.getSubOrgIDofAffordOrg()
				+ "%'"
				+ " and dev.dev_acc_id is not null ) tmp where rn = 1 ");
		// 设备名称
		if (StringUtils.isNotBlank(devname)) {
			querySql.append(" and dev_name like '%" + devname + "%'");
		}
		// 规格型号
		if (StringUtils.isNotBlank(devmodel)) {
			querySql.append(" and dev_model like '%" + devmodel + "%'");	
		}
		// 证照类型
		if (StringUtils.isNotBlank(licensetype)) {
			querySql.append(" and license_type like '%" + licensetype + "%'");
		}
		// 车牌号
		if (StringUtils.isNotBlank(licensenum)) {
			querySql.append(" and license_num like '%" + licensenum + "%'");
		}
		// 实物标识号
		if (StringUtils.isNotBlank(devsign)) {
			querySql.append(" and dev_sign like '%" + devsign + "%'");
		}
		// 有效天数
		if (StringUtils.isNotBlank(validday)) {
			querySql.append(" and to_number(valid_day) < '" + validday + "'");
		}
		querySql.append(" order by license_type,dev_end_date,valid_day ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * NEWMETHOD 查询车辆证照明细信息
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevLicDetInfo(ISrvMsg msg) throws Exception {
		log.info("queryDevLicDetInfo");
		String devlicense_id = msg.getValue("devlicenseid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);

		StringBuffer sb = new StringBuffer()
				.append("select dev.dev_type,dev.dev_acc_id,dev.dev_name, dev.dev_model,dev.license_num,dev.owning_org_id,"
						+ " org.org_abbreviation as owning_org_name,dev.asset_coding,dev.usage_org_id,usage.org_abbreviation as usage_org_name,"
						+ " dev.using_stat,usestat.coding_name as usestat_name, gdl.dev_license_id,gdl.dev_reg_date,dev.dev_coding,"
						+ " gdl.dev_start_date,gdl.dev_end_date,gdl.dev_cgs_name,gdl.dev_user_name,gdl.dev_zs_no,"
						+ " case gdl.license_type when '001' then '车辆行驶证' when '002' then '车辆道路运输证' when '003' then '危货运输车辆检测' when '004' then  '危险品运输证' "
						+ " when '005' then '车辆二级维护' end as license_type_name,gdl.dev_gd_bsflag,gdl.dev_sx_bsflag,sd.coding_name as cycle_name,gdl.last_audit_date,gdl.validate_end"
						+ " from gms_device_account dev join gms_device_license gdl on gdl.dev_acc_id = dev.dev_acc_id and gdl.bsflag = '0'"
						+ " left join comm_org_information usage on usage.org_id = dev.usage_org_id and usage.bsflag = '0'"
						+ " left join comm_coding_sort_detail usestat on usestat.coding_code_id = dev.using_stat and usestat.bsflag = '0'"
						+ " left join comm_org_information org on org.org_id = dev.owning_org_id and org.bsflag = '0'"
						+ " left join comm_coding_sort_detail sd on sd.coding_code_id = gdl.dev_audie_cycle and sd.bsflag = '0'"
						+ " where dev.bsflag = '0' and gdl.dev_license_id = '"
						+ devlicense_id + "'");

		Map devLicMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (devLicMap != null) {
			responseMsg.setValue("devLicMap", devLicMap);
		}
		return responseMsg;
	}

	/**
	 * NEWMETHOD 车辆证照审验明细
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryLicAuiditInfo(ISrvMsg msg) throws Exception {
		log.info("queryLicAuiditInfo");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
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
		String devaccid = msg.getValue("devaccid");
		String licensetype = msg.getValue("licensetype");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select distinct dev.dev_name,dev.dev_model,dev.license_num,dev.dev_coding,gdl.dev_start_date,gdl.dev_end_date,"
				+ " case gdl.license_type when '001' then '车辆行驶证' when '002' then '车辆道路运输证' when '003' then '危货运输车辆检测' when '004' then  '危险品运输证' "
				+ " when '005' then '车辆二级维护' end as license_type_name,gdl.last_audit_date"
				+ " from gms_device_account dev join gms_device_license gdl on gdl.dev_acc_id = dev.dev_acc_id and gdl.bsflag = '0'"
				+ " where dev.dev_acc_id = '"
				+ devaccid
				+ "' and gdl.license_type = '"
				+ licensetype
				+ "' order by gdl.dev_end_date desc");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
}
