package com.bgp.mcs.service.common.excelIE.srv;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.common.excelIE.util.ExcelDataInteractive;
import com.bgp.mcs.service.common.excelIE.util.ExcelEIResolvingUtil;
import com.bgp.mcs.service.common.excelIE.util.ExcelEIXmlOperTools;
import com.bgp.mcs.service.common.excelIE.util.ExcelExceptionHandler;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * ���⣺������������˾��̽��������ϵͳ
 * 
 * ��˾: �������
 * 
 * ���ߣ����챪
 *       
 * ����������֧��ƽ̨ͨ��excel���뵼������
 */

@SuppressWarnings({ "rawtypes", "unchecked" })
public class TsExcelExportImportSrv extends BaseService {

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IJdbcDao queryJdbcDao = BeanFactory.getQueryJdbcDAO();
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();

	/*
	 * ����excel��querySql��ѯ���ݣ�����������excel����ʽչ�ָ��û�
	 * 
	 * fileName �������ļ��� fileContent �������ļ����ݵ������� modelName xml�����õ�model id
	 */
	public ISrvMsg exportExcelData(ISrvMsg reqDTO) throws Exception {

		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);

		String modelName = reqDTO.getValue("modelName");
		if (modelName != null && !"".equals(modelName)) {
			String fileName = "excel.xls";
			String fileContent = "";

			List<Map> columnList = null;
			String sql = "";
			Map map = ExcelEIXmlOperTools.getExportXmlData(modelName);
			columnList = (List<Map>) map.get("columnList");
			fileName = (String) map.get("fileName");
			fileContent = (String) map.get("fileTitle");
			sql = (String) map.get("sql");
			List resultList = queryJdbcDao.queryRecords(sql);
			Workbook wb = ExcelEIResolvingUtil.EERU.getWorkbookByXmlAndData(columnList, fileContent, resultList);
			WSFile wsfile = new WSFile();
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			wb.write(os);
			wsfile.setFileData(os.toByteArray());
			wsfile.setFilename(fileName);
			os.close();
			mqmsgimpl.setFile(wsfile);
			
		}
		return mqmsgimpl;
	}

	/*
	 * ����excel����ģ�壬��ϵͳ����ʹ��
	 * 
	 * fileName �������ļ��� fileContent �������ļ����ݵ������� modelName xml�����õ�model id
	 */
	public ISrvMsg exportExcelTemplate(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);

		String modelName = reqDTO.getValue("modelName");
		if (modelName != null && !"".equals(modelName)) {
			String fileName = "excel.xls";
			String fileContent = "";
			List<Map> columnList = null;

			Map map = ExcelEIXmlOperTools.getExportTemplateXmlData(modelName);
			columnList = (List<Map>) map.get("columnList");
			fileName = (String) map.get("fileName");
			fileContent = (String) map.get("fileTitle");
			Workbook wb = ExcelEIResolvingUtil.EERU.getWorkbookByXml(columnList, fileContent);
			WSFile wsfile = new WSFile();
			ByteArrayOutputStream os = new ByteArrayOutputStream();
			wb.write(os);
			wsfile.setFileData(os.toByteArray());
			wsfile.setFilename(fileName);
			os.close();
			mqmsgimpl.setFile(wsfile);
		}
		return mqmsgimpl;
	}

	/*
	 * ��excelģ���е����ݵ��뵽ϵͳ��
	 * 
	 * fileName �������ļ��� fileContent �������ļ����ݵ������� modelName xml�����õ�model id
	 */
	public ISrvMsg importExcelTemplate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String redirectURL = reqDTO.getValue("redirectUrl");
		String modelName = reqDTO.getValue("modelName");
		if (modelName != null && !"".equals(modelName)) {
			MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
			String errorMessage = null;
			List<WSFile> files = mqMsg.getFiles();
			List<Map> columnList = new ArrayList<Map>();
			String sql = "";
			Map map = ExcelEIXmlOperTools.getImportXmlData(modelName);
			columnList = (List<Map>) map.get("columnList");
			sql = (String) map.get("sql");
			List dataList = new ArrayList();
			if (files != null && !files.isEmpty()) {
				for (int i = 0; i < files.size(); i++) {
					WSFile file = files.get(i);
					try{
						Map mapUserInfo=new HashMap();
						mapUserInfo.put("userId", user.getUserId());
						mapUserInfo.put("userName", user.getUserName());
						mapUserInfo.put("orgId", user.getOrgId());
						mapUserInfo.put("orgSubjectionId", user.getOrgSubjectionId());
						mapUserInfo.put("codeAffordOrgID", user.getCodeAffordOrgID());
						mapUserInfo.put("subOrgIDofAffordOrg", user.getSubOrgIDofAffordOrg());
						
						mapUserInfo.put("projectInfoNo", user.getProjectInfoNo());
					dataList = ExcelEIResolvingUtil.EERU.getExcelDataByWSFile(file, columnList,mapUserInfo);
					}catch(ExcelExceptionHandler ex){
						ex.printStackTrace();
						errorMessage=ex.getMessage();
						responseDTO.setValue("errorMessage", errorMessage);
						return responseDTO;
					}
				}
			}
			jdbcTemplate.batchUpdate(sql, ExcelDataInteractive.getFormatSetterObject(dataList));
			responseDTO.setValue("errorMessage", errorMessage);
		}
		responseDTO.setValue("redirectUrl", redirectURL);
		return responseDTO;
	}

}