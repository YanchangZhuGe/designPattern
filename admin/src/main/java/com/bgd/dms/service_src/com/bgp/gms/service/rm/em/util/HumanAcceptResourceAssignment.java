package com.bgp.gms.service.rm.em.util;

import java.sql.Timestamp;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.xml.bind.JAXBElement;
import javax.xml.namespace.QName;

import com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.ResourceAssignmentWSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.primavera.ws.p6.resourceassignment.ResourceAssignment;

public class HumanAcceptResourceAssignment {
	
	
	RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	/**
	 * 人员接收修改p6状态
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public void saveP6ResourceAssignment() throws Exception {
		
		UserToken user = null;
		Timestamp t = getInterExecDate("P6_Resource.humanAcceptToP6", "C6000000000001");
		Timestamp newT = new Timestamp(System.currentTimeMillis());
		ResourceAssignmentWSBean rab = new ResourceAssignmentWSBean();
		int currPage=1;
		int pageSize=100;
		
		//将物探中正式员工新增的任务同步到P6
		while(true){
			
			List ral = new ArrayList();

			PageModel page = new PageModel();
			page.setCurrPage(currPage);
			page.setPageSize(pageSize);
			
			List datas = queryGMSHumanAccept(page, t);

			// last page
			if(datas.size()==0){
				break;
			}
						
			for(int i=0;i<datas.size();i++){
				ResourceAssignment ra = new ResourceAssignment();
				Map data = (Map)datas.get(i);
				
				ra.setActivityObjectId(Integer.parseInt((String)data.get("activityId")));
				ra.setResourceObjectId(new JAXBElement<Integer>(new QName("ResourceObjectId"), Integer.class, Integer.parseInt((String)data.get("resourceId"))));
				
				ral.add(ra);
			}
			
			List list = rab.saveResourceAssignmentToP6(user, ral);
			
			for(int m=0;m<list.size();m++){
				System.out.println(list.get(m));
			}
			
			currPage++;
			
		}
		
		currPage=1;
		
		//将物探中临时工的任务同步到P6
		while(true){
			
			List ral = new ArrayList();

			PageModel page = new PageModel();
			page.setCurrPage(currPage);
			page.setPageSize(pageSize);
			
			List datas = queryGMSLaborAccept(page, t);

			// last page
			if(datas.size()==0){
				break;
			}
						
			for(int i=0;i<datas.size();i++){
				ResourceAssignment ra = new ResourceAssignment();
				Map data = (Map)datas.get(i);
				
				ra.setActivityObjectId(Integer.parseInt((String)data.get("activityId")));
				ra.setResourceObjectId(new JAXBElement<Integer>(new QName("ResourceObjectId"), Integer.class, Integer.parseInt((String)data.get("resourceId"))));
					
				ral.add(ra);
			}
			
			List list = rab.saveResourceAssignmentToP6(user, ral);
			
			for(int m=0;m<list.size();m++){
				System.out.println(list.get(m));
			}
			
			currPage++;
			
		}

		
		setInterExecDate("P6_Resource.humanAcceptToP6", "C6000000000001", newT);

	}
	
    public Timestamp getInterExecDate(String interId, String orgId){

    	List list = jdbcDao.getJdbcTemplate().queryForList("select exec_date from bgp_inter_manage where inter_id='"+interId+"' and exec_org_id='"+orgId+"'");
    	
    	if(list!=null && list.size()>0){

        	Map map = (Map)list.get(0);
        	
    		return (Timestamp)map.get("exec_date");
    	}else {
    		return new Timestamp(0);
    	}
    }
    
    /**
     * 设置接口的最后执行时间
     * @return
     */
    public void setInterExecDate(String interId, String orgId, Timestamp t){

    	int i = jdbcDao.getJdbcTemplate().update("update bgp_inter_manage set exec_date=? where inter_id=? and exec_org_id=?", new Object[]{t, interId, orgId}, new int[]{Types.TIMESTAMP, Types.VARCHAR, Types.VARCHAR});
    	
    	if(i==0){ // no update
    		jdbcDao.getJdbcTemplate().update("insert into bgp_inter_manage (exec_date, inter_id, exec_org_id) values(?,?,?)", new Object[]{t, interId, orgId}, new int[]{Types.TIMESTAMP, Types.VARCHAR, Types.VARCHAR});
    	}
    }
    
    public List queryGMSHumanAccept(PageModel page, Timestamp t){

		List list = BeanFactory.getQueryJdbcDAO().queryRecordsBySQL("select a.object_id activity_id,a.name activity_name,a.planned_start_date,a.planned_finish_date,a.planned_duration,r.object_id resource_id,r.name resource_name from bgp_comm_human_receive_process t inner join bgp_p6_activity a on t.task_id=a.id and a.bsflag='0' inner join comm_human_employee_hr hr on t.employee_id=hr.employee_id and hr.bsflag='0' inner join bgp_p6_resource r on r.id=hr.employee_cd where t.bsflag='0' and t.modifi_date>to_date('"+new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(t)+"','yyyy-MM-dd hh24:mi:ss')", page).getData();
		
		return list;
    }
    
    
    
    public List queryGMSLaborAccept(PageModel page, Timestamp t){

		List list = BeanFactory.getQueryJdbcDAO().queryRecordsBySQL("select a.object_id activity_id,a.name activity_name, a.planned_start_date, a.planned_finish_date, a.planned_duration, r.object_id resource_id,r.name resource_name from bgp_comm_human_receive_labor t inner join bgp_p6_activity a on t.task_id=a.id and a.bsflag = '0' inner join bgp_comm_human_labor l on t.labor_id=l.labor_id and l.bsflag='0' inner join bgp_p6_resource r on r.id = l.employee_id_code_no where t.bsflag = '0' and t.modifi_date > to_date('"+new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(t)+"', 'yyyy-MM-dd hh24:mi:ss')", page).getData();
		
		return list;
    }
    
    
    public static void main(String[] args) throws Exception {
    	
    	HumanAcceptResourceAssignment a = new HumanAcceptResourceAssignment();
    	a.saveP6ResourceAssignment();
    	
    }

}
