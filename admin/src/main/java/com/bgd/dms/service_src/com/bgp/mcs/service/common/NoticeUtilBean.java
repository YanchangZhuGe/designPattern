package com.bgp.mcs.service.common;

import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
/**
 * ���⣺������������˾��̽��������ϵͳ
 * 
 * ��˾: �������
 * 
 * ���ߣ����˽�
 *       
 * ������֪ͨ���ѵĹ�����
 */
public class NoticeUtilBean{

	private ILog log;
    private IJdbcDao jdbcDao;
    private IPureJdbcDao pureDao;
    
    public NoticeUtilBean()
    {
        log = LogFactory.getLogger(NoticeUtilBean.class);
        jdbcDao = BeanFactory.getQueryJdbcDAO();
        pureDao = BeanFactory.getPureJdbcDAO();
    }
    
	public Map notice(Map dataMap) throws Exception {

		log.debug("׼������֪ͨ...");
		
		Map retMap = new HashMap();
		
		String dataId =(String)dataMap.get("dataId"); // ����ID
		String dataUnique =(String)dataMap.get("dataUnique"); // ����Ψһ�Ը����ֶ�
		String target = (String)dataMap.get("empId"); // ������
		String method = (String)dataMap.get("method");// ��ʽ
		String title = (String)dataMap.get("title");// ����
		if(title!=null){
			title = URLDecoder.decode(title, "UTF-8");
		}else{
			title="";
		}
		
		String content = (String)dataMap.get("content");// ����
		if(content!=null){
			content = URLDecoder.decode(content, "UTF-8");
		}else{
			content="";
		}
		
		String priority = (String)dataMap.get("priority");// ���ȼ�
		
		String sender = (String)dataMap.get("sender");//2010-08-31��ӣ�������
		String link = (String)dataMap.get("link");//2010-08-31��ӣ�����
		String origin = (String)dataMap.get("origin");//ԭʼ��Դ
		if(link!=null){
			link = URLDecoder.decode(link, "UTF-8");
		}else{
			link = "";
		}
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				
		if(target!=null){
			String[] targets = target.split(",");
			
			StringBuffer sb = new StringBuffer();
			
			for(int i=0;i<targets.length;i++){
				sb = new StringBuffer();
				sb.append("select e.employee_name as empname,e.mail_address as mailadd,u.account_id as ocsid from comm_human_employee e");
				
				sb.append(" left join bgp_comm_user_map u on e.employee_id=u.employee_id  and u.account_type='OCS'");
				
				sb.append("  where e.bsflag='0' and  e.employee_id='").append(targets[i]).append("'");
				
				Map accountMap = jdbcDao.queryRecordBySQL(sb.toString());
				
				if(accountMap==null) continue;
				String empName = (String)accountMap.get("empname");
				String ocsId = (String)accountMap.get("ocsid");
				String mailAdd = (String)accountMap.get("mailadd");
				
				if(ocsId!=null && method.indexOf("0110000010000000001")>=0){ // OCS��Ϣ
					
					Map ocsMap = new HashMap();
					
					ocsMap.put("target", "MSN:"+ocsId);//+ocsId
					
					ocsMap.put("messagename", title);
					
					ocsMap.put("messagedoc", format.format(new Date())+" ��̽��������ϵͳ��ʾ��"+title+"\n"+content+"\n\n");//��̽��������
					
					ocsMap.put("messagepriority", "1");
					
					pureDao.saveOrUpdateEntity(ocsMap, "bgp_ts_messageinfo");

					log.debug("���͸�"+ empName + ocsId + "һ��OCS��Ϣ...");
					
				}

				if(ocsId!=null && method.indexOf("0110000010000000003")>=0){ // ����
					
					Map ocsMap = new HashMap();
					
					ocsMap.put("target", "SMS:"+ocsId);
					
					ocsMap.put("messagename", title);
					
					ocsMap.put("messagedoc", content);
					
					ocsMap.put("messagepriority", "5");
					
					pureDao.saveOrUpdateEntity(ocsMap, "bgp_ts_messageinfo");
					
					log.debug("���͸�"+ empName+ ocsId + "һ������Ϣ...");
				}
				
//				if(mailAdd!=null && method.indexOf("0110000010000000002")>=0){ // �ʼ�
//					
//					String smtphost = "mail.cnpc.com.cn"; // �����ʼ�������
//					String user = "it_support@cnpc.com.cn"; // �ʼ���������¼�û���
//					String password = "123456"; // �ʼ���������¼����
//					
//					Properties props = new Properties();
//					props.put("mail.smtp.host", smtphost);
//					props.put("mail.smtp.auth","true");
//					Session ssn = Session.getInstance(props, null);
//
//					MimeMessage message = new MimeMessage(ssn);
//
//					InternetAddress fromAddress = new InternetAddress("it_support@cnpc.com.cn");
//					message.setFrom(fromAddress);
//					InternetAddress toAddress = new InternetAddress(mailAdd);
//					message.addRecipient(Message.RecipientType.TO, toAddress);
//
//					message.setSubject("��̽��������ϵͳ��ʾ��"+title);
//					message.setText(content);
//
//					Transport transport = ssn.getTransport("smtp");
//					transport.connect(smtphost, user, password);
//					transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
//					transport.close();
//					
//					log.debug("���͸�"+ empName+ mailAdd + "һ���ʼ�...");
//				}
				
				if(method.indexOf("0110000010000000004")>=0){ // ��������
					
					Map pendingMap = new HashMap();
					
					pendingMap.put("target", targets[i]);
					
					pendingMap.put("title", title);
					
					pendingMap.put("content", content);

					pendingMap.put("link", link);

					pendingMap.put("sender", sender);

					pendingMap.put("send_date", new Date());

					pendingMap.put("priority", priority);
					pendingMap.put("origin", origin);
					String pendingMessageId = (String)pureDao.saveOrUpdateEntity(pendingMap, "bgp_comm_pending_message");;
					
					retMap.put("pendingMessageId", pendingMessageId);
					
					log.debug("���͸�"+ empName+ targets[i] + "һ����������...");
				}
				
				
			}
		}

		log.debug("����֪ͨ���...");
		
		return retMap;
		
	}

	public List<Map> getNoticeLog(String dataId, String dataUnique) throws Exception {

		Map noticeLogData = new HashMap();
		
		noticeLogData.put("empId", "");
		noticeLogData.put("empName", "");
		noticeLogData.put("method", "");
		noticeLogData.put("methodName", "");
		noticeLogData.put("title", "");
		noticeLogData.put("content", "");
		noticeLogData.put("noticeDate", "");
		
		List<Map> logList = new ArrayList<Map>(); 
		
		logList.add(noticeLogData);
		
		return logList;
	}
	
	public String getPendingNum(String empId) throws Exception {

		StringBuffer sb = new StringBuffer();
		
		sb.append("select count(*) as pendingNum from bgp_comm_pending_message t where t.target='").append(empId).append("'");
		
		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		
		if(map!=null){
			return (String)map.get("pendingnum");
		}
		return "0";
	}

	public Map getPendingInfo(String messageId) throws Exception {

		StringBuffer sb = new StringBuffer();
		
		sb.append("select t.message_id,t.title,t.link,t.content,");
		
		sb.append(" to_char(send_date,'yyyy-MM-dd hh24:mi:ss') as send_date,e.employee_name as sender");
		
		sb.append(",(select for_pre.message_id from bgp_comm_pending_message for_pre where for_pre.target = t.target and for_pre.send_date > t.send_date and rownum=1) as pre_id");
		
		sb.append(",(select for_next.message_id from bgp_comm_pending_message for_next where for_next.target = t.target and for_next.send_date < t.send_date and rownum=1) as next_id");
		
		sb.append(" from bgp_comm_pending_message t left join comm_human_employee e on e.employee_id=t.sender");
		
		sb.append(" where t.message_id = '").append(messageId).append("'");
		
		Map pending = jdbcDao.queryRecordBySQL(sb.toString());
		
		sb = new StringBuffer();
		
		return pending;
	}
	
	/**
	 * ����һ������������Ϣ
	 * �����ѱ��priority�ֶΣ��������������Ϊ9999��������ɺ���������ѽ����˲����Լ������
	 */
	public void handlePending(String messageId) throws Exception {

		Map map = jdbcDao.queryEntity("bgp_comm_pending_message",messageId);
		
		if(map!=null && !((String)map.get("priority")).contains("9999")){
			pureDao.deleteEntity("bgp_comm_pending_message",messageId);
		}
	}
}
