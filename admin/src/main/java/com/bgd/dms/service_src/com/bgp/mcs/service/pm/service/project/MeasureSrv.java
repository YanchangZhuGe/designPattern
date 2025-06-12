package com.bgp.mcs.service.pm.service.project;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class MeasureSrv extends BaseService {

	public MeasureSrv(){
		log = LogFactory.getLogger(MeasureSrv.class);
	}
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	public ISrvMsg queryMeasureList(ISrvMsg isrvmsg) throws Exception {
		log.debug("...........queryMeasureList!");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String projectInfoNo = isrvmsg.getValue("projectInfoNo");
		String measureType = isrvmsg.getValue("measureType");
		String view_measurement = isrvmsg.getValue("viewmeasurement"); //判断是否只是查看
		//String projectName = isrvmsg.getValue("projectName");
		DecimalFormat numFormat = new DecimalFormat("##0.00"); 
		String projectName = jdbcDao.queryRecordBySQL("select p.project_name from gp_task_project p where p.bsflag='0' and p.project_info_no ='"+projectInfoNo+"'").get("project_name").toString();
		
		StringBuffer querySql = new StringBuffer("select t.terrain_measure_id,t.project_info_no,t.line_no,");
		querySql.append("t.jb_mountain_one,t.jb_mountain_two,t.jb_mountain_three,t.jb_desert_small,t.jb_desert_big,t.jb_sw_zz,t.jb_yzw_nt,t.jb_wzw_nt,");
		querySql.append("t.px_mountain_one,t.px_mountain_two,t.px_mountain_three,t.px_desert_small,t.px_desert_big,t.px_sw_zz,t.px_yzw_nt,t.px_wzw_nt ");
		querySql.append("from bgp_pm_terrain_measure t where t.bsflag = '0' and t.measure_confirm = '"+measureType+"' and t.project_info_no = '"+projectInfoNo+"'");
		querySql.append(" order by t.create_date desc");
		
		List<Map> measureList = jdbcDao.queryRecords(querySql.toString());
		List<Map<String,Object>> showMeasureList = new ArrayList<Map<String,Object>>();
		
		float total_jb_mountain_one = 0;
		float total_jb_mountain_two = 0;
		float total_jb_mountain_three = 0;
		float total_jb_desert_small = 0;
		float total_jb_desert_big = 0;
		float total_jb_sw_zz = 0;
		float total_jb_yzw_nt = 0;
		float total_jb_wzw_nt = 0;
		
		float total_px_mountain_one = 0;
		float total_px_mountain_two = 0;
		float total_px_mountain_three = 0;
		float total_px_desert_small = 0;
		float total_px_desert_big = 0;
		float total_px_sw_zz = 0;
		float total_px_yzw_nt = 0;
		float total_px_wzw_nt = 0;
		
		for(int i=0;i<measureList.size();i++){
			Map<String,Object> measureMap = new HashMap<String, Object>();
			
			measureMap.put("terrain_measure_id", measureList.get(i).get("terrain_measure_id"));
			measureMap.put("line_no", measureList.get(i).get("line_no")!=null?measureList.get(i).get("line_no"):"");
			
			measureMap.put("jb_mountain_one", measureList.get(i).get("jb_mountain_one")!=null?measureList.get(i).get("jb_mountain_one"):"");
			measureMap.put("jb_mountain_two", measureList.get(i).get("jb_mountain_two")!=null?measureList.get(i).get("jb_mountain_two"):"");	
			measureMap.put("jb_mountain_three", measureList.get(i).get("jb_mountain_three")!=null?measureList.get(i).get("jb_mountain_three"):"");				
			measureMap.put("jb_desert_small", measureList.get(i).get("jb_desert_small")!=null?measureList.get(i).get("jb_desert_small"):"");
			measureMap.put("jb_desert_big", measureList.get(i).get("jb_desert_big")!=null?measureList.get(i).get("jb_desert_big"):"");				
			measureMap.put("jb_sw_zz", measureList.get(i).get("jb_sw_zz")!=null?measureList.get(i).get("jb_sw_zz"):"");
			measureMap.put("jb_yzw_nt", measureList.get(i).get("jb_yzw_nt")!=null?measureList.get(i).get("jb_yzw_nt"):"");	
			measureMap.put("jb_wzw_nt", measureList.get(i).get("jb_wzw_nt")!=null?measureList.get(i).get("jb_wzw_nt"):"");	
			
			measureMap.put("px_mountain_one", measureList.get(i).get("px_mountain_one")!=null?measureList.get(i).get("px_mountain_one"):"");
			measureMap.put("px_mountain_two", measureList.get(i).get("px_mountain_two")!=null?measureList.get(i).get("px_mountain_two"):"");	
			measureMap.put("px_mountain_three", measureList.get(i).get("px_mountain_three")!=null?measureList.get(i).get("px_mountain_three"):"");				
			measureMap.put("px_desert_small", measureList.get(i).get("px_desert_small")!=null?measureList.get(i).get("px_desert_small"):"");
			measureMap.put("px_desert_big", measureList.get(i).get("px_desert_big")!=null?measureList.get(i).get("px_desert_big"):"");				
			measureMap.put("px_sw_zz", measureList.get(i).get("px_sw_zz")!=null?measureList.get(i).get("px_sw_zz"):"");
			measureMap.put("px_yzw_nt", measureList.get(i).get("px_yzw_nt")!=null?measureList.get(i).get("px_yzw_nt"):"");	
			measureMap.put("px_wzw_nt", measureList.get(i).get("px_wzw_nt")!=null?measureList.get(i).get("px_wzw_nt"):"");
			
			showMeasureList.add(measureMap);
			
			if(measureList.get(i).get("jb_mountain_one").toString() != "" && measureList.get(i).get("jb_mountain_one").toString() != null){
				total_jb_mountain_one += Float.parseFloat(measureList.get(i).get("jb_mountain_one").toString());
			}
			if(measureList.get(i).get("jb_mountain_two").toString() != "" && measureList.get(i).get("jb_mountain_two").toString() != null){
				total_jb_mountain_two += Float.parseFloat(measureList.get(i).get("jb_mountain_two").toString());
			}
			if(measureList.get(i).get("jb_mountain_three").toString() != "" && measureList.get(i).get("jb_mountain_three").toString() != null){
				total_jb_mountain_three += Float.parseFloat(measureList.get(i).get("jb_mountain_three").toString());
			}
			if(measureList.get(i).get("jb_desert_small").toString() != "" && measureList.get(i).get("jb_desert_small").toString() != null){
				total_jb_desert_small += Float.parseFloat(measureList.get(i).get("jb_desert_small").toString());
			}
			if(measureList.get(i).get("jb_desert_big").toString() != "" && measureList.get(i).get("jb_desert_big").toString() != null){
				total_jb_desert_big += Float.parseFloat(measureList.get(i).get("jb_desert_big").toString());
			}
			if(measureList.get(i).get("jb_sw_zz").toString() != "" && measureList.get(i).get("jb_sw_zz").toString() != null){
				total_jb_sw_zz += Float.parseFloat(measureList.get(i).get("jb_sw_zz").toString());
			}
			if(measureList.get(i).get("jb_yzw_nt").toString() != "" && measureList.get(i).get("jb_yzw_nt").toString() != null){
				total_jb_yzw_nt += Float.parseFloat(measureList.get(i).get("jb_yzw_nt").toString());
			}
			if(measureList.get(i).get("jb_wzw_nt").toString() != "" && measureList.get(i).get("jb_wzw_nt").toString() != null){
				total_jb_wzw_nt += Float.parseFloat(measureList.get(i).get("jb_wzw_nt").toString());
			}
			
			if(measureList.get(i).get("px_mountain_one").toString() != "" && measureList.get(i).get("px_mountain_one").toString() != null){
				total_px_mountain_one += Float.parseFloat(measureList.get(i).get("px_mountain_one").toString());
			}
			if(measureList.get(i).get("px_mountain_two").toString() != "" && measureList.get(i).get("px_mountain_two").toString() != null){
				total_px_mountain_two += Float.parseFloat(measureList.get(i).get("px_mountain_two").toString());
			}
			if(measureList.get(i).get("px_mountain_three").toString() != "" && measureList.get(i).get("px_mountain_three").toString() != null){
				total_px_mountain_three += Float.parseFloat(measureList.get(i).get("px_mountain_three").toString());
			}
			if(measureList.get(i).get("px_desert_small").toString() != "" && measureList.get(i).get("px_desert_small").toString() != null){
				total_px_desert_small += Float.parseFloat(measureList.get(i).get("px_desert_small").toString());
			}
			if(measureList.get(i).get("px_desert_big").toString() != "" && measureList.get(i).get("px_desert_big").toString() != null){
				total_px_desert_big += Float.parseFloat(measureList.get(i).get("px_desert_big").toString());
			}
			if(measureList.get(i).get("px_sw_zz").toString() != "" && measureList.get(i).get("px_sw_zz").toString() != null){
				total_px_sw_zz += Float.parseFloat(measureList.get(i).get("px_sw_zz").toString());
			}
			if(measureList.get(i).get("px_yzw_nt").toString() != "" && measureList.get(i).get("px_yzw_nt").toString() != null){
				total_px_yzw_nt += Float.parseFloat(measureList.get(i).get("px_yzw_nt").toString());
			}
			if(measureList.get(i).get("px_wzw_nt").toString() != "" && measureList.get(i).get("px_wzw_nt").toString() != null){
				total_px_wzw_nt += Float.parseFloat(measureList.get(i).get("px_wzw_nt").toString());
			}
			
		}
		responseDTO.setValue("showMeasureList", showMeasureList);
		
		responseDTO.setValue("total_jb_mountain_one", numFormat.format(total_jb_mountain_one));
		responseDTO.setValue("total_jb_mountain_two", numFormat.format(total_jb_mountain_two));
		responseDTO.setValue("total_jb_mountain_three", numFormat.format(total_jb_mountain_three));
		responseDTO.setValue("total_jb_desert_small", numFormat.format(total_jb_desert_small));
		responseDTO.setValue("total_jb_desert_big", numFormat.format(total_jb_desert_big));
		responseDTO.setValue("total_jb_sw_zz", numFormat.format(total_jb_sw_zz));
		responseDTO.setValue("total_jb_yzw_nt", numFormat.format(total_jb_yzw_nt));
		responseDTO.setValue("total_jb_wzw_nt", numFormat.format(total_jb_wzw_nt));
		
		responseDTO.setValue("total_px_mountain_one", numFormat.format(total_px_mountain_one));
		responseDTO.setValue("total_px_mountain_two", numFormat.format(total_px_mountain_two));
		responseDTO.setValue("total_px_mountain_three", numFormat.format(total_px_mountain_three));
		responseDTO.setValue("total_px_desert_small", numFormat.format(total_px_desert_small));
		responseDTO.setValue("total_px_desert_big", numFormat.format(total_px_desert_big));
		responseDTO.setValue("total_px_sw_zz", numFormat.format(total_px_sw_zz));
		responseDTO.setValue("total_px_yzw_nt", numFormat.format(total_px_yzw_nt));
		responseDTO.setValue("total_px_wzw_nt", numFormat.format(total_px_wzw_nt));
		responseDTO.setValue("projectName", projectName);
		responseDTO.setValue("measureType", measureType);
		responseDTO.setValue("viewmeasurement", view_measurement);
		
		return responseDTO;
	}
}
