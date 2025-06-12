package com.bgp.mcs.service.util.mail;

import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;

/**
 * @Title: SimpleMailSender.java
 * @Package com.bgp.gms.comm.mail
 * @Description: 邮件发送操作
 * @author wuhj
 * @date 2014-9-25 下午4:12:14
 * @version V1.0
 */
public class SimpleMailSender{
	private static String fromAddress = "notify@cnpc.com.cn";
	private static String mailServerHost = "mail.cnpc.com.cn";
	private static String mailServerPort = "25";
	private static String userName = "notify@cnpc.com.cn";
	private static String password = "39xcSr82AMJ9";
	private static String toAddress = "dongzhi01@cnpc.com.cn";
	private static String[] toAddresses = {"donzhi01@cnpc.com.cn"};
	public static void main(String[] args) {
		sendTextMail("test","你好啊");
		
	}
	/**
	 * 只向一个邮箱发送邮件
	 * @param subject
	 * @param content
	 * @param toAddress
	 */
	public static void sendTextMail(String subject,String content){
		MailSenderInfo mailInfo  = new MailSenderInfo();
		mailInfo.setFromAddress(fromAddress);
		mailInfo.setMailServerHost(mailServerHost);
		mailInfo.setMailServerPort(mailServerPort);
		mailInfo.setUserName(userName);
		mailInfo.setPassword(password);
		mailInfo.setToAddress(toAddress);
		/*try {
			for(int i = 0;i<toAddresses.length;i++){
				mailInfo.setToAddress(toAddresses[i]);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		
		
		mailInfo.setValidate(true);
		mailInfo.setSubject(subject);
		mailInfo.setContent(content);
		sendTextMail(mailInfo);
		//ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
		//String ip = cfgHd
		//		.getSingleNodeValue("//local_url");
		//if("http://10.88.2.243:7080/BGPMCS".equals(ip)){
			//sendHtmlMail(mailInfo);
		//}
		
	}
	
	/**
	 * 群发邮件
	 * @param subject
	 * @param content
	 * @param toAddresses
	 */
	public static void sendListTextMail(String subject,String content){
		List<String> toAddresses = Arrays.asList(toAddress);
		MailSenderInfo mailInfo  = new MailSenderInfo();
		mailInfo.setFromAddress(fromAddress);
		mailInfo.setMailServerHost(mailServerHost);
		mailInfo.setMailServerPort(mailServerPort);
		mailInfo.setUserName(userName);
		mailInfo.setPassword(password);
		mailInfo.setToAddresses(toAddresses);
		mailInfo.setToAddresses(toAddresses);
		mailInfo.setValidate(true);
		mailInfo.setSubject(subject);
		mailInfo.setContent(content);
		sendListTextMail(mailInfo);
	}
	/**
	 * 群发邮件
	 * @param receivName 指定收件人
	 * @param subject 标题
	 * @param content 内容
	 * @param mailToList 收件人地址
	 */
	public static void sendListTextMail(String receivName,String subject,String content,String[] mailToList){
		List<String> toAddresses = Arrays.asList(mailToList);
		MailSenderInfo mailInfo  = new MailSenderInfo();
		StringBuffer mailBuffer = new StringBuffer();
		mailBuffer.append(receivName).append(",您好！\r\n").append(content);
		mailInfo.setFromAddress(fromAddress);
		mailInfo.setMailServerHost(mailServerHost);
		mailInfo.setMailServerPort(mailServerPort);
		mailInfo.setUserName(userName);
		mailInfo.setPassword(password);
		mailInfo.setToAddresses(toAddresses);
		mailInfo.setValidate(true);
		mailInfo.setSubject(subject);
		mailInfo.setContent(mailBuffer.toString());
		sendListTextMail(mailInfo);
	}
	/**
	 * 以HTML格式发送邮件
	 * @param subject
	 * @param content
	 */
	public static void  sendHtmlMail(String subject,String content){
		MailSenderInfo mailInfo  = new MailSenderInfo();
		mailInfo.setFromAddress(fromAddress);
		mailInfo.setMailServerHost(mailServerHost);
		mailInfo.setMailServerPort(mailServerPort);
		mailInfo.setUserName(userName);
		mailInfo.setPassword(password);
		mailInfo.setToAddress(toAddress);
		mailInfo.setValidate(true);
		mailInfo.setSubject("test");
		mailInfo.setContent("test");
		sendHtmlMail(mailInfo);
	}
	/**
	 * 以文本格式发送邮件
	 * 
	 * @param mailInfo
	 *            单发邮件
	 */
	private static boolean sendTextMail(MailSenderInfo mailInfo)
	{
		// 判断是否需要身份认证
		MyAuthenticator authenticator = null;
		Properties pro = mailInfo.getProperties();
		if (mailInfo.isValidate())
		{
			// 如果需要身份认证，则创建一个密码验证器
			authenticator = new MyAuthenticator(mailInfo.getUserName(),
					mailInfo.getPassword());
		}
		// 根据邮件会话属性和密码验证器构造一个发送邮件的session
		Session sendMailSession = Session
				.getDefaultInstance(pro, authenticator);
		try
		{
			// 根据session创建一个邮件消息
			Message mailMessage = new MimeMessage(sendMailSession);
			// 创建邮件发送者地址
			Address from = new InternetAddress(mailInfo.getFromAddress());
			// 设置邮件消息的发送者
			mailMessage.setFrom(from);
			// 创建邮件的接收者地址，并设置到邮件消息中
			Address to = new InternetAddress(mailInfo.getToAddress());
			mailMessage.setRecipient(Message.RecipientType.TO, to);
			// 设置邮件消息的主题
			mailMessage.setSubject(mailInfo.getSubject());
			// 设置邮件消息发送的时间
			mailMessage.setSentDate(new Date());
			// 设置邮件消息的主要内容
			String mailContent = mailInfo.getContent();
			mailMessage.setText(mailContent);
			// 发送邮件
			Transport.send(mailMessage);
			return true;
		} catch (MessagingException ex)
		{
			ex.printStackTrace();
		}
		return false;
	}

	/**
	 * 
	 *  以文本格式发送邮件
	* @Title: sendMoreTextMail
	* @Description: 群发邮件
	* @param @param mailInfo
	* @param @return    设定文件
	* @return boolean    返回类型
	* @throws
	 */
	private static boolean sendListTextMail(MailSenderInfo mailInfo)
	{
		// 判断是否需要身份认证
		MyAuthenticator authenticator = null;
		Properties pro = mailInfo.getProperties();
		if (mailInfo.isValidate())
		{
			// 如果需要身份认证，则创建一个密码验证器
			authenticator = new MyAuthenticator(mailInfo.getUserName(),
					mailInfo.getPassword());
		}
		// 根据邮件会话属性和密码验证器构造一个发送邮件的session
		Session sendMailSession = Session
				.getDefaultInstance(pro, authenticator);
		try
		{
			// 根据session创建一个邮件消息
			Message mailMessage = new MimeMessage(sendMailSession);
			// 创建邮件发送者地址
			Address from = new InternetAddress(mailInfo.getFromAddress());
			// 设置邮件消息的发送者
			mailMessage.setFrom(from);
			// 创建邮件的接收者地址，并设置到邮件消息中
			List<String> toAddresses = mailInfo.getToAddresses();

			Address[] addresses = new InternetAddress[toAddresses.size()];

			for (int i = 0; i < toAddresses.size(); i++)
			{
				addresses[i] = new InternetAddress(toAddresses.get(i));
			}
			mailMessage.setRecipients(Message.RecipientType.TO, addresses);
			// 设置邮件消息的主题
			mailMessage.setSubject(mailInfo.getSubject());
			// 设置邮件消息发送的时间
			mailMessage.setSentDate(new Date());
			// 设置邮件消息的主要内容
			String mailContent = mailInfo.getContent();
			
			mailMessage.setText(mailContent);
			
			// 发送邮件
			Transport.send(mailMessage);
			return true;
		} catch (MessagingException ex)
		{
			ex.printStackTrace();
		}
		return false;
	}

	public static void sendListHtmlMail(String subject,String content){
		List<String> toAddresses = Arrays.asList(toAddress);
		MailSenderInfo mailInfo  = new MailSenderInfo();
		mailInfo.setFromAddress(fromAddress);
		mailInfo.setMailServerHost(mailServerHost);
		mailInfo.setMailServerPort(mailServerPort);
		mailInfo.setUserName(userName);
		mailInfo.setPassword(password);
		mailInfo.setToAddresses(toAddresses);
		mailInfo.setValidate(true);
		mailInfo.setSubject(subject);
		mailInfo.setContent(content);
		sendListHtmlMail(mailInfo);
	}
	/**
	 * 以HTML格式发送邮件
	 * 
	 * @param mailInfo
	 *            待发送的邮件信息
	 */
	private static boolean sendHtmlMail(MailSenderInfo mailInfo)
	{
		// 判断是否需要身份认证
		MyAuthenticator authenticator = null;
		Properties pro = mailInfo.getProperties();
		// 如果需要身份认证，则创建一个密码验证器
		if (mailInfo.isValidate())
		{
			authenticator = new MyAuthenticator(mailInfo.getUserName(),
					mailInfo.getPassword());
		}
		// 根据邮件会话属性和密码验证器构造一个发送邮件的session
		Session sendMailSession = Session
				.getDefaultInstance(pro, authenticator);
		try
		{
			// 根据session创建一个邮件消息
			Message mailMessage = new MimeMessage(sendMailSession);
			// 创建邮件发送者地址
			Address from = new InternetAddress(mailInfo.getFromAddress());
			// 设置邮件消息的发送者
			mailMessage.setFrom(from);
			// 创建邮件的接收者地址，并设置到邮件消息中
			Address to = new InternetAddress(mailInfo.getToAddress());
			// Message.RecipientType.TO属性表示接收者的类型为TO
			mailMessage.setRecipient(Message.RecipientType.TO, to); 
			// 设置邮件消息的主题
			mailMessage.setSubject(mailInfo.getSubject());
			// 设置邮件消息发送的时间
			mailMessage.setSentDate(new Date());
			// MiniMultipart类是一个容器类，包含MimeBodyPart类型的对象
			Multipart mainPart = new MimeMultipart();
			// 创建一个包含HTML内容的MimeBodyPart
			BodyPart html = new MimeBodyPart();
			// 设置HTML内容
			html.setContent(mailInfo.getContent(), "text/html; charset=utf-8");
			mainPart.addBodyPart(html);
			// 将MiniMultipart对象设置为邮件内容
			mailMessage.setContent(mainPart);
			// 发送邮件
			Transport.send(mailMessage);
			return true;
		} catch (MessagingException ex)
		{
			ex.printStackTrace();
		}
		return false;
	}
	
	/**
	 * 以HTML格式发送邮件
	 * 
	 * @param mailInfo
	 *            群发邮件
	 */
	public static boolean sendListHtmlMail(MailSenderInfo mailInfo)
	{
		// 判断是否需要身份认证
		MyAuthenticator authenticator = null;
		Properties pro = mailInfo.getProperties();
		// 如果需要身份认证，则创建一个密码验证器
		if (mailInfo.isValidate())
		{
			authenticator = new MyAuthenticator(mailInfo.getUserName(),
					mailInfo.getPassword());
		}
		// 根据邮件会话属性和密码验证器构造一个发送邮件的session
		Session sendMailSession = Session
				.getDefaultInstance(pro, authenticator);
		try
		{
			// 根据session创建一个邮件消息
			Message mailMessage = new MimeMessage(sendMailSession);
			// 创建邮件发送者地址
			Address from = new InternetAddress(mailInfo.getFromAddress());
			// 设置邮件消息的发送者
			mailMessage.setFrom(from);
			// 创建邮件的接收者地址，并设置到邮件消息中
			Address to = new InternetAddress(mailInfo.getToAddress());
			// Message.RecipientType.TO属性表示接收者的类型为TO
			mailMessage.setRecipient(Message.RecipientType.TO, to);
			// 设置邮件消息的主题
			mailMessage.setSubject(mailInfo.getSubject());
			// 设置邮件消息发送的时间
			mailMessage.setSentDate(new Date());
			// MiniMultipart类是一个容器类，包含MimeBodyPart类型的对象
			Multipart mainPart = new MimeMultipart();
			// 创建一个包含HTML内容的MimeBodyPart
			BodyPart html = new MimeBodyPart();
			// 设置HTML内容
			html.setContent(mailInfo.getContent(), "text/html; charset=utf-8");
			mainPart.addBodyPart(html);
			// 将MiniMultipart对象设置为邮件内容
			mailMessage.setContent(mainPart);
			// 发送邮件
			Transport.send(mailMessage);
			return true;
		} catch (MessagingException ex)
		{
			ex.printStackTrace();
		}
		return false;
	}
}
