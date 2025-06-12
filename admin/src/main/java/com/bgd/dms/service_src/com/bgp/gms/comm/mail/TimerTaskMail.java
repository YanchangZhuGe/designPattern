package com.bgp.gms.comm.mail;

import java.util.Calendar;
import java.util.Date;
import java.util.Timer;

/**   
 * @Title: TimerTaskMail.java
 * @Package com.bgp.gms.comm.mail
 * @Description: TODO(用一句话描述该文件做什么)
 * @author wuhj 
 * @date 2014-10-15 下午3:30:03
 * @version V1.0   
 */
public class TimerTaskMail
{

	// 时间间隔(一天)
	private static final long PERIOD_DAY = 24 * 60 * 60 * 1000;
	
	private Date date = null;
	
	public TimerTaskMail(){
		
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.HOUR_OF_DAY, 1); // 凌晨1点
		calendar.set(Calendar.MINUTE, 0);
		calendar.set(Calendar.SECOND, 0);
		date = calendar.getTime(); // 第一次执行定时任务的时间
		// 如果第一次执行定时任务的时间 小于当前的时间
		// 此时要在 第一次执行定时任务的时间加一天，以便此任务在下个时间点执行。如果不加一天，任务会立即执行。
		if (date.before(new Date()))
		{
			date = this.addDay(date, 1);
		}
		System.out.println(date.before(new Date()));
		
		Timer timer = new Timer(); 
		// //安排指定的任务在指定的时间开始进行重复的固定延迟执行。
		 timer.schedule(new SenderMailTask(),date,PERIOD_DAY);
	}
 
	/**
	 * 
	* @Title: addDay
	* @Description: 添加时间
	* @param @param date
	* @param @param num
	* @param @return    设定文件
	* @return Date    返回类型
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
