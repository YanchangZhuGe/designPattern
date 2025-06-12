package com.bgp.dms.plan;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * @ClassName: DeviceStruAnalSrv
 * @Description:设备结构分析服务
 * @author dushuai
 * @date 2015-3-18
 */
public class DeviceStruAnalSrv extends BaseService {

	public DeviceStruAnalSrv() {
		log = LogFactory.getLogger(DeviceStruAnalSrv.class);
	}
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	IBaseDao baseDao = BeanFactory.getBaseDao();

	/**
	 * 获取设备结构信息数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevStruInfoData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// 地震仪器
		StringBuilder sql0 = new StringBuilder(
				"select sum(nvl(dh.sum_num,0)) as total_num, trunc(sum(nvl(dh.original_value,0))/10000,2) as total_ori,trunc(sum(nvl(dh.net_value,0))/10000,2) as total_net,"
						+ " '' as three_num,'' as three_ori,'' as three_net,'' as four_six_num,'' as four_six_ori,"
						+ " '' as four_six_net,'' as seven_nine_num,'' as seven_nine_ori,'' as seven_nine_net,"
						+ " '' as ten_num,'' as ten_ori,'' as ten_net"
						+ " from dms_device_tree dt left join gms_device_dailyhistory dh on dt.device_code=dh.device_type and dh.bsflag='0'"
						+ " where dt.bsflag='0' and dt.dev_tree_id like 'D001%' and dt.device_code is not null"
						+ " and dh.his_date= (select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0')");
		// 物探处
		if (StringUtils.isNotBlank(orgSubId)) {
			sql0.append(" and dh.org_subjection_id='"+orgSubId+"'");
		}
		// 可控震源 物探钻机 运输设备 推土机
		StringBuilder sql1 = new StringBuilder(
				"select tmp.*, dd.device_name as name,'closed' as state from (select substr(dt.dev_tree_id, 1, 4) as id,"
						+ " sum(case when da.dev_acc_id is not null then 1 else 0 end) as total_num,trunc(sum(nvl(da.asset_value, 0))/10000,2) as total_ori,trunc(sum(nvl(da.net_value, 0))/10000,2) as total_net,"
						+ " sum(case when months_between(sysdate, da.producting_date) / 12 <= 3 and da.dev_acc_id is not null then 1 else 0 end) as three_num,"
						+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 <= 3 then da.asset_value end,0))/10000,2) as three_ori,"
						+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 <= 3 then da.net_value end,0))/10000,2) as three_net,"
						+ " sum(case when months_between(sysdate, da.producting_date) / 12 > 3 and months_between(sysdate, da.producting_date) / 12 < 7 and da.dev_acc_id is not null then 1 else 0 end) as four_six_num,"
						+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 > 3 and months_between(sysdate, da.producting_date) / 12 < 7 then da.asset_value end,0))/10000,2) as four_six_ori,"
						+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 > 3 and months_between(sysdate, da.producting_date) / 12 < 7 then da.net_value end,0))/10000,2) as four_six_net,"
						+ " sum(case when months_between(sysdate, da.producting_date) / 12 >= 7 and months_between(sysdate, da.producting_date) / 12 < 10 and da.dev_acc_id is not null then 1 else 0 end) as seven_nine_num,"
						+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 >= 7 and months_between(sysdate, da.producting_date) / 12 < 10 then da.asset_value end,0))/10000,2) as seven_nine_ori,"
						+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 >= 7 and months_between(sysdate, da.producting_date) / 12 < 10 then da.net_value end,0))/10000,2) as seven_nine_net,"
						+ " sum(case when months_between(sysdate, da.producting_date) / 12 >= 10 and da.dev_acc_id is not null then 1 else 0 end) as ten_num,"
						+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 >= 10 then da.asset_value end,0))/10000,2) as ten_ori,"
						+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 >= 10 then da.net_value end,0))/10000,2) as ten_net"
						+ " from dms_device_tree dt left join gms_device_account da on dt.device_code = da.dev_type and da.bsflag = '0' and da.account_stat != '0110000013000000005'"
						+ " where dt.bsflag = '0' and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%')"
						+ " and dt.device_code is not null");
		// 物探处
		if (StringUtils.isNotBlank(orgSubId)) {
			sql1.append(" and (case when da.owning_sub_id like 'C105001%' or da.owning_sub_id like 'C105005%' then substr(da.owning_sub_id,1,10)"
					+ "  else substr(da.owning_sub_id, 1, 7) end) ='"
					+ orgSubId + "'");
		}
		sql1.append(" group by substr(dt.dev_tree_id, 1, 4)) tmp left join dms_device_tree dd on tmp.id = dd.dev_tree_id order by tmp.id");
		// 检波器
		StringBuilder sql2 = new StringBuilder(
				"select 'closed' as state ,'检波器' as name,'D005' as id,sum(nvl(dh.sum_num,0)) as total_num,"
						+ " trunc(sum(nvl(dh.original_value,0))/10000,2) as total_ori,trunc(sum(nvl(dh.net_value,0))/10000,2) as total_net,"
						+ " '' as three_num,'' as three_ori,'' as three_net,'' as four_six_num,'' as four_six_ori,"
						+ " '' as four_six_net,'' as seven_nine_num,'' as seven_nine_ori,'' as seven_nine_net,"
						+ " '' as ten_num,'' as ten_ori,'' as ten_net"
						+ " from dms_device_tree dt left join gms_device_dailyhistory dh on dt.device_code=dh.device_type and dh.bsflag='0' ");
		// 物探处
		if (StringUtils.isNotBlank(orgSubId)) {
			sql2.append(" and dh.org_subjection_id='"+orgSubId+"'");
		}
		sql2.append(" where dt.bsflag='0' and dt.dev_tree_id like 'D005%' and dt.device_code is not null"
		+ " and dh.his_date= (select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0')");
		Map map0 = jdbcDao.queryRecordBySQL(sql0.toString());
		List<Map> list1 = jdbcDao.queryRecords(sql1.toString());
		Map map1 = jdbcDao.queryRecordBySQL(sql2.toString());
		List<Map> tList =new ArrayList<Map>();
		if(MapUtils.isNotEmpty(map0)){
			if (StringUtils.isNotBlank(map0.get("total_num").toString())
					|| StringUtils.isNotBlank(map0.get("total_ori").toString())
					|| StringUtils.isNotBlank(map0.get("total_net").toString())) {
				map0.put("state", "closed");
				map0.put("name", "地震仪器");
				map0.put("id", "D001");
				tList.add(map0);
			}
		}
		if(CollectionUtils.isNotEmpty(list1)){
			tList.addAll(list1);
		}
		if(MapUtils.isNotEmpty(map1)){
			if (StringUtils.isNotBlank(map1.get("total_num").toString())
					|| StringUtils.isNotBlank(map1.get("total_ori").toString())
					|| StringUtils.isNotBlank(map1.get("total_net").toString())) {
				map1.put("state", "closed");
				map1.put("name", "检波器");
				map1.put("id", "D005");
				tList.add(map1);
			}
		}
		JSONArray retJson = JSONArray.fromObject(tList);
		if (retJson == null) {
			responseDTO.setValue("json", "[]");
		} else {
			responseDTO.setValue("json", retJson.toString());
		}
		return responseDTO;
	}

	/**
	 * 获取设备结构子节点信息数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevStruCNodeInfoData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String json="[]";
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// 父节点id
		String id = isrvmsg.getValue("id");
		int idLen=id.length()+3;
		// 地震仪器,检波器
		if(id.startsWith("D001") || id.startsWith("D005")){
			// 地震仪器
			StringBuilder sql = new StringBuilder(
					"select tdt.state,tdt.device_name as name,t1.* from"
							+ " (select substr(dt.dev_tree_id,1,"
							+ idLen
							+ ") as id,sum(nvl(dh.sum_num,0)) as total_num,trunc(sum(nvl(dh.original_value,0))/10000,2) as total_ori,"
							+ " trunc(sum(nvl(dh.net_value,0))/10000,2) as total_net,'' as three_num,'' as three_ori,'' as three_net,"
							+ " '' as four_six_num,'' as four_six_ori,'' as four_six_net,'' as seven_nine_num,'' as seven_nine_ori,'' as seven_nine_net,"
							+ " '' as ten_num,'' as ten_ori,'' as ten_net"
							+ " from dms_device_tree dt left join gms_device_dailyhistory dh on dt.device_code=dh.device_type and dh.bsflag='0'"
							+ " where dt.bsflag='0' and dt.dev_tree_id like '"
							+ id
							+ "%' and dt.device_code is not null"
							+ " and dh.his_date= (select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0')");
			// 物探处
			if (StringUtils.isNotBlank(orgSubId)) {
				sql.append(" and dh.org_subjection_id='"+orgSubId+"'");
			}
			sql.append(" group by substr(dt.dev_tree_id,1,"
					+ idLen
					+ ")) t1"
					+ " left join (select decode(connect_by_isleaf,'1','open','0','closed') as state,ddt.dev_tree_id,ddt.code_order, "
					+ " case when ddt.device_type is null then ddt.device_name else ddt.device_name||'('||ddt.device_type||')' end as device_name "
					+ " from dms_device_tree ddt connect by ddt.father_id = prior ddt.dev_tree_id start with ddt.father_id ='"
					+ id
					+ "') tdt on t1.id=tdt.dev_tree_id order by tdt.code_order");
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			JSONArray retJson = JSONArray.fromObject(list);
			if (retJson != null) {
				json=retJson.toString();
			} 
		}
		// 可控震源 物探钻机 运输设备 推土机
		if(id.startsWith("D002")||id.startsWith("D003")||id.startsWith("D004")||id.startsWith("D006")){
			StringBuilder sql = new StringBuilder(
					"select tmp.*, tdt.device_name as name,tdt.state from (select substr(dt.dev_tree_id, 1, "+idLen+") as id,"
							+ " sum(case when da.dev_acc_id is not null then 1 else 0 end) as total_num,trunc(sum(nvl(da.asset_value, 0))/10000,2) as total_ori,trunc(sum(nvl(da.net_value, 0))/10000,2) as total_net,"
							+ " sum(case when months_between(sysdate, da.producting_date) / 12 <= 3 and da.dev_acc_id is not null then 1 else 0 end) as three_num,"
							+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 <= 3 then da.asset_value end,0))/10000,2) as three_ori,"
							+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 <= 3 then da.net_value end,0))/10000,2) as three_net,"
							+ " sum(case when months_between(sysdate, da.producting_date) / 12 > 3 and months_between(sysdate, da.producting_date) / 12 < 7 and da.dev_acc_id is not null then 1 else 0 end) as four_six_num,"
							+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 > 3 and months_between(sysdate, da.producting_date) / 12 < 7 then da.asset_value end,0))/10000,2) as four_six_ori,"
							+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 > 3 and months_between(sysdate, da.producting_date) / 12 < 7 then da.net_value end,0))/10000,2) as four_six_net,"
							+ " sum(case when months_between(sysdate, da.producting_date) / 12 >= 7 and months_between(sysdate, da.producting_date) / 12 < 10 and da.dev_acc_id is not null then 1 else 0 end) as seven_nine_num,"
							+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 >= 7 and months_between(sysdate, da.producting_date) / 12 < 10 then da.asset_value end,0))/10000,2) as seven_nine_ori,"
							+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 >= 7 and months_between(sysdate, da.producting_date) / 12 < 10 then da.net_value end,0))/10000,2) as seven_nine_net,"
							+ " sum(case when months_between(sysdate, da.producting_date) / 12 >= 10 and da.dev_acc_id is not null then 1 else 0 end) as ten_num,"
							+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 >= 10 then da.asset_value end,0))/10000,2) as ten_ori,"
							+ " trunc(sum(nvl(case when months_between(sysdate, da.producting_date) / 12 >= 10 then da.net_value end,0))/10000,2) as ten_net"
							+ " from dms_device_tree dt left join gms_device_account da on dt.device_code = da.dev_type and da.bsflag = '0' and da.account_stat != '0110000013000000005'"
							+ " where dt.bsflag = '0' and dt.device_code is not null and dt.dev_tree_id like '"+id+"%'");
			// 物探处
			if (StringUtils.isNotBlank(orgSubId)) {
				sql.append(" and (case when da.owning_sub_id like 'C105001%' or da.owning_sub_id like 'C105005%' then substr(da.owning_sub_id,1,10)"
						+ "  else substr(da.owning_sub_id, 1, 7) end) ='"
						+ orgSubId + "'");
			}
			sql.append(" group by substr(dt.dev_tree_id, 1, "
					+ idLen
					+ ")) tmp left join "
					+ " (select decode(connect_by_isleaf,'1','open','0','closed') as state,ddt.dev_tree_id,ddt.code_order, "
					+ " case when ddt.device_type is null then ddt.device_name else ddt.device_name||'('||ddt.device_type||')' end as device_name "
					+ " from dms_device_tree ddt connect by ddt.father_id = prior ddt.dev_tree_id start with ddt.father_id ='"
					+ id + "') tdt"
					+ " on tmp.id=tdt.dev_tree_id order by tdt.code_order");
			List<Map> list = jdbcDao.queryRecords(sql.toString());
			JSONArray retJson = JSONArray.fromObject(list);
			if (retJson != null) {
				json=retJson.toString();
			} 
		}
		responseDTO.setValue("json", json);
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
