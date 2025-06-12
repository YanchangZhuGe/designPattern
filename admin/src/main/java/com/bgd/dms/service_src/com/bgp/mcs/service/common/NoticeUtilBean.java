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
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：屈克将
 *       
 * 描述：通知提醒的功能类
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

		log.debug("准备发送通知...");
		
		Map retMap = new HashMap();
		
		String dataId =(String)dataMap.get("dataId"); // 数据ID
		String dataUnique =(String)dataMap.get("dataUnique"); // 数据唯一性辅助字段
		String target = (String)dataMap.get("empId"); // 接收人
		String method = (String)dataMap.get("method");// 方式
		String title = (String)dataMap.get("title");// 标题
		if(title!=null){
			title = URLDecoder.decode(title, "UTF-8");
		}else{
			title="";
		}
		
		String content = (String)dataMap.get("content");// 内容
		if(content!=null){
			content = URLDecoder.decode(content, "UTF-8");
		}else{
			content="";
		}
		
		String priority = (String)dataMap.get("priority");// 优先级
		
		String sender = (String)dataMap.get("sender");//2010-08-31添加，发送人
		String link = (String)dataMap.get("link");//2010-08-31添加，链接
		String origin = (String)dataMap.get("origin");//原始来源
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
				
				if(ocsId!=null && method.indexOf("0110000010000000001")>=0){ // OCS消息
					
					Map ocsMap = new HashMap();
					
					ocsMap.put("target", "MSN:"+ocsId);//+ocsId
					
					ocsMap.put("messagename", title);
					
					ocsMap.put("messagedoc", format.format(new Date())+" 物探生产管理系统提示："+title+"\n"+content+"\n\n");//物探生产管理
					
					ocsMap.put("messagepriority", "1");
					
					pureDao.saveOrUpdateEntity(ocsMap, "bgp_ts_messageinfo");

					log.debug("发送给"+ empName + ocsId + "一条OCS消息...");
					
				}

				if(ocsId!=null && method.indexOf("0110000010000000003")>=0){ // 短信
					
					Map ocsMap = new HashMap();
					
					ocsMap.put("target", "SMS:"+ocsId);
					
					ocsMap.put("messagename", title);
					
					ocsMap.put("messagedoc", content);
					
					ocsMap.put("messagepriority", "5");
					
					pureDao.saveOrUpdateEntity(ocsMap, "bgp_ts_messageinfo");
					
					log.debug("发送给"+ empName+ ocsId + "一条短消息...");
				}
				
//				if(mailAdd!=null && method.indexOf("0110000010000000002")>=0){ // 邮件
//					
//					String smtphost = "mail.cnpc.com.cn"; // 发送邮件服务器
//					String user = "it_support@cnpc.com.cn"; // 邮件服务器登录用户名
//					String password = "123456"; // 邮件服务器登录密码
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
//					message.setSubject("物探生产管理系统提示："+title);
//					message.setText(content);
//
//					Transport transport = ssn.getTransport("smtp");
//					transport.connect(smtphost, user, password);
//					transport.sendMessage(message, message.getRecipients(Message.RecipientType.TO));
//					transport.close();
//					
//					log.debug("发送给"+ empName+ mailAdd + "一封邮件...");
//				}
				
				if(method.indexOf("0110000010000000004")>=0){ // 待办事宜
					
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
					
					log.debug("发送给"+ empName+ targets[i] + "一条待办事宜...");
				}
				
				
			}
		}

		log.debug("发送通知完毕...");
		
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
	 * 处理一条待办事宜信息
	 * 在提醒表的priority字段，工作检查提醒设为9999，工作完成后清除。提醒接收人不能自己清除。
	 */
	public void handlePending(String messageId) throws Exception {

		Map map = jdbcDao.queryEntity("bgp_comm_pending_message",messageId);
		
		if(map!=null && !((String)map.get("priority")).contains("9999")){
			pureDao.deleteEntity("bgp_comm_pending_message",messageId);
		}
	}
}
