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
 * @Description: �ʼ����Ͳ���
 * @author wuhj
 * @date 2014-9-25 ����4:12:14
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
		sendTextMail("test","��ð�");
		
	}
	/**
	 * ֻ��һ�����䷢���ʼ�
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
	 * Ⱥ���ʼ�
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
	 * Ⱥ���ʼ�
	 * @param receivName ָ���ռ���
	 * @param subject ����
	 * @param content ����
	 * @param mailToList �ռ��˵�ַ
	 */
	public static void sendListTextMail(String receivName,String subject,String content,String[] mailToList){
		List<String> toAddresses = Arrays.asList(mailToList);
		MailSenderInfo mailInfo  = new MailSenderInfo();
		StringBuffer mailBuffer = new StringBuffer();
		mailBuffer.append(receivName).append(",���ã�\r\n").append(content);
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
	 * ��HTML��ʽ�����ʼ�
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
	 * ���ı���ʽ�����ʼ�
	 * 
	 * @param mailInfo
	 *            �����ʼ�
	 */
	private static boolean sendTextMail(MailSenderInfo mailInfo)
	{
		// �ж��Ƿ���Ҫ�����֤
		MyAuthenticator authenticator = null;
		Properties pro = mailInfo.getProperties();
		if (mailInfo.isValidate())
		{
			// �����Ҫ�����֤���򴴽�һ��������֤��
			authenticator = new MyAuthenticator(mailInfo.getUserName(),
					mailInfo.getPassword());
		}
		// �����ʼ��Ự���Ժ�������֤������һ�������ʼ���session
		Session sendMailSession = Session
				.getDefaultInstance(pro, authenticator);
		try
		{
			// ����session����һ���ʼ���Ϣ
			Message mailMessage = new MimeMessage(sendMailSession);
			// �����ʼ������ߵ�ַ
			Address from = new InternetAddress(mailInfo.getFromAddress());
			// �����ʼ���Ϣ�ķ�����
			mailMessage.setFrom(from);
			// �����ʼ��Ľ����ߵ�ַ�������õ��ʼ���Ϣ��
			Address to = new InternetAddress(mailInfo.getToAddress());
			mailMessage.setRecipient(Message.RecipientType.TO, to);
			// �����ʼ���Ϣ������
			mailMessage.setSubject(mailInfo.getSubject());
			// �����ʼ���Ϣ���͵�ʱ��
			mailMessage.setSentDate(new Date());
			// �����ʼ���Ϣ����Ҫ����
			String mailContent = mailInfo.getContent();
			mailMessage.setText(mailContent);
			// �����ʼ�
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
	 *  ���ı���ʽ�����ʼ�
	* @Title: sendMoreTextMail
	* @Description: Ⱥ���ʼ�
	* @param @param mailInfo
	* @param @return    �趨�ļ�
	* @return boolean    ��������
	* @throws
	 */
	private static boolean sendListTextMail(MailSenderInfo mailInfo)
	{
		// �ж��Ƿ���Ҫ�����֤
		MyAuthenticator authenticator = null;
		Properties pro = mailInfo.getProperties();
		if (mailInfo.isValidate())
		{
			// �����Ҫ�����֤���򴴽�һ��������֤��
			authenticator = new MyAuthenticator(mailInfo.getUserName(),
					mailInfo.getPassword());
		}
		// �����ʼ��Ự���Ժ�������֤������һ�������ʼ���session
		Session sendMailSession = Session
				.getDefaultInstance(pro, authenticator);
		try
		{
			// ����session����һ���ʼ���Ϣ
			Message mailMessage = new MimeMessage(sendMailSession);
			// �����ʼ������ߵ�ַ
			Address from = new InternetAddress(mailInfo.getFromAddress());
			// �����ʼ���Ϣ�ķ�����
			mailMessage.setFrom(from);
			// �����ʼ��Ľ����ߵ�ַ�������õ��ʼ���Ϣ��
			List<String> toAddresses = mailInfo.getToAddresses();

			Address[] addresses = new InternetAddress[toAddresses.size()];

			for (int i = 0; i < toAddresses.size(); i++)
			{
				addresses[i] = new InternetAddress(toAddresses.get(i));
			}
			mailMessage.setRecipients(Message.RecipientType.TO, addresses);
			// �����ʼ���Ϣ������
			mailMessage.setSubject(mailInfo.getSubject());
			// �����ʼ���Ϣ���͵�ʱ��
			mailMessage.setSentDate(new Date());
			// �����ʼ���Ϣ����Ҫ����
			String mailContent = mailInfo.getContent();
			
			mailMessage.setText(mailContent);
			
			// �����ʼ�
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
	 * ��HTML��ʽ�����ʼ�
	 * 
	 * @param mailInfo
	 *            �����͵��ʼ���Ϣ
	 */
	private static boolean sendHtmlMail(MailSenderInfo mailInfo)
	{
		// �ж��Ƿ���Ҫ�����֤
		MyAuthenticator authenticator = null;
		Properties pro = mailInfo.getProperties();
		// �����Ҫ�����֤���򴴽�һ��������֤��
		if (mailInfo.isValidate())
		{
			authenticator = new MyAuthenticator(mailInfo.getUserName(),
					mailInfo.getPassword());
		}
		// �����ʼ��Ự���Ժ�������֤������һ�������ʼ���session
		Session sendMailSession = Session
				.getDefaultInstance(pro, authenticator);
		try
		{
			// ����session����һ���ʼ���Ϣ
			Message mailMessage = new MimeMessage(sendMailSession);
			// �����ʼ������ߵ�ַ
			Address from = new InternetAddress(mailInfo.getFromAddress());
			// �����ʼ���Ϣ�ķ�����
			mailMessage.setFrom(from);
			// �����ʼ��Ľ����ߵ�ַ�������õ��ʼ���Ϣ��
			Address to = new InternetAddress(mailInfo.getToAddress());
			// Message.RecipientType.TO���Ա�ʾ�����ߵ�����ΪTO
			mailMessage.setRecipient(Message.RecipientType.TO, to); 
			// �����ʼ���Ϣ������
			mailMessage.setSubject(mailInfo.getSubject());
			// �����ʼ���Ϣ���͵�ʱ��
			mailMessage.setSentDate(new Date());
			// MiniMultipart����һ�������࣬����MimeBodyPart���͵Ķ���
			Multipart mainPart = new MimeMultipart();
			// ����һ������HTML���ݵ�MimeBodyPart
			BodyPart html = new MimeBodyPart();
			// ����HTML����
			html.setContent(mailInfo.getContent(), "text/html; charset=utf-8");
			mainPart.addBodyPart(html);
			// ��MiniMultipart��������Ϊ�ʼ�����
			mailMessage.setContent(mainPart);
			// �����ʼ�
			Transport.send(mailMessage);
			return true;
		} catch (MessagingException ex)
		{
			ex.printStackTrace();
		}
		return false;
	}
	
	/**
	 * ��HTML��ʽ�����ʼ�
	 * 
	 * @param mailInfo
	 *            Ⱥ���ʼ�
	 */
	public static boolean sendListHtmlMail(MailSenderInfo mailInfo)
	{
		// �ж��Ƿ���Ҫ�����֤
		MyAuthenticator authenticator = null;
		Properties pro = mailInfo.getProperties();
		// �����Ҫ�����֤���򴴽�һ��������֤��
		if (mailInfo.isValidate())
		{
			authenticator = new MyAuthenticator(mailInfo.getUserName(),
					mailInfo.getPassword());
		}
		// �����ʼ��Ự���Ժ�������֤������һ�������ʼ���session
		Session sendMailSession = Session
				.getDefaultInstance(pro, authenticator);
		try
		{
			// ����session����һ���ʼ���Ϣ
			Message mailMessage = new MimeMessage(sendMailSession);
			// �����ʼ������ߵ�ַ
			Address from = new InternetAddress(mailInfo.getFromAddress());
			// �����ʼ���Ϣ�ķ�����
			mailMessage.setFrom(from);
			// �����ʼ��Ľ����ߵ�ַ�������õ��ʼ���Ϣ��
			Address to = new InternetAddress(mailInfo.getToAddress());
			// Message.RecipientType.TO���Ա�ʾ�����ߵ�����ΪTO
			mailMessage.setRecipient(Message.RecipientType.TO, to);
			// �����ʼ���Ϣ������
			mailMessage.setSubject(mailInfo.getSubject());
			// �����ʼ���Ϣ���͵�ʱ��
			mailMessage.setSentDate(new Date());
			// MiniMultipart����һ�������࣬����MimeBodyPart���͵Ķ���
			Multipart mainPart = new MimeMultipart();
			// ����һ������HTML���ݵ�MimeBodyPart
			BodyPart html = new MimeBodyPart();
			// ����HTML����
			html.setContent(mailInfo.getContent(), "text/html; charset=utf-8");
			mainPart.addBodyPart(html);
			// ��MiniMultipart��������Ϊ�ʼ�����
			mailMessage.setContent(mainPart);
			// �����ʼ�
			Transport.send(mailMessage);
			return true;
		} catch (MessagingException ex)
		{
			ex.printStackTrace();
		}
		return false;
	}
}
