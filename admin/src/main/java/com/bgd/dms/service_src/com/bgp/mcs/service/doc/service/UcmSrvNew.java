package com.bgp.mcs.service.doc.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.datatype.XMLGregorianCalendar;

import oracle.stellent.ridc.IdcClientException;
import oracle.stellent.ridc.model.DataObject;
import oracle.stellent.ridc.model.DataResultSet;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.op.util.OPCommonUtil;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WorkFlowBean;
import com.bgp.mcs.service.pm.service.bimap.BiMapUtils;
import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.p6.activity.ActivityWSBean;
import com.bgp.mcs.service.pm.service.p6.util.SynUtils;
import com.bgp.mcs.service.pm.service.projwbsdate.SynWbsDateUtils;
import com.bgp.mcs.service.risk.service.RiskSrv;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.webapp.upload.WebPathUtil;
import com.primavera.ws.p6.activity.Activity;
import com.sun.xml.fastinfoset.Decoder;

@SuppressWarnings( { "rawtypes", "unused" })
public class UcmSrvNew extends BaseService {
	
	public UcmSrvNew(){
		log = LogFactory.getLogger(UcmSrvNew.class);
	}

	
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	IBaseDao baseDao = BeanFactory.getBaseDao();

	static String topParentFolder;
	static String topFolderAbbr;
	static String templateId;
	static String fileNumberFormat;
	
	private static RADJdbcDao radjdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	static{
		ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
		Map parentFolderMap = radjdbcDao.queryRecordBySQL("select f.file_id,f.file_abbr from bgp_doc_gms_file f where f.bsflag = '0' and f.parent_file_id is null and f.project_info_no is null and f.is_file = '0'");
	    topParentFolder = parentFolderMap.get("file_id").toString();
	    topFolderAbbr = parentFolderMap.get("file_abbr").toString();
	    templateId = cfgHd.getSingleNodeValue("//doc/template_id");
	    fileNumberFormat = cfgHd.getSingleNodeValue("//doc/number_format");
	}
	
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");

	/**
	 * 上传修改文件公用方法
	 * @param reqDTO    文件id:file_id, 项目id：project_info_no,ucmid,fileName,文件目录缩写：folder_id
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg commonSaveOrUpdateFile(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String business_info = reqDTO.getValue("business_info");
		String business_type = reqDTO.getValue("business_type");

		UserToken user = reqDTO.getUserToken();
		String file_id = reqDTO.getValue("file_id");
		String project_info_no = reqDTO.getValue("project_info_no");
		if(project_info_no==null||"".equals(project_info_no)){
			project_info_no = user.getProjectInfoNo();			
		}
		String ucm_old = reqDTO.getValue("ucmId");
		String fileName_old = reqDTO.getValue("fileName");
		String folder_id = reqDTO.getValue("folder_id");

		String getFileId="select FILE_ID from BGP_DOC_GMS_FILE where BSFLAG='0' and IS_FILE<>'1' and PROJECT_INFO_NO='"+project_info_no+"' and FILE_ABBR='"+folder_id+"'";
		Map fileIdMap = jdbcDao.queryRecordBySQL(getFileId);
		String folderFileId="";
		if(fileIdMap!=null){
			folderFileId = (String)fileIdMap.get("file_id");
		}
		String ucmDocId = "";
		String uploadFileName="";
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

		String org_id = user.getOrgId();
		String org_subjection_id = user.getOrgSubjectionId();
		String user_id = user.getUserId();
		String qc_id = radjdbcDao.generateUUID();
		//如果文件id为空，新增

		if(file_id==null||"".equals(file_id)){
			String  file_id2 = radjdbcDao.generateUUID();

			StringBuffer sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id ,parent_file_id,file_number)");
			sbSql.append("values('").append(file_id2).append("','").append(uploadFileName).append("','").append(ucmDocId).append("','").append(qc_id).append("','").append(project_info_no).append("','0',sysdate,'")
			.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append(org_id).append("','").append(org_subjection_id).append("','").append(folderFileId).append("','')");
			jdbcTemplate.execute(sbSql.toString());
			myUcm.docVersion(file_id2, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);
			myUcm.docLog(file_id2, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);
			
			
		}else{
			if(!"".equals(ucmDocId)){
				ucm_old = ucmDocId;
			}
			if(!"".equals(uploadFileName)){
				fileName_old = uploadFileName;
			}
			 String updateSql="update BGP_DOC_GMS_FILE set FILE_NAME='"+fileName_old+"'," +
			 		"UCM_ID='"+ucm_old+"',PARENT_FILE_ID='"+folderFileId+"',CREATOR_ID='"+user_id+"',ORG_SUBJECTION_ID='"+org_subjection_id+"',ORG_ID='"+org_id+"'," +
			 		"MODIFI_DATE=sysdate where FILE_ID='"+file_id+"'";
			jdbcTemplate.execute(updateSql);
			//myUcm.docVersion(file_id, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);
			//myUcm.docLog(file_id, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),uploadFileName);
			
		}
	
		msg.setValue("folder_id", folder_id);
		msg.setValue("business_type", business_type);
		msg.setValue("business_info", business_info);


		return msg;
	}
	
	public ISrvMsg commonDeleteFile(ISrvMsg reqDTO) throws Exception{
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String param = reqDTO.getValue("param");
		String plansql = "update BGP_DOC_GMS_FILE set BSFLAG='1' where FILE_ID='"+param+"'";
		jdbcTemplate.execute(plansql);
		msg.setValue("returnCode","0");
		return msg;

	}
	
	/**
	 * 上传文档到ucm,从本地服务器上传
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg uploadFileNew(ISrvMsg isrvmsg) throws Exception {
		System.out.println("uploadFile !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ucmDocId = "";
		String last_number = (int) System.currentTimeMillis()+"";
		UserToken user = isrvmsg.getUserToken();
		
		SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyyMMdd");
		String multiFlag = isrvmsg.getValue("isMultiProject") != null?isrvmsg.getValue("isMultiProject"):"";
		String parentFolder = isrvmsg.getValue("folder_id") != null?isrvmsg.getValue("folder_id"):"";
		String docNumber = isrvmsg.getValue("doc_number") != null?isrvmsg.getValue("doc_number"):"";
		//多项目
		if(multiFlag != ""){
			if(parentFolder == ""){
				//parentFolder是多项目的最顶层目录
				parentFolder = topParentFolder;
				if(docNumber  == ""){
					System.out.println("topFolderAbbr is:"+topFolderAbbr);
					docNumber = "bgp-"+simpleFormat.format(new Date())+"-"+last_number.trim().substring(last_number.length()-4, last_number.length());
				}
			}
		}
		//单项目
		else if(multiFlag == ""){
			if(parentFolder == ""){
				//parentFolder是该项目的最顶层目录
				Map parentFolderMap = jdbcDao.queryRecordBySQL("select b.file_id,b.file_abbr FROM bgp_doc_gms_file b WHERE b.project_info_no = '"+user.getProjectInfoNo()+"' and b.bsflag='0' and b.is_file='0' and b.parent_file_id is null and b.ucm_id is null");
				parentFolder = parentFolderMap.get("file_id").toString();
				String folderAbbr = parentFolderMap.get("file_abbr").toString();
				if(docNumber  == ""){
					docNumber = "bgp-"+folderAbbr+"-"+simpleFormat.format(new Date())+"-"+last_number.trim().substring(last_number.length()-4, last_number.length());
				}
			}
		}
		
		String docName = isrvmsg.getValue("doc_name") != null?isrvmsg.getValue("doc_name"):"";
		String docType = isrvmsg.getValue("doc_type") != null?isrvmsg.getValue("doc_type"):"";
		String docImportance = isrvmsg.getValue("doc_importance") != null?isrvmsg.getValue("doc_importance"):"";	
		String docKeyword = isrvmsg.getValue("doc_keyword") != null?isrvmsg.getValue("doc_keyword"):"";
		String docTemplate = isrvmsg.getValue("doc_template")!= null?isrvmsg.getValue("doc_template"):"";
		String docScore = isrvmsg.getValue("doc_score");	
		String docBrief = isrvmsg.getValue("doc_brief") != null?isrvmsg.getValue("doc_brief"):"";	
		String relationId = isrvmsg.getValue("relation_id")!= null?isrvmsg.getValue("relation_id"):"";	
		String quality_control = isrvmsg.getValue("qualityControl");
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		//如果不选择文件，则不执行上传文档到ucm的操作	to_date('"+today+"','YYYY-MM-DD HH24-mi-ss'
		//从本地服务器获取文档
		byte[] fileBytes = null;
		String uploadFileName = isrvmsg.getValue("upload_file_name") != null?isrvmsg.getValue("upload_file_name"):"";
		if(uploadFileName != ""){
			fileBytes = MyUcm.getFileBytes(uploadFileName, user);
		}
		if(fileBytes != null && fileBytes.length > 0){
			ucmDocId = myUcm.uploadFile(uploadFileName, fileBytes);
		}
		
		//文件成功上传到UCM中后,才向数据库里写入相应数据
		if(ucmDocId != "" && ucmDocId != null){
			String FileId = jdbcDao.generateUUID();	
			StringBuffer sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,file_number,file_type,parent_file_id,ucm_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,doc_importance,doc_keyword,doc_template,doc_score,doc_brief,relation_id");
			sbSql.append(",is_attachment)");
			sbSql.append(" values('"+FileId+"','"+docName+"','"+docNumber+"','"+docType+"','"+parentFolder+"','"+ucmDocId+"',"); 
			
			//多项目,项目编号填空
			if(multiFlag != ""){
				sbSql.append("'',");
			}else{
				sbSql.append("'"+user.getProjectInfoNo()+"',");
			}
			sbSql.append("'0',to_date('"+format.format(new Date())+"','YYYY-MM-DD HH24-mi-ss'),'"+user.getUserId()+"',to_date('"+format.format(new Date())+"','YYYY-MM-DD HH24-mi-ss'),'"+user.getUserId()+"','1','"+user.getCodeAffordOrgID()+"','"+user.getSubOrgIDofAffordOrg()+"','"+docImportance+"','"+docKeyword+"','"+docTemplate+"',");
			sbSql.append("'"+docScore+"','"+docBrief+"'");
			if(relationId != ""&&relationId !=null){
				sbSql.append(",'"+relationId+"','1')");
			}else{
				sbSql.append(","+null+",'0')");
			}
			
			jdbcTemplate.execute(sbSql.toString());
			
			myUcm.docVersion(FileId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),docName);
			myUcm.docLog(FileId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),docName);
			
			responseDTO.setValue("ucmDocId", ucmDocId);
			responseDTO.setValue("uploadfolderid", relationId);
			responseDTO.setValue("qualityControl",quality_control);
		}
		return responseDTO;

	}
	
	/**
	 * 上传新版本的文档
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg uploadNewVersionFileNew(ISrvMsg isrvmsg) throws Exception {
		String docNumber = isrvmsg.getValue("doc_number") != null?isrvmsg.getValue("doc_number"):"";
		String docName = isrvmsg.getValue("doc_name") != null?isrvmsg.getValue("doc_name"):"";
		String docType = isrvmsg.getValue("doc_type") != null?isrvmsg.getValue("doc_type"):"";
		String docImportance = isrvmsg.getValue("doc_importance") != null?isrvmsg.getValue("doc_importance"):"";	
		String docKeyword = isrvmsg.getValue("doc_keyword") != null?isrvmsg.getValue("doc_keyword"):"";
		String docTemplate = isrvmsg.getValue("doc_template");
		String docScore = isrvmsg.getValue("doc_score");	
		String docBrief = isrvmsg.getValue("doc_brief") != null?isrvmsg.getValue("doc_brief"):"";	

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ucmDocId = "";
		UserToken user = isrvmsg.getUserToken();
		
		String fileID = isrvmsg.getValue("file_id");
		//查询一下版本表中file_id为fileID的记录有几条
		String querySql = "select count(v.bgp_doc_file_version_id) as versioncount from bgp_doc_file_version v where v.bsflag='0' and v.file_id ='"+fileID+"'";
		Map map=jdbcDao.queryRecordBySQL(querySql);
		String docVersion = (Integer.parseInt(map.get("versioncount").toString())+1)+".0";
		
		Map<String, Object> paramMap = new HashMap<String,Object>();
		Map<String, Object> versionMap = new HashMap<String,Object>();
		//选择文件，更新基本信息,上传文档到ucm的操作
		
		//从本地服务器获取文档
		byte[] fileBytes = null;
		String uploadFileName = isrvmsg.getValue("upload_file_name") != null?isrvmsg.getValue("upload_file_name"):"";
		if(uploadFileName != ""){
			fileBytes = MyUcm.getFileBytes(uploadFileName, user);
		}
		if(fileBytes != null && fileBytes.length > 0){
			ucmDocId = myUcm.uploadFile(uploadFileName, fileBytes);
			paramMap.put("file_id",fileID);
			paramMap.put("file_name",docName);
			paramMap.put("ucm_id",ucmDocId);
			paramMap.put("doc_importance",docImportance);
			paramMap.put("doc_keyword",docKeyword);
			paramMap.put("doc_score",docScore);
			paramMap.put("doc_template",docTemplate);
			paramMap.put("doc_brief",docBrief);
			paramMap.put("doc_number",docNumber);
			paramMap.put("doc_type",docType);
			paramMap.put("bsflag", "0");
			paramMap.put("modifi_date", new Date());
			paramMap.put("updator_id", user.getUserId());
			paramMap.put("org_id", user.getCodeAffordOrgID());
			paramMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_gms_file");
			
			versionMap.put("file_id", fileID);
			versionMap.put("file_version", docVersion);
			versionMap.put("version_ucm_id", ucmDocId);
			versionMap.put("file_version_title", docName);
			versionMap.put("bsflag", "0");
			versionMap.put("create_date", new Date());
			versionMap.put("modifi_date", new Date());
			versionMap.put("creator_id", user.getUserId());
			versionMap.put("updator_id", user.getUserId());
			versionMap.put("org_id", user.getCodeAffordOrgID());
			versionMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			jdbcDao.saveOrUpdateEntity(versionMap, "bgp_doc_file_version");
			
			//写入日志
			if(ucmDocId != ""&&ucmDocId !=null){
				myUcm.docLog(fileID, docVersion, 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),docName);
			}
		}else{
			//不选文档，只更新基本信息
			paramMap.put("file_id", fileID);
			paramMap.put("file_name",docName);
			paramMap.put("doc_importance",docImportance);
			paramMap.put("doc_keyword",docKeyword);
			paramMap.put("doc_score",docScore);
			paramMap.put("doc_template",docTemplate);
			paramMap.put("doc_brief",docBrief);
			paramMap.put("doc_number",docNumber);
			paramMap.put("doc_type",docType);
			paramMap.put("file_version", docVersion);
			paramMap.put("bsflag", "0");
			paramMap.put("modifi_date", new Date());
			paramMap.put("updator_id", user.getUserId());
			paramMap.put("org_id", user.getCodeAffordOrgID());
			paramMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_gms_file");
		}
		
		responseDTO.setValue("verdionUcmId", ucmDocId);
		responseDTO.setValue("verdionFileId", fileID);
		return responseDTO;

	}
}
