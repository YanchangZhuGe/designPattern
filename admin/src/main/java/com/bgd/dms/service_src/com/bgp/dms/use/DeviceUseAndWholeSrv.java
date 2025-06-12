package com.bgp.dms.use;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 
 * @author wangzheqin 2015.3.18
 *
 */
public class DeviceUseAndWholeSrv extends BaseService{
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	
	public DeviceUseAndWholeSrv(){
		log = LogFactory.getLogger(DeviceUseAndWholeSrv.class);
	}
		
	/**	
	 * 获得主要设备利用率,输出成图表显示
	 * @return dateSets
	 */
	public ISrvMsg getUseRate(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		String currentDate=getCurrentDate();
		// 级别(默认为第一级)
		String level = reqDTO.getValue("level");
		if(StringUtils.isBlank(level)){
			level="0";
		}
		//截取长度(编码规则是每级编码长度加3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree编码(默认为空，级别为第一级)
		String devTreeId = reqDTO.getValue("devTreeId");
		// 物探处
		String orgSubId = reqDTO.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// 国内国外
		String country = reqDTO.getValue("country");
		String vcountry="";
		if(StringUtils.isBlank(country)){
			country="";
		}else{
			if("1".equals(country)){
				vcountry="国内";
			}
			if("2".equals(country)){
				vcountry="国外";			
			}
		}
		// 开始时间
		String startDate = reqDTO.getValue("startDate");
		// 结束时间
		String endDate = reqDTO.getValue("endDate");
		String _startDate="";
		String _endDate="";
		if(StringUtils.isNotBlank(startDate)){
			_startDate=startDate;
		}else{
			_startDate=(currentYear+"-01-01").trim();
		}
		if(StringUtils.isNotBlank(endDate)){
			_endDate=endDate;
		}else{
			_endDate=currentDate;
		}
		String hisDate="";
		String hisSql="select to_char(min(dt.his_date),'yyyy-mm-dd') as min_his_date, to_char(max(dt.his_date),'yyyy-mm-dd') as max_his_date from gms_device_dailyhistory dt where    dt.account_stat='0110000013000000003' and  dt.bsflag = '0'";
		Map hisMap=pureJdbcDao.queryRecordBySQL(hisSql);
		if(MapUtils.isNotEmpty(hisMap)){
			String minHisDate=hisMap.get("min_his_date").toString();
			String maxHisDate=hisMap.get("max_his_date").toString();
			if(compareDateStr(minHisDate,_endDate) || compareDateStr(_endDate,maxHisDate)){
				hisDate=maxHisDate;
			}else{
				hisDate=_endDate;
			}
		}else{
			hisDate=_endDate;
		}
		StringBuilder sb = new StringBuilder();
		if(StringUtils.isBlank(orgSubId)){
			sb.append("select '东方' label,round(decode(sum(dh.sum_num),0,0,sum(dh.use_num) / sum(dh.sum_num)),4)*100 as userate, ")
			  .append("round(decode(sum(dh.sum_num),0,0,sum(dh.intact_num) / sum(dh.sum_num)),4)*100  as whrate ")
			  .append("from gms_device_dailyhistory dh  left join comm_org_information i on i.org_id = dh.org_id ")
			  .append("where    dh.account_stat='0110000013000000003' and dh.bsflag='0' ");
		}else{
			sb.append(
				"select org_abbreviation as label,nvl(decode(sum(dh.sum_num),0,0,sum(dh.use_num) / sum(dh.sum_num)),0)*100 as userate, "
						+ "nvl(decode(sum(dh.sum_num),0,0,sum(dh.intact_num) / sum(dh.sum_num)),0)*100 as whrate "
						+ "from gms_device_dailyhistory dh left join comm_org_information i on i.org_id = dh.org_id where dh.bsflag='0'");
		}
		
		
		StringBuilder sql = new StringBuilder(
				"select t.*, d.device_name as label"
						+ " from (select substr(dt.dev_tree_id, 1, "+subStrLength+") dev_tree_id,"
						+ " round(decode(sum(dh.sum_num),0,0,sum(dh.use_num) / sum(dh.sum_num)),4)*100 as userate,"
						+ "round(decode(sum(dh.sum_num),0,0,sum(dh.intact_num) / sum(dh.sum_num)),4)*100 as whrate,"
						+ " sum(case when dh.his_date = to_date('" + hisDate + "','yyyy-mm-dd')  then"
						+ " dh.sum_num else 0 end) as sum_day_num"
						+ " from dms_device_tree dt"
						+ " left join gms_device_dailyhistory dh"
						+ " on dh.device_type = dt.device_code"
						+ " and dh.bsflag = '0' and   dh.account_stat='0110000013000000003'");
		
		// 国内国外
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and dh.country='"+vcountry+"'");
			sb.append(" and dh.country='"+vcountry+"'");
		}
		// 开始时间
		sql.append(" and dh.his_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		sb.append(" and dh.his_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and dh.his_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sb.append(" and dh.his_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" where dt.bsflag = '0'");
		
		
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dh.org_subjection_id='"+orgSubId+"'");
			sb.append(" and dh.org_subjection_id='"+orgSubId+"'").append(" group by org_abbreviation ");
		}
		// tree编码
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%' and dt.dev_tree_id <> '" + devTreeId + "'");
		}
		
		List<Map> list;
		sql.append(" group by substr(dt.dev_tree_id, 1, "+subStrLength+")) t left join dms_device_tree d on t.dev_tree_id = d.dev_tree_id order by d.code_order");
		if("0".equals(level)){
			list = jdbcDao.queryRecords(sb.toString());
		}else{
			list = jdbcDao.queryRecords(sql.toString()); 
		}
		
		// 构造xml数据
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("numbersuffix", "%");

		int cLevel=Integer.parseInt(level);//当前钻取级别
		int nLevel=cLevel+1;//下一钻取级别
		// 构造数据
		if(CollectionUtils.isNotEmpty(list)){
			
			//x轴
			Element categories = root.addElement("categories");
			for(Map map:list) {
				Element category  = categories.addElement("category");
				category.addAttribute("label", map.get("label").toString());
			}
			
			//完好率
			Element dataset1 = root.addElement("dataset");
			dataset1.addAttribute("seriesName","完好率");
			for(Map map:list) {
				Element set = dataset1.addElement("set");
				set.addAttribute("value", map.get("whrate").toString());
				if("0".equals(level)){
					set.addAttribute("link","JavaScript:popNextLevelUseRate('"+nLevel+"','','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
				}else{
					String sumDayNum=map.get("sum_day_num").toString();//当前日期总量
					String cdevTreeId=map.get("dev_tree_id").toString();//当前dev_tree_id编码
					String value = "0";//默认完好率
					if(cdevTreeId.startsWith("D001")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
						}
					}
					//检波器子类型只钻取到二级
					if(cdevTreeId.startsWith("D005")){
						// 检波器 井下检波器不进行钻取
						if(cdevTreeId.startsWith("D005003")){
							if(cLevel<=1){
								set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}
						}
					}
					//可控震源,钻机,运输设备,最后显示详细信息
					if(cdevTreeId.startsWith("D002")||cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
						// 运输设备 爆破器材运输车,直接展现列表数据
						if(cdevTreeId.startsWith("D004003")){
							set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}else{
								set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}
						}
					}
					//推土机子类型只钻取到一级
					if(cdevTreeId.startsWith("D006")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
						}
					}
				}
			}
			
			//利用率
			Element dataset2 = root.addElement("dataset");
			dataset2.addAttribute("seriesName","利用率");
			for(Map map:list) {
				Element set = dataset2.addElement("set");
				set.addAttribute("value", map.get("userate").toString());
				if("0".equals(level)){
					set.addAttribute("link","JavaScript:popNextLevelUseRate('"+nLevel+"','','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
				}else{
					String sumDayNum=map.get("sum_day_num").toString();//当前日期总量
					String cdevTreeId=map.get("dev_tree_id").toString();//当前dev_tree_id编码
					String value = "0";//默认完好率
					if(cdevTreeId.startsWith("D001")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
						}
					}
					//检波器子类型只钻取到二级
					if(cdevTreeId.startsWith("D005")){
						// 检波器 井下检波器不进行钻取
						if(cdevTreeId.startsWith("D005003")){
							if(cLevel<=1){
								set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}
						}
					}
					//可控震源,钻机,运输设备,最后显示详细信息
					if(cdevTreeId.startsWith("D002")||cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
						// 运输设备 爆破器材运输车,直接展现列表数据
						if(cdevTreeId.startsWith("D004003")){
							set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}else{
								set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
							}
						}
					}
					//推土机子类型只钻取到一级
					if(cdevTreeId.startsWith("D006")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"')");
						}
					}
				}
			}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * 查询设备信息列表
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryDevList");		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		//获取当前年度
		String currentYear=getCurrentYear();
		//获取当前时间
		//String currentDate=getCurrentDate();
		String devTreeId = isrvmsg.getValue("devTreeId");//  tree编码
		String orgSubId = isrvmsg.getValue("orgSubId");// 物探处
		String country = isrvmsg.getValue("country");// 国内/国外
		String vcountry="";
		if(StringUtils.isNotBlank(country)){
			if("1".equals(country)){
				vcountry="国内";
			}
			if("2".equals(country)){
				vcountry="国外";			
			}
		}
		// 开始时间
		String startDate = isrvmsg.getValue("startDate");
		// 结束时间
		String endDate = isrvmsg.getValue("endDate");
		String _startDate="";
		String _endDate="";
		if(StringUtils.isNotBlank(startDate)){
			_startDate=startDate;
		}else{
			_startDate=(currentYear+"-01-01").trim();
		}
		if(StringUtils.isNotBlank(endDate)){
			_endDate=endDate;
		}
		String hisDate="";
		String hisSql="select to_char(min(dt.his_date),'yyyy-mm-dd') as min_his_date, to_char(max(dt.his_date),'yyyy-mm-dd') as max_his_date from gms_device_dailyhistory dt where dt.bsflag = '0'";
		Map hisMap=pureJdbcDao.queryRecordBySQL(hisSql);
		if(MapUtils.isNotEmpty(hisMap)){
			String minHisDate=hisMap.get("min_his_date").toString();
			String maxHisDate=hisMap.get("max_his_date").toString();
			if(compareDateStr(minHisDate,_endDate) || compareDateStr(_endDate,maxHisDate)){
				hisDate=maxHisDate;
			}else{
				hisDate=_endDate;
			}
		}else{
			hisDate=_endDate;
		}
		//else{
			//_endDate=currentDate;
		//}
		StringBuilder sql = new StringBuilder(
				"select t.device_code,t.userate,t.whl,t.sum_day_num,d.device_name,d.device_type, cur_date from ( "
						+ " select dt.device_code,nvl(round(decode(sum(dh.sum_num),0,0,sum(dh.use_num) *100/ sum(dh.sum_num)),2),0) as userate,"
						+ " nvl(round(decode(sum(dh.sum_num),0,0,sum(dh.intact_num)*100 / sum(dh.sum_num)),2),0) as whl,"
						+ " sum(case when dh.his_date = to_date('" + hisDate + "','yyyy-mm-dd') then"
						+ " dh.sum_num else 0 end) as sum_day_num,max(dh.his_date) as cur_date"
						+ " from dms_device_tree dt"
						+ " inner join gms_device_dailyhistory dh"
						+ " on dh.device_type = dt.device_code"
						+ " and dh.bsflag = '0'");
		// 物探处
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dh.org_subjection_id='"+orgSubId+"'");
		}
		// 国内国外
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and dh.country='"+vcountry+"'");
		}
		// 开始时间
		sql.append(" and dh.his_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// 结束时间
		sql.append(" and dh.his_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" where dt.bsflag = '0' and dt.device_code is not null ");
		// tree编码
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%'");
		}
		sql.append(" group by dt.device_code) t left join dms_device_tree d on t.device_code = d.device_code order by d.code_order");

		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	
	/**
	 * 获取当前年度
	 * 
	 * @return
	 */
	public String getCurrentYear() {
		Calendar cal = Calendar.getInstance();
		Integer year = cal.get(Calendar.YEAR);
		return year.toString();
	}

	
	/**
	 * 获取当前时间
	 * 
	 * @return
	 */
	public String getCurrentDate() {
		Date now = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat(
				"yyyy-MM-dd");
		return dateFormat.format(now);
	}
	
	/**
	 * 比较日期大小
	 * @param date1
	 * @param date2
	 * @return
	 */
	public boolean compareDateStr(String date1,String date2){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		try {
			Date d1 = sdf.parse(date1);
			Date d2 = sdf.parse(date2);
			if(d1.before(d2)){
				return false;
			}else{
				return true;
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return false;
		
	} 
}
