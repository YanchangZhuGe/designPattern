package com.bgp.mcs.service.doc.service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import oracle.stellent.ridc.IdcClient;
import oracle.stellent.ridc.IdcClientException;
import oracle.stellent.ridc.IdcClientManager;
import oracle.stellent.ridc.IdcContext;
import oracle.stellent.ridc.model.DataBinder;
import oracle.stellent.ridc.model.DataObject;
import oracle.stellent.ridc.model.DataResultSet;
import oracle.stellent.ridc.model.TransferFile;
import oracle.stellent.ridc.protocol.ServiceResponse;

import org.jfree.util.Log;
import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.webapp.upload.WebPathUtil;


public class MyUcm {

	ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	IBaseDao baseDao = BeanFactory.getBaseDao();
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	/*
	 * UCM连接地址
	 */
	private String idcConnectionURL = cfgHd.getSingleNodeValue("//p6/ucm/ucm_url");
	/*
	 * 用户名
	 */
	private String userName = cfgHd.getSingleNodeValue("//p6/ucm/ucm_user");
	/*
	 * 密码
	 */
	private String passWord = cfgHd.getSingleNodeValue("//p6/ucm/ucm_pwd");
	//井中项目类型
	private static String ZJ_PROJECT_TYPE = "5000100004000000008";
	
	/**
	 * 构造方法
	 * @param idcConnectionURL
	 * @param userName
	 * @param passWord
	 */
//	public MyUcm(String idcConnectionURL, String userName, String passWord)
//	{
//		this.idcConnectionURL = idcConnectionURL;
//		this.userName = userName;
//		this.passWord = passWord;
//	}
	
	@SuppressWarnings("rawtypes")
	public String uploadFile(File file) throws IdcClientException, IOException
	{
		String docId = "";
		String docTitle = "";
		String fileName = getName(file.getPath());
		int index = fileName.lastIndexOf(".");
		if(index == -1){//不存在.			
			docTitle = fileName;
		}else{          //存在.
			docTitle = fileName.substring(0, index);
		}
		
		IdcClient idcClient = getIdcClient();
		IdcContext idcContext = getIdcContext();
		DataBinder dataBinder = idcClient.createBinder();
		dataBinder.putLocal("IdcService", "CHECKIN_UNIVERSAL");
		dataBinder.putLocal("dDocTitle", docTitle);
		//dataBinder.putLocal("dDocName", docTitle);
		dataBinder.putLocal("dDocAccount", "");
		//dataBinder.putLocal("dDocType", "ADACCT");
		dataBinder.putLocal("dDocType", "GMSDocs");
		dataBinder.putLocal("dSecurityGroup", "Public");
		dataBinder.getLocalData().setDate("dInDate", new Date());
		dataBinder.addFile("primaryFile", new TransferFile(file));
		ServiceResponse response = idcClient.sendRequest(idcContext, dataBinder);
		DataBinder binder = response.getResponseAsBinder();
		docId = binder.getLocal("dID");
		return docId;
	}
	
	@SuppressWarnings("rawtypes")
	public String uploadFile(String fileName, byte[] uploadData) throws IdcClientException
	{
		String docId = "";
		//文件名无后缀和有后缀两种情况 index = -1表示不存在
		String docTitle = "";
		int index = fileName.lastIndexOf(".");
		System.out.println("The index is: "+index);
		if(index == -1){//不存在.			
			docTitle = fileName;
		}else{          //存在.
			docTitle = fileName.substring(0, index);
		}
		
		
		System.out.println("The fileName is:"+ fileName);
		System.out.println("The doctitle is:"+ docTitle);
		IdcClient idcClient = getIdcClient();
		IdcContext idcContext = getIdcContext();
		DataBinder dataBinder = idcClient.createBinder();
		dataBinder.putLocal("IdcService", "CHECKIN_UNIVERSAL");
		dataBinder.putLocal("dDocTitle", docTitle);
		//dataBinder.putLocal("dDocName", fileName);
		dataBinder.putLocal("dDocAccount", "");
		//dataBinder.putLocal("dDocType", "ADACCT");
		dataBinder.putLocal("dDocType", "GMSDocs");
		dataBinder.putLocal("dSecurityGroup", "Public");
		dataBinder.getLocalData().setDate("dInDate", new Date());
		dataBinder.addFile("primaryFile", new TransferFile(new ByteArrayInputStream(uploadData), fileName, uploadData.length, "application/octet-stream"));
		ServiceResponse response = idcClient.sendRequest(idcContext, dataBinder);
		DataBinder binder = response.getResponseAsBinder();
		docId = binder.getLocal("dID");
		
		return docId;
	}
	/**
	 * 向指定的文件夹中上传文件
	 * @param file
	 * @return
	 * @throws IdcClientException
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public String uploadFileToCollection(String fileName, byte[] uploadData) throws IdcClientException, IOException
	{
		String docId = "";		
		String docTitle = "";//文件名无后缀和有后缀两种情况 index = -1表示不存在
		int index = fileName.indexOf(".");
		if(index == -1){//不存在.			
			docTitle = fileName;
		}else{          //存在.
			docTitle = fileName.substring(0, index);
		}
		IdcClient idcClient = getIdcClient();
		IdcContext idcContext = getIdcContext();
		DataBinder dataBinder = idcClient.createBinder();
		dataBinder.putLocal("IdcService", "COLLECTION_CHECKIN_NEW");
		dataBinder.putLocal("dDocTitle", docTitle);
		dataBinder.putLocal("hasCollectionID", "true");
		dataBinder.putLocal("dCollectionID", "719179511213000004");//985754302688000801是本机虚拟文件夹gmsdoc的编号，719179511213000004是246服务器的
		dataBinder.putLocal("dDocType", "GMSDocs");
		dataBinder.putLocal("dSecurityGroup", "Public");
		dataBinder.getLocalData().setDate("dInDate", new Date());
		dataBinder.addFile("primaryFile", new TransferFile(new ByteArrayInputStream(uploadData), fileName, uploadData.length, "application/octet-stream"));
		ServiceResponse response = idcClient.sendRequest(idcContext, dataBinder);
		DataBinder binder = response.getResponseAsBinder();
		docId = binder.getLocal("dID");
		return docId;
	}
	
	/**
	 * 获取IdcClient对象
	 */
		@SuppressWarnings("rawtypes")
		public IdcClient getIdcClient()
		{
			IdcClientManager idcClientManager = IdcClientManagerInstance.getInstance();
			IdcClient idcClient = null;
			try
			{
				idcClient = idcClientManager.createClient(idcConnectionURL);
			} catch (Exception e)
			{
				System.out.println("This is the Error");
			}
			return idcClient;
		}
	/*
	 * 获取IdcContext对象
	 */
		public IdcContext getIdcContext()
		{
			return new IdcContext(userName, passWord);
		}
		
		/**
		 * 根据上传文件的路径获取文件名
		 * @param name 文件上传路径
		 * @return
		 */
		protected String getName(String name)
		{
			String rtn = null;
			if (name != null)
			{
				int index = name.lastIndexOf("/");
				if (index != -1)
				{
					rtn = name.substring(index + 1);
				} else
				{
					index = name.lastIndexOf("\\");
					if (index != -1)
					{
						rtn = name.substring(index + 1);
					} else
					{
						rtn = name;
					}
				}
			}
			return rtn;
		}
		
			
		@SuppressWarnings("rawtypes")
		public void creatFolder() throws IdcClientException, IOException
		{
			IdcClient idcClient = getIdcClient();
			IdcContext idcContext = getIdcContext();
			DataBinder dataBinder = idcClient.createBinder();
			dataBinder.putLocal("IdcService", "COLLECTION_ADD");
			dataBinder.putLocal("hasParentCollectionID", "false");
			dataBinder.putLocal("dCollectionName", "zxl");
			//dataBinder.putLocal("dCollectionOwner", "GMSDOC");
			//dataBinder.putLocal("WebsiteSection", "/内容提供文件夹/GMS Folder/");
			//dataBinder.getLocalData().setDate("dInDate", new Date());
			//dataBinder.addFile("primaryFile", new TransferFile(file));
			//ServiceResponse response = idcClient.sendRequest(idcContext, dataBinder);
			//DataBinder binder = response.getResponseAsBinder();
			//docId = binder.getLocal("dID");
			//return docId;
		}
		
		public void test(){
			System.out.println("The test");
		}
		
		/**
		 * 查询文档quickSearch
		 * @throws IdcClientException
		 */
	    public void quickSearch () throws IdcClientException {
	        //Get the client (from the base class) and create a new binder
	        IdcClient client = getIdcClient();
	        
	        String theKey = "e";
	        String theKey1 = "P6Docs";
	        
	        //Call the service to perform the search
	        DataBinder dataBinder = client.createBinder ();
	        dataBinder.putLocal ("IdcService", "GET_SEARCH_RESULTS");
	        dataBinder.putLocal ("SortField", "dInDate");
	        dataBinder.putLocal ("SortOrder", "Desc");
	        dataBinder.putLocal ("ResultCount", "120");
	        //dataBinder.putLocal ("StartRow", "21");
	        //dataBinder.putLocal ("SearchEngineName", "databasefulltext");dDocFullText
	        dataBinder.putLocal ("SearchEngineName", "database");
	        //dataBinder.putLocal ("QueryText", "dDocTitle <substring> <qsch>"+theKey+"</qsch>");
	        //dataBinder.putLocal ("QueryText", "dSecurityGroup <substring> <qsch>"+theKey+"</qsch>");
	        dataBinder.putLocal ("QueryText", "");
	        dataBinder.putLocal("dDocAccount", "");
	        //dataBinder.putLocal("dDocAccount", "_user91");
	        dataBinder.putLocal ("SearchQueryFormat", "Universal");
	        
	        //Convert the response to a databinder
	        ServiceResponse response = client.sendRequest (getIdcContext(), dataBinder);
	        DataBinder responseData = response.getResponseAsBinder ();

	        String fileURL = responseData.getLocal("dDocTitle");
	        System.out.println("The url is: "+fileURL);
	        //Get the SearchResults resultset
	        DataResultSet searchResults = responseData.getResultSet ("SearchResults");

	        
	        //Get all the fieldnames
	        List<String> fieldnames = new ArrayList<String> ();
	        for (DataResultSet.Field field:searchResults.getFields ()) {
	            fieldnames.add (field.getName ());
	        }
	        
	        //Print all the fieldnames
	        for (String field:fieldnames) {
	            System.out.print (field + " | ");
	        }

	        //Print all the rows
	        for (DataObject row:searchResults.getRows ()) {
	            System.out.println();

	            //Loop through each fieldname and get the value
	            for (String field:fieldnames) {
	                System.out.print(row.get (field) + " | ");
	            }
	        }

	        //System.out.println();
	    }

	    /**
	     * 删除文档
	     * @param dID
	     * @param dDocName
	     * @throws IdcClientException
	     */
	    @SuppressWarnings("rawtypes")
		public void deleteFile (String dID) throws IdcClientException {
	        //Get the client (from the base class) and create a new binder
	        IdcClient client = getIdcClient();

	        //Call the service to delete the file
	        DataBinder dataBinder = client.createBinder ();
	        dataBinder.putLocal ("IdcService", "DELETE_DOC");
	        dataBinder.putLocal ("dID", dID);
	       // dataBinder.putLocal ("dDocName", dDocName);
	        ServiceResponse response = client.sendRequest (getIdcContext(), dataBinder);

	        //Convert the response to a dataBinder
	        DataBinder responseData = response.getResponseAsBinder ();

	        //Display the status of the service call
	        System.out.println (String.format("Content Server response: %s", responseData.getLocal ("StatusMessage")));
	    }
	    
	    /**
	     * 获取文档
	     * @param dID
	     * @return
	     * @throws IdcClientException
	     * @throws IOException
	     */
	    public byte[] getFile (String dID) throws IdcClientException, IOException {
	        //Get the client (from the base class) and create a new binder
	        IdcClient client = getIdcClient();
	        DataBinder dataBinder = client.createBinder ();

	        //retrieve the file, check the file size
	        dataBinder.putLocal ("IdcService", "GET_FILE");
	        dataBinder.putLocal ("dID", dID);
	        ServiceResponse response = client.sendRequest (getIdcContext(), dataBinder);
	        int reportedSize = Integer.parseInt (response.getHeader ("Content-Length"));
	        int retrievedSize = 0;
	        String contentsInHex = "";
	        //The file is streamed back to us in the response
	        InputStream ios = response.getResponseStream ();
	        byte[] outData = MyUcm.InputStreamToByte(ios);
	        return outData;
	    }

	    /**
	     * 创建docAccount
	     * @param accountName
	     * @throws IdcClientException
	     */
	    public void createAccount (String accountName) throws IdcClientException {
	        //Get the client (from the base class) and create a new binder
	        IdcClient client = getIdcClient();

	        //Call the service to delete the file
	        DataBinder dataBinder = client.createBinder ();
	        dataBinder.putLocal ("IdcService", "ADD_DOC_ACCOUNT");
	        dataBinder.putLocal ("dDocAccount", accountName);
	       // dataBinder.putLocal ("dDocName", dDocName);
	        ServiceResponse response = client.sendRequest (getIdcContext(), dataBinder);

	        //Convert the response to a dataBinder
	        DataBinder responseData = response.getResponseAsBinder ();

	        //Display the status of the service call
	        System.out.println (String.format("Content Server response: %s", responseData.getLocal ("StatusMessage")));
	    }
	    
	    public void deleteAccount (String accountName) throws IdcClientException {
	        //Get the client (from the base class) and create a new binder
	        IdcClient client = getIdcClient();

	        //Call the service to delete the file
	        DataBinder dataBinder = client.createBinder ();
	        dataBinder.putLocal ("IdcService", "DELETE_DOC_ACCOUNT");
	        dataBinder.putLocal ("dDocAccount", accountName);
	       // dataBinder.putLocal ("dDocName", dDocName);
	        ServiceResponse response = client.sendRequest (getIdcContext(), dataBinder);

	        //Convert the response to a dataBinder
	        DataBinder responseData = response.getResponseAsBinder ();

	        //Display the status of the service call
	        System.out.println (String.format("Content Server response: %s", responseData.getLocal ("StatusMessage")));
	    }
	    
	    public String makeFilePath (String filePath) throws IdcClientException {
	        //Get the client (from the base class) and create a new binder
	    	return filePath;
	    }
	    
	    /**
	     * 根据UCMID获取ucm文档名称
	     * @param dId
	     * @return
	     */
	    public String getDocTitle(String dId){
	    	String docTitle = "";
			IdcClient idcClient = getIdcClient();
			IdcContext idcContext = getIdcContext();
			DataBinder dataBinder = idcClient.createBinder();
			dataBinder.putLocal("IdcService", "DOC_INFO");
			dataBinder.putLocal("dID", dId);
			ServiceResponse response;
			
			try {
				response = idcClient.sendRequest(idcContext, dataBinder);
				DataBinder binder = response.getResponseAsBinder();
				DataResultSet searchResults = binder.getResultSet("DOC_INFO");
				docTitle = searchResults.getRows().get(0).get("dDocTitle")+"."+searchResults.getRows().get(0).get("dWebExtension");

			
			} catch (IdcClientException e) {
				e.printStackTrace();
			}			
	    	return docTitle;
	    }
	    /**
	     * getDocUcmUrl
	     * @param dId
	     * @return
	     */
	    public String getDocUcmUrl(String dId){
	    	String docUcmUrl = "";
			IdcClient idcClient = getIdcClient();
			IdcContext idcContext = getIdcContext();
			DataBinder dataBinder = idcClient.createBinder();
			dataBinder.putLocal("IdcService", "DOC_INFO");
			dataBinder.putLocal("dID", dId);
			ServiceResponse response;
			
			try {
				response = idcClient.sendRequest(idcContext, dataBinder);
				DataBinder binder = response.getResponseAsBinder();
				DataResultSet searchResults = binder.getResultSet("DOC_INFO");
				docUcmUrl = searchResults.getRows().get(0).get("dDocName")+"."+searchResults.getRows().get(0).get("dWebExtension");

			
			} catch (IdcClientException e) {
				e.printStackTrace();
			}			
	    	return docUcmUrl;
	    }
	    
	    /**
	     * 获取文档信息
	     * @param dId
	     * @return
	     */
	    public DataResultSet getDocInfo(String dId){
	    	String docUcmUrl = "";
	    	DataResultSet searchResults = null;
			IdcClient idcClient = getIdcClient();
			IdcContext idcContext = getIdcContext();
			DataBinder dataBinder = idcClient.createBinder();
			dataBinder.putLocal("IdcService", "DOC_INFO");
			dataBinder.putLocal("dID", dId);
			ServiceResponse response;
			
			try {
				response = idcClient.sendRequest(idcContext, dataBinder);
				DataBinder binder = response.getResponseAsBinder();
				searchResults = binder.getResultSet("DOC_INFO");
				//docUcmUrl = searchResults.getRows().get(0).get("dDocName")+"."+searchResults.getRows().get(0).get("dWebExtension");

			
			} catch (IdcClientException e) {
				e.printStackTrace();
			}			
	    	return searchResults;
	    }
	    /**
	     * 获取文件夹下面的文件夹列表
	     * @param collectionId
	     * @return
	     * @throws IdcClientException
	     */
	    @SuppressWarnings("unchecked")
		public DataResultSet getSubFolders(String collectionId) throws IdcClientException{
	    	DataResultSet ds = null;
	        IdcClient client = getIdcClient();
	        DataBinder dataBinder = client.createBinder ();
	        dataBinder.putLocal ("IdcService", "COLLECTION_GET_COLLECTIONS");//获得文件夹的列表
	        dataBinder.putLocal ("hasCollectionID", "true");
	        dataBinder.putLocal ("dCollectionID", collectionId);
	        ServiceResponse response = client.sendRequest (getIdcContext(), dataBinder);
	        DataBinder responseBinder = response.getResponseAsBinder();
	        ds = responseBinder.getResultSet ("COLLECTIONS");
	    	return ds;
	    }
	    /**
	     * 获取文件夹下面的文档列表
	     * @param collectionId
	     * @return
	     * @throws IdcClientException
	     */
	    @SuppressWarnings("unchecked")
		public DataResultSet getFilesInFolder(String collectionId) throws IdcClientException{
	    	DataResultSet ds = null;
	        IdcClient client = getIdcClient();
	        DataBinder dataBinder = client.createBinder ();
	        dataBinder.putLocal ("IdcService", "COLLECTION_GET_CONTENTS");//获得文件夹的列表
	        dataBinder.putLocal ("hasCollectionID", "true");
	        dataBinder.putLocal ("dCollectionID", collectionId);
	        ServiceResponse response = client.sendRequest (getIdcContext(), dataBinder);
	        DataBinder responseBinder = response.getResponseAsBinder();
	        ds = responseBinder.getResultSet ("CONTENTS");
	    	return ds;
	    }
	        
	    /**
	     * 把inputstream转换成byte[]
	     * @param in
	     * @return
	     * @throws IOException
	     */
	    public static byte[] InputStreamToByte(InputStream in) throws IOException{  
	        ByteArrayOutputStream outStream = new ByteArrayOutputStream();  
	        byte[] data = new byte[4096];  
	
	        int count = 0;  
	         while((count = in.read(data,0,data.length)) != -1){
	        	 outStream.write(data, 0, count);
	         }                  
	        data = null;  
	        return outStream.toByteArray();  
	    } 
	    
	    /**
	     * 获取文件的内容
	     * @param in
	     * @return
	     * @throws IOException
	     */
	    public static byte[] getFileBytes(String fileName,UserToken user) throws IOException{  
			String path = WebPathUtil.getWebProjectPath();
			String outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user.getEmpId();
			String inputFile = outFilePath +File.separator+fileName; 
			File uploadFile = new File(inputFile);
			if(uploadFile.exists()){
				InputStream fileStream= new FileInputStream(uploadFile);
				return InputStreamToByte(fileStream);
			}else{
				return null;
			}
	    }
	    
	    /**
	     * 通过项目id获取项目名称
	     * @param projectId
	     * @return
	     */
		public String getProjectNameById(String projectId){
			String projectName = "";
			String querySql = "select t.wbs_name from projwbs@p6db t where t.proj_node_flag = 'Y' and t.proj_id = '"+projectId+"'";
			Map m = jdbcDao.queryRecordBySQL(querySql);
			if(m!=null){
				projectName = m.get("wbs_name").toString();
			}else{
				projectName = projectId;
			}
			System.out.println("The project name is: "+projectName);
			return projectName;
		}
		/**
		 * 文档日志	 1添加, 2下载 ,3修改,4删除
		 * @param operationFlag
		 * @param operatorID
		 * @param creatorID
		 * @param updatorID
		 */
		@SuppressWarnings({ "rawtypes", "unchecked" })
			public void docLog(String fileID,String docVersionID,int operationFlag,String operatorID,String creatorID,String updatorID,String OrgId,String OrgSubId,String logFileTitle){
				//operationFlag 1add 2download 3modify 4delete 5view 6restore
				
				Map docLogMap = new HashMap();
				docLogMap.put("file_id", fileID);
				docLogMap.put("doc_version_id", docVersionID);
				docLogMap.put("operation", operationFlag);
				docLogMap.put("operator_id", operatorID);
				docLogMap.put("operation_date", new Date());
				docLogMap.put("bsflag", "0");
				docLogMap.put("create_date", new Date());
				docLogMap.put("creator_id", creatorID);
				docLogMap.put("modifi_date", new Date());
				docLogMap.put("updator_id", updatorID);		
				docLogMap.put("org_id", OrgId);
				docLogMap.put("org_subjection_id", OrgSubId);
				docLogMap.put("log_file_title", logFileTitle);
				jdbcDao.saveOrUpdateEntity(docLogMap, "bgp_doc_file_log");
			}
		/**
		 * 文档版本
		 * @param fileID
		 * @param fileVersion
		 * @param versionUcmId
		 * @param creatorID
		 * @param updatorID
		 */
		@SuppressWarnings({ "rawtypes", "unchecked" })
		public void docVersion(String fileID,String fileVersion,String versionUcmId,String creatorID,String updatorID,String OrgId,String OrgSubId,String fileVersionTitle){
			//operationFlag 1add 2download 3modify 4delete
			
			System.out.println("The fileVersionTitle is:"+fileVersionTitle);
			
			Map docVersionMap = new HashMap();
			docVersionMap.put("file_id", fileID);
			docVersionMap.put("file_version", fileVersion);
			docVersionMap.put("version_ucm_id", versionUcmId);
			docVersionMap.put("bsflag", "0");
			docVersionMap.put("create_date", new Date());
			docVersionMap.put("creator_id", creatorID);
			docVersionMap.put("modifi_date", new Date());
			docVersionMap.put("updator_id", updatorID);		
			docVersionMap.put("org_id", OrgId);
			docVersionMap.put("org_subjection_id", OrgSubId);
			docVersionMap.put("file_version_title", fileVersionTitle);
			jdbcDao.saveOrUpdateEntity(docVersionMap, "bgp_doc_file_version");
		}
		
		/**
		 * bgp_doc_gms_file 插入数据
		 * @param fileName
		 * @param fileType
		 * @param parentFileID
		 * @param projectID
		 * @param crateDate
		 * @param creatorID
		 * @param modifiDate
		 * @param updatorID
		 * @param bsflag
		 * @param isFile
		 * @param ucmID
		 */
		@SuppressWarnings({ "rawtypes", "unchecked" })
		public void insertDocInfo(String fileName,
				String parentFileID, String projectID, String creatorID, String updatorID,
				String OrgId,String OrgSubId) {
			Map paramMap = new HashMap();
			paramMap.put("file_name", fileName);
			paramMap.put("parent_file_id", parentFileID);
			paramMap.put("project_info_no", projectID);
			paramMap.put("bsflag", "0");
			paramMap.put("create_date", new Date());
			paramMap.put("creator_id", creatorID);
			paramMap.put("modifi_date", new Date());
			paramMap.put("updator_id", updatorID);
			paramMap.put("is_file", "0");
			paramMap.put("org_id", OrgId);
			paramMap.put("org_subjection_id", OrgSubId);
			jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_gms_file");

		}
		/**
		 * 获取文档在UCM服务器的存储位置
		 * @param ucmId
		 * @return
		 */
		@SuppressWarnings("rawtypes")
		public String getDocUrl(String ucmId){
			
			String gmsUrl = cfgHd.getSingleNodeValue("//p6/ucm/ucm_url");
			String doc_url = "";
			IdcClient idcClient = getIdcClient();
			IdcContext idcContext = getIdcContext();
			DataBinder dataBinder = idcClient.createBinder();
			dataBinder.putLocal("IdcService", "DOC_INFO");
			dataBinder.putLocal("dID", ucmId);
			ServiceResponse response;
			try {
				response = idcClient.sendRequest(idcContext, dataBinder);
				DataBinder binder = response.getResponseAsBinder();
				int indeStart = gmsUrl.indexOf("://");
				int indexEnd = gmsUrl.lastIndexOf(":");
				gmsUrl = gmsUrl.substring(indeStart,indexEnd);
				
				String urltemp = binder.getLocal("DocUrl");
				int index = urltemp.indexOf(":16200");
				String subStr = urltemp.substring(0,index);
				doc_url = urltemp.replaceFirst(subStr,"http"+gmsUrl);
			} catch (IdcClientException e) {
				e.printStackTrace();
			}
			return doc_url;
		}
		
		public List<Map> haveChildFolders(String parentId){
			List<Map> resultMap = null;
			String getChildFoldersSql = "select t.file_id from bgp_doc_gms_file t where t.bsflag = '0' and t.is_template = '1' and t.parent_file_id = '"+parentId+"'";
			List<Map> folderMapList = jdbcDao.queryRecords(getChildFoldersSql);
			if(folderMapList != null){
				for(Map folderMap : folderMapList){
					resultMap = haveChildFolders(folderMap.get("file_id").toString());
					//复制操作
				}
			}
			return resultMap;
		}
		
		/**
		 * 递归插入模板信息
		 * @param temp_folder_id
		 * @param proj_folder_id
		 * @param projectInfoNo
		 * @param use_id
		 * @param org_id
		 * @param org_subjection_id
		 */
		@SuppressWarnings({ "unchecked", "rawtypes" })
		public void setTemplate(String temp_folder_id,String proj_folder_id,String projectInfoNo,String use_id,String org_id,String org_subjection_id){
			//获取模板里的子信息
			Map save_proj_folder_map = new HashMap();
			String get_temp_childfolder = "select t.file_id,t.file_name,t.file_abbr,t.file_number_format from bgp_doc_gms_file t where t.bsflag = '0' and t.is_template = '1' and t.parent_file_id = '"+temp_folder_id+"'";
			List<Map> temp_folder_list = jdbcDao.queryRecords(get_temp_childfolder);
			if(temp_folder_list != null){
				for(Map temp_folder : temp_folder_list){
					save_proj_folder_map.put("file_name", temp_folder.get("file_name").toString()); 
					save_proj_folder_map.put("file_abbr", temp_folder.get("file_abbr").toString());
					save_proj_folder_map.put("file_number_format", temp_folder.get("file_number_format").toString());
					save_proj_folder_map.put("parent_file_id", proj_folder_id);
					save_proj_folder_map.put("project_info_no", projectInfoNo);
					save_proj_folder_map.put("bsflag", "0");
					save_proj_folder_map.put("create_date", new Date());
					save_proj_folder_map.put("creator_id", use_id);
					save_proj_folder_map.put("modifi_date", new Date());
					save_proj_folder_map.put("updator_id", use_id);
					save_proj_folder_map.put("is_file", "0");
					save_proj_folder_map.put("org_id", org_id);
					save_proj_folder_map.put("org_subjection_id", org_subjection_id);
					String new_proj_folder_id = jdbcDao.saveOrUpdateEntity(save_proj_folder_map, "bgp_doc_gms_file").toString();
					System.out.println("The new proj folder id is:"+new_proj_folder_id);
					setTemplate(temp_folder.get("file_id").toString(),new_proj_folder_id,projectInfoNo,use_id,org_id,org_subjection_id);
				}
			}
		}
		
		/**
		 * 载入目录模板信息(改进)
		 * @param temp_folder_id
		 * @param proj_folder_id
		 * @param projectInfoNo
		 * @param use_id
		 * @param org_id
		 * @param org_subjection_id
		 */
		public void setTemplateNew(String temp_folder_id,String projectInfoNo,String projectName,String user_id,String org_id,String org_subjection_id,String isTemplate){
			//获取模板里的子信息
			System.out.println("setTemplateNew");
			String file_number_format = cfgHd.getSingleNodeValue("//doc/number_format");
			StringBuffer setTemplateSql = new StringBuffer("insert into bgp_doc_gms_file(file_id,file_name,file_abbr,file_number_format,parent_file_id,project_info_no,bsflag,order_num,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id)");
			setTemplateSql.append(" select sys_guid() as file_id, t.file_name as file_name,t.file_abbr as file_abbr,t.file_number_format as file_number_format,t.parent_file_id as parent_file_id,'"+projectInfoNo+"' as project_info_no,'0' as bsflag,1000 as order_num,sysdate as create_date,'"+user_id+"' as creator_id,sysdate as modifi_date,'"+user_id+"' as updator_id,'0' as is_file,'"+org_id+"' as org_id,'"+org_subjection_id+"' as org_subjection_id from bgp_doc_gms_file t ");
			//setTemplateSql.append(" where t.bsflag = '0' and t.is_template = '1' and t.template_name = (select f.file_abbr from bgp_doc_gms_file f where f.file_id = '"+temp_folder_id+"' and f.bsflag = '0' and f.is_template = '1')");
			setTemplateSql.append("join bgp_doc_gms_file t1 on t.template_name = t1.file_abbr where t.bsflag = '0' and t.is_template = '"+isTemplate+"' and t1.file_id = '"+temp_folder_id+"'");
			
			jdbcTemplate.execute(setTemplateSql.toString());	
			
			String update_sql = "update bgp_doc_gms_file t set t.file_name = '"+projectName+"',t.file_number_format = '"+file_number_format+"' where t.bsflag = '0' and t.is_template is null and t.parent_file_id is null and t.project_info_no ='"+projectInfoNo+"'";
			jdbcDao.executeUpdate(update_sql);
			
		}
		
		
		/**
		 * 判断某一节点是否包含子节点
		 * @param parentId
		 * @return
		 */
		public boolean hasChildFolders(String parentId){
			boolean has_child_folder = false;
			String getChildFoldersSql = "select t.file_id from bgp_doc_gms_file t where t.bsflag = '0' and t.is_template = '1' and t.parent_file_id = '"+parentId+"'";
			if(jdbcDao.queryRecords(getChildFoldersSql) != null){
				has_child_folder = true;
			}
			return has_child_folder;
		}
		
		/**
		 * 获取
		 * @param folderID
		 */
		public void getDocsInFolder(String folderID){
			String get_docs_Sql = "select * from bgp_doc_gms_file t where t.bsflag = '0' and t.parent_file_id = '"+folderID+"'";
			List<Map> doc_list = jdbcDao.queryRecords(get_docs_Sql);
			System.out.println("list is:"+doc_list.size());
			if(doc_list != null){
				for(Map docMap : doc_list){
					String is_file = docMap.get("is_file").toString();
					if("1".equals(is_file)){
						//是文档，打印相关信息
						System.out.println("doc");
						String ucm_id = docMap.get("ucm_id").toString();
						System.out.println("ucm id is:"+ucm_id);
						String file_name = docMap.get("file_name").toString();
						System.out.println("file name is:"+file_name);
					}else if("0".equals(is_file)){
						//不是文档，继续查询
						System.out.println("folder");
						String folder_id = docMap.get("file_id").toString();
						getDocsInFolder(folder_id);
					}
				}
			}

		}
		
		/**
		 * 创建项目的文档目录结构
		 * @param projectNo
		 * @param projectName
		 * @param userId
		 * @param codeAffordOrgID
		 * @param subOrgIDofAffordOrg
		 * @param templateId
		 * @throws Exception
		 */
		@SuppressWarnings({ "rawtypes", "unchecked" })
//		public void createProjectFolder(String projectNo,String projectName,String userId,String codeAffordOrgID,String subOrgIDofAffordOrg) throws Exception {
//			System.out.println("createProjectFolder !");
//			//固定了所选的模板
//			//String templateId = "8ad89177389cdae001389cfa64e10003";
//			String templateId = cfgHd.getSingleNodeValue("//doc/template_id");
//			String file_number_format = cfgHd.getSingleNodeValue("//doc/number_format");
//			if(projectNo !="" &&projectNo != null){
//				System.out.println("选择了项目，项目不为空");
//				Map folderInfoMap = new HashMap();
//				String checkSql = "select count(*) as projectcount from bgp_doc_gms_file t where t.project_info_no = '"+projectNo+"' and t.bsflag = '0' and t.is_file = '0' and t.parent_file_id is null";
//				if(Integer.parseInt(jdbcDao.queryRecordBySQL(checkSql).get("projectcount").toString())== 0){
//					//该数据不存在，需要插入
//					System.out.println("该项目目录不存在");
//					folderInfoMap.put("file_name", projectName);
//					folderInfoMap.put("project_info_no", projectNo);
//					folderInfoMap.put("bsflag", "0");
//					folderInfoMap.put("create_date", new Date());
//					folderInfoMap.put("creator_id", userId);
//					folderInfoMap.put("modifi_date", new Date());
//					folderInfoMap.put("updator_id", userId);
//					folderInfoMap.put("is_file", "0");
//					folderInfoMap.put("file_abbr", "root");
//					folderInfoMap.put("file_number_format", file_number_format);
//					folderInfoMap.put("org_id", codeAffordOrgID);
//					folderInfoMap.put("org_subjection_id", subOrgIDofAffordOrg);
//					jdbcDao.saveOrUpdateEntity(folderInfoMap, "bgp_doc_gms_file");
//					
//					if(projectNo!=""&&projectNo!=null&&templateId!=""&&templateId!=null){
//						setTemplate(templateId, projectNo, projectNo, userId, codeAffordOrgID,subOrgIDofAffordOrg);
//						jdbcDao.executeUpdate("update bgp_doc_gms_file t set t.is_template_used = '1' where t.is_template = '1' and t.file_id = '"+templateId+"'");
//					}		
//					
//				}else{
//					System.out.println("该项目目录已存在");
//				}
//			}else{
//				System.out.println("没选项目");
//			}
//		}
		
		/**
		 * 创建项目的文档目录结构(直接导入数据库的数据)
		 * @param projectNo
		 * @param projectName
		 * @param userId
		 * @param codeAffordOrgID
		 * @param subOrgIDofAffordOrg
		 * @throws Exception
		 */
		public void createProjectFolderNew(String projectNo,String projectName,String userId,String codeAffordOrgID,String subOrgIDofAffordOrg,String projectType) throws Exception {
			System.out.println("createProjectFolderNew !");
			//固定了所选的模板,采集项目文档模板	
			//String templateId = "8ad891f738e0c89c0138e0e94d5a0004";
			String templateId = null;
			if(projectNo !="" &&projectNo != null){
				System.out.println("选择了项目，项目不为空");
				String checkSql = "select count(*) as projectcount from bgp_doc_gms_file t where t.project_info_no = '"+projectNo+"' and t.bsflag = '0' and t.is_file = '0' and t.parent_file_id is null";
				if(Integer.parseInt(jdbcDao.queryRecordBySQL(checkSql).get("projectcount").toString())== 0){
					//该数据不存在，需要插入
					Log.info("该项目目录不存在");
					
					if(projectType==null){
						//吴海军， 根据项目类型添加井中模版
						String sqlProjectType = "select  t.project_type projectType from gp_task_project t  where t.project_info_no ='"+projectNo+"' ";
						Map mapProjectType = jdbcDao.queryRecordBySQL(sqlProjectType);
						if(mapProjectType!=null && mapProjectType.isEmpty()){
							projectType = (String)mapProjectType.get("projectType");
						}
					}
			
					String isTemplate =null;
					//井中项目
					if(ZJ_PROJECT_TYPE.equals(projectType)){
						isTemplate = "2";
						templateId = cfgHd.getSingleNodeValue("//doc/zj_template_id");
					} else {
				    //其他项目
						isTemplate = "1";
						templateId = cfgHd.getSingleNodeValue("//doc/template_id");
					}
					
					if(projectNo!=""&&projectNo!=null&&templateId!=""&&templateId!=null){
						setTemplateNew(templateId, projectNo, projectName, userId, codeAffordOrgID, subOrgIDofAffordOrg,isTemplate);
						
						jdbcDao.executeUpdate("update bgp_doc_gms_file t set t.is_template_used = '1' where t.is_template = '"+isTemplate+"' and t.file_id = '"+templateId+"'");
					}		
					setModuleFolder(projectNo,userId,codeAffordOrgID,subOrgIDofAffordOrg);
				}else{
					System.out.println("该项目目录已存在");
				}
			}else{
				System.out.println("没选项目");
			}
		}
		
		/**
		 * 为模块分配固定的文件夹
		 * @param projectNo
		 * @param projectName
		 * @param userId
		 * @param codeAffordOrgID
		 * @param subOrgIDofAffordOrg
		 */
				
		public void setModuleFolder(String projectNo,String userId,String codeAffordOrgID,String subOrgIDofAffordOrg){
				System.out.println("setModuleFolder!");
				String risk_module_id = cfgHd.getSingleNodeValue("//doc/risk_module_id");
				String hse_module_id = cfgHd.getSingleNodeValue("//doc/hse_module_id");
				String op_module_id = cfgHd.getSingleNodeValue("//doc/op_module_id");
				String em_module_id = cfgHd.getSingleNodeValue("//doc/em_module_id");
				String pm_module_id = cfgHd.getSingleNodeValue("//doc/pm_module_id");
				String dm_module_id = cfgHd.getSingleNodeValue("//doc/dm_module_id");
				String market_module_id = cfgHd.getSingleNodeValue("//doc/market_module_id");
				String mat_module_id = cfgHd.getSingleNodeValue("//doc/mat_module_id");
				String qua_module_id = cfgHd.getSingleNodeValue("//doc/qua_module_id");
				String tech_module_id = cfgHd.getSingleNodeValue("//doc/tech_module_id");
				
				String sql = "select f.file_id,f.file_name,f.file_abbr from bgp_doc_gms_file f where f.bsflag = '0' and f.is_template is null and f.is_file = '0' and f.file_abbr in ('HSE','SCGL','SA','JY','SB','WZ','RL','ZL','FX','JS') and f.project_info_no = '"+projectNo+"' order by f.file_abbr";
				List list = jdbcDao.queryRecords(sql);
				Map paramMap = new HashMap();
				if(list != null){
					for(int i = 0;i<list.size();i++){
						Map map = (Map)list.get(i);
						if(map.get("file_abbr")!=null && map.get("file_abbr").toString().equals("FX") && map.get("file_name").toString().equals("风险")){
							//paramMap.put("module_id", "8ad891f738e022910138e02560000002");
							paramMap.put("module_id", risk_module_id);
							paramMap.put("folder_id", map.get("file_id"));
							paramMap.put("folder_name", map.get("file_name"));
							paramMap.put("module_name", "风险管理");
							paramMap.put("bsflag", "0");
							paramMap.put("create_date", new Date());
							paramMap.put("creator_id", userId);
							paramMap.put("modifi_date", new Date());
							paramMap.put("updator_id", userId);
							paramMap.put("org_id", codeAffordOrgID);
							paramMap.put("org_subjection_id", subOrgIDofAffordOrg);
							paramMap.put("project_info_no", projectNo);
							jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
						}
						if(map.get("file_abbr")!=null && map.get("file_abbr").toString().equals("HSE") && map.get("file_name").toString().equals("HSE")){
							//paramMap.put("module_id", "8ad891d8380783e6013807edd9d00003");
							paramMap.put("module_id", hse_module_id);
							paramMap.put("folder_id", map.get("file_id"));
							paramMap.put("folder_name", map.get("file_name"));
							paramMap.put("module_name", "HSE管理");
							paramMap.put("bsflag", "0");
							paramMap.put("create_date", new Date());
							paramMap.put("creator_id", userId);
							paramMap.put("modifi_date", new Date());
							paramMap.put("updator_id", userId);
							paramMap.put("org_id", codeAffordOrgID);
							paramMap.put("org_subjection_id", subOrgIDofAffordOrg);
							paramMap.put("project_info_no", projectNo);
							jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
						}
						if(map.get("file_abbr")!=null && map.get("file_abbr").toString().equals("JY") && map.get("file_name").toString().equals("经营")){
							//paramMap.put("module_id", "8ad8916d37d4641f0137d559d8f30002");
							paramMap.put("module_id", op_module_id);
							paramMap.put("folder_id", map.get("file_id"));
							paramMap.put("folder_name", map.get("file_name"));
							paramMap.put("module_name", "经营管理");
							paramMap.put("bsflag", "0");
							paramMap.put("create_date", new Date());
							paramMap.put("creator_id", userId);
							paramMap.put("modifi_date", new Date());
							paramMap.put("updator_id", userId);
							paramMap.put("org_id", codeAffordOrgID);
							paramMap.put("org_subjection_id", subOrgIDofAffordOrg);
							paramMap.put("project_info_no", projectNo);
							jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
						}
						if(map.get("file_abbr")!=null && map.get("file_abbr").toString().equals("RL") && map.get("file_name").toString().equals("人力资源")){
							//paramMap.put("module_id", "8ad889ec37c46d760137c480f1a60002");
							paramMap.put("module_id", em_module_id);
							paramMap.put("folder_id", map.get("file_id"));
							paramMap.put("folder_name", map.get("file_name"));
							paramMap.put("module_name", "人力资源");
							paramMap.put("bsflag", "0");
							paramMap.put("create_date", new Date());
							paramMap.put("creator_id", userId);
							paramMap.put("modifi_date", new Date());
							paramMap.put("updator_id", userId);
							paramMap.put("org_id", codeAffordOrgID);
							paramMap.put("org_subjection_id", subOrgIDofAffordOrg);
							paramMap.put("project_info_no", projectNo);
							jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
						}
						if(map.get("file_abbr")!=null && map.get("file_abbr").toString().equals("SA") && map.get("file_name").toString().equals("生产")){
							//paramMap.put("module_id", "8ad8892637c5af3d0137c5b365140001");
							paramMap.put("module_id", pm_module_id);
							paramMap.put("folder_id", map.get("file_id"));
							paramMap.put("folder_name", map.get("file_name"));
							paramMap.put("module_name", "生产管理");
							paramMap.put("bsflag", "0");
							paramMap.put("create_date", new Date());
							paramMap.put("creator_id", userId);
							paramMap.put("modifi_date", new Date());
							paramMap.put("updator_id", userId);
							paramMap.put("org_id", codeAffordOrgID);
							paramMap.put("org_subjection_id", subOrgIDofAffordOrg);
							paramMap.put("project_info_no", projectNo);
							jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
						}
						if(map.get("file_abbr")!=null && map.get("file_abbr").toString().equals("SB") && map.get("file_name").toString().equals("设备")){
							//paramMap.put("module_id", "40288a8137fd4bd00137fda969cc0003");
							paramMap.put("module_id", dm_module_id);
							paramMap.put("folder_id", map.get("file_id"));
							paramMap.put("folder_name", map.get("file_name"));
							paramMap.put("module_name", "设备管理");
							paramMap.put("bsflag", "0");
							paramMap.put("create_date", new Date());
							paramMap.put("creator_id", userId);
							paramMap.put("modifi_date", new Date());
							paramMap.put("updator_id", userId);
							paramMap.put("org_id", codeAffordOrgID);
							paramMap.put("org_subjection_id", subOrgIDofAffordOrg);
							paramMap.put("project_info_no", projectNo);
							jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
						}
						if(map.get("file_abbr")!=null && map.get("file_abbr").toString().equals("SCGL") && map.get("file_name").toString().equals("市场管理")){
							//paramMap.put("module_id", "8ad889c437c0f7c60137c101da250003");
							paramMap.put("module_id", market_module_id);
							paramMap.put("folder_id", map.get("file_id"));
							paramMap.put("folder_name", map.get("file_name"));
							paramMap.put("module_name", "市场信息");
							paramMap.put("bsflag", "0");
							paramMap.put("create_date", new Date());
							paramMap.put("creator_id", userId);
							paramMap.put("modifi_date", new Date());
							paramMap.put("updator_id", userId);
							paramMap.put("org_id", codeAffordOrgID);
							paramMap.put("org_subjection_id", subOrgIDofAffordOrg);
							paramMap.put("project_info_no", projectNo);
							jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
						}
						if(map.get("file_abbr")!=null && map.get("file_abbr").toString().equals("WZ") && map.get("file_name").toString().equals("物资")){
							//paramMap.put("module_id", "8ad889bd37cabe080137cac1698e0002");
							paramMap.put("module_id", mat_module_id);
							paramMap.put("folder_id", map.get("file_id"));
							paramMap.put("folder_name", map.get("file_name"));
							paramMap.put("module_name", "物资管理");
							paramMap.put("bsflag", "0");
							paramMap.put("create_date", new Date());
							paramMap.put("creator_id", userId);
							paramMap.put("modifi_date", new Date());
							paramMap.put("updator_id", userId);
							paramMap.put("org_id", codeAffordOrgID);
							paramMap.put("org_subjection_id", subOrgIDofAffordOrg);
							paramMap.put("project_info_no", projectNo);
							jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
						}
						if(map.get("file_abbr")!=null && map.get("file_abbr").toString().equals("ZL") && map.get("file_name").toString().equals("质量")){
							//paramMap.put("module_id", "8ad8897037bf52290137bf59caa20001");
							paramMap.put("module_id", qua_module_id);
							paramMap.put("folder_id", map.get("file_id"));
							paramMap.put("folder_name", map.get("file_name"));
							paramMap.put("module_name", "质量管理");
							paramMap.put("bsflag", "0");
							paramMap.put("create_date", new Date());
							paramMap.put("creator_id", userId);
							paramMap.put("modifi_date", new Date());
							paramMap.put("updator_id", userId);
							paramMap.put("org_id", codeAffordOrgID);
							paramMap.put("org_subjection_id", subOrgIDofAffordOrg);
							paramMap.put("project_info_no", projectNo);
							jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
						}
						if(map.get("file_abbr")!=null && map.get("file_abbr").toString().equals("JS") && map.get("file_name").toString().equals("技术")){
							//paramMap.put("module_id", "8ad8913639d33c0a0139d3e1af560016");
							paramMap.put("module_id", tech_module_id);
							paramMap.put("folder_id", map.get("file_id"));
							paramMap.put("folder_name", map.get("file_name"));
							paramMap.put("module_name", "技术管理");
							paramMap.put("bsflag", "0");
							paramMap.put("create_date", new Date());
							paramMap.put("creator_id", userId);
							paramMap.put("modifi_date", new Date());
							paramMap.put("updator_id", userId);
							paramMap.put("org_id", codeAffordOrgID);
							paramMap.put("org_subjection_id", subOrgIDofAffordOrg);
							paramMap.put("project_info_no", projectNo);
							jdbcDao.saveOrUpdateEntity(paramMap, "bgp_doc_folder_module");
						}
					}
				}
		}
		
		
		
		
		
		/**
		 * 创建项目的文档目录结构(直接导入数据库的数据)
		 * @param projectNo
		 * @param projectName
		 * @param userId
		 * @param codeAffordOrgID
		 * @param subOrgIDofAffordOrg
		 * @throws Exception
		 */
		public void createProjectFolderNew(String projectNo,String projectName,String userId,String codeAffordOrgID,String subOrgIDofAffordOrg) throws Exception {
			System.out.println("createProjectFolderNew !");
			//固定了所选的模板,采集项目文档模板	
			//String templateId = "8ad891f738e0c89c0138e0e94d5a0004";
			String templateId = cfgHd.getSingleNodeValue("//doc/template_id");
			if(projectNo !="" &&projectNo != null){
				System.out.println("选择了项目，项目不为空");
				String checkSql = "select count(*) as projectcount from bgp_doc_gms_file t where t.project_info_no = '"+projectNo+"' and t.bsflag = '0' and t.is_file = '0' and t.parent_file_id is null";
				if(Integer.parseInt(jdbcDao.queryRecordBySQL(checkSql).get("projectcount").toString())== 0){
					//该数据不存在，需要插入
					System.out.println("该项目目录不存在");
					
					if(projectNo!=""&&projectNo!=null&&templateId!=""&&templateId!=null){
						setTemplateNew(templateId, projectNo, projectName, userId, codeAffordOrgID, subOrgIDofAffordOrg);
						jdbcDao.executeUpdate("update bgp_doc_gms_file t set t.is_template_used = '1' where t.is_template = '1' and t.file_id = '"+templateId+"'");
					}		
					setModuleFolder(projectNo,userId,codeAffordOrgID,subOrgIDofAffordOrg);
				}else{
					System.out.println("该项目目录已存在");
				}
			}else{
				System.out.println("没选项目");
			}
		}
		
		
		
		/**
		 * 载入目录模板信息(改进)
		 * @param temp_folder_id
		 * @param proj_folder_id
		 * @param projectInfoNo
		 * @param use_id
		 * @param org_id
		 * @param org_subjection_id
		 */
		public void setTemplateNew(String temp_folder_id,String projectInfoNo,String projectName,String user_id,String org_id,String org_subjection_id){
			//获取模板里的子信息
			System.out.println("setTemplateNew");
			String file_number_format = cfgHd.getSingleNodeValue("//doc/number_format");
			StringBuffer setTemplateSql = new StringBuffer("insert into bgp_doc_gms_file(file_id,file_name,file_abbr,file_number_format,parent_file_id,project_info_no,bsflag,order_num,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id)");
			setTemplateSql.append(" select sys_guid() as file_id, t.file_name as file_name,t.file_abbr as file_abbr,t.file_number_format as file_number_format,t.parent_file_id as parent_file_id,'"+projectInfoNo+"' as project_info_no,'0' as bsflag,1000 as order_num,sysdate as create_date,'"+user_id+"' as creator_id,sysdate as modifi_date,'"+user_id+"' as updator_id,'0' as is_file,'"+org_id+"' as org_id,'"+org_subjection_id+"' as org_subjection_id from bgp_doc_gms_file t ");
			//setTemplateSql.append(" where t.bsflag = '0' and t.is_template = '1' and t.template_name = (select f.file_abbr from bgp_doc_gms_file f where f.file_id = '"+temp_folder_id+"' and f.bsflag = '0' and f.is_template = '1')");
			setTemplateSql.append("join bgp_doc_gms_file t1 on t.template_name = t1.file_abbr where t.bsflag = '0' and t.is_template = '1' and t1.file_id = '"+temp_folder_id+"'");
			
			jdbcTemplate.execute(setTemplateSql.toString());	
			
			String update_sql = "update bgp_doc_gms_file t set t.file_name = '"+projectName+"',t.file_number_format = '"+file_number_format+"' where t.bsflag = '0' and t.is_template is null and t.parent_file_id is null and t.project_info_no ='"+projectInfoNo+"'";
			jdbcDao.executeUpdate(update_sql);
			
		}
}