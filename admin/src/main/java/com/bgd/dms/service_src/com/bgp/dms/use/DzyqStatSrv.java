package com.bgp.dms.use;

import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * @ClassName: DzyqStatSrv
 * @Description:地震仪器动态情况统计分析服务
 * @author dushuai
 * @date 2015-5-12
 */
public class DzyqStatSrv extends BaseService {

	public DzyqStatSrv() {
		log = LogFactory.getLogger(DzyqStatSrv.class);
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	IBaseDao baseDao = BeanFactory.getBaseDao();

	/**
	 * 查询公司级地震仪器动态情况统计表
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCompEqChart(ISrvMsg reqDTO) throws Exception{
		String sql = "select ci.node_type_id,sd.coding_name,sum(ci.dev_slot_num*total_num) as total_slotnum,"+
						"sum(ci.dev_slot_num*use_num) as use_slotnum,sum(ci.dev_slot_num*unuse_num) as unuse_slotnum,"+
						"sum(ci.dev_slot_num*repairing_num) as repairing_slotnum "+
						"from gms_device_coll_account ca "+
						"join gms_device_coll_account_tech cat on ca.dev_acc_id = cat.dev_acc_id "+
						"join gms_device_collectinfo ci on ca.device_id=ci.device_id "+
						"left join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id "+
						"where ci.node_type_id is not null "+
						"group by ci.node_type_id,sd.coding_name";
		
		List list = jdbcDao.queryRecords(sql.toString());
		//拼xml串
		Document document = DocumentHelper.createDocument(); 
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("rotateValues", "1");
		root.addAttribute("yAxisName", "道");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		Element categories = root.addElement("categories");
		Element[] categorys = new Element[list.size()];
		Element datasetTotal = root.addElement("dataset");
		datasetTotal.addAttribute("seriesName", "总量");
		Element datasetZaiyong = root.addElement("dataset");
		datasetZaiyong.addAttribute("seriesName", "在用");
		Element datasetXianzhi = root.addElement("dataset");
		datasetXianzhi.addAttribute("seriesName", "闲置");
		Element datasetWeixiu = root.addElement("dataset");
		datasetWeixiu.addAttribute("seriesName", "维修");
		for(int index=0;index<list.size();index++){
			Map dataMap = (Map)list.get(index);
			categorys[index] = categories.addElement("category");
			categorys[index].addAttribute("label", dataMap.get("coding_name").toString());
			Element settotal = datasetTotal.addElement("set");
			settotal.addAttribute("value", dataMap.get("total_slotnum").toString());
			Element setzaiyong = datasetZaiyong.addElement("set");
			setzaiyong.addAttribute("value", dataMap.get("use_slotnum").toString());
			setzaiyong.addAttribute("link", "j-popzaiyongdrill-"+dataMap.get("node_type_id"));
			Element setxianzhi = datasetXianzhi.addElement("set");
			setxianzhi.addAttribute("value", dataMap.get("unuse_slotnum").toString());
			setxianzhi.addAttribute("link", "j-popxianzhidrill-"+dataMap.get("node_type_id"));
			Element setweixiu = datasetWeixiu.addElement("set");
			setweixiu.addAttribute("value", dataMap.get("repairing_slotnum").toString());
		}
		String xmlData = root.asXML();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("xmldata", xmlData);
		return msg;
	}
	
	/**
	 * 异步查询设备技术状态的统计数据(公司级):物探处 向项目的钻取
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg drillEQUseProDistribute(ISrvMsg reqDTO) throws Exception{
		String code = reqDTO.getValue("code");
		String suborgid = reqDTO.getValue("orgsubid");
		//查询地震仪器存在的型号
		String nodetypesql = "select distinct sd.coding_name as node_type,sd.coding_code_id  from gms_device_coll_account ca "+
				"left join gms_device_collectinfo ci on ca.device_id=ci.device_id "+
				"left join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id "+
				"where sd.coding_name is not null and ci.node_type_id='"+code+"' ";
		nodetypesql += "order by sd.coding_code_id ";
		Map teamMap = jdbcDao.queryRecordBySQL(nodetypesql.toString());
		String nodetypes = null;
		String nodetypeids = null;
		if(teamMap!=null){
			nodetypes = teamMap.get("node_type").toString();
			nodetypeids = teamMap.get("coding_code_id").toString();
		}
		//orgid,not org_sub_id 
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("yAxisName", "单位:道");
		Element categories = root.addElement("categories");
		Element datasets = root.addElement("dataset");
		datasets.addAttribute("seriesName", nodetypes);
		//查询物探处信息
		String searchWutanchuSql = "select distinct orgsubparent.org_subjection_id||'-'||org.org_abbreviation as org_name "+
					"from gms_device_coll_account_dui dui "+ 
					"join gms_device_collectinfo ci on dui.device_id=ci.device_id "+
					"join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no "+
					"join comm_org_subjection orgsub on dym.org_subjection_id=orgsub.org_subjection_id and orgsub.bsflag='0' "+
					"join comm_org_subjection orgsubparent on orgsub.father_org_id=orgsubparent.org_subjection_id and orgsubparent.bsflag='0' "+
					"join comm_org_information org on orgsubparent.org_id=org.org_id "+
					"where dui.project_info_id is not null and dui.is_leaving='0' "+
					"and ci.node_type_id='"+code+"' and orgsubparent.org_subjection_id='"+suborgid+"' ";
		
		Map orgNameMap = jdbcDao.queryRecordBySQL(searchWutanchuSql);
		//统计物探处的几类数值
		StringBuffer wutansb = new StringBuffer("select data1.project_name||'('||base.label||')' as label,nvl(data1.value,0) as value,base.seq from ")
				.append("(select '"+nodetypes+"' as label,'1' as seq from dual ) base left join (");
			wutansb.append("select pro.project_name,dui.project_info_id,sd.coding_name as label,sum(ci.dev_slot_num*dui.unuse_num) as value ")
				.append("from gms_device_coll_account_dui dui ")
				.append("join gp_task_project pro on dui.project_info_id=pro.project_info_no ")
				.append("join gms_device_collectinfo ci on dui.device_id=ci.device_id ")
				.append("join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id  ")
				.append("join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no ")
				.append("join comm_org_subjection orgsub on dym.org_subjection_id=orgsub.org_subjection_id and orgsub.bsflag='0' ")
				.append("join comm_org_subjection orgsubparent on orgsub.father_org_id=orgsubparent.org_subjection_id and orgsubparent.bsflag='0' ")
				.append("join comm_org_information org on orgsubparent.org_id=org.org_id ")
				.append("where dui.project_info_id is not null and dui.is_leaving='0' and orgsubparent.org_subjection_id='@' ")
				.append("and ci.node_type_id is not null and ci.node_type_id='"+nodetypeids+"' ")
				.append("group by pro.project_name,dui.project_info_id,sd.coding_name ) data1 on base.label=data1.label ");
		if(orgNameMap!=null){
			String labelStr = orgNameMap.get("org_name").toString();
			
			List wutanlist = jdbcDao.queryRecords(wutansb.toString().replaceAll("@", labelStr.split("-")[0]));
			
			if(wutanlist != null){
				for(int k=0;k<wutanlist.size();k++){
					if(Float.parseFloat((String)((Map)wutanlist.get(k)).get("value"))!=0){
						Element category = categories.addElement("category");
						category.addAttribute("label", (String)((Map)wutanlist.get(k)).get("label"));
						Element set1 = datasets.addElement("set");
						set1.addAttribute("value", (String)((Map)wutanlist.get(k)).get("value"));
						//添加 钻取到各物探处的项目
						set1.addAttribute("link", "j-drillEQUseBack-"+code);
					}
				}
			}else{
				Element category = categories.addElement("category");
				category.addAttribute("label", labelStr.split("-")[1]);
				
				Element set1 = datasets.addElement("set");
			}
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("xmldata", root.asXML());
		return msg;
	}
	
	/**
	 * 异步查询设备技术状态的统计数据(公司级):在用数据在各项目的分布
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getEqUseComDistribute(ISrvMsg reqDTO) throws Exception{
		String code = reqDTO.getValue("code");
		//查询地震仪器存在的型号
		String nodetypesql = "select distinct sd.coding_name as node_type,sd.coding_code_id  from gms_device_coll_account ca "+
				"left join gms_device_collectinfo ci on ca.device_id=ci.device_id "+
				"left join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id "+
				"where sd.coding_name is not null ";
		if(code!=null&&!"".equals(code)){
			nodetypesql += "and ci.node_type_id='"+code+"' ";
		}
		nodetypesql += "order by sd.coding_code_id ";
		List teamList = jdbcDao.queryRecords(nodetypesql.toString());
		String[] nodetypes = new String[teamList.size()];
		String[] nodetypeids = new String[teamList.size()];
		for(int i=0;i<teamList.size();i++){
			Map tempMap = (Map)teamList.get(i);
			nodetypes[i] = tempMap.get("node_type").toString();
			nodetypeids[i] = tempMap.get("coding_code_id").toString();
		}
		//orgid,not org_sub_id 
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("yAxisName", "单位:道");
		Element categories = root.addElement("categories");
		Element[] datasets = new Element[nodetypes.length];
		for(int j=0;j<nodetypes.length;j++){
			datasets[j] = root.addElement("dataset");
			datasets[j].addAttribute("seriesName", nodetypes[j]);
		}
		
		//统计对应类别的数值
		StringBuffer sb = new StringBuffer("select label,value ");
		sb.append(" from (");
		for(int j=0;j<nodetypes.length;j++){
			if(j>0){
				sb.append("union all ");
			}
			sb.append("( select base.label,nvl(data1.value,0) as value,base.seq from ")
				.append("(select '"+nodetypes[j]+"' as label,'"+j+"' as seq from dual ) base left join (");
			sb.append("select sd.coding_name as label,sum(ci.dev_slot_num*dui.unuse_num) as value ")
				.append("from gms_device_coll_account_dui dui ")
				.append("join gms_device_collectinfo ci on dui.device_id=ci.device_id ")
				.append("join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id  ")
				.append("join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no ")
				.append("join comm_org_subjection orgsub on dym.org_subjection_id=orgsub.org_subjection_id and orgsub.bsflag='0' ")
				.append("join comm_org_subjection orgsubparent on orgsub.father_org_id=orgsubparent.org_subjection_id and orgsubparent.bsflag='0' ")
				.append("join comm_org_information org on orgsubparent.org_id=org.org_id ")
				.append("where dui.project_info_id is not null and dui.is_leaving='0' ")
				.append("and ci.node_type_id is not null and ci.node_type_id='"+nodetypeids[j]+"' ")
				.append("group by sd.coding_name ) data1 on base.label=data1.label)");
		}
		sb.append(" ) order by seq");
		//先查询总数
		List list = jdbcDao.queryRecords(sb.toString());
		if(list != null){
			Element category = categories.addElement("category");
			category.addAttribute("label", "总量");
			for(int k=0;k<list.size();k++){
				Element set1 = datasets[k].addElement("set");
				set1.addAttribute("color", "F9DA7A");
				set1.addAttribute("value", (String)((Map)list.get(k)).get("value"));
			}
		}else{
			Element category = categories.addElement("category");
			category.addAttribute("label", "总量");
		}
		//查询物探处信息
		String searchWutanchuSql = "select distinct orgsubparent.org_subjection_id||'-'||org.org_abbreviation as org_name "+
					"from gms_device_coll_account_dui dui "+ 
					"join gms_device_collectinfo ci on dui.device_id=ci.device_id "+
					"join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no "+
					"join comm_org_subjection orgsub on dym.org_subjection_id=orgsub.org_subjection_id and orgsub.bsflag='0' "+
					"join comm_org_subjection orgsubparent on orgsub.father_org_id=orgsubparent.org_subjection_id and orgsubparent.bsflag='0' "+
					"join comm_org_information org on orgsubparent.org_id=org.org_id "+
					"where dui.project_info_id is not null and dui.is_leaving='0' and ci.node_type_id='"+code+"' ";
		
		List<Map> orgNamesList = jdbcDao.queryRecords(searchWutanchuSql);
		//统计物探处的几类数值
		StringBuffer wutansb = new StringBuffer("select label,value ");
		wutansb.append(" from (");
		for(int j=0;j<nodetypes.length;j++){
			if(j>0){
				wutansb.append("union all ");
			}
			wutansb.append("( select base.label,nvl(data1.value,0) as value,base.seq from ")
				.append("(select '"+nodetypes[j]+"' as label,'"+j+"' as seq from dual ) base left join (");
			wutansb.append("select sd.coding_name as label,sum(ci.dev_slot_num*dui.unuse_num) as value ")
				.append("from gms_device_coll_account_dui dui ")
				.append("join gms_device_collectinfo ci on dui.device_id=ci.device_id ")
				.append("join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id  ")
				.append("join gp_task_project_dynamic dym on dui.project_info_id=dym.project_info_no ")
				.append("join comm_org_subjection orgsub on dym.org_subjection_id=orgsub.org_subjection_id and orgsub.bsflag='0' ")
				.append("join comm_org_subjection orgsubparent on orgsub.father_org_id=orgsubparent.org_subjection_id and orgsubparent.bsflag='0' ")
				.append("join comm_org_information org on orgsubparent.org_id=org.org_id ")
				.append("where dui.project_info_id is not null and dui.is_leaving='0' and orgsubparent.org_subjection_id='@' ")
				.append("and ci.node_type_id is not null and ci.node_type_id='"+nodetypeids[j]+"' ")
				.append("group by sd.coding_name ) data1 on base.label=data1.label)");
		}
		wutansb.append(" ) order by seq");
		for(int index=0;index<orgNamesList.size();index++){
			Map tempMap = orgNamesList.get(index);
			String labelStr = tempMap.get("org_name").toString();
			
			List wutanlist = jdbcDao.queryRecords(wutansb.toString().replaceAll("@", labelStr.split("-")[0]));
			
			if(wutanlist != null){
				Element category = categories.addElement("category");
				category.addAttribute("label", labelStr.split("-")[1]);
				
				for(int k=0;k<wutanlist.size();k++){
					Element set1 = datasets[k].addElement("set");
					if(Float.parseFloat((String)((Map)wutanlist.get(k)).get("value"))!=0){
						set1.addAttribute("color", "D1E8F9");
						set1.addAttribute("value", (String)((Map)wutanlist.get(k)).get("value"));
						//添加 钻取到各物探处的项目
						set1.addAttribute("link", "j-drillEQUseProDistribute-"+code+"~"+labelStr.split("-")[0]);
					}
				}
			}else{
				Element category = categories.addElement("category");
				category.addAttribute("label", labelStr.split("-")[1]);
				
				for(int k=0;k<nodetypes.length;k++){
					Element set1 = datasets[k].addElement("set");
				}
			}
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("xmldata", document.asXML());
		return msg;
	}
	
	/**
	 * 异步查询设备技术状态为闲置的统计数据(公司级)
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getEqUnuseComDistribute(ISrvMsg reqDTO) throws Exception{
		String code = reqDTO.getValue("code");
		//查询地震仪器存在的型号
		String nodetypesql = "select distinct sd.coding_name as node_type,sd.coding_code_id  from gms_device_coll_account ca "+
				"left join gms_device_collectinfo ci on ca.device_id=ci.device_id "+
				"left join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id "+
				"where sd.coding_name is not null ";
		if(code!=null&&!"".equals(code)){
			nodetypesql += "and ci.node_type_id='"+code+"' ";
		}
		nodetypesql += "order by sd.coding_code_id ";
		List teamList = jdbcDao.queryRecords(nodetypesql.toString());
		String[] nodetypes = new String[teamList.size()];
		String[] nodetypeids = new String[teamList.size()];
		for(int i=0;i<teamList.size();i++){
			Map tempMap = (Map)teamList.get(i);
			nodetypes[i] = tempMap.get("node_type").toString();
			nodetypeids[i] = tempMap.get("coding_code_id").toString();
		}
		//orgid,not org_sub_id 
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("yAxisName", "单位:道");
		Element categories = root.addElement("categories");
		Element[] datasets = new Element[nodetypes.length];
		for(int j=0;j<nodetypes.length;j++){
			datasets[j] = root.addElement("dataset");
			datasets[j].addAttribute("seriesName", nodetypes[j]);
		}
		
		//统计5类数值
		StringBuffer sb = new StringBuffer("select label,value ");
		sb.append(" from (");
		for(int j=0;j<nodetypes.length;j++){
			if(j>0){
				sb.append("union all ");
			}
			sb.append("( select base.label,nvl(data1.value,0) as value,base.seq from ")
				.append("(select '"+nodetypes[j]+"' as label,'"+j+"' as seq from dual ) base left join (");
			sb.append("select sd.coding_name as label,sum(ci.dev_slot_num*unuse_num) as value ")
				.append("from gms_device_coll_account ca ")
				.append("left join comm_org_subjection s on ca.usage_org_id = s.org_id  and s.bsflag = '0' ")
				.append("join gms_device_coll_account_tech cat on ca.dev_acc_id = cat.dev_acc_id ")
				.append("join gms_device_collectinfo ci on ca.device_id=ci.device_id  ")
				.append("join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id  ")
				.append("where ci.node_type_id is not null and ci.node_type_id='"+nodetypeids[j]+"' ")
				.append("group by sd.coding_name )data1 on base.label=data1.label)");
		}
		sb.append(" ) order by seq");
		//先查询总数
		List list = jdbcDao.queryRecords(sb.toString());
		if(list != null){
			Element category = categories.addElement("category");
			category.addAttribute("label", "总量");
			for(int k=0;k<list.size();k++){
				Element set1 = datasets[k].addElement("set");
				set1.addAttribute("color", "F9DA7A");
				set1.addAttribute("value", (String)((Map)list.get(k)).get("value"));
			}
		}else{
			Element category = categories.addElement("category");
			category.addAttribute("label", "总量");
		}
		String[] orgNames = new String[]{"C105006002-仪器服务中心","C105006008-塔里木作业部","C105006005-北疆作业部",
				"C105006009-吐哈作业部","C105006006-敦煌作业部" ,"C105006004-长庆作业部", "C105006007-华北作业部",
				"C105006011-新区作业部","C105063-辽河物探处","C105007-大港物探处"};
		//统计物探处的5类数值
		StringBuffer wutansb = new StringBuffer("select label,value ");
		wutansb.append(" from (");
		for(int j=0;j<nodetypes.length;j++){
			if(j>0){
				wutansb.append(" union all ");
			}
			wutansb.append("( select base.label,nvl(data1.value,0) as value,base.seq from ")
				.append("(select '"+nodetypes[j]+"' as label,'"+j+"' as seq from dual ) base left join (");
			wutansb.append("select sd.coding_name as label,sum(ci.dev_slot_num*unuse_num) as value ")
				.append("from gms_device_coll_account ca ")
				.append("left join comm_org_subjection s on ca.usage_org_id = s.org_id  and s.bsflag = '0' ")
				.append("join gms_device_coll_account_tech cat on ca.dev_acc_id = cat.dev_acc_id ")
				.append("join gms_device_collectinfo ci on ca.device_id=ci.device_id  ")
				.append("join comm_coding_sort_detail sd on ci.node_type_id=sd.coding_code_id  ")
				.append("where ci.node_type_id is not null and ci.node_type_id='"+nodetypeids[j]+"' ")
				.append("and s.org_subjection_id like '@' group by sd.coding_name )data1 on base.label=data1.label)");
		}
		wutansb.append(" ) order by seq");
		for(int index=0;index<orgNames.length;index++){
			List wutanlist = jdbcDao.queryRecords(wutansb.toString().replaceAll("@", orgNames[index].split("-")[0]));
			
			if(wutanlist != null){
				Element category = categories.addElement("category");
				category.addAttribute("label", orgNames[index].split("-")[1]);
				
				for(int k=0;k<wutanlist.size();k++){
					Element set1 = datasets[k].addElement("set");
					if(Float.parseFloat((String)((Map)wutanlist.get(k)).get("value"))!=0){
						set1.addAttribute("color", "D1E8F9");
						set1.addAttribute("value", (String)((Map)wutanlist.get(k)).get("value"));
					}
				}
			}else{
				Element category = categories.addElement("category");
				category.addAttribute("label", orgNames[index].split("-")[1]);
				
				for(int k=0;k<nodetypes.length;k++){
					Element set1 = datasets[k].addElement("set");
				}
			}
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("xmldata", document.asXML());
		return msg;
	}
}
