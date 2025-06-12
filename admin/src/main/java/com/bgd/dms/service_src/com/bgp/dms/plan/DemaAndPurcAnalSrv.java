package com.bgp.dms.plan;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.bgp.dms.util.CommonData;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 
 * @author dushuai
 * 需求计划采购计划统计分析服务
 */
public class DemaAndPurcAnalSrv extends BaseService {

	public DemaAndPurcAnalSrv() {
		log = LogFactory.getLogger(DemaAndPurcAnalSrv.class);
	}

	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	/**
	 * 获取表格数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTableData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// 年度
		String year = isrvmsg.getValue("year");
		StringBuilder sql = new StringBuilder();
		sql.append("select t.org_subjection_id, inf.org_abbreviation, t.mtotal, t.ptotal from ("
				 + " select t1.mtotal,t2.ptotal,case when t1.de_org_subjection_id is not null"
				 + " then t1.de_org_subjection_id else t2.pd_org_subjection_id end as org_subjection_id from ("
				 + " select nvl(sum(de.apply_number*de.asse_price),0) as mtotal,ap.org_subjection_id as de_org_subjection_id"
				 + " from dms_exeplan_apply_detail de"
				 + " left join dms_exeplan_apply ap on ap.apply_id = de.apply_id"
				 + " where de.bsflag = '0' and ap.bsflag = '0' and de.org_subjection_id is not null");
		// 年度
		if (StringUtils.isNotBlank(year)) {
			sql.append(" and ap.apply_year = '" + year + "'");
		}
		sql.append(" group by ap.org_subjection_id ) t1 full join (select nvl(sum(pd.amount*pd.price),0) as ptotal,"
				 + " mp.father_sub_id as pd_org_subjection_id from dms_exeplan_purc_detail pd"
				 + " left join dms_exeplan_purc pu on pu.purc_id = pd.purc_id"
				 + " left join bgp_comm_sap_org_mapper mp on pd.org_id = mp.org_id and mp.bsflag = '0'"
				 + " where pd.bsflag = '0' and pu.bsflag = '0' and pd.org_subjection_id is not null");
		// 年度
		if (StringUtils.isNotBlank(year)) {
			sql.append(" and pu.purc_year  = '" + year + "'");
		}
		sql.append("group by mp.father_sub_id ) t2 on t1.de_org_subjection_id = t2.pd_org_subjection_id) t"
				+ " left join comm_org_subjection sub on t.org_subjection_id=sub.org_subjection_id and sub.bsflag='0'"
				+ " left join comm_org_information inf on sub.org_id=inf.org_id and inf.bsflag='0'"
				+ " order by sub.org_subjection_id,sub.coding_show_id");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * 查询需求采购计划信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDemaPurcInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryDemaPurcInfoList");
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
		String year = isrvmsg.getValue("year");// 年度
		String orgSubId = isrvmsg.getValue("orgSubId");// 物探处
		String tableFlag = isrvmsg.getValue("tableFlag");// 标示
		StringBuffer querySql = new StringBuffer();
		//查询需求计划
		if("demand".equals(tableFlag)){
			querySql.append("select ap.apply_num,ap.apply_year,de.apply_dnum,de.dev_name,de.dev_type,de.meas_unit,de.apply_number," 
					+ " de.asse_price,inf.org_abbreviation as org_name,nvl(de.apply_number*de.asse_price,0) as mtotal"
					+ " from dms_exeplan_apply_detail de left join dms_exeplan_apply ap on ap.apply_id = de.apply_id"
					+ " left join comm_org_subjection sub on de.org_subjection_id = sub.org_subjection_id and sub.bsflag='0'"
					+ " left join comm_org_information inf on sub.org_id = inf.org_id and inf.bsflag='0'"
					+ " where ap.bsflag = '0' and de.bsflag = '0'");
			// 年度
			if (StringUtils.isNotBlank(year)) {
				querySql.append(" and ap.apply_year = '" + year + "'");
			}
			// 物探处
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and de.org_subjection_id = '" + orgSubId + "'");
			}
			querySql.append(" order by sub.org_subjection_id,sub.coding_show_id,ap.order_type desc,ap.is_gene,ap.fill_date desc");
			page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		}
		//查询采购计划
		if("purchase".equals(tableFlag)){
			querySql.append("select pu.purc_num,pu.purc_year,ad.apply_num,pd.material_code,pd.material_desc,pd.unit,pd.amount," 
					+ " pd.price,inf.org_abbreviation as org_name,nvl(pd.amount*pd.price,0) as ptotal"
					+ " from dms_exeplan_purc_detail pd left join dms_exeplan_purc pu on pu.purc_id = pd.purc_id"
					+ " left join dms_exeplan_apply_detail ad on pd.exeplan_detail_id=ad.detail_id and ad.bsflag='0'"
					+ " left join comm_org_subjection sub on pd.org_subjection_id = sub.org_subjection_id and sub.bsflag='0'"
					+ " left join comm_org_information inf on sub.org_id = inf.org_id and inf.bsflag='0'"
					+ " where pd.bsflag = '0' and pu.bsflag = '0'");
			// 年度
			if (StringUtils.isNotBlank(year)) {
				querySql.append(" and pu.purc_year = '" + year + "'");
			}
			// 物探处
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and pd.org_subjection_id = '" + orgSubId + "'");
			}
			querySql.append(" order by sub.org_subjection_id,sub.coding_show_id,pu.order_type desc,pu.appstate,pu.fill_date desc");
			page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		}
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	public ISrvMsg getAnalysisData(ISrvMsg isrvMsg) throws Exception {
		log.info("getAnalysisData");
		UserToken user = isrvMsg.getUserToken();
		String args=isrvMsg.getValue("args");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvMsg);
		
		CommonData comData=new CommonData();
		List tmp1=comData.getData("device_demand_num", args);
		responseDTO.setValue("datas", tmp1);
		responseDTO.setValue("totalRows", 1);
		responseDTO.setValue("pageSize", 1);
		return responseDTO;
	}
	
}
