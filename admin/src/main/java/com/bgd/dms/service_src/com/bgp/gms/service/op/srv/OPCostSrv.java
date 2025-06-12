package com.bgp.gms.service.op.srv;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.net.URLDecoder;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import net.sf.json.JSONArray;

import org.apache.commons.lang.time.DateUtils;
import org.apache.poi.hssf.usermodel.DVConstraint;
import org.apache.poi.hssf.usermodel.HSSFDataValidation;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddressList;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.op.util.OPCaculator;
import com.bgp.gms.service.op.util.OPCommonUtil;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WFCommonBean;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WFVarBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 
 * 标题：
 * 
 * 作者：邱庆豹，2012 6 8
 * 
 * 描述：费用管理操作服务类
 * 
 * 更改：添加目标费用管理 2012/7/3
 * 
 * 更改:添加目标费用分摊管理 2012/7/4
 */
@SuppressWarnings({ "unchecked", "rawtypes", "deprecation" })
public class OPCostSrv extends BaseService {

	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	
	private static RADJdbcDao radjdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	static WFCommonBean wfBean = (WFCommonBean) BeanFactory.getBean("WFCommonBean");

	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();

	private final static String LineAColor = "1381c0";
	private final static String LineBColor = "fd962e";
	private final static String LineCColor = "666666";

	private final static String PillarAColor = "78bce5";
	private final static String PillarBColor = "f5d34b";

	public void saveDatasBySql(String sqls) throws Exception {
		//System.out.println(sqls);
		String sql[] = sqls.split(";");
		for(int i=0 ;i<sql.length;i++){
			jdbcTemplate.execute(sql[i]);
		}
	}
	/**
	 * 公共 --> 保存(map)
	 * 
	 * author xiaoxia 
	 * date 2013-11-08
	 * @param reqDTO
	 */
	public ISrvMsg savedDatasByMap(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map map = reqDTO.toMap();
		log.info(map);
		String table_name = (String)map.get("table_name");
		String table_key_id = "";
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,table_name);
		table_key_id = id.toString();
		msg.setValue("table_key_id", table_key_id);
		return msg;
	}
	
	public ISrvMsg saveConfirmRecrdWs(ISrvMsg reqDTO) throws Exception{
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map map = reqDTO.toMap();
		log.info(map);
		String project_info_id = (String)map.get("project_info_id");
		String contracts_signed_change = (String)map.get("contracts_signed_change");	
		String complete_value_change = (String)map.get("complete_value_change");	
		String contracts_signed = (String)map.get("contracts_signed");	
		String complete_value = (String)map.get("complete_value");
		String project_year = (String)map.get("project_year");
		String ifcarry = (String)map.get("ifcarry");
		String creator_id =  user.getUserId();
		String creator_name =  user.getUserName();
		
		String projectInfoSql = "select PROJECT_NAME from GP_TASK_PROJECT where PROJECT_INFO_NO='"+project_info_id+"'";
		Map projectInfoMap =  radjdbcDao.queryRecordBySQL(projectInfoSql);
		String projectName = (String)projectInfoMap.get("project_name");
		
		String recordId = UUID.randomUUID().toString().replaceAll("-", "");
		String sql="INSERT INTO BGP_OP_MONEY_CONFIRM_RECORD_WS(RECORD_ID, PROJECT_INFO_ID, CONTRACTS_SIGNED, CONTRACTS_SIGNED_CHANGE, COMPLETE_VALUE, COMPLETE_VALUE_CHANGE, CHANGE_STATUS, CREATE_DATE, CREATOR_ID, CREATOR_NAME,BSFLAG,YEAR,IF_CARRY)"+ 
													" VALUES('"+recordId+"', '"+project_info_id+"', '"+contracts_signed+"', '"+contracts_signed_change+"', '"+complete_value+"', '"+complete_value_change+"', '', SYSDATE, '"+creator_id+"', '"+creator_name+"','0','"+project_year+"','"+ifcarry+"')";
		radjdbcDao.executeUpdate(sql);
		
		String businessId = recordId;
		String businessTableName = "BGP_OP_MONEY_CONFIRM_RECORD_WS";
		String businessType = "5110000004100001086";
		String businessInfo = "井中项目金额确认申请";
		
		
		String applicantDate = df.format(new Date());
		Map mapwf = new HashMap();
		
		mapwf.put("wfVar_projectName", projectName);
		mapwf.put("wfVar_record_id", businessId);
		mapwf.put("wfVar_ifcarry", ifcarry);
		WFVarBean wfVar = new WFVarBean(businessId, businessTableName,
				businessType, businessInfo, 
				wfBean.copyMapFromStartMap(mapwf, "wfVar_"),
				projectName, user ,applicantDate);
		String procinstId = wfBean.startWFProcess(wfVar);
		String forwardUrl = reqDTO.getValue("forwardUrl");
		msg.setValue("message", "success");
		return msg;
	}
	public ISrvMsg saveCarrayOverProjectWs(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map map = reqDTO.toMap();
		String project_info_id = (String)map.get("project_info_id");
		String contracts_signed_carryover = (String)map.get("contracts_signed_carryover");
		String complete_value_carryover = (String)map.get("complete_value_carryover");
		String year_carryover = (String)map.get("year_carryover");
		String well_number_ = (String)map.get("well_number_");

		String carryoverId = UUID.randomUUID().toString().replaceAll("-", "");
		String sql="INSERT INTO BGP_OP_PROJECT_MONEY_CARRYOVER(CARRYOVER_ID, YEAR, PROJECT_INFO_NO, IF_CHANGE, CREATE_DATE, BSFLAG, CONTRACTS_SIGNED_CARRYOVER, COMPLETE_VALUE_CARRYOVER, CREATOR_ID, CREATOR_NAME,PROJECT_NAME_CARRYOVER) "
											+" VALUES('"+carryoverId+"', '"+year_carryover+"', '"+project_info_id+"', '0', SYSDATE, '0','"+contracts_signed_carryover+"', '"+complete_value_carryover+"', '"+user.getUserId()+"', '"+user.getUserName()+"','"+well_number_+year_carryover+"年度')";
		radjdbcDao.executeUpdate(sql);
		return msg;

	}
	
	public ISrvMsg deleteCarry(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String carryover_id = reqDTO.getValue("carryover_id");
		String strsql="update  BGP_OP_PROJECT_MONEY_CARRYOVER set BSFLAG='1' where CARRYOVER_ID='"+carryover_id+"'";
		int temp = radjdbcDao.executeUpdate(strsql);
		msg.setValue("message", "success");
		return msg;
	}
	public ISrvMsg saveFCSM(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map map = reqDTO.toMap();
		log.info(map);
		String project_info_id = (String)map.get("project_info_id");
		String contracts_signed = (String)map.get("contracts_signed");	
		String complete_value = (String)map.get("complete_value");

		String strsql="update BGP_WS_DAILY_REPORT set contracts_signed='"+contracts_signed+"' , complete_value='"+complete_value+"',CONTRACTS_MONEY_STAUTS='1' where PROJECT_INFO_NO='"+project_info_id+"'";
		int temp = radjdbcDao.executeUpdate(strsql);
		msg.setValue("message", "success");
		return msg;
	}
	
	/*
	 * 获取费用模板信息，返回json串
	 */
	
	public ISrvMsg deleteTargetCostPlan(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String param = reqDTO.getValue("param");
		String[] params = param.split(",");
		for(int i=0;i<params.length;i++){
			String plansql = "update BGP_OP_TARGET_COST_PLAN_WS set BSFLAG='1' where target_cost_id='"+params[i]+"'";
			jdbcTemplate.execute(plansql);
		}
		msg.setValue("returnCode","0");
		return msg;

	}
	
	public ISrvMsg saveOrUpdateTargetCostPlan(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String target_cost_id = reqDTO.getValue("target_cost_id");
		String project_info_no = reqDTO.getValue("project_info_no");
		String file_id_old = reqDTO.getValue("file_id");
		
		String ucmDocId = "";
		String uploadFileName="";
		MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	//	String uploadFileName = reqDTO.getValue("upload_file_name") != null?reqDTO.getValue("upload_file_name"):"";

		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList.size()!=0){
			for(int i=0;i<fileList.size();i++){
				WSFile uploadFile = fileList.get(i);
				uploadFileName=uploadFile.getFilename();
				byte[] uploadData = uploadFile.getFileData();
				ucmDocId = myUcm.uploadFile(uploadFileName, uploadData);
			}
		}
		if(ucmDocId!=""){
			String org_id = user.getOrgId();
			String org_subjection_id = user.getOrgSubjectionId();
			String user_id = user.getUserId();
			String qc_id = radjdbcDao.generateUUID();
			String file_id = radjdbcDao.generateUUID();
			StringBuffer sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id ,parent_file_id,file_number)");
			sbSql.append("values('").append(file_id).append("','").append(uploadFileName).append("','").append(ucmDocId).append("','").append(qc_id).append("','").append(project_info_no).append("','0',sysdate,'")
			.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append(org_id).append("','").append(org_subjection_id).append("','','')");
			
			jdbcTemplate.execute(sbSql.toString());
			myUcm.docVersion(file_id, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);
			myUcm.docLog(file_id, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);
			file_id_old = file_id;
		}		
		
		Map<String,Object> map =  new HashMap<String, Object>();
		if(target_cost_id!=null&&!"".equals(target_cost_id)){
			map.put("target_cost_id", target_cost_id);
		}else{
			map.put("create_date", new Date());

		}
		map.put("project_info_no", project_info_no);
		map.put("project_name", user.getProjectName());

		if(uploadFileName!=""){
			map.put("fileName", uploadFileName);
		}
		

		map.put("file_id", file_id_old);
		map.put("bsflag", "0");
		map.put("creator_id", user.getUserId());
		map.put("creator_name", user.getUserName());
		map.put("modifi_date", new Date());
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_OP_TARGET_COST_PLAN_WS");
		return msg;
	
	}

	public ISrvMsg getCostTemplate(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = reqDTO.getValue("costType");

		/*StringBuffer sqlBuffer = new StringBuffer("select connect_by_root(template_id) root,level,formula_type,formula_content, ");
		sqlBuffer.append(" decode(formula_type,'0','计划实际公式维护','1','计划实际手动维护','2','计划公式实际手动维护','3','计划手动实际公式维护') formula_type_name, ");
		sqlBuffer.append("decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(template_id, '/') path, ");
		sqlBuffer.append("cost_name,cost_desc,template_id,parent_id,parent_id zip,order_code ");
		sqlBuffer.append("from (select coding_code template_id,coding_name cost_name,''  cost_desc,'root' parent_id,  0 order_code,'' formula_type,'' formula_content ");
		sqlBuffer.append("from comm_coding_sort_detail where coding_sort_id = '5110000023' ");
		sqlBuffer.append("union ");
		sqlBuffer.append("select template_id, cost_name, cost_desc, parent_id,order_code,formula_type,formula_content from bgp_op_cost_template where bsflag='0'");
		sqlBuffer.append(") ");
		sqlBuffer.append("start with parent_id = '" + costType + "' connect by prior template_id = parent_id   order by parent_id ,order_code asc ");
		List list = jdbcDao.queryRecords(sqlBuffer.toString());

		Map map = new HashMap();
		map.put("templateId", costType);
		map.put("parentId", "root");
		map.put("costName", "东方地球物理公司");
		map.put("costDesc", "");
		map.put("expanded", "true");
		map.put("zip", "root");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "templateId", "parentId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);*/
		
		/*夏秋雨修改 ，为了适应井中、综合物化探、滩浅海等拓展业务*/
		String node = reqDTO.getValue("node");
		JSONArray json = null;
		if(node==null || node.trim().equals("") || node.trim().equals("root")){//展开的是根节点
			StringBuffer sb  = new StringBuffer();
			sb.append(" select t.coding_code_id id,t.coding_name cost_name ,'' template_id ,'root' parent_id,'' cost_desc ,'root' zip,'false' leaf ")
			.append(" from comm_coding_sort_detail t where t.bsflag ='0' and t.coding_sort_id like '5000100004' ")
			.append(" and (t.coding_code_id ='5000100004000000001' or t.coding_code_id ='5000100004000000006' or t.coding_code_id ='5000100004000000008' ")
			.append(" or t.coding_code_id ='5000100004000000009' or t.coding_code_id ='5000100004000000010') order by t.coding_code_id");

			List root = jdbcDao.queryRecords(sb.toString());
			json = JSONArray.fromObject(root);
			
		}else{
			String parent_id = "01";
			String project_type = "";
			String type = "";
			if(node.trim().startsWith("5000100004")){//展开的是拓展业务节点
				if(node.trim().startsWith("5000100004000000009")){//综合物化探业务，区分物探处和项目
					StringBuffer sb  = new StringBuffer();
					//sb.append("select '5000100004000000009'||':'||'1' id ,'物探处' cost_name ,'false' leaf from dual union ")
					sb.append("select '5000100004000000009'||':'||'2' id ,'项目' cost_name,'false' leaf from dual");

					List root = jdbcDao.queryRecords(sb.toString());
					json = JSONArray.fromObject(root);
				}if(node.trim().startsWith("5000100004000000009:")){//综合物化探业务，区分物探处和项目
					project_type = node.split(":")[0];
					type = node.split(":")[1];
					StringBuffer sb  = new StringBuffer();
					sb.append(" select spare5||':'||t.template_id||':'||t.spare1 id,t.cost_name ,t.cost_desc ,t.template_id,t.parent_id zip,t.order_code,t.formula_type,t.formula_content, ")
					.append(" decode(formula_type,'0','计划实际公式维护','1','计划实际手动维护','2','计划公式实际手动维护','3','计划手动实际公式维护') formula_type_name, ")
					.append(" decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf from bgp_op_cost_template t where t.bsflag ='0' and t.spare1 ='"+project_type+"' and t.parent_id ='01' ")
					.append(" and spare5 ='"+type+"' start with t.parent_id ='01' connect by prior t.template_id = t.parent_id order siblings by t.order_code ");

					List root = jdbcDao.queryRecords(sb.toString());
					json = JSONArray.fromObject(root);
				}else if(!node.trim().startsWith("5000100004000000009")){//陆地、井中、滩浅海等业务节点
					StringBuffer sb  = new StringBuffer();
					sb.append(" select spare5||':'||t.template_id||':'||t.spare1 id,t.cost_name ,t.cost_desc ,t.template_id,t.parent_id zip,t.order_code,t.formula_type,t.formula_content, ")
					.append(" decode(formula_type,'0','计划实际公式维护','1','计划实际手动维护','2','计划公式实际手动维护','3','计划手动实际公式维护') formula_type_name, ")
					.append(" decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf from bgp_op_cost_template t where t.bsflag ='0' and t.spare1 ='"+node+"' and t.parent_id ='01' ")
					.append(" start with t.parent_id ='01' connect by prior t.template_id = t.parent_id order siblings by t.order_code ");

					List root = jdbcDao.queryRecords(sb.toString());
					json = JSONArray.fromObject(root);
				}
			}else{//费用节点
				parent_id = node.split(":")[1];
				project_type = node.split(":")[2];
				type = node.split(":")[0];
				StringBuffer sb  = new StringBuffer();
				sb.append(" select spare5||':'||t.template_id||':'||t.spare1 id,t.cost_name ,t.cost_desc ,t.template_id,t.parent_id zip,t.order_code,t.formula_type,t.formula_content, ")
				.append(" decode(formula_type,'0','计划实际公式维护','1','计划实际手动维护','2','计划公式实际手动维护','3','计划手动实际公式维护') formula_type_name, ")
				.append(" decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf from bgp_op_cost_template t where t.bsflag ='0' and t.spare1 ='"+project_type+"' and t.parent_id ='"+parent_id+"' ")
				.append(" start with t.parent_id ='"+parent_id+"' connect by prior t.template_id = t.parent_id order siblings by t.order_code ");

				List root = jdbcDao.queryRecords(sb.toString());
				json = JSONArray.fromObject(root);
			}
		}
		responseDTO.setValue("json", json.toString());
		return responseDTO;
	}

	/*
	 * 获取费用模板信息，返回json串
	 */

	public ISrvMsg getCostTemplateOther(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = reqDTO.getValue("costType");
		String templateType=reqDTO.getValue("templateType");

		StringBuffer sqlBuffer = new StringBuffer("select connect_by_root(template_id) root,level,formula_type,formula_content, ");
		sqlBuffer.append(" decode(formula_type,'0','计划实际公式维护','1','计划实际手动维护','2','计划公式实际手动维护','3','计划手动实际公式维护') formula_type_name, ");
		sqlBuffer.append("decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(template_id, '/') path, ");
		sqlBuffer.append("cost_name,cost_desc,template_id,parent_id,parent_id zip,order_code ");
		sqlBuffer.append("from (select coding_code template_id,coding_name cost_name,''  cost_desc,'root' parent_id,  0 order_code,'' formula_type,'' formula_content ");
		sqlBuffer.append("from comm_coding_sort_detail where coding_sort_id = '5110000023' ");
		sqlBuffer.append("union ");
		sqlBuffer.append("select template_id, cost_name, cost_desc, parent_id,order_code,formula_type,formula_content from bgp_op_cost_template_other where bsflag='0' and template_type='"+templateType+"'");
		sqlBuffer.append(") ");
		sqlBuffer.append("start with parent_id = '" + costType + "' connect by prior template_id = parent_id   order by parent_id ,order_code asc ");
		List list = jdbcDao.queryRecords(sqlBuffer.toString());

		Map map = new HashMap();
		map.put("templateId", costType);
		map.put("parentId", "root");
		map.put("costName", "东方地球物理公司");
		map.put("costDesc", "");
		map.put("expanded", "true");
		map.put("zip", "root");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "templateId", "parentId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}
	
	/*
	 * 异步加载树
	 */
	public ISrvMsg getCostTemplateAsync(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String parentId = reqDTO.getValue("node");
		String costType = reqDTO.getValue("costType");
		if (parentId == null || "".equals(parentId) || "root".equals(parentId)) {
			parentId = costType;
		}
		StringBuffer sqlBuffer = new StringBuffer("select * from (select connect_by_root(template_id) root,level cur_depth, ");
		sqlBuffer.append("decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(template_id, '/') path, ");
		sqlBuffer.append("cost_name,cost_desc,template_id,parent_id,parent_id zip,order_code,template_id id ");
		sqlBuffer.append("from (select coding_code template_id,coding_name cost_name,''  cost_desc,'root' parent_id,  0 order_code ");
		sqlBuffer.append("from comm_coding_sort_detail where coding_sort_id = '5110000023' ");
		sqlBuffer.append("union ");
		sqlBuffer.append("select template_id, cost_name, cost_desc, parent_id,order_code from bgp_op_cost_template where bsflag='0'");
		sqlBuffer.append(") ");
		sqlBuffer.append("start with parent_id = '" + parentId + "' connect by prior template_id = parent_id   order by order_code asc) where cur_depth= '1' ");
		List list = jdbcDao.queryRecords(sqlBuffer.toString());

		JSONArray retJson = JSONArray.fromObject(list);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}

	/*
	 * 获取项目费用信息，返回json串
	 */
	public ISrvMsg getCostProject(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String costType = reqDTO.getValue("costType");
		String costProjectSchemaId = reqDTO.getValue("costProjectSchemaId");
		if (costType == null || "null".equals(costType) || "".equals(costType)) {
			costType = OPCommonUtil.getCostTypeBySchemaId(costProjectSchemaId);
		}
		StringBuffer sqlBuffer = new StringBuffer("");
		sqlBuffer.append("with total_money as(select sum(nvl(pd.cost_detail_money,0)) total_money ")
		.append(" from bgp_op_cost_project_info p  left join bgp_op_cost_project_detail pd on p.gp_cost_project_id = pd.gp_cost_project_id and pd.bsflag ='0' ")
		.append(" where p.bsflag ='0' and p.cost_project_schema_id ='"+costProjectSchemaId+"'  and p.node_code like 'S01001%')")
		.append(" select tt.*,(select case when nvl(tm.total_money,0)=0 then '' when (tt.node_code='S01001006' or tt.node_code='S01001001' or tt.node_code='S01001004'")
		.append(" or tt.node_code='S01001002' or tt.node_code='S01001003') then round(nvl(tt.cost_detail_money,0)/nvl(tm.total_money,0)*10000)/100.0 ||'%' ")
		.append(" else '' end radio from total_money tm ) radio from(")
		.append(" select t.gp_cost_project_id,t.parent_id ,t.cost_name ,decode(connect_by_isleaf,0,'false','true') is_leaf,t.node_code,decode(connect_by_isleaf,0,'false','true') leaf,")
		.append(" (select sum(nvl(pd.cost_detail_money,0)) cost_detail_money from bgp_op_cost_project_info p ")
		.append(" left join bgp_op_cost_project_detail pd on p.gp_cost_project_id = pd.gp_cost_project_id and pd.bsflag ='0'")
		.append(" where p.bsflag ='0' and p.cost_project_schema_id ='"+costProjectSchemaId+"' ")
		.append(" and p.node_code like t.node_code ||'%') cost_detail_money,")
		.append(" (select pd.cost_detail_desc cost_detail_money from bgp_op_cost_project_detail pd ")
		.append(" where pd.bsflag='0' and pd.gp_cost_project_id = t.gp_cost_project_id ")
		.append(" and pd.cost_project_schema_id ='"+costProjectSchemaId+"') cost_detail_desc ")
		
		.append(" from bgp_op_cost_project_info t where t.bsflag ='0' and t.cost_project_schema_id ='"+costProjectSchemaId+"' ")
		.append(" start with t.parent_id ='01' connect by prior t.gp_cost_project_id = t.parent_id order siblings by t.order_code) tt");

		List<Map> list = jdbcDao.queryRecords(sqlBuffer.toString());
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list != null ? list.size() : 0);

		responseDTO.setValue("pageCount", "1");
		responseDTO.setValue("pageSize", "0");
		responseDTO.setValue("currentPage", "1");
		// 获取项目名称
		String projectName = OPCommonUtil.getProjectNameByProjectInfoNo(projectInfoNo);
		Map map = new HashMap();
		map.put("gpCostProjectId", costType);
		map.put("parentId", "root");
		map.put("costName", projectName);
		map.put("costDetailMoney", "");
		map.put("costDetailDesc", "");
		map.put("expanded", "true");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "gpCostProjectId", "parentId", map);
		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}

	/*
	 * 获取项目费用类型costType
	 */
	public ISrvMsg getProjectCostType(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = "";
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			String sqlCostType = " select distinct cost_type from bgp_op_cost_project_info where bsflag='0' and  project_info_no='" + projectInfoNo + "'";
			Map map = jdbcDao.queryRecordBySQL(sqlCostType);
			if (map != null && map.get("costType") != null && !"".equals(map.get("costType"))) {
				costType = (String) map.get("costType");
			} else {
				String sqlCode = "SELECT t.coding_code AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='5110000023' and t.bsflag='0' order by t.coding_show_id ";
				List list = jdbcDao.queryRecords(sqlCode);
				if (list != null && list.size() > 0) {
					Map mapCode = (Map) list.get(0);
					if (mapCode != null) {
						costType = (String) mapCode.get("costType");
					}
				}
			}
		} else {
			costType = OPCommonUtil.getCodeFirstData("5110000023");
		}
		responseDTO.setValue("costType", costType);
		return responseDTO;
	}

	/*
	 * 保存项目费用数据(从模板导入的情况)
	 */
	public ISrvMsg saveProjectCostByTemplate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = reqDTO.getValue("costType");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String costProjectSchemaId = reqDTO.getValue("costProjectSchemaId");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			String sqlDelete = "delete from  bgp_op_cost_project_info  where project_info_no='" + projectInfoNo + "' and cost_project_schema_id='" + costProjectSchemaId + "'";
			jdbcTemplate.execute(sqlDelete);
			String sqlInsert = "insert into bgp_op_cost_project_info (gp_cost_project_id,template_id,project_info_no,node_code,cost_name,cost_desc,order_code,cost_type,parent_id,create_date,cost_project_schema_id,bsflag) "
					+ "(select   SYS_GUID () AS key_id,TEMPLATE_ID,'"
					+ projectInfoNo
					+ "',node_code,cost_name,cost_desc,order_code,cost_type,parent_id,sysdate,'"
					+ costProjectSchemaId + "','0' from bgp_op_cost_template where bsflag='0' and  cost_type = '" + costType + "')";
			jdbcTemplate.execute(sqlInsert);
			String sqlUpdate = "update bgp_op_cost_project_info t set t.parent_id =(select p.gp_cost_project_id from bgp_op_cost_project_info p where p.template_id=t.parent_id and p.project_info_no=t.project_info_no and p.cost_project_schema_id='"
					+ costProjectSchemaId + "') where project_info_no = '" + projectInfoNo + "' and cost_project_schema_id='" + costProjectSchemaId + "'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_op_cost_project_info t set t.parent_id='" + costType + "' where parent_id is null and   project_info_no = '" + projectInfoNo
					+ "' and cost_project_schema_id='" + costProjectSchemaId + "'";
			jdbcTemplate.execute(sqlUpdate);
		}
		return responseDTO;
	}

	/*
	 * 保存项目费用数据(从excel导入的情况)
	 */
	public ISrvMsg saveProjectCostByExcel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String costProjectSchemaId = reqDTO.getValue("costProjectSchemaId");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> files = mqMsg.getFiles();
		if (projectInfoNo != null && !"".equals(projectInfoNo)) {
			if (files != null && files.size() > 0) {
				WSFile file = files.get(0);
				InputStream is = new ByteArrayInputStream(file.getFileData());
				HSSFWorkbook book = new HSSFWorkbook(is);
				Sheet sheet = book.getSheetAt(0);
				String[] colName1 = {"manage_org", "team", "project_name", "surface_type"};
				String[] colName2 = {"work_load", "work_situation", "work_factor", "work_reason", "work_person", "work_device"};
				String sql_basic = "";
				int row_num = 2;
				for(String s :colName1){
					Row row = sheet.getRow(row_num++);
					Cell cell = row.getCell(3);
					cell.setCellType(1);
					String name = cell.getStringCellValue();
					sql_basic += s+"='"+name+"',";
				}
				sql_basic ="update bgp_op_cost_project_basic t set "+sql_basic+" bsflag ='0' where t.project_info_no = '"+projectInfoNo+"'";
				jdbcTemplate.execute(sql_basic);
				String cost_schema_detail_id ="";
				String sql_temp ="select t.cost_schema_detail_id from bgp_op_cost_project_sch_det t where t.bsflag ='0' and t.cost_project_schema_id ='"+costProjectSchemaId+"'";
				List<Map> list_temp = pureDao.queryRecords(sql_temp);
				for(Map map:list_temp){
					cost_schema_detail_id = map==null || map.get("cost_schema_detail_id")==null?"":(String)map.get("cost_schema_detail_id");
				}
				if(cost_schema_detail_id==null || cost_schema_detail_id.trim().equals("")){
					sql_basic = "";
					row_num = 6;
					for(String s :colName2){
						Row row = sheet.getRow(row_num++);
						Cell cell = row.getCell(3);
						cell.setCellType(1);
						String name = cell.getStringCellValue();
						sql_basic += "'"+name+"',";
					}
					sql_basic ="insert into bgp_op_cost_project_sch_det(cost_schema_detail_id,cost_project_schema_id,work_load,work_situation,work_factor,work_reason,"+
					"work_person,work_device,org_id,org_subjection_id,creator,create_date,updator,modifi_date,bsflag,spare4)values((select lower(sys_guid()) from dual),"+
					"'"+costProjectSchemaId+"',"+sql_basic+"'"+org_id+"','"+org_subjection_id+"','"+user_id+"',sysdate,'"+user_id+"',sysdate,'0',sysdate)";
				}else{
					sql_basic = "";
					row_num = 6;
					for(String s :colName2){
						Row row = sheet.getRow(row_num++);
						Cell cell = row.getCell(3);
						cell.setCellType(1);
						String name = cell.getStringCellValue();
						sql_basic += s+"='"+name+"',";
					}
					sql_basic ="update bgp_op_cost_project_sch_det t set "+sql_basic+ "bsflag='0' where t.cost_project_schema_id = '"+costProjectSchemaId+"'";
				}
				jdbcTemplate.execute(sql_basic);
				String sql = "delete bgp_op_cost_project_detail t where t.cost_project_schema_id ='"+costProjectSchemaId+"'";
				jdbcTemplate.execute(sql);
				StringBuffer sb = new StringBuffer();
				for(int k = 16;k <= 163;k++){
					Row row = sheet.getRow(k);
					Cell cell = row.getCell(0)==null?row.createCell(0):row.getCell(0);
					String node_code = cell.getStringCellValue()==null||cell.getStringCellValue().trim().equals("")?"":cell.getStringCellValue();
					if(node_code!=null && !node_code.trim().equals("")){
						cell = row.getCell(3)==null?row.createCell(0):row.getCell(3);
						cell.setCellType(1);
						String cost_detail_money = cell.getStringCellValue()==null || cell.getStringCellValue().trim().equals("")?"0":String.valueOf(Double.valueOf(cell.getStringCellValue())*10000);
						cell = row.getCell(4)==null?row.createCell(0):row.getCell(4);
						cell.setCellType(1);
						String cost_detail_desc = cell.getStringCellValue()==null || cell.getStringCellValue().trim().equals("")?"":cell.getStringCellValue();
						
						sb.append("insert into bgp_op_cost_project_detail(cost_project_detail_id,gp_cost_project_id,cost_project_schema_id,")
						.append(" cost_detail_money,cost_detail_desc,org_id,org_subjection_id,creator,create_date,updator,modifi_date,bsflag,spare4)")
						.append(" select lower(sys_guid()),p.gp_cost_project_id,'").append(costProjectSchemaId).append("','").append(cost_detail_money).append("',")
						.append("'").append(cost_detail_desc).append("','").append(org_id).append("','").append(org_subjection_id).append("','")
						.append(user_id).append("',sysdate,'").append(user_id).append("',sysdate,'0',sysdate")
						.append(" from bgp_op_cost_project_info p where p.bsflag ='0'and p.cost_project_schema_id='")
						.append(costProjectSchemaId).append("' and p.node_code ='").append(node_code).append("' and rownum =1;");
					}
				}
				saveDatasBySql(sb.toString());
				
				/*List<Map> list = OPCommonUtil.getDataBlockFromExcel(file, 1, 13, 3);
				System.out.println(list);
				List<String> sql = OPCommonUtil.setVersionDataBlockByExcel(list, projectInfoNo, costProjectSchemaId);
				jdbcTemplate.batchUpdate(OPCommonUtil.getStringFromList(sql));*/
			}
		}
		return responseDTO;
	}

	/*
	 * 保存费用模板拖拽顺序数据
	 */
	public ISrvMsg saveCostTemplateOrder(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		OPCommonUtil.setOrderOfTreeDragDrop("bgp_op_cost_template", "template_id", reqDTO);
		return responseDTO;
	}
	
	/*
	 * 保存费用模板拖拽顺序数据
	 */
	public ISrvMsg saveCostTemplateOrderOther(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		OPCommonUtil.setOrderOfTreeDragDrop("bgp_op_cost_template_other", "template_id", reqDTO);
		return responseDTO;
	}

	/*
	 * 保存模板费用数据
	 */
	public ISrvMsg saveCostTemplateData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String template_id = reqDTO.getValue("template_id");
		String parent_id = reqDTO.getValue("parent_id");
		String cost_name = reqDTO.getValue("cost_name");
		String cost_desc = reqDTO.getValue("cost_desc");
		String cost_type = reqDTO.getValue("cost_type");
		String spare1 = reqDTO.getValue("spare1");//拓展业务类型
		String spare5 = reqDTO.getValue("spare5");//区分物探处、项目
		
		if (cost_name != null && !"".equals(cost_name)) {
			cost_name = URLDecoder.decode(cost_name, "UTF-8");
		}
		if (cost_desc != null && !"".equals(cost_desc)) {
			cost_desc = URLDecoder.decode(cost_desc, "UTF-8");
		}
		Map map = reqDTO.toMap();
		map.put("cost_name", cost_name);
		map.put("cost_desc", cost_desc);
		map.put("bsflag", "0");
		map.put("spare1", spare1);
		map.put("spare5", spare5);

		if (template_id == null || "".equals(template_id)) {
			// 计算order、自动编码
			String order_code = "";
			String node_code = "";
			String code = OPCommonUtil.getCostOrderAndCode("bgp_op_cost_template", parent_id,spare1,spare5);
			if(code!=null && !code.trim().equals("")){
				node_code = code.split(":")[0];
				order_code = code.split(":")[1];
			}
			node_code = node_code==null || node_code.trim().equals("")?"S01001":"S0"+String.valueOf(Integer.valueOf(node_code.substring(2))-(-1));
			order_code = order_code==null || order_code.trim().equals("")?"0":String.valueOf((Integer.valueOf(order_code)-(-1)));
			
			map.put("node_code", node_code);
			map.put("order_code", order_code);
			
		}
		pureDao.saveOrUpdateEntity(map, "BGP_OP_COST_TEMPLATE");
		responseDTO.setValue("success", true);
		return responseDTO;
	}

	/*
	 * 保存模板费用数据
	 */
	public ISrvMsg saveCostTemplateOtherData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String template_id = reqDTO.getValue("template_id");
		String parent_id = reqDTO.getValue("parent_id");
		String cost_name = reqDTO.getValue("cost_name");
		String cost_desc = reqDTO.getValue("cost_desc");
		String cost_type = reqDTO.getValue("cost_type");
		
		String templateType=reqDTO.getValue("templateType");
		if (cost_name != null && !"".equals(cost_name)) {
			cost_name = URLDecoder.decode(cost_name, "UTF-8");
		}
		if (cost_desc != null && !"".equals(cost_desc)) {
			cost_desc = URLDecoder.decode(cost_desc, "UTF-8");
		}
		Map map = reqDTO.toMap();
		map.put("cost_name", cost_name);
		map.put("tempalte_type", templateType);
		map.put("cost_desc", cost_desc);
		map.put("bsflag", "0");

		// 计算order并自动生成编码
		if (template_id == null || "".equals(template_id)) {
			// 计算order
			int index = OPCommonUtil.getOrderOfTreeDisplay("bgp_op_cost_template_other", parent_id);
			map.put("order_code", index);
			// 计算自动编码
			String nodeCode = OPCommonUtil.getCodeNodeByAutoGen("bgp_op_cost_template_other", "template_id", parent_id, cost_type);
			map.put("node_code", nodeCode);
		}
		pureDao.saveOrUpdateEntity(map, "BGP_OP_COST_TEMPLATE_OTHER");
		responseDTO.setValue("success", true);
		return responseDTO;
	}
	
	/*
	 * 保存项目费用拖拽顺序数据
	 */
	public ISrvMsg saveCostProjectOrder(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		OPCommonUtil.setOrderOfTreeDragDrop("bgp_op_cost_project_info", "gp_cost_project_id", reqDTO);
		return responseDTO;
	}

	/*
	 * 保存项目费用数据
	 */

	public ISrvMsg saveCostProjectData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String gp_cost_project_id = reqDTO.getValue("gp_cost_project_id");
		String parent_id = reqDTO.getValue("parent_id");
		String cost_type = reqDTO.getValue("cost_type");
		Map map = reqDTO.toMap();
		map.put("bsflag", "0");

		// 计算order
		if (gp_cost_project_id == null || "".equals(gp_cost_project_id)) {
			int index = OPCommonUtil.getOrderOfTreeDisplay("bgp_op_cost_project_info", parent_id);
			map.put("order_code", index);

			// 计算自动编码
			String nodeCode = OPCommonUtil.getCodeNodeByAutoGen("bgp_op_cost_project_info", "gp_cost_project_id", parent_id, cost_type);
			map.put("node_code", nodeCode);
		}
		pureDao.saveOrUpdateEntity(map, "bgp_op_cost_project_info");
		responseDTO.setValue("success", true);
		return responseDTO;
	}

	/*
	 * 保存项目方案信息
	 */
	public ISrvMsg saveCostProjectVersionData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		Map map = reqDTO.toMap();
		String primaryKey = (String) map.get("cost_project_schema_id");
		String key = pureDao.saveOrUpdateEntity(map, "BGP_OP_COST_PROJECT_SCHEMA").toString();
		// 生成费用科目树
		String costType = "01";// reqDTO.getValue("costType");
		String projectInfoNo = reqDTO.getValue("project_info_no");
		String costProjectSchemaId = key;// reqDTO.getValue("costProjectSchemaId");
		if ((primaryKey == null || "".equals(primaryKey)) && projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			String sqlDelete = "delete from  bgp_op_cost_project_info  where project_info_no='" + projectInfoNo + "' and cost_project_schema_id='" + costProjectSchemaId + "'";
			jdbcTemplate.execute(sqlDelete);
			String sqlInsert = "insert into bgp_op_cost_project_info (gp_cost_project_id,template_id,project_info_no,node_code,cost_name,cost_desc,order_code,cost_type,parent_id,create_date,cost_project_schema_id,bsflag) "
					+ "(select   SYS_GUID () AS key_id,TEMPLATE_ID,'"
					+ projectInfoNo
					+ "',node_code,cost_name,cost_desc,order_code,cost_type,parent_id,sysdate,'"
					+ costProjectSchemaId + "','0' from bgp_op_cost_template where bsflag='0' and  cost_type = '" + costType + "')";
			jdbcTemplate.execute(sqlInsert);
			String sqlUpdate = "update bgp_op_cost_project_info t set t.parent_id =(select p.gp_cost_project_id from bgp_op_cost_project_info p where p.template_id=t.parent_id and p.project_info_no=t.project_info_no and p.cost_project_schema_id='"
					+ costProjectSchemaId + "') where project_info_no = '" + projectInfoNo + "' and cost_project_schema_id='" + costProjectSchemaId + "'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_op_cost_project_info t set t.parent_id='" + costType + "' where parent_id is null and   project_info_no = '" + projectInfoNo
					+ "' and cost_project_schema_id='" + costProjectSchemaId + "'";
			jdbcTemplate.execute(sqlUpdate);
		}
		return responseDTO;
	}
	
	/*
	 * 保存辅助单位费用基本信息saveCostAssistInfo
	 */
	public ISrvMsg saveCostAssistInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		Map map = reqDTO.toMap();
		String primaryKey = (String) map.get("assist_info_id");
		String assitType = (String) map.get("assist_type");
		String key = pureDao.saveOrUpdateEntity(map, "BGP_OP_COST_ASSIST_INFO").toString();
		// 生成费用科目树
		if ((primaryKey == null || "".equals(primaryKey)) ) {
			primaryKey=key;
			String sqlDelete = "delete from  bgp_op_cost_assist_detail where  assist_info_id='" + primaryKey + "'";
			jdbcTemplate.execute(sqlDelete);
			String sqlInsert = "insert into bgp_op_cost_assist_detail (assist_detail_id,template_id,assist_info_id,node_code,cost_name,cost_desc,order_code,parent_id,create_date,bsflag) "
					+ "(select   SYS_GUID () AS key_id,TEMPLATE_ID,'"
					+ primaryKey
					+ "',node_code,cost_name,cost_desc,order_code,parent_id,sysdate,'0' from bgp_op_cost_template_other where bsflag='0' and  assist_type = '" + assitType + "')";
			jdbcTemplate.execute(sqlInsert);
			String sqlUpdate = "update bgp_op_cost_assist_detail t set t.parent_id =(select p.assist_detail_id from bgp_op_cost_assist_detail p where p.template_id=t.parent_id and p.assist_info_id='"
					+ primaryKey + "') ";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_op_cost_assist_detail t set t.parent_id='01' where parent_id is null and   assist_info_id = '" + primaryKey+ "'";
			jdbcTemplate.execute(sqlUpdate);
		}
		return responseDTO;
	} 
	
	/*
	 * 保存辅助单位费用基本信息saveCostAssistInfo
	 */
	public ISrvMsg saveCostAssistTargetInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		Map map = reqDTO.toMap();
		String primaryKey = (String) map.get("assist_info_id");
		String assitType = (String) map.get("assist_type");
		String key = pureDao.saveOrUpdateEntity(map, "BGP_OP_TARGET_ASSIST_INFO").toString();
		// 生成费用科目树
		if ((primaryKey == null || "".equals(primaryKey)) ) {
			primaryKey=key;
			String sqlDelete = "delete from  bgp_op_target_assist_detail where  assist_info_id='" + primaryKey + "'";
			jdbcTemplate.execute(sqlDelete);
			String sqlInsert = "insert into bgp_op_target_assist_detail (assist_detail_id,template_id,assist_info_id,node_code,cost_name,cost_desc,order_code,parent_id,create_date,bsflag) "
					+ "(select   SYS_GUID () AS key_id,TEMPLATE_ID,'"
					+ primaryKey
					+ "',node_code,cost_name,cost_desc,order_code,parent_id,sysdate,'0' from bgp_op_cost_template_other where bsflag='0' and  assist_type = '" + assitType + "')";
			jdbcTemplate.execute(sqlInsert);
			String sqlUpdate = "update bgp_op_target_assist_detail t set t.parent_id =(select p.assist_detail_id from bgp_op_target_assist_detail p where p.template_id=t.parent_id and p.assist_info_id='"
					+ primaryKey + "') ";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_op_target_assist_detail t set t.parent_id='01' where parent_id is null and   assist_info_id = '" + primaryKey+ "'";
			jdbcTemplate.execute(sqlUpdate);
		}
		return responseDTO;
	} 
	
	/*
	 * 生成项目费用科目版本信息
	 */
	public ISrvMsg saveCostProjectEditionData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		String costProjectSchemaId = reqDTO.getValue("cost_project_schema_id");
		String projectInfoNo = reqDTO.getValue("project_info_no");
		String costType = reqDTO.getValue("cost_type");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			// 计算当前版本号
			String sqlQueryEditionNo = "select max(edition_no)+1 as edition_no from bgp_op_cost_project_edition where cost_project_schema_id='" + costProjectSchemaId
					+ "' and project_info_no='" + projectInfoNo + "'";
			Map mapEdition = pureDao.queryRecordBySQL(sqlQueryEditionNo);
			String editionNo = "001";
			if (mapEdition != null && mapEdition.get("edition_no") != null && !"".equals(mapEdition.get("edition_no"))) {
				editionNo = (String) mapEdition.get("edition_no");
				switch (editionNo.length()) {
				case 1:
					editionNo = "00" + editionNo;
					break;
				case 2:
					editionNo = "0" + editionNo;
					break;
				case 3:
					break;
				default:
					editionNo = "001";
				}

			} else {
				mapEdition = new HashMap();
				mapEdition.put("edition_no", editionNo);
			}
			mapEdition.put("cost_project_schema_id", costProjectSchemaId);
			mapEdition.put("project_info_no", projectInfoNo);
			mapEdition.put("title", reqDTO.getValue("title"));
			mapEdition.put("bsflag", "0");
			String editionId = pureDao.saveOrUpdateEntity(mapEdition, "bgp_op_cost_project_edition").toString();

			// 获取项目费用科目数据
			StringBuffer sqlQuery = new StringBuffer(
					"select pi.gp_cost_project_id,pi.project_info_no,pi.node_code,pi.cost_name,pi.cost_desc,pi.cost_type,pi.parent_id,pi.org_id,pi.org_subjection_id,pi.bsflag,");
			sqlQuery.append(" pd.cost_detail_money,pd.cost_detail_desc,pd.cost_project_schema_id ");
			sqlQuery.append(" from bgp_op_cost_project_info pi ");
			sqlQuery.append(" left outer join bgp_op_cost_project_detail pd on pi.gp_cost_project_id = pd.gp_cost_project_id and pd.bsflag = '0' and pd.cost_project_schema_id='"
					+ costProjectSchemaId + "'");
			sqlQuery.append(" where pi.project_info_no='" + projectInfoNo + "' and pi.cost_type='" + costType + "' ");
			List<Map> list = pureDao.queryRecords(sqlQuery.toString());
			for (Map map : list) {
				map.put("edition_id", editionId);
				map.put("cost_project_schema_id", costProjectSchemaId);
				pureDao.saveOrUpdateEntity(map, "bgp_op_cost_project_gather");
			}

			// 修改更新后数据的层级关系关联ID
			String sqlUpdate = "update bgp_op_cost_project_gather t set t.parent_id =(select p.gather_id from bgp_op_cost_project_gather p where p.gp_cost_project_id=t.parent_id and p.edition_id='"
					+ editionId + "') where project_info_no = '" + projectInfoNo + "' and edition_id='" + editionId + "'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_op_cost_project_gather t set t.parent_id='" + costType + "' where parent_id is null and   project_info_no = '" + projectInfoNo
					+ "' and edition_id='" + editionId + "'";
			jdbcTemplate.execute(sqlUpdate);
		}
		return responseDTO;
	}

	/*
	 * 获取项目目标费用信息，返回json串
	 */
	public ISrvMsg getCostTargetProject(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String project_type = reqDTO.getValue("project_type");
		String spare5 = reqDTO.getValue("spare5");
		String costType = reqDTO.getValue("costType");
		if (costType == null || "".equals(costType)) {
			costType = OPCommonUtil.getCostTypeOfTargetProject(projectInfoNo);
		}
		String ifcheck = reqDTO.getValue("ifcheck");
		StringBuffer sqlBuffer = new StringBuffer("select connect_by_root(gp_cost_temp_id) root,level,decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf, ");
		sqlBuffer.append(" sys_connect_by_path(substr(node_code,0,length(node_code)-3)||lpad(order_code+1,3,'0'), '/') path,cost_name,cost_desc,gp_cost_temp_id,parent_id, ");
		sqlBuffer.append(" parent_id zip,order_code,cost_detail_money,cost_detail_desc,spare3, ");
		sqlBuffer
				.append(" decode(length(substr(sys_connect_by_path(row_count,'.'),2)),2,czutil.num2chi(substr(sys_connect_by_path(row_count,'.'),2)),substr(sys_connect_by_path(row_count,'.'),2)) path_point ");
		sqlBuffer.append(" from (select cp.gp_target_project_id gp_cost_temp_id,cp.cost_name,cp.cost_desc,cp.parent_id,cp.order_code, ");
		sqlBuffer.append(" pd.cost_detail_desc,pd.spare3,pm.cost_detail_money,cp.node_code, ");
		sqlBuffer
				.append(" decode(length(cp.parent_id),2,(row_number() over(partition by cp.parent_id  order by cp.order_code asc))+11,(row_number() over(partition by cp.parent_id  order by cp.order_code asc)))  row_count ");
		sqlBuffer.append(" from bgp_op_target_project_info cp ");
		sqlBuffer.append(" left join bgp_op_target_project_detail pd on cp.gp_target_project_id = pd.gp_target_project_id and pd.bsflag = '0' ");
		sqlBuffer
				.append(" left outer join ( select pi.*,(select sum(pd.cost_detail_money)from (select n.project_info_no,m.cost_detail_money,n.node_code from bgp_op_target_project_info n ");
		sqlBuffer.append(" left outer join bgp_op_target_project_detail m on m.gp_target_project_id = n.gp_target_project_id and m.bsflag = '0' and n.bsflag = '0' and n.spare1 ='"+project_type+"' and n.spare5='"+spare5+"') pd ");
		sqlBuffer.append(" where pd.project_info_no = pi.project_info_no and pd.node_code like concat(pi.node_code, '%')) cost_detail_money ");
		sqlBuffer.append(" from bgp_op_target_project_info pi where pi.project_info_no = '" + projectInfoNo + "') pm ");
		sqlBuffer.append(" on cp.gp_target_project_id = pm.gp_target_project_id  ");
		sqlBuffer.append(" where cp.bsflag = '0' and cp.project_info_no = '" + projectInfoNo + "' and cp.spare1 ='"+project_type+"' and cp.spare5='"+spare5+"') ");
		sqlBuffer.append(" start with parent_id = '" + costType + "' connect by prior gp_cost_temp_id = parent_id  order by path asc");

		List<Map> list = jdbcDao.queryRecords(sqlBuffer.toString());

		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list != null ? list.size() : 0);

		responseDTO.setValue("pageCount", "1");
		responseDTO.setValue("pageSize", "0");
		responseDTO.setValue("currentPage", "1");

		// 获取项目名称

		String projectName = OPCommonUtil.getProjectNameByProjectInfoNo(projectInfoNo);
		Map map = new HashMap();
		map.put("gpCostTempId", costType);
		map.put("parentId", "root");
		map.put("costName", projectName);
		map.put("costDesc", "");
		map.put("expanded", "true");
		if(project_type!=null && project_type.trim().equals("5000100004000000009")){
			String sum_money = OPCommonUtil.getWhtSumMoney(projectInfoNo,"");
			map.put("costDetailMoney", sum_money);
		}

		Map jsonMap = new HashMap();
		if ("true".equals(ifcheck)) {
			jsonMap = OPCommonUtil.convertListTreeToJsonCheck(list, "gpCostTempId", "parentId", map);
		} else {
			jsonMap = OPCommonUtil.convertListTreeToJson(list, "gpCostTempId", "parentId", map);
		}

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		responseDTO.setValue("basicId", OPCommonUtil.getTargetProjectBasicId(projectInfoNo));
		return responseDTO;
	}

	/*
	 * 获取辅助单位费用信息，返回json串
	 */
	public ISrvMsg getCostAssistProject(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String assistInfoId = reqDTO.getValue("assistInfoId");
		
		StringBuffer sqlBuffer = new StringBuffer("select connect_by_root(assist_detail_id) root,level,formula_type,formula_content, ");
				sqlBuffer.append(" decode(formula_type,'0','计划实际公式维护','1','计划实际手动维护','2','计划公式实际手动维护','3','计划手动实际公式维护') formula_type_name,  ");
				sqlBuffer.append(" decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(template_id, '/') path,  ");
				sqlBuffer.append(" cost_name,cost_desc,template_id,parent_id,parent_id zip,order_code,assist_detail_id, ");
				sqlBuffer.append("（select sum(p.cost_money) from bgp_op_cost_assist_detail p  where p.assist_info_id = '"+assistInfoId+"' and p.node_code like concat(t.node_code,'%') ） cost_money ");
				sqlBuffer.append(" from bgp_op_cost_assist_detail t  where assist_info_id = '"+assistInfoId+"' and bsflag='0'");
				sqlBuffer.append(" start with parent_id = '01' connect by prior assist_detail_id = parent_id   order by parent_id ,order_code asc ");
		
		List<Map> list = jdbcDao.queryRecords(sqlBuffer.toString());

		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list != null ? list.size() : 0);

		responseDTO.setValue("pageCount", "1");
		responseDTO.setValue("pageSize", "0");
		responseDTO.setValue("currentPage", "1");

		// 获取项目名称

		Map map = new HashMap();
		map.put("assistDetailId", "01");
		map.put("parentId", "root");
		map.put("costName", "费用管理");
		map.put("costDesc", "");
		map.put("expanded", "true");

		Map jsonMap = new HashMap();
			jsonMap = OPCommonUtil.convertListTreeToJson(list, "assistDetailId", "parentId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}
	
	/*
	 * 获取项目目标费用手动维护项信息，返回json串
	 */
	public ISrvMsg getCostTargetNFormulaProject(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String costType = reqDTO.getValue("costType");
		if (costType == null || "".equals(costType)) {
			costType = OPCommonUtil.getCostTypeOfTargetProject(projectInfoNo);
		}
		String ifcheck = reqDTO.getValue("ifcheck");
		StringBuffer sqlBuffer = new StringBuffer("select connect_by_root(gp_cost_temp_id) root,level, ");
		sqlBuffer.append(" decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf, ");
		sqlBuffer.append(" sys_connect_by_path(substr(node_code, 0, length(node_code) - 3) || lpad(order_code + 1, 3, '0'), '/') path, ");
		sqlBuffer.append(" cost_name,gp_cost_temp_id,parent_id,parent_id zip,order_code,cost_detail_money,COST_DETAIL_DESC ");
		sqlBuffer.append(" from (select cp.gp_target_project_id gp_cost_temp_id,cp.cost_name,cp.parent_id,cp.order_code,cp.cost_detail_money,cp.node_code,cp.COST_DETAIL_DESC ");
		sqlBuffer.append(" from view_op_target_plan_other cp where cp.bsflag = '0' and cp.project_info_no = '" + projectInfoNo + "') ");
		sqlBuffer.append(" start with parent_id = '" + costType + "' connect by prior gp_cost_temp_id = parent_id order by path asc");

		List<Map> list = jdbcDao.queryRecords(sqlBuffer.toString());

		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list != null ? list.size() : 0);

		responseDTO.setValue("pageCount", "1");
		responseDTO.setValue("pageSize", "0");
		responseDTO.setValue("currentPage", "1");

		// 获取项目名称

		String projectName = OPCommonUtil.getProjectNameByProjectInfoNo(projectInfoNo);
		Map map = new HashMap();
		map.put("gpCostTempId", costType);
		map.put("parentId", "root");
		map.put("costName", projectName);
		map.put("costDesc", "");
		map.put("expanded", "true");

		Map jsonMap = new HashMap();
		if ("true".equals(ifcheck)) {
			jsonMap = OPCommonUtil.convertListTreeToJsonCheck(list, "gpCostTempId", "parentId", map);
		} else {
			jsonMap = OPCommonUtil.convertListTreeToJson(list, "gpCostTempId", "parentId", map);
		}

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		responseDTO.setValue("basicId", OPCommonUtil.getTargetProjectBasicId(projectInfoNo));
		return responseDTO;
	}

	/*
	 * 保存项目目标费用数据(从模板导入的情况)
	 */
	public ISrvMsg saveProjectCostTargetByTemplate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = reqDTO.getValue("costType");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String project_type = reqDTO.getValue("project_type");
		String spare5 = reqDTO.getValue("spare5");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			String basicId = OPCommonUtil.getTargetProjectBasicId(projectInfoNo);
			String sqlDeleteSub = "delete from bgp_op_target_project_detail where GP_TARGET_PROJECT_ID in (select GP_TARGET_PROJECT_ID  from  bgp_op_target_project_info  where project_info_no='"
					+ projectInfoNo + "' and spare1='"+project_type+"' and spare5='"+spare5+"')";
			String sqlDelete = "delete from  bgp_op_target_project_info  where project_info_no='" + projectInfoNo + "' and spare1='"+project_type+"' and spare5='"+spare5+"'";
			jdbcTemplate.execute(sqlDeleteSub);
			jdbcTemplate.execute(sqlDelete);
			String sqlInsert = "insert into bgp_op_target_project_info (GP_TARGET_PROJECT_ID,template_id,project_info_no,node_code,cost_name,cost_desc,order_code,cost_type,parent_id,create_date,TARTGET_BASIC_ID,bsflag,formula_type,formula_content,formula_content_a,spare1,spare5) "
					+ "(select   SYS_GUID () AS key_id,TEMPLATE_ID,'"
					+ projectInfoNo
					+ "',node_code,cost_name,cost_desc,order_code,cost_type,parent_id,sysdate,'"
					+ basicId
					+ "','0',formula_type,formula_content,formula_content_a,'"+project_type+"','"+spare5+"' from bgp_op_cost_template  where bsflag='0' and  cost_type = '" + costType + "' and spare1='"+project_type+"' and spare5='"+spare5+"')";
			jdbcTemplate.execute(sqlInsert);
			String sqlUpdate = "update bgp_op_target_project_info t set t.parent_id =(select p.gp_target_project_id from bgp_op_target_project_info p where p.template_id=t.parent_id and p.project_info_no=t.project_info_no) where project_info_no = '"
					+ projectInfoNo + "'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_op_target_project_info t set t.parent_id='" + costType + "' where parent_id is null and   project_info_no = '" + projectInfoNo + "'";
			jdbcTemplate.execute(sqlUpdate);
		}
		return responseDTO;
	}
	
	/*
	 * 保存辅助单位费用数据(从模板导入的情况)
	 */
	public ISrvMsg saveCostAssistInfoByTemplate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String assistType = reqDTO.getValue("assistType");
		String assistInfoId = reqDTO.getValue("assistInfoId");
		String init=reqDTO.getValue("init");
		if (assistInfoId != null && !"".equals(assistInfoId) && !"null".equals(assistInfoId)) {
			String sql="select *  from bgp_op_cost_assist_detail where assist_info_id = '"+assistInfoId+"'";
			List list=jdbcTemplate.queryForList(sql);
			if(("true".equals(init)&&(list==null||list.size()==0))||!"true".equals(init)){
				String sqlDelete = "delete from  bgp_op_cost_assist_detail  where assist_info_id='" + assistInfoId + "'";
				jdbcTemplate.execute(sqlDelete);
				String sqlInsert = "insert into bgp_op_cost_assist_detail (assist_detail_id,template_id,assist_info_id,node_code,cost_name,cost_desc,order_code,parent_id,create_date,bsflag,formula_type,formula_content,formula_content_a) "
						+ "(select   SYS_GUID () AS key_id,TEMPLATE_ID,'"
						+ assistInfoId
						+ "',node_code,cost_name,cost_desc,order_code,parent_id,sysdate,"
						+ "'0',formula_type,formula_content,formula_content_a from bgp_op_cost_template_other  where bsflag='0' and  template_type = '" + assistType + "')";
				jdbcTemplate.execute(sqlInsert);
				String sqlUpdate = "update bgp_op_cost_assist_detail t set t.parent_id =(select p.assist_detail_id from bgp_op_cost_assist_detail p where p.template_id=t.parent_id and p.assist_info_id=t.assist_info_id) where assist_info_id = '"
						+ assistInfoId + "'";
				jdbcTemplate.execute(sqlUpdate);
				sqlUpdate = "update bgp_op_cost_assist_detail t set t.parent_id='01' where parent_id is null and   assist_info_id = '" + assistInfoId + "'";
				jdbcTemplate.execute(sqlUpdate);
			}
		}
		return responseDTO;
	}
	
	
	/*
	 * 保存辅助单位费用数据(从模板导入的情况)
	 */
	public ISrvMsg saveCostAssistTargetInfoByTemplate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String assistType = reqDTO.getValue("assistType");
		String assistInfoId = reqDTO.getValue("assistInfoId");
		String init=reqDTO.getValue("init");
		if (assistInfoId != null && !"".equals(assistInfoId) && !"null".equals(assistInfoId)) {
			String sql="select *  from bgp_op_target_assist_detail where assist_info_id = '"+assistInfoId+"'";
			List list=jdbcTemplate.queryForList(sql);
			if(("true".equals(init)&&(list==null||list.size()==0))||!"true".equals(init)){
				String sqlDelete = "delete from  bgp_op_target_assist_detail  where assist_info_id='" + assistInfoId + "'";
				jdbcTemplate.execute(sqlDelete);
				String sqlInsert = "insert into bgp_op_target_assist_detail (assist_detail_id,template_id,assist_info_id,node_code,cost_name,cost_desc,order_code,parent_id,create_date,bsflag,formula_type,formula_content,formula_content_a) "
						+ "(select   SYS_GUID () AS key_id,TEMPLATE_ID,'"
						+ assistInfoId
						+ "',node_code,cost_name,cost_desc,order_code,parent_id,sysdate,"
						+ "'0',formula_type,formula_content,formula_content_a from bgp_op_cost_template_other  where bsflag='0' and  template_type = '" + assistType + "')";
				jdbcTemplate.execute(sqlInsert);
				String sqlUpdate = "update bgp_op_target_assist_detail t set t.parent_id =(select p.assist_detail_id from bgp_op_target_assist_detail p where p.template_id=t.parent_id and p.assist_info_id=t.assist_info_id) where assist_info_id = '"
						+ assistInfoId + "'";
				jdbcTemplate.execute(sqlUpdate);
				sqlUpdate = "update bgp_op_target_assist_detail t set t.parent_id='01' where parent_id is null and   assist_info_id = '" + assistInfoId + "'";
				jdbcTemplate.execute(sqlUpdate);
			}
		}
		return responseDTO;
	}

	/*
	 * 获取项目目标费用类型costType
	 */
	public ISrvMsg getProjectCostTargetType(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = "";
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo)) {
			costType = OPCommonUtil.getCostTypeOfTargetProject(projectInfoNo);
		} else {
			costType = OPCommonUtil.getCodeFirstData("5110000023");
		}
		responseDTO.setValue("costType", costType);
		return responseDTO;
	}

	/*
	 * 保存项目目标费用拖拽顺序数据
	 */
	public ISrvMsg saveCostTargetProjectOrder(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String tableName = reqDTO.getValue("tableName");
		String tableKeyName = reqDTO.getValue("tableKeyName");
		if (tableName != null && !"".equals(tableName) && tableKeyName != null && !"".equals(tableKeyName)) {
			OPCommonUtil.setOrderOfTreeDragDrop(tableName, tableKeyName, reqDTO);
		} else {
			OPCommonUtil.setOrderOfTreeDragDrop("bgp_op_target_project_info", "gp_target_project_id", reqDTO);
		}
		return responseDTO;
	}

	/*
	 * 保存项目费用数据
	 */

	public ISrvMsg saveCostTargetProjectData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String gp_target_project_id = reqDTO.getValue("gp_target_project_id");
		String parent_id = reqDTO.getValue("parent_id");
		String cost_type = reqDTO.getValue("cost_type");
		Map map = reqDTO.toMap();
		map.put("bsflag", "0");

		// 计算order
		if (gp_target_project_id == null || "".equals(gp_target_project_id)) {
			int index = OPCommonUtil.getOrderOfTreeDisplay("bgp_op_target_project_info", parent_id);
			map.put("order_code", index);

			// 计算自动编码
			String nodeCode = OPCommonUtil.getCodeNodeByAutoGen("bgp_op_target_project_info", "gp_target_project_id", parent_id, cost_type);
			map.put("node_code", nodeCode);
		}
		pureDao.saveOrUpdateEntity(map, "bgp_op_target_project_info");
		responseDTO.setValue("success", true);
		return responseDTO;
	}

	/*
	 * 从设备中获取计划的设备明细
	 */
	public ISrvMsg getOilDevicePlanInfoFromDm(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String sql = "select  t.dev_acc_id,t.dev_name,t.self_num,t.dev_sign,t.dev_team,t.dev_model,t.project_info_id project_info_no,t.dev_sign,t.planning_in_time plan_start_date,t.planning_out_time  plan_end_date "
				+ "from gms_device_account_dui t where t.dev_type not like 'S14%' and t.dev_type not like 'S11%' and t.project_info_id='" + projectInfoNo + "'";
		List<Map> list = pureDao.queryRecords(sql);
		String deleteSql = "delete from BGP_OP_TARTET_DEVICE_OIL where dev_acc_id is not null and project_info_no='" + projectInfoNo + "'";
		jdbcTemplate.execute(deleteSql);
		if (list != null && list.size() > 0) {
			for (Map map : list) {
				map.put("bsflag", "0");
				map.put("if_change", "0");
				pureDao.saveOrUpdateEntity(map, "BGP_OP_TARTET_DEVICE_OIL");
			}
		}
		responseDTO.setValue("success", "true");
		return responseDTO;
	}

	/*
	 * 从设备中获取计划的设备明细
	 */
	public ISrvMsg getDepreDevicePlanInfoFromDm(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String user_id = user.getUserId();
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		StringBuffer sb = new StringBuffer();
		sb.append("update bgp_op_tartet_device_depre d set(dev_team,dev_name,dev_model,self_num,license_num,dev_sign,asset_coding,plan_start_date,")
		.append(" plan_end_date,actual_start_date ,actual_end_date,asset_value) = ( select t.dev_team,t.dev_name,t.dev_model,t.self_num,")
		.append(" t.license_num,t.dev_sign,t.asset_coding,t.planning_in_time,t.planning_out_time,t.actual_in_time ,nvl(t.actual_out_time,d.actual_end_date),t.asset_value")
		.append(" from gms_device_account_dui t where t.bsflag ='0' and t.dev_type not like 'S14%' and t.dev_type not like 'S11%' ")
		.append(" and t.project_info_id ='").append(projectInfoNo).append("' and t.dev_acc_id = d.dev_acc_id )")
		.append(" where d.bsflag ='0' and d.if_change='2' and d.project_info_no ='").append(projectInfoNo).append("' and d.spare1 is null");
		jdbcTemplate.execute(sb.toString());
		
		sb = new StringBuffer();
		sb.append(" insert into bgp_op_tartet_device_depre(target_depre_id,project_info_no,dev_acc_id,dev_team,dev_name,dev_model,device_count,self_num,")
		.append(" license_num,dev_sign,asset_coding,plan_start_date,plan_end_date,actual_start_date ,actual_end_date,asset_value,org_id,org_subjection_id,")
		.append(" creator,create_date,updator,update_date,spare4,bsflag,if_change,record_type) select lower(sys_guid()),'").append(projectInfoNo).append("',")
		.append(" t.dev_acc_id,t.dev_team,t.dev_name,t.dev_model,1 ,t.self_num,t.license_num,t.dev_sign,t.asset_coding,t.planning_in_time,")
		.append(" t.planning_out_time,t.actual_in_time ,t.actual_out_time,t.asset_value ,'").append(org_id).append("','").append(org_subjection_id).append("',")
		.append(" '").append(user_id).append("',sysdate,'").append(user_id).append("',sysdate,sysdate,'0','2','0'")
		.append(" from gms_device_account_dui t where t.bsflag ='0' and t.dev_type not like 'S14%' and t.dev_type not like 'S11%' ")
		.append(" and t.project_info_id ='").append(projectInfoNo).append("' and t.dev_acc_id not in (select distinct dev_acc_id ")
		.append(" from bgp_op_tartet_device_depre d where d.bsflag ='0' and d.record_type ='0' and d.project_info_no='").append(projectInfoNo).append("')");
		jdbcTemplate.execute(sb.toString());
		
		sb = new StringBuffer();
		sb.append("update bgp_op_target_device_rent d set(dev_team,dev_name,dev_model,self_num,license_num,dev_sign,asset_coding,plan_start_date,")
		.append(" plan_end_date,actual_start_date ,actual_end_date,asset_value) = ( select t.dev_team,t.dev_name,t.dev_model,t.self_num,")
		.append(" t.license_num,t.dev_sign,t.asset_coding,t.planning_in_time,t.planning_out_time,t.actual_in_time ,nvl(t.actual_out_time,d.actual_end_date),t.asset_value")
		.append(" from gms_device_account_dui t where t.bsflag ='0' and t.dev_type not like 'S14%' and t.dev_type not like 'S11%' ")
		.append(" and t.project_info_id ='").append(projectInfoNo).append("' and t.dev_acc_id = d.dev_acc_id )")
		.append(" where d.bsflag ='0' and d.if_change='2' and d.project_info_no ='").append(projectInfoNo).append("' and d.spare1 is null");
		jdbcTemplate.execute(sb.toString());
		
		sb = new StringBuffer();
		sb.append(" insert into bgp_op_target_device_rent(target_rent_id,project_info_no,dev_acc_id,dev_team,dev_name,dev_model,device_count,self_num,")
		.append(" license_num,dev_sign,asset_coding,plan_start_date,plan_end_date,actual_start_date ,actual_end_date,asset_value,org_id,org_subjection_id,")
		.append(" creator,create_date,updator,update_date,spare4,bsflag,if_change) select lower(sys_guid()),'").append(projectInfoNo).append("',")
		.append(" t.dev_acc_id,t.dev_team,t.dev_name,t.dev_model,1 ,t.self_num,t.license_num,t.dev_sign,t.asset_coding,t.planning_in_time,")
		.append(" t.planning_out_time,t.actual_in_time ,t.actual_out_time,t.asset_value ,'").append(org_id).append("','").append(org_subjection_id).append("',")
		.append(" '").append(user_id).append("',sysdate,'").append(user_id).append("',sysdate,sysdate,'0','2'")
		.append(" from gms_device_account_dui t where t.bsflag ='0' and t.dev_type not like 'S14%' and t.dev_type not like 'S11%' ")
		.append(" and t.project_info_id ='").append(projectInfoNo).append("' and t.dev_acc_id not in (select distinct dev_acc_id ")
		.append(" from bgp_op_target_device_rent d where d.bsflag ='0' and d.project_info_no='").append(projectInfoNo).append("')");
		jdbcTemplate.execute(sb.toString());
		
		/*String sql = "select  t.dev_acc_id,t.dev_name,t.self_num,t.dev_team,t.dev_model,t.asset_value,t.project_info_id project_info_no,t.dev_sign,t.planning_in_time plan_start_date,t.planning_out_time  plan_end_date "
				+ "from gms_device_account_dui t where t.dev_type not like 'S14%' and t.dev_type not like 'S11%' and t.project_info_id='" + projectInfoNo + "'";
		List<Map> list = pureDao.queryRecords(sql);
		String deleteSql = "delete from bgp_op_tartet_device_depre where dev_acc_id is not null and project_info_no='" + projectInfoNo + "'";
		jdbcTemplate.execute(deleteSql);
		if (list != null && list.size() > 0) {
			for (Map map : list) {
				map.put("bsflag", "0");
				map.put("if_change", "0");
				map.put("device_count", "1");
				map.put("record_type", "0");
				pureDao.saveOrUpdateEntity(map, "bgp_op_tartet_device_depre");
			}
		}*/
		responseDTO.setValue("success", "true");
		return responseDTO;
	}

	/*
	 * 从设备中获取计划的设备明细
	 */
	public ISrvMsg getMaterialDevicePlanInfoFromDm(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String sql = "select  t.dev_acc_id,t.dev_name,t.self_num,t.dev_team,t.dev_model,t.project_info_id project_info_no,t.dev_sign,t.planning_in_time plan_start_date,t.planning_out_time  plan_end_date "
				+ "from gms_device_account_dui t where t.dev_type not like 'S14%' and t.dev_type not like 'S11%' and t.project_info_id='" + projectInfoNo + "'";
		List<Map> list = pureDao.queryRecords(sql);
		String deleteSql = "delete from bgp_op_tartet_device_material where dev_acc_id is not null and project_info_no='" + projectInfoNo + "'";
		jdbcTemplate.execute(deleteSql);
		if (list != null && list.size() > 0) {
			for (Map map : list) {
				map.put("bsflag", "0");
				map.put("device_count", "1");
				map.put("if_change", "0");
				pureDao.saveOrUpdateEntity(map, "bgp_op_tartet_device_material");
			}
		}

		responseDTO.setValue("success", "true");
		return responseDTO;
	}

	/*
	 * 从设备口中获取长期待摊设备信息
	 */
	public ISrvMsg importDeviceLdAtualInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuilder sb = new StringBuilder("select dui.dev_acc_id,dui.dev_name,dui.dev_model,dui.actual_in_time  ACTUAL_START_DATE,dui.actual_out_time ACTUAL_end_DATE, ");
		sb.append(" dui.dev_team,dui.ASSET_VALUE/100 ");
		sb.append(" from gms_device_account_dui dui  join gms_device_codeinfo ci    on dui.dev_type = ci.dev_ci_code ");
		sb.append(" where dev_ct_code like '14050208%' and dev_ct_code not like '1405020806003' and dev_ct_code not like '1405020806004' ");
		sb.append(" and dui.project_info_id = '" + projectInfoNo + "'");
		List<Map> list = pureDao.queryRecords(sb.toString());
		if (list != null && list.size() > 0) {
			for (Map map : list) {
				String devAccId = (String) map.get("dev_acc_id");
				String sql = "select target_depre_id from BGP_OP_TARTET_DEVICE_DEPRE dr where dr.RECORD_TYPE = '1' and bsflag='0' and dr.dev_acc_id='" + devAccId + "'";
				Map mapNum = pureDao.queryRecordBySQL(sql);
				if (mapNum != null && mapNum.get("target_depre_id") != null) {
					map.put("target_depre_id", mapNum.get("target_depre_id"));
					map.put("bsflag", "0");
					map.put("device_count", "100");
					map.put("record_type", "1");
					map.put("if_change", "2");
					map.put("project_info_no", projectInfoNo);
					pureDao.saveOrUpdateEntity(map, "bgp_op_tartet_device_depre");
				} else {
					map.put("bsflag", "0");
					map.put("device_count", "100");
					map.put("record_type", "1");
					map.put("if_change", "2");
					map.put("project_info_no", projectInfoNo);
					pureDao.saveOrUpdateEntity(map, "bgp_op_tartet_device_depre");
				}
			}
		}
		return responseDTO;
	}

	/*
	 * 获取设备费用信息
	 */
	public ISrvMsg getDeviceShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {

			// 读取设备费用信息
			StringBuffer queryDeviceCost = new StringBuffer(
					"select td.dev_name,td.dev_model,sd.coding_name dev_team,nvl(td.device_count,1) device_count,td.dev_acc_id,td.cost_device_id, ");
			queryDeviceCost.append(" td.plan_start_date,td.plan_end_date,td.plan_end_date - td.plan_start_date+1 as date_num, ");
			queryDeviceCost.append(" td.actual_start_date,td.daily_oil_type,td.actual_end_date,td.daily_oil,td.daily_small_oil,td.single_well_oil, ");
			queryDeviceCost.append(" td.oil_unit_price,decode(td.daily_oil_type,'2','柴油','1','汽油','') daily_oil_type_name, ");
			queryDeviceCost.append(" to_char(td.oil_unit_price * (nvl(td.daily_oil,0)+nvl(td.single_well_oil,0)) *(td.plan_end_date - td.plan_start_date+1) * nvl(td.device_count,1),'9999999999999999.99') sum_oil_price, ");
			queryDeviceCost.append(" to_char(td.daily_small_oil * (td.plan_end_date - td.plan_start_date+1) * nvl(td.device_count,1),'9999999999999999.99') sum_small_oil_price ");
			queryDeviceCost.append(" from bgp_op_tartet_device_oil td left join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id ");
			queryDeviceCost.append(" where td.bsflag='0' and  td.project_info_no = '" + projectInfoNo + "' and td.if_change ='0' ");

			String dev_team = reqDTO.getValue("dev_team");
			String dev_name = reqDTO.getValue("dev_name");
			String dev_model = reqDTO.getValue("dev_model");
			if (dev_team != null) {
				queryDeviceCost.append(" and td.dev_team like '%" + dev_team + "%'");
			}
			if (dev_name != null) {
				queryDeviceCost.append(" and td.dev_name like '%" + dev_name + "%'");
			}
			if (dev_model != null) {
				queryDeviceCost.append(" and td.dev_model like '%" + dev_model + "%'");
			}
			queryDeviceCost.append(" order by td.create_date desc ");
			OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, queryDeviceCost.toString());
		}
		return responseDTO;
	}

	/*
	 * 获取设备折旧费用信息
	 */
	public ISrvMsg getDeviceDepreShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			// 读取设备费用信息
			StringBuffer queryDeviceCost = new StringBuffer(
					"select nvl(da.dev_name,td.dev_name) dev_name,da.self_num,da.asset_coding,da.license_num,da.turn_num,nvl(da.dev_model,td.dev_model) dev_model,sd.coding_name dev_team,da.dev_sign,td.dev_acc_id,td.target_depre_id, ");
			queryDeviceCost.append(" td.plan_start_date,td.device_count,td.plan_end_date,td.plan_end_date - td.plan_start_date+1 as date_num, ");
			queryDeviceCost.append(" td.actual_start_date,td.actual_end_date,td.ASSET_VALUE,td.DEPRECIATION_VALUE, ");
			queryDeviceCost.append(" to_char(decode(td.depreciation_value,0,0,td.asset_value*0.97/td.depreciation_value/8),'9999999999999999.99') sum_month_depreciation, ");
			queryDeviceCost
					.append(" to_char(decode(td.depreciation_value,0,0,td.asset_value*0.97/td.depreciation_value/8*td.device_count/30*(td.plan_end_date-td.plan_start_date+1)),'9999999999999999.99') sum_depreciation ");
			queryDeviceCost.append(" from BGP_OP_TARTET_DEVICE_DEPRE td left outer join gms_device_account_dui da on td.dev_acc_id = da.dev_acc_id ");
			queryDeviceCost.append(" left outer join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id ");
			queryDeviceCost.append(" where td.bsflag='0' and  td.project_info_no = '" + projectInfoNo + "'  and td.record_type='0'  and td.if_change ='0'  ");

			String dev_team = reqDTO.getValue("dev_team");
			String dev_name = reqDTO.getValue("dev_name");
			String dev_model = reqDTO.getValue("dev_model");
			if (dev_team != null) {
				queryDeviceCost.append(" and td.dev_team like '%" + dev_team + "%'");
			}
			if (dev_name != null) {
				queryDeviceCost.append(" and td.dev_name like '%" + dev_name + "%'");
			}
			if (dev_model != null) {
				queryDeviceCost.append(" and td.dev_model like '%" + dev_model + "%'");
			}
			queryDeviceCost.append(" order by td.create_date desc ");

			OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, queryDeviceCost.toString());
		}
		return responseDTO;
	}

	/*
	 * 获取设备折旧费用待摊信息
	 */
	public ISrvMsg getDeviceDepreOtherShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			// 读取设备费用信息
			StringBuffer queryDeviceCost = new StringBuffer("select td.dev_name,td.dev_model,td.target_depre_id, ");
			queryDeviceCost.append(" td.plan_start_date,td.plan_end_date,td.plan_end_date - td.plan_start_date+1 as date_num, ");
			queryDeviceCost.append(" td.actual_start_date,td.actual_end_date,td.ASSET_VALUE,td.DEPRECIATION_VALUE,td.device_count, ");
			queryDeviceCost.append(" to_char(decode(td,depreciation_value,0,0,nvl(td.device_count,1)*td.asset_value*0.97/td.depreciation_value/8),'9999999999999999.99') sum_month_depreciation, ");
			queryDeviceCost
					.append(" to_char(decode(td.depreciation_value,0,0,td.asset_value*0.97/td.depreciation_value/8*nvl(td.device_count,1)/30*(td.plan_end_date-td.plan_start_date+1)),'9999999999999999.99') sum_depreciation ");
			queryDeviceCost.append(" from BGP_OP_TARTET_DEVICE_DEPRE td  ");
			queryDeviceCost.append(" where td.bsflag='0' and  td.project_info_no = '" + projectInfoNo + "'  and td.record_type='1'  and td.if_change ='0'  order by td.create_date desc");

			OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, queryDeviceCost.toString());
		}
		return responseDTO;
	}

	/*
	 * 获取设备材料费用信息
	 */
	public ISrvMsg getDeviceMaterialShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			// 读取设备费用信息
			StringBuffer queryDeviceCost = new StringBuffer(
					"select nvl(da.dev_name,td.dev_name) dev_name,da.self_num,da.asset_coding,da.license_num,da.turn_num,nvl(da.dev_model,td.dev_model) dev_model,sd.coding_name dev_team,da.dev_sign,td.dev_acc_id,td.target_material_id, ");
			queryDeviceCost.append(" td.plan_start_date,td.plan_end_date,td.device_count,td.plan_end_date - td.plan_start_date+1 as date_num, ");
			queryDeviceCost.append(" td.actual_start_date,td.actual_end_date,td.vehicle_daily_material,td.drilling_daily_material,td.restore_repails, ");
			queryDeviceCost
					.append(" to_char(td.vehicle_daily_material*(td.plan_end_date - td.plan_start_date+1)*td.device_count,'9999999999999999.99') sum_vehicle_daily_material, ");
			queryDeviceCost
					.append(" to_char(td.drilling_daily_material*(td.plan_end_date - td.plan_start_date+1)*td.device_count,'9999999999999999.99') sum_drilling_daily_material ");
			queryDeviceCost.append(" from bgp_op_tartet_device_material td left outer join gms_device_account_dui da on td.dev_acc_id = da.dev_acc_id ");
			queryDeviceCost.append(" left outer join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id ");
			queryDeviceCost.append(" where  td.bsflag='0' and td.project_info_no = '" + projectInfoNo + "'  and td.if_change ='0' ");

			String dev_team = reqDTO.getValue("dev_team");
			String dev_name = reqDTO.getValue("dev_name");
			String dev_model = reqDTO.getValue("dev_model");
			if (dev_team != null) {
				queryDeviceCost.append(" and td.dev_team like '%" + dev_team + "%'");
			}
			if (dev_name != null) {
				queryDeviceCost.append(" and td.dev_name like '%" + dev_name + "%'");
			}
			if (dev_model != null) {
				queryDeviceCost.append(" and td.dev_model like '%" + dev_model + "%'");
			}
			queryDeviceCost.append(" order by td.create_date desc ");
			OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, queryDeviceCost.toString());
		}
		return responseDTO;
	}

	/*
	 * 保存设备费用信息
	 */
	public ISrvMsg saveDeviceShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String checkNums = reqDTO.getValue("checkNums");
		String dataInfoStrs = reqDTO.getValue("dataInfoStrs");
		String tableName = reqDTO.getValue("tableName");
		if (checkNums != null && !"".equals(checkNums) && dataInfoStrs != null && !"".equals(dataInfoStrs)) {
			String[] checkNum = checkNums.split(",");
			String[] dataInfoStr = dataInfoStrs.split(",");
			for (String i : checkNum) {
				Map map = new HashMap();
				for (String j : dataInfoStr) {
					map.put(j, reqDTO.getValue("fy" + i + j));
				}
				pureDao.saveOrUpdateEntity(map, tableName);
			}
		}
		responseDTO.setValue("success", "true");
		return responseDTO;
	}

	/*
	 * 保存目标成本费用科目金额分摊信息
	 */
	public ISrvMsg saveDeviceShareInfoToTarget(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		int count = Integer.parseInt(reqDTO.getValue("count"));
		for (int i = 0; i < count; i++) {
			String gpTargetProjectId = reqDTO.getValue("fy" + i + "gp_target_project_id");
			if (gpTargetProjectId != null && !"".equals(gpTargetProjectId)) {
				String costDetailMoney = reqDTO.getValue("fy" + i + "cost_detail_money");
				String costDetailDesc = reqDTO.getValue("fy" + i + "cost_detail_desc");
				String sqlDelete = "delete from bgp_op_target_project_detail where gp_target_project_id='" + gpTargetProjectId + "'";
				// jdbcTemplate.execute(sqlDelete);
				((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).executeUpdate(sqlDelete);
				Map map = new HashMap();
				map.put("gp_target_project_id", gpTargetProjectId);
				map.put("cost_detail_money", costDetailMoney);
				map.put("cost_detail_desc", costDetailDesc);
				map.put("bsflag", "0");
				pureDao.saveOrUpdateEntity(map, "bgp_op_target_project_detail");
			}
		}
		responseDTO.setValue("success", "true");
		return responseDTO;
	}

	/*
	 * 获取人员费用信息
	 */
	public ISrvMsg getHumanShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			// 若第一次进入改模块,先初始化人员信息，将人员信息从人员调配业务表中抽取到费用分摊表
			String queryIfFirst = "select cost_human_id from  bgp_op_cost_tartet_human where project_info_no = '" + projectInfoNo + "'";
			Map mapIfFirst = jdbcDao.queryRecordBySQL(queryIfFirst);
			if (mapIfFirst == null) {
				StringBuffer queryDeviceInfo = new StringBuffer(" select t.employee_id,e.employee_name,t.team,d1.coding_name team_name,t.work_post,d2.coding_name work_post_name, ");
				queryDeviceInfo.append(" d3.coding_name employee_gz_name,t.plan_start_date,t.plan_end_date,t.actual_start_date,t.actual_end_date ");
				queryDeviceInfo.append("  from bgp_human_prepare_human_detail t ");
				queryDeviceInfo.append(" inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' ");
				queryDeviceInfo.append(" inner join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag = '0' ");
				queryDeviceInfo.append(" inner join comm_human_employee_hr hr on t.employee_id = hr.employee_id  ");
				queryDeviceInfo.append(" inner join comm_coding_sort_detail d1 on t.team = d1.coding_code_id and d1.bsflag = '0' ");
				queryDeviceInfo.append(" inner join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id and d2.bsflag = '0' ");
				queryDeviceInfo.append(" inner join comm_coding_sort_detail d3 on hr.employee_gz = d3.coding_code_id and d3.bsflag = '0' ");
				queryDeviceInfo.append(" where t.bsflag = '0' and p.project_info_no = '8a9588b63618fc0d01361a93e0bf0018' ");
				List<Map> list = pureDao.queryRecords(queryDeviceInfo.toString());
				if (list != null && list.size() > 0) {
					for (Map map : list) {
						map.put("project_info_no", projectInfoNo);
						map.put("bsflag", "0");
						pureDao.saveOrUpdateEntity(map, "BGP_OP_COST_TARTET_HUMAN");
					}
				}
			}
			// 读取人员费用信息
			StringBuffer queryHumanCost = new StringBuffer(
					" select rownum, t.cost_human_id,t.employee_id,t.project_info_no,t.plan_start_date,t.plan_end_date,t.actual_start_date,t.actual_end_date, ");
			queryHumanCost.append(" t.team_name,t.employee_gz_name, t.actual_wage,e.employee_name,t.plan_end_date-t.plan_start_date as date_num, ");
			queryHumanCost.append(" t.actual_wage/30*(t.plan_end_date-t.plan_start_date) sum_wage ");
			queryHumanCost.append("  from BGP_OP_COST_TARTET_HUMAN t  left outer join comm_human_employee e on t.employee_id = e.employee_id and t.bsflag='0' ");
			queryHumanCost.append(" where t.project_info_no = '" + projectInfoNo + "'");
			List list = jdbcDao.queryRecords(queryHumanCost.toString());
			responseDTO.setValue("datas", list);
			responseDTO.setValue("totalRows", list != null ? list.size() : 0);

			responseDTO.setValue("pageCount", "1");
			responseDTO.setValue("pageSize", "0");
			responseDTO.setValue("currentPage", "1");
		}

		return responseDTO;
	}

	/*
	 * 保存人员费用信息
	 */
	public ISrvMsg saveHumanShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String checkNums = reqDTO.getValue("checkNums");
		String dataInfoStrs = reqDTO.getValue("dataInfoStrs");
		if (checkNums != null && !"".equals(checkNums) && dataInfoStrs != null && !"".equals(dataInfoStrs)) {
			String[] checkNum = checkNums.split(",");
			String[] dataInfoStr = dataInfoStrs.split(",");
			for (String i : checkNum) {
				Map map = new HashMap();
				for (String j : dataInfoStr) {
					map.put(j, reqDTO.getValue("fy" + i + j));
				}
				pureDao.saveOrUpdateEntity(map, "bgp_op_cost_tartet_human");
			}
		}
		responseDTO.setValue("success", "true");
		return responseDTO;
	}

	/*
	 * 获取内部设备租赁信息
	 */
	public ISrvMsg getMataxiShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.plan_end_date-t.plan_start_date+1 date_num ,");
		sql.append(" case t.dev_name when '0' then '动迁时间' when '1' then '租赁时间' when '2' then '遣散时间' "+
		" when '3' then '待工时间' when '4' then '交回验收时间' when '5' then '超计划占用时间' else'' end dev_name1,");
		sql.append(" t.*,t.dev_count*t.taxi_unit*(t.plan_end_date-t.plan_start_date+1) mataxi_price ,");
		sql.append(" decode(t.mataxi_type,'1','仪器','2','运载设备','3','专用工具','') mataxi_type_name,");
		sql.append(" t.dev_count*t.taxi_unit*(t.plan_end_date-t.plan_start_date+1)*t.taxi_ratio manage_price ");
		sql.append(" from bgp_op_target_device_mataxi t where  t.mataxi_type !='4' and t.project_info_no='" + projectInfoNo
				+ "'  and  t.if_change ='0' and t.bsflag='0'  order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取专用工具修理费信息
	 */
	public ISrvMsg getMatareShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.*,to_char(t.dev_count*t.taxi_unit,'9999999999999999.99') sum_price ,case t.dev_type when '1' then '物探处专用工具' when '2' then '装备部专用工具' else '' end type");
		sql.append(" from bgp_op_target_device_matare t where   t.project_info_no='" + projectInfoNo + "'  and  t.if_change ='0' and t.bsflag='0'  order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取震源设备租赁信息
	 */
	public ISrvMsg getShocksShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.plan_end_date-t.plan_start_date+1 date_num ,");
		sql.append(" t.*,'震源' mataxi_type_name,");
		sql.append(" case t.dev_name when '0' then '动迁时间' when '1' then '租赁时间' when '2' then '遣散时间' "+
		" when '3' then '待工时间' when '4' then '交回验收时间' when '5' then '超计划占用时间' else'' end dev_name1,");
		sql.append(" to_char(t.dev_count*t.taxi_unit*((t.plan_end_date-t.plan_start_date+1)-nvl(t.passive_date,0))*t.taxi_ratio,'9999999999999999.99') manage_price ");
		sql.append(" from bgp_op_target_device_mataxi t where   t.mataxi_type ='4' and  t.project_info_no='" + projectInfoNo
				+ "'  and  t.if_change ='0' and t.bsflag='0' order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取测量设备租赁信息
	 */
	public ISrvMsg getMeasureShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.*,decode(t.surface_type,'1','有作物农田、浮土地','2','无作物农田、戈壁、平原','3','山地Ⅰ类','4','山地Ⅱ类',5,'山地Ⅲ类','6','沙漠(小沙)','7','沙漠(大沙)','8','水网、沼泽') surface_type_name,");
		sql.append(" to_char((nvl(t.detector_line,0)+nvl(bomb_line,0))*measure_price*nvl(measure_ratio,0),'9999999999999999.99') sum_price ");
		sql.append(" from bgp_op_tartet_device_measure t where bsflag='0' and t.project_info_no='" + projectInfoNo + "'  and  t.if_change ='0' order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取测量辅助费用信息
	 */
	public ISrvMsg getMeassistShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.* ");
		sql.append(" from bgp_op_tartet_device_meassist t where bsflag='0' and t.project_info_no='" + projectInfoNo + "'   and t.if_change ='0'  order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取安全设施投入费用信息
	 */
	public ISrvMsg getHseShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.*,to_char(t.hse_unit*(t.hse_count_t),'9999999999999999.99') hse_money ");
		sql.append(" from BGP_OP_COST_TARTET_HSE t where bsflag='0' and t.project_info_no='" + projectInfoNo + "'   and  t.if_change ='0'  order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取劳保费用信息
	 */
	public ISrvMsg getLabormonShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.*,to_char(t.person_num*t.person_money,'9999999999999999.99') sum_labormon ");
		sql.append(" from BGP_OP_COST_TARTET_LABORMON t where bsflag='0' and t.project_info_no='" + projectInfoNo + "'   and  t.if_change ='0'  order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取运输费用测算
	 */
	public ISrvMsg getDerentShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer(
				"select t.*,to_char((t.Plan_End_Date-T.PLAN_START_DATE+1)*T.DERENT_MONEY*t.DERENT_COUNT,'9999999999999999.99') SUM_DERENT ,t.Plan_End_Date-T.PLAN_START_DATE+1 day_num ");
		sql.append(" from bgp_op_cost_tartet_derent t where bsflag='0' and t.project_info_no='" + projectInfoNo + "'   and t.if_change ='0'  order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取动迁费用信息
	 */
	public ISrvMsg getTransportShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer(
				"select t.*,to_char(t.tonnage*t.transport_count*t.transport_unit*(nvl(t.start_meter,0)+nvl(t.back_meter,0)),'9999999999999999.99') sum_transport ");
		sql.append(" from BGP_OP_COST_TARTET_TRANSPORT t where bsflag='0' and transport_type = '0' and t.project_info_no='" + projectInfoNo
				+ "'   and t.if_change ='0'  order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}
	
	
	
	/*
	 * 获取动迁费用信息
	 */
	public ISrvMsg getTransportHShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer(
				"select t.*,to_char(t.person_num*t.person_money-(-other_money),'9999999999999999.99') sum_transport ");//
		sql.append(" from BGP_OP_COST_TARTET_TRANSPORT_H t where bsflag='0'  and t.project_info_no='" + projectInfoNo
				+ "'   and t.if_change ='0'  order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}
	/*
	 * 获取动迁费用信息
	 */
	public ISrvMsg getTransportHOtherMoney(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String other_money = reqDTO.getValue("money");
		if(other_money!=null && !other_money.trim().equals("")){
			Double money = OPCaculator.excute(other_money);
			responseDTO.setValue("money", money);
		}else{
			responseDTO.setValue("money", 0);
		}
		return responseDTO;
	}
	/*
	 * 获取动迁费用信息
	 */
	public ISrvMsg getDeviceHShareInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer(
				"select t.*,to_char(nvl(t.person_num,0)*nvl(t.person_money,0)-(-nvl(other_money,0)),'9999999999999999.99') sum_transport ");
		sql.append(" from BGP_OP_TARGET_DEVICE_HUM t where bsflag='0'  and t.project_info_no='" + projectInfoNo
				+ "'   and t.if_change ='0'  order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}
	

	/*
	 * 获取动迁-运输费费用信息
	 */
	public ISrvMsg getTransportShareOtherInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer(
				"select t.*,to_char(t.tonnage*t.transport_count*t.transport_unit*(nvl(t.start_meter,0)+nvl(t.back_meter,0)),'9999999999999999.99') sum_transport ");
		sql.append(" from BGP_OP_COST_TARTET_TRANSPORT t where bsflag='0' and transport_type = '1'  and t.project_info_no='" + projectInfoNo
				+ "'   and t.if_change ='0'  order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}
	
	public ISrvMsg getProjectSchema(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String if_workflow = reqDTO.getValue("if_workflow");
		if(if_workflow!=null && if_workflow.trim().equals("1")){
			if_workflow = "and if_workflow ='1'";
		}else{
			if_workflow = "";
		}
		StringBuffer sb = new StringBuffer("");
		sb.append("with detail_money as (select ps.project_info_no,pp.cost_project_schema_id,pp.cost_detail_money from bgp_op_cost_project_schema ps")
		.append(" left join (select pd.cost_project_schema_id ,sum(nvl(pd.cost_detail_money,0))cost_detail_money  from bgp_op_cost_project_detail pd ")
		.append(" left join bgp_op_cost_project_info pi on pd.gp_cost_project_id = pi.gp_cost_project_id and pi.bsflag ='0'")
		.append(" where pd.bsflag='0' and pi.node_code like'S01001%' group by pd.cost_project_schema_id)pp on ps.cost_project_schema_id = pp.cost_project_schema_id")
		.append(" where bsflag ='0' and project_info_no ='").append(projectInfoNo).append("'  order by schema_name)")
		.append(" select rownum row_num ,s.*,case when s.if_decision ='1' then 'blue' when s.cost_detail_money=s.max_money then 'red' ")
		.append(" when s.cost_detail_money=s.min_money then 'green' else'black' end decision")
		.append(" from (select t.* ,nvl(dd.cost_detail_money,0) cost_detail_money ,m.max_money,m.min_money from bgp_op_cost_project_schema t ")
		.append(" left join (select d.cost_project_schema_id ,sum(nvl(d.cost_detail_money,0))cost_detail_money  from bgp_op_cost_project_detail d ")
		.append(" left join bgp_op_cost_project_info pi on d.gp_cost_project_id = pi.gp_cost_project_id and pi.bsflag ='0' ")
		.append(" where d.bsflag='0' and pi.node_code like'S01001%' group by d.cost_project_schema_id)dd on t.cost_project_schema_id = dd.cost_project_schema_id")
		.append(" left join(select max(dm.cost_detail_money) max_money,min(dm.cost_detail_money) min_money from detail_money dm ")
		.append(" where nvl(dm.cost_detail_money,0)!=0)m on 1=1 where t.bsflag ='0' and t.project_info_no ='").append(projectInfoNo).append("' ")
		.append(if_workflow).append(" order by schema_name)s");
		
		//String sqlCode = "select rownum row_num ,s.* from (select decode(t.if_decision,'1','blue','black')decision,t.* from bgp_op_cost_project_schema t where bsflag ='0' and project_info_no ='"+projectInfoNo+"' "+if_workflow+" order by schema_name) s";
		List<Map> list = jdbcDao.queryRecords(sb.toString());
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	/*
	 * 计算一体化方案对比
	 */
	public ISrvMsg getCostSchemaContrastInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String if_workflow = reqDTO.getValue("if_workflow");
		String project_type = OPCommonUtil.getProjectType(projectInfoNo);
		
		String[] colName = {"观测系统类型-tech_001", "设计线束-tech_002","满覆盖工作量-tech_003", "实物工作量-tech_004","井炮生产炮数-tech_005","震源生产炮数-tech_006",
				"气枪生产炮数-tech_007","炮数-tech_008", "微测井-tech_009","小折射-tech_010", "接收道数-tech_011","检波器串数-tech_012","覆盖次数-tech_013",
				"道间距-tech_014","炮点距-tech_015", "接收线距-tech_016","炮线距-tech_017","单线道数-tech_018","滚动接收线数-tech_019", "面元-tech_020"};
		if(if_workflow!=null && if_workflow.trim().equals("1")){
			if_workflow = "and if_workflow ='1'";
		}else{
			if_workflow = "";
		}
		StringBuffer sb = new StringBuffer("select rownum row_num ,s.* from (select * from bgp_op_cost_project_schema where bsflag ='0' and project_info_no ='"+projectInfoNo+"' "+if_workflow+" order by schema_name) s");
		List<Map> tech_list = pureDao.queryRecords(sb.toString());
		String cols= "";
		sb = new StringBuffer("");
		for(int i=1;i<=tech_list.size();i++){
			cols += "t"+i+".cost_detail_money cost_detail_money"+i+",";
			sb.append(" left join(select p.template_id,p.node_code,p.cost_name,(select nvl(sum(d.cost_detail_money),0) from bgp_op_cost_project_info pi left join bgp_op_cost_project_detail d on pi.gp_cost_project_id = d.gp_cost_project_id") 
			.append(" where pi.bsflag ='0' and pi.node_code like p.node_code ||'%'  and pi.cost_project_schema_id =(select cost_project_schema_id from(select rownum row_num ,s.* from (select * from bgp_op_cost_project_schema ")
			.append(" where bsflag ='0' and project_info_no ='").append(projectInfoNo).append("' "+if_workflow+" order by schema_name) s) where row_num ="+i+"))cost_detail_money")
			.append(" from bgp_op_cost_project_info p where p.bsflag ='0' and p.cost_project_schema_id =(select cost_project_schema_id from(select rownum row_num ,s.* from (select * from bgp_op_cost_project_schema ")
			.append(" where bsflag ='0' and project_info_no ='").append(projectInfoNo).append("' "+if_workflow+" order by schema_name ) s) where row_num ="+i+")) t"+i+" on t.template_id = t"+i+".template_id and t.node_code = t"+i+".node_code");
		}
		String sql = "select "+cols+" t.cost_name from bgp_op_cost_template t"+sb.toString()+" where t.bsflag = '0' start with t.parent_id ='01' connect by prior t.template_id = t.parent_id order siblings by t.order_code";
		List<Map> list = pureDao.queryRecords(sql);
		int j = 0;
		int length = 20;
		if(project_type!=null && project_type.trim().equals("2")){
			length = 15;
		}
		for(String s:colName){
			if(j>=length) break;
			String title = s.split("-")[0];
			String col = s.split("-")[1];
			Map map = new HashMap();
			map.put("cost_name", title);
			for(int i=0;tech_list!=null && i<tech_list.size();i++){
				Map temp = (Map)tech_list.get(i);
				String row_num = temp==null||temp.get("row_num")==null?"":(String)temp.get("row_num");
				map.put("cost_detail_money"+row_num, temp==null||temp.get(col)==null?"":(String)temp.get(col));
			}
			if(list==null)list = new ArrayList();
			list.add(j++,map);
		}
		Map map = new HashMap();
		String s = "工作量类型-spare5";
		String title = s.split("-")[0];
		String col = s.split("-")[1];
		map.put("cost_name", title);
		for(int i=0;tech_list!=null && i<tech_list.size();i++){
			Map temp = (Map)tech_list.get(i);
			String row_num = temp==null||temp.get("row_num")==null?"":(String)temp.get("row_num");
			String spare5 = temp==null||temp.get(col)==null?"":(String)temp.get(col);
			if(spare5!=null && spare5.trim().equals("2")){
				spare5 ="实物工作量";
			}else{
				spare5 ="满覆盖工作量";
			}
			map.put("cost_detail_money"+row_num, spare5);
		}
		list.add(0,map);
		
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list.size());
		responseDTO.setValue("pageSize", "1000");
		
		return responseDTO;
	}

	/*
	 * 一体化方案论证审核
	 */
	public ISrvMsg getCostSchemaInfowfpg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		return responseDTO;
	}

	/*
	 * 一体化方案论证审核
	 */
	public ISrvMsg doCostSchemaInfowfpa(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String schemaId = reqDTO.getValue("checkedSchemaId");
		String isPass = reqDTO.getValue("isPass");
		if ("pass".equals(isPass)) {
			if (schemaId != null) {
				String[] schemaIds = schemaId.split(",");
				if (schemaIds != null && schemaIds.length > 0) {
					for (String s : schemaIds) {
						String sql = "update  bgp_op_cost_project_schema t set t.if_decision='1' where t.cost_project_schema_id ='" + s + "'";
						jdbcTemplate.execute(sql);
					}
				}
			}
		}
		return responseDTO;

	}

	/*
	 * 经营管理责任书初始化
	 */
	public ISrvMsg initCostTargetPledges(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		// 获取目标成本基本信息表主键
		String sqlBasicId = "select tartget_basic_id from BGP_OP_TARGET_PROJECT_BASIC where project_info_no = '" + projectInfoNo + "' and bsflag='0'";
		Map map = pureDao.queryRecordBySQL(sqlBasicId);
		boolean audit = false;
		String basicId = map == null ? null : (String) map.get("tartget_basic_id");
		if (basicId != null) {
			// 责任书是否已初始化
			String sqlPledges = "select TARGET_PLEDGES_ID from BGP_OP_TARGET_PROJECT_PLEDGES where bsflag='0' and  tartget_basic_id='" + basicId + "'";
			Map mapPledges = pureDao.queryRecordBySQL(sqlPledges);
			String targetPledgesId = mapPledges == null ? null : (String) mapPledges.get("target_pledges_id");
			if (targetPledgesId == null) {
				// 获取审批状态
				String sqlAudit = "select PROC_STATUS from common_busi_wf_middle where business_id = '" + basicId + "' and busi_table_name = 'BGP_OP_TARGET_PROJECT_BASIC' ";
				Map mapAudit = pureDao.queryRecordBySQL(sqlAudit);
				if (mapAudit != null) {
					String procStatus = (String) mapAudit.get("proc_status");
					if ("3".equals(procStatus)) {
						audit = true;
						Map mapForSave = new HashMap();
						mapForSave.put("bsflag", "0");
						mapForSave.put("tartget_basic_id", basicId);
						targetPledgesId = pureDao.saveOrUpdateEntity(mapForSave, "BGP_OP_TARGET_PROJECT_PLEDGES").toString();
						responseDTO.setValue("targetPledgesId", targetPledgesId);
					}
				}
			} else {
				audit = true;
				responseDTO.setValue("targetPledgesId", targetPledgesId);
			}
		}
		responseDTO.setValue("audit", audit);
		return responseDTO;
	}

	/*
	 * 获取项目目标费用预算调整对比信息，返回json串
	 */
	public ISrvMsg getCostTargetChangeProject(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String project_type = reqDTO.getValue("project_type");
		String costType = reqDTO.getValue("costType");
		if (costType == null || "".equals(costType)) {
			costType = OPCommonUtil.getCostTypeOfTargetProject(projectInfoNo);
		}
		String ifcheck = reqDTO.getValue("ifcheck");
		StringBuffer sqlBuffer = new StringBuffer("select connect_by_root(f.gp_target_project_id) root,level, ");
		sqlBuffer.append(" decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf, ");
		sqlBuffer.append(" sys_connect_by_path(substr(f.node_code, 0, length(f.node_code) - 3) || lpad(f.order_code + 1, 3, '0'), '/') path, ");
		sqlBuffer.append(" f.parent_id zip,f.gp_target_project_id gp_cost_temp_id,f.*,s.cost_detail_money cost_change_money,s.cost_detail_desc cost_change_desc, ");
		//sqlBuffer.append(" case when (s.cost_detail_money is not null or f.cost_detail_money is not null) then nvl(s.cost_detail_money,0)-nvl(f.cost_detail_money,0) else s.cost_detail_money-f.cost_detail_money end cost_plus_money ");
		sqlBuffer.append(" nvl(s.cost_detail_money,0)-nvl(f.cost_detail_money,0) cost_plus_money ");
		sqlBuffer.append(" from view_op_target_plan_money_f f inner join view_op_target_plan_money_s s ");
		sqlBuffer.append(" on f.gp_target_project_id = s.gp_target_project_id and f.project_info_no = '" + projectInfoNo + "' ");
		sqlBuffer.append(" start with f.parent_id = '01' connect by prior f.gp_target_project_id = f.parent_id order by path asc ");

		List<Map> list = jdbcDao.queryRecords(sqlBuffer.toString());

		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list != null ? list.size() : 0);

		responseDTO.setValue("pageCount", "1");
		responseDTO.setValue("pageSize", "0");
		responseDTO.setValue("currentPage", "1");

		// 获取项目名称

		String projectName = OPCommonUtil.getProjectNameByProjectInfoNo(projectInfoNo);
		Map map = new HashMap();
		map.put("gpCostTempId", costType);
		map.put("parentId", "root");
		map.put("costName", projectName);
		map.put("costDesc", "");
		map.put("expanded", "true");
		if(project_type!=null && project_type.trim().equals("5000100004000000009")){
			String sum_money1 = OPCommonUtil.getWhtSumMoney(projectInfoNo,"");
			String sum_money2 = OPCommonUtil.getWhtSumMoney(projectInfoNo,"adjust");
			map.put("costDetailMoney", sum_money1);
			map.put("costPlusMoney", sum_money2);
			map.put("costChangeMoney", Double.valueOf(sum_money1)+Double.valueOf(sum_money2));
		}
		
		Map jsonMap = new HashMap();
		if ("true".equals(ifcheck)) {
			jsonMap = OPCommonUtil.convertListTreeToJsonCheck(list, "gpCostTempId", "parentId", map);
		} else {
			jsonMap = OPCommonUtil.convertListTreeToJson(list, "gpCostTempId", "parentId", map);
		}

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		responseDTO.setValue("basicId", OPCommonUtil.getTargetProjectBasicId(projectInfoNo));
		return responseDTO;
	}

	/*
	 * 获取项目目标费用预算调整对比信息，返回json串
	 */
	public ISrvMsg getCostTargetNFormulaChangeProject(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String costType = reqDTO.getValue("costType");
		if (costType == null || "".equals(costType)) {
			costType = OPCommonUtil.getCostTypeOfTargetProject(projectInfoNo);
		}
		String ifcheck = reqDTO.getValue("ifcheck");
		StringBuffer sqlBuffer = new StringBuffer("select m.*,nvl(m.cost_change_money_z,0) cost_change_money from ( select t.root,t.leaf,t.path,t.cost_name,t.gp_cost_temp_id,t.parent_id,t.parent_id zip, ");
		sqlBuffer.append(" t.order_code,t.cost_detail_money cost_change_money_z,t.node_code,t.project_info_no, ");
		sqlBuffer.append(" (select sum(vpm.cost_detail_money) from bgp_op_target_project_detail vpm inner join bgp_op_target_project_info pi ");
		sqlBuffer.append(" on vpm.gp_target_project_id = pi.gp_target_project_id and vpm.bsflag = '0' and pi.bsflag = '0' ");
		sqlBuffer.append(" where pi.project_info_no = t.project_info_no and pi.node_code like concat(t.node_code, '%')) cost_detail_money ");
		sqlBuffer.append(" from (select connect_by_root(gp_cost_temp_id) root,decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf, ");
		sqlBuffer.append(" sys_connect_by_path(substr(node_code, 0, length(node_code) - 3) || lpad(order_code + 1, 3, '0'), '/') path, ");
		sqlBuffer.append(" cost_name,gp_cost_temp_id,parent_id,parent_id zip,order_code,cost_detail_money,node_code,project_info_no ");
		sqlBuffer.append(" from (select cp.gp_target_project_id gp_cost_temp_id,cp.PROJECT_INFO_NO,cp.cost_name,cp.parent_id,cp.order_code, ");
		sqlBuffer.append(" cp.cost_detail_money,cp.node_code ");
		sqlBuffer.append(" from view_op_target_plan_otherc cp  where cp.bsflag = '0' and cp.project_info_no = '" + projectInfoNo + "') ");
		sqlBuffer.append(" start with parent_id = '" + costType + "' connect by prior gp_cost_temp_id = parent_id) t)m  ORDER BY path ASC");

		List<Map> list = jdbcDao.queryRecords(sqlBuffer.toString());

		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list != null ? list.size() : 0);

		responseDTO.setValue("pageCount", "1");
		responseDTO.setValue("pageSize", "0");
		responseDTO.setValue("currentPage", "1");

		// 获取项目名称

		String projectName = OPCommonUtil.getProjectNameByProjectInfoNo(projectInfoNo);
		Map map = new HashMap();
		map.put("gpCostTempId", costType);
		map.put("parentId", "root");
		map.put("costName", projectName);
		map.put("costDesc", "");
		map.put("expanded", "true");

		Map jsonMap = new HashMap();
		if ("true".equals(ifcheck)) {
			jsonMap = OPCommonUtil.convertListTreeToJsonCheck(list, "gpCostTempId", "parentId", map);
		} else {
			jsonMap = OPCommonUtil.convertListTreeToJson(list, "gpCostTempId", "parentId", map);
		}

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		responseDTO.setValue("basicId", OPCommonUtil.getTargetProjectBasicId(projectInfoNo));
		return responseDTO;
	}

	/*
	 * 获取油料目标预算变更信息
	 */
	public ISrvMsg getTargetAdjustOilInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			// 读取设备费用信息
			StringBuffer queryDeviceCost = new StringBuffer(
					"select td.dev_name,nvl(da.dev_model,td.dev_model) dev_model,da.asset_coding,da.license_num,da.turn_num,da.self_num,da.dev_sign,nvl(td.DEVICE_COUNT,1) DEVICE_COUNT,sd.coding_name dev_team,td.dev_acc_id,td.cost_device_id, ");
			queryDeviceCost.append(" td.plan_start_date,td.plan_end_date,td.plan_end_date - td.plan_start_date+1 as date_num, ");
			queryDeviceCost.append(" td.actual_start_date,td.daily_oil_type,td.actual_end_date,td.daily_oil,td.daily_small_oil,td.single_well_oil, ");
			queryDeviceCost.append(" td.oil_unit_price,decode(td.daily_oil_type,'2','柴油','1','汽油','') daily_oil_type_name, ");
			queryDeviceCost.append(" decode(td.if_change,'1','变更数据','非变更数据') change_data, to_char(td.change_date,'yyyy-MM-dd') change_date,");
			queryDeviceCost
					.append(" to_char(td.oil_unit_price * (nvl(td.daily_oil,0)+nvl(td.single_well_oil,0)) *(td.plan_end_date - td.plan_start_date+1) * nvl(td.device_count,1),'9999999999999999.99') sum_oil_price, ");
			queryDeviceCost.append(" to_char(td.daily_small_oil * (td.plan_end_date - td.plan_start_date+1) * nvl(td.device_count,1),'9999999999999999.99') sum_small_oil_price ");
			queryDeviceCost.append(" from bgp_op_tartet_device_oil td  left outer join gms_device_account_dui da on td.dev_acc_id = da.dev_acc_id");
			queryDeviceCost.append(" left outer join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id ");
			queryDeviceCost.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo + "' and td.if_change !='2'  and td.if_delete_change is null");

			String dev_team = reqDTO.getValue("dev_team");
			String dev_name = reqDTO.getValue("dev_name");
			String dev_model = reqDTO.getValue("dev_model");
			if (dev_team != null) {
				queryDeviceCost.append(" and td.dev_team like '%" + dev_team + "%'");
			}
			if (dev_name != null) {
				queryDeviceCost.append(" and td.dev_name like '%" + dev_name + "%'");
			}
			if (dev_model != null) {
				queryDeviceCost.append(" and td.dev_model like '%" + dev_model + "%'");
			}
			queryDeviceCost.append(" order by td.create_date desc ");

			OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, queryDeviceCost.toString());
		}
		return responseDTO;
	}

	/*
	 * 保存目标预算变更信息
	 */
	public ISrvMsg saveTargetAdjustInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		Map map = reqDTO.toMap();
		String ifChange = (String) map.get("if_change");
		String jcdpTableId = (String) map.get("JCDP_TABLE_ID");
		String tableId = (String) map.get("tableId");
		String tableName = (String) map.get("JCDP_TABLE_NAME");

		if (jcdpTableId == null) {// 新增
			map.put("if_change", "1");
			pureDao.saveOrUpdateEntity(map, tableName);
		} else {
			if ("1".equals(ifChange)) {// 变更数据的修改删除
				pureDao.saveOrUpdateEntity(map, tableName);
			} else {// 原始数据的变更
				String sql = "select * from " + tableName + " where " + tableId + "='" + jcdpTableId + "'";
				Map mapDate = pureDao.queryRecordBySQL(sql);
				mapDate.remove("if_delete_change");
				mapDate.put("if_delete_change", "1");
				mapDate.put(tableId, jcdpTableId);
				pureDao.saveOrUpdateEntity(mapDate, tableName);
				map.remove(tableId);
				map.remove("JCDP_TABLE_ID");
				map.put("if_change", "1");
				map.put("create_date", mapDate.get("create_date"));
				map.put("dev_acc_id", mapDate.get("dev_acc_id"));
				map.put("self_num", mapDate.get("self_num"));
				map.put("dev_sign", mapDate.get("dev_sign"));
				pureDao.saveOrUpdateEntity(map, tableName);
			}
		}
		return responseDTO;
	}

	/*
	 * 获取设备折旧费用信息
	 */
	public ISrvMsg getDeviceAdjustDepreInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			// 读取设备费用信息
			StringBuffer queryDeviceCost = new StringBuffer(
					"select td.dev_name,td.dev_model,da.turn_num,da.self_num,da.asset_coding,da.license_num,td.dev_acc_id,nvl(td.device_count,1) device_count,td.target_depre_id,sd.coding_name dev_team,td.dev_sign, ");
			queryDeviceCost.append(" td.plan_start_date,td.plan_end_date,td.plan_end_date - td.plan_start_date+1 as date_num, ");
			queryDeviceCost.append(" td.actual_start_date,td.actual_end_date,td.asset_value,td.depreciation_value, ");
			queryDeviceCost.append(" decode(td.if_change,'1','变更数据','非变更数据') change_data,to_char(td.change_date,'yyyy-MM-dd') change_date, ");
			queryDeviceCost.append(" to_char(decode(td.depreciation_value,0,0,td.asset_value*0.97/td.depreciation_value/8),'9999999999999999.99') sum_month_depreciation, ");
			queryDeviceCost
					.append(" to_char(decode(td.depreciation_value,0,0,td.asset_value*0.97/td.depreciation_value/8*td.device_count/30*(td.plan_end_date-td.plan_start_date+1)),'9999999999999999.99') sum_depreciation ");
			queryDeviceCost.append(" from bgp_op_tartet_device_depre td  left outer join gms_device_account_dui da on td.dev_acc_id = da.dev_acc_id ");
			queryDeviceCost.append(" left outer join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id ");
			queryDeviceCost.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo + "' and td.record_type = '0' and  (td.if_change!='2' and  td.if_delete_change is null)  ");

			String dev_team = reqDTO.getValue("dev_team");
			String dev_name = reqDTO.getValue("dev_name");
			String dev_model = reqDTO.getValue("dev_model");
			if (dev_team != null) {
				queryDeviceCost.append(" and td.dev_team like '%" + dev_team + "%'");
			}
			if (dev_name != null) {
				queryDeviceCost.append(" and td.dev_name like '%" + dev_name + "%'");
			}
			if (dev_model != null) {
				queryDeviceCost.append(" and td.dev_model like '%" + dev_model + "%'");
			}
			queryDeviceCost.append(" order by td.create_date desc ");

			OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, queryDeviceCost.toString());
		}
		return responseDTO;
	}

	/*
	 * 获取长期待摊费用调整信息
	 */
	public ISrvMsg getDeviceAdjustDepreOtherInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			// 读取设备费用信息
			StringBuffer queryDeviceCost = new StringBuffer("select to_char(td.change_date,'yyyy-MM-dd') change_date,td.dev_name,td.dev_model,td.dev_acc_id,td.target_depre_id, ");
			queryDeviceCost.append(" td.plan_start_date,td.plan_end_date,td.plan_end_date - td.plan_start_date+1 as date_num, ");
			queryDeviceCost.append(" td.actual_start_date,td.actual_end_date,td.asset_value,td.depreciation_value, ");
			queryDeviceCost.append(" decode(td.if_change,'1','变更数据','非变更数据') change_data, td.device_count,");
			queryDeviceCost.append(" to_char(decode(td.depreciation_value,0,0,td.asset_value*0.97/td.depreciation_value/8),'9999999999999999.99') sum_month_depreciation, ");
			queryDeviceCost
					.append(" to_char(decode(td.depreciation_value,0,0,td.asset_value*0.97/td.depreciation_value/8*td.device_count/30*(td.plan_end_date-td.plan_start_date+1)),'9999999999999999.99') sum_depreciation ");
			queryDeviceCost.append(" from bgp_op_tartet_device_depre td  ");
			queryDeviceCost.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo
					+ "' and td.record_type = '1' and  (td.if_change!='2' and  td.if_delete_change is null) order by td.create_date desc");
			OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, queryDeviceCost.toString());
		}
		return responseDTO;
	}

	/*
	 * 获取设备材料费用预算调整信息
	 */
	public ISrvMsg getDeviceAdjustMaterialInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			// 读取设备费用信息
			StringBuffer queryDeviceCost = new StringBuffer(
					"select td.dev_name,td.dev_model,da.turn_num,da.self_num,da.asset_coding,da.license_num,td.dev_sign,nvl(td.DEVICE_COUNT,1) DEVICE_COUNT,sd.coding_name dev_team,td.dev_acc_id,td.target_material_id, ");
			queryDeviceCost.append(" td.plan_start_date,td.plan_end_date,td.plan_end_date - td.plan_start_date+1 as date_num, ");
			queryDeviceCost.append(" decode(td.if_change,'1','变更数据','非变更数据') change_data, to_char(td.change_date,'yyyy-MM-dd') change_date,");
			queryDeviceCost.append(" td.actual_start_date,td.actual_end_date,td.vehicle_daily_material,td.drilling_daily_material,td.restore_repails, ");
			queryDeviceCost
					.append(" to_char(td.vehicle_daily_material*(td.plan_end_date - td.plan_start_date+1)*td.device_count,'9999999999999999.99') sum_vehicle_daily_material, ");
			queryDeviceCost
					.append(" to_char(td.drilling_daily_material*(td.plan_end_date - td.plan_start_date+1)*td.device_count,'9999999999999999.99') sum_drilling_daily_material ");
			queryDeviceCost.append(" from bgp_op_tartet_device_material td left outer join gms_device_account_dui da on td.dev_acc_id = da.dev_acc_id");
			queryDeviceCost.append(" left outer join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id ");
			queryDeviceCost.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo + "' and  (td.if_change!='2' and td.if_delete_change is null ) ");

			String dev_team = reqDTO.getValue("dev_team");
			String dev_name = reqDTO.getValue("dev_name");
			String dev_model = reqDTO.getValue("dev_model");
			if (dev_team != null) {
				queryDeviceCost.append(" and td.dev_team like '%" + dev_team + "%'");
			}
			if (dev_name != null) {
				queryDeviceCost.append(" and td.dev_name like '%" + dev_name + "%'");
			}
			if (dev_model != null) {
				queryDeviceCost.append(" and td.dev_model like '%" + dev_model + "%'");
			}
			queryDeviceCost.append(" order by td.create_date desc ");

			OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, queryDeviceCost.toString());
		}
		return responseDTO;
	}

	/*
	 * 获取仪器、运载、专用工具设备租赁信息预算调整
	 */
	public ISrvMsg getMataxiAdjustInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.plan_end_date-t.plan_start_date+1 date_num ,");
		sql.append(" t.*,t.dev_count*t.taxi_unit*(t.plan_end_date-t.plan_start_date+1) mataxi_price ,");
		sql.append(" case t.dev_name when '0' then '动迁时间' when '1' then '租赁时间' when '2' then '遣散时间' "+
		" when '3' then '待工时间' when '4' then '交回验收时间' when '5' then '超计划占用时间' else'' end dev_name1,");
		sql.append(" decode(t.if_change,'1','变更数据','非变更数据') change_data, ");
		sql.append(" decode(t.mataxi_type,'1','仪器','2','运载设备','3','专用工具','') mataxi_type_name,");
		sql.append(" to_char(t.dev_count*t.taxi_unit*(t.plan_end_date-t.plan_start_date+1)*t.taxi_ratio,'9999999999999999.99') manage_price  ");
		sql.append(" from bgp_op_target_device_mataxi t where bsflag='0' and t.project_info_no='" + projectInfoNo
				+ "' and t.mataxi_type !='4'  and  (t.if_change!='2' and t.if_delete_change is null) order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取仪器、运载、专用工具设备租赁信息预算调整
	 */
	public ISrvMsg getMatareAdjustInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.* , decode(t.if_change,'1','变更数据','非变更数据') change_data, ");
		sql.append(" to_char(t.dev_count*t.taxi_unit,'9999999999999999.99') sum_price  ");
		sql.append(" from bgp_op_target_device_matare t where bsflag='0' and t.project_info_no='" + projectInfoNo + "'  and  (t.if_change!='2' and t.if_delete_change is null) order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取震源设备租赁信息预算调整
	 */
	public ISrvMsg getMataxiAdjustOtherInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.plan_end_date-t.plan_start_date+1 date_num ,");
		sql.append(" t.*,t.dev_count*t.taxi_unit*(t.plan_end_date-t.plan_start_date+1) mataxi_price ,");
		sql.append(" case t.dev_name when '0' then '动迁时间' when '1' then '租赁时间' when '2' then '遣散时间' "+
		" when '3' then '待工时间' when '4' then '交回验收时间' when '5' then '超计划占用时间' else'' end dev_name1,");
		sql.append(" decode(t.if_change,'1','变更数据','非变更数据') change_data, ");
		sql.append(" '震源' mataxi_type_name,");
		sql.append(" to_char(t.dev_count*t.taxi_unit*((t.plan_end_date-t.plan_start_date+1)-nvl(t.passive_date,0))*t.taxi_ratio,'9999999999999999.99') manage_price ");
		sql.append(" from bgp_op_target_device_mataxi t where bsflag='0' and t.project_info_no='" + projectInfoNo
				+ "' and t.mataxi_type ='4'  and  (t.if_change!='2' and t.if_delete_change is null) order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取测量设备租赁信息
	 */
	public ISrvMsg getMeasureAdjustInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.*,decode(t.surface_type,'1','有作物农田、浮土地','2','无作物农田、戈壁、平原','3','山地Ⅰ类','4','山地Ⅱ类',5,'山地Ⅲ类','6','沙漠(小沙)','7','沙漠(大沙)','8','水网、沼泽') surface_type_name,");
		sql.append(" decode(t.if_change,'1','变更数据','非变更数据') change_data, ");
		sql.append(" to_char((nvl(t.detector_line,0)+nvl(bomb_line,0))*measure_price*nvl(measure_ratio,0),'9999999999999999.99') sum_price ");
		sql.append(" from bgp_op_tartet_device_measure t where bsflag='0' and t.project_info_no='" + projectInfoNo
				+ "' and  (t.if_change!='2' and t.if_delete_change is null) order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取测量辅助费用预算调整信息
	 */
	public ISrvMsg getMeassistAdjustInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.*,decode(t.if_change,'1','变更数据','非变更数据') change_data ");
		sql.append(" from bgp_op_tartet_device_meassist t where bsflag='0' and  (t.if_change!='2' and t.if_delete_change is null) and t.project_info_no='" + projectInfoNo
				+ "' order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取租赁设备费用预算调整信息
	 */
	public ISrvMsg getDerentAdjustInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer(
				"select decode(t.if_change,'1','变更数据','非变更数据') change_data,t.*,to_char((t.Plan_End_Date-T.PLAN_START_DATE+1)*T.DERENT_MONEY*t.DERENT_COUNT,'9999999999999999.99') SUM_DERENT ,t.Plan_End_Date-T.PLAN_START_DATE+1 day_num ");
		sql.append(" from bgp_op_cost_tartet_derent t where bsflag='0' and (t.if_delete_change !='1' or t.if_delete_change is null) and t.project_info_no='" + projectInfoNo
				+ "' order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取动迁、运输费费用信息
	 */
	public ISrvMsg getTransportAdjustInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer(
				"select decode(t.if_change,'1','变更数据','非变更数据') change_data,t.*,to_char(t.tonnage*t.transport_count*t.transport_unit*(nvl(t.start_meter,0)+nvl(t.back_meter,0)),'9999999999999999.99') sum_transport ");
		sql.append(" from BGP_OP_COST_TARTET_TRANSPORT t where bsflag='0' and transport_type = '0' and (t.if_delete_change !='1' or t.if_delete_change is null) and t.project_info_no='"
				+ projectInfoNo + "' order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取动迁、运输费费用信息
	 */
	public ISrvMsg getTransportAdjustOtherInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer(
				"select decode(t.if_change,'1','变更数据','非变更数据') change_data,t.*,to_char(t.tonnage*t.transport_count*t.transport_unit*(nvl(t.start_meter,0)+nvl(t.back_meter,0)),'9999999999999999.99') sum_transport ");
		sql.append(" from BGP_OP_COST_TARTET_TRANSPORT t where bsflag='0' and transport_type = '1'  and (t.if_delete_change !='1' or t.if_delete_change is null) and t.project_info_no='"
				+ projectInfoNo + "' order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取劳保费用信息
	 */
	public ISrvMsg getLabormonAdjustInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer(
				"select t.*,to_char(t.person_num*t.person_money,'9999999999999999.99') sum_labormon ,decode(t.if_change,'1','变更数据','非变更数据') change_data ");
		sql.append(" from BGP_OP_COST_TARTET_LABORMON t where bsflag='0' and (t.if_delete_change !='1' or t.if_delete_change is null) and t.project_info_no='" + projectInfoNo
				+ "' order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}
	
	/*
	 * 获取安全设施投入费用信息
	 */
	public ISrvMsg getHseAdjustInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select decode(t.if_change,'1','变更数据','非变更数据') change_data,t.*,to_char(t.hse_unit*(t.hse_count_t),'9999999999999999.99') hse_money ");
		sql.append(" from BGP_OP_COST_TARTET_HSE t where bsflag='0' and (t.if_delete_change !='1' or t.if_delete_change is null) and t.project_info_no='" + projectInfoNo
				+ "' order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}
	
	/*
	 * 获取设备折旧费用信息
	 */
	public ISrvMsg getDeviceActualDepreInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			Map map = OPCommonUtil.getProjectDate(projectInfoNo);
			//String start_date = map==null || map.get("planned_start_date")==null?df.format(new Date()):(String)map.get("planned_start_date");
			String end_date = map==null || map.get("planned_finish_date")==null?df.format(new Date()):(String)map.get("planned_finish_date");
			// 读取设备费用信息
			StringBuffer queryDeviceCost = new StringBuffer(
					"select td.dev_name,td.dev_model,da.self_num,da.asset_coding,da.license_num,da.turn_num,td.dev_acc_id,nvl(td.device_count,1) device_count,td.target_depre_id,sd.coding_name dev_team,td.dev_sign, ");
			queryDeviceCost.append(" td.plan_start_date,td.plan_end_date,nvl(td.actual_end_date,to_date('"+end_date+"','yyyy-MM-dd')) - td.actual_start_date+1 as date_num, ");
			queryDeviceCost.append(" td.actual_start_date,td.actual_end_date,td.asset_value,td.depreciation_value, ");
			queryDeviceCost.append(" decode(td.if_change,'1','变更数据','非变更数据') change_data,to_char(td.change_date,'yyyy-MM-dd') change_date, ");
			queryDeviceCost.append(" to_char(decode(td.depreciation_value,0,0,td.asset_value*0.97/td.depreciation_value/8),'9999999999999999.99') sum_month_depreciation, ");
			queryDeviceCost.append(" to_char(decode(td.depreciation_value,0,0,td.asset_value*0.97/td.depreciation_value/8*td.device_count/30*(nvl(td.actual_end_date,to_date('"+end_date+"','yyyy-MM-dd'))-nvl(da.actual_in_time,td.actual_start_date)+1)),'9999999999999999.99') sum_depreciation ");
			queryDeviceCost.append(" from bgp_op_tartet_device_depre td  left outer join gms_device_account_dui da on td.dev_acc_id = da.dev_acc_id and td.PROJECT_INFO_NO=da.PROJECT_INFO_ID ");
			queryDeviceCost.append(" left outer join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id ");
			queryDeviceCost.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo + "' and td.record_type = '0' and td.if_change='2' ");

			String teamName = reqDTO.getValue("teamName");
			String devSign = reqDTO.getValue("devSign");
			String devName = reqDTO.getValue("devName");
			String devSelf = reqDTO.getValue("devSelf");
			String licenseNum = reqDTO.getValue("licenseNum");
			String assetCoding = reqDTO.getValue("assetCoding");
			if (teamName != null) {
				queryDeviceCost.append(" and sd.coding_name like '%" + teamName + "%'");
			}
			if (devSign != null) {
				queryDeviceCost.append(" and da.dev_sign like '%" + devSign + "%'");
			}
			if (devName != null) {
				queryDeviceCost.append(" and da.dev_name like '%" + devName + "%'");
			}
			if (devSelf != null) {
				queryDeviceCost.append(" and da.self_num like '%" + devSelf + "%'");
			}
			if (licenseNum != null) {
				queryDeviceCost.append(" and da.license_num like '%" + licenseNum + "%'");
			}
			if (assetCoding != null) {
				queryDeviceCost.append(" and da.asset_coding like '%" + assetCoding + "%'");
			}

			queryDeviceCost.append(" order by td.create_date ");

			OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, queryDeviceCost.toString());
		}
		return responseDTO;
	}

	/*
	 * 获取项目实际费用信息，返回json串
	 */
	public ISrvMsg getCostActualProject(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String costType = reqDTO.getValue("costType");
		if (costType == null || "".equals(costType)) {
			costType = OPCommonUtil.getCostTypeOfTargetProject(projectInfoNo);
		}
		String ifcheck = reqDTO.getValue("ifcheck");
		StringBuffer sqlBuffer = new StringBuffer("select connect_by_root(vs.gp_target_project_id) root,level,decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf, ");
		sqlBuffer.append(" sys_connect_by_path(substr(vs.node_code, 0, length(vs.node_code) - 3) || lpad(vs.order_code + 1, 3, '0'), '/') path, ");
		sqlBuffer.append(" vs.*,vs.gp_target_project_id gp_cost_temp_id,vs.parent_id zip ");
		sqlBuffer.append(" from (select vs.*, nvl(vs.spare3,nvl(vs.formula_content_a,vs.formula_content)) formula,case wf.proc_status when '3' then vf.cost_detail_money else 0 end cost_detail_money_plan," );
		sqlBuffer.append(" case wf.proc_status when '3' then vf.cost_detail_money else 0 end - nvl(vs.cost_detail_money,0) cost_detail_money_plus, nvl(vs.formula_content_a,vs.formula_content) cost_detail_desc from view_op_target_actual_money_s vs ");
		sqlBuffer.append(" inner join view_op_target_plan_money_s vf on vs.gp_target_project_id = vf.gp_target_project_id and ");
		sqlBuffer.append(" vs.project_info_no = '" + projectInfoNo + "' left join common_busi_wf_middle wf on vf.project_info_no = wf.business_id and wf.bsflag ='0' and wf.busi_table_name ='BGP_OP_TARGET_PROJECT_INFO' and wf.business_type ='5110000004100000014') vs ");
		sqlBuffer.append(" where vs.project_info_no = '" + projectInfoNo + "' ");
		sqlBuffer.append(" start with vs.parent_id = '" + costType + "' connect by prior vs.gp_target_project_id = vs.parent_id order by path asc");
		List<Map> list = jdbcDao.queryRecords(sqlBuffer.toString());

		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list != null ? list.size() : 0);

		responseDTO.setValue("pageCount", "1");
		responseDTO.setValue("pageSize", "0");
		responseDTO.setValue("currentPage", "1");

		// 获取项目名称

		String projectName = OPCommonUtil.getProjectNameByProjectInfoNo(projectInfoNo);
		Map map = new HashMap();
		map.put("gpCostTempId", costType);
		map.put("parentId", "root");
		map.put("costName", projectName);
		map.put("costDesc", "");
		map.put("expanded", "true");

		Map jsonMap = new HashMap();
		if ("true".equals(ifcheck)) {
			jsonMap = OPCommonUtil.convertListTreeToJsonCheck(list, "gpCostTempId", "parentId", map);
		} else {
			jsonMap = OPCommonUtil.convertListTreeToJson(list, "gpCostTempId", "parentId", map);
		}

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		responseDTO.setValue("basicId", OPCommonUtil.getTargetProjectBasicId(projectInfoNo));
		return responseDTO;
	}

	/*
	 * 获取项目实际费用信息，返回json串getCostNFormulaActualProject
	 */
	public ISrvMsg getCostNFormulaActualProject(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String costType = reqDTO.getValue("costType");
		if (costType == null || "".equals(costType)) {
			costType = OPCommonUtil.getCostTypeOfTargetProject(projectInfoNo);
		}
		String ifcheck = reqDTO.getValue("ifcheck");
		StringBuffer sqlBuffer = new StringBuffer("select connect_by_root(gp_cost_temp_id) root,level,decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf, ");
		sqlBuffer.append(" sys_connect_by_path(substr(node_code,0,length(node_code)-3)||lpad(order_code+1,3,'0'), '/') path,cost_name,cost_desc,gp_cost_temp_id,parent_id, ");
		sqlBuffer.append(" parent_id zip,order_code,cost_detail_money,cost_detail_desc ");
		sqlBuffer.append(" from (select cp.gp_target_project_id gp_cost_temp_id,cp.cost_name,cp.cost_desc,cp.parent_id,cp.order_code, ");
		sqlBuffer.append(" cp.formula_content cost_detail_desc,pm.cost_detail_money,cp.node_code ");
		sqlBuffer.append(" from view_op_target_actual_other cp ");
		sqlBuffer.append(" left join bgp_op_target_project_detail pd on cp.gp_target_project_id = pd.gp_target_project_id and pd.bsflag = '0' ");
		sqlBuffer.append(" left outer join ( select pi.*,(select sum(pd.cost_detail_money) from (select n.project_info_no, m.cost_detail_money, n.node_code ");
		sqlBuffer
				.append(" from bgp_op_target_project_info n left outer join bgp_op_actual_project_detail m on m.gp_target_project_id = n.gp_target_project_id and m.bsflag = '0'  and n.bsflag = '0') pd ");
		sqlBuffer.append(" where pd.project_info_no = pi.project_info_no and pd.node_code like concat(pi.node_code, '%')) cost_detail_money ");
		sqlBuffer.append(" from bgp_op_target_project_info pi where pi.project_info_no = '" + projectInfoNo + "') pm ");
		sqlBuffer.append(" on cp.gp_target_project_id = pm.gp_target_project_id  ");
		sqlBuffer.append(" where cp.bsflag = '0' and cp.project_info_no = '" + projectInfoNo + "') ");
		sqlBuffer.append(" start with parent_id = '" + costType + "' connect by prior gp_cost_temp_id = parent_id  order by path asc");

		List<Map> list = jdbcDao.queryRecords(sqlBuffer.toString());

		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list != null ? list.size() : 0);

		responseDTO.setValue("pageCount", "1");
		responseDTO.setValue("pageSize", "0");
		responseDTO.setValue("currentPage", "1");

		// 获取项目名称

		String projectName = OPCommonUtil.getProjectNameByProjectInfoNo(projectInfoNo);
		Map map = new HashMap();
		map.put("gpCostTempId", costType);
		map.put("parentId", "root");
		map.put("costName", projectName);
		map.put("costDesc", "");
		map.put("expanded", "true");

		Map jsonMap = new HashMap();
		if ("true".equals(ifcheck)) {
			jsonMap = OPCommonUtil.convertListTreeToJsonCheck(list, "gpCostTempId", "parentId", map);
		} else {
			jsonMap = OPCommonUtil.convertListTreeToJson(list, "gpCostTempId", "parentId", map);
		}

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		responseDTO.setValue("basicId", OPCommonUtil.getTargetProjectBasicId(projectInfoNo));
		return responseDTO;
	}

	/*
	 * 获取设备实际成本反馈信息预算调整
	 */
	public ISrvMsg getMataxiActualInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		StringBuffer sql = new StringBuffer("select  nvl(t.actual_end_date, to_date(to_char(sysdate, 'yyyy-MM-dd'),'yyyy-MM-dd'))-t.actual_start_date+1 date_num_2 ,");
		sql.append(" t.*,t.dev_count*t.taxi_unit*(nvl(t.actual_end_date, to_date(to_char(sysdate, 'yyyy-MM-dd'),'yyyy-MM-dd'))-t.actual_start_date+1)*t.taxi_ratio manage_price_2 ,");
		sql.append(" case t.dev_name when '0' then '动迁时间' when '1' then '租赁时间' when '2' then '遣散时间' "+
		" when '3' then '待工时间' when '4' then '交回验收时间' when '5' then '超计划占用时间' else'' end dev_name1,");
		sql.append(" decode(t.if_change,'1','变更数据','非变更数据') change_data, ");
		sql.append(" decode(t.mataxi_type,'1','仪器','2','运载设备','3','专用工具','') mataxi_type_name,");
		sql.append(" to_char(t.dev_count*t.taxi_unit*(t.plan_end_date-t.plan_start_date+1)*t.taxi_ratio,'9999999999999999.99') manage_price  ");
		sql.append(" from bgp_op_target_device_mataxi t where bsflag='0' and t.project_info_no='" + projectInfoNo
				+ "' and t.mataxi_type !='4' and t.if_delete_change is null and  t.if_actual_change is null order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取专用工具修理费实际成本反馈信息预算调整
	 */
	public ISrvMsg getMatareActualInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select   t.*,t.dev_count*t.taxi_unit sum_price,to_char(t.update_date,'yyyy-MM-dd') mataxi_date ");
		sql.append(" from bgp_op_target_device_matare t where bsflag='0' and t.mataxi_type ='0' and t.project_info_no='" + projectInfoNo
				+ "'  and t.if_delete_change is null and t.if_actual_change is null order by t.dev_name asc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取震源设备实际成本反馈信息预算调整
	 */
	public ISrvMsg getShocksActualInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select nvl(t.actual_end_date, to_date(to_char(sysdate, 'yyyy-MM-dd'),'yyyy-MM-dd'))-t.actual_start_date+1 date_num_2 ,");
		sql.append(" t.*,t.dev_count*t.taxi_unit*( nvl(t.taxi_ratio,0))*((nvl(t.actual_end_date, to_date(to_char(sysdate, 'yyyy-MM-dd'),'yyyy-MM-dd')) - t.actual_start_date+1)-nvl(t.passive_date,0)) manage_price_2,");
		sql.append(" case t.dev_name when '0' then '动迁时间' when '1' then '租赁时间' when '2' then '遣散时间' "+
		" when '3' then '待工时间' when '4' then '交回验收时间' when '5' then '超计划占用时间' else'' end dev_name1,");
		sql.append(" decode(t.if_change,'1','变更数据','非变更数据') change_data, ");
		sql.append(" '震源' mataxi_type_name from bgp_op_target_device_mataxi t where bsflag='0' and t.project_info_no='" + projectInfoNo
				+ "' and t.mataxi_type ='4' and t.if_delete_change is null and  t.if_actual_change is null order by t.create_date desc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 保存目标预算变更信息
	 */
	public ISrvMsg saveTargetActualInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		Map map = reqDTO.toMap();
		String ifChange = (String) map.get("if_change");
		String jcdpTableId = (String) map.get("JCDP_TABLE_ID");
		String tableId = (String) map.get("tableId");
		String tableName = (String) map.get("JCDP_TABLE_NAME");

		if (jcdpTableId == null) {// 新增
			map.put("if_change", "2");
			pureDao.saveOrUpdateEntity(map, tableName);
		} else {
			if ("2".equals(ifChange)) {// 实际数据的修改
				pureDao.saveOrUpdateEntity(map, tableName);
			} else {// 原始计划数据的修改
				String sql = "select * from " + tableName + " where " + tableId + "='" + jcdpTableId + "'";
				Map mapDate = pureDao.queryRecordBySQL(sql);
				mapDate.remove("if_actual_change");
				mapDate.put("if_actual_change", "1");
				pureDao.saveOrUpdateEntity(mapDate, tableName);
				map.put("if_change", "2");
				map.remove(tableId);
				map.remove("JCDP_TABLE_ID");
				map.put("dev_acc_id", mapDate.get("dev_acc_id"));
				map.put("self_num", mapDate.get("self_num"));
				map.put("dev_sign", mapDate.get("dev_sign"));
				pureDao.saveOrUpdateEntity(map, tableName);
			}
		}
		return responseDTO;
	}

	/*
	 * 获取动迁、运输费实际费用信息
	 */
	public ISrvMsg getTransportActualInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer(
				"select decode(t.if_change,'1','变更数据','非变更数据') change_data,t.*,t.tonnage*t.transport_count*t.transport_unit*(nvl(t.start_meter,0)+nvl(t.back_meter,0)) sum_transport ");
		sql.append(" from BGP_OP_COST_TARTET_TRANSPORT t where bsflag='0' and  t.if_change='2' and t.project_info_no='" + projectInfoNo + "' order by t.spare4 asc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取长期待摊实际费用信息
	 */
	public ISrvMsg getDeviceActualDepreOtherInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			// 读取设备费用信息
			StringBuffer queryDeviceCost = new StringBuffer("select td.dev_name,td.dev_model,td.dev_acc_id,td.target_depre_id, ");
			queryDeviceCost
					.append(" td.plan_start_date,td.plan_end_date,nvl(td.actual_end_date, to_date(to_char(sysdate, 'yyyy-MM-dd'),'yyyy-MM-dd')) - td.actual_start_date+1 as date_num, ");
			queryDeviceCost.append(" td.actual_start_date,td.actual_end_date,td.asset_value,td.depreciation_value, ");
			queryDeviceCost.append(" decode(td.if_change,'1','变更数据','非变更数据') change_data, td.device_count,");
			queryDeviceCost.append(" to_char(decode(td.depreciation_value,0,0,td.device_count*td.asset_value*0.97/td.depreciation_value/8),'9999999999999999.99') sum_month_depreciation, ");
			queryDeviceCost
					.append(" to_char(decode(td.depreciation_value,0,0,td.device_count*td.asset_value*0.97/td.depreciation_value/8*1/30*(nvl(td.actual_end_date, to_date(to_char(sysdate, 'yyyy-MM-dd'),'yyyy-MM-dd'))-td.actual_start_date+1)),'9999999999999999.99') sum_depreciation ");
			queryDeviceCost.append(" from bgp_op_tartet_device_depre td  ");
			queryDeviceCost.append(" where td.bsflag='0' and td.project_info_no = '" + projectInfoNo
					+ "' and td.record_type = '1' and  td.if_delete_change is null and  td.if_actual_change is null order by td.spare4 asc");
			OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, queryDeviceCost.toString());
		}
		return responseDTO;
	}

	/*
	 * 获取测量设备实际成本信息
	 */
	public ISrvMsg getMeasureActualInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.*,decode(t.surface_type,'1','有作物农田、浮土地','2','无作物农田、戈壁、平原','3','山地Ⅰ类','4','山地Ⅱ类',5,'山地Ⅲ类','') surface_type_name,");
		sql.append(" decode(t.if_change,'1','变更数据','非变更数据') change_data, ");
		sql.append(" (t.detector_line+bomb_line)*measure_price sum_price_ss, ");
		sql.append(" (t.detector_line+bomb_line)*measure_price*nvl(measure_ratio,0) sum_price_ma, ");
		sql.append(" (t.detector_line+bomb_line)*measure_price*(1+nvl(measure_ratio,0)) sum_price ");
		sql.append(" from bgp_op_tartet_device_measure t where bsflag='0' and t.project_info_no='" + projectInfoNo
				+ "' and  (t.if_change ='2' and t.if_actual_change is null) order by t.spare4 asc");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 获取测量辅助费用预算调整信息
	 */
	public ISrvMsg getMeassistActualInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer("select t.*,decode(t.if_change,'1','变更数据','非变更数据') change_data ");
		sql.append(" from bgp_op_tartet_device_meassist t where bsflag='0' and t.if_delete_change is null and  t.if_actual_change is null and t.project_info_no='" + projectInfoNo
				+ "' order by t.meassist_name");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	private boolean isNullOrEmpty(Object s) {
		return (s == null || "".equals(s)) ? true : false;
	}

	/*
	 * 获取单价库模板信息，返回json串
	 */

	public ISrvMsg getCostPriceTemplate(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = reqDTO.getValue("costType");

		StringBuffer sqlBuffer = new StringBuffer(
				"select connect_by_root(PRICE_TEMPLATE_ID) root,level,decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(PRICE_TEMPLATE_ID, '/') path, ");
		sqlBuffer.append(" PRICE_TEMPLATE_ID gp_cost_temp_id,PRICE_NAME,PRICE_UNIT,PRICE_TEMPLATE_ID,parent_id,parent_id zip,ORDER_CODE ,price_type,mat_id");
		sqlBuffer.append(" from BGP_OP_PRICE_TEMPLATE_INFO start with parent_id = '01' connect by prior PRICE_TEMPLATE_ID = parent_id order by ORDER_CODE asc ");
		List list = jdbcDao.queryRecords(sqlBuffer.toString());

		Map map = new HashMap();
		map.put("priceTemplateId", costType);
		map.put("parentId", "root");
		map.put("priceName", "东方地球物理公司");
		map.put("priceUnit", "");
		map.put("expanded", "true");
		map.put("zip", "root");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "priceTemplateId", "parentId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}

	/*
	 * 保存模板费用数据
	 */
	public ISrvMsg saveCostPriceTemplateData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String price_template_id = reqDTO.getValue("price_template_id");
		String parent_id = reqDTO.getValue("parent_id");
		String price_name = reqDTO.getValue("price_name");
		String price_unit = reqDTO.getValue("price_unit");
		if (price_name != null && !"".equals(price_name)) {
			price_name = URLDecoder.decode(price_name, "UTF-8");
		}
		if (price_unit != null && !"".equals(price_unit)) {
			price_unit = URLDecoder.decode(price_unit, "UTF-8");
		}
		Map map = reqDTO.toMap();
		map.put("price_name", price_name);
		map.put("price_unit", price_unit);
		map.put("bsflag", "0");

		// 计算order并自动生成编码
		if (price_template_id == null || "".equals(price_template_id)) {
			// 计算自动编码
			String nodeCode = OPCommonUtil.getCodeNodeByAutoGen("bgp_op_price_template_info", "price_template_id", parent_id, "01");
			map.put("node_code", nodeCode);
		}
		pureDao.saveOrUpdateEntity(map, "bgp_op_price_template_info");
		responseDTO.setValue("success", true);
		return responseDTO;
	}

	/*
	 * 获取项目单价库模板信息，返回json串
	 */

	public ISrvMsg getCostPricePrjTemplate(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = reqDTO.getValue("costType");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sqlBuffer = new StringBuffer("select connect_by_root(PRICE_PROJECT_ID) root,level,decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(PRICE_PROJECT_ID, '/') path, ");
		sqlBuffer.append(" PRICE_NAME,PRICE_UNIT,PRICE_PROJECT_ID,parent_id,parent_id zip,ORDER_CODE ,price_type ,mat_id ");
		sqlBuffer.append(" from BGP_OP_PRICE_PROJECT_INFO where project_info_no = '" + projectInfoNo
				+ "' and if_change is null  start with parent_id = '01' connect by prior PRICE_PROJECT_ID = parent_id order by ORDER_CODE ");
		List list = jdbcDao.queryRecords(sqlBuffer.toString());

		Map map = new HashMap();
		map.put("priceProjectId", costType);
		map.put("parentId", "root");
		map.put("priceName", "东方地球物理公司");
		map.put("priceUnit", "");
		map.put("expanded", "true");
		map.put("zip", "root");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "priceProjectId", "parentId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}

	/*
	 * 获取项目单价库模板变更信息，返回json串
	 */

	public ISrvMsg getCostPricePrjAdjustTemplate(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = reqDTO.getValue("costType");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sqlBuffer = new StringBuffer(
				"select connect_by_root(PRICE_PROJECT_ID) root,level,decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(PRICE_PROJECT_ID, '/') path, ");
		sqlBuffer.append(" PRICE_NAME,PRICE_UNIT,PRICE_PROJECT_ID,parent_id,parent_id zip,order_code ");
		sqlBuffer
				.append(" from BGP_OP_PRICE_PROJECT_INFO where bsflag='0' and if_delete_change is null and project_info_no = '" + projectInfoNo+"'  start with parent_id = '01' connect by prior PRICE_PROJECT_ID = parent_id order by order_code asc ");
		List list = jdbcDao.queryRecords(sqlBuffer.toString());

		Map map = new HashMap();
		map.put("priceProjectId", costType);
		map.put("parentId", "root");
		map.put("priceName", "东方地球物理公司");
		map.put("priceUnit", "");
		map.put("expanded", "true");
		map.put("zip", "root");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "priceProjectId", "parentId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}

	/*
	 * 保存项目单价库费用数据(从模板导入的情况)
	 */
	public ISrvMsg saveCostPricePrjByTemplate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = reqDTO.getValue("costType");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			String sqlDelete = "delete from  bgp_op_price_project_info  where project_info_no='" + projectInfoNo + "'";
			jdbcTemplate.execute(sqlDelete);
			String sqlInsert = "insert into bgp_op_price_project_info (price_project_id,PRICE_TEMPLATE_ID,project_info_no,node_code,PRICE_NAME,PRICE_UNIT,parent_id,create_date,bsflag,price_type,mat_id) "
					+ "(select   SYS_GUID () AS key_id,PRICE_TEMPLATE_ID,'"
					+ projectInfoNo
					+ "',node_code,PRICE_NAME,PRICE_UNIT,parent_id,sysdate,'0',price_type,mat_id from BGP_OP_PRICE_TEMPLATE_INFO where bsflag='0')";
			jdbcTemplate.execute(sqlInsert);
			String sqlUpdate = "update bgp_op_price_project_info t set t.parent_id =(select p.price_project_id from bgp_op_price_project_info p where p.PRICE_TEMPLATE_ID=t.parent_id and p.project_info_no=t.project_info_no ) where project_info_no = '"
					+ projectInfoNo + "'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_op_price_project_info t set t.parent_id='" + costType + "' where parent_id is null and   project_info_no = '" + projectInfoNo + "'";
			jdbcTemplate.execute(sqlUpdate);
		}
		return responseDTO;
	}

	/*
	 * 保存项目单价库费用数据(只导入变化后的数据)
	 */
	public ISrvMsg saveCostPricePrjByTemplateChange(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = reqDTO.getValue("costType");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			StringBuilder sqlUpdateTable =new StringBuilder("update  bgp_op_price_project_info  t set  ");
			sqlUpdateTable.append(" t.order_code=(select max(order_code) from bgp_op_price_template_info p  where t.price_template_id = p.price_template_id), ");
			sqlUpdateTable.append(" t.price_name=(select max(price_name) from bgp_op_price_template_info p  where t.price_template_id = p.price_template_id), ");
			sqlUpdateTable.append(" t.price_type=(select price_type from bgp_op_price_template_info p  where t.price_template_id = p.price_template_id), ");
			sqlUpdateTable.append(" t.mat_id=(select mat_id from bgp_op_price_template_info p  where t.price_template_id = p.price_template_id), ");
			sqlUpdateTable.append(" t.parent_id=(select max(parent_id) from bgp_op_price_template_info p  where t.price_template_id = p.price_template_id) ");
			sqlUpdateTable.append(" where t.project_info_no='" + projectInfoNo + "' ");
			jdbcTemplate.execute(sqlUpdateTable.toString());
			String sqlInsert = "insert into bgp_op_price_project_info (price_project_id,PRICE_TEMPLATE_ID,project_info_no,node_code,PRICE_NAME,PRICE_UNIT,parent_id,create_date,bsflag ,price_type,mat_id) "
					+ "(select   SYS_GUID () AS key_id,PRICE_TEMPLATE_ID,'"
					+ projectInfoNo
					+ "',node_code,PRICE_NAME,PRICE_UNIT,parent_id,sysdate,'0',price_type ,mat_id from BGP_OP_PRICE_TEMPLATE_INFO where bsflag='0'"
					+ " and price_template_id not in (select price_template_id from bgp_op_price_project_info where project_info_no='" + projectInfoNo + "' )) ";
			jdbcTemplate.execute(sqlInsert);
			String sqlUpdate = "update bgp_op_price_project_info t set t.parent_id =(select p.price_project_id from bgp_op_price_project_info p where p.PRICE_TEMPLATE_ID=t.parent_id and p.project_info_no=t.project_info_no ) where project_info_no = '"
					+ projectInfoNo + "'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_op_price_project_info t set t.parent_id='" + costType + "' where parent_id is null and   project_info_no = '" + projectInfoNo + "'";
			jdbcTemplate.execute(sqlUpdate);
		}
		return responseDTO;
	}
	
	
	/*
	 * 上传报表文档
	 */
	public ISrvMsg saveNStructReportFile(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> files = mqMsg.getFiles();
		UserToken user = reqDTO.getUserToken();
		String id = reqDTO.getValue("id");
		if (files != null && files.size() > 0 && id != null) {
			WSFile file = files.get(0);
			MyUcm ucm = new MyUcm();
			String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
			String updateSql = "update BGP_OP_NSTRUCT_REPORT set ucm_id = '" + ucmDocId + "' where NSTRUCT_REPORT_ID='" + id + "'";
			jdbcTemplate.execute(updateSql);

			// 解析结构化数据
			String sql = " select report_date,report_type from BGP_OP_NSTRUCT_REPORT where NSTRUCT_REPORT_ID='" + id + "'";
			Map map = jdbcDao.queryRecordBySQL(sql);
			if (map != null) {
				String reportDate = (String) map.get("reportDate");
				String reportType = (String) map.get("reportType");
				if (reportDate != null && reportType != null) {
					switch (reportType.charAt(0)) {
					case '0':
						break;
					case '1':
						break;
					case '2':// 辅助生产单位经营状况表7,2
						List<Map> list2 = OPCommonUtil.getDataBlockFromExcel(file, 1, 6, 5, reportType, reportDate, user);
						String deleteSql2 = "update BGP_OP_REPORT_STRUCT_DATA set bsflag='1' where cost_type='" + reportType + "' and to_char(report_date,'yyyy-MM') =to_char('"
								+ reportDate + "','yyyy-MM')";
						jdbcTemplate.execute(deleteSql2);
						OPCommonUtil.saveListDataInfoByTableName(list2, "BGP_OP_REPORT_STRUCT_DATA");
						break;
					case '3':// 机关及附属单位费用支出表7,2
						List<Map> list3 = OPCommonUtil.getDataBlockFromExcel(file, 1, 6, 5, reportType, reportDate, user);
						String deleteSql3 = "update BGP_OP_REPORT_STRUCT_DATA set bsflag='1' where cost_type='" + reportType + "' and to_char(report_date,'yyyy-MM') =to_char('"
								+ reportDate + "','yyyy-MM')";
						jdbcTemplate.execute(deleteSql3);
						OPCommonUtil.saveListDataInfoByTableName(list3, "BGP_OP_REPORT_STRUCT_DATA");
						break;
					case '4':// 非施工期费用支出表
						List<Map> list4 = OPCommonUtil.getDataBlockFromExcel(file, 1, 6, 5, reportType, reportDate, user);
						String deleteSql4 = "update BGP_OP_REPORT_STRUCT_DATA set bsflag='1' where cost_type='" + reportType + "' and to_char(report_date,'yyyy-MM') =to_char('"
								+ reportDate + "','yyyy-MM')";
						jdbcTemplate.execute(deleteSql4);
						OPCommonUtil.saveListDataInfoByTableName(list4, "BGP_OP_REPORT_STRUCT_DATA");
						break;
					default:
						break;
					}

				}
			}
		}
		return responseDTO;

	}

	/*
	 * 获取公式基础信息，返回json串
	 */

	public ISrvMsg getCostFormulaData(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sqlBuffer = new StringBuffer("select price_template_id,connect_by_root(price_template_id) root,level, ");
		sqlBuffer.append(" decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(price_template_id, '/') path, ");
		sqlBuffer.append(" PRICE_NAME,parent_id,parent_id zip ");
		sqlBuffer.append(" from (select ti.price_template_id, ti.price_name, ti.parent_id from bgp_op_price_template_info ti ");
		sqlBuffer.append(" union select fd.formula_data_id, fd.item_name, fd.parent_id from bgp_op_formula_data fd) t ");
		sqlBuffer.append(" start with t.parent_id = 's' connect by prior t.price_template_id = t.parent_id ");
		List list = jdbcDao.queryRecords(sqlBuffer.toString());

		Map map = new HashMap();
		map.put("priceTemplateId", "s");
		map.put("parentId", "root");
		map.put("priceName", "东方地球物理公司");
		map.put("expanded", "true");
		map.put("zip", "root");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "priceTemplateId", "parentId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}

	/*
	 * 获取公式基础信息，返回json串
	 */

	public ISrvMsg getCostFormulaProjectData(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sqlBuffer = new StringBuffer("select price_template_id,connect_by_root(price_template_id) root,level, ");
		sqlBuffer.append(" decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(price_template_id, '/') path, ");
		sqlBuffer.append(" PRICE_NAME,parent_id,parent_id zip ");
		sqlBuffer.append(" from (select ti.PRICE_PROJECT_ID price_template_id, ti.price_name, ti.parent_id from BGP_OP_PRICE_PROJECT_INFO ti where ti.project_info_no = '"
				+ projectInfoNo + "'");
		sqlBuffer.append(" union select fd.formula_data_id, fd.item_name, fd.parent_id from bgp_op_formula_data fd) t ");
		sqlBuffer.append(" start with t.parent_id = 's' connect by prior t.price_template_id = t.parent_id ");
		List list = jdbcDao.queryRecords(sqlBuffer.toString());

		Map map = new HashMap();
		map.put("priceTemplateId", "s");
		map.put("parentId", "root");
		map.put("priceName", "东方地球物理公司");
		map.put("expanded", "true");
		map.put("zip", "root");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "priceTemplateId", "parentId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}

	/*
	 * 根据公式汇总目标计划成本信息
	 *TODO  目标成本预算
	 */
	public ISrvMsg hzCostPlanByFormula(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		Map<String, Double> mapBasicInfo = new HashMap<String, Double>();
		List<String> list = new ArrayList<String>();
		if (projectInfoNo != null && !"".equals(projectInfoNo)) {
			// 初始化数据
			StringBuffer sqlOil = new StringBuffer(
					"select to_char(sum(decode(td.daily_oil_type, '2', 0, '1',td.oil_unit_price * (nvl(td.daily_oil,0)+nvl(td.single_well_oil,0)) *(td.plan_end_date - td.plan_start_date+1) * nvl(td.device_count,1), 0)),'9999999999999999.99') oil1, ");
			sqlOil.append(" to_char(sum(decode(td.daily_oil_type, '1', 0, '2',td.oil_unit_price * (nvl(td.daily_oil,0)+nvl(td.single_well_oil,0)) *(td.plan_end_date - td.plan_start_date+1) * nvl(td.device_count,1), 0)),'9999999999999999.99') oil2, ");
			sqlOil.append(" to_char(sum(td.daily_small_oil *(td.plan_end_date - td.plan_start_date + 1) * nvl(td.device_count,1)),'9999999999999999.99') oil3 ");
			sqlOil.append(" from bgp_op_tartet_device_oil td ");
			sqlOil.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo + "' and (td.if_change = '0' or td.if_change is null) group by project_info_no ");
			Map mapOil = pureDao.queryRecordBySQL(sqlOil.toString());
			// 汽油S01001006004001001
			double cos006 = 0f;
			String cos006_desc = "见油料费、小油品费用测算表";
			if (mapOil != null) {
				cos006 = (isNullOrEmpty((String) mapOil.get("oil1"))) ? 0f : Double.parseDouble((String) mapOil.get("oil1"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{汽油费}", cos006, cos006_desc, projectInfoNo);
			// 柴油S01001006004001002
			double cos007 = 0f;
			String cos007_desc = "见油料费、小油品费用测算表";
			if (mapOil != null) {
				cos007 = (isNullOrEmpty((String) mapOil.get("oil2"))) ? 0f : Double.parseDouble((String) mapOil.get("oil2"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{柴油费}", cos007, cos007_desc, projectInfoNo);
			// 小油品S01001006004001003001
			double cos008 = 0f;
			String cos008_desc = "见油料费、小油品费用测算表";
			if (mapOil != null) {
				cos008 = (isNullOrEmpty((String) mapOil.get("oil3"))) ? 0f : Double.parseDouble((String) mapOil.get("oil3"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{小油品费}", cos008, cos008_desc, projectInfoNo);

			StringBuffer sqlDepreciation = new StringBuffer(
					"select to_char(sum(decode(td.depreciation_value,0,0,td.asset_value * 0.97 / td.depreciation_value / 8 * 1 / 30 *(td.plan_end_date - td.plan_start_date + 1)*td.device_count)),'9999999999999999.99') sum_depreciation ");
			sqlDepreciation.append(" from BGP_OP_TARTET_DEVICE_DEPRE td ");
			sqlDepreciation.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo
					+ "' and td.record_type='0' and (td.if_change = '0' or td.if_change is null) group by project_info_no ");
			Map mapDepreciation = pureDao.queryRecordBySQL(sqlDepreciation.toString());
			// 折旧费S01001004002002
			double cos015 = 0f;
			String cos015_desc = "见设备折旧费用测算表";
			if (mapDepreciation != null) {
				cos015 = (isNullOrEmpty((String) mapDepreciation.get("sum_depreciation"))) ? 0f : Double.parseDouble((String) mapDepreciation.get("sum_depreciation"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{折旧费费}", cos015, cos015_desc, projectInfoNo);

			// 长期待摊费用S01001004002001
			StringBuffer sqlDepreciationOther = new StringBuffer(
					"select to_char(sum(decode(td.depreciation_value,0,0,td.asset_value * 0.97 / td.depreciation_value / 8 * 1 / 30 *(td.plan_end_date - td.plan_start_date + 1)*td.device_count)),'9999999999999999.99') sum_depreciation ");
			sqlDepreciationOther.append(" from BGP_OP_TARTET_DEVICE_DEPRE td ");
			sqlDepreciationOther.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo
					+ "' and td.record_type='1' and (td.if_change = '0' or td.if_change is null) group by project_info_no ");
			Map mapDepreciationOther = pureDao.queryRecordBySQL(sqlDepreciationOther.toString());
			double cos016 = 0f;
			String cos016_desc = "见长期待摊费用测算表";
			if (mapDepreciationOther != null) {
				cos016 = (isNullOrEmpty((String) mapDepreciationOther.get("sum_depreciation"))) ? 0f : Double.parseDouble((String) mapDepreciationOther.get("sum_depreciation"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{长期待摊费}", cos016, cos016_desc, projectInfoNo);

			StringBuffer sqlMaterial = new StringBuffer("select   sum(td.restore_repails) restore_repails ,");
			sqlMaterial.append(" to_char(sum(td.vehicle_daily_material *(td.plan_end_date - td.plan_start_date + 1) *td.device_count),'9999999999999999.99') sum_vehicle_daily_material, ");
			sqlMaterial.append(" to_char(sum(td.drilling_daily_material *(td.plan_end_date - td.plan_start_date + 1) *td.device_count),'9999999999999999.99') sum_drilling_daily_material ");
			sqlMaterial.append(" from bgp_op_tartet_device_material td ");
			sqlMaterial.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo + "' and (td.if_change = '0' or td.if_change is null) group by project_info_no ");
			Map mapMaterial = pureDao.queryRecordBySQL(sqlMaterial.toString());
			// 汽车材料S01001004001002
			double cos017 = 0f;
			String cos017_desc = "见设备材料、恢复性修理费测算表";
			if (mapMaterial != null) {
				cos017 = (isNullOrEmpty((String) mapMaterial.get("sum_vehicle_daily_material"))) ? 0f : Double.parseDouble((String) mapMaterial.get("sum_vehicle_daily_material"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{汽车材料费}", cos017, cos017_desc, projectInfoNo);
			// 钻机材料S01001004001003
			double cos018 = 0f;
			String cos018_desc = "见设备材料、恢复性修理费测算表";
			if (mapMaterial != null) {
				cos018 = (isNullOrEmpty((String) mapMaterial.get("sum_drilling_daily_material"))) ? 0f : Double
						.parseDouble((String) mapMaterial.get("sum_drilling_daily_material"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{钻机材料费}", cos018, cos018_desc, projectInfoNo);

			// 恢复性修理费用S01001004001004001
			double cos019 = 0f;
			String cos019_desc = "见设备材料、恢复性修理费测算表";
			if (mapMaterial != null) {
				cos019 = (isNullOrEmpty((String) mapMaterial.get("restore_repails"))) ? 0f : Double.parseDouble((String) mapMaterial.get("restore_repails"));
			}

			// 汽车恢复性修理费用S01001004001004003
			double cos020 = 0f;
			String cos020_desc = "见设备材料、恢复性修理费测算表";
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{钻机恢复性修理费}", cos020, cos020_desc, projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{汽车恢复性修理费}", cos019, cos019_desc, projectInfoNo);

			StringBuffer sqlMataxi = new StringBuffer("select sum(decode(t.mataxi_type,'1',to_char((t.plan_end_date - t.plan_start_date + 1) *t.taxi_ratio,'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price1, ");
			sqlMataxi.append(" sum(decode(t.mataxi_type,'2',to_char((t.plan_end_date - t.plan_start_date + 1) *t.taxi_ratio,'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price2, ");
			sqlMataxi.append(" sum(decode(t.mataxi_type,'3',to_char((t.plan_end_date - t.plan_start_date + 1) *t.taxi_ratio,'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price3, ");
			sqlMataxi.append(" sum(decode(t.mataxi_type,'4',to_char((t.plan_end_date - t.plan_start_date + 1-nvl(t.passive_date,0)) *t.taxi_ratio,'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price4 ");
			sqlMataxi.append(" from bgp_op_target_device_mataxi t ");
			sqlMataxi.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_change = '0' or t.if_change is null)  ");
			Map mapMataxi = pureDao.queryRecordBySQL(sqlMataxi.toString());

			StringBuffer sqlMatare = new StringBuffer("select to_char(sum(t.taxi_unit * (t.dev_count)),'9999999999999.00') sum_money from BGP_OP_TARGET_DEVICE_MATARE t ");
			sqlMatare.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_change = '0' or t.if_change is null) ");
			Map mapMatare = pureDao.queryRecordBySQL(sqlMatare.toString());

			// 仪器租用费S01001004004002004
			double cos022 = 0f;
			String cos022_desc = "见仪器、专用工具租赁费测算表";
			if (mapMataxi != null) {
				cos022 = (isNullOrEmpty((String) mapMataxi.get("sum_price1"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price1"));
			}
			StringBuffer sb = new StringBuffer("select nvl(sum(nvl(t.person_num,0)*nvl(t.person_money,0)+nvl(other_money,0)),0) total_money ")
			.append(" from bgp_op_target_device_hum t where bsflag='0' and t.if_change ='0' and t.transport_type ='1' ")
			.append(" and t.project_info_no ='").append(projectInfoNo).append("' ");
			Map human = pureDao.queryRecordBySQL(sb.toString());
			if(human!=null){
				double temp = 0;
				temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
				cos022 = cos022 + temp ;
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{仪器租用费}", cos022, cos022_desc, projectInfoNo);
			// 专用工具租赁费(维修费)S01001004004002001
			double cos023 = 0f;
			String cos023_desc = "见仪器、专用工具租赁费测算表";
			if (mapMataxi != null) {
				cos023 = (isNullOrEmpty((String) mapMataxi.get("sum_price3"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price3"));
			}
			if (mapMatare != null) {
				cos023 += (isNullOrEmpty((String) mapMatare.get("sum_money"))) ? 0f : Double.parseDouble((String) mapMatare.get("sum_money"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{专用工具租用费}", cos023, cos023_desc, projectInfoNo);
			// 震源租用费S01001004004002005
			double cos024 = 0f;
			String cos024_desc = "见震源租赁费测算表";
			if (mapMataxi != null) {
				cos024 = (isNullOrEmpty((String) mapMataxi.get("sum_price4"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price4"));
			}
			sb = new StringBuffer("select nvl(sum(nvl(t.person_num,0)*nvl(t.person_money,0)+nvl(other_money,0)),0) total_money ")
			.append(" from bgp_op_target_device_hum t where bsflag='0' and t.if_change ='0' and t.transport_type ='0' ")
			.append(" and t.project_info_no ='").append(projectInfoNo).append("' ");
			human = pureDao.queryRecordBySQL(sb.toString());
			if(human!=null){
				double temp = 0;
				temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
				cos024 = cos024 + temp ;
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{震源租用费}", cos024, cos024_desc, projectInfoNo);

			// 运载设备租用费S01001004004002003
			double cos026 = 0f;
			String cos026_desc = "见仪器、专用工具租赁费测算表";
			if (mapMataxi != null) {
				cos026 = (isNullOrEmpty((String) mapMataxi.get("sum_price2"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price2"));
			}
			sb = new StringBuffer("select nvl(sum(t.device_count*(t.plan_end_date-t.plan_start_date+1)*nvl(t.taxi_unit,0)),0) total_money ")
			.append(" from bgp_op_target_device_rent t where bsflag='0' and (t.if_change = '0' or t.if_change is null) ")
			.append(" and t.project_info_no ='").append(projectInfoNo).append("' ");
			human = pureDao.queryRecordBySQL(sb.toString());
			if(human!=null){
				double temp = 0;
				temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
				cos026 = cos026 + temp ;
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{运载设备费}", cos026, cos026_desc, projectInfoNo);

			// 测量服务费S01001004004002002

			StringBuffer sqlMeasure = new StringBuffer("select sum((nvl(t.detector_line,0) + nvl(bomb_line,0)) * measure_price*nvl(measure_ratio,0)) sum_price ");
			sqlMeasure.append(" from bgp_op_tartet_device_measure t ");
			sqlMeasure.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_change = '0' or t.if_change is null) group by project_info_no ");
			Map mapMeasure = pureDao.queryRecordBySQL(sqlMeasure.toString());

			StringBuffer sqlMeassist = new StringBuffer("select to_char(sum(t.meassist_money),'99999999999999999999.99') meassist_money from bgp_op_tartet_device_meassist t ");
			sqlMeassist.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_change = '0' or t.if_change is null)");
			Map mapMeassist = pureDao.queryRecordBySQL(sqlMeassist.toString());

			double cos025 = 0f;
			String cos025_desc = "见测量服务费测算表";
			double cos025_1 = 0f;
			if (mapMeasure != null) {
				cos025_1 = (isNullOrEmpty((String) mapMeasure.get("sum_price"))) ? 0f : Double.parseDouble((String) mapMeasure.get("sum_price"));
			}
			double cos025_2 = 0f;
			if (mapMeassist != null) {
				cos025_2 = (isNullOrEmpty((String) mapMeassist.get("meassist_money"))) ? 0f : Double.parseDouble((String) mapMeassist.get("meassist_money"));
			}
			cos025 = cos025_1 + cos025_2;
			
			sb = new StringBuffer("select nvl(sum(nvl(t.person_num,0)*nvl(t.person_money,0)+nvl(other_money,0)),0) total_money ")
			.append(" from bgp_op_target_device_hum t where bsflag='0' and (t.if_change = '0' or t.if_change is null) and t.transport_type ='2' ")
			.append(" and t.project_info_no ='").append(projectInfoNo).append("' ");
			human = pureDao.queryRecordBySQL(sb.toString());
			if(human!=null){
				double temp = 0;
				temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
				cos025 = cos025 + temp ;
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{测量服务费}", cos025, cos025_desc, projectInfoNo);

			// 安全设施费S01001002004006
			StringBuffer sqlHSE = new StringBuffer("select to_char(sum(t.hse_unit * (t.hse_count_t)),'9999999999999.00') hse_money from BGP_OP_COST_TARTET_HSE t ");
			sqlHSE.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_change = '0' or t.if_change is null) ");
			Map mapHSE = pureDao.queryRecordBySQL(sqlHSE.toString());
			double cos030 = 0f;
			String cos030_desc = "见安全设施费用测算表";
			if (mapHSE != null) {
				cos030 = (isNullOrEmpty((String) mapHSE.get("hse_money"))) ? 0f : Double.parseDouble((String) mapHSE.get("hse_money"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{安全设施费}", cos030, cos030_desc, projectInfoNo);

			StringBuffer sqlLabormon = new StringBuffer("select to_char(sum(t.person_num * t.person_money),'9999999999999.00') sum_labormon from BGP_OP_COST_TARTET_LABORMON t ");
			sqlLabormon.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_change = '0' or t.if_change is null) group by project_info_no ");
			Map mapLabormon = pureDao.queryRecordBySQL(sqlLabormon.toString());
			// 劳保用品S01001002004007
			double cos031 = 0f;
			String cos031_desc = "见劳保用品费用测算表";
			if (mapLabormon != null) {
				cos031 = (isNullOrEmpty((String) mapLabormon.get("sum_labormon"))) ? 0f : Double.parseDouble((String) mapLabormon.get("sum_labormon"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{劳保用品费}", cos031, cos031_desc, projectInfoNo);

			StringBuffer sqlDerent = new StringBuffer(
					"select   to_char(sum((t.Plan_End_Date - T.PLAN_START_DATE+1) * T.DERENT_MONEY*t.DERENT_COUNT),'99999999999999.00') SUM_DERENT from bgp_op_cost_tartet_derent t ");
			sqlDerent.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_change = '0' or t.if_change is null) group  by project_info_no ");
			Map mapDerent = pureDao.queryRecordBySQL(sqlDerent.toString());
			// 运输费S01001003011
			double cos032 = 0f;
			String cos032_desc = "见租赁费用测算表";
			if (mapDerent != null) {
				cos032 = (isNullOrEmpty((String) mapDerent.get("sum_derent"))) ? 0f : Double.parseDouble((String) mapDerent.get("sum_derent"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{设备租赁费}", cos032, cos032_desc, projectInfoNo);
			// 动谴费S01001003008
			StringBuffer sqlTransport = new StringBuffer("select  to_char(sum(t.tonnage * t.transport_count * t.transport_unit *(nvl(t.start_meter,0) + nvl(t.back_meter,0))),'9999999999999999.99') sum_transport from bgp_op_cost_tartet_transport t  ");
			sqlTransport.append(" where bsflag = '0' and t.transport_type = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_change = '0' or t.if_change is null) ");
			Map mapsqlTransport = pureDao.queryRecordBySQL(sqlTransport.toString());

			double cos033 = 0f;
			String cos033_desc = "见动迁费用测算表";
			if (mapsqlTransport != null) {
				cos033 = ((String) mapsqlTransport.get("sum_transport")) == null || "".equals(((String) mapsqlTransport.get("sum_transport"))) ? 0f : Double
						.parseDouble((String) mapsqlTransport.get("sum_transport"));
			}
			
			sqlTransport = new StringBuffer("select round(sum(t.person_num*t.person_money+t.other_money)*1000)/1000.0 sum_transport from bgp_op_cost_tartet_transport_h t  ");
			sqlTransport.append(" where bsflag = '0' and t.transport_type = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_change = '0' or t.if_change is null) ");
			mapsqlTransport = pureDao.queryRecordBySQL(sqlTransport.toString());
			if (mapsqlTransport != null) {
				cos033 += ((String) mapsqlTransport.get("sum_transport")) == null || "".equals(((String) mapsqlTransport.get("sum_transport"))) ? 0f : Double.parseDouble((String) mapsqlTransport.get("sum_transport"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{动迁费}", cos033, cos033_desc, projectInfoNo);

			StringBuffer sqlTransportOther = new StringBuffer();
			sqlTransportOther.append(" select round(sum(t.tonnage * t.transport_count * t.transport_unit *(nvl(t.start_meter,0) + nvl(t.back_meter,0)))*1000)/1000.0 sum_transport ");
			sqlTransportOther.append(" from BGP_OP_COST_TARTET_TRANSPORT t where bsflag = '0' and t.transport_type = '1' and t.project_info_no = '" + projectInfoNo + "' and (t.if_change = '0' or t.if_change is null) ");
			Map mapsqlTransportOther = pureDao.queryRecordBySQL(sqlTransportOther.toString());
			double cos033_other = 0f;
			String cos033_desc_other = "见运输费用测算表";
			if (mapsqlTransportOther != null) {
				cos033_other = ((String) mapsqlTransportOther.get("sum_transport")) == null || "".equals(((String) mapsqlTransportOther.get("sum_transport"))) ? 0f : Double
						.parseDouble((String) mapsqlTransportOther.get("sum_transport"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{运输费}", cos033_other, cos033_desc_other, projectInfoNo);

			StringBuffer sqlHumanCost = new StringBuffer("select sum(case ps.subject_id when '0000000002000000002' then ps.cont_cost when '0000000002000000007' then ps.cont_cost else 0 end)*10000 cont_cost, ");
			sqlHumanCost.append(" sum(case ps.subject_id when '0000000002000000002' then ps.mark_cost when '0000000002000000007' then ps.mark_cost else 0 end)*10000 mark_cost, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000047', ps.temp_cost, 0))*10000 temp_cost, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000047', ps.reem_cost, 0))*10000 reem_cost, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000053', ps.cont_cost, 0))*10000 cont_cost_eat, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000053', ps.mark_cost, 0))*10000 mark_cost_eat, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000053', nvl(ps.temp_cost,0) + nvl(ps.reem_cost,0)+ nvl(ps.serv_cost,0), 0))*10000 temp_cost_other, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000006', nvl(ps.temp_cost,0) + nvl(ps.reem_cost,0)+ nvl(ps.serv_cost,0), 0))*10000 cost_tel ");
			sqlHumanCost.append(" from(select wf.proc_status,s.* from bgp_comm_human_plan_cost t");
			sqlHumanCost.append(" left join common_busi_wf_middle wf on t.plan_id = wf.business_id and wf.bsflag ='0'");
			sqlHumanCost.append(" and wf.busi_table_name ='bgp_comm_human_plan_cost' and wf.business_type ='5110000004100000048'");
			sqlHumanCost.append(" left join bgp_comm_human_cost_plan_sala s on t.plan_id = s.plan_id and s.bsflag='0'");
			sqlHumanCost.append(" where t.bsflag ='0' and t.cost_state='1' and wf.proc_status='3' and t.project_info_no ='"+projectInfoNo+"' ");
			sqlHumanCost.append(" and sysdate>=(select case max(r.examine_end_date) when null then (sysdate+1) ");
			sqlHumanCost.append(" else to_date(max(r.examine_end_date),'yyyy-MM-dd hh24:mi:ss') end from wf_r_examineinst r where r.procinst_id = wf.proc_inst_id))ps");
			/*sqlHumanCost.append(" from bgp_comm_human_cost_plan_sala ps inner join  bgp_comm_human_plan_cost t on t.plan_id = ps.plan_id and t.cost_state='1' and ps.spare5 is null and t.spare5 is null"); 
			sqlHumanCost.append(" inner join common_busi_wf_middle wf on t.plan_id = wf.business_id and wf.bsflag ='0'");
			sqlHumanCost.append(" and wf.busi_table_name ='bgp_comm_human_plan_cost' and wf.business_type ='5110000004100000048' ");
			sqlHumanCost.append(" where t.bsflag ='0' and ps.bsflag ='0' and ps.project_info_no = '" + projectInfoNo + "'");*/

			Map mapHumanCost = pureDao.queryRecordBySQL(sqlHumanCost.toString());
			String contCost = (String) mapHumanCost.get("cont_cost");
			String markCost = (String) mapHumanCost.get("mark_cost");
			String tempCost = (String) mapHumanCost.get("temp_cost");
			String reemCost = (String) mapHumanCost.get("reem_cost");
			String contCostEat = (String) mapHumanCost.get("cont_cost_eat");
			String markCostEat = (String) mapHumanCost.get("mark_cost_eat");
			String tempCostOther = (String) mapHumanCost.get("temp_cost_other");
			String costTel = (String) mapHumanCost.get("cost_tel");

			double DcontCost = isNullOrEmpty(contCost) ? 0f : Double.parseDouble(contCost);
			double DmarkCost = isNullOrEmpty(markCost) ? 0f : Double.parseDouble(markCost);
			double DtempCost = isNullOrEmpty(tempCost) ? 0f : Double.parseDouble(tempCost);
			double DreemCost = isNullOrEmpty(reemCost) ? 0f : Double.parseDouble(reemCost);
			double DcontCostEat = isNullOrEmpty(contCostEat) ? 0f : Double.parseDouble(contCostEat);
			double DmarkCostEat = isNullOrEmpty(markCostEat) ? 0f : Double.parseDouble(markCostEat);
			double DtempCostOther = isNullOrEmpty(tempCostOther) ? 0f : Double.parseDouble(tempCostOther);
			double DcostTel = isNullOrEmpty(costTel) ? 0f : Double.parseDouble(costTel);

			// 获取风险奖励
			String sqlFengxian = "select nvl(max(pd.cost_detail_money),0)  money from bgp_op_target_project_info pi inner join bgp_op_target_project_detail pd "
					+ " on pi.gp_target_project_id = pd.gp_target_project_id and pi.bsflag='0' and pd.bsflag='0' and pi.project_info_no='" + projectInfoNo
					+ "' and pi.node_code = 'S01001001001002'";
			Map mapFengxian = pureDao.queryRecordBySQL(sqlFengxian);
			String fengxianMoney = (String) mapFengxian.get("money");
			double DfengxianMoney = isNullOrEmpty(fengxianMoney) ? 0f : Double.parseDouble(fengxianMoney);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{季节工工资}", DtempCost, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{钻井人工工资}", 0, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{再就业人员工资}", DreemCost, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{合同化员工工资}", DcontCost, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{市场化员工工资}", DmarkCost, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{合同化误餐费}", DcontCostEat, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{市场化误餐费}", DmarkCostEat, "", projectInfoNo);
			//OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{移动通讯费}", DcostTel, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{移动通讯费}", 0, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{其他人工费}", DtempCostOther, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{职工工资}", DcontCost + DmarkCost + DfengxianMoney, "", projectInfoNo);

			// 获取项目各项技术指标
			String sqlTechProject = "select pi.*,gp.acquire_start_time,gp.acquire_end_time,gp.acquire_end_time-gp.acquire_start_time project_dates from BGP_OP_TARGET_PROJECT_BASIC pb inner join BGP_OP_TARGET_PROJECT_INDICATO pi "
					+ "on pb.bsflag='0' and pi.bsflag='0' and pb.tartget_basic_id = pi.tartget_basic_id and pb.project_info_no='"
					+ projectInfoNo
					+ "'"
					+ " inner join gp_task_project gp on pb.project_info_no = gp.project_info_no  and gp.bsflag='0'";
			Map map = pureDao.queryRecordBySQL(sqlTechProject);
			String tech004 = "0";// 炮数
			String tech008 = "0";// 接受道数
			String tech018 = "0";// 微测井个数
			String tech019 = "0";// 检波器串数
			String tech020 = "0";// 偏前满覆盖工作量
			String tech021 = "0";// 震源生产数量
			String tech022 = "0";// 井炮生产数量
			String tech023 = "0";// 气枪生产数量
			if(map!=null){
				tech004 = (String) map.get("tech_004");// 炮数
				tech008 = (String) map.get("tech_008");// 接受道数
				tech018 = (String) map.get("tech_018");// 微测井个数
				tech019 = (String) map.get("tech_019");// 检波器串数
				tech020 = (String) map.get("tech_020");// 偏前满覆盖工作量
				tech021 = (String) map.get("tech_021");// 震源生产数量
				tech022 = (String) map.get("tech_022");// 井炮生产数量
				tech023 = (String) map.get("tech_023");// 气枪生产数量
			}

			// 项目周期天
			StringBuffer sqlStartDate = new StringBuffer(
					"select nvl(min(t3.actual_start_date),min(t3.planned_start_date)) planned_start_date from  bgp_p6_project t1 inner join bgp_p6_project_wbs t2 ");
			sqlStartDate.append(" on t1.object_id=t2.project_object_id left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id ");
			sqlStartDate.append(" where t1.bsflag ='0' and t1.project_info_no = '" + projectInfoNo + "' start with t2.name ='工区踏勘' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID ");

			StringBuffer sqlEndDate = new StringBuffer(
					"select nvl(max(t3.actual_finish_date),max(t3.planned_finish_date)) planned_finish_date from  bgp_p6_project t1 inner join bgp_p6_project_wbs t2 ");
			sqlEndDate.append(" on t1.object_id=t2.project_object_id left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id ");
			sqlEndDate.append(" where t1.bsflag ='0' and t1.project_info_no = '" + projectInfoNo + "' start with t2.name ='资源遣散' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID ");

			Map mapStartDate = pureDao.queryRecordBySQL(sqlStartDate.toString());
			Map mapEndDate = pureDao.queryRecordBySQL(sqlEndDate.toString());
			String planned_start_date = mapStartDate == null ? "" : (String) mapStartDate.get("planned_start_date");
			String planned_end_date = mapEndDate == null ? "" : (String) mapEndDate.get("planned_finish_date");
			Date startdate = new SimpleDateFormat("yyyy-MM-dd").parse(planned_start_date);
			Date enddate = new SimpleDateFormat("yyyy-MM-dd").parse(planned_end_date);
			int days = (int) ((enddate.getTime() - startdate.getTime()) / 1000 / 60 / 60 / 24);

			double dTech004 = isNullOrEmpty(tech004) ? 0f : Double.parseDouble(tech004);
			double dTech008 = isNullOrEmpty(tech008) ? 0f : Double.parseDouble(tech008);
			double dTech018 = isNullOrEmpty(tech018) ? 0f : Double.parseDouble(tech018);
			double dTech019 = isNullOrEmpty(tech019) ? 0f : Double.parseDouble(tech019);
			double dTech020 = isNullOrEmpty(tech020) ? 0f : Double.parseDouble(tech020);
			
			double dTech021 = isNullOrEmpty(tech021) ? 0f : Double.parseDouble(tech021);
			double dTech022 = isNullOrEmpty(tech022) ? 0f : Double.parseDouble(tech022);
			double dTech023 = isNullOrEmpty(tech023) ? 0f : Double.parseDouble(tech023);

			double dProjectDates = days;

			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{钻井炮数}", dTech022, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{采集炮数}", dTech004, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{采集生产天}", dProjectDates, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{项目周期天}", dProjectDates, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{项目工作量}", dTech020, "", projectInfoNo);
			
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{震源生产数量}", dTech021, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{井炮生产数量}", dTech022, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{气枪生产数量}", dTech023, "", projectInfoNo);

			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{微测井个数}", dTech018, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{接收道数}", dTech008, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{检波器串数}", dTech019, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{采集电瓶数}", 0, "", projectInfoNo);

			// 获取单价库信息
			String sqlPriceUnit = "select '{'||price_name||'}' price_name,price_unit from bgp_op_price_project_info where project_info_no ='" + projectInfoNo
					+ "' and bsflag= '0' and if_change is null and (price_name !='物资带入单价' and price_name !='手工输入单价')";
			List<Map> listPriceUnit = pureDao.queryRecords(sqlPriceUnit);
			if (listPriceUnit != null) {
				for (Map mapPriceUnit : listPriceUnit) {
					OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, (String) mapPriceUnit.get("price_name"), Double.parseDouble((String) mapPriceUnit.get("price_unit")), "",
							projectInfoNo);
				}
			}

			// 开始基础数据的四则运算
			String sqlFormula = "select * from bgp_op_target_project_info pi where pi.project_info_no = '" + projectInfoNo
					+ "' and pi.bsflag='0' and (pi.formula_type = '0'  or pi.formula_type = '2')and pi.node_code like 'S01001%' order by node_code asc";
			List<Map> listFormula = pureDao.queryRecords(sqlFormula);
			for (Map mapFormula : listFormula) {
				String formulaContent = (String) mapFormula.get("formula_content");
				String nodeCode = (String) mapFormula.get("node_code");
				double formulaValue = OPCommonUtil.getFormulaDataByBasicInfo(mapBasicInfo, formulaContent);
				String formulaDesc = OPCommonUtil.getFormulaDescByBasicInfo(mapBasicInfo, formulaContent);
				OPCommonUtil.setTargetMoneyInfoByCode(list, nodeCode, formulaValue, formulaDesc, projectInfoNo);
			}
			jdbcTemplate.batchUpdate(OPCommonUtil.getStringFromList(list));

			list = new ArrayList<String>();
			// 采集价值工作量 采集直接费用 增值税附加税 非施工期费用 机关及辅助单位费用 靠前支持费 上级管理费 勘探项目成本

			String sql = "select sum(cost_detail_money) sum_money from bgp_op_target_project_info pi inner join bgp_op_target_project_detail pd on pi.gp_target_project_id = pd.gp_target_project_id "
					+ "and pi.node_code like 'S01001%' and pd.cost_detail_money is not null and pi.project_info_no = '" + projectInfoNo + "'";
			Map mapCollection = pureDao.queryRecordBySQL(sql);
			double collection = 0f;
			if (mapCollection != null) {
				collection = ((String) mapCollection.get("sum_money")) == null || "".equals(((String) mapCollection.get("sum_money"))) ? 0f : Double.parseDouble((String) mapCollection.get("sum_money"));
			}

			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{采集直接费用}", collection, null, projectInfoNo);
			// 项目价值工作量S01008
			double cos034 = 0f;
			cos034 = dTech020;
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{实物工作量}", cos034, null, projectInfoNo);
			// 处理解释费S01009
			double cos035 = 0f;
			cos035 = dTech020;
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{处理解释费}", cos035, null, projectInfoNo);
			// 采集价值工作量S01010
			double cos042 = 0f;
			cos042 = cos034 - cos035;
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{采集价值工作量}", cos042, null, projectInfoNo);

			// 开始基础数据的四则运算
			String sqlFormulaOther = "select * from bgp_op_target_project_info pi where pi.project_info_no = '" + projectInfoNo
					+ "' and pi.bsflag='0' and (pi.formula_type = '0' or pi.formula_type = '2') and pi.node_code not like 'S01001%' and pi.node_code ='S01012' order by order_code asc";
			List<Map> listFormulaOther = pureDao.queryRecords(sqlFormulaOther);
			for (Map mapFormulaOther : listFormulaOther) {
				String formulaContent = (String) mapFormulaOther.get("formula_content");
				String nodeCode = (String) mapFormulaOther.get("node_code");
				String costName = (String) mapFormulaOther.get("cost_name");
				double formulaValue = OPCommonUtil.getFormulaDataByBasicInfo(mapBasicInfo, formulaContent);
				String formulaDesc = OPCommonUtil.getFormulaDescByBasicInfo(mapBasicInfo, formulaContent);
				OPCommonUtil.setTargetMoneyInfoByCode(list, nodeCode, formulaValue, formulaDesc, projectInfoNo);
				OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{" + costName + "}", formulaValue, null, projectInfoNo);
			}
			jdbcTemplate.batchUpdate(OPCommonUtil.getStringFromList(list));
		}
		return responseDTO;
	}

	/*
	 * 根据公式汇总目标计划成本信息
	 * TODO  目标成本预算调整
	 */
	public ISrvMsg hzCostPlanChangeByFormula(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		Map<String, Double> mapBasicInfo = new HashMap<String, Double>();
		List<String> list = new ArrayList<String>();
		if (projectInfoNo != null && !"".equals(projectInfoNo)) {
			// 初始化数据
			StringBuffer sqlOil = new StringBuffer(
					"select to_char(sum(decode(td.daily_oil_type, '2', 0, '1',td.oil_unit_price * (nvl(td.daily_oil,0)+nvl(td.single_well_oil,0)) *(td.plan_end_date - td.plan_start_date+1) * nvl(td.device_count,1), 0)),'9999999999999999.99') oil1, ");
			sqlOil.append(" to_char(sum(decode(td.daily_oil_type, '1', 0, '2',td.oil_unit_price * (nvl(td.daily_oil,0)+nvl(td.single_well_oil,0)) *(td.plan_end_date - td.plan_start_date+1) * nvl(td.device_count,1), 0)),'9999999999999999.99') oil2, ");
			sqlOil.append(" to_char(sum(td.daily_small_oil *(td.plan_end_date - td.plan_start_date + 1) * nvl(td.device_count,1)),'9999999999999999.99') oil3 ");
			sqlOil.append(" from bgp_op_tartet_device_oil td ");
			sqlOil.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo + "' and (td.if_delete_change is null and  td.if_change !='2') group by project_info_no ");
			Map mapOil = pureDao.queryRecordBySQL(sqlOil.toString());
			// 汽油S01001006004001001
			double cos006 = 0f;
			String cos006_desc = "见油料费、小油品费用测算表";
			if (mapOil != null) {
				cos006 = (isNullOrEmpty((String) mapOil.get("oil1"))) ? 0f : Double.parseDouble((String) mapOil.get("oil1"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{汽油费}", cos006, cos006_desc, projectInfoNo);
			// 柴油S01001006004001002
			double cos007 = 0f;
			String cos007_desc = "见油料费、小油品费用测算表";
			if (mapOil != null) {
				cos007 = (isNullOrEmpty((String) mapOil.get("oil2"))) ? 0f : Double.parseDouble((String) mapOil.get("oil2"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{柴油费}", cos007, cos007_desc, projectInfoNo);
			// 小油品S01001006004001003001
			double cos008 = 0f;
			String cos008_desc = "见油料费、小油品费用测算表";
			if (mapOil != null) {
				cos008 = (isNullOrEmpty((String) mapOil.get("oil3"))) ? 0f : Double.parseDouble((String) mapOil.get("oil3"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{小油品费}", cos008, cos008_desc, projectInfoNo);

			StringBuffer sqlDepreciation = new StringBuffer(
					"select to_char(sum(decode(td.depreciation_value,0,0,td.asset_value * 0.97 / td.depreciation_value / 8 * 1 / 30 *(td.plan_end_date - td.plan_start_date + 1)*td.device_count)),'9999999999999999.99') sum_depreciation ");
			sqlDepreciation.append(" from BGP_OP_TARTET_DEVICE_DEPRE td ");
			sqlDepreciation.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo
					+ "' and td.record_type='0' and (td.if_delete_change is null and  td.if_change !='2') group by project_info_no ");
			Map mapDepreciation = pureDao.queryRecordBySQL(sqlDepreciation.toString());
			// 折旧费S01001004002002
			double cos015 = 0f;
			String cos015_desc = "见设备折旧费用测算表";
			if (mapDepreciation != null) {
				cos015 = (isNullOrEmpty((String) mapDepreciation.get("sum_depreciation"))) ? 0f : Double.parseDouble((String) mapDepreciation.get("sum_depreciation"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{折旧费费}", cos015, cos015_desc, projectInfoNo);

			// 长期待摊费用S01001004002001
			StringBuffer sqlDepreciationOther = new StringBuffer(
					"select to_char(sum(decode(td.depreciation_value,0,0,td.asset_value * 0.97 / td.depreciation_value / 8 * 1 / 30 *(td.plan_end_date - td.plan_start_date + 1)*td.device_count)),'9999999999999999.99') sum_depreciation ");
			sqlDepreciationOther.append(" from BGP_OP_TARTET_DEVICE_DEPRE td ");
			sqlDepreciationOther.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo
					+ "' and td.record_type='1' and (td.if_delete_change is null and  td.if_change !='2') group by project_info_no ");
			Map mapDepreciationOther = pureDao.queryRecordBySQL(sqlDepreciationOther.toString());
			double cos016 = 0f;
			String cos016_desc = "见长期待摊费用测算表";
			if (mapDepreciationOther != null) {
				cos016 = (isNullOrEmpty((String) mapDepreciationOther.get("sum_depreciation"))) ? 0f : Double.parseDouble((String) mapDepreciationOther.get("sum_depreciation"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{长期待摊费}", cos016, cos016_desc, projectInfoNo);

			StringBuffer sqlMaterial = new StringBuffer("select   sum(td.restore_repails) restore_repails ,");
			sqlMaterial
					.append(" to_char(sum(td.vehicle_daily_material *(td.plan_end_date - td.plan_start_date + 1) *td.device_count),'9999999999999999.99') sum_vehicle_daily_material, ");
			sqlMaterial
					.append(" to_char(sum(td.drilling_daily_material *(td.plan_end_date - td.plan_start_date + 1) *td.device_count),'9999999999999999.99') sum_drilling_daily_material ");
			sqlMaterial.append(" from bgp_op_tartet_device_material td ");
			sqlMaterial.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo + "' and (td.if_delete_change is null and  td.if_change !='2') group by project_info_no ");
			Map mapMaterial = pureDao.queryRecordBySQL(sqlMaterial.toString());
			// 汽车材料S01001004001002
			double cos017 = 0f;
			String cos017_desc = "见设备材料、恢复性修理费测算表";
			if (mapMaterial != null) {
				cos017 = (isNullOrEmpty((String) mapMaterial.get("sum_vehicle_daily_material"))) ? 0f : Double.parseDouble((String) mapMaterial.get("sum_vehicle_daily_material"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{汽车材料费}", cos017, cos017_desc, projectInfoNo);
			// 钻机材料S01001004001003
			double cos018 = 0f;
			String cos018_desc = "见设备材料、恢复性修理费测算表";
			if (mapMaterial != null) {
				cos018 = (isNullOrEmpty((String) mapMaterial.get("sum_drilling_daily_material"))) ? 0f : Double
						.parseDouble((String) mapMaterial.get("sum_drilling_daily_material"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{钻机材料费}", cos018, cos018_desc, projectInfoNo);

			// 恢复性修理费用S01001004001004001
			double cos019 = 0f;
			String cos019_desc = "见设备材料、恢复性修理费测算表";
			if (mapMaterial != null) {
				cos019 = (isNullOrEmpty((String) mapMaterial.get("restore_repails"))) ? 0f : Double.parseDouble((String) mapMaterial.get("restore_repails"));
			}

			// 汽车恢复性修理费用S01001004001004003
			double cos020 = 0f;
			String cos020_desc = "见设备材料、恢复性修理费测算表";
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{钻机恢复性修理费}", cos020, cos020_desc, projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{汽车恢复性修理费}", cos019, cos019_desc, projectInfoNo);

			StringBuffer sqlMataxi = new StringBuffer(
					  "select  sum(decode(t.mataxi_type,'1',to_char((t.plan_end_date - t.plan_start_date + 1) *t.taxi_ratio,'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price1, ");
			sqlMataxi.append(" sum(decode(t.mataxi_type,'2',to_char((t.plan_end_date - t.plan_start_date + 1) *t.taxi_ratio,'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price2, ");
			sqlMataxi.append(" sum(decode(t.mataxi_type,'3',to_char((t.plan_end_date - t.plan_start_date + 1) *t.taxi_ratio,'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price3, ");
			sqlMataxi.append(" sum(decode(t.mataxi_type,'4',to_char((t.plan_end_date - t.plan_start_date + 1-nvl(t.passive_date,0)) *t.taxi_ratio,'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price4 ");
			sqlMataxi.append(" from bgp_op_target_device_mataxi t ");
			sqlMataxi.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_delete_change is null and  t.if_change !='2')  ");

			Map mapMataxi = pureDao.queryRecordBySQL(sqlMataxi.toString());

			StringBuffer sqlMatare = new StringBuffer("select to_char(sum(t.taxi_unit * (t.dev_count)),'9999999999999.00') sum_money from BGP_OP_TARGET_DEVICE_MATARE t ");
			sqlMatare.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_delete_change is null and  t.if_change !='2') ");
			Map mapMatare = pureDao.queryRecordBySQL(sqlMatare.toString());

			// 仪器租用费S01001004004002004
			double cos022 = 0f;
			String cos022_desc = "见仪器、专用工具租赁费测算表";
			if (mapMataxi != null) {
				cos022 = (isNullOrEmpty((String) mapMataxi.get("sum_price1"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price1"));
			}
			StringBuffer sb = new StringBuffer("select nvl(sum(nvl(t.person_num,0)*nvl(t.person_money,0)+nvl(other_money,0)),0) total_money ")
			.append(" from bgp_op_target_device_hum t where bsflag='0' and (t.if_change ='0' or t.if_change='1') and t.transport_type ='1' ")
			.append(" and nvl(t.if_delete_change,0) !=1 and t.project_info_no ='").append(projectInfoNo).append("' ");
			Map human = pureDao.queryRecordBySQL(sb.toString());
			if(human!=null){
				double temp = 0;
				temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
				cos022 = cos022 + temp ;
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{仪器租用费}", cos022, cos022_desc, projectInfoNo);
			// 专用工具租赁费(维修费)S01001004004002001
			double cos023 = 0f;
			String cos023_desc = "见仪器、专用工具租赁费测算表";
			if (mapMataxi != null) {
				cos023 = (isNullOrEmpty((String) mapMataxi.get("sum_price3"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price3"));
			}
			if (mapMatare != null) {
				cos023 += (isNullOrEmpty((String) mapMatare.get("sum_money"))) ? 0f : Double.parseDouble((String) mapMatare.get("sum_money"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{专用工具租用费}", cos023, cos023_desc, projectInfoNo);
			// 震源租用费S01001004004002005
			double cos024 = 0f;
			String cos024_desc = "见震源租赁费测算表";
			if (mapMataxi != null) {
				cos024 = (isNullOrEmpty((String) mapMataxi.get("sum_price4"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price4"));
			}
			sb = new StringBuffer("select nvl(sum(nvl(t.person_num,0)*nvl(t.person_money,0)+nvl(other_money,0)),0) total_money ")
			.append(" from bgp_op_target_device_hum t where bsflag='0' and (t.if_change ='0' or t.if_change='1') and t.transport_type ='0' ")
			.append(" and nvl(t.if_delete_change,0) !=1 and t.project_info_no ='").append(projectInfoNo).append("' ");
			human = pureDao.queryRecordBySQL(sb.toString());
			if(human!=null){
				double temp = 0;
			    temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
			    cos024 = cos024 + temp ;
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{震源租用费}", cos024, cos024_desc, projectInfoNo);

			// 运载设备租用费S01001004004002003
			double cos026 = 0f;
			String cos026_desc = "见仪器、专用工具租赁费测算表";
			if (mapMataxi != null) {
				cos026 = (isNullOrEmpty((String) mapMataxi.get("sum_price2"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price2"));
			}
			sb = new StringBuffer("select nvl(sum(t.device_count*(t.plan_end_date-t.plan_start_date+1)*nvl(t.taxi_unit,0)),0) total_money ")
			.append(" from bgp_op_target_device_rent t where bsflag='0' and t.if_change != '2' and t.if_delete_change is null")
			.append(" and t.project_info_no ='").append(projectInfoNo).append("' ");
			human = pureDao.queryRecordBySQL(sb.toString());
			if(human!=null){
				double temp = 0;
				temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
				cos026 = cos026 + temp ;
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{运载设备费}", cos026, cos026_desc, projectInfoNo);

			// 测量服务费S01001004004002002

			StringBuffer sqlMeasure = new StringBuffer("select sum((nvl(t.detector_line,0) + nvl(bomb_line,0)) * measure_price*nvl(measure_ratio,0)) sum_price ");
			sqlMeasure.append(" from bgp_op_tartet_device_measure t ");
			sqlMeasure.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo
					+ "' and (t.if_delete_change is null and  t.if_change !='2') group by project_info_no ");
			Map mapMeasure = pureDao.queryRecordBySQL(sqlMeasure.toString());

			StringBuffer sqlMeassist = new StringBuffer("select to_char(sum(t.meassist_money),'99999999999999999999.99') meassist_money from bgp_op_tartet_device_meassist t ");
			sqlMeassist.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_delete_change is null and  t.if_change !='2')");
			Map mapMeassist = pureDao.queryRecordBySQL(sqlMeassist.toString());

			double cos025 = 0f;
			String cos025_desc = "见测量服务费测算表";
			double cos025_1 = 0f;
			if (mapMeasure != null) {
				cos025_1 = (isNullOrEmpty((String) mapMeasure.get("sum_price"))) ? 0f : Double.parseDouble((String) mapMeasure.get("sum_price"));
			}
			double cos025_2 = 0f;
			if (mapMeassist != null) {
				cos025_2 = (isNullOrEmpty((String) mapMeassist.get("meassist_money"))) ? 0f : Double.parseDouble((String) mapMeassist.get("meassist_money"));
			}
			cos025 = cos025_1 + cos025_2;
			sb = new StringBuffer("select nvl(sum(nvl(t.person_num,0)*nvl(t.person_money,0)+nvl(other_money,0)),0) total_money ")
			.append(" from bgp_op_target_device_hum t where bsflag='0' and (t.if_change ='0' or t.if_change='1') and t.transport_type ='2' ")
			.append(" and nvl(t.if_delete_change,0) !=1 and t.project_info_no ='").append(projectInfoNo).append("' ");
			human = pureDao.queryRecordBySQL(sb.toString());
			if(human!=null){
			  double temp = 0;
			  temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
			  cos025 = cos025 + temp ;
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{测量服务费}", cos025, cos025_desc, projectInfoNo);

			// 安全设施费S01001002004006
			StringBuffer sqlHSE = new StringBuffer("select to_char(sum(t.hse_unit * (t.hse_count_t)),'9999999999999.00') hse_money from BGP_OP_COST_TARTET_HSE t ");
			sqlHSE.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and (t.if_delete_change is null and  t.if_change !='2') ");
			Map mapHSE = pureDao.queryRecordBySQL(sqlHSE.toString());
			double cos030 = 0f;
			String cos030_desc = "见安全设施费用测算表";
			if (mapHSE != null) {
				cos030 = (isNullOrEmpty((String) mapHSE.get("hse_money"))) ? 0f : Double.parseDouble((String) mapHSE.get("hse_money"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{安全设施费}", cos030, cos030_desc, projectInfoNo);

			StringBuffer sqlLabormon = new StringBuffer("select to_char(sum(t.person_num * t.person_money),'9999999999999.00') sum_labormon from BGP_OP_COST_TARTET_LABORMON t ");
			sqlLabormon.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo
					+ "' and (t.if_delete_change is null and  t.if_change !='2') group by project_info_no ");
			Map mapLabormon = pureDao.queryRecordBySQL(sqlLabormon.toString());
			// 劳保用品S01001002004007
			double cos031 = 0f;
			String cos031_desc = "见劳保用品费用测算表";
			if (mapLabormon != null) {
				cos031 = (isNullOrEmpty((String) mapLabormon.get("sum_labormon"))) ? 0f : Double.parseDouble((String) mapLabormon.get("sum_labormon"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{劳保用品费}", cos031, cos031_desc, projectInfoNo);

			StringBuffer sqlDerent = new StringBuffer(
					"select   to_char(sum((t.Plan_End_Date - T.PLAN_START_DATE+1) * T.DERENT_MONEY*t.DERENT_COUNT),'99999999999999.00') SUM_DERENT from bgp_op_cost_tartet_derent t ");
			sqlDerent.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo
					+ "' and (t.if_delete_change is null and  t.if_change !='2') group  by project_info_no ");
			Map mapDerent = pureDao.queryRecordBySQL(sqlDerent.toString());
			// 运输费S01001003011
			double cos032 = 0f;
			String cos032_desc = "见租赁费用测算表";
			if (mapDerent != null) {
				cos032 = (isNullOrEmpty((String) mapDerent.get("sum_derent"))) ? 0f : Double.parseDouble((String) mapDerent.get("sum_derent"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{设备租赁费}", cos032, cos032_desc, projectInfoNo);
			// 动谴费S01001003008
			StringBuffer sqlTransport = new StringBuffer(
					"select  to_char(sum(t.tonnage * t.transport_count * t.transport_unit *(nvl(t.start_meter,0) + nvl(t.back_meter,0))),'9999999999999999.99') sum_transport from BGP_OP_COST_TARTET_TRANSPORT t  ");
			sqlTransport.append(" where bsflag = '0' and t.transport_type = '0' and t.project_info_no = '" + projectInfoNo
					+ "' and (t.if_delete_change is null and  t.if_change !='2') ");
			Map mapsqlTransport = pureDao.queryRecordBySQL(sqlTransport.toString());
			double cos033 = 0f;
			String cos033_desc = "见动迁费用测算表";
			if (mapsqlTransport != null) {
				cos033 = ((String) mapsqlTransport.get("sum_transport")) == null || "".equals(((String) mapsqlTransport.get("sum_transport"))) ? 0f : Double
						.parseDouble((String) mapsqlTransport.get("sum_transport"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{动迁费}", cos033, cos033_desc, projectInfoNo);

			StringBuffer sqlTransportOther = new StringBuffer(
					"select  to_char(sum(t.tonnage * t.transport_count * t.transport_unit *(nvl(t.start_meter,0) + nvl(t.back_meter,0))),'9999999999999999.99') sum_transport from BGP_OP_COST_TARTET_TRANSPORT t  ");
			sqlTransportOther.append(" where bsflag = '0' and t.transport_type = '1' and t.project_info_no = '" + projectInfoNo
					+ "' and (t.if_delete_change is null and  t.if_change !='2') ");
			Map mapsqlTransportOther = pureDao.queryRecordBySQL(sqlTransportOther.toString());
			double cos033_other = 0f;
			String cos033_desc_other = "见运输费用测算表";
			if (mapsqlTransport != null) {
				cos033_other = ((String) mapsqlTransportOther.get("sum_transport")) == null || "".equals(((String) mapsqlTransportOther.get("sum_transport"))) ? 0f : Double
						.parseDouble((String) mapsqlTransportOther.get("sum_transport"));
			}
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{运输费}", cos033_other, cos033_desc_other, projectInfoNo);

			StringBuffer sqlHumanCost = new StringBuffer("select sum(case ps.subject_id when '0000000002000000002' then ps.cont_cost when '0000000002000000007' then ps.cont_cost else 0 end)*10000 cont_cost, ");
			sqlHumanCost.append(" sum(case ps.subject_id when '0000000002000000002' then ps.mark_cost when '0000000002000000007' then ps.mark_cost else 0 end)*10000 mark_cost, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000047', ps.temp_cost, 0))*10000 temp_cost, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000047', ps.reem_cost, 0))*10000 reem_cost, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000053', ps.cont_cost, 0))*10000 cont_cost_eat, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000053', ps.mark_cost, 0))*10000 mark_cost_eat, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000053', nvl(ps.temp_cost,0) + nvl(ps.reem_cost,0)+ nvl(ps.serv_cost,0), 0))*10000 temp_cost_other, ");
			sqlHumanCost.append(" sum(decode(ps.subject_id, '0000000002000000006', nvl(ps.temp_cost,0) + nvl(ps.reem_cost,0)+ nvl(ps.serv_cost,0), 0))*10000 cost_tel ");
			sqlHumanCost.append(" from(select wf.proc_status,s.* from bgp_comm_human_plan_cost t");
			sqlHumanCost.append(" left join common_busi_wf_middle wf on t.plan_id = wf.business_id and wf.bsflag ='0'");
			sqlHumanCost.append(" and wf.busi_table_name ='bgp_comm_human_plan_cost' and wf.business_type ='5110000004100000048'");
			sqlHumanCost.append(" left join bgp_comm_human_cost_plan_sala s on t.plan_id = s.plan_id and s.bsflag='0'");
			sqlHumanCost.append(" where t.bsflag ='0' and t.cost_state='1' and wf.proc_status='3' and t.project_info_no ='"+projectInfoNo+"' ");
			sqlHumanCost.append(" and sysdate>=(select case max(r.examine_end_date) when null then (sysdate+1) ");
			sqlHumanCost.append(" else to_date(max(r.examine_end_date),'yyyy-MM-dd hh24:mi:ss') end from wf_r_examineinst r where r.procinst_id = wf.proc_inst_id))ps");
			/*sqlHumanCost.append(" from bgp_comm_human_cost_plan_sala ps inner join  bgp_comm_human_plan_cost t on t.plan_id = ps.plan_id and t.cost_state='1'");
			sqlHumanCost.append(" inner join common_busi_wf_middle wf on t.plan_id = wf.business_id and wf.bsflag ='0'");
			sqlHumanCost.append(" and wf.busi_table_name ='bgp_comm_human_plan_cost' and wf.business_type ='5110000004100000048' ");
			sqlHumanCost.append(" where ps.project_info_no = '"+ projectInfoNo + "'");*/

			Map mapHumanCost = pureDao.queryRecordBySQL(sqlHumanCost.toString());
			String contCost = (String) mapHumanCost.get("cont_cost");
			String markCost = (String) mapHumanCost.get("mark_cost");
			String tempCost = (String) mapHumanCost.get("temp_cost");
			String reemCost = (String) mapHumanCost.get("reem_cost");
			String contCostEat = (String) mapHumanCost.get("cont_cost_eat");
			String markCostEat = (String) mapHumanCost.get("mark_cost_eat");
			String tempCostOther = (String) mapHumanCost.get("temp_cost_other");
			String costTel = (String) mapHumanCost.get("cost_tel");

			double DcontCost = isNullOrEmpty(contCost) ? 0f : Double.parseDouble(contCost);
			double DmarkCost = isNullOrEmpty(markCost) ? 0f : Double.parseDouble(markCost);
			double DtempCost = isNullOrEmpty(tempCost) ? 0f : Double.parseDouble(tempCost);
			double DreemCost = isNullOrEmpty(reemCost) ? 0f : Double.parseDouble(reemCost);
			double DcontCostEat = isNullOrEmpty(contCostEat) ? 0f : Double.parseDouble(contCostEat);
			double DmarkCostEat = isNullOrEmpty(markCostEat) ? 0f : Double.parseDouble(markCostEat);
			double DtempCostOther = isNullOrEmpty(tempCostOther) ? 0f : Double.parseDouble(tempCostOther);
			double DcostTel = isNullOrEmpty(costTel) ? 0f : Double.parseDouble(costTel);

			// 获取风险奖励
			String sqlFengxian = "select nvl(max(pd.cost_detail_money),0)  money from bgp_op_target_project_info pi inner join bgp_op_target_project_detail pd "
					+ " on pi.gp_target_project_id = pd.gp_target_project_id and pi.bsflag='0' and pd.bsflag='0' and pi.project_info_no='" + projectInfoNo
					+ "' and pi.node_code = 'S01001001001002'";
			Map mapFengxian = pureDao.queryRecordBySQL(sqlFengxian);
			String fengxianMoney = (String) mapFengxian.get("money");
			double DfengxianMoney = isNullOrEmpty(fengxianMoney) ? 0f : Double.parseDouble(fengxianMoney);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{季节工工资}", DtempCost, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{钻井人工工资}", 0, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{再就业人员工资}", DreemCost, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{合同化员工工资}", DcontCost, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{市场化员工工资}", DmarkCost, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{合同化误餐费}", DcontCostEat, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{市场化误餐费}", DmarkCostEat, "", projectInfoNo);
			//OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{移动通讯费}", DcostTel, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{移动通讯费}", 0, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{其他人工费}", DtempCostOther, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{职工工资}", DcontCost + DmarkCost + DfengxianMoney, "", projectInfoNo);

			// 获取项目各项技术指标
			String sqlTechProject = "select pi.*,gp.acquire_start_time,gp.acquire_end_time,gp.acquire_end_time-gp.acquire_start_time project_dates from BGP_OP_TARGET_PROJECT_BASIC pb inner join BGP_OP_TARGET_PROJECT_INDICATO pi "
					+ "on pb.bsflag='0' and pi.bsflag='0' and pb.tartget_basic_id = pi.tartget_basic_id and pb.project_info_no='"
					+ projectInfoNo
					+ "'"
					+ " inner join gp_task_project gp on pb.project_info_no = gp.project_info_no  and gp.bsflag='0'";
			Map map = pureDao.queryRecordBySQL(sqlTechProject);
			String tech004 = "0";// 炮数
			String tech008 = "0";// 接受道数
			String tech018 = "0";// 微测井个数
			String tech019 = "0";// 检波器串数
			String tech020 = "0";// 偏前满覆盖工作量
			
			String tech021 = "0";// 震源生产数量
			String tech022 = "0";// 井炮生产数量
			String tech023 = "0";// 气枪生产数量
			if(map!=null){
				tech004 = (String) map.get("tech_004");// 炮数
				tech008 = (String) map.get("tech_008");// 接受道数
				tech018 = (String) map.get("tech_018");// 微测井个数
				tech019 = (String) map.get("tech_019");// 检波器串数
				tech020 = (String) map.get("tech_020");// 偏前满覆盖工作量
				
				tech021 = (String) map.get("tech_021");// 震源生产数量
				tech022 = (String) map.get("tech_022");// 井炮生产数量
				tech023 = (String) map.get("tech_023");// 气枪生产数量
			}

			// 项目周期天
			StringBuffer sqlStartDate = new StringBuffer("select min(t3.planned_start_date) planned_start_date from  bgp_p6_project t1 inner join bgp_p6_project_wbs t2 ");
			sqlStartDate.append(" on t1.object_id=t2.project_object_id left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id ");
			sqlStartDate.append(" where t1.bsflag ='0' and t1.project_info_no = '" + projectInfoNo + "' start with t2.name ='工区踏勘' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID ");

			StringBuffer sqlEndDate = new StringBuffer("select max(t3.planned_finish_date) planned_finish_date from  bgp_p6_project t1 inner join bgp_p6_project_wbs t2 ");
			sqlEndDate.append(" on t1.object_id=t2.project_object_id left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id ");
			sqlEndDate.append(" where t1.bsflag ='0' and t1.project_info_no = '" + projectInfoNo + "' start with t2.name ='资源遣散' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID ");

			Map mapStartDate = pureDao.queryRecordBySQL(sqlStartDate.toString());
			Map mapEndDate = pureDao.queryRecordBySQL(sqlEndDate.toString());
			String planned_start_date = mapStartDate == null ? "" : (String) mapStartDate.get("planned_start_date");
			String planned_end_date = mapEndDate == null ? "" : (String) mapEndDate.get("planned_finish_date");
			int days = 0;
			if (!"".equals(planned_start_date) && !"".equals(planned_end_date)) {
				Date startdate = new SimpleDateFormat("yyyy-MM-dd").parse(planned_start_date);
				Date enddate = new SimpleDateFormat("yyyy-MM-dd").parse(planned_end_date);
				days = (int) ((enddate.getTime() - startdate.getTime()) / 1000 / 60 / 60 / 24);
			}

			double dTech004 = isNullOrEmpty(tech004) ? 0f : Double.parseDouble(tech004);
			double dTech008 = isNullOrEmpty(tech008) ? 0f : Double.parseDouble(tech008);
			double dTech018 = isNullOrEmpty(tech018) ? 0f : Double.parseDouble(tech018);
			double dTech019 = isNullOrEmpty(tech019) ? 0f : Double.parseDouble(tech019);
			double dTech020 = isNullOrEmpty(tech020) ? 0f : Double.parseDouble(tech020);
			
			double dTech021 = isNullOrEmpty(tech021) ? 0f : Double.parseDouble(tech021);
			double dTech022 = isNullOrEmpty(tech022) ? 0f : Double.parseDouble(tech022);
			double dTech023 = isNullOrEmpty(tech023) ? 0f : Double.parseDouble(tech023);

			double dProjectDates = days;

			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{钻井炮数}", dTech022, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{采集炮数}", dTech004, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{采集生产天}", dProjectDates, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{项目周期天}", dProjectDates, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{项目工作量}", dTech020, "", projectInfoNo);
			
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{震源生产数量}", dTech021, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{井炮生产数量}", dTech022, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{气枪生产数量}", dTech023, "", projectInfoNo);

			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{微测井个数}", dTech018, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{接收道数}", dTech008, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{检波器串数}", dTech019, "", projectInfoNo);
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{采集电瓶数}", 0, "", projectInfoNo);

			// 获取单价库信息
			String sqlPriceUnit = "select '{'||price_name||'}' price_name,price_unit from bgp_op_price_project_info where project_info_no ='" + projectInfoNo
					+ "' and bsflag= '0' and if_delete_change is null and (price_name !='物资带入单价' and price_name !='手工输入单价')";
			

			List<Map> listPriceUnit = pureDao.queryRecords(sqlPriceUnit);
			if (listPriceUnit != null) {
				for (Map mapPriceUnit : listPriceUnit) {
					OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, (String) mapPriceUnit.get("price_name"), Double.parseDouble((String) mapPriceUnit.get("price_unit")), "",
							projectInfoNo);
				}
			}

			// 开始基础数据的四则运算
			String sqlFormula = "select * from bgp_op_target_project_info pi where pi.project_info_no = '" + projectInfoNo
					+ "' and pi.bsflag='0' and (pi.formula_type = '0' or pi.formula_type = '2') and pi.node_code like 'S01001%' order by node_code asc";
			List<Map> listFormula = pureDao.queryRecords(sqlFormula);
			for (Map mapFormula : listFormula) {
				String formulaContent = (String) mapFormula.get("formula_content");
				String nodeCode = (String) mapFormula.get("node_code");
				double formulaValue = OPCommonUtil.getFormulaDataByBasicInfo(mapBasicInfo, formulaContent);
				String formulaDesc = OPCommonUtil.getFormulaDescByBasicInfo(mapBasicInfo, formulaContent);
				OPCommonUtil.setTargetMoneyInfoChangeByCode(list, nodeCode, formulaValue, formulaDesc, projectInfoNo);
			}
			if(list!=null && list.size()>0)
			jdbcTemplate.batchUpdate(OPCommonUtil.getStringFromList(list));

			list = new ArrayList<String>();
			// 采集价值工作量 采集直接费用 增值税附加税 非施工期费用 机关及辅助单位费用 靠前支持费 上级管理费 勘探项目成本

			String sql = "select sum(cost_detail_money) sum_money from bgp_op_target_project_info pi inner join bgp_op_target_project_detail pd on pi.gp_target_project_id = pd.gp_target_project_id "
					+ "and pi.node_code like 'S01001%' and pd.cost_detail_money is not null and pi.project_info_no = '" + projectInfoNo + "'";
			Map mapCollection = pureDao.queryRecordBySQL(sql);
			double collection = 0f;
			if (mapCollection != null) {
				collection = ((String) mapCollection.get("sum_money")) == null || "".equals(((String) mapCollection.get("sum_money"))) ? 0f : Double
						.parseDouble((String) mapCollection.get("sum_money"));
			}

			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{采集直接费用}", collection, null, projectInfoNo);
			// 项目价值工作量S01008
			double cos034 = 0f;
			cos034 = dTech020;
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{实物工作量}", cos034, null, projectInfoNo);
			// 处理解释费S01009
			double cos035 = 0f;
			cos035 = dTech020;
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{处理解释费}", cos035, null, projectInfoNo);
			// 采集价值工作量S01010
			double cos042 = 0f;
			cos042 = cos034 - cos035;
			OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{采集价值工作量}", cos042, null, projectInfoNo);

			// 开始基础数据的四则运算
			String sqlFormulaOther = "select * from bgp_op_target_project_info pi where pi.project_info_no = '" + projectInfoNo
					+ "' and pi.bsflag='0' and (pi.formula_type = '0' or pi.formula_type = '2') and pi.node_code not like 'S01001%' order by order_code asc";
			List<Map> listFormulaOther = pureDao.queryRecords(sqlFormulaOther);
			for (Map mapFormulaOther : listFormulaOther) {
				String formulaContent = (String) mapFormulaOther.get("formula_content");
				String nodeCode = (String) mapFormulaOther.get("node_code");
				String costName = (String) mapFormulaOther.get("cost_name");
				double formulaValue = OPCommonUtil.getFormulaDataByBasicInfo(mapBasicInfo, formulaContent);
				String formulaDesc = OPCommonUtil.getFormulaDescByBasicInfo(mapBasicInfo, formulaContent);
				OPCommonUtil.setTargetMoneyInfoChangeByCode(list, nodeCode, formulaValue, formulaDesc, projectInfoNo);
				OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{" + costName + "}", formulaValue, null, projectInfoNo);
			}
			if(list!=null && list.size()>0)
			jdbcTemplate.batchUpdate(OPCommonUtil.getStringFromList(list));
		}
		return responseDTO;
	}

	/*
	 * 根据公式汇总实际成本信息
	 * TODO  成本费用检测
	 */
	public ISrvMsg hzCostActualByFormula(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String project_type = reqDTO.getValue("project_type");
		UserToken user = reqDTO.getUserToken();
		String user_name="";
		String org_id = "'";
		String org_subjection_id = "";
		if(user!=null&&!"".equals(user)){
			 user_name = user.getUserName();
			 org_id = user.getOrgId();
			 org_subjection_id = user.getOrgSubjectionId();			
		}

		if(project_type!=null && project_type.trim().equals("5000100004000000009")){
			String sql = "delete bgp_op_actual_project_detail d where d.gp_target_project_id =(select t.gp_target_project_id"+
				" from bgp_op_target_project_info t where t.bsflag ='0' and t.node_code ='S01001' and t.project_info_no ='"+projectInfoNo+"') ";
			jdbcTemplate.execute(sql);
			
			StringBuffer sb = new StringBuffer("");
			sb.append(" insert into bgp_op_actual_project_detail(actual_detail_id,gp_target_project_id,occur_date,cost_detail_money,org_id,org_subjection_id,creator,create_date, ")
			.append(" updator,modifi_date,bsflag,spare4)select lower(sys_guid()),(select t.gp_target_project_id from bgp_op_target_project_info t where t.bsflag ='0'  ")
			.append(" and t.node_code ='S01001' and t.project_info_no ='"+projectInfoNo+"' ),t.app_date, t.sum_human_cost ,'"+org_id+"','"+org_subjection_id+"','"+user_name+"',")
			.append(" sysdate,'"+user_name+"',sysdate,'0',sysdate from bgp_comm_human_cost_act_deta t where t.bsflag ='0'  ")
			.append(" and (t.subject_id ='0000000002000000002' or t.subject_id ='0000000002000000001') and t.project_info_no ='"+projectInfoNo+"' ");
			jdbcTemplate.execute(sb.toString());
		}else{
			String delete_sql = "delete bgp_op_actual_project_detail d where d.gp_target_project_id in (select p.gp_target_project_id"+
			" from bgp_op_target_project_info p where p.bsflag ='0' and p.project_info_no='"+projectInfoNo+"' and (p.formula_type = '0' or p.formula_type = '3'))";
			jdbcTemplate.execute(delete_sql);
			String currentDate = null;
			StringBuffer sqlStartDate = new StringBuffer(
					"select nvl(min(t3.actual_start_date),min(t3.planned_start_date)) planned_start_date from  bgp_p6_project t1 inner join bgp_p6_project_wbs t2 ");
			sqlStartDate.append(" on t1.object_id=t2.project_object_id left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id ");
			sqlStartDate.append(" where t1.bsflag ='0' and t1.project_info_no = '" + projectInfoNo + "' start with t2.name ='工区踏勘' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID ");

			StringBuffer sqlEndDate = new StringBuffer(
					"select nvl(max(t3.actual_finish_date),max(t3.planned_finish_date)) planned_finish_date from  bgp_p6_project t1 inner join bgp_p6_project_wbs t2 ");
			sqlEndDate.append(" on t1.object_id=t2.project_object_id left outer join bgp_p6_activity t3 on t2.object_id=t3.wbs_object_id ");
			sqlEndDate.append(" where t1.bsflag ='0' and t1.project_info_no = '" + projectInfoNo + "' start with t2.name ='资源遣散' connect by prior  t2.object_id=t2.PARENT_OBJECT_ID ");

			String sqlIsCacu = "select count(1) num from bgp_op_target_project_info where bsflag ='0' and project_info_no='"+ projectInfoNo+ "' ";
					//+ "and project_info_no in('8ad891d338a1d0550138a1fc0f770002','8ad878dd3a62928f013a63137ca50002','8ad8913d3abaa8ea013abae448800002','8ad878dd39aefd8a0139b3320af9018e','8ad882733bdad830013bdf8079ed03de','8ad882733d26799b013d2e7ec531081b')";

			Map mapStartDate = pureDao.queryRecordBySQL(sqlStartDate.toString());
			Map mapEndDate = pureDao.queryRecordBySQL(sqlEndDate.toString());
			Map mapIsCacu = pureDao.queryRecordBySQL(sqlIsCacu.toString());

			String planned_start_date = mapStartDate == null ? "" : (String) mapStartDate.get("planned_start_date");
			String planned_end_date = mapEndDate == null ? "" : (String) mapEndDate.get("planned_finish_date");

			double swgzl = 0;

			if (!"".equals(planned_start_date) && !"".equals(planned_end_date) && !"0".equals(mapIsCacu.get("num"))) {
				Date startdate = new SimpleDateFormat("yyyy-MM-dd").parse(planned_start_date);
				Date enddate = new SimpleDateFormat("yyyy-MM-dd").parse(planned_end_date);
				int days = (int) ((enddate.getTime() - startdate.getTime()) / 1000 / 60 / 60 / 24+1);
				//合同化、市场化、季节工、再就业的计划工资和误餐费
				StringBuffer money_sql = new StringBuffer();
				money_sql.append(" select sum(case when t.node_code='S01001001001001' then c.cost_detail_money else 0 end) ht_money, ")
				.append(" sum(case when t.node_code='S01001001001003' then c.cost_detail_money else 0 end) sc_money, ")
				.append(" sum(case when t.node_code='S01001001009003' then c.cost_detail_money else 0 end) jj_money, ")
				.append(" sum(case when t.node_code='S01001001009001' then c.cost_detail_money else 0 end) jy_money, ")
				.append(" sum(case when t.node_code='S01001001006001001' then c.cost_detail_money else 0 end) ht_bonus, ")
				.append(" sum(case when t.node_code='S01001001006001002' then c.cost_detail_money else 0 end) sc_bonus, ")
				.append(" sum(case when t.node_code='S01001001006002' then c.cost_detail_money else 0 end) jj_bonus from bgp_op_target_project_info t ")
				.append(" left join bgp_op_target_project_detail d on t.gp_target_project_id = d.gp_target_project_id and d.bsflag ='0'  ")
				.append(" left join (select gp_target_project_id,sum(cost_detail_money)cost_detail_money from bgp_op_target_project_change where bsflag ='0'  ")
				.append(" group by gp_target_project_id) c on t.gp_target_project_id = c.gp_target_project_id  ")
				.append(" where t.bsflag='0' and t.project_info_no='"+projectInfoNo+"' ");
				Map money_map = (Map)pureDao.queryRecordBySQL(money_sql.toString());
				double ht_money = money_map==null || money_map.get("ht_money")==null?0:Double.valueOf((String)money_map.get("ht_money"));
				double sc_money = money_map==null || money_map.get("sc_money")==null?0:Double.valueOf((String)money_map.get("sc_money"));
				double jj_money = money_map==null || money_map.get("jj_money")==null?0:Double.valueOf((String)money_map.get("jj_money"));
				double jy_money = money_map==null || money_map.get("jy_money")==null?0:Double.valueOf((String)money_map.get("jy_money"));
				double ht_bonus = money_map==null || money_map.get("ht_bonus")==null?0:Double.valueOf((String)money_map.get("ht_bonus"));
				double sc_bonus = money_map==null || money_map.get("sc_bonus")==null?0:Double.valueOf((String)money_map.get("sc_bonus"));
				double jj_bonus = money_map==null || money_map.get("jj_bonus")==null?0:Double.valueOf((String)money_map.get("jj_bonus"));
				//合同化、市场化、季节工、再就业的人数
				StringBuffer num_sql = new StringBuffer();
				num_sql.append(" select sum(case when employee_gz='0110000019000000001' then 1 else 0 end) ht_num,sum(case when employee_gz='0110000019000000002' then 1 else 0 end) sc_num, ")
				.append(" sum(case when employee_gz='0110000059000000005' or employee_gz='0110000059000000002' or employee_gz='0110000059000000003' or employee_gz='110000059000000006' then 1 else 0 end) jj_num, ")
				.append(" sum(case when employee_gz='0110000059000000001' then 1 else 0 end) jy_num from(select h.employee_gz,p.employee_id,e.employee_name from bgp_human_prepare t  ")
				.append(" left join bgp_human_prepare_human_detail d on t.prepare_no = d.prepare_no and d.bsflag ='0' ")
				.append(" left join bgp_comm_human_receive_process p on d.employee_id = p.employee_id and p.bsflag ='0' ")
				.append(" left join comm_human_employee e on d.employee_id = e.employee_id and e.bsflag ='0' ")
				.append(" left join comm_human_employee_hr h on e.employee_id = h.employee_id and h.bsflag ='0' ")
				.append(" where t.bsflag ='0' and d.between_param is null and p.task_id is not null and t.project_info_no ='"+projectInfoNo+"' union ")
				.append(" select l.if_engineer,l.labor_id employee_id,l.employee_name from bgp_comm_human_labor_deploy t ")
				.append(" left join bgp_comm_human_deploy_detail d on t.labor_deploy_id = d.labor_deploy_id and d.bsflag = '0'   ")
				.append(" left join bgp_comm_human_receive_labor r on d.deploy_detail_id = r.deploy_detail_id and r.bsflag ='0' ")
				.append(" left join bgp_comm_human_labor l on t.labor_id = l.labor_id and l.bsflag='0' ")
				.append(" where t.bsflag ='0' and t.between_param  is null and r.task_id is not null and t.project_info_no ='"+projectInfoNo+"') ");
				Map num_map = (Map)pureDao.queryRecordBySQL(num_sql.toString());
				int ht_num = num_map==null || num_map.get("ht_num")==null || ((String)num_map.get("ht_num")).trim().equals("")?0:Integer.valueOf((String)num_map.get("ht_num"));
				int sc_num = num_map==null || num_map.get("sc_num")==null || ((String)num_map.get("sc_num")).trim().equals("")?0:Integer.valueOf((String)num_map.get("sc_num"));
				int jj_num = num_map==null || num_map.get("jj_num")==null || ((String)num_map.get("jj_num")).trim().equals("")?0:Integer.valueOf((String)num_map.get("jj_num"));
				int jy_num = num_map==null || num_map.get("jy_num")==null || ((String)num_map.get("jy_num")).trim().equals("")?0:Integer.valueOf((String)num_map.get("jy_num"));
				
				double ht_money_per = ht_num==0?0:Math.round(ht_money/ht_num*10000)/10000.0;
				double sc_money_per = sc_num==0?0:Math.round(sc_money/sc_num*10000)/10000.0;
				double jj_money_per = jj_num==0?0:Math.round(jj_money/jj_num*10000)/10000.0;
				double jy_money_per = jy_num==0?0:Math.round(jy_money/jy_num*10000)/10000.0;
				double ht_bonus_per = ht_num==0?0:Math.round(ht_bonus/ht_num*10000)/10000.0;
				double sc_bonus_per = sc_num==0?0:Math.round(sc_bonus/sc_num*10000)/10000.0;
				double jj_bonus_per = (jj_num+jy_num)==0?0:Math.round(jj_bonus/(jj_num+jy_num)*10000)/10000.0;

				// 更新设备的进队离队时间
				StringBuilder sqlDeviceTime = new StringBuilder("update BGP_OP_TARTET_DEVICE_DEPRE t set t.actual_start_date =  ");
				sqlDeviceTime.append(" (select max(dui.actual_in_time) from gms_device_account_dui dui where dui.project_info_id=t.project_info_no and dui.dev_acc_id=t.dev_acc_id ), ");
				sqlDeviceTime.append(" t.actual_end_date =  ");
				sqlDeviceTime.append(" (select max(dui.actual_out_time) from gms_device_account_dui dui where dui.project_info_id=t.project_info_no and dui.dev_acc_id=t.dev_acc_id ) ");
				sqlDeviceTime.append(" where t.project_info_no='"+projectInfoNo+"'  AND T.RECORD_TYPE ='0'");
				jdbcTemplate.execute(sqlDeviceTime.toString());
				Date date1 = new Date();
				//油
				Map <String,String> mapOil = new HashMap<String, String>();
				StringBuffer sqlOil = new StringBuffer("");
				sqlOil.append("   select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,sum(case when mi.coding_code_id like '070301%' then d.oil_num * d.actual_price else 0 end) oil1,   ");
				sqlOil.append("     sum(case when mi.coding_code_id like '070303%' then d.oil_num * d.actual_price else 0 end) oil2    ");
				sqlOil.append("   from gms_device_account_dui dui  ");
				sqlOil.append(" left join gms_mat_teammat_out_detail d on dui.dev_acc_id = d.dev_acc_id and d.bsflag = '0'  ");
				sqlOil.append("  left join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id and o.bsflag = '0'  "); 
				sqlOil.append("  left join gms_mat_infomation mi on d.wz_id = mi.wz_id and mi.bsflag = '0'     ");
				sqlOil.append("  where dui.project_info_id = '"+projectInfoNo+"' and dui.BSFLAG='0'and d.dev_acc_id is not null "); 
				sqlOil.append(" group by  to_char(o.outmat_date,'yyyy_MM_dd')");      		
				List listOil = pureDao.queryRecords(sqlOil.toString());
				if (listOil != null) {
					for(int o=0;o<listOil.size();o++){
						Map mapOiltemp=(Map)listOil.get(o);
						String produceDate = (String) mapOiltemp.get("producedate");
						mapOil.put("date"+produceDate, mapOiltemp.get("oil1")+"_"+mapOiltemp.get("oil2"));

					}
				}
				
				Map<String,String> mapMaterial = new HashMap<String, String>();
				StringBuffer sqlMaterial = new StringBuffer("");
				sqlMaterial.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,sum(case when mi.coding_code_id like '55%' or mi.coding_code_id like '56%'  then d.mat_num * d.actual_price else 0 end) oil2, ");
				sqlMaterial.append("  sum(case when mi.coding_code_id like '48%' then o.total_money else 0 end) oil1, ");
				sqlMaterial.append(" sum(case when mi.coding_code_id like '0705%' or mi.coding_code_id like '0707%' or mi.coding_code_id like '0708%'  or mi.coding_code_id like '0709%' or mi.coding_code_id like '179905%'  then d.mat_num * d.actual_price else 0 end) oil3   "); 
				sqlMaterial.append(" from gms_device_account_dui dui ");
				sqlMaterial.append(" left join gms_mat_teammat_out o on dui.dev_acc_id = o.dev_acc_id and o.bsflag = '0' ");
				sqlMaterial.append(" left join gms_mat_teammat_out_detail d on o.teammat_out_id = d.teammat_out_id and d.bsflag = '0'  ");
				sqlMaterial.append(" left join gms_mat_infomation mi on d.wz_id = mi.wz_id and mi.bsflag = '0'   ");
				sqlMaterial.append(" where dui.project_info_id = '"+projectInfoNo+"' and o.dev_acc_id is not null and  dui.dev_type not like 'S1405%' ");
				sqlMaterial.append(" and dui.BSFLAG='0' group by to_char(o.outmat_date,'yyyy_MM_dd') ");
				List listMaterial = pureDao.queryRecords(sqlMaterial.toString());
				if(listMaterial!=null){
					for(int m=0;m<listMaterial.size();m++){
						Map mapMaterialTemp = (Map)listMaterial.get(m);
						String producedate = (String)mapMaterialTemp.get("producedate");
						mapMaterial.put("date"+producedate, mapMaterialTemp.get("oil1")+"_"+mapMaterialTemp.get("oil2")+"_"+mapMaterialTemp.get("oil3"));
					}
				}
				
				// 获取钻探材料
				Map<String,String> mapZuantan = new HashMap<String, String>();
				StringBuffer sqlZuanTan = new StringBuffer();
				sqlZuanTan.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_zt ");
				sqlZuanTan.append("from GMS_MAT_TEAMMAT_OUT_DETAIL d  ");
				sqlZuanTan.append("inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  and o.BSFLAG='0' and o.OUTMAT_DATE is not null ");
				sqlZuanTan.append("inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0' ");
				sqlZuanTan.append("where d.bsflag = '0'  and d.project_info_no = '"+projectInfoNo+"'   and (mi.coding_code_id like '02%' or mi.coding_code_id like '47%') ");
				sqlZuanTan.append("group  by to_char(o.outmat_date,'yyyy_MM_dd') ");
				List listZuantan = pureDao.queryRecords(sqlZuanTan.toString());
				if(listZuantan!=null){
					for(int z=0;z<listZuantan.size();z++){
						Map mapZuantanTemp = (Map)listZuantan.get(z);
						String producedate = (String)mapZuantanTemp.get("producedate");
						mapZuantan.put("date"+producedate, ""+mapZuantanTemp.get("sum_zt"));	
					}
				}

				// 聚乙烯绳及钢纤
				Map<String,String> mapJuYiXi = new HashMap<String, String>();
				StringBuffer sqlJuYiXi = new StringBuffer();
				sqlJuYiXi.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_zt " );
				sqlJuYiXi.append(" from GMS_MAT_TEAMMAT_OUT_DETAIL d   ");
				sqlJuYiXi.append(" inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  and o.BSFLAG='0' ");
				sqlJuYiXi.append(" inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  ");
				sqlJuYiXi.append(" where d.bsflag = '0'  and d.project_info_no = '"+projectInfoNo+"'   and (mi.coding_code_id like '40031514%' or mi.coding_code_id like '02003014%') ");
				sqlJuYiXi.append(" group  by to_char(o.outmat_date,'yyyy_MM_dd') ");
				List listJuYiXi = pureDao.queryRecords(sqlJuYiXi.toString());
				if (listJuYiXi != null) {
					for(int j=0;j<listJuYiXi.size();j++){
						Map mapJuYiXiTemp = (Map)listJuYiXi.get(j);
						String producedate = (String)mapJuYiXiTemp.get("producedate");
						mapJuYiXi.put("date"+producedate, ""+mapJuYiXiTemp.get("sum_zt"));
					}				
				}
				
				// 检波器维修材料
				Map<String,String> mapJianBoQi = new HashMap<String, String>();
				StringBuffer sqlJianBoQi = new StringBuffer();
				sqlJianBoQi.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_zt ");
				sqlJianBoQi.append(" from GMS_MAT_TEAMMAT_OUT_DETAIL d  ");
				sqlJianBoQi.append(" inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  and o.BSFLAG='0' ");
				sqlJianBoQi.append(" inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  ");
				sqlJianBoQi.append(" where d.bsflag = '0'  and d.project_info_no = '"+projectInfoNo+"'   and mi.coding_code_id like '37810104%' ");
				sqlJianBoQi.append(" group  by to_char(o.outmat_date,'yyyy_MM_dd') ");
				List listJianBoQi = pureDao.queryRecords(sqlJianBoQi.toString());
				if(listJianBoQi!=null){
					for(int j=0;j<listJianBoQi.size();j++){
						Map mapJianBoQiTemp = (Map)listJianBoQi.get(j);
						String producedate = (String)mapJianBoQiTemp.get("producedate");
						mapJianBoQi.put("date"+producedate, ""+mapJianBoQiTemp.get("sum_zt"));
					}
				}
				
				//@todo 只有钻井组发放的洗衣粉放到里面
				// 膨润土
				Map<String,String> mapPengRunTu = new HashMap<String, String>();
				StringBuffer sqlPengRunTu = new StringBuffer();
				sqlPengRunTu.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_zt ");
				sqlPengRunTu.append(" from GMS_MAT_TEAMMAT_OUT_DETAIL d  ");
				sqlPengRunTu.append(" inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  and o.BSFLAG='0' ");
				sqlPengRunTu.append(" inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  ");
				sqlPengRunTu.append(" where d.bsflag = '0'  and d.project_info_no = '"+projectInfoNo+"'   and (mi.coding_code_id like '12030101%' or mi.coding_code_id like '21120103%') ");
				sqlPengRunTu.append(" group  by to_char(o.outmat_date,'yyyy_MM_dd') ");
				List listPengRunTu = pureDao.queryRecords(sqlPengRunTu.toString());
				if(listPengRunTu!=null){
					for(int p=0;p<listPengRunTu.size();p++){
						Map mapPengRunTuTemp = (Map)listPengRunTu.get(p);
						String producedate  = (String)mapPengRunTuTemp.get("producedate");
						mapPengRunTu.put("date"+producedate, ""+mapPengRunTuTemp.get("sum_zt"));
					}
				}
				

				//炸药
				Map<String,String> mapZhayao = new HashMap<String, String>();
				StringBuffer sqlZhayao = new StringBuffer();
				sqlZhayao.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_zt ");
				sqlZhayao.append("from GMS_MAT_TEAMMAT_OUT_DETAIL d   ");
				sqlZhayao.append("inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  and o.BSFLAG='0' ");
				sqlZhayao.append("inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  ");
				sqlZhayao.append("where d.bsflag = '0'  and d.project_info_no = '"+projectInfoNo+"'    and (mi.coding_code_id like '1091%' or mi.coding_code_id like '1095%') ");
				sqlZhayao.append("group  by to_char(o.outmat_date,'yyyy_MM_dd') ");
				List listZhayao = pureDao.queryRecords(sqlZhayao.toString());
				if(listZhayao!=null){
					for(int z=0;z<listZhayao.size();z++){
						Map mapZhayaoTemp = (Map)listZhayao.get(z);
						String producedate = (String)mapZhayaoTemp.get("producedate");
						mapZhayao.put("date"+producedate, ""+mapZhayaoTemp.get("sum_zt"));
					}
				}
				
				//雷管
				Map<String,String> mapLeiguan = new HashMap<String, String>();
				StringBuffer sqlLeiguan = new StringBuffer();
				sqlLeiguan.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_zt ");
				sqlLeiguan.append("from GMS_MAT_TEAMMAT_OUT_DETAIL d   ");
				sqlLeiguan.append("inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  and o.BSFLAG='0' ");
				sqlLeiguan.append("inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  ");
				sqlLeiguan.append("where d.bsflag = '0'  and d.project_info_no = '"+projectInfoNo+"'  and  mi.coding_code_id like '1093%' ");
				sqlLeiguan.append("group  by to_char(o.outmat_date,'yyyy_MM_dd') ");
				List listLeiguan = pureDao.queryRecords(sqlLeiguan.toString());
				if(listLeiguan!=null){
					for(int l=0;l<listLeiguan.size();l++){
						Map mapLeiguanTemp = (Map)listLeiguan.get(l);
						String producedate = (String)mapLeiguanTemp.get("producedate");
						mapLeiguan.put("date"+producedate, ""+mapLeiguanTemp.get("sum_zt"));
					}
				}
				
				//炮线
				Map<String,String> mapPaoxian = new HashMap<String, String>();
				StringBuffer sqlPaoxian = new StringBuffer();
				sqlPaoxian.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_zt ");
				sqlPaoxian.append("from GMS_MAT_TEAMMAT_OUT_DETAIL d   ");
				sqlPaoxian.append("inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  and o.BSFLAG='0' ");
				sqlPaoxian.append("inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  ");
				sqlPaoxian.append("where d.bsflag = '0'  and d.project_info_no = '"+projectInfoNo+"'  and  mi.coding_code_id like '32019904%' ");
				sqlPaoxian.append("group  by to_char(o.outmat_date,'yyyy_MM_dd') ");
				List listPaoxian = pureDao.queryRecords(sqlPaoxian.toString());
				if(listPaoxian!=null){
					for(int p=0;p<listPaoxian.size();p++){
						Map mapPaoxianTemp = (Map)listPaoxian.get(p);
						String producedate = (String)mapPaoxianTemp.get("producedate");
						mapPaoxian.put("date"+producedate, ""+mapPaoxianTemp.get("sum_zt"));
					}
				}
				
				//磁带
				Map<String,String> mapCidai = new HashMap<String, String>();
				StringBuffer sqlCidai = new StringBuffer();
				sqlCidai.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_zt ");
				sqlCidai.append("from GMS_MAT_TEAMMAT_OUT_DETAIL d   ");
				sqlCidai.append("inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  and o.BSFLAG='0' ");
				sqlCidai.append("inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  ");
				sqlCidai.append("where d.bsflag = '0'  and d.project_info_no = '"+projectInfoNo+"'  and  mi.coding_code_id like '36070205%' ");
				sqlCidai.append("group  by to_char(o.outmat_date,'yyyy_MM_dd') ");
				List listCidai = pureDao.queryRecords(sqlCidai.toString());
				if(listPaoxian!=null){
					for(int c=0;c<listCidai.size();c++){
						Map mapCIdaiTemp = (Map)listCidai.get(c);
						String producedate = (String)mapCIdaiTemp.get("producedate");
						mapCidai.put("date"+producedate, ""+mapCIdaiTemp.get("sum_zt"));
					}
				}
				
				//记录纸
				Map<String,String> mapJiluzhi = new HashMap<String, String>();
				StringBuffer sqlJiluzhi = new StringBuffer();
				sqlJiluzhi.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_zt ");
				sqlJiluzhi.append("from GMS_MAT_TEAMMAT_OUT_DETAIL d   ");
				sqlJiluzhi.append("inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  and o.BSFLAG='0' ");
				sqlJiluzhi.append("inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  ");
				sqlJiluzhi.append("where d.bsflag = '0'  and d.project_info_no = '"+projectInfoNo+"'  and  mi.coding_code_id like '20010302%' ");
				sqlJiluzhi.append("group  by to_char(o.outmat_date,'yyyy_MM_dd') ");
				List listJiluzhi = pureDao.queryRecords(sqlJiluzhi.toString());
				if(listJiluzhi!=null){
					for(int c=0;c<listJiluzhi.size();c++){
						Map mapJiluzhiTemp = (Map)listJiluzhi.get(c);
						String producedate = (String)mapJiluzhiTemp.get("producedate");
						mapJiluzhi.put("date"+producedate, ""+mapJiluzhiTemp.get("sum_zt"));
					}
				}
				// 劳保用品
				Map<String,String> mapLabormon = new HashMap<String, String>();
				StringBuffer sqlLabormon = new StringBuffer();
				sqlLabormon.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_zt ");
				sqlLabormon.append("from GMS_MAT_TEAMMAT_OUT_DETAIL d   ");
				sqlLabormon.append("inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  and o.BSFLAG='0' ");
				sqlLabormon.append("inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  ");
				sqlLabormon.append("where d.bsflag = '0'  and d.project_info_no = '"+projectInfoNo+"'  and  mi.coding_code_id like '21%' ");
				sqlLabormon.append("group  by to_char(o.outmat_date,'yyyy_MM_dd') ");
				List listLabormon = pureDao.queryRecords(sqlLabormon.toString());
				if(listLabormon!=null){
					for(int c=0;c<listLabormon.size();c++){
						Map mapLabormonTemp = (Map)listLabormon.get(c);
						String producedate = (String)mapLabormonTemp.get("producedate");
						mapLabormon.put("date"+producedate, ""+mapLabormonTemp.get("sum_zt"));
					}
				}
				
				// 营地建设费
				Map<String,String> mapYDJs = new HashMap<String, String>();
				StringBuffer sqlYDJs = new StringBuffer();
				sqlYDJs.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_labormon from GMS_MAT_TEAMMAT_OUT_DETAIL d ");
				sqlYDJs.append("	 inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id and o.BSFLAG='0'  ");
				sqlYDJs.append(" inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  	 ");
				sqlYDJs.append(" inner join GMS_MAT_DEMAND_PLAN_BZ bz on o.plan_invoice_id = bz.submite_number  ");
				sqlYDJs.append("  where  d.project_info_no='"+projectInfoNo+"' and    bz.plan_type='5110000044000000002' and d.bsflag = '0'  ");
	        	sqlYDJs.append("  group by to_char(o.outmat_date,'yyyy_MM_dd')  ");
	        	List listYDJs = pureDao.queryRecords(sqlYDJs.toString());
	        	if(listYDJs!=null){
	        		for(int y=0;y<listYDJs.size();y++){
	        			Map mapYDJsTemp = (Map)listYDJs.get(y);
						String producedate = (String)mapYDJsTemp.get("producedate");
						mapYDJs.put("date"+producedate, ""+mapYDJsTemp.get("sum_labormon"));
	        		}
	        	}
	        	
				// 办公用品
				Map<String,String> mapBGYP = new HashMap<String, String>();
				StringBuffer sqlBGYP = new StringBuffer();
				sqlBGYP.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_labormon from GMS_MAT_TEAMMAT_OUT_DETAIL d ");
				sqlBGYP.append("	 inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id and o.BSFLAG='0'  ");
				sqlBGYP.append(" inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  	 ");
				sqlBGYP.append(" inner join GMS_MAT_DEMAND_PLAN_BZ bz on o.plan_invoice_id = bz.submite_number  ");
				sqlBGYP.append("  where  d.project_info_no='"+projectInfoNo+"' and    bz.plan_type='5110000044000000002' and d.bsflag = '0'  ");
				sqlBGYP.append("  group by to_char(o.outmat_date,'yyyy_MM_dd')  ");
	        	List listBGYP = pureDao.queryRecords(sqlBGYP.toString());
	        	if(listBGYP!=null){
	        		for(int y=0;y<listBGYP.size();y++){
	        			Map mapBGYPTemp = (Map)listBGYP.get(y);
						String producedate = (String)mapBGYPTemp.get("producedate");
						mapBGYP.put("date"+producedate, ""+mapBGYPTemp.get("sum_labormon"));
	        		}
	        	}
	        	
				// 安全建设费
				Map<String,String> mapAJC = new HashMap<String, String>();
				StringBuffer sqlAJC = new StringBuffer();
				sqlAJC.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_labormon from GMS_MAT_TEAMMAT_OUT_DETAIL d ");
				sqlAJC.append("	 inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id and o.BSFLAG='0'  ");
				sqlAJC.append(" inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0'  	 ");
				sqlAJC.append(" inner join GMS_MAT_DEMAND_PLAN_BZ bz on o.plan_invoice_id = bz.submite_number  ");
				sqlAJC.append("  where  d.project_info_no='"+projectInfoNo+"' and    bz.plan_type='5110000044000000004' and d.bsflag = '0'  ");
				sqlAJC.append("  group by to_char(o.outmat_date,'yyyy_MM_dd')  ");
	        	List listAJC = pureDao.queryRecords(sqlAJC.toString());
	        	if(listAJC!=null){
	        		for(int y=0;y<listAJC.size();y++){
	        			Map mapAJCTemp = (Map)listAJC.get(y);
						String producedate = (String)mapAJCTemp.get("producedate");
						mapAJC.put("date"+producedate, ""+mapAJCTemp.get("sum_labormon"));
	        		}
	        	}
	        	
	        	//其他材料费
				Map<String,String> mapQTCL = new HashMap<String, String>();
	        	StringBuffer sqlQTCL = new StringBuffer();
	        	sqlQTCL.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate, nvl(sum(d.mat_num * d.actual_price), 0) sum_zt ");
	        	sqlQTCL.append("from GMS_MAT_TEAMMAT_OUT_DETAIL d  ");
	        	sqlQTCL.append("inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  and o.bsflag = '0'  ");
	        	sqlQTCL.append("inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0' ");
	        	sqlQTCL.append("where d.project_info_no = '"+projectInfoNo+"'  and d.bsflag = '0'   ");
	        	sqlQTCL.append("and (mi.coding_code_id like '60%' and (mi.coding_code_id not like '6004%' or (mi.coding_code_id  like '60040182%' and  mi.coding_code_id  like '60040152%' and mi.coding_code_id  like '60040140%' and  mi.coding_code_id  like '60040204%' and mi.coding_code_id  like '600404%' and mi.coding_code_id  like '60040223%' and  mi.coding_code_id  like '600404%')) and  mi.coding_code_id not like '601101%' and  mi.coding_code_id not like '601102%'  and  mi.coding_code_id not like '601106%' and  mi.coding_code_id not like '601107%' and  mi.coding_code_id not like '601108%') ");
	        	sqlQTCL.append(" group by to_char(o.outmat_date,'yyyy_MM_dd') ");
	        	List listQTCL = pureDao.queryRecords(sqlQTCL.toString());
	        	if(listQTCL!=null){
	        		for(int q=0;q<listQTCL.size();q++){
	        			Map mapQTCLTemp = (Map)listQTCL.get(q);
						String producedate = (String)mapQTCLTemp.get("producedate");
	        			mapQTCL.put("date"+producedate, ""+mapQTCLTemp.get("sum_zt"));
	        		}
	        	}
	        	
				// 低值易耗品
				Map<String,String> mapDZYH = new HashMap<String, String>();
				StringBuffer sqlDZYH = new StringBuffer();
				sqlDZYH.append(" select to_char(o.outmat_date,'yyyy_MM_dd') as produceDate,nvl(sum(d.mat_num * d.actual_price), 0) sum_zt ");
				sqlDZYH.append("from GMS_MAT_TEAMMAT_OUT_DETAIL d  ");
				sqlDZYH.append("inner join gms_mat_teammat_out o on d.teammat_out_id = o.teammat_out_id  ");  
				sqlDZYH.append("inner join GMS_MAT_INFOMATION mi  on d.wz_id = mi.wz_id and mi.bsflag = '0' ");
				sqlDZYH.append("where d.project_info_no = '8ad88271414d615f01414dc3d0b80094'    and ( mi.coding_code_id  like '601101%' or  mi.coding_code_id  like '601102%'  or  mi.coding_code_id  like '601106%' or  mi.coding_code_id  like '601107%' or  mi.coding_code_id  like '601108%') ");
				sqlDZYH.append("and d.bsflag = '0'  group by to_char(o.outmat_date,'yyyy_MM_dd') ");
	        	List listDZYH = pureDao.queryRecords(sqlDZYH.toString());
	        	if(listDZYH!=null){
	        		for(int q=0;q<listDZYH.size();q++){
	        			Map mapDZYHTemp = (Map)listDZYH.get(q);
						String producedate = (String)mapDZYHTemp.get("producedate");
						mapDZYH.put("date"+producedate, ""+mapDZYHTemp.get("sum_zt"));
	        		}
	        	}
			
				// 获取风险奖励
				String sqlFengxian = "select nvl(max(pd.cost_detail_money),0)  money from bgp_op_target_project_info pi inner join bgp_op_actual_project_detail pd "
						+ " on pi.gp_target_project_id = pd.gp_target_project_id and  pd.bsflag='0' where pi.project_info_no='" + projectInfoNo+ "' and pi.bsflag='0'  and pi.node_code = 'S01001001001002'";
				Map mapFengxian = pureDao.queryRecordBySQL(sqlFengxian);
				String fengxianMoney = (String) mapFengxian.get("money");
				
				//获取分摊折旧费
				String sqlFTDepre="select pd.cost_detail_money money from bgp_op_target_project_detail pd inner join bgp_op_target_project_info pi " +
						"on pi.GP_TARGET_PROJECT_ID=pd.GP_TARGET_PROJECT_ID and pi.bsflag='0' where pi.cost_name='分摊折旧费'  and pi.project_info_no='"+projectInfoNo+"'";
				Map mapFTDepre=pureDao.queryRecordBySQL(sqlFTDepre);
				
				// 获取项目各项技术指标
				String sqlTechProject = "select pi.*,gp.acquire_start_time,gp.acquire_end_time,gp.acquire_end_time-gp.acquire_start_time project_dates from BGP_OP_TARGET_PROJECT_BASIC pb inner join BGP_OP_TARGET_PROJECT_INDICATO pi "
						+ "on pb.bsflag='0' and pi.bsflag='0' and pb.tartget_basic_id = pi.tartget_basic_id and pb.project_info_no='"
						+ projectInfoNo
						+ "'"
						+ " inner join gp_task_project gp on pb.project_info_no = gp.project_info_no  and gp.bsflag='0'";
				Map map = pureDao.queryRecordBySQL(sqlTechProject);
				
				
				Map<String,String> mapProject001 = new HashMap<String, String>();
				StringBuffer sqlProject001 = new StringBuffer();
				sqlProject001.append(" 	select to_char(gd.send_date,'yyyy_MM_dd') as produceDate,nvl(sum(nvl(gd.DAILY_FINISHING_2D_SP,0) + nvl(gd.DAILY_FINISHING_3D_SP,0)), 0) acquire_sp, ");
				sqlProject001.append(" 	  nvl(sum(nvl(gd.daily_2d_total_shot,0) + nvl(gd.daily_3d_total_shot,0)), 0) drilly_sp, ");
				sqlProject001.append(" 		 nvl(sum(nvl(gd.SHOT_2D_WORKLOAD,0) + nvl(gd.SHOT_3D_WORKLOAD,0)), 0) shot_workload, ");
			    sqlProject001.append(" 		 nvl(sum(nvl(gd.finish_3d_workload,0) + nvl(gd.finish_2d_workload,0)), 0) work_load ");
				sqlProject001.append(" 		from rpt_gp_daily gd  ");
				sqlProject001.append(" 		where gd.project_info_no = '"+projectInfoNo+"'  and gd.bsflag = '0'   group by to_char(gd.send_date,'yyyy_MM_dd')");
				List listProject001 = pureDao.queryRecords(sqlProject001.toString());
				if(listProject001!=null){
					for(int p=0;p<listProject001.size();p++){
						Map mapProject001Temp = (Map)listProject001.get(p);
						String producedate = (String)mapProject001Temp.get("producedate");
						mapProject001.put("date"+producedate, mapProject001Temp.get("acquire_sp")+"_"+mapProject001Temp.get("drilly_sp")+"_"+mapProject001Temp.get("shot_workload")+"_"+mapProject001Temp.get("work_load"));
					}
				}
				
				Map<String,String> mapProject003 = new HashMap<String, String>();
				StringBuffer sqlProject003 = new StringBuffer();
				sqlProject003.append(" select to_char(gr.produce_date,'yyyy_MM_dd') as produceDate,max(gr.DAILY_MICRO_MEASUE_POINT_NUM) DAILY_MICRO_MEASUE_POINT_NUM from gp_ops_daily_report  gr  ");
				sqlProject003.append("  where gr.project_info_no = '"+projectInfoNo+"'  and gr.bsflag='0'  ");
				sqlProject003.append("  group by to_char(gr.produce_date,'yyyy_MM_dd') ");
				List listProject003 = pureDao.queryRecords(sqlProject003.toString());
				if(listProject003!=null){
					for(int p=0;p<listProject003.size();p++){
						Map mapProject003Temp = (Map)listProject003.get(p);
						String producedate = (String)mapProject003Temp.get("producedate");
						mapProject003.put("date"+producedate, mapProject003Temp.get("daily_micro_measue_point_num")+"");
					}
				}
				
				// 获取单价库信息
				String sqlPriceUnit = "select '{'||price_name||'}' price_name,price_unit from bgp_op_price_project_info where project_info_no ='" + projectInfoNo
						+ "' and bsflag= '0' and if_delete_change is null and (price_name !='物资带入单价' and price_name !='手工输入单价')";
				List<Map> listPriceUnit = pureDao.queryRecords(sqlPriceUnit);

				String sqlFormula = "select pi.*,nvl(pi.formula_content_a,pi.formula_content) formula_text from bgp_op_target_project_info pi where pi.project_info_no = '"
					+ projectInfoNo + "' and pi.bsflag='0' and (pi.formula_type = '0' or pi.formula_type = '3') and pi.node_code like 'S01001%' order by node_code asc";
				List<Map> listFormula = pureDao.queryRecords(sqlFormula);
				
				// 开始基础数据的四则运算
				String sqlFormulaOther = "select * from bgp_op_target_project_info pi where pi.project_info_no = '" + projectInfoNo
						+ "' and pi.bsflag='0' and (pi.formula_type = '0' or pi.formula_type = '3') and pi.node_code not like 'S01001%' order by order_code asc";
				List<Map> listFormulaOther = pureDao.queryRecords(sqlFormulaOther);
				
				String sql = "select sum(cost_detail_money) sum_money from bgp_op_target_project_info pi inner join bgp_op_actual_project_detail pd on pi.gp_target_project_id = pd.gp_target_project_id "
					+ "and pi.node_code like 'S01001%' and pd.cost_detail_money is not null and pi.project_info_no = '" + projectInfoNo + "'";
				Map mapCollection = pureDao.queryRecordBySQL(sql);
				double collection = 0f;
				if (mapCollection != null) {
					collection = ((String) mapCollection.get("sum_money")) == null || "".equals(((String) mapCollection.get("sum_money"))) ? 0f : Double
							.parseDouble((String) mapCollection.get("sum_money"));
					collection = collection / days;
				}
				while (startdate.compareTo(enddate) <= 0) {
					currentDate = new SimpleDateFormat("yyyy-MM-dd").format(startdate);
					String mapDateK = new SimpleDateFormat("yyyy_MM_dd").format(startdate);
					Map<String, Double> mapBasicInfo = new HashMap<String, Double>();
					List<String> list = new ArrayList<String>();
					if (projectInfoNo != null && !"".equals(projectInfoNo)) {
						// 初始化数据
						// 汽油S01001006004001001
						double cos006 = 0f;
						String cos006_desc = "见油料费、小油品费用测算表";
		
						// 柴油S01001006004001002
						double cos007 = 0f;
						String cos007_desc = "见油料费、小油品费用测算表";

						String oilValues = mapOil.get("date"+mapDateK);
						if(oilValues!=null){
							 String oil1 = oilValues.split("_")[0];
							 String oil2 = oilValues.split("_")[1];
							 cos006 = (isNullOrEmpty(oil1)) ? 0f : Double.parseDouble(oil1);
							 cos007 = (isNullOrEmpty(oil2)) ? 0f : Double.parseDouble(oil2);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{汽油费}", cos006, cos006_desc, projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{柴油费}", cos007, cos007_desc, projectInfoNo);

						
						StringBuffer sqlDepreciation = new StringBuffer(
								"select to_char(sum(decode(td.depreciation_value,0,0,td.asset_value * 0.97 / td.depreciation_value / 8 * (case when nvl(dui.actual_in_time,td.actual_start_date) is null then 0 when to_date('" + currentDate
										+ "','yyyy-MM-dd') >=dui.actual_in_time AND ");
						sqlDepreciation.append(" to_date('" + currentDate
								+ "','yyyy-MM-dd')<=nvl(nvl(dui.actual_out_time,td.actual_end_date),sysdate) then 1 else 0 end) / 30 *td.device_count)),'9999999999999999.99') sum_depreciation  ");
						sqlDepreciation
								.append(" from BGP_OP_TARTET_DEVICE_DEPRE td  left outer join gms_device_account_dui dui on td.project_info_no = dui.project_info_id and dui.bsflag='0' and td.dev_acc_id = dui.dev_acc_id ");
						sqlDepreciation.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo
								+ "' and td.record_type='0' and td.if_actual_change is null and td.if_delete_change is null group by project_info_no  ");

						Map mapDepreciation = pureDao.queryRecordBySQL(sqlDepreciation.toString());
						// 折旧费S01001004002002
						double cos015 = 0f;
						String cos015_desc = "见设备折旧费用测算表";
						if (mapDepreciation != null) {
							cos015 = (isNullOrEmpty((String) mapDepreciation.get("sum_depreciation"))) ? 0f : Double.parseDouble((String) mapDepreciation.get("sum_depreciation"));
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{折旧费费}", cos015, cos015_desc, projectInfoNo);

						
						// 长期待摊费用S01001004002001
						StringBuffer sqlDepreciationOther = new StringBuffer(
								"select to_char(sum(decode(td.depreciation_value,0,0,td.asset_value * 0.97 / td.depreciation_value / 8 * (case  when td.actual_start_date is null then 0 ");
						sqlDepreciationOther.append(" when td.actual_start_date >to_date('" + currentDate + "','yyyy-MM-dd') then 0  ");
						sqlDepreciationOther.append(" when td.actual_start_date <=to_date('" + currentDate + "','yyyy-MM-dd') and td.actual_end_date is null then 1 ");
						sqlDepreciationOther.append(" when td.actual_start_date <=to_date('" + currentDate + "','yyyy-MM-dd') and td.actual_end_date>=to_date('" + currentDate
								+ "','yyyy-MM-dd') then 1 ");
						sqlDepreciationOther.append(" when td.actual_end_date<=to_date('" + currentDate
								+ "','yyyy-MM-dd') then 0 else 0 end) / 30 *td.device_count)),'9999999999999999.99') sum_depreciation ");
						sqlDepreciationOther.append(" from BGP_OP_TARTET_DEVICE_DEPRE td ");
						sqlDepreciationOther.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo
								+ "' and td.record_type='1' and td.if_delete_change is null and  td.if_actual_change is null group by project_info_no ");
						Map mapDepreciationOther = pureDao.queryRecordBySQL(sqlDepreciationOther.toString());
						double cos016 = 0f;
						String cos016_desc = "见长期待摊费用测算表";
						if (mapDepreciationOther != null) {
							cos016 = (isNullOrEmpty((String) mapDepreciationOther.get("sum_depreciation"))) ? 0f : Double.parseDouble((String) mapDepreciationOther
									.get("sum_depreciation"));
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{长期待摊费}", cos016, cos016_desc, projectInfoNo);

						// 钻机材料费S01001004001002
						double cos017 = 0f;
						String cos017_desc = "见设备材料、恢复性修理费测算表";

						// 汽车材料费S01001004001003
						double cos018 = 0f;
						String cos018_desc = "见设备材料、恢复性修理费测算表";

						// 小油品S01001006004001003001
						double cos008 = 0f;
						String cos008_desc = "见油料费、小油品费用测算表";

						String materialValues = mapMaterial.get("date"+mapDateK);
						if(materialValues!=null){
							String oil1 = (String)materialValues.split("_")[0];
							String oil2 = (String)materialValues.split("_")[1];
							String oil3 = (String)materialValues.split("_")[2];
							cos017 = (isNullOrEmpty(oil1)) ? 0f : Double.parseDouble(oil1);
							cos018 = (isNullOrEmpty(oil2)) ? 0f : Double.parseDouble(oil2);
							cos008 = (isNullOrEmpty(oil3)) ? 0f : Double.parseDouble(oil3);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{钻机材料费}", cos017, cos017_desc, projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{汽车材料费}", cos018, cos018_desc, projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{小油品费}", cos008, cos008_desc, projectInfoNo);

						
						// 恢复性修理费
						StringBuffer sqlHFX = new StringBuffer("select   sum(td.restore_repails) restore_repails ,");
						sqlHFX.append(" to_char(sum(td.vehicle_daily_material *(td.plan_end_date - td.plan_start_date + 1) *td.device_count),'9999999999999999.99') sum_vehicle_daily_material, ");
						sqlHFX.append(" to_char(sum(td.drilling_daily_material *(td.plan_end_date - td.plan_start_date + 1) *td.device_count),'9999999999999999.99') sum_drilling_daily_material ");
						sqlHFX.append(" from bgp_op_tartet_device_material td ");
						sqlHFX.append(" where td.bsflag ='0' and td.project_info_no = '" + projectInfoNo + "' and td.if_delete_change is null group by project_info_no ");
						Map mapHFX = pureDao.queryRecordBySQL(sqlHFX.toString());
						// 恢复性修理费用
						double cos019 = 0f;
						String cos019_desc = "见设备材料、恢复性修理费测算表";
						if (mapHFX != null) {
							cos019 = (isNullOrEmpty((String) mapHFX.get("restore_repails"))) ? 0f : Double.parseDouble((String) mapHFX.get("restore_repails"));
						}
						cos019 = cos019 / days;
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{汽车恢复性修理费}", cos019, cos019_desc, projectInfoNo);
						// 汽车恢复性修理费用S01001004001004003
						double cos020 = 0f;
						cos020 = cos020 / days;
						String cos020_desc = "见设备材料、恢复性修理费测算表";
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{钻机恢复性修理费}", cos020, cos020_desc, projectInfoNo);

						StringBuffer sqlMataxi = new StringBuffer(
								"select  sum(decode(t.mataxi_type,'1',to_char((nvl(t.taxi_ratio,0)),'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price1, ");
						sqlMataxi.append(" sum(decode(t.mataxi_type,'2',to_char((nvl(t.taxi_ratio,0)),'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price2, ");
						sqlMataxi.append(" sum(decode(t.mataxi_type, '3', to_char((nvl(t.taxi_ratio,0)),'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price3, ");
						sqlMataxi.append(" sum(decode(t.mataxi_type, '4', to_char(((nvl(t.actual_end_date, to_date(to_char(sysdate, 'yyyy-MM-dd'),'yyyy-MM-dd')) - t.actual_start_date+1-nvl(t.passive_date,0)/2)/(nvl(t.actual_end_date, to_date(to_char(sysdate, 'yyyy-MM-dd'),'yyyy-MM-dd')) - t.actual_start_date+1)) *(nvl(t.taxi_ratio,0)),'9999999999999999.99')*t.dev_count*t.taxi_unit,'0.00')) sum_price4 ");
						sqlMataxi.append(" from bgp_op_target_device_mataxi t ");
						sqlMataxi.append(" where bsflag = '0'  and t.project_info_no = '" + projectInfoNo + "' and t.if_delete_change is null and  t.if_actual_change is null ");
						sqlMataxi.append("  and t.actual_start_date <=to_date('" + currentDate + "','yyyy-MM-dd') and (t.actual_end_date>=to_date('" + currentDate
								+ "','yyyy-MM-dd') or t.actual_end_date is null) and (to_date('" + currentDate + "','yyyy-MM-dd')- to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd'))< 0");

						Map mapMataxi = pureDao.queryRecordBySQL(sqlMataxi.toString());
						
						StringBuffer sqlMatare = new StringBuffer("select to_char(sum(t.taxi_unit * (t.dev_count)),'9999999999999.00') sum_money from BGP_OP_TARGET_DEVICE_MATARE t ");
						sqlMatare.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "' and t.if_delete_change is null and  t.if_actual_change is null ");
						Map mapMatare = pureDao.queryRecordBySQL(sqlMatare.toString());
						
						// 仪器租用费S01001004004002004
						double cos022 = 0f;
						String cos022_desc = "见仪器、专用工具租赁费测算表";
						if (mapMataxi != null) {
							cos022 = (isNullOrEmpty((String) mapMataxi.get("sum_price1"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price1"));
						}
						StringBuffer sb = new StringBuffer("select nvl(sum(nvl(t.person_num,0)*nvl(t.person_money,0)+nvl(other_money,0)),0) total_money ")
						.append(" from bgp_op_target_device_hum t where bsflag='0' and t.if_change ='2' and t.transport_type ='1' ")
						.append(" and t.project_info_no ='").append(projectInfoNo).append("' and t.change_date = to_date('").append(currentDate).append("', 'yyyy-MM-dd')");
						Map human = pureDao.queryRecordBySQL(sb.toString());
						if(human!=null){
							double temp = 0;
							temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
							cos022 = cos022 + temp ;
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{仪器租用费}", cos022, cos022_desc, projectInfoNo);
						// 专用工具租赁费(维修费)S01001004004002001
						double cos023 = 0f;
						double cos023_a = 0f;
						String cos023_desc = "见仪器、专用工具租赁费测算表";
						if (mapMataxi != null) {
							cos023 = (isNullOrEmpty((String) mapMataxi.get("sum_price3"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price3"));
						}
						if (mapMatare != null) {
							cos023_a = (isNullOrEmpty((String) mapMatare.get("sum_money"))) ? 0f : Double.parseDouble((String) mapMatare.get("sum_money"));
						}
						cos023 = cos023 + cos023_a / days;
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{专用工具租用费}", cos023, cos023_desc, projectInfoNo);
						// 震源租用费S01001004004002005
						double cos024 = 0f;
						String cos024_desc = "见震源租赁费测算表";
						if (mapMataxi != null) {
							cos024 = (isNullOrEmpty((String) mapMataxi.get("sum_price4"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price4"));
						}
						sb = new StringBuffer("select nvl(sum(nvl(t.person_num,0)*nvl(t.person_money,0)+nvl(other_money,0)),0) total_money ")
						.append(" from bgp_op_target_device_hum t where bsflag='0' and t.if_change='2' and t.transport_type ='0' ")
						.append(" and t.project_info_no ='").append(projectInfoNo).append("' and t.change_date = to_date('").append(currentDate).append("', 'yyyy-MM-dd')");
						human = pureDao.queryRecordBySQL(sb.toString());
						if(human!=null){
							double temp = 0;
							temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
							cos024 = cos024 + temp ;
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{震源租用费}", cos024, cos024_desc, projectInfoNo);

						// 运载设备租用费S01001004004002003
						double cos026 = 0f;
						String cos026_desc = "见仪器、专用工具租赁费测算表";
						if (mapMataxi != null) {
							cos026 = (isNullOrEmpty((String) mapMataxi.get("sum_price2"))) ? 0f : Double.parseDouble((String) mapMataxi.get("sum_price2"));
						}
						//运载设备费 == 内部租赁费 + 仪器、专用工具租赁费(mataxi_type=2)
						sb = new StringBuffer("select nvl(sum(t.device_count*nvl(t.taxi_unit,0)),0) total_money ")
						.append(" from bgp_op_target_device_rent t where bsflag='0' and t.if_change = '2' ")
						.append(" and t.actual_start_date <= to_date('"+currentDate+"','yyyy-MM-dd') and nvl(t.actual_end_date,sysdate) >= to_date('"+currentDate+"','yyyy-MM-dd')")
						.append(" and t.project_info_no ='").append(projectInfoNo).append("' ");
						human = pureDao.queryRecordBySQL(sb.toString());
						if(human!=null){
							double temp = 0;
							temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
							cos026 = cos026 + temp ;
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{运载设备费}", cos026, cos026_desc, projectInfoNo);

						// 测量服务费S01001004004002002

						StringBuffer sqlMeassist = new StringBuffer(
								"select to_char(sum(t.meassist_money),'99999999999999999999.99') meassist_money from bgp_op_tartet_device_meassist t ");
						sqlMeassist.append(" where bsflag = '0' and t.project_info_no = '" + projectInfoNo + "'  and t.if_delete_change is null and  t.if_actual_change is null");
						Map mapMeassist = pureDao.queryRecordBySQL(sqlMeassist.toString());

						StringBuffer sqlMeasureModify = new StringBuffer("select nvl(nvl(sum(nvl(gd.SHOT_2D_WORKLOAD, 0) + nvl(gd.SHOT_3D_WORKLOAD, 0)), ");
						sqlMeasureModify.append(" 0)*max((select nvl(max(t.price_unit),0) from bgp_op_price_project_info t where t.project_info_no='" + projectInfoNo
								+ "' and t.node_code='S01026')),0) sum_price ");
						sqlMeasureModify.append("from rpt_gp_daily gd where gd.project_info_no = '" + projectInfoNo + "' and gd.send_date = to_date('" + currentDate
								+ "', 'yyyy-MM-dd') ");
						sqlMeasureModify.append("and gd.bsflag = '0'");
						Map mapMeasureModify = pureDao.queryRecordBySQL(sqlMeasureModify.toString());

						double cos025 = 0f;
						String cos025_desc = "见测量服务费测算表";
						double cos025_1 = 0f;
						if (mapMeasureModify != null) {
							cos025_1 = (isNullOrEmpty((String) mapMeasureModify.get("sum_price"))) ? 0f : Double.parseDouble((String) mapMeasureModify.get("sum_price"));
						}
						double cos025_2 = 0f;
						if (mapMeassist != null) {
							cos025_2 = (isNullOrEmpty((String) mapMeassist.get("meassist_money"))) ? 0f : Double.parseDouble((String) mapMeassist.get("meassist_money"));
						}
						cos025 = (cos025_1 + cos025_2/days);
						sb = new StringBuffer("select nvl(sum(nvl(t.person_num,0)*nvl(t.person_money,0)+nvl(other_money,0)),0) total_money ")
						.append(" from bgp_op_target_device_hum t where bsflag='0' and t.if_change ='2' and t.transport_type ='2' ")
						.append(" and t.project_info_no ='").append(projectInfoNo).append("' and t.change_date = to_date('").append(currentDate).append("', 'yyyy-MM-dd')");
						human = pureDao.queryRecordBySQL(sb.toString());
						if(human!=null){
						double temp = 0;
							temp = Double.valueOf(human.get("total_money")==null ||((String)human.get("total_money")).trim().equals("")?"0":(String)human.get("total_money"));
							cos025 = cos025 + temp ;
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{测量服务费}", cos025, cos025_desc, projectInfoNo);

						// 获取钻探材料
						double cos030 = 0f;
						String cos030_desc = "见物资钻探材料";
						String zuantanValues = mapZuantan.get("date"+mapDateK);
						if(zuantanValues!=null){
							cos030 = (isNullOrEmpty(zuantanValues)) ? 0f : Double.parseDouble(zuantanValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{钻探材料}", cos030, cos030_desc, projectInfoNo);

						// 聚乙烯绳及钢纤
						
						double cos027 = 0f;
						String cos027_desc = "见物资聚乙烯绳及钢纤";
						String juYiXiValues = mapJuYiXi.get("date"+mapDateK);
						if(juYiXiValues!=null){
							cos027 = (isNullOrEmpty(juYiXiValues)) ? 0f : Double.parseDouble(juYiXiValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{聚乙烯绳及钢钎}", cos027, cos027_desc, projectInfoNo);

						// 检波器维修材料
						double cos028 = 0f;
						String cos028_desc = "见物资检波器维修材料";
						String jianBoQiValues = mapJianBoQi.get("date"+mapDateK);
						if(jianBoQiValues!=null){
							cos028 = (isNullOrEmpty(jianBoQiValues)) ? 0f : Double.parseDouble(jianBoQiValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{检波器维修材料}", cos028, cos028_desc, projectInfoNo);
						//@todo 只有钻井组发放的洗衣粉放到里面
						// 膨润土
						double cos029 = 0f;
						String cos029_desc = "见物资膨润土";
						String pengRunTuValues = mapPengRunTu.get("date"+mapDateK);
						if(pengRunTuValues!=null){
							cos029 = (isNullOrEmpty(pengRunTuValues)) ? 0f : Double.parseDouble(pengRunTuValues);
						}

						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{膨润土材料}", cos029, cos029_desc, projectInfoNo);

						//炸药
						double cos040 = 0f;
						String cos040_desc = "见炸药";
						String zhayaoValues = mapZhayao.get("date"+mapDateK);
						if(zhayaoValues!=null){
							cos028 = (isNullOrEmpty(zhayaoValues)) ? 0f : Double.parseDouble(zhayaoValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{炸药(物资)}", cos040, cos040_desc, projectInfoNo);
						
						//雷管
						double cos041 = 0f;
						String cos041_desc = "见雷管";
						String leiguanValues = mapLeiguan.get("date"+mapDateK);
						if(leiguanValues!=null){
							cos041 = (isNullOrEmpty(leiguanValues)) ? 0f : Double.parseDouble(leiguanValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{雷管(物资)}", cos041, cos041_desc, projectInfoNo);
						//炮线
						double cos039 = 0f;
						String cos039_desc = "见炮线(物资)";
						String paoxianValues = mapPaoxian.get("date"+mapDateK);
						if(paoxianValues!=null){
							cos039 = (isNullOrEmpty(paoxianValues)) ? 0f : Double.parseDouble(paoxianValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{炮线(物资)}", cos039, cos039_desc, projectInfoNo);
						//磁带
						double cos043 = 0f;
						String cos043_desc = "见磁带(物资)";
						String cidaiValues = mapCidai.get("date"+mapDateK);
						if(cidaiValues!=null){
							cos043 = (isNullOrEmpty(cidaiValues)) ? 0f : Double.parseDouble(cidaiValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{磁带(物资)}", cos043, cos043_desc, projectInfoNo);
						//记录纸
						double cos044 = 0f;
						String cos044_desc = "见记录纸(物资)";
						String jiLuZhiValues = mapJiluzhi.get("date"+mapDateK);
						if(jiLuZhiValues!=null){
							cos044 = (isNullOrEmpty(jiLuZhiValues)) ? 0f : Double.parseDouble(jiLuZhiValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{记录纸(物资)}", cos044, cos044_desc, projectInfoNo);
								
						// 劳保用品
						double cos031 = 0f;
						String cos031_desc = "见劳保用品费用测算表";
						String LabormonValues = mapLabormon.get("date"+mapDateK);
						if(LabormonValues!=null){
							cos031 = (isNullOrEmpty(LabormonValues)) ? 0f : Double.parseDouble(LabormonValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{劳保用品费}", cos031, cos031_desc, projectInfoNo);

						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{其他材料(其他)}", cos031, cos031_desc, projectInfoNo);

						// 营地建设费
						double cos032 = 0f;
						String cos032_desc = "见营地建设";
						String yDJsValues = mapYDJs.get("date"+mapDateK);
						if(yDJsValues!=null){
							cos032 = (isNullOrEmpty(yDJsValues)) ? 0f : Double.parseDouble(yDJsValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{营地建设费}", cos032, cos032_desc, projectInfoNo);

						// 办公用品费
						double cos033 = 0f;
						String cos033_desc = "见办公用品";
						String bGYPValues = mapBGYP.get("date"+mapDateK);
						if(bGYPValues!=null){
							cos033 = (isNullOrEmpty(bGYPValues)) ? 0f : Double.parseDouble(bGYPValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{办公用品费}", cos033, cos033_desc, projectInfoNo);

						// 安全设施费
						double cos036 = 0f;
						String cos036_desc = "见安全设施";
						String aJCValues = mapAJC.get("date"+mapDateK);
						if(aJCValues!=null){
							cos036 = (isNullOrEmpty(aJCValues)) ? 0f : Double.parseDouble(aJCValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{安全设施费}", cos036, cos036_desc, projectInfoNo);

						// 其他材料费
						double cos037 = 0f;
						String cos037_desc = "见其他材料费";
						String qTCLValues = mapQTCL.get("date"+mapDateK);
						if(qTCLValues!=null){
							cos037 = (isNullOrEmpty(qTCLValues)) ? 0f : Double.parseDouble(qTCLValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{其他材料费}", cos037, cos037_desc, projectInfoNo);

						// 低值易耗品
						double cos038 = 0f;
						String cos038_desc = "见低值易耗品";
						String dZYHValues = mapDZYH.get("date"+mapDateK);
						if(dZYHValues!=null){
							cos038 = (isNullOrEmpty(dZYHValues)) ? 0f : Double.parseDouble(dZYHValues);
						}
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{低值易耗品}", cos038, cos038_desc, projectInfoNo);
		
						
						StringBuffer final_sql = new StringBuffer("");
						final_sql.append(" select sum(case when employee_gz='0110000019000000001' then round("+ht_money_per+"/day_num*10000)/10000.0 else 0 end) ht_money, ")
						.append(" sum(case when employee_gz='0110000019000000002' then round("+sc_money_per+"/day_num*10000)/10000.0 else 0 end) sc_money, ")
						.append(" sum(case when employee_gz='0110000059000000005' or employee_gz='0110000059000000002' or employee_gz='0110000059000000003' or ")
						.append(" employee_gz='110000059000000006' then round("+jj_money_per+"/day_num*10000)/10000.0 else 0 end) jj_money, ")
						.append(" sum(case when employee_gz='0110000059000000001' then round("+jy_money_per+"/day_num*10000)/10000.0 else 0 end) jy_money, ")
						.append(" sum(case when employee_gz='0110000019000000001' then round("+ht_bonus_per+"/day_num*10000)/10000.0 else 0 end) ht_bonus, ")
						.append(" sum(case when employee_gz='0110000019000000002' then round("+sc_bonus_per+"/day_num*10000)/10000.0 else 0 end) sc_bonus, ")
						.append(" sum(case when employee_gz='0110000059000000005' or employee_gz='0110000059000000002' or employee_gz='0110000059000000003' or employee_gz='110000059000000006'  ")
						.append(" or employee_gz='0110000059000000001' then round("+jj_bonus_per+"/day_num*10000)/10000.0 else 0 end) jj_bonus ")
						.append(" from(select dd.*,case when nvl(to_date(to_char(dd.end_date,'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(dd.start_date,'yyyy-MM-dd'),'yyyy-MM-dd')+1,0)>"+days+" then "+days+" ")
						.append(" else nvl(to_date(to_char(dd.end_date,'yyyy-MM-dd'),'yyyy-MM-dd')-to_date(to_char(dd.start_date,'yyyy-MM-dd'),'yyyy-MM-dd')+1,0) end day_num  ")
						.append(" from (select tt.*,row_number() over(partition by tt.employee_id order by tt.start_date)row_num   ")
						.append(" from(select h.employee_gz,p.employee_id,e.employee_name,p.task_id, ")
						.append(" case when to_date(to_char(nvl(pa.actual_start_date,pa.planned_start_date),'yyyy-MM-dd'),'yyyy-MM-dd')<to_date('"+planned_start_date+"','yyyy-MM-dd')  ")
						.append(" then to_date('"+planned_start_date+"','yyyy-MM-dd') else to_date(to_char(nvl(pa.actual_start_date,pa.planned_start_date),'yyyy-MM-dd'),'yyyy-MM-dd') end start_date ,  ") 
						.append(" case when to_date(to_char(nvl(pa.actual_finish_date,pa.planned_finish_date),'yyyy-MM-dd'),'yyyy-MM-dd')>to_date('"+planned_end_date+"','yyyy-MM-dd')  ")
						.append(" then to_date('"+planned_end_date+"','yyyy-MM-dd') else to_date(to_char(nvl(pa.actual_finish_date,pa.planned_finish_date),'yyyy-MM-dd'),'yyyy-MM-dd') end end_date  ")
						.append(" from bgp_human_prepare t left join bgp_human_prepare_human_detail d on t.prepare_no = d.prepare_no and d.bsflag ='0'   ")
						.append(" left join bgp_comm_human_receive_process p on d.employee_id = p.employee_id and p.bsflag ='0'   ")
						.append(" join bgp_p6_activity pa on p.task_id = pa.object_id and pa.bsflag ='0'   ")
						.append(" left join comm_human_employee e on d.employee_id = e.employee_id and e.bsflag ='0'   ")
						.append(" left join comm_human_employee_hr h on e.employee_id = h.employee_id and h.bsflag ='0'   ")
						.append(" where t.bsflag ='0' and d.between_param is null and p.task_id is not null and t.project_info_no ='"+projectInfoNo+"' union all  ") 
						.append(" select l.if_engineer,l.labor_id employee_id,l.employee_name,r.task_id,   ")
						.append(" case when to_date(to_char(nvl(pa.actual_start_date,pa.planned_start_date),'yyyy-MM-dd'),'yyyy-MM-dd')<to_date('2013-2-27','yyyy-MM-dd')  ")
						.append(" then to_date('2013-2-27','yyyy-MM-dd') else to_date(to_char(nvl(pa.actual_start_date,pa.planned_start_date),'yyyy-MM-dd'),'yyyy-MM-dd') end start_date , ")  
						.append(" case when to_date(to_char(nvl(pa.actual_finish_date,pa.planned_finish_date),'yyyy-MM-dd'),'yyyy-MM-dd')>to_date('2013-4-25','yyyy-MM-dd')  ")
						.append(" then to_date('2013-4-25','yyyy-MM-dd') else to_date(to_char(nvl(pa.actual_finish_date,pa.planned_finish_date),'yyyy-MM-dd'),'yyyy-MM-dd') end end_date  ")
						.append(" from bgp_comm_human_labor_deploy t left join bgp_comm_human_deploy_detail d on t.labor_deploy_id = d.labor_deploy_id and d.bsflag = '0'  ")   
						.append(" left join bgp_comm_human_receive_labor r on d.deploy_detail_id = r.deploy_detail_id and r.bsflag ='0'   ")
						.append(" join bgp_p6_activity pa on r.task_id = pa.object_id and pa.bsflag ='0'   ")
						.append(" left join bgp_comm_human_labor l on t.labor_id = l.labor_id and l.bsflag='0'   ")
						.append(" where t.bsflag ='0' and t.between_param  is null and r.task_id is not null   ") 
						.append(" and t.project_info_no ='"+projectInfoNo+"')tt)dd where dd.row_num=1 ")
						.append(" and to_date(to_char(dd.start_date,'yyyy-MM-dd'),'yyyy-MM-dd')<=to_date('"+currentDate+"','yyyy-MM-dd') ")   
						.append(" and to_date(to_char(dd.end_date,'yyyy-MM-dd'),'yyyy-MM-dd')>=to_date('"+currentDate+"','yyyy-MM-dd')) ");

						money_map = pureDao.queryRecordBySQL(final_sql.toString()); 
						
						double htGz = money_map==null || money_map.get("ht_money")==null || ((String)money_map.get("ht_money")).trim().equals("")?0:Double.valueOf((String)money_map.get("ht_money"));
						double scGz = money_map==null || money_map.get("sc_money")==null ||((String)money_map.get("sc_money")).trim().equals("")?0:Double.valueOf((String)money_map.get("sc_money"));
						double jjGz = money_map==null || money_map.get("jj_money")==null ||((String)money_map.get("jj_money")).trim().equals("")?0:Double.valueOf((String)money_map.get("jj_money"));
						double zjyGz = money_map==null || money_map.get("jy_money")==null ||((String)money_map.get("jy_money")).trim().equals("")?0:Double.valueOf((String)money_map.get("jy_money"));
						double htWc = money_map==null || money_map.get("ht_bonus")==null ||((String)money_map.get("ht_bonus")).trim().equals("")?0:Double.valueOf((String)money_map.get("ht_bonus"));
						double scWc = money_map==null || money_map.get("sc_bonus")==null ||((String)money_map.get("sc_bonus")).trim().equals("")?0:Double.valueOf((String)money_map.get("sc_bonus"));
						double jjWc = money_map==null || money_map.get("jj_bonus")==null ||((String)money_map.get("jj_bonus")).trim().equals("")?0:Double.valueOf((String)money_map.get("jj_bonus"));
						
						// 获取风险奖励
						double DfengxianMoney = isNullOrEmpty(fengxianMoney) ? 0f : Double.parseDouble(fengxianMoney);
						OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{合同化员工工资}", htGz, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{市场化员工工资}", scGz, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{季节工工资}", jjGz, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{钻井人工工资}", 0, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{再就业人员工资}", zjyGz, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{合同化误餐费}", htWc, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{市场化误餐费}", scWc, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{移动通讯费}", 0, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{其他人工费}", jjWc, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfPlan(mapBasicInfo, "{职工工资}", htGz + scGz + DfengxianMoney, "", projectInfoNo);
						
						
						//获取分摊折旧费
						double cost055=0f;
						if(mapFTDepre!=null){
							cost055=Double.parseDouble((mapFTDepre.get("money")==null||"".equals(mapFTDepre.get("money"))?"0":(String)mapFTDepre.get("money")));
						}
						
						cost055=Math.round(cost055/days*100)/100.0;
						
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{分摊折旧费}", cost055, "", projectInfoNo);
						
						// 获取项目各项技术指标
						String project001Values = mapProject001.get("date"+mapDateK);
						double dTech004_a = 0f;
						double dTech004_b = 0f;
						double dTech004_c = 0f;
						double dWorkLoad = 0f;

						if(project001Values!=null){
							String tech004_a = project001Values.split("_")[0];
							String tech004_b = project001Values.split("_")[1];
							String tech004_c = project001Values.split("_")[2];
							String workLoad = project001Values.split("_")[3];
							dTech004_a = (isNullOrEmpty(tech004_a)) ? 0f : Double.parseDouble(tech004_a);
							dTech004_b = (isNullOrEmpty(tech004_b)) ? 0f : Double.parseDouble(tech004_b);
							dTech004_c = (isNullOrEmpty(tech004_c)) ? 0f : Double.parseDouble(tech004_c);
							dWorkLoad = (isNullOrEmpty(workLoad)) ? 0f : Double.parseDouble(workLoad);
							
						}

						String dailyMicroMeasuePointNum="";
						String project003Values = mapProject003.get("date"+mapDateK);
						if(project003Values!=null){
							dailyMicroMeasuePointNum = project003Values == null ? "" :project003Values;// 微测井个数
						}
						
					
						String tech008 = map == null ? "" : (String) map.get("tech_008");// 接受道数
						String tech019 = map == null ? "" : (String) map.get("tech_019");// 检波器串数

						double dTech008 = isNullOrEmpty(tech008) ? 0f : Double.parseDouble(tech008);
						double dTech019 = isNullOrEmpty(tech019) ? 0f : Double.parseDouble(tech019);


						double ddailyMicroMeasuePointNum = isNullOrEmpty(dailyMicroMeasuePointNum) ? 0f : Double.parseDouble(dailyMicroMeasuePointNum);

						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{钻井炮数}", dTech004_b, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{采集炮数}", dTech004_a, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{采集生产天}", 1, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{项目周期天}", 1, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{项目工作量}", dWorkLoad, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{当天测量公里数}", dTech004_c, "", projectInfoNo);
						swgzl += dWorkLoad;
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{微测井个数}", ddailyMicroMeasuePointNum, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{接收道数}", dTech008, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{检波器串数}", dTech019, "", projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{采集电瓶数}", 0, "", projectInfoNo);

						// 获取单价库信息

						if (listPriceUnit != null) {
							for (Map mapPriceUnit : listPriceUnit) {
								OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, (String) mapPriceUnit.get("price_name"),
										Double.parseDouble((String) mapPriceUnit.get("price_unit")), "", projectInfoNo);
							}
						}

						// 开始基础数据的四则运算
						DecimalFormat df = new DecimalFormat("0.00");
						StringBuffer temsql = new StringBuffer("select pi.node_code,pi.gp_target_project_id,pd.actual_detail_id,pd.cost_detail_money,pd.cost_detail_desc from bgp_op_target_project_info pi ");
						temsql.append(" left outer join bgp_op_actual_project_detail pd on pi.gp_target_project_id = pd.gp_target_project_id and pd.bsflag='0' and pd.occur_date=to_date('"
								+ currentDate + "','yyyy-MM-dd')");
						temsql.append(" where pi.project_info_no= '" + projectInfoNo + "' and pi.bsflag='0' ");
						List temBaseList = pureDao.queryRecords(temsql.toString());

						for (Map mapFormula : listFormula) {
							String formulaContent = (String) mapFormula.get("formula_text");
							String nodeCode = (String) mapFormula.get("node_code");
							double formulaValue = OPCommonUtil.getFormulaDataByBasicInfo(mapBasicInfo, formulaContent);
							String formulaDesc = OPCommonUtil.getFormulaDescByBasicInfo(mapBasicInfo, formulaContent);
							
							for(int b=0;b<temBaseList.size();b++){
								Map tempMap = (Map) temBaseList.get(b);
								String tempNodeCode = (String) tempMap.get("node_code");
								if(tempNodeCode.equals(nodeCode)){
									String sqlInsert = "insert into bgp_op_actual_project_detail (actual_detail_id,gp_target_project_id,cost_detail_money,cost_detail_desc,bsflag,create_date,modifi_date,occur_date) "
										+ "(select sys_guid(),'{gp_target_project_id}',{cost_detail_money},{cost_detail_desc},'0',sysdate,sysdate,to_date('"
										+ currentDate
										+ "','yyyy-MM-dd') from dual)";
									String sqlUpdate = "update bgp_op_actual_project_detail set cost_detail_money = {cost_detail_money},cost_detail_desc={cost_detail_desc} where actual_detail_id='{actual_detail_id}'";
									
									String actualDetailId = (String) tempMap.get("actual_detail_id");
									if (actualDetailId != null && !"".equals(actualDetailId)) {
										sqlUpdate = sqlUpdate.replace("{cost_detail_money}", "to_number('" + df.format(formulaValue) + "')");
										sqlUpdate = sqlUpdate.replace("{cost_detail_desc}", formulaDesc == null ? "null" : "'" + formulaDesc + "'");
										sqlUpdate = sqlUpdate.replace("{actual_detail_id}", actualDetailId);
										list.add(sqlUpdate);
									} else {
										sqlInsert = sqlInsert.replace("{gp_target_project_id}", (String) tempMap.get("gp_target_project_id"));
										sqlInsert = sqlInsert.replace("{cost_detail_money}", "to_number('" + df.format(formulaValue) + "')");
										sqlInsert = sqlInsert.replace("{cost_detail_desc}", formulaDesc == null ? "null" : "'" + formulaDesc + "'");
										list.add(sqlInsert);
									}
									break;
								}
							}
							
						}
						System.out.println("-------11111111111111111-----111--122--1111111111----------"+new Date());
						if (list != null && list.size() > 0) {
							jdbcTemplate.batchUpdate(OPCommonUtil.getStringFromList(list));
						}
						System.out.println("-------11111111111111111------22222222222222222------------"+new Date());

						list = new ArrayList<String>();
						// 采集价值工作量 采集直接费用 增值税附加税 非施工期费用 机关及辅助单位费用 靠前支持费 上级管理费 勘探项目成本

						StringBuffer sqlProject002 = new StringBuffer("select nvl(sum(nvl(gd.DAILY_FINISHING_2D_SP,0) + nvl(gd.DAILY_FINISHING_3D_SP,0)), 0) acquire_sp, ");
						sqlProject002.append(" nvl(sum(nvl(gd.daily_2d_total_shot,0) + nvl(gd.daily_3d_total_shot,0)), 0) drilly_sp, ");
						sqlProject002.append(" nvl(sum(nvl(gd.finish_3d_workload,0) + nvl(gd.finish_2d_workload,0)), 0) work_load from rpt_gp_daily gd ");
						sqlProject002.append(" where gd.project_info_no = '" + projectInfoNo + "'   ");
						sqlProject002.append(" and gd.bsflag = '0' ");
						Map mapProject002 = pureDao.queryRecordBySQL(sqlProject002.toString());

						String tech004_d = mapProject002 == null ? "" : (String) mapProject002.get("acquire_sp");// 当天采集炮数
						double dTech004_d = isNullOrEmpty(tech004_d) ? 0f : Double.parseDouble(tech004_d);
						String workLoad_d = mapProject002 == null ? "" : (String) mapProject002.get("work_load");// 当天
						double dWorkLoad_d = isNullOrEmpty(workLoad_d) ? 0f : Double.parseDouble(workLoad_d);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{采集炮数}", dTech004_d, null, projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{项目工作量}", dWorkLoad_d, null, projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{采集直接费用}", collection, null, projectInfoNo);
						// 项目价值工作量S01008
						double cos034 = 0f;
						cos034 = dWorkLoad;
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{实物工作量}", cos034, null, projectInfoNo);
						// 处理解释费S01009
						double cos035 = 0f;
						cos035 = dWorkLoad;
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{项目价值工作量}", 0, null, projectInfoNo);
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{处理解释费}", cos035, null, projectInfoNo);
						// 采集价值工作量S01010
						double cos042 = 0f;
						cos042 = cos034 - cos035;
						OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{采集价值工作量}", cos042, null, projectInfoNo);



						for (Map mapFormulaOther : listFormulaOther) {
							String formulaContent = (String) mapFormulaOther.get("formula_content");
							String nodeCode = (String) mapFormulaOther.get("node_code");
							String costName = (String) mapFormulaOther.get("cost_name");
							double formulaValue = OPCommonUtil.getFormulaDataByBasicInfo(mapBasicInfo, formulaContent);
							String formulaDesc = OPCommonUtil.getFormulaDescByBasicInfo(mapBasicInfo, formulaContent);
							
							for(int b=0;b<temBaseList.size();b++){
								Map tempMap = (Map) temBaseList.get(b);
								String tempNodeCode = (String) tempMap.get("node_code");
								if(tempNodeCode.equals(nodeCode)){
									String actualDetailId = (String) tempMap.get("actual_detail_id");
									
									String sqlInsert = "insert into bgp_op_actual_project_detail (actual_detail_id,gp_target_project_id,cost_detail_money,cost_detail_desc,bsflag,create_date,modifi_date,occur_date) "
										+ "(select sys_guid(),'{gp_target_project_id}',{cost_detail_money},{cost_detail_desc},'0',sysdate,sysdate,to_date('"
										+ currentDate
										+ "','yyyy-MM-dd') from dual)";
									String sqlUpdate = "update bgp_op_actual_project_detail set cost_detail_money = {cost_detail_money},cost_detail_desc={cost_detail_desc} where actual_detail_id='{actual_detail_id}'";
								
									if (actualDetailId != null && !"".equals(actualDetailId)) {
										sqlUpdate = sqlUpdate.replace("{cost_detail_money}", "to_number('" + df.format(formulaValue) + "')");
										sqlUpdate = sqlUpdate.replace("{cost_detail_desc}", formulaDesc == null ? "null" : "'" + formulaDesc + "'");
										sqlUpdate = sqlUpdate.replace("{actual_detail_id}", actualDetailId);
										list.add(sqlUpdate);
									} else {
										sqlInsert = sqlInsert.replace("{gp_target_project_id}", (String) tempMap.get("gp_target_project_id"));
										sqlInsert = sqlInsert.replace("{cost_detail_money}", "to_number('" + df.format(formulaValue) + "')");
										sqlInsert = sqlInsert.replace("{cost_detail_desc}", formulaDesc == null ? "null" : "'" + formulaDesc + "'");
										list.add(sqlInsert);
									}
									break;
								}
							}
							
							OPCommonUtil.setFormulaBasicInfoOfActual(mapBasicInfo, "{" + costName + "}", formulaValue, null, projectInfoNo);
						}
						if (list != null && list.size() > 0) {
							jdbcTemplate.batchUpdate(OPCommonUtil.getStringFromList(list));
						}

					}
					startdate = DateUtils.addDays(startdate, 1);
				}
				String deltetSqlV = "delete VIEW_OP_TARGET_ACTUAL_MONEYS where PROJECT_INFO_NO='"+projectInfoNo+"'";
				jdbcTemplate.execute(deltetSqlV);
				String selectInfo ="select opi.project_info_no,   opi.gp_target_project_id,  opi.template_id, opi.cost_name, opi.order_code, opi.node_code,  opi.parent_id, opi.formula_type, opi.formula_content,opi.formula_content_a,opi.bsflag,opi.cost_desc,opi.spare3 "
															+" from bgp_op_target_project_info opi where opi.PROJECT_INFO_NO='"+projectInfoNo+"' and opi.BSFLAG='0'";
				List listInfo = pureDao.queryRecords(selectInfo);
				if(listInfo!=null){
					List Vlist = new ArrayList<String>();

					for(int k=0;k<listInfo.size();k++){
						Map mapInfo = (Map)listInfo.get(k);
						String node_code = (String)mapInfo.get("node_code");
						String getcostDetailMoney = "select sum(t1.cost_detail_money) costDetailMoney from BGP_OP_ACTUAL_PROJECT_DETAIL t1  inner join bgp_op_target_project_info t2"+
						  " on t1.gp_target_project_id=t2.gp_target_project_id and t2.bsflag='0'"+
						  " where t2.project_info_no = '"+projectInfoNo+"'   and t2.node_code like concat('"+node_code+"', '%')  and t1.bsflag='0' ";
						Map moneyMap = pureDao.queryRecordBySQL(getcostDetailMoney);
						double costDetailMoney=0f;
						if(moneyMap!=null){
							String tempy = (String)moneyMap.get("costdetailmoney");
							if(tempy!=null&&!"".equals(tempy)){
								costDetailMoney = Double.parseDouble(tempy);
							}
						}

						  String project_info_no =(String) mapInfo.get("project_info_no");
						  String gp_target_project_id= (String)mapInfo.get("gp_target_project_id");
						  String template_id=(String) mapInfo.get("template_id");
						  String cost_name= (String)mapInfo.get("cost_name");
						  String order_code=(String) mapInfo.get("order_code");
						  String parent_id= (String)mapInfo.get("parent_id");
						  String formula_type= (String)mapInfo.get("formula_type");
						  String formula_content=(String) mapInfo.get("formula_content");
						  String formula_content_a= (String)mapInfo.get("formula_content_a");
						  String bsflag= (String)mapInfo.get("bsflag");
						  String cost_desc= (String)mapInfo.get("cost_desc");
						  String spare3= (String)mapInfo.get("spare3");
						//pureDao.saveOrUpdateEntity(map, "VIEW_OP_TARGET_ACTUAL_MONEYS");
						  String inserV="INSERT INTO VIEW_OP_TARGET_ACTUAL_MONEYS(GP_TARGET_PROJECT_ID,          PROJECT_INFO_NO, TEMPLATE_ID,       COST_NAME,         ORDER_CODE, NODE_CODE,       PARENT_ID,              FORMULA_TYPE, FORMULA_CONTENT, FORMULA_CONTENT_A, BSFLAG, COST_DESC, SPARE3, COST_DETAIL_MONEY) "+
						  													" VALUES('"+gp_target_project_id+"', '"+project_info_no+"', '"+template_id+"', '"+cost_name+"', "+order_code+", '"+node_code+"', '"+parent_id+"', '"+formula_type+"', '"+formula_content+"', '"+formula_content_a+"', '0', '"+cost_desc+"', '"+spare3+"', "+costDetailMoney+")";
						  Vlist.add(inserV);
					}
					if (Vlist != null && Vlist.size() > 0) {
						jdbcTemplate.batchUpdate(OPCommonUtil.getStringFromList(Vlist));
					}
					System.out.println("-------end------22222222222222222------------"+new Date());

				}
			}	
		}
		return responseDTO;
	}

	/*
	 * 初始化技术指标变更表值
	 */
	public ISrvMsg initIndicatoChange(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String tartgetBasicId = reqDTO.getValue("tartget_basic_id");
		String sql = "select count(1) num from  BGP_OP_TARGET_INDICATO_CHANGE where bsflag='0' and tartget_basic_id='" + tartgetBasicId + "'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		if (map == null || "0".equals(map.get("num"))) {
			String sqlQuery = "select * from BGP_OP_TARGET_PROJECT_INDICATO where bsflag='0' and tartget_basic_id='" + tartgetBasicId + "'";
			List<Map> list = pureDao.queryRecords(sqlQuery);
			for (Map mapSave : list) {
				pureDao.saveOrUpdateEntity(mapSave, "bgp_op_target_indicato_change");
			}
		}
		return responseDTO;
	}

	/*
	 * 获取专用工具修理费信息
	 */
	public ISrvMsg getReportInoutInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("select t.*,decode(t.cost_type,'0','收入','1','支出') cost_type_name from BGP_OP_REPORT_INOUT_INFO t where  t.bsflag='0'");
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql.toString());
		return responseDTO;
	}

	/*
	 * 保存报表科目模板
	 */
	public ISrvMsg saveReportTemplateData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String template_id = reqDTO.getValue("report_template_id");
		String parent_id = reqDTO.getValue("parent_id");
		String cost_name = reqDTO.getValue("cost_name");
		String cost_type = reqDTO.getValue("cost_type");
		if (cost_name != null && !"".equals(cost_name)) {
			cost_name = URLDecoder.decode(cost_name, "UTF-8");
		}
		Map map = reqDTO.toMap();
		map.put("cost_name", cost_name);
		map.put("bsflag", "0");

		// 计算order并自动生成编码
		if (template_id == null || "".equals(template_id)) {
			// 计算order
			int index = OPCommonUtil.getOrderOfTreeDisplay("bgp_op_report_template", parent_id);
			map.put("order_code", index);
			// 计算自动编码
			String nodeCode = OPCommonUtil.getCodeNodeByAutoGen("bgp_op_report_template", "report_template_id", parent_id, cost_type);
			map.put("node_code", nodeCode);
		}
		pureDao.saveOrUpdateEntity(map, "bgp_op_report_template");
		responseDTO.setValue("success", true);
		return responseDTO;
	}

	/*
	 * 获取报表科目模板信息，返回json串
	 */

	public ISrvMsg getReportTemplate(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String costType = reqDTO.getValue("costType");

		StringBuffer sqlBuffer = new StringBuffer("select connect_by_root(report_template_id) root,level, ");
		sqlBuffer.append("decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf,sys_connect_by_path(report_template_id, '/') path, ");
		sqlBuffer.append("cost_name,report_template_id,parent_id,parent_id zip,order_code ");
		sqlBuffer.append("from (select report_template_id, cost_name, parent_id,order_code from bgp_op_report_template where bsflag='0'");
		sqlBuffer.append(") ");
		sqlBuffer.append("start with parent_id = '" + costType + "' connect by prior report_template_id = parent_id   order by parent_id ,order_code asc ");
		List list = jdbcDao.queryRecords(sqlBuffer.toString());

		Map map = new HashMap();
		map.put("reportTemplateId", costType);
		map.put("parentId", "root");
		map.put("costName", "东方地球物理公司");
		map.put("costDesc", "");
		map.put("expanded", "true");
		map.put("zip", "root");
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "reportTemplateId", "parentId", map);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}

	/*
	 * 保存费用模板拖拽顺序数据
	 */
	public ISrvMsg saveReportTemplateOrder(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		OPCommonUtil.setOrderOfTreeDragDrop("bgp_op_report_template", "reportTemplateId", reqDTO);
		return responseDTO;
	}

	// ==============================〉〉仪表盘开始
	/*
	 * 获取公司收入情况
	 */
	public ISrvMsg getCompanyIncomeInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId=reqDTO.getValue("orgSubjectionId");
		if(orgSubjectionId==null || orgSubjectionId.trim().equals("")){
			orgSubjectionId = user.getSubOrgIDofAffordOrg();
		}
		StringBuffer sql = new StringBuffer("with temp_rq as (select add_months(to_date(to_char(sysdate, 'yyyy') || '0101', 'yyyymmdd') - 1,  rownum) d_month from dual connect by rownum < 13), "); 
		sql.append(" op_price as (select max((case NODE_CODE when 'S01021' then price_unit else 0 end)) - max((case NODE_CODE when 'S01022' then price_unit else 0 end)) price_unit, project_info_no ");  
		sql.append(" from bgp_op_price_project_info where bsflag='0' group by project_info_no) "); 
		sql.append(" select to_number(to_char(dd.d_month,'MM'))||'月' monthtime ,dd.* from( "); 
		sql.append(" select tr.d_month, to_number(to_char(sum(pr.w_price), '99999990.00')) actual_price,  "); 
		sql.append(" to_number(to_char(sum(pp.w_price), '99999990.00')) old_price from temp_rq tr ");
		sql.append(" left outer join (select decode(gp.EXPLORATION_METHOD, '0300100012000000003', gd.finish_3d_workload, '0300100012000000002', gd.finish_2d_workload) *  "); 
		sql.append("   nvl(pi.price_unit, 0) / 10000 w_price, gd.project_info_no, gd.send_date　 from rpt_gp_daily gd  "); 
		sql.append("   left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no and gp.bsflag ='0'  "); 
		sql.append("   left outer join op_price pi on gd.project_info_no =  pi.project_info_no  "); 
		sql.append("   where gd.bsflag = '0' and gp.bsflag='0' and gd.org_subjection_id like '").append(orgSubjectionId).append("%'  ");  
		sql.append("   and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy')) pr on tr.d_month >= pr.send_date "); 
		sql.append(" left outer join (select decode(gp.EXPLORATION_METHOD,  '0300100012000000003', gd.finish_3d_workload, '0300100012000000002',gd.finish_2d_workload) * ");  
		sql.append("   nvl(pi.price_unit, 0) / 10000 w_price, gd.project_info_no, gd.send_date　 from rpt_gp_daily gd "); 
		sql.append("   left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no and gp.bsflag ='0'  "); 
		sql.append("   left outer join op_price pi on gd.project_info_no = pi.project_info_no "); 
		sql.append("   where gd.bsflag = '0'  and gd.org_subjection_id like '").append(orgSubjectionId).append("%' "); 
		sql.append("   and to_char(gd.send_date,'yyyy') = to_char(to_number(to_char(sysdate,'yyyy'))-1,'9999') "); 
		sql.append("   and to_char(gd.send_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) pp on add_months(tr.d_month, -12) = pp.send_date "); 
		sql.append(" group by tr.d_month order by d_month )dd  "); 
		System.out.println(sql.toString());
		String sqlIndex = "select NVL(sum(nvl(t.money,0)),0) money from  BGP_OP_COST_INCOME_INDEX t where t.year=to_char(sysdate,'yyyy') and t.type='0' and org_info like '"+orgSubjectionId+"%'";
		Map mapIndex = pureDao.queryRecordBySQL(sqlIndex);
		double money = mapIndex==null?0:Double.parseDouble((String) mapIndex.get("money"))/10000.0;
		DecimalFormat df = new DecimalFormat(".##");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");
		root.addAttribute("yAxisMaxValue ", df.format(money));

		Element trendlines = root.addElement("trendlines");
		Element line = trendlines.addElement("line");
		line.addAttribute("color", LineCColor);
		line.addAttribute("valueOnRight", "1");
		line.addAttribute("dashed", "1");
		line.addAttribute("thickness", "2");
		line.addAttribute("startValue", df.format(money));
		line.addAttribute("displayValue", df.format(money));

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "去年");

		dataset1.addAttribute("color", LineAColor);
		dataset2.addAttribute("color", LineBColor);

		for (Map map : list) {
			Element categoriesTemp = categories.addElement("category");
			categoriesTemp.addAttribute("label", (String) map.get("monthtime"));
			String dMonth = (String) map.get("monthtime");
			dMonth = dMonth.replaceAll("月", "");
			if (new Date().getMonth() + 1 >= Integer.parseInt(dMonth)) {
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", (String) map.get("actual_price"));
				Element set2 = dataset2.addElement("set");
				set2.addAttribute("value", (String) map.get("old_price"));
				set1.addAttribute("anchorBgColor", LineAColor);
				set2.addAttribute("anchorBgColor", LineBColor);
				set1.addAttribute("link", "j-drillgssr-" + (String) map.get("d_month"));
				if (map.equals(list.get(new Date().getMonth()))) {
					set1.addAttribute("showValue", "1");
					set2.addAttribute("showValue", "1");
				}
			}

		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:公司支出同比折线图
	 */
	public ISrvMsg getOutcomeCompareYearInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String orgSubjectionId=reqDTO.getValue("orgSubjectionId");
		orgSubjectionId=(orgSubjectionId==null||"".equals(orgSubjectionId))?"C105":orgSubjectionId;
		
		StringBuffer sql = new StringBuffer("with temp_rq as (select add_months(to_date(to_char(sysdate, 'yyyy') || '0101', 'yyyymmdd') - 1,  rownum) d_month from dual ");
		sql.append(" connect by rownum < 13) ");
		sql.append(" select to_number(to_char(d_month, 'mm')) || '月' month,d_month, ");
		sql.append(" TO_CHAR(sum(nvl(wl.w_price, 0)) over(order by to_char(d_month, 'mm') asc)/10000,'99999999999999.00') now_price, ");
		sql.append(" TO_CHAR(sum(nvl(wz.w_price, 0)) over(order by to_char(d_month, 'mm') asc)/10000,'99999999999999.00') old_price ");
		sql.append(" from temp_rq rq ");
		sql.append(" left outer join (select sum(pd.cost_detail_money) w_price, to_char(pd.occur_date, 'yyyymm') m_month ");
		sql.append(" from bgp_op_target_project_info t1 inner join  bgp_op_actual_project_detail pd  on t1.gp_target_project_id = pd.gp_target_project_id ");
		sql.append(" where t1.node_code like 'S01001%' and to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pd.bsflag = '0'  ");
		sql.append(" AND  T1.PROJECT_INFO_NO IN (SELECT PROJECT_INFO_NO FROM view_op_project_info WHERE org_subjection_id LIKE '"+orgSubjectionId+"%') group by to_char(pd.occur_date, 'yyyymm') ) wl ");
		sql.append(" on to_char(rq.d_month, 'yyyymm') = wl.m_month ");
		sql.append(" left outer join (select sum(pd.cost_detail_money) w_price, to_char(pd.occur_date, 'yyyymm') m_month from  ");
		sql.append(" bgp_op_target_project_info t1 inner join  bgp_op_actual_project_detail pd  on t1.gp_target_project_id = pd.gp_target_project_id ");
		sql.append(" where t1.node_code like 'S01001%' and to_char(pd.occur_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy') and pd.bsflag = '0' ");
		sql.append("  AND T1.PROJECT_INFO_NO IN (SELECT PROJECT_INFO_NO FROM view_op_project_info WHERE org_subjection_id LIKE '"+orgSubjectionId+"%') ");
		sql.append(" group by to_char(pd.occur_date, 'yyyymm')) wz on to_char(add_months(rq.d_month, -12), 'yyyymm') = wz.m_month ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");
		root.addAttribute("showLimits", "1");
		

		String sqlIndex = "select NVL(sum(nvl(t.money,0)),0) money from  BGP_OP_COST_INCOME_INDEX t where t.year=to_char(sysdate,'yyyy') and t.type='1' and org_info like '"+orgSubjectionId+"%'";
		Map mapIndex = pureDao.queryRecordBySQL(sqlIndex);
		double moneyIncome = mapIndex==null?0:Double.parseDouble((String) mapIndex.get("money"))/10000.0;
		String sqlLirun = "select NVL(sum(nvl(t.money,0)),0) money from  BGP_OP_COST_INCOME_INDEX t where t.year=to_char(sysdate,'yyyy') and t.type='0' and org_info like '"+orgSubjectionId+"%'";
		Map mapLirun = pureDao.queryRecordBySQL(sqlLirun);
		double moneyLirun = mapLirun==null?0:Double.parseDouble((String) mapLirun.get("money"))/10000.0;
		DecimalFormat df = new DecimalFormat(".##");

		Element trendlines = root.addElement("trendlines");
		Element line = trendlines.addElement("line");
		line.addAttribute("color", LineCColor);
		line.addAttribute("valueOnRight", "1");
		line.addAttribute("dashed", "1");
		line.addAttribute("thickness", "2");
		line.addAttribute("startValue", df.format(moneyLirun - moneyIncome));
		line.addAttribute("displayValue", df.format(moneyLirun - moneyIncome));
		
		root.addAttribute("yAxisMaxValue", df.format(moneyLirun - moneyIncome));
		
		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "去年");

		dataset1.addAttribute("color", LineAColor);
		dataset2.addAttribute("color", LineBColor);

		for (Map map : list) {
			Element categoriesTemp = categories.addElement("category");
			categoriesTemp.addAttribute("label", (String) map.get("month"));
			String dMonth = (String) map.get("month");
			dMonth = dMonth.replaceAll("月", "");
			if (new Date().getMonth() + 1 >= Integer.parseInt(dMonth)) {
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", (String) map.get("now_price"));
				Element set2 = dataset2.addElement("set");
				set2.addAttribute("value", (String) map.get("old_price"));
				set1.addAttribute("link", "j-drillgszc-" + (String) map.get("d_month"));
				set1.addAttribute("anchorBgColor", LineAColor);
				set2.addAttribute("anchorBgColor", LineBColor);
				if (map.equals(list.get(new Date().getMonth()))) {
					set1.addAttribute("showValue", "1");
					set2.addAttribute("showValue", "1");
				}
			}
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 获取公司利润情况
	 */
	public ISrvMsg getCompanyProfitInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String orgSubjectionId=reqDTO.getValue("orgSubjectionId");
		orgSubjectionId=(orgSubjectionId==null||"".equals(orgSubjectionId))?"C105":orgSubjectionId;
		
		
		StringBuffer sql = new StringBuffer("with temp_rq as (select add_months(to_date(to_char(sysdate, 'yyyy') || '0101', 'yyyymmdd') - 1,  rownum) d_month from dual ");
		sql.append(" connect by rownum < 13),     op_price as (select max((case NODE_CODE when 'S01021' then price_unit else 0 end)) - max((case NODE_CODE when 'S01022' then price_unit else 0 end)) price_unit, project_info_no  from bgp_op_price_project_info where bsflag='0' group by project_info_no)"
				+ " select month || '月' monthtime, d_month, nvl(actual_price,0) actual_price, nvl(old_price,0) old_price  ");
		sql.append(" from (select to_number(to_char(d_month, 'MM')) 　month,d_month, max(actual_price) actual_price,max(old_price) old_price ");
		sql.append(" from (select tr.d_month, to_number(to_char(sum(pr.w_price), '99999990.00')) actual_price, ");
		sql.append(" to_number(to_char(sum(pp.w_price), '99999990.00')) old_price from temp_rq tr　 ");
		sql.append(" left outer join (select decode(gp.EXPLORATION_METHOD, '0300100012000000003', gd.finish_3d_workload, '0300100012000000002', gd.finish_2d_workload) * ");
		sql.append(" nvl(pi.price_unit, 0) / 10000 w_price, gd.project_info_no, gd.send_date　 from rpt_gp_daily gd ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no and gp.bsflag ='0'");
		sql.append(" left outer join op_price pi on gd.project_info_no =  pi.project_info_no  　 ");
		sql.append(" where gd.bsflag = '0'  and gd.org_subjection_id like '"+orgSubjectionId+"%'  and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy')) pr on tr.d_month >= pr.send_date　 ");
		sql.append(" left outer join (select decode(gp.EXPLORATION_METHOD,  '0300100012000000003', gd.finish_3d_workload, '0300100012000000002',gd.finish_2d_workload) * ");
		sql.append(" nvl(pi.price_unit, 0) / 10000 w_price, gd.project_info_no, gd.send_date　 from rpt_gp_daily gd ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no and gp.bsflag ='0' ");
		sql.append(" left outer join op_price pi on gd.project_info_no = pi.project_info_no ");
		sql.append(" where gd.bsflag = '0'  and gd.org_subjection_id like '"+orgSubjectionId+"%'  and to_char(gd.send_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) pp ");
		sql.append(" on add_months(tr.d_month, -12) = pp.send_date　 group by tr.d_month) m group by d_month ) order by　month ");

		String sqlIndex = "select NVL(sum(nvl(t.money,0)),0) money from  BGP_OP_COST_INCOME_INDEX t where t.year=to_char(sysdate,'yyyy') and t.type='1' and org_info like '"+orgSubjectionId+"%'";
		Map mapIndex = pureDao.queryRecordBySQL(sqlIndex);
		double money = mapIndex==null?0:Double.parseDouble((String) mapIndex.get("money"))/10000.0;
		DecimalFormat df = new DecimalFormat(".##");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> listIncome = jdbcDAO.queryRecords(sql.toString());

		StringBuffer sqlOutcome = new StringBuffer("with temp_rq as (select add_months(to_date(to_char(sysdate, 'yyyy') || '0101', 'yyyymmdd') - 1, rownum) d_month FROM DUAL ");
		sqlOutcome.append(" connect by rownum < 13) ");
		sqlOutcome.append(" select to_number(to_char(d_month, 'mm')) || '月' month,d_month, ");
		sqlOutcome.append(" TO_CHAR(sum(nvl(wl.w_price, 0)) over(order by to_char(d_month, 'mm') asc)/10000,'99999999999999.00') now_price, ");
		sqlOutcome.append(" TO_CHAR(sum(nvl(wz.w_price, 0)) over(order by to_char(d_month, 'mm') asc)/10000,'99999999999999.00') old_price ");
		sqlOutcome.append(" from temp_rq rq ");
		sqlOutcome.append(" left outer join (select sum(pd.cost_detail_money) w_price, to_char(pd.occur_date, 'yyyymm') m_month ");
		sqlOutcome.append(" from bgp_op_target_project_info t1 inner join  bgp_op_actual_project_detail pd  on t1.gp_target_project_id = pd.gp_target_project_id and t1.node_code like 'S01001%' ");
		sqlOutcome.append(" where to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pd.bsflag = '0'  ");
		sqlOutcome.append(" AND  T1.PROJECT_INFO_NO IN (SELECT PROJECT_INFO_NO FROM view_op_project_info WHERE org_subjection_id LIKE '"+orgSubjectionId+"%') group by to_char(pd.occur_date, 'yyyymm') ) wl ");
		sqlOutcome.append(" on to_char(rq.d_month, 'yyyymm') = wl.m_month ");
		sqlOutcome.append(" left outer join (select sum(pd.cost_detail_money) w_price, to_char(pd.occur_date, 'yyyymm') m_month from  ");
		sqlOutcome.append(" bgp_op_target_project_info t1 inner join  bgp_op_actual_project_detail pd  on t1.gp_target_project_id = pd.gp_target_project_id and t1.node_code like 'S01001%'  ");
		sqlOutcome.append(" where to_char(pd.occur_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy') and pd.bsflag = '0' ");
		sqlOutcome.append("  AND  T1.PROJECT_INFO_NO IN (SELECT PROJECT_INFO_NO FROM view_op_project_info WHERE org_subjection_id LIKE '"+orgSubjectionId+"%') ");
		sqlOutcome.append(" group by to_char(pd.occur_date, 'yyyymm')) wz on to_char(add_months(rq.d_month, -12), 'yyyymm') = wz.m_month ");

		List<Map> listOutcome = jdbcDAO.queryRecords(sqlOutcome.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");
		root.addAttribute("yAxisMaxValue ", df.format(money));

		Element trendlines = root.addElement("trendlines");
		Element line = trendlines.addElement("line");
		line.addAttribute("color", LineCColor);
		line.addAttribute("valueOnRight", "1");
		line.addAttribute("dashed", "1");
		line.addAttribute("thickness", "2");
		line.addAttribute("startValue", df.format(money));
		line.addAttribute("displayValue", df.format(money));

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "去年");

		dataset1.addAttribute("color", LineAColor);
		dataset2.addAttribute("color", LineBColor);

		for (int i = 0; i < listIncome.size(); i++) {
			Map mapIncome = listIncome.get(i);
			Map mapOutcome = listOutcome.get(i);

			Element categoriesTemp = categories.addElement("category");
			categoriesTemp.addAttribute("label", (String) mapIncome.get("monthtime"));
			String dMonth = (String) mapIncome.get("monthtime");
			dMonth = dMonth.replaceAll("月", "");
			if (new Date().getMonth() + 1 >= Integer.parseInt(dMonth)) {
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", df.format(Double.parseDouble((String) mapIncome.get("actual_price")) - Double.parseDouble((String) mapOutcome.get("now_price"))));
				Element set2 = dataset2.addElement("set");
				set2.addAttribute("value", df.format(Double.parseDouble((String) mapIncome.get("old_price")) - Double.parseDouble((String) mapOutcome.get("old_price"))));
				set1.addAttribute("link", "j-drillgslr-" + (String) mapIncome.get("d_month"));
				set1.addAttribute("anchorBgColor", LineAColor);
				set2.addAttribute("anchorBgColor", LineBColor);
				if (mapIncome.equals(listIncome.get(new Date().getMonth()))) {
					set1.addAttribute("showValue", "1");
					set2.addAttribute("showValue", "1");
				}
			}
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 公司周收入同比分析
	 */
	public ISrvMsg getCompanyIncomeWeekInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgSubjectionId=reqDTO.getValue("orgSubjectionId");
		orgSubjectionId=(orgSubjectionId==null||"".equals(orgSubjectionId))?"C105":orgSubjectionId;
		
		String d_month = reqDTO.getValue("d_month");
		if (d_month == null || "".equals(d_month) || "null".equals(d_month)) {
			Date date = new Date();
			d_month = String.valueOf(date.getYear() + 1900) + "-" + String.valueOf(date.getMonth() + 1) + "-"
					+ (date.getDate() < 10 ? "0" + String.valueOf(date.getDate()) : String.valueOf(date.getDate()));
		}
		StringBuffer sql = new StringBuffer("WITH temp_weeks as (select next_day(to_date(to_char(to_date('" + d_month
				+ "', 'yyyy-MM-dd'),'yyyy-MM')||'-01','yyyy-MM-dd')-14,'星期一')+ rownum * 7 cdate, ");
		sql.append(" to_char(next_day(to_date(to_char(to_date('" + d_month
				+ "', 'yyyy-MM-dd'),'yyyy-MM')||'-01','yyyy-MM-dd')-14,'星期一')+ rownum * 7,'WW') weeks from dual  connect by rownum < 7) ");
		sql.append(" ,op_price as (select max((case NODE_CODE when 'S01021' then price_unit else 0 end)) - max((case NODE_CODE when 'S01022' then price_unit else 0 end)) price_unit, project_info_no  from bgp_op_price_project_info where bsflag='0' group by project_info_no) ");
		sql.append(" select rq.weeks, nvl(wz.w_price,0) now_price, nvl(wl.w_price,0) old_price from temp_weeks rq ");
		sql.append(" left outer join (select sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002', ");
		sql.append("                          gd.finish_2d_workload) * nvl(pi.price_unit, 0) / 10000) w_price, to_char(gd.send_date, 'WW') m_month ");
		sql.append("         from rpt_gp_daily gd left outer join op_price pi  on gd.project_info_no =  pi.project_info_no 　");
		sql.append("         left outer join gp_task_project gp  on gd.project_info_no = gp.project_info_no ");
		sql.append("        where gd.bsflag = '0' and to_char(GD.SEND_DATE, 'yyyy') = to_char(sysdate, 'yyyy') AND GD.ORG_SUBJECTION_ID LIKE '"+orgSubjectionId+"%'");
		sql.append("        group by to_char(gd.send_date, 'WW')) wl on RQ.weeks = wl.m_month ");
		sql.append(" left outer join (select sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002', ");
		sql.append("                       gd.finish_2d_workload) * nvl(pi.price_unit, 0) / 10000) w_price, to_char(gd.send_date, 'WW') m_month ");
		sql.append("      from rpt_gp_daily gd left outer join op_price pi  on gd.project_info_no =  pi.project_info_no 　");
		sql.append("       left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append("      where gd.bsflag = '0' and to_char(GD.SEND_DATE, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy') AND GD.ORG_SUBJECTION_ID LIKE '"+orgSubjectionId+"%'");
		sql.append("      group by to_char(gd.send_date, 'WW')) wz on RQ.weeks = wz.m_month ");
		sql.append(" order by weeks ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "去年");

		dataset1.addAttribute("color", LineAColor);
		dataset2.addAttribute("color", LineBColor);

		for (Map map : list) {
			Element categoriesTemp = categories.addElement("category");
			categoriesTemp.addAttribute("label", (String) map.get("weeks"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("old_price"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("now_price"));
			set1.addAttribute("anchorBgColor", LineAColor);
			set2.addAttribute("anchorBgColor", LineBColor);
			if (map.equals(list.get(list.size() - 1))) {
				set1.addAttribute("showValue", "1");
				set2.addAttribute("showValue", "1");
			}
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 公司周支出同比分析
	 */
	public ISrvMsg getCompanyOutcomeWeekInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String orgSubjectionId=reqDTO.getValue("orgSubjectionId");
		orgSubjectionId=(orgSubjectionId==null||"".equals(orgSubjectionId))?"C105":orgSubjectionId;
		
		
		String d_month = reqDTO.getValue("d_month");
		if (d_month == null || "".equals(d_month) || "null".equals(d_month)) {
			Date date = new Date();
			d_month = String.valueOf(date.getYear() + 1900) + "-" + String.valueOf(date.getMonth() + 1) + "-"
					+ (date.getDate() < 10 ? "0" + String.valueOf(date.getDate()) : String.valueOf(date.getDate()));
		}
		StringBuffer sql = new StringBuffer("with temp_rq as ");
		sql.append(" (select  next_day(to_date(to_char(to_date('" + d_month + "', 'yyyy-MM-dd'),'yyyy-MM')||'-01','yyyy-MM-dd')-14,'星期一')+ rownum * 7 s_date, ");
		sql.append(" next_day(to_date(to_char(to_date('" + d_month + "', 'yyyy-MM-dd'),'yyyy-MM')||'-01','yyyy-MM-dd')-14,'星期一')+ rownum * 7+6 e_date, ");
		sql.append(" to_char(next_day(to_date(to_char(to_date('" + d_month + "', 'yyyy-MM-dd'),'yyyy-MM')||'-01','yyyy-MM-dd')-14,'星期一')+ rownum * 7,'WW') weeks ");
		sql.append(" from dual connect by rownum < 7) ");
		sql.append(" select rq.weeks,TO_CHAR(sum(nvl(wl.w_price, 0))/ 10000,'99999999999999.00') now_price, ");
		sql.append(" TO_CHAR(sum(nvl(wz.w_price, 0)) / 10000,'99999999999999.00') old_price from temp_rq rq ");
		sql.append(" left outer join (select sum(pd.cost_detail_money) w_price, pd.occur_date  from bgp_op_target_project_info t1 ");
		sql.append("  inner join  bgp_op_actual_project_detail pd  on t1.gp_target_project_id = pd.gp_target_project_id and t1.node_code like 'S01001%' ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') =to_char(sysdate, 'yyyy') and pd.bsflag = '0'  ");
		sql.append(" AND  T1.PROJECT_INFO_NO IN (SELECT PROJECT_INFO_NO FROM view_op_project_info WHERE org_subjection_id LIKE '"+orgSubjectionId+"%')  ");
		sql.append(" group by pd.occur_date) wl on wl.occur_date >= rq.s_date and wl.occur_date<=rq.e_date ");
		sql.append(" left outer join (select sum(pd.cost_detail_money) w_price, pd.occur_date  from bgp_op_target_project_info t1 ");
		sql.append(" inner join  bgp_op_actual_project_detail pd  on t1.gp_target_project_id = pd.gp_target_project_id and t1.node_code like 'S01001%' ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy') and pd.bsflag = '0' ");
		sql.append(" AND  T1.PROJECT_INFO_NO IN (SELECT PROJECT_INFO_NO FROM view_op_project_info WHERE org_subjection_id LIKE '"+orgSubjectionId+"%')  ");
		sql.append(" group by pd.occur_date ) wz on wz.occur_date >= rq.s_date and wz.occur_date<=rq.e_date ");
		sql.append(" group by rq.weeks order  by rq.weeks asc");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "去年");

		dataset1.addAttribute("color", LineAColor);
		dataset2.addAttribute("color", LineBColor);

		for (Map map : list) {
			Element categoriesTemp = categories.addElement("category");
			categoriesTemp.addAttribute("label", (String) map.get("weeks"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("now_price"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("old_price"));
			set1.addAttribute("anchorBgColor", LineAColor);
			set2.addAttribute("anchorBgColor", LineBColor);
			if (map.equals(list.get(list.size() - 1))) {
				set1.addAttribute("showValue", "1");
				set2.addAttribute("showValue", "1");
			}
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 获取公司周利润情况
	 */
	public ISrvMsg getCompanyWeekProfitInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String d_month = reqDTO.getValue("d_month");
		
		String orgSubjectionId=reqDTO.getValue("orgSubjectionId");
		orgSubjectionId=(orgSubjectionId==null||"".equals(orgSubjectionId))?"C105":orgSubjectionId;
		
		if (d_month == null || "".equals(d_month) || "null".equals(d_month)) {
			Date date = new Date();
			d_month = String.valueOf(date.getYear() + 1900) + "-" + String.valueOf(date.getMonth() + 1) + "-"
					+ (date.getDate() < 10 ? "0" + String.valueOf(date.getDate()) : String.valueOf(date.getDate()));
		}
		StringBuffer sql = new StringBuffer("WITH temp_weeks as (select next_day(to_date(to_char(to_date('" + d_month
				+ "', 'yyyy-MM-dd'),'yyyy-MM')||'-01','yyyy-MM-dd')-14,'星期一')+ rownum * 7 cdate, ");
		sql.append(" to_char(next_day(to_date(to_char(to_date('" + d_month
				+ "', 'yyyy-MM-dd'),'yyyy-MM')||'-01','yyyy-MM-dd')-14,'星期一')+ rownum * 7,'WW') weeks from dual  connect by rownum < 7) ");
		sql.append(" select rq.weeks, nvl(wz.w_price,0) now_price, nvl(wl.w_price,0) old_price from temp_weeks rq ");
		sql.append(" left outer join (select sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002', ");
		sql.append("                          gd.finish_2d_workload) * 19) w_price, to_char(gd.send_date, 'WW') m_month ");
		sql.append("         from rpt_gp_daily gd ");
		sql.append("         left outer join gp_task_project gp  on gd.project_info_no = gp.project_info_no ");
		sql.append("        where gd.bsflag = '0' and to_char(GD.SEND_DATE, 'yyyy') = to_char(sysdate, 'yyyy') AND GD.ORG_SUBJECTION_ID LIKE '"+orgSubjectionId+"%'");
		sql.append("        group by to_char(gd.send_date, 'WW')) wl on RQ.weeks = wl.m_month ");
		sql.append(" left outer join (select sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002', ");
		sql.append("                       gd.finish_2d_workload) * 19) w_price, to_char(gd.send_date, 'WW') m_month ");
		sql.append("      from rpt_gp_daily gd ");
		sql.append("       left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append("      where gd.bsflag = '0' and to_char(GD.SEND_DATE, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy') AND GD.ORG_SUBJECTION_ID LIKE '"+orgSubjectionId+"%'");
		sql.append("      group by to_char(gd.send_date, 'WW')) wz on RQ.weeks = wz.m_month ");
		sql.append(" order by weeks ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		StringBuffer sqlOutcome = new StringBuffer("with temp_rq as ");
		sqlOutcome.append(" (select  next_day(to_date(to_char(to_date('" + d_month + "', 'yyyy-MM-dd'),'yyyy-MM')||'-01','yyyy-MM-dd')-14,'星期一')+ rownum * 7 s_date, ");
		sqlOutcome.append(" next_day(to_date(to_char(to_date('" + d_month + "', 'yyyy-MM-dd'),'yyyy-MM')||'-01','yyyy-MM-dd')-14,'星期一')+ rownum * 7+6 e_date, ");
		sqlOutcome.append(" to_char(next_day(to_date(to_char(to_date('" + d_month + "', 'yyyy-MM-dd'),'yyyy-MM')||'-01','yyyy-MM-dd')-14,'星期一')+ rownum * 7,'WW') weeks ");
		sqlOutcome.append(" from dual connect by rownum < 7) ");
		sqlOutcome.append(" select rq.weeks,TO_CHAR(sum(nvl(wl.w_price, 0))/ 10000,'99999999999999.00') now_price, ");
		sqlOutcome.append(" TO_CHAR(sum(nvl(wz.w_price, 0)) / 10000,'99999999999999.00') old_price from temp_rq rq ");
		sqlOutcome.append(" left outer join (select sum(pd.cost_detail_money) w_price, pd.occur_date  from bgp_op_target_project_info t1 ");
		sqlOutcome.append("  inner join  bgp_op_actual_project_detail pd  on t1.gp_target_project_id = pd.gp_target_project_id and t1.node_code like 'S01001%' ");
		sqlOutcome.append(" where to_char(pd.occur_date, 'yyyy') =to_char(sysdate, 'yyyy') and pd.bsflag = '0'  ");
		sqlOutcome.append(" AND  T1.PROJECT_INFO_NO IN (SELECT PROJECT_INFO_NO FROM view_op_project_info WHERE org_subjection_id LIKE '"+orgSubjectionId+"%')  ");
		sqlOutcome.append(" group by pd.occur_date) wl on wl.occur_date >= rq.s_date and wl.occur_date<=rq.e_date ");
		sqlOutcome.append(" left outer join (select sum(pd.cost_detail_money) w_price, pd.occur_date  from bgp_op_target_project_info t1 ");
		sqlOutcome.append(" inner join  bgp_op_actual_project_detail pd  on t1.gp_target_project_id = pd.gp_target_project_id and t1.node_code like 'S01001%' ");
		sqlOutcome.append(" where to_char(pd.occur_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy') and pd.bsflag = '0' ");
		sqlOutcome.append(" AND  T1.PROJECT_INFO_NO IN (SELECT PROJECT_INFO_NO FROM view_op_project_info WHERE org_subjection_id LIKE '"+orgSubjectionId+"%')  ");
		sqlOutcome.append(" group by pd.occur_date ) wz on wz.occur_date >= rq.s_date and wz.occur_date<=rq.e_date ");
		sqlOutcome.append(" group by rq.weeks order  by rq.weeks asc");

		List<Map> listOutcome = jdbcDAO.queryRecords(sqlOutcome.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "去年");

		dataset1.addAttribute("color", LineAColor);
		dataset2.addAttribute("color", LineBColor);

		DecimalFormat df = new DecimalFormat(".##");

		for (int i = 0; i < list.size(); i++) {
			Map mapIncome = list.get(i);
			Map mapOutcome = listOutcome.get(i);
			Element categoriesTemp = categories.addElement("category");
			categoriesTemp.addAttribute("label", (String) mapIncome.get("weeks"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", df.format(Double.parseDouble((String) mapIncome.get("now_price")) - Double.parseDouble((String) mapOutcome.get("now_price"))));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", df.format(Double.parseDouble((String) mapIncome.get("old_price")) - Double.parseDouble((String) mapOutcome.get("old_price"))));
			set1.addAttribute("anchorBgColor", LineAColor);
			set2.addAttribute("anchorBgColor", LineBColor);
			if (mapIncome.equals(list.get(list.size() - 1))) {
				set1.addAttribute("showValue", "1");
				set2.addAttribute("showValue", "1");
			}
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;

	}

	/*
	 * 仪表盘:物探处收入完成情况
	 */
	public ISrvMsg getCompanyCompareSectionInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer(
				"with op_price as (select max((case NODE_CODE when 'S01021' then price_unit else 0 end)) - max((case NODE_CODE when 'S01022' then price_unit else 0 end)) "
						+ "price_unit, project_info_no  from bgp_op_price_project_info where bsflag='0' group by project_info_no)"
						+ "select to_char(sum(nvl(decode(to_char(gd.send_date, 'yyyy'),to_char(sysdate, 'yyyy'), ");
		sql.append(" decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload), ");
		sql.append(" 0)*pi.price_unit/10000,0)),'9999999999.00') new_price, ");
		sql.append(" to_char(sum(nvl(decode(to_char(gd.send_date, 'yyyy'),to_char(add_months(sysdate, -12), 'yyyy'), ");
		sql.append(" decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload), ");
		sql.append(" 0)*pi.price_unit/10000,0)),'9999999999.00') old_price, ns.org_short_name w_label, ns.org_subjection_id ");
		sql.append(" from bgp_comm_org_wtc ns left outer join  rpt_gp_daily gd on gd.org_subjection_id like ns.org_subjection_id||'%'");
		sql.append(" and gd.bsflag = '0' and (to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') or ");
		sql.append(" to_char(gd.send_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy'))");
		sql.append("   left outer join op_price pi on gd.project_info_no = pi.project_info_no  ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no and gp.bsflag ='0'");
		sql.append(" group by ns.org_short_name,ns.org_subjection_id,ns.order_num order by ns.order_num");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "去年");

		dataset1.addAttribute("color", PillarAColor);
		dataset2.addAttribute("color", PillarBColor);
		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("w_label"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("new_price"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("old_price"));
			set1.addAttribute("link", "j-drillxmsr-" + (String) map.get("org_subjection_id"));
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:公司物探处支出对比图
	 */
	public ISrvMsg getCompanyOutcomeCompareSectionInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String gjb=reqDTO.getValue("gjb");
		StringBuffer sql = new StringBuffer(
				"  select to_char(sum(decode(to_char(pd.occur_date, 'yyyy'),to_char(sysdate, 'yyyy'),pd.cost_detail_money / 10000,0)),'9999999999.00') new_price, ");
		sql.append(" to_char(sum(decode(to_char(pd.occur_date, 'yyyy'),to_char(add_months(sysdate, -12), 'yyyy'),pd.cost_detail_money / 10000,0)),'9999999999.00') old_price, ");
		sql.append(" ns.org_short_name w_label,ns.org_subjection_id from bgp_comm_org_wtc ns ");
		sql.append(" left outer join gp_task_project_dynamic t1 on t1.org_subjection_id like  ns.org_subjection_id||'%' ");
		sql.append(" left outer join bgp_op_target_project_info pi on pi.project_info_no = t1.project_info_no and pi.bsflag = '0' and pi.node_code like 'S01001%'");
		sql.append(" left outer  join bgp_op_actual_project_detail pd on pd.gp_target_project_id = pi.gp_target_project_id and pd.bsflag = '0' ");
		sql.append(" and (to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') or to_char(pd.occur_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) ");
		sql.append(" and to_date(to_char(pd.occur_date, 'yyyy-MM'),'yyyy-MM') <= to_date(to_char(sysdate, 'yyyy-MM'),'yyyy-MM') ");
		if("0".equals(gjb)){
			sql.append(" where ns.org_subjection_id !='C105002'");
		}
		sql.append(" group by ns.org_short_name,ns.org_subjection_id,ns.order_num order by ns.order_num");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "去年");

		dataset1.addAttribute("color", PillarAColor);
		dataset2.addAttribute("color", PillarBColor);
		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("w_label"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("new_price"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("old_price"));
			set1.addAttribute("link", "j-drillxmzc-" + (String) map.get("org_subjection_id"));
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 获取物探处利润情况
	 */
	public ISrvMsg getSectionProfitInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sqlIncome = new StringBuffer(
				"with op_price as (select max((case NODE_CODE when 'S01021' then price_unit else 0 end)) - max((case NODE_CODE when 'S01022' then price_unit else 0 end)) "
						+ "price_unit, project_info_no  from bgp_op_price_project_info where bsflag='0' group by project_info_no)"
						+ "select TO_NUMBER(to_char(sum(nvl(decode(to_char(gd.send_date, 'yyyy'),to_char(sysdate, 'yyyy'), ");
		sqlIncome.append(" decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload), ");
		sqlIncome.append(" 0)*pi.price_unit/10000,0)),'9999999999.00')) new_price, ");
		sqlIncome.append(" TO_NUMBER(to_char(sum(nvl(decode(to_char(gd.send_date, 'yyyy'),to_char(add_months(sysdate, -12), 'yyyy'), ");
		sqlIncome.append(" decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload), ");
		sqlIncome.append(" 0)*pi.price_unit/10000,0)),'9999999999.00')) old_price, ns.org_short_name w_label, ns.org_subjection_id ");
		sqlIncome.append(" from bgp_comm_org_wtc ns left outer join  rpt_gp_daily gd on gd.org_subjection_id like ns.org_subjection_id||'%'");
		sqlIncome.append(" and gd.bsflag = '0' and (to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') or ");
		sqlIncome.append(" to_char(gd.send_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy'))");
		sqlIncome.append("   left outer join op_price pi on gd.project_info_no = pi.project_info_no  ");
		sqlIncome.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no and gp.bsflag ='0'");
		sqlIncome.append(" group by ns.org_short_name,ns.org_subjection_id,ns.order_num order by ns.order_num");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> listIncome = jdbcDAO.queryRecords(sqlIncome.toString());

		StringBuffer sqlOutcome = new StringBuffer(
				" select TO_NUMBER(to_char(sum(decode(to_char(pd.occur_date, 'yyyy'),to_char(sysdate, 'yyyy'),pd.cost_detail_money / 10000,0)),'9999999999.00')) new_price, ");
		sqlOutcome
				.append(" TO_NUMBER(to_char(sum(decode(to_char(pd.occur_date, 'yyyy'),to_char(add_months(sysdate, -12), 'yyyy'),pd.cost_detail_money / 10000,0)),'9999999999.00')) old_price, ");
		sqlOutcome.append(" ns.org_short_name w_label,ns.org_subjection_id from bgp_comm_org_wtc ns ");
		sqlOutcome.append(" left outer join gp_task_project_dynamic t1 on t1.org_subjection_id like  ns.org_subjection_id||'%' ");
		sqlOutcome.append(" left outer join bgp_op_target_project_info pi on pi.project_info_no = t1.project_info_no and pi.bsflag = '0' and pi.node_code like 'S01001%'");
		sqlOutcome.append(" left outer  join bgp_op_actual_project_detail pd on pd.gp_target_project_id = pi.gp_target_project_id and pd.bsflag = '0' ");
		sqlOutcome.append(" and (to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') or to_char(pd.occur_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) ");
		sqlOutcome.append(" and to_date(to_char(pd.occur_date, 'yyyy-MM'),'yyyy-MM') <= to_date(to_char(sysdate, 'yyyy-MM'),'yyyy-MM') ");
		sqlOutcome.append(" group by ns.org_short_name,ns.org_subjection_id,ns.order_num order by ns.order_num");
		List<Map> listOutcome = jdbcDAO.queryRecords(sqlOutcome.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "去年");

		dataset1.addAttribute("color", PillarAColor);
		dataset2.addAttribute("color", PillarBColor);

		DecimalFormat df = new DecimalFormat("#.##");

		for (int i = 0; i < listIncome.size(); i++) {
			Map mapIncome = listIncome.get(i);
			Map mapOutcome = listOutcome.get(i);

			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) mapIncome.get("w_label"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", df.format(Double.parseDouble((String) mapIncome.get("new_price")) - Double.parseDouble((String) mapOutcome.get("new_price"))));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", df.format(Double.parseDouble((String) mapIncome.get("old_price")) - Double.parseDouble((String) mapOutcome.get("old_price"))));
			set1.addAttribute("link", "j-drillxmlr-" + (String) mapIncome.get("org_subjection_id"));
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:物探处小队收入支出对比图
	 */
	public ISrvMsg getSectionCompareTeamIncomeInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		StringBuffer sql = new StringBuffer("  with project_team as(select distinct gp.project_info_no, gp.project_name, ot.team_id  from gp_task_project gp ");
		sql.append(" left outer join gp_task_project_dynamic pd  on gp.project_info_no = pd.project_info_no  and pd.bsflag = '0' ");
		sql.append(" left outer join comm_org_team ot on pd.org_id = ot.org_id  and ot.bsflag = '0' gp.BSFLAG='0'), ");
		sql.append(" op_price as (select max((case NODE_CODE when 'S01021' then price_unit else 0 end)) - max((case NODE_CODE when 'S01022' then price_unit else 0 end))"
				+ " price_unit, project_info_no  from bgp_op_price_project_info where bsflag='0' group by project_info_no) ");
		sql.append(" select p.*, TO_CHAR(P.price_unit*P.WORKLOAD/10000,'9999999999.00') PRICE,t.acquire_start_time,t.team_id TEAM_NAME,substr(t.exploration_method,0,2) exploration_method,t.acquire_end_time,t.project_status,to_char(p.finish_sp/t.design_sp_num*100,'9999999999.00') jd from( ");
		sql.append(" select to_number(to_char(sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002', ");
		sql.append(" gd.finish_2d_workload) * pi.price_unit / 10000),'99999999.00')) w_price, pt.project_name team_id,PT.project_info_no, ");
		sql.append(" sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload)) workload,max(pi.price_unit) price_unit,  ");
		sql.append(" sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.DAILY_FINISHING_3D_SP,'0300100012000000002',gd.DAILY_FINISHING_2D_SP)) finish_sp  ");
		sql.append(" from rpt_gp_daily gd left outer join op_price pi on gd.project_info_no = pi.project_info_no  ");
		sql.append("  left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no and gp.bsflag ='0'");
		sql.append(" left outer join project_team pt on gd.project_info_no = pt.project_info_no ");
		sql.append(" where gd.bsflag = '0' and gd.org_subjection_id like '" + orgId + "%'  and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') ");
		sql.append(" group by pt.project_name,PT.project_info_no ");
		sql.append("  ) p left outer join (select t1.project_info_no,oi.team_id,sd1.coding_name exploration_method,t1.acquire_start_time,t1.acquire_end_time,sd.coding_name project_status,pd.design_sp_num  from gp_task_project t1  ");
		sql.append(" left outer join comm_coding_sort_detail sd on t1.project_status=sd.coding_code_id  and sd.bsflag='0' ");
		sql.append(" left outer join comm_coding_sort_detail sd1 on t1.exploration_method=sd1.coding_code_id  and sd.bsflag='0' ");
		sql.append(" left outer join gp_task_project_dynamic pd on t1.project_info_no=pd.project_info_no and pd.bsflag='0'  ");
		sql.append(" left outer join comm_org_team oi on pd.org_id=oi.org_id and oi.bsflag='0'  where t1.bsflag='0')t ");
		sql.append(" on p.project_info_no =t.project_info_no  ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		//dataset1.addAttribute("seriesName", "收入");

		dataset1.addAttribute("color", PillarAColor);
		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("team_id"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("w_price"));
			set1.addAttribute("toolText", "完成采集工作量："+(String) map.get("workload")+";炮数"+(String) map.get("finish_sp")+";采集价值工作量"+(String) map.get("price_unit")+"元");
			set1.addAttribute("showValue", "1");
			set1.addAttribute("link", "j-drillxmsrmx-" + (String) map.get("project_info_no"));
		}
		responseDTO.setValue("Str", document.asXML());
		responseDTO.setValue("datas", list);

		return responseDTO;
	}

	/*
	 * 仪表盘:物探处小队支出对比图
	 */
	public ISrvMsg getSectionTeamOutcomeInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		StringBuffer sql = new StringBuffer("  with org_name_sub as(select oi.org_abbreviation, os.org_subjection_id, t.project_info_no ");
		sql.append(" from comm_org_information oi inner join comm_org_subjection os on oi.org_id = os.org_id and os.bsflag = '0' ");
		sql.append(" left outer join gp_task_project_dynamic t on t.org_subjection_id like os.org_subjection_id || '%' and t.bsflag = '0' ");
		sql.append(" where  os.org_subjection_id = '" + orgId + "' and oi.bsflag = '0') ");
		sql.append(" select p.*,t.acquire_start_time,t.team_id TEAM_NAME,substr(t.exploration_method,0,2) exploration_method,t.acquire_end_time,t.project_status from( ");
		sql.append(" select to_char(sum(decode(to_char(pd.occur_date, 'yyyy'), to_char(sysdate, 'yyyy'), pd.cost_detail_money / 10000, 0)),'99999999.00') new_price, ");
		sql.append(" t.project_name w_label,T.project_info_no from org_name_sub ns ");
		sql.append(" inner join bgp_op_target_project_info pi  on pi.project_info_no = ns.project_info_no  and pi.bsflag = '0' and pi.node_code like 'S01001%'");
		sql.append(" inner join bgp_op_actual_project_detail pd  on pd.gp_target_project_id = pi.gp_target_project_id  and pd.bsflag = '0' ");
		sql.append(" and (to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') or to_char(pd.occur_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) ");
		sql.append(" left outer join gp_task_project t on ns.project_info_no = t.project_info_no and t.bsflag ='0'");
		sql.append(" where to_date(to_char(pd.occur_date, 'yyyy-MM'),'yyyy-MM') <= to_date(to_char(sysdate, 'yyyy-MM'),'yyyy-MM') group by t.project_name,T.project_info_no");
		sql.append(") p left outer join (select t1.project_info_no,oi.team_id,sd1.coding_name exploration_method,t1.acquire_start_time,t1.acquire_end_time,sd.coding_name project_status,pd.design_sp_num  from gp_task_project t1  "); 
		sql.append(" left outer join comm_coding_sort_detail sd on t1.project_status=sd.coding_code_id  and sd.bsflag='0' ");
		sql.append(" left outer join comm_coding_sort_detail sd1 on t1.exploration_method=sd1.coding_code_id  and sd.bsflag='0' ");
		sql.append(" left outer join gp_task_project_dynamic pd on t1.project_info_no=pd.project_info_no and pd.bsflag='0'  ");
		sql.append(" left outer join comm_org_team oi on pd.org_id=oi.org_id and oi.bsflag='0'  where t1.bsflag='0')t ");
		sql.append(" on p.project_info_no =t.project_info_no ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");

		dataset1.addAttribute("color", PillarAColor);
		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("w_label"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("new_price"));
			set1.addAttribute("showValue", "1");
			set1.addAttribute("link", "j-drillxmmx-" + (String) map.get("project_info_no"));
		}
		responseDTO.setValue("Str", document.asXML());
		responseDTO.setValue("datas", list);

		return responseDTO;
	}
	/*
	 * 仪表盘:物探处小队预警信息
	 */
	public ISrvMsg getTeamYJInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuffer sql = new StringBuffer();
		sql.append(" select m.*,nvl(actual_money-plan_money,0)plus_money,case when (nvl(plan_money,0)=0 and nvl(actual_money,0)=0) then '0.00%'  ")
		.append(" when (nvl(plan_money,0)=0 and nvl(actual_money,0)!=0) then '100.00%' when nvl(plan_money,0)!=0 then  ")
		.append(" round(nvl(actual_money-plan_money,0)/nvl(plan_money,0)*100*100)/100.0 ||'%' else '' end radio ")
		.append(" from(select p.cost_name,(select case nvl(m.proc_status,'1') when '3' then round(sum(nvl(t.change_money,0))*100)/100.0 ")
		.append(" else round(sum(nvl(t.plan_money,0))*100)/100.0 end cost_detail_money from view_op_target_cost t ")
		.append(" left join common_busi_wf_middle m on m.business_id ='"+projectInfoNo+"' ")
		.append(" and m.busi_table_name ='BGP_OP_TARGET_PROJECT_INFO' and m.business_type ='5110000004100000014'")
		.append(" where t.project_info_no ='"+projectInfoNo+"' and t.node_code like p.node_code ||'%' group by m.proc_status) plan_money, ")
		.append(" (select sum(nvl(d.cost_detail_money,0)) from bgp_op_target_project_info t  ")
		.append(" left join bgp_op_actual_project_detail d on t.gp_target_project_id = d.gp_target_project_id and d.bsflag ='0' ")
		.append(" where t.bsflag ='0' and t.project_info_no ='"+projectInfoNo+"'  and t.node_code like p.node_code ||'%') actual_money ")
		.append(" from bgp_op_target_project_info p where p.bsflag ='0' and p.project_info_no ='"+projectInfoNo+"' ")
		.append(" start with p.parent_id ='01' connect by prior p.gp_target_project_id = p.parent_id order siblings by p.order_code)m");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());
		responseDTO.setValue("datas", list);
		
		return responseDTO;
	}
	
	/*
	 * 仪表盘:物探处小队利润对比图
	 */
	public ISrvMsg getSectionTeamProfitInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		StringBuffer sql = new StringBuffer("  with org_name_sub as(select oi.org_abbreviation, os.org_subjection_id, t.project_info_no, gp.project_name ");
		sql.append(" from comm_org_information oi  ");
		sql.append(" inner join comm_org_subjection os   on oi.org_id = os.org_id  and os.bsflag = '0' ");
		sql.append(" left outer join gp_task_project_dynamic t  on t.org_subjection_id like os.org_subjection_id || '%'  and t.bsflag = '0' ");
		sql.append(" left outer join gp_task_project gp  on t.project_info_no = gp.project_info_no  and t.bsflag = '0' ");
		sql.append(" where  os.org_subjection_id = '" + orgId + "'  and oi.bsflag = '0'), ");
		sql.append("      op_price as (select max((case NODE_CODE when 'S01021' then price_unit else 0 end)) - max((case NODE_CODE when 'S01022' then price_unit else 0 end)) price_unit, project_info_no  from bgp_op_price_project_info where bsflag='0' group by project_info_no) ");
		sql.append(" select to_char(nvl(p2.w_price,0) - p1.new_price,'9999999999.00') lirun, p1.w_label  from (select sum(decode(to_char(pd.occur_date, 'yyyy'), ");
		sql.append(" to_char(sysdate, 'yyyy'), pd.cost_detail_money / 10000, 0)) new_price, ns.project_name w_label, ns.project_info_no ");
		sql.append(" from org_name_sub ns  inner join bgp_op_target_project_info pi  on pi.project_info_no = ns.project_info_no  and pi.bsflag = '0' and pi.node_code like 'S01001%' ");
		sql.append(" inner join bgp_op_actual_project_detail pd on pd.gp_target_project_id = pi.gp_target_project_id ");
		sql.append(" where pd.bsflag = '0' and (to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') or ");
		sql.append(" to_char(pd.occur_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) ");
		sql.append(" and to_date(to_char(pd.occur_date, 'yyyy-MM'),'yyyy-MM') <= to_date(to_char(sysdate, 'yyyy-MM'),'yyyy-MM')");
		sql.append(" group by ns.project_name, ns.project_info_no order by ns.project_name desc) p1 ");
		sql.append(" left outer join (select to_number(to_char(sum(decode(gp.EXPLORATION_METHOD, '0300100012000000003', gd.finish_3d_workload, ");
		sql.append(" '0300100012000000002', gd.finish_2d_workload) * pi.price_unit / 10000), '99999999.00')) w_price, ");
		sql.append(" ns.project_name w_label, ns.project_info_no from org_name_sub ns ");
		sql.append(" left outer join rpt_gp_daily gd on gd.project_info_no = ns.project_info_no ");
		sql.append(" left outer join op_price pi on gd.project_info_no = pi.project_info_no ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0'  and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') group by ns.project_name, ns.project_info_no) p2 ");
		sql.append(" on p1.project_info_no = p2.project_info_no ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");

		dataset1.addAttribute("color", PillarAColor);

		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("w_label"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("lirun"));
			set1.addAttribute("showValue", "1");
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:小队目标成本组成饼图
	 */
	public ISrvMsg getTeamTargetPieInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");// "8ad8788529ef02230129f2e53deb01ac";
		StringBuffer sql = new StringBuffer("");
		String parentId = reqDTO.getValue("parentId");
		if(parentId==null || parentId.trim().equals("")){
			parentId ="S01001";
		}
		int lenght = parentId.length()-(-3);
		sql.append("with target_cost as (select t.cost_name,t.node_code,case nvl(m.proc_status,'1') when '3' then round(nvl(t.change_money,0)/10000*100)/100.0 ")
		.append(" else round(nvl(t.plan_money,0)/10000*100)/100.0 end cost_detail_money,t.order_code from view_op_target_cost t ")
		.append(" left join common_busi_wf_middle m on m.business_id ='").append(projectInfoNo).append("' ")
		.append(" and m.busi_table_name ='BGP_OP_TARGET_PROJECT_INFO' and m.business_type ='5110000004100000014'")
		.append(" where t.project_info_no ='").append(projectInfoNo).append("' and t.node_code !='"+parentId+"' and t.node_code like '"+parentId+"%')")
		.append(" select t.cost_name ,(select sum(tc.cost_detail_money) from target_cost tc where tc.node_code like t.node_code ||'%') cost_detail_money ")
		.append(" from target_cost t where length(t.node_code)="+lenght+" order by t.order_code");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");

		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showPercentValues", "0");
		root.addAttribute("startingAngle", "175");
		root.addAttribute("baseFontSize ", "12");

		for (Map map : list) {
			Element dataset1 = root.addElement("set");
			
			dataset1.addAttribute("label", (String) map.get("cost_name"));
			dataset1.addAttribute("value", (String) map.get("cost_detail_money"));
		}

		responseDTO.setValue("Str", document.asXML());
		log.info(document.asXML());
		return responseDTO;
	}

	/*
	 * 仪表盘:项目周收入对比图
	 */
	public ISrvMsg getTeamIncomeWeekInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String week_first = "select to_number(to_char(to_date(to_char(sysdate,'yyyy')||'01-01','yyyy-MM-dd'),'d'))-2 week_first from dual";
		Map week = BeanFactory.getPureJdbcDAO().queryRecordBySQL(week_first);
		int first = week.get("week_first")==null ?0:Integer.valueOf((String)week.get("week_first"));
		StringBuffer sql = new StringBuffer("  with op_price as(select max((case NODE_CODE when 'S01021' then  price_unit  else  0   end)) - max((case NODE_CODE ");
		sql.append(" when 'S01022' then  price_unit  else  0   end)) price_unit,  project_info_no from bgp_op_price_project_info ");
		sql.append(" where bsflag = '0' group by project_info_no) ");
		sql.append(" select to_char(t.send_date+"+first+",'WW') weeks,sum(t.daily_finishing_sp) daily_finishing_sp,");
		sql.append(" sum(decode(t.EXPLORATION_METHOD,'0300100012000000003',t.finish_3d_workload,'0300100012000000002',t.finish_2d_workload)) workload, ");
		sql.append(" to_number(to_char(sum(decode(t.EXPLORATION_METHOD,'0300100012000000003',t.finish_3d_workload,'0300100012000000002',t.finish_2d_workload)*op.price_unit/10000),'9999999.00')) price");
		sql.append(" from rpt_gp_daily t  left outer join op_price op on t.project_info_no = op.project_info_no ");
		sql.append(" where t.project_info_no='"+projectInfoNo+"' group by to_char(t.send_date+"+first+",'WW') order by to_char(t.send_date+"+first+",'WW') asc");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("xAxisName ", "自然周");
		root.addAttribute("palette", "2");

		for (Map map : list) {
			Element set = root.addElement("set");
			set.addAttribute("value", (String) map.get("price"));
			set.addAttribute("label", (String) map.get("weeks"));
			set.addAttribute("showValue", "1");
			set.addAttribute("showLabel", "1");
			set.addAttribute("toolText", "周完成工作量："+(String) map.get("workload")+",炮数:"+(String) map.get("daily_finishing_sp")+",采集价值工作量（万元）:"+(String) map.get("price"));
			set.addAttribute("link", "j-drillxmsrmx-" + projectInfoNo+"-"+(String) map.get("weeks"));
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	/*
	 * 仪表盘:项目自然周内收入对比图
	 */
	public ISrvMsg getTeamIncomeWeekDayInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo"); 
		String week = reqDTO.getValue("week"); 
		String week_sql = "select to_number(to_char(to_date(to_char(sysdate,'yyyy')||'01-01','yyyy-MM-dd'),'d'))-2 week_first from dual";
		Map week_first = BeanFactory.getPureJdbcDAO().queryRecordBySQL(week_sql);
		int first = week_first.get("week_first")==null ?0:Integer.valueOf((String)week_first.get("week_first"));
		StringBuffer sql = new StringBuffer("  with op_price as(select max((case NODE_CODE when 'S01021' then  price_unit  else  0   end)) - max((case NODE_CODE ");
		sql.append(" when 'S01022' then  price_unit  else  0   end)) price_unit,  project_info_no from bgp_op_price_project_info ");
		sql.append(" where bsflag = '0' group by project_info_no) ");
		sql.append(" select t.send_date days,sum(t.daily_finishing_sp) daily_finishing_sp,");
		sql.append(" sum(decode(t.EXPLORATION_METHOD,'0300100012000000003',t.finish_3d_workload,'0300100012000000002',t.finish_2d_workload)) workload, ");
		sql.append(" to_number(to_char(sum(decode(t.EXPLORATION_METHOD,'0300100012000000003',t.finish_3d_workload,'0300100012000000002',t.finish_2d_workload)*op.price_unit/10000),'9999999.00')) price");
		sql.append(" from rpt_gp_daily t  left outer join op_price op on t.project_info_no = op.project_info_no ");
		sql.append(" where t.project_info_no='"+projectInfoNo+"'  and  to_char(t.send_date+"+first+",'WW')="+week+" group by t.send_date  order by t.send_date asc");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("xAxisName ", "日期");
		root.addAttribute("palette", "2");

		for (Map map : list) {
			Element set = root.addElement("set");
			set.addAttribute("value", (String) map.get("price"));
			set.addAttribute("label", (String) map.get("days"));
			set.addAttribute("showValue", "1");
			set.addAttribute("showLabel", "1");
			set.addAttribute("toolText", "当天完成工作量："+(String) map.get("workload")+",炮数:"+(String) map.get("daily_finishing_sp")+",采集价值工作量（万元）:"+(String) map.get("price"));
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	/*
	 * 仪表盘:小队目标成本与实际金额对比图
	 */
	public ISrvMsg getTeamTargetActualInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");// "8ad8788529ef02230129f2e53deb01ac";
		String parentId = reqDTO.getValue("parentId");
		StringBuffer sql = new StringBuffer();
		sql.append("with target_cost as (select t.cost_name,t.node_code,case nvl(m.proc_status,'1') when '3' then round(nvl(t.change_money,0)/10000*100)/100.0 ")
		.append(" else round(nvl(t.plan_money,0)/10000*100)/100.0 end cost_detail_money,t.order_code,connect_by_isleaf leaf from view_op_target_cost t ")
		.append(" left join common_busi_wf_middle m on m.business_id ='").append(projectInfoNo).append("' ")
		.append(" and m.busi_table_name ='BGP_OP_TARGET_PROJECT_INFO' and m.business_type ='5110000004100000014'")
		.append(" where t.project_info_no ='").append(projectInfoNo).append("' and t.node_code !='"+parentId+"' and t.node_code like '"+parentId+"%'")
		.append(" start with t.node_code='S01001' connect by prior t.gp_target_project_id = t.parent_id) ")
		.append(" select t.cost_name ,t.node_code,(select sum(tc.cost_detail_money) from target_cost tc where tc.node_code like t.node_code ||'%') plan_money ,")
		.append(" round(nvl(s.cost_detail_money,0)/10000*100)/100.0 actual_money ,t.leaf")
		.append(" from target_cost t left join view_op_target_actual_money_s s on t.node_code = s.node_code")
		.append(" where length(t.node_code)="+(parentId.length()+3)+" and s.project_info_no ='").append(projectInfoNo).append("' order by t.order_code");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "目标成本");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "实际成本");

		dataset1.addAttribute("color", PillarAColor);
		dataset2.addAttribute("color", PillarBColor);
		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("cost_name"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("plan_money"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("actual_money"));
			
			Double plan = Double.valueOf(((String) map.get("plan_money")));
			Double actual = Double.valueOf(((String) map.get("actual_money")));
			String percent = "";
			String displayValue = "";
			if(plan!=0){
				percent = "实际成本,"+(String) map.get("cost_name")+",￥"+actual+",是目标成本的"+Math.round(actual/plan*10000)/100.00+"%";
				displayValue = Math.round(actual/plan*10000)/100.00+"%";
			}else if(actual!=0){
				percent = "实际成本,"+(String) map.get("cost_name")+",￥"+actual+",是目标成本的100.0%";
				displayValue = "100%";
			}else{
				percent = "实际成本,"+(String) map.get("cost_name")+",￥"+actual;
			}
			set2.addAttribute("toolText", percent);
			set2.addAttribute("displayValue", displayValue);
			if("0".equals((String) map.get("leaf"))){
				set1.addAttribute("link", "j-drillxmtadt-" + (String) map.get("node_code"));
				set2.addAttribute("link", "j-drillxmtadt-" + (String) map.get("node_code"));
			}
			
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 预警分析
	 */
	public ISrvMsg getPlanActualCompareData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String nodeCode = reqDTO.getValue("nodeCode");
		StringBuffer sql = new StringBuffer();
		sql.append("select round(d.plan_money/10000*100)/100.0 plan_money,round(nvl(t.sum_cost_detail_money/10000*100,0))/100.0 sum_cost_detail_money,t.occur_date ")
		.append(" from (select nvl(sum(dd.cost_detail_money),0) plan_money,dd.project_info_no from(select d.cost_detail_money,p.project_info_no ")
		.append(" from bgp_op_target_project_info p left join bgp_op_target_project_detail d on p.gp_target_project_id = d.gp_target_project_id")
		.append(" where p.bsflag ='0' and p.project_info_no ='").append(projectInfoNo).append("' and p.node_code like '").append(nodeCode).append("%' union")
		.append(" select 0 cost_detail_money,'").append(projectInfoNo).append("' project_info_no from dual)dd group by dd.project_info_no ) d ")
		.append(" left join(select nvl(sum(dd.cost_detail_money),0) cost_detail_money,dd.occur_date,sum(sum(dd.cost_detail_money)) over(order by occur_date asc) sum_cost_detail_money,") 
		.append(" dd.project_info_no from(select d.cost_detail_money,to_char(d.occur_date,'MM-dd') occur_date ,p.project_info_no")
		.append(" from bgp_op_target_project_info p left join bgp_op_actual_project_detail d on p.gp_target_project_id = d.gp_target_project_id")
		.append(" where p.bsflag ='0' and p.project_info_no ='").append(projectInfoNo).append("' and p.node_code like '").append(nodeCode).append("%' ")
		.append(" and d.occur_date is not null and to_char(d.occur_date,'yyyy')=to_char(sysdate,'yyyy'))dd ")
		.append(" group by dd.project_info_no, dd.occur_date order by dd.occur_date)t on t.project_info_no=d.project_info_no");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		/*root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("palette", "2");
		root.addAttribute("labeldisplay", "wrap");*/
		
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showLabel", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		Element dataset2 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "实际成本");
		dataset2.addAttribute("seriesName", "目标成本");

		dataset1.addAttribute("color", LineAColor);
		dataset2.addAttribute("color", LineBColor);
		int i = 0;
		for (Map map : list) {
			if ((list.size() / 10) == 0 || i % (list.size() / 10) == 0 || i == (list.size() - 1)) {
				Element categoriesTemp = categories.addElement("category");
				categoriesTemp.addAttribute("label", (String) map.get("occur_date"));
				Element set1 = dataset1.addElement("set");
				Element set2 = dataset2.addElement("set");

				set1.addAttribute("value", (String) map.get("sum_cost_detail_money"));
				set1.addAttribute("anchorBgColor", LineAColor);

				set2.addAttribute("value", (String) map.get("plan_money"));
				set2.addAttribute("anchorBgColor", LineBColor);
			}
			i++;
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:公司二三维收入对比饼图
	 */
	public ISrvMsg getIncomeCompareTwoTreePieInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgSubjectionId=reqDTO.getValue("orgSubjectionId");
		orgSubjectionId=(orgSubjectionId==null||"".equals(orgSubjectionId))?"C105":orgSubjectionId;
		StringBuffer sql = new StringBuffer("with op_price as (select max((case NODE_CODE when 'S01021' then price_unit else 0 end)) - max((case NODE_CODE when 'S01022' then price_unit else 0 end))");
		sql.append("  price_unit, project_info_no  from bgp_op_price_project_info where bsflag='0' group by project_info_no) ");
		sql.append(" select to_char(sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload)*nvl(pi.price_unit,0))/10000,'9999999999999.00') w_price, ");
		sql.append(" decode(gp.exploration_method, '0300100012000000003', '三维', '0300100012000000002', '二维') w_label ");
		sql.append(" from rpt_gp_daily gd left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" left outer join op_price pi  on gd.project_info_no = pi.project_info_no   ");
		sql.append(" where gd.bsflag = '0' and gp.bsflag = '0' and gd.org_subjection_id like '"+orgSubjectionId+"%' and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') group by gp.exploration_method ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showPercentValues", "0");
		root.addAttribute("startingAngle", "175");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("yAxisName ", "(万元)");
		root.addAttribute("radius3D", "60");
		for (Map map : list) {
			Element dataset1 = root.addElement("set");
			dataset1.addAttribute("label", (String) map.get("w_label"));
			dataset1.addAttribute("value", (String) map.get("w_price"));
			dataset1.addAttribute("link", "j-drillxmsr-"+orgSubjectionId);
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:二三维支出对比饼图
	 */
	public ISrvMsg getOutcomeCompareTwoTreePieInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgSubjectionId=reqDTO.getValue("orgSubjectionId");
		orgSubjectionId=(orgSubjectionId==null||"".equals(orgSubjectionId))?"C105":orgSubjectionId;
		StringBuffer sql = new StringBuffer("with project_team as(select distinct gp.project_info_no, gp.project_name,ot.team_id,pd.org_subjection_id ");
		sql.append(" from gp_task_project gp ");
		sql.append(" left outer join gp_task_project_dynamic pd on gp.project_info_no = pd.project_info_no and gp.bsflag = '0' ");
		sql.append(" left outer join comm_org_team ot on pd.org_id = ot.org_id and ot.bsflag = '0' where gp.bsflag = '0') ");
		sql.append(" select to_char(sum(pd.cost_detail_money) / 10000, '99999999999999.00') w_price, ");
		sql.append(" decode(gp.exploration_method,'0300100012000000003','三维','0300100012000000002', '二维') w_label ");
		sql.append(" from bgp_op_actual_project_detail pd ");
		sql.append(" inner join bgp_op_target_project_info pi on pd.gp_target_project_id = pi.gp_target_project_id and pi.bsflag = '0' and pd.bsflag = '0' ");
		sql.append(" inner join gp_task_project gp on pi.project_info_no = gp.project_info_no ");
		sql.append(" left outer join project_team pt on gp.project_info_no = pt.project_info_no ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pd.bsflag = '0' and pi.node_code like 'S01001%' ");
		sql.append(" and to_date(to_char(pd.occur_date, 'yyyy-MM'),'yyyy-MM') <= to_date(to_char(sysdate, 'yyyy-MM'),'yyyy-MM') ");
		sql.append(" and pt.org_subjection_id like '"+orgSubjectionId+"%' group by gp.exploration_method ");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showPercentValues", "0");
		root.addAttribute("startingAngle", "175");
		root.addAttribute("baseFontSize ", "12");

		for (Map map : list) {
			Element dataset1 = root.addElement("set");
			dataset1.addAttribute("label", (String) map.get("w_label"));
			dataset1.addAttribute("value", (String) map.get("w_price"));
			dataset1.addAttribute("link", "j-drillxmzc-"+orgSubjectionId );
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	/*
	 * 仪表盘:二三维利润对比饼图
	 */
	public ISrvMsg getCompareTwoTreeLirunPieInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgSubjectionId=reqDTO.getValue("orgSubjectionId");
		orgSubjectionId=(orgSubjectionId==null||"".equals(orgSubjectionId))?"C105":orgSubjectionId;
		StringBuffer sql = new StringBuffer("with op_price as (select max((case NODE_CODE when 'S01021' then price_unit else 0 end)) - max((case NODE_CODE when 'S01022' then price_unit else 0 end)) ");
		sql.append("  price_unit, project_info_no  from bgp_op_price_project_info where bsflag='0' group by project_info_no) , ");
		sql.append(" project_team as(select distinct gp.project_info_no, gp.project_name,ot.team_id,pd.org_subjection_id  ");
		sql.append(" from gp_task_project gp  ");
		sql.append(" left outer join gp_task_project_dynamic pd on gp.project_info_no = pd.project_info_no and gp.bsflag = '0'  ");
		sql.append(" left outer join comm_org_team ot on pd.org_id = ot.org_id and ot.bsflag = '0')  ");
		sql.append(" SELECT T1.W_PRICE-T2.W_PRICE PRICE,T1.W_LABEL FROM( ");
		sql.append(" select to_char(sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload)*nvl(pi.price_unit,0))/10000,'9999999999999.00') w_price, "); 
		sql.append(" decode(gp.exploration_method, '0300100012000000003', '三维', '0300100012000000002', '二维') w_label  ");
		sql.append(" from rpt_gp_daily gd left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no  ");
		sql.append(" left outer join op_price pi  on gd.project_info_no = pi.project_info_no    ");
		sql.append(" where gd.bsflag = '0'   AND  gd.org_subjection_id like '"+orgSubjectionId+"%' and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') group by gp.exploration_method) T1 ");
		sql.append(" FULL JOIN ( select to_char(sum(pd.cost_detail_money) / 10000, '99999999999999.00') w_price,  ");
		sql.append(" decode(gp.exploration_method,'0300100012000000003','三维','0300100012000000002', '二维') w_label  ");
		sql.append(" from bgp_op_actual_project_detail pd  ");
		sql.append(" inner join bgp_op_target_project_info pi on pd.gp_target_project_id = pi.gp_target_project_id and pi.bsflag = '0' and pd.bsflag = '0' "); 
		sql.append(" inner join gp_task_project gp on pi.project_info_no = gp.project_info_no  ");
		sql.append(" left outer join project_team pt on gp.project_info_no = pt.project_info_no  ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pd.bsflag = '0' and pi.node_code like 'S01001%'  ");
		sql.append(" and to_date(to_char(pd.occur_date, 'yyyy-MM'),'yyyy-MM') <= to_date(to_char(sysdate, 'yyyy-MM'),'yyyy-MM') ");
		sql.append(" and pt.org_subjection_id like '"+orgSubjectionId+"%' group by gp.exploration_method  )T2 ");
		sql.append(" ON T1.W_LABEL=T2.W_LABEL ");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showPercentValues", "0");
		root.addAttribute("startingAngle", "175");
		root.addAttribute("baseFontSize ", "12");

		for (Map map : list) {
			Element dataset1 = root.addElement("set");
			dataset1.addAttribute("label", (String) map.get("w_label"));
			dataset1.addAttribute("value", (String) map.get("price"));
			dataset1.addAttribute("link", "j-drillxmlr-"+orgSubjectionId );
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	/*
	 * 仪表盘:公司收入国内国际对比
	 */
	public ISrvMsg getCompanyCompareCountryInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("with op_price as(select max((case NODE_CODE when 'S01021' then price_unit else 0 ");
		sql.append(" end)) - max((case NODE_CODE when 'S01022' then price_unit else 0 end)) price_unit, ");
		sql.append(" project_info_no from bgp_op_price_project_info where bsflag = '0' group by project_info_no) ");
		sql.append(" select t.*,p.target from( select nvl(to_number(to_char(sum(decode(to_char(gd.send_date, 'yyyy'),to_char(sysdate, 'yyyy'),  ");
		sql.append(" decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload),  ");
		sql.append(" 0)*op.price_unit)/10000,'999999999.00')),0) new_price,  ");
		sql.append(" nvl(to_number(to_char(sum(decode(to_char(gd.send_date, 'yyyy'),to_char(add_months(sysdate, -12), 'yyyy'),  ");
		sql.append(" decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload),  ");
		sql.append(" 0)*op.price_unit)/ 10000,'999999999.00')),0) old_price,  ");
		sql.append(" decode(Substr(sd.coding_code, 0, 2), '01', '国内采集收入', '国际采集收入') w_label  ");
		sql.append(" from rpt_gp_daily gd  ");
		sql.append(" left outer join op_price op on gd.project_info_no = op.project_info_no ");
		sql.append(" left outer join comm_coding_sort_detail sd on gd.market_classify = sd.coding_code_id  ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no  ");
		sql.append(" where gd.bsflag = '0' and (to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') or  ");
		sql.append(" to_char(gd.send_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) ");
		sql.append(" group by Substr(sd.coding_code, 0, 2) ");
		sql.append(" ) t left outer join (select  to_char(sum(t.money),'9999999999.99') target,decode(t.org_info,'C105002','国际采集收入','国内采集收入') w_label  ");
		sql.append(" from BGP_OP_COST_INCOME_INDEX t where t.type='0' and  t.year=to_char(sysdate,'yyyy') group by decode(t.org_info,'C105002','国际采集收入','国内采集收入') )p on t.w_label=p.w_label ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showPercentValues", "0");
		root.addAttribute("startingAngle", "175");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("chartTopMargin ", "12");
		root.addAttribute("captionPadding ", "1");
		root.addAttribute("pieRadius", "150");

		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		dataset.addAttribute("seriesName", "去年完成值");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "今年完成指标");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年完成值");
		
		
		for (Map map : list) {
			String label=(String) map.get("w_label");
			Element category = categories.addElement("category");
			category.addAttribute("label", (String) map.get("w_label"));
			
			Element set = dataset.addElement("set");
			set.addAttribute("value", (String) map.get("old_price")==null?"0": (String) map.get("old_price"));
			
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("new_price")==null?"0": (String) map.get("new_price"));
			
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("target")==null||"".equals(map.get("target"))?"0": (String) map.get("target"));
			if("国内采集收入".equals(label)){
				set1.addAttribute("link", "j-drillwtsr-0");
			}else if ( "国际采集收入".equals(label) ){
				set1.addAttribute("link", "j-drillwtsr-1");
			}
			
			
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	/*
	 * 仪表盘:公司国内国际支出对比饼图
	 */
	public ISrvMsg getCompanyCompareCountryOutInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("select nvl(t2.w_price,0) w_price,t1.label w_label from(select '国内支出' label from dual union  select '国际支出' label from dual)t1 left outer join( ");
		sql.append(" select to_number(to_char(sum(pd.cost_detail_money)/10000,'99999999999999.00')) w_price,  ");
		sql.append(" decode(Substr(sd.coding_code, 0, 2), '01', '国内支出', '国际支出') w_label  from bgp_op_actual_project_detail pd  ");
		sql.append(" inner join bgp_op_target_project_info pi on pd.gp_target_project_id = pi.gp_target_project_id and pi.bsflag = '0' and pd.bsflag = '0'  ");
		sql.append(" inner join gp_task_project gp on pi.project_info_no = gp.project_info_no  ");
		sql.append(" left outer join comm_coding_sort_detail sd on gp.market_classify = sd.coding_code_id  ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pd.bsflag = '0' and pi.Node_Code like 'S01001%'  group by Substr(sd.coding_code, 0, 2))t2 on t1.label=t2.w_label ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showPercentValues", "0");
		root.addAttribute("startingAngle", "175");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("yAxisName ", "(万元)");
		root.addAttribute("pieRadius", "150");
		
		Element categories = root.addElement("categories");
		Element dataset = root.addElement("dataset");
		
		for (Map map : list) {
			
			Element category = categories.addElement("category");
			category.addAttribute("label", (String) map.get("w_label"));
			Element set = dataset.addElement("set");
			set.addAttribute("value", (String) map.get("w_price"));
			if("国际支出".equals((String) map.get("w_label"))){
				set.addAttribute("link", "j-drillwtzc-0" );
			}else{
				set.addAttribute("link", "j-drillwtzc-1" );
			}
			
			
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	/*
	 * 仪表盘:公司收入国内国际对比
	 */
	public ISrvMsg getCompanyCompareCountryLirunInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("with op_price as (select max((case NODE_CODE when 'S01021' then  price_unit else 0 end)) - max((case NODE_CODE when 'S01022' then ");
		sql.append(" price_unit else 0 end)) price_unit, project_info_no from bgp_op_price_project_info where bsflag = '0' group by project_info_no) ");
		sql.append(" select t1.new_price - t2.w_price price, t1.w_label from (select to_number(to_char(sum(decode(to_char(gd.send_date, 'yyyy'), ");
		sql.append(" to_char(sysdate, 'yyyy'),decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002', ");
		sql.append(" gd.finish_2d_workload),0) * op.price_unit) / 10000,'999999999.00')) new_price,decode(Substr(sd.coding_code, 0, 2), '01', '国内', '国际') w_label ");
		sql.append(" from rpt_gp_daily gd left outer join op_price op on gd.project_info_no = op.project_info_no ");
		sql.append(" left outer join comm_coding_sort_detail sd on gd.market_classify = sd.coding_code_id ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0' and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') group by Substr(sd.coding_code, 0, 2)) t1 ");
		sql.append(" full join (select to_number(to_char(sum(pd.cost_detail_money) / 10000, '99999999999999.00')) w_price, decode(Substr(sd.coding_code, 0, 2), ");
		sql.append(" '01','国内','国际') w_label from bgp_op_actual_project_detail pd ");
		sql.append(" inner join bgp_op_target_project_info pi on pd.gp_target_project_id = pi.gp_target_project_id and pi.bsflag = '0' and pd.bsflag = '0' ");
		sql.append(" inner join gp_task_project gp on pi.project_info_no = gp.project_info_no ");
		sql.append(" left outer join comm_coding_sort_detail sd on gp.market_classify = sd.coding_code_id ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pd.bsflag = '0' and pi.Node_Code like 'S01001%' ");
		sql.append(" group by Substr(sd.coding_code, 0, 2)) t2 on t1.w_label = t2.w_label");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showPercentValues", "0");
		root.addAttribute("startingAngle", "175");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("yAxisName ", "(万元)");
		root.addAttribute("pieRadius", "150");
		for (Map map : list) {
			Element set1 = root.addElement("set");
			set1.addAttribute("label", (String) map.get("w_label"));
			set1.addAttribute("value", (String) map.get("price"));
			set1.addAttribute("link", "j-drillwtlr-0" );
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	/*
	 * 仪表盘:物探处收入支出对比柱状图
	 */
	public ISrvMsg getAllcomeCompareYearInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgSubjectionId=reqDTO.getValue("orgSubjectionId");
		orgSubjectionId=(orgSubjectionId==null||"".equals(orgSubjectionId))?"C105":orgSubjectionId;
		
		StringBuffer sql = new StringBuffer("with op_price as (select max((case NODE_CODE when 'S01021' then price_unit else 0 end)) - max((case NODE_CODE ");
		sql.append(" when 'S01022' then  price_unit else 0  end)) price_unit, project_info_no from bgp_op_price_project_info ");
		sql.append(" where bsflag = '0' group by project_info_no), org_name_sub as (select distinct gp.project_info_no, ");
		sql.append(" gp.project_name,ot.team_id,pd.org_subjection_id from gp_task_project gp ");
		sql.append(" left outer join gp_task_project_dynamic pd  on gp.project_info_no = pd.project_info_no  and gp.bsflag = '0' ");
		sql.append(" left outer join comm_org_team ot  on pd.org_id = ot.org_id  and ot.bsflag = '0' ");
		sql.append(" where pd.org_subjection_id like '"+orgSubjectionId+"%') ");
		sql.append(" select t1.w_price income, t2.w_price outcome, '今年' come_desc ");
		sql.append(" from (select to_number(to_char(nvl(sum(decode(gp.EXPLORATION_METHOD, '0300100012000000003', gd.finish_3d_workload, ");
		sql.append(" '0300100012000000002',gd.finish_2d_workload) *nvl(op.price_unit, 0)),0) / 10000,'9999999999999.00')) w_price ");
		sql.append(" from rpt_gp_daily gd left outer join op_price op on gd.project_info_no = op.project_info_no ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0' and gd.org_subjection_id like '"+orgSubjectionId+"%' and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy')) t1 ");
		sql.append(" left outer join (select nvl(to_char(sum(pd.cost_detail_money) / 10000, '9999999999.00'),0) w_price ");
		sql.append(" from bgp_op_actual_project_detail pd inner join bgp_op_target_project_info pi on pd.gp_target_project_id = pi.gp_target_project_id ");
		sql.append(" and pi.bsflag = '0' and pd.bsflag = '0' inner join gp_task_project gp on pi.project_info_no = gp.project_info_no ");
		sql.append(" inner join org_name_sub os on pi.project_info_no = os.project_info_no ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pi.node_code like 'S01001%' and pd.bsflag = '0') t2 on 1 = 1 ");
		sql.append(" union ");
		sql.append(" select t1.w_price income, t2.w_price outcome, '去年' come_desc ");
		sql.append(" from (select to_number(to_char(nvl(sum(decode(gp.EXPLORATION_METHOD, '0300100012000000003', gd.finish_3d_workload, ");
		sql.append(" '0300100012000000002',gd.finish_2d_workload) *nvl(op.price_unit, 0)),0) / 10000,'9999999999999.00')) w_price ");
		sql.append(" from rpt_gp_daily gd left outer join op_price op on gd.project_info_no = op.project_info_no ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0' and gd.org_subjection_id like '"+orgSubjectionId+"%' and to_char(gd.send_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) t1 ");
		sql.append(" left outer join (select nvl(to_char(sum(pd.cost_detail_money) / 10000, '9999999999.00'), 0) w_price ");
		sql.append(" from bgp_op_actual_project_detail pd ");
		sql.append(" inner join bgp_op_target_project_info pi on pd.gp_target_project_id = pi.gp_target_project_id and pi.bsflag = '0' and pd.bsflag = '0' ");
		sql.append(" inner join gp_task_project gp on pi.project_info_no = gp.project_info_no inner join org_name_sub os on pi.project_info_no = os.project_info_no ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy') and pi.node_code like 'S01001%' and pd.bsflag = '0') t2 on 1 = 1 ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("palette", "2");
		root.addAttribute("labeldisplay", "wrap");

		Element categories = root.addElement("categories");
		Element category1 = categories.addElement("category");
		Element category2 = categories.addElement("category");
		category1.addAttribute("label", "收入");
		category2.addAttribute("label", "支出");

		for (Map map : list) {
			Element dataset = root.addElement("dataset");
			dataset.addAttribute("seriesName", (String) map.get("come_desc"));
			Element set1 = dataset.addElement("set");
			set1.addAttribute("value", (String) map.get("income"));
			Element set2 = dataset.addElement("set");
			set2.addAttribute("value", (String) map.get("outcome"));
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	
	/*
	 * 仪表盘:物探处收入完成情况(二三维对比)
	 */
	public ISrvMsg getCompareSectionIncomeTwoThreeInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String isGuoNei=reqDTO.getValue("isGuoNei");
		
		StringBuffer sql = new StringBuffer("with op_price as(select max((case NODE_CODE  when 'S01021' then price_unit  else  0 end)) - max((case NODE_CODE ");
		sql.append(" when 'S01022' then price_unit else 0 end)) price_unit, project_info_no from bgp_op_price_project_info where bsflag = '0' group by project_info_no) select");
		sql.append(" to_number(to_char(sum(nvl(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',0)* pi.price_unit / 10000,0)),'9999999999.00')) price3 ");
		sql.append(" ,to_number(to_char(sum(nvl(decode(gp.EXPLORATION_METHOD,'0300100012000000003',0,'0300100012000000002',gd.finish_2d_workload) * pi.price_unit / 10000,0)),'9999999999.00')) price2 ");
		sql.append(" ,to_number(to_char(sum(nvl(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',0),0)),'9999999999.00')) workload_3d ");
		sql.append(" ,to_number(to_char(sum(nvl(decode(gp.EXPLORATION_METHOD,'0300100012000000003',0,'0300100012000000002',gd.finish_2d_workload) ,0)),'9999999999.00')) workload_2d ");
		sql.append(" ,to_number(to_char(sum(nvl(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.DAILY_FINISHING_SP,'0300100012000000002',0),0)),'9999999999.00')) sp_3 ");
		sql.append(" ,to_number(to_char(sum(nvl(decode(gp.EXPLORATION_METHOD,'0300100012000000003',0,'0300100012000000002',gd.DAILY_FINISHING_SP),0)),'9999999999.00')) sp_2 ");
		sql.append(" ,ns.org_short_name w_label,ns.org_subjection_id  from bgp_comm_org_wtc ns ");
		sql.append(" left outer join rpt_gp_daily gd on gd.org_subjection_id like ns.org_subjection_id || '%' and gd.bsflag = '0' ");
		sql.append(" and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') ");
		sql.append(" left outer join op_price pi on gd.project_info_no = pi.project_info_no ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" group by ns.org_short_name, ns.org_subjection_id, ns.order_num order by ns.order_num ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "三维");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "二维");

		dataset1.addAttribute("color", PillarAColor);
		dataset2.addAttribute("color", PillarBColor);
		List listRemove=new ArrayList();
		for (Map map : list) {
			if(("0".equals(isGuoNei)&&!"国际部".equals(map.get("w_label")))||("1".equals(isGuoNei)&&"国际部".equals(map.get("w_label")))||(!"1".equals(isGuoNei)&&!"0".equals(isGuoNei))){
				Element category1 = categories.addElement("category");
				category1.addAttribute("label", (String) map.get("w_label"));
				Element set1 = dataset1.addElement("set");
				set1.addAttribute("value", (String) map.get("price3"));
				Element set2 = dataset2.addElement("set");
				set2.addAttribute("value", (String) map.get("price2"));
				set1.addAttribute("link", "j-drillxmsr-" + (String) map.get("org_subjection_id"));
			}else{
				listRemove.add(map);
			}
			
		}
		list.removeAll(listRemove);
		responseDTO.setValue("Str", document.asXML());
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/*
	 * 仪表盘:公司物探处支出对比图(二三维对比)
	 */
	public ISrvMsg getCompareSectionOutcomeTwoThreeInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("  select to_char(sum(decode(gp.exploration_method, '0300100012000000003', pd.cost_detail_money / 10000, 0)), ");
		sql.append(" '9999999999.00') price3,to_char(sum(decode(gp.exploration_method,'0300100012000000002',pd.cost_detail_money / 10000,0)), ");
		sql.append(" '9999999999.00') price2, ns.org_short_name w_label,ns.org_subjection_id from bgp_comm_org_wtc ns ");
		sql.append(" left outer join gp_task_project_dynamic t1 on t1.org_subjection_id like ns.org_subjection_id || '%' ");
		sql.append(" left outer join bgp_op_target_project_info pi on pi.project_info_no = t1.project_info_no and pi.bsflag = '0' and pi.node_code like 'S01001%' ");
		sql.append(" left outer join gp_task_project gp on pi.project_info_no=gp.project_info_no and gp.bsflag='0' ");
		sql.append(" left outer join bgp_op_actual_project_detail pd  on pd.gp_target_project_id = pi.gp_target_project_id ");
		sql.append(" and pd.bsflag = '0' and (to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') or ");
		sql.append(" to_char(pd.occur_date, 'yyyy') =to_char(add_months(sysdate, -12), 'yyyy')) ");
		sql.append(" group by ns.org_short_name, ns.org_subjection_id, ns.order_num ");
		sql.append(" order by ns.order_num ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "三维");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "二维");

		dataset1.addAttribute("color", PillarAColor);
		dataset2.addAttribute("color", PillarBColor);
		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("w_label"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("price3"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("price2"));
			set1.addAttribute("link", "j-drillxmzc-" + (String) map.get("org_subjection_id"));
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	/*
	 * 仪表盘:公司物探处利润对比图(二三维对比)
	 */
	public ISrvMsg getCompareSectionLirunTwoThreeInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("       with op_price as(select max((case NODE_CODE  when 'S01021' then price_unit  else  0 end)) - max((case NODE_CODE  ");
		sql.append(" when 'S01022' then price_unit else 0 end)) price_unit, project_info_no from bgp_op_price_project_info  ");
		sql.append("  where bsflag = '0' group by project_info_no)  ");
		sql.append(" select t1.price3-t2.price3 price3 ,t1.price2-t2.price2 price2,t1.w_label, t1.org_subjection_id from(  select to_number(to_char(sum(nvl(  ");
		sql.append(" decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',0) * pi.price_unit / 10000,0)),  ");
		sql.append(" '9999999999.00')) price3,to_number(to_char(sum(nvl(decode(gp.EXPLORATION_METHOD,'0300100012000000003',0,'0300100012000000002',  ");
		sql.append(" gd.finish_2d_workload) * pi.price_unit / 10000,0)),'9999999999.00')) price2,ns.org_short_name w_label,ns.org_subjection_id  ");
		sql.append(" from bgp_comm_org_wtc ns  ");
		sql.append(" left outer join rpt_gp_daily gd on gd.org_subjection_id like ns.org_subjection_id || '%' and gd.bsflag = '0'  ");
		sql.append(" and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy')  ");
		sql.append("  left outer join op_price pi on gd.project_info_no = pi.project_info_no  ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no  ");
		sql.append(" group by ns.org_short_name, ns.org_subjection_id, ns.order_num order by ns.order_num ) t1 ");
		sql.append(" full join (select to_char(sum(decode(gp.exploration_method, '0300100012000000003', pd.cost_detail_money / 10000, 0)),  ");
		sql.append(" '9999999999.00') price3,to_char(sum(decode(gp.exploration_method,'0300100012000000002',pd.cost_detail_money / 10000,0)),  ");
		sql.append(" '9999999999.00') price2, ns.org_short_name w_label,ns.org_subjection_id from bgp_comm_org_wtc ns  ");
		sql.append(" left outer join gp_task_project_dynamic t1 on t1.org_subjection_id like ns.org_subjection_id || '%'  ");
		sql.append(" left outer join bgp_op_target_project_info pi on pi.project_info_no = t1.project_info_no and pi.bsflag = '0' and pi.node_code like 'S01001%'  ");
		sql.append(" left outer join gp_task_project gp on pi.project_info_no=gp.project_info_no and gp.bsflag='0'  ");
		sql.append(" left outer join bgp_op_actual_project_detail pd  on pd.gp_target_project_id = pi.gp_target_project_id  ");
		sql.append(" and pd.bsflag = '0' and (to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') or  ");
		sql.append(" to_char(pd.occur_date, 'yyyy') =to_char(add_months(sysdate, -12), 'yyyy')) "); 
		sql.append(" group by ns.org_short_name, ns.org_subjection_id, ns.order_num  ");
		sql.append(" order by ns.order_num  ");
		sql.append(" )t2 on t1.org_subjection_id=t2.org_subjection_id ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("labeldisplay", "none");
		root.addAttribute("palette", "2");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "三维");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "二维");

		dataset1.addAttribute("color", PillarAColor);
		dataset2.addAttribute("color", PillarBColor);
		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("w_label"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("price3"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("price2"));
			set1.addAttribute("link", "j-drillxmlr-" + (String) map.get("org_subjection_id"));
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	
	/*
	 * 仪表盘:目标成本与实际费用累计支出对比
	 */
	public ISrvMsg getCompareTargetActualInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo=reqDTO.getValue("projectInfoNo");
		if(projectInfoNo==null||"".equals(projectInfoNo)){
			UserToken user = reqDTO.getUserToken();
			projectInfoNo=user.getProjectInfoNo();
		}
		StringBuffer sql = new StringBuffer(" select * from(SELECT case nvl(m.proc_status,'1') when '3' then round(sum(nvl(t.change_money,0))/10000*100)/100.0 else round(sum(nvl(t.plan_money,0))/10000*100)/100.0 end cost_detail_money,'目标成本' label from view_op_target_cost t  ");
		sql.append(" left join common_busi_wf_middle m on m.business_id ='"+projectInfoNo+"' and m.busi_table_name ='BGP_OP_TARGET_PROJECT_INFO' and m.business_type ='5110000004100000014' where t.node_code like 'S01001%' and t.project_info_no ='"+projectInfoNo+"'");
		sql.append(" group by m.proc_status union SELECT TO_NUMBER(TO_CHAR(cost_detail_money/10000,'99999999.00')) cost_detail_money,'实际费用' label FROM view_op_target_actual_money_s WHERE node_code = 'S01001' AND PROJECT_INFO_NO='"+projectInfoNo+"') order by label asc ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showLabel", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("palette", "2");

		String labelDescription=null;
		String displayValue = "";
		if(list!=null&&list.size()>1){
			Map map1=list.get(0);
			Map map2=list.get(1);
			String valuePlan=(String) map1.get("cost_detail_money");
			String valueActual=(String) map2.get("cost_detail_money");
			
			try{
			double plan=Double.parseDouble(valuePlan);
			double actual=Double.parseDouble(valueActual);
			if(plan!=0){
				DecimalFormat f = new DecimalFormat();
				f.applyPattern("#.##");	
				String result=f.format(actual/plan*100);
				labelDescription="实际成本占目标成本的"+result+"%";
				displayValue=result+"%";
			}
			}catch(Exception ex){
				labelDescription="转化出错，实际成本目标成本有问题";
			}
			
		}
		
		
		for (Map map : list) {
			Element set = root.addElement("set");
			set.addAttribute("toolText", labelDescription);
			set.addAttribute("label", (String) map.get("label"));
			set.addAttribute("value", (String) map.get("cost_detail_money"));
			set.addAttribute("displayValue", (String) map.get("cost_detail_money")+","+displayValue);
			set.addAttribute("link", "j-drillxmtadb-" + projectInfoNo);
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	/*
	 * 仪表盘:目标成本与实际费用累计支出对比 ,综合物化探专用
	 * 夏秋雨添加 	
	 * 2013-11-14
	 */
	public ISrvMsg getWhtTargetActualInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo =reqDTO.getValue("projectInfoNo");
		String nodeCode =reqDTO.getValue("nodeCode");
		if(projectInfoNo==null||"".equals(projectInfoNo)){
			UserToken user = reqDTO.getUserToken();
			projectInfoNo=user.getProjectInfoNo();
		}
		if(nodeCode==null || nodeCode.trim().equals("")){
			nodeCode = "S01";
		}
		StringBuffer sql = new StringBuffer(" select * from(SELECT case nvl(m.proc_status,'1') when '3' then round(sum(nvl(t.change_money,0))/10000*100)/100.0 else round(sum(nvl(t.plan_money,0))/10000*100)/100.0 end cost_detail_money,'目标成本' label from view_op_target_cost t  ");
		sql.append(" left join common_busi_wf_middle m on m.business_id ='"+projectInfoNo+"' and m.busi_table_name ='BGP_OP_TARGET_PROJECT_INFO' and m.business_type ='5110000004100000014' where t.node_code like '"+nodeCode+"%' and t.project_info_no ='"+projectInfoNo+"'");
		sql.append(" group by m.proc_status union SELECT round(nvl(sum(cost_detail_money/10000),0)*100)/100.0 cost_detail_money,'实际费用' label FROM view_op_target_actual_money_s WHERE node_code like '"+nodeCode+"%' AND PROJECT_INFO_NO='"+projectInfoNo+"') order by label asc ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("showLabel", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("rotateYAxisName ", "0");
		root.addAttribute("yAxisNameWidth ", "16");
		root.addAttribute("yAxisName ", "万元");
		root.addAttribute("palette", "2");

		String labelDescription=null;
		String displayValue = "";
		if(list!=null&&list.size()>1){
			Map map1=list.get(0);
			Map map2=list.get(1);
			String valuePlan=(String) map1.get("cost_detail_money");
			String valueActual=(String) map2.get("cost_detail_money");
			
			try{
			double plan=Double.parseDouble(valuePlan);
			double actual=Double.parseDouble(valueActual);
			if(plan!=0){
				DecimalFormat f = new DecimalFormat();
				f.applyPattern("#.##");	
				String result=f.format(actual/plan*100);
				labelDescription="实际成本占目标成本的"+result+"%";
				displayValue=result+"%";
			}
			}catch(Exception ex){
				labelDescription="转化出错，实际成本目标成本有问题";
			}
		}
		
		for (Map map : list) {
			Element set = root.addElement("set");
			set.addAttribute("toolText", labelDescription);
			set.addAttribute("label", (String) map.get("label"));
			set.addAttribute("value", (String) map.get("cost_detail_money"));
			set.addAttribute("displayValue", (String) map.get("cost_detail_money")+","+displayValue);
			set.addAttribute("link", "j-drillxmtadb-" + projectInfoNo);
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	
	
	// ==============================〉〉仪表盘结束

	// ====================================〉〉仪表盘暂时不使用

	/*
	 * 仪表盘:公司收入同比折线图
	 */
	public ISrvMsg getIncomeCompareYearInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer(
				"with temp_rq as (select add_months(to_date(to_char(sysdate, 'yyyy') || '0101', 'yyyymmdd') - 1, rownum) d_month from dual connect by rownum < 13) ");
		sql.append(" select TO_UPPER_NUM(to_number(to_char(d_month, 'mm')),0,0)||'月' month, ");
		sql.append(" sum(wz.w_price) over(order by to_char(d_month, 'mm') asc) old_price, ");
		sql.append(" sum(wl.w_price) over(order by to_char(d_month, 'mm') asc) now_price from temp_rq rq ");
		sql.append(" left outer join (select sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload)) w_price, ");
		sql.append(" to_char(gd.send_date, 'yyyymm') m_month from rpt_gp_daily gd left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0' group by to_char(gd.send_date, 'yyyymm')) wl on to_char(rq.d_month, 'yyyymm') = wl.m_month ");
		sql.append(" left outer join (select sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload)) w_price, ");
		sql.append(" to_char(gd.send_date, 'yyyymm') m_month from rpt_gp_daily gd ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0' group by to_char(gd.send_date, 'yyyymm')) wz ");
		sql.append(" on to_char(add_months(rq.d_month, -12), 'yyyymm') = wz.m_month order by to_number(to_char(d_month, 'mm'))");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");

		root.addAttribute("xAxisName", "月份");
		root.addAttribute("yAxisName ", "收入（万元）");
		root.addAttribute("baseFontSize ", "12");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年度收入");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "去年收入");
		for (Map map : list) {
			Element categoriesTemp = categories.addElement("category");
			categoriesTemp.addAttribute("label", (String) map.get("month"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("now_price"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("old_price"));
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:项目收入对比柱状图
	 */
	public ISrvMsg getIncomeCompareProjectInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer(
				"select sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload)) w_price, ");
		sql.append(" gp.project_name w_label from rpt_gp_daily gd left outer join gp_task_project gp  on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0' and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') group by gp.project_name ");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("xAxisName", "项目名称");
		root.addAttribute("yAxisName ", "项目收入（万元）");
		root.addAttribute("baseFontSize ", "12");

		for (Map map : list) {
			Element dataset1 = root.addElement("set");
			dataset1.addAttribute("label", (String) map.get("w_label"));
			dataset1.addAttribute("value", (String) map.get("w_price"));
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}


	/*
	 * 仪表盘:项目支出对比柱状图
	 */
	public ISrvMsg getOutcomeCompareProjectInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer(
				"select to_char(sum(pd.cost_detail_money)/10000,'99999999999999.00') w_price,gp.project_name w_label from bgp_op_actual_project_detail pd ");
		sql.append(" inner join bgp_op_target_project_info pi on pd.gp_target_project_id = pi.gp_target_project_id and pi.bsflag = '0' and pd.bsflag = '0' ");
		sql.append(" inner join gp_task_project gp on pi.project_info_no = gp.project_info_no ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pd.bsflag = '0' group by gp.project_name ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("xAxisName", "项目名称");
		root.addAttribute("yAxisName ", "采集直接费用(万元)");
		root.addAttribute("baseFontSize ", "12");

		for (Map map : list) {
			Element dataset1 = root.addElement("set");
			dataset1.addAttribute("label", (String) map.get("w_label"));
			dataset1.addAttribute("value", (String) map.get("w_price"));
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}


	/*
	 * 物探处利润完成情况
	 */
	public ISrvMsg getSectionIncomeInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		UserToken user = reqDTO.getUserToken();
		String orgSubjectId = orgId == null || "".equals(orgId) ? user.getSubOrgIDofAffordOrg() : orgId;
		StringBuffer sql = new StringBuffer("with temp_rq as (select add_months(to_date(to_char(sysdate, 'yyyy') || '0101', 'yyyymmdd') - 1, rownum) d_month from dual　");
		sql.append(" connect by rownum < 13) select *　from (select to_char(d_month,'MM')　month,actual_price,sum(n.money) plan_money from (　　");
		sql.append(" select tr.d_month, to_number(to_char(sum(w_price), '99999990.00')) actual_price from temp_rq tr　　");
		sql.append(" left outer join (select decode(gp.EXPLORATION_METHOD,'0300100012000000003', gd.finish_3d_workload,'0300100012000000002',　　");
		sql.append(" gd.finish_2d_workload)*nvl(pi.price_unit, 0) / 10000 w_price,gd.project_info_no,gd.send_date　　");
		sql.append(" from rpt_gp_daily gd  left outer join gp_task_project gp  on gd.project_info_no = gp.project_info_no　　");
		sql.append(" left outer join bgp_op_price_project_info pi  on gd.project_info_no = pi.project_info_no  and pi.bsflag = '0'  and pi.node_code = 'S01021'　　");
		sql.append(" where gd.bsflag = '0' and gd.org_subjection_id like '" + orgSubjectId
				+ "%'  and to_char(gd.send_date, 'yyyy') =  to_char(sysdate, 'yyyy')) pr on tr.d_month >= pr.send_date　　");
		sql.append(" group by tr.d_month) m left outer join bgp_op_cost_income_index n on to_char(m.d_month,'yyyy')=n.year　　");
		sql.append(" and to_char(m.d_month,'MM')=n.month and n.org_info like '" + orgSubjectId + "%' group  by d_month,actual_price) order by　month");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "0");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "指标");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "实际收入");
		for (Map map : list) {
			Element categoriesTemp = categories.addElement("category");
			categoriesTemp.addAttribute("label", (String) map.get("month"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("plan_money"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("actual_price"));
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘：公司收入完成情况
	 */
	public ISrvMsg getCompanyIncomeRatioInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer(
				"select nvl(sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload))*19,0) w_price ");
		sql.append(" from rpt_gp_daily gd left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0' and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy')");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		Map map = jdbcDAO.queryRecordBySQL(sql.toString());
		String wlPrice = (String) map.get("w_price");
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");

		root.addAttribute("bgAlpha", "0");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("numberSuffix", "%25");
		root.addAttribute("chartTopMargin", "25");
		root.addAttribute("chartBottomMargin", "25");
		root.addAttribute("chartLeftMargin", "25");
		root.addAttribute("chartRightMargin", "25");
		root.addAttribute("toolTipBgColor", "80A905");
		root.addAttribute("gaugeFillMix", "{dark-10},FFFFFF,{dark-10}");
		root.addAttribute("gaugeFillRatio", "3");
		root.addAttribute("upperLimit", "100");
		root.addAttribute("baseFontSize ", "12");

		Element colorRange = root.addElement("colorRange");
		Element color1 = colorRange.addElement("color");
		color1.addAttribute("minValue", "0");
		color1.addAttribute("maxValue", "80");
		color1.addAttribute("code", "FF654F");
		Element color2 = colorRange.addElement("color");
		color2.addAttribute("minValue", "80");
		color2.addAttribute("maxValue", "100");
		color2.addAttribute("code", "8BBA00");

		Element dials = root.addElement("dials");
		Element dial = dials.addElement("dial");
		dial.addAttribute("value", String.valueOf(Double.parseDouble(wlPrice) / 3000 * 100));
		dial.addAttribute("rearExtension", "10");

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	

	/*
	 * 仪表盘:地震勘探项目深海浅海陆地对比
	 */
	public ISrvMsg getCompanyCompareSeaInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("select sum(decode(to_char(gd.send_date, 'yyyy'),to_char(sysdate, 'yyyy'), ");
		sql.append(" decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload), ");
		sql.append(" 0))*19 new_price, ");
		sql.append(" sum(decode(to_char(gd.send_date, 'yyyy'),to_char(add_months(sysdate, -12), 'yyyy'), ");
		sql.append(" decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload), ");
		sql.append(" 0))*19 old_price, ");
		sql.append("  decode(gp.project_type, '5000100004000000006', '深海', '5000100004000000002','浅海','陆地') w_label ");
		sql.append(" from rpt_gp_daily gd ");
		sql.append(" left outer join comm_coding_sort_detail sd on gd.market_classify = sd.coding_code_id ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0' and (to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') or ");
		sql.append(" to_char(gd.send_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) ");
		sql.append(" group by gp.project_type ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("yAxisName ", "采集直接费用(万元)");
		root.addAttribute("baseFontSize ", "12");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "去年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "今年");
		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("w_label"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("old_price"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("new_price"));
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:地震勘探项目深海浅海陆地对比
	 */
	public ISrvMsg getCompanyCompareTwoThreeInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("select sum(decode(to_char(gd.send_date, 'yyyy'),to_char(sysdate, 'yyyy'), ");
		sql.append(" decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload), ");
		sql.append(" 0))*19 new_price, ");
		sql.append(" sum(decode(to_char(gd.send_date, 'yyyy'),to_char(add_months(sysdate, -12), 'yyyy'), ");
		sql.append(" decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload), ");
		sql.append(" 0))*19 old_price, ");
		sql.append("  decode(gp.exploration_method, '0300100012000000003', '三维', '二维') w_label ");
		sql.append(" from rpt_gp_daily gd ");
		sql.append(" left outer join comm_coding_sort_detail sd on gd.market_classify = sd.coding_code_id ");
		sql.append(" left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0' and (to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') or ");
		sql.append(" to_char(gd.send_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) ");
		sql.append(" group by gp.exploration_method ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("yAxisName ", "采集直接费用(万元)");
		root.addAttribute("baseFontSize ", "12");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "去年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "今年");
		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("w_label"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("old_price"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("new_price"));
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:公司二三维支出对比饼图
	 */
	public ISrvMsg getCompanyOutcomeCompareTwoTreePieInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("select to_char(sum(pd.cost_detail_money)/10000,'99999999999999.00') w_price, ");
		sql.append(" decode(gp.exploration_method, '0300100012000000003', '三维', '0300100012000000002', '二维') w_label ");
		sql.append(" from bgp_op_actual_project_detail pd ");
		sql.append(" inner join bgp_op_target_project_info pi on pd.gp_target_project_id = pi.gp_target_project_id and pi.bsflag = '0' and pd.bsflag = '0' ");
		sql.append(" inner join gp_task_project gp on pi.project_info_no = gp.project_info_no ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pd.bsflag = '0' group by gp.exploration_method ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showPercentValues", "0");
		root.addAttribute("pieYScale", "50");
		root.addAttribute("startingAngle", "175");
		root.addAttribute("baseFontSize ", "12");

		for (Map map : list) {
			Element dataset1 = root.addElement("set");
			dataset1.addAttribute("label", (String) map.get("w_label"));
			dataset1.addAttribute("value", (String) map.get("w_price"));
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:公司深海浅海陆地支出对比饼图
	 */
	public ISrvMsg getCompanyOutcomeCompareSeaPieInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("select to_char(sum(pd.cost_detail_money)/10000,'99999999999999.00') w_price, ");
		sql.append(" decode(gp.project_type, '5000100004000000006', '深海', '5000100004000000002','浅海','陆地') w_label ");
		sql.append(" from bgp_op_actual_project_detail pd ");
		sql.append(" inner join bgp_op_target_project_info pi on pd.gp_target_project_id = pi.gp_target_project_id and pi.bsflag = '0' and pd.bsflag = '0' ");
		sql.append(" inner join gp_task_project gp on pi.project_info_no = gp.project_info_no ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pd.bsflag = '0'  group by gp.project_type ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showPercentValues", "0");
		root.addAttribute("pieYScale", "50");
		root.addAttribute("startingAngle", "175");
		root.addAttribute("baseFontSize ", "12");

		for (Map map : list) {
			Element dataset1 = root.addElement("set");
			dataset1.addAttribute("label", (String) map.get("w_label"));
			dataset1.addAttribute("value", (String) map.get("w_price"));
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	

	/*
	 * 仪表盘：物探处收入完成情况
	 */
	public ISrvMsg getSectionIncomeRatioInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		StringBuffer sql = new StringBuffer(
				"select nvl(sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload))*19,0) w_price ");
		sql.append(" from rpt_gp_daily gd left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0' and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') and gd.org_subjection_id like '" + orgId + "%'");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		Map map = jdbcDAO.queryRecordBySQL(sql.toString());
		String wlPrice = (String) map.get("w_price");
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");

		root.addAttribute("bgAlpha", "0");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("numberSuffix", "%25");
		root.addAttribute("chartTopMargin", "25");
		root.addAttribute("chartBottomMargin", "25");
		root.addAttribute("chartLeftMargin", "25");
		root.addAttribute("chartRightMargin", "25");
		root.addAttribute("toolTipBgColor", "80A905");
		root.addAttribute("gaugeFillMix", "{dark-10},FFFFFF,{dark-10}");
		root.addAttribute("gaugeFillRatio", "3");
		root.addAttribute("upperLimit", "100");
		root.addAttribute("baseFontSize ", "12");

		Element colorRange = root.addElement("colorRange");
		Element color1 = colorRange.addElement("color");
		color1.addAttribute("minValue", "0");
		color1.addAttribute("maxValue", "80");
		color1.addAttribute("code", "FF654F");
		Element color2 = colorRange.addElement("color");
		color2.addAttribute("minValue", "80");
		color2.addAttribute("maxValue", "100");
		color2.addAttribute("code", "8BBA00");

		Element dials = root.addElement("dials");
		Element dial = dials.addElement("dial");
		dial.addAttribute("value", String.valueOf(Double.parseDouble(wlPrice) / 3000 * 100));
		dial.addAttribute("rearExtension", "10");

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 物探处周收入同比分析
	 */
	public ISrvMsg getSectionIncomeWeekInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		StringBuffer sql = new StringBuffer("WITH temp_weeks as (select next_day(add_months(sysdate, -2), '星期一') + rownum * 7 cdate, ");
		sql.append(" to_char(next_day(add_months(sysdate, -2), '星期一') + rownum * 7, 'WW') weeks from dual  connect by rownum < 16) ");
		sql.append(" select rq.weeks, nvl(wz.w_price,0) now_price, nvl(wl.w_price,0) old_price from temp_weeks rq ");
		sql.append(" left outer join (select sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002', ");
		sql.append("                          gd.finish_2d_workload) * 19) w_price, to_char(gd.send_date, 'WW') m_month ");
		sql.append("         from rpt_gp_daily gd ");
		sql.append("         left outer join gp_task_project gp  on gd.project_info_no = gp.project_info_no ");
		sql.append("        where gd.bsflag = '0' and to_char(GD.SEND_DATE, 'yyyy') = to_char(sysdate, 'yyyy') ");
		sql.append("        group by to_char(gd.send_date, 'WW')) wl on RQ.weeks = wl.m_month ");
		sql.append(" left outer join (select sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002', ");
		sql.append("                       gd.finish_2d_workload) * 19) w_price, to_char(gd.send_date, 'WW') m_month ");
		sql.append("      from rpt_gp_daily gd ");
		sql.append("       left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append("      where gd.bsflag = '0' and to_char(GD.SEND_DATE, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy') ");
		sql.append("      and gd.org_subjection_id like '" + orgId + "%' ");
		sql.append("      group by to_char(gd.send_date, 'WW')) wz on RQ.weeks = wz.m_month ");
		sql.append(" order by weeks ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");

		root.addAttribute("xAxisName", "周");
		root.addAttribute("yAxisName ", "收入（万元）");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "今年度收入");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "去年收入");
		for (Map map : list) {
			Element categoriesTemp = categories.addElement("category");
			categoriesTemp.addAttribute("label", (String) map.get("weeks"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("now_price"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("old_price"));
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:物探处二三维收入对比饼图
	 */
	public ISrvMsg getSectionIncomeTwoTreePieInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		StringBuffer sql = new StringBuffer(
				"select sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload))*19 w_price, ");
		sql.append(" decode(gp.exploration_method, '0300100012000000003', '三维', '0300100012000000002', '二维') w_label ");
		sql.append(" from rpt_gp_daily gd left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" where gd.bsflag = '0' and gd.org_subjection_id like '" + orgId + "%'"
				+ "and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') group by gp.exploration_method ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize ", "12");

		for (Map map : list) {
			Element dataset1 = root.addElement("set");
			dataset1.addAttribute("label", (String) map.get("w_label"));
			dataset1.addAttribute("value", (String) map.get("w_price"));
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:物探处二三维支出对比饼图
	 */
	public ISrvMsg getSectionOutcomeTwoTreePieInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		StringBuffer sql = new StringBuffer("with org_name_sub as ");
		sql.append(" (select oi.org_abbreviation, os.org_subjection_id from comm_org_information oi ");
		sql.append(" inner join comm_org_subjection os on oi.org_id = os.org_id and os.bsflag = '0' ");
		sql.append(" where oi.org_level = '0200100005000000004' and oi.org_type = '0200100004000000015' and oi.edition_nameplate != '1' and oi.bsflag = '0') ");
		sql.append(" select to_char(sum(pd.cost_detail_money) / 10000, '99999999999999.00') w_price, ");
		sql.append(" decode(gp.exploration_method, '0300100012000000003', '三维', '0300100012000000002', '二维') w_label ");
		sql.append(" from bgp_op_actual_project_detail pd ");
		sql.append(" inner join bgp_op_target_project_info pi on pd.gp_target_project_id = pi.gp_target_project_id and pi.bsflag = '0' and pd.bsflag = '0' ");
		sql.append(" inner join gp_task_project gp on pi.project_info_no = gp.project_info_no ");
		sql.append(" inner join (select distinct m.org_abbreviation, t.project_info_no, m.org_subjection_id ");
		sql.append(" from gp_task_project_dynamic t inner join org_name_sub m on t.org_subjection_id like m.org_subjection_id || '%' ");
		sql.append(" and t.bsflag = '0') gd on pi.project_info_no = gd.project_info_no and gd.org_subjection_id like '" + orgId + "%' ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pd.bsflag = '0' group by gp.exploration_method ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showPercentValues", "0");
		root.addAttribute("pieYScale", "50");
		root.addAttribute("startingAngle", "175");
		root.addAttribute("baseFontSize ", "12");

		for (Map map : list) {
			Element dataset1 = root.addElement("set");
			dataset1.addAttribute("label", (String) map.get("w_label"));
			dataset1.addAttribute("value", (String) map.get("w_price"));
		}

		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:物探处小队收入支出对比图
	 */
	public ISrvMsg getSectionCompareTeamInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		StringBuffer sql = new StringBuffer("  with project_team as ");
		sql.append(" (select distinct gp.project_info_no, gp.project_name, ot.team_id from gp_task_project gp ");
		sql.append(" left outer join gp_task_project_dynamic pd on gp.project_info_no = pd.project_info_no and gp.bsflag = '0' ");
		sql.append(" left outer join comm_org_team ot on pd.org_id = ot.org_id and ot.bsflag = '0'), ");
		sql.append(" org_name_sub as ");
		sql.append(" (select oi.org_abbreviation, os.org_subjection_id from comm_org_information oi ");
		sql.append(" inner join comm_org_subjection os  on oi.org_id = os.org_id and os.bsflag = '0' ");
		sql.append(" where oi.org_level = '0200100005000000004' and oi.org_type = '0200100004000000015' and oi.edition_nameplate != '1' and oi.bsflag = '0') ");
		sql.append(" select m.w_price outcome, n.w_price income, m.team_id ");
		sql.append(" from (select sum(pd.cost_detail_money)/10000 w_price, pt.team_id from bgp_op_actual_project_detail pd ");
		sql.append(" inner join bgp_op_target_project_info pi on pd.gp_target_project_id = pi.gp_target_project_id ");
		sql.append(" and pi.bsflag = '0' and pd.bsflag = '0' ");
		sql.append(" inner join gp_task_project gp  on pi.project_info_no = gp.project_info_no ");
		sql.append(" inner join (select distinct m.org_abbreviation, t.project_info_no, m.org_subjection_id ");
		sql.append(" from gp_task_project_dynamic t ");
		sql.append(" inner join org_name_sub m  on t.org_subjection_id like m.org_subjection_id || '%' and t.bsflag = '0') gd ");
		sql.append(" on pi.project_info_no = gd.project_info_no and gd.org_subjection_id like '" + orgId + "%' ");
		sql.append(" left outer join project_team pt on gp.project_info_no = pt.project_info_no ");
		sql.append(" where to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') and pd.bsflag = '0'  group by pt.team_id) m ");
		sql.append(" left outer join (select sum(decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload))*19 w_price,pt.team_id ");
		sql.append(" from rpt_gp_daily gd left outer join gp_task_project gp on gd.project_info_no = gp.project_info_no ");
		sql.append(" left outer join project_team pt on gd.project_info_no = pt.project_info_no ");
		sql.append(" where gd.bsflag = '0' and gd.org_subjection_id like '" + orgId + "%' and to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') ");
		sql.append(" group by pt.team_id) n on m.team_id = n.team_id ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("yAxisName ", "(万元)");
		root.addAttribute("baseFontSize ", "12");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "收入");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "支出");
		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("team_id"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("income"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("outcome"));
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	/*
	 * 仪表盘:物探处收支差异率对比图
	 */
	public ISrvMsg getSectionRatioTwoThreeInfo(ISrvMsg reqDTO) throws Exception {
		String orgId = reqDTO.getValue("orgId");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer("  with org_name_sub as (select oi.org_abbreviation, os.org_subjection_id ");
		sql.append(" from comm_org_information oi ");
		sql.append(" inner join comm_org_subjection os on oi.org_id = os.org_id and os.bsflag = '0' ");
		sql.append(" where oi.org_level = '0200100005000000004' and oi.org_type = '0200100004000000015' and oi.edition_nameplate != '1' and ");
		sql.append("  oi.bsflag = '0') ");
		sql.append(" select nvl(decode(nvl(n.new_price, 0), 0, 0, (n.new_price - m.new_price) / n.new_price) * 100,0) new_ration, ");
		sql.append(" decode(nvl(n.old_price, 0), 0, 0, (n.old_price - m.old_price) / n.old_price) * 100 old_ration, ");
		sql.append(" nvl(m.w_label,n.w_label)  w_label");
		sql.append(" from (select sum(decode(to_char(pd.occur_date, 'yyyy'), to_char(sysdate, 'yyyy'), pd.cost_detail_money, 0)) / 10000 new_price, ");
		sql.append(" sum(decode(to_char(pd.occur_date, 'yyyy'), ");
		sql.append("  to_char(add_months(sysdate, -12), 'yyyy'), ");
		sql.append("  pd.cost_detail_money, ");
		sql.append("  0)) / 10000 old_price, ");
		sql.append("  decode(gp.exploration_method, '0300100012000000003', '三维', '0300100012000000002', '二维') w_label ");
		sql.append("  from bgp_op_actual_project_detail pd ");
		sql.append("  inner join bgp_op_target_project_info pi ");
		sql.append("    on pd.gp_target_project_id = pi.gp_target_project_id and pi.bsflag = '0' and pd.bsflag = '0' ");
		sql.append(" inner join gp_task_project gp ");
		sql.append("    on pi.project_info_no = gp.project_info_no ");
		sql.append("  inner join (select distinct m.org_abbreviation, t.project_info_no, m.org_subjection_id ");
		sql.append("               from gp_task_project_dynamic t ");
		sql.append("              inner join org_name_sub m ");
		sql.append("                 on t.org_subjection_id like m.org_subjection_id || '%' and t.bsflag = '0') gd ");
		sql.append("     on pi.project_info_no = gd.project_info_no and gd.org_subjection_id like '" + orgId + "%' ");
		sql.append("   where (to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') or ");
		sql.append("         to_char(pd.occur_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) and pd.bsflag = '0' ");
		sql.append("   group by gp.exploration_method) m ");
		sql.append(" full  join (select sum(decode(to_char(gd.send_date, 'yyyy'),to_char(sysdate, 'yyyy'), ");
		sql.append("            decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload),0)) * 19 new_price, ");
		sql.append("              sum(decode(to_char(gd.send_date, 'yyyy'),to_char(add_months(sysdate, -12), 'yyyy'), ");
		sql.append("            decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload),0)) * 19 old_price, ");
		sql.append("             decode(gp.exploration_method, '0300100012000000003', '三维', '0300100012000000002', '二维') w_label ");
		sql.append("               from rpt_gp_daily gd ");
		sql.append("                left outer join gp_task_project gp ");
		sql.append("                  on gd.project_info_no = gp.project_info_no ");
		sql.append("              where gd.bsflag = '0' and gd.org_subjection_id like '" + orgId + "%' and ");
		sql.append("                    (to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') or ");
		sql.append("                   to_char(gd.send_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) ");
		sql.append("             group by gp.exploration_method) n on m.w_label = n.w_label ");
		sql.append(" union ");
		sql.append(" select decode(nvl(n.new_price, 0), 0, 0, (n.new_price - m.new_price) / n.new_price) * 0 new_ration, ");
		sql.append(" decode(nvl(n.old_price, 0), 0, 0, (n.old_price - m.old_price) / n.old_price) * 100 old_ration, ");
		sql.append(" '综合' w_label ");
		sql.append(" from (select sum(decode(to_char(pd.occur_date, 'yyyy'), to_char(sysdate, 'yyyy'), pd.cost_detail_money, 0)) / 10000 new_price, ");
		sql.append("    sum(decode(to_char(pd.occur_date, 'yyyy'), ");
		sql.append("                to_char(add_months(sysdate, -12), 'yyyy'), ");
		sql.append("               pd.cost_detail_money, ");
		sql.append("               0)) / 10000 old_price ");
		sql.append("  from bgp_op_actual_project_detail pd ");
		sql.append(" inner join bgp_op_target_project_info pi ");
		sql.append("    on pd.gp_target_project_id = pi.gp_target_project_id and pi.bsflag = '0' and pd.bsflag = '0' ");
		sql.append(" inner join gp_task_project gp ");
		sql.append("    on pi.project_info_no = gp.project_info_no ");
		sql.append(" inner join (select distinct m.org_abbreviation, t.project_info_no, m.org_subjection_id ");
		sql.append("    from gp_task_project_dynamic t ");
		sql.append("             inner join org_name_sub m ");
		sql.append("                on t.org_subjection_id like m.org_subjection_id || '%' and t.bsflag = '0') gd ");
		sql.append("   on pi.project_info_no = gd.project_info_no and gd.org_subjection_id like '" + orgId + "%' ");
		sql.append(" where (to_char(pd.occur_date, 'yyyy') = to_char(sysdate, 'yyyy') or ");
		sql.append("       to_char(pd.occur_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) and pd.bsflag = '0' ");
		sql.append(" ) m ");
		sql.append(" left outer join (select sum(decode(to_char(gd.send_date, 'yyyy'),to_char(sysdate, 'yyyy'), ");
		sql.append("         decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload),0)) * 19 new_price, ");
		sql.append("           sum(decode(to_char(gd.send_date, 'yyyy'),to_char(add_months(sysdate, -12), 'yyyy'), ");
		sql.append("     decode(gp.EXPLORATION_METHOD,'0300100012000000003',gd.finish_3d_workload,'0300100012000000002',gd.finish_2d_workload),0)) * 19 old_price ");
		sql.append("        from rpt_gp_daily gd ");
		sql.append("        left outer join gp_task_project gp ");
		sql.append("          on gd.project_info_no = gp.project_info_no ");
		sql.append("       where gd.bsflag = '0' and gd.org_subjection_id like '" + orgId + "%' and ");
		sql.append("             (to_char(gd.send_date, 'yyyy') = to_char(sysdate, 'yyyy') or ");
		sql.append("             to_char(gd.send_date, 'yyyy') = to_char(add_months(sysdate, -12), 'yyyy')) ");
		sql.append("       ) n on 1=1 ");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		List<Map> list = jdbcDAO.queryRecords(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showValues", "0");
		root.addAttribute("baseFontSize ", "12");

		Element categories = root.addElement("categories");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "去年");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "今年");
		for (Map map : list) {
			Element category1 = categories.addElement("category");
			category1.addAttribute("label", (String) map.get("w_label"));
			Element set1 = dataset1.addElement("set");
			set1.addAttribute("value", (String) map.get("old_ration"));
			Element set2 = dataset2.addElement("set");
			set2.addAttribute("value", (String) map.get("new_ration"));
		}
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}

	
	/*
	 * 井中项目
	 */
	public ISrvMsg getjzMoney(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sql = new StringBuffer();
		String year = reqDTO.getValue("year");
		String org_name = reqDTO.getValue("org_name");
		sql.append("select sum(tt.PROJECT_INCOME) as PROJECT_INCOME,sum(tt.CONTRACTS_SIGNED_CHANGE) as CONTRACTS_SIGNED_CHANGE,sum(tt.COMPLETE_VALUE_CHANGE) as COMPLETE_VALUE_CHANGE   from (	");
		sql.append("select t1.PROJECT_INFO_NO,t1.ORG_NAME,t1.PROJECT_INCOME,re3.CONTRACTS_SIGNED_CHANGE,re3.COMPLETE_VALUE_CHANGE,p.project_year  	");
		sql.append("from 	");
		sql.append("( SELECT DAILY_ID,PROJECT_INFO_NO,ORG_NAME,project_income FROM BGP_WS_DAILY_REPORT WHERE BSFLAG='0' and DAILY_ID IN (SELECT MAX(DAILY_ID) FROM BGP_WS_DAILY_REPORT rt left join COMMON_BUSI_WF_MIDDLE wf on rt.PROJECT_INFO_NO=wf.BUSINESS_ID and wf.BSFLAG='0'WHERE rt.BSFLAG='0' AND wf.PROC_STATUS='3' and wf.busi_table_name='bgp_ws_daily_report' GROUP BY rt.PROJECT_INFO_NO) 	");
		sql.append(") t1 left join gp_task_project p on p.PROJECT_INFO_NO=t1.PROJECT_INFO_NO and p.BSFLAG='0' left join	");
		sql.append("( select re.CREATE_DATE ,re.PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.YEAR   from BGP_OP_MONEY_CONFIRM_RECORD_WS re right join 	");
		sql.append("(select max(rr.CREATE_DATE) as CREATE_DATE,rr.PROJECT_INFO_ID,rr.YEAR from BGP_OP_MONEY_CONFIRM_RECORD_WS rr left join COMMON_BUSI_WF_MIDDLE wf on rr.RECORD_ID=wf.BUSINESS_ID and wf.BSFLAG='0' where wf.PROC_STATUS='3'and rr.BSFLAG='0' group by rr.PROJECT_INFO_ID,rr.YEAR) tt on tt.CREATE_DATE=re.CREATE_DATE where re.BSFLAG='0') re3 on re3.PROJECT_INFO_ID=t1.PROJECT_INFO_NO and re3.year=p.project_year 	");
		sql.append("where p.PROJECT_YEAR is not null	");
		sql.append("union 	");
		sql.append("select cr.PROJECT_INFO_NO,da.ORG_NAME,da.PROJECT_INCOME,decode(cr.wf1.CONTRACTS_SIGNED_CHANGE,'',cr.CONTRACTS_SIGNED_CARRYOVER,cr.wf1.CONTRACTS_SIGNED_CHANGE) as CONTRACTS_SIGNED_CHANGE,decode(wf1.COMPLETE_VALUE_CHANGE,'',cr.COMPLETE_VALUE_CARRYOVER,wf1.COMPLETE_VALUE_CHANGE) as COMPLETE_VALUE_CHANGE,cr.year as project_year 	");
		sql.append("from BGP_OP_PROJECT_MONEY_CARRYOVER cr  	");
		sql.append("left join BGP_OP_MONEY_CONFIRM_RECORD_WS re on cr.PROJECT_INFO_NO=re.PROJECT_INFO_ID and cr.YEAR=re.year and re.BSFLAG='0' 	");
		sql.append("left join( select re.CREATE_DATE ,re.PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.year  from BGP_OP_MONEY_CONFIRM_RECORD_WS re  where re.CREATE_DATE in  (select max(rr.CREATE_DATE) from BGP_OP_MONEY_CONFIRM_RECORD_WS rr left join COMMON_BUSI_WF_MIDDLE wf on rr.RECORD_ID=wf.BUSINESS_ID and wf.BSFLAG='0' where wf.PROC_STATUS='3' group by rr.PROJECT_INFO_ID,rr.year) group by PROJECT_INFO_ID,re.CONTRACTS_SIGNED_CHANGE,re.COMPLETE_VALUE_CHANGE,re.CREATE_DATE,re.year )  wf1 on wf1.PROJECT_INFO_ID=cr.PROJECT_INFO_NO and wf1.year=cr.YEAR 	"); 
		sql.append("left join BGP_WS_DAILY_REPORT da on da.PROJECT_INFO_NO=cr.PROJECT_INFO_NO and da.BSFLAG='0' where cr.BSFLAG='0'	");
		sql.append("	) tt where 1=1 	");
		if(year!=null&&!"".equals(year)){
			sql.append(" and tt.project_year='"+year+"'");
		}
		if(org_name!=null&&!"".equals(org_name)){
			sql.append(" and tt.org_name='"+org_name+"队'");			
		}
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		Map map = jdbcDAO.queryRecordBySQL(sql.toString());

		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showLegend", "1");
		root.addAttribute("showValues", "1");
		root.addAttribute("numberPrefix", "￥");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("showPercentValues", "0");
		root.addAttribute("startingAngle", "175");
		root.addAttribute("baseFontSize ", "12");
		root.addAttribute("chartTopMargin ", "12");
		root.addAttribute("captionPadding ", "1");
		root.addAttribute("pieRadius", "150");

		Element categories = root.addElement("categories");

		Element dataset = root.addElement("dataset");
		dataset.addAttribute("seriesName", "已签到合同额（万元）");
		Element dataset1 = root.addElement("dataset");
		dataset1.addAttribute("seriesName", "预计完成价值工作量（万元）");
		Element dataset2 = root.addElement("dataset");
		dataset2.addAttribute("seriesName", "完成价值工作量（万元）");
		
		Element category1 = categories.addElement("category");
		//category1.addAttribute("label", "");		
	

		
		Element set = dataset.addElement("set");
		set.addAttribute("value", (String) map.get("contracts_signed_change")==null?"0": (String) map.get("contracts_signed_change"));	
		
		Element set1 = dataset1.addElement("set");
		set1.addAttribute("value", (String) map.get("project_income")==null?"0": (String) map.get("project_income"));	
		
		Element set2 = dataset2.addElement("set");
		set2.addAttribute("value",(String) map.get("complete_value_change")==null?"0": (String) map.get("complete_value_change") );			

		
		responseDTO.setValue("Str", document.asXML());

		return responseDTO;
	}
	// =====================================〉〉结束

	/*
	 * toGenerateVersionData
	 */
	public ISrvMsg toGenerateVersionData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");// "8ad8788529ef02230129f2e53deb01ac";
		if (projectInfoNo != null && !"".equals(projectInfoNo) && !"null".equals(projectInfoNo)) {
			String verNumber = OPCommonUtil.getNumberOfTargetVersion(projectInfoNo);
			String sqlDelete = "delete from  bgp_op_target_gather_info  where project_info_no='" + projectInfoNo + "' and create_date=sysdate";
			jdbcTemplate.execute(sqlDelete);
			String sqlInsert = "insert into bgp_op_target_gather_info (gp_target_gather_id,gather_version,template_id,tartget_basic_id,spare3,project_info_no,node_code,cost_name,order_code,parent_id,"
					+ "formula_type,formula_content,cost_detail_money,create_date,bsflag) "
					+ "(select   SYS_GUID () AS key_id,'"
					+ verNumber
					+ "',TEMPLATE_ID,tartget_basic_id,gp_target_project_id,'"
					+ projectInfoNo
					+ "',node_code,cost_name,order_code,parent_id,formula_type,formula_content,cost_detail_money,sysdate,"
					+ "'0' from view_op_target_plan_money_f where  project_info_no = '" + projectInfoNo + "')";
			jdbcTemplate.execute(sqlInsert);
			String sqlUpdate = "update bgp_op_target_gather_info t set t.parent_id =(select p.gp_target_gather_id from bgp_op_target_gather_info p where p.spare3=t.parent_id and p.project_info_no=t.project_info_no and p.gather_version='"
					+ verNumber + "'  ) where project_info_no = '" + projectInfoNo + "' and gather_version='" + verNumber + "'";
			jdbcTemplate.execute(sqlUpdate);
			sqlUpdate = "update bgp_op_target_gather_info t set t.parent_id='01' where parent_id is null and   project_info_no = '" + projectInfoNo + "' and gather_version='"
					+ verNumber + "'";
			jdbcTemplate.execute(sqlUpdate);
		}
		return responseDTO;
	}

	/*
	 * 获取目标成本某版本成本树
	 */
	public ISrvMsg getCostTargetVersionDetail(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String versionId = reqDTO.getValue("versionId");
		String ifcheck = reqDTO.getValue("ifcheck");
		StringBuffer sqlBuffer = new StringBuffer("select connect_by_root(t.gp_target_gather_id) root,level,decode(connect_by_isleaf, 0, 'false', 1, 'true') leaf, ");
		sqlBuffer.append(" sys_connect_by_path(substr(node_code,0,length(node_code)-3)||lpad(order_code+1,3,'0'), '/') path ");
		sqlBuffer.append(" ,cost_name,cost_desc,t.gp_target_gather_id gp_cost_temp_id,parent_id, ");
		sqlBuffer.append(" parent_id zip,order_code,cost_detail_money,cost_detail_desc  from bgp_op_target_gather_info t ");
		sqlBuffer.append(" where t.project_info_no = '" + projectInfoNo + "' and t.gather_version = '" + versionId + "' ");
		sqlBuffer.append(" start with t.parent_id = '01' connect by prior t.gp_target_gather_id = t.parent_id order by path asc");

		List<Map> list = jdbcDao.queryRecords(sqlBuffer.toString());

		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", list != null ? list.size() : 0);

		responseDTO.setValue("pageCount", "1");
		responseDTO.setValue("pageSize", "0");
		responseDTO.setValue("currentPage", "1");

		// 获取项目名称

		String projectName = OPCommonUtil.getProjectNameByProjectInfoNo(projectInfoNo);
		Map map = new HashMap();
		map.put("gpCostTempId", "01");
		map.put("parentId", "root");
		map.put("costName", projectName);
		map.put("costDesc", "");
		map.put("expanded", "true");

		Map jsonMap = new HashMap();
		if ("true".equals(ifcheck)) {
			jsonMap = OPCommonUtil.convertListTreeToJsonCheck(list, "gpCostTempId", "parentId", map);
		} else {
			jsonMap = OPCommonUtil.convertListTreeToJson(list, "gpCostTempId", "parentId", map);
		}

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		responseDTO.setValue("basicId", OPCommonUtil.getTargetProjectBasicId(projectInfoNo));
		return responseDTO;
	}

	/*
	 * 项目健康度
	 */
	public ISrvMsg getSingleProjectHealthInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		OPCommonUtil.saveProjectHealthInfo(projectInfoNo);
		return responseDTO;
	}

	/*
	 * 获取单机消耗情况
	 */
	public ISrvMsg getSingleDeviceOutInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		StringBuilder sb = new StringBuilder("select sd.coding_name team_name, dui.dev_name,dui.dev_model,dui.dev_sign ,dui.dev_acc_id , ");
		sb.append(" sum(case when mi.coding_code_id like '55%' or mi.coding_code_id like '56%' then d.total_money else  0 end) qc_money, ");
		sb.append(" sum(case when mi.coding_code_id like '48%' then d.total_money else  0 end) zj_money, ");
		sb.append(" sum(case when oi.oil_name ='0110000043000000001' then oi.oil_quantity * oi.oil_unit_price else 0 end) qy_money, ");
		sb.append(" sum(case when oi.oil_name ='0110000043000000002' then oi.oil_quantity * oi.oil_unit_price else 0 end) cy_money, ");
		sb.append(" sum(case when oi.oil_name !='0110000043000000002' and oi.oil_name !='0110000043000000001'  then oi.oil_quantity * oi.oil_unit_price else 0 end) x_money ");
		sb.append(" from  gms_device_account_dui dui ");
		sb.append(" left outer join  bgp_comm_device_oil_info oi on dui.dev_acc_id = oi.device_account_id ");
		sb.append(" left outer  join gms_mat_teammat_out o on o.dev_acc_id = dui.dev_acc_id ");
		sb.append(" left outer  join gms_mat_teammat_out_detail d  on d.teammat_out_id = o.teammat_out_id and d.bsflag = '0' and o.bsflag = '0' ");
		sb.append(" left outer join GMS_MAT_INFOMATION mi on d.wz_id = mi.wz_id and mi.bsflag = '0'  ");
		sb.append(" left outer join comm_coding_sort_detail sd on dui.dev_team = sd.coding_code_id ");
		sb.append(" where dui.project_info_id = '" + projectInfoNo + "' ");
		sb.append(" group by sd.coding_name, dui.dev_name,dui.dev_model,dui.dev_sign,dui.dev_acc_id ");
		OPCommonUtil.saveProjectHealthInfo(projectInfoNo);
		return responseDTO;
	}

	/*
	 * 获取项目健康状况信息
	 */
	public ISrvMsg queryProjectHealthInfo(ISrvMsg reqDTO) throws Exception {

		String org_subjection_id = (String) reqDTO.getValue("orgSubjectionId");
		String project_name = (String) reqDTO.getValue("projectName");
		String[] projectNames = project_name.split("");// 分解成单字符
		project_name = "%";

		for (int i = 0; i < projectNames.length; i++) {
			project_name += projectNames[i] + "%";
		}
		String org_name = (String) reqDTO.getValue("orgName");
		String[] orgNames = org_name.split("");
		org_name = "%";
		for (int i = 0; i < orgNames.length; i++) {
			org_name += orgNames[i] + "%";
		}

		String project_status = (String) reqDTO.getValue("projectStatus");
		String project_type = (String) reqDTO.getValue("projectType");

		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		StringBuffer sql = new StringBuffer(" select hi.project_info_no,hi.pm_info,hi.qm_info,hi.hse_info,hi.heath_info_id, ");
		sql.append(" gp.project_name,gp.project_status,oi.org_abbreviation,sd.coding_name project_status_name ");
		sql.append(" from BGP_PM_PROJECT_HEATH_INFO hi  ");
		sql.append(" inner join gp_task_project gp  on gp.project_info_no = hi.project_info_no and gp.project_name like '" + project_name + "%' and gp.bsflag = '0' and ");
		sql.append(" gp.project_status like '%" + project_status + "%' and project_type like '%" + project_type + "%' ");
		sql.append(" inner join gp_task_project_dynamic pd on gp.project_info_no = pd.project_info_no and pd.bsflag = '0' ");
		sql.append(" inner join comm_org_information oi on oi.org_id = pd.org_id and oi.org_name like '" + org_name + "%' and oi.bsflag = '0' ");
		sql.append(" inner join comm_coding_sort_detail sd on sd.coding_code_id =gp.project_status ");
		sql.append(" where pd.org_subjection_id like '%" + org_subjection_id + "%' ");

		page = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).queryRecordsBySQL(sql.toString(), page);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);

		return msg;

	}

	/**
	 * 发放物资表单详细信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findGrantList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String devAccId = reqDTO.getValue("devAccId");
		String sql = "select * from gms_mat_teammat_out_detail t inner join  gms_mat_teammat_out p on t.teammat_out_id=p.teammat_out_id and p.dev_acc_id='" + devAccId
				+ "'  inner join gms_mat_infomation i on t.wz_id=i.wz_id and i.bsflag='0' and t.project_info_no='" + projectInfoNo + "'"
				+ " and (i.coding_code_id like '48%' or i.coding_code_id like '55%' or i.coding_code_id like '56%')";
		List list = pureDao.queryRecords(sql);
		reqMsg.setValue("matInfo", list);
		return reqMsg;
	}

	/*
	 * 导出一体化论证费用信息
	 */
	public ISrvMsg exportCostVersionInfo(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		String costProjectSchemaId=reqDTO.getValue("costProjectSchemaId");
		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../op/common/costTemplateTree.xls"));
		Sheet sheet = wb.getSheetAt(0);
		StringBuffer sb=new StringBuffer("select t.*,to_char(t.cost_detail_money/10000,'9999999999.00') cost_money, sys_connect_by_path(substr(node_code, 0, length(node_code) - 3) || lpad(order_code + 1, 3, '0'), '/') path from view_op_cost_plan_money_f t ");
		sb.append(" where cost_project_schema_id = '"+costProjectSchemaId+"' start with parent_id = '01' connect by prior gp_cost_project_id = parent_id order by path asc ");
		List<Map> list=pureDao.queryRecords(sb.toString());
		int row=13,col=2;
		for(Map map:list){
			String costDetailMoney=(String) map.get("cost_money");
			costDetailMoney=costDetailMoney==null?"0":costDetailMoney;
			sheet.getRow(row++).getCell(col).setCellValue(costDetailMoney.trim());
		}
		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename("费用科目.xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;
	}
	/*
	 * 导出设备信息
	 */
	public ISrvMsg exportDeviceInfoForCost(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../op/common/deviceExport.xls"));
		Sheet sheet = wb.getSheetAt(0);
		int rows = sheet.getPhysicalNumberOfRows();
		String[] colName = { "dev_acc_id","row_num","dev_name", "team_name","device_count", "dev_model", "self_num", "license_num","plan_start_date","plan_end_date","date_num","asset_value",
		"depreciation_value","daily_oil_type","daily_oil","daily_small_oil","single_well_oil","oil_unit_price","vehicle_daily_material","drilling_daily_material","restore_repails" };
		StringBuilder sb = new StringBuilder();
		sb.append("select td.dev_acc_id ,rownum row_num ,sd.coding_name team_name,td.dev_name dev_name ,td.dev_model dev_model,td.self_num ,td.license_num ,")
		.append(" td.plan_start_date,td.plan_end_date ,nvl(td.plan_end_date-td.plan_start_date-(-1),0) date_num,td.oil_unit_price ,td.device_count,")
		.append(" decode(td.daily_oil_type,'2','柴油','1','汽油','') daily_oil_type ,td.daily_oil ,td.daily_small_oil ,td.single_well_oil, ")
		.append(" dd.asset_value ,dd.depreciation_value,dm.vehicle_daily_material,dm.drilling_daily_material,dm.restore_repails ")
		.append(" from bgp_op_tartet_device_oil td ")//left outer join gms_device_account_dui da on td.dev_acc_id = da.dev_acc_id 
		.append(" left join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id ")
		.append(" left join bgp_op_tartet_device_depre dd on td.dev_acc_id = dd.dev_acc_id and dd.bsflag ='0' and dd.record_type ='0'")
		.append(" left join bgp_op_tartet_device_material dm on td.dev_acc_id = dm.dev_acc_id and dm.bsflag ='0'")
	    .append(" where td.bsflag='0' and  td.project_info_no = '").append(projectInfoNo).append("' and td.if_change ='0'"); //t.dev_type not like 'S11%'
		List<Map> list = pureDao.queryRecords(sb.toString());
		for (Map map : list) {
			Row row = sheet.createRow(rows++);
			int col = 0;
			for (String s : colName) {
				Cell cell = row.createCell(col++);
				cell.setCellValue((String) map.get(s));
			}
		}

		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename("油料费、小油品费.xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;

	}
	
	public ISrvMsg exportDeviceInfoForCostRc(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../op/common/deviceExport.xls"));
		Sheet sheet = wb.getSheetAt(0);
		int rows = sheet.getPhysicalNumberOfRows();
		String[] colName = { "dev_acc_id","row_num","dev_name", "team_name","device_count", "dev_model", "self_num", "license_num","plan_start_date","plan_end_date","date_num","asset_value",
		"depreciation_value","daily_oil_type","daily_oil","daily_small_oil","single_well_oil","oil_unit_price","vehicle_daily_material","drilling_daily_material","restore_repails" };
		StringBuilder sb = new StringBuilder();
		sb.append("select td.dev_acc_id ,rownum row_num ,sd.coding_name team_name,td.dev_name dev_name ,td.dev_model dev_model ,td.self_num ,td.license_num ,td.device_count,")
		.append(" td.plan_start_date,td.plan_end_date ,nvl(td.plan_end_date-td.plan_start_date-(-1),0) date_num,td.asset_value ,td.depreciation_value,")
		.append(" decode(do.daily_oil_type,'2','柴油','1','汽油','') daily_oil_type,do.daily_oil ,do.daily_small_oil,do.single_well_oil,do.oil_unit_price,")
		.append(" dm.vehicle_daily_material,dm.drilling_daily_material,dm.restore_repails from bgp_op_tartet_device_depre td ")//left outer join gms_device_account_dui da on td.dev_acc_id = da.dev_acc_id 
		.append(" left join comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id ")
		.append(" left join bgp_op_tartet_device_oil do on td.dev_acc_id = do.dev_acc_id and do.bsflag ='0' ")
		.append(" left join bgp_op_tartet_device_material dm on td.dev_acc_id = dm.dev_acc_id and dm.bsflag ='0'")
	    .append(" where td.bsflag='0' and  td.project_info_no = '").append(projectInfoNo).append("' and td.record_type ='0' and td.if_change ='0'"); //t.dev_type not like 'S11%'
		List<Map> list = pureDao.queryRecords(sb.toString());
		for (Map map : list) {
			Row row = sheet.createRow(rows++);
			int col = 0;
			for (String s : colName) {
				Cell cell = row.createCell(col++);
				cell.setCellValue((String) map.get(s));
			}
		}

		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename("设备折旧费.xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;

	}
	
	public ISrvMsg exportDeviceInfoForCostRp(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../op/common/deviceExport.xls"));
		Sheet sheet = wb.getSheetAt(0);
		int rows = sheet.getPhysicalNumberOfRows();
		String[] colName = { "dev_acc_id","row_num","dev_name", "team_name","device_count", "dev_model", "self_num", "license_num","plan_start_date","plan_end_date","date_num","asset_value",
		"depreciation_value","daily_oil_type","daily_oil","daily_small_oil","single_well_oil","oil_unit_price","vehicle_daily_material","drilling_daily_material","restore_repails" };
		StringBuilder sb = new StringBuilder();
		sb.append("select td.dev_acc_id ,rownum row_num ,sd.coding_name team_name,td.dev_name dev_name ,td.dev_model dev_model ,td.self_num ,td.license_num ,td.device_count,")
		.append(" td.plan_start_date,td.plan_end_date,nvl(td.plan_end_date-td.plan_start_date-(-1),0) date_num,td.vehicle_daily_material ,td.restore_repails,  ")
		.append(" decode(do.daily_oil_type,'2','柴油','1','汽油','') daily_oil_type,do.daily_oil ,do.daily_small_oil,do.single_well_oil,do.oil_unit_price,")
		.append(" dd.asset_value ,dd.depreciation_value,td.drilling_daily_material from bgp_op_tartet_device_material td ")
		.append(" left outer join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id ")
		.append(" left join bgp_op_tartet_device_depre dd on td.dev_acc_id = dd.dev_acc_id and dd.bsflag ='0' and dd.record_type ='0' ")
		.append(" left join bgp_op_tartet_device_oil do on td.dev_acc_id = do.dev_acc_id and do.bsflag ='0' ")
	    .append(" where td.bsflag='0' and  td.project_info_no = '").append(projectInfoNo).append("' and td.if_change ='0'"); //t.dev_type not like 'S11%'
		List<Map> list = pureDao.queryRecords(sb.toString());
		for (Map map : list) {
			Row row = sheet.createRow(rows++);
			int col = 0;
			for (String s : colName) {
				Cell cell = row.createCell(col++);
				cell.setCellValue((String) map.get(s));
			}
		}

		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename("设备材料费、恢复修理费.xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;

	}
	
	public ISrvMsg exportDeviceInfoForRent(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../op/common/deviceExport.xls"));
		Sheet sheet = wb.getSheetAt(0);
		int rows = sheet.getPhysicalNumberOfRows();
		String[] colName = { "dev_acc_id","row_num","dev_name", "team_name","device_count", "dev_model", "self_num", "license_num","plan_start_date","plan_end_date","date_num","asset_value",
		"depreciation_value","daily_oil_type","daily_oil","daily_small_oil","single_well_oil","oil_unit_price","vehicle_daily_material","drilling_daily_material","restore_repails" };
		StringBuilder sb = new StringBuilder();
		sb.append("select td.dev_acc_id ,rownum row_num ,sd.coding_name team_name,td.dev_name dev_name ,td.dev_model dev_model ,td.self_num ,td.license_num ,td.device_count,")
		.append(" td.plan_start_date,td.plan_end_date,nvl(td.plan_end_date-td.plan_start_date-(-1),0) date_num,td.vehicle_daily_material ,td.restore_repails,  ")
		.append(" decode(do.daily_oil_type,'2','柴油','1','汽油','') daily_oil_type,do.daily_oil ,do.daily_small_oil,do.single_well_oil,do.oil_unit_price,")
		.append(" dd.asset_value ,dd.depreciation_value,td.drilling_daily_material from bgp_op_tartet_device_material td ")
		.append(" left outer join  comm_coding_sort_detail sd  on td.dev_team = sd.coding_code_id ")
		.append(" left join bgp_op_tartet_device_depre dd on td.dev_acc_id = dd.dev_acc_id and dd.bsflag ='0' and dd.record_type ='0' ")
		.append(" left join bgp_op_tartet_device_oil do on td.dev_acc_id = do.dev_acc_id and do.bsflag ='0' ")
	    .append(" where td.bsflag='0' and  td.project_info_no = '").append(projectInfoNo).append("' and td.if_change ='0'"); //t.dev_type not like 'S11%'
		List<Map> list = pureDao.queryRecords(sb.toString());
		for (Map map : list) {
			Row row = sheet.createRow(rows++);
			int col = 0;
			for (String s : colName) {
				Cell cell = row.createCell(col++);
				cell.setCellValue((String) map.get(s));
			}
		}

		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename("设备材料费、恢复修理费.xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;

	}
	/*
	 * 导入设备信息
	 */
	public ISrvMsg importDeviceInfoForCost(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String errorMessage = "";
		UserToken user = reqDTO.getUserToken();
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String projectInfoNo = user.getProjectInfoNo();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> files = mqMsg.getFiles();
		if (files != null && files.size() > 0) {
			WSFile file = files.get(0);
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = new HSSFWorkbook(is);
			Sheet sheet = book.getSheetAt(0);
			StringBuilder sql = new StringBuilder("");
			String team_types = "0110000001000000001_测量组,0110000001000000003_表层调查组,0110000001000000008_放线班,0110000001000000010_爆炸班,0110000001000000011_震源组,"+
			"0110000001000000013_修理组,0110000001000000014_警戒组,0110000001000000017_后勤,0110000001000000018_仪器组,0110000001000000019_解释组,"+
			"0110000001000000020_队部,0110000001000000022_炊事班,0110000001000000023_司机组,0110000001000000024_钻井组,0110000001000000027_航海,0110000001000001031_非地震";
			for (int i = 2; i < sheet.getPhysicalNumberOfRows(); i++) {
				Row row = sheet.getRow(i);
				Cell cell = row.getCell(0)==null?row.createCell(0):row.getCell(0);
				String dev_acc_id = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				cell = row.getCell(2)==null?row.createCell(2):row.getCell(2);
				cell.setCellType(1);
				String dev_name = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(dev_name==null || dev_name.trim().equals("")){
					errorMessage += "第"+(i+1)+"行设备名称不能空；";
				}
				cell = row.getCell(3)==null?row.createCell(3):row.getCell(3);
				cell.setCellType(1);
				String dev_team = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(dev_team==null || dev_team.trim().equals("") || team_types.indexOf(dev_team)==-1){
					errorMessage += "第"+(i+1)+"行班组不存在；";
				}else{
					dev_team = team_types.substring(team_types.indexOf(dev_team)-20, team_types.indexOf(dev_team)-1);
				}
				cell = row.getCell(4)==null?row.createCell(4):row.getCell(4);
				cell.setCellType(1);
				String device_count = cell.getStringCellValue()==null? "":cell.getStringCellValue();
				if(device_count ==null || device_count.trim().equals("") || !device_count.matches("\\d+")){
					errorMessage += "第"+(i+1)+"行配备数量不是整数；";
				}
				cell = row.getCell(5)==null?row.createCell(5):row.getCell(5);
				cell.setCellType(1);
				String dev_model = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				cell = row.getCell(6)==null?row.createCell(6):row.getCell(6);
				cell.setCellType(1);
				String self_num = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				cell = row.getCell(7)==null?row.createCell(7):row.getCell(7);
				cell.setCellType(1);
				String license_num = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				cell = row.getCell(8)==null?row.createCell(8):row.getCell(8);
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				String plan_start_date = "";
				if(cell.getCellType()==1){
					plan_start_date = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				}else if(cell.getCellType()==0){
					Calendar calendar = Calendar.getInstance();
					calendar.set(1900, 0, 1);
					cell.setCellType(1);
					int add= Integer.valueOf(cell.getStringCellValue());
					calendar.add(Calendar.DAY_OF_YEAR, add-2);
					plan_start_date = df.format(calendar.getTime());
				}
				plan_start_date = plan_start_date.replaceAll("/", "-");
				try{
					df.parse(plan_start_date);
				}catch(Exception e){
					errorMessage += "第"+(i+1)+"行计划进队时间格式不正确；";
				}
				cell = row.getCell(9)==null?row.createCell(9):row.getCell(9);
				String plan_end_date = "";
				if(cell.getCellType()==1){
					plan_end_date = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				}else if(cell.getCellType()==0){
					Calendar calendar = Calendar.getInstance();
					calendar.set(1900, 0, 1);
					cell.setCellType(1);
					int add= Integer.valueOf(cell.getStringCellValue());
					calendar.add(Calendar.DAY_OF_YEAR, add-2);
					plan_end_date = df.format(calendar.getTime());
				}
				plan_end_date = plan_end_date.replaceAll("/", "-");
				try{
					df.parse(plan_end_date);
				}catch(Exception e){
					errorMessage += "第"+(i+1)+"行计划离开时间格式不正确；";
				}
				
				cell = row.getCell(11)==null?row.createCell(11):row.getCell(11);
				cell.setCellType(1);
				String asset_value = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(asset_value ==null || asset_value.trim().equals("") || !asset_value.matches("[0-9]+.\\d+|\\d+")){
					errorMessage += "第"+(i+1)+"行设备原值不是数值；";
				}
				cell = row.getCell(12)==null?row.createCell(12):row.getCell(12);
				cell.setCellType(1);
				String depreciation_value = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(depreciation_value ==null || depreciation_value.trim().equals("") || !depreciation_value.matches("[0-9]+.\\d+|\\d+")){
					errorMessage += "第"+(i+1)+"行计提折旧年限不是数值；";
				}
				
				cell = row.getCell(13)==null?row.createCell(13):row.getCell(13);
				cell.setCellType(1);
				String daily_oil_type = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				String oil_types = "柴油,汽油";
				if(daily_oil_type == null || daily_oil_type.trim().equals("") || oil_types.indexOf(daily_oil_type)==-1){
					errorMessage += "第"+(i+1)+"行日消耗油料类型不存在；";
				}else{
					if(daily_oil_type!=null &&daily_oil_type.trim().equals("柴油")){
						daily_oil_type = "2";
					}else if(daily_oil_type!=null &&daily_oil_type.trim().equals("汽油")){
						daily_oil_type = "1";
					}
				}
				cell = row.getCell(14)==null?row.createCell(14):row.getCell(14);
				cell.setCellType(1);
				String daily_oil = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(daily_oil !=null && !daily_oil.trim().equals("") &&!daily_oil.matches("[0-9]+.\\d+|\\d+")){
					errorMessage += "第"+(i+1)+"行日消耗油料（公斤）不是数字；";
				}
				cell = row.getCell(15)==null?row.createCell(15):row.getCell(15);
				cell.setCellType(1);
				String daily_small_oil = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(daily_small_oil !=null && !daily_small_oil.trim().equals("") && !daily_small_oil.matches("[0-9]+.\\d+|\\d+")){
					errorMessage += "第"+(i+1)+"行日消耗小油品（元/天）不是数字；";
				}
				cell = row.getCell(16)==null?row.createCell(16):row.getCell(16);
				cell.setCellType(1);
				String single_well_oil = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(single_well_oil !=null && !single_well_oil.trim().equals("") && !single_well_oil.matches("[0-9]+.\\d+|\\d+")){
					errorMessage += "第"+(i+1)+"行单井消耗油料（公斤）不是数字；";
				}
				cell = row.getCell(17)==null?row.createCell(17):row.getCell(17);
				cell.setCellType(1);
				String oil_unit_price = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(oil_unit_price !=null && !oil_unit_price.trim().equals("") && !oil_unit_price.matches("[0-9]+.\\d+|\\d+")){
					errorMessage += "第"+(i+1)+"行油料单价(元/公斤)不是数字；";
				}
				
				cell = row.getCell(18)==null?row.createCell(18):row.getCell(18);
				cell.setCellType(1);
				String vehicle_daily_material = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(vehicle_daily_material !=null && !vehicle_daily_material.trim().equals("") && !vehicle_daily_material.matches("[0-9]+.\\d+|\\d+")){
					errorMessage += "第"+(i+1)+"行车辆日消耗材料不是数字；";
				}
				cell = row.getCell(19)==null?row.createCell(19):row.getCell(19);
				cell.setCellType(1);
				String drilling_daily_material = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(drilling_daily_material !=null && !drilling_daily_material.trim().equals("") && !drilling_daily_material.matches("[0-9]+.\\d+|\\d+")){
					errorMessage += "第"+(i+1)+"行钻机日消耗材料不是数字；";
				}
				cell = row.getCell(20)==null?row.createCell(20):row.getCell(20);
				cell.setCellType(1);
				String restore_repails = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(restore_repails !=null && !restore_repails.trim().equals("") && !restore_repails.matches("[0-9]+.\\d+|\\d+")){
					errorMessage += "第"+(i+1)+"行恢复性修理费不是数字；";
				}
				if(dev_acc_id==null || dev_acc_id.trim().equals("")){
					dev_acc_id = java.util.UUID.randomUUID().toString();
					dev_acc_id = dev_acc_id.replaceAll("-", "");
					sql.append("insert into bgp_op_tartet_device_oil(cost_device_id,project_info_no,dev_name,dev_model,plan_start_date,plan_end_date,")
					.append(" daily_oil_type,daily_oil,daily_small_oil,single_well_oil,oil_unit_price,org_id,org_subjection_id,creator,create_date,updator,")
					.append("update_date,bsflag,if_change,dev_team,device_count,dev_acc_id) values((lower(sys_guid())),'"+projectInfoNo+"','"+dev_name+"',")
					.append("'"+dev_model+"',to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'"+daily_oil_type+"',")
					.append("'"+daily_oil+"','"+daily_small_oil+"','"+single_well_oil+"','"+oil_unit_price+"','"+org_id+"','"+org_subjection_id+"',")
					.append(" '"+user_id+"',sysdate,'"+user_id+"',sysdate,'0','0','"+dev_team+"','"+device_count+"','"+dev_acc_id+"');");
										
					sql.append("insert into bgp_op_tartet_device_depre(target_depre_id,project_info_no,dev_name,dev_model,dev_team,device_count,plan_start_date,")
					.append(" plan_end_date,org_id,org_subjection_id,creator,create_date,updator,update_date,bsflag,if_change,record_type,dev_acc_id,asset_value,")
					.append(" depreciation_value)values((lower(sys_guid())),'"+projectInfoNo+"','"+dev_name+"','"+dev_model+"','"+dev_team+"','"+device_count+"',")
					.append(" to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'"+org_id+"','"+org_subjection_id+"',")
					.append(" '"+user_id+"',sysdate,'"+user_id+"',sysdate,'0','0','0','"+dev_acc_id+"','"+asset_value+"','"+depreciation_value+"');");
										
					sql.append("insert into bgp_op_tartet_device_material(target_material_id,project_info_no,dev_name,dev_model,dev_team,device_count,plan_start_date,plan_end_date,")
					.append(" org_id,org_subjection_id,creator,create_date,updator,update_date,bsflag,if_change,dev_acc_id,vehicle_daily_material,drilling_daily_material,")
					.append(" restore_repails)values((lower(sys_guid())),'"+projectInfoNo+"','"+dev_name+"','"+dev_model+"','"+dev_team+"','"+device_count+"',")
					.append(" to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'"+org_id+"','"+org_subjection_id+"','"+user_id+"',")
					.append(" sysdate,'"+user_id+"',sysdate,'0','0','"+dev_acc_id+"','"+vehicle_daily_material+"','"+drilling_daily_material+"','"+restore_repails+"');");
				}else{
					sql.append(" update bgp_op_tartet_device_oil t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.device_count='"+device_count+"',")
					.append(" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),")
					.append(" t.daily_oil='"+daily_oil+"',t.daily_small_oil='"+daily_small_oil+"',t.single_well_oil='"+single_well_oil+"',")
					.append(" t.oil_unit_price='"+oil_unit_price+"',t.dev_team='"+dev_team+"',t.daily_oil_type='"+daily_oil_type+"' ")
					.append(" where t.dev_acc_id='"+dev_acc_id+"';");
								
					sql.append("update bgp_op_tartet_device_depre t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.device_count='"+device_count+"',")
					.append(" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),")
					.append(" t.dev_team='"+dev_team+"',t.asset_value='"+asset_value+"',t.depreciation_value='"+depreciation_value+"' where t.dev_acc_id='"+dev_acc_id+"';");
								
					sql.append("update bgp_op_tartet_device_material t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.device_count='"+device_count+"',")
					.append(" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),")
					.append(" t.dev_team='"+dev_team+"' ,t.vehicle_daily_material='"+vehicle_daily_material+"',t.drilling_daily_material='"+drilling_daily_material+"',")
					.append(" t.restore_repails='"+restore_repails+"' where t.dev_acc_id='"+dev_acc_id+"';");
				}
			}
			System.out.println(sql.toString());
			if(errorMessage==null || errorMessage.trim().equals("")){
				errorMessage = "导入成功!";
				jdbcTemplate.batchUpdate(sql.toString().split(";"));
			}
		}
		responseDTO.setValue("message", errorMessage);
		return responseDTO;

	}

	/*
	 * 获取某物探处的指标信息getOrgIncomeIndex
	 */
	public ISrvMsg getOrgIncomeIndex(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		String year = reqDTO.getValue("year");
		String sql = " select * from bgp_op_cost_income_index t where t.org_info = '" + orgId + "' and t.year='" + year + "' order by month";
		OPCommonUtil.setFenyeInfo(reqDTO, responseDTO, sql);
		return responseDTO;
	}

	/*
	 * 保存物探处指标信息saveCostIncomeIndex
	 */
	public ISrvMsg saveCostIncomeIndex(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String orgId = reqDTO.getValue("orgId");
		String year = reqDTO.getValue("year");
		UserToken user = reqDTO.getUserToken();

		String sql = "delete from bgp_op_cost_income_index t where t.org_info = '" + orgId + "' and t.year='" + year + "' ";
		jdbcTemplate.execute(sql);
		for (int i = 0; i < 2; i++) {
			Map map = new HashMap();
			map.put("year", Integer.parseInt(year));
			map.put("org_info", orgId);
			map.put("type", i);
			map.put("money", "".equals(reqDTO.getValue("fy" + i + "money"))?0:Double.parseDouble(reqDTO.getValue("fy" + i + "money"))*10000);
			map.put("bsflag", "0");
			map.put("org_id", user.getOrgId());
			map.put("org_subjection_id", user.getOrgSubjectionId());
			map.put("creator", user.getUserName());
			pureDao.saveOrUpdateEntity(map, "bgp_op_cost_income_index");
		}
		return responseDTO;
	}

	/*
	 * 获取项目的各项技术指标importTargetIndicatorInfo
	 */
	public ISrvMsg importTargetIndicatorInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String targetBasicId = reqDTO.getValue("targetBasicId");
		String adjustOrNot = reqDTO.getValue("adjustOrNot");
		if(adjustOrNot==null || adjustOrNot.trim().equals("")){
			OPCommonUtil.importTargetIndicatorInfo(projectInfoNo,"bgp_op_target_project_indicato","target_indicator_id",targetBasicId,user);
		}else{
			OPCommonUtil.importTargetIndicatorInfo(projectInfoNo,"bgp_op_target_indicato_change","indicator_change_id",targetBasicId,user);
		}
		return responseDTO;
	}
	
	/*
	 * 从已有的项目中导入已经设计好的公式
	 */
	public ISrvMsg importFormulaFromProject(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String projectId = reqDTO.getValue("projectId");
		StringBuffer sql=new StringBuffer("update bgp_op_target_project_info t set t.formula_type = (select formula_type from bgp_op_target_project_info p where p.project_info_no = '"+projectInfoNo+"' and p.template_id = t.template_id)");
		sql.append(",t.formula_content = (select formula_content from bgp_op_target_project_info p where p.project_info_no = '"+projectInfoNo+"' and p.template_id = t.template_id)");
		sql.append(",t.formula_content_a = (select formula_content_a from bgp_op_target_project_info p where p.project_info_no = '"+projectInfoNo+"' and p.template_id = t.template_id)");
		sql.append(" where t.project_info_no = '"+projectId+"'");
		jdbcTemplate.execute(sql.toString());
		return responseDTO;
		
	}
	/*
	 * 人工成本计划   costState=1 表示物探处，=0表示专业化 ，twoState is null 表示补充计划
	 */
	public ISrvMsg getCostPlanCodes(ISrvMsg reqDTO) throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		
		String costState = reqDTO.getValue("costState");
		String twoState = reqDTO.getValue("twoState");
		String spare5 = reqDTO.getValue("spare5");
		if(spare5==null || spare5.trim().equals("")){
			spare5 = "";
		}
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		StringBuffer sql = new StringBuffer("select t.coding_code_id, t.coding_code,s.sum_human_cost,s.cont_cost,s.mark_cost,s.temp_cost,s.reem_cost, ")
		.append(" s.serv_cost,s.subject_id, case when length(t.coding_code) = 2 then 1 when length(t.coding_code) = 4 then 2 else  3 end fs,  ")
		.append(" t.coding_name, t.coding_show_order,  decode(length(t.coding_code), 2, 's', 4,substr(t.coding_code, 0, 2),substr(t.coding_code, 0, 4)) parent_id ") 
		.append(" from comm_human_coding_sort t left join (select sum(pp.sum_human_cost)sum_human_cost,sum(pp.cont_cost)cont_cost,sum(pp.mark_cost)mark_cost,")
		.append(" sum(pp.reem_cost)reem_cost,sum(pp.temp_cost)temp_cost,sum(pp.serv_cost)serv_cost,pp.subject_id,pp.cost_state ")
		.append(" from (select s.sum_human_cost,s.cont_cost,s.mark_cost,s.temp_cost,s.reem_cost,s.serv_cost,s.subject_id,s.cost_state")
		.append(" from bgp_comm_human_cost_plan_sala s   ")
		.append(" inner join bgp_comm_human_plan_cost c on s.project_info_no = c.project_info_no   and s.plan_id = c.plan_id and c.cost_state = '1'  ")  
		.append(" inner join common_busi_wf_middle wf on wf.business_id = c.plan_id and wf.bsflag ='0' and wf.proc_status ='3'   ")
		.append(" and wf.busi_table_name ='bgp_comm_human_plan_cost' and wf.business_type ='5110000004100000048'   ")
		.append(" where s.bsflag='0' and s.spare5 is null  and c.spare5 is null and s.project_info_no = '").append(projectInfoNo).append("'");
		if(spare5!=null && !spare5.trim().equals("")){
			sql.append(" union select s.sum_human_cost,s.cont_cost,s.mark_cost,s.temp_cost,s.reem_cost,s.serv_cost,s.subject_id,s.cost_state from bgp_comm_human_cost_plan_sala s  ") 
			.append(" inner join bgp_comm_human_plan_cost c on s.project_info_no = c.project_info_no   and s.plan_id = c.plan_id and c.cost_state = '1' ")   
			.append(" inner join common_busi_wf_middle wf on wf.business_id = c.plan_id and wf.bsflag ='0' and wf.proc_status ='3' ")//
			.append(" and wf.busi_table_name ='bgp_comm_human_plan_cost' and wf.business_type ='5110000004100000048'   ")
			.append(" where s.bsflag='0' and s.spare5 ='1'  and c.spare5 ='1' and s.project_info_no = '").append(projectInfoNo).append("'");
		}
		
		sql.append(")pp group by pp.subject_id,pp.cost_state) s   on t.coding_code_id = s.subject_id  ")
		.append(" where t.coding_sort_id = '0000000002' and t.bsflag = '0'  order by t.coding_code, t.coding_show_order");

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		
		StringBuffer rootSql = new StringBuffer("select sum(sum_human_cost) sum_human_cost from(select sum(s.sum_human_cost) sum_human_cost ");
		rootSql.append(" from bgp_comm_human_cost_plan_sala s  inner join bgp_comm_human_plan_cost c on s.project_info_no = c.project_info_no ");
		rootSql.append(" inner join common_busi_wf_middle wf on wf.business_id = c.plan_id and wf.bsflag ='0' and wf.proc_status ='3' ");
		rootSql.append(" and wf.busi_table_name ='bgp_comm_human_plan_cost' and wf.business_type ='5110000004100000048' ");
		rootSql.append(" and s.plan_id = c.plan_id and c.cost_state = '").append(costState).append("' ");
		rootSql.append(" left join comm_human_coding_sort o on s.subject_id = o.coding_code_id ");
		rootSql.append(" where s.bsflag = '0' and length(o.coding_code) = 2 and s.spare5 is null  and c.spare5 is null");
		rootSql.append(" and s.project_info_no = '").append(projectInfoNo).append("' ");
		if(spare5!=null && !spare5.trim().equals("")){
			rootSql.append(" union select sum(s.sum_human_cost) sum_human_cost ");
			rootSql.append(" from bgp_comm_human_cost_plan_sala s  inner join bgp_comm_human_plan_cost c on s.project_info_no = c.project_info_no ");
			rootSql.append(" inner join common_busi_wf_middle wf on wf.business_id = c.plan_id and wf.bsflag ='0' and wf.proc_status ='3' ");//
			rootSql.append(" and wf.busi_table_name ='bgp_comm_human_plan_cost' and wf.business_type ='5110000004100000048' ");
			rootSql.append(" and s.plan_id = c.plan_id and c.cost_state = '").append(costState).append("' ");
			rootSql.append(" left join comm_human_coding_sort o on s.subject_id = o.coding_code_id ");
			rootSql.append(" where s.bsflag = '0' and length(o.coding_code) = 2 and s.spare5 ='1'  and c.spare5 ='1'");
			rootSql.append(" and s.project_info_no = '").append(projectInfoNo).append("'");
		}
		rootSql.append(" )");
		
		
		
		Map rootMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(rootSql.toString());
		
		rootMap.put("codingCodeId", "s");
		rootMap.put("codingCode", "s");
		rootMap.put("parentId", "root");
		rootMap.put("codingName", "项目");
		rootMap.put("codingShowOrder", "1");
		rootMap.put("expanded", "true");

		
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "codingCode", "parentId", rootMap);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("json", json);
		
		return msg;
	}
	
	/*
	 *判断当前论证方案是否已提交 
	 */
	public ISrvMsg getInformationOfAuditVersion(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo=reqDTO.getValue("projectInfoNo");
		if(projectInfoNo==null || projectInfoNo.trim().equals("")){
			projectInfoNo = user.getProjectInfoNo();
		}
		boolean audit=OPCommonUtil.getInformationOfAuditVersion(projectInfoNo);
		responseDTO.setValue("audit", audit);
		return responseDTO;
	}
	
    /* 单价库excel导出 */ 
	public ISrvMsg exportPrice(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String project_name = user.getProjectName();
		Workbook wb = new HSSFWorkbook();
		Font font = wb.createFont();
		font.setColor(Font.COLOR_RED);
		CellStyle cs = wb.createCellStyle();
		cs.setFont(font);
		cs.setAlignment(CellStyle.ALIGN_CENTER);
		cs.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		
		Sheet sheet = wb.createSheet();
		sheet.setColumnWidth(0, 9000);
		sheet.setColumnHidden(0, true);
		sheet.setColumnWidth(1, 9000);
		sheet.setColumnHidden(1, true);
		sheet.setColumnWidth(2, 9000);
		sheet.setColumnWidth(3, 6000);
		sheet.setColumnWidth(4, 4000);
		Row row0 = sheet.createRow((short)0);
		row0.setHeight((short)400);
		Cell cell0 = row0.createCell((short) 0);
		cell0.setCellStyle(cs);
		cell0.setCellValue("模板主键(不可删除)");
		cell0 = row0.createCell((short) 1);
		cell0.setCellStyle(cs);
		cell0.setCellValue("项目主键(不可删除)");
		cell0 = row0.createCell((short) 2);
		cell0.setCellStyle(cs);
		cell0.setCellValue("项目名称(不可删除)");
		cell0 = row0.createCell((short) 3);
		cell0.setCellStyle(cs);
		cell0.setCellValue("单价名称");
		cell0 = row0.createCell((short) 4);
		cell0.setCellStyle(cs);
		cell0.setCellValue("价格");
		String[] colName = { "price_template_id", "project_info_no","project_name", "price_name", "price_unit"};
		StringBuilder sb = new StringBuilder();
		sb.append("select t.price_template_id,t.project_info_no,t.price_name,t.price_unit ,'").append(project_name).append("' project_name from bgp_op_price_project_info t where t.bsflag ='0' and t.if_change is null")
		.append(" and t.price_name !='物资带入单价' and t.price_name !='手工输入单价' and t.project_info_no ='").append(projectInfoNo).append("' order by t.parent_id asc ,t.order_code asc"); //and t.parent_id !='01'
		List<Map> list = pureDao.queryRecords(sb.toString());
		int i =1;
		for (Map map : list) {
			Row row = sheet.createRow(i++);
			int col = 0;
			for (String s : colName) {
				Cell cell = row.createCell(col++);
				cell.setCellValue((String) map.get(s));
			}
		}

		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename("单价库信息.xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;

	}
	
	/* 单价库excel导出入*/ 
	public ISrvMsg importPrice(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String message = "";
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		List<WSFile> fileList = mqMsg.getFiles();
		StringBuffer sb = new StringBuffer();
		if(fileList!=null && fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] uploadData = uploadFile.getFileData();
			String file_name = uploadFile.getFilename();
			String price_template_id = "";
        	String project_info_no = "";
        	String price_name = "";
        	String price_unit = "";
			String type = file_name.substring(file_name.indexOf(".")+1);
			Workbook wb = null;
			Sheet sheet = null;
			if(type!=null && type.equals("xls")){
				wb = new HSSFWorkbook(	new POIFSFileSystem(new ByteArrayInputStream(uploadFile.getFileData())));
		        sheet = wb.getSheetAt(0); 
			}else if(type!=null && type.equals("xlsx")){
				wb = new XSSFWorkbook(	new ByteArrayInputStream(uploadFile.getFileData()));
		        sheet = wb.getSheetAt(0);
			}
			int rowIndex = sheet.getPhysicalNumberOfRows();
	        for(int i = 3;i<rowIndex;i++ ){
	        	Row row = sheet.getRow(i);
	        	Cell cell = row.getCell((short)0);
	        	if(cell==null ){
	        		message = message + "第"+(i+1)+"行‘模板主键’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		price_template_id = cell.getStringCellValue();
	        		if(price_template_id==null ){
	        			message = message + "第"+(i+1)+"行‘模板主键’为空;";
	        		}
	        	}
	        	cell = row.getCell((short)1);
	        	if(cell==null ){
	        		message = message + "第"+(i+1)+"行‘项目主键’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		project_info_no = cell.getStringCellValue();
	        		if(project_info_no==null || project_info_no.trim().equals("")){
	        			message = message + "第"+(i+1)+"行‘项目主键’为空;";
	        		}
	        	}
	        	cell = row.getCell((short)3);
	        	if(cell==null){
	        		message = message + "第"+(i+1)+"行‘单价名称’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		price_name = cell.getStringCellValue();
	        		if(price_name==null || price_name.trim().equals("")){
	        			message = message + "第"+(i+1)+"行‘单价名称’为空;";
	        		}
	        	}
	        	cell = row.getCell((short)4);
	        	if(cell==null){
	        		message = message + "第"+(i+1)+"行‘价格’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		price_unit = cell.getStringCellValue();
	        		if(price_unit==null || price_unit.trim().equals("")){
	        			message = message + "第"+(i+1)+"行‘价格’为空;";
	        		}else{
	        			if(!price_unit.matches("[0-9]+\\d*|\\d+.\\d+")){
	        				message = message + "第"+(i+1)+"行‘价格’格式不正确;";
	        			}
	        		}
	        	}
        		sb.append("update bgp_op_price_project_info t set t.price_name = '").append(price_name).append("' ,t.price_unit= '").append(price_unit).append("'")
    			.append(" where t.bsflag ='0' and t.price_template_id ='").append(price_template_id).append("' and t.project_info_no ='").append(project_info_no).append("';");
    			
	        }
		}
		if(message!=null && message.trim().equals("")){
			message = "导入成功!";
			saveDatasBySql(sb.toString());
		}
		responseDTO.setValue("message", message);
		return responseDTO;

	}
	/**
	 * 获得项目的单价库信息
	 * author xiaoxia 
	 */
	public ISrvMsg getPriceTree(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String node = reqDTO.getValue("node");
		String price_type = reqDTO.getValue("price_type");
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null || project_info_no.trim().equals("")){
			project_info_no = user.getProjectInfoNo();
		}
		StringBuffer sb  = new StringBuffer();
		JSONArray json = null;
		if(node==null || node.trim().equals("") || node.trim().equals("root")){
			node = "01";
		}
		if(price_type==null ||price_type.trim().equals("")){
			price_type = "if_change";
		}
		sb = new StringBuffer();
		sb.append(" select t.price_project_id id,t.price_name,t.price_unit,t.price_type, ")
		.append(" decode((select count(*) from bgp_op_price_project_info where parent_id = t.price_project_id),0,'true','false') leaf ")
		.append(" from bgp_op_price_project_info t where t.bsflag ='0' and project_info_no = '").append(project_info_no).append("' ")
		.append(" and ").append(price_type).append(" is null and parent_id = '").append(node).append("' order by ORDER_CODE ");
		List list = jdbcDao.queryRecords(sb.toString());
		json = JSONArray.fromObject(list);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (json == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", json.toString());
		}
		return msg;
	}
	/* 技术方案编制excel导出 */ 
	public ISrvMsg exportProjectSchema(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_name = reqDTO.getValue("project_name");
		project_name = java.net.URLDecoder.decode(project_name,"UTF-8");
		String cost_project_schema_id = reqDTO.getValue("cost_project_schema_id");
		Workbook wb = new HSSFWorkbook();
		CellStyle cs = getTitleStyle(wb);
		String[] colName1 = {"方案名称-schema_name","方案描述-schema_desc","观测系统类型-tech_001", "设计线束-tech_002","满覆盖工作量-tech_003", "实物工作量-tech_004",
			"井炮生产炮数-tech_005","震源生产炮数-tech_006","气枪生产炮数-tech_007","炮数-tech_008", "微测井-tech_009","小折射-tech_010", "接收道数-tech_011","检波器串数-tech_012",
			"覆盖次数-tech_013", "道间距-tech_014","炮点距-tech_015", "接收线距-tech_016","炮线距-tech_017","单线道数-tech_018","滚动接收线数-tech_019", "面元-tech_020"};
		StringBuilder sb = new StringBuilder();
		sb.append("select t.* from bgp_op_cost_project_schema t ")
		.append(" left join bgp_op_cost_project_sch_det d on t.cost_project_schema_id = d.cost_project_schema_id")
		.append(" where t.bsflag ='0' and t.cost_project_schema_id ='").append(cost_project_schema_id).append("'");
		Map map = pureDao.queryRecordBySQL(sb.toString());
		Sheet sheet = wb.createSheet("方案技术指标");
		if(map!=null ){
			String project_type = OPCommonUtil.getProjectType((String)map.get("project_info_no"));
			sheet.setColumnHidden(0, true);
			sheet.setColumnWidth(0, 9000);
			sheet.setColumnHidden(1, true);
			sheet.setColumnWidth(1, 9000);
			sheet.setColumnWidth(2, 6000);
			sheet.setColumnWidth(3, 6000);
			sheet.setColumnWidth(4, 6000);
			Row row0 = sheet.createRow(0);
			row0.setHeight((short)400);
			Cell cell0 = row0.createCell(0);
			cell0.setCellStyle(cs);
			cell0.setCellValue("项目(不可删除)");
			cell0 = row0.createCell(1);
			cell0.setCellStyle(cs);
			cell0.setCellValue("字段(不可删除)");
			cell0 = row0.createCell(2);
			cell0.setCellStyle(cs);
			cell0.setCellValue("名称");
			cell0 = row0.createCell(3);
			cell0.setCellStyle(cs);
			cell0.setCellValue("内容");
			int i =2;
			int length = 23;
			if(project_type!=null && project_type.trim().equals("2")){
				length = 18;
			}
			for (String s : colName1 ) {
				if(i>length) break;
				
				Row row = sheet.createRow(i++);
				row.setHeight((short)400);
				CellStyle cs0 = getContentStyle(wb);
				String []column = s.split("-");
				Cell cell = row.createCell(0);
				cell.setCellStyle(cs0);
				cell.setCellValue((String) map.get("project_info_no"));
				
				cell = row.createCell(1);
				cell.setCellStyle(cs0);
				cell.setCellValue(column[1]);
				
				cell = row.createCell(2);
				cell.setCellStyle(cs0);
				cell.setCellValue(column[0]);
				
				cell = row.createCell(3);
				cell.setCellStyle(cs0);
				cell.setCellValue((String) map.get(column[1]));
			}
			i =1;
			Row row = sheet.createRow(i);
			row.setHeight((short)400);
			CellStyle cs0 = getContentStyle(wb);
			String s = "工作量类型-spare5";
			String []column = s.split("-");
			Cell cell = row.createCell(0);
			cell.setCellStyle(cs0);
			cell.setCellValue((String) map.get("project_info_no"));
			
			cell = row.createCell(1);
			cell.setCellStyle(cs0);
			cell.setCellValue(column[1]);
			
			cell = row.createCell(2);
			cell.setCellStyle(cs0);
			cell.setCellValue(column[0]);
			
			cell = row.createCell(3);
			cell.setCellStyle(cs0);
			String spare5 = (String)map.get(column[1]);
			if(spare5!=null && spare5.trim().equals("2")){
				spare5 = "实物工作量";
			}else{
				spare5 = "满覆盖工作量";
			}
			cell.setCellValue(spare5);
			String[] type = {"满覆盖工作量","实物工作量"};
			DVConstraint constraint = DVConstraint.createExplicitListConstraint(type);		
			//设置数据有效性加载在哪个单元格上。
			CellRangeAddressList regions = new CellRangeAddressList(i,i, 3, 3);//四个参数分别是：起始行、终止行、起始列、终止列
			//数据有效性对象
			HSSFDataValidation data_validation = new HSSFDataValidation(regions, constraint);
			sheet.addValidationData(data_validation);
		}
		
		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename(project_name+".xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;

	}
	/* 技术方案编制excel导入*/ 
	public ISrvMsg importProjectSchema(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String message = "";
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		List<WSFile> fileList = mqMsg.getFiles();
		StringBuffer sb = new StringBuffer();
		if(fileList!=null && fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			String file_name = uploadFile.getFilename();
			String project_info_no = "";
        	String name = "";
        	String value = "";
			String type = file_name.substring(file_name.indexOf(".")+1);
			Workbook wb = null;
			Sheet sheet = null;
			if(type!=null && type.equals("xls")){
				wb = new HSSFWorkbook(	new POIFSFileSystem(new ByteArrayInputStream(uploadFile.getFileData())));
			}else if(type!=null && type.equals("xlsx")){
				wb = new XSSFWorkbook(	new ByteArrayInputStream(uploadFile.getFileData()));
			}
			sheet = wb.getSheetAt(0);
			String sql = "select lower(sys_guid()) key_id from dual";
			Map map = pureDao.queryRecordBySQL(sql);
			String key_id = (map==null || map.get("key_id")==null || ((String)map.get("key_id")).trim().equals(""))?"":(String)map.get("key_id");
			String column = "";
			String values = "";
			String update = "";
			int rowIndex = sheet.getPhysicalNumberOfRows();
	        for(int i = 2;i<rowIndex;i++ ){
	        	Row row = sheet.getRow(i);
        		Cell cell = row.getCell((short)0);
	        	if(cell==null ){
	        		message = message + "第"+(i+1)+"行‘项目’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		project_info_no = cell.getStringCellValue();
	        		if(project_info_no==null || project_info_no.trim().equals("")){
	        			message = message + "第"+(i+1)+"行‘项目’为空;";
	        		}
	        	}
	        	cell = row.getCell((short)1);
	        	if(cell==null ){
	        		message = message + "第"+(i+1)+"行‘字段’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		name = cell.getStringCellValue();
	        		if(name==null || name.trim().equals("")){
	        			message = message + "第"+(i+1)+"行‘字段’为空;";
	        		}
	        	}
	        	cell = row.getCell((short)3);
        		cell.setCellType(1);
        		value = cell.getStringCellValue();
        		column = column + name+",";
        		values = values +"'"+ value+"',";
        		update = update + name+"='"+value+"',";
	        }
	        Row row = sheet.getRow(2);
    		Cell cell = row.getCell((short)3);
    		if(cell.getCellType()==0){
    			message = "方案名称不能是数字!"+ message;
    		}
    		cell.setCellType(1);
    		String schema_name = cell.getStringCellValue();
    		
    		row = sheet.getRow(1);
    		cell = row.getCell((short)3);
    		String types = "1_满覆盖工作量,2_实物工作量";
    		String spare5 = cell.getStringCellValue();
    		int index = types.indexOf(spare5);
    		spare5 = types.substring(index-2, index-1);
    		
    		column = column + "spare5,";
    		values = values +"'"+ spare5+"',";
    		update = update + "spare5='"+spare5+"',";
    		
    		sql = "select t.cost_project_schema_id from bgp_op_cost_project_schema t where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"' and t.schema_name ='"+schema_name+"' and rownum=1";
    		map = pureDao.queryRecordBySQL(sql);
    		String cost_project_schema_id = (map==null || map.get("cost_project_schema_id")==null)?"":(String)map.get("cost_project_schema_id");
    		if(cost_project_schema_id!=null && !cost_project_schema_id.trim().equals("")){
    			sb.append("update bgp_op_cost_project_schema t set ").append(update).append(" bsflag ='0' where t.cost_project_schema_id='").append(cost_project_schema_id).append("'");
    		}else{
    			sb.append("insert into bgp_op_cost_project_schema(cost_project_schema_id,").append(column).append("org_id,org_subjection_id,creator,create_date,updator,modifi_date,bsflag,")
		        .append("spare4,project_info_no)values('").append(key_id).append("',").append(values).append("'").append(org_id).append("','").append(org_subjection_id).append("',")
		        .append("'").append(user_id).append("',sysdate,'").append(user_id).append("',sysdate,'0',sysdate,'").append(project_info_no).append("');");
    			cost_project_schema_id = key_id;
    			sb.append("insert into bgp_op_cost_project_info(gp_cost_project_id,template_id,project_info_no,node_code,cost_name,cost_desc,order_code,cost_type,")
    			.append(" parent_id,spare4,bsflag,cost_project_schema_id) select lower(sys_guid()),t.template_id, '").append(project_info_no).append("',t.node_code,")
    			.append(" t.cost_name,t.cost_desc,t.order_code,t.cost_type,(select gp_cost_project_id from bgp_op_cost_project_info where bsflag ='0' and template_id = t.parent_id")
    			.append(" and project_info_no ='").append(project_info_no).append("' and cost_project_schema_id ='").append(cost_project_schema_id).append("')")
    			.append(",sysdate,'0','").append(cost_project_schema_id).append("' ")
    			.append(" from bgp_op_cost_template t where t.bsflag ='0' and t.template_id not in (select template_id from bgp_op_cost_project_info where bsflag ='0' ")
    			.append(" and project_info_no ='").append(project_info_no).append("' and cost_project_schema_id ='").append(cost_project_schema_id).append("');");
    			sb.append("update bgp_op_cost_project_info t set t.parent_id =(select (select p.gp_cost_project_id from bgp_op_cost_project_info p where p.template_id = ct.parent_id")
    			.append(" and p.project_info_no=t.project_info_no and p.cost_project_schema_id=t.cost_project_schema_id) from bgp_op_cost_template ct where ct.bsflag ='0' and ct.template_id = t.template_id) ")
    		    .append(" where t.bsflag ='0' and t.project_info_no = '" + project_info_no + "' and t.cost_project_schema_id='" + cost_project_schema_id + "';");
    			sb.append("update bgp_op_cost_project_info t set t.parent_id='01' where parent_id is null and project_info_no = '" + project_info_no+ "' and cost_project_schema_id='" + cost_project_schema_id + "';");
    		}
		}
		if(message!=null && message.trim().equals("")){
			message = "导入成功!";
			saveDatasBySql(sb.toString());
		}
		responseDTO.setValue("message", message);
		return responseDTO;

	}
	public ISrvMsg refrashCostSchema(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String project_info_no = reqDTO.getValue("project_info_no");
		String cost_project_schema_id = reqDTO.getValue("cost_project_schema_id");
		StringBuffer sb = new StringBuffer("insert into bgp_op_cost_project_info(gp_cost_project_id,template_id,project_info_no,node_code,cost_name,cost_desc,order_code,cost_type,")
		.append(" parent_id,spare4,bsflag,cost_project_schema_id) select lower(sys_guid()),t.template_id, '").append(project_info_no).append("',t.node_code,")
		.append(" t.cost_name,t.cost_desc,t.order_code,t.cost_type,(select gp_cost_project_id from bgp_op_cost_project_info where bsflag ='0' and template_id = t.parent_id")
		.append(" and project_info_no ='").append(project_info_no).append("' and cost_project_schema_id ='").append(cost_project_schema_id).append("')")
		.append(",sysdate,'0','").append(cost_project_schema_id).append("' ")
		.append(" from bgp_op_cost_template t where t.bsflag ='0' and t.template_id not in (select template_id from bgp_op_cost_project_info where bsflag ='0' ")
		.append(" and project_info_no ='").append(project_info_no).append("' and cost_project_schema_id ='").append(cost_project_schema_id).append("')");
		jdbcTemplate.execute(sb.toString());
		//	importProjectSchema
		return msg;

	}
	public ISrvMsg exportCostSchema(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		String project_info_no = reqDTO.getValue("project_info_no");
		String cost_project_schema_id = reqDTO.getValue("cost_project_schema_id");
		UserToken user = reqDTO.getUserToken();
		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../op/costMangerVersion/costTemplateTree.xls"));
		Sheet sheet = wb.getSheetAt(0);
		int rows = sheet.getPhysicalNumberOfRows();
		String[] colName = { "manage_org", "team", "project_name", "surface_type", "work_load", "work_situation", "work_factor", "work_reason", "work_person", "work_device"};
		StringBuffer sb = new StringBuffer("select t.manage_org,t.team,t.project_name,t.surface_type,sd.work_load,sd.work_situation,sd.work_factor,sd.work_reason,")
		.append(" sd.work_person,sd.work_device from bgp_op_cost_project_basic t ")
		.append(" left join bgp_op_cost_project_schema ps on t.project_info_no = ps.project_info_no and ps.bsflag ='0' and ps.cost_project_schema_id ='"+cost_project_schema_id+"'")
		.append(" left join bgp_op_cost_project_sch_det sd on ps.cost_project_schema_id = sd.cost_project_schema_id and sd.bsflag ='0'")
		.append(" where t.bsflag ='0' and t.project_info_no ='"+project_info_no+"'");
		Map map1 = pureDao.queryRecordBySQL(sb.toString());
		int row_num = 2;
		for (String s : colName) {
			Row row = sheet.getRow(row_num++);
			Cell cell = row.getCell(3);
			cell.setCellValue(map1==null || map1.get(s)==null?"":(String) map1.get(s));
		}
		sb = new StringBuffer()
		.append(" select t.cost_name ,(select nvl(sum(d.cost_detail_money),0)/10000.0 from bgp_op_cost_project_info p left join bgp_op_cost_project_detail d on p.gp_cost_project_id = d.gp_cost_project_id")
		.append(" where p.bsflag ='0'  and p.node_code like t.node_code||'%' and p.cost_project_schema_id ='"+cost_project_schema_id+"') cost_detail_money ,connect_by_isleaf is_leaf,")
		.append(" (select distinct d.cost_detail_desc from bgp_op_cost_project_info p left join bgp_op_cost_project_detail d on p.gp_cost_project_id = d.gp_cost_project_id")
		.append(" where p.bsflag ='0'  and t.gp_cost_project_id = p.gp_cost_project_id and p.cost_project_schema_id ='"+cost_project_schema_id+"') cost_detail_desc")
		.append(" from bgp_op_cost_project_info t where t.bsflag ='0' and t.project_info_no = '"+project_info_no+"'")
		.append(" and t.cost_project_schema_id ='"+cost_project_schema_id+"' start with t.parent_id ='01' connect by prior t.gp_cost_project_id = t.parent_id order siblings by t.order_code");
		List<Map> list = pureDao.queryRecords(sb.toString());
		row_num = 13;
		for(long i =0;list!=null && i<list.size();i++){
			Map map = (Map)list.get((int)i);
			Row row = sheet.getRow(row_num++);
			String cost_detail_money = (String)map.get("cost_detail_money");
			String cost_detail_desc = (String)map.get("cost_detail_desc");
			Cell cell = row.getCell(3);
			//cell.setCellValue(map==null||map.get("cost_detail_money")==null?"":(String)map.get("cost_detail_money"));
			cell.setCellValue(cost_detail_money);
			cell = row.getCell(4);
			//cell.setCellValue(map==null||map.get("cost_detail_desc")==null?"":(String)map.get("cost_detail_desc"));
			cell.setCellValue(cost_detail_desc);
		}
		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename("技术经济一体化论证模板.xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;

	}
	
	/* excel导出 公共方法*/ 
	public ISrvMsg commExportExcel(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String export_function = reqDTO.getValue("export_function");
		String project_info_no = reqDTO.getValue("project_info_no");
		String key_id = reqDTO.getValue("key_id");
		String file_name = reqDTO.getValue("file_name");
		file_name = java.net.URLDecoder.decode(file_name, "UTF-8");
		Workbook wb = new HSSFWorkbook();
		if(export_function!=null && export_function.trim().equals("exportShareHSE")){
			wb = exportShareHSE(project_info_no);
		}else if(export_function!=null && export_function.trim().equals("exportShareLabormon")){
			wb = exportShareLabormon(project_info_no);
		}else if(export_function!=null && export_function.trim().equals("exportBanlance")){
			wb = exportBanlance(project_info_no,key_id);
		}else if(export_function!=null && export_function.trim().equals("exportWarning")){
			wb = exportWarning(project_info_no);
		}else if(export_function!=null && export_function.trim().equals("exportRent")){
			wb = exportRent(project_info_no);
		}else if(export_function!=null && export_function.trim().equals("exportTargetCost")){
			wb = exportTargetCost(project_info_no,key_id);
		}else if(export_function!=null && export_function.trim().equals("exportLine")){
			wb = exportLine(project_info_no,file_name);
		}
		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename(file_name+".xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;

	}
	public Workbook exportShareHSE(String project_info_no){
		Workbook wb = new HSSFWorkbook();
		CellStyle cs = getTitleStyle(wb);
		//安全设施费用
		String[] colName1 = {"名称-hse_name","数量-hse_count_t","单价-hse_unit"};
		
		StringBuilder sb = new StringBuilder();
		sb.append("select t.*,t.rowid from bgp_op_cost_tartet_hse t where t.bsflag ='0' and t.if_change ='0' and t.project_info_no ='").append(project_info_no).append("' order by t.create_date desc");
		List<Map> list = pureDao.queryRecords(sb.toString());
		Sheet sheet = wb.createSheet("安全设施费测算");
		sheet.setColumnHidden(0, true);
		sheet.setColumnWidth(0, 9000);
		sheet.setColumnWidth(1, 9000);
		sheet.setColumnWidth(2, 6000);
		sheet.setColumnWidth(3, 6000);
		sheet.setColumnWidth(4, 6000);
		Row row0 = sheet.createRow(0);
		row0.setHeight((short)400);
		Cell cell0 = row0.createCell(0);
		cell0.setCellStyle(cs);
		cell0.setCellValue("项目(不可删除)");
		cell0 = row0.createCell(1);
		cell0.setCellStyle(cs);
		cell0.setCellValue("名称");
		cell0 = row0.createCell(2);
		cell0.setCellStyle(cs);
		cell0.setCellValue("数量(整数)");
		cell0 = row0.createCell(3);
		cell0.setCellStyle(cs);
		cell0.setCellValue("单价(小数)");
		int i =1;
		for(Map map:list ){
			Row row = sheet.createRow(i++);
			row.setHeight((short)400);
			CellStyle cs0 = getContentStyle(wb);
			Cell cell = row.createCell(0);
			cell.setCellStyle(cs0);
			cell.setCellValue((String) map.get("project_info_no"));
			int col = 1;
			for (String s : colName1) {
				String []column = s.split("-");
				cell = row.createCell(col++);
				cell.setCellStyle(cs0);
				cell.setCellValue((String) map.get(column[1]));
			}
		}
		return wb;
	}
	public Workbook exportShareLabormon(String project_info_no){
		Workbook wb = new HSSFWorkbook();
		CellStyle cs = getTitleStyle(wb);
		//安全设施费用
		String[] colName1 = {"工序及班组-apply_team","岗位名称-post","定员-person_num","劳保配备标准（元）-person_money"};
		
		StringBuilder sb = new StringBuilder();
		sb.append("select t.*,t.rowid from bgp_op_cost_tartet_labormon t where t.bsflag ='0' and t.if_change ='0' and t.project_info_no ='").append(project_info_no).append("' order by t.create_date desc");
		List<Map> list = pureDao.queryRecords(sb.toString());
		Sheet sheet = wb.createSheet("劳保费用测算");
		sheet.setColumnHidden(0, true);
		sheet.setColumnWidth(0, 9000);
		sheet.setColumnWidth(1, 9000);
		sheet.setColumnWidth(2, 6000);
		sheet.setColumnWidth(3, 6000);
		sheet.setColumnWidth(4, 6000);
		Row row0 = sheet.createRow(0);
		row0.setHeight((short)400);
		Cell cell0 = row0.createCell(0);
		cell0.setCellStyle(cs);
		cell0.setCellValue("项目(不可删除)");
		cell0 = row0.createCell(1);
		cell0.setCellStyle(cs);
		cell0.setCellValue("工序及班组");
		cell0 = row0.createCell(2);
		cell0.setCellStyle(cs);
		cell0.setCellValue("岗位名称");
		cell0 = row0.createCell(3);
		cell0.setCellStyle(cs);
		cell0.setCellValue("定员(整数)");
		cell0 = row0.createCell(4);
		cell0.setCellStyle(cs);
		cell0.setCellValue("劳保配备标准（元）");
		int i =1;
		for(Map map:list ){
			Row row = sheet.createRow(i++);
			row.setHeight((short)400);
			CellStyle cs0 = getContentStyle(wb);
			Cell cell = row.createCell(0);
			cell.setCellStyle(cs0);
			cell.setCellValue((String) map.get("project_info_no"));
			int col = 1;
			for (String s : colName1) {
				String []column = s.split("-");
				cell = row.createCell(col++);
				cell.setCellStyle(cs0);
				cell.setCellValue((String) map.get(column[1]));
			}
		}
		return wb;
	}
	public Workbook exportBanlance(String projectInfoNo ,String if_workflow){
		Workbook wb = new HSSFWorkbook();
		CellStyle cs = getTitleStyle(wb);
		Sheet sheet = wb.createSheet("技术方案对比");
		String project_type = OPCommonUtil.getProjectType(projectInfoNo);
		String[] colName = {"施工因素-schema_name","观测系统类型-tech_001", "设计线束-tech_002","满覆盖工作量-tech_003", "实物工作量-tech_004","井炮生产炮数-tech_005","震源生产炮数-tech_006",
				"气枪生产炮数-tech_007","炮数-tech_008", "微测井-tech_009","小折射-tech_010", "接收道数-tech_011","检波器串数-tech_012","覆盖次数-tech_013",
				"道间距-tech_014","炮点距-tech_015", "接收线距-tech_016","炮线距-tech_017","单线道数-tech_018","滚动接收线数-tech_019", "面元-tech_020"};
		if(if_workflow!=null && if_workflow.trim().equals("1")){
			if_workflow = "and if_workflow ='1'";
		}else{
			if_workflow = "";
		}
		StringBuffer sb = new StringBuffer("select rownum row_num ,s.* from (select * from bgp_op_cost_project_schema where bsflag ='0' and project_info_no ='"+projectInfoNo+"' "+if_workflow+" order by schema_name) s");
		List<Map> tech_list = pureDao.queryRecords(sb.toString());
		sheet.setColumnWidth(0, 9000);
		int k = 1;
		for(Map map:tech_list){
			sheet.setColumnWidth(k, 9000);
			k++;
		}
		String cols= "";
		sb = new StringBuffer("");
		for(int i=1;i<=tech_list.size();i++){
			cols += "t"+i+".cost_detail_money cost_detail_money"+i+",";
			sb.append(" left join(select p.template_id,p.node_code,p.cost_name,(select nvl(sum(d.cost_detail_money),0) from bgp_op_cost_project_info pi left join bgp_op_cost_project_detail d on pi.gp_cost_project_id = d.gp_cost_project_id") 
			.append(" where pi.bsflag ='0' and pi.node_code like p.node_code ||'%'  and pi.cost_project_schema_id =(select cost_project_schema_id from(select rownum row_num ,s.* from (select * from bgp_op_cost_project_schema ")
			.append(" where bsflag ='0' and project_info_no ='").append(projectInfoNo).append("' "+if_workflow+" order by schema_name) s) where row_num ="+i+"))cost_detail_money")
			.append(" from bgp_op_cost_project_info p where p.bsflag ='0' and p.cost_project_schema_id =(select cost_project_schema_id from(select rownum row_num ,s.* from (select * from bgp_op_cost_project_schema ")
			.append(" where bsflag ='0' and project_info_no ='").append(projectInfoNo).append("' "+if_workflow+" order by schema_name ) s) where row_num ="+i+")) t"+i+" on t.template_id = t"+i+".template_id and t.node_code = t"+i+".node_code");
		}
		String sql = "select "+cols+" t.cost_name from bgp_op_cost_template t"+sb.toString()+" where t.bsflag = '0' start with t.parent_id ='01' connect by prior t.template_id = t.parent_id order siblings by t.order_code";
		List<Map> list = pureDao.queryRecords(sql);
		int j = 0;
		int length = 21;
		if(project_type!=null && project_type.trim().equals("2")){
			length = 16;
		}
		for(String s:colName){
			if(j>=length) break;
			String title = s.split("-")[0];
			String col = s.split("-")[1];
			Map map = new HashMap();
			map.put("cost_name", title);
			for(int i=0;tech_list!=null && i<tech_list.size();i++){
				Map temp = (Map)tech_list.get(i);
				String row_num = temp==null||temp.get("row_num")==null?"":(String)temp.get("row_num");
				map.put("cost_detail_money"+row_num, temp==null||temp.get(col)==null?"":(String)temp.get(col));
			}
			if(list==null)list = new ArrayList();
			list.add(j++,map);
		}
		Map map1 = new HashMap();
		String s = "工作量类型-spare5";
		String title = s.split("-")[0];
		String col = s.split("-")[1];
		map1.put("cost_name", title);
		for(Map temp :tech_list){
			String row_num = temp==null||temp.get("row_num")==null?"":(String)temp.get("row_num");
			String spare5 = temp==null||temp.get(col)==null?"":(String)temp.get(col);
			if(spare5!=null && spare5.trim().equals("2")){
				spare5 ="实物工作量";
			}else{
				spare5 ="满覆盖工作量";
			}
			map1.put("cost_detail_money"+row_num, spare5);
		}
		list.add(1,map1);
		int i =0;
		for(Map map:list ){
			CellStyle cs0 = getContentStyle(wb);
			if(i==0){
				cs0 = getTitleStyle(wb);
			}
			Row row = sheet.createRow(i++);
			row.setHeight((short)400);
			Cell cell = row.createCell(0);
			cell.setCellStyle(cs0);
			cell.setCellValue((String) map.get("cost_name"));
			int col_num = 1;
			for(Map temp :tech_list){
				cell = row.createCell(col_num++);
				cell.setCellStyle(cs0);
				String row_num = temp==null||temp.get("row_num")==null?"":(String)temp.get("row_num");
				cell.setCellValue((String) map.get("cost_detail_money"+row_num));
			}
		}
		return wb;
	}
	public Workbook exportWarning(String projectInfoNo){
		Workbook wb = new HSSFWorkbook();
		CellStyle cs = getTitleStyle(wb);
		Sheet sheet = wb.createSheet("成本预警");
		String project_type = OPCommonUtil.getProjectType(projectInfoNo);
		String[] colName = {"费用科目-cost_name","计划成本(元)-plan_money", "当前实际成本(元)-actual_money","超出金额(元)-plus_money", "超出比例-radio"};
		StringBuffer sql = new StringBuffer();
		sql.append(" select m.*,nvl(actual_money-plan_money,0)plus_money,case when (nvl(plan_money,0)=0 and nvl(actual_money,0)=0) then '0.00%'  ")
		.append(" when (nvl(plan_money,0)=0 and nvl(actual_money,0)!=0) then '100.00%' when nvl(plan_money,0)!=0 then  ")
		.append(" round(nvl(actual_money-plan_money,0)/nvl(plan_money,0)*100*100)/100.0 ||'%' else '' end radio ")
		.append(" from(select p.cost_name,(select case nvl(m.proc_status,'1') when '3' then round(sum(nvl(t.change_money,0))*100)/100.0 ")
		.append(" else round(sum(nvl(t.plan_money,0))*100)/100.0 end cost_detail_money from view_op_target_cost t ")
		.append(" left join common_busi_wf_middle m on m.business_id ='"+projectInfoNo+"' ")
		.append(" and m.busi_table_name ='BGP_OP_TARGET_PROJECT_INFO' and m.business_type ='5110000004100000014'")
		.append(" where t.project_info_no ='"+projectInfoNo+"' and t.node_code like p.node_code ||'%' group by m.proc_status) plan_money, ")
		.append(" (select sum(nvl(d.cost_detail_money,0)) from bgp_op_target_project_info t  ")
		.append(" left join bgp_op_actual_project_detail d on t.gp_target_project_id = d.gp_target_project_id and d.bsflag ='0' ")
		.append(" where t.bsflag ='0' and t.project_info_no ='"+projectInfoNo+"'  and t.node_code like p.node_code ||'%') actual_money ")
		.append(" from bgp_op_target_project_info p where p.bsflag ='0' and p.project_info_no ='"+projectInfoNo+"' ")
		.append(" start with p.parent_id ='01' connect by prior p.gp_target_project_id = p.parent_id order siblings by p.order_code)m");
		List<Map> list = pureDao.queryRecords(sql.toString());
		sheet.setColumnWidth(0, 9000);
		sheet.setColumnWidth(1, 9000);
		sheet.setColumnWidth(2, 9000);
		sheet.setColumnWidth(3, 9000);
		sheet.setColumnWidth(4, 9000);
		Row row0 = sheet.createRow(0);
		row0.setHeight((short)400);
		Cell cell0 = row0.createCell(0);
		cell0.setCellStyle(cs);
		cell0.setCellValue("费用科目");
		cell0 = row0.createCell(1);
		cell0.setCellStyle(cs);
		cell0.setCellValue("计划成本(元)");
		cell0 = row0.createCell(2);
		cell0.setCellStyle(cs);
		cell0.setCellValue("当前实际成本(元)");
		cell0 = row0.createCell(3);
		cell0.setCellStyle(cs);
		cell0.setCellValue("超出金额(元)");
		cell0 = row0.createCell(4);
		cell0.setCellStyle(cs);
		cell0.setCellValue("超出比例%");
		int i =1;
		for(Map map:list ){
			Row row = sheet.createRow(i++);
			row.setHeight((short)400);
			CellStyle cs0 = getContentStyle(wb);
			int col = 0;
			for (String s : colName) {
				String []column = s.split("-");
				Cell cell = row.createCell(col++);
				cell.setCellStyle(cs0);
				cell.setCellValue((String) map.get(column[1]));
			}
		}
		return wb;
	}
	public Workbook exportRent(String projectInfoNo){
		Workbook wb = new HSSFWorkbook();
		try {
			wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../op/common/deviceExport.xls"));
		} catch (IOException e) {
			e.printStackTrace();
		}
		Sheet sheet = wb.getSheetAt(0);
		sheet.setColumnHidden(12, true);
		Row row1 = sheet.getRow(1);
		Cell cell0 = row1.getCell(11);
		cell0.setCellType(1);
		CellStyle cs = wb.createCellStyle();
		Font font = wb.createFont();
		font.setColor(Font.COLOR_RED);
		font.setFontName("宋体");
		font.setBoldweight(Font.BOLDWEIGHT_BOLD);
		font.setFontHeightInPoints((short)11);
		cs.setFont(font);
		cs.setBorderBottom((short)1);
		cs.setAlignment(CellStyle.ALIGN_CENTER);
		cs.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		cell0.setCellStyle(cs);
		cell0.setCellValue("租赁单价");
		int rows = sheet.getPhysicalNumberOfRows();
		String[] colName = { "dev_acc_id","row_num","dev_name", "team_name","device_count", "dev_model", "self_num", "license_num","plan_start_date","plan_end_date","date_num","taxi_unit",
		"depreciation_value","daily_oil_type","daily_oil","daily_small_oil","single_well_oil","oil_unit_price","vehicle_daily_material","drilling_daily_material","restore_repails" };
		StringBuilder sb = new StringBuilder();
		sb.append("select dr.dev_acc_id ,rownum row_num ,sd.coding_name team_name,dr.dev_name dev_name ,dr.dev_model dev_model ,dr.self_num ,dr.license_num ,dr.device_count,")
		.append(" dr.plan_start_date,dr.plan_end_date ,nvl(dr.plan_end_date-dr.plan_start_date-(-1),0) date_num,dr.taxi_unit ,dr.depreciation_value,")
		.append(" decode(do.daily_oil_type,'2','柴油','1','汽油','') daily_oil_type,do.daily_oil ,do.daily_small_oil,do.single_well_oil,do.oil_unit_price,")
		.append(" dm.vehicle_daily_material,dm.drilling_daily_material,dm.restore_repails from bgp_op_target_device_rent dr ")//left outer join gms_device_account_dui da on dr.dev_acc_id = da.dev_acc_id 
		.append(" left join comm_coding_sort_detail sd  on dr.dev_team = sd.coding_code_id ")
		.append(" left join bgp_op_tartet_device_oil do on dr.dev_acc_id = do.dev_acc_id and do.bsflag ='0' ")
		.append(" left join bgp_op_tartet_device_material dm on dr.dev_acc_id = dm.dev_acc_id and dm.bsflag ='0'")
	    .append(" where dr.bsflag='0' and  dr.project_info_no = '").append(projectInfoNo).append("' and dr.if_change ='0'"); //t.dev_type not like 'S11%'
		List<Map> list = pureDao.queryRecords(sb.toString());
		for (Map map : list) {
			Row row = sheet.createRow(rows++);
			int col = 0;
			for (String s : colName) {
				Cell cell = row.createCell(col++);
				cell.setCellValue((String) map.get(s));
			}
		}
		return wb;
	}
	/*项目目标成本预算导出*/
	public Workbook exportTargetCost(String project_info_no,String key_id){///
		String spare1 = key_id.split(":")[0];
		String spare5 = key_id.split(":")[1];
		Workbook wb = new HSSFWorkbook();
		CellStyle cs = getTitleStyle(wb);
		//导出的列
		String[] colName1 = {"(不可删除)-gp_target_project_id","(不可删除)-detail_target_project_id","费用名称-cost_name","金额-cost_detail_money","计算依据-cost_detail_desc","备注-note"};
		
		StringBuilder sb = new StringBuilder();
		sb.append("select t.* ,d.gp_target_project_id detail_target_project_id,d.cost_detail_money,d.cost_detail_desc,d.spare3 note from bgp_op_target_project_info t")
		.append(" left join bgp_op_target_project_detail d on t.gp_target_project_id = d.gp_target_project_id and d.bsflag ='0'")
		.append(" where t.bsflag ='0' and t.spare1 ='"+spare1+"' and t.spare5 ='"+spare5+"' and t.project_info_no ='")
		.append(project_info_no).append("' order by t.order_code");
		List<Map> list = pureDao.queryRecords(sb.toString());
		Sheet sheet = wb.createSheet();
		sheet.setColumnHidden(0, true);
		sheet.setColumnHidden(1, true);
		sheet.setColumnWidth(2, 5000);
		sheet.setColumnWidth(3, 9000);
		sheet.setColumnWidth(4, 9000);
		sheet.setColumnWidth(5, 12000);
		sheet.setColumnWidth(7, 5000);
		sheet.setColumnWidth(8, 9000);
		sheet.setColumnHidden(6, true);
		Row row0 = sheet.createRow(0);
		row0.setHeight((short)400);
		int col0 = 0;
		for (String s : colName1) {
			String []column = s.split("-");
			Cell cell0 = row0.createCell(col0++);
			cell0.setCellStyle(cs);
			cell0.setCellValue(column[0]);
		}
		Cell cell0 = row0.createCell(++col0);
		cell0.setCellStyle(cs);
		cell0.setCellValue("项目基本情况");
		int i =1;
		for(Map map:list ){
			Row row = sheet.createRow(i++);
			row.setHeight((short)400);
			CellStyle cs0 = getContentStyle(wb);
			int col = 0;
			for (String s : colName1) {
				String []column = s.split("-");
				Cell cell = row.createCell(col++);
				cell.setCellStyle(cs0);
				cell.setCellValue((String) map.get(column[1]));
			}
		}
		//项目基本情况
		String[] colName2 = {"施工地区-work_load","地形-work_situation","物理点-work_factor","公里-work_reason","搬迁距离(km)-work_person","搬迁方式-work_device",
				"施工方法-construct_mean","测网-network","班组-team_no","工期(施工月)-work_days","合同化员工-office_num","市场化员工-market_num","再就业员工-employ_num"
				,"招聘员工-recruit_num","采集仪器-coll_equip","测量仪器-meas_equip","运载车辆-tran_equip","辅助设备-assist_equip"};
		
		sb = new StringBuilder();
		sb.append("select * from bgp_op_target_project_basic t where t.bsflag ='0' and rownum =1 and t.project_info_no ='"+project_info_no+"'");
		Map map = pureDao.queryRecordBySQL(sb.toString());
		i =1;
		for (String s : colName2) {
			Row row = sheet.getRow(i);
			if(row==null){
				row = sheet.createRow(i++);
			}else{
				i++;
			}
			row.setHeight((short)400);
			CellStyle cs0 = getContentStyle(wb);
			String []column = s.split("-");
			Cell cell = row.createCell(6);
			cell.setCellStyle(cs0);
			cell.setCellValue(column[1]);
			cell = row.createCell(7);
			cell.setCellStyle(cs0);
			cell.setCellValue(column[0]);
			cell = row.createCell(8);
			cell.setCellStyle(cs0);
			cell.setCellValue((String) map.get(column[1]));
		}
		String tartget_basic_id = map==null || map.get("tartget_basic_id")==null?"":(String)map.get("tartget_basic_id");//项目基本情况主键
		cell0 = row0.createCell(6);
		cell0.setCellStyle(cs);
		cell0.setCellValue(tartget_basic_id);
		return wb;
	}
	/*大港物探处-测线完成情况表-导出*/
	public Workbook exportLine(String project_info_no,String file_name){///
		Workbook wb = new HSSFWorkbook();
		try {
			wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../pm/lineCompleted/lineC105007.xls"));
		} catch (IOException e) {
			e.printStackTrace();
		}
		Sheet sheet = wb.getSheetAt(0);
		Row row1 = sheet.getRow(0);
		Cell cell0 = row1.getCell(0);
		cell0.setCellValue(file_name);
		
		int rows = sheet.getPhysicalNumberOfRows();
		String[] colName = {"line_completion_id","rownum","line_no","exploration_method","accept_no","cross_direction","wire_direction","cover_num","full_cover_start_end","full_cover","design_shot_num",
				"shot_num","test_shot_num","empty_shot_num","empty_rate","first_qualified_rate","first_waster_rate","second_qualified_rate","second_waster_rate" };
		StringBuilder sb = new StringBuilder();
		sb.append("select rownum, t.* ,t.rowid from bgp_pm_line_completion t where t.bsflag ='0' and t.project_info_no = '").append(project_info_no).append("'");
		List<Map> list = pureDao.queryRecords(sb.toString());
		for (Map map : list) {
			Row row = sheet.createRow(rows++);
			int col = 0;
			for (String s : colName) {
				Cell cell = row.getCell(col)==null ?row.createCell(col):row.getCell(col);
				cell.setCellValue((String) map.get(s));
				CellStyle cs = getContentStyle(wb);
				cell.setCellStyle(cs);
				col++;
			}
		}
		return wb;
	}
	/* excel导入 公共方法*/ 
	public ISrvMsg commImportExcel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String message = "";
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		String import_function = reqDTO.getValue("import_function");
		if(import_function!=null && import_function.trim().equals("importShareHSE")){
			message = importShareHSE(user,fileList);
		}else if(import_function!=null && import_function.trim().equals("importShareLabormon")){
			message = importShareLabormon(user,fileList);
		}else if(import_function!=null && import_function.trim().equals("importRent")){
			message = importRent(user,fileList);
		}else if(import_function!=null && import_function.trim().equals("importTargetCost")){
			message = importTargetCost(user,fileList);
		}else if(import_function!=null && import_function.trim().equals("importLine")){
			message = importLine(user,fileList);
		}
		responseDTO.setValue("message", message);
		responseDTO.setValue("import_function", import_function);
		return responseDTO;
	}
	public String importShareHSE(UserToken user,List<WSFile> fileList){
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String project_info_no = user.getProjectInfoNo();
		String message = "";
		StringBuffer sb = new StringBuffer();
		if(fileList!=null && fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			String file_name = uploadFile.getFilename();
        	String hse_name = "";
        	String hse_count_t = "";
        	String hse_unit = "";
			String type = file_name.substring(file_name.indexOf(".")+1);
			Workbook wb = null;
			Sheet sheet = null;
			if(type!=null && type.equals("xls")){
				try {
					wb = new HSSFWorkbook(new POIFSFileSystem(new ByteArrayInputStream(uploadFile.getFileData())));
				} catch (IOException e) {
					e.printStackTrace();
				}
			}else if(type!=null && type.equals("xlsx")){
				try {
					wb = new XSSFWorkbook(new ByteArrayInputStream(uploadFile.getFileData()));
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			sheet = wb.getSheetAt(0);
			int rowIndex = sheet.getPhysicalNumberOfRows();
	        for(int i = 1;i<rowIndex;i++ ){
	        	Row row = sheet.getRow(i);
        		Cell cell = row.getCell((short)1);
	        	if(cell==null ){
	        		message = message + "第"+(i+1)+"行‘名称’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		hse_name = cell.getStringCellValue();
	        		if(hse_name==null || hse_name.trim().equals("")){
	        			message = message + "第"+(i+1)+"行‘名称’为空;";
	        		}
	        	}
	        	cell = row.getCell((short)2);
        		cell.setCellType(1);
        		hse_count_t = cell.getStringCellValue();
        		if(!hse_count_t.matches("\\d+")){
        			message = message + "第"+(i+1)+"行‘数量’不是数字;";
        		}
	        	cell = row.getCell((short)3);
        		cell.setCellType(1);
        		hse_unit = cell.getStringCellValue();
        		if(!hse_unit.matches("[1-9]+\\d*|\\d+.\\d+")){
        			message = message + "第"+(i+1)+"行‘单价’不是数字;";
        		}
        		String sql = "select t.cost_hse_id from bgp_op_cost_tartet_hse t where t.bsflag ='0' and t.if_change ='0' and t.project_info_no ='"+project_info_no+"' and t.hse_name ='"+hse_name+"' ";
        		Map map = pureDao.queryRecordBySQL(sql);
        		String cost_hse_id = (map==null || map.get("cost_hse_id")==null)?"":(String)map.get("cost_hse_id");
        		if(cost_hse_id!=null && !cost_hse_id.trim().equals("")){
        			sb.append("update bgp_op_cost_tartet_hse t set t.hse_name='").append(hse_name).append("',t.hse_count_t='").append(hse_count_t)
        			.append("',t.hse_unit='").append(hse_unit).append("' where t.cost_hse_id='").append(cost_hse_id).append("';");
        		}else{
        			sb.append("insert into bgp_op_cost_tartet_hse(cost_hse_id,project_info_no,hse_name,hse_count_t,hse_unit,org_id,org_subjection_id,creator,")
        			.append("create_date,updator,update_date,spare4,bsflag,if_change)values((select lower(sys_guid()) from dual),'").append(project_info_no).append("',")
        			.append("'").append(hse_name).append("','").append(hse_count_t).append("','").append(hse_unit).append("','").append(org_id).append("',")
        			.append("'").append(org_subjection_id).append("','").append(user_id).append("',sysdate,'").append(user_id).append("',sysdate,sysdate,'0','0');");
        		}
	        }
		}
		if(message!=null && message.trim().equals("")){
			message = "导入成功!";
			try {
				saveDatasBySql(sb.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return message;
	}
	public String importShareLabormon(UserToken user,List<WSFile> fileList){
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String project_info_no = user.getProjectInfoNo();
		String message = "";
		StringBuffer sb = new StringBuffer();
		if(fileList!=null && fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			String file_name = uploadFile.getFilename();
        	String apply_team = "";
        	String post = "";
        	String person_num = "";
        	String person_money = "";
			String type = file_name.substring(file_name.indexOf(".")+1);
			Workbook wb = null;
			Sheet sheet = null;
			if(type!=null && type.equals("xls")){
				try {
					wb = new HSSFWorkbook(new POIFSFileSystem(new ByteArrayInputStream(uploadFile.getFileData())));
				} catch (IOException e) {
					e.printStackTrace();
				}
			}else if(type!=null && type.equals("xlsx")){
				try {
					wb = new XSSFWorkbook(new ByteArrayInputStream(uploadFile.getFileData()));
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			sheet = wb.getSheetAt(0);
			int rowIndex = sheet.getPhysicalNumberOfRows();
	        for(int i = 1;i<rowIndex;i++ ){
	        	Row row = sheet.getRow(i);
        		Cell cell = row.getCell((short)1);
	        	if(cell==null ){
	        		message = message + "第"+(i+1)+"行‘工序及班组’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		apply_team = cell.getStringCellValue();
	        		if(apply_team==null || apply_team.trim().equals("")){
	        			message = message + "第"+(i+1)+"行‘工序及班组’为空;";
	        		}
	        	}
	        	cell = row.getCell((short)2);
	        	if(cell==null ){
	        		message = message + "第"+(i+1)+"行‘岗位名称’为空;";
	        	}else{
	        		cell.setCellType(1);
	        		post = cell.getStringCellValue();
	        		if(post==null || post.trim().equals("")){
	        			message = message + "第"+(i+1)+"行‘岗位名称’为空;";
	        		}
	        	}
	        	cell = row.getCell((short)3);
        		cell.setCellType(1);
        		person_num = cell.getStringCellValue();
        		if(!person_num.matches("\\d+")){
        			message = message + "第"+(i+1)+"行‘定员’不是数字;";
        		}
	        	cell = row.getCell((short)4);
        		cell.setCellType(1);
        		person_money = cell.getStringCellValue();
        		if(!person_money.matches("[1-9]+\\d*|\\d+.\\d+")){
        			message = message + "第"+(i+1)+"行‘劳保配备标准（元）’不是数字;";
        		}
        		String sql = "select t.cost_labormon_id from bgp_op_cost_tartet_labormon t where t.bsflag ='0' and t.if_change ='0' and t.project_info_no ='"+project_info_no+"' and apply_team ='"+apply_team+"' and post='"+post+"'";
        		Map map = pureDao.queryRecordBySQL(sql);
        		String cost_labormon_id = (map==null || map.get("cost_labormon_id")==null)?"":(String)map.get("cost_labormon_id");
        		if(cost_labormon_id!=null && !cost_labormon_id.trim().equals("")){
        			sb.append("update bgp_op_cost_tartet_labormon t set apply_team='").append(apply_team).append("',post='").append(post).append("',person_num='")
        			.append(person_num).append("',person_money='").append(person_money).append("' where t.cost_labormon_id='").append(cost_labormon_id).append("';");
        		}else{
        			sb.append("insert into bgp_op_cost_tartet_labormon(cost_labormon_id,project_info_no,apply_team,post,person_num,person_money,org_id,org_subjection_id,creator,")
        			.append("create_date,updator,update_date,spare4,bsflag,if_change)values((select lower(sys_guid()) from dual),'").append(project_info_no).append("',")
        			.append("'").append(apply_team).append("','").append(post).append("','").append(person_num).append("','").append(person_money).append("','").append(org_id).append("',")
        			.append("'").append(org_subjection_id).append("','").append(user_id).append("',sysdate,'").append(user_id).append("',sysdate,sysdate,'0','0');");
        		}
	        }
		}
		if(message!=null && message.trim().equals("")){
			message = "导入成功!";
			try {
				saveDatasBySql(sb.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return message;
	}
	public String importRent(UserToken user,List<WSFile> fileList){
		String message = "";
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String projectInfoNo = user.getProjectInfoNo();
		if (fileList != null && fileList.size() > 0) {
			WSFile file = fileList.get(0);
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = new HSSFWorkbook();
			try {
				book = new HSSFWorkbook(is);
			} catch (IOException e1) {
				e1.printStackTrace();
			}
			Sheet sheet = book.getSheetAt(0);
			StringBuilder sql = new StringBuilder("");
			String team_types = "0110000001000000001_测量组,0110000001000000003_表层调查组,0110000001000000008_放线班,0110000001000000010_爆炸班,0110000001000000011_震源组,"+
			"0110000001000000013_修理组,0110000001000000014_警戒组,0110000001000000017_后勤,0110000001000000018_仪器组,0110000001000000019_解释组,"+
			"0110000001000000020_队部,0110000001000000022_炊事班,0110000001000000023_司机组,0110000001000000024_钻井组,0110000001000000027_航海,0110000001000001031_非地震";
			for (int i = 2; i < sheet.getPhysicalNumberOfRows(); i++) {
				Row row = sheet.getRow(i);
				Cell cell = row.getCell(0)==null?row.createCell(0):row.getCell(0);
				String dev_acc_id = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				cell = row.getCell(2)==null?row.createCell(2):row.getCell(2);
				cell.setCellType(1);
				String dev_name = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(dev_name==null || dev_name.trim().equals("")){
					message += "第"+(i+1)+"行设备名称不能空；";
				}
				cell = row.getCell(3)==null?row.createCell(3):row.getCell(3);
				cell.setCellType(1);
				String dev_team = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(dev_team==null || dev_team.trim().equals("") || team_types.indexOf(dev_team)==-1){
					message += "第"+(i+1)+"行班组不存在；";
				}else{
					dev_team = team_types.substring(team_types.indexOf(dev_team)-20, team_types.indexOf(dev_team)-1);
				}
				cell = row.getCell(4)==null?row.createCell(4):row.getCell(4);
				cell.setCellType(1);
				String device_count = cell.getStringCellValue()==null? "":cell.getStringCellValue();
				if(device_count ==null || device_count.trim().equals("") || !device_count.matches("\\d+")){
					message += "第"+(i+1)+"行配备数量不是整数；";
				}
				cell = row.getCell(5)==null?row.createCell(5):row.getCell(5);
				cell.setCellType(1);
				String dev_model = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				cell = row.getCell(6)==null?row.createCell(6):row.getCell(6);
				cell.setCellType(1);
				String self_num = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				cell = row.getCell(7)==null?row.createCell(7):row.getCell(7);
				cell.setCellType(1);
				String license_num = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				cell = row.getCell(8)==null?row.createCell(8):row.getCell(8);
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				String plan_start_date = "";
				if(cell.getCellType()==1){
					plan_start_date = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				}else if(cell.getCellType()==0){
					Calendar calendar = Calendar.getInstance();
					calendar.set(1900, 0, 1);
					cell.setCellType(1);
					int add= Integer.valueOf(cell.getStringCellValue());
					calendar.add(Calendar.DAY_OF_YEAR, add-2);
					plan_start_date = df.format(calendar.getTime());
				}
				plan_start_date = plan_start_date.replaceAll("/", "-");
				try{
					df.parse(plan_start_date);
				}catch(Exception e){
					message += "第"+(i+1)+"行计划进队时间格式不正确；";
				}
				cell = row.getCell(9)==null?row.createCell(9):row.getCell(9);
				String plan_end_date = "";
				if(cell.getCellType()==1){
					plan_end_date = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				}else if(cell.getCellType()==0){
					Calendar calendar = Calendar.getInstance();
					calendar.set(1900, 0, 1);
					cell.setCellType(1);
					int add= Integer.valueOf(cell.getStringCellValue());
					calendar.add(Calendar.DAY_OF_YEAR, add-2);
					plan_end_date = df.format(calendar.getTime());
				}
				plan_end_date = plan_end_date.replaceAll("/", "-");
				try{
					df.parse(plan_end_date);
				}catch(Exception e){
					message += "第"+(i+1)+"行计划离开时间格式不正确；";
				}
				
				cell = row.getCell(11)==null?row.createCell(11):row.getCell(11);
				cell.setCellType(1);
				String taxi_unit = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(taxi_unit ==null || taxi_unit.trim().equals("") || !taxi_unit.matches("[0-9]+.\\d+|\\d+")){
					message += "第"+(i+1)+"行租赁单价不是数值；";
				}
				cell = row.getCell(12)==null?row.createCell(12):row.getCell(12);
				cell.setCellType(1);
				String depreciation_value = "";
				
				cell = row.getCell(13)==null?row.createCell(13):row.getCell(13);
				cell.setCellType(1);
				String daily_oil_type = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				String oil_types = "柴油,汽油";
				if(daily_oil_type == null || daily_oil_type.trim().equals("") || oil_types.indexOf(daily_oil_type)==-1){
					message += "第"+(i+1)+"行日消耗油料类型不存在；";
				}else{
					if(daily_oil_type!=null &&daily_oil_type.trim().equals("柴油")){
						daily_oil_type = "2";
					}else if(daily_oil_type!=null &&daily_oil_type.trim().equals("汽油")){
						daily_oil_type = "1";
					}
				}
				cell = row.getCell(14)==null?row.createCell(14):row.getCell(14);
				cell.setCellType(1);
				String daily_oil = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(daily_oil !=null && !daily_oil.trim().equals("") &&!daily_oil.matches("[0-9]+.\\d+|\\d+")){
					message += "第"+(i+1)+"行日消耗油料（公斤）不是数字；";
				}
				cell = row.getCell(15)==null?row.createCell(15):row.getCell(15);
				cell.setCellType(1);
				String daily_small_oil = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(daily_small_oil !=null && !daily_small_oil.trim().equals("") && !daily_small_oil.matches("[0-9]+.\\d+|\\d+")){
					message += "第"+(i+1)+"行日消耗小油品（元/天）不是数字；";
				}
				cell = row.getCell(16)==null?row.createCell(16):row.getCell(16);
				cell.setCellType(1);
				String single_well_oil = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(single_well_oil !=null && !single_well_oil.trim().equals("") && !single_well_oil.matches("[0-9]+.\\d+|\\d+")){
					message += "第"+(i+1)+"行单井消耗油料（公斤）不是数字；";
				}
				cell = row.getCell(17)==null?row.createCell(17):row.getCell(17);
				cell.setCellType(1);
				String oil_unit_price = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(oil_unit_price !=null && !oil_unit_price.trim().equals("") && !oil_unit_price.matches("[0-9]+.\\d+|\\d+")){
					message += "第"+(i+1)+"行油料单价(元/公斤)不是数字；";
				}
				
				cell = row.getCell(18)==null?row.createCell(18):row.getCell(18);
				cell.setCellType(1);
				String vehicle_daily_material = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(vehicle_daily_material !=null && !vehicle_daily_material.trim().equals("") && !vehicle_daily_material.matches("[0-9]+.\\d+|\\d+")){
					message += "第"+(i+1)+"行车辆日消耗材料不是数字；";
				}
				cell = row.getCell(19)==null?row.createCell(19):row.getCell(19);
				cell.setCellType(1);
				String drilling_daily_material = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(drilling_daily_material !=null && !drilling_daily_material.trim().equals("") && !drilling_daily_material.matches("[0-9]+.\\d+|\\d+")){
					message += "第"+(i+1)+"行钻机日消耗材料不是数字；";
				}
				cell = row.getCell(20)==null?row.createCell(20):row.getCell(20);
				cell.setCellType(1);
				String restore_repails = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if(restore_repails !=null && !restore_repails.trim().equals("") && !restore_repails.matches("[0-9]+.\\d+|\\d+")){
					message += "第"+(i+1)+"行恢复性修理费不是数字；";
				}
				if(dev_acc_id==null || dev_acc_id.trim().equals("")){
					dev_acc_id = java.util.UUID.randomUUID().toString();
					dev_acc_id = dev_acc_id.replaceAll("-", "");
					sql.append("insert into bgp_op_tartet_device_oil(cost_device_id,project_info_no,dev_name,dev_model,plan_start_date,plan_end_date,")
					.append(" daily_oil_type,daily_oil,daily_small_oil,single_well_oil,oil_unit_price,org_id,org_subjection_id,creator,create_date,updator,")
					.append("update_date,bsflag,if_change,dev_team,device_count,dev_acc_id) values((lower(sys_guid())),'"+projectInfoNo+"','"+dev_name+"',")
					.append("'"+dev_model+"',to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'"+daily_oil_type+"',")
					.append("'"+daily_oil+"','"+daily_small_oil+"','"+single_well_oil+"','"+oil_unit_price+"','"+org_id+"','"+org_subjection_id+"',")
					.append(" '"+user_id+"',sysdate,'"+user_id+"',sysdate,'0','0','"+dev_team+"','"+device_count+"','"+dev_acc_id+"');");
										
					sql.append("insert into bgp_op_tartet_device_depre(target_depre_id,project_info_no,dev_name,dev_model,dev_team,device_count,plan_start_date,")
					.append(" plan_end_date,org_id,org_subjection_id,creator,create_date,updator,update_date,bsflag,if_change,record_type,dev_acc_id,asset_value,")
					.append(" depreciation_value)values((lower(sys_guid())),'"+projectInfoNo+"','"+dev_name+"','"+dev_model+"','"+dev_team+"','"+device_count+"',")
					.append(" to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'"+org_id+"','"+org_subjection_id+"',")
					.append(" '"+user_id+"',sysdate,'"+user_id+"',sysdate,'0','0','0','"+dev_acc_id+"','','"+depreciation_value+"');");
										
					sql.append("insert into bgp_op_tartet_device_material(target_material_id,project_info_no,dev_name,dev_model,dev_team,device_count,plan_start_date,plan_end_date,")
					.append(" org_id,org_subjection_id,creator,create_date,updator,update_date,bsflag,if_change,dev_acc_id,vehicle_daily_material,drilling_daily_material,")
					.append(" restore_repails)values((lower(sys_guid())),'"+projectInfoNo+"','"+dev_name+"','"+dev_model+"','"+dev_team+"','"+device_count+"',")
					.append(" to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'"+org_id+"','"+org_subjection_id+"','"+user_id+"',")
					.append(" sysdate,'"+user_id+"',sysdate,'0','0','"+dev_acc_id+"','"+vehicle_daily_material+"','"+drilling_daily_material+"','"+restore_repails+"');");
					
					sql.append("insert into bgp_op_target_device_rent(target_rent_id,project_info_no,dev_name,dev_model,dev_team,device_count,plan_start_date,plan_end_date,")
					.append(" org_id,org_subjection_id,creator,create_date,updator,update_date,bsflag,if_change,dev_acc_id,taxi_unit)")
					.append(" values((lower(sys_guid())),'"+projectInfoNo+"','"+dev_name+"','"+dev_model+"','"+dev_team+"','"+device_count+"',")
					.append(" to_date('"+plan_start_date+"','yyyy-MM-dd'),to_date('"+plan_end_date+"','yyyy-MM-dd'),'"+org_id+"','"+org_subjection_id+"','"+user_id+"',")
					.append(" sysdate,'"+user_id+"',sysdate,'0','0','"+dev_acc_id+"','"+taxi_unit+"');");
				}else{
					sql.append(" update bgp_op_tartet_device_oil t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.device_count='"+device_count+"',")
					.append(" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),")
					.append(" t.daily_oil='"+daily_oil+"',t.daily_small_oil='"+daily_small_oil+"',t.single_well_oil='"+single_well_oil+"',")
					.append(" t.oil_unit_price='"+oil_unit_price+"',t.dev_team='"+dev_team+"',t.daily_oil_type='"+daily_oil_type+"' ")
					.append(" where t.dev_acc_id='"+dev_acc_id+"';");
								
					sql.append("update bgp_op_tartet_device_depre t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.device_count='"+device_count+"',")
					.append(" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),")
					.append(" t.dev_team='"+dev_team+"',t.asset_value='',t.depreciation_value='"+depreciation_value+"' where t.dev_acc_id='"+dev_acc_id+"';");
								
					sql.append("update bgp_op_tartet_device_material t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.device_count='"+device_count+"',")
					.append(" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),")
					.append(" t.dev_team='"+dev_team+"' ,t.vehicle_daily_material='"+vehicle_daily_material+"',t.drilling_daily_material='"+drilling_daily_material+"',")
					.append(" t.restore_repails='"+restore_repails+"' where t.dev_acc_id='"+dev_acc_id+"';");
					
					sql.append("update bgp_op_target_device_rent t set t.dev_name='"+dev_name+"',t.dev_model='"+dev_model+"',t.device_count='"+device_count+"',")
					.append(" t.plan_start_date=to_date('"+plan_start_date+"','yyyy-MM-dd'),t.plan_end_date=to_date('"+plan_end_date+"','yyyy-MM-dd'),")
					.append(" t.dev_team='"+dev_team+"' ,t.taxi_unit='"+taxi_unit+"' where t.dev_acc_id='"+dev_acc_id+"';");
				}
			}
			if((message==null || message.trim().equals(""))&& !sql.toString().trim().equals("")){
				message = "导入成功!";
				jdbcTemplate.batchUpdate(sql.toString().split(";"));
			}
		}
		return message;
	}
	/*导入项目目标成本预算*/
	public String importTargetCost(UserToken user,List<WSFile> fileList){
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserName();
		String project_info_no = user.getProjectInfoNo();
		String message = "";
		StringBuffer sb = new StringBuffer();
		if(fileList!=null && fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			String file_name = uploadFile.getFilename();
        	String gp_target_project_id = "";
        	String detail_target_project_id = "";
        	String cost_detail_money = "";
        	String cost_detail_desc = "";
        	String spare3 = "";
			String type = file_name.substring(file_name.indexOf(".")+1);
			Workbook wb = null;
			Sheet sheet = null;
			if(type!=null && type.equals("xls")){
				try {
					wb = new HSSFWorkbook(new POIFSFileSystem(new ByteArrayInputStream(uploadFile.getFileData())));
				} catch (IOException e) {
					e.printStackTrace();
				}
			}else if(type!=null && type.equals("xlsx")){
				try {
					wb = new XSSFWorkbook(new ByteArrayInputStream(uploadFile.getFileData()));
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			sheet = wb.getSheetAt(0);
			int rowIndex = sheet.getPhysicalNumberOfRows();
	        for(int i = 1;i<rowIndex && i<=9;i++ ){
	        	Row row = sheet.getRow(i);
        		Cell cell = row.getCell((short)0)==null ?row.createCell(0):row.getCell((short)0);
        		cell.setCellType(1);
        		gp_target_project_id = cell.getStringCellValue();
        		
        		cell = row.getCell((short)1);
        		cell.setCellType(1);
        		detail_target_project_id = cell.getStringCellValue();
        		
        		cell = row.getCell((short)3);
        		cell.setCellType(1);
        		cost_detail_money = cell.getStringCellValue();
        		if(cost_detail_money!=null&&!cost_detail_money.equals("")&&!cost_detail_money.matches("\\d+")){
        			message = message + "第"+(i+1)+"行‘金额’不是数字;";
        		}
        		cell = row.getCell((short)4);
        		cell.setCellType(1);
        		cost_detail_desc = cell.getStringCellValue();
	        	cell = row.getCell((short)5);
        		cell.setCellType(1);
        		spare3 = cell.getStringCellValue();
        		//TODO
        		String sql = "select * from bgp_op_target_project_detail t where t.bsflag ='0' and rownum =1 and t.gp_target_project_id ='"+gp_target_project_id+"'";
        		Map map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sql);
        		if(map==null){
        			sb.append("insert into bgp_op_target_project_detail(target_project_detail_id,gp_target_project_id,cost_detail_money,cost_detail_desc,org_id,org_subjection_id,")
                    .append("creator,create_date,updator,modifi_date,bsflag,spare3,spare4)values(lower(sys_guid()),'"+gp_target_project_id+"','"+cost_detail_money+"',")
                    .append("'"+cost_detail_desc+"','"+org_id+"','"+org_subjection_id+"','"+user_id+"',sysdate,'"+user_id+"',sysdate,'0','"+spare3+"',sysdate);");//'"++"',
        		}else{
        			sb.append("update bgp_op_target_project_detail t set cost_detail_money='").append(cost_detail_money).append("',cost_detail_desc='").append(cost_detail_desc).append("',")
        			.append("spare3='").append(spare3).append("' where t.gp_target_project_id ='").append(detail_target_project_id).append("';");
        		}
	        }
	        Row row0 = sheet.getRow(0);
    		Cell cell0 = row0.getCell((short)6);
    		cell0.setCellType(1);
    		String tartget_basic_id = cell0.getStringCellValue();
    		String[] colName2 = {"施工地区-work_load","地形-work_situation","物理点-work_factor","公里-work_reason","搬迁距离(km)-work_person","搬迁方式-work_device",
    				"施工方法-construct_mean","测网-network","班组-team_no","工期(施工月)-work_days","合同化员工-office_num","市场化员工-market_num","再就业员工-employ_num",
    				"招聘员工-recruit_num","采集仪器-coll_equip","测量仪器-meas_equip","运载车辆-tran_equip","辅助设备-assist_equip"};
	        String sql = "select * from bgp_op_target_project_basic t where t.bsflag ='0' and rownum =1 and t.tartget_basic_id = '"+tartget_basic_id+"'";
    		Map map = BeanFactory.getPureJdbcDAO().queryRecordBySQL(sql);
    		if(map==null){
    			String insert_type = "";
    			String insert_data = "";
    			int i =1;
    			for(String s : colName2){
    				Row row = sheet.getRow(i++);
    	    		Cell cell = row.getCell((short)6);
    	    		cell.setCellType(1);
    	    		String column = cell.getStringCellValue();
    	    		insert_type = insert_type+column+",";
    	    		
    	    		cell = row.getCell((short)8);
    	    		cell.setCellType(1);
    	    		String data = cell.getStringCellValue();
    	    		insert_data = insert_data +"'"+ data+"',";
    	    		
    			}
    			sb.append("insert into bgp_op_target_project_basic(tartget_basic_id,"+insert_type+"bsflag,spare4,update_date,updator,create_date,creator,org_subjection_id,org_id,project_info_no)")
                .append("values(lower(sys_guid()),"+insert_data+" '0',sysdate,sysdate,'"+user.getUserName()+"',sysdate,'"+user.getUserName()+"','"+user.getOrgSubjectionId()+"','"+user.getOrgId()+"');");//'"++"',
    		}else{
    			String update_data = "";
    			int i =1;
    			for(String s : colName2){
    				Row row = sheet.getRow(i++);
    	    		Cell cell = row.getCell((short)6);
    	    		cell.setCellType(1);
    	    		String column = cell.getStringCellValue();
    	    		
    	    		cell = row.getCell((short)8);
    	    		cell.setCellType(1);
    	    		String data = cell.getStringCellValue();
    	    		
    	    		update_data = update_data + column+"='"+data+"',";
    	    		
    			}
    			sb.append("update bgp_op_target_project_basic t set "+update_data+" bsflag='0' where tartget_basic_id ='"+tartget_basic_id+"';");//'"++"',
    		}
		}
		if(message!=null && message.trim().equals("")){
			message = "导入成功!";
			try {
				saveDatasBySql(sb.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return message;
	}
	/*导入大港物探处-测线完成情况表*/
	public String importLine(UserToken user,List<WSFile> fileList){
		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserName();
		String project_info_no = user.getProjectInfoNo();
		String message = "";
		StringBuffer sb = new StringBuffer("delete from bgp_pm_line_completion t where t.project_info_no ='"+project_info_no+"';");
		if(fileList!=null && fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			String file_name = uploadFile.getFilename();
        	String gp_target_project_id = "";
        	String detail_target_project_id = "";
        	String cost_detail_money = "";
        	String cost_detail_desc = "";
        	String spare3 = "";
			String type = file_name.substring(file_name.indexOf(".")+1);
			Workbook wb = null;
			Sheet sheet = null;
			if(type!=null && type.equals("xls")){
				try {
					wb = new HSSFWorkbook(new POIFSFileSystem(new ByteArrayInputStream(uploadFile.getFileData())));
				} catch (IOException e) {
					e.printStackTrace();
				}
			}else if(type!=null && type.equals("xlsx")){
				try {
					wb = new XSSFWorkbook(new ByteArrayInputStream(uploadFile.getFileData()));
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			sheet = wb.getSheetAt(0);
			int rowIndex = sheet.getPhysicalNumberOfRows();
	        for(int i = 3; i < rowIndex; i++ ){
	        	Row row = sheet.getRow(i);
	        	String cols = "line_no,exploration_method,accept_no,cross_direction,wire_direction,cover_num,full_cover_start_end,full_cover,design_shot_num,"+
				"shot_num,test_shot_num,empty_shot_num,empty_rate,first_qualified_rate,first_waster_rate,second_qualified_rate,second_waster_rate";
	        	String[] colName = cols.split(",");
	        	String values = "";
	        	short colIndex = 2;
	        	for(String name : colName){
	        		Cell cell = row.getCell(colIndex);
	        		int cell_type = cell.getCellType();
	        		if(cell_type == 2){
	        			cell.setCellType(0);
	        			double value = cell.getNumericCellValue();
	        			value = Math.round(value*100)/100.0;
		        		values = values +"'"+value+"',";
	        		}else{
	        			cell.setCellType(1);
	        			String value = cell.getStringCellValue();
		        		values = values +"'"+value+"',";
	        		}
	        		colIndex++;
	        	}
	        	sb.append("insert into bgp_pm_line_completion(line_completion_id,project_info_no,"+cols+",creator,creator_date,updator,modifi_date,bsflag)")
                .append("values(lower(sys_guid()),'"+project_info_no+"',"+values+" '"+user_id+"',sysdate,'"+user_id+"',sysdate,'0');");
	        }
		}
		if(message!=null && message.trim().equals("")){
			message = "导入成功!";
			try {
				saveDatasBySql(sb.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return message;
	}
	private CellStyle getTitleStyle(Workbook wb){
		Font font = wb.createFont();
		font.setColor(Font.COLOR_RED);
		CellStyle cs = wb.createCellStyle();
		cs.setFont(font);
		cs.setAlignment(CellStyle.ALIGN_CENTER);
		cs.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		return cs;
	}
	private CellStyle getContentStyle(Workbook wb){
		Font font = wb.createFont();
		font.setColor(Font.COLOR_RED);
		CellStyle cs = wb.createCellStyle();
		cs.setWrapText(true);
		cs.setAlignment(CellStyle.ALIGN_CENTER);
		cs.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		return cs;
	}
	/**
	 * eps树 --> 东方--物探处--项目
	 * author xiaoxia 
	 * date 2013-11-27
	 * @param reqDTO
	 */
	public ISrvMsg getProjectTreeEps(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		String node = reqDTO.getValue("node");
		String checked = reqDTO.getValue("checked");
		String leaf = reqDTO.getValue("leaf");
		String org_id = user.getOrgId();
		if(org_id ==null){
			org_id ="";
		}
		String org_subjection_id = user.getSubOrgIDofAffordOrg();
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null || project_info_no.trim().equals("")){
			project_info_no = user.getProjectInfoNo();
		}
		
		StringBuffer sb  = new StringBuffer();
		JSONArray json = null;
		if(node==null || node.trim().equals("") || node.trim().equals("C105")){
			sb = new StringBuffer();
			sb.append("select wtc.org_subjection_id id ,wtc.org_abbreviation name ,wtc.org_id ,'' project_info_no ,'true' eps ")
			.append(" from bgp_comm_org_wtc wtc")
			.append(" where wtc.bsflag = '0' and wtc.org_subjection_id like '"+org_subjection_id+"%' order by wtc.order_num");

			List root = BeanFactory.getPureJdbcDAO().queryRecords(sb.toString());
			List list = new ArrayList();
			if(checked!=null && checked.trim().equals("true")){
				for(int i =0;i<root.size() ;i++){
					Map map = (Map)root.get(i);
					if(org_subjection_id!=null && org_subjection_id.equals("C105") && leaf!=null && leaf.equals("true")){
						map.put("checked" ,false);
						map.put("leaf" ,true);
					}
					if(org_subjection_id!=null && !org_subjection_id.equals("C105")){
						map.put("expanded" ,true);
					}
					list.add(map);
				}
			}else{
				for(int i =0;i<root.size() ;i++){
					Map map = (Map)root.get(i);
					if(org_subjection_id!=null && org_subjection_id.equals("C105") && leaf!=null && leaf.equals("true")){
						map.put("leaf" ,true);
					}
					if(org_subjection_id!=null && !org_subjection_id.equals("C105")){
						map.put("expanded" ,true);
					}
					list.add(map);
				}
			}
			json = JSONArray.fromObject(list);
		}else{
			sb = new StringBuffer();
			sb.append("select distinct t.project_info_no id,t.project_name name ,d.org_id ,d.org_subjection_id project_info_no ,'false' eps")
			.append(" from gp_task_project t")
			.append(" join gp_task_project_dynamic d on t.project_info_no = d.project_info_no ")
			.append(" and d.bsflag ='0' and t.exploration_method = d.exploration_method ")
			//.append(" join comm_org_subjection o on d.org_id = o.org_id and o.bsflag ='0'")//现在项目可能有多个施工队伍，所以org_id字段存储的是多个队伍
			.append(" join comm_coding_sort_detail s on t.manage_org = s.coding_code_id and s.bsflag = '0' ")
			.append(" where t.bsflag ='0'")
			.append(" and d.org_subjection_id like'").append(node).append("%'");
			
			List root = BeanFactory.getPureJdbcDAO().queryRecords(sb.toString());
			List list = new ArrayList();
			if(checked!=null && checked.trim().equals("true")){
				for(int i =0;i<root.size() ;i++){
					Map map = (Map)root.get(i);
					map.put("checked" ,false);
					map.put("leaf" ,true);
					list.add(map);
				}
			}else{
				for(int i =0;i<root.size() ;i++){
					Map map = (Map)root.get(i);
					map.put("leaf" ,true);
					list.add(map);
				}
			}
			json = JSONArray.fromObject(list);
		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		if (json == null) {
			msg.setValue("json", "[]");
		} else {
			msg.setValue("json", json.toString());
		}
		return msg;
	}
	public static void main(String args[]) throws IOException {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		Calendar calendar = Calendar.getInstance();
		calendar.set(1900, 0, 1);
		calendar.add(Calendar.DAY_OF_YEAR, 25569-2);
		System.out.println(df.format(calendar.getTime()));
		calendar.getTime();
		String str = "{采集直接费用11372194.8200}/{项目工作量73.7100}";
		str.replaceAll("/[^\\d\\\\+\\\\-\\\\*\\\\/(){}]/g", "");
		System.out.println(str.replaceAll("[^\\d\\\\+\\\\-\\\\*\\\\/(){}\\.]", ""));
		
		System.out.println((4251 +4550 +4392 +4350 +4328 +4343 +4340 +4335 +4300 +4270 +4200 +4123 +4043 +4025*2 + 3966*3)/18.0);
		
		Calendar cal = Calendar.getInstance();//n为推迟的周数，1本周，-1向前推迟一周，2下周，依次类推
		String month_end = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
		String month_start = month_end.substring(0, 7)+ "-01";
		
		int  day_of_week = cal.get(Calendar.DAY_OF_WEEK)-1;
		 
		if(day_of_week == 0){
			int n = -1;
			cal.add(Calendar.DATE, (n+1)*7);
			cal.set(Calendar.DAY_OF_WEEK,Calendar.SUNDAY);
			String week_sunday = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
				
			cal.add(Calendar.DATE, n*7);
			cal.set(Calendar.DAY_OF_WEEK,Calendar.MONDAY);
			String week_monday = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
		}else{
			int n = 0;
			cal.add(Calendar.DATE, n*7);
			cal.set(Calendar.DAY_OF_WEEK,Calendar.MONDAY);
			String week_monday = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
			
			cal.add(Calendar.DATE, (n+1)*7);
			cal.set(Calendar.DAY_OF_WEEK,Calendar.SUNDAY);
			String week_sunday = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
		}
	}

}
