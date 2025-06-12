package com.bgp.mcs.service.ws.pm.service.dailyReport;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import javax.xml.soap.SOAPException;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.Region;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.op.srv.OPCostSrv;
import com.bgp.mcs.service.common.DateOperation;
import com.bgp.mcs.service.pm.service.common.P6TypeConvert;
import com.bgp.mcs.service.pm.service.p6.resource.resourceAssignment.workload.WorkloadMCSBean;
import com.bgp.mcs.service.pm.service.project.DailyReportProcessRatePOJO;
import com.bgp.mcs.service.pm.service.project.ProjectMCSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
public class WsDailyReportSrv extends BaseService {

	private ILog log;
	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	private RADJdbcDao radDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao")).getJdbcTemplate();
	public WsDailyReportSrv() {
		log = LogFactory.getLogger(WsDailyReportSrv.class);
	}

	java.text.DecimalFormat df_1 = new java.text.DecimalFormat("#.000");

	public ISrvMsg queryDailyReport(ISrvMsg reqDTO) throws Exception {

		String org_subjection_id = (String) reqDTO.getValue("orgSubjectionId");

		String project_name = (String) reqDTO.getValue("projectName");

		 
		String[] projectNames = project_name.split("");// 分解成单字符

		project_name = "%";

		for (int i = 0; i < projectNames.length; i++) {
			project_name += projectNames[i] + "%";
		}

		String org_name = (String) reqDTO.getValue("orgName");
 
		String[] orgNames = org_name.split("");

		org_name = "%";

		for (int i = 0; i < orgNames.length; i++) {
			org_name += orgNames[i] + "%";
		}

		String audit_status = (String) reqDTO.getValue("auditStatus");

		String project_status = (String) reqDTO.getValue("projectStatus");

		String project_type = (String) reqDTO.getValue("projectType");

		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String sql = "select * from (select row_number() over (partition  by r.project_info_no order by r.produce_date desc) as row_num,r.*,gp.project_name,oi.org_abbreviation as org_name,r.org_id as report_org_id,gp.project_type as gp_project_type,gp.exploration_method as gp_exploration_method,gp.project_start_time as gp_start_time,gp.project_end_time as gp_end_time "
				+ " from gp_ops_daily_report_ws r "
				+ " join gp_task_project gp on gp.project_info_no = r.project_info_no and gp.project_name like '"
				+ project_name
				+ "' and gp.bsflag = '0' and gp.project_status like '%"
				+ project_status
				+ "%' and project_type like '%"
				+ project_type
				+ "%' "
				+ " join comm_org_information oi on oi.org_id = r.org_id and oi.org_name like '"
				+ org_name
				+ "' and oi.bsflag = '0' "
				+ " where r.bsflag = '0' and r.org_subjection_id like '"
				+ org_subjection_id
				+ "%' "
				+ " and r.audit_status !='0' and r.audit_status like '%"
				+ audit_status + "%' " + " ) where row_num = 1 ";

		// Map map = jdbcDao.queryRecordBySQL(sql);

		page = radDao.queryRecordsBySQL(sql, page);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);

		return msg;

	}
	public static boolean isMergedRegion(Sheet sheet , int row , int column){
		//获取合并单元格的数量
		int sheetMergeCount = sheet.getNumMergedRegions();
			for(int i = 0 ; i < sheetMergeCount ; i++ ){
				CellRangeAddress ca = sheet.getMergedRegion(i);
				int firstColumn = ca.getFirstColumn();
				int lastColumn = ca.getLastColumn();
				int firstRow = ca.getFirstRow();
				int lastRow = ca.getLastRow();
				if(row >= firstRow && row <= lastRow){//存在合并单元格
					if(column >= firstColumn && column <= lastColumn){
						return true ;
					}
				}
			}
			return false ;
	}
	
	public static Map getMergedRegionValue(Sheet sheet ,int row , int column){
		Map<String,Object> result= new HashMap<String,Object>();
		int sheetMergeCount = sheet.getNumMergedRegions();
				
		if(isMergedRegion( sheet ,row ,  column)){
			for(int i = 0 ; i < sheetMergeCount ; i++){
				CellRangeAddress ca = sheet.getMergedRegion(i);
				int firstColumn = ca.getFirstColumn();
				int lastColumn = ca.getLastColumn();
				int firstRow = ca.getFirstRow();
				int lastRow = ca.getLastRow();
				if(row >= firstRow && row <= lastRow){	
					if(column >= firstColumn && column <= lastColumn){
						int number=lastRow-firstRow+1;
						String logo=""+firstRow+"~"+lastRow+"~"+firstColumn+"~"+lastColumn;
						Row fRow = sheet.getRow(firstRow);
						Cell fCell =fRow.getCell(firstColumn)==null?fRow.createCell(firstColumn):fRow.getCell(firstColumn);

						//Cell fCell = fRow.getCell(firstColumn);
						fCell.setCellType(1);
						result.put("fCell", fCell);
						result.put("logo", logo);
						result.put("number", ""+number);					
					}
				}
			}			
		}else{
			

				Row fRow = sheet.getRow(row);
				//Cell fCell = fRow.getCell(column);
				Cell fCell =fRow.getCell(column)==null?fRow.createCell(column):fRow.getCell(column);
				fCell.setCellType(1);
				result.put("fCell", fCell);
				result.put("logo", "0");
				result.put("number", "");
		}
		return result ;
	}
	/**
	 * 导出井中周报
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg exportReportWs(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = user.getProjectInfoNo();
		String projectName = user.getProjectName();

		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../pm/comm/exportReportWs.xls"));
		Sheet sheet = wb.getSheetAt(0);
		String getReportList="select * from BGP_WS_DAILY_REPORT where PROJECT_INFO_NO='"+projectInfoNo+"' and BSFLAG='0' order by SEQNO ";
		List<Map> list = radDao.queryRecords(getReportList);
		
		HSSFCellStyle cellStyle = (HSSFCellStyle) wb.createCellStyle(); 

		cellStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN); //下边框    
		cellStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);//左边框    
		cellStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);//上边框    
		cellStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);//右边框 
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER_SELECTION); // 居中  

		
		Row rowTitle = sheet.getRow(0);
		Cell cellTitle = rowTitle.createCell(0);
		cellTitle.setCellValue(projectName);
		cellTitle.setCellStyle(cellStyle);
		
		Map<String,String> seqnoMap = new HashMap<String, String>();
		Map<String,String> seqnoMap2 = new HashMap<String, String>();
		String isExcle="";
		 for(int i=3;i<list.size()+3;i++){
			Row row = sheet.getRow(i);
			Map map = list.get(i-3);
			String seqno = (String)map.get("seqno");
			String view_type_code = (String)map.get("view_type_code");

			if(seqno!=null&&!"".equals(seqno)){
				int gg = seqno.length();
				if(seqno.length()>=4){
					isExcle="0";
					if(seqnoMap.get("k_"+seqno)==null){
						seqnoMap.put("k_"+seqno, i+"_"+seqno);						
					}					
				}else{
					isExcle="1";
					if(seqnoMap2.get("k_"+view_type_code+"_"+seqno)==null){
						seqnoMap2.put("k_"+view_type_code+"_"+seqno, ""+i+"_"+"0");						
					}else{
						String jg = seqnoMap2.get("k_"+view_type_code+"_"+seqno);
						String first = jg.split("_")[0];
						String ca = jg.split("_")[1];
						seqnoMap2.put("k_"+view_type_code+"_"+seqno, first+"_"+(Integer.parseInt(ca)+1));												
					}
				}

			}
			
			
			//获取初始行，获取结束行，
			String org_name = (String)map.get("org_name");
			Cell cell = row.createCell(0);
			cell.setCellValue(org_name);	
			cell.setCellStyle(cellStyle);
			
			String basin = (String)map.get("basin");
			cell = row.createCell(1);
			cell.setCellValue(basin);	
			cell.setCellStyle(cellStyle);
			
			String well_number = (String)map.get("well_number");
			cell = row.createCell(2);
			cell.setCellValue(well_number);	
			cell.setCellStyle(cellStyle);
			
			String coding_name = (String)map.get("coding_name");
			cell = row.createCell(3);
			cell.setCellValue(coding_name);	
			cell.setCellStyle(cellStyle);
			
			String contracts_signed = (String)map.get("contracts_signed");
			cell = row.createCell(4);
			cell.setCellValue(contracts_signed);
			cell.setCellStyle(cellStyle);
			
			String project_income = (String)map.get("project_income");
			cell = row.createCell(5);
			cell.setCellStyle(cellStyle);
			cell.setCellValue(project_income);	
			
			String complete_value = (String)map.get("complete_value");
			cell = row.createCell(6);
			cell.setCellValue(complete_value);		
			cell.setCellStyle(cellStyle);
			
			String view_type = (String)map.get("view_type");
			cell = row.createCell(7);
			cell.setCellValue(view_type);	
			cell.setCellStyle(cellStyle);

			String view_well = (String)map.get("view_well");
			String view_point = (String)map.get("view_point");
			String acquire_level = (String)map.get("acquire_level");
			
			String build_method = (String)map.get("build_method");
			cell = row.createCell(10);
			cell.setCellValue(build_method);				
			cell.setCellStyle(cellStyle);
			
			if(!"微地震地面监测".equals(view_type)||!"随钻地震".equals(view_type)){
				cell = row.createCell(8);
				cell.setCellValue(view_well);
				cell.setCellStyle(cellStyle);

				cell = row.createCell(9);
				cell.setCellValue(view_point);
				cell.setCellStyle(cellStyle);

				cell = row.createCell(11);
				cell.setCellValue(acquire_level);
				cell.setCellStyle(cellStyle);

				cell = row.createCell(12);
				cell.setCellValue("");
				cell.setCellStyle(cellStyle);

				cell = row.createCell(13);
				cell.setCellValue("");
				cell.setCellStyle(cellStyle);

				cell = row.createCell(14);
				cell.setCellValue("");	
				cell.setCellStyle(cellStyle);

			}else{
				cell = row.createCell(8);
				cell.setCellValue("");
				cell.setCellStyle(cellStyle);

				cell = row.createCell(9);
				cell.setCellValue("");
				cell.setCellStyle(cellStyle);

				cell = row.createCell(11);
				cell.setCellValue("");
				cell.setCellStyle(cellStyle);

				cell = row.createCell(12);
				cell.setCellValue(view_well);
				cell.setCellStyle(cellStyle);
				
				cell = row.createCell(13);
				cell.setCellValue(view_point);
				cell.setCellStyle(cellStyle);

				cell = row.createCell(14);
				cell.setCellValue(acquire_level);	
				cell.setCellStyle(cellStyle);

			}
		
			String shot_number = (String)map.get("shot_number");
			cell = row.createCell(15);
			cell.setCellValue(shot_number);	
			cell.setCellStyle(cellStyle);
			
			String test_record = (String)map.get("test_record");
			cell = row.createCell(16);
			cell.setCellValue(test_record);	
			cell.setCellStyle(cellStyle);
			
			String obs_point = (String)map.get("obs_point");
			cell = row.createCell(17);
			cell.setCellValue(obs_point);	
			cell.setCellStyle(cellStyle);
			
			String quality_opints = (String)map.get("quality_opints");
			cell = row.createCell(18);
			cell.setCellValue(quality_opints);	
			cell.setCellStyle(cellStyle);
			
			String quality_rate = (String)map.get("quality_rate");
			cell = row.createCell(19);
			cell.setCellValue(quality_rate);	
			cell.setCellStyle(cellStyle);
			
			String pass_point = (String)map.get("pass_point");
			cell = row.createCell(20);
			cell.setCellValue(pass_point);	
			cell.setCellStyle(cellStyle);
			
			String pass_rate = (String)map.get("pass_rate");
			cell = row.createCell(21);
			cell.setCellValue(pass_rate);
			cell.setCellStyle(cellStyle);
			
			String waste_point = (String)map.get("waste_point");
			cell = row.createCell(22);
			cell.setCellValue(waste_point);	
			cell.setCellStyle(cellStyle);
			
			String waste_rate = (String)map.get("waste_rate");
			cell = row.createCell(23);
			cell.setCellValue(waste_rate);	
			cell.setCellStyle(cellStyle);
					
			String ref_points = (String)map.get("ref_points");
			cell = row.createCell(24);
			cell.setCellValue(ref_points);	
			cell.setCellStyle(cellStyle);
	
			String mic_logging = (String)map.get("mic_logging");
			cell = row.createCell(25);
			cell.setCellValue(mic_logging);	
			cell.setCellStyle(cellStyle);
			
			String start_date = (String)map.get("start_date");
			cell = row.createCell(26);
			cell.setCellValue(start_date);	
			cell.setCellStyle(cellStyle);
			
			String end_date = (String)map.get("end_date");
			cell = row.createCell(27);
			cell.setCellValue(end_date);
			cell.setCellStyle(cellStyle);
			
			String project_status = (String)map.get("project_status");
			cell = row.createCell(28);
			cell.setCellValue(project_status);
			cell.setCellStyle(cellStyle);
			
			String handle_explain_status = (String)map.get("handle_explain_status");
			cell = row.createCell(29);
			cell.setCellValue(handle_explain_status);
			cell.setCellStyle(cellStyle);
			
			String pass_date = (String)map.get("pass_date");
			cell = row.createCell(30);
			cell.setCellValue(pass_date);	
			cell.setCellStyle(cellStyle);
			
			String remarks = (String)map.get("remarks");
			cell = row.createCell(31);
			cell.setCellValue(remarks);
			cell.setCellStyle(cellStyle);

		 }	
			CellRangeAddress  region0 = new CellRangeAddress(3,(short)list.size()+2, 0,(short)0); 
			CellRangeAddress  region1 = new CellRangeAddress(3,(short)list.size()+2, 1,(short)1); 
			CellRangeAddress  region2 = new CellRangeAddress(3,(short)list.size()+2, 2,(short)2); 
			CellRangeAddress  region3 = new CellRangeAddress(3,(short)list.size()+2, 3,(short)3); 
			CellRangeAddress  region4 = new CellRangeAddress(3,(short)list.size()+2, 4,(short)4); 
			CellRangeAddress  region5 = new CellRangeAddress(3,(short)list.size()+2, 5,(short)5); 
			CellRangeAddress  region6 = new CellRangeAddress(3,(short)list.size()+2, 6,(short)6); 
			
			CellRangeAddress  region26 = new CellRangeAddress(3,(short)list.size()+2, 26,(short)26); 
			CellRangeAddress  region27 = new CellRangeAddress(3,(short)list.size()+2, 27,(short)27); 
			CellRangeAddress  region28 = new CellRangeAddress(3,(short)list.size()+2, 28,(short)28); 
			CellRangeAddress  region29 = new CellRangeAddress(3,(short)list.size()+2, 29,(short)29); 
			CellRangeAddress  region30 = new CellRangeAddress(3,(short)list.size()+2, 30,(short)30); 
			CellRangeAddress  region31 = new CellRangeAddress(3,(short)list.size()+2, 31,(short)31); 


			sheet.addMergedRegion(region0);
			sheet.addMergedRegion(region1);
			sheet.addMergedRegion(region2);
			sheet.addMergedRegion(region3);
			sheet.addMergedRegion(region4);
			sheet.addMergedRegion(region5);
			sheet.addMergedRegion(region6);
			
			sheet.addMergedRegion(region26);
			sheet.addMergedRegion(region27);
			sheet.addMergedRegion(region28);
			sheet.addMergedRegion(region29);
			sheet.addMergedRegion(region30);
			sheet.addMergedRegion(region31);
			
		 if(isExcle=="0"){
			 Set<String> key = seqnoMap.keySet();
		     for (Iterator<String> it = key.iterator(); it.hasNext();) {
		            String s = (String) it.next();
		            String sStrs = seqnoMap.get(s);
		            int firstRow = Integer.parseInt(sStrs.split("_")[0]);
		            String biaozhi = sStrs.split("_")[1];
		            String a = biaozhi.split("~")[0];
		            String b = biaozhi.split("~")[1];
		            int lastRow = Integer.parseInt(b)-Integer.parseInt(a)+firstRow;
		    		CellRangeAddress  region7 = new CellRangeAddress(firstRow,(short)lastRow, 7,(short)7); 
		    		sheet.addMergedRegion(region7);
		     }			 
		 }else if(isExcle=="1"){
			 Set<String> key = seqnoMap2.keySet();
		     for (Iterator<String> it = key.iterator(); it.hasNext();) {
		            String s = (String) it.next();
		            String sStrs = seqnoMap2.get(s);
		            String firstRow = sStrs.split("_")[0];
		            String ca = sStrs.split("_")[1];
		            int lastRow=Integer.parseInt(firstRow)+Integer.parseInt(ca);
		    		CellRangeAddress  region7 = new CellRangeAddress(Integer.parseInt(firstRow),(short)lastRow, 7,(short)7); 
		    		sheet.addMergedRegion(region7);

		     }
			 
		 }

	     

	     

		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename(projectName+"_井中项目报表.xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;

	}

/**
 * 井中周报导入
 * @param reqDTO
 * @return
 * @throws Exception
 */
	public ISrvMsg importReportWs(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String project_info_no = user.getProjectInfoNo();
		String deleteSql = " delete  BGP_WS_DAILY_REPORT where PROJECT_INFO_NO='"+project_info_no+"'";
		radDao.executeUpdate(deleteSql);
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> files = mqMsg.getFiles();
		if (files != null && files.size() > 0) {
			WSFile file = files.get(0);
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = new HSSFWorkbook(is);
			Sheet sheet = book.getSheetAt(0);
			int dd = sheet.getPhysicalNumberOfRows();
			for (int i = 3; i < sheet.getPhysicalNumberOfRows(); i++) {
				Row row = sheet.getRow(i);
				Map<String, Object> map = new HashMap<String, Object>();
				//施工队伍
				Map resultMap=getMergedRegionValue(sheet ,i , 0);
				Cell cell = (Cell) resultMap.get("fCell");
				String ORG_NAME = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				if("".equals(ORG_NAME)){
					responseDTO.setValue("message", "导入成功!");
					return responseDTO; 
				}
				map.put("org_name", ORG_NAME);
				//盆地
				resultMap=getMergedRegionValue(sheet ,i , 1);
				cell = (Cell) resultMap.get("fCell");
				String BASIN = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("basin", BASIN);
				//施工井号
				resultMap=getMergedRegionValue(sheet ,i , 2);
				cell = (Cell) resultMap.get("fCell");
				String WELL_NUMBER = cell.getStringCellValue()==null?"":cell.getStringCellValue();	
				map.put("well_number", WELL_NUMBER);
				//甲方单位
				resultMap=getMergedRegionValue(sheet ,i , 3);
				cell = (Cell) resultMap.get("fCell");
				String CODING_NAME = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("coding_name", CODING_NAME);
				//已签到合同
				resultMap=getMergedRegionValue(sheet ,i , 4);
				cell = (Cell) resultMap.get("fCell");
				String CONTRACTS_SIGNED = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("contracts_signed", CONTRACTS_SIGNED);
				//预计价值工作量
				resultMap=getMergedRegionValue(sheet ,i , 5);
				cell = (Cell) resultMap.get("fCell");
				String PROJECT_INCOME = cell.getStringCellValue()==null?"":cell.getStringCellValue();	
				map.put("project_income", PROJECT_INCOME);
				//完成价值工作量
				resultMap=getMergedRegionValue(sheet ,i , 6);
				cell = (Cell) resultMap.get("fCell");
				String COMPLETE_VALUE = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("complete_value", COMPLETE_VALUE);
				//观测方式
				resultMap=getMergedRegionValue(sheet ,i , 7);
				cell = (Cell) resultMap.get("fCell");
				String number = (String) resultMap.get("number");
				String logo = (String) resultMap.get("logo");
				String VIEW_TYPE = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("view_type", VIEW_TYPE);
				map.put("seqno", logo);
				//观测井段
				resultMap=getMergedRegionValue(sheet ,i , 8);
				cell = (Cell) resultMap.get("fCell");
				String VIEW_WELL = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				
				//观测点距
				resultMap=getMergedRegionValue(sheet ,i , 9);
				cell = (Cell) resultMap.get("fCell");
				String VIEW_POINT = cell.getStringCellValue()==null?"":cell.getStringCellValue();	

				//激发方式
				resultMap=getMergedRegionValue(sheet ,i , 10);
				cell = (Cell) resultMap.get("fCell");
				String BUILD_METHOD = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("build_method", BUILD_METHOD);
				
				//采集级数
				resultMap=getMergedRegionValue(sheet ,i , 11);
				cell = (Cell) resultMap.get("fCell");
				String ACQUIRE_LEVEL = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				//接受线数 
				resultMap=getMergedRegionValue(sheet ,i , 12);
				cell = (Cell) resultMap.get("fCell");
				String AS_VIEW_WELL = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				//道距
				resultMap=getMergedRegionValue(sheet ,i , 13);
				cell = (Cell) resultMap.get("fCell");
				String AS_VIEW_POINT = cell.getStringCellValue()==null?"":cell.getStringCellValue();				
				//总道数
				resultMap=getMergedRegionValue(sheet ,i , 14);
				cell = (Cell) resultMap.get("fCell");
				String AS_ACQUIRE_LEVEL = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				
				
				if(!"微地震地面监测".equals(VIEW_TYPE)||!"随钻地震".equals(VIEW_TYPE)){
					map.put("view_well", VIEW_WELL);
					map.put("view_point", VIEW_POINT);
					map.put("acquire_level", ACQUIRE_LEVEL);
				}else{
					map.put("view_well", AS_VIEW_WELL);
					map.put("view_point", AS_VIEW_POINT);
					map.put("acquire_level", AS_ACQUIRE_LEVEL);
				}

				//炮数
				resultMap=getMergedRegionValue(sheet ,i , 15);
				cell = (Cell) resultMap.get("fCell");
				String SHOT_NUMBER = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("shot_number", SHOT_NUMBER);

				//合格试验记录
				resultMap=getMergedRegionValue(sheet ,i , 16);
				cell = (Cell) resultMap.get("fCell");
				String TEST_RECORD = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("test_record", TEST_RECORD);

				//总观测点数
				resultMap=getMergedRegionValue(sheet ,i , 17);
				cell = (Cell) resultMap.get("fCell");
				String OBS_POINT = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("obs_point", OBS_POINT);

				//优级品点数
				resultMap=getMergedRegionValue(sheet ,i , 18);
				cell = (Cell) resultMap.get("fCell");
				String QUALITY_POINTS = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("quality_opints", QUALITY_POINTS);

				//优级品率
				resultMap=getMergedRegionValue(sheet ,i , 19);
				cell = (Cell) resultMap.get("fCell");
				String QUALITY_RATE = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("quality_rate", QUALITY_RATE);

				//合格品点数
				resultMap=getMergedRegionValue(sheet ,i , 20);
				cell = (Cell) resultMap.get("fCell");
				String PASS_POINT = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("pass_point", PASS_POINT);

				//合格品率
				resultMap=getMergedRegionValue(sheet ,i , 21);
				cell = (Cell) resultMap.get("fCell");
				String PASS_RATE = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("pass_rate", PASS_RATE);

				//废品点数
				resultMap=getMergedRegionValue(sheet ,i , 22);
				cell = (Cell) resultMap.get("fCell");
				String WASTE_POINT = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("waste_point", WASTE_POINT);

				//废品率
				resultMap=getMergedRegionValue(sheet ,i , 23);
				cell = (Cell) resultMap.get("fCell");
				String WASTE_RATE = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("waste_rate",WASTE_RATE);

				//小折射点数
				resultMap=getMergedRegionValue(sheet ,i , 24);
				cell = (Cell) resultMap.get("fCell");
				String REF_POINTS = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("ref_points", REF_POINTS);

				//微测井
				resultMap=getMergedRegionValue(sheet ,i , 25);
				cell = (Cell) resultMap.get("fCell");
				String MIC_LOGGING = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("mic_logging", MIC_LOGGING);

				//开工时间
				resultMap=getMergedRegionValue(sheet ,i , 26);
				cell = (Cell) resultMap.get("fCell");
				String START_DATE = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("start_date", START_DATE);

				//完工时间
				resultMap=getMergedRegionValue(sheet ,i , 27);
				cell = (Cell) resultMap.get("fCell");
				String END_DATE = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("end_date", END_DATE);

				//运行状态
				resultMap=getMergedRegionValue(sheet ,i , 28);
				cell = (Cell) resultMap.get("fCell");
				String PROJECT_STATUS = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("project_status", PROJECT_STATUS);

				//处理、解释状态
				resultMap=getMergedRegionValue(sheet ,i , 29);
				cell = (Cell) resultMap.get("fCell");
				String HANDLE_EXPLAIN_STATUS = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("handle_explain_status",HANDLE_EXPLAIN_STATUS );

				//甲方验收日期
				resultMap=getMergedRegionValue(sheet ,i , 30);
				cell = (Cell) resultMap.get("fCell");
				String PASS_DATE = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("pass_date", PASS_DATE);

				//备注
				resultMap=getMergedRegionValue(sheet ,i , 31);
				cell = (Cell) resultMap.get("fCell");
				String REMARKS = cell.getStringCellValue()==null?"":cell.getStringCellValue();
				map.put("remarks", REMARKS);
				String daily_id = UUID.randomUUID().toString().replaceAll("-", "");

			
				if("零偏横波VSP".equals(VIEW_TYPE)){
					map.put("view_type_code", "5110000053000000000");
				}else if("零偏纵波VSP".equals(VIEW_TYPE)){
					map.put("view_type_code", "5110000053000000001");					
				}else if("非零偏VSP".equals(VIEW_TYPE)){
					map.put("view_type_code", "5110000053000000002");
				}else if("Walkaway-VSP".equals(VIEW_TYPE)){
					map.put("view_type_code", "5110000053000000003");					
				}else if("Walkaround-VSP".equals(VIEW_TYPE)){
					map.put("view_type_code", "5110000053000000004");	
				}else if("微地震井中监测".equals(VIEW_TYPE)){
					map.put("view_type_code", "5110000053000000005");	
				}else if("微地震地面监测".equals(VIEW_TYPE)){
					map.put("view_type_code", "5110000053000000006");	
				}else if("随钻地震".equals(VIEW_TYPE)){
					map.put("view_type_code", "5110000053000000007");	
				}else if("井间地震".equals(VIEW_TYPE)){
					map.put("view_type_code", "5110000053000000008");	
				}else if("井地联合勘探".equals(VIEW_TYPE)){
					map.put("view_type_code", "5110000053000000009");	
				}else{
					map.put("view_type_code", "5110000053000000010");	
				}
			//	map.put("daily_id",daily_id);
				map.put("bsflag", "0");
				map.put("project_info_no", project_info_no);
				map.put("audit_status", "1");
								
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"BGP_WS_DAILY_REPORT");
				
			}
			
		}
		responseDTO.setValue("message", "导入成功!");
		return responseDTO;
	}	
	public ISrvMsg getAuditInfo(ISrvMsg reqDTO) throws Exception {

		String daily_no = reqDTO.getValue("dailyNo");

 
		String sql = "select r.*,h.employee_name,adm.*  from gp_ops_daily_report_ws r"
				+ " left join gp_adm_data_examine adm on r.daily_no_ws = adm.data_no and adm.bsflag = '0' "
 
	 
 
				+ " left join comm_human_employee h on h.employee_id = r.ratifier and h.bsflag = '0' "
				+ " where daily_no_ws = '" + daily_no + "' ";

		Map map = jdbcDao.queryRecordBySQL(sql);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		msg.setValue("auditMap", map);

		return msg;
	}

	@Deprecated
	public Map getDailyReport(Map map) {

		String dailyNo = (String) map.get("dailyNo");
		String daily_no_ws=(String) map.get("daily_no_ws");
		String daily_no=(String) map.get("dailyNoWs");
		String projectInfoNo = (String) map.get("projectInfoNo");
		String produceDate = (String) map.get("produceDate");

		if (dailyNo == null || "".equals(dailyNo)) {
			dailyNo = (String) map.get("daily_no");
		}
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map.get("produce_date");
		}

		String sql = "";

		if (produceDate != null && !"".equals(produceDate)
				&& produceDate != "null" && !"null".equals(produceDate)) {
			sql = "select * from gp_ops_daily_report_ws r left join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no_ws and sit.bsflag = '0' "
					+ " join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = r.project_info_no and (dy.exploration_method is null or dy.exploration_method = r.exploration_method) "
					+ " where r.project_info_no = '"
					+ projectInfoNo
					+ "'  and r.bsflag = '0' and produce_date = to_date('"
					+ produceDate + "','yyyy-MM-dd') ";
		} else {
			sql = "select * from gp_ops_daily_report_ws r left join gp_ops_daily_produce_sit sit on sit.daily_no = r.daily_no_ws and sit.bsflag = '0' "
					+ " join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = r.project_info_no and (dy.exploration_method is null or dy.exploration_method = r.exploration_method) "
					+ " where r.daily_no = '"
					+ dailyNo
					+ "'  and r.bsflag = '0' ";
		}

		Map dailyReport = jdbcDao.queryRecordBySQL(sql);

		sql = "select sum(nvl(r.daily_survey_shot_num,0)) as project_survey_shot_num "
				+ ",sum(nvl(r.daily_survey_geophone_num,0)) as project_survey_geophone_num "
				+ ",sum(nvl(r.survey_incept_workload,0)) as project_survey_incept_workload "
				+ ",sum(nvl(r.survey_shot_workload,0)) as project_survey_shot_workload "
				+ ",sum(nvl(r.daily_micro_measue_point_num,0)) as project_micro_measue_num"
				+ ",sum(nvl(r.daily_small_refraction_num,0)) as project_small_refraction_num"
				+ ",sum(nvl(r.daily_drill_sp_num,0)) as project_drill_sp_num"
				+ ",sum(nvl(r.daily_drill_well_num,0)) as project_drill_well_num"
				+ ",sum(nvl(r.daily_drill_footage_num,0)) as project_drill_footage_num"
				+ ",sum(nvl(r.daily_acquire_sp_num,0)+nvl(r.daily_jp_acquire_shot_num,0)+nvl(r.daily_qq_acquire_shot_num,0)) as project_acquire_sp_num"
				+ ",sum(nvl(r.daily_acquire_workload,0)+nvl(r.daily_jp_acquire_workload,0)+nvl(r.daily_qq_acquire_workload,0)) as project_acquire_workload"
				+ ",sum(nvl(r.daily_acquire_qualified_num,0)) as project_qualified_sp_num"
				+ ",sum(nvl(r.daily_acquire_firstlevel_num,0)) as project_firstlevel_sp_num"
				+ ",sum(nvl(r.collect_2_class,0)) as project_collect_2_class"
				+ ",sum(nvl(r.collect_waster_num,0)) as project_collect_waster_num"
				+ ",sum(nvl(r.collect_miss_num,0)) as project_collect_miss_num"
				+ ",sum(nvl(r.daily_test_sp_num,0)) as project_test_sp_num"
				+ ",sum(nvl(r.daily_test_qualified_sp_num,0)) as project_qualified_test_sp_num"
				+ " from gp_ops_daily_report r where project_info_no = '"
				+ projectInfoNo + "' ";

		if (produceDate != null && !"".equals(produceDate)
				&& produceDate != "null" && !"null".equals(produceDate)) {
			sql += " and produce_date <= to_date('" + produceDate
					+ "','yyyy-MM-dd') ";
		}

		Map map1 = jdbcDao.queryRecordBySQL(sql);

		try {
			dailyReport.putAll(map1);
		} catch (NullPointerException e) {
			// map为空
			dailyReport = map1;
			dailyReport.put("produceDate", produceDate);
		}

		DecimalFormat df = new DecimalFormat();
		String style = "0.00%";

		df.applyPattern(style);

		// 测量日完成总点
		if (dailyReport.get("dailySurveyShotNum") == null
				|| "".equals(dailyReport.get("dailySurveyShotNum"))) {
			dailyReport.put("dailySurveyShotNum", "0");
		}
		if (dailyReport.get("dailySurveyGeophoneNum") == null
				|| "".equals(dailyReport.get("dailySurveyGeophoneNum"))) {
			dailyReport.put("dailySurveyGeophoneNum", "0");
		}
		dailyReport
				.put("dailySurveyTotalNum",
						P6TypeConvert.convertLong(dailyReport
								.get("dailySurveyShotNum"))
								+ P6TypeConvert.convertLong(dailyReport
										.get("dailySurveyGeophoneNum")));

		// 各种比率
		double designNum = 0.0;
		double actualNum = 0.0;

		// 测量完成
		if (dailyReport.get("designSpNum") == null
				|| "".equals(dailyReport.get("designSpNum"))) {
			dailyReport.put("designSpNum", "0");
		}
		if (dailyReport.get("designGeophoneNum") == null
				|| "".equals(dailyReport.get("designGeophoneNum"))) {
			dailyReport.put("designGeophoneNum", "0");
		}
		if (dailyReport.get("projectSurveyShotNum") == null
				|| "".equals(dailyReport.get("projectSurveyShotNum"))) {
			dailyReport.put("projectSurveyShotNum", "0");
		}
		if (dailyReport.get("projectSurveyGeophoneNum") == null
				|| "".equals(dailyReport.get("projectSurveyGeophoneNum"))) {
			dailyReport.put("projectSurveyGeophoneNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport.get("designSpNum"))
				+ P6TypeConvert.convertDouble(dailyReport
						.get("designGeophoneNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectSurveyRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectSurveyShotNum"))
					+ P6TypeConvert.convertDouble(dailyReport
							.get("projectSurveyGeophoneNum"));
			dailyReport.put("projectSurveyRatio",
					df.format((actualNum / designNum)));
		}

		// 钻井炮点
		if (dailyReport.get("designDrillNum") == null
				|| "".equals(dailyReport.get("designDrillNum"))) {
			dailyReport.put("designDrillNum", "0");
		}
		if (dailyReport.get("projectDrillSpNum") == null
				|| "".equals(dailyReport.get("projectDrillSpNum"))) {
			dailyReport.put("projectDrillSpNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport
				.get("designDrillNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectDrillSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectDrillSpNum"));
			dailyReport.put("projectDrillSpRatio",
					df.format((actualNum / designNum)));
		}

		// 钻井 检波点
		if (dailyReport.get("designGeophoneNum") == null
				|| "".equals(dailyReport.get("designGeophoneNum"))) {
			dailyReport.put("designGeophoneNum", "0");
		}
		if (dailyReport.get("projectSurveyGeophoneNum") == null
				|| "".equals(dailyReport.get("projectSurveyGeophoneNum"))) {
			dailyReport.put("projectSurveyGeophoneNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport
				.get("designGeophoneNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectSurveyRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectSurveyGeophoneNum"));
			dailyReport.put("projectSurveyRatio",
					df.format((actualNum / designNum)));
		}

		// 采集 炮点
		if (dailyReport.get("designSpNum") == null
				|| "".equals(dailyReport.get("designSpNum"))) {
			dailyReport.put("designSpNum", "0");
		}
		if (dailyReport.get("projectAcquireSpNum") == null
				|| "".equals(dailyReport.get("projectAcquireSpNum"))) {
			dailyReport.put("projectAcquireSpNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport.get("designSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectAcquireSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectAcquireSpNum"));
			dailyReport.put("projectAcquireSpRatio",
					df.format((actualNum / designNum)));
		}

		// 采集 工作量
		if (dailyReport.get("fullFoldWorkload") == null
				|| "".equals(dailyReport.get("fullFoldWorkload"))) {
			dailyReport.put("fullFoldWorkload", "0");
		}
		if (dailyReport.get("projectAcquireWorkload") == null
				|| "".equals(dailyReport.get("projectAcquireWorkload"))) {
			dailyReport.put("projectAcquireWorkload", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport
				.get("fullFoldWorkload"));

		if (designNum == 0.0) {
			dailyReport.put("projectAcquireWorkRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectAcquireWorkload"));
			dailyReport.put("projectAcquireWorkRatio",
					df.format((actualNum / designNum)));
		}

		// 采集 合格炮
		if (dailyReport.get("projectAcquireSpNum") == null
				|| "".equals(dailyReport.get("projectAcquireSpNum"))) {
			dailyReport.put("projectAcquireSpNum", "0");
		}
		if (dailyReport.get("projectQualifiedSpNum") == null
				|| "".equals(dailyReport.get("projectQualifiedSpNum"))) {
			dailyReport.put("projectQualifiedSpNum", "0");
		}
		designNum = P6TypeConvert.convertDouble(dailyReport
				.get("projectAcquireSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectQualifiedSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectQualifiedSpNum"));
			dailyReport.put("projectQualifiedSpRatio",
					df.format((actualNum / designNum)));
		}

		// 采集 一级炮
		if (dailyReport.get("projectFirstlevelSpNum") == null
				|| "".equals(dailyReport.get("projectFirstlevelSpNum"))) {
			dailyReport.put("projectFirstlevelSpNum", "0");
		}
		// designNum =
		// P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectFirstlevelSpRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectFirstlevelSpNum"));
			dailyReport.put("projectFirstlevelSpRatio",
					df.format((actualNum / designNum)));
		}

		// 采集 二级炮
		if (dailyReport.get("projectCollect2Class") == null
				|| "".equals(dailyReport.get("projectCollect2Class"))) {
			dailyReport.put("projectCollect2Class", "0");
		}
		// designNum =
		// P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectCollect2ClassRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectCollect2Class"));
			dailyReport.put("projectCollect2ClassRatio",
					df.format((actualNum / designNum)));
		}

		// 采集 废炮
		if (dailyReport.get("projectCollectWasterNum") == null
				|| "".equals(dailyReport.get("projectCollectWasterNum"))) {
			dailyReport.put("projectCollectWasterNum", "0");
		}
		// designNum =
		// P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectCollectWasterNumRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectCollectWasterNum"));
			dailyReport.put("projectCollectWasterNumRatio",
					df.format((actualNum / designNum)));
		}

		// 采集 空炮
		if (dailyReport.get("projectCollectMissNum") == null
				|| "".equals(dailyReport.get("projectCollectMissNum"))) {
			dailyReport.put("projectCollectMissNum", "0");
		}
		// designNum =
		// P6TypeConvert.convertDouble(dailyReport.get("projectAcquireSpNum"));

		if (designNum == 0.0) {
			dailyReport.put("projectCollectMissNumRatio", "-");
		} else {
			actualNum = P6TypeConvert.convertDouble(dailyReport
					.get("projectCollectMissNum"));
			dailyReport.put("projectCollectMissNumRatio",
					df.format((actualNum / designNum)));
		}

		return dailyReport;
	}

	public ISrvMsg getDailyReportInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);// ????????
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String produceDate = (String) reqDTO.getValue("produceDate");
		String daily_no=reqDTO.getValue("dailyNo");
		// Map temp = reqDTO.toMap();


		Map map1 = new HashMap();
		map1.put("produceDate", produceDate);

		map1.put("projectInfoNo", projectInfoNo);

		Map map2 = new HashMap();
		map2.put("produceDate", produceDate);

		map2.put("projectInfoNo", projectInfoNo);

		Map map = new HashMap();
		map.put("produceDate", produceDate);

		map.put("projectInfoNo", projectInfoNo);
		Map map3 = new HashMap();
		map3.put("daily_no", daily_no);

	 
		Map dailyProject = getDailyProject(map1);
		Map build = getDailyReportNew(map);
		Map sumDaily = getDailySum(map2);
        Map dailySit=getDailySit(map3);
		msg.setValue("build", build);
		msg.setValue("dailyProject", dailyProject);
		msg.setValue("sumDaily", sumDaily);
		
		msg.setValue("dailySit", dailySit);
		return msg;
	}

	private Map getDailySum(Map map2) {
		// TODO Auto-generated method stub

		String projectInfoNo = (String) map2.get("projectInfoNo");
		String produceDate = (String) map2.get("produceDate");
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map2.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map2.get("produce_date");
		}

		String sql = "select (select sum(r.daily_survey_point_num_ws) over(partition by r.audit_status order by r.produce_date) aaa"+
                      "    from gp_ops_daily_report_ws r    where r.project_info_no = '"+projectInfoNo+"'"+
                        "   and r.audit_status = '3'   and r.bsflag = '0'   and r.produce_date = t.produce_date) sum_ce,"+
                        "(select sum(daily_acquire_qualified_num) over(partition by r.audit_status order by r.produce_date) ada"+
                      "    from gp_ops_daily_report_ws r    where r.project_info_no = '"+projectInfoNo+"'"+
                        "   and r.audit_status = '3'   and r.bsflag = '0'   and r.produce_date = t.produce_date) sum_right_ce,"+
                      " (select sum(r.daily_acquire_sp_num) over(partition by r.audit_status order by r.produce_date) bbb"+
                       "   from gp_ops_daily_report_ws r where r.project_info_no =   '"+projectInfoNo+"'"+
                       "    and r.audit_status = '3'   and r.bsflag = '0'  and r.produce_date = t.produce_date) daily_acquire_cj,"+
                       "(select sum(r.daily_surface_point_num) over(partition by r.audit_status order by r.produce_date) ccc"+
                        "  from gp_ops_daily_report_ws r  where r.project_info_no =   '"+projectInfoNo+"'  and r.audit_status = '3'"+
                        "   and r.bsflag = '0'  and r.produce_date = t.produce_date) daily_surface_bc,"+
                        "(select sum(r.daily_test_sp_num) over(partition by r.audit_status order by r.produce_date) ddd"+
                        "  from gp_ops_daily_report_ws r  where r.project_info_no =   '"+projectInfoNo+"'"+
                         "  and r.audit_status = '3'  and r.bsflag = '0'     and r.produce_date = t.produce_date) daily_test_sy,"+
                     "(select sum(r.daily_drill_sp_num) over(partition by r.audit_status order by r.produce_date) eee"+
                       "   from gp_ops_daily_report_ws r   where r.project_info_no =  '"+projectInfoNo+"'"+
                        "   and r.audit_status = '3'  and r.bsflag = '0'    and r.produce_date = t.produce_date) daily_drill_zj,"+
                      " t.produce_date,  t.audit_status   from gp_ops_daily_report_ws t   where t.project_info_no = '"+projectInfoNo+"'"+
                " group by t.produce_date, audit_status ";

		Map dailyNum = new HashMap();
		dailyNum = jdbcDao.queryRecordBySQL(sql);

		return dailyNum;
	}

	private Map getDailyProject(Map map1) {
		// TODO Auto-generated method stub

		String projectInfoNo = (String) map1.get("projectInfoNo");
		String produceDate = (String) map1.get("produceDate");

		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map1.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map1.get("produce_date");
		}

		String sql = "select * from gp_task_project_dynamic where bsflag='0' and project_info_no='"
				+ projectInfoNo + "'";

		Map dailyProject = new HashMap();
		dailyProject = jdbcDao.queryRecordBySQL(sql);

		return dailyProject;

	}
	
	private Map getDailySit(Map map3) {
		// TODO Auto-generated method stub

		 
		String dailyNo = (String) map3.get("daily_no");
		if (dailyNo == null || "".equals(dailyNo)) {
			dailyNo = (String) map3.get("dailyNo");
		}
	 

		String sql = "select * from gp_ops_daily_produce_sit t where t.daily_no='"
				+ dailyNo + "'";

		Map dailySit = new HashMap();
		dailySit = jdbcDao.queryRecordBySQL(sql);

		return dailySit;

	}


	public Map getDailyReportNew(Map map) {


		String projectInfoNo = (String) map.get("projectInfoNo");
		String produceDate = (String) map.get("produceDate");
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map.get("produce_date");
		}

		String sql = "select * from gp_ops_daily_report_ws where project_info_no='"
			+ projectInfoNo +"' and bsflag='0' and produce_date = to_date('"+produceDate+"','yyyy-MM-dd')";

		Map build = new HashMap();
		build = jdbcDao.queryRecordBySQL(sql);

		return build;
	}

public Map getDailyReportBy(Map map) {
		
		String projectInfoNo = (String) map.get("projectInfoNo");
		String produceDate = (String) map.get("produceDate");

		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = (String) map.get("project_info_no");
		}
		if (produceDate == null || "".equals(produceDate)) {
			produceDate = (String) map.get("produce_date");
		}

		String sql = "select * from gp_ops_daily_report_ws where project_info_no='"
				+ projectInfoNo +"' and bsflag='0' and  produce_date = to_date('"+produceDate+"','yyyy-MM-dd')";

		Map dailyReport = new HashMap();
		dailyReport = jdbcDao.queryRecordBySQL(sql);

		return dailyReport;
	}
	public Map getDailyReportProduceSit(Map map) {

		Object daily_no = map.get("dailyNo");
		Object project_info_no = map.get("projectInfoNo");
		Object produce_date = map.get("produceDate");
		Object difference = map.get("difference");

		if (difference == null || "".equals(difference)) {
			difference = "0";
		}

		String sql = null;

		if (produce_date != null && !"".equals(produce_date)
				&& produce_date != "null" && !"null".equals(produce_date)) {
			sql = "select sit.* from gp_ops_daily_produce_sit sit join gp_ops_daily_report r on r.daily_no = sit.daily_no and r.project_info_no = '"
					+ project_info_no
					+ "' and produce_date = to_date('"
					+ produce_date
					+ "','yyyy-MM-dd')-"
					+ difference
					+ " "
					+ " and r.bsflag = '0'  where sit.bsflag = '0' ";
		} else {
			sql = "select * from gp_ops_daily_produce_sit where bsflag = '0'  and daily_no = '"
					+ daily_no + "'";
		}

		Map report = jdbcDao.queryRecordBySQL(sql);
		return report;
	}

	public Map getNextDailyReportStatus(Map map) {

		Object daily_no = map.get("dailyNo");
		Object project_info_no = map.get("projectInfoNo");
		Object produce_date = map.get("produceDate");
		Object difference = map.get("difference");

		if (difference == null || "".equals(difference)) {
			difference = "0";
		}

		String sql = null;

		if (produce_date != null && !"".equals(produce_date)
				&& produce_date != "null" && !"null".equals(produce_date)) {
			sql = "select sit.* from gp_ops_daily_produce_sit sit join gp_ops_daily_report r on r.daily_no = sit.daily_no and r.project_info_no = '"
					+ project_info_no
					+ "' and produce_date = to_date('"
					+ produce_date
					+ "','yyyy-MM-dd')+"
					+ difference
					+ " "
					+ " and r.bsflag = '0'  where sit.bsflag = '0' ";
		} else {
			sql = "select * from gp_ops_daily_produce_sit where bsflag = '0'  and daily_no = '"
					+ daily_no + "'";
		}

		Map report = jdbcDao.queryRecordBySQL(sql);
		return report;
	}

	public ISrvMsg queryDailyReportList(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String multi_flag = reqDTO.getValue("multi") != null ? reqDTO
				.getValue("multi") : "";
		if ("1" == multi_flag || "1".equals(multi_flag)) {
			// 多项目的日报列表,项目编号从前台传,查询需要审批的数据
			String projectInfoNo = reqDTO.getValue("projectInfoNo") != null ? reqDTO
					.getValue("projectInfoNo") : "";

			if (projectInfoNo == null || "".equals(projectInfoNo)) {
				msg.setValue("totalRows", 0);
				return msg;
			}

			String currentPage = reqDTO.getValue("currentPage");
			if (currentPage == null || currentPage.trim().equals(""))
				currentPage = "1";
			String pageSize = reqDTO.getValue("pageSize");
			if (pageSize == null || pageSize.trim().equals("")) {
				ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
				pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
			}

			PageModel page = new PageModel();
			page.setCurrPage(Integer.parseInt(currentPage));
			page.setPageSize(Integer.parseInt(pageSize));

			String sql = "select nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0) as sp, "
					+ "(case t.audit_status when '3' then  sum(nvl(t.daily_acquire_sp_num, 0) +  nvl(t.daily_qq_acquire_shot_num, 0) +  nvl(t.daily_jp_acquire_shot_num, 0))  over(partition by t.project_info_no order by t.produce_date asc) - "
					+ "nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' "
					+ "and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) else  sum(nvl(t.daily_acquire_sp_num, 0) +  nvl(t.daily_qq_acquire_shot_num, 0) +  nvl(t.daily_jp_acquire_shot_num, 0)) "
					+ "over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r "
					+ "where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_sp, (case t.audit_status "
					+ "when '3' then round(case nvl(dy.design_sp_num, 0) when 0 then 0 else (sum(nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0)) "
					+ "over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r "
					+ "where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.design_sp_num * 100 end, 2) else round(case nvl(dy.design_sp_num, 0) when 0 then "
					+ "0 else (sum(nvl(t.daily_acquire_sp_num, 0) + nvl(t.daily_qq_acquire_shot_num, 0) + nvl(t.daily_jp_acquire_shot_num, 0)) over(partition by t.project_info_no order by  t.produce_date asc) - nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + "
					+ "nvl(r.daily_qq_acquire_shot_num, 0) + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no "
					+ "and r.produce_date <= t.produce_date),0)) / dy.design_sp_num * 100 end, 2) end) total_sp_radio, nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0) as survey, (case t.audit_status when '3' then sum(nvl(t.survey_incept_workload, 0) + "
					+ "nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r "
					+ "where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) else sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "
					+ "nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report_ws r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "
					+ "end) as total_survey, (case t.audit_status when '3' then round(case nvl(dy.measure_km, 0) when 0 then 0 else (sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "
					+ "nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report_ws r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.measure_km * 100 "
					+ "end, 2) else round(case nvl(dy.measure_km, 0) when 0 then 0 else (sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.survey_incept_workload, 0) + "
					+ "nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report_ws r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.measure_km * 100 end, 2) end) as total_survey_radio, "
					+ "nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0) as measue, (case t.audit_status when '3' then sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "
					+ "nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report_ws r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "
					+ "else sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) "
					+ "from gp_ops_daily_report_ws r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_measue, (case t.audit_status when '3' then round(case nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0) "
					+ "when 0 then 0 else (sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report_ws r "
					+ "where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / (nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0)) * 100 end, 2) else round(case nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0) "
					+ "when 0 then 0 else (sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report_ws r "
					+ "where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / (nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0)) * 100 end, 2) end) as total_measue_radio, nvl(t.daily_drill_sp_num, 0) as drill, "
					+ "(case t.audit_status when '3' then sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report_ws r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "
					+ "else sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report_ws r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_drill, "
					+ "(case t.audit_status when '3' then round(case nvl(dy.design_drill_num, 0) when 0 then 0 else (sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report_ws r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no "
					+ "and r.produce_date <= t.produce_date),0)) / dy.design_drill_num * 100 end, 2) else round(case nvl(dy.design_drill_num, 0) when 0 then 0 else (sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report_ws r where r.bsflag = '0' and r.audit_status <> '3' "
					+ "and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.design_drill_num * 100 end, 2) end) as total_drill_radio, "
					+ "t.produce_date, gp.project_name, gp.build_method, oi.org_abbreviation as org_name, t.audit_status, t.daily_no, t.project_info_no "
					+ "from gp_ops_daily_report t join gp_task_project gp on gp.project_info_no = t.project_info_no and gp.bsflag = '0'  and t.exploration_method = gp.exploration_method "
					+ " join comm_org_information oi on oi.org_id = t.org_id and oi.bsflag = '0' "
					+ " join gp_task_project_dynamic dy "
					+ " on dy.project_info_no = t.project_info_no "
					+ " and dy.exploration_method = t.exploration_method"
					+ " where t.bsflag = '0' and (t.audit_status = '1' or t.audit_status = '3') and t.project_info_no = '"
					+ projectInfoNo + "' order by produce_date desc";


			page = radDao.queryRecordsBySQL(sql, page);

			msg.setValue("datas", page.getData());
			msg.setValue("totalRows", page.getTotalRow());
			msg.setValue("pageSize", pageSize);

		} else {

			// 单项目的日报列表
		
			String projectInfoNo = user.getProjectInfoNo();
		
                                 
			if (projectInfoNo == null || "".equals(projectInfoNo)) {
				msg.setValue("totalRows", 0);
				return msg;
			}

			String currentPage = reqDTO.getValue("currentPage");
			if (currentPage == null || currentPage.trim().equals(""))
				currentPage = "1";
			String pageSize = reqDTO.getValue("pageSize");
			if (pageSize == null || pageSize.trim().equals("")) {
				ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
				pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
			}

			PageModel page = new PageModel();
			page.setCurrPage(Integer.parseInt(currentPage));
			page.setPageSize(Integer.parseInt(pageSize));

//			String sql = "select nvl(t.daily_acquire_sp_num, 0)    "
//					+ "(case t.audit_status when '3' then  sum(nvl(t.daily_acquire_sp_num, 0)   )  over(partition by t.project_info_no order by t.produce_date asc) - "
//					+ "nvl((select sum(nvl(r.daily_acquire_sp_num, 0)   ) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' "
//					+ "and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) else  sum(nvl(t.daily_acquire_sp_num, 0)  ) "
//					+ "over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_acquire_sp_num, 0) ) from gp_ops_daily_report r "
//					+ "where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_sp, (case t.audit_status "
//					+ "when '3' then round(case nvl(dy.design_sp_num, 0) when 0 then 0 else (sum(nvl(t.daily_acquire_sp_num, 0)   + nvl(t.daily_jp_acquire_shot_num, 0)) "
//					+ "over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_acquire_sp_num, 0)   + nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r "
//					+ "where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.design_sp_num * 100 end, 2) else round(case nvl(dy.design_sp_num, 0) when 0 then "
//					+ "0 else (sum(nvl(t.daily_acquire_sp_num, 0)   + nvl(t.daily_jp_acquire_shot_num, 0)) over(partition by t.project_info_no order by  t.produce_date asc) - nvl((select sum(nvl(r.daily_acquire_sp_num, 0) + "
//					+ " nvl(r.daily_jp_acquire_shot_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no "
//					+ "and r.produce_date <= t.produce_date),0)) / dy.design_sp_num * 100 end, 2) end) total_sp_radio, nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0) as survey, (case t.audit_status when '3' then sum(nvl(t.survey_incept_workload, 0) + "
//					+ "nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r "
//					+ "where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) else sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "
//					+ "nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "
//					+ "end) as total_survey, (case t.audit_status when '3' then round(case nvl(dy.measure_km, 0) when 0 then 0 else (sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "
//					+ "nvl((select sum(nvl(r.survey_incept_workload, 0) + nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.measure_km * 100 "
//					+ "end, 2) else round(case nvl(dy.measure_km, 0) when 0 then 0 else (sum(nvl(t.survey_incept_workload, 0) + nvl(t.survey_shot_workload, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.survey_incept_workload, 0) + "
//					+ "nvl(r.survey_shot_workload, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.measure_km * 100 end, 2) end) as total_survey_radio, "
//					+ "nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0) as measue, (case t.audit_status when '3' then sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - "
//					+ "nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "
//					+ "else sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) -nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) "
//					+ "from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_measue, (case t.audit_status when '3' then round(case nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0) "
//					+ "when 0 then 0 else (sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r "
//					+ "where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / (nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0)) * 100 end, 2) else round(case nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0) "
//					+ "when 0 then 0 else (sum(nvl(t.daily_micro_measue_point_num, 0) + nvl(t.daily_small_refraction_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_micro_measue_point_num, 0) + nvl(r.daily_small_refraction_num, 0)) from gp_ops_daily_report r "
//					+ "where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / (nvl(dy.design_micro_measue_num, 0) + nvl(dy.design_small_regraction_num, 0)) * 100 end, 2) end) as total_measue_radio, nvl(t.daily_drill_sp_num, 0) as drill, "
//					+ "(case t.audit_status when '3' then sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) "
//					+ "else sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0) end) as total_drill, "
//					+ "(case t.audit_status when '3' then round(case nvl(dy.design_drill_num, 0) when 0 then 0 else (sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' and r.project_info_no = t.project_info_no "
//					+ "and r.produce_date <= t.produce_date),0)) / dy.design_drill_num * 100 end, 2) else round(case nvl(dy.design_drill_num, 0) when 0 then 0 else (sum(nvl(t.daily_drill_sp_num, 0)) over(partition by t.project_info_no order by t.produce_date asc) - nvl((select sum(nvl(r.daily_drill_sp_num, 0)) from gp_ops_daily_report r where r.bsflag = '0' and r.audit_status <> '3' "
//					+ "and r.project_info_no = t.project_info_no and r.produce_date <= t.produce_date),0)) / dy.design_drill_num * 100 end, 2) end) as total_drill_radio, "
//					+ "t.produce_date, gp.project_name, gp.build_method, oi.org_abbreviation as org_name, t.audit_status, t.daily_no, t.project_info_no "
//					+ "from gp_ops_daily_report t join gp_task_project gp on gp.project_info_no = t.project_info_no and gp.bsflag = '0'  and t.exploration_method = gp.exploration_method "
//					+ " join comm_org_information oi on oi.org_id = t.org_id and oi.bsflag = '0' "
//					+ " join gp_task_project_dynamic dy "
//					+ " on dy.project_info_no = t.project_info_no "
//					+ " and dy.exploration_method = t.exploration_method"
//					+ " where t.bsflag = '0' and t.project_info_no = '"
//					+ projectInfoNo + "' order by produce_date desc";
			String sql="select  inf.Sum_ce,inf.Daily_Acquire_cj, inf.Daily_Surface_bc, inf.DAILY_TEST_sy," +
					" inf.Daily_Drill_zj,  inf.produce_date, inf.audit_status,"+
   "inf.avg_ce,inf.avg_cj,inf.avg_bc,inf.avg_test,inf.avg_zj,  wt.daily_no_ws,wt.project_info_no  from(  select  ing.sum_ce," +
   "ing.daily_acquire_cj,ing.daily_surface_bc,ing.daily_test_sy,ing.daily_drill_zj,ing.produce_date, ing.audit_status,"+
"round (decode(yy.design_survey_num,0,0, ing.sum_ce  / yy.design_survey_num),2) * 100 as avg_ce,"+
"round (decode(yy.design_sp_num,0,0,  ing.daily_acquire_cj/ yy.design_sp_num),2) * 100 as avg_cj,"+
"round (decode(yy.design_surface_num,0,0,   ing.daily_surface_bc / yy.design_surface_num),2) * 100 as avg_bc,"+
"round (decode(yy.design_test_num,0,0,     ing.daily_test_sy / yy.design_test_num),2) * 100 as avg_test,     "+
"round (decode(yy.design_drill_num,0,0,     ing.daily_drill_zj / yy.design_drill_num),2) * 100 as avg_zj"+
    


" from (select nvl((select sum(r.daily_survey_point_num_ws) over(partition by r.audit_status order by r.produce_date) aaa "+ //日完成测量点数2
         " from gp_ops_daily_report_ws r  where r.project_info_no = '"+projectInfoNo+"'    and r.audit_status = '3' and r.bsflag='0'"+ 
         " and r.produce_date = t.produce_date) ,0)sum_ce,    nvl((select sum(r.daily_acquire_sp_num) over(partition by r.audit_status order by r.produce_date) bbb  "+ 
         " from gp_ops_daily_report_ws r where r.project_info_no = '"+projectInfoNo+"'  and r.audit_status = '3'and r.bsflag='0'"+
         "  and r.produce_date = t.produce_date) ,0) daily_acquire_cj,  nvl( (select  sum(r.daily_surface_point_num) over(partition by r.audit_status order by r.produce_date) ccc  "+
        "  from gp_ops_daily_report_ws r  where r.project_info_no = '"+projectInfoNo+"'   and r.audit_status = '3'and r.bsflag='0'"+
          " and r.produce_date = t.produce_date)  ,0)daily_surface_bc,  nvl( (select   sum(r.daily_test_sp_num) over(partition by r.audit_status order by r.produce_date) ddd  "+
        "  from gp_ops_daily_report_ws r where r.project_info_no = '"+projectInfoNo+"' and r.audit_status = '3' and r.bsflag='0'"+
        "   and r.produce_date = t.produce_date) ,0) daily_test_sy,     nvl((select    sum(r.daily_drill_sp_num) over(partition by r.audit_status order by r.produce_date) eee  "+
        "  from gp_ops_daily_report_ws r  where r.project_info_no = '"+projectInfoNo+"'   and r.audit_status = '3'and r.bsflag='0'"+
         "  and r.produce_date = t.produce_date) ,0) daily_drill_zj,  t.produce_date, t.audit_status from gp_ops_daily_report_ws t"+
" where t.project_info_no = '"+projectInfoNo+"' group by t.produce_date,audit_status)ing, (select c.design_sp_num,"+
           "    c.design_survey_num,   c.design_surface_num,  c.design_drill_num,  c.design_test_num  from gp_task_project_dynamic c"+
        " where c.project_info_no = '"+projectInfoNo+"' and c.bsflag='0') yy  )inf,gp_ops_daily_report_ws wt where wt.produce_date=inf.produce_date and wt.bsflag='0' and wt.project_info_no='"+projectInfoNo+"' order by inf.produce_date ";
			page = radDao.queryRecordsBySQL(sql, page);
			
			msg.setValue("datas", page.getData());
			msg.setValue("totalRows", page.getTotalRow());
			msg.setValue("pageSize", pageSize);
		}
		return msg;
	}

	public String getBuildMethod(String projectInfoNo) throws Exception {

		String build_method = "";
		String get_build_method = "select p.build_method from gp_task_project p where p.bsflag = '0' and p.project_info_no = '"
				+ projectInfoNo + "'";
		if (jdbcDao.queryRecordBySQL(get_build_method) != null) {
			build_method = jdbcDao.queryRecordBySQL(get_build_method)
					.get("buildMethod").toString();
		}
		return build_method;
	}
	

	public ISrvMsg submitDailyReport(ISrvMsg reqDTO) throws Exception {

		String dailyNo = reqDTO.getValue("dailyNo");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String produceDate = reqDTO.getValue("produceDate");
		String tt=reqDTO.getValue("survey_process_status");

		if (dailyNo == null || "".equals(dailyNo) || dailyNo == "null"
				|| "null".equals(dailyNo)) {

			Map map = new HashMap();
			map.put("projectInfoNo", projectInfoNo);
			map.put("produceDate", produceDate);
			Map daily = this.getDailyReport(map);
			dailyNo = (String) daily.get("dailyNo");
		}

		UserToken user = reqDTO.getUserToken();

		Map map = reqDTO.toMap();
		map.put("updator", user.getUserName());
		map.put("modifi_date", new Date());
		map.put("submit_status", "2");
		map.put("audit_status", "1");
		map.put("daily_no_ws", dailyNo);

		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
				"gp_ops_daily_report_ws");

		map.put("survey_process_status",
				reqDTO.getValue("survey_process_status"));
		map.put("surface_process_status",
				reqDTO.getValue("surface_process_status"));
		map.put("drill_process_status", reqDTO.getValue("drill_process_status"));
		map.put("collect_process_status",
				reqDTO.getValue("collect_process_status"));

		String update = "update gp_ops_daily_produce_sit set survey_process_status = '"
				+ reqDTO.getValue("survey_process_status")
				+ "',surface_process_status = '"
				+ reqDTO.getValue("surface_process_status")
				+ "',drill_process_status = '"
				+ reqDTO.getValue("drill_process_status")
				+ "',collect_process_status = '"
				+ reqDTO.getValue("collect_process_status")
				+ "' where daily_no = '" + dailyNo + "' ";
		radDao.getJdbcTemplate().update(update);

		update = "update bgp_p6_assign_mapping set submit_flag = '1',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"
				+ projectInfoNo + "') and bsflag = '0'";

		radDao.getJdbcTemplate().update(update);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("message", "success");
		return msg;
	}

	public ISrvMsg auditDailyReport(ISrvMsg reqDTO) throws Exception {
		String dailyNo = reqDTO.getValue("dailyNo");
		String auditStatus = reqDTO.getValue("audit_status");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String audit_opinion = reqDTO.getValue("audit_opinion");
		// String orgId = reqDTO.getValue("orgId");

		String sql = "select * from gp_task_project where project_info_no = '"
				+ projectInfoNo + "' ";

		Map project = jdbcDao.queryRecordBySQL(sql);

		UserToken user = reqDTO.getUserToken();

		Map map = reqDTO.toMap();
		map.put("updator", user.getEmpId());
		map.put("audit_date", new Date());
		map.put("daily_no_ws", dailyNo);
		// map.put("org_id", orgId);
		map.put("modifi_date", new Date());
		map.put("audit_status", auditStatus);
		map.put("ratifier", user.getEmpId());

		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
				"gp_ops_daily_report_ws");

		if (audit_opinion != null && !"".equals(audit_opinion)) {
			sql = "select * from gp_adm_data_examine where data_no = '"
					+ dailyNo + "'  and bsflag = '0' ";

			Map temp = new HashMap();
			Map examine = jdbcDao.queryRecordBySQL(sql);
			if (examine != null) {
				temp.put("data_examine_no", examine.get("dataExamineNo"));
				temp.put("project_info_no", projectInfoNo);
				temp.put("data_no", dailyNo);
				temp.put("audit_date", new Date());
				temp.put("audit_opinion", audit_opinion);
				temp.put("bsflag", "0");
			} else {
				temp.put("project_info_no", projectInfoNo);
				temp.put("data_no", dailyNo);
				temp.put("audit_date", new Date());
				temp.put("audit_opinion", audit_opinion);
				temp.put("bsflag", "0");
			}

			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(temp,
					"gp_adm_data_examine");
		}

		// 审批通过 根据日报状态修改项目状态
		if (auditStatus != null && auditStatus.equals("3")) {
			if (map.get("if_build") != null
					&& "4".equals((String) map.get("if_build"))) {
				if ("5000100001000000001".equals((String) project
						.get("projectStatus"))) {
					// 测量 改成项目启动
					map.put("project_status", "5000100001000000002");
					map.put("project_info_no", projectInfoNo);
					map.put("modifi_date", new Date());

					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
							"gp_task_project");
				}
			} else if (map.get("if_build") != null
					&& "6".equals((String) map.get("if_build"))) {
				// 采集
				map.put("ifBuild", "6");
				map.put("flag", "min");

				Map report = this.getDailyReportByStatus(map);
				if (report != null) {
					map.put("project_start_time", report.get("produceDate"));
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);

					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
							"gp_task_project");
				}
			} else if (map.get("if_build") != null
					&& "9".equals((String) map.get("if_build"))) {
				// 结束
				map.put("ifBuild", "9");
				map.put("flag", "max");

				Map report = this.getDailyReportByStatus(map);
				if (report != null) {
					map.put("project_end_time", report.get("produceDate"));
					map.put("project_status", "5000100001000000005");
					map.put("modifi_date", new Date());
					map.put("project_info_no", projectInfoNo);

					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
							"gp_task_project");
				}
			} else if (map.get("if_build") != null
					&& "8".equals((String) map.get("if_build"))) {
				// 暂停
				map.put("project_status", "5000100001000000004");
				map.put("modifi_date", new Date());
				map.put("project_info_no", projectInfoNo);

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,
						"gp_task_project");
			}
			map.clear();
			// map.put("produceDate", value)
			map.put("userId", user.getEmpId());
			map.put("userName", user.getUserName());

			sql = "select * from gp_ops_daily_report_ws where daily_no_ws = '"
					+ dailyNo + "' ";

			Map daily = jdbcDao.queryRecordBySQL(sql);

			map.put("projectInfoNo", projectInfoNo);
			map.put("produceDate", daily.get("produceDate"));

			// 审批通过以后把工作量分配表的本期值置空
			String update = "update bgp_p6_workload set actual_this_period_units = '0',modifi_date = sysdate where project_info_no = '"
					+ projectInfoNo + "' and bsflag = '0'";
			// radDao.getJdbcTemplate().update(update);

			// 日报允许打回操作 不置空本期值 审批通过时更新每日的工作量分配记录的累计值
			update = "select p.project_object_id,sum(nvl(p.actual_this_period_units,0)) as actual_this_period_units,p.activity_object_id,p.resource_object_id from bgp_p6_workload p join gp_ops_daily_report r  on r.project_info_no = p.project_info_no and r.produce_date = p.produce_date "
					+ "and r.produce_date <= to_date('"
					+ daily.get("produceDate")
					+ "','yyyy-MM-dd') and r.project_info_no = '"
					+ projectInfoNo
					+ "' and r.bsflag = '0' where p.bsflag = '0' group by p.project_object_id,p.activity_object_id,p.resource_object_id ";

			List<Map> list = jdbcDao.queryRecords(update);
			if (list != null && list.size() != 0) {
				for (int i = 0; i < list.size(); i++) {
					Map temp = list.get(i);
					update = "update bgp_p6_workload set actual_units = '"
							+ temp.get("actualThisPeriodUnits")
							+ "' where project_info_no = '" + projectInfoNo
							+ "' and activity_object_id = '"
							+ temp.get("activityObjectId")
							+ "' and resource_object_id = '"
							+ temp.get("resourceObjectId")
							+ "'  and produce_date is null ";
					radDao.getJdbcTemplate().update(update);
				}
			}

			update = "update bgp_p6_assign_mapping set submit_flag = '"
					+ auditStatus
					+ "',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"
					+ projectInfoNo + "') and bsflag = '0'";
			radDao.getJdbcTemplate().update(update);

			update = "update bgp_p6_activity set submit_flag = '"
					+ auditStatus
					+ "',modifi_date = sysdate where project_object_id in (select object_id from bgp_p6_project where project_info_no = '"
					+ projectInfoNo + "') and bsflag = '0' ";

			radDao.getJdbcTemplate().update(update);

			AuditDailyReportThread thread = new AuditDailyReportThread(map);
			thread.start();
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		msg.setValue("dailyNo", dailyNo);
		msg.setValue("projectInfoNo", projectInfoNo);

		return msg;
	}

	public Map getDailyReportByStatus(Map map) {
		String ifBuild = (String) map.get("ifBuild");
		String flag = (String) map.get("flag");
		String projectInfoNo = (String) map.get("projectInfoNo");
		String orgId = (String) map.get("orgId");

		String sql = "select * from gp_ops_daily_report t,gp_ops_daily_produce_sit sit where t.project_info_no = '"
				+ projectInfoNo
				+ "' and sit.daily_no = t.daily_no and sit.if_build = '"
				+ ifBuild
				+ "' "
				+ " and t.audit_status = '3'  and t.bsflag = '0'";

		if (orgId != null && !"".equals(orgId)) {
			sql += " and t.rog_id = '" + orgId + "' ";
		}

		sql += " order by t.produce_date ";

		if (flag == "max" || "max".equals(flag)) {
			sql += "desc";
		}

		Map report = jdbcDao.queryRecordBySQL(sql);

		return report;
	}

	public ISrvMsg saveOrUpdateDailyReport(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();

		String flag = reqDTO.getValue("flag");
		String edit_flag = reqDTO.getValue("edit_flag");
		String project_info_no = reqDTO.getValue("project_info_no");
		String produceDate = reqDTO.getValue("produce_date");

		String org_id = null;
		String org_subjection_id = null;

		boolean flag1 = false;

		ProjectMCSBean projectMCSBean = (ProjectMCSBean) BeanFactory
				.getBean("ProjectMCSBean");

		PageModel page = new PageModel();

		Map map = reqDTO.toMap();
		map.put("projectInfoNo", map.get("project_info_no"));

		page = projectMCSBean.quertProject(map, page);

		List list = page.getData();
		if (list != null && list.size() != 0) {
			Map project = (Map) list.get(0);
			map.put("workarea_no", project.get("workarea_no"));
			map.put("exploration_method", project.get("exploration_method"));
		}

		page = projectMCSBean.quertProjectDynamic(map, page);

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map dy = (Map) list.get(0);

			org_id = (String) dy.get("org_id");
			map.put("org_id", dy.get("org_id"));

			org_subjection_id = (String) dy.get("org_subjection_id");
			map.put("org_subjection_id", dy.get("org_subjection_id"));
		}

		if (flag.equals("notSaved")) {
			// 新增
			map.put("creator", user.getUserName());
			map.put("create_date", new Date());

			map.put("updator", user.getUserName());
			map.put("modifi_date", new Date());

			map.put("bsflag", "0");
			map.put("SUBMIT_STATUS", "1");
			map.put("audit_status", "0");

			Serializable dailyNo = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_daily_report_ws");

			map.put("daily_no", dailyNo);
		  BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"gp_ops_daily_produce_sit");

			flag1 = true;

			JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

			String sql = "select * from bgp_p6_workload where bsflag = '0' and project_info_no = '"
					+ project_info_no
					+ "' and produce_date = to_date('"
					+ produceDate + "','yyyy-MM-dd') ";

			List<Map<String, Object>> temp = radDao.getJdbcTemplate()
					.queryForList(sql);
			if (temp == null || temp.size() == 0) {
				// 本日没有记录
				sql = "select * from bgp_p6_workload where bsflag = '0' and produce_date is null and project_info_no = '"
						+ project_info_no + "' ";
				List<Map<String, Object>> tempList = radDao.getJdbcTemplate()
						.queryForList(sql);
				// 创建本日记录
				for (int i = 0; i < tempList.size(); i++) {
					Map<String, Object> mapTemp = tempList.get(i);

					mapTemp.put("produce_date", produceDate);
					mapTemp.put("object_id", null);

					mapTemp.put("actual_this_period_units", "0");

					mapTemp.put("create_date", new Date());
					mapTemp.put("creator", user.getUserId());
					mapTemp.put("modifi_date", new Date());
					mapTemp.put("updator", user.getUserId());
				}

				WorkloadMCSBean w = new WorkloadMCSBean();
				w.saveOrUpdateWorkloadToMCS(tempList, user);
			}

		} else if (edit_flag.equals("yes")
				&& (flag.equals("notPassed") || flag.equals("notSubmited"))) {
			// 修改
			String daily_no_ws=reqDTO.getValue("daily_no_ws");
			String if_build=reqDTO.getValue("if_build");
//			String collect_time=reqDTO.getValue("collect_time");
//			Map daily = this.getDailyReport(map);
			map.put("daily_no_ws",daily_no_ws );

			map.put("updator", user.getUserName());
			map.put("modifi_date", new Date());

//			map.put("collect_time", collect_time);
			map.put("bsflag", "0");
			map.put("SUBMIT_STATUS", "1");
			map.put("if_build", if_build);
			map.put("produce_date", produceDate);

			Serializable dailyNo = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_daily_report_ws");

			// 查询出daily_sit_no进行更新
			String getsitDailyNo = "select s.daily_sit_no from gp_ops_daily_produce_sit s where s.bsflag = '0' and s.daily_no = '"
					+ dailyNo + "'";

			if (radDao.queryRecordBySQL(getsitDailyNo.toString()) != null) {
				map.put("daily_sit_no", radDao.queryRecordBySQL(getsitDailyNo.toString()).get( "daily_sit_no"));
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_daily_produce_sit");
			}

			flag1 = true;
		}

		if (flag1) {
			String deleteId = reqDTO.getValue("deleteId");
			Map map1 = reqDTO.toMap();
			String[] deleteIds = deleteId.split(",");
			List<String> list1 = new ArrayList<String>();
			if (deleteIds != null && deleteIds.length > 1) {
				for (int i = 1; i < deleteIds.length; i++) {
					list1.add(deleteIds[i]);
				}
				this.deleteQuestion(list1);
			}

			List<String> listOrders = reqDTO.getValues("order");
			String order = reqDTO.getValue("order");

			if (listOrders == null && order != null) {
				listOrders = new ArrayList<String>();
				listOrders.add(order);
			}

			List saveList = new ArrayList();
			List updateList = new ArrayList();

			String j = null;

			String question_id = null;

			String bug_code = null;
			String q_description = null;
			String resolvent = null;

			if (listOrders != null && listOrders.size() != 0) {

				for (int i = 0; i < listOrders.size(); i++) {
					j = listOrders.get(i);

					question_id = reqDTO.getValue("question_id_" + j);
					bug_code = reqDTO.getValue("bug_code_" + j);
					q_description = reqDTO.getValue("q_description_" + j);
					resolvent = reqDTO.getValue("resolvent_" + j);
					if (question_id == null || "".equals(question_id)) {
						// 新增
						map = new HashMap();

						map.put("creator", user.getEmpId());
						map.put("create_date", new Date());
						map.put("updator", user.getEmpId());
						map.put("modifi_date", new Date());

						map.put("bsflag", "0");
						map.put("bug_code", bug_code);
						map.put("q_description", q_description);
						map.put("resolvent", resolvent);
						map.put("project_info_no", project_info_no);
						map.put("org_id", org_id);
						map.put("org_subjection_id", org_subjection_id);
						map.put("produce_date", produceDate);

						saveList.add(map);
					} else {
						// 修改
						map = new HashMap();

						map.put("updator", user.getEmpId());
						map.put("modifi_date", new Date());

						map.put("bsflag", "0");
						map.put("bug_code", bug_code);
						map.put("q_description", q_description);
						map.put("resolvent", resolvent);
						map.put("project_info_no", project_info_no);
						map.put("org_id", org_id);
						map.put("org_subjection_id", org_subjection_id);
						map.put("produce_date", produceDate);

						map.put("question_id", question_id);

						updateList.add(map);
					}

				}
			}

			this.saveDailyQuestion(saveList);
			this.updateDailyQuestion(updateList);
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("flag", flag);
		msg.setValue("projectInfoNo", project_info_no);

		msg.setValue("customKey", "edit_flag,produceDate");
		msg.setValue("customValue", edit_flag + "," + produceDate);
		msg.setValue("taskBackUrl",
				"/pm/dailyReport/singleProject/ws/queryWsResourceAssignment.srq");
		return msg;
	}
	public ISrvMsg saveOrUpdateWsProjectReport(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
        
	 
		String projectInfoNo = reqDTO.getValue("project_info_no");
	 

		String org_id = null;
		String org_subjection_id = null;
		ProjectMCSBean projectMCSBean = (ProjectMCSBean) BeanFactory
		.getBean("ProjectMCSBean");
		PageModel page = new PageModel();
		Map map = reqDTO.toMap();
	
			 
		page = projectMCSBean.quertProjectDynamic(map, page);
		 
		List list = page.getData();
		if (list != null && list.size() != 0) {
			Map dy = (Map) list.get(0);

			org_id = (String) dy.get("org_id");
			map.put("org_id", dy.get("org_id"));

			org_subjection_id = (String) dy.get("org_subjection_id");
			map.put("org_subjection_id", dy.get("org_subjection_id"));
		}
		map.put("CREATOR", user.getUserName());
		map.put("CREATE_DATE",new Date());
		
		map.put("projectInfoNo", map.get("project_info_no"));
		map.put("daily_pd_ws", map.get("daily_pd_ws"));
		Serializable dailyNo = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "gp_ops_project_report_ws");

		return reqDTO;
 
	}
	public ISrvMsg getProjectFn(ISrvMsg  reqDTO) throws SOAPException {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);// ????????
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String sql = "select project_father_no from gp_task_project where project_info_no='"
			+ projectInfoNo
			+ "' and bsflag='0' ";

	Map projectFn = new HashMap();
	projectFn = jdbcDao.queryRecordBySQL(sql);
   msg.setValue("projectFn", projectFn);
		return msg;
	}
	public ISrvMsg getProjectReport(ISrvMsg  reqDTO) throws SOAPException {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);// ????????
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		 


		String sql = "select * from gp_ops_project_report_ws where project_info_no='"
				+ projectInfoNo
				+ "' and bsflag='0' ";

		Map projectMap = new HashMap();
		projectMap = jdbcDao.queryRecordBySQL(sql);
       msg.setValue("projectMap", projectMap);
		return msg;
	}
	private void deleteQuestion(final List<String> ids) {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String sql = "update gp_ops_daily_question set bsflag = '1' where question_id = ?";
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return ids.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				ps.setString(1, ids.get(i));
			}

		};

		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}

	/**
	 * 查询日报附属表
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> findGpOpsDaily(Map map) {

		String dailyNo = (String) map.get("dailyNo");
		String lineGroupId = (String) map.get("lineGroupId");
		String tableName = (String) map.get("tableName");

		if (dailyNo == null || "".equals(dailyNo)) {
			dailyNo = (String) map.get("daily_no");
		}
		if (lineGroupId == null || "".equals(lineGroupId)) {
			lineGroupId = (String) map.get("line_group_id");
		}
		if (tableName == null || "".equals(tableName)) {
			tableName = (String) map.get("table_name");
		}

		String customKey = (String) map.get("customKey");
		String customValue = (String) map.get("customValue");

		if (customKey == null || "".equals(customKey)) {
			customKey = (String) map.get("custom_key");
		}
		if (customValue == null || "".equals(customValue)) {
			customValue = (String) map.get("custom_value");
		}

		String sql = "select * from " + tableName + " where daily_no = '"
				+ dailyNo + "' and bsflag = '0'  ";

		if (lineGroupId != null && !"".equals(lineGroupId)) {
			sql += " and line_group_id = '" + lineGroupId + "' ";
		}

		if (customKey != null && !"".equals(customKey)) {
			String[] temp = customKey.split(",");
			String[] temp1 = customValue.split(",");

			for (int i = 0; i < temp.length; i++) {
				sql += " and " + temp[i] + "= '" + temp1[i] + "' ";
			}
		}

		List<Map<String, Object>> list = radDao.getJdbcTemplate().queryForList(
				sql);

		return list;
	}

	public ISrvMsg saveOrUpdateDailyPlan(ISrvMsg reqDTO) throws Exception {

		String deleteId = reqDTO.getValue("deleteId");
		Map map1 = reqDTO.toMap();
		String[] deleteIds = deleteId.split(",");
		List<String> list = new ArrayList<String>();
		if (deleteIds != null && deleteIds.length > 1) {
			for (int i = 1; i < deleteIds.length; i++) {
				list.add(deleteIds[i]);
			}
			this.deleteDailyPlan(list);
		}

		List<String> listOrders = reqDTO.getValues("order");
		String order = reqDTO.getValue("order");

		if (listOrders == null && order != null) {
			listOrders = new ArrayList<String>();
			listOrders.add(order);
		}

		UserToken user = reqDTO.getUserToken();
		String project_info_no = reqDTO.getValue("project_info_no");
		if (project_info_no == null || "".equals(project_info_no)) {
			project_info_no = user.getProjectInfoNo();
		}

		List saveList = new ArrayList();
		List updateList = new ArrayList();

		String j = null;
		String pro_plan_id = null;
		String value = null;
		String record_month = null;
		Map map = null;

		String[] valueName = { "measure_", "drill_", "collect_" };
		String[] valueKey = { "workload_num", "workload", "workload" };
		String[] proValue = { "measure_pro_plan_id_", "drill_pro_plan_id_",
				"coll_pro_plan_id_" };
		String[] planType = { "measuredailylist", "drilldailylist",
				"colldailylist" };

		if (listOrders != null) {
			for (int i = 0; i < listOrders.size(); i++) {
				j = listOrders.get(i);

				for (int k = 0; k < valueName.length; k++) {

					value = reqDTO.getValue(valueName[k] + j);
					pro_plan_id = reqDTO.getValue(proValue[k] + j);
					record_month = reqDTO.getValue("record_month_" + j);
					if (value == null) {
						// 无值 跳过
					} else {
						if (pro_plan_id == null || "".equals(pro_plan_id)
								|| "undefined".equals(pro_plan_id)) {
							// 新增
							map = new HashMap();
							map.put("bsflag", "0");
							// map.put("pro_plan_id", pro_plan_id);
							map.put("record_month", record_month);
							map.put("oper_plan_type", planType[k]);
							map.put(valueKey[k], value);
							map.put("project_info_no", project_info_no);

							saveList.add(map);
						} else {
							// 修改
							map = new HashMap();
							map.put("bsflag", "0");
							map.put("pro_plan_id", pro_plan_id);
							map.put("record_month", record_month);
							map.put("oper_plan_type", planType[k]);
							map.put(valueKey[k], value);
							map.put("project_info_no", project_info_no);

							updateList.add(map);
						}
					}

				}

			}

			this.saveDailyPlan(saveList);
			this.updateDailyPlan(updateList);
		} else {
			String updateAll = "update gp_proj_product_plan p set p.bsflag = '1' where p.project_info_no = '"
					+ project_info_no + "'";
			radDao.executeUpdate(updateAll);
		}

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		return msg;
	}

	public ISrvMsg queryDailyPlan(ISrvMsg reqDTO) throws Exception {

		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(9999);

		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		String[] planType = { "measuredailylist", "drilldailylist",
				"colldailylist" };

		StringBuffer sql = new StringBuffer();

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		sql.append("select distinct to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month from gp_proj_product_plan where project_info_no = '"
				+ projectInfoNo + "'  and oper_plan_type in(");

		for (int i = 0; i < planType.length; i++) {
			sql.append("'" + planType[i] + "',");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(") and bsflag ='0' order by to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') ");

		page = radDao.queryRecordsBySQL(sql.toString(), page);
		List list = page.getData();
		// List list = null;
		if (list != null && list.size() != 0) {
			msg.setValue("hasSaved", "1");
			msg.setValue("allList", list);

			for (int i = 0; i < planType.length; i++) {
				sql = new StringBuffer();
				sql.append("select pro_plan_id,to_char(to_date(record_month,'yyyy-MM-dd'),'yyyy-MM-dd') as record_month,workload_num,workload from gp_proj_product_plan where bsflag = '0' and project_info_no = '"
						+ projectInfoNo
						+ "'  and oper_plan_type = '"
						+ planType[i]
						+ "'  order by to_char(to_date("
						+ "record_month,'yyyy-MM-dd'),'yyyy-MM-dd')");
				page = radDao.queryRecordsBySQL(sql.toString(), page);
				msg.setValue(planType[i], page.getData());
			}
		} else if (list == null || list.size() == 0) {
			msg.setValue("hasSaved", "0");
			list = countDailyPlan(projectInfoNo);

			msg.setValue("allList", list.get(0));
			msg.setValue("measuredailylist", list.get(1));
			msg.setValue("drilldailylist", list.get(2));
			msg.setValue("colldailylist", list.get(3));
		}

		return msg;
	}

	private Map<String, String> getDesignTotal(String projectInfoNo) {
		Map totalUnitsMap = new HashMap();
		String[] measure2Type = { "G02003", "G02004" };
		String[] measure3Type = { "G2003", "G2004" };

		String[] drill2Type = { "G05001" };
		String[] drill3Type = { "G5001" };

		String[] coll2Type = { "G07001", "G07003", "G07005" };
		String[] coll3Type = { "G7001", "G7003", "G7005" };

		String method_sql = "select exploration_method from gp_task_project  where project_info_no = '"
				+ projectInfoNo + "' and bsflag = '0'";
		Map totalMap = radDao.queryRecordBySQL(method_sql);

		String exploration_method = null;
		if (totalMap != null) {
			exploration_method = (String) totalMap.get("exploration_method");
		}

		// 测量
		String measureSqlTemp = "";
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			measureSqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				measureSqlTemp = measureSqlTemp + measure2Type[i] + "','";
			}
			measureSqlTemp = measureSqlTemp.substring(0,
					measureSqlTemp.length() - 2);
			measureSqlTemp += ") order by a.planned_start_date";
		} else {
			measureSqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				measureSqlTemp = measureSqlTemp + measure3Type[i] + "','";
			}
			measureSqlTemp = measureSqlTemp.substring(0,
					measureSqlTemp.length() - 2);
			measureSqlTemp += ") order by a.planned_start_date";
		}

		String measureSql = "select nvl(sum(w.planned_units),0) as measure_plan_units from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' ";
		measureSql += measureSqlTemp;
		String totalMeasure = "";
		if (radDao.queryRecordBySQL(measureSql) != null) {
			totalMeasure = radDao.queryRecordBySQL(measureSql)
					.get("measure_plan_units").toString();
		}
		totalUnitsMap.put("totalMeasure", totalMeasure);

		// 钻井
		String drillSqlTemp = "";
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			drillSqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill2Type.length; i++) {
				drillSqlTemp = drillSqlTemp + drill2Type[i] + "','";
			}
			drillSqlTemp = drillSqlTemp.substring(0, drillSqlTemp.length() - 2);
			drillSqlTemp += ")";
		} else {
			drillSqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill3Type.length; i++) {
				drillSqlTemp = drillSqlTemp + drill3Type[i] + "','";
			}
			drillSqlTemp = drillSqlTemp.substring(0, drillSqlTemp.length() - 2);
			drillSqlTemp += ")";
		}

		String drillSql = "select nvl(sum(w.planned_units),0) as drill_planned_units from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' ";

		drillSql += drillSqlTemp;
		String totalDrill = "";
		if (radDao.queryRecordBySQL(drillSql) != null) {
			totalDrill = radDao.queryRecordBySQL(drillSql)
					.get("drill_planned_units").toString();
		}
		totalUnitsMap.put("totalDrill", totalDrill);

		// 采集
		String collSqlTemp = "";
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			collSqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll2Type.length; i++) {
				collSqlTemp = collSqlTemp + coll2Type[i] + "','";
			}
			collSqlTemp = collSqlTemp.substring(0, collSqlTemp.length() - 2);
			collSqlTemp += ")";
		} else {
			collSqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll3Type.length; i++) {
				collSqlTemp = collSqlTemp + coll3Type[i] + "','";
			}
			collSqlTemp = collSqlTemp.substring(0, collSqlTemp.length() - 2);
			collSqlTemp += ")";
		}

		String collSql = "select nvl(sum(w.planned_units),0) as coll_planned_units from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' ";

		collSql += collSqlTemp;
		String totalColl = "";
		if (radDao.queryRecordBySQL(collSql) != null) {
			totalColl = radDao.queryRecordBySQL(collSql)
					.get("coll_planned_units").toString();
		}
		totalUnitsMap.put("totalColl", totalColl);

		return totalUnitsMap;
	}

	private List countDailyPlan(String projectInfoNo) {
		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(99999);

		List AllList = new ArrayList();
		List measuredailylist = new ArrayList();
		List drilldailylist = new ArrayList();
		List colldailylist = new ArrayList();

		String[] measure2Type = { "G02003", "G02004" };
		String[] measure3Type = { "G2003", "G2004" };

		String[] drill2Type = { "G05001" };
		String[] drill3Type = { "G5001" };

		String[] coll2Type = { "G07001", "G07003", "G07005" };
		String[] coll3Type = { "G7001", "G7003", "G7005" };

		String sql = "select exploration_method from gp_task_project  where project_info_no = '"
				+ projectInfoNo + "' and bsflag = '0'";
		page = radDao.queryRecordsBySQL(sql.toString(), page);

		List list = page.getData();

		String exploration_method = null;
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			exploration_method = (String) map.get("exploration_method");
		} else {
			return null;
		}

		String sqlTemp = null;

		// 总的
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				sqlTemp = sqlTemp + measure2Type[i] + "','";
			}
			for (int i = 0; i < drill2Type.length; i++) {
				sqlTemp = sqlTemp + drill2Type[i] + "','";
			}
			for (int i = 0; i < coll2Type.length; i++) {
				sqlTemp = sqlTemp + coll2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				sqlTemp = sqlTemp + measure3Type[i] + "','";
			}
			for (int i = 0; i < drill3Type.length; i++) {
				sqlTemp = sqlTemp + drill3Type[i] + "','";
			}
			for (int i = 0; i < coll3Type.length; i++) {
				sqlTemp = sqlTemp + coll3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		}

		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);

		String max_finish_date = null;
		String min_start_date = null;

		Date start_date = null;
		Date end_date = null;

		int day = 0;

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");

			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation
						.getDateSkip(min_start_date, max_finish_date);
			}
		}
		Date temp = start_date;
		String dateTemp = null;
		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month",
					DateOperation.formatDate(temp, "yyyy-MM-dd"));
			temp.setTime(temp.getTime() + 86400000L);
			AllList.add(map);
		}

		// 测量
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure2Type.length; i++) {
				sqlTemp = sqlTemp + measure2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ") order by a.planned_start_date";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < measure3Type.length; i++) {
				sqlTemp = sqlTemp + measure3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ") order by a.planned_start_date";
		}

		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);

		max_finish_date = null;
		min_start_date = null;

		start_date = null;
		end_date = null;

		day = 0;

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");

			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation
						.getDateSkip(min_start_date, max_finish_date);
			}
		}

		sql = "select w.planned_units,a.planned_duration/8 as duration,round(w.planned_units*8/a.planned_duration,3) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();

		temp = new Date();
		dateTemp = null;

		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month",
					DateOperation.formatDate(temp, "yyyy-MM-dd"));

			double workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Double.parseDouble((String) tempMap
							.get("average_units"));
				}
			}
			map.put("workload_num", df_1.format(workload_num));
			measuredailylist.add(map);
		}

		// String startDate = null;
		// String endDate = null;
		//
		// Date sd = null;
		// Date ed = null;
		// Date tempDate = null;
		//
		// for (int i = 0; i < list.size(); i++) {
		// Map tempMap = (Map) list.get(i);
		// startDate = (String) tempMap.get("start_date");//每个作业的开始时间
		// endDate = (String) tempMap.get("finish_date");//每个作业的结束时间
		//
		// tempDate = DateOperation.parseToUtilDate(startDate);//用于比较
		//
		// if (sd == null || ed == null) {
		// //如果sd为null 该记录为第一条作业
		// sd = tempDate;
		// ed = DateOperation.parseToUtilDate(endDate);
		// } else
		// if(DateOperation.getDateSkip(endDate,DateOperation.formatDate(sd)) >
		// 0) {
		// //如果endDate > sd
		//
		// } else {
		// //如果endDate <= sd
		//
		// }
		//
		// }

		// 钻井
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill2Type.length; i++) {
				sqlTemp = sqlTemp + drill2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < drill3Type.length; i++) {
				sqlTemp = sqlTemp + drill3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		}

		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);

		max_finish_date = null;
		min_start_date = null;

		start_date = null;
		end_date = null;

		day = 0;

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");

			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation
						.getDateSkip(min_start_date, max_finish_date);
			}
		}

		sql = "select w.planned_units,a.planned_duration/8 as duration,round(w.planned_units*8/a.planned_duration,3) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();

		temp = new Date();
		dateTemp = null;

		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month",
					DateOperation.formatDate(temp, "yyyy-MM-dd"));

			double workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Double.parseDouble((String) tempMap
							.get("average_units"));
				}
			}
			map.put("workload", df_1.format(workload_num));
			drilldailylist.add(map);
		}

		// 采集
		if (exploration_method == "0300100012000000002"
				|| "0300100012000000002".equals(exploration_method)) {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll2Type.length; i++) {
				sqlTemp = sqlTemp + coll2Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		} else {
			sqlTemp = " and resource_id in ('";
			for (int i = 0; i < coll3Type.length; i++) {
				sqlTemp = sqlTemp + coll3Type[i] + "','";
			}
			sqlTemp = sqlTemp.substring(0, sqlTemp.length() - 2);
			sqlTemp += ")";
		}

		sql = "select to_char(min(a.planned_start_date),'yyyy-MM-dd') as min_start_date,to_char(max(a.planned_finish_date),'yyyy-MM-dd') as max_finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);

		max_finish_date = null;
		min_start_date = null;

		start_date = null;
		end_date = null;

		day = 0;

		list = page.getData();
		if (list != null && list.size() != 0) {
			Map map = (Map) list.get(0);
			min_start_date = (String) map.get("min_start_date");
			max_finish_date = (String) map.get("max_finish_date");

			try {
				start_date = DateOperation.parseToUtilDate(min_start_date);
				end_date = DateOperation.parseToUtilDate(max_finish_date);
			} catch (Exception e) {
			}
			if (start_date == null || end_date == null) {
				day = 0;
			} else {
				day = DateOperation
						.getDateSkip(min_start_date, max_finish_date);
			}
		}

		sql = "select w.planned_units,a.planned_duration/8 as duration,round(w.planned_units*8/a.planned_duration,3) as average_units,to_char(a.planned_start_date,'yyyy-MM-dd') as start_date,to_char(a.planned_finish_date,'yyyy-MM-dd') as finish_date from bgp_p6_workload w "
				+ " join bgp_p6_activity a on a.object_id = w.activity_object_id and a.bsflag = '0' "
				+ " where w.project_info_no = '"
				+ projectInfoNo
				+ "' and w.bsflag = '0' and w.produce_date is null ";

		sql += sqlTemp;

		page = radDao.queryRecordsBySQL(sql.toString(), page);
		list = page.getData();

		temp = new Date();
		dateTemp = null;

		for (int i = 0; i < day; i++) {
			Map map = new HashMap();
			temp.setTime(start_date.getTime() + 86400000L * i);
			dateTemp = DateOperation.formatDate(temp);
			map.put("record_month",
					DateOperation.formatDate(temp, "yyyy-MM-dd"));

			double workload_num = 0;
			for (int j = 0; j < list.size(); j++) {
				Map tempMap = (Map) list.get(j);
				String s = (String) tempMap.get("start_date");
				String e = (String) tempMap.get("finish_date");

				if (DateOperation.dateBetween(s, e, dateTemp)) {
					workload_num += Double.parseDouble((String) tempMap
							.get("average_units"));
				}
			}
			map.put("workload", df_1.format(workload_num));
			colldailylist.add(map);
		}

		List list2 = new ArrayList();
		list2.add(AllList);
		list2.add(measuredailylist);
		list2.add(drilldailylist);
		list2.add(colldailylist);
		return list2;
	}

	private void deleteDailyPlan(final List<String> ids) {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String sql = "update gp_proj_product_plan set bsflag = '1' where pro_plan_id = ?";
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return ids.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				ps.setString(1, ids.get(i));
			}

		};

		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}

	private void saveDailyPlan(final List list) {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String[] propertys = { "RECORD_MONTH", "WORKLOAD", "WORKLOAD_NUM",
				"PROJECT_INFO_NO", "OPER_PLAN_TYPE", "BSFLAG", "PRO_PLAN_ID" };
		StringBuffer sql = new StringBuffer();
		sql.append("insert into gp_proj_product_plan (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append(propertys[i]).append(",");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(") values (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append("?,");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(")");

		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return list.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				Map map = (Map) list.get(i);

				ps.setString(1, (String) map.get("record_month"));
				ps.setString(2, (String) map.get("workload"));
				ps.setString(3, (String) map.get("workload_num"));
				ps.setString(4, (String) map.get("project_info_no"));
				ps.setString(5, (String) map.get("oper_plan_type"));
				ps.setString(6, "0");
				ps.setString(7, radDao.generateUUID());
			}

		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}

	private void updateDailyPlan(final List list) {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String[] propertys = { "RECORD_MONTH", "WORKLOAD", "WORKLOAD_NUM",
				"PROJECT_INFO_NO", "OPER_PLAN_TYPE", "BSFLAG", "PRO_PLAN_ID" };

		StringBuffer sql = new StringBuffer();
		sql.append("update gp_proj_product_plan set ");
		for (int i = 0; i < propertys.length - 1; i++) {
			sql.append(propertys[i]).append("=?,");// 其他值
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(" where ").append(propertys[propertys.length - 1])
				.append("=?");// 主键

		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return list.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				Map map = (Map) list.get(i);

				ps.setString(1, (String) map.get("record_month"));
				ps.setString(2, (String) map.get("workload"));
				ps.setString(3, (String) map.get("workload_num"));
				ps.setString(4, (String) map.get("project_info_no"));
				ps.setString(5, (String) map.get("oper_plan_type"));
				ps.setString(6, "0");
				ps.setString(7, (String) map.get("pro_plan_id"));
			}

		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);
	}

	public ISrvMsg queryDailyQuestion(ISrvMsg reqDTO) throws Exception {

		PageModel page = new PageModel();
		page.setCurrPage(1);
		page.setPageSize(9999);

		String produceDate = reqDTO.getValue("produceDate");// 问题日期
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		String bugCode = reqDTO.getValue("bugCode");// 问题分类

		UserToken user = reqDTO.getUserToken();
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}

		String sql = "select * from gp_ops_daily_question where bsflag = '0' ";

		if (projectInfoNo != null) {
			sql = sql + " and project_info_no = '" + projectInfoNo + "' ";
		}
		if (produceDate != null) {
			sql = sql + " and produce_date = to_date('" + produceDate
					+ "','yyyy-MM-dd')";
		}
		if (bugCode != null) {
			sql = sql + " and bug_code = '" + bugCode + "' ";
		}

		page = radDao.queryRecordsBySQL(sql, page);
		List list = page.getData();

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("questionList", list);

		return msg;
	}

	public ISrvMsg queryDailyQuestionList(ISrvMsg reqDTO) throws Exception {

		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}

		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));

		String produceDate = reqDTO.getValue("produceDate");// 问题日期
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		String bugCode = reqDTO.getValue("bugCode");// 问题分类

		UserToken user = reqDTO.getUserToken();
		if (projectInfoNo == null || "".equals(projectInfoNo)) {
			projectInfoNo = user.getProjectInfoNo();
		}

		String sql = "select * from gp_ops_daily_question where bsflag = '0' ";

		if (projectInfoNo != null && !"".equals(projectInfoNo)) {
			sql = sql + " and project_info_no = '" + projectInfoNo + "' ";
		}
		if (produceDate != null && !"".equals(produceDate)
				&& !"null".equals(produceDate)) {
			sql = sql + " and produce_date = to_date('" + produceDate
					+ "','yyyy-MM-dd')";
		}
		if (bugCode != null && !"".equals(bugCode)) {
			sql = sql + " and bug_code = '" + bugCode + "' ";
		}

		page = radDao.queryRecordsBySQL(sql, page);

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		msg.setValue("datas", page.getData());
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);

		return msg;
	}

	private void saveDailyQuestion(final List list) throws Exception {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String[] propertys = { "project_info_no", "org_id",
				"org_subjection_id", "bug_code", "bug_name", "resolvent",
				"q_description", "produce_date", "creator", "create_date",
				"updator", "modifi_date", "bsflag", "question_id" };

		StringBuffer sql = new StringBuffer();
		sql.append("insert into gp_ops_daily_question (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append(propertys[i]).append(",");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(") values (");
		for (int i = 0; i < propertys.length; i++) {
			sql.append("?,");
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(")");

		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return list.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				Map map = (Map) list.get(i);

				ps.setString(1, (String) map.get("project_info_no"));
				ps.setString(2, (String) map.get("org_id"));
				ps.setString(3, (String) map.get("org_subjection_id"));
				ps.setString(4, (String) map.get("bug_code"));
				ps.setString(5, (String) map.get("bug_name"));
				ps.setString(6, (String) map.get("resolvent"));
				ps.setString(7, (String) map.get("q_description"));

				SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
				java.sql.Date date;
				try {
					date = new java.sql.Date(f.parse(
							(String) map.get("produce_date")).getTime());
					ps.setDate(8, date);
				} catch (Exception e) {
					ps.setDate(8, null);
				}

				ps.setString(9, (String) map.get("creator"));
				ps.setDate(10, new java.sql.Date(new Date().getTime()));

				ps.setString(11, (String) map.get("updator"));
				ps.setDate(12, new java.sql.Date(new Date().getTime()));

				ps.setString(13, "0");

				ps.setString(14, radDao.generateUUID());
			}

		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);

	}

	private void updateDailyQuestion(final List list) throws Exception {
		final RADJdbcDao radDao = (RADJdbcDao) BeanFactory
				.getBean("radJdbcDao");
		JdbcTemplate jdbcTemplate = radDao.getJdbcTemplate();

		String[] propertys = { "project_info_no", "org_id",
				"org_subjection_id", "bug_code", "bug_name", "resolvent",
				"q_description", "produce_date", "updator", "modifi_date",
				"bsflag", "question_id" };

		StringBuffer sql = new StringBuffer();
		sql.append("update gp_ops_daily_question set ");
		for (int i = 0; i < propertys.length - 1; i++) {
			sql.append(propertys[i]).append("=?,");// 其他值
		}
		sql.deleteCharAt(sql.length() - 1);
		sql.append(" where ").append(propertys[propertys.length - 1])
				.append("=?");// 主键

		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {

			@Override
			public int getBatchSize() {
				return list.size();
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				Map map = (Map) list.get(i);

				ps.setString(1, (String) map.get("project_info_no"));
				ps.setString(2, (String) map.get("org_id"));
				ps.setString(3, (String) map.get("org_subjection_id"));
				ps.setString(4, (String) map.get("bug_code"));
				ps.setString(5, (String) map.get("bug_name"));
				ps.setString(6, (String) map.get("resolvent"));
				ps.setString(7, (String) map.get("q_description"));

				SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
				java.sql.Date date;
				try {
					date = new java.sql.Date(f.parse(
							(String) map.get("produce_date")).getTime());
					ps.setDate(8, date);
				} catch (Exception e) {
					ps.setDate(8, null);
				}

				ps.setString(9, (String) map.get("updator"));
				ps.setDate(10, new java.sql.Date(new Date().getTime()));

				ps.setString(11, "0");

				ps.setString(12, (String) map.get("question_id"));
			}

		};
		jdbcTemplate.batchUpdate(sql.toString(), setter);

	}

	/**
	 * 查询项目进度信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */

	public ISrvMsg queryDailyReportProcess(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		// String produceDate = reqDTO.getValue("produceTime");
		String startDate = reqDTO.getValue("startTime");
		String endDate = reqDTO.getValue("endTime");
		String orgId = reqDTO.getValue("orgId");
		String projectType = reqDTO.getValue("projectType");
		String explorationMethod = reqDTO.getValue("explorationMethod");

		Map<String, String> paramMap = new HashMap<String, String>();

		paramMap.put("projectInfoNo", projectInfoNo);
		// paramMap.put("produceDate", produceDate);
		paramMap.put("startDate", startDate);
		paramMap.put("endDate", endDate);
		paramMap.put("orgId", orgId);
		paramMap.put("projectType", projectType);
		paramMap.put("explorationMethod", explorationMethod);

		// 获得当前页
		String currentPage = reqDTO.getValue("cur");

		String cur = null;
		String pageSize1 = "20";
		if (currentPage == null) {
			cur = "1";
		} else {
			cur = currentPage;
		}

		log.debug("the currentPage is:" + currentPage);

		String totalRows = null;
		List<Map> produceDateList = loadAllProduceDate(paramMap);
		// 处理记录总数
		if (produceDateList != null && produceDateList.size() > 0) {

			totalRows = String.valueOf(produceDateList.size());
		} else {

			totalRows = "0";
		}

		// 分页后的的日报生产日期列表
		List<Map> dateList = new ArrayList();

		if (produceDateList != null && !produceDateList.isEmpty()) {

			int currPage = new Integer(cur);
			int totalRow = new Integer(totalRows);
			int pageSize = new Integer(pageSize1);
			int reCount = 0;
			if (totalRow < pageSize)
				reCount = totalRow;
			else {
				if (totalRow - (currPage - 1) * pageSize > pageSize)
					reCount = pageSize;
				else {
					if (currPage == 1)
						reCount = pageSize;
					else
						reCount = totalRow - (currPage - 1) * pageSize;
				}

			}
			for (int i = (currPage - 1) * pageSize; i < (currPage - 1)
					* pageSize + reCount; i++) {
				dateList.add(produceDateList.get(i));
			}
		}

		// 获取符合条件的生产日期
		// List<Map> dateMaps = loadAllProduceDate(paramMap);
		List<DailyReportProcessRatePOJO> totalList = new ArrayList<DailyReportProcessRatePOJO>();
		if (dateList != null && dateList.size() != 0) {
			for (int i = 0; i < dateList.size(); i++) {
				Map dateMap = dateList.get(i);
				String produce_date = dateMap.get("produceDate").toString();

				paramMap.put("produceDate", produce_date);
				DailyReportProcessRatePOJO dailyReportProcessRate = findDailyReportProcessByProject(paramMap);
				totalList.add(dailyReportProcessRate);
			}
		}

		msg.setValue("pageSize", pageSize1);// 页面记录条数
		msg.setValue("cur", cur);// 当前页码
		msg.setValue("totalRows", totalRows);// 记录总数2
		msg.setValue("totalList", totalList);// 日报进度信息列表2
		msg.setValue("projectInfoNo", projectInfoNo);// 项目编号
		msg.setValue("projectType", projectType);// 项目类型
		msg.setValue("explorationMethod", explorationMethod);// 勘探类型
		msg.setValue("startDate", startDate);// 生产日期开始时间
		msg.setValue("endDate", endDate);// 生产日期结束时间

		return msg;
	}

	/**
	 * 查找所有符合条件的不重复的的生产日期
	 * 
	 * @param map
	 *            Map 表单参数
	 * @return list List 日报生产日期列表
	 * @throws 无
	 */
	public List loadAllProduceDate(Map map) {

		String projectInfoNo = (String) map.get("projectInfoNo");
		String produceDate = (String) map.get("produceDate");
		String startDate = (String) map.get("startDate");
		String endDate = (String) map.get("endDate");
		String explorationMethod = (String) map.get("explorationMethod");

		// 如果为空，说明是按项目；如果不为空，说明是按项目的施工队伍
		String orgId = (String) map.get("orgId");

		if (projectInfoNo == null) {
			projectInfoNo = "";
		}
		if (produceDate == null) {
			produceDate = "";
		}
		if (startDate == null) {
			startDate = "";
		}
		if (endDate == null) {
			endDate = "";
		}
		if (orgId == null) {
			orgId = "";
		}
		if (explorationMethod == null) {
			explorationMethod = "";
		}

		String sqlDates = "select distinct t1.produce_date from gp_ops_daily_report t1 left outer join gp_task_project gp on t1.project_info_no = gp.project_info_no where t1.audit_status = '3' and t1.bsflag = '0' and gp.bsflag = '0'";

		if (!orgId.equals("")) {

			sqlDates = sqlDates + " and t1.org_id = '" + orgId + "'";
		}
		if (!projectInfoNo.equals("")) {

			sqlDates = sqlDates + " and t1.project_info_no = '" + projectInfoNo
					+ "'";
		}
		if (!startDate.equals("")) {

			sqlDates = sqlDates + " and t1.produce_date >= to_date('"
					+ startDate + "','yyyy-mm-dd')";
		}

		if (!endDate.equals("")) {

			sqlDates = sqlDates
					+ " and TO_CHAR(t1.produce_date,'YYYY-MM-DD') <= '"
					+ endDate + "'";
		}
		if (!explorationMethod.equals("")) {

			sqlDates = sqlDates + " and t1.exploration_method= '"
					+ explorationMethod + "'";
		}

		sqlDates = sqlDates + "order by t1.produce_date desc";

		log.debug("the sql is:" + sqlDates);

		List list = jdbcDao.queryRecords(sqlDates);

		return list;
	}

	/**
	 * 如果Long格式为空，转换为０
	 * 
	 * @param par
	 *            Long 转换前的数据
	 * @return par Long 转换后的数据
	 * @throws 无
	 */
	public static Long nullToLong(Long par) {
		if (par == null) {
			return new Long(0);
		} else {
			try {
				return par;
			} catch (Exception e) {
				e.printStackTrace();
				return new Long(0);
			}
		}
	}

	/**
	 * 按项目查找日报进度信息
	 * 
	 * @param map
	 *            Map 表单参数
	 * @return dailyReportProcessRatePOJO DailyReportProcessRatePOJO 日报进度信息对象
	 * @throws 无
	 */
	public DailyReportProcessRatePOJO findDailyReportProcessByProject(Map map) {

		log.debug("进入 GpOpsDailyReportDAO 的 findDailyReportProcessByProject 方法.....");
		log.debug("The map is:" + map);

		String projectInfoNo = (String) map.get("projectInfoNo");
		String projectType = (String) map.get("projectType");
		String produceDate = (String) map.get("produceDate");
		String explorationMethod = (String) map.get("explorationMethod");
		String explorationMethod1 = "";
		if (explorationMethod1 != null) {
			explorationMethod1 = explorationMethod;
			if (explorationMethod1 == "2" || "2".equals(explorationMethod1)) {
				explorationMethod1 = "0300100012000000002";
			} else {
				explorationMethod1 = "0300100012000000003";
			}
		}

		if (produceDate == null) {
			produceDate = "";
		}
		if (projectInfoNo == null) {
			projectInfoNo = "";
		}

		DailyReportProcessRatePOJO dpProcess = new DailyReportProcessRatePOJO();

		// 生产日期
		dpProcess.setProductDate(produceDate);

		// 查询已提交的日报主表信息
		String sqlReport = " select dr.* from gp_ops_daily_report dr left outer join gp_task_project gp on dr.project_info_no = gp.project_info_no where dr.bsflag = '0' and gp.bsflag = '0' and dr.audit_status = '3'";
		if (projectInfoNo != "") {
			sqlReport = sqlReport + " and dr.project_info_no = '"
					+ projectInfoNo + "'";
		}
		if (produceDate != "") {
			sqlReport = sqlReport + " and dr.produce_date =  TO_DATE('"
					+ produceDate + "','YYYY-MM-DD')";
		}

		List<Map> listReport = jdbcDao.queryRecords(sqlReport);

		if (listReport == null || listReport.isEmpty()) {

			log.debug("离开 GpOpsDailyReportDAO 的 findDailyReportProcessByProject 方法.....");

			return dpProcess;
		}

		long acquireShot = (long) 0;// 采集日完成点数震源炮点数+井炮炮点数+气枪炮点数
		long drillShot = (long) 0;// 钻井日完成点数
		long surfaceShot = (long) 0;// 表层日完成点数=小折射日完成点数+微测井日完成点数
		long surveyShotNum = (long) 0;// 测量日完成炮点数
		long surveyGeophoneNum = (long) 0;// 测量日完成检波点数

		for (int j = 0; j < listReport.size(); j++) {

			// GpOpsDailyReport dailyReport =
			// (GpOpsDailyReport)listReport.get(j);
			Map dailyReport = listReport.get(j);
			acquireShot = acquireShot
					+ nullToLong(Long.valueOf(dailyReport.get(
							"dailyAcquireSpNum").toString() != "" ? dailyReport
							.get("dailyAcquireSpNum").toString() : "0"))
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailyJpAcquireShotNum")
									.toString() != "" ? dailyReport.get(
									"dailyJpAcquireShotNum").toString() : "0"))
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailyQqAcquireShotNum")
									.toString() != "" ? dailyReport.get(
									"dailyQqAcquireShotNum").toString() : "0"));
			drillShot = drillShot
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailyDrillSpNum")
									.toString() != "" ? dailyReport.get(
									"dailyDrillSpNum").toString() : "0"));
			surfaceShot = surfaceShot
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailySmallRefractionNum")
									.toString() != "" ? dailyReport.get(
									"dailySmallRefractionNum").toString() : "0"))
					+ nullToLong(Long
							.valueOf(dailyReport
									.get("dailyMicroMeasuePointNum").toString() != "" ? dailyReport
									.get("dailyMicroMeasuePointNum").toString()
									: "0"));
			surveyShotNum = surveyShotNum
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailySurveyShotNum")
									.toString() != "" ? dailyReport.get(
									"dailySurveyShotNum").toString() : "0"));
			surveyGeophoneNum = surveyGeophoneNum
					+ nullToLong(Long
							.valueOf(dailyReport.get("dailySurveyGeophoneNum")
									.toString() != "" ? dailyReport.get(
									"dailySurveyGeophoneNum").toString() : "0"));
		}

		// 将日完成点数置进所拼pojo
		dpProcess.setCollShotNum(String.valueOf(acquireShot));
		dpProcess.setDrillShotNum(String.valueOf(drillShot));
		dpProcess.setSurfacePointNo(String.valueOf(surfaceShot));
		dpProcess.setSurveyShotNum(String.valueOf(surveyShotNum));
		dpProcess.setSurveyGeophoneNum(String.valueOf(surveyGeophoneNum));

		// 查找各项项目累计值
		String sql1 = "select nvl(sum(nvl(t1.daily_acquire_sp_num,0)),0) as projectAcquireSpNum1 ,"
				+ "nvl(sum(nvl(t1.daily_micro_measue_point_num,0)),0) as projectMicroMeasueNum,"
				+ "nvl(sum(nvl(t1.daily_small_refraction_num,0)),0) as projectSmallRefractionNum ,"
				+ "nvl(sum(nvl(t1.daily_survey_shot_num,0)),0) as projectSurveyShotNum ,"
				+ "nvl(sum(nvl(t1.daily_survey_geophone_num,0)),0) as projectSurveyGeophoneNum ,"
				+ "nvl(sum(nvl(t1.daily_drill_sp_num,0)),0) as projectDrillSpNum ,"
				+ "nvl(sum(nvl(t1.daily_jp_acquire_shot_num,0)),0) as projectAcquireSpNum2,"
				+ "nvl(sum(nvl(t1.daily_qq_acquire_shot_num,0)),0) as projectAcquireSpNum3 "
				+ "from gp_ops_daily_report t1 left outer join gp_task_project gp on "
				+ "t1.project_info_no = gp.project_info_no "
				+ "where t1.bsflag = '0' and gp.bsflag = '0' ";
		if (projectInfoNo != "") {
			sql1 = sql1 + " and t1.project_info_no = '" + projectInfoNo + "'";
		}
		if (produceDate != "") {
			sql1 = sql1 + " and TO_CHAR(t1.produce_date,'YYYY-MM-DD') <= '"
					+ produceDate + "'";
		}

		List<Map> listsql1 = jdbcDao.queryRecords(sql1);

		// 没有符合条件的记录
		if (listsql1 == null || listsql1.isEmpty()) {

			return dpProcess;
		}
		Long projectAcquireSpNum1 = (long) 0;
		Long projectAcquireSpNum2 = (long) 0;
		Long projectAcquireSpNum3 = (long) 0;
		Long projectAcquireSpNum = (long) 0;

		Long projectMicroMeasueNum = (long) 0;
		Long projectSmallRefractionNum = (long) 0;
		Long projectSurveyShotNum = (long) 0;
		Long projectSurveyGeophoneNum = (long) 0;
		Long projectDrillSpNum = (long) 0;

		Map listsqlMap = listsql1.get(0);
		if (listsqlMap != null) {
			projectAcquireSpNum1 = Long.valueOf(listsqlMap.get(
					"projectacquirespnum1").toString());
			projectAcquireSpNum2 = Long.valueOf(listsqlMap.get(
					"projectacquirespnum2").toString());
			projectAcquireSpNum3 = Long.valueOf(listsqlMap.get(
					"projectacquirespnum3").toString());
			projectAcquireSpNum = projectAcquireSpNum1 + projectAcquireSpNum2
					+ projectAcquireSpNum3;

			projectMicroMeasueNum = Long.valueOf(listsqlMap.get(
					"projectmicromeasuenum").toString());
			projectSmallRefractionNum = Long.valueOf(listsqlMap.get(
					"projectsmallrefractionnum").toString());
			projectSurveyShotNum = Long.valueOf(listsqlMap.get(
					"projectsurveyshotnum").toString());
			projectSurveyGeophoneNum = Long.valueOf(listsqlMap.get(
					"projectsurveygeophonenum").toString());
			projectDrillSpNum = Long.valueOf(listsqlMap
					.get("projectdrillspnum").toString());
		}

		// 将累计工作量置进所拼pojo中
		dpProcess.setCollFinishedSpNum(String.valueOf(projectAcquireSpNum));
		dpProcess.setSurfaceFinishedSpNum(String.valueOf(projectMicroMeasueNum
				+ projectSmallRefractionNum));
		dpProcess.setSurveyFinishedSpNum(String.valueOf(projectSurveyShotNum
				+ projectSurveyGeophoneNum));
		dpProcess.setDrillFinishedSpNum(String.valueOf(projectDrillSpNum));

		String sql2 = "";
		log.debug("the explorationMethod is:" + explorationMethod);
		// 查找各项设计值：如果为二维，查找二维工区设计参数；如果为三、四维，查找三维工区设计参数
		if (explorationMethod != null
				&& explorationMethod.equals("0300100012000000002")) {
			sql2 = "select nvl(t.design_sp_num,0) as designSpNum,"
					+ "nvl(t.design_geophone_num,0) as designGeophoneNum,"
					+ "nvl(t.design_drilling_num,0) as designDrillNum,"
					+ "nvl(t.design_micro_measue_num,0) as designMicroMeasueNum,"
					+ "nvl(t.design_small_regraction_num,0) as designSmallRegractionNum"
					+ " from gp_ops_2dwa_design_basic_data t left outer join gp_task_project gp "
					+ " on t.project_info_no = gp.project_info_no where t.bsflag = '0' and gp.bsflag = '0'";
			if (projectInfoNo != "") {
				sql2 = sql2 + " and t.project_info_no = '" + projectInfoNo
						+ "'";
			}

		} else if (explorationMethod != null
				&& explorationMethod.equals("0300100012000000003")) {
			sql2 = "select nvl(t1.design_shot_num,0) as designSpNum,"
					+ "nvl(t1.receiveing_point_num,0) as designGeophoneNum,"
					+ "nvl(t1.design_drilling_num,0) as designDrillNum,"
					+ "nvl(t1.design_micro_measue_num,0) as designMicroMeasueNum,"
					+ "nvl(t1.design_small_regraction_num,0) as designSmallRegractionNum"
					+ " from gp_ops_3dwa_design_data t1 left outer join gp_task_project gp1 "
					+ " on t1.project_info_no = gp1.project_info_no where t1.bsflag = '0' and gp1.bsflag = '0'";
			if (projectInfoNo != "") {
				sql2 = sql2 + " and t1.project_info_no = '" + projectInfoNo
						+ "'";
			}
		}
		log.debug("The sql2 is:" + sql2);
		List<Map> listsql2 = jdbcDao.queryRecords(sql2);

		// 没有符合条件的记录
		if (listsql2 == null || listsql2.isEmpty()) {

			return dpProcess;
		}

		Long designSpNum = (long) 0;
		Long designGeophoneNum = (long) 0;
		Long designDrillNum = (long) 0;
		Long designMicroMeasueNum = (long) 0;
		Long designSmallRegractionNum = (long) 0;
		Map listsqlMap2 = listsql2.get(0);

		if (listsqlMap2 != null) {
			designSpNum = Long.valueOf(listsqlMap2.get("designspnum")
					.toString());
			designGeophoneNum = Long.valueOf(listsqlMap2.get(
					"designgeophonenum").toString());
			designDrillNum = Long.valueOf(listsqlMap2.get("designdrillnum")
					.toString());
			designMicroMeasueNum = Long.valueOf(listsqlMap2.get(
					"designmicromeasuenum").toString());
			designSmallRegractionNum = Long.valueOf(listsqlMap2.get(
					"designsmallregractionnum").toString());
		}

		// 计算出百分比，并四舍五入保留两位小数
		Double projectAcquireSpRatio = 0.00;
		Double projectSurfaceRatio = 0.00;
		Double projectSurveyRatio = 0.00;
		Double projectDrillSpRatio = 0.00;

		if (designSpNum != 0) {

			projectAcquireSpRatio = (double) (Math.round(10000
					* (double) projectAcquireSpNum / (double) designSpNum)) / 100;
		}

		if (designMicroMeasueNum + designSmallRegractionNum != 0) {

			projectSurfaceRatio = (double) (Math
					.round(10000
							* (double) (projectMicroMeasueNum + projectSmallRefractionNum)
							/ (double) (designMicroMeasueNum + designSmallRegractionNum))) / 100;
		}

		if (designSpNum + designGeophoneNum != 0) {

			projectSurveyRatio = (double) (Math
					.round(10000
							* (double) (projectSurveyShotNum + projectSurveyGeophoneNum)
							/ (double) (designSpNum + designGeophoneNum))) / 100;
		}

		if (designDrillNum != 0) {

			projectDrillSpRatio = (double) (Math.round(10000
					* (double) projectDrillSpNum / (double) designDrillNum)) / 100;
		}

		// 将完成百分比置进所拼pojo中
		dpProcess.setCollFinishedRate(String.valueOf(projectAcquireSpRatio));
		dpProcess.setSurfaceFinishedRate(String.valueOf(projectSurfaceRatio));
		dpProcess.setSurveyFinishedRate(String.valueOf(projectSurveyRatio));
		dpProcess.setDrillFinishedRate(String.valueOf(projectDrillSpRatio));

		log.debug("操作成功，离开 GpOpsDailyReportDAO 的 findDailyReportProcessByProject 方法.....");

		return dpProcess;
	}

	/**
	 * 删除日报数据
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteDailyReport(ISrvMsg isrvmsg) throws Exception {
		System.out.println("deleteDailyReport !");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);

		String dailyNos = isrvmsg.getValue("dailyNos");
		String[] params = dailyNos.split(",");
		String updateSql = "";
		String updateSurface = "";
		String updateSurvey = "";
		String updateAcquire = "";
		String updateDrill = "";
		String updateSit = "";
		String getReportInfoSql = "";
		String updateDailyWorkloadSql = "";
		String updateReportQuestion = "";

		if (dailyNos != null) {
			for (String id : params) {
				// 删除对应日期的工作量分配和日报对应的问题
				getReportInfoSql = "select r.project_info_no,r.produce_date from gp_ops_daily_report_ws r where r.bsflag = '0' and r.daily_no_ws = '"
						+ id + "'";
				Map reportInofMap = radDao.queryRecordBySQL(getReportInfoSql);
				if (reportInofMap != null) {
					updateReportQuestion = "update gp_ops_daily_question w set w.bsflag = '1' where w.project_info_no = '"
							+ reportInofMap.get("project_info_no")
							+ "' and w.produce_date = to_date('"
							+ reportInofMap.get("produce_date")
							+ "','yyyy-MM-dd')";
					radDao.executeUpdate(updateReportQuestion);
					updateDailyWorkloadSql = "update bgp_p6_workload w set w.bsflag = '1' where w.project_info_no = '"
							+ reportInofMap.get("project_info_no")
							+ "' and w.produce_date = to_date('"
							+ reportInofMap.get("produce_date")
							+ "','yyyy-MM-dd')";
					radDao.executeUpdate(updateDailyWorkloadSql);
				}

				updateSql = "update gp_ops_daily_report_ws g set g.bsflag='1' where g.daily_no_ws='"
						+ id + "'";
				radDao.executeUpdate(updateSql);
		
			}
		}
		return responseDTO;

	}

	/**
	 * 重新读取计划日效
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg refreshDailyPlan(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String checkSql = "select p.pro_plan_id from gp_proj_product_plan p where p.bsflag = '0' and p.project_info_no = '"
				+ projectInfoNo + "'";
		if (radDao.queryRecords(checkSql) != null
				&& radDao.queryRecords(checkSql).size() > 0) {
			String delDailyPlanSql = "update gp_proj_product_plan p set p.bsflag = '1' where p.project_info_no = '"
					+ projectInfoNo + "'";
			if (radDao.executeUpdate(delDailyPlanSql) > 0) {
				List list = countDailyPlan(projectInfoNo);
				msg.setValue("allList", list.get(0));
				msg.setValue("measuredailylist", list.get(1));
				msg.setValue("drilldailylist", list.get(2));
				msg.setValue("colldailylist", list.get(3));
			}
		} else {
			List list = countDailyPlan(projectInfoNo);
			msg.setValue("allList", list.get(0));
			msg.setValue("measuredailylist", list.get(1));
			msg.setValue("drilldailylist", list.get(2));
			msg.setValue("colldailylist", list.get(3));
		}
		msg.setValue("hasSaved", "0");
		return msg;
	}
	/**
	 * 获取项目的施工队伍
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProjectTeamName(ISrvMsg reqDTO) throws Exception{
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
 
		
		//如果队伍都在一条记录里,如下
		  ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
	      String getTeamSql = "select d.org_id from gp_task_project_dynamic d where d.bsflag = '0' and d.project_info_no = '"+projectInfoNo+"'";
	      Map projectInfoMap = radDao.queryRecordBySQL(getTeamSql);
	      if(projectInfoMap != null){
	    	  String teamName = "";
	    	  String orgIdParmas = "";
	    	  String orgId = projectInfoMap.get("org_id").toString();
	    	  String[] orgIds = orgId.split(",");
	    	  int orgLength = orgIds.length;
	    	  if(orgLength == 1){
	    		  String getTeamNameSlq = "select i.org_name from comm_org_information i where i.bsflag = '0' and i.org_id = '"+orgId+"'";
	    		  Map teamNameMap = radDao.queryRecordBySQL(getTeamNameSlq);
	    		  if(teamNameMap != null){
	    			  teamName = teamNameMap.get("org_name").toString();
	    		  }
	    	  }else if(orgLength >= 2){
	    		  for(int i=0;i<orgLength;i++){
	    			  orgIdParmas += ",'"+orgIds[i]+"'";
	    		  }
	    		  orgIdParmas = orgIdParmas.substring(1, orgIdParmas.length());
	    		  String getTeamNameSlq = "select wm_concat(i.org_abbreviation) as teams from comm_org_information i where i.bsflag = '0' and i.org_id in ("+orgIdParmas+")";
	    		  Map teamNameMap = radDao.queryRecordBySQL(getTeamNameSlq);
	    		  if(teamNameMap != null){
	    			  teamName = teamNameMap.get("teams").toString();
	    		  }
	    	  }
	    	  
	      	msg.setValue("teamName", teamName);
	      }
		
        return msg;
	}
	
	//---------------------------------------------------------------------------------------------------
	public ISrvMsg addReport(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		Map map = reqDTO.toMap();
 
		String projectInfoNo =user.getProjectInfoNo();
		map.put("project_info_no", projectInfoNo);
		map.put("AUDIT_STATUS", 1);
		map.put("bsflag",0);
		
 

		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map, "BGP_WS_DAILY_REPORT");
        msg.setValue("bcStuts", "ok");
		return msg;
	}
	
	public Map getFatherNo(String projectInfoNo) throws Exception {
 
		String sql="select * from gp_task_project t where t.project_info_no='"+projectInfoNo+"' and t.project_father_no is not null";

		Map  map = jdbcDao.queryRecordBySQL(sql);

		return map;
	}
	
//	public ISrvMsg getYearReport(ISrvMsg  reqDTO) throws Exception {
//		UserToken user = reqDTO.getUserToken();
//		String projectInfoNo = "";
//		String startDate = (String) reqDTO.getValue("startDate");
//		String endDate = (String) reqDTO.getValue("endDate");
//		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
//	 
//		 StringBuffer sb =new StringBuffer();
//		 
//		 sb.append("  select distinct * from( select  rp.project_info_no ,rp.org_name,rp.basin,rp.well_number,rp.start_date,rp.end_date,rp.remarks, s.num,j.instrument_model"+
//         " from bgp_ws_daily_report rp left join gp_task_project j on j.project_info_no=rp.project_info_no and j.bsflag='0' ,    (select t.project_info_no, count(t.view_type) num    from bgp_ws_daily_report t where t.bsflag='0'"+
//          " group by t.project_info_no ) s  where s.project_info_no = rp.project_info_no  and rp.bsflag='0' ");
//		  if(!"".equals(startDate)){
//			  sb.append( "and rp.start_date >= to_date('"+startDate+"', 'yyyy-mm-dd')");
//		  }	
//		 if(!"".equals(endDate)){
//			  sb.append( " and rp.start_date <= to_date('"+endDate+"', 'yyyy-mm-dd')");
//		 }
//		 sb.append(" order by rp.start_date ) r  ");
//		
//      
//
//		 List<Map> list2 = jdbcDao.queryRecords(sb.toString());
//			
//			
//			for(int i=0;i<list2.size();i++){
//				Map map=list2.get(i);
//				String  viewType="$";
//				String viewWells="$";
//				String viewPoint="$";
//				String buildMethod="$";
//				String collectionSeries="$";
//				String shotNumber="$";
//				String testRecord="$";
//				String obsPoint="$";
//				String passPoint="$";
//				String passRate="$";
//				  String sql="select t.view_type,t.project_info_no,    t.view_wells,  t.view_point, t.build_method,  t.collection_series,  t.shot_number,    t.test_record,"+
//                  " t.obs_point,t.pass_point,t.pass_rate from bgp_ws_daily_report t  "
//                  + " where t.bsflag='0' and t.project_info_no = '"+map.get("projectInfoNo")+"'   order by t.view_type";
//				  List<Map> list = jdbcDao.queryRecords(sql);
//				  for(int j=0;j<list.size();j++){
//					  Map mapView=list.get(j);
//				        projectInfoNo=(String) mapView.get("projectInfoNo");
//				       
//				        	if(viewType.equals("$")){
//				        		viewType=(String) mapView.get("viewType");
//				        	}else{
//				        		viewType=viewType+","+(String) mapView.get("viewType");
//				        	}
//				        	if(viewWells.equals("$")){
//				        		viewWells=(String) mapView.get("viewWells");
//				        	}else{
//				        		viewWells=viewWells+","+(String) mapView.get("viewWells");
//				        	}
//				        	if(viewPoint.equals("$")){
//				        		viewPoint=(String) mapView.get("viewPoint");
//				        	}else{
//				        		viewPoint=viewPoint+","+(String) mapView.get("viewPoint");
//				        	}
//				        	if(buildMethod.equals("$")){
//				        		buildMethod=(String) mapView.get("buildMethod");
//				        	}else{
//				        		buildMethod=buildMethod+","+(String) mapView.get("buildMethod");
//				        	}
//				        	if(collectionSeries.equals("$")){
//				        		collectionSeries=(String) mapView.get("collectionSeries");
//				        	} else{
//				        		collectionSeries=collectionSeries+","+(String) mapView.get("collectionSeries");
//				        	}
//				        		
//				        	 
//				        	if(shotNumber.equals("$")){
//				        		shotNumber=(String) mapView.get("shotNumber");
//				        	} 
//				        		shotNumber=shotNumber+","+(String) mapView.get("shotNumber");
//				         
//				         	if(testRecord.equals("$")){
//				         		testRecord=(String) mapView.get("testRecord");
//				        	}else{
//				        		testRecord=testRecord+","+(String) mapView.get("testRecord");
//				        	}
//				        	if(obsPoint.equals("$")){
//				        		obsPoint=(String) mapView.get("obsPoint");
//				        	}else{
//				        		obsPoint=obsPoint+","+(String) mapView.get("obsPoint");
//				        	}
//				        	if(passPoint.equals("$")){
//				        		passPoint=(String) mapView.get("passPoint");
//				        	}else{
//				        		passPoint=passPoint+","+(String) mapView.get("passPoint");
//				        	}
//				        	if(passRate.equals("$")){
//				        		passRate=(String) mapView.get("passRate");
//				        	}else{
//				        		passRate=passRate+","+(String) mapView.get("passRate");
//				        	}
//				        	
//				  }
//				   map.put("viewType", viewType);
//				   map.put("viewWells", viewWells);
//				   
//				   map.put("viewPoint", viewPoint);
//				   map.put("buildMethod", buildMethod);
//				   map.put("collectionSeries", collectionSeries);
//				   map.put("shotNumber", shotNumber);
//				   map.put("testRecord", testRecord);
//				   map.put("obsPoint", obsPoint);
//				   map.put("passPoint", passPoint);
//				   map.put("passRate", passRate);
//
//			      map.put("rowNum",list2.size()-i);
//			}
//		 
//		 
//	  msg.setValue("datas", list2);
//		return msg;
//	}




public ISrvMsg getAuditStatus(ISrvMsg  reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		 
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		 
		 String sql="select * from  bgp_ws_daily_report j  where j.bsflag='0' and j.project_info_no = '"+projectInfoNo+"'";
 
		List list = jdbcDao.queryRecords(sql);
		msg.setValue("message", list);
		return msg;
	}
	public ISrvMsg getViewType(ISrvMsg  reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		 
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		 String sql="SELECT pe1.*,seqno sequo, (SELECT count(pe.seqno) c_seqno   FROM bgp_ws_view_type pe   where pe.project_info_no = '"+projectInfoNo+"'"+
          " and pe.bsflag='0' and pe.view_type_code = pe1.view_type_code and pe.seqno=pe1.seqno)se_seqno FROM bgp_ws_view_type pe1  where pe1.bsflag='0' and pe1.project_info_no = '"+projectInfoNo+"'"+
         " order by pe1.seqno";
  
		List list = jdbcDao.queryRecords(sql);
		msg.setValue("dataList", list);
		return msg;
	}
	public ISrvMsg querViewReport(ISrvMsg  reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		PageModel page = new PageModel();
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		 
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		 String sql="select q.project_name,q.org_name, q.start_time,  q.end_time,    q.project_status,  q.project_info_no, s.proc_status as audit_status"+ 
             " from (select distinct t.project_info_no,    t.project_name,  n.org_name,  t.start_time,  t.end_time,    n.project_status "+
              "  from gp_task_project t inner join bgp_ws_daily_report n on n.project_info_no =  t.project_info_no   and n.bsflag = '0'"+
            "   where t.project_father_no is not null  and t.bsflag = '0')q left join  (select e.proc_status,e.business_id from  common_busi_wf_middle e  "+                             
           "  where e.busi_table_name = 'bgp_ws_daily_report' and e.bsflag = '0')s  on s.business_id=q.project_info_no order by  q.start_time ";
 
		  page = jdbcDao.queryRecordsBySQL(sql);
			msg.setValue("datas", page.getData());
			msg.setValue("totalRows", page.getTotalRow());
			msg.setValue("pageSize", pageSize);
		return msg;
	}
 
	public ISrvMsg refreshReport(ISrvMsg  reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo =(String) reqDTO.getValue("projectInfoNo");
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		String sql="SELECT pe1.*,replace(seqno,'~','')sequo,(SELECT count(pe.seqno) c_seqno   FROM bgp_ws_daily_report pe where pe.project_info_no = '"+projectInfoNo+"'"+
          "  and pe.bsflag = '0'  and pe.view_type_code = pe1.view_type_code and pe.seqno=pe1.seqno) se_seqno FROM bgp_ws_daily_report pe1 where pe1.bsflag = '0'"+
          "   and pe1.project_info_no = '"+projectInfoNo+"'  order by pe1.seqno";
		List list = jdbcDao.queryRecords(sql);
		msg.setValue("dataList", list);
		return msg;
	}
	





public ISrvMsg updateAustaus(ISrvMsg  reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		 
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		 
		 String sql="update bgp_ws_daily_report t set t.audit_status='2' where t.bslag='0' and  t.project_info_no='"+projectInfoNo+"'";
 
		Map  dailyMap = jdbcDao.queryRecordBySQL(sql);
		msg.setValue("datas", dailyMap);
		return msg;
	}
	public ISrvMsg getAustaus(ISrvMsg  reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		 
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		 
		 String sql="select  u.audit_status,g.proc_status  from (select distinct t.audit_status,t.project_info_no   from bgp_ws_daily_report t"+
              "   where t.bsflag = '0'    and t.project_info_no = '"+projectInfoNo+"')u left join   (select d.proc_status ,d.business_id"+
        "  from common_busi_wf_middle d   where d.business_id = '"+projectInfoNo+"'  and d.bsflag = '0'"+
          " and d.busi_table_name = 'bgp_ws_daily_report')g  on g.business_id=u.project_info_no";
 
		Map  dailyMap = jdbcDao.queryRecordBySQL(sql);
		msg.setValue("dailyMap", dailyMap);
		return msg;
	}
	
	public ISrvMsg getReport(ISrvMsg  reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		 
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		 
		 String sql="select  n.org_abbreviation as org_name,    v.workarea as basin,   ccsd.coding_name,  j.project_income,  j.View_Type, "+
         " j.build_method,   j.start_time as start_date,j.end_time as end_date, j.well_no as well_number ,   j.project_status from gp_task_project j"+
        " left join gp_task_project_dynamic c on c.project_info_no =  j.project_info_no  and c.bsflag = '0'  left join comm_org_information n on n.org_id = c.org_id"+
       "  left join gp_workarea_diviede v on v.workarea_no = j.workarea_no   left join comm_coding_sort_detail ccsd on j.manage_org = ccsd.coding_code_id"+
         " and ccsd.bsflag = '0'  where j.project_info_no = '"+projectInfoNo+"' and j.bsflag='0'";
 
		Map  dailyMap = jdbcDao.queryRecordBySQL(sql);
		msg.setValue("datas", dailyMap);
		return msg;
	}
	public ISrvMsg submitWeekReport(ISrvMsg  reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = (String) reqDTO.getValue("projectInfoNo");
		String sql="update bgp_ws_daily_report set audit_status='2'  where bsflag='0' and project_info_no='"+projectInfoNo+"'";
		jdbcTemplate.execute(sql);
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("action_status","ok");
		return msg;
	}
	

	public ISrvMsg getCheckedReport(ISrvMsg  reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = " select * from bgp_ws_daily_report where bsflag='0' and contracts_money_stauts='1' ";
		List  datas = jdbcDao.queryRecords(sql);
		msg.setValue("datas", datas);
		return msg;
	}



}
