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
import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;

public class OPAutoUtil extends QuartzJobBean {

	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	
	@SuppressWarnings("rawtypes")
	@Override
	protected synchronized void executeInternal(JobExecutionContext arg0) throws JobExecutionException {
		
		ServiceCallConfig servicecallconfig = new ServiceCallConfig();
		servicecallconfig.setServiceName("OPCostSrv");
		servicecallconfig.setOperationName("hzCostActualByFormula");
		ServiceCallConfig servicecallconfig1 = new ServiceCallConfig();
		servicecallconfig1.setServiceName("OPCostSrv");
		servicecallconfig1.setOperationName("getSingleProjectHealthInfo");
		try {
			String sql = "select t.* from bgp_p6_project t  where 1=1 and t.bsflag = '0' and t.project_info_no is not null ";
			List<Map> listProject=pureDao.queryRecords(sql);
			for(Map map:listProject){
				System.out.println("开始统计数据，项目为："+ map.get("project_name"));
				String projectInfoNo=(String) map.get("project_info_no");
				if(projectInfoNo!=null&&!"".equals(projectInfoNo)){
					ISrvMsg reqDTO = SrvMsgUtil.createISrvMsg(servicecallconfig.getOperationName());
					reqDTO.setValue("projectInfoNo", projectInfoNo);
					
					ISrvMsg reqDTO1 = SrvMsgUtil.createISrvMsg(servicecallconfig1.getOperationName());
					reqDTO1.setValue("projectInfoNo", projectInfoNo);
					
					ServiceCallFactory.getIServiceCall().callWithDTO(null, reqDTO, servicecallconfig);
					ServiceCallFactory.getIServiceCall().callWithDTO(null, reqDTO1, servicecallconfig1);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
