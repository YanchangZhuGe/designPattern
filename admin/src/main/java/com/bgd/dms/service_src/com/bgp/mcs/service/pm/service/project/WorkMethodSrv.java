package com.bgp.mcs.service.pm.service.project;

import java.io.Serializable;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.common.DateOperation;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class WorkMethodSrv  extends BaseService {

	private IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
	RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	
	public ISrvMsg saveWork2Method(ISrvMsg reqDTO) throws Exception{
		
		Map map = reqDTO.toMap();
		
		UserToken user = reqDTO.getUserToken();
		String wa2dID = reqDTO.getValue("wa2d_id");
		if(wa2dID == null || "".equals(wa2dID)){
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
		}
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		
		Serializable work_method_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_wa2d_method_data");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	public ISrvMsg saveWork3Method(ISrvMsg reqDTO) throws Exception{
		Map map = reqDTO.toMap();
		UserToken user = reqDTO.getUserToken();
		String wa3dID = reqDTO.getValue("wa3d_id");
		if(wa3dID == null || "".equals(wa3dID)){
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
		}
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		
		Serializable work_method_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_wa3d_method_data");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	/**
	 * 获取二维施工方法
	 * @throws Exception
	 */
	public ISrvMsg getWork2Method(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("projectInfoNo");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer mainDataSql = new StringBuffer("select * from gp_ops_2dwa_design_basic_data");
		mainDataSql.append(" where project_info_no='").append(project_info_no).append("'");
		
		StringBuffer fromDataSql = new StringBuffer("select * from gp_ops_2dwa_design_data_from");
		fromDataSql.append(" where project_info_no='").append(project_info_no).append("' and bsflag='0' ");
		fromDataSql.append(" order by section_type,order_num");
		
		Map mainData = jdbcDAO.queryRecordBySQL(mainDataSql.toString());
		List<Map> allFromData = jdbcDAO.queryRecords(fromDataSql.toString());
		
		List<Map> layoutData = new ArrayList<Map>();
		List<Map> spData = new ArrayList<Map>();
		List<Map> sourceData = new ArrayList<Map>();
		List<Map> geophoneData = new ArrayList<Map>();
		List<Map> instrumentData = new ArrayList<Map>();
		List<Map> qqData = new ArrayList<Map>();
		
		//数据段类型,1:观测系统;2:井炮参数;3:震源参数;4:检波器参数;5:仪器参数;6:气枪参数
		if(allFromData != null){
			for(int i=0; i<allFromData.size(); i++){
				Map map = allFromData.get(i);
				String sectionType = "" + map.get("section_type");
				if("1".equals(sectionType)){
					layoutData.add(map);
				}else if("2".equals(sectionType)){
					spData.add(map);
				}else if("3".equals(sectionType)){
					sourceData.add(map);
				}else if("4".equals(sectionType)){
					geophoneData.add(map);
				}else if("5".equals(sectionType)){
					instrumentData.add(map);
				}else if("6".equals(sectionType)){
					qqData.add(map);
				}
			}			
		}
		
		responseMsg.setValue("mainData", mainData);
		responseMsg.setValue("layoutData", layoutData);
		responseMsg.setValue("spData", spData);
		responseMsg.setValue("sourceData", sourceData);
		responseMsg.setValue("geophoneData", geophoneData);
		responseMsg.setValue("instrumentData", instrumentData);
		responseMsg.setValue("qqData", qqData);
		return responseMsg;
	}
	
	/**
	 * 获取三维施工方法
	 * @throws Exception
	 */
	public ISrvMsg getWork3Method(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("projectInfoNo");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer mainDataSql = new StringBuffer("select * from gp_ops_3dwa_design_data");
		mainDataSql.append(" where project_info_no='").append(project_info_no).append("'");
		
		StringBuffer fromDataSql = new StringBuffer("select * from gp_ops_3dwa_design_data_from");
		fromDataSql.append(" where project_info_no='").append(project_info_no).append("' and bsflag='0' ");
		fromDataSql.append(" order by section_type,order_num");
		
		Map mainData = jdbcDAO.queryRecordBySQL(mainDataSql.toString());
		List<Map> allFromData = jdbcDAO.queryRecords(fromDataSql.toString());
		
		List<Map> layoutData = new ArrayList<Map>();
		List<Map> spData = new ArrayList<Map>();
		List<Map> sourceData = new ArrayList<Map>();
		List<Map> geophoneData = new ArrayList<Map>();
		List<Map> instrumentData = new ArrayList<Map>();
		
		//数据段类型,1:观测系统;2:井炮参数;3:震源参数;4:检波器参数;5:仪器参数     
		//浅海 滩浅海 新增数据段类型 6：气枪
		List<Map> airgunData = new ArrayList<Map>();
		
		
		if(allFromData != null){
			for(int i=0; i<allFromData.size(); i++){
				Map map = allFromData.get(i);
				String sectionType = "" + map.get("section_type");
				if("1".equals(sectionType)){
					layoutData.add(map);
				}else if("2".equals(sectionType)){
					spData.add(map);
				}else if("3".equals(sectionType)){
					sourceData.add(map);
				}else if("4".equals(sectionType)){
					geophoneData.add(map);
				}else if("5".equals(sectionType)){
					instrumentData.add(map);
				}else if("6".equals(sectionType)){
					airgunData.add(map);
				}
			}			
		}
		
		responseMsg.setValue("mainData", mainData);
		responseMsg.setValue("layoutData", layoutData);
		responseMsg.setValue("spData", spData);
		responseMsg.setValue("sourceData", sourceData);
		responseMsg.setValue("geophoneData", geophoneData);
		responseMsg.setValue("instrumentData", instrumentData);
		responseMsg.setValue("airgunData", airgunData);
		return responseMsg;
	}
	
	/**
	 * 获取项目施工方法
	 * @throws Exception
	 */
	public String getProjectWorkMethod(String projectInfoNo) throws Exception {
		String workmethod = "";
		StringBuffer sb = new StringBuffer("select project_info_no,exploration_method from gp_task_project ");
		sb.append(" where project_info_no ='").append(projectInfoNo).append("'");
		
		Map projectInfo = jdbcDAO.queryRecordBySQL(sb.toString());
		if(projectInfo != null){
			workmethod = (String)projectInfo.get("exploration_method");
		}
		return workmethod;
	}
	
	/**
	 * 获取综合物化探项目施工方法
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String,Object>> getProjectWorkMethodWt(String projectInfoNo) throws Exception {
		List<Map<String,Object>> methodList = new ArrayList<Map<String,Object>>();
		StringBuffer sb = new StringBuffer("select project_info_no,exploration_method from gp_task_project ");
		sb.append(" where project_info_no ='").append(projectInfoNo).append("'");
		
		Map<String,Object> projectInfo = jdbcDAO.queryRecordBySQL(sb.toString());
		if(projectInfo != null){
			String workMethod = (String)projectInfo.get("exploration_method");
			String[] methods = workMethod.split(",");
			int length = methods.length;
			if(length > 0){
				for(int i=0;i<length;i++){
					Map<String,Object> methodMap = new HashMap<String,Object>();
					String getNameByIdSql = "select d.coding_name from comm_coding_sort_detail d where d.coding_code_id = '"+methods[i]+"'";
					Map<String,Object> codeNameMap = jdbcDAO.queryRecordBySQL(getNameByIdSql);
					String codeName = codeNameMap.get("coding_name").toString();
					methodMap.put("codeID", methods[i]);
					methodMap.put("codeName", codeName);
					methodList.add(methodMap);
				}
			}
		}
		return methodList;
	}
	
	/**
	 * 获取综合物化探项目施工方法
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<String> getProjectWorkMethodWtList(String projectInfoNo) throws Exception {
		List<String> methodList = new ArrayList<String>();
		StringBuffer sb = new StringBuffer("select project_info_no,exploration_method from gp_task_project ");
		sb.append(" where project_info_no ='").append(projectInfoNo).append("'");
		
		Map<String,Object> projectInfo = jdbcDAO.queryRecordBySQL(sb.toString());
		if(projectInfo != null){
			String workMethod = (String)projectInfo.get("exploration_method");
			String[] methods = workMethod.split(",");
			int length = methods.length;
			if(length > 0){
				for(int i=0;i<length;i++){
					methodList.add(methods[i]);
				}
			}
		}
		return methodList;
	}
	
	/**
	 * 获取项目激发方式
	 * @throws Exception
	 */
	public String getProjectExcitationMode(String projectInfoNo) throws Exception {
		String build_method = "";
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		StringBuffer sb = new StringBuffer("select project_info_no,build_method from gp_task_project ");
		sb.append(" where project_info_no ='").append(projectInfoNo).append("'");
		
		Map projectInfo = new HashMap();
		projectInfo = jdbcDAO.queryRecordBySQL(sb.toString());
		if(projectInfo != null){
			build_method = (String)projectInfo.get("build_method");
		}
		return build_method;
	}
	/**
	 * 获取日报线束（测线）完成详情
	 * 夏秋雨添加2013-12-05
	 * @throws Exception
	 */
	public List<Map> getDailyInformation(String projectInfoNo,String produce_date,String resource_id) throws Exception {
		int type = 7005;
		StringBuffer sb = new StringBuffer("");
		sb.append(" select nvl(sum(t.qq_shot_num),0) qq_shot_num,nvl(sum(t.jp_shot_num),0) jp_shot_num,")
		.append(" nvl(sum(t.zy_shot_num),0) zy_shot_num,t.line_num ,t.start_end from bgp_pm_daily_information t ")
		.append(" where t.bsflag ='0' and t.project_info_no ='"+projectInfoNo+"' ")
		.append(" and t.produce_date = to_date('"+produce_date+"','yyyy-MM-dd') group by t.line_num ,t.start_end");
		
		List<Map> list = BeanFactory.getPureJdbcDAO().queryRecords(sb.toString());
		return list;
	}
	/**
	 * 获取日报录入时作业信息
	 * 夏秋雨添加2013-12-09
	 * @throws Exception
	 */
	public Map getActivityInformation(String activity_object_id) throws Exception {
		StringBuffer sb = new StringBuffer("");
		sb.append(" select t.*,c.* from bgp_p6_activity t left join bgp_p6_calendar c on t.calendar_object_id = c.object_id  ")
		.append(" where t.bsflag ='0' and t.object_id ='"+activity_object_id+"' and rownum =1");
		
		Map map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sb.toString());
		return map;
	}
 
	public String getSitStatus(String activity_object_id) throws Exception{
 
	 
 
		 
		String sql=" select a.status  from bgp_p6_activity a  where a.object_id = '"+activity_object_id+"'  and a.bsflag = '0'";
		   List<Map>  list=radDao.queryRecords(sql);
		   String st = null;
		   Map map=list.get(0);
			 String sitStatus=(String) map.get("status");
          boolean bool= sitStatus.contains("In Progress");//运行
		  boolean blean=sitStatus.contains("Not Started");//未开始
		  boolean bn=sitStatus.contains("Completed");//完成
		 
			  if(bool){
				  st="2";
			  }else if(bool==false&&bn==true){
				  st="3";
			  }else{
				  st="1";
			  }
		 
		
			 
		return st;
		
	}
	/**
	 * 获取日报录入时工作量情况
	 * 夏秋雨添加2013-12-09
	 * @throws Exception
	 */
	public List<Map> getDailyWorkload(String projectInfoNo,String produce_date,String activity_object_id) throws Exception {
		/*首先insert into的思路是：如果计划编制时添加了新的工作量，然而之前录过旧工作量，再次修改当天的工作量时可能会显示旧工作量组合*/
		StringBuffer sb = new StringBuffer("");
		sb.append(" insert into bgp_p6_workload(object_id, project_info_no,project_object_id,planned_units,remaining_units,actual_this_period_units,actual_units,")
		.append(" resource_name,modifi_date,updator,bsflag,creator_date,creator,activity_object_id,activity_name,resource_id,resource_object_id,produce_date )")
		.append(" select lower(sys_guid()),t.project_info_no,t.project_object_id,t.planned_units,t.remaining_units,t.actual_this_period_units,t.actual_units,")
		.append(" t.resource_name,t.modifi_date,t.updator,t.bsflag,t.creator_date,t.creator,t.activity_object_id,t.activity_name,t.resource_id,t.resource_object_id,")
		.append(" to_date('"+produce_date+"','yyyy-MM-dd')from bgp_p6_workload t where t.bsflag ='0' and t.produce_date is null and t.project_info_no ='"+projectInfoNo+"' ")
		.append(" and t.activity_object_id ='"+activity_object_id+"' and t.resource_id not in(select pw.resource_id from bgp_p6_workload pw where pw.bsflag ='0' ")
		.append(" and pw.project_info_no ='"+projectInfoNo+"' and pw.produce_date = to_date('"+produce_date+"','yyyy-MM-dd') and pw.activity_object_id ='"+activity_object_id+"' )");
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		jdbcTemplate.execute(sb.toString());
		
		sb = new StringBuffer("");
		/*total字段和actual_units字段关系：total字段是 produce_date之前的工作量之和。这么做的目的是录入页面修改本期完成时正确的修改累计，累计=本期完成 + total*/
		sb.append("select w.object_id,t.resource_id, t.resource_name ,t.planned_units,w.actual_this_period_units,(w.actual_this_period_units-(-nvl(s.actual_units,0))) actual_units,")
		.append(" (t.planned_units -w.actual_this_period_units -nvl(s.actual_units,0)) remaining_units ,nvl(s.actual_units,0)total from bgp_p6_workload t")
		.append(" left join bgp_p6_workload w on t.project_info_no = w.project_info_no and w.bsflag ='0' and t.resource_id = w.resource_id")
		.append(" and t.activity_object_id = w.activity_object_id and w.produce_date = to_date('"+produce_date+"','yyyy-MM-dd')")
		.append(" left join (select pw.resource_id ,sum(nvl(pw.actual_this_period_units,0)) actual_units from bgp_p6_workload pw ")
		.append(" where pw.bsflag ='0' and pw.project_info_no ='"+projectInfoNo+"' and pw.activity_object_id ='"+activity_object_id+"' ")
		.append(" and pw.produce_date < to_date('"+produce_date+"','yyyy-MM-dd') group by pw.resource_id)s on t.resource_id = s.resource_id")
		.append(" where t.bsflag ='0' and t.produce_date is null and t.project_info_no ='"+projectInfoNo+"' and t.activity_object_id ='"+activity_object_id+"'");
		List<Map> list = BeanFactory.getPureJdbcDAO().queryRecords(sb.toString());
		
		return list;
	}
	/**
	 * 综合化物探
	 * @param projectInfoNo
	 * @param typeList
	 * @return
	 * @throws Exception
	 */
	public List getDailyDateAnalysisWt(String projectInfoNo,List<String> methodCodeList) throws Exception{
		DecimalFormat df = new DecimalFormat("0.00");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
//		String ddd = "2014-02-08";
		Date nowDate = new Date();
		//nowDate=sdf.parse(ddd);
		List resultlist = new ArrayList();
		
		if(methodCodeList!=null&&methodCodeList.size()>0){
			for(int i=0;i<methodCodeList.size();i++){
				String lastDay = "";
				
				String xmlData="";
				String xmlData2 = "";
				Map<String,Object> xmlDataMap = new HashMap<String, Object>();
				String exMethodCode = methodCodeList.get(i);
				String sql_date = " SELECT MAX(PRODUCE_DATE) PRODUCE_DATE FROM GP_OPS_DAILY_REPORT_ZB WHERE bsflag='0' and PROJECT_INFO_NO='"+projectInfoNo+"' and EXPLORATION_METHOD = '"+exMethodCode+"'";
				Map date_map = radDao.queryRecordBySQL(sql_date);
				
				//获取勘探方法的名字
				String nameSql = "select CODING_NAME from comm_coding_sort_detail where CODING_CODE_ID='"+exMethodCode+"'";
				Map nameMap = radDao.queryRecordBySQL(nameSql);
				String exMethodName = (String)nameMap.get("coding_name");

				String widWhatSql="SELECT DISTINCT w.WTYPEID FROM gp_proj_product_plan_wt w,bgp_activity_method_mapping m where" +
						" w.PROJECT_INFO_NO='"+projectInfoNo+"' and w.MID=m.ACTIVITY_OBJECT_ID and m.PROJECT_INFO_NO='"+projectInfoNo+"' " +
						"and m.EXPLORATION_METHOD='"+exMethodCode+"'";
				Map widWhat =  radDao.queryRecordBySQL(widWhatSql);
				
				String widType="";
				if(widWhat!=null){
					String WTypeId = (String)widWhat.get("wtypeid");
					
					if("G6601".equals(WTypeId)){
						widType = "02";
					}
					if("G6602".equals(WTypeId)){
						widType = "05";
					}
					if("G6603".equals(WTypeId)){
						widType = "05";
					}
					if("G6604".equals(WTypeId)){
						widType = "04";
					}					
					if("G6605".equals(WTypeId)){
						widType = "05";
					}					
					if("G6606".equals(WTypeId)){
						widType = "04";
					}					
					if("G6607".equals(WTypeId)){
						widType = "07";
					}
				}

				//判断计划数据是否有坐标点
				String isWorkOrcoorpSql = "select * from( SELECT sum(w.VALUE) as workload FROM gp_proj_product_plan_wt w,bgp_activity_method_mapping m   " +
						" where w.PROJECT_INFO_NO='"+projectInfoNo+"' and m.PROJECT_INFO_NO='"+projectInfoNo+"' and " +
						"w.MID=m.ACTIVITY_OBJECT_ID    and m.EXPLORATION_METHOD='"+exMethodCode+"' and w.wid='01') a," +
						"(SELECT sum(w1.VALUE) as coorp  FROM gp_proj_product_plan_wt w1,bgp_activity_method_mapping m1   " +
						"  where w1.PROJECT_INFO_NO='"+projectInfoNo+"' and m1.PROJECT_INFO_NO='"+projectInfoNo+"' " +
						"and w1.MID=m1.ACTIVITY_OBJECT_ID     and m1.EXPLORATION_METHOD='"+exMethodCode+"' and w1.wid='"+widType+"' ) b ";
				Map isWorkOrcoorp = radDao.queryRecordBySQL(isWorkOrcoorpSql);
				if(isWorkOrcoorp!=null){
					String workLoad  = (String)isWorkOrcoorp.get("workload");
					String coorp = (String)isWorkOrcoorp.get("coorp");
					String widType1 = "0000";
					String workType = "";
					String exNameType="";
					if(coorp!=null&&!"0".equals(coorp)&&!"".equals(coorp)){
						widType1 = widType;
						workType = "DAILY_COORDINATE_POINT";
						exNameType = "物理点";
					//}else if(workLoad!=null&&!"0".equals(workLoad)&&!"".equals(workLoad)){
					}else {
						widType1="01";
						workType = "daily_workload";
						exNameType = "工作量";

					}
					
					xmlDataMap.put("exMethodName", exMethodName+exNameType);

						
					//查询该勘探方法的数据
					String planSql="select * from ( SELECT w.VALUE as design_data, 0 as daily_data, to_char(to_date(w.mdate,'yyyy-MM-dd'),'yyyy-MM-dd') as axis_date FROM " +
							"gp_proj_product_plan_wt w,bgp_activity_method_mapping m where " +
							"w.PROJECT_INFO_NO='"+projectInfoNo+"' and m.PROJECT_INFO_NO='"+projectInfoNo+"' " +
							"and w.MID=m.ACTIVITY_OBJECT_ID  and m.EXPLORATION_METHOD='"+exMethodCode+"' and w.wid='"+widType1+"'  union" +
							" select '0' as design_data,z."+workType+" as daily_data," +
							"to_char(z.produce_date,'yyyy-MM-dd') as axis_date from gp_ops_daily_report_zb z where z.project_info_no = '"+projectInfoNo+"' " +
							"and z.bsflag = '0' and z.exploration_method = '"+exMethodCode+"') n order by n.axis_date";
					
						List<Map> dataListTemp = radDao.queryRecords(planSql);
						if(dataListTemp!=null){
							
							List<Map> dataList  = new ArrayList<Map>();
							
						

							Map<String,String[]> mapTemp2 = new LinkedHashMap<String, String[]>();

							for(int t=0;t<dataListTemp.size();t++){
								Map mapTemp  = dataListTemp.get(t);
								String tempaxis = (String)mapTemp.get("axis_date");
								String tempdesign = (String)mapTemp.get("design_data");
								String tempdaily =  (String)mapTemp.get("daily_data");
								if(mapTemp2.containsKey("d"+tempaxis)){
									String[] tempVal = (String[])mapTemp2.get("d"+tempaxis);
									String[] putTempVal = new String[2];
									if("0".equals(tempVal[0])){
										putTempVal[0]=tempdesign;
									}else{
										putTempVal[0]=tempVal[0];
									}
									if("0".equals(tempVal[1])){
										putTempVal[1]=tempdaily;
									}else{
										putTempVal[1]=tempVal[1];

									}
									mapTemp2.put("d"+tempaxis,putTempVal);
								}else{
									String[] tempSt = {tempdesign,tempdaily};
									mapTemp2.put("d"+tempaxis,tempSt);

								}
							}
							
							Set set = mapTemp2.keySet();
							  
							 for(Iterator iter = set.iterator(); iter.hasNext();){
							   String key = (String)iter.next();
							   String[] value = (String[])mapTemp2.get(key);
							   Map<String,String> tmp = new HashMap<String, String>();
							   tmp.put("axis_date", key.substring(1));
							   tmp.put("design_data", value[0]);
							   tmp.put("daily_data", value[1]);
							   dataList.add(tmp);
							  }
							
							
							Document document = DocumentHelper.createDocument();
							Element root = document.addElement("chart");
							root.addAttribute("bgColor", "F3F5F4,DEE6EB");
							root.addAttribute("palette", "2");
							root.addAttribute("rotateYAxisName", "0");
							root.addAttribute("yAxisNameWidth", "16");
							root.addAttribute("baseFontSize", "12");
							root.addAttribute("yAxisName", exMethodName+"日效图");
					
							root.addAttribute("showLabels", "1");
							root.addAttribute("showValues", "0");
							root.addAttribute("formatNumberScale", "0");
							root.addAttribute("formatNumber", "0");
							
							Element categories = root.addElement("categories");
							Element designDataset = root.addElement("dataset");
							
							designDataset.addAttribute("seriesName", "设计日效");
							designDataset.addAttribute("color", "1381c0");
							designDataset.addAttribute("anchorBorderColor", "1381c0");
							designDataset.addAttribute("anchorBgColor", "1381c0");
							
							Element actualDataset = root.addElement("dataset");
							actualDataset.addAttribute("seriesName", "实际日效");
							actualDataset.addAttribute("color", "fd962e");
							actualDataset.addAttribute("anchorBorderColor", "fd962e");
							actualDataset.addAttribute("anchorBgColor", "fd962e");
							

							
							
							//日效累计图
							Document document2 = DocumentHelper.createDocument();
							Element root2 = document2.addElement("chart");
							root2.addAttribute("bgColor", "F3F5F4,DEE6EB");
							root2.addAttribute("rotateYAxisName", "0");
							root2.addAttribute("yAxisNameWidth", "16");
							root2.addAttribute("palette", "2");
							root2.addAttribute("baseFontSize", "12");
							root2.addAttribute("yAxisName", exMethodName+"日效图");
							root2.addAttribute("showLabels", "1");
							root2.addAttribute("showValues", "0");
							root2.addAttribute("formatNumberScale", "0");
							root2.addAttribute("formatNumber", "0");

							Element categories2 = root2.addElement("categories");
							Element designDataset2 = root2.addElement("dataset");
							designDataset2.addAttribute("seriesName", "设计日效");
							designDataset2.addAttribute("lineDashed", "1");
							designDataset2.addAttribute("color", "1381c0");
							designDataset2.addAttribute("anchorBorderColor", "1381c0");
							designDataset2.addAttribute("anchorBgColor", "1381c0");
							
							Element actualDataset2 = root2.addElement("dataset");
							actualDataset2.addAttribute("seriesName", "实际日效");
							actualDataset2.addAttribute("color", "fd962e");
							actualDataset2.addAttribute("anchorBorderColor", "fd962e");
							actualDataset2.addAttribute("anchorBgColor", "fd962e");
							
							//预测完成日效=
							//实际完成日效/实际天数=每日日效
							//当每日日效累计等于剩余日效时停止
							Element forcastDataset = root2.addElement("dataset"); // 剩余工作量的预测完成日效
							forcastDataset.addAttribute("seriesName", "预测完成日效");
							forcastDataset.addAttribute("color", "e7d948");
							forcastDataset.addAttribute("anchorBorderColor", "e7d948");
							forcastDataset.addAttribute("anchorBgColor", "e7d948");
							
							
							List<Date> listaxisDate = new ArrayList<Date>();
							double designData = 0.0;
							double dailyData = 0.0;
							
							double nowDateDailyData=0.0;
							//获取每个勘探方法日报的最大日期
							
							for(int j=0;j<dataList.size();j++){
								Map recordMap = dataList.get(j);
								String xAxisDate = "" + recordMap.get("axis_date");				
								String design_value = "" + recordMap.get("design_data");
								String daily_value = "" + recordMap.get("daily_data");
								Date date= sdf.parse(xAxisDate);
								listaxisDate.add(date);
								Element category = categories.addElement("category");
								category.addAttribute("label", xAxisDate.substring(5));
								
								//设计值
								Element designSet = designDataset.addElement("set");
								designSet.addAttribute("value", design_value);
									
								if(date_map!=null&&date_map.size()!=0){
									SimpleDateFormat dft = new SimpleDateFormat("yyyy-MM-dd");
									Date date1 = dft.parse(xAxisDate);
									Date date2 = dft.parse(date_map.get("produce_date").toString());
									if(date1.before(date2)){
										Element actualSet = actualDataset.addElement("set");
										actualSet.addAttribute("value", daily_value);
									}
									
								}
								
								
								
								//累计
								// 日期坐标
								Element category2 = categories2.addElement("category");
								category2.addAttribute("label", xAxisDate.substring(5));
								
								Element designSet2 = designDataset2.addElement("set");
								if(design_value!=null&&!"".equals(design_value)){
									designData += Double.parseDouble(design_value);
									designSet2.addAttribute("value", "" + designData);
								}else{
									designSet2.addAttribute("value", "" + designData);
								}

								
								if(date_map!=null&&date_map.size()!=0){
									String produce_date = date_map.get("produce_date").toString();
									// 日报值
									 SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
									 Date date1 = format.parse(produce_date);
									 Date date2 = format.parse(xAxisDate);
									 if(date1.after(date2)){
										 Element actualSet2 = actualDataset2.addElement("set");
											if(daily_value!=null&&!"".equals(daily_value)){
												dailyData += Double.parseDouble(daily_value);
												actualSet2.addAttribute("value", "" + dailyData);
											}else{
												actualSet2.addAttribute("value", "" + dailyData);

											}
									 }
									
									
								}else{
									Element actualSet2 = actualDataset2.addElement("set");
									if(daily_value!=null&&!"".equals(daily_value)){
										dailyData += Double.parseDouble(daily_value);
										actualSet2.addAttribute("value", "" + dailyData);
									}else{
										actualSet2.addAttribute("value", "" + dailyData);

									}
								}
								
								if(sdf.parse(xAxisDate).equals(nowDate)){
									nowDateDailyData = dailyData;
								}
								
						  }	
							
							//获取日效最大日期
							String getPanlMaxDateSql="SELECT max(w.MDATE) as maxPlanDate FROM gp_proj_product_plan_wt w," +
									"bgp_activity_method_mapping m where w.PROJECT_INFO_NO='"+projectInfoNo+"' " +
									"and w.MID=m.ACTIVITY_OBJECT_ID and m.PROJECT_INFO_NO='"+projectInfoNo+"' and " +
									"m.EXPLORATION_METHOD='"+exMethodCode+"' and w.WID='"+widType1+"'";
							Map maxPlanDateMap =  radDao.queryRecordBySQL(getPanlMaxDateSql);
							String maxPlanDate = "";
							if(maxPlanDateMap!=null){
								maxPlanDate = (String)maxPlanDateMap.get("maxplandate");
							}
			
							//获取日报施工加停工的天数，用累计的总实际工作量/天数
							String getDailyDay = "SELECT count(*) as countNumber FROM GP_OPS_DAILY_REPORT_ZB where PROJECT_INFO_NO='"+projectInfoNo+"' and BSFLAG='0' and EXPLORATION_METHOD='"+exMethodCode+"' and (TASK_STATUS ='1' or TASK_STATUS='2'  or TASK_STATUS='3') ";
							Map dailyDayMap = radDao.queryRecordBySQL(getDailyDay);
							String dilayDay = "0";
							if(dailyDayMap!=null){
								dilayDay = (String)dailyDayMap.get("countnumber");
							}
							double ycwcData = dailyData/Integer.parseInt(dilayDay);
							double ycwcSumData = dailyData;
							
							if(dailyData>0){
								if(dailyData>=designData){
									System.out.println("已完成");
								}else{
								Date ZBMAX = Collections.max(listaxisDate);
								if(ZBMAX.after(nowDate)){
									//循环，当前之前的为空，之后的有只，
									for(int f=0;f<listaxisDate.size();f++){
										Date  axisDate2 = listaxisDate.get(f);
										if((sdf.format(axisDate2)).equals(sdf.format(nowDate))){
											Element forcastset = forcastDataset.addElement("set");
											forcastset.addAttribute("value", ""+ycwcSumData);
										}else if(axisDate2.before(nowDate)){
											Element forcastset = forcastDataset.addElement("set");
											forcastset.addAttribute("value", "");
										}else{
											if(designData-ycwcSumData<ycwcData){
												Element forcastset = forcastDataset.addElement("set");
												forcastset.addAttribute("value", ""+designData);
												ycwcSumData+=ycwcData;
												break;
											}else{
												Element forcastset = forcastDataset.addElement("set");
												forcastset.addAttribute("value", ""+(ycwcSumData+ycwcData));
											}
											ycwcSumData+=ycwcData;
										}
								
									}
									
									String tempZBMAX = sdf.format(ZBMAX);
									if(ycwcSumData<designData){
										while(ycwcSumData-ycwcData<designData){
											tempZBMAX = DateOperation.afterNDays(tempZBMAX, 1);
											Element category2 = categories2.addElement("category");
											category2.addAttribute("label", tempZBMAX.substring(5));
											if(designData-ycwcSumData<ycwcData){
												Element forcastset = forcastDataset.addElement("set");
												forcastset.addAttribute("value", ""+designData);
												break;
											}else{
												Element forcastset = forcastDataset.addElement("set");
												forcastset.addAttribute("value", ""+(ycwcSumData+ycwcData));
											}
											ycwcSumData+=ycwcData;
										}
										
									}
								
									lastDay = tempZBMAX;
								
									
								}else{
									
									for(int f=0;f<listaxisDate.size();f++){
										Element forcastset = forcastDataset.addElement("set");
										forcastset.addAttribute("value", "");
									}
									String tempZBMAX = sdf.format(ZBMAX);
									while(ycwcSumData<designData){
										tempZBMAX = DateOperation.afterNDays(tempZBMAX, 1);
										Element category2 = categories2.addElement("category");
										category2.addAttribute("label", tempZBMAX.substring(5));
										String tempZBMAX2 = DateOperation.afterNDays(tempZBMAX, 1);
								
										if(sdf.parse(tempZBMAX2).after(nowDate)){
											Element forcastset = forcastDataset.addElement("set");
											forcastset.addAttribute("value",""+ycwcSumData);
											
											if(designData-ycwcSumData<ycwcData){
												Element category3 = categories2.addElement("category");
												category3.addAttribute("label", tempZBMAX.substring(5));
												
												Element forcastset2 = forcastDataset.addElement("set");
												forcastset2.addAttribute("value", ""+designData);
											}
											ycwcSumData+=ycwcData;
										}else{
											Element forcastset = forcastDataset.addElement("set");
											forcastset.addAttribute("value", "");
										}	
									}
									lastDay = tempZBMAX;
								
								
								}
								
								
									}
							}
							
							//在今天之前的有这接卸些，无创建坐标，之后创建坐标。。先计算需要几天完成。当前日期加上天数==最后坐标。，开始循环循环完后
						String getPalnDaySql = "SELECT count(*) as palnDay FROM gp_proj_product_plan_wt w,bgp_activity_method_mapping" +
								" m where w.PROJECT_INFO_NO='"+projectInfoNo+"' and w.MID=m.ACTIVITY_OBJECT_ID and m.PROJECT_INFO_NO='"+projectInfoNo+"' and m.EXPLORATION_METHOD='"+exMethodCode+"' and w.WID='"+widType1+"' and BSFLAG='0'";
						Map palnDayMap = radDao.queryRecordBySQL(getPalnDaySql);
						 int palnDay = 0;
						if(palnDayMap!=null){
							String palnDaytemp = (String)palnDayMap.get("palnday");
							if(palnDaytemp!=null&&!"".equals(palnDaytemp)){
								palnDay=Integer.parseInt(palnDaytemp);
							}
						}
						StringBuffer	chatInfo = new StringBuffer();
						if(dailyData!=0&&designData!=0){
							chatInfo.append("截至"+ sdf.format(nowDate)+"日计划平均日效为" + df.format(designData/palnDay)+ exNameType + ",实际平均日效为"+ df.format(ycwcData) + exNameType + ";");
							chatInfo.append("累计完成"+dailyData+exNameType);
							if(dailyData<designData){
								chatInfo.append("以目前生产情况推算，剩余工作量" + (designData-dailyData)+ exNameType + "，预计完成日期为"+lastDay+"，尚需天"+	DateOperation.diffDaysOfDate(lastDay, sdf.format(nowDate))+";");
								chatInfo.append("实际完成日期超过计划完成日期");

							}else{
								chatInfo.append("已经完成");
								
							}
						}else{
							chatInfo.append("目前尚无生产数据");

						}
						

						

						
						
							//是 9结束 当单签日期12号那么9到12号不用增加，12号之后加坐标，当前日期 list里最大日期天数，是都能将工作量分配完，不行则for循换加坐标
							xmlData = document.asXML();
							int p_start = xmlData.indexOf("<chart");
							if(p_start > 0){
								xmlData = xmlData.substring(p_start, xmlData.length());
							}
							xmlDataMap.put("xmlData", xmlData);	
							
							xmlData2 = document2.asXML();
							int p_start2 = xmlData2.indexOf("<chart");
							if(p_start2 > 0){
								xmlData2 = xmlData2.substring(p_start2, xmlData2.length());
							}
							xmlDataMap.put("xmlData2", xmlData2);	
							xmlDataMap.put("chatInfo", chatInfo.toString());	

							
							
	

					}
				
				}
				resultlist.add(xmlDataMap);

			}
			
		}
		return resultlist;
	}
	
	
	/**
	 * 综合物化探
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public Map getDailyActivityWt(String projectInfoNo, List<String> typeList) throws Exception{
		
		String chatInfo = "";
		String xmlData = "";
		
		boolean showFlag = false;
		
		String designStartDate = "";
		String designEndDate = "";
		String dailyStartDate = "";
		String dailyEndDate = "";
		Map<String,Object> xmlDataMap = new HashMap<String,Object>();
		for(int k=0;k<typeList.size();k++){
			String expType = typeList.get(k);
			//取日期坐标值，计划的 . 取计划数据
			
			String designAndDailySql = "select temp.axis_date,sum(temp.design_data) as design_data,sum(temp.daily_data) as daily_data from "+
						 "(select w.value as design_data,0 as daily_data,to_char(to_date(w.mdate,'yyyy-MM-dd'),'yyyy-MM-dd') as axis_date from "+
						 "gp_proj_product_plan_wt w join bgp_activity_method_mapping m on w.mid = m.activity_object_id "+
						 "and w.project_info_no = m.project_info_no and m.bsflag = '0' and w.project_info_no = '"+projectInfoNo+"'"+
						 "and w.wid = '01' and m.exploration_method = '"+expType+"' "+
						 "union "+
						 "select '0' as design_data,z.daily_workload as daily_data,to_char(z.produce_date,'yyyy-MM-dd') as axis_date from " +
						 "gp_ops_daily_report_zb z where z.project_info_no = '"+projectInfoNo+"' "+
						 "and z.bsflag = '0' and z.exploration_method = '"+expType+"') temp "+
						 "group by temp.axis_date order by temp.axis_date";
			List<Map> dataList = radDao.queryRecords(designAndDailySql);	
			
			// 取设计起始日期
			String designDateSql = "select to_char(min(to_date(w.mdate,'yyyy-MM-dd')), 'yyyy-MM-dd') as min_date,"+
							       " to_char(max(to_date(w.mdate,'yyyy-MM-dd')), 'yyyy-MM-dd') as max_date from"+
								   " gp_proj_product_plan_wt w join bgp_activity_method_mapping m on w.mid = m.activity_object_id"+
								   " and w.project_info_no = m.project_info_no and m.bsflag = '0' and w.project_info_no = '"+projectInfoNo+"'"+
								   " and w.wid = '01' and m.exploration_method = '"+expType+"'";
			Map designDateMap = radDao.queryRecordBySQL(designDateSql);
			if(designDateMap != null){
				designStartDate = "" + designDateMap.get("min_date");
				designEndDate = "" + designDateMap.get("max_date");
			}
			
			//获取日报的起止日期
			String dailyDateSql = "select  sum(zb.DAILY_WORKLOAD) as workload,sum(zb.DAILY_COORDINATE_POINT) as coordinate, to_char(min(zb.produce_date), 'yyyy-MM-dd') as min_date, "+
							      "to_char(max(zb.produce_date), 'yyyy-MM-dd') as max_date "+
							  	  "from gp_ops_daily_report_zb zb "+
								  "where bsflag = '0' "+
							   	  " and project_info_no = '"+projectInfoNo+"'"+
							   	  " and zb.exploration_method = '"+expType+"'";
			Map dailyDateMap = radDao.queryRecordBySQL(dailyDateSql);
			String unit = "";
			if(dailyDateMap != null){
				dailyStartDate = "" + dailyDateMap.get("min_date");
				dailyEndDate = "" + dailyDateMap.get("max_date");
				String workLoad  = (String)dailyDateMap.get("workload");
				String coordinate  = (String)dailyDateMap.get("coordinate");
				
				if(coordinate!=null&&!"".equals(coordinate)){
					unit="坐标点";
				}else{
					if(workLoad!=null&&!"".equals(workLoad)){
						unit="工作量";
					}
				}
			}
			
			//拼接图标数据
			if(dataList != null && dataList.size() > 0){
				Document document = DocumentHelper.createDocument();
				Element root = document.addElement("chart");
				root.addAttribute("bgColor", "F3F5F4,DEE6EB");
				root.addAttribute("palette", "2");
				root.addAttribute("rotateYAxisName", "0");
				root.addAttribute("yAxisNameWidth", "16");
				root.addAttribute("baseFontSize", "12");

				String expMethodName = this.getExpMethodName(expType);
				if(expMethodName != null){
					root.addAttribute("yAxisName", expMethodName+"日效图");
				}
				
				root.addAttribute("showLabels", "1");
				root.addAttribute("showValues", "0");
				root.addAttribute("formatNumberScale", "0");
				root.addAttribute("formatNumber", "0");
				
				Element categories = root.addElement("categories");
				Element designDataset = root.addElement("dataset");
				designDataset.addAttribute("seriesName", "设计日效");
				designDataset.addAttribute("color", "1381c0");
				designDataset.addAttribute("anchorBorderColor", "1381c0");
				designDataset.addAttribute("anchorBgColor", "1381c0");
				
				Element actualDataset = root.addElement("dataset");
				actualDataset.addAttribute("seriesName", "实际日效");
				actualDataset.addAttribute("color", "fd962e");
				actualDataset.addAttribute("anchorBorderColor", "fd962e");
				actualDataset.addAttribute("anchorBgColor", "fd962e");
				
				for(int i=0; i<dataList.size(); i++){
					Map recordMap = dataList.get(i);
					String xAxisDate = "" + recordMap.get("axis_date");				
					String design_value = "" + recordMap.get("design_data");
					String daily_value = "" + recordMap.get("daily_data");
					
					// 日期坐标
					Element category = categories.addElement("category");
					category.addAttribute("label", xAxisDate.substring(5));
					//填充数据
					//设计值
					Element designSet = designDataset.addElement("set");
					if(DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0){
					}else{
						if(design_value != "" && !"".equals(design_value)){
							//当设计日效不为0的时候,showFlag = true
							if(!showFlag){
								if(Float.parseFloat(recordMap.get("design_data").toString())>0){
									showFlag = true;
								}
							}
							
							if(showFlag){
								designSet.addAttribute("value", design_value);
							}
						}else{
							designSet.addAttribute("value", "0");
						}

					}
					
					//日报值
					Element actualSet = actualDataset.addElement("set");
					if(DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0){
						if(DateOperation.diffDaysOfDate(dailyEndDate, xAxisDate) >= 0){
								actualSet.addAttribute("value", daily_value);
						}
					}
				}
				xmlData = document.asXML();
				int p_start = xmlData.indexOf("<chart");
				if(p_start > 0){
					xmlData = xmlData.substring(p_start, xmlData.length());
				}
				
				xmlDataMap.put("xmlData_"+expType, unit+"@"+xmlData);
			}
			
		}
		return xmlDataMap;
	}	
	
	/**
	 * 综合物化探的累计值
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public Map getDaysCumulativeWt(String projectInfoNo, List<String> typeList) throws Exception {
		
		String chatInfo = "";
		String xmlData = "";
		
		boolean noDailyData = false;
		
		String designStartDate = "";
		String designEndDate = "";
		String dailyStartDate = "";
		String dailyEndDate = "";

		double designWorkLoad = 0;// 设计工作量
		double dailyWorkLoad = 0;// 日报工作量
		double sum_designWorkLoad = 0;// 设计工作量之和
		double sum_dailyWorkLoad = 0;// 日报工作量之和
		double sum_curDesignWorkLoad = 0;
		double sum_curDailyWorkLoad = 0;
		double avgWorkLoad = 1;// 最近7天平均工作量
		DecimalFormat df = new DecimalFormat("0.00");
		Date curDate = new Date();// 当前日期
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sCurDate = sdf.format(curDate);
		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");// [0-9]+(.[0-9]?)?+
		
		Map<String,Object> xmlDataMap = new HashMap<String,Object>();
		String taskName = "";
		String unitName = "炮";
		
		//按勘探方法分别计算
		for(int k=0;k<typeList.size();k++){

			//重新初始化变量
			chatInfo = "";
			xmlData = "";
			
			designWorkLoad = 0;// 设计工作量
			dailyWorkLoad = 0;// 日报工作量
			sum_designWorkLoad = 0;// 设计工作量之和
			sum_dailyWorkLoad = 0;// 日报工作量之和
			sum_curDesignWorkLoad = 0;
			sum_curDailyWorkLoad = 0;
			avgWorkLoad = 1;// 最近7天平均工作量
			
			String expType = typeList.get(k);
			// 取设计起始日期、设计累积值
			String designDateSql = "select to_char(min(to_date(w.mdate,'yyyy-MM-dd')), 'yyyy-MM-dd') as min_date, "+
							       "to_char(max(to_date(w.mdate,'yyyy-MM-dd')), 'yyyy-MM-dd') as max_date, "+
							       "sum(nvl(w.value,0)) as sum_design_data from "+
								   "gp_proj_product_plan_wt w join bgp_activity_method_mapping m on w.mid = m.activity_object_id "+
								   "and w.project_info_no = m.project_info_no and m.bsflag = '0' and w.project_info_no = '"+projectInfoNo+"' "+
							       "and w.wid = '01' and m.exploration_method = '"+expType+"'";
			
			Map recordMap = radDao.queryRecordBySQL(designDateSql);
			if (recordMap != null) {
				designStartDate = "" + recordMap.get("min_date");
				designEndDate = "" + recordMap.get("max_date");
				String sumDesignNum = "" + recordMap.get("sum_design_data");
				Matcher isNum1 = pattern.matcher(sumDesignNum);
				if (isNum1.matches()) {
					sum_designWorkLoad = Double.valueOf(sumDesignNum);
				}
			}
			
			// 取日报起始日期、日报累积值
			String dailyDateSql = "select to_char(min(zb.produce_date), 'yyyy-MM-dd') as min_date,"+
							      "to_char(max(zb.produce_date), 'yyyy-MM-dd') as max_date,"+
							      "sum(nvl(zb.daily_workload,0)) as sum_daily_data "+
							      "from gp_ops_daily_report_zb zb "+
							      "where bsflag = '0' "+
							      "and project_info_no = '"+projectInfoNo+"' "+
							   	  "and zb.exploration_method = '"+expType+"'";
			recordMap = radDao.queryRecordBySQL(dailyDateSql);
			if (recordMap != null) {
				dailyStartDate = "" + recordMap.get("min_date");
				dailyEndDate = "" + recordMap.get("max_date");
				String sumDailyData = "" + recordMap.get("sum_daily_data");
				Matcher isNum1 = pattern.matcher(sumDailyData);
				if (isNum1.matches()) {
					sum_dailyWorkLoad = Double.valueOf(sumDailyData);
				}
				// 没有日报数据
				if("".equals(dailyStartDate)){
					noDailyData = true;
				}
			}
			
			// 取截止当前的设计工作量
			String curDesignWorkloadSql = "select sum(nvl(w.value,0)) as sum_design_data from "+
										  "gp_proj_product_plan_wt w join bgp_activity_method_mapping m on w.mid = m.activity_object_id "+
										  "and w.project_info_no = m.project_info_no and m.bsflag = '0' "+
										  "and w.project_info_no = '"+projectInfoNo+"'"+
										  " and w.wid = '01' and m.exploration_method = '"+expType+"'"+ 
										  " and to_date(w.mdate,'yyyy-MM-dd') <= to_date('"+dailyEndDate+"','yyyy-MM-dd')";
			recordMap = radDao.queryRecordBySQL(curDesignWorkloadSql);
			if (recordMap != null) {
				String value = "" + recordMap.get("sum_design_data");
				Matcher isNum = pattern.matcher(value);
				if (isNum.matches()) {
					sum_curDesignWorkLoad = Double.valueOf(value);
				}
			}
			
			// 取截止当前的实际工作量
			String curDailyWorkloadSql = "select sum(nvl(zb.daily_workload,0)) as sum_daily_data"+
										 " from gp_ops_daily_report_zb zb"+
										 " where bsflag = '0' and task_status = '1'"+
										 " and project_info_no = '"+projectInfoNo+"'"+
										 " and zb.exploration_method = '"+expType+"'"+
										 " and zb.produce_date <= to_date('"+dailyEndDate+"','yyyy-MM-dd')";
			
			recordMap = radDao.queryRecordBySQL(curDailyWorkloadSql);
			if (recordMap != null) {
				String value = "" + recordMap.get("sum_daily_data");
				Matcher isNum = pattern.matcher(value);
				if (isNum.matches()) {
					sum_curDailyWorkLoad = Double.valueOf(value);
				}
			}
			
			// 取当前工序的结束状态
			String endFlagSql = "select nvl(count(*),0) as end_day"+
							    " from gp_ops_daily_report_zb zb"+
							    " where bsflag = '0'"+
							    " and project_info_no = '"+projectInfoNo+"'"+
							    " and zb.exploration_method = '"+expType+"'"+
							    " and zb.task_status = '4'"+
							    " and zb.produce_date <= to_date('"+dailyEndDate+"','yyyy-MM-dd')"+
							    " and zb.produce_date >= to_date('"+dailyStartDate+"','yyyy-MM-dd')";
			recordMap = radDao.queryRecordBySQL(endFlagSql);
			long endFlagDay = 0;
			if (recordMap != null) {
				String value = "" + recordMap.get("end_day");
				Matcher isNum = pattern.matcher(value);
				if (isNum.matches()) {
					endFlagDay = Long.valueOf(value);
				}
			}
			
			// 计算项目开始到现在的天数 用于计算设计值,实际结束时间-计划开始时间
			long projectUpToNowDays = DateOperation.diffDaysOfDate(dailyEndDate, designStartDate)+1;
			
			// 计算项目实际开始到现在的天数 用于计算实际值,实际结束时间-实际开始时间 
			long actualWorkDays = DateOperation.diffDaysOfDate(dailyEndDate, dailyStartDate)+1;
			
			//计算项目开始到现在的施工天数 除掉暂停天数
			long workDay = actualWorkDays;
			
			// 计算当前的设计平均日效
			double curDesignAvgWorkLoad = 0;
			if (projectUpToNowDays != 0) {
				curDesignAvgWorkLoad = sum_curDesignWorkLoad / projectUpToNowDays;
			}
			// 计算当前的实际平均日效
			double curDailyAvgWorkLoad = 0;
			if (projectUpToNowDays != 0) {
				curDailyAvgWorkLoad = sum_curDailyWorkLoad / workDay;
			}
			
			long compareDate = DateOperation.diffDaysOfDate(dailyEndDate, designEndDate);
			if(compareDate >= 0){
				chatInfo = "截至"+ dailyEndDate+"日计划平均日效为" + df.format(curDesignAvgWorkLoad) + unitName + ",实际平均日效为"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
			}else{
				chatInfo = "截至"+ dailyEndDate+"日计划平均日效为" + df.format(curDesignAvgWorkLoad) + unitName + ",实际平均日效为"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
			}
			
			String designAndDailySql = "select temp.axis_date,sum(temp.design_data) as design_data,sum(temp.daily_data) as daily_data from "+
			 "(select w.value as design_data,0 as daily_data,to_char(to_date(w.mdate,'yyyy-MM-dd'),'yyyy-MM-dd') as axis_date from "+
			 "gp_proj_product_plan_wt w join bgp_activity_method_mapping m on w.mid = m.activity_object_id "+
			 "and w.project_info_no = m.project_info_no and m.bsflag = '0' and w.project_info_no = '"+projectInfoNo+"'"+
			 "and w.wid = '01' and m.exploration_method = '"+expType+"' "+
			 "union "+
			 "select '0' as design_data,z.daily_workload as daily_data,to_char(z.produce_date,'yyyy-MM-dd') as axis_date from " +
			 "gp_ops_daily_report_zb z where z.project_info_no = '"+projectInfoNo+"' "+
			 "and z.bsflag = '0' and z.exploration_method = '"+expType+"') temp "+
			 "group by temp.axis_date order by temp.axis_date";
			
			List<Map> dataList = radDao.queryRecords(designAndDailySql);	
			
			// 计算最近7天工作量不为零的数据
			String daysAvgSql = "select sum(colsadd_value)/7 as avg_value from"+
								" (select zb.daily_workload as colsadd_value,to_char(zb.produce_date,'yyyy-MM-dd') as date1"+
								" from gp_ops_daily_report_zb zb"+
								" where zb.bsflag = '0' and zb.task_status = '1'"+
								" and zb.project_info_no = '"+projectInfoNo+"'"+
								" and zb.exploration_method = '"+expType+"'"+
								" order by date1 desc) where rownum < 8";
			List<Map> daysAvgList = radDao.queryRecords(daysAvgSql);

			if (daysAvgList != null && daysAvgList.size() > 0) {
				recordMap = daysAvgList.get(0);
				String value = "" + recordMap.get("avg_value");
				Matcher isNum = pattern.matcher(value);
				if (isNum.matches()) {
					avgWorkLoad = Double.valueOf(value);
					avgWorkLoad = Double.valueOf(df.format(avgWorkLoad));
				}
			}
			
			if (dataList != null && dataList.size() > 0) {
				Document document = DocumentHelper.createDocument();
				Element root = document.addElement("chart");
				root.addAttribute("bgColor", "F3F5F4,DEE6EB");
				root.addAttribute("rotateYAxisName", "0");
				root.addAttribute("yAxisNameWidth", "16");
				root.addAttribute("palette", "2");
				root.addAttribute("baseFontSize", "12");
				
				
				String expMethodName = this.getExpMethodName(expType);
				root.addAttribute("yAxisName", expMethodName+"日效累计图");
				
				root.addAttribute("showLabels", "1");
				root.addAttribute("showValues", "0");
				root.addAttribute("formatNumberScale", "0");
				root.addAttribute("formatNumber", "0");

				Element categories = root.addElement("categories");
				Element designDataset = root.addElement("dataset");
				designDataset.addAttribute("seriesName", "设计日效");
				designDataset.addAttribute("lineDashed", "1");
				designDataset.addAttribute("color", "1381c0");
				designDataset.addAttribute("anchorBorderColor", "1381c0");
				designDataset.addAttribute("anchorBgColor", "1381c0");
				
				Element actualDataset = root.addElement("dataset");
				actualDataset.addAttribute("seriesName", "实际日效");
				actualDataset.addAttribute("color", "fd962e");
				actualDataset.addAttribute("anchorBorderColor", "fd962e");
				actualDataset.addAttribute("anchorBgColor", "fd962e");

				if (endFlagDay > 0) {
					for (int i = 0; i < dataList.size(); i++) {
						Map map = dataList.get(i);
						String xAxisDate = "" + map.get("axis_date");
						String design_value = "" + map.get("design_data");
						String daily_value = "" + map.get("daily_data");
						Matcher isNum1 = pattern.matcher(design_value);
						if (isNum1.matches()) {
							designWorkLoad += Double.valueOf(design_value);
						}
						Matcher isNum2 = pattern.matcher(daily_value);
						if (isNum2.matches()) {
							dailyWorkLoad += Double.valueOf(daily_value);
						}

						// 日期坐标
						Element category = categories.addElement("category");
						category.addAttribute("label", xAxisDate.substring(5));
						// 填充数据
						// 设计值
						Element designSet = designDataset.addElement("set");
						if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
						} else {
							if(designWorkLoad > 0){
								designSet.addAttribute("value", "" + designWorkLoad);
							}
						}
						// 日报值
						Element actualSet = actualDataset.addElement("set");
						if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
							actualSet.addAttribute("value", "" + dailyWorkLoad);
						}
					}
					chatInfo = chatInfo + taskName + "工序已完成;累计完成"+df.format(dailyWorkLoad)+""+unitName;
				} else {
					Element forcastDataset = root.addElement("dataset"); // 剩余工作量的预测完成日效
					forcastDataset.addAttribute("seriesName", "预测完成日效");
					forcastDataset.addAttribute("color", "e7d948");
					forcastDataset.addAttribute("anchorBorderColor", "e7d948");
					forcastDataset.addAttribute("anchorBgColor", "e7d948");
					
					Element planDataset = root.addElement("dataset"); // 剩余工作量按计划日期完成日效
					
					planDataset.addAttribute("seriesName", "按计划完成所需日效");
					
					planDataset.addAttribute("color", "95a700");
					planDataset.addAttribute("anchorBorderColor", "95a700");
					planDataset.addAttribute("anchorBgColor", "95a700");
					
					String axisEndDate = designEndDate;
					if (DateOperation.diffDaysOfDate(dailyEndDate, designEndDate) > 0) {
						axisEndDate = dailyEndDate;
					}
					// 计算预测完成日效
					String forcastFinishDate = dailyEndDate; // 预测完成日期
					long forcastFinishDays = 0;
					long drawForcastDays = 1;
					if ((sum_designWorkLoad - sum_dailyWorkLoad) > 0) {
						long days = (long)((sum_designWorkLoad - sum_dailyWorkLoad) / avgWorkLoad);
						if(0 < ((sum_designWorkLoad - sum_dailyWorkLoad) / avgWorkLoad)){
							if (((sum_designWorkLoad - sum_dailyWorkLoad) % avgWorkLoad) > 0) {
								forcastFinishDays = days + 1;
							} else {
								forcastFinishDays = days;
							}
						}
						forcastFinishDate = DateOperation.afterNDays(dailyEndDate,forcastFinishDays);
						chatInfo = chatInfo + "以目前生产情况推算，剩余工作量" + df.format(sum_designWorkLoad - sum_dailyWorkLoad) + unitName + "，预计完成日期为" + forcastFinishDate + "尚需" + forcastFinishDays + "天.";
					}
					// 计算按计划日期完成日效(当前日期小于计划日期时)
					boolean planFinishLine = false;
					double planFinishWorkLoad = 0;
					long drawPlanDays = 1;
					long diffDays = DateOperation.diffDaysOfDate(designEndDate,	dailyEndDate);
					// long diffDays = DateOperation.diffDaysOfDate(designEndDate,dailyEndDate);
					if (diffDays > 0) {
						// 设计工作量减去实际完成工作量 / 剩余天数
						planFinishWorkLoad = (long)(sum_designWorkLoad - sum_dailyWorkLoad)/ diffDays;
						planFinishLine = true;
						chatInfo = chatInfo + "按计划时间完成，所需日效为" + df.format(planFinishWorkLoad) + unitName + ".";
					}else{
						chatInfo = chatInfo + "实际工作日期已超出设计日期.";
					}
					for (int i = 0; i < dataList.size(); i++) {
						Map map = dataList.get(i);
						String xAxisDate = "" + map.get("axis_date");
						String design_value = "" + map.get("design_data");
						String daily_value = "" + map.get("daily_data");
						Matcher isNum1 = pattern.matcher(design_value);
						if (isNum1.matches()) {
							designWorkLoad += Double.valueOf(design_value);
						}
						Matcher isNum2 = pattern.matcher(daily_value);
						if (isNum2.matches()) {
							dailyWorkLoad += Double.valueOf(daily_value);
						}
						// 日期坐标
						Element category = categories.addElement("category");
						category.addAttribute("label", xAxisDate.substring(5));
						// 填充数据
						// 设计值
						Element designSet = designDataset.addElement("set");
						if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
						} else {
							designSet.addAttribute("value", "" + designWorkLoad);
						}
						// 日报值
						Element dailySet = actualDataset.addElement("set");
						if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
								dailySet.addAttribute("value", "" + dailyWorkLoad);
						}
						// 按计划完成日效值
						Element planSet = planDataset.addElement("set");
						if (planFinishLine) {
							if(xAxisDate.equals(dailyEndDate)) {
								planSet.addAttribute("value", "" + sum_dailyWorkLoad);
								planSet.addAttribute("Color", "95a700");
								planSet.addAttribute("toolText", "实际日效,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
							}
							if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0) {
								planSet.addAttribute("value", "" + (sum_dailyWorkLoad + planFinishWorkLoad * drawPlanDays));
								drawPlanDays++;
							}
						}
						// 预测完成日效值
						Element forcastSet = forcastDataset.addElement("set");
						if (xAxisDate.equals(dailyEndDate)) {
							forcastSet.addAttribute("value", "" + sum_dailyWorkLoad);
							forcastSet.addAttribute("Color", "e7d948");
							forcastSet.addAttribute("toolText", "实际日效,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
						}
						if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0 && DateOperation.diffDaysOfDate(forcastFinishDate, xAxisDate) >= 0) {
							drawForcastDays++;
							forcastSet.addAttribute("value", df.format(sum_dailyWorkLoad + avgWorkLoad * drawForcastDays));
						}
					}

					// 预测完成日期是否大于坐标的结束日期(大于则追加坐标日期)
					if (DateOperation.diffDaysOfDate(forcastFinishDate, axisEndDate) > 0) {
						diffDays = DateOperation.diffDaysOfDate(forcastFinishDate,axisEndDate);
						String nextDate = axisEndDate;
						for (int j = 0; j < diffDays; j++) {
							nextDate = DateOperation.afterNDays(nextDate, 1);
							Element category = categories.addElement("category");
							category.addAttribute("label", nextDate.substring(5));
							Element designSet = designDataset.addElement("set");
							Element dailySet = actualDataset.addElement("set");
							Element planSet = planDataset.addElement("set");
							Element forcastSet = forcastDataset.addElement("set");
							forcastSet.addAttribute("value", df.format(sum_dailyWorkLoad + avgWorkLoad * drawForcastDays));
							drawForcastDays++;
						}
					}
				}
				xmlData = document.asXML();
				int p_start = xmlData.indexOf("<chart");
				if (p_start > 0) {
					xmlData = xmlData.substring(p_start, xmlData.length());
				}
				if(noDailyData){
					chatInfo = "当前日报没有实际工作数据.";
				}
				
				xmlDataMap.put("xmlData_"+expType, xmlData);
				xmlDataMap.put("chatInfo_"+expType, chatInfo);
			}
		}	
		return xmlDataMap;
	}
	
	/**
	 * 根据expMethod编号获取内容
	 * @return
	 */
	public String getExpMethodName(String expMethodId){
		String sql = "select d.coding_name from comm_coding_sort_detail d where d.bsflag = '0' and d.coding_code_id = '"+expMethodId+"'";
		Map m = radDao.queryRecordBySQL(sql);
		if(m!=null){
			return m.get("coding_name").toString(); 
		}else{
			return null;
		}
	}
	
	/**
	 * 获取已选择的勘探方法
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getChoosenMethod(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("project_info_no");
		String activityObjectId = reqDTO.getValue("activity_object_id");
		String sql = "select m.exploration_method "+
					 "from bgp_activity_method_mapping m "+
					 "where m.bsflag = '0' "+
					 "and m.project_info_no = '"+projectInfoNo+"' "+
					 "and m.activity_object_id = '"+activityObjectId+"'";
		Map m = radDao.queryRecordBySQL(sql);
		if(m!=null){
			msg.setValue("choosenMethod",m.get("exploration_method")); 
		}
		return msg;
	}
}
