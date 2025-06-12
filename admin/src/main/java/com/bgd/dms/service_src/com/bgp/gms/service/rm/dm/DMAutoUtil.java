package com.bgp.gms.service.rm.dm;

import java.text.MessageFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;
/**
 * 
 * ���ߣ������� 2012-12-14
 *       
 * �������Զ�ͳ����̽������ά����������������
 */
public class DMAutoUtil{
	
	public DMAutoUtil() {
	}

	public void run() {

		ServiceCallConfig servicecallconfig = new ServiceCallConfig();
		servicecallconfig.setServiceName("DevCommInfoSrv");
		servicecallconfig.setOperationName("getWHLYTRANS");
		try {
			System.out.println("---------��ʼͳ�ƹ�˾������̽��������ʡ�����������---------");
				
			ISrvMsg reqDTO1 = SrvMsgUtil.createISrvMsg(servicecallconfig.getOperationName());
			
			ServiceCallFactory.getIServiceCall().callWithDTO(null, reqDTO1, servicecallconfig);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public void autoMixKQInfo(){
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		//��ǰ����
		Calendar currentCalendar = Calendar.getInstance();
		//����ʱ�䣬����1��
		Calendar endCalendar = Calendar.getInstance();
		endCalendar.set(currentCalendar.get(Calendar.YEAR), 
				currentCalendar.get(Calendar.MONTH), 
				currentCalendar.get(Calendar.DATE));
		endCalendar.set(Calendar.DATE,1);
		Calendar beginCalendar = Calendar.getInstance();
		//��ʼʱ�䣬����1��
		beginCalendar.set(currentCalendar.get(Calendar.YEAR), 
				currentCalendar.get(Calendar.MONTH)-1,1);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String autofillkqsql = "insert into bgp_comm_device_timesheet(timesheet_id,device_account_id,timesheet_date,timesheet_symbol)"+
			" (select sys_guid(),dui.dev_acc_id,to_date('@','yyyy-mm-dd'),'5110000041000000001' from gms_device_account_dui dui "+
			"where 1=1 "+
			"and (dui.dev_type like 'S0601%' or dui.dev_type like 'S0622%' or dui.dev_type like 'S0623%' "+
        	"or dui.dev_type like 'S07010101%' or dui.dev_type like 'S070301%' "+
        	"or dui.dev_type like 'S0801%' or dui.dev_type like 'S0802%' or dui.dev_type like 'S0803%' or dui.dev_type like 'S0804%' "+
        	"or dui.dev_type like 'S080503%' or dui.dev_type like 'S080504%' or dui.dev_type like 'S080601%' or dui.dev_type like 'S080604%' "+
        	"or dui.dev_type like 'S080607%' or dui.dev_type like 'S090101%') "+
        	"and not exists(select 1 from bgp_comm_device_timesheet sheet where sheet.device_account_id=dui.dev_acc_id "+
        	"and sheet.bsflag='0' and sheet.timesheet_date=to_date('@','yyyy-mm-dd')) "+
        	"and (dui.actual_out_time is null or dui.actual_out_time>to_date('@','yyyy-mm-dd')))";
		try {
			long startint = new Date().getTime();
			for(;beginCalendar.before(endCalendar);beginCalendar.add(Calendar.DATE, 1)){
				String fordate = sdf.format(beginCalendar.getTime());
				jdbcDao.executeUpdate(autofillkqsql.replaceAll("@", fordate));
			}
			long endint = new Date().getTime();
			System.out.println("------�Զ���д�Ŀ�����Ϣ����ʱ��"+(endint-startint)/1000+"s...");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public static void main(String[] args){
		new DMAutoUtil().autoMixKQInfo();
	}
	public static String getPerfectUse(String yearinfo){
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		//String orginfo = reqDTO.getValue("code");
		String orgstrId = "C6000000000001";
		String orginfo = "C105";
		if(orginfo==null||"".equals(orginfo)){
			String subidsql = "select org_subjection_id as orgsubid from comm_org_subjection where org_id='"+orgstrId+"' and bsflag='0' ";
			Map tmpMap = jdbcDao.queryRecordBySQL(subidsql);
			orginfo = tmpMap.get("orgsubid").toString();
		}
		
		if(yearinfo == null){
			yearinfo = new SimpleDateFormat("yyyy").format(Calendar.getInstance().getTime());
		}
		String[] nodetypes = new String[]{yearinfo+"-01",yearinfo+"-02",yearinfo+"-03",yearinfo+"-04",yearinfo+"-05",
				yearinfo+"-06",yearinfo+"-07",yearinfo+"-08",yearinfo+"-09",yearinfo+"-10",yearinfo+"-11",yearinfo+"-12"};
		//2013-02-25 ��ǰ��
		int currentmonth = Integer.parseInt(new SimpleDateFormat("MM").format(new Date()),10);
		
		String[] seriesNames = new String[]{"��Ҫ�豸�����","��Ҫ�豸������"};
		
		String[] orgNames = new String[]{"C105006-װ��","C105001005-����ľ","C105001002-�½�", 
				"C105001003-�¹�","C105001004-�ຣ" ,"C105005004-����", 
				"C105005000-����","C105005001-������̽","C105063-�ɺ�","C105007-���"};
		int[] specialindex = new int[]{0,8,9};
		ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
		String[] specialweights = rb.getString("SPECIAL_WEIGHT").split("~", -1);
		//���ڿ������Ƿ��������ֵ�� ��������ʾ������
		String specialweight = null;
		String orgname = null;
		//��ȡ���� 0 ��˾ 1��̽�� 2��Ŀ
		String drilllevel = "0";
		if("0".equals(drilllevel)){
			specialweight = rb.getString("SPECIAL_WEIGHT_GONGSI");
			orginfo = DevConstants.COMM_COM_ORGSUBID;
			orgname = "��˾";
		}else{
			for(int index=0;index<orgNames.length;index++){
				String checkinfo = orgNames[index].split("-")[0];
				if(checkinfo.equals(orginfo)){
					orgname = orgNames[index];
					for(int j=0;j<specialindex.length;j++){
						if(specialindex[j]==index){
							specialweight = specialweights[j];
						}
					}
				}
			}
		}
		//orgid,not org_sub_id 
		Document document = DocumentHelper.createDocument();  		
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("formatNumber", "0");
		root.addAttribute("showValues", "1");
		root.addAttribute("numbersuffix", "%");
		//root.addAttribute("xAxisName", orgname.split("-")[1]+"<��Ҫ�豸����ʡ�������>");
		
		Element categories = root.addElement("categories");
		
		Element[] datasets = new Element[seriesNames.length];
		for(int j=0;j<seriesNames.length;j++){
			datasets[j] = root.addElement("dataset");
			datasets[j].addAttribute("seriesName", seriesNames[j]);
		}
		//ͳ��5����ֵ
		StringBuffer dantaiwanhao = new StringBuffer("select label,monthinfo,wanhaolv,liyonglv ");
		dantaiwanhao.append(" from (");
			dantaiwanhao.append("select subtable.label,tmp.monthinfo,")
					.append("case when totalzhiduinfo=0 then 0 else trunc(100*(totalzhiduinfo-totalweixiuinfo)/totalzhiduinfo,2) end as wanhaolv, ");
			dantaiwanhao.append("case when totalzhiduinfo=0 then 0 else trunc(100*(totalliyonginfo)/totalzhiduinfo,2) end as liyonglv ");
			dantaiwanhao.append("from (select  '"+orginfo+"' as orginfo,'"+orgname+"' as label from dual) subtable ");
			dantaiwanhao.append("left join ");
			dantaiwanhao.append("(select '"+orginfo+"' as orginfo,monthinfo,sum(zhiduinfo) as  totalzhiduinfo,sum(weixiuinfo) as totalweixiuinfo,sum(liyonginfo) as totalliyonginfo ");
			dantaiwanhao.append("from gms_device_whly_trans where orgsubid like '"+orginfo+"%' and transtype='1' and monthinfo like '"+yearinfo+"%' ")
				.append(" group by monthinfo order by monthinfo ) tmp on subtable.orginfo=tmp.orginfo ");
		dantaiwanhao.append(")order by monthinfo ");
		//�������
		StringBuffer piliangwanhao = new StringBuffer("select label,monthinfo,wanhaolv,liyonglv ");
			piliangwanhao.append(" from (");
			piliangwanhao.append("select subtable.label,tmp.monthinfo,")
					.append("case when totalzhiduinfo=0 then 0 else trunc(100*(totalzhiduinfo-totalweixiuinfo)/totalzhiduinfo,2) end as wanhaolv, ");
			piliangwanhao.append("case when totalzhiduinfo=0 then 0 else trunc(100*(totalliyonginfo)/totalzhiduinfo,2) end as liyonglv ");
			piliangwanhao.append("from (select  '"+orginfo+"' as orginfo,'"+orgname+"' as label from dual) subtable ");
			piliangwanhao.append("left join ");
			piliangwanhao.append("(select '"+orginfo+"' as orginfo,monthinfo,sum(zhiduinfo) as  totalzhiduinfo,sum(weixiuinfo) as totalweixiuinfo,sum(liyonginfo) as totalliyonginfo ");
			piliangwanhao.append("from gms_device_whly_trans where orgsubid like '"+orginfo+"%' and transtype='2' and monthinfo like '"+yearinfo+"%' ")
					.append(" group by monthinfo order by monthinfo ) tmp on subtable.orginfo=tmp.orginfo ");
			piliangwanhao.append(")order by monthinfo ");
		
		//�Ȳ�ѯ���� dantaiwanhao dantailiyong
		List<Map> dantaiwanhaolist = jdbcDao.queryRecords(dantaiwanhao.toString());
		List<Map> piliangwanhaolist = null;
		if(specialweight!=null){
			piliangwanhaolist = jdbcDao.queryRecords(piliangwanhao.toString());
		}
		StringBuffer sb = new StringBuffer("");
		for(int index=0;index<dantaiwanhaolist.size();index++){
			String monthinfo = dantaiwanhaolist.get(index).get("monthinfo").toString();
			Element category = categories.addElement("category");
			category.addAttribute("label", monthinfo);
			
			int thismonthinfo = Integer.parseInt(monthinfo.split("-")[1],10);
			if(Integer.parseInt(yearinfo)==(new Date().getYear()+1900)){
				if(thismonthinfo>currentmonth)
					continue;
			}
			//2012-10-26 ��Ȩ��������ʺ�������
			Float wanhaolv;
			Float liyonglv;
			if(specialweight!=null){
				Float dantaiwanhaolv = new Float(Float.parseFloat(specialweight)*Float.parseFloat(((Map)dantaiwanhaolist.get(index)).get("wanhaolv").toString()));
				Float piliangwanhaolv = 0.0f;
				if(piliangwanhaolist.size()>index&&piliangwanhaolist.get(index)!=null){
					piliangwanhaolv = new Float((1-Float.parseFloat(specialweight))*Float.parseFloat(((Map)piliangwanhaolist.get(index)).get("wanhaolv").toString()));
				}
				wanhaolv = new Float(piliangwanhaolv+dantaiwanhaolv);
				Float dantailiyonglv = new Float(Float.parseFloat(specialweight)*Float.parseFloat(((Map)dantaiwanhaolist.get(index)).get("liyonglv").toString()));
				if(dantailiyonglv<0){
					dantailiyonglv = 0.0f;
				}
				Float piliangliyonglv = 0.0f;
				if(piliangwanhaolist.size()>index&&piliangwanhaolist.get(index)!=null){
					piliangwanhaolv = new Float((1-Float.parseFloat(specialweight))*Float.parseFloat(((Map)piliangwanhaolist.get(index)).get("liyonglv").toString()));
				}
				if(piliangwanhaolv<0){
					piliangwanhaolv = 0.0f;
				}
				liyonglv = new Float(piliangliyonglv+dantailiyonglv);
			}else{
				wanhaolv = Float.parseFloat(((Map)dantaiwanhaolist.get(index)).get("wanhaolv").toString());
				liyonglv = Float.parseFloat(((Map)dantaiwanhaolist.get(index)).get("liyonglv").toString());
				if(liyonglv<0){
					liyonglv = 0.0f;
				}
			}
			Element set1 = datasets[0].addElement("set");
			set1.addAttribute("value", MessageFormat.format("{0,number,0.0}", new Object[]{wanhaolv}));
			Element set2 = datasets[1].addElement("set");
			set2.addAttribute("value", MessageFormat.format("{0,number,0.0}", new Object[]{liyonglv}));
			//��ȡ���� 0 ��˾ 1��̽�� 2��Ŀ
			if(drilllevel!=null){
				//��˾��������ȡ��Ϣ
				if("0".equals(drilllevel)){
					set1.addAttribute("link", "j-popComWanhaoForMonth-"+monthinfo);
					set2.addAttribute("link", "j-popComWanhaoForMonth-"+monthinfo);
				}else if("1".equals(drilllevel)){
					set1.addAttribute("link", "j-popWutanWanhaoForMonth-"+monthinfo);
					set2.addAttribute("link", "j-popWutanWanhaoForMonth-"+monthinfo);
				}
			}
			sb.append("select '"+monthinfo+"' year_month ,'"+wanhaolv+"'perfect,'"+liyonglv+"'use_ratio from dual union ");
			
		}
		sb.append("select '' year_month ,''perfect,''use_ratio from dual");
		return sb.toString();
	}
}
