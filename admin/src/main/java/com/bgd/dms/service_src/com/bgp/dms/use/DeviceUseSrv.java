package com.bgp.dms.use;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
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
 * @author chenchong 2015.5.11
 *
 */
public class DeviceUseSrv extends BaseService{
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	
	public DeviceUseSrv(){
		log = LogFactory.getLogger(DeviceUseSrv.class);
	}
	/**	
	 * ��û�����Ҫ�豸�����ʶԱ�,�����ͼ����ʾ
	 * @return dateSets
	 */
	public ISrvMsg getUseRateForOrg(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		System.out.println("ccc--");
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
		// ���ڹ���
		String country = reqDTO.getValue("country");
		if(StringUtils.isBlank(country)){
			country="";
		}
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
		StringBuilder sql = new StringBuilder(
				"select i.org_abbreviation as label,"
						+ " nvl(decode(sum(dh.sum_num),0,0,sum(dh.use_num) / sum(dh.sum_num)),0) as userate "
						+ " from gms_device_dailyhistory dh left join comm_org_subjection s on s.org_subjection_id = dh.org_subjection_id "
						+"  left join comm_org_information i on i.org_id = s.org_id"
						+"  where (dh.org_subjection_id like 'C105002%' or"
						+"  dh.org_subjection_id like 'C105001005%' or"
						+"  dh.org_subjection_id like 'C105001002%' or"
						+"  dh.org_subjection_id like 'C105001003%' or"
						+"  dh.org_subjection_id like 'C105001004%' or"
						+"  dh.org_subjection_id like 'C105005004%' or"
						+"  dh.org_subjection_id like 'C105005000%' or"
						+"  dh.org_subjection_id like 'C105005001%' or"
						+"  dh.org_subjection_id like 'C105007%' or"
						+"  dh.org_subjection_id like 'C105063%' or"
						+"  dh.org_subjection_id like 'C105086%' or"
						+"  dh.org_subjection_id like 'C105006%')");
						
		// ��̽��
		if(StringUtils.isNotBlank(orgSubId)){
			sql.append(" and dh.org_subjection_id='"+orgSubId+"'");
		}
		// ���ڹ���
		if(StringUtils.isNotBlank(country)){
			sql.append(" and dh.country='"+country+"'");
		}
		// ��ʼʱ��
		sql.append(" and dh.his_date>=to_date('" + _startDate + "','yyyy-mm-dd')");
		// ����ʱ��
		sql.append(" and dh.his_date<=to_date('" + _endDate + "','yyyy-mm-dd')");
		sql.append("  group by dh.org_subjection_id, i.org_abbreviation  order by dh.org_subjection_id ");
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
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String value = "0";//Ĭ�������
				set.addAttribute("label", map.get("label").toString());
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
	 * NEWMETHOD
	 * ��Ŀ�ۺ����ݲ�ѯ
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProject(ISrvMsg msg) throws Exception {
		log.info("queryProject");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String projectName = msg.getValue("projectName");//��Ŀ����
		String orgSubjectionId = msg.getValue("orgSubjectionId");//��̽��
		String projectType = msg.getValue("projectType");//��Ŀ����
		String projectYear = msg.getValue("projectYear");//��Ŀ���
		String isMainProject = msg.getValue("isMainProject");//��Ҫ�̶�
		String projectStatus = msg.getValue("projectStatus");//��Ŀ״̬
		String orgName = msg.getValue("orgName");//ʩ������
		String explorationMethod = msg.getValue("explorationMethod");//��̽����
		String projectArea = msg.getValue("projectArea");//������������

		StringBuffer querySql = new StringBuffer();
		querySql.append("select p.*,dy.org_id as org_id22,(select t.coding_name  from comm_coding_sort_detail t"+
			" where t.coding_code_id = (select superior_code_id from comm_coding_sort_detail where coding_code_id = p.manage_org)) || ' ' ||  ccsd.coding_name as manage_org_name,sap.prctr_name as prctr_name,ct.project_name as pro_name,"+
			" p.design_end_date - p.design_start_date as duration_date,p6.object_id as project_object_id,"+
			" nvl(p.project_start_time, p.acquire_start_time) as start_date,nvl(p.project_end_time, p.acquire_end_time) as end_date,"+
			" dy.org_id,org.org_abbreviation as org_name,(case p.project_status when '5000100001000000001' then '1'"+
			" when '5000100001000000002' then '2' when '5000100001000000003' then '4' when '5000100001000000004' then '3'"+
			" when '5000100001000000005' then '5' else '6' end) pro_status,"+
			" case when dy.org_subjection_id like 'C105001005%' then '����ľ��̽��' when dy.org_subjection_id like 'C105001002%' then '�½���̽��'"+
			" when dy.org_subjection_id like 'C105001003%' then '�¹���̽��' when dy.org_subjection_id like 'C105001004%' then '�ຣ��̽��'"+
			" when dy.org_subjection_id like 'C105005004%' then '������̽��' when dy.org_subjection_id like 'C105005000%' then '������̽��'"+
			" when dy.org_subjection_id like 'C105005001%' then '������̽������' when dy.org_subjection_id like 'C105007%' then '�����̽��'"+
			" when dy.org_subjection_id like 'C105063%' then '�ɺ���̽��' when dy.org_subjection_id like 'C105086%' then '���̽��'"+
			" when dy.org_subjection_id like 'C105008%' then '�ۺ��ﻯ��' when dy.org_subjection_id like 'C105002%' then '���ʿ�̽��ҵ��'"+
			" when dy.org_subjection_id like 'C105006%' then 'װ������' when dy.org_subjection_id like 'C105003%' then '�о�Ժ'"+
			" when dy.org_subjection_id like 'C105017%' then '����������ҵ��' else org.org_abbreviation end as owning_org_name_desc"+
			" from gp_task_project p "+
			" left join gp_task_project_dynamic dy on dy.bsflag = '0'  and dy.project_info_no =  p.project_info_no and dy.exploration_method =p.exploration_method"+
			" left join comm_coding_sort_detail ccsd on p.manage_org = ccsd.coding_code_id  and ccsd.bsflag = '0'"+
			" left join bgp_pm_sap_org sap on sap.prctr = p.prctr left join bgp_p6_project p6 on p6.project_info_no =  p.project_info_no and p6.bsflag = '0'"+
			" left join gp_workarea_diviede wd on wd.workarea_no = p.workarea_no and wd.bsflag = '0' "+
			" left join comm_org_information org on org.org_id = dy.org_id and org.bsflag = '0' left join gp_ops_epg_task_project ct on ct.project_info_no = p.spare2"+
			" where p.bsflag = '0'");
		
		if (StringUtils.isNotBlank(projectName)) {//��Ŀ����
			querySql.append(" and p.project_name like '%"+projectName+"%' ");
		}		
		if (StringUtils.isNotBlank(orgSubjectionId)) {//��̽��
			querySql.append(" and dy.org_subjection_id like '%"+orgSubjectionId+"%' ");
		}
		if (StringUtils.isNotBlank(projectType)) {//��Ŀ����
			querySql.append(" and p.project_type like '%"+projectType+"%' ");
		}
		if (StringUtils.isNotBlank(projectYear)) {//���
			querySql.append(" and p.project_year like '%"+projectYear+"%' ");
		}
		if (StringUtils.isNotBlank(isMainProject)) {//��Ҫ�̶�
			querySql.append(" and p.is_main_project like '%"+projectYear+"%' ");
		}
		if (StringUtils.isNotBlank(projectStatus)) {//��Ŀ״̬
			querySql.append(" and p.project_status like '%"+projectStatus+"%' ");
		}
		if (StringUtils.isNotBlank(orgName)) {//ʩ������
			querySql.append(" and org.org_abbreviation like '%"+orgName+"%' ");
		}
		if (StringUtils.isNotBlank(explorationMethod)) {//��̽����
			querySql.append(" and p.exploration_method like '%"+explorationMethod+"%' ");
		}
		if (StringUtils.isNotBlank(projectArea)) {//������������
			querySql.append(" and wd.region_name like '%"+projectArea+"%' ");
		}
		querySql.append("order by case "
				+ "when p.project_type = '5000100004000000001' then 1 "   //½����Ŀ
				+ "when p.project_type = '5000100004000000005' then 2 "   //������Ŀ
				+ "when p.project_type = '5000100004000000007' then 3 "   //½�غ�ǳ����Ŀ
				+ "when p.project_type = '5000100004000000002' then 4 "   //ǳ����Ŀ
				+ "when p.project_type = '5000100004000000010' then 5 "   //̲ǳ�����ɴ�
				+ "when p.project_type = '5000100004000000006' then 6 "   //���Ŀ
				+ "when p.project_type = '5000100004000000011' then 7 "   //���ʲ�
				+ "when p.project_type = '5000100004000000003' then 8 "   //�ǵ�����Ŀ
				+ "when p.project_type = '5000100004000000008' then 9 "   //������Ŀ
				+ "when p.project_type = '5000100004000000009' then 10 "  //�ۺ��ﻯ̽
				+ "end,pro_status, p.project_year desc ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	
	
}
