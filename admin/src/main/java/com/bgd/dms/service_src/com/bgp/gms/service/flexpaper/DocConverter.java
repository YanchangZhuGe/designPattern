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
 * @Description: �ĵ�ת����pdf�ļ�
 * @author wuhj
 * @date 2013-12-31 ����9:33:08
 * @version V1.0
 */
public class DocConverter
{
	private static ILog log = LogFactory.getLogger(DocConverter.class);

	private static DocConverter docConverter = new DocConverter();
	
	private static String OPEN_OFFICE_LINUX = "/opt/openoffice.org3";
	
	private static String OPEN_OFFICE_WINDOW = "C:\\Program Files (x86)\\OpenOffice.org 3\\";

	// ��ȡ���õ��ļ�·��
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
	 * @Description: ��UCM�ϻ�ȡ�ļ���Ӧ��ϵͳ��������
	 * @param @param ucmId
	 * @param @param userID
	 * @param @param fileName
	 * @param @return
	 * @param @throws Exception �趨�ļ�
	 * @return boolean ��������
	 * @throws
	 */
	public boolean downloadFileForUCM(String ucmId, String userID,
			String fileName) throws Exception
	{
		// ����UCM������
		DataBinder dataBinder = myUcm.getIdcClient().createBinder();
		// ����UCM�Ĳ�����ʽ
		dataBinder.putLocal("IdcService", "GET_FILE");
		// ���ļ���UCM��ID
		dataBinder.putLocal("dID", ucmId);
		// ��ȡUCM��������
		IdcContext idcContext = myUcm.getIdcContext();
		// ��ȡUCM����Ӧ
		ServiceResponse response = myUcm.getIdcClient().sendRequest(idcContext,
				dataBinder);

		int reportedSize = Integer.parseInt(response
				.getHeader("Content-Length"));

		log.info("reportedSize=" + reportedSize);
		// ����2M���ļ���������
		if (reportedSize > 2100000)
		{
			return false;
		}

		InputStream ins = response.getResponseStream();

		// �����û����ļ�·��
		String pdfDir = getFilePath(userID);

		File outFile = new File(pdfDir + File.separator + fileName);

		FileOutputStream fouts = new FileOutputStream(outFile);
		// ���ö�ȡ�ֽڴ�С
		byte by[] = new byte[66666];
		// һ�ζ�ȡ����
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
	 * @Description: �����ļ�·��
	 * @param @param userID
	 * @param @return
	 * @param @throws IOException �趨�ļ�
	 * @return String ��������
	 * @throws
	 */
	private String getFilePath(String userID)
	{

		String pdfDir = pdfFilePath + File.separator + userID;
		System.out.println("pdfDir============"+pdfDir);

		File pdfFileDir = new File(pdfDir);

		// �ж��ļ�·���Ƿ����
		if (!pdfFileDir.exists())
		{
			// �����ļ�·��
			pdfFileDir.mkdirs();
		}

		return pdfDir;
	}
	/**
	 * 
	* @Title: getOpenOfficeHome
	* @Description: ��ȡ����ϵͳ·����Ŀǰֻ֧��window��linux
	* @param @return    �趨�ļ�
	* @return String    ��������
	* @throws
	 */
	private String getOpenOfficeHome(){
		// ��ȡ����ϵͳ������
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
	 * @Description: ���ĵ�ת����pdf�ĵ�
	 * @param @param userID
	 * @param @param fileName
	 * @param @throws IOException �趨�ļ�
	 * @return void ��������
	 * @throws
	 */
	public String docToPDF(String userID, String fileName)
	{
		// �����û����ļ�·��
		String pdfDir = getFilePath(userID);
		//�����pdf���ô���
		if(fileName.indexOf("pdf") != -1){
			
			return pdfDir + File.separator + fileName;
		}
		
		DefaultOfficeManagerConfiguration config = new DefaultOfficeManagerConfiguration();
		String officeHome = getOpenOfficeHome(); 
		
		config.setOfficeHome(officeHome);  
		OfficeManager officeManager = config.buildOfficeManager();   
		OfficeDocumentConverter converter = new OfficeDocumentConverter(officeManager);  
		officeManager.start(); 
		 
//		// ��ȡ�ļ���
		String fileN = fileName.substring(0, fileName.lastIndexOf("."));
 
		String outputFilePath = pdfDir + File.separator + fileN + ".pdf";  
		File inputFile = new File(pdfDir + File.separator + fileName);  
		
		if (inputFile.exists()) {// �Ҳ���Դ�ļ�, �򷵻�  
		       File outputFile = new File(outputFilePath);  
		       if (!outputFile.getParentFile().exists()) { // ����Ŀ��·��������, ���½���·��  
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
	* @Description: ������ת������ĸ
	* @param @param name
	* @param @return    �趨�ļ�
	* @return String    ��������
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
	 * @Description: pdf�ļ�ת����swf
	 * @param @param fileName
	 * @param @return
	 * @param @throws IOException �趨�ļ�
	 * @return String �������� �ļ�·��
	 * @throws
	 */
	public String pdfToSWF(String filePath) throws UnsupportedEncodingException 
	{
		Runtime r = Runtime.getRuntime();
		
		// ��ȡ����ϵͳ������
		String opsys = System.getProperty("os.name");

		StringBuffer cmdSB = new StringBuffer(" ");
		// �ж�pdf�ļ��Ƿ����
		File pdfFile = new File(filePath);

		String path = pdfFile.getParent();
		String name = pdfFile.getName();
		// ��ȡ�ļ�����ȥ����չ��
		String subName = name.substring(0, name.lastIndexOf("."));
		
		//����������
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
						log.info("pdfת����swf�ɹ�!");
					}
				}
			} catch (IOException e)
			{
				log.info("pdfת����swfʧ��!");
				e.printStackTrace();
			}

		}
		
//		// pdfת����swf��ɾ��
//		if (pdfFile.exists())
//			pdfFile.delete();
		//�ж�swf�ļ��Ƿ����
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
