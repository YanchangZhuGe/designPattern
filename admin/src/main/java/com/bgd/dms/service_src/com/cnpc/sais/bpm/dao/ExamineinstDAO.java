package com.cnpc.sais.bpm.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.sais.bpm.mail.MailUtil;
import com.cnpc.sais.bpm.pojo.WfRExamineinst;
import com.cnpc.sais.bpm.pojo.WfRProcinst;
import com.cnpc.sais.bpm.pojo.WfRTaskinst;
import com.cnpc.sais.bpm.util.DateUtil;
import com.cnpc.sais.bpm.util.WFConstant;

/** 
 * @author 夏烨  
 * @version 创建时间：2009-8-13 下午04:04:37 
 * 类说明 
 */
public class ExamineinstDAO {
	private IBaseDao baseDao = BeanFactory.getBaseDao();
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	public List queryList(String sql){
		return jdbcDao.queryRecords(sql);
	}
	public void saveExamineinst(List examineList,WfRProcinst wfRProcinst,WfRTaskinst wfRTaskinst){
			for(int j=0;j<examineList.size();j++)
			{
				WfRExamineinst wfRExamineinst=(WfRExamineinst)examineList.get(j);
				if(wfRExamineinst!=null&&wfRExamineinst.getExamineUserId()!=null)
				{
					//替换动态审批人员信息
					if(wfRExamineinst.getExamineUserId().equals(WFConstant.WF_PROCDEFINE_NODE_DYNAMICPEOPLE))
					{
					  wfRExamineinst.setExamineUserId(wfRProcinst.getCreateUser());
					}
					wfRExamineinst.setProcinstId(wfRProcinst.getEntityId());
					wfRExamineinst.setTaskinstId(wfRTaskinst.getEntityId());
//					baseDao.save(wfRExamineinst);
					//发送邮件
					this.sendMailToUser(wfRExamineinst.getExamineUserId(),wfRExamineinst.getNodeId());
				}else if(wfRExamineinst!=null&&wfRExamineinst.getExamineRoleId()!=null){
					wfRExamineinst.setProcinstId(wfRProcinst.getEntityId());
					wfRExamineinst.setTaskinstId(wfRTaskinst.getEntityId());
//					baseDao.save(wfRExamineinst);
				}
				//添加审批有效期
				this.addExpiryDate(wfRTaskinst.getNodeId(), wfRExamineinst);
				baseDao.save(wfRExamineinst);
			}
			
	}
	public WfRExamineinst queryExamineinstByID(String entityId)  {
	       return (WfRExamineinst)baseDao.get(WfRExamineinst.class, entityId);
		}

	public void saveExamineinst(WfRExamineinst wfRExamineinst) {
		baseDao.save(wfRExamineinst);
	}
	public void updateExamineinst(WfRExamineinst wfRExamineinst)  {
		baseDao.update(wfRExamineinst);
	}
	public void deleteExamineinstByProcInstId(String procinstId)  {
		String sql="procinstId ='"+procinstId+"'";
		baseDao.batchDelete(WfRExamineinst.class, sql);
	}
   
	/**
	 * 查询当前用户待审批列表信息
	 * @param sql
	 * @return
	 */
   public List queryExamineInstListByUser(String sql) {
		List examineInstList = new ArrayList();
		examineInstList = jdbcDao.queryRecords(sql);
		return examineInstList ;

	}
  
    /**
     * 查询流程变量信息
     * @param procInstId
     * @return
     */
	public List queryProcInstVarByID(String procInstId){
		List varList=new ArrayList();
		String sql="select * from wf_r_variableinst where PROCINST_ID='"+procInstId+"'";
		varList=jdbcDao.queryRecords(sql);
		return varList;
	}
	
	
	public List queryExaminsListByTaskId(String taskInstId){
		List examines=new ArrayList();
		String sql="select * from wf_r_examineinst  where TASKINST_ID='"+taskInstId+"'";
		examines=jdbcDao.queryRecords(sql);
		return examines;
	}
	
	
	/**
	 * 查询同一TASKINST下的用户审批实例
	 * @param taskInstID
	 * @param examineinstID
	 * @return
	 */
	public List queryOtherExamineInstList(String taskInstID,String examineinstID)
	{
		List examineInstList=new ArrayList();
		String sql="";
		String[] args=null;
		sql="from WfRExamineinst WHERE taskinstId=? and entityId!=? and state="+WFConstant.WF_EXAMINEINST_STATE_START+"";
		args=new String[]{taskInstID,examineinstID}; 
		
		examineInstList=baseDao.queryByHql(sql, args);
		return examineInstList;
	}
	/**
	 * 查询同一ProcInst下所有开启的用户审批实例
	 * @param taskInstID
	 * @param examineinstID
	 * @return
	 */
	public List queryProcInstExamineInstList(String procInstId)
	{
		List examineInstList=new ArrayList();
		String sql="";
		String[] args=null;
		sql="from WfRExamineinst WHERE procinstId=? and state="+WFConstant.WF_EXAMINEINST_STATE_START+"";
		args=new String[]{procInstId}; 
		
		examineInstList=baseDao.queryByHql(sql, args);
		return examineInstList;
	}
	public WfRExamineinst queryProcInstExamineInst(String procInstId)
	{
		List examineInstList=new ArrayList();
		String sql="";
		String[] args=null;
		sql="from WfRExamineinst where examineEndDate= (select max(examineEndDate) from WfRExamineinst WHERE procinstId=?)";
		//sql="from WfRExamineinst WHERE procinstId=? and ";
		args=new String[]{procInstId}; 
		
		examineInstList=baseDao.queryByHql(sql, args);
		if(examineInstList.size()>0){
			return (WfRExamineinst) examineInstList.get(0);
		}
		return null;
	}
	/**
	 * 根据节点ID和流程实例ID查询当前节点的审批信息
	 * @param nodeId
	 * @param procInstId
	 * @return
	 */
	public List queryExamineInstByNodeId(String nodeId,String procInstId)
	{
		List examineInstList=new ArrayList();
		String sql="";
		String[] args=null;
		sql="from WfRExamineinst WHERE procinstId=? and nodeId=? and state!="+WFConstant.WF_EXAMINEINST_STATE_START;
		args=new String[]{procInstId,nodeId}; 
		
		examineInstList=baseDao.queryByHql(sql, args);
		return examineInstList;
	}
	/**
	 * 根据procInstId 批量修改ExamineInst实例
	 * @param procInstId
	 */
	public void updateBatchExamineInst(String procInstId){
		String arg="procinstId ='"+procInstId+"'";
	    String sql="state ='"+WFConstant.WF_EXAMINEINST_STATE_CLOSE+"'";
		baseDao.batchUpdate(WfRExamineinst.class, sql, arg);
		
	}
	/**
	 * 发送邮件给审批人
	 * @param userId
	 */
	public void sendMailToUser(String userId,String nodeId) {
		String sql = "select EMAIL from  p_auth_user where user_id='" + userId+ "'";
		String sql1 = "select IS_MAIL_MESSAGE from  wf_d_node where ENTITY_ID='" + nodeId+ "'";
		List isMailMessages =jdbcDao.queryRecords(sql1);
		Map isMailmap = (Map) isMailMessages.get(0);
		String isMail= isMailmap.get("isMailMessage").toString();
		if(isMail!=null&&isMail.equals("true")){
//			List userModle = jdbcDao.queryRecords(sql);
//			Map map = (Map) userModle.get(0);
			Map map = jdbcDao.queryRecordBySQL(sql);
			String email = map.get("email").toString();
			 String[] to = {email}; //收件人
			MailUtil.sendMail("您有待审批信息", "您有待审批信息！注意审批", to);
		}
		
	}
	//给启动的流程审批实例计算有效日期
	public void addExpiryDate(String nodeId,WfRExamineinst wfRExamineinst){
		String sql = "select EXPIRY_DATE from  wf_d_node where ENTITY_ID ='" + nodeId+ "'";
		List nodes =jdbcDao.queryRecords(sql);
		Map nodeMap = (Map) nodes.get(0);
		String date="";
		DateUtil util=new DateUtil();
		String expiryDate=nodeMap.get("expiryDate").toString();
		if(expiryDate!=null&&!expiryDate.equals("0")&&!expiryDate.equals("")){
			date=util.DateAdd(util.GetDate(),Integer.parseInt(expiryDate),2);
			System.out.println("有效日期是:============================"+date);
			wfRExamineinst.setExpiryDate(date);
		}
	
	}
	/**
	 * 查询过期的审批实例
	 * @return
	 */
	public List queryExaminesExpiryDate(){
		List list=new ArrayList();
		DateUtil util=new DateUtil();
		String sql = "select PROC_E_NAME,PROC_VERSION,NODE_ID,PROCINST_ID,e.ENTITY_ID as examineinstId from  wf_r_examineinst e,wf_r_procinst p where  e.PROCINST_ID=p.ENTITY_ID and e.STATE='1' and e.EXPIRY_DATE >  '" + util.GetDate()+ "'";
		System.out.println("sql:"+sql);
		list=jdbcDao.queryRecords(sql);
		return list;
	}

	public List queryExaminesById(String procInstId,String nodeId){
		 List list=new ArrayList();
		 String examineSql="select * from wf_r_examineinst where PROCINST_ID='"+procInstId+"' and NODE_ID='"+nodeId+"'";
		 list=jdbcDao.queryRecords(examineSql);
		 return list;
	}
	/**
	 * 根据当前用户查询所有参与审批的流程实例信息
	 * @param userId
	 * @param roleId
	 * @param state
	 * @return
	 */
	public List queryProcInstByUser(String userId,String roleId,String state,String procId,String procType){
		List list=new ArrayList();
		String sql ="select ex.PROCINST_ID as procinstId ,ex.EXAMINE_START_DATE, " +
		" pr.* from wf_r_examineinst ex,wf_r_procinst pr" +
		" where ex.PROCINST_ID =pr.ENTITY_ID  and  " +
		" ex.EXAMINE_USER_ID='"+userId+"' " +
		" ";
		if(!state.equals("")){
			sql ="select ex.PROCINST_ID as procinstId ,ex.EXAMINE_START_DATE, " +
			" pr.* from wf_r_examineinst ex,wf_r_procinst pr" +
			" where ex.PROCINST_ID =pr.ENTITY_ID  and  " +
			" ex.EXAMINE_USER_ID='"+userId+"'" +
			"  and pr.state in("+state+") ";
		}
		if(!procId.equals("")){
		  sql=sql+" and ex.PROC_ID='"+procId+"'";
		}
		if(!procType.equals("")){
			  sql=sql+" and ex.PROC_TYPE='"+procType+"'";
			}
		 sql=sql+" and ex.STATE !='"+WFConstant.WF_EXAMINEINST_STATE_START+"' order by ex.EXAMINE_START_DATE desc";
		list=jdbcDao.queryRecords(sql);
		return list;
	}
	
	public PageModel queryProcInstByUserForPage(String userId,String roleId,String state,String procId,String procType,PageModel page){
//		List list=new ArrayList();
		String sql ="select ex.PROCINST_ID as procinstId ,ex.EXAMINE_START_DATE, " +
		" pr.* from wf_r_examineinst ex,wf_r_procinst pr" +
		" where ex.PROCINST_ID =pr.ENTITY_ID  and  " +
		" ex.EXAMINE_USER_ID='"+userId+"' " +
		" ";
		if(!state.equals("")){
			sql ="select ex.PROCINST_ID as procinstId ,ex.EXAMINE_START_DATE, " +
			" pr.* from wf_r_examineinst ex,wf_r_procinst pr" +
			" where ex.PROCINST_ID =pr.ENTITY_ID  and  " +
			" ex.EXAMINE_USER_ID='"+userId+"'" +
			"  and pr.state in("+state+") ";
		}
		if(!procId.equals("")){
		  sql=sql+" and ex.PROC_ID='"+procId+"'";
		}
		if(!procType.equals("")){
			  sql=sql+" and ex.PROC_TYPE in ("+procType+")";
			}
		 sql=sql+" and ex.STATE !='"+WFConstant.WF_EXAMINEINST_STATE_START+"' order by ex.EXAMINE_START_DATE desc";
		 sql = "SELECT rt.procinstid,rt.examine_start_date,rt.proc_name,rt.proc_e_name,rt.create_user, e2.create_date, e2.create_user_name, e.org_name  from  ("+sql+") rt  left join   wf_r_procinst e2   on e2.entity_id = rt.procinstId  left join p_auth_user e1    on e1.user_id = e2.create_user  left join comm_org_information e    on e.org_id = e1.org_id order by e2.create_date  desc ";
		 page = jdbcDao.queryRecordsBySQL(sql, page);

		return page;
	}
	
	public List queryProcInstByUserState(String userId,String roleId,String state,String examineinstState,String procId,String procType){
		List list=new ArrayList();
		String sql ="select distinct  ex.PROCINST_ID as procinstId ,ex.EXAMINE_START_DATE, " +
		" pr.* from wf_r_examineinst ex,wf_r_procinst pr" +
		" where ex.PROCINST_ID =pr.ENTITY_ID  and  " +
		" ex.EXAMINE_USER_ID='"+userId+"' " +
		" ";
		if(!state.equals("")){
			sql ="select distinct  ex.PROCINST_ID as procinstId ,ex.EXAMINE_START_DATE," +
			" pr.* from wf_r_examineinst ex,wf_r_procinst pr" +
			" where ex.PROCINST_ID =pr.ENTITY_ID  and  " +
			" ex.EXAMINE_USER_ID='"+userId+"'" +
			"  and pr.state in ("+state+")";
		}
		if(!procId.equals("")){
		  sql=sql+" and ex.PROC_ID='"+procId+"'";
		}
		if(!procType.equals("")){
			  sql=sql+" and ex.PROC_TYPE='"+procType+"'";
			}
		 sql=sql+" and ex.STATE !='"+WFConstant.WF_EXAMINEINST_STATE_START+"' and ex.STATE!='"+WFConstant.WF_EXAMINEINST_STATE_DOWM+"'  order by ex.EXAMINE_START_DATE desc";
		list=jdbcDao.queryRecords(sql);
		return list;
	}
	/**
	 * 查询同一TASKINST下的用户审批实例
	 * @param taskInstID
	 * @param examineinstID
	 * @return
	 */
	public List queryExaminesByTsakIdHQL(String taskInstId)
	{
		List examineInstList=new ArrayList();
		String sql="";
		String[] args=null;
		sql="from WfRExamineinst WHERE taskinstId=? ";
		args=new String[]{taskInstId}; 
		
		examineInstList=baseDao.queryByHql(sql, args);
		return examineInstList;
	}
public List queryCurrExamineinst(String procinstId){
		
		String sql = "select a from WfRExamineinst a where procinstId ='"+procinstId+"' and (examineEndDate != '' or examineEndDate is not null )  order by examineEndDate asc";
		String []arg1=new String[]{};
		return this.baseDao.queryByHql(sql, arg1);
	}
public List queryCurrExamineinstNode(String procinstId){
	
	String sql = "select b.node_name,a.examine_user_name,a.examine_end_date,a.state,a.examine_info,a.reason  from wf_r_examineinst a left join wf_d_node b on a.node_id=b.entity_id where (a.examine_end_date is not null or a.examine_end_date<>'') and a.procinst_id='"+procinstId+"' order by a.examine_end_date asc";
	
	return jdbcDao.queryRecords(sql);
}
}
