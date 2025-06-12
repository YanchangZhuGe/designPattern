package com.cnpc.sais.bpm.dao;

import java.util.List;
import java.util.Map;

import java.util.ArrayList;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.sais.bpm.pojo.WfDProcdefine;
import com.cnpc.sais.bpm.util.WFConstant;

/** 
 * @author 夏烨  
 * @version 创建时间：2009-9-1 下午03:58:03 
 * 类说明 
 */
public class ProcdefineDAO {
	private IBaseDao baseDao = BeanFactory.getBaseDao();
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private RADJdbcDao radJdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");	
	public void saveProcdefine(WfDProcdefine wfDProcdefine){
		baseDao.save(wfDProcdefine);
	}
	public void updateProcdefine(WfDProcdefine wfDProcdefine) {
		baseDao.update(wfDProcdefine);
	}
	public void deleteProcdefine(WfDProcdefine wfDProcdefine) {
		baseDao.delete(WfDProcdefine.class, wfDProcdefine.getEntityId());
	}
	public WfDProcdefine queryProcdefineByID(String entityId) {
	       return (WfDProcdefine)baseDao.get(WfDProcdefine.class, entityId);
    }
	public List queryProcdefines()  {
		String[] args=new String[]{};
		String hql="from WfDProcdefine where deleteFlag is null or deleteFlag='0'";
			
			return baseDao.queryByHql(hql, args);
	       //return baseDao.getAll(WfDProcdefine.class);
    }
	public boolean queryProcNameExist(String procName,String procEName) {
		  boolean isExist=false;
		  List procNameList=new ArrayList();
		  String[] args=new String[]{procName,procEName};
		  String sql="from WfDProcdefine WHERE procName =? or procEName=?";
		  procNameList=baseDao.queryByHql(sql, args);
		  if(procNameList.size()>0)
		  {
			  isExist=true;
		  }
		  return isExist;
	}
	public WfDProcdefine queryProcdefineByName(String procName) {
		  boolean isExist=false;
		  List procNameList=new ArrayList();
		  String[] args=new String[]{procName};
		  String sql="from WfDProcdefine WHERE procName =? ";
		  procNameList=baseDao.queryByHql(sql, args);
		 
		  return (WfDProcdefine)procNameList.get(0);
	   }
	
	public WfDProcdefine queryProcByVersion(String procName,String version) {
		  boolean isExist=false;
		  List procNameList=new ArrayList();
		  String[] args=new String[]{procName,version};
		  String sql="from WfDProcdefine WHERE procName =? and procVersion=? ";
		  procNameList=baseDao.queryByHql(sql, args);
		 
		  return (WfDProcdefine)procNameList.get(0);
	   }
	public WfDProcdefine queryProcByEnameVersion(String procEName,String version) {
		  boolean isExist=false;
		  List procNameList=new ArrayList();
		  String[] args=new String[]{procEName,version};
		  String sql="from WfDProcdefine WHERE procEName =? and procVersion=? ";
		  procNameList=baseDao.queryByHql(sql, args);
		 
		  return (WfDProcdefine)procNameList.get(0);
	   }
	/**
	 * 得到当前流程的下个版本号
	 * @param procName
	 * @return
	 */
	public int queryVerionByName(String procName) {
		

		  String[] args1=new String[]{procName};
//		  String sql="select max(o.procVersion) from WfDProcdefine o where o.procName=?";
		  String sql="select max(o.procVersion+0) from WfDProcdefine o where o.procName=?";
		  List model = baseDao.queryByHql(sql,args1); 
//		  int verion=Integer.parseInt(((String)model.get(0)));
		  int verion=Integer.parseInt(model.get(0).toString());
		  verion=verion+1;
		  return verion;
	   }
	
	/**
	 * 得到当前流程的最新版本号
	 * @param procName
	 * @return
	 */
	public String queryVerionByeName(String procEName) {
		  String[] args1=new String[]{procEName};
		  String sql="select max(o.procVersion+0) from WfDProcdefine o where o.procEName=?";
		  List model = baseDao.queryByHql(sql,args1); 
		  return model.get(0).toString();
	   }
	
	
	
	/**
	 * 查询所有流程模板下的运行的流程实例
	 * @return
	 */
	public List queryInstSumByProcDefine()
	{
		  String[] args=new String[]{};
//		  String sql="select pd.proc_name , count(*) as total ,pd.STATE as state,pd.ENTITY_ID as procid " +
//		  		     "from wf_d_procdefine pd  LEFT JOIN wf_r_procinst " +
//		  		     "inst ON pd.ENTITY_ID=inst.PROC_ID and" +
//		  		     " inst.STATE="+WFConstant.WF_PROCINST_STATE_START+" GROUP BY pd.PROC_NAME ,pd.STATE,pd.ENTITY_ID";
		 
		  String sql="SELECT pd.proc_name,count(pi.entity_id) as total,pd.STATE as state,pd.ENTITY_ID as procid " +
		  		     " FROM wf_d_procdefine pd LEFT JOIN wf_r_procinst  pi" +
		  		     " ON pd.ENTITY_ID=pi.PROC_ID and pi.STATE="+WFConstant.WF_PROCINST_STATE_START+ 
		  		     " GROUP BY pd.PROC_NAME ,pd.STATE,pd.ENTITY_ID";
		  PageModel model = new PageModel();
		  List<Map> list = jdbcDao.queryRecordsBySQL(sql, model).getData();
		  return list;
		
	}
	/**
	 * 根据模板类型查询所有流程模板
	 * 
	 * @param procType
	 * @return
	 */
	public List queryProcDefinesByType(String procType, String state) {
		List procDefineList = new ArrayList();
		String[] args = new String[] { procType, state };
		String sql = "from WfDProcdefine WHERE procType =? and state=?";
		procDefineList = baseDao.queryByHql(sql, args);

		return procDefineList;
	}
	public List queryProcDefineByInst(String procinstId){
		String sql = "select a.* from wf_d_procdefine a left join wf_r_procinst b on a.entity_id=b.proc_id where b.entity_id='"+procinstId+"'";
		List list=jdbcDao.queryRecords(sql);
		return list;
		
	}
	public List queryList(String sql){
		List list=jdbcDao.queryRecords(sql);
		return list;
	}
	/**
	 * 得到流程模板管理显示
	 * @param procType
	 * @return
	 */
	public List queryProcDefinesList(String procType)
	{
		  List procDefineList=new ArrayList();
		  String sql="";
		  if(procType!=null&&!procType.equals("")){
			  sql="select * from wf_d_procdefine where PROC_TYPE='"+procType+"' order by PROC_NAME,PROC_VERSION+0 desc";
		  }else{
			  sql="select * from wf_d_procdefine  order by PROC_NAME,PROC_VERSION+0 desc";
		  }
		  
		  procDefineList=jdbcDao.queryRecords(sql);
		  return procDefineList;
	}
	
	public void procHangUp(String procId){
		String sql="update wf_d_procdefine set STATE='1' where ENTITY_ID='"+procId+"'";
		radJdbcDao.executeUpdate(sql);
	}
	public void deleteProc(String procId){
		String sql="update wf_d_procdefine set STATE='1',DELETE_FLAG='1' where ENTITY_ID='"+procId+"'";
		radJdbcDao.executeUpdate(sql);
	}
	
}
