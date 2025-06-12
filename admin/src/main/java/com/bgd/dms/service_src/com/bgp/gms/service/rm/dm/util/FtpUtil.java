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
 * 作者： 李永峰
 * 创建日期 ：2013-6-27
 * 功能说明：ftp服务器工具
 * 修改记录：
 */
public class FtpUtil {
	static Logger logger = LoggerFactory.getLogger(FtpUtil.class);
	
	/**
	 * 根据路径和名称获得ftp上文件的流
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
					//改变工作目录
					client.changeWorkingDirectory(new String(d.getBytes("GBK"),"ISO-8859-1"));
				}
			}
			
			//获取文件
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
			logger.error("--从FTP下载附件发生异常--",e);
			throw new Exception("文件下载发生错误");
		}
	}
	public static FTPClient getFtpConnect() throws Exception{
		//创建ftp
		FTPClient client = new FTPClient();
		//判断系统语言
		FTPClientConfig conf = new FTPClientConfig(FTPClientConfig.SYST_UNIX);
		conf.setServerLanguageCode("zh");
		client.configure(conf);
		//获得属性
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
		//连接ftp
		client.connect(ftpUrl, ftpProt);
		//登陆ftp
		client.login(ftpUser, ftpPasswd);
		//验证ftp
		boolean flag = FtpUtil.validFTPServer(client);
		if(flag){
			//使用被动传输模式
			client.enterLocalPassiveMode();
			//设置二进制文件传输类型
			client.setFileType(FTP.BINARY_FILE_TYPE);
			//设置3小时超时
			client.setSoTimeout(10800000);
			//处理中文问题
			client.setControlEncoding("GBK");
			//优化
			client.setBufferSize(100000);
			//改变工作目录到epgoms
			String filePath = prop.getProperty("filePath");
			//如果是多层，进行切分，一层一层的进入
			if(StringUtils.contains(filePath, "/")){
				String[] paths = StringUtils.split(filePath,"/");
				for (String p : paths) {
					//创建目录
					client.makeDirectory(new String(p.getBytes("GBK"),"ISO-8859-1"));
					//转到工作目录
					client.changeWorkingDirectory(new String(p.getBytes("GBK"),"ISO-8859-1"));
				}
			}else{
				//创建目录
				client.makeDirectory(new String(filePath.getBytes("GBK"),"ISO-8859-1"));
				//转到工作目录
				client.changeWorkingDirectory(new String(filePath.getBytes("GBK"),"ISO-8859-1"));
			}
			logger.info("登陆FTP结束，本机端口号："+client.getLocalPort());
			return client;
		}else{
			throw new Exception("不能访问FTP Server");
		}
	}
	
	/**
	 * 上传文件到FTP
	 * @param filename 原始文件名字
	 * @param data 文件的二进制数据数组
	 * @param oilname 油田名称
	 * @param projectname 项目名称
	 * @param extname 文件扩展名
	 * @return 上传成功返回新文件名字，上传失败返回null
	 * @throws Exception
	 */
	public static Map<String,String> uploadFile(String filename,InputStream data) throws Exception {
		
		//返回值
		Map<String,String> rest = new HashMap<String,String>();
		
		//获得配置信息
		FTPClient client = FtpUtil.getFtpConnect();
		logger.info("开始调用FTP上传方法，上传："+filename);
		try {
			
			//存储文件
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
		    
			logger.info("结束调用FTP上传方法，上传结束："+filename);
			//返回
			return rest;
		} catch (Exception e) {
			logger.info("--FTP文件上传方法发生错误--");
			throw new Exception("文件上传发生错误",e);
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
	 * 产生随机的附件文件名
	 * @return 23位文件名
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
			String s = "司法岛/随碟附送/试试";
			StringUtils.split(s,"/");
			s.split("/");
			FTPClient cl = FtpUtil.getFtpConnect();
			
			FTPFile[] fl = cl.listDirectories();
			for (FTPFile ftpFile : fl) {
				System.out.println(ftpFile.getName());
			}
			boolean l = cl.makeDirectory("qqqq\\kk");
			System.out.println("=========="+l);
			cl.storeUniqueFile(new String("撒范德萨发顺丰.doc".getBytes("GBK"),"ISO-8859-1"), new FileInputStream(new File("d:/1.doc")));
			cl.logout();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			System.out.println("Over");
		}
	}
}
