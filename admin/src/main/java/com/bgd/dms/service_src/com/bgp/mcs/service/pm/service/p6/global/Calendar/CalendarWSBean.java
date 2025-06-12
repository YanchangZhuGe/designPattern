package com.bgp.mcs.service.pm.service.p6.global.Calendar;

import java.util.ArrayList;
import java.util.List;

import com.bgp.mcs.service.pm.service.common.P6WSPortTypeFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.primavera.ws.p6.calendar.Calendar;
import com.primavera.ws.p6.calendar.CalendarFieldType;
import com.primavera.ws.p6.calendar.CalendarPortType;

/**
 * 
 * ���⣺��ʯ�ͼ��Ź�˾��������ϵͳ
 * 
 * רҵ����̽רҵ
 * 
 * ��˾: �������
 * 
 * ���ߣ��ǿ��Jan 5, 2012
 * 
 * ������
 * 
 * ˵��:
 */
public class CalendarWSBean {

	private ILog log;
	
	public CalendarWSBean() {
		log = LogFactory.getLogger(CalendarWSBean.class);
	}
	
	/**
	 * ��P6�л�ȡ��������
	 * @param mcsUser
	 * @param filter
	 * @param order
	 * @return
	 * @throws Exception
	 */
	public List<Calendar> getCalendarFromP6(UserToken mcsUser, String filter, String order)throws Exception {
		List<CalendarFieldType> fieldTypes = new ArrayList<CalendarFieldType>();
		fieldTypes.add(CalendarFieldType.OBJECT_ID);
		fieldTypes.add(CalendarFieldType.NAME);
		fieldTypes.add(CalendarFieldType.PROJECT_OBJECT_ID);
		fieldTypes.add(CalendarFieldType.TYPE);
		//fieldTypes.add(CalendarFieldType.BASE_CALENDAR_OBJECT_ID);
		fieldTypes.add(CalendarFieldType.HOURS_PER_DAY);
		fieldTypes.add(CalendarFieldType.HOURS_PER_MONTH);
		fieldTypes.add(CalendarFieldType.HOURS_PER_WEEK);
		fieldTypes.add(CalendarFieldType.HOURS_PER_YEAR);
		//fieldTypes.add(CalendarFieldType.STANDARD_WORK_WEEK);
		fieldTypes.add(CalendarFieldType.LAST_UPDATE_DATE);
		
		CalendarPortType calendarServicePort = P6WSPortTypeFactory.getPortType(CalendarPortType.class,mcsUser);
		
		List<Calendar> list = calendarServicePort.readCalendars(fieldTypes, filter, order);
		
		return list;
	}
	
	public static void main(String[] args) throws Exception {
		CalendarWSBean cw = new CalendarWSBean();
		List<Calendar> list = cw.getCalendarFromP6(null, null, null);
		for (int i = 0; i < list.size(); i++) {
			Calendar c = list.get(i);
			System.out.println(c.getName() +"||"+c.getObjectId()+"||"+ c.getHoursPerDay());
		}
	}
}
