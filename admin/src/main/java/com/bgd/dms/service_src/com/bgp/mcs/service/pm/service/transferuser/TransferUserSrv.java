package com.bgp.mcs.service.pm.service.transferuser;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class TransferUserSrv extends BaseService{
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	IBaseDao baseDao = BeanFactory.getBaseDao();
	
	/**
	 * 根据指定传输用户编码查询传输用户信息
	 * @param gpBaseTransmitUser
	 * @param transUserNo
	 * @throws Exception
	 */
	public ISrvMsg getTransferUser(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String transUserNo = reqDTO.getValue("transUserNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer("select u.trans_user_no , u.trans_user_name ,(select WMSYS.WM_CONCAT(org_id) from gp_base_transmit_org b where b.trans_user_no = u.trans_user_no and b.bsflag='0') as org_ids, (select WMSYS.WM_CONCAT(project_info_no) from gp_base_user_project b where b.trans_user_no = u.trans_user_no and b.bsflag='0') as prj_ids ,(select WMSYS.WM_CONCAT(org_abbreviation) from comm_org_information a INNER join gp_base_transmit_org b on a.org_id = b.org_id where b.trans_user_no = u.trans_user_no and b.bsflag='0') as org_name,(select WMSYS.WM_CONCAT(project_name) from gp_task_project a INNER join gp_base_user_project b on a.project_info_no = b.project_info_no where b.trans_user_no = u.trans_user_no and b.bsflag='0') as prj_name from gp_base_transmit_user u where u.bsflag='0' ");

		Map transferUser = new HashMap();
		if(null != transUserNo && !"".equals(transUserNo)){
			sb.append(" and u.trans_user_no='").append(transUserNo).append("'");
			transferUser = jdbcDAO.queryRecordBySQL(sb.toString());
		}
	
		if (transferUser != null) {
			responseMsg.setValue("transferUser", transferUser);
		}

		return responseMsg;
	}
	
	/**
	 * 检查用户名是否存在
	 * @param transUserName
	 * @throws Exception
	 */
	public ISrvMsg checkUserNameExist(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String transUserName = reqDTO.getValue("transUserName");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer("select count(*) as cnt from gp_base_transmit_user u where bsflag='0' and trans_user_name='"+transUserName+"'");

		Map transferUser = jdbcDAO.queryRecordBySQL(sb.toString());
		String count="0";
		if (transferUser != null) {
			responseMsg.setValue("transferUser", transferUser);
			count =(String)transferUser.get("cnt");
		}
		responseMsg.setValue("count", count);
		return responseMsg;
	}
	
	/**
	 *  存储传输用户
	 * 
	 */
	public ISrvMsg addTransUser(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String transUserNo =jdbcDao.generateUUID();
		String transUserName = reqDTO.getValue("transUserName");
		String transUserPWD = reqDTO.getValue("password");
		String orgIds = reqDTO.getValue("orgIds");
		String projectInfoNos = reqDTO.getValue("projectInfoNos");
		String creator = user.getUserName();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		// 传输用户表中写入数据
		StringBuffer sbInsert = new StringBuffer("INSERT INTO gp_base_transmit_user(trans_user_no,trans_user_name,trans_user_password,modifi_date,create_date,creator,bsflag) ");
		sbInsert.append(" VALUES('").append(transUserNo).append("'");
		sbInsert.append(" ,'").append(transUserName).append("'");
		sbInsert.append(" ,'").append(transUserPWD).append("'");
		sbInsert.append(" ,sysdate");
		sbInsert.append(" ,sysdate");
		sbInsert.append(" ,'").append(creator).append("','0')");
		
		jdbcTemplate.execute(sbInsert.toString());
		
		// 传输用户对应队伍表中写入数据
		if(orgIds!=null && orgIds.length() > 0){
			String orgidArray[] = orgIds.split(",");
			for(int i=0; i<orgidArray.length; i++){
				String orgid = orgidArray[i];
				String trans_org_no = jdbcDao.generateUUID();
				StringBuffer sbInsertOrg = new StringBuffer("INSERT INTO gp_base_transmit_org(trans_org_no,trans_user_no,org_id,modifi_date,create_date,creator,bsflag) ");
				sbInsertOrg.append(" VALUES('").append(trans_org_no).append("'");
				sbInsertOrg.append(" ,'").append(transUserNo).append("'");
				sbInsertOrg.append(" ,'").append(orgid).append("'");
				sbInsertOrg.append(" ,sysdate");
				sbInsertOrg.append(" ,sysdate");
				sbInsertOrg.append(" ,'").append(creator).append("','0')");
				
				jdbcTemplate.execute(sbInsertOrg.toString());
			}
		}
		
		// 传输用户对应项目表中写入数据
		if(projectInfoNos!=null && projectInfoNos.length() > 0){
			String prjArray[] = projectInfoNos.split(",");
			for(int i=0; i<prjArray.length; i++){
				String prjno = prjArray[i];
				String trans_prj_no = jdbcDao.generateUUID();
				StringBuffer sbInsertPrj = new StringBuffer("INSERT INTO gp_base_user_project(trans_project_no,trans_user_no,project_info_no,modifi_date,create_date,creator,bsflag) ");
				sbInsertPrj.append(" VALUES('").append(trans_prj_no).append("'");
				sbInsertPrj.append(" ,'").append(transUserNo).append("'");
				sbInsertPrj.append(" ,'").append(prjno).append("'");
				sbInsertPrj.append(" ,sysdate");
				sbInsertPrj.append(" ,sysdate");
				sbInsertPrj.append(" ,'").append(creator).append("','0')");
				
				jdbcTemplate.execute(sbInsertPrj.toString());
			}
		}
		
		//根据传输用户Id，name新建一条客户端记录 
		String clientId = jdbcDao.generateUUID();
		StringBuffer sbInsertClient = new StringBuffer("INSERT INTO Oms_Down_Client(client_id,client_name,down_user_id,create_date,modifi_date,creator)");
		sbInsertClient.append("VALUES('");
		sbInsertClient.append(clientId).append("'");
		sbInsertClient.append(",'").append(transUserName).append("'");
		sbInsertClient.append(",'").append(transUserNo).append("'");
		sbInsertClient.append(",sysdate").append(",sysdate");
		sbInsertClient.append(",'").append(creator).append("'");
		sbInsertClient.append(")");
		
		jdbcTemplate.execute(sbInsertClient.toString());
		
		//将组全部赋给新建的客户端 
		StringBuffer sbQueryGroup = new StringBuffer("SELECT oms_tab_group_id , oms_tab_group_name FROM oms_down_tab_group");
		List<Map> listResult = jdbcDAO.queryRecords(sbQueryGroup.toString());
		if(listResult!=null && listResult.size()>0){
			for(int i=0; i<listResult.size(); i++){
				Map map = listResult.get(i);
				String oms_tab_group_id = (String) map.get("oms_tab_group_id");
				String clientGroupRelationId = jdbcDao.generateUUID();
				StringBuffer sbInsertClientGroup = new StringBuffer("INSERT INTO oms_client_group_relation(client_group_relation_id,oms_tab_group_id,client_id,create_date,modifi_date,creator,order_code)");
				sbInsertClientGroup.append("VALUES('");
				sbInsertClientGroup.append(clientGroupRelationId).append("'");
				sbInsertClientGroup.append(",'").append(oms_tab_group_id).append("'");
				sbInsertClientGroup.append(",'").append(clientId).append("'");
				sbInsertClientGroup.append(",sysdate,sysdate");
				sbInsertClientGroup.append(",'").append(creator).append("'");
				sbInsertClientGroup.append(",").append(i);
				sbInsertClientGroup.append(")");
				jdbcTemplate.execute(sbInsertClientGroup.toString());
			}
		}
		
		//将组表关系全部赋给新建的客户端 
		StringBuffer sbQueryGroupRel = new StringBuffer("SELECT group_tab_relation_id FROM oms_down_group_tab_relation");
		listResult = jdbcDAO.queryRecords(sbQueryGroupRel.toString());
		if(listResult!=null && listResult.size()>0){
			for(int i=0; i<listResult.size(); i++){
				Map map = listResult.get(i);
				String group_tab_relation_id = (String) map.get("group_tab_relation_id");
				String clientTabRelationId = jdbcDao.generateUUID();
				StringBuffer sbInsertClientGroupRel = new StringBuffer("INSERT INTO oms_client_tab_relation(client_tab_relation_id,group_tab_relation_id,client_id,last_down_date)");
				sbInsertClientGroupRel.append("VALUES('");
				sbInsertClientGroupRel.append(clientTabRelationId).append("'");
				sbInsertClientGroupRel.append(",'").append(group_tab_relation_id).append("'");
				sbInsertClientGroupRel.append(",'").append(clientId).append("'");
				sbInsertClientGroupRel.append(",to_date('2008-10-16','yyyy-MM-dd')");
				sbInsertClientGroupRel.append(")");	
				
				jdbcTemplate.execute(sbInsertClientGroupRel.toString());
			}			
		}
		
		responseMsg.setValue("actionStatus", "ok");
		return responseMsg;
	}
	
	/**
	 *  删除传输用户
	 * 
	 */
	public ISrvMsg deleteTransUser(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		String ids = reqDTO.getValue("transUserNo");
		String[] transUserNos = ids.split(",");
		//增加循环删除
		for (int i = 0; i < transUserNos.length; i++) {
			String transUserNo = transUserNos[i];
			StringBuffer sbQueryClient = new StringBuffer("SELECT client_id FROM Oms_Down_Client");
			sbQueryClient.append(" WHERE down_user_id='").append(transUserNo).append("'");
			Map map = jdbcDAO.queryRecordBySQL(sbQueryClient.toString());
			String clientId = "";
			if(map != null){
				clientId = (String) map.get("client_id");
			}
			//删除客户端配置
			if(clientId.length()> 0 ){
				jdbcTemplate.execute("delete from oms_client_group_relation where client_id = '"+clientId+"'");
				jdbcTemplate.execute("delete from oms_client_tab_relation where client_id = '"+clientId+"'");
				jdbcTemplate.execute("delete from oms_down_client where client_id = '"+clientId+"'");
			}
		
			StringBuffer sb1 = new StringBuffer("update gp_base_user_project set bsflag='1' ");
			sb1.append(" where trans_user_no ='"+transUserNo+"'");
			StringBuffer sb2 = new StringBuffer("update gp_base_transmit_org set bsflag='1' ");
			sb2.append(" where trans_user_no ='"+transUserNo+"'");
			StringBuffer sb3 = new StringBuffer("update gp_base_transmit_user set bsflag='1' ");
			sb3.append(" where trans_user_no ='"+transUserNo+"'");
		
			jdbcTemplate.execute(sb1.toString());
			jdbcTemplate.execute(sb2.toString());
			jdbcTemplate.execute(sb3.toString());
		}
		responseMsg.setValue("actionStatus", "ok");
		return responseMsg;
	}
	
	/**
	 *  修改传输用户
	 * 
	 */
	public ISrvMsg updateTransUser(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String transUserNo =reqDTO.getValue("transUserNo");
		String transUserName = reqDTO.getValue("transUserName");
		String transUserPWD = reqDTO.getValue("password");
		String orgIds = reqDTO.getValue("orgIds");
		String projectInfoNos = reqDTO.getValue("projectInfoNos");
		String updator = user.getUserName();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		//更新传输用户信息
		StringBuffer sbUpdateTransUser = new StringBuffer("UPDATE gp_base_transmit_user ");
		sbUpdateTransUser.append(" SET trans_user_name='").append(transUserName).append("'");
		sbUpdateTransUser.append(" , trans_user_password='").append(transUserPWD).append("'");
		sbUpdateTransUser.append(" , modifi_date = sysdate");
		sbUpdateTransUser.append(" , updator='").append(updator).append("'");
		sbUpdateTransUser.append(" where bsflag='0' and trans_user_no='").append(transUserNo).append("'");
		
		jdbcTemplate.execute(sbUpdateTransUser.toString());
		
		//更新队伍
		StringBuffer sbDeleteOrg = new StringBuffer("update gp_base_transmit_org set bsflag='1' ");
		sbDeleteOrg.append(" WHERE trans_user_no='").append(transUserNo).append("'");
		jdbcTemplate.execute(sbDeleteOrg.toString());
		if(orgIds!=null && orgIds.length() > 0){
			String orgidArray[] = orgIds.split(",");
			for(int i=0; i<orgidArray.length; i++){
				String orgid = orgidArray[i];
				String trans_org_no = jdbcDao.generateUUID();
				StringBuffer sbInsertOrg = new StringBuffer("INSERT INTO gp_base_transmit_org(trans_org_no,trans_user_no,org_id,modifi_date,create_date,creator,bsflag) ");
				sbInsertOrg.append(" VALUES('").append(trans_org_no).append("'");
				sbInsertOrg.append(" ,'").append(transUserNo).append("'");
				sbInsertOrg.append(" ,'").append(orgid).append("'");
				sbInsertOrg.append(" ,sysdate");
				sbInsertOrg.append(" ,sysdate");
				sbInsertOrg.append(" ,'").append(updator).append("','0')");
				
				jdbcTemplate.execute(sbInsertOrg.toString());
			}
		}
		
		//更新项目
		StringBuffer sbDeletePrj = new StringBuffer("update gp_base_user_project set bsflag='1' ");
		sbDeletePrj.append(" WHERE trans_user_no='").append(transUserNo).append("'");
		jdbcTemplate.execute(sbDeletePrj.toString());
		if(projectInfoNos!=null && projectInfoNos.length() > 0){
			String prjArray[] = projectInfoNos.split(",");
			for(int i=0; i<prjArray.length; i++){
				String prjno = prjArray[i];
				String trans_prj_no = jdbcDao.generateUUID();
				StringBuffer sbInsertPrj = new StringBuffer("INSERT INTO gp_base_user_project(trans_project_no,trans_user_no,project_info_no,modifi_date,create_date,creator,bsflag) ");
				sbInsertPrj.append(" VALUES('").append(trans_prj_no).append("'");
				sbInsertPrj.append(" ,'").append(transUserNo).append("'");
				sbInsertPrj.append(" ,'").append(prjno).append("'");
				sbInsertPrj.append(" ,sysdate");
				sbInsertPrj.append(" ,sysdate");
				sbInsertPrj.append(" ,'").append(updator).append("','0')");
				
				jdbcTemplate.execute(sbInsertPrj.toString());
			}
		}
		
		//更新客户端配置
		StringBuffer sbUpdateClient = new StringBuffer("UPDATE Oms_Down_Client");
		sbUpdateClient.append(" SET client_name='").append(transUserName).append("'");
		sbUpdateClient.append(" WHERE down_user_id='").append(transUserNo).append("'");
		jdbcTemplate.execute(sbUpdateClient.toString());
		
		StringBuffer sbQueryClient = new StringBuffer("SELECT client_id FROM Oms_Down_Client");
		sbQueryClient.append(" WHERE down_user_id='").append(transUserNo).append("'");
		Map map1 = jdbcDAO.queryRecordBySQL(sbQueryClient.toString());
		String clientId = "";
		if(map1 != null){
			clientId = (String) map1.get("client_id");
			jdbcTemplate.execute("delete from oms_client_group_relation where client_id = '"+clientId+"'");
			jdbcTemplate.execute("delete from oms_client_tab_relation where client_id = '"+clientId+"'");	
		}
		//
		//将组全部赋给新建的客户端 
		StringBuffer sbQueryGroup = new StringBuffer("SELECT oms_tab_group_id , oms_tab_group_name FROM oms_down_tab_group");
		List<Map> listResult = jdbcDAO.queryRecords(sbQueryGroup.toString());
		if(listResult!=null && listResult.size()>0){
			for(int i=0; i<listResult.size(); i++){
				Map map = listResult.get(i);
				String oms_tab_group_id = (String) map.get("oms_tab_group_id");
				String clientGroupRelationId = jdbcDao.generateUUID();
				StringBuffer sbInsertClientGroup = new StringBuffer("INSERT INTO oms_client_group_relation(client_group_relation_id,oms_tab_group_id,client_id,create_date,modifi_date,creator,order_code)");
				sbInsertClientGroup.append("VALUES('");
				sbInsertClientGroup.append(clientGroupRelationId).append("'");
				sbInsertClientGroup.append(",'").append(oms_tab_group_id).append("'");
				sbInsertClientGroup.append(",'").append(clientId).append("'");
				sbInsertClientGroup.append(",sysdate,sysdate");
				sbInsertClientGroup.append(",'").append(updator).append("'");
				sbInsertClientGroup.append(",").append(i);
				sbInsertClientGroup.append(")");
				jdbcTemplate.execute(sbInsertClientGroup.toString());
			}
		}
		
		//将组表关系全部赋给新建的客户端 
		StringBuffer sbQueryGroupRel = new StringBuffer("SELECT group_tab_relation_id FROM oms_down_group_tab_relation");
		listResult = jdbcDAO.queryRecords(sbQueryGroupRel.toString());
		if(listResult!=null && listResult.size()>0){
			for(int i=0; i<listResult.size(); i++){
				Map map = listResult.get(i);
				String group_tab_relation_id = (String) map.get("group_tab_relation_id");
				String clientTabRelationId = jdbcDao.generateUUID();
				StringBuffer sbInsertClientGroupRel = new StringBuffer("INSERT INTO oms_client_tab_relation(client_tab_relation_id,group_tab_relation_id,client_id,last_down_date)");
				sbInsertClientGroupRel.append("VALUES('");
				sbInsertClientGroupRel.append(clientTabRelationId).append("'");
				sbInsertClientGroupRel.append(",'").append(group_tab_relation_id).append("'");
				sbInsertClientGroupRel.append(",'").append(clientId).append("'");
				sbInsertClientGroupRel.append(",to_date('2008-10-16','yyyy-MM-dd')");
				sbInsertClientGroupRel.append(")");	
				
				jdbcTemplate.execute(sbInsertClientGroupRel.toString());
			}
		}
		return responseMsg;
	}
}
