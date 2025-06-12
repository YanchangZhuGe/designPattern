package com.bgp.gms.service.ess.srv;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.springframework.stereotype.Service;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.soaf.util.Operation;

/**
 * @Title: GmsServiceForESS.java
 * @Package com.bgp.gms.service.ess.srv
 * @Description: Ϊר��֧��ϵͳ�ṩ����
 * @author wuhj
 * @date 2014-4-2 ����3:25:37
 * @version V1.0
 */
@Service("GmsService")
public class GmsServiceForESS extends BaseService
{

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	@Operation(input = "date", output = "projects")
	public ISrvMsg gainProjectInfos(ISrvMsg reqDTO) throws Exception
	{

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		//�û���¼ID
	//	String loginId = reqDTO.getValue("userId");
		String date    = reqDTO.getValue("date");
		//��ѯ�û�����֯����ID
	//	String orgSql = "select n.org_subjection_id from comm_org_subjection n where n.org_id in ("
	//			+ " select r.org_id from p_auth_user r where r.login_id = '"
	//			+ loginId + "')   and n.bsflag='0'";
		
	//	Map map = jdbcDao.queryRecordBySQL(orgSql);
	
		//��ȡ�û���֯������������ϵ
	//	String orgSubjectId= (String)map.get("org_subjection_id");
		
		//��ȡ��Ŀ��Ϣ
		String projectSql = dealWithProjectSQL(date);
		
		List<Map> list = jdbcDao.queryRecords(projectSql);
		
		//��ȡ��Ŀ����Ա��Ϣ
		List<Map> totalList = processProjectForHumans(list);
		
		//ת����json��
		JSONArray jsonArray = JSONArray.fromCollection(totalList);
		
//		System.out.println(jsonArray.toString());
		
		responseDTO.setValue("projects", jsonArray.toString());

		return responseDTO;

	}
	
	/**
	 * 
	* @Title: processProjectForHumans
	* @Description: ��ȡÿ����Ŀ��Ϣ����Ա��Ϣ
	* @param @param list
	* @param @return    �趨�ļ�
	* @return List<Map>    ��������
	* @throws
	 */
	private List<Map> processProjectForHumans(List<Map> list){
 
		//��Ŀ��Ϣ����Ա��Ϣ
		List<Map> totalList = new ArrayList<Map>();
		
		for(Map map : list){
			String  project_info_no = (String)map.get("project_info_no");
			String  humanSql = dealWithProjectHumanSQL(project_info_no);
			List<Map> humanList = jdbcDao.queryRecords(humanSql);
			map.put("humans", humanList); 
			totalList.add(map);
		}
		
		return totalList;
	}
	/**
	 * 
	* @Title: dealWithProjectHumanSQL
	* @Description: ÿ����Ŀ����Ա��Ϣ
	* @param @param projectInfoNo
	* @param @return    �趨�ļ�
	* @return String    ��������
	* @throws
	 */
	private String dealWithProjectHumanSQL(String projectInfoNo){
		StringBuffer sb = new StringBuffer();
		sb.append(" select r.login_id, r.org_id ,r.user_name");
		sb.append("   from p_auth_user r  where r.emp_id in ");
		sb.append(" (select d.employee_id   from bgp_human_prepare_human_detail d ");
		sb.append("  inner join bgp_human_prepare p  on d.prepare_no = p.prepare_no ");
		sb.append("   and p.prepare_status = '2'  ");
		sb.append("  where d.bsflag = '0'   and p.project_info_no = '"+projectInfoNo+"') ");
		
		return sb.toString();
	}

	/**
	 * 
	 * @Title: dealWithSQL
	 * @Description: ������ʱ���ѯ������Ŀ
	 * @param @param orgCode
	 * @param @return �趨�ļ�
	 * @return String ��������
	 * @throws
	 */
	private String dealWithProjectSQL(String date)
	{

		String projectListSql = "select "
			/*+ "   tp.build_method, "
			+ "  tp.project_name as tp_project_name, "
			+ "  oi.org_abbreviation as org_name, "
			+ "   (case tp.is_main_project "
			+ "    when '0300100008000000001' then "
			+ "     '�����ص�' "
			+ "    when '0300100008000000002' then "
			+ "    '�������֣��ص�' "
			+ "    when '0300100008000000005' then "
			+ "      '����' "
			+ "    end) as is_main_project, "
			+ "    (case tp.project_status "
			+ "   when '5000100001000000001' then "
			+ "    '��Ŀ����' "
			+ "    when '5000100001000000002' then "
			+ "     '��������' "
			+ "     when '5000100001000000003' then "
			+ "      '��Ŀ����' "
			+ "     when '5000100001000000004' then "
			+ "     'ʩ����ͣ' "
			+ "    when '5000100001000000005' then "
			+ "     'ʩ������' "
			+ "  end) as project_status, "
			+ "    (case tp.project_type "
			+ "     when '5000100004000000001' then "
			+ "      '½����Ŀ' "
			+ "     when '5000100004000000007' then "
			+ "     '½�غ�ǳ����Ŀ' "
			+ "    end) as project_type, "
			+ "    ccsd.coding_name as manage_org_name, "
			+ "   nvl(tp.project_start_time, tp.acquire_start_time) as acquire_start_time, "
			+ "   nvl(tp.project_end_time, tp.acquire_end_time) as acquire_end_time, "
			+ "    p.heath_info_id, "
			+ "    p.pm_info, "
			+ "    p.qm_info, "
			+ "   p.hse_info, "
			+ "    gp.project_info_no, "
			+ "    w.focus_y, "
			+ "   w.focus_x "*/
			+ "  tp.project_name as project_name, "
			+ "  gp.project_info_no,"
			+ "  to_char(tp.create_date,'yyyy-MM-dd HH24:mi:ss') as create_date "
			+ "  from bgp_p6_project t "
			+ " left outer join (select * "
			+ "          from bgp_pm_project_heath_info "
			+ "        where heath_info_id in (SELECT heath_info_id "
			+ "   FROM (SELECT heath_info_id, "
			+ "                                              ROW_NUMBER() OVER(PARTITION BY project_info_no ORDER BY spare4 DESC) AS RN "
			+ "                                     FROM bgp_pm_project_heath_info) "
			+ "                                    WHERE RN = 1)) p "
			+ "  on t.project_info_no = p.project_info_no "
			+ " left outer join gp_task_project tp "
			+ "   on t.project_info_no = tp.project_info_no "
			+ "  join comm_coding_sort_detail ccsd "
			+ "    on tp.manage_org = ccsd.coding_code_id "
			+ "  join gp_task_project_dynamic dy "
			+ "    on tp.project_info_no = dy.project_info_no "
			+ "   and dy.bsflag = '0' "
			+ "   and dy.exploration_method = tp.exploration_method " +

			"  join comm_org_information oi "
			+ "     on oi.org_id = dy.org_id " + "   and oi.bsflag = '0' " +

			"   join gp_task_project gp "
			+ "   on gp.project_info_no = t.project_info_no "
			+ "   and gp.bsflag = '0' "
			+ "   left join gp_workarea_diviede w "
			+ "    on gp.workarea_no = w.workarea_no " + "  where 1 = 1 "
			+ "  and t.bsflag = '0' "
			+ "  and t.project_info_no is not null "
			+ "   and ccsd.bsflag = '0' " + "  and tp.create_date  > to_date('"+date+"','yyyy-mm-dd hh24:mi:ss') ";


		return projectListSql.toString();
	}
	
//	@Operation(input = "date", output = "projects")
//	public ISrvMsg saveClassTest(ISrvMsg reqDTO) throws Exception
//	{
//
//		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
//		Map map = new HashMap();
// 
//		
//		map.put("DAILY_NO", "8ad89114481f317501481f7cdb5e0042");
//		map.put("MODIFI_DATE", new Date());
//		map.put("WEATHER","2"  ); 
//		map.put("FIRST_SHOT_TIME", Timestamp.valueOf("2011-11-11 12:21:11"));
//		map.put("LAST_SHOT_TIME", Timestamp.valueOf("2011-11-11 12:21:11"));
//		
//		jdbcDao.saveOrUpdateEntity(map, "bgp_ops_ss_daily_efficiency");
//		
//		return responseDTO;
//
//	}
}
