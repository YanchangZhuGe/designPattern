package fixVersion;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class fileUtils {
    static final String dirPath = "d:/var";

    public static BufferedWriter mikFile(String sqlName) throws IOException {
        String strPath = dirPath + File.separator + sqlName;
        File file = new File(strPath);
        File fileParent = file.getParentFile();
        if (!fileParent.exists()) {
            fileParent.mkdirs();
            System.out.println("文件创建成功！");
        }
        file.createNewFile();
        BufferedWriter out = new BufferedWriter(new FileWriter(file, true));
        return out;
    }

    public static List<String> convertRow(HSSFRow row, int rowIndex) {
        List newRow = convertRow(row);
        if (newRow.size() < 2) {
            throw new RuntimeException("导入文件不符合要求：有效数据行数小于2！");
        }

        //	newRow.add(Integer.toString(rowIndex + 1));
        return newRow;
    }

    public static List<String> convertRow(HSSFRow row) {
        List newRow = new ArrayList();
        int cellSize = row.getLastCellNum();// 行中有多少个单元格，也就是有多少列
        for (short k = 0; k < cellSize; k++) {
            HSSFCell cell = row.getCell(k);
            String key = getCellTypes(cell);
            newRow.add(key);
        }
        return newRow;
    }

    public static String getCellTypes(HSSFCell cell) {
        String cellValue = null;
        if (null != cell) {
            // 以下是判断数据的类型
            switch (cell.getCellType()) {
                case HSSFCell.CELL_TYPE_NUMERIC: // 数字
                    // 处理日期格式、时间格式
                    if (HSSFDateUtil.isCellDateFormatted(cell)) {
                        Date d = cell.getDateCellValue();
                        DateFormat formater = new SimpleDateFormat("yyyy-MM-dd");
                        cellValue = formater.format(d);
                    } else {
                        DecimalFormat df = new DecimalFormat("0");
                        cellValue = df.format(cell.getNumericCellValue());
                    }
                    break;
                case HSSFCell.CELL_TYPE_STRING: // 字符串
                    cellValue = cell.getStringCellValue();
                    break;
                case HSSFCell.CELL_TYPE_BOOLEAN: // Boolean
                    cellValue = cell.getBooleanCellValue() + "";
                    break;
                case HSSFCell.CELL_TYPE_FORMULA: // 公式
                    // cellValue = cell.getCellFormula() + "";
                    try {
                        DecimalFormat df = new DecimalFormat("0.0000");
                        cellValue = String.valueOf(df.format(cell
                                .getNumericCellValue()));
                    } catch (IllegalStateException e) {
                        cellValue = String.valueOf(cell.getStringCellValue()); // ???????
                    }
                    break;
                case HSSFCell.CELL_TYPE_BLANK: // 空值
                    cellValue = "";
                    break;
                case HSSFCell.CELL_TYPE_ERROR: // 故障
                    cellValue = "非法字符";
                    break;
                default:
                    cellValue = "未知类型";
                    break;
            }
        }
        return cellValue;
    }

}
