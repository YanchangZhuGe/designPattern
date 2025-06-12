package com.cnpc.sais.bpm.runtime.entity.inst;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.Element;

import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.soa.exception.RetCodeException;
import com.cnpc.sais.bpm.bean.ExamineListBean;
import com.cnpc.sais.bpm.bean.ExamineinstBean;
import com.cnpc.sais.bpm.cache.MemberCache;
import com.cnpc.sais.bpm.dao.ExamineinstDAO;
import com.cnpc.sais.bpm.dao.ProcInstDAO;
import com.cnpc.sais.bpm.define.entity.node.AbstractNodeEntity;
import com.cnpc.sais.bpm.define.entity.process.ProcessDefineEntity;
import com.cnpc.sais.bpm.define.entity.process.TaskDefineEntity;
import com.cnpc.sais.bpm.pojo.WfDNode;
import com.cnpc.sais.bpm.pojo.WfRExamineinst;
import com.cnpc.sais.bpm.pojo.WfRProcinst;
import com.cnpc.sais.bpm.pojo.WfRTaskinst;
import com.cnpc.sais.bpm.pojo.WfRTonen;
import com.cnpc.sais.bpm.pojo.WfRVariableinst;
import com.cnpc.sais.bpm.service.ProcDefineService;
import com.cnpc.sais.bpm.service.ProcInstService;
import com.cnpc.sais.bpm.util.DateUtil;
import com.cnpc.sais.bpm.util.ObjectCopy;
import com.cnpc.sais.bpm.util.WFConstant;
import com.cnpc.sais.bpm.util.WFUtils;
/**
 * @author 夏烨
 * @version 创建时间：2009-8-7 下午01:44:12 类说明
 */
public class ProcInstEntity {

	private WfRProcinst wfRProcinst;
	
	private TokenInstEntity rootToken;

	private TokenInstEntity superProcToken;

	private ProcessDefineEntity procDefine;
	
	private ProcInstService procInstService;
	
	private ProcDefineService procDefineService;
	
	private ExamineinstDAO examineinstDAO;
	
	private WFUtils utils=new WFUtils();
	
	private List variables=new ArrayList();

	private DateUtil dateUtil=new DateUtil();
    private String userId; 
	
    private String ccUsers;
	public void  initProcInstEntity(String createUser,String userName,String orgId) {
	    wfRProcinst=new WfRProcinst();
		this.wfRProcinst.setEntityId("");
		this.wfRProcinst.setProcName(procDefine.getWfDProcdefine().getProcName());
		this.wfRProcinst.setProcVersion(procDefine.getWfDProcdefine().getProcVersion());
		this.wfRProcinst.setStartNodeid(procDefine.getWfDProcdefine().getStartNode());
		this.wfRProcinst.setProcId(procDefine.getWfDProcdefine().getEntityId());
	    this.wfRProcinst.setCreateDate(dateUtil.GetDateTime());
		this.wfRProcinst.setState(WFConstant.WF_PROCINST_STATE_START);
		this.wfRProcinst.setCreateUser(createUser);
		this.wfRProcinst.setCreateUserName(userName);
		this.wfRProcinst.setOrgId(orgId);
		this.wfRProcinst.setProcEName(procDefine.getWfDProcdefine().getProcEName());
	}
	public void  initProcInst(String entityId) {
		//数据库中加载流程实例基本信息
		this.wfRProcinst=this.getProcInstService().getProcInstDAO().queryProcInstByID(entityId);
		String tokenID=wfRProcinst.getRoottoken();
		WfRTonen wfRTonen=this.getProcInstService().getTokenInstDAO().queryTokenInstByID(tokenID);
		rootToken=new TokenInstEntity();
		rootToken.setWfRTonen(wfRTonen);
		//加载流程模板信息
//		ProcessDefineEntity procDefine=this.getProcDefineService().getProcessDefineEntityByID(this.wfRProcinst.getProcId(),false);
		String cacheKey=this.wfRProcinst.getProcEName()+"_"+this.wfRProcinst.getProcVersion();
		ProcessDefineEntity procDefine=MemberCache.getInstance().retrieveProcDefine(cacheKey);
		
		this.setProcDefine(procDefine);
	}
	public void setCCusers(String ccUsers){
		this.ccUsers=ccUsers;
	}
	/**
	 * 启动流程
	 * @throws Exception 
	 * @throws Exception 
	 */
	public void startProcInst(){
		 //1.启动根令牌，指向开始节点
		rootToken=new TokenInstEntity();
		rootToken.getWfRTonen().setStartNodeid(this.wfRProcinst.getStartNodeid());
		rootToken.getWfRTonen().setState(WFConstant.WF_TOKEN_STATE_START);
		rootToken.getWfRTonen().setNodeId(this.wfRProcinst.getStartNodeid());
		rootToken.getWfRTonen().setProcinstId(this.wfRProcinst.getEntityId());
		rootToken.getWfRTonen().setTonkenStartDate(utils.getNowDate());
		//2.根据NODE定义得到TASK定义，创建TASK实例,启动审批实例EXAMINEINST
		String startNodeID=this.wfRProcinst.getStartNodeid();
		AbstractNodeEntity startNode=this.procDefine.getNodeByNodeID(startNodeID);
		
		//如果该起始节点是审批节点
		if(startNode.getWfDNode().getNodeType().equals(WFConstant.WF_PROCDEFINE_NODE_TYPE_PEOPLES_NODE)||startNode.getWfDNode().getNodeType().equals(WFConstant.WF_PROCDEFINE_NODE_TYPE_FORK_NODE)){
			//得到节点的TASK定义列表
			List  taskInstList=this.getTaskInstEntityByNode(startNode,"");
		    //数据同步到数据库
			this.getProcInstService().saveStartProcInst(wfRProcinst,rootToken.getWfRTonen(), taskInstList,this.getVariables(),this.ccUsers);
		}else{
			AbstractNodeEntity nextNode=this.procDefine.getNextApplyNode(startNode.getWfDNode().getEntityId());
			List  taskInstList=new ArrayList();
			if(!nextNode.getWfDNode().getNodeType().equals(WFConstant.WF_PROCDEFINE_NODE_TYPE_PEOPLES_NODE)){
				
				nextNode.setCruTonen( rootToken.getWfRTonen());
				rootToken.getWfRTonen().setNodeId(nextNode.getNodeID());
				nextNode.setProcInstEntity(this);
				this.getProcInstService().saveStartProcInst(wfRProcinst,rootToken.getWfRTonen(), taskInstList,this.getVariables(),this.ccUsers);
				Map map=new HashMap();
				map.put("examineinstID", "");
				map.put("examineInfo", "");
				map.put("examineUserName", WFConstant.SYSTEM_USER);
				map.put("cruTonen", rootToken.getWfRTonen());
				map.put("nextNodeID", "");
				map.put("ptaskId", "1");
				map.put("procState", wfRProcinst.getState());
				map.put("userId", "");
				map.put("procInstState", new HashMap());
				nextNode.init(map);
				nextNode.startNodeInst();
			}else{
				rootToken.getWfRTonen().setNodeId(nextNode.getWfDNode().getEntityId());
				taskInstList=this.getTaskInstEntityByNode(nextNode,"");
				//数据同步到数据库
				this.procInstService.saveStartProcInst(wfRProcinst,rootToken.getWfRTonen(), taskInstList,this.getVariables(),this.ccUsers);
			}
		}
	}
	
	/**
	 * 重新启动流程
	 * @throws Exception 
	 * @throws Exception 
	 */
	public void reStartProcInst(String procInstId,String nodeId,String movNodeId){
		WfRTonen wfRTonen=this.procInstService.getTokenInstDAO().queryTokenByNodeProcinst(nodeId, procInstId);
		this.wfRProcinst.setState(WFConstant.WF_PROCINST_STATE_START);
		rootToken=new TokenInstEntity();
		if(wfRTonen!=null){
			rootToken.setWfRTonen(wfRTonen);
		}
		rootToken.getWfRTonen().setStartNodeid(this.wfRProcinst.getStartNodeid());
		rootToken.getWfRTonen().setState(WFConstant.WF_TOKEN_STATE_START);
		rootToken.getWfRTonen().setNodeId(this.wfRProcinst.getStartNodeid());
		rootToken.getWfRTonen().setProcinstId(this.wfRProcinst.getEntityId());
		rootToken.getWfRTonen().setTonkenStartDate(utils.getNowDate());
		if(StringUtils.isNotBlank(movNodeId)){
			List  taskInstList=null;
			if(this.getProcInstService().isRootTokenByNode(movNodeId, procInstId)){
				rootToken.getWfRTonen().setNodeId(movNodeId);
				AbstractNodeEntity moveNode=this.procDefine.getNodeByNodeID(movNodeId);
				moveNode.setCruTonen(rootToken.getWfRTonen());
				this.getProcInstService().getTokenInstDAO().updateTokenInst(rootToken.getWfRTonen());
				taskInstList=this.getTaskInstEntityByNode(moveNode,"1");
				this.getProcInstService().saveStartNextTaskInst(taskInstList, this.getWfRProcinst(),rootToken.getWfRTonen()); 
			}else{
				AbstractNodeEntity Node=this.procDefine.getNextApplyNode(nodeId);
				while(!Node.getWfDNode().getNodeType().equals(WFConstant.WF_PROCDEFINE_NODE_TYPE_FORK_NODE)){
					Node=this.procDefine.getNextApplyNode(Node.getWfDNode().getEntityId());
				}
				TokenInstEntity subToken=new  TokenInstEntity();
				
				rootToken.getWfRTonen().setState(WFConstant.WF_TOKEN_STATE_DOWN);
				rootToken.getWfRTonen().setNodeId(Node.getWfDNode().getEntityId());
				this.getProcInstService().getTokenInstDAO().updateTokenInst(rootToken.getWfRTonen());
				List<WfRTaskinst> wfRTaskinstList=this.getProcInstService().getTaskInstDAO().queryTaskInstsByNode(procInstId, movNodeId);
				subToken.setWfRTonen(this.getProcInstService().getTokenInstDAO().queryTokenInstByID(wfRTaskinstList.get(0).getToken()));
				subToken.getWfRTonen().setStartNodeid(this.wfRProcinst.getStartNodeid());
				subToken.getWfRTonen().setState(WFConstant.WF_TOKEN_STATE_START);
				subToken.getWfRTonen().setNodeId(movNodeId);
				subToken.getWfRTonen().setProcinstId(this.wfRProcinst.getEntityId());
				subToken.getWfRTonen().setTonkenStartDate(utils.getNowDate());
				AbstractNodeEntity moveNode=this.procDefine.getNodeByNodeID(movNodeId);
				moveNode.setCruTonen(subToken.getWfRTonen());
				this.getProcInstService().getTokenInstDAO().updateTokenInst(subToken.getWfRTonen());
				taskInstList=this.getTaskInstEntityByNode(moveNode,"1");
				this.getProcInstService().saveStartNextTaskInst(taskInstList, this.getWfRProcinst(),subToken.getWfRTonen());
				this.getProcInstService().addUpNodeByToken(subToken.getWfRTonen(), procInstId);
			}
			
			
		}else{
			String startNodeID=this.wfRProcinst.getStartNodeid();
			
			AbstractNodeEntity startNode=this.procDefine.getNodeByNodeID(startNodeID);
			//如果该起始节点是审批节点
			if(startNode.getWfDNode().getNodeType().equals(WFConstant.WF_PROCDEFINE_NODE_TYPE_PEOPLES_NODE)||startNode.getWfDNode().getNodeType().equals(WFConstant.WF_PROCDEFINE_NODE_TYPE_FORK_NODE))
			{
				//得到节点的TASK定义列表
				List  taskInstList=this.getTaskInstEntityByNode(startNode,"");
			    //数据同步到数据库
				this.getProcInstService().saveReStartProcInst(wfRProcinst,rootToken.getWfRTonen(), taskInstList,this.getVariables(),this.ccUsers);
			}else{
				startNode=this.procDefine.getNextApplyNode(startNode.getWfDNode().getEntityId());
				List  taskInstList=new ArrayList();
				if(!startNode.getWfDNode().getNodeType().equals(WFConstant.WF_PROCDEFINE_NODE_TYPE_PEOPLES_NODE)){
					startNode.setCruTonen( rootToken.getWfRTonen());
					rootToken.getWfRTonen().setNodeId(startNode.getNodeID());
					startNode.setProcInstEntity(this);
					this.getProcInstService().saveReStartProcInst(wfRProcinst,rootToken.getWfRTonen(), taskInstList,this.getVariables(),this.ccUsers);
					Map map=new HashMap();
					map.put("examineinstID", "");
					map.put("examineInfo", "");
					map.put("examineUserName", WFConstant.SYSTEM_USER);
					map.put("cruTonen", rootToken.getWfRTonen());
					map.put("nextNodeID", "");
					map.put("ptaskId", "1");
					map.put("procState", wfRProcinst.getState());
					map.put("userId", "");
					map.put("procInstState", new HashMap());
					startNode.init(map);
					startNode.startNodeInst();
				}else{
					rootToken.getWfRTonen().setNodeId(startNode.getWfDNode().getEntityId());
					taskInstList=this.getTaskInstEntityByNode(startNode,"");
				}
				
			    //数据同步到数据库
				this.getProcInstService().saveReStartProcInst(wfRProcinst,rootToken.getWfRTonen(), taskInstList,this.getVariables(),this.ccUsers);
			}
		}
		
	}

	/*
	 * 得到下级节点列表
	 */
    public List getNextNodeList(String examineinstID)
	{
    	WfRExamineinst wfRExamineinst = this.getProcInstService().getExamineinstDAO().queryExamineinstByID(examineinstID);
		WfRTaskinst currentTaskInst = this.getProcInstService().getTaskInstDAO().queryWfRTaskinstByID(wfRExamineinst.getTaskinstId());
    	
	    List nodeList=this.getProcDefine().getNextNodes(currentTaskInst.getNodeId());
	    return nodeList;
    }
    /*
	 * 得到当前节点
	 */
	public AbstractNodeEntity getCurNode() {
		return this.getProcDefine().getNodeByNodeID(
				this.rootToken.getWfRTonen().getNodeId());
	}
	
	private void stopProcInst()
	{
       //1.数据同步到数据库
		
	}
	
	/**
	 * 得到当前正在运行的token
	 * @param examineinstID
	 * @return
	 */
	 public WfRTonen getCurToken(String examineinstID)
		{
	    	WfRExamineinst wfRExamineinst = this.getProcInstService().getExamineinstDAO().queryExamineinstByID(examineinstID);
			WfRTaskinst currentTaskInst = this.getProcInstService().getTaskInstDAO().queryWfRTaskinstByID(wfRExamineinst.getTaskinstId());
			return this.getProcInstService().getTokenInstDAO().queryTokenInstByID(currentTaskInst.getToken());
	    }

	/**
	 * 审批流程
	 * @param nextNodeID 下级节点ID
	 * @param examineInfo 审批信息
	 * @param isPass  是否通过
	 * @throws Exception 
	 */
	public Map examineProcess(String nextNodeID, String examineInfo,
			String isPass, String examineinstID, String examineUserName,
			String ptaskId, String userId,String busiInfo) {
		Map examineMap = new HashMap();
		if (examineInfo == null) {
			examineInfo = "";
		}
		examineMap.put("procInstState", WFConstant.WF_PROCINST_STATE_START);
		WfRTonen cruTonen = this.getCruTonen(examineinstID);
		// 判断时候是结束节点
		boolean isEndNode = this.isEndNode(nextNodeID, cruTonen);
		// 判断流程运行状态
		String procState = this.estimateProcInstState(isPass, isEndNode);
		// 判断是否是汇聚节点
		// boolean isForkNode=this.procDefine.isForkNode(cruTonen.getNodeId());

		Map args = new HashMap();
		args.put("examineinstID", examineinstID);
		args.put("examineInfo", examineInfo);
		args.put("examineUserName", examineUserName);
		args.put("cruTonen", cruTonen);
		args.put("nextNodeID", nextNodeID);
		args.put("ptaskId", ptaskId);
		args.put("procState", procState);
		args.put("userId", userId);
		args.put("busiInfo", busiInfo);
		args.put("procInstState", examineMap);

		// 得到当前节点
		AbstractNodeEntity cruNode = this.getProcDefine().getNodeByNodeID(
				cruTonen.getNodeId(), args);
		cruNode.setProcInstEntity(this);
		cruNode.execute();

		// 得到下级节点
		if (cruNode.getIsPass()) {
			AbstractNodeEntity nextNode = this.getProcDefine().getNodeByNodeID(nextNodeID, args);
			nextNode.setProcInstEntity(this);
			nextNode.startNodeInst();
		}

		return examineMap;

	}
	public WfRTonen getCruTonen(String examineinstID){
		WfRTonen cruTonen=null;
		WfRTonen rootTonen=this.getRootToken().getWfRTonen();
		if(this.getRootToken().getWfRTonen().getState().equals(WFConstant.WF_TOKEN_STATE_WAIT)
				||this.getRootToken().getWfRTonen().getState().equals(WFConstant.WF_TOKEN_STATE_DOWN)
						||this.getRootToken().getWfRTonen().getState().equals(WFConstant.WF_TOKEN_STATE_BACK)){
			cruTonen=this.getCurToken(examineinstID);
		}else{
			cruTonen=this.getRootToken().getWfRTonen();
		}
		return cruTonen;
	}
	
	public String  getUrls(String examInstId){
		WfRTonen cruTonen = this.getCruTonen(examInstId);
		Map args = new HashMap();
		args.put("examineinstID", examInstId);
		args.put("examineInfo", "");
		args.put("examineUserName", "");
		args.put("cruTonen", cruTonen);
		args.put("nextNodeID", "");
		args.put("ptaskId", "");
		args.put("procState", "");
		args.put("userId", "");
		args.put("busiInfo", "");
		args.put("procInstState", new HashMap());
		AbstractNodeEntity cruNode = this.getProcDefine().getNodeByNodeID(cruTonen.getNodeId(), args);
		
		return cruNode.getWfDNode().getUrls();
	}
	
	/**
	 * 判断时候是结束节点
	 * @param nextNodeID
	 * @param cruTonen
	 * @return
	 */
	public boolean isEndNode(String nextNodeID,WfRTonen cruTonen){
		
		boolean isEndNode=false;
		if(nextNodeID.equals("")){
			isEndNode=this.getProcDefine().isEndNode(cruTonen);
			}else{
			isEndNode=this.getProcDefine().isEndNodeByNodeId(nextNodeID);
			}
		return isEndNode;
	}
	/**
	 * 并行节点处理--得到下级节点，启动相应的实例信息
	 * @param nextNodeID
	 * @param isLiveTask
	 * @param ptaskId
	 */
	private void parallelFlow(String curNodeId,boolean isLiveTask,String ptaskId){
			List subTonkenList=new ArrayList();
			List taskInstList=new ArrayList();
			 //1.设置令牌指向
			int nodesSize=0;
             //2.得到当前节点的下级并行节点
			List<AbstractNodeEntity> nextNodes=this.procDefine.getNextNodeEntitys(curNodeId);
			if(nextNodes!=null&&nextNodes.size()>1){
				this.rootToken.getWfRTonen().setState(WFConstant.WF_TOKEN_STATE_WAIT);
				nodesSize=nextNodes.size();
				for (int i = 0; i < nodesSize; i++) {
					AbstractNodeEntity nextNode = (AbstractNodeEntity) nextNodes
							.get(i);
					// 设置subtoken信息
					WfRTonen subToken = new WfRTonen();
					subToken.setParentTokenid(this.rootToken.getWfRTonen()
							.getEntityId());
					subToken.setProcinstId(this.rootToken.getWfRTonen()
							.getProcinstId());
					subToken.setStartNodeid(nextNode.getNodeID());
					subToken.setState(WFConstant.WF_TOKEN_STATE_START);
					subToken.setNodeId(nextNode.getNodeID());
					subTonkenList.add(subToken);

					if (!isLiveTask) {
						// 2.根据NODE定义得到TASK定义，创建TASK实例,启动审批实例EXAMINEINST
						taskInstList = this.getTaskInstEntityByNode(nextNode,
								ptaskId);
						// 启动下级节点实例
						this.getProcInstService().saveParallelFlowExamine(
								wfRProcinst, subToken, taskInstList);
					}

				}
				
			}
	}
	

	/**
	 * 得到用户审批实例信息
	 * @param examineinstID
	 * @param examineInfo
	 * @return
	 * @throws Exception
	 */
	public WfRExamineinst getExamineinstByID(String examineinstID,
			String examineInfo, String examineState, String examineUserName,String userId) {
		WfRExamineinst wfRExamineinst = this.getProcInstService()
				.getExamineinstDAO().queryExamineinstByID(examineinstID);
		wfRExamineinst.setExamineInfo(examineInfo);
		wfRExamineinst.setIspass(examineState);
		wfRExamineinst.setState(examineState);
		wfRExamineinst.setExamineUserName(examineUserName);
		//更新审批用户信息到examineInst
		wfRExamineinst.setExamineUserId(userId);
		
		wfRExamineinst.setExamineEndDate(dateUtil.GetDateTime());
		return wfRExamineinst;

	}
	
    /**
     * 根据节点的TASK定义得到审批节点实例
     * @param node
     * @return
     */
	public List getTaskInstEntityByNode(AbstractNodeEntity node,String ptaskId)
	{
		    List list=new ArrayList();
			TaskInstEntity taskInstEntity=null;
			List taskList=node.getCurrentTasks();
			List examines=new ArrayList();
			for(int i=0;i<taskList.size();i++)
			{
				TaskDefineEntity taskDefineEntity=(TaskDefineEntity)taskList.get(i);
				taskDefineEntity.setProcInstEntity(this);
//				examines=taskDefineEntity.getWfRExamineinst();
				
				taskInstEntity=new TaskInstEntity();
				WfRTaskinst wfRTaskinst=new WfRTaskinst();
				wfRTaskinst.setIsOpen(WFConstant.WF_TASKINST_OPEN_START);
				wfRTaskinst.setNodeId(node.getNodeID());
				wfRTaskinst.setProcId(this.wfRProcinst.getProcId());
				wfRTaskinst.setProcType(this.procDefine.getWfDProcdefine().getProcType());
				wfRTaskinst.setState(WFConstant.WF_TASKINST_STATE_START);
				wfRTaskinst.setTaskPriority("");
				wfRTaskinst.setToken("");
				wfRTaskinst.setTaskId(taskDefineEntity.getWfDTask().getEntityId());
				wfRTaskinst.setProcinstId("");
				wfRTaskinst.setPtaskId(ptaskId);
				taskInstEntity.setWfRTaskinst(wfRTaskinst);
				//如果不是第一次启动该实例，用户审批实例已经缓存
				if(taskDefineEntity.getExamineinstList().size()==0 )
				{
				  examines=taskDefineEntity.getWfRExamineinst();
				  taskInstEntity.setExamineList(examines);
				}else
				{
					List wfRExamineinstList=new ArrayList();
					for(Object obj:taskDefineEntity.getExamineinstList()){
					
						try {
							WfRExamineinst wfRExamineinst=(WfRExamineinst)ObjectCopy.copy(obj);
							wfRExamineinst.setEntityId("");
							//procInstService.getExamineinstDAO().addExpiryDate(node.getWfDNode(), wfRExamineinst);
							wfRExamineinstList.add(wfRExamineinst);
							
						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					
					taskInstEntity.setExamineList(wfRExamineinstList);
				}
				
//				taskInstEntity.setExamineList(examines);
				if(taskInstEntity.getExamineList().size()>0){
					list.add(taskInstEntity);
				}
			}
			
		return list;
	}
	

	
	/**
	 * 判断流程实例的运行状态
	 * @param isPass
	 * @param isEndNode
	 * @return
	 */
	private String estimateProcInstState(String isPass,boolean isEndNode)
	{
		String procState="";
		if(isPass.equals("passend")){
			procState=WFConstant.WF_PROCINST_STATE_PASSEND;
		}
		if(isPass.equals("nopassend")){
			procState=WFConstant.WF_PROCINST_STATE_NOPASSEND;
		}
		if(isPass.equals("pass")&&isEndNode==true)
		{
			procState=WFConstant.WF_PROCINST_STATE_PASSEND;
		}else if(isPass.equals("nopass")&&isEndNode==true)
		{
			procState=WFConstant.WF_PROCINST_STATE_NOPASSEND;
		}else if(isPass.equals("nopass")&&isEndNode==false)
		{
			procState=WFConstant.WF_PROCINST_STATE_NOPASS;
		}else if(isPass.equals("pass")&&isEndNode==false)
		{
			procState=WFConstant.WF_PROCINST_STATE_PASSRUN;
		}
		return procState;
		
	}
	
	
	/**
     * 回退当前流程
     * @param exanimrInstId
	 * @throws Exception 
     */
    public void backProcInst(String examineInsetId,String examineInfo) 
    {
    	this.getProcInstService().addBackProcInst(this, examineInsetId,examineInfo);
    	
    }
    /**
	 * 查询当前用户发起的流程实例
	 * @param userId
	 * @return
	 */
	public List queryProcInstByUserId(String userId,String procType)
	{
		return this.getProcInstService().queryProcInsts(userId, procType);
		
	}
	/**
	 * 查询某流程实例的审批信息
	 * @param procInstId
	 * @return
	 */
	public List queryProcInstExamineInfo(String procInstId)
	{
		Map assortMap=new HashMap();
		List list=new ArrayList();
		List examineList=this.getProcInstService().getProcInstDAO().queryProcInstExamineInfo(procInstId);
		if(examineList!=null)
		{
			
			Iterator iterator1 = examineList.iterator(); 
			while (iterator1.hasNext()) { 
				Map o = (Map) iterator1.next(); 
				String key=(String)o.get("nodeid");
				ExamineListBean examineListBean=this.isDoubleExamine(list, key);
				if(examineListBean!=null)
				{
					String nodename=(String)o.get("nodename");
					String startdate=(String)o.get("startdate");
					String enddate=(String)o.get("enddate");
					String examineinfo=(String)o.get("examineinfo");
					String username=(String)o.get("username");
					String state=(String)o.get("state");
					
					ExamineinstBean examineinstBean=new ExamineinstBean();
					examineinstBean.setEnddate(enddate);
					examineinstBean.setExamineinfo(examineinfo);
					examineinstBean.setStartdate(startdate);
					examineinstBean.setUsername(username);
					examineinstBean.setState(state);
					
					examineListBean.addExamineInfo(examineinstBean);
				}else
				{
					ExamineListBean examineListBean1=new ExamineListBean();
					examineListBean1.setNodeId(key);
					String nodename=(String)o.get("nodename");
					String startdate=(String)o.get("startdate");
					String enddate=(String)o.get("enddate");
					String examineinfo=(String)o.get("examineinfo");
					String username=(String)o.get("username");
					String state=(String)o.get("state");
					
					examineListBean1.setNodeName(nodename);
					
					ExamineinstBean examineinstBean=new ExamineinstBean();
					examineinstBean.setEnddate(enddate);
					examineinstBean.setExamineinfo(examineinfo);
					examineinstBean.setStartdate(startdate);
					examineinstBean.setUsername(username);
					examineinstBean.setState(state);
					
					examineListBean1.addExamineInfo(examineinstBean);
					list.add(examineListBean1);
				}
				
			   
			}
		
			
		}
		
		return list;
	}
	
	private ExamineListBean isDoubleExamine(List list,String nodeId)
	{
	   ExamineListBean examineListBean=null;
	   if(list!=null)
	   {
		   for(int i=0;i<list.size();i++)
		   {
			   ExamineListBean bean=(ExamineListBean)list.get(i);
			   if(!bean.getNodeId().equals("")&&bean.getNodeId().equals(nodeId))
			   {
				   examineListBean=bean;
				   
			   }
		   }
	   }
	   return examineListBean;
		
	}
    /**
     * 是否是第一级审批节点
     * @return
     */
    public boolean isFirstApplyNode()
    {
    	boolean isApply=false;
    	
    	String parentNodeId=this.getProcDefine().getParentNode(this.getRootToken().getWfRTonen().getNodeId());
		AbstractNodeEntity parentNode=this.getProcDefine().getNodeByNodeID(parentNodeId);
		if(parentNode!=null&&parentNode.getWfDNode().getNodeType().equals(WFConstant.WF_PROCDEFINE_NODE_TYPE_START))
		{
			isApply=true;
		}
    	if(parentNodeId==null||parentNodeId.equals(""))
    	{
    		isApply=true;
    	}
    	return isApply;
    }
    /**
     * 得到流程实例运行情况描述
     * @return
     */
    public String getProcInstView()
    {
    	String viewXml="";
    	Document doc=this.getProcDefine().getProcDefineView();
    	System.out.println("procInst View:"+doc.asXML());
    	if(doc!=null)
    	{
    	Map nodeStateMap=this.getProcInstService().getProcInstNodeState(this);
    	
    	//设置运行节点颜色
    	List list = doc.selectNodes("//Nodes/Node/BaseProperties");
    	    Iterator iter = list.iterator();
    	   while (iter.hasNext()) {
    		  Element element = (Element) iter.next();
    		  String nodeId=element.attribute("id").getStringValue();
    		  String isRun=(String)nodeStateMap.get(nodeId);
    		  if(isRun.equals("true"))
    		  {
    			  Element nodeElement=element.getParent();
    			  Element  VMLPropertiesElement= nodeElement.element("VMLProperties");
    			  VMLPropertiesElement.addAttribute("isFocused", "T");
    		  }
    	   }
    	
    	   //设置流程线颜色
    	   List lineList = doc.selectNodes("//Lines/Line/BaseProperties");
   	       Iterator lineIter = lineList.iterator();
	   	    while (lineIter.hasNext()) {
	  		  Element element = (Element) lineIter.next();
	  		  String nodeId=element.attribute("to").getStringValue();
	  		  String isRun=(String)nodeStateMap.get(nodeId);
	  		  if(isRun.equals("true"))
	  		  {
	  			  Element lineElement=element.getParent();
	  			  Element  VMLPropertiesElement= lineElement.element("VMLProperties");
	  			  VMLPropertiesElement.addAttribute("isFocused", "T");
	  		  }
	  		
	  		  
	  	   }
    	   
    	   viewXml=doc.asXML();
    	}
    	return viewXml;
    }
    /**
     * 在流程实例中移动节点
     * @param examineInstId
     * @param examineInfo
     * @param moveNodeId
     */
    public void moveNodeProcInst(String examineInstId, String examineInfo,
		String moveNodeId,String taskInstId,UserToken userToken) {
    	AbstractNodeEntity moveNode=null;
    	String cacheKey=this.wfRProcinst.getProcEName()+"_"+this.wfRProcinst.getProcVersion();
		ProcessDefineEntity procDefine=MemberCache.getInstance().retrieveProcDefine(cacheKey);
		//判断下如果moveNodeId为空则自动需要找到上级用户审批类型节点
		WfRTonen cruToken=this.getCurToken(examineInstId);
		//List moveNodes=new ArrayList();
		if(moveNodeId==null||moveNodeId.equals("")){
			//moveNodes=this.getProcDefine().getPeopleParentNodes(cruToken.getNodeId());
	    	System.out.println("nodeid 为空不能正常后退！！！");
			
		}else{
			moveNode=this.getProcDefine().getNodeByNodeID(moveNodeId);
			//moveNodes.add(node);
		}
		
		this.getProcInstService().addMoveNode(this, examineInstId,
				examineInfo, moveNode, procDefine,taskInstId,cruToken, userToken);
	
		
	}
    
	public TokenInstEntity getSuperProcToken() {
		return superProcToken;
	}
	public void setSuperProcToken(TokenInstEntity superProcToken) {
		this.superProcToken = superProcToken;
	}
	public TokenInstEntity getRootToken() {
		return rootToken;
	}
	public void setRootToken(TokenInstEntity rootToken) {
		this.rootToken = rootToken;
	}
	public ProcessDefineEntity getProcDefine() {
		return procDefine;
	}
	public void setProcDefine(ProcessDefineEntity procDefine) {
		this.procDefine = procDefine;
	}
	public List getVariables() {
		return variables;
	}
	public void setVariables(List variables) {
		this.variables = variables;
	}
	public ProcDefineService getProcDefineService() {
		return procDefineService;
	}
	public void setProcDefineService(ProcDefineService procDefineService) {
		this.procDefineService = procDefineService;
	}
	public ExamineinstDAO getExamineinstDAO() {
		return examineinstDAO;
	}
	public void setExamineinstDAO(ExamineinstDAO examineinstDAO) {
		this.examineinstDAO = examineinstDAO;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}

	public WfRProcinst getWfRProcinst() {
		return wfRProcinst;
	}
	public void setWfRProcinst(WfRProcinst wfRProcinst) {
		this.wfRProcinst = wfRProcinst;
	}
	public ProcInstService getProcInstService() {
		return procInstService;
	}
	public void setProcInstService(ProcInstService procInstService) {
		this.procInstService = procInstService;
	}
}
