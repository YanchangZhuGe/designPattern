package com.bgp.mcs.service.pm.service.project;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class DeployDiagramSrv  extends BaseService {
	
	public ISrvMsg saveDeployDiagram(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String deploy_name = reqDTO.getValue("deploy_name");
		String projectInfoNo = reqDTO.getValue("project_info_no");
		
		String creator = user.getUserId();
		
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		Connection conn = jdbcDao.getDataSource().getConnection();
		PreparedStatement pstmt = null;
		
		//ÐÂÔö
		String object_id = jdbcDao.generateUUID();
		StringBuffer insertSql = new StringBuffer();
		insertSql.append("insert into gp_project_deployment(object_id,project_info_no,deploy_name,image_content,creator_id,create_date,bsflag)");
		insertSql.append("values('").append(object_id).append("'");
		insertSql.append(",'").append(projectInfoNo).append("'");
		insertSql.append(",'").append(deploy_name).append("',empty_blob()");
		insertSql.append(",'").append(creator).append("',sysdate,'0')");
		pstmt = conn.prepareStatement(insertSql.toString());
		pstmt.executeUpdate();
		
		pstmt = conn.prepareStatement("select image_content from gp_project_deployment where object_id='"+object_id+"' for update");
		
		ResultSet rset = pstmt.executeQuery();
		if(rset.next()){
			Blob fileBlob = rset.getBlob("image_content");
						
			if(fileList.size()!=0){
				WSFile uploadFile1 = fileList.get(0);
				fileBlob.setBytes(1, uploadFile1.getFileData());
			}
			pstmt = conn.prepareStatement("update gp_project_deployment set image_content=? where object_id='"+object_id+"'");
			
			pstmt.setBlob(1, fileBlob);
			
			pstmt.executeUpdate();
		}
		
		pstmt.close();
		conn.close();
		conn = null;
		
		return msg;
	}
	
	public ISrvMsg deleteDeployDiagram(ISrvMsg reqDTO) throws Exception {
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		
		String ids = reqDTO.getValue("objectIds");
		String[] objectIds = ids.split(",");
		
		String sql = "update gp_project_deployment set bsflag='1'  where bsflag='0' and object_id in(";
		for (int i = 0; i < objectIds.length; i++) {
			sql += "'"+objectIds[i] +"',";
		}
		
		sql = sql.substring(0, sql.lastIndexOf(","));
		sql += ")";
		jdbcTemplate.execute(sql);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("ActionStatus","ok");
		return msg;
	}
	
	public ISrvMsg viewDeployDiagram(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String object_id = isrvmsg.getValue("object_id");
		
		responseDTO.setValue("object_id", object_id);
		return responseDTO;
	}
	
	public byte[] getBlobContent(String object_id) throws Exception{
		byte[] content = null;
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		Connection conn = jdbcDao.getDataSource().getConnection();
		PreparedStatement pstmt = null;
		
		if(object_id != null && !"".equals(object_id)){
			pstmt = conn.prepareStatement("select image_content from gp_project_deployment where object_id='"+object_id+"'");
			ResultSet rset = pstmt.executeQuery();
			if(rset.next()){
				Blob blob = rset.getBlob("image_content");
				InputStream in = blob.getBinaryStream();
				
				ByteArrayOutputStream outStream = new ByteArrayOutputStream();  
		        byte[] data = new byte[4096];
		
		        int count = 0;
		         while((count = in.read(data,0,data.length)) != -1){
		        	 outStream.write(data, 0, count);
		         }
		        data = null;
		        in.close();
		        content = outStream.toByteArray();
			}
			pstmt.close();
		}
		conn.close();
		conn = null;
		return content;
	}
}
