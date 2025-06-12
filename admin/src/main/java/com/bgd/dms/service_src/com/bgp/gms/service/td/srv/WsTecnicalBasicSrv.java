package com.bgp.gms.service.td.srv;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.op.srv.OPCostSrv;
import com.bgp.mcs.service.common.excelIE.util.ExcelExceptionHandler;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;


public class WsTecnicalBasicSrv extends BaseService {
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	/**
	 * 技术管理--保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveTdDoc(ISrvMsg reqDTO) throws Exception {
		Map map = reqDTO.toMap();
		String project_info_no = (String) map.get("project_info_no");
		String tecnicalId = (String)reqDTO.getValue("tecnical_id");
		String businessType = reqDTO.getValue("business_type");	
		String fileAbbr = reqDTO.getValue("file_abbr");	
		String docType = reqDTO.getValue("doc_type");	
		String parent_file_id = reqDTO.getValue("parent_file_id");	
		String businessType_s = reqDTO.getValue("businessType_s");	
		
		UserToken user = reqDTO.getUserToken();
		
		if(docType!=null){
			map.put("doc_type", docType);
		}
	
		map.put("bsflag", "0");
		map.put("updator_id", user.getEmpId());
		map.put("modifi_date", new Date());
		map.put("project_info_no",project_info_no);
		if (tecnicalId == null || "".equals(tecnicalId)) {
			//如果为空 则添加创建人
			map.put("creator_id", user.getEmpId());
			map.put("create_date", new Date());
		}
		
		Serializable tecnical_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_WS_TECNICAL_BASIC");
		
		// 保存文件
		String fileName = "";
		String fileUcmId = "";
		String fileType = "";
		boolean fileExist = false;
		String fieldName="";
		String oldFile ="";
		
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList.size()!=0){
			for(int i=0;i<fileList.size();i++){
				WSFile uploadFile = fileList.get(i);
				fileName = uploadFile.getFilename();
				fileType = uploadFile.getType();
				fieldName=uploadFile.getKey();
				byte[] uploadData = uploadFile.getFileData();
				fileUcmId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
				oldFile = reqDTO.getValue("pk_"+fieldName)==null?"":reqDTO.getValue("pk_"+fieldName);
//				System.out.println("*******************oldFile****"+oldFile);
				
				//主键存不为空修改，为空新增
				if(oldFile!=null && !"".equals(oldFile)){
					//删除旧的文件记录
					myUcm.deleteFile(oldFile);
					String sql = "update bgp_doc_gms_file set bsflag = '1' where ucm_id = '" + oldFile + "'";
					RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
					JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
					jdbcTemplate.execute(sql);
				}
				Map fileMap = new HashMap();
				fileMap.put("relation_id",tecnical_id.toString());
				fileMap.put("business_type",businessType);
				fileMap.put("file_abbr",fileAbbr);
				fileMap.put("doc_file_type",fieldName==""?"":fieldName.substring(0,19));
				fileMap.put("parent_file_id",parent_file_id);
				
			//	fileMap.put("doc_type", docType);
				fileMap.put("file_name", fileName);
				fileMap.put("ucm_id", fileUcmId);
				fileMap.put("file_type", fileType);
				fileMap.put("project_info_no", project_info_no);
				fileMap.put("bsflag", "0");
				fileMap.put("is_file", "1");
				fileMap.put("creator_id", user.getEmpId());
				fileMap.put("create_date", new Date());
				fileMap.put("org_id", user.getOrgId());
				fileMap.put("org_subjection_id", user.getOrgSubjectionId());
				
				String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fileMap,"bgp_doc_gms_file").toString();
				myUcm.docVersion(doc_pk_id, "1.0", fileUcmId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
				myUcm.docLog(doc_pk_id, "1.0", 1, fileUcmId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
			}
		}
		
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		responseMsg.setValue("message", "success");
		responseMsg.setValue("businessType_s", businessType_s);
		responseMsg.setValue("businessType", businessType);
		responseMsg.setValue("fileAbbr", fileAbbr);
		
		if(""!=(String) map.get("isSingle")&&null!=(String) map.get("isSingle")){
			responseMsg.setValue("isSingle",(String) map.get("isSingle"));
		}
		return responseMsg;
	}
	
	
	/**
	 * 技术管理--vsp处理解释保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveVspDoc(ISrvMsg reqDTO) throws Exception {
		Map map = reqDTO.toMap();
		String project_info_no = (String) map.get("project_info_no");
		String id_All= "";
		String table_name="";
		String businessType = reqDTO.getValue("business_type");	
		String fileAbbr = reqDTO.getValue("file_abbr");	
		String docType = reqDTO.getValue("doc_type");	
		String parent_file_id = reqDTO.getValue("parent_file_id");	 

		String spare1 = reqDTO.getValue("spare1");	
	 
	 
		String s_id = reqDTO.getValue("s_id");	
		String s_name = reqDTO.getValue("s_name");	
		String a_s_id = reqDTO.getValue("a_s_id");	
		String a_s_name = reqDTO.getValue("a_s_name");	
		String outsourcing = reqDTO.getValue("outsourcing");	
		UserToken user = reqDTO.getUserToken();
		
		if(docType!=null){
			map.put("doc_type", docType);
		}
	
		map.put("bsflag", "0");
		map.put("updator_id", user.getEmpId());
		map.put("modifi_date", new Date());
		map.put("project_info_no",project_info_no);
		
		if(businessType.equals("0110000061200000001") || businessType.equals("0110000061200000006")){//处理解释任务书
			if(businessType.equals("0110000061200000006")){
				map.put("CREATOR_ID", user.getEmpId());
				map.put("CREATE_DATE", new Date());
			}else{
				if(spare1!=null){ 
					map.put("CREATOR_ID", user.getEmpId());
					map.put("CREATE_DATE", new Date());
				}else{
					id_All=(String)reqDTO.getValue("commitments_id"); 
					map.put("commitments_id",id_All);
				}
			}
			table_name="GP_WS_VSP_COMMITMENTS";
			 
			if(outsourcing.equals("1")){
				map.put("todeal_people_s",s_id);
				map.put("todeal_people",s_name);
				map.put("explain_people_s",a_s_id);
				map.put("explain_people",a_s_name);
				map.put("outsourcing_personnel","");
			}else{
				map.put("todeal_people_s","");
				map.put("todeal_people","");
				map.put("explain_people_s","");
				map.put("explain_people","");
				
				map.put("t_start_time","");
				map.put("t_end_time","");
				map.put("e_start_time","");
				map.put("e_end_time","");
				 
			}
			
		}
		
		if(businessType.equals("0110000061200000002") || businessType.equals("0110000061200000007")){ //处理解释状态
			id_All=(String)reqDTO.getValue("cstatus_id"); 
			table_name="GP_WS_VSP_CSTATUS"; 
			map.put("cstatus_id",id_All);
			
		}
		
		if(businessType.equals("0110000061200000003") || businessType.equals("0110000061200000008")){ //内部审核
			id_All=(String)reqDTO.getValue("audit_id"); 
			table_name="GP_WS_VSP_AUDIT"; 
			map.put("audit_id",id_All);
			
		}
		
		if(businessType.equals("0110000061200000004") || businessType.equals("0110000061200000009")){ //甲方资料归档
			id_All=(String)reqDTO.getValue("data_id"); 
			table_name="GP_WS_VSP_DATA"; 
			map.put("data_id",id_All);
			
		}
		
		if(businessType.equals("0110000061200000005") || businessType.equals("0110000061200000010")){ //内部资料归档
			id_All=(String)reqDTO.getValue("idata_id"); 
			table_name="GP_WS_VSP_INTERNADATA"; 
			map.put("idata_id",id_All);
			
		}
		Serializable tecnical_id ="";
		if(businessType.equals("0110000061200000006")){
			  tecnical_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,table_name);
		}else{
			if(spare1!=null){ 
				 tecnical_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,table_name);
			}else{
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,table_name);
			}
		}
		// 保存文件
		String fileName = "";
		String fileUcmId = "";
		String fileType = "";
		boolean fileExist = false;
		String fieldName="";
		String oldFile ="";
		
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList.size()!=0){
			for(int i=0;i<fileList.size();i++){
				WSFile uploadFile = fileList.get(i);
				fileName = uploadFile.getFilename();
				fileType = uploadFile.getType();
				fieldName=uploadFile.getKey();
				byte[] uploadData = uploadFile.getFileData();
				fileUcmId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
				oldFile = reqDTO.getValue("pk_"+fieldName)==null?"":reqDTO.getValue("pk_"+fieldName);
//				System.out.println("*******************oldFile****"+oldFile);
				
				//主键存不为空修改，为空新增
				if(oldFile!=null && !"".equals(oldFile)){
					//删除旧的文件记录
					myUcm.deleteFile(oldFile);
					String sql = "update bgp_doc_gms_file set bsflag = '1' where ucm_id = '" + oldFile + "'";
					RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
					JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
					jdbcTemplate.execute(sql);
				}
				Map fileMap = new HashMap();				
				if(businessType.equals("0110000061200000006")){ //微地震处理解释任务书
					fileMap.put("relation_id",tecnical_id.toString());
				}else{
					if(spare1!=null){ 
						fileMap.put("relation_id",tecnical_id.toString());
					}else{
						fileMap.put("relation_id",id_All);
					}
				}
				fileMap.put("business_type",businessType);
				fileMap.put("file_abbr",fileAbbr);
				fileMap.put("doc_file_type",fieldName==""?"":fieldName.substring(0,19));
				fileMap.put("parent_file_id",parent_file_id);

				if(businessType.equals("0110000061200000002") || businessType.equals("0110000061200000007") ){ //处理解释状态针对不同两个附件
					String sub_fname=fieldName.substring(20,fieldName.length());
					if(sub_fname.equals("0") || sub_fname.equals("2")){
						fileMap.put("checkout_status", "0");
					}else{
						fileMap.put("checkout_status", "1");
					}
				}
			//	fileMap.put("doc_type", docType);
				fileMap.put("file_name", fileName);
				fileMap.put("ucm_id", fileUcmId);
				fileMap.put("file_type", fileType);
				fileMap.put("project_info_no", project_info_no);
				fileMap.put("bsflag", "0");
				fileMap.put("is_file", "1");
				fileMap.put("creator_id", user.getEmpId());
				fileMap.put("create_date", new Date());
				fileMap.put("org_id", user.getOrgId());
				fileMap.put("org_subjection_id", user.getOrgSubjectionId());
				
				String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fileMap,"bgp_doc_gms_file").toString();
				myUcm.docVersion(doc_pk_id, "1.0", fileUcmId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
				myUcm.docLog(doc_pk_id, "1.0", 1, fileUcmId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
			}
		}
		
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		responseMsg.setValue("message", "success");
 
		responseMsg.setValue("doc_type", businessType);
		responseMsg.setValue("fileAbbr", fileAbbr);
		
		if(""!=(String) map.get("isSingle")&&null!=(String) map.get("isSingle")){
			responseMsg.setValue("isSingle",(String) map.get("isSingle"));
		}
		return responseMsg;
	}
	
	
	

	/**
	 * 技术管理--vsp处理解释内部资料归档
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveVspIdata(ISrvMsg reqDTO) throws Exception {
		Map map = reqDTO.toMap();
	 
		String project_info_no = reqDTO.getValue("project_info_no");	
		String [] project_info_no_sub = project_info_no.split(",");
		
		String table_name="";
		String parent_file_id="";
		int data_length = Integer.parseInt(reqDTO.getValue("data_length"));	
		String businessType = reqDTO.getValue("business_type");	
		String fileAbbr = reqDTO.getValue("file_abbr");	
		String docType = reqDTO.getValue("doc_type");	
		String upload_status = reqDTO.getValue("upload_status");	
		int p_size = Integer.parseInt(reqDTO.getValue("p_size"));	
		String idata_id = reqDTO.getValue("idata_id");	
		String [] idata_id_sub = idata_id.split(",");
		UserToken user = reqDTO.getUserToken();
		
		if(p_size>0){ 
			
			for(int e=0;e<data_length;e++){
				
				String sql_pid="select f.file_id ,f.project_info_no from bgp_doc_gms_file f where f.bsflag='0' and f.is_file='0' and f.project_info_no ='"+project_info_no_sub[e]+"'  and f.file_abbr='"+fileAbbr+"'";
			 
				List p_list = BeanFactory.getQueryJdbcDAO().queryRecords(sql_pid); 
				MyUcm ucm = new MyUcm();
				if(!p_list.isEmpty()){  
						Map p_map = (Map)p_list.get(0);
						  parent_file_id = (String)p_map.get("fileId");
				}else{
					 parent_file_id ="01A8DE665EA27111111111111111101";
					 fileAbbr="JZVSPPROJECT";
				}
						if(docType!=null){
							map.put("doc_type", docType);
						}
						map.put("bsflag", "0");
						map.put("upload_status",upload_status);
						map.put("updator_id", user.getEmpId());
						map.put("modifi_date", new Date());
						map.put("project_info_no",project_info_no_sub[e]);
						 
						if(businessType.equals("0110000061200000005") || businessType.equals("0110000061200000010") ){ //甲方资料归档
							table_name="GP_WS_VSP_INTERNADATA"; 
							map.put("idata_id",idata_id_sub[e] );
							
						}
					    BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,table_name);
 
		
					
					// 保存文件
					String fileName = "";
					String fileUcmId = "";
					String fileType = "";
					boolean fileExist = false;
					String fieldName="";
					String oldFile ="";
					
					MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
					List<WSFile> fileList = mqMsg.getFiles();
					if(fileList.size()!=0){
						for(int i=0;i<fileList.size();i++){
							WSFile uploadFile = fileList.get(i);
							fileName = uploadFile.getFilename();
							fileType = uploadFile.getType();
							fieldName=uploadFile.getKey();
							byte[] uploadData = uploadFile.getFileData();
							fileUcmId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
							oldFile = reqDTO.getValue("pk_"+fieldName)==null?"":reqDTO.getValue("pk_"+fieldName);
			//				System.out.println("*******************oldFile****"+oldFile);
							
							//主键存不为空修改，为空新增
							if(oldFile!=null && !"".equals(oldFile)){
								//删除旧的文件记录
								myUcm.deleteFile(oldFile);
								String sql = "update bgp_doc_gms_file set bsflag = '1' where ucm_id = '" + oldFile + "'";
								RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
								JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
								jdbcTemplate.execute(sql);
							}
							Map fileMap = new HashMap();				
			
							fileMap.put("relation_id",idata_id_sub[e] );
							fileMap.put("business_type",businessType);
							fileMap.put("file_abbr",fileAbbr);
							fileMap.put("doc_file_type",fieldName==""?"":fieldName.substring(0,19));
							fileMap.put("parent_file_id",parent_file_id);
			 
							fileMap.put("file_name", fileName);
							fileMap.put("ucm_id", fileUcmId);
							fileMap.put("file_type", fileType);
							fileMap.put("project_info_no", project_info_no_sub[e]);
							fileMap.put("bsflag", "0");
							fileMap.put("is_file", "1");
							fileMap.put("creator_id", user.getEmpId());
							fileMap.put("create_date", new Date());
							fileMap.put("org_id", user.getOrgId());
							fileMap.put("org_subjection_id", user.getOrgSubjectionId());
							
							String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fileMap,"bgp_doc_gms_file").toString();
							myUcm.docVersion(doc_pk_id, "1.0", fileUcmId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
							myUcm.docLog(doc_pk_id, "1.0", 1, fileUcmId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
						}
					}
					
					
			}
		
		}
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		responseMsg.setValue("message", "success");
 
		responseMsg.setValue("doc_type", businessType);
		responseMsg.setValue("fileAbbr", fileAbbr);
		
		if(""!=(String) map.get("isSingle")&&null!=(String) map.get("isSingle")){
			responseMsg.setValue("isSingle",(String) map.get("isSingle"));
		}
		return responseMsg;
	}
	
	
	
	
	
	/**
	 * 技术管理--技术设计删除
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteTdDoc(ISrvMsg reqDTO) throws Exception {
		String ids = reqDTO.getValue("ids");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		String[] tecIds = ids.split(",");
		
		String sql = "update gp_ws_tecnical_basic set bsflag = '1' where tecnical_id in ( ";
		for (int i = 0; i < tecIds.length; i++) {
			sql += "'"+tecIds[i] +"',";
		}
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		jdbcDao.getJdbcTemplate().execute(sql);
		
		
		String update = "update bgp_doc_gms_file set bsflag = '1' where relation_id in ( ";
		for (int i = 0; i < tecIds.length; i++) {
			update += "'"+tecIds[i] +"',";
		}
		update = update.substring(0, update.lastIndexOf(","));
		update += ")";
		jdbcDao.getJdbcTemplate().execute(update);
		
		String str = "select t.ucm_id from bgp_doc_gms_file t where t.relation_id in  ( ";
		for (int i = 0; i < tecIds.length; i++) {
			str += "'"+tecIds[i] +"',";
		}
		str = str.substring(0, str.lastIndexOf(","));
		str += ")";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(str);
		
		MyUcm ucm = new MyUcm();
		if(!list.isEmpty()){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				String ucmId = (String)map.get("ucmId");
				ucm.deleteFile(ucmId);
			}
		}
		
		return responseDTO;
	}
	
	
	/**
	 * 技术管理--技术设计删除
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteTdDocJz(ISrvMsg reqDTO) throws Exception {
		String ids = reqDTO.getValue("ids");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
	 
		
		String sql = "update gp_ws_tecnical_basic set bsflag = '1' where tecnical_id = ";
		 
			sql += "'"+ids +"'";
	 
		jdbcDao.getJdbcTemplate().execute(sql);
		
		
		String update = "update bgp_doc_gms_file set bsflag = '1' where relation_id in = ";
		update += "'"+ids +"'";
		 
		jdbcDao.getJdbcTemplate().execute(update);
		
		String str = "select t.ucm_id from bgp_doc_gms_file t where t.relation_id in  = ";
		str += "'"+ids +"'";
		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(str);
		
		MyUcm ucm = new MyUcm();
		if(!list.isEmpty()){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				String ucmId = (String)map.get("ucmId");
				ucm.deleteFile(ucmId);
			}
		}
		
		
		return responseDTO;
	}
	
	/**
	 * 综合物化探工区设计边框Excel导入
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveWorkDesignExcel(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = getExcelDataByWSFile(file);
			}
			//遍历dataList，操作数据库
			for(int i=0;i<dataList.size();i++){
				Map dataMap = (Map) dataList.get(i);
					Map kqMap = new HashMap();
					kqMap.put("title", dataMap.get("title"));
					kqMap.put("north_location", dataMap.get("north_location"));
					kqMap.put("south_location", dataMap.get("south_location"));
					kqMap.put("bsflag", "0");
					kqMap.put("creator_id", user.getEmpId());
					kqMap.put("create_date", new Date());
					kqMap.put("updator_id", user.getEmpId());
					kqMap.put("modifi_date", new Date());
					kqMap.put("org_id", user.getOrgId());
					kqMap.put("org_subjection_id",user.getOrgSubjectionId());
					kqMap.put("project_info_no",user.getProjectInfoNo());
					kqMap.put("business_type",reqDTO.getValue("business_type"));
					jdbcDao.saveOrUpdateEntity(kqMap,"GP_WS_TECNICAL_BASIC");
				}
			}
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		return reqMsg;
	}
	
	/**
	 * 通过wsfile 解析excel 获取excel中的信息
	 * 
	 * @param IN:file wsFile文件、columnList xml配置的excel导入配置信息
	 * 
	 * @param Out:List 将excel解析的数据集放置到list中
	 * 
	 */
	private List getExcelDataByWSFile(WSFile file) throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")||file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = new HSSFWorkbook(is); //HSSFWorkbook针对xls，XSSFWorkbook针对xlsx
			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();//总行数
			for(int i=1;i<rows;i++){//循环行数
				Map mapColumnInfoIn = new HashMap();
				Row row = sheet0.getRow(i);
				int columns = row.getPhysicalNumberOfCells();//获得列数
				NumberFormat nf = NumberFormat.getInstance();
				nf.setGroupingUsed(false);//true时的格式：1,234,567,890
				
				for(int m=0;m<columns;m++){
					Cell cell = sheet0.getRow(i).getCell(m);
					int cellType = cell.getCellType();
					switch (cellType) {
					case 1://
						mapColumnInfoIn.put(m,cell.getStringCellValue());
						break;
					case 0:
						mapColumnInfoIn.put(m,nf.format(row.getCell(m).getNumericCellValue()));
						break;
					}
				}
				Map map = new HashMap();
				map.put("title",mapColumnInfoIn.get(0));
				map.put("north_location",mapColumnInfoIn.get(1));
				map.put("south_location",mapColumnInfoIn.get(2));
				System.out.println(map);
				dataList.add(map);
			}
		}
		return dataList;
	}
	
	/**
	 * 工区设计边框 获得单号ID
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg submitTecnicalPlan(ISrvMsg reqDTO) throws Exception{
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String businessType = reqDTO.getValue("businessType");
		String sql="select t.plan_id from gp_ws_tecnical_plan t where t.project_info_no='"+projectInfoNo+"' and t.business_type='"+businessType+"' and t.bsflag='0'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		String planId = "";
		if(null!=map){
			planId = (String) map.get("planId"); 
		}else{
			UserToken user = reqDTO.getUserToken();
			Map mapDetail = new HashMap();	
			mapDetail.put("bsflag", "0");
			mapDetail.put("project_info_no", projectInfoNo);
			mapDetail.put("business_type", businessType);
			mapDetail.put("creator_id", user.getEmpId());
			mapDetail.put("create_date", new Date());
			mapDetail.put("updator_id", user.getEmpId());
			mapDetail.put("modifi_date", new Date());
			
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"gp_ws_tecnical_plan");
			planId = id.toString();
		}
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		reqMsg.setValue("planId",planId);
		return reqMsg;
	}
	
	
	/**
	 * 工区设计边框||工区完成边框导出excel
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg exportWorkExcel(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String businessType = reqDTO.getValue("businessType");
		Workbook wb=null;
		if("5110000004100000092".equals(businessType)){//工区设计边框
			wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../td/workDesignDoc/wt/workDesignList.xls"));
		}
		if("5110000057000000012".equals(businessType)){//工区完成边框
			wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../td/doc/workResultDoc/wt/workResultList.xls"));
		}
		Sheet sheet = wb.getSheetAt(0);
		int rows = 1;//sheet.getPhysicalNumberOfRows();
		String[] colName = {"title","north_location","south_location"};
		StringBuilder subsql = new StringBuilder(); 
		subsql.append("select t.title,t.north_location,t.south_location,p.project_name ");
		subsql.append("from gp_ws_tecnical_basic t left join gp_task_project p on t.project_info_no=p.project_info_no ");
		subsql.append("where t.project_info_no = '").append(projectInfoNo).append("'");
		subsql.append("and t.bsflag = '0'  and t.business_type = '").append(businessType).append("'");
		List<Map> list =  BeanFactory.getPureJdbcDAO().queryRecords(subsql.toString());
		for (Map map:list) {
			Row row = sheet.createRow(rows++);
			int col = 0;
			for (String s:colName) {
				Cell cell = row.createCell(col++);
				cell.setCellValue((String) map.get(s));
			}
		}
		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename(list.get(0).get("project_name")+".xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;
	}
}
