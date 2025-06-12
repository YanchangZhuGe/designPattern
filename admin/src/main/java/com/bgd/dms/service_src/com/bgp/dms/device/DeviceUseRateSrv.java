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
public class DeviceUseRateSrv extends BaseService{
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	
	public DeviceUseRateSrv(){
		log = LogFactory.getLogger(DeviceUseRateSrv.class);
	}
	
	/**	
	 * �����Ҫ�豸������,�����ͼ����ʾ
	 * @return dateSets
	 */
	public ISrvMsg getUseRate(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// ��̽��
		String orgSubId = reqDTO.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		System.out.println("xxxxxxxxxxxxxxxxxx"+orgSubId);
		// ���ڹ���
		String country = reqDTO.getValue("country");
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
		String startDate = reqDTO.getValue("startDate");
		// ����ʱ��
		String endDate = reqDTO.getValue("endDate");
		//�����豸��ʶ
		String ifproduction  = reqDTO.getValue("ifproduction");
		//Ĭ������
		if(StringUtils.isBlank(ifproduction)){
			ifproduction = "5110000186000000001";
		}
		
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
		StringBuilder sql = new StringBuilder(
				"select t.*, d.device_name as label"
						+ " from (select substr(dt.dev_tree_id, 1, "+subStrLength+") dev_tree_id,"
						+ " round(nvl(decode(sum(dh.sum_num),0,0,sum(dh.use_num) / sum(dh.sum_num)),0),4)*100 as userate,"
						+ " sum(case when dh.his_date = to_date('" + hisDate + "','yyyy-mm-dd') then"
						+ " dh.sum_num else 0 end) as sum_day_num"
						+ " from dms_device_tree dt"
						+ " left join gms_device_dailyhistory dh"
						+ " on dh.device_type = dt.device_code"
						+ " and dh.bsflag = '0' and dh.account_stat='0110000013000000003' ");
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dh.org_subjection_id like '"+orgSubId+"%' ");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(vcountry)){
			sql.append(" and dh.country='"+vcountry+"' ");
		}
		//�Ƿ������豸
		if(StringUtils.isNotBlank(ifproduction)){
			sql.append(" and dh.ifproduction ='"+ifproduction+"' ");
		}
		// ��ʼʱ��
		sql.append(" and dh.his_date>=to_date('" + _startDate + "','yyyy-mm-dd') ");
		// ����ʱ��
		sql.append(" and dh.his_date<=to_date('" + _endDate + "','yyyy-mm-dd') ");
		sql.append(" where dt.bsflag = '0'");
		// tree����
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%' and dt.dev_tree_id <> '" + devTreeId + "'");
		}
		sql.append(" group by substr(dt.dev_tree_id, 1, "+subStrLength+")) t left join dms_device_tree d on t.dev_tree_id = d.dev_tree_id where sum_day_num>0 order by d.code_order");
		log.info(sql);
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
		root.addAttribute("numbersuffix", "%");

		int cLevel=Integer.parseInt(level);//��ǰ��ȡ����
		int nLevel=cLevel+1;//��һ��ȡ����
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String sumDayNum=map.get("sum_day_num").toString();//��ǰ��������
				String cdevTreeId=map.get("dev_tree_id").toString();//��ǰdev_tree_id����
				String value = "0";//Ĭ�������
				if(cdevTreeId.startsWith("D001")||cdevTreeId.startsWith("D005")){
					sumDayNum+="��";
				}
				if(cdevTreeId.startsWith("D002")||cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
					sumDayNum+="̨";
				}
				set.addAttribute("label", map.get("label").toString()+"("+sumDayNum+")");
				if(null!=map.get("userate") && !"0".equals(map.get("userate").toString())){
					value=map.get("userate").toString();
					//��������������ֻ��ȡ��һ��
					if(cdevTreeId.startsWith("D001")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"','"+ifproduction+"')");
						}
					}
					//�첨��������ֻ��ȡ������
					if(cdevTreeId.startsWith("D005")){
						// �첨�� ���¼첨����������ȡ
						if(cdevTreeId.startsWith("D005003")){
							if(cLevel<=1){
								set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"','"+ifproduction+"')");
							}
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"','"+ifproduction+"')");
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
								set.addAttribute("link", "JavaScript:popNextLevelUseRate('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"','"+_startDate+"','"+_endDate+"','"+ifproduction+"')");
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
		String ifproduction = isrvmsg.getValue("ifproduction");// �Ƿ������豸
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
		StringBuilder sql = new StringBuilder(
				"select t.device_code,t.userate,t.sum_day_num,d.device_name,d.device_type, cur_date from ( "
						+ " select dt.device_code,nvl(round(decode(sum(dh.sum_num),0,0,sum(dh.use_num)*100 / sum(dh.sum_num)),2),0) as userate,"
						+ " sum(case when dh.his_date = to_date('" + hisDate + "','yyyy-mm-dd') then"
						+ " dh.sum_num else 0 end) as sum_day_num,max(dh.his_date) as cur_date"
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
		// ��ʼʱ��
		sql.append(" and dh.his_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and dh.his_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append(" where dt.bsflag = '0' and dt.device_code is not null ");
		// tree����
		if(StringUtils.isNotBlank(devTreeId)){
			sql.append(" and dt.dev_tree_id like '" + devTreeId + "%'");
		}
		//�Ƿ������豸
		if(StringUtils.isNotBlank(ifproduction)){
			sql.append(" and dh.ifproduction='"+ifproduction+"'");
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
	 * ��ȡ�豸3-5�����������
	 * @return
	 */
	public ISrvMsg getYearUseRateNew(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		//��̽��
		String orgSubId = reqDTO.getValue("orgSubId");
		//�豸���� 
		String devTypeId = reqDTO.getValue("dev_type_id");
		//�Ƿ������豸
		String prFlag = reqDTO.getValue("prFlag");
		//��ʾ���
		Integer yearNum = 1;//Ĭ����ʾ����
		
		//x��lebel
		String[] xLableArr = new String[]{"01","02","03","04","05","06","07","08","09","10","11","12"};
		
		String yearinfo = reqDTO.getValue("yearinfo");
		String year = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
		//3��
	    if("3".equals(yearinfo)){
			yearNum = 3;
		}
		//5��
		else if("5".equals(yearinfo)){
			yearNum = 5;
		}
		
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("numbersuffix", "%");
		root.addAttribute("xAxisName","�·�");
		
		//x��
		Element categories = root.addElement("categories");
		for(int i = 0 ; i<xLableArr.length;i++){
			Element category = categories.addElement("category");
			category.addAttribute("label", xLableArr[i]);
		}
		
		for(int i = 0 ; i < yearNum; i++){
			//��ȡ3-5���������(��ǰ����ǰ��)
			if(i>0){
				year = String.valueOf(Integer.parseInt(year)-1) ; 
			}
			String[] nodetypes = new String[]{year+"-01",year+"-02",year+"-03",year+"-04",year+"-05",
					year+"-06",year+"-07",year+"-08",year+"-09",year+"-10",year+"-11",year+"-12"};
			
			StringBuffer sb = new StringBuffer();
			for(int j = 0;j<nodetypes.length;j++){
				if(j>0){
					sb.append(" union all ");
				}
				sb.append("select his_date,sum(use_num) as use_num,sum(sum_num) as sum_num,round(avg(userate),2) as userate from ( ")
				  .append("select his_date,sum(tt.use_num) as use_num,tt.device_type,sum(tt.sum_num) as sum_num , ")
				  .append("round(decode(sum(tt.sum_num),0,0,sum(tt.use_num)/sum(tt.sum_num))*100,2) as userate ")
				  .append(" from (select dd.his_date,nvl(sum_num,0) as sum_num,nvl(use_num,0) as use_num,substr(dt.dev_tree_id,1,4) as device_type from ")
				  .append("(select '").append(nodetypes[j]).append("' as his_date from dual) dd left join gms_device_dailyhistory t  on t.bsflag='0' ")
				  .append("and t.account_stat='0110000013000000003' and to_char(t.his_date,'yyyy-MM') = '").append(nodetypes[j]).append("' ");
				  //��֯����
				  if(StringUtils.isNotBlank(orgSubId)){
					  sb.append("and t.org_subjection_id like '").append(orgSubId).append("%' ");
				  }
				 //�Ƿ������豸
				  if(StringUtils.isNotBlank(prFlag)){
					  sb.append("and t.ifproduction = '").append(prFlag).append("' ");
				  }
				  
				  sb.append(" left join dms_device_tree dt on t.device_type = dt.device_code  ");
				  //��֯��ID
				  if(StringUtils.isNotBlank(devTypeId)){
					  sb.append("and dt.dev_tree_id like '").append(devTypeId).append("%'");					  
				  }
				  sb.append(") tt group by his_date,tt.device_type) ttt group by ttt.his_date ");
			}
			
			List<Map> list = jdbcDao.queryRecords(sb.toString());
			
			sb.setLength(0);
				
			//dataset
			Element dataset = root.addElement("dataset");
			dataset.addAttribute("seriesName",year);
			for(Map map : list){
				Element set = dataset.addElement("set");
				set.addAttribute("value",map.get("userate").toString());	
			}
			
		}
		
	
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * ��ȡ�豸3-5�����������
	 * @return
	 */
	public ISrvMsg getYearUseRate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		// ��̽��
		String orgSubId = reqDTO.getValue("orgSubId");
		//��ȡ�㼶
		String level = reqDTO.getValue("level");
		//��ȡ�·�
		String date = reqDTO.getValue("date");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="C105";
		}	
		
		StringBuffer sb = new StringBuffer();
		sb.append("select i.org_abbreviation from comm_org_information i left join comm_org_subjection s on i.org_id = s.org_id ")
		  .append("where i.bsflag ='0' and s.bsflag='0' and s.org_subjection_id = '").append(orgSubId).append("'");
		
		Map tempMap = jdbcDao.queryRecordBySQL(sb.toString());
		String orgName = "";//��֯��������<����ͼ��ͼ��������ʾ>
		
		if(tempMap != null){
			orgName = tempMap.get("org_abbreviation").toString();
		}
		
		sb.setLength(0);//���StringBuffer
		
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "1");
		
		root.addAttribute("numbersuffix", "%");
		
		String fromatDate = "";
		//���ײ�ʱ<��ʾ���>
		if(level==null || "1".equals(level)){
			fromatDate = "yyyy";
			root.addAttribute("xAxisName","���");
		}
		//�ڶ�����ȡ��ʾ�·�
		else if("2".equals(level)){
			fromatDate = "yyyy-MM";
			root.addAttribute("xAxisName","�·�");
		}
		//��������ȡ��ʾ����
		else if("3".equals(level)){
			fromatDate = "yyyy-MM-dd";
			root.addAttribute("xAxisName","����");
		}
		
		sb.append("select his_date,sum(tt.use_num) as use_num,sum(tt.sum_num) as sum_num ,round(decode(sum(tt.sum_num),0,0,sum(tt.use_num)/sum(tt.sum_num))*100,2) as userate from ( ")
		  .append("select to_char(t.his_date,'").append(fromatDate).append("') as  his_date,sum_num,use_num from ")
		  .append("gms_device_dailyhistory t ")
		  .append("where t.bsflag='0' ");
		
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId) && !"C105".equals(orgSubId)){
			sb.append(" and t.org_subjection_id='"+orgSubId+"'");
		}
		//�ڶ����굽�·�
		if("2".equals(level)){
			sb.append("and substr(to_char(t.his_date,'yyyy-mm-dd'),0,4)='").append(date).append("' ");
		}
		//�������굽��ϸ����<ѡ���·ݵ�һ�쵽���һ��>
		if("3".equals(level)){
			sb.append("and t.his_date between to_date(to_char('").append(date).append("')||'-01','yyyy-MM-dd') ")
			  .append("and last_day(to_date(to_char('").append(date).append("')||'-01','yyyy-MM-dd')) ");
		}

		sb.append(") tt group by his_date ")
		  .append("order by his_date ");
		
		List<Map> list = jdbcDao.queryRecords(sb.toString());
		
		if(CollectionUtils.isNotEmpty(list)){
			Element categories = root.addElement("categories");
			//x��
		    for (Map map:list) {
		    	Element category = categories.addElement("category");
		    	category.addAttribute("label",map.get("his_date").toString());
		    }
		    //��״ͼ
		    Element dataset1 = root.addElement("dataset");
			dataset1.addAttribute("seriesName", orgName);
		    for (Map map:list) {
				Element set = dataset1.addElement("set");
				set.addAttribute("value",  map.get("userate").toString());
				set.addAttribute("displayValue", map.get("use_num").toString()+"/"+ map.get("sum_num").toString()+","+map.get("userate").toString()+"%");
				if(level==null || "1".equals(level)){
					set.addAttribute("link", "JavaScript:popNextTwoLevelYearUseRate('"+orgSubId+"','"+map.get("his_date").toString()+"')");
				}else if("2".equals(level)){
					set.addAttribute("link", "JavaScript:popNextThirdLevelYearUseRate('"+orgSubId+"','"+map.get("his_date").toString()+"')");
				}
		    }
		    //����ͼ
		    Element dataset2 = root.addElement("dataset");
			dataset2.addAttribute("seriesName", orgName);
			dataset2.addAttribute("renderAs", "Line");
			 for (Map map:list) {
				Element set = dataset2.addElement("set");
				set.addAttribute("value",  map.get("userate").toString());
				set.addAttribute("displayValue"," ");
			 }

		}
		
		
		responseDTO.setValue("Str", document.asXML());
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
	 * ��û�����Ҫ�豸�����ʶԱ�,�����ͼ����ʾ
	 * @return dateSets
	 */
	public ISrvMsg getUseRateNew(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// �豸����
		String dev_type_id = reqDTO.getValue("dev_type_id");
		 
		//�����豸��ʶ
		String prFlag  = reqDTO.getValue("prFlag");
		//�ж� ͬ�ȣ�����
		String flag=reqDTO.getValue("flag");
		
		//Ĭ������
		if(StringUtils.isBlank(prFlag)){
			prFlag = "5110000186000000001";
			}
		
		// ��ʼʱ��
		String startDate = reqDTO.getValue("startDate");
		
		String sql1="with ";
				if(StringUtils.isNotBlank(startDate)){
					  sql1+=" djz as  (select to_number(to_char(to_date('"+startDate+"','yyyy-MM-dd'),'ww')) djz from dual),";
				}else{
					  sql1+=" djz as  (select to_number(to_char((select  trunc(sysdate,'iw')-10 from dual),'ww')) djz from dual),";
				}

  sql1+=" result1 as ("
 +" select trunc(sysdate, 'yyyy') - to_char(trunc(sysdate, 'yyyy'), 'd') - 1 +"
 +"       (select * from djz) * 7 startweek,"
 +"       trunc(sysdate, 'yyyy') - to_char(trunc(sysdate, 'yyyy'), 'd') + 5 +"
 +"       (select * from djz) * 7 as endweek"
 +"  from dual"
 +"  union all "
 +"  select trunc(add_months(sysdate,-12), 'yyyy') - to_char(trunc(add_months(sysdate,-12), 'yyyy'), 'd') - 1 +"
 +"       (select * from djz) * 7 startweek,"
 +"       trunc(add_months(sysdate,-12), 'yyyy') - to_char(trunc(add_months(sysdate,-12), 'yyyy'), 'd') + 5 +"
 +"       (select * from djz) * 7 as endweek"
 +"  from dual),"
 +"  result2 as ("
 +" select trunc(sysdate, 'yyyy') - to_char(trunc(sysdate, 'yyyy'), 'd') - 1 +"
 +"       (select * from djz) * 7 startweek,"
 +"       trunc(sysdate, 'yyyy') - to_char(trunc(sysdate, 'yyyy'), 'd') + 5 +"
 +"       (select * from djz) * 7 as endweek"
 +"  from dual"
 +"  union all "
 +"  select trunc(sysdate, 'yyyy') - to_char(trunc(sysdate, 'yyyy'), 'd') - 1 +"
  +"      (select djz-4 from djz) * 7 startweek,"
  +"      trunc(sysdate, 'yyyy') - to_char(trunc(sysdate, 'yyyy'), 'd') + 5 +"
  +"      (select djz-4 from djz) * 7 as endweek"
 +"  from dual) ";
		if("hb".equals(flag)){
			sql1+="select * from result2" ;	
		}else{
			
			sql1+="select * from result1" ;	
		}
		List<Map> list1=jdbcDao.queryRecords(sql1.toString());
		Map map0=list1.get(0);
		Map map1=list1.get(1);
		
		StringBuilder sql = new StringBuilder(
				"select '"+map0.get("startweek")+"~"+map0.get("endweek")+"' label,"
						+ "  trunc(nvl(decode(sum(dh.sum_num),0,0,sum(dh.use_num) / sum(dh.sum_num)),0)*100,2)  as userate "
						+ " from gms_device_dailyhistory dh left join comm_org_subjection s on s.org_subjection_id = dh.org_subjection_id "
						+"  left join comm_org_information i on i.org_id = s.org_id"
						+"  where  1=1");
		// �豸���
		if(StringUtils.isNotBlank(dev_type_id)){
			sql.append(" and dh.device_type  in  " +
					" (select tree.device_code from dms_device_tree tree where tree.device_code is not null and" +
					" tree.dev_tree_id like '"+dev_type_id+"%')"); 
		}
		//�Ƿ������豸
			sql.append(" and dh.ifproduction ='"+prFlag+"' ");
		// ��ʼʱ��
		sql.append(" and dh.his_date>=to_date('" + map0.get("startweek") + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and dh.his_date<=to_date('" + map0.get("endweek") + "','yyyy-mm-dd')");
		
		sql.append("union all select '"+map1.get("startweek")+"~"+map1.get("endweek")+"' label,"
						+ "  trunc(nvl(decode(sum(dh.sum_num),0,0,sum(dh.use_num) / sum(dh.sum_num)),0)*100,2)  as userate "
						+ " from gms_device_dailyhistory dh left join comm_org_subjection s on s.org_subjection_id = dh.org_subjection_id "
						+"  left join comm_org_information i on i.org_id = s.org_id"
						+"  where  1=1");
		// �豸���
				if(StringUtils.isNotBlank(dev_type_id)){
					sql.append(" and dh.device_type  in  " +
							" (select tree.device_code from dms_device_tree tree where tree.device_code is not null and" +
							" tree.dev_tree_id like '"+dev_type_id+"%')"); 
				}
		//�Ƿ������豸
		sql.append(" and dh.ifproduction ='"+prFlag+"' ");
		// ��ʼʱ��
		sql.append(" and dh.his_date>=to_date('" + map1.get("startweek") + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and dh.his_date<=to_date('" + map1.get("endweek") + "','yyyy-mm-dd')");
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
		root.addAttribute("unescapeLinks", "0");
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String value = "0";//Ĭ�������
				set.addAttribute("label", map.get("label").toString());
				if(null!=map.get("userate") && !"0".equals(map.get("userate").toString())){
					value=map.get("userate").toString();
				set.addAttribute("value", value);
				set.addAttribute("displayValue", value+"%");
				set.addAttribute("toolText", map.get("label").toString()+","+value+"%");
		}
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**	
	 * ��û�����Ҫ�豸�����ʶԱ�,�����ͼ����ʾ
	 * @return dateSets
	 */
	public ISrvMsg getUseRateForOrg(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		//��ȡ��ǰ���
		String currentYear=getCurrentYear();
		//��ȡ��ǰʱ��
		String currentDate=getCurrentDate();
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// �豸����
		String dev_type_id = reqDTO.getValue("dev_type_id");
		if(StringUtils.isBlank(dev_type_id)){
			dev_type_id="";
		}
		String country=reqDTO.getValue("country");
		String vcountry="";
		if(StringUtils.isNotBlank(country)){
			if("1".equals(country)){
				vcountry="����";
			}
			if("2".equals(country)){
				vcountry="����";			
			}
		}
		//�����豸��ʶ
		String prFlag  = reqDTO.getValue("prFlag");
		// ��ʼʱ��
		String startDate = reqDTO.getValue("startDate");
		// ����ʱ��
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
		StringBuilder sql = new StringBuilder("select orgsubidtoname(org_subjection_id) label,"
		+ " userate from(select OrgSubIdToshortid(dh.org_subjection_id) org_subjection_id,"
		+ " trunc(nvl(decode(sum(dh.sum_num), 0, 0, sum(dh.use_num) / sum(dh.sum_num)), 0) * 100, 2) as userate"
		+ " from gms_device_dailyhistory dh"
		+ " left join comm_org_subjection s on s.org_subjection_id = dh.org_subjection_id and s.bsflag = '0'"
		+ " left join comm_org_information i on i.org_id = s.org_id and i.bsflag = '0'"
		+ " where dh.account_stat = '0110000013000000003' and (dh.org_subjection_id like 'C105002%' or"
		+ " dh.org_subjection_id like 'C105001005%' or dh.org_subjection_id like 'C105001002%' or"
		+ " dh.org_subjection_id like 'C105001003%' or dh.org_subjection_id like 'C105001004%' or"
		+ " dh.org_subjection_id like 'C105005004%' or dh.org_subjection_id like 'C105005000%' or"
		+ " dh.org_subjection_id like 'C105005001%' or dh.org_subjection_id like 'C105007%' or"
		+ " dh.org_subjection_id like 'C105063%' or dh.org_subjection_id like 'C105087%' or"
		+ " dh.org_subjection_id like 'C105092%' or dh.org_subjection_id like 'C105093%' or"
		+ " dh.org_subjection_id like 'C105006%')");
				
		// �豸���
		if(StringUtils.isNotBlank(dev_type_id)){
			sql.append(" and dh.device_type in " 
					+ " (select tree.device_code from dms_device_tree tree"
					+ " where tree.device_code is not null"
					+ " and tree.dev_tree_id like '"+dev_type_id+"%')"); 
		}
		
		//�Ƿ������豸
		if(StringUtils.isNotBlank(prFlag)){
			sql.append(" and dh.ifproduction ='"+prFlag+"' ");
		} 
		//���ڹ���
		if(StringUtils.isNotBlank(country)){
			sql.append("and dh.country='"+vcountry+"'");
		}
		// ��ʼʱ��
		sql.append(" and dh.his_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and dh.his_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append("  group by OrgSubIdToshortid(dh.org_subjection_id)) ");
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
		root.addAttribute("unescapeLinks", "0");
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String value = "0";//Ĭ�������
				set.addAttribute("label", map.get("label").toString());
				if(null!=map.get("userate") && !"0".equals(map.get("userate").toString())){
					value=map.get("userate").toString();
				set.addAttribute("value", value);
				set.addAttribute("displayValue", value+"%");
				set.addAttribute("toolText", map.get("label").toString()+","+value+"%");
		}
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**	
	 * ����豸��Դ�أ���̨��,�����ͼ����ʾ
	 * @return dateSets
	 */
	public ISrvMsg getDeviceLieOne(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if(StringUtils.isBlank(level)){
			level = "1";
		}
		//��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength = 1 + Integer.parseInt(level)*3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// �豸����
		String orgSubId = reqDTO.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId = "";
		}
		// ���ڹ���
		String country = reqDTO.getValue("country");
		String vcountry = "";
		if(StringUtils.isBlank(country)){
			country = "";
		}else{
			if("1".equals(country)){
				vcountry = "����";
			}
			if("2".equals(country)){
				vcountry = "����";			
			}
		}
	
		StringBuilder sql = new StringBuilder();
			sql.append(	"select replace( i.org_abbreviation,'��̽��','') as lable,s.org_subjection_id,"
						+ " count(dh.dev_acc_id) as sum_day_num, sum(dh.ifunused) as userate from (select"
						+ " t.dev_acc_id,t.ifcountry,t.ifunused,t.Dev_Type, t.using_stat,"
						+ " ( case when (t.owning_sub_id like 'C105001%' or t.owning_sub_id like 'C105005%')"
						+ " then substr(t.owning_sub_id, 0, 10) else substr(t.owning_sub_id, 0, 7) end ) as owning_sub_id"
						+ " from gms_device_account t"
						+ " where t.ifproduction = '5110000186000000001' and t.account_stat != '0110000013000000005') dh"
						+ " left join comm_org_subjection s on s.org_subjection_id = dh.owning_sub_id"
						+ " left join comm_org_information i on i.org_id = s.org_id  where"
						+ " (dh.owning_sub_id like 'C105002%' or dh.owning_sub_id like 'C105001005%' or"
						+ " dh.owning_sub_id like 'C105001002%' or dh.owning_sub_id like 'C105001003%' or"
						+ " dh.owning_sub_id like 'C105001004%' or dh.owning_sub_id like 'C105005004%' or"
						+ " dh.owning_sub_id like 'C105005000%' or dh.owning_sub_id like 'C105005001%' or"
						+ " dh.owning_sub_id like 'C105007%' or dh.owning_sub_id like 'C105063%' or"
						+ " dh.owning_sub_id like 'C105086%' or dh.owning_sub_id like 'C105006%')"
						+ " and dh.dev_type in (select tree.device_code from dms_device_tree tree"
						+ " where tree.dev_tree_id like 'D003%' OR tree.dev_tree_id like 'D004%'"
						+ " or  tree.dev_tree_id like 'D006%' ) ");
								
						// ���ڹ���
						if(StringUtils.isNotBlank(country)){
							sql.append(" and dh.ifcountry='"+vcountry+"'");
						}
						//�豸����
						if(StringUtils.isNotBlank(devTreeId)){
							String types[]=devTreeId.split(",");	
							sql.append("and (");
							for(int i=0;i<types.length;i++){
								if(i==0){
									sql.append(" dh.dev_type in (select tree.device_code from dms_device_tree tree where tree.dev_tree_id like '"+types[i]+"%')");
								}else{
									sql.append(" or dh.Dev_Type in (select tree.device_code from dms_device_tree tree where tree.dev_tree_id like '"+types[i]+"%')");
								}
							}
							sql.append(")");
						}
						sql.append(" and dh.using_stat='0110000007000000002' group by dh.owning_sub_id, i.org_abbreviation, i.org_name,s.org_subjection_id  order by dh.owning_sub_id ");
			
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("yAxisName", "��������");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("unescapeLinks", "0");
		int cLevel = Integer.parseInt(level);//��ǰ��ȡ����
		int nLevel = cLevel + 1;//��һ��ȡ����
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String sumDayNum=map.get("sum_day_num").toString();//��ǰ��������
				String orgSubIds=map.get("org_subjection_id").toString();//��ǰ����ID
				String value = "0";//Ĭ�������
				set.addAttribute("label", map.get("lable").toString()+"("+sumDayNum+")");
				if(null!=map.get("userate") && !"0".equals(map.get("userate").toString())){
					value=map.get("userate").toString();
						// �����豸 �����������䳵,ֱ��չ���б�����
					set.addAttribute("link", "JavaScript:popDevList('"+devTreeId+"','"+orgSubIds+"','"+country+"')");
					set.addAttribute("value", value);	
				}
				
		    }
		}
		
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**	
	 * ����豸������ȡ��Դ��,�����ͼ����ʾ
	 * @return dateSets
	 */
	public ISrvMsg getSecondJBQLie(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// ��̽��
		String orgSubId = reqDTO.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ���ڹ���
		String country = reqDTO.getValue("country");
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
		StringBuilder sql = new StringBuilder();

						if(StringUtils.isNotBlank(devTreeId))
						{
							sql.append(	"select t.*, d.device_name as label  from (select substr(dt.dev_tree_id, 1, 10) dev_tree_id,sum(tt.total_num) as sum_day_num,"
									+ " sum(tt.unuse_num) as userate  from dms_device_tree dt "
									+ "   left join ( SELECT acc.dev_name,acc.dev_model,ci.dev_code,acc.unuse_num,acc.total_num,acc.ifcountry, acc.owning_sub_id FROM"
									+ "   gms_device_coll_account acc  left join gms_device_collectinfo ci on acc.device_id = ci.device_id  ) tt  on tt.dev_code=dt.device_code ");
							sql.append("   where dt.bsflag = '0'  and dt.dev_tree_id like '"+devTreeId+"%' and dt.dev_tree_id <> '"+devTreeId+"' " );

						}
						else
						{
							sql.append(	"select t.*, d.device_name as label  from (select substr(dt.dev_tree_id, 1, 7) dev_tree_id,sum(tt.total_num) as sum_day_num,"
									+ " sum(tt.unuse_num) as userate  from dms_device_tree dt "
									+ "   left join ( SELECT acc.dev_name,acc.dev_model,ci.dev_code,acc.unuse_num,acc.total_num,acc.ifcountry, acc.owning_sub_id FROM"
									+ "   gms_device_coll_account acc  left join gms_device_collectinfo ci on acc.device_id = ci.device_id  ) tt  on tt.dev_code=dt.device_code ");
							sql.append("   where dt.bsflag = '0'  and dt.dev_tree_id like 'D005%' and dt.dev_tree_id <> 'D005' " );

						}
						// ���ڹ���
						if(StringUtils.isNotBlank(country)){
								sql.append(" and tt.ifcountry='"+vcountry+"'");
						}
						// ��̽��
						if(StringUtils.isNotBlank(orgSubId)){
							sql.append(" and tt.owning_sub_id like '"+orgSubId+"%'");
						}
						
						if(StringUtils.isNotBlank(devTreeId))
						{
							sql.append("  group by substr(dt.dev_tree_id, 1, 10)) t  left join dms_device_tree d on t.dev_tree_id = d.dev_tree_id  order by d.code_order");
						}
						else
						{
							sql.append("  group by substr(dt.dev_tree_id, 1, 7)) t  left join dms_device_tree d on t.dev_tree_id = d.dev_tree_id  order by d.code_order");

						}
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
		root.addAttribute("unescapeLinks", "0");
		int cLevel=Integer.parseInt(level);//��ǰ��ȡ����
		int nLevel=cLevel+1;//��һ��ȡ����
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String sumDayNum=map.get("sum_day_num").toString();//��ǰ��������
				String cdevTreeId=map.get("dev_tree_id").toString();//��ǰdev_tree_id����
				String value = "0";//Ĭ�������
				if(cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
					sumDayNum+="̨";
				}
				if(cdevTreeId.startsWith("D006")){
					sumDayNum+="��";
				}
				if(cdevTreeId.startsWith("D005")){
					sumDayNum+="��";
				}
				set.addAttribute("label", map.get("label").toString()+"("+sumDayNum+")");
				if(null!=map.get("userate") && !"0".equals(map.get("userate").toString())){
					value=map.get("userate").toString();
				
					//�첨��������ֻ��ȡ������
					if(cdevTreeId.startsWith("D005")){
							if(cLevel<2){
								if(cdevTreeId.startsWith("D005003"))
										{
								set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"')");
										}
								else{
								set.addAttribute("link", "JavaScript:popNextLevelLie('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"')");
								}
							}
							else
							{
								set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"')");

							}
					}
					set.addAttribute("value", value);	
				}
				
		    }
		}
		
		
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**	
	 * ������̽���鿴�豸��Դ�����,�����ͼ����ʾ
	 * @return dateSets
	 */
	public ISrvMsg fourLevelJBQLie(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// ��̽��
		String orgSubId = reqDTO.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ���ڹ���
		String country = reqDTO.getValue("country");
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
		
		StringBuilder sql = new StringBuilder();
						
							sql.append(	"select i.org_abbreviation as lable, sum(dh.total_num) as sum_day_num,sum(dh.unuse_num) as userate"
									+ "  from (SELECT acc.dev_name, acc.dev_model, ci.dev_code,   acc.unuse_num,   acc.total_num, acc.ifcountry,acc.device_id, "
									+ "   case when (acc.owning_sub_id like 'C105001%' or    acc.owning_sub_id like 'C105005%') then    substr(acc.owning_sub_id, 0, 10)"
									+ "   else   substr(acc.owning_sub_id, 0, 7)    end as owning_sub_id    FROM gms_device_coll_account acc  ");
							sql.append("  left join gms_device_collectinfo ci on acc.device_id =  ci.device_id)  dh  left join comm_org_subjection s on s.org_subjection_id =    dh.owning_sub_id   left join comm_org_information i on i.org_id = s.org_id  where 1=1 " );

						// ���ڹ���
						if(StringUtils.isNotBlank(country)){
								sql.append(" and dh.ifcountry='"+vcountry+"'");
						}
						// ��̽��
						if(StringUtils.isNotBlank(orgSubId)){
							sql.append(" and dh.owning_sub_id like '"+orgSubId+"%'");
						}
						//�豸����
						if(StringUtils.isNotBlank(devTreeId)){
							sql.append(" AND  DH.dev_code in (select TREE.DEVICE_CODE from dms_device_tree tree where tree.dev_tree_id like '"+devTreeId+"%')");
						}
						
						sql.append(" group by dh.owning_sub_id, i.org_abbreviation,i.org_name  order by dh.owning_sub_id ");

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
		root.addAttribute("unescapeLinks", "0");
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String sumDayNum=map.get("sum_day_num").toString();//��ǰ��������
				String value = "0";//Ĭ��ֵ
				
				set.addAttribute("label", map.get("lable").toString()+"("+sumDayNum+")");
				if(null!=map.get("userate") && !"0".equals(map.get("userate").toString())){
					value=map.get("userate").toString();
					set.addAttribute("value", value);	
				}
				
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
	public ISrvMsg queryDevLieForttjList(ISrvMsg isrvmsg) throws Exception {
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
		StringBuilder sql = new StringBuilder(
				"select tree.device_code,T.DEV_NAME,T.DEV_MODEL,sum(t.ifunused) as uusecount,count(1) sumcount from gms_device_account t   "
						+ " left join dms_device_tree tree on tree.Device_Code=t.dev_type");
	
		if(StringUtils.isNotBlank(devTreeId))
		{
			sql.append( " where tree.dev_tree_id like '"+devTreeId+"%'  ");
		}
						
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and T.OWNING_SUB_ID   LIKE '"+orgSubId+"%'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(country)){
			sql.append(" and T.IFCOUNTRY='"+vcountry+"'");
		}
		sql.append("  and t.ifproduction='5110000186000000001' and t.account_stat !='0110000013000000005' ");
		
		sql.append(" GROUP BY T.DEV_TYPE,T.DEV_NAME,T.DEV_MODEL,tree.device_code ");
		

		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ�豸��Ϣ�����б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevLieInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryDevLieInfoList");
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
		StringBuilder sql = new StringBuilder(
				" select t.dev_name,t.dev_model,t.dev_sign,t.producting_date,(select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=t.tech_stat) as tech_stat,(select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=t.using_stat) as using_stat,(select d.coding_name from comm_coding_sort_detail d where d.coding_code_id=t.account_stat) as account_stat,t.dev_position,f.org_name  from gms_device_account t    "
						+ "  left join comm_coding_sort_detail d on d.coding_code_id=t.asset_stat");
	
		sql.append(" left join comm_org_information f on f.org_id=t.owning_org_id where t.ifunused='1' and t.ifproduction='5110000186000000001' and t.using_stat='0110000007000000002' and t.account_stat !='0110000013000000005' ");
		
		if(StringUtils.isNotBlank(devTreeId))
		{
			sql.append( " and t.dev_type like '"+devTreeId+"%'  ");
		}
						
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and T.OWNING_SUB_ID   LIKE '"+orgSubId+"%'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(country)){
			sql.append(" and T.IFCOUNTRY='"+vcountry+"'");
		}
		sql.append(" and t.using_stat='0110000007000000002' ");
		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**	
	 * ����豸��Դ��,�����ͼ����ʾ
	 * @return dateSets
	 */
	public ISrvMsg getDeviceLie(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// ����(Ĭ��Ϊ��һ��)
		String level = reqDTO.getValue("level");
		if(StringUtils.isBlank(level)){
			level="1";
		}
		//��ȡ����(���������ÿ�����볤�ȼ�3)
		int subStrLength=1+Integer.parseInt(level)*3;
		// tree����(Ĭ��Ϊ�գ�����Ϊ��һ��)
		String devTreeId = reqDTO.getValue("devTreeId");
		// ��̽��
		String orgSubId = reqDTO.getValue("orgSubId");
		if(StringUtils.isBlank(orgSubId)){
			orgSubId="";
		}
		// ���ڹ���
		String country = reqDTO.getValue("country");
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
	
	
		StringBuilder sql = new StringBuilder();
			if(StringUtils.isNotBlank(devTreeId)){
				if(level.equals("3"))
				{
					sql.append(	"select t.*, d.device_name as label"
							+ " from (select substr(dt.dev_tree_id, 1, 10) dev_tree_id,"
							+ "  sum(dh.ifunused) as userate,count(dh.dev_acc_id) as sum_day_num"
							+ "  from dms_device_tree dt left join gms_device_account dh on dh.dev_type =dt.device_code  and dh.bsflag = '0' ");
				}else{
				sql.append(	"select t.*, d.device_name as label"
						+ " from (select substr(dt.dev_tree_id, 1, 7) dev_tree_id,"
						+ "  sum(dh.ifunused) as userate,count(dh.dev_acc_id) as sum_day_num"
						+ "  from dms_device_tree dt left join gms_device_account dh on dh.dev_type =dt.device_code  and dh.bsflag = '0' ");
				}	
				}	
					else
					{
				sql.append(	"select t.*, d.device_name as label"
						+ " from (select substr(dt.dev_tree_id, 1, 4) dev_tree_id,"
						+ "  sum(dh.ifunused) as userate,count(dh.dev_acc_id) as sum_day_num"
						+ "  from dms_device_tree dt left join gms_device_account dh on dh.dev_type =dt.device_code  and dh.bsflag = '0' ");
					}
			
					sql.append("  where dt.bsflag = '0' " );
						// ���ڹ���
						if(StringUtils.isNotBlank(country)){
								sql.append(" and dh.ifcountry='"+vcountry+"'");
						}
						// ��̽��
						if(StringUtils.isNotBlank(orgSubId)){
							sql.append(" and dh.owning_sub_id like '"+orgSubId+"%'");
						}
						sql.append(" and dh.ifproduction='5110000186000000001' and dh.account_stat !='0110000013000000005' ");
		
		// tree����
		if(StringUtils.isNotBlank(devTreeId)){
			if(level.equals("3"))
			{
				sql.append(" group by substr(dt.dev_tree_id, 1, 10)) t left join dms_device_tree d on t.dev_tree_id = d.dev_tree_id ");
				sql.append(" where d.dev_tree_id like '" + devTreeId + "%' and d.dev_tree_id <> '" + devTreeId + "'");
			}
			else{
			sql.append(" group by substr(dt.dev_tree_id, 1, 7)) t left join dms_device_tree d on t.dev_tree_id = d.dev_tree_id ");
			sql.append(" where d.dev_tree_id like '" + devTreeId + "%' and d.dev_tree_id <> '" + devTreeId + "'");}
		}
		else
		{
			sql.append(" group by substr(dt.dev_tree_id, 1, 4)) t left join dms_device_tree d on t.dev_tree_id = d.dev_tree_id ");
			sql.append("  WHERE t.dev_tree_id in ('D003','D004','D006')");
		}
		sql.append("  order by d.code_order");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("showValues", "1");
		root.addAttribute("decimals", "2");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("palette", "4");
		root.addAttribute("yAxisName", "��������");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("unescapeLinks", "0");
		int cLevel=Integer.parseInt(level);//��ǰ��ȡ����
		int nLevel=cLevel+1;//��һ��ȡ����
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String sumDayNum=map.get("sum_day_num").toString();//��ǰ��������
				String cdevTreeId=map.get("dev_tree_id").toString();//��ǰdev_tree_id����
				String value = "0";//Ĭ�������
				if(cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
					sumDayNum+="̨";
				}
				if(cdevTreeId.startsWith("D006")){
					sumDayNum+="��";
				}
				set.addAttribute("label", map.get("label").toString()+"("+sumDayNum+")");
				if(null!=map.get("userate") && !"0".equals(map.get("userate").toString())){
					value=map.get("userate").toString();
					
					//�ɿ���Դ,���,�����豸,�����ʾ��ϸ��Ϣ
					if(cdevTreeId.startsWith("D003")||cdevTreeId.startsWith("D004")){
						// �����豸 �����������䳵,ֱ��չ���б�����
						if(cdevTreeId.startsWith("D004003")){
							set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"')");
						}else{
							if(cLevel<=2){
								set.addAttribute("link", "JavaScript:popNextLevelLie('"+nLevel+"','"+cdevTreeId+"','"+orgSubId+"','"+country+"')");
							}else{
								set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"')");
							}
						}
					}
					//������������ֻ��ȡ��һ��
					if(cdevTreeId.startsWith("D006")){
						if(cLevel<=1){
							set.addAttribute("link", "JavaScript:popDevList('"+cdevTreeId+"','"+orgSubId+"','"+country+"')");
						}
					}
					set.addAttribute("value", value);	
				}
				
		    }
		}
//if(StringUtils.isNotBlank(devTreeId)){
//			
//		}
//		else
//		{
//		StringBuilder sqlj = new StringBuilder();
//		sqlj.append(" select  sum(tmp.total_num) as lable,sum(tmp.unuse_num) as value " +
//				"from (select acc.dev_acc_id,acc.dev_unit," +
//				"nvl(acc.total_num, 0) total_num,nvl(acc.unuse_num, 0) " +
//				"unuse_num,acc.dev_name,acc.dev_model,nvl(acc.use_num, 0) use_num," +
//				"case when acc.ifcountry='000' then '����' else acc.ifcountry end as ifcountry," +
//				"nvl(acc.other_num, 0) other_num,ci.dev_code,ci.dev_name as dev_type, ");
//		sqlj.append(" usageorg.org_abbreviation as usage_org_name,owingorg.org_abbreviation as owning_org_name," +
//				"unitsd.coding_name as unit_name, org.org_abbreviation as org_name,acc.usage_sub_id,acc.usage_org_id,acc.owning_org_id,acc.owning_sub_id,suborg.org_subjection_id ");
//		sqlj.append("  from gms_device_coll_account acc ");
//		sqlj.append("  left join gms_device_collectinfo ci on acc.device_id=ci.device_id");
//		sqlj.append("  left join comm_org_information org on acc.owning_org_id=org.org_id and org.bsflag = '0'");
//		sqlj.append(" left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id and usageorg.bsflag = '0' ");
//		sqlj.append(" left join comm_org_information owingorg on acc.owning_org_id=owingorg.org_id and owingorg.bsflag = '0' ");
//		sqlj.append(" left join comm_org_subjection suborg on acc.owning_org_id = suborg.org_id and suborg.bsflag = '0'");
//		sqlj.append(" left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id where acc.bsflag='0' and ci.is_leaf = '1' ");
//		// ��̽��
//		if(StringUtils.isNotBlank(orgSubId)){
//			sqlj.append("  and ( acc.owning_sub_id like '"+orgSubId+"%' or acc.usage_sub_id like '"+orgSubId+"%' )");
//		}
//		sqlj.append(" )tmp where 1=1 and tmp.dev_code like '04%'");
//		// ���ڹ���
//		if(StringUtils.isNotBlank(country)){
//				sqlj.append("  and tmp.ifcountry='"+vcountry+"'");
//		}
//		Map map =jdbcDao.queryRecordBySQL(sqlj.toString());
//		Element set1 = root.addElement("set");
//		if(!map.get("lable").equals(""))
//		{
//		set1.addAttribute("label", "�첨��("+map.get("lable").toString()+"��)");
//		set1.addAttribute("link", "JavaScript:popNextLevelJBQLie('"+orgSubId+"','"+country+"')");
//		set1.addAttribute("value", map.get("value").toString());
//		}
//		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * ��ѯ�豸��Ϣ�б�̨
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevLieForList(ISrvMsg isrvmsg) throws Exception {
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
		StringBuilder sql = new StringBuilder(
				"select tree.device_code,T.DEV_NAME,T.DEV_MODEL,sum(t.ifunused) as uusecount,count(1) sumcount from gms_device_account t   "
						+ " left join dms_device_tree tree on tree.Device_Code=t.dev_type where  t.ifproduction='5110000186000000001' "
	+"AND t.Dev_Type in      (select TREE.DEVICE_CODE   from dms_device_tree tree  where tree.dev_tree_id like 'D003%' OR TREE.DEV_TREE_ID LIKE 'D004%' OR  TREE.DEV_TREE_ID LIKE 'D006%' ) ");
		// ��̽��
				if(StringUtils.isNotBlank(orgSubId)){
					sql.append(" and T.OWNING_SUB_ID   LIKE '"+orgSubId+"%' ");
				}
		if(!devTreeId.equals("null"))
		{
			String devTypes[]=devTreeId.split(",");
			sql.append(" and (");
			for(int i=0;i<devTypes.length;i++)
			{
				if(i==0)
				{
					sql.append( "   tree.dev_tree_id like '"+devTypes[i]+"%'  ");
				}
				else
				{
					sql.append( "  or  tree.dev_tree_id like '"+devTypes[i]+"%'  ");
				}
	
			}
			sql.append(" )");
		}
		
		// ���ڹ���
		if(StringUtils.isNotBlank(country)){
			sql.append(" and T.IFCOUNTRY='"+vcountry+"'");
		}
		
		sql.append(" GROUP BY T.DEV_TYPE,T.DEV_NAME,T.DEV_MODEL,tree.device_code ");
		

		page = pureJdbcDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
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
}
