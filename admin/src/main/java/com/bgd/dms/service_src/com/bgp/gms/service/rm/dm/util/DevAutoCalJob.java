package com.bgp.gms.service.rm.dm.util;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.compress.archivers.ArchiveException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.RowMapper;

import com.bgp.mcs.service.pm.service.bimap.SynBiMapTask;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.util.DateUtil;

public class DevAutoCalJob {

	private ILog log = LogFactory.getLogger(SynBiMapTask.class);
	
	public void autoCalJob(){
		log.info("=======================设备每日统计开始=======================");
		try {
			//统计当前设备台账的状态
			//计算每天各个机构的总的利用率和完好率
			Date da = DateUtil.getCurrentDate();
			final Timestamp d = new Timestamp(da.getTime());
			final Calendar calen = Calendar.getInstance();
			calen.setTime(da);
			    
			//统计在用设备
			StringBuilder sb = new StringBuilder("select sum(wanhao) wh,sum(zaiyong) zy,owning_sub_id,owning_org_id,dev_type");
			sb.append(" from (select decode(tech_stat,'0110000006000000001',1,0) wanhao,");
			sb.append("decode(using_stat,'0110000007000000001',1,0) zaiyong,acc.owning_org_id,acc.owning_sub_id,");
			sb.append("acc.dev_type from gms_device_account_b acc left join GMS_DEVICE_CODEINFO cltype");
			sb.append(" on cltype.dev_ci_code = acc.dev_type left join GMS_DEVICE_COLL_MAPPING mp");
			sb.append(" on mp.dev_ci_code = cltype.dev_ci_code");
			sb.append(" left join GMS_DEVICE_COLLECTINFO ci");
			sb.append(" on ci.device_id = mp.device_id and (ci.dev_code like '10%' or ci.dev_code like '11%' or ci.dev_code like '12%')");
			sb.append("where acc.bsflag='0') group by owning_sub_id,owning_org_id,dev_type");
			
			final RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
			final List<Map<String,Object>> using = jdbcDao.getJdbcTemplate().query(sb.toString(), new RowMapper<Map<String,Object>>(){
				@Override
				public Map<String, Object> mapRow(ResultSet rs, int rowNum)
						throws SQLException {
					Map<String, Object> m = new HashMap<String, Object>();
					m.put("wh", rs.getLong(1));
					m.put("zy", rs.getLong(2));
					m.put("org_sub_id", rs.getString(3));
					m.put("orgid", rs.getString(4));
					m.put("devtype", rs.getString(5));
					return m;
				}});
			if(CollectionUtils.isNotEmpty(using)){
				//批量插入数据库
				String sql = "insert into GMS_DEVICE_RFID_LYLWHL(ID,ORG_ID,SUBORG_ID,CALTIME,CALYEAR,CALMONTH,CALDAY,LYL,WHL,DEV_TYPE) values(?,?,?,?,?,?,?,?,?,?)";
				jdbcDao.getJdbcTemplate().batchUpdate(sql, new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
						ps.setString(1, jdbcDao.generateUUID());
						ps.setString(2, (String) (using.get(i).get("orgid")));
						ps.setString(3, (String) (using.get(i).get("org_sub_id")));
						ps.setTimestamp(4, d);
						ps.setInt(5, calen.get(Calendar.YEAR));
						ps.setInt(6, calen.get(Calendar.MONTH)+1);
						ps.setInt(7, calen.get(Calendar.DAY_OF_MONTH));
						ps.setLong(8, Long.parseLong(using.get(i).get("zy").toString()));
						ps.setLong(9, Long.parseLong(using.get(i).get("wh").toString()));
						ps.setString(10, (String) (using.get(i).get("devtype")));
					}
					@Override
					public int getBatchSize() {
						return using.size();
					}
				});
				
			}
			
		} catch (Exception e) {
			log.error("=======================设备统计发生错误=======================", e);
		}
		log.info("=======================设备每日统计结束=======================");
	}
	
	/**
	 * 生成台账文件
	 */
	public void makeDevAcc(){
		log.info("=======================生成设备台账文件开始=======================");
		String dbFileName = "DATA_ACCOUNT.db";
		Connection conn = null;
		try {
			ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
			String pp = classLoader.getResource("").getPath();
			String realPath = pp.substring(0, pp.lastIndexOf('/'));
			realPath = realPath.substring(0, realPath.lastIndexOf('/'));
			realPath = realPath.substring(0, realPath.lastIndexOf('/'));
			realPath = realPath + "/rm/dm/rfidData/";
			
			//删除目录下的所有文件
			File tmp = new File(realPath);
			if(tmp.exists()){
				File[] files = tmp.listFiles();
				if(files!=null && files.length>0){
					for (File file : files) {
						if(file.exists()){
							if(file.getName().endsWith("zip")){
								file.delete();
							}
						}
					}
				}
			}
			
			/*String filename = FtpUtil.generateFileName()+".zip";
			n = realPath + filename;
			Connection conn = jdbcDao.getDataSource().getConnection();
			conn.setAutoCommit(false);
			PreparedStatement cmd = conn.prepareStatement("SELECT S.DEV_ACC_ID||','||S.DEV_NAME||','||S.DEV_MODEL||','||S.DEV_TYPE||','||c.dev_ci_name||','||s.dev_sign||','||s.project_info_no||','||c.type_seq FROM Gms_Device_Account_b s left join GMS_DEVICE_CODEINFO c on s.dev_type=c.dev_ci_code");
		    cmd.setFetchSize(5000);
		    byte[] sep = System.getProperty("line.separator").getBytes();
		    BufferedOutputStream baos = new BufferedOutputStream(new FileOutputStream(new File(n)));
		    //OutputStream baos = new ByteArrayOutputStream();
		    ZipArchiveOutputStream zipout = (ZipArchiveOutputStream) new ArchiveStreamFactory().createArchiveOutputStream(ArchiveStreamFactory.ZIP, baos);
		    ZipArchiveEntry zip = new ZipArchiveEntry("data.db");
	        zipout.putArchiveEntry(zip);*/
	        conn = makeDBFile(dbFileName, realPath);
            
			/*RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
			Connection conn = null;
			try {
				conn = dao.getDataSource().getConnection();
				conn.setAutoCommit(false);
				PreparedStatement cmd = conn.prepareStatement("SELECT S.DEV_ACC_ID||','||S.DEV_NAME||','||S.DEV_MODEL||','||S.DEV_TYPE||','||c.dev_ci_name||','||s.dev_sign||','||s.project_info_no||','||c.type_seq FROM Gms_Device_Account_b s left join GMS_DEVICE_CODEINFO c on s.dev_type=c.dev_ci_code");
			    cmd.setFetchSize(5000);
			    byte[] sep = System.getProperty("line.separator").getBytes();
			    BufferedOutputStream baos = new BufferedOutputStream(new FileOutputStream(new File("d:/a.gzip")));
			    //OutputStream baos = new ByteArrayOutputStream();
			    ZipArchiveOutputStream zipout = (ZipArchiveOutputStream) new ArchiveStreamFactory().createArchiveOutputStream(ArchiveStreamFactory.ZIP, baos);
			    ZipArchiveEntry zip = new ZipArchiveEntry("data.txt");
		        zipout.putArchiveEntry(zip);
				ResultSet rs = cmd.executeQuery();
		        int byteSum = 0;
		        byte[] b = null;
		        while (rs.next()) {
		            b = rs.getString(1).getBytes();
		            zipout.write(b);
		            zipout.write(sep);
		            byteSum = byteSum + b.length;
		            
					if(byteSum>1024*1024){//缓冲区中数据大于1M，输出
						byteSum = 0;
						zipout.flush();
					}
		        }
		        zipout.closeArchiveEntry();
		        zipout.close();
		        baos.close();
		        return null;
			} catch (Exception e) {
				e.printStackTrace();
			}finally{
				//zipout.closeArchiveEntry();
		        //zipout.close();
		        //baos.close();
			}
			return null;*/
		} catch (Exception e) {
			log.error("=======================生成设备台账文件错误=======================", e);
		} finally {
			try {
				if(conn!=null && !conn.isClosed()){
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		log.info("=======================生成设备台账文件结束=======================");
	}
	
	public Connection makeDBFile(String dbFileName, String realPath) throws FileNotFoundException, ClassNotFoundException, SQLException, ArchiveException, IOException{
		 
		return   new RFIDDevAccount().makeDBFile(dbFileName, realPath); 
	}
}
