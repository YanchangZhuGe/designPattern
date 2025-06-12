package com.bgp.dms.device;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * @ClassName: DeviceAnalSrv
 * @Description:设备出勤率统计分析服务
 * @author dushuai
 * @date 2015-3-18
 */
public class DeviceAtteSrv extends BaseService {

	public DeviceAtteSrv() {
		log = LogFactory.getLogger(DeviceAtteSrv.class);
	}

	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	IBaseDao baseDao = BeanFactory.getBaseDao();

	/**
	 * 获取出勤率图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAtteChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		System.out.println("orgSubId == "+orgSubId);
		// 开始时间
		String startDate = isrvmsg.getValue("startDate");
		// 结束时间
		String endDate = isrvmsg.getValue("endDate");
		String _startDate="";
		String _endDate="";
		if(StringUtils.isNotBlank(startDate)){
			_startDate=startDate;
		}else{
			_startDate=(currentYear+"-01-01").trim();
		}
		if(StringUtils.isNotBlank(endDate)){
			_endDate=endDate;
		}else{
			_endDate=currentDate;
		}
		// 可控震源 S062301 钻机S0601 运输设备S08 推土机S070301
		StringBuilder sql = new StringBuilder("select t.device_type,case  when t.device_type = '1' then  '可控震源' "
			+ " when t.device_type = '2' then '钻机'  when t.device_type = '3' then '运输设备' when t.device_type = '4' then '推土机' end as label,"
			+ " round(nvl(sum(sjcq),0)*100/ sum(case when ceil(act_out_time - actual_in_time) + 1 > 0 then ceil(act_out_time - actual_in_time) + 1 else  0  end),2) as cql "
			+ " from (select pro.project_info_no, dy.org_subjection_id,dui.owning_sub_id,dui.dev_acc_id,dui.actual_in_time, "
			+ " case when dui.actual_out_time is not null then dui.actual_out_time else pro.project_end_time end as act_out_time,dui.actual_out_time, "
			+ " pro.project_end_time,tm.sjcq ,case when dui.dev_type like 'S062301%' then '1' when dui.dev_type like 'S0601%' then "
			+ " '2' when dui.dev_type like 'S08%' then '3' when dui.dev_type like 'S070301%' then '4' end as device_type"
			+ " from gp_task_project pro left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no and dy.exploration_method = pro.exploration_method "
			+ " and dy.bsflag = '0' left join gms_device_account_dui dui on pro.project_info_no = dui.project_info_id and dui.bsflag <> '1' "
			+ " left join (select dt.device_account_id, sum(decode(dt.timesheet_symbol, '5110000041000000001',1,0)) as sjcq "
			+ " from (select distinct ts.timesheet_date,ts.timesheet_symbol,ts.device_account_id from bgp_comm_device_timesheet ts "
			+ " left join gms_device_account_dui ad on ts.device_account_id = ad.dev_acc_id and ad.bsflag <> '1' left join gp_task_project gp "
			+ " on ad.project_info_id = gp.project_info_no and gp.bsflag = '0' and gp.project_father_no is null and gp.project_status in "
			+ "('5000100001000000005','5000100001000000003') where ts.bsflag = '0' and ts.device_account_id is not null and ts.timesheet_date >= ad.actual_in_time "
			+ " and ts.timesheet_date <= decode(ad.actual_out_time,null,gp.project_end_time,ad.actual_out_time)"
			+ " and ( ad.dev_type like 'S062301%' or ad.dev_type like 'S0601%' or ad.dev_type like 'S08%' or ad.dev_type like 'S070301%') ) dt "
			+ " group by dt.device_account_id) tm on dui.dev_acc_id = tm.device_account_id  where pro.bsflag = '0' and pro.project_father_no is null "
			+ " and pro.project_status in ('5000100001000000005','5000100001000000003') " 
			+ " and ( dui.dev_type like 'S062301%' or dui.dev_type like 'S0601%' or dui.dev_type like 'S08%' or dui.dev_type like 'S070301%') ");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dy.org_subjection_id like '"+orgSubId+"%'");
		}
		// 开始时间 
		sql.append(" and dui.actual_out_time>=to_date('"+_startDate+"','yyyy-mm-dd')");
		// 结束时间 
		sql.append(" and decode(dui.actual_out_time,null,pro.project_end_time,dui.actual_out_time)<=to_date('"+_endDate+"','yyyy-mm-dd')");
		sql.append(" ) t group by t.device_type order by t.device_type");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		List<Map> tlist = new ArrayList<Map>();
		Map map1=new HashMap();
		map1.put("device_type","1");
		map1.put("label","可控震源");
		map1.put("cql","0");
		tlist.add(map1);
		Map map2=new HashMap();
		map2.put("device_type","2");
		map2.put("label","钻机");
		map2.put("cql","0");
		tlist.add(map2);
		Map map3=new HashMap();
		map3.put("device_type","3");
		map3.put("label","运输设备");
		map3.put("cql","0");
		tlist.add(map3);
		Map map4=new HashMap();
		map4.put("device_type","4");
		map4.put("label","推土机");
		map4.put("cql","0");
		tlist.add(map4);
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		// 构造数据
		for (Map tmap:tlist) {
			Element set = root.addElement("set");
			set.addAttribute("label", tmap.get("label").toString());
			String value = tmap.get("cql").toString();
				if(CollectionUtils.isNotEmpty(list)){
					for(Map map:list){
						if(MapUtils.isNotEmpty(map)&& map.get("device_type").toString().equals(tmap.get("device_type").toString())) {
							if(null!=map.get("cql") && StringUtils.isNotBlank(map.get("cql").toString())){
								value = map.get("cql").toString();
								set.addAttribute("link", "JavaScript:popProDevAtte('"+orgSubId+"','"+map.get("device_type").toString()+"','"+_startDate+"','"+_endDate+"')");
								list.remove(map);
								break;
							}
						}
					}
					
				}
			set.addAttribute("value", value);
			set.addAttribute("displayValue", value+"%");
			set.addAttribute("toolText", tmap.get("label").toString()+","+value+"%");
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}

	/**
	 * 获取所在项目设备出勤率图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProDevAtteChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		//设备类型 可控震源1 钻机2 运输设备3 推土机4 地震仪器5 检波器6
		String deviceType = isrvmsg.getValue("deviceType");
		String device_type="";
		// 可控震源
		if("1".equals(deviceType)){
			device_type="S062301";
		}
		// 钻机
		if("2".equals(deviceType)){
			device_type="S0601";
		}
		// 运输设备
		if("3".equals(deviceType)){
			device_type="S08";
		}
		// 推土机
		if("4".equals(deviceType)){
			device_type="S070301";
		}
		// 开始时间
		String startDate = isrvmsg.getValue("startDate");
		// 结束时间
		String endDate = isrvmsg.getValue("endDate");
		StringBuilder sql = new StringBuilder(
				"select t.project_info_no,t.project_name as label, "
						+ " round(nvl(sum(sjcq)*100 / sum(case when ceil(act_out_time-actual_in_time) + 1 > 0 then ceil(act_out_time-actual_in_time)+1 else 0 end),0),2) as cql "
						+ " from (select pro.project_info_no,pro.project_name,dui.actual_in_time, "
						+ " case when dui.actual_out_time is not null then dui.actual_out_time else pro.project_end_time end as act_out_time, "
						+ " dui.actual_out_time,pro.project_end_time,tm.sjcq "
						+ " from gp_task_project pro "
						+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no and dy.exploration_method = pro.exploration_method and dy.bsflag = '0' "
						+ " left join gms_device_account_dui dui on pro.project_info_no = dui.project_info_id and dui.bsflag <> '1' "
						+ " left join (select dt.device_account_id,sum(decode(dt.timesheet_symbol,'5110000041000000001',1,0)) as sjcq "
						+ " from (select distinct ts.timesheet_date,ts.timesheet_symbol,ts.device_account_id "
						+ " from bgp_comm_device_timesheet ts "
						+ " left join gms_device_account_dui ad on ts.device_account_id = ad.dev_acc_id and ad.bsflag <> '1' "
						+ " left join gp_task_project gp on ad.project_info_id = gp.project_info_no and gp.bsflag = '0' "
						+ " and gp.project_father_no is null and gp.project_status in('5000100001000000005','5000100001000000003') "
						+ " where ts.bsflag = '0' and ts.device_account_id is not null "
						+ " and ts.timesheet_date >= ad.actual_in_time "
						+ " and ts.timesheet_date <=decode(ad.actual_out_time,null,gp.project_end_time,ad.actual_out_time) "
						+ " and ad.dev_type like '"+device_type+"%') dt group by dt.device_account_id) tm on dui.dev_acc_id = tm.device_account_id "
						+ " where pro.bsflag = '0' and pro.project_father_no is null and pro.project_status in ('5000100001000000005', '5000100001000000003') "
						+ " and dui.dev_type like '"+device_type+"%' ");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dy.org_subjection_id like '"+orgSubId+"%'");
		}
		// 开始时间 
		if(StringUtils.isNotBlank(startDate)){
			sql.append(" and dui.actual_out_time>=to_date('"+startDate+"','yyyy-mm-dd')");
		}
		// 结束时间 
		if(StringUtils.isNotBlank(endDate)){
			sql.append(" and decode(dui.actual_out_time,null,pro.project_end_time,dui.actual_out_time)<=to_date('"+endDate+"','yyyy-mm-dd')");
		}
		sql.append(" ) t group by t.project_info_no, project_name");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		// 构造数据
		if(CollectionUtils.isNotEmpty(list)){
			for (Map map:list) {
				Element set = root.addElement("set");
				set.addAttribute("label", map.get("label").toString());
				set.addAttribute("value", map.get("cql").toString());
				set.addAttribute("displayValue", map.get("cql").toString()+"%");
				set.addAttribute("toolText", map.get("label").toString()+","+map.get("cql").toString()+"%");
				String proNo=map.get("project_info_no").toString();
				set.addAttribute("link", "JavaScript:popProDevAtteList('"+orgSubId+"','"+proNo+"','"+device_type+"','"+startDate+"','"+endDate+"')");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 查询设备出勤率信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevAtteInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryDevAtteInfoList");
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
		String orgSubId = isrvmsg.getValue("orgSubId");//  物探处
		String deviceType = isrvmsg.getValue("deviceType");// 设备编码
		String proNo = isrvmsg.getValue("proNo");// 项目编号
		String li_num=isrvmsg.getValue("li_num");
		String self_num=isrvmsg.getValue("slef_num");
		// 开始时间
		String startDate = isrvmsg.getValue("startDate");
		// 结束时间
		String endDate = isrvmsg.getValue("endDate");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,(case when ceil(act_out_time - actual_in_time) + 1 > 0 then ceil(act_out_time - actual_in_time) + 1 else 0 end) as tcq "
				+ " from (select pro.project_info_no,pro.project_name,dui.dev_acc_id,dui.dev_name,dui.dev_model,dui.dev_coding,dui.actual_in_time, "
				+ " case when dui.actual_out_time is not null then dui.actual_out_time else pro.project_end_time end as act_out_time,nvl(tm.sjcq,0) as sjcq "
				+ " from gp_task_project pro left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no and dy.exploration_method = pro.exploration_method and dy.bsflag = '0' "
				+ " left join gms_device_account_dui dui on pro.project_info_no = dui.project_info_id and dui.bsflag <> '1' "
				+ " left join (select dt.device_account_id,sum(decode(dt.timesheet_symbol,'5110000041000000001',1,0)) as sjcq "
				+ " from (select distinct ts.timesheet_date,ts.timesheet_symbol,ts.device_account_id "
				+ " from bgp_comm_device_timesheet ts left join gms_device_account_dui ad on ts.device_account_id = ad.dev_acc_id and ad.bsflag <> '1' "
				+ " left join gp_task_project gp on ad.project_info_id = gp.project_info_no and gp.bsflag = '0' and gp.project_father_no is null "
				+ " and gp.project_status in ('5000100001000000005','5000100001000000003') "
				+ " where ts.bsflag = '0' and ts.device_account_id is not null and ts.timesheet_date >= ad.actual_in_time "
				+ " and ts.timesheet_date <=decode(ad.actual_out_time,null,gp.project_end_time,ad.actual_out_time) "
				+ " and ad.dev_type like '"
				+ deviceType
				+ "%') dt group by dt.device_account_id) tm on dui.dev_acc_id = tm.device_account_id "
				+ " where pro.bsflag = '0' and pro.project_father_no is null and pro.project_status in ('5000100001000000005', '5000100001000000003') and dui.dev_type like '"
				+ deviceType + "%' ");

		// 物探处
		if (StringUtils.isNotBlank(orgSubId)) {
			querySql.append(" and dy.org_subjection_id like '" + orgSubId + "%'");
		}
		// 项目编号
		if (StringUtils.isNotBlank(proNo)) {
			querySql.append(" and pro.project_info_no = '" + proNo + "'");
		}
		// 开始时间
		if (StringUtils.isNotBlank(startDate)) {
			querySql.append(" and dui.actual_out_time>=to_date('" + startDate + "','yyyy-mm-dd')");
		}
		// 结束时间
		if (StringUtils.isNotBlank(endDate)) {
			querySql.append(" and decode(dui.actual_out_time,null,pro.project_end_time,dui.actual_out_time)<=to_date('" + endDate + "','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(li_num)){
			querySql.append(" and license_num like '%"+li_num+"%'");
		}
		if(StringUtils.isNotBlank(self_num)){
			querySql.append(" and self_num like '%"+self_num+"%'");
		}
		querySql.append(" ) t order by t.dev_coding");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询设备实际出勤信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProDevActAtteList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryProDevActAtteList");
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
		String devAccId = isrvmsg.getValue("devAccId");// 设备id
		// 开始时间
		String startDate = isrvmsg.getValue("startDate");
		// 结束时间
		String endDate = isrvmsg.getValue("endDate");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select dui.dev_name,dui.dev_model,dui.self_num,dui.dev_sign,dui.license_num,dui.dev_coding,t.timesheet_date from ( "
				+ " select distinct ts.timesheet_date,ts.timesheet_symbol,ts.device_account_id "
				+ " from bgp_comm_device_timesheet ts where ts.bsflag = '0' and ts.timesheet_symbol='5110000041000000001' ");
		// 设备id
		if (StringUtils.isNotBlank(devAccId)) {
			querySql.append(" and ts.device_account_id = '" + devAccId + "'");
		}
		// 开始时间
		if (StringUtils.isNotBlank(startDate)) {
			querySql.append(" and ts.timesheet_date>=to_date('" + startDate + "','yyyy-mm-dd')");
		}
		// 结束时间
		if (StringUtils.isNotBlank(endDate)) {
			querySql.append(" and ts.timesheet_date<=to_date('" + endDate + "','yyyy-mm-dd')");
		}
		querySql.append(" ) t left join gms_device_account_dui dui on dui.dev_acc_id=t.device_account_id order by t.timesheet_date");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 获取当前年度
	 * 
	 * @return
	 */
	public String getCurrentYear() {
		Calendar cal = Calendar.getInstance();
		Integer year = cal.get(Calendar.YEAR);
		return year.toString();
	}

	/**
	 * 获取当前时间
	 * 
	 * @return
	 */
	public String getCurrentDate() {
		Date now = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd");
		return dateFormat.format(now);
	}

	
}
