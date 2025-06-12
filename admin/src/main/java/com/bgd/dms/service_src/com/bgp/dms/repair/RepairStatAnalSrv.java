package com.bgp.dms.repair;

import java.net.URLDecoder;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.xml.soap.SOAPException;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.bgp.dms.charts.cache.SelfCacheUtil;
import com.bgp.mcs.service.util.CacheUtil;
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
 * @ClassName: RepairStatAnalSrv
 * @Description:维修统计分析服务
 * @author dushuai
 * @date 2015-5-15
 */
public class RepairStatAnalSrv extends BaseService {

	public RepairStatAnalSrv() {
		log = LogFactory.getLogger(RepairStatAnalSrv.class);
	}
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	IBaseDao baseDao = BeanFactory.getBaseDao();
	private ISrvMsg getChartsDataFromCache(String key,ISrvMsg responseDTO) throws SOAPException{
		if(SelfCacheUtil.getCache("getRepairCostChartData")!=null){
			String chartStr = SelfCacheUtil.getCache("getRepairCostChartData").toString();
			responseDTO.setValue("Str", chartStr);
			//responseDTO.setValue("Str", CacheUtil.get("RepairCostChartData"));
			return responseDTO; 
		}
		return null;
	}
	/**
	 * 车辆维修费用统计
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg devRepaTypes(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String chartStr  = null;
		/*if(SelfCacheUtil.getCache("getRepairCostChartData")!=null){
			chartStr = SelfCacheUtil.getCache("getRepairCostChartData").toString();
			responseDTO.setValue("Str", chartStr);
			//responseDTO.setValue("Str", CacheUtil.get("RepairCostChartData"));
			return responseDTO; 
		}*/
		String dev_types=isrvmsg.getValue("dev_types");
		 String startDate=isrvmsg.getValue("startDate");
		 String endDate=isrvmsg.getValue("endDate");
		String sql1="select device_name||'('||device_type||')' dev_name from dms_device_tree where dev_tree_id in ("+dev_types+") ";
		List<Map> dev_names = jdbcDao.queryRecords(sql1.toString());
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		String year = isrvmsg.getValue("year");
		if(StringUtils.isBlank(year)){
			year=getCurrentYear();
		}
		
		String sql =  " select * from( select dev_tree_id,device_name, nvl(sum(totalcost),0) totalcost, to_char(repair_start_date, 'fmmm') mon from (select * from (select dt.dev_tree_id,acc.dev_name||'('||acc.dev_model||')' device_name,(pinfo.HUMAN_COST+pinfo.MATERIAL_COST) totalcost, pinfo.repair_start_date from BGP_COMM_DEVICE_REPAIR_INFO pinfo, gms_device_account acc, dms_device_tree dt where pinfo.project_info_no is null and acc.dev_acc_id = pinfo.device_account_id and dt.device_code=acc.dev_type union all select dt1.dev_tree_id,acc1.dev_name||'('||acc1.dev_model||')' device_name ,(info.HUMAN_COST+info.MATERIAL_COST) totalcost, info.repair_start_date from BGP_COMM_DEVICE_REPAIR_INFO info, gms_device_account_dui dui, gms_device_account acc1, dms_device_tree dt1 where info.device_account_id = dui.dev_acc_id and dui.fk_dev_acc_id = acc1.dev_acc_id and dt1.device_code=acc1.dev_type) where repair_start_date between to_date('"+startDate+"', 'yyyy-mm-dd') and to_date('"+endDate+"', 'yyyy-mm-dd') order by dev_tree_id,device_name, repair_start_date) group by dev_tree_id,device_name,to_char(repair_start_date, 'fmmm')) where dev_tree_id in ("+dev_types+") order by mon ";
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		DecimalFormat df = new DecimalFormat("0.00");
		
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("yAxisName", "(单位：元)");
		Element categories=root.addElement("categories");
		
		for(int i=1;i<=12;i++){
			Element category = categories.addElement("category");
			category.addAttribute("label", String.valueOf(i));
		}
		for (Map obj : dev_names) {
			String names=(String)obj.get("dev_name");
			Element dataset=root.addElement("dataset");
			dataset.addAttribute("seriesName", names);
			dataset.addAttribute("color", getRandColorCode());
			
			List<Map> listtemp=new ArrayList<Map>();
			for (Map tmap1:list) {
			if(names.equals(tmap1.get("device_name"))){
				listtemp.add(tmap1);
			}	
			}
			
			for (Map object : listtemp) {
				
				Element tset = dataset.addElement("set");
				tset.addAttribute("value", (String)object.get("totalcost"));
				tset.addAttribute("toolText", "维修金额："+(String)object.get("totalcost"));
				tset.addAttribute("showValue","0");
			}	
			 	 
			} 
		 
		
		//CacheUtil.set("RepairCostChartData", document.asXML());
		//chartStr = document.asXML();
		//SelfCacheUtil.updateCache("getRepairCostChartData", chartStr);
		responseDTO.setValue("Str", document.asXML());
		//responseDTO.setValue("Str", CacheUtil.get("RepairCostChartData"));
		return responseDTO;
	}
	//随机颜色16进制
	public  String getRandColorCode(){  
		  String r,g,b;  
		  Random random = new Random();  
		  r = Integer.toHexString(random.nextInt(256)).toUpperCase();  
		  g = Integer.toHexString(random.nextInt(256)).toUpperCase();  
		  b = Integer.toHexString(random.nextInt(256)).toUpperCase();  
		     
		  r = r.length()==1 ? "0" + r : r ;  
		  g = g.length()==1 ? "0" + g : g ;  
		  b = b.length()==1 ? "0" + b : b ;  
		     
		  return r+g+b;  
	}
	/**
	 * 获取维修费用统计图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairCostChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String chartStr  = null;
		/*if(SelfCacheUtil.getCache("getRepairCostChartData")!=null){
			chartStr = SelfCacheUtil.getCache("getRepairCostChartData").toString();
			responseDTO.setValue("Str", chartStr);
			//responseDTO.setValue("Str", CacheUtil.get("RepairCostChartData"));
			return responseDTO; 
		}*/
		
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		String year = isrvmsg.getValue("year");
		if(StringUtils.isBlank(year)){
			year=getCurrentYear();
		}
		
		StringBuilder sql = new StringBuilder(
				"select to_number(tttmp.repair_month,'99') as repair_month,tttmp.repair_cost," 
				        + " sum(tttmp.repair_cost) over(order by tttmp.repair_month) as repair_toal_cost from ("
						+ " select ttmp.repair_month,sum(ttmp.repair_cost) as repair_cost from ("
						+ " select tmp.repair_cost as repair_cost,"
						+ " substr(to_char(tmp.repair_date, 'yyyy-mm-dd'), 6, 2) as repair_month"
						+ " from ( select * from (");
		sql.append(getRepairAnalBasicSql());
		sql.append(") tt where 1=1");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tt.sub_id like '"+orgSubId+"%'");
		}
		// 年度
		if(StringUtils.isNotBlank(year)){
			sql.append(" and to_char(tt.repair_date, 'yyyy')='"+year+"'");
		}
		sql.append(" ) tmp) ttmp group by ttmp.repair_month ) tttmp");
		log.info("getRepairCostFusionChart sql=" + sql.toString());
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		List<Map> tList= new ArrayList<Map>();
		for(int i=1;i<=12;i++){
			Map smap=new HashMap();
			smap.put("repair_month", i);
			smap.put("repair_cost", 0);
			tList.add(smap);
		} 
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		DecimalFormat df = new DecimalFormat("0.00");
		
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("yAxisName", "(单位：万元)");
		Element categories=root.addElement("categories");
		Element tdataset=root.addElement("dataset");
		tdataset.addAttribute("seriesName", "总额度");
		tdataset.addAttribute("color", "A66EDD");
		Element mdataset=root.addElement("dataset");
		mdataset.addAttribute("seriesName", "月额度");
		mdataset.addAttribute("color", "F6BD0F");
		String tCost="0";
		// 构造数据
		for (Map tmap:tList) {
			Element category = categories.addElement("category");
			String tmonth=tmap.get("repair_month").toString();
			category.addAttribute("label", tmonth);
			//总量维修额度
			Element tset = tdataset.addElement("set");
			//月维修额度
			Element mset = mdataset.addElement("set");
			String mCost=tmap.get("repair_cost").toString();
			if(CollectionUtils.isNotEmpty(list)){
				for(Map map:list){
					if(tmonth.equals(map.get("repair_month").toString())) {
						tCost = map.get("repair_toal_cost").toString();
						tCost = df.format(Double.parseDouble(tCost)/10000 );
						mCost = map.get("repair_cost").toString();
						mCost = df.format(Double.parseDouble(mCost)/10000 );
						list.remove(map);
						break;
					}
				}
			}
			tset.addAttribute("value", tCost);
			tset.addAttribute("toolText", "总额度："+tCost);
			tset.addAttribute("showValue","0");
			if(!"0".equals(tCost)){
				tset.addAttribute("link", "JavaScript:popRepairMainChart('"+year+"','"+tmonth+"','"+orgSubId+"','total')");
			}else{
				
			}
			mset.addAttribute("value", mCost);
			mset.addAttribute("toolText", "月额度："+mCost);
			mset.addAttribute("showValue","0");
			
			if(!"0".equals(mCost)){
				mset.addAttribute("link", "JavaScript:popRepairMainChart('"+year+"','"+tmonth+"','"+orgSubId+"','month')");
			}
		}
		CacheUtil.set("RepairCostChartData", document.asXML());
		System.out.println("RepairCostChartData=" +  CacheUtil.get("RepairCostChartData"));
		chartStr = document.asXML();
		SelfCacheUtil.updateCache("getRepairCostChartData", chartStr);
		responseDTO.setValue("Str", document.asXML());
		//responseDTO.setValue("Str", CacheUtil.get("RepairCostChartData"));
		return responseDTO;
	}
	
	/**
	 * 获取维修统计基本sql
	 * @return  
	 */
	public String getRepairAnalBasicSql(){
		String sql = " select nvl(ri.human_cost, 0) + nvl(ri.material_cost, 0) as repair_cost,"
				+ " case when ri.repair_level='605' then 'baoyang' else 'weixiu' end as repair_type,"
				+ " ri.repair_start_date as repair_date, "
				+ " 'xcwx' data_type,"
				+ " dui.dev_type,"
				+ " acc.ifcountry,"
				+ " dui.dev_name,"
				+ " dui.dev_model,"
				+ " dui.self_num,"
				+ " dui.license_num,"
				+ " dui.dev_sign,"
				+ " nvl(dui.asset_value,0) as asset_value,"
				+ " nvl(dui.net_value,0) as net_value,"
				+ " ri.project_info_no,"
				+ " case when dui.owning_sub_id like 'C105001%' then"
				+ " substr(dui.owning_sub_id, 1, 10) when dui.owning_sub_id like 'C105005%' then"
				+ " substr(dui.owning_sub_id, 1, 10) else substr(dui.owning_sub_id, 1, 7) end as sub_id"
				+ " from bgp_comm_device_repair_info ri "
				+ " left join gms_device_account_dui dui on ri.device_account_id = dui.dev_acc_id and dui.bsflag = '0' "
				+ " left join gms_device_account acc on dui.fk_dev_acc_id=acc.dev_acc_id and acc.bsflag='0' "
				+ " where ri.bsflag = '0' and ri.datafrom is null and ri.project_info_no is not null "
				+ " union all"
				+ " select nvl(ri.human_cost, 0) + nvl(ri.material_cost, 0) as repair_cost,"
				+ " case when ri.repair_level='605' then 'baoyang' else 'weixiu' end as repair_type,"
				+ " ri.repair_start_date as repair_date,"
				+ " 'fxcwx' data_type,"
				+ " acc.dev_type,"
				+ " acc.ifcountry,"
				+ " acc.dev_name,"
				+ " acc.dev_model,"
				+ " acc.self_num,"
				+ " acc.license_num,"
				+ " acc.dev_sign,"
				+ " nvl(acc.asset_value,0) as asset_value,"
				+ " nvl(acc.net_value,0) as net_value,"
				+ " '' as project_info_no,"
				+ " case when acc.owning_sub_id like 'C105001%' then substr(acc.owning_sub_id, 1, 10)"
				+ " when acc.owning_sub_id like 'C105005%' then substr(acc.owning_sub_id, 1, 10) else substr(acc.owning_sub_id, 1, 7) end as sub_id"
				+ " from bgp_comm_device_repair_info ri"
				+ " left join gms_device_account acc on ri.device_account_id = acc.dev_acc_id and acc.bsflag = '0'"
				+ " where ri.bsflag = '0' and ( ri.datafrom ='SAP' or ( ri.datafrom is null and ri.project_info_no is null ))"
				+ " union all"
				+ " select nvl(m.use_num, 0) * nvl(r.actual_price, 0) as repair_cost,"
				+ " case when t.maintenance_level='无' then 'weixiu' else 'baoyang' end as repair_type,"
				+ " t.bywx_date as repair_date,"
				+ " 'fxcwx' data_type,"
				+ " acc.dev_type,"
				+ " acc.ifcountry,"
				+ " acc.dev_name,"
				+ " acc.dev_model,"
				+ " acc.self_num,"
				+ " acc.license_num,"
				+ " acc.dev_sign,"
				+ " nvl(acc.asset_value,0) as asset_value,"
				+ " nvl(acc.net_value,0) as net_value,"
				+ " '' as project_info_no,"
				+ " t.org_subjection_id as sub_id"
				+ " from gms_device_zy_bywx t"
				+ " left join gms_device_zy_wxbymat m on t.usemat_id = m.usemat_id"
				+ " left join gms_mat_recyclemat_info r on r.wz_id = m.wz_id"
				+ " left join gms_device_account acc on t.dev_acc_id=acc.dev_acc_id and acc.bsflag = '0' "
				+ " where t.project_info_id is null and r.wz_type = '3' and r.bsflag = '0' and r.project_info_id is null and t.bsflag = '0'"
				+ " union all"
				+ " select nvl(m.use_num, 0) * nvl(r.actual_price, 0) as repair_cost,"
				+ " case when t.maintenance_level='无' then 'weixiu' else 'baoyang' end as repair_type,"
				+ " t.bywx_date as repair_date,"
				+ " 'xcwx' data_type,"
				+ " dui.dev_type,"
				+ " acc.ifcountry,"
				+ " dui.dev_name,"
				+ " dui.dev_model,"
				+ " dui.self_num,"
				+ " dui.license_num,"
				+ " dui.dev_sign,"
				+ " nvl(dui.asset_value,0) as asset_value,"
				+ " nvl(dui.net_value,0) as net_value,"
				+ " t.project_info_id as project_info_no,"
				+ " t.org_subjection_id as sub_id"
				+ " from gms_device_zy_bywx t"
				+ " left join gms_device_zy_wxbymat m on t.usemat_id = m.usemat_id"
				+ " left join gms_mat_recyclemat_info r on r.wz_id = m.wz_id"
				+ " left join gms_device_account_dui dui on t.dev_acc_id=dui.dev_acc_id and dui.bsflag = '0'"
				+ " left join gms_device_account acc on dui.fk_dev_acc_id=acc.dev_acc_id and acc.bsflag='0' "
				+ " where t.bsflag = '0' and r.project_info_id = t.project_info_id";
		return sql;
	}
	
	/**
	 * 获取项目维修费用基本sql
	 * @return
	 */
	public String getProjRepairCostBasicSql(){
		String sql = "select nvl(ri.human_cost, 0) + nvl(ri.material_cost, 0) as repair_cost,"
				+ " ri.repair_start_date as repair_date, "
				+ " ri.project_info_no,"
				+ " pro.project_name,"
				+ " dui.dev_coding,"
				+ " dui.dev_name,"
				+ " dui.dev_model,"
				+ " dui.self_num,"
				+ " dui.dev_sign,"
				+ " case when dui.owning_sub_id like 'C105001%' then"
				+ " substr(dui.owning_sub_id, 1, 10) when dui.owning_sub_id like 'C105005%' then"
				+ " substr(dui.owning_sub_id, 1, 10) else substr(dui.owning_sub_id, 1, 7) end as sub_id"
				+ " from bgp_comm_device_repair_info ri "
				+ " left join gms_device_account_dui dui on ri.device_account_id = dui.dev_acc_id and dui.bsflag = '0' "
				+ " left join gp_task_project pro on ri.project_info_no=pro.project_info_no "
				+ " where ri.bsflag = '0' and ri.datafrom is null and ri.project_info_no is not null"
				+ " union all"
				+ " select nvl(m.use_num, 0) * nvl(r.actual_price, 0) as repair_cost,"
				+ " t.bywx_date as repair_date,"
				+ " t.project_info_id as project_info_no,"
				+ " pro.project_name,"
				+ " dui.dev_coding,"
				+ " dui.dev_name,"
				+ " dui.dev_model,"
				+ " dui.self_num,"
				+ " dui.dev_sign,"
				+ " t.org_subjection_id as sub_id"
				+ " from gms_device_zy_bywx t"
				+ " left join gms_device_zy_wxbymat m on t.usemat_id = m.usemat_id"
				+ " left join gms_mat_recyclemat_info r on r.wz_id = m.wz_id"
				+ " left join gp_task_project pro on t.project_info_id=pro.project_info_no"
				+ " left join gms_device_account_dui dui on t.dev_acc_id=dui.dev_acc_id"
				+ " where r.project_info_id = t.project_info_id";
		return sql;
	}
	/**
	 * 获取维护,保养图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairMainChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 年度
		String year = isrvmsg.getValue("year");
		// 月份
		String month = isrvmsg.getValue("month");
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// 总额度，月额度标识
		String flag = isrvmsg.getValue("flag");
		StringBuilder sql = new StringBuilder(
				"select sum(tt.repair_cost) as repair_cost,tt.repair_type as repair_type,round(ratio_to_report(sum(tt.repair_cost)) over(),4)*100 as rate from ("
						+ " select * from ( ");
		sql.append(getRepairAnalBasicSql());
		sql.append("  ) t where 1=1 ");
		// 年度
		if(StringUtils.isNotBlank(year)){
			sql.append(" and to_char(t.repair_date, 'yyyy')='"+year+"'");
		}
		// 总额
		if("total".equals(flag)){
			sql.append(" and to_number(substr(to_char(t.repair_date, 'yyyy-mm-dd'),6,2),'99') <= "+month+"");
		}else{// 月额度
			sql.append(" and to_number(substr(to_char(t.repair_date, 'yyyy-mm-dd'),6,2),'99') = "+month+"");
		}
		sql.append(" ) tt group by tt.repair_type");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		List<Map> tlist = new ArrayList<Map>();
		Map map1=new HashMap();
		map1.put("repair_type","baoyang");
		map1.put("label","保养");
		map1.put("value","0");
		tlist.add(map1);
		Map map2=new HashMap();
		map2.put("repair_type","weixiu");
		map2.put("label","维修");
		map2.put("value","0");
		tlist.add(map2);
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// 构造数据
		for (Map tmap:tlist) {
			Element set = root.addElement("set");
			set.addAttribute("label", tmap.get("label").toString());
			String value = tmap.get("value").toString();
			String toolText= "0";
			if(CollectionUtils.isNotEmpty(list)){
				for(Map map:list){
					if(map.get("repair_type").toString().equals(tmap.get("repair_type").toString())) {
						if(null!=map.get("repair_cost") && StringUtils.isNotBlank(map.get("repair_cost").toString())){
							value = map.get("rate").toString();
							toolText= map.get("repair_cost").toString();
							list.remove(map);
							break;
						}
					}
				}
			}
			set.addAttribute("value", value);
			set.addAttribute("displayValue", tmap.get("label").toString()+","+value+"%");
			set.addAttribute("toolText", toolText);
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 获取维修费用占比图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairCostProportionChartData(ISrvMsg isrvmsg) throws Exception {
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
		StringBuilder sql = new StringBuilder(
				"select sum(t.repair_cost) as repair_cost_pro,t.data_type,round(ratio_to_report(sum(t.repair_cost)) over(),4)*100 as rate from ("
						+ " select * from ( ");
		sql.append(getRepairAnalBasicSql());
		sql.append("  ) tmp where 1=1 ");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp.sub_id like '"+orgSubId+"%'");
		}
		// 开始时间
		sql.append(" and tmp.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and tmp.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t group by t.data_type");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		List<Map> tlist = new ArrayList<Map>();
		Map map1=new HashMap();
		map1.put("data_type","xcwx");
		map1.put("label","现场维修数据");
		map1.put("value","0");
		tlist.add(map1);
		Map map2=new HashMap();
		map2.put("data_type","fxcwx");
		map2.put("label","恢复性修理数据");
		map2.put("value","0");
		tlist.add(map2);
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// 构造数据
		for (Map tmap:tlist) {
			Element set = root.addElement("set");
			set.addAttribute("label", tmap.get("label").toString());
			String value = tmap.get("value").toString();
			String toolText="0";
			if(CollectionUtils.isNotEmpty(list)){
				for(Map map:list){
					if(map.get("data_type").toString().equals(tmap.get("data_type").toString())) {
						if(null!=map.get("repair_cost_pro") && StringUtils.isNotBlank(map.get("repair_cost_pro").toString())){
							value = map.get("rate").toString();
							toolText= map.get("repair_cost_pro").toString();
							list.remove(map);
							break;
						}
					}
				}
			}
			set.addAttribute("value", value);
			set.addAttribute("displayValue", tmap.get("label").toString()+","+value+"%");
			set.addAttribute("toolText", toolText+"元");
			if((!"0".equals(value)) && ("xcwx".equals(tmap.get("data_type").toString()))){
				set.addAttribute("link", "JavaScript:popProjRepaCostList('"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 查询项目维修费用信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProjRepaCostList(ISrvMsg isrvmsg) throws Exception {
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
		String orgSubId = isrvmsg.getValue("orgSubId");// 物探处
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
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
		StringBuilder sql = new StringBuilder(
				"select tt.*,inf.org_abbreviation from (select sum(t.repair_cost) as repair_cost,t.sub_id,t.project_name,t.project_info_no"
						+ " from ( select * from (");
		sql.append(getProjRepairCostBasicSql());
		sql.append(" ) tmp where 1=1");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp.sub_id like '"+orgSubId+"%'");
		}
		// 开始时间
		sql.append(" and tmp.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and tmp.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t group by t.sub_id,t.project_info_no,t.project_name )tt "
				+ " left join comm_org_subjection sub on tt.sub_id=sub.org_subjection_id "
				+ " left join comm_org_information inf on sub.org_id=inf.org_id "
				+ " where tt.sub_id is not null order by tt.sub_id");
		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询项目设备维修费用信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevRepaCostList(ISrvMsg isrvmsg) throws Exception {
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
		String proNo = isrvmsg.getValue("proNo");// 项目编号
		String subId = isrvmsg.getValue("subId");// 所属单位
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
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
		StringBuilder sql = new StringBuilder(
				"select t.dev_coding,t.dev_name,t.dev_model,t.self_num,t.dev_sign,sum(t.repair_cost) as repair_cost from ( "
						+ " select * from ( ");
		sql.append(getProjRepairCostBasicSql());
		sql.append(" ) tmp where 1=1");
		// 项目号
		if(StringUtils.isNotBlank(proNo)){
			sql.append(" and tmp.project_info_no  = '"+proNo+"' ");
		}
		// 物探处
		if(StringUtils.isNotBlank(subId)){
			sql.append(" and tmp.sub_id  = '"+subId+"' ");
		}
		// 开始时间
		sql.append(" and tmp.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and tmp.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t group by t.dev_coding,t.dev_name,t.dev_model,t.self_num,t.dev_sign");
		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 获取维修项目图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairItemChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
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
		StringBuilder sql = new StringBuilder(
				"select tt.repair_item,tt.coding_name,tt.repair_cost,"
						+ " round(decode(sum(tt.repair_cost)over(),0,0,tt.repair_cost *100/sum(tt.repair_cost)over()),2) as repair_percent  from (" 
						+ " select t.repair_item,t.coding_name,sum(t.repair_cost) as repair_cost from ("
						+ " select ri.repair_item,det.coding_name,nvl(ri.human_cost, 0) + nvl(ri.material_cost, 0) repair_cost,"
						+ " case when dui.owning_sub_id like 'C105001%' then substr(dui.owning_sub_id,1,10)"
						+ " when dui.owning_sub_id like 'C105005%' then substr(dui.owning_sub_id,1,10)"
						+ " else substr(dui.owning_sub_id,1,7) end as sub_id,ri.repair_start_date"
						+ " from bgp_comm_device_repair_info ri"
						+ " left join comm_coding_sort_detail det on ri.repair_item = det.coding_code_id and det.bsflag='0' and det.coding_sort_id='5110000024'"
						+ " left join gms_device_account_dui dui on ri.device_account_id = dui.dev_acc_id and dui.bsflag = '0'"
						+ " where ri.datafrom is null and ri.project_info_no is not null"
						+ " union all"
						+ " select ri.repair_item,det.coding_name,nvl(ri.human_cost, 0) + nvl(ri.material_cost, 0) repair_cost,"
						+ " case when acc.owning_sub_id like 'C105001%' then substr(acc.owning_sub_id,1,10)"
						+ " when acc.owning_sub_id like 'C105005%' then substr(acc.owning_sub_id,1,10)"
						+ " else substr(acc.owning_sub_id,1,7) end as sub_id,ri.repair_start_date"
						+ " from bgp_comm_device_repair_info ri"
						+ " left join comm_coding_sort_detail det on ri.repair_item = det.coding_code_id and det.bsflag='0' and det.coding_sort_id='5110000024'"
						+ " left join gms_device_account acc on ri.dev_code=acc.dev_acc_id and acc.bsflag='0'"
						+ " where ri.datafrom ='SAP' or ( ri.datafrom is null and ri.project_info_no is null )) t where 1=1 ");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id = '"+orgSubId+"' ");
		}
		// 开始时间
		sql.append(" and t.repair_start_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and t.repair_start_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append("   group by t.repair_item,t.coding_name )tt ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		String tSql = "select det.coding_code_id as repair_item,det.coding_name as label,'0' as value "
				+ "from comm_coding_sort_detail det where det.bsflag='0' and det.coding_sort_id = '5110000024' order by det.coding_code";
		List<Map> tlist = jdbcDao.queryRecords(tSql);
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// 构造数据
		for (Map tmap:tlist) {
			Element set = root.addElement("set");
			set.addAttribute("label", tmap.get("label").toString());
			String value = tmap.get("value").toString();
			String toolValue="0";
			if(CollectionUtils.isNotEmpty(list)){
				for(Map map:list){
					if(map.get("repair_item").toString().equals(tmap.get("repair_item").toString())) {
						if(null!=map.get("repair_percent") && StringUtils.isNotBlank(map.get("repair_percent").toString())){
							value = map.get("repair_percent").toString();
							toolValue=map.get("repair_cost").toString();
							list.remove(map);
							break;
						}
					}
				}
			}
			set.addAttribute("value", value);
			set.addAttribute("displayValue", tmap.get("label").toString()+","+value+"%");
			set.addAttribute("toolText", tmap.get("label").toString()+","+toolValue);
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 获取维修类别图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairTypeChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
		// 级别(默认为第一级)
		String level = isrvmsg.getValue("level");
		String project_id=isrvmsg.getValue("project_id");
		DecimalFormat df = new DecimalFormat("#.00");
		String value = "0";
		double costValue = 0;
		String costValueFormat = "";
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//截取长度(编码规则是每级编码长度加3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree编码(默认为空，级别为第一级)
		String devTreeId = isrvmsg.getValue("devTreeId");
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// 国内国外
		String country = isrvmsg.getValue("country");
		String vcountry="";
		if(StringUtils.isBlank(country)){
			country="";
		}else{
			if("1".equals(country)){
				vcountry="国内";
			}
			if("2".equals(country)){
				vcountry="国外";			
			}
		}
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
		String sql1="select tmp.*, d.device_name, d.device_type from(select substr(dt.dev_tree_id, 1, "+subStrLength+") as dev_tree_id,"
				   + " nvl(sum(t.repair_cost), 0) as repair_cost from dms_device_tree dt"
				   + " left join (select * from (select nvl(ri.human_cost, 0) + nvl(ri.material_cost, 0) as repair_cost,"
				   + " case when ri.repair_level = '605' then 'baoyang' else 'weixiu' end as repair_type,"
				   + " ri.repair_start_date as repair_date, 'xcwx' data_type, dui.dev_type, acc.ifcountry,"
				   + " dui.dev_name, dui.dev_model, dui.self_num, dui.license_num, dui.dev_sign,"
				   + " nvl(dui.asset_value, 0) as asset_value, nvl(dui.net_value, 0) as net_value,"
				   + " ri.project_info_no, case when dui.owning_sub_id like 'C105001%' then substr(dui.owning_sub_id, 1, 10)"
				   + " when dui.owning_sub_id like 'C105005%' then substr(dui.owning_sub_id, 1, 10)"
				   + " else substr(dui.owning_sub_id, 1, 7) end as sub_id"
				   + " from bgp_comm_device_repair_info ri"
				   + " left join gms_device_account_dui dui on ri.device_account_id = dui.dev_acc_id and dui.bsflag = '0'"
				   + " left join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag = '0'"
				   + " where ri.bsflag = '0' and ri.datafrom is null and ri.project_info_no ='"+project_id+"'"
				   + " and repair_start_date >= to_date('"+_startDate+"', 'yyyy-mm-dd')"
				   + "　and repair_start_date <= to_date('"+_endDate+"', 'yyyy-mm-dd')) )t on dt.device_code = t.dev_type"
				   + " where dt.bsflag = '0' and dt.device_code is not null"
				   + " and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%')" ;
		// tree编码
				if(StringUtils.isNotBlank(devTreeId)){
				sql1+=(" and dt.dev_tree_id like '" + devTreeId + "%' and dt.dev_tree_id <> '" + devTreeId + "'");
				}
				sql1+=" group by substr(dt.dev_tree_id, 1, "+subStrLength+")) tmp left join dms_device_tree d on tmp.dev_tree_id = d.dev_tree_id order by d.code_order ";
		StringBuilder sql = new StringBuilder();
		sql.append("select tmp.*, d.device_name, d.device_type"
				+ " from (select substr(dt.dev_tree_id, 1, "+subStrLength+") as dev_tree_id,"
				+ " nvl(sum(t.repair_cost),0) as repair_cost"
				+ " from dms_device_tree dt"
				+ " left join ( select * from ( ");
		sql.append(getRepairAnalBasicSql());
		sql.append(" ) tmp0 where 1=1");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp0.sub_id like '"+orgSubId+"%'");
		}
		// 国内国外
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and tmp0.ifcountry='"+vcountry+"'");
		}
		// 开始时间
		sql.append(" and tmp0.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and tmp0.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t on dt.device_code = t.dev_type where dt.bsflag = '0' and dt.device_code is not null");
		sql.append(" and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%')");
		// tree编码
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%' and dt.dev_tree_id <> '" + devTreeId + "'");
		}
		sql.append("  group by substr(dt.dev_tree_id, 1, "+subStrLength+")) tmp left join dms_device_tree d on tmp.dev_tree_id = d.dev_tree_id order by d.code_order");
		if(StringUtils.isNotBlank(project_id)&&!"null".equals(project_id)){
		sql=new StringBuilder(sql1);	
		} 
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
		root.addAttribute("numberScaleUnit", "万元");
		root.addAttribute("yAxisName", "(单位：万元)");
		
		int cLevel=Integer.parseInt(level);//当前钻取级别
		int nLevel=cLevel+1;//下一钻取级别
		// 构造数据
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
		    	costValueFormat="0";
				Element set = root.addElement("set");
				String cdevTreeId=map.get("dev_tree_id").toString();//当前dev_tree_id编码
				
				set.addAttribute("label", map.get("device_name").toString());
				if(null!=map.get("repair_cost") && !"0".equals(map.get("repair_cost").toString())){
					value=map.get("repair_cost").toString();
					costValue = Double.parseDouble(value)/10000;
					costValueFormat = df.format(costValue);
					//可控震源,钻机,运输设备,最后显示详细信息
					if(cdevTreeId.startsWith("D002")||cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
						// 运输设备 爆破器材运输车,直接展现列表数据
						if(cdevTreeId.startsWith("D004003")){
							set.addAttribute("link", "JavaScript:popRepairTypeList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextRepairType('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}else{
								set.addAttribute("link", "JavaScript:popRepairTypeList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}
						}
					}
					//推土机子类型只钻取到一级
					if(cdevTreeId.startsWith("D006")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popRepairTypeList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
						}
					}
				}
				set.addAttribute("value", costValueFormat );
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 获取维修费用率图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairCostRateChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
		// 级别(默认为第一级)
		String level = isrvmsg.getValue("level");
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//截取长度(编码规则是每级编码长度加3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree编码(默认为空，级别为第一级)
		String devTreeId = isrvmsg.getValue("devTreeId");
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// 国内国外
		String country = isrvmsg.getValue("country");
		String vcountry="";
		if(StringUtils.isBlank(country)){
			country="";
		}else{
			if("1".equals(country)){
				vcountry="国内";
			}
			if("2".equals(country)){
				vcountry="国外";			
			}
		}
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
		StringBuilder sql = new StringBuilder();
		sql.append("select tmp.*, d.device_name, d.device_type"
				+ " from (select substr(dt.dev_tree_id, 1, "+subStrLength+") as dev_tree_id,"
				+ " round(nvl(decode(sum(t.asset_value),0,0,sum(t.repair_cost)*100 / sum(t.asset_value)),0),2) as repair_cost_rate"
				+ " from dms_device_tree dt"
				+ " left join ( select * from ( ");
		sql.append(getRepairAnalBasicSql());
		sql.append(" ) tmp0 where 1=1");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp0.sub_id like '"+orgSubId+"%'");
		}
		// 国内国外
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and tmp0.ifcountry='"+vcountry+"'");
		}
		// 开始时间
		sql.append(" and tmp0.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and tmp0.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t on dt.device_code = t.dev_type where dt.bsflag = '0' and dt.device_code is not null");
		sql.append(" and ( dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%')");
		// tree编码
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%' and dt.dev_tree_id <> '" + devTreeId + "'");
		}
		sql.append("  group by substr(dt.dev_tree_id, 1, "+subStrLength+")) tmp left join dms_device_tree d on tmp.dev_tree_id = d.dev_tree_id order by d.code_order");
		System.out.println("sql:"+sql);
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		int cLevel=Integer.parseInt(level);//当前钻取级别
		int nLevel=cLevel+1;//下一钻取级别
		// 构造数据
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String cdevTreeId=map.get("dev_tree_id").toString();//当前dev_tree_id编码
				String value = "0";
				set.addAttribute("label", map.get("device_name").toString());
				if(null!=map.get("repair_cost_rate") && !"0".equals(map.get("repair_cost_rate").toString())){
					value=map.get("repair_cost_rate").toString();
					//可控震源,钻机,运输设备,最后显示详细信息
					if(cdevTreeId.startsWith("D002")||cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
						// 运输设备 爆破器材运输车,直接展现列表数据
						if(cdevTreeId.startsWith("D004003")){
							set.addAttribute("link", "JavaScript:popRepairCostRateList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextRepairCostRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}else{
								set.addAttribute("link", "JavaScript:popRepairCostRateList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}
						}
					}
					//推土机子类型只钻取到一级
					if(cdevTreeId.startsWith("D006")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popRepairCostRateList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
						}
					}
				}
				set.addAttribute("value", value);
				set.addAttribute("displayValue", value+"%");
				set.addAttribute("toolText", map.get("device_name").toString()+","+value+"%");
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 查询维修类型信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRepairTypeList(ISrvMsg isrvmsg) throws Exception {
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
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
		String devTreeId = isrvmsg.getValue("devTreeId");//  tree编码
		String orgSubId = isrvmsg.getValue("orgSubId");// 物探处
		String country = isrvmsg.getValue("country");// 国内/国外
		String project_id=isrvmsg.getValue("project_id");
		String vcountry="";
		if(StringUtils.isNotBlank(country)){
			if("1".equals(country)){
				vcountry="国内";
			}
			if("2".equals(country)){
				vcountry="国外";			
			}
		}
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
		String sql1="select t.dev_name, t.dev_model, t.self_num, t.license_num, t.dev_sign,"
				   + " sum(repair_cost) as repair_cost from dms_device_tree dt"
				   + " inner join(select * from (select nvl(ri.human_cost, 0) + nvl(ri.material_cost, 0) as repair_cost,"
				   + " case when ri.repair_level = '605' then 'baoyang' else 'weixiu' end as repair_type,"
				   + " ri.repair_start_date as repair_date, 'xcwx' data_type, dui.dev_type, acc.ifcountry,"
				   + " dui.dev_name, dui.dev_model, dui.self_num, dui.license_num, dui.dev_sign,"
				   + " nvl(dui.asset_value, 0) as asset_value, nvl(dui.net_value, 0) as net_value, ri.project_info_no,"
				   + " case when dui.owning_sub_id like 'C105001%' then substr(dui.owning_sub_id, 1, 10)"
				   + " when dui.owning_sub_id like 'C105005%' then substr(dui.owning_sub_id, 1, 10)"
				   + " else substr(dui.owning_sub_id, 1, 7) end as sub_id from bgp_comm_device_repair_info ri"
				   + " left join gms_device_account_dui dui on ri.device_account_id = dui.dev_acc_id and dui.bsflag = '0'"
				   + " left join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag = '0'"
				   + " where ri.bsflag = '0' and ri.datafrom is null and ri.project_info_no ='"+project_id+"') tmp0"
				   + " where 1 = 1 and tmp0.repair_date >= to_date('"+startDate+"', 'yyyy-mm-dd')"
				   + " and tmp0.repair_date <= to_date('"+endDate+"', 'yyyy-mm-dd')) t on dt.device_code = t.dev_type"
				   + " where dt.bsflag = '0' and dt.device_code is not null " ;
		// tree编码
				if(StringUtils.isNotBlank(devTreeId)){
					sql1+=" and dt.dev_tree_id like '" + devTreeId + "%'";
				}
				sql1+=	" group by t.dev_name, t.dev_model, t.self_num, t.license_num, t.dev_sign order by t.self_num, t.license_num";
		StringBuilder sql = new StringBuilder();
		sql.append("select t.dev_name,t.dev_model,t.self_num,t.license_num,t.dev_sign,sum(repair_cost) as repair_cost "
				+ " from dms_device_tree dt "
		        + " inner join ( select * from ( ");
		sql.append(getRepairAnalBasicSql());
		sql.append(" ) tmp0 where 1=1");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp0.sub_id like '"+orgSubId+"%'");
		}
		// 国内国外
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and tmp0.ifcountry='"+vcountry+"'");
		}
		// 开始时间
		sql.append(" and tmp0.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and tmp0.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t on dt.device_code = t.dev_type where dt.bsflag = '0' and dt.device_code is not null ");
		// tree编码
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%'");
		}
		sql.append(" group by t.dev_name,t.dev_model,t.self_num,t.license_num,t.dev_sign");
		sql.append(" order by t.self_num,t.license_num ");
		if(StringUtils.isNotBlank(project_id)&&!"null".equals(project_id)){
			sql=new StringBuilder(sql1);
		}
		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询维修费用率信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRepairCostRateList(ISrvMsg isrvmsg) throws Exception {
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
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
		String devTreeId = isrvmsg.getValue("devTreeId");//  tree编码
		String orgSubId = isrvmsg.getValue("orgSubId");// 物探处
		String country = isrvmsg.getValue("country");// 国内/国外
		String vcountry="";
		if(StringUtils.isNotBlank(country)){
			if("1".equals(country)){
				vcountry="国内";
			}
			if("2".equals(country)){
				vcountry="国外";			
			}
		}
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
		StringBuilder sql = new StringBuilder();
		sql.append("select t.dev_name,t.dev_model,t.self_num,t.dev_sign,sum(asset_value) as asset_value,sum(repair_cost) as repair_cost, "
				+ " round(nvl(decode(sum(t.asset_value),0,0,sum(t.repair_cost)*100 /sum(t.asset_value)),0),3) as repair_cost_rate "
				+ " from dms_device_tree dt "
				+ " inner join ( select * from ( ");
		sql.append(getRepairAnalBasicSql());
		sql.append(" ) tmp0 where 1=1");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp0.sub_id like '"+orgSubId+"%'");
		}
		// 国内国外
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and tmp0.ifcountry='"+vcountry+"'");
		}
		// 开始时间
		sql.append(" and tmp0.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and tmp0.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t on dt.device_code = t.dev_type where dt.bsflag = '0' and dt.device_code is not null ");
		// tree编码
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%'");
		}
		sql.append(" group by t.dev_name,t.dev_model,t.self_num,t.dev_sign");
		sql.append(" order by t.self_num ");
		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 获取设备费用率利润率图表数据(公司级别)
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeviceCostProfitRateChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String amountYear = isrvmsg.getValue("amountYear");//年度
		if(StringUtils.isBlank(amountYear)){
			amountYear="";
		}
		String analType = isrvmsg.getValue("analType");//统计分析类别
		if(StringUtils.isBlank(analType)){
			analType="";
		}
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		String cSql = " select sum(case when ben.amount_type = '1' then ben.amount end) as income_amount,"
						+ " sum(case when ben.amount_type = '2' then ben.amount end) as cost_amount,"
						+ " sum(case when ben.amount_type = '1' then ben.amount end)-nvl(sum(case when ben.amount_type = '2' then ben.amount end),0) as profit_amount,"
						+ " ben.sub_org_id as sub_id from dms_device_benefit ben where ben.bsflag = '0' ";
		String rSql = getRepairAnalBasicSql();
		//东方公司
		StringBuilder sql1 = new StringBuilder();
		//物探处
		StringBuilder sql2 = new StringBuilder();
		//收入比
		if("cost".equals(analType)){
			sql1.append("select oi.org_abbreviation as org_name,t.sub_id,t.income_amount,t2.repair_cost,round(decode(nvl(t.income_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.income_amount,0)),2) as rate from ( ");
		}else{//利润比
			sql1.append("select oi.org_abbreviation as org_name,t.sub_id,t.profit_amount,t2.repair_cost,round(decode(nvl(t.profit_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.profit_amount,0)),2) as rate from ( ");
		}
		sql1.append(cSql);
		sql1.append(" and ben.level_type='1' ");
		// 年度
		if (StringUtils.isNotBlank(amountYear)) {
			sql1.append(" and ben.amount_year='" + amountYear + "' ");
		}
		sql1.append(" and ben.sub_org_id='"+orgSubId+"' ");
		sql1.append(" group by ben.sub_org_id ) t");
		sql1.append(" left join ( select '"+orgSubId+"' as sub_id,sum(t1.repair_cost) as repair_cost from ( ");
		sql1.append(rSql);
		sql1.append(" ) t1 ");
		if (StringUtils.isNotBlank(amountYear)) {
			sql1.append(" where to_char(t1.repair_date,'yyyy')='" + amountYear + "' ");
		}
		sql1.append(" ) t2 on t.sub_id=t2.sub_id ");
		sql1.append(" left join comm_org_subjection sub on t.sub_id=sub.org_subjection_id and  sub.bsflag='0'");
		sql1.append(" left join comm_org_information oi on sub.org_id=oi.org_id and oi.bsflag='0' order by rate,sub.coding_show_id desc");
		//物探处
		if("cost".equals(analType)){
			sql2.append("select oi.org_abbreviation as org_name,t.sub_id,t.income_amount,t2.repair_cost,round(decode(nvl(t.income_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.income_amount,0)),2) as rate from ( ");
		}else{//利润比
			sql2.append("select oi.org_abbreviation as org_name,t.sub_id,t.profit_amount,t2.repair_cost,round(decode(nvl(t.profit_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.profit_amount,0)),2) as rate from ( ");
		}
		sql2.append(cSql);
		sql2.append(" and ben.level_type='2' ");
		// 年度
		if (StringUtils.isNotBlank(amountYear)) {
			sql2.append(" and ben.amount_year='" + amountYear + "' ");
		}
		sql2.append(" group by ben.sub_org_id ) t");
		sql2.append(" left join (select t1.sub_id as sub_id,sum(t1.repair_cost) as repair_cost from ( ");
		sql2.append(rSql);
		sql2.append(" ) t1 ");
		if (StringUtils.isNotBlank(amountYear)) {
			sql2.append(" where to_char(t1.repair_date,'yyyy')='" + amountYear + "' ");
		}
		sql2.append(" group by t1.sub_id) t2 on t.sub_id=t2.sub_id ");
		sql2.append(" left join comm_org_subjection sub on t.sub_id=sub.org_subjection_id and  sub.bsflag='0'");
		sql2.append(" left join comm_org_information oi on sub.org_id=oi.org_id and oi.bsflag='0' order by rate,sub.coding_show_id desc");
		List<Map> list1 = jdbcDao.queryRecords(sql1.toString());
		List<Map> list2 = jdbcDao.queryRecords(sql2.toString());
		List<Map> list =new ArrayList<Map>();
		if(CollectionUtils.isNotEmpty(list1)){
			list.addAll(list1);
		}
		if(CollectionUtils.isNotEmpty(list2)){
			list.addAll(list2);
		}
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		String[] org_names = {"研究院","信息技术中心","物探技术研究中心"};
		// 构造数据
	    if (CollectionUtils.isNotEmpty(list)) {
	    	for(Map map:list){
				
				if(!inStr(org_names, map.get("org_name").toString())){
					Element set = root.addElement("set");
					String value="0";
					if(null!=map.get("rate")){
						value=map.get("rate").toString();
					}
					set.addAttribute("label", map.get("org_name").toString());
					set.addAttribute("value", value);
					set.addAttribute("displayValue", value+"%");
					set.addAttribute("toolText", map.get("org_name").toString()+","+value+"%");
					if(!"0".equals(value)){
						String _orgSubId=map.get("sub_id").toString();
						if(!"C105".equals(_orgSubId)){
							set.addAttribute("link", "JavaScript:popWuTanCostProfitRate('"+amountYear+"','"+analType+"','"+_orgSubId+"')");
						}
					}
				}
				
	    	}
	    }
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	private boolean inStr(String[] strs,String s){
		for (int i = 0; i < strs.length; i++) {
			if(s.equals(strs[i])){
				return true;
			}
		}
		return false;
	}
	/**
	 * 获取设备费用率利润率图表数据(物探处级别)
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getWuTanCostProfitRateChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String amountYear = isrvmsg.getValue("amountYear");//年度
		if(StringUtils.isBlank(amountYear)){
			amountYear="";
		}
		String analType = isrvmsg.getValue("analType");//统计分析类别
		if(StringUtils.isBlank(analType)){
			analType="";
		}
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		String cSql = " select sum(case when ben.amount_type = '1' then ben.amount end) as income_amount,"
						+ " sum(case when ben.amount_type = '2' then ben.amount end) as cost_amount,"
						+ " sum(case when ben.amount_type = '1' then ben.amount end)-nvl(sum(case when ben.amount_type = '2' then ben.amount end),0) as profit_amount,"
						+ " ben.sub_org_id as sub_id from dms_device_benefit ben where ben.bsflag = '0' ";
		String rSql = getRepairAnalBasicSql();
		//物探处
		StringBuilder sql1 = new StringBuilder();
		//项目
		StringBuilder sql2 = new StringBuilder();
		//收入比
		if("cost".equals(analType)){
			sql1.append("select oi.org_abbreviation as label,t.sub_id as id,t.income_amount,t2.repair_cost,round(decode(nvl(t.income_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.income_amount,0)),2) as rate from ( ");
		}else{//利润比
			sql1.append("select oi.org_abbreviation as label,t.sub_id as id,t.profit_amount,t2.repair_cost,round(decode(nvl(t.profit_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.profit_amount,0)),2) as rate from ( ");
		}
		sql1.append(cSql);
		sql1.append(" and ben.level_type='2' ");
		// 年度
		if (StringUtils.isNotBlank(amountYear)) {
			sql1.append(" and ben.amount_year='" + amountYear + "' ");
		}
		sql1.append(" and ben.sub_org_id='"+orgSubId+"' ");
		sql1.append(" group by ben.sub_org_id ) t");
		sql1.append(" left join ( select t1.sub_id as sub_id,sum(t1.repair_cost) as repair_cost from ( ");
		sql1.append(rSql);
		sql1.append(" ) t1 ");
		if (StringUtils.isNotBlank(amountYear)) {
			sql1.append(" where to_char(t1.repair_date,'yyyy')='" + amountYear + "' ");
		}
		sql1.append(" and t1.sub_id='"+orgSubId+"' ");
		sql1.append(" group by t1.sub_id) t2 on t.sub_id=t2.sub_id ");
		sql1.append(" left join comm_org_subjection sub on t.sub_id=sub.org_subjection_id and  sub.bsflag='0'");
		sql1.append(" left join comm_org_information oi on sub.org_id=oi.org_id and oi.bsflag='0' order by sub.coding_show_id");
		//项目
		if("cost".equals(analType)){
			sql2.append("select pro.project_name as label,t.project_info_no as id,t.income_amount,t2.repair_cost,round(decode(nvl(t.income_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.income_amount,0)),2) as rate from ( ");
		}else{//利润比
			sql2.append("select pro.project_name as label,t.project_info_no as id,t.profit_amount,t2.repair_cost,round(decode(nvl(t.profit_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.profit_amount,0)),2) as rate from ( ");
		}
		sql2.append(" select sum(case when ben.amount_type = '1' then ben.amount end) as income_amount,"
				+ " sum(case when ben.amount_type = '2' then ben.amount end) as cost_amount,"
				+ " sum(case when ben.amount_type = '1' then ben.amount end)-nvl(sum(case when ben.amount_type = '2' then ben.amount end),0) as profit_amount,"
				+ " ben.project_info_no as project_info_no from dms_device_benefit ben where ben.bsflag = '0' and ben.level_type='3'");
		// 年度
		if (StringUtils.isNotBlank(amountYear)) {
			sql2.append(" and ben.amount_year='" + amountYear + "' ");
		}
		sql2.append(" and ben.sub_org_id='"+orgSubId+"' ");
		sql2.append(" group by ben.project_info_no ) t");
		sql2.append(" left join (select t1.project_info_no as project_info_no,sum(t1.repair_cost) as repair_cost from ( ");
		sql2.append(rSql);
		sql2.append(" ) t1 ");
		if (StringUtils.isNotBlank(amountYear)) {
			sql2.append(" where to_char(t1.repair_date,'yyyy')='" + amountYear + "' ");
		}
		sql2.append(" and t1.sub_id='"+orgSubId+"' ");
		sql2.append(" group by t1.project_info_no) t2 on t.project_info_no=t2.project_info_no ");
		sql2.append(" left join gp_task_project pro on t.project_info_no=pro.project_info_no ");
		
		List<Map> list1 = jdbcDao.queryRecords(sql1.toString());
		List<Map> list2 = jdbcDao.queryRecords(sql2.toString());
		List<Map> list =new ArrayList<Map>();
		if(CollectionUtils.isNotEmpty(list1)){
			list.addAll(list1);
		}
		if(CollectionUtils.isNotEmpty(list2)){
			list.addAll(list2);
		}
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		// 构造数据
	    if (CollectionUtils.isNotEmpty(list)) {
	    	for(Map map:list){
				Element set = root.addElement("set");
				String value="0";
				if(null!=map.get("rate")){
					value=map.get("rate").toString();
				}
				set.addAttribute("label", map.get("label").toString());
				set.addAttribute("value", value);
				set.addAttribute("displayValue", value+"%");
				set.addAttribute("toolText", map.get("label").toString()+","+value+"%");
	    	}
	    }
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 获取备件统计基本sql
	 * @return  
	 */
	public String getSpareAnalBasicSql(){
		String sql = " select inf.coding_code_id as mat_code, inf.wz_name as mat_name, rd.material_coding wz_id, nvl(rd.material_amout, 0) as mat_num, nvl(rd.unit_price, 0) as mat_price, nvl(rd.total_charge, 0) as mat_money, ri.repair_start_date as mat_date, case when dui.owning_sub_id like 'C105001%' then substr(dui.owning_sub_id, 1, 10) when dui.owning_sub_id like 'C105005%' then substr(dui.owning_sub_id, 1, 10) else substr(dui.owning_sub_id, 1, 7) end as sub_id from bgp_comm_device_repair_info ri left join bgp_comm_device_repair_detail rd on ri.repair_info = rd.repair_info and rd.bsflag = '0' left join gms_mat_infomation inf on inf.wz_id = rd.material_coding and inf.bsflag = '0' left join gms_device_account_dui dui on ri.device_account_id = dui.dev_acc_id and dui.bsflag = '0' where ri.bsflag = '0' and ri.datafrom is null and ri.project_info_no is not null union all select rd.material_type as mat_code, rd.material_name as mat_name, rd.material_coding, nvl(rd.material_amout, 0) as mat_num, nvl(rd.unit_price, 0) as mat_price, nvl(rd.total_charge, 0) as mat_money, ri.repair_start_date as mat_date, case when acc.owning_sub_id like 'C105001%' then substr(acc.owning_sub_id, 1, 10) when acc.owning_sub_id like 'C105005%' then substr(acc.owning_sub_id, 1, 10) else substr(acc.owning_sub_id, 1, 7) end as sub_id from bgp_comm_device_repair_info ri left join bgp_comm_device_repair_detail rd on ri.repair_info = rd.repair_info and rd.bsflag = '0' left join gms_device_account acc on ri.dev_code = acc.dev_acc_id and acc.bsflag = '0' where ri.bsflag = '0' and(ri.datafrom = 'SAP' or (ri.datafrom is null and ri.project_info_no is null)) union all select inf.coding_code_id as mat_code, inf.wz_name as mat_name, m.wz_id, nvl(m.use_num, 0) as mat_num, nvl(r.actual_price, 0) as mat_price, nvl(m.use_num, 0) * nvl(r.actual_price, 0) as mat_money, t.bywx_date as mat_date, t.org_subjection_id as sub_id from gms_device_zy_bywx t left join gms_device_zy_wxbymat m on t.usemat_id = m.usemat_id left join gms_mat_recyclemat_info r on r.wz_id = m.wz_id left join gms_mat_infomation inf on r.wz_id = inf.wz_id where t.project_info_id is null and r.wz_type = '3' and r.bsflag = '0' and r.project_info_id is null and t.bsflag = '0' union all select inf.coding_code_id as mat_code, inf.wz_name as mat_name, m.wz_id, nvl(m.use_num, 0) as mat_num, nvl(r.actual_price, 0) as mat_price, nvl(m.use_num, 0) * nvl(r.actual_price, 0) as mat_money, t.bywx_date as mat_date, t.org_subjection_id as sub_id from gms_device_zy_bywx t left join gms_device_zy_wxbymat m on t.usemat_id = m.usemat_id left join gms_mat_recyclemat_info r on r.wz_id = m.wz_id left join gms_mat_infomation inf on r.wz_id = inf.wz_id where t.bsflag = '0' and r.project_info_id = t.project_info_id ";
		return sql;
	}
	
	/**
	 * 获取备件消耗统计图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSpareConsStatChartDataYear(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
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
		StringBuilder sql = new StringBuilder(
				"select tt.mat_type,sum(tt.mat_money) as mat_money, to_char(tt.mat_date, 'fmmm') mon from ("
						+ " select case when t.mat_code like '07%' or t.mat_code ='17990414' or t.mat_code ='17990501' then 1"
						+ " when t.mat_code like '1402%' then 2"
						+ " when t.mat_code ='22060201' then 3"
						+ " when t.mat_code like '28%' then 4"
						+ " when t.mat_code like '29%' and t.mat_code not in('29990206','29990207','29990212','29990219') then 5"
						+ " when t.mat_code in ('35010201','35010202','35010203','35810101') then 6"
						+ " when t.mat_code like '37%' then 7"
						+ " when t.mat_code in ('38140112','38158102') then 8"
						+ " when t.mat_code like '43%' then 9"
						+ " when t.mat_code like '48%' then 10"
						+ " when t.mat_code like '51%' then 11"
						+ " when t.mat_code like '54%' then 12"
						+ " when t.mat_code like '55%' then 13"
						+ " when t.mat_code like '56%' then 14"
						+ " when t.mat_code in ('57210101','57210102','57210103','57210104','57210105','57210106') then 15"
						+ " end as mat_type,t.mat_money,  t.mat_date from (");
		sql.append(getSpareAnalBasicSql());
		sql.append(" ) t where 1=1 ");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id like '"+orgSubId+"%' ");
		}
		// 开始时间
		sql.append(" and t.mat_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and t.mat_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append("   )tt group by tt.mat_type,to_char(tt.mat_date, 'fmmm')  order by mat_type,to_number(mon) ");
		System.out.println("sql = " + sql.toString());
		
		List<String> mat_typeIndexList = new ArrayList<String>();
		for (int i = 1; i < 16; i++) {
			mat_typeIndexList.add(i + "");
		}
		List<String> mat_typeList = new ArrayList<String>();
		List<Map> appendList = new ArrayList<Map>();
		List<Map> resultList = new ArrayList<Map>();
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		
		for (Iterator iterator = list.iterator(); iterator.hasNext();) {
			Map map = (Map) iterator.next();
			String mat_type = map.get("mat_type").toString();
			mat_typeList.add(mat_type);
		}
		for (Iterator iterator = mat_typeIndexList.iterator(); iterator.hasNext();) {
			String index = (String) iterator.next();
			if(!mat_typeList.contains(index)){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("mat_type", index);
				map.put("mat_money", new Double(0));
				appendList.add(map);
			}
		}
		resultList.addAll(list);
		resultList.addAll(appendList);
		System.out.println("resultList size=" + resultList.size());
 		List<Map> tList =new ArrayList<Map>();
 		Map<String,Integer> dev_names=new HashMap<String, Integer>();
		for(int i=1;i<=15;i++){
			Map map=new HashMap();
			map.put("mat_type", i);
			map.put("mat_money", 0);
			//String[] array1 = {i+"","石油及产品"};
			if(i==1){
				map.put("mat_name", "石油及产品");
			}
			
			//String[] array2 = {i+"","轮胎"};
			if(i==2){
				map.put("mat_name", "轮胎");
			}
			
			//String[] array3 = {i+"","石油专用设备"};
			if(i==3){
				map.put("mat_name", "石油专用设备");
			}
			
			//String[] array4 = {i+"","动力设备"};
			if(i==4){
				map.put("mat_name", "动力设备");
			}
			
			//String[] array5 = {i+"","交通运输设备"};
			if(i==5){
				map.put("mat_name", "交通运输设备");
			}
			
			String[] array6 = {i+"","通信设备"};
			if(i==6){
				map.put("mat_name", "通信设备");
			}
			
			//String[] array7 = {i+"","石油专用仪器、仪表"};
			if(i==7){
				map.put("mat_name", "石油专用仪器、仪表");
			}
			
			//String[] array8 = {i+"","通用仪器、仪表"};
			if(i==8){
				map.put("mat_name", "通用仪器、仪表");
			}
			
			//String[] array9 = {i+"","轴承"};
			if(i==9){
				map.put("mat_name", "轴承");
			}
			
			//String[] array10 = {i+"","石油钻采设备配件"};
			if(i==10){
				map.put("mat_name", "石油钻采设备配件");
			}
			
			//String[] array11 = {i+"","工矿配件"};
			if(i==11){
				map.put("mat_name", "工矿配件");
			}
			
			//String[] array12 = {i+"","内燃机及拖拉机配件"};
			if(i==12){
				map.put("mat_name", "内燃机及拖拉机配件");
			}
			
			//String[] array13 = {i+"","重型汽车配件"};
			if(i==13){
				map.put("mat_name", "重型汽车配件");
			}
			
			//String[] array14 = {i+"","一般汽车及摩托车配件"};
			if(i==14){
				map.put("mat_name", "一般汽车及摩托车配件");
			}
			
			//String[] array15 = {i+"","地震勘探船配件"};
			if(i==15){
				map.put("mat_name", "地震勘探船配件");
			}
			dev_names.put((String)map.get("mat_name"), i);
			tList.add(map);
		}
		
		// 构造xml数据
				Document document = DocumentHelper.createDocument();
				Element root = document.addElement("chart");
				DecimalFormat df = new DecimalFormat("0.00");
				
				root.addAttribute("bgColor", "F3F5F4,DEE6EB");
				root.addAttribute("showValues", "1");
				root.addAttribute("decimals", "2");
				root.addAttribute("formatNumberScale", "0");
				root.addAttribute("palette", "4");
				root.addAttribute("baseFontSize", "12");
				root.addAttribute("yAxisName", "(单位：元)");
				Element categories=root.addElement("categories");
				
				for(int i=1;i<=12;i++){
					Element category = categories.addElement("category");
					category.addAttribute("label", String.valueOf(i));
				}
				
				for(Map.Entry<String,Integer> entry: dev_names.entrySet()) {
					String mat_type=String.valueOf(entry.getValue());
					Element dataset=root.addElement("dataset");
					dataset.addAttribute("seriesName", entry.getKey());
					dataset.addAttribute("color", getRandColorCode());
					
					List<Map> listtemp=new ArrayList<Map>();
					for (Map tmap1:list) {
					if(mat_type.equals(tmap1.get("mat_type"))){
						listtemp.add(tmap1);
					}	
					}
					
					for (Map object : listtemp) {
						
						Element tset = dataset.addElement("set");
						tset.addAttribute("value", String.valueOf(object.get("mat_money")));
						tset.addAttribute("link", "JavaScript:refreshData('"+object.get("mat_type")+"')");
						tset.addAttribute("showValue","0");
					}	
					 	 
					} 
				 
 
		 
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * 获取备件消耗统计图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSpareConsStatChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
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
		StringBuilder sql = new StringBuilder(
				"select tt.mat_type,sum(tt.mat_money) as mat_money from ("
						+ " select case when t.mat_code like '07%' or t.mat_code ='17990414' or t.mat_code ='17990501' then 1"
						+ " when t.mat_code like '1402%' then 2"
						+ " when t.mat_code ='22060201' then 3"
						+ " when t.mat_code like '28%' then 4"
						+ " when t.mat_code like '29%' and t.mat_code not in('29990206','29990207','29990212','29990219') then 5"
						+ " when t.mat_code in ('35010201','35010202','35010203','35810101') then 6"
						+ " when t.mat_code like '37%' then 7"
						+ " when t.mat_code in ('38140112','38158102') then 8"
						+ " when t.mat_code like '43%' then 9"
						+ " when t.mat_code like '48%' then 10"
						+ " when t.mat_code like '51%' then 11"
						+ " when t.mat_code like '54%' then 12"
						+ " when t.mat_code like '55%' then 13"
						+ " when t.mat_code like '56%' then 14"
						+ " when t.mat_code in ('57210101','57210102','57210103','57210104','57210105','57210106') then 15"
						+ " end as mat_type,t.mat_money from (");
		sql.append(getSpareAnalBasicSql());
		sql.append(" ) t where 1=1 ");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id like '"+orgSubId+"%' ");
		}
		// 开始时间
		sql.append(" and t.mat_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and t.mat_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append("   )tt group by tt.mat_type order by mat_money, tt.mat_type desc");
		System.out.println("sql = " + sql.toString());
		
		List<String> mat_typeIndexList = new ArrayList<String>();
		for (int i = 1; i < 16; i++) {
			mat_typeIndexList.add(i + "");
		}
		List<String> mat_typeList = new ArrayList<String>();
		List<Map> appendList = new ArrayList<Map>();
		List<Map> resultList = new ArrayList<Map>();
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		
		for (Iterator iterator = list.iterator(); iterator.hasNext();) {
			Map map = (Map) iterator.next();
			String mat_type = map.get("mat_type").toString();
			mat_typeList.add(mat_type);
		}
		for (Iterator iterator = mat_typeIndexList.iterator(); iterator.hasNext();) {
			String index = (String) iterator.next();
			if(!mat_typeList.contains(index)){
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("mat_type", index);
				map.put("mat_money", new Double(0));
				appendList.add(map);
			}
		}
		resultList.addAll(list);
		resultList.addAll(appendList);
		System.out.println("resultList size=" + resultList.size());
 		List<Map> tList =new ArrayList<Map>();
		for(int i=1;i<=15;i++){
			Map map=new HashMap();
			map.put("mat_type", i);
			map.put("mat_money", 0);
			//String[] array1 = {i+"","石油及产品"};
			if(i==1){
				map.put("mat_name", "石油及产品");
			}
			
			//String[] array2 = {i+"","轮胎"};
			if(i==2){
				map.put("mat_name", "轮胎");
			}
			
			//String[] array3 = {i+"","石油专用设备"};
			if(i==3){
				map.put("mat_name", "石油专用设备");
			}
			
			//String[] array4 = {i+"","动力设备"};
			if(i==4){
				map.put("mat_name", "动力设备");
			}
			
			//String[] array5 = {i+"","交通运输设备"};
			if(i==5){
				map.put("mat_name", "交通运输设备");
			}
			
			String[] array6 = {i+"","通信设备"};
			if(i==6){
				map.put("mat_name", "通信设备");
			}
			
			//String[] array7 = {i+"","石油专用仪器、仪表"};
			if(i==7){
				map.put("mat_name", "石油专用仪器、仪表");
			}
			
			//String[] array8 = {i+"","通用仪器、仪表"};
			if(i==8){
				map.put("mat_name", "通用仪器、仪表");
			}
			
			//String[] array9 = {i+"","轴承"};
			if(i==9){
				map.put("mat_name", "轴承");
			}
			
			//String[] array10 = {i+"","石油钻采设备配件"};
			if(i==10){
				map.put("mat_name", "石油钻采设备配件");
			}
			
			//String[] array11 = {i+"","工矿配件"};
			if(i==11){
				map.put("mat_name", "工矿配件");
			}
			
			//String[] array12 = {i+"","内燃机及拖拉机配件"};
			if(i==12){
				map.put("mat_name", "内燃机及拖拉机配件");
			}
			
			//String[] array13 = {i+"","重型汽车配件"};
			if(i==13){
				map.put("mat_name", "重型汽车配件");
			}
			
			//String[] array14 = {i+"","一般汽车及摩托车配件"};
			if(i==14){
				map.put("mat_name", "一般汽车及摩托车配件");
			}
			
			//String[] array15 = {i+"","地震勘探船配件"};
			if(i==15){
				map.put("mat_name", "地震勘探船配件");
			}
			tList.add(map);
		}
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
//		// 构造数据
//		System.out.println("list size=" + resultList.size());
//		for (Iterator iterator = resultList.iterator(); iterator.hasNext();) {
//			Element set = root.addElement("set");
//			String value = null;
//			Map map = (Map) iterator.next();
//			String mat_type = map.get("mat_type").toString();
//			System.out.println("mat_type=" + mat_type);
//			if(mat_type!=null&&(!"".equals(mat_type))){
//				if(null!=map.get("mat_money") && StringUtils.isNotBlank(map.get("mat_money").toString())){
//					value = map.get("mat_money").toString();
//					//list.remove(map);
//					for (Iterator iterator2 = tList.iterator(); iterator2.hasNext();) {
//						Map tmap = (Map) iterator2.next();
//						String mat_name = tmap.get("mat_name").toString();
//						
//						if(mat_type.equals(tmap.get("mat_type").toString())){
//							set.addAttribute("label", mat_name);
//							set.addAttribute("value", value);
//							System.out.println("name=" + mat_name + "  value=" + value);
//							break;
//						}
//					}
//					
//				}
//			}
//			
//			if(!"0".equals(value)){
//				String matType=map.get("mat_type").toString();
//				if("1".equals(matType)||"2".equals(matType)||"3".equals(matType)||"5".equals(matType)||"6".equals(matType)||"8".equals(matType)||"15".equals(matType)){
//					set.addAttribute("link", "JavaScript:popSpareConsStatList('"+matType+"','"+orgSubId+"','"+_startDate+"','"+_endDate+"','list')");
//				}
//				if("4".equals(matType)){
//					set.addAttribute("link", "JavaScript:popCSpareConsStat('28','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
//				}
//				if("7".equals(matType)){
//					set.addAttribute("link", "JavaScript:popCSpareConsStat('37','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
//				}
//				if("9".equals(matType)){
//					set.addAttribute("link", "JavaScript:popCSpareConsStat('43','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
//				}
//				if("10".equals(matType)){
//					set.addAttribute("link", "JavaScript:popCSpareConsStat('48','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
//				}
//				if("11".equals(matType)){
//					set.addAttribute("link", "JavaScript:popCSpareConsStat('51','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
//				}
//				if("12".equals(matType)){
//					set.addAttribute("link", "JavaScript:popCSpareConsStat('54','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
//				}
//				if("13".equals(matType)){
//					set.addAttribute("link", "JavaScript:popCSpareConsStat('55','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
//				}
//				if("14".equals(matType)){
//					set.addAttribute("link", "JavaScript:popCSpareConsStat('56','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
//				}
//			}
//		}
		
		 for (Map tmap:tList) {
			Element set = root.addElement("set");
			set.addAttribute("label", tmap.get("mat_name").toString());
			String value = tmap.get("mat_money").toString();
			if(CollectionUtils.isNotEmpty(list)){
				for(Map map:list){
					if(null!=map.get("mat_type") && map.get("mat_type").toString().equals(tmap.get("mat_type").toString())) {
						if(null!=map.get("mat_money") && StringUtils.isNotBlank(map.get("mat_money").toString())){
							value = map.get("mat_money").toString();
							list.remove(map);
							break;
						}
					}
				}
			}
			set.addAttribute("value", value);
			if(!"0".equals(value)){
				String matType=tmap.get("mat_type").toString();
				if("1".equals(matType)||"2".equals(matType)||"3".equals(matType)||"5".equals(matType)||"6".equals(matType)||"8".equals(matType)||"15".equals(matType)){
					set.addAttribute("link", "JavaScript:popSpareConsStatList('"+matType+"','"+orgSubId+"','"+_startDate+"','"+_endDate+"','list')");
				}
				if("4".equals(matType)){
					set.addAttribute("link", "JavaScript:popCSpareConsStat('28','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
				}
				if("7".equals(matType)){
					set.addAttribute("link", "JavaScript:popCSpareConsStat('37','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
				}
				if("9".equals(matType)){
					set.addAttribute("link", "JavaScript:popCSpareConsStat('43','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
				}
				if("10".equals(matType)){
					set.addAttribute("link", "JavaScript:popCSpareConsStat('48','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
				}
				if("11".equals(matType)){
					set.addAttribute("link", "JavaScript:popCSpareConsStat('51','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
				}
				if("12".equals(matType)){
					set.addAttribute("link", "JavaScript:popCSpareConsStat('54','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
				}
				if("13".equals(matType)){
					set.addAttribute("link", "JavaScript:popCSpareConsStat('55','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
				}
				if("14".equals(matType)){
					set.addAttribute("link", "JavaScript:popCSpareConsStat('56','2','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
				}
			}
		} 
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * 获取子类型备件消耗统计图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCSpareConsStatChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// 级别
		String level = isrvmsg.getValue("level");
		//截取长度
		int subStrLength=Integer.parseInt(level)*2;
		//编码
		String matCode = isrvmsg.getValue("matCode");
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
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
		StringBuilder sql = new StringBuilder(
				"select tt.*,cc.code_name from ("
						+ " select substr(t.mat_code, 1, "+subStrLength+") as mat_code,sum(t.mat_money) as mat_money from (");
		sql.append(getSpareAnalBasicSql());
		sql.append(" ) t where 1=1 ");
		// 编码
		if(StringUtils.isNotBlank(matCode)){
			sql.append(" and t.mat_code like '"+matCode+"%'");
		}
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id like '"+orgSubId+"%' ");
		}
		// 开始时间
		sql.append(" and t.mat_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and t.mat_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" group by substr(t.mat_code, 1, "+subStrLength+")) tt ");
		sql.append(" left join gms_mat_coding_code cc on tt.mat_code=cc.coding_code_id and cc.bsflag='0' order by cc.coding_code_id");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		if(CollectionUtils.isNotEmpty(list)){
			// 构造数据
			for (Map map:list) {
				if(MapUtils.isNotEmpty(map)){
					Element set = root.addElement("set");
					set.addAttribute("label", map.get("code_name").toString());
					if(null!=map.get("mat_money") && !"0".equals(map.get("mat_money").toString())){
						set.addAttribute("value", map.get("mat_money").toString());
						String cMatCode=map.get("mat_code").toString();
						if(Integer.parseInt(level)<4){
							int nlevel=Integer.parseInt(level)+1;
							set.addAttribute("link", "JavaScript:popNextSpareConsStat('"+cMatCode+"','"+nlevel+"','"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
						}else{
							set.addAttribute("link", "JavaScript:popDSpareConsStatList('"+cMatCode+"','"+orgSubId+"','"+_startDate+"','"+_endDate+"','clist')");
						}
						
					}else{
						set.addAttribute("value", "0");
					}
				}
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 查询备件消耗统计信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg querySpareConsStatList(ISrvMsg isrvmsg) throws Exception {
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
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
		String matType = isrvmsg.getValue("matType");//  物资类别
		String orgSubId = isrvmsg.getValue("orgSubId");// 物探处
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
		StringBuilder sql = new StringBuilder(
				"select wz_id,t.mat_name,sum(t.mat_money) as total_mat_money from (");
				sql.append(getSpareAnalBasicSql());
				sql.append(" ) t where 1=1 ");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id like '"+orgSubId+"%' ");
		}
		// 开始时间
		sql.append(" and t.mat_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and t.mat_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		if("1".equals(matType)){
			sql.append(" and ( t.mat_code like '07%' or t.mat_code ='17990414' or t.mat_code ='17990501' )");
		}
		if("2".equals(matType)){
			sql.append(" and t.mat_code like '1402%'");
		}
		if("3".equals(matType)){
			sql.append(" and t.mat_code ='22060201'");
		}
		if("4".equals(matType)){
			sql.append(" and t.mat_code like '28%' ");
		}
		if("5".equals(matType)){
			sql.append(" and t.mat_code like '29%' and t.mat_code not in('29990206','29990207','29990212','29990219')");
		}
		if("6".equals(matType)){
			sql.append(" and t.mat_code in ('35010201','35010202','35010203','35810101')");
		}
		if("7".equals(matType)){
			sql.append(" and t.mat_code like '37%' ");
		}
		if("8".equals(matType)){
			sql.append(" and t.mat_code in ('38140112','38158102')");
		}
		if("9".equals(matType)){
			sql.append(" and t.mat_code like '43%' ");
		}
		if("10".equals(matType)){
			sql.append(" and t.mat_code like '48%' ");
		}
		if("11".equals(matType)){
			sql.append(" and t.mat_code like '51%' ");
		}
		if("12".equals(matType)){
			sql.append(" and t.mat_code like '54%' ");
		}
		if("13".equals(matType)){
			sql.append(" and t.mat_code like '55%' ");
		}
		if("14".equals(matType)){
			sql.append(" and t.mat_code like '56%' ");
		}
		if("15".equals(matType)){
			sql.append(" and t.mat_code in ('57210101','57210102','57210103','57210104','57210105','57210106')");
		}
		sql.append(" group by wz_id,t.mat_name order by wz_id ");
		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 查询备件消耗统计信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCSpareConsStatList(ISrvMsg isrvmsg) throws Exception {
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
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
		String matCode = isrvmsg.getValue("matCode");//  物资编码
		String orgSubId = isrvmsg.getValue("orgSubId");// 物探处
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
		StringBuilder sql = new StringBuilder(
				"select mat_code,wz_id,t.mat_name,sum(t.mat_money) as total_mat_money from (");
		sql.append(getSpareAnalBasicSql());
		sql.append(" ) t where 1=1 ");
		// 物资编码
		if(StringUtils.isNotBlank(matCode)){
			sql.append(" and t.mat_code ='"+matCode+"'");
		}
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id like '"+orgSubId+"%' ");
		}
		// 开始时间
		sql.append(" and t.mat_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and t.mat_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" group by wz_id,t.mat_name,mat_code order by mat_code, wz_id ");
		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 获取物资库存基本sql
	 * @return
	 */
	public String getMatBasicSql(){
		String sql = "select * from (select tmp1.org_subjection_id, tmp1.wz_id,tmp1.stock_amount,gmi.coding_code_id,gmi.wz_name,gmi.wz_prickie, tmp1.stock_place,gmi.wz_price,"
				+ " tmp1.stock_amount * gmi.wz_price as stock_money,'SAP' as data_source"
				+ " from (select dmsd.org_subjection_id,dmsd.wz_id,dmsd.stock_place,sum(nvl(dmsd.stock_amount, 0)) as stock_amount"
				+ " from dms_mat_stock_detail dmsd where dmsd.bsflag = '0' and dmsd.stock_date=( select max(tmpd.stock_date)"
				+ " from dms_mat_stock_detail tmpd where tmpd.bsflag='0' )" 
				+ " group by dmsd.org_subjection_id, dmsd.wz_id,dmsd.stock_place) tmp1"
				+ " inner join gms_mat_infomation gmi on tmp1.wz_id = gmi.wz_id and gmi.bsflag = '0'"
				+ " union all"
				+ " select tmp2.org_subjection_id,tmp2.wz_id,tmp2.stock_amount,gmi.coding_code_id,gmi.wz_name,gmi.wz_prickie, (select n.org_abbreviation"
				+ "	from comm_org_information n, comm_org_subjection n1"
				+ " where n1.org_id = n.org_id"
				+ " and n1.org_subjection_id=tmp2.org_subjection_id) stock_place,gmi.wz_price,"
				+ " tmp2.stock_amount * gmi.wz_price as stock_money,'XMGL' as data_source"
				+ " from (select gmri.org_subjection_id,gmri.wz_id,sum(nvl(gmri.stock_num, 0)) as stock_amount"
				+ " from gms_mat_recyclemat_info gmri where gmri.bsflag = '0' and gmri.wz_type = '1'"
				+ " group by gmri.org_subjection_id, gmri.wz_id) tmp2"
				+ " inner join gms_mat_infomation gmi on tmp2.wz_id = gmi.wz_id and gmi.bsflag = '0'"
				+ " union all"
				+ " select aa.org_subjection_id,aa.wz_id,(aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) stock_amount,"
				+ " i.coding_code_id,i.wz_name,i.wz_prickie,(select n.org_abbreviation"
				+ " from comm_org_information n, comm_org_subjection n1"
				+ " where n1.org_id = n.org_id"
		 		+ " and n1.org_subjection_id=aa.org_subjection_id) stock_place,i.wz_price,"
				+ " (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) * i.wz_price as stock_money,'XMGL' as data_source"
				+ " from (select mti.org_subjection_id,tid.wz_id, sum(nvl(tid.mat_num,0)) mat_num"
				+ " from gms_mat_teammat_invoices mti"
				+ " left join gp_task_project p on p.project_info_no=mti.project_info_no "
				+ " inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0'"
				+ " where mti.bsflag = '0' and mti.invoices_type <> '2' and mti.invoices_type <> '1' and mti.if_input = '0'"
				+ " and ( p.project_start_time>=sysdate-365 or p.project_start_time is null )"
				+ " group by mti.org_subjection_id,tid.wz_id) aa"
				+ " left join (select mto.org_subjection_id,tod.wz_id, sum(nvl(tod.mat_num,0)) out_num"
				+ " from gms_mat_teammat_out mto"
				+ " left join gp_task_project p on p.project_info_no=mto.project_info_no "
				+ " inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0'"
				+ " where mto.bsflag = '0' and mto.wz_type = '0'"
				+ " and ( p.project_start_time>=sysdate-365 or p.project_start_time is null ) "
				+ " group by mto.org_subjection_id,tod.wz_id) bb"
				+ " on aa.wz_id = bb.wz_id and aa.org_subjection_id=bb.org_subjection_id"
				+ " inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0'"
				+ " union all"
				+ " select aa.org_subjection_id,aa.wz_id,(aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) as stock_amount,"
				+ " i.coding_code_id,i.wz_name,i.wz_prickie, (select n.org_abbreviation"
				+ " from comm_org_information n, comm_org_subjection n1"
				+ " where n1.org_id = n.org_id"
				+ " and n1.org_subjection_id=aa.org_subjection_id) stock_place,i.wz_price,"
				+ " (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) * i.wz_price as stock_money,'XMGL' as data_source"
				+ " from (select mti.org_subjection_id,tid.wz_id,sum(nvl(tid.mat_num, 0)) mat_num"
				+ " from gms_mat_teammat_invoices mti"
				+ " left join gp_task_project p on p.project_info_no=mti.project_info_no "
				+ " inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0'"
				+ " where mti.bsflag = '0' and mti.if_input = '0' " 
				+ " and ( p.project_start_time>=sysdate-365 or p.project_start_time is null ) "
				+	" group by mti.org_subjection_id, tid.wz_id) aa"
				+ " left join (select mto.org_subjection_id,tod.wz_id,sum(nvl(tod.mat_num, 0)) out_num"
				+ " from gms_mat_teammat_out mto"
				+ " left join gp_task_project p on p.project_info_no=mto.project_info_no "
				+ " inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0'"
				+ " where mto.bsflag = '0' and (mto.oil_from != '1' or mto.oil_from is null) " 
				+ " and ( p.project_start_time>=sysdate-365 or p.project_start_time is null ) "
				+ " group by mto.org_subjection_id, tod.wz_id) bb"
				+ " on aa.wz_id = bb.wz_id and aa.org_subjection_id = bb.org_subjection_id"
				+ " inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0') tmp where tmp.stock_amount>0";
		return sql;
	}
	
	/**
	 * 获取备件库存占比统计图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSpareStockChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// 数据来源
		String dataSource = isrvmsg.getValue("dataSource");
		if(StringUtils.isBlank(dataSource)){
			dataSource="";
		}
		// 是否添加图表单击事件,Y:添加
		String flag = isrvmsg.getValue("flag");
		if(StringUtils.isBlank(flag)){
			flag="";
		}
		StringBuilder sql = new StringBuilder(
				"select tt.mat_type,round(sum(tt.stock_money)/10000,2) as mat_money from ("
						+ " select case when t.coding_code_id like '07%' or t.coding_code_id ='17990414' or t.coding_code_id ='17990501' then 1"
						+ " when t.coding_code_id like '1402%' then 2"
						+ " when t.coding_code_id ='22060201' then 3"
						+ " when t.coding_code_id like '28%' then 4"
						+ " when t.coding_code_id like '29%' and t.coding_code_id not in('29990206','29990207','29990212','29990219') then 5"
						+ " when t.coding_code_id in ('35010201','35010202','35010203','35810101') then 6"
						+ " when t.coding_code_id like '37%' then 7"
						+ " when t.coding_code_id in ('38140112','38158102') then 8"
						+ " when t.coding_code_id like '43%' then 9"
						+ " when t.coding_code_id like '48%' then 10"
						+ " when t.coding_code_id like '51%' then 11"
						+ " when t.coding_code_id like '54%' then 12"
						+ " when t.coding_code_id like '55%' then 13"
						+ " when t.coding_code_id like '56%' then 14"
						+ " when t.coding_code_id in ('57210101','57210102','57210103','57210104','57210105','57210106') then 15"
						+ " end as mat_type,t.stock_money from ( "+getMatBasicSql()+" ) t where 1=1 ");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.org_subjection_id = '"+orgSubId+"' ");
		}
		// 数据来源
		if(StringUtils.isNotBlank(dataSource)){
			sql.append(" and t.data_source = '"+dataSource+"' ");
		}
		sql.append("   )tt group by tt.mat_type order by tt.mat_type ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		List<Map> tList =new ArrayList<Map>();
		for(int i=1;i<=15;i++){
			Map map=new HashMap();
			map.put("mat_type", i);
			map.put("mat_money", 0);
			if(i==1){
				map.put("mat_name", "石油及产品");
			}
			if(i==2){
				map.put("mat_name", "轮胎");
			}
			if(i==3){
				map.put("mat_name", "石油专用设备");
			}
			if(i==4){
				map.put("mat_name", "动力设备");
			}
			if(i==5){
				map.put("mat_name", "交通运输设备");
			}
			if(i==6){
				map.put("mat_name", "通信设备");
			}
			if(i==7){
				map.put("mat_name", "石油专用仪器、仪表");
			}
			if(i==8){
				map.put("mat_name", "通用仪器、仪表");
			}
			if(i==9){
				map.put("mat_name", "轴承");
			}
			if(i==10){
				map.put("mat_name", "石油钻采设备配件");
			}
			if(i==11){
				map.put("mat_name", "工矿配件");
			}
			if(i==12){
				map.put("mat_name", "内燃机及拖拉机配件");
			}
			if(i==13){
				map.put("mat_name", "重型汽车配件");
			}
			if(i==14){
				map.put("mat_name", "一般汽车及摩托车配件");
			}
			if(i==15){
				map.put("mat_name", "地震勘探船配件");
			}
			tList.add(map);
		}
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("yAxisName", "单位（万元 ）");
		// 构造数据
		for (Map tmap:tList) {
			Element set = root.addElement("set");
			set.addAttribute("label", tmap.get("mat_name").toString());
			String value = tmap.get("mat_money").toString();
			String matType = tmap.get("mat_type").toString();
			if(CollectionUtils.isNotEmpty(list)){
				for(Map map:list){
					if(null!=map.get("mat_type") && map.get("mat_type").toString().equals(matType)) {
						if(null!=map.get("mat_money") && StringUtils.isNotBlank(map.get("mat_money").toString())){
							value = map.get("mat_money").toString();
							list.remove(map);
							break;
						}
					}
				}
			}
			set.addAttribute("value", value);
			//图表添加单击事件
			if("Y".equals(flag)){
				set.addAttribute("link", "JavaScript:popSpareStockList('"+matType+"','"+orgSubId+"','"+dataSource+"')");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 查询备件库存信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg querySpareStockList(ISrvMsg isrvmsg) throws Exception {
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
		String matType = isrvmsg.getValue("matType");//  物资类别
		String orgSubId = isrvmsg.getValue("orgSubId");// 物探处
		String dataSource = isrvmsg.getValue("dataSource");// 数据来源
		StringBuilder sql = new StringBuilder(
				"select t.* from ( "+getMatBasicSql()+ ") t where 1=1 ");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.org_subjection_id = '"+orgSubId+"' ");
		}
		// 数据来源
		if(StringUtils.isNotBlank(dataSource)){
			sql.append(" and t.data_source = '"+dataSource+"' ");
		}
		if("1".equals(matType)){
			sql.append(" and ( t.coding_code_id like '07%' or t.coding_code_id ='17990414' or t.coding_code_id ='17990501' )");
		}
		if("2".equals(matType)){
			sql.append(" and t.coding_code_id like '1402%'");
		}
		if("3".equals(matType)){
			sql.append(" and t.coding_code_id ='22060201'");
		}
		if("4".equals(matType)){
			sql.append(" and t.coding_code_id like '28%'");
		}
		if("5".equals(matType)){
			sql.append(" and t.coding_code_id like '29%' and t.coding_code_id not in('29990206','29990207','29990212','29990219')");
		}
		if("6".equals(matType)){
			sql.append(" and t.coding_code_id in ('35010201','35010202','35010203','35810101')");
		}
		if("7".equals(matType)){
			sql.append(" and t.coding_code_id like '37%'");
		}
		if("8".equals(matType)){
			sql.append(" and t.coding_code_id in ('38140112','38158102')");
		}
		if("9".equals(matType)){
			sql.append(" and t.coding_code_id like '43%'");
		}
		if("10".equals(matType)){
			sql.append(" and t.coding_code_id like '48%'");
		}
		if("11".equals(matType)){
			sql.append(" and t.coding_code_id like '51%'");
		}
		if("12".equals(matType)){
			sql.append(" and t.coding_code_id like '54%'");
		}
		if("13".equals(matType)){
			sql.append(" and t.coding_code_id like '55%'");
		}
		if("14".equals(matType)){
			sql.append(" and t.coding_code_id like '56%'");
		}
		if("15".equals(matType)){
			sql.append(" and t.coding_code_id in ('57210101','57210102','57210103','57210104','57210105','57210106')");
		}
		sql.append(" order by t.wz_id,t.coding_code_id ");
		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
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
	/**
	 * 获取备件消耗占比统计图表数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSpareConsumeChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 物探处
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// 数据来源
		String dataSource = isrvmsg.getValue("dataSource");
		if(StringUtils.isBlank(dataSource)){
			dataSource="";
		}
		// 是否添加图表单击事件,Y:添加
		String flag = isrvmsg.getValue("flag");
		if(StringUtils.isBlank(flag)){
			flag="";
		}
		// 开始时间
		String startDate = isrvmsg.getValue("startDate");
		if(StringUtils.isBlank(startDate)){
			startDate="";
		}
		// 结束时间
		String endDate = isrvmsg.getValue("endDate");
		if(StringUtils.isBlank(endDate)){
			endDate="";
		}
		StringBuilder sql = new StringBuilder(
				"select tt.mat_type,round(sum(tt.stock_money)/10000,2) as mat_money from ("
						+ " select case when t.coding_code_id like '07%' or t.coding_code_id ='17990414' or t.coding_code_id ='17990501' then 1"
						+ " when t.coding_code_id like '1402%' then 2"
						+ " when t.coding_code_id ='22060201' then 3"
						+ " when t.coding_code_id like '28%' then 4"
						+ " when t.coding_code_id like '29%' and t.coding_code_id not in('29990206','29990207','29990212','29990219') then 5"
						+ " when t.coding_code_id in ('35010201','35010202','35010203','35810101') then 6"
						+ " when t.coding_code_id like '37%' then 7"
						+ " when t.coding_code_id in ('38140112','38158102') then 8"
						+ " when t.coding_code_id like '43%' then 9"
						+ " when t.coding_code_id like '48%' then 10"
						+ " when t.coding_code_id like '51%' then 11"
						+ " when t.coding_code_id like '54%' then 12"
						+ " when t.coding_code_id like '55%' then 13"
						+ " when t.coding_code_id like '56%' then 14"
						+ " when t.coding_code_id in ('57210101','57210102','57210103','57210104','57210105','57210106') then 15"
						+ " else 16 end as mat_type,t.stock_money from ( "+getMatConsumeSql()+" ) t where 1=1 ");
		
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.org_subjection_id like '%"+orgSubId+"%' ");
		}
		// 数据来源
		if(StringUtils.isNotBlank(dataSource)){
			sql.append(" and t.data_source = '"+dataSource+"' ");
		}
		// 开始时间
		if(StringUtils.isNotBlank(startDate)){
			sql.append(" and to_char(t.create_date,'yyyy-mm-dd')>= '"+startDate+"' ");
		}
		// 结束时间
		if(StringUtils.isNotBlank(endDate)){
			sql.append(" and to_char(t.create_date,'yyyy-mm-dd') <= '"+endDate+"' ");
		}
		sql.append("   )tt group by tt.mat_type order by tt.mat_type ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		List<Map> tList =new ArrayList<Map>();
		for(int i=1;i<=16;i++){
			Map map=new HashMap();
			map.put("mat_type", i);
			map.put("mat_money", 0);
			if(i==1){
				map.put("mat_name", "石油及产品");
			}
			if(i==2){
				map.put("mat_name", "轮胎");
			}
			if(i==3){
				map.put("mat_name", "石油专用设备");
			}
			if(i==4){
				map.put("mat_name", "动力设备");
			}
			if(i==5){
				map.put("mat_name", "交通运输设备");
			}
			if(i==6){
				map.put("mat_name", "通信设备");
			}
			if(i==7){
				map.put("mat_name", "石油专用仪器、仪表");
			}
			if(i==8){
				map.put("mat_name", "通用仪器、仪表");
			}
			if(i==9){
				map.put("mat_name", "轴承");
			}
			if(i==10){
				map.put("mat_name", "石油钻采设备配件");
			}
			if(i==11){
				map.put("mat_name", "工矿配件");
			}
			if(i==12){
				map.put("mat_name", "内燃机及拖拉机配件");
			}
			if(i==13){
				map.put("mat_name", "重型汽车配件");
			}
			if(i==14){
				map.put("mat_name", "一般汽车及摩托车配件");
			}
			if(i==15){
				map.put("mat_name", "地震勘探船配件");
			}
			if(i==16){
				map.put("mat_name", "其它");
			}
			tList.add(map);
		}
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("yAxisName", "单位（万元 ）");
		// 构造数据
		for (Map tmap:tList) {
			Element set = root.addElement("set");
			set.addAttribute("label", tmap.get("mat_name").toString());
			String value = tmap.get("mat_money").toString();
			String matType = tmap.get("mat_type").toString();
			if(CollectionUtils.isNotEmpty(list)){
				for(Map map:list){
					if(null!=map.get("mat_type") && map.get("mat_type").toString().equals(matType)) {
						if(null!=map.get("mat_money") && StringUtils.isNotBlank(map.get("mat_money").toString())){
							value = map.get("mat_money").toString();
							list.remove(map);
							break;
						}
					}
				}
			}
			set.addAttribute("value", value);
			//图表添加单击事件
			if("Y".equals(flag)){
				set.addAttribute("link", "JavaScript:popSpareConsumeList('"+matType+"','"+orgSubId+"','"+dataSource+"','"+startDate+"','"+endDate+"')");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * 获取物消耗基本sql
	 * @return
	 */
	public String getMatConsumeSql(){
		String sql = "select  accinfo.self_num,accinfo.dev_name,accinfo.owning_sub_id as org_sub_id,"
				+ " decode(accinfo.datafrom,'SAP','SAP','XMGL') as data_source,"
				+ " d.material_coding as wz_id,d.material_unit,"
				+ " d.material_name as name,d.material_amout as amout,"
				+ " d.unit_price as unit_price,d.material_amout*d.unit_price as stock_money,d.create_date,"
				+ " i.wz_name,i.coding_code_id"
				+ " from BGP_COMM_DEVICE_REPAIR_DETAIL d"
				+ " left join gms_mat_infomation i on d.material_coding=i.wz_id"
				+ " inner join (select owning_sub_id,repair_info,datafrom,self_num,dev_name "
				+ " from bgp_comm_device_repair_info info "
				+ " left join (select owning_sub_id,self_num,dev_name,dev_acc_id from  GMS_DEVICE_ACCOUNT"
				+ " union all"
				+ " select owning_sub_id,self_num,dev_name,dev_acc_id from  GMS_DEVICE_ACCOUNT_dui) acc "
				+ " on info.DEVICE_ACCOUNT_ID=acc.dev_acc_id ) accinfo"
				+ " on d.repair_info = accinfo.repair_info"
				+ " union all"
				+ " select l.self_num,l.dev_name,l.org_subjection_id as org_sub_id,'XMGL' as data_source,"
				+ " mat.wz_id,i.wz_prickie as material_unit,"
				+ " i.wz_name as name,mat.use_num as amout,i.wz_price as unit_price,"
				+ " mat.use_num*i.wz_price as stock_money,mat.create_date,i.wz_name,"
				+ " i.coding_code_id"
				+ " from gms_device_zy_wxbymat mat"
				+ " inner join (select org_subjection_id,usemat_id,self_num,dev_name "
				+ " from gms_device_zy_bywx t,"
				+ " (select owning_sub_id,self_num,dev_name,dev_acc_id,'' as fk_dev_acc_id from  gms_device_account "
				+ " union all"
				+ " select owning_sub_id,self_num,dev_name,dev_acc_id,fk_dev_acc_id from  gms_device_account_dui) a where t.dev_acc_id= a.dev_acc_id ) l"
				+ " on l.usemat_id=mat.usemat_id "
				+ " left join comm_coding_sort_detail d on d.coding_code_id=mat.coding_code_id"
				+ " inner join(gms_mat_infomation i  inner join gms_mat_coding_code c "
				+ " on i.coding_code_id = c.coding_code_id and i.bsflag = '0' and c.bsflag = '0')"
				+ " on mat.wz_id=i.wz_id";
		return sql;
	}
	/**
	 * 查询备件消耗信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg querySpareConsumeList(ISrvMsg isrvmsg) throws Exception {
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
		String matType = isrvmsg.getValue("matType");//  物资类别
		String orgSubId = isrvmsg.getValue("orgSubId");// 物探处
		String dataSource = isrvmsg.getValue("dataSource");// 数据来源
		// 开始时间
		String startDate = isrvmsg.getValue("startDate");
		if(StringUtils.isBlank(startDate)){
			startDate="";
		}
		// 结束时间
		String endDate = isrvmsg.getValue("endDate");
		if(StringUtils.isBlank(endDate)){
			endDate="";
		}
		StringBuilder sql = new StringBuilder(
				"select t.* from ( "+getMatConsumeSql()+ ") t where 1=1 ");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.org_sub_id like '"+orgSubId+"%' ");
		}
		// 数据来源
		if(StringUtils.isNotBlank(dataSource)){
			sql.append(" and t.data_source = '"+dataSource+"' ");
		}
		// 开始时间
		if(StringUtils.isNotBlank(startDate)){
			sql.append(" and to_char(t.create_date,'yyyy-mm-dd') >= '"+startDate+"' ");
		}
		// 结束时间
		if(StringUtils.isNotBlank(endDate)){
			sql.append(" and to_char(t.create_date,'yyyy-mm-dd') <= '"+endDate+"' ");
		}
		if("1".equals(matType)){
			sql.append(" and ( t.coding_code_id like '07%' or t.coding_code_id ='17990414' or t.coding_code_id ='17990501' )");
		}
		if("2".equals(matType)){
			sql.append(" and t.coding_code_id like '1402%'");
		}
		if("3".equals(matType)){
			sql.append(" and t.coding_code_id ='22060201'");
		}
		if("4".equals(matType)){
			sql.append(" and t.coding_code_id like '28%'");
		}
		if("5".equals(matType)){
			sql.append(" and t.coding_code_id like '29%' and t.coding_code_id not in('29990206','29990207','29990212','29990219')");
		}
		if("6".equals(matType)){
			sql.append(" and t.coding_code_id in ('35010201','35010202','35010203','35810101')");
		}
		if("7".equals(matType)){
			sql.append(" and t.coding_code_id like '37%'");
		}
		if("8".equals(matType)){
			sql.append(" and t.coding_code_id in ('38140112','38158102')");
		}
		if("9".equals(matType)){
			sql.append(" and t.coding_code_id like '43%'");
		}
		if("10".equals(matType)){
			sql.append(" and t.coding_code_id like '48%'");
		}
		if("11".equals(matType)){
			sql.append(" and t.coding_code_id like '51%'");
		}
		if("12".equals(matType)){
			sql.append(" and t.coding_code_id like '54%'");
		}
		if("13".equals(matType)){
			sql.append(" and t.coding_code_id like '55%'");
		}
		if("14".equals(matType)){
			sql.append(" and t.coding_code_id like '56%'");
		}
		if("15".equals(matType)){
			sql.append(" and t.coding_code_id in ('57210101','57210102','57210103','57210104','57210105','57210106')");
		}
		sql.append(" order by t.wz_id,t.coding_code_id ");
		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
}
