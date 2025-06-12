package com.bgp.mcs.service.doc.service;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import oracle.stellent.ridc.model.DataObject;
import oracle.stellent.ridc.model.DataResultSet;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.flexpaper.DocConverter;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WorkFlowBean;
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
import com.sun.xml.fastinfoset.Decoder;

@SuppressWarnings( { "rawtypes", "unchecked", "unused" })
public class UcmSrv extends BaseService {
	
	public UcmSrv(){
		log = LogFactory.getLogger(UcmSrv.class);
	}

	
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
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
	//GetDocFromGMS getDocFromGMS = (GetDocFromGMS) BeanFactory.getBean("getDocsFromGMS");

	/**
	 * 上传文档到ucm
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg uploadFile(ISrvMsg isrvmsg) throws Exception {
		System.out.println("uploadFile !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ucmDocId = "";
		String last_number = (int) System.currentTimeMillis()+"";
		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;

		SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyyMMdd");
		String multiFlag = isrvmsg.getValue("isMultiProject") != null?isrvmsg.getValue("isMultiProject"):"";
		String parentFolder = isrvmsg.getValue("folder_id") != null?isrvmsg.getValue("folder_id"):"";
		String docNumber = isrvmsg.getValue("doc_number") != null?isrvmsg.getValue("doc_number"):"";
		//多项目
		if(multiFlag != ""){
			if(parentFolder == ""){
				//parentFolder是多项目的最顶层目录
				parentFolder = topParentFolder;
				//String folderName = jdbcDao.queryRecordBySQL("select f.file_id,f.file_name from bgp_doc_gms_file f where f.bsflag = '0' and f.parent_file_id is null and f.project_info_no is null and f.is_file = '0'").get("file_name").toString();
				//System.out.println("The folder name multi:"+folderName);
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
		System.out.println("The docNumber is:"+docNumber);
		
		//String checkoutStatus = isrvmsg.getValue("checkout_status");
		
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

		//System.out.println("The values is:"+parentFolder+"|"+docNumber+"|"+docTitle+"|"+docType+"|"+docImportance+"|"+docKeyword+"|"+docTemplate+"|"+docScore+"|"+docBrief);
		
		List<WSFile> fileList = mqMsg.getFiles();
		//如果不选择文件，则不执行上传文档到ucm的操作	to_date('"+today+"','YYYY-MM-DD HH24-mi-ss'
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] uploadData = uploadFile.getFileData();
			ucmDocId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
		}
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
		
		return responseDTO;

	}
	/**
	 * 删除文档
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteFile(ISrvMsg isrvmsg) throws Exception {
		
		System.out.println("deleteFile !");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String file_ids = isrvmsg.getValue("docId");		
		String[] params = file_ids.split(",");		
		String theUcmId = "";
		String fileName = "";
		String updateSql = "";
		String updateVersion = "";
		String updateLog = "";
		for(String file_id : params){
			if(file_id != ""&&file_id != null){
				//通过fileid获取到ucmid
					theUcmId = jdbcDao.queryRecordBySQL("select df.ucm_id from bgp_doc_gms_file df where df.is_file = '1' and df.file_id = '"+file_id+"'").get("ucm_id").toString();					
					fileName = jdbcDao.queryRecordBySQL("select df.file_name from bgp_doc_gms_file df where df.is_file = '1' and df.file_id = '"+file_id+"'").get("file_name").toString();					
					updateSql = "update bgp_doc_gms_file g set g.bsflag='1' where g.file_id='"+file_id+"'";
					updateVersion = "update bgp_doc_file_version g set g.bsflag='1' where g.file_id='"+file_id+"'";
					updateLog = "update bgp_doc_file_log g set g.bsflag='1' where g.file_id='"+file_id+"'";
					if(jdbcDao.executeUpdate(updateSql)>0){
						String fileVersion = jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '0' and bfv.file_id= '"+file_id+"'").get("file_version").toString();	
						System.out.println("delete, the fileVersion is:"+fileVersion);
						myUcm.docLog(file_id, fileVersion,4, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),fileName);
						jdbcDao.executeUpdate(updateVersion);
						jdbcDao.executeUpdate(updateLog);
					}
			}
		}
		
		String folder_id = isrvmsg.getValue("folderid");

		responseDTO.setValue("ucmDocId", theUcmId);
		responseDTO.setValue("folderid", folder_id);
		return responseDTO;

	}
	
	/**
	 * 通过ucmid删除文档
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteFileByUcmId(ISrvMsg isrvmsg) throws Exception {
		
		System.out.println("deleteFileByUcmId !");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String ucm_id = isrvmsg.getValue("docId");	
		String updateSql = "";
		if(ucm_id != ""&&ucm_id != null){
			updateSql = "update bgp_doc_gms_file g set g.bsflag='1' where g.file_id='"+ucm_id+"'";
			jdbcDao.executeUpdate(updateSql);
		}
		responseDTO.setValue("ucmId", ucm_id);
		return responseDTO;

	}
	
	/**
	 * 通过ucmid下载
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg downloadDocByUcmId(ISrvMsg isrvmsg) throws Exception {
		System.out.println("downloadDocByUcmId !");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String docAction = isrvmsg.getValue("action");
		String emFlag = isrvmsg.getValue("emflag");
		
		//通过fileid获取到ucmid
		String ucmId = isrvmsg.getValue("docId");
		
		if(ucmId!=""&&ucmId!=null){
			if(emFlag != ""&&emFlag!=null){
				responseDTO.setValue("emflag", emFlag);
			}			
			responseDTO.setValue("docaction", docAction);
			responseDTO.setValue("docid", ucmId);		
			responseDTO.setValue("userId", user.getUserId());
			responseDTO.setValue("orgId", user.getCodeAffordOrgID());		
			responseDTO.setValue("orgSubId", user.getSubOrgIDofAffordOrg());
		}
		return responseDTO;
	}
	
	/**
	 * 通过ucmId查看txt文件
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg viewTxtFileByUcmId(ISrvMsg isrvmsg) throws Exception {
		System.out.println("viewTxtFile !");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String docAction = isrvmsg.getValue("action");
		String emFlag = isrvmsg.getValue("emflag");
		
		//通过fileid获取到ucmid
		String ucmId = isrvmsg.getValue("docId");
		
		if(ucmId!=""&&ucmId!=null){
			if(emFlag != ""&&emFlag!=null){
				responseDTO.setValue("emflag", emFlag);
			}			
			responseDTO.setValue("docaction", docAction);
			responseDTO.setValue("docid", ucmId);		
			responseDTO.setValue("userId", user.getUserId());
			responseDTO.setValue("orgId", user.getCodeAffordOrgID());		
			responseDTO.setValue("orgSubId", user.getSubOrgIDofAffordOrg());
		}
		return responseDTO;
	}
	/**
	 * 通过fileId查看txt文件
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg viewTxtFileByFileId(ISrvMsg isrvmsg) throws Exception {
		System.out.println("viewTxtFile !");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String docAction = isrvmsg.getValue("action");
		String emFlag = isrvmsg.getValue("emflag");
		//区分是文档回收站还是文档列表的中文档
		String is_deleted = isrvmsg.getValue("isdeleted");
		
		String fileVersion = "";
		String fileId = "";
		//通过fileid获取到ucmid
		String ucmId = "";
		//通过fileid获取到ucmid
		String download_file_id = isrvmsg.getValue("docId");
		if(download_file_id != ""&&download_file_id != null){
			ucmId = jdbcDao.queryRecordBySQL("select df.ucm_id from bgp_doc_gms_file df where df.is_file = '1' and df.file_id = '"+download_file_id+"'").get("ucm_id").toString();	
		}
		
		if(ucmId!=""&&ucmId!=null){
			//下载已删除的文档bsflag = 1
			if(emFlag != ""&&emFlag!=null){
				System.out.println("emflag:"+emFlag);
				responseDTO.setValue("emflag", emFlag);
			}
			else{
				if(is_deleted!=null&&"deletedfile".equals(is_deleted)){
					fileVersion = jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '1' and bfv.version_ucm_id= '"+ucmId+"'").get("file_version").toString();	
					fileId = jdbcDao.queryRecordBySQL("select bgv.file_id from bgp_doc_file_version bgv where bgv.bsflag = '1' and bgv.version_ucm_id= '"+ucmId+"'").get("file_id").toString();
				}else{
					fileVersion = jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '0' and bfv.version_ucm_id= '"+ucmId+"'").get("file_version").toString();	
					fileId = jdbcDao.queryRecordBySQL("select bgv.file_id from bgp_doc_file_version bgv where bgv.bsflag = '0' and bgv.version_ucm_id= '"+ucmId+"'").get("file_id").toString();
				}
				responseDTO.setValue("logFileId", fileId);
				responseDTO.setValue("fileVersion", fileVersion);
			}			

		}
		responseDTO.setValue("docaction", docAction);
		responseDTO.setValue("docid", ucmId);		
		responseDTO.setValue("userId", user.getUserId());
		responseDTO.setValue("orgId", user.getCodeAffordOrgID());		
		responseDTO.setValue("orgSubId", user.getSubOrgIDofAffordOrg());

		return responseDTO;
	}

	/**
	 * 查询GMS中指定文件夹下的文档
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDocFromGMS(ISrvMsg isrvmsg) throws Exception {
		System.out.println("queryDocFromGMS !");

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

		String get_doc_name = isrvmsg.getValue("doc_name");
		String get_create_date = isrvmsg.getValue("create_date");
		String get_folder_id = isrvmsg.getValue("folder_id");
		// and t.delete_date is null

		StringBuffer querySql = new StringBuffer("select t.file_id,t.file_name,t.file_type,t.create_date,t.ucm_id from bgp_doc_gms_file t where t.bsflag='0' and t.is_file='1'");
		querySql.append(" and t.parent_file_id ='"+get_folder_id+"'");

		if (get_doc_name != "" && get_doc_name != null) {
			querySql.append(" and t.file_name like '%").append(
					URLDecoder.decode(get_doc_name.trim(), "utf-8")).append(
					"%'");
		}
		if (get_create_date != "" && get_create_date != null) {
			querySql.append(" and t.create_date like to_date('").append(
					get_create_date).append("','yyyy-mm-dd hh24:mi:ss')");
		}
		querySql.append(" order by t.create_date desc");
		page = jdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}

	/**
	 * 从ucm中下载文档
	 *
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg downloadDocOld(ISrvMsg isrvmsg) throws Exception {
		System.out.println("downloadDoc !");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ucmId = isrvmsg.getValue("docId");// 此处获取的是ucm的编号
		String docAction = isrvmsg.getValue("action");
		String emFlag = isrvmsg.getValue("emflag");
		//区分是文档回收站还是文档列表的中文档
		String is_deleted = isrvmsg.getValue("isdeleted");
		
		System.out.println("The UCMID is:"+ucmId);
		System.out.println("The docAction is:"+docAction);
		String fileVersion = "";
		String fileId = "";
		
		if(ucmId!=""&&ucmId!=null){
//			if("version".equals(docAction)){
//				fileId = jdbcDao.queryRecordBySQL("select bgv.file_id from bgp_doc_file_version bgv where bgv.bsflag = '0' and bgv.version_ucm_id= '"+ucmId+"'").get("file_id").toString();
//				responseDTO.setValue("logFileId", fileId);
//			}else{
//				fileId = jdbcDao.queryRecordBySQL("select bgf.file_id from bgp_doc_gms_file bgf where bgf.bsflag = '0' and bgf.is_file = '1' and bgf.ucm_id= '"+ucmId+"'").get("file_id").toString();
//				responseDTO.setValue("logFileId", fileId);
//			}	
			//下载已删除的文档bsflag = 1
			if(emFlag != ""&&emFlag!=null){
				System.out.println("emflag:"+emFlag);
				responseDTO.setValue("emflag", emFlag);
			}
			else{
				if(is_deleted!=null&&"deletedfile".equals(is_deleted)){
					fileVersion = jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '1' and bfv.version_ucm_id= '"+ucmId+"'").get("file_version").toString();	
					fileId = jdbcDao.queryRecordBySQL("select bgv.file_id from bgp_doc_file_version bgv where bgv.bsflag = '1' and bgv.version_ucm_id= '"+ucmId+"'").get("file_id").toString();
				}else{
					fileVersion = jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '0' and bfv.version_ucm_id= '"+ucmId+"'").get("file_version").toString();	
					fileId = jdbcDao.queryRecordBySQL("select bgv.file_id from bgp_doc_file_version bgv where bgv.bsflag = '0' and bgv.version_ucm_id= '"+ucmId+"'").get("file_id").toString();
				}
				responseDTO.setValue("logFileId", fileId);
				responseDTO.setValue("fileVersion", fileVersion);
			}			

		}
		responseDTO.setValue("docaction", docAction);
		responseDTO.setValue("docid", ucmId);		
		responseDTO.setValue("userId", user.getUserId());
		responseDTO.setValue("orgId", user.getCodeAffordOrgID());		
		responseDTO.setValue("orgSubId", user.getSubOrgIDofAffordOrg());
		return responseDTO;
	}
	
	
	/**
	 * 通过文件编号下载文件
	 *
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg downloadDoc(ISrvMsg isrvmsg) throws Exception {
		System.out.println("downloadDoc !");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ucmId = "";
		String docAction = isrvmsg.getValue("action");
		String emFlag = isrvmsg.getValue("emflag");
		//区分是文档回收站还是文档列表的中文档
		String is_deleted = isrvmsg.getValue("isdeleted");
		
		String fileVersion = "";
		String fileId = "";
		
		//通过fileid获取到ucmid
		String download_file_id = isrvmsg.getValue("docId");
		if(download_file_id != ""&&download_file_id != null){
			ucmId = jdbcDao.queryRecordBySQL("select df.ucm_id from bgp_doc_gms_file df where df.is_file = '1' and df.file_id = '"+download_file_id+"'").get("ucm_id").toString();	
		}
		
		if(ucmId!=""&&ucmId!=null){
			//下载已删除的文档bsflag = 1
			if(emFlag != ""&&emFlag!=null){
				System.out.println("emflag:"+emFlag);
				responseDTO.setValue("emflag", emFlag);
			}
			else{
				if(is_deleted!=null&&"deletedfile".equals(is_deleted)){
					if(jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '1' and bfv.version_ucm_id= '"+ucmId+"'").get("file_version") != null){
						fileVersion = jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '1' and bfv.version_ucm_id= '"+ucmId+"'").get("file_version").toString();	
					}
					if(jdbcDao.queryRecordBySQL("select bgv.file_id from bgp_doc_file_version bgv where bgv.bsflag = '1' and bgv.version_ucm_id= '"+ucmId+"'").get("file_id") != null){
						fileId = jdbcDao.queryRecordBySQL("select bgv.file_id from bgp_doc_file_version bgv where bgv.bsflag = '1' and bgv.version_ucm_id= '"+ucmId+"'").get("file_id").toString();						
					}else{
						fileId = download_file_id;
					}
				}else{
					if(jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '0' and bfv.version_ucm_id= '"+ucmId+"'")!= null){
						fileVersion = jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '0' and bfv.version_ucm_id= '"+ucmId+"'").get("file_version").toString();	
					}
					if(jdbcDao.queryRecordBySQL("select bgv.file_id from bgp_doc_file_version bgv where bgv.bsflag = '0' and bgv.version_ucm_id= '"+ucmId+"'") != null){
						fileId = jdbcDao.queryRecordBySQL("select bgv.file_id from bgp_doc_file_version bgv where bgv.bsflag = '0' and bgv.version_ucm_id= '"+ucmId+"'").get("file_id").toString();
					}else{
						fileId = download_file_id;
					}
				}
				responseDTO.setValue("logFileId", fileId);
				responseDTO.setValue("fileVersion", fileVersion);
			}			

		}
		responseDTO.setValue("docaction", docAction);
		responseDTO.setValue("docid", ucmId);		
		responseDTO.setValue("userId", user.getUserId());
		responseDTO.setValue("orgId", user.getCodeAffordOrgID());		
		responseDTO.setValue("orgSubId", user.getSubOrgIDofAffordOrg());
		return responseDTO;
	}
	
	/**
	 * 下载已删除的文档
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg downloadDeletedDoc(ISrvMsg isrvmsg) throws Exception {
		System.out.println("downloadDeletedDoc !");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ucmId = "";
		String docAction = isrvmsg.getValue("action");
		String emFlag = isrvmsg.getValue("emflag");
		//区分是文档回收站还是文档列表的中文档
		String is_deleted = isrvmsg.getValue("isdeleted");
		
		String fileVersion = "";
		String fileId = "";
		
		//通过fileid获取到ucmid
		String download_file_id = isrvmsg.getValue("docId");
		if(download_file_id != ""&&download_file_id != null){
			ucmId = jdbcDao.queryRecordBySQL("select df.ucm_id from bgp_doc_gms_file df where df.is_file = '1' and df.file_id = '"+download_file_id+"'").get("ucm_id").toString();	
		}
		
		if(ucmId!=""&&ucmId!=null){
			//下载已删除的文档bsflag = 1
			if(emFlag != ""&&emFlag!=null){
				System.out.println("emflag:"+emFlag);
				responseDTO.setValue("emflag", emFlag);
			}			
			responseDTO.setValue("docid", ucmId);
			responseDTO.setValue("docaction", docAction);				
			responseDTO.setValue("userId", user.getUserId());
			responseDTO.setValue("orgId", user.getCodeAffordOrgID());		
			responseDTO.setValue("orgSubId", user.getSubOrgIDofAffordOrg());
		}

		return responseDTO;
	}
	
	/**
	 * 通过ucmid下载已删除文档
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg downloadDeletedDocByUcmId(ISrvMsg isrvmsg) throws Exception {
		System.out.println("downloadDeletedDocByUcmId !");

		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//通过fileid获取到ucmid
		String ucmId = isrvmsg.getValue("docId");
		String docAction = isrvmsg.getValue("action");
		String emFlag = isrvmsg.getValue("emflag");
		//区分是文档回收站还是文档列表的中文档
		String is_deleted = isrvmsg.getValue("isdeleted");
		
		String fileVersion = "";
		String fileId = "";
		
		if(ucmId!=""&&ucmId!=null){
			//下载已删除的文档bsflag = 1
			if(emFlag != ""&&emFlag!=null){
				System.out.println("emflag:"+emFlag);
				responseDTO.setValue("emflag", emFlag);
			}			
			responseDTO.setValue("docid", ucmId);
			responseDTO.setValue("docaction", docAction);				
			responseDTO.setValue("userId", user.getUserId());
			responseDTO.setValue("orgId", user.getCodeAffordOrgID());		
			responseDTO.setValue("orgSubId", user.getSubOrgIDofAffordOrg());
		}

		return responseDTO;
	}

	/**
	 * 获取GMS中某个文件夹中的文档
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg getDocsInFolder(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getDocsInFolder");

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

		String folder_id = isrvmsg.getValue("folderid").equals("null")?"":isrvmsg.getValue("folderid");
		System.out.println("the folder id1 is:"+folder_id);
		String file_name = isrvmsg.getValue("file_name");
		
		String doc_type = isrvmsg.getValue("doc_type");
		System.out.println("doc_type is:"+doc_type);
		
		String doc_keyword = isrvmsg.getValue("doc_keyword");
		String doc_importance = isrvmsg.getValue("doc_importance");
		System.out.println("doc_importance is:"+doc_importance);
		
		String create_date = isrvmsg.getValue("create_date");
		
		
		//String folder_id = "8ad889f137559fb9013755c5abda0007";

		StringBuffer querySql = new StringBuffer("select t.file_id,t.file_name,t.file_type,to_char(t.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date,v.file_version,tt.maxversion,v.version_ucm_id as ucm_id,u.user_name,(case w.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end) as proc_status ");
		querySql.append(" from bgp_doc_gms_file t join bgp_doc_file_version v on t.file_id = v.file_id left outer join p_auth_user u on v.creator_id = u.user_id ");
		querySql.append(" left outer join common_busi_wf_middle w on t.file_id = w.business_id ");
		querySql.append(" join (select max(fv.file_version) as maxversion,fv.file_id as maxversionid from bgp_doc_file_version fv group by fv.file_id) tt on v.file_version=tt.maxversion and tt.maxversionid = t.file_id");
		querySql.append(" where t.bsflag='0' and t.is_file='1' and v.bsflag = '0'");
		querySql.append(" and t.parent_file_id ='"+folder_id+"'");
		if(file_name != null&&file_name != ""){
			querySql.append(" and t.file_name like '%"+file_name+"%'");
		}		
		if(doc_type != null&&doc_type != ""){
			querySql.append(" and t.file_type = '"+doc_type+"'");
		}
		if(doc_keyword != null&&doc_keyword != ""){
			querySql.append(" and t.doc_keyword like '%"+doc_keyword+"%'");
		}
		if(doc_importance != null&&doc_importance != ""){
			querySql.append(" and t.doc_importance = '"+doc_importance+"'");
		}
		if(create_date != null&&create_date != ""){
			querySql.append(" and t.create_date like to_date('"+create_date+"','yyyy-mm-dd hh24:mi:ss')");
		}
		
		querySql.append(" and t.ucm_id is not null");		
		querySql.append(" order by t.create_date desc");

		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}
	/**
	 * 获取GMS中某个文件的详细信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDocInfo(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getDocInfo !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		
		
		UserToken user = isrvmsg.getUserToken();
		String ucm_id = isrvmsg.getValue("ucmid");
		String is_deleted = isrvmsg.getValue("isdeleted");
		String[] params = ucm_id.split(",");		
		String theUcmId = "";
		String theFileId = "";
		DataResultSet dataResultSet = null;
		Map docInfoMap = new HashMap();
		List<String> fieldnames = new ArrayList<String> ();//ucm的各个属性名
		
		for(String fileAnducm : params){
			if(fileAnducm != ""&&fileAnducm != null){
				theFileId = fileAnducm.split(":")[0];
				if(theFileId != ""&&theFileId != null){
					theUcmId = jdbcDao.queryRecordBySQL("select df.ucm_id from bgp_doc_gms_file df where df.file_id = '"+theFileId+"'").get("ucm_id").toString();	
				}
			}			
		}		

		if(theUcmId != ""&&theUcmId != null){
			System.out.println("The ucmid is "+theUcmId+"!!");
			dataResultSet = myUcm.getDocInfo(theUcmId);
	        for (DataResultSet.Field field:dataResultSet.getFields ()) {
	            fieldnames.add (field.getName ());
	        }

	        for (DataObject row:dataResultSet.getRows ()) {
	            System.out.println();

	            //Loop through each fieldname and get the value，row.get (field) 获取到对应field的值
	            for (String field:fieldnames) {
	            	docInfoMap.put(field, row.get (field)); //把键和值对应到map中
	            }

	        }
	        float dFileSize = (Float.parseFloat(dataResultSet.getRows().get(0).get("dFileSize")))/1024;

	        float docSize =  (float)(Math.round(dFileSize*100))/100;
	        
	        docInfoMap.put("doc_size", docSize+"K");
		}		
        
        String docImportance = "";
        String docKeyword = "empty";
        String docScore = "";
        String docTemplate = "";
        String docBrief = "";
        String docType = "";
        
		//String folder_id = isrvmsg.getValue("folderid");

		//String updateSql = "update bgp_doc_gms_file g set g.bsflag='1' where g.ucm_id='"+ucm_id+"'";
		//if(jdbcDao.executeUpdate(updateSql)>0){
		//	myUcm.deleteFile(ucm_id);
		//}
        //获取文档表主键
        String queryDocId = "";
        if(is_deleted!=null&"deletedfile".equals(is_deleted)){
            queryDocId="select t.file_id,(case t.doc_importance when '1' then '高'  when '2' then '中' when '3' then '低' else '' end) as doc_importance,t.doc_keyword,t.doc_score,t.doc_template,t.doc_brief,(case t.file_type when 'word' then 'Word' when 'excel' then 'Excel' when 'ppt' then 'PowerPoint' when 'pdf' then 'PDF' when 'txt' then 'TXT' when 'picture' then '图片文件' when 'compress' then '压缩文件' when 'other' then '其他文件' else '' end) as doc_type from bgp_doc_gms_file t where t.file_id = '"+theFileId+"' and bsflag='1'";
        }else{
            queryDocId="select t.file_id,(case t.doc_importance when '1' then '高'  when '2' then '中' when '3' then '低' else '' end) as doc_importance,t.doc_keyword,t.doc_score,t.doc_template,t.doc_brief,(case t.file_type when 'word' then 'Word' when 'excel' then 'Excel' when 'ppt' then 'PowerPoint' when 'pdf' then 'PDF' when 'txt' then 'TXT' when 'picture' then '图片文件' when 'compress' then '压缩文件' when 'other' then '其他文件' else '' end) as doc_type from bgp_doc_gms_file t where t.file_id = '"+theFileId+"' and bsflag='0'";
        }
        Map map=jdbcDao.queryRecordBySQL(queryDocId);
        if(map!=null){
        	String fileId=(String) map.get("file_id");
        	docImportance = (String) map.get("doc_importance");
        	docKeyword = (String) map.get("doc_keyword");
        	docType = (String)map.get("doc_type");
        	System.out.println("The docKeyword is:"+docKeyword);
//        	if(map.get("doc_keyword") !=null&&map.get("doc_keyword")!=""){
//        		System.out.println("docKeyword bu shi kong de"+docKeyword);
//        	}else{
//        		System.out.println("docKeyword shi kong de"+docKeyword);
//        	}
        	
        	docScore = (String) map.get("doc_score");
        	docTemplate = (String) map.get("doc_template");
        	docBrief = (String) map.get("doc_brief");
        	
        	docInfoMap.put("file_id", fileId);
        	docInfoMap.put("doc_importance", docImportance);
        	
        	
        	docInfoMap.put("doc_keyword", docKeyword);
        	docInfoMap.put("doc_score", docScore);
        	docInfoMap.put("doc_template", docTemplate);
        	docInfoMap.put("doc_brief", docBrief);
        	docInfoMap.put("doc_type", docType);
        	 //获取文档流程信息
            String sql="select proc_inst_id ,proc_id,proc_status from common_busi_wf_middle where business_id ='"+fileId+"' and bsflag='0'";
            Map mapProcess=jdbcDao.queryRecordBySQL(sql);
            if(mapProcess!=null){
            	String procInstId=(String) mapProcess.get("proc_inst_id");
            	String procId=(String) mapProcess.get("proc_id");
            	String procStatus=(String) mapProcess.get("proc_status");
            	//获取审批历史记录
        		WorkFlowBean workFlowBean = (WorkFlowBean) BeanFactory.getBean("workFlowBean");
        		// 获取审批历史信息
        		List listProcHistory = workFlowBean.getProcHistory(procInstId);
        		if("1".equals(procStatus)){
        			procStatus="待审批";
        		}else if("3".equals(procStatus)){
        			procStatus="审批通过";
        		}else if("4".equals(procStatus)){
        			procStatus="审批不通过";
        		}
        		responseDTO.setValue("procStatus", procStatus);
        		responseDTO.setValue("procInstId", procInstId);
        		responseDTO.setValue("showWorkflow", isrvmsg.getValue("showWorkflow"));
        		responseDTO.setValue("listProcHistory", listProcHistory);
            }else{
            	responseDTO.setValue("procStatus", "未提交");
            }
            responseDTO.setValue("fileId", fileId);

        }
        System.out.println(isrvmsg.getValue("showWF"));
        System.out.println("The ucmdocid is:"+theUcmId);
		responseDTO.setValue("ucmDocId", theUcmId);
		responseDTO.setValue("fieldnames", fieldnames); 
		responseDTO.setValue("docInfoMap", docInfoMap); 
		return responseDTO;

	}
	
	/**
	 * 获取一条记录的附件列表
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAttachmentList(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getAttachmentList !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String relation_id = isrvmsg.getValue("relationId");
		String file_name = isrvmsg.getValue("file_name");
		String doc_type = isrvmsg.getValue("doc_type");		
		String doc_keyword = isrvmsg.getValue("doc_keyword");
		String doc_importance = isrvmsg.getValue("doc_importance");		
		String create_date = isrvmsg.getValue("create_date");

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

		StringBuffer querySql = new StringBuffer("select t.file_id,t.file_name,t.file_type,to_char(t.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date,t.ucm_id ");
		querySql.append("from bgp_doc_gms_file t join bgp_doc_file_version v on t.file_id = v.file_id,");
		querySql.append("(select max(fv.file_version) as maxversion,fv.file_id as maxversionid from bgp_doc_file_version fv group by fv.file_id) tt ");
		querySql.append("where t.bsflag='0' and t.is_file='1' and v.bsflag = '0' and v.file_version=tt.maxversion and tt.maxversionid = t.file_id");
		querySql.append(" and t.relation_id ='"+relation_id+"'");
		if(file_name != null&&file_name != ""){
			querySql.append(" and t.file_name like '%"+file_name+"%'");
		}
		if(doc_type != null&&doc_type != ""){
			querySql.append(" and t.file_type = '"+doc_type+"'");
		}
		if(doc_keyword != null&&doc_keyword != ""){
			querySql.append(" and t.doc_keyword like '%"+doc_keyword+"%'");
		}
		if(doc_importance != null&&doc_importance != ""){
			querySql.append(" and t.doc_importance = '"+doc_importance+"'");
		}
		if(create_date != null&&create_date != ""){
			querySql.append(" and t.create_date like to_date('"+create_date+"','yyyy-mm-dd hh24:mi:ss')");
		}
		querySql.append(" order by t.create_date desc");
		
		page = jdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}
	/**
	 * 获取一批相关附件列表
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAttachmentCollList(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getAttachmentList !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String relation_id = isrvmsg.getValue("relationId");
		String file_name = isrvmsg.getValue("file_name");
		String doc_type = isrvmsg.getValue("doc_type");		
		String doc_keyword = isrvmsg.getValue("doc_keyword");
		String doc_importance = isrvmsg.getValue("doc_importance");		
		String create_date = isrvmsg.getValue("create_date");

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

		StringBuffer querySql = new StringBuffer("select t.file_id,t.file_name,t.file_type,to_char(t.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date,t.ucm_id ");
		querySql.append("from bgp_doc_gms_file t join bgp_doc_file_version v on t.file_id = v.file_id,");
		querySql.append("(select max(fv.file_version) as maxversion,fv.file_id as maxversionid from bgp_doc_file_version fv group by fv.file_id) tt ");
		querySql.append("where t.bsflag='0' and t.is_file='1' and v.bsflag = '0' and v.file_version=tt.maxversion and tt.maxversionid = t.file_id");
		querySql.append(" and t.relation_id in(select id from(");
		querySql.append(" select app.scrape_apply_id as a,app.scrape_collect_id as b,app.scrape_report_id as c");
		querySql.append(" from dms_scrape_apply app where app.scrape_apply_id in(");
		querySql.append(" select t.scrape_apply_id from dms_scrape_detailed t ");
		querySql.append(" where t.foreign_dev_id ='"+relation_id+"' and t.bsflag='0')");
		querySql.append(" ) unpivot(id for jd  in(a,b,c)))");
		if(file_name != null&&file_name != ""){
			querySql.append(" and t.file_name like '%"+file_name+"%'");
		}
		if(doc_type != null&&doc_type != ""){
			querySql.append(" and t.file_type = '"+doc_type+"'");
		}
		if(doc_keyword != null&&doc_keyword != ""){
			querySql.append(" and t.doc_keyword like '%"+doc_keyword+"%'");
		}
		if(doc_importance != null&&doc_importance != ""){
			querySql.append(" and t.doc_importance = '"+doc_importance+"'");
		}
		if(create_date != null&&create_date != ""){
			querySql.append(" and t.create_date like to_date('"+create_date+"','yyyy-mm-dd hh24:mi:ss')");
		}
		querySql.append(" order by t.create_date desc");
		
		page = jdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}
	/**
	 * 获取某个文档的日志信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */

	public ISrvMsg getDocLogList(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getDocLogList !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String file_log_id = isrvmsg.getValue("theFileLogId");
		//String file_name = isrvmsg.getValue("file_name");


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


		StringBuffer querySql = new StringBuffer("select l.bgp_doc_file_log_id,l.file_id,l.doc_version_id,(case l.operation when '1' then '新增' when '2' then '下载' when '3' then '修改' when '4' then '删除' when '5' then '查看' when '6' then '还原' else '无操作' end) as doc_operation,u.user_name,to_char(l.operation_date,'yyyy-MM-dd HH24:mi:ss') as operation_date,to_char(l.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date,l.log_file_title as file_name from bgp_doc_file_log l left outer join p_auth_user u on l.operator_id = u.user_id ");
		if(file_log_id != null&&file_log_id != ""){
			querySql.append("where l.file_id = '"+file_log_id+"'");
		}
		querySql.append(" order by l.create_date desc");
		page = jdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}
	/**
	 * 获取文档版本的列表
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDocVersionList(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getDocVersionList !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String file_version_id = isrvmsg.getValue("theFileVersionId");
		//String file_name = isrvmsg.getValue("file_name");


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


		StringBuffer querySql = new StringBuffer("select v.bgp_doc_file_version_id,v.file_id,v.file_version,v.version_ucm_id,v.file_version_title as file_name,u.user_name,to_char(v.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date from bgp_doc_file_version v left outer join p_auth_user u on v.creator_id = u.user_id where v.bsflag = '0'");
		if(file_version_id != null&&file_version_id != ""){
			querySql.append(" and v.file_id = '"+file_version_id+"'");
		}
		querySql.append(" order by v.create_date desc");
		page = jdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}
	
	/**
	 * 获取已删除文档版本的列表
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeletedDocVersionList(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getDocVersionList !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String file_version_id = isrvmsg.getValue("theFileVersionId");
		//String file_name = isrvmsg.getValue("file_name");


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


		StringBuffer querySql = new StringBuffer("select v.bgp_doc_file_version_id,v.file_id,v.file_version,v.version_ucm_id,v.file_version_title as file_name,u.user_name,to_char(v.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date from bgp_doc_file_version v left outer join p_auth_user u on v.creator_id = u.user_id where v.bsflag = '1'");
		if(file_version_id != null&&file_version_id != ""){
			querySql.append(" and v.file_id = '"+file_version_id+"'");
		}
		querySql.append(" order by v.create_date desc");
		page = jdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}
	/**
	 * 获取文档所在ucm的物理位置
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDocUrl(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getDocUrl !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String ucm_id = isrvmsg.getValue("ucmId");
		String ucm_url = myUcm.getDocUrl(ucm_id);
		responseDTO.setValue("ucmUrl", ucm_url);
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
		System.out.println("The fileId in the getEditDcoInfo is:"+file_id);
        
		Map docInfoMap = new HashMap();
		
        //获取文档表主键
        String queryDocId="select t.file_id,t.file_name,t.file_number,t.file_type,t.doc_importance,t.doc_keyword,t.doc_score,t.doc_template,t.doc_brief,t.ucm_id from bgp_doc_gms_file t where t.file_id = '"+file_id+"' and bsflag='0'";
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
        }
		responseDTO.setValue("editFileId", file_id); 
		responseDTO.setValue("docInfoMap", docInfoMap); 
		return responseDTO;

	}
	/**
	 * 上传新版本的文档
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg uploadNewVersionFile(ISrvMsg isrvmsg) throws Exception {
		System.out.println("uploadNewVersionFile !");

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
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		
		System.out.println("The userId is:"+user.getUserId());
		
		String fileID = isrvmsg.getValue("file_id");
		//查询一下版本表中file_id为fileID的记录有几条
		String querySql = "select count(v.bgp_doc_file_version_id) as versioncount from bgp_doc_file_version v where v.bsflag='0' and v.file_id ='"+fileID+"'";
		Map map=jdbcDao.queryRecordBySQL(querySql);
		String docVersion = (Integer.parseInt(map.get("versioncount").toString())+1)+".0";
		
		System.out.println("The docVersion is:"+docVersion);
		
		List<WSFile> fileList = mqMsg.getFiles();
		Map paramMap = new HashMap();
		Map versionMap = new HashMap();
		//选择文件，更新基本信息,上传文档到ucm的操作
		if(fileList.size()!=0){
			WSFile uploadFile = fileList.get(0);
			byte[] uploadData = uploadFile.getFileData();
			ucmDocId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
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

	/**
	 * 检查某一项目编号是否在文档数据库表中
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkProjectExist(ISrvMsg isrvmsg) throws Exception {
		System.out.println("checkProjectExist !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		UserToken user = isrvmsg.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		String temp_folder_id = "8ad891ad3a06a863013a07ec2d2a0004";
		if(project_info_no !="" &&project_info_no != null){
			System.out.println("选择了项目，项目不为空");
			String project_name = user.getProjectName();
			Map folderInfoMap = new HashMap();
			String checkSql = "select count(*) as projectcount from bgp_doc_gms_file t where t.project_info_no = '"+project_info_no+"' and t.bsflag = '0' and t.is_file = '0' and t.is_template is null and t.parent_file_id is null";
			if(Integer.parseInt(jdbcDao.queryRecordBySQL(checkSql).get("projectcount").toString())== 0){
				//该数据不存在，需要插入
				System.out.println("该项目不存在");
//				myUcm.setTemplateNew(temp_folder_id, user.getProjectInfoNo(), user.getProjectName(), user.getUserId(), user.getOrgId(), user.getOrgSubjectionId());
//				folderInfoMap.put("file_name", project_name);
//				folderInfoMap.put("project_info_no", project_info_no);
//				folderInfoMap.put("bsflag", "0");
//				folderInfoMap.put("create_date", new Date());
//				folderInfoMap.put("creator_id", user.getUserId());
//				folderInfoMap.put("modifi_date", new Date());
//				folderInfoMap.put("updator_id", user.getUserId());
//				folderInfoMap.put("is_file", "0");
//				folderInfoMap.put("file_abbr", "root");
//				folderInfoMap.put("file_number_format", "8ad8913d382176330138226e8e3f00fe");
//				folderInfoMap.put("org_id", user.getCodeAffordOrgID());
//				folderInfoMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
//				jdbcDao.saveOrUpdateEntity(folderInfoMap, "bgp_doc_gms_file");
			}else{
				System.out.println("该项目已存在");
			}
		}else{
			System.out.println("没选项目");
		}
		return responseDTO;

	}
	/**
	 * 查询多项目的根节点东方地球物理公司是否存在
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkBGPExist(ISrvMsg isrvmsg) throws Exception {
		System.out.println("checkBGPExist !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		UserToken user = isrvmsg.getUserToken();
		String project_info_no = user.getProjectInfoNo();

			Map folderInfoMap = new HashMap();
			String checkSql = "select count(f.file_name) as projectcount from bgp_doc_gms_file f where f.bsflag = '0' and f.parent_file_id is null and f.project_info_no is null and f.is_file = '0'";
			if(Integer.parseInt(jdbcDao.queryRecordBySQL(checkSql).get("projectcount").toString())== 0){
				//BGP不存在，需要插入
				System.out.println("BGP不存在");
				folderInfoMap.put("file_name", "东方地球物理公司");
				folderInfoMap.put("bsflag", "0");
				folderInfoMap.put("create_date", new Date());
				folderInfoMap.put("creator_id", user.getUserId());
				folderInfoMap.put("modifi_date", new Date());
				folderInfoMap.put("updator_id", user.getUserId());
				folderInfoMap.put("is_file", "0");
				folderInfoMap.put("file_abbr", "BGProot");
				//folderInfoMap.put("file_number_format", "8ad8913d382176330138226e8e3f00fe");
				folderInfoMap.put("file_number_format", fileNumberFormat);
				folderInfoMap.put("org_id", user.getCodeAffordOrgID());
				folderInfoMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				jdbcDao.saveOrUpdateEntity(folderInfoMap, "bgp_doc_gms_file");
			}else{
				System.out.println("BGP已存在");
			}
		return responseDTO;

	}
	/**
	 * 给模块分配文件夹
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg setMenuFolder(ISrvMsg isrvmsg) throws Exception {
		System.out.println("setMenuFolder !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		String moduleId = isrvmsg.getValue("moduleId");
		String moduleText = isrvmsg.getValue("moduleText");
		String[] folderIds = isrvmsg.getValue("folderids").split(",");
		String[] folderTexts = isrvmsg.getValue("folderTexts").split(",");
		String multiFlag = isrvmsg.getValue("isMultiProject") != null?isrvmsg.getValue("isMultiProject"):"";
		
		String operationFlag = "success";
		 
		
 		for(int i=0;i<folderIds.length;i++){
			Map paramMap = new HashMap();
			paramMap.put("module_id", moduleId);
			paramMap.put("module_name", moduleText);
			paramMap.put("folder_id", folderIds[i].toString());
			paramMap.put("folder_name", folderTexts[i].toString());
			paramMap.put("bsflag", "0");
			paramMap.put("create_date", new Date());			
			paramMap.put("creator_id", user.getUserId());
			paramMap.put("modifi_date", new Date());
			paramMap.put("updator_id", user.getUserId());
			if(multiFlag == ""){
				paramMap.put("project_info_no", user.getProjectInfoNo());
			}			
			paramMap.put("org_id", user.getCodeAffordOrgID());
			paramMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			try {
				jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
			} catch (Exception e) {
				operationFlag = "failed";
			}
		}


		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	/**
	 * 取消模块和文件夹的对应关系
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteModuleAndFolder(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteModuleAndFolder !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String module_id = isrvmsg.getValue("moduleId");	
		String multiFlag = isrvmsg.getValue("isMultiProject") != null?isrvmsg.getValue("isMultiProject"):"";
		String operationFlag = "success";
		try {
			//是多项目,删除项目编号为空的数据
			if(multiFlag != ""){
				System.out.println("多项目");
				jdbcDao.executeUpdate("delete from bgp_doc_folder_module g where g.module_id='"+module_id+"' and g.project_info_no is null");
			}
			//是单项目,删除项目编号为对应项目的数据
			else{
				System.out.println("单项目");
				jdbcDao.executeUpdate("delete from bgp_doc_folder_module g where g.module_id='"+module_id+"' and g.project_info_no = '"+user.getProjectInfoNo()+"'");
			}
			
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;

	}
	/**
	 * 设置新的模块和文件夹的关系:先要删除原有的关系，再建立新的关系
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg setNewMenuFolder(ISrvMsg isrvmsg) throws Exception {
		System.out.println("setNewMenuFolder !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		
		String moduleId = isrvmsg.getValue("moduleId");
		String moduleText = isrvmsg.getValue("moduleText");
		String multiFlag = isrvmsg.getValue("isMultiProject") != null?isrvmsg.getValue("isMultiProject"):"";

		//是多项目,删除项目编号为空的数据
		if(multiFlag != ""){
			System.out.println("多项目");
			jdbcDao.executeUpdate("delete from bgp_doc_folder_module g where g.module_id='"+moduleId+"' and g.project_info_no is null");
		}
		//是单项目,删除项目编号为对应项目的数据
		else{
			System.out.println("单项目");
			jdbcDao.executeUpdate("delete from bgp_doc_folder_module g where g.module_id='"+moduleId+"' and g.project_info_no = '"+user.getProjectInfoNo()+"'");
		}
		
		String operationFlag = "success";
		
		String[] folderIds = isrvmsg.getValue("folderids").split(",");
		System.out.println("The folder:"+folderIds);
		String[] folderTexts = isrvmsg.getValue("folderTexts").split(",");
 		for(int i=0;i<folderIds.length;i++){
			Map paramMap = new HashMap();
			paramMap.put("module_id", moduleId);
			paramMap.put("module_name", moduleText);
			paramMap.put("folder_id", folderIds[i].toString());
			paramMap.put("folder_name", folderTexts[i].toString());
			paramMap.put("bsflag", "0");
			paramMap.put("create_date", new Date());			
			paramMap.put("creator_id", user.getUserId());
			paramMap.put("modifi_date", new Date());
			paramMap.put("updator_id", user.getUserId());
			if(multiFlag == ""){
				paramMap.put("project_info_no", user.getProjectInfoNo());
			}
			paramMap.put("org_id", user.getCodeAffordOrgID());
			paramMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
			try {
				jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
			} catch (Exception e) {
				operationFlag = "failed";
			}
		}
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 文档的编号形式
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveNumberFormat(ISrvMsg isrvmsg) throws Exception {
		System.out.println("saveNumberFormat !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		
		String folder_abbr = isrvmsg.getValue("userfolderabbr");
		String use_year = isrvmsg.getValue("useyear");
		String use_month = isrvmsg.getValue("usemonth");
		String use_day = isrvmsg.getValue("useday");
		String serial_length = isrvmsg.getValue("seriallength");
		String number_prefix = isrvmsg.getValue("numberprefix");
		String number_name = isrvmsg.getValue("numbername");
		System.out.println("numbername is:"+number_name);
		String file_number_value = isrvmsg.getValue("savetext");
		String operationFlag = "success";
		
		Map saveNumberMap = new HashMap();
		saveNumberMap.put("use_file_abb", folder_abbr);
		saveNumberMap.put("use_year", use_year);
		saveNumberMap.put("use_month", use_month);
		saveNumberMap.put("use_day", use_day);
		saveNumberMap.put("serial_length", serial_length);
		saveNumberMap.put("file_number_prefix", number_prefix);
		saveNumberMap.put("file_number_name", number_name);
		saveNumberMap.put("file_number_value", file_number_value);
		saveNumberMap.put("bsflag", "0");
		saveNumberMap.put("create_date", new Date());			
		saveNumberMap.put("creator_id", user.getUserId());
		saveNumberMap.put("modifi_date", new Date());
		saveNumberMap.put("updator_id", user.getUserId());
		saveNumberMap.put("org_id", user.getCodeAffordOrgID());
		saveNumberMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		
		try {
			jdbcDao.saveOrUpdateEntity(saveNumberMap, "bgp_doc_file_number");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 获取文档编号规则
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getFileNumber(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getFileNumber");

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

		String file_number_name = isrvmsg.getValue("number_name");
		String file_number_value = isrvmsg.getValue("number_value");

		StringBuffer querySql = new StringBuffer("select t.bgp_doc_file_number_id,t.file_number_name,t.file_number_value,to_char(t.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date from bgp_doc_file_number t where t.bsflag = '0' ");
		if(file_number_name != null&&file_number_name != ""){
			querySql.append(" and t.file_number_name like '%"+file_number_name+"%'");
		}		
		if(file_number_value != null&&file_number_value != ""){
			querySql.append(" and t.file_number_value like '%"+file_number_value+"%'");
		}
				
		querySql.append(" order by t.create_date desc");

		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}
	
	/**
	 * 删除编号形式
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteFileNumber(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteFileNumber !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String file_number_id = isrvmsg.getValue("fileNumberId");
		String updateSql = "";
		if(file_number_id != ""&&file_number_id != null){
			updateSql = "update bgp_doc_file_number g set g.bsflag='1' where g.bgp_doc_file_number_id='"+file_number_id+"'";
		}
		jdbcDao.executeUpdate(updateSql);
		return responseDTO;

	}
	
	/**
	 * 获取编号形式的详细信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getFileNumberInfo(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getFileNumberInfo !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String file_number_id = isrvmsg.getValue("fileNumberId");
		Map file_number_map = new HashMap();
        String queryDocId="select t.file_number_name,t.file_number_value,t.file_number_prefix,t.use_file_abb,t.use_year,t.use_month,t.use_day,t.serial_length,to_char(t.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date,u.user_name as creator_name from bgp_doc_file_number t left outer join p_auth_user u on t.creator_id = u.user_id where t.bsflag = '0' and t.bgp_doc_file_number_id ='"+file_number_id+"'";
        Map map=jdbcDao.queryRecordBySQL(queryDocId);
        if(map!=null){
        	file_number_map.put("fileNumberName", (String) map.get("file_number_name"));
        	file_number_map.put("fileNumberValue", (String) map.get("file_number_value"));
        	file_number_map.put("createDate", (String) map.get("create_date"));
        	file_number_map.put("creatorName", (String) map.get("creator_name"));

        	file_number_map.put("fileNumberPrefix", (String) map.get("file_number_prefix"));
        	file_number_map.put("fileAbb", (String) map.get("use_file_abb"));
        	file_number_map.put("useYear", (String) map.get("use_year"));
        	file_number_map.put("useMonth", (String) map.get("use_month"));
        	
          	file_number_map.put("useDay", (String) map.get("use_day"));
        	file_number_map.put("serialLength", (String) map.get("serial_length"));
        	responseDTO.setValue("fileNumberMap", file_number_map); 
        }
		return responseDTO;
	}
	/**
	 * 更新文档编号形式
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateFileNumber(ISrvMsg isrvmsg) throws Exception {
		System.out.println("updateFileNumber !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		
		String file_number_id = isrvmsg.getValue("filenumberid");
		String folder_abbr = isrvmsg.getValue("userfolderabbr");
		String use_year = isrvmsg.getValue("useyear");
		String use_month = isrvmsg.getValue("usemonth");
		String use_day = isrvmsg.getValue("useday");
		String serial_length = isrvmsg.getValue("seriallength");
		String number_prefix = isrvmsg.getValue("numberprefix");
		String number_name = isrvmsg.getValue("numbername");		
		String file_number_value = isrvmsg.getValue("saveText");
		String operationFlag = "success";
		
		Map saveNumberMap = new HashMap();
		saveNumberMap.put("bgp_doc_file_number_id", file_number_id);
		saveNumberMap.put("use_file_abb", folder_abbr);
		saveNumberMap.put("use_year", use_year);
		saveNumberMap.put("use_month", use_month);
		saveNumberMap.put("use_day", use_day);
		saveNumberMap.put("serial_length", serial_length);
		saveNumberMap.put("file_number_prefix", number_prefix);
		saveNumberMap.put("file_number_name", number_name);
		saveNumberMap.put("file_number_value", file_number_value);
		saveNumberMap.put("bsflag", "0");
		saveNumberMap.put("create_date", new Date());			
		saveNumberMap.put("creator_id", user.getUserId());
		saveNumberMap.put("modifi_date", new Date());
		saveNumberMap.put("updator_id", user.getUserId());
		saveNumberMap.put("org_id", user.getCodeAffordOrgID());
		saveNumberMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		
		try {
			jdbcDao.saveOrUpdateEntity(saveNumberMap, "bgp_doc_file_number");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 分配新的编号样式
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	
	public ISrvMsg setNewNumberFormat(ISrvMsg isrvmsg) throws Exception {
		System.out.println("setNewNumberFormat !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String file_number_id = isrvmsg.getValue("formatId");
		String folder_id = isrvmsg.getValue("folderId");
		String updateSql = "";
		if(file_number_id != ""&&file_number_id != null && folder_id != ""&&folder_id != null){
			updateSql = "update bgp_doc_gms_file g set g.file_number_format='"+file_number_id+"' where g.file_id='"+folder_id+"'";
		}
		if(jdbcDao.executeUpdate(updateSql)>0){
			String format_value = jdbcDao.queryRecordBySQL("select t.file_number_name from bgp_doc_file_number t where t.bsflag = '0' and t.bgp_doc_file_number_id= '"+file_number_id+"'").get("file_number_name").toString();	
			responseDTO.setValue("numberFormatValue", format_value);
		}
		return responseDTO;
	}
	
	/**
	 * 获取所有文档结构模板
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getFolderTemplate(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getFolderTemplate");

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

		String template_name = isrvmsg.getValue("template_name");

//		StringBuffer querySql = new StringBuffer("select t.file_id,t.file_name,t.create_date,u.user_name,(case t.is_template_used when '0' then '未使用' when '1' then '已使用' else '无值' end) as is_template_used from bgp_doc_gms_file t left outer join p_auth_user u on t.creator_id = u.user_id where t.bsflag = '0' and t.is_template = '1' and t.parent_file_id is null ");
		StringBuffer querySql = new StringBuffer("select t.is_template ,t.file_abbr,t.file_id,t.file_name,t.create_date,u.user_name,(case t.is_template_used when '0' then '未使用' when '1' then '已使用' else '无值' end) as is_template_used from bgp_doc_gms_file t left outer join p_auth_user u on t.creator_id = u.user_id where t.bsflag = '0'  and t.is_template is not null  and t.parent_file_id is null ");
		if(template_name != null&&template_name != ""){
			querySql.append("and t.file_name like '%"+template_name+"%'");
		}					
		querySql.append(" order by t.create_date desc");

		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;
	}
	/**
	 * 获取文档模板信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTemplateInfo(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getTemplateInfo !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		UserToken user = isrvmsg.getUserToken();
		String template_id = isrvmsg.getValue("templateID");	
        
		Map docInfoMap = new HashMap();
		
//        String queryDocId="select t.file_id,t.file_name,t.file_abbr,to_char(t.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date,u.user_name,(case t.is_template_used when '0' then '未使用' when '1' then '已使用' else '无值' end) as is_template_used,is_template from bgp_doc_gms_file t left outer join p_auth_user u on t.creator_id = u.user_id where t.bsflag = '0' and t.is_template = '1' and t.parent_file_id is null and t.file_id = '"+template_id+"'";
		String queryDocId="select t.file_id,t.file_name,t.file_abbr,to_char(t.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date,u.user_name,(case t.is_template_used when '0' then '未使用' when '1' then '已使用' else '无值' end) as is_template_used,is_template from bgp_doc_gms_file t left outer join p_auth_user u on t.creator_id = u.user_id where t.bsflag = '0'  and t.parent_file_id is null and t.file_id = '"+template_id+"'";
        Map map=jdbcDao.queryRecordBySQL(queryDocId);
        if(map!=null){
        	
        	docInfoMap.put("template_id", (String) map.get("file_id"));
        	docInfoMap.put("template_name", (String) map.get("file_name"));
        	docInfoMap.put("template_abbr", (String) map.get("file_abbr"));
        	docInfoMap.put("create_date", (String) map.get("create_date"));
        	docInfoMap.put("user_name", (String) map.get("user_name"));
        	docInfoMap.put("is_template_used", (String) map.get("is_template_used"));
        	//
        	docInfoMap.put("is_template", (String) map.get("is_template"));
        }
		responseDTO.setValue("editFileId", template_id); 
		responseDTO.setValue("docInfoMap", docInfoMap); 
		return responseDTO;

	}
	/**
	 * 删除模板
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteTemplate(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteTemplate !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String template_id = isrvmsg.getValue("templateID");
		String updateSql = "";
		if(template_id != ""&&template_id != null){
			updateSql = "update bgp_doc_gms_file g set g.bsflag='1' where g.file_id='"+template_id+"'";
		}
		jdbcDao.executeUpdate(updateSql);
		return responseDTO;

	}
	
	/**
	 * 新增文档结构模板
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addTemplate(ISrvMsg isrvmsg) throws Exception {
		System.out.println("addTemplate !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		
		String template_name = isrvmsg.getValue("template_name");
		String template_abbr = isrvmsg.getValue("template_abbr");
		//添加模版类型
		String is_template = isrvmsg.getValue("is_template");
		
		String operationFlag = "success";
		
		Map saveTemplateMap = new HashMap();
		saveTemplateMap.put("file_name", template_name);
		saveTemplateMap.put("file_abbr", template_abbr);
		//saveTemplateMap.put("file_number_format", "8ad8913d382176330138226e8e3f00fe");
		saveTemplateMap.put("file_number_format", fileNumberFormat);
		saveTemplateMap.put("bsflag", "0");
		saveTemplateMap.put("is_file", "0");
		saveTemplateMap.put("create_date", new Date());			
		saveTemplateMap.put("creator_id", user.getUserId());
		saveTemplateMap.put("modifi_date", new Date());
		saveTemplateMap.put("updator_id", user.getUserId());
		saveTemplateMap.put("org_id", user.getCodeAffordOrgID());
		saveTemplateMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		saveTemplateMap.put("is_template", is_template);
		saveTemplateMap.put("template_name", template_abbr);
		saveTemplateMap.put("is_template_used", "0");	
		
		try {
			jdbcDao.saveOrUpdateEntity(saveTemplateMap, "bgp_doc_gms_file");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 修改文档结构模板信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg editTemplateInfo(ISrvMsg isrvmsg) throws Exception {
		System.out.println("editTemplateInfo !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		
		String template_name = isrvmsg.getValue("template_name");
		String template_abbr = isrvmsg.getValue("template_abbr");
		String template_id = isrvmsg.getValue("template_id") !=null ? isrvmsg.getValue("template_id"):"";
		String operationFlag = "success";
		
		Map saveTemplateMap = new HashMap();
		saveTemplateMap.put("file_id", template_id);
		saveTemplateMap.put("file_name", template_name);
		saveTemplateMap.put("file_abbr", template_abbr);
		saveTemplateMap.put("modifi_date", new Date());
		saveTemplateMap.put("updator_id", user.getUserId());
		saveTemplateMap.put("org_id", user.getCodeAffordOrgID());
		saveTemplateMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
		
		try {
			jdbcDao.saveOrUpdateEntity(saveTemplateMap, "bgp_doc_gms_file");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 获取已删除的文档
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeletedDocsInFolder(ISrvMsg isrvmsg) throws Exception {

		System.out.println("getDeletedDocsInFolder");

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

		String folder_id = isrvmsg.getValue("folderid") !=null?isrvmsg.getValue("folderid"):"";
		String file_name = isrvmsg.getValue("file_name");
		String doc_type = isrvmsg.getValue("doc_type");
		String doc_keyword = isrvmsg.getValue("doc_keyword");
		String doc_importance = isrvmsg.getValue("doc_importance");
		String create_date = isrvmsg.getValue("create_date");
		String project_info_no = user.getProjectInfoNo() !=null?user.getProjectInfoNo():"";
		
		StringBuffer querySql = new StringBuffer("select t.file_id,t.file_name,t.ucm_id,t.file_type,t.doc_keyword,t.doc_importance,u.user_name,to_char(t.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date,(case w.proc_status when '1' then '待审批' when '3' then '审批通过' when '4' then '审批不通过' else '未提交' end) as proc_status ");
		querySql.append(" from bgp_doc_gms_file t left outer join p_auth_user u on t.creator_id = u.user_id left outer join common_busi_wf_middle w on t.file_id = w.business_id");
		querySql.append(" where t.is_file='1' and t.bsflag = '1'");
		querySql.append(" and t.parent_file_id ='"+folder_id+"'");
		querySql.append(" and t.project_info_no ='"+project_info_no+"'");
		if(file_name != null&&file_name != ""){
			querySql.append(" and t.file_name like '%"+file_name+"%'");
		}		
		if(doc_type != null&&doc_type != ""){
			querySql.append(" and t.file_type = '"+doc_type+"'");
		}
		if(doc_keyword != null&&doc_keyword != ""){
			querySql.append(" and t.doc_keyword like '%"+doc_keyword+"%'");
		}
		if(doc_importance != null&&doc_importance != ""){
			querySql.append(" and t.doc_importance = '"+doc_importance+"'");
		}
		if(create_date != null&&create_date != ""){
			querySql.append(" and t.create_date like to_date('"+create_date+"','yyyy-mm-dd hh24:mi:ss')");
		}
				
		querySql.append(" order by t.create_date desc");

		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}
	/**
	 * 还原已删除的文档
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg restoreDeletedFile(ISrvMsg isrvmsg) throws Exception {
				
		System.out.println("restoreDeletedFile !");
		
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ucm_file_id = isrvmsg.getValue("docId");
		
		String[] params = ucm_file_id.split(",");
		String theFileId = "";
		String updateSql = "";
		String updateVersion = "";
		String updateLog = "";
		
//		updateSql = "update bgp_doc_gms_file g set g.bsflag='1' where g.file_id='"+theFileId+"'";
//		updateVersion = "update bgp_doc_file_version g set g.bsflag='1' where g.file_id='"+theFileId+"'";
//		updateLog = "update bgp_doc_file_log g set g.bsflag='1' where g.file_id='"+theFileId+"'";
		
		
		for(String fileAnducm : params){
			theFileId = fileAnducm.split(":")[0];				
			updateSql = "update bgp_doc_gms_file g set g.bsflag='0' where g.file_id='"+theFileId+"'";
			updateVersion = "update bgp_doc_file_version g set g.bsflag='0' where g.file_id='"+theFileId+"'";
			updateLog = "update bgp_doc_file_log g set g.bsflag='0' where g.file_id='"+theFileId+"'";
			
			if(jdbcDao.executeUpdate(updateSql)>0&&jdbcDao.executeUpdate(updateVersion)>0&&jdbcDao.executeUpdate(updateLog)>0){				
				String fileVersion = jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.file_id= '"+theFileId+"'").get("file_version").toString();	
				String fileName = jdbcDao.queryRecordBySQL("select bfv.file_version_title from bgp_doc_file_version bfv where bfv.file_id= '"+theFileId+"'").get("file_version_title").toString();
				//还原操作写入日志
				myUcm.docLog(theFileId, fileVersion, 6, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),fileName);
			}
		}
		return responseDTO;

	}
	/**
	 * 彻底删除文档
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteFileCompletely(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteFileCompletely !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();

		String ucm_file_id = isrvmsg.getValue("docId");
		
		String[] params = ucm_file_id.split(",");
		
		String theUcmId = "";
		String theFileId = "";
		String updateSql = "";
		for(String fileAnducm : params){
			if(fileAnducm.split(":").length < 2){
				theFileId = fileAnducm.split(":")[0];
			}else{
				theFileId = fileAnducm.split(":")[0];
				theUcmId = fileAnducm.split(":")[1];
			}	
			updateSql = "update bgp_doc_gms_file g set g.bsflag='2' where g.file_id='"+theFileId+"'";
			try {
				jdbcDao.executeUpdate(updateSql);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		String folder_id = isrvmsg.getValue("folderid");
		responseDTO.setValue("ucmDocId", theUcmId);
		responseDTO.setValue("folderid", folder_id);
		return responseDTO;
	}
	
	/**
	 * 文档综合查询
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg complexFileSearch(ISrvMsg isrvmsg) throws Exception {

		System.out.println("complexFileSearch!");

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
		String fileTypes = "";
		

		String file_number = isrvmsg.getValue("file_number");
		String file_name = isrvmsg.getValue("file_name");
		String doc_keyword = isrvmsg.getValue("doc_keyword");
		System.out.println("The key word is:"+doc_keyword);
		String doc_importance = isrvmsg.getValue("doc_importance");		
		String doc_type = isrvmsg.getValue("doc_type");		
		String file_types = isrvmsg.getValue("doc_type");
		String create_date_start = isrvmsg.getValue("create_date_start");
		String create_date_end = isrvmsg.getValue("create_date_end");
		String creator_id = isrvmsg.getValue("creator_id");
		String project_id = isrvmsg.getValue("project_id");
	//case l.operation when '1' then '新增' when '2' then '下载' when '3' then '修改' when '4' then '删除' when '5' then '查看' when '6' then '还原' else '无操作' end
		StringBuffer querySql = new StringBuffer("select f.file_id,f.ucm_id,f.file_number,f.file_name,f.doc_keyword,f.doc_importance,f.create_date,f.file_type,f.creator_id,f.project_info_no,(case f.file_type when 'word' then 'Word' when 'excel' then 'Excel' when 'ppt' then 'PowerPoint' when 'pdf' then 'PDF' when 'txt' then 'TXT' when 'picture' then '图片文件' when 'compress' then '压缩文件' when 'other' then '其他文件' else '' end) as the_file_type,(case f.doc_importance when '1' then '高' when '2' then '中' when '3' then '低' else '' end) as doc_importance_value,u.user_name,p.project_name");
		querySql.append(" from bgp_doc_gms_file f left outer join p_auth_user u on f.creator_id = u.user_id left outer join gp_task_project p on f.project_info_no = p.project_info_no");
		querySql.append(" where f.bsflag='0' and f.is_file='1'");

		if(file_number != null&&file_number != ""){
			querySql.append(" and f.file_number like '%"+file_number+"%'");
		}		
		if(file_name != null&&file_name != ""){
			querySql.append(" and f.file_name like '%"+file_name+"%'");
		}
		if(doc_keyword != null&&doc_keyword != ""){
			querySql.append(" and f.doc_keyword like '%"+doc_keyword+"%'");
		}
		if(doc_importance != null&&doc_importance != ""){
			querySql.append(" and f.doc_importance = '"+doc_importance+"'");
		}
		
		if(create_date_start != null&&create_date_start != ""){
			querySql.append(" and f.create_date >= to_date('"+create_date_start+"','yyyy-mm-dd hh24:mi:ss')");
		}
		if(create_date_end != null&&create_date_end != ""){
			querySql.append(" and f.create_date <= to_date('"+create_date_end+"','yyyy-mm-dd hh24:mi:ss')");
		}
		if(file_types != null&&file_types != ""){
			querySql.append(" and f.file_type in ("+file_types+")");
		}
		if(creator_id != null&&creator_id != ""){
			querySql.append(" and f.creator_id = '"+creator_id+"'");
		}
		if(project_id != null&&project_id != ""){
			querySql.append(" and f.project_info_no = '"+project_id+"'");
		}
				
		querySql.append(" order by f.create_date desc");
		
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);

		return responseDTO;

	}

	/**
	 * 设置文档结构模板
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg setTemplate(ISrvMsg isrvmsg) throws Exception {
		System.out.println("setTemplate !");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		
		String root_id = isrvmsg.getValue("rootId");
		String template_id = isrvmsg.getValue("templateId");
		Map save_template_map = new HashMap();
		if(root_id!=""&& root_id!=null&&template_id!=""&&template_id!=null){
			myUcm.createProjectFolderNew(user.getProjectInfoNo(), user.getProjectName(), user.getUserId(), user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(),null);
//			jdbcDao.executeUpdate("update bgp_doc_gms_file t set t.is_template_used = '1' where t.is_template = '1' and t.file_id = '"+template_id+"'");
			jdbcDao.executeUpdate("update bgp_doc_gms_file t set t.is_template_used = '1' where  t.file_id = '"+template_id+"'");
		}		
		
		String operationFlag = "success";
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * 查询chart图所需要的数据
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDocChart(ISrvMsg isrvmsg) throws Exception {
		System.out.println("getDocChart");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String sql = "select to_char(bf.create_date,'yyyy-MM-dd') as filecreatedate,count(bf.file_id) as doccount from bgp_doc_gms_file bf where bf.bsflag = '0' and bf.is_file = '1' and bf.create_date >= trunc(sysdate - 5) group by to_char(bf.create_date,'yyyy-MM-dd') order by to_char(bf.create_date,'yyyy-MM-dd') desc";
		List<Map> doc_list = jdbcDao.queryRecords(sql);
		String Str = "<chart caption='近5天上传文档统计' showPercentageInLabel='1' showValues='1' showLabels='1' showLegend='1'  bgColor='FFFFFF'>";
		for(Map docMap : doc_list){
			String create_date = docMap.get("filecreatedate").toString();
			String doc_count = docMap.get("doccount").toString();
			Str = Str+"<set value='"+doc_count+"' label='"+create_date+"'/>";
		}
		
		Str = Str+"</chart>";

		responseDTO.setValue("Str", Str);
		return responseDTO;

	}
	
	/**
	 * 创建项目的文档目录结构
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg createProjectFolder(ISrvMsg isrvmsg) throws Exception {
		System.out.println("createProjectFolder !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
				
		UserToken user = isrvmsg.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		if(project_info_no !="" &&project_info_no != null){
			System.out.println("选择了项目，项目不为空");
			String project_name = user.getProjectName();
			Map folderInfoMap = new HashMap();
			String checkSql = "select count(*) as projectcount from bgp_doc_gms_file t where t.project_info_no = '"+project_info_no+"' and t.bsflag = '0' and t.is_file = '0' and t.parent_file_id is null";
			if(Integer.parseInt(jdbcDao.queryRecordBySQL(checkSql).get("projectcount").toString())== 0){
				//该数据不存在，需要插入
				System.out.println("该项目不存在");
				folderInfoMap.put("file_name", project_name);
				folderInfoMap.put("project_info_no", project_info_no);
				folderInfoMap.put("bsflag", "0");
				folderInfoMap.put("create_date", new Date());
				folderInfoMap.put("creator_id", user.getUserId());
				folderInfoMap.put("modifi_date", new Date());
				folderInfoMap.put("updator_id", user.getUserId());
				folderInfoMap.put("is_file", "0");
				folderInfoMap.put("file_abbr", "root");
				folderInfoMap.put("file_number_format", fileNumberFormat);
				folderInfoMap.put("org_id", user.getCodeAffordOrgID());
				folderInfoMap.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				jdbcDao.saveOrUpdateEntity(folderInfoMap, "bgp_doc_gms_file");
				
				//String root_id = isrvmsg.getValue("rootId");
				String root_id = project_info_no;
				//String template_id = isrvmsg.getValue("templateId");	
				String template_id = templateId;
				Map save_template_map = new HashMap();
				if(root_id!=""&&root_id!=null&&template_id!=""&&template_id!=null){
					
					
					myUcm.setTemplate(template_id, root_id, user.getProjectInfoNo(), user.getUserId(), user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg());
					jdbcDao.executeUpdate("update bgp_doc_gms_file t set t.is_template_used = '1' where t.is_template = '1' and t.file_id = '"+template_id+"'");
				}		
				
				String operationFlag = "success";
				responseDTO.setValue("operationflag", operationFlag);
			}else{
				System.out.println("该项目已存在");
			}
		}else{
			System.out.println("没选项目");
		}
		return responseDTO;		
	}
	
	/**
	 * 增加时检查目录结构中目录缩写的唯一性(模板)
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkFolderAbbr(ISrvMsg isrvmsg) throws Exception {
		System.out.println("checkFolderAbbr");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String folder_abbr = isrvmsg.getValue("folderAbbr");
		String is_template = isrvmsg.getValue("is_template");
		String pf_id = isrvmsg.getValue("pf_id");
		
	
		if(is_template.equals("") && is_template == null){
			is_template="1";
		}
		String check_abbr_sql = "select count(f.file_id) as abbr_count from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file = '0' and f.is_template = '"+is_template+"' and f.file_abbr = '"+folder_abbr+"' ";
		
		if(!pf_id.equals("") && pf_id != null){
			check_abbr_sql+=" and PARENT_FILE_ID = '"+pf_id+"' ";
		}
		
		int abbr_count= Integer.parseInt(jdbcDao.queryRecordBySQL(check_abbr_sql).get("abbr_count").toString());
		if(abbr_count != 0){
			//该file_abbr存在,不能再添加了
			responseDTO.setValue("isexist", "1");
		}else{
			responseDTO.setValue("isexist", "0");
		}
		
		return responseDTO;
	}
	
	/**
	 * 修改时检查目录结构中目录缩写的唯一性(模板)
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkFolderAbbrEdit(ISrvMsg isrvmsg) throws Exception {
		System.out.println("checkFolderAbbrEdit");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String folder_id = isrvmsg.getValue("folderId");
		String is_template = isrvmsg.getValue("is_template");
		if(is_template.equals("") && is_template == null){
			is_template="1";
		}
		
		String check_abbr_sql = "select f.file_abbr,f.file_name from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file = '0' and f.is_template = '"+is_template+"' and f.file_id = '"+folder_id+"'";
		
		String file_abbr= jdbcDao.queryRecordBySQL(check_abbr_sql).get("file_abbr").toString();
		String file_name = jdbcDao.queryRecordBySQL(check_abbr_sql).get("file_name").toString();

		responseDTO.setValue("fileAbbr", file_abbr);
		responseDTO.setValue("fileName", file_name);
		
		return responseDTO;
	}
	
	/**
	 * 增加时检查目录结构中目录缩写的唯一性(单项目)
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkFolderAbbrProject(ISrvMsg isrvmsg) throws Exception {
		System.out.println("checkFolderAbbrProject");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String project_info_no = isrvmsg.getValue("projectInfoNo") != null? isrvmsg.getValue("projectInfoNo"):"";
		UserToken user = isrvmsg.getUserToken();
		String folder_abbr = isrvmsg.getValue("folderAbbr");
		StringBuffer check_abbr_sql = new StringBuffer("select count(f.file_id) as abbr_count from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file = '0' and f.is_template is null and f.file_abbr = '"+folder_abbr+"'");
		if(project_info_no != ""){
			check_abbr_sql.append(" and f.project_info_no = '"+project_info_no+"'");
		}
		
		int abbr_count= Integer.parseInt(jdbcDao.queryRecordBySQL(check_abbr_sql.toString()).get("abbr_count").toString());
		if(abbr_count != 0){
			//该file_abbr存在,不能再添加了
			responseDTO.setValue("isexist", "1");
		}else{
			responseDTO.setValue("isexist", "0");
		}
		
		return responseDTO;
	}
	
	/**
	 * 修改时检查目录结构中目录缩写的唯一性(单项目)
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkFolderAbbrEditProject(ISrvMsg isrvmsg) throws Exception {
		System.out.println("checkFolderAbbrEditProject");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String project_info_no = isrvmsg.getValue("projectInfoNo") != null? isrvmsg.getValue("projectInfoNo"):"";
		String folder_id = isrvmsg.getValue("folderId");
		StringBuffer check_abbr_sql = new StringBuffer("select f.file_abbr,f.file_name from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file = '0' and f.is_template is null and f.file_id = '"+folder_id+"'");
		if(project_info_no != ""){
			check_abbr_sql.append(" and f.project_info_no = '"+project_info_no+"'");
		}
		
		String file_abbr= jdbcDao.queryRecordBySQL(check_abbr_sql.toString()).get("file_abbr").toString();
		String file_name = jdbcDao.queryRecordBySQL(check_abbr_sql.toString()).get("file_name").toString();

		responseDTO.setValue("fileAbbr", file_abbr);
		responseDTO.setValue("fileName", file_name);
		
		return responseDTO;
	}
	
	
	/**
	 * 增加时检查目录结构中目录缩写的唯一性(多项目)
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkFolderAbbrMulti(ISrvMsg isrvmsg) throws Exception {
		System.out.println("checkFolderAbbrMulti");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String folder_abbr = isrvmsg.getValue("folderAbbr");
		StringBuffer check_abbr_sql = new StringBuffer("select count(f.file_id) as abbr_count from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file = '0' and f.is_template is null and f.project_info_no is null and f.file_abbr = '"+folder_abbr+"'");
		
		int abbr_count= Integer.parseInt(jdbcDao.queryRecordBySQL(check_abbr_sql.toString()).get("abbr_count").toString());
		if(abbr_count != 0){
			//该file_abbr存在,不能再添加了
			responseDTO.setValue("isexist", "1");
		}else{
			responseDTO.setValue("isexist", "0");
		}
		
		return responseDTO;
	}
	
	/**
	 * 检查模板名称是否存在
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkTemplateName(ISrvMsg isrvmsg) throws Exception {
		System.out.println("checkTemplateShortName");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String template_name = isrvmsg.getValue("templateName");
		String is_template = isrvmsg.getValue("isTemplate");
		StringBuffer check_template_sql = new StringBuffer("select count(f.file_id) as template_count from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file = '0' and f.is_template = '"+is_template+"' and f.project_info_no is null and f.parent_file_id is null and f.template_name = '"+template_name+"'");
		
		int template_count= Integer.parseInt(jdbcDao.queryRecordBySQL(check_template_sql.toString()).get("template_count").toString());
		if(template_count != 0){
			//该file_abbr存在,不能再添加了
			responseDTO.setValue("isexist", "1");
		}else{
			responseDTO.setValue("isexist", "0");
		}
		
		return responseDTO;
	}
	
	/**
	 * 拖动改变顺序(项目文档结构)
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg moveTreeNodePosition(ISrvMsg isrvmsg) throws Exception {
		System.out.println("moveTreeNodePosition");
		 
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
 
		String pkValue = isrvmsg.getValue("pkValue"); //当前记录的主键              
		int index = Integer.parseInt(isrvmsg.getValue("index"));    //拖动的顺序 
		String oldParentId = isrvmsg.getValue("oldParentId"); //父节点Id
		String newParentId = isrvmsg.getValue("newParentId"); //新的父节点Id
		
		Map moveOrg = null;
		
		//根据  org_hr_id查询   orderNum  
		StringBuffer subsqla = new StringBuffer("select t.file_id,t.file_name,t.file_abbr from bgp_doc_gms_file t where t.bsflag = '0' and t.is_template is null and t.parent_file_id = ");
		subsqla.append("(select t1.file_abbr from bgp_doc_gms_file t1 where t1.bsflag = '0' and t1.is_template is null and t1.file_id = '"+oldParentId+"')").append(" order by t.order_num");
	 
		List orgs =BeanFactory.getQueryJdbcDAO().queryRecords(subsqla.toString());
		for(int i=0;i<orgs.size();i++){
			// 移动位置
			Map org = (Map)orgs.get(i);
			String file_id = (String)org.get("fileId");
			//将选中的节点从其父节点的列表中移除，并记录该节点的信息
			if(pkValue.equals(file_id)){
				moveOrg = (Map) orgs.get(i);
				orgs.remove(i);
				if(orgs.size() != 0){
					orgs.add(index, org);
				}
				break;
			}
		}
		// 写入新位置到数据库,父节点变化了
		if(!oldParentId.equals(newParentId)){
			saveNewPositionNewParent(moveOrg,newParentId);
		}
		//父节点没变化
		else{
			saveNewPosition(orgs);
		}
		
		
		return respMsg;
	}
	/**
	 * 写入新位置到数据库,父节点变化(项目文档结构)
	 * @param orgs
	 */
	private void saveNewPositionNewParent(final Map orgs,final String newParentId){
		System.out.println("saveNewPositionNewParent");

		String check_abbr_sql = "select f.file_abbr from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file = '0' and f.is_template is null and f.file_id = '"+newParentId+"'";
		
		final String file_abbr= jdbcDao.queryRecordBySQL(check_abbr_sql).get("file_abbr").toString();
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

    	JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
    	
		String sql = "update bgp_doc_gms_file set order_num=?,parent_file_id=? where file_id=?";
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map data = orgs;
//				try {
//					data = (Map)orgs.get(i);
//				} catch (Exception e) {
//					
//				}
				ps.setString(1, String.valueOf(1000+i));
				
				ps.setString(2, file_abbr);

				ps.setString(3, (String)data.get("fileId"));

			}

			public int getBatchSize() {
				return orgs.size();
			}
		};

		jdbcTemplate.batchUpdate(sql, setter);

	}
	
	/**
	 * 写入新位置到数据库,父节点没变(项目文档结构)
	 * @param orgs
	 */
	private void saveNewPosition(final List orgs){
		System.out.println("saveNewPosition");

		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

    	JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
    	
		String sql = "update bgp_doc_gms_file set order_num=? where file_id=?";
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map data = null;
				try {
					data = (Map)orgs.get(i);
				} catch (Exception e) {
					
				}
				ps.setString(1, String.valueOf(1000+i));

				ps.setString(2, (String)data.get("fileId"));
			}

			public int getBatchSize() {
				return orgs.size();
			}
		};

		jdbcTemplate.batchUpdate(sql, setter);

	}
	
	
	/**
	 * 拖动改变顺序(模板结构)
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg moveTreeNodePositionTemplate(ISrvMsg isrvmsg) throws Exception {
		System.out.println("moveTreeNodePositionTemplate");
		 
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
 
		String pkValue = isrvmsg.getValue("pkValue"); //当前记录的主键              
		int index = Integer.parseInt(isrvmsg.getValue("index"));    //拖动的顺序 
		String oldParentId = isrvmsg.getValue("oldParentId"); //父节点Id
		String newParentId = isrvmsg.getValue("newParentId"); //新的父节点Id
		
		Map moveOrg = null;
		
		//根据  org_hr_id查询   orderNum  
		StringBuffer subsqla = new StringBuffer("select t.file_id,t.file_name,t.file_abbr from bgp_doc_gms_file t where t.bsflag = '0' and t.is_template = '1' and t.project_info_no is null and t.parent_file_id = ");
		subsqla.append("(select t1.file_abbr from bgp_doc_gms_file t1 where t1.bsflag = '0' and t1.is_template = '1' and t1.file_id = '"+oldParentId+"')").append(" order by t.order_num");
	 
		List orgs =BeanFactory.getQueryJdbcDAO().queryRecords(subsqla.toString());
		for(int i=0;i<orgs.size();i++){
			// 移动位置
			Map org = (Map)orgs.get(i);
			String file_id = (String)org.get("fileId");
			//将选中的节点从其父节点的列表中移除，并记录该节点的信息
			if(pkValue.equals(file_id)){
				moveOrg = (Map) orgs.get(i);
				orgs.remove(i);
				if(orgs.size() != 0){
					orgs.add(index, org);
				}
				break;
			}
		}
		// 写入新位置到数据库,父节点变化了
		if(!oldParentId.equals(newParentId)){
			saveNewPositionNewParentTemplate(moveOrg,newParentId);
		}
		//父节点没变化
		else{
			saveNewPositionTemplate(orgs);
		}
		
		
		return respMsg;
	}
	/**
	 * 写入新位置到数据库,父节点变化(模板结构)
	 * @param orgs
	 */
	private void saveNewPositionNewParentTemplate(final Map orgs,final String newParentId){
		System.out.println("saveNewPositionNewParentTemplate");

		String check_abbr_sql = "select f.file_abbr from bgp_doc_gms_file f where f.bsflag = '0' and f.is_file = '0' and f.is_template = '1' and f.project_info_no is null and f.file_id = '"+newParentId+"'";
		
		final String file_abbr= jdbcDao.queryRecordBySQL(check_abbr_sql).get("file_abbr").toString();
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

    	JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
    	
		String sql = "update bgp_doc_gms_file set order_num=?,parent_file_id=? where file_id=?";
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map data = orgs;
//				try {
//					data = (Map)orgs.get(i);
//				} catch (Exception e) {
//					
//				}
				ps.setString(1, String.valueOf(1000+i));
				
				ps.setString(2, file_abbr);

				ps.setString(3, (String)data.get("fileId"));

			}

			public int getBatchSize() {
				return orgs.size();
			}
		};

		jdbcTemplate.batchUpdate(sql, setter);

	}
	
	/**
	 * 写入新位置到数据库,父节点没变(模板结构)
	 * @param orgs
	 */
	private void saveNewPositionTemplate(final List orgs){
		System.out.println("saveNewPositionTemplate");

		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

    	JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
    	
		String sql = "update bgp_doc_gms_file set order_num=? where file_id=?";
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map data = null;
				try {
					data = (Map)orgs.get(i);
				} catch (Exception e) {
					
				}
				ps.setString(1, String.valueOf(1000+i));

				ps.setString(2, (String)data.get("fileId"));
			}

			public int getBatchSize() {
				return orgs.size();
			}
		};

		jdbcTemplate.batchUpdate(sql, setter);

	}
	
	/**
	 * 拖动改变顺序(多项目)
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg moveTreeNodePositionMulti(ISrvMsg isrvmsg) throws Exception {
		System.out.println("moveTreeNodePositionMulti");
		 
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
 
		String pkValue = isrvmsg.getValue("pkValue"); //当前记录的主键              
		int index = Integer.parseInt(isrvmsg.getValue("index"));    //拖动的顺序 
		String oldParentId = isrvmsg.getValue("oldParentId"); //父节点Id
		String newParentId = isrvmsg.getValue("newParentId"); //新的父节点Id
		
		Map moveOrg = null;
		
		//根据  org_hr_id查询   orderNum  
		StringBuffer subsqla = new StringBuffer("select t.file_id,t.file_name,t.file_abbr from bgp_doc_gms_file t where t.bsflag = '0' and t.project_info_no is null and t.parent_file_id = '"+oldParentId+"'");
		subsqla.append(" order by t.order_num");
	 
		List orgs =BeanFactory.getQueryJdbcDAO().queryRecords(subsqla.toString());
		for(int i=0;i<orgs.size();i++){
			// 移动位置
			Map org = (Map)orgs.get(i);
			String file_id = (String)org.get("fileId");
			//将选中的节点从其父节点的列表中移除，并记录该节点的信息
			if(pkValue.equals(file_id)){
				moveOrg = (Map) orgs.get(i);
				orgs.remove(i);
				if(orgs.size() != 0){
					orgs.add(index, org);
				}
				break;
			}
		}
		// 写入新位置到数据库,父节点变化了
		if(!oldParentId.equals(newParentId)){
			saveNewPositionNewParentMulti(moveOrg,newParentId);
		}
		//父节点没变化
		else{
			saveNewPositionMulti(orgs);
		}
		
		return respMsg;
	}
	/**
	 * 写入新位置到数据库,父节点变化(多项目)
	 * @param orgs
	 */
	private void saveNewPositionNewParentMulti(final Map orgs,final String newParentId){
		System.out.println("saveNewPositionNewParentMulti");
		
		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

    	JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
    	
		String sql = "update bgp_doc_gms_file set order_num=?,parent_file_id=? where file_id=?";
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map data = orgs;
				ps.setString(1, String.valueOf(1000+i));
				
				ps.setString(2, newParentId);

				ps.setString(3, (String)data.get("fileId"));

			}

			public int getBatchSize() {
				return orgs.size();
			}
		};

		jdbcTemplate.batchUpdate(sql, setter);

	}
	
	/**
	 * 写入新位置到数据库,父节点没变(多项目)
	 * @param orgs
	 */
	private void saveNewPositionMulti(final List orgs){
		System.out.println("saveNewPositionMulti");

		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

    	JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
    	
		String sql = "update bgp_doc_gms_file set order_num=? where file_id=?";
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map data = null;
				try {
					data = (Map)orgs.get(i);
				} catch (Exception e) {
					
				}
				ps.setString(1, String.valueOf(1000+i));
				ps.setString(2, (String)data.get("fileId"));
			}

			public int getBatchSize() {
				return orgs.size();
			}
		};

		jdbcTemplate.batchUpdate(sql, setter);

	}
	
	/**
	 * 创建项目文档结构(新)
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg createProjectFolderNew(ISrvMsg isrvmsg) throws Exception {
		System.out.println("createProjectFolderNew");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		myUcm.createProjectFolderNew(user.getProjectInfoNo(), user.getProjectName(), user.getUserId(), user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),null);
		return responseDTO;

	}
	
	/**
	 * 为模块分配目录
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg setModuleFolder(ISrvMsg isrvmsg) throws Exception {
		System.out.println("setModuleFolder");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		myUcm.setModuleFolder(user.getProjectInfoNo(), user.getProjectName(), user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg());
		return responseDTO;

	}
	
	/**
	 * test
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg test(ISrvMsg isrvmsg) throws Exception {
		System.out.println("this is test");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		String folder_id = "8ad8b7cb304f1acf01304f1e1eb20002";
		System.out.println("the folder id is:"+folder_id);
		myUcm.getDocsInFolder(folder_id);		
		return responseDTO;

	}
	public ISrvMsg getFilePathByUcmFileName(ISrvMsg reqMsg) throws Exception{
		// 获取文件id与ucmid
		String info = reqMsg.getValue("info");
		String[] params = info.split(":");
		
		String ucmId =  params[0];
		String fileName =  params[1];
		UserToken user = reqMsg.getUserToken();

		ISrvMsg respDTO = SrvMsgUtil.createResponseMsg(reqMsg);
		respDTO = processDoc(respDTO, fileName, ucmId, user);

		return respDTO;

	}

	/**
	 * 
	 * @Title: getFilePath
	 * @Description: 从UCM获取文件，转换成pdf，然后转换成swf，返回文件的swf文件路径
	 * @param @param reqMsg
	 * @param @return
	 * @param @throws Exception 设定文件
	 * @return ISrvMsg 返回类型
	 * @throws
	 */
	public ISrvMsg getFilePath(ISrvMsg reqMsg) throws Exception
	{
		// 获取文件id与ucmid
		String ucmids = reqMsg.getValue("ucmid");

		log.info("fileid:ucmid=" + ucmids);

		String[] params = ucmids.split(":");
		// 文件ID
		String fileId = params[0];
		// 文件在UCM上的ID
		String ucmId = params[1];

		UserToken user = reqMsg.getUserToken();

		String sql = "select f.file_name from bgp_doc_gms_file  f where  f.is_file = 1 and f.file_id = '"
				+ fileId + "'";

		Map map = jdbcDao.queryRecordBySQL(sql);

		ISrvMsg respDTO = SrvMsgUtil.createResponseMsg(reqMsg);
		// 文件不存在
		if (map == null)
		{
			respDTO.setValue("message", "文件不存在！");
			return respDTO;
		}

		String fileName = (String) map.get("file_name");
//		//判断是否有文件扩展名
//		if(fileName.indexOf(".")==-1){
//			respDTO.setValue("message", "没有文件后缀名，不支持预览！");
//			return respDTO;
//		}

		respDTO = processDoc(respDTO, fileName, ucmId, user);

		return respDTO;

	}
	

	private synchronized ISrvMsg processDoc(ISrvMsg respDTO, String fileName,
			String ucmId, UserToken user) throws Exception
	{
	    String ucmFileName =myUcm.getDocTitle(ucmId);
			
		if(fileName.indexOf(".")==-1){
			
			if(ucmFileName == null || ("").equals(ucmFileName)){
				respDTO.setValue("message", "文件不存在！");
				return respDTO;
			}
			
			//获取文件名
			ucmFileName = ucmFileName.substring(ucmFileName.indexOf("."), ucmFileName.length());
			fileName = fileName + ucmFileName; 

		}
		//处理文件后缀名为xml文件，转换成txt文件
		if(fileName.indexOf(".xml")!=-1){ 
			fileName = fileName.replace(".xml", ".txt");
		}

		// 从ucm下载文件到本地服务器上
		boolean flag = DocConverter.getInit().downloadFileForUCM(ucmId,
				user.getUserId(), fileName);
		// 判断文件是否太大
		if (!flag)
		{
			respDTO.setValue("message", "文件大于2M，无法打开！");
			return respDTO;
		}

		// 把文件转换成pdf格式 ,如何是pdf方法里面已经处理
		String filePath = DocConverter.getInit().docToPDF(user.getUserId(),
				fileName);
	 
		// 把pdf文件转换成swf格式
		String fileSWF = DocConverter.getInit().pdfToSWF(filePath);

		if (fileSWF == null)
		{
			respDTO.setValue("message", "pdf转换成swf文件失败！");
		} else
		{
			respDTO.setValue("fileSWF", fileSWF);
		}

		return respDTO;
	}

}
