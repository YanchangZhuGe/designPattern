package com.bgp.gms.service.rm.dm.util;

import com.bgp.mcs.service.pm.service.bimap.SynBiMapTask;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
public class ByAutoCalJob {
	private ILog log = LogFactory.getLogger(SynBiMapTask.class);
	/**
	 * 保养提醒 - 按天数
	 */
	/*public void makeByCal(){
		//查询保养计划表，找到下次保养日期在当前日期左右5天的保养数据
		//gms_device_zy_by  by_nexttime
		StringBuilder sb = new StringBuilder("select t.*,dui.dev_name,dui.self_num,zp.project_name from  gms_device_zy_by t "
				+ "left join gms_device_account_dui dui on t.dev_acc_id = dui.dev_acc_id "
				+ "left join gp_task_project zp on zp.project_info_no = t.projectinfono "
				+ "where t.isnewbymsg='0' and t.bsflag ='0' "
				+ "and to_date(to_char(sysdate - interval '15' day,'YYYY/MM/DD'),'YYYY/MM/DD')<= t.by_nexttime "
				+ "and to_date(to_char(sysdate + interval '15' day,'YYYY/MM/DD'),'YYYY/MM/DD')>= t.by_nexttime ");
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<Map<String,Object>> using = jdbcDao.getJdbcTemplate().queryForList(sb.toString());
		log.info("=======================保养提醒开始=======================");
		log.info("有"+using.size()+"条数据在提示范围内");
		if(using.size()>0){
			String messages ="<html>有"+using.size()+"条数据在提示范围内<br/>";
			for(int i = 0;i<using.size();i++){
				log.info("有来自项目:"+using.get(i).get("project_name")+"的设备:"+using.get(i).get("dev_name")+",自编号:"+using.get(i).get("self_num")+",需要进行"+using.get(i).get("bysx").toString().substring(0, 1)+"级保养");
				messages +="有来自项目:"+using.get(i).get("project_name")+"的设备:"+using.get(i).get("dev_name")+",自编号:"+using.get(i).get("self_num")+",需要进行"+using.get(i).get("bysx").toString().substring(0, 1)+"级保养<br/>";
			}
			messages+="</html>";
			new MailSendTest().sendMail(messages);
		}
		log.info("=======================保养提醒结束=======================");
	}*/
	/**
	 * 操作证周期提醒 - 提前3个月提醒	
	 */
	public void makeByCal(){
		//查询保养计划表，找到下次保养日期在当前日期左右5天的保养数据
		//gms_device_zy_by  by_nexttime

		String sql = " select row_number() over(order by tt.work_date desc) rowno,tt.* ,b.file_id from ( select * from (select *"
				+ " from (select distinct l.*,"
				+ " d4.coding_name org_name,"
				+ " d3.coding_name post"
				+ " from (select distinct  "
				+ " '' employee_cd,"
				+ "  l.employee_id_code_no,"
				+ " to_char(l.create_date, 'yyyy-MM-dd')  work_date,"
				+ "  '' org_id,"
				+ "   l.employee_name,"
				+ "   decode(l.employee_gender, '0', '女', '1', '男') employee_gender,"
				+ "   nvl(t1.post, l.post) set_postw,"
				+ "   nvl(t1.apply_team, l.apply_team) set_teamw"
				+ "  from bgp_comm_human_labor l"
				+ "  left join (select lt.labor_id, count(1) nu"
				+ "  from bgp_comm_human_labor_list lt"
				+ "  left join bgp_comm_human_labor l"
				+ "     on l.labor_id = lt.labor_id"
				+ "   where lt.bsflag = '0'"
				+ "     and l.bsflag = '0'"
				+ "   group by lt.labor_id) lt"
				+ " on l.labor_id = lt.labor_id"
				+ " left join (select d2.*"
				+ "  from (select d1.*"
				+ "    from (select d.apply_team,"
				+ "                  d.post,"
				+ "                  l1.labor_id,"
				+ "                  row_number() over(partition by l1.labor_id order by d.start_date desc) numa"
				+ "             from bgp_comm_human_deploy_detail d"
				+ "             left join bgp_comm_human_labor_deploy l1"
				+ "               on d.labor_deploy_id ="
				+ "                  l1.labor_deploy_id"
				+ "           where d.bsflag = '0') d1"
				+ "    where d1.numa = 1) d2) t1"
				+ " on l.labor_id = t1.labor_id"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on l.employee_nation = d1.coding_code_id"
				+ "  left join comm_coding_sort_detail d2"
				+ "    on l.employee_education_level = d2.coding_code_id"
				+ " left join (select count(distinct"
				+ "                       to_char(t.start_date, 'yyyy')) years,"
				+ "                 t.labor_id"
				+ "            from bgp_comm_human_labor_deploy t"
				+ "           group by t.labor_id) t"
				+ "  on l.labor_id = t.labor_id"
				+ "  left join bgp_comm_human_certificate cft"
				+ "    on cft.employee_id = l.labor_id"
				+ "    and cft.bsflag = '0'"
				+ "   where l.bsflag = '0'"
				+ "    and l.owning_subjection_org_id like '%C105%') l"
				+ " left join comm_coding_sort_detail d3"
				+ "   on l.set_postw = d3.coding_code_id"
				+ "  left join comm_coding_sort_detail d4"
				+ "    on l.set_teamw = d4.coding_code_id) t"
				+ "   union all "
				+ "   select t.*"
				+ "  from (select h.employee_cd,"
				+ "  e.employee_id_code_no,"
				+ "   to_char(h.work_date, 'yyyy-MM-dd') work_date,"
				+ "   e.org_id,"
				+ "   e.employee_name,"
				+ "   decode(e.employee_gender, '0', '女', '1', '男') employee_gender,"
				+ "   nvl(phr.work_post, h.set_post) set_postw,"
				+ "   nvl(phr.team, h.set_team) set_teamw,"
				+ "   i.org_abbreviation org_name,"
				+ "   h.post"
				+ "  from comm_human_employee e"
				+ " inner join comm_human_employee_hr h"
				+ "    on e.employee_id = h.employee_id"
				+ "  left join comm_org_subjection s"
				+ "    on e.org_id = s.org_id"
				+ "   and s.bsflag = '0'"
				+ "  left join comm_org_information i"
				+ "   on e.org_id = i.org_id"
				+ "  and i.bsflag = '0'"
				+ "  left join comm_coding_sort_detail d1"
				+ "    on h.post_level = d1.coding_code_id"
				+ "  and d1.bsflag = '0'"
				+ "   left join comm_coding_sort_detail d2"
				+ "    on e.employee_education_level = d2.coding_code_id"
				+ "    and d2.bsflag = '0'"
				+ "   left join (select d2.*"
				+ "             from (select d1.*"
				+ "                     from (select hr.team,"
				+ "                                 hr.work_post,"
				+ "                               hr.employee_id,"
				+ "                                 hr.actual_start_date,"
				+ "                               hr.actual_end_date,"
				+ "                               row_number() over(partition by hr.employee_id order by hr.actual_end_date desc) numa"
				+ "                          from bgp_project_human_relation hr"
				+ "                         where hr.bsflag = '0'"
				+ "                         and hr.locked_if = '1') d1"
				+ "                 where d1.numa = 1) d2) phr"
				+ "     on e.employee_id = phr.employee_id"
				+ "  left join comm_coding_sort_detail d13"
				+ "    on h.present_state = d13.coding_code_id"
				+ "  left join comm_org_subjection pin"
				+ "    on h.pin_unit = pin.org_subjection_id"
				+ "   and pin.bsflag = '0'"
				+ "  left join bgp_comm_org_hr_gms pin1"
				+ "    on pin1.org_gms_id = pin.org_id"
				+ "  left join bgp_comm_org_hr pin2"
				+ "   on pin2.org_hr_id = pin1.org_hr_id"
				+ "  where e.bsflag = '0'"
				+ "    and h.bsflag = '0'"
				+ "   order by e.modifi_date desc, e.employee_name desc) t"
				+ " left join comm_coding_sort_detail d11"
				+ "    on t.set_teamw = d11.coding_code_id"
				+ "  left join comm_coding_sort_detail d12"
				+ "   on t.set_postw = d12.coding_code_id) temp   where temp.employee_id_code_no in(select EMPLOYEE_ID from dms_device_opcardapply_details where  sfcz='0' ";
		 
			sql += " and apply_id=(select devapp.apply_id   from dms_device_opcardappply devapp  ";
			sql+=" left join common_busi_wf_middle wfmiddle on devapp.apply_id = wfmiddle.business_id where proc_status='3' and to_date('2018-03-01','yyyy-mm-dd') between add_months(modifi_date,22) and add_months(modifi_date,24))";
		 
		sql += " )  union all ";

		sql += " select  '' employee_cd,employee_id employee_id_code_no,to_char(work_date, 'yyyy-MM-dd')  work_date, '' org_id,employee_name,    employee_gender,'' set_postw ,'' set_teamw, org_name ,post  from dms_device_opcardapply_details where  sfcz='1'";
		 
	    sql += " and apply_id  in(select devapp.apply_id   from dms_device_opcardappply devapp  ";
	    sql+=" left join common_busi_wf_middle wfmiddle on devapp.apply_id = wfmiddle.business_id where proc_status='3' and to_date('2018-03-01','yyyy-mm-dd') between add_months(modifi_date,22) and add_months(modifi_date,24)) ";
		 
		sql += " ) tt left join BGP_DOC_GMS_FILE  b on b.relation_id=employee_id_code_no  where 1=1 ";
		 
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		List<Map<String,Object>> using = jdbcDao.getJdbcTemplate().queryForList(sql);
		log.info("=======================操作证提醒开始=======================");
		log.info("有"+using.size()+"条数据在提示范围内");
		if(using.size()>0){
			String messages ="<html>有"+using.size()+"条数据在提示范围内<br/>";
			for(int i = 0;i<using.size();i++){
				messages +="姓名:"+using.get(i).get("employee_name")+"身份证:"+using.get(i).get("employee_id_code_no").toString()+"操作证即将到期<br/>";
			}
			messages+="</html>";
			new MailSendTest().sendMail(messages);
		}
		log.info("=======================操作证提醒开始=======================");
	}
}
