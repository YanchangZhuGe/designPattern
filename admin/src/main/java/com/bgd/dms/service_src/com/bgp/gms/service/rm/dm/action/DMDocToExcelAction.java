package com.bgp.gms.service.rm.dm.action;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.soap.SOAPException;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

public class DMDocToExcelAction extends WSAction {
	/**
	 * 先准备数据
	 */
	@Override
	public ActionForward servieCall(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ServiceCallConfig servicecallconfig = new ServiceCallConfig();
        servicecallconfig.setServiceName("DevCommInfoSrv");
        servicecallconfig.setOperationName("createDocFile");
        
        ISrvMsg isrvmsg;
        if((isrvmsg = SrvMsgUtil.createISrvMsg(servicecallconfig.getOperationName())) == null)
        {
            return null;
        } else
        {
            setDTOValue(isrvmsg, mapping, form, request, response);
            //在这个方法这个里面统一处理
            ISrvMsg isrvmsg1 = ServiceCallFactory.getIServiceCall().callWithDTO(null, isrvmsg, servicecallconfig);
            request.setAttribute("responseDTO", isrvmsg1);
            return null;
        }
	}
	/**
	 * 浏览器推送
	 */
	@Override
	public ActionForward executeResponse(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
		//获得打印的文档类别
		String doctype = responseDTO.getValue("doctype");
		String excelName = null;
		if("ZYTPD".equals(doctype)||"FHTPD".equals(doctype)){
			excelName = saveZYTPD(responseDTO);
		}else if("ZBTPD".equals(doctype)||"ZBTPD_PL".equals(doctype)||"JBQ_PL".equals(doctype)){
			excelName = saveZBTPD(responseDTO);
		}else if("ZBCKD".equals(doctype)){
			excelName = saveZBDTCKD(responseDTO);
		}else if("ZBCKD_PL".equals(doctype)){
			excelName = saveZBPLCKD(responseDTO);
		}
    	response.setContentType("text/json; charset=utf-8");
    	
    	String ret="{returnCode:0, excelName:'"+excelName+"',showName:'"+excelName+"'}";
    	
    	response.getWriter().write(ret);
    	
    	return null;
	}


	/**
	 * 保存装备的excel 批量出库单
	 * @param responseDTO
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String saveZBPLCKD(ISrvMsg responseDTO) throws SOAPException, IOException {
		String title = responseDTO.getValue("title");
		MsgElement baseData = responseDTO.getMsgElement("baseinfo");
		List<MsgElement> detDatas = responseDTO.getMsgElements("detList");
		String excelName = baseData.getValue("outinfo_no")+".xls";//UUID.randomUUID().toString()+".xls";
		
		if(baseData!=null){
			String sheetName = "出库单";
			HSSFWorkbook wb = new HSSFWorkbook();//建立新HSSFWorkbook对象  
    		HSSFSheet sheet = wb.createSheet(sheetName);//建立新的sheet对象
    		//第二行是标题
    		HSSFRow row1 = sheet.createRow((short)1);//建立新行
    		HSSFCell cell1 = row1.createCell(0);
    		cell1.setCellValue(title);
    		sheet.addMergedRegion(new Region(1, (short)0, 1, (short)7));
    		HSSFFont row1_font = wb.createFont();
    		row1_font.setFontHeightInPoints((short)18);
    		row1_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		row1_font.setFontName("黑体");
    		HSSFCellStyle row1_style = wb.createCellStyle();
    		row1_style.setFont(row1_font);
    		row1_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell1.setCellStyle(row1_style);
    		//第三行 到 第六行 是单子基本信息
    		HSSFFont row3_font = wb.createFont();
    		row3_font.setFontHeightInPoints((short)12);
    		row3_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle row3_style = wb.createCellStyle();
    		row3_style.setFont(row3_font);
    		row3_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		HSSFRow row2 = sheet.createRow((short)2);//建立新行
    		HSSFCell cell20 = row2.createCell(0);
    		cell20.setCellValue("转出单位:");
    		cell20.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)0, 2, (short)1));
    		HSSFCell cell22 = row2.createCell(2);
    		if(baseData.getValue("devouttype").toString().equals("2")){
    			cell22.setCellValue(baseData.getValue("inorgname"));
    		}
    		else{
    			cell22.setCellValue(baseData.getValue("outorgname"));
    		}
    		cell22.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)2, 2, (short)3));
    		HSSFCell cell212 = row2.createCell(5);
    		cell212.setCellValue(baseData.getValue("outinfo_no"));
    		cell212.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)5, 2, (short)7));
    		HSSFRow row3 = sheet.createRow((short)3);//建立新行
    		HSSFRow row4 = sheet.createRow((short)4);//建立新行
    		HSSFCell cell40 = row4.createCell(0);
    		cell40.setCellValue("转入单位:");
    		cell40.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)0, 4, (short)1));
    		HSSFCell cell42 = row4.createCell(2);
    		if(baseData.getValue("devouttype").toString().equals("2")){
    			cell42.setCellValue(baseData.getValue("outorgname"));
    		}
    		else{
    			cell42.setCellValue(baseData.getValue("inorgname"));
    		}
    		cell42.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)2, 4, (short)3));
    		HSSFCell cell412 = row4.createCell(5);
    		cell412.setCellValue(baseData.getValue("mixdate"));
    		cell412.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)5, 4, (short)7));
    		HSSFRow row5 = sheet.createRow((short)5);//建立新行
    		
    		//写标题
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		//font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		String[] titleArrays = new String[]{"序号","设备名称","型号及规格","单位",
    				"数量","技术状况","存放地","备注"};
    		// 建立表头
    		HSSFFont rowdettitle_font = wb.createFont();
    		rowdettitle_font.setFontHeightInPoints((short)12);
    		rowdettitle_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		rowdettitle_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle rowdettitle_Style = wb.createCellStyle();
    		rowdettitle_Style.setFont(rowdettitle_font);
    		rowdettitle_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdettitle_Style.setBorderBottom((short)1);
    		rowdettitle_Style.setBorderLeft((short)1);
    		rowdettitle_Style.setBorderRight((short)1);
    		rowdettitle_Style.setBorderTop((short)1);
    		HSSFRow row6 = sheet.createRow((short)6);//建立新行
    		for(int j=0;j<8;j++){
    			HSSFCell cell = row6.createCell(j);//建立新cell
				cell.setCellValue(titleArrays[j]);
				cell.setCellStyle(style);
				cell.setCellStyle(rowdettitle_Style);
    		}
    		// 建立具体数据
    		int detSize = detDatas.size();
    		HSSFFont rowdetcontent_font = wb.createFont();
    		rowdetcontent_font.setFontHeightInPoints((short)12);
    		rowdetcontent_font.setFontName("宋体");
    		HSSFCellStyle rowdetcontent_Style = wb.createCellStyle();
    		rowdetcontent_Style.setFont(rowdetcontent_font);
    		rowdetcontent_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdetcontent_Style.setBorderBottom((short)1);
    		rowdetcontent_Style.setBorderLeft((short)1);
    		rowdetcontent_Style.setBorderRight((short)1);
    		rowdetcontent_Style.setBorderTop((short)1);
    		for(int i=0;i<detSize;i++){
    			MsgElement data = detDatas.get(i);
    			HSSFRow row = sheet.createRow((short)(i+7));//建立新行
    			//创建16个内容
				HSSFCell detcell0 = row.createCell(0);//序号
				detcell0.setCellValue(i+1);
				detcell0.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell1 = row.createCell(1);//设备名称
				detcell1.setCellValue(data.getValue("dev_name"));
				detcell1.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell2 = row.createCell(2);//规格型号
				detcell2.setCellValue(data.getValue("dev_model"));
				detcell2.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell3 = row.createCell(3);//单位
				detcell3.setCellValue(data.getValue("unit_name"));
				detcell3.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell4 = row.createCell(4);//数量
				detcell4.setCellValue(data.getValue("out_num"));
				detcell4.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell5 = row.createCell(5);//
				detcell5.setCellValue("");
				detcell5.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell6 = row.createCell(6);//
				detcell6.setCellValue("");
				detcell6.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell7 = row.createCell(7);//备注
				detcell7.setCellValue("");
				detcell7.setCellStyle(rowdetcontent_Style);
    		}
    		//后面在加写乱七八糟的信息
    		HSSFFont rowlast_font = wb.createFont();
    		rowlast_font.setFontHeightInPoints((short)12);
    		rowlast_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle rowlast_Style = wb.createCellStyle();
    		rowlast_Style.setFont(rowlast_font);
    		//rowlast_Style.setBorderBottom((short)1);
    		//rowlast_Style.setBorderLeft((short)1);
    		//rowlast_Style.setBorderRight((short)1);
    		//rowlast_Style.setBorderTop((short)1);
    		HSSFRow row_last1 = sheet.createRow((short)(detSize+7));//建立新行
    		HSSFCell cell_last10 = row_last1.createCell(0);
    		row_last1.createCell(1);
    		row_last1.createCell(2);
    		row_last1.createCell(3);
    		cell_last10.setCellValue("出库依据：");
    		cell_last10.setCellStyle(rowlast_Style);
    		sheet.addMergedRegion(new Region(detSize+7, (short)0, detSize+7, (short)3));
    		HSSFCell cell_last19 = row_last1.createCell(4);
    		cell_last19.setCellValue("制表：");
    		cell_last19.setCellStyle(rowlast_Style);
    		row_last1.createCell(5);
    		row_last1.createCell(6);
    		row_last1.createCell(7);
    		sheet.addMergedRegion(new Region(detSize+7, (short)4, detSize+7, (short)7));
    		HSSFRow row_last3 = sheet.createRow((short)(detSize+8));//建立新行
    		HSSFCell cell_last30 = row_last3.createCell(0);
    		cell_last30.setCellValue("调出单位（资产移交人)：");
    		cell_last30.setCellStyle(rowlast_Style);
    		row_last3.createCell(1);
    		row_last3.createCell(2);
    		row_last3.createCell(3);
    		sheet.addMergedRegion(new Region(detSize+8, (short)0, detSize+8, (short)3));
    		HSSFCell cell_last39 = row_last3.createCell(4);
    		cell_last39.setCellValue("调入单位(资产接收人):");
    		cell_last39.setCellStyle(rowlast_Style);
    		row_last3.createCell(5);
    		row_last3.createCell(6);
    		row_last3.createCell(7);
    		sheet.addMergedRegion(new Region(detSize+8, (short)4, detSize+8, (short)7));
    		HSSFRow row_last5 = sheet.createRow((short)(detSize+9));//建立新行
    		HSSFCell cell_last50 = row_last5.createCell(0);
    		cell_last50.setCellValue("单位领导：");
    		cell_last50.setCellStyle(rowlast_Style);
    		row_last3.createCell(1);
    		row_last3.createCell(2);
    		row_last3.createCell(3);
    		sheet.addMergedRegion(new Region(detSize+8, (short)4, detSize+9, (short)7));
    		// 设置列宽，自动 
    		for(int j=0;j<titleArrays.length;j++){
				sheet.autoSizeColumn(j, true); // 自动计算列宽
				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // 设置列宽为自动值的1.5倍
    		}
    		
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/dm/"+excelName);
			
			OutputStream os = new FileOutputStream(file);
    		
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}
	/**
	 * 保存装备的excel调配单
	 * @param responseDTO
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String saveZBDTCKD(ISrvMsg responseDTO) throws SOAPException, IOException {
		String title = responseDTO.getValue("title");
		MsgElement baseData = responseDTO.getMsgElement("baseinfo");
		List<MsgElement> detDatas = responseDTO.getMsgElements("detList");
		String excelName = baseData.getValue("outinfo_no")+".xls";//UUID.randomUUID().toString()+".xls";
		if(baseData!=null){
			String sheetName = "出库单";
			HSSFWorkbook wb = new HSSFWorkbook();//建立新HSSFWorkbook对象  
    		HSSFSheet sheet = wb.createSheet(sheetName);//建立新的sheet对象
    		//第二行是标题
    		HSSFRow row1 = sheet.createRow((short)1);//建立新行
    		HSSFCell cell1 = row1.createCell(0);
    		cell1.setCellValue(title);
    		sheet.addMergedRegion(new Region(1, (short)0, 1, (short)15));
    		HSSFFont row1_font = wb.createFont();
    		row1_font.setFontHeightInPoints((short)18);
    		row1_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		row1_font.setFontName("黑体");
    		HSSFCellStyle row1_style = wb.createCellStyle();
    		row1_style.setFont(row1_font);
    		row1_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell1.setCellStyle(row1_style);
    		//第三行 到 第六行 是单子基本信息
    		HSSFFont row3_font = wb.createFont();
    		row3_font.setFontHeightInPoints((short)12);
    		row3_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle row3_style = wb.createCellStyle();
    		row3_style.setFont(row3_font);
    		row3_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		HSSFRow row2 = sheet.createRow((short)2);//建立新行
    		HSSFCell cell20 = row2.createCell(0);
    		cell20.setCellValue("转出单位:");
    		cell20.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)0, 2, (short)1));
    		HSSFCell cell22 = row2.createCell(2);
    		cell22.setCellValue(baseData.getValue("outorgname"));
    		cell22.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)2, 2, (short)3));
    		HSSFCell cell212 = row2.createCell(12);
    		cell212.setCellValue(baseData.getValue("outinfo_no"));
    		cell212.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)12, 2, (short)15));
    		HSSFRow row3 = sheet.createRow((short)3);//建立新行
    		HSSFRow row4 = sheet.createRow((short)4);//建立新行
    		HSSFCell cell40 = row4.createCell(0);
    		cell40.setCellValue("转入单位:");
    		cell40.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)0, 4, (short)1));
    		HSSFCell cell42 = row4.createCell(2);
    		cell42.setCellValue(baseData.getValue("inorgname"));
    		cell42.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)2, 4, (short)3));
    		HSSFCell cell412 = row4.createCell(12);
    		cell412.setCellValue(baseData.getValue("mixdate"));
    		cell412.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)12, 4, (short)15));
    		HSSFRow row5 = sheet.createRow((short)5);//建立新行
    		
    		//写标题
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		//font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		String[] titleArrays = new String[]{"序号","设备名称","型号及规格","单位",
    				"数量","资产编号","实物标识号","自编号","牌照号","底盘号",
    				"行驶证","附加费","营运证","技术状况","存放地","备注"};
    		// 建立表头
    		HSSFFont rowdettitle_font = wb.createFont();
    		rowdettitle_font.setFontHeightInPoints((short)12);
    		rowdettitle_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		rowdettitle_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle rowdettitle_Style = wb.createCellStyle();
    		rowdettitle_Style.setFont(rowdettitle_font);
    		rowdettitle_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdettitle_Style.setBorderBottom((short)1);
    		rowdettitle_Style.setBorderLeft((short)1);
    		rowdettitle_Style.setBorderRight((short)1);
    		rowdettitle_Style.setBorderTop((short)1);
    		HSSFRow row6 = sheet.createRow((short)6);//建立新行
    		for(int j=0;j<16;j++){
    			HSSFCell cell = row6.createCell(j);//建立新cell
				cell.setCellValue(titleArrays[j]);
				cell.setCellStyle(style);
				cell.setCellStyle(rowdettitle_Style);
    		}
    		// 建立具体数据
    		int detSize = detDatas.size();
    		HSSFFont rowdetcontent_font = wb.createFont();
    		rowdetcontent_font.setFontHeightInPoints((short)12);
    		rowdetcontent_font.setFontName("宋体");
    		HSSFCellStyle rowdetcontent_Style = wb.createCellStyle();
    		rowdetcontent_Style.setFont(rowdetcontent_font);
    		rowdetcontent_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdetcontent_Style.setBorderBottom((short)1);
    		rowdetcontent_Style.setBorderLeft((short)1);
    		rowdetcontent_Style.setBorderRight((short)1);
    		rowdetcontent_Style.setBorderTop((short)1);
    		for(int i=0;i<detSize;i++){
    			MsgElement data = detDatas.get(i);
    			HSSFRow row = sheet.createRow((short)(i+7));//建立新行
    			//创建16个内容
				HSSFCell detcell0 = row.createCell(0);//序号
				detcell0.setCellValue(i+1);
				detcell0.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell1 = row.createCell(1);//设备名称
				detcell1.setCellValue(data.getValue("dev_name"));
				detcell1.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell2 = row.createCell(2);//规格型号
				detcell2.setCellValue(data.getValue("dev_model"));
				detcell2.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell3 = row.createCell(3);//单位
				detcell3.setCellValue(data.getValue("unit_name"));
				detcell3.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell4 = row.createCell(4);//数量
				detcell4.setCellValue("1");
				detcell4.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell5 = row.createCell(5);//资产编号
				detcell5.setCellValue(data.getValue("asset_coding"));
				detcell5.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell6 = row.createCell(6);//实物标识号
				detcell6.setCellValue(data.getValue("dev_sign"));
				detcell6.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell7 = row.createCell(7);//自编号
				detcell7.setCellValue(data.getValue("self_num"));
				detcell7.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell8 = row.createCell(8);//实物标识号
				detcell8.setCellValue(data.getValue("license_num"));
				detcell8.setCellStyle(rowdetcontent_Style);
				//后面的先放空。
				HSSFCell detcell9 = row.createCell(9);//
				detcell9.setCellValue("");
				detcell9.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell10 = row.createCell(10);//
				detcell10.setCellValue("");
				detcell10.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell11 = row.createCell(11);//
				detcell11.setCellValue("");
				detcell11.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell12 = row.createCell(12);//
				detcell12.setCellValue("");
				detcell12.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell13 = row.createCell(13);//
				detcell13.setCellValue("");
				detcell13.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell14 = row.createCell(14);//
				detcell14.setCellValue("");
				detcell14.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell15 = row.createCell(15);//
				detcell15.setCellValue("");
				detcell15.setCellStyle(rowdetcontent_Style);
    		}
    		//后面在加写乱七八糟的信息
    		HSSFFont rowlast_font = wb.createFont();
    		rowlast_font.setFontHeightInPoints((short)12);
    		rowlast_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle rowlast_Style = wb.createCellStyle();
    		rowlast_Style.setFont(rowlast_font);
    		//rowlast_Style.setBorderBottom((short)1);
    		//rowlast_Style.setBorderLeft((short)1);
    		//rowlast_Style.setBorderRight((short)1);
    		//rowlast_Style.setBorderTop((short)1);
    		HSSFRow row_last1 = sheet.createRow((short)(detSize+7));//建立新行
    		HSSFCell cell_last10 = row_last1.createCell(0);
    		row_last1.createCell(1);
    		row_last1.createCell(2);
    		row_last1.createCell(3);
    		row_last1.createCell(4);
    		row_last1.createCell(5);
    		row_last1.createCell(6);
    		row_last1.createCell(7);
    		row_last1.createCell(8);
    		cell_last10.setCellValue("出库依据：");
    		cell_last10.setCellStyle(rowlast_Style);
    		sheet.addMergedRegion(new Region(detSize+7, (short)0, detSize+7, (short)8));
    		HSSFCell cell_last19 = row_last1.createCell(9);
    		cell_last19.setCellValue("制表：");
    		cell_last19.setCellStyle(rowlast_Style);
    		row_last1.createCell(10);
    		row_last1.createCell(11);
    		row_last1.createCell(12);
    		row_last1.createCell(13);
    		row_last1.createCell(14);
    		row_last1.createCell(15);
    		sheet.addMergedRegion(new Region(detSize+7, (short)9, detSize+7, (short)15));
    		HSSFRow row_last3 = sheet.createRow((short)(detSize+8));//建立新行
    		HSSFCell cell_last30 = row_last3.createCell(0);
    		cell_last30.setCellValue("调出单位（资产移交人)：");
    		cell_last30.setCellStyle(rowlast_Style);
    		row_last3.createCell(1);
    		row_last3.createCell(2);
    		row_last3.createCell(3);
    		row_last3.createCell(4);
    		row_last3.createCell(5);
    		row_last3.createCell(6);
    		row_last3.createCell(7);
    		row_last3.createCell(8);
    		sheet.addMergedRegion(new Region(detSize+8, (short)0, detSize+8, (short)8));
    		HSSFCell cell_last39 = row_last3.createCell(9);
    		cell_last39.setCellValue("调入单位(资产接收人):");
    		cell_last39.setCellStyle(rowlast_Style);
    		row_last3.createCell(10);
    		row_last3.createCell(11);
    		row_last3.createCell(12);
    		row_last3.createCell(13);
    		row_last3.createCell(14);
    		row_last3.createCell(15);
    		sheet.addMergedRegion(new Region(detSize+9, (short)8, detSize+9, (short)15));
    		// 设置列宽，自动 
    		for(int j=2;j<9;j++){
				sheet.autoSizeColumn(j, true); // 自动计算列宽
				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // 设置列宽为自动值的1.5倍
    		}
    		
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/dm/"+excelName);
			
			OutputStream os = new FileOutputStream(file);
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
		}
		return excelName;
	}
	/**
	 * 保存装备的excel调配单
	 * @param responseDTO
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String saveZBTPD(ISrvMsg responseDTO) throws SOAPException, IOException {
		String doctype = responseDTO.getValue("doctype");
		String title = responseDTO.getValue("title");
		MsgElement baseData = responseDTO.getMsgElement("baseinfo");
		List<MsgElement> detDatas = responseDTO.getMsgElements("detList");
		String excelName = baseData.getValue("mixinfo_no")+".xls";//UUID.randomUUID().toString()+".xls";
		if(baseData!=null){
			String sheetName = "调配单";
			HSSFWorkbook wb = new HSSFWorkbook();//建立新HSSFWorkbook对象  
    		HSSFSheet sheet = wb.createSheet(sheetName);//建立新的sheet对象
    		//第一行插入调配单的机构名称
    		HSSFRow row0 = sheet.createRow((short)0);//建立新行
    		HSSFCell cell0 = row0.createCell(0);
    		if(!"JBQ_PL".equals(doctype)){
    			cell0.setCellValue("装备服务处设备物资科");
    		}
    		sheet.addMergedRegion(new Region(0, (short)0, 0, (short)7));
    		HSSFFont row0_font = wb.createFont();
    		row0_font.setFontHeightInPoints((short)16);
    		row0_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle row0_style = wb.createCellStyle();
    		row0_style.setFont(row0_font);
    		row0_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell0.setCellStyle(row0_style);
    		//第二行是标题
    		HSSFRow row1 = sheet.createRow((short)1);//建立新行
    		HSSFCell cell1 = row1.createCell(0);
    		cell1.setCellValue(title);
    		sheet.addMergedRegion(new Region(1, (short)0, 1, (short)7));
    		HSSFFont row1_font = wb.createFont();
    		row1_font.setFontHeightInPoints((short)18);
    		row1_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		row1_font.setFontName("黑体");
    		HSSFCellStyle row1_style = wb.createCellStyle();
    		row1_style.setFont(row1_font);
    		row1_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell1.setCellStyle(row1_style);
    		//第三行 到 第六行 是单子基本信息
    		HSSFFont row3_font = wb.createFont();
    		row3_font.setFontHeightInPoints((short)12);
    		row3_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle row3_style = wb.createCellStyle();
    		row3_style.setFont(row3_font);
    		row3_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		HSSFRow row2 = sheet.createRow((short)2);//建立新行
    		HSSFCell cell20 = row2.createCell(0);
    		cell20.setCellValue(baseData.getValue("outorgname"));
    		cell20.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)0, 2, (short)1));
    		HSSFCell cell212 = row2.createCell(6);
    		cell212.setCellValue(baseData.getValue("mixinfo_no"));
    		cell212.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)6, 2, (short)7));
    		HSSFRow row3 = sheet.createRow((short)3);//建立新行
    		HSSFRow row4 = sheet.createRow((short)4);//建立新行
    		HSSFCell cell40 = row4.createCell(0);
    		cell40.setCellValue("兹将下列固定资产调给");
    		cell40.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)0, 4, (short)1));
    		HSSFCell cell43 = row4.createCell(2);
    		cell43.setCellValue(baseData.getValue("inorgname"));
    		cell43.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)2, 4, (short)3));
    		HSSFCell cell46 = row4.createCell(4);
    		cell46.setCellValue("使用(保存)");
    		cell46.setCellStyle(row3_style);
    		HSSFCell cell412 = row4.createCell(6);
    		cell412.setCellValue(baseData.getValue("mixdate"));
    		cell412.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)6, 4, (short)7));
    		HSSFRow row5 = sheet.createRow((short)5);//建立新行
    		
    		//写标题
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		//font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		String[] titleArrays = new String[]{"序号","设备名称","型号及规格","单位",
    				"数量","技术状况","存放地","备注"};
    		// 建立表头
    		HSSFFont rowdettitle_font = wb.createFont();
    		rowdettitle_font.setFontHeightInPoints((short)12);
    		rowdettitle_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		rowdettitle_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle rowdettitle_Style = wb.createCellStyle();
    		rowdettitle_Style.setFont(rowdettitle_font);
    		rowdettitle_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdettitle_Style.setBorderBottom((short)1);
    		rowdettitle_Style.setBorderLeft((short)1);
    		rowdettitle_Style.setBorderRight((short)1);
    		rowdettitle_Style.setBorderTop((short)1);
    		HSSFRow row6 = sheet.createRow((short)6);//建立新行
    		for(int j=0;j<8;j++){
    			HSSFCell cell = row6.createCell(j);//建立新cell
				cell.setCellValue(titleArrays[j]);
				cell.setCellStyle(style);
				cell.setCellStyle(rowdettitle_Style);
    		}
    		// 建立具体数据
    		int detSize = detDatas.size();
    		HSSFFont rowdetcontent_font = wb.createFont();
    		rowdetcontent_font.setFontHeightInPoints((short)12);
    		rowdetcontent_font.setFontName("宋体");
    		HSSFCellStyle rowdetcontent_Style = wb.createCellStyle();
    		rowdetcontent_Style.setFont(rowdetcontent_font);
    		rowdetcontent_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdetcontent_Style.setBorderBottom((short)1);
    		rowdetcontent_Style.setBorderLeft((short)1);
    		rowdetcontent_Style.setBorderRight((short)1);
    		rowdetcontent_Style.setBorderTop((short)1);
    		for(int i=0;i<detSize;i++){
    			MsgElement data = detDatas.get(i);
    			HSSFRow row = sheet.createRow((short)(i+7));//建立新行
    			//创建16个内容
				HSSFCell detcell0 = row.createCell(0);//序号
				detcell0.setCellValue(i+1);
				detcell0.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell1 = row.createCell(1);//设备名称
				detcell1.setCellValue(data.getValue("dev_name"));
				detcell1.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell2 = row.createCell(2);//规格型号
				if("ZBTPD_PL".equals(doctype)||"JBQ_PL".equals(doctype)||"ZBTPD".equals(doctype)){
					detcell2.setCellValue(data.getValue("dev_model"));
				}else{
					detcell2.setCellValue("");
				}
				detcell2.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell3 = row.createCell(3);//单位
				if("ZBTPD_PL".equals(doctype)||"JBQ_PL".equals(doctype)){
					detcell3.setCellValue(data.getValue("unit_name"));
				}else{
					detcell3.setCellValue("");//(data.getValue("unit_name"));
				}
				detcell3.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell4 = row.createCell(4);//数量
				detcell4.setCellValue(data.getValue("assign_num"));
				detcell4.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell5 = row.createCell(5);//
				detcell5.setCellValue("");
				detcell5.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell6 = row.createCell(6);//
				detcell6.setCellValue("");
				detcell6.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell7 = row.createCell(7);//备注
				detcell7.setCellValue("");
				detcell7.setCellStyle(rowdetcontent_Style);
    		}
    		//后面在加写乱七八糟的信息
    		HSSFFont rowlast_font = wb.createFont();
    		rowlast_font.setFontHeightInPoints((short)12);
    		rowlast_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle rowlast_Style = wb.createCellStyle();
    		rowlast_Style.setFont(rowlast_font);
    		//rowlast_Style.setBorderBottom((short)1);
    		//rowlast_Style.setBorderLeft((short)1);
    		//rowlast_Style.setBorderRight((short)1);
    		//rowlast_Style.setBorderTop((short)1);
    		HSSFRow row_last1 = sheet.createRow((short)(detSize+7));//建立新行
    		HSSFCell cell_last10 = row_last1.createCell(0);
    		row_last1.createCell(1);
    		row_last1.createCell(2);
    		row_last1.createCell(3);
    		cell_last10.setCellValue("调拨依据：");
    		cell_last10.setCellStyle(rowlast_Style);
    		sheet.addMergedRegion(new Region(detSize+7, (short)0, detSize+7, (short)3));
    		HSSFCell cell_last19 = row_last1.createCell(4);
    		cell_last19.setCellValue("设备物资部负责人（审批）：");
    		cell_last19.setCellStyle(rowlast_Style);
    		row_last1.createCell(5);
    		row_last1.createCell(6);
    		row_last1.createCell(7);
    		sheet.addMergedRegion(new Region(detSize+7, (short)4, detSize+7, (short)7));
    		HSSFRow row_last2 = sheet.createRow((short)(detSize+8));//建立新行
    		HSSFCell cell_last20 = row_last2.createCell(0);
    		cell_last20.setCellValue("设备所属单位领导（签字）：");
    		cell_last20.setCellStyle(rowlast_Style);
    		row_last2.createCell(1);
    		row_last2.createCell(2);
    		row_last2.createCell(3);
    		sheet.addMergedRegion(new Region(detSize+8, (short)0, detSize+8, (short)3));
    		HSSFCell cell_last29 = row_last2.createCell(4);
    		cell_last29.setCellValue("制表：");
    		cell_last29.setCellStyle(rowlast_Style);
    		row_last2.createCell(5);
    		row_last2.createCell(6);
    		row_last2.createCell(7);
    		sheet.addMergedRegion(new Region(detSize+8, (short)4, detSize+8, (short)7));
    		HSSFRow row_last3 = sheet.createRow((short)(detSize+9));//建立新行
    		HSSFCell cell_last30 = row_last3.createCell(0);
    		cell_last30.setCellValue("调出单位（资产移交人)：");
    		cell_last30.setCellStyle(rowlast_Style);
    		row_last3.createCell(1);
    		row_last3.createCell(2);
    		row_last3.createCell(3);
    		sheet.addMergedRegion(new Region(detSize+9, (short)0, detSize+9, (short)3));
    		HSSFCell cell_last39 = row_last3.createCell(4);
    		cell_last39.setCellValue("调入单位(资产接收人):");
    		cell_last39.setCellStyle(rowlast_Style);
    		row_last3.createCell(5);
    		row_last3.createCell(6);
    		row_last3.createCell(7);
    		sheet.addMergedRegion(new Region(detSize+9, (short)4, detSize+9, (short)7));
    		// 设置列宽，自动 
    		for(int j=0;j<titleArrays.length;j++){
				sheet.autoSizeColumn(j, true); // 自动计算列宽
				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // 设置列宽为自动值的1.5倍
    		}
    		
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/dm/"+excelName);
			
			OutputStream os = new FileOutputStream(file);
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
		}
		return excelName;
	}
	/**
	 * 保存自有的excel调配单
	 * @param responseDTO
	 * @return
	 * @throws SOAPException
	 * @throws IOException
	 */
	private String saveZYTPD(ISrvMsg responseDTO) throws SOAPException, IOException {

		String title = responseDTO.getValue("title");
		MsgElement baseData = responseDTO.getMsgElement("baseinfo");
		List<MsgElement> detDatas = responseDTO.getMsgElements("detList");
		String excelName =baseData.getValue("mixinfo_no")+".xls"; //UUID.randomUUID().toString()+".xls";
		if(baseData!=null){
			String sheetName = "调配单";
			HSSFWorkbook wb = new HSSFWorkbook();//建立新HSSFWorkbook对象  
    		HSSFSheet sheet = wb.createSheet(sheetName);//建立新的sheet对象
    		//第一行插入调配单的机构名称
    		HSSFRow row0 = sheet.createRow((short)0);//建立新行
    		HSSFCell cell0 = row0.createCell(0);
    		cell0.setCellValue(baseData.getValue("mixorgname"));
    		sheet.addMergedRegion(new Region(0, (short)0, 0, (short)15));
    		HSSFFont row0_font = wb.createFont();
    		row0_font.setFontHeightInPoints((short)16);
    		row0_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle row0_style = wb.createCellStyle();
    		row0_style.setFont(row0_font);
    		row0_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell0.setCellStyle(row0_style);
    		//第二行是标题
    		HSSFRow row1 = sheet.createRow((short)1);//建立新行
    		HSSFCell cell1 = row1.createCell(0);
    		cell1.setCellValue(title);
    		sheet.addMergedRegion(new Region(1, (short)0, 1, (short)15));
    		HSSFFont row1_font = wb.createFont();
    		row1_font.setFontHeightInPoints((short)18);
    		row1_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		row1_font.setFontName("黑体");
    		HSSFCellStyle row1_style = wb.createCellStyle();
    		row1_style.setFont(row1_font);
    		row1_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		cell1.setCellStyle(row1_style);
    		//第三行 到 第六行 是单子基本信息
    		HSSFFont row3_font = wb.createFont();
    		row3_font.setFontHeightInPoints((short)12);
    		row3_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle row3_style = wb.createCellStyle();
    		row3_style.setFont(row3_font);
    		row3_style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		HSSFRow row2 = sheet.createRow((short)2);//建立新行
    		HSSFCell cell20 = row2.createCell(1);
    		cell20.setCellValue(baseData.getValue("outorgname"));
    		cell20.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)1, 2, (short)2));
    		HSSFCell cell212 = row2.createCell(12);
    		cell212.setCellValue(baseData.getValue("mixinfo_no"));
    		cell212.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(2, (short)12, 2, (short)15));
    		HSSFRow row3 = sheet.createRow((short)3);//建立新行
    		HSSFRow row4 = sheet.createRow((short)4);//建立新行
    		HSSFCell cell40 = row4.createCell(1);
    		cell40.setCellValue("兹将下列固定资产调给");
    		cell40.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)1, 4, (short)3));
    		HSSFCell cell43 = row4.createCell(4);
    		cell43.setCellValue(baseData.getValue("inorgname"));
    		cell43.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)4, 4, (short)5));
    		HSSFCell cell46 = row4.createCell(6);
    		cell46.setCellValue("使用(保存)");
    		cell46.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)6, 4, (short)7));
    		HSSFCell cell412 = row4.createCell(12);
    		cell412.setCellValue(baseData.getValue("mixdate"));
    		cell412.setCellStyle(row3_style);
    		sheet.addMergedRegion(new Region(4, (short)12, 4, (short)15));
    		HSSFRow row5 = sheet.createRow((short)5);//建立新行
    		
    		//写标题
    		HSSFFont font = wb.createFont();
    		font.setFontHeightInPoints((short)11);
    		//font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		HSSFCellStyle style = wb.createCellStyle();
    		style.setFont(font);
    		String[] titleArrays = new String[]{"序号","设备名称","型号及规格","自编号","牌照号",
    				"实物标识号","资产编号","单位","数量","底盘号",
    				"行驶证","附加费","营运证","技术状况","存放地","备注"};
    		// 建立表头
    		HSSFFont rowdettitle_font = wb.createFont();
    		rowdettitle_font.setFontHeightInPoints((short)12);
    		rowdettitle_font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
    		rowdettitle_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle rowdettitle_Style = wb.createCellStyle();
    		rowdettitle_Style.setFont(rowdettitle_font);
    		rowdettitle_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdettitle_Style.setBorderBottom((short)1);
    		rowdettitle_Style.setBorderLeft((short)1);
    		rowdettitle_Style.setBorderRight((short)1);
    		rowdettitle_Style.setBorderTop((short)1);
    		HSSFRow row6 = sheet.createRow((short)6);//建立新行
    		for(int j=0;j<16;j++){
    			HSSFCell cell = row6.createCell(j);//建立新cell
				cell.setCellValue(titleArrays[j]);
				cell.setCellStyle(style);
				cell.setCellStyle(rowdettitle_Style);
    		}
    		// 建立具体数据
    		int detSize = detDatas.size();
    		HSSFFont rowdetcontent_font = wb.createFont();
    		rowdetcontent_font.setFontHeightInPoints((short)12);
    		rowdetcontent_font.setFontName("宋体");
    		HSSFCellStyle rowdetcontent_Style = wb.createCellStyle();
    		rowdetcontent_Style.setFont(rowdetcontent_font);
    		rowdetcontent_Style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
    		rowdetcontent_Style.setBorderBottom((short)1);
    		rowdetcontent_Style.setBorderLeft((short)1);
    		rowdetcontent_Style.setBorderRight((short)1);
    		rowdetcontent_Style.setBorderTop((short)1);
    		for(int i=0;i<detSize;i++){
    			MsgElement data = detDatas.get(i);
    			HSSFRow row = sheet.createRow((short)(i+7));//建立新行
    			//创建16个内容
    			HSSFCell detcell0 = row.createCell(0);//序号
				detcell0.setCellValue(i+1);
				detcell0.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell1 = row.createCell(1);//设备名称
				detcell1.setCellValue(data.getValue("dev_name"));
				detcell1.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell2 = row.createCell(2);//规格型号
				detcell2.setCellValue(data.getValue("dev_model"));
				detcell2.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell3 = row.createCell(3);//自编号
				detcell3.setCellValue(data.getValue("self_num"));
				detcell3.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell4 = row.createCell(4);//实物标识号
				detcell4.setCellValue(data.getValue("license_num"));
				detcell4.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell5 = row.createCell(5);//实物标识号
				detcell5.setCellValue(data.getValue("dev_sign"));
				detcell5.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell6 = row.createCell(6);//资产编号
				detcell6.setCellValue(data.getValue("asset_coding"));
				detcell6.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell7 = row.createCell(7);//单位
				detcell7.setCellValue(data.getValue("unit_name"));
				detcell7.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell8 = row.createCell(8);//数量
				detcell8.setCellValue("1");
				detcell8.setCellStyle(rowdetcontent_Style);
				//后面的先放空。
				HSSFCell detcell9 = row.createCell(9);//
				detcell9.setCellValue("");
				detcell9.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell10 = row.createCell(10);//
				detcell10.setCellValue("");
				detcell10.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell11 = row.createCell(11);//
				detcell11.setCellValue("");
				detcell11.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell12 = row.createCell(12);//
				detcell12.setCellValue("");
				detcell12.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell13 = row.createCell(13);//
				detcell13.setCellValue("");
				detcell13.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell14 = row.createCell(14);//
				detcell14.setCellValue("");
				detcell14.setCellStyle(rowdetcontent_Style);
				HSSFCell detcell15 = row.createCell(15);//
				detcell15.setCellValue("");
				detcell15.setCellStyle(rowdetcontent_Style);
    		}
    		//后面在加写乱七八糟的信息
    		HSSFFont rowlast_font = wb.createFont();
    		rowlast_font.setFontHeightInPoints((short)12);
    		rowlast_font.setFontName("仿宋_GB2312");
    		HSSFCellStyle rowlast_Style = wb.createCellStyle();
    		rowlast_Style.setFont(rowlast_font);
    		//rowlast_Style.setBorderBottom((short)1);
    		//rowlast_Style.setBorderLeft((short)1);
    		//rowlast_Style.setBorderRight((short)1);
    		//rowlast_Style.setBorderTop((short)1);
    		HSSFRow row_last1 = sheet.createRow((short)(detSize+7));//建立新行
    		HSSFCell cell_last10 = row_last1.createCell(0);
    		row_last1.createCell(1);
    		row_last1.createCell(2);
    		row_last1.createCell(3);
    		row_last1.createCell(4);
    		row_last1.createCell(5);
    		row_last1.createCell(6);
    		row_last1.createCell(7);
    		row_last1.createCell(8);
    		cell_last10.setCellValue("调拨依据：");
    		cell_last10.setCellStyle(rowlast_Style);
    		sheet.addMergedRegion(new Region(detSize+7, (short)0, detSize+7, (short)8));
    		HSSFCell cell_last19 = row_last1.createCell(9);
    		cell_last19.setCellValue("设备物资部负责人（审批）：");
    		cell_last19.setCellStyle(rowlast_Style);
    		row_last1.createCell(10);
    		row_last1.createCell(11);
    		row_last1.createCell(12);
    		row_last1.createCell(13);
    		row_last1.createCell(14);
    		row_last1.createCell(15);
    		sheet.addMergedRegion(new Region(detSize+7, (short)9, detSize+7, (short)15));
    		HSSFRow row_last2 = sheet.createRow((short)(detSize+8));//建立新行
    		HSSFCell cell_last20 = row_last2.createCell(0);
    		cell_last20.setCellValue("设备所属单位领导（签字）：");
    		cell_last20.setCellStyle(rowlast_Style);
    		row_last2.createCell(1);
    		row_last2.createCell(2);
    		row_last2.createCell(3);
    		row_last2.createCell(4);
    		row_last2.createCell(5);
    		row_last2.createCell(6);
    		row_last2.createCell(7);
    		row_last2.createCell(8);
    		sheet.addMergedRegion(new Region(detSize+8, (short)0, detSize+8, (short)8));
    		HSSFCell cell_last29 = row_last2.createCell(9);
    		cell_last29.setCellValue("制表：");
    		cell_last29.setCellStyle(rowlast_Style);
    		row_last2.createCell(10);
    		row_last2.createCell(11);
    		row_last2.createCell(12);
    		row_last2.createCell(13);
    		row_last2.createCell(14);
    		row_last2.createCell(15);
    		sheet.addMergedRegion(new Region(detSize+8, (short)9, detSize+8, (short)15));
    		HSSFRow row_last3 = sheet.createRow((short)(detSize+9));//建立新行
    		HSSFCell cell_last30 = row_last3.createCell(0);
    		cell_last30.setCellValue("调出单位（资产移交人)：");
    		cell_last30.setCellStyle(rowlast_Style);
    		row_last3.createCell(1);
    		row_last3.createCell(2);
    		row_last3.createCell(3);
    		row_last3.createCell(4);
    		row_last3.createCell(5);
    		row_last3.createCell(6);
    		row_last3.createCell(7);
    		row_last3.createCell(8);
    		sheet.addMergedRegion(new Region(detSize+9, (short)0, detSize+9, (short)8));
    		HSSFCell cell_last39 = row_last3.createCell(9);
    		cell_last39.setCellValue("调入单位(资产接收人):");
    		cell_last39.setCellStyle(rowlast_Style);
    		row_last3.createCell(10);
    		row_last3.createCell(11);
    		row_last3.createCell(12);
    		row_last3.createCell(13);
    		row_last3.createCell(14);
    		row_last3.createCell(15);
    		sheet.addMergedRegion(new Region(detSize+9, (short)9, detSize+9, (short)15));
    		// 设置列宽，自动 
    		for(int j=2;j<9;j++){
				sheet.autoSizeColumn(j, true); // 自动计算列宽
				sheet.setColumnWidth(j, (int)(sheet.getColumnWidth(j)*1.5)); // 设置列宽为自动值的1.5倍
    		}
    		
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/dm/"+excelName);
			
			OutputStream os = new FileOutputStream(file);
    		
			wb.write(os);
			
			os.flush();
			
			os.close();
		}
		return excelName;
	}
}
