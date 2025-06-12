package com.bgp.mcs.service.util.mail;

import java.util.List;
import java.util.Properties;

/**   
 * @Title: MailSenderInfo.java
 * @Package com.bgp.gms.comm.mail
 * @Description: �ʼ���Ϣ
 * @author wuhj 
 * @date 2014-9-25 ����4:11:12
 * @version V1.0   
 */
public class MailSenderInfo {   
	   // �����ʼ��ķ�������IP�Ͷ˿�   
	   private String mailServerHost;   
	   private String mailServerPort = "25";   
	    // �ʼ������ߵĵ�ַ   
	    private String fromAddress;   
	    // �ʼ������ߵĵ�ַ   
	    private String toAddress;  
	    
	    private List<String> toAddresses;
	    
	    public List<String> getToAddresses()
		{
			return toAddresses;
		}
		public void setToAddresses(List<String> toAddresses)
		{
			this.toAddresses = toAddresses;
		}
		// ��½�ʼ����ͷ��������û���������   
	    private String userName;   
	    private String password;   
	    // �Ƿ���Ҫ�����֤   
	    private boolean validate = true;   
	    // �ʼ�����   
	    private String subject;   
	    // �ʼ����ı�����   
	    private String content;   
	    // �ʼ��������ļ���   
	    private String[] attachFileNames;     
	    /**  
	      * ����ʼ��Ự����  
	      */   
	    public Properties getProperties(){   
	      Properties p = new Properties();     
	      p.put("mail.smtp.host", this.mailServerHost);    
	      p.put("mail.smtp.port", this.mailServerPort);   
	      p.put("mail.smtp.auth", validate ? "true" : "false"); 
	      return p;   
	    }   
	    public String getMailServerHost() {   
	      return mailServerHost;   
	    }   
	    public void setMailServerHost(String mailServerHost) {   
	      this.mailServerHost = mailServerHost;   
	    }  
	    public String getMailServerPort() {   
	      return mailServerPort;   
	    }  
	    public void setMailServerPort(String mailServerPort) {   
	      this.mailServerPort = mailServerPort;   
	    }  
	    public boolean isValidate() {   
	      return validate;   
	    }  
	    public void setValidate(boolean validate) {   
	      this.validate = validate;   
	    }  
	    public String[] getAttachFileNames() {   
	      return attachFileNames;   
	    }  
	    public void setAttachFileNames(String[] fileNames) {   
	      this.attachFileNames = fileNames;   
	    }  
	    public String getFromAddress() {   
	      return fromAddress;   
	    }   
	    public void setFromAddress(String fromAddress) {   
	      this.fromAddress = fromAddress;   
	    }  
	    public String getPassword() {   
	      return password;   
	    }  
	    public void setPassword(String password) {   
	      this.password = password;   
	    }  
	    public String getToAddress() {   
	      return toAddress;   
	    }   
	    public void setToAddress(String toAddress) {   
	      this.toAddress = toAddress;   
	    }   
	    public String getUserName() {   
	      return userName;   
	    }  
	    public void setUserName(String userName) {   
	      this.userName = userName;   
	    }  
	    public String getSubject() {   
	      return subject;   
	    }  
	    public void setSubject(String subject) {   
	      this.subject = subject;   
	    }  
	    public String getContent() {   
	      return content;   
	    }  
	    public void setContent(String textContent) {   
	      this.content = textContent;   
	    }   
	}   

