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
 * ���⣺������������˾��̽��������ϵͳ
 * 
 * ��˾: �������
 * 
 * ���ߣ���԰
 * 
 * ������excel��������࣬������ȡ������excel
 */

@SuppressWarnings({ "rawtypes", "unchecked" })
public class ExcelEIResolvingUtil {
	private static ILog log = LogFactory.getLogger(ExcelEIResolvingUtil.class);
	/*
	 * ͨ��wsfile ����excel ��ȡexcel�е���Ϣ
	 * 
	 * @param IN:file wsFile�ļ���columnList xml���õ�excel����������Ϣ
	 * 
	 * @param Out:List ��excel���������ݼ����õ�list��
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
				String bcffsl=valueOf(mapColumnInfoIn.get(4),"");//���η������� 
				//String sjdj=valueOf(mapColumnInfoIn.get(7),"");//ʵ�ʵ��� 
				//String totalmoney=valueOf(mapColumnInfoIn.get(8),"");//���
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
	 * ͨ��wsfile ����excel ��ȡexcel�е���Ϣ
	 * 
	 * @param IN:file wsFile�ļ���columnList xml���õ�excel����������Ϣ
	 * 
	 * @param Out:List ��excel���������ݼ����õ�list��
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
					if (oil_from.equals("����վ")) {
						oil_from = "1";
					} else if (oil_from.equals("�Ϳ�-����")) {
						oil_from = "0";
					}else if (oil_from.equals("�Ϳ�-�Բɹ�")) {
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
	 * ��ָ���ж�,��Ĭ��ֵ create by gaoyunpeng 20150415
	 * 
	 * @param in
	 *            ����ֵ
	 * @param defalutValue
	 *            Ĭ��ֵ
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
	 * ������excel����
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
					if("ERP���ߵ�����".equals(INVOICES_TYPE)){
						map.put("INVOICES_TYPE", "6");
					}
					if("ERP���ߵ�����".equals(INVOICES_TYPE)){
						map.put("INVOICES_TYPE", "7");
					}
					if("���������".equals(INVOICES_TYPE)){
						map.put("INVOICES_TYPE", "8");
					}
					if("���֪ͨ��".equals(INVOICES_TYPE)){
						map.put("INVOICES_TYPE", "9");
					}
					if("ֱ��ɹ�����".equals(INVOICES_TYPE)){
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
			 * ȥ���ظ�����
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
					map.put("alias", mapColumnInfoIn.get(11));//����
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
							// ��������
							map.put("bywx_date", mapColumnInfoIn.get(0));
							// �Ա��
							map.put("self_num", mapColumnInfoIn.get(1));
							// �ۼƹ���Сʱ
							map.put("work_hours", mapColumnInfoIn.get(2));
							// �������
							map.put("maintenance_level", mapColumnInfoIn.get(3));
							// ��������
							map.put("maintenance_desc", mapColumnInfoIn.get(4));
							// ��������
							map.put("performance_desc", mapColumnInfoIn.get(5));
							// ��������
							map.put("falut_desc", mapColumnInfoIn.get(6));
							// ���Ͻ���취
							map.put("falut_case", mapColumnInfoIn.get(7));
							// ��������
							map.put("legacy", mapColumnInfoIn.get(8));
							// ���޵�λ
							map.put("repair_unit", mapColumnInfoIn.get(9));
							// ������
							map.put("repair_men", mapColumnInfoIn.get(10));
							// ��ע
							map.put("bak", mapColumnInfoIn.get(11));
							// ��ע
							map.put("project_name", mapColumnInfoIn.get(12));
							// �ܳɼ����� ��ת��ƴ���
							map.put("zcj_type", mapColumnInfoIn.get(13));
							// ����ԭ��
							map.put("falut_reason", mapColumnInfoIn.get(14));
							// ���ʱ���
							map.put("wz_id", mapColumnInfoIn.get(15));
							// ��������
							map.put("wz_name", mapColumnInfoIn.get(16));
							// ���к�
							map.put("wz_sequence", mapColumnInfoIn.get(17));
							// ���ʵ�λ
							map.put("wz_prickie", mapColumnInfoIn.get(18));
							// ���ʵ���
							map.put("wz_price", mapColumnInfoIn.get(19));
							
							// ��������
							map.put("use_num", mapColumnInfoIn.get(20));
							// �������� ת���ɴ���
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
			// 0����ID 1�������� 2������λ 3 �������� 4�������
			// 0���ʱ�� 1���ʷ����� 2�������� 3������λ 4�ο����� 5������� 6����
			Map map = new HashMap();
			map.put("wz_id", mapColumnInfoIn.get(0));
			map.put("wz_name", mapColumnInfoIn.get(2));
			// map.put("wz_prockie", mapColumnInfoIn.get(1));
			// map.put("actual_price", mapColumnInfoIn.get(4)); //����
			map.put("stock_num", mapColumnInfoIn.get(5));
			System.out.println(map);
			dataList.add(map);
		}
		return dataList;
	}
	/**
	 * ����Ŀǿ�Ʊ�������excel����*
	 * @author zhangjb
	 * @since 2016��6��28��15:16:12
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
							// �豸����
							map.put("dev_name", mapColumnInfoIn.get(0));
							// ����ͺ�
							map.put("dev_model", mapColumnInfoIn.get(1));
							// �Ա��
							map.put("self_num", mapColumnInfoIn.get(2));
							// ���պ�
							map.put("license_num", mapColumnInfoIn.get(3));
							// ʵ���ʶ��
							map.put("dev_sign", mapColumnInfoIn.get(4));
							// erp�豸���
							map.put("dev_coding", mapColumnInfoIn.get(5));
							// ��������
							map.put("repair_start_date", mapColumnInfoIn.get(6));
							// ��������
							map.put("repair_end_date", mapColumnInfoIn.get(7));
							// ��ʱ
							map.put("work_hour", mapColumnInfoIn.get(8));
							// ��ʱ��
							map.put("human_cost", mapColumnInfoIn.get(9));
							// ���α�����ʻ���(����)
							map.put("mileage_total", mapColumnInfoIn.get(10));
							//�꾮����
							map.put("drilling_footage_total", mapColumnInfoIn.get(11));
							// ����Сʱ
							map.put("work_hour_total", mapColumnInfoIn.get(12));
							// ������
							map.put("repairer", mapColumnInfoIn.get(13));
							// ������
							map.put("accepter", mapColumnInfoIn.get(14));
							// ��������
							map.put("repair_detail", mapColumnInfoIn.get(15));
							// ������Ŀ
							map.put("repair_item", mapColumnInfoIn.get(16));
							
							// ���ʱ���
							map.put("wz_id", mapColumnInfoIn.get(17));
							// ��������
							map.put("wz_name", mapColumnInfoIn.get(18));
							// ���ʵ�λ
							map.put("wz_prickie", mapColumnInfoIn.get(19));
							// ��������
							map.put("use_num", mapColumnInfoIn.get(20));
							// ���ʵ���
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
	 * ����Ŀ�豸ά�޵���excel����*
	 * @author zhangjb
	 * @since 2016��6��30��16:16:12
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
							// �豸����
							map.put("dev_name", mapColumnInfoIn.get(0));
							// ����ͺ�
							map.put("dev_model", mapColumnInfoIn.get(1));
							// �Ա��
							map.put("self_num", mapColumnInfoIn.get(2));
							// ���պ�
							map.put("license_num", mapColumnInfoIn.get(3));
							// ʵ���ʶ��
							map.put("dev_sign", mapColumnInfoIn.get(4));
							// erp�豸���
							map.put("dev_coding", mapColumnInfoIn.get(5));
							// ��������
							map.put("repair_start_date", mapColumnInfoIn.get(6));
							// ������
							map.put("repairer", mapColumnInfoIn.get(7));
							// �������
							map.put("repair_type", mapColumnInfoIn.get(8));
							// ������Ŀ
							map.put("repair_item", mapColumnInfoIn.get(9));
							// ������
							map.put("repair_level", mapColumnInfoIn.get(10));
							// ��ʱ��
							map.put("human_cost", mapColumnInfoIn.get(11));
							// ��������
							map.put("repair_end_date", mapColumnInfoIn.get(12));
							// ������
							map.put("accepter", mapColumnInfoIn.get(13));
							// ά��״̬
							map.put("record_status", mapColumnInfoIn.get(14));
							// ����״��
							map.put("tech_stat", mapColumnInfoIn.get(15));
							// ��������
							map.put("repair_detail", mapColumnInfoIn.get(16));
							// ���ʱ���
							map.put("wz_id", mapColumnInfoIn.get(17));
							// ��������
							map.put("wz_name", mapColumnInfoIn.get(18));
							// ���ʵ�λ
							map.put("wz_prickie", mapColumnInfoIn.get(19));
							// ��������
							map.put("use_num", mapColumnInfoIn.get(20));
							// ���ʵ���
							map.put("wz_price", mapColumnInfoIn.get(21));
							// �ܼ�
							dataList.add(map);

						}
					}
				}
			}
		}

		return dataList;
	}
	/**
	 * ����Ŀ�����豸����excel����*
	 * @author zhangjb
	 * @since 2016��7��7��14:16:12
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
							map.put("dev_coding", mapColumnInfoIn.get(0));//�豸���
							map.put("dev_name", mapColumnInfoIn.get(1));//�豸����
							map.put("asset_stat", mapColumnInfoIn.get(2));//�ʲ�״̬
							map.put("dev_model", mapColumnInfoIn.get(3));//�豸����
							map.put("self_num", mapColumnInfoIn.get(4));//�Ա��
							map.put("dev_sign", mapColumnInfoIn.get(5));//ʵ���ʶ��
							map.put("dev_type", mapColumnInfoIn.get(6));//�豸����
							map.put("dev_unit", mapColumnInfoIn.get(7));//������λ
							map.put("asset_coding", mapColumnInfoIn.get(8));//�ʲ����(ERP)
							map.put("turn_num", mapColumnInfoIn.get(9));//ת�ʵ���
							map.put("order_num", mapColumnInfoIn.get(10));//�ɹ�������
							map.put("requ_num", mapColumnInfoIn.get(11));//��������
							map.put("asset_value", mapColumnInfoIn.get(12));//�ʲ�ԭֵ
							map.put("net_value", mapColumnInfoIn.get(13));//�ʲ���ֵ
							map.put("cont_num", mapColumnInfoIn.get(14));//��ͬ��
							map.put("currency", mapColumnInfoIn.get(15));//����
							map.put("tech_stat", mapColumnInfoIn.get(16));//����״̬
							map.put("using_stat", mapColumnInfoIn.get(17));//ʹ��״̬
							map.put("capital_source", mapColumnInfoIn.get(18));//�ʽ���Դ
							map.put("owning_org_id", mapColumnInfoIn.get(19));//������λ
							map.put("owning_org_name", mapColumnInfoIn.get(20));//������λ����
							map.put("owning_sub_id", mapColumnInfoIn.get(21));//������λ������ϵ
							map.put("usage_org_id", mapColumnInfoIn.get(22));//���ڵ�λ
							map.put("usage_org_name", mapColumnInfoIn.get(23));//���ڵ�λ����
							map.put("usage_sub_id", mapColumnInfoIn.get(24));//���ڵ�λ������ϵ
							map.put("dev_position", mapColumnInfoIn.get(25));//����λ��
							map.put("manu_factur", mapColumnInfoIn.get(26));//������
							map.put("producting_date", mapColumnInfoIn.get(27));//Ͷ������
							map.put("account_stat", mapColumnInfoIn.get(28));//����״̬
							map.put("license_num", mapColumnInfoIn.get(29));//���պ�
							map.put("chassis_num", mapColumnInfoIn.get(30));//���̺�
							map.put("engine_num", mapColumnInfoIn.get(31));//��������
							map.put("remark", mapColumnInfoIn.get(32));//��ע
							map.put("planning_in_time", mapColumnInfoIn.get(33));//�ƻ���ʼʱ��
							map.put("planning_out_time", mapColumnInfoIn.get(34));//�ƻ�����ʱ��
							map.put("actual_in_time", mapColumnInfoIn.get(35));//ʵ�ʿ�ʼʱ��
							map.put("actual_out_time", mapColumnInfoIn.get(36));//ʵ�ʽ���ʱ��
							map.put("fk_dev_acc_id", mapColumnInfoIn.get(37));//�豸��̨������
							//map.put("project_info_id", mapColumnInfoIn.get(38));//��ĿID
							map.put("out_org_id", mapColumnInfoIn.get(39-1));//���ⵥλ
							map.put("in_org_id", mapColumnInfoIn.get(40-1));//��ⵥΪ
							map.put("is_leaving", mapColumnInfoIn.get(41-1));//��ӱ�ʶ 0-δ�볡  1-�����
							map.put("fk_device_appmix_id", mapColumnInfoIn.get(42-1));//���ⵥ����  ת���豸������
							map.put("search_id", mapColumnInfoIn.get(43-1));//��ѯ����
							map.put("dev_team", mapColumnInfoIn.get(44-1));//����
							map.put("stop_date", mapColumnInfoIn.get(45-1));//��ͣ����
							map.put("restart_date", mapColumnInfoIn.get(46-1));//��������
							map.put("mix_type_id", mapColumnInfoIn.get(47-1));//��������
							map.put("check_time", mapColumnInfoIn.get(48-1));//���ʱ��
							map.put("receive_state", mapColumnInfoIn.get(49-1));//����״̬1:�ϸ�;0:���ϸ�
							map.put("transfer_state", mapColumnInfoIn.get(50-1));//�����豸ת��״̬ 0����ת��  1����ת��  2��ת����  3��ת���ѷ���  4��ת���ѷ���
							map.put("fk_wells_transfer_id", mapColumnInfoIn.get(51-1));//����ת���豸������
							map.put("repair_state", mapColumnInfoIn.get(52-1));//�����豸���ޣ�  1�������豸������  2:���޷���
							map.put("repair_wells_back_id", mapColumnInfoIn.get(53-1));//�����豸���޵�����
							map.put("transfer_type", mapColumnInfoIn.get(54-1));//�豸ת������  0:����Ŀ�豸ת��  1:����Ŀ������Ŀ�豸ת�� 2:����Ŀ�����豸�������豸ת��
							map.put("position_id", mapColumnInfoIn.get(55-1));//�豸��ŵر���
							dataList.add(map);

						}
					}
				}
			}
		}

		return dataList;
	}
	/**
	 * ͨ��wsfile ����excel ��ȡ��۵������Ŀ�豸excel�е���Ϣ
	 * 
	 * @param IN
	 *            :file wsFile�ļ���columnList xml���õ�excel����������Ϣ
	 * 
	 * @param Out
	 *            :List ��excel���������ݼ����õ�list��
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
						//map.put("owning_org_id", mapColumnInfoIn.get(15));//ɾ��������λid
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
						//map.put("owning_sub_id", mapColumnInfoIn.get(17));//ɾ��������λ������ϵid
						map.put("usage_org_id", mapColumnInfoIn.get(16));
						map.put("usage_org_name", mapColumnInfoIn.get(17));
						map.put("usage_sub_id", mapColumnInfoIn.get(18));
						map.put("dev_position", mapColumnInfoIn.get(19));
						//map.put("manu_factur", mapColumnInfoIn.get(22));//ɾ��������
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
	 * ͨ��wsfile ����excel ��ȡ��۵����豸�����е���Ϣ��ͨ�õ��������ͼ첨����
	 * 
	 * @param IN
	 *            :file wsFile�ļ���columnList xml���õ�excel����������Ϣ
	 * 
	 * @param Out
	 *            :List ��excel���������ݼ����õ�list��
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
	 *�����豸����
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
						map.put("hire_dev_class", mapColumnInfoIn.get(0));//�������
						map.put("dev_name", mapColumnInfoIn.get(1));//�豸����
						map.put("dev_model", mapColumnInfoIn.get(2));//�豸�ͺ�
						map.put("cont_num", mapColumnInfoIn.get(3));//����
						map.put("asset_value", mapColumnInfoIn.get(4));//ԭֵ
						map.put("net_value", mapColumnInfoIn.get(5));//��ֵ
						/*map.put("month_depreciation", mapColumnInfoIn.get(6));//���۾ɶ�
						map.put("unit_price", mapColumnInfoIn.get(7));//���޵���
*/						map.put("start_date", mapColumnInfoIn.get(6));//����ʱ��
						map.put("end_date", mapColumnInfoIn.get(7));//�뿪ʱ��
						map.put("hire_day_num", mapColumnInfoIn.get(8));//��������
						/*map.put("hire_cost", mapColumnInfoIn.get(11));//�ڲ��豸���޷ѣ����۾�+����ѣ�
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
	 *�����豸����
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
						map.put("hire_dev_class", "���");//�������
						map.put("dev_name", mapColumnInfoIn.get(0));//�豸����
						map.put("dev_model", mapColumnInfoIn.get(1));//�豸�ͺ�
						map.put("project_name", mapColumnInfoIn.get(2));//�豸�ͺ�
						map.put("cont_num", mapColumnInfoIn.get(3));//����
						map.put("day_cost", mapColumnInfoIn.get(4));//�����
						map.put("start_date", mapColumnInfoIn.get(5));//����ʱ��
						map.put("end_date", mapColumnInfoIn.get(6));//�뿪ʱ��
						map.put("hire_day_num", mapColumnInfoIn.get(7));//��������
						map.put("other_cost", mapColumnInfoIn.get(8));//����
						map.put("hire_cost", mapColumnInfoIn.get(9));//�ڲ��豸���޷ѣ����۾�+����ѣ�
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
