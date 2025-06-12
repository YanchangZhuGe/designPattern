package com.bgp.gms.service.op.srv;

import java.util.List;
import java.util.Map;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

public class OPAutoHealthUtil extends QuartzJobBean {

	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	
	@SuppressWarnings("rawtypes")
	@Override
	protected synchronized void executeInternal(JobExecutionContext arg0) throws JobExecutionException {

		ServiceCallConfig servicecallconfig1 = new ServiceCallConfig();
		servicecallconfig1.setServiceName("OPCostSrv");
		servicecallconfig1.setOperationName("getSingleProjectHealthInfo");
		
			String sql = "select t.* from bgp_p6_project t JOIN gp_task_project gp ON t.PROJECT_INFO_NO=gp.PROJECT_INFO_NO AND gp.bsflag='0' and t.bsflag = '0' AND gp.PROJECT_TYPE<>'5000100004000000008' and t.project_info_no is not null ";
			List<Map> listProject=pureDao.queryRecords(sql);
			for(Map map:listProject){
				try {
					System.out.println("开始统计数据，项目为："+ map.get("project_name"));
					String projectInfoNo=(String) map.get("project_info_no");
					if(projectInfoNo!=null&&!"".equals(projectInfoNo)){
						ISrvMsg reqDTO1 = SrvMsgUtil.createISrvMsg(servicecallconfig1.getOperationName());
						reqDTO1.setValue("projectInfoNo", projectInfoNo);
						ServiceCallFactory.getIServiceCall().callWithDTO(null, reqDTO1, servicecallconfig1);
					}
				} catch (Exception e) {
					e.printStackTrace();
					continue;//如果循环内一个处理有问题  不能影响循环后面的执行，跳出本次循环 继续后面的数据处理 所以加了continue
				}
			}
		
	}

}
