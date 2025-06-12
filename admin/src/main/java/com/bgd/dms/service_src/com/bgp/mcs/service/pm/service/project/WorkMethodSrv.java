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
	 * ��ȡ��άʩ������
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
		
		//���ݶ�����,1:�۲�ϵͳ;2:���ڲ���;3:��Դ����;4:�첨������;5:��������;6:��ǹ����
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
	 * ��ȡ��άʩ������
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
		
		//���ݶ�����,1:�۲�ϵͳ;2:���ڲ���;3:��Դ����;4:�첨������;5:��������     
		//ǳ�� ̲ǳ�� �������ݶ����� 6����ǹ
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
	 * ��ȡ��Ŀʩ������
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
	 * ��ȡ�ۺ��ﻯ̽��Ŀʩ������
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
	 * ��ȡ�ۺ��ﻯ̽��Ŀʩ������
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
	 * ��ȡ��Ŀ������ʽ
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
	 * ��ȡ�ձ����������ߣ��������
	 * ���������2013-12-05
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
	 * ��ȡ�ձ�¼��ʱ��ҵ��Ϣ
	 * ���������2013-12-09
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
          boolean bool= sitStatus.contains("In Progress");//����
		  boolean blean=sitStatus.contains("Not Started");//δ��ʼ
		  boolean bn=sitStatus.contains("Completed");//���
		 
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
	 * ��ȡ�ձ�¼��ʱ���������
	 * ���������2013-12-09
	 * @throws Exception
	 */
	public List<Map> getDailyWorkload(String projectInfoNo,String produce_date,String activity_object_id) throws Exception {
		/*����insert into��˼·�ǣ�����ƻ�����ʱ������µĹ�������Ȼ��֮ǰ¼���ɹ��������ٴ��޸ĵ���Ĺ�����ʱ���ܻ���ʾ�ɹ��������*/
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
		/*total�ֶκ�actual_units�ֶι�ϵ��total�ֶ��� produce_date֮ǰ�Ĺ�����֮�͡���ô����Ŀ����¼��ҳ���޸ı������ʱ��ȷ���޸��ۼƣ��ۼ�=������� + total*/
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
	 * �ۺϻ���̽
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
				
				//��ȡ��̽����������
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

				//�жϼƻ������Ƿ��������
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
						exNameType = "�����";
					//}else if(workLoad!=null&&!"0".equals(workLoad)&&!"".equals(workLoad)){
					}else {
						widType1="01";
						workType = "daily_workload";
						exNameType = "������";

					}
					
					xmlDataMap.put("exMethodName", exMethodName+exNameType);

						
					//��ѯ�ÿ�̽����������
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
							root.addAttribute("yAxisName", exMethodName+"��Чͼ");
					
							root.addAttribute("showLabels", "1");
							root.addAttribute("showValues", "0");
							root.addAttribute("formatNumberScale", "0");
							root.addAttribute("formatNumber", "0");
							
							Element categories = root.addElement("categories");
							Element designDataset = root.addElement("dataset");
							
							designDataset.addAttribute("seriesName", "�����Ч");
							designDataset.addAttribute("color", "1381c0");
							designDataset.addAttribute("anchorBorderColor", "1381c0");
							designDataset.addAttribute("anchorBgColor", "1381c0");
							
							Element actualDataset = root.addElement("dataset");
							actualDataset.addAttribute("seriesName", "ʵ����Ч");
							actualDataset.addAttribute("color", "fd962e");
							actualDataset.addAttribute("anchorBorderColor", "fd962e");
							actualDataset.addAttribute("anchorBgColor", "fd962e");
							

							
							
							//��Ч�ۼ�ͼ
							Document document2 = DocumentHelper.createDocument();
							Element root2 = document2.addElement("chart");
							root2.addAttribute("bgColor", "F3F5F4,DEE6EB");
							root2.addAttribute("rotateYAxisName", "0");
							root2.addAttribute("yAxisNameWidth", "16");
							root2.addAttribute("palette", "2");
							root2.addAttribute("baseFontSize", "12");
							root2.addAttribute("yAxisName", exMethodName+"��Чͼ");
							root2.addAttribute("showLabels", "1");
							root2.addAttribute("showValues", "0");
							root2.addAttribute("formatNumberScale", "0");
							root2.addAttribute("formatNumber", "0");

							Element categories2 = root2.addElement("categories");
							Element designDataset2 = root2.addElement("dataset");
							designDataset2.addAttribute("seriesName", "�����Ч");
							designDataset2.addAttribute("lineDashed", "1");
							designDataset2.addAttribute("color", "1381c0");
							designDataset2.addAttribute("anchorBorderColor", "1381c0");
							designDataset2.addAttribute("anchorBgColor", "1381c0");
							
							Element actualDataset2 = root2.addElement("dataset");
							actualDataset2.addAttribute("seriesName", "ʵ����Ч");
							actualDataset2.addAttribute("color", "fd962e");
							actualDataset2.addAttribute("anchorBorderColor", "fd962e");
							actualDataset2.addAttribute("anchorBgColor", "fd962e");
							
							//Ԥ�������Ч=
							//ʵ�������Ч/ʵ������=ÿ����Ч
							//��ÿ����Ч�ۼƵ���ʣ����Чʱֹͣ
							Element forcastDataset = root2.addElement("dataset"); // ʣ�๤������Ԥ�������Ч
							forcastDataset.addAttribute("seriesName", "Ԥ�������Ч");
							forcastDataset.addAttribute("color", "e7d948");
							forcastDataset.addAttribute("anchorBorderColor", "e7d948");
							forcastDataset.addAttribute("anchorBgColor", "e7d948");
							
							
							List<Date> listaxisDate = new ArrayList<Date>();
							double designData = 0.0;
							double dailyData = 0.0;
							
							double nowDateDailyData=0.0;
							//��ȡÿ����̽�����ձ����������
							
							for(int j=0;j<dataList.size();j++){
								Map recordMap = dataList.get(j);
								String xAxisDate = "" + recordMap.get("axis_date");				
								String design_value = "" + recordMap.get("design_data");
								String daily_value = "" + recordMap.get("daily_data");
								Date date= sdf.parse(xAxisDate);
								listaxisDate.add(date);
								Element category = categories.addElement("category");
								category.addAttribute("label", xAxisDate.substring(5));
								
								//���ֵ
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
								
								
								
								//�ۼ�
								// ��������
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
									// �ձ�ֵ
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
							
							//��ȡ��Ч�������
							String getPanlMaxDateSql="SELECT max(w.MDATE) as maxPlanDate FROM gp_proj_product_plan_wt w," +
									"bgp_activity_method_mapping m where w.PROJECT_INFO_NO='"+projectInfoNo+"' " +
									"and w.MID=m.ACTIVITY_OBJECT_ID and m.PROJECT_INFO_NO='"+projectInfoNo+"' and " +
									"m.EXPLORATION_METHOD='"+exMethodCode+"' and w.WID='"+widType1+"'";
							Map maxPlanDateMap =  radDao.queryRecordBySQL(getPanlMaxDateSql);
							String maxPlanDate = "";
							if(maxPlanDateMap!=null){
								maxPlanDate = (String)maxPlanDateMap.get("maxplandate");
							}
			
							//��ȡ�ձ�ʩ����ͣ�������������ۼƵ���ʵ�ʹ�����/����
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
									System.out.println("�����");
								}else{
								Date ZBMAX = Collections.max(listaxisDate);
								if(ZBMAX.after(nowDate)){
									//ѭ������ǰ֮ǰ��Ϊ�գ�֮�����ֻ��
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
							
							//�ڽ���֮ǰ�������жЩ���޴������֮꣬�󴴽����ꡣ���ȼ�����Ҫ������ɡ���ǰ���ڼ�������==������ꡣ����ʼѭ��ѭ�����
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
							chatInfo.append("����"+ sdf.format(nowDate)+"�ռƻ�ƽ����ЧΪ" + df.format(designData/palnDay)+ exNameType + ",ʵ��ƽ����ЧΪ"+ df.format(ycwcData) + exNameType + ";");
							chatInfo.append("�ۼ����"+dailyData+exNameType);
							if(dailyData<designData){
								chatInfo.append("��Ŀǰ����������㣬ʣ�๤����" + (designData-dailyData)+ exNameType + "��Ԥ���������Ϊ"+lastDay+"��������"+	DateOperation.diffDaysOfDate(lastDay, sdf.format(nowDate))+";");
								chatInfo.append("ʵ��������ڳ����ƻ��������");

							}else{
								chatInfo.append("�Ѿ����");
								
							}
						}else{
							chatInfo.append("Ŀǰ������������");

						}
						

						

						
						
							//�� 9���� ����ǩ����12����ô9��12�Ų������ӣ�12��֮������꣬��ǰ���� list����������������Ƕ��ܽ������������꣬������forѭ��������
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
	 * �ۺ��ﻯ̽
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
			//ȡ��������ֵ���ƻ��� . ȡ�ƻ�����
			
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
			
			// ȡ�����ʼ����
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
			
			//��ȡ�ձ�����ֹ����
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
					unit="�����";
				}else{
					if(workLoad!=null&&!"".equals(workLoad)){
						unit="������";
					}
				}
			}
			
			//ƴ��ͼ������
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
					root.addAttribute("yAxisName", expMethodName+"��Чͼ");
				}
				
				root.addAttribute("showLabels", "1");
				root.addAttribute("showValues", "0");
				root.addAttribute("formatNumberScale", "0");
				root.addAttribute("formatNumber", "0");
				
				Element categories = root.addElement("categories");
				Element designDataset = root.addElement("dataset");
				designDataset.addAttribute("seriesName", "�����Ч");
				designDataset.addAttribute("color", "1381c0");
				designDataset.addAttribute("anchorBorderColor", "1381c0");
				designDataset.addAttribute("anchorBgColor", "1381c0");
				
				Element actualDataset = root.addElement("dataset");
				actualDataset.addAttribute("seriesName", "ʵ����Ч");
				actualDataset.addAttribute("color", "fd962e");
				actualDataset.addAttribute("anchorBorderColor", "fd962e");
				actualDataset.addAttribute("anchorBgColor", "fd962e");
				
				for(int i=0; i<dataList.size(); i++){
					Map recordMap = dataList.get(i);
					String xAxisDate = "" + recordMap.get("axis_date");				
					String design_value = "" + recordMap.get("design_data");
					String daily_value = "" + recordMap.get("daily_data");
					
					// ��������
					Element category = categories.addElement("category");
					category.addAttribute("label", xAxisDate.substring(5));
					//�������
					//���ֵ
					Element designSet = designDataset.addElement("set");
					if(DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0){
					}else{
						if(design_value != "" && !"".equals(design_value)){
							//�������Ч��Ϊ0��ʱ��,showFlag = true
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
					
					//�ձ�ֵ
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
	 * �ۺ��ﻯ̽���ۼ�ֵ
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

		double designWorkLoad = 0;// ��ƹ�����
		double dailyWorkLoad = 0;// �ձ�������
		double sum_designWorkLoad = 0;// ��ƹ�����֮��
		double sum_dailyWorkLoad = 0;// �ձ�������֮��
		double sum_curDesignWorkLoad = 0;
		double sum_curDailyWorkLoad = 0;
		double avgWorkLoad = 1;// ���7��ƽ��������
		DecimalFormat df = new DecimalFormat("0.00");
		Date curDate = new Date();// ��ǰ����
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String sCurDate = sdf.format(curDate);
		Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");// [0-9]+(.[0-9]?)?+
		
		Map<String,Object> xmlDataMap = new HashMap<String,Object>();
		String taskName = "";
		String unitName = "��";
		
		//����̽�����ֱ����
		for(int k=0;k<typeList.size();k++){

			//���³�ʼ������
			chatInfo = "";
			xmlData = "";
			
			designWorkLoad = 0;// ��ƹ�����
			dailyWorkLoad = 0;// �ձ�������
			sum_designWorkLoad = 0;// ��ƹ�����֮��
			sum_dailyWorkLoad = 0;// �ձ�������֮��
			sum_curDesignWorkLoad = 0;
			sum_curDailyWorkLoad = 0;
			avgWorkLoad = 1;// ���7��ƽ��������
			
			String expType = typeList.get(k);
			// ȡ�����ʼ���ڡ�����ۻ�ֵ
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
			
			// ȡ�ձ���ʼ���ڡ��ձ��ۻ�ֵ
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
				// û���ձ�����
				if("".equals(dailyStartDate)){
					noDailyData = true;
				}
			}
			
			// ȡ��ֹ��ǰ����ƹ�����
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
			
			// ȡ��ֹ��ǰ��ʵ�ʹ�����
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
			
			// ȡ��ǰ����Ľ���״̬
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
			
			// ������Ŀ��ʼ�����ڵ����� ���ڼ������ֵ,ʵ�ʽ���ʱ��-�ƻ���ʼʱ��
			long projectUpToNowDays = DateOperation.diffDaysOfDate(dailyEndDate, designStartDate)+1;
			
			// ������Ŀʵ�ʿ�ʼ�����ڵ����� ���ڼ���ʵ��ֵ,ʵ�ʽ���ʱ��-ʵ�ʿ�ʼʱ�� 
			long actualWorkDays = DateOperation.diffDaysOfDate(dailyEndDate, dailyStartDate)+1;
			
			//������Ŀ��ʼ�����ڵ�ʩ������ ������ͣ����
			long workDay = actualWorkDays;
			
			// ���㵱ǰ�����ƽ����Ч
			double curDesignAvgWorkLoad = 0;
			if (projectUpToNowDays != 0) {
				curDesignAvgWorkLoad = sum_curDesignWorkLoad / projectUpToNowDays;
			}
			// ���㵱ǰ��ʵ��ƽ����Ч
			double curDailyAvgWorkLoad = 0;
			if (projectUpToNowDays != 0) {
				curDailyAvgWorkLoad = sum_curDailyWorkLoad / workDay;
			}
			
			long compareDate = DateOperation.diffDaysOfDate(dailyEndDate, designEndDate);
			if(compareDate >= 0){
				chatInfo = "����"+ dailyEndDate+"�ռƻ�ƽ����ЧΪ" + df.format(curDesignAvgWorkLoad) + unitName + ",ʵ��ƽ����ЧΪ"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
			}else{
				chatInfo = "����"+ dailyEndDate+"�ռƻ�ƽ����ЧΪ" + df.format(curDesignAvgWorkLoad) + unitName + ",ʵ��ƽ����ЧΪ"+ df.format(curDailyAvgWorkLoad) + unitName + ";";
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
			
			// �������7�칤������Ϊ�������
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
				root.addAttribute("yAxisName", expMethodName+"��Ч�ۼ�ͼ");
				
				root.addAttribute("showLabels", "1");
				root.addAttribute("showValues", "0");
				root.addAttribute("formatNumberScale", "0");
				root.addAttribute("formatNumber", "0");

				Element categories = root.addElement("categories");
				Element designDataset = root.addElement("dataset");
				designDataset.addAttribute("seriesName", "�����Ч");
				designDataset.addAttribute("lineDashed", "1");
				designDataset.addAttribute("color", "1381c0");
				designDataset.addAttribute("anchorBorderColor", "1381c0");
				designDataset.addAttribute("anchorBgColor", "1381c0");
				
				Element actualDataset = root.addElement("dataset");
				actualDataset.addAttribute("seriesName", "ʵ����Ч");
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

						// ��������
						Element category = categories.addElement("category");
						category.addAttribute("label", xAxisDate.substring(5));
						// �������
						// ���ֵ
						Element designSet = designDataset.addElement("set");
						if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
						} else {
							if(designWorkLoad > 0){
								designSet.addAttribute("value", "" + designWorkLoad);
							}
						}
						// �ձ�ֵ
						Element actualSet = actualDataset.addElement("set");
						if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
							actualSet.addAttribute("value", "" + dailyWorkLoad);
						}
					}
					chatInfo = chatInfo + taskName + "���������;�ۼ����"+df.format(dailyWorkLoad)+""+unitName;
				} else {
					Element forcastDataset = root.addElement("dataset"); // ʣ�๤������Ԥ�������Ч
					forcastDataset.addAttribute("seriesName", "Ԥ�������Ч");
					forcastDataset.addAttribute("color", "e7d948");
					forcastDataset.addAttribute("anchorBorderColor", "e7d948");
					forcastDataset.addAttribute("anchorBgColor", "e7d948");
					
					Element planDataset = root.addElement("dataset"); // ʣ�๤�������ƻ����������Ч
					
					planDataset.addAttribute("seriesName", "���ƻ����������Ч");
					
					planDataset.addAttribute("color", "95a700");
					planDataset.addAttribute("anchorBorderColor", "95a700");
					planDataset.addAttribute("anchorBgColor", "95a700");
					
					String axisEndDate = designEndDate;
					if (DateOperation.diffDaysOfDate(dailyEndDate, designEndDate) > 0) {
						axisEndDate = dailyEndDate;
					}
					// ����Ԥ�������Ч
					String forcastFinishDate = dailyEndDate; // Ԥ���������
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
						chatInfo = chatInfo + "��Ŀǰ����������㣬ʣ�๤����" + df.format(sum_designWorkLoad - sum_dailyWorkLoad) + unitName + "��Ԥ���������Ϊ" + forcastFinishDate + "����" + forcastFinishDays + "��.";
					}
					// ���㰴�ƻ����������Ч(��ǰ����С�ڼƻ�����ʱ)
					boolean planFinishLine = false;
					double planFinishWorkLoad = 0;
					long drawPlanDays = 1;
					long diffDays = DateOperation.diffDaysOfDate(designEndDate,	dailyEndDate);
					// long diffDays = DateOperation.diffDaysOfDate(designEndDate,dailyEndDate);
					if (diffDays > 0) {
						// ��ƹ�������ȥʵ����ɹ����� / ʣ������
						planFinishWorkLoad = (long)(sum_designWorkLoad - sum_dailyWorkLoad)/ diffDays;
						planFinishLine = true;
						chatInfo = chatInfo + "���ƻ�ʱ����ɣ�������ЧΪ" + df.format(planFinishWorkLoad) + unitName + ".";
					}else{
						chatInfo = chatInfo + "ʵ�ʹ��������ѳ����������.";
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
						// ��������
						Element category = categories.addElement("category");
						category.addAttribute("label", xAxisDate.substring(5));
						// �������
						// ���ֵ
						Element designSet = designDataset.addElement("set");
						if (DateOperation.diffDaysOfDate(xAxisDate, designEndDate) > 0) {
						} else {
							designSet.addAttribute("value", "" + designWorkLoad);
						}
						// �ձ�ֵ
						Element dailySet = actualDataset.addElement("set");
						if (DateOperation.diffDaysOfDate(xAxisDate, dailyStartDate) >= 0 && DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) <= 0) {
								dailySet.addAttribute("value", "" + dailyWorkLoad);
						}
						// ���ƻ������Чֵ
						Element planSet = planDataset.addElement("set");
						if (planFinishLine) {
							if(xAxisDate.equals(dailyEndDate)) {
								planSet.addAttribute("value", "" + sum_dailyWorkLoad);
								planSet.addAttribute("Color", "95a700");
								planSet.addAttribute("toolText", "ʵ����Ч,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
							}
							if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0) {
								planSet.addAttribute("value", "" + (sum_dailyWorkLoad + planFinishWorkLoad * drawPlanDays));
								drawPlanDays++;
							}
						}
						// Ԥ�������Чֵ
						Element forcastSet = forcastDataset.addElement("set");
						if (xAxisDate.equals(dailyEndDate)) {
							forcastSet.addAttribute("value", "" + sum_dailyWorkLoad);
							forcastSet.addAttribute("Color", "e7d948");
							forcastSet.addAttribute("toolText", "ʵ����Ч,"+xAxisDate.substring(5) + "," + sum_dailyWorkLoad);
						}
						if (DateOperation.diffDaysOfDate(xAxisDate, dailyEndDate) > 0 && DateOperation.diffDaysOfDate(forcastFinishDate, xAxisDate) >= 0) {
							drawForcastDays++;
							forcastSet.addAttribute("value", df.format(sum_dailyWorkLoad + avgWorkLoad * drawForcastDays));
						}
					}

					// Ԥ����������Ƿ��������Ľ�������(������׷����������)
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
					chatInfo = "��ǰ�ձ�û��ʵ�ʹ�������.";
				}
				
				xmlDataMap.put("xmlData_"+expType, xmlData);
				xmlDataMap.put("chatInfo_"+expType, chatInfo);
			}
		}	
		return xmlDataMap;
	}
	
	/**
	 * ����expMethod��Ż�ȡ����
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
	 * ��ȡ��ѡ��Ŀ�̽����
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
