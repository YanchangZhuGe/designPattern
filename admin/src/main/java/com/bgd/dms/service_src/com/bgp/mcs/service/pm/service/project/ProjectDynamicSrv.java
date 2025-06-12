package com.bgp.mcs.service.pm.service.project;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class ProjectDynamicSrv  extends BaseService {

	public ISrvMsg queryDynamicProject(ISrvMsg reqDTO) throws Exception {
		//国内动态项目
		String orgSubId = reqDTO.getValue("orgSubId");
		String country = reqDTO.getValue("country");
		
		StringBuffer message = new StringBuffer();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("select distinct p.project_info_no, p.project_name, w.focus_x, w.focus_y, p.project_status, p.project_type");
		sql.append(" from  Gp_Task_Project p inner join gp_workarea_diviede w on p.workarea_no = w.workarea_no");
		sql.append(" left join Gp_Task_Project_Dynamic d on d.project_info_no = p.project_info_no");
		sql.append(" where d.bsflag = '0' and d.org_id != 'C6000000007048' and p.bsflag = '0'");
		sql.append(" and p.project_status in ('5000100001000000001','5000100001000000002','5000100001000000004')");
		sql.append(" and w.focus_x is not null and w.focus_y is not null ");
		sql.append(" and p.project_country = '").append(country).append("'");
		sql.append(" and d.org_Subjection_Id like '").append(orgSubId).append("%'");
		
		List<Map> projectList = null;
		
		try{
			projectList = jdbcDAO.queryRecords(sql.toString());
		}catch(Exception e){
			message.append("表名或查询条件字段不存在!");
		}
		responseMsg.setValue("projectList", projectList);
		return responseMsg;
	}
	
	public ISrvMsg getProjectSiuation(ISrvMsg reqDTO) throws Exception {
		//项目情况统计
		UserToken user = reqDTO.getUserToken();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String curDate = reqDTO.getValue("curDate");
		String startDate = reqDTO.getValue("startDate");
		String endDate = reqDTO.getValue("endDate");
		
		String orgSubIdofAff = user.getSubOrgIDofAffordOrg();
		
		//获取统计单位
		DBDataService dbDataSrv = new DBDataService();
		List<Map> orgList = dbDataSrv.getOrganization(orgSubIdofAff);
		
		if(orgList != null){
			// 获取项目统计数
			List<Map> projectRunList = getProjectRunNum(startDate, endDate);
			List<Map> todayFinishList = getTodayFinishNum(curDate);
			List<Map> cumulativeFinishList = getCumulativeFinishNum(startDate, endDate);
			List<Map> projectStatistics = new ArrayList<Map>();
			
			long sumProjectEndNums=0;
			long sumProjectRunNums = 0;
			long sumProjectPauseNums = 0;
			long sumProjectReadyNums = 0;
			long sumProjectTotalNums = 0;
			long sumTodayFinish2dNums = 0;
			long sumTodayFinish3dNums = 0;
			double sumCumlativeFinish2dNums = 0;
			double sumCumlativeFinish3dNums = 0;
			
			long sumTodayFinish2dSPNums = 0;
			long sumTodayFinish3dSPNums = 0;
			long sumCumlativeFinish2dSPNums = 0;
			long sumCumlativeFinish3dSPNums = 0;
			
			for(int i=0; i < orgList.size(); i++){
				Map map = orgList.get(i);
				String orgName = (String)map.get("org_name");
				String orgCode = (String)map.get("org_sub_id");
				Map lineStatistics = new HashMap();
				
				// 结束
				long  projectEndNums = 0;
				// 运行
				long  projectRunNums = 0;
				// 暂停
				long  projectPauseNums = 0;
				// 准备
				long  projectReadyNums = 0;
				// 共计
				long  projectTotalNums = 0;
				// 当日完成二维数
				long  todayFinish2dNums = 0;
				// 当日完成三维数
				long  todayFinish3dNums = 0;
				// 累积完成二维数
				double  cumlativeFinish2dNums = 0;
				// 累积完成三维数
				double  cumlativeFinish3dNums = 0;
				
				long  todayFinish2dSPNums = 0;
				long  todayFinish3dSPNums = 0;
				long  cumlativeFinish2dSPNums = 0;
				long  cumlativeFinish3dSPNums = 0;
				// 运作项目个数计算
				if(projectRunList != null){
					for(int k=0; k < projectRunList.size(); k++){
						Map project = projectRunList.get(k);
						String orgSubId = (String) project.get("org_sub_id");
						String status = (String) project.get("ifbuild");
						//String sNum = (String) project.get("num");
						if(orgSubId.contains(orgCode)){
							//long lNum = new Long(sNum);
							if("5000100001000000003".equals(status)){
								projectEndNums ++;
							}else if("5000100001000000004".equals(status)){
								projectPauseNums ++;
							}else if("5000100001000000001".equals(status)){
								projectReadyNums ++;
							}else{
								projectRunNums ++;
							}
						}
					}
					projectTotalNums = projectEndNums + projectPauseNums + projectReadyNums + projectRunNums;
				}
				// 当日完成数计算
				if(todayFinishList != null){
					for(int k=0; k < todayFinishList.size(); k++){
						Map project = todayFinishList.get(k);
						String orgSubId = (String) project.get("org_sub_id");
						String sNum2 = (String) project.get("num2");
						String sNum3 = (String) project.get("num3");
						String spNum2 = (String) project.get("daily_finishing_2d_sp");
						String spNum3 = (String) project.get("daily_finishing_3d_sp");
						if(orgSubId.contains(orgCode)){
							double lNum2 = new Double(sNum2);
							double lNum3 = new Double(sNum3);
							long lspNum2 = new Long(spNum2);
							long lspNum3 = new Long(spNum3);
							todayFinish2dNums += lNum2;
							todayFinish3dNums += lNum3;
							todayFinish2dSPNums += lspNum2;
							todayFinish3dSPNums += lspNum3;
						}
					}
				}
				// 累积完成数计算
				if(cumulativeFinishList != null){
					for(int k=0; k < cumulativeFinishList.size(); k++){
						Map project = cumulativeFinishList.get(k);
						String orgSubId = (String) project.get("org_sub_id");
						String sNum2 = (String) project.get("num2");
						String sNum3 = (String) project.get("num3");
						String spNum2 = (String) project.get("daily_finishing_2d_sp");
						String spNum3 = (String) project.get("daily_finishing_3d_sp");
						if(orgSubId.contains(orgCode)){
							double lNum2 = new Double(sNum2);
							double lNum3 = new Double(sNum3);
							long lspNum2 = new Long(spNum2);
							long lspNum3 = new Long(spNum3);
							cumlativeFinish2dNums += lNum2;
							cumlativeFinish3dNums += lNum3;
							cumlativeFinish2dSPNums += lspNum2;
							cumlativeFinish3dSPNums += lspNum3;
						}
					}
				}
				lineStatistics.put("orgName", orgName);
				lineStatistics.put("orgCode", orgCode);
				lineStatistics.put("projectEndNums", projectEndNums);
				lineStatistics.put("projectRunNums", projectRunNums);
				lineStatistics.put("projectPauseNums", projectPauseNums);
				lineStatistics.put("projectReadyNums", projectReadyNums);
				lineStatistics.put("projectTotalNums", projectTotalNums);
				lineStatistics.put("todayFinish2dNums", todayFinish2dNums);
				lineStatistics.put("todayFinish3dNums", todayFinish3dNums);
				lineStatistics.put("cumlativeFinish2dNums", cumlativeFinish2dNums);
				lineStatistics.put("cumlativeFinish3dNums", cumlativeFinish3dNums);
				
				lineStatistics.put("todayFinish2dSPNums", todayFinish2dSPNums);
				lineStatistics.put("todayFinish3dSPNums", todayFinish3dSPNums);
				lineStatistics.put("cumlativeFinish2dSPNums", cumlativeFinish2dSPNums);
				lineStatistics.put("cumlativeFinish3dSPNums", cumlativeFinish3dSPNums);
				
				
				// 计算所有的行
				projectStatistics.add(lineStatistics);
				sumProjectEndNums += projectEndNums;
				sumProjectRunNums += projectRunNums;
				sumProjectPauseNums += projectPauseNums;
				sumProjectReadyNums += projectReadyNums;
				sumProjectTotalNums += projectTotalNums;
				sumTodayFinish2dNums += todayFinish2dNums;
				sumTodayFinish3dNums += todayFinish3dNums;
				sumCumlativeFinish2dNums += cumlativeFinish2dNums;
				sumCumlativeFinish3dNums += cumlativeFinish3dNums;
				
				sumTodayFinish2dSPNums += todayFinish2dSPNums;
				sumTodayFinish3dSPNums += todayFinish3dSPNums;
				sumCumlativeFinish2dSPNums += cumlativeFinish2dSPNums;
				sumCumlativeFinish3dSPNums += cumlativeFinish3dSPNums;
			}
			Map sumStatistics = new HashMap();
			sumStatistics.put("orgName", "公司总计");
			sumStatistics.put("orgCode", "C105");
			sumStatistics.put("projectEndNums", sumProjectEndNums);
			sumStatistics.put("projectRunNums", sumProjectRunNums);
			sumStatistics.put("projectPauseNums", sumProjectPauseNums);
			sumStatistics.put("projectReadyNums", sumProjectReadyNums);
			sumStatistics.put("projectTotalNums", sumProjectTotalNums);
			sumStatistics.put("todayFinish2dNums", sumTodayFinish2dNums);
			sumStatistics.put("todayFinish3dNums", sumTodayFinish3dNums);
			sumStatistics.put("cumlativeFinish2dNums", sumCumlativeFinish2dNums);
			sumStatistics.put("cumlativeFinish3dNums", sumCumlativeFinish3dNums);
			
			sumStatistics.put("todayFinish2dSPNums", sumTodayFinish2dSPNums);
			sumStatistics.put("todayFinish3dSPNums", sumTodayFinish3dSPNums);
			sumStatistics.put("cumlativeFinish2dSPNums", sumCumlativeFinish2dSPNums);
			sumStatistics.put("cumlativeFinish3dSPNums", sumCumlativeFinish3dSPNums);
			projectStatistics.add(sumStatistics);
			
			String dataXml1 = dataToXML(projectStatistics,"1");
			String dataXml2 = dataToXML(projectStatistics,"2");
			
			int p_start = dataXml1.indexOf("<chart");
			dataXml1 = dataXml1.substring(p_start, dataXml1.length());
			
			p_start = dataXml2.indexOf("<chart");
			dataXml2 = dataXml2.substring(p_start, dataXml2.length());
			
			responseMsg.setValue("Str1", dataXml1);
			responseMsg.setValue("Str2", dataXml2);
			responseMsg.setValue("projectStatistics", projectStatistics);
			
		}
		
		return responseMsg;
	}
	
	private List<Map> getProjectRunNum(String startDate, String endDate){
		//获取项目运作个数
		StringBuffer message = new StringBuffer();
//		StringBuffer sql = new StringBuffer("select * from ( select work_status as ifBuild ");
//		sql.append(" ,project_info_no as num,org_subjection_id as org_sub_id ");
//		sql.append(" ,row_number() over(partition by project_info_no order by send_date desc) rowl ");
//		sql.append(" from rpt_gp_daily where send_date >= to_date('" + startDate + "', 'yyyy-MM-dd')");
//		sql.append(" and send_date <= to_date('" + endDate + "','yyyy-MM-dd') and bsflag = '0'");
//		sql.append(" ) where rowl = 1");
		
		
		
		StringBuffer sql = new StringBuffer("select gp.project_status as ifBuild ,gp.project_info_no as num,pd.org_subjection_id as org_sub_id");
		sql.append(" from gp_task_project gp join gp_task_project_dynamic pd on pd.project_info_no = gp.project_info_no and pd.bsflag = '0' where gp.bsflag='0'");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try{
			resultList = jdbcDAO.queryRecords(sql.toString());
		}catch(Exception e){
			message.append("表名或查询条件字段不存在!");
		}
		return resultList;
	}
	
	private List<Map> getTodayFinishNum(String curDate){
		//获取当日完成数
		StringBuffer message = new StringBuffer();
		StringBuffer sql = new StringBuffer(" select sum(nvl(r.finish_2d_workload,0)) as num2,sum(nvl(r.finish_3d_workload,0)) as num3 ");
		sql.append(" ,sum(nvl(r.daily_finishing_2d_sp,0)) as daily_finishing_2d_sp,sum(nvl(r.daily_finishing_3d_sp,0)) as daily_finishing_3d_sp ");
		sql.append(" ,r.org_subjection_id as org_sub_id ");
		sql.append(" from rpt_gp_daily r ");
		sql.append(" where r.send_date = to_date('" + curDate + "','yyyy-MM-dd') ");
		sql.append(" and r.bsflag = '0'");
		sql.append(" group by r.org_subjection_id");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try{
			resultList = jdbcDAO.queryRecords(sql.toString());
		}catch(Exception e){
			message.append("表名或查询条件字段不存在!");
		}
		return resultList;
	}
	
	private List<Map> getCumulativeFinishNum(String startDate, String endDate){
		//获取累积完成数
		StringBuffer message = new StringBuffer();
		StringBuffer sql = new StringBuffer("select sum(nvl(r.finish_2d_workload,0)) as num2,sum(nvl(r.finish_3d_workload,0)) as num3 ");
		sql.append(" ,sum(nvl(r.daily_finishing_2d_sp,0)) as daily_finishing_2d_sp,sum(nvl(r.daily_finishing_3d_sp,0)) as daily_finishing_3d_sp ");
		sql.append(" ,r.org_subjection_id as org_sub_id ");
		sql.append(" from rpt_gp_daily r ");
		sql.append(" where r.send_date >= to_date('" + startDate + "','yyyy-MM-dd') ");
		sql.append(" and r.send_date <= to_date('" + endDate + "','yyyy-MM-dd') ");
		
		sql.append(" and r.bsflag = '0'");
		sql.append(" group by r.org_subjection_id");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> resultList = null;
		try{
			resultList = jdbcDAO.queryRecords(sql.toString());
		}catch(Exception e){
			message.append("表名或查询条件字段不存在!");
		}
		return resultList;
	}
	
	private String dataToXML(List<Map> list,String dataType){
		String resultXML = "";
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("caption", "");
		root.addAttribute("yAxisName", "公里数千米");
		root.addAttribute("rotateYAxisName", "0");
		root.addAttribute("yAxisNameWidth", "16");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("labelDisplay", "none");
		root.addAttribute("showLabels", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("palette", "2");
		root.addAttribute("legendPosition", "RIGHT");
		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		Element dataset2 = root.addElement("dataset");
		if(!"1".equals(dataType)){
			dataset1.addAttribute("seriesName", "二维累计");
			dataset2.addAttribute("seriesName", "三维累计");
		}
		if(list != null){
			for(int i=0; i< list.size(); i++){
				Map map = list.get(i);
				String orgName = (String)map.get("orgName");
				String orgCode = (String)map.get("orgCode");
				if("1".equals(dataType)){
					//国际部
					if(!"国际部".equals(orgName)){
						continue;
					}
				}else{
					//
					if("国际部".equals(orgName) || "公司总计".equals(orgName)){
						continue;
					}
				}		
				
				Element category = categories.addElement("category");
				category.addAttribute("label", orgName);
				
				//二维累积
				String data1 = "" + map.get("cumlativeFinish2dNums");
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("link", "j-inBrowse('"+orgCode+"')");
				set1.addAttribute("value", data1);
				set1.addAttribute("showValue", "1");
				
				//三维累积
				String data2 = "" + map.get("cumlativeFinish3dNums");
				Element set2 = dataset2.addElement("set");
				set2.addAttribute("link", "j-inBrowse('"+orgCode+"')");
				set2.addAttribute("value", data2);
				set2.addAttribute("showValue", "1");
			}
		}
		resultXML = document.asXML();
		return resultXML;
	}
}
