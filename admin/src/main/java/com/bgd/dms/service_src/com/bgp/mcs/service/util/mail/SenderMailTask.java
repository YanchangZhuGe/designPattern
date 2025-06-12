package com.bgp.mcs.service.util.mail;

import java.util.TimerTask;

import com.bgp.gms.comm.mail.ExamineSendMails;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;

/**
 * @Title: TimerTaskSenderMail.java
 * @Package com.bgp.gms.comm.mail
 * @Description: �������̶�ʱ���ʼ�
 * @author wuhj
 * @date 2014-10-15 ����3:05:42
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
		log.info("��ʼ���ʼ�..............................");
		ExamineSendMails sendMails = new ExamineSendMails();
		sendMails.sendFlowInfoMailInfos(null);
		log.info("�������ʼ�.............................."); 
 
	}
 
}
