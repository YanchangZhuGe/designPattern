package com.bgp.mcs.service.ma.showMainFrame.util;

import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;

/**
 * 
 * 标题：物探生产管理系统
 * 
 * 专业：物探专业
 * 
 * 公司：中油瑞飞
 * 
 * 作者：邱庆豹，2011-9-5
 * 
 * 描述：市场信息平台展示页面获取某类信息通用工具类
 */

@SuppressWarnings({ "unchecked", "rawtypes" })
public class MarketGetInfoUtil {

	private IJdbcDao queryJdbcDao = BeanFactory.getQueryJdbcDAO();
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private static MarketGetInfoUtil mg = null;

	private MarketGetInfoUtil() {

	}

	public static MarketGetInfoUtil getInstance() {
		if (mg == null) {
			return new MarketGetInfoUtil();
		} else {
			return mg;
		}
	}

	/*
	 * 根据类别获取标题信息
	 */
	public List getMarketHeadingInfoByType(String twoTypeId) {
		StringBuffer sql = new StringBuffer(
				"SELECT T.INFOMATION_NAME, T.ABSTRACT summary,t.release_date,t.infomation_id FROM BGP_INFOMATION_RELEASE_INFO T ")
				.append("WHERE T.BSFLAG = '0'  AND T.TWO_TYPE_ID in (" + twoTypeId + ")  ORDER BY T.RELEASE_DATE DESC ");
		List list = queryJdbcDao.queryRecords(sql.toString());
		return list;
	}

	/*
	 * 根据二级类别获取标题信息
	 */
	public List getMarketHeadingInfoByType(String twoTypeId, int rowcount) {
		rowcount = rowcount + 1;
		rowcount = rowcount + 1;
		StringBuffer sql = new StringBuffer(
				"select * from (SELECT T.INFOMATION_NAME, T.ABSTRACT summary,t.release_date,t.infomation_id FROM BGP_INFOMATION_RELEASE_INFO T ")
				.append("WHERE T.BSFLAG = '0'  AND T.TWO_TYPE_ID in (" + twoTypeId + ") "
						+ " ORDER BY T.RELEASE_DATE DESC, T.MODIFY_DATE DESC ) where rownum <'"+rowcount+"'");
		List list = queryJdbcDao.queryRecords(sql.toString());
		return list;
	}
	/*
	 *根据二级类别获取标题信息  （油公司，物探公司） 
	*/
	public List getMarketHeadingInfoByType2(String twoTypeId, int rowcount) {
		rowcount = rowcount + 1;
		rowcount = rowcount + 1;
		StringBuffer sql = new StringBuffer(
				"SELECT * FROM (SELECT T.INFOMATION_NAME, T.ABSTRACT summary,t.release_date,t.infomation_id FROM BGP_INFOMATION_RELEASE_INFO T ")
				.append("WHERE T.BSFLAG = '0'  AND T.THREE_TYPE_ID in '"+twoTypeId+"' ORDER BY T.RELEASE_DATE DESC, T.MODIFY_DATE DESC ) where rownum <'" + rowcount
						+ "'");
		List list = queryJdbcDao.queryRecords(sql.toString());
		return list;
	}
	
	/*
	 * 根据三级类别获取标题信息
	 */
	public List getMarketHeadingInfoByType3(String threeTypeId, int rowcount) {
		rowcount = rowcount + 1;
		rowcount = rowcount + 1;
		StringBuffer sql = new StringBuffer(
				"select * from (SELECT T.INFOMATION_NAME, T.ABSTRACT summary,t.release_date,t.infomation_id FROM BGP_INFOMATION_RELEASE_INFO T ")
				.append("WHERE T.BSFLAG = '0'  AND T.TWO_TYPE_ID in (" + threeTypeId + ")"
						+ " ORDER BY T.RELEASE_DATE DESC,T.MODIFY_DATE DESC) where rownum <'"+rowcount+"'");
		List list = queryJdbcDao.queryRecords(sql.toString());
		return list;
	}
	
	/*
	 * 根据类别获取标题信息
	 */
	public List getMarketHeadingInfoByType(String twoTypeId, String threeTypeId) {
		StringBuffer sql = new StringBuffer(
				"SELECT T.INFOMATION_NAME, T.ABSTRACT summary,t.release_date,t.infomation_id FROM BGP_INFOMATION_RELEASE_INFO T ")
				.append("WHERE T.BSFLAG = '0'  AND T.TWO_TYPE_ID in (" + twoTypeId + ") AND T.THREE_TYPE_ID in (" + threeTypeId
						+ ")  ORDER BY T.RELEASE_DATE DESC ");
		List list = queryJdbcDao.queryRecords(sql.toString());
		return list;
	}

	/*
	 * 根据类别获取标题，摘要以及主键信息(获取前rowcount行)
	 */
	public List getMarketHeadingInfoByType(String twoTypeId, String threeTypeId, int rowcount) {
		rowcount = rowcount + 1;
		StringBuffer sql = new StringBuffer(
				"SELECT T.INFOMATION_NAME, T.ABSTRACT summary, T.INFOMATION_ID,t.release_date FROM BGP_INFOMATION_RELEASE_INFO T ")
				.append("WHERE T.BSFLAG = '0' and rownum <" + rowcount + " AND T.TWO_TYPE_ID in (" + twoTypeId
						+ ") AND T.THREE_TYPE_ID in ('" + threeTypeId + "')  ORDER BY T.RELEASE_DATE DESC ");
		List list = queryJdbcDao.queryRecords(sql.toString());
		return list;
	}

	/*
	 * 根据informationId获取blob信息,用于点击标题显示详细内容
	 */
	public Map getMarketContentInfoById(String informationId) {
		StringBuffer sql = new StringBuffer(
				"SELECT T.INFOMATION_NAME, T.ABSTRACT summary, T.INFOMATION_ID, T.CONTENT,t.release_date FROM BGP_INFOMATION_RELEASE_INFO T ")
				.append(" WHERE T.INFOMATION_ID = '" + informationId + "'");
		Map map = queryJdbcDao.queryRecordBySQL(sql.toString());
		Map returnMap = new HashMap();
		returnMap.put("infomationName", map.get("infomationName"));
		returnMap.put("abstract", map.get("abstract"));
		if (map.get("content") != null && !"".equals(map.get("content"))) {
			String content;
			try {
				content = new String((byte[]) map.get("content"), "GBK");
			} catch (UnsupportedEncodingException e) {
				returnMap.put("errorMessage", "编码错误");
				return returnMap;
			}
			returnMap.put("content", content);
		} else {
			String content = "";
			returnMap.put("content", content);
		}

		return returnMap;
	}

	/*
	 * 获取附件中添加的最新的N张图片
	 */
	public List getMarketNewPictureUrl(int count) {
		StringBuffer sql = new StringBuffer(
				"SELECT T.INFOMATION_NAME, T.ABSTRACT summary, T.INFOMATION_ID, T.CONTENT,t.release_date FROM BGP_INFOMATION_RELEASE_INFO T ")
				.append(" WHERE T.bsflag='0' and t.two_type_id like '103%' order by T.create_date DESC");
		List list = queryJdbcDao.queryRecords(sql.toString());
		List returnList = new ArrayList();
		for (int i = 0; list != null && i < list.size() && count > 0; i++) {
			Map map = (Map) list.get(i);
			Map returnMap = new HashMap();
			
			String infomationName=(String) (map.get("infomationName")!=null?map.get("infomationName"):"");
			if(infomationName.length()>=25){
				infomationName=infomationName.substring(0,25)+"...";
			}
			returnMap.put("infomationName", infomationName);
			returnMap.put("summary", map.get("summary"));
			returnMap.put("releaseDate",map.get("summary"));
			returnMap.put("content", map.get("content"));
			returnMap.put("infomationId", map.get("infomationId"));
			if (map.get("content") != null && !"".equals(map.get("content"))) {
				String content;
				try {
					content = new String((byte[]) map.get("content"), "GBK");
				} catch (UnsupportedEncodingException e) {
					return returnList;
				}
				String url = getImgSrcFromContent(content);
				if (!"".equals(url)) {
					returnMap.put("url", url);
					count--;
					returnList.add(returnMap);
				}
			}

		}
		return returnList;
	}

	/*
	 * 获取某类别的信息以及content中包含的图片信息(获取前rowcount行)
	 */

	public List getMarketHeadingInfoAndImgByType(String twoTypeId, String threeTypeId, int rowcount) {
		rowcount = rowcount + 1;
		StringBuffer sql = new StringBuffer(
				"SELECT T.INFOMATION_NAME, T.ABSTRACT summary, T.INFOMATION_ID,t.release_date, T.CONTENT FROM BGP_INFOMATION_RELEASE_INFO T ")
				.append("WHERE T.BSFLAG = '0' and rownum <" + rowcount + " AND T.TWO_TYPE_ID in (" + twoTypeId
						+ ") AND T.THREE_TYPE_ID in (" + threeTypeId + ")  ORDER BY T.RELEASE_DATE DESC ");
		List list = queryJdbcDao.queryRecords(sql.toString());
		List returnList = new ArrayList();
		for (int i = 0; list != null && i < list.size(); i++) {
			Map map = (Map) list.get(i);
			Map returnMap = new HashMap();
			returnMap.put("infomationName", map.get("infomationName"));
			returnMap.put("summary", map.get("summary"));
			returnMap.put("releaseDate", map.get("releaseDate"));
			returnMap.put("content", map.get("content"));
			returnMap.put("infomationId", map.get("infomationId"));
			if (map.get("content") != null && !"".equals(map.get("content"))) {
				String content;
				try {
					content = new String((byte[]) map.get("content"), "GBK");
				} catch (UnsupportedEncodingException e) {
					return returnList;
				}

				returnMap.put("url", getImgSrcFromContent(content));
			}
			returnList.add(returnMap);
		}
		return list;
	}

	/*
	 * 获取某类别的信息以及content中包含的图片信息(获取前rowcount行)
	 */

	public List getMarketHeadingInfoAndImgByType(String twoTypeId, int rowcount) {

		rowcount = rowcount + 1;
		StringBuffer sql = new StringBuffer(
				"SELECT T.INFOMATION_NAME, T.ABSTRACT summary, T.INFOMATION_ID,t.release_date, T.CONTENT FROM BGP_INFOMATION_RELEASE_INFO T ")
				.append("WHERE T.BSFLAG = '0' and rownum <" + rowcount + " AND T.TWO_TYPE_ID in (" + twoTypeId
						+ ")   ORDER BY T.RELEASE_DATE DESC ");
		List list = queryJdbcDao.queryRecords(sql.toString());
		List returnList = new ArrayList();
		for (int i = 0; list != null && i < list.size(); i++) {
			Map map = (Map) list.get(i);
			Map returnMap = new HashMap();
			returnMap.put("infomationName", map.get("infomationName"));
			returnMap.put("summary", map.get("summary"));
			returnMap.put("releaseDate", map.get("releaseDate"));
			returnMap.put("content", map.get("content"));
			returnMap.put("infomationId", map.get("infomationId"));
			if (map.get("content") != null && !"".equals(map.get("content"))) {
				String content;
				try {
					content = new String((byte[]) map.get("content"), "GBK");
				} catch (UnsupportedEncodingException e) {
					return returnList;
				}

				returnMap.put("url", getImgSrcFromContent(content));
			}
			returnList.add(returnMap);
		}
		return returnList;
	}

	/*
	 * 从content里面去的img的src地址
	 */
	public String getImgSrcFromContent(String content) {
		String result = "";
		if (content.contains("img")) {
			Pattern pattern = Pattern.compile("<img.*/>");
			Matcher matcher = pattern.matcher(content);
			if (matcher.find()) {
				String resultTemp = matcher.group(0);
				Pattern patternTemp = Pattern.compile("src=\".+?\"");
				Matcher matcherTemp = patternTemp.matcher(resultTemp);
				if (matcherTemp.find()) {
					result = matcherTemp.group(0);
					result = result.replaceAll("src=", "");
					result = result.replaceAll("\"", "");
					result = result.replaceAll("/BGPMCS", "");
					return result;
				} else {
					return result;
				}
			} else {
				return result;
			}
		} else {
			return result;
		}
	}

	/*
	 * 获取下级分类列表
	 */
	public List getTypeInfoByFather(String fatherCode) {
		String sql = "select t.code,t.code_name from BGP_INFOMATION_TYPE_INFO t where t.code not in ('10502017','10502016','10502015','10502014','10502006','10502003','10504001') and t.bsflag='0'  and t.father_code='" + fatherCode
				+ "' order by t.code asc";
		List list = queryJdbcDao.queryRecords(sql.toString());
		return list;
	}

	/*
	 * 获取某分类下的所有叶子节点
	 */
	public List getLeafTypeInfoByFather(String fatherCode) {
		String sql = "select p.code,p.code_name,p.type_level from (SELECT CONNECT_BY_ISLEAF isleaf,t.type_level, t.code,t.code_name FROM BGP_INFOMATION_TYPE_INFO T "
				+ "START WITH T.FATHER_CODE = "
				+ fatherCode
				+ " CONNECT BY PRIOR T.CODE = T.FATHER_CODE ) p where p.isleaf=1 order by p.code asc";
		List list = queryJdbcDao.queryRecords(sql.toString());
		return list;
	}

	/*
	 * 获取组织机构中最新的一张图片
	 */
	public String getSrcByContentFromOrgModel(String twoTypeId) {
		StringBuffer sql = new StringBuffer(
				"SELECT T.INFOMATION_NAME, T.ABSTRACT summary, T.INFOMATION_ID,t.release_date, T.CONTENT FROM BGP_INFOMATION_RELEASE_INFO T ")
				.append("WHERE T.BSFLAG = '0'  AND T.TWO_TYPE_ID ='"+twoTypeId+"'   ORDER BY T.RELEASE_DATE DESC ");
		List list = queryJdbcDao.queryRecords(sql.toString());
		String returnStr="";
		String content="";
		for (int i = 0; list != null && i < 1; i++) {
			Map map = (Map) list.get(i);
			if (map.get("content") != null && !"".equals(map.get("content"))) {
				
				try {
					content = new String((byte[]) map.get("content"), "GBK");
				} catch (UnsupportedEncodingException e) {
					return "";
				}

				returnStr=content;
			}
		}
		return returnStr;
	}
	
	public List getNewGetIncomeMoney(){
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	    String today = format.format(new Date());
	    String endDate = "";
	    String sql = "";
		String[] circalInfo=today.split("-");
		if(Integer.parseInt(circalInfo[2])>26){
			endDate=circalInfo[0]+"-"+circalInfo[1]+"-25";
		}else{
			if(circalInfo[1].equals("01")){//如果是一月份
				endDate=String.valueOf(Integer.parseInt(circalInfo[0])-1)+"-12-25";//上一年度12月25日开始
			}else if(circalInfo[1].equals("11") || circalInfo[1].equals("12")){
				endDate=circalInfo[0]+"-"+String.valueOf(Integer.parseInt(circalInfo[1])-1)+"-25";//上个月25日开始
			}else{
				endDate=circalInfo[0]+"-0"+String.valueOf(Integer.parseInt(circalInfo[1])-1)+"-25";//上个月25日开始，月份前多加个0
			}
		}
		
		if(Integer.parseInt(circalInfo[2])>26){
			sql = "select "
			    +"oi.org_abbreviation "
			    +",round((nvl(bud.new_get,0)+nvl(bud.new_get_out,0))/12*to_number(to_char(sysdate,'MM'))/10000,2) as bud " 
			    +",round(sum(nvl(inc.new_get,0))/10000,2) as inc "
			    +"from bgp_wr_income_money inc "
			    +"join bgp_wr_budget_year bud "
			    +"on bud.org_subjection_id = inc.org_subjection_id "
			    +"and bud.bsflag = '0' and bud.year=to_char(sysdate, 'yyyy') "
			    +"join comm_org_information oi "
			    +"on oi.org_id = inc.org_id "
			    +"and oi.bsflag = '0' "
			    +"where inc.bsflag = '0' "
			    +"and inc.week_end_date = to_date('"+endDate+"','yyyy-mm-dd') and inc.org_type='1' and inc.type='2' "
			    +"group by inc.org_subjection_id,oi.org_abbreviation,bud.new_get,bud.new_get_out "
			    +"having sum(nvl(inc.new_get,0))-(nvl(bud.new_get,0)+nvl(bud.new_get_out,0))/12*to_number(to_char(sysdate,'MM')) < 0 ";
		}else{
			sql = "select "
			    +"oi.org_abbreviation "
			    +",round((nvl(bud.new_get,0)+nvl(bud.new_get_out,0))/12*(to_number(to_char(sysdate,'MM'))-1)/10000,2) as bud " 
			    +",round(sum(nvl(inc.new_get,0))/10000,2) as inc "
			    +"from bgp_wr_income_money inc "
			    +"join bgp_wr_budget_year bud "
			    +"on bud.org_subjection_id = inc.org_subjection_id "
			    +"and bud.bsflag = '0' and bud.year=to_char(sysdate, 'yyyy') "
			    +"join comm_org_information oi "
			    +"on oi.org_id = inc.org_id "
			    +"and oi.bsflag = '0' "
			    +"where inc.bsflag = '0' "
			    +"and inc.week_end_date = to_date('"+endDate+"','yyyy-mm-dd') and inc.org_type='1' and inc.type='2' "
			    +"group by inc.org_subjection_id,oi.org_abbreviation,bud.new_get,bud.new_get_out "
			    +"having sum(nvl(inc.new_get,0))-(nvl(bud.new_get,0)+nvl(bud.new_get_out,0))/12*(to_number(to_char(sysdate,'MM')-1)) < 0 ";
		}
		
		
//		String sql = "select "+
//		"oi.org_abbreviation "+
//		",round(nvl(bud.new_get+bud.new_get_out,0)/12*to_number(to_char(sysdate,'MM'))/10000,2) as bud "+
//		",round(sum(nvl(inc.new_get,0))/10000,2) as inc " +
//		"from bgp_wr_income_money inc "+
//		"join bgp_wr_budget_year bud "+
//		"on bud.org_subjection_id = inc.org_subjection_id "+
//		"and bud.bsflag = '0' and bud.year=to_char(sysdate, 'yyyy')"+
//		"join comm_org_information oi "+
//		"on oi.org_id = inc.org_id "+
//		"and oi.bsflag = '0' "+
//		"where inc.bsflag = '0' "+
//		"and to_char(inc.week_date,'yyyy') = to_char(sysdate,'yyyy') "+
//		"group by inc.org_subjection_id,oi.org_abbreviation,bud.new_get,bud.new_get_out "+
//		"having sum(nvl(inc.new_get,0))-nvl(bud.new_get+bud.new_get_out,0)/12*to_number(to_char(sysdate,'MM')) < 0";
		List list = queryJdbcDao.queryRecords(sql);
		return list;
	}
	
	public String getCountFromProjecttDynamic(String orgId,String status,String recordYear) {
		String sql ="select count(*) count from mm_project_dynamic t where t.corp_id='"+orgId+"' and t.project_status='"+status+"' and t.record_year='"+recordYear+"'";
		Map map = queryJdbcDao.queryRecordBySQL(sql);
		
		String returnStr="";
		String count="";
		if(map.get("count")!=null){
			 count = (String)map.get("count");
		}else{
			 count = "0";
		}
		returnStr = count;
		return returnStr;
	}
	
	public String getCountFromTeamDynamic(String orgId,String status) {
		String sql ="select count(*) count from mm_team_dynamic t where t.corp_id = '"+orgId+"' and t.team_status = '"+status+"'";
		Map map = queryJdbcDao.queryRecordBySQL(sql);
		
		String returnStr="";
		String count="";
		if(map.get("count")!=null){
			 count = (String)map.get("count");
		}else{
			 count = "0";
		}
		returnStr = count;
		return returnStr;
	}
	
	//添加操作日志
	public void addLogInfo(String title,String operationPlace) throws Exception {
		
		Date now = new Date();
		
		Map map = new HashMap();
		map.put("OPERATION_TITLE",title) ;
		map.put("OPERATION_PLACE",operationPlace) ;
		map.put("CREATE_DATE",now) ;
		map.put("MODIFY_DATE",now) ;
		map.put("BSFLAG","0") ;
		pureJdbcDao.saveOrUpdateEntity(map, "COMM_OPERATION_LOG");
	}
	
	public static List<Map> getListMapFromListMsgElement(List<MsgElement> mg) {
		List<Map> returnList = new ArrayList<Map>();
		if (mg != null) {
			for (int i = 0; i < mg.size(); i++) {
				try {
					Map map = mg.get(i).toMap();
					returnList.add(map);
				} catch (Exception e) {
					return returnList;
				}
			}
			return returnList;
		} else {
			return returnList;
		}
	}

	
}
