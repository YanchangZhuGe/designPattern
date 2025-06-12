package com.bgp.mcs.service.mat.util;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.bgp.mcs.service.common.excelIE.util.ExcelExceptionHandler;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：杨园
 * 
 * 描述：excel处理分析类，用来获取及生成excel
 */

@SuppressWarnings({ "rawtypes", "unchecked" })
public class ExcelEIResolvingUtil {
	private static ILog log = LogFactory.getLogger(ExcelEIResolvingUtil.class);
	/*
	 * 通过wsfile 解析excel 获取excel中的信息
	 * 
	 * @param IN:file wsFile文件、columnList xml配置的excel导入配置信息
	 * 
	 * @param Out:List 将excel解析的数据集放置到list中
	 */
	public static List getExcelDataByWSFileOfWZ(WSFile file) throws IOException,
			ExcelExceptionHandler {
		String logid = "[getExcelDataByWSFileOfWZ]";
		List dataList = new ArrayList();
		String s = file.getFilename();
		Workbook book = null;
		if (file.getFilename().endsWith(".xlsx")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			book = new XSSFWorkbook(is);
		} else {
			if (file.getFilename().endsWith(".xls")) {
				InputStream is = new ByteArrayInputStream(file.getFileData());
				book = new HSSFWorkbook(is);
			}
		}
		Sheet sheet0 = book.getSheetAt(0);
		int rows = sheet0.getPhysicalNumberOfRows();
		log.info("rowssize=" + rows);
		Row row0 = sheet0.getRow(0);
		int columns = row0.getPhysicalNumberOfCells();
		for (int m = 1; m <= rows-1; m++) {
			Row row = sheet0.getRow(m);
			Map mapColumnInfoIn = new HashMap();
			log.info("columns m="+ m + " row=" +row);
			for (int n = 0; n < columns; n++) {
				if (row.getCell(n) != null) {
					Cell cell = row.getCell(n);
					int cellType = cell.getCellType();
					switch (cellType) {
					case 0:
						if (HSSFDateUtil.isCellDateFormatted(cell)) {
							mapColumnInfoIn.put(n, cell.getDateCellValue());
						} else {
							cell.setCellType(cell.CELL_TYPE_STRING);
							mapColumnInfoIn.put(n, cell.getStringCellValue());
						}
						break;
					case 1:
						mapColumnInfoIn.put(n, cell.getStringCellValue());
						break;
					}
				} else {
					mapColumnInfoIn.put(n, "");
				}
			}
			 
			Map map = new HashMap();
		 
			String wzId = "";
			if (mapColumnInfoIn.get(0) != null
					&& !mapColumnInfoIn.get(0).equals("")) {
				wzId = valueOf(mapColumnInfoIn.get(0), "") ; 
				String bcffsl=valueOf(mapColumnInfoIn.get(4),"");//本次发放数量 
				//String sjdj=valueOf(mapColumnInfoIn.get(7),"");//实际单价 
				//String totalmoney=valueOf(mapColumnInfoIn.get(8),"");//金额
				map.put("wz_id", wzId);
				map.put("mat_num", bcffsl);
				//map.put("actual_price", sjdj);
				//map.put("total_money", totalmoney);
				dataList.add(map);
			}
		}

		return dataList;
	}
	/*
	 * 通过wsfile 解析excel 获取excel中的信息
	 * 
	 * @param IN:file wsFile文件、columnList xml配置的excel导入配置信息
	 * 
	 * @param Out:List 将excel解析的数据集放置到list中
	 */
	public static List getExcelDataByWSFile(WSFile file) throws IOException,
			ExcelExceptionHandler {
		String logid = "[getExcelDataByWSFile]";
		List dataList = new ArrayList();
		String s = file.getFilename();
		Workbook book = null;
		if (file.getFilename().endsWith(".xlsx")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			book = new XSSFWorkbook(is);
		} else {
			if (file.getFilename().endsWith(".xls")) {
				InputStream is = new ByteArrayInputStream(file.getFileData());
				book = new HSSFWorkbook(is);
			}
		}
		Sheet sheet0 = book.getSheetAt(0);
		int rows = sheet0.getPhysicalNumberOfRows();
		log.info("rowssize=" + rows);
		Row row0 = sheet0.getRow(0);
		int columns = row0.getPhysicalNumberOfCells();
		for (int m = 1; m <= rows-1; m++) {
			Row row = sheet0.getRow(m);
			Map mapColumnInfoIn = new HashMap();
			log.info("columns m="+ m + " row=" +row);
			for (int n = 0; n < columns; n++) {
				if (row.getCell(n) != null) {
					Cell cell = row.getCell(n);
					int cellType = cell.getCellType();
					switch (cellType) {
					case 0:
						if (HSSFDateUtil.isCellDateFormatted(cell)) {
							mapColumnInfoIn.put(n, cell.getDateCellValue());
						} else {
							cell.setCellType(cell.CELL_TYPE_STRING);
							mapColumnInfoIn.put(n, cell.getStringCellValue());
						}
						break;
					case 1:
						mapColumnInfoIn.put(n, cell.getStringCellValue());
						break;
					}
				} else {
					mapColumnInfoIn.put(n, "");
				}
			}
			Set<Integer> set =mapColumnInfoIn.keySet();
			 
			//log.info(logid + " mapColumnInfoIn=" + mapColumnInfoIn);
			Map map = new HashMap();
			// String codingCodeId = mapColumnInfoIn.get(0).toString();
			String wzId = "";
			if (mapColumnInfoIn.get(0) != null
					&& !mapColumnInfoIn.get(0).equals("")) {
				wzId = valueOf(mapColumnInfoIn.get(0), "") ;
				String outDate = valueOf(mapColumnInfoIn.get(1), "")
						.replace(".", "-");
				String actualPrice = valueOf(mapColumnInfoIn.get(2), "0");
				
				String matNum = valueOf(mapColumnInfoIn.get(3), "");
				
				String totalMoney = String
						.valueOf((Double.valueOf(actualPrice))
								* (Double.valueOf(matNum)));
				String operator = valueOf(mapColumnInfoIn.get(10), "");
				DecimalFormat df = new DecimalFormat("0.0000");
				if (wzId != null) {
					String sql = "select * from gms_mat_infomation i where i.bsflag='0' and i.wz_id='"
							+ wzId + "'";
					Map mapCode = BeanFactory.getQueryJdbcDAO()
							.queryRecordBySQL(sql);
					if (mapCode != null) {
						String coding_code_id = (String) mapCode
								.get("codingCodeId");
						if (coding_code_id.equals("07030102")) {
							matNum = df.format((Double.valueOf(mapColumnInfoIn
									.get(3).toString()) * 0.75) / 1000);
						} else if (coding_code_id.equals("07030301")) {
							matNum = df.format((Double.valueOf(mapColumnInfoIn
									.get(3).toString()) * 0.86) / 1000);
						}
					}
				}

				// if(wzId!=null&&(wzId.equals("11000051822")||wzId.equals("10001037161")||wzId.equals("11004534305")||wzId.equals("10000189078")||wzId.equals("11000062340"))){
				// matNum =
				// df.format((Double.valueOf(mapColumnInfoIn.get(4).toString())*0.75)/1000);
				// }else
				// if(wzId!=null&&(wzId.equals("11003426794")||wzId.equals("11003308799")||wzId.equals("11003308800")||wzId.equals("11003308801")||wzId.equals("11003308804")||wzId.equals("11003308802")||wzId.equals("11003308803")||wzId.equals("11003308805"))){
				// matNum =
				// df.format((Double.valueOf(mapColumnInfoIn.get(4).toString())*0.86)/1000);
				// }
				// if(codingCodeId.equals("07030102")){
				// }
				// else{
				// matNum =
				// df.format((Double.valueOf(mapColumnInfoIn.get(4).toString())*0.86)/1000);
				// }
				map.put("wz_id", wzId);
				map.put("out_date", outDate);
				map.put("actual_price", actualPrice);
				map.put("mat_num", matNum);
				map.put("oil_num", valueOf(mapColumnInfoIn.get(3), ""));
				map.put("total_money", totalMoney);
				map.put("dev_sign", mapColumnInfoIn.get(8));
				map.put("self_num", mapColumnInfoIn.get(6));
				map.put("license_num", mapColumnInfoIn.get(7));
				map.put("dev_coding", mapColumnInfoIn.get(9));
				map.put("operator", operator);
				
				String oil_from = "";
				if (mapColumnInfoIn.get(11) != null) {
					oil_from = mapColumnInfoIn.get(11).toString();
					if (oil_from.equals("加油站")) {
						oil_from = "1";
					} else if (oil_from.equals("油库-在账")) {
						oil_from = "0";
					}else if (oil_from.equals("油库-自采购")) {
						oil_from = "2";
					} else  {
						oil_from = null;
					}
				} else {
					oil_from = null;
				}
				map.put("oil_from", oil_from);
				//System.out.println(map);
				dataList.add(map);
			}
		}

		return dataList;
	}
	/**
	 * 空指针判断,赋默认值 create by gaoyunpeng 20150415
	 * 
	 * @param in
	 *            传入值
	 * @param defalutValue
	 *            默认值
	 * @return
	 */
	public static String valueOf(Object in, String defalutValue) {
		// TODO Auto-generated method stub
		if (in == null || "".equals(in)) {
			return defalutValue;
		}
		return in.toString();
	}
	/**
	 * 调拨单excel导入
	 * @param file
	 * @return
	 * @throws IOException
	 * @throws ExcelExceptionHandler
	 */
	public static List getMatOrderExcelDataByWSFile(WSFile file)
			throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		Map dataOrderList=new HashMap();
		List dataMatList=new ArrayList();
		String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = new XSSFWorkbook(is);
			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			Row row0 = sheet0.getRow(0);
			int columns = row0.getPhysicalNumberOfCells();
			System.out.println(rows);
			for (int m = 1; m < rows-1; m++) {
				Row row = sheet0.getRow(m);

				Map mapColumnInfoIn = new HashMap();
				for (int n = 0; n < columns; n++) {
					Cell cell = row.getCell(n);
					int cellType = cell.getCellType();
					switch (cellType) {
					case 0:
						if (HSSFDateUtil.isCellDateFormatted(cell)) {
							mapColumnInfoIn.put(n, cell.getDateCellValue());
						} else {
							cell.setCellType(cell.CELL_TYPE_STRING);
							mapColumnInfoIn.put(n, cell.getStringCellValue());
						}
						break;
					case 1:
						mapColumnInfoIn.put(n, cell.getStringCellValue());
						break;
					}
				}
			
				String orderno=(String)mapColumnInfoIn.get(8);
				String INVOICES_TYPE=(String)mapColumnInfoIn.get(7);
				Map matMap=new HashMap();
				matMap.put("INVOICES_ID",orderno );
				matMap.put("WZ_ID", mapColumnInfoIn.get(1));
				matMap.put("ACTUAL_PRICE", mapColumnInfoIn.get(4));
				matMap.put("TOTAL_MONEY", mapColumnInfoIn.get(6));
				matMap.put("IF_ACCEPT", "0");
				matMap.put("MAT_NUM", mapColumnInfoIn.get(5));
				dataMatList.add(matMap);
				if(!dataOrderList.containsKey(orderno)){
					Map map = new HashMap();
					map.put("INVOICES_NO", valueOf(orderno,""));
					map.put("INVOICES_ID", valueOf(orderno,""));
					map.put("PROCURE_NO", valueOf(orderno,""));
					map.put("INPUT_DATE", valueOf(mapColumnInfoIn.get(10),""));
					map.put("bsflag", "0");
					if("ERP在线调拨单".equals(INVOICES_TYPE)){
						map.put("INVOICES_TYPE", "6");
					}
					if("ERP离线调拨单".equals(INVOICES_TYPE)){
						map.put("INVOICES_TYPE", "7");
					}
					if("条码调拨单".equals(INVOICES_TYPE)){
						map.put("INVOICES_TYPE", "8");
					}
					if("入库通知单".equals(INVOICES_TYPE)){
						map.put("INVOICES_TYPE", "9");
					}
					if("直达采购订单".equals(INVOICES_TYPE)){
						map.put("INVOICES_TYPE", "1");
					} 
					map.put("IF_INPUT", "1");
					map.put("TOTAL_MONEY", 0);
					dataOrderList.put(orderno, map);
				}
				
			}
			dataList.add(dataOrderList) ;
			dataList.add(dataMatList);
		}
		return dataList;
	}
	
	public static List getRepMatExcelDataByWSFile(WSFile file)
			throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = new XSSFWorkbook(is);
			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			Row row0 = sheet0.getRow(0);
			int columns = row0.getPhysicalNumberOfCells();
			System.out.println(rows);
			for (int m = 1; m < rows; m++) {
				Row row = sheet0.getRow(m);

				Map mapColumnInfoIn = new HashMap();
				for (int n = 0; n < columns; n++) {
					Cell cell = row.getCell(n);
					int cellType = cell.getCellType();
					switch (cellType) {
					case 0:
						if (HSSFDateUtil.isCellDateFormatted(cell)) {
							mapColumnInfoIn.put(n, cell.getDateCellValue());
						} else {
							cell.setCellType(cell.CELL_TYPE_STRING);
							mapColumnInfoIn.put(n, cell.getStringCellValue());
						}
						break;
					case 1:
						mapColumnInfoIn.put(n, cell.getStringCellValue());
						break;
					}
				}
				Map map = new HashMap();
				map.put("wz_id", mapColumnInfoIn.get(0));
				map.put("actual_price", mapColumnInfoIn.get(3));
				map.put("stock_num", mapColumnInfoIn.get(4));
				System.out.println(map);
				dataList.add(map);
			}
		}
		return dataList;
	}

	public static List getRepMatzyExcelDataByWSFile(WSFile file)
			throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = new XSSFWorkbook(is);
			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			Row row0 = sheet0.getRow(0);
			int columns = row0.getPhysicalNumberOfCells();
			/**
			 * 去除重复数据
			 */

			for (int m = 1; m < rows; m++) {

				Row row = sheet0.getRow(m);
				if (row != null) {

					Map mapColumnInfoIn = new HashMap();

					for (int n = 0; n < columns; n++) {

						Cell cell = row.getCell(n);
						if (null != cell) {
							int cellType = cell.getCellType();
							switch (cellType) {
							case 0:
								if (HSSFDateUtil.isCellDateFormatted(cell)) {
									mapColumnInfoIn.put(n,
											cell.getDateCellValue());
								} else {
									cell.setCellType(cell.CELL_TYPE_STRING);
									mapColumnInfoIn.put(n,
											cell.getStringCellValue().trim());
								}
								break;
							case 1:
								mapColumnInfoIn.put(n,
										cell.getStringCellValue().trim());
								break;
							}
						}

					}
					Map map = new HashMap();
					map.put("postion", mapColumnInfoIn.get(0));
					map.put("wz_id", mapColumnInfoIn.get(1));
					map.put("mat_desc", mapColumnInfoIn.get(2));
					map.put("mat_model", mapColumnInfoIn.get(3));
					map.put("partsno", mapColumnInfoIn.get(4));
					map.put("wz_prickie", mapColumnInfoIn.get(5));
					map.put("stock_num", mapColumnInfoIn.get(6));
					map.put("wz_price", mapColumnInfoIn.get(7));
					map.put("price", mapColumnInfoIn.get(8));
					map.put("wz_sequence", mapColumnInfoIn.get(9));
					map.put("note", mapColumnInfoIn.get(10));
					map.put("alias", mapColumnInfoIn.get(11));//别名
					// map.put("wz_id", mapColumnInfoIn.get(0));
					// map.put("wz_sequence", mapColumnInfoIn.get(2));
					// map.put("actual_price", mapColumnInfoIn.get(3));
					// map.put("stock_num", mapColumnInfoIn.get(4));
					dataList.add(map);
				}
			}
		}
		return dataList;
	}

	public static List getBywxzyExcelDataByWSFile(WSFile file)
			throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}
			if (null != book) {
				Sheet sheet0 = book.getSheetAt(0);
				int rows = sheet0.getPhysicalNumberOfRows();
				if (rows > 2) {
					Row row0 = sheet0.getRow(0);
					int columns = row0.getPhysicalNumberOfCells();
					for (int m = 2; m < rows; m++) {
						Row row = sheet0.getRow(m);

						Map mapColumnInfoIn = new HashMap();
						for (int n = 0; n < columns; n++) {
							Cell cell = row.getCell(n);
							if (null != cell) {
								int cellType = cell.getCellType();
								switch (cellType) {
								case 0:
									if (HSSFDateUtil.isCellDateFormatted(cell)) {
										mapColumnInfoIn.put(n,
												cell.getDateCellValue());
									} else {
										cell.setCellType(cell.CELL_TYPE_STRING);
										mapColumnInfoIn.put(n,
												cell.getStringCellValue().trim());
									}
									break;
								case 1:
									mapColumnInfoIn.put(n,
											cell.getStringCellValue().trim());
									break;
								}
							}

						}
						Map map = new HashMap();
						if (mapColumnInfoIn.get(0) != null) {
							// 保养日期
							map.put("bywx_date", mapColumnInfoIn.get(0));
							// 自编号
							map.put("self_num", mapColumnInfoIn.get(1));
							// 累计工作小时
							map.put("work_hours", mapColumnInfoIn.get(2));
							// 保养界别
							map.put("maintenance_level", mapColumnInfoIn.get(3));
							// 保养内容
							map.put("maintenance_desc", mapColumnInfoIn.get(4));
							// 性能描述
							map.put("performance_desc", mapColumnInfoIn.get(5));
							// 故障现象
							map.put("falut_desc", mapColumnInfoIn.get(6));
							// 故障解决办法
							map.put("falut_case", mapColumnInfoIn.get(7));
							// 遗留问题
							map.put("legacy", mapColumnInfoIn.get(8));
							// 承修单位
							map.put("repair_unit", mapColumnInfoIn.get(9));
							// 承修人
							map.put("repair_men", mapColumnInfoIn.get(10));
							// 备注
							map.put("bak", mapColumnInfoIn.get(11));
							// 备注
							map.put("project_name", mapColumnInfoIn.get(12));
							// 总成件名称 需转码称代码
							map.put("zcj_type", mapColumnInfoIn.get(13));
							// 故障原因
							map.put("falut_reason", mapColumnInfoIn.get(14));
							// 物资编码
							map.put("wz_id", mapColumnInfoIn.get(15));
							// 物资名称
							map.put("wz_name", mapColumnInfoIn.get(16));
							// 序列号
							map.put("wz_sequence", mapColumnInfoIn.get(17));
							// 物资单位
							map.put("wz_prickie", mapColumnInfoIn.get(18));
							// 物资单价
							map.put("wz_price", mapColumnInfoIn.get(19));
							
							// 消耗数量
							map.put("use_num", mapColumnInfoIn.get(20));
							// 备件分类 转换成代码
							map.put("coding_code_id", mapColumnInfoIn.get(21));
							dataList.add(map);

						}
					}
				}
			}
		}

		return dataList;
	}

	public static List getRepMatExcelDataByWSFileDg(WSFile file)
			throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		String s = file.getFilename();
		InputStream is = new ByteArrayInputStream(file.getFileData());
		HSSFWorkbook book = new HSSFWorkbook(is);
		Sheet sheet0 = book.getSheetAt(0);
		int rows = sheet0.getPhysicalNumberOfRows();
		Row row0 = sheet0.getRow(0);
		int columns = row0.getPhysicalNumberOfCells();
		System.out.println(rows);
		for (int m = 1; m < rows; m++) {
			Row row = sheet0.getRow(m);

			Map mapColumnInfoIn = new HashMap();
			for (int n = 0; n < columns; n++) {
				Cell cell = row.getCell(n);
				int cellType = cell.getCellType();
				switch (cellType) {
				case 0:
					if (HSSFDateUtil.isCellDateFormatted(cell)) {
						mapColumnInfoIn.put(n, cell.getDateCellValue());
					} else {
						cell.setCellType(cell.CELL_TYPE_STRING);
						mapColumnInfoIn.put(n, cell.getStringCellValue());
					}
					break;
				case 1:
					mapColumnInfoIn.put(n, cell.getStringCellValue());
					break;
				}
			}
			// 0物资ID 1物资名称 2计量单位 3 调剂单价 4入库数量
			// 0物资编号 1物资分类码 2物资名称 3计量单位 4参考单价 5库存数量 6分类
			Map map = new HashMap();
			map.put("wz_id", mapColumnInfoIn.get(0));
			map.put("wz_name", mapColumnInfoIn.get(2));
			// map.put("wz_prockie", mapColumnInfoIn.get(1));
			// map.put("actual_price", mapColumnInfoIn.get(4)); //单价
			map.put("stock_num", mapColumnInfoIn.get(5));
			System.out.println(map);
			dataList.add(map);
		}
		return dataList;
	}
	/**
	 * 多项目强制保养导入excel解析*
	 * @author zhangjb
	 * @since 2016年6月28日15:16:12
	 * */
	public static List getQzbyExcelDataByWSFile(WSFile file)
			throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}
			if (null != book) {
				Sheet sheet0 = book.getSheetAt(0);
				int rows = sheet0.getPhysicalNumberOfRows();
				if (rows > 2) {
					Row row0 = sheet0.getRow(0);
					int columns = row0.getPhysicalNumberOfCells();
					for (int m = 2; m < rows; m++) {
						Row row = sheet0.getRow(m);

						Map mapColumnInfoIn = new HashMap();
						for (int n = 0; n < columns; n++) {
							Cell cell = row.getCell(n);
							if (null != cell) {
								int cellType = cell.getCellType();
								switch (cellType) {
								case 0:
									if (HSSFDateUtil.isCellDateFormatted(cell)) {
										mapColumnInfoIn.put(n,
												cell.getDateCellValue());
									} else {
										cell.setCellType(cell.CELL_TYPE_STRING);
										mapColumnInfoIn.put(n,
												cell.getStringCellValue().trim());
									}
									break;
								case 1:
									mapColumnInfoIn.put(n,
											cell.getStringCellValue().trim());
									break;
								}
							}

						}
						Map map = new HashMap();
						if (mapColumnInfoIn.get(0) != null) {
							// 设备名称
							map.put("dev_name", mapColumnInfoIn.get(0));
							// 规格型号
							map.put("dev_model", mapColumnInfoIn.get(1));
							// 自编号
							map.put("self_num", mapColumnInfoIn.get(2));
							// 牌照号
							map.put("license_num", mapColumnInfoIn.get(3));
							// 实物标识号
							map.put("dev_sign", mapColumnInfoIn.get(4));
							// erp设备编号
							map.put("dev_coding", mapColumnInfoIn.get(5));
							// 送修日期
							map.put("repair_start_date", mapColumnInfoIn.get(6));
							// 竣工日期
							map.put("repair_end_date", mapColumnInfoIn.get(7));
							// 工时
							map.put("work_hour", mapColumnInfoIn.get(8));
							// 工时费
							map.put("human_cost", mapColumnInfoIn.get(9));
							// 本次保养行驶里程(公里)
							map.put("mileage_total", mapColumnInfoIn.get(10));
							//钻井进尺
							map.put("drilling_footage_total", mapColumnInfoIn.get(11));
							// 工作小时
							map.put("work_hour_total", mapColumnInfoIn.get(12));
							// 承修人
							map.put("repairer", mapColumnInfoIn.get(13));
							// 验收人
							map.put("accepter", mapColumnInfoIn.get(14));
							// 保养内容
							map.put("repair_detail", mapColumnInfoIn.get(15));
							// 保养项目
							map.put("repair_item", mapColumnInfoIn.get(16));
							
							// 物资编码
							map.put("wz_id", mapColumnInfoIn.get(17));
							// 物资名称
							map.put("wz_name", mapColumnInfoIn.get(18));
							// 物资单位
							map.put("wz_prickie", mapColumnInfoIn.get(19));
							// 消耗数量
							map.put("use_num", mapColumnInfoIn.get(20));
							// 物资单价
							map.put("wz_price", mapColumnInfoIn.get(21));
							dataList.add(map);

						}
					}
				}
			}
		}

		return dataList;
	}
	/**
	 * 多项目设备维修导入excel解析*
	 * @author zhangjb
	 * @since 2016年6月30日16:16:12
	 * */
	public static List getSbwxExcelDataByWSFile(WSFile file)
			throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}
			if (null != book) {
				Sheet sheet0 = book.getSheetAt(0);
				int rows = sheet0.getPhysicalNumberOfRows();
				if (rows > 2) {
					Row row0 = sheet0.getRow(0);
					int columns = row0.getPhysicalNumberOfCells();
					for (int m = 2; m < rows; m++) {
						Row row = sheet0.getRow(m);

						Map mapColumnInfoIn = new HashMap();
						for (int n = 0; n < columns; n++) {
							Cell cell = row.getCell(n);
							if (null != cell) {
								int cellType = cell.getCellType();
								switch (cellType) {
								case 0:
									if (HSSFDateUtil.isCellDateFormatted(cell)) {
										mapColumnInfoIn.put(n,
												cell.getDateCellValue());
									} else {
										cell.setCellType(cell.CELL_TYPE_STRING);
										mapColumnInfoIn.put(n,
												cell.getStringCellValue().trim());
									}
									break;
								case 1:
									mapColumnInfoIn.put(n,
											cell.getStringCellValue().trim());
									break;
								}
							}

						}
						Map map = new HashMap();
						if (mapColumnInfoIn.get(0) != null) {
							// 设备名称
							map.put("dev_name", mapColumnInfoIn.get(0));
							// 规格型号
							map.put("dev_model", mapColumnInfoIn.get(1));
							// 自编号
							map.put("self_num", mapColumnInfoIn.get(2));
							// 牌照号
							map.put("license_num", mapColumnInfoIn.get(3));
							// 实物标识号
							map.put("dev_sign", mapColumnInfoIn.get(4));
							// erp设备编号
							map.put("dev_coding", mapColumnInfoIn.get(5));
							// 送修日期
							map.put("repair_start_date", mapColumnInfoIn.get(6));
							// 承修人
							map.put("repairer", mapColumnInfoIn.get(7));
							// 修理类别
							map.put("repair_type", mapColumnInfoIn.get(8));
							// 修理项目
							map.put("repair_item", mapColumnInfoIn.get(9));
							// 修理级别
							map.put("repair_level", mapColumnInfoIn.get(10));
							// 工时费
							map.put("human_cost", mapColumnInfoIn.get(11));
							// 竣工日期
							map.put("repair_end_date", mapColumnInfoIn.get(12));
							// 验收人
							map.put("accepter", mapColumnInfoIn.get(13));
							// 维修状态
							map.put("record_status", mapColumnInfoIn.get(14));
							// 技术状况
							map.put("tech_stat", mapColumnInfoIn.get(15));
							// 保养内容
							map.put("repair_detail", mapColumnInfoIn.get(16));
							// 物资编码
							map.put("wz_id", mapColumnInfoIn.get(17));
							// 物资名称
							map.put("wz_name", mapColumnInfoIn.get(18));
							// 物资单位
							map.put("wz_prickie", mapColumnInfoIn.get(19));
							// 消耗数量
							map.put("use_num", mapColumnInfoIn.get(20));
							// 物资单价
							map.put("wz_price", mapColumnInfoIn.get(21));
							// 总价
							dataList.add(map);

						}
					}
				}
			}
		}

		return dataList;
	}
	/**
	 * 单项目外租设备导入excel解析*
	 * @author zhangjb
	 * @since 2016年7月7日14:16:12
	 * */
	public static List getWzsbExcelDataByWSFile(WSFile file)
			throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}
			if (null != book) {
				Sheet sheet0 = book.getSheetAt(0);
				int rows = sheet0.getPhysicalNumberOfRows();
				if (rows > 1) {
					Row row0 = sheet0.getRow(0);
					int columns = row0.getPhysicalNumberOfCells();
					for (int m = 1; m < rows; m++) {
						Row row = sheet0.getRow(m);

						Map mapColumnInfoIn = new HashMap();
						for (int n = 0; n < columns; n++) {
							Cell cell = row.getCell(n);
							if (null != cell) {
								int cellType = cell.getCellType();
								switch (cellType) {
								case 0:
									if (HSSFDateUtil.isCellDateFormatted(cell)) {
										mapColumnInfoIn.put(n,
												cell.getDateCellValue());
									} else {
										cell.setCellType(cell.CELL_TYPE_STRING);
										mapColumnInfoIn.put(n,
												cell.getStringCellValue().trim());
									}
									break;
								case 1:
									mapColumnInfoIn.put(n,
											cell.getStringCellValue().trim());
									break;
								}
							}

						}
						Map map = new HashMap();
						if (mapColumnInfoIn.get(1) != null) {
							map.put("dev_coding", mapColumnInfoIn.get(0));//设备编号
							map.put("dev_name", mapColumnInfoIn.get(1));//设备名称
							map.put("asset_stat", mapColumnInfoIn.get(2));//资产状态
							map.put("dev_model", mapColumnInfoIn.get(3));//设备类型
							map.put("self_num", mapColumnInfoIn.get(4));//自编号
							map.put("dev_sign", mapColumnInfoIn.get(5));//实物标识号
							map.put("dev_type", mapColumnInfoIn.get(6));//设备编码
							map.put("dev_unit", mapColumnInfoIn.get(7));//计量单位
							map.put("asset_coding", mapColumnInfoIn.get(8));//资产编号(ERP)
							map.put("turn_num", mapColumnInfoIn.get(9));//转资单号
							map.put("order_num", mapColumnInfoIn.get(10));//采购订单号
							map.put("requ_num", mapColumnInfoIn.get(11));//调拨单号
							map.put("asset_value", mapColumnInfoIn.get(12));//资产原值
							map.put("net_value", mapColumnInfoIn.get(13));//资产净值
							map.put("cont_num", mapColumnInfoIn.get(14));//合同号
							map.put("currency", mapColumnInfoIn.get(15));//币种
							map.put("tech_stat", mapColumnInfoIn.get(16));//技术状态
							map.put("using_stat", mapColumnInfoIn.get(17));//使用状态
							map.put("capital_source", mapColumnInfoIn.get(18));//资金来源
							map.put("owning_org_id", mapColumnInfoIn.get(19));//所属单位
							map.put("owning_org_name", mapColumnInfoIn.get(20));//所属单位名称
							map.put("owning_sub_id", mapColumnInfoIn.get(21));//所属单位隶属关系
							map.put("usage_org_id", mapColumnInfoIn.get(22));//所在单位
							map.put("usage_org_name", mapColumnInfoIn.get(23));//所在单位名称
							map.put("usage_sub_id", mapColumnInfoIn.get(24));//所在单位隶属关系
							map.put("dev_position", mapColumnInfoIn.get(25));//所在位置
							map.put("manu_factur", mapColumnInfoIn.get(26));//制造商
							map.put("producting_date", mapColumnInfoIn.get(27));//投产日期
							map.put("account_stat", mapColumnInfoIn.get(28));//在帐状态
							map.put("license_num", mapColumnInfoIn.get(29));//牌照号
							map.put("chassis_num", mapColumnInfoIn.get(30));//底盘号
							map.put("engine_num", mapColumnInfoIn.get(31));//发动机号
							map.put("remark", mapColumnInfoIn.get(32));//备注
							map.put("planning_in_time", mapColumnInfoIn.get(33));//计划开始时间
							map.put("planning_out_time", mapColumnInfoIn.get(34));//计划结束时间
							map.put("actual_in_time", mapColumnInfoIn.get(35));//实际开始时间
							map.put("actual_out_time", mapColumnInfoIn.get(36));//实际结束时间
							map.put("fk_dev_acc_id", mapColumnInfoIn.get(37));//设备总台帐主键
							//map.put("project_info_id", mapColumnInfoIn.get(38));//项目ID
							map.put("out_org_id", mapColumnInfoIn.get(39-1));//出库单位
							map.put("in_org_id", mapColumnInfoIn.get(40-1));//入库单为
							map.put("is_leaving", mapColumnInfoIn.get(41-1));//离队标识 0-未离场  1-已离队
							map.put("fk_device_appmix_id", mapColumnInfoIn.get(42-1));//出库单主键  转移设备单主键
							map.put("search_id", mapColumnInfoIn.get(43-1));//查询主键
							map.put("dev_team", mapColumnInfoIn.get(44-1));//班组
							map.put("stop_date", mapColumnInfoIn.get(45-1));//报停日期
							map.put("restart_date", mapColumnInfoIn.get(46-1));//启动日期
							map.put("mix_type_id", mapColumnInfoIn.get(47-1));//调配类型
							map.put("check_time", mapColumnInfoIn.get(48-1));//检查时间
							map.put("receive_state", mapColumnInfoIn.get(49-1));//验收状态1:合格;0:不合格
							map.put("transfer_state", mapColumnInfoIn.get(50-1));//井中设备转移状态 0：已转入  1：已转出  2：转出中  3：转入已返还  4：转出已返还
							map.put("fk_wells_transfer_id", mapColumnInfoIn.get(51-1));//井中转移设备单主键
							map.put("repair_state", mapColumnInfoIn.get(52-1));//井中设备送修：  1：井中设备已送修  2:送修返还
							map.put("repair_wells_back_id", mapColumnInfoIn.get(53-1));//井中设备送修单主键
							map.put("transfer_type", mapColumnInfoIn.get(54-1));//设备转移类型  0:单项目设备转移  1:多项目井中项目设备转移 2:多项目井中设备分中心设备转移
							map.put("position_id", mapColumnInfoIn.get(55-1));//设备存放地编码
							dataList.add(map);

						}
					}
				}
			}
		}

		return dataList;
	}
	/**
	 * 通过wsfile 解析excel 获取大港导入多项目设备excel中的信息
	 * 
	 * @param IN
	 *            :file wsFile文件、columnList xml配置的excel导入配置信息
	 * 
	 * @param Out
	 *            :List 将excel解析的数据集放置到list中
	 */
	public static List getDEVExcelDataDgByWSFile(WSFile file) throws IOException,
			ExcelExceptionHandler {
		List dataList = new ArrayList();
		// String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}

			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			Row row = sheet0.getRow(0);
			for (int m = 1; m < rows; m++) {
				int columns = row.getPhysicalNumberOfCells();
				System.out.println(columns);
				Map mapColumnInfoIn = new HashMap();
				int blankflag = 0;
				for (int n = 0; n < columns; n++) {
					Cell cell = sheet0.getRow(m).getCell(n);
					if (cell == null) {
						mapColumnInfoIn.put(n, "");
					} else {
						int cellType = cell.getCellType();
						switch (cellType) {
						case 1:
							mapColumnInfoIn.put(n, cell.getStringCellValue());
							break;
						case 0:
							mapColumnInfoIn.put(n, cell.getNumericCellValue());
							break;
						case 3:
							blankflag++;
							break;
						}
					}
					if (n == 26 && blankflag < 26) {
						Map map = new HashMap();

						map.put("dev_coding", mapColumnInfoIn.get(0));
						map.put("dev_name", mapColumnInfoIn.get(1));
						map.put("dev_model", mapColumnInfoIn.get(2));
						map.put("self_num", mapColumnInfoIn.get(3));
						map.put("dev_sign", mapColumnInfoIn.get(4));
						map.put("dev_type", mapColumnInfoIn.get(5));
						map.put("dev_unit", mapColumnInfoIn.get(6));
						map.put("asset_coding", mapColumnInfoIn.get(7));
						map.put("asset_value", mapColumnInfoIn.get(8));
						map.put("net_value", mapColumnInfoIn.get(9));
						map.put("cont_num", mapColumnInfoIn.get(10));
						map.put("currency", mapColumnInfoIn.get(11));
						map.put("tech_stat", mapColumnInfoIn.get(12));
						map.put("using_stat", mapColumnInfoIn.get(13));
						map.put("capital_source", mapColumnInfoIn.get(14));
						//map.put("owning_org_id", mapColumnInfoIn.get(15));//删除所属单位id
						String owning_org_id="";
						String owning_org_name="";
						if(mapColumnInfoIn.get(15)!=""){
							String owning_org=mapColumnInfoIn.get(15).toString();
							int n_pos = owning_org.indexOf("-");
							//String[] tmp = owning_org.split("-");
							owning_org_id = owning_org.substring(n_pos+1,owning_org.length());
							owning_org_name = owning_org.substring(0,n_pos);
						}
						map.put("owning_org_id", owning_org_id);
						map.put("owning_org_name", owning_org_name);
						//map.put("owning_sub_id", mapColumnInfoIn.get(17));//删除所属单位隶属关系id
						map.put("usage_org_id", mapColumnInfoIn.get(16));
						map.put("usage_org_name", mapColumnInfoIn.get(17));
						map.put("usage_sub_id", mapColumnInfoIn.get(18));
						map.put("dev_position", mapColumnInfoIn.get(19));
						//map.put("manu_factur", mapColumnInfoIn.get(22));//删除制造商
						map.put("producting_date", mapColumnInfoIn.get(20));
						map.put("account_stat", mapColumnInfoIn.get(21));
						map.put("license_num", mapColumnInfoIn.get(22));
						map.put("chassis_num", mapColumnInfoIn.get(23));
						map.put("engine_num", mapColumnInfoIn.get(24));
						map.put("remark", mapColumnInfoIn.get(25));
						String[] tmp = null;
						if(mapColumnInfoIn.get(26)!=""){
							String indiv_dev_type = mapColumnInfoIn.get(26).toString();
							tmp = indiv_dev_type.split("-");
					    }
						if(tmp!=null){
							if(tmp.length>0){
								map.put("indiv_dev_type",tmp[1]);
							}else{
								map.put("indiv_dev_type","G15");
							}
						}else{
							map.put("indiv_dev_type","G15");
						}
						
						//System.out.println(map);
						dataList.add(map);
					}
				}
				if (blankflag == 26)
					break;
			}
		}
		return dataList;
	}
	/**
	 * 通过wsfile 解析excel 获取大港导入设备返还中的信息（通用地震仪器和检波器）
	 * 
	 * @param IN
	 *            :file wsFile文件、columnList xml配置的excel导入配置信息
	 * 
	 * @param Out
	 *            :List 将excel解析的数据集放置到list中
	 */
	public static List getDEVExcelBackDetailDataDgByWSFile(WSFile file) throws IOException,
			ExcelExceptionHandler {
		List dataList = new ArrayList();
		// String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}

			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			Row row = sheet0.getRow(0);
			for (int m = 1; m < rows; m++) {
				int columns = row.getPhysicalNumberOfCells();
				System.out.println(columns);
				Map mapColumnInfoIn = new HashMap();
				int blankflag = 0;
				for (int n = 0; n < columns; n++) {
					Cell cell = sheet0.getRow(m).getCell(n);
					if (cell == null) {
						mapColumnInfoIn.put(n, "");
					} else {
						int cellType = cell.getCellType();
						switch (cellType) {
						case 1:
							mapColumnInfoIn.put(n, cell.getStringCellValue());
							break;
						case 0:
							mapColumnInfoIn.put(n, cell.getNumericCellValue());
							break;
						case 3:
							blankflag++;
							break;
						}
					}
					if (n == 5 && blankflag < 5) {
						Map map = new HashMap();

						map.put("dev_coding", mapColumnInfoIn.get(0));
						map.put("dev_name", mapColumnInfoIn.get(1));
						map.put("dev_model", mapColumnInfoIn.get(2));
						//map.put("self_num", mapColumnInfoIn.get(3));
						/*map.put("dev_sign", mapColumnInfoIn.get(4));
						map.put("dev_type", mapColumnInfoIn.get(5));*/
						map.put("dev_unit", mapColumnInfoIn.get(3));
						/*map.put("asset_coding", mapColumnInfoIn.get(7));*/
						map.put("asset_value", mapColumnInfoIn.get(4));
						map.put("net_value", mapColumnInfoIn.get(5));
						/*map.put("cont_num", mapColumnInfoIn.get(10));
						map.put("currency", mapColumnInfoIn.get(11));
						map.put("tech_stat", mapColumnInfoIn.get(12));
						map.put("using_stat", mapColumnInfoIn.get(13));
						map.put("capital_source", mapColumnInfoIn.get(14));
						map.put("owning_org_id", mapColumnInfoIn.get(15));
						map.put("owning_org_name", mapColumnInfoIn.get(16));
						map.put("owning_sub_id", mapColumnInfoIn.get(17));
						map.put("usage_org_id", mapColumnInfoIn.get(18));
						map.put("usage_org_name", mapColumnInfoIn.get(19));
						map.put("usage_sub_id", mapColumnInfoIn.get(20));
						map.put("dev_position", mapColumnInfoIn.get(21));
						map.put("manu_factur", mapColumnInfoIn.get(21));
						map.put("producting_date", mapColumnInfoIn.get(23));
						map.put("account_stat", mapColumnInfoIn.get(24));
						map.put("license_num", mapColumnInfoIn.get(25));
						map.put("chassis_num", mapColumnInfoIn.get(26));
						map.put("engine_num", mapColumnInfoIn.get(27));
						map.put("remark", mapColumnInfoIn.get(28));
						map.put("indiv_dev_type", mapColumnInfoIn.get(29));*/
						System.out.println(map);
						dataList.add(map);
					}
				}
				if (blankflag == 5)
					break;
			}
		}
		return dataList;
	}
	/**
	 *内租设备解析
	 */
	public static List getHireRecDetailInExcelDgByWSFile(WSFile file) throws IOException,
			ExcelExceptionHandler {
		List dataList = new ArrayList();
		// String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}

			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			Row row = sheet0.getRow(0);
			for (int m = 1; m < rows; m++) {
				int columns = row.getPhysicalNumberOfCells();
				System.out.println(columns);
				Map mapColumnInfoIn = new HashMap();
				int blankflag = 0;
				for (int n = 0; n < columns; n++) {
					Cell cell = sheet0.getRow(m).getCell(n);
					if (cell == null) {
						mapColumnInfoIn.put(n, "");
					} else {
						int cellType = cell.getCellType();
						switch (cellType) {
						case 1:
							mapColumnInfoIn.put(n, cell.getStringCellValue());
							break;
						case 0:
							mapColumnInfoIn.put(n, cell.getNumericCellValue());
							break;
						case 3:
							blankflag++;
							break;
						}
					}
					if (n == 8 && blankflag < 8) {
						Map map = new HashMap();
						map.put("hire_dev_class", mapColumnInfoIn.get(0));//租赁类别
						map.put("dev_name", mapColumnInfoIn.get(1));//设备名称
						map.put("dev_model", mapColumnInfoIn.get(2));//设备型号
						map.put("cont_num", mapColumnInfoIn.get(3));//数量
						map.put("asset_value", mapColumnInfoIn.get(4));//原值
						map.put("net_value", mapColumnInfoIn.get(5));//净值
						/*map.put("month_depreciation", mapColumnInfoIn.get(6));//月折旧额
						map.put("unit_price", mapColumnInfoIn.get(7));//租赁单价
*/						map.put("start_date", mapColumnInfoIn.get(6));//到达时间
						map.put("end_date", mapColumnInfoIn.get(7));//离开时间
						map.put("hire_day_num", mapColumnInfoIn.get(8));//租赁天数
						/*map.put("hire_cost", mapColumnInfoIn.get(11));//内部设备租赁费（月折旧+管理费）
						map.put("dev_coding", mapColumnInfoIn.get(12));*/
						System.out.println(map);
						dataList.add(map);
					}
				}
				if (blankflag == 8)
					break;
			}
		}
		return dataList;
	}
	/**
	 *外租设备解析
	 */
	public static List getHireRecDetailOutExcelDgByWSFile(WSFile file) throws IOException,
			ExcelExceptionHandler {
		List dataList = new ArrayList();
		// String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}

			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			Row row = sheet0.getRow(0);
			for (int m = 1; m < rows; m++) {
				int columns = row.getPhysicalNumberOfCells();
				System.out.println(columns);
				Map mapColumnInfoIn = new HashMap();
				int blankflag = 0;
				for (int n = 0; n < columns; n++) {
					Cell cell = sheet0.getRow(m).getCell(n);
					if (cell == null) {
						mapColumnInfoIn.put(n, "");
					} else {
						int cellType = cell.getCellType();
						switch (cellType) {
						case 1:
							mapColumnInfoIn.put(n, cell.getStringCellValue());
							break;
						case 0:
							mapColumnInfoIn.put(n, cell.getNumericCellValue());
							break;
						case 3:
							blankflag++;
							break;
						}
					}
					if (n == 10 && blankflag < 10) {
						Map map = new HashMap();
						map.put("hire_dev_class", "社会");//租赁类别
						map.put("dev_name", mapColumnInfoIn.get(0));//设备名称
						map.put("dev_model", mapColumnInfoIn.get(1));//设备型号
						map.put("project_name", mapColumnInfoIn.get(2));//设备型号
						map.put("cont_num", mapColumnInfoIn.get(3));//数量
						map.put("day_cost", mapColumnInfoIn.get(4));//日租金
						map.put("start_date", mapColumnInfoIn.get(5));//到达时间
						map.put("end_date", mapColumnInfoIn.get(6));//离开时间
						map.put("hire_day_num", mapColumnInfoIn.get(7));//租赁天数
						map.put("other_cost", mapColumnInfoIn.get(8));//数量
						map.put("hire_cost", mapColumnInfoIn.get(9));//内部设备租赁费（月折旧+管理费）
						map.put("dev_coding", mapColumnInfoIn.get(10));
						dataList.add(map);
					}
				}
				if (blankflag == 10)
					break;
			}
		}
		return dataList;
	}
}
