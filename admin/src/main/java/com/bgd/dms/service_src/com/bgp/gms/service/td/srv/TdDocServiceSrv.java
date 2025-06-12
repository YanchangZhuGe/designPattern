package com.bgp.gms.service.td.srv;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.omg.CORBA.Request;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.rm.em.util.PropertiesUtil;
import com.bgp.gms.service.td.pojo.BgpDocTdFileCheck;
import com.bgp.gms.service.td.pojo.BgpDocTdFileCheckData;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * project: 东方物探生产管理系统
 * 
 * creator: 林彦博
 * 
 * creator time:2012-9-18
 * 
 * description:
 * 
 */
public class TdDocServiceSrv extends BaseService {
 
	private static final String[] remindMonth = { "0110000061000000004-测量仪器月检", "0110000061000000002-仪器月检","0110000061000000007-小折射仪器月检","0110000061000000008-震源月检","0110000061000001008-气枪月检" };
	private static final String[] remindYear = { "0110000061000000003-测量仪器年检", "0110000061000000001-仪器年检","0110000061000000010-SMT测试仪年检", "0110000061000000005-震源年检","0110000061000000006-小折射仪器年检"};
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO(); 
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	IBaseDao baseDao = BeanFactory.getBaseDao();
	
	static String topParentFolder;
	static String topFolderAbbr;
	static String templateId;
	static String fileNumberFormat;
	
	static{
		RADJdbcDao staticJdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
		Map parentFolderMap = staticJdbcDao.queryRecordBySQL("select f.file_id,f.file_abbr from bgp_doc_gms_file f where f.bsflag = '0' and f.parent_file_id is null and f.project_info_no is null and f.is_file = '0'");
	    topParentFolder = parentFolderMap.get("file_id").toString();
	    topFolderAbbr = parentFolderMap.get("file_abbr").toString();
	    templateId = cfgHd.getSingleNodeValue("//doc/template_id");
	    fileNumberFormat = cfgHd.getSingleNodeValue("//doc/number_format");
	}
	
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	
	
	
	public ISrvMsg saveProjectTdDoc(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		UserToken user = reqDTO.getUserToken();
		String documentId = "";
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String creatorId = reqDTO.getValue("creatorId");
		String parentFileId = reqDTO.getValue("parentFileId");
		String docType = reqDTO.getValue("docType");	
		String uploadDate = reqDTO.getValue("uploadDate");
		String fileName = reqDTO.getValue("fileName");
		String ucmId = reqDTO.getValue("ucmId");
		String fileId = reqDTO.getValue("fileId");
		
		String receiveOrg = reqDTO.getValue("receiveOrg");
		String receiveId = reqDTO.getValue("receiveId");
		String uploadId = reqDTO.getValue("uploadId");
		String docFileType = reqDTO.getValue("docFileType");
		
		Map mapDetail = new HashMap();
		
		mapDetail.put("project_info_no", projectInfoNo);
		mapDetail.put("creator_id", creatorId);
		mapDetail.put("parent_file_id", parentFileId);
		mapDetail.put("doc_type", docType);
		mapDetail.put("receive_id", receiveId);
		mapDetail.put("upload_id", uploadId);
		mapDetail.put("receive_org", receiveOrg);
		mapDetail.put("doc_file_type", docFileType);
		mapDetail.put("upload_date", uploadDate);
		mapDetail.put("create_date", new Date());
		mapDetail.put("modifi_date", new Date());
		mapDetail.put("file_name", fileName);
		mapDetail.put("bsflag", "0");
		mapDetail.put("is_file", "1");
		mapDetail.put("org_id", user.getOrgId());
		mapDetail.put("org_subjection_id", user.getOrgSubjectionId());
		//主键存不为空修改，为空新增
		if(fileId!=null && !"".equals(fileId)){
			mapDetail.put("file_id", fileId);
		}
		
		byte[] fileBytes = null;
		String uploadFileName = reqDTO.getValue("upload_file_name") != null?reqDTO.getValue("upload_file_name"):"";
		if(uploadFileName != ""){
			fileBytes = MyUcm.getFileBytes(uploadFileName, user);
		}
		if(fileBytes != null && fileBytes.length > 0){
			documentId = myUcm.uploadFile(uploadFileName, fileBytes);
			mapDetail.put("ucm_id", documentId);
			
			if(ucmId!=null && !"".equals(ucmId)){
				myUcm.deleteFile(ucmId); 
				String update =" update bgp_doc_gms_file set bsflag='1' where ucm_id='"+ucmId+"'";
				jdbcDao.getJdbcTemplate().update(update);
			}
		}
		
	/*	MyUcm ucm = new MyUcm();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		String documentId = "";
		if(fileList!= null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			documentId = ucm.uploadFile(fs.getFilename(),fs.getFileData());
			mapDetail.put("ucm_id", documentId);
			
			if(ucmId!=null && !"".equals(ucmId)){
				ucm.deleteFile(ucmId);
				
				String update =" update bgp_doc_gms_file set bsflag='1' where ucm_id='"+ucmId+"'";
				jdbcDao.getJdbcTemplate().update(update);
			}
			
		}*/
		
		
		String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_doc_gms_file").toString();
				
		myUcm.docVersion(doc_pk_id, "1.0", documentId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
		myUcm.docLog(doc_pk_id, "1.0", 1, documentId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
		
		responseDTO.setValue("codingCodeId", docType);			
		responseDTO.setValue("parentFileId", parentFileId);			
		return responseDTO;
	}
	/**
	 * 获取要编辑的文档信息 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getEditDocInfo(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getEditDocInfo !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		UserToken user = isrvmsg.getUserToken();
		String file_id = isrvmsg.getValue("fileId");
		String fileAbbr = isrvmsg.getValue("fileAbbr");
		System.out.println("The fileId in the getEditDcoInfo is:"+file_id);
        
		Map docInfoMap = new HashMap();
		
        //获取文档表主键
        String queryDocId="select t.file_abbr,t.doc_type, t.file_id,t.file_name,t.file_number,t.file_type,t.doc_importance,t.doc_keyword,t.doc_score,t.doc_template,t.doc_brief,t.ucm_id from bgp_doc_gms_file t where t.file_id = '"+file_id+"' and bsflag='0'";
        Map map=jdbcDao.queryRecordBySQL(queryDocId);
        if(map!=null){
        	String original_doc_name = myUcm.getDocTitle((String)map.get("ucm_id"));
        	docInfoMap.put("orig_doc_name", original_doc_name);
        	docInfoMap.put("file_id", (String) map.get("file_id"));
        	docInfoMap.put("doc_name", (String) map.get("file_name"));
        	docInfoMap.put("doc_importance", (String) map.get("doc_importance"));
        	docInfoMap.put("doc_keyword", (String) map.get("doc_keyword"));
        	docInfoMap.put("doc_score", (String) map.get("doc_score"));
        	docInfoMap.put("doc_template", (String) map.get("doc_template"));
        	docInfoMap.put("doc_brief", (String) map.get("doc_brief"));
        	docInfoMap.put("doc_number", (String) map.get("file_number"));
        	docInfoMap.put("doc_type", (String) map.get("file_type"));
        	docInfoMap.put("doc_type_s", (String) map.get("doc_type"));
        	docInfoMap.put("file_abbr", (String) map.get("file_abbr"));
        }
		responseDTO.setValue("editFileId", file_id); 
		responseDTO.setValue("docInfoMap", docInfoMap); 
		List<Map> values = queryDocValueInfo(file_id);
		if(values!=null && !values.isEmpty()){
			Map valuesMap = new HashMap();
			for(Map valMap:values){
				valuesMap.put("doc_"+valMap.get("doc_gms_field"), valMap.get("doc_gms_value"));
			}
			responseDTO.setValue("valuesMap", valuesMap); 
		}
		  
		return responseDTO;

	}
	
	//施工设计保存新
	public ISrvMsg saveTdDoc(ISrvMsg isrvmsg) throws Exception {
 
		System.out.println("uploadFile !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ucmDocId = "";
		String last_number = (int) System.currentTimeMillis()+"";
		UserToken user = isrvmsg.getUserToken();
		
		SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyyMMdd");
 
		String parentFolder = isrvmsg.getValue("file_id") != null?isrvmsg.getValue("file_id"):"";
		String fileAbbr = isrvmsg.getValue("file_abbr") != null?isrvmsg.getValue("file_abbr"):"";
		String doc_type_s = isrvmsg.getValue("doc_type_s") != null?isrvmsg.getValue("doc_type_s"):"";
		String parent_file_id = isrvmsg.getValue("parent_file_id") != null?isrvmsg.getValue("parent_file_id"):"";
			//多项目 
			//if(parentFolder.equals("null")){
				//parentFolder是该项目的最顶层目录 
				//Map parentFolderMap = jdbcDao.queryRecordBySQL("select b.file_id,b.file_abbr FROM bgp_doc_gms_file b WHERE b.project_info_no = '"+user.getProjectInfoNo()+"' and b.bsflag='0' and b.is_file='0' and b.parent_file_id is null and b.ucm_id is null");
			//	Map parentFolderMap = jdbcDao.queryRecordBySQL("select f.file_id, f.file_abbr  from bgp_doc_gms_file f where f.bsflag='0' and f.is_file='0' and f.project_info_no='"+user.getProjectInfoNo()+"' and f.file_abbr='"+fileAbbr+"'");
			//	parentFolder = parentFolderMap.get("file_id").toString();
			//	String folderAbbr = parentFolderMap.get("file_abbr").toString();
				 
			//}
		 
		
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
		 SimpleDateFormat formats = new SimpleDateFormat("yyyy-MM-dd");
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
		System.out.println("***********ucmDocId"+ucmDocId);
		//文件成功上传到UCM中后,才向数据库里写入相应数据
		if(ucmDocId != "" && ucmDocId != null){
			String FileId = jdbcDao.generateUUID();	
			StringBuffer sbSql = new StringBuffer("Insert into bgp_doc_gms_file(upload_date,file_abbr,file_id,file_name,file_type,parent_file_id,ucm_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,doc_importance,doc_keyword,doc_template,doc_score,doc_brief,relation_id");
			sbSql.append(",is_attachment,doc_type)");
			sbSql.append(" values(to_date('"+format.format(new Date())+"','YYYY-MM-DD HH24-mi-ss'),'"+fileAbbr+"','"+FileId+"','"+docName+"','"+docType+"','"+parent_file_id+"','"+ucmDocId+"',"); 
			
			//多项目,项目编号填空
	 
			sbSql.append("'"+user.getProjectInfoNo()+"',");
		 
			sbSql.append("'0',to_date('"+format.format(new Date())+"','YYYY-MM-DD HH24-mi-ss'),'"+user.getEmpId()+"',to_date('"+format.format(new Date())+"','YYYY-MM-DD HH24-mi-ss'),'"+user.getEmpId()+"','1','"+user.getCodeAffordOrgID()+"','"+user.getSubOrgIDofAffordOrg()+"','"+docImportance+"','"+docKeyword+"','"+docTemplate+"',");
			sbSql.append("'"+docScore+"','"+docBrief+"'");
			if(relationId != ""&&relationId !=null){
				sbSql.append(",'"+relationId+"','1','"+doc_type_s+"')");
			}else{
				sbSql.append(","+null+",'0','"+doc_type_s+"')");
			}
			
			jdbcTemplate.execute(sbSql.toString());
			
			myUcm.docVersion(FileId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),docName);
			myUcm.docLog(FileId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),docName);
			
			List<Map> fields = queryDocFieldInfo(fileAbbr);
			 if(fields!=null && !fileAbbr.isEmpty()){
				for(Map map:fields){
					Map item = new HashMap(); 
					item.put("DOC_GMS_ID", FileId);
					String fieldEnName = (String)map.get("field_en_name");
					String value = isrvmsg.getValue("doc_"+fieldEnName);
					item.put("DOC_GMS_FIELD", fieldEnName);
					item.put("DOC_GMS_VALUE", value);
					jdbcDao.saveOrUpdateEntity(item, "BGP_DOC_GMS_VALUE");
				}
			}
			
			responseDTO.setValue("ucmDocId", ucmDocId);
			responseDTO.setValue("uploadfolderid", relationId);
			responseDTO.setValue("qualityControl",quality_control);
		}
		return responseDTO;
		
	}
	
	/**
	 * 施工设计修改保存新
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveEditTdDoc(ISrvMsg isrvmsg) throws Exception {
		String fileAbbr = isrvmsg.getValue("file_abbr") != null?isrvmsg.getValue("file_abbr"):"";
		String doc_type_s = isrvmsg.getValue("doc_type_s") != null?isrvmsg.getValue("doc_type_s"):"";
		String parent_file_id = isrvmsg.getValue("parent_file_id") != null?isrvmsg.getValue("parent_file_id"):"";
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
			paramMap.put("doc_type",doc_type_s);
			paramMap.put("file_type",docType);
			paramMap.put("file_abbr",fileAbbr);
			paramMap.put("parent_file_id",parent_file_id);
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
			paramMap.put("doc_type",doc_type_s);
			paramMap.put("file_type",docType);
			paramMap.put("file_abbr",fileAbbr);
			paramMap.put("parent_file_id",parent_file_id);
			paramMap.put("file_version", docVersion);
			paramMap.put("bsflag", "0");
			paramMap.put("modifi_date", new Date());
			paramMap.put("updator_id", user.getUserId());
			paramMap.put("org_id", user.getCodeAffordOrgID());
			paramMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_gms_file");
		}
		
		List<Map> values = queryDocValueInfo(fileID);
		if(values!=null ){
			for(Map valueMap:values){  
				String fieldEnName = (String)valueMap.get("doc_gms_field");
				String value = isrvmsg.getValue("doc_"+fieldEnName);
				valueMap.put("doc_gms_value", value);
				jdbcDao.saveOrUpdateEntity(valueMap, "BGP_DOC_GMS_VALUE");
			}
		}
		
		responseDTO.setValue("verdionUcmId", ucmDocId);
		responseDTO.setValue("verdionFileId", fileID);
		return responseDTO;

	}
	
	
	//施工设计保存旧
	public ISrvMsg saveTdDocOld(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		UserToken user = reqDTO.getUserToken();
		
		String docType = reqDTO.getValue("docType");		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String creatorId = reqDTO.getValue("creatorId");
		String uploadDate = reqDTO.getValue("uploadDate");
		String fileName = reqDTO.getValue("fileName");
		String ucmId = reqDTO.getValue("ucmId");
		String fileId = reqDTO.getValue("fileId");
		String fileAbbr = reqDTO.getValue("fileAbbr");
		
		String receiveOrg = reqDTO.getValue("receiveOrg");
		String receiveId = reqDTO.getValue("receiveId");
		String uploadId = reqDTO.getValue("uploadId");
		String docFileType = reqDTO.getValue("docFileType");
		
		Map mapDetail = new HashMap();
		
		mapDetail.put("project_info_no", projectInfoNo);
		mapDetail.put("receive_id", receiveId);
		mapDetail.put("upload_id", uploadId);
		mapDetail.put("receive_org", receiveOrg);
		mapDetail.put("doc_file_type", docFileType);
		mapDetail.put("creator_id", creatorId);
		mapDetail.put("doc_type", docType);
		mapDetail.put("upload_date", uploadDate);
		mapDetail.put("create_date", new Date());
		mapDetail.put("modifi_date", new Date());
		mapDetail.put("file_name", fileName);
		mapDetail.put("file_abbr", fileAbbr);
		mapDetail.put("bsflag", "0");
		mapDetail.put("is_file", "1");
		mapDetail.put("org_id", user.getOrgId());
		mapDetail.put("org_subjection_id", user.getOrgSubjectionId());
		
		String parent_file_id = "";
		String sql = "select * from bgp_doc_gms_file f where f.bsflag='0' and is_file='0' and f.project_info_no='"+projectInfoNo+"' and f.file_abbr='"+fileAbbr+"'";
		Map map  = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null){
			parent_file_id = (String)map.get("fileId");
		}
		mapDetail.put("parent_file_id", parent_file_id);
		
		
		//主键存不为空修改，为空新增
		if(fileId!=null && !"".equals(fileId)){
			mapDetail.put("file_id", fileId);
		}
		
		MyUcm ucm = new MyUcm();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		String documentId = "";
		if(fileList!= null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			documentId = ucm.uploadFile(fs.getFilename(),fs.getFileData());
			mapDetail.put("ucm_id", documentId);
			
			if(ucmId!=null && !"".equals(ucmId)){
				ucm.deleteFile(ucmId);
								
				String update =" update bgp_doc_gms_file set bsflag='1' where ucm_id='"+ucmId+"'";
				jdbcDao.getJdbcTemplate().update(update);
			}
			
		}
		
		
		String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_doc_gms_file").toString();
				
		ucm.docVersion(doc_pk_id, "1.0", documentId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
		ucm.docLog(doc_pk_id, "1.0", 1, documentId, user.getUserId(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId(),fileName);
				
		responseDTO.setValue("codingCodeId", docType);	
		responseDTO.setValue("fileAbbr", fileAbbr);
		return responseDTO;
	}
	
	
	public ISrvMsg deleteTdDoc(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);		
		
		String id = reqDTO.getValue("id");
				
		String update =" update bgp_doc_gms_file t set t.bsflag='1' where t.file_id in ("+id+")";
		jdbcDao.getJdbcTemplate().update(update);
		
		String sql = "select t.ucm_id from bgp_doc_gms_file t where t.file_id in ("+id+")";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		MyUcm ucm = new MyUcm();
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String ucmId = (String)map.get("ucmId");
			ucm.deleteFile(ucmId);
		}
		
		return responseDTO;
	}
	
	
	/**
	 * 进入基础检查表查看页面
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg checkDocView(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String keyId = reqDTO.getValue("id");
		String docType = reqDTO.getValue("docType");
		String projectInfoNo = user.getProjectInfoNo();
		// 申请表主键
		
		if (keyId == null || "".equals(keyId)) {
			Map map = new HashMap();
			map.put("uploadName", user.getUserName());
			map.put("uploadId", user.getEmpId());
			String applyDate = new SimpleDateFormat("yyyy-MM-dd")
					.format(new Date());
			map.put("uploadDate", applyDate);
			map.put("projectInfoNo", projectInfoNo);
			map.put("docType", docType);
			
			responseDTO.setValue("applyInfo", map);
			
			// 查询子表信息
			StringBuffer subsql = new StringBuffer(" select d.coding_code_id check_code,d.coding_name check_code_name from comm_coding_sort_detail d where d.bsflag='0' ");			
			subsql.append(" and d.superior_code_id='").append(docType).append("' order by d.coding_show_id");			
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
			
			responseDTO.setValue("detailInfo", list);
		} else {
			// 查询主表信息
			Map map = new HashMap();
			StringBuffer sb = new StringBuffer(" select t.check_id, t.project_info_no, p.project_name,t.upload_date, t.check_no, t.upload_id,e.employee_name upload_name, ");
			sb.append(" t.check_date,t.check_type,t.doc_type,t.org_id,t.org_subjection_id ");
			sb.append(" from bgp_doc_td_file_check t ");
			sb.append(" left join gp_task_project p on t.project_info_no = t.project_info_no ");
			sb.append(" left join comm_human_employee e on t.upload_id = e.employee_id ");
			sb.append(" where t.bsflag = '0' and t.check_id = '").append(keyId).append("' ");
		
			map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
			responseDTO.setValue("applyInfo", map);
			
			// 查询子表信息
			StringBuffer subsql = new StringBuffer(" select d.data_id, d.is_complete, d.is_pass, nvl(d.check_code_name,e.coding_name) check_code_name, e.coding_code_id  check_code,d.notes ");
			subsql.append(" from (select e.coding_code_id, e.coding_name from comm_coding_sort_detail e where e.superior_code_id = '").append(docType).append("') e ");					
			subsql.append(" full join (select d.data_id, d.is_complete, d.is_pass, d.check_code, d.check_code_name,d.notes ");					
			subsql.append(" from bgp_doc_td_file_check_data d left join bgp_doc_td_file_check c on c.check_id = d.check_id  ");		
			subsql.append("  where d.bsflag = '0' and c.check_id = '").append(keyId).append("' ) d on d.check_code = e.coding_code_id ");	

			List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
			responseDTO.setValue("detailInfo", list);
			
		}
		
		return responseDTO;
	}
	
	/**
	 * 进入基础检查表查看页面
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg checkChartDocView(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String docType = reqDTO.getValue("docType");
		String day = reqDTO.getValue("day");


		// 查询主表信息
		Map map = new HashMap();
		StringBuffer sb = new StringBuffer(" select t.check_id, t.project_info_no, p.project_name,t.upload_date, t.check_no, t.upload_id,e.employee_name upload_name, ");
		sb.append(" t.check_date,t.check_type,t.doc_type,t.org_id,t.org_subjection_id ");
		sb.append(" from bgp_doc_td_file_check t ");
		sb.append(" left join gp_task_project p on t.project_info_no = t.project_info_no ");
		sb.append(" left join comm_human_employee e on t.upload_id = e.employee_id ");
		sb.append(" where t.bsflag = '0' and t.project_info_no = '").append(projectInfoNo).append("' ");
		sb.append(" and t.doc_type = '").append(docType).append("' ");
		sb.append(" and t.upload_date = to_date('").append(day).append("','yyyy-MM-dd' )");
	
		map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
		responseDTO.setValue("applyInfo", map);
		
		// 查询子表信息		
		StringBuffer subsql = new StringBuffer(" select d.data_id, d.is_complete, d.is_pass, nvl(d.check_code_name,e.coding_name) check_code_name, e.coding_code_id  check_code ");
		subsql.append(" from (select e.coding_code_id, e.coding_name from comm_coding_sort_detail e where e.superior_code_id = '").append(docType).append("') e ");					
		subsql.append(" full join (select d.data_id, d.is_complete, d.is_pass, d.check_code, d.check_code_name ");					
		subsql.append(" from bgp_doc_td_file_check_data d left join bgp_doc_td_file_check c on c.check_id = d.check_id  ");		
		subsql.append("  where d.bsflag = '0' and c.check_id = '").append(map.get("checkId")).append("' ) d on d.check_code = e.coding_code_id ");	

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
		responseDTO.setValue("detailInfo", list);
			
		
		return responseDTO;
	}
	
	public ISrvMsg savecheckDoc(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		Map mapInfo = null;
		BgpDocTdFileCheck applyInfo = new BgpDocTdFileCheck();
		PropertiesUtil.msgToPojo(reqDTO, applyInfo);
		mapInfo = PropertiesUtil.describe(applyInfo);
		
		String docType = reqDTO.getValue("docType");

		
		//申请表主键
		String infoKeyValue = "";
		if (mapInfo.get("check_id") == null) {// 新增操作			

			// check_type 0  待审核   1  审核通过  2  审核不通过
		
			mapInfo.put("bsflag", "0");
			mapInfo.put("creator", user.getEmpId());
			mapInfo.put("create_date", new Date());
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			mapInfo.put("org_id", user.getOrgId());
			mapInfo.put("org_subjection_id", user.getOrgSubjectionId());
			
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,"bgp_doc_td_file_check");
			infoKeyValue = id.toString();
		} else {// 修改或审核操作
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,
					"bgp_doc_td_file_check");
			infoKeyValue = (String) mapInfo.get("check_id");
		}

		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));

		Map mapDetail = new HashMap();
		//存放申请单子表信息
		for (int i = 0; i < equipmentSize; i++) {		
			BgpDocTdFileCheckData applyDetail = new BgpDocTdFileCheckData();
				PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
						applyDetail);				
				mapDetail = PropertiesUtil.describe(applyDetail);		
				if(applyDetail.getCheck()!=null && "on".endsWith(applyDetail.getCheck())){
					mapDetail.put("bsflag", "0");
				}else{
					mapDetail.put("bsflag", "1");
				}
				mapDetail.put("check_id", infoKeyValue);				
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modifi_date", new Date());
				
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
				"bgp_doc_td_file_check_data");

				
		} 
		responseDTO.setValue("docType", applyInfo.getDocType());
		return responseDTO;
	}
	
	public ISrvMsg queryCheckDoc(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		UserToken user = reqDTO.getUserToken();
		SimpleDateFormat oSdf = new SimpleDateFormat ("yyyy-MM-dd");   
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String projectName = reqDTO.getValue("projectName");
		String orgSubjectionId = user.getOrgSubjectionId();
		String docDate = reqDTO.getValue("docDate");
		if(docDate == null){
			docDate = oSdf.format(new Date());
		}
		String docType = reqDTO.getValue("docType");
		
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("select distinct t.project_info_no,t.project_name from gp_task_project t  ");
		sb.append(" inner join gp_task_project_dynamic dy on dy.project_info_no = t.project_info_no  and dy.exploration_method = t.exploration_method  and dy.bsflag = '0'  and dy.org_subjection_id like '").append(orgSubjectionId).append("%' ");		
		sb.append(" inner join comm_org_subjection s on dy.org_id=s.org_id and s.bsflag='0' ");		
		sb.append(" join comm_org_information oi on dy.org_id = oi.org_id  and oi.org_name like '%%' ");
		sb.append(" join comm_coding_sort_detail ccsd on t.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ");
		sb.append(" join comm_coding_sort_detail ccsd1 on t.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ");
		sb.append(" where t.bsflag='0' and t.project_name like '%%' and t.project_type like '%%'  and t.is_main_project like '%%' and t.project_status like '%%' ");

		List list = jdbcDAO.queryRecords(sb.toString());
		Calendar cal = new GregorianCalendar();
   
		cal.setTime(oSdf.parse(docDate)); 
		int daynum = cal.getActualMaximum(Calendar.DAY_OF_MONTH); 
		
		//decode(t.check_type, '0', '待审核', '1', '审核通过','2', '审核不通过','') check_type_name
		StringBuffer sql = new StringBuffer(" select d.check_date,t.project_info_no,p.project_name,t.doc_file_type,t.check_type ");
		sql.append(" from (SELECT TRUNC(to_date('").append(docDate).append("', 'yyyy-MM-dd'), 'MM') + ROWNUM - 1 check_date ");
		sql.append(" FROM DUAL CONNECT BY ROWNUM <= TO_NUMBER(TO_CHAR(LAST_DAY(to_date('").append(docDate).append("', 'yyyy-MM-dd')), 'dd'))) d ");
		sql.append(" left join bgp_doc_td_file_check t on  t.upload_date = d.check_date and t.project_info_no= '@projectInfoNo' ");
		sql.append(" and t.doc_type='@docType' and t.bsflag = '0' ");
		sql.append(" left join gp_task_project p on t.project_info_no = p.project_info_no  and p.bsflag='0' ");		
		sql.append(" order by d.check_date ");
		
		String docsql = sql.toString().replaceAll("@docType", docType);
		
		List newlist = new ArrayList();
		
		if(projectInfoNo != null && !"".equals(projectInfoNo)){
			Map map = new HashMap();
			map.put("project_info_no", projectInfoNo);
			map.put("project_name", projectName);
			
			String newsql = docsql.replaceAll("@projectInfoNo", projectInfoNo);
			List templist = jdbcDAO.queryRecords(newsql);
			
			for(int j=0;j<templist.size();j++){
				Map checkmap = (Map)templist.get(j);
				map.put("date"+(j+1), checkmap.get("check_type"));
			}
			newlist.add(map);
			
		}else{
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				
				String newsql = docsql.replaceAll("@projectInfoNo", (String)map.get("project_info_no"));
				List templist = jdbcDAO.queryRecords(newsql);
				
				for(int j=0;j<templist.size();j++){
					Map checkmap = (Map)templist.get(j);
					map.put("date"+(j+1), checkmap.get("check_type"));
				}
				
				newlist.add(map);
			} 
		}
		
		
		responseDTO.setValue("docDate", docDate);
		responseDTO.setValue("docType", docType);
		responseDTO.setValue("projectInfoNo", projectInfoNo);
		responseDTO.setValue("projectName", projectName);
		responseDTO.setValue("daynum", daynum+"");
		responseDTO.setValue("newlist", newlist);	
		
		return responseDTO;
	}

	public ISrvMsg getDocRemindStr(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		SimpleDateFormat oSdf = new SimpleDateFormat ("yyyy-MM-dd");   
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo= user.getProjectInfoNo();
		StringBuffer str = new StringBuffer();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer db = new StringBuffer("select to_date(to_char(case when sysdate > p.acquire_end_time then  p.acquire_end_time else sysdate end,'yyyy-mm' )||'-01','yyyy-mm-dd') dd ");
		db.append(" from gp_task_project p left join bgp_doc_gms_file t on t.project_info_no = p.project_info_no ");		
		db.append(" and t.doc_type = '@docType' and t.bsflag='0'  where p.bsflag = '0'    and p.project_info_no = '").append(projectInfoNo).append("' ");		
		
		StringBuffer sb = new StringBuffer("select to_char(t.d_month,'yyyy-mm') d_month, p.nums from (select add_months(to_date('@sysdate','yyyy-mm-dd'), -rownum + 1) d_month from dual  ");
		sb.append(" connect by rownum <=(select months_between(to_date('@sysdate','yyyy-mm-dd'), ");		
		sb.append(" min(to_date(to_char(t.upload_date,'yyyy-mm') || '-01','yyyy-mm-dd'))) + 1 ");		
		sb.append(" from bgp_doc_gms_file t where t.bsflag = '0' and t.project_info_no = '").append(projectInfoNo).append("' ");		
		sb.append(" and t.doc_type = '@docType')  order by d_month desc) t ");		
		sb.append(" left join (select to_date(to_char(t.upload_date, 'yyyy-mm') || '-01', 'yyyy-mm-dd') upload_date,  count(t.file_id) nums ");		
		sb.append(" from bgp_doc_gms_file t where t.bsflag = '0' and t.project_info_no = '").append(projectInfoNo).append("' and t.doc_type = '@docType' ");		
		sb.append(" group by to_char(t.upload_date, 'yyyy-mm')) p on t.d_month = p.upload_date  where p.nums is null order by t.d_month ");		

		StringBuffer ysb = new StringBuffer("select to_char(t.d_month, 'yyyy') d_month, p.nums from (select add_months(to_date(to_char(sysdate, 'yyyy') || '0101','yyyymmdd'), -rownum + 1) d_month from dual  ");
		ysb.append(" connect by rownum <=(select months_between(to_date(to_char(sysdate, 'yyyy') || '0101','yyyymmdd'), ");		
		ysb.append(" min(to_date(to_char(t.upload_date,'yyyy') || '0101','yyyymmdd')))/12 ");		
		ysb.append(" from bgp_doc_gms_file t where t.bsflag = '0' and t.project_info_no = '").append(projectInfoNo).append("' ");		
		ysb.append(" and t.doc_type = '@docType')  order by d_month desc) t ");		
		ysb.append(" left join (select to_date(to_char(t.upload_date, 'yyyy') || '0101', 'yyyymmdd') upload_date,  count(t.file_id) nums ");		
		ysb.append(" from bgp_doc_gms_file t where t.bsflag = '0' and t.project_info_no = '").append(projectInfoNo).append("' and t.doc_type = '@docType' ");		
		ysb.append(" group by to_char(t.upload_date, 'yyyy')) p on t.d_month = p.upload_date  where p.nums is null order by t.d_month ");	
		
		String buildMsql="select   t.build_method  from  gp_task_project t   where t.bsflag = '0'  and t.project_info_no='"+projectInfoNo+"' "; 
		
		Map map  = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(buildMsql);
		if(map!=null){ 
			 	String 	build_method = (String)map.get("buildMethod");	 
			 	
			 	if (build_method.equals("5000100003000000005")){  //气枪/井炮
			 	 	 String [] remindMonth={ "0110000061000000004-测量仪器月检", "0110000061000000002-仪器月检","0110000061000000007-小折射仪器月检","0110000061000000008-震源月检","0110000061000001008-气枪月检" };
			 	}else if (build_method.equals("5000100003000000003")){ //气枪
			 		String [] remindMonth={ "0110000061000000004-测量仪器月检", "0110000061000000002-仪器月检","0110000061000000007-小折射仪器月检","0110000061000001008-气枪月检" };
			 	}else if (build_method.equals("5000100003000000001")){ //井炮
			 		String [] remindMonth={ "0110000061000000004-测量仪器月检", "0110000061000000002-仪器月检","0110000061000000007-小折射仪器月检"};
			 	}else if (build_method.equals("5000100003000000004")){ //井炮/震源
			 		String [] remindMonth={ "0110000061000000004-测量仪器月检", "0110000061000000002-仪器月检","0110000061000000007-小折射仪器月检","0110000061000000008-震源月检"};
			 	}else if (build_method.equals("5000100003000000007")){ //  气枪/井炮/震源
			 		String [] remindMonth={ "0110000061000000004-测量仪器月检", "0110000061000000002-仪器月检","0110000061000000007-小折射仪器月检","0110000061000000008-震源月检","0110000061000001008-气枪月检" };
			 	}else {
			 		String [] remindMonth={ "0110000061000000004-测量仪器月检", "0110000061000000002-仪器月检","0110000061000000007-小折射仪器月检","0110000061000000008-震源月检" };
			 	}
				 
			 }
		for(int i=0;i<remindMonth.length;i++){
			
			String ddsql = db.toString().replaceAll("@docType", remindMonth[i].split("-")[0]);
			Map ddMap = jdbcDAO.queryRecordBySQL(ddsql);
			String dd = "";
			if(ddMap != null){
				dd = (String)ddMap.get("dd");
			}
						
			String docsql = sb.toString().replaceAll("@docType", remindMonth[i].split("-")[0]);
			docsql = docsql.replaceAll("@sysdate", dd);
			
			List templist = jdbcDAO.queryRecords(docsql);
			if(templist != null && templist.size()>0){
				str.append(remindMonth[i].split("-")[1]);
				for(int j=0;j<templist.size();j++){					
					Map checkmap = (Map)templist.get(j);
					str.append(checkmap.get("d_month")).append(" ");
				}
				str.append("未检查;\n");
			}
		}
		
//		for(int i=0;i<remindYear.length;i++){
//			String docsql = ysb.toString().replaceAll("@docType", remindYear[i].split("-")[0]);
//			List templist = jdbcDAO.queryRecords(docsql);
//			if(templist != null && templist.size()>0){
//				str.append(remindYear[i].split("-")[1]);
//				for(int j=0;j<templist.size();j++){					
//					Map checkmap = (Map)templist.get(j);
//					str.append(checkmap.get("d_month")).append(" ");
//				}
//				str.append("未检查;\n");
//			}
//		}
		responseDTO.setValue("str", str.toString());		
		return responseDTO;
	}
	
	public ISrvMsg queryChartAduitList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String s_org_id = reqDTO.getValue("s_org_id");
		String is_main_project = reqDTO.getValue("is_main_project");
		String project_status = reqDTO.getValue("project_status");
		String is_type = reqDTO.getValue("is_type");
		

		StringBuffer sql = new  StringBuffer(" select t.project_info_no,p.project_type,p.project_name, ");
		sql.append(" sum(case when t.doc_type='0110000061100000001' and t.proc_status='1'  or   t.doc_type = '0110000061100001009' and t.proc_status = '1'  then 1 else 0 end ) n1, ");
		sql.append(" sum(case when t.doc_type='0110000061100000001' and t.proc_status='3'   or   t.doc_type = '0110000061100001009' and t.proc_status = '3'  then 1 else 0 end ) n2, ");
		sql.append(" sum(case when t.doc_type='0110000061100000002' and t.proc_status='1' then 1 else 0 end ) n3, ");
		sql.append(" sum(case when t.doc_type='0110000061100000002' and t.proc_status='3' then 1 else 0 end ) n4, ");
		sql.append(" sum(case when t.doc_type='0110000061100000003' and t.proc_status='1' or  t.doc_type = '0110000061100001008' and t.proc_status = '1' then 1 else 0 end ) n5, ");
		sql.append(" sum(case when t.doc_type='0110000061100000003' and t.proc_status='3'  or   t.doc_type = '0110000061100001008' and t.proc_status = '3' then 1 else 0 end ) n6, ");
		sql.append(" sum(case when t.doc_type='0110000061100000004' and t.proc_status='1' then 1 else 0 end ) n7, ");
		sql.append(" sum(case when t.doc_type='0110000061100000004' and t.proc_status='3' then 1 else 0 end ) n8, ");
		sql.append(" sum(case when t.doc_type='0110000061100000005' and t.proc_status='1' then 1 else 0 end ) n9, ");
		sql.append(" sum(case when t.doc_type='0110000061100000005' and t.proc_status='3' then 1 else 0 end ) n10, ");
		sql.append(" sum(case when t.doc_type='0110000061100000006' and t.proc_status='1' then 1 else 0 end ) n11, ");
		sql.append(" sum(case when t.doc_type='0110000061100000006' and t.proc_status='3' then 1 else 0 end ) n12, ");
		sql.append(" sum(case when t.doc_type='0110000061100000007' and t.proc_status='1' then 1 else 0 end ) n13, ");
		sql.append(" sum(case when t.doc_type='0110000061100000007' and t.proc_status='3' then 1 else 0 end ) n14 ");
		sql.append("  from ( ");
		sql.append(" select t.project_info_no, t.doc_type, te.proc_status ");
		sql.append("   from bgp_doc_gms_file t ");
		sql.append("   left join common_busi_wf_middle te on te.business_id = t.file_id and te.bsflag = '0'  and te.proc_status in ('1', '3') ");
		sql.append("  and te.business_type in  ('5110000004100000059', '5110000004100000051', '5110000004100000052','5110000004100000053','5110000004100000054', '5110000004100000062','5110000004100000063','5110000004100000064') ");
		sql.append("  where t.doc_type in  ('0110000061100000001', '0110000061100000002', '0110000061100000003', '0110000061100000004', '0110000061100000005', '0110000061000000029','0110000061100000006','0110000061100000007') ");
		sql.append("  and te.proc_status in ('1', '3') and t.bsflag='0'   union all    select t.project_info_no, t.doc_type, te.proc_status  from gp_ws_tecnical_basic t  left join common_busi_wf_middle te  on te.business_id = t.tecnical_id  and te.bsflag = '0'  and te.proc_status in ('1', '3')  and te.business_type in  ('5110000004100000083',  '5110000004100000085',  '5110000004100000086',  '5110000004100000084',  '5110000004100000087')  where t.doc_type in ('0110000061100000002',  '0110000061100000006',  '0110000061100000007',  '0110000061100001008',  '0110000061100001009')  and te.proc_status in ('1', '3')  and t.bsflag = '0'   ");
		sql.append("  ) t left join gp_task_project p on t.project_info_no=p.project_info_no and p.bsflag='0' ");
		sql.append(" left join gp_task_project_dynamic p1 on p.project_info_no=p1.project_info_no and p1.bsflag='0' ");
		sql.append(" left join comm_org_subjection p2 on p1.org_id =p2.org_id and p2.bsflag='0'  where p.project_name like '%%' ");
		if(projectInfoNo != null && !"".equals(projectInfoNo)){
			sql.append(" and t.project_info_no='").append(projectInfoNo).append("' ");
		}
		if(is_main_project != null && !"".equals(is_main_project)){
	 
				sql.append(" and p.is_main_project='").append(is_main_project).append("' ");
			 
		}
		//处理项目类型
		if(is_type != null && !"".equals(is_type)){
		 
				sql.append(" and p.project_type='5000100004000000008' ");
			 
		}else{
			sql.append(" and p.project_type !='5000100004000000008' ");
			
		}
		
		if(project_status != null && !"".equals(project_status)){
			sql.append(" and p.project_status='").append(project_status).append("' ");
		}
		if(s_org_id != null && !"".equals(s_org_id)){
			sql.append(" and p2.org_subjection_id like '").append(s_org_id).append("%' ");
		}
		sql.append("  group by t.project_info_no,p.project_type,p.project_name order by p.project_name ");
		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}
	
	public ISrvMsg queryChartList(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		UserToken user = reqDTO.getUserToken();
		SimpleDateFormat oSdf = new SimpleDateFormat ("yyyy-MM-dd");   
		SimpleDateFormat mon = new SimpleDateFormat ("yyyy-MM");   
		String docDate = oSdf.format(new Date());
		String monDate = mon.format(new Date());
		String orgSubjectionId = user.getOrgSubjectionId();		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		StringBuffer sb = new StringBuffer("select distinct t.project_info_no,t.project_name from gp_task_project t  ");
		sb.append(" inner join gp_task_project_dynamic dy on dy.project_info_no = t.project_info_no  and dy.exploration_method = t.exploration_method  and dy.bsflag = '0'  and dy.org_subjection_id like '").append(orgSubjectionId).append("%' ");		
		sb.append(" inner join comm_org_subjection s on dy.org_id=s.org_id and s.bsflag='0' ");		
		sb.append(" join comm_org_information oi on dy.org_id = oi.org_id  and oi.org_name like '%%' ");
		sb.append(" join comm_coding_sort_detail ccsd on t.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ");
		sb.append(" join comm_coding_sort_detail ccsd1 on t.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ");
		sb.append(" where t.bsflag='0' and t.project_name like '%%' and t.project_type like '%%'  and t.is_main_project like '%%' and t.project_status like '%%' order by t.project_name ");

		List list = jdbcDAO.queryRecords(sb.toString());
		Calendar cal = new GregorianCalendar();   
		cal.setTime(oSdf.parse(docDate)); 
		int daynum = cal.getActualMaximum(Calendar.DAY_OF_MONTH); 
		
		//decode(t.check_type, '0', '待审核', '1', '审核通过','2', '审核不通过','') check_type_name
		StringBuffer sql = new StringBuffer(" select t.project_info_no,t.doc_type,REPLACE( t.type_name, '检查表', '检查结果') type_name, ");		
		for(int n=1;n<=daynum;n++){
			sql.append(" sum(case when  t.upload_date = to_date('").append(monDate).append("-").append(n).append("','yyyy-MM-dd') then t.check_type else '' end ) n").append(n);
			if(n != daynum){
				sql.append(" , ");
			}
		}		
		sql.append(" from ( ");
		sql.append(" select t.project_info_no, t.doc_type,d.coding_name type_name, t.upload_date,t.check_type  from bgp_doc_td_file_check t ");
		sql.append(" left join comm_coding_sort_detail d on t.doc_type=d.coding_code_id  where  t.bsflag = '0' and t.project_info_no='@projectInfoNo' order by t.project_info_no,t.upload_date, t.doc_type ) t ");
		sql.append(" group by  t.project_info_no, t.doc_type,t.type_name order by t.project_info_no, t.doc_type,t.type_name ");
		
		List newlist = new ArrayList();
		
		
		
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			
			String newsql = sql.toString().replaceAll("@projectInfoNo", (String)map.get("project_info_no"));
			List templist = jdbcDAO.queryRecords(newsql);
			
			if(templist != null && templist.size()>0){
				for(int j=0;j<templist.size();j++){
					Map temp = new HashMap();
					temp.put("project_info_no", map.get("project_info_no"));
					temp.put("project_name", map.get("project_name"));
					temp.putAll((Map)templist.get(j));
					
					newlist.add(temp);
				}
				
			}			
		} 
		
		responseDTO.setValue("detailInfo", newlist);
		
		return responseDTO;
	}
	
	public ISrvMsg queryChartTeamList(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		UserToken user = reqDTO.getUserToken();

	//	String projectInfoNo= user.getProjectInfoNo();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				
		StringBuffer sql = new StringBuffer(" select t.d_day,p.project_info_no, ");		
		sql.append(" sum(case when p.doc_type='0110000061000000042' then p.check_type else '' end ) n1, ");
		sql.append(" sum(case when p.doc_type='0110000061000000043' then p.check_type else '' end ) n2, ");
		sql.append(" sum(case when p.doc_type='0110000061000000078' then p.check_type else '' end ) n3, ");
		sql.append(" sum(case when p.doc_type='0110000061000000096' then p.check_type else '' end ) n4, ");
		sql.append(" sum(case when p.doc_type='0110000061000000087' then p.check_type else '' end ) n5, ");	
		sql.append(" sum(case when p.doc_type='0110000061000001078' then p.check_type else '' end ) n6 ");	
		sql.append(" from ( ");
		sql.append(" select to_char(sysdate -rownum,'yyyy-MM-dd')  d_day from dual ");
		sql.append(" connect by rownum <=(select round(sysdate- min(t.upload_date)) ");
		sql.append(" from bgp_doc_td_file_check t where t.bsflag = '0' and t.project_info_no = '").append(projectInfoNo).append("') ");
		sql.append(" ) t left join (  select t.project_info_no, t.doc_type, to_char(t.upload_date,'yyyy-MM-dd') upload_date, t.check_type ");
		sql.append(" from bgp_doc_td_file_check t where t.bsflag = '0' and t.project_info_no = '").append(projectInfoNo).append("' ");
		sql.append(" order by t.project_info_no, t.upload_date, t.doc_type ) p on t.d_day=p.upload_date group by t.d_day,p.project_info_no order by t.d_day ");
	
		
		List templist = jdbcDAO.queryRecords(sql.toString());
		
		Map projectName = jdbcDAO.queryRecordBySQL(" select project_name from gp_task_project where project_info_no ='"+projectInfoNo+"'");
				
		responseDTO.setValue("detailInfo", templist);
		responseDTO.setValue("projectName", projectName);
		
		return responseDTO;
	}
	//查询 技术首页面第二个 列表数据
	public ISrvMsg queryChartOrgNumsList(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = user.getSubOrgIDofAffordOrg();

		String s_org_id = reqDTO.getValue("s_org_id");
		String is_main_project = reqDTO.getValue("is_main_project");
		String project_status = reqDTO.getValue("project_status");

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				
		StringBuffer sql = new StringBuffer(" select t.project_name,t3.* from ( select nvl(t1.project_info_no,t2.project_info_no ) project_info_no ,nvl(t1.n1,0) n1,nvl(t1.n2,0) n2,nvl(t1.n3,0) n3,nvl(t1.n4 ,0) n4 ,nvl(t1.n5,0) n5,nvl(t1.n6 ,0) n6, ");		
		sql.append(" nvl(t2.n7,0) || '-' || nvl(t2.d7,0) n7,nvl(t2.n8,0) || '-' || nvl(t2.d8,0) n8,nvl(t2.n9,0)|| '-' || nvl(t2.d9,0) n9,nvl(t2.n10,0)|| '-' || nvl(t2.d10,0) n10,nvl(t2.n11,0) || '-' || nvl(t2.d11,0) n11 ,nvl(t2.n12,0) || '-' || nvl(t2.d12,0) n12 from ( ");
		sql.append(" select t.project_info_no, ");
		sql.append(" sum(case when t.doc_type = '0110000061000000050' then 1 else 0 end) n1, ");
		sql.append(" sum(case when t.doc_type = '0110000061000000070' then 1 else 0 end) n2, ");
		sql.append(" sum(case when t.doc_type = '0110000061000000075' then 1 else 0 end) n3, ");
		sql.append(" sum(case when t.doc_type = '0110000061000000071' then 1 else 0 end) n4, ");
		sql.append(" sum(case when t.doc_type = '0110000061000000073' then 1 else 0 end) n5, ");
		sql.append(" sum(case when t.doc_type = '0110000061000000053' then 1 else 0 end) n6 ");
		sql.append(" from (select t.project_info_no, t.doc_type  from bgp_doc_gms_file t  where t.bsflag = '0' ");
		sql.append(" and t.doc_type in ('0110000061000000050','0110000061000000070','0110000061000000075','0110000061000000071','0110000061000000073','0110000061000000053') ");
		sql.append(" ) t group by t.project_info_no ) t1 full join ( ");
		sql.append(" select p.project_info_no, ");
		sql.append(" sum(case when p.doc_type='0110000061000000042' then 1 else 0 end ) n7,  ");
		sql.append(" sum(case when p.check_type='0' and p.doc_type = '0110000061000000042' then 1 else 0 end ) d7,  ");
		sql.append(" sum(case when p.doc_type='0110000061000000043' then 1 else 0 end ) n8,  ");
		sql.append(" sum(case when p.check_type='0' and p.doc_type = '0110000061000000043' then 1 else 0 end ) d8,  ");
		sql.append(" sum(case when p.doc_type='0110000061000000078' then 1 else 0 end ) n9, ");
		sql.append(" sum(case when p.check_type='0' and p.doc_type = '0110000061000000078' then 1 else 0 end ) d9,  ");
		sql.append(" sum(case when p.doc_type='0110000061000000096' then 1 else 0 end ) n10, ");
		sql.append(" sum(case when p.check_type='0' and p.doc_type = '0110000061000000096' then 1 else 0 end ) d10,  ");
		sql.append(" sum(case when p.doc_type='0110000061000000087' then 1 else 0 end ) n11,  ");
		sql.append(" sum(case when p.check_type='0' and p.doc_type = '0110000061000000087' then 1 else 0 end ) d11,  ");
		sql.append(" sum(case when p.doc_type='0110000061000001078' then 1 else 0 end ) n12,  ");
		sql.append(" sum(case when p.check_type='0' and p.doc_type = '0110000061000001078' then 1 else 0 end ) d12  ");
		
		sql.append(" from ( select t.project_info_no, t.doc_type,t.check_type from bgp_doc_td_file_check t where t.bsflag = '0' and t.check_type in ('0','1') ");
		sql.append(" and t.doc_type in ('0110000061000000042','0110000061000000043','0110000061000000078','0110000061000000096','0110000061000000087','0110000061000001078') ");
		sql.append("  ) p  group by p.project_info_no  ");
		sql.append(" ) t2 on t1.project_info_no=t2.project_info_no ) ");
		sql.append("  t3 left join ( ");
		sql.append("select distinct t.project_info_no,t.project_name, s.org_subjection_id,t.is_main_project, t.project_type ,t.project_status from gp_task_project t  ");
		sql.append(" inner join gp_task_project_dynamic dy on dy.project_info_no = t.project_info_no  and dy.exploration_method = t.exploration_method  and dy.bsflag = '0'  and dy.org_subjection_id like '").append(orgSubjectionId).append("%' ");		
		sql.append(" inner join comm_org_subjection s on dy.org_id=s.org_id and s.bsflag='0' ");		
		sql.append(" join comm_org_information oi on dy.org_id = oi.org_id  and oi.org_name like '%%' ");
		//sql.append(" join comm_coding_sort_detail ccsd on t.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ");
		//sql.append(" join comm_coding_sort_detail ccsd1 on t.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ");
		sql.append(" where t.bsflag='0' and t.project_name like '%%' and t.project_type like '%%'  and t.is_main_project like '%%' and t.project_status like '%%' order by t.project_name ");
		sql.append(" ) t on t.project_info_no=t3.project_info_no  where 1=1 and  t.project_name like '%%'  ");

		if(projectInfoNo != null && !"".equals(projectInfoNo)){
			sql.append(" and t.project_info_no='").append(projectInfoNo).append("' ");
		}
		if(is_main_project != null && !"".equals(is_main_project)){
			sql.append(" and t.is_main_project='").append(is_main_project).append("' ");
		}
		if(project_status != null && !"".equals(project_status)){
			sql.append(" and t.project_status='").append(project_status).append("' ");
		}
		if(s_org_id != null && !"".equals(s_org_id)){
			sql.append(" and t.org_subjection_id like '").append(s_org_id).append("%' and t.project_type  !='5000100004000000008' ");
		}
				
		List templist = jdbcDAO.queryRecords(sql.toString());
				
		responseDTO.setValue("detailInfo", templist);
		
		return responseDTO;
	}
	
	
	
	
	
	
	//查询井中项目业务 技术单首页面2
public ISrvMsg queryChartOrgNumsListJZ(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = user.getSubOrgIDofAffordOrg();

		String s_org_id = reqDTO.getValue("s_org_id");
		String is_main_project = reqDTO.getValue("is_main_project");
		String project_status = reqDTO.getValue("project_status");

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				
		StringBuffer sql = new StringBuffer(" select   t3.*    from (select nvl(t1.project_info_no, t2.project_info_no) project_info_no, nvl(t1.project_name, t2.project_name) project_name,  nvl(t1.project_type, t2.project_type) project_type, nvl(t1.n1, 0) n1,  nvl(t1.n2, 0) n2,  nvl(t1.n3, 0) n3,  nvl(t1.n4, 0) n4,  nvl(t1.n5, 0) n5,  nvl(t1.n6, 0) n6,  nvl(t1.n7, 0) n7,    nvl(t2.n8, 0) n8,  nvl(t2.n9, 0) n9,  nvl(t2.n10, 0) n10,  nvl(t2.n11, 0) n11,  nvl(t2.n12, 0) n12       from (  ");		
	 
		sql.append("   select t.project_info_no,pt.project_name,pt.project_type, ");
		sql.append("   sum(case   when t.doc_type = '0110000061000000050' then  1   else  0  end) n1, ");
		sql.append("   sum(case  when t.doc_type = '5110000057000000005'  then  1  else  0  end) n2,");  //or   t.doc_type = '0110000061000000001' 
		sql.append("   sum(case  when t.doc_type = '0110000061000000087'  then  1  else  0  end) n3, "); //or t.doc_type = '0110000061100000020'
		sql.append("   sum(case  when t.doc_type = '0110000061000000072' then  1  else  0  end) n4, ");
		sql.append("   sum(case  when t.doc_type = '0110000061100000021' then  1  else  0  end) n5, ");
		sql.append("   sum(case  when t.doc_type = '0110000061100000023'   then  1  else  0  end) n6, ");//t.doc_type = '0110000061100000043'  or
		sql.append("   sum(case  when t.doc_type = '5000100106000000003'   then  1  else  0  end) n7  ");//t.doc_type = '0110000061100000024'  or 
	    sql.append("   from (select t.project_info_no, t.business_type doc_type   from  gp_ws_tecnical_basic t  where t.bsflag = '0'  and t.business_type in  ('0110000061000000050',  '5110000057000000005',   '0110000061000000087',    '0110000061000000072','0110000061100000021','0110000061100000023','5000100106000000003')) t  left join gp_task_project  pt  on pt.project_info_no= t.project_info_no    group by t.project_info_no,pt.project_name ,pt.project_type  ) t1  ");
		sql.append("   full join  (select t.project_info_no,pt.project_name,pt.project_type, ");		
		sql.append("   sum(case  when t.doc_type = '0110000061000000070' then  1  else  0  end) n8,");
		sql.append("   sum(case  when t.doc_type = '0110000061000000075' then  1  else  0  end) n9,");
		sql.append("   sum(case  when t.doc_type = '0110000061100000051' then  1  else  0  end) n10,");
		sql.append("   sum(case  when t.doc_type = '0110000061100000049' then  1  else  0  end) n11,");
		sql.append("   sum(case  when t.doc_type = '0110000061100000050' then  1  else  0  end) n12  "); 
		sql.append("   from (select t.project_info_no, t.doc_type   from  bgp_doc_gms_file t  where t.bsflag = '0'  and t.doc_type in  ('0110000061000000070',  '0110000061000000075',  '0110000061100000051',  '0110000061100000049',  '0110000061100000050' )) t  left join gp_task_project  pt  on pt.project_info_no= t.project_info_no    group by t.project_info_no,pt.project_name ,pt.project_type ) t2    on t1.project_info_no = t2.project_info_no    ) t3  ");

		sql.append("  left join ( ");
		sql.append("select distinct t.project_info_no,t.project_name, s.org_subjection_id,t.is_main_project, t.project_status from gp_task_project t  ");
		sql.append(" inner join gp_task_project_dynamic dy on dy.project_info_no = t.project_info_no  and dy.exploration_method = t.exploration_method  and dy.bsflag = '0'  and dy.org_subjection_id like '").append(orgSubjectionId).append("%' ");		
		sql.append(" inner join comm_org_subjection s on dy.org_id=s.org_id and s.bsflag='0' ");		
		sql.append(" join comm_org_information oi on dy.org_id = oi.org_id  and oi.org_name like '%%' ");
		//sql.append(" join comm_coding_sort_detail ccsd on t.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ");
		//sql.append(" join comm_coding_sort_detail ccsd1 on t.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ");
		sql.append(" where t.bsflag='0' and t.project_name like '%%'    and t.project_status like '%%' order by t.project_name ");
		sql.append(" ) t on t.project_info_no=t3.project_info_no  where 1=1  and  t3.project_type='5000100004000000008' ");

		if(projectInfoNo != null && !"".equals(projectInfoNo)){
			sql.append(" and t3.project_info_no='").append(projectInfoNo).append("' ");
		}
		 
		if(project_status != null && !"".equals(project_status)){
			sql.append(" and t.project_status='").append(project_status).append("' ");
		}
		if(s_org_id != null && !"".equals(s_org_id)){
			sql.append(" and t.org_subjection_id like '").append(s_org_id).append("%' ");
		}
				
		List templist = jdbcDAO.queryRecords(sql.toString());
				
		responseDTO.setValue("detailInfo", templist);
		
		return responseDTO;
	}

//查询井中项目业务 技术单首页面3
public ISrvMsg queryChartListJZ(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);	
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = user.getSubOrgIDofAffordOrg();

		String s_org_id = reqDTO.getValue("s_org_id");
		String is_main_project = reqDTO.getValue("is_main_project");
		String project_status = reqDTO.getValue("project_status");

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
				
		StringBuffer sql = new StringBuffer(" select t.project_type, t.project_name, t3.*   from (select   t2.project_info_no ,  nvl(t2.n7, 0) || '-' || nvl(t2.d7, 0) n7,  nvl(t2.n8, 0) || '-' || nvl(t2.d8, 0) n8,  nvl(t2.n9, 0) || '-' || nvl(t2.d9, 0) n9,  nvl(t2.n10, 0) || '-' || nvl(t2.d10, 0) n10,  nvl(t2.n11, 0) || '-' || nvl(t2.d11, 0) n11  from (  ");		
	 
		sql.append(" select p.project_info_no, ");
		sql.append(" sum(case when p.doc_type='0110000061000000042' then 1 else 0 end ) n7,  ");
		sql.append(" sum(case when p.check_type='0' and p.doc_type = '0110000061000000042' then 1 else 0 end ) d7,  ");
		sql.append(" sum(case when p.doc_type='0110000061000000043' then 1 else 0 end ) n8,  ");
		sql.append(" sum(case when p.check_type='0' and p.doc_type = '0110000061000000043' then 1 else 0 end ) d8,  ");
		sql.append(" sum(case when p.doc_type='0110000061000000078' then 1 else 0 end ) n9, ");
		sql.append(" sum(case when p.check_type='0' and p.doc_type = '0110000061000000078' then 1 else 0 end ) d9,  ");
		sql.append(" sum(case when p.doc_type='0110000061000000096' then 1 else 0 end ) n10, ");
		sql.append(" sum(case when p.check_type='0' and p.doc_type = '0110000061000000096' then 1 else 0 end ) d10,  ");
		sql.append(" sum(case when p.doc_type='0110000061000000087' then 1 else 0 end ) n11,  ");
		sql.append(" sum(case when p.check_type='0' and p.doc_type = '0110000061000000087' then 1 else 0 end ) d11  ");
		sql.append(" from ( select t.project_info_no, t.doc_type,t.check_type from bgp_doc_td_file_check t where t.bsflag = '0' and t.check_type in ('0','1') ");
		sql.append(" and t.doc_type in ('0110000061000000042','0110000061000000043','0110000061000000078','0110000061000000096','0110000061000000087') ");
		sql.append("  ) p  group by p.project_info_no  ");
		sql.append(" ) t2   ) ");
		sql.append("  t3 left join ( ");
		sql.append("select distinct t.project_info_no,t.project_type,t.project_name, s.org_subjection_id,t.is_main_project, t.project_status from gp_task_project t  ");
		sql.append(" inner join gp_task_project_dynamic dy on dy.project_info_no = t.project_info_no  and dy.exploration_method = t.exploration_method  and dy.bsflag = '0'  and dy.org_subjection_id like '").append(orgSubjectionId).append("%' ");		
		sql.append(" inner join comm_org_subjection s on dy.org_id=s.org_id and s.bsflag='0' ");		
		sql.append(" join comm_org_information oi on dy.org_id = oi.org_id  and oi.org_name like '%%' ");
		//sql.append(" join comm_coding_sort_detail ccsd on t.manage_org = ccsd.coding_code_id and ccsd.bsflag = '0' ");
		//sql.append(" join comm_coding_sort_detail ccsd1 on t.market_classify = ccsd1.coding_code_id and ccsd1.bsflag = '0' ");
		sql.append(" where t.bsflag='0' and t.project_name like '%%' and t.project_type like '%%'    and t.project_status like '%%' order by t.project_name ");
		sql.append(" ) t on t.project_info_no=t3.project_info_no  where 1=1  and t.project_type ='5000100004000000008' ");

		if(projectInfoNo != null && !"".equals(projectInfoNo)){
			sql.append(" and t3.project_info_no='").append(projectInfoNo).append("' ");
		}
	 
		if(project_status != null && !"".equals(project_status)){
			sql.append(" and t.project_status='").append(project_status).append("' ");
		}
		if(s_org_id != null && !"".equals(s_org_id)){
			sql.append(" and t.org_subjection_id like '").append(s_org_id).append("%' ");
		}
				
		List templist = jdbcDAO.queryRecords(sql.toString());
				
		responseDTO.setValue("detailInfo", templist);
		
		return responseDTO;
	}
 
    /**
     * 
    * @Title: processDocValuesInfo
    * @Description: 处理文档字段值
    * @param @param docType
    * @param @param fieldId
    * @param @return    设定文件
    * @return String    返回类型
    * @throws
     */
	public String processDocValuesInfo(String docType,String fieldId,String contextPath)
	{
		Map values = processDocValueInfo(fieldId);
		if(values == null || values.isEmpty()){
			return "";
		}
		List<Map> ls = queryDocFieldInfo(docType);
		if (ls == null || ls.isEmpty())
			return "";

		StringBuffer sb = new StringBuffer("");

		for (int i = 0; i < ls.size(); i++)
		{
			Map map = ls.get(i);

			//处理时间
			String fieldType = (String)map.get("field_type");
			StringBuffer dateField = new StringBuffer("");
			if(("date").equalsIgnoreCase(fieldType)){
				dateField.append("&nbsp;&nbsp;<img src='"+contextPath+"/images/calendar.gif' id='tributton"+i+"' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(doc_"+map.get("field_en_name")+",tributton"+i+");' />");
			}
			
			if (ls.size() % 2 == 0)
			{
				if (i % 2 == 0)
				{
					sb.append("<tr> ");
					sb.append("<td class='inquire_item4'>"
							+ map.get("field_cn_name") + "：</td> ");
					String fieldEnName = (String) map.get("field_en_name");
					sb.append("<td class='inquire_form4'> <input type='text' name='doc_"
							+ fieldEnName
							+ "' id='doc_"
							+ fieldEnName
							+ "' class='input_width' value='"+values.get(fieldEnName)+"'/> "+dateField.toString()+"</td> ");

				} else
				{
					sb.append("<td class='inquire_item4'>"
							+ map.get("field_cn_name") + "：</td> ");
					String fieldEnName = (String) map.get("field_en_name");
					sb.append("<td class='inquire_form4'> <input type='text' name='doc_"
							+ fieldEnName
							+ "' id='doc_"
							+ fieldEnName
							+ "' class='input_width' value='"+values.get(fieldEnName)+"'/> "+dateField.toString()+" </td> ");
					sb.append("<tr> ");
					sb.append("</tr> ");
				}
			} else
			{
				if (i % 2 == 0)
				{
					if (i == (ls.size() - 1))
					{
						sb.append("<tr> ");
						sb.append("<td class='inquire_item4'  >"
								+ map.get("field_cn_name") + "：</td> ");
						String fieldEnName = (String) map.get("field_en_name");
						sb.append("<td class='inquire_form4'  > <input type='text' name='doc_"
								+ fieldEnName
								+ "' id='doc_"
								+ fieldEnName
								+ "' class='input_width' value='"+values.get(fieldEnName)+"' /> "+dateField.toString()+" </td> ");
						sb.append("</tr>");
					} else
					{
						sb.append("<tr> ");
						sb.append("<td class='inquire_item4'>"
								+ map.get("field_cn_name") + "：</td> ");
						String fieldEnName = (String) map.get("field_en_name");
						sb.append("<td class='inquire_form4'> <input type='text' name='doc_"
								+ fieldEnName
								+ "' id='doc_"
								+ fieldEnName
								+ "' class='input_width' value='"+values.get(fieldEnName)+"'/> "+dateField.toString()+" </td> ");
					}

				} else
				{
					sb.append("<td class='inquire_item4'>"
							+ map.get("field_cn_name") + "：</td> ");
					String fieldEnName = (String) map.get("field_en_name");
					sb.append("<td class='inquire_form4'> <input type='text' name='doc_"
							+ fieldEnName
							+ "' id='doc_"
							+ fieldEnName
							+ "' class='input_width' value='"+values.get(fieldEnName)+"'/> "+dateField.toString()+" </td> ");
					sb.append("</tr> ");
				}
			}
		}

		return sb.toString();

	}

	/**
	 * 
	* @Title: processDocFieldInfo
	* @Description: 处理文档字段
	* @param @param docType
	* @param @return    设定文件
	* @return String    返回类型
	* @throws
	 */
	public String processDocFieldInfo(String docType,String contextPath)
	{

		List<Map> ls = queryDocFieldInfo(docType);
		if (ls == null || ls.isEmpty())
			return "";

		StringBuffer sb = new StringBuffer("");

		for (int i = 0; i < ls.size(); i++)
		{
			Map map = ls.get(i);
			//处理时间
			String fieldType = (String)map.get("field_type");
			StringBuffer dateField = new StringBuffer("");
			if(("date").equalsIgnoreCase(fieldType)){
				dateField.append("&nbsp;&nbsp;<img src='"+contextPath+"/images/calendar.gif' id='tributton"+i+"' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(doc_"+map.get("field_en_name")+",tributton"+i+");' />");
			}
			
			if (ls.size() % 2 == 0)
			{
				if (i % 2 == 0)
				{
					sb.append("<tr> ");
					sb.append("<td class='inquire_item4'>"
							+ map.get("field_cn_name") + "：</td> ");
					String fieldEnName = (String) map.get("field_en_name");
					sb.append("<td class='inquire_form4'> <input type='text' name='doc_"
							+ fieldEnName
							+ "' id='doc_"
							+ fieldEnName
							+ "' class='input_width'/>"+dateField.toString()+"</td> ");

				} else
				{
					sb.append("<td class='inquire_item4'>"
							+ map.get("field_cn_name") + "：</td> ");
					String fieldEnName = (String) map.get("field_en_name");
					sb.append("<td class='inquire_form4'> <input type='text' name='doc_"
							+ fieldEnName
							+ "' id='doc_"
							+ fieldEnName
							+ "' class='input_width'/>"+dateField.toString()+"</td> ");
					sb.append("<tr> ");
					sb.append("</tr> ");
				}
			} else
			{
				if (i % 2 == 0)
				{
					if (i == (ls.size() - 1))
					{
						sb.append("<tr> ");
						sb.append("<td class='inquire_item4'  >"
								+ map.get("field_cn_name") + "：</td> ");
						String fieldEnName = (String) map.get("field_en_name");
						sb.append("<td class='inquire_form4'  > <input type='text' name='doc_"
								+ fieldEnName
								+ "' id='doc_"
								+ fieldEnName
								+ "' class='input_width'/>"+dateField.toString()+"</td> ");
						sb.append("</tr>");
					} else
					{
						sb.append("<tr> ");
						sb.append("<td class='inquire_item4'>"
								+ map.get("field_cn_name") + "：</td> ");
						String fieldEnName = (String) map.get("field_en_name");
						sb.append("<td class='inquire_form4'> <input type='text' name='doc_"
								+ fieldEnName
								+ "' id='doc_"
								+ fieldEnName
								+ "' class='input_width'/>"+dateField.toString()+"</td> ");
					}

				} else
				{
					sb.append("<td class='inquire_item4'>"
							+ map.get("field_cn_name") + "：</td> ");
					String fieldEnName = (String) map.get("field_en_name");
					sb.append("<td class='inquire_form4'> <input type='text' name='doc_"
							+ fieldEnName
							+ "' id='doc_"
							+ fieldEnName
							+ "' class='input_width'/>"+dateField.toString()+"</td> ");
					sb.append("</tr> ");
				}
			}
		}

		return sb.toString();

	}

	/**
	 * 
	* @Title: queryDocFieldInfo
	* @Description: 查询文档字段
	* @param @param docType
	* @param @return    设定文件
	* @return List<Map>    返回类型
	* @throws
	 */
	private List<Map> queryDocFieldInfo(String docType)
	{
		if (docType == null || docType.equals(""))
		{
			return null;
		}
		String sql = "SELECT t1.field_cn_name,t1.field_en_name,t1.field_type FROM BGP_DOC_GMS_FIELD t1 where t1.doc_type = '"
				+ docType + "' and t1.field_valid='1'  order by t1.doc_field_id ";

		List<Map> ls = jdbcDao.queryRecords(sql);
		if (ls == null || ls.isEmpty())
		{
			return null;
		}
		return ls;

	}
	
	/**
	 * 
	* @Title: processDocValueInfo
	* @Description: 处理文档字段集合转换成Map数据
	* @param @param fileId
	* @param @return    设定文件
	* @return Map    返回类型
	* @throws
	 */
	private Map processDocValueInfo(String fileId)
	{
		Map values = new HashMap();
		
		List<Map> ls = queryDocValueInfo(fileId);
		if(ls == null)
			return null;
		
		for(Map map :ls){
			values.put(map.get("doc_gms_field"), map.get("doc_gms_value"));
		}
		
		return values;

	}
	
	/**
	 * 
	* @Title: queryDocValueInfo
	* @Description: 查询文档字段值
	* @param @param fileId
	* @param @return    设定文件
	* @return List<Map>    返回类型
	* @throws
	 */
	private List<Map> queryDocValueInfo(String fileId){
		
		if (fileId == null || fileId.equals(""))
		{
			return null;
		}
		String sql = "SELECT  * FROM BGP_DOC_GMS_VALUE e where e.doc_gms_id = '"+fileId+"' ";

		List<Map> ls = jdbcDao.queryRecords(sql);
		if (ls == null || ls.isEmpty())
		{
			return null;
		}
		return ls;
	}

}
