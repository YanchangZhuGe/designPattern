package com.bgp.gms.service.rm.em.srv; 
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.*;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate; 
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * project: 东方物探生产管理系统
 * 
 * creator: 申文珮
 * 
 * creator time:2012-7-27
 * 
 * description:备注公共信息操作
 * 
 */
@SuppressWarnings("unchecked")
public class CommonRemarkSrv extends BaseService {
	IBaseDao baseDao = BeanFactory.getBaseDao();
 
	/**
	 *备注信息相关操作
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
 
	public ISrvMsg remarkOperation(ISrvMsg isrvmsg) throws Exception {
	 
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		String foreignKeyId = isrvmsg.getValue("foreignKeyId");
		String action = isrvmsg.getValue("action");
		if(action==null){//解决项目审批页面查看项目的时候备注隐藏保存按钮
			action="";
		}
		
		respMsg.setValue("foreignKeyId", foreignKeyId);
		respMsg.setValue("action", action);
		return respMsg;
	}
	
	public ISrvMsg moveTreeNodePosition(ISrvMsg isrvmsg) throws Exception {
		 
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
 
		String pkValue = isrvmsg.getValue("pkValue");               
		int index = Integer.parseInt(isrvmsg.getValue("index"));    //拖动的顺序 
		String oldParentId = isrvmsg.getValue("oldParentId");
		
		//根据  org_hr_id查询   orderNum  
		StringBuffer subsqla = new StringBuffer("select t1.org_hr_id,t1.org_hr_short_name from bgp_comm_org_hr t1 where t1.org_hr_parent_id='");
		subsqla.append(oldParentId).append("' order by t1.order_num");
	 
		List orgs =BeanFactory.getQueryJdbcDAO().queryRecords(subsqla.toString());
		
		for(int i=0;i<orgs.size();i++){
			// 移动位置
			Map org = (Map)orgs.get(i);
			String orgHrId = (String)org.get("orgHrId");
			if(pkValue.equals(orgHrId)){
				orgs.remove(i);
				orgs.add(index, org);
				break;
			}
		}
		// 写入新位置到数据库
		saveNewPosition(orgs);
		
		return respMsg;
	}
	/**
	 * 写入新位置到数据库
	 * @param orgs
	 */
	private void saveNewPosition(final List orgs){

		final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

    	JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();
    	
		String sql = "update bgp_comm_org_hr set order_num=? where org_hr_id=?";
		
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map data = null;
				try {
					data = (Map)orgs.get(i);
				} catch (Exception e) {
					
				}
				ps.setString(1, String.valueOf(1000+i));

				ps.setString(2, (String)data.get("orgHrId"));
			}

			public int getBatchSize() {
				return orgs.size();
			}
		};

		jdbcTemplate.batchUpdate(sql, setter);

	}
	
}
