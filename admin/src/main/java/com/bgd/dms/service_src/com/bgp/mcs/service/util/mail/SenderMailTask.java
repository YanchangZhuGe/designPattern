package com.bgp.mcs.service.util.mail;

import java.util.TimerTask;

import com.bgp.gms.comm.mail.ExamineSendMails;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;

/**
 * @Title: TimerTaskSenderMail.java
 * @Package com.bgp.gms.comm.mail
 * @Description: 审批流程定时发邮件
 * @author wuhj
 * @date 2014-10-15 下午3:05:42
 * @version V1.0
 */
public class SenderMailTask extends TimerTask
{
	private ILog log;

	public SenderMailTask()
	{
		log = LogFactory.getLogger(SenderMailTask.class);

	}
 
	@Override
	public void run()
	{
		log.info("开始发邮件..............................");
		ExamineSendMails sendMails = new ExamineSendMails();
		sendMails.sendFlowInfoMailInfos(null);
		log.info("结束发邮件.............................."); 
 
	}
 
}
