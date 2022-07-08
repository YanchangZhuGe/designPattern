package fixVersion;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.junit.platform.commons.util.StringUtils;

import java.io.*;
import java.util.*;

/**
 * 定板脚本生成
 * 1.可通过本地excel文件导出
 * 表格如果是xlsx，另存是保存为xls文件
 */
public class ExcelToSqlTest {
    /**
     * add 2017-10-20 denghuajie
     * 解决 POI Unable to read entire block; 409 bytes read; expected 512 bytes  BUG
     * 需要说明的是如果文件被 WPS 等软件打开后就没问题了, 只有将下载的用户导入模块直接上传时才会报错
     * <br>原因：POI 读取文件时是以 512 byte 读取的, 如果文件最后长度不满足 512 就会报错
     * <br>解决思路: 将文件最后不满足 512 长度的强制填充至 512 长度
     */
    //========================================================//
    public static void main(String[] args) throws IOException {
        File file = new File("D:/var/aaaq.xls");
        //固定输出sql
        BufferedWriter eams_appsign = fileUtils.mikFile("eams_appsign.sql");
        eams_appsign.write(SqlConst.getAppsignSql());
        BufferedWriter eams_system = fileUtils.mikFile("eams_system.sql");
        eams_system.write(SqlConst.getSystemSql());
        BufferedWriter eams_buss_property = fileUtils.mikFile("eams_buss_property.sql");
        eams_buss_property.write(SqlConst.getEams_buss_property());
        //根据excel表格输出
        FileInputStream input = null;
        ByteArrayOutputStream byteOS = new ByteArrayOutputStream();
        InputStream byteIS = null;
        try {
            input = new FileInputStream(file);
            byte[] by = new byte[512];
            int t = input.read(by, 0, by.length);
            while (t > 0) {
                byteOS.write(by, 0, 512);
                t = input.read(by, 0, by.length);
            }
            byteIS = new ByteArrayInputStream(byteOS.toByteArray());
            //========================================================//
            HSSFWorkbook wb = new HSSFWorkbook(byteIS);
            hssfWorkbook(wb);
        } catch (FileNotFoundException e) {
            System.out.println("文件未找到:" + file.getName());
            throw new RuntimeException("文件未找到" + file.getName());
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("请选择xls文件，如果是xlsx格式请先自行转换！");
        } catch (RuntimeException e) {
            System.out.println(e.getMessage());
            throw new RuntimeException(e.getMessage());
        } finally {
            eams_appsign.close();
            eams_system.close();
            eams_buss_property.close();
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    System.out.println("文件流关闭失败");
                }
            }
            if (byteIS != null) {
                try {
                    byteIS.close();
                } catch (IOException e) {
                }
            }
            try {
                byteOS.close();
            } catch (IOException e) {
            }
        }
    }

    public static void hssfWorkbook(HSSFWorkbook wb) throws IOException {
        // 取第一个sheet
        int sheetSize = wb.getNumberOfSheets();
        if (sheetSize < 1) {
            throw new RuntimeException("文件没有sheet页签");
        }
        HSSFSheet sheet = null;
        List<List<String>> allRows = new ArrayList<List<String>>();
        BufferedWriter out = null;
        try {
            //获取第几个工作簿0-x,0指第一个
            sheet = wb.getSheetAt(1);
            int rowSize = sheet.getLastRowNum() + 1;
            //System.out.println(rowSize);
            for (int j = 0; j < rowSize; j++) {// 遍历行
                HSSFRow row = sheet.getRow(j);
                if (row == null) {// 略过空行
                    continue;
                }
                List<String> newRow = fileUtils.convertRow(row, j);
                allRows.add(newRow);
            }
            String appno = "020100000";
            String uuid3 = null;
            // 附件类型从excel中读取
            Map<String, String> fileMap = new HashMap<>();
            //维护attachfile表
            String attsql = attachfileSQL(allRows, fileMap);
            out = fileUtils.mikFile("eams_attachfile.sql");
            out.write(attsql);
            out.close();
            //维护busstype，attach_buss_type表
            // todo eams_buss_property这个表也可以维护在下面方法中
            busstypeAndattach(allRows, appno, uuid3, fileMap);
        } finally {
            out.close();
        }
    }

    private static void busstypeAndattach(List<List<String>> allRows, String appno, String uuid3, Map<String, String> fileMap) throws IOException {
        String treeno = null;
        String treeno2 = null;
        String treeno3 = null;
        String sql;
        String sql2 = "";
//        sql2 += "delete from eams_attachfile_busstype";
//        sql2 += ";";
//        sql2 += "\n";
        BufferedWriter eams_attachfile_busstype = fileUtils.mikFile("eams_attachfile_busstype.sql");
        BufferedWriter eams_buss_type = fileUtils.mikFile("eams_buss_type.sql");
        for (int j = 1; j < allRows.size(); j++) {
            List<String> rs = allRows.get(j);
            String workItemCode = rs.get(10);
            sql = "";
            if (uuid3 != null) {
                String workItemName4 = rs.get(3);
                String isRequired = rs.get(6);
                String fileSize = rs.get(7);
                if ((workItemName4 != null && !"".equals(workItemName4))) {
                    if (fileMap.containsKey(workItemName4)) {
                        int isrqud = 0;
                        if (isRequired != null && isRequired.equals("是")) {
                            isrqud = 1;
                        } else {
                            isrqud = 0;
                        }
                        Integer size;
                        if (StringUtils.isNotBlank(fileSize)) {
                            size = Integer.valueOf(fileSize);
                        } else {
                            size = 100;
                        }
                        sql2 += "\n";
                        sql2 += "insert into eams_attachfile_busstype (attno,buss_id,required) values( '" + fileMap.get(workItemName4) + "','" + uuid3 + "'," + isrqud + ")";
                        sql2 += ";";
                    }
                }
            }

            //维护业务类型表
            if (workItemCode != null && !"".equals(workItemCode)) {
                if (workItemCode.length() == 3) {
                    String workItemName1 = rs.get(0);
                    if (treeno == null) {
                        treeno = "001";
                    } else {
                        treeno2 = "000000";
                        int no = Integer.parseInt(treeno) + 1;
                        if (no < 10) {
                            treeno = "00" + no;
                        } else if (no >= 10 && no < 100) {
                            treeno = "0" + no;
                        } else {
                            treeno = "" + no;
                        }
                    }
                    String uuid = UUID.randomUUID().toString();
                    uuid = uuid.replace("-", "");
                    sql += "\n";
                    sql += "insert into eams_buss_type (buss_id,treeno,appno,buss_value,buss_name,grade,isdeleted) select '" + uuid + "','" + treeno + "','" + appno + "','" + workItemCode + "','" + workItemName1 + "'," + 1 + "," + 0 + " from dual where not exists(select 1 from eams_buss_type where buss_value = '" + workItemCode + "');";
                    eams_buss_type.write(sql);
                    continue;
                }
                if (workItemCode.length() == 6) {
                    String workItemName2 = rs.get(1);
                    if (treeno2 == null) {
                        treeno2 = treeno + "001";
                    } else {
                        treeno3 = "000000000";
                        String substring = treeno2.substring(3, 6);
                        int no = Integer.parseInt(substring) + 1;
                        if (no < 10) {
                            treeno2 = treeno + "00" + no;
                        } else if (no >= 10 && no < 100) {
                            treeno2 = treeno + "0" + no;
                        } else {
                            treeno2 = treeno + "" + no;
                        }
                    }
                    String uuid = UUID.randomUUID().toString();
                    uuid = uuid.replace("-", "");
                    sql += "\n";
                    sql += "insert into eams_buss_type (buss_id,treeno,appno,buss_value,buss_name,grade,isdeleted) select '" + uuid + "','" + treeno2 + "','" + appno + "','" + workItemCode + "','" + workItemName2 + "'," + 2 + "," + 0 + " from dual where not exists(select 1 from eams_buss_type where buss_value = '" + workItemCode + "');";
                    eams_buss_type.write(sql);
                    //System.out.println(sql);
                    continue;
                }
                if (workItemCode.length() == 9) {
                    String workItemName3 = rs.get(2);
                    if (treeno3 == null) {
                        treeno3 = treeno2 + "001";
                    } else {
                        String substring = treeno3.substring(6, 9);
                        int no = Integer.parseInt(substring) + 1;
                        if (no < 10) {
                            treeno3 = treeno2 + "00" + no;
                        } else if (no >= 10 && no < 100) {
                            treeno3 = treeno2 + "0" + no;
                        } else {
                            treeno3 = treeno2 + "" + no;
                        }
                    }
                    uuid3 = UUID.randomUUID().toString().replace("-", "");
                    sql += "\n";
                    sql += "insert into eams_buss_type (buss_id,treeno,appno,buss_value,buss_name,grade,isdeleted) select '" + uuid3 + "','" + treeno3 + "','" + appno + "','" + workItemCode + "','" + workItemName3 + "'," + 3 + "," + 0 + " from dual where not exists(select 1 from eams_buss_type where buss_value = '" + workItemCode + "');";
                    eams_buss_type.write(sql);
                    continue;
                }
            }
        }
        eams_buss_type.close();
        eams_attachfile_busstype.write(sql2);
        eams_attachfile_busstype.close();
    }

    private static String attachfileSQL(List<List<String>> allRows, Map<String, String> fileMap) {
        //维护档案表
        ArrayList<Object> list = new ArrayList<>();
        String attsql = "";
        attsql += "delete from eams_attachfile";
        attsql += ";";
        attsql += "\n";
        int attnoInt = 11;
        for (int j = 1; j < allRows.size(); j++) {
            List<String> rs = allRows.get(j);
            String attname = rs.get(3);
            String attno = rs.get(4);
            String remark = rs.get(5);
            String isRequired = rs.get(6);
            String fileSize = rs.get(7);
            if (!attname.equals("") && attname != null) {
                if (list.contains(attname)) {
                    continue;
                }
                int isrqud = 0;
                if (isRequired != null && isRequired.equals("是")) {
                    isrqud = 1;
                } else {
                    isrqud = 0;
                }
                Integer size;
                if (StringUtils.isNotBlank(fileSize)) {
                    size = Integer.valueOf(fileSize);
                } else {
                    size = 100;
                }
                if (StringUtils.isBlank(attno)) {
                    attno = "0" + attnoInt;
                    attnoInt++;
                }
                attsql += "\n";
                String pub = "','system', null,'修改人', null, '" + remark + "', null, null, 0," + size + ",0,0," + isrqud + ",null,null from dual where not exists(select 1 from EAMS_ATTACHFILE where ATTNO = '" + attno + "');";
                attsql += "insert into eams_attachfile(ATTNO, ATTNAME, CREATOR, CREATETIME, UPDATEONE, UPDATETIMEDATE, REMARK,STARTDATE, ENDDATE,ISDELETED,att_size,can_use,longterm,required,validityday,remindday) select '" + attno + "','" + attname + pub;
                list.add(attname);
                fileMap.put(attname, attno);
            }
        }
        return attsql;
    }


}

