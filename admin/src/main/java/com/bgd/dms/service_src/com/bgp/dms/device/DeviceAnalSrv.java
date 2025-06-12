package com.bgp.dms.device;

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
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.sais.ibp.auth2.util.GMSUserUtil;
import com.cnpc.sais.ibp.auth2.util.RoleUtil;
import com.cnpc.sais.ibp.auth2.util.UserUtil;

/**
 * @ClassName: DeviceAnalSrv
 * @Description:�豸ͳ�Ʒ�������
 * @author dushuai
 * @date 2015-3-18
 */
public class DeviceAnalSrv extends BaseService {

	public DeviceAnalSrv() {
		log = LogFactory.getLogger(DeviceAnalSrv.class);
	}

	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	IBaseDao baseDao = BeanFactory.getBaseDao();

	/**
	 * ��ȡ����ʣ��������㣩ͼ������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAmountWhlChartData(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ����(Ĭ��Ϊ��һ��)
		String level = isrvmsg.getValue("level");
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = isrvmsg.getValue("devTreeId");
		// ��̽��
		String orgSubId = isrvmsg.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ���ڹ���
		String country = isrvmsg.getValue("country");
		String vcountry="";
		if(StringUtils.isBlank(country)){
			country="";
		}else{
			if("1".equals(country)){
				vcountry="����";
			}
			if("2".equals(country)){
				vcountry="����";			
			}
		}
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		}else{
			_endDate=currentDate;
		}
		String hisDate="";
		String hisSql="select to_char(min(dt.his_date),'yyyy-mm-dd') as min_his_date, to_char(max(dt.his_date),'yyyy-mm-dd') as max_his_date from gms_device_dailyhistory dt where dt.account_stat='0110000013000000003' and  dt.bsflag = '0'";
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
		//�Ƿ������豸
		String ifproduction = isrvmsg.getValue("ifproduction");
		//Ĭ������
		if(StringUtils.isBlank(ifproduction)){
			ifproduction = "5110000186000000001";
		}
		StringBuilder sql = new StringBuilder(
				"select t.*, d.device_name as label"
						+ " from (select substr(dt.dev_tree_id, 1, "+subStrLength+") dev_tree_id,"
						+ " round(nvl(decode(sum(dh.sum_num),0,0,sum(dh.intact_num)*100 / sum(dh.sum_num)),0),2) as whl,"
						+ " sum(case when dh.his_date =  to_date('" + hisDate + "','yyyy-mm-dd') then"
						+ " dh.sum_num else 0 end) as sum_day_num"
						+ " from dms_device_tree dt"
						+ " left join gms_device_dailyhistory dh"
						+ " on dh.device_type = dt.device_code"
						+ " and dh.bsflag = '0'  and dh.account_stat='0110000013000000003'");
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dh.org_subjection_id like '"+orgSubId+"%'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and dh.country='"+vcountry+"'");
		}
		// �Ƿ������豸
		if(StringUtils.isNotBlank(ifproduction)){
			sql.append(" and dh.ifproduction = '" + ifproduction + "'");
		}
		// ��ʼʱ��
		sql.append(" and dh.his_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and dh.his_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" where dt.bsflag = '0'");
		// tree����
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%' and dt.dev_tree_id <> '" + devTreeId + "'");
		}
		sql.append(" group by substr(dt.dev_tree_id, 1, "+subStrLength+")) t left join dms_device_tree d on t.dev_tree_id = d.dev_tree_id   where sum_day_num>0 order by d.code_order ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("baseFontSize", "12");
		int cLevel=Integer.parseInt(level);//��ǰ��ȡ����
		int nLevel=cLevel+1;//��һ��ȡ����
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String sumDayNum=map.get("sum_day_num").toString();//��ǰ��������
				String cdevTreeId=map.get("dev_tree_id").toString();//��ǰdev_tree_id����
				String value = "0";//Ĭ�������
				if(cdevTreeId.startsWith("D001")){
					sumDayNum+="��";
				}
				if(cdevTreeId.startsWith("D002")||cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
					sumDayNum+="̨";
				}
				if(cdevTreeId.startsWith("D005")){
					sumDayNum+="��";
				}
				set.addAttribute("label", map.get("label").toString()+"("+sumDayNum+")");
				if(null!=map.get("whl") && !"0".equals(map.get("whl").toString())){
					value=map.get("whl").toString();
					//��������������ֻ��ȡ��һ��
					if(cdevTreeId.startsWith("D001")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popNextLevelAWhl('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"','"+ifproduction+"')");
						}
					}
					//�첨��������ֻ��ȡ������
					if(cdevTreeId.startsWith("D005")){
						// �첨�� ���¼첨����������ȡ
						if(cdevTreeId.startsWith("D005003")){
							if(cLevel<=1){
								set.addAttribute("link", "JavaScript:popNextLevelAWhl('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"','"+ifproduction+"')");
							}
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextLevelAWhl('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"','"+ifproduction+"')");
							}
						}
					}
					//�ɿ���Դ,���,�����豸,�����ʾ��ϸ��Ϣ
					if(cdevTreeId.startsWith("D002")||cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
						// �����豸 �����������䳵,ֱ��չ���б�����
						if(cdevTreeId.startsWith("D004003")){
							set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"','"+ifproduction+"')");
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextLevelAWhl('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"','"+ifproduction+"')");
							}else{
								set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"','"+ifproduction+"')");
							}
						}
					}
					//������������ֻ��ȡ��һ��
					if(cdevTreeId.startsWith("D006")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"','"+ifproduction+"')");
						}
					}
				}
				set.addAttribute("value", value);
				set.addAttribute("displayValue", value+"%");
				set.addAttribute("toolText", map.get("label").toString()+","+value+"%");
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}

	
	
	/**
	 * ��ѯ�豸��Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryDevList");
		UserToken user = isrvmsg.getUserToken();
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
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		String devTreeId = isrvmsg.getValue("devTreeId");//  tree����
		String orgSubId = isrvmsg.getValue("orgSubId");// ��̽��
		String country = isrvmsg.getValue("country");// ����/����
		String vcountry="";
		if(StringUtils.isNotBlank(country)){
			if("1".equals(country)){
				vcountry="����";
			}
			if("2".equals(country)){
				vcountry="����";			
			}
		}
		// ��ʼʱ��
		String startDate = isrvmsg.getValue("startDate");
		// ����ʱ��
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
		}else{
			_endDate=currentDate;
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
		//�Ƿ������豸
		String ifproduction = isrvmsg.getValue("ifproduction");
		//Ĭ������
		if(StringUtils.isBlank(ifproduction)){
			ifproduction = "5110000186000000001";
		}
		StringBuilder sql = new StringBuilder(
				"select t.device_code,t.whl,t.sum_day_num,d.device_name,d.device_type,'"+currentDate+"' as cur_date from ( "
						+ " select dt.device_code,nvl(round(decode(sum(dh.sum_num),0,0,sum(dh.intact_num)*100 / sum(dh.sum_num)),2),0) as whl,"
						+ " sum(case when dh.his_date = to_date('" + hisDate + "','yyyy-mm-dd') then"
						+ " dh.sum_num else 0 end) as sum_day_num"
						+ " from dms_device_tree dt"
						+ " inner join gms_device_dailyhistory dh"
						+ " on dh.device_type = dt.device_code"
						+ " and dh.bsflag = '0'");
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dh.org_subjection_id='"+orgSubId+"'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and dh.country='"+vcountry+"'");
		}
		// �Ƿ������豸
		if(StringUtils.isNotBlank(ifproduction)){
			sql.append(" and dh.ifproduction = '" + ifproduction + "'");
		}
		// ��ʼʱ��
		sql.append(" and dh.his_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and dh.his_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" where dt.bsflag = '0' and dt.device_code is not null ");
		// tree����
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
	 * ��ȡ��ǰ���
	 * 
	 * @return
	 */
	public String getCurrentYear() {
		Calendar cal = Calendar.getInstance();
		Integer year = cal.get(Calendar.YEAR);
		return year.toString();
	}

	/**
	 * ��ȡ��ǰʱ��
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
	 * �Ƚ����ڴ�С
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
	
	/**OA�������ӵ�½
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg OAProcessList(ISrvMsg reqDTO) throws Exception{

		String loginId = reqDTO.getValue("loginId");
		String loginIp = reqDTO.getValue("loginIp");
		
		UserUtil userUtil = new UserUtil(); 
		UserToken user = userUtil.authUserBGPSFRZ(loginId, loginIp);
		user.setCharset(reqDTO.getValue("charset"));
		GMSUserUtil gmsUserUtil = new GMSUserUtil();
		gmsUserUtil.setUserProperty(user);
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("userToken", user);
		msg.setValue("funCodes", RoleUtil.getFunctionCodesByRoleIds(user.getRoleIds()));
		  
		Map userProfile = userUtil.queryUserProfile(user.getUserId());		
		if(userProfile!=null){
			msg.setValue("userProfile", userProfile);		
		}
		return msg;
	}
}
