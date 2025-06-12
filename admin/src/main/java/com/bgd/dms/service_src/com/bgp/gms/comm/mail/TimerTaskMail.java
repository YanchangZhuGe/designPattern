package com.bgp.gms.comm.mail;

import java.util.Calendar;
import java.util.Date;
import java.util.Timer;

/**   
 * @Title: TimerTaskMail.java
 * @Package com.bgp.gms.comm.mail
 * @Description: TODO(��һ�仰�������ļ���ʲô)
 * @author wuhj 
 * @date 2014-10-15 ����3:30:03
 * @version V1.0   
 */
public class TimerTaskMail
{

	// ʱ����(һ��)
	private static final long PERIOD_DAY = 24 * 60 * 60 * 1000;
	
	private Date date = null;
	
	public TimerTaskMail(){
		
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.HOUR_OF_DAY, 1); // �賿1��
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		date = calendar.getTime(); // ��һ��ִ�ж�ʱ�����ʱ��
		// �����һ��ִ�ж�ʱ�����ʱ�� С�ڵ�ǰ��ʱ��
		// ��ʱҪ�� ��һ��ִ�ж�ʱ�����ʱ���һ�죬�Ա���������¸�ʱ���ִ�С��������һ�죬���������ִ�С�
		if (date.before(new Date()))
		{
			date = this.addDay(date, 1);
		}
		System.out.println(date.before(new Date()));
		
		Timer timer = new Timer(); 
		// //����ָ����������ָ����ʱ�俪ʼ�����ظ��Ĺ̶��ӳ�ִ�С�
		 timer.schedule(new SenderMailTask(),date,PERIOD_DAY);
	}
 
	/**
	 * 
	* @Title: addDay
	* @Description: ���ʱ��
	* @param @param date
	* @param @param num
	* @param @return    �趨�ļ�
	* @return Date    ��������
	* @throws
	 */
	private Date addDay(Date date, int num)
	{
		Calendar startDT = Calendar.getInstance();
		startDT.setTime(date);
		startDT.add(Calendar.DAY_OF_MONTH, num);
		return startDT.getTime();
	}
	
	public static void main(String args[]){
		new TimerTaskMail();
	}
 
}
