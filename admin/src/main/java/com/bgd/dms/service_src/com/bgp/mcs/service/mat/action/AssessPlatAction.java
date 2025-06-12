package com.bgp.mcs.service.mat.action;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.soap.SOAPException;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

/**
 * 物资模块导出Excel Action帮助类
 * @author wangzheqin 2015.4.7
 *
 */
public class AssessPlatAction extends WSAction{
	
	/**
	 * 先准备数据
	 */
	@Override
	public ActionForward servieCall(ActionMapping mapping, ActionForm form, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ServiceCallConfig servicecallconfig = new ServiceCallConfig();
        servicecallconfig.setServiceName("MatItemSrv");
        servicecallconfig.setOperationName("getExcelData");
        
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
		//各班组物资消耗情况 
		if("gbzwzxh".equals(doctype)){
			excelName = createCommonExcel(responseDTO,2);
		}
		
		response.setContentType("text/json; charset=utf-8");
    	
    	String ret="{returnCode:0, excelName:'"+excelName+"',showName:'"+excelName+"'}";
    	
    	response.getWriter().write(ret);
    	  
    	return null;
	}
	
	/**
	 * 创建excel
	 * @param responseDTO
	 * @param times 列宽倍数
	 * @return
	 * @throws Exception
	 */
	private String createCommonExcel(ISrvMsg responseDTO,double times) throws Exception {
		
		String excelName = responseDTO.getValue("excelName");//excel名称
		String title = responseDTO.getValue("title");//excel标题
		List excelHeader = responseDTO.getValues("excelHeader");//excel表头
		List<MsgElement> excelData = responseDTO.getMsgElements("excelData");//excel数据
		String sheetName = title;
		if(CollectionUtils.isNotEmpty(excelHeader)){
			Workbook wb = new HSSFWorkbook();//建立新HSSFWorkbook对象 
			Sheet sheet = wb.createSheet(sheetName);//建立新的sheet对象
			//标题行
			Row titleRow = sheet.createRow(0);//建立新行
			Cell tc = titleRow.createCell(0);
			tc.setCellValue(title);
			tc.setCellStyle(setExcelTitleStyle(wb));
			sheet.addMergedRegion(new CellRangeAddress(0,0,0,excelHeader.size()-1));
			//表头
			Row headerRow = sheet.createRow(1);
			Cell hcell=null;
			
			for(int i=0;i<excelHeader.size();i++){
				hcell = headerRow.createCell(i);
				hcell.setCellStyle(setExcelHearderStyle(wb));
				hcell.setCellValue(excelHeader.get(i).toString());
			}
			//数据列
			Row dataRow =null;
			//写入数据
			MsgElement data=null;
			if(CollectionUtils.isNotEmpty(excelData)){
	    		for(int i=0;i<excelData.size();i++){
	    			//创建当前行
	    			dataRow = sheet.createRow(2+i);
	    			//获取数据
	    			data=excelData.get(i);
	    			for(int j=0;j<excelHeader.size();j++){
	    				//创建单元格
	    				Cell dCell=dataRow.createCell(j);
	    				//设置样式
	    				dCell.setCellStyle(setExcelCommonStyle(wb));
	    				//列写入数据
						String key=("excel_column_val"+j).trim();
						if(null!=data.getValue(key) && StringUtils.isNotBlank(data.getValue(key).toString())){
		    				dCell.setCellValue(data.getValue(key).toString());
						}
	    			}
	    		}
			}
			// 设置列宽
			setColumnWidth(sheet,excelHeader.size(),times);
			String file = this.getServlet().getServletContext().getRealPath("/WEB-INF/temp/dm/"+excelName);
			OutputStream os = new FileOutputStream(file);
			wb.write(os);
			os.flush();
			os.close();
		}
		return excelName;
	}
	
	/**
	 * 设置列宽
	 * @param sheet
	 * @param columnSize
	 * @param times
	 */
	public void setColumnWidth(Sheet sheet, int columnSize , double times) {
		for (int i = 0; i < columnSize; i++) {
			// 自动计算列宽
			sheet.autoSizeColumn(i, true);
			// 设置列宽为自动值的1.5倍
			sheet.setColumnWidth(i, (int) (sheet.getColumnWidth(i) * times));
		}
	}
	
	/**
	 * 设置标题样式
	 * 
	 * @param wb
	 * @return
	 */
	public CellStyle setExcelTitleStyle(Workbook wb) {
		CellStyle cellStyle = wb.createCellStyle(); // 创建单元格样式
		// 设置单元格水平方向对其方式
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// 设置单元格垂直方向对其方式
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		// 创建字体
		Font font = wb.createFont();
		font.setFontHeightInPoints((short) 16);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("宋体");
		// 设置字体样式
		cellStyle.setFont(font);
		return cellStyle;
	}

	/**
	 * 设备表头样式
	 * 
	 * @param wb
	 * @return
	 */
	public CellStyle setExcelHearderStyle(Workbook wb) {
		CellStyle cellStyle = wb.createCellStyle(); // 创建单元格样式
		// 设置单元格水平方向对其方式
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// 设置单元格垂直方向对其方式
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		// 创建字体
		Font font = wb.createFont();
		font.setFontHeightInPoints((short) 11);
		font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		font.setFontName("宋体");
		// 设置字体样式
		cellStyle.setFont(font);
		// 设置边框
		cellStyle.setBorderTop(CellStyle.BORDER_THIN); // 上边边框
		cellStyle.setBorderRight(CellStyle.BORDER_THIN); // 右边边框 
		cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 底部边框
		cellStyle.setBorderLeft(CellStyle.BORDER_THIN);  // 左边边框
		return cellStyle;
	}
	
	/**
	 * 设置单元格样式
	 * 
	 * @param wb
	 * @return
	 */
	public CellStyle setExcelCommonStyle(Workbook wb) {
		CellStyle cellStyle = wb.createCellStyle(); // 创建单元格样式
		// 设置单元格水平方向对其方式
		cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		// 设置单元格垂直方向对其方式
		cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		// 设置边框
		cellStyle.setBorderTop(CellStyle.BORDER_THIN); // 上边边框
		cellStyle.setBorderRight(CellStyle.BORDER_THIN); // 右边边框 
		cellStyle.setBorderBottom(CellStyle.BORDER_THIN); // 底部边框
		cellStyle.setBorderLeft(CellStyle.BORDER_THIN);  // 左边边框
		return cellStyle;
	}
	
}
