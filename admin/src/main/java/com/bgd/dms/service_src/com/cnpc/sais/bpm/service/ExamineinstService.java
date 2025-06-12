package com.cnpc.sais.bpm.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.sais.bpm.dao.ExamineinstDAO;
import com.cnpc.sais.bpm.dao.ProcInstDAO;
import com.cnpc.sais.bpm.dao.TaskInstDAO;
import com.cnpc.sais.bpm.pojo.WfRExamineinst;
import com.cnpc.sais.bpm.runtime.entity.inst.ProcInstEntity;
import com.cnpc.sais.bpm.util.WFConstant;
import com.cnpc.sais.bpm.util.WFUtils;

/** 
 * @author 夏烨  
 * @version 创建时间：2009-8-19 下午02:21:00 
 * 类说明 
 */
public class ExamineinstService {
	private ExamineinstDAO examineinstDAO;

	private ProcInstDAO procInstDAO;
	
    private TaskInstDAO taskInstDAO;

    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	private String parseRoleId(String roleId) {
		String newRoleId = "";
		if (roleId != null && !roleId.equals("")) {
			String[] roleIds = roleId.split(",");
			for (int i = 0; i < roleIds.length; i++) {
				String id = roleIds[i];
				newRoleId = newRoleId + "'" + id + "',";
			}
			if (newRoleId.length() > 0) {
				newRoleId = newRoleId.substring(0, newRoleId.length() - 1);
			}
		}

		return newRoleId;
	}
	private String parseSQL(String sql,String[] args,String procType,String procId)
	{
		String tempStr=" ";
		if(args!=null && args[0]!=null){
			sql= sql + " ( ";
			tempStr="(";
			if(args[0]!=null&&!args[0].equals("")){
				sql=sql+args[0]  ;
				tempStr+=args[0] ;
				if(args[1]==null||args[1].equals("")){
					sql=sql+ " )  and  ";
					tempStr+=" )  and ";
				}
			}
			if(args[1]!=null&&!args[1].equals("")){
				if(args[0]!=null&&!args[0].equals("")){
				  sql=sql+" or "+args[1]+" )";
				  tempStr+=" or "+args[1]+" )";
				}else{
				  sql=sql+args[1] +" )";
				  tempStr+=args[1] +" )";
				}
				
			}
			sql=sql+"  state="+ WFConstant.WF_EXAMINEINST_STATE_START;
			tempStr+="   state="+ WFConstant.WF_EXAMINEINST_STATE_START;
			if(procType!=null&&!procType.equals("")){
				int ptl = procType.length();
				if(ptl == 20){
					sql=sql+" and PROC_TYPE in ("+procType.substring(0, ptl-1)+") ";
					tempStr+=" and PROC_TYPE in ("+procType.substring(0, ptl-1)+")";
				} else {
					sql=sql+" and PROC_TYPE in ("+procType+") ";
					tempStr+=" and PROC_TYPE in ("+procType+")";
				}
	
			}
			if(procId!=null&&!procId.equals("")){
				sql=sql+" and PROC_ID='"+procId+"'";
				tempStr+=" and PROC_ID='"+procId+"'";
			}
			sql=sql+" group by TASKINST_ID ";
			
			sql=sql+" ) group by TASKINST_ID )  and "+tempStr+" order by EXAMINE_START_DATE desc";
		} else {
			 
			sql=sql+"  state="+ WFConstant.WF_EXAMINEINST_STATE_START;
			tempStr+="   state="+ WFConstant.WF_EXAMINEINST_STATE_START;
			if(procType!=null&&!procType.equals("")){
				int ptl = procType.length();
				if(ptl == 20){
					sql=sql+" and PROC_TYPE in ("+procType.substring(0, ptl-1)+") ";
					tempStr+=" and PROC_TYPE in ("+procType.substring(0, ptl-1)+")";
				} else {
					sql=sql+" and PROC_TYPE in ("+procType+") ";
					tempStr+=" and PROC_TYPE in ("+procType+")";
				}
	
			}
			if(procId!=null&&!procId.equals("")){
				sql=sql+" and PROC_ID='"+procId+"'";
				tempStr+=" and PROC_ID='"+procId+"'";
			}
			sql=sql+" group by TASKINST_ID ";
			sql=sql+" ) group by TASKINST_ID )  and "+tempStr+" order by EXAMINE_START_DATE desc";
		}
		
		return sql;
	}
	/**
	 * 把流程变量添加到每个待审批实例中
	 * @param examineInstList
	 * @return
	 */
	private List CreateVarInExamineInst(List examineInstList){
		List list=new ArrayList();
		for(int j=0;j<examineInstList.size();j++){
			Map map=(Map)examineInstList.get(j);
			List varList=this.getExamineinstDAO().queryProcInstVarByID(map.get("procinstId").toString());
			String sql="select * from wf_d_procdefine where entity_id = '"+map.get("procId").toString()+"'";
			List<Map>procdefinelist=this.getExamineinstDAO().queryList(sql);
			if(procdefinelist!=null && !procdefinelist.isEmpty()){
				map.put("isToSync", (procdefinelist.get(0)).get("isToSync"));
			}
			for(int k=0;k<varList.size();k++){
		        Map assortMap=(Map)varList.get(k);
				Iterator iterator2 =assortMap.keySet().iterator();
				while (iterator2.hasNext()) { 
					String key=(String)iterator2.next(); 
					if(assortMap.get(key)!=null&&key.equals("varName"))
					{
						map.put(assortMap.get(key), assortMap.get("varValue"));
					}
					
			      }
				
			}
			list.add(map);
		}
		return list;
		
	}
	/**
	 * 查询当前用户的待审批信息
	 * @param procType
	 * @param examineUserId
	 * @param examineRoleId
	 * @return
	 */
	
    public List queryExamineInstList(String procType,String examineUserId,String examineRoleId,String procId)
	{
    	//将角色Id转换成'32103131','31131' 格式
		examineRoleId = this.parseRoleId(examineRoleId);
//		String sql = "select p.ENTITY_ID,p.PROC_ID,p.REASON,p.ISPASS,p.EXAMINE_INFO," +
//				     " p.PROC_TYPE,PROCINST_ID,STATE,p.EXAMINE_USER_NAME,p.EXAMINE_USER_ID,"+
//                     " p.NODE_ID,p.EXAMINE_START_DATE,p.EXAMINE_END_DATE,p.SUPER_EXAMINEINST," +
//                     " p.NODELEV,p.TASKINST_ID,p.EXAMINE_ROLE_ID,p.EXAMINE_ROLE_NAME,"+
//                     " p.ORG_ID,p.EXPIRY_DATE from Wf_R_Examineinst p WHERE (";
		String sql = "select * from Wf_R_Examineinst where ENTITY_ID in "
				+ "(select min( ENTITY_ID) from Wf_R_Examineinst where  examine_User_Id ='"+examineUserId+"' and TASKINST_ID in "
				+ "(select TASKINST_ID " + " from Wf_R_Examineinst p WHERE (";
		String sqlArgs[] = new String[2];// 记录角色 、用户的SQL条件

		if (examineUserId != null && !examineUserId.equals("")) {
			sqlArgs[0] = " examine_User_Id ='" + examineUserId + "'";
		}
		if (examineRoleId != null && !examineRoleId.equals("")) {
			sqlArgs[1] = " examine_Role_Id in(" + examineRoleId + ")";
		}
		//添加条件角色、人员、流程类型查询条件
		sql=parseSQL(sql ,sqlArgs,procType,procId);
		//修改人 吴海军，按提交排序
		sql = "select rt.*,t.create_date from wf_r_procinst t , ("+sql+") rt where  t.entity_id =rt.procinst_id order by t.create_date  desc ";
		List examineInstList=this.getExamineinstDAO().queryExamineInstListByUser(sql);
		
		return  this.CreateVarInExamineInst(examineInstList);
		
	}
    
    /**
     * 
    * @Title: queryExamineInstListForPage
    * @Description: 流程分页方法 2013-8-14（）
    * @param @param procType
    * @param @param examineUserId
    * @param @param examineRoleId
    * @param @param procId
    * @param @param page
    * @param @return    设定文件
    * @return List    返回类型
    * @throws
     */
    public PageModel queryExamineInstListForPage(String procType,String examineUserId,String examineRoleId,String procId,PageModel page,String noFilter)
   	{
       	//将角色Id转换成'32103131','31131' 格式
   		examineRoleId = this.parseRoleId(examineRoleId);
//   		String sql = "select p.ENTITY_ID,p.PROC_ID,p.REASON,p.ISPASS,p.EXAMINE_INFO," +
//   				     " p.PROC_TYPE,PROCINST_ID,STATE,p.EXAMINE_USER_NAME,p.EXAMINE_USER_ID,"+
//                        " p.NODE_ID,p.EXAMINE_START_DATE,p.EXAMINE_END_DATE,p.SUPER_EXAMINEINST," +
//                        " p.NODELEV,p.TASKINST_ID,p.EXAMINE_ROLE_ID,p.EXAMINE_ROLE_NAME,"+
//                        " p.ORG_ID,p.EXPIRY_DATE from Wf_R_Examineinst p WHERE (";
   		String examUserId = " examine_User_Id ='"+examineUserId+"'  and  ";  
   		if(("1").equals(noFilter)){
   			examUserId = "";
   		}
   		String sql = "select * from Wf_R_Examineinst where ENTITY_ID in "
   				+ "(select min( ENTITY_ID) from Wf_R_Examineinst where " +
   				examUserId +
   						" TASKINST_ID in "
   				+ "(select TASKINST_ID " + " from Wf_R_Examineinst p WHERE ";
   		String sqlArgs[] = new String[2];// 记录角色 、用户的SQL条件

   		if (examineUserId != null && !examineUserId.equals("") && !("1").equals(noFilter)) {
   			sqlArgs[0] = " examine_User_Id ='" + examineUserId + "'";
   		}
   		if (examineRoleId != null && !examineRoleId.equals("") && !("1").equals(noFilter) ) {
   			sqlArgs[1] = " examine_Role_Id in(" + examineRoleId + ")";
   		}
   		//添加条件角色、人员、流程类型查询条件
   		sql=parseSQL(sql ,sqlArgs,procType,procId);
   		//修改人 吴海军，按提交排序
   		
   		sql = "SELECT rt.*, e2.create_date, e2.create_user_name, e.org_name,(to_date('"+sdf.format(new Date())+"','yyyy-MM-dd')-to_date(rt.EXAMINE_START_DATE,'yyyy-MM-dd')) wait_day   from  ("
   				+ sql
   				+ ") rt  left join   wf_r_procinst e2   on e2.entity_id = rt.procinst_id  left join p_auth_user e1    on e1.user_id = e2.create_user  left join comm_org_information e    on e.org_id = e1.org_id order by  wait_day desc, e2.create_date  desc ";

   		IJdbcDao jdbcDao =BeanFactory.getQueryJdbcDAO();
   		
   		page = jdbcDao.queryRecordsBySQL(sql, page);
   		
   		//处理结果集 
   		List examineInstList= page.getData();//this.getExamineinstDAO().queryExamineInstListByUser(sql);
   		List  data = this.CreateVarInExamineInstForInfo(examineInstList);
   		page.setData(data);
   		
   		return   page;
   		
   	}

    /**
     * 
    * @Title: queryExamineInstListForMails
    * @Description: 查询所有审批流程，为邮件提醒提供数据
    * @param @param procType 流程类型：系统模块的流程类型编码
    * @param @return    设定文件
    * @return List    返回类型
    * @throws
     */
    public List queryExamineInstListForMails(String procType){
    	
    	String sql = "select * from Wf_R_Examineinst where ENTITY_ID in "
				+ "(select min( ENTITY_ID) from Wf_R_Examineinst where " + 
						" TASKINST_ID in "
				+ "(select TASKINST_ID " + " from Wf_R_Examineinst p WHERE ";
		 
		//添加条件角色、人员、流程类型查询条件
		sql=parseSQL(sql ,null,procType,null);
		 
		
		sql = "SELECT rt.*, e2.create_date, e2.create_user_name, e.org_name,(to_date('"+sdf.format(new Date())+"','yyyy-MM-dd')-to_date(rt.EXAMINE_START_DATE,'yyyy-MM-dd')) wait_day   from  ("
				+ sql
				+ ") rt  left join   wf_r_procinst e2   on e2.entity_id = rt.procinst_id  left join p_auth_user e1    on e1.user_id = e2.create_user  left join comm_org_information e    on e.org_id = e1.org_id order by  wait_day desc, e2.create_date  desc ";

		IJdbcDao jdbcDao =BeanFactory.getQueryJdbcDAO();
		
		List list = jdbcDao.queryRecords(sql);
		
    	return list;
    }
    
    /**
	 * 把流程变量添加到每个待审批实例中
	 * 吴海军修改
	 * 处理提交单位和提交人
	 * @param examineInstList
	 * @return
	 */
	private List CreateVarInExamineInstForInfo(List examineInstList){
		List list=new ArrayList();
		for(int j=0;j<examineInstList.size();j++){
			Map map=(Map)examineInstList.get(j);
			List varList=this.getExamineinstDAO().queryProcInstVarByID(map.get("procinstId").toString());
			String sql="  select      t1.is_to_sync   from wf_d_procdefine t1 join comm_org_subjection os  on t1.create_user_name = os.org_subjection_id   join comm_org_information oi on os.org_id = oi.org_id where t1.entity_id='"+map.get("procId").toString()+"'";
			List<Map>procdefinelist=this.getExamineinstDAO().queryList(sql);
			if(procdefinelist!=null && !procdefinelist.isEmpty()){
				map.put("isToSync", (procdefinelist.get(0)).get("isToSync"));
			}
			for(int k=0;k<varList.size();k++){
		        Map assortMap=(Map)varList.get(k);
				Iterator iterator2 =assortMap.keySet().iterator();
				while (iterator2.hasNext()) { 
					String key=(String)iterator2.next(); 
					if(assortMap.get(key)!=null&&key.equals("varName"))
					{
						map.put(assortMap.get(key), assortMap.get("varValue"));
					}
					
			      }
				
			}
			list.add(map);
		}
		return list;
		
	}
    
    /**
     * 审批实例委托
     * @param examInstID
     * @param userIDs
     * @throws Exception 
     */
    public void addconsignExamInst(String examInstID,String userIDs)
    {
    	WFUtils utils=new WFUtils();
    	WfRExamineinst wfRExamineinst=this.getExamineinstDAO().queryExamineinstByID(examInstID);
    	String[] users=userIDs.split(",");
    	for(int i=0;i<users.length;i++)
    	{
    		String userID=users[i];
    		if(userID!=null&&!userID.equals(""))
    		{
    			
    			WfRExamineinst bean = (WfRExamineinst)utils.wrap(wfRExamineinst,WfRExamineinst.class);   
    			bean.setExamineStartDate(utils.getNowDate());
    			bean.setExamineUserId(userID);
    			bean.setEntityId("");
    			this.getExamineinstDAO().saveExamineinst(bean);
    		}
    		
    	}
    }
 /**
  * 得到流程实例的变量信息
  * @param procInstId
  * @return
  */
    public Map getProcInstVar(String procInstId){
			List varList=this.getExamineinstDAO().queryProcInstVarByID(procInstId);
			Map map=new HashMap();
			for(int k=0;k<varList.size();k++){
		        Map assortMap=(Map)varList.get(k);
				Iterator iterator2 =assortMap.keySet().iterator();
				while (iterator2.hasNext()) { 
					String key=(String)iterator2.next(); 
					if(assortMap.get(key)!=null&&key.equals("varName"))
					{
						map.put(assortMap.get(key), assortMap.get("varValue"));
					}
					
			      }
				
			}
		
		return map;
    }
    
    
    
    public ExamineinstDAO getExamineinstDAO() {
		return examineinstDAO;
	}
    public void setExamineinstDAO(ExamineinstDAO examineinstDAO) {
		this.examineinstDAO = examineinstDAO;
	}

	public ProcInstDAO getProcInstDAO() {
		return procInstDAO;
	}

	public void setProcInstDAO(ProcInstDAO procInstDAO) {
		this.procInstDAO = procInstDAO;
	}

	public TaskInstDAO getTaskInstDAO() {
		return taskInstDAO;
	}

	public void setTaskInstDAO(TaskInstDAO taskInstDAO) {
		this.taskInstDAO = taskInstDAO;
	}
    
}
