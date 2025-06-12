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
 * project: ������̽��������ϵͳ
 * 
 * creator: ���ī�
 * 
 * creator time:2012-7-27
 * 
 * description:��ע������Ϣ����
 * 
 */
@SuppressWarnings("unchecked")
public class CommonRemarkSrv extends BaseService {
	IBaseDao baseDao = BeanFactory.getBaseDao();
 
	/**
	 *��ע��Ϣ��ز���
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
 
	public ISrvMsg remarkOperation(ISrvMsg isrvmsg) throws Exception {
	 
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		String foreignKeyId = isrvmsg.getValue("foreignKeyId");
		String action = isrvmsg.getValue("action");
		if(action==null){//�����Ŀ����ҳ��鿴��Ŀ��ʱ��ע���ر��水ť
			action="";
		}
		
		respMsg.setValue("foreignKeyId", foreignKeyId);
		respMsg.setValue("action", action);
		return respMsg;
	}
	
	public ISrvMsg moveTreeNodePosition(ISrvMsg isrvmsg) throws Exception {
		 
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
 
		String pkValue = isrvmsg.getValue("pkValue");               
		int index = Integer.parseInt(isrvmsg.getValue("index"));    //�϶���˳�� 
		String oldParentId = isrvmsg.getValue("oldParentId");
		
		//����  org_hr_id��ѯ   orderNum  
		StringBuffer subsqla = new StringBuffer("select t1.org_hr_id,t1.org_hr_short_name from bgp_comm_org_hr t1 where t1.org_hr_parent_id='");
		subsqla.append(oldParentId).append("' order by t1.order_num");
	 
		List orgs =BeanFactory.getQueryJdbcDAO().queryRecords(subsqla.toString());
		
		for(int i=0;i<orgs.size();i++){
			// �ƶ�λ��
			Map org = (Map)orgs.get(i);
			String orgHrId = (String)org.get("orgHrId");
			if(pkValue.equals(orgHrId)){
				orgs.remove(i);
				orgs.add(index, org);
				break;
			}
		}
		// д����λ�õ����ݿ�
		saveNewPosition(orgs);
		
		return respMsg;
	}
	/**
	 * д����λ�õ����ݿ�
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
