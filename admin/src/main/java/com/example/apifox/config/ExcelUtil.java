package com.example.apifox.config;

import com.nstc.common.utils.date.DateUtil;
import com.nstc.lms.entity.scope.ExportField;
import com.nstc.lms.enums.ExcelExport;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.*;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.*;
import java.util.stream.Collectors;

/**
 * <p>Title: </p>
 *
 * <p>Description: </p>
 *
 * <p>Company: 北京九恒星科技股份有限公司</p>
 *
 * @author baixiaodong
 * @since @date 2022/06/09 16:10
 */
public class ExcelUtil {

    public static HSSFWorkbook export(List<?> datas,Integer dir) throws Exception {
        if(datas==null||datas.isEmpty()){
            return null;
        }
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet("sheet");
        sheet.setDefaultColumnWidth((short) 30);
        List<ExportField> fields = getField(datas.get(0),dir);
        List<String> header = getHeader(fields);
        int num=0;
        createRow(sheet,header,num++);
        for (Object data : datas) {
            List<List<String>> rows = new ArrayList<>();
            List<String> value = getValue(fields, data, rows);
            //一对一
            if(rows.isEmpty()){
                createRow(sheet,value,num++);
            }else{//一对多
                for (int i = 0; i < rows.size(); i++) {
                    List<String> node = rows.get(i);
                    createRow(sheet,node,num++);
                }
            }
        }
        return workbook;
    }

    private static void createRow(HSSFSheet sheet,List<String> data,int num){
        HSSFRow head = sheet.createRow(num);
        for (int i = 0; i < data.size(); i++) {
            HSSFCell cell = head.createCell(i);
            cell.setCellValue(data.get(i));
        }
    }

    private static List<ExportField> getField(Object obj,int dir)throws Exception{
        List<Field> fields = Arrays.stream(obj.getClass().getDeclaredFields())
                .filter(field -> {
                    ExcelExport annotation = field.getAnnotation(ExcelExport.class);
                    if (annotation == null) {
                        return false;
                    }
                    if(annotation.dir()==0||annotation.dir()==dir){
                        return true;
                    }
                    return false;
                })
                .sorted((f1, f2) -> {
                    int order1 = f1.getAnnotation(ExcelExport.class).order();
                    int order2 = f2.getAnnotation(ExcelExport.class).order();
                    return order1 - order2;
                })
                .collect(Collectors.toList());
        List<ExportField> result= new ArrayList<>();
        for (Field field : fields) {
            ExcelExport annotation = field.getAnnotation(ExcelExport.class);
            field.setAccessible(true);
            ExportField exportField=new ExportField();
            exportField.setFieldName(field.getName());
            if(annotation.list()){
                Object value = field.get(obj);
                if(value!=null){
                    List<ExportField> fieldList = getField(((Collection) value).iterator().next(),dir);
                    exportField.setFields(fieldList);
                }
            }
            exportField.setField(field);
            result.add(exportField);
        }
        return result;
    }

    private static List<String> getHeader(List<ExportField> fields) throws Exception {
        List<String> headers=new ArrayList<>();
        for (ExportField field : fields) {
            if(field.getFields()!=null){
                List<String> header = getHeader(field.getFields());
                headers.addAll(header);
            }else{
                ExcelExport annotation = field.getField().getAnnotation(ExcelExport.class);
                headers.add(annotation.header());
            }
        }
        return headers;
    }


    /**
     *
     * @param obj
     * @throws
     */
    private static List<String> getValue(List<ExportField> fieldList,Object obj,List<List<String>> rows) throws Exception {
        ArrayList<String> row=new ArrayList<>();
        for (ExportField exportField : fieldList) {
            Field field = exportField.getField();
            ExcelExport annotation = field.getAnnotation(ExcelExport.class);
            Object value = field.get(obj);
            if(!Objects.isNull(value)){
                if(value instanceof Collection){
                    List<ExportField> fields = exportField.getFields();
                    Iterator iterator = ((Collection)value).iterator();
                    while (iterator.hasNext()) {
                        Object next = iterator.next();
                        List<String> curRow = getValue(fields, next,rows);
                        ArrayList<String> copy = (ArrayList<String>) row.clone();
                        copy.addAll(curRow);
                        rows.add(copy);
                    }
                }else{
                    Object newValue =null;
                    if(value instanceof Date){
                        String format = annotation.dateFormat();
                        newValue = DateUtil.format((Date)value, format);
                    }
                    if(annotation.dict()){
                        String className = annotation.enumClass();
                        String methodName = annotation.methodName();
                        if(StringUtils.isNotBlank(className)&&StringUtils.isNotBlank(methodName)){
                            Class<?> clazz = Class.forName(className);
                            Method method = clazz.getMethod(methodName,value.getClass());
                            newValue = method.invoke(null, value);
                        }
                    }
                    row.add(Objects.isNull(newValue)?value.toString():newValue.toString());
                }
            }else{
                row.add("");
            }
        }
        return row;
    }

}
