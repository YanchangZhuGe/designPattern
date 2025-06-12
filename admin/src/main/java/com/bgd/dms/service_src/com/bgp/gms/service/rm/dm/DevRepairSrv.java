package com.bgp.gms.service.rm.dm;

import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.soap.SOAPException;

import net.sf.json.JSONArray;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.bgp.gms.service.rm.dm.util.StringUtil;
import com.bgp.mcs.service.util.mail.SimpleMailSender;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;

/**
 * project: 东方物探生产管理系统
 * 
 * creator: dz
 * 
 * creator time:2017-11-15
 * 
 * description:设备维修相关服务
 * 
 */
@Service("DevRepairSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class DevRepairSrv extends BaseService{
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private IWtcDevSrv wtcDevSrv = new WtcPubDevSrv();
	
	/**
	 * 设备维修信息查看
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevRepairList(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String devName = msg.getValue("devname");//设备名称
		String devModel = msg.getValue("devmodel");//规格型号
		String licenseNum = msg.getValue("licensenum");//牌照号
		String selfNum = msg.getValue("selfnum");//自编号
		String devSign = msg.getValue("devsign");//实物标识号
		String devCoding = msg.getValue("devcoding");//ERP编号
		String owningSubId = msg.getValue("owningsubid");//所属单位
		String repairPostion = msg.getValue("repairpostion");//维修单位
		String repairEr = msg.getValue("repairer");//承修人
		String acceptEr = msg.getValue("accepter");//验收人
		String aufNr = msg.getValue("aufnr");//工单号
		String repairDetail = msg.getValue("accepter");//维修详情
		String creatOr = msg.getValue("creator");//创建人
		String projectName = msg.getValue("projectname");//项目描述
		String humanCostStart = msg.getValue("humancoststart");//工时费开始金额
		String humanCostEnd = msg.getValue("humancostend");//工时费结束金额
		String materialCostStart = msg.getValue("materialcoststart");//材料费开始金额
		String materialCostEnd = msg.getValue("materialcosttend");//材料费结束金额
		String repairStartDateStart = msg.getValue("repairstartdatestart");//送修起始时间
		String repairStartDateEnd = msg.getValue("repairstartdateend");//送修结束时间
		String repairEndDateStart = msg.getValue("repairenddatestart");//验收起始时间
		String repairEndDateEnd = msg.getValue("repairenddateend");//验收结束时间
		String dataFrom = msg.getValue("datafrom");// 数据来源
		String repairType = msg.getValue("repairtype");// 维修类型
		String repairLevel = msg.getValue("repairlevel");// 维修级别
		String recordStatus = msg.getValue("recordstatus");// 单据状态
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer conditionSql = new StringBuffer();//条件SQL
		
		StringBuffer sumAvgStartSql = new StringBuffer();		
		sumAvgStartSql.append("select nvl(round(sum(human_cost),3),0) as sumhumancost,nvl(round(sum(material_cost),3),0) as summaterialcost,"
							+ " nvl(round(avg(human_cost),3),0) as avghumancost,nvl(round(avg(material_cost),3),0) as avgmaterialcost from (");
		StringBuffer sumAvgEndSql = new StringBuffer();
		sumAvgEndSql.append(" )");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select * from (select 'M' as msflag,info.repair_detail,acc.dev_name,org.org_name,info.accepter,"
				+ " case"
                + " when acc.owning_sub_id like 'C105001005%' then '塔里木物探处'"
                + " when acc.owning_sub_id like 'C105001002%' then '新疆物探处'"
                + " when acc.owning_sub_id like 'C105001003%' then '吐哈物探处'"
                + " when acc.owning_sub_id like 'C105001004%' then '青海物探处'"
                + " when acc.owning_sub_id like 'C105005004%' then '长庆物探处'"
                + " when acc.owning_sub_id like 'C105005000%' then '华北物探处'"
                + " when acc.owning_sub_id like 'C105005001%' then '新兴物探开发处'"
                + " when acc.owning_sub_id like 'C105007%' then '大港物探处'"
                + " when acc.owning_sub_id like 'C105063%' then '辽河物探处'"
                + " when acc.owning_sub_id like 'C105008%' then '综合物化处'"
                + " when acc.owning_sub_id like 'C105006%' then '装备服务处'"
                + " when acc.owning_sub_id like 'C105002%' then '国际勘探事业部'"
                + " when acc.owning_sub_id like 'C105003%' then '研究院'"
                + " when acc.owning_sub_id like 'C105015%' then '井中地震中心'"
                + " when acc.owning_sub_id like 'C105086%' then '深海物探处'"
                + " when acc.owning_sub_id like 'C105017%' then '矿区服务事业部'"
                + " when acc.owning_sub_id like 'C105014%' then '信息技术中心(中油瑞飞)'"
                + " when acc.owning_sub_id like 'C105016%' then '西安物探装备分公司'"
                + " when acc.owning_sub_id like 'C105005%' then '东方地球物理公司东部勘探'"
                + " when acc.owning_sub_id like 'C105075%' then '物探培训中心'"
                + " when acc.owning_sub_id like 'C105004%' then '物探技术研究中心'"
                + " when acc.owning_sub_id like 'C105078%' then '物资供应中心'"
                + " when acc.owning_sub_id like 'C105013%' then '采集技术支持部'"
                + " when acc.owning_sub_id like 'C105082%' then '油藏地球物理研究中心'"
                + " else org.org_abbreviation end as org_abbreviation,org.org_abbreviation as abbrevname,"
				+ " case when datafrom = 'YD' then '手持机' when datafrom = 'SAP' then 'SAP' else '平台录入' end as data_from_name,"		
				+ " acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,dtype.coding_name as repairtype,info.repair_info,"
				+ " ditem.coding_name as repairitem,dlevel.coding_name as repairlevel,info.repair_start_date,info.repair_postion,"
				+ " info.repair_end_date,info.repairer,info.human_cost,info.material_cost,info.project_name,"
				+ " info.bsflag,acc.owning_sub_id,acc.dev_type,acc.dev_coding,info.repair_type,info.record_status,info.datafrom,"
				+ " emp.employee_name,info.aufnr,info.repair_level"
				+ " from bgp_comm_device_repair_info info"
				+ " left join gms_device_account acc on acc.dev_acc_id = info.device_account_id"
				+ " left join comm_org_information org on org.org_id = acc.owning_org_id and org.bsflag = '0'"
				+ " left join comm_coding_sort_detail dtype on dtype.coding_code_id = info.repair_type"
				+ " left join comm_coding_sort_detail ditem on ditem.coding_code_id = info.repair_item"
				+ " left join comm_coding_sort_detail dlevel on dlevel.coding_code_id = info.repair_level"
				+ " left join comm_human_employee emp on emp.employee_id = info.creator"
				+ " union all"
				+ " select 'S' as msflag,info.repair_detail,acc.dev_name,org.org_name,info.accepter,"
				+ " case"
                + " when acc.owning_sub_id like 'C105001005%' then '塔里木物探处'"
                + " when acc.owning_sub_id like 'C105001002%' then '新疆物探处'"
                + " when acc.owning_sub_id like 'C105001003%' then '吐哈物探处'"
                + " when acc.owning_sub_id like 'C105001004%' then '青海物探处'"
                + " when acc.owning_sub_id like 'C105005004%' then '长庆物探处'"
                + " when acc.owning_sub_id like 'C105005000%' then '华北物探处'"
                + " when acc.owning_sub_id like 'C105005001%' then '新兴物探开发处'"
                + " when acc.owning_sub_id like 'C105007%' then '大港物探处'"
                + " when acc.owning_sub_id like 'C105063%' then '辽河物探处'"
                + " when acc.owning_sub_id like 'C105008%' then '综合物化处'"
                + " when acc.owning_sub_id like 'C105006%' then '装备服务处'"
                + " when acc.owning_sub_id like 'C105002%' then '国际勘探事业部'"
                + " when acc.owning_sub_id like 'C105003%' then '研究院'"
                + " when acc.owning_sub_id like 'C105015%' then '井中地震中心'"
                + " when acc.owning_sub_id like 'C105086%' then '深海物探处'"
                + " when acc.owning_sub_id like 'C105017%' then '矿区服务事业部'"
                + " when acc.owning_sub_id like 'C105014%' then '信息技术中心(中油瑞飞)'"
                + " when acc.owning_sub_id like 'C105016%' then '西安物探装备分公司'"
                + " when acc.owning_sub_id like 'C105005%' then '东方地球物理公司东部勘探'"
                + " when acc.owning_sub_id like 'C105075%' then '物探培训中心'"
                + " when acc.owning_sub_id like 'C105004%' then '物探技术研究中心'"
                + " when acc.owning_sub_id like 'C105078%' then '物资供应中心'"
                + " when acc.owning_sub_id like 'C105013%' then '采集技术支持部'"
                + " when acc.owning_sub_id like 'C105082%' then '油藏地球物理研究中心'"
                + " else org.org_abbreviation end as org_abbreviation,org.org_abbreviation as abbrevname,"
				+ " case when datafrom = 'YD' then '手持机' when datafrom = 'SAP' then 'SAP' else '平台录入' end as data_from_name,"		
				+ " acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,dtype.coding_name as repairtype,info.repair_info,"
				+ " ditem.coding_name as repairitem,dlevel.coding_name as repairlevel,info.repair_start_date,info.repair_postion,"
				+ " info.repair_end_date,info.repairer,info.human_cost,info.material_cost,info.project_name,"
				+ " info.bsflag,acc.owning_sub_id,acc.dev_type,acc.dev_coding,info.repair_type,info.record_status,info.datafrom,"
				+ " emp.employee_name,info.aufnr,info.repair_level"
				+ " from bgp_comm_device_repair_info info"
				+ " left join gms_device_account_dui dui on dui.dev_acc_id = info.device_account_id"
				+ " left join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id"
				+ " left join comm_org_information org on org.org_id = acc.owning_org_id and org.bsflag = '0'"
				+ " left join comm_coding_sort_detail dtype on dtype.coding_code_id = info.repair_type"
				+ " left join comm_coding_sort_detail ditem on ditem.coding_code_id = info.repair_item"
				+ " left join comm_coding_sort_detail dlevel on dlevel.coding_code_id = info.repair_level"
				+ " left join comm_human_employee emp on emp.employee_id = info.creator)"
				+ " where bsflag = '"+DevConstants.BSFLAG_NORMAL+"'"
				+ " and owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'");
		// 设备名称
		if (StringUtils.isNotBlank(devName)) {
			conditionSql.append(" and dev_name like '%"+devName+"%'");
		}
		// 规格型号
		if (StringUtils.isNotBlank(devModel)) {
			conditionSql.append(" and dev_model like '%"+devModel+"%'");
		}
		// 牌照号
		if (StringUtils.isNotBlank(licenseNum)) {
			conditionSql.append(" and license_num like '%"+licenseNum+"%'");
		}
		// 自编号
		if (StringUtils.isNotBlank(selfNum)) {
			conditionSql.append(" and self_num like '%"+selfNum+"%'");
		}
		// 实物标识号
		if (StringUtils.isNotBlank(devSign)) {
			conditionSql.append(" and dev_sign like '%"+devSign+"%'");
		}
		// ERP编号
		if (StringUtils.isNotBlank(devCoding)) {
			conditionSql.append(" and dev_coding like '%"+devCoding+"%'");
		}
		// 所属单位名称
		if (StringUtils.isNotBlank(owningSubId)) {
			conditionSql.append(" and owning_sub_id like '%"+owningSubId+"%'");
		}
		// 维修单位
		if (StringUtils.isNotBlank(repairPostion)) {
			conditionSql.append(" and repair_postion like '%"+repairPostion+"%'");
		}
		// 承修人
		if (StringUtils.isNotBlank(repairEr)) {
			conditionSql.append(" and repairer like '%"+repairEr+"%'");
		}
		// 验收人
		if (StringUtils.isNotBlank(acceptEr)) {
			conditionSql.append(" and accepter like '%"+acceptEr+"%'");
		}
		// 创建人
		if (StringUtils.isNotBlank(creatOr)) {
			conditionSql.append(" and employee_name like '%"+creatOr+"%'");
		}
		// 项目描述
		if (StringUtils.isNotBlank(projectName)) {
			conditionSql.append(" and project_name like '%"+projectName+"%'");
		}
		// 工单号
		if (StringUtils.isNotBlank(aufNr)) {
			conditionSql.append(" and aufnr like '%"+aufNr+"%'");
		}
		// 维修详情
		if (StringUtils.isNotBlank(repairDetail)) {
			conditionSql.append(" and repair_detail like '%"+repairDetail+"%'");
		}
		//工时费
		if(StringUtils.isNotBlank(humanCostStart) && StringUtils.isNotBlank(humanCostEnd)){
			conditionSql.append(" and human_cost >= '"+humanCostStart+"' and human_cost <= '"+humanCostEnd+"'");
		}
		if(StringUtils.isNotBlank(humanCostStart) && StringUtils.isBlank(humanCostEnd)){
			conditionSql.append(" and human_cost >= '"+humanCostStart+"'");
		}
		if(StringUtils.isBlank(humanCostStart) && StringUtils.isNotBlank(humanCostEnd)){
			conditionSql.append(" and human_cost <= '"+humanCostEnd+"'");
		}
		//材料费
		if(StringUtils.isNotBlank(materialCostStart) && StringUtils.isNotBlank(materialCostEnd)){
			conditionSql.append(" and material_cost >= '"+materialCostStart+"' and material_cost <= '"+materialCostEnd+"'");
		}
		if(StringUtils.isNotBlank(materialCostStart) && StringUtils.isBlank(materialCostEnd)){
			conditionSql.append(" and material_cost >= '"+materialCostStart+"'");
		}
		if(StringUtils.isBlank(materialCostStart) && StringUtils.isNotBlank(materialCostEnd)){
			conditionSql.append(" and material_cost <= '"+materialCostEnd+"'");
		}
		//送修日期
		if(StringUtils.isNotBlank(repairStartDateStart) && StringUtils.isNotBlank(repairStartDateEnd)){
			conditionSql.append(" and repair_start_date >= to_date('"+repairStartDateStart+"','yyyy-mm-dd')"
								+ " and repair_start_date <= to_date('"+repairStartDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(repairStartDateStart) && StringUtils.isBlank(repairStartDateEnd)){
			conditionSql.append(" and repair_start_date >= to_date('"+repairStartDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(repairStartDateStart) && StringUtils.isNotBlank(repairStartDateEnd)){
			conditionSql.append(" and repair_start_date <= to_date('"+repairStartDateEnd+"','yyyy-mm-dd')");
		}
		//验收日期
		if(StringUtils.isNotBlank(repairEndDateStart) && StringUtils.isNotBlank(repairEndDateEnd)){
			conditionSql.append(" and repair_end_date >= to_date('"+repairEndDateStart+"','yyyy-mm-dd')"
								+ " and repair_end_date <= to_date('"+repairEndDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(repairEndDateStart) && StringUtils.isBlank(repairEndDateEnd)){
			conditionSql.append(" and repair_end_date >= to_date('"+repairEndDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(repairEndDateStart) && StringUtils.isNotBlank(repairEndDateEnd)){
			conditionSql.append(" and repair_end_date <= to_date('"+repairEndDateEnd+"','yyyy-mm-dd')");
		}
		// 数据来源
		if (StringUtils.isNotBlank(dataFrom)&&!"请选择...".equals(dataFrom)) {
			conditionSql.append(" and datafrom = '"+dataFrom+"'");	
		}
		// 维修类型
		if (StringUtils.isNotBlank(repairType)&&!"请选择...".equals(repairType)) {
			conditionSql.append(" and repair_type = '"+repairType+"'");	
		}
		// 维修级别
		if (StringUtils.isNotBlank(repairLevel)&&!"请选择...".equals(repairLevel)) {
			conditionSql.append(" and repair_level = '"+repairLevel+"'");	
		}
		// 单据状态
		if (StringUtils.isNotBlank(recordStatus)&&!"请选择...".equals(recordStatus)) {
			conditionSql.append(" and record_status = '"+recordStatus+"'");	
		}
		if(StringUtils.isNotBlank(sortField)){
			conditionSql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			conditionSql.append(" order by repair_start_date desc,dev_type,owning_sub_id,repair_info");
		}
		querySql.append(conditionSql);
		sumAvgStartSql.append(querySql).append(sumAvgEndSql);
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		List pageFooter = new ArrayList();
		Map sumFooter = new HashMap();
		Map avgFooter = new HashMap();
		Map sumAvgMap = jdbcDao.queryRecordBySQL(sumAvgStartSql.toString());
		if(MapUtils.isNotEmpty(sumAvgMap)){
			sumFooter.put("human_cost", sumAvgMap.get("sumhumancost"));
			sumFooter.put("material_cost", sumAvgMap.get("summaterialcost"));
			if(user.getSubOrgIDofAffordOrg().equals(DevConstants.COMM_COM_ORGSUBID)){
				sumFooter.put("org_abbreviation", "合计(元)");
				avgFooter.put("org_abbreviation", "平均(元)");
			}else{
				sumFooter.put("abbrevname", "合计(元)");
				avgFooter.put("abbrevname", "平均(元)");
			}
			avgFooter.put("human_cost", sumAvgMap.get("avghumancost"));
			avgFooter.put("material_cost", sumAvgMap.get("avgmaterialcost"));			
			pageFooter.add(avgFooter);
			pageFooter.add(sumFooter);
		}
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		responseDTO.setValue("footer", pageFooter);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 设备维修信息主页面信息显示
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevRepairMainInfo(ISrvMsg reqDTO) throws Exception {		
		String repairInfo = reqDTO.getValue("repairinfo");
		String msFlag = reqDTO.getValue("msflag");//区别单项目录入还是多项目录入的维修保养记录
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer startSql = new StringBuffer()
				.append("select acc.dev_name,acc.dev_model,acc.self_num,org.org_name,info.accepter,emp.employee_name,"
						+ "	dstatus.coding_name as record_status_desc,acc.dev_coding,info.project_name,"
						+ " case when datafrom = 'YD' then '手持机' when datafrom = 'SAP' then 'SAP' else '平台录入' end as data_from_name,"		
						+ " acc.license_num,acc.dev_sign,dtype.coding_name as repairtype,info.repair_detail,info.repair_postion,"
						+ " ditem.coding_name as repairitem,dlevel.coding_name as repairlevel,info.repair_start_date,"
						+ " info.repair_end_date,info.repairer,info.human_cost,info.material_cost,info.aufnr"
						+ " from bgp_comm_device_repair_info info");
		StringBuffer middleSql = new StringBuffer();
		if(DevUtil.isValueNotNull(msFlag,"M")){//多项目录入
			middleSql.append(" left join gms_device_account acc on acc.dev_acc_id = info.device_account_id");
		}else{//单项目录入
			middleSql.append(" left join gms_device_account_dui dui on dui.dev_acc_id = info.device_account_id"
						   + " left join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id");
		}
		StringBuffer endSql = new StringBuffer()
				.append(" left join comm_org_information org on org.org_id = acc.owning_org_id and org.bsflag = '0'"
					  + " left join comm_coding_sort_detail dtype on dtype.coding_code_id = info.repair_type"
					  + " left join comm_coding_sort_detail ditem on ditem.coding_code_id = info.repair_item"
					  + " left join comm_coding_sort_detail dlevel on dlevel.coding_code_id = info.repair_level"
					  + " left join comm_coding_sort_detail dstatus on dstatus.coding_code_id = info.record_status"
					  + " left join comm_human_employee emp on emp.employee_id = info.creator"
					  + " where info.repair_info = '"+repairInfo+"'");
		Map repairMap = jdbcDao.queryRecordBySQL(startSql.append(middleSql).append(endSql).toString());
		if (MapUtils.isNotEmpty(repairMap)) {
			responseMsg.setValue("data", repairMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD 设备维修消耗备件明细
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevRepairDet(ISrvMsg msg) throws Exception {	
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String repairInfo = msg.getValue("repairinfo");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.repair_detail_id,d.material_name,d.material_coding,"
					  + " d.unit_price,d.material_amout,d.total_charge,d.name_text,"
					  + " d.material_unit,det.coding_name as repairitemname"
					  + " from bgp_comm_device_repair_detail d"
					  + " left join comm_coding_sort_detail det on d.repair_item = det.coding_code_id"
					  + " where d.repair_info = '"+repairInfo+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.create_date desc,d.repair_detail_id");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
}
