package com.bgp.gms.service.rm.dm.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Date;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.commons.compress.archivers.ArchiveException;
import org.springframework.jdbc.core.PreparedStatementSetter;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.util.DateUtil;

public class RFIDDevAccount {

	public Connection makeDBFile(String dbFileName, String realPath) throws ClassNotFoundException, SQLException,
		FileNotFoundException, ArchiveException, IOException {
	//Connection conn;
	RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	//链接SQLite
	final String zipFileName = FtpUtil.generateFileName()+".zip";
	Class.forName("org.sqlite.JDBC");
	Connection sqliteConn = DriverManager.getConnection("jdbc:sqlite://"+realPath+dbFileName);
	Statement stat = sqliteConn.createStatement();
	stat.executeUpdate("drop table if exists GMS_DEVICE_ACCOUNT;");
	StringBuilder sb = new StringBuilder("CREATE TABLE GMS_DEVICE_ACCOUNT (DEV_ACC_ID VARCHAR2(32) NOT NULL,DEV_NAME VARCHAR2(64),DEV_MODEL VARCHAR2(64),");
	sb.append("DEV_TYPE_ID VARCHAR2(24),DEV_SIGN VARCHAR2(32),PROJECT_INFO_NO VARCHAR2(32),PROJECT_INFO_NAME VARCHAR2(64),");
	sb.append("DEV_SEQ VARCHAR2(40),TYPE_SEQ INTEGER,TID VARCHAR2(40),PRODUCTING_DATE DATE,HANDHELD_FLAG INTEGER default 0,CONSTRAINT sqlite_autoindex_GMS_DEVICE_ACCOUNT_1 PRIMARY KEY (DEV_ACC_ID));");
	stat.executeUpdate(sb.toString());
	
	//删除 DEV_TYPE_MAP   创建DEV_TYPE_MAP
	stat.executeUpdate("drop table if exists DEV_TYPE_MAP;");
	StringBuilder sb1 = new StringBuilder("CREATE TABLE DEV_TYPE_MAP (TYPE_SEQ INTEGER NOT NULL,DEV_TYPE_ID VARCHAR2(24),");
	sb1.append("DEVICE_ID VARCHAR2(32),DEVICE_NAME VARCHAR2(255),DEVICE_MODEL VARCHAR2(64),DEV_CI_MODEL VARCHAR2(64)");
	sb1.append(",CONSTRAINT sqlite_autoindex_DEV_TYPE_MAP PRIMARY KEY (TYPE_SEQ));");
	stat.executeUpdate(sb1.toString());
	stat.executeUpdate("CREATE INDEX IDX_DEV_TYPE_MAP_TYPE_SEQ ON DEV_TYPE_MAP (TYPE_SEQ);");
	//结束
	//删除 GMS_DEVICE_ACCOUNT_B   创建GMS_DEVICE_ACCOUNT_B
	stat.executeUpdate("drop table if exists GMS_DEVICE_ACCOUNT_B;");
	StringBuilder sb2 = new StringBuilder("CREATE TABLE GMS_DEVICE_ACCOUNT_B (DEV_ACC_ID VARCHAR2(32) NOT NULL,DEV_NAME VARCHAR2(64),DEV_MODEL VARCHAR2(64),");
	sb2.append("DEV_TYPE_ID VARCHAR2(24),DEV_SIGN VARCHAR2(32),PROJECT_INFO_NO VARCHAR2(32),PROJECT_INFO_NAME VARCHAR2(64),");
	sb2.append("DEV_SEQ VARCHAR2(40),TYPE_SEQ INTEGER,TID VARCHAR2(40),PRODUCTING_DATE DATE,HANDHELD_FLAG INTEGER default 0,CONSTRAINT sqlite_autoindex_GMS_DEVICE_ACCOUNT_B_1 PRIMARY KEY (DEV_ACC_ID));");
	stat.executeUpdate(sb2.toString());
	stat.executeUpdate("CREATE INDEX IDX_GMS_DEVICE_ACCOUNT_B_DEV_SEQ ON GMS_DEVICE_ACCOUNT_B (DEV_SEQ);");
	stat.executeUpdate("CREATE INDEX IDX_GMS_DEVICE_ACCOUNT_B_DEV_SIGN ON GMS_DEVICE_ACCOUNT_B (DEV_SIGN);");
	
	
	//结束
	//sqliteConn.commit();
	//stat.close();
	//String date = DateUtil.getCurrentDateStr("yyyy-MM-dd HH:mm:ss");
	//int count = dao.getJdbcTemplate().queryForInt("select count(*) from gms_device_account_b b where b.modifi_date<to_date('"+date+"','yyyy-mm-dd hh24:mi:ss')");
	
	//stat.executeUpdate("delete from GMS_DEVICE_ACCOUNT");
	//stat.executeUpdate("VACUUM GMS_DEVICE_ACCOUNT");
	PreparedStatement prep = sqliteConn.prepareStatement("insert into GMS_DEVICE_ACCOUNT(DEV_ACC_ID,DEV_NAME,DEV_MODEL,DEV_TYPE_ID,dev_sign,PROJECT_INFO_NO,PROJECT_INFO_NAME,DEV_SEQ,TYPE_SEQ,TID,PRODUCTING_DATE,HANDHELD_FLAG) values(?,?,?,?,?,?,?,?,?,?,?,?)");
	Connection conn = dao.getDataSource().getConnection();
	PreparedStatement cmd = conn.prepareStatement(" SELECT S.DEV_ACC_ID,S.DEV_NAME,S.DEV_MODEL,S.DEV_TYPE,s.dev_sign,nvl2(s.project_info_no,s.project_info_no,''),nvl2(p.project_name,p.project_name,''),rfid.epc_code,c.type_seq,rf.tagid,s.producting_date,0 as Handheld_Flag FROM Gms_Device_Account_b s left join GMS_DEVICE_RFID rfid on s.dev_acc_id=rfid.dev_acc_id and rfid.bsflag='0' left join GMS_DEVICE_CODEINFO c on s.dev_type=c.dev_ci_code left join GP_TASK_PROJECT p on s.project_info_no=p.project_info_no left join (select distinct tagid,dev_acc_id from GMS_DEVICE_RFID where bsflag='0'  )  rf  on s.dev_acc_id=rf.dev_acc_id where dev_name like '%采集站%' union SELECT S.DEV_ACC_ID,S.DEV_NAME,S.DEV_MODEL,S.DEV_TYPE,s.dev_sign,nvl2(s.project_info_no,s.project_info_no,''),nvl2(p.project_name,p.project_name,''),rfid.epc_code,c.type_seq,rf.tagid,s.producting_date,0 as Handheld_Flag FROM Gms_Device_Account s left join GMS_DEVICE_RFID rfid on s.dev_acc_id=rfid.dev_acc_id and rfid.bsflag='0' left join GMS_DEVICE_CODEINFO c on s.dev_type=c.dev_ci_code left join GP_TASK_PROJECT p on s.project_info_no=p.project_info_no left join (select distinct tagid,dev_acc_id from GMS_DEVICE_RFID where bsflag='0'  )  rf  on s.dev_acc_id=rf.dev_acc_id where dev_name like '%采集站%' ");
	cmd.setFetchSize(10000);
	ResultSet rs = cmd.executeQuery();
	int commitCount = 0;
	sqliteConn.setAutoCommit(false);
	while (rs.next()) {
		prep.setString(1, rs.getString(1));
		prep.setString(2, rs.getString(2));
		prep.setString(3, rs.getString(3));
		prep.setString(4, rs.getString(4));
		prep.setString(5, rs.getString(5));
		prep.setString(6, rs.getString(6));
		prep.setString(7, rs.getString(7));
		prep.setString(8, rs.getString(8));
		prep.setString(9, rs.getString(9));
		prep.setString(10, rs.getString(10));
		if(rs.getDate(11)!=null){
			prep.setString(11, DateUtil.convertDateToString(rs.getDate(11),"yyyy-MM-dd"));
		}else{
			prep.setString(11, null);
		}
		prep.setString(12, rs.getString(12));
		prep.addBatch();
		//prep.clearParameters();
		if( ++commitCount > 30000 ){
			commitCount = 0;
			prep.executeBatch();
			//sqliteConn.commit();
		}
	}
	prep.executeBatch();
	//sqliteConn.commit();
	sqliteConn.setAutoCommit(true);
	
	//
	stat.executeUpdate("CREATE INDEX IDX_GMS_DEVICE_ACCOUNT_DEV_SEQ ON GMS_DEVICE_ACCOUNT (DEV_SEQ);");
	stat.executeUpdate("CREATE INDEX IDX_GMS_DEVICE_ACCOUNT_DEV_SIGN ON GMS_DEVICE_ACCOUNT (DEV_SIGN);");
	
	
	/**
	 * 下载映射关系 --开始
	 */
	
	
	
	//sqliteConn.commit();
	//stat.close();
	//String date = DateUtil.getCurrentDateStr("yyyy-MM-dd HH:mm:ss");
	//int count = dao.getJdbcTemplate().queryForInt("select count(*) from gms_device_account_b b where b.modifi_date<to_date('"+date+"','yyyy-mm-dd hh24:mi:ss')");
	
	//stat.executeUpdate("delete from GMS_DEVICE_ACCOUNT");
	//stat.executeUpdate("VACUUM GMS_DEVICE_ACCOUNT");
	 prep = sqliteConn.prepareStatement("insert into DEV_TYPE_MAP(TYPE_SEQ,DEV_TYPE_ID,DEVICE_ID, DEVICE_NAME,DEVICE_MODEL,DEV_CI_MODEL) values(?,?,?,?,?,?)");
	 conn = dao.getDataSource().getConnection();
	 cmd = conn.prepareStatement("select cltype.type_seq,cltype.dev_ci_code dev_type_id,ct.device_id,ct.dev_name,ct.dev_model,cltype.dev_ci_model,cltype.dev_ci_name dev_type_name from  GMS_DEVICE_CODEINFO cltype join GMS_DEVICE_COLL_MAPPING mp on mp.dev_ci_code=cltype.dev_ci_code join GMS_DEVICE_COLLECTINFO ct on ct.device_id=mp.device_id and ct.node_level=3 ");
	cmd.setFetchSize(10000);
	 rs = cmd.executeQuery();
	 commitCount = 0;
	sqliteConn.setAutoCommit(false);
	while (rs.next()) {
		prep.setInt(1, rs.getInt(1));
		prep.setString(2, rs.getString(2));
		prep.setString(3, rs.getString(3));
		prep.setString(4, rs.getString(4));
		prep.setString(5, rs.getString(5));
		prep.setString(6, rs.getString(6));
		prep.addBatch();
		//prep.clearParameters();
		if( ++commitCount > 30000 ){
			commitCount = 0;
			prep.executeBatch();
			//sqliteConn.commit();
		}
	}
	prep.executeBatch();
	//sqliteConn.commit();
	sqliteConn.setAutoCommit(true);
	
	//
	//stat.executeUpdate("CREATE INDEX IDX_GMS_DEVICE_ACCOUNT_DEV_SEQ ON GMS_DEVICE_ACCOUNT (DEV_SEQ);");
	//stat.executeUpdate("CREATE INDEX IDX_GMS_DEVICE_ACCOUNT_DEV_SIGN ON GMS_DEVICE_ACCOUNT (DEV_SIGN);");
	
	/**
	 * 下载映射关系结束
	 */
	
	
	
	
	
	
	
	
	sqliteConn.close();
	conn.close();
	
	//
	FileOutputStream f = new FileOutputStream(realPath+zipFileName);
	//CheckedOutputStream csum = new CheckedOutputStream(f, new CRC32());
	ZipOutputStream out = new ZipOutputStream(new BufferedOutputStream(f));
	out.setComment("RFID handheld data file,create by:"+DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd hh-mm-ss"));
	
	// now adding files ? any number with putNextEntry() method
	//BufferedReader in = new BufferedReader( new FileReader(realPath+dbFileName));
	File srcFile = new File(realPath+dbFileName);
	BufferedInputStream is = new BufferedInputStream(new FileInputStream(srcFile));
	out.putNextEntry(new ZipEntry(dbFileName));
	int byteSum = 0;
	byte[] b = new byte[409600];
	while (is.read(b)!=-1) {
		out.write(b);
	    byteSum = byteSum + b.length;
		if(byteSum>4096000){//缓冲区中数据大于4M，输出
			byteSum = 0;
			out.flush();
		}
	}
	is.close();
	out.closeEntry();
	out.close();
	srcFile.delete();
	
	//数据文件写入压缩文件
	/*BufferedOutputStream baos = new BufferedOutputStream(new FileOutputStream(new File(realPath+zipFileName)));
	File srcFile = new File(realPath+dbFileName);
	BufferedInputStream is = new BufferedInputStream(new FileInputStream(srcFile));
	ZipArchiveOutputStream zipout = (ZipArchiveOutputStream) new ArchiveStreamFactory().createArchiveOutputStream(ArchiveStreamFactory.ZIP, baos);
	ZipArchiveEntry zip = new ZipArchiveEntry(dbFileName);
	zipout.putArchiveEntry(zip);
	int byteSum = 0;
	byte[] b = new byte[102400];
	while (is.read(b)!=-1) {
	    zipout.write(b);
	    byteSum = byteSum + b.length;
		if(byteSum>1024*1024){//缓冲区中数据大于1M，输出
			byteSum = 0;
			zipout.flush();
		}
	}
	zipout.closeArchiveEntry();
	zipout.close();
	zipout = null;
	baos.close();
	is.close();
	srcFile.delete();*/
	
	//记录生成的文件
	String sql = "insert into GMS_DEVICE_JOBLOG(id,FILENAME,OPT_DATE) values(?,?,?)";
	String delsql = "delete from GMS_DEVICE_JOBLOG";
	dao.getJdbcTemplate().update(delsql);
	dao.getJdbcTemplate().update(sql, new PreparedStatementSetter(){
		@Override
		public void setValues(PreparedStatement ps) throws SQLException {
			ps.setString(1, UUID.randomUUID().toString().replaceAll("-", ""));
			ps.setString(2, zipFileName);
			ps.setTimestamp(3, new Timestamp(new Date().getTime()));
		}});
	return conn;
	}
}
