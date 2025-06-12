/**
 * 
 */
package com.cnpc.sais.bpm;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.soa.exception.RetCodeException;

import com.cnpc.jcdp.soa.xpdl.Package;
import com.cnpc.jcdp.soa.xpdl.parser.XPDLParser;
import com.cnpc.jcdp.soa.xpdl.parser.XPDLParserException;
import com.cnpc.jcdp.soa.xpdl.parser.dom4j.Dom4JXPDLParser;
import com.cnpc.sais.bpm.bean.ExamineinstBean;
import com.cnpc.sais.bpm.cache.MemberCache;
import com.cnpc.sais.bpm.dao.ExamineinstDAO;
import com.cnpc.sais.bpm.dao.ProcInstDAO;
import com.cnpc.sais.bpm.dao.ProcdefineDAO;
import com.cnpc.sais.bpm.dao.ProcinstCopyDAO;
import com.cnpc.sais.bpm.define.entity.node.AbstractNodeEntity;
import com.cnpc.sais.bpm.define.entity.process.ProcessDefineEntity;
import com.cnpc.sais.bpm.pojo.WfDNode;
import com.cnpc.sais.bpm.pojo.WfDProcdefine;
import com.cnpc.sais.bpm.pojo.WfRExamineinst;
import com.cnpc.sais.bpm.pojo.WfRProcinst;
import com.cnpc.sais.bpm.pojo.WfRVariableinst;
import com.cnpc.sais.bpm.runtime.entity.inst.ExamineinstEntity;
import com.cnpc.sais.bpm.runtime.entity.inst.ProcInstEntity;
import com.cnpc.sais.bpm.service.ProcDefineService;
import com.cnpc.sais.bpm.service.ProcInstService;
import com.cnpc.sais.bpm.util.WFConstant;
import com.cnpc.sais.bpm.util.WFUtils;

import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;
/** 
 * @author 夏烨  
 * @version 创建时间：2009-11-4 上午10:04:43 
 * 类说明 
 */

public class ProcInstSrv implements IProcInstSrv{
	/**
	 * 添加流程模板定义
	 * @param xpdl 流程的xpdl描述  
	 * @param doc  流程图形化描述
	 * @param pdname 流程描述
	 * @return Map 包含流程相关信息
	 */
	/*public Map addProcessDefine(String xpdl,String doc,String pdname){
	    Map msg=new HashMap();
		
		InputStream in=new ByteArrayInputStream(xpdl.getBytes());
		XPDLParser parser = new Dom4JXPDLParser();
		Package p = null;
		try {
			p = parser.parse(in);
		} catch (XPDLParserException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
	    Map map=procDefineService.addProcDefineToDB(p);

	    String procState="";
	    String procid="";
	    if(map.get("state")!=null)
	    {
	    	procState=(String)map.get("state");
	    }
	    if(map.get("procid")!=null)
	    {
	    	procid=(String)map.get("procid");
	    }
		msg.put("pdname", pdname);
		msg.put("procid", procid);
		msg.put("doc", doc);
		msg.put("flag", "success");
		msg.put("state", procState);
		return msg;
	
	}*/
	
	public Map addProcessDefineFlex(String xml,String pdname,String createUserName,String procEName,String procType)
	{
		 Document ProcDoc = null;
		 try {
			 ProcDoc = DocumentHelper.parseText(xml);
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
	    Map msg=procDefineService.addProcDefineFelxToDB(ProcDoc, pdname,createUserName,procEName,procType);
	    
	   /* String procId=msg.get("procid").toString();
        try {
			this.addProcDefine2Cache(procId, procDefineService);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
	    return msg;
	}
	public Map addProcessDefineFlex(String xml,String pdname,Map userInfo,String procEName,String procType)
	{
		 Document ProcDoc = null;
		 try {
			 ProcDoc = DocumentHelper.parseText(xml);
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
	    Map msg=procDefineService.addProcDefineFelxToDB(ProcDoc, pdname,userInfo,procEName,procType);
	    
	   /* String procId=msg.get("procid").toString();
        try {
			this.addProcDefine2Cache(procId, procDefineService);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
	    return msg;
	}
	
	public String addProcessDefineFlex(String xml,String procinstId)
	{
		 Document ProcDoc = null;
		 try {
			 ProcDoc = DocumentHelper.parseText(xml);
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
	    procDefineService.addProcDefineFelx(ProcDoc, procinstId);
	   return ProcDoc.asXML();
	}
	
	
	
	/**
	 * 流程模板添加到缓存中
	 * @param procId
	 * @throws Exception 
	 */
	public void addProcDefine2Cache(String procId,ProcDefineService procDefineService) throws Exception{
	    ProcessDefineEntity processDefineEntity=procDefineService.getProcessDefineEntityByID(procId, false);
	    String cacheKey=processDefineEntity.getWfDProcdefine().getProcEName()+"_"+processDefineEntity.getWfDProcdefine().getProcVersion();
		MemberCache.getInstance().storeObject(cacheKey, processDefineEntity);
	}
	/*public Map addProcessDefine(String xpdl,String doc,String pdname,String procType)throws RetCodeException
	{
	
		 Map msg=new HashMap();
			
			InputStream in=new ByteArrayInputStream(xpdl.getBytes());
			XPDLParser parser = new Dom4JXPDLParser();
			Package p = null;
			try {
				p = parser.parse(in);
			} catch (XPDLParserException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		    Map map=procDefineService.addProcDefineToDB(p,procType);

		    String procState="";
		    String procid="";
		    if(map.get("state")!=null)
		    {
		    	procState=(String)map.get("state");
		    }
		    if(map.get("procid")!=null)
		    {
		    	procid=(String)map.get("procid");
		    }
			msg.put("pdname", pdname);
			msg.put("procid", procid);
			msg.put("doc", doc);
			msg.put("flag", "success");
			msg.put("state", procState);
			return msg;
	
	}*/
	/**
	 * 修改流程模板定义Flex
	 * @param xml 流程的xpdl描述  
	 * @param pdname 流程描述
	 * @return Map 包含流程相关信息
	 */
	public Map updateProcessDefineFlex(String xml,String pdname,String createUserName,String procId){
		 Document ProcDoc = null;
		 try {
			 ProcDoc = DocumentHelper.parseText(xml);
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
	    Map map=procDefineService.updateProcDefineFelxToDB(ProcDoc, pdname,createUserName,procId);
	    String upProcId=map.get("procid").toString();
	    try {
			this.addProcDefine2Cache(upProcId, procDefineService);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 return map;
	}
	public Map updateProcessDefineFlex(String xml,String pdname,Map userInfo,String procId){
		 Document ProcDoc = null;
		 try {
			 ProcDoc = DocumentHelper.parseText(xml);
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
	    Map map=procDefineService.updateProcDefineFelxToDB(ProcDoc, pdname,userInfo,procId);
	   /* String upProcId=map.get("procid").toString();
	    try {
			this.addProcDefine2Cache(upProcId, procDefineService);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}*/
		 return map;
	}
	/**
	 * 修改流程模板定义
	 * @param xpdl
	 * @param doc
	 * @param pdname
	 * @return
	 */
	public Map updateProcessDefine(String xpdl,String doc,String pdname)throws RetCodeException{
		 Map msg=new HashMap();
	
		InputStream   in=new ByteArrayInputStream(xpdl.getBytes());
		XPDLParser parser = new Dom4JXPDLParser();
		Package p = null;
		try {
			p = parser.parse(in);
		} catch (XPDLParserException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		procDefineService.updateProcDefineToDB(p);
		msg.put("pdname", pdname);
		msg.put("doc", doc);
		msg.put("flag", "success");
		msg.put("state", "0");
		return msg;
		
		
	}
	/**
	 * 启动流程
	 * @param procTempId:流程模板ID
	 * @param vars：流程变量
	 * @param userId:创建人ID
	 * @return RetCodeException
	 * @throws Exception 
	 */
	public ProcInstEntity startProc(String procEName, String procVersion,
			List<WfRVariableinst> vars, String userId, String userName,String ccUsers,String orgID)
			throws RetCodeException {
		if(StringUtils.isBlank(procVersion)){
			ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
			procVersion=procDefineService.getProcdefineDAO().queryVerionByeName(procEName);
		}
		String cacheKey = procEName + "_" + procVersion;
		ProcessDefineEntity procDefine = MemberCache.getInstance().retrieveProcDefine(cacheKey);

		ProcInstEntity procInstEntity = (ProcInstEntity) BeanFactory
				.getBean("ProcInst");
		procInstEntity.setProcDefine(procDefine);
		procInstEntity.initProcInstEntity(userId, userName,orgID);
		procInstEntity.setVariables(vars);
		procInstEntity.setCCusers(ccUsers);
		procInstEntity.startProcInst();
		return procInstEntity;
	}
	/**
	 * 重新启动流程
	 * @param procInstId
	 * @param movNodeId 启动后要跳到的节点ID
	 * @return
	 */
	public void reStartProc(String procInstId,String movNodeId){
		ProcInstEntity procInstEntity = (ProcInstEntity) BeanFactory
		.getBean("ProcInst");
		procInstEntity.initProcInst(procInstId);
		String nodeId=procInstEntity.getWfRProcinst().getStartNodeid();
		procInstEntity.reStartProcInst(procInstId,nodeId,movNodeId);
	}
	public String getPeopleNodes(String procInstId){
		ProcInstEntity procInstEntity = (ProcInstEntity) BeanFactory
		.getBean("ProcInst");
		procInstEntity.initProcInst(procInstId);
		String procId=procInstEntity.getWfRProcinst().getProcId();
		 WfRExamineinst wfRExamineinst=procInstEntity.getProcInstService().getExamineinstDAO().queryProcInstExamineInst(procInstId);
		 if(wfRExamineinst!=null){
			 AbstractNodeEntity moveNode= procInstEntity.getProcDefine().getNodeByNodeID( wfRExamineinst.getNodeId());
			 return moveNode.getNodeID();
		 }
		return null;
	}
	/**
	 * 得到流程的图形化显示XML-FLEX版本
	 * @param procDefineId
	 * @return
	 */
	public Map getProcFlexView(String procEName,String procVersion )
	{
		String cacheKey=procEName+"_"+procVersion;
		ProcessDefineEntity procDefine=MemberCache.getInstance().retrieveProcDefine(cacheKey);
		return procDefine.getProcDesignFlexById(procDefine);
	}
	public Map getProcInstFlexView(String procInstId )
	{
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		WfRProcinst wfRProcinst=procDefineService.getProcInstDAO().queryProcInstByID(procInstId);
		WfDProcdefine wfDProcdefine=procDefineService.getProcdefineDAO().queryProcdefineByID(wfRProcinst.getProcId());
		
		String cacheKey=wfDProcdefine.getProcEName()+"_"+wfDProcdefine.getProcVersion();
		ProcessDefineEntity procDefine=MemberCache.getInstance().retrieveProcDefine(cacheKey);
		return procDefine.getProcInstFlexById(procDefine,procInstId);
	}
	/**
	 * 缓存中加载流程信息
	 */
	public void loadProcDefines()throws RetCodeException{
		ProcDefineService procdefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		procdefineService.cacheProcDefines();
		System.out.println("load end");
		
	}
	/**
	 * 根据当前用户和模板类型得到待审批列表
	 * examineinstId为空时查询用户所有审批信息，不为空时查询指定的审批信息
	 * @param userId 用户ID
	 * @param procType 流程类型
	 * examineRoleId 
	 * @return
	 */
	public List getExamineInstListByUserID(String userId, String procType,
			String examineinstId, String examineRoleId,String procId) throws RetCodeException {
		List examineInstList = new ArrayList();
		ExamineinstEntity examineinstEntity = (ExamineinstEntity) BeanFactory
				.getBean("Examineinst");
		examineInstList = examineinstEntity.queryExamineInstList(procType,userId, examineRoleId,procId);
		return examineInstList;
	}
	/**
	 * 点击审批时得到审批实例的所有信息和所有下级节点
	 * @param procinstId 流程实例Id
	 * @param examineinstId 审批实例Id
	 * @return
	 */
	public Map getExamineInfo(String procinstId,String examineinstId,String procType,String userId)throws RetCodeException{
		Map msg = new HashMap();
		
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.initProcInst(procinstId);
		//得到下级流程节点列表
		String nodeId=procInstEntity.getCruTonen(examineinstId).getNodeId();
		
		List nodeList=procInstEntity.getNextNodeList(examineinstId);
		ExamineinstEntity examineinstEntity=(ExamineinstEntity)BeanFactory.getBean("Examineinst");
		Map varMap=examineinstEntity.getProcInstVar(procinstId);
		varMap.put("procinstId", procinstId);
		varMap.put("examineinstId", examineinstId);
		varMap.put("taskinstId", examineinstEntity.getExamineinstById(examineinstId).getTaskinstId());
		String isCanPass = "false";
		if (procInstEntity.getCurNode().getWfDNode().getIsCanPass() != null) {
			isCanPass = procInstEntity.getCurNode().getWfDNode().getIsCanPass();
		}
		msg.put("nodeId", nodeId);
		boolean isFirstApplyNode=procInstEntity.isFirstApplyNode();
		//通过审批的节点信息
		//是否是第一级审批节点--用户能否回退
		msg.put("isFirstApplyNode",String.valueOf(isFirstApplyNode));
		//审批信息显示
		msg.put("examineinInfo", varMap);
		//下级节点--用户SELECT选择使用
		msg.put("nodeList", nodeList);
		//是否能够直接通过
		msg.put("isCanPass", isCanPass);
		
		msg.put("startNode", procInstEntity.getProcDefine().getWfDProcdefine().getStartNode());
		return msg;
		
	}
	/**
	 * 审批某级节点
	 * @param nextNodeId 下级节点Id
	 * @param examineInfo 本级节点审批信息
	 * @param isPass  是否通过
	 * @param examineinstId 审批实例Id
	 */
	public Map examineNode(String nextNodeId, String examineInfo,
			String isPass, String examineinstId, String procinstId,
			String examineUserName, String taskInstId,String userId,String busiInfo ) throws RetCodeException {
		Map examineMap = new HashMap();
		// boolean ispass=false;
		// if(isPass.equals("pass"))
		// {
		// ispass=true;
		// }
		// 加载流程实例
		ProcInstEntity procInstEntity = (ProcInstEntity) BeanFactory.getBean("ProcInst");
		procInstEntity.initProcInst(procinstId);
		if (nextNodeId == null)
			nextNodeId = "";
		examineMap = procInstEntity.examineProcess(nextNodeId, examineInfo,
				isPass, examineinstId, examineUserName, "1",userId,busiInfo);
		return examineMap;
	}
	
	/**
	 * 委托用户审批实例
	 * @param examineinstId 审批实例节点Id
	 * @param userIds 多个委托用户Id用逗号隔开 
	 * @throws Exception 
	 */
	public void consignExamInst(String examineinstId,String userIds)throws RetCodeException{
	
		ExamineinstEntity examineinstEntity=(ExamineinstEntity)BeanFactory.getBean("Examineinst");
		examineinstEntity.consignExamInst(examineinstId, userIds);
		
	}
	
	/**
	 * 回退流程实例
	 * @param examineinstId
	 * @param examineInfo
	 * @param procinstId
	 */
	public void backProcInst(String examineinstId,String examineInfo,String procinstId)throws RetCodeException{
	    //加载流程实例
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.initProcInst(procinstId);
		procInstEntity.backProcInst(examineinstId,examineInfo);
		
	}
	
	/**
	 * 根据流程模板ID得到流程模板实例
	 * @param procDefineId 流程模板Id
	 */
	public void getprocDefineById(String procEName,String procVersion)throws RetCodeException{
	  String cacheKey=procEName+"_"+procVersion;
      ProcessDefineEntity procDefine=MemberCache.getInstance().retrieveProcDefine(cacheKey);
		
	}
	
	/**
	 * 得到流程模板实例用于展示--生成显示xml
	 * @param procDefineId
	 * @return
	 */
	public Map getProcessViewById(String procDefineId)throws RetCodeException{
		Map msg=new HashMap();
		ProcDefineService procd=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		Map reMap=procd.getProcessDocument(procDefineId);
		String procName=(String)reMap.get("procName");
		String xmlStr=(String)reMap.get("document");
		
		msg.put("procName", procName);
		msg.put("xmlStr", xmlStr);
		return msg;
		
	}
	
	/**
	 * 根据当前用户启动的流程实例
	 * @param userId 当前用户Id
	 * @param procType 流程类型
	 * @return
	 */
	public List getStartProcInstByCurUser(String userId,String procType){
		List procInstList=new ArrayList();
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstList=procInstEntity.queryProcInstByUserId(userId,procType);
		return procInstList;
	}
	
	/**
	 * 图形化显示流程实例的运行情况
	 * @param procinstId
	 * @return
	 */
	public String getProcInstView(String procinstId){
		
		WFUtils utils=new WFUtils();
		String str="";
		 //加载流程实例
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.initProcInst(procinstId);
		
		String procInstView=procInstEntity.getProcInstView();
		str=utils.replaceBlank(procInstView);
		return str;
		
	}
	/**
	 * 根据节点ID和流程实例ID查询当前节点的审批信息
	 * @param nodeId
	 * @param procInstId
	 * @return
	 */
	public List queryExamineInstByNodeId(String nodeId,String procInstId)
	{
		ExamineinstDAO examineinstDao=(ExamineinstDAO)BeanFactory.getBean("ExamineinstDAO");
	    return  examineinstDao.queryExamineInstByNodeId(nodeId, procInstId);
	}
	/**
	 * 查询所有流程模板下的运行的流程实例
	 * @return
	 */
	public List queryInstSumByProcDefine()
	{
		ProcdefineDAO procdefineDAO=(ProcdefineDAO)BeanFactory.getBean("ProcdefineDAO");
		return procdefineDAO.queryInstSumByProcDefine();
	}
	/**
	 * 	得到某个模板下某种状态的实例
	 * @param procId
	 * @param state
	 * @return
	 */
	public List queryProcInstsByProcId(String procId,String state)
	{
		ProcInstDAO procInstDAO=(ProcInstDAO)BeanFactory.getBean("ProcInstDAO");
		return procInstDAO.queryProcInstsByProcId(procId, state);
		
	}
	/**
	 * 根据流程类型得到相应的流程模板
	 * @param procType
	 * @return
	 */
	public List getProcProcDefinesByType(String procType){
		ProcdefineDAO procdefineDAO=(ProcdefineDAO)BeanFactory.getBean("ProcdefineDAO");
		return procdefineDAO.queryProcDefinesByType(procType,WFConstant.WF_PROC_STATE_RUN);
	}
	public List getProcDefineByInst(String procinstId){
		ProcdefineDAO procdefineDAO=(ProcdefineDAO)BeanFactory.getBean("ProcdefineDAO");
		return procdefineDAO.queryProcDefineByInst(procinstId);
	}
	/**
	 * 查询流程实例审批信息
	 * @param procInstId
	 * @return
	 */
	public List queryProcInstExamineInfo(String procInstId)
	{
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		return procInstEntity.queryProcInstExamineInfo(procInstId);
	}
	/**
	 * 删除流程模板物理删除
	 * @param procDeineId
	 */
	public void delProcDefine(String procDeineId)
	{
		ProcDefineService procd=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		procd.deleteProcDsfine(procDeineId);
	}
	
	

	/**
	 * 修改流程模板状态
	 * @param procDeineId
	 * @param state
	 */
	public void stopProcDefine(String procDeineId)
	{
		ProcDefineService procd=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		procd.updateProcState(procDeineId, WFConstant.WF_PROC_STATE_STOP);
	}
	/**
	 * 开启流程模板
	 * @param procDeineId
	 */
	public void startProcDefine(String procDeineId)
	{
		ProcDefineService procd=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		procd.updateProcState(procDeineId, WFConstant.WF_PROC_STATE_RUN);
		
	}
	/**
	 * 删除流程实例相关信息
	 * @param procInstId
	 */
	public void delProcInst(String procinstId)
	{
		ProcInstService procInst=(ProcInstService)BeanFactory.getBean("ProcInstService");
		procInst.deleteProcInst(procinstId);
		
	}

	/**
	 * 得到流程管理列表
	 * 
	 * @param procType
	 * @return
	 */
	public String queryProcManagerList(String procType) {
		ProcDefineService procd = (ProcDefineService) BeanFactory
				.getBean("ProcDefineService");
		return procd.getProcDefinesHtml(procType);
	}
	
	/**
	 * 根据Id停止流程实例
	 * @param procInstId
	 * @return
	 */
	public void stopProcInst(String procInstId){
		ProcInstService procInst=(ProcInstService)BeanFactory.getBean("ProcInstService");
		procInst.updateProcInstStopById(procInstId);
	}
	/**
	 * 根据userid查询抄送的流程列表
	 * @param procInstId
	 * @return
	 */
	public List queryPorcInstCCByUserId(String userId){
		ProcinstCopyDAO procinstCopyDAO=(ProcinstCopyDAO)BeanFactory.getBean("ProcinstCopyDAO");
		return procinstCopyDAO.queryCopyProcInstsByuserId(userId);
	}
	/**
	 * 在流程实例中跳转审批节点
	 * @param procInstEntity
	 * @param examineInstId
	 * @param examineInfo
	 * @param moveNodeId
	 * @param procDefine
	 */
	public String moveNodeProcInst(String examineInstId, String examineInfo,
			String moveNodeId,String procinstId,String taskInstId,UserToken userToken) {
		ProcInstEntity procInstEntity = (ProcInstEntity) BeanFactory
				.getBean("ProcInst");
		procInstEntity.initProcInst(procinstId);

		procInstEntity.moveNodeProcInst(examineInstId, examineInfo, moveNodeId,taskInstId,userToken);
		return procInstEntity.getWfRProcinst().getState();
	}
	public void saveFlashProcinst(String procinstId){
		ProcInstService procInst=(ProcInstService)BeanFactory.getBean("ProcInstService");
		procInst.flashProcInst(procinstId);
	}
	
	
	/**
	 * 查询节点审批信息
	 * @param procInstId
	 */
	public List qyeryNodeApply(String procInstId){
		ProcInstService procInst=(ProcInstService)BeanFactory.getBean("ProcInstService");
		return procInst.queryProcInstApply(procInstId);
	}
	/**
	 * 查询当前用户参加审批的流程实例
	 * @param userId
	 * @param roleId
	 * @param state
	 * @return
	 */
	public List queryJoinInstByUser(String userId,String roleId,String state,String procId,String procType){
		ProcInstService procInst=(ProcInstService)BeanFactory.getBean("ProcInstService");
		List examineInstList=procInst.queryJoinProcInstByUser(userId, roleId, state,procId,procType);
		return examineInstList;
	}
	/**
	 * 查询当前用户参加审批的流程实例
	 * @param userId 用户ID
	 * @param roleId 角色
	 * @param state 流程实例状态
	 * @param examineinstState 审批实例状态
	 * @return
	 */
	public List queryJoinInstByUserBystate(String userId,String roleId,String state,String examineinstState,String procId,String procType){
		ProcInstService procInst=(ProcInstService)BeanFactory.getBean("ProcInstService");
		List examineInstList=procInst.queryJoinProcInstByUserState(userId, roleId, state,examineinstState,procId,procType);
		return examineInstList;
	}
	/**
	 * 根据节点ID查询可回退的节点
	 * @param nodeId
	 * @return
	 */
	public List queryBackNode(String nodeId) throws Exception{
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		WfDNode wfDNode=procDefineService.getNodeDAO().queryNodeByID(nodeId);
		List backNodeList=procDefineService.getBackNodeDAO().queryBackNode(wfDNode.getViewId());
		return backNodeList;
	}
	
	/**
	 * 根据流程实例ID查找业务数据
	 * @param procInstId
	 * @return
	 */
	
	public String getBusinessData(String ProcInstIds){
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		List <WfRVariableinst>list=procInstEntity.getProcInstService().getVariableinstDAO().queryByProcInstIds(ProcInstIds);
		StringBuffer sb=new StringBuffer();
		for(int i=0;i<list.size();i++){
			if(sb.length()<=0){
				sb.append("'").append(list.get(i).getVarValue()).append("'");
			}else{
				sb.append(",'").append(list.get(i).getVarValue()).append("'");
			}
		}
		 if(sb.length()>0){
			 return sb.toString();
		 }
		return null;
	}
	public List getBusinessDataList(String ProcInstIds){
		
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		List <WfRVariableinst>list=procInstEntity.getProcInstService().getVariableinstDAO().queryByProcInstIds(ProcInstIds);
		List list1=new ArrayList();
		for(int i=0;i<list.size();i++){
			list1.add(list.get(i).getVarValue());
		}
		return list1;
	}
	/**
	 * 根据流程实例ID判断是否为连接流程
	 * @param procInstId
	 * @return true/false true 为是连接流程，false为非连接流程
	 */
	public boolean isLink(String procInstId){
		boolean flag=false;
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.initProcInst(procInstId);
		String IsToSync=procInstEntity.getProcDefine().getWfDProcdefine().getIsToSync();
		if(StringUtils.isNotBlank(IsToSync)&&(IsToSync.equals("01")||IsToSync.equals("1"))){
			flag=true;
		}
		return flag;
	}
	/**
	 * 查看当前流程实例的状态
	 * 
	 * 
	 * */
	public List queryCurrExamineinst(String procinstId){
		
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		
		return procInstEntity.getProcInstService().getExamineinstDAO().queryCurrExamineinst(procinstId);
	}
	/**
	 * 查看当前流程实例的状态
	 * 
	 * 
	 * */
	public List queryCurrExamineinstNode(String procinstId){
		
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		
		return procInstEntity.getProcInstService().getExamineinstDAO().queryCurrExamineinstNode(procinstId);
	}
	
	/**
	 * 挂起流程实例
	 * */
	public void procInstHangUp(String procInstId){
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.getProcInstService().getProcInstDAO().procInstHangUp(procInstId);
	}

	/**
	 * 恢复流程实例
	 * */
	
	public void procInsRecovery(String procInstId){
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.getProcInstService().getProcInstDAO().procInsRecovery(procInstId);
	}
	
	/**
	 * 删除流程
	 * */
	public void procInsDelete(String procInstId){
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.getProcInstService().getProcInstDAO().procInsDelete(procInstId);
	}
	public String getUrls(String procinstId,String examInstId){
		ProcInstEntity procInstEntity = (ProcInstEntity) BeanFactory.getBean("ProcInst");
		procInstEntity.initProcInst(procinstId);
		return procInstEntity.getUrls(examInstId);
	}
	/**
	 * 挂起流程模板
	 * */
	public void procHangUp(String procId){
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		procDefineService.getProcdefineDAO().procHangUp(procId);
	}

	public void deleteProc(String procId) {
		// TODO Auto-generated method stub
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		procDefineService.getProcdefineDAO().deleteProc(procId);
	}
	/*public List getUsers(String procEName,String procVersion){
		ProcDefineService procDefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		return procDefineService.getUsers(procEName, procVersion);
	}*/
}
