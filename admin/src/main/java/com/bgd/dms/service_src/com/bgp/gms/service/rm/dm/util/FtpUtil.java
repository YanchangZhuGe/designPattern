package com.bgp.gms.service.rm.dm.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPClientConfig;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * ���ߣ� ������
 * �������� ��2013-6-27
 * ����˵����ftp����������
 * �޸ļ�¼��
 */
public class FtpUtil {
	static Logger logger = LoggerFactory.getLogger(FtpUtil.class);
	
	/**
	 * ����·�������ƻ��ftp���ļ�����
	 * @param storedir
	 * @param storename
	 * @return
	 * @throws Exception
	 */
	public static InputStream getFileStream(FTPClient client,String storedir, String storename) throws Exception{
		
		try {
			if(StringUtils.isNotBlank(storedir)){
				String[] dirs = StringUtils.split(storedir,"/");
				for (String d : dirs) {
					//�ı乤��Ŀ¼
					client.changeWorkingDirectory(new String(d.getBytes("GBK"),"ISO-8859-1"));
				}
			}
			
			//��ȡ�ļ�
			//client.retrieveFile(new String(storename.getBytes("GBK"),"ISO-8859-1"), os);
			//InputStream is = client.retrieveFileStream(new String(storename.getBytes("GBK"),"ISO-8859-1"));
			/*int replyCode = client.getReplyCode();
			if(replyCode==550){
				return null;
			}else{
				return client.retrieveFileStream(new String(storename.getBytes("GBK"),"ISO-8859-1"));
			}*/
			return client.retrieveFileStream(new String(storename.getBytes("GBK"),"ISO-8859-1"));
		} catch (Exception e) {
			logger.error("--��FTP���ظ��������쳣--",e);
			throw new Exception("�ļ����ط�������");
		}
	}
	public static FTPClient getFtpConnect() throws Exception{
		//����ftp
		FTPClient client = new FTPClient();
		//�ж�ϵͳ����
		FTPClientConfig conf = new FTPClientConfig(FTPClientConfig.SYST_UNIX);
		conf.setServerLanguageCode("zh");
		client.configure(conf);
		//�������
		ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
		InputStream inputStream = classLoader.getResourceAsStream("ftp.properties");
		Properties prop = new Properties();
		prop.load(inputStream);
		
		/*for test
		 * ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
		InputStream inputStream = classLoader.getResourceAsStream("sysPropConf.properties");
		Properties prop = new Properties();
		prop.load(inputStream);*/
		
		
		String ftpUrl = prop.getProperty("ftpUrl");
		int ftpProt = Integer.parseInt(prop.getProperty("ftpProt"));
		String ftpUser = prop.getProperty("ftpUser");
		String ftpPasswd = prop.getProperty("ftpPasswd");
		//����ftp
		client.connect(ftpUrl, ftpProt);
		//��½ftp
		client.login(ftpUser, ftpPasswd);
		//��֤ftp
		boolean flag = FtpUtil.validFTPServer(client);
		if(flag){
			//ʹ�ñ�������ģʽ
			client.enterLocalPassiveMode();
			//���ö������ļ���������
			client.setFileType(FTP.BINARY_FILE_TYPE);
			//����3Сʱ��ʱ
			client.setSoTimeout(10800000);
			//������������
			client.setControlEncoding("GBK");
			//�Ż�
			client.setBufferSize(100000);
			//�ı乤��Ŀ¼��epgoms
			String filePath = prop.getProperty("filePath");
			//����Ƕ�㣬�����з֣�һ��һ��Ľ���
			if(StringUtils.contains(filePath, "/")){
				String[] paths = StringUtils.split(filePath,"/");
				for (String p : paths) {
					//����Ŀ¼
					client.makeDirectory(new String(p.getBytes("GBK"),"ISO-8859-1"));
					//ת������Ŀ¼
					client.changeWorkingDirectory(new String(p.getBytes("GBK"),"ISO-8859-1"));
				}
			}else{
				//����Ŀ¼
				client.makeDirectory(new String(filePath.getBytes("GBK"),"ISO-8859-1"));
				//ת������Ŀ¼
				client.changeWorkingDirectory(new String(filePath.getBytes("GBK"),"ISO-8859-1"));
			}
			logger.info("��½FTP�����������˿ںţ�"+client.getLocalPort());
			return client;
		}else{
			throw new Exception("���ܷ���FTP Server");
		}
	}
	
	/**
	 * �ϴ��ļ���FTP
	 * @param filename ԭʼ�ļ�����
	 * @param data �ļ��Ķ�������������
	 * @param oilname ��������
	 * @param projectname ��Ŀ����
	 * @param extname �ļ���չ��
	 * @return �ϴ��ɹ��������ļ����֣��ϴ�ʧ�ܷ���null
	 * @throws Exception
	 */
	public static Map<String,String> uploadFile(String filename,InputStream data) throws Exception {
		
		//����ֵ
		Map<String,String> rest = new HashMap<String,String>();
		
		//���������Ϣ
		FTPClient client = FtpUtil.getFtpConnect();
		logger.info("��ʼ����FTP�ϴ��������ϴ���"+filename);
		try {
			
			//�洢�ļ�
			//boolean flag = client.storeFile(new String(newFileName.getBytes("GBK"),"ISO-8859-1"), bais);
			OutputStream os = client.storeFileStream(new String(filename.getBytes("GBK"),"ISO-8859-1"));
			byte buf[] = new byte[8192];
		    int bytesRead = data.read(buf);
		    Float filesize = 0f + bytesRead;
		    while (bytesRead != -1) {
		    	os.write(buf, 0, bytesRead);
		    	bytesRead = data.read(buf);
		    	filesize = filesize + bytesRead;
		    }
		    data.close();
		    os.close();
		    rest.put("filename", filename);
		    
			logger.info("��������FTP�ϴ��������ϴ�������"+filename);
			//����
			return rest;
		} catch (Exception e) {
			logger.info("--FTP�ļ��ϴ�������������--");
			throw new Exception("�ļ��ϴ���������",e);
		} finally {
			if(data!=null){
				data.close();
			}
			client.logout();
		}
	}
	
	private static boolean validFTPServer(FTPClient cl) throws IOException{
		int resp = cl.getReplyCode();
		if (!FTPReply.isPositiveCompletion(resp)) {
			cl.disconnect();  
            return false;  
        }else{
        	return true;
        }
	}
	
	/**
	 * ��������ĸ����ļ���
	 * @return 23λ�ļ���
	 */
	public static String generateFileName(){
		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH)+1;
		int day = cal.get(Calendar.DAY_OF_MONTH);
		int hour = cal.get(Calendar.HOUR_OF_DAY);
		int minu = cal.get(Calendar.MINUTE);
		int second = cal.get(Calendar.SECOND);
		int mill = cal.get(Calendar.MILLISECOND);
		int randomint = (int)Math.round((Math.random()*900+100)*1000);
		StringBuilder sb = new StringBuilder();
		sb.append(year);
		if(month<10){
			sb.append(0).append(month);
		}else{
			sb.append(month);
		}
		if(day<10){
			sb.append(0).append(day);
		}else{
			sb.append(day);
		}
		if(hour<10){
			sb.append(0).append(hour);
		}else{
			sb.append(hour);
		}
		if(minu<10){
			sb.append(0).append(minu);
		}else{
			sb.append(minu);
		}
		if(second<10){
			sb.append(0).append(second);
		}else{
			sb.append(second);
		}
		if(mill<10){
			sb.append(0).append(0).append(mill);
		}else if(mill<100){
			sb.append(0).append(mill);
		}else{
			sb.append(mill);
		}
		sb.append(randomint);
		return sb.toString();
	}
	
	public static void main(String[] args) {
		try {
			String s = "˾����/�������/����";
			StringUtils.split(s,"/");
			s.split("/");
			FTPClient cl = FtpUtil.getFtpConnect();
			
			FTPFile[] fl = cl.listDirectories();
			for (FTPFile ftpFile : fl) {
				System.out.println(ftpFile.getName());
			}
			boolean l = cl.makeDirectory("qqqq\\kk");
			System.out.println("=========="+l);
			cl.storeUniqueFile(new String("����������˳��.doc".getBytes("GBK"),"ISO-8859-1"), new FileInputStream(new File("d:/1.doc")));
			cl.logout();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			System.out.println("Over");
		}
	}
}
