package com.bgp.dms.assess.util;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.xml.soap.SOAPException;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.soa.msg.ISrvMsg;

public class AssessTools {
	public static String generateAssessNodeCode(){
		return null;
	}
	/**
	 * ��ָ���ж�,��Ĭ��ֵ create by gaoyunpeng 20150415
	 * 
	 * @param in
	 *            ����ֵ
	 * @param defalutValue
	 *            Ĭ��ֵ
	 * @return
	 */
	public static String valueOf(Object in, String defalutValue) {
		// TODO Auto-generated method stub
		if (in == null || "".equals(in)||"null".equals(in)) {
			return defalutValue;
		}
		return in.toString();
	}
	
	/**
	 * create by gaoyunpeng 20150416 ��ȡ������
	 * 
	 * @return������
	 */
	public static  String getCurrentDate() {
		java.util.Calendar c = java.util.Calendar.getInstance();
		java.text.SimpleDateFormat f = new java.text.SimpleDateFormat(
				"yyyyMMdd");
		String currentTime = f.format(c.getTime());
		return currentTime;
	}
	/**
	 * ��ȡ������ʱ���� create by gaoyunpeng 20150416
	 * 
	 * @return������ʱ����
	 */
	public static   String getCurrentTime() {
		java.util.Calendar c = java.util.Calendar.getInstance();
		java.text.SimpleDateFormat f = new java.text.SimpleDateFormat(
				"yyyyMMddhhmmss");
		String currentTime = f.format(c.getTime());
		return currentTime;
	}
	/**
	 * ��ȡlogid create by gaoyunpeng 20150416
	 * 
	 * @return
	 */
	public static   String getLogid(String className) {
		// TODO Auto-generated method stub
		StringBuffer logid = new StringBuffer();
		java.util.Calendar c = java.util.Calendar.getInstance();
		java.text.SimpleDateFormat f = new java.text.SimpleDateFormat(
				"yyyy��MM��dd��hhʱmm��ss��");
		String currentTime = f.format(c.getTime());
		logid.append("[").append(currentTime).append("]");
		try {
			logid.append("[").append(Class.forName(className).getCanonicalName())
					.append("]");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return logid.toString();
	}
	public static String getStringNow(String formatter) {
		java.util.Calendar c = java.util.Calendar.getInstance();
		java.text.SimpleDateFormat f = new java.text.SimpleDateFormat(formatter);
		String currentTime = f.format(c.getTime());
		return currentTime;
	}
	public static String getLogid() {
		// TODO Auto-generated method stub
		StringBuffer logid = new StringBuffer();
		java.util.Calendar c = java.util.Calendar.getInstance();
		java.text.SimpleDateFormat f = new java.text.SimpleDateFormat(
				"yyyy��MM��dd��hhʱmm��ss��");
		String currentTime = f.format(c.getTime());
		logid.append("[").append(currentTime).append("]");
		logid.append("[").append(Class.class.getSuperclass())
				.append("]");
		return logid.toString();
	}
	public static void printLoginfo(String logname, String msg,
			boolean displayOnConsole) {
		String logid = getLogid();
		org.apache.log4j.Logger logger = org.apache.log4j.Logger
				.getLogger(logname);
		StringBuffer loginfo = new StringBuffer();
		loginfo.append(logid).append(msg);
		String info = loginfo.toString();
		logger.info(info);
		if (displayOnConsole) {
			System.out.println(info);
		}
	}
	public static PageModel getPage(ISrvMsg msg,String pageSize) throws SOAPException{
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		return page;
	}
	/**
	 * ҳ��������뷵�ض���responseDTO
	 * @param msg ҳ���������
	 * @param responseDTO
	 * @return
	 * @throws Exception
	 */
	public static ISrvMsg setParams(ISrvMsg msg,ISrvMsg responseDTO) throws Exception{
		Map<String, Object> params = null;
		if(msg!=null){
			params = msg.toMap();
			Set<String> keys = params.keySet();
			for (Iterator iterator = keys.iterator(); iterator.hasNext();) {
				String key = (String) iterator.next();
				String value = AssessTools.valueOf(params.get(key), "");
				responseDTO.setValue(key, value);
			}
		}
		
		return responseDTO;
	}
	/**
	 * �������¼map����responseDTO
	 * @param params �������¼
	 * @param responseDTO
	 * @return
	 * @throws Exception
	 */
	public static ISrvMsg setParams(Map params,ISrvMsg responseDTO) throws Exception{
		printLoginfo("DMS", "setMapParams", true);
		Set<String> keys = null;
		if(params!=null){
			keys = params.keySet();
			for (Iterator iterator = keys.iterator(); iterator.hasNext();) {
				String key = (String) iterator.next();
				String value = AssessTools.valueOf(params.get(key), "");
				System.out.println("key=" + key + " value=" + value);
				responseDTO.setValue(key.toLowerCase(), value);
			}
		}
		
		return responseDTO;
	}
	/**
	 * �����ַ����Թ̶�������ҳ���ϻ���
	 * @param content ���ַ���
	 * @param lineSize �ַ�������
	 * @return
	 */
	public static String newLines(String content,int lineSize){
		StringBuffer contentBuffer = new StringBuffer();
		int contentSize = valueOf(content, "").length();
		int index = 0;
		for(int x = 0;x<contentSize;x++){
			if(x>=lineSize){
				
				if(x!=0){
					int flag = x%lineSize;
					
					if(flag==0){
						String lineStr = content.substring(x-lineSize, x);
						contentBuffer.append("<p>").append(lineStr).append("</p>");
						
						index = x;
					}
					if(x+lineSize>contentSize){
						
						index = x;
						break;
					}
				}
				
			}
			
		}
		String lastStr = content.substring(index, contentSize);
		contentBuffer.append("<p>").append(lastStr).append("</p>");
		return contentBuffer.toString();
	}
	public static String newLinesBySeparator(String content,String separator, int lineSize){
		String[] array = content.split(separator);
		StringBuffer buffer = new StringBuffer();
		for (int i = 0; i < array.length; i++) {
			
			String line = newLines(array[i], lineSize);
			buffer.append(line);
		}
		return buffer.toString();
	}
	public static void main(String[] args) {
		String s = "abcdefyy";
		System.out.println(newLines(s, 3));
	}
}
