package com.bgp.mcs.service.pm.bpm.workFlow.srv;

import java.util.List;
import java.util.Map;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;

import com.bgp.gms.service.op.srv.OPCostSrv;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.PureJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;


/**
 * ���ߣ����챪
 * 
 * ʱ�䣺2012-6-7
 * 
 * ˵��: �û����������������뵽ҵ����,�ڲ�Ӱ��ҵ���������£���ҵ���������̹ܿ���
 * 
 * ������aspectjrt.jar aspectjweaver.jar aopalliance.jar�Լ�spring3 AOP/ASPECTJ
 */

@Aspect
public class WFAroundAdvice  extends OPCostSrv{

	/**
	 * 
	 */
	/*
	 * ��������㣬��Ӱ�����з�������Ϊ���⣬�����������ҷ�������WFPI��β�ķ���
	 */
	@Pointcut("execution(* *.*WFPI(..))")
	public void wfProcessInitiatingCut(){
		
	}
	
	@Around("wfProcessInitiatingCut()")
	public Object doWFProcessInitiating(ProceedingJoinPoint  joinPoint) throws Throwable {
		Object responesObj=joinPoint.proceed();
		Object requestObjs[]=joinPoint.getArgs();
		if(requestObjs!=null&&requestObjs.length==1){
			if(requestObjs[0] instanceof  ISrvMsg){
				ISrvMsg reqDTO=(ISrvMsg) requestObjs[0];
				UserToken user = reqDTO.getUserToken();
				WFCommonBean wfBean=new WFCommonBean();
				String businessId = reqDTO.getValue("businessId");
				String businessTableName = reqDTO.getValue("businessTableName");
				String businessType = reqDTO.getValue("businessType");
				String projectName = reqDTO.getValue("projectName");
				String applicantDate = reqDTO.getValue("applicantDate");
				String businessInfo=reqDTO.getValue("businessInfo");
				

				WFVarBean wfVar = new WFVarBean(businessId, businessTableName, businessType,businessInfo, wfBean.copyMapFromStartMap(reqDTO.toMap(), "wfVar_"),
						projectName, user, applicantDate);
				wfBean.startWFProcess(wfVar);
			}
		}
		return responesObj;
	}
	
	
	/*
	 * ��������㣬��Ӱ�����з�������Ϊ���⣬�����������ҷ�������WFPG��β�ķ���
	 * 
	 * ���뵽ҵ��ķ��ʲ�����,��ȡ���������Ϣ���������������ǩ������
	 */
	@Pointcut("execution(* *.*wfpg(..))")
	public void wfProcessGetIntoCut(){
		
	}
	
	
	/*
	 * ����֪ͨ����ز�����������Χ֪ͨ����Ӧ�е�ΪwfProcessGetIntoCut.ͬһ�������
	 * 
	 * ��ȡ���̵����������Ϣ���Թ�ǰ̨ҵ���������̱�ǩ
	 */
	@SuppressWarnings("rawtypes")
	@Around("wfProcessGetIntoCut()")
	public Object doWFProcessGetInto(ProceedingJoinPoint  joinPoint) throws Throwable {
		Object responesObj=joinPoint.proceed();
		Object requestObjs[]=joinPoint.getArgs();
		if(requestObjs!=null&&requestObjs.length==1){
			if(requestObjs[0] instanceof  ISrvMsg){
				if(responesObj instanceof ISrvMsg){
					ISrvMsg reqDTO=(ISrvMsg) requestObjs[0];
					ISrvMsg responseDTO=(ISrvMsg) responesObj;
					WFCommonBean wfBean=new WFCommonBean();
					String businessType = reqDTO.getValue("businessType");
					String procinstId = reqDTO.getValue("procinstID");
					String examineinstId = reqDTO.getValue("examineinstID");
					String businessId=reqDTO.getValue("businessId");
					
					
					Map map = wfBean.getWFProcessInfo(reqDTO.getUserToken(), businessType, procinstId, examineinstId);
					wfBean.copyMapToDTO(map, responseDTO);

					//��ȡ������ʷ��Ϣ
					List listExamine = wfBean.getProcHistory(procinstId);
					responseDTO.setValue("examineInfoList", listExamine);

					//��ȡ���̱�����Ϣ
					Map mapVarialble=wfBean.getProcessVarInfo(procinstId);
					wfBean.copyMapToDTO(mapVarialble, responseDTO);

					responseDTO.setValue("businessId", businessId);
					responseDTO.setValue("businessType", businessType);
					responseDTO.setValue("examineinstId", examineinstId);
					responseDTO.setValue("procinstId", procinstId);
					
					return responseDTO;
				}
			}
		}
		return responesObj;
	}
	/*
	 * ��������㣬��Ӱ�����з�������Ϊ���⣬�����������ҷ�������WFPA��β�ķ���
	 * 
	 * ���뵽ҵ��ľ�������У��������̵�����
	 */
	@Pointcut("execution(* *.*wfpa(..))")
	public void wfProcessApprovalCut(){
		
	}
	/*
	 * ����֪ͨ����ز�����������Χ֪ͨ����Ӧ�е�ΪwfProcessApprovalCut.ͬһ�������
	 */
	@Around("wfProcessApprovalCut()")
	public synchronized Object doWFProcessApproval(ProceedingJoinPoint  joinPoint) throws Throwable {

		Object requestObjs[]=joinPoint.getArgs();
		Object responesObj=joinPoint.proceed();
		if(requestObjs!=null&&requestObjs.length==1){
			if(requestObjs[0] instanceof  ISrvMsg){
				WFCommonBean wfBean=new WFCommonBean();
				ISrvMsg reqDTO=(ISrvMsg) requestObjs[0];
				String nextNodeId = reqDTO.getValue("nextNodeID");
				String examineInfo = reqDTO.getValue("examineInfo");
				String isPassstr = reqDTO.getValue("isPass");
				String isFirst=reqDTO.getValue("isFirst");
				if("notPass".equals(isPassstr)){
					if("true".equals(isFirst)){
						isPassstr="back1";
					}else{
						isPassstr="back";
					}
				}
				String examineinstId = reqDTO.getValue("examineinstID");
				String procinstId = reqDTO.getValue("procinstID");
				String taskinstId = reqDTO.getValue("taskinstId");
				String moveNodeId = reqDTO.getValue("moveNodeId");
				String businessId=reqDTO.getValue("businessId");
				String sqlExamineInst="select state from wf_r_examineinst where entity_id = '"+examineinstId+"'";
				Map map= BeanFactory.getPureJdbcDAO().queryRecordBySQL(sqlExamineInst);
				String state="1";
				if(map!=null){
					state=(String) map.get("state");
				}
				if(!"2".equals(state)){
					if("pass".equals(isPassstr)||"back1".equals(isPassstr)||"back".equals(isPassstr)){
						String procStatus = wfBean.doWfProcess(reqDTO.getUserToken(), nextNodeId, examineInfo, isPassstr, examineinstId, procinstId,
								taskinstId, moveNodeId,businessId);
						if(responesObj instanceof ISrvMsg){
							ISrvMsg responseDTO=(ISrvMsg) responesObj;
							responseDTO.setValue("procStatus", procStatus);
						}
					}else{
						if(responesObj instanceof ISrvMsg){
							ISrvMsg responseDTO=(ISrvMsg) responesObj;
							responseDTO.setValue("procStatus", "1");
						}
					}
				}
			}
		}
		return responesObj;
	}
	
}
