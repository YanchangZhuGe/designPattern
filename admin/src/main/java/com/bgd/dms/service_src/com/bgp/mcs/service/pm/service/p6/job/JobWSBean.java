package com.bgp.mcs.service.pm.service.p6.job;


import java.text.SimpleDateFormat;
import java.util.Date;

import javax.xml.datatype.XMLGregorianCalendar;
import javax.xml.ws.Response;

import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.common.P6WSPortTypeFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.job.JobPortType;
import com.primavera.ws.p6.job.ScheduleResponse;

public class JobWSBean {

	private ILog log;
	JobPortType servicePort;
	public JobWSBean(){
		log = LogFactory.getLogger(JobWSBean.class);
	}
	
	public void scheduleProject(UserToken mcsUser, int projectObjectId,String dateString) throws Exception{
		//String namespace = " http://xmlns.oracle.com/Primavera/P6/WS/Job/V2";
		JobPortType servicePort = P6WSPortTypeFactory.getPortType(JobPortType.class,mcsUser);
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		Date date = sdf.parse(dateString);
		XMLGregorianCalendar dataDate = P6TypeConvert.convertNew(date);
		Response<ScheduleResponse> t =  servicePort.scheduleAsync(projectObjectId, dataDate, 5000, null, null);
		ScheduleResponse s = t.get();
		log.info("jobId:"+s.getJobId());
		log.info("jobStatus:"+s.getJobStatus());
	}
	
	public static void main(String[] args) throws Exception {
		//JobWSBean p6 = new JobWSBean();
		//p6.scheduleProject(null,4351);
	}
}
