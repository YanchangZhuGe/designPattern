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
 * @Description:ά��ͳ�Ʒ�������
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
	 * ����ά�޷���ͳ��
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
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		DecimalFormat df = new DecimalFormat("0.00");
		
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("yAxisName", "(��λ��Ԫ)");
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
				tset.addAttribute("toolText", "ά�޽�"+(String)object.get("totalcost"));
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
	//�����ɫ16����
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
	 * ��ȡά�޷���ͳ��ͼ������
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tt.sub_id like '"+orgSubId+"%'");
		}
		// ���
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
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		DecimalFormat df = new DecimalFormat("0.00");
		
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("yAxisName", "(��λ����Ԫ)");
		Element categories=root.addElement("categories");
		Element tdataset=root.addElement("dataset");
		tdataset.addAttribute("seriesName", "�ܶ��");
		tdataset.addAttribute("color", "A66EDD");
		Element mdataset=root.addElement("dataset");
		mdataset.addAttribute("seriesName", "�¶��");
		mdataset.addAttribute("color", "F6BD0F");
		String tCost="0";
		// ��������
		for (Map tmap:tList) {
			Element category = categories.addElement("category");
			String tmonth=tmap.get("repair_month").toString();
			category.addAttribute("label", tmonth);
			//����ά�޶��
			Element tset = tdataset.addElement("set");
			//��ά�޶��
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
			tset.addAttribute("toolText", "�ܶ�ȣ�"+tCost);
			tset.addAttribute("showValue","0");
			if(!"0".equals(tCost)){
				tset.addAttribute("link", "JavaScript:popRepairMainChart('"+year+"','"+tmonth+"','"+orgSubId+"','total')");
			}else{
				
			}
			mset.addAttribute("value", mCost);
			mset.addAttribute("toolText", "�¶�ȣ�"+mCost);
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
	 * ��ȡά��ͳ�ƻ���sql
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
				+ " case when t.maintenance_level='��' then 'weixiu' else 'baoyang' end as repair_type,"
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
				+ " case when t.maintenance_level='��' then 'weixiu' else 'baoyang' end as repair_type,"
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
	 * ��ȡ��Ŀά�޷��û���sql
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
	 * ��ȡά��,����ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairMainChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ���
		String year = isrvmsg.getValue("year");
		// �·�
		String month = isrvmsg.getValue("month");
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// �ܶ�ȣ��¶�ȱ�ʶ
		String flag = isrvmsg.getValue("flag");
		StringBuilder sql = new StringBuilder(
				"select sum(tt.repair_cost) as repair_cost,tt.repair_type as repair_type,round(ratio_to_report(sum(tt.repair_cost)) over(),4)*100 as rate from ("
						+ " select * from ( ");
		sql.append(getRepairAnalBasicSql());
		sql.append("  ) t where 1=1 ");
		// ���
		if(StringUtils.isNotBlank(year)){
			sql.append(" and to_char(t.repair_date, 'yyyy')='"+year+"'");
		}
		// �ܶ�
		if("total".equals(flag)){
			sql.append(" and to_number(substr(to_char(t.repair_date, 'yyyy-mm-dd'),6,2),'99') <= "+month+"");
		}else{// �¶��
			sql.append(" and to_number(substr(to_char(t.repair_date, 'yyyy-mm-dd'),6,2),'99') = "+month+"");
		}
		sql.append(" ) tt group by tt.repair_type");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		List<Map> tlist = new ArrayList<Map>();
		Map map1=new HashMap();
		map1.put("repair_type","baoyang");
		map1.put("label","����");
		map1.put("value","0");
		tlist.add(map1);
		Map map2=new HashMap();
		map2.put("repair_type","weixiu");
		map2.put("label","ά��");
		map2.put("value","0");
		tlist.add(map2);
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// ��������
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
	 * ��ȡά�޷���ռ��ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairCostProportionChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp.sub_id like '"+orgSubId+"%'");
		}
		// ��ʼʱ��
		sql.append(" and tmp.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and tmp.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t group by t.data_type");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		List<Map> tlist = new ArrayList<Map>();
		Map map1=new HashMap();
		map1.put("data_type","xcwx");
		map1.put("label","�ֳ�ά������");
		map1.put("value","0");
		tlist.add(map1);
		Map map2=new HashMap();
		map2.put("data_type","fxcwx");
		map2.put("label","�ָ�����������");
		map2.put("value","0");
		tlist.add(map2);
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// ��������
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
			set.addAttribute("toolText", toolText+"Ԫ");
			if((!"0".equals(value)) && ("xcwx".equals(tmap.get("data_type").toString()))){
				set.addAttribute("link", "JavaScript:popProjRepaCostList('"+orgSubId+"','"+_startDate+"','"+_endDate+"')");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * ��ѯ��Ŀά�޷�����Ϣ�б�
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
		String orgSubId = isrvmsg.getValue("orgSubId");// ��̽��
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp.sub_id like '"+orgSubId+"%'");
		}
		// ��ʼʱ��
		sql.append(" and tmp.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
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
	 * ��ѯ��Ŀ�豸ά�޷�����Ϣ�б�
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
		String proNo = isrvmsg.getValue("proNo");// ��Ŀ���
		String subId = isrvmsg.getValue("subId");// ������λ
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// ��Ŀ��
		if(StringUtils.isNotBlank(proNo)){
			sql.append(" and tmp.project_info_no  = '"+proNo+"' ");
		}
		// ��̽��
		if(StringUtils.isNotBlank(subId)){
			sql.append(" and tmp.sub_id  = '"+subId+"' ");
		}
		// ��ʼʱ��
		sql.append(" and tmp.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
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
	 * ��ȡά����Ŀͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairItemChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id = '"+orgSubId+"' ");
		}
		// ��ʼʱ��
		sql.append(" and t.repair_start_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and t.repair_start_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append("   group by t.repair_item,t.coding_name )tt ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		String tSql = "select det.coding_code_id as repair_item,det.coding_name as label,'0' as value "
				+ "from comm_coding_sort_detail det where det.bsflag='0' and det.coding_sort_id = '5110000024' order by det.coding_code";
		List<Map> tlist = jdbcDao.queryRecords(tSql);
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// ��������
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
	 * ��ȡά�����ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairTypeChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ����(Ĭ��Ϊ��һ��)
		String level = isrvmsg.getValue("level");
		String project_id=isrvmsg.getValue("project_id");
		DecimalFormat df = new DecimalFormat("#.00");
		String value = "0";
		double costValue = 0;
		String costValueFormat = "";
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = isrvmsg.getValue("devTreeId");
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ���ڹ���
		String country = isrvmsg.getValue("country");
		String vcountry="";
		if(StringUtils.isBlank(country)){
			country="";
		}else{
			if("1".equals(country)){
				vcountry="����";
			}
			if("2".equals(country)){
				vcountry="����";			
			}
		}
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
				   + "��and repair_start_date <= to_date('"+_endDate+"', 'yyyy-mm-dd')) )t on dt.device_code = t.dev_type"
				   + " where dt.bsflag = '0' and dt.device_code is not null"
				   + " and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%')" ;
		// tree����
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp0.sub_id like '"+orgSubId+"%'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and tmp0.ifcountry='"+vcountry+"'");
		}
		// ��ʼʱ��
		sql.append(" and tmp0.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and tmp0.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t on dt.device_code = t.dev_type where dt.bsflag = '0' and dt.device_code is not null");
		sql.append(" and (dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%')");
		// tree����
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%' and dt.dev_tree_id <> '" + devTreeId + "'");
		}
		sql.append("  group by substr(dt.dev_tree_id, 1, "+subStrLength+")) tmp left join dms_device_tree d on tmp.dev_tree_id = d.dev_tree_id order by d.code_order");
		if(StringUtils.isNotBlank(project_id)&&!"null".equals(project_id)){
		sql=new StringBuilder(sql1);	
		} 
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("numberScaleUnit", "��Ԫ");
		root.addAttribute("yAxisName", "(��λ����Ԫ)");
		
		int cLevel=Integer.parseInt(level);//��ǰ��ȡ����
		int nLevel=cLevel+1;//��һ��ȡ����
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
		    	costValueFormat="0";
				Element set = root.addElement("set");
				String cdevTreeId=map.get("dev_tree_id").toString();//��ǰdev_tree_id����
				
				set.addAttribute("label", map.get("device_name").toString());
				if(null!=map.get("repair_cost") && !"0".equals(map.get("repair_cost").toString())){
					value=map.get("repair_cost").toString();
					costValue = Double.parseDouble(value)/10000;
					costValueFormat = df.format(costValue);
					//�ɿ���Դ,���,�����豸,�����ʾ��ϸ��Ϣ
					if(cdevTreeId.startsWith("D002")||cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
						// �����豸 �����������䳵,ֱ��չ���б�����
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
					//������������ֻ��ȡ��һ��
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
	 * ��ȡά�޷�����ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRepairCostRateChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ����(Ĭ��Ϊ��һ��)
		String level = isrvmsg.getValue("level");
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = isrvmsg.getValue("devTreeId");
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ���ڹ���
		String country = isrvmsg.getValue("country");
		String vcountry="";
		if(StringUtils.isBlank(country)){
			country="";
		}else{
			if("1".equals(country)){
				vcountry="����";
			}
			if("2".equals(country)){
				vcountry="����";			
			}
		}
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp0.sub_id like '"+orgSubId+"%'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and tmp0.ifcountry='"+vcountry+"'");
		}
		// ��ʼʱ��
		sql.append(" and tmp0.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and tmp0.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t on dt.device_code = t.dev_type where dt.bsflag = '0' and dt.device_code is not null");
		sql.append(" and ( dt.dev_tree_id like 'D002%' or dt.dev_tree_id like 'D003%' or dt.dev_tree_id like 'D004%' or dt.dev_tree_id like 'D006%')");
		// tree����
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%' and dt.dev_tree_id <> '" + devTreeId + "'");
		}
		sql.append("  group by substr(dt.dev_tree_id, 1, "+subStrLength+")) tmp left join dms_device_tree d on tmp.dev_tree_id = d.dev_tree_id order by d.code_order");
		System.out.println("sql:"+sql);
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		int cLevel=Integer.parseInt(level);//��ǰ��ȡ����
		int nLevel=cLevel+1;//��һ��ȡ����
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String cdevTreeId=map.get("dev_tree_id").toString();//��ǰdev_tree_id����
				String value = "0";
				set.addAttribute("label", map.get("device_name").toString());
				if(null!=map.get("repair_cost_rate") && !"0".equals(map.get("repair_cost_rate").toString())){
					value=map.get("repair_cost_rate").toString();
					//�ɿ���Դ,���,�����豸,�����ʾ��ϸ��Ϣ
					if(cdevTreeId.startsWith("D002")||cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
						// �����豸 �����������䳵,ֱ��չ���б�����
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
					//������������ֻ��ȡ��һ��
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
	 * ��ѯά��������Ϣ�б�
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
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		String devTreeId = isrvmsg.getValue("devTreeId");//  tree����
		String orgSubId = isrvmsg.getValue("orgSubId");// ��̽��
		String country = isrvmsg.getValue("country");// ����/����
		String project_id=isrvmsg.getValue("project_id");
		String vcountry="";
		if(StringUtils.isNotBlank(country)){
			if("1".equals(country)){
				vcountry="����";
			}
			if("2".equals(country)){
				vcountry="����";			
			}
		}
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// tree����
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp0.sub_id like '"+orgSubId+"%'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and tmp0.ifcountry='"+vcountry+"'");
		}
		// ��ʼʱ��
		sql.append(" and tmp0.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and tmp0.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t on dt.device_code = t.dev_type where dt.bsflag = '0' and dt.device_code is not null ");
		// tree����
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
	 * ��ѯά�޷�������Ϣ�б�
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
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		String devTreeId = isrvmsg.getValue("devTreeId");//  tree����
		String orgSubId = isrvmsg.getValue("orgSubId");// ��̽��
		String country = isrvmsg.getValue("country");// ����/����
		String vcountry="";
		if(StringUtils.isNotBlank(country)){
			if("1".equals(country)){
				vcountry="����";
			}
			if("2".equals(country)){
				vcountry="����";			
			}
		}
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and tmp0.sub_id like '"+orgSubId+"%'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and tmp0.ifcountry='"+vcountry+"'");
		}
		// ��ʼʱ��
		sql.append(" and tmp0.repair_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and tmp0.repair_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" ) t on dt.device_code = t.dev_type where dt.bsflag = '0' and dt.device_code is not null ");
		// tree����
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
	 * ��ȡ�豸������������ͼ������(��˾����)
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeviceCostProfitRateChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String amountYear = isrvmsg.getValue("amountYear");//���
		if(StringUtils.isBlank(amountYear)){
			amountYear="";
		}
		String analType = isrvmsg.getValue("analType");//ͳ�Ʒ������
		if(StringUtils.isBlank(analType)){
			analType="";
		}
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		String cSql = " select sum(case when ben.amount_type = '1' then ben.amount end) as income_amount,"
						+ " sum(case when ben.amount_type = '2' then ben.amount end) as cost_amount,"
						+ " sum(case when ben.amount_type = '1' then ben.amount end)-nvl(sum(case when ben.amount_type = '2' then ben.amount end),0) as profit_amount,"
						+ " ben.sub_org_id as sub_id from dms_device_benefit ben where ben.bsflag = '0' ";
		String rSql = getRepairAnalBasicSql();
		//������˾
		StringBuilder sql1 = new StringBuilder();
		//��̽��
		StringBuilder sql2 = new StringBuilder();
		//�����
		if("cost".equals(analType)){
			sql1.append("select oi.org_abbreviation as org_name,t.sub_id,t.income_amount,t2.repair_cost,round(decode(nvl(t.income_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.income_amount,0)),2) as rate from ( ");
		}else{//�����
			sql1.append("select oi.org_abbreviation as org_name,t.sub_id,t.profit_amount,t2.repair_cost,round(decode(nvl(t.profit_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.profit_amount,0)),2) as rate from ( ");
		}
		sql1.append(cSql);
		sql1.append(" and ben.level_type='1' ");
		// ���
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
		//��̽��
		if("cost".equals(analType)){
			sql2.append("select oi.org_abbreviation as org_name,t.sub_id,t.income_amount,t2.repair_cost,round(decode(nvl(t.income_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.income_amount,0)),2) as rate from ( ");
		}else{//�����
			sql2.append("select oi.org_abbreviation as org_name,t.sub_id,t.profit_amount,t2.repair_cost,round(decode(nvl(t.profit_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.profit_amount,0)),2) as rate from ( ");
		}
		sql2.append(cSql);
		sql2.append(" and ben.level_type='2' ");
		// ���
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
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		String[] org_names = {"�о�Ժ","��Ϣ��������","��̽�����о�����"};
		// ��������
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
	 * ��ȡ�豸������������ͼ������(��̽������)
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getWuTanCostProfitRateChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String amountYear = isrvmsg.getValue("amountYear");//���
		if(StringUtils.isBlank(amountYear)){
			amountYear="";
		}
		String analType = isrvmsg.getValue("analType");//ͳ�Ʒ������
		if(StringUtils.isBlank(analType)){
			analType="";
		}
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		String cSql = " select sum(case when ben.amount_type = '1' then ben.amount end) as income_amount,"
						+ " sum(case when ben.amount_type = '2' then ben.amount end) as cost_amount,"
						+ " sum(case when ben.amount_type = '1' then ben.amount end)-nvl(sum(case when ben.amount_type = '2' then ben.amount end),0) as profit_amount,"
						+ " ben.sub_org_id as sub_id from dms_device_benefit ben where ben.bsflag = '0' ";
		String rSql = getRepairAnalBasicSql();
		//��̽��
		StringBuilder sql1 = new StringBuilder();
		//��Ŀ
		StringBuilder sql2 = new StringBuilder();
		//�����
		if("cost".equals(analType)){
			sql1.append("select oi.org_abbreviation as label,t.sub_id as id,t.income_amount,t2.repair_cost,round(decode(nvl(t.income_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.income_amount,0)),2) as rate from ( ");
		}else{//�����
			sql1.append("select oi.org_abbreviation as label,t.sub_id as id,t.profit_amount,t2.repair_cost,round(decode(nvl(t.profit_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.profit_amount,0)),2) as rate from ( ");
		}
		sql1.append(cSql);
		sql1.append(" and ben.level_type='2' ");
		// ���
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
		//��Ŀ
		if("cost".equals(analType)){
			sql2.append("select pro.project_name as label,t.project_info_no as id,t.income_amount,t2.repair_cost,round(decode(nvl(t.income_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.income_amount,0)),2) as rate from ( ");
		}else{//�����
			sql2.append("select pro.project_name as label,t.project_info_no as id,t.profit_amount,t2.repair_cost,round(decode(nvl(t.profit_amount,0),0,0,nvl(t2.repair_cost,0)*100/nvl(t.profit_amount,0)),2) as rate from ( ");
		}
		sql2.append(" select sum(case when ben.amount_type = '1' then ben.amount end) as income_amount,"
				+ " sum(case when ben.amount_type = '2' then ben.amount end) as cost_amount,"
				+ " sum(case when ben.amount_type = '1' then ben.amount end)-nvl(sum(case when ben.amount_type = '2' then ben.amount end),0) as profit_amount,"
				+ " ben.project_info_no as project_info_no from dms_device_benefit ben where ben.bsflag = '0' and ben.level_type='3'");
		// ���
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
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "3");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		// ��������
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
	 * ��ȡ����ͳ�ƻ���sql
	 * @return  
	 */
	public String getSpareAnalBasicSql(){
		String sql = " select inf.coding_code_id as mat_code, inf.wz_name as mat_name, rd.material_coding wz_id, nvl(rd.material_amout, 0) as mat_num, nvl(rd.unit_price, 0) as mat_price, nvl(rd.total_charge, 0) as mat_money, ri.repair_start_date as mat_date, case when dui.owning_sub_id like 'C105001%' then substr(dui.owning_sub_id, 1, 10) when dui.owning_sub_id like 'C105005%' then substr(dui.owning_sub_id, 1, 10) else substr(dui.owning_sub_id, 1, 7) end as sub_id from bgp_comm_device_repair_info ri left join bgp_comm_device_repair_detail rd on ri.repair_info = rd.repair_info and rd.bsflag = '0' left join gms_mat_infomation inf on inf.wz_id = rd.material_coding and inf.bsflag = '0' left join gms_device_account_dui dui on ri.device_account_id = dui.dev_acc_id and dui.bsflag = '0' where ri.bsflag = '0' and ri.datafrom is null and ri.project_info_no is not null union all select rd.material_type as mat_code, rd.material_name as mat_name, rd.material_coding, nvl(rd.material_amout, 0) as mat_num, nvl(rd.unit_price, 0) as mat_price, nvl(rd.total_charge, 0) as mat_money, ri.repair_start_date as mat_date, case when acc.owning_sub_id like 'C105001%' then substr(acc.owning_sub_id, 1, 10) when acc.owning_sub_id like 'C105005%' then substr(acc.owning_sub_id, 1, 10) else substr(acc.owning_sub_id, 1, 7) end as sub_id from bgp_comm_device_repair_info ri left join bgp_comm_device_repair_detail rd on ri.repair_info = rd.repair_info and rd.bsflag = '0' left join gms_device_account acc on ri.dev_code = acc.dev_acc_id and acc.bsflag = '0' where ri.bsflag = '0' and(ri.datafrom = 'SAP' or (ri.datafrom is null and ri.project_info_no is null)) union all select inf.coding_code_id as mat_code, inf.wz_name as mat_name, m.wz_id, nvl(m.use_num, 0) as mat_num, nvl(r.actual_price, 0) as mat_price, nvl(m.use_num, 0) * nvl(r.actual_price, 0) as mat_money, t.bywx_date as mat_date, t.org_subjection_id as sub_id from gms_device_zy_bywx t left join gms_device_zy_wxbymat m on t.usemat_id = m.usemat_id left join gms_mat_recyclemat_info r on r.wz_id = m.wz_id left join gms_mat_infomation inf on r.wz_id = inf.wz_id where t.project_info_id is null and r.wz_type = '3' and r.bsflag = '0' and r.project_info_id is null and t.bsflag = '0' union all select inf.coding_code_id as mat_code, inf.wz_name as mat_name, m.wz_id, nvl(m.use_num, 0) as mat_num, nvl(r.actual_price, 0) as mat_price, nvl(m.use_num, 0) * nvl(r.actual_price, 0) as mat_money, t.bywx_date as mat_date, t.org_subjection_id as sub_id from gms_device_zy_bywx t left join gms_device_zy_wxbymat m on t.usemat_id = m.usemat_id left join gms_mat_recyclemat_info r on r.wz_id = m.wz_id left join gms_mat_infomation inf on r.wz_id = inf.wz_id where t.bsflag = '0' and r.project_info_id = t.project_info_id ";
		return sql;
	}
	
	/**
	 * ��ȡ��������ͳ��ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSpareConsStatChartDataYear(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id like '"+orgSubId+"%' ");
		}
		// ��ʼʱ��
		sql.append(" and t.mat_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
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
			//String[] array1 = {i+"","ʯ�ͼ���Ʒ"};
			if(i==1){
				map.put("mat_name", "ʯ�ͼ���Ʒ");
			}
			
			//String[] array2 = {i+"","��̥"};
			if(i==2){
				map.put("mat_name", "��̥");
			}
			
			//String[] array3 = {i+"","ʯ��ר���豸"};
			if(i==3){
				map.put("mat_name", "ʯ��ר���豸");
			}
			
			//String[] array4 = {i+"","�����豸"};
			if(i==4){
				map.put("mat_name", "�����豸");
			}
			
			//String[] array5 = {i+"","��ͨ�����豸"};
			if(i==5){
				map.put("mat_name", "��ͨ�����豸");
			}
			
			String[] array6 = {i+"","ͨ���豸"};
			if(i==6){
				map.put("mat_name", "ͨ���豸");
			}
			
			//String[] array7 = {i+"","ʯ��ר���������Ǳ�"};
			if(i==7){
				map.put("mat_name", "ʯ��ר���������Ǳ�");
			}
			
			//String[] array8 = {i+"","ͨ���������Ǳ�"};
			if(i==8){
				map.put("mat_name", "ͨ���������Ǳ�");
			}
			
			//String[] array9 = {i+"","���"};
			if(i==9){
				map.put("mat_name", "���");
			}
			
			//String[] array10 = {i+"","ʯ������豸���"};
			if(i==10){
				map.put("mat_name", "ʯ������豸���");
			}
			
			//String[] array11 = {i+"","�������"};
			if(i==11){
				map.put("mat_name", "�������");
			}
			
			//String[] array12 = {i+"","��ȼ�������������"};
			if(i==12){
				map.put("mat_name", "��ȼ�������������");
			}
			
			//String[] array13 = {i+"","�����������"};
			if(i==13){
				map.put("mat_name", "�����������");
			}
			
			//String[] array14 = {i+"","һ��������Ħ�г����"};
			if(i==14){
				map.put("mat_name", "һ��������Ħ�г����");
			}
			
			//String[] array15 = {i+"","����̽�����"};
			if(i==15){
				map.put("mat_name", "����̽�����");
			}
			dev_names.put((String)map.get("mat_name"), i);
			tList.add(map);
		}
		
		// ����xml����
				Document document = DocumentHelper.createDocument();
				Element root = document.addElement("chart");
				DecimalFormat df = new DecimalFormat("0.00");
				
				root.addAttribute("bgColor", "F3F5F4,DEE6EB");
				root.addAttribute("showValues", "1");
				root.addAttribute("decimals", "2");
				root.addAttribute("formatNumberScale", "0");
				root.addAttribute("palette", "4");
				root.addAttribute("baseFontSize", "12");
				root.addAttribute("yAxisName", "(��λ��Ԫ)");
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
	 * ��ȡ��������ͳ��ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSpareConsStatChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id like '"+orgSubId+"%' ");
		}
		// ��ʼʱ��
		sql.append(" and t.mat_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
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
			//String[] array1 = {i+"","ʯ�ͼ���Ʒ"};
			if(i==1){
				map.put("mat_name", "ʯ�ͼ���Ʒ");
			}
			
			//String[] array2 = {i+"","��̥"};
			if(i==2){
				map.put("mat_name", "��̥");
			}
			
			//String[] array3 = {i+"","ʯ��ר���豸"};
			if(i==3){
				map.put("mat_name", "ʯ��ר���豸");
			}
			
			//String[] array4 = {i+"","�����豸"};
			if(i==4){
				map.put("mat_name", "�����豸");
			}
			
			//String[] array5 = {i+"","��ͨ�����豸"};
			if(i==5){
				map.put("mat_name", "��ͨ�����豸");
			}
			
			String[] array6 = {i+"","ͨ���豸"};
			if(i==6){
				map.put("mat_name", "ͨ���豸");
			}
			
			//String[] array7 = {i+"","ʯ��ר���������Ǳ�"};
			if(i==7){
				map.put("mat_name", "ʯ��ר���������Ǳ�");
			}
			
			//String[] array8 = {i+"","ͨ���������Ǳ�"};
			if(i==8){
				map.put("mat_name", "ͨ���������Ǳ�");
			}
			
			//String[] array9 = {i+"","���"};
			if(i==9){
				map.put("mat_name", "���");
			}
			
			//String[] array10 = {i+"","ʯ������豸���"};
			if(i==10){
				map.put("mat_name", "ʯ������豸���");
			}
			
			//String[] array11 = {i+"","�������"};
			if(i==11){
				map.put("mat_name", "�������");
			}
			
			//String[] array12 = {i+"","��ȼ�������������"};
			if(i==12){
				map.put("mat_name", "��ȼ�������������");
			}
			
			//String[] array13 = {i+"","�����������"};
			if(i==13){
				map.put("mat_name", "�����������");
			}
			
			//String[] array14 = {i+"","һ��������Ħ�г����"};
			if(i==14){
				map.put("mat_name", "һ��������Ħ�г����");
			}
			
			//String[] array15 = {i+"","����̽�����"};
			if(i==15){
				map.put("mat_name", "����̽�����");
			}
			tList.add(map);
		}
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
//		// ��������
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
	 * ��ȡ�����ͱ�������ͳ��ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCSpareConsStatChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ����
		String level = isrvmsg.getValue("level");
		//��ȡ����
		int subStrLength=Integer.parseInt(level)*2;
		//����
		String matCode = isrvmsg.getValue("matCode");
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// ����
		if(StringUtils.isNotBlank(matCode)){
			sql.append(" and t.mat_code like '"+matCode+"%'");
		}
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id like '"+orgSubId+"%' ");
		}
		// ��ʼʱ��
		sql.append(" and t.mat_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and t.mat_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" group by substr(t.mat_code, 1, "+subStrLength+")) tt ");
		sql.append(" left join gms_mat_coding_code cc on tt.mat_code=cc.coding_code_id and cc.bsflag='0' order by cc.coding_code_id");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		if(CollectionUtils.isNotEmpty(list)){
			// ��������
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
	 * ��ѯ��������ͳ����Ϣ�б�
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
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		String matType = isrvmsg.getValue("matType");//  �������
		String orgSubId = isrvmsg.getValue("orgSubId");// ��̽��
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id like '"+orgSubId+"%' ");
		}
		// ��ʼʱ��
		sql.append(" and t.mat_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
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
	 * ��ѯ��������ͳ����Ϣ�б�
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
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		String matCode = isrvmsg.getValue("matCode");//  ���ʱ���
		String orgSubId = isrvmsg.getValue("orgSubId");// ��̽��
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		// ���ʱ���
		if(StringUtils.isNotBlank(matCode)){
			sql.append(" and t.mat_code ='"+matCode+"'");
		}
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.sub_id like '"+orgSubId+"%' ");
		}
		// ��ʼʱ��
		sql.append(" and t.mat_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
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
	 * ��ȡ���ʿ�����sql
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
	 * ��ȡ�������ռ��ͳ��ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSpareStockChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ������Դ
		String dataSource = isrvmsg.getValue("dataSource");
		if(StringUtils.isBlank(dataSource)){
			dataSource="";
		}
		// �Ƿ����ͼ�����¼�,Y:���
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
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.org_subjection_id = '"+orgSubId+"' ");
		}
		// ������Դ
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
				map.put("mat_name", "ʯ�ͼ���Ʒ");
			}
			if(i==2){
				map.put("mat_name", "��̥");
			}
			if(i==3){
				map.put("mat_name", "ʯ��ר���豸");
			}
			if(i==4){
				map.put("mat_name", "�����豸");
			}
			if(i==5){
				map.put("mat_name", "��ͨ�����豸");
			}
			if(i==6){
				map.put("mat_name", "ͨ���豸");
			}
			if(i==7){
				map.put("mat_name", "ʯ��ר���������Ǳ�");
			}
			if(i==8){
				map.put("mat_name", "ͨ���������Ǳ�");
			}
			if(i==9){
				map.put("mat_name", "���");
			}
			if(i==10){
				map.put("mat_name", "ʯ������豸���");
			}
			if(i==11){
				map.put("mat_name", "�������");
			}
			if(i==12){
				map.put("mat_name", "��ȼ�������������");
			}
			if(i==13){
				map.put("mat_name", "�����������");
			}
			if(i==14){
				map.put("mat_name", "һ��������Ħ�г����");
			}
			if(i==15){
				map.put("mat_name", "����̽�����");
			}
			tList.add(map);
		}
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("yAxisName", "��λ����Ԫ ��");
		// ��������
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
			//ͼ����ӵ����¼�
			if("Y".equals(flag)){
				set.addAttribute("link", "JavaScript:popSpareStockList('"+matType+"','"+orgSubId+"','"+dataSource+"')");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * ��ѯ���������Ϣ�б�
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
		String matType = isrvmsg.getValue("matType");//  �������
		String orgSubId = isrvmsg.getValue("orgSubId");// ��̽��
		String dataSource = isrvmsg.getValue("dataSource");// ������Դ
		StringBuilder sql = new StringBuilder(
				"select t.* from ( "+getMatBasicSql()+ ") t where 1=1 ");
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.org_subjection_id = '"+orgSubId+"' ");
		}
		// ������Դ
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
	 * ��ȡ��ǰ���
	 * 
	 * @return
	 */
	public String getCurrentYear() {
		Calendar cal = Calendar.getInstance();
		Integer year = cal.get(Calendar.YEAR);
		return year.toString();
	}

	/**
	 * ��ȡ��ǰʱ��
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
	 * ��ȡ��������ռ��ͳ��ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSpareConsumeChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ������Դ
		String dataSource = isrvmsg.getValue("dataSource");
		if(StringUtils.isBlank(dataSource)){
			dataSource="";
		}
		// �Ƿ����ͼ�����¼�,Y:���
		String flag = isrvmsg.getValue("flag");
		if(StringUtils.isBlank(flag)){
			flag="";
		}
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		if(StringUtils.isBlank(startDate)){
			startDate="";
		}
		// ����ʱ��
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
		
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.org_subjection_id like '%"+orgSubId+"%' ");
		}
		// ������Դ
		if(StringUtils.isNotBlank(dataSource)){
			sql.append(" and t.data_source = '"+dataSource+"' ");
		}
		// ��ʼʱ��
		if(StringUtils.isNotBlank(startDate)){
			sql.append(" and to_char(t.create_date,'yyyy-mm-dd')>= '"+startDate+"' ");
		}
		// ����ʱ��
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
				map.put("mat_name", "ʯ�ͼ���Ʒ");
			}
			if(i==2){
				map.put("mat_name", "��̥");
			}
			if(i==3){
				map.put("mat_name", "ʯ��ר���豸");
			}
			if(i==4){
				map.put("mat_name", "�����豸");
			}
			if(i==5){
				map.put("mat_name", "��ͨ�����豸");
			}
			if(i==6){
				map.put("mat_name", "ͨ���豸");
			}
			if(i==7){
				map.put("mat_name", "ʯ��ר���������Ǳ�");
			}
			if(i==8){
				map.put("mat_name", "ͨ���������Ǳ�");
			}
			if(i==9){
				map.put("mat_name", "���");
			}
			if(i==10){
				map.put("mat_name", "ʯ������豸���");
			}
			if(i==11){
				map.put("mat_name", "�������");
			}
			if(i==12){
				map.put("mat_name", "��ȼ�������������");
			}
			if(i==13){
				map.put("mat_name", "�����������");
			}
			if(i==14){
				map.put("mat_name", "һ��������Ħ�г����");
			}
			if(i==15){
				map.put("mat_name", "����̽�����");
			}
			if(i==16){
				map.put("mat_name", "����");
			}
			tList.add(map);
		}
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("yAxisName", "��λ����Ԫ ��");
		// ��������
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
			//ͼ����ӵ����¼�
			if("Y".equals(flag)){
				set.addAttribute("link", "JavaScript:popSpareConsumeList('"+matType+"','"+orgSubId+"','"+dataSource+"','"+startDate+"','"+endDate+"')");
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * ��ȡ�����Ļ���sql
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
	 * ��ѯ����������Ϣ�б�
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
		String matType = isrvmsg.getValue("matType");//  �������
		String orgSubId = isrvmsg.getValue("orgSubId");// ��̽��
		String dataSource = isrvmsg.getValue("dataSource");// ������Դ
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		if(StringUtils.isBlank(startDate)){
			startDate="";
		}
		// ����ʱ��
		String endDate = isrvmsg.getValue("endDate");
		if(StringUtils.isBlank(endDate)){
			endDate="";
		}
		StringBuilder sql = new StringBuilder(
				"select t.* from ( "+getMatConsumeSql()+ ") t where 1=1 ");
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and t.org_sub_id like '"+orgSubId+"%' ");
		}
		// ������Դ
		if(StringUtils.isNotBlank(dataSource)){
			sql.append(" and t.data_source = '"+dataSource+"' ");
		}
		// ��ʼʱ��
		if(StringUtils.isNotBlank(startDate)){
			sql.append(" and to_char(t.create_date,'yyyy-mm-dd') >= '"+startDate+"' ");
		}
		// ����ʱ��
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
