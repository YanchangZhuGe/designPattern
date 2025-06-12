/**
 * 流程实例服务
 */
package com.cnpc.sais.bpm;

import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.common.UserToken;
import com.cnpc.sais.bpm.cache.MemberCache;
import com.cnpc.sais.bpm.define.entity.process.ProcessDefineEntity;
import com.cnpc.sais.bpm.pojo.WfRVariableinst;
import com.cnpc.sais.bpm.runtime.entity.inst.ProcInstEntity;
import com.cnpc.sais.bpm.service.ProcDefineService;

/** 
 * @author 夏烨  
 * @version 创建时间：2009-11-4 上午09:53:58 
 * 类说明 
 */

public interface IProcInstSrv {
	
	/**
	 * 添加流程模板定义
	 * @param xpdl 流程的xpdl描述  
	 * @param doc  流程图形化描述
	 * @param pdname 流程描述
	 * @return Map 包含流程相关信息
	 */
	/*public Map addProcessDefine(String xpdl,String doc,String pdname);*/
	/**
	 * 添加流程模板定义Flex
	 * @param xml 流程的xpdl描述  
	 * @param pdname 流程描述
	 * @param procEName 流程英文名称
	 * @return Map 包含流程相关信息
	 */
	public Map addProcessDefineFlex(String xml,String pdname,String createUserName,String procEName,String procType)throws Exception;
	public Map addProcessDefineFlex(String xml,String pdname,Map userInfo,String procEName,String procType)throws Exception;
	/**
	 * 修改流程模板定义Flex
	 * @param xml 流程的xpdl描述  
	 * @param pdname 流程描述
	 * @return Map 包含流程相关信息
	 */
	public Map updateProcessDefineFlex(String xml,String pdname,String createUserName,String procId)throws Exception;
	public Map updateProcessDefineFlex(String xml,String pdname,Map userInfo,String procId)throws Exception;
	/**
	 * 添加流程模板定义
	 * @param xpdl 流程的xpdl描述  
	 * @param doc  流程图形化描述
	 * @param pdname 流程描述
	 * @return Map 包含流程相关信息
	 * @param procType 流程模板类型
	 * @return
	 */
	/*public Map addProcessDefine(String xpdl,String doc,String pdname,String procType);*/
	/**
	 * 修改流程模板定义
	 * @param xpdl
	 * @param doc
	 * @param pdname
	 * @return
	 */
	public Map updateProcessDefine(String xpdl,String doc,String pdname);
	/**
	 * 启动流程实例
	 * @param procEName 流程英文标识
	 * @param procVersion 流程版本号
	 * @param vars      流程实例变量
	 * @param userId    发起流程人员Id
	 * @param userName  发起流程人员名称
	 * @param ccUsers   抄送人员Id
	 * @return
	 */
	public ProcInstEntity startProc(String procEName,String procVersion,List<WfRVariableinst> vars,String userId,String userName,String ccUsers,String orgID);
	
	
	public void reStartProc(String procInstId,String movNodeId);
	public String getPeopleNodes(String procInstId);
	/**
	 * 得到流程的图形化显示XML-FLEX版本
	 * @param procDefineId
	 * @return
	 */
	
	public Map getProcFlexView(String procEName,String procVersion );
	/**
	 * 缓存中加载流程信息
	 */
	public void loadProcDefines();
	/**
	 * 根据当前用户和模板类型得到待审批列表
	 * 
	 * @param userId
	 *            用户ID
	 * @param procType
	 *            流程类型 examineinstId 审批实例Id 一般设为空字符串即可 examineRoleId 角色Id
	 * @return
	 */
	public List getExamineInstListByUserID(String userId, String procType,
			String examineinstId, String examineRoleId,String procId);
	
	/**
	 * 点击审批时得到审批实例的所有信息和所有下级节点
	 * @param procinstId     流程实例Id
	 * @param examineinstId  审批实例Id
	 * @param procType       流程类型，一般为空字符串
	 * @param userId         当前用户Id
	 * @return
	 */
	public Map getExamineInfo(String procinstId, String examineinstId,
			String procType, String userId);
	
	/**
	 * 审批节点
	 * 
	 * @param nextNodeId
	 *            下级节点Id
	 * @param examineInfo
	 *            本级节点审批信息
	 * @param isPass
	 *            是否通过
	 * @param examineinstId
	 *            审批实例Id
	 * @param procinstId
	 *            流程实例Id
	 * @param examineUserName
	 *            审批用户名称
	 * @param taskInstId
	 *            审批taskInstId
	 * @return
	 */
	public Map examineNode(String nextNodeId, String examineInfo,
			String isPass, String examineinstId, String procinstId,
			String examineUserName, String taskInstId,String userId,String busiInfo);
	
	/**
	 * 委托用户审批实例
	 * @param examineinstId 审批实例节点Id
	 * @param userIds 多个委托用户Id用逗号隔开 
	 */
	public void consignExamInst(String examineinstId,String userIds);
	
	/**
	 * 回退流程实例
	 * @param examineinstId
	 * @param examineInfo 回退原因
	 * @param procinstId
	 */
	public void backProcInst(String examineinstId,String examineInfo,String procinstId);
	
	/**
	 * 根据流程模板ID得到流程模板实例
	 * @param procDefineId 流程模板Id
	 */
	public void getprocDefineById(String procEName,String procVersion);
	/**
	 * 得到流程模板实例用于展示--生成显示xml
	 * @param procDefineId
	 * @return
	 */
	public Map getProcessViewById(String procDefineId);
	
	/**
	 * 根据当前用户启动的流程实例
	 * @param userId 当前用户Id
	 * @param procType 流程类型
	 * @return
	 */
	public List getStartProcInstByCurUser(String userId,String procType);
	
	/**
	 * 图形化显示流程实例的运行情况
	 * @param procinstId
	 * @return
	 */
	public String getProcInstView(String procinstId);
	/**
	 * 根据流程类型得到相应的流程模板
	 * @param procType
	 * @return
	 */
	public List getProcProcDefinesByType(String procType);
	/**
	 * 根据节点ID和流程实例ID查询当前节点的审批信息
	 * @param nodeId
	 * @param procInstId
	 * @return
	 */
	public List queryExamineInstByNodeId(String nodeId,String procInstId);
	/**
	 * 查询所有流程模板下的运行的流程实例
	 * @return
	 */
	public List queryInstSumByProcDefine();

	/**
	 * 	得到某个模板下某种状态的实例
	 * @param procId
	 * @param state
	 * @return
	 */
	public List queryProcInstsByProcId(String procId,String state);
	/**
	 * 查询流程实例审批信息
	 * @param procInstId
	 * @return
	 */
	public List queryProcInstExamineInfo(String procInstId);
	/**
	 * 逻辑删除流程模板
	 * @param procDeineId
	 */
	public void delProcDefine(String procDeineId);
	/**
	 * 修改流程模板状态
	 * @param procDeineId
	 */
	public void stopProcDefine(String procDeineId);
	/**
	 * 开启流程模板
	 * @param procDeineId
	 */
	public void startProcDefine(String procDeineId);
	/**
	 * 删除流程实例相关信息
	 * @param procInstId
	 */
	public void delProcInst(String procInstId);
   /**
    * 得到流程管理列表
    * @param procType
    * @return
    */
	public String queryProcManagerList(String procType);
	/**
	 * 根据Id停止流程实例
	 * @param procInstId
	 * @return
	 */
	public void stopProcInst(String procInstId);
	/**
	 * 根据userid查询抄送的流程列表
	 * @param procInstId
	 * @return
	 */
	public List queryPorcInstCCByUserId(String userId);
	/**
	 * 在流程实例中跳转审批节点
	 * @param examineInstId
	 * @param examineInfo
	 * @param moveNodeId
	 * @param procinstId
	 */
	public String moveNodeProcInst(String examineInstId, String examineInfo,
			String moveNodeId,String procinstId,String taskInstId,UserToken userToken);
	/**
	 * 查询节点审批信息
	 * @param procInstId
	 */
	public List qyeryNodeApply(String procInstId);
	
	public List queryBackNode(String nodeId) throws Exception;
	/**
	 * 查询当前用户参加审批的流程实例
	 * @param userId
	 * @param roleId
	 * @param state
	 * @param procId
	 * @param procType
	 * @return
	 */
	public List queryJoinInstByUser(String userId,String roleId,String state,String procId,String procType);
	
	/**
	 * 查询当前用户参加审批的流程实例
	 * @param userId 用户ID
	 * @param roleId 角色
	 * @param state 流程实例状态
	 * @param examineinstState 审批实例状态
	 * @return
	 */
	public List queryJoinInstByUserBystate(String userId,String roleId,String state,String examineinstState,String procId,String procType);
	/**
	 * 流程模板添加到缓存中
	 * @param procId
	 */
	public void addProcDefine2Cache(String procId,ProcDefineService procDefineService)throws Exception;
	/**
	 * 查找业务数据
	 * @param procInstId 流程实例ID
	 * return 业务数据
	 */
	public String getBusinessData(String procInstId);
	public List getBusinessDataList(String ProcInstIds);
	public boolean isLink(String procInstId);
	public List queryCurrExamineinst(String procinstId);
	public List queryCurrExamineinstNode(String procinstId);
	public List getProcDefineByInst(String procinstId);
	public String addProcessDefineFlex(String xml,String procinstId);
	/**
	 * 挂起流程实例
	 * */
	public void procInstHangUp(String procInstId);
	/**
	 * 挂起流程模板
	 * */
	public void procHangUp(String procId);
	/**
	 * 删除模板
	 * */
	public void deleteProc(String procId);

	/**
	 * 恢复流程
	 * */
	
	public void procInsRecovery(String procInstId);
	
	/**
	 * 删除流程
	 * */
	public void procInsDelete(String procInstId);
	/**
	 * 跟据流程 实例ID和审批实例ID获取节点
	 * */
	public String getUrls(String procinstId,String examInstId);
	public void saveFlashProcinst(String procinstId);
	/*public List getUsers(String procEName,String procVersion);*/
}
