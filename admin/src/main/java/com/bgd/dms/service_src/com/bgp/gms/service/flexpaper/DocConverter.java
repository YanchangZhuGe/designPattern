package com.bgp.gms.service.flexpaper;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.ConnectException;

import oracle.stellent.ridc.IdcContext;
import oracle.stellent.ridc.model.DataBinder;
import oracle.stellent.ridc.protocol.ServiceResponse;

import org.artofsolving.jodconverter.OfficeDocumentConverter;
import org.artofsolving.jodconverter.office.DefaultOfficeManagerConfiguration;
import org.artofsolving.jodconverter.office.OfficeManager;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.web.common.listener.ApplicationInitListener;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;

/**
 * @Title: DocConverterPDF.java
 * @Package com.bgp.gms.service.flexpaper
 * @Description: 文档转换成pdf文件
 * @author wuhj
 * @date 2013-12-31 上午9:33:08
 * @version V1.0
 */
public class DocConverter
{
	private static ILog log = LogFactory.getLogger(DocConverter.class);

	private static DocConverter docConverter = new DocConverter();
	
	private static String OPEN_OFFICE_LINUX = "/opt/openoffice.org3";
	
	private static String OPEN_OFFICE_WINDOW = "C:\\Program Files (x86)\\OpenOffice.org 3\\";

	// 获取配置的文件路径
	public static String pdfFilePath = null;

	private static MyUcm myUcm = new MyUcm();

	public static DocConverter getInit()
	{
		if (pdfFilePath == null)
		{
			pdfFilePath = ApplicationInitListener.APP_PATH + "SWFTools";
		}
		return docConverter;
	}

	private void DocConverter()
	{

	}

	/**
	 * 
	 * @Title: downloadFileForUCM
	 * @Description: 从UCM上获取文件到应用系统服务器上
	 * @param @param ucmId
	 * @param @param userID
	 * @param @param fileName
	 * @param @return
	 * @param @throws Exception 设定文件
	 * @return boolean 返回类型
	 * @throws
	 */
	public boolean downloadFileForUCM(String ucmId, String userID,
			String fileName) throws Exception
	{
		// 连接UCM服务器
		DataBinder dataBinder = myUcm.getIdcClient().createBinder();
		// 设置UCM的操作方式
		dataBinder.putLocal("IdcService", "GET_FILE");
		// 传文件在UCM的ID
		dataBinder.putLocal("dID", ucmId);
		// 获取UCM的上下文
		IdcContext idcContext = myUcm.getIdcContext();
		// 获取UCM的响应
		ServiceResponse response = myUcm.getIdcClient().sendRequest(idcContext,
				dataBinder);

		int reportedSize = Integer.parseInt(response
				.getHeader("Content-Length"));

		log.info("reportedSize=" + reportedSize);
		// 大于2M的文件，不处理
		if (reportedSize > 2100000)
		{
			return false;
		}

		InputStream ins = response.getResponseStream();

		// 创建用户的文件路径
		String pdfDir = getFilePath(userID);

		File outFile = new File(pdfDir + File.separator + fileName);

		FileOutputStream fouts = new FileOutputStream(outFile);
		// 设置读取字节大小
		byte by[] = new byte[66666];
		// 一次读取长度
		int len = 0;

		while ((len = ins.read(by, 0, by.length)) > 0)
		{
			fouts.write(by, 0, len);
		}
		ins.close();
		fouts.close();

		return true;
	}

	/**
	 * 
	 * @Title: getFilePath
	 * @Description: 创建文件路径
	 * @param @param userID
	 * @param @return
	 * @param @throws IOException 设定文件
	 * @return String 返回类型
	 * @throws
	 */
	private String getFilePath(String userID)
	{

		String pdfDir = pdfFilePath + File.separator + userID;
		System.out.println("pdfDir============"+pdfDir);

		File pdfFileDir = new File(pdfDir);

		// 判断文件路径是否存在
		if (!pdfFileDir.exists())
		{
			// 创建文件路径
			pdfFileDir.mkdirs();
		}

		return pdfDir;
	}
	/**
	 * 
	* @Title: getOpenOfficeHome
	* @Description: 获取操作系统路径，目前只支持window与linux
	* @param @return    设定文件
	* @return String    返回类型
	* @throws
	 */
	private String getOpenOfficeHome(){
		// 获取操作系统的类型
		String opsys = System.getProperty("os.name");
		if (opsys.toLowerCase().indexOf("window") != -1)
		{
			return OPEN_OFFICE_WINDOW;
		} else {
			return OPEN_OFFICE_LINUX;
		}
	}

	/**
	 * @throws IOException
	 * 
	 * @Title: docToPDF
	 * @Description: 把文档转换成pdf文档
	 * @param @param userID
	 * @param @param fileName
	 * @param @throws IOException 设定文件
	 * @return void 返回类型
	 * @throws
	 */
	public String docToPDF(String userID, String fileName)
	{
		// 创建用户的文件路径
		String pdfDir = getFilePath(userID);
		//如何是pdf不用处理
		if(fileName.indexOf("pdf") != -1){
			
			return pdfDir + File.separator + fileName;
		}
		
		DefaultOfficeManagerConfiguration config = new DefaultOfficeManagerConfiguration();
		String officeHome = getOpenOfficeHome(); 
		
		config.setOfficeHome(officeHome);  
		OfficeManager officeManager = config.buildOfficeManager();   
		OfficeDocumentConverter converter = new OfficeDocumentConverter(officeManager);  
		officeManager.start(); 
		 
//		// 获取文件名
		String fileN = fileName.substring(0, fileName.lastIndexOf("."));
 
		String outputFilePath = pdfDir + File.separator + fileN + ".pdf";  
		File inputFile = new File(pdfDir + File.separator + fileName);  
		
		if (inputFile.exists()) {// 找不到源文件, 则返回  
		       File outputFile = new File(outputFilePath);  
		       if (!outputFile.getParentFile().exists()) { // 假如目标路径不存在, 则新建该路径  
		           outputFile.getParentFile().mkdirs();  
		       }  
		       converter.convert(inputFile, outputFile);  
		   }  
		 
		officeManager.stop();  
		return pdfDir + File.separator + fileN + ".pdf";

	}

	/**
	 * 
	* @Title: processChinaName
	* @Description: 把中文转换成字母
	* @param @param name
	* @param @return    设定文件
	* @return String    返回类型
	* @throws
	 */
	private String processChinaName(String name){
		byte[] b = name.getBytes();
		String str = "";
		for (int  i = 0; i < b.length; i++)
		{
			Integer I = new Integer(b[i]);
			String strTmp = I.toHexString(b[i]);
			if (strTmp.length() > 2)
				strTmp = strTmp.substring(strTmp.length() - 2);
			str = str + strTmp;
		}
		return str;
	}
	/**
	 * @throws UnsupportedEncodingException 
	 * 
	 * @Title: pdfToSWF
	 * @Description: pdf文件转换成swf
	 * @param @param fileName
	 * @param @return
	 * @param @throws IOException 设定文件
	 * @return String 返回类型 文件路径
	 * @throws
	 */
	public String pdfToSWF(String filePath) throws UnsupportedEncodingException 
	{
		Runtime r = Runtime.getRuntime();
		
		// 获取操作系统的类型
		String opsys = System.getProperty("os.name");

		StringBuffer cmdSB = new StringBuffer(" ");
		// 判断pdf文件是否存在
		File pdfFile = new File(filePath);

		String path = pdfFile.getParent();
		String name = pdfFile.getName();
		// 截取文件名，去掉扩展名
		String subName = name.substring(0, name.lastIndexOf("."));
		
		//处理中文名
		subName = processChinaName(subName);
		
		
		
		if (pdfFile.exists())
		{
			if (opsys.toLowerCase().indexOf("window") != -1)
			{
				cmdSB.append(pdfFilePath + File.separator + "pdf2swf.exe  ");
			} else
			{
				cmdSB.append("/usr/local/swftools/bin/pdf2swf  ");
			}
			cmdSB.append( filePath + "  -o  " + path +File.separator+ subName + ".swf" + "  -T 9 ");

			log.info("cmdSB========"+cmdSB);
			try
			{
				Process p = r.exec(cmdSB.toString());
		
				DataInputStream sb = new DataInputStream(p.getInputStream());
				String line = null;
				while((line=sb.readLine()) !=null){
					log.info(line);
					if(line.indexOf("10days_10000words.swf")!=-1){
						log.info("pdf转换成swf成功!");
					}
				}
			} catch (IOException e)
			{
				log.info("pdf转换成swf失败!");
				e.printStackTrace();
			}

		}
		
//		// pdf转换成swf后，删除
//		if (pdfFile.exists())
//			pdfFile.delete();
		//判断swf文件是否存在
		File swfF = new File(path +File.separator+ subName + ".swf");
		if(!swfF.exists()){
			return null;
		}

		return swfF.getName();

	}

	// private String

	public static void main(String[] args)
	{

	}

}
