package com.cnpc.sais.bpm.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.sais.bpm.bean.TaskInstBean;
import com.cnpc.sais.bpm.cache.MemberCache;
import com.cnpc.sais.bpm.dao.ExamineinstDAO;
import com.cnpc.sais.bpm.dao.ProcInstDAO;
import com.cnpc.sais.bpm.dao.ProcinstCopyDAO;
import com.cnpc.sais.bpm.dao.TaskInstDAO;
import com.cnpc.sais.bpm.dao.TokenInstDAO;
import com.cnpc.sais.bpm.dao.VariableinstDAO;
import com.cnpc.sais.bpm.define.entity.node.AbstractNodeEntity;
import com.cnpc.sais.bpm.define.entity.process.ProcessDefineEntity;
import com.cnpc.sais.bpm.pojo.WfDNode;
import com.cnpc.sais.bpm.pojo.WfRExamineinst;
import com.cnpc.sais.bpm.pojo.WfRProcinst;
import com.cnpc.sais.bpm.pojo.WfRTaskinst;
import com.cnpc.sais.bpm.pojo.WfRTonen;
import com.cnpc.sais.bpm.runtime.entity.inst.ProcInstEntity;
import com.cnpc.sais.bpm.runtime.entity.inst.TaskInstEntity;
import com.cnpc.sais.bpm.util.DateUtil;
import com.cnpc.sais.bpm.util.WFConstant;

/**
 * @author 夏烨
 * @version 创建时间：2009-8-14 下午02:46:04 RetCodeException 类说明
 */
public class ProcInstService {
	private ProcInstDAO procInstDAO;
	private TokenInstDAO tokenInstDAO;
	private TaskInstDAO taskInstDAO;
	private ExamineinstDAO examineinstDAO;
	private VariableinstDAO variableinstDAO;
    private ProcinstCopyDAO procinstCopyDAO;
    private DateUtil dateUtil=new DateUtil();
	public void saveStartProcInst(WfRProcinst wfRProcinst, WfRTonen wfRTonen,
			List taskInstList, List variables,String ccUsers) {

		// 启动根令牌实例，同步信息到数据库
		this.getTokenInstDAO().saveTokenInst(wfRTonen);
		// 启动流程实例，同步信息到数据库
		this.getProcInstDAO().saveProcInst(wfRProcinst, wfRTonen);
		wfRTonen.setProcinstId(wfRProcinst.getEntityId());
		this.getTokenInstDAO().updateTokenInst(wfRTonen);
		// 启动任务实例，同步信息到数据库
		this.saveStartNextTaskInst(taskInstList, wfRProcinst,wfRTonen);
		// 保存流程变量
		this.getVariableinstDAO().saveVariableinst(variables, wfRProcinst);
		//处理流程实例抄送信息
		this.getProcinstCopyDAO().saveProcinstCopy(ccUsers,wfRProcinst);
		
	}
	
	public void saveReStartProcInst(WfRProcinst wfRProcinst, WfRTonen wfRTonen,
			List taskInstList, List variables,String ccUsers) {

		// 启动根令牌实例，同步信息到数据库
		
		// 启动流程实例，同步信息到数据库
		
		wfRTonen.setProcinstId(wfRProcinst.getEntityId());
		this.getTokenInstDAO().updateTokenInst(wfRTonen);
		wfRProcinst.setRoottoken(wfRTonen.getEntityId());
		this.getProcInstDAO().updateProcInst(wfRProcinst);
		// 启动任务实例，同步信息到数据库
		this.saveStartNextTaskInst(taskInstList, wfRProcinst,wfRTonen);
		// 保存流程变量
		//this.getVariableinstDAO().saveVariableinst(variables, wfRProcinst);
		//处理流程实例抄送信息
		//this.getProcinstCopyDAO().saveProcinstCopy(ccUsers,wfRProcinst);
		
	}
	/**
	 * 完成流程用户实例的关闭-用于存在同级节点时只是关闭审批实例，不开启新的实例
	 * 
	 * @param wfRTonen
	 * @param wfRExamineinst
	 * @param taskInstEntity
	 * @throws Exception
	 */
	public void saveExamineProcInst(WfRProcinst wfRProcinst, WfRTonen wfRTonen,
			WfRExamineinst wfRExamineinst, WfRTaskinst wfRTaskinst,
			List taskInstList) {
		this.getTokenInstDAO().updateTokenInst(wfRTonen);
		this.getExamineinstDAO().updateExamineinst(wfRExamineinst);
		wfRTaskinst.setProcinstId(wfRProcinst.getEntityId());
		this.getTaskInstDAO().updateTaskInst(wfRTaskinst);

		// 关闭其他用户审批实例
		this.closeOtherExamineInstByTaskInst(wfRTaskinst.getEntityId(),
				wfRExamineinst.getEntityId());
		// 启动下级审批TASKINST
		this.saveStartNextTaskInst(taskInstList, wfRProcinst,wfRTonen);
	}
	
	/**
	 * 处理并行节点
	 * @param wfRProcinst
	 * @param wfRTonen
	 * @param wfRExamineinst
	 * @param wfRTaskinst
	 * @param taskInstList
	 */
	public void saveParallelFlowExamine(WfRProcinst wfRProcinst,WfRTonen subWfRTonen,
			List taskInstList){
		this.getTokenInstDAO().saveTokenInst(subWfRTonen);
		
		if(taskInstList!=null){
			for(int i=0;i<taskInstList.size();i++)
			{
				TaskInstEntity taskInstEntity=(TaskInstEntity)taskInstList.get(i);
				taskInstEntity.getWfRTaskinst().setToken(subWfRTonen.getEntityId());
			}
		}
		// 启动下级审批TASKINST
		this.saveStartNextTaskInst(taskInstList, wfRProcinst,subWfRTonen);
		
	}
	
	/**
	 * 处理汇聚节点token信息
	 * @param pTokenId
	 */
	public void updateBatchTokenInstState(String pTokenId,WfRProcinst wfRProcinst,
			WfRExamineinst wfRExamineinst, WfRTaskinst wfRTaskinst,WfDNode nexeNode){
		List subTokens=this.getTokenInstDAO().querySubTokens(pTokenId);
		//同步子Token信息
		for(int i=0;i<subTokens.size();i++){
			WfRTonen subToken=(WfRTonen)subTokens.get(i);
			subToken.setState(WFConstant.WF_TOKEN_STATE_STOP);
			this.getTokenInstDAO().updateTokenInst(subToken);
			
		}
		WfRTonen Ptoken=this.getTokenInstDAO().queryTokenInstByID(pTokenId);
		Ptoken.setNodeId(nexeNode.getEntityId());
		Ptoken.setState(WFConstant.WF_TOKEN_STATE_START);
		this.getTokenInstDAO().updateTokenInst(Ptoken);
		
		this.getExamineinstDAO().updateExamineinst(wfRExamineinst);
		wfRTaskinst.setProcinstId(wfRProcinst.getEntityId());
		this.getTaskInstDAO().updateTaskInst(wfRTaskinst);
	}
	
	/**
	 * 启动下级审批TASKINST
	 * @param taskInstList
	 * @param wfRProcinst
	 * @param wfRTaskinst
	 */
		 public void saveStartNextTaskInst(List taskInstList,WfRProcinst wfRProcinst,WfRTonen wfRTonen){
				if (taskInstList != null) {
					for (int i = 0; i < taskInstList.size(); i++) {
						TaskInstEntity taskInstEntity = (TaskInstEntity) taskInstList
								.get(i);
						WfRTaskinst taskinst = taskInstEntity.getWfRTaskinst();
						taskinst.setProcinstId(wfRProcinst.getEntityId());
						taskinst.setToken(wfRTonen.getEntityId());
						this.getTaskInstDAO().saveTaskInst(taskinst);
						// 启动用户审批实例，同步信息到数据库
						this.getExamineinstDAO().saveExamineinst(
								taskInstEntity.getExamineList(), wfRProcinst, taskinst);
					}
				}
		 }
	/**
	 * 完成流程用户实例的关闭-如果流程是最后节点并通过审批
	 * 
	 * @param wfRProcinst
	 * @param wfRTonen
	 * @param wfRExamineinst
	 * @param wfRTaskinst
	 * @throws Exception
	 */
	public void saveExamineProcInst(WfRProcinst wfRProcinst, WfRTonen wfRTonen,
			WfRExamineinst wfRExamineinst, WfRTaskinst wfRTaskinst) {
		this.getTokenInstDAO().updateTokenInst(wfRTonen);
		this.getExamineinstDAO().updateExamineinst(wfRExamineinst);
		this.getTaskInstDAO().updateTaskInst(wfRTaskinst);
		this.getProcInstDAO().updateProcInst(wfRProcinst);

		// 关闭其他用户审批实例
		this.closeOtherExamineInstByTaskInst(wfRTaskinst.getEntityId(),
				wfRExamineinst.getEntityId());
	}
    /**
     * 关闭同一节点下的所有taskInst和examintInst
     * @param procinstId
     * @param nodeId
     * @param examineInstId
     */
	public void saveCloseAllTakInstExaminst(String procinstId,String nodeId,String examineInstId,boolean isBackFlag ){
		List taskList = this.getTaskInstDAO().queryTaskExamineInstList(
				procinstId, nodeId);
		// 关闭本级所有TaskInst和examintInst
		if (taskList != null) {
			Map taskBeanMap = this.getTaskInstByList(taskList);
			Iterator it = taskBeanMap.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry entry = (Map.Entry) it.next();
				String key = (String) entry.getKey();
				TaskInstBean taskInstBean = (TaskInstBean) entry.getValue();
				if(isBackFlag){
					taskInstBean.getWfRTaskinst().setState(
							WFConstant.WF_EXAMINEINST_STATE_BACK);
					
				}else{
					taskInstBean.getWfRTaskinst().setState(
							WFConstant.WF_EXAMINEINST_STATE_CLOSE);
				}
				
				this.getTaskInstDAO().updateTaskInst(
						taskInstBean.getWfRTaskinst());
				for (int i = 0; i < taskInstBean.getExaminInstList().size(); i++) {
					WfRExamineinst examineinst = (WfRExamineinst) taskInstBean
							.getExaminInstList().get(i);
					if (examineinst.getEntityId().equals(examineInstId)) {
						examineinst
								.setState(WFConstant.WF_EXAMINEINST_STATE_BACK);
					} else {
						examineinst
								.setState(WFConstant.WF_EXAMINEINST_STATE_CLOSE);
					}
					this.getExamineinstDAO().updateExamineinst(examineinst);
				}
			}

		}
	}
	/**
	 * 查询当前用户发起的流程实例
	 * 
	 * @param userId
	 * @return
	 */
	public List queryProcInsts(String userId, String procType) {
		return this.getProcInstDAO().queryProcInstsByUserId(userId, procType);

	}

	public void saveExamineProcInstNoPass(WfRProcinst wfRProcinst,
			WfRTonen wfRTonen, WfRExamineinst wfRExamineinst,
			WfRTaskinst wfRTaskinst) {
		this.getTokenInstDAO().updateTokenInst(wfRTonen);
		this.getExamineinstDAO().updateExamineinst(wfRExamineinst);
		this.getTaskInstDAO().updateTaskInst(wfRTaskinst);
		this.getProcInstDAO().updateProcInst(wfRProcinst);

		// 关闭流程所有用户审批和TASKINST实例
		this.closeProcInst(wfRProcinst.getEntityId());
	}
	public void saveExamineProcInstNoPass(WfRProcinst wfRProcinst,
			WfRTonen wfRTonen) {
		this.getTokenInstDAO().updateTokenInst(wfRTonen);
		this.getProcInstDAO().updateProcInst(wfRProcinst);
		// 关闭流程所有用户审批和TASKINST实例
		this.closeProcInst(wfRProcinst.getEntityId());
	}
	// 关闭同一TASKINST下的其他用户审批实例
	private void closeOtherExamineInstByTaskInst(String taskInstID,
			String rxamineInstID) {

		List otherExamineInstList = this.getExamineinstDAO()
				.queryOtherExamineInstList(taskInstID, rxamineInstID);
		if (otherExamineInstList != null) {
			for (int j = 0; j < otherExamineInstList.size(); j++) {
				WfRExamineinst examineinst = (WfRExamineinst) otherExamineInstList
						.get(j);
				examineinst.setState(WFConstant.WF_EXAMINEINST_STATE_CLOSE);
				this.getExamineinstDAO().updateExamineinst(examineinst);

			}

		}

	}
	

	// 关闭流程实例下的所有用户审批实例和TASKINST
	private void closeProcInst(String procInstID) {

		List otherExamineInstList = this.getExamineinstDAO()
				.queryProcInstExamineInstList(procInstID);
		if (otherExamineInstList != null) {
			for (int j = 0; j < otherExamineInstList.size(); j++) {
				WfRExamineinst examineinst = (WfRExamineinst) otherExamineInstList
						.get(j);
				examineinst.setState(WFConstant.WF_EXAMINEINST_STATE_CLOSE);
				this.getExamineinstDAO().updateExamineinst(examineinst);

			}

		}

		List otherTaskInstList = this.getTaskInstDAO()
				.queryProcInstTaskInstList(procInstID);
		if (otherTaskInstList != null) {
			for (int j = 0; j < otherTaskInstList.size(); j++) {
				WfRTaskinst wfRTaskinst = (WfRTaskinst) otherTaskInstList
						.get(j);
				wfRTaskinst.setState(WFConstant.WF_EXAMINEINST_STATE_CLOSE);
				this.getTaskInstDAO().updateTaskInst(wfRTaskinst);

			}

		}
	}

	/**
	 * 流程审批实例回退
	 * 
	 * @param exanimrInstId
	 * @throws Exception
	 */
	public void addBackProcInst(ProcInstEntity procInstEntity,
		String examineInstId, String examineInfo) {
		String procinstId = procInstEntity.getWfRProcinst().getEntityId();
		String nodeId = procInstEntity.getRootToken().getWfRTonen().getNodeId();

		List taskList = this.getTaskInstDAO().queryTaskExamineInstList(
				procinstId, nodeId);
		// 关闭本级所有TaskInst和examintInst
		if (taskList != null) {
			Map taskBeanMap = this.getTaskInstByList(taskList);
			Iterator it = taskBeanMap.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry entry = (Map.Entry) it.next();
				String key = (String) entry.getKey();
				TaskInstBean taskInstBean = (TaskInstBean) entry.getValue();
				taskInstBean.getWfRTaskinst().setState(
						WFConstant.WF_EXAMINEINST_STATE_CLOSE);
				this.getTaskInstDAO().updateTaskInst(
						taskInstBean.getWfRTaskinst());
				for (int i = 0; i < taskInstBean.getExaminInstList().size(); i++) {
					WfRExamineinst examineinst = (WfRExamineinst) taskInstBean
							.getExaminInstList().get(i);
					if (examineinst.getEntityId().equals(examineInstId)) {
						examineinst.setState(WFConstant.WF_EXAMINEINST_STATE_BACK);
						examineinst.setReason(examineInfo);
					} else {
						examineinst.setState(WFConstant.WF_EXAMINEINST_STATE_CLOSE);
					}
					
					examineinst.setExamineEndDate(dateUtil.GetDateTime());
					this.getExamineinstDAO().updateExamineinst(examineinst);
				}
			}

		}

		// 得到上级审批实例，实现重新审批
		// String
		// parentNodeId=procInstEntity.getProcDefine().getParentNode(nodeId);
		// System.out.println("上级节点ID："+parentNodeId);
		List parentNodes = procInstEntity.getProcDefine()
				.getParentNodes(nodeId);

		System.out.println("上级节点size：" + parentNodes.size());
		if (parentNodes != null) {
			for (int k = 0; k < parentNodes.size(); k++) {
				String parentNodeId = (String) parentNodes.get(k);
				// 得到上级节点下的所有TaskInst
				List parentTaskList = this.getTaskInstDAO()
						.queryTaskExamineInstList(procinstId, parentNodeId);
				if (parentTaskList != null) {
					Map taskBeanMap = this.getTaskInstByList(parentTaskList);
					Iterator it = taskBeanMap.entrySet().iterator();
					while (it.hasNext()) {
						Map.Entry entry = (Map.Entry) it.next();
						String key = (String) entry.getKey();
						TaskInstBean taskInstBean = (TaskInstBean) entry
								.getValue();
						taskInstBean.getWfRTaskinst().setState(
								WFConstant.WF_EXAMINEINST_STATE_START);
						this.getTaskInstDAO().updateTaskInst(
								taskInstBean.getWfRTaskinst());
						for (int i = 0; i < taskInstBean.getExaminInstList()
								.size(); i++) {
							WfRExamineinst examineinst = (WfRExamineinst) taskInstBean
									.getExaminInstList().get(i);
							if (examineinst.getState().equals(
									WFConstant.WF_EXAMINEINST_STATE_PASS)) {
								examineinst
										.setState(WFConstant.WF_EXAMINEINST_STATE_START);
								this.getExamineinstDAO().updateExamineinst(
										examineinst);
							}

						}
					}

				}
				// 设置TOKEN指向
				procInstEntity.getRootToken().getWfRTonen().setNodeId(
						parentNodeId);
				this.getTokenInstDAO().updateTokenInst(
						procInstEntity.getRootToken().getWfRTonen());
			}
		}
	}

	/**
	 * 
	 * @param taskList
	 * @return
	 */
	private Map getTaskInstByList(List taskList) {
		List reList = new ArrayList();
		Map assortMap = new HashMap();

		Iterator iterator1 = taskList.iterator();
		while (iterator1.hasNext()) {
			Object[] o = (Object[]) iterator1.next();
			WfRTaskinst wfRTaskinst = (WfRTaskinst) o[0];

			String key = wfRTaskinst.getEntityId();
			if (assortMap.get(key) != null) {
				TaskInstBean taskInstBean = (TaskInstBean) assortMap.get(key);
				WfRExamineinst wfRExamineinst = (WfRExamineinst) o[1];
				taskInstBean.addexaminInst(wfRExamineinst);
			} else {
				TaskInstBean taskInstBean = new TaskInstBean();
				WfRExamineinst wfRExamineinst = (WfRExamineinst) o[1];
				taskInstBean.setWfRTaskinst(wfRTaskinst);
				taskInstBean.addexaminInst(wfRExamineinst);
				assortMap.put(key, taskInstBean);
			}

		}
		return assortMap;
	}

	/**
	 * 查询流程实例中每个节点的运行状态
	 * 
	 * @param procInstEntity
	 * @return
	 */
	public Map getProcInstNodeState(ProcInstEntity procInstEntity) {
		Map nodeStateMap = new HashMap();
		List nodes = procInstEntity.getProcDefine().getNodes();
		String procinstId = procInstEntity.getWfRProcinst().getEntityId();
		if (nodes != null) {
			for (int i = 0; i < nodes.size(); i++) {
				AbstractNodeEntity node = (AbstractNodeEntity) nodes.get(i);
				String isComplete = this.getTaskInstDAO().queryNodeIsComplete(
						procinstId, node.getWfDNode().getEntityId());
				nodeStateMap.put(node.getWfDNode().getEntityId(), isComplete);

			}

		}

		return nodeStateMap;
	}

	/**
	 * 删除流程实例信息
	 * 
	 * @param procInstId
	 */
	public void deleteProcInst(String procinstId) {
		WfRProcinst wfRProcinst = this.getProcInstDAO().queryProcInstByID(
				procinstId);
		this.getProcInstDAO().deleteProcInst(wfRProcinst);
		this.getExamineinstDAO().deleteExamineinstByProcInstId(procinstId);
		this.getTaskInstDAO().deleteTaskInstByProcInstId(procinstId);
		this.getTokenInstDAO().deleteTokenInstByProcInstId(procinstId);
		this.getVariableinstDAO().deleteVariableByProcInstId(procinstId);
	}

	/**
	 * 停止流程实例
	 * 
	 * @param procinstId
	 */
	public void updateProcInstStopById(String procinstId) {
		WfRProcinst wfRProcinst = this.getProcInstDAO().queryProcInstByID(
				procinstId);
		wfRProcinst.setState(WFConstant.WF_PROCINST_STATE_NOPASS);
		this.getProcInstDAO().updateProcInst(wfRProcinst);
		this.getExamineinstDAO().updateBatchExamineInst(procinstId);
		this.getTaskInstDAO().updateBatchTaskInstById(procinstId);
		this.getTokenInstDAO().updateBatchTokenInstById(procinstId);

		//this.getVariableinstDAO().deleteVariableByProcInstId(procinstId);
	}
	/**
	 * 流程实例跳到任意节点
	 * 
	 * @param exanimrInstId
	 * @throws Exception
	 */
	public void addMoveNode(ProcInstEntity procInstEntity,
		String examineInstId, String examineInfo,AbstractNodeEntity moveNode,
		ProcessDefineEntity procDefine,String taskInstId,WfRTonen wfToken,UserToken userToken) {
		
		String procinstId = procInstEntity.getWfRProcinst().getEntityId();
       
		List  taskInstList=null;

		WfRExamineinst cruExamineInst=this.getExamineinstDAO().queryExamineinstByID(examineInstId);
		cruExamineInst.setExamineInfo(examineInfo);
		cruExamineInst.setExamineEndDate(dateUtil.GetDateTime());
		this.getExamineinstDAO().updateExamineinst(cruExamineInst);
		 //关闭同一节点下的所有taskInst和examinst-状态置为回退
		 //判断当前节点是否在主token或者子token上节点
		 //如果在主token上的节点则正常关闭该级节点的task和examine（join中需要关闭子tonken节点状态）
		  if(this.isRootToken(wfToken)){
			  System.out.println("当前节点处于主token之上");
			  this.addCloseAllTakInstExaminstNEW(WFConstant.WF_TOKEN_STATE_BACK,cruExamineInst.getTaskinstId(),procinstId, wfToken, examineInstId,true);
			  
		  }else{
	     //如果在子token上则需要把本节点的task和examie设置成回退，把同级的子token节点的task和examine都设置成挂起，并把
		 //该级子token状态设置成挂起
			  System.out.println("当前节点处于子token之上");
			  //关闭本级ExamineInst
//			  this.addCloseOtherExamineInstByTaskInst(taskInstId, cruExamineInst, examineInfo, userToken.getUserName());
			  this.addCloseAllTakInstExaminstNEW(WFConstant.WF_TOKEN_STATE_BACK,cruExamineInst.getTaskinstId(),procinstId, wfToken, examineInstId,true);
			  //同级的子token节点的task和examine都设置成挂起，并把
			  //该级子token状态设置成挂起
			  this.addDownNodeByToken(wfToken, procinstId);
		  }
		    
		 //如果移动到主token节点上则正常开启该节点的task和examine，并且设置主token指向该节点-isRootTokenByNode有待完善
		  if(this.isRootTokenByNode(moveNode, procinstId)){
			 
				 procInstEntity.getRootToken().getWfRTonen().setNodeId(moveNode.getNodeID());
				  procInstEntity.getRootToken().getWfRTonen().setState(WFConstant.WF_TOKEN_STATE_START);
				  this.getTokenInstDAO().updateTokenInst(procInstEntity.getRootToken().getWfRTonen());
				  taskInstList=procInstEntity.getTaskInstEntityByNode(moveNode,taskInstId);
				  this.saveStartNextTaskInst(taskInstList, procInstEntity.getWfRProcinst(),wfToken); 
			 
			  
		  }else{
			  /*如果移动到开始节点将令牌指向开始节点并设置为停止将流程实例设置为等待重新启动*/
			  if(moveNode.getWfDNode().getNodeType().equals(WFConstant.WF_PROCDEFINE_NODE_TYPE_START)){
				 procInstEntity.getRootToken().getWfRTonen().setNodeId(moveNode.getNodeID());
				 procInstEntity.getRootToken().getWfRTonen().setState(WFConstant.WF_TOKEN_STATE_STOP);
				 this.getTokenInstDAO().updateTokenInst(procInstEntity.getRootToken().getWfRTonen());
				 procInstEntity.getWfRProcinst().setState(WFConstant.WF_PROCINST_STATE_WAIT);
				 procInstDAO.updateProcInst( procInstEntity.getWfRProcinst());
			 }
			  /*else if(moveNode.getWfDNode().getNodeType().equals(WFConstant.WF_PROCDEFINE_NODE_TYPE_FORK_NODE)){
				 moveNode.startNodeInst();
			 }*/
			  else{
				//如果移动到子token节点上，开启本级子token（task和examine），并把同级子tonken设置为等待
//					List subTokentaskInsts=this.getTaskInstDAO().queryTaskInstsByNode(procinstId, moveNode.getNodeID());
//					this.saveStartNextTaskInst(subTokentaskInsts, procInstEntity.getWfRProcinst(),wfToken);
			  WfRTonen subToken= this.addSetSubTokenWait(moveNode, procinstId);
			  taskInstList=procInstEntity.getTaskInstEntityByNode(moveNode,taskInstId);
			 // this.getTokenInstDAO();
			  this.saveStartNextTaskInst(taskInstList, procInstEntity.getWfRProcinst(),subToken);
			 }
		  }
		  
		 //关闭当前节点的takinst和examineInst 
		// 改变子token状态
		
		
		
	//	this.saveCloseAllTakInstExaminst(procinstId, wfToken.getNodeId(), examineInstId,true);
		//判断节点是否在子token中
		
		  
		  /*
		for(int i=0;i<moveNodes.size();i++){
			AbstractNodeEntity node=(AbstractNodeEntity)moveNodes.get(i);
			System.out.println("节点类型是...................."+node.getNodeType());
			wfToken.setNodeId(node.getNodeID());
			//改变tonkenInst指向节点位置
			this.getTokenInstDAO().updateTokenInst(wfToken);
		    //数据同步到数据库
		     taskInstList=procInstEntity.getTaskInstEntityByNode(node,taskInstId);
			this.saveStartNextTaskInst(taskInstList, procInstEntity.getWfRProcinst(),wfToken);
		}
		*/
	}
	/*
	 * 设置同级子token状态为等待,返回移动节点的子token
	 */
	private WfRTonen addSetSubTokenWait(AbstractNodeEntity moveNode,String procInistId){
		WfRTonen token=null;
		List taskInsts=this.getTaskInstDAO().queryTaskInstsByNode(procInistId, moveNode.getNodeID());
		if(taskInsts!=null&&taskInsts.size()>0){
			WfRTaskinst taskInst=(WfRTaskinst)taskInsts.get(0);
			token=this.getTokenInstDAO().queryTokenInstByID(taskInst.getToken());
			token.setNodeId(moveNode.getNodeID());
			token.setState(WFConstant.WF_TOKEN_STATE_START);
			this.getTokenInstDAO().updateTokenInst(token);
			List subTokens=this.getTokenInstDAO().querySubTokensNoId(token);
			for(int i=0;i<subTokens.size();i++){
				WfRTonen subToken=(WfRTonen)subTokens.get(i);
				subToken.setState(WFConstant.WF_TOKEN_STATE_WAIT);
				this.getTokenInstDAO().updateTokenInst(subToken);
			}
			
		}
		return token;
	}
	/**
	 * 挂起其他子token下的节点实例
	 */
	private void addDownNodeByToken(WfRTonen wfToken,String procinstId){
	  List subTokens=this.getTokenInstDAO().querySubTokensNoId(wfToken);
	  if(subTokens!=null){
		  for(int i=0;i<subTokens.size();i++){
			  WfRTonen subToken=(WfRTonen)subTokens.get(i);
			  if(subToken.getState().equals(WFConstant.WF_TOKEN_STATE_START)){
				  subToken.setState(WFConstant.WF_TOKEN_STATE_DOWN);
			  }else if(subToken.getState().equals(WFConstant.WF_TOKEN_STATE_WAIT)){
				  subToken.setState(WFConstant.WF_TOKEN_STATE_DOWNWAIT);
			  }
			  List taskList = this.getTaskInstDAO().queryTaskExamineInstList(
						procinstId, subToken.getNodeId());
			  if (taskList != null) {
					Map taskBeanMap = this.getTaskInstByList(taskList);
					Iterator it = taskBeanMap.entrySet().iterator();
					while (it.hasNext()) {
						Map.Entry entry = (Map.Entry) it.next();
						String key = (String) entry.getKey();
						TaskInstBean taskInstBean = (TaskInstBean) entry.getValue();
						if(taskInstBean.getWfRTaskinst().getState().equals(WFConstant.WF_TASKINST_OPEN_START)){
							taskInstBean.getWfRTaskinst().setState(
									WFConstant.WF_TASKINST_OPEN_DOWN);
						}
							
						this.getTaskInstDAO().updateTaskInst(
								taskInstBean.getWfRTaskinst());
						for (int j = 0; j < taskInstBean.getExaminInstList().size(); j++) {
							WfRExamineinst examineinst = (WfRExamineinst) taskInstBean
									.getExaminInstList().get(j);
							   if(examineinst.getState().equals(WFConstant.WF_EXAMINEINST_STATE_START)){
								   examineinst.setState(WFConstant.WF_EXAMINEINST_STATE_DOWM); 
							   }
								
							this.getExamineinstDAO().updateExamineinst(examineinst);
						}
					}

				}
			   this.getTokenInstDAO().updateTokenInst(subToken);
		  }
		  
		 
	  }
	}
	  /**
     * 关闭同一节点下的所有taskInst和examintInst
     * @param procinstId
     * @param nodeId
     * @param examineInstId
     */
	public void addCloseAllTakInstExaminstNEW(String tokenState,String taskInstId,String procinstId,WfRTonen wfToken,String examineInstId,boolean isBackFlag ){
		List taskList = this.getTaskInstDAO().queryTaskExamineInstList(
				procinstId, wfToken.getNodeId());
		wfToken.setState(tokenState);
		this.getTokenInstDAO().updateTokenInst(wfToken);
		// 关闭本级所有TaskInst和examintInst
		if (taskList != null) {
			Map taskBeanMap = this.getTaskInstByList(taskList);
			Iterator it = taskBeanMap.entrySet().iterator();
			while (it.hasNext()) {
				Map.Entry entry = (Map.Entry) it.next();
				String key = (String) entry.getKey();
				TaskInstBean taskInstBean = (TaskInstBean) entry.getValue();
				if(taskInstBean.getWfRTaskinst().getEntityId().equals(taskInstId)&&isBackFlag){
					taskInstBean.getWfRTaskinst().setState(
							WFConstant.WF_EXAMINEINST_STATE_BACK);
					
				}else{
					taskInstBean.getWfRTaskinst().setState(
							WFConstant.WF_EXAMINEINST_STATE_CLOSE);
				}
				
				this.getTaskInstDAO().updateTaskInst(
						taskInstBean.getWfRTaskinst());
				for (int i = 0; i < taskInstBean.getExaminInstList().size(); i++) {
					WfRExamineinst examineinst = (WfRExamineinst) taskInstBean
							.getExaminInstList().get(i);
					if (examineinst.getEntityId().equals(examineInstId)) {
						examineinst
								.setState(WFConstant.WF_EXAMINEINST_STATE_BACK);
					} else {
						examineinst
								.setState(WFConstant.WF_EXAMINEINST_STATE_CLOSE);
					}
					this.getExamineinstDAO().updateExamineinst(examineinst);
				}
			}

		}
	}
	// 设置本级examineInst为回退，挂起同一TASKINST下的其他用户审批实例--临时方法
	private void addCloseOtherExamineInstByTaskInst(String taskInstID,
			WfRExamineinst cruExamineInst,String examineInfo,String userName) {
		cruExamineInst.setExamineInfo(examineInfo);
		cruExamineInst.setExamineUserName(userName);
		cruExamineInst.setExamineEndDate(dateUtil.GetDateTime());
		cruExamineInst.setState(WFConstant.WF_EXAMINEINST_STATE_BACK);
		this.getExamineinstDAO().updateExamineinst(cruExamineInst);
		
		List otherExamineInstList = this.getExamineinstDAO()
				.queryOtherExamineInstList(taskInstID, cruExamineInst.getEntityId());
		if (otherExamineInstList != null) {
			for (int j = 0; j < otherExamineInstList.size(); j++) {
				WfRExamineinst examineinst = (WfRExamineinst) otherExamineInstList
						.get(j);
				examineinst.setState(WFConstant.WF_EXAMINEINST_STATE_CLOSE);
				this.getExamineinstDAO().updateExamineinst(examineinst);

			}

		}
		WfRTaskinst cruTaskInst=this.getTaskInstDAO().queryWfRTaskinstByID(taskInstID);
		cruTaskInst.setState(WFConstant.WF_TASKINST_OPEN_BACK);
		this.getTaskInstDAO().updateTaskInst(cruTaskInst);
	}
	/**
	 * 判断token是否为主token
	 * @return
	 */
	public boolean isRootToken(WfRTonen wfRTonen){
		boolean isRoot_=false;
		if(wfRTonen.getParentTokenid()==null||wfRTonen.getParentTokenid().equals("")){
			isRoot_=true;
		}
		return isRoot_;
	}
	/**
	 * 判断节点是否在主token上
	 * @return
	 */
	public boolean isRootTokenByNode(AbstractNodeEntity moveNode,String procInistId){
		boolean isRoot_=false;
		List taskInsts=this.getTaskInstDAO().queryTaskInstsByNode(procInistId, moveNode.getNodeID());
		if(taskInsts!=null&&taskInsts.size()>0){
			WfRTaskinst taskInst=(WfRTaskinst)taskInsts.get(0);
			WfRTonen token=this.getTokenInstDAO().queryTokenInstByID(taskInst.getToken());
			isRoot_=this.isRootToken(token);
		}
		return isRoot_;
	}
	/**
	 * 查询当前节点下的同级子token列表
	 * @return
	 */
	public List queryCruSubToken(String pTokenId){
		return this.getTokenInstDAO().querySubTokens(pTokenId);
	}
	/**
	 * 根据状态改变同级token状态
	 * @param pTokenId
	 */
	public void addCloseSubTokens(String pTokenId,String state){
		List subTokens=this.queryCruSubToken(pTokenId);
		if(subTokens!=null){
			for(int i=0;i<subTokens.size();i++){
				WfRTonen wfRTonen=(WfRTonen)subTokens.get(i);
				wfRTonen.setState(state);
				this.getTokenInstDAO().updateTokenInst(wfRTonen);
			}
			
		}
	}
	/**
	 * 流程实例跳到任意节点
	 * 
	 * @param exanimrInstId
	 * @throws Exception
	 */
	public void addMoveProcInstBK(ProcInstEntity procInstEntity,
		String examineInstId, String examineInfo,List moveNodes,
		ProcessDefineEntity procDefine,String taskInstId,WfRTonen wfToken,UserToken userToken) {
		
		String procinstId = procInstEntity.getWfRProcinst().getEntityId();
//		String nodeId = procInstEntity.getRootToken().getWfRTonen().getNodeId();
       
		List  taskInstList=null;
/*		
		AbstractNodeEntity moveNode=procDefine.getNodeByNodeID(moveNodeId);
		 得到跳转的节点信息
		if (moveNode.getWfDNode().getNodeType().equals(
				WFConstant.WF_PROCDEFINE_NODE_TYPE_PEOPLES_NODE)) {
			  taskInstList=procInstEntity.getTaskInstEntityByNode(moveNode,taskInstId);
			
		}
		else {
			 moveNode = procInstEntity.getProcDefine().getNextApplyNode(moveNode.getWfDNode()
					.getEntityId());
			 taskInstList=procInstEntity.getTaskInstEntityByNode(moveNode,taskInstId);
		}
		*/
		
		WfRExamineinst cruExamineInst=this.getExamineinstDAO().queryExamineinstByID(examineInstId);
		cruExamineInst.setExamineInfo(examineInfo);
		cruExamineInst.setExamineUserName(userToken.getUserName());
		cruExamineInst.setExamineEndDate(dateUtil.GetDateTime());
		this.getExamineinstDAO().updateExamineinst(cruExamineInst);
		
		 //关闭同一节点下的所有taskInst和examinst
		this.saveCloseAllTakInstExaminst(procinstId, wfToken.getNodeId(), examineInstId,true);
		//判断
		for(int i=0;i<moveNodes.size();i++){
			AbstractNodeEntity node=(AbstractNodeEntity)moveNodes.get(i);
			wfToken.setNodeId(node.getNodeID());
			//改变tonkenInst指向节点位置
			this.getTokenInstDAO().updateTokenInst(wfToken);
		    //数据同步到数据库
		     taskInstList=procInstEntity.getTaskInstEntityByNode(node,taskInstId);
			this.saveStartNextTaskInst(taskInstList, procInstEntity.getWfRProcinst(),wfToken);
		}
		
	}
	/**
	 * 查询流程实例的审批节点状态
	 * @param procInstId
	 * @return
	 */
	public List queryProcInstApply(String procInstId) {
		List procInstStates = new ArrayList();
     
		WfRProcinst procinst=this.getProcInstDAO().queryProcInstByID(procInstId);
		String cacheKey=procinst.getProcEName()+"_"+procinst.getProcVersion();
		ProcessDefineEntity procDefine=MemberCache.getInstance().retrieveProcDefine(cacheKey);
       
		procInstStates=this.getProcInstStateList(procInstId, procDefine);
        
		return procInstStates;
	}
	private List getProcInstStateList(String procInstId,
			ProcessDefineEntity procDefine) {
		List list = new ArrayList();
		String ptsakId = "";
		String taskId = "";
		boolean flag = false;
		Map task_ = this.queryTaskInstByInstId(procInstId, ptsakId, procDefine);
		if (task_ != null) {
			list.add(task_);
			flag = true;
			while (flag)
				if (task_ != null) {
					if (task_.get("taskId") != null) {
						taskId = task_.get("taskId").toString();
						
						if(taskId.equals("")){
							flag = false;
							break;
						}else{
						 task_ = this.queryTaskInstByInstId(procInstId, taskId,
								procDefine);
						if(task_!=null){
						 
						  list.add(task_);
						}
						
						}
					}

				}else {
					flag = false;
				}
		}
		return list;
	}
	
	private Map queryTaskInstByInstId(String procInstId,String ptsakId,ProcessDefineEntity procDefine){
		List tasks=new ArrayList();
		tasks=this.getTaskInstDAO().queryProcTaskInstByPTask(procInstId,ptsakId);
		
		Map nodeMap=null;
		String taskids="";
		List examines=new ArrayList();
		if(tasks!=null&&tasks.size()>0){
			nodeMap=new HashMap();
			for(int i=0;i<tasks.size();i++){
				Map task_=(Map)tasks.get(i);
				String nodeId=task_.get("nodeId").toString();
				String taskId=task_.get("entityId").toString();
				taskids=taskids+taskId+",";
				if(i==0){
		            String nodeName=procDefine.getNodeByNodeID(nodeId).getWfDNode().getNodeName();
		            nodeMap.put("nodeName", nodeName);
		            examines=this.queryTaskExamineInfo(taskId);
		           
				}else{
					List examines_=this.queryTaskExamineInfo(taskId);
					if(examines_!=null){
						for(int j=0;j<examines_.size();j++){
							Map examineMap=(Map)examines_.get(j);
							examines.add(examineMap);
						}
					}
				}
			}
			if(taskids.length()>0){
				taskids=taskids.substring(0, taskids.length()-1);
			}
			nodeMap.put("taskId", taskids);
		    nodeMap.put("examineInsts", examines);
		}
		
		return nodeMap;
	}
	private List queryTaskExamineInfo(String taskId ){
        return this.getExamineinstDAO().queryExaminsListByTaskId(taskId);
	}
	/**
	 * 查询当前用户参加审批的流程实例
	 * @param userId
	 * @param roleId
	 * @param state
	 * @return
	 */
	public List queryJoinProcInstByUser(String userId,String roleId,String state,String procId,String procType) {
		List list=new ArrayList();
		if(state==null){
			state="";
		}
		if(procId==null){
			procId="";
		}
		if(procType==null){
			procType="";
		}
		List procInsts=this.getExamineinstDAO().queryProcInstByUser(userId, roleId, state,procId,procType);
		return this.CreateVarInProcInst(procInsts);
	}
	
	/**
	 * 
	* @Title: queryJoinProcInstByUserForPage
	* @Description: 流程分页 吴海军  2013-8-14
	* @param @param userId
	* @param @param roleId
	* @param @param state
	* @param @param procId
	* @param @param procType
	* @param @param page
	* @param @return    设定文件
	* @return PageModel    返回类型
	* @throws
	 */
	public PageModel queryJoinProcInstByUserForPage(String userId,String roleId,String state,String procId,String procType,PageModel page) {
		List list=new ArrayList();
		if(state==null){
			state="";
		}
		if(procId==null){
			procId="";
		}
		if(procType==null){
			procType="";
		}
		page =this.getExamineinstDAO().queryProcInstByUserForPage(userId, roleId, state,procId,procType,page);
		List data =this.CreateVarInProcInst(page.getData());
		page.setData(data);
		
		return page;
	}
	
	public List queryJoinProcInstByUserState(String userId,String roleId,String state,String examineinstState,String procId,String procType) {
		List list=new ArrayList();
		if(state==null){
			state="";
		}
		if(procId==null){
			procId="";
		}
		if(procType==null){
			procType="";
		}
		List procInsts=this.getExamineinstDAO().queryProcInstByUserState(userId, roleId, state,examineinstState,procId,procType);
		return this.CreateVarInProcInst(procInsts);
	}
	/**
	 * 处理分支节点信息
	 * @param nextNodes
	 * @param cruToken
	 * @param args
	 * @param procInstEntity
	 */
	public void addForkNodeExcute(List nextNodes,WfRTonen cruToken,Map args,ProcInstEntity procInstEntity) {
		int nodesSize=0;
		//修改上级Token 状态
		cruToken.setState(WFConstant.WF_TOKEN_STATE_WAIT);
		this.getTokenInstDAO().updateTokenInst(cruToken);
		//+++++++++
		Map subTokenMap=this.updateSubTokenMap(cruToken);
        //处理下级节点信息
		if (nextNodes != null && nextNodes.size() > 1) {
			nodesSize = nextNodes.size();
			for (int i = 0; i < nodesSize; i++) {
				AbstractNodeEntity nextNode = (AbstractNodeEntity) nextNodes
						.get(i);
				
				//判断原有移动token属于回退或者挂起，新建回退task，重启原有task和examine
                WfRTonen token=null;
                if(subTokenMap.size()>0){
                	if(subTokenMap.get(nextNode.getNodeID())!=null){
                   	   token=(WfRTonen)subTokenMap.get(nextNode.getNodeID());
                   	   System.out.println("tokenId..............."+token.getEntityId());
                   	 if(token.getState().equals(WFConstant.WF_TOKEN_STATE_DOWN)){
                   		this.updateMoveSubTokenInst(token);
                   	 }
//                   	 if(token.getState().equals(WFConstant.WF_TOKEN_STATE_DOWNWAIT)){
//                   		 token.setState(WFConstant.WF_TOKEN_STATE_WAIT);
//                   		 this.getTokenInstDAO().updateTokenInst(token);
//                   	 }
                   	 if(token.getState().equals(WFConstant.WF_TOKEN_STATE_BACK)){
                   		token.setState(WFConstant.WF_TOKEN_STATE_STOP);
                   		this.getTokenInstDAO().updateTokenInst(token);
                   		WfRTonen subToken = new WfRTonen();
        				subToken.setParentTokenid(cruToken.getEntityId());
        				subToken.setProcinstId(cruToken.getProcinstId());
        				subToken.setStartNodeid(nextNode.getNodeID());
        				subToken.setState(WFConstant.WF_TOKEN_STATE_START);
        				subToken.setNodeId(nextNode.getNodeID());
                        this.getTokenInstDAO().saveTokenInst(subToken);
                    	args.put("cruTonen", subToken);
        				args.put("nextNodeID", nextNode.getNodeID());
        				nextNode.init(args);
        				nextNode.setProcInstEntity(procInstEntity);
        				nextNode.startNodeInst(); 
                   	  }
                	}
                }else{
                	// 设置subtoken信息
    				WfRTonen subToken = new WfRTonen();
    				subToken.setParentTokenid(cruToken.getEntityId());
    				subToken.setProcinstId(cruToken.getProcinstId());
    				subToken.setStartNodeid(nextNode.getNodeID());
    				subToken.setState(WFConstant.WF_TOKEN_STATE_START);
    				subToken.setNodeId(nextNode.getNodeID());
                    this.getTokenInstDAO().saveTokenInst(subToken);
                	args.put("cruTonen", subToken);
    				args.put("nextNodeID", nextNode.getNodeID());
    				nextNode.init(args);
    				nextNode.setProcInstEntity(procInstEntity);
    				nextNode.startNodeInst();
                }
			}

		}
	
	
	}
	/**
	 * 重启该节点的所有taskInst和examineInst
	 * @param subToken
	 */
   public void updateMoveSubTokenInst(WfRTonen subToken){
	   subToken.setState(WFConstant.WF_TOKEN_STATE_START);
	   this.getTokenInstDAO().updateTokenInst(subToken);
	  List taskInsts=this.getTaskInstDAO().queryTaskInstByToken(subToken);
	   if(taskInsts!=null){
		  for(int i=0;i<taskInsts.size();i++){
			  WfRTaskinst taskInst=(WfRTaskinst)taskInsts.get(i);
			  if(taskInst.getState().equals(WFConstant.WF_TASKINST_OPEN_DOWN)){
				  taskInst.setState(WFConstant.WF_TASKINST_OPEN_START);
			  }
			  this.getTaskInstDAO().updateTaskInst(taskInst);
			  List examineInsts= this.getExamineinstDAO().queryExaminesByTsakIdHQL(taskInst.getEntityId());
			  if(examineInsts!=null){
				  for(int j=0;j<examineInsts.size();j++){
					  WfRExamineinst examineInse=(WfRExamineinst)examineInsts.get(j);
					  if(examineInse.getState().equals(WFConstant.WF_EXAMINEINST_STATE_DOWM)){
						  examineInse.setState(WFConstant.WF_EXAMINEINST_STATE_START);
					  }
					  this.getExamineinstDAO().updateExamineinst(examineInse);
				  }
			  }
			  
		  }
	  }
	  
	  
	}
	/**
	 * 处理流程因为回退返回到汇聚节点,如果是
	 * @return
	 */
	private Map updateSubTokenMap(WfRTonen cruToken){
		boolean is_=false;
		Map tokenMap=new HashMap();
		if(cruToken!=null){
			List subTokens=this.getTokenInstDAO().querySubTokensByMove(cruToken.getEntityId());
			if(subTokens!=null){
				for(int i=0;i<subTokens.size();i++){
					WfRTonen subToken=(WfRTonen)subTokens.get(i);
					if(subToken.getState().equals(WFConstant.WF_TOKEN_STATE_DOWNWAIT)){
						subToken.setState(WFConstant.WF_TOKEN_STATE_WAIT);
						this.getTokenInstDAO().updateTokenInst(subToken);
					}
					tokenMap.put(subToken.getNodeId(), subToken) ;
				}
			}
				
		}
		return tokenMap;
	}
	/**
	 * 处理汇聚节点
	 * @param ptoken
	 * @param args
	 * @param nextNodeId
	 * @param procInstEntity
	 */
	public void addJoinNodeExcute(WfRTonen ptoken,Map args,String nextNodeId,ProcInstEntity procInstEntity) {
		ptoken.setState(WFConstant.WF_TOKEN_STATE_START);
		this.getTokenInstDAO().updateTokenInst(ptoken);
		args.put("cruTonen", ptoken);
		args.put("nextNodeID", nextNodeId);
		AbstractNodeEntity nextNode = procInstEntity.getProcDefine()
				.getNodeByNodeID(nextNodeId, args);
		nextNode.setProcInstEntity(procInstEntity);
		nextNode.startNodeInst();
	}
	
	/**
	 * 把流程变量添加到每个待审批实例中
	 * @param examineInstList
	 * @return
	 */
	private List CreateVarInProcInst(List procInsts){
		List list=new ArrayList();
		for(int j=0;j<procInsts.size();j++){
			Map map=(Map)procInsts.get(j);
			List varList=this.getExamineinstDAO().queryProcInstVarByID(map.get("procinstid").toString());
			
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
	
	public boolean isRootTokenByNode(String moveNodeId,String procInistId){
		boolean isRoot_=false;
		List taskInsts=this.getTaskInstDAO().queryTaskInstsByNode(procInistId,moveNodeId);
		if(taskInsts!=null&&taskInsts.size()>0){
			WfRTaskinst taskInst=(WfRTaskinst)taskInsts.get(0);
			WfRTonen token=this.getTokenInstDAO().queryTokenInstByID(taskInst.getToken());
			isRoot_=this.isRootToken(token);
		}
		return isRoot_;
	}
	
	/**
	 * 打开其他子token下的节点实例
	 */
	public void addUpNodeByToken(WfRTonen wfToken,String procinstId){
		  List subTokens=this.getTokenInstDAO().querySubTokensNoId(wfToken);
		  if(subTokens!=null){
			  for(int i=0;i<subTokens.size();i++){
				  WfRTonen subToken=(WfRTonen)subTokens.get(i);
				  if(subToken.getState().equals(WFConstant.WF_TOKEN_STATE_DOWN)){
					  subToken.setState(WFConstant.WF_TOKEN_STATE_START);
				  }else if(subToken.getState().equals(WFConstant.WF_TOKEN_STATE_DOWNWAIT)){
					  subToken.setState(WFConstant.WF_TOKEN_STATE_WAIT);
				  }
				  List taskList = this.getTaskInstDAO().queryUpTaskExamineInstList(
							procinstId, subToken.getNodeId());
				  if (taskList != null) {
						Map taskBeanMap = this.getTaskInstByList(taskList);
						Iterator it = taskBeanMap.entrySet().iterator();
						while (it.hasNext()) {
							Map.Entry entry = (Map.Entry) it.next();
							String key = (String) entry.getKey();
							TaskInstBean taskInstBean = (TaskInstBean) entry.getValue();
							if(taskInstBean.getWfRTaskinst().getState().equals(WFConstant.WF_TASKINST_OPEN_DOWN)){
								taskInstBean.getWfRTaskinst().setState(
										WFConstant.WF_TASKINST_OPEN_START);
							}
								
							this.getTaskInstDAO().updateTaskInst(
									taskInstBean.getWfRTaskinst());
							for (int j = 0; j < taskInstBean.getExaminInstList().size(); j++) {
								WfRExamineinst examineinst = (WfRExamineinst) taskInstBean
										.getExaminInstList().get(j);
								   if(examineinst.getState().equals(WFConstant.WF_EXAMINEINST_STATE_DOWM)){
									   examineinst.setState(WFConstant.WF_EXAMINEINST_STATE_START); 
								   }
									
								this.getExamineinstDAO().updateExamineinst(examineinst);
							}
						}

					}
				   this.getTokenInstDAO().updateTokenInst(subToken);
			  }
			  
			 
		  }
		}
	
	  public void flashProcInst(String procinstId)
	  {
	    WfRProcinst wfRProcinst = getProcInstDAO().queryProcInstByID(procinstId);
	    getProcInstDAO().updateFlashProcInst(wfRProcinst);
	  }
	
	public ProcInstDAO getProcInstDAO() {
		return procInstDAO;
	}

	public void setProcInstDAO(ProcInstDAO procInstDAO) {
		this.procInstDAO = procInstDAO;
	}

	public TokenInstDAO getTokenInstDAO() {
		return tokenInstDAO;
	}

	public void setTokenInstDAO(TokenInstDAO tokenInstDAO) {
		this.tokenInstDAO = tokenInstDAO;
	}

	public TaskInstDAO getTaskInstDAO() {
		return taskInstDAO;
	}

	public void setTaskInstDAO(TaskInstDAO taskInstDAO) {
		this.taskInstDAO = taskInstDAO;
	}

	public ExamineinstDAO getExamineinstDAO() {
		return examineinstDAO;
	}

	public void setExamineinstDAO(ExamineinstDAO examineinstDAO) {
		this.examineinstDAO = examineinstDAO;
	}

	public VariableinstDAO getVariableinstDAO() {
		return variableinstDAO;
	}

	public void setVariableinstDAO(VariableinstDAO variableinstDAO) {
		this.variableinstDAO = variableinstDAO;
	}

	public ProcinstCopyDAO getProcinstCopyDAO() {
		return procinstCopyDAO;
	}

	public void setProcinstCopyDAO(ProcinstCopyDAO procinstCopyDAO) {
		this.procinstCopyDAO = procinstCopyDAO;
	}
	
}
