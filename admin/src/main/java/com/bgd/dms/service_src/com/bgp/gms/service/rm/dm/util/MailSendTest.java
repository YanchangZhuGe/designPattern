package com.bgp.gms.service.rm.dm.util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.Message.RecipientType;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailSendTest {

	public static void main(String[] args){
		new MailSendTest().sendMail("hellozjb");
	}
	public void sendMail(String messages){
        // 配置发送邮件的环境属性
        final Properties props = new Properties();
        /*
         * 可用的属性： mail.store.protocol / mail.transport.protocol / mail.host /
         * mail.user / mail.from
         */
        // 表示SMTP发送邮件，需要进行身份验证
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", "mail.cnpc.com.cn");//smtp.163.com
        // 发件人的账号
        props.put("mail.user", "notify@cnpc.com.cn");
        // 访问SMTP服务时需要提供的密码
        props.put("mail.password", "39xcSr82AMJ9");
        
        /*代理设置*/
        /*props.setProperty("proxySet", "true");
        props.setProperty("http.proxyHost", "proxy3.bj.petrochina");
        props.setProperty("http.proxyPort", "8080");*/
        
        // 构建授权信息，用于进行SMTP进行身份验证
        Authenticator authenticator = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                // 用户名、密码
                String userName = props.getProperty("mail.user");
                String password = props.getProperty("mail.password");
                return new PasswordAuthentication(userName, password);
            }
        };
        // 使用环境属性和授权信息，创建邮件会话
        Session mailSession = Session.getInstance(props, authenticator);
        // 创建邮件消息
        MimeMessage message = new MimeMessage(mailSession);
        // 设置发件人
        InternetAddress form = null;
		try {
			form = new InternetAddress(
			        props.getProperty("mail.user"));
		} catch (AddressException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        try {
			message.setFrom(form);
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        // 设置收件人
        InternetAddress to = null;
		try {
			to = new InternetAddress("1598228873@qq.com");
		} catch (AddressException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        try {
			message.setRecipient(RecipientType.TO, to);
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        // 设置抄送
//        InternetAddress cc = new InternetAddress("luo_aaaaa@yeah.net");
//        message.setRecipient(RecipientType.CC, cc);

        // 设置密送，其他的收件人不能看到密送的邮件地址
//        InternetAddress bcc = new InternetAddress("aaaaa@163.com");
//        message.setRecipient(RecipientType.CC, bcc);

        // 设置邮件标题
        try {
			message.setSubject("保养提醒");
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        // 设置邮件的内容体
        try {
			message.setContent(messages, "text/html;charset=UTF-8");
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        // 发送邮件
        try {
			Transport.send(message);
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }

}
