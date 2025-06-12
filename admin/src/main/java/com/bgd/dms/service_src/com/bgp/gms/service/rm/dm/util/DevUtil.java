package com.bgp.gms.service.rm.dm.util;

import java.text.MessageFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.util.DateUtil;

public class DevUtil {
	private static IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	public static final List<String> mixtypeList = new ArrayList<String>();
	static{
		mixtypeList.add(DevConstants.MIXTYPE_ZHENYUAN);
		mixtypeList.add(DevConstants.MIXTYPE_YIQI);
		mixtypeList.add(DevConstants.MIXTYPE_CELIANG);
		mixtypeList.add(DevConstants.MIXTYPE_ZHUANGBEI_DZYQ);
	}
	public static final List<String> orgNameList = new ArrayList<String>();
	public static final List<String> proorgNameList = new ArrayList<String>();
	static{
		orgNameList.add("C105002-国际勘探事业部");
		orgNameList.add("C105005004-长庆物探处");
		orgNameList.add("C105001005-塔里木物探处");
		orgNameList.add("C105001002-新疆物探处");
		orgNameList.add("C105001003-吐哈物探处");
		orgNameList.add("C105001004-青海物探处");
		orgNameList.add("C105007-海洋物探处");
		orgNameList.add("C105063-辽河物探处");
		orgNameList.add("C105005000-华北物探处");
		orgNameList.add("C105005001-新兴物探开发处");
		//orgNameList.add("C105086-深海物探处");  
		orgNameList.add("C105006-装备服务处");
		orgNameList.add("C105008-综合物化处");
		orgNameList.add("C105087-西南物探分公司");
		orgNameList.add("C105092-大庆物探一公司");
		orgNameList.add("C105093-大庆物探二公司");
		
		proorgNameList.add("C105001002-新疆物探处");
		proorgNameList.add("C105001003-吐哈物探处");
		proorgNameList.add("C105001004-青海物探处");
		proorgNameList.add("C105005004-长庆物探处");
		proorgNameList.add("C105005000-华北物探处");
		proorgNameList.add("C105063-辽河物探处");
		proorgNameList.add("C105001005-塔里木物探处");
		proorgNameList.add("C105005001-新兴物探开发处");
		proorgNameList.add("C105007-海洋物探处");
		proorgNameList.add("C105087-西南物探分公司");
		proorgNameList.add("C105092-大庆物探一公司");
		proorgNameList.add("C105093-大庆物探二公司");
	}
	/**
	 * 获取IP地址
	 * 
	 * 使用Nginx等反向代理软件， 则不能通过request.getRemoteAddr()获取IP地址
	 * 如果使用了多级反向代理的话，X-Forwarded-For的值并不止一个，而是一串IP地址，X-Forwarded-For中第一个非unknown的有效IP字符串，则为真实IP地址
	 */
	public static String getIpAddr(HttpServletRequest request) {

		String ip = request.getHeader("x-forwarded-for");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		return "0:0:0:0:0:0:0:1".equals(ip) ? "127.0.0.1" : ip;
	}
	/**
	 * 根据作业部单位sub_id返回对应属地物探处sub_id
	 * 
	 * @param msg
	 * @return 对应属地物探处sub_id
	 * @throws Exception
	 */
	public static String getCorreSpondOrgSubId(String zbOrgSubId) throws Exception {
		String orgSubId = "";
		if (isValueNotNull(zbOrgSubId)) {
			if ("C105006008".equals(zbOrgSubId)) {
				orgSubId = "C105001005";// 塔里木作业部--塔里木物探处
			}else if ("C105006005".equals(zbOrgSubId)) {
				orgSubId = "C105001002";// 北疆作业部---新疆物探处
			}else if ("C105006009".equals(zbOrgSubId)) {
				orgSubId = "C105001003";// 吐哈作业部--吐哈物探处
			}else if ("C105006006".equals(zbOrgSubId)) {
				orgSubId = "C105001004";// 敦煌作业部--青海物探处
			}else if ("C105006004".equals(zbOrgSubId)) {
				orgSubId = "C105005004";// 长庆物探处--长庆作业部
			}else if ("C105006029".equals(zbOrgSubId)) {
				orgSubId = "C105063";// 辽河作业部--辽河物探处
			}else if ("C105006007".equals(zbOrgSubId)) {
				orgSubId = "C105005000";// 华北作业部--华北物探处
			}else if ("C105006011".equals(zbOrgSubId)) {
				orgSubId = "C105005001";// 新区作业部--新兴物探处/大港物探处
			}else if ("C105007002".equals(zbOrgSubId)) {
				orgSubId = "C105007";// 大港仪器设备服务中心--大港物探处
			} else {
				orgSubId = "";
			}
		}
		return orgSubId;
	}

	/**
	 * 根据技术状况查询使用状况
	 */
	public static String getUsingStatByTechstat(String tech_stat){
		String usingstatdesc = null;
		if(DevConstants.DEV_TECH_WANHAO.equals(tech_stat)){
			usingstatdesc = DevConstants.DEV_USING_XIANZHI;
		}else{
			usingstatdesc = DevConstants.DEV_USING_QITA;
		}
		return usingstatdesc;
	}
	/**
	 * 根据用户提交的申请信息，查找调配单位
	 */
	public static String getMixOrgId(String mixtypeid,UserToken user){
		String returnStr;
		if(mixtypeList.contains(mixtypeid)){
			returnStr = DevConstants.MIXTYPE_ZHUANGBEI_ORGID;
		}else{
			returnStr = user.getOrgId();
		}
		return returnStr;
	}
	/**
	 * 根据用户提交的申请信息，查找返还调配单位
	 */
	public static String getBackMixOrgId(String mixtypeid,UserToken user){
		String returnStr;
		if(mixtypeList.contains(mixtypeid)){
			returnStr = DevConstants.MIXTYPE_ZHUANGBEI_ORGID;
		}else{
			returnStr = user.getOrgId();
		}
		return returnStr;
	}
	/**
	 * 大计划的配置计划单编号
	 * @return
	 */
	public static String getDeviceAllAppNo(String projectType){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String device_allapp_no="";
		if("5000100004000000009".equals(projectType)){
			device_allapp_no +="物探队";
		}
		else{
			device_allapp_no +="地震队";
		}
		return device_allapp_no+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 配置计划单编号
	 * @return
	 */
	public static String getDeviceAllAppNoNew(String projectType){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String device_allapp_no="";
		if("5000100004000000009".equals(projectType)){
			device_allapp_no +="配置计划";
		}
		else{
			device_allapp_no +="地震队";
		}
		return device_allapp_no+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 外租申请单编号
	 * @return
	 */
	public static String getDeviceHireAppNo(String mixtypename){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return mixtypename+"申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 外租申请单编号--综合物化探
	 * @return
	 */
	public static String getDeviceHireAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "外租申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	
	public static String getDgDeviceHireAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "大港外租申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	
	public static String getDgDeviceProAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "大港专业化申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	
	public static String getDgDeviceOwnAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "大港自有申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	
	/**
	 * 井中设备请示报告(外租设备)
	 * @return
	 */
	public static String getJzDeviceOwnAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "井中外租请示报告"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	
	/**
	 * 井中设备分中心设备申请
	 * @return
	 */
	public static String getWellsDevAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "井中设备分中心"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	
	/**
	 * 设备送修申请单编号liug add
	 * @return
	 */
	public static String getDeviceRepairAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "设备送修"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 设备送修申请单编号liug add
	 * @return
	 */
	public static String getDeviceRepairSendAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "设备送外维修"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 设备送修申请单编号liug add
	 * @return
	 */
	public static String getDeviceRepairRtnSendAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "设备送外维修返还"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 设备送修申请单编号liug add
	 * @return
	 */
	public static String getDeviceRepairRtnAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "设备送内维修返还"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 外租返还单编号
	 * @return
	 */
	public static String getDeviceHireBackNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "外租返还"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 小计划的调配申请单编号(采集设备)
	 * @return
	 */
	public static String getCollDeviceAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "采集设备调配申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 设备报停计划单号
	 * @return
	 */
	public static String getOSAppInfoNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "设备报停"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 采集设备调配单（按量管理）
	 * @return
	 */
	public static String getCollMixInfoNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "采集设备调配单"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 采集设备出库单编号
	 * @return
	 */
	public static String getCollOutInfoNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "采集设备出库"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 采集设备出库单编号
	 * @return
	 */
	public static String getEquOutInfoNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "装备设备出库"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 打计划配置补充单编号
	 * @return
	 */
	public static String getDeviceAllAddAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "配置补充"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 小计划的调配申请单编号
	 * @return
	 */
	public static String getDeviceAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "调配申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 配置计划单编号
	 * @return
	 */
	public static String getBackMixInfoNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "返还调拨"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 维修返还调拨单编号
	 * @return
	 */
	public static String getRepairBackMixInfoNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "维修返还"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 维修调拨单单编号
	 * @return
	 */
	public static String getRepairMixInfoNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "维修调拨"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 配置计划单编号
	 * @return
	 */
	public static String getMixInfoNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "调配"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 更换设备单编号
	 * @return
	 */
	public static String getChanInfoNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "更换设备"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 配置计划单编号
	 * @return
	 */
	public static String getEqMixInfoNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "装备调配"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 配置计划单编号
	 * @return
	 */
	public static String getDisMixInfoNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "调剂"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 设备转移单编号
	 * @return
	 */
	public static String getMoveAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "转移申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 设备返还调配单编号
	 * @return
	 */
	public static String getBackAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "返还申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 内部送修编号
	 * @return
	 */
	public static String getRepAppNo(String repapptype){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String prefixstr = "";
		if("1".equals(repapptype)){
			prefixstr = "内部送修";
		}else{
			prefixstr = "内部返还";
		}
		return prefixstr+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * 查找采集设备申请的是否添加流程标识
	 * @return
	 */
	public static String getCollMixAppFlag(){
		ResourceBundle rb  = ResourceBundle.getBundle("devCodeDesc");
		String collMixFlag = null;
		if(rb != null){
			collMixFlag = rb.getString("CollMixFlag");
		}
		return collMixFlag;
	}
	/**
	 * 查找
	 * @param showid
	 * @param parentid
	 * @return
	 */
	public static List<Map> getDrillConditionForTwo(String showid,String parentid){
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<Map> paramList = null;
		if("COM".equals(showid)){
			if(parentid == null){
				//公司级一级钻取
				String sqlinfo = "select id,name,code,showtype,seq from gms_device_showparam "+
					"where showid='COM' and parentid is null order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for(Map paramMap : paramList){
					if("DZYQ".equals(paramMap.get("code"))){
						paramMap.put("condition", "");
					}else{
						//1级都是like，不做控制了
						paramMap.put("condition", "dev_type like '"+paramMap.get("code")+"' ");
					}
				}
			}else if("1".equals(parentid)){
				//公司级的地震仪器二级，单独做
				String sqlinfo = "select id,name,code,showtype,seq from gms_device_showparam "+
					"where showid='COM' and parentid='1' order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for(Map paramMap : paramList){
					paramMap.put("condition", "device_id in (select device_id from gms_device_collectinfo where dev_model like '%"+paramMap.get("name")+"%'and dev_code not like '04%')");
				}
			}else if("7".equals(parentid)){
				//公司级的检波器，单独做
				String sqlinfo = "select id,name,code,showtype,otherinfo,othertype,seq from gms_device_showparam "+
				"where showid='COM' and parentid='"+parentid+"' order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for(Map paramMap : paramList){
					String code = paramMap.get("code").toString();
					String showtype = paramMap.get("showtype").toString();
					String othertype = paramMap.get("othertype").toString();
					String otherinfo = paramMap.get("otherinfo").toString();
					String condition = "device_id "+showtype+" '"+code+"' ";
					if(othertype!=null){
						if("IN".equals(othertype)){
							condition += "or device_id "+othertype+" ('"+otherinfo.replaceAll(",", "','") +"') ";
						}
					}
					condition += ") ";
					paramMap.put("condition", condition);
				}
			}else{
				String sqlinfo = "select id,name,code,showtype,otherinfo,othertype,seq from gms_device_showparam "+
					"where showid='COM' and parentid='"+parentid+"' order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for(Map paramMap : paramList){
					String code = paramMap.get("code").toString();
					String showtype = paramMap.get("showtype").toString();
					String othertype = paramMap.get("othertype").toString();
					String otherinfo = paramMap.get("otherinfo").toString();
					String condition = " (dev_type "+showtype+" '"+code+"' ";
					if(othertype!=null){
						if(othertype.startsWith("NOT")){
							condition += "and dev_type "+othertype+" ('"+otherinfo.replaceAll(",", "','") +"') ";
						}else if("OR".equals(othertype)){
							condition += "and dev_type = '"+otherinfo +"' ";
						}else if("IN".equals(othertype)){
							condition += "or dev_type "+othertype+" ('"+otherinfo.replaceAll(",", "','") +"') ";
						}else if("OR LIKE".equals(othertype)){
							condition += "or dev_type like '"+otherinfo +"' ";
						}
					}
					condition += ") ";
					paramMap.put("condition", condition);
				}
			}
		}else if("WUTAN".equals(showid)){
			//物探处级查询的都是单台设备
			if(parentid == null){
				//物探处一级钻取
				String sqlinfo = "select id,name,code,showtype,seq from gms_device_showparam "+
					"where showid='WUTAN' and parentid is null order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for(Map paramMap : paramList){
					//1级都是like，不做控制了
					paramMap.put("condition", "dev_type like '"+paramMap.get("code")+"' ");
				}
			}else{
				String sqlinfo = "select id,name,code,showtype,otherinfo,othertype,seq from gms_device_showparam "+
					"where showid='WUTAN' and parentid='"+parentid+"' order by seq";
				paramList = jdbcDao.queryRecords(sqlinfo);
				for(Map paramMap : paramList){
					String code = paramMap.get("code").toString();
					String showtype = paramMap.get("showtype").toString();
					String othertype = paramMap.get("othertype").toString();
					String otherinfo = paramMap.get("otherinfo").toString();
					String condition = " (dev_type "+showtype+" '"+code+"' ";
					if(othertype!=null){
						if(othertype.startsWith("NOT")){
							condition += "and dev_type "+othertype+" ('"+otherinfo.replaceAll(",", "','") +"') ";
						}else if("OR".equals(othertype)){
							condition += "and dev_type = '"+otherinfo +"' ";
						}else if("IN".equals(othertype)){
							condition += "or dev_type "+othertype+" ('"+otherinfo.replaceAll(",", "','") +"') ";
						}else if("OR LIKE".equals(othertype)){
							condition += "or dev_type like '"+otherinfo +"' ";
						}
					}
					condition += ") ";
					paramMap.put("condition", condition);
				}
			}
		}
		return paramList;
	}
	/**
	 * 说明：获得公司级、物探处级二级钻取的查询sql
	 * @param showid
	 * @param parentid
	 * @return
	 */
	public static String getDrillSqlForTwo(String showid,String parentid,String ifcountry,String orgsubid){
		List<Map> conditionList = getDrillConditionForTwo(showid,parentid);
		StringBuffer sb = new StringBuffer();
		if("COM".equals(showid)){
			if("1".equals(parentid)){
				sb.append("select base.id,base.name,base.code,nvl(tempzs.zs,0) as zs,")
					.append("nvl(tempzs.zy,0) as zy,0 as xz_little,nvl(tempzs.xz,0) as xz,nvl(tempzs.qt,0) as qt,nvl(tempzs.dbf,0) as dbf ")
					.append("from (select id,code,name,seq from gms_device_showparam where showid='COM' and parentid='1') base ") 
					.append("left join (");
				int index = 0;
				for(Map paramMap : conditionList){
					if(index>0){
						sb.append(" union ");
					}
					sb.append("(select '"+paramMap.get("id")+"' as id,sum(ci.dev_slot_num * ca.total_num) as zs,sum(ci.dev_slot_num * ca.use_num) as zy,")
						.append("sum(ci.dev_slot_num * ca.unuse_num) as xz,sum(ci.dev_slot_num * cat.repairing_num) as qt,")
						.append("sum(ci.dev_slot_num * cat.touseless_num) as dbf ")
						.append("from gms_device_coll_account ca ")
						.append("left join gms_device_coll_account_tech cat on ca.dev_acc_id = cat.dev_acc_id ")
						.append("left join gms_device_collectinfo ci on ca.device_id = ci.device_id ")
						.append("where ")
						.append(" ca.").append(paramMap.get("condition"))
						.append(") ");
					index++;
				}
				sb.append(") tempzs on base.id=tempzs.id order by base.seq");
			}else if("7".equals(parentid)){
				sb.append("select base.id,base.name,base.code,nvl(tempzs.zs,0) as zs,")
				.append("nvl(tempzs.zy,0) as zy,0 as xz_little,nvl(tempzs.xz,0) as xz,nvl(tempzs.qt,0) as qt,nvl(tempzs.dbf,0) as dbf ")
				.append("from (select id,code,name,seq from gms_device_showparam where showid='COM' and parentid='7') base ") 
				.append("left join (");
				int index = 0;
				for(Map paramMap : conditionList){
					if(index>0){
						sb.append(" union ");
					}
					sb.append("(select '"+paramMap.get("id")+"' as id,sum(ca.total_num) as zs,sum(ca.use_num) as zy,")
						.append("sum(ca.unuse_num) as xz,sum(cat.repairing_num) as qt,")
						.append("sum(cat.touseless_num) as dbf ")
						.append("from gms_device_coll_account ca ")
						.append("left join gms_device_coll_account_tech cat on ca.dev_acc_id = cat.dev_acc_id where 1=1 ");
						if(ifcountry !=null && "1".equals(ifcountry)){//国内
							sb.append("and (ca.ifcountry != '国外' or ca.ifcountry is null) ");
						}else if(ifcountry !=null && "2".equals(ifcountry)){//国外
							sb.append("and ca.ifcountry = '国外' ");
						}
						sb.append("and ca.bsflag = '0' and( ca.").append(paramMap.get("condition"))
						.append(") ");
					index++;
				}
				sb.append(") tempzs on base.id=tempzs.id order by base.seq");
			}else{
				//增加其他的2级钻取
				sb.append("select base.id,base.name,base.code,nvl(tempdata.zs,0) as zs,")
					.append("nvl(tempdata.zy,0) as zy,nvl(tempdata.xz_little,0) as xz_little,nvl(tempdata.xz,0) as xz,nvl(tempdata.wx,0) as qt,nvl(tempdata.dbf,0) as dbf ")
					.append("from (select id,code,name,seq from gms_device_showparam where showid='COM' and parentid='"+parentid+"') base ") 
					.append("left join (");
				int index = 0;
				for(Map paramMap : conditionList){
					if(index>0){
						sb.append(" union ");
					}
					sb.append("(select tempzs.id,tempzs.zs,tempzy.zy,tempxzlittle.xz_little,tempxz.xz,tempwx.wx,tempdbf.dbf from ");
					sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as zs ")
						.append("from gms_device_account acc ")
						.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and ").append(paramMap.get("condition"));
						if(ifcountry !=null && "1".equals(ifcountry)){//国内
							sb.append(" and (acc.ifcountry != '国外' or acc.ifcountry is null) ");
						}else if(ifcountry !=null && "2".equals(ifcountry)){//国外
							sb.append(" and acc.ifcountry = '国外' ");
						}
						sb.append(" ) tempzs left join  ");
					sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as zy ")
						.append("from gms_device_account acc ")
						.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and acc.using_stat = '0110000007000000001' and ").append(paramMap.get("condition"));
						if(ifcountry !=null && "1".equals(ifcountry)){//国内
							sb.append(" and (acc.ifcountry != '国外' or acc.ifcountry is null) ");
						}else if(ifcountry !=null && "2".equals(ifcountry)){//国外
							sb.append(" and acc.ifcountry = '国外' ");
						}
						sb.append(" ) tempzy on tempzs.id=tempzy.id left join  ");
					sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as xz_little ")
						.append("from gms_device_account acc ")
						.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and acc.using_stat = '0110000007000000002' and (acc.check_time is not null and acc.check_time>=trunc(add_months(sysdate,-1),'dd')) and ").append(paramMap.get("condition"));
						if(ifcountry !=null && "1".equals(ifcountry)){//国内
							sb.append(" and (acc.ifcountry != '国外' or acc.ifcountry is null) ");
						}else if(ifcountry !=null && "2".equals(ifcountry)){//国外
							sb.append(" and acc.ifcountry = '国外' ");
						}
						sb.append(" ) tempxzlittle on tempzs.id=tempxzlittle.id left join  ");
					sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as xz ")
						.append("from gms_device_account acc ")
						.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and acc.using_stat = '0110000007000000002' and (acc.check_time is null or acc.check_time<trunc(add_months(sysdate,-1),'dd')) and ").append(paramMap.get("condition"));
						if(ifcountry !=null && "1".equals(ifcountry)){//国内
							sb.append(" and (acc.ifcountry != '国外' or acc.ifcountry is null) ");
						}else if(ifcountry !=null && "2".equals(ifcountry)){//国外
							sb.append(" and acc.ifcountry = '国外' ");
						}
						sb.append(" ) tempxz on tempzs.id=tempxz.id left join  ");
					sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as wx ")
						.append("from gms_device_account acc ")
						.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and acc.using_stat = '0110000007000000006' ")
						.append("and (acc.tech_stat = '0110000006000000006' or acc.tech_stat = '0110000006000000007') ")
						.append("and ").append(paramMap.get("condition"));
						if(ifcountry !=null && "1".equals(ifcountry)){//国内
							sb.append(" and (acc.ifcountry != '国外' or acc.ifcountry is null) ");
						}else if(ifcountry !=null && "2".equals(ifcountry)){//国外
							sb.append(" and acc.ifcountry = '国外' ");
						}
						sb.append(" ) tempwx on tempzs.id=tempwx.id left join  ");
					sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as dbf ")
						.append("from gms_device_account acc ")
						.append("where acc.bsflag='0' and acc.account_stat != '0110000013000000005' and acc.using_stat = '0110000007000000006' ")
						.append("and acc.tech_stat = '0110000006000000005' ")
						.append("and ").append(paramMap.get("condition"));
						if(ifcountry !=null && "1".equals(ifcountry)){//国内
							sb.append(" and (acc.ifcountry != '国外' or acc.ifcountry is null) ");
						}else if(ifcountry !=null && "2".equals(ifcountry)){//国外
							sb.append(" and acc.ifcountry = '国外' ");
						}
						sb.append(") tempdbf on tempzs.id=tempdbf.id ) ");
					index++;
				}
				sb.append(") tempdata on base.id=tempdata.id order by base.seq");
			}
		}else if("WUTAN".equals(showid)){
			//增加其他的2级钻取
			sb.append("select base.id,base.name,base.code,nvl(tempdata.zs,0) as zs,")
				.append("nvl(tempdata.zy,0) as zy,nvl(tempdata.xz_little,0) as xz_little,nvl(tempdata.xz,0) as xz,nvl(tempdata.qt,0) as qt,")
				.append("nvl(tempdata.dx,0) as dx,nvl(tempdata.zx,0) as zx,nvl(tempdata.dbf,0) as dbf ")
				.append("from (select id,code,name,seq from gms_device_showparam where showid='WUTAN' and parentid='"+parentid+"') base ") 
				.append("left join (");
			int index = 0;
			for(Map paramMap : conditionList){
				if(index>0){
					sb.append(" union ");
				}
				sb.append("(select tempzs.id,tempzs.zs,tempzy.zy,tempxzlittle.xz_little,tempxz.xz,tempqt.qt,tempdx.dx,tempzx.zx,tempdbf.dbf from ");
				sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as zs ")
					.append("from gms_device_account acc ")
					.append("where 1=1 and ").append(paramMap.get("condition"))
					.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempzs left join  ");
				sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as zy ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000001' and ").append(paramMap.get("condition"))
					.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempzy on tempzs.id=tempzy.id left join  ");
				sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as xz_little ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is not null and acc.check_time>=trunc(add_months(sysdate,-1),'dd')) and ").append(paramMap.get("condition"))
					.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempxzlittle on tempzs.id=tempxzlittle.id left join  ");
				sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as xz ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is null or acc.check_time<trunc(add_months(sysdate,-1),'dd')) and ").append(paramMap.get("condition"))
					.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempxz on tempzs.id=tempxz.id left join  ");
				sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as qt ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000006' ")
					.append("and ").append(paramMap.get("condition"))
					.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempqt on tempzs.id=tempqt.id left join  ");
				sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as dx ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000006' ")
					.append("and acc.tech_stat = '0110000006000000006' ")
					.append("and ").append(paramMap.get("condition"))
					.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempdx on tempzs.id=tempdx.id left join  ");
				sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as zx ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000006' ")
					.append("and acc.tech_stat = '0110000006000000007' ")
					.append("and ").append(paramMap.get("condition"))
					.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempzx on tempzs.id=tempzx.id left join  ");
				sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as dbf ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000006' ")
					.append("and acc.tech_stat = '0110000006000000005' ")
					.append("and ").append(paramMap.get("condition"))
					.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempdbf on tempzs.id=tempdbf.id ) ");
				index++;
			}
			sb.append(") tempdata on base.id=tempdata.id order by base.seq");
		}
		return sb.toString();
	}
	/**
	 * 查找
	 * @param showid
	 * @param parentid
	 * @return
	 */
	public static Map getDrillConditionForWutanRoot(String showid,String id){
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		Map paramMap = null;
		if("WUTAN".equals(showid)){
			//物探处级查询的都是单台设备
			String sqlinfo = "select id,name,code,showtype,otherinfo,othertype,seq from gms_device_showparam "+
				"where showid='WUTAN' and id='"+id+"' ";
			paramMap = jdbcDao.queryRecordBySQL(sqlinfo);
			
			String code = paramMap.get("code").toString();
			String showtype = paramMap.get("showtype").toString();
			String othertype = paramMap.get("othertype").toString();
			String otherinfo = paramMap.get("otherinfo").toString();
			String condition = " (dev_type "+showtype+" '"+code+"' ";
			if(othertype!=null){
				if(othertype.startsWith("NOT")){
					condition += "and dev_type "+othertype+" ('"+otherinfo.replaceAll(",", "','") +"') ";
				}else if("OR".equals(othertype)){
					condition += "and dev_type = '"+otherinfo +"' ";
				}else if("IN".equals(othertype)){
					condition += "or dev_type "+othertype+" ('"+otherinfo.replaceAll(",", "','") +"') ";
				}else if("OR LIKE".equals(othertype)){
					condition += "or dev_type like '"+otherinfo +"' ";
				}
				condition += ") ";
				paramMap.put("condition", condition);
			}
		}
		return paramMap;
	}
	/**
	 * 说明：获得物探处级一级钻取的查询sql
	 * @param showid
	 * @param parentid
	 * @return
	 */
	public static String getDrillSqlForWutanRoot(String showid,String id,String orgsubid){
		Map paramMap = getDrillConditionForWutanRoot(showid,id);
		StringBuffer sb = new StringBuffer();
		if("WUTAN".equals(showid)){
			//增加其他的2级钻取
			sb.append("select base.id,base.name,base.code,nvl(tempdata.zs,0) as zs,")
				.append("nvl(tempdata.zy,0) as zy,nvl(tempdata.xz_little,0) as xz_little,nvl(tempdata.xz,0) as xz,nvl(tempdata.qt,0) as qt,")
				.append("nvl(tempdata.dx,0) as dx,nvl(tempdata.zx,0) as zx,nvl(tempdata.dbf,0) as dbf ")
				.append("from (select id,code,name,seq from gms_device_showparam where showid='WUTAN' and id='"+id+"') base ") 
				.append("left join (");
			sb.append("(select tempzs.id,tempzs.zs,tempzy.zy,tempxzlittle.xz_little,tempxz.xz,tempqt.qt,tempdx.dx,tempzx.zx,tempdbf.dbf from ");
			sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as zs ")
				.append("from gms_device_account acc ")
				.append("where 1=1 and ").append(paramMap.get("condition"))
				.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempzs left join  ");
			sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as zy ")
				.append("from gms_device_account acc ")
				.append("where acc.using_stat = '0110000007000000001' and ").append(paramMap.get("condition"))
				.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempzy on tempzs.id=tempzy.id left join  ");
			sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as xz_little ")
				.append("from gms_device_account acc ")
				.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is not null and acc.check_time>=trunc(add_months(sysdate,-1),'dd')) and ").append(paramMap.get("condition"))
				.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempxzlittle on tempzs.id=tempxzlittle.id left join  ");
			sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as xz ")
				.append("from gms_device_account acc ")
				.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is null or acc.check_time<trunc(add_months(sysdate,-1),'dd')) and ").append(paramMap.get("condition"))
				.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempxz on tempzs.id=tempxz.id left join  ");
			sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as qt ")
				.append("from gms_device_account acc ")
				.append("where acc.using_stat = '0110000007000000006' ")
				.append("and ").append(paramMap.get("condition"))
				.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempqt on tempzs.id=tempqt.id left join  ");
			sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as dx ")
				.append("from gms_device_account acc ")
				.append("where acc.using_stat = '0110000007000000006' ")
				.append("and acc.tech_stat = '0110000006000000006' ")
				.append("and ").append(paramMap.get("condition"))
				.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempdx on tempzs.id=tempdx.id left join  ");
			sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as zx ")
				.append("from gms_device_account acc ")
				.append("where acc.using_stat = '0110000007000000006' ")
				.append("and acc.tech_stat = '0110000006000000007' ")
				.append("and ").append(paramMap.get("condition"))
				.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempzx on tempzs.id=tempzx.id left join  ");
			sb.append("(select '"+paramMap.get("id")+"' as id,count(1) as dbf ")
				.append("from gms_device_account acc ")
				.append("where acc.using_stat = '0110000007000000006' ")
				.append("and acc.tech_stat = '0110000006000000005' ")
				.append("and ").append(paramMap.get("condition"))
				.append(" and acc.owning_sub_id like '"+orgsubid+"%') tempdbf on tempzs.id=tempdbf.id ) ");
		}
		sb.append(") tempdata on base.id=tempdata.id order by base.seq");
		return sb.toString();
	}
	/**
	 * 查找
	 * @param showid
	 * @param parentid
	 * @return
	 */
	public static Map getDrillConditionForThree(String showid,String id){
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		Map paramMap = null;
		if("COM".equals(showid)){
			if(id == null){
				//TODO 1级不走这 这个控制有问题，得调整
			}else if("1".equals(id)){
				//地震仪器没有三级钻取
			}else{
				String sqlinfo = "select id,name,code,showtype,otherinfo,othertype,seq from gms_device_showparam "+
					"where showid='COM' and id='"+id+"' ";
				paramMap = jdbcDao.queryRecordBySQL(sqlinfo);
				
				String code = paramMap.get("code").toString();
				String showtype = paramMap.get("showtype").toString();
				String othertype = paramMap.get("othertype").toString();
				String otherinfo = paramMap.get("otherinfo").toString();
				String condition = " (dev_type "+showtype+" '"+code+"' ";
				if(othertype!=null){
					if(othertype.startsWith("NOT")){
						condition += "and dev_type "+othertype+" ('"+otherinfo.replaceAll(",", "','") +"') ";
					}else if("OR".equals(othertype)){
						condition += "and dev_type = '"+otherinfo +"' ";
					}else if("IN".equals(othertype)){
						condition += "or dev_type "+othertype+" ('"+otherinfo.replaceAll(",", "','") +"') ";
					}else if("OR LIKE".equals(othertype)){
						condition += "or dev_type like '"+otherinfo +"' ";
					}
					condition += ") ";
					paramMap.put("condition", condition);
				}
			}
		}else if("WUTAN".equals(showid)){
			//物探处级查询的都是单台设备
			String sqlinfo = "select id,name,code,showtype,otherinfo,othertype,seq from gms_device_showparam "+
				"where showid='WUTAN' and id='"+id+"' ";
			paramMap = jdbcDao.queryRecordBySQL(sqlinfo);
			
			String code = paramMap.get("code").toString();
			String showtype = paramMap.get("showtype").toString();
			String othertype = paramMap.get("othertype").toString();
			String otherinfo = paramMap.get("otherinfo").toString();
			String condition = " (dev_type "+showtype+" '"+code+"' ";
			if(othertype!=null){
				if(othertype.startsWith("NOT")){
					condition += "and dev_type "+othertype+" ('"+otherinfo.replaceAll(",", "','") +"') ";
				}else if("OR".equals(othertype)){
					condition += "and dev_type = '"+otherinfo +"' ";
				}else if("IN".equals(othertype)){
					condition += "or dev_type "+othertype+" ('"+otherinfo.replaceAll(",", "','") +"') ";
				}else if("OR LIKE".equals(othertype)){
					condition += "or dev_type like '"+otherinfo +"' ";
				}
				condition += ") ";
				paramMap.put("condition", condition);
			}
		}
		return paramMap;
	}
	/**
	 * 说明：获得公司级、物探处级二级钻取的查询sql
	 * @param showid
	 * @param parentid
	 * @return
	 */
	public static String getDrillSqlForThree(String showid,String id,String orgsubid){
		Map paramMap = getDrillConditionForThree(showid,id);
		StringBuffer sb = new StringBuffer();
		if("COM".equals(showid)){
			if("1".equals(id)||"2".equals(id)){
				//TODO 3级钻取通过另外的界面展开。地震仪器在flash中只钻1次 这个条件有问题，得调整
			}else{
				//按照二级单位进行分组显示
				sb.append("select tempzs.owning_sub_id,org.org_abbreviation as org_name,nvl(tempzs.zs,0) as zs,")
				.append("nvl(tempzy.zy,0) as zy,nvl(tempxzlittle.xz_little,0) as xz_little,nvl(tempxz.xz,0) as xz,nvl(tempwx.wx,0) as qt,nvl(tempdbf.dbf,0) as dbf from ");
				sb.append("(select acc.owning_sub_id,count(1) as zs ")
					.append("from gms_device_account acc ")
					.append("where 1=1 and ").append(paramMap.get("condition"))
					.append(" group by owning_sub_id ) tempzs left join  ");
				sb.append("(select acc.owning_sub_id,count(1) as zy ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000001' and ").append(paramMap.get("condition"))
					.append(" group by owning_sub_id ) tempzy on tempzs.owning_sub_id=tempzy.owning_sub_id left join  ");
				sb.append("(select acc.owning_sub_id,count(1) as xz_little ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is not null and acc.check_time>=trunc(add_months(sysdate,-1),'dd')) and ").append(paramMap.get("condition"))
					.append(" group by owning_sub_id ) tempxzlittle on tempzs.owning_sub_id=tempxzlittle.owning_sub_id left join  ");
				sb.append("(select acc.owning_sub_id,count(1) as xz ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000002' and (acc.check_time is null or acc.check_time<trunc(add_months(sysdate,-1),'dd'))and ").append(paramMap.get("condition"))
					.append(" group by owning_sub_id ) tempxz on tempzs.owning_sub_id=tempxz.owning_sub_id left join  ");
				sb.append("(select acc.owning_sub_id,count(1) as wx ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000006' ")
					.append("and (acc.tech_stat = '0110000006000000006' or acc.tech_stat = '0110000006000000007') ")
					.append("and ").append(paramMap.get("condition"))
					.append(" group by owning_sub_id ) tempwx on tempzs.owning_sub_id=tempwx.owning_sub_id left join  ");
				sb.append("(select acc.owning_sub_id,count(1) as dbf ")
					.append("from gms_device_account acc ")
					.append("where acc.using_stat = '0110000007000000006' ")
					.append("and acc.tech_stat = '0110000006000000005' ")
					.append("and ").append(paramMap.get("condition"))
					.append(" group by owning_sub_id ) tempdbf on tempzs.owning_sub_id=tempdbf.owning_sub_id ");
				sb.append("left join comm_org_subjection orgsub on tempzs.owning_sub_id=orgsub.org_subjection_id and orgsub.bsflag='0' ");
				sb.append("left join comm_org_information org on orgsub.org_id=org.org_id ");
			}
		}else if("WUTAN".equals(showid)){
			//物探三级钻取，给在用的数量展开到项目上
			sb.append("select tempzy.project_info_no,pro.project_name,nvl(tempzy.zy,0) as zy from ");
			sb.append("(select acc.project_info_no,count(1) as zy ")
				.append("from gms_device_account acc ")
				.append("where acc.using_stat = '0110000007000000001' and ").append(paramMap.get("condition"))
				.append(" and acc.owning_sub_id like '"+orgsubid+"%' and acc.project_info_no is not null group by project_info_no ) tempzy ");
			sb.append("left join gp_task_project pro on pro.project_info_no=tempzy.project_info_no ");
		}
		return sb.toString();
	}
	/**
	 * 获取decode语句
	 * @param code  liug
	 * @return str
	 */
	public static String getDecodeStr(String key){
		String sqlinfo =  
				"SELECT T.DICTKEY, T.DICTDESC, I.OPTIONVALUE, I.OPTIONDESC, I.DISPLAYORDER\n" +
						"  FROM GMS_DEVICE_COMM_DICT T\n" + 
						"  JOIN GMS_DEVICE_COMM_DICT_ITEM I\n" + 
						"    ON T.ID = I.DICT_ID\n" + 
						" WHERE T.BSFLAG = '0'\n" + 
						"   AND T.DICTKEY = '"+key+"'\n" + 
						" ORDER BY I.OPTIONVALUE";
			StringBuffer sb = new StringBuffer();
			RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
			List<Map> list = null;
			list =	jdbcDao.queryRecords(sqlinfo);
			for(Map paramMap : list){
				String val = paramMap.get("optionvalue").toString();
				String desc = paramMap.get("optiondesc").toString();
				sb.append("'"+val+"',");
				sb.append("'"+desc+"',");
			}
			if(list == null || list.size()<=0){
				sb.append("'',");
			}
			sb.append("''");
			return sb.toString();
	}
	
	/**
	 * 闲置设备调剂申请单号
	 * @return
	 */
	public static String getDeviceXzAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "闲置调剂单"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	 * DateUtil.java
	 * @author zhangjb
	 * Created on 2016年07月08日 上午8:38:08
	 */
	public static void main(String[] args) {
		System.out.println(new DevUtil().returnDateStringSimple("Fri Dec 18 00:00:00 CST 2015"));
		System.out.println(new DevUtil().returnDateStringSimple("2016-7-8 11:22:41"));
		System.out.println(new DevUtil().returnDateStringSimple("2016年7月8日 11时21分16秒"));
		System.out.println(new DevUtil().returnDateStringSimple("2016年7月8日 11:42:34"));
		System.out.println(new DevUtil().returnDateStringSimple("2016年7月8日"));
		System.out.println(new DevUtil().returnDateStringSimple("2016/07/08"));
		System.out.println(new DevUtil().returnDateStringSimple("2016-07-08"));
		System.out.println(new DevUtil().returnDateStringSimple("2016/07/08"));
		System.out.println(new DevUtil().dateToString(new Date(),"yyyy-MM-dd"));
		System.out.println(new DevUtil().returnDateStringByPattern("2016-7-8 11:22:41", "yyyy-MM-dd HH:mm:ss", "yyyy/MM/dd HH:mm:ss"));
	}
	private static final ThreadLocal<SimpleDateFormat> threadLocal = new ThreadLocal<SimpleDateFormat>();

	/**
	 * 获取SimpleDateFormat
	 * 
	 * @param pattern
	 *            日期格式
	 * @return SimpleDateFormat对象
	 * @throws RuntimeException
	 *             异常：非法日期格式
	 */
	private static SimpleDateFormat getDateFormat(String pattern)
			throws RuntimeException {
		SimpleDateFormat dateFormat = threadLocal.get();
		if (dateFormat == null) {
			dateFormat = new SimpleDateFormat(pattern);
			dateFormat.setLenient(false);
			threadLocal.set(dateFormat);
		} else {
			dateFormat.applyPattern(pattern);
		}

		return dateFormat;
	}

	/**
	 * 将日期转化为日期字符串。失败返回null。
	 * 
	 * @param date
	 *            日期
	 * @param pattern
	 *            日期格式
	 * @return 日期字符串
	 */
	public static String dateToString(Date date, String pattern) {
		String dateString = null;
		if (date != null) {
			try {
				dateString = getDateFormat(pattern).format(date);
			} catch (Exception e) {
			}
		}
		return dateString;
	}
	/**对时间字符串的处理,尽量多的把各个情况考虑进来
	 * 目前包含格式：
	 * Fri Dec 18 00:00:00 CST 2015、
	 * 2016-7-8 11:22:41、
	 * 2016年7月8日 11时21分16秒、
	 * 2016年7月8日 11:42:34、
	 * 2016年7月8日、
	 * 2016/07/08、
	 * 2016-07-08、
	 * 
	 * **/
	 public String returnDateStringSimple(String x) {
	 	//时间格式是Fri Dec 18 00:00:00 CST 2015普通时间格式
		SimpleDateFormat sdf1 = new SimpleDateFormat("EEE MMM dd HH:mm:ss Z yyyy", Locale.UK);
		try {
			x = this.getString(sdf1,x);
		} catch (ParseException e1) {
			SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			try {
				x = this.getString(sdf2,x);
			} catch (ParseException e2) {
				SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy年MM月dd日 hh时mm分ss秒");
				try {
					x = this.getString(sdf3,x);
				} catch (ParseException e3) {
					SimpleDateFormat sdf4 = new SimpleDateFormat("yyyy年MM月dd日 hh:mm:ss");
					try {
						x = this.getString(sdf4,x);
					} catch (ParseException e4) {
						SimpleDateFormat sdf5 = new SimpleDateFormat("yyyy年MM月dd日");
						try {
							x = this.getString(sdf5,x);
						} catch (ParseException e5) {
							SimpleDateFormat sdf6 = new SimpleDateFormat("yyyy/MM/dd");
							try {
								x = this.getString(sdf6,x);
							} catch (ParseException e6) {
							}
						}
					}
				}
			}
		}
		//返回时，ok，如果参数是普通时间类型，我们处理后再返回，如果不是，直接返回
		return x;
	 }
	 public String getString(SimpleDateFormat sdfs,String x)throws ParseException{
		 Date date = sdfs.parse(x);
		 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		 x= sdf.format(date);
		 return x;
	 }
	 /**
	  * @author zhangjb
	  * 当定义时间格式不能满足需求的时候，用此方法自定义输入输出时间格式
	  * **/
	 public String returnDateStringByPattern(String StringDate,String fromPattern,String toPattern) {
		 	//时间格式是Fri Dec 18 00:00:00 CST 2015普通时间格式
			SimpleDateFormat sdfs = new SimpleDateFormat(fromPattern);
			try {
				 Date date = sdfs.parse(StringDate);
				 SimpleDateFormat sdf = new SimpleDateFormat(toPattern);
				 StringDate= sdf.format(date);
			} catch (ParseException e1) {
				System.out.println("你输入的时间格式不正确！！");
			}
			return StringDate;
	}
	 /**
		 * 空指针及空值判断
		 * @return
	*/
	public static boolean isValueNotNull(String value){
		if(value != null 
				&& !"".equals(value) 
					&& !"null".equals(value)
						&& !"undefined".equals(value)){
			return true;
		}
		return false;
	}
	/**
		* 空指针及空值判断并比较值
		* @return
	*/
	public static boolean isValueNotNull(String value,String compareValue){
		if(value != null 
				&& !"".equals(value) 
					&& !"null".equals(value)
						&& !"undefined".equals(value)
							&&value.equals(compareValue)){
			return true;
		}
		return false;
	}
	 /**
		 * 获得 年-月-日 时:分:秒
		 * @return
	*/
	public static String getCurrentTime(){
		String currentTime = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		return currentTime;
	}
	/**
	 * 获取当前年度
	 * 
	 * @return
	 */
	public static String getCurrentYear() {
		Calendar cal = Calendar.getInstance();
		Integer year = cal.get(Calendar.YEAR);
		return year.toString();
	}
	/**
		* 获得当前 年-月-日
		* @return
	*/
	public static String getCurrentDate(){
		String currentDate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd");
		return currentDate;
	}
	/**
		 * 物探处直接调拨自有设备单号
		 * @return
	*/
	public static String getWTCDevMixAppNo(String zjFlag){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String wtcAppNo = "";
		if("JBQ".equals(zjFlag)){
			wtcAppNo = "检波器调配"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else if("COLL".equals(zjFlag)){
			wtcAppNo = "采集设备调配"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else{
			wtcAppNo = "自有设备调配"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}
		return wtcAppNo;
	}
	/**
	 * 物探处直接调拨外租设备
	 * @return
	 */
	public static String getWTCHireDevAppNo(String zjFlag){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String wtcAppNo = "";
		if("WZJBQ".equals(zjFlag)){
			wtcAppNo = "外租检波器调配"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else{
			wtcAppNo = "外租单台调配"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}
		return wtcAppNo;
	}
	/**
	 * 各种设备返还申请
	 * @return
	 */
	public static String getDevBackAppNo(String devFlag){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String backAppNo = "";
		if("JBQ".equals(devFlag)){
			backAppNo = "检波器返还申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else if("COLL".equals(devFlag)){
			backAppNo = "地震仪器返还申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else if("ZY".equals(devFlag)){
			backAppNo = "自有设备返还申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else if("JY".equals(devFlag)){
			backAppNo = "震源设备返还申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else if("CL".equals(devFlag)){
			backAppNo = "测量设备返还申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else if("YQFS".equals(devFlag)){
			backAppNo = "仪器附属返还申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else if("TJ".equals(devFlag)){
			backAppNo = "调剂设备返还申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else{
			backAppNo = "返还申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}
		return backAppNo;
	}
	 /**
	 * 接收外租设备
	 * @return
	 */
	public static String getWTCHireDevAppNoNew(String hireDevType){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String wtcAppNo = "";
		wtcAppNo = "外租设备接收";
		if("1".equals(hireDevType)){
			wtcAppNo = "外租检波器接收";
		}else if("2".equals(hireDevType)){
			wtcAppNo = "外租地震仪器接收";
		}else {
			wtcAppNo = "外租单台接收";
		}
		wtcAppNo +=sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		return wtcAppNo;
	}
	/**
	 * 返回对应物探处subid
	 * @return
	 */
	public static String getWtcSubId(String subCode){
		String wtcSubId = "";
		if(StringUtils.isNotBlank(subCode)){
			if(DevConstants.DMS_INDICATORE_TLMWTC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_TLMWTC_SUB_ID;//塔里木物探处
			}else if(DevConstants.DMS_INDICATORE_XJWTC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_XJWTC_SUB_ID;//新疆物探处
			}else if(DevConstants.DMS_INDICATORE_THWTC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_THWTC_SUB_ID;//吐哈物探处
			}else if(DevConstants.DMS_INDICATORE_QHWTC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_QHWTC_SUB_ID;//青海物探处
			}else if(DevConstants.DMS_INDICATORE_DGWTC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_DGWTC_SUB_ID;//海洋物探处
			}else if(DevConstants.DMS_INDICATORE_LHWTC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_LHWTC_SUB_ID;//辽河物探处
			}else if(DevConstants.DMS_INDICATORE_HBWTC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_HBWTC_SUB_ID;//华北物探处
			}else if(DevConstants.DMS_INDICATORE_XXWTKFC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_XXWTKFC_SUB_ID;//新兴物探开发处
			}else if(DevConstants.DMS_INDICATORE_ZHWHTC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_ZHWHTC_SUB_ID;//综合物化探处
			}else if(DevConstants.DMS_INDICATORE_XNWTC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_XNWTC_SUB_ID;//西南物探处
			}else if(DevConstants.DMS_INDICATORE_DQYGS_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_DQYGS_SUB_ID;//大庆物探一公司
			}else if(DevConstants.DMS_INDICATORE_DQEGS_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_DQEGS_SUB_ID;//大庆物探二公司
			}else if(DevConstants.DMS_INDICATORE_ZBFWC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_ZBFWC_SUB_ID;//装备服务处
			}else if(DevConstants.DMS_INDICATORE_CQWTC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_CQWTC_SUB_ID;//长庆物探处
			}else if(DevConstants.DMS_INDICATORE_GJKTSYB_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_GJKTSYB_SUB_ID;//国际勘探事业部
			}else if(DevConstants.DMS_INDICATORE_SHWTC_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_SHWTC_SUB_ID;//深海物探处
			}else if(DevConstants.DMS_INDICATORE_YQFWZX_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_YQFWZX_SUB_ID;//仪器服务中心
			}else if(DevConstants.DMS_INDICATORE_CLFWZX_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_CLFWZX_SUB_ID;//测量服务中心
			}else if(DevConstants.DMS_INDICATORE_ZYFWZX_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_ZYFWZX_SUB_ID;//震源服务中心
			}else if(DevConstants.DMS_INDICATORE_BJZYB_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_BJZYB_SUB_ID;//北疆作业部
			}else if(DevConstants.DMS_INDICATORE_DHZYB_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_DHZYB_SUB_ID;//敦煌作业部
			}else if(DevConstants.DMS_INDICATORE_HBZYB_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_HBZYB_SUB_ID;//华北作业部
			}else if(DevConstants.DMS_INDICATORE_LHZYB_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_LHZYB_SUB_ID;//辽河作业部
			}else if(DevConstants.DMS_INDICATORE_TLMZYB_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_TLMZYB_SUB_ID;//塔里木作业部
			}else if(DevConstants.DMS_INDICATORE_THZYB_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_THZYB_SUB_ID;//吐哈木作业部
			}else if(DevConstants.DMS_INDICATORE_XQZYB_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_XQZYB_SUB_ID;//新区木作业部
			}else if(DevConstants.DMS_INDICATORE_CQZYB_CODE.equals(subCode)){
				wtcSubId = DevConstants.DMS_INDICATORE_CQZYB_SUB_ID;//长庆木作业部
			}else{
				wtcSubId = DevConstants.COMM_COM_ORGSUBID;
			}
		}
		return wtcSubId;
	}
	/**
	 * 返回对应物探处orgid
	 * @return
	 */
	public static String getWtcOrgId(String subCode){
		String wtcOrgId = "";
		if(StringUtils.isNotBlank(subCode)){
			if(DevConstants.DMS_INDICATORE_TLMWTC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_TLMWTC_ORG_ID; 
			}else if(DevConstants.DMS_INDICATORE_XJWTC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_XJWTC_ORG_ID;
			}else if(DevConstants.DMS_INDICATORE_THWTC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_THWTC_ORG_ID;
			}else if(DevConstants.DMS_INDICATORE_QHWTC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_QHWTC_ORG_ID;
			}else if(DevConstants.DMS_INDICATORE_DGWTC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_DGWTC_ORG_ID;
			}else if(DevConstants.DMS_INDICATORE_LHWTC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_LHWTC_ORG_ID;
			}else if(DevConstants.DMS_INDICATORE_HBWTC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_HBWTC_ORG_ID;
			}else if(DevConstants.DMS_INDICATORE_XXWTKFC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_XXWTKFC_ORG_ID;
			}else if(DevConstants.DMS_INDICATORE_ZHWHTC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_ZHWHTC_ORG_ID;
			}else if(DevConstants.DMS_INDICATORE_ZBFWC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_ZBFWC_ORG_ID;
			}else if(DevConstants.DMS_INDICATORE_CQWTC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_CQWTC_ORG_ID;
			}else if(DevConstants.DMS_INDICATORE_GJKTSYB_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_GJKTSYB_ORG_ID;
			}else if(DevConstants.DMS_INDICATORE_SHWTC_CODE.equals(subCode)){
				wtcOrgId = DevConstants.DMS_INDICATORE_SHWTC_ORG_ID;
			}else{
				wtcOrgId = DevConstants.COMM_COM_ORGID;
			}
		}
		return wtcOrgId;
	}
	/**
	 * 返回考核对应的detail_id(此方法暂时这样使用，值不能写死在里边)
	 * @return
	 */
	public static String getMonitorDetailId(String detCode){
		String detailId = "";
		if(StringUtils.isNotBlank(detCode)){
			if(DevConstants.DMS_INDICATORE_KGYS_CODE.equals(detCode)){
				detailId = DevConstants.DMS_INDICATORE_KGYS_DET_ID; 
			}else if(DevConstants.DMS_INDICATORE_BYGL_CODE.equals(detCode)){
				detailId = DevConstants.DMS_INDICATORE_BYGL_DET_ID;
			}else if(DevConstants.DMS_INDICATORE_SBKQ_CODE.equals(detCode)){
				detailId = DevConstants.DMS_INDICATORE_SBKQ_DET_ID;
			}else if(DevConstants.DMS_INDICATORE_DRDJ_CODE.equals(detCode)){
				detailId = DevConstants.DMS_INDICATORE_DRDJ_DET_ID;
			}else if(DevConstants.DMS_INDICATORE_YZJL_CODE.equals(detCode)){
				detailId = DevConstants.DMS_INDICATORE_YZJL_DET_ID;
			}else if(DevConstants.DMS_INDICATORE_SBFH_CODE.equals(detCode)){
				detailId = DevConstants.DMS_INDICATORE_SBFH_DET_ID;
			}else if(DevConstants.DMS_INDICATORE_SGYS_CODE.equals(detCode)){
				detailId = DevConstants.DMS_INDICATORE_SGYS_DET_ID;
			}else if(DevConstants.DMS_INDICATORE_TZSBGL_CODE.equals(detCode)){
				detailId = DevConstants.DMS_INDICATORE_TZSBGL_DET_ID;
			}else if(DevConstants.DMS_INDICATORE_DZYQPK_CODE.equals(detCode)){
				detailId = DevConstants.DMS_INDICATORE_DZYQPK_DET_ID;
			}else if(DevConstants.DMS_INDICATORE_DZYQHS_CODE.equals(detCode)){
				detailId = DevConstants.DMS_INDICATORE_DZYQHS_DET_ID;
			}
		}
		return detailId;
	}
	/**
	 * 装备直接申请震源、测量及仪器车设备申请单编号
	 * @return
	 */
	public static String getZCDevAppNo(String zcFlag){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String zcAppNo = "";
		if("zy".equals(zcFlag)){
			zcAppNo = "震源设备申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else if("cl".equals(zcFlag)){
			zcAppNo = "测量设备申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}else{
			zcAppNo = "仪器车设备申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
		}
		return zcAppNo;
	}
	/**
	 * 装备采集设备申请单编号
	 * @return
	 */
	public static String getCollDevAppNo(){
		Object[] array = new Object[]{new Double(Math.random()*1000).intValue()};
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		return "采集设备申请"+sdf.format(new Date())+MessageFormat.format("{0,number,0000}", array);
	}
	/**
	* 验证输入密码是否符合条件(必须同时包含：大写字母、小写字母、数字、特殊字符,长度要求12位以上)
	* 
	* @param 待验证的字符串
	* @return 如果是符合格式的字符串,返回 <b>true </b>,否则为 <b>false </b>
	*/
	public static boolean isValidPassword(String str) {
		String regEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@#!*?&])[A-Za-z\\d$@#!*?&]{12,}";
		return match(regEx, str);
	}
	/**
	* @param regex
	* 正则表达式字符串
	* @param str
	* 要匹配的字符串
	* @return 如果str 符合 regex的正则表达式格式,返回true, 否则返回 false;
	*/
	private static boolean match(String regEx, String str) {
		Pattern pattern = Pattern.compile(regEx);
		Matcher matcher = pattern.matcher(str);
		return matcher.matches();
	}
}
