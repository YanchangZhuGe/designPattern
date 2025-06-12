package test;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.bgp.mcs.service.pm.service.p6.util.SynUtils;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

/**   
 * @Title: TestService.java
 * @Package test
 * @Description: TODO(用一句话描述该文件做什么)
 * @author wuhj 
 * @date 2014-7-16 上午10:32:20
 * @version V1.0   
 */
public class TestService extends BaseService{ 
	
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	

	public ISrvMsg queryProject(ISrvMsg reqDTO) throws Exception{
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		processProject(projectInfoNo);
		
		return msg;
	}
	public ISrvMsg startupProjectSynP6(ISrvMsg reqDTO) throws Exception{
		log.info("com.bgp.mcs.p6.service.SynTimerTask ======== BEGIN!");
		try{
			//格式为foo(String filter)的方法可以加到list中，便于调用
			List<String> method_names=new ArrayList<String>();//将要调用的同步方法名add到list里面
			method_names.add("synActivityGMStoP6");
			method_names.add("synActivityP6toGMS");
			//method_names.add("synActivityCodeP6toGMS");
			//method_names.add("synActivityCodeTypeP6toGMS");
			method_names.add("synWbsP6toGMS");
			//method_names.add("synResourceP6toGMS");
			//method_names.add("synResourceAssignmentP6toGMS");
			//method_names.add("synResourceCodeP6toGMS");
			//method_names.add("synResourceCodeTypeP6toGMS");
			//method_names.add("synResourceAssignmentGMStoP6");
			//method_names.add("synUDFValueP6toGMS");
			
			SynUtils synUtils=new SynUtils();
			for(int i=0;i<method_names.size();i++){
				String m_name=method_names.get(i);
				System.out.println(m_name+" is running!!=========");
				Method mothed1 = synUtils.getClass().getMethod("getFilter",String.class );   //方法名以及定义传入的参数类型
	            String filter=(String) mothed1.invoke(synUtils, m_name); //所属对象和参数
//	            System.out.println("filter="+filter);
	            try {
	            	Method mothed2 = synUtils.getClass().getMethod(m_name,String.class );  
					mothed2.invoke(synUtils, filter);
	            	Method mothed3 = synUtils.getClass().getMethod("setUpdateDate",String.class ); 
	            	mothed3.invoke(synUtils, m_name); 
				} catch (Exception e) {
					log.error("定时器:"+m_name+"异常 跳过该定时器 执行下一个定时器");
					e.printStackTrace();
					continue;
				}
			}
			synUtils.syncP6DeletedDatas();//删除同步器
			synUtils.synProject();//项目同步
			synUtils.synBaselineProject();//目标项目同步
			synUtils.syncBaseProjectId();//同步项目的目标项目编号
		}catch(Exception e){
			e.printStackTrace();
		}
		log.info("com.bgp.mcs.p6.service.SynTimerTask ======== END!");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		 
		
		return msg;
	} 
	
	private void processProject(String project_Info_No){
		
		ServiceCallConfig servicecallconfig1 = new ServiceCallConfig();
		servicecallconfig1.setServiceName("OPCostSrv");
		servicecallconfig1.setOperationName("getSingleProjectHealthInfo");
		
		if(project_Info_No ==null){ 
			try {
				String sql = "select t.* from bgp_p6_project t  where 1=1 and t.bsflag = '0' and t.project_info_no is not null ";
				List<Map> listProject=pureDao.queryRecords(sql);
				for(Map map:listProject){
					System.out.println("开始统计数据，项目为："+ map.get("project_name"));
					String projectInfoNo=(String) map.get("project_info_no");
					if(projectInfoNo!=null&&!"".equals(projectInfoNo)){
						ISrvMsg reqDTO1 = SrvMsgUtil.createISrvMsg(servicecallconfig1.getOperationName());
						reqDTO1.setValue("projectInfoNo", projectInfoNo);
						ServiceCallFactory.getIServiceCall().callWithDTO(null, reqDTO1, servicecallconfig1);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			try{
				ISrvMsg reqDTO1 = SrvMsgUtil.createISrvMsg(servicecallconfig1.getOperationName());
				reqDTO1.setValue("projectInfoNo", project_Info_No);
				ServiceCallFactory.getIServiceCall().callWithDTO(null, reqDTO1, servicecallconfig1);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}

	}
 

}
