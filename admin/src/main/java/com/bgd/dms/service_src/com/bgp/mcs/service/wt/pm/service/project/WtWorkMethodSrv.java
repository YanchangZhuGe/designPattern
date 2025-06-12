package com.bgp.mcs.service.wt.pm.service.project;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.doc.service.MyUcm;
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

public class WtWorkMethodSrv extends BaseService {

	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	private JdbcTemplate dao = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao"))
			.getJdbcTemplate();
	IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();

	// private RADJdbcDao jdbcDao = (RADJdbcDao)
	// BeanFactory.getBean("radJdbcDao");
	// private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	// private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	/**
	 * 公共
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg executeBySql(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sqls = reqDTO.getValue("sql");
		System.out.println(sqls);
		String sql[] = sqls.split(";");
		for (int i = 0; i < sql.length; i++) {
			dao.execute(sql[i]);
		}
		msg.setValue("returnCode", "0");
		return msg;
	}
	
	/**
	 * 查询人工厂源参数字段ById
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryWtAfParaById(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
//		UserToken user = reqDTO.getUserToken();
//		
//		String projectInfoNo = user.getProjectInfoNo();
		
		String paraId = reqDTO.getValue("paraId");
		
		String querySql ="select * from gp_wt_parameter_af_para t where t.id='"+paraId+"'";
		
		
		Map afParaMap = dao.queryForMap(querySql);
		responseDTO.setValue("afParaMap", afParaMap);

		
		
		return responseDTO;
	}
	
	/**
	 * 查询人工厂源参数字段
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryWtAfPara(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals("")){
			currentPage = "1";
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(10);
		
		String querySql ="select * from gp_wt_parameter_af_para t order by t.field_order";
		
		
		page = pureDao.queryRecordsBySQL(querySql,page);
		List paraList = page.getData();
		responseDTO.setValue("datas", paraList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", page.getPageSize());
		
		
		return responseDTO;
	}
	
	/**
	 * 查询人工厂源参数字段
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllWtAfPara(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String querySql ="select * from gp_wt_parameter_af_para t order by t.field_order";
		
		List allwtaf = pureDao.queryRecords(querySql);
		responseDTO.setValue("allwtaf", allwtaf);
		
		
		return responseDTO;
	}

	/**
	 * 保存设计参数
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveWtWorkMethod(ISrvMsg reqDTO) throws Exception {

		Map<String,Map<String,String>> orow = new HashMap();//其他数据 不包含测量
		List<Map> afrow = new ArrayList<Map>();//人工厂源数据
		
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		Map rs = reqDTO.toMap();
		
		
		for (Iterator i = rs.entrySet().iterator(); i.hasNext();) {
			Map.Entry entry=(Map.Entry)i.next();
			String name = (String)entry.getKey();
			String names[] = name.split("-");
			if(names.length==2){
				
					//其他勘探方法数据
					if(orow.get(names[1])==null){
						Map<String,String> rowMap =  new HashMap<String,String>();
						rowMap.put(names[0], (String)entry.getValue());
						orow.put(names[1],rowMap);
					}else{
						((Map)orow.get(names[1])).put(names[0], (String)entry.getValue());
					}
				
				
			}else if(names.length==3){
				//names[0] para_value              names[1] 勘探方法code        names[3] para_id
				if("para_value".equals(names[0])){
					//人工厂源方法
					Map<String,String> rowMap =  new HashMap<String,String>();
					rowMap.put("para_value", (String)entry.getValue());
					rowMap.put("para_id", names[2]);
					rowMap.put("method_code", names[1]);
					rowMap.put("project_info_no", project_info_no);
					
					afrow.add(rowMap);
					
					
				}
			}
			
		}
		
		//保存
		for (Iterator i = orow.entrySet().iterator(); i.hasNext();) {
			Map.Entry entry=(Map.Entry)i.next();
			String code = (String)entry.getKey();
			Map rowm = (Map)entry.getValue();
			rowm.put("method_code", code);
			rowm.put("project_info_no", project_info_no);
			
			pureDao.saveOrUpdateEntity(rowm, "gp_wt_parameter");
		}
		
		//保存 人工
		dao.execute("delete from gp_wt_parameter_af t where t.project_info_no='"+project_info_no+"'");//删除原有
		for (int i=0;i<afrow.size();i++) {
			Map rowm = (Map)afrow.get(i);
			pureDao.saveOrUpdateEntity(rowm, "gp_wt_parameter_af");
		}
		
		
		
		
	
		//测量 直接保存  不存method code
		
		Map clMap = new HashMap();
		String coordinate = reqDTO.getValue("coordinate") != null ? reqDTO
				.getValue("coordinate") : "";
		String high_work = reqDTO.getValue("high_work") != null ? reqDTO
				.getValue("high_work") : "";
		String shadow_method = reqDTO.getValue("shadow_method") != null ? reqDTO
				.getValue("shadow_method")
				: "";
		String observe_method = reqDTO.getValue("observe_method") != null ? reqDTO
				.getValue("observe_method")
				: "";
		String static_observe_method = reqDTO.getValue("static_observe_method") != null ? reqDTO
				.getValue("static_observe_method")
				: "";
		String rtk = reqDTO.getValue("rtk") != null ? reqDTO.getValue("rtk")
				: "";
		String center_control_radius = reqDTO.getValue("center_control_radius") != null ? reqDTO
				.getValue("center_control_radius")
				: "";
		String measuring_line = reqDTO.getValue("measuring_line") != null ? reqDTO
				.getValue("measuring_line")
				: "";
		String measure_precision_target = reqDTO
				.getValue("measure_precision_target") != null ? reqDTO
				.getValue("measure_precision_target") : "";
		String quality_target = reqDTO.getValue("quality_target") != null ? reqDTO
				.getValue("quality_target")
				: "";
				
		String idcl = reqDTO.getValue("idcl");//id		
		if(idcl!=null&&!idcl.equals("")){	
			clMap.put("id", idcl);//记录id
		}
		clMap.put("project_info_no", project_info_no);//项目id
		clMap.put("coordinate", coordinate);
		clMap.put("high_work", high_work);
		clMap.put("shadow_method", shadow_method);
		clMap.put("observe_method", observe_method);
		clMap.put("static_observe_method", static_observe_method);
		clMap.put("rtk", rtk);
		clMap.put("center_control_radius", center_control_radius);
		clMap.put("measuring_line", measuring_line);
		clMap.put("measure_precision_target", measure_precision_target);
		clMap.put("quality_target", quality_target);

		pureDao.saveOrUpdateEntity(clMap, "gp_wt_parameter");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		responseDTO.setValue("saveResult", "1");
		return responseDTO;
	}

	/**
	 * 获取方法数据
	 * 
	 * @throws Exception
	 */

	public ISrvMsg getWtWorkMethod(ISrvMsg reqDTO) throws Exception {
 		UserToken user = reqDTO.getUserToken();
		//String project_info_no = user.getProjectInfoNo();
		String project_info_no = reqDTO.getValue("projectInfoNo");
 		
 		if(project_info_no==null||project_info_no.equals("")){
 			project_info_no = user.getProjectInfoNo();
 		}
 		
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "select * from gp_wt_parameter t where t.project_info_no='"+ project_info_no + "' order by t.method_code";//其它
		List<Map> methodDataList = pureDao.queryRecords(sql);
		responseMsg.setValue("methodDataList", methodDataList);
		
		Map<String,String> afRsMap = new HashMap<String,String>();
		sql = "select * from gp_wt_parameter_af t where t.project_info_no='"+ project_info_no + "'";//人工场源
		List<Map> afList = pureDao.queryRecords(sql);
		for (int i = 0; i < afList.size(); i++) {
			Map orow = afList.get(i);
			String key="para_value-"+orow.get("method_code")+"-"+orow.get("para_id");
			String value=(String)orow.get("para_value");
			afRsMap.put(key, value);
		}
		responseMsg.setValue("afRsMap", afRsMap);
		
		return responseMsg;
	}
	
	/**
	 * 获取user项目对应的勘探方法
	 * 
	 * @throws Exception
	 */

	public ISrvMsg getProjectMethod(ISrvMsg reqDTO) throws Exception {
		
		
		List methodMapList = new ArrayList();
		
		UserToken user = reqDTO.getUserToken();
		
		String project_info_no = reqDTO.getValue("projectInfoNo");
		if(project_info_no==null||"".equals(project_info_no)){
			project_info_no = user.getProjectInfoNo();
		}
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "select t.exploration_method from gp_task_project t where t.project_info_no='"+ project_info_no + "'";
		Map rs = pureDao.queryRecordBySQL(sql);
		String paratemp = "";
		if(rs!=null){
			String em = (String)rs.get("exploration_method");
			String emt[] = em.split(",");
			
			for (int i = 0; i < emt.length; i++) {
				paratemp+="'"+emt[i]+"',";
			}
			
			paratemp=paratemp.substring(0,paratemp.length()-1);
			
			sql = "select t.superior_code_id,t.coding_name,t.coding_code_id from comm_coding_sort_detail t where t.coding_code_id in ("+paratemp+") order by t.coding_code_id";
			List rl = pureDao.queryRecords(sql);
			for (Iterator iterator = rl.iterator(); iterator.hasNext();) {
				rs = (Map) iterator.next();
				Map methodNameMap = new HashMap();
				methodNameMap.put("coding_name",rs.get("coding_name"));
				methodNameMap.put("coding_code_id", rs.get("coding_code_id"));
				methodNameMap.put("superior_code_id", rs.get("superior_code_id"));
				methodMapList.add(methodNameMap);
			}
			
		}
		
		responseMsg.setValue("methodMapList", methodMapList);
		
	
		return responseMsg;
	}
	

}
