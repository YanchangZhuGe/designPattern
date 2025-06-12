/**
 * ����ʵ������
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
 * @author ����  
 * @version ����ʱ�䣺2009-11-4 ����09:53:58 
 * ��˵�� 
 */

public interface IProcInstSrv {
	
	/**
	 * �������ģ�嶨��
	 * @param xpdl ���̵�xpdl����  
	 * @param doc  ����ͼ�λ�����
	 * @param pdname ��������
	 * @return Map �������������Ϣ
	 */
	/*public Map addProcessDefine(String xpdl,String doc,String pdname);*/
	/**
	 * �������ģ�嶨��Flex
	 * @param xml ���̵�xpdl����  
	 * @param pdname ��������
	 * @param procEName ����Ӣ������
	 * @return Map �������������Ϣ
	 */
	public Map addProcessDefineFlex(String xml,String pdname,String createUserName,String procEName,String procType)throws Exception;
	public Map addProcessDefineFlex(String xml,String pdname,Map userInfo,String procEName,String procType)throws Exception;
	/**
	 * �޸�����ģ�嶨��Flex
	 * @param xml ���̵�xpdl����  
	 * @param pdname ��������
	 * @return Map �������������Ϣ
	 */
	public Map updateProcessDefineFlex(String xml,String pdname,String createUserName,String procId)throws Exception;
	public Map updateProcessDefineFlex(String xml,String pdname,Map userInfo,String procId)throws Exception;
	/**
	 * �������ģ�嶨��
	 * @param xpdl ���̵�xpdl����  
	 * @param doc  ����ͼ�λ�����
	 * @param pdname ��������
	 * @return Map �������������Ϣ
	 * @param procType ����ģ������
	 * @return
	 */
	/*public Map addProcessDefine(String xpdl,String doc,String pdname,String procType);*/
	/**
	 * �޸�����ģ�嶨��
	 * @param xpdl
	 * @param doc
	 * @param pdname
	 * @return
	 */
	public Map updateProcessDefine(String xpdl,String doc,String pdname);
	/**
	 * ��������ʵ��
	 * @param procEName ����Ӣ�ı�ʶ
	 * @param procVersion ���̰汾��
	 * @param vars      ����ʵ������
	 * @param userId    ����������ԱId
	 * @param userName  ����������Ա����
	 * @param ccUsers   ������ԱId
	 * @return
	 */
	public ProcInstEntity startProc(String procEName,String procVersion,List<WfRVariableinst> vars,String userId,String userName,String ccUsers,String orgID);
	
	
	public void reStartProc(String procInstId,String movNodeId);
	public String getPeopleNodes(String procInstId);
	/**
	 * �õ����̵�ͼ�λ���ʾXML-FLEX�汾
	 * @param procDefineId
	 * @return
	 */
	
	public Map getProcFlexView(String procEName,String procVersion );
	/**
	 * �����м���������Ϣ
	 */
	public void loadProcDefines();
	/**
	 * ���ݵ�ǰ�û���ģ�����͵õ��������б�
	 * 
	 * @param userId
	 *            �û�ID
	 * @param procType
	 *            �������� examineinstId ����ʵ��Id һ����Ϊ���ַ������� examineRoleId ��ɫId
	 * @return
	 */
	public List getExamineInstListByUserID(String userId, String procType,
			String examineinstId, String examineRoleId,String procId);
	
	/**
	 * �������ʱ�õ�����ʵ����������Ϣ�������¼��ڵ�
	 * @param procinstId     ����ʵ��Id
	 * @param examineinstId  ����ʵ��Id
	 * @param procType       �������ͣ�һ��Ϊ���ַ���
	 * @param userId         ��ǰ�û�Id
	 * @return
	 */
	public Map getExamineInfo(String procinstId, String examineinstId,
			String procType, String userId);
	
	/**
	 * �����ڵ�
	 * 
	 * @param nextNodeId
	 *            �¼��ڵ�Id
	 * @param examineInfo
	 *            �����ڵ�������Ϣ
	 * @param isPass
	 *            �Ƿ�ͨ��
	 * @param examineinstId
	 *            ����ʵ��Id
	 * @param procinstId
	 *            ����ʵ��Id
	 * @param examineUserName
	 *            �����û�����
	 * @param taskInstId
	 *            ����taskInstId
	 * @return
	 */
	public Map examineNode(String nextNodeId, String examineInfo,
			String isPass, String examineinstId, String procinstId,
			String examineUserName, String taskInstId,String userId,String busiInfo);
	
	/**
	 * ί���û�����ʵ��
	 * @param examineinstId ����ʵ���ڵ�Id
	 * @param userIds ���ί���û�Id�ö��Ÿ��� 
	 */
	public void consignExamInst(String examineinstId,String userIds);
	
	/**
	 * ��������ʵ��
	 * @param examineinstId
	 * @param examineInfo ����ԭ��
	 * @param procinstId
	 */
	public void backProcInst(String examineinstId,String examineInfo,String procinstId);
	
	/**
	 * ��������ģ��ID�õ�����ģ��ʵ��
	 * @param procDefineId ����ģ��Id
	 */
	public void getprocDefineById(String procEName,String procVersion);
	/**
	 * �õ�����ģ��ʵ������չʾ--������ʾxml
	 * @param procDefineId
	 * @return
	 */
	public Map getProcessViewById(String procDefineId);
	
	/**
	 * ���ݵ�ǰ�û�����������ʵ��
	 * @param userId ��ǰ�û�Id
	 * @param procType ��������
	 * @return
	 */
	public List getStartProcInstByCurUser(String userId,String procType);
	
	/**
	 * ͼ�λ���ʾ����ʵ�����������
	 * @param procinstId
	 * @return
	 */
	public String getProcInstView(String procinstId);
	/**
	 * �����������͵õ���Ӧ������ģ��
	 * @param procType
	 * @return
	 */
	public List getProcProcDefinesByType(String procType);
	/**
	 * ���ݽڵ�ID������ʵ��ID��ѯ��ǰ�ڵ��������Ϣ
	 * @param nodeId
	 * @param procInstId
	 * @return
	 */
	public List queryExamineInstByNodeId(String nodeId,String procInstId);
	/**
	 * ��ѯ��������ģ���µ����е�����ʵ��
	 * @return
	 */
	public List queryInstSumByProcDefine();

	/**
	 * 	�õ�ĳ��ģ����ĳ��״̬��ʵ��
	 * @param procId
	 * @param state
	 * @return
	 */
	public List queryProcInstsByProcId(String procId,String state);
	/**
	 * ��ѯ����ʵ��������Ϣ
	 * @param procInstId
	 * @return
	 */
	public List queryProcInstExamineInfo(String procInstId);
	/**
	 * �߼�ɾ������ģ��
	 * @param procDeineId
	 */
	public void delProcDefine(String procDeineId);
	/**
	 * �޸�����ģ��״̬
	 * @param procDeineId
	 */
	public void stopProcDefine(String procDeineId);
	/**
	 * ��������ģ��
	 * @param procDeineId
	 */
	public void startProcDefine(String procDeineId);
	/**
	 * ɾ������ʵ�������Ϣ
	 * @param procInstId
	 */
	public void delProcInst(String procInstId);
   /**
    * �õ����̹����б�
    * @param procType
    * @return
    */
	public String queryProcManagerList(String procType);
	/**
	 * ����Idֹͣ����ʵ��
	 * @param procInstId
	 * @return
	 */
	public void stopProcInst(String procInstId);
	/**
	 * ����userid��ѯ���͵������б�
	 * @param procInstId
	 * @return
	 */
	public List queryPorcInstCCByUserId(String userId);
	/**
	 * ������ʵ������ת�����ڵ�
	 * @param examineInstId
	 * @param examineInfo
	 * @param moveNodeId
	 * @param procinstId
	 */
	public String moveNodeProcInst(String examineInstId, String examineInfo,
			String moveNodeId,String procinstId,String taskInstId,UserToken userToken);
	/**
	 * ��ѯ�ڵ�������Ϣ
	 * @param procInstId
	 */
	public List qyeryNodeApply(String procInstId);
	
	public List queryBackNode(String nodeId) throws Exception;
	/**
	 * ��ѯ��ǰ�û��μ�����������ʵ��
	 * @param userId
	 * @param roleId
	 * @param state
	 * @param procId
	 * @param procType
	 * @return
	 */
	public List queryJoinInstByUser(String userId,String roleId,String state,String procId,String procType);
	
	/**
	 * ��ѯ��ǰ�û��μ�����������ʵ��
	 * @param userId �û�ID
	 * @param roleId ��ɫ
	 * @param state ����ʵ��״̬
	 * @param examineinstState ����ʵ��״̬
	 * @return
	 */
	public List queryJoinInstByUserBystate(String userId,String roleId,String state,String examineinstState,String procId,String procType);
	/**
	 * ����ģ����ӵ�������
	 * @param procId
	 */
	public void addProcDefine2Cache(String procId,ProcDefineService procDefineService)throws Exception;
	/**
	 * ����ҵ������
	 * @param procInstId ����ʵ��ID
	 * return ҵ������
	 */
	public String getBusinessData(String procInstId);
	public List getBusinessDataList(String ProcInstIds);
	public boolean isLink(String procInstId);
	public List queryCurrExamineinst(String procinstId);
	public List queryCurrExamineinstNode(String procinstId);
	public List getProcDefineByInst(String procinstId);
	public String addProcessDefineFlex(String xml,String procinstId);
	/**
	 * ��������ʵ��
	 * */
	public void procInstHangUp(String procInstId);
	/**
	 * ��������ģ��
	 * */
	public void procHangUp(String procId);
	/**
	 * ɾ��ģ��
	 * */
	public void deleteProc(String procId);

	/**
	 * �ָ�����
	 * */
	
	public void procInsRecovery(String procInstId);
	
	/**
	 * ɾ������
	 * */
	public void procInsDelete(String procInstId);
	/**
	 * �������� ʵ��ID������ʵ��ID��ȡ�ڵ�
	 * */
	public String getUrls(String procinstId,String examInstId);
	public void saveFlashProcinst(String procinstId);
	/*public List getUsers(String procEName,String procVersion);*/
}
