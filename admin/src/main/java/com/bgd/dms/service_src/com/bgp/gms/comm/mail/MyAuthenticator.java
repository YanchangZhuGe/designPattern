package com.bgp.gms.comm.mail;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

/**
 * @Title: MyAuthenticator.java
 * @Package com.bgp.gms.comm.mail
 * @Description: 邮件验证
 * @author wuhj
 * @date 2014-9-25 下午4:13:53
 * @version V1.0
 */
public class MyAuthenticator extends Authenticator
{
	String userName = null;
	String password = null;

	public MyAuthenticator()
	{
	}

	public MyAuthenticator(String username, String password)
	{
		this.userName = username;
		this.password = password;
	}

	protected PasswordAuthentication getPasswordAuthentication()
	{
		return new PasswordAuthentication(userName, password);
	}
}