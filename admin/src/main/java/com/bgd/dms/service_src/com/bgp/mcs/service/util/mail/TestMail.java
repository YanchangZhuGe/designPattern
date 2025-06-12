package com.bgp.mcs.service.util.mail;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

/**
 * @Title: TestMail.java
 * @Package com.bgp.gms.comm.mail
 * @Description: TODO(用一句话描述该文件做什么)
 * @author wuhj
 * @date 2014-9-25 下午4:14:46
 * @version V1.0
 */
public class TestMail
{

	/**
	 * @Title: main
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @param @param args 设定文件
	 * @return void 返回类型
	 * @throws
	 */
	public static void main(String[] args)
	{
		System.out.println(0%2);
 
//		// 这个类主要是设置邮件
//		MailSenderInfo mailInfo = new MailSenderInfo();
//		mailInfo.setMailServerHost("mail.cnpc.com.cn");
//		mailInfo.setMailServerPort("25");
//		mailInfo.setValidate(true);
//		mailInfo.setUserName("wuhaijun01@cnpc.com.cn");
//		mailInfo.setPassword("");// 您的邮箱密码
//		mailInfo.setFromAddress("wuhaijun01@cnpc.com.cn");
//		List<String> toAddresses = new ArrayList<String>();
//		toAddresses.add("328988215@qq.com");
//		toAddresses.add("18612617743@163.com");
//		mailInfo.setToAddresses(toAddresses);
////		mailInfo.setToAddress("328988215@qq.com");
//		mailInfo.setSubject("设置邮箱标题");
//		mailInfo.setContent("设置邮箱内容");
//		// 这个类主要来发送邮件
//		SimpleMailSender sms = new SimpleMailSender();
//		boolean flag = sms.sendMoreTextMail(mailInfo);
////		boolean flag = sms.sendTextMail(mailInfo);// 发送文体格式
//		if(flag){
//			System.out.println("发送成功！");
//		}
//		sms.sendHtmlMail(mailInfo);// 发送html格式
	}

}
