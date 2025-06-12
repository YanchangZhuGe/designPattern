package com.bgp.gms.service.rm.dm.util;

import java.io.File;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.RowMapper;

import com.bgp.gms.service.rm.dm.DevCommInfoSrv;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.SpringFactory;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.util.DateUtil;
import com.cnpc.sais.ibp.auth2.util.PasswordUtil;

public class DevRFIDWebSrvImpl implements DevRFIDWebSrv {

	ILog logger = LogFactory.getLogger(DevRFIDWebSrvImpl.class);
	
	@Override
	public String createDevAccountDataFile()  {
		logger.info("客户端开始调用createDevAccountDataFile方法");
		Connection conn = null;
		try{
			RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
			List<Map<String, String>> m = getFileName(dao);
			String dbFileName = "DATA_ACCOUNT.db";
			ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
			String pp = classLoader.getResource("").getPath();
			String realPath = pp.substring(0, pp.lastIndexOf('/'));
			realPath = realPath.substring(0, realPath.lastIndexOf('/'));
			realPath = realPath.substring(0, realPath.lastIndexOf('/'));
			realPath = realPath + "/rm/dm/rfidData/";
			if(CollectionUtils.isNotEmpty(m)){
				String fn = m.get(0).get("filename");
				File f = new File(realPath+fn);
				if(f.exists()){
					logger.info("客户端结束调用createDevAccountDataFile方法");
					return fn;
				}else{
					//生成文件
					DevAutoCalJob job = (DevAutoCalJob) SpringFactory.getBean("devCalTask");
					conn = job.makeDBFile(dbFileName, realPath);
					m = getFileName(dao);
					logger.info("客户端结束调用createDevAccountDataFile方法");
					return m.get(0).get("filename");
				}
			}else{
				//生成文件
				DevAutoCalJob job = (DevAutoCalJob) SpringFactory.getBean("devCalTask");
				conn = job.makeDBFile(dbFileName, realPath);
				m = getFileName(dao);
				logger.info("客户端结束调用createDevAccountDataFile方法");
				return m.get(0).get("filename");
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
		/*Long start = System.currentTimeMillis();
		ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
		String pp = classLoader.getResource("").getPath();
		String realPath = pp.substring(0, pp.lastIndexOf('/'));
		realPath = realPath.substring(0, realPath.lastIndexOf('/'));
		realPath = realPath.substring(0, realPath.lastIndexOf('/'));
		realPath = realPath + "/rm/dm/rfidData/";
		
        //链接SQLite
		String dbFileName = "DATA_ACCOUNT.db";
		Connection conn = null;
        try {
        	String zipFileName = FtpUtil.generateFileName()+".zip";
        	Class.forName("org.sqlite.JDBC");
            Connection sqliteConn = DriverManager.getConnection("jdbc:sqlite://"+realPath+dbFileName);
            Statement stat = sqliteConn.createStatement();
            stat.executeUpdate("drop table if exists GMS_DEVICE_ACCOUNT;");
            StringBuilder sb = new StringBuilder("CREATE TABLE GMS_DEVICE_ACCOUNT (DEV_ACC_ID VARCHAR2(32) NOT NULL,DEV_NAME VARCHAR2(64),DEV_MODEL VARCHAR2(64),");
            sb.append("DEV_TYPE_ID VARCHAR2(24),DEV_TYPE_NAME VARCHAR2(64),DEV_SIGN VARCHAR2(32),PROJECT_INFO_NO VARCHAR2(32),PROJECT_INFO_NAME VARCHAR2(64),");
            sb.append("DEV_SEQ NUMERIC(8),TYPE_SEQ NUMERIC(6),CONSTRAINT sqlite_autoindex_GMS_DEVICE_ACCOUNT_1 PRIMARY KEY (DEV_ACC_ID));");
            stat.executeUpdate(sb.toString());
            stat.executeUpdate("CREATE INDEX IDX_GMS_DEVICE_ACCOUNT_DEV_SEQ ON GMS_DEVICE_ACCOUNT (DEV_SEQ);");
            stat.executeUpdate("CREATE INDEX IDX_GMS_DEVICE_ACCOUNT_DEV_SIGN ON GMS_DEVICE_ACCOUNT (DEV_SIGN);");
            
            //stat.executeUpdate("delete from GMS_DEVICE_ACCOUNT");
            //stat.executeUpdate("VACUUM GMS_DEVICE_ACCOUNT");
            PreparedStatement prep = sqliteConn.prepareStatement("insert into GMS_DEVICE_ACCOUNT(DEV_ACC_ID,DEV_NAME,DEV_MODEL,DEV_TYPE,dev_ci_name,dev_sign,PROJECT_INFO_NO,PROJECT_INFO_NAME,DEV_SEQ,TYPE_SEQ) values(?,?,?,?,?,?,?,?,?,?)");
        	conn = dao.getDataSource().getConnection();
        	PreparedStatement cmd = conn.prepareStatement("SELECT S.DEV_ACC_ID,S.DEV_NAME,S.DEV_MODEL,S.DEV_TYPE,c.dev_ci_name,s.dev_sign,nvl2(s.project_info_no,s.project_info_no,''),nvl2(p.project_name,p.project_name,''),s.dev_seq,c.type_seq FROM Gms_Device_Account_b s left join GMS_DEVICE_CODEINFO c on s.dev_type=c.dev_ci_code left join GP_TASK_PROJECT p on s.project_info_no=p.project_info_no");
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
            	prep.addBatch();
    			if( ++commitCount > 10000 ){
    				commitCount = 0;
    				prep.executeBatch();
    			}
            }
            prep.executeBatch();
            sqliteConn.commit();
            sqliteConn.setAutoCommit(true);
            sqliteConn.close();
            conn.close();
            
            //数据文件写入压缩文件
            BufferedOutputStream baos = new BufferedOutputStream(new FileOutputStream(new File(realPath+zipFileName)));
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
            srcFile.delete();
            Long end = System.currentTimeMillis();
            logger.info(start+":"+end+":总耗时："+(end-start)/1000);*/
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("获取设备台账服务调用发生异常",e);
		} finally {
			try {
				if(conn!=null && !conn.isClosed()){
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
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
		return null;
	}

	private List<Map<String, String>> getFileName(RADJdbcDao dao) {
		String sql = "select t.filename from GMS_DEVICE_JOBLOG t";
		List<Map<String,String>> m = dao.getJdbcTemplate().query(sql, new RowMapper<Map<String,String>>(){
			@Override
			public Map<String,String> mapRow(ResultSet rs, int rowNum) throws SQLException {
				Map<String,String> t = new HashMap<String,String>();
				t.put("filename", rs.getString(1));
				return t;
			}});
		return m;
	}
	
	@Override
	public UserInfo clientLogin(String username, String password) {
		logger.info(StringUtil.wrapString("客户端开始调用clientLogin方法，参数为：",username));
		StringBuilder sql = new StringBuilder("select t.user_name,t.user_id,t.org_id,o.org_name,o.org_type,");
		sql.append("o.org_abbreviation,o.org_desc,o.org_level,o.locked_if from P_AUTH_USER t join ");
		sql.append(" COMM_ORG_INFORMATION o on t.org_id=o.org_id where t.login_id=? and t.user_pwd=? and t.user_status='0'");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<UserInfo> m = dao.getJdbcTemplate().query(sql.toString(), new Object[]{username,PasswordUtil.encrypt(password)},new RowMapper<UserInfo>(){
			@Override
			public UserInfo mapRow(ResultSet rs, int rowNum) throws SQLException {
				UserInfo m = new UserInfo();
				m.setUser_name(rs.getString(1));
				m.setUser_id(rs.getString(2));
				m.setOrg_id(rs.getString(3));
				m.setOrg_name(rs.getString(4));
				m.setOrg_type(rs.getString(5));
				m.setOrg_abbreviation(rs.getString(6));
				m.setOrg_desc(rs.getString(7));
				m.setOrg_level(rs.getString(8));
				m.setLocked_if(rs.getString(9));
				return m;
			}});
		logger.info(StringUtil.wrapString("客户端结束调用clientLogin方法，参数为：",username));
		if(CollectionUtils.isEmpty(m)){
			return null;
		}else{
			return m.get(0);
		}
	}

	@Override
	public List<DevTypeMapping> getDevTypeMapping() {
		logger.info("客户端开始调用getDevTypeMapping方法");
		StringBuilder sql = new StringBuilder("select ct.device_id,cltype.type_seq,ct.dev_name,ct.dev_model,");
		sql.append("cltype.dev_ci_name dev_type_name,cltype.dev_ci_code dev_type_id,cltype.dev_ci_unit from ");
		sql.append(" GMS_DEVICE_CODEINFO cltype join GMS_DEVICE_COLL_MAPPING mp on mp.dev_ci_code=cltype.dev_ci_code ");
		sql.append("join GMS_DEVICE_COLLECTINFO ct on ct.device_id=mp.device_id and ct.node_level=3 ");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<DevTypeMapping> l = dao.getJdbcTemplate().query(sql.toString(),new RowMapper<DevTypeMapping>(){

			@Override
			public DevTypeMapping mapRow(ResultSet rs, int rowNum) throws SQLException {
				DevTypeMapping mp = new DevTypeMapping();
				mp.setDevice_id(rs.getString(1));
				mp.setType_seq(rs.getInt(2));
				mp.setDevice_name(rs.getString(3));
				mp.setDevice_model(rs.getString(4));
				mp.setDev_type_name(rs.getString(5));
				mp.setDev_type_id(rs.getString(6));
				return mp;
			}});
		logger.info("结束调用getDevTypeMapping方法");
		if(CollectionUtils.isEmpty(l)){
			l = null;
		}
		return l;
	}

	@Override
	public void deleteDevAccountDataFile(String filename) {
		logger.info(StringUtil.wrapString("客户端开始调用deleteDevAccountDataFile方法，参数为：",filename));
		/*ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
		String pp = classLoader.getResource("").getPath();
		String realPath = pp.substring(0, pp.lastIndexOf('/'));
		realPath = realPath.substring(0, realPath.lastIndexOf('/'));
		realPath = realPath.substring(0, realPath.lastIndexOf('/'));
		realPath = realPath + "/rm/dm/rfidData/";
		new File(realPath + filename).delete();*/
		logger.info(StringUtil.wrapString("客户端结束调用deleteDevAccountDataFile方法，参数为：",filename));
	}

	@Override
	public List<RFIDDevOutFormDTO> downloadOutForm(String orgid) {
		logger.info(StringUtil.wrapString("客户端开始调用downloadOutForm方法，参数为：",orgid));
		StringBuilder sql = new StringBuilder("select o1.org_abbreviation org,o2.org_abbreviation in_org,o3.org_abbreviation out_org,");
		sql.append("t.project_info_no,p.project_name,t.device_outinfo_id bill_id,t.outinfo_no,t.state,");
		sql.append("t.opr_state,t.devouttype,t.create_date,c.user_name creator_id,t.modifi_date,u.user_name updator_id,t.bsflag ");
		sql.append(" from GMS_DEVICE_COLL_OUTFORM t join COMM_ORG_INFORMATION o1 on t.org_id=o1.org_id ");
		sql.append(" join COMM_ORG_INFORMATION o2 on t.in_org_id=o2.org_id join COMM_ORG_INFORMATION o3 on t.out_org_id=o3.org_id");
		sql.append(" join GP_TASK_PROJECT p on p.project_info_no=t.project_info_no ");
		sql.append(" join P_AUTH_USER c on t.creator_id=c.emp_id join P_AUTH_USER u on t.updator_id=u.emp_id ");
		sql.append(" where t.state!=9 and t.out_org_id=? ");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		//List<Map<String, Object>> l = dao.getJdbcTemplate().queryForList(sql.toString(), orgid);
		List<RFIDDevOutFormDTO> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{orgid}, new RowMapper<RFIDDevOutFormDTO>(){
			@Override
			public RFIDDevOutFormDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
				RFIDDevOutFormDTO d = new RFIDDevOutFormDTO();
				d.setOrg(StringUtils.isBlank(rs.getString(1))?"":rs.getString(1));
				d.setIn_org(StringUtils.isBlank(rs.getString(2))?"":rs.getString(2));
				d.setOut_org(StringUtils.isBlank(rs.getString(3))?"":rs.getString(3));
				d.setProject_info_no(StringUtils.isBlank(rs.getString(4))?"":rs.getString(4));
				d.setProject_name(StringUtils.isBlank(rs.getString(5))?"":rs.getString(5));
				d.setBill_id(StringUtils.isBlank(rs.getString(6))?"":rs.getString(6));
				d.setOutinfo_no(StringUtils.isBlank(rs.getString(7))?"":rs.getString(7));
				d.setState(StringUtils.isBlank(rs.getString(8))?"":rs.getString(8));
				d.setOpr_state(StringUtils.isBlank(rs.getString(9))?"":rs.getString(9));
				d.setDevouttype(StringUtils.isBlank(rs.getString(10))?"":rs.getString(10));
				d.setCreate_date(StringUtils.isBlank(rs.getDate(11).toString())?"":rs.getString(11));
				d.setCreator_id(StringUtils.isBlank(rs.getString(12))?"":rs.getString(12));
				d.setModifi_date(StringUtils.isBlank(rs.getDate(13).toString())?"":rs.getString(13));
				d.setUpdator_id(StringUtils.isBlank(rs.getString(14))?"":rs.getString(14));
				d.setBsflag(StringUtils.isBlank(rs.getString(15))?"":rs.getString(15));
				return d;
			}});
		//RFIDDevOutFormDTO[] t = new RFIDDevOutFormDTO[l.size()];
		//t = l.toArray(t);
		logger.info(StringUtil.wrapString("客户端结束调用downloadOutForm方法，参数为：",orgid));
		if(CollectionUtils.isEmpty(l)){
			return null;
		}else{
			return l;
		}
	}

	@Override
	public List<RFIDDevOutFormSub> downloadOutFormSub(String outformid) {
		logger.info(StringUtil.wrapString("客户端开始调用downloadOutFormSub方法，参数为：",outformid));
		StringBuilder sql = new StringBuilder("select t.device_oif_subid sub_id,t.device_outinfo_id bill_id,t.device_id,");
		sql.append("t.device_name,t.device_model,m.mix_num bill_count,c.coding_name unit,t.out_num mix_count from GMS_DEVICE_COLL_OUTSUB t ");
		sql.append(" join GMS_DEVICE_COLL_MIXSUB m on t.device_mif_subid=m.device_mif_subid join comm_coding_sort_detail c");
		sql.append(" on t.unit_id=c.coding_code_id where t.device_outinfo_id=?");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<RFIDDevOutFormSub> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{outformid},new RowMapper<RFIDDevOutFormSub>(){

			@Override
			public RFIDDevOutFormSub mapRow(ResultSet rs, int rowNum) throws SQLException {
				RFIDDevOutFormSub obj = new RFIDDevOutFormSub();
				obj.setSub_id(rs.getString(1));
				obj.setBill_id(rs.getString(2));
				obj.setDevice_id(rs.getString(3));
				obj.setDevice_name(rs.getString(4));
				obj.setDevice_model(rs.getString(5));
				obj.setBill_count(rs.getInt(6));
				obj.setUnit(rs.getString(7));
				obj.setOut_count(rs.getInt(8));
				return obj;
			}});
		if(CollectionUtils.isEmpty(l)){
			l = null;
		}
		logger.info(StringUtil.wrapString("客户端结束调用downloadOutFormSub方法，参数为：",outformid));
		return l;
	}

	@Override
	public List<RFIDDevOutFormSubDetail> downloadOutFormSubDetail(String outformid) {
		logger.info(StringUtil.wrapString("客户端开始调用downloadOutFormSubDetail方法，参数为：",outformid));
		StringBuilder sql = new StringBuilder("select t.id,t.device_outinfo_id,t.device_oif_subid,");
		sql.append("t.dev_acc_id,t.device_id,t.dev_sign,t.type_seq,f.project_info_no,p.project_name,");
		sql.append("t.epc from GMS_DEVICE_COLL_OUTDET t ");
		sql.append(" join gms_device_coll_outform f on  t.device_outinfo_id=f.device_outinfo_id ");
		sql.append(" join gp_task_project p on f.project_info_no=p.project_info_no where t.device_outinfo_id=?");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<RFIDDevOutFormSubDetail> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{outformid},new RowMapper<RFIDDevOutFormSubDetail>(){

			@Override
			public RFIDDevOutFormSubDetail mapRow(ResultSet rs, int rowNum) throws SQLException {
				RFIDDevOutFormSubDetail d = new RFIDDevOutFormSubDetail();
				d.setDetail_id(rs.getString(1));
				d.setBill_id(rs.getString(2));
				d.setSub_id(rs.getString(3));
				d.setDev_acc_id(rs.getString(4));
				d.setDevice_id(rs.getString(5));
				d.setDev_sign(rs.getString(6));
				d.setType_seq(rs.getInt(7));
				d.setProject_id(rs.getString(8));
				d.setProject_name(rs.getString(9));
				d.setEpc(rs.getString(10));
				return d;
			}});
		if(CollectionUtils.isEmpty(l)){
			l = null;
		}
		logger.info(StringUtil.wrapString("客户端结束调用downloadOutFormSubDetail方法，参数为：",outformid));
		return l;
	}

	@Override
	public Map<String, Object> uploadOutDetail(String outFormId, List<RFIDDevOut> detailData,String userid) {
		logger.info(StringUtil.wrapString("客户端开始调用uploadOutDetail方法，出库单ID为：",outFormId));
		Map<String, Object> rest = new HashMap<String, Object>();
		if(CollectionUtils.isEmpty(detailData)){
			rest.put("flag", "0");
			rest.put("msg", "上传的数据为空");
		}else if(StringUtils.isEmpty(outFormId)){
			rest.put("flag", "0");
			rest.put("msg", "上传的出库单ID参数为空");
		}else if(StringUtils.isEmpty(userid)){
			rest.put("flag", "0");
			rest.put("msg", "上传的用户ID参数为空");
		}else{
			int _count = detailData.size();
			rest.put("uploadsum", _count);//上传明细总数
			DevCommInfoSrv srv = (DevCommInfoSrv) SpringFactory.getBean("DevCommInfoSrv");
			Map<String,Integer> m =srv.saveRFIDOutFormDetailData(outFormId,detailData,userid);
			//根据返还的数据统计成功数量和失败数量
			int successsum = 0;
			//查询子表出库数量对比
			StringBuilder sum_sql = new StringBuilder("select t.device_name||t.device_model dkey,t.out_num||'|'||(t.mix_num-t.out_num) dnum from GMS_DEVICE_COLL_OUTSUB t where t.device_outinfo_id=? and (t.device_id in (");
			if(MapUtils.isNotEmpty(m)){
				Iterator<Entry<String, Integer>> ite = m.entrySet().iterator();
				int i = 10;
				while(ite.hasNext()){
					Entry<String, Integer> ent = ite.next();
					int _i = ent.getValue();
					successsum = successsum + _i;
					i++;
					if(i%1000==0){
						sum_sql.delete(sum_sql.length()-1, sum_sql.length());
						sum_sql.append(") or t.device_id in ('").append(ent.getKey()).append("',");
					}else{
						sum_sql.append("'").append(ent.getKey()).append("',");
					}
				}
				sum_sql.replace(sum_sql.length()-1, sum_sql.length(), "))");
				RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
				List<Map<String,Object>> _ll = dao.getJdbcTemplate().query(sum_sql.toString(), new Object[]{outFormId}, new RowMapper<Map<String,Object>>(){

					@Override
					public Map<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
						Map<String, Object> _m = new HashMap<String, Object>();
						_m.put(rs.getString("dkey"), rs.getString("dnum"));
						return _m;
					}});
				if(CollectionUtils.isNotEmpty(_ll)){
					for (Map<String, Object> map : _ll) {
						rest.putAll(map);
					}
				}
				rest.put("errorsum", _count - successsum);
				rest.put("successsum", successsum);
				rest.put("flag", "1");
				rest.put("msg", "上传出库数据成功");
			}else{
				rest.put("errorsum", _count);
				rest.put("successsum",0);
				rest.put("flag", "1");
				rest.put("msg", "上传出库数据成功");
			}
		}
		logger.info(StringUtil.wrapString("客户端结束调用uploadOutDetail方法，出库单ID为：",outFormId));
		return rest;
	}
	
	@Override
	public String testSvr(String name) {
		System.out.println("--------------"+name);
		return "服务器接收到参数："+name;
	}
	
	@Override
	public String testMap(Map<String, Object> m) {
		System.out.println(m.toString());
		return m.toString();
	}


	@Override
	public Map<String, Object> uploadRFIDBind(List<RFIDBind> data,String orgid) {
		
		logger.info(StringUtil.wrapString("客户端开始调用uploadRFIDBind方法，参数数量：",data.size()+""));
		
		Map<String,Object> m = new HashMap<String,Object>();
		//验证数据
		if(CollectionUtils.isEmpty(data)){
			m.put("flag", "0");
			m.put("msg", "上传标签绑定数据失败，上传的数据为空");
		}else{
			//将绑定信息导入数据库
			DevCommInfoSrv srv = (DevCommInfoSrv) SpringFactory.getBean("DevCommInfoSrv");
			//int[] i =srv.saveRFIDBind(data);
			srv.saveRFIDBind(data,orgid);
			m.put("flag", "1");
			m.put("msg", "上传标签绑定数据成功");
			m.put("uploadsum", data.size());//上传明细总数
		}
		
		logger.info(StringUtil.wrapString("客户端结束调用uploadRFIDBind方法，参数数量：",data.size()+""));
		return m;
	}


	@Override
	public List<RFIDDevInFormDTO> downloadInForm(String orgid) {
		
		logger.info(StringUtil.wrapString("客户端开始调用downloadInForm方法，参数为：",orgid));
		StringBuilder sql = new StringBuilder("select o1.org_abbreviation org,o2.org_abbreviation in_org,o3.org_abbreviation out_org,");
	    sql.append("t.project_info_id,p.project_name,t.device_coll_mixinfo_id bill_id,t.device_mixapp_no,cba.create_date apdate,");//8
	    sql.append("ep.employee_name,t.back_dev_type,t.create_date,c.user_name creator_id,t.device_backapp_id,");//13
	    sql.append("pauu.user_name uup_id,t.modifi_date,o4.org_abbreviation,bmu.user_name,t.remark,t.backapp_name,o4.org_name,");//20
	    sql.append("t.state,t.opr_state,t.bsflag,cba.backapp_name cba_name from GMS_DEVICE_COLL_BACKINFO_FORM t join COMM_ORG_INFORMATION o1 on t.org_id=o1.org_id ");
	    sql.append(" left join P_AUTH_USER pauu on t.updator_id=pauu.user_id ");
	    sql.append(" join GMS_DEVICE_COLLBACKAPP cba on t.device_backapp_id=cba.device_backapp_id left join COMM_HUMAN_EMPLOYEE ep on cba.back_employee_id=ep.employee_id ");
	    sql.append(" left join COMM_ORG_INFORMATION o2 on t.receive_org_id=o2.org_id left join COMM_ORG_INFORMATION o3 on t.back_org_id=o3.org_id ");
	    sql.append(" join GP_TASK_PROJECT p on p.project_info_no=t.project_info_id left join P_AUTH_USER c on t.creator_id=c.user_id ");
	    sql.append(" left join COMM_ORG_INFORMATION o4 on t.backmix_org_id=o4.org_id left join P_AUTH_USER bmu on t.backmix_username=bmu.user_id ");
	    sql.append(" where (t.opr_state is null or t.opr_state!=9) and t.back_dev_type='S9000' and t.receive_org_id=?");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

		List<RFIDDevInFormDTO> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{orgid}, new RowMapper<RFIDDevInFormDTO>(){
			@Override
			public RFIDDevInFormDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
				RFIDDevInFormDTO d = new RFIDDevInFormDTO();
				d.setOrg(rs.getString(1));
				d.setReceive_org(rs.getString(2));
				d.setOut_org(rs.getString(3));
				d.setProject_info_id(rs.getString(4));
				d.setProject_info_name(rs.getString(5));
				d.setBill_id(rs.getString(6));
				d.setBill_no(rs.getString(7));
				d.setBackdate(rs.getDate(8));
				d.setBack_employee(rs.getString(9));
				d.setCreate_date(rs.getDate(11));
				d.setCreator(rs.getString(12));
				d.setUpdator(rs.getString(14));
				d.setModifi_date(rs.getDate(15));
				d.setBackmix_org(rs.getString(16));
				d.setBackmix_username(rs.getString(17));
				d.setRemark(rs.getString(18));
				d.setMixapp_name(rs.getString(19));
				d.setBackapp_name(rs.getString(24));
				return d;
			}});

		logger.info(StringUtil.wrapString("客户端结束调用downloadInForm方法，参数为：",orgid));
		
		if(CollectionUtils.isEmpty(l)){
			return null;
		}else{
			return l;
		}
	}


	@Override
	public List<RFIDDevInFormSub> downloadInFormSub(String inFormId) {
		StringBuilder sql = new StringBuilder("select t.device_coll_backdet_id,t.device_coll_mixinfo_id,");
		sql.append("d.device_id,d.dev_name,d.dev_model,s.coding_name,t.back_num,d.unuse_num,t.device_backdet_id,");
		sql.append("t.in_num,t.is_leaving,t.planning_out_time,t.in_date from GMS_DEVICE_COLL_BACK_DETAIL t ");
		sql.append(" join GMS_DEVICE_COLL_ACCOUNT_DUI d on t.dev_acc_id2=d.dev_acc_id ");
		sql.append(" left join comm_coding_sort_detail s on d.dev_unit=s.coding_code_id ");
		sql.append(" where t.device_coll_mixinfo_id=?");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<RFIDDevInFormSub> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{inFormId}, new RowMapper<RFIDDevInFormSub>(){
			@Override
			public RFIDDevInFormSub mapRow(ResultSet rs, int rowNum) throws SQLException {
				RFIDDevInFormSub m = new RFIDDevInFormSub();
				m.setSub_id(rs.getString(1));
				m.setBill_id(rs.getString(2));
				m.setDevice_id(rs.getString(3));
				m.setDevice_name(rs.getString(4));
				m.setDevice_model(rs.getString(5));
				m.setUnitName(rs.getString(6));
				m.setBill_count(rs.getInt(7));
				m.setOut_count(rs.getInt(8));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}


	@Override
	public List<RFIDDevInFormSubDetail> downloadInFormSubDetail(String inFormId) {
		StringBuilder sql = new StringBuilder("select t.id,t.device_coll_mixinfo_id,t.device_coll_backdet_id,");
		sql.append("t.dev_acc_id,t.device_id,t.dev_sign,t.type_seq,t.epc,f.project_info_id,p.project_name ");
		sql.append(" from GMS_DEVICE_RFCOLINFORM_DET t join GMS_DEVICE_COLL_BACKINFO_FORM f on ");
		sql.append(" t.device_coll_mixinfo_id=f.device_coll_mixinfo_id join gp_task_project p on ");
		sql.append(" f.project_info_id=p.project_info_no where t.device_coll_mixinfo_id=?");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<RFIDDevInFormSubDetail> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{inFormId}, new RowMapper<RFIDDevInFormSubDetail>(){
			@Override
			public RFIDDevInFormSubDetail mapRow(ResultSet rs, int rowNum) throws SQLException {
				RFIDDevInFormSubDetail m = new RFIDDevInFormSubDetail();
				m.setDetail_id(rs.getString(1));
				m.setBill_id(rs.getString(2));
				m.setSub_id(rs.getString(3));
				m.setDev_acc_id(rs.getString(4));
				m.setDevice_id(rs.getString(5));
				m.setDev_sign(rs.getString(6));
				m.setType_seq(rs.getInt(7));
				//m.setDev_seq(rs.getInt(8));
				m.setEpc(rs.getString(8));
				m.setProject_info_no(rs.getString(9));
				m.setProject_info_name(rs.getString(10));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}


	@Override
	public Map<String, Object> uploadInDetail(String inFormId,List<RFIDDevIn> detailData, String userid) {
		logger.info(StringUtil.wrapString("客户端开始调用uploadInDetail方法，入库单ID为：",inFormId));
		Map<String, Object> rest = new HashMap<String, Object>();
		if(CollectionUtils.isEmpty(detailData)){
			rest.put("flag", "0");
			rest.put("msg", "上传的数据为空");
		}else if(StringUtils.isEmpty(inFormId)){
			rest.put("flag", "0");
			rest.put("msg", "上传的入库单ID参数为空");
		}else if(StringUtils.isEmpty(userid)){
			rest.put("flag", "0");
			rest.put("msg", "上传的用户ID参数为空");
		}else{
			int _count = detailData.size();
			rest.put("uploadsum", _count);//上传明细数据总数
			DevCommInfoSrv srv = (DevCommInfoSrv) SpringFactory.getBean("DevCommInfoSrv");
			Map<String,Integer> m =srv.saveRFIDInFormDetailData(inFormId,detailData,userid);
			//根据返回的数据统计成功数量和失败数量
			int successsum = 0;
			if(MapUtils.isNotEmpty(m)){
				//查询入库单，获得对应设备类型的入库数量
				StringBuilder sum_sql = new StringBuilder("select t.dev_name||t.dev_model dkey,t.in_num||'|'||(t.back_num-t.in_num) dnum from GMS_DEVICE_COLL_BACK_DETAIL t where t.device_coll_mixinfo_id=? and (t.device_id in (");
				Iterator<Entry<String, Integer>> ite = m.entrySet().iterator();
				int i=10;
				while(ite.hasNext()){
					Entry<String, Integer> ent = ite.next();
					int _i = ent.getValue();
					i++;
					if(i%1000==0){
						sum_sql.delete(sum_sql.length()-1, sum_sql.length());
						sum_sql.append(") or t.device_id in ('").append(ent.getKey()).append("',");
					}else{
						sum_sql.append("'").append(ent.getKey()).append("',");
					}
					//rest.put(ent.getKey(), _i);
					successsum = successsum + _i;
				}
				sum_sql.replace(sum_sql.length()-1, sum_sql.length(), "))");
				RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
				List<Map<String,Object>> _ll = dao.getJdbcTemplate().query(sum_sql.toString(), new Object[]{inFormId}, new RowMapper<Map<String,Object>>(){

					@Override
					public Map<String, Object> mapRow(ResultSet rs, int rowNum) throws SQLException {
						Map<String, Object> _m = new HashMap<String, Object>();
						_m.put(rs.getString("dkey"), rs.getString("dnum"));
						return _m;
					}});
				if(CollectionUtils.isNotEmpty(_ll)){
					for (Map<String, Object> map : _ll) {
						rest.putAll(map);
					}
				}
				rest.put("errorsum", _count - successsum);
				rest.put("successsum", successsum);
				rest.put("flag", "1");
				rest.put("msg", "上传入库数据成功");
			}else{
				rest.put("errorsum", _count);
				rest.put("successsum",0);
				rest.put("flag", "1");
				rest.put("msg", "上传入库数据成功");
			}
		}
		logger.info(StringUtil.wrapString("客户端结束调用uploadInDetail方法，入库单ID为：",inFormId));
		return rest;
	}

	@Override
	public List<EnumEntity> downloadEnum(String enumType) {
		if(StringUtils.isBlank(enumType)){
			return null;
		}else{
			DevCommInfoSrv srv = (DevCommInfoSrv) SpringFactory.getBean("DevCommInfoSrv");
			List<EnumEntity> enum_list =srv.downloadEnum(enumType);
			if(CollectionUtils.isNotEmpty(enum_list)){
				return enum_list;
			}else{
				return null;
			}
		}
	}

	@Override
	public List<GmsDeviceCollRepairSend> downloadVendorRepairForm(String orgid) {
		String str = 
		"SELECT DATA.ID                 AS ID,\n" +
		"       DATA.REPAIR_FORM_NO     AS REPAIR_FORM_NO,\n" + 
		"       DATA.APPLY_DATE         AS APPLY_DATE,\n" + 
		"       PRO.PROJECT_NAME        AS OWN_PROJECT,\n" + 
		"       REQORG.ORG_ABBREVIATION AS APPLY_ORG,\n" + 
		"       DATA.SERVICE_COMPANY    AS SERVICE_COMPANY,\n" + 
		"       DICT.OPTIONDESC           AS CURRENCY,\n" + 
		"       DATA.RATE               AS RATE,\n" + 
		"       DATA.BUGET_OUR          AS BUGET_OUR,\n" + 
		"       DATA.BUGET_LOCAL        AS BUGET_LOCAL,\n" + 
		"       DATA.STATUS             AS STATUS,\n" + 
		"       DATA.REMARK             AS REMARK,\n" + 
		"       DATA.BSFLAG             AS BSFLAG,\n" + 
		"       CREUSER.EMPLOYEE_NAME   AS CREATOR,\n" + 
		"       DATA.CREATE_DATE        AS CREATE_DATE,\n" + 
		"       UPUSER.EMPLOYEE_NAME    AS MODIFIER,\n" + 
		"       DATA.MODIFI_DATE        AS MODIFI_DATE,\n" + 
		"       DATA.REPAIR_FORM_NAME   AS REPAIR_FORM_NAME,\n" + 
		"       DATA.RETURN_FLG\n" + 
		"  FROM (\n" + 
		"        -------------\n" + 
		"        SELECT S.ID               AS ID,\n" + 
		"                S.REPAIR_FORM_NO   AS REPAIR_FORM_NO,\n" + 
		"                S.APPLY_DATE       AS APPLY_DATE,\n" + 
		"                S.OWN_PROJECT      AS OWN_PROJECT,\n" + 
		"                S.APPLY_ORG        AS APPLY_ORG,\n" + 
		"                S.SERVICE_COMPANY  AS SERVICE_COMPANY,\n" + 
		"                S.CURRENCY         AS CURRENCY,\n" + 
		"                S.RATE             AS RATE,\n" + 
		"                S.BUGET_OUR        AS BUGET_OUR,\n" + 
		"                S.BUGET_LOCAL      AS BUGET_LOCAL,\n" + 
		"                S.STATUS           AS STATUS,\n" + 
		"                S.REMARK           AS REMARK,\n" + 
		"                S.BSFLAG           AS BSFLAG,\n" + 
		"                S.CREATOR          AS CREATOR,\n" + 
		"                S.CREATE_DATE      AS CREATE_DATE,\n" + 
		"                S.MODIFIER         AS MODIFIER,\n" + 
		"                S.MODIFI_DATE      AS MODIFI_DATE,\n" + 
		"                S.REPAIR_FORM_NAME AS REPAIR_FORM_NAME,\n" +
		"                S.RETURN_FLG\n" +
		"          FROM GMS_DEVICE_COLL_REPAIR_SEND S\n" + 
		"         WHERE 1 = 1\n" + 
		"           AND S.BSFLAG = '0'\n" + 
		"           AND S.STATUS = '0'\n" + 
		"           AND S.APPLY_ORG = ?\n" + 
		/*"        UNION ALL\n" + 
		"        SELECT T.ID               AS ID,\n" + 
		"               T.REPAIR_FORM_NO   AS REPAIR_FORM_NO,\n" + 
		"               T.APPLY_DATE       AS APPLY_DATE,\n" + 
		"               T.OWN_PROJECT      AS OWN_PROJECT,\n" + 
		"               T.APPLY_ORG        AS APPLY_ORG,\n" + 
		"               T.SERVICE_COMPANY  AS SERVICE_COMPANY,\n" + 
		"               T.CURRENCY         AS CURRENCY,\n" + 
		"               T.RATE             AS RATE,\n" + 
		"               T.BUGET_OUR        AS BUGET_OUR,\n" + 
		"               T.BUGET_LOCAL      AS BUGET_LOCAL,\n" + 
		"               T.STATUS           AS STATUS,\n" + 
		"               T.REMARK           AS REMARK,\n" + 
		"               T.BSFLAG           AS BSFLAG,\n" + 
		"               T.CREATOR          AS CREATOR,\n" + 
		"               T.CREATE_DATE      AS CREATE_DATE,\n" + 
		"               T.MODIFIER         AS MODIFIER,\n" + 
		"               T.MODIFI_DATE      AS MODIFI_DATE,\n" + 
		"               T.REPAIR_FORM_NAME AS REPAIR_FORM_NAME\n" + 
		"          FROM GMS_DEVICE_COLL_REPAIR_SEND T, COMMON_BUSI_WF_MIDDLE WFMIDDLE\n" + 
		"         WHERE T.BSFLAG = '0'\n" + 
		"           AND T.ID = WFMIDDLE.BUSINESS_ID(+)\n" + 
		"           AND T.APPLY_ORG = ?\n" + 
		"           AND WFMIDDLE.BSFLAG = '0'\n" + 
		"           AND WFMIDDLE.PROC_STATUS = '3'\n" + 
		"           AND T.ID NOT IN\n" + 
		"              ----返还不够的记录\n" + 
		"               (SELECT A.FORMID AS FORMID\n" + 
		"                  FROM (SELECT COUNT(1) AS COUNT1, SUB.SEND_FORM_ID AS FORMID\n" + 
		"                          FROM GMS_DEVICE_COLL_SEND_SUB SUB\n" + 
		"                         WHERE SUB.BSFLAG = 0\n" + 
		"                         GROUP BY SUB.SEND_FORM_ID) A,\n" + 
		"                       (SELECT COUNT(1) AS COUNT2,\n" + 
		"                               DETAIL.REPAIRFORM_ID AS FORMID\n" + 
		"                          FROM GMS_DEVICE_COL_REP_DETAIL DETAIL\n" + 
		"                         WHERE DETAIL.BSFLAG = 0\n" + 
		"                         GROUP BY DETAIL.REPAIRFORM_ID) B\n" + 
		"                 WHERE A.FORMID = B.FORMID\n" + 
		"                   AND A.COUNT1 = B.COUNT2)\n" + */
		"        ) DATA,\n" + 
		"       GP_TASK_PROJECT PRO,\n" + 
		"       COMM_ORG_INFORMATION REQORG,\n" + 
		"       COMM_HUMAN_EMPLOYEE CREUSER,\n" + 
		"       COMM_HUMAN_EMPLOYEE UPUSER,\n" + 
		"       (SELECT T.DICTKEY,\n" + 
		"               T.DICTDESC,\n" + 
		"               I.OPTIONVALUE,\n" + 
		"               I.OPTIONDESC,\n" + 
		"               I.DISPLAYORDER\n" + 
		"          FROM GMS_DEVICE_COMM_DICT T\n" + 
		"          JOIN GMS_DEVICE_COMM_DICT_ITEM I\n" + 
		"            ON T.ID = I.DICT_ID\n" + 
		"         WHERE T.BSFLAG = '0'\n" + 
		"           AND T.DICTKEY = 'currency') DICT\n" + 
		" WHERE DATA.OWN_PROJECT = PRO.PROJECT_INFO_NO(+)\n" + 
		"   AND DATA.APPLY_ORG = REQORG.ORG_ID(+)\n" + 
		"   AND DATA.CREATOR = CREUSER.EMPLOYEE_ID(+)\n" + 
		"   AND DATA.MODIFIER = UPUSER.EMPLOYEE_ID(+)\n" + 
		"   AND DATA.CURRENCY = DICT.OPTIONVALUE(+)";
		StringBuilder sql = new StringBuilder(str);
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<GmsDeviceCollRepairSend> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{orgid}, new RowMapper<GmsDeviceCollRepairSend>(){
			@Override
			public GmsDeviceCollRepairSend mapRow(ResultSet rs, int rowNum) throws SQLException {
				GmsDeviceCollRepairSend m = new GmsDeviceCollRepairSend();
				m.setId(rs.getString(1));
				m.setRepair_form_no(rs.getString(2));
				m.setApply_date(rs.getDate(3));
				m.setOwn_project(rs.getString(4));
				m.setApply_org(rs.getString(5));
				m.setService_company(rs.getString(6));
				m.setCurrency(rs.getString(7));
				m.setRate(rs.getDouble(8));
				m.setBuget_our(rs.getDouble(9));
				m.setBuget_local(rs.getDouble(10));
				m.setStatus(rs.getString(11));
				m.setRemark(rs.getString(12));
				m.setBsflag(rs.getString(13));
				m.setCreator(rs.getString(14));
				m.setCreate_date(rs.getDate(15));
				m.setModifier(rs.getString(16));
				m.setModifi_date(rs.getDate(17));
				m.setRepair_form_name(rs.getString(18));
				m.setReturn_flg(rs.getString(19));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}

	@Override
	public List<GmsDeviceCollRepairform> downloadSelfRepairForm(String orgid) {
		String str = 
				//联表查询  start
				"select data.ID as id,\n" +
				"       data.REPAIR_FORM_CODE as REPAIR_FORM_CODE,\n" + 
				"       data.REPAIR_FORM_NAME as REPAIR_FORM_NAME,\n" + 
				"       data.APPLY_DATE as APPLY_DATE,\n" + 
				"       PRO.PROJECT_NAME         as OWN_PROJECT,\n" + 
				"       REQORG.ORG_ABBREVIATION  as REQ_COMP,\n" + 
				"       TODOORG.ORG_ABBREVIATION as TODO_COMP,\n" + 
				"       REQUSER.Employee_Name    as REQ_USER,\n" + 
				"       data.REQ_DATE as REQ_DATE,\n" + 
				"       data.STATUS as STATUS,\n" + 
				"       data.REMARK as REMARK,\n" + 
				"       data.BSFLAG as BSFLAG,\n" + 
				"       creUSER.Employee_Name    as CREATOR,\n" + 
				"       data.CREATE_DATE as CREATE_DATE,\n" + 
				"       upUSER.Employee_Name     as MODIFIER,\n" + 
				"       data.MODIFI_DATE as MODIFI_DATE,\n" + 
				"       PROCESS_STAT as PROCESS_STAT,\n" + 
				"		data.RETURN_FLG\n" + 
				"  from (" +
				//联表查询  end
				"SELECT f.ID as id,\n" +
						"       f.REPAIR_FORM_CODE as REPAIR_FORM_CODE,\n" + 
						"       f.REPAIR_FORM_NAME as REPAIR_FORM_NAME,\n" + 
						"       f.APPLY_DATE as APPLY_DATE,\n" + 
						"       f.OWN_PROJECT as OWN_PROJECT,\n" + 
						"       f.REQ_COMP as REQ_COMP,\n" + 
						"       f.TODO_COMP as TODO_COMP,\n" + 
						"       f.REQ_USER as REQ_USER,\n" + 
						"       f.REQ_DATE as REQ_DATE,\n" + 
						"       f.STATUS as STATUS,\n" + 
						"       f.REMARK as REMARK,\n" + 
						"       f.BSFLAG as BSFLAG,\n" + 
						"       f.CREATOR as CREATOR,\n" + 
						"       f.CREATE_DATE as CREATE_DATE,\n" + 
						"       f.MODIFIER as MODIFIER,\n" + 
						"       f.MODIFI_DATE as MODIFI_DATE,\n" + 
						"       f.PROCESS_STAT as PROCESS_STAT,\n" +
						"       f.RETURN_FLG  \n"+
						"  FROM GMS_DEVICE_COLL_REPAIRFORM  f WHERE 1=1 AND f.BSFLAG = '0' AND f.STATUS = '0' AND f.REQ_COMP = ?\n" + 
						/*"  union all\n" + 
						"SELECT t.ID as ID,\n" + 
						"       t.REPAIR_FORM_CODE as REPAIR_FORM_CODE,\n" + 
						"       t.REPAIR_FORM_NAME as REPAIR_FORM_NAME,\n" + 
						"       t.APPLY_DATE as APPLY_DATE,\n" + 
						"       t.OWN_PROJECT as OWN_PROJECT,\n" + 
						"       t.REQ_COMP as REQ_COMP,\n" + 
						"       t.TODO_COMP as TODO_COMP,\n" + 
						"       t.REQ_USER as REQ_USER,\n" + 
						"       t.REQ_DATE as REQ_DATE,\n" + 
						"       t.STATUS as STATUS,\n" + 
						"       t.REMARK as REMARK,\n" + 
						"       t.BSFLAG as BSFLAG,\n" + 
						"       t.CREATOR as CREATOR,\n" + 
						"       t.CREATE_DATE as CREATE_DATE,\n" + 
						"       t.MODIFIER as MODIFIER,\n" + 
						"       t.MODIFI_DATE as MODIFI_DATE,\n" + 
						"       t.PROCESS_STAT as PROCESS_STAT\n" + 
						"  FROM GMS_DEVICE_COLL_REPAIRFORM t\n" + 
						" where t.BSFLAG = '0' AND t.STATUS = '1' \n" + 
						"   and t.REQ_COMP = ? " + 
						"   and t.id NOT in " + 
						//返还没完成的
						"(SELECT A.FORMID AS FORMID FROM\n" +
						"(SELECT COUNT(1) AS COUNT1, sub.REPAIRFORM_ID AS FORMID FROM   GMS_DEVICE_COLL_REPAIR_SUB sub\n" + 
						"WHERE sub.BSFLAG = 0  AND sub.DEV_STATUS > 2 GROUP BY sub.REPAIRFORM_ID) A,\n" + 
						"(SELECT COUNT(1) AS COUNT2, detail.REPAIRFORM_ID AS FORMID FROM   GMS_DEVICE_COL_REP_DETAIL detail\n" + 
						"WHERE detail.BSFLAG = 0 GROUP BY detail.REPAIRFORM_ID) B\n" + 
						"WHERE A.FORMID = B.FORMID\n" + 
						"AND A.COUNT1 = B.COUNT2)"+*/
						//联表查询  start
						") data,\n" +
						"       GP_TASK_PROJECT PRO,\n" + 
						"       COMM_ORG_INFORMATION REQORG,\n" + 
						"       COMM_ORG_INFORMATION TODOORG,\n" + 
						"       COMM_HUMAN_EMPLOYEE REQUSER,\n" + 
						"       COMM_HUMAN_EMPLOYEE CREUSER,\n" + 
						"       COMM_HUMAN_EMPLOYEE UPUSER\n" + 
						" where data.OWN_PROJECT = pro.PROJECT_INFO_NO(+)\n" + 
						"   and data.REQ_COMP = REQORG.ORG_ID(+)\n" + 
						"   and data.TODO_COMP = TODOORG.Org_Id(+)\n" + 
						"   and data.REQ_USER = REQUSER.Employee_Id(+)\n" + 
						"   and data.CREATOR = CREUSER.Employee_Id(+)\n" + 
						"   and data.MODIFIER = UPUSER.Employee_Id(+)";
		StringBuilder sql = new StringBuilder(str);
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<GmsDeviceCollRepairform> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{orgid}, new RowMapper<GmsDeviceCollRepairform>(){
			@Override
			public GmsDeviceCollRepairform mapRow(ResultSet rs, int rowNum) throws SQLException {
				GmsDeviceCollRepairform m = new GmsDeviceCollRepairform();
				m.setId(rs.getString(1));
				m.setRepair_form_code(rs.getString(2));
				m.setRepair_form_name(rs.getString(3));
				m.setApply_date(rs.getDate(4));
				m.setOwn_project(rs.getString(5));
				m.setReq_comp(rs.getString(6));
				m.setTodo_comp(rs.getString(7));
				m.setReq_user(rs.getString(8));
				m.setReq_date(rs.getDate(9));
				m.setStatus(rs.getString(10));
				m.setRemark(rs.getString(11));
				m.setBsflag(rs.getString(12));
				m.setCreator(rs.getString(13));
				m.setCreate_date(rs.getDate(14));
				m.setModifier(rs.getString(15));
				m.setModifi_date(rs.getDate(16));
				m.setProcess_stat(rs.getString(17));
				m.setReturn_flg(rs.getString(18));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}

	@Override
	public List<GmsDeviceDolRepForm> downloadReturnRepairForm(String orgid) {
		/*String str =    
				"select data.ID as ID,\n" +
				"       data.SEND_ID as SEND_ID,\n" + 
				"       REQORG.ORG_ABBREVIATION as BACK_ORG_ID,\n" + 
				"       data.BACKAPP_NAME as BACKAPP_NAME,\n" + 
				"       data.BACKDATE as BACKDATE,\n" + 
				"       backUSER.Employee_Name  as BACK_EMPLOYEE_ID,\n" + 
				"       data.REMARK as REMARK,\n" + 
				"       data.ORG_ID as ORG_ID,\n" + 
				"       data.ORG_NAME as ORG_NAME,\n" + 
				"       data.ORG_SUBJECTION_ID as ORG_SUBJECTION_ID,\n" + 
				"       data.BSFLAG as BSFLAG,\n" + 
				"       data.CREATE_DATE as CREATE_DATE,\n" + 
				"       creUSER.Employee_Name   as CREATOR_ID,\n" + 
				"       data.MODIFI_DATE as MODIFI_DATE,\n" + 
				"       upUSER.Employee_Name    as UPDATOR_ID,\n" + 
				"       data.REP_TYPE as REP_TYPE,\n" + 
				"       data.BACKAPP_NO as BACKAPP_NO,\n" + 
				"       data.STATUS as STATUS\n" + 
				"  from ("+
				//--------
				"SELECT ID,\n" +
						"       SEND_ID,\n" + 
						"       BACK_ORG_ID,\n" + 
						"       BACKAPP_NAME,\n" + 
						"       BACKDATE,\n" + 
						"       BACK_EMPLOYEE_ID,\n" + 
						"       REMARK,\n" + 
						"       ORG_ID,\n" + 
						"       ORG_NAME,\n" + 
						"       ORG_SUBJECTION_ID,\n" + 
						"       BSFLAG,\n" + 
						"       CREATE_DATE,\n" + 
						"       CREATOR_ID,\n" + 
						"       MODIFI_DATE,\n" + 
						"       UPDATOR_ID,\n" + 
						"       REP_TYPE,\n" + 
						"       BACKAPP_NO,\n" + 
						"       STATUS\n" + 
						"  FROM GMS_DEVICE_COL_REP_FORM t";
		StringBuilder sqlTmp = new StringBuilder(str);
		sqlTmp.append(" WHERE 1=1 AND t.BSFLAG = '0' AND T.SEND_ID IN (SELECT DISTINCT (SEND_ID)  FROM GMS_DEVICE_COL_REP_FORM T1 ");
		sqlTmp.append(" WHERE 1=1 AND BSFLAG = '0' AND STATUS = '0' AND BACK_ORG_ID = ? )");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		String sql = sqlTmp.toString();
		sql += 
				"       ) data,\n" +
						"      COMM_ORG_INFORMATION REQORG,\n" + 
						"      COMM_HUMAN_EMPLOYEE backUSER,\n" + 
						"      COMM_HUMAN_EMPLOYEE CREUSER,\n" + 
						"      COMM_HUMAN_EMPLOYEE UPUSER\n" + 
						"where data.BACK_ORG_ID = REQORG.ORG_ID(+)\n" + 
						"  and data.BACK_EMPLOYEE_ID = backUSER.Employee_Id(+)\n" + 
						"  and data.CREATOR_ID = CREUSER.Employee_Id(+)\n" + 
						"  and data.UPDATOR_ID = UPUSER.Employee_Id(+)";*/
		
		
		
			String sql=" select distinct f.ID as ID, \n" + 
			"      sub.SEND_FORM_ID  send_id \n" + 
			"   ,sub.return_flg, "+
			"  f.BACKAPP_NAME as BACKAPP_NAME, \n" + 
			"  f.BACKDATE as BACKDATE, \n" + 
			"   backUSER.Employee_Name  as BACK_EMPLOYEE_ID, \n" + 
			"   f.REMARK as REMARK, \n" + 
			"  f.ORG_ID as ORG_ID, \n" + 
			"  f.ORG_NAME as ORG_NAME, \n" + 
			"  f.ORG_SUBJECTION_ID as ORG_SUBJECTION_ID, \n" + 
			"  f.BSFLAG as BSFLAG, \n" + 
			"  f.CREATE_DATE as CREATE_DATE, \n" + 
			"  creUSER.Employee_Name   as CREATOR_ID, \n" + 
			"  f.MODIFI_DATE as MODIFI_DATE, \n" + 
			"  upUSER.Employee_Name    as UPDATOR_ID, \n" + 
			"  f.REP_TYPE as REP_TYPE, \n" + 
			"  f.BACKAPP_NO as BACKAPP_NO, \n" + 
			"  f.STATUS as STATUS,BACK_ORG_ID, \n" + 
			"  sub.return_flg \n" + 
			"  from GMS_DEVICE_COL_REP_FORM f , GMS_DEVICE_COL_REP_DETAIL b , \n" + 
			"  GMS_DEVICE_COLL_SEND_SUB sub,COMM_ORG_INFORMATION REQORG, \n" + 
			"  COMM_HUMAN_EMPLOYEE backUSER, \n" + 
			"  COMM_HUMAN_EMPLOYEE CREUSER, \n" + 
			"  COMM_HUMAN_EMPLOYEE UPUSER  where  \n" + 
			"  f.BACK_ORG_ID = REQORG.ORG_ID(+) \n" + 
			"  and f.BACK_EMPLOYEE_ID = backUSER.Employee_Id(+) \n" + 
			"  and f.CREATOR_ID = CREUSER.Employee_Id(+) \n" + 
			"  and f.UPDATOR_ID = UPUSER.Employee_Id(+) \n" + 
			"  and f.id=b.REP_RETURN_ID (+) \n" + 
			"  and b.REP_FORM_DET_ID=sub.id(+) \n" + 
			"  and   RETURN_FLG !='2' and BACK_ORG_ID=?  \n" + 
			
			"  union   \n" +
			  
			"  select distinct f.ID as ID,sub.REPAIRFORM_ID  send_id,sub.return_flg,  \n" +
			"  f.BACKAPP_NAME as BACKAPP_NAME,  \n" +
			"  f.BACKDATE as BACKDATE,  \n" +
			"  backUSER.Employee_Name  as BACK_EMPLOYEE_ID,  \n" +
			"  f.REMARK as REMARK,  \n" +
			"  f.ORG_ID as ORG_ID,  \n" +
			"  f.ORG_NAME as ORG_NAME,  \n" +
			"  f.ORG_SUBJECTION_ID as ORG_SUBJECTION_ID,  \n" +
			"  f.BSFLAG as BSFLAG,  \n" +
			"  f.CREATE_DATE as CREATE_DATE,  \n" +
			"  creUSER.Employee_Name   as CREATOR_ID,  \n" +
			"  f.MODIFI_DATE as MODIFI_DATE,  \n" +
			"  upUSER.Employee_Name    as UPDATOR_ID,  \n" +
			"  f.REP_TYPE as REP_TYPE,  \n" +
			"  f.BACKAPP_NO as BACKAPP_NO,  \n" +
			"  f.STATUS as STATUS,BACK_ORG_ID , \n" + 
			"  sub.return_flg \n" +
			"  from GMS_DEVICE_COL_REP_FORM f , GMS_DEVICE_COL_REP_DETAIL b ,  \n" +
			"  GMS_DEVICE_COLL_REPAIR_SUB sub,COMM_ORG_INFORMATION REQORG,  \n" +
			"  COMM_HUMAN_EMPLOYEE backUSER,  \n" +
			"  COMM_HUMAN_EMPLOYEE CREUSER, \n" +
			"  COMM_HUMAN_EMPLOYEE UPUSER  where  \n" +
			"  f.BACK_ORG_ID = REQORG.ORG_ID(+) \n" +
			"  and f.BACK_EMPLOYEE_ID = backUSER.Employee_Id(+) \n" +
			"  and f.CREATOR_ID = CREUSER.Employee_Id(+) \n" +
			"  and f.UPDATOR_ID = UPUSER.Employee_Id(+) \n" +
			"  and f.id=b.REP_RETURN_ID (+) \n" +
			"  and b.REP_FORM_DET_ID=sub.id(+) \n" +
			"  and   RETURN_FLG !='2'  and BACK_ORG_ID=? ";
			RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<GmsDeviceDolRepForm> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{orgid,orgid}, new RowMapper<GmsDeviceDolRepForm>(){
			@Override
			public GmsDeviceDolRepForm mapRow(ResultSet rs, int rowNum) throws SQLException {
				GmsDeviceDolRepForm m = new GmsDeviceDolRepForm();
				m.setId(rs.getString(1));
				m.setSend_id(rs.getString(2));
				m.setBack_org_id(rs.getString(3));
				m.setBackapp_name(rs.getString(4));
				m.setBackdate(rs.getDate(5));
				m.setBack_employee_id(rs.getString(6));
				m.setRemark(rs.getString(7));
				m.setOrg_id(rs.getString(8));
				m.setOrg_name(rs.getString(9));
				m.setOrg_subjection_id(rs.getString(10));
				m.setBsflag(rs.getString(11));
				m.setCreate_date(rs.getDate(12));
				m.setCreator_id(rs.getString(13));
				m.setModifi_date(rs.getDate(14));
				m.setUpdator_id(rs.getString(15));
				m.setRep_type(rs.getString(16));
				m.setBackapp_no(rs.getString(17));
				m.setStatus(rs.getString(18));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}

	@Override
	public Map<String, Object> uploadVendorRepairFormDetail(String formId,
			List<GmsDeviceCollSendSub> data) {
		logger.info(StringUtil.wrapString("客户端开始调用uploadVendorRepairFormDetail方法，参数数量：",data.size()+""));
		int uploadsum = data.size();
		Map<String,Object> m = new HashMap<String,Object>();
		m.put("uploadsum", uploadsum);//上传总数
		//验证数据
		if(CollectionUtils.isEmpty(data)){
			m.put("flag", "0");
			m.put("msg", "上传标签绑定数据失败，上传的数据为空");
		}else{
			//将绑定信息导入数据库
			DevCommInfoSrv srv = (DevCommInfoSrv) SpringFactory.getBean("DevCommInfoSrv");
			List<GmsDeviceCollSendSub> useData = new ArrayList<GmsDeviceCollSendSub>(); //将不重复的记录保存起来
			int dupsum = 0;//未成功接收数量 (包括重复的)
			//判断与送外维修表中明细台账是否重复  根据台账ID
			for(int i = 0;i<data.size();i++){
				int j = 0;
				String fromId = (String)data.get(i).getSend_form_id();  //送外维修单表ID
				String devAccId = (String)data.get(i).getDev_acc_id();  //台账ID
				String querySql = "SELECT COUNT(1) FROM GMS_DEVICE_COLL_SEND_SUB T WHERE T.SEND_FORM_ID = ? AND T.DEV_ACC_ID = ? ";
				j = srv.queryForInt(querySql, new Object[] {fromId,devAccId});
				if(j==0){//没有重复记录
					useData.add(data.get(i));
				}else{//有重复记录
					dupsum += j;
				}
			}
			//successsum(成功接收并入库总数):8,errorsum(未成功接收数量，包括重复的):2}
			int tmp[] = srv.saveVendorRepairFormDetail(useData);
			int successsum = tmp.length;
			int errorsum = uploadsum - successsum;
			m.put("successsum", successsum);
			m.put("errorsum", errorsum);
			m.put("flag", "1");
			m.put("msg", "上传标签绑定数据成功");
		}
		
		logger.info(StringUtil.wrapString("客户端结束调用uploadVendorRepairFormDetail方法，参数数量：",data.size()+""));
		return m;
	
	}

	@Override
	public Map<String, Object> uploadSelfRepairFormDetail(String formId,
			List<GmsDeviceCollRepairSub> data) {
		logger.info(StringUtil.wrapString("客户端开始调用uploadSelfRepairFormDetail方法，参数数量：",data.size()+""));
		int uploadsum = data.size();
		Map<String,Object> m = new HashMap<String,Object>();
		m.put("uploadsum", uploadsum);//上传总数
		//验证数据
		if(CollectionUtils.isEmpty(data)){
			m.put("flag", "0");
			m.put("msg", "上传标签绑定数据失败，上传的数据为空");
		}else{
			//将绑定信息导入数据库
			DevCommInfoSrv srv = (DevCommInfoSrv) SpringFactory.getBean("DevCommInfoSrv");
			List<GmsDeviceCollRepairSub> useData = new ArrayList<GmsDeviceCollRepairSub>(); //将不重复的记录保存起来
			int dupsum = 0;//未成功接收数量 (包括重复的)
			//判断与送内维修表中明细台账是否重复  根据台账ID
			for(int i = 0;i<data.size();i++){
				int j = 0;
				String fromId = (String)data.get(i).getRepairform_id();  //送内维修单表ID
				String devAccId = (String)data.get(i).getDev_acc_id();  //台账ID
				String querySql = "SELECT COUNT(1) FROM GMS_DEVICE_COLL_REPAIR_SUB T WHERE T.REPAIRFORM_ID = ? AND T.DEV_ACC_ID = ? ";
				j = srv.queryForInt(querySql, new Object[] {fromId,devAccId});
				if(j==0){//没有重复记录
					useData.add(data.get(i));
				}else{//有重复记录
					dupsum += j;
				}
			}
			//successsum(成功接收并入库总数):8,errorsum(未成功接收数量，包括重复的):2}
			int tmp[] = srv.saveSelfRepairFormDetail(useData);
			int successsum = tmp.length;
			int errorsum = uploadsum - successsum;
			m.put("successsum", successsum);
			m.put("errorsum", errorsum);
			m.put("flag", "1");
			m.put("msg", "上传标签绑定数据成功");
		}
		
		logger.info(StringUtil.wrapString("客户端结束调用uploadSelfRepairFormDetail方法，参数数量：",data.size()+""));
		return m;
	}

	@Override
	public Map<String, Object> uploadReturnRepairFormDetail(String formId,
			List<GmsDeviceColRepDetail> data) {
		logger.info(StringUtil.wrapString("客户端开始调用uploadReturnRepairFormDetail方法，参数数量：",data.size()+""));
		int uploadsum = data.size();
		Map<String,Object> m = new HashMap<String,Object>();
		m.put("uploadsum", uploadsum);//上传总数
		//验证数据
		if(CollectionUtils.isEmpty(data)){
			m.put("flag", "0");
			m.put("msg", "上传标签绑定数据失败，上传的数据为空");
		}else{
			//将绑定信息导入数据库
			DevCommInfoSrv srv = (DevCommInfoSrv) SpringFactory.getBean("DevCommInfoSrv");
			List<GmsDeviceColRepDetail> useData = new ArrayList<GmsDeviceColRepDetail>(); //将不重复的记录保存起来
			int dupsum = 0;//未成功接收数量 (包括重复的)
			//判断与送内维修表中明细台账是否重复  根据台账ID
			for(int i = 0;i<data.size();i++){
				int j = 0;
				String returnId = (String)data.get(i).getRep_return_id();  //返还单ID
				String fromId = (String)data.get(i).getRepairform_id();  //维修单表ID
				String devAccId = (String)data.get(i).getRep_form_det_id();  //明细ID
				String querySql = "SELECT COUNT(1) FROM GMS_DEVICE_COL_REP_DETAIL T WHERE T.REP_RETURN_ID = ? AND T.REPAIRFORM_ID = ? AND T.rep_form_det_id = ? ";
				j = srv.queryForInt(querySql, new Object[] {returnId,fromId,devAccId});
				if(j==0){//没有重复记录
					useData.add(data.get(i));
				}else{//有重复记录
					dupsum += j;
				}
			}
			//successsum(成功接收并入库总数):8,errorsum(未成功接收数量，包括重复的):2}
			int tmp[] = srv.saveReturnRepairFormDetail(useData);
			int successsum = tmp.length;
			int errorsum = uploadsum - successsum;
			m.put("successsum", successsum);
			m.put("errorsum", errorsum);
			m.put("flag", "1");
			m.put("msg", "上传标签绑定数据成功");
		}
		
		logger.info(StringUtil.wrapString("客户端结束调用uploadReturnRepairFormDetail方法，参数数量：",data.size()+""));
		return m;
	}
	
	
	@Override
	public List<GmsDeviceCollSendSub> downloadVendorRepairFormSub(String id) {
		String str = 
						"SELECT ID ,\n" +
						"       SEND_FORM_ID ,\n" + 
						"       DEV_ACC_ID ,\n" + 
						"       TYPE_SEQ ,\n" + 
						"       EPC ,\n" + 
						"       ERROR_TYPE ,\n" + 
						"       ERROR_DESC ,\n" + 
						"       DEV_STATUS ,\n" + 
						"       REMARK ,\n" + 
						"       BSFLAG ,\n" + 
						"       CREATOR ,\n" + 
						"       CREATE_DATE ,\n" + 
						"       MODIFIER ,\n" + 
						"       DEV_NAME ,\n" + 
						"       DEV_MODEL ,\n" + 
						"       DEV_SIGN ,\n" + 
						"       MODIFI_DATE,\n" + 
						"       RETURN_FLG\n" + 
						"  FROM GMS_DEVICE_COLL_SEND_SUB";
		StringBuilder sql = new StringBuilder(str);
		sql.append(" WHERE 1=1 AND BSFLAG = '0' AND SEND_FORM_ID = ? ");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<GmsDeviceCollSendSub> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{id}, new RowMapper<GmsDeviceCollSendSub>(){
			@Override
			public GmsDeviceCollSendSub mapRow(ResultSet rs, int rowNum) throws SQLException {
				GmsDeviceCollSendSub m = new GmsDeviceCollSendSub();
				m.setId(rs.getString(1));
				m.setSend_form_id(rs.getString(2));
				m.setDev_acc_id(rs.getString(3));
				m.setType_seq(rs.getInt(4));
				m.setEpc(rs.getString(5));
				m.setError_type(rs.getString(6));
				m.setError_desc(rs.getString(7));
				m.setDev_status(rs.getString(8));
				m.setRemark(rs.getString(9));
				m.setBsflag(rs.getString(10));
				m.setCreator(rs.getString(11));
				m.setCreate_date(rs.getDate(12));
				m.setModifier(rs.getString(13));
				m.setDev_name(rs.getString(14));
				m.setDev_model(rs.getString(15));
				m.setDev_sign(rs.getString(16));
				m.setModifi_date(rs.getDate(17));
				m.setReturn_flg(rs.getString(18));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}

	@Override
	public List<GmsDeviceCollRepairSub> downloadSelfRepairFormSub(String id) {
		String str =   
				"SELECT ID ,\n" +
						"       REPAIRFORM_ID ,\n" + 
						"       TYPE_SEQ ,\n" + 
						"       EPC ,\n" + 
						"       DEV_ACC_ID ,\n" + 
						"       ERROR_TYPE ,\n" + 
						"       ERROR_DESC ,\n" + 
						"       DEV_STATUS ,\n" + 
						"       REMARK ,\n" + 
						"       DEV_NAME ,\n" + 
						"       DEV_MODEL ,\n" + 
						"       DEV_SIGN ,\n" + 
						"       BSFLAG,\n" +
						"       RETURN_FLG\n" +
						"  FROM GMS_DEVICE_COLL_REPAIR_SUB";
		StringBuilder sql = new StringBuilder(str);
		sql.append(" WHERE 1=1 AND BSFLAG = '0' AND  REPAIRFORM_ID = ? ");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<GmsDeviceCollRepairSub> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{id}, new RowMapper<GmsDeviceCollRepairSub>(){
			@Override
			public GmsDeviceCollRepairSub mapRow(ResultSet rs, int rowNum) throws SQLException {
				GmsDeviceCollRepairSub m = new GmsDeviceCollRepairSub();
				m.setId(rs.getString(1));
				m.setRepairform_id(rs.getString(2));
				m.setType_seq(rs.getInt(3));
				m.setEpc(rs.getString(4));
				m.setDev_acc_id(rs.getString(5));
				m.setError_type(rs.getString(6));
				m.setError_desc(rs.getString(7));
				m.setDev_status(rs.getString(8));
				m.setRemark(rs.getString(9));
				m.setDev_name(rs.getString(10));
				m.setDev_model(rs.getString(11));
				m.setDev_sign(rs.getString(12));
				m.setBsflag(rs.getString(13));
				m.setReturn_flg(rs.getString(14));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}

	@Override
	public List<GmsDeviceColRepDetail> downloadReturnRepairFormSub(String id) {
		String str =
				"SELECT ID ,\n" +
						"       REP_RETURN_ID ,\n" + 
						"       REPAIRFORM_ID ,\n" + 
						"       DEV_ACC_ID ,\n" + 
						"       EPC,\n" + 
						"       ERROR_LEVEL ,\n" + 
						"       ERROR_TYPE ,\n" + 
						"       REMARK ,\n" + 
						"       REP_FORM_DET_ID ,\n" + 
						"       DEV_NAME ,\n" + 
						"       DEV_MODEL ,\n" + 
						"       DEV_SIGN ,\n" + 
						"       BSFLAG\n" + 
						"  FROM GMS_DEVICE_COL_REP_DETAIL";
		StringBuilder sql = new StringBuilder(str);
		sql.append(" WHERE 1=1 AND BSFLAG = '0' AND REP_RETURN_ID = ? ");
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<GmsDeviceColRepDetail> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{id}, new RowMapper<GmsDeviceColRepDetail>(){
			@Override
			public GmsDeviceColRepDetail mapRow(ResultSet rs, int rowNum) throws SQLException {
				GmsDeviceColRepDetail m = new GmsDeviceColRepDetail();
				m.setId(rs.getString(1));
				m.setRep_return_id(rs.getString(2));
				m.setRepairform_id(rs.getString(3));
				m.setDev_acc_id(rs.getString(4));
				m.setEpc(rs.getString(5));
				m.setError_level(rs.getString(6));
				m.setError_type(rs.getString(7));
				m.setRemark(rs.getString(8));
				m.setRep_form_det_id(rs.getString(9));
				m.setDev_name(rs.getString(10));
				m.setDev_model(rs.getString(11));
				m.setDev_sign(rs.getString(12));
				m.setBsflag(rs.getString(13));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}
	
	/*@Override
	public List<GmsDeviceCollRepairSend> downloadVendorRepairFormByRtnId(String rtnid) {
		String str = 
					"SELECT DATA.ID                 AS ID,\n" +
					"       DATA.REPAIR_FORM_NO     AS REPAIR_FORM_NO,\n" + 
					"       DATA.APPLY_DATE         AS APPLY_DATE,\n" + 
					"       PRO.PROJECT_NAME        AS OWN_PROJECT,\n" + 
					"       REQORG.ORG_ABBREVIATION AS APPLY_ORG,\n" + 
					"       DATA.SERVICE_COMPANY    AS SERVICE_COMPANY,\n" + 
					"       DICT.OPTIONDESC         AS CURRENCY,\n" + 
					"       DATA.RATE               AS RATE,\n" + 
					"       DATA.BUGET_OUR          AS BUGET_OUR,\n" + 
					"       DATA.BUGET_LOCAL        AS BUGET_LOCAL,\n" + 
					"       DATA.STATUS             AS STATUS,\n" + 
					"       DATA.REMARK             AS REMARK,\n" + 
					"       DATA.BSFLAG             AS BSFLAG,\n" + 
					"       CREUSER.EMPLOYEE_NAME   AS CREATOR,\n" + 
					"       DATA.CREATE_DATE        AS CREATE_DATE,\n" + 
					"       UPUSER.EMPLOYEE_NAME    AS MODIFIER,\n" + 
					"       DATA.MODIFI_DATE        AS MODIFI_DATE,\n" + 
					"       DATA.REPAIR_FORM_NAME   AS REPAIR_FORM_NAME\n" + 
					"  FROM (SELECT S.ID               AS ID,\n" + 
					"               S.REPAIR_FORM_NO   AS REPAIR_FORM_NO,\n" + 
					"               S.APPLY_DATE       AS APPLY_DATE,\n" + 
					"               S.OWN_PROJECT      AS OWN_PROJECT,\n" + 
					"               S.APPLY_ORG        AS APPLY_ORG,\n" + 
					"               S.SERVICE_COMPANY  AS SERVICE_COMPANY,\n" + 
					"               S.CURRENCY         AS CURRENCY,\n" + 
					"               S.RATE             AS RATE,\n" + 
					"               S.BUGET_OUR        AS BUGET_OUR,\n" + 
					"               S.BUGET_LOCAL      AS BUGET_LOCAL,\n" + 
					"               S.STATUS           AS STATUS,\n" + 
					"               S.REMARK           AS REMARK,\n" + 
					"               S.BSFLAG           AS BSFLAG,\n" + 
					"               S.CREATOR          AS CREATOR,\n" + 
					"               S.CREATE_DATE      AS CREATE_DATE,\n" + 
					"               S.MODIFIER         AS MODIFIER,\n" + 
					"               S.MODIFI_DATE      AS MODIFI_DATE,\n" + 
					"               S.REPAIR_FORM_NAME AS REPAIR_FORM_NAME\n" + 
					"          FROM GMS_DEVICE_COLL_REPAIR_SEND S\n" + 
					"         WHERE 1 = 1\n" + 
					"           AND S.BSFLAG = '0'\n" + 
					"           AND S.STATUS = '0'\n" + 
					"        --          AND S.APPLY_ORG = ''\n" + 
					"        UNION ALL\n" + 
					"        SELECT T.ID               AS ID,\n" + 
					"               T.REPAIR_FORM_NO   AS REPAIR_FORM_NO,\n" + 
					"               T.APPLY_DATE       AS APPLY_DATE,\n" + 
					"               T.OWN_PROJECT      AS OWN_PROJECT,\n" + 
					"               T.APPLY_ORG        AS APPLY_ORG,\n" + 
					"               T.SERVICE_COMPANY  AS SERVICE_COMPANY,\n" + 
					"               T.CURRENCY         AS CURRENCY,\n" + 
					"               T.RATE             AS RATE,\n" + 
					"               T.BUGET_OUR        AS BUGET_OUR,\n" + 
					"               T.BUGET_LOCAL      AS BUGET_LOCAL,\n" + 
					"               T.STATUS           AS STATUS,\n" + 
					"               T.REMARK           AS REMARK,\n" + 
					"               T.BSFLAG           AS BSFLAG,\n" + 
					"               T.CREATOR          AS CREATOR,\n" + 
					"               T.CREATE_DATE      AS CREATE_DATE,\n" + 
					"               T.MODIFIER         AS MODIFIER,\n" + 
					"               T.MODIFI_DATE      AS MODIFI_DATE,\n" + 
					"               T.REPAIR_FORM_NAME AS REPAIR_FORM_NAME\n" + 
					"          FROM GMS_DEVICE_COLL_REPAIR_SEND T, COMMON_BUSI_WF_MIDDLE WFMIDDLE\n" + 
					"         WHERE T.BSFLAG = '0'\n" + 
					"           AND T.ID = WFMIDDLE.BUSINESS_ID(+)\n" + 
					"              --         AND T.APPLY_ORG = ''\n" + 
					"           AND WFMIDDLE.BSFLAG = '0'\n" + 
					"           AND WFMIDDLE.PROC_STATUS = '3'\n" + 
					"           AND T.ID NOT IN\n" + 
					"              ----返还不够的记录\n" + 
					"               (SELECT A.FORMID AS FORMID\n" + 
					"                  FROM (SELECT COUNT(1) AS COUNT1, SUB.SEND_FORM_ID AS FORMID\n" + 
					"                          FROM GMS_DEVICE_COLL_SEND_SUB SUB\n" + 
					"                         WHERE SUB.BSFLAG = 0\n" + 
					"                         GROUP BY SUB.SEND_FORM_ID) A,\n" + 
					"                       (SELECT COUNT(1) AS COUNT2,\n" + 
					"                               DETAIL.REPAIRFORM_ID AS FORMID\n" + 
					"                          FROM GMS_DEVICE_COL_REP_DETAIL DETAIL\n" + 
					"                         WHERE DETAIL.BSFLAG = 0\n" + 
					"                         GROUP BY DETAIL.REPAIRFORM_ID) B\n" + 
					"                 WHERE A.FORMID = B.FORMID\n" + 
					"                   AND A.COUNT1 = B.COUNT2)) DATA,\n" + 
					"       GP_TASK_PROJECT PRO,\n" + 
					"       COMM_ORG_INFORMATION REQORG,\n" + 
					"       COMM_HUMAN_EMPLOYEE CREUSER,\n" + 
					"       COMM_HUMAN_EMPLOYEE UPUSER,\n" + 
					"       GMS_DEVICE_COL_REP_FORM RTN,\n" + 
					"       (SELECT T.DICTKEY,\n" + 
					"               T.DICTDESC,\n" + 
					"               I.OPTIONVALUE,\n" + 
					"               I.OPTIONDESC,\n" + 
					"               I.DISPLAYORDER\n" + 
					"          FROM GMS_DEVICE_COMM_DICT T\n" + 
					"          JOIN GMS_DEVICE_COMM_DICT_ITEM I\n" + 
					"            ON T.ID = I.DICT_ID\n" + 
					"         WHERE T.BSFLAG = '0'\n" + 
					"           AND T.DICTKEY = 'currency') DICT\n" + 
					" WHERE DATA.OWN_PROJECT = PRO.PROJECT_INFO_NO(+)\n" + 
					"   AND DATA.APPLY_ORG = REQORG.ORG_ID(+)\n" + 
					"   AND DATA.CREATOR = CREUSER.EMPLOYEE_ID(+)\n" + 
					"   AND DATA.MODIFIER = UPUSER.EMPLOYEE_ID(+)\n" + 
					"   AND DATA.CURRENCY = DICT.OPTIONVALUE(+)\n" + 
					"   AND DATA.ID = RTN.SEND_ID(+)\n" + 
					"   AND RTN.ID = ? ";
		StringBuilder sql = new StringBuilder(str);
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<GmsDeviceCollRepairSend> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{rtnid}, new RowMapper<GmsDeviceCollRepairSend>(){
			@Override
			public GmsDeviceCollRepairSend mapRow(ResultSet rs, int rowNum) throws SQLException {
				GmsDeviceCollRepairSend m = new GmsDeviceCollRepairSend();
				m.setId(rs.getString(1));
				m.setRepair_form_no(rs.getString(2));
				m.setApply_date(rs.getDate(3));
				m.setOwn_project(rs.getString(4));
				m.setApply_org(rs.getString(5));
				m.setService_company(rs.getString(6));
				m.setCurrency(rs.getString(7));
				m.setRate(rs.getDouble(8));
				m.setBuget_our(rs.getDouble(9));
				m.setBuget_local(rs.getDouble(10));
				m.setStatus(rs.getString(11));
				m.setRemark(rs.getString(12));
				m.setBsflag(rs.getString(13));
				m.setCreator(rs.getString(14));
				m.setCreate_date(rs.getDate(15));
				m.setModifier(rs.getString(16));
				m.setModifi_date(rs.getDate(17));
				m.setRepair_form_name(rs.getString(18));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}

	@Override
	public List<GmsDeviceCollRepairform> downloadSelfRepairFormByRtnId(String rtnid) {
		String str = 
				//联表查询  start
				"select data.ID as id,\n" +
				"       data.REPAIR_FORM_CODE as REPAIR_FORM_CODE,\n" + 
				"       data.REPAIR_FORM_NAME as REPAIR_FORM_NAME,\n" + 
				"       data.APPLY_DATE as APPLY_DATE,\n" + 
				"       PRO.PROJECT_NAME         as OWN_PROJECT,\n" + 
				"       REQORG.ORG_ABBREVIATION  as REQ_COMP,\n" + 
				"       TODOORG.ORG_ABBREVIATION as TODO_COMP,\n" + 
				"       REQUSER.Employee_Name    as REQ_USER,\n" + 
				"       data.REQ_DATE as REQ_DATE,\n" + 
				"       data.STATUS as STATUS,\n" + 
				"       data.REMARK as REMARK,\n" + 
				"       data.BSFLAG as BSFLAG,\n" + 
				"       creUSER.Employee_Name    as CREATOR,\n" + 
				"       data.CREATE_DATE as CREATE_DATE,\n" + 
				"       upUSER.Employee_Name     as MODIFIER,\n" + 
				"       data.MODIFI_DATE as MODIFI_DATE,\n" + 
				"       PROCESS_STAT as PROCESS_STAT\n" + 
				"  from (" +
				//联表查询  end
				"SELECT f.ID as id,\n" +
						"       f.REPAIR_FORM_CODE as REPAIR_FORM_CODE,\n" + 
						"       f.REPAIR_FORM_NAME as REPAIR_FORM_NAME,\n" + 
						"       f.APPLY_DATE as APPLY_DATE,\n" + 
						"       f.OWN_PROJECT as OWN_PROJECT,\n" + 
						"       f.REQ_COMP as REQ_COMP,\n" + 
						"       f.TODO_COMP as TODO_COMP,\n" + 
						"       f.REQ_USER as REQ_USER,\n" + 
						"       f.REQ_DATE as REQ_DATE,\n" + 
						"       f.STATUS as STATUS,\n" + 
						"       f.REMARK as REMARK,\n" + 
						"       f.BSFLAG as BSFLAG,\n" + 
						"       f.CREATOR as CREATOR,\n" + 
						"       f.CREATE_DATE as CREATE_DATE,\n" + 
						"       f.MODIFIER as MODIFIER,\n" + 
						"       f.MODIFI_DATE as MODIFI_DATE,\n" + 
						"       f.PROCESS_STAT as PROCESS_STAT\n" + 
						"  FROM GMS_DEVICE_COLL_REPAIRFORM  f WHERE 1=1 AND f.BSFLAG = '0' AND f.STATUS = '0' \n" + 
						"  union all\n" + 
						"SELECT t.ID as ID,\n" + 
						"       t.REPAIR_FORM_CODE as REPAIR_FORM_CODE,\n" + 
						"       t.REPAIR_FORM_NAME as REPAIR_FORM_NAME,\n" + 
						"       t.APPLY_DATE as APPLY_DATE,\n" + 
						"       t.OWN_PROJECT as OWN_PROJECT,\n" + 
						"       t.REQ_COMP as REQ_COMP,\n" + 
						"       t.TODO_COMP as TODO_COMP,\n" + 
						"       t.REQ_USER as REQ_USER,\n" + 
						"       t.REQ_DATE as REQ_DATE,\n" + 
						"       t.STATUS as STATUS,\n" + 
						"       t.REMARK as REMARK,\n" + 
						"       t.BSFLAG as BSFLAG,\n" + 
						"       t.CREATOR as CREATOR,\n" + 
						"       t.CREATE_DATE as CREATE_DATE,\n" + 
						"       t.MODIFIER as MODIFIER,\n" + 
						"       t.MODIFI_DATE as MODIFI_DATE,\n" + 
						"       t.PROCESS_STAT as PROCESS_STAT\n" + 
						"  FROM GMS_DEVICE_COLL_REPAIRFORM t\n" + 
						" where t.BSFLAG = '0' AND t.STATUS = '1' \n" + 
						"   and t.id NOT in " + 
						//返还没完成的
						"(SELECT A.FORMID AS FORMID FROM\n" +
						"(SELECT COUNT(1) AS COUNT1, sub.REPAIRFORM_ID AS FORMID FROM   GMS_DEVICE_COLL_REPAIR_SUB sub\n" + 
						"WHERE sub.BSFLAG = 0  AND sub.DEV_STATUS > 2 GROUP BY sub.REPAIRFORM_ID) A,\n" + 
						"(SELECT COUNT(1) AS COUNT2, detail.REPAIRFORM_ID AS FORMID FROM   GMS_DEVICE_COL_REP_DETAIL detail\n" + 
						"WHERE detail.BSFLAG = 0 GROUP BY detail.REPAIRFORM_ID) B\n" + 
						"WHERE A.FORMID = B.FORMID\n" + 
						"AND A.COUNT1 = B.COUNT2)"+
						//联表查询  start
						") data,\n" +
						"       GP_TASK_PROJECT PRO,\n" + 
						"       COMM_ORG_INFORMATION REQORG,\n" + 
						"       COMM_ORG_INFORMATION TODOORG,\n" + 
						"       COMM_HUMAN_EMPLOYEE REQUSER,\n" + 
						"       COMM_HUMAN_EMPLOYEE CREUSER,\n" + 
						"       COMM_HUMAN_EMPLOYEE UPUSER,\n" + 
						"       GMS_DEVICE_COL_REP_FORM RTN\n" +
						" where data.OWN_PROJECT = pro.PROJECT_INFO_NO(+)\n" + 
						"   and data.REQ_COMP = REQORG.ORG_ID(+)\n" + 
						"   and data.TODO_COMP = TODOORG.Org_Id(+)\n" + 
						"   and data.REQ_USER = REQUSER.Employee_Id(+)\n" + 
						"   and data.CREATOR = CREUSER.Employee_Id(+)\n" + 
						"   and data.MODIFIER = UPUSER.Employee_Id(+) " +
						"   AND data.ID = RTN.SEND_ID(+)\n" + 
						"   AND RTN.ID = ? ";
		StringBuilder sql = new StringBuilder(str);
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<GmsDeviceCollRepairform> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{rtnid}, new RowMapper<GmsDeviceCollRepairform>(){
			@Override
			public GmsDeviceCollRepairform mapRow(ResultSet rs, int rowNum) throws SQLException {
				GmsDeviceCollRepairform m = new GmsDeviceCollRepairform();
				m.setId(rs.getString(1));
				m.setRepair_form_code(rs.getString(2));
				m.setRepair_form_name(rs.getString(3));
				m.setApply_date(rs.getDate(4));
				m.setOwn_project(rs.getString(5));
				m.setReq_comp(rs.getString(6));
				m.setTodo_comp(rs.getString(7));
				m.setReq_user(rs.getString(8));
				m.setReq_date(rs.getDate(9));
				m.setStatus(rs.getString(10));
				m.setRemark(rs.getString(11));
				m.setBsflag(rs.getString(12));
				m.setCreator(rs.getString(13));
				m.setCreate_date(rs.getDate(14));
				m.setModifier(rs.getString(15));
				m.setModifi_date(rs.getDate(16));
				m.setProcess_stat(rs.getString(17));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}*/
	@Override
	public List<GmsDeviceCollRepairSend> downloadVendorRepairFormByRtnId(String rtnid) {
		String str = 
				"select t.id                  as id,\n" +
						"       t.repair_form_no      as repair_form_no,\n" + 
						"       t.apply_date          as apply_date,\n" + 
						"       pro.project_name      as own_project,\n" + 
						"       req.org_abbreviation  as apply_org,\n" + 
						"       t.service_company     as service_company,\n" + 
						"       dict.optiondesc       as currency,\n" + 
						"       t.rate                as rate,\n" + 
						"       t.buget_our           as buget_our,\n" + 
						"       t.buget_local         as buget_local,\n" + 
						"       t.status              as status,\n" + 
						"       t.remark              as remark,\n" + 
						"       t.bsflag              as bsflag,\n" + 
						"       creuser.employee_name as creator,\n" + 
						"       t.create_date         as create_date,\n" + 
						"       upuser.employee_name  as modifier,\n" + 
						"       t.modifi_date         as modifi_date,\n" + 
						"       t.repair_form_name    as repair_form_name,\n" +
						"       t.return_flg \n" +
						"  from gms_device_coll_repair_send t,\n" + 
						"       gp_task_project pro,\n" + 
						"       comm_org_information req,\n" + 
						"       comm_human_employee creuser,\n" + 
						"       comm_human_employee upuser,\n" + 
						"       (select a.dictkey,\n" + 
						"               a.dictdesc,\n" + 
						"               i.optionvalue,\n" + 
						"               i.optiondesc,\n" + 
						"               i.displayorder\n" + 
						"          from gms_device_comm_dict a\n" + 
						"          join gms_device_comm_dict_item i\n" + 
						"            on a.id = i.dict_id\n" + 
						"         where a.bsflag = '0'\n" + 
						"           and a.dictkey = 'currency') dict\n" + 
						" where t.own_project = pro.project_info_no(+)\n" + 
						"   and t.apply_org = req.org_id(+)\n" + 
						"   and t.creator = creuser.employee_id(+)\n" + 
						"   and t.modifier = upuser.employee_id(+)\n" + 
						"   and t.currency = dict.optionvalue(+)" +
						"   AND t.ID = ? ";
		StringBuilder sql = new StringBuilder(str);
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<GmsDeviceCollRepairSend> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{rtnid}, new RowMapper<GmsDeviceCollRepairSend>(){
			@Override
			public GmsDeviceCollRepairSend mapRow(ResultSet rs, int rowNum) throws SQLException {
				GmsDeviceCollRepairSend m = new GmsDeviceCollRepairSend();
				m.setId(rs.getString(1));
				m.setRepair_form_no(rs.getString(2));
				m.setApply_date(rs.getDate(3));
				m.setOwn_project(rs.getString(4));
				m.setApply_org(rs.getString(5));
				m.setService_company(rs.getString(6));
				m.setCurrency(rs.getString(7));
				m.setRate(rs.getDouble(8));
				m.setBuget_our(rs.getDouble(9));
				m.setBuget_local(rs.getDouble(10));
				m.setStatus(rs.getString(11));
				m.setRemark(rs.getString(12));
				m.setBsflag(rs.getString(13));
				m.setCreator(rs.getString(14));
				m.setCreate_date(rs.getDate(15));
				m.setModifier(rs.getString(16));
				m.setModifi_date(rs.getDate(17));
				m.setRepair_form_name(rs.getString(18));
				m.setReturn_flg(rs.getString(19));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}

	@Override
	public List<GmsDeviceCollRepairform> downloadSelfRepairFormByRtnId(String rtnid) {
		String str = 
					" select f.ID                     as id,\n" +
					"       f.REPAIR_FORM_CODE       as REPAIR_FORM_CODE,\n" + 
					"       f.REPAIR_FORM_NAME       as REPAIR_FORM_NAME,\n" + 
					"       f.APPLY_DATE             as APPLY_DATE,\n" + 
					"       PRO.PROJECT_NAME         as OWN_PROJECT,\n" + 
					"       REQORG.ORG_ABBREVIATION  as REQ_COMP,\n" + 
					"       TODOORG.ORG_ABBREVIATION as TODO_COMP,\n" + 
					"       REQUSER.Employee_Name    as REQ_USER,\n" + 
					"       f.REQ_DATE               as REQ_DATE,\n" + 
					"       f.STATUS                 as STATUS,\n" + 
					"       f.REMARK                 as REMARK,\n" + 
					"       f.BSFLAG                 as BSFLAG,\n" + 
					"       creUSER.Employee_Name    as CREATOR,\n" + 
					"       f.CREATE_DATE            as CREATE_DATE,\n" + 
					"       upUSER.Employee_Name     as MODIFIER,\n" + 
					"       f.MODIFI_DATE            as MODIFI_DATE,\n" + 
					"       PROCESS_STAT             as PROCESS_STAT,\n" +
					"       f.RETURN_FLG\n" +
					"  FROM GMS_DEVICE_COLL_REPAIRFORM f,\n" + 
					"       GP_TASK_PROJECT            PRO,\n" + 
					"       COMM_ORG_INFORMATION       REQORG,\n" + 
					"       COMM_ORG_INFORMATION       TODOORG,\n" + 
					"       COMM_HUMAN_EMPLOYEE        REQUSER,\n" + 
					"       COMM_HUMAN_EMPLOYEE        CREUSER,\n" + 
					"       COMM_HUMAN_EMPLOYEE        UPUSER\n" + 
					" where f.OWN_PROJECT = pro.PROJECT_INFO_NO(+)\n" + 
					"   and f.REQ_COMP = REQORG.ORG_ID(+)\n" + 
					"   and f.TODO_COMP = TODOORG.Org_Id(+)\n" + 
					"   and f.REQ_USER = REQUSER.Employee_Id(+)\n" + 
					"   and f.CREATOR = CREUSER.Employee_Id(+)\n" + 
					"   and f.MODIFIER = UPUSER.Employee_Id(+)" +
					"   AND f.ID = ? ";
		StringBuilder sql = new StringBuilder(str);
		RADJdbcDao dao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<GmsDeviceCollRepairform> l = dao.getJdbcTemplate().query(sql.toString(), new Object[]{rtnid}, new RowMapper<GmsDeviceCollRepairform>(){
			@Override
			public GmsDeviceCollRepairform mapRow(ResultSet rs, int rowNum) throws SQLException {
				GmsDeviceCollRepairform m = new GmsDeviceCollRepairform();
				m.setId(rs.getString(1));
				m.setRepair_form_code(rs.getString(2));
				m.setRepair_form_name(rs.getString(3));
				m.setApply_date(rs.getDate(4));
				m.setOwn_project(rs.getString(5));
				m.setReq_comp(rs.getString(6));
				m.setTodo_comp(rs.getString(7));
				m.setReq_user(rs.getString(8));
				m.setReq_date(rs.getDate(9));
				m.setStatus(rs.getString(10));
				m.setRemark(rs.getString(11));
				m.setBsflag(rs.getString(12));
				m.setCreator(rs.getString(13));
				m.setCreate_date(rs.getDate(14));
				m.setModifier(rs.getString(15));
				m.setModifi_date(rs.getDate(16));
				m.setProcess_stat(rs.getString(17));
				m.setReturn_flg(rs.getString(18));
				return m;
			}});
		if(CollectionUtils.isNotEmpty(l)){
			return l;
		}else{
			return null;
		}
	}

	@Override
	public String getServerTime() {
		return DateUtil.getCurrentDateStr("yyyy-MM-dd HH:mm:ss");
	}
}
