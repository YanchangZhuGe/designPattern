package com.bgp.mcs.service.pm.service.project;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class DesignSpsSrv extends BaseService {

	public ISrvMsg saveDesignSps(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String sps_file_no = reqDTO.getValue("sps_file_no");
		String line_group_id = reqDTO.getValue("line_group_id");
		String projectInfoNo = user.getProjectInfoNo();
		String creator = user.getUserName();
	
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		Connection conn = jdbcDao.getDataSource().getConnection();
		PreparedStatement pstmt = null;
		
		if("".equals(sps_file_no) || sps_file_no == null){
			//ÐÂÔö
			sps_file_no = jdbcDao.generateUUID();
			StringBuffer insertSql = new StringBuffer();
			insertSql.append("insert into gp_ops_sps_data(sps_file_no,project_info_no,sps_type,line_group_id,r_data,s_data,x_data,other_file,creator,create_date,modifi_date,bsflag,org_id,org_subjection_id)");
			insertSql.append("values('").append(sps_file_no).append("'");
			insertSql.append(",'").append(projectInfoNo).append("'");
			insertSql.append(",'1','").append(line_group_id).append("',empty_blob(),empty_blob(),empty_blob(),empty_blob()");
			insertSql.append(",'").append(creator).append("',sysdate,sysdate,'0'");
			insertSql.append(",'").append(user.getOrgId()).append("'");
			insertSql.append(",'").append(user.getOrgSubjectionId()).append("')");
			pstmt = conn.prepareStatement(insertSql.toString());
			pstmt.executeUpdate();
		}
		else{ 
			pstmt = conn.prepareStatement("update gp_ops_sps_data set r_data=empty_blob(),s_data=empty_blob(),x_data=empty_blob(),other_file=empty_blob() where sps_file_no='"+sps_file_no+"'");
			pstmt.executeUpdate();
		}
		pstmt = conn.prepareStatement("select r_data,s_data,x_data,other_file from gp_ops_sps_data where sps_file_no='"+sps_file_no+"' for update");
		
		String uploadFileNames = reqDTO.getValue("upload_file_name");
		
		String fileNames[] = uploadFileNames.split("#GMS#");
		String xFileName = null;
		String sFileName = null;
		String rFileName = null;
		String otherFileName = null;
		for(int i=0; i<fileNames.length; i++){
			String fileName = fileNames[i];
			if(fileNames[i].indexOf("X")!=-1){
				xFileName = fileName; 
			} else if(fileNames[i].indexOf("S")!=-1) {
				sFileName = fileName; 
			}else if(fileNames[i].indexOf("R")!=-1) {
				rFileName = fileName; 
			} else {
				otherFileName = fileName; 
			}
		}
		
		ResultSet rset = pstmt.executeQuery();
		if(rset.next()){
			Blob rBlob = rset.getBlob("r_data");
			Blob sBlob = rset.getBlob("s_data");
			Blob xBlob = rset.getBlob("x_data");
			Blob otherBlob = rset.getBlob("other_file");
						
			if(fileNames.length!=0){
				byte[] uploadFile1 = MyUcm.getFileBytes(rFileName, user);
				byte[] uploadFile2 = MyUcm.getFileBytes(sFileName, user);
				byte[] uploadFile3 = MyUcm.getFileBytes(xFileName, user);
				rBlob.setBytes(1, uploadFile1);
				sBlob.setBytes(1, uploadFile2);
				xBlob.setBytes(1, uploadFile3);
				if(fileNames.length == 4){
					byte[] uploadFile4 = MyUcm.getFileBytes(otherFileName, user);
					otherBlob.setBytes(1, uploadFile4);
				}
			}
			pstmt = conn.prepareStatement("update gp_ops_sps_data set r_data=?,s_data=?,x_data=?,other_file=? where sps_file_no='"+sps_file_no+"'");
			
			pstmt.setBlob(1, rBlob);
			pstmt.setBlob(2, sBlob);
			pstmt.setBlob(3, xBlob);
			pstmt.setBlob(4, otherBlob);
			
			pstmt.executeUpdate();
		}
		
		pstmt.close();
		conn.close();
		conn = null;
		
		return msg;
	}
	
	public ISrvMsg getDesignSpsById(ISrvMsg reqDTO) throws Exception{
		String sps_file_no = reqDTO.getValue("spsfileNo");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		StringBuffer sb = new StringBuffer("select sps_file_no,line_group_id,nvl(DBMS_LOB.GETLENGTH(r_data),0) as rsize,nvl(DBMS_LOB.GETLENGTH(s_data),0) as ssize,nvl(DBMS_LOB.GETLENGTH(x_data),0) as xsize,nvl(DBMS_LOB.GETLENGTH(other_file),0) as osize from gp_ops_sps_data where sps_file_no='"+sps_file_no+"'");
		
		Map project = new HashMap();
		project = jdbcDAO.queryRecordBySQL(sb.toString());
		
		if (project != null) {
			msg.setValue("project", project);
		}
		
		return msg;
	}
	
	public ISrvMsg deleteDesignSps(ISrvMsg reqDTO) throws Exception {
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		
		String ids = reqDTO.getValue("spsfileNos");
		String[] objectIds = ids.split(",");
		
		String sql = "update gp_ops_sps_data set bsflag='1'  where bsflag='0' and sps_file_no in(";
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
	
	public ISrvMsg downloadBlobData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String spsfileNo = isrvmsg.getValue("spsfileNo");
		String colName = isrvmsg.getValue("colName");
		
		responseDTO.setValue("spsfileNo", spsfileNo);
		responseDTO.setValue("colName", colName);
		return responseDTO;
	}
	
	public byte[] getBlobContent(String spsfileNo, String colName) throws Exception{
		byte[] content = null;
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		Connection conn = jdbcDao.getDataSource().getConnection();
		PreparedStatement pstmt = null;
		
		if(spsfileNo != null && !"".equals(spsfileNo)){
			pstmt = conn.prepareStatement("select r_data,s_data,x_data,other_file from gp_ops_sps_data where sps_file_no='"+spsfileNo+"'");
			ResultSet rset = pstmt.executeQuery();
			if(rset.next()){
				Blob blob = rset.getBlob(colName);
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
