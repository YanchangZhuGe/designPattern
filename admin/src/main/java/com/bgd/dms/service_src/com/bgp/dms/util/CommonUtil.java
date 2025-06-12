package com.bgp.dms.util;

import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
/**
 * ����������
 * @author �³�
 * 2015-2-10
 */
public class CommonUtil {

	/**
	 * �������뵥�� cc add
	 * @return
	 */
	public static String getScrapeAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "�������뵥"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	
	/**
	 * �������뵥�� zjb add
	 * @return
	 */
	public static String getScrapeAppNoWithOrgName(String orgName,int no){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return orgName+sdf.format(new Date())+no;
	}
	/**
	 * ���ϻ��ܵ��� cc add
	 * @return
	 */
	public static String getScrapeCollectNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "���ϻ��ܵ�"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * �����ϱ����� cc add
	 * @return
	 */
	public static String getScrapeReportNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "�����ϱ���"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * ���ϴ������뵥�� cc add
	 * @return
	 */
	public static String getDisposeAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "���ϴ������뵥"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	
	/**
	 * ���ϴ��ý������ cc add
	 * @return
	 */
	public static String getDisposeResultNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "���ϴ��ý����"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	
	/**
	 * ��ȡsql
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public static String getAutoScoreSql(Map<Map,List<Map>> map) throws Exception{
		String sql="";
		if(MapUtils.isNotEmpty(map)){
			int i=1;
			for(Map kMap:map.keySet()){
				String confFlag=(String) kMap.get("conf_content_type");
				if("0".equals(confFlag)){
					if (MapUtils.isNotEmpty(kMap)){
						sql+=" select ";
						//���ò�ѯ��
						String conf_column_name=kMap.get("conf_column_name") == null ? "" : (String) kMap.get("conf_column_name");
						if(StringUtils.isNotBlank(conf_column_name)) {
							sql+=conf_column_name;
						}else{
							throw new Exception();
						}
						//���ñ�����
						String conf_table_name=kMap.get("conf_table_name") == null ? "" : (String) kMap.get("conf_table_name");
						if(StringUtils.isNotBlank(conf_table_name)) {
							sql+=" from "+conf_table_name;
						}else{
							throw new Exception();
						}
						sql+=" where 1=1 ";
					}else{
						throw new Exception();
					}
					List<Map> sList=map.get(kMap);
					if(CollectionUtils.isNotEmpty(sList)){
						for(Map sMap:sList){
							if(MapUtils.isNotEmpty(sMap)){
								//����������������
								String connect_type=sMap.get("connect_type") == null ? "" : (String) sMap.get("connect_type");
								if(StringUtils.isNotBlank(connect_type)) {
									sql+=connect_type+" ";
								}else{
									throw new Exception();
								}
								//����������
								String filter_column_name=sMap.get("filter_column_name") == null ? "" : (String) sMap.get("filter_column_name");
								if(StringUtils.isNotBlank(filter_column_name)) {
									sql+=filter_column_name+" ";
								}else{
									throw new Exception();
								}
								//��������������
								String query_type=sMap.get("query_type") == null ? "" : (String) sMap.get("query_type");
								if(StringUtils.isNotBlank(query_type)) {
									sql+=query_type+" ";
								}else{
									throw new Exception();
								}
								//����������
								String filter_column_type=(String)sMap.get("filter_column_type") == null ? "" : (String) sMap.get("filter_column_type");
								//�������͸�ʽ
								String date_type_format=(String)sMap.get("date_type_format") == null ? "" : (String) sMap.get("date_type_format");
								//������ֵ
								String filter_column_value=(String)sMap.get("filter_column_value") == null ? "" : (String) sMap.get("filter_column_value");
								if(StringUtils.isNotBlank(filter_column_value)) {
									//��������
									if("date".equals(filter_column_type)){
										if(StringUtils.isNotBlank(date_type_format)) {
											sql+=" to_date('"+filter_column_value+"', '"+date_type_format+"') ";
										}else{
											throw new Exception();
										}
									}else{
										//in��ѯ
										if("in".equals(query_type)){
											if("string".equals(filter_column_type)){
												String inSelection=generateInSelection(filter_column_value,"string");
												if(StringUtils.isNotBlank(inSelection)){
													sql+=inSelection+" ";
												}else{
													throw new Exception();
												}
											}
											if("number".equals(filter_column_type)){
												String inSelection=generateInSelection(filter_column_value,"number");
												if(StringUtils.isNotBlank(inSelection)){
													sql+=inSelection+" ";
												}else{
													throw new Exception();
												}
											}
										}else{
											if("string".equals(filter_column_type)){
												sql+="'"+filter_column_value+"' ";
											}
											if("number".equals(filter_column_type)){
												sql+=filter_column_value+" ";
											}
										}
										
									}
								}else{
									throw new Exception();
								}
							}
						}
					}
				}else {
					sql+=" "+(String) kMap.get("conf_content")+" ";
				}
				if(i<map.size()){
					sql+= " union all ";
				}
				i++;
			}
		}
		return sql;
		
	}
	
	/**
	 * ����in��ѯ
	 * @param formatStr
	 * @param type
	 * @return
	 */
	public static String generateInSelection(String formatStr,String type){
		String selection="";
		if(StringUtils.isNotBlank(formatStr) && StringUtils.isNotBlank(type)){
			String[] arrStr=formatStr.split(",");
			if(null!=arrStr && arrStr.length>0){
				selection+="( ";
				if("string".equals(type)){
					for(int i=0;i<arrStr.length;i++){
						if(0==i){
							selection+="'"+arrStr[i]+"'";
						}else{
							selection+=",'"+arrStr[i]+"'";
						}
					}
				}
				if("number".equals(type)){
					for(int i=0;i<arrStr.length;i++){
						if(0==i){
							selection+=arrStr[i];
						}else{
							selection+=","+arrStr[i];
						}
					}
				}
				selection+=" )";
			}
		}
		return selection;
	}
	
	/**
	 * ���ɲ������
	 * @param data
	 * @param tableName
	 * @param arr
	 * @param oFlag
	 * @return
	 */
	public static String assembleSql(Map data,String tableName,String[] arr,String oFlag,String pkColumn){
		String tempSql="";
		if("add".equals(oFlag)){
			tempSql += "insert into "+ tableName +"(";
			String values = "";
			Object[] keys =  data.keySet().toArray();
			
			for(int i=0;i<keys.length;i++){
				tempSql+= keys[i].toString() + ",";
				boolean flag = false;
				if(null!=arr){
					for(int j=0;j<arr.length;j++){
						if(keys[i].toString().equals(arr[j])){
							flag = true;
							break;
						}
					}
				}
				if(null== data.get(keys[i].toString()) || StringUtils.isBlank( data.get(keys[i].toString()).toString())){
					values += "null,";
				}else{
					if(flag){
						values += data.get(keys[i].toString())+",";
					}else{
						values += "'"+data.get(keys[i].toString())+"',";
					}
				}
			}
			tempSql = tempSql.substring(0, tempSql.length()-1);
			values = values.substring(0, values.length()-1);
			tempSql+=") values ("+values+") ";
		}
		if("update".equals(oFlag)){
			tempSql += "update  "+ tableName +" set ";
			Object[] keys =  data.keySet().toArray();
			
			for(int i=0;i<keys.length;i++){
				tempSql+= keys[i].toString() + "=";
				boolean flag = false;
				if(null!=arr){
					for(int j=0;j<arr.length;j++){
						if(keys[i].toString().equals(arr[j])){
							flag = true;
							break;
						}
					}
				}
				if(null== data.get(keys[i].toString()) || StringUtils.isBlank( data.get(keys[i].toString()).toString())){
					tempSql += "null,";
				}else{
					if(flag){
						tempSql += data.get(keys[i].toString())+",";
					}else{
						tempSql += "'"+data.get(keys[i].toString())+"',";
					}
				}
			}
			tempSql = tempSql.substring(0, tempSql.length()-1);
			tempSql+=" where "+pkColumn+"='"+data.get(pkColumn).toString()+"'";
		}
		return tempSql;
	}
	
	/**
	 *  ����ɾ��sql���
	 * @param pkName
	 * @param data
	 * @param tableName
	 * @return
	 */
	public static String assembleDelSql(String pkName,Map data,String tableName){
		String tempSql="";
		tempSql="delete from "+tableName+" where "+pkName+"='"+data.get(pkName).toString()+"'";
		return tempSql;
	}
}
