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
        // ���÷����ʼ��Ļ�������
        final Properties props = new Properties();
        /*
         * ���õ����ԣ� mail.store.protocol / mail.transport.protocol / mail.host /
         * mail.user / mail.from
         */
        // ��ʾSMTP�����ʼ�����Ҫ���������֤
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", "mail.cnpc.com.cn");//smtp.163.com
        // �����˵��˺�
        props.put("mail.user", "notify@cnpc.com.cn");
        // ����SMTP����ʱ��Ҫ�ṩ������
        props.put("mail.password", "39xcSr82AMJ9");
        
        /*��������*/
        /*props.setProperty("proxySet", "true");
        props.setProperty("http.proxyHost", "proxy3.bj.petrochina");
        props.setProperty("http.proxyPort", "8080");*/
        
        // ������Ȩ��Ϣ�����ڽ���SMTP���������֤
        Authenticator authenticator = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                // �û���������
                String userName = props.getProperty("mail.user");
                String password = props.getProperty("mail.password");
                return new PasswordAuthentication(userName, password);
            }
        };
        // ʹ�û������Ժ���Ȩ��Ϣ�������ʼ��Ự
        Session mailSession = Session.getInstance(props, authenticator);
        // �����ʼ���Ϣ
        MimeMessage message = new MimeMessage(mailSession);
        // ���÷�����
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

        // �����ռ���
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

        // ���ó���
//        InternetAddress cc = new InternetAddress("luo_aaaaa@yeah.net");
//        message.setRecipient(RecipientType.CC, cc);

        // �������ͣ��������ռ��˲��ܿ������͵��ʼ���ַ
//        InternetAddress bcc = new InternetAddress("aaaaa@163.com");
//        message.setRecipient(RecipientType.CC, bcc);

        // �����ʼ�����
        try {
			message.setSubject("��������");
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        // �����ʼ���������
        try {
			message.setContent(messages, "text/html;charset=UTF-8");
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        // �����ʼ�
        try {
			Transport.send(message);
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }

}
