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
 * @author ����  
 * @version ����ʱ�䣺2009-11-4 ����10:04:43 
 * ��˵�� 
 */

public class ProcInstSrv implements IProcInstSrv{
	/**
	 * �������ģ�嶨��
	 * @param xpdl ���̵�xpdl����  
	 * @param doc  ����ͼ�λ�����
	 * @param pdname ��������
	 * @return Map �������������Ϣ
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
	 * ����ģ����ӵ�������
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
	 * �޸�����ģ�嶨��Flex
	 * @param xml ���̵�xpdl����  
	 * @param pdname ��������
	 * @return Map �������������Ϣ
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
	 * �޸�����ģ�嶨��
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
	 * ��������
	 * @param procTempId:����ģ��ID
	 * @param vars�����̱���
	 * @param userId:������ID
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
	 * ������������
	 * @param procInstId
	 * @param movNodeId ������Ҫ�����Ľڵ�ID
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
	 * �õ����̵�ͼ�λ���ʾXML-FLEX�汾
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
	 * �����м���������Ϣ
	 */
	public void loadProcDefines()throws RetCodeException{
		ProcDefineService procdefineService=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		procdefineService.cacheProcDefines();
		System.out.println("load end");
		
	}
	/**
	 * ���ݵ�ǰ�û���ģ�����͵õ��������б�
	 * examineinstIdΪ��ʱ��ѯ�û�����������Ϣ����Ϊ��ʱ��ѯָ����������Ϣ
	 * @param userId �û�ID
	 * @param procType ��������
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
	 * �������ʱ�õ�����ʵ����������Ϣ�������¼��ڵ�
	 * @param procinstId ����ʵ��Id
	 * @param examineinstId ����ʵ��Id
	 * @return
	 */
	public Map getExamineInfo(String procinstId,String examineinstId,String procType,String userId)throws RetCodeException{
		Map msg = new HashMap();
		
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.initProcInst(procinstId);
		//�õ��¼����̽ڵ��б�
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
		//ͨ�������Ľڵ���Ϣ
		//�Ƿ��ǵ�һ�������ڵ�--�û��ܷ����
		msg.put("isFirstApplyNode",String.valueOf(isFirstApplyNode));
		//������Ϣ��ʾ
		msg.put("examineinInfo", varMap);
		//�¼��ڵ�--�û�SELECTѡ��ʹ��
		msg.put("nodeList", nodeList);
		//�Ƿ��ܹ�ֱ��ͨ��
		msg.put("isCanPass", isCanPass);
		
		msg.put("startNode", procInstEntity.getProcDefine().getWfDProcdefine().getStartNode());
		return msg;
		
	}
	/**
	 * ����ĳ���ڵ�
	 * @param nextNodeId �¼��ڵ�Id
	 * @param examineInfo �����ڵ�������Ϣ
	 * @param isPass  �Ƿ�ͨ��
	 * @param examineinstId ����ʵ��Id
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
		// ��������ʵ��
		ProcInstEntity procInstEntity = (ProcInstEntity) BeanFactory.getBean("ProcInst");
		procInstEntity.initProcInst(procinstId);
		if (nextNodeId == null)
			nextNodeId = "";
		examineMap = procInstEntity.examineProcess(nextNodeId, examineInfo,
				isPass, examineinstId, examineUserName, "1",userId,busiInfo);
		return examineMap;
	}
	
	/**
	 * ί���û�����ʵ��
	 * @param examineinstId ����ʵ���ڵ�Id
	 * @param userIds ���ί���û�Id�ö��Ÿ��� 
	 * @throws Exception 
	 */
	public void consignExamInst(String examineinstId,String userIds)throws RetCodeException{
	
		ExamineinstEntity examineinstEntity=(ExamineinstEntity)BeanFactory.getBean("Examineinst");
		examineinstEntity.consignExamInst(examineinstId, userIds);
		
	}
	
	/**
	 * ��������ʵ��
	 * @param examineinstId
	 * @param examineInfo
	 * @param procinstId
	 */
	public void backProcInst(String examineinstId,String examineInfo,String procinstId)throws RetCodeException{
	    //��������ʵ��
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.initProcInst(procinstId);
		procInstEntity.backProcInst(examineinstId,examineInfo);
		
	}
	
	/**
	 * ��������ģ��ID�õ�����ģ��ʵ��
	 * @param procDefineId ����ģ��Id
	 */
	public void getprocDefineById(String procEName,String procVersion)throws RetCodeException{
	  String cacheKey=procEName+"_"+procVersion;
      ProcessDefineEntity procDefine=MemberCache.getInstance().retrieveProcDefine(cacheKey);
		
	}
	
	/**
	 * �õ�����ģ��ʵ������չʾ--������ʾxml
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
	 * ���ݵ�ǰ�û�����������ʵ��
	 * @param userId ��ǰ�û�Id
	 * @param procType ��������
	 * @return
	 */
	public List getStartProcInstByCurUser(String userId,String procType){
		List procInstList=new ArrayList();
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstList=procInstEntity.queryProcInstByUserId(userId,procType);
		return procInstList;
	}
	
	/**
	 * ͼ�λ���ʾ����ʵ�����������
	 * @param procinstId
	 * @return
	 */
	public String getProcInstView(String procinstId){
		
		WFUtils utils=new WFUtils();
		String str="";
		 //��������ʵ��
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.initProcInst(procinstId);
		
		String procInstView=procInstEntity.getProcInstView();
		str=utils.replaceBlank(procInstView);
		return str;
		
	}
	/**
	 * ���ݽڵ�ID������ʵ��ID��ѯ��ǰ�ڵ��������Ϣ
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
	 * ��ѯ��������ģ���µ����е�����ʵ��
	 * @return
	 */
	public List queryInstSumByProcDefine()
	{
		ProcdefineDAO procdefineDAO=(ProcdefineDAO)BeanFactory.getBean("ProcdefineDAO");
		return procdefineDAO.queryInstSumByProcDefine();
	}
	/**
	 * 	�õ�ĳ��ģ����ĳ��״̬��ʵ��
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
	 * �����������͵õ���Ӧ������ģ��
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
	 * ��ѯ����ʵ��������Ϣ
	 * @param procInstId
	 * @return
	 */
	public List queryProcInstExamineInfo(String procInstId)
	{
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		return procInstEntity.queryProcInstExamineInfo(procInstId);
	}
	/**
	 * ɾ������ģ������ɾ��
	 * @param procDeineId
	 */
	public void delProcDefine(String procDeineId)
	{
		ProcDefineService procd=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		procd.deleteProcDsfine(procDeineId);
	}
	
	

	/**
	 * �޸�����ģ��״̬
	 * @param procDeineId
	 * @param state
	 */
	public void stopProcDefine(String procDeineId)
	{
		ProcDefineService procd=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		procd.updateProcState(procDeineId, WFConstant.WF_PROC_STATE_STOP);
	}
	/**
	 * ��������ģ��
	 * @param procDeineId
	 */
	public void startProcDefine(String procDeineId)
	{
		ProcDefineService procd=(ProcDefineService)BeanFactory.getBean("ProcDefineService");
		procd.updateProcState(procDeineId, WFConstant.WF_PROC_STATE_RUN);
		
	}
	/**
	 * ɾ������ʵ�������Ϣ
	 * @param procInstId
	 */
	public void delProcInst(String procinstId)
	{
		ProcInstService procInst=(ProcInstService)BeanFactory.getBean("ProcInstService");
		procInst.deleteProcInst(procinstId);
		
	}

	/**
	 * �õ����̹����б�
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
	 * ����Idֹͣ����ʵ��
	 * @param procInstId
	 * @return
	 */
	public void stopProcInst(String procInstId){
		ProcInstService procInst=(ProcInstService)BeanFactory.getBean("ProcInstService");
		procInst.updateProcInstStopById(procInstId);
	}
	/**
	 * ����userid��ѯ���͵������б�
	 * @param procInstId
	 * @return
	 */
	public List queryPorcInstCCByUserId(String userId){
		ProcinstCopyDAO procinstCopyDAO=(ProcinstCopyDAO)BeanFactory.getBean("ProcinstCopyDAO");
		return procinstCopyDAO.queryCopyProcInstsByuserId(userId);
	}
	/**
	 * ������ʵ������ת�����ڵ�
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
	 * ��ѯ�ڵ�������Ϣ
	 * @param procInstId
	 */
	public List qyeryNodeApply(String procInstId){
		ProcInstService procInst=(ProcInstService)BeanFactory.getBean("ProcInstService");
		return procInst.queryProcInstApply(procInstId);
	}
	/**
	 * ��ѯ��ǰ�û��μ�����������ʵ��
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
	 * ��ѯ��ǰ�û��μ�����������ʵ��
	 * @param userId �û�ID
	 * @param roleId ��ɫ
	 * @param state ����ʵ��״̬
	 * @param examineinstState ����ʵ��״̬
	 * @return
	 */
	public List queryJoinInstByUserBystate(String userId,String roleId,String state,String examineinstState,String procId,String procType){
		ProcInstService procInst=(ProcInstService)BeanFactory.getBean("ProcInstService");
		List examineInstList=procInst.queryJoinProcInstByUserState(userId, roleId, state,examineinstState,procId,procType);
		return examineInstList;
	}
	/**
	 * ���ݽڵ�ID��ѯ�ɻ��˵Ľڵ�
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
	 * ��������ʵ��ID����ҵ������
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
	 * ��������ʵ��ID�ж��Ƿ�Ϊ��������
	 * @param procInstId
	 * @return true/false true Ϊ���������̣�falseΪ����������
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
	 * �鿴��ǰ����ʵ����״̬
	 * 
	 * 
	 * */
	public List queryCurrExamineinst(String procinstId){
		
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		
		return procInstEntity.getProcInstService().getExamineinstDAO().queryCurrExamineinst(procinstId);
	}
	/**
	 * �鿴��ǰ����ʵ����״̬
	 * 
	 * 
	 * */
	public List queryCurrExamineinstNode(String procinstId){
		
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		
		return procInstEntity.getProcInstService().getExamineinstDAO().queryCurrExamineinstNode(procinstId);
	}
	
	/**
	 * ��������ʵ��
	 * */
	public void procInstHangUp(String procInstId){
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.getProcInstService().getProcInstDAO().procInstHangUp(procInstId);
	}

	/**
	 * �ָ�����ʵ��
	 * */
	
	public void procInsRecovery(String procInstId){
		ProcInstEntity procInstEntity=(ProcInstEntity)BeanFactory.getBean("ProcInst");
		procInstEntity.getProcInstService().getProcInstDAO().procInsRecovery(procInstId);
	}
	
	/**
	 * ɾ������
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
	 * ��������ģ��
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
