package com.bgp.mcs.service.ma.marketInfoInput;

import java.io.Serializable;
import java.net.URLDecoder;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.ma.showMainFrame.util.MarketGetInfoUtil;
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
import com.cnpc.jcdp.soa.xpdl.log.provider.SysoutLogProvider;
//import com.cnpc.oms.dao.DAOFactory;
//import com.cnpc.oms.gnr.dao.QueryJdbcDAO;

@SuppressWarnings({ "rawtypes", "unchecked", "unused" })
public class MarketInfoInputSrv extends BaseService {

	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
//	QueryJdbcDAO dao = (QueryJdbcDAO) DAOFactory.getDAO("queryJdbcDAO");
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	IBaseDao baseDao = BeanFactory.getBaseDao();
	
	private MarketGetInfoUtil mg=MarketGetInfoUtil.getInstance();
	
	//历史数据市场周月季报维护    附件下载
	public ISrvMsg queryFile(ISrvMsg isrvmsg)throws Exception{
    MQMsgImpl mqmsgimpl = (MQMsgImpl)SrvMsgUtil.createMQResponseMsg(isrvmsg);
    String s1 = isrvmsg.getValue("pkValue");
    
    String s2 = (new StringBuilder()).append("SELECT attach_content,attach_name FROM comm_attachment WHERE attach_id='").append(s1).append("'").toString();
    
    Map map = jdbcDao.queryRecordBySQL(s2);
    byte abyte0[] = (byte[])(byte[])map.get("attach_content");
    WSFile wsfile = new WSFile();
    wsfile.setFilename((String)map.get("attach_name"));
    wsfile.setFileData(abyte0);
    mqmsgimpl.setFile(wsfile);
    return mqmsgimpl;
	}
 
	// 市场开发添加
	public ISrvMsg addSckf(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		String infoId = isrvmsg.getValue("fileId");

		String infomation_name = isrvmsg.getValue("infomation_name");
		String release_date = isrvmsg.getValue("release_date");
		String cateId = isrvmsg.getValue("two_type_id");
		String threeTypeId = isrvmsg.getValue("three_type_id");
		String infomation_id = isrvmsg.getValue("infomation_id");
		Date now = new Date();
		Map map = new HashMap();

		String procId = (String) map.get("procId");
		if (infoId == null || "".equals(infoId)) {
			infoId = jdbcDao.generateUUID();
			String sqlFileIndex = "insert into p_file_index (info_id) values('" + infoId + "')";
			jdbcTemplate.execute(sqlFileIndex);
		}

		for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			// String sql =
			// "update p_file_content set bsflag = '1' where org_id ='" +
			// user.getOrgId() + "' and info_id='" + infoId + "'";
			// jdbcTemplate.execute(sql);
			Map fileMap = new HashMap();
			fileMap.put("file_name", fs.getFilename());
			fileMap.put("file_size", fs.getFilesize());
			fileMap.put("file_content", fs.getFileData());
			fileMap.put("info_id", infoId);
			fileMap.put("creator", user.getUserId());
			fileMap.put("create_date", new Date());
			fileMap.put("updator", user.getUserId());
			fileMap.put("modifi_date", new Date());
			fileMap.put("org_id", user.getOrgId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "P_FILE_CONTENT");

		}

		Map fileMap1 = new HashMap();
		fileMap1.put("infomation_id", infomation_id);
		fileMap1.put("infomation_name", infomation_name);
		fileMap1.put("release_date", release_date);
		fileMap1.put("abstract", isrvmsg.getValue("abstract"));
		fileMap1.put("two_type_id", cateId);
		fileMap1.put("three_type_id", threeTypeId);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFY_USER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");

		String content = isrvmsg.getValue("content") == null ? "" : isrvmsg.getValue("content");
		fileMap1.put("content", content.getBytes("GBK"));
		fileMap1.put("file_id", infoId);

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "BGP_INFOMATION_RELEASE_INFO");
		
		String title = user.getUserName() +"在后台发布中市场开发里添加了一条标题为：“"+infomation_name+"”的信息";
		String operationPlace = "市场开发";
		mg.addLogInfo(title, operationPlace);
		return responseDTO;

	}

	public ISrvMsg viewSckf(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String infomation_id = isrvmsg.getValue("infomation_id");

		String sql = "select * from bgp_infomation_release_info r where infomation_id='" + infomation_id + "'";
		String sql2 = "select p.file_id,p.file_name from bgp_infomation_release_info r,p_file_content p where r.file_id=p.info_id and p.bsflag='0' and r.infomation_id='"
				+ infomation_id + "'";
		String sql3 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.two_type_id=t.code and r.infomation_id='"
				+ infomation_id + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);

		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content = new String((byte[]) map.get("content"), "GBK");
			responseDTO.setValue("content", content);
		} else {
			String content = "";
			responseDTO.setValue("content", content);
		}

		responseDTO.setValue("marketMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("mapType", mapType);
		return responseDTO;
	}

	public ISrvMsg editSckf(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String infomation_id = isrvmsg.getValue("infomation_id");

		String sql = "select * from bgp_infomation_release_info r where infomation_id='" + infomation_id + "'";
		String sql2 = "select p.file_id,p.file_name,p.info_id from bgp_infomation_release_info r,p_file_content p where r.file_id=p.info_id and p.bsflag='0' and r.infomation_id='"
				+ infomation_id + "'";
		String sql3 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.two_type_id=t.code and r.infomation_id='"
				+ infomation_id + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);

		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content = new String((byte[]) map.get("content"), "GBK");
			responseDTO.setValue("content", content);
		} else {
			String content = "";
			responseDTO.setValue("content", content);
		}

		responseDTO.setValue("marketMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("mapType", mapType);
		return responseDTO;
	}

	public ISrvMsg updateSckf(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		String infomation_name = isrvmsg.getValue("infomation_name");
		String release_date = isrvmsg.getValue("release_date");
		String cateId = isrvmsg.getValue("two_type_id");
		String infomation_id = isrvmsg.getValue("infomation_id");
		List<WSFile> fileList = mqMsg.getFiles();
		String threeTypeId = isrvmsg.getValue("three_type_id");
		String infoId = isrvmsg.getValue("infoId");

		Date now = new Date();
		Map map = new HashMap();
		// 暂时用BGP_TS_QUESTION_WF的proc_inst_id存储组织机构隶属ID
		//删除附件
		String deletedFiles = isrvmsg.getValue("deletedFiles");
		if(deletedFiles!=null&&!"".equals(deletedFiles)){
			String del[] = deletedFiles.split(",");
			int len = del.length;
			for(int i=0;i<len ;i++){
				String delSql = "update p_file_content set bsflag = '1' where file_id='"+del[i]+"'";
				jdbcTemplate.execute(delSql);
			}
		}

		if (infoId == null || "".equals(infoId)) {
			infoId = jdbcDao.generateUUID();
			String sqlFileIndex = "insert into p_file_index (info_id) values('" + infoId + "')";
			jdbcTemplate.execute(sqlFileIndex);
		}

		for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			Map fileMap = new HashMap();
			fileMap.put("file_name", fs.getFilename());
			fileMap.put("file_size", fs.getFilesize());
			fileMap.put("file_content", fs.getFileData());
			fileMap.put("info_id", infoId);
			fileMap.put("creator", user.getUserId());
			fileMap.put("create_date", new Date());
			fileMap.put("updator", user.getUserId());
			fileMap.put("modifi_date", new Date());
			fileMap.put("org_id", user.getOrgId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "P_FILE_CONTENT");
		
		}
		
		String three = threeTypeId == null ? "" : threeTypeId;
		if(!cateId.equals("10306")&&!cateId.equals("10307")){
			three = "";
		}
		
		Map fileMap1 = new HashMap();
		fileMap1.put("infomation_id", infomation_id);
		fileMap1.put("infomation_name", infomation_name);
		fileMap1.put("release_date", release_date);
		fileMap1.put("two_type_id", cateId);
		fileMap1.put("three_type_id", three);
		fileMap1.put("MODIFY_USER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");
		
		String abstr = isrvmsg.getValue("abstract") == null ? "" : isrvmsg.getValue("abstract");
		String content = isrvmsg.getValue("content") == null ? "" : isrvmsg.getValue("content");
		fileMap1.put("content", content.getBytes("GBK"));
		fileMap1.put("abstract", abstr);

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "BGP_INFOMATION_RELEASE_INFO");
		
		String title = user.getUserName() +"在后台发布中市场开发里修改了一条标题为：“"+infomation_name+"”的信息";
		String operationPlace = "市场开发";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;

	}

	// 市场管理添加
	public ISrvMsg addManage(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		String infoId = isrvmsg.getValue("fileId");
		String infomation_name = isrvmsg.getValue("infomation_name");
		String release_date = isrvmsg.getValue("release_date");
		String cateId = isrvmsg.getValue("two_type_id");
		String infomation_id = isrvmsg.getValue("infomation_id");
		String threeTypeId = isrvmsg.getValue("three_type_id");
		Date now = new Date();
		Map map = new HashMap();

		String procId = (String) map.get("procId");
		if (infoId == null || "".equals(infoId)) {
			infoId = jdbcDao.generateUUID();
			String sqlFileIndex = "insert into p_file_index (info_id) values('" + infoId + "')";
			jdbcTemplate.execute(sqlFileIndex);
		}

		for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			// String sql =
			// "update p_file_content set bsflag = '1' where org_id ='" +
			// user.getOrgId() + "' and info_id='" + infoId + "'";
			// jdbcTemplate.execute(sql);
			Map fileMap = new HashMap();
			fileMap.put("file_name", fs.getFilename());
			fileMap.put("file_size", fs.getFilesize());
			fileMap.put("file_content", fs.getFileData());
			fileMap.put("info_id", infoId);
			fileMap.put("creator", user.getUserId());
			fileMap.put("create_date", new Date());
			fileMap.put("updator", user.getUserId());
			fileMap.put("modifi_date", new Date());
			fileMap.put("org_id", user.getOrgId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "P_FILE_CONTENT");

		}

		Map fileMap1 = new HashMap();
		fileMap1.put("infomation_id", infomation_id);
		fileMap1.put("infomation_name", infomation_name);
		fileMap1.put("release_date", release_date);
		fileMap1.put("abstract", isrvmsg.getValue("abstract"));
		fileMap1.put("two_type_id", cateId);
		fileMap1.put("three_type_id", threeTypeId);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFY_USER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");

		String content = isrvmsg.getValue("content") == null ? "" : isrvmsg.getValue("content");
		fileMap1.put("content", content.getBytes("GBK"));
		fileMap1.put("file_id", infoId);

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "BGP_INFOMATION_RELEASE_INFO");
		String title = user.getUserName() +"在后台发布中市场管理里添加了一条标题为：“"+infomation_name+"”的信息";
		String operationPlace = "市场管理";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;
	}

	public ISrvMsg viewManage(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String infomation_id = isrvmsg.getValue("infomation_id");

		String sql = "select * from bgp_infomation_release_info r where infomation_id='" + infomation_id + "'";
		String sql2 = "select p.file_id,p.file_name from bgp_infomation_release_info r,p_file_content p where r.file_id=p.info_id and p.bsflag='0' and r.infomation_id='"
				+ infomation_id + "'";
		String sql3 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.two_type_id=t.code and r.infomation_id='"
				+ infomation_id + "'";
		String sql4 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.three_type_id=t.code and r.infomation_id='"
			+ infomation_id + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);
		Map threeType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql4);
		

		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content = new String((byte[]) map.get("content"), "GBK");
			responseDTO.setValue("content", content);
		} else {
			String content = "";
			responseDTO.setValue("content", content);
		}

		responseDTO.setValue("marketMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("mapType", mapType);
		responseDTO.setValue("threeType", threeType);
		return responseDTO;
	}

	public ISrvMsg editManage(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String infomation_id = isrvmsg.getValue("infomation_id");

		String sql = "select * from bgp_infomation_release_info r where infomation_id='" + infomation_id + "'";
		String sql2 = "select p.file_id,p.file_name from bgp_infomation_release_info r,p_file_content p where r.file_id=p.info_id and p.bsflag='0' and r.infomation_id='"
				+ infomation_id + "'";
		String sql3 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.two_type_id=t.code and r.infomation_id='"
				+ infomation_id + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);

		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content = new String((byte[]) map.get("content"), "GBK");
			responseDTO.setValue("content", content);
		} else {
			String content = "";
			responseDTO.setValue("content", content);
		}

		responseDTO.setValue("marketMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("mapType", mapType);
		return responseDTO;
	}

	public ISrvMsg updateManage(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		String infomation_name = isrvmsg.getValue("infomation_name");
		String release_date = isrvmsg.getValue("release_date");
		String cateId = isrvmsg.getValue("two_type_id");
		String threeTypeId = isrvmsg.getValue("three_type_id");
		String infomation_id = isrvmsg.getValue("infomation_id");
		List<WSFile> fileList = mqMsg.getFiles();
		String infoId = isrvmsg.getValue("infoId");
		Date now = new Date();
		Map map = new HashMap();
		
		//删除附件
		String deletedFiles = isrvmsg.getValue("deletedFiles");
		if(deletedFiles!=null&&!"".equals(deletedFiles)){
			String del[] = deletedFiles.split(",");
			int len = del.length;
			for(int i=0;i<len ;i++){
				String delSql = "update p_file_content set bsflag = '1' where file_id='"+del[i]+"'";
				jdbcTemplate.execute(delSql);
			}
		}

		if (infoId == null || "".equals(infoId)) {
			infoId = jdbcDao.generateUUID();
			String sqlFileIndex = "insert into p_file_index (info_id) values('" + infoId + "')";
			jdbcTemplate.execute(sqlFileIndex);
		}

		for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			Map fileMap = new HashMap();
			fileMap.put("file_name", fs.getFilename());
			fileMap.put("file_size", fs.getFilesize());
			fileMap.put("file_content", fs.getFileData());
			fileMap.put("info_id", infoId);
			fileMap.put("creator", user.getUserId());
			fileMap.put("create_date", new Date());
			fileMap.put("updator", user.getUserId());
			fileMap.put("modifi_date", new Date());
			fileMap.put("org_id", user.getOrgId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "P_FILE_CONTENT");
		
		}

		Map fileMap1 = new HashMap();
		fileMap1.put("infomation_id", infomation_id);
		fileMap1.put("infomation_name", infomation_name);
		fileMap1.put("release_date", release_date);
		fileMap1.put("two_type_id", cateId);
		fileMap1.put("three_type_id", threeTypeId);
		fileMap1.put("MODIFY_USER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");

		String abstr = isrvmsg.getValue("abstract") == null ? "" : isrvmsg.getValue("abstract");
		String content = isrvmsg.getValue("content") == null ? "" : isrvmsg.getValue("content");
		fileMap1.put("content", content.getBytes("GBK"));
		fileMap1.put("abstract", abstr);

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "BGP_INFOMATION_RELEASE_INFO");
		
		String title = user.getUserName() +"在后台发布中市场管理里修改了一条标题为：“"+infomation_name+"”的信息";
		String operationPlace = "市场管理";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;

	}

	// 物探公司动态添加
	public ISrvMsg addWtgs(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		String infoId = isrvmsg.getValue("fileId");
		String infomation_name = isrvmsg.getValue("infomation_name");
		String release_date = isrvmsg.getValue("release_date");
		String cateId = isrvmsg.getValue("two_type_id");
		String threeId = isrvmsg.getValue("three_type_id");
		String infomation_id = isrvmsg.getValue("infomation_id");
		String comm = isrvmsg.getValue("comm");
		Date now = new Date();
		Map map = new HashMap();

		String procId = (String) map.get("procId");
		if (infoId == null || "".equals(infoId)) {
			infoId = jdbcDao.generateUUID();
			String sqlFileIndex = "insert into p_file_index (info_id) values('" + infoId + "')";
			jdbcTemplate.execute(sqlFileIndex);
		}

		for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			// String sql =
			// "update p_file_content set bsflag = '1' where org_id ='" +
			// user.getOrgId() + "' and info_id='" + infoId + "'";
			// jdbcTemplate.execute(sql);
			Map fileMap = new HashMap();
			fileMap.put("file_name", fs.getFilename());
			fileMap.put("file_size", fs.getFilesize());
			fileMap.put("file_content", fs.getFileData());
			fileMap.put("info_id", infoId);
			fileMap.put("creator", user.getUserId());
			fileMap.put("create_date", new Date());
			fileMap.put("updator", user.getUserId());
			fileMap.put("modifi_date", new Date());
			fileMap.put("org_id", user.getOrgId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "P_FILE_CONTENT");

		}

		Map fileMap1 = new HashMap();
		fileMap1.put("infomation_id", infomation_id);
		fileMap1.put("infomation_name", infomation_name);
		fileMap1.put("release_date", release_date);
		fileMap1.put("abstract", isrvmsg.getValue("abstract"));
		fileMap1.put("two_type_id", comm);
		fileMap1.put("three_type_id", threeId);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFY_USER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");

		String content = isrvmsg.getValue("content") == null ? "" : isrvmsg.getValue("content");
		fileMap1.put("content", content.getBytes("GBK"));
		fileMap1.put("file_id", infoId);

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "BGP_INFOMATION_RELEASE_INFO");
		
		String title = user.getUserName() +"在后台发布中物探公司动态里添加了一条标题为：“"+infomation_name+"”的信息";
		String operationPlace = "物探公司动态";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;
	}

	public ISrvMsg viewWtgs(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String infomation_id = isrvmsg.getValue("infomation_id");

		String sql = "select * from bgp_infomation_release_info r where infomation_id='" + infomation_id + "'";
		String sql2 = "select p.file_id,p.file_name from bgp_infomation_release_info r,p_file_content p where r.file_id=p.info_id and p.bsflag='0' and r.infomation_id='"
				+ infomation_id + "'";
		String sql3 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.two_type_id=t.code and r.infomation_id='"
				+ infomation_id + "'";
		String sql4 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.three_type_id=t.code and r.infomation_id='"
			+ infomation_id + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);
		Map mapType2 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql4);

		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content = new String((byte[]) map.get("content"), "GBK");
			responseDTO.setValue("content", content);
		} else {
			String content = "";
			responseDTO.setValue("content", content);
		}

		responseDTO.setValue("marketMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("mapType", mapType);
		responseDTO.setValue("mapType2", mapType2);
		return responseDTO;
	}

	public ISrvMsg editWtgs(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String infomation_id = isrvmsg.getValue("infomation_id");

		String sql = "select * from bgp_infomation_release_info r where infomation_id='" + infomation_id + "'";
		String sql2 = "select p.file_id,p.file_name from bgp_infomation_release_info r,p_file_content p where r.file_id=p.info_id and p.bsflag='0' and r.infomation_id='"
				+ infomation_id + "'";
		String sql3 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.two_type_id=t.code and r.infomation_id='"
				+ infomation_id + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);

		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content = new String((byte[]) map.get("content"), "GBK");
			responseDTO.setValue("content", content);
		} else {
			String content = "";
			responseDTO.setValue("content", content);
		}

		responseDTO.setValue("marketMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("mapType", mapType);
		return responseDTO;
	}

	public ISrvMsg updateWtgs(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		String infomation_name = isrvmsg.getValue("infomation_name");
		String release_date = isrvmsg.getValue("release_date");
		String cateId = isrvmsg.getValue("two_type_id");
		String threeId = isrvmsg.getValue("three_type_id");
		String infomation_id = isrvmsg.getValue("infomation_id");
		List<WSFile> fileList = mqMsg.getFiles();
		String infoId = isrvmsg.getValue("infoId");
		String comm = isrvmsg.getValue("comm");
		Date now = new Date();
		Map map = new HashMap();
		
		//删除附件
		String deletedFiles = isrvmsg.getValue("deletedFiles");
		if(deletedFiles!=null&&!"".equals(deletedFiles)){
			String del[] = deletedFiles.split(",");
			int len = del.length;
			for(int i=0;i<len ;i++){
				String delSql = "update p_file_content set bsflag = '1' where file_id='"+del[i]+"'";
				jdbcTemplate.execute(delSql);
			}
		}

		if (infoId == null || "".equals(infoId)) {
			infoId = jdbcDao.generateUUID();
			String sqlFileIndex = "insert into p_file_index (info_id) values('" + infoId + "')";
			jdbcTemplate.execute(sqlFileIndex);
		}

		for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			Map fileMap = new HashMap();
			fileMap.put("file_name", fs.getFilename());
			fileMap.put("file_size", fs.getFilesize());
			fileMap.put("file_content", fs.getFileData());
			fileMap.put("info_id", infoId);
			fileMap.put("creator", user.getUserId());
			fileMap.put("create_date", new Date());
			fileMap.put("updator", user.getUserId());
			fileMap.put("modifi_date", new Date());
			fileMap.put("org_id", user.getOrgId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "P_FILE_CONTENT");
		
		}
		Map fileMap1 = new HashMap();
		fileMap1.put("infomation_id", infomation_id);
		fileMap1.put("infomation_name", infomation_name);
		fileMap1.put("release_date", release_date);
		fileMap1.put("two_type_id", comm);
		fileMap1.put("three_type_id", threeId);
		fileMap1.put("MODIFY_USER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");

		String abstr = isrvmsg.getValue("abstract") == null ? "" : isrvmsg.getValue("abstract");
		String content = isrvmsg.getValue("content") == null ? "" : isrvmsg.getValue("content");
		fileMap1.put("content", content.getBytes("GBK"));
		fileMap1.put("abstract", abstr);

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "BGP_INFOMATION_RELEASE_INFO");
		
		String title = user.getUserName() +"在后台发布中物探公司动态里修改了一条标题为：“"+infomation_name+"”的信息";
		String operationPlace = "物探公司动态";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;

	}

	// 油田公司动态添加
	public ISrvMsg addYtgs(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		String infoId = isrvmsg.getValue("fileId");
		String infomation_name = isrvmsg.getValue("infomation_name");
		String release_date = isrvmsg.getValue("release_date");
		String cateId = isrvmsg.getValue("two_type_id");
		String threeId = isrvmsg.getValue("three_type_id");
		String infomation_id = isrvmsg.getValue("infomation_id");
		String comm = isrvmsg.getValue("comm");
		Date now = new Date();
		Map map = new HashMap();

		String procId = (String) map.get("procId");
		if (infoId == null || "".equals(infoId)) {
			infoId = jdbcDao.generateUUID();
			String sqlFileIndex = "insert into p_file_index (info_id) values('" + infoId + "')";
			jdbcTemplate.execute(sqlFileIndex);
		}

		for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			// String sql =
			// "update p_file_content set bsflag = '1' where org_id ='" +
			// user.getOrgId() + "' and info_id='" + infoId + "'";
			// jdbcTemplate.execute(sql);
			Map fileMap = new HashMap();
			fileMap.put("file_name", fs.getFilename());
			fileMap.put("file_size", fs.getFilesize());
			fileMap.put("file_content", fs.getFileData());
			fileMap.put("info_id", infoId);
			fileMap.put("creator", user.getUserId());
			fileMap.put("create_date", new Date());
			fileMap.put("updator", user.getUserId());
			fileMap.put("modifi_date", new Date());
			fileMap.put("org_id", user.getOrgId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "P_FILE_CONTENT");

		}

		Map fileMap1 = new HashMap();
		fileMap1.put("infomation_id", infomation_id);
		fileMap1.put("infomation_name", infomation_name);
		fileMap1.put("release_date", release_date);
		fileMap1.put("abstract", isrvmsg.getValue("abstract"));
		fileMap1.put("two_type_id", comm);
		fileMap1.put("three_type_id", threeId);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFY_USER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");

		String content = isrvmsg.getValue("content") == null ? "" : isrvmsg.getValue("content");
		fileMap1.put("content", content.getBytes("GBK"));
		fileMap1.put("file_id", infoId);

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "BGP_INFOMATION_RELEASE_INFO");
		
		String title = user.getUserName() +"在后台发布中油公司动态里添加了一条标题为：“"+infomation_name+"”的信息";
		String operationPlace = "油公司动态";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;
	}

	public ISrvMsg viewYtgs(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String infomation_id = isrvmsg.getValue("infomation_id");

		String sql = "select * from bgp_infomation_release_info r where infomation_id='" + infomation_id + "'";
		String sql2 = "select p.file_id,p.file_name from bgp_infomation_release_info r,p_file_content p where r.file_id=p.info_id and p.bsflag='0' and r.infomation_id='"
				+ infomation_id + "'";
		String sql3 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.two_type_id=t.code and r.infomation_id='"
				+ infomation_id + "'";
		String sql4 = "select t.code_name,t.code,r.three_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.three_type_id=t.code and r.infomation_id='"
			+ infomation_id + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);
		Map mapType2 = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql4);

		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content = new String((byte[]) map.get("content"), "GBK");
			responseDTO.setValue("content", content);
		} else {
			String content = "";
			responseDTO.setValue("content", content);
		}

		responseDTO.setValue("marketMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("mapType", mapType);
		responseDTO.setValue("mapType2", mapType2);
		return responseDTO;
	}

	public ISrvMsg editYtgs(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String infomation_id = isrvmsg.getValue("infomation_id");

		String sql = "select * from bgp_infomation_release_info r where infomation_id='" + infomation_id + "'";
		String sql2 = "select p.file_id,p.file_name from bgp_infomation_release_info r,p_file_content p where r.file_id=p.info_id and p.bsflag='0' and r.infomation_id='"
				+ infomation_id + "'";
		String sql3 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.two_type_id=t.code and r.infomation_id='"
				+ infomation_id + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);

		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content = new String((byte[]) map.get("content"), "GBK");
			responseDTO.setValue("content", content);
		} else {
			String content = "";
			responseDTO.setValue("content", content);
		}

		responseDTO.setValue("marketMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("mapType", mapType);
		return responseDTO;
	}

	public ISrvMsg updateYtgs(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		String infomation_name = isrvmsg.getValue("infomation_name");
		String release_date = isrvmsg.getValue("release_date");
		String cateId = isrvmsg.getValue("two_type_id");
		String threeId = isrvmsg.getValue("three_type_id");
		String infomation_id = isrvmsg.getValue("infomation_id");
		List<WSFile> fileList = mqMsg.getFiles();
		String infoId = isrvmsg.getValue("infoId");
		String comm = isrvmsg.getValue("comm");
		Date now = new Date();
		Map map = new HashMap();
		
		
		String deletedFiles = isrvmsg.getValue("deletedFiles");
		if(deletedFiles!=null&&!"".equals(deletedFiles)){
			String del[] = deletedFiles.split(",");
			int len = del.length;
			for(int i=0;i<len ;i++){
				String delSql = "update p_file_content set bsflag = '1' where file_id='"+del[i]+"'";
				jdbcTemplate.execute(delSql);
			}
		}

		if (infoId == null || "".equals(infoId)) {
			infoId = jdbcDao.generateUUID();
			String sqlFileIndex = "insert into p_file_index (info_id) values('" + infoId + "')";
			jdbcTemplate.execute(sqlFileIndex);
		}

		for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			Map fileMap = new HashMap();
			fileMap.put("file_name", fs.getFilename());
			fileMap.put("file_size", fs.getFilesize());
			fileMap.put("file_content", fs.getFileData());
			fileMap.put("info_id", infoId);
			fileMap.put("creator", user.getUserId());
			fileMap.put("create_date", new Date());
			fileMap.put("updator", user.getUserId());
			fileMap.put("modifi_date", new Date());
			fileMap.put("org_id", user.getOrgId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "P_FILE_CONTENT");
		
		}

		Map fileMap1 = new HashMap();
		fileMap1.put("infomation_id", infomation_id);
		fileMap1.put("infomation_name", infomation_name);
		fileMap1.put("release_date", release_date);
		fileMap1.put("two_type_id", comm);
		fileMap1.put("three_type_id", threeId);
		fileMap1.put("MODIFY_USER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");

		String abstr = isrvmsg.getValue("abstract") == null ? "" : isrvmsg.getValue("abstract");
		String content = isrvmsg.getValue("content") == null ? "" : isrvmsg.getValue("content");
		fileMap1.put("content", content.getBytes("GBK"));
		fileMap1.put("abstract", abstr);

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "BGP_INFOMATION_RELEASE_INFO");
		String title = user.getUserName() +"在后台发布中油公司动态里修改了一条标题为：“"+infomation_name+"”的信息";
		String operationPlace = "油公司动态";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;

	}

	// 统计分析添加
	public ISrvMsg addTj(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		String infoId = isrvmsg.getValue("fileId");
		String infomation_name = isrvmsg.getValue("infomation_name");
		String release_date = isrvmsg.getValue("release_date");
		String cateId = isrvmsg.getValue("two_type_id");
		String three = isrvmsg.getValue("three_type_id");

		String infomation_id = isrvmsg.getValue("infomation_id");
		Date now = new Date();
		Map map = new HashMap();

		String procId = (String) map.get("procId");
		if (infoId == null || "".equals(infoId)) {
			infoId = jdbcDao.generateUUID();
			String sqlFileIndex = "insert into p_file_index (info_id) values('" + infoId + "')";
			jdbcTemplate.execute(sqlFileIndex);
		}

		for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			// String sql =
			// "update p_file_content set bsflag = '1' where org_id ='" +
			// user.getOrgId() + "' and info_id='" + infoId + "'";
			// jdbcTemplate.execute(sql);
			Map fileMap = new HashMap();
			fileMap.put("file_name", fs.getFilename());
			fileMap.put("file_size", fs.getFilesize());
			fileMap.put("file_content", fs.getFileData());
			fileMap.put("info_id", infoId);
			fileMap.put("creator", user.getUserId());
			fileMap.put("create_date", new Date());
			fileMap.put("updator", user.getUserId());
			fileMap.put("modifi_date", new Date());
			fileMap.put("org_id", user.getOrgId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "P_FILE_CONTENT");

		}

		Map fileMap1 = new HashMap();
		fileMap1.put("infomation_id", infomation_id);
		fileMap1.put("infomation_name", infomation_name);
		fileMap1.put("release_date", release_date);
		fileMap1.put("abstract", isrvmsg.getValue("abstract"));
		fileMap1.put("two_type_id", three);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFY_USER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");

		String content = isrvmsg.getValue("content") == null ? "" : isrvmsg.getValue("content");
		fileMap1.put("content", content.getBytes("GBK"));
		fileMap1.put("file_id", infoId);

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "BGP_INFOMATION_RELEASE_INFO");
		
		String title = user.getUserName() +"在后台发布中统计分析里添加了一条标题为：“"+infomation_name+"”的信息";
		String operationPlace = "统计分析";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;
	}

	public ISrvMsg viewTj(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String infomation_id = isrvmsg.getValue("infomation_id");

		String sql = "select * from bgp_infomation_release_info r where infomation_id='" + infomation_id + "'";
		String sql2 = "select p.file_id,p.file_name from bgp_infomation_release_info r,p_file_content p where r.file_id=p.info_id and p.bsflag='0' and r.infomation_id='"
				+ infomation_id + "'";
		String sql3 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.two_type_id=t.code and r.infomation_id='"
				+ infomation_id + "'";
		

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);
		
		
		String twoType = (String)map.get("twoTypeId");
		String twoTypeStr = twoType.substring(0,5);
		
		String sql4 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where t.code='"+twoTypeStr+"'";
		Map mapThreeType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql4);
		
		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content = new String((byte[]) map.get("content"), "GBK");
			responseDTO.setValue("content", content);
		} else {
			String content = "";
			responseDTO.setValue("content", content);
		}

		responseDTO.setValue("marketMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("mapType", mapType);
		responseDTO.setValue("mapThreeType", mapThreeType);
		return responseDTO;
	}

	public ISrvMsg editTj(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String infomation_id = isrvmsg.getValue("infomation_id");

		String sql = "select * from bgp_infomation_release_info r where infomation_id='" + infomation_id + "'";
		String sql2 = "select p.file_id,p.file_name from bgp_infomation_release_info r,p_file_content p where r.file_id=p.info_id and p.bsflag='0' and r.infomation_id='"
				+ infomation_id + "'";
		String sql3 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.two_type_id=t.code and r.infomation_id='"
				+ infomation_id + "'";
		

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);

		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content = new String((byte[]) map.get("content"), "GBK");
			responseDTO.setValue("content", content);
		} else {
			String content = "";
			responseDTO.setValue("content", content);
		}

		responseDTO.setValue("marketMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("mapType", mapType);
		return responseDTO;
	}

	public ISrvMsg updateTj(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		String infomation_name = isrvmsg.getValue("infomation_name");
		String release_date = isrvmsg.getValue("release_date");
		String cateId = isrvmsg.getValue("two_type_id");
		String three = isrvmsg.getValue("three_type_id");
		String infomation_id = isrvmsg.getValue("infomation_id");
		List<WSFile> fileList = mqMsg.getFiles();
		String infoId = isrvmsg.getValue("infoId");
		Date now = new Date();
		Map map = new HashMap();
		
		//删除附件
		String deletedFiles = isrvmsg.getValue("deletedFiles");
		if(deletedFiles!=null&&!"".equals(deletedFiles)){
			String del[] = deletedFiles.split(",");
			int len = del.length;
			for(int i=0;i<len ;i++){
				String delSql = "update p_file_content set bsflag = '1' where file_id='"+del[i]+"'";
				jdbcTemplate.execute(delSql);
			}
		}

		if (infoId == null || "".equals(infoId)) {
			infoId = jdbcDao.generateUUID();
			String sqlFileIndex = "insert into p_file_index (info_id) values('" + infoId + "')";
			jdbcTemplate.execute(sqlFileIndex);
		}

		for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			Map fileMap = new HashMap();
			fileMap.put("file_name", fs.getFilename());
			fileMap.put("file_size", fs.getFilesize());
			fileMap.put("file_content", fs.getFileData());
			fileMap.put("info_id", infoId);
			fileMap.put("creator", user.getUserId());
			fileMap.put("create_date", new Date());
			fileMap.put("updator", user.getUserId());
			fileMap.put("modifi_date", new Date());
			fileMap.put("org_id", user.getOrgId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "P_FILE_CONTENT");
		
		}
		Map fileMap1 = new HashMap();
		fileMap1.put("infomation_id", infomation_id);
		fileMap1.put("infomation_name", infomation_name);
		fileMap1.put("release_date", release_date);
		fileMap1.put("two_type_id", three);       //把最终类别放到two_type_id里
		fileMap1.put("MODIFY_USER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");

		String abstr = isrvmsg.getValue("abstract") == null ? "" : isrvmsg.getValue("abstract");
		String content = isrvmsg.getValue("content") == null ? "" : isrvmsg.getValue("content");
		fileMap1.put("content", content.getBytes("GBK"));
		fileMap1.put("abstract", abstr);

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "BGP_INFOMATION_RELEASE_INFO");
		
		String title = user.getUserName() +"在后台发布中统计分析里修改了一条标题为：“"+infomation_name+"”的信息";
		String operationPlace = "统计分析";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;

	}

	public ISrvMsg viewList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String typeId = isrvmsg.getValue("typeId");
		String typeName = isrvmsg.getValue("typeName");

		String currentPage = isrvmsg.getValue("currentPage");

		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		int currentPage2 = Integer.parseInt(currentPage);
		int pageSize2 = Integer.parseInt(pageSize);
		int rowStart = (currentPage2 - 1) * pageSize2;
		int rowEnd = currentPage2 * pageSize2;

		String sql = "select r.infomation_id,r.infomation_name,r.release_date from bgp_infomation_release_info r  ";
		if (typeId != null) {
			if(typeId.startsWith("10203")){
				sql += "where bsflag='0' and  r.two_type_id like '" + typeId + "%'  order by release_date desc,modify_date desc";
			}else{
				if (typeId.length() > 5) {
					sql += "where bsflag='0' and  r.three_type_id = '" + typeId + "'  order by release_date desc,modify_date desc";
				} else {
					sql += "where bsflag='0' and  r.two_type_id like '" + typeId + "%'  order by release_date desc,modify_date desc";
				}
			}	
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select * from (select datas.*,rownum rownum_ from (");
		sb.append(sql);
		sb.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());

		sb = new StringBuffer();
		sb.append("select count(1) as count from ( ");// ,
		sb.append(sql);
		sb.append(")");
		String totalRows = "0";

		Map countMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (countMap != null) {
			totalRows = (String) countMap.get("count");
			if (totalRows == null || totalRows.equals(""))
				totalRows = "0";
		}

		int total = Integer.parseInt(totalRows);
		int pageCount = total / pageSize2;
		pageCount += ((total % pageSize2) == 0 ? 0 : 1);

		responseDTO.setValue("totalRows", totalRows);
		responseDTO.setValue("pageCount", pageCount);
		responseDTO.setValue("pageSize", pageSize);
		responseDTO.setValue("currentPage", currentPage);

		responseDTO.setValue("list", list);
		responseDTO.setValue("typeName", typeName);
		responseDTO.setValue("typeId", typeId);
		
		//获取logo域 二级菜单列表
		List sckfList=mg.getTypeInfoByFather("103");
		List scglList=mg.getTypeInfoByFather("104");
		List ygsdtList=mg.getTypeInfoByFather("105");
		List jzhbdtList=mg.getTypeInfoByFather("106");
		List tjfxList=mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList",jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		return responseDTO;
	}
	
	public ISrvMsg viewListMore(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String typeId = isrvmsg.getValue("typeId");
		String typeName = isrvmsg.getValue("typeName");
		String orgId = isrvmsg.getValue("orgId");

		String currentPage = isrvmsg.getValue("currentPage");

		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		int currentPage2 = Integer.parseInt(currentPage);
		int pageSize2 = Integer.parseInt(pageSize);
		int rowStart = (currentPage2 - 1) * pageSize2;
		int rowEnd = currentPage2 * pageSize2;

		String sql = "select r.infomation_id,r.infomation_name,r.release_date from bgp_infomation_release_info r  ";
		if (typeId != null) {
			if (typeId.length() > 5) {
				sql += "where bsflag='0' and  r.three_type_id = '" + typeId + "' and r.two_type_id='"+orgId+"'  order by release_date desc,modify_date desc";
			} else {
				sql += "where bsflag='0' and  r.two_type_id like '" + typeId + "%' and r.three_type_id='"+orgId+"'  order by release_date desc,modify_date desc";
			}
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select * from (select datas.*,rownum rownum_ from (");
		sb.append(sql);
		sb.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());

		sb = new StringBuffer();
		sb.append("select count(1) as count from ( ");// ,
		sb.append(sql);
		sb.append(")");
		String totalRows = "0";

		Map countMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (countMap != null) {
			totalRows = (String) countMap.get("count");
			if (totalRows == null || totalRows.equals(""))
				totalRows = "0";
		}

		int total = Integer.parseInt(totalRows);
		int pageCount = total / pageSize2;
		pageCount += ((total % pageSize2) == 0 ? 0 : 1);

		responseDTO.setValue("totalRows", totalRows);
		responseDTO.setValue("pageCount", pageCount);
		responseDTO.setValue("pageSize", pageSize);
		responseDTO.setValue("currentPage", currentPage);

		responseDTO.setValue("list", list);
		responseDTO.setValue("typeName", typeName);
		responseDTO.setValue("typeId", typeId);
		responseDTO.setValue("orgId", orgId);
		
		//获取logo域 二级菜单列表
		List sckfList=mg.getTypeInfoByFather("103");
		List scglList=mg.getTypeInfoByFather("104");
		List ygsdtList=mg.getTypeInfoByFather("105");
		List jzhbdtList=mg.getTypeInfoByFather("106");
		List tjfxList=mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList",jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		return responseDTO;
	}

	
	public ISrvMsg viewListTree(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String typeId = isrvmsg.getValue("typeId");
		String typeName = isrvmsg.getValue("typeName");
		String twoId=isrvmsg.getValue("twoId");
		if(typeId.equals("10201")||typeId.equals("10201001")){
			typeName="市场落实价值工作量";
		}else if(typeId.equals("10202")||typeId.equals("10202001")){
			typeName="新签市场价值工作量落实情况";
		}else if(typeId.equals("10203")){
			typeName="市场周报";
		}else if(typeId.equals("10202002")){
			typeName="新签市场价值工作量与上年同比";
		}else if(typeId.equals("10202003")){
			typeName="新签市场价值工作量月度落实情况";
		}
		if(!typeId.equals("10303")){
			if(typeId.length()==5){
			typeId=typeId+"001";
			}
			if(typeId.length()==3){
			typeId=typeId+"01001";
			}
		}
		String currentPage = isrvmsg.getValue("currentPage");

		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		int currentPage2 = Integer.parseInt(currentPage);
		int pageSize2 = Integer.parseInt(pageSize);
		int rowStart = (currentPage2 - 1) * pageSize2;
		int rowEnd = currentPage2 * pageSize2;

		String sql = "select r.infomation_id,r.infomation_name,r.release_date from bgp_infomation_release_info r  ";
		if (twoId != null&&!"".equals(twoId)) {
			sql += "where bsflag='0' and  r.two_type_id = '" + twoId + "' and  r.three_type_id = '" + typeId + "'  order by release_date desc,modify_date desc";
		}else{
			sql += "where bsflag='0' and  r.two_type_id = '" + typeId + "'  order by release_date desc,modify_date desc";
		}
		StringBuffer sb = new StringBuffer();
		sb.append("select * from (select datas.*,rownum rownum_ from (");
		sb.append(sql);
		sb.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());

		sb = new StringBuffer();
		sb.append("select count(1) as count from ( ");// ,
		sb.append(sql);
		sb.append(")");
		String totalRows = "0";

		Map countMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (countMap != null) {
			totalRows = (String) countMap.get("count");
			if (totalRows == null || totalRows.equals(""))
				totalRows = "0";
		}

		int total = Integer.parseInt(totalRows);
		int pageCount = total / pageSize2;
		pageCount += ((total % pageSize2) == 0 ? 0 : 1);

		
		if(typeId.startsWith("10203")){
			if("10203001".equals(typeId)||"10203003".equals(typeId)||"10203005".equals(typeId)){
				String nextTypeId="10203001".equals(typeId)?"10203002":("10203003".equals(typeId)?"10203004":"10203006");
				String sqlNext = "select r.infomation_id,r.infomation_name,r.release_date from bgp_infomation_release_info r  ";
				sqlNext += "where bsflag='0' and  r.two_type_id = '" + nextTypeId + "'  order by release_date desc,modify_date desc";
				StringBuffer sbNext = new StringBuffer();
				sbNext.append("select * from (select datas.*,rownum rownum_ from (");
				sbNext.append(sqlNext);
				sbNext.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
				List nextList=BeanFactory.getQueryJdbcDAO().queryRecords(sbNext.toString());
				responseDTO.setValue("nextList", nextList);
				responseDTO.setValue("list", list);
			}else if("10203002".equals(typeId)||"10203004".equals(typeId)||"10203006".equals(typeId)){
				String lastTypeId="10203002".equals(typeId)?"10203001":("10203004".equals(typeId)?"10203003":"10203005");
				String sqlNext = "select r.infomation_id,r.infomation_name,r.release_date from bgp_infomation_release_info r  ";
				sqlNext += "where bsflag='0' and  r.two_type_id = '" + lastTypeId + "'  order by release_date desc,modify_date desc";
				StringBuffer sbNext = new StringBuffer();
				sbNext.append("select * from (select datas.*,rownum rownum_ from (");
				sbNext.append(sqlNext);
				sbNext.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
				List nextList=BeanFactory.getQueryJdbcDAO().queryRecords(sbNext.toString());
				responseDTO.setValue("nextList", list);
				responseDTO.setValue("list", nextList);
			}
		}else{
			responseDTO.setValue("list", list);
		}
		
		
		responseDTO.setValue("totalRows", totalRows);
		responseDTO.setValue("pageCount", pageCount);
		responseDTO.setValue("pageSize", pageSize);
		responseDTO.setValue("currentPage", currentPage);

		
		responseDTO.setValue("typeName", typeName);
		responseDTO.setValue("typeId", typeId);
		responseDTO.setValue("twoId", twoId);
		
		String pageType=isrvmsg.getValue("pageType");
		String codingType="";
		String headingInfo="";
		if("sckf".equals(pageType)){
			codingType="103";
			headingInfo="市场开发";
		}else if("scgl".equals(pageType)){
			codingType="104";
			headingInfo="市场管理";
		}else if("ygsdt".equals(pageType)){
			codingType="105";
			headingInfo="油公司动态";
		}else if("jzhbdt".equals(pageType)){
			codingType="106";
			headingInfo="物探公司动态";
		}else if("tjfx".equals(pageType)){
			codingType="10203";
			headingInfo="统计分析";
		}
		responseDTO.setValue("headingInfo", headingInfo);
		responseDTO.setValue("pageType", pageType);
		//获取二级页面右侧树列表
		List twoList=mg.getTypeInfoByFather("tjfx".equals(pageType)?"102":codingType);
		responseDTO.setValue("twoList", twoList);
		for(int i=0;twoList!=null&&i<twoList.size();i++){
			Map map=(Map) twoList.get(i);
			String code=(String) map.get("code");
			List subList=mg.getTypeInfoByFather(code);
			responseDTO.setValue("twoList"+code, subList);
		}
		//获取二级页面左侧列表页面
		List leafList=mg.getLeafTypeInfoByFather(codingType);
		responseDTO.setValue("leafList", leafList);
		for(int i=0;leafList!=null&&i<leafList.size();i++){
			Map map=(Map) leafList.get(i);
			String code=(String) map.get("code");
			String typeLevel=(String) map.get("typeLevel");
			if("3".equals(typeLevel)){
				List subList=mg.getMarketHeadingInfoByType(code.substring(0, 5), code, 3);
				responseDTO.setValue("leafList"+code, subList);
			}else{
				List subList=mg.getMarketHeadingInfoByType(code, 3);
				responseDTO.setValue("leafList"+code, subList);
			}
		}
		//获取logo域 二级菜单列表
		List sckfList=mg.getTypeInfoByFather("103");
		List scglList=mg.getTypeInfoByFather("104");
		List ygsdtList=mg.getTypeInfoByFather("105");
		List jzhbdtList=mg.getTypeInfoByFather("106");
		List tjfxList=mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList",jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		return responseDTO;
	}
	
	//市场开发的二级页面展示
	public ISrvMsg viewListTreeSckf(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String typeId = isrvmsg.getValue("typeId");
		String typeName = isrvmsg.getValue("typeName");
		if(typeId==null||"".equals(typeId)){
			typeId="10301";
			typeName="高层互访";
		}
		
		String currentPage = isrvmsg.getValue("currentPage");

		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		int currentPage2 = Integer.parseInt(currentPage);
		int pageSize2 = Integer.parseInt(pageSize);
		int rowStart = (currentPage2 - 1) * pageSize2;
		int rowEnd = currentPage2 * pageSize2;

		String sql = "select r.infomation_id,r.infomation_name,r.release_date from bgp_infomation_release_info r  ";
			sql += "where bsflag='0' and  r.two_type_id = '" + typeId + "'  order by release_date desc,modify_date desc";
		
		StringBuffer sb = new StringBuffer();
		sb.append("select * from (select datas.*,rownum rownum_ from (");
		sb.append(sql);
		sb.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());

		sb = new StringBuffer();
		sb.append("select count(1) as count from ( ");// ,
		sb.append(sql);
		sb.append(")");
		String totalRows = "0";

		Map countMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (countMap != null) {
			totalRows = (String) countMap.get("count");
			if (totalRows == null || totalRows.equals(""))
				totalRows = "0";
		}

		int total = Integer.parseInt(totalRows);
		int pageCount = total / pageSize2;
		pageCount += ((total % pageSize2) == 0 ? 0 : 1);

		
			if("10301".equals(typeId)||"10304".equals(typeId)||"10306".equals(typeId)){
				String nextTypeId="10301".equals(typeId)?"10302":("10304".equals(typeId)?"10305":"10307");
				String sqlNext = "select r.infomation_id,r.infomation_name,r.release_date from bgp_infomation_release_info r  ";
				sqlNext += "where bsflag='0' and  r.two_type_id = '" + nextTypeId + "'  order by release_date desc,modify_date desc";
				StringBuffer sbNext = new StringBuffer();
				sbNext.append("select * from (select datas.*,rownum rownum_ from (");
				sbNext.append(sqlNext);
				sbNext.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
				List nextList=BeanFactory.getQueryJdbcDAO().queryRecords(sbNext.toString());
				responseDTO.setValue("nextList", nextList);
				responseDTO.setValue("list", list);
			}else if("10302".equals(typeId)||"10305".equals(typeId)||"10307".equals(typeId)){
				String lastTypeId="10302".equals(typeId)?"10301":("10305".equals(typeId)?"10304":"10306");
				String sqlNext = "select r.infomation_id,r.infomation_name,r.release_date from bgp_infomation_release_info r  ";
				sqlNext += "where bsflag='0' and  r.two_type_id = '" + lastTypeId + "'  order by release_date desc,modify_date desc";
				StringBuffer sbNext = new StringBuffer();
				sbNext.append("select * from (select datas.*,rownum rownum_ from (");
				sbNext.append(sqlNext);
				sbNext.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
				List nextList=BeanFactory.getQueryJdbcDAO().queryRecords(sbNext.toString());
				responseDTO.setValue("nextList", list);
				responseDTO.setValue("list", nextList);
			}
			else{
			responseDTO.setValue("list", list);
		}
		
		
		responseDTO.setValue("totalRows", totalRows);
		responseDTO.setValue("pageCount", pageCount);
		responseDTO.setValue("pageSize", pageSize);
		responseDTO.setValue("currentPage", currentPage);

		
		responseDTO.setValue("typeName", typeName);
		responseDTO.setValue("typeId", typeId);
		
		
		String pageType=isrvmsg.getValue("pageType");
		String codingType="";
		String headingInfo="";
		if("sckf".equals(pageType)){
			codingType="103";
			headingInfo="市场开发";
		}else if("scgl".equals(pageType)){
			codingType="104";
			headingInfo="市场管理";
		}else if("ygsdt".equals(pageType)){
			codingType="105";
			headingInfo="油公司动态";
		}else if("jzhbdt".equals(pageType)){
			codingType="106";
			headingInfo="物探公司动态";
		}else if("tjfx".equals(pageType)){
			codingType="10203";
			headingInfo="统计分析";
		}
		responseDTO.setValue("headingInfo", headingInfo);
		responseDTO.setValue("pageType", pageType);
		//获取二级页面右侧树列表
		List twoList=mg.getTypeInfoByFather("tjfx".equals(pageType)?"102":codingType);
		responseDTO.setValue("twoList", twoList);
		for(int i=0;twoList!=null&&i<twoList.size();i++){
			Map map=(Map) twoList.get(i);
			String code=(String) map.get("code");
			List subList=mg.getTypeInfoByFather(code);
			responseDTO.setValue("twoList"+code, subList);
		}
		//获取二级页面左侧列表页面
		List leafList=mg.getLeafTypeInfoByFather(codingType);
		responseDTO.setValue("leafList", leafList);
		for(int i=0;leafList!=null&&i<leafList.size();i++){
			Map map=(Map) leafList.get(i);
			String code=(String) map.get("code");
			String typeLevel=(String) map.get("typeLevel");
			if("3".equals(typeLevel)){
				List subList=mg.getMarketHeadingInfoByType(code.substring(0, 5), code, 3);
				responseDTO.setValue("leafList"+code, subList);
			}else{
				List subList=mg.getMarketHeadingInfoByType(code, 3);
				responseDTO.setValue("leafList"+code, subList);
			}
		}
		//获取logo域 二级菜单列表
		List sckfList=mg.getTypeInfoByFather("103");
		List scglList=mg.getTypeInfoByFather("104");
		List ygsdtList=mg.getTypeInfoByFather("105");
		List jzhbdtList=mg.getTypeInfoByFather("106");
		List tjfxList=mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList",jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		return responseDTO;
	}
	
	
	
	
	//市场管理
	public ISrvMsg viewListTreeManage(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String typeId = isrvmsg.getValue("typeId");
		String typeName = isrvmsg.getValue("typeName");
		String threeTypeId = isrvmsg.getValue("threeTypeId");
		
		if(typeName==null||typeName.equals("")){
			typeName="组织机构";
		}
		
		String currentPage = isrvmsg.getValue("currentPage");

		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		int currentPage2 = Integer.parseInt(currentPage);
		int pageSize2 = Integer.parseInt(pageSize);
		int rowStart = (currentPage2 - 1) * pageSize2;
//		int rowEnd = currentPage2 * pageSize2;
		int rowEnd = 13;
		String totalRows = "0";
		int pageCount=0;
		StringBuffer sb = new StringBuffer();
		
		Map mapOrg = new HashMap();
		List listOrg = new ArrayList();
		String sqlOrg="";
		if(typeId.equals("10401")||typeId.equals("10406")){
			sqlOrg = "select * from (select t.infomation_name,t.content from bgp_infomation_release_info t where t.bsflag='0' and two_type_id='"+typeId+"' and three_type_id='"+threeTypeId+"'order  by t.modify_date desc) where rownum='1' ";
			mapOrg = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlOrg);
			String content = "";
			if(mapOrg!=null){
				if (mapOrg.get("content") != null && !"".equals(mapOrg.get("content"))) {
					content = new String((byte[]) mapOrg.get("content"), "GBK");
				} 
			}
			responseDTO.setValue("content", content);
		}else{
			if(threeTypeId.equals("10401001")&&typeId.equals("10407")){
				sqlOrg = "select * from bgp_infomation_release_info t where t.bsflag='0' and t.two_type_id='"+typeId+"' and t.three_type_id like '10401%' order by t.release_date desc,t.modify_date desc"; 
				
				sb.append("select * from (select datas.*,rownum rownum_ from (");
				sb.append(sqlOrg);
				sb.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
			}else{
			sqlOrg = "select * from bgp_infomation_release_info t where t.bsflag='0' and t.two_type_id='"+typeId+"' and t.three_type_id='"+threeTypeId+"' order by t.release_date desc,t.modify_date desc"; 
			sb.append("select * from (select datas.*,rownum rownum_ from (");
			sb.append(sqlOrg);
			sb.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
			}
			listOrg = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());

			sb = new StringBuffer();
			sb.append("select count(1) as count from ( ");// ,
			sb.append(sqlOrg);
			sb.append(")");
			
			Map countMap = jdbcDao.queryRecordBySQL(sb.toString());
			if (countMap != null) {
				totalRows = (String) countMap.get("count");
				if (totalRows == null || totalRows.equals(""))
					totalRows = "0";
			}

			int total = Integer.parseInt(totalRows);
			pageCount = total / pageSize2;
			pageCount += ((total % pageSize2) == 0 ? 0 : 1);
		}
		

		
		System.out.println("mapOrg="+mapOrg);
		System.out.println("listOrg="+listOrg);
		
		responseDTO.setValue("listOrg", listOrg);
		responseDTO.setValue("mapOrg", mapOrg);
		
		responseDTO.setValue("totalRows", totalRows);
		responseDTO.setValue("pageCount", pageCount);
		responseDTO.setValue("pageSize", pageSize);
		responseDTO.setValue("currentPage", currentPage);

		
		responseDTO.setValue("typeName", typeName);
		responseDTO.setValue("typeId", typeId);
		responseDTO.setValue("threeTypeId", threeTypeId);
		
		String pageType=isrvmsg.getValue("pageType");
		pageType = "scgl";
		String codingType="";
		String headingInfo="";
		if("sckf".equals(pageType)){
			codingType="103";
			headingInfo="市场开发";
		}else if("scgl".equals(pageType)){
			codingType="104";
			headingInfo="市场管理";
		}else if("ygsdt".equals(pageType)){
			codingType="105";
			headingInfo="油公司动态";
		}else if("jzhbdt".equals(pageType)){
			codingType="106";
			headingInfo="物探公司动态";
		}else if("tjfx".equals(pageType)){
			codingType="10203";
			headingInfo="统计分析";
		}
		responseDTO.setValue("pageType", pageType);
		
		//显示页面右侧的各个二级单位
		String secondOrgSql = "select t.code,t.code_name from bgp_infomation_type_info t where t.father_code='10401'  and t.code!='10401001' order by t.code" ;
		List secondOrgList = BeanFactory.getQueryJdbcDAO().queryRecords(secondOrgSql.toString());
		responseDTO.setValue("secondOrgList", secondOrgList);
		
		//获取logo域 二级菜单列表
		List sckfList=mg.getTypeInfoByFather("103");
		List scglList=mg.getTypeInfoByFather("104");
		List ygsdtList=mg.getTypeInfoByFather("105");
		List jzhbdtList=mg.getTypeInfoByFather("106");
		List tjfxList=mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList",jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		
		return responseDTO;
	}
	
	//市场统计---历史数据
	public ISrvMsg viewListReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String typeId = isrvmsg.getValue("typeId");
		String corpId = isrvmsg.getValue("corpId");
		String typeName="历史数据";
		//右侧二级单位
		String sqlOrg = "select t.org_id,t.org_name,t.order_no,t.bgp_infomation_type_id from sm_org t where t.parent_id='300'"
							+" and t.org_id not in ('8ad878cd2e765396012eb37e23e20215','285','181','313') order by t.order_no"; 
		List listOrg = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOrg.toString());
		responseDTO.setValue("listOrg", listOrg);
		
		// 获取二级页面右侧树列表
		List twoList = mg.getTypeInfoByFather(typeId.substring(0, 3));
		responseDTO.setValue("twoList", twoList);
		for (int i = 0; twoList != null && i < twoList.size(); i++) {
			Map map = (Map) twoList.get(i);
			String code = (String) map.get("code");
			List subList = mg.getTypeInfoByFather(code);
			responseDTO.setValue("twoList" + code, subList);
		}
		
		// 获取二级页面左侧列表页面
		List leafList = mg.getLeafTypeInfoByFather(typeId);
		responseDTO.setValue("leafList", leafList);
		for (int i = 0; leafList != null && i < leafList.size(); i++) {
			Map map = (Map) leafList.get(i);
			String code = (String) map.get("code");
			List subList = mg.getMarketHeadingInfoByType(code, 3);
			responseDTO.setValue("leafList" + code, subList);
		}
		
		responseDTO.setValue("typeId", typeId);
		responseDTO.setValue("corpId", corpId);
		responseDTO.setValue("typeName", typeName);
		
		String pageType=isrvmsg.getValue("pageType");
		String codingType="";
		String headingInfo="";
		if("sckf".equals(pageType)){
			codingType="103";
			headingInfo="市场开发";
		}else if("scgl".equals(pageType)){
			codingType="104";
			headingInfo="市场管理";
		}else if("ygsdt".equals(pageType)){
			codingType="105";
			headingInfo="油公司动态";
		}else if("jzhbdt".equals(pageType)){
			codingType="106";
			headingInfo="物探公司动态";
		}else if("tjfx".equals(pageType)){
			codingType="10203";
			headingInfo="统计分析";
		}
		responseDTO.setValue("pageType", pageType);
		responseDTO.setValue("headingInfo", headingInfo);
		
		//获取logo域 二级菜单列表
		List sckfList=mg.getTypeInfoByFather("103");
		List scglList=mg.getTypeInfoByFather("104");
		List ygsdtList=mg.getTypeInfoByFather("105");
		List jzhbdtList=mg.getTypeInfoByFather("106");
		List tjfxList=mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList",jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		
		return responseDTO;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public ISrvMsg viewDetail(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String infomation_id = isrvmsg.getValue("id");
		String typeName = isrvmsg.getValue("typeName");

		String sql = "select * from bgp_infomation_release_info r where infomation_id='" + infomation_id + "'";
		String sql2 = "select p.file_id,p.file_name from bgp_infomation_release_info r,p_file_content p where r.file_id=p.info_id and p.bsflag='0' and r.infomation_id='"
				+ infomation_id + "'";
		String sql3 = "select t.code_name,t.code,r.two_type_id from bgp_infomation_release_info r , bgp_infomation_type_info t where r.two_type_id=t.code and r.infomation_id='"
				+ infomation_id + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);

		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content = new String((byte[]) map.get("content"), "GBK");
			responseDTO.setValue("content", content);
		} else {
			String content = "";
			responseDTO.setValue("content", content);
		}
		
		String times = "" ;
		if(map.get("times")==null || "".equals(map.get("times"))){
			times = "0";
		}else{
			times = (String)map.get("times");
		}

		int nowTimes = Integer.parseInt(times)+1;
		
		Map map1 = new HashMap();
		map1.put("INFOMATION_ID", infomation_id);
		map1.put("TIMES", nowTimes);
		pureJdbcDao.saveOrUpdateEntity(map1, "BGP_INFOMATION_RELEASE_INFO");
		 
		responseDTO.setValue("times", nowTimes);
		responseDTO.setValue("marketMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("mapType", mapType);
		responseDTO.setValue("typeName", typeName);
		
		//获取logo域 二级菜单列表
		List sckfList=mg.getTypeInfoByFather("103");
		List scglList=mg.getTypeInfoByFather("104");
		List ygsdtList=mg.getTypeInfoByFather("105");
		List jzhbdtList=mg.getTypeInfoByFather("106");
		List tjfxList=mg.getTypeInfoByFather("102");
		responseDTO.setValue("sckfList", sckfList);
		responseDTO.setValue("scglList", scglList);
		responseDTO.setValue("ygsdtList", ygsdtList);
		responseDTO.setValue("jzhbdtList",jzhbdtList);
		responseDTO.setValue("tjfxList", tjfxList);
		
		return responseDTO;
	}
	
	//crm
	public ISrvMsg viewPerson(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String personId = isrvmsg.getValue("person_id");

		String sql = "select * from ci_person t where t.person_id='" + personId + "'";
		String sql2 = "select cd.code_detail_id as code, cd.code_detail_name as name from comm_code_detail cd "
						+" where cd.code_id = '001' order by code";
		String sql3 = "select cd.code_detail_id as code, cd.code_detail_name as name from comm_code_detail cd "
			+" where cd.code_id = '002' order by code";
								
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);

		SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd");
		responseDTO.setValue("map", map);
		responseDTO.setValue("nationalityList", list2);
		responseDTO.setValue("politicalStatusList", list3);
		
		return responseDTO;
	}
	//市场人员添加（crm）
	public ISrvMsg addPerson(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		
		String corpId = isrvmsg.getValue("corpId");
		String deptId = isrvmsg.getValue("deptId");
		String name = isrvmsg.getValue("name");
		String sex = isrvmsg.getValue("sex");
		String birthday = isrvmsg.getValue("birthday");
		String nationality = isrvmsg.getValue("nationality");
		String politicalStatus = isrvmsg.getValue("politicalStatus");
		String duty = isrvmsg.getValue("duty");
		String mobilePhone = isrvmsg.getValue("mobilePhone");
		String officePhone = isrvmsg.getValue("officePhone");
		String homePhone = isrvmsg.getValue("homePhone");
		String fax = isrvmsg.getValue("fax");
		String email = isrvmsg.getValue("email");
		String inChargeOf = isrvmsg.getValue("inChargeOf");
		String majorSubject = isrvmsg.getValue("majorSubject");
		String educationLevel = isrvmsg.getValue("educationLevel");
		String birthPlace = isrvmsg.getValue("birthPlace");
		String hobby = isrvmsg.getValue("hobby");
		String homeAddress = isrvmsg.getValue("homeAddress");
		String workPlace = isrvmsg.getValue("workPlace");
		String relationship = isrvmsg.getValue("relationship");
		String graduateFrom = isrvmsg.getValue("graduateFrom");
		String graduateDate = isrvmsg.getValue("graduateDate");
		String goodAt = isrvmsg.getValue("goodAt");
		String studyExperience = isrvmsg.getValue("studyExperience");
		String homeMemo = isrvmsg.getValue("homeMemo");
		String memo = isrvmsg.getValue("memo");
		String orderNo1 = "999";
		
		String sql ="select max(to_number(order_no)) as order_no from ci_person c where bsflag='0' and corp_id="+corpId+" and dept_id='"+deptId+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map==null&&"".equals(map)){
			
		}else{
			if(map.get("orderNo")==null||map.get("orderNo").equals("")){
				orderNo1 = "1";
			}else{
			String orderNo = (String)map.get("orderNo");
				int order_no = Integer.parseInt(orderNo)+1;
				orderNo1 = String.valueOf(order_no);
			}
		}
		Date now = new Date();
		
		Map fileMap1 = new HashMap();
		fileMap1.put("CORP_ID", corpId);
		fileMap1.put("DEPT_ID", deptId);
		fileMap1.put("NAME", name);
		fileMap1.put("SEX", sex);
		fileMap1.put("BIRTHDAY", birthday);
		fileMap1.put("NATIONALITY", nationality);
		fileMap1.put("POLITICAL_STATUS", politicalStatus);
		fileMap1.put("DUTY", duty);
		fileMap1.put("FAX", fax);
		fileMap1.put("BIRTH_PLACE", birthPlace);
		fileMap1.put("MOBILE_PHONE", mobilePhone);
		fileMap1.put("OFFICE_PHONE", officePhone);
		fileMap1.put("HOME_PHONE", homePhone);
		fileMap1.put("EMAIL", email);
		fileMap1.put("WORK_PLACE", workPlace);
		fileMap1.put("GRADUATE_FROM", graduateFrom);
		fileMap1.put("GRADUATE_DATE", graduateDate);
		fileMap1.put("HOME_ADDRESS", homeAddress);
		fileMap1.put("EDUCATION_LEVEL", educationLevel);
		fileMap1.put("STUDY_EXPERIENCE", studyExperience);
		fileMap1.put("IN_CHARGE_OF", inChargeOf);
		fileMap1.put("HOME_MEMO", homeMemo);
		fileMap1.put("HOBBY", hobby);
		fileMap1.put("GOOD_AT", goodAt);
		fileMap1.put("MEMO", memo);
		fileMap1.put("MAJOR_SUBJECT", majorSubject);
		fileMap1.put("RELATIONSHIP", relationship);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("ORDER_NO", orderNo1);
		fileMap1.put("BSFLAG", "0");
		
		responseDTO.setValue("id", deptId);
		responseDTO.setValue("corpId", corpId);
		pureJdbcDao.saveOrUpdateEntity(fileMap1, "CI_PERSON");
		
		String title = user.getUserName()+"在油公司人员维护中添加了一个姓名为：“"+name+"”的人员";
		String operationPlace = "油公司人员维护";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;
	}
	
	
	public ISrvMsg personOrder(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String personId = isrvmsg.getValue("person_id");
		
		String sql = "select * from ci_person ci where ci.person_id='" + personId + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("personId", personId);
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	public ISrvMsg personOrderSave(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
	
		String personId = isrvmsg.getValue("personId");
		String deptId = isrvmsg.getValue("deptId");
		String corpId = isrvmsg.getValue("corpId");
		String newOrderNo = isrvmsg.getValue("newOrderNo");
		String orderNo = isrvmsg.getValue("orderNo");
		int newNo = Integer.parseInt(newOrderNo);
		int no = Integer.parseInt(orderNo);
		
		Date now = new Date();
		
		Map fileMap1 = new HashMap();
		fileMap1.put("PERSON_ID",personId) ;
		fileMap1.put("ORDER_NO",newOrderNo) ;
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");	

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "CI_PERSON");
		
		if(newNo<no){
			String sql = "select * from CI_PERSON where bsflag='0' and corp_id = '"+corpId+"' and dept_id = '"+deptId+"' and to_number(order_no) > '"+(newNo-1)+"' and to_number(order_no) < '"+no+"' order by to_number(order_no)";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			System.out.println("list:"+list);
			for(int i=0; i<list.size();i++){
				Map map = (Map)list.get(i);
				if(!map.get("personId").toString().equals(personId)){
					Map fileMap = new HashMap();
					String order = String.valueOf(Integer.parseInt((String)map.get("orderNo"))+1);
					fileMap.put("PERSON_ID",map.get("personId").toString()) ;
					fileMap.put("ORDER_NO",order) ;
					pureJdbcDao.saveOrUpdateEntity(fileMap, "CI_PERSON");
				}
			}
		}
		if(newNo>no){
			String sql = "select * from CI_PERSON  where bsflag='0' and corp_id = '"+corpId+"' and dept_id = '"+deptId+"' and to_number(order_no) > '"+no+"' and to_number(order_no) < '"+(newNo+1)+"' order by order_no";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			System.out.println("list:"+list);
			for(int i=0; i<list.size();i++){
				Map map = (Map)list.get(i);
				if(!map.get("personId").toString().equals(personId)){
					Map fileMap = new HashMap();
					String order = String.valueOf(Integer.parseInt((String)map.get("orderNo"))-1);
					fileMap.put("PERSON_ID",map.get("personId").toString()) ;
					fileMap.put("ORDER_NO",order) ;
					pureJdbcDao.saveOrUpdateEntity(fileMap, "CI_PERSON");
				}
			}
		}
		
		return responseDTO;
	}
	//物探人员位置调整
	public ISrvMsg wtPersonOrderSave(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
	
		String personId = isrvmsg.getValue("personId");
		String corpId = isrvmsg.getValue("corpId");
		String newOrderNo = isrvmsg.getValue("newOrderNo");
		String orderNo = isrvmsg.getValue("orderNo");
		int newNo = Integer.parseInt(newOrderNo);
		int no = Integer.parseInt(orderNo);
		
		Date now = new Date();
		
		Map fileMap1 = new HashMap();
		fileMap1.put("PERSON_ID",personId) ;
		fileMap1.put("ORDER_NO",newOrderNo) ;
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");	

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "CI_PERSON");
		
		if(newNo<no){
			String sql = "select * from CI_PERSON where bsflag='0' and corp_id = '"+corpId+"'  and to_number(order_no) > '"+(newNo-1)+"' and to_number(order_no) < '"+no+"' order by to_number(order_no)";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			for(int i=0; i<list.size();i++){
				Map map = (Map)list.get(i);
				if(!map.get("personId").toString().equals(personId)){
					Map fileMap = new HashMap();
					String order = String.valueOf(Integer.parseInt((String)map.get("orderNo"))+1);
					fileMap.put("PERSON_ID",map.get("personId").toString()) ;
					fileMap.put("ORDER_NO",order) ;
					pureJdbcDao.saveOrUpdateEntity(fileMap, "CI_PERSON");
				}
			}
		}
		if(newNo>no){
			String sql = "select * from CI_PERSON where bsflag='0' and corp_id = '"+corpId+"' and to_number(order_no) > '"+no+"' and to_number(order_no) < '"+(newNo+1)+"' order by to_number(order_no)";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			for(int i=0; i<list.size();i++){
				Map map = (Map)list.get(i);
				if(!map.get("personId").toString().equals(personId)){
					Map fileMap = new HashMap();
					String order = String.valueOf(Integer.parseInt((String)map.get("orderNo"))-1);
					fileMap.put("PERSON_ID",map.get("personId").toString()) ;
					fileMap.put("ORDER_NO",order) ;
					pureJdbcDao.saveOrUpdateEntity(fileMap, "CI_PERSON");
				}
			}
		}
		
		return responseDTO;
	}
	//部门位置调整
	public ISrvMsg deptOrder(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String deptId = isrvmsg.getValue("dept_id");
		
		String sql = "select * from ci_department where dept_id='"+deptId+"'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("deptId", deptId);
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	public ISrvMsg deptOrderSave(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
	
		String deptId = isrvmsg.getValue("deptId");
		String corpId = isrvmsg.getValue("corpId");
		String newOrderNo = isrvmsg.getValue("newOrderNo");
		String orderNo = isrvmsg.getValue("orderNo");
		int newNo = Integer.parseInt(newOrderNo);
		int no = Integer.parseInt(orderNo);
		
		Date now = new Date();
		
		Map fileMap1 = new HashMap();
		fileMap1.put("DEPT_ID",deptId) ;
		fileMap1.put("ORDER_NO",newOrderNo) ;
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");	

		pureJdbcDao.saveOrUpdateEntity(fileMap1, "CI_DEPARTMENT");
		
		if(newNo<no){
			String sql = "select * from ci_department where bsflag='0' and corp_id = '"+corpId+"' and to_number(order_no) > '"+(newNo-1)+"' and to_number(order_no) < '"+no+"' order by to_number(order_no)";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			for(int i=0; i<list.size();i++){
				Map map = (Map)list.get(i);
				if(!map.get("deptId").toString().equals(deptId)){
					Map fileMap = new HashMap();
					String order = String.valueOf(Integer.parseInt((String)map.get("orderNo"))+1);
					fileMap.put("DEPT_ID",map.get("deptId").toString()) ;
					fileMap.put("ORDER_NO",order) ;
					pureJdbcDao.saveOrUpdateEntity(fileMap, "CI_DEPARTMENT");
				}
			}
		}
		if(newNo>no){
			String sql = "select * from ci_department where bsflag='0' and corp_id = '"+corpId+"' and to_number(order_no) > '"+no+"' and to_number(order_no) < '"+(newNo+1)+"' order by to_number(order_no)";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
			for(int i=0; i<list.size();i++){
				Map map = (Map)list.get(i);
				if(!map.get("deptId").toString().equals(deptId)){
					Map fileMap = new HashMap();
					String order = String.valueOf(Integer.parseInt((String)map.get("orderNo"))-1);
					fileMap.put("DEPT_ID",map.get("deptId").toString()) ;
					fileMap.put("ORDER_NO",order) ;
					pureJdbcDao.saveOrUpdateEntity(fileMap, "CI_DEPARTMENT");
				}
			}
		}
		
		return responseDTO;
	}
	
	public ISrvMsg editPerson(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String personId = isrvmsg.getValue("person_id");
		
		String sql = "select * from ci_person ci where ci.person_id='" + personId + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("personId", personId);
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	public ISrvMsg updatePerson(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		String personId = isrvmsg.getValue("personId");
		String corpId = isrvmsg.getValue("corpId");
		String deptId = isrvmsg.getValue("deptId");
		String name = isrvmsg.getValue("name") ==null ? "" :isrvmsg.getValue("name");
		String sex = isrvmsg.getValue("sex") ==null ? "" :isrvmsg.getValue("sex");
		String birthday = isrvmsg.getValue("birthday") ==null ? "" :isrvmsg.getValue("birthday");
		String nationality = isrvmsg.getValue("nationality") ==null ? "" :isrvmsg.getValue("nationality");
		String politicalStatus = isrvmsg.getValue("politicalStatus") ==null ? "" :isrvmsg.getValue("politicalStatus");
		String duty = isrvmsg.getValue("duty") ==null ? "" :isrvmsg.getValue("duty");
		String mobilePhone = isrvmsg.getValue("mobilePhone") ==null ? "" :isrvmsg.getValue("mobilePhone");
		String officePhone = isrvmsg.getValue("officePhone") ==null ? "" :isrvmsg.getValue("officePhone");
		String homePhone = isrvmsg.getValue("homePhone") ==null ? "" :isrvmsg.getValue("homePhone");
		String fax = isrvmsg.getValue("fax") ==null ? "" :isrvmsg.getValue("fax");
		String email = isrvmsg.getValue("email") ==null ? "" :isrvmsg.getValue("email");
		String inChargeOf = isrvmsg.getValue("inChargeOf") ==null ? "" :isrvmsg.getValue("inChargeOf");
		String majorSubject = isrvmsg.getValue("majorSubject") ==null ? "" :isrvmsg.getValue("majorSubject");
		String educationLevel = isrvmsg.getValue("educationLevel") ==null ? "" :isrvmsg.getValue("educationLevel");
		String birthPlace = isrvmsg.getValue("birthPlace") ==null ? "" :isrvmsg.getValue("birthPlace");
		String hobby = isrvmsg.getValue("hobby") ==null ? "" :isrvmsg.getValue("hobby");
		String homeAddress = isrvmsg.getValue("homeAddress") ==null ? "" :isrvmsg.getValue("homeAddress");
		String workPlace = isrvmsg.getValue("workPlace") ==null ? "" :isrvmsg.getValue("workPlace");
		String relationship = isrvmsg.getValue("relationship") ==null ? "" :isrvmsg.getValue("relationship");
		String graduateFrom = isrvmsg.getValue("graduateFrom") ==null ? "" :isrvmsg.getValue("graduateFrom");
		String graduateDate = isrvmsg.getValue("graduateDate") ==null ? "" :isrvmsg.getValue("graduateDate");
		String goodAt = isrvmsg.getValue("goodAt") ==null ? "" :isrvmsg.getValue("goodAt");
		String studyExperience = isrvmsg.getValue("studyExperience") ==null ? "" :isrvmsg.getValue("studyExperience");
		String homeMemo = isrvmsg.getValue("homeMemo") ==null ? "" :isrvmsg.getValue("homeMemo");
		String memo = isrvmsg.getValue("memo") ==null ? "" :isrvmsg.getValue("memo");
		
		
		Date now = new Date();
		
		Map fileMap1 = new HashMap();
		fileMap1.put("PERSON_ID",personId) ;
		fileMap1.put("CORP_ID", corpId);
		fileMap1.put("DEPT_ID", deptId);
		fileMap1.put("NAME", name);
		fileMap1.put("SEX", sex);
		fileMap1.put("BIRTHDAY", birthday);
		fileMap1.put("NATIONALITY", nationality);
		fileMap1.put("POLITICAL_STATUS", politicalStatus);
		fileMap1.put("DUTY", duty);
		fileMap1.put("FAX", fax);
		fileMap1.put("BIRTH_PLACE", birthPlace);
		fileMap1.put("MOBILE_PHONE", mobilePhone);
		fileMap1.put("OFFICE_PHONE", officePhone);
		fileMap1.put("HOME_PHONE", homePhone);
		fileMap1.put("EMAIL", email);
		fileMap1.put("WORK_PLACE", workPlace);
		fileMap1.put("GRADUATE_FROM", graduateFrom);
		fileMap1.put("GRADUATE_DATE", graduateDate);
		fileMap1.put("HOME_ADDRESS", homeAddress);
		fileMap1.put("EDUCATION_LEVEL", educationLevel);
		fileMap1.put("STUDY_EXPERIENCE", studyExperience);
		fileMap1.put("IN_CHARGE_OF", inChargeOf);
		fileMap1.put("HOME_MEMO", homeMemo);
		fileMap1.put("HOBBY", hobby);
		fileMap1.put("GOOD_AT", goodAt);
		fileMap1.put("MEMO", memo);
		fileMap1.put("MAJOR_SUBJECT", majorSubject);
		fileMap1.put("RELATIONSHIP", relationship);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");
		
		responseDTO.setValue("id", deptId);
		responseDTO.setValue("corpId", corpId);
		pureJdbcDao.saveOrUpdateEntity(fileMap1, "CI_PERSON");
		
		String title = user.getUserName()+"在油公司人员维护中修改了一个姓名为：“"+name+"”的人员";
		String operationPlace = "油公司人员维护";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;
	}

	//市场物探公司人员添加（crm）
	public ISrvMsg addWuTanPerson(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String name = isrvmsg.getValue("name");
		String sex = isrvmsg.getValue("sex");
		String corpId = isrvmsg.getValue("corpId");
		String birthday = isrvmsg.getValue("birthday");
		String politicalStatus = isrvmsg.getValue("politicalStatus");
		String nationality = isrvmsg.getValue("nationality");
		String duty = isrvmsg.getValue("duty");
		String mobilePhone = isrvmsg.getValue("mobilePhone");
		String officePhone = isrvmsg.getValue("officePhone");
		String homePhone = isrvmsg.getValue("homePhone");
		String fax = isrvmsg.getValue("fax");
		String email = isrvmsg.getValue("email");
		String educationLevel = isrvmsg.getValue("educationLevel");
		String birthPlace = isrvmsg.getValue("birthPlace");
		String hobby = isrvmsg.getValue("hobby");
		String homeAddress = isrvmsg.getValue("homeAddress");
		String workPlace = isrvmsg.getValue("workPlace");
		String majorSubject = isrvmsg.getValue("majorSubject");
		String graduateFrom = isrvmsg.getValue("graduateFrom");
		String graduateDate = isrvmsg.getValue("graduateDate");
		String goodAt = isrvmsg.getValue("goodAt");
		String inChargeOf = isrvmsg.getValue("inChargeOf");
		String studyExperience = isrvmsg.getValue("studyExperience");
		String homeMemo = isrvmsg.getValue("homeMemo");
		String memo = isrvmsg.getValue("memo");
		String orderNo1 = "999";
		
		String sql ="select max(to_number(order_no)) as order_no from ci_person c where corp_id='"+corpId+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map==null&&"".equals(map)){
			
		}else{
			String orderNo = (String)map.get("orderNo");
			if(orderNo!=null&&"".equals(orderNo));
				int order_no = Integer.parseInt(orderNo)+1;
				orderNo1 = String.valueOf(order_no);
		}
		Date now = new Date();
		
		Map fileMap1 = new HashMap();
		fileMap1.put("CORP_ID", corpId);
		fileMap1.put("NAME", name);
		fileMap1.put("SEX", sex);
		fileMap1.put("BIRTHDAY", birthday);
		fileMap1.put("NATIONALITY", nationality);
		fileMap1.put("POLITICAL_STATUS", politicalStatus);
		fileMap1.put("DUTY", duty);
		fileMap1.put("FAX", fax);
		fileMap1.put("BIRTH_PLACE", birthPlace);
		fileMap1.put("MOBILE_PHONE", mobilePhone);
		fileMap1.put("OFFICE_PHONE", officePhone);
		fileMap1.put("HOME_PHONE", homePhone);
		fileMap1.put("EMAIL", email);
		fileMap1.put("WORK_PLACE", workPlace);
		fileMap1.put("GRADUATE_FROM", graduateFrom);
		fileMap1.put("GRADUATE_DATE", graduateDate);
		fileMap1.put("HOME_ADDRESS", homeAddress);
		fileMap1.put("EDUCATION_LEVEL", educationLevel);
		fileMap1.put("STUDY_EXPERIENCE", studyExperience);
		fileMap1.put("IN_CHARGE_OF", inChargeOf);
		fileMap1.put("HOME_MEMO", homeMemo);
		fileMap1.put("HOBBY", hobby);
		fileMap1.put("GOOD_AT", goodAt);
		fileMap1.put("MEMO", memo);
		fileMap1.put("MAJOR_SUBJECT", majorSubject);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("ORDER_NO", orderNo1);
		fileMap1.put("BSFLAG", "0");
		
		responseDTO.setValue("corpId", corpId);
		pureJdbcDao.saveOrUpdateEntity(fileMap1, "CI_PERSON");
		
		String title = user.getUserName()+"在物探公司人员维护中添加了一个姓名为：“"+name+"”的人员";
		String operationPlace = "物探公司人员维护";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;
	}
	public ISrvMsg editWuTanPerson(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String button = isrvmsg.getValue("button");
		String personId = isrvmsg.getValue("personId");
		
		String sql = "select * from ci_person ci where ci.person_id='" + personId + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("personId", personId);
		responseDTO.setValue("button", button);
		responseDTO.setValue("map", map);
		return responseDTO;
	}
	
	//市场物探公司人员添加（crm）
	public ISrvMsg updateWuTanPerson(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String personId = isrvmsg.getValue("personId");
		String name = isrvmsg.getValue("name");
		String sex = isrvmsg.getValue("sex");
		String corpId = isrvmsg.getValue("corpId");
		String birthday = isrvmsg.getValue("birthday");
		String politicalStatus = isrvmsg.getValue("politicalStatus");
		String nationality = isrvmsg.getValue("nationality");
		String duty = isrvmsg.getValue("duty");
		String mobilePhone = isrvmsg.getValue("mobilePhone");
		String officePhone = isrvmsg.getValue("officePhone");
		String homePhone = isrvmsg.getValue("homePhone");
		String fax = isrvmsg.getValue("fax");
		String email = isrvmsg.getValue("email");
		String educationLevel = isrvmsg.getValue("educationLevel");
		String birthPlace = isrvmsg.getValue("birthPlace");
		String hobby = isrvmsg.getValue("hobby");
		String homeAddress = isrvmsg.getValue("homeAddress");
		String workPlace = isrvmsg.getValue("workPlace");
		String majorSubject = isrvmsg.getValue("majorSubject");
		String graduateFrom = isrvmsg.getValue("graduateFrom");
		String graduateDate = isrvmsg.getValue("graduateDate");
		String goodAt = isrvmsg.getValue("goodAt");
		String inChargeOf = isrvmsg.getValue("inChargeOf");
		String studyExperience = isrvmsg.getValue("studyExperience");
		String homeMemo = isrvmsg.getValue("homeMemo");
		String memo = isrvmsg.getValue("memo");
		String orderNo1 = "999";
		
		String sql ="select max(to_number(order_no)) as order_no from ci_person c where corp_id='"+corpId+"'";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map==null&&"".equals(map)){
			
		}else{
			String orderNo = (String)map.get("orderNo");
			if(orderNo!=null&&"".equals(orderNo));
				int order_no = Integer.parseInt(orderNo)+1;
				orderNo1 = String.valueOf(order_no);
		}
		Date now = new Date();
		
		Map fileMap1 = new HashMap();
		fileMap1.put("PERSON_ID", personId);
		fileMap1.put("CORP_ID", corpId);
		fileMap1.put("NAME", name);
		fileMap1.put("SEX", sex);
		fileMap1.put("BIRTHDAY", birthday);
		fileMap1.put("NATIONALITY", nationality);
		fileMap1.put("POLITICAL_STATUS", politicalStatus);
		fileMap1.put("DUTY", duty);
		fileMap1.put("FAX", fax);
		fileMap1.put("BIRTH_PLACE", birthPlace);
		fileMap1.put("MOBILE_PHONE", mobilePhone);
		fileMap1.put("OFFICE_PHONE", officePhone);
		fileMap1.put("HOME_PHONE", homePhone);
		fileMap1.put("EMAIL", email);
		fileMap1.put("WORK_PLACE", workPlace);
		fileMap1.put("GRADUATE_FROM", graduateFrom);
		fileMap1.put("GRADUATE_DATE", graduateDate);
		fileMap1.put("HOME_ADDRESS", homeAddress);
		fileMap1.put("EDUCATION_LEVEL", educationLevel);
		fileMap1.put("STUDY_EXPERIENCE", studyExperience);
		fileMap1.put("IN_CHARGE_OF", inChargeOf);
		fileMap1.put("HOME_MEMO", homeMemo);
		fileMap1.put("HOBBY", hobby);
		fileMap1.put("GOOD_AT", goodAt);
		fileMap1.put("MEMO", memo);
		fileMap1.put("MAJOR_SUBJECT", majorSubject);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("ORDER_NO", orderNo1);
		fileMap1.put("BSFLAG", "0");
		
		responseDTO.setValue("corpId", corpId);
		
		pureJdbcDao.saveOrUpdateEntity(fileMap1, "CI_PERSON");
		
		String title = user.getUserName()+"在物探公司人员维护中添加了一个姓名为：“"+name+"”的人员";
		String operationPlace = "物探公司人员维护";
		mg.addLogInfo(title, operationPlace);

		return responseDTO;
	}
	
	// 市场历史数据（周月季报）
	public ISrvMsg startReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String corpId = user.getOrgId();
		String name = user.getOrgName();
		String userId="300";
		String orgId = isrvmsg.getValue("orgId");
		
		String sql = "select t.org_subjection_id from comm_org_subjection t where t.org_id='"+corpId+"'";
		Map map =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null&&!map.equals("")){
			String orgSubjectionId = map.get("orgSubjectionId").toString();
			if(orgSubjectionId.length()>6){
			String subId = orgSubjectionId.substring(0, 7);
			if(subId.equals("C105005")||subId.equals("C105001")||subId.equals("C105079")){
				if(orgSubjectionId.length()>9){
			   subId = orgSubjectionId.substring(0, 10);
				}
			}
//			if(subId.equals("C105079")){
//				subId="C105016";
//			}
			String orgIdSql = "select sm.* from comm_org_subjection o,sm_org sm where o.org_id=sm.bgp_org_id and o.org_subjection_id='"+subId+"'";
			Map orgMap =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(orgIdSql);
			if(orgMap!=null&&!orgMap.equals("")){
				userId = orgMap.get("orgId").toString();
			}
			}
		}
		
		if(orgId==null||orgId.equals("")){
			orgId=userId;
		}
		
		responseDTO.setValue("userId", userId);
		responseDTO.setValue("orgId", orgId);
	
		return responseDTO;
	}
	
	public ISrvMsg addReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		
		String corpId = isrvmsg.getValue("orgId");
		String title = isrvmsg.getValue("title");
		String type = isrvmsg.getValue("type");
		String recordYear = isrvmsg.getValue("recordYear");
		String month = isrvmsg.getValue("month");
		String memo = isrvmsg.getValue("memo");
		Date now = new Date();
		Map map = new HashMap();
		

		Map fileMap1 = new HashMap();
		fileMap1.put("CORP_ID", corpId);
		fileMap1.put("RECORD_YEAR", recordYear);
		fileMap1.put("MONTH", month);
		fileMap1.put("TYPE", type);
		fileMap1.put("TITLE", title);
		fileMap1.put("MEMO", memo);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");
		
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fileMap1,
		"MM_HISTORY_REPORT");
		
		
		String titleLog = user.getUserName()+"在历史数据维护中添加了一条"+recordYear+"年"+month+"的名称为：“"+title+"”的信息";
		String operationPlace = "历史数据维护";
		mg.addLogInfo(titleLog, operationPlace);

		String historyReportId = id.toString();
	
		if (historyReportId != null && !"".equals(historyReportId)) {
			for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			String attachExt = fs.getFilename().substring(fs.getFilename().lastIndexOf(".")+1, fs.getFilename().length());
			Map fileMap = new HashMap();
			fileMap.put("TABLE_NAME", "MM_HISTORY_REPORT");
			fileMap.put("RECORD_ID", historyReportId);
			fileMap.put("ATTACH_NAME", fs.getFilename());
			fileMap.put("ATTACH_CONTENT", fs.getFileData());
			fileMap.put("ATTACH_EXT", attachExt);
			fileMap.put("CREATE_DATE", new Date());
			fileMap.put("CREATOR", user.getUserId());
			fileMap.put("MODIFY_DATE", new Date());
			fileMap.put("MODIFIER", user.getUserId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "COMM_ATTACHMENT");

			}
		}
		return responseDTO;

	}

	public ISrvMsg viewReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String reportId = isrvmsg.getValue("reportId");
		String button = isrvmsg.getValue("button");
		if(button==null){
			button = "return";
		}

		String sql = "select * from mm_history_report where history_report_id='" + reportId + "'";
		String sql2 = "select attach_id,attach_name from comm_attachment where bsflag='0' and record_id='"+ reportId + "'";
		String sql3 = "select h.corp_id,s.org_name from sm_org s ,mm_history_report h where h.corp_id=s.org_id and h.history_report_id='"+ reportId + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		Map mapType = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql3);

		responseDTO.setValue("button", button);
		responseDTO.setValue("reportMap", map);
		responseDTO.setValue("fileList", list);
		responseDTO.setValue("orgMap", mapType);
		return responseDTO;
	}

	public ISrvMsg editReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String reportId = isrvmsg.getValue("reportId");
		String orgId = isrvmsg.getValue("orgId");
		
		String sql = "select * from mm_history_report where history_report_id='" + reportId + "'";
		String sql2 ="select attach_id,attach_name from comm_attachment where bsflag='0' and record_id='"+ reportId + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		
		responseDTO.setValue("orgId", orgId);
		responseDTO.setValue("reportMap", map);
		responseDTO.setValue("fileList", list);
		return responseDTO;
	}

	public ISrvMsg updateReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		
		String corpId = isrvmsg.getValue("orgId");
		String historyReportId = isrvmsg.getValue("historyReportId");
		String title = isrvmsg.getValue("title");
		String type = isrvmsg.getValue("type");
		String recordYear = isrvmsg.getValue("recordYear");
		String month = isrvmsg.getValue("month");
		String memo = isrvmsg.getValue("memo");
		//删除的附件的attachId（一个数组）
		String deletedFiles = isrvmsg.getValue("deletedFiles");
		if(deletedFiles!=null&&!"".equals(deletedFiles)){
			String del[] = deletedFiles.split(",");
			int len = del.length;
			for(int i=0;i<len ;i++){
				String delSql = "update comm_attachment set bsflag = '1' where attach_id='"+del[i]+"'";
				jdbcTemplate.execute(delSql);
			}
		}
		
		Date now = new Date();
		Map map = new HashMap();
		

		Map fileMap1 = new HashMap();
		fileMap1.put("HISTORY_REPORT_ID", historyReportId);
		fileMap1.put("RECORD_YEAR", recordYear);
		fileMap1.put("MONTH", month);
		fileMap1.put("TYPE", type);
		fileMap1.put("TITLE", title);
		fileMap1.put("MEMO", memo);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fileMap1,"MM_HISTORY_REPORT");
		
		String titleLog = user.getUserName()+"在历史数据维护中修改了一条"+recordYear+"年"+month+"的名称为：“"+title+"”的信息";
		String operationPlace = "历史数据维护";
		mg.addLogInfo(titleLog, operationPlace);

		if (historyReportId != null && !"".equals(historyReportId)) {
			for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			String attachExt = fs.getFilename().substring(fs.getFilename().lastIndexOf(".")+1, fs.getFilename().length());
			Map fileMap = new HashMap();
			fileMap.put("TABLE_NAME", "MM_HISTORY_REPORT");
			fileMap.put("RECORD_ID", historyReportId);
			fileMap.put("ATTACH_NAME", fs.getFilename());
			fileMap.put("ATTACH_CONTENT", fs.getFileData());
			fileMap.put("ATTACH_EXT", attachExt);
			fileMap.put("CREATE_DATE", new Date());
			fileMap.put("CREATOR", user.getUserId());
			fileMap.put("MODIFY_DATE", new Date());
			fileMap.put("MODIFIER", user.getUserId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "COMM_ATTACHMENT");

			}
		}
		return responseDTO;

	}

	// 市场价值量图（原CRM）
	public ISrvMsg startValueQuantity(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String corpId = user.getOrgId();
		String name = user.getOrgName();
		String userId="300";
		String orgId = isrvmsg.getValue("orgId");
		
		String sql = "select t.org_subjection_id from comm_org_subjection t where t.org_id='"+corpId+"'";
		Map map =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null&&!map.equals("")){
			String orgSubjectionId = map.get("orgSubjectionId").toString();
			if(orgSubjectionId.length()>6){
			String subId = orgSubjectionId.substring(0, 7);
			if(subId.equals("C105005")||subId.equals("C105001")||subId.equals("C105079")){
				if(orgSubjectionId.length()>9){
			   subId = orgSubjectionId.substring(0, 10);
				}
			}
//			if(subId.equals("C105079")){
//				subId="C105016";
//			}
			String orgIdSql = "select sm.* from comm_org_subjection o,sm_org sm where o.org_id=sm.bgp_org_id and o.org_subjection_id='"+subId+"'";
			Map orgMap =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(orgIdSql);
			if(orgMap!=null&&!orgMap.equals("")){
				userId = orgMap.get("orgId").toString();
			}
			}
		}
		
		if(orgId==null||orgId.equals("")){
			orgId=userId;
		}
		
		responseDTO.setValue("userId", userId);
		responseDTO.setValue("orgId", orgId);
		return responseDTO;
	}
	
	public ISrvMsg addValueQuantity(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		
		String corpId = isrvmsg.getValue("orgId");
		String recordYear = isrvmsg.getValue("recordYear");
		String recordMonth = isrvmsg.getValue("recordMonth");
		String planValue = isrvmsg.getValue("planValue");
		String implValue = isrvmsg.getValue("implValue");
		String totalValue = isrvmsg.getValue("totalValue");
		
		Date now = new Date();
		Map map = new HashMap();

		map.put("CORP_ID", corpId);
		map.put("RECORD_YEAR", recordYear);
		map.put("RECORD_MONTH", recordMonth);
		map.put("IMPL_VALUE", implValue);
		map.put("TOTAL_VALUE", totalValue);
		map.put("PLAN_VALUE", planValue);
		map.put("CREATOR", user.getUserName());
		map.put("CREATE_DATE", now);
		map.put("MODIFIER", user.getUserName());
		map.put("MODIFY_DATE", now);
		map.put("BSFLAG", "0");
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"MM_VALUE_QUANTITY");
		
		String titleLog = user.getUserName()+"在价值量图维护中添加了一条"+recordYear+"年"+recordMonth+"月的信息";
		String operationPlace = "价值量图维护";
		mg.addLogInfo(titleLog, operationPlace);

		return responseDTO;

	}

	public ISrvMsg editValueQuantity(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String valueQuantityId = isrvmsg.getValue("valueQuantityId");
		
		String sql = "select * from mm_value_quantity where value_quantity_id='" + valueQuantityId + "'";
		
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("valueMap", map);
		return responseDTO;
	}

	public ISrvMsg updateValueQuantity(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		
		String recordYear = isrvmsg.getValue("recordYear");
		String recordMonth = isrvmsg.getValue("recordMonth");
		String planValue = isrvmsg.getValue("planValue");
		String implValue = isrvmsg.getValue("implValue");
		String totalValue = isrvmsg.getValue("totalValue");
		String valueQuantityId = isrvmsg.getValue("valueQuantityId");
		
		Date now = new Date();
		Map map = new HashMap();

		map.put("VALUE_QUANTITY_ID", valueQuantityId);
		map.put("RECORD_YEAR", recordYear);
		map.put("RECORD_MONTH", recordMonth);
		map.put("IMPL_VALUE", implValue);
		map.put("TOTAL_VALUE", totalValue);
		map.put("PLAN_VALUE", planValue);
		map.put("CREATOR", user.getUserName());
		map.put("CREATE_DATE", now);
		map.put("MODIFIER", user.getUserName());
		map.put("MODIFY_DATE", now);
		map.put("BSFLAG", "0");
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"MM_VALUE_QUANTITY");
		
		String titleLog = user.getUserName()+"在价值量图维护中修改了一条"+recordYear+"年"+recordMonth+"月的信息";
		String operationPlace = "价值量图维护";
		mg.addLogInfo(titleLog, operationPlace);

		return responseDTO;
	}

	
	// 合同台账添加
	public ISrvMsg addContract(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		
		String contractNo = isrvmsg.getValue("contractNo");
		String contractName = isrvmsg.getValue("contractName");
		String undertakingOrgId = isrvmsg.getValue("undertakingOrgId");
		String partaOrg = isrvmsg.getValue("partaOrg");
		String contractType = isrvmsg.getValue("contractType");
		String contractMoney = isrvmsg.getValue("contractMoney");
		String workload = isrvmsg.getValue("workload");
		String unitPrice = isrvmsg.getValue("unitPrice");
		String signedTime = isrvmsg.getValue("signedTime");
		String marketType = isrvmsg.getValue("marketType");
		String contractStartDate = isrvmsg.getValue("contractStartDate");
		String contractEndDate = isrvmsg.getValue("contractEndDate");
		String memo = isrvmsg.getValue("memo");
		
		Date now = new Date();

		Map map = new HashMap();
		map.put("CONTRACT_NO", contractNo);
		map.put("CONTRACT_NAME", contractName);
		map.put("UNDERTAKING_ORG", undertakingOrgId);
		map.put("PARTA_ORG", partaOrg);
		map.put("CONTRACT_TYPE", contractType);
		map.put("CONTRACT_MONEY", contractMoney);
		map.put("WORKLOAD", workload);
		map.put("UNIT_PRICE", unitPrice);
		map.put("SIGNED_DATE", signedTime);
		map.put("MARKET_TYPE", marketType);
		map.put("CONTRACT_START_DATE", contractStartDate);
		map.put("CONTRACT_END_DATE", contractEndDate);
		map.put("MEMO", memo);
		
		map.put("CREATOR", user.getUserName());
		map.put("CREATE_DATE", now);
		map.put("UPDATOR", user.getUserName());
		map.put("MODIFI_DATE", now);
		map.put("BSFLAG", "0");

		

		pureJdbcDao.saveOrUpdateEntity(map, "BGP_MARKET_CONTRACT_ACCOUNT");
		
		String titleLog = user.getUserName()+"在合同台账维护中添加了一条项目名称为：“"+contractName+"”的信息";
		String operationPlace = "合同台账维护";
		mg.addLogInfo(titleLog, operationPlace);

		return responseDTO;

	}

	public ISrvMsg editContract(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String contractId = isrvmsg.getValue("contractId");

		
		String sql = "select m.*,c.org_abbreviation from bgp_market_contract_account m,comm_org_information c where m.undertaking_org=c.org_id and m.contract_id='"+ contractId + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		responseDTO.setValue("map", map);
		return responseDTO;
	}

	public ISrvMsg updateContract(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		
		String contractId = isrvmsg.getValue("contractId");
		String contractNo = isrvmsg.getValue("contractNo");
		String contractName = isrvmsg.getValue("contractName");
		String undertakingOrgId = isrvmsg.getValue("undertakingOrgId");
		String partaOrg = isrvmsg.getValue("partaOrg");
		String contractType = isrvmsg.getValue("contractType");
		String contractMoney = isrvmsg.getValue("contractMoney");
		String workload = isrvmsg.getValue("workload");
		String unitPrice = isrvmsg.getValue("unitPrice");
		String signedTime = isrvmsg.getValue("signedTime");
		String marketType = isrvmsg.getValue("marketType");
		String contractStartDate = isrvmsg.getValue("contractStartDate");
		String contractEndDate = isrvmsg.getValue("contractEndDate");
		String memo = isrvmsg.getValue("memo");
		
		Date now = new Date();

		Map map = new HashMap();
		map.put("CONTRACT_ID", contractId);
		map.put("CONTRACT_NO", contractNo);
		map.put("CONTRACT_NAME", contractName);
		map.put("UNDERTAKING_ORG", undertakingOrgId);
		map.put("PARTA_ORG", partaOrg);
		map.put("CONTRACT_TYPE", contractType);
		map.put("CONTRACT_MONEY", contractMoney);
		map.put("WORKLOAD", workload);
		map.put("UNIT_PRICE", unitPrice);
		map.put("SIGNED_DATE", signedTime);
		map.put("MARKET_TYPE", marketType);
		map.put("CONTRACT_START_DATE", contractStartDate);
		map.put("CONTRACT_END_DATE", contractEndDate);
		map.put("MEMO", memo);
		
		map.put("UPDATOR", user.getUserName());
		map.put("MODIFI_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map, "BGP_MARKET_CONTRACT_ACCOUNT");
		
		String titleLog = user.getUserName()+"在合同台账维护中修改了一条项目名称为：“"+contractName+"”的信息";
		String operationPlace = "合同台账维护";
		mg.addLogInfo(titleLog, operationPlace);

		return responseDTO;
	}
	
	//市场周报列表页面
	public ISrvMsg weekReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String userEmpId = user.getEmpId();
		String corpId = user.getOrgId();
		String name = user.getOrgName();
		String userId="C6000000000025";
		String orgId = isrvmsg.getValue("orgId");
		
		String sql = "select t.org_subjection_id from comm_org_subjection t where t.org_id='"+corpId+"'";
		Map map =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null&&!map.equals("")){
			String orgSubjectionId = map.get("orgSubjectionId").toString();
			if(orgSubjectionId.length()>6){
			String subId = orgSubjectionId.substring(0, 7);
			if(subId.equals("C105005")||subId.equals("C105001")||subId.equals("C105079")){
				if(orgSubjectionId.length()>9){
			   subId = orgSubjectionId.substring(0, 10);
				}
			}
			String orgIdSql = "select * from comm_org_subjection o where o.org_subjection_id='"+subId+"'";
			Map orgMap =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(orgIdSql);
			userId = orgMap.get("orgId").toString();
			}
		}
		
		if(orgId==null||orgId.equals("")){
			orgId=userId;
		}
		
		responseDTO.setValue("userId", userId);
		responseDTO.setValue("orgId", orgId);
		
		return responseDTO;
	}
	//东方添加周报--自动生成二级单位填写的周报
	public ISrvMsg addWeekReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		String orgId = isrvmsg.getValue("orgId");
		String action = isrvmsg.getValue("action");

		String sqlOne = "select t.typeid, t.week_date, t.week_end_date, t.content,oi.org_abbreviation,t.subflag  "
					+"from bgp_wr_martandproject_info t join comm_org_information oi on oi.org_id = t.org_id "
					+"where t.org_id in ('C6000000000003', 'C6000000000004', 'C6000000000010','C6000000000011', 'C6000000000013', 'C6000000000012',"
					+" 'C6000000000045', 'C6000000000008', 'C6000000001888','C0000000000232', 'C6000000000060', 'C6000000000009','C6000000000015','C6000000000017','C6000000006451') and t.bsflag='0' and t.subflag='1' "
					+"and t.type='1' and t.typeid = '1' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlTwo = "select t.typeid, t.week_date, t.week_end_date, t.content,oi.org_abbreviation,t.subflag "
					+"from bgp_wr_martandproject_info t join comm_org_information oi on oi.org_id = t.org_id "
					+"where t.org_id in ('C6000000000003', 'C6000000000004', 'C6000000000010','C6000000000011', 'C6000000000013', 'C6000000000012',"
					+" 'C6000000000045', 'C6000000000008', 'C6000000001888','C0000000000232', 'C6000000000060', 'C6000000000009','C6000000000015','C6000000000017','C6000000006451') and t.bsflag='0' and t.subflag='1' "
					+"and t.type='1' and t.typeid = '2' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlThree = "select t.typeid, t.week_date, t.week_end_date, t.content,oi.org_abbreviation,t.subflag "
					+"from bgp_wr_martandproject_info t join comm_org_information oi on oi.org_id = t.org_id "
					+"where t.org_id in ('C6000000000003', 'C6000000000004', 'C6000000000010','C6000000000011', 'C6000000000013', 'C6000000000012',"
					+" 'C6000000000045', 'C6000000000008', 'C6000000001888','C0000000000232', 'C6000000000060', 'C6000000000009','C6000000000015','C6000000000017','C6000000006451') and t.bsflag='0' and t.subflag='1' "
					+"and t.type='1' and t.typeid = '3' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlFour = "select t.typeid, t.week_date, t.week_end_date, t.content,oi.org_abbreviation,t.subflag "
					+"from bgp_wr_martandproject_info t join comm_org_information oi on oi.org_id = t.org_id "
					+"where t.org_id in ('C6000000000003', 'C6000000000004', 'C6000000000010','C6000000000011', 'C6000000000013', 'C6000000000012',"
					+" 'C6000000000045', 'C6000000000008', 'C6000000001888','C0000000000232', 'C6000000000060', 'C6000000000009','C6000000000015','C6000000000017','C6000000006451') and t.bsflag='0' and t.subflag='1' "
					+"and t.type='1' and t.typeid = '4' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlFive = "select t.typeid, t.week_date, t.week_end_date, t.content,oi.org_abbreviation,t.subflag "
					+"from bgp_wr_martandproject_info t join comm_org_information oi on oi.org_id = t.org_id "
					+"where t.org_id in ('C6000000000003', 'C6000000000004', 'C6000000000010','C6000000000011', 'C6000000000013', 'C6000000000012',"
					+" 'C6000000000045', 'C6000000000008', 'C6000000001888','C0000000000232', 'C6000000000060', 'C6000000000009','C6000000000015','C6000000000017','C6000000006451') and t.bsflag='0' and t.subflag='1' "
					+"and t.type='1' and t.typeid = '5' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		
		List list1 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOne);
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlTwo);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlThree);
		List list4 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlFour);
		List list5 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlFive);
		
		
		responseDTO.setValue("weekDate", weekDate);
		responseDTO.setValue("weekEndDate", weekEndDate);
		responseDTO.setValue("orgId", orgId);
		responseDTO.setValue("action", action);
		

		responseDTO.setValue("list1", list1);
		responseDTO.setValue("list2", list2);
		responseDTO.setValue("list3", list3);
		responseDTO.setValue("list4", list4);
		responseDTO.setValue("list5", list5);
		return responseDTO;
	}
	//保存周报
	public ISrvMsg saveWeekReport(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		
		String orgId = isrvmsg.getValue("orgId");
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		String typeOne = isrvmsg.getValue("typeOne");
		String typeTwo = isrvmsg.getValue("typeTwo");
		String typeThree = isrvmsg.getValue("typeThree");
		String typeFour = isrvmsg.getValue("typeFour");
		String typeFive = isrvmsg.getValue("typeFive");
		if(typeOne!=null&&!"".endsWith(typeOne)){
			typeOne = typeOne.replace("km2","k㎡" );
		}
		if(typeTwo!=null&&!"".endsWith(typeTwo)){
			typeTwo = typeTwo.replace("km2","k㎡" );
		}
		if(typeThree!=null&&!"".endsWith(typeThree)){
			typeThree = typeThree.replace("km2","k㎡" );
		}
		if(typeFour!=null&&!"".endsWith(typeFour)){
			typeFour = typeFour.replace("km2","k㎡" );
		}
		if(typeFive!=null&&!"".endsWith(typeFive)){
			typeFive = typeFive.replace("km2","k㎡" );
		}
		String orgSubjectionId="";
		
		String sql = "select * from comm_org_subjection t where t.locked_if='0' and t.bsflag='0' and t.org_id='"+orgId+"'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		for(int i= 0;i<list.size();i++){
			Map map=(Map)list.get(i);
			orgSubjectionId=(String)map.get("orgSubjectionId") ;
		}
	
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("INSERT INTO BGP_WR_MARTANDPROJECT_INFO ");
		sb.append("(MARTANDPRO_ID,WEEK_DATE,ORG_ID,ORG_SUBJECTION_ID,TYPEID,CREATE_USER,CREATE_DATE,MONDIFY_USER,MONDIFY_DATE,BSFLAG,SUBFLAG,WEEK_END_DATE,TYPE,CONTENT)");
		sb.append("VALUES(?,to_date('").append(weekDate).append("','yyyy-MM-dd'),'").append(orgId).append("','").append(orgSubjectionId).append("',?,'").append(user.getUserName()).append("',sysdate,'").append(user.getUserName()).append("',sysdate,'0','0',to_date('").append(weekEndDate).append("','yyyy-MM-dd'),'1',?)");
		
		int[] paramTypes = new int[]{Types.VARCHAR, Types.VARCHAR, Types.VARCHAR};
		
		RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String[] types = new String[]{"",typeOne, typeTwo, typeThree, typeFour, typeFive};
		
		for(int i=1;i<=5;i++){
			Object[] params = new Object[]{radDao.generateUUID(), String.valueOf(i), types[i]};
			radDao.getJdbcTemplate().update(sb.toString(), params, paramTypes);
		}
		
		String titleLog = user.getUserName()+"在市场信息周报中添加了一条周报开始日期为：“"+weekDate+"”的信息";
		String operationPlace = "市场信息周报";
		mg.addLogInfo(titleLog, operationPlace);
		
		return responseDTO;

	}
	

	//修改周报
	public ISrvMsg editWeekReport(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String orgId = isrvmsg.getValue("orgId");
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		String action = isrvmsg.getValue("action");

		String sqlOne = "select * from bgp_wr_martandproject_info t where t.org_id='"+orgId+"' and t.bsflag='0'  "
					+"and t.type='1' and t.typeid = '1' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlTwo = "select * from bgp_wr_martandproject_info t where t.org_id='"+orgId+"' and t.bsflag='0'  "
					+"and t.type='1' and t.typeid = '2' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlThree = "select * from bgp_wr_martandproject_info t where t.org_id='"+orgId+"' and t.bsflag='0'  "
					+"and t.type='1' and t.typeid = '3' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlFour = "select * from bgp_wr_martandproject_info t where t.org_id='"+orgId+"' and t.bsflag='0'  "
					+"and t.type='1' and t.typeid = '4' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlFive = "select * from bgp_wr_martandproject_info t where t.org_id='"+orgId+"' and t.bsflag='0'  "
					+"and t.type='1' and t.typeid = '5' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		
		List list1 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOne);
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlTwo);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlThree);
		List list4 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlFour);
		List list5 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlFive);
		
		responseDTO.setValue("weekDate", weekDate);
		responseDTO.setValue("weekEndDate", weekEndDate);
		responseDTO.setValue("orgId", orgId);
		responseDTO.setValue("action", action);
		

		responseDTO.setValue("list1", list1);
		responseDTO.setValue("list2", list2);
		responseDTO.setValue("list3", list3);
		responseDTO.setValue("list4", list4);
		responseDTO.setValue("list5", list5);

		return responseDTO;

	}
	
	//保存修改周报
	public ISrvMsg updateWeekReport(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		
		String orgId = isrvmsg.getValue("orgId");
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		
		String martandId1 = isrvmsg.getValue("martandId1");
		String martandId2 = isrvmsg.getValue("martandId2");
		String martandId3 = isrvmsg.getValue("martandId3");
		String martandId4 = isrvmsg.getValue("martandId4");
		String martandId5 = isrvmsg.getValue("martandId5");
		
		String typeOne = isrvmsg.getValue("typeOne");
		String typeTwo = isrvmsg.getValue("typeTwo");
		String typeThree = isrvmsg.getValue("typeThree");
		String typeFour = isrvmsg.getValue("typeFour");
		String typeFive = isrvmsg.getValue("typeFive");
		if(typeOne!=null&&!"".endsWith(typeOne)){
			typeOne = typeOne.replace("km2","k㎡" );
		}
		if(typeTwo!=null&&!"".endsWith(typeTwo)){
			typeTwo = typeTwo.replace("km2","k㎡" );
		}
		if(typeThree!=null&&!"".endsWith(typeThree)){
			typeThree = typeThree.replace("km2","k㎡" );
		}
		if(typeFour!=null&&!"".endsWith(typeFour)){
			typeFour = typeFour.replace("km2","k㎡" );
		}
		if(typeFive!=null&&!"".endsWith(typeFive)){
			typeFive = typeFive.replace("km2","k㎡" );
		}
		String orgSubjectionId="";
		
		String sql = "select * from comm_org_subjection t where t.locked_if='0' and t.bsflag='0' and t.org_id='"+orgId+"'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		for(int i= 0;i<list.size();i++){
			Map map=(Map)list.get(i);
			orgSubjectionId=(String)map.get("orgSubjectionId") ;
		}
		
		Date now = new Date();
		
		
		String updateSql = "update bgp_wr_martandproject_info t set t.week_date= to_date('"+weekDate+"','yyyy-MM-dd'),t.org_id= '"+orgId+"',t.org_subjection_id = '"+orgSubjectionId+"',"
		+" t.typeid= ?,t.mondify_user = '"+user.getUserName()+"',t.mondify_date = sysdate, t.bsflag='0',t.subflag='0',t.week_end_date=to_date('"+weekEndDate+"','yyyy-MM-dd'),t.type='1',"
		+"t.content=? where t.bsflag='0' and t.subflag='0' and t.martandpro_id=?";
				
		int[] paramTypes = new int[]{Types.VARCHAR, Types.VARCHAR, Types.VARCHAR};
		
		RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String[] types = new String[]{"",typeOne, typeTwo, typeThree, typeFour, typeFive};
		String[] types2 = new String[]{"",martandId1,martandId2,martandId3,martandId4,martandId5};
 		
		for(int i=1;i<=5;i++){
			Object[] params = new Object[]{ String.valueOf(i),types[i], types2[i]};
			radDao.getJdbcTemplate().update(updateSql, params, paramTypes);
		}
		
		String titleLog = user.getUserName()+"在市场信息周报中修改了一条周报开始日期为：“"+weekDate+"”的信息";
		String operationPlace = "市场信息周报";
		mg.addLogInfo(titleLog, operationPlace);
		
		return responseDTO;

	}
	
	
	
	//市场月报列表页面
	public ISrvMsg monthReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String userEmpId = user.getEmpId();
		String corpId = user.getOrgId();
		String name = user.getOrgName();
		String userId="C6000000000025";
		String orgId = isrvmsg.getValue("orgId");
		
		String sql = "select t.org_subjection_id from comm_org_subjection t where t.org_id='"+corpId+"'";
		Map map =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null&&!map.equals("")){
			String orgSubjectionId = map.get("orgSubjectionId").toString();
			if(orgSubjectionId.length()>6){
			String subId = orgSubjectionId.substring(0, 7);
			if(subId.equals("C105005")||subId.equals("C105001")||subId.equals("C105079")){
				if(orgSubjectionId.length()>9){
			   subId = orgSubjectionId.substring(0, 10);
				}
			}
			String orgIdSql = "select * from comm_org_subjection o where o.org_subjection_id='"+subId+"'";
			Map orgMap =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(orgIdSql);
			userId = orgMap.get("orgId").toString();
			}
		}
		
		if(orgId==null||orgId.equals("")){
			orgId=userId;
		}
		
		responseDTO.setValue("userId", userId);
		responseDTO.setValue("orgId", orgId);
		
		return responseDTO;
	}
	//东方添加月报--自动生成二级单位填写的周报
	public ISrvMsg addMonthReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		String orgId = isrvmsg.getValue("orgId");
		String action = isrvmsg.getValue("action");

		String sqlOne = "select t.typeid, t.week_date, t.week_end_date, t.content,oi.org_abbreviation,t.subflag  "
					+"from bgp_wr_martandproject_info t join comm_org_information oi on oi.org_id = t.org_id "
					+"where t.org_id in ('C6000000000003', 'C6000000000004', 'C6000000000010','C6000000000011', 'C6000000000013', 'C6000000000012',"
					+" 'C6000000000045', 'C6000000000008', 'C6000000001888','C0000000000232', 'C6000000000060', 'C6000000000009','C6000000000015','C6000000000017','C6000000006451') and t.bsflag='0' and t.subflag='1' "
					+"and t.type='2' and t.typeid = '1' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlTwo = "select t.typeid, t.week_date, t.week_end_date, t.content,oi.org_abbreviation,t.subflag "
					+"from bgp_wr_martandproject_info t join comm_org_information oi on oi.org_id = t.org_id "
					+"where t.org_id in ('C6000000000003', 'C6000000000004', 'C6000000000010','C6000000000011', 'C6000000000013', 'C6000000000012',"
					+" 'C6000000000045', 'C6000000000008', 'C6000000001888','C0000000000232', 'C6000000000060', 'C6000000000009','C6000000000015','C6000000000017','C6000000006451') and t.bsflag='0' and t.subflag='1' "
					+"and t.type='2' and t.typeid = '2' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlThree = "select t.typeid, t.week_date, t.week_end_date, t.content,oi.org_abbreviation,t.subflag "
					+"from bgp_wr_martandproject_info t join comm_org_information oi on oi.org_id = t.org_id "
					+"where t.org_id in ('C6000000000003', 'C6000000000004', 'C6000000000010','C6000000000011', 'C6000000000013', 'C6000000000012',"
					+" 'C6000000000045', 'C6000000000008', 'C6000000001888','C0000000000232', 'C6000000000060', 'C6000000000009','C6000000000015','C6000000000017','C6000000006451') and t.bsflag='0' and t.subflag='1' "
					+"and t.type='2' and t.typeid = '3' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlFour = "select t.typeid, t.week_date, t.week_end_date, t.content,oi.org_abbreviation,t.subflag "
					+"from bgp_wr_martandproject_info t join comm_org_information oi on oi.org_id = t.org_id "
					+"where t.org_id in ('C6000000000003', 'C6000000000004', 'C6000000000010','C6000000000011', 'C6000000000013', 'C6000000000012',"
					+" 'C6000000000045', 'C6000000000008', 'C6000000001888','C0000000000232', 'C6000000000060', 'C6000000000009','C6000000000015','C6000000000017','C6000000006451') and t.bsflag='0' and t.subflag='1' "
					+"and t.type='2' and t.typeid = '4' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlFive = "select t.typeid, t.week_date, t.week_end_date, t.content,oi.org_abbreviation,t.subflag "
					+"from bgp_wr_martandproject_info t join comm_org_information oi on oi.org_id = t.org_id "
					+"where t.org_id in ('C6000000000003', 'C6000000000004', 'C6000000000010','C6000000000011', 'C6000000000013', 'C6000000000012',"
					+" 'C6000000000045', 'C6000000000008', 'C6000000001888','C0000000000232', 'C6000000000060', 'C6000000000009','C6000000000015','C6000000000017','C6000000006451') and t.bsflag='0' and t.subflag='1' "
					+"and t.type='2' and t.typeid = '5' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		
		List list1 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOne);
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlTwo);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlThree);
		List list4 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlFour);
		List list5 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlFive);
		
		
		responseDTO.setValue("weekDate", weekDate);
		responseDTO.setValue("weekEndDate", weekEndDate);
		responseDTO.setValue("orgId", orgId);
		responseDTO.setValue("action", action);
		

		responseDTO.setValue("list1", list1);
		responseDTO.setValue("list2", list2);
		responseDTO.setValue("list3", list3);
		responseDTO.setValue("list4", list4);
		responseDTO.setValue("list5", list5);
		return responseDTO;
	}
	//保存月报
	public ISrvMsg saveMonthReport(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		
		String orgId = isrvmsg.getValue("orgId");
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		String typeOne = isrvmsg.getValue("typeOne");
		String typeTwo = isrvmsg.getValue("typeTwo");
		String typeThree = isrvmsg.getValue("typeThree");
		String typeFour = isrvmsg.getValue("typeFour");
		String typeFive = isrvmsg.getValue("typeFive");
		if(typeOne!=null&&!"".endsWith(typeOne)){
			typeOne = typeOne.replace("km2","k㎡" );
		}
		if(typeTwo!=null&&!"".endsWith(typeTwo)){
			typeTwo = typeTwo.replace("km2","k㎡" );
		}
		if(typeThree!=null&&!"".endsWith(typeThree)){
			typeThree = typeThree.replace("km2","k㎡" );
		}
		if(typeFour!=null&&!"".endsWith(typeFour)){
			typeFour = typeFour.replace("km2","k㎡" );
		}
		if(typeFive!=null&&!"".endsWith(typeFive)){
			typeFive = typeFive.replace("km2","k㎡" );
		}
		String orgSubjectionId="";
		
		String sql = "select * from comm_org_subjection t where t.locked_if='0' and t.bsflag='0' and t.org_id='"+orgId+"'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		for(int i= 0;i<list.size();i++){
			Map map=(Map)list.get(i);
			orgSubjectionId=(String)map.get("orgSubjectionId") ;
		}
		
		
		Date now = new Date();

		StringBuffer sb = new StringBuffer();
		
		sb.append("INSERT INTO BGP_WR_MARTANDPROJECT_INFO ");
		sb.append("(MARTANDPRO_ID,WEEK_DATE,ORG_ID,ORG_SUBJECTION_ID,TYPEID,CREATE_USER,CREATE_DATE,MONDIFY_USER,MONDIFY_DATE,BSFLAG,SUBFLAG,WEEK_END_DATE,TYPE,CONTENT)");
		sb.append("VALUES(?,to_date('").append(weekDate).append("','yyyy-MM-dd'),'").append(orgId).append("','").append(orgSubjectionId).append("',?,'").append(user.getUserName()).append("',sysdate,'").append(user.getUserName()).append("',sysdate,'0','0',to_date('").append(weekEndDate).append("','yyyy-MM-dd'),'2',?)");
		
		int[] paramTypes = new int[]{Types.VARCHAR, Types.VARCHAR, Types.VARCHAR};
		
		RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String[] types = new String[]{"",typeOne, typeTwo, typeThree, typeFour, typeFive};
		
		for(int i=1;i<=5;i++){
			Object[] params = new Object[]{radDao.generateUUID(), String.valueOf(i), types[i]};
			radDao.getJdbcTemplate().update(sb.toString(), params, paramTypes);
		}
		
		String titleLog = user.getUserName()+"在市场信息月报中添加了一条月报开始日期为：“"+weekDate+"”的信息";
		String operationPlace = "市场信息月报";
		mg.addLogInfo(titleLog, operationPlace);

		return responseDTO;

	}
	
	//修改月报
	public ISrvMsg editMonthReport(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String orgId = isrvmsg.getValue("orgId");
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		String action = isrvmsg.getValue("action");

		String sqlOne = "select * from bgp_wr_martandproject_info t where t.org_id='"+orgId+"' and t.bsflag='0'  "
					+"and t.type='2' and t.typeid = '1' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlTwo = "select * from bgp_wr_martandproject_info t where t.org_id='"+orgId+"' and t.bsflag='0'  "
					+"and t.type='2' and t.typeid = '2' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlThree = "select * from bgp_wr_martandproject_info t where t.org_id='"+orgId+"' and t.bsflag='0'  "
					+"and t.type='2' and t.typeid = '3' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlFour = "select * from bgp_wr_martandproject_info t where t.org_id='"+orgId+"' and t.bsflag='0'  "
					+"and t.type='2' and t.typeid = '4' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		String sqlFive = "select * from bgp_wr_martandproject_info t where t.org_id='"+orgId+"' and t.bsflag='0'  "
					+"and t.type='2' and t.typeid = '5' and to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"'";
		
		List list1 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlOne);
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlTwo);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlThree);
		List list4 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlFour);
		List list5 = BeanFactory.getQueryJdbcDAO().queryRecords(sqlFive);
		
		responseDTO.setValue("weekDate", weekDate);
		responseDTO.setValue("weekEndDate", weekEndDate);
		responseDTO.setValue("orgId", orgId);
		responseDTO.setValue("action", action);
		

		responseDTO.setValue("list1", list1);
		responseDTO.setValue("list2", list2);
		responseDTO.setValue("list3", list3);
		responseDTO.setValue("list4", list4);
		responseDTO.setValue("list5", list5);

		return responseDTO;

	}
	
	//保存修改月报k㎡
	public ISrvMsg updateMonthReport(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		
		String orgId = isrvmsg.getValue("orgId");
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		
		String martandId1 = isrvmsg.getValue("martandId1");
		String martandId2 = isrvmsg.getValue("martandId2");
		String martandId3 = isrvmsg.getValue("martandId3");
		String martandId4 = isrvmsg.getValue("martandId4");
		String martandId5 = isrvmsg.getValue("martandId5");
		
		String typeOne = isrvmsg.getValue("typeOne");
		String typeTwo = isrvmsg.getValue("typeTwo");
		String typeThree = isrvmsg.getValue("typeThree");
		String typeFour = isrvmsg.getValue("typeFour");
		String typeFive = isrvmsg.getValue("typeFive");
		if(typeOne!=null&&!"".endsWith(typeOne)){
			typeOne = typeOne.replace("km2","k㎡" );
		}
		if(typeTwo!=null&&!"".endsWith(typeTwo)){
			typeTwo = typeTwo.replace("km2","k㎡" );
		}
		if(typeThree!=null&&!"".endsWith(typeThree)){
			typeThree = typeThree.replace("km2","k㎡" );
		}
		if(typeFour!=null&&!"".endsWith(typeFour)){
			typeFour = typeFour.replace("km2","k㎡" );
		}
		if(typeFive!=null&&!"".endsWith(typeFive)){
			typeFive = typeFive.replace("km2","k㎡" );
		}
		String orgSubjectionId="";
		
		String sql = "select * from comm_org_subjection t where t.locked_if='0' and t.bsflag='0' and t.org_id='"+orgId+"'";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		for(int i= 0;i<list.size();i++){
			Map map=(Map)list.get(i);
			orgSubjectionId=(String)map.get("orgSubjectionId") ;
		}
		
		Date now = new Date();
		
		
		String updateSql = "update bgp_wr_martandproject_info t set t.week_date= to_date('"+weekDate+"','yyyy-MM-dd'),t.org_id= '"+orgId+"',t.org_subjection_id = '"+orgSubjectionId+"',"
		+" t.typeid= ?,t.mondify_user = '"+user.getUserName()+"',t.mondify_date = sysdate, t.bsflag='0',t.subflag='0',t.week_end_date=to_date('"+weekEndDate+"','yyyy-MM-dd'),t.type='2',"
		+"t.content=? where t.bsflag='0' and t.subflag='0' and t.martandpro_id=?";
				
		int[] paramTypes = new int[]{Types.VARCHAR, Types.VARCHAR, Types.VARCHAR};
		
		RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
		String[] types = new String[]{"",typeOne, typeTwo, typeThree, typeFour, typeFive};
		String[] types2 = new String[]{"",martandId1,martandId2,martandId3,martandId4,martandId5};
 		
		for(int i=1;i<=5;i++){
			Object[] params = new Object[]{ String.valueOf(i),types[i], types2[i]};
			radDao.getJdbcTemplate().update(updateSql, params, paramTypes);
		}
		
		String titleLog = user.getUserName()+"在市场信息月报中修改了一条月报开始日期为：“"+weekDate+"”的信息";
		String operationPlace = "市场信息月报";
		mg.addLogInfo(titleLog, operationPlace);
		
		return responseDTO;

	}
	
	
	//市场价值工作量列表页面
	public ISrvMsg incomeReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String userEmpId = user.getEmpId();
		String corpId = user.getOrgId();
		String name = user.getOrgName();
		String userId="C6000000000025";
		String orgId = isrvmsg.getValue("orgId");
		
		String sql = "select t.org_subjection_id from comm_org_subjection t where t.org_id='"+corpId+"'";
		Map map =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null&&!map.equals("")){
			String orgSubjectionId = map.get("orgSubjectionId").toString();
			if(orgSubjectionId.length()>6){
			String subId = orgSubjectionId.substring(0, 7);
			if(subId.equals("C105005")||subId.equals("C105001")||subId.equals("C105079")){
				if(orgSubjectionId.length()>9){
			   subId = orgSubjectionId.substring(0, 10);
				}
			}
			String orgIdSql = "select * from comm_org_subjection o where o.org_subjection_id='"+subId+"'";
			Map orgMap =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(orgIdSql);
			userId = orgMap.get("orgId").toString();
			}
		}
		
		if(orgId==null||orgId.equals("")){
			orgId=userId;
		}
		
		responseDTO.setValue("userId", userId);
		responseDTO.setValue("orgId", orgId);
		return responseDTO;
	}
	
	//东方添加月报--自动生成二级单位填写的周报
	public ISrvMsg addValueReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		
		String sql0="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000003' order by org_id, country";
		String sql1="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000004' order by org_id, country";
		String sql2="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000010' order by org_id, country";
		String sql3="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000011' order by org_id, country";
		String sql4="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000013' order by org_id, country";
		String sql5="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000012' order by org_id, country";
		String sql6="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000045' order by org_id, country";
		String sql7="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000008' order by org_id, country";
		String sql8="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000001888' order by org_id, country";
		String sql9="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C0000000000232' order by org_id, country";
		String sql10="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000060' order by org_id, country";
		String sql11="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000009' order by org_id, country";
		String sql12="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000015' order by org_id, country";
		String sql13="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000000017' order by org_id, country";
		String sql14="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='1' and org_id='C6000000006451' order by org_id, country";

		
		List list0 = BeanFactory.getQueryJdbcDAO().queryRecords(sql0);
		List list1 = BeanFactory.getQueryJdbcDAO().queryRecords(sql1);
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
		List list4 = BeanFactory.getQueryJdbcDAO().queryRecords(sql4);
		List list5 = BeanFactory.getQueryJdbcDAO().queryRecords(sql5);
		List list6 = BeanFactory.getQueryJdbcDAO().queryRecords(sql6);
		List list7 = BeanFactory.getQueryJdbcDAO().queryRecords(sql7);
		List list8 = BeanFactory.getQueryJdbcDAO().queryRecords(sql8);
		List list9 = BeanFactory.getQueryJdbcDAO().queryRecords(sql9);
		List list10 = BeanFactory.getQueryJdbcDAO().queryRecords(sql10);
		List list11 = BeanFactory.getQueryJdbcDAO().queryRecords(sql11);
		List list12 = BeanFactory.getQueryJdbcDAO().queryRecords(sql12);
		List list13 = BeanFactory.getQueryJdbcDAO().queryRecords(sql13);
		List list14 = BeanFactory.getQueryJdbcDAO().queryRecords(sql14);
		
		responseDTO.setValue("weekDate", weekDate);
		responseDTO.setValue("weekEndDate", weekEndDate);
		String qwe="qwe";

		responseDTO.setValue("qwe", qwe);
		responseDTO.setValue("list0", list0);
		responseDTO.setValue("list1", list1);
		responseDTO.setValue("list2", list2);
		responseDTO.setValue("list3", list3);
		responseDTO.setValue("list4", list4);
		responseDTO.setValue("list5", list5);
		responseDTO.setValue("list6", list6);
		responseDTO.setValue("list7", list7);
		responseDTO.setValue("list8", list8);
		responseDTO.setValue("list9", list9);
		responseDTO.setValue("list10", list10);
		responseDTO.setValue("list11", list11);
		responseDTO.setValue("list12", list12);
		responseDTO.setValue("list13", list13);
		responseDTO.setValue("list14", list14);
		return responseDTO;
	}
	
	public ISrvMsg editValueReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		
		String sql0="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000003' ";
		String sql1="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000004' ";
		String sql2="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000010' ";
		String sql3="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000011' ";
		String sql4="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000013' ";
		String sql5="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000012' ";
		String sql6="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000045' ";
		String sql7="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000008' ";
		String sql8="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000001888' ";
		String sql9="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C0000000000232' ";
		String sql10="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000060'";
		String sql11="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000009'";
		String sql12="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000015'";
		String sql13="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000000017'";
		String sql14="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='1' and org_id='C6000000006451'";

		
		List list0 = BeanFactory.getQueryJdbcDAO().queryRecords(sql0);
		List list1 = BeanFactory.getQueryJdbcDAO().queryRecords(sql1);
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
		List list4 = BeanFactory.getQueryJdbcDAO().queryRecords(sql4);
		List list5 = BeanFactory.getQueryJdbcDAO().queryRecords(sql5);
		List list6 = BeanFactory.getQueryJdbcDAO().queryRecords(sql6);
		List list7 = BeanFactory.getQueryJdbcDAO().queryRecords(sql7);
		List list8 = BeanFactory.getQueryJdbcDAO().queryRecords(sql8);
		List list9 = BeanFactory.getQueryJdbcDAO().queryRecords(sql9);
		List list10 = BeanFactory.getQueryJdbcDAO().queryRecords(sql10);
		List list11 = BeanFactory.getQueryJdbcDAO().queryRecords(sql11);
		List list12 = BeanFactory.getQueryJdbcDAO().queryRecords(sql12);
		List list13 = BeanFactory.getQueryJdbcDAO().queryRecords(sql13);
		List list14 = BeanFactory.getQueryJdbcDAO().queryRecords(sql14);
		
		responseDTO.setValue("weekDate", weekDate);
		responseDTO.setValue("weekEndDate", weekEndDate);
		
		responseDTO.setValue("list0", list0);
		responseDTO.setValue("list1", list1);
		responseDTO.setValue("list2", list2);
		responseDTO.setValue("list3", list3);
		responseDTO.setValue("list4", list4);
		responseDTO.setValue("list5", list5);
		responseDTO.setValue("list6", list6);
		responseDTO.setValue("list7", list7);
		responseDTO.setValue("list8", list8);
		responseDTO.setValue("list9", list9);
		responseDTO.setValue("list10", list10);
		responseDTO.setValue("list11", list11);
		responseDTO.setValue("list12", list12);
		responseDTO.setValue("list13", list13);
		responseDTO.setValue("list14", list14);
		return responseDTO;
	}
	
	public ISrvMsg viewValueReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		
		String sql0="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000003' ";
		String sql1="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000004' ";
		String sql2="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000010' ";
		String sql3="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000011' ";
		String sql4="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000013' ";
		String sql5="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000012' ";
		String sql6="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000045' ";
		String sql7="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000008' ";
		String sql8="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000001888' ";
		String sql9="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C0000000000232' ";
		String sql10="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000060'";
		String sql11="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000009'";
		String sql12="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000015'";
		String sql13="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000000017'";
		String sql14="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='1' and org_id='C6000000006451'";

		
		List list0 = BeanFactory.getQueryJdbcDAO().queryRecords(sql0);
		List list1 = BeanFactory.getQueryJdbcDAO().queryRecords(sql1);
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
		List list4 = BeanFactory.getQueryJdbcDAO().queryRecords(sql4);
		List list5 = BeanFactory.getQueryJdbcDAO().queryRecords(sql5);
		List list6 = BeanFactory.getQueryJdbcDAO().queryRecords(sql6);
		List list7 = BeanFactory.getQueryJdbcDAO().queryRecords(sql7);
		List list8 = BeanFactory.getQueryJdbcDAO().queryRecords(sql8);
		List list9 = BeanFactory.getQueryJdbcDAO().queryRecords(sql9);
		List list10 = BeanFactory.getQueryJdbcDAO().queryRecords(sql10);
		List list11 = BeanFactory.getQueryJdbcDAO().queryRecords(sql11);
		List list12 = BeanFactory.getQueryJdbcDAO().queryRecords(sql12);
		List list13 = BeanFactory.getQueryJdbcDAO().queryRecords(sql13);
		List list14 = BeanFactory.getQueryJdbcDAO().queryRecords(sql14);
		
		responseDTO.setValue("weekDate", weekDate);
		responseDTO.setValue("weekEndDate", weekEndDate);
		
		responseDTO.setValue("list0", list0);
		responseDTO.setValue("list1", list1);
		responseDTO.setValue("list2", list2);
		responseDTO.setValue("list3", list3);
		responseDTO.setValue("list4", list4);
		responseDTO.setValue("list5", list5);
		responseDTO.setValue("list6", list6);
		responseDTO.setValue("list7", list7);
		responseDTO.setValue("list8", list8);
		responseDTO.setValue("list9", list9);
		responseDTO.setValue("list10", list10);
		responseDTO.setValue("list11", list11);
		responseDTO.setValue("list12", list12);
		responseDTO.setValue("list13", list13);
		responseDTO.setValue("list14", list14);
		return responseDTO;
	}
	
	
	public ISrvMsg saveValueReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String week_date = isrvmsg.getValue("week_date");
		String week_end_date = isrvmsg.getValue("week_end_date");
		Date now = new Date();
		
		
//		for(int i=0 ;i<15;i++){
//			for(int j=0;j<2;j++){
//			String org_id = isrvmsg.getValue("org_id"+i);
//			String org_subjection_id = isrvmsg.getValue("org_subjection_id"+i);
//			String income_id = isrvmsg.getValue("income_id"+i+j);
//			String country = isrvmsg.getValue("country"+i+j);
//			String new_get = isrvmsg.getValue("new_get"+i+j) == null ? "" : isrvmsg.getValue("new_get"+i+j);
//			String carryout = isrvmsg.getValue("carryout"+i+j) == null ? "" : isrvmsg.getValue("carryout"+i+j);
//			String carryover = isrvmsg.getValue("carryover"+i+j) == null ? "" : isrvmsg.getValue("carryover"+i+j);
//			String new_sign = isrvmsg.getValue("new_sign"+i+j) == null ? "" : isrvmsg.getValue("new_sign"+i+j);
//			String new_get_dollar = isrvmsg.getValue("new_get_dollar"+i+j) == null ? "" : isrvmsg.getValue("new_get_dollar"+i+j);
//			String carryout_dollar = isrvmsg.getValue("carryout_dollar"+i+j) == null ? "" : isrvmsg.getValue("carryout_dollar"+i+j);
//			String carryovey_dollar = isrvmsg.getValue("carryovey_dollar"+i+j) == null ? "" : isrvmsg.getValue("carryovey_dollar"+i+j);
//			System.out.println(new_sign);
//			
//			Map map = new HashMap();
//			map.put("WEEK_DATE", week_date);
//			map.put("WEEK_END_DATE", week_end_date);
//			map.put("INCOME_ID", income_id);
//			map.put("ORG_ID", org_id);
//			map.put("ORG_SUBJECTION_ID", org_subjection_id);
//			map.put("COUNTRY", country);
//			map.put("NEW_SIGN", new_sign);
//			map.put("NEW_GET", new_get);
//			map.put("CARRYOUT", carryout);
//			map.put("CARRYOVER", carryover);
//			if(j==1){
//				map.put("NEW_GET_DOLLAR", new_get_dollar);
//				map.put("CARRYOUT_DOLLAR", carryout_dollar);
//				map.put("CARRYOVEY_DOLLAR", carryovey_dollar);
//			}
//			map.put("BSFLAG", "0");
//			map.put("SUBFLAG", "0");
//			map.put("ORG_TYPE", "1");
//			map.put("TYPE", "1");
//			map.put("MONDIFY_USER", user.getUserName());
//			map.put("MONDIFY_DATE", now);
//			
//			pureJdbcDao.saveOrUpdateEntity(map, "BGP_WR_INCOME_MONEY");
//			}
//		}
		
		
		
		String org_id0 = isrvmsg.getValue("org_id0") ;
		String org_subjection_id0 = isrvmsg.getValue("org_subjection_id0");
		String new_sign00 = isrvmsg.getValue("new_sign00");
		String new_sign01 = isrvmsg.getValue("new_sign01");
		String income_id00 = isrvmsg.getValue("income_id00");
		String country00 = isrvmsg.getValue("country00");
		String new_get00 = isrvmsg.getValue("new_get00");
		String carryout00 = isrvmsg.getValue("carryout00");
		String carryover00 = isrvmsg.getValue("carryover00");
		String income_id01 = isrvmsg.getValue("income_id01");
		String country01 = isrvmsg.getValue("country01");
		String new_get01 = isrvmsg.getValue("new_get01");
		String new_get_dollar01 = isrvmsg.getValue("new_get_dollar01");
		String carryout01 = isrvmsg.getValue("carryout01");
		String carryout_dollar01 = isrvmsg.getValue("carryout_dollar01");
		String carryover01 = isrvmsg.getValue("carryover01");
		String carryovey_dollar01 = isrvmsg.getValue("carryovey_dollar01");
		
		Map map00 = new HashMap();
		if(income_id00!=null){
		map00.put("WEEK_DATE", week_date);
		map00.put("WEEK_END_DATE", week_end_date);
		map00.put("INCOME_ID", income_id00);
		map00.put("ORG_ID", org_id0);
		map00.put("ORG_SUBJECTION_ID", org_subjection_id0);
		map00.put("NEW_SIGN", new_sign00);
		map00.put("NEW_GET", new_get00);
		map00.put("CARRYOUT", carryout00);
		map00.put("CARRYOVER", carryover00);
		map00.put("COUNTRY", country00);
		map00.put("BSFLAG", "0");
		map00.put("SUBFLAG", "0");
		map00.put("ORG_TYPE", "1");
		map00.put("TYPE", "1");
		map00.put("MONDIFY_USER", user.getUserName());
		map00.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map00, "BGP_WR_INCOME_MONEY");
		}
		
		Map map01 = new HashMap();
		if(income_id01!=null){
		map01.put("WEEK_DATE", week_date);
		map01.put("WEEK_END_DATE", week_end_date);
		map01.put("INCOME_ID", income_id01);
		map01.put("ORG_ID", org_id0);
		map01.put("ORG_SUBJECTION_ID", org_subjection_id0);
		map01.put("NEW_SIGN", new_sign01);
			map01.put("NEW_GET", new_get01);
			map01.put("CARRYOUT", carryout01);
			map01.put("CARRYOVER", carryover01);
			map01.put("NEW_GET_DOLLAR", new_get_dollar01);
			map01.put("CARRYOUT_DOLLAR", carryout_dollar01);
			map01.put("CARRYOVEY_DOLLAR", carryovey_dollar01);
		map01.put("COUNTRY", country01);
		map01.put("BSFLAG", "0");
		map01.put("SUBFLAG", "0");
		map01.put("ORG_TYPE", "1");
		map01.put("TYPE", "1");
		map01.put("MONDIFY_USER", user.getUserName());
		map01.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map01, "BGP_WR_INCOME_MONEY");
		}
		
		
		String org_id1 = isrvmsg.getValue("org_id1");
		String org_subjection_id1 = isrvmsg.getValue("org_subjection_id1");
		String new_sign10 = isrvmsg.getValue("new_sign10");
		String new_sign11 = isrvmsg.getValue("new_sign11");
		String income_id10 = isrvmsg.getValue("income_id10");
		String country10 = isrvmsg.getValue("country10");
		String new_get10 = isrvmsg.getValue("new_get10");
		String carryout10 = isrvmsg.getValue("carryout10");
		String carryover10 = isrvmsg.getValue("carryover10");
		String income_id11 = isrvmsg.getValue("income_id11");
		String country11 = isrvmsg.getValue("country11");
		String new_get11 = isrvmsg.getValue("new_get11");
		String new_get_dollar11 = isrvmsg.getValue("new_get_dollar11");
		String carryout11 = isrvmsg.getValue("carryout11");
		String carryout_dollar11 = isrvmsg.getValue("carryout_dollar11");
		String carryover11 = isrvmsg.getValue("carryover11");
		String carryovey_dollar11 = isrvmsg.getValue("carryovey_dollar11");
		
		Map map10 = new HashMap();
		if(income_id10!=null){
		map10.put("WEEK_DATE", week_date);
		map10.put("WEEK_END_DATE", week_end_date);
		map10.put("INCOME_ID", income_id10);
		map10.put("ORG_ID", org_id1);
		map10.put("ORG_SUBJECTION_ID", org_subjection_id1);
			map10.put("NEW_SIGN", new_sign10);
			map10.put("NEW_GET", new_get10);
			map10.put("CARRYOUT", carryout10);
			map10.put("CARRYOVER", carryover10);
		map10.put("COUNTRY", country10);
		map10.put("BSFLAG", "0");
		map10.put("SUBFLAG", "0");
		map10.put("ORG_TYPE", "1");
		map10.put("TYPE", "1");
		map10.put("MONDIFY_USER", user.getUserName());
		map10.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map10, "BGP_WR_INCOME_MONEY");
		}
		
		Map map11 = new HashMap();
		if(income_id11!=null){
		map11.put("WEEK_DATE", week_date);
		map11.put("WEEK_END_DATE", week_end_date);
		map11.put("INCOME_ID", income_id11);
		map11.put("ORG_ID", org_id1);
		map11.put("ORG_SUBJECTION_ID", org_subjection_id1);
		map11.put("NEW_SIGN", new_sign11);
			map11.put("NEW_GET", new_get11);
			map11.put("CARRYOUT", carryout11);
			map11.put("CARRYOVER", carryover11);
			map11.put("NEW_GET_DOLLAR", new_get_dollar11);
			map11.put("CARRYOUT_DOLLAR", carryout_dollar11);
			map11.put("CARRYOVEY_DOLLAR", carryovey_dollar11);
		map11.put("COUNTRY", country11);
		map11.put("BSFLAG", "0");
		map11.put("SUBFLAG", "0");
		map11.put("ORG_TYPE", "1");
		map11.put("TYPE", "1");
		map11.put("MONDIFY_USER", user.getUserName());
		map11.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map11, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		String org_id2 = isrvmsg.getValue("org_id2");
		String org_subjection_id2 = isrvmsg.getValue("org_subjection_id2");
		String new_sign20 = isrvmsg.getValue("new_sign20");
		String new_sign21 = isrvmsg.getValue("new_sign21");
		String income_id20 = isrvmsg.getValue("income_id20");
		String country20 = isrvmsg.getValue("country20");
		String new_get20 = isrvmsg.getValue("new_get20");
		String carryout20 = isrvmsg.getValue("carryout20");
		String carryover20 = isrvmsg.getValue("carryover20");
		String income_id21 = isrvmsg.getValue("income_id21");
		String country21 = isrvmsg.getValue("country21");
		String new_get21 = isrvmsg.getValue("new_get21");
		String new_get_dollar21 = isrvmsg.getValue("new_get_dollar21");
		String carryout21 = isrvmsg.getValue("carryout21");
		String carryout_dollar21 = isrvmsg.getValue("carryout_dollar21");
		String carryover21 = isrvmsg.getValue("carryover21");
		String carryovey_dollar21 = isrvmsg.getValue("carryovey_dollar21");
		
		Map map20 = new HashMap();
		if(income_id20!=null){
		map20.put("WEEK_DATE", week_date);
		map20.put("WEEK_END_DATE", week_end_date);
		map20.put("INCOME_ID", income_id20);
		map20.put("ORG_ID", org_id2);
		map20.put("ORG_SUBJECTION_ID", org_subjection_id2);
			map20.put("NEW_SIGN", new_sign20);
			map20.put("NEW_GET", new_get20);
			map20.put("CARRYOUT", carryout20);
			map20.put("CARRYOVER", carryover20);
		map20.put("COUNTRY", country20);
		map20.put("BSFLAG", "0");
		map20.put("SUBFLAG", "0");
		map20.put("ORG_TYPE", "1");
		map20.put("TYPE", "1");
		map20.put("MONDIFY_USER", user.getUserName());
		map20.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map20, "BGP_WR_INCOME_MONEY");
		}
		
		Map map21 = new HashMap();
		if(income_id21!=null){
		map21.put("WEEK_DATE", week_date);
		map21.put("WEEK_END_DATE", week_end_date);
		map21.put("INCOME_ID", income_id21);
		map21.put("ORG_ID", org_id2);
		map21.put("ORG_SUBJECTION_ID", org_subjection_id2);
		map21.put("NEW_SIGN", new_sign21);
			map21.put("NEW_GET", new_get21);
			map21.put("CARRYOUT", carryout21);
			map21.put("CARRYOVER", carryover21);
			map21.put("NEW_GET_DOLLAR", new_get_dollar21);
			map21.put("CARRYOUT_DOLLAR", carryout_dollar21);
			map21.put("CARRYOVEY_DOLLAR", carryovey_dollar21);
		map21.put("COUNTRY", country21);
		map21.put("BSFLAG", "0");
		map21.put("SUBFLAG", "0");
		map21.put("ORG_TYPE", "1");
		map21.put("TYPE", "1");
		map21.put("MONDIFY_USER", user.getUserName());
		map21.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map21, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		String org_id3 = isrvmsg.getValue("org_id3");
		String org_subjection_id3 = isrvmsg.getValue("org_subjection_id3");
		String new_sign30 = isrvmsg.getValue("new_sign30");
		String new_sign31 = isrvmsg.getValue("new_sign31");
		String income_id30 = isrvmsg.getValue("income_id30");
		String country30 = isrvmsg.getValue("country30");
		String new_get30 = isrvmsg.getValue("new_get30");
		String carryout30 = isrvmsg.getValue("carryout30");
		String carryover30 = isrvmsg.getValue("carryover30");
		String income_id31 = isrvmsg.getValue("income_id31");
		String country31 = isrvmsg.getValue("country31");
		String new_get31 = isrvmsg.getValue("new_get31");
		String new_get_dollar31 = isrvmsg.getValue("new_get_dollar31");
		String carryout31 = isrvmsg.getValue("carryout31");
		String carryout_dollar31 = isrvmsg.getValue("carryout_dollar31");
		String carryover31 = isrvmsg.getValue("carryover31");
		String carryovey_dollar31 = isrvmsg.getValue("carryovey_dollar31");
		
		Map map30 = new HashMap();
		if(income_id30!=null){
		map30.put("WEEK_DATE", week_date);
		map30.put("WEEK_END_DATE", week_end_date);
		map30.put("INCOME_ID", income_id30);
		map30.put("ORG_ID", org_id3);
		map30.put("ORG_SUBJECTION_ID", org_subjection_id3);
			map30.put("NEW_SIGN", new_sign30);
			map30.put("NEW_GET", new_get30);
			map30.put("CARRYOUT", carryout30);
			map30.put("CARRYOVER", carryover30);
		map30.put("COUNTRY", country30);
		map30.put("BSFLAG", "0");
		map30.put("SUBFLAG", "0");
		map30.put("ORG_TYPE", "1");
		map30.put("TYPE", "1");
		map30.put("MONDIFY_USER", user.getUserName());
		map30.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map30, "BGP_WR_INCOME_MONEY");
		}
		
		Map map31 = new HashMap();
		if(income_id31!=null){
		map31.put("WEEK_DATE", week_date);
		map31.put("WEEK_END_DATE", week_end_date);
		map31.put("INCOME_ID", income_id31);
		map31.put("ORG_ID", org_id3);
		map31.put("ORG_SUBJECTION_ID", org_subjection_id3);
		map31.put("NEW_SIGN", new_sign31);
			map31.put("NEW_GET", new_get31);
			map31.put("CARRYOUT", carryout31);
			map31.put("CARRYOVER", carryover31);
			map31.put("NEW_GET_DOLLAR", new_get_dollar31);
			map31.put("CARRYOUT_DOLLAR", carryout_dollar31);
			map31.put("CARRYOVEY_DOLLAR", carryovey_dollar31);
		map31.put("COUNTRY", country31);
		map31.put("BSFLAG", "0");
		map31.put("SUBFLAG", "0");
		map31.put("ORG_TYPE", "1");
		map31.put("TYPE", "1");
		map31.put("MONDIFY_USER", user.getUserName());
		map31.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map31, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		
		String org_id4 = isrvmsg.getValue("org_id4");
		String org_subjection_id4 = isrvmsg.getValue("org_subjection_id4");
		String new_sign40 = isrvmsg.getValue("new_sign40");
		String new_sign41 = isrvmsg.getValue("new_sign41");
		String income_id40 = isrvmsg.getValue("income_id40");
		String country40 = isrvmsg.getValue("country40");
		String new_get40 = isrvmsg.getValue("new_get40");
		String carryout40 = isrvmsg.getValue("carryout40");
		String carryover40 = isrvmsg.getValue("carryover40");
		String income_id41 = isrvmsg.getValue("income_id41");
		String country41 = isrvmsg.getValue("country41");
		String new_get41 = isrvmsg.getValue("new_get41");
		String new_get_dollar41 = isrvmsg.getValue("new_get_dollar41");
		String carryout41 = isrvmsg.getValue("carryout41");
		String carryout_dollar41 = isrvmsg.getValue("carryout_dollar41");
		String carryover41 = isrvmsg.getValue("carryover41");
		String carryovey_dollar41 = isrvmsg.getValue("carryovey_dollar41");
		
		Map map40 = new HashMap();
		if(income_id40!=null){
		map40.put("WEEK_DATE", week_date);
		map40.put("WEEK_END_DATE", week_end_date);
		map40.put("INCOME_ID", income_id40);
		map40.put("ORG_ID", org_id4);
		map40.put("ORG_SUBJECTION_ID", org_subjection_id4);
			map40.put("NEW_SIGN", new_sign40);
			map40.put("NEW_GET", new_get40);
			map40.put("CARRYOUT", carryout40);
			map40.put("CARRYOVER", carryover40);
		map40.put("COUNTRY", country40);
		map40.put("BSFLAG", "0");
		map40.put("SUBFLAG", "0");
		map40.put("ORG_TYPE", "1");
		map40.put("TYPE", "1");
		map40.put("MONDIFY_USER", user.getUserName());
		map40.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map40, "BGP_WR_INCOME_MONEY");
		}
		
		Map map41 = new HashMap();
		if(income_id41!=null){
		map41.put("WEEK_DATE", week_date);
		map41.put("WEEK_END_DATE", week_end_date);
		map41.put("INCOME_ID", income_id41);
		map41.put("ORG_ID", org_id4);
		map41.put("ORG_SUBJECTION_ID", org_subjection_id4);
		map41.put("NEW_SIGN", new_sign41);
			map41.put("NEW_GET", new_get41);
			map41.put("CARRYOUT", carryout41);
			map41.put("CARRYOVER", carryover41);
			map41.put("NEW_GET_DOLLAR", new_get_dollar41);
			map41.put("CARRYOUT_DOLLAR", carryout_dollar41);
			map41.put("CARRYOVEY_DOLLAR", carryovey_dollar41);
		map41.put("COUNTRY", country41);
		map41.put("BSFLAG", "0");
		map41.put("SUBFLAG", "0");
		map41.put("ORG_TYPE", "1");
		map41.put("TYPE", "1");
		map41.put("MONDIFY_USER", user.getUserName());
		map41.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map41, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		String org_id5 = isrvmsg.getValue("org_id5");
		String org_subjection_id5 = isrvmsg.getValue("org_subjection_id5");
		String new_sign50 = isrvmsg.getValue("new_sign50");
		String new_sign51 = isrvmsg.getValue("new_sign51");
		String income_id50 = isrvmsg.getValue("income_id50");
		String country50 = isrvmsg.getValue("country50");
		String new_get50 = isrvmsg.getValue("new_get50");
		String carryout50 = isrvmsg.getValue("carryout50");
		String carryover50 = isrvmsg.getValue("carryover50");
		String income_id51 = isrvmsg.getValue("income_id51");
		String country51 = isrvmsg.getValue("country51");
		String new_get51 = isrvmsg.getValue("new_get51");
		String new_get_dollar51 = isrvmsg.getValue("new_get_dollar51");
		String carryout51 = isrvmsg.getValue("carryout51");
		String carryout_dollar51 = isrvmsg.getValue("carryout_dollar51");
		String carryover51 = isrvmsg.getValue("carryover51");
		String carryovey_dollar51 = isrvmsg.getValue("carryovey_dollar51");
		
		Map map50 = new HashMap();
		if(income_id50!=null){
		map50.put("WEEK_DATE", week_date);
		map50.put("WEEK_END_DATE", week_end_date);
		map50.put("INCOME_ID", income_id50);
		map50.put("ORG_ID", org_id5);
		map50.put("ORG_SUBJECTION_ID", org_subjection_id5);
			map50.put("NEW_GET", new_get50);
			map50.put("NEW_SIGN", new_sign50);
			map50.put("CARRYOUT", carryout50);
			map50.put("CARRYOVER", carryover50);
		map50.put("COUNTRY", country50);
		map50.put("BSFLAG", "0");
		map50.put("SUBFLAG", "0");
		map50.put("ORG_TYPE", "1");
		map50.put("TYPE", "1");
		map50.put("MONDIFY_USER", user.getUserName());
		map50.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map50, "BGP_WR_INCOME_MONEY");
		}
		
		Map map51 = new HashMap();
		if(income_id51!=null){
		map51.put("WEEK_DATE", week_date);
		map51.put("WEEK_END_DATE", week_end_date);
		map51.put("INCOME_ID", income_id51);
		map51.put("ORG_ID", org_id5);
		map51.put("ORG_SUBJECTION_ID", org_subjection_id5);
		map51.put("NEW_SIGN", new_sign51);
		
			map51.put("NEW_GET", new_get51);
			map51.put("CARRYOUT", carryout51);
			map51.put("CARRYOVER", carryover51);
			map51.put("NEW_GET_DOLLAR", new_get_dollar51);
			map51.put("CARRYOUT_DOLLAR", carryout_dollar51);
			map51.put("CARRYOVEY_DOLLAR", carryovey_dollar51);
		map51.put("COUNTRY", country51);
		map51.put("BSFLAG", "0");
		map51.put("SUBFLAG", "0");
		map51.put("ORG_TYPE", "1");
		map51.put("TYPE", "1");
		map51.put("MONDIFY_USER", user.getUserName());
		map51.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map51, "BGP_WR_INCOME_MONEY");
		}
		
		
		String org_id6 = isrvmsg.getValue("org_id6");
		String org_subjection_id6 = isrvmsg.getValue("org_subjection_id6");
		String new_sign60 = isrvmsg.getValue("new_sign60");
		String new_sign61 = isrvmsg.getValue("new_sign61");
		String income_id60 = isrvmsg.getValue("income_id60");
		String country60 = isrvmsg.getValue("country60");
		String new_get60 = isrvmsg.getValue("new_get60");
		String carryout60 = isrvmsg.getValue("carryout60");
		String carryover60 = isrvmsg.getValue("carryover60");
		String income_id61 = isrvmsg.getValue("income_id61");
		String country61 = isrvmsg.getValue("country61");
		String new_get61 = isrvmsg.getValue("new_get61");
		String new_get_dollar61 = isrvmsg.getValue("new_get_dollar61");
		String carryout61 = isrvmsg.getValue("carryout61");
		String carryout_dollar61 = isrvmsg.getValue("carryout_dollar61");
		String carryover61 = isrvmsg.getValue("carryover61");
		String carryovey_dollar61 = isrvmsg.getValue("carryovey_dollar61");
		
		Map map60 = new HashMap();
		if(income_id60!=null){
		map60.put("WEEK_DATE", week_date);
		map60.put("WEEK_END_DATE", week_end_date);
		map60.put("INCOME_ID", income_id60);
		map60.put("ORG_ID", org_id6);
		map60.put("ORG_SUBJECTION_ID", org_subjection_id6);
			map60.put("NEW_SIGN", new_sign60);
			map60.put("NEW_GET", new_get60);
			map60.put("CARRYOUT", carryout60);
			map60.put("CARRYOVER", carryover60);
		map60.put("COUNTRY", country60);
		map60.put("BSFLAG", "0");
		map60.put("SUBFLAG", "0");
		map60.put("ORG_TYPE", "1");
		map60.put("TYPE", "1");
		map60.put("MONDIFY_USER", user.getUserName());
		map60.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map60, "BGP_WR_INCOME_MONEY");
		}
		
		Map map61 = new HashMap();
		if(income_id61!=null){
		map61.put("WEEK_DATE", week_date);
		map61.put("WEEK_END_DATE", week_end_date);
		map61.put("INCOME_ID", income_id61);
		map61.put("ORG_ID", org_id6);
		map61.put("ORG_SUBJECTION_ID", org_subjection_id6);
		map61.put("NEW_SIGN", new_sign61);
			map61.put("NEW_GET", new_get61);
			map61.put("CARRYOUT", carryout61);
			map61.put("CARRYOVER", carryover61);
			map61.put("NEW_GET_DOLLAR", new_get_dollar61);
			map61.put("CARRYOUT_DOLLAR", carryout_dollar61);
			map61.put("CARRYOVEY_DOLLAR", carryovey_dollar61);
		map61.put("COUNTRY", country61);
		map61.put("BSFLAG", "0");
		map61.put("SUBFLAG", "0");
		map61.put("ORG_TYPE", "1");
		map61.put("TYPE", "1");
		map61.put("MONDIFY_USER", user.getUserName());
		map61.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map61, "BGP_WR_INCOME_MONEY");
		}
		
		
		String org_id7 = isrvmsg.getValue("org_id7");
		String org_subjection_id7 = isrvmsg.getValue("org_subjection_id7");
		String new_sign70 = isrvmsg.getValue("new_sign70");
		String new_sign71 = isrvmsg.getValue("new_sign71");
		String income_id70 = isrvmsg.getValue("income_id70");
		String country70 = isrvmsg.getValue("country70");
		String new_get70 = isrvmsg.getValue("new_get70");
		String carryout70 = isrvmsg.getValue("carryout70");
		String carryover70 = isrvmsg.getValue("carryover70");
		String income_id71 = isrvmsg.getValue("income_id71");
		String country71 = isrvmsg.getValue("country71");
		String new_get71 = isrvmsg.getValue("new_get71");
		String new_get_dollar71 = isrvmsg.getValue("new_get_dollar71");
		String carryout71 = isrvmsg.getValue("carryout71");
		String carryout_dollar71 = isrvmsg.getValue("carryout_dollar71");
		String carryover71 = isrvmsg.getValue("carryover71");
		String carryovey_dollar71 = isrvmsg.getValue("carryovey_dollar71");
		
		Map map70 = new HashMap();
		if(income_id70!=null){
		map70.put("WEEK_DATE", week_date);
		map70.put("WEEK_END_DATE", week_end_date);
		map70.put("INCOME_ID", income_id70);
		map70.put("ORG_ID", org_id7);
		map70.put("ORG_SUBJECTION_ID", org_subjection_id7);
			map70.put("NEW_SIGN", new_sign70);
			map70.put("NEW_GET", new_get70);
			map70.put("CARRYOUT", carryout70);
			map70.put("CARRYOVER", carryover70);
		map70.put("COUNTRY", country70);
		map70.put("BSFLAG", "0");
		map70.put("SUBFLAG", "0");
		map70.put("ORG_TYPE", "1");
		map70.put("TYPE", "1");
		map70.put("MONDIFY_USER", user.getUserName());
		map70.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map70, "BGP_WR_INCOME_MONEY");
		}
		
		Map map71 = new HashMap();
		if(income_id71!=null){
		map71.put("WEEK_DATE", week_date);
		map71.put("WEEK_END_DATE", week_end_date);
		map71.put("INCOME_ID", income_id71);
		map71.put("ORG_ID", org_id7);
		map71.put("ORG_SUBJECTION_ID", org_subjection_id7);
		map71.put("NEW_SIGN", new_sign71);
			map71.put("NEW_GET", new_get71);
			map71.put("CARRYOUT", carryout71);
			map71.put("CARRYOVER", carryover71);
			map71.put("NEW_GET_DOLLAR", new_get_dollar71);
			map71.put("CARRYOUT_DOLLAR", carryout_dollar71);
			map71.put("CARRYOVEY_DOLLAR", carryovey_dollar71);
		map71.put("COUNTRY", country71);
		map71.put("BSFLAG", "0");
		map71.put("SUBFLAG", "0");
		map71.put("ORG_TYPE", "1");
		map71.put("TYPE", "1");
		map71.put("MONDIFY_USER", user.getUserName());
		map71.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map71, "BGP_WR_INCOME_MONEY");
		}
		
		
		String org_id8 = isrvmsg.getValue("org_id8");
		String org_subjection_id8 = isrvmsg.getValue("org_subjection_id8");
		String new_sign80 = isrvmsg.getValue("new_sign80");
		String new_sign81 = isrvmsg.getValue("new_sign81");
		String income_id80 = isrvmsg.getValue("income_id80");
		String country80 = isrvmsg.getValue("country80");
		String new_get80 = isrvmsg.getValue("new_get80");
		String carryout80 = isrvmsg.getValue("carryout80");
		String carryover80 = isrvmsg.getValue("carryover80");
		String income_id81 = isrvmsg.getValue("income_id81");
		String country81 = isrvmsg.getValue("country81");
		String new_get81 = isrvmsg.getValue("new_get81");
		String new_get_dollar81 = isrvmsg.getValue("new_get_dollar81");
		String carryout81 = isrvmsg.getValue("carryout81");
		String carryout_dollar81 = isrvmsg.getValue("carryout_dollar81");
		String carryover81 = isrvmsg.getValue("carryover81");
		String carryovey_dollar81 = isrvmsg.getValue("carryovey_dollar81");
		
		Map map80 = new HashMap();
		if(income_id80!=null){
		map80.put("WEEK_DATE", week_date);
		map80.put("WEEK_END_DATE", week_end_date);
		map80.put("INCOME_ID", income_id80);
		map80.put("ORG_ID", org_id8);
		map80.put("ORG_SUBJECTION_ID", org_subjection_id8);
			map80.put("NEW_SIGN", new_sign80);
			map80.put("NEW_GET", new_get80);
			map80.put("CARRYOUT", carryout80);
			map80.put("CARRYOVER", carryover80);
		map80.put("COUNTRY", country80);
		map80.put("BSFLAG", "0");
		map80.put("SUBFLAG", "0");
		map80.put("ORG_TYPE", "1");
		map80.put("TYPE", "1");
		map80.put("MONDIFY_USER", user.getUserName());
		map80.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map80, "BGP_WR_INCOME_MONEY");
		}
		
		Map map81 = new HashMap();
		if(income_id81!=null){
		map81.put("WEEK_DATE", week_date);
		map81.put("WEEK_END_DATE", week_end_date);
		map81.put("INCOME_ID", income_id81);
		map81.put("ORG_ID", org_id8);
		map81.put("ORG_SUBJECTION_ID", org_subjection_id8);
		map81.put("NEW_SIGN", new_sign81);
			map81.put("NEW_GET", new_get81);
			map81.put("CARRYOUT", carryout81);
			map81.put("CARRYOVER", carryover81);
			map81.put("NEW_GET_DOLLAR", new_get_dollar81);
			map81.put("CARRYOUT_DOLLAR", carryout_dollar81);
			map81.put("CARRYOVEY_DOLLAR", carryovey_dollar81);
		map81.put("COUNTRY", country81);
		map81.put("BSFLAG", "0");
		map81.put("SUBFLAG", "0");
		map81.put("ORG_TYPE", "1");
		map81.put("TYPE", "1");
		map81.put("MONDIFY_USER", user.getUserName());
		map81.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map81, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		String org_id9 = isrvmsg.getValue("org_id9");
		String org_subjection_id9 = isrvmsg.getValue("org_subjection_id9");
		String new_sign90 = isrvmsg.getValue("new_sign90");
		String new_sign91 = isrvmsg.getValue("new_sign91");
		String income_id90 = isrvmsg.getValue("income_id90");
		String country90 = isrvmsg.getValue("country90");
		String new_get90 = isrvmsg.getValue("new_get90");
		String carryout90 = isrvmsg.getValue("carryout90");
		String carryover90 = isrvmsg.getValue("carryover90");
		String income_id91 = isrvmsg.getValue("income_id91");
		String country91 = isrvmsg.getValue("country91");
		String new_get91 = isrvmsg.getValue("new_get91");
		String new_get_dollar91 = isrvmsg.getValue("new_get_dollar91");
		String carryout91 = isrvmsg.getValue("carryout91");
		String carryout_dollar91 = isrvmsg.getValue("carryout_dollar91");
		String carryover91 = isrvmsg.getValue("carryover91");
		String carryovey_dollar91 = isrvmsg.getValue("carryovey_dollar91");
		
		Map map90 = new HashMap();
		if(income_id90!=null){
		map90.put("WEEK_DATE", week_date);
		map90.put("WEEK_END_DATE", week_end_date);
		map90.put("INCOME_ID", income_id90);
		map90.put("ORG_ID", org_id9);
		map90.put("ORG_SUBJECTION_ID", org_subjection_id9);
			map90.put("NEW_GET", new_get90);
			map90.put("NEW_SIGN", new_sign90);
			map90.put("CARRYOUT", carryout90);
			map90.put("CARRYOVER", carryover90);
		map90.put("COUNTRY", country90);
		map90.put("BSFLAG", "0");
		map90.put("SUBFLAG", "0");
		map90.put("ORG_TYPE", "1");
		map90.put("TYPE", "1");
		map90.put("MONDIFY_USER", user.getUserName());
		map90.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map90, "BGP_WR_INCOME_MONEY");
		}
		
		Map map91 = new HashMap();
		if(income_id91!=null){
		map91.put("WEEK_DATE", week_date);
		map91.put("WEEK_END_DATE", week_end_date);
		map91.put("INCOME_ID", income_id91);
		map91.put("ORG_ID", org_id9);
		map91.put("ORG_SUBJECTION_ID", org_subjection_id9);
		map91.put("NEW_SIGN", new_sign91);
			map91.put("NEW_GET", new_get91);
			map91.put("CARRYOUT", carryout91);
			map91.put("CARRYOVER", carryover91);
			map91.put("NEW_GET_DOLLAR", new_get_dollar91);
			map91.put("CARRYOUT_DOLLAR", carryout_dollar91);
			map91.put("CARRYOVEY_DOLLAR", carryovey_dollar91);
		map91.put("COUNTRY", country91);
		map91.put("BSFLAG", "0");
		map91.put("SUBFLAG", "0");
		map91.put("ORG_TYPE", "1");
		map91.put("TYPE", "1");
		map91.put("MONDIFY_USER", user.getUserName());
		map91.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map91, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		String org_id10 = isrvmsg.getValue("org_id10");
		String org_subjection_id10 = isrvmsg.getValue("org_subjection_id10");
		String new_sign100 = isrvmsg.getValue("new_sign100");
		String new_sign101 = isrvmsg.getValue("new_sign101");
		String income_id100 = isrvmsg.getValue("income_id100");
		String country100 = isrvmsg.getValue("country100");
		String new_get100 = isrvmsg.getValue("new_get100");
		String carryout100 = isrvmsg.getValue("carryout100");
		String carryover100 = isrvmsg.getValue("carryover100");
		String income_id101 = isrvmsg.getValue("income_id101");
		String country101 = isrvmsg.getValue("country101");
		String new_get101 = isrvmsg.getValue("new_get101");
		String new_get_dollar101 = isrvmsg.getValue("new_get_dollar101");
		String carryout101 = isrvmsg.getValue("carryout101");
		String carryout_dollar101 = isrvmsg.getValue("carryout_dollar101");
		String carryover101 = isrvmsg.getValue("carryover101");
		String carryovey_dollar101 = isrvmsg.getValue("carryovey_dollar101");
		
		Map map100 = new HashMap();
		if(income_id100!=null){
		map100.put("WEEK_DATE", week_date);
		map100.put("WEEK_END_DATE", week_end_date);
		map100.put("INCOME_ID", income_id100);
		map100.put("ORG_ID", org_id10);
		map100.put("ORG_SUBJECTION_ID", org_subjection_id10);
			map100.put("NEW_SIGN", new_sign100);
			map100.put("NEW_GET", new_get100);
			map100.put("CARRYOUT", carryout100);
			map100.put("CARRYOVER", carryover100);
		map100.put("COUNTRY", country100);
		map100.put("BSFLAG", "0");
		map100.put("SUBFLAG", "0");
		map100.put("ORG_TYPE", "1");
		map100.put("TYPE", "1");
		map100.put("MONDIFY_USER", user.getUserName());
		map100.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map100, "BGP_WR_INCOME_MONEY");
		}
		
		Map map101 = new HashMap();
		if(income_id101!=null){
		map101.put("WEEK_DATE", week_date);
		map101.put("WEEK_END_DATE", week_end_date);
		map101.put("INCOME_ID", income_id101);
		map101.put("ORG_ID", org_id10);
		map101.put("ORG_SUBJECTION_ID", org_subjection_id10);
		map101.put("NEW_SIGN", new_sign101);
			map101.put("NEW_GET", new_get101);
			map101.put("CARRYOUT", carryout101);
			map101.put("CARRYOVER", carryover101);
			map101.put("NEW_GET_DOLLAR", new_get_dollar101);
			map101.put("CARRYOUT_DOLLAR", carryout_dollar101);
			map101.put("CARRYOVEY_DOLLAR", carryovey_dollar101);
		map101.put("COUNTRY", country101);
		map101.put("BSFLAG", "0");
		map101.put("SUBFLAG", "0");
		map101.put("ORG_TYPE", "1");
		map101.put("TYPE", "1");
		map101.put("MONDIFY_USER", user.getUserName());
		map101.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map101, "BGP_WR_INCOME_MONEY");
		}
		
		
		String org_id11 = isrvmsg.getValue("org_id11");
		String org_subjection_id11 = isrvmsg.getValue("org_subjection_id11");
		String new_sign110 = isrvmsg.getValue("new_sign110");
		String new_sign111 = isrvmsg.getValue("new_sign111");
		String income_id110 = isrvmsg.getValue("income_id110");
		String country110 = isrvmsg.getValue("country110");
		String new_get110 = isrvmsg.getValue("new_get110");
		String carryout110 = isrvmsg.getValue("carryout110");
		String carryover110 = isrvmsg.getValue("carryover110");
		String income_id111 = isrvmsg.getValue("income_id111");
		String country111 = isrvmsg.getValue("country111");
		String new_get111 = isrvmsg.getValue("new_get111");
		String new_get_dollar111 = isrvmsg.getValue("new_get_dollar111");
		String carryout111 = isrvmsg.getValue("carryout111");
		String carryout_dollar111 = isrvmsg.getValue("carryout_dollar111");
		String carryover111 = isrvmsg.getValue("carryover111");
		String carryovey_dollar111 = isrvmsg.getValue("carryovey_dollar111");
		
		Map map110 = new HashMap();
		if(income_id110!=null){
		map110.put("WEEK_DATE", week_date);
		map110.put("WEEK_END_DATE", week_end_date);
		map110.put("INCOME_ID", income_id110);
		map110.put("ORG_ID", org_id11);
		map110.put("ORG_SUBJECTION_ID", org_subjection_id11);
			map110.put("NEW_SIGN", new_sign110);
			map110.put("NEW_GET", new_get110);
			map110.put("CARRYOUT", carryout110);
			map110.put("CARRYOVER", carryover110);
		map110.put("COUNTRY", country110);
		map110.put("BSFLAG", "0");
		map110.put("SUBFLAG", "0");
		map110.put("ORG_TYPE", "1");
		map110.put("TYPE", "1");
		map110.put("MONDIFY_USER", user.getUserName());
		map110.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map110, "BGP_WR_INCOME_MONEY");
		}
		
		Map map111 = new HashMap();
		if(income_id111!=null){
		map111.put("WEEK_DATE", week_date);
		map111.put("WEEK_END_DATE", week_end_date);
		map111.put("INCOME_ID", income_id111);
		map111.put("ORG_ID", org_id11);
		map111.put("ORG_SUBJECTION_ID", org_subjection_id11);
		map111.put("NEW_SIGN", new_sign111);
			map111.put("NEW_GET", new_get111);
			map111.put("CARRYOUT", carryout111);
			map111.put("CARRYOVER", carryover111);
			map111.put("NEW_GET_DOLLAR", new_get_dollar111);
			map111.put("CARRYOUT_DOLLAR", carryout_dollar111);
			map111.put("CARRYOVEY_DOLLAR", carryovey_dollar111);
		map111.put("COUNTRY", country111);
		map111.put("BSFLAG", "0");
		map111.put("SUBFLAG", "0");
		map111.put("ORG_TYPE", "1");
		map111.put("TYPE", "1");
		map111.put("MONDIFY_USER", user.getUserName());
		map111.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map111, "BGP_WR_INCOME_MONEY");
		}
		
		String org_id12 = isrvmsg.getValue("org_id12");
		String org_subjection_id12 = isrvmsg.getValue("org_subjection_id12");
		String new_sign120 = isrvmsg.getValue("new_sign120");
		String new_sign121 = isrvmsg.getValue("new_sign121");
		String income_id120 = isrvmsg.getValue("income_id120");
		String country120 = isrvmsg.getValue("country120");
		String new_get120 = isrvmsg.getValue("new_get120");
		String carryout120 = isrvmsg.getValue("carryout120");
		String carryover120 = isrvmsg.getValue("carryover120");
		String income_id121 = isrvmsg.getValue("income_id121");
		String country121 = isrvmsg.getValue("country121");
		String new_get121 = isrvmsg.getValue("new_get121");
		String new_get_dollar121 = isrvmsg.getValue("new_get_dollar121");
		String carryout121 = isrvmsg.getValue("carryout121");
		String carryout_dollar121 = isrvmsg.getValue("carryout_dollar121");
		String carryover121 = isrvmsg.getValue("carryover121");
		String carryovey_dollar121 = isrvmsg.getValue("carryovey_dollar121");
		
		Map map120 = new HashMap();
		if(income_id120!=null){
		map120.put("WEEK_DATE", week_date);
		map120.put("WEEK_END_DATE", week_end_date);
		map120.put("INCOME_ID", income_id120);
		map120.put("ORG_ID", org_id12);
		map120.put("ORG_SUBJECTION_ID", org_subjection_id12);
			map120.put("NEW_SIGN", new_sign120);
			map120.put("NEW_GET", new_get120);
			map120.put("CARRYOUT", carryout120);
			map120.put("CARRYOVER", carryover120);
		map120.put("COUNTRY", country120);
		map120.put("BSFLAG", "0");
		map120.put("SUBFLAG", "0");
		map120.put("ORG_TYPE", "1");
		map120.put("TYPE", "1");
		map120.put("MONDIFY_USER", user.getUserName());
		map120.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map120, "BGP_WR_INCOME_MONEY");
		}
		
		Map map121 = new HashMap();
		if(income_id121!=null){
		map121.put("WEEK_DATE", week_date);
		map121.put("WEEK_END_DATE", week_end_date);
		map121.put("INCOME_ID", income_id121);
		map121.put("ORG_ID", org_id12);
		map121.put("ORG_SUBJECTION_ID", org_subjection_id12);
		map121.put("NEW_SIGN", new_sign121);
			map121.put("NEW_GET", new_get121);
			map121.put("CARRYOUT", carryout121);
			map121.put("CARRYOVER", carryover121);
			map121.put("NEW_GET_DOLLAR", new_get_dollar121);
			map121.put("CARRYOUT_DOLLAR", carryout_dollar121);
			map121.put("CARRYOVEY_DOLLAR", carryovey_dollar121);
		map121.put("COUNTRY", country121);
		map121.put("BSFLAG", "0");
		map121.put("SUBFLAG", "0");
		map121.put("ORG_TYPE", "1");
		map121.put("TYPE", "1");
		map121.put("MONDIFY_USER", user.getUserName());
		map121.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map121, "BGP_WR_INCOME_MONEY");
		}
		
		String org_id13 = isrvmsg.getValue("org_id13");
		String org_subjection_id13 = isrvmsg.getValue("org_subjection_id13");
		String new_sign130 = isrvmsg.getValue("new_sign130");
		String new_sign131 = isrvmsg.getValue("new_sign131");
		String income_id130 = isrvmsg.getValue("income_id130");
		String country130 = isrvmsg.getValue("country130");
		String new_get130 = isrvmsg.getValue("new_get130");
		String carryout130 = isrvmsg.getValue("carryout130");
		String carryover130 = isrvmsg.getValue("carryover130");
		String income_id131 = isrvmsg.getValue("income_id131");
		String country131 = isrvmsg.getValue("country131");
		String new_get131 = isrvmsg.getValue("new_get131");
		String new_get_dollar131 = isrvmsg.getValue("new_get_dollar131");
		String carryout131 = isrvmsg.getValue("carryout131");
		String carryout_dollar131 = isrvmsg.getValue("carryout_dollar131");
		String carryover131 = isrvmsg.getValue("carryover131");
		String carryovey_dollar131 = isrvmsg.getValue("carryovey_dollar131");
		
		Map map130 = new HashMap();
		if(income_id130!=null){
		map130.put("WEEK_DATE", week_date);
		map130.put("WEEK_END_DATE", week_end_date);
		map130.put("INCOME_ID", income_id130);
		map130.put("ORG_ID", org_id13);
		map130.put("ORG_SUBJECTION_ID", org_subjection_id13);
			map130.put("NEW_SIGN", new_sign130);
			map130.put("NEW_GET", new_get130);
			map130.put("CARRYOUT", carryout130);
			map130.put("CARRYOVER", carryover130);
		map130.put("COUNTRY", country130);
		map130.put("BSFLAG", "0");
		map130.put("SUBFLAG", "0");
		map130.put("ORG_TYPE", "1");
		map130.put("TYPE", "1");
		map130.put("MONDIFY_USER", user.getUserName());
		map130.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map130, "BGP_WR_INCOME_MONEY");
		}
		
		Map map131 = new HashMap();
		if(income_id131!=null){
		map131.put("WEEK_DATE", week_date);
		map131.put("WEEK_END_DATE", week_end_date);
		map131.put("INCOME_ID", income_id131);
		map131.put("ORG_ID", org_id13);
		map131.put("ORG_SUBJECTION_ID", org_subjection_id13);
		map131.put("NEW_SIGN", new_sign131);
			map131.put("NEW_GET", new_get131);
			map131.put("CARRYOUT", carryout131);
			map131.put("CARRYOVER", carryover131);
			map131.put("NEW_GET_DOLLAR", new_get_dollar131);
			map131.put("CARRYOUT_DOLLAR", carryout_dollar131);
			map131.put("CARRYOVEY_DOLLAR", carryovey_dollar131);
		map131.put("COUNTRY", country131);
		map131.put("BSFLAG", "0");
		map131.put("SUBFLAG", "0");
		map131.put("ORG_TYPE", "1");
		map131.put("TYPE", "1");
		map131.put("MONDIFY_USER", user.getUserName());
		map131.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map131, "BGP_WR_INCOME_MONEY");
		}
		
		String org_id14 = isrvmsg.getValue("org_id14");
		String org_subjection_id14 = isrvmsg.getValue("org_subjection_id14");
		String new_sign140 = isrvmsg.getValue("new_sign140");
		String new_sign141 = isrvmsg.getValue("new_sign141");
		String income_id140 = isrvmsg.getValue("income_id140");
		String country140 = isrvmsg.getValue("country140");
		String new_get140 = isrvmsg.getValue("new_get140");
		String carryout140 = isrvmsg.getValue("carryout140");
		String carryover140 = isrvmsg.getValue("carryover140");
		String income_id141 = isrvmsg.getValue("income_id141");
		String country141 = isrvmsg.getValue("country141");
		String new_get141 = isrvmsg.getValue("new_get141");
		String new_get_dollar141 = isrvmsg.getValue("new_get_dollar141");
		String carryout141 = isrvmsg.getValue("carryout141");
		String carryout_dollar141 = isrvmsg.getValue("carryout_dollar141");
		String carryover141 = isrvmsg.getValue("carryover141");
		String carryovey_dollar141 = isrvmsg.getValue("carryovey_dollar141");
		
		Map map140 = new HashMap();
		if(income_id140!=null){
		map140.put("WEEK_DATE", week_date);
		map140.put("WEEK_END_DATE", week_end_date);
		map140.put("INCOME_ID", income_id140);
		map140.put("ORG_ID", org_id14);
		map140.put("ORG_SUBJECTION_ID", org_subjection_id14);
			map140.put("NEW_SIGN", new_sign140);
			map140.put("NEW_GET", new_get140);
			map140.put("CARRYOUT", carryout140);
			map140.put("CARRYOVER", carryover140);
		map140.put("COUNTRY", country140);
		map140.put("BSFLAG", "0");
		map140.put("SUBFLAG", "0");
		map140.put("ORG_TYPE", "1");
		map140.put("TYPE", "1");
		map140.put("MONDIFY_USER", user.getUserName());
		map140.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map140, "BGP_WR_INCOME_MONEY");
		}
		
		Map map141 = new HashMap();
		if(income_id141!=null){
		map141.put("WEEK_DATE", week_date);
		map141.put("WEEK_END_DATE", week_end_date);
		map141.put("INCOME_ID", income_id141);
		map141.put("ORG_ID", org_id14);
		map141.put("ORG_SUBJECTION_ID", org_subjection_id14);
		map141.put("NEW_SIGN", new_sign141);
			map141.put("NEW_GET", new_get141);
			map141.put("CARRYOUT", carryout141);
			map141.put("CARRYOVER", carryover141);
			map141.put("NEW_GET_DOLLAR", new_get_dollar141);
			map141.put("CARRYOUT_DOLLAR", carryout_dollar141);
			map141.put("CARRYOVEY_DOLLAR", carryovey_dollar141);
		map141.put("COUNTRY", country141);
		map141.put("BSFLAG", "0");
		map141.put("SUBFLAG", "0");
		map141.put("ORG_TYPE", "1");
		map141.put("TYPE", "1");
		map141.put("MONDIFY_USER", user.getUserName());
		map141.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map141, "BGP_WR_INCOME_MONEY");
		}
		
		
		String titleLog = user.getUserName()+"在周市场落实价值工作量中添加了一条周报开始日期为：“"+week_date+"”的信息";
		String operationPlace = "周市场落实价值工作量";
		mg.addLogInfo(titleLog, operationPlace);

		return responseDTO;
	}
	
	
	//市场价值工作量列表页面(月报)
	public ISrvMsg incomeMonthReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String userEmpId = user.getEmpId();
		String corpId = user.getOrgId();
		String name = user.getOrgName();
		String userId="C6000000000025";
		String orgId = isrvmsg.getValue("orgId");
		
		String sql = "select t.org_subjection_id from comm_org_subjection t where t.org_id='"+corpId+"'";
		Map map =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null&&!map.equals("")){
			String orgSubjectionId = map.get("orgSubjectionId").toString();
			if(orgSubjectionId.length()>6){
			String subId = orgSubjectionId.substring(0, 7);
				if(subId.equals("C105005")||subId.equals("C105001")||subId.equals("C105079")){
					if(orgSubjectionId.length()>9){
				   subId = orgSubjectionId.substring(0, 10);
					}
				}
			String orgIdSql = "select * from comm_org_subjection o where o.org_subjection_id='"+subId+"'";
			Map orgMap =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(orgIdSql);
			userId = orgMap.get("orgId").toString();
			}
		}
		if(orgId==null||orgId.equals("")){
			orgId=userId;
		}
		
		responseDTO.setValue("userId", userId);
		responseDTO.setValue("orgId", orgId);
		return responseDTO;
	}
	//东方添加月报--自动生成二级单位填写的周报
	public ISrvMsg addMonthValueReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		
		String sql0="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000003' order by org_id, country";
		String sql1="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000004' order by org_id, country";
		String sql2="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000010' order by org_id, country";
		String sql3="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000011' order by org_id, country";
		String sql4="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000013' order by org_id, country";
		String sql5="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000012' order by org_id, country";
		String sql6="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000045' order by org_id, country";
		String sql7="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000008' order by org_id, country";
		String sql8="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000001888' order by org_id, country";
		String sql9="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C0000000000232' order by org_id, country";
		String sql10="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000060' order by org_id, country";
		String sql11="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000009' order by org_id, country";
		String sql12="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000015' order by org_id, country";
		String sql13="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000000017' order by org_id, country";
		String sql14="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='1' and org_type = '0' and type='2' and org_id='C6000000006451' order by org_id, country";

		
		List list0 = BeanFactory.getQueryJdbcDAO().queryRecords(sql0);
		List list1 = BeanFactory.getQueryJdbcDAO().queryRecords(sql1);
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
		List list4 = BeanFactory.getQueryJdbcDAO().queryRecords(sql4);
		List list5 = BeanFactory.getQueryJdbcDAO().queryRecords(sql5);
		List list6 = BeanFactory.getQueryJdbcDAO().queryRecords(sql6);
		List list7 = BeanFactory.getQueryJdbcDAO().queryRecords(sql7);
		List list8 = BeanFactory.getQueryJdbcDAO().queryRecords(sql8);
		List list9 = BeanFactory.getQueryJdbcDAO().queryRecords(sql9);
		List list10 = BeanFactory.getQueryJdbcDAO().queryRecords(sql10);
		List list11 = BeanFactory.getQueryJdbcDAO().queryRecords(sql11);
		List list12 = BeanFactory.getQueryJdbcDAO().queryRecords(sql12);
		List list13 = BeanFactory.getQueryJdbcDAO().queryRecords(sql13);
		List list14 = BeanFactory.getQueryJdbcDAO().queryRecords(sql14);
		
		responseDTO.setValue("weekDate", weekDate);
		responseDTO.setValue("weekEndDate", weekEndDate);
		String qwe="qwe";

		responseDTO.setValue("qwe", qwe);
		responseDTO.setValue("list0", list0);
		responseDTO.setValue("list1", list1);
		responseDTO.setValue("list2", list2);
		responseDTO.setValue("list3", list3);
		responseDTO.setValue("list4", list4);
		responseDTO.setValue("list5", list5);
		responseDTO.setValue("list6", list6);
		responseDTO.setValue("list7", list7);
		responseDTO.setValue("list8", list8);
		responseDTO.setValue("list9", list9);
		responseDTO.setValue("list10", list10);
		responseDTO.setValue("list11", list11);
		responseDTO.setValue("list12", list12);
		responseDTO.setValue("list13", list13);
		responseDTO.setValue("list14", list14);
		return responseDTO;
	}
	
	public ISrvMsg editMonthValueReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		
		String sql0="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000003' ";
		String sql1="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000004' ";
		String sql2="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000010' ";
		String sql3="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000011' ";
		String sql4="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000013' ";
		String sql5="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000012' ";
		String sql6="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000045' ";
		String sql7="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000008' ";
		String sql8="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000001888' ";
		String sql9="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C0000000000232' ";
		String sql10="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000060'";
		String sql11="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000009'";
		String sql12="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000015'";
		String sql13="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000000017'";
		String sql14="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0' and subflag='0' and org_type = '1' and type='2' and org_id='C6000000006451'";

		
		List list0 = BeanFactory.getQueryJdbcDAO().queryRecords(sql0);
		List list1 = BeanFactory.getQueryJdbcDAO().queryRecords(sql1);
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
		List list4 = BeanFactory.getQueryJdbcDAO().queryRecords(sql4);
		List list5 = BeanFactory.getQueryJdbcDAO().queryRecords(sql5);
		List list6 = BeanFactory.getQueryJdbcDAO().queryRecords(sql6);
		List list7 = BeanFactory.getQueryJdbcDAO().queryRecords(sql7);
		List list8 = BeanFactory.getQueryJdbcDAO().queryRecords(sql8);
		List list9 = BeanFactory.getQueryJdbcDAO().queryRecords(sql9);
		List list10 = BeanFactory.getQueryJdbcDAO().queryRecords(sql10);
		List list11 = BeanFactory.getQueryJdbcDAO().queryRecords(sql11);
		List list12 = BeanFactory.getQueryJdbcDAO().queryRecords(sql12);
		List list13 = BeanFactory.getQueryJdbcDAO().queryRecords(sql13);
		List list14 = BeanFactory.getQueryJdbcDAO().queryRecords(sql14);
		
		responseDTO.setValue("weekDate", weekDate);
		responseDTO.setValue("weekEndDate", weekEndDate);
		
		responseDTO.setValue("list0", list0);
		responseDTO.setValue("list1", list1);
		responseDTO.setValue("list2", list2);
		responseDTO.setValue("list3", list3);
		responseDTO.setValue("list4", list4);
		responseDTO.setValue("list5", list5);
		responseDTO.setValue("list6", list6);
		responseDTO.setValue("list7", list7);
		responseDTO.setValue("list8", list8);
		responseDTO.setValue("list9", list9);
		responseDTO.setValue("list10", list10);
		responseDTO.setValue("list11", list11);
		responseDTO.setValue("list12", list12);
		responseDTO.setValue("list13", list13);
		responseDTO.setValue("list14", list14);
		return responseDTO;
	}
	
	public ISrvMsg viewMonthValueReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String weekDate = isrvmsg.getValue("week_date");
		String weekEndDate = isrvmsg.getValue("week_end_date");
		
		String sql0="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000003' ";
		String sql1="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000004' ";
		String sql2="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000010' ";
		String sql3="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000011' ";
		String sql4="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000013' ";
		String sql5="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000012' ";
		String sql6="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000045' ";
		String sql7="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000008' ";
		String sql8="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000001888' ";
		String sql9="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C0000000000232' ";
		String sql10="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000060'";
		String sql11="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000009'";
		String sql12="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000015'";
		String sql13="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000000017'";
		String sql14="select t.* from bgp_wr_income_money t where to_char(t.week_date, 'yyyy-MM-dd') = '"+weekDate+"' and to_char(t.week_end_date,'yyyy-MM-dd') = '"+weekEndDate+"' and bsflag = '0'  and org_type = '1' and type='2' and org_id='C6000000006451'";

		
		List list0 = BeanFactory.getQueryJdbcDAO().queryRecords(sql0);
		List list1 = BeanFactory.getQueryJdbcDAO().queryRecords(sql1);
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		List list3 = BeanFactory.getQueryJdbcDAO().queryRecords(sql3);
		List list4 = BeanFactory.getQueryJdbcDAO().queryRecords(sql4);
		List list5 = BeanFactory.getQueryJdbcDAO().queryRecords(sql5);
		List list6 = BeanFactory.getQueryJdbcDAO().queryRecords(sql6);
		List list7 = BeanFactory.getQueryJdbcDAO().queryRecords(sql7);
		List list8 = BeanFactory.getQueryJdbcDAO().queryRecords(sql8);
		List list9 = BeanFactory.getQueryJdbcDAO().queryRecords(sql9);
		List list10 = BeanFactory.getQueryJdbcDAO().queryRecords(sql10);
		List list11 = BeanFactory.getQueryJdbcDAO().queryRecords(sql11);
		List list12 = BeanFactory.getQueryJdbcDAO().queryRecords(sql12);
		List list13 = BeanFactory.getQueryJdbcDAO().queryRecords(sql13);
		List list14 = BeanFactory.getQueryJdbcDAO().queryRecords(sql14);
		
		responseDTO.setValue("weekDate", weekDate);
		responseDTO.setValue("weekEndDate", weekEndDate);
		
		responseDTO.setValue("list0", list0);
		responseDTO.setValue("list1", list1);
		responseDTO.setValue("list2", list2);
		responseDTO.setValue("list3", list3);
		responseDTO.setValue("list4", list4);
		responseDTO.setValue("list5", list5);
		responseDTO.setValue("list6", list6);
		responseDTO.setValue("list7", list7);
		responseDTO.setValue("list8", list8);
		responseDTO.setValue("list9", list9);
		responseDTO.setValue("list10", list10);
		responseDTO.setValue("list11", list11);
		responseDTO.setValue("list12", list12);
		responseDTO.setValue("list13", list13);
		responseDTO.setValue("list14", list14);
		return responseDTO;
	}
	
	public ISrvMsg saveMonthValueReport(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String week_date = isrvmsg.getValue("week_date");
		String week_end_date = isrvmsg.getValue("week_end_date");
		Date now = new Date();
		
//		for(int i=0 ;i<15;i++){
//			for(int j=0;j<2;j++){
//			String org_id = isrvmsg.getValue("org_id"+i);
//			String org_subjection_id = isrvmsg.getValue("org_subjection_id"+i);
//			String income_id = isrvmsg.getValue("income_id"+i+j);
//			String country = isrvmsg.getValue("country"+i+j);
//			String new_get = isrvmsg.getValue("new_get"+i+j) == null ? "" : isrvmsg.getValue("new_get"+i+j);
//			String carryout = isrvmsg.getValue("carryout"+i+j) == null ? "" : isrvmsg.getValue("carryout"+i+j);
//			String carryover = isrvmsg.getValue("carryover"+i+j) == null ? "" : isrvmsg.getValue("carryover"+i+j);
//			String new_sign = isrvmsg.getValue("new_sign"+i+j) == null ? "" : isrvmsg.getValue("new_sign"+i+j);
//			String new_get_dollar = isrvmsg.getValue("new_get_dollar"+i+j) == null ? "" : isrvmsg.getValue("new_get_dollar"+i+j);
//			String carryout_dollar = isrvmsg.getValue("carryout_dollar"+i+j) == null ? "" : isrvmsg.getValue("carryout_dollar"+i+j);
//			String carryovey_dollar = isrvmsg.getValue("carryovey_dollar"+i+j) == null ? "" : isrvmsg.getValue("carryovey_dollar"+i+j);
//			System.out.println(new_sign);
//			
//			Map map = new HashMap();
//			map.put("WEEK_DATE", week_date);
//			map.put("WEEK_END_DATE", week_end_date);
//			map.put("INCOME_ID", income_id);
//			map.put("ORG_ID", org_id);
//			map.put("ORG_SUBJECTION_ID", org_subjection_id);
//			map.put("COUNTRY", country);
//			map.put("NEW_SIGN", new_sign);
//			map.put("NEW_GET", new_get);
//			map.put("CARRYOUT", carryout);
//			map.put("CARRYOVER", carryover);
//			if(j==1){
//				map.put("NEW_GET_DOLLAR", new_get_dollar);
//				map.put("CARRYOUT_DOLLAR", carryout_dollar);
//				map.put("CARRYOVEY_DOLLAR", carryovey_dollar);
//			}
//			map.put("BSFLAG", "0");
//			map.put("SUBFLAG", "0");
//			map.put("ORG_TYPE", "1");
//			map.put("TYPE", "2");
//			map.put("MONDIFY_USER", user.getUserName());
//			map.put("MONDIFY_DATE", now);
//			
//			pureJdbcDao.saveOrUpdateEntity(map, "BGP_WR_INCOME_MONEY");
//			}
//		}
		
		
		
		String org_id0 = isrvmsg.getValue("org_id0") ;
		String org_subjection_id0 = isrvmsg.getValue("org_subjection_id0");
		String new_sign00 = isrvmsg.getValue("new_sign00");
		String new_sign01 = isrvmsg.getValue("new_sign01");
		
		String income_id00 = isrvmsg.getValue("income_id00");
		String country00 = isrvmsg.getValue("country00");
		String new_get00 = isrvmsg.getValue("new_get00");
		String carryout00 = isrvmsg.getValue("carryout00");
		String carryover00 = isrvmsg.getValue("carryover00");
		String income_id01 = isrvmsg.getValue("income_id01");
		String country01 = isrvmsg.getValue("country01");
		String new_get01 = isrvmsg.getValue("new_get01");
		String new_get_dollar01 = isrvmsg.getValue("new_get_dollar01");
		String carryout01 = isrvmsg.getValue("carryout01");
		String carryout_dollar01 = isrvmsg.getValue("carryout_dollar01");
		String carryover01 = isrvmsg.getValue("carryover01");
		String carryovey_dollar01 = isrvmsg.getValue("carryovey_dollar01");
		
		Map map00 = new HashMap();
		if(income_id00!=null){
		map00.put("WEEK_DATE", week_date);
		map00.put("WEEK_END_DATE", week_end_date);
		map00.put("INCOME_ID", income_id00);
		map00.put("ORG_ID", org_id0);
		map00.put("ORG_SUBJECTION_ID", org_subjection_id0);
			map00.put("NEW_SIGN", new_sign00);
			map00.put("NEW_GET", new_get00);
			map00.put("CARRYOUT", carryout00);
			map00.put("CARRYOVER", carryover00);
		map00.put("COUNTRY", country00);
		map00.put("BSFLAG", "0");
		map00.put("SUBFLAG", "0");
		map00.put("ORG_TYPE", "1");
		map00.put("TYPE", "2");
		map00.put("MONDIFY_USER", user.getUserName());
		map00.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map00, "BGP_WR_INCOME_MONEY");
		}
		
		Map map01 = new HashMap();
		if(income_id01!=null){
		map01.put("WEEK_DATE", week_date);
		map01.put("WEEK_END_DATE", week_end_date);
		map01.put("INCOME_ID", income_id01);
		map01.put("ORG_ID", org_id0);
		map01.put("ORG_SUBJECTION_ID", org_subjection_id0);
		map01.put("NEW_SIGN", new_sign01);
			map01.put("NEW_GET", new_get01);
			map01.put("CARRYOUT", carryout01);
			map01.put("CARRYOVER", carryover01);
			map01.put("NEW_GET_DOLLAR", new_get_dollar01);
			map01.put("CARRYOUT_DOLLAR", carryout_dollar01);
			map01.put("CARRYOVEY_DOLLAR", carryovey_dollar01);
		map01.put("COUNTRY", country01);
		map01.put("BSFLAG", "0");
		map01.put("SUBFLAG", "0");
		map01.put("ORG_TYPE", "1");
		map01.put("TYPE", "2");
		map01.put("MONDIFY_USER", user.getUserName());
		map01.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map01, "BGP_WR_INCOME_MONEY");
		}
		
		
		String org_id1 = isrvmsg.getValue("org_id1");
		String org_subjection_id1 = isrvmsg.getValue("org_subjection_id1");
		String new_sign10 = isrvmsg.getValue("new_sign10");
		String new_sign11 = isrvmsg.getValue("new_sign11");
		String income_id10 = isrvmsg.getValue("income_id10");
		String country10 = isrvmsg.getValue("country10");
		String new_get10 = isrvmsg.getValue("new_get10");
		String carryout10 = isrvmsg.getValue("carryout10");
		String carryover10 = isrvmsg.getValue("carryover10");
		String income_id11 = isrvmsg.getValue("income_id11");
		String country11 = isrvmsg.getValue("country11");
		String new_get11 = isrvmsg.getValue("new_get11");
		String new_get_dollar11 = isrvmsg.getValue("new_get_dollar11");
		String carryout11 = isrvmsg.getValue("carryout11");
		String carryout_dollar11 = isrvmsg.getValue("carryout_dollar11");
		String carryover11 = isrvmsg.getValue("carryover11");
		String carryovey_dollar11 = isrvmsg.getValue("carryovey_dollar11");
		
		Map map10 = new HashMap();
		if(income_id10!=null){
		map10.put("WEEK_DATE", week_date);
		map10.put("WEEK_END_DATE", week_end_date);
		map10.put("INCOME_ID", income_id10);
		map10.put("ORG_ID", org_id1);
		map10.put("ORG_SUBJECTION_ID", org_subjection_id1);
			map10.put("NEW_SIGN", new_sign10);
			map10.put("NEW_GET", new_get10);
			map10.put("CARRYOUT", carryout10);
			map10.put("CARRYOVER", carryover10);
		map10.put("COUNTRY", country10);
		map10.put("BSFLAG", "0");
		map10.put("SUBFLAG", "0");
		map10.put("ORG_TYPE", "1");
		map10.put("TYPE", "2");
		map10.put("MONDIFY_USER", user.getUserName());
		map10.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map10, "BGP_WR_INCOME_MONEY");
		}
		
		Map map11 = new HashMap();
		if(income_id11!=null){
		map11.put("WEEK_DATE", week_date);
		map11.put("WEEK_END_DATE", week_end_date);
		map11.put("INCOME_ID", income_id11);
		map11.put("ORG_ID", org_id1);
		map11.put("ORG_SUBJECTION_ID", org_subjection_id1);
		map11.put("NEW_SIGN", new_sign11);
			map11.put("NEW_GET", new_get11);
			map11.put("CARRYOUT", carryout11);
			map11.put("CARRYOVER", carryover11);
			map11.put("NEW_GET_DOLLAR", new_get_dollar11);
			map11.put("CARRYOUT_DOLLAR", carryout_dollar11);
			map11.put("CARRYOVEY_DOLLAR", carryovey_dollar11);
		map11.put("COUNTRY", country11);
		map11.put("BSFLAG", "0");
		map11.put("SUBFLAG", "0");
		map11.put("ORG_TYPE", "1");
		map11.put("TYPE", "2");
		map11.put("MONDIFY_USER", user.getUserName());
		map11.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map11, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		String org_id2 = isrvmsg.getValue("org_id2");
		String org_subjection_id2 = isrvmsg.getValue("org_subjection_id2");
		String new_sign20 = isrvmsg.getValue("new_sign20");
		String new_sign21 = isrvmsg.getValue("new_sign21");
		String income_id20 = isrvmsg.getValue("income_id20");
		String country20 = isrvmsg.getValue("country20");
		String new_get20 = isrvmsg.getValue("new_get20");
		String carryout20 = isrvmsg.getValue("carryout20");
		String carryover20 = isrvmsg.getValue("carryover20");
		String income_id21 = isrvmsg.getValue("income_id21");
		String country21 = isrvmsg.getValue("country21");
		String new_get21 = isrvmsg.getValue("new_get21");
		String new_get_dollar21 = isrvmsg.getValue("new_get_dollar21");
		String carryout21 = isrvmsg.getValue("carryout21");
		String carryout_dollar21 = isrvmsg.getValue("carryout_dollar21");
		String carryover21 = isrvmsg.getValue("carryover21");
		String carryovey_dollar21 = isrvmsg.getValue("carryovey_dollar21");
		
		Map map20 = new HashMap();
		if(income_id20!=null){
		map20.put("WEEK_DATE", week_date);
		map20.put("WEEK_END_DATE", week_end_date);
		map20.put("INCOME_ID", income_id20);
		map20.put("ORG_ID", org_id2);
		map20.put("ORG_SUBJECTION_ID", org_subjection_id2);
			map20.put("NEW_SIGN", new_sign20);
			map20.put("NEW_GET", new_get20);
			map20.put("CARRYOUT", carryout20);
			map20.put("CARRYOVER", carryover20);
		map20.put("COUNTRY", country20);
		map20.put("BSFLAG", "0");
		map20.put("SUBFLAG", "0");
		map20.put("ORG_TYPE", "1");
		map20.put("TYPE", "2");
		map20.put("MONDIFY_USER", user.getUserName());
		map20.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map20, "BGP_WR_INCOME_MONEY");
		}
		
		Map map21 = new HashMap();
		if(income_id21!=null){
		map21.put("WEEK_DATE", week_date);
		map21.put("WEEK_END_DATE", week_end_date);
		map21.put("INCOME_ID", income_id21);
		map21.put("ORG_ID", org_id2);
		map21.put("ORG_SUBJECTION_ID", org_subjection_id2);
		map21.put("NEW_SIGN", new_sign21);
			map21.put("NEW_GET", new_get21);
			map21.put("CARRYOUT", carryout21);
			map21.put("CARRYOVER", carryover21);
			map21.put("NEW_GET_DOLLAR", new_get_dollar21);
			map21.put("CARRYOUT_DOLLAR", carryout_dollar21);
			map21.put("CARRYOVEY_DOLLAR", carryovey_dollar21);
		map21.put("COUNTRY", country21);
		map21.put("BSFLAG", "0");
		map21.put("SUBFLAG", "0");
		map21.put("ORG_TYPE", "1");
		map21.put("TYPE", "2");
		map21.put("MONDIFY_USER", user.getUserName());
		map21.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map21, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		String org_id3 = isrvmsg.getValue("org_id3");
		String org_subjection_id3 = isrvmsg.getValue("org_subjection_id3");
		String new_sign30 = isrvmsg.getValue("new_sign30");
		String new_sign31 = isrvmsg.getValue("new_sign31");
		String income_id30 = isrvmsg.getValue("income_id30");
		String country30 = isrvmsg.getValue("country30");
		String new_get30 = isrvmsg.getValue("new_get30");
		String carryout30 = isrvmsg.getValue("carryout30");
		String carryover30 = isrvmsg.getValue("carryover30");
		String income_id31 = isrvmsg.getValue("income_id31");
		String country31 = isrvmsg.getValue("country31");
		String new_get31 = isrvmsg.getValue("new_get31");
		String new_get_dollar31 = isrvmsg.getValue("new_get_dollar31");
		String carryout31 = isrvmsg.getValue("carryout31");
		String carryout_dollar31 = isrvmsg.getValue("carryout_dollar31");
		String carryover31 = isrvmsg.getValue("carryover31");
		String carryovey_dollar31 = isrvmsg.getValue("carryovey_dollar31");
		
		Map map30 = new HashMap();
		if(income_id30!=null){
		map30.put("WEEK_DATE", week_date);
		map30.put("WEEK_END_DATE", week_end_date);
		map30.put("INCOME_ID", income_id30);
		map30.put("ORG_ID", org_id3);
		map30.put("ORG_SUBJECTION_ID", org_subjection_id3);
			map30.put("NEW_SIGN", new_sign30);
			map30.put("NEW_GET", new_get30);
			map30.put("CARRYOUT", carryout30);
			map30.put("CARRYOVER", carryover30);
		map30.put("COUNTRY", country30);
		map30.put("BSFLAG", "0");
		map30.put("SUBFLAG", "0");
		map30.put("ORG_TYPE", "1");
		map30.put("TYPE", "2");
		map30.put("MONDIFY_USER", user.getUserName());
		map30.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map30, "BGP_WR_INCOME_MONEY");
		}
		
		Map map31 = new HashMap();
		if(income_id31!=null){
		map31.put("WEEK_DATE", week_date);
		map31.put("WEEK_END_DATE", week_end_date);
		map31.put("INCOME_ID", income_id31);
		map31.put("ORG_ID", org_id3);
		map31.put("ORG_SUBJECTION_ID", org_subjection_id3);
		map31.put("NEW_SIGN", new_sign31);
			map31.put("NEW_GET", new_get31);
			map31.put("CARRYOUT", carryout31);
			map31.put("CARRYOVER", carryover31);
			map31.put("NEW_GET_DOLLAR", new_get_dollar31);
			map31.put("CARRYOUT_DOLLAR", carryout_dollar31);
			map31.put("CARRYOVEY_DOLLAR", carryovey_dollar31);
		map31.put("COUNTRY", country31);
		map31.put("BSFLAG", "0");
		map31.put("SUBFLAG", "0");
		map31.put("ORG_TYPE", "1");
		map31.put("TYPE", "2");
		map31.put("MONDIFY_USER", user.getUserName());
		map31.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map31, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		
		String org_id4 = isrvmsg.getValue("org_id4");
		String org_subjection_id4 = isrvmsg.getValue("org_subjection_id4");
		String new_sign40 = isrvmsg.getValue("new_sign40");
		String new_sign41 = isrvmsg.getValue("new_sign41");
		String income_id40 = isrvmsg.getValue("income_id40");
		String country40 = isrvmsg.getValue("country40");
		String new_get40 = isrvmsg.getValue("new_get40");
		String carryout40 = isrvmsg.getValue("carryout40");
		String carryover40 = isrvmsg.getValue("carryover40");
		String income_id41 = isrvmsg.getValue("income_id41");
		String country41 = isrvmsg.getValue("country41");
		String new_get41 = isrvmsg.getValue("new_get41");
		String new_get_dollar41 = isrvmsg.getValue("new_get_dollar41");
		String carryout41 = isrvmsg.getValue("carryout41");
		String carryout_dollar41 = isrvmsg.getValue("carryout_dollar41");
		String carryover41 = isrvmsg.getValue("carryover41");
		String carryovey_dollar41 = isrvmsg.getValue("carryovey_dollar41");
		
		Map map40 = new HashMap();
		if(income_id40!=null){
		map40.put("WEEK_DATE", week_date);
		map40.put("WEEK_END_DATE", week_end_date);
		map40.put("INCOME_ID", income_id40);
		map40.put("ORG_ID", org_id4);
		map40.put("ORG_SUBJECTION_ID", org_subjection_id4);
			map40.put("NEW_SIGN", new_sign40);
			map40.put("NEW_GET", new_get40);
			map40.put("CARRYOUT", carryout40);
			map40.put("CARRYOVER", carryover40);
		map40.put("COUNTRY", country40);
		map40.put("BSFLAG", "0");
		map40.put("SUBFLAG", "0");
		map40.put("ORG_TYPE", "1");
		map40.put("TYPE", "2");
		map40.put("MONDIFY_USER", user.getUserName());
		map40.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map40, "BGP_WR_INCOME_MONEY");
		}
		
		Map map41 = new HashMap();
		if(income_id41!=null){
		map41.put("WEEK_DATE", week_date);
		map41.put("WEEK_END_DATE", week_end_date);
		map41.put("INCOME_ID", income_id41);
		map41.put("ORG_ID", org_id4);
		map41.put("ORG_SUBJECTION_ID", org_subjection_id4);
		map41.put("NEW_SIGN", new_sign41);
			map41.put("NEW_GET", new_get41);
			map41.put("CARRYOUT", carryout41);
			map41.put("CARRYOVER", carryover41);
			map41.put("NEW_GET_DOLLAR", new_get_dollar41);
			map41.put("CARRYOUT_DOLLAR", carryout_dollar41);
			map41.put("CARRYOVEY_DOLLAR", carryovey_dollar41);
		map41.put("COUNTRY", country41);
		map41.put("BSFLAG", "0");
		map41.put("SUBFLAG", "0");
		map41.put("ORG_TYPE", "1");
		map41.put("TYPE", "2");
		map41.put("MONDIFY_USER", user.getUserName());
		map41.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map41, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		String org_id5 = isrvmsg.getValue("org_id5");
		String org_subjection_id5 = isrvmsg.getValue("org_subjection_id5");
		String new_sign50 = isrvmsg.getValue("new_sign50");
		String new_sign51 = isrvmsg.getValue("new_sign51");
		String income_id50 = isrvmsg.getValue("income_id50");
		String country50 = isrvmsg.getValue("country50");
		String new_get50 = isrvmsg.getValue("new_get50");
		String carryout50 = isrvmsg.getValue("carryout50");
		String carryover50 = isrvmsg.getValue("carryover50");
		String income_id51 = isrvmsg.getValue("income_id51");
		String country51 = isrvmsg.getValue("country51");
		String new_get51 = isrvmsg.getValue("new_get51");
		String new_get_dollar51 = isrvmsg.getValue("new_get_dollar51");
		String carryout51 = isrvmsg.getValue("carryout51");
		String carryout_dollar51 = isrvmsg.getValue("carryout_dollar51");
		String carryover51 = isrvmsg.getValue("carryover51");
		String carryovey_dollar51 = isrvmsg.getValue("carryovey_dollar51");
		
		Map map50 = new HashMap();
		if(income_id50!=null){
		map50.put("WEEK_DATE", week_date);
		map50.put("WEEK_END_DATE", week_end_date);
		map50.put("INCOME_ID", income_id50);
		map50.put("ORG_ID", org_id5);
		map50.put("ORG_SUBJECTION_ID", org_subjection_id5);
			map50.put("NEW_GET", new_get50);
			map50.put("NEW_SIGN", new_sign50);
			map50.put("CARRYOUT", carryout50);
			map50.put("CARRYOVER", carryover50);
		map50.put("COUNTRY", country50);
		map50.put("BSFLAG", "0");
		map50.put("SUBFLAG", "0");
		map50.put("ORG_TYPE", "1");
		map50.put("TYPE", "2");
		map50.put("MONDIFY_USER", user.getUserName());
		map50.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map50, "BGP_WR_INCOME_MONEY");
		}
		
		Map map51 = new HashMap();
		if(income_id51!=null){
		map51.put("WEEK_DATE", week_date);
		map51.put("WEEK_END_DATE", week_end_date);
		map51.put("INCOME_ID", income_id51);
		map51.put("ORG_ID", org_id5);
		map51.put("ORG_SUBJECTION_ID", org_subjection_id5);
		map51.put("NEW_SIGN", new_sign51);
			map51.put("NEW_GET", new_get51);
			map51.put("CARRYOUT", carryout51);
			map51.put("CARRYOVER", carryover51);
			map51.put("NEW_GET_DOLLAR", new_get_dollar51);
			map51.put("CARRYOUT_DOLLAR", carryout_dollar51);
			map51.put("CARRYOVEY_DOLLAR", carryovey_dollar51);
		map51.put("COUNTRY", country51);
		map51.put("BSFLAG", "0");
		map51.put("SUBFLAG", "0");
		map51.put("ORG_TYPE", "1");
		map51.put("TYPE", "2");
		map51.put("MONDIFY_USER", user.getUserName());
		map51.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map51, "BGP_WR_INCOME_MONEY");
		}
		
		
		String org_id6 = isrvmsg.getValue("org_id6");
		String org_subjection_id6 = isrvmsg.getValue("org_subjection_id6");
		String new_sign60 = isrvmsg.getValue("new_sign60");
		String new_sign61 = isrvmsg.getValue("new_sign61");
		String income_id60 = isrvmsg.getValue("income_id60");
		String country60 = isrvmsg.getValue("country60");
		String new_get60 = isrvmsg.getValue("new_get60");
		String carryout60 = isrvmsg.getValue("carryout60");
		String carryover60 = isrvmsg.getValue("carryover60");
		String income_id61 = isrvmsg.getValue("income_id61");
		String country61 = isrvmsg.getValue("country61");
		String new_get61 = isrvmsg.getValue("new_get61");
		String new_get_dollar61 = isrvmsg.getValue("new_get_dollar61");
		String carryout61 = isrvmsg.getValue("carryout61");
		String carryout_dollar61 = isrvmsg.getValue("carryout_dollar61");
		String carryover61 = isrvmsg.getValue("carryover61");
		String carryovey_dollar61 = isrvmsg.getValue("carryovey_dollar61");
		
		Map map60 = new HashMap();
		if(income_id60!=null){
		map60.put("WEEK_DATE", week_date);
		map60.put("WEEK_END_DATE", week_end_date);
		map60.put("INCOME_ID", income_id60);
		map60.put("ORG_ID", org_id6);
		map60.put("ORG_SUBJECTION_ID", org_subjection_id6);
			map60.put("NEW_SIGN", new_sign60);
			map60.put("NEW_GET", new_get60);
			map60.put("CARRYOUT", carryout60);
			map60.put("CARRYOVER", carryover60);
		map60.put("COUNTRY", country60);
		map60.put("BSFLAG", "0");
		map60.put("SUBFLAG", "0");
		map60.put("ORG_TYPE", "1");
		map60.put("TYPE", "2");
		map60.put("MONDIFY_USER", user.getUserName());
		map60.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map60, "BGP_WR_INCOME_MONEY");
		}
		
		Map map61 = new HashMap();
		if(income_id61!=null){
		map61.put("WEEK_DATE", week_date);
		map61.put("WEEK_END_DATE", week_end_date);
		map61.put("INCOME_ID", income_id61);
		map61.put("ORG_ID", org_id6);
		map61.put("ORG_SUBJECTION_ID", org_subjection_id6);
		map61.put("NEW_SIGN", new_sign61);
			map61.put("NEW_GET", new_get61);
			map61.put("CARRYOUT", carryout61);
			map61.put("CARRYOVER", carryover61);
			map61.put("NEW_GET_DOLLAR", new_get_dollar61);
			map61.put("CARRYOUT_DOLLAR", carryout_dollar61);
			map61.put("CARRYOVEY_DOLLAR", carryovey_dollar61);
		map61.put("COUNTRY", country61);
		map61.put("BSFLAG", "0");
		map61.put("SUBFLAG", "0");
		map61.put("ORG_TYPE", "1");
		map61.put("TYPE", "2");
		map61.put("MONDIFY_USER", user.getUserName());
		map61.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map61, "BGP_WR_INCOME_MONEY");
		}
		
		
		String org_id7 = isrvmsg.getValue("org_id7");
		String org_subjection_id7 = isrvmsg.getValue("org_subjection_id7");
		String new_sign70 = isrvmsg.getValue("new_sign70");
		String new_sign71 = isrvmsg.getValue("new_sign71");
		String income_id70 = isrvmsg.getValue("income_id70");
		String country70 = isrvmsg.getValue("country70");
		String new_get70 = isrvmsg.getValue("new_get70");
		String carryout70 = isrvmsg.getValue("carryout70");
		String carryover70 = isrvmsg.getValue("carryover70");
		String income_id71 = isrvmsg.getValue("income_id71");
		String country71 = isrvmsg.getValue("country71");
		String new_get71 = isrvmsg.getValue("new_get71");
		String new_get_dollar71 = isrvmsg.getValue("new_get_dollar71");
		String carryout71 = isrvmsg.getValue("carryout71");
		String carryout_dollar71 = isrvmsg.getValue("carryout_dollar71");
		String carryover71 = isrvmsg.getValue("carryover71");
		String carryovey_dollar71 = isrvmsg.getValue("carryovey_dollar71");
		
		Map map70 = new HashMap();
		if(income_id70!=null){
		map70.put("WEEK_DATE", week_date);
		map70.put("WEEK_END_DATE", week_end_date);
		map70.put("INCOME_ID", income_id70);
		map70.put("ORG_ID", org_id7);
		map70.put("ORG_SUBJECTION_ID", org_subjection_id7);
			map70.put("NEW_SIGN", new_sign70);
			map70.put("NEW_GET", new_get70);
			map70.put("CARRYOUT", carryout70);
			map70.put("CARRYOVER", carryover70);
		map70.put("COUNTRY", country70);
		map70.put("BSFLAG", "0");
		map70.put("SUBFLAG", "0");
		map70.put("ORG_TYPE", "1");
		map70.put("TYPE", "2");
		map70.put("MONDIFY_USER", user.getUserName());
		map70.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map70, "BGP_WR_INCOME_MONEY");
		}
		
		Map map71 = new HashMap();
		if(income_id71!=null){
		map71.put("WEEK_DATE", week_date);
		map71.put("WEEK_END_DATE", week_end_date);
		map71.put("INCOME_ID", income_id71);
		map71.put("ORG_ID", org_id7);
		map71.put("ORG_SUBJECTION_ID", org_subjection_id7);
		map71.put("NEW_SIGN", new_sign71);
			map71.put("NEW_GET", new_get71);
			map71.put("CARRYOUT", carryout71);
			map71.put("CARRYOVER", carryover71);
			map71.put("NEW_GET_DOLLAR", new_get_dollar71);
			map71.put("CARRYOUT_DOLLAR", carryout_dollar71);
			map71.put("CARRYOVEY_DOLLAR", carryovey_dollar71);
		map71.put("COUNTRY", country71);
		map71.put("BSFLAG", "0");
		map71.put("SUBFLAG", "0");
		map71.put("ORG_TYPE", "1");
		map71.put("TYPE", "2");
		map71.put("MONDIFY_USER", user.getUserName());
		map71.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map71, "BGP_WR_INCOME_MONEY");
		}
		
		
		String org_id8 = isrvmsg.getValue("org_id8");
		String org_subjection_id8 = isrvmsg.getValue("org_subjection_id8");
		String new_sign80 = isrvmsg.getValue("new_sign80");
		String new_sign81 = isrvmsg.getValue("new_sign81");
		String income_id80 = isrvmsg.getValue("income_id80");
		String country80 = isrvmsg.getValue("country80");
		String new_get80 = isrvmsg.getValue("new_get80");
		String carryout80 = isrvmsg.getValue("carryout80");
		String carryover80 = isrvmsg.getValue("carryover80");
		String income_id81 = isrvmsg.getValue("income_id81");
		String country81 = isrvmsg.getValue("country81");
		String new_get81 = isrvmsg.getValue("new_get81");
		String new_get_dollar81 = isrvmsg.getValue("new_get_dollar81");
		String carryout81 = isrvmsg.getValue("carryout81");
		String carryout_dollar81 = isrvmsg.getValue("carryout_dollar81");
		String carryover81 = isrvmsg.getValue("carryover81");
		String carryovey_dollar81 = isrvmsg.getValue("carryovey_dollar81");
		
		Map map80 = new HashMap();
		if(income_id80!=null){
		map80.put("WEEK_DATE", week_date);
		map80.put("WEEK_END_DATE", week_end_date);
		map80.put("INCOME_ID", income_id80);
		map80.put("ORG_ID", org_id8);
		map80.put("ORG_SUBJECTION_ID", org_subjection_id8);
			map80.put("NEW_SIGN", new_sign80);
			map80.put("NEW_GET", new_get80);
			map80.put("CARRYOUT", carryout80);
			map80.put("CARRYOVER", carryover80);
		map80.put("COUNTRY", country80);
		map80.put("BSFLAG", "0");
		map80.put("SUBFLAG", "0");
		map80.put("ORG_TYPE", "1");
		map80.put("TYPE", "2");
		map80.put("MONDIFY_USER", user.getUserName());
		map80.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map80, "BGP_WR_INCOME_MONEY");
		}
		
		Map map81 = new HashMap();
		if(income_id81!=null){
		map81.put("WEEK_DATE", week_date);
		map81.put("WEEK_END_DATE", week_end_date);
		map81.put("INCOME_ID", income_id81);
		map81.put("ORG_ID", org_id8);
		map81.put("ORG_SUBJECTION_ID", org_subjection_id8);
		map81.put("NEW_SIGN", new_sign81);
			map81.put("NEW_GET", new_get81);
			map81.put("CARRYOUT", carryout81);
			map81.put("CARRYOVER", carryover81);
			map81.put("NEW_GET_DOLLAR", new_get_dollar81);
			map81.put("CARRYOUT_DOLLAR", carryout_dollar81);
			map81.put("CARRYOVEY_DOLLAR", carryovey_dollar81);
		map81.put("COUNTRY", country81);
		map81.put("BSFLAG", "0");
		map81.put("SUBFLAG", "0");
		map81.put("ORG_TYPE", "1");
		map81.put("TYPE", "2");
		map81.put("MONDIFY_USER", user.getUserName());
		map81.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map81, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		String org_id9 = isrvmsg.getValue("org_id9");
		String org_subjection_id9 = isrvmsg.getValue("org_subjection_id9");
		String new_sign90 = isrvmsg.getValue("new_sign90");
		String new_sign91 = isrvmsg.getValue("new_sign91");
		String income_id90 = isrvmsg.getValue("income_id90");
		String country90 = isrvmsg.getValue("country90");
		String new_get90 = isrvmsg.getValue("new_get90");
		String carryout90 = isrvmsg.getValue("carryout90");
		String carryover90 = isrvmsg.getValue("carryover90");
		String income_id91 = isrvmsg.getValue("income_id91");
		String country91 = isrvmsg.getValue("country91");
		String new_get91 = isrvmsg.getValue("new_get91");
		String new_get_dollar91 = isrvmsg.getValue("new_get_dollar91");
		String carryout91 = isrvmsg.getValue("carryout91");
		String carryout_dollar91 = isrvmsg.getValue("carryout_dollar91");
		String carryover91 = isrvmsg.getValue("carryover91");
		String carryovey_dollar91 = isrvmsg.getValue("carryovey_dollar91");
		
		Map map90 = new HashMap();
		if(income_id90!=null){
		map90.put("WEEK_DATE", week_date);
		map90.put("WEEK_END_DATE", week_end_date);
		map90.put("INCOME_ID", income_id90);
		map90.put("ORG_ID", org_id9);
		map90.put("ORG_SUBJECTION_ID", org_subjection_id9);
			map90.put("NEW_GET", new_get90);
			map90.put("NEW_SIGN", new_sign90);
			map90.put("CARRYOUT", carryout90);
			map90.put("CARRYOVER", carryover90);
		map90.put("COUNTRY", country90);
		map90.put("BSFLAG", "0");
		map90.put("SUBFLAG", "0");
		map90.put("ORG_TYPE", "1");
		map90.put("TYPE", "2");
		map90.put("MONDIFY_USER", user.getUserName());
		map90.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map90, "BGP_WR_INCOME_MONEY");
		}
		
		Map map91 = new HashMap();
		if(income_id91!=null){
		map91.put("WEEK_DATE", week_date);
		map91.put("WEEK_END_DATE", week_end_date);
		map91.put("INCOME_ID", income_id91);
		map91.put("ORG_ID", org_id9);
		map91.put("ORG_SUBJECTION_ID", org_subjection_id9);
		map91.put("NEW_SIGN", new_sign91);
			map91.put("NEW_GET", new_get91);
			map91.put("CARRYOUT", carryout91);
			map91.put("CARRYOVER", carryover91);
			map91.put("NEW_GET_DOLLAR", new_get_dollar91);
			map91.put("CARRYOUT_DOLLAR", carryout_dollar91);
			map91.put("CARRYOVEY_DOLLAR", carryovey_dollar91);
		map91.put("COUNTRY", country91);
		map91.put("BSFLAG", "0");
		map91.put("SUBFLAG", "0");
		map91.put("ORG_TYPE", "1");
		map91.put("TYPE", "2");
		map91.put("MONDIFY_USER", user.getUserName());
		map91.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map91, "BGP_WR_INCOME_MONEY");
		}
		
		
		
		String org_id10 = isrvmsg.getValue("org_id10");
		String org_subjection_id10 = isrvmsg.getValue("org_subjection_id10");
		String new_sign100 = isrvmsg.getValue("new_sign100");
		String new_sign101 = isrvmsg.getValue("new_sign101");
		String income_id100 = isrvmsg.getValue("income_id100");
		String country100 = isrvmsg.getValue("country100");
		String new_get100 = isrvmsg.getValue("new_get100");
		String carryout100 = isrvmsg.getValue("carryout100");
		String carryover100 = isrvmsg.getValue("carryover100");
		String income_id101 = isrvmsg.getValue("income_id101");
		String country101 = isrvmsg.getValue("country101");
		String new_get101 = isrvmsg.getValue("new_get101");
		String new_get_dollar101 = isrvmsg.getValue("new_get_dollar101");
		String carryout101 = isrvmsg.getValue("carryout101");
		String carryout_dollar101 = isrvmsg.getValue("carryout_dollar101");
		String carryover101 = isrvmsg.getValue("carryover101");
		String carryovey_dollar101 = isrvmsg.getValue("carryovey_dollar101");
		
		Map map100 = new HashMap();
		if(income_id100!=null){
		map100.put("WEEK_DATE", week_date);
		map100.put("WEEK_END_DATE", week_end_date);
		map100.put("INCOME_ID", income_id100);
		map100.put("ORG_ID", org_id10);
		map100.put("ORG_SUBJECTION_ID", org_subjection_id10);
			map100.put("NEW_SIGN", new_sign100);
			map100.put("NEW_GET", new_get100);
			map100.put("CARRYOUT", carryout100);
			map100.put("CARRYOVER", carryover100);
		map100.put("COUNTRY", country100);
		map100.put("BSFLAG", "0");
		map100.put("SUBFLAG", "0");
		map100.put("ORG_TYPE", "1");
		map100.put("TYPE", "2");
		map100.put("MONDIFY_USER", user.getUserName());
		map100.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map100, "BGP_WR_INCOME_MONEY");
		}
		
		Map map101 = new HashMap();
		if(income_id101!=null){
		map101.put("WEEK_DATE", week_date);
		map101.put("WEEK_END_DATE", week_end_date);
		map101.put("INCOME_ID", income_id101);
		map101.put("ORG_ID", org_id10);
		map101.put("ORG_SUBJECTION_ID", org_subjection_id10);
		map101.put("NEW_SIGN", new_sign101);
			map101.put("NEW_GET", new_get101);
			map101.put("CARRYOUT", carryout101);
			map101.put("CARRYOVER", carryover101);
			map101.put("NEW_GET_DOLLAR", new_get_dollar101);
			map101.put("CARRYOUT_DOLLAR", carryout_dollar101);
			map101.put("CARRYOVEY_DOLLAR", carryovey_dollar101);
		map101.put("COUNTRY", country101);
		map101.put("BSFLAG", "0");
		map101.put("SUBFLAG", "0");
		map101.put("ORG_TYPE", "1");
		map101.put("TYPE", "2");
		map101.put("MONDIFY_USER", user.getUserName());
		map101.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map101, "BGP_WR_INCOME_MONEY");
		}
		
		
		String org_id11 = isrvmsg.getValue("org_id11");
		String org_subjection_id11 = isrvmsg.getValue("org_subjection_id11");
		String new_sign110 = isrvmsg.getValue("new_sign110");
		String new_sign111 = isrvmsg.getValue("new_sign111");
		String income_id110 = isrvmsg.getValue("income_id110");
		String country110 = isrvmsg.getValue("country110");
		String new_get110 = isrvmsg.getValue("new_get110");
		String carryout110 = isrvmsg.getValue("carryout110");
		String carryover110 = isrvmsg.getValue("carryover110");
		String income_id111 = isrvmsg.getValue("income_id111");
		String country111 = isrvmsg.getValue("country111");
		String new_get111 = isrvmsg.getValue("new_get111");
		String new_get_dollar111 = isrvmsg.getValue("new_get_dollar111");
		String carryout111 = isrvmsg.getValue("carryout111");
		String carryout_dollar111 = isrvmsg.getValue("carryout_dollar111");
		String carryover111 = isrvmsg.getValue("carryover111");
		String carryovey_dollar111 = isrvmsg.getValue("carryovey_dollar111");
		
		Map map110 = new HashMap();
		if(income_id110!=null){
		map110.put("WEEK_DATE", week_date);
		map110.put("WEEK_END_DATE", week_end_date);
		map110.put("INCOME_ID", income_id110);
		map110.put("ORG_ID", org_id11);
		map110.put("ORG_SUBJECTION_ID", org_subjection_id11);
			map110.put("NEW_SIGN", new_sign110);
			map110.put("NEW_GET", new_get110);
			map110.put("CARRYOUT", carryout110);
			map110.put("CARRYOVER", carryover110);
		map110.put("COUNTRY", country110);
		map110.put("BSFLAG", "0");
		map110.put("SUBFLAG", "0");
		map110.put("ORG_TYPE", "1");
		map110.put("TYPE", "2");
		map110.put("MONDIFY_USER", user.getUserName());
		map110.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map110, "BGP_WR_INCOME_MONEY");
		}
		
		Map map111 = new HashMap();
		if(income_id111!=null){
		map111.put("WEEK_DATE", week_date);
		map111.put("WEEK_END_DATE", week_end_date);
		map111.put("INCOME_ID", income_id111);
		map111.put("ORG_ID", org_id11);
		map111.put("ORG_SUBJECTION_ID", org_subjection_id11);
		map111.put("NEW_SIGN", new_sign111);
			map111.put("NEW_GET", new_get111);
			map111.put("CARRYOUT", carryout111);
			map111.put("CARRYOVER", carryover111);
			map111.put("NEW_GET_DOLLAR", new_get_dollar111);
			map111.put("CARRYOUT_DOLLAR", carryout_dollar111);
			map111.put("CARRYOVEY_DOLLAR", carryovey_dollar111);
		map111.put("COUNTRY", country111);
		map111.put("BSFLAG", "0");
		map111.put("SUBFLAG", "0");
		map111.put("ORG_TYPE", "1");
		map111.put("TYPE", "2");
		map111.put("MONDIFY_USER", user.getUserName());
		map111.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map111, "BGP_WR_INCOME_MONEY");
		}
		
		String org_id12 = isrvmsg.getValue("org_id12");
		String org_subjection_id12 = isrvmsg.getValue("org_subjection_id12");
		String new_sign120 = isrvmsg.getValue("new_sign120");
		String new_sign121 = isrvmsg.getValue("new_sign121");
		String income_id120 = isrvmsg.getValue("income_id120");
		String country120 = isrvmsg.getValue("country120");
		String new_get120 = isrvmsg.getValue("new_get120");
		String carryout120 = isrvmsg.getValue("carryout120");
		String carryover120 = isrvmsg.getValue("carryover120");
		String income_id121 = isrvmsg.getValue("income_id121");
		String country121 = isrvmsg.getValue("country121");
		String new_get121 = isrvmsg.getValue("new_get121");
		String new_get_dollar121 = isrvmsg.getValue("new_get_dollar121");
		String carryout121 = isrvmsg.getValue("carryout121");
		String carryout_dollar121 = isrvmsg.getValue("carryout_dollar121");
		String carryover121 = isrvmsg.getValue("carryover121");
		String carryovey_dollar121 = isrvmsg.getValue("carryovey_dollar121");
		
		Map map120 = new HashMap();
		if(income_id120!=null){
		map120.put("WEEK_DATE", week_date);
		map120.put("WEEK_END_DATE", week_end_date);
		map120.put("INCOME_ID", income_id120);
		map120.put("ORG_ID", org_id12);
		map120.put("ORG_SUBJECTION_ID", org_subjection_id12);
			map120.put("NEW_SIGN", new_sign120);
			map120.put("NEW_GET", new_get120);
			map120.put("CARRYOUT", carryout120);
			map120.put("CARRYOVER", carryover120);
		map120.put("COUNTRY", country120);
		map120.put("BSFLAG", "0");
		map120.put("SUBFLAG", "0");
		map120.put("ORG_TYPE", "1");
		map120.put("TYPE", "2");
		map120.put("MONDIFY_USER", user.getUserName());
		map120.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map120, "BGP_WR_INCOME_MONEY");
		}
		
		Map map121 = new HashMap();
		if(income_id121!=null){
		map121.put("WEEK_DATE", week_date);
		map121.put("WEEK_END_DATE", week_end_date);
		map121.put("INCOME_ID", income_id121);
		map121.put("ORG_ID", org_id12);
		map121.put("ORG_SUBJECTION_ID", org_subjection_id12);
		map121.put("NEW_SIGN", new_sign121);
			map121.put("NEW_GET", new_get121);
			map121.put("CARRYOUT", carryout121);
			map121.put("CARRYOVER", carryover121);
			map121.put("NEW_GET_DOLLAR", new_get_dollar121);
			map121.put("CARRYOUT_DOLLAR", carryout_dollar121);
			map121.put("CARRYOVEY_DOLLAR", carryovey_dollar121);
		map121.put("COUNTRY", country121);
		map121.put("BSFLAG", "0");
		map121.put("SUBFLAG", "0");
		map121.put("ORG_TYPE", "1");
		map121.put("TYPE", "2");
		map121.put("MONDIFY_USER", user.getUserName());
		map121.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map121, "BGP_WR_INCOME_MONEY");
		}
		
		String org_id13 = isrvmsg.getValue("org_id13");
		String org_subjection_id13 = isrvmsg.getValue("org_subjection_id13");
		String new_sign130 = isrvmsg.getValue("new_sign130");
		String new_sign131 = isrvmsg.getValue("new_sign131");
		String income_id130 = isrvmsg.getValue("income_id130");
		String country130 = isrvmsg.getValue("country130");
		String new_get130 = isrvmsg.getValue("new_get130");
		String carryout130 = isrvmsg.getValue("carryout130");
		String carryover130 = isrvmsg.getValue("carryover130");
		String income_id131 = isrvmsg.getValue("income_id131");
		String country131 = isrvmsg.getValue("country131");
		String new_get131 = isrvmsg.getValue("new_get131");
		String new_get_dollar131 = isrvmsg.getValue("new_get_dollar131");
		String carryout131 = isrvmsg.getValue("carryout131");
		String carryout_dollar131 = isrvmsg.getValue("carryout_dollar131");
		String carryover131 = isrvmsg.getValue("carryover131");
		String carryovey_dollar131 = isrvmsg.getValue("carryovey_dollar131");
		
		Map map130 = new HashMap();
		if(income_id130!=null){
		map130.put("WEEK_DATE", week_date);
		map130.put("WEEK_END_DATE", week_end_date);
		map130.put("INCOME_ID", income_id130);
		map130.put("ORG_ID", org_id13);
		map130.put("ORG_SUBJECTION_ID", org_subjection_id13);
			map130.put("NEW_SIGN", new_sign130);
			map130.put("NEW_GET", new_get130);
			map130.put("CARRYOUT", carryout130);
			map130.put("CARRYOVER", carryover130);
		map130.put("COUNTRY", country130);
		map130.put("BSFLAG", "0");
		map130.put("SUBFLAG", "0");
		map130.put("ORG_TYPE", "1");
		map130.put("TYPE", "2");
		map130.put("MONDIFY_USER", user.getUserName());
		map130.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map130, "BGP_WR_INCOME_MONEY");
		}
		
		Map map131 = new HashMap();
		if(income_id131!=null){
		map131.put("WEEK_DATE", week_date);
		map131.put("WEEK_END_DATE", week_end_date);
		map131.put("INCOME_ID", income_id131);
		map131.put("ORG_ID", org_id13);
		map131.put("ORG_SUBJECTION_ID", org_subjection_id13);
		map131.put("NEW_SIGN", new_sign131);
			map131.put("NEW_GET", new_get131);
			map131.put("CARRYOUT", carryout131);
			map131.put("CARRYOVER", carryover131);
			map131.put("NEW_GET_DOLLAR", new_get_dollar131);
			map131.put("CARRYOUT_DOLLAR", carryout_dollar131);
			map131.put("CARRYOVEY_DOLLAR", carryovey_dollar131);
		map131.put("COUNTRY", country131);
		map131.put("BSFLAG", "0");
		map131.put("SUBFLAG", "0");
		map131.put("ORG_TYPE", "1");
		map131.put("TYPE", "2");
		map131.put("MONDIFY_USER", user.getUserName());
		map131.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map131, "BGP_WR_INCOME_MONEY");
		}
		
		String org_id14 = isrvmsg.getValue("org_id14");
		String org_subjection_id14 = isrvmsg.getValue("org_subjection_id14");
		String new_sign140 = isrvmsg.getValue("new_sign140");
		String new_sign141 = isrvmsg.getValue("new_sign141");
		String income_id140 = isrvmsg.getValue("income_id140");
		String country140 = isrvmsg.getValue("country140");
		String new_get140 = isrvmsg.getValue("new_get140");
		String carryout140 = isrvmsg.getValue("carryout140");
		String carryover140 = isrvmsg.getValue("carryover140");
		String income_id141 = isrvmsg.getValue("income_id141");
		String country141 = isrvmsg.getValue("country141");
		String new_get141 = isrvmsg.getValue("new_get141");
		String new_get_dollar141 = isrvmsg.getValue("new_get_dollar141");
		String carryout141 = isrvmsg.getValue("carryout141");
		String carryout_dollar141 = isrvmsg.getValue("carryout_dollar141");
		String carryover141 = isrvmsg.getValue("carryover141");
		String carryovey_dollar141 = isrvmsg.getValue("carryovey_dollar141");
		
		Map map140 = new HashMap();
		if(income_id140!=null){
		map140.put("WEEK_DATE", week_date);
		map140.put("WEEK_END_DATE", week_end_date);
		map140.put("INCOME_ID", income_id140);
		map140.put("ORG_ID", org_id14);
		map140.put("ORG_SUBJECTION_ID", org_subjection_id14);
			map140.put("NEW_SIGN", new_sign140);
			map140.put("NEW_GET", new_get140);
			map140.put("CARRYOUT", carryout140);
			map140.put("CARRYOVER", carryover140);
		map140.put("COUNTRY", country140);
		map140.put("BSFLAG", "0");
		map140.put("SUBFLAG", "0");
		map140.put("ORG_TYPE", "1");
		map140.put("TYPE", "2");
		map140.put("MONDIFY_USER", user.getUserName());
		map140.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map140, "BGP_WR_INCOME_MONEY");
		}
		
		Map map141 = new HashMap();
		if(income_id141!=null){
		map141.put("WEEK_DATE", week_date);
		map141.put("WEEK_END_DATE", week_end_date);
		map141.put("INCOME_ID", income_id141);
		map141.put("ORG_ID", org_id14);
		map141.put("ORG_SUBJECTION_ID", org_subjection_id14);
		map141.put("NEW_SIGN", new_sign141);
			map141.put("NEW_GET", new_get141);
			map141.put("CARRYOUT", carryout141);
			map141.put("CARRYOVER", carryover141);
			map141.put("NEW_GET_DOLLAR", new_get_dollar141);
			map141.put("CARRYOUT_DOLLAR", carryout_dollar141);
			map141.put("CARRYOVEY_DOLLAR", carryovey_dollar141);
		map141.put("COUNTRY", country141);
		map141.put("BSFLAG", "0");
		map141.put("SUBFLAG", "0");
		map141.put("ORG_TYPE", "1");
		map141.put("TYPE", "2");
		map141.put("MONDIFY_USER", user.getUserName());
		map141.put("MONDIFY_DATE", now);

		pureJdbcDao.saveOrUpdateEntity(map141, "BGP_WR_INCOME_MONEY");
		}
		
		String titleLog = user.getUserName()+"在月市场落实价值工作量中添加了一条月报开始日期为：“"+week_date+"”的信息";
		String operationPlace = "月市场落实价值工作量";
		mg.addLogInfo(titleLog, operationPlace);
		
		return responseDTO;
	}
	
	
	
	// 市场项目明细填报
	public ISrvMsg startProjectDynamic(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String corpId = user.getOrgId();
		String name = user.getOrgName();
		String userId="300";
		String orgId = isrvmsg.getValue("orgId");
		String recordYear = isrvmsg.getValue("recordYear");
		String qwe = isrvmsg.getValue("qwe");
		
		String sql = "select t.org_subjection_id from comm_org_subjection t where t.org_id='"+corpId+"'";
		Map map =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null&&!map.equals("")){
			String orgSubjectionId = map.get("orgSubjectionId").toString();
			if(orgSubjectionId.length()>6){
			String subId = orgSubjectionId.substring(0, 7);
			if(subId.equals("C105005")||subId.equals("C105001")||subId.equals("C105079")){
				if(orgSubjectionId.length()>9){
			   subId = orgSubjectionId.substring(0, 10);
				}
			}
//			if(subId.equals("C105079")){
//			}
			String orgIdSql = "select sm.* from comm_org_subjection o,sm_org sm where o.org_id=sm.bgp_org_id and o.org_subjection_id='"+subId+"'";
			Map orgMap =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(orgIdSql);
			if(orgMap!=null&&!orgMap.equals("")){
				userId = orgMap.get("orgId").toString();//用户组织机构ID
			}
			}
		}
		
		if(orgId==null||orgId.equals("")){
			orgId=userId;
		}
		 Date d = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String year = sdf.format(d).toString().substring(0, 4);
		
		responseDTO.setValue("userId", userId);
		responseDTO.setValue("orgId", orgId);
		if(orgId.equals("300")){
			if(recordYear==null||"".equals(recordYear)){
				recordYear=year;
			}
			String countguoji1 = mg.getCountFromProjecttDynamic("306", "已完成", recordYear);
			String countguoji2 = mg.getCountFromProjecttDynamic("306", "运行中", recordYear);
			String countguoji3 = mg.getCountFromProjecttDynamic("306", "准备启动", recordYear);
			
			String countyanjiuyuan1 = mg.getCountFromProjecttDynamic("180", "已完成", recordYear);
			String countyanjiuyuan2 = mg.getCountFromProjecttDynamic("180", "运行中", recordYear);
			String countyanjiuyuan3 = mg.getCountFromProjecttDynamic("180", "准备启动", recordYear);
			
			String counttalimu1 = mg.getCountFromProjecttDynamic("319", "已完成", recordYear);
			String counttalimu2 = mg.getCountFromProjecttDynamic("319", "运行中", recordYear);
			String counttalimu3 = mg.getCountFromProjecttDynamic("319", "准备启动", recordYear);
			
			String countxinjiang1 = mg.getCountFromProjecttDynamic("320", "已完成", recordYear);
			String countxinjiang2 = mg.getCountFromProjecttDynamic("320", "运行中", recordYear);
			String countxinjiang3 = mg.getCountFromProjecttDynamic("320", "准备启动", recordYear);
			
			String counttuha1 = mg.getCountFromProjecttDynamic("321", "已完成", recordYear);
			String counttuha2 = mg.getCountFromProjecttDynamic("321", "运行中", recordYear);
			String counttuha3 = mg.getCountFromProjecttDynamic("321", "准备启动", recordYear);
			
			String countqinghai1 = mg.getCountFromProjecttDynamic("322", "已完成", recordYear);
			String countqinghai2 = mg.getCountFromProjecttDynamic("322", "运行中", recordYear);
			String countqinghai3 = mg.getCountFromProjecttDynamic("322", "准备启动", recordYear);
			
			String countchangqing1 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f4e7ec00c3", "已完成", recordYear);
			String countchangqing2 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f4e7ec00c3", "运行中", recordYear);
			String countchangqing3 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f4e7ec00c3", "准备启动", recordYear);
			
			String countdagang1 = mg.getCountFromProjecttDynamic("308", "已完成", recordYear);
			String countdagang2 = mg.getCountFromProjecttDynamic("308", "运行中", recordYear);
			String countdagang3 = mg.getCountFromProjecttDynamic("308", "准备启动", recordYear);
			
			String countliaohe1 = mg.getCountFromProjecttDynamic("323", "已完成", recordYear);
			String countliaohe2 = mg.getCountFromProjecttDynamic("323", "运行中", recordYear);
			String countliaohe3 = mg.getCountFromProjecttDynamic("323", "准备启动", recordYear);
			
			String counthuabei1 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f53ff000c4", "已完成", recordYear);
			String counthuabei2 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f53ff000c4", "运行中", recordYear);
			String counthuabei3 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f53ff000c4", "准备启动", recordYear);
			
			String countxinxing1 = mg.getCountFromProjecttDynamic("8ad878cd2d11f476012d2553db8a0435", "已完成", recordYear);
			String countxinxing2 = mg.getCountFromProjecttDynamic("8ad878cd2d11f476012d2553db8a0435", "运行中", recordYear);
			String countxinxing3 = mg.getCountFromProjecttDynamic("8ad878cd2d11f476012d2553db8a0435", "准备启动", recordYear);
			
			String countzonghe1 = mg.getCountFromProjecttDynamic("309", "已完成", recordYear);
			String countzonghe2 = mg.getCountFromProjecttDynamic("309", "运行中", recordYear);
			String countzonghe3 = mg.getCountFromProjecttDynamic("309", "准备启动", recordYear);
			
			String countxinxi1 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb2394b5201aa", "已完成", recordYear);
			String countxinxi2 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb2394b5201aa", "运行中", recordYear);
			String countxinxi3 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb2394b5201aa", "准备启动", recordYear);
			
			String countyingluowa1 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb23bf93801ae", "已完成", recordYear);
			String countyingluowa2 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb23bf93801ae", "运行中", recordYear);
			String countyingluowa3 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb23bf93801ae", "准备启动", recordYear);
			
			String countxian1 = mg.getCountFromProjecttDynamic("123", "已完成", recordYear);
			String countxian2 = mg.getCountFromProjecttDynamic("123", "运行中", recordYear);
			String countxian3 = mg.getCountFromProjecttDynamic("123", "准备启动", recordYear);
			
			responseDTO.setValue("countguoji1", countguoji1);
			responseDTO.setValue("countguoji2", countguoji2);
			responseDTO.setValue("countguoji3", countguoji3);
			
			responseDTO.setValue("countyanjiuyuan1", countyanjiuyuan1);
			responseDTO.setValue("countyanjiuyuan2", countyanjiuyuan2);
			responseDTO.setValue("countyanjiuyuan3", countyanjiuyuan3);
			
			responseDTO.setValue("counttalimu1", counttalimu1);
			responseDTO.setValue("counttalimu2", counttalimu2);
			responseDTO.setValue("counttalimu3", counttalimu3);
			
			responseDTO.setValue("countxinjiang1", countxinjiang1);
			responseDTO.setValue("countxinjiang2", countxinjiang2);
			responseDTO.setValue("countxinjiang3", countxinjiang3);
			
			responseDTO.setValue("counttuha1", counttuha1);
			responseDTO.setValue("counttuha2", counttuha2);
			responseDTO.setValue("counttuha3", counttuha3);
			
			responseDTO.setValue("countqinghai1", countqinghai1);
			responseDTO.setValue("countqinghai2", countqinghai2);
			responseDTO.setValue("countqinghai3", countqinghai3);
			
			responseDTO.setValue("countchangqing1", countchangqing1);
			responseDTO.setValue("countchangqing2", countchangqing2);
			responseDTO.setValue("countchangqing3", countchangqing3);
			
			responseDTO.setValue("countdagang1", countdagang1);
			responseDTO.setValue("countdagang2", countdagang2);
			responseDTO.setValue("countdagang3", countdagang3);
			
			responseDTO.setValue("countliaohe1", countliaohe1);
			responseDTO.setValue("countliaohe2", countliaohe2);
			responseDTO.setValue("countliaohe3", countliaohe3);
			
			responseDTO.setValue("counthuabei1", counthuabei1);
			responseDTO.setValue("counthuabei2", counthuabei2);
			responseDTO.setValue("counthuabei3", counthuabei3);
			
			responseDTO.setValue("countxinxing1", countxinxing1);
			responseDTO.setValue("countxinxing2", countxinxing2);
			responseDTO.setValue("countxinxing3", countxinxing3);
			
			responseDTO.setValue("countzonghe1", countzonghe1);
			responseDTO.setValue("countzonghe2", countzonghe2);
			responseDTO.setValue("countzonghe3", countzonghe3);
			
			
			
			responseDTO.setValue("countxinxi1", countxinxi1);
			responseDTO.setValue("countxinxi2", countxinxi3);
			responseDTO.setValue("countxinxi3", countxinxi3);
			
			responseDTO.setValue("countyingluowa1", countyingluowa1);
			responseDTO.setValue("countyingluowa2", countyingluowa2);
			responseDTO.setValue("countyingluowa3", countyingluowa3);
			
			responseDTO.setValue("countxian1", countxian1);
			responseDTO.setValue("countxian2", countxian2);
			responseDTO.setValue("countxian3", countxian3);
			
			responseDTO.setValue("recordYear", recordYear);
			responseDTO.setValue("strutsForwardName", "successA");
		}else{
			responseDTO.setValue("strutsForwardName", "successB");
		}
		return responseDTO;
	}
	
	public ISrvMsg addProjectDynamic(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		
		String corpId = isrvmsg.getValue("orgId");
		String recordYear = isrvmsg.getValue("recordYear");
		String projectStatus = isrvmsg.getValue("projectStatus");
		String teamNo = isrvmsg.getValue("teamNo");
		String projectType = isrvmsg.getValue("projectType");
		String projectName = isrvmsg.getValue("projectName");
		String truster = isrvmsg.getValue("truster");
		String designWorkload = isrvmsg.getValue("designWorkload");
		String valueWorkload = isrvmsg.getValue("valueWorkload");
		String physicsCount = isrvmsg.getValue("physicsCount");
		String conStatus = isrvmsg.getValue("conStatus");
		String constructionMethod = isrvmsg.getValue("constructionMethod");
		String projectIntroduction = isrvmsg.getValue("projectIntroduction");
		String projectSchedule = isrvmsg.getValue("projectSchedule");
		String problem = isrvmsg.getValue("problem");
		String balance = isrvmsg.getValue("balance");
		Date now = new Date();
		Map map = new HashMap();
		

		Map fileMap1 = new HashMap();
		fileMap1.put("CORP_ID", corpId);
		fileMap1.put("RECORD_YEAR", recordYear);
		fileMap1.put("PROJECT_NAME", projectName);
		fileMap1.put("PROJECT_STATUS", projectStatus);
		fileMap1.put("PROJECT_TYPE", projectType);
		fileMap1.put("TEAM_NO", teamNo);
		fileMap1.put("TRUSTER", truster);
		fileMap1.put("DESIGN_WORKLOAD", designWorkload);
		fileMap1.put("VALUE_WORKLOAD", valueWorkload);
		fileMap1.put("PHYSICS_COUNT", physicsCount);
		fileMap1.put("CONSTRUCTION_METHOD", constructionMethod);
		fileMap1.put("PROJECT_INSTRRODUCTION", projectIntroduction);
		fileMap1.put("PROJECT_SCHEDULE", projectSchedule);
		fileMap1.put("PROBLEM", problem);
		fileMap1.put("BALANCE", balance);
		fileMap1.put("CON_STATUS", conStatus);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");
		
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fileMap1,"MM_PROJECT_DYNAMIC");
		
		String titleLog = user.getUserName()+"在项目明细填报中添加了一条项目名称为：“"+projectName+"”的信息";
		String operationPlace = "项目明细填报";
		mg.addLogInfo(titleLog, operationPlace);
		

		String projectDynamicId = id.toString();
	
		if (projectDynamicId != null && !"".equals(projectDynamicId)) {
			for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			String attachExt = fs.getFilename().substring(fs.getFilename().lastIndexOf(".")+1, fs.getFilename().length());
			Map fileMap = new HashMap();
			fileMap.put("TABLE_NAME", "MM_PROJECT_DYNAMIC");
			fileMap.put("RECORD_ID", projectDynamicId);
			fileMap.put("ATTACH_NAME", fs.getFilename());
			fileMap.put("ATTACH_CONTENT", fs.getFileData());
			fileMap.put("ATTACH_EXT", attachExt);
			fileMap.put("CREATE_DATE", new Date());
			fileMap.put("CREATOR", user.getUserName());
			fileMap.put("MODIFY_DATE", new Date());
			fileMap.put("MODIFIER", user.getUserName());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "COMM_ATTACHMENT");

			}
		}
		return responseDTO;

	}

	public ISrvMsg viewProjectDynamic(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String projectDynamicId = isrvmsg.getValue("projectDynamicId");
		String button = isrvmsg.getValue("button");
		String orgId = isrvmsg.getValue("orgId");
		String back = isrvmsg.getValue("back");
		if(button==null){
			button = "view";
		}
		if(back==null){
			back = "display";
		}

		String sql = "select * from mm_project_dynamic where project_dynamic_id='" + projectDynamicId + "'";
		String sql2 = "select attach_id,attach_name from comm_attachment where bsflag='0' and record_id='"+ projectDynamicId + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		List fileList = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);

		responseDTO.setValue("back", back);
		responseDTO.setValue("orgId", orgId);
		responseDTO.setValue("button", button);
		responseDTO.setValue("map", map);
		responseDTO.setValue("fileList", fileList);
		return responseDTO;
	}


	public ISrvMsg updateProjectDynamic(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> fileList = mqMsg.getFiles();
		
		String projectDynamicId = isrvmsg.getValue("projectDynamicId");
		String corpId = isrvmsg.getValue("orgId");
		String recordYear = isrvmsg.getValue("recordYear");
		String projectStatus = isrvmsg.getValue("projectStatus");
		String teamNo = isrvmsg.getValue("teamNo") == null ? "" : isrvmsg.getValue("teamNo");
		String projectType = isrvmsg.getValue("projectType");
		String projectName = isrvmsg.getValue("projectName");
		String truster = isrvmsg.getValue("truster");
		String designWorkload = isrvmsg.getValue("designWorkload") == null ? "" : isrvmsg.getValue("designWorkload");
		String valueWorkload = isrvmsg.getValue("valueWorkload") == null ? "" : isrvmsg.getValue("valueWorkload");
		String physicsCount = isrvmsg.getValue("physicsCount") == null ? "" : isrvmsg.getValue("physicsCount");
		String conStatus = isrvmsg.getValue("conStatus") == null ? "" : isrvmsg.getValue("conStatus");
		String constructionMethod = isrvmsg.getValue("constructionMethod") == null ? "" : isrvmsg.getValue("constructionMethod");
		String projectIntroduction = isrvmsg.getValue("projectIntroduction") == null ? "" : isrvmsg.getValue("projectIntroduction");
		String projectSchedule = isrvmsg.getValue("projectSchedule") == null ? "" : isrvmsg.getValue("projectSchedule");
		String problem = isrvmsg.getValue("problem") == null ? "" : isrvmsg.getValue("problem");
		String balance = isrvmsg.getValue("balance") == null ? "" : isrvmsg.getValue("balance");
		//删除的附件的attachId（一个数组）
		String deletedFiles = isrvmsg.getValue("deletedFiles");
		if(deletedFiles!=null&&!"".equals(deletedFiles)){
			String del[] = deletedFiles.split(",");
			int len = del.length;
			for(int i=0;i<len ;i++){
				String delSql = "update comm_attachment set bsflag = '1' where attach_id='"+del[i]+"'";
				jdbcTemplate.execute(delSql);
			}
		}
		
		Date now = new Date();
		Map map = new HashMap();
		

		Map fileMap1 = new HashMap();
		
		fileMap1.put("PROJECT_DYNAMIC_ID", projectDynamicId);
		fileMap1.put("CORP_ID", corpId);
		fileMap1.put("RECORD_YEAR", recordYear);
		fileMap1.put("PROJECT_NAME", projectName);
		fileMap1.put("PROJECT_STATUS", projectStatus);
		fileMap1.put("PROJECT_TYPE", projectType);
		fileMap1.put("TEAM_NO", teamNo);
		fileMap1.put("TRUSTER", truster);
		fileMap1.put("DESIGN_WORKLOAD", designWorkload);
		fileMap1.put("VALUE_WORKLOAD", valueWorkload);
		fileMap1.put("PHYSICS_COUNT", physicsCount);
		fileMap1.put("CONSTRUCTION_METHOD", constructionMethod);
		fileMap1.put("PROJECT_INSTRRODUCTION", projectIntroduction);
		fileMap1.put("PROJECT_SCHEDULE", projectSchedule);
		fileMap1.put("PROBLEM", problem);
		fileMap1.put("BALANCE", balance);
		fileMap1.put("CON_STATUS", conStatus);
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fileMap1,"MM_PROJECT_DYNAMIC");
		
		String titleLog = user.getUserName()+"在项目明细填报中修改了一条项目名称为：“"+projectName+"”的信息";
		String operationPlace = "项目明细填报";
		mg.addLogInfo(titleLog, operationPlace);

		if (projectDynamicId != null && !"".equals(projectDynamicId)) {
			for (int i = 0; fileList != null && i < fileList.size(); i++) {
			WSFile fs = fileList.get(i);
			String attachExt = fs.getFilename().substring(fs.getFilename().lastIndexOf(".")+1, fs.getFilename().length());
			Map fileMap = new HashMap();
			fileMap.put("TABLE_NAME", "MM_PROJECT_DYNAMIC");
			fileMap.put("RECORD_ID", projectDynamicId);
			fileMap.put("ATTACH_NAME", fs.getFilename());
			fileMap.put("ATTACH_CONTENT", fs.getFileData());
			fileMap.put("ATTACH_EXT", attachExt);
			fileMap.put("CREATE_DATE", new Date());
			fileMap.put("CREATOR", user.getUserId());
			fileMap.put("MODIFY_DATE", new Date());
			fileMap.put("MODIFIER", user.getUserId());
			fileMap.put("bsflag", "0");
			pureJdbcDao.saveOrUpdateEntity(fileMap, "COMM_ATTACHMENT");

			}
		}
		return responseDTO;
	}
	//页面展示的项目明细
	public ISrvMsg showProjectDynamic(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String recordYear = isrvmsg.getValue("recordYear");
		 Date d = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String year = sdf.format(d).toString().substring(0, 4);
		
		
			if(recordYear==null||"".equals(recordYear)){
				recordYear=year;
			}
			String countguoji1 = mg.getCountFromProjecttDynamic("306", "已完成", recordYear);
			String countguoji2 = mg.getCountFromProjecttDynamic("306", "运行中", recordYear);
			String countguoji3 = mg.getCountFromProjecttDynamic("306", "准备启动", recordYear);
			
			String countyanjiuyuan1 = mg.getCountFromProjecttDynamic("180", "已完成", recordYear);
			String countyanjiuyuan2 = mg.getCountFromProjecttDynamic("180", "运行中", recordYear);
			String countyanjiuyuan3 = mg.getCountFromProjecttDynamic("180", "准备启动", recordYear);
			
			String counttalimu1 = mg.getCountFromProjecttDynamic("319", "已完成", recordYear);
			String counttalimu2 = mg.getCountFromProjecttDynamic("319", "运行中", recordYear);
			String counttalimu3 = mg.getCountFromProjecttDynamic("319", "准备启动", recordYear);
			
			String countxinjiang1 = mg.getCountFromProjecttDynamic("320", "已完成", recordYear);
			String countxinjiang2 = mg.getCountFromProjecttDynamic("320", "运行中", recordYear);
			String countxinjiang3 = mg.getCountFromProjecttDynamic("320", "准备启动", recordYear);
			
			String counttuha1 = mg.getCountFromProjecttDynamic("321", "已完成", recordYear);
			String counttuha2 = mg.getCountFromProjecttDynamic("321", "运行中", recordYear);
			String counttuha3 = mg.getCountFromProjecttDynamic("321", "准备启动", recordYear);
			
			String countqinghai1 = mg.getCountFromProjecttDynamic("322", "已完成", recordYear);
			String countqinghai2 = mg.getCountFromProjecttDynamic("322", "运行中", recordYear);
			String countqinghai3 = mg.getCountFromProjecttDynamic("322", "准备启动", recordYear);
			
			String countchangqing1 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f4e7ec00c3", "已完成", recordYear);
			String countchangqing2 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f4e7ec00c3", "运行中", recordYear);
			String countchangqing3 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f4e7ec00c3", "准备启动", recordYear);
			
			String countdagang1 = mg.getCountFromProjecttDynamic("308", "已完成", recordYear);
			String countdagang2 = mg.getCountFromProjecttDynamic("308", "运行中", recordYear);
			String countdagang3 = mg.getCountFromProjecttDynamic("308", "准备启动", recordYear);
			
			String countliaohe1 = mg.getCountFromProjecttDynamic("323", "已完成", recordYear);
			String countliaohe2 = mg.getCountFromProjecttDynamic("323", "运行中", recordYear);
			String countliaohe3 = mg.getCountFromProjecttDynamic("323", "准备启动", recordYear);
			
			String counthuabei1 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f53ff000c4", "已完成", recordYear);
			String counthuabei2 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f53ff000c4", "运行中", recordYear);
			String counthuabei3 = mg.getCountFromProjecttDynamic("8ad878cd2cf41a23012d02f53ff000c4", "准备启动", recordYear);
			
			String countxinxing1 = mg.getCountFromProjecttDynamic("8ad878cd2d11f476012d2553db8a0435", "已完成", recordYear);
			String countxinxing2 = mg.getCountFromProjecttDynamic("8ad878cd2d11f476012d2553db8a0435", "运行中", recordYear);
			String countxinxing3 = mg.getCountFromProjecttDynamic("8ad878cd2d11f476012d2553db8a0435", "准备启动", recordYear);
			
			String countzonghe1 = mg.getCountFromProjecttDynamic("309", "已完成", recordYear);
			String countzonghe2 = mg.getCountFromProjecttDynamic("309", "运行中", recordYear);
			String countzonghe3 = mg.getCountFromProjecttDynamic("309", "准备启动", recordYear);
			
			String countxinxi1 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb2394b5201aa", "已完成", recordYear);
			String countxinxi2 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb2394b5201aa", "运行中", recordYear);
			String countxinxi3 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb2394b5201aa", "准备启动", recordYear);
			
			String countyingluowa1 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb23bf93801ae", "已完成", recordYear);
			String countyingluowa2 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb23bf93801ae", "运行中", recordYear);
			String countyingluowa3 = mg.getCountFromProjecttDynamic("8ad878cd2e765396012eb23bf93801ae", "准备启动", recordYear);
			
			String countxian1 = mg.getCountFromProjecttDynamic("123", "已完成", recordYear);
			String countxian2 = mg.getCountFromProjecttDynamic("123", "运行中", recordYear);
			String countxian3 = mg.getCountFromProjecttDynamic("123", "准备启动", recordYear);
			
			responseDTO.setValue("countguoji1", countguoji1);
			responseDTO.setValue("countguoji2", countguoji2);
			responseDTO.setValue("countguoji3", countguoji3);
			
			responseDTO.setValue("countyanjiuyuan1", countyanjiuyuan1);
			responseDTO.setValue("countyanjiuyuan2", countyanjiuyuan2);
			responseDTO.setValue("countyanjiuyuan3", countyanjiuyuan3);
			
			responseDTO.setValue("counttalimu1", counttalimu1);
			responseDTO.setValue("counttalimu2", counttalimu2);
			responseDTO.setValue("counttalimu3", counttalimu3);
			
			responseDTO.setValue("countxinjiang1", countxinjiang1);
			responseDTO.setValue("countxinjiang2", countxinjiang2);
			responseDTO.setValue("countxinjiang3", countxinjiang3);
			
			responseDTO.setValue("counttuha1", counttuha1);
			responseDTO.setValue("counttuha2", counttuha2);
			responseDTO.setValue("counttuha3", counttuha3);
			
			responseDTO.setValue("countqinghai1", countqinghai1);
			responseDTO.setValue("countqinghai2", countqinghai2);
			responseDTO.setValue("countqinghai3", countqinghai3);
			
			responseDTO.setValue("countchangqing1", countchangqing1);
			responseDTO.setValue("countchangqing2", countchangqing2);
			responseDTO.setValue("countchangqing3", countchangqing3);
			
			responseDTO.setValue("countdagang1", countdagang1);
			responseDTO.setValue("countdagang2", countdagang2);
			responseDTO.setValue("countdagang3", countdagang3);
			
			responseDTO.setValue("countliaohe1", countliaohe1);
			responseDTO.setValue("countliaohe2", countliaohe2);
			responseDTO.setValue("countliaohe3", countliaohe3);
			
			responseDTO.setValue("counthuabei1", counthuabei1);
			responseDTO.setValue("counthuabei2", counthuabei2);
			responseDTO.setValue("counthuabei3", counthuabei3);
			
			responseDTO.setValue("countxinxing1", countxinxing1);
			responseDTO.setValue("countxinxing2", countxinxing2);
			responseDTO.setValue("countxinxing3", countxinxing3);
			
			responseDTO.setValue("countzonghe1", countzonghe1);
			responseDTO.setValue("countzonghe2", countzonghe2);
			responseDTO.setValue("countzonghe3", countzonghe3);
			
			
			
			responseDTO.setValue("countxinxi1", countxinxi1);
			responseDTO.setValue("countxinxi2", countxinxi3);
			responseDTO.setValue("countxinxi3", countxinxi3);
			
			responseDTO.setValue("countyingluowa1", countyingluowa1);
			responseDTO.setValue("countyingluowa2", countyingluowa2);
			responseDTO.setValue("countyingluowa3", countyingluowa3);
			
			responseDTO.setValue("countxian1", countxian1);
			responseDTO.setValue("countxian2", countxian2);
			responseDTO.setValue("countxian3", countxian3);
			
			responseDTO.setValue("recordYear", recordYear);
		
		return responseDTO;
	}
	
	
	// 市场项目队伍动态
	public ISrvMsg startTeamDynamic(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String corpId = user.getOrgId();
		String name = user.getOrgName();
		String userId="300";
		String orgId = isrvmsg.getValue("orgId");
		String recordYear = isrvmsg.getValue("recordYear");
		String qwe = isrvmsg.getValue("qwe");
		
		String sql = "select t.org_subjection_id from comm_org_subjection t where t.org_id='"+corpId+"'";
		Map map =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		if(map!=null&&!map.equals("")){
			String orgSubjectionId = map.get("orgSubjectionId").toString();
			if(orgSubjectionId.length()>6){
			String subId = orgSubjectionId.substring(0, 7);
			if(subId.equals("C105005")||subId.equals("C105001")||subId.equals("C105079")){
				if(orgSubjectionId.length()>9){
			   subId = orgSubjectionId.substring(0, 10);
				}
			}
//			if(subId.equals("C105079")){
//			}
			String orgIdSql = "select sm.* from comm_org_subjection o,sm_org sm where o.org_id=sm.bgp_org_id and o.org_subjection_id='"+subId+"'";
			Map orgMap =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(orgIdSql);
			if(orgMap!=null&&!orgMap.equals("")){
				userId = orgMap.get("orgId").toString();
			}
			}
		}
		
		if(orgId==null||orgId.equals("")){
			orgId=userId;
		}
		
		responseDTO.setValue("userId", userId);
		responseDTO.setValue("orgId", orgId);
		if(orgId.equals("300")){
		
			String countguoji1 = mg.getCountFromTeamDynamic("306", "在工");
			String countguoji2 = mg.getCountFromTeamDynamic("306", "闲置");
			String countguoji3 = mg.getCountFromTeamDynamic("306", "准备启动");
			
			String countyanjiuyuan1 = mg.getCountFromTeamDynamic("180", "在工");
			String countyanjiuyuan2 = mg.getCountFromTeamDynamic("180", "闲置");
			String countyanjiuyuan3 = mg.getCountFromTeamDynamic("180", "准备启动");
			
			String counttalimu1 = mg.getCountFromTeamDynamic("319", "在工");
			String counttalimu2 = mg.getCountFromTeamDynamic("319", "闲置");
			String counttalimu3 = mg.getCountFromTeamDynamic("319", "准备启动");
			
			String countxinjiang1 = mg.getCountFromTeamDynamic("320", "在工");
			String countxinjiang2 = mg.getCountFromTeamDynamic("320", "闲置");
			String countxinjiang3 = mg.getCountFromTeamDynamic("320", "准备启动");
			
			String counttuha1 = mg.getCountFromTeamDynamic("321", "在工");
			String counttuha2 = mg.getCountFromTeamDynamic("321", "闲置");
			String counttuha3 = mg.getCountFromTeamDynamic("321", "准备启动");
			
			String countqinghai1 = mg.getCountFromTeamDynamic("322", "在工");
			String countqinghai2 = mg.getCountFromTeamDynamic("322", "闲置");
			String countqinghai3 = mg.getCountFromTeamDynamic("322", "准备启动");
			
			String countchangqing1 = mg.getCountFromTeamDynamic("8ad878cd2cf41a23012d02f4e7ec00c3", "在工");
			String countchangqing2 = mg.getCountFromTeamDynamic("8ad878cd2cf41a23012d02f4e7ec00c3", "闲置");
			String countchangqing3 = mg.getCountFromTeamDynamic("8ad878cd2cf41a23012d02f4e7ec00c3", "准备启动");
			
			String countdagang1 = mg.getCountFromTeamDynamic("308", "在工");
			String countdagang2 = mg.getCountFromTeamDynamic("308", "闲置");
			String countdagang3 = mg.getCountFromTeamDynamic("308", "准备启动");
			
			String countliaohe1 = mg.getCountFromTeamDynamic("323", "在工");
			String countliaohe2 = mg.getCountFromTeamDynamic("323", "闲置");
			String countliaohe3 = mg.getCountFromTeamDynamic("323", "准备启动");
			
			String counthuabei1 = mg.getCountFromTeamDynamic("8ad878cd2cf41a23012d02f53ff000c4", "在工");
			String counthuabei2 = mg.getCountFromTeamDynamic("8ad878cd2cf41a23012d02f53ff000c4", "闲置");
			String counthuabei3 = mg.getCountFromTeamDynamic("8ad878cd2cf41a23012d02f53ff000c4", "准备启动");
			
			String countxinxing1 = mg.getCountFromTeamDynamic("8ad878cd2d11f476012d2553db8a0435", "在工");
			String countxinxing2 = mg.getCountFromTeamDynamic("8ad878cd2d11f476012d2553db8a0435", "闲置");
			String countxinxing3 = mg.getCountFromTeamDynamic("8ad878cd2d11f476012d2553db8a0435", "准备启动");
			
			String countzonghe1 = mg.getCountFromTeamDynamic("309", "在工");
			String countzonghe2 = mg.getCountFromTeamDynamic("309", "闲置");
			String countzonghe3 = mg.getCountFromTeamDynamic("309", "准备启动");
			
			String countxinxi1 = mg.getCountFromTeamDynamic("8ad878cd2e765396012eb2394b5201aa", "在工");
			String countxinxi2 = mg.getCountFromTeamDynamic("8ad878cd2e765396012eb2394b5201aa", "闲置");
			String countxinxi3 = mg.getCountFromTeamDynamic("8ad878cd2e765396012eb2394b5201aa", "准备启动");
			
			String countyingluowa1 = mg.getCountFromTeamDynamic("8ad878cd2e765396012eb23bf93801ae", "在工");
			String countyingluowa2 = mg.getCountFromTeamDynamic("8ad878cd2e765396012eb23bf93801ae", "闲置");
			String countyingluowa3 = mg.getCountFromTeamDynamic("8ad878cd2e765396012eb23bf93801ae", "准备启动");
			
			String countxian1 = mg.getCountFromTeamDynamic("123", "在工");
			String countxian2 = mg.getCountFromTeamDynamic("123", "闲置");
			String countxian3 = mg.getCountFromTeamDynamic("123", "准备启动");
			
			responseDTO.setValue("countguoji1", countguoji1);
			responseDTO.setValue("countguoji2", countguoji2);
			responseDTO.setValue("countguoji3", countguoji3);
			
			responseDTO.setValue("countyanjiuyuan1", countyanjiuyuan1);
			responseDTO.setValue("countyanjiuyuan2", countyanjiuyuan2);
			responseDTO.setValue("countyanjiuyuan3", countyanjiuyuan3);
			
			responseDTO.setValue("counttalimu1", counttalimu1);
			responseDTO.setValue("counttalimu2", counttalimu2);
			responseDTO.setValue("counttalimu3", counttalimu3);
			
			responseDTO.setValue("countxinjiang1", countxinjiang1);
			responseDTO.setValue("countxinjiang2", countxinjiang2);
			responseDTO.setValue("countxinjiang3", countxinjiang3);
			
			responseDTO.setValue("counttuha1", counttuha1);
			responseDTO.setValue("counttuha2", counttuha2);
			responseDTO.setValue("counttuha3", counttuha3);
			
			responseDTO.setValue("countqinghai1", countqinghai1);
			responseDTO.setValue("countqinghai2", countqinghai2);
			responseDTO.setValue("countqinghai3", countqinghai3);
			
			responseDTO.setValue("countchangqing1", countchangqing1);
			responseDTO.setValue("countchangqing2", countchangqing2);
			responseDTO.setValue("countchangqing3", countchangqing3);
			
			responseDTO.setValue("countdagang1", countdagang1);
			responseDTO.setValue("countdagang2", countdagang2);
			responseDTO.setValue("countdagang3", countdagang3);
			
			responseDTO.setValue("countliaohe1", countliaohe1);
			responseDTO.setValue("countliaohe2", countliaohe2);
			responseDTO.setValue("countliaohe3", countliaohe3);
			
			responseDTO.setValue("counthuabei1", counthuabei1);
			responseDTO.setValue("counthuabei2", counthuabei2);
			responseDTO.setValue("counthuabei3", counthuabei3);
			
			responseDTO.setValue("countxinxing1", countxinxing1);
			responseDTO.setValue("countxinxing2", countxinxing2);
			responseDTO.setValue("countxinxing3", countxinxing3);
			
			responseDTO.setValue("countzonghe1", countzonghe1);
			responseDTO.setValue("countzonghe2", countzonghe2);
			responseDTO.setValue("countzonghe3", countzonghe3);
			
			
			
			responseDTO.setValue("countxinxi1", countxinxi1);
			responseDTO.setValue("countxinxi2", countxinxi3);
			responseDTO.setValue("countxinxi3", countxinxi3);
			
			responseDTO.setValue("countyingluowa1", countyingluowa1);
			responseDTO.setValue("countyingluowa2", countyingluowa2);
			responseDTO.setValue("countyingluowa3", countyingluowa3);
			
			responseDTO.setValue("countxian1", countxian1);
			responseDTO.setValue("countxian2", countxian2);
			responseDTO.setValue("countxian3", countxian3);
			
			responseDTO.setValue("strutsForwardName", "successA");
		}else{
			responseDTO.setValue("strutsForwardName", "successB");
		}
		return responseDTO;
	}
	
	public ISrvMsg addTeamDynamic(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String corpId = isrvmsg.getValue("orgId");
		String teamNo = isrvmsg.getValue("teamNo");
		String teamStatus = isrvmsg.getValue("teamStatus");
		String workPlace = isrvmsg.getValue("workPlace");
		Date now = new Date();
		

		Map fileMap1 = new HashMap();
		fileMap1.put("CORP_ID", corpId);
		fileMap1.put("TEAM_NO", teamNo);
		fileMap1.put("TEAM_STATUS", teamStatus);
		fileMap1.put("WORK_PLACE", workPlace);
		fileMap1.put("CREATOR", user.getUserName());
		fileMap1.put("CREATE_DATE", now);
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");
		
		pureJdbcDao.saveOrUpdateEntity(fileMap1, "MM_TEAM_DYNAMIC");
//		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fileMap1,"MM_PROJECT_DYNAMIC");
		
		String titleLog = user.getUserName()+"在队伍动态维护中添加了一条作业队号为：“"+teamNo+"”的信息";
		String operationPlace = "队伍动态维护";
		mg.addLogInfo(titleLog, operationPlace);
		
		responseDTO.setValue("orgId", corpId);
		return responseDTO;
	}

	public ISrvMsg viewTeamDynamic(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		int num = 0;
		String userEmpId = user.getEmpId();
		String teamDynamicId = isrvmsg.getValue("teamDynamicId");

		String sql = "select * from mm_team_dynamic where team_dynamic_id='" + teamDynamicId + "'";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);

		responseDTO.setValue("map", map);
		return responseDTO;
	}


	public ISrvMsg updateTeamDynamic(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		
		String teamDynamicId = isrvmsg.getValue("teamDynamicId");
		String corpId = isrvmsg.getValue("orgId");
		String teamNo = isrvmsg.getValue("teamNo");
		String teamStatus = isrvmsg.getValue("teamStatus");
		String workPlace = isrvmsg.getValue("workPlace") ==null ? "" :isrvmsg.getValue("workPlace");
		Date now = new Date();

		Map fileMap1 = new HashMap();
		
		fileMap1.put("TEAM_DYNAMIC_ID", teamDynamicId);
		fileMap1.put("CORP_ID", corpId);
		fileMap1.put("TEAM_NO", teamNo);
		fileMap1.put("TEAM_STATUS", teamStatus);
		fileMap1.put("WORK_PLACE", workPlace);
		fileMap1.put("MODIFIER", user.getUserName());
		fileMap1.put("MODIFY_DATE", now);
		fileMap1.put("BSFLAG", "0");
		
		pureJdbcDao.saveOrUpdateEntity(fileMap1, "MM_TEAM_DYNAMIC");
		
//		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(fileMap1,"MM_PROJECT_DYNAMIC");
		
		String titleLog = user.getUserName()+"在队伍动态维护中修改了一条作业队号为：“"+teamNo+"”的信息";
		String operationPlace = "队伍动态维护";
		mg.addLogInfo(titleLog, operationPlace);

		return responseDTO;
	}
	
	
	//操作日志中的删除部分
	public ISrvMsg logDelete(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		UserToken user = isrvmsg.getUserToken();
		String title =  isrvmsg.getValue("title");
		if (title != null && !"".equals(title)) {
		title = URLDecoder.decode(title, "utf-8");
		}
		String operationPlace = isrvmsg.getValue("operationPlace");
		if (operationPlace != null && !"".equals(operationPlace)) {
			operationPlace = URLDecoder.decode(operationPlace, "utf-8");
			}
		title = user.getUserName()+title;
		mg.addLogInfo(title, operationPlace);
		
		return responseDTO;

	}

	
	//市场市场管理组织机构
//	public ISrvMsg startOrganization(ISrvMsg isrvmsg) throws Exception {
//		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
//		UserToken user = isrvmsg.getUserToken();
//		String userEmpId = user.getEmpId();
//		String corpId = user.getOrgId();
//		String name = user.getOrgName();
//		String userId="10401001";
//		String orgId = isrvmsg.getValue("orgId");
//		
//		String sql = "select t.org_subjection_id from comm_org_subjection t where t.org_id='"+corpId+"'";
//		Map map =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
//		if(map!=null&&!map.equals("")){
//			String orgSubjectionId = map.get("orgSubjectionId").toString();
//			if(orgSubjectionId.length()>6){
//			String subId = orgSubjectionId.substring(0, 7);
//			if(subId.equals("C105005")||subId.equals("C105001")||subId.equals("C105079")){
//				if(orgSubjectionId.length()>9){
//			   subId = orgSubjectionId.substring(0, 10);
//				}
//			}
//			String orgIdSql = "select sm.* from comm_org_subjection o,sm_org sm where o.org_id=sm.bgp_org_id and o.org_subjection_id='"+subId+"'";
//			Map orgMap =BeanFactory.getQueryJdbcDAO().queryRecordBySQL(orgIdSql);
//			if(orgMap!=null&&!orgMap.equals("")){
//				if(orgMap.get("bgpInfomationTypeId")!=null&&!"".equals(orgMap.get("bgpInfomationTypeId"))){
//				userId = orgMap.get("bgpInfomationTypeId").toString();
//				}
//			}
//			}
//		}
//		
//		if(orgId==null||orgId.equals("")){
//			orgId=userId;
//		}
//		
//		responseDTO.setValue("userId", userId);
//		responseDTO.setValue("orgId", orgId);
//		
//		return responseDTO;
//	}
//	public ISrvMsg addOrganization(ISrvMsg isrvmsg) throws Exception {
//		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
//
//		UserToken user = isrvmsg.getUserToken();
//		
//		String orgId = isrvmsg.getValue("orgId");
//		String name = isrvmsg.getValue("name");
//		String duty = isrvmsg.getValue("duty");
//		String officePhone = isrvmsg.getValue("officePhone");
//		String mobilePhone = isrvmsg.getValue("mobilePhone");
//		String email = isrvmsg.getValue("email");
//		String memo = isrvmsg.getValue("memo");
//		String orderNo1 = "";
//		
//		String sql ="select max(to_number(order_no)) as order_no from bgp_market_organization  where bsflag='0' and org_id='"+orgId+"'";
//		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
//		if(map==null&&"".equals(map)){
//			
//		}else{
//			if(map.get("orderNo")==null||map.get("orderNo").equals("")){
//				orderNo1 = "1";
//			}else{
//			String orderNo = (String)map.get("orderNo");
//				int order_no = Integer.parseInt(orderNo)+1;
//				orderNo1 = String.valueOf(order_no);
//			}
//		}
//		
//		Date now = new Date();
//		
//		Map fileMap = new HashMap();
//		fileMap.put("ORG_ID", orgId);
//		fileMap.put("NAME", name);
//		fileMap.put("DUTY", duty);
//		fileMap.put("OFFICE_PHONE", officePhone);
//		fileMap.put("MOBILE_PHONE", mobilePhone);
//		fileMap.put("EMAIL", email);
//		fileMap.put("MEMO", memo);
//		fileMap.put("ORDER_NO", orderNo1);
//		fileMap.put("CREATE_USER", user.getUserName());
//		fileMap.put("CREATE_DATE", now);
//		fileMap.put("MODIFY_USER", user.getUserName());
//		fileMap.put("MODIFY_DATE", now);
//		fileMap.put("BSFLAG", "0");
//		
//		System.out.println(fileMap);
//		
//		pureJdbcDao.saveOrUpdateEntity(fileMap, "BGP_MARKET_ORGANIZATION");
//		
//		String titleLog = user.getUserName()+"在组织机构维护中添加了一条姓名为：“"+name+"”的信息";
//		String operationPlace = "组织机构维护";
//		mg.addLogInfo(titleLog, operationPlace);
//		
//		responseDTO.setValue("orgId", orgId);
//		return responseDTO;
//	}
//
//	public ISrvMsg editOrganization(ISrvMsg isrvmsg) throws Exception {
//		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
//		UserToken user = isrvmsg.getUserToken();
//		int num = 0;
//		String userEmpId = user.getEmpId();
//		String organizationId = isrvmsg.getValue("organizationId");
//
//		String sql = "select * from bgp_market_organization where organization_id='" + organizationId + "'";
//
//		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
//
//		responseDTO.setValue("organizationId", organizationId);
//		responseDTO.setValue("map", map);
//		return responseDTO;
//	}
//
//
//	public ISrvMsg saveOrganization(ISrvMsg isrvmsg) throws Exception {
//		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
//
//		UserToken user = isrvmsg.getUserToken();
//		
//		String organizationId = isrvmsg.getValue("organizationId");
//		String orgId = isrvmsg.getValue("orgId");
//		String name = isrvmsg.getValue("name");
//		String duty = isrvmsg.getValue("duty") == null ? "" : isrvmsg.getValue("duty");
//		String officePhone = isrvmsg.getValue("officePhone") == null ? "" : isrvmsg.getValue("officePhone");
//		String mobilePhone = isrvmsg.getValue("mobilePhone") == null ? "" : isrvmsg.getValue("mobilePhone");
//		String email = isrvmsg.getValue("email") == null ? "" : isrvmsg.getValue("email");
//		String memo = isrvmsg.getValue("memo") == null ? "" : isrvmsg.getValue("memo");
//
//		Date now = new Date();
//		
//		Map map1 = new HashMap();
//		map1.put("ORGANIZATION_ID", organizationId);
//		map1.put("ORG_ID", orgId);
//		map1.put("NAME", name);
//		map1.put("DUTY", duty);
//		map1.put("OFFICE_PHONE", officePhone);
//		map1.put("MOBILE_PHONE", mobilePhone);
//		map1.put("EMAIL", email);
//		map1.put("MEMO", memo);
//		map1.put("MODIFY_USER", user.getUserName());
//		map1.put("MODIFY_DATE", now);
//		map1.put("BSFLAG", "0");
//		
//		pureJdbcDao.saveOrUpdateEntity(map1, "BGP_MARKET_ORGANIZATION");
//		
//		String titleLog = user.getUserName()+"在组织机构维护中修改了一条姓名为：“"+name+"”的信息";
//		String operationPlace = "组织机构维护";
//		mg.addLogInfo(titleLog, operationPlace);
//
//		return responseDTO;
//	}
//	
//	
//	public ISrvMsg organizationOrderSave(ISrvMsg isrvmsg) throws Exception {
//		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
//
//		UserToken user = isrvmsg.getUserToken();
//	
//		String orgId = isrvmsg.getValue("orgId");
//		String organizationId = isrvmsg.getValue("organizationId");
//		String newOrderNo = isrvmsg.getValue("newOrderNo");
//		String orderNo = isrvmsg.getValue("orderNo");
//		int newNo = Integer.parseInt(newOrderNo);
//		int no = Integer.parseInt(orderNo);
//		
//		Date now = new Date();
//
//		Map map1 = new HashMap();
//		map1.put("ORGANIZATION_ID", organizationId);
//		map1.put("ORDER_NO", newOrderNo);
//		map1.put("MODIFY_USER", user.getUserName());
//		map1.put("MODIFY_DATE", now);
//		map1.put("BSFLAG", "0");
//		
//		pureJdbcDao.saveOrUpdateEntity(map1, "BGP_MARKET_ORGANIZATION");
//		
//		if(newNo<no){
//			String sql = "select * from BGP_MARKET_ORGANIZATION where bsflag='0' and org_id='"+orgId+"' and to_number(order_no) > '"+(newNo-1)+"' and to_number(order_no) < '"+no+"' order by to_number(order_no)";
//			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
//			System.out.println("list:"+list);
//			for(int i=0; i<list.size();i++){
//				Map map = (Map)list.get(i);
//				if(!map.get("organizationId").toString().equals(organizationId)){
//					Map fileMap = new HashMap();
//					String order = String.valueOf(Integer.parseInt((String)map.get("orderNo"))+1);
//					fileMap.put("ORGANIZATION_ID",map.get("organizationId").toString()) ;
//					fileMap.put("ORDER_NO",order) ;
//					pureJdbcDao.saveOrUpdateEntity(fileMap, "BGP_MARKET_ORGANIZATION");
//				}
//			}
//		}
//		if(newNo>no){
//			String sql = "select * from BGP_MARKET_ORGANIZATION  where bsflag='0' and org_id='"+orgId+"' and to_number(order_no) > '"+no+"' and to_number(order_no) < '"+(newNo+1)+"' order by order_no";
//			List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
//			System.out.println("list:"+list);
//			for(int i=0; i<list.size();i++){
//				Map map = (Map)list.get(i);
//				if(!map.get("organizationId").toString().equals(organizationId)){
//					Map fileMap = new HashMap();
//					String order = String.valueOf(Integer.parseInt((String)map.get("orderNo"))-1);
//					fileMap.put("ORGANIZATION_ID",map.get("organizationId").toString()) ;
//					fileMap.put("ORDER_NO",order) ;
//					pureJdbcDao.saveOrUpdateEntity(fileMap, "BGP_MARKET_ORGANIZATION");
//				}
//			}
//		}
//		
//		return responseDTO;
//	}
	
//	试验的
//	public ISrvMsg search(ISrvMsg isrvmsg) throws Exception {
//		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
//		UserToken user = isrvmsg.getUserToken();
//		
//		String weekDate = isrvmsg.getValue("week_date");
//		String orgId = isrvmsg.getValue("orgId");
//		String subflag = isrvmsg.getValue("subflag");
//		orgId="C6000000000025";
//
//		String sql="select distinct t.week_date,t.subflag,t.week_end_date  from bgp_wr_income_money t  	 where t.bsflag = '0' and t.org_type='1' and type='1' order by week_date desc";
//		if(weekDate != null){
//			sql=sql+" and week_date=to_date('"+weekDate+"','yyyy-mm-dd') ";
//		}
//		if(subflag != null){
//			sql=sql+" and subflag='"+subflag+"'";
//		}
//		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
//		for(int i=0;i<list.size();i++){
//			Map map = (Map)list.get(i);
//			System.out.println(map);
//		}
//		System.out.println(sql);
//		System.out.println(list);
//		
//		responseDTO.setValue("weekDate", weekDate);
//		responseDTO.setValue("orgId", orgId);
//		responseDTO.setValue("subflag", subflag);
//		responseDTO.setValue("list", list);
//		
//		return responseDTO;
//	}
//	
	
	
}
