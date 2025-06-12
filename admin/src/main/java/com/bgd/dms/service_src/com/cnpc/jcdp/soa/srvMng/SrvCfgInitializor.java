package com.cnpc.jcdp.soa.srvMng;

import java.io.InputStream;
import java.sql.ResultSet;
import java.util.Properties;

import com.cnpc.jcdp.cfg.PropertyConfig;
import com.cnpc.jcdp.cfg.SpringFactory;
import com.cnpc.jcdp.common.IAutoRunBean;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.srvMng.pojo.MessageConfig;
import com.cnpc.jcdp.srvMng.pojo.OperationConfig;
import com.cnpc.jcdp.srvMng.pojo.ServiceConfig;
import com.cnpc.jcdp.util.db.DBConnConfig;
import com.cnpc.jcdp.util.db.JDBCHandler;



public class SrvCfgInitializor implements IAutoRunBean{
	protected ILog log = LogFactory.getLogger(SrvCfgInitializor.class);

	private JDBCHandler handler;
	
	public void run(){
		try{
			Properties srvDbCfg = new Properties();
			InputStream confs_is = PropertyConfig.class.getClassLoader().getResourceAsStream("dbConfig.properties");
			if(confs_is!=null){
				srvDbCfg.load(confs_is);
				confs_is.close();
			}		
			DBConnConfig dbCfg = new DBConnConfig();
			dbCfg.setDriverClass(srvDbCfg.getProperty("srvDb.driver"));
			dbCfg.setConnUrl(srvDbCfg.getProperty("srvDb.driverUrl"));
			dbCfg.setUserName(srvDbCfg.getProperty("srvDb.user"));
			dbCfg.setPassword(srvDbCfg.getProperty("srvDb.password"));
			
/*			dbCfg.setDriverClass(cfgHdl.getSingleNodeValue("//serviceCfg_db_info/driver"));
			dbCfg.setConnUrl(cfgHdl.getSingleNodeValue("//serviceCfg_db_info/url"));
			dbCfg.setUserName(cfgHdl.getSingleNodeValue("//serviceCfg_db_info/user"));
			dbCfg.setPassword(cfgHdl.getSingleNodeValue("//serviceCfg_db_info/password"));*/
			handler = new JDBCHandler(dbCfg);
			SrvCfgPool.clearPool();
			readSrvCfgs();
		}
		catch(Exception ex){
			//ex.printStackTrace();
			log.error(ex);
		}	
		finally{
			if(handler!=null) handler.close();
		}
	}
	
	private void readSrvCfgs()throws Exception{
		StringBuffer sb = new StringBuffer();
		//read service config
		sb.append("SELECT * FROM sys_config_service_dms");
		ResultSet rs = handler.query(sb.toString());		
		while(rs.next()){
			ServiceConfig srvCfg = new ServiceConfig(rs);			
			SrvCfgPool.putServiceConfig(srvCfg);	
			//同时动态构造一个bean的定义文件，放入这个服务的定义
			if(srvCfg.getClsName()!=null && !srvCfg.getClsName().equals("")){
				SpringFactory.initServiceBean(srvCfg.toMap());
			}
		}
		handler.closeQuery();
		//服务加载完成后，由SpringFacory一次读取到spring上下文中
		SpringFactory.loadServiceBean();
		
		//read operation config
		sb.setLength(0);
		sb.append("SELECT op.*,srv.service_name ");
		sb.append(" FROM sys_config_operation_dms op,sys_config_service_dms srv");
		sb.append(" WHERE op.service_id=srv.service_id");
		log.debug(sb.toString());
		rs = handler.query(sb.toString());	
		while(rs.next()){
			OperationConfig opCfg = new OperationConfig(rs);
			SrvCfgPool.putOperationConfig(rs.getString("service_name"), opCfg);			
		}
		handler.closeQuery();		
		
		//read message config
		sb.setLength(0);
		sb.append("SELECT msg_code,CN_msg,EN_MSG,OTHER_MSG ");
		sb.append(" FROM sys_config_message_dms");
		log.debug(sb.toString());
		rs = handler.query(sb.toString());	
		while(rs.next()){
			MessageConfig msg = new MessageConfig(rs);
			SrvCfgPool.putMsgConfig(msg);		
		}
		handler.closeQuery();		
	}
	
	public static void main(String[] args){
		SrvCfgInitializor init = new SrvCfgInitializor();
		init.run();
	}
}
