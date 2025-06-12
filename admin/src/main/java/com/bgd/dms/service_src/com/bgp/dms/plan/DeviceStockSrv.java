package com.bgp.dms.plan;

import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.bgp.dms.util.BigScreenUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * @ClassName: DeviceStockSrv
 * @Description:设备存量统计分析服务
 * @author dushuai
 * @date 2015-3-18
 */
public class DeviceStockSrv extends BaseService {
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	public DeviceStockSrv() {
		log = LogFactory.getLogger(DeviceStockSrv.class);
	}

	/**
	 * 获取存量图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getStockChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// 国内国外
		String country = isrvmsg.getValue("country");
		if(StringUtils.isBlank(country)){
			country="";
		}else{
			if("1".equals(country)){
				country="国内";
			}
			if("2".equals(country)){
				country="国外";			
			}
		}
		// 编码
		String code = isrvmsg.getValue("code");
		if(StringUtils.isBlank(code)){
			code="";
		}
		String display=isrvmsg.getValue("display");//显示
		StringBuilder sql = new StringBuilder(
				"select substr(dt.dev_tree_id, 1, 4) as device_code,"
						+ " sum(nvl(dh.use_num,0)) as use_num,"
						+ " sum(nvl(dh.idle_num,0)) as idle_num,"
						+ " sum(nvl(dh.repairing_num ,0)+nvl(dh.wait_repair_num,0)) as repaire_num,"
						+ " sum(nvl(dh.wait_scrap_num,0)) as wait_scrap_num,"
						+ " sum(nvl(dh.sum_num,0)-nvl(dh.idle_num,0)-nvl(dh.use_num,0)) as other_num"
						+ " from gms_device_dailyhistory dh"
						+ " left join dms_device_tree dt on dh.device_type = dt.device_code and dt.bsflag='0' and dt.device_code is not null"
					    + " where dh.bsflag = '0' and dh.account_stat='0110000013000000003' and dh.his_date=(select max(te.his_date) from gms_device_dailyhistory te where te.bsflag='0')");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dh.org_subjection_id='"+orgSubId+"'");
		}
		// 国内国外
		if(StringUtils.isNotBlank(country)){
			sql.append(" and dh.country = '"+country+"'");
		}
		// 编码
		if(StringUtils.isNotBlank(code)){
			sql.append(" and dt.dev_tree_id like '"+code+"%'");
		}	
		sql.append(" group by substr(dt.dev_tree_id, 1,4)");
		Map map = jdbcDao.queryRecordBySQL(sql.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		//大屏字体为微软雅黑，大小20
		if(null!=display && "bigScreen".equals(display)){
			root.addAttribute("baseFont", BigScreenUtil.BIG_SCREEN_FONT_FAMILY);
			root.addAttribute("baseFontSize", BigScreenUtil.BIG_SCREEN_FONT_SIZE);
		}else{
			root.addAttribute("baseFontSize", "12");
		}
		// 构造数据
		if(MapUtils.isNotEmpty(map)) {
			Element set1 = root.addElement("set");
			set1.addAttribute("label", "闲置");
			set1.addAttribute("value", map.get("idle_num").toString());
			setElementDisplayValue(display,code,set1,"闲置, "+map.get("idle_num").toString());
			Element set2 = root.addElement("set");
			set2.addAttribute("label", "在用");
			set2.addAttribute("value", map.get("use_num").toString());
			setElementDisplayValue(display,code,set2,"在用, "+map.get("use_num").toString());
			Element set3 = root.addElement("set");
			set3.addAttribute("label", "待报废");
			set3.addAttribute("value", map.get("wait_scrap_num").toString());
			setElementDisplayValue(display,code,set3,"待报废, "+map.get("wait_scrap_num").toString());
			Element set4 = root.addElement("set");
			set4.addAttribute("label", "维修");
			set4.addAttribute("value", map.get("repaire_num").toString());
			setElementDisplayValue(display,code,set4,"维修, "+map.get("repaire_num").toString());
			Element set5 = root.addElement("set");
			set5.addAttribute("label", "其他");
			set5.addAttribute("value", map.get("other_num").toString());
			setElementDisplayValue(display,code,set5,"其他, "+map.get("other_num").toString());
		}else{
			Element set1 = root.addElement("set");
			set1.addAttribute("label", "闲置");
			set1.addAttribute("value", "0");
			setElementDisplayValue(display,code,set1,"闲置, 0");
			Element set2 = root.addElement("set");
			set2.addAttribute("label", "在用");
			set2.addAttribute("value", "0");
			setElementDisplayValue(display,code,set2,"在用, 0");
			Element set3 = root.addElement("set");
			set3.addAttribute("label", "待报废");
			set3.addAttribute("value", "0");
			setElementDisplayValue(display,code,set3,"待报废, 0");
			Element set4 = root.addElement("set");
			set4.addAttribute("label", "维修");
			set4.addAttribute("value", "0");
			setElementDisplayValue(display,code,set4,"维修, 0");
			Element set5 = root.addElement("set");
			set5.addAttribute("label", "其他");
			set5.addAttribute("value", "0");
			setElementDisplayValue(display,code,set5,"其他, 0");
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	//设置设备显示数量单位（只针对地震仪器和检波器）
	public void setElementDisplayValue(String chartDisplay,String code,Element element,String displayName){
		//非大屏显示设备数量单位，大屏不显示设备数量单位
		if(null==chartDisplay || (!"bigScreen".equals(chartDisplay))){
			//地震仪器
			if("D001".equals(code)){
				element.addAttribute("displayValue", displayName+"道");
			}
			//检波器
			if("D005".equals(code)){
				element.addAttribute("displayValue", displayName+"串");
			}
		}
	}

	/**
	 * 获取地震仪器存量图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDzyqStockChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuilder sql = new StringBuilder(
				"select round(sum(nvl(acc.total_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as total_num,"
						+ " round(sum(nvl(acc.unuse_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as unuse_num,"
						+ " round(sum(nvl(acc.use_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as use_num,"
						+ " round(sum(nvl(te.touseless_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as touseless_num,"
						+ " round(sum(nvl(te.torepair_num, 0) * nvl(ms.device_slot_num, 0) +"
						+ " nvl(te.repairing_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as repair_num,"
						+ " round(sum(nvl(te.tocheck_num, 0) * nvl(ms.device_slot_num, 0) +"
						+ " nvl(te.destroy_num, 0) * nvl(ms.device_slot_num, 0))/10000,2) as other_num"
						+ " from gms_device_coll_account acc"
						+ " left join gms_device_coll_account_tech te on te.dev_acc_id = acc.dev_acc_id"
						+ " left join gms_device_collectinfo info on info.device_id = acc.device_id"
						+ " left join (select distinct su.device_id,su.device_name,su.device_model,su.device_slot_num"
						+ " from gms_device_collmodel_sub su left join gms_device_collmodel_main ma on su.model_mainid = ma.model_mainid"
						+ " where ma.bsflag = '0') ms on ms.device_id = acc.device_id"
						+ " where (info.dev_code like '01%' or info.dev_code like '02%' or info.dev_code like '03%' or info.dev_code like '05%') and acc.bsflag = '0'");
		Map map = jdbcDao.queryRecordBySQL(sql.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "2");
		root.addAttribute("baseFontSize", "12");
		// 构造数据
		Element set1 = root.addElement("set");
		set1.addAttribute("label", "闲置");
		set1.addAttribute("value", map.get("unuse_num").toString());
		set1.addAttribute("displayValue", "闲置, "+map.get("unuse_num").toString()+"万道");
		Element set2 = root.addElement("set");
		set2.addAttribute("label", "在用");
		set2.addAttribute("value", map.get("use_num").toString());
		set2.addAttribute("displayValue", "在用, "+map.get("use_num").toString()+"万道");
		Element set3 = root.addElement("set");
		set3.addAttribute("label", "待报废");
		set3.addAttribute("value", map.get("touseless_num").toString());
		set3.addAttribute("displayValue", "待报废, "+map.get("touseless_num").toString()+"万道");
		Element set4 = root.addElement("set");
		set4.addAttribute("label", "维修");
		set4.addAttribute("value", map.get("repair_num").toString());
		set4.addAttribute("displayValue", "维修, "+map.get("repair_num").toString()+"万道");
		Element set5 = root.addElement("set");
		set5.addAttribute("label", "其他");
		set5.addAttribute("value", map.get("other_num").toString());
		set5.addAttribute("displayValue", "其他, "+map.get("other_num").toString()+"万道");
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 获取检波器存量图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getJbqStockChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuilder sql = new StringBuilder(
				"select sum(nvl(acc.total_num, 0)) as total_num,"
						+ " sum(nvl(acc.unuse_num, 0)) as unuse_num,"
						+ " sum(nvl(acc.use_num, 0)) as use_num,"
						+ " sum(nvl(te.touseless_num, 0)) as touseless_num,"
						+ " sum(nvl(te.torepair_num, 0) +nvl(te.repairing_num, 0)) as repair_num,"
						+ " sum(nvl(te.tocheck_num, 0) +nvl(te.destroy_num, 0) ) as other_num"
						+ " from gms_device_coll_account acc"
						+ " left join gms_device_coll_account_tech te"
						+ " on te.dev_acc_id = acc.dev_acc_id"
						+ " left join gms_device_collectinfo info"
						+ " on info.device_id = acc.device_id"
						+ " where info.dev_code like '04%'"
						+ " and acc.bsflag = '0'");
		Map map = jdbcDao.queryRecordBySQL(sql.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// 构造数据
		Element set1 = root.addElement("set");
		set1.addAttribute("label", "闲置");
		set1.addAttribute("value", map.get("unuse_num").toString());
		set1.addAttribute("displayValue", "闲置, "+map.get("unuse_num").toString()+"串");
		Element set2 = root.addElement("set");
		set2.addAttribute("label", "在用");
		set2.addAttribute("value", map.get("use_num").toString());
		set2.addAttribute("displayValue", "在用, "+map.get("use_num").toString()+"串");
		Element set3 = root.addElement("set");
		set3.addAttribute("label", "待报废");
		set3.addAttribute("value", map.get("touseless_num").toString());
		set3.addAttribute("displayValue", "待报废, "+map.get("touseless_num").toString()+"串");
		Element set4 = root.addElement("set");
		set4.addAttribute("label", "维修");
		set4.addAttribute("value", map.get("repair_num").toString());
		set4.addAttribute("displayValue", "维修, "+map.get("repair_num").toString()+"串");
		Element set5 = root.addElement("set");
		set5.addAttribute("label", "其他");
		set5.addAttribute("value", map.get("other_num").toString());
		set5.addAttribute("displayValue", "其他, "+map.get("other_num").toString()+"串");
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
}
