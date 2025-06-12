package com.bgp.gms.service.rm.em.srv;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.op.srv.OPCostSrv;
import com.bgp.gms.service.op.util.OPCommonUtil;
import com.bgp.gms.service.rm.em.util.EquipmentAutoNum;
import com.bgp.gms.service.rm.em.util.PropertiesUtil;
import com.bgp.mcs.service.common.excelIE.util.ExcelExceptionHandler;
import com.bgp.mcs.service.rm.em.humanRequired.pojo.BgpProjectHumanRelation;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * project: 东方物探生产管理系统
 * 
 * creator: 申文珮
 * 
 * creator time:2012-5-29
 * 
 * description:临时工基本信息查看,以及页面选项卡多信息
 * 
 */
public class HumanLaborMessageSrv extends BaseService {
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	IBaseDao baseDao = BeanFactory.getBaseDao();
	private IJdbcDao queryJdbcDao = BeanFactory.getQueryJdbcDAO();
	
	public ISrvMsg getCommInfo(ISrvMsg reqDTO) throws Exception {
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String id = reqDTO.getValue("id");
		String employeeGz = reqDTO.getValue("employeeGz");
		
		StringBuffer employee = new StringBuffer("");
		
		if("0110000019000000001,0110000019000000002".indexOf(employeeGz) != -1){
			employee.append("select e.employee_id,h.employee_cd, e.employee_name, ");
			employee.append("decode(e.employee_gender,'0','女','1','男') employee_gender, ");
			employee.append("(to_char(sysdate, 'YYYY') - to_char(e.employee_birth_date, 'YYYY')) age,to_char( e.employee_birth_date,'yyyy-MM-dd') employee_birth_date, ");
			employee.append("e.employee_nation,nvl(d1.coding_name, e.employee_nation)employee_nation_name, ");
			employee.append("h.nationality,nvl(d7.coding_name, h.nationality) nationality_name,nvl(i.org_abbreviation,e.org_id) org_name, ");
			employee.append("e.mail_address , e.phone_num , e.employee_mobile_phone, ");
			employee.append("e.employee_education_level,nvl(d2.coding_name,e.employee_education_level ) employee_education_level_name, ");
			employee.append("h.employee_gz, nvl(d3.coding_name, h.employee_gz ) employee_gz_name, ");
			employee.append("h.post, h.post_sort,nvl(d8.coding_name,h.post_sort) post_sort_name, ");
			employee.append("h.post_level,nvl(d4.coding_name, h.post_level ) post_level_name, ");
			employee.append("h.df_workerfrom, nvl(d5.coding_name, h.df_workerfrom) workerfrom_name, ");
			employee.append("h.language_sort, nvl(d9.coding_name,h.language_sort) language_sort_name, ");
			employee.append("h.language_level,nvl(d10.coding_name,h.language_level) language_level_name, ");
			employee.append("e.employee_health_info, nvl(d6.coding_name,e.employee_health_info) employee_health_info_name, ");
			employee.append("to_char( h.work_date,'yyyy-MM-dd') work_date, ");
			employee.append("to_char( h.work_cnpc_date,'yyyy-MM-dd') work_cnpc_date, ");
			employee.append("h.second_org, h.third_org, h.fourth_org,  h.fifth_org, ");
			employee.append("e.employee_id_code_no,nvl(d11.coding_name,h.set_team) set_team_name, ");
			employee.append("nvl(d12.coding_name,h.set_post) set_post_name,decode(h.spare7,'0','一线员工','1','境外员工','2','二线员工','4','三线员工','3','境外二三线','') spare7,h.spare2,h.home_address,h.qq,h.e_mail ");
			employee.append("from comm_human_employee e ");
			employee.append("left join comm_human_employee_hr h on e.employee_id = h.employee_id and h.bsflag = '0' ");
			employee.append("left join comm_org_information i on e.org_id = i.org_id and i.bsflag = '0' ");
			employee.append("left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' ");
			employee.append("left join comm_coding_sort_detail d1 on e.employee_nation=d1.coding_code_id and d1.bsflag='0' ");
			employee.append("left join comm_coding_sort_detail d2 on e.employee_education_level=d2.coding_code_id and d2.bsflag='0' ");
			employee.append("left join comm_coding_sort_detail d3 on h.employee_gz=d3.coding_code_id and d3.bsflag='0' ");
			employee.append("left join comm_coding_sort_detail d4 on h.post_level=d4.coding_code_id and d4.bsflag='0' ");
			employee.append("left join comm_coding_sort_detail d5 on h.df_workerfrom =d5.coding_code_id and d5.bsflag='0' ");
			employee.append("left join comm_coding_sort_detail d6 on e.employee_health_info=d6.coding_code_id and d6.bsflag='0' ");
			employee.append("left join comm_coding_sort_detail d7 on h.nationality = d7.coding_code_id and d7.bsflag = '0' ");
			employee.append("left join comm_coding_sort_detail d8 on h.post_sort = d8.coding_code_id and d8.bsflag = '0' ");
			employee.append("left join comm_coding_sort_detail d9 on h.language_sort = d9.coding_code_id and d9.bsflag = '0' ");
			employee.append("left join comm_coding_sort_detail d10 on h.language_level = d10.coding_code_id and d10.bsflag = '0' ");
			employee.append("left join comm_coding_sort_detail d11 on h.set_team = d11.coding_code_id ");
			employee.append("left join comm_coding_sort_detail d12 on h.set_post = d12.coding_code_id  ");
			employee.append("where e.bsflag = '0' ");
			employee.append("and e.employee_id='").append(id).append("'");
		}else{

			employee.append("select rownum,  l.labor_id, decode(l.labor_distribution, '0', '一线员工', '1', '境外员工', '2', '二线员工','4','三线员工','3','境外二三线',l.labor_distribution) labor_distribution,    decode(l.labor_category, '0', '临时季节性用工', '1', '再就业人员', '2', '劳务派遣人员', '3', '其他用工', l.labor_category) labor_category,    l.employee_name,       l.post,       l.apply_team,       d3.coding_name posts,       d4.coding_name apply_teams, ");
			employee.append(" l.employee_nation,       d1.coding_name employee_nation_name,       l.employee_gender,       l.owning_org_id,       l.owning_subjection_org_id,       i.org_name,");
			employee.append(" decode(l.employee_gender, '0', '女', '1', '男', l.employee_gender) employee_gender_name,    decode(l.if_project,  '0',   '不在项目',  '1', '在项目',  l.if_project) if_project_name, ");
			employee.append(" l.if_project,   l.if_engineer,   d5.coding_name if_engineer_name,    l.cont_num,   l.employee_birth_date,   l.employee_id_code_no,   l.employee_education_level,  d2.coding_name employee_education_level_name, ");
			employee.append(" l.employee_address,   l.phone_num,  l.postal_code,  l.employee_health_info,   l.mobile_number, l.specialty,   decode(nvl(l.elite_if, 0), '0', '否', '1', '是', l.elite_if) elite_if_name,l.workerfrom,  ");
			employee.append(" d6.coding_name workerfrom_name, l.technical_title,    d7.coding_name technical_title_name,   d8.coding_name nationality_name, lt.list_id,  case  when lt.list_id is null then  '否'  else  '是'  end fsflag, case  when lt.list_id is null then  ''  else  'red'  end bgcolor,   nvl(t.years, 0) years  ");
			employee.append(" from bgp_comm_human_labor l ");
			employee.append(" left join bgp_comm_human_labor_list lt on l.labor_id = lt.labor_id   and lt.bsflag = '0' ");
			employee.append(" left join comm_coding_sort_detail d1 on l.employee_nation = d1.coding_code_id");
			employee.append(" left join comm_coding_sort_detail d2 on l.employee_education_level = d2.coding_code_id  ");
			employee.append(" left join comm_coding_sort_detail d3 on l.post = d3.coding_code_id  ");
			employee.append(" left join comm_coding_sort_detail d4 on l.apply_team = d4.coding_code_id  ");
			employee.append(" left join comm_coding_sort_detail d5 on l.if_engineer = d5.coding_code_id ");
			employee.append(" left join comm_coding_sort_detail d6 on l.workerfrom = d6.coding_code_id ");
			employee.append(" left join comm_coding_sort_detail d7 on l.technical_title = d7.coding_code_id  ");
			employee.append(" left join comm_coding_sort_detail d8 on l.nationality = d8.coding_code_id  ");
			employee.append(" left join comm_org_subjection cn on l.owning_org_id = cn.org_id  ");
			employee.append(" left join comm_org_information i on l.owning_org_id = i.org_id  ");
			employee.append(" left join (select count(distinct to_char(t.start_date, 'yyyy')) years,  t.labor_id     from bgp_comm_human_labor_deploy t    group by t.labor_id) t  ");
			employee.append(" on l.labor_id = t.labor_id   where l.bsflag = '0'  ");
			employee.append(" and l.labor_id = '").append(id).append("'");
		}
		
		Map employeeMap = jdbcDAO.queryRecordBySQL(employee.toString());
	
		if (employeeMap != null) {
			responseMsg.setValue("employeeMap", employeeMap);
		}
		
		return responseMsg;
		
	}
	

	/**
	 * 临时工基本信息查看
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getLaborInfo(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		String laborId = reqDTO.getValue("laborId");

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer employee = new StringBuffer(
				"select rownum,  l.labor_id, decode(l.labor_distribution,'0','一线员工','1','境外一线','2','二线员工','4','三线员工','3','境外二三线', l.labor_distribution) labor_distribution,   decode(l.labor_category, '0', '临时季节性用工', '1', '再就业人员', '2', '劳务派遣人员', '3', '其他用工', l.labor_category) labor_category,    l.employee_name,       l.post,       l.apply_team,       d3.coding_name posts,       d4.coding_name apply_teams, ");
		employee.append("  l.employee_nation,    l.position_nationality, d11.coding_name position_name,decode(l.position_type,'0110000021000000003','技能操作类','0110000021000000002','专业技术类','0110000021000000001','管理类','')position_type,    d1.coding_name employee_nation_name,       l.employee_gender,       l.owning_org_id,       l.owning_subjection_org_id,       i.org_name,");
		employee.append("  decode(l.employee_gender, '0', '女', '1', '男', l.employee_gender) employee_gender_name,    decode(l.if_project,  '0',   '不在项目',  '1', '在项目',  l.if_project) if_project_name, ");
		employee.append("  l.if_project,   l.if_engineer,   d5.coding_name if_engineer_name,    l.cont_num,   l.employee_birth_date,   l.employee_id_code_no,   l.employee_education_level,  d2.coding_name employee_education_level_name, ");
		employee.append("  l.employee_address,   l.phone_num,  l.postal_code,  l.employee_health_info,   l.mobile_number, l.specialty,   decode(nvl(l.elite_if, 0), '0', '否', '1', '是', l.elite_if) elite_if_name,l.workerfrom,decode(l.household_type,'0','农业','1','非农业') household_type,  ");
		employee.append("  d6.coding_name workerfrom_name,     l.technical_title,    d7.coding_name technical_title_name,   d8.coding_name nationality_name, nvl(t.years, 0) years , ");
		employee.append("  decode(l.institutions_type,'0','境外项目','1','总部机关') institutions_type,l.grass_root_unit,l.go_abroad_time,l.home_time,nvl(d10.coding_name,l.present_state) present_state_name,l.now_start_date,l.implementation_date, ");
		employee.append("  l.account_place,l.start_salary_date,l.technical_time,l.post_sequence,l.post_exam,l.toefl_score,l.tofel_listening,decode(l.if_qualified,'0','是','1','否') if_qualified,l.nine_result,l.elite_if, ");
		employee.append("  decode(l.if_qualifieds,'0','是','1','否') if_qualifieds,l.holds_result  "); 
	    employee.append(" from bgp_comm_human_labor l ");
//		employee.append(" left join bgp_comm_human_labor_list lt    on l.labor_id = lt.labor_id   and lt.bsflag = '0' ");
		employee.append(" left join comm_coding_sort_detail d1    on l.employee_nation = d1.coding_code_id");
		employee.append(" left join comm_coding_sort_detail d2    on l.employee_education_level = d2.coding_code_id  ");
		employee.append(" left join comm_coding_sort_detail d3    on l.post = d3.coding_code_id  ");
		employee.append(" left join comm_coding_sort_detail d4    on l.apply_team = d4.coding_code_id  ");
		employee.append(" left join comm_coding_sort_detail d5    on l.if_engineer = d5.coding_code_id ");
		employee.append(" left join comm_coding_sort_detail d6    on l.workerfrom = d6.coding_code_id ");
		employee.append(" left join comm_coding_sort_detail d7    on l.technical_title = d7.coding_code_id  ");
		employee.append(" left join comm_coding_sort_detail d8    on l.nationality = d8.coding_code_id  ");
		employee.append(" left join comm_coding_sort_detail d10  on l.present_state = d10.coding_code_id  ");
		employee.append(" left join comm_coding_sort_detail d11  on l.position_nationality = d11.coding_code_id  ");
		
//		employee.append(" left join comm_org_subjection cn    on l.owning_org_id = cn.org_id  ");
		employee.append(" left join comm_org_information i    on l.owning_org_id = i.org_id  ");
		employee.append(" left join (select count(distinct to_char(t.start_date, 'yyyy')) years,    t.labor_id     from bgp_comm_human_labor_deploy t    group by t.labor_id) t  ");
		employee.append(" on l.labor_id = t.labor_id   where l.bsflag = '0'  ");

		Map employeeMap = new HashMap();
		if (null != laborId && !"".equals(laborId)) {
			employee.append("   and l.labor_id = '").append(laborId)
					.append("'");
			employeeMap = jdbcDAO.queryRecordBySQL(employee.toString());
		}

		if (employeeMap != null) {
			responseMsg.setValue("employeeMap", employeeMap);
		}

		// 工作履历
		StringBuffer record = new StringBuffer(
				"select rownum ,r.record_no, r.employee_id,to_char( r.start_date,'yyyy-MM-dd') start_date,decode(to_char(r.end_date,'yyyy'),'9999','至今',to_char( r.end_date,'yyyy-MM-dd')) end_date, ");
		record.append("  r.company,r.administration,r.technology,r.skill,r.post,d1.coding_name skillname from bgp_comm_human_record r ");
		record.append("  left join comm_coding_sort_detail d1 on r.skill = d1.coding_code_id");
		record.append("  where r.bsflag='0' and r.employee_id ='")
				.append(laborId).append("' order by r.start_date desc ");

		List<Map> recordMap = jdbcDAO.queryRecords(record.toString());

		if (recordMap != null && recordMap.size() > 0) {
			responseMsg.setValue("recordMap", recordMap);
		}

		// 培训信息
		StringBuffer train = new StringBuffer(
				"select rownum ,t.train_no, t.employee_id, to_char(t.start_date,'yyyy-MM-dd') start_date,to_char(t.end_date,'yyyy-MM-dd') end_date, ");
		train.append(" t.class_name,t.train_content,t.train_level,t.train_channel,t.train_sort,t.train_form,t.train_result,t.train_place ");
		train.append(
				" from bgp_comm_human_train t where t.bsflag='0' and t.employee_id ='")
				.append(laborId).append("'");

		List<Map> trainMap = jdbcDAO.queryRecords(train.toString());

		if (trainMap != null && trainMap.size() > 0) {
			responseMsg.setValue("trainMap", trainMap);
		}

		// 项目经历
		StringBuffer project = new StringBuffer(
				"select rownum,       pt.project_name,       pt.project_info_no,       d1.coding_name apply_team_name,       d2.coding_name post_name, ");
		project.append("    to_char(td.start_date,'yyyy-mm-dd')start_date,       to_char(td.end_date,'yyyy-mm-dd')end_date, lr.cont_num, ");
		project.append("      round(case   when nvl(td.end_date, sysdate) - td.start_date >= 0 then    nvl(td.end_date, sysdate) - td.start_date +1    else      0   end) plan_days  ");
		project.append("  from  ");
		project.append(" bgp_comm_human_labor_deploy td   ");
		project.append(" left join gp_task_project pt    on td.project_info_no = pt.project_info_no  ");
		project.append("  left join bgp_comm_human_deploy_detail dl    on dl.labor_deploy_id = td.labor_deploy_id  ");
		project.append("  left join comm_coding_sort_detail d1    on dl.apply_team = d1.coding_code_id  ");
		project.append("  left join comm_coding_sort_detail d2    on dl.post = d2.coding_code_id   left join   bgp_comm_human_labor lr       on lr.labor_id=td.labor_id  and lr.bsflag='0'   ");
		project.append("  where td.bsflag = '0'  ");

		project.append(" and td.labor_id ='").append(laborId).append("'   union all   select rownum,       pt.project_name,       pt.project_info_no,       d1.coding_name apply_team_name,       d2.coding_name post_name,     to_char(td.start_date,'yyyy-mm-dd') start_date,       to_char(td.end_date,'yyyy-mm-dd') end_date, lr.cont_num,       round(case   when nvl(td.end_date, sysdate) - td.start_date >= 0 then    nvl(td.end_date, sysdate) - td.start_date +1    else      0   end) plan_days    from   BGP_COMM_HUMAN_LABOR_PROJECT td    left join gp_task_project pt    on td.project_info_no = pt.project_info_no        left join comm_coding_sort_detail d1    on td.apply_team = d1.coding_code_id    left join comm_coding_sort_detail d2    on td.post = d2.coding_code_id    left join   bgp_comm_human_labor lr       on lr.labor_id=td.labor_id  and lr.bsflag='0'    where td.bsflag = '0'   and td.labor_id ='").append(laborId).append("'    ");

		project.append(" union all  select   rownum,  pt.project_name,   pt.project_info_no,  t.team_name apply_team_name ,t.work_post_name  post_name ,to_char(t.start_date,'yyyy-mm-dd') start_date,to_char(t.end_date,'yyyy-mm-dd') end_date,'' cont_num ,   round(case      when nvl(t.end_date, sysdate) - t.start_date >= 0 then    nvl(t.end_date, sysdate) - t.start_date + 1    else  0     end) plan_days  from BGP_COMM_HUMAN_PT_DETAIL t    left join gp_task_project pt   on t.bproject_info_no = pt.project_info_no    where t.bsflag='0' and t.end_date is not null and t.employee_id =	'").append(laborId).append("'    ");			
	
		List<Map> projectMap = jdbcDAO.queryRecords(project.toString());

		if (projectMap != null && projectMap.size() > 0) {
			responseMsg.setValue("projectMap", projectMap);
		}
		// 黑名单信息
		StringBuffer blackList = new StringBuffer(
				" select rownum,   pt.project_name,   pt.project_info_no,  l.labor_id,  l.employee_name,   l.employee_gender, ");
		blackList
				.append("  decode(l.employee_gender, '0', '女', '1', '男') employee_gender_name,   l.employee_id_code_no,   lt.list_id,   lt.list_reason,    to_char(lt.list_date,'yyyy-mm-dd')list_date,  ");
		blackList
				.append("    lt.notes,   lt.bl_status,  decode(lt.bl_status, '1', 'red', '2', 'gray', lt.bl_status) bgcolor  from bgp_comm_human_labor l  ");
		blackList
				.append("  left join bgp_comm_human_labor_list lt    on l.labor_id = lt.labor_id   and l.bsflag = '0'  ");
		blackList
				.append("  left join gp_task_project pt    on lt.project_info_no = pt.project_info_no  where lt.list_id is not null and lt.bsflag='0'  ");
		blackList.append(" and l.labor_id='").append(laborId)
				.append("'  order by rownum  ");
		List<Map> blackListMap = jdbcDAO.queryRecords(blackList.toString());

		if (blackListMap != null && blackListMap.size() > 0) {
			responseMsg.setValue("blackListMap", blackListMap);
		}

		StringBuffer education = new StringBuffer(
				"select to_char(t.start_date,'yyyy-MM-dd') start_date,to_char(t.finish_date,'yyyy-MM-dd') finish_date,t.school_name,t.profess,t.education from bgp_comm_human_education t ");
		education.append("where t.bsflag='0' and t.employee_id ='")
				.append(laborId).append("'");
		List<Map> educationMap = jdbcDAO.queryRecords(education.toString());

		if (educationMap != null && educationMap.size() > 0) {
			responseMsg.setValue("educationMap", educationMap);
		}

		return responseMsg;
	}

	public ISrvMsg deleteLaborInfo(ISrvMsg isrvmsg) throws Exception {

		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		String laborId = isrvmsg.getValue("laborId");
		jdbcDao.deleteEntity("bgp_comm_human_labor", laborId);
		return respMsg;
	}

	public ISrvMsg deleteUpdate(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String laborId = isrvmsg.getValue("laborId");
		String updateSql = "update bgp_comm_human_labor t set t.bsflag='1',modifi_date=sysdate where t.labor_id in ("
				+ laborId + ")";
		jdbcDao.executeUpdate(updateSql);
		return responseDTO;

	}

	public ISrvMsg deleteUpdateBlack(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String listId = isrvmsg.getValue("listId");
		String updateSql = "update BGP_COMM_HUMAN_LABOR_LIST t set t.bsflag='1',modifi_date=sysdate where t.list_id='"
				+ listId + "'";
		jdbcDao.executeUpdate(updateSql);
		return responseDTO;

	}

	public ISrvMsg deleteUpdateProjectInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String projectId = isrvmsg.getValue("projectId");
		String updateSql = "update bgp_project_human_relation set bsflag='1',modifi_date=sysdate where relation_no ='"
				+ projectId + "'";
		System.out.println(updateSql);
		jdbcDao.executeUpdate(updateSql);
		return responseDTO;

	}

	/**
	 * 进入人员项目经历查看或修改及新增页面
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg humanRelatView(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String subOrgId=user.getSubOrgIDofAffordOrg();
		String projectType=user.getProjectType();
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		}
//		if(subOrgId.equals("C105008")){
//			projectType="5000100004000000009"; //综合
//		}else if (subOrgId.equals("C105002001")){ // 国际深海
//			projectType="5000100004000000006";
//		}else{	// 陆地其他
//			projectType="5000100004000000001";
//		}
		
		String keyId = reqDTO.getValue("id");// 申请表主键

		if (keyId == null || "".equals(keyId)) {
			List list = new ArrayList();
			responseDTO.setValue("detailInfo", list);
		} else {

			String querySubSql = "select decode(hr.locked_if,"
					+ "              '0',"
					+ "              '待审核',"
					+ "              '1',"
					+ "              '审核通过',"
					+ "              '2',"
					+ "              '审核不通过') locked_if_name,"
					+ "       decode(he.EMPLOYEE_GENDER, '0', '男', '1', '女') employee_gender,"
					+ "       p.project_name,"
					+ "       hr.locked_if,"
					+ "       hr.relation_no,"
					+ "       hr.project_info_no,"
					+ "       hr.project_info_name,"
					+ "       hr.employee_id,"
					+ "       he.employee_name,"
					+ "       hr.plan_start_date,"
					+ "       he.org_id,"
					+ "       hr.plan_end_date,"
					+ "       hr.actual_start_date,"
					+ "       hr.actual_end_date,"
					+ "       hr.team,"
					+ "       sd.coding_name team_name,"
					+ "       hr.work_post,"
					+ "       sd2.coding_name work_post_name,"
					+ "       hr.project_evaluate,"
					+ "       hr.project_responsibility"
					+ "  from bgp_project_human_relation hr"
					+ "  left join comm_human_employee he on hr.employee_id = he.employee_id"
					+ "                                  and he.bsflag = '0'"
					+ "  left join comm_coding_sort_detail sd on hr.team = sd.coding_code_id"
					+ "                                      and sd.bsflag = '0'"
					+ "  left join comm_coding_sort_detail sd2 on hr.work_post ="
					+ "                                           sd2.coding_code_id"
					+ "                                       and sd2.bsflag = '0'"
					+ "  left join gp_task_project p on hr.project_info_no = p.project_info_no"
					+ "                             and p.bsflag = '0'"
					+ "  where hr.relation_no = '" + keyId + "'";

			List list = BeanFactory.getQueryJdbcDAO().queryRecords(querySubSql);
			responseDTO.setValue("detailInfo", list);
		}
		// 查询所有岗位不包含班组
		String sql = "select team.coding_code_id team,"
				+ "       team.coding_name teamname,"
				+ "       pos.coding_code_id apply_post,"
				+ "       pos.coding_name apply_postname"
				+ "  from (SELECT t.coding_sort_id,"
				+ "               t.coding_code_id,"
				+ "               t.coding_code,"
				+ "               t.coding_name"
				+ "          FROM comm_coding_sort_detail t"
				+ "         where t.coding_sort_id = '0110000001'  and t.coding_mnemonic_id='"+projectType+"' "
				+ "           and t.bsflag = '0'"
				+ "           and t.spare1='0'"
				+ "           and length(t.coding_code) = 2"
				+ "         order by t.coding_show_id) team,"
				+ "       comm_coding_sort_detail pos"
				+ " where team.coding_sort_id = pos.coding_sort_id and length(pos.coding_code) > 2"
				+ " and team.coding_code = Substr(pos.coding_code,0,2)";

		List postList = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		responseDTO.setValue("postList", postList);
		// 查询所有班组不含岗位
		String psql = "SELECT t.coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.coding_mnemonic_id='"+projectType+"' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) = 2 order by t.coding_show_id";
		List teamlist = BeanFactory.getQueryJdbcDAO().queryRecords(psql);
		responseDTO.setValue("teamList", teamlist);

		return responseDTO;
	}

	/**
	 * 进入人员项目经历保存，一个项目存多条
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg savehumanRelat(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));
		String deleteRowFlag = reqDTO.getValue("deleteRowFlag");
		String[] rowFlag = null;
		Map mapFlag = new HashMap();
		if (deleteRowFlag != null && !deleteRowFlag.equals("")) {
			rowFlag = deleteRowFlag.split(",");
			for (int i = 0; i < rowFlag.length; i++) {
				mapFlag.put(rowFlag[i], "true");
			}
		}

		for (int i = 0; i < equipmentSize; i++) {
			if (mapFlag.get(String.valueOf(i)) == null) {
				Map mapDetail = new HashMap();
				BgpProjectHumanRelation applyDetail = new BgpProjectHumanRelation();
				PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
						applyDetail);
				mapDetail = PropertiesUtil.describe(applyDetail);
				System.out.println(mapDetail);
				// String valueprojectEvaluate =
				// String.valueOf(mapDetail.get("project_evaluate"));

				// System.out.println(URLDecoder.decode(valueprojectEvaluate,
				// "UTF-8"));
				// mapDetail.put("project_evaluate",
				// URLDecoder.decode(valueprojectEvaluate, "UTF-8"));

				mapDetail.put("project_info_no", projectInfoNo);
				mapDetail.put("bsflag", "0");
				mapDetail.put("locked_if", "0");
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modifi_date", new Date());

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"bgp_project_human_relation");
			}
		}

		return responseDTO;
	}

	/*
	 * 查询岗位列表
	 */
	public ISrvMsg queryApplyPostList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String applyTeam = reqDTO.getValue("applyTeam");

		StringBuffer sb = new StringBuffer(
				" SELECT t.coding_code_id AS value, t.coding_name AS label FROM comm_coding_sort_detail t, (select coding_sort_id, coding_code ");
		sb.append(" from comm_coding_sort_detail where coding_code_id = '")
				.append(applyTeam).append("' and bsflag='0' ) d ");
		sb.append(" where t.coding_sort_id = d.coding_sort_id and t.bsflag = '0' and t.coding_code like d.coding_code||'_%'  order by t.coding_show_id ");

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}

	/**
	 * 进入人员项目经历保存，一个人存多条
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg savehumanRela(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String employeeId = reqDTO.getValue("employeeId1");

		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize1"));
		String deleteRowFlag = reqDTO.getValue("deleteRowFlag1");
		String[] rowFlag = null;
		Map mapFlag = new HashMap();
		if (deleteRowFlag != null && !deleteRowFlag.equals("")) {
			rowFlag = deleteRowFlag.split(",");
			for (int i = 0; i < rowFlag.length; i++) {
				mapFlag.put(rowFlag[i], "true");
			}
		}

		for (int i = 0; i < equipmentSize; i++) {
			if (mapFlag.get(String.valueOf(i)) == null) {
				Map mapDetail = new HashMap();
				BgpProjectHumanRelation applyDetail = new BgpProjectHumanRelation();
				PropertiesUtil.msgToPojo("f" + String.valueOf(i), reqDTO,
						applyDetail);
				mapDetail = PropertiesUtil.describe(applyDetail);

				mapDetail.put("employee_id", employeeId);
				mapDetail.put("bsflag", "0");
				mapDetail.put("locked_if", "0");
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modifi_date", new Date());

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"bgp_project_human_relation");
			}
		}

		return responseDTO;
	}


	/*
	 * 文化程度
	 */
	public ISrvMsg queryDegreeOps(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer(
				"SELECT t.coding_code_id AS value, t.coding_name AS label  FROM comm_coding_sort_detail t where t.coding_sort_id = '0500100004'   and t.bsflag = '0'  order by t.coding_show_id ");
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}
	

	public ISrvMsg queryLaborAcceptReturnList(ISrvMsg reqDTO) throws Exception {
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
				
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
	    String laborCategory = reqDTO.getValue("laborCategory");
		String yorn = reqDTO.getValue("yorn");
		String employeeName = reqDTO.getValue("employee_name");
		String apply_team = reqDTO.getValue("apply_team");
		String post = reqDTO.getValue("post");
		String ids = reqDTO.getValue("ids");
		String s_fen = reqDTO.getValue("sfen");
 
		String szFather = reqDTO.getValue("szFather"); //这个值是区分弹出的接收父项目人员的页面
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			pageSize = "10";
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		
		String projectType = user.getProjectType();	
		String projectTypeJz = user.getProjectType();	
		
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		} 
		if(projectType.equals("5000100004000000002")){
			projectType="5000100004000000001";
		}
		 
		String fatherIdSql= " select t.project_info_no,t.project_father_no ,t.project_name   from gp_task_project  t  where  t.project_info_no='"+user.getProjectInfoNo()+"' and  t.bsflag='0' and t.project_father_no is not  null ";
		String fatherId=""; //根据本项目查询 是否有上级父项目
		List listFsql = BeanFactory.getQueryJdbcDAO().queryRecords(fatherIdSql);
	 	for(int i=0;i<listFsql.size();i++){
			Map map = (Map)listFsql.get(i);
			fatherId = (String)map.get("projectFatherNo");
		}
	 	
		
		StringBuffer sql = new StringBuffer("  select *  from (" +
				"select t.* from  (  select dt.employee_gz if_engineer,'' project_father_no,'' receive_no, 'add' emp_type,  dt.ptdetail_id  labor_deploy_id,'0' sz_type,'' zy_type ,case  when dt.locked_if is null  then '' else 'disabled' end disasss,     '' zy_sf,dt.employee_id labor_id,dt.employee_name,dt.employee_cd  employee_id_code_no     ,t.project_info_no,dt.start_date,l.cont_num,dt.end_date ,dt.start_date actual_start_date,'' deploy_detail_id,dt.team_s apply_team,dt.post_s post, dt.team_name apply_team_name ,dt.work_post_name post_name,round(case  when nvl(dt.end_date, sysdate) -   dt.start_date > 0 then   nvl(dt.end_date, sysdate) - dt.start_date - (-1)   else     0    end) days, to_date(to_char(t.create_date,'yyyy-MM-dd'),'yyyy-MM-dd') create_dates,dt.bsflag     from  BGP_COMM_HUMAN_PT_DETAIL dt    left join comm_coding_sort_detail cd3 on dt.notes = cd3.coding_code_id    left join gp_task_project t on dt.bproject_info_no= t.project_info_no   left join bgp_comm_human_labor l on dt.employee_id = l.labor_id    where   dt.pk_ids='add' and dt.bproject_info_no='").append(projectInfoNo).append("'" );
		sql.append(" union  all　select distinct l.if_engineer, t.project_father_no ,clr.receive_no,  'edit' emp_type,   t.labor_deploy_id,'0' sz_type,t.zy_type,case  when t.zy_type is null  then '' else 'disabled' end disasss,case  when t.zy_type is null  then '' else '是' end zy_sf,t.labor_id,l.employee_name,l.employee_id_code_no,t.project_info_no,t.start_date,l.cont_num, ");
		sql.append("t.end_date,case when    clr.receive_no is null  then  t.actual_start_date  else  nvl(t.actual_start_date,t.start_date) end actual_start_date,d2.deploy_detail_id,d2.apply_team,d2.post,d3.coding_name apply_team_name,d4.coding_name post_name,round( case when nvl(t.end_date, sysdate) - t.start_date > 0 then nvl(t.end_date, sysdate) - t.start_date  -(-1) else 0 end ) days ,    to_date(to_char(t.create_date,'yyyy-MM-dd'),'yyyy-MM-dd') create_dates ,t.bsflag  from bgp_comm_human_labor_deploy t ");
		sql.append("left join bgp_comm_human_deploy_detail d2 on t.labor_deploy_id = d2.labor_deploy_id    left join bgp_comm_human_labor l on t.labor_id = l.labor_id   left join comm_coding_sort_detail d3 on d2.apply_team = d3.coding_code_id  and d3.bsflag = '0'  and d3.coding_mnemonic_id='"+projectType+"'  ");
		sql.append(" left join comm_coding_sort_detail d4 on d2.post = d4.coding_code_id  and d4.bsflag = '0'  and d4.coding_mnemonic_id='"+projectType+"'    left   join  bgp_comm_human_receive_labor clr    on clr.deploy_detail_id= d2.deploy_detail_id  and clr.bsflag='0' where      t.between_param  is null   and t.project_info_no ='").append(projectInfoNo).append("'　 ) t  where 1 = 1 　");
	    
		//区分 弹出的接收父项目人员的页面
		if (szFather == "0" || "0".equals(szFather)) {
			sql.append("and t.project_father_no is  null ");
		}
		
		// 已返还
		if (yorn == "3" || "3".equals(yorn)) {
			sql.append("and t.end_date is not null and  t.bsflag='0' ");
			
		}else if (yorn == "4" || "4".equals(yorn)) { // 未返还
			
			if(projectTypeJz.equals("5000100004000000008") || projectTypeJz.equals("5000100004000000009") ){
				sql.append("and t.end_date is null  and  t.actual_start_date  is not null  and  t.bsflag='0' ");
			}else{ 
				sql.append("and t.end_date is null  and t.receive_no is not null  and  t.bsflag='0'  ");
			}
			
	
		} 

		
		if (employeeName != null) {
			sql.append(" and t.employee_name like'%").append(employeeName).append("%' ");
		}  
		if (apply_team != null) {
			sql.append(" and t.apply_team='").append(apply_team).append("' ");
		} 
		if (post != null) {
			sql.append(" and t.post='").append(post).append("' ");
		} 
		if (s_fen != null && !"".equals(s_fen)) {
			
			if(projectTypeJz.equals("5000100004000000008") || projectTypeJz.equals("5000100004000000009") ){
			 
				if(s_fen.equals("1")){
					sql.append("and  t.actual_start_date  is not null and  t.bsflag='0' ");
				}else if (s_fen.equals("0")){
					sql.append("and  t.actual_start_date  is  null and  t.bsflag='0'  ");
				} else if (s_fen.equals("3")){
					sql.append("and  t.bsflag='1'  ");
				} 
				 
				
			}else{ 

				if(s_fen.equals("1")){
					sql.append(" and t.receive_no is not null and  t.bsflag='0'  ");
				}else if (s_fen.equals("0")){
					sql.append(" and t.receive_no is   null  and  t.bsflag='0'  ");
				}
				 
			}
			
			
		}		
		if (laborCategory != null && !"".equals(laborCategory)) { 
			sql.append(" and t.if_engineer ='").append(laborCategory).append("' ");
		}
		
		
		if (ids != null && !"".equals(ids)) {
			sql.append("and t.labor_deploy_id in (").append(ids).append(") ");
		}
		
		if (szFather == null || szFather.trim().equals("")) { 
			 if (fatherId !=null && !"".equals(fatherId)){  // 父项目人员
				 
					sql.append(" union all  select distinct  l.if_engineer, t.project_father_no ,clr.receive_no,   'edit' emp_type,  t.labor_deploy_id,'1' sz_type,t.zy_type,case  when t.zy_type is null  then '' else 'disabled' end disasss,case  when t.zy_type is null  then '' else '是' end zy_sf,t.labor_id,l.employee_name,l.employee_id_code_no,t.project_info_no,t.start_date,l.cont_num, ");
					sql.append("t.end_date,case when    clr.receive_no is null  then  t.actual_start_date  else  nvl(t.actual_start_date,t.start_date) end actual_start_date,d2.deploy_detail_id,d2.apply_team,d2.post,d3.coding_name apply_team_name,d4.coding_name post_name,round( case when nvl(t.end_date, sysdate) - t.start_date > 0 then nvl(t.end_date, sysdate) - t.start_date  -(-1) else 0 end ) days ,    to_date(to_char(t.create_date,'yyyy-MM-dd'),'yyyy-MM-dd') create_dates ,t.bsflag   from bgp_comm_human_labor_deploy t ");
					sql.append("left join bgp_comm_human_deploy_detail d2 on t.labor_deploy_id = d2.labor_deploy_id   left join bgp_comm_human_labor l on t.labor_id = l.labor_id   left join comm_coding_sort_detail d3 on d2.apply_team = d3.coding_code_id  and d3.bsflag = '0'  and d3.coding_mnemonic_id='"+projectType+"'  ");
					sql.append(" left join comm_coding_sort_detail d4 on d2.post = d4.coding_code_id  and d4.bsflag = '0'  and d4.coding_mnemonic_id='"+projectType+"'    left   join  bgp_comm_human_receive_labor clr    on clr.deploy_detail_id= d2.deploy_detail_id  and clr.bsflag='0' where    t.between_param  is null and   t.project_father_no='").append(projectInfoNo).append("'  and t.project_info_no = '").append(fatherId).append("'  ");
					
			  
					// 已返还
					if (yorn == "3" || "3".equals(yorn)) {
						sql.append("and t.end_date is not null and  t.bsflag='0'  ");
					}else if (yorn == "4" || "4".equals(yorn)) {
						 
						if(projectTypeJz.equals("5000100004000000008") || projectTypeJz.equals("5000100004000000009") ){
							sql.append("and t.end_date is null  and  t.actual_start_date  is not null and  t.bsflag='0' ");
						}else{ 
							sql.append("and t.end_date is null  and clr.receive_no is not null and  t.bsflag='0'  ");
						}
						
						
					} 

					
					if (employeeName != null) {
						sql.append(" and l.employee_name like'%").append(employeeName).append("%' ");
					}  
					if (apply_team != null) {
						sql.append(" and d2.apply_team='").append(apply_team).append("' ");
					} 
					if (post != null) {
						sql.append(" and d2.post='").append(post).append("' ");
					} 
					if (s_fen != null && !"".equals(s_fen)) {

						if(projectTypeJz.equals("5000100004000000008") || projectTypeJz.equals("5000100004000000009") ){
							 
							if(s_fen.equals("1")){
								sql.append("and  t.actual_start_date  is not null and  t.bsflag='0'  ");
							}else if (s_fen.equals("0")){
								sql.append("and  t.actual_start_date  is  null and  t.bsflag='0'  ");
							}else if (s_fen.equals("3")){
								sql.append("and  t.bsflag='1' ");
							}
							 
							
						}else{ 
							if(s_fen.equals("1")){
								sql.append(" and clr.receive_no is not null  and  t.bsflag='0' ");
							}else if (s_fen.equals("0")){
								sql.append(" and clr.receive_no is   null  and  t.bsflag='0'   ");
							}
							
						}
						
						 
					}		
					if (laborCategory != null && !"".equals(laborCategory)) { 
						sql.append(" and l.if_engineer ='").append(laborCategory).append("' ");
					}
					
					
					if (ids != null && !"".equals(ids)) {
						sql.append("and t.labor_deploy_id in (").append(ids).append(") ");
					}
					
			 }
		}
		sql.append(" ) ttt  order by ttt.create_dates desc  "); 
 
		List<Map> list =  BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		page = jdbcDAO.queryRecordsBySQL(sql.toString(), page);
		
		list = page.getData(); 		
		msg.setValue("datas", list);
		msg.setValue("yorn", yorn);
		msg.setValue("projectInfoNo", projectInfoNo);
		msg.setValue("laborCategory", laborCategory);
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		return msg;
	}

	/**
	 * 人工成本计划导入综合
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanCostExcleZh(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);	
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		UserToken user = reqDTO.getUserToken();
		
		String costState = reqDTO.getValue("costState");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String plan_id = reqDTO.getValue("planId");
		String projectType = reqDTO.getValue("projectType");
		String projectName = reqDTO.getValue("projectName");
		projectName =URLDecoder.decode(projectName, "utf-8");
		
		String planId="";
		
		SimpleDateFormat datetemp=new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList != null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			
			Map costMap = new HashMap();	
			costMap.put("cost_state", costState);
			costMap.put("project_info_no", projectInfoNo);
			
			List<Map> planlist = new ArrayList<Map>();
			List<Map> salalist = new ArrayList<Map>();
			
			try{		
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx")==-1) {		
					book = new HSSFWorkbook(new POIFSFileSystem(new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);  						
				}else{
					book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					sheet = book.getSheetAt(0);							
				}
			
				if(sheet != null ){  
					
					String sql1 = "update bgp_comm_human_plan_cost t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
					jdbcDao.getJdbcTemplate().update(sql1);
					String sql2 = "update bgp_comm_human_cost_plan t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
					jdbcDao.getJdbcTemplate().update(sql2);
					String sql3 = "update bgp_comm_human_cost_plan_deta t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
					jdbcDao.getJdbcTemplate().update(sql3);
					String sql4 = "update bgp_comm_human_cost_plan_sala t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
					jdbcDao.getJdbcTemplate().update(sql4);
					
					costMap.put("bsflag", "0");
					costMap.put("apply_date", new Date());
					costMap.put("create_date", new Date());
					costMap.put("modifi_date", new Date());
					costMap.put("creator",user.getEmpId());
					costMap.put("org_id", user.getOrgId());
					costMap.put("org_subjection_id", user.getOrgSubjectionId());
					
					//1
					Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(costMap,"bgp_comm_human_plan_cost");
					  planId = id.toString();
					//2		
						//costMap.put("plan_id", planId);		
						//BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(costMap,"bgp_comm_human_cost_plan");
				    //3	
					
					
					//制度工资
					row = sheet.getRow(42);	
					Map tempMap = new HashMap();
					Cell ss=row.getCell(3);	//纵向从零开始
					String value ="0";
					if (ss != null && !"".equals(ss.toString())) {
						ss.setCellType(1); 
						value = ss.getStringCellValue().trim();
						tempMap.put("cont_cost", value);//合同化
					}
					
					row = sheet.getRow(52);	
					Cell ss2=row.getCell(3); 
					String value2 ="0";
					if (ss2 != null && !"".equals(ss2.toString())) {
						ss2.setCellType(1); 
						value2 = ss2.getStringCellValue().trim();
						tempMap.put("mark_cost", value2);//市场化
					}
  
					tempMap.put("subject_id", "0000000003000000803");
					tempMap.put("sum_human_cost", Double.parseDouble(value)+Double.parseDouble(value2)); 
					tempMap.put("creator", user.getEmpId());
					tempMap.put("create_date", new Date());
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date());
					tempMap.put("bsflag", "0");
					tempMap.put("project_info_no",projectInfoNo);
					tempMap.put("cost_state", costState);
					tempMap.put("plan_id", planId);	
					tempMap.put("org_id", user.getOrgId());
					tempMap.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMap,"bgp_comm_human_cost_plan_sala");
					
					
					//地区补贴
					row = sheet.getRow(43);	
					Map tempMapA = new HashMap();
					Cell ss3=row.getCell(3);	//纵向从零开始
					String value3 ="0";
					if (ss3 != null && !"".equals(ss3.toString())) {
						ss3.setCellType(1); 
						value3 = ss3.getStringCellValue().trim();
						tempMapA.put("cont_cost", value3);//合同化
					}
					
					row = sheet.getRow(53);	
					Cell ss4=row.getCell(3); 
					String value4 ="0";
					if (ss4 != null && !"".equals(ss4.toString())) {
						ss4.setCellType(1); 
						value4 = ss4.getStringCellValue().trim();
						tempMapA.put("mark_cost", value4);//市场化
					}
					tempMapA.put("subject_id", "0000000003000000804");
					tempMapA.put("sum_human_cost", Double.parseDouble(value3)+Double.parseDouble(value4)); 
					tempMapA.put("creator", user.getEmpId());
					tempMapA.put("create_date", new Date());
					tempMapA.put("updator", user.getEmpId());
					tempMapA.put("modifi_date", new Date());
					tempMapA.put("bsflag", "0");
					tempMapA.put("project_info_no",projectInfoNo);
					tempMapA.put("cost_state", costState);
					tempMapA.put("plan_id", planId);	
					tempMapA.put("org_id", user.getOrgId());
					tempMapA.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMapA,"bgp_comm_human_cost_plan_sala");
					
					//休假工资
					row = sheet.getRow(46);	
					Map tempMapB = new HashMap();
					Cell ss5=row.getCell(3);	//纵向从零开始
					String value5 ="0";
					if (ss5 != null && !"".equals(ss5.toString())) {
						ss5.setCellType(1); 
						value5 = ss5.getStringCellValue().trim();
						tempMapB.put("cont_cost", value5);//合同化
					}
					
					row = sheet.getRow(56);	
					Cell ss6=row.getCell(3);	 
					String value6 ="0";
					if (ss6 != null && !"".equals(ss6.toString())) {
						ss6.setCellType(1); 
						value6 = ss6.getStringCellValue().trim();
						tempMapB.put("mark_cost", value6);//市场化
					}
					tempMapB.put("subject_id", "0000000003000000805");
					tempMapB.put("sum_human_cost", Double.parseDouble(value5)+Double.parseDouble(value6)); 
					tempMapB.put("creator", user.getEmpId());
					tempMapB.put("create_date", new Date());
					tempMapB.put("updator", user.getEmpId());
					tempMapB.put("modifi_date", new Date());
					tempMapB.put("bsflag", "0");
					tempMapB.put("project_info_no",projectInfoNo);
					tempMapB.put("cost_state", costState);
					tempMapB.put("plan_id", planId);	
					tempMapB.put("org_id", user.getOrgId());
					tempMapB.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMapB,"bgp_comm_human_cost_plan_sala");
					
					
					//奖金
					row = sheet.getRow(47);	
					Map tempMapC = new HashMap();
					Cell ss7=row.getCell(3);	//纵向从零开始
					String value7 ="0";
					if (ss7 != null && !"".equals(ss7.toString())) {
						ss7.setCellType(1); 
						value7 = ss7.getStringCellValue().trim();
						tempMapC.put("cont_cost", value7);//合同化
					}
					
					row = sheet.getRow(57);	
					Cell ss8=row.getCell(3);	   
					String value8 ="0";
					if (ss8 != null && !"".equals(ss8.toString())) {
						ss8.setCellType(1); 
						value8 = ss8.getStringCellValue().trim();
						tempMapC.put("mark_cost", value8);//市场化
					}
					
					tempMapC.put("subject_id", "0000000003000000806");
					tempMapC.put("sum_human_cost", Double.parseDouble(value7)+Double.parseDouble(value8)); 
					tempMapC.put("creator", user.getEmpId());
					tempMapC.put("create_date", new Date());
					tempMapC.put("updator", user.getEmpId());
					tempMapC.put("modifi_date", new Date());
					tempMapC.put("bsflag", "0");
					tempMapC.put("project_info_no",projectInfoNo);
					tempMapC.put("cost_state", costState);
					tempMapC.put("plan_id", planId);	
					tempMapC.put("org_id", user.getOrgId());
					tempMapC.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMapC,"bgp_comm_human_cost_plan_sala");
					
					
					//误餐费
					row = sheet.getRow(48);	
					Map  tempMapD = new HashMap ();
					Cell ss9=row.getCell(3);	//纵向从零开始
					String value9 ="0";
					if (ss9 != null && !"".equals(ss9.toString())) {
						ss9.setCellType(1); 
						value9 = ss9.getStringCellValue().trim();
						tempMapD.put("cont_cost", value9);//合同化
					}
					
					row = sheet.getRow(58);	
					Cell ss10=row.getCell(3);	  
					String value10 ="0";
					if (ss10 != null && !"".equals(ss10.toString())) {
						ss10.setCellType(1); 
						value10 = ss10.getStringCellValue().trim();
						tempMapD.put("mark_cost", value10);// 市场化
					}
					 
					tempMapD.put("subject_id", "0000000003000000807");
					tempMapD.put("sum_human_cost", Double.parseDouble(value9)+Double.parseDouble(value10)); 
					tempMapD.put("creator", user.getEmpId());
					tempMapD.put("create_date", new Date());
					tempMapD.put("updator", user.getEmpId());
					tempMapD.put("modifi_date", new Date());
					tempMapD.put("bsflag", "0");
					tempMapD.put("project_info_no",projectInfoNo);
					tempMapD.put("cost_state", costState);
					tempMapD.put("plan_id", planId);	
					tempMapD.put("org_id", user.getOrgId());
					tempMapD.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMapD,"bgp_comm_human_cost_plan_sala");
					
					
					//劳务费
					row = sheet.getRow(62);	
					Map  tempMapE = new HashMap ();
					Cell ss11=row.getCell(3);	//纵向从零开始
					String value11 ="0";
					if (ss11 != null && !"".equals(ss11.toString())) {
						ss11.setCellType(1); 
						value11 = ss11.getStringCellValue().trim();
						tempMapE.put("reem_cost", value11);//再就业
					}
					
					row = sheet.getRow(66);	
					Cell ss12=row.getCell(3);	 
					String value12 ="0";
					if (ss12 != null && !"".equals(ss12.toString())) {
						ss12.setCellType(1); 
						value12 = ss12.getStringCellValue().trim();
						tempMapE.put("recruit_cost", value12);//招聘骨干
					}
					
					row = sheet.getRow(69);	
					Cell ss13=row.getCell(3);	 
					String value13 ="0";
					if (ss13 != null && !"".equals(ss13.toString())) {
						ss13.setCellType(1); 
						value13 = ss13.getStringCellValue().trim();
						tempMapE.put("worker_cost", value13);//外雇工
					} 
					
					tempMapE.put("subject_id", "0000000003000000808");
					tempMapE.put("sum_human_cost", Double.parseDouble(value11)+Double.parseDouble(value12)+Double.parseDouble(value13)); 
					tempMapE.put("creator", user.getEmpId());
					tempMapE.put("create_date", new Date());
					tempMapE.put("updator", user.getEmpId());
					tempMapE.put("modifi_date", new Date());
					tempMapE.put("bsflag", "0");
					tempMapE.put("project_info_no",projectInfoNo);
					tempMapE.put("cost_state", costState);
					tempMapE.put("plan_id", planId);	
					tempMapE.put("org_id", user.getOrgId());
					tempMapE.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMapE,"bgp_comm_human_cost_plan_sala");
				 
			   }
					
			 	
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}	 
			responseMsg.setValue("projectInfoNo", projectInfoNo);
			responseMsg.setValue("projectType", projectType);
			responseMsg.setValue("projectName",java.net.URLEncoder.encode(projectName,"utf-8"));
			responseMsg.setValue("planIds", planId);
			responseMsg.setValue("costState", costState);
			responseMsg.setValue("message", "1");
			responseMsg.setValue("pBackUrl", "/rm/em/singleHuman/humanCostPlan/humanCostPlanList.jsp");
			
		}		
		
		return responseMsg;		
	}
	
	
	/**
	 * 人工成本计划导入综合补充
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanExcleZhsupply(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);	
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		UserToken user = reqDTO.getUserToken();
		
		String costState = reqDTO.getValue("costState");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String plan_id = reqDTO.getValue("planId");
		String projectType = reqDTO.getValue("projectType");
	 
		
		String planId="";
		
		SimpleDateFormat datetemp=new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList != null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			
			Map costMap = new HashMap();	
			costMap.put("cost_state", costState);
			costMap.put("project_info_no", projectInfoNo);
			
			List<Map> planlist = new ArrayList<Map>();
			List<Map> salalist = new ArrayList<Map>();
			
			try{		
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx")==-1) {		
					book = new HSSFWorkbook(new POIFSFileSystem(new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);  						
				}else{
					book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					sheet = book.getSheetAt(0);							
				}
			
				if(sheet != null ){  
					if(plan_id != null ){   
						String sql1 = "update bgp_comm_human_plan_cost t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
						jdbcDao.getJdbcTemplate().update(sql1);
						String sql2 = "update bgp_comm_human_cost_plan t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
						jdbcDao.getJdbcTemplate().update(sql2);
						String sql3 = "update bgp_comm_human_cost_plan_deta t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
						jdbcDao.getJdbcTemplate().update(sql3);
						String sql4 = "update bgp_comm_human_cost_plan_sala t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
						jdbcDao.getJdbcTemplate().update(sql4);
					}
					
				
					
					String planNo = EquipmentAutoNum.generateNumberByUserToken(
							reqDTO.getUserToken(), "RGCB");
 
					//申请理由
					row = sheet.getRow(2);	
					Cell ssA=row.getCell(2);	//纵向从零开始
					String apply_reason ="";
					if (ssA != null && !"".equals(ssA.toString())) {
						ssA.setCellType(1); 
						apply_reason = ssA.getStringCellValue().trim();
						costMap.put("apply_reason", apply_reason); 
					}
	
					costMap.put("bsflag", "0");
					costMap.put("spare5", "1");
					costMap.put("plan_no", planNo);
 
					costMap.put("apply_date", new Date());
					costMap.put("create_date", new Date());
					costMap.put("modifi_date", new Date());
					costMap.put("creator",user.getEmpId());
					costMap.put("org_id", user.getOrgId());
					costMap.put("org_subjection_id", user.getOrgSubjectionId());
					
					//1
					Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(costMap,"bgp_comm_human_plan_cost");
					  planId = id.toString();
					//2		
						//costMap.put("plan_id", planId);		
						//BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(costMap,"bgp_comm_human_cost_plan");
				    //3	
					
					
					//制度工资
					row = sheet.getRow(43);	
					Map tempMap = new HashMap();
					Cell ss=row.getCell(3);	//纵向从零开始
					String value ="0";
					if (ss != null && !"".equals(ss.toString())) {
						ss.setCellType(1); 
						value = ss.getStringCellValue().trim();
						tempMap.put("cont_cost", value);//合同化
					}
					
					row = sheet.getRow(53);	
					Cell ss2=row.getCell(3); 
					String value2 ="0";
					if (ss2 != null && !"".equals(ss2.toString())) {
						ss2.setCellType(1); 
						value2 = ss2.getStringCellValue().trim();
						tempMap.put("mark_cost", value2);//市场化
					}
  
					tempMap.put("subject_id", "0000000003000000803");
					tempMap.put("sum_human_cost", Double.parseDouble(value)+Double.parseDouble(value2)); 
					tempMap.put("creator", user.getEmpId());
					tempMap.put("create_date", new Date());
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date());
					tempMap.put("bsflag", "0");
					tempMap.put("spare5", "1"); 
					tempMap.put("project_info_no",projectInfoNo);
					tempMap.put("cost_state", costState);
					tempMap.put("plan_id", planId);	
					tempMap.put("org_id", user.getOrgId());
					tempMap.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMap,"bgp_comm_human_cost_plan_sala");
					
					
					//地区补贴
					row = sheet.getRow(44);	
					Map tempMapA = new HashMap();
					Cell ss3=row.getCell(3);	//纵向从零开始
					String value3 ="0";
					if (ss3 != null && !"".equals(ss3.toString())) {
						ss3.setCellType(1); 
						value3 = ss3.getStringCellValue().trim();
						tempMapA.put("cont_cost", value3);//合同化
					}
					
					row = sheet.getRow(54);	
					Cell ss4=row.getCell(3); 
					String value4 ="0";
					if (ss4 != null && !"".equals(ss4.toString())) {
						ss4.setCellType(1); 
						value4 = ss4.getStringCellValue().trim();
						tempMapA.put("mark_cost", value4);//市场化
					}
					tempMapA.put("subject_id", "0000000003000000804");
					tempMapA.put("sum_human_cost", Double.parseDouble(value3)+Double.parseDouble(value4)); 
					tempMapA.put("creator", user.getEmpId());
					tempMapA.put("create_date", new Date());
					tempMapA.put("updator", user.getEmpId());
					tempMapA.put("modifi_date", new Date());
					tempMapA.put("bsflag", "0");tempMapA.put("spare5", "1"); 
					tempMapA.put("project_info_no",projectInfoNo);
					tempMapA.put("cost_state", costState);
					tempMapA.put("plan_id", planId);	
					tempMapA.put("org_id", user.getOrgId());
					tempMapA.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMapA,"bgp_comm_human_cost_plan_sala");
					
					//休假工资
					row = sheet.getRow(47);	
					Map tempMapB = new HashMap();
					Cell ss5=row.getCell(3);	//纵向从零开始
					String value5 ="0";
					if (ss5 != null && !"".equals(ss5.toString())) {
						ss5.setCellType(1); 
						value5 = ss5.getStringCellValue().trim();
						tempMapB.put("cont_cost", value5);//合同化
					}
					
					row = sheet.getRow(57);	
					Cell ss6=row.getCell(3);	 
					String value6 ="0";
					if (ss6 != null && !"".equals(ss6.toString())) {
						ss6.setCellType(1); 
						value6 = ss6.getStringCellValue().trim();
						tempMapB.put("mark_cost", value6);//市场化
					}
					tempMapB.put("subject_id", "0000000003000000805");
					tempMapB.put("sum_human_cost", Double.parseDouble(value5)+Double.parseDouble(value6)); 
					tempMapB.put("creator", user.getEmpId());
					tempMapB.put("create_date", new Date());
					tempMapB.put("updator", user.getEmpId());
					tempMapB.put("modifi_date", new Date());
					tempMapB.put("bsflag", "0");tempMapB.put("spare5", "1"); 
					tempMapB.put("project_info_no",projectInfoNo);
					tempMapB.put("cost_state", costState);
					tempMapB.put("plan_id", planId);	
					tempMapB.put("org_id", user.getOrgId());
					tempMapB.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMapB,"bgp_comm_human_cost_plan_sala");
					
					
					//奖金
					row = sheet.getRow(48);	
					Map tempMapC = new HashMap();
					Cell ss7=row.getCell(3);	//纵向从零开始
					String value7 ="0";
					if (ss7 != null && !"".equals(ss7.toString())) {
						ss7.setCellType(1); 
						value7 = ss7.getStringCellValue().trim();
						tempMapC.put("cont_cost", value7);//合同化
					}
					
					row = sheet.getRow(58);	
					Cell ss8=row.getCell(3);	   
					String value8 ="0";
					if (ss8 != null && !"".equals(ss8.toString())) {
						ss8.setCellType(1); 
						value8 = ss8.getStringCellValue().trim();
						tempMapC.put("mark_cost", value8);//市场化
					}
					
					tempMapC.put("subject_id", "0000000003000000806");
					tempMapC.put("sum_human_cost", Double.parseDouble(value7)+Double.parseDouble(value8)); 
					tempMapC.put("creator", user.getEmpId());
					tempMapC.put("create_date", new Date());
					tempMapC.put("updator", user.getEmpId());
					tempMapC.put("modifi_date", new Date());
					tempMapC.put("bsflag", "0");tempMapC.put("spare5", "1"); 
					tempMapC.put("project_info_no",projectInfoNo);
					tempMapC.put("cost_state", costState);
					tempMapC.put("plan_id", planId);	
					tempMapC.put("org_id", user.getOrgId());
					tempMapC.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMapC,"bgp_comm_human_cost_plan_sala");
					
					
					//误餐费
					row = sheet.getRow(49);	
					Map  tempMapD = new HashMap ();
					Cell ss9=row.getCell(3);	//纵向从零开始
					String value9 ="0";
					if (ss9 != null && !"".equals(ss9.toString())) {
						ss9.setCellType(1); 
						value9 = ss9.getStringCellValue().trim();
						tempMapD.put("cont_cost", value9);//合同化
					}
					
					row = sheet.getRow(59);	
					Cell ss10=row.getCell(3);	  
					String value10 ="0";
					if (ss10 != null && !"".equals(ss10.toString())) {
						ss10.setCellType(1); 
						value10 = ss10.getStringCellValue().trim();
						tempMapD.put("mark_cost", value10);// 市场化
					}
					 
					tempMapD.put("subject_id", "0000000003000000807");
					tempMapD.put("sum_human_cost", Double.parseDouble(value9)+Double.parseDouble(value10)); 
					tempMapD.put("creator", user.getEmpId());
					tempMapD.put("create_date", new Date());
					tempMapD.put("updator", user.getEmpId());
					tempMapD.put("modifi_date", new Date());
					tempMapD.put("bsflag", "0");tempMapD.put("spare5", "1"); 
					tempMapD.put("project_info_no",projectInfoNo);
					tempMapD.put("cost_state", costState);
					tempMapD.put("plan_id", planId);	
					tempMapD.put("org_id", user.getOrgId());
					tempMapD.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMapD,"bgp_comm_human_cost_plan_sala");
					
					
					//劳务费
					row = sheet.getRow(63);	
					Map  tempMapE = new HashMap ();
					Cell ss11=row.getCell(3);	//纵向从零开始
					String value11 ="0";
					if (ss11 != null && !"".equals(ss11.toString())) {
						ss11.setCellType(1); 
						value11 = ss11.getStringCellValue().trim();
						tempMapE.put("reem_cost", value11);//再就业
					}
					
					row = sheet.getRow(67);	
					Cell ss12=row.getCell(3);	 
					String value12 ="0";
					if (ss12 != null && !"".equals(ss12.toString())) {
						ss12.setCellType(1); 
						value12 = ss12.getStringCellValue().trim();
						tempMapE.put("recruit_cost", value12);//招聘骨干
					}
					
					row = sheet.getRow(70);	
					Cell ss13=row.getCell(3);	 
					String value13 ="0";
					if (ss13 != null && !"".equals(ss13.toString())) {
						ss13.setCellType(1); 
						value13 = ss13.getStringCellValue().trim();
						tempMapE.put("worker_cost", value13);//外雇工
					} 
					
					tempMapE.put("subject_id", "0000000003000000808");
					tempMapE.put("sum_human_cost", Double.parseDouble(value11)+Double.parseDouble(value12)+Double.parseDouble(value13)); 
					tempMapE.put("creator", user.getEmpId());
					tempMapE.put("create_date", new Date());
					tempMapE.put("updator", user.getEmpId());
					tempMapE.put("modifi_date", new Date());
					tempMapE.put("bsflag", "0");tempMapE.put("spare5", "1"); 
					tempMapE.put("project_info_no",projectInfoNo);
					tempMapE.put("cost_state", costState);
					tempMapE.put("plan_id", planId);	
					tempMapE.put("org_id", user.getOrgId());
					tempMapE.put("org_subjection_id", user.getOrgSubjectionId()); 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(tempMapE,"bgp_comm_human_cost_plan_sala");
				 
			   }
					
			 	
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}	 
			responseMsg.setValue("projectInfoNo", projectInfoNo);
			responseMsg.setValue("projectType", projectType);
			responseMsg.setValue("projectName","*");
			responseMsg.setValue("planIds", planId);
			responseMsg.setValue("costState", costState);
			responseMsg.setValue("message", "2");
			responseMsg.setValue("pBackUrl", "/rm/em/singleHuman/humanCostPlan/humanCostPlanSupplyList.jsp");
		}		
		
		return responseMsg;		
	}
	
	
	/**
	 * 人工成本计划导入
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanCostPlanExcle(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);	
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		UserToken user = reqDTO.getUserToken();
		
		String costState = reqDTO.getValue("costState");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		SimpleDateFormat datetemp=new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList != null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			
			Map<String, String> costMap = new HashMap<String, String>();
			costMap.put("cost_state", costState);
			costMap.put("project_info_no", projectInfoNo);
			
			List<Map> planlist = new ArrayList<Map>();
			List<Map> salalist = new ArrayList<Map>();
			
			try{		
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx")==-1) {		
					book = new HSSFWorkbook(new POIFSFileSystem(new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);  						
				}else{
					book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					sheet = book.getSheetAt(0);							
				}
				
				if(sheet != null ){
					
					for (int i = 1; i <= 3; i++) {
						row = sheet.getRow(i);	
						
						for (int j = 2; j <= 6; j++) {
							if(i==1 && j==2){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("work_load", value);
								}
							}	
							if(i==1 && j==4){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("fix_num", value);
								}
							}	
							if(i==1 && j==6){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("daily_acti", value);
								}
							}
							
							if(i==2 && j==2){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("const_month", value);
								}
							}	
							if(i==2 && j==4){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("nodal_period", value);
								}
							}	
							if(i==2 && j==6){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("const_period", value);
								}
							}
							
							if(i==3 && j==2){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("holoday_season", value);
								}
							}	
							if(i==3 && j==4){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("wages_month", value);
								}
							}	
							if(i==3 && j==6){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("acti_work_mon", value);
								}
							}							
						}
					}
					
										
					for (int i = 6; i <= 10; i++) {
						row = sheet.getRow(i);	
						Map<String, String> tempMap = new HashMap<String, String>();
						if(i == 6){
							tempMap.put("employee_gz", "0110000019000000001");
							tempMap.put("show_order", "1");
						}else if(i == 7){
							tempMap.put("employee_gz", "0110000019000000002");
							tempMap.put("show_order", "2");
						}else if(i == 8){
							tempMap.put("employee_gz", "0110000059000000001");
							tempMap.put("show_order", "3");
						}else if(i == 9){
							tempMap.put("employee_gz", "0110000059000000005");
							tempMap.put("show_order", "4");
						}else if(i == 10){
							tempMap.put("employee_gz", "0110000059000000003");
							tempMap.put("show_order", "5");
						}
						
						for (int j = 1; j <= 7; j++) {							
							Cell ss=row.getCell(j);		
							String value = "";
							switch (j) {
							case 1:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("gz_num", value);
								break;
							case 2:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("sys_wage", value);
								break;
							case 3:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("post_allow", value);
								break;
							case 4:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("area_allow", value);
								break;
							case 5:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("month_allow", value);
								break;
							case 6:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("lunch_wage", value);
								break;
							case 7:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("food_wage", value);
								break;
							default:
								break;
							}							
						}
						planlist.add(tempMap);
					}
										
					for (int m = 13; m <= 65; m++) {   
						row = sheet.getRow(m);	
						Map<String, String> tempMap = new HashMap<String, String>();
						for (int n = 0; n < 8; n++) {
							Cell ss=row.getCell(n);							
							String value = "";

							if (ss != null && !"".equals(ss.toString())) {
								switch (n) {
								case 0:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("subject_id_name", value);
									break;
								case 1:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("sum_human_cost", value);
									break;
								case 2:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("cont_cost", value);
									break;
								case 3:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("mark_cost", value);
									break;
								case 4:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("temp_cost", value);
									break;
								case 5:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("reem_cost", value);
									break;
								case 6:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("serv_cost", value);
									break;
								case 7:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("notes", value);
									break;
								default:
									break;
								}					
							}
						}	
						salalist.add(tempMap);
					}  
				}		
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}
			
			saveImportCostPlan(costMap,planlist,salalist,user);
			
			responseMsg.setValue("costState", costState);
			responseMsg.setValue("message", "导入成功!");
		}		
		
		return responseMsg;		
	}
	
	public void saveImportCostPlan(Map costMap,List planlist,List salalist,UserToken user){
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	    
		String plan_id ="";
		String psql = "select t.plan_id from bgp_comm_human_plan_cost t  where t.project_info_no='"+costMap.get("project_info_no")+"' and t.cost_state='"+costMap.get("cost_state")+"' and t.bsflag='0'  and t.spare5 is null ";
		Map planMap = jdbcDao.queryRecordBySQL(psql);
		if( planMap != null){						
			plan_id = (String)planMap.get("plan_id");						
		}
		
		String sql1 = "update bgp_comm_human_plan_cost t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
		jdbcDao.getJdbcTemplate().update(sql1);
		String sql2 = "update bgp_comm_human_cost_plan t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
		jdbcDao.getJdbcTemplate().update(sql2);
		String sql3 = "update bgp_comm_human_cost_plan_deta t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
		jdbcDao.getJdbcTemplate().update(sql3);
		String sql4 = "update bgp_comm_human_cost_plan_sala t set t.bsflag='1' where t.plan_id ='"+plan_id+"'";		
		jdbcDao.getJdbcTemplate().update(sql4);
		
		costMap.put("bsflag", "0");
		costMap.put("apply_date", new Date());
		costMap.put("create_date", new Date());
		costMap.put("modifi_date", new Date());
		costMap.put("org_id", user.getOrgId());
		costMap.put("org_subjection_id", user.getOrgSubjectionId());
		
		//1
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(costMap,"bgp_comm_human_plan_cost");
		String planId = id.toString();
		//2		
		costMap.put("plan_id", planId);		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(costMap,"bgp_comm_human_cost_plan");
	    //3		
		if(planlist != null && planlist.size()>0){		

			for(int i=0;i<planlist.size();i++){
				Map map = (HashMap)planlist.get(i);
				
				map.put("creator", user.getEmpId());
				map.put("create_date", new Date());
				map.put("updator", user.getEmpId());
				map.put("modifi_date", new Date());
				map.put("bsflag", "0");
				map.put("project_info_no", costMap.get("project_info_no"));
				map.put("cost_state", costMap.get("cost_state"));
				map.put("plan_id", planId);		
				map.put("org_id", user.getOrgId());
				map.put("org_subjection_id", user.getOrgSubjectionId());
			
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_cost_plan_deta");

			}
		}
		//4
		if(salalist != null && salalist.size()>0){		

			for(int i=0;i<salalist.size();i++){
				Map map = (HashMap)salalist.get(i);

				String subject_id ="";
				Map teamMap = jdbcDao.queryRecordBySQL("select t.coding_code_id from comm_human_coding_sort t where t.coding_name like '"+map.get("subject_id_name")+"' and t.coding_sort_id = '0000000002' ");				
				if( teamMap != null){						
					subject_id = (String)teamMap.get("coding_code_id");						
				}
				
				map.put("subject_id", subject_id);
				map.put("creator", user.getEmpId());
				map.put("create_date", new Date());
				map.put("updator", user.getEmpId());
				map.put("modifi_date", new Date());
				map.put("bsflag", "0");
				map.put("project_info_no", costMap.get("project_info_no"));
				map.put("cost_state", costMap.get("cost_state"));
				map.put("plan_id", planId);	
				map.put("org_id", user.getOrgId());
				map.put("org_subjection_id", user.getOrgSubjectionId());
			
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_cost_plan_sala");

			}
		}

	}
	

	/**
	 * 人工成本补充计划导入
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanCostPlanExcleTwo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);	
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		UserToken user = reqDTO.getUserToken();
		
		String planIds = reqDTO.getValue("planIds");
		String costState = reqDTO.getValue("costState");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		SimpleDateFormat datetemp=new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList != null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			
			Map<String, String> costMap = new HashMap<String, String>();
			costMap.put("cost_state", costState);
			costMap.put("project_info_no", projectInfoNo);
			costMap.put("plan_id", planIds);
			
			List<Map> planlist = new ArrayList<Map>();
			List<Map> salalist = new ArrayList<Map>();
			
			try{		
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx")==-1) {		
					book = new HSSFWorkbook(new POIFSFileSystem(new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);  						
				}else{
					book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					sheet = book.getSheetAt(0);							
				}
				
				if(sheet != null ){
					
					for (int i = 1; i <= 3; i++) {
						row = sheet.getRow(i);	
						
						for (int j = 2; j <= 6; j++) {
							if(i==1 && j==2){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("work_load", value);
								}
							}	
							if(i==1 && j==4){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("fix_num", value);
								}
							}	
							if(i==1 && j==6){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("daily_acti", value);
								}
							}
							
							if(i==2 && j==2){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("const_month", value);
								}
							}	
							if(i==2 && j==4){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("nodal_period", value);
								}
							}	
							if(i==2 && j==6){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("const_period", value);
								}
							}
							
							if(i==3 && j==2){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("holoday_season", value);
								}
							}	
							if(i==3 && j==4){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("wages_month", value);
								}
							}	
							if(i==3 && j==6){
								Cell ss = row.getCell(j);	
								if (ss != null && !"".equals(ss.toString())) {
									ss.setCellType(1); 
									String value = ss.getStringCellValue().trim();
									costMap.put("acti_work_mon", value);
								}
							}							
						}
					}
					
										
					for (int i = 6; i <= 10; i++) {
						row = sheet.getRow(i);	
						Map<String, String> tempMap = new HashMap<String, String>();
						if(i == 6){
							tempMap.put("employee_gz", "0110000019000000001");
							tempMap.put("show_order", "1");
						}else if(i == 7){
							tempMap.put("employee_gz", "0110000019000000002");
							tempMap.put("show_order", "2");
						}else if(i == 8){
							tempMap.put("employee_gz", "0110000059000000001");
							tempMap.put("show_order", "3");
						}else if(i == 9){
							tempMap.put("employee_gz", "0110000059000000005");
							tempMap.put("show_order", "4");
						}else if(i == 10){
							tempMap.put("employee_gz", "0110000059000000003");
							tempMap.put("show_order", "5");
						}
						
						for (int j = 1; j <= 7; j++) {							
							Cell ss=row.getCell(j);		
							String value = "";
							switch (j) {
							case 1:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("gz_num", value);
								break;
							case 2:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("sys_wage", value);
								break;
							case 3:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("post_allow", value);
								break;
							case 4:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("area_allow", value);
								break;
							case 5:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("month_allow", value);
								break;
							case 6:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("lunch_wage", value);
								break;
							case 7:
								ss.setCellType(1); 
								value = ss.getStringCellValue().trim();
								tempMap.put("food_wage", value);
								break;
							default:
								break;
							}							
						}
						planlist.add(tempMap);
					}
										
					for (int m = 13; m <= 65; m++) {   
						row = sheet.getRow(m);	
						Map<String, String> tempMap = new HashMap<String, String>();
						for (int n = 0; n < 8; n++) {
							Cell ss=row.getCell(n);							
							String value = "";

							if (ss != null && !"".equals(ss.toString())) {
								switch (n) {
								case 0:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("subject_id_name", value);
									break;
								case 1:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("sum_human_cost", value);
									break;
								case 2:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("cont_cost", value);
									break;
								case 3:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("mark_cost", value);
									break;
								case 4:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("temp_cost", value);
									break;
								case 5:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("reem_cost", value);
									break;
								case 6:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("serv_cost", value);
									break;
								case 7:
									ss.setCellType(1); 
									value = ss.getStringCellValue().trim();
									tempMap.put("notes", value);
									break;
								default:
									break;
								}					
							}
						}	
						salalist.add(tempMap);
					}  
				}		
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}
			
			saveImportCostPlanTwo(costMap,planlist,salalist,user);
			responseMsg.setValue("message", "导入成功!");
			responseMsg.setValue("costStateExcel", costState);
			responseMsg.setValue("planIds", planIds);
			responseMsg.setValue("buttonN", "1");
			
		}		
		
		return responseMsg;		
	}
	
	public void saveImportCostPlanTwo(Map costMap,List planlist,List salalist,UserToken user){
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	    
		String plan_id ="";
		String psql = "select t.plan_id from bgp_comm_human_plan_cost t  where t.project_info_no='"+costMap.get("project_info_no")+"' and t.cost_state='"+costMap.get("cost_state")+"' and t.bsflag='0' and t.plan_id ='"+costMap.get("plan_id")+"' and t.spare5='1' ";
		Map planMap = jdbcDao.queryRecordBySQL(psql);
		if( planMap != null){						
			plan_id = (String)planMap.get("plan_id");						
		}
		System.out.println("plan_id:"+plan_id);
		
//		String sql1 = "update bgp_comm_human_plan_cost t set t.bsflag='1' where t.plan_id ='"+plan_id+"'  ";		
//		jdbcDao.getJdbcTemplate().update(sql1);
		String sql2 = "update bgp_comm_human_cost_plan t set t.bsflag='1' where t.plan_id ='"+plan_id+"' ";		
		jdbcDao.getJdbcTemplate().update(sql2);
		String sql3 = "update bgp_comm_human_cost_plan_deta t set t.bsflag='1' where t.plan_id ='"+plan_id+"' ";		
		jdbcDao.getJdbcTemplate().update(sql3);
		String sql4 = "update bgp_comm_human_cost_plan_sala t set t.bsflag='1' where t.plan_id ='"+plan_id+"'   ";		
		jdbcDao.getJdbcTemplate().update(sql4);
 	
  
		costMap.put("bsflag", "0");
		costMap.put("spare5", "1");
		costMap.put("apply_date", new Date());
		costMap.put("create_date", new Date());
		costMap.put("modifi_date", new Date());
		costMap.put("org_id", user.getOrgId());
		costMap.put("org_subjection_id", user.getOrgSubjectionId());
		
		//1
		Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(costMap,"bgp_comm_human_plan_cost");
		String planId = id.toString();
		//2		
		costMap.put("plan_id", plan_id);		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(costMap,"bgp_comm_human_cost_plan");
	    //3		
		if(planlist != null && planlist.size()>0){		

			for(int i=0;i<planlist.size();i++){
				Map map = (HashMap)planlist.get(i);
		  
				map.put("creator", user.getEmpId());
				map.put("create_date", new Date());
				map.put("updator", user.getEmpId());
				map.put("modifi_date", new Date());
				map.put("bsflag", "0");
				map.put("spare5", "1");
				map.put("project_info_no", costMap.get("project_info_no"));
				map.put("cost_state", costMap.get("cost_state"));
				map.put("plan_id", plan_id);		
				map.put("org_id", user.getOrgId());
				map.put("org_subjection_id", user.getOrgSubjectionId());
			
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_cost_plan_deta");

			}
		}
		//4
		if(salalist != null && salalist.size()>0){		

			for(int i=0;i<salalist.size();i++){
				Map map = (HashMap)salalist.get(i);

				String subject_id ="";
				Map teamMap = jdbcDao.queryRecordBySQL("select t.coding_code_id from comm_human_coding_sort t where t.coding_name like '"+map.get("subject_id_name")+"' and t.coding_sort_id = '0000000002' ");				
				if( teamMap != null){						
					subject_id = (String)teamMap.get("coding_code_id");						
				}
	 
				map.put("subject_id", subject_id);
				map.put("creator", user.getEmpId());
				map.put("create_date", new Date());
				map.put("updator", user.getEmpId());
				map.put("modifi_date", new Date());
				map.put("bsflag", "0");
				map.put("spare5", "1");
				map.put("project_info_no", costMap.get("project_info_no"));
				map.put("cost_state", costMap.get("cost_state"));
				map.put("plan_id", plan_id);	
				map.put("org_id", user.getOrgId());
				map.put("org_subjection_id", user.getOrgSubjectionId());
			
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_cost_plan_sala");

			}
		}

	}
	

	
	
	/**
	 * 人工成本实际导入
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanCostActualExcle(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);	
		UserToken user = reqDTO.getUserToken();
		SimpleDateFormat datetemp = new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		String costState = reqDTO.getValue("costState");
		String str = "";
		if(fileList != null && fileList.size()>0){
			WSFile fs = fileList.get(0);

			List<Map> salalist = new ArrayList<Map>();

			try{		
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx")==-1) {		
					book = new HSSFWorkbook(new POIFSFileSystem(new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);  						
				}else{
					book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					sheet = book.getSheetAt(0);							
				}

					Map mapDateInfoIn = new HashMap();
					Row daterow = sheet.getRow(1);
					Cell yearcell = daterow.getCell(1);
					mapDateInfoIn.put(1, yearcell.getStringCellValue());
					String yearStr = mapDateInfoIn.get(1).toString();

					Cell monthcell = daterow.getCell(3);
					mapDateInfoIn.put(2, monthcell.getStringCellValue());
					String monthStr = mapDateInfoIn.get(2).toString();
					
					 if(yearStr.equals("") || monthStr.equals("") ){
					      str+="年、月为必填项!";
					  } 
					 
					Calendar calendar = new GregorianCalendar(Integer.parseInt(yearStr),Integer.parseInt(monthStr),0);
					//本月最大多少天
					int monthday = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
					 String dateStr=yearStr+"-"+monthStr+"-20";
					String dateStrT=yearStr+"-"+monthStr;
					Date appDate=datetemp.parse(dateStr);
			 System.out.println(appDate);
					 
				if(sheet != null ){
				
					for (int m = 4; m <= 56; m++) {   
						row = sheet.getRow(m);	
						Map<String, String> tempMap = new HashMap<String, String>();
						for (int n = 0; n < 7; n++) {
							Cell ss=row.getCell(n);							
							String value = "";

							if (ss != null && !"".equals(ss.toString())) {
								switch (n) {
								case 0:
									value = getCellValue((HSSFCell) ss).trim();
									tempMap.put("subject_id_name", value);
									break;
								case 1:
									value = getCellValue((HSSFCell) ss).trim();
									tempMap.put("sum_human_cost", value);
									break;
								case 2:
									value = getCellValue((HSSFCell) ss).trim();
									tempMap.put("cont_cost", value);
									break;
								case 3:
									value = getCellValue((HSSFCell) ss).trim();
									tempMap.put("mark_cost", value);
									break;
								case 4:
									value = getCellValue((HSSFCell) ss).trim();
									tempMap.put("temp_cost", value);
									break;
								case 5:
									value = getCellValue((HSSFCell) ss).trim();
									tempMap.put("reem_cost", value);
									break;
								case 6:
									value = getCellValue((HSSFCell) ss).trim();
									tempMap.put("serv_cost", value);
									break;
								default:
									break;
								}					
							}
						}	
						tempMap.put("app_date", dateStr);
						salalist.add(tempMap);
				 
							String actual_deta_ids ="";
							String psql = "select  actual_deta_id  from   bgp_comm_human_cost_act_deta  where to_char(app_date,'yyyy-MM') ='"+dateStrT+"' and bsflag='0' and  project_info_no = '"+user.getProjectInfoNo()+"' ";
							List<Map> planMap = jdbcDao.queryRecords(psql.toString()); 
							
							for(int i=0;i<planMap.size();i++){
								Map dataMap = (Map) planMap.get(i);
								actual_deta_ids = dataMap.get("actual_deta_id").toString();
								//System.out.println("actual_deta_ids:"+actual_deta_ids);
								String sql1 = "update bgp_comm_human_cost_act_deta t set t.bsflag='1' where t.actual_deta_id ='"+actual_deta_ids+"'  ";		
								jdbcDao.getJdbcTemplate().update(sql1);
								
							}
						
					}  
				}		
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}

			 if (str != null && !"".equals(str)) {
				    responseMsg.setValue("message", str); 
				   }else{

				    saveImportCostActualPlan(salalist,user);
				    responseMsg.setValue("message", "导入成功!");
				   
				   }  
 
			responseMsg.setValue("costState", costState);
			
			
		}		
		
		return responseMsg;		
	}
	
	public void saveImportCostActualPlan(List salalist,UserToken user){
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		if(salalist != null && salalist.size()>0){		
 
				for(int i=0;i<salalist.size();i++){
				
				Map map = (HashMap)salalist.get(i);
				String subject_id ="";
				Map teamMap = jdbcDao.queryRecordBySQL("select t.coding_code_id from comm_human_coding_sort t where t.coding_name like '"+map.get("subject_id_name")+"' and t.coding_sort_id = '0000000002' ");				
				if( teamMap != null){						
					subject_id = (String)teamMap.get("coding_code_id");						
				}
			  
				map.put("subject_id", subject_id);
				map.put("creator", user.getEmpId());				
				map.put("create_date", new Date());
				map.put("updator", user.getEmpId());
				map.put("modifi_date", new Date());
				map.put("bsflag", "0");
			//	map.put("app_date", map.get("app_date"));
				map.put("project_info_no", user.getProjectInfoNo());
				map.put("org_id", user.getOrgId());
				map.put("org_subjection_id", user.getOrgSubjectionId());
		 
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_cost_act_deta");

			}
		}

	}
	
	public ISrvMsg getOverseasCodes(ISrvMsg reqDTO) throws Exception {
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		StringBuffer sql = new StringBuffer("select t.coding_code_id,t.coding_code,t.coding_lever as fs, t.coding_name,t.coding_show_order as coding_show_id,  decode(length(t.coding_code), 2, 's', substr(t.coding_code, 0, 2)) parent_id   from comm_human_coding_sort t where  t.coding_sort_id='0000000003' and t.bsflag='0' order by t.coding_code ");
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString()); 
		
		Map rootMap = new HashMap();
		rootMap.put("codingCodeId", "s");
		rootMap.put("codingCode", "s");
		rootMap.put("parentId", "root");
		rootMap.put("codingName", "国际部岗位");
		rootMap.put("codingShowId", "1");
		rootMap.put("expanded", "true");

		
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "codingCode", "parentId", rootMap);

		JSONArray retJson = JSONArray.fromObject(jsonMap);
		String json = null;
		if (retJson == null) {
			json = "[]";
		} else {
			json = retJson.toString();
		}
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("json", json);
		
		return msg;
	}
	
	public ISrvMsg saveOverseasCodes(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		String coding_name = reqDTO.getValue("coding_name");
		String coding_code_id = reqDTO.getValue("coding_code_id");		
		String coding_code = reqDTO.getValue("coding_code");
		String coding_show_id = reqDTO.getValue("coding_show_order");
		String coding_lever=reqDTO.getValue("coding_lever");
		 
		coding_name=URLDecoder.decode(coding_name, "utf-8");
		coding_code_id=URLDecoder.decode(coding_code_id, "utf-8");
		coding_code=URLDecoder.decode(coding_code, "utf-8");
		coding_show_id=URLDecoder.decode(coding_show_id, "utf-8");
		coding_lever=URLDecoder.decode(coding_lever, "utf-8");

		StringBuffer sb = new StringBuffer();
		
		sb.append("insert into comm_human_coding_sort (coding_code_id,coding_sort_id,coding_code,coding_name,coding_show_order,bsflag,coding_lever,creator,create_date) values ");
		sb.append("( '").append(coding_code_id).append("',");
		sb.append("'0000000003',");
		sb.append("'").append(coding_code).append("',");
		sb.append("'").append(coding_name).append("',");
		sb.append("'").append(coding_show_id).append("',");
		sb.append("'0',");
		sb.append("'").append(coding_lever).append("',");
		sb.append("'").append(user.getEmpId()).append("',");
		sb.append("sysdate) ");

		jdbcDao.executeUpdate(sb.toString()); 
		return msg;
	}
	
	/**
	 * 临时工基本信息批量导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public ISrvMsg importExcelTemplate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String orgId= reqDTO.getValue("orgId"); // 登录人组织机构id
		String subId= reqDTO.getValue("subId"); // 登录人SubId
		String laborCategory= reqDTO.getValue("laborCategory"); 
		
		SimpleDateFormat datetemp = new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO; // 读取excel 表中的数据
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					book = new XSSFWorkbook(new ByteArrayInputStream(fs
							.getFileData()));
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					for (int m = 3; m <= sheet.getLastRowNum(); m++) {
						row = sheet.getRow(m);
						// 固定处理 ..上
						// *姓名 *性别 *出生年月 *民族 *身份证号 文化程度 家庭住址 *联系电话 健康信息 技能 是否骨干
						// 技术职称
						String laborName = "";
						String sex = "";
						String bithDate = "";
						String nation = "";
						String codeId = "";
						String degree = "";
						String adress = "";
						String phone = "";
						String health = "";
						String skill = "";
						String ifStamm = "";
						String skillName = "";
						String ifProject=""; //是否在项目
						String ifEngineer="";//是否工程分包人员
						String post="";
						String applyTeam="";
						String mobileNumnber="";
						String postalCode="";
						String contNum="";
						String laborDistribution="";//用工分布
						
						String position_type="";
						String position_nationality="";
						
						Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																						// 集合
						for (int j = 0; j <22; j++) {
							Cell ss = row.getCell(j);
							// System.out.println(ss);

							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
								case 0:
									ss.setCellType(1);
									laborName = ss.getStringCellValue().trim(); // 对应赋值
									tempMap.put("employee_name", laborName);
									break;
								case 1:
									ss.setCellType(1);
									sex = ss.getStringCellValue().trim();
									tempMap.put("employee_gender", sex);
									break;
								case 2:
									
									if(ss.getCellType()==0){
										bithDate=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
									}else{
										ss.setCellType(1);
										bithDate = ss.getStringCellValue().trim(); // 对应赋值
									}
//						   bithDate = ss.getStringCellValue().trim(); // 对应赋值
// 								 if (bithDate.indexOf("-") > 0) {      
// 									 bithDate = bithDate.replace("-", "/");      
// 									 } 
 								 
 								bithDate=bithDate.replace("/", "-");
 								String[] biths=bithDate.split("-");
 								String temp="";
 								for(int i=0;i<biths.length;i++){
 									if(biths[i].length()==1){
 									biths[i]="0"+biths[i];
 									}
 									if(i==biths.length-1){
 										temp+=biths[i];
 									}else{
 										temp+=biths[i]+"-";
 									}
 									
 								}
 								System.out.println(temp);
 								tempMap.put("employee_birth_date",temp); 
 								
 								try{
 									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
 								}catch(Exception ex){
 									
 									message.append("第").append(m + 1).append(
									"行日期格式不正确；");
 								}
//									String bithDate1 = ss.getDateCellValue().toString(); // 对应赋值
//							System.out.println(bithDate1);
//								    if (bithDate1.indexOf("") > 0) {     
//									 bithDate1 = bithDate1.replace("-", "/");      
//									 }     
//// 								
//						        	ss.setCellType(0);
//									bithDate=datetemp.format(ss.getDateCellValue());					 
//									tempMap.put("employee_birth_date",bithDate);
									break;
								case 3:
									ss.setCellType(1);
									nation = ss.getStringCellValue().trim();
									tempMap.put("employee_nation", nation);
									break;
								case 4:
									ss.setCellType(1);
									codeId = ss.getStringCellValue().trim();
									tempMap.put("employee_id_code_no", codeId);
									break;
								case 5:
									ss.setCellType(1);
									degree = ss.getStringCellValue().trim();
									tempMap.put("employee_education_level",
											degree);
									break;
								case 6:
									ss.setCellType(1);
									adress = ss.getStringCellValue().trim();
									tempMap.put("employee_address", adress);
									break;
								case 7:
									ss.setCellType(1);
									phone = ss.getStringCellValue().trim();
									tempMap.put("phone_num", phone);
									break;
								case 8:
									ss.setCellType(1);
									health = ss.getStringCellValue().trim();
									tempMap.put("employee_health_info", health);
									break;
								case 9:
									ss.setCellType(1);
									skill = ss.getStringCellValue().trim();
									tempMap.put("specialty", skill);
									break;
								case 10:
									ss.setCellType(1);
									ifStamm = ss.getStringCellValue().trim();
									tempMap.put("elite_if", ifStamm);
									break;
								case 11:
									ss.setCellType(1);
									skillName = ss.getStringCellValue().trim();
									tempMap.put("technical_title", skillName);
									break;
									
									//手机号码	邮编	*劳动合同编号	班组	岗位	*是否工程分包人员	项目状态
							
								case 12:
									ss.setCellType(1);
									mobileNumnber = ss.getStringCellValue().trim();
									tempMap.put("mobile_numnber", mobileNumnber);
									break;
								case 13:
									ss.setCellType(1);
									postalCode = ss.getStringCellValue().trim();
									tempMap.put("postal_code", postalCode);
									break;
								case 14:
									ss.setCellType(1);
									contNum = ss.getStringCellValue().trim();
									tempMap.put("cont_num", contNum);
									break;
								case 15:
									ss.setCellType(1);
									applyTeam = ss.getStringCellValue().trim();
									tempMap.put("apply_team", applyTeam);
									break;
								case 16:
									ss.setCellType(1);
									post = ss.getStringCellValue().trim();
									tempMap.put("post", post);
									break;
								case 17:
									ss.setCellType(1);
									ifEngineer = ss.getStringCellValue().trim();
									tempMap.put("if_engineer", ifEngineer);
									break;
								case 18:
									ss.setCellType(1);
									ifProject = ss.getStringCellValue().trim();
									tempMap.put("if_project", ifProject);

									break;
								case 19:
									ss.setCellType(1);
									laborDistribution = ss.getStringCellValue().trim();
									tempMap.put("labor_distribution", laborDistribution);

									break;
								case 20:
									ss.setCellType(1);
									position_type = ss.getStringCellValue().trim();
									tempMap.put("position_type", position_type);

									break;
								case 21:
									ss.setCellType(1);
									position_nationality = ss.getStringCellValue().trim();
									tempMap.put("position_nationality", position_nationality);

									break;
									
								default:
									break;
								}
							}
						}
						// 判断必填项处理
						if(ifEngineer.equals("工程分包")){ 
							
						}else{
							if(contNum.equals("")){
								message.append("第").append(m + 1).append(
								"行劳动合同编号不能为空；");
							}else{
								
								if (laborName.equals("") || sex.equals("")||ifEngineer.equals("")
										|| bithDate.equals("") || nation.equals("")
										|| codeId.equals("") || laborDistribution.equals("") || degree.equals("") || position_type.equals("") || mobileNumnber.equals("") ) {
									
									message.append("第").append(m + 1).append(
											"行红色标注项不能为空；");
								}
 
								if (message.toString().equals("")) {
									tempMap.put("orgId", orgId);
									tempMap.put("subId", subId);
									datelist.add(tempMap);
								} // 必填项不为空 则把数据放入 集合中
								
							}
							
							
							
						}
						
					}
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
			if (!message.toString().equals("")) {
				responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
			} else {
				if (datelist != null && datelist.size() > 0) {
					saveImportLabor(datelist, user); // 调用保存方法
				}
				responseDTO.setValue("message", "导入成功!");
 
			}
		}
		responseDTO.setValue("laborCategory", laborCategory);
		return responseDTO;
	}

	/**
	 * 临时工基本信息批量数据保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public void saveImportLabor(List datelist, UserToken user) {
		if (datelist != null && datelist.size() > 0) { // 表格数据list集合

			for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
				Map map = (HashMap) datelist.get(i);
				// 根据身份证号查询所有
				String sql1 = "select t.* from bgp_comm_human_labor t where t.employee_id_code_no='"
						+ map.get("employee_id_code_no")
						+ "' and t.bsflag='0' ";

				Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);
				// *姓名 *性别 *出生年月 *民族 *身份证号 文化程度 家庭住址 *联系电话 健康信息 技能 是否骨干 技术职称
				String laborId = "";
				String codeId = "";
				String employee_nation = ""; // 民族
				String employee_education_level = ""; // 文化程度
				String technical_title = ""; // 技术职称
				String employee_gender = (String) map.get("employee_gender"); // 性别
				String elite_if = (String) map.get("elite_if");
				String if_Projects=(String) map.get("if_project"); //是否在项目
				String labor_distribution=(String) map.get("labor_distribution");;  
				
				String employeeGender = ""; // 性别
				String eliteIf = ""; // 是否骨干
                String ifProjects=""; //是否在项目
                String ifEngineers=""; //是否工程分包人员
				String post="";
				String applyTeam="";
				String laborDistribution="";
			    
				String position_type=(String) map.get("position_type"); 
				String positionType="";
				
				String position_nationality="";
				
			 
				if (position_type != null) {
					if (position_type.equals("技能操作类")) {
						positionType = "0110000021000000003";
					} else if (position_type.equals("专业技术类")) {
						positionType = "0110000021000000002";
					}else if (position_type.equals("管理类")) {
						positionType = "0110000021000000001";
					}
				}
				
				
				if (employee_gender.equals("女")) {
					employeeGender = "0";
				} else if (employee_gender.equals("男")) {
					employeeGender = "1";
				}
				if (elite_if != null) {
					if (elite_if.equals("是")) {
						eliteIf = "1";
					} else if (elite_if.equals("否")) {
						eliteIf = "0";
					}
				}
				if (if_Projects != null) {
					if (if_Projects.equals("在项目")) {
						ifProjects = "1";
					} else if (if_Projects.equals("不在项目")) {
						ifProjects = "0";
					}
				}
				if (labor_distribution != null) {
					if (labor_distribution.equals("一线员工")) {
						laborDistribution = "0";
					} else if (labor_distribution.equals("境外一线")) {
						laborDistribution = "1";
					}else if (labor_distribution.equals("二线员工")) {
						laborDistribution = "2";
					}else if (labor_distribution.equals("三线员工")) {
						laborDistribution = "4";
					}
					else if (labor_distribution.equals("境外二三线")) {
						laborDistribution = "3";
					}
					 
				}

				// 转换下拉表 name文字为id
				Map engineersMap = jdbcDao
				.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
						+ map.get("if_engineer")
						+ "' and t.coding_sort_id='0110000059' ");
				if (engineersMap != null)
					ifEngineers = (String) engineersMap.get("coding_code_id");
		
				Map nationMap = jdbcDao
						.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
								+ map.get("employee_nation")
								+ "' and t.coding_sort_id='0500100001' ");
				if (nationMap != null)
					employee_nation = (String) nationMap.get("coding_code_id");
				
				Map positionNaMap= jdbcDao
				.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
						+ map.get("position_nationality")
						+ "' and t.coding_sort_id='5110000053' ");
				if (positionNaMap != null)
					position_nationality = (String) positionNaMap.get("coding_code_id");
		
		
				Map educationMap = jdbcDao
						.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
								+ map.get("employee_education_level") + "'");
				if (educationMap != null)
					employee_education_level = (String) educationMap.get("coding_code_id");
				System.out.println(employee_education_level);
				Map technicalMap = jdbcDao
						.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
								+ map.get("technical_title") + "'");
				if (technicalMap != null)
					technical_title = (String) technicalMap.get("coding_code_id");
				//班组
				Map applyTeamMap = jdbcDao
				.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
						+ map.get("apply_team") + "'");
		        if (applyTeamMap != null)
			     applyTeam = (String) applyTeamMap.get("coding_code_id");
		        //岗位
		        Map postMap = jdbcDao
				.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
						+ map.get("post") + "'");
		        if (postMap != null)
		        	post= (String) postMap.get("coding_code_id");
		        
		        
				// 判断人是否存在,存在修改，不存在则在临时工表中新增一条人员记录
				if (tempmap != null) {
					Map tempMap = new HashMap();
					laborId = tempmap.get("laborId").toString();
					codeId = tempmap.get("employeeIdCodeNo").toString();
					String orgIds=tempmap.get("owningOrgId").toString();
					String subIds=tempmap.get("owningSubjectionOrgId").toString();
					tempMap.put("labor_id", laborId);
					tempMap.put("employee_name", map.get("employee_name")); // 姓名
					tempMap.put("employee_id_code_no", codeId); // 身份证号
					tempMap.put("employee_birth_date", map.get("employee_birth_date")); // 生日
					tempMap.put("specialty", map.get("specialty")); // 技能
					tempMap.put("employee_health_info", map.get("employee_health_info"));// 健康信息
					tempMap.put("phone_num", map.get("phone_num")); // 电话
					tempMap.put("employee_address", map.get("employee_address")); // 家庭住址
					tempMap.put("employee_nation", employee_nation); // 民族
					tempMap.put("employee_education_level",employee_education_level); // 文化程度
					tempMap.put("technical_title", technical_title); // 技术职称
					tempMap.put("employee_gender", employeeGender); // 性别
					tempMap.put("elite_if", eliteIf); // 是否骨干
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date()); 
					
					tempMap.put("position_type", positionType);
					tempMap.put("position_nationality",position_nationality);
					
					tempMap.put("mobile_number",map.get("mobile_numnber")); //手机号码 
					tempMap.put("postal_code",map.get("postal_code"));   //邮编
					tempMap.put("cont_num",map.get("cont_num"));  //劳动合同编号
					tempMap.put("apply_team",applyTeam); //班组
					tempMap.put("post",post); //岗位
					tempMap.put("if_Project",ifProjects); 
					tempMap.put("if_Engineer",ifEngineers);  
					tempMap.put("labor_distribution",laborDistribution);  
					tempMap.put("owning_org_id",map.get("orgId"));  //组织机构
					tempMap.put("owning_subjection_org_id",map.get("subId")); //组织机构 subId
					jdbcDao.saveOrUpdateEntity(tempMap, "bgp_comm_human_labor"); // 保存

				} else {
					Map tempMap = new HashMap();
					tempMap.put("employee_name", map.get("employee_name")); // 姓名
					tempMap.put("employee_id_code_no", map.get("employee_id_code_no")); // 身份证号
					tempMap.put("employee_birth_date", map.get("employee_birth_date")); // 生日
					tempMap.put("specialty", map.get("specialty")); // 技能
					tempMap.put("employee_health_info", map.get("employee_health_info"));// 健康信息
					tempMap.put("phone_num", map.get("phone_num")); // 电话
					tempMap.put("employee_address", map.get("employee_address")); // 家庭住址
					tempMap.put("employee_nation", employee_nation); // 民族
					tempMap.put("employee_education_level",employee_education_level); // 文化程度
					tempMap.put("technical_title", technical_title); // 技术职称
					tempMap.put("employee_gender", employeeGender); // 性别
					tempMap.put("elite_if", eliteIf); // 是否骨干

					tempMap.put("creator", user.getEmpId());
					tempMap.put("create_date", new Date());
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date());
			    	tempMap.put("bsflag", "0");
		
			    	tempMap.put("position_type", positionType);
					tempMap.put("position_nationality",position_nationality);
					
					tempMap.put("mobile_number",map.get("mobile_numnber")); //手机号码 
					tempMap.put("postal_code",map.get("postal_code"));   //邮编
					tempMap.put("cont_num",map.get("cont_num"));  //劳动合同编号
					tempMap.put("apply_team",applyTeam); //班组
					tempMap.put("post",post); //岗位
					tempMap.put("if_Project",ifProjects); 
					tempMap.put("if_Engineer",ifEngineers); 
					tempMap.put("labor_distribution",laborDistribution);  
					tempMap.put("owning_org_id",map.get("orgId"));  //组织机构
					tempMap.put("owning_subjection_org_id",map.get("subId")); //组织机构 subId
					jdbcDao.saveOrUpdateEntity(tempMap, "bgp_comm_human_labor"); // 保存
				}
			}
		}
	}
	
	
	/**
	 * 临时工国际部信息批量导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public ISrvMsg importExcelTemplateG(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String orgId= reqDTO.getValue("orgId"); // 登录人组织机构id
		String subId= reqDTO.getValue("subId"); // 登录人SubId
		String laborCategory= reqDTO.getValue("laborCategory"); 
		
		SimpleDateFormat datetemp = new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO; // 读取excel 表中的数据
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					book = new XSSFWorkbook(new ByteArrayInputStream(fs
							.getFileData()));
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					for (int m = 3; m <= sheet.getLastRowNum(); m++) {
						row = sheet.getRow(m);
						// 固定处理 ..上
						// *姓名 *性别 *出生年月 *民族 *身份证号 文化程度 家庭住址 *联系电话 健康信息 技能 是否骨干
						// 技术职称
						String laborName = "";
						String codeId = ""; 

						String account_place="";
						String institutions_type="";
						String grass_root_unit="";
						
						String go_abroad_time="";
						String home_time="";
						String now_start_date="";
						String implementation_date="";
						String start_salary_date="";
						String technical_time="";
						String post_sequence="";
						 
						String post_exam="";
						String toefl_score="";
						String tofel_listening="";
						String if_qualified="";
						String nine_result="";
						String if_qualifieds="";
						String holds_result=""; 
						String household_type=""; 
						String present_state="";  
						
						Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																						// 集合
						for (int j = 0; j <21; j++) {
							Cell ss = row.getCell(j);
							// System.out.println(ss);

							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
								case 0:
									ss.setCellType(1);
									laborName = ss.getStringCellValue().trim(); // 对应赋值
									tempMap.put("employee_name", laborName);
									break; 
								case 1:
									ss.setCellType(1);
									codeId = ss.getStringCellValue().trim();
									tempMap.put("employee_id_code_no", codeId);
									break;
								case 2:
									ss.setCellType(1);
									account_place = ss.getStringCellValue().trim(); 
									tempMap.put("account_place", account_place);  //用工分布
									break; 
						 
								case 3:
									ss.setCellType(1);
									institutions_type= ss.getStringCellValue().trim();
									tempMap.put("institutions_type",institutions_type );//机构类别
									break; 
								case 4:
									ss.setCellType(1);
									grass_root_unit= ss.getStringCellValue().trim();
									tempMap.put("grass_root_unit",grass_root_unit );//基层单位
									break;
									
							     case 5:
									
									if(ss.getCellType()==0){  //出国(或国内上班)时间
										go_abroad_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
									}else{
										ss.setCellType(1);
										go_abroad_time = ss.getStringCellValue().trim(); // 对应赋值
									}
 
									go_abroad_time=go_abroad_time.replace("/", "-");
 								String[] biths=go_abroad_time.split("-");
 								String temp="";
 								for(int i=0;i<biths.length;i++){
 									if(biths[i].length()==1){
 									biths[i]="0"+biths[i];
 									}
 									if(i==biths.length-1){
 										temp+=biths[i];
 									}else{
 										temp+=biths[i]+"-";
 									}
 									
 								}
 								System.out.println(temp);
 								tempMap.put("go_abroad_time",temp); 
 								
 								try{
 									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
 								}catch(Exception ex){
 									
 									message.append("第").append(m + 1).append(
									"行日期格式不正确；");
 								}
 
									break;
							     case 6:
										
										if(ss.getCellType()==0){  //回国时间
											home_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											home_time = ss.getStringCellValue().trim(); // 对应赋值
										}
	 
										home_time=home_time.replace("/", "-");
	 								String[] biths1=home_time.split("-");
	 								String temp1="";
	 								for(int i=0;i<biths1.length;i++){
	 									if(biths1[i].length()==1){
	 									biths1[i]="0"+biths1[i];
	 									}
	 									if(i==biths1.length-1){
	 										temp1+=biths1[i];
	 									}else{
	 										temp1+=biths1[i]+"-";
	 									}
	 									
	 								}
	 								System.out.println(temp1);
	 								tempMap.put("home_time",temp1); 
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(temp1);
	 								}catch(Exception ex){ 
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								}
	 
									break;
									 
								case 7:
									ss.setCellType(1);
									present_state = ss.getStringCellValue().trim();
									tempMap.put("present_state", present_state);  //目前状态
									break; 
								 case 8:
										
										if(ss.getCellType()==0){               //现岗位起始日期 
											now_start_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											now_start_date = ss.getStringCellValue().trim(); // 对应赋值
										}
	 
										now_start_date=now_start_date.replace("/", "-");
	 								String[] biths2=now_start_date.split("-");
	 								String temp2="";
	 								for(int i=0;i<biths2.length;i++){
	 									if(biths2[i].length()==1){
	 									biths2[i]="0"+biths2[i];
	 									}
	 									if(i==biths2.length-1){
	 										temp2+=biths2[i];
	 									}else{
	 										temp2+=biths2[i]+"-";
	 									}
	 									
	 								}
	 								System.out.println(temp2);
	 								tempMap.put("now_start_date",temp2); 
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(temp2);
	 								}catch(Exception ex){ 
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								} 
									break;
								 case 9:
										
										if(ss.getCellType()==0){               //执行日期 
											implementation_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											implementation_date = ss.getStringCellValue().trim(); // 对应赋值
										}
	 
										implementation_date=implementation_date.replace("/", "-");
	 								String[] biths3=implementation_date.split("-");
	 								String temp3="";
	 								for(int i=0;i<biths3.length;i++){
	 									if(biths3[i].length()==1){
	 									biths3[i]="0"+biths3[i];
	 									}
	 									if(i==biths3.length-1){
	 										temp3+=biths3[i];
	 									}else{
	 										temp3+=biths3[i]+"-";
	 									}
	 									
	 								}
	 								System.out.println(temp3);
	 								tempMap.put("implementation_date",temp3); 
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(temp3);
	 								}catch(Exception ex){ 
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								} 
									break;
								 case 10:
										
										if(ss.getCellType()==0){               //起薪日期 
											start_salary_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											start_salary_date = ss.getStringCellValue().trim(); // 对应赋值
										}
	 
										start_salary_date=start_salary_date.replace("/", "-");
	 								String[] biths4=start_salary_date.split("-");
	 								String temp4="";
	 								for(int i=0;i<biths4.length;i++){
	 									if(biths4[i].length()==1){
	 									biths4[i]="0"+biths4[i];
	 									}
	 									if(i==biths4.length-1){
	 										temp4+=biths4[i];
	 									}else{
	 										temp4+=biths4[i]+"-";
	 									}
	 									
	 								}
	 								System.out.println(temp4);
	 								tempMap.put("start_salary_date",temp4); 
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(temp4);
	 								}catch(Exception ex){ 
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								} 
									break;
									 
								 case 11:
										
										if(ss.getCellType()==0){               //技术职称资格时间
											technical_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											technical_time = ss.getStringCellValue().trim(); // 对应赋值
										}
	 
										technical_time=technical_time.replace("/", "-");
	 								String[] biths5=technical_time.split("-");
	 								String temp5="";
	 								for(int i=0;i<biths5.length;i++){
	 									if(biths5[i].length()==1){
	 									biths5[i]="0"+biths5[i];
	 									}
	 									if(i==biths5.length-1){
	 										temp5+=biths5[i];
	 									}else{
	 										temp5+=biths5[i]+"-";
	 									}
	 									
	 								}
	 								System.out.println(temp5);
	 								tempMap.put("technical_time",temp5); 
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(temp5);
	 								}catch(Exception ex){ 
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								} 
									break;
						 
								 case 12:
										ss.setCellType(1);
										post_sequence= ss.getStringCellValue().trim();
										tempMap.put("post_sequence",post_sequence );//岗位序列
										break;
									
								 case 13:
										ss.setCellType(1);
										post_exam= ss.getStringCellValue().trim();
										tempMap.put("post_exam",post_exam );//岗位对应考试标准
										break;
									
								 case 14:
										ss.setCellType(1);
										toefl_score= ss.getStringCellValue().trim();
										tempMap.put("toefl_score",toefl_score );//托福总分
										break; 
						 
								 case 15:
										ss.setCellType(1);
										tofel_listening= ss.getStringCellValue().trim();
										tempMap.put("tofel_listening",tofel_listening );//托福听力
										break;
								 case 16:
										ss.setCellType(1);
										if_qualified= ss.getStringCellValue().trim();
										tempMap.put("if_qualified",if_qualified );//托福是否合格
										break;
								 case 17:
										ss.setCellType(1);
										nine_result= ss.getStringCellValue().trim();
										tempMap.put("nine_result",nine_result );//900句成绩
										break;
								 case 18:
										ss.setCellType(1);
										if_qualifieds= ss.getStringCellValue().trim();
										tempMap.put("if_qualifieds",if_qualifieds );//900句成绩是否合格
										break;
								 case 19:
										ss.setCellType(1);
										holds_result= ss.getStringCellValue().trim();
										tempMap.put("holds_result",holds_result );//托业成绩
										break;
								 case 20:
										ss.setCellType(1);
										household_type= ss.getStringCellValue().trim();
										tempMap.put("household_type",household_type );//户籍类型
										break; 
									
								default:
									break;
								}
							}
						}
						// 判断必填项处理
					   
								if (laborName.equals("") || codeId.equals("") ) { 
									message.append("第").append(m + 1).append(
											"行红色标注项不能为空；");
								}
 
								if(!codeId.equals("")){ 
									// 根据人员编号判断导入人员是否存在
									String sql = "select t.* from bgp_comm_human_labor t where t.bsflag='0' and  t.employee_id_code_no='"+codeId+"' ";
									Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
									if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
										codeId = (String) tempMaps.get("employeeIdCodeNo"); 
										tempMap.put("employee_id_code_no", codeId);
									}else{
										message.append("第").append(m + 1).append(
										"行人员身份证号不存在，请正确输入；"); 
									}
									
								}  
								
								
								if (message.toString().equals("")) {
									tempMap.put("orgId", orgId);
									tempMap.put("subId", subId);
									datelist.add(tempMap);
								} // 必填项不为空 则把数据放入 集合中
								
					  
					}
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
			if (!message.toString().equals("")) {
				responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
			} else {
				if (datelist != null && datelist.size() > 0) {
					saveImportLaborG(datelist, user); // 调用保存方法
				}
				responseDTO.setValue("message", "导入成功!");
 
			}
		}
		responseDTO.setValue("laborCategory", laborCategory); 
		return responseDTO;
	}

	/**
	 * 临时工国际部信息批量数据保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public void saveImportLaborG(List datelist, UserToken user) {
		if (datelist != null && datelist.size() > 0) { // 表格数据list集合

			for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
				Map map = (HashMap) datelist.get(i);
				// 根据身份证号查询所有
				String sql1 = "select t.* from bgp_comm_human_labor t where t.employee_id_code_no='"
						+ map.get("employee_id_code_no")
						+ "' and t.bsflag='0' ";

				Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);
				// *姓名 *性别 *出生年月 *民族 *身份证号 文化程度 家庭住址 *联系电话 健康信息 技能 是否骨干 技术职称
				String laborId = "";
				String codeId = "";
		 
				String account_place=(String) map.get("account_place"); 
				String institutions_type=(String) map.get("institutions_type");
				String institutionsType=""; 
				String grass_root_unit=(String) map.get("grass_root_unit"); 
	 
				String go_abroad_time=(String) map.get("go_abroad_time");
				String home_time=(String) map.get("home_time");
				String present_state="";   
				String now_start_date=(String) map.get("now_start_date");
				String implementation_date=(String) map.get("implementation_date");
				String start_salary_date=(String) map.get("start_salary_date");
				String technical_time=(String) map.get("technical_time");
				
				String post_sequence=(String) map.get("post_sequence"); 
				String post_exam=(String) map.get("post_exam");
				String toefl_score= (String)map.get("toefl_score");
				String tofel_listening=(String) map.get("tofel_listening");
				
				String if_qualified=(String) map.get("if_qualified");
			    String ifQualified="";
				String nine_result=(String) map.get("nine_result");
				String if_qualifieds=(String) map.get("if_qualifieds");
				String ifQualifieds="";
				String holds_result=(String) map.get("holds_result"); 
				String household_type=(String) map.get("household_type");
				String householdType="";
				
				 
				if (institutions_type != null) {
					if (institutions_type.equals("境外项目")) {
						institutionsType = "0";
					} else if (institutions_type.equals("总部机关")) {
						institutionsType = "1";
					}
				}
				 
				 
				if (if_qualified != null) {
					if (if_qualified.equals("是")) {
						ifQualified = "0";
					} else if (if_qualified.equals("否")) {
						ifQualified = "1";
					}
				}
				if (if_qualifieds != null) {
					if (if_qualifieds.equals("是")) {
						ifQualifieds = "0";
					} else if (if_qualifieds.equals("否")) {
						ifQualifieds = "1";
					}
				}
				 
				if (household_type != null) {
					if (household_type.equals("农业")) {
						householdType = "0";
					} else if (household_type.equals("非农业")) {
						householdType = "1";
					}
				}
				 
				
		        
				// 转换下拉表 name文字为id
				Map currentStateMap = jdbcDao
				.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
						+ map.get("present_state")
						+ "' and t.coding_sort_id='5110000046' and t.bsflag='0' and t.superior_code_id='0' ");
				if (currentStateMap != null)
					present_state = (String) currentStateMap.get("coding_code_id"); 
				 
		        
				// 判断人是否存在,存在修改，不存在则在临时工表中新增一条人员记录
				if (tempmap != null) {
					Map tempMap = new HashMap();
					laborId = tempmap.get("laborId").toString();
					codeId = tempmap.get("employeeIdCodeNo").toString();
					String orgIds=tempmap.get("owningOrgId").toString();
					String subIds=tempmap.get("owningSubjectionOrgId").toString();
					tempMap.put("labor_id", laborId);
					tempMap.put("employee_name", map.get("employee_name")); // 姓名
					tempMap.put("employee_id_code_no", codeId); // 身份证号 
					
					tempMap.put("account_place", account_place);     
					tempMap.put("institutions_type", institutionsType);   
					tempMap.put("grass_root_unit", grass_root_unit);    
					tempMap.put("go_abroad_time",  map.get("go_abroad_time")); 
					tempMap.put("home_time", map.get("home_time")); 
					tempMap.put("present_state", present_state);  
					tempMap.put("now_start_date", map.get("now_start_date")); 
					tempMap.put("implementation_date", map.get("implementation_date"));  
					tempMap.put("start_salary_date", map.get("start_salary_date")); 
					tempMap.put("technical_time", map.get("technical_time"));  
					tempMap.put("post_sequence", post_sequence);  
					tempMap.put("post_exam", post_exam);   
					tempMap.put("toefl_score", map.get("toefl_score"));  
					tempMap.put("tofel_listening", map.get("tofel_listening")); 
					tempMap.put("if_qualified", ifQualified); 
					tempMap.put("nine_result", map.get("nine_result")); 
					tempMap.put("if_qualifieds", ifQualifieds);  
					tempMap.put("holds_result", map.get("holds_result")); 
					tempMap.put("household_type", householdType); 
					
					
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date()); 
					tempMap.put("owning_org_id",map.get("orgId"));  //组织机构
					tempMap.put("owning_subjection_org_id",map.get("subId")); //组织机构 subId
					jdbcDao.saveOrUpdateEntity(tempMap, "bgp_comm_human_labor"); // 保存

				} else {
					Map tempMap = new HashMap();
					tempMap.put("employee_name", map.get("employee_name")); // 姓名
					tempMap.put("employee_id_code_no", map.get("employee_id_code_no")); // 身份证号
				 
					tempMap.put("account_place", account_place);     
					tempMap.put("institutions_type", institutionsType);   
					tempMap.put("grass_root_unit", grass_root_unit);    
					tempMap.put("go_abroad_time",  map.get("go_abroad_time")); 
					tempMap.put("home_time", map.get("home_time")); 
					tempMap.put("present_state", present_state);  
					tempMap.put("now_start_date", map.get("now_start_date")); 
					tempMap.put("implementation_date", map.get("implementation_date"));  
					tempMap.put("start_salary_date", map.get("start_salary_date")); 
					tempMap.put("technical_time", map.get("technical_time"));  
					tempMap.put("post_sequence", post_sequence);  
					tempMap.put("post_exam", post_exam);   
					tempMap.put("toefl_score", map.get("toefl_score"));  
					tempMap.put("tofel_listening", map.get("tofel_listening")); 
					tempMap.put("if_qualified", ifQualified); 
					tempMap.put("nine_result", map.get("nine_result")); 
					tempMap.put("if_qualifieds", ifQualifieds);  
					tempMap.put("holds_result", map.get("holds_result")); 
					tempMap.put("household_type", householdType); 
					
					tempMap.put("creator", user.getEmpId());
					tempMap.put("create_date", new Date());
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date());
			    	tempMap.put("bsflag", "0");  
					tempMap.put("owning_org_id",map.get("orgId"));  //组织机构
					tempMap.put("owning_subjection_org_id",map.get("subId")); //组织机构 subId
					jdbcDao.saveOrUpdateEntity(tempMap, "bgp_comm_human_labor"); // 保存
				}
			}
		}
	}
	
	
	
	
	/*
	 * 目前状态编码
	 */
	public ISrvMsg queryCurrentState(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("SELECT t.coding_code_id AS value, t.coding_name AS label  FROM comm_coding_sort_detail t where t.coding_sort_id = '5110000046'   and t.bsflag = '0'   and t.SUPERIOR_CODE_ID='0'     order by t.coding_code_id  ");
	 		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}
	
	
	/**
	 * 考勤信息批量导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public ISrvMsg importExcelAttendance(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String orgId= reqDTO.getValue("orgId"); // 登录人组织机构id
		String subId= reqDTO.getValue("subId"); // 登录人SubId
	  
		SimpleDateFormat datetemp = new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO; // 读取excel 表中的数据
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					book = new XSSFWorkbook(new ByteArrayInputStream(fs
							.getFileData()));
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					for (int m = 3; m <= sheet.getLastRowNum(); m++) {
						row = sheet.getRow(m);
 
						String employee_name = "";
						String sap_number = "";
						String start_time = "";
						String end_time = "";
						String current_state = "";
						String days="";
						String employeeId="";
						Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																						// 集合
						for (int j = 0; j <5; j++) {
							Cell ss = row.getCell(j);
							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
								case 0:
									ss.setCellType(1);
									employee_name = ss.getStringCellValue().trim(); // 对应赋值
									tempMap.put("employee_name", employee_name);
									break;
								case 1:
									ss.setCellType(1);
									sap_number = ss.getStringCellValue().trim();
									tempMap.put("sap_number", sap_number);
									break; 
								case 2:
									ss.setCellType(1);
									current_state = ss.getStringCellValue().trim();
									tempMap.put("current_state", current_state);
									break; 
					
								case 3: 
									if(ss.getCellType()==0){
										start_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
									}else{
										ss.setCellType(1);
										start_time = ss.getStringCellValue().trim(); // 对应赋值
									} 
								 start_time=start_time.replace("/", "-");
 								String[] biths=start_time.split("-");
 								String temp="";
 								for(int i=0;i<biths.length;i++){
 									if(biths[i].length()==1){
 									biths[i]="0"+biths[i];
 									}
 									if(i==biths.length-1){
 										temp+=biths[i];
 									}else{
 										temp+=biths[i]+"-";
 									}
 									
 								}
 								System.out.println(temp);
 								tempMap.put("start_time",temp); 
 								
 								try{
 									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
 								}catch(Exception ex){
 									
 									message.append("第").append(m + 1).append(
									"行日期格式不正确；");
 								} 
									break;
									
								case 4: 
									if(ss.getCellType()==0){
										end_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
									}else{
										ss.setCellType(1);
										end_time = ss.getStringCellValue().trim(); // 对应赋值
									} 
								end_time=end_time.replace("/", "-");
 								String[] bithsEnd=end_time.split("-");
 								String tempEnd="";
 								for(int i=0;i<bithsEnd.length;i++){
 									if(bithsEnd[i].length()==1){
 										bithsEnd[i]="0"+bithsEnd[i];
 									}
 									if(i==bithsEnd.length-1){
 										tempEnd+=bithsEnd[i];
 									}else{
 										tempEnd+=bithsEnd[i]+"-";
 									}
 									
 								}
 								System.out.println(tempEnd);
 								tempMap.put("end_time",tempEnd); 
 								
 								try{
 									new SimpleDateFormat("yyyy-MM-dd").parse(tempEnd);
 								}catch(Exception ex){
 									
 									message.append("第").append(m + 1).append(
									"行日期格式不正确；");
 								} 
									break;
									 
								default:
									break;
								}
							}
						}
					     	// 判断必填项处理
		 
								if (employee_name.equals("") || sap_number.equals("")||start_time.equals("")
										|| end_time.equals("") || current_state.equals("") ) { 
									message.append("第").append(m + 1).append(
											"行红色标注项不能为空；");
								}
 
								if(!sap_number.equals("")){ 
									// 根据人员编号判断导入人员是否存在
									String sql = "select  hr.employee_id,hr.employee_cd,he.employee_name  from comm_human_employee he left join comm_human_employee_hr hr on he.employee_id=hr.employee_id and  hr.bsflag='0' where he.bsflag='0' and hr.employee_cd='"+sap_number+"' ";
									Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
									if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
									     employeeId = (String) tempMaps.get("employeeId");
									     employee_name = (String) tempMaps.get("employeeName");
									      sap_number = (String) tempMaps.get("employeeCd"); 
										  Date date1 = new SimpleDateFormat("yyyy-MM-dd").parse(end_time);
										  Date date2 = new SimpleDateFormat("yyyy-MM-dd").parse(start_time);
										  System.out.println(date1+"--------"+date2);
										long day = (date1.getTime()-date2.getTime())/(24*60*60*1000)>0 ? (date1.getTime()-date2.getTime())/(24*60*60*1000):(date2.getTime()-date1.getTime())/(24*60*60*1000);
									    
										tempMap.put("days", Long.toString(day));
										tempMap.put("employeeId", employeeId);
										tempMap.put("employeeName", employee_name);
										tempMap.put("employeeCd", sap_number);
										
									}else{
										message.append("第").append(m + 1).append(
										"行人员编号不存在，请正确输入；"); 
									}
									
								} 
								
								if (message.toString().equals("")) {
									tempMap.put("orgId", orgId);
									tempMap.put("subId", subId);
									datelist.add(tempMap);
								} // 必填项不为空 则把数据放入 集合中
				 
					   
					}
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
			if (!message.toString().equals("")) {
				responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
			} else {
				if (datelist != null && datelist.size() > 0) {
					saveImportAttendance(datelist, user); // 调用保存方法
				}
				responseDTO.setValue("message", "导入成功!");
 
			}
		}
		return responseDTO;
	}

	
	/**
	 * 考勤信息批量数据保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public void saveImportAttendance (List datelist, UserToken user) {
		if (datelist != null && datelist.size() > 0) { // 表格数据list集合

			for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
				Map map = (HashMap) datelist.get(i);
				// 根据人员办好查询所有
				String sql1 = "select t.* from bgp_comm_human_attendance t where t.sap_number='"
						+ map.get("employeeCd")
						+ "' and t.bsflag='0' "; 
				Map tempmap = queryJdbcDao.queryRecordBySQL(sql1); 
				
				String attendance_id = ""; 
				String employee_name = (String) map.get("employeeName");
				String employee_id = (String) map.get("employeeId");
				String sap_number = (String) map.get("employeeCd");
				String days = (String) map.get("days");   
				String start_time = (String) map.get("start_time"); 
				String end_time = (String) map.get("end_time");  
				String current_state = "";
 
				// 转换下拉表 name文字为id
				Map currentStateMap = jdbcDao
				.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
						+ map.get("current_state")
						+ "' and t.coding_sort_id='5110000046' and t.bsflag='0' and t.superior_code_id='0' ");
				if (currentStateMap != null)
					current_state = (String) currentStateMap.get("coding_code_id");
		
			  
				// 判断人是否存在,存在修改，不存在则在考勤表中新增一条人员记录
				if (tempmap != null) {
					Map tempMap = new HashMap();
					attendance_id = tempmap.get("attendanceId").toString();
					sap_number = tempmap.get("sapNumber").toString();
					tempMap.put("attendance_id", attendance_id); 
					tempMap.put("employee_name", employee_name);
					tempMap.put("employee_id", employee_id);
					tempMap.put("sap_number", sap_number);
					tempMap.put("days", days);
					tempMap.put("start_time", start_time);
					tempMap.put("end_time", end_time);
					tempMap.put("current_state", current_state);   
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date()); 
					tempMap.put("org_id",map.get("orgId"));  //组织机构
					tempMap.put("org_sub_id",map.get("subId")); //组织机构 subId
					jdbcDao.saveOrUpdateEntity(tempMap, "bgp_comm_human_attendance"); // 保存 
				} else {
					Map tempMap = new HashMap();
					tempMap.put("attendance_id", attendance_id); 
					tempMap.put("employee_name", employee_name);
					tempMap.put("employee_id", employee_id);
					tempMap.put("sap_number", sap_number);
					tempMap.put("days", days);
					tempMap.put("start_time", start_time);
					tempMap.put("end_time", end_time);
					tempMap.put("current_state", current_state);   
					tempMap.put("creator", user.getEmpId());
					tempMap.put("create_date", new Date());
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date());
			    	tempMap.put("bsflag", "0");
			    	tempMap.put("org_id",map.get("orgId"));  //组织机构
					tempMap.put("org_sub_id",map.get("subId")); //组织机构 subId 
					jdbcDao.saveOrUpdateEntity(tempMap, "bgp_comm_human_attendance"); // 保存
				}
			}
		}
	}
	
	/**
	 * 正式工信息批量导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public ISrvMsg importExcelHuman(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String orgId= reqDTO.getValue("orgId"); // 登录人组织机构id
		String subId= reqDTO.getValue("subId"); // 登录人SubId
		String paramsType= reqDTO.getValue("paramsType"); 
		
		SimpleDateFormat datetemp = new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO; // 读取excel 表中的数据
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					book = new XSSFWorkbook(new ByteArrayInputStream(fs
							.getFileData()));
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					for (int m = 3; m <= sheet.getLastRowNum(); m++) {
						row = sheet.getRow(m);
  					
						String employee_hr_id=""; 
						String employee_id="";						
						String employee_name="";
						String employee_cd=""; 
						String set_team="";
						String set_post="";
						String spare7="";
						String home_address="";
						String qq="";
						String e_mail="";
						String employee_mobile_phone="";
						String institutions_type="";
						String grass_root_unit="";
						String present_state=""; 
						Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																						// 集合
						for (int j = 0; j <12; j++) {
							Cell ss = row.getCell(j);
							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
								case 0:
									ss.setCellType(1);
									employee_name = ss.getStringCellValue().trim(); // 对应赋值
									tempMap.put("employee_name", employee_name);
									break;
								case 1:
									ss.setCellType(1);
									employee_cd = ss.getStringCellValue().trim();
									tempMap.put("employee_cd", employee_cd);
									break; 
								case 2:
									ss.setCellType(1);
									set_team = ss.getStringCellValue().trim();
									tempMap.put("set_team", set_team);
									break;  
								case 3:
									ss.setCellType(1);
									set_post = ss.getStringCellValue().trim();
									tempMap.put("set_post", set_post);
									break;  
								case 4:
									ss.setCellType(1);
									spare7 = ss.getStringCellValue().trim();
									tempMap.put("spare7", spare7);
									break; 
								case 5:
									ss.setCellType(1);
									home_address= ss.getStringCellValue().trim();
									tempMap.put("home_address",home_address );
									break; 
								case 6:
									ss.setCellType(1);
									qq= ss.getStringCellValue().trim();
									tempMap.put("qq", qq);
									break; 
								case 7:
									ss.setCellType(1);
									e_mail = ss.getStringCellValue().trim();
									tempMap.put("e_mail",e_mail );
									break; 
								case 8:
									ss.setCellType(1);
									employee_mobile_phone = ss.getStringCellValue().trim();
									tempMap.put("employee_mobile_phone", employee_mobile_phone);
									break; 
								case 9:
									ss.setCellType(1);
									institutions_type= ss.getStringCellValue().trim();
									tempMap.put("institutions_type",institutions_type );
									break; 
								case 10:
									ss.setCellType(1);
									grass_root_unit= ss.getStringCellValue().trim();
									tempMap.put("grass_root_unit",grass_root_unit );
									break;
								case 11:
									ss.setCellType(1);
									present_state = ss.getStringCellValue().trim();
									tempMap.put("present_state", present_state);
									break; 
									
								default:
									break;
								}
							}
						}
					     	// 判断必填项处理
		 
								if (employee_name.equals("") || employee_cd.equals("")||spare7.equals("") ) { 
									message.append("第").append(m + 1).append(
											"行红色标注项不能为空；");
								}
 
								if(!employee_cd.equals("")){ 
									// 根据人员编号判断导入人员是否存在
									String sql = "select  hr.employee_id,hr.employee_cd,he.employee_name ,hr.employee_hr_id  from comm_human_employee he left join comm_human_employee_hr hr on he.employee_id=hr.employee_id and  hr.bsflag='0' where he.bsflag='0' and hr.employee_cd='"+employee_cd+"' ";
									Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
									if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
										 employee_id = (String) tempMaps.get("employeeId");
									     employee_name = (String) tempMaps.get("employeeName");
									     employee_cd = (String) tempMaps.get("employeeCd"); 
									     employee_hr_id=(String) tempMaps.get("employeeHrId"); 
									      
										tempMap.put("employeeId", employee_id);
										tempMap.put("employeeName", employee_name);
										tempMap.put("employeeCd", employee_cd);
										tempMap.put("employeeHrId", employee_hr_id);
										
									}else{
										message.append("第").append(m + 1).append(
										"行人员编号不存在，请正确输入；"); 
									}
									
								} 
								
								if (message.toString().equals("")) {
									tempMap.put("orgId", orgId);
									tempMap.put("subId", subId);
									datelist.add(tempMap);
								} // 必填项不为空 则把数据放入 集合中
				 
					   
					}
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
			if (!message.toString().equals("")) {
				responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
			} else {
				if (datelist != null && datelist.size() > 0) {
					saveImportHuman(datelist, user); // 调用保存方法
				}
				responseDTO.setValue("message", "导入成功!");
 
			}
		}
		return responseDTO;
	}

	
	
	/**
	 * 正式工批量数据保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public void saveImportHuman (List datelist, UserToken user) {
		if (datelist != null && datelist.size() > 0) { // 表格数据list集合 
			for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
				Map map = (HashMap) datelist.get(i);
				// 根据人员办好查询所有
				String sql1 = "select t.* from comm_human_employee_hr t where t.employee_cd='"
						+ map.get("employeeCd")
						+ "' and t.bsflag='0' "; 
				Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);  
				String employee_hr_id="";
				String employee_id=(String) map.get("employeeId"); 
				String employee_name=(String) map.get("employeeName");
				String employee_cd=(String) map.get("employeeCd"); 
				String set_team="";
				String set_post="";
				String spare7=(String) map.get("spare7");
				String home_address=(String) map.get("home_address");
				String qq=(String) map.get("qq");
				String e_mail=(String) map.get("e_mail");
				String employee_mobile_phone=(String) map.get("employee_mobile_phone");
				String institutions_type=(String) map.get("institutions_type");
				String grass_root_unit=(String) map.get("grass_root_unit"); 
				String present_state="";   
				String spare="";
				String institutionsType="";
				
				if (institutions_type != null) {
					if (institutions_type.equals("境外项目")) {
						institutionsType = "0";
					} else if (institutions_type.equals("总部机关")) {
						institutionsType = "1";
					}
				}
				 
				if (spare7 != null) {
					if (spare7.equals("一线员工")) {
						spare = "0";
					} else if (spare7.equals("境外一线")) {
						spare = "1";
					}else if (spare7.equals("二线员工")) {
						spare = "2";
					}else if (spare7.equals("三线员工")) {
						spare = "4";
					}else if (spare7.equals("境外二三线")) {
						spare = "3";
					} 
				} 
				
				//班组
				Map applyTeamMap = jdbcDao
				.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
						+ map.get("set_team") + "'");
		        if (applyTeamMap != null)
		        	set_team = (String) applyTeamMap.get("coding_code_id");
		        //岗位
		        Map postMap = jdbcDao
				.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
						+ map.get("set_post") + "'");
		        if (postMap != null)
		        	set_post= (String) postMap.get("coding_code_id");
		        
		        
				// 转换下拉表 name文字为id
				Map currentStateMap = jdbcDao
				.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
						+ map.get("present_state")
						+ "' and t.coding_sort_id='5110000046' and t.bsflag='0' and t.superior_code_id='0' ");
				if (currentStateMap != null)
					present_state = (String) currentStateMap.get("coding_code_id"); 
			  
				// 判断人是否存在,存在修改，不存在则在人员hr表中新增一条人员记录
				if (tempmap != null) {
					Map tempMap = new HashMap();
					employee_hr_id = tempmap.get("employeeHrId").toString(); 
					tempMap.put("employee_hr_id", employee_hr_id); 
					tempMap.put("employee_id", employee_id); 
					tempMap.put("employee_name", employee_name);
					tempMap.put("employee_cd", employee_cd);
					tempMap.put("set_team", set_team);
					tempMap.put("set_post", set_post);
					tempMap.put("spare7", spare);    
					tempMap.put("home_address", home_address);   
					tempMap.put("qq", qq);   
					tempMap.put("e_mail", e_mail);   
					tempMap.put("employee_mobile_phone", employee_mobile_phone);   
					tempMap.put("institutions_type", institutionsType);   
					tempMap.put("grass_root_unit", grass_root_unit);   
					tempMap.put("present_state", present_state);  
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date());  
					jdbcDao.saveOrUpdateEntity(tempMap, "comm_human_employee_hr"); // 保存 
				} else {
					Map tempMap = new HashMap();
					tempMap.put("employee_hr_id", employee_hr_id); 
					tempMap.put("employee_id", employee_id); 
					tempMap.put("employee_name", employee_name);
					tempMap.put("employee_cd", employee_cd);
					tempMap.put("set_team", set_team);
					tempMap.put("set_post", set_post);
					tempMap.put("spare7", spare);    
					tempMap.put("home_address", home_address);   
					tempMap.put("qq", qq);   
					tempMap.put("e_mail", e_mail);   
					tempMap.put("employee_mobile_phone", employee_mobile_phone);   
					tempMap.put("institutions_type", institutionsType);   
					tempMap.put("grass_root_unit", grass_root_unit);   
					tempMap.put("present_state", present_state);  
					tempMap.put("creator", user.getEmpId());
					tempMap.put("create_date", new Date());
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date());
			    	tempMap.put("bsflag", "0");
					jdbcDao.saveOrUpdateEntity(tempMap, "comm_human_employee_hr"); // 保存
				}
			}
		}
	}
	
	
	/**
	 * 正式工国际部信息批量导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public ISrvMsg importExcelHumanG(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		UserToken user = reqDTO.getUserToken();
		String orgId= reqDTO.getValue("orgId"); // 登录人组织机构id
		String subId= reqDTO.getValue("subId"); // 登录人SubId
		String paramsType= reqDTO.getValue("paramsType"); 
		
		SimpleDateFormat datetemp = new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO; // 读取excel 表中的数据
		List<WSFile> fileList = mqMsg.getFiles();
		if (fileList != null && fileList.size() > 0) {
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
			try {
				Workbook book = null;
				Sheet sheet = null;
				Row row = null;
				if (fs.getFilename().indexOf(".xlsx") == -1) {
					book = new HSSFWorkbook(new POIFSFileSystem(
							new ByteArrayInputStream(fs.getFileData())));
					sheet = book.getSheetAt(0);
				} else {
					book = new XSSFWorkbook(new ByteArrayInputStream(fs
							.getFileData()));
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					for (int m = 3; m <= sheet.getLastRowNum(); m++) {
						row = sheet.getRow(m);
  					
						String employee_hr_id=""; 
						String employee_id="";						
						String employee_name="";
						String employee_cd="";  
						String spare7=""; 
						String institutions_type="";
						String grass_root_unit="";
						
						String go_abroad_time="";
						String home_time="";
						String now_start_date="";
						String implementation_date="";
						String start_salary_date="";
						String technical_time="";
						String post_sequence="";
						 
						String post_exam="";
						String toefl_score="";
						String tofel_listening="";
						String if_qualified="";
						String nine_result="";
						String if_qualifieds="";
						String holds_result=""; 
						String household_type="";
						
						String present_state=""; 
						Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map
																						// 集合
						for (int j = 0; j <21; j++) {
							Cell ss = row.getCell(j);
							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
								case 0:
									ss.setCellType(1);
									employee_name = ss.getStringCellValue().trim(); // 对应赋值
									tempMap.put("employee_name", employee_name);
									break;
								case 1:
									ss.setCellType(1);
									employee_cd = ss.getStringCellValue().trim();
									tempMap.put("employee_cd", employee_cd);
									break; 
						  
								case 2:
									ss.setCellType(1);
									spare7 = ss.getStringCellValue().trim(); 
									tempMap.put("spare7", spare7);  //用工分布
									break; 
						 
								case 3:
									ss.setCellType(1);
									institutions_type= ss.getStringCellValue().trim();
									tempMap.put("institutions_type",institutions_type );//机构类别
									break; 
								case 4:
									ss.setCellType(1);
									grass_root_unit= ss.getStringCellValue().trim();
									tempMap.put("grass_root_unit",grass_root_unit );//基层单位
									break;
									
							     case 5:
									
									if(ss.getCellType()==0){  //出国(或国内上班)时间
										go_abroad_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
									}else{
										ss.setCellType(1);
										go_abroad_time = ss.getStringCellValue().trim(); // 对应赋值
									}
 
									go_abroad_time=go_abroad_time.replace("/", "-");
 								String[] biths=go_abroad_time.split("-");
 								String temp="";
 								for(int i=0;i<biths.length;i++){
 									if(biths[i].length()==1){
 									biths[i]="0"+biths[i];
 									}
 									if(i==biths.length-1){
 										temp+=biths[i];
 									}else{
 										temp+=biths[i]+"-";
 									}
 									
 								}
 								System.out.println(temp);
 								tempMap.put("go_abroad_time",temp); 
 								
 								try{
 									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
 								}catch(Exception ex){
 									
 									message.append("第").append(m + 1).append(
									"行日期格式不正确；");
 								}
 
									break;
							     case 6:
										
										if(ss.getCellType()==0){  //回国时间
											home_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											home_time = ss.getStringCellValue().trim(); // 对应赋值
										}
	 
										home_time=home_time.replace("/", "-");
	 								String[] biths1=home_time.split("-");
	 								String temp1="";
	 								for(int i=0;i<biths1.length;i++){
	 									if(biths1[i].length()==1){
	 									biths1[i]="0"+biths1[i];
	 									}
	 									if(i==biths1.length-1){
	 										temp1+=biths1[i];
	 									}else{
	 										temp1+=biths1[i]+"-";
	 									}
	 									
	 								}
	 								System.out.println(temp1);
	 								tempMap.put("home_time",temp1); 
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(temp1);
	 								}catch(Exception ex){ 
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								}
	 
									break;
									 
								case 7:
									ss.setCellType(1);
									present_state = ss.getStringCellValue().trim();
									tempMap.put("present_state", present_state);  //目前状态
									break; 
								 case 8:
										
										if(ss.getCellType()==0){               //现岗位起始日期 
											now_start_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											now_start_date = ss.getStringCellValue().trim(); // 对应赋值
										}
	 
										now_start_date=now_start_date.replace("/", "-");
	 								String[] biths2=now_start_date.split("-");
	 								String temp2="";
	 								for(int i=0;i<biths2.length;i++){
	 									if(biths2[i].length()==1){
	 									biths2[i]="0"+biths2[i];
	 									}
	 									if(i==biths2.length-1){
	 										temp2+=biths2[i];
	 									}else{
	 										temp2+=biths2[i]+"-";
	 									}
	 									
	 								}
	 								System.out.println(temp2);
	 								tempMap.put("now_start_date",temp2); 
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(temp2);
	 								}catch(Exception ex){ 
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								} 
									break;
								 case 9:
										
										if(ss.getCellType()==0){               //执行日期 
											implementation_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											implementation_date = ss.getStringCellValue().trim(); // 对应赋值
										}
	 
										implementation_date=implementation_date.replace("/", "-");
	 								String[] biths3=implementation_date.split("-");
	 								String temp3="";
	 								for(int i=0;i<biths3.length;i++){
	 									if(biths3[i].length()==1){
	 									biths3[i]="0"+biths3[i];
	 									}
	 									if(i==biths3.length-1){
	 										temp3+=biths3[i];
	 									}else{
	 										temp3+=biths3[i]+"-";
	 									}
	 									
	 								}
	 								System.out.println(temp3);
	 								tempMap.put("implementation_date",temp3); 
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(temp3);
	 								}catch(Exception ex){ 
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								} 
									break;
								 case 10:
										
										if(ss.getCellType()==0){               //起薪日期 
											start_salary_date=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											start_salary_date = ss.getStringCellValue().trim(); // 对应赋值
										}
	 
										start_salary_date=start_salary_date.replace("/", "-");
	 								String[] biths4=start_salary_date.split("-");
	 								String temp4="";
	 								for(int i=0;i<biths4.length;i++){
	 									if(biths4[i].length()==1){
	 									biths4[i]="0"+biths4[i];
	 									}
	 									if(i==biths4.length-1){
	 										temp4+=biths4[i];
	 									}else{
	 										temp4+=biths4[i]+"-";
	 									}
	 									
	 								}
	 								System.out.println(temp4);
	 								tempMap.put("start_salary_date",temp4); 
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(temp4);
	 								}catch(Exception ex){ 
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								} 
									break;
									 
								 case 11:
										
										if(ss.getCellType()==0){               //技术职称资格时间
											technical_time=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											technical_time = ss.getStringCellValue().trim(); // 对应赋值
										}
	 
										technical_time=technical_time.replace("/", "-");
	 								String[] biths5=technical_time.split("-");
	 								String temp5="";
	 								for(int i=0;i<biths5.length;i++){
	 									if(biths5[i].length()==1){
	 									biths5[i]="0"+biths5[i];
	 									}
	 									if(i==biths5.length-1){
	 										temp5+=biths5[i];
	 									}else{
	 										temp5+=biths5[i]+"-";
	 									}
	 									
	 								}
	 								System.out.println(temp5);
	 								tempMap.put("technical_time",temp5); 
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(temp5);
	 								}catch(Exception ex){ 
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								} 
									break;
						 
								 case 12:
										ss.setCellType(1);
										post_sequence= ss.getStringCellValue().trim();
										tempMap.put("post_sequence",post_sequence );//岗位序列
										break;
									
								 case 13:
										ss.setCellType(1);
										post_exam= ss.getStringCellValue().trim();
										tempMap.put("post_exam",post_exam );//岗位对应考试标准
										break;
									
								 case 14:
										ss.setCellType(1);
										toefl_score= ss.getStringCellValue().trim();
										tempMap.put("toefl_score",toefl_score );//托福总分
										break; 
						 
								 case 15:
										ss.setCellType(1);
										tofel_listening= ss.getStringCellValue().trim();
										tempMap.put("tofel_listening",tofel_listening );//托福听力
										break;
								 case 16:
										ss.setCellType(1);
										if_qualified= ss.getStringCellValue().trim();
										tempMap.put("if_qualified",if_qualified );//托福是否合格
										break;
								 case 17:
										ss.setCellType(1);
										nine_result= ss.getStringCellValue().trim();
										tempMap.put("nine_result",nine_result );//900句成绩
										break;
								 case 18:
										ss.setCellType(1);
										if_qualifieds= ss.getStringCellValue().trim();
										tempMap.put("if_qualifieds",if_qualifieds );//900句成绩是否合格
										break;
								 case 19:
										ss.setCellType(1);
										holds_result= ss.getStringCellValue().trim();
										tempMap.put("holds_result",holds_result );//托业成绩
										break;
								 case 20:
										ss.setCellType(1);
										household_type= ss.getStringCellValue().trim();
										tempMap.put("household_type",household_type );//户籍类型
										break; 
										
								default:
									break;
								}
							}
						}
					     	// 判断必填项处理
		 
								if (employee_name.equals("") || employee_cd.equals("") ) { 
									message.append("第").append(m + 1).append(
											"行红色标注项不能为空；");
								}
 
								if(!employee_cd.equals("")){ 
									// 根据人员编号判断导入人员是否存在
									String sql = "select  hr.employee_id,hr.employee_cd,he.employee_name ,hr.employee_hr_id  from comm_human_employee he left join comm_human_employee_hr hr on he.employee_id=hr.employee_id and  hr.bsflag='0' where he.bsflag='0' and hr.employee_cd='"+employee_cd+"' ";
									Map tempMaps = queryJdbcDao.queryRecordBySQL(sql);
									if (tempMaps != null && tempMaps.size() > 0) { // map集合不为空则取出id
										 employee_id = (String) tempMaps.get("employeeId");
									     employee_name = (String) tempMaps.get("employeeName");
									     employee_cd = (String) tempMaps.get("employeeCd"); 
									     employee_hr_id=(String) tempMaps.get("employeeHrId"); 
									      
										tempMap.put("employeeId", employee_id);
										tempMap.put("employeeName", employee_name);
										tempMap.put("employeeCd", employee_cd);
										tempMap.put("employeeHrId", employee_hr_id);
										
									}else{
										message.append("第").append(m + 1).append(
										"行人员编号不存在，请正确输入；"); 
									}
									
								} 
								
								if (message.toString().equals("")) {
									tempMap.put("orgId", orgId);
									tempMap.put("subId", subId);
									datelist.add(tempMap);
								} // 必填项不为空 则把数据放入 集合中
				 
					   
					}
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
			if (!message.toString().equals("")) {
				responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
			} else {
				if (datelist != null && datelist.size() > 0) {
					saveImportHumanG(datelist, user); // 调用保存方法
				}
				responseDTO.setValue("message", "导入成功!");
 
			}
		}
		responseDTO.setValue("paramsType", paramsType);
	 
		return responseDTO;
	}

	
	
	/**
	 * 正式工国际部批量数据保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public void saveImportHumanG (List datelist, UserToken user) {
		if (datelist != null && datelist.size() > 0) { // 表格数据list集合 
			for (int i = 0; i < datelist.size(); i++) { // 循环读取每行数据
				Map map = (HashMap) datelist.get(i);
				// 根据人员办好查询所有
				String sql1 = "select t.* from comm_human_employee_hr t where t.employee_cd='"
						+ map.get("employeeCd")
						+ "' and t.bsflag='0' "; 
				Map tempmap = queryJdbcDao.queryRecordBySQL(sql1);  
				String employee_hr_id="";
				String employee_id=(String) map.get("employeeId"); 
				String employee_name=(String) map.get("employeeName");
				String employee_cd=(String) map.get("employeeCd"); 
		 
				String spare7=(String) map.get("spare7");
				String spare="";
				String institutions_type=(String) map.get("institutions_type");
				String institutionsType="";
				
				String grass_root_unit=(String) map.get("grass_root_unit"); 
	 
				String go_abroad_time=(String) map.get("go_abroad_time");
				String home_time=(String) map.get("home_time");
				String present_state="";   
				
				String now_start_date=(String) map.get("now_start_date");
				String implementation_date=(String) map.get("implementation_date");
				String start_salary_date=(String) map.get("start_salary_date");
				String technical_time=(String) map.get("technical_time");
				
				String post_sequence=(String) map.get("post_sequence"); 
				String post_exam=(String) map.get("post_exam");
				String toefl_score= (String)map.get("toefl_score");
				String tofel_listening=(String) map.get("tofel_listening");
				
				String if_qualified=(String) map.get("if_qualified");
			    String ifQualified="";
				String nine_result=(String) map.get("nine_result");
				String if_qualifieds=(String) map.get("if_qualifieds");
				String ifQualifieds="";
				String holds_result=(String) map.get("holds_result"); 
				String household_type=(String) map.get("household_type");
				String householdType="";
				
				 
				if (institutions_type != null) {
					if (institutions_type.equals("境外项目")) {
						institutionsType = "0";
					} else if (institutions_type.equals("总部机关")) {
						institutionsType = "1";
					}
				}
				 
				if (spare7 != null) {
					if (spare7.equals("一线员工")) {
						spare = "0";
					} else if (spare7.equals("境外一线")) {
						spare = "1";
					}else if (spare7.equals("二线员工")) {
						spare = "2";
					}else if (spare7.equals("三线员工")) {
						spare = "4";
					}else if (spare7.equals("境外二三线")) {
						spare = "3";
					} 
				} 
				if (if_qualified != null) {
					if (if_qualified.equals("是")) {
						ifQualified = "0";
					} else if (if_qualified.equals("否")) {
						ifQualified = "1";
					}
				}
				if (if_qualifieds != null) {
					if (if_qualifieds.equals("是")) {
						ifQualifieds = "0";
					} else if (if_qualifieds.equals("否")) {
						ifQualifieds = "1";
					}
				}
				 
				if (household_type != null) {
					if (household_type.equals("农业")) {
						householdType = "0";
					} else if (household_type.equals("非农业")) {
						householdType = "1";
					}
				}
				 
				
		        
				// 转换下拉表 name文字为id
				Map currentStateMap = jdbcDao
				.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
						+ map.get("present_state")
						+ "' and t.coding_sort_id='5110000046' and t.bsflag='0' and t.superior_code_id='0' ");
				if (currentStateMap != null)
					present_state = (String) currentStateMap.get("coding_code_id"); 
			  
				// 判断人是否存在,存在修改，不存在则在人员hr表中新增一条人员记录
				if (tempmap != null) {
					Map tempMap = new HashMap();
					employee_hr_id = tempmap.get("employeeHrId").toString(); 
					tempMap.put("employee_hr_id", employee_hr_id); 
					tempMap.put("employee_id", employee_id); 
					tempMap.put("employee_name", employee_name);
					tempMap.put("employee_cd", employee_cd); 
					
					tempMap.put("spare7", spare);     
					tempMap.put("institutions_type", institutionsType);   
					tempMap.put("grass_root_unit", grass_root_unit);    
					tempMap.put("go_abroad_time",  map.get("go_abroad_time")); 
					tempMap.put("home_time", map.get("home_time")); 
					tempMap.put("present_state", present_state);  
					tempMap.put("now_start_date", map.get("now_start_date")); 
					tempMap.put("implementation_date", map.get("implementation_date"));  
					tempMap.put("start_salary_date", map.get("start_salary_date")); 
					tempMap.put("technical_time", map.get("technical_time"));  
					tempMap.put("post_sequence", post_sequence);  
					tempMap.put("post_exam", post_exam);   
					tempMap.put("toefl_score", map.get("toefl_score"));  
					tempMap.put("tofel_listening", map.get("tofel_listening")); 
					tempMap.put("if_qualified", ifQualified); 
					tempMap.put("nine_result", map.get("nine_result")); 
					tempMap.put("if_qualifieds", ifQualifieds);  
					tempMap.put("holds_result", map.get("holds_result")); 
					tempMap.put("household_type", householdType); 
			 
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date());  
					jdbcDao.saveOrUpdateEntity(tempMap, "comm_human_employee_hr"); // 保存 
				} else {
					Map tempMap = new HashMap();
					tempMap.put("employee_hr_id", employee_hr_id); 
					tempMap.put("employee_id", employee_id); 
					tempMap.put("employee_name", employee_name);
					tempMap.put("employee_cd", employee_cd); 
					
					tempMap.put("spare7", spare);     
					tempMap.put("institutions_type", institutionsType);   
					tempMap.put("grass_root_unit", grass_root_unit);    
					tempMap.put("go_abroad_time",  map.get("go_abroad_time")); 
					tempMap.put("home_time", map.get("home_time")); 
					tempMap.put("present_state", present_state);  
					tempMap.put("now_start_date", map.get("now_start_date")); 
					tempMap.put("implementation_date", map.get("implementation_date"));  
					tempMap.put("start_salary_date", map.get("start_salary_date")); 
					tempMap.put("technical_time", map.get("technical_time"));  
					tempMap.put("post_sequence", post_sequence);  
					tempMap.put("post_exam", post_exam);   
					tempMap.put("toefl_score", map.get("toefl_score"));  
					tempMap.put("tofel_listening", map.get("tofel_listening")); 
					tempMap.put("if_qualified", ifQualified); 
					tempMap.put("nine_result", map.get("nine_result")); 
					tempMap.put("if_qualifieds", ifQualifieds);  
					tempMap.put("holds_result", map.get("holds_result")); 
					tempMap.put("household_type", householdType); 
					
					tempMap.put("creator", user.getEmpId());
					tempMap.put("create_date", new Date());
					tempMap.put("updator", user.getEmpId());
					tempMap.put("modifi_date", new Date());
			    	tempMap.put("bsflag", "0");
					jdbcDao.saveOrUpdateEntity(tempMap, "comm_human_employee_hr"); // 保存
				}
			}
		}
	}
	
	
	
	
	
	/**
	 * 人员考勤数据导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveKQExcel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();

		//导入的时候是导入所有的，根据三个信息去查找数据库
		//String dev_acc_id = reqDTO.getValue("dev_acc_id");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List dataList = new ArrayList();
		//调整文件导入的格式和数据 以及后续的导入工作
 
			if (files != null && !files.isEmpty()) {
				for (int i = 0; i < files.size(); i++) {
					WSFile file = files.get(i);
					dataList = getKQExcelDataByWSFile(file,projectInfoId);
				}
				//遍历dataList，操作数据库
				for(int i=0;i<dataList.size();i++){
					Map dataMap = (Map) dataList.get(i);
					//dev_acc_id信息查询下，如果不存在，那么不导入
					String employee_id = dataMap.get("employee_id").toString();
					if(employee_id==null)
						continue;
					String sql = "select kqms_id from BGP_COMM_EMPLOYEE_KQMS where  bsflag='0' and  employee_id='"+employee_id+"' and timesheet_date=to_date('"+dataMap.get("timesheet_date")+"','yyyy-MM-dd')";
					Map getMap = jdbcDao.queryRecordBySQL(sql);
					System.out.println(getMap);
					if(getMap==null){//新增
						Map kqMap = new HashMap();
						kqMap.put("employee_id", employee_id);
						kqMap.put("timesheet_date", dataMap.get("timesheet_date"));
						kqMap.put("timesheet_symbol", dataMap.get("timesheet_symbol"));
						kqMap.put("project_id", projectInfoId);
						kqMap.put("bsflag", "0");
						jdbcDao.saveOrUpdateEntity(kqMap, "BGP_COMM_EMPLOYEE_KQMS");
					}else{//修改
						Map kqMap = new HashMap();
						kqMap.put("kqms_id", getMap.get("kqms_id"));
						kqMap.put("employee_id", employee_id);
						kqMap.put("timesheet_date", dataMap.get("timesheet_date"));
						kqMap.put("timesheet_symbol", dataMap.get("timesheet_symbol"));
						kqMap.put("project_id", projectInfoId);
						kqMap.put("bsflag", "0");
						jdbcDao.saveOrUpdateEntity(kqMap, "BGP_COMM_EMPLOYEE_KQMS");
						
					}
				}
			} 
		 
		//System.out.println(dataList.size());
		reqMsg.setValue("message","导入成功!");
		return reqMsg;
	}
	
	
	/**
	 * 通过wsfile 解析excel 获取excel中的信息
	 * 
	 * @param IN:file wsFile文件、columnList xml配置的excel导入配置信息
	 * 
	 * @param Out:List 将excel解析的数据集放置到list中
	 */
	private List getKQExcelDataByWSFile(WSFile file,String projectInfoId) throws IOException, ExcelExceptionHandler {
		List dataList = new ArrayList();
		String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = new XSSFWorkbook(is);
			Sheet sheet0 = book.getSheetAt(0);  // 读取第一个工作薄
			int rows = sheet0.getPhysicalNumberOfRows();
			int rowst = sheet0.getLastRowNum();// 获取该工作薄的总行数
			
			// getPhysicalNumberOfRows() 读取的是文件存在的行数，行数之间的空行不进行读取,   
			// 如果文件中存在非最后一行以后存在空行，则读取数据就会不正确
			Map mapDateInfoIn = new HashMap();
			Row daterow = sheet0.getRow(2);
			Cell yearcell = daterow.getCell(1);
			mapDateInfoIn.put(1, yearcell.getStringCellValue());
			String yearStr = mapDateInfoIn.get(1).toString();
 
			Cell monthcell = daterow.getCell(3);
			mapDateInfoIn.put(2, monthcell.getStringCellValue());
			String monthStr = mapDateInfoIn.get(2).toString();
	 
			Calendar calendar = new GregorianCalendar(Integer.parseInt(yearStr),Integer.parseInt(monthStr),0);
			//本月最大多少天
			int monthday = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		    	//System.out.println("-------------------"+yearStr+"-"+monthStr+":"+monthday+"-------------------------");
			for(int m=4;m<rowst;m++){ 
				Row row = sheet0.getRow(m);	// 获取单元格中指定列对象   
				int columns = row.getPhysicalNumberOfCells(); // 获取行中最后一个单元格
				// getPhysicalNumberOfCells获取行中存在的单元格个数           
			     
				String employee_id = null;
				if(columns>5){
		 
//					Cell sapno = row.getCell(2); 
//					System.out.println("sapno"+sapno);
//					sapno.setCellType(1);
//					String  sapnoStr = sapno.getStringCellValue().trim(); // 对应赋值
//					 
				//	System.out.println("输出第四行的第3列:"+row.getCell(2).toString());
				//	employee_id = this.getKQByID(projectInfoId,row.getCell(1).toString(),row.getCell(2).toString());
					 
 				if( !row.getCell(1).toString().equals(null)){
 					if(!row.getCell(1).toString().equals("")){//如果身份证号不为空则走 以身份证查询条件的sql
 						  employee_id = this.getKQByID(projectInfoId,row.getCell(1).toString(),"");
 					} else{
 						  employee_id = this.getKQByID(projectInfoId,row.getCell(1).toString(),row.getCell(2).toString()); 						
 					}  				 
 					 
 				}
										
					if(employee_id==null)
						continue;
				}else{
					continue;
				}
				for (int n = 5; n < columns&&n<(monthday+5); n++) {
					Cell cell = row.getCell(n);
					int cellType = cell.getCellType();
					switch (cellType) {
//					case 0:
					//System.out.println("数值型");
//						if (HSSFDateUtil.isCellDateFormatted(cell)) {
//							mapColumnInfoIn.put(n, cell.getDateCellValue());
//						} else {
//							cell.setCellType(cell.CELL_TYPE_STRING);
//							mapColumnInfoIn.put(n, cell.getStringCellValue());
//						}
//						break;
					case 1:
						//System.out.println("字符串型 ");
						Map mapColumnInfoIn = new HashMap();
						mapColumnInfoIn.put(1, row.getCell(1).getStringCellValue());
						mapColumnInfoIn.put(2, row.getCell(2).getStringCellValue());
						mapColumnInfoIn.put(3, row.getCell(3).getStringCellValue());
						mapColumnInfoIn.put(n, cell.getStringCellValue());
						
						Map map = new HashMap();
						map.put("employee_name", mapColumnInfoIn.get(3));
						if(n-4<10){
							map.put("timesheet_date", yearStr+"-"+monthStr+"-0"+(n-4));
						}else{
							map.put("timesheet_date", yearStr+"-"+monthStr+"-"+(n-4));
						}
						if("○".equals(mapColumnInfoIn.get(n).toString())){
							map.put("timesheet_symbol", "5110000052000000002");
						}else if("√".equals(mapColumnInfoIn.get(n).toString())){
							map.put("timesheet_symbol", "5110000052000000001");
						}else if("△".equals(mapColumnInfoIn.get(n).toString())){
							map.put("timesheet_symbol", "5110000052000000003");
						}else if("⊙".equals(mapColumnInfoIn.get(n).toString())){
							map.put("timesheet_symbol", "5110000052000000004");
						}else if("×".equals(mapColumnInfoIn.get(n).toString())){
							map.put("timesheet_symbol", "5110000052000000005");
						}else if("◇".equals(mapColumnInfoIn.get(n).toString())){
							map.put("timesheet_symbol", "5110000052000000007");
						}else{
							map.put("timesheet_symbol", "5110000052000000001");
						}
						map.put("sap_id", mapColumnInfoIn.get(2));
						map.put("code_id", mapColumnInfoIn.get(1));
						//直接给dev_acc_id扔进来
						map.put("employee_id", employee_id);
						dataList.add(map);
						break;
					case 3:
					//	System.out.println("空值");
						Map mapColumnInfoIn2 = new HashMap();
						mapColumnInfoIn2.put(1, row.getCell(1).getStringCellValue());
						mapColumnInfoIn2.put(2, row.getCell(2).getStringCellValue());
						mapColumnInfoIn2.put(3, row.getCell(3).getStringCellValue());
						mapColumnInfoIn2.put(n, cell.getStringCellValue());
						
						Map map2 = new HashMap();
						map2.put("employee_name", mapColumnInfoIn2.get(3));
						if(n-4<10){
							map2.put("timesheet_date", yearStr+"-"+monthStr+"-0"+(n-4));
						}
						else{
							map2.put("timesheet_date", yearStr+"-"+monthStr+"-"+(n-4));
						}
					//	map2.put("timesheet_symbol", "5110000041000000001");
						if("○".equals(mapColumnInfoIn2.get(n).toString())){
							map2.put("timesheet_symbol", "5110000052000000002");
						}else if("√".equals(mapColumnInfoIn2.get(n).toString())){
							map2.put("timesheet_symbol", "5110000052000000001");
						}else if("△".equals(mapColumnInfoIn2.get(n).toString())){
							map2.put("timesheet_symbol", "5110000052000000003");
						}else if("⊙".equals(mapColumnInfoIn2.get(n).toString())){
							map2.put("timesheet_symbol", "5110000052000000004");
						}else if("×".equals(mapColumnInfoIn2.get(n).toString())){
							map2.put("timesheet_symbol", "5110000052000000005");
						}else if("◇".equals(mapColumnInfoIn2.get(n).toString())){
							map2.put("timesheet_symbol", "5110000052000000007");
						}else{
							map2.put("timesheet_symbol", "5110000052000000001");
						}
						
						map2.put("sap_id", mapColumnInfoIn2.get(2));
						map2.put("code_id", mapColumnInfoIn2.get(1));
						//直接给dev_acc_id扔进来
						map2.put("employee_id", employee_id);
						dataList.add(map2);
						break;
					}
			}
				
			}
		}
		return dataList;
	}
	
	/**
	 * 根据省份证号和SAP员工编号关键信息，查询数据库的id信息
	 * @param selfnum
	 * @param licensenum
	 * @param devsign
	 * @return
	 */
	private String getKQByID(String projectinfoid,String codeId,String sapId){
		if(codeId==null&&sapId==null)
			return null;
		String sql ="";
 
		if(!codeId.equals(null) || !sapId.equals(null) ){
		  sql="select e.org_id, e.employee_id, e.employee_id_code_no,hr.employee_cd    from comm_human_employee e   left join comm_human_employee_hr hr on hr.employee_id=e.employee_id and hr.bsflag='0'         where e.bsflag = '0' and e.employee_id_code_no='"+codeId+"'";
		}
		if(!codeId.equals(null)  && !codeId.equals("") ){
			  sql="select os.org_subjection_id,tt.employee_id,tt.employee_id_code_no from comm_org_subjection os   join comm_org_information oi on os.org_id = oi.org_id   and oi.bsflag = '0'  join (select e.org_id, e.employee_id,e.employee_id_code_no    from comm_human_employee e    where e.bsflag = '0'       union    select l.owning_org_id as org_is,     l.labor_id      as employee_id,   l.employee_id_code_no      from bgp_comm_human_labor l     where l.bsflag = '0') tt     on tt.org_id = oi.org_id       where os.bsflag = '0' and tt.employee_id_code_no='"+codeId+"'";
		}
      if(!sapId.equals(null) && !sapId.equals("") ){
 			  sql="select e.org_id, e.employee_id, e.employee_id_code_no,hr.employee_cd    from comm_human_employee e   left join comm_human_employee_hr hr on hr.employee_id=e.employee_id and hr.bsflag='0'         where e.bsflag = '0' and hr.employee_cd='"+sapId+"'";
 		}
		Map g=jdbcDao.queryRecordBySQL(sql);
		if(g==null||g.get("employee_id")==null||"".equals(g.get("employee_id")))
			return null;
		return g.get("employee_id").toString();
	}
	
	
	//人员考勤
	public ISrvMsg getAttendanceInfoKq(ISrvMsg reqDTO) throws Exception{
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		UserToken user = reqDTO.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		 
		String employee_id = reqDTO.getValue("deviceId");//where device_account_id='"+device_acc_id+"'
		String startDate = reqDTO.getValue("startDate");
		
		String sDay=startDate.substring(8);  
		String   sDayN=sDay.substring(0,1);
		String   sDayB=sDay.substring(1,2);
		if(sDayN.equals("0")){
			sDay=sDayB;
		}
         int days= Integer.parseInt(sDay);
		String sMonth=startDate.substring(5,7); 
		String sMonthN=sMonth.substring(0,1);
		String sMonthB=sMonth.substring(1,2);
		if(sMonthN.equals("0")){
			sMonth=sMonthB;
		}
		String months=startDate.substring(0,7); 
 
		for (int i = 1; i < days; i++) { 
			String dayNum=Integer.toString(i); 
			if(dayNum.length()==1){
				dayNum="0"+dayNum;
			}
			Map map=new HashMap();
			
			Map kqms_Ids = jdbcDAO.queryRecordBySQL("select kqms_id,employee_id,timesheet_date,project_id   from  BGP_COMM_EMPLOYEE_KQMS   where bsflag='0' and  to_char(timesheet_date ,'yyyy-MM-dd')='"+months+"-"+dayNum+"'  and employee_id='"+employee_id+"'  and project_id='"+projectInfoId+"' ");				
				if( kqms_Ids != null){			 
					    map.put("kqms_id",kqms_Ids.get("kqms_id"));
						map.put("timesheet_symbol", "5110000052000000006");
						map.put("RECORD_STATUS", "9");
						jdbcDao.saveOrUpdateEntity(map, "BGP_COMM_EMPLOYEE_KQMS");
				}else{ 
				map.put("EMPLOYEE_ID", employee_id); 
				map.put("timesheet_date",months+"-"+dayNum);
				map.put("timesheet_symbol", "5110000052000000006");
				map.put("PROJECT_ID", projectInfoId);
				map.put("RECORD_STATUS", "9");
				map.put("BSFLAG", "0");
				//System.out.println(months+"-"+dayNum);
				  jdbcDao.saveOrUpdateEntity(map, "BGP_COMM_EMPLOYEE_KQMS");
				}
		}
 
		
		String gr="select to_char(a.timesheet_date,'yyyy') as Year,to_char(a.timesheet_date,'mm') as month from BGP_COMM_EMPLOYEE_KQMS a where a.employee_id='"+employee_id+"' and bsflag='0' group by to_char(a.timesheet_date,'yyyy'),to_char(a.timesheet_date,'mm') order by to_char(a.timesheet_date,'yyyy'),to_char(a.timesheet_date,'mm') desc";
		List<Map>g=jdbcDao.queryRecords(gr);
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		 
		responseMsg.setValue("employee_id",employee_id);
		responseMsg.setValue("group", g);
		return responseMsg;
	}
	
	/**
	 * 删除人员考勤记录
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteKQ(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String deviceId = isrvmsg.getValue("deviceId"); 
		String date = isrvmsg.getValue("date"); 
		
		String updateSql = "update BGP_COMM_EMPLOYEE_KQMS t set t.bsflag='1'  where t.employee_id='"+deviceId+"' and t.timesheet_date=to_date('"+date+"','yyyy-mm-dd')";
		 jdbcDao.executeUpdate(updateSql);
   
		return responseDTO;

	}
	
	//人员考勤页面添加
	public ISrvMsg savekq(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String projectInfoId = user.getProjectInfoNo();
		String stateT = isrvmsg.getValue("state");
	
		Map map=new HashMap();
		map.put("EMPLOYEE_ID", isrvmsg.getValue("employee_id")); 
		map.put("timesheet_date", isrvmsg.getValue("timesheet_date"));
		map.put("timesheet_symbol", isrvmsg.getValue("kqstate"));
		map.put("PROJECT_ID", projectInfoId);
		map.put("RECORD_STATUS", stateT);
		
		jdbcDao.saveOrUpdateEntity(map, "BGP_COMM_EMPLOYEE_KQMS");
		responseDTO.setValue("message", "保存成功!");
		responseDTO.setValue("shuaId",isrvmsg.getValue("employee_id"));
		return responseDTO;
	}
	
 public String getCellValue(HSSFCell cell) {
         String value = "";
         if (cell != null) {
             switch (cell.getCellType()) {
             case HSSFCell.CELL_TYPE_FORMULA:
                 // cell.getCellFormula();
                 try {
                     value = String.valueOf(cell.getNumericCellValue());
                 } catch (IllegalStateException e) {
                     value = String.valueOf(cell.getRichStringCellValue());
                 }
                 break;
             case HSSFCell.CELL_TYPE_NUMERIC:
             value = String.valueOf(cell.getNumericCellValue());
                 break;
             case HSSFCell.CELL_TYPE_STRING:
                 value = String.valueOf(cell.getRichStringCellValue());
                 break;
             }
         }
 
         return value;
     }
 
 
 


/*
 *正式工人员信息数据导出
 */
public ISrvMsg exportHummanList(ISrvMsg reqDTO) throws Exception {
	MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
	UserToken user = reqDTO.getUserToken();
	String projectInfoNo = user.getProjectInfoNo(); 
 
	String employeeGz = reqDTO.getValue("employeeGz");
	String orgSubId = reqDTO.getValue("orgSubId");
    
	StringBuilder subsql = new StringBuilder(); 
		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../rm/em/commHumanInfo/humanReportList.xls"));
		Sheet sheet = wb.getSheetAt(0);
		int rows = sheet.getPhysicalNumberOfRows();
		String[] colName = { "employee_cd", "employee_name", "employee_gender_name", "age", "employee_birth_date", "employee_nation_name", "nationality_name", "employee_education_level_name", "org_name", "post",
				"post_sort_name", "post_level_name", "workerfrom_name", "employee_gz_name", "work_date", "work_cnpc_date", "set_team_name", "set_post_name", "spare7_name", "mail_address",
				"language_sort_name", "language_level_name", "phone_num", "employee_mobile_phone", "home_address", "e_mail", "qq", "account_place", "institutions_type", "grass_root_unit",
				"go_abroad_time", "home_time", "present_state", "now_start_date", "implementation_date", "household_type", "start_salary_date", "technical_time", "post_sequence", "post_exam",
				"toefl_score", "tofel_listening", "if_qualified_n", "nine_result", "if_qualifieds_n", "holds_result"};
		
		subsql.append("select t.*, nvl(d11.coding_name, t.set_teamw) set_team_name,    nvl(d12.coding_name, t.set_postw) set_post_name   from (select h.employee_cd, e.employee_id, e.org_id, e.employee_name, decode(e.employee_gender, '0', '女', '1', '男') employee_gender_name, (to_char(sysdate, 'YYYY') - to_char(e.employee_birth_date, 'YYYY')) age,  h.spare7,i.org_abbreviation org_name, h.post, h.post_level, d1.coding_name post_level_name, e.employee_education_level, d2.coding_name employee_education_level_name, s.org_subjection_id,e.modifi_date,h.home_address,h.qq,h.e_mail,h.employee_gz ,  cft.coding_code as dalei,cft.coding_code_id as xiaolei ,h.if_qualified,h.if_qualifieds ,to_char(e.employee_birth_date, 'yyyy-MM-dd') employee_birth_date,  nvl(d3.coding_name, e.employee_nation) employee_nation_name,   nvl(d7.coding_name, h.nationality) nationality_name,   e.mail_address,  e.phone_num,  e.employee_mobile_phone,  nvl(d4.coding_name, h.employee_gz) employee_gz_name, nvl(d8.coding_name, h.post_sort) post_sort_name,  nvl(d5.coding_name, h.df_workerfrom) workerfrom_name,   nvl(d9.coding_name, h.language_sort) language_sort_name,  nvl(d10.coding_name, h.language_level) language_level_name,    nvl(d6.coding_name, e.employee_health_info) employee_health_info_name,  to_char(h.work_date, 'yyyy-MM-dd') work_date,  to_char(h.work_cnpc_date, 'yyyy-MM-dd') work_cnpc_date,   e.employee_id_code_no,  nvl(phr.work_post,  h.set_post) set_postw,  nvl(phr.team, h.set_team) set_teamw,  decode(h.spare7,  '0',  '一线员工',  '1',  '境外一线',  '2',  '二线员工',  '4',  '三线员工',  '3',  '境外二三线',  '') spare7_name,  h.spare2,   decode(h.household_type, '0', '农业', '1', '非农业') household_type,  decode(h.institutions_type, '0', '境外项目', '1', '总部机关') institutions_type,  h.grass_root_unit,  h.go_abroad_time,  h.home_time,  nvl(d13.coding_name, h.present_state) present_state_name,  h.now_start_date,  h.implementation_date,  h.account_place,  h.start_salary_date,  h.technical_time,  h.post_sequence,  h.post_exam,  h.toefl_score,  h.tofel_listening,  decode(h.if_qualified, '0', '是', '1', '否') if_qualified_n,  h.nine_result,  decode(h.if_qualifieds, '0', '是', '1', '否') if_qualifieds_n,  h.holds_result,  h.pin_whether,  h.pin_unit,  pin2.org_hr_short_name as pin_unit_name    from comm_human_employee e inner join comm_human_employee_hr h on e.employee_id = h.employee_id left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' left join comm_org_information i on e.org_id = i.org_id and i.bsflag = '0' left join comm_coding_sort_detail d1 on h.post_level = d1.coding_code_id and d1.bsflag = '0' left join comm_coding_sort_detail d2 on e.employee_education_level = d2.coding_code_id and d2.bsflag = '0'   left join  bgp_comm_human_certificate cft  on cft.employee_id= e.employee_id  and cft.bsflag='0'   left join comm_coding_sort_detail d3  on e.employee_nation = d3.coding_code_id  and d3.bsflag = '0'         left join comm_coding_sort_detail d4  on h.employee_gz = d4.coding_code_id  and d4.bsflag = '0'    left join comm_coding_sort_detail d5  on h.df_workerfrom = d5.coding_code_id  and d5.bsflag = '0'  left join comm_coding_sort_detail d6  on e.employee_health_info = d6.coding_code_id  and d6.bsflag = '0'  left join comm_coding_sort_detail d7  on h.nationality = d7.coding_code_id  and d7.bsflag = '0'  left join comm_coding_sort_detail d8  on h.post_sort = d8.coding_code_id  and d8.bsflag = '0'  left join comm_coding_sort_detail d9  on h.language_sort = d9.coding_code_id  and d9.bsflag = '0'  left join comm_coding_sort_detail d10  on h.language_level = d10.coding_code_id  and d10.bsflag = '0'   left join   (    select d2.*  from (select d1.*  from (   select hr.team,hr.work_post,hr.employee_id,    hr.actual_start_date,    hr.actual_end_date , row_number() over(partition by hr.employee_id order by hr.actual_end_date  desc) numa  from bgp_project_human_relation hr      where hr.bsflag='0'  and hr.locked_if='1'  ) d1  where d1.numa = 1) d2   )  phr  on   e.employee_id= phr.employee_id   left join comm_coding_sort_detail d13  on h.present_state = d13.coding_code_id  left join comm_org_subjection pin  on h.pin_unit = pin.org_subjection_id  and pin.bsflag = '0'  left join bgp_comm_org_hr_gms pin1  on pin1.org_gms_id = pin.org_id  left join bgp_comm_org_hr pin2  on pin2.org_hr_id = pin1.org_hr_id   where e.bsflag = '0' and h.bsflag='0'  and h.employee_gz ='").append(employeeGz).append("' and ( s.org_subjection_id like '").append(orgSubId).append("%' or  h.pin_unit = '").append(orgSubId).append("' ) order by e.modifi_date desc,e.employee_name desc ) t  left join comm_coding_sort_detail d11    on t.set_teamw = d11.coding_code_id  left join comm_coding_sort_detail d12    on t.set_postw = d12.coding_code_id    ");
        
		List<Map> list =  BeanFactory.getPureJdbcDAO().queryRecords( subsql.toString());
		for (Map map : list) {
			Row row = sheet.createRow(rows++);
			int col = 0;
			for (String s : colName) {
				Cell cell = row.createCell(col++);
				cell.setCellValue((String) map.get(s));
			}
		}

		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename("人员基本信息.xls");
		os.close();
		mqmsgimpl.setFile(wsfile); 
	
	return mqmsgimpl;

}



/*
 *临时工人员信息数据导出
 */
public ISrvMsg exportLaborList(ISrvMsg reqDTO) throws Exception {
	MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
	UserToken user = reqDTO.getUserToken();
	String projectInfoNo = user.getProjectInfoNo(); 
 
	String ifEngineer = reqDTO.getValue("ifEngineer");
	String orgSubId = reqDTO.getValue("orgSubId");
    
	StringBuilder subsql = new StringBuilder(); 
		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../rm/em/humanLabor/laborReportList.xls"));
		Sheet sheet = wb.getSheetAt(0);
		int rows = sheet.getPhysicalNumberOfRows();
		String[] colName = { "employee_name", "employee_gender_name", "employee_health_info", "employee_id_code_no", "employee_birth_date", "employee_nation_name", "elite_if_name", "employee_education_level_name", "employee_address", "apply_teams",
				"posts", "phone_num", "workerfrom_name", "technical_title_name", "mobile_number", "org_name", "if_engineer_name", "if_project_name", "postal_code", "cont_num",
				"specialty", "labor_distribution", "nationality_name", "household_type", "institutions_type", "grass_root_unit", "go_abroad_time", "home_time", "present_state", "now_start_date",
				"implementation_date", "account_place", "start_salary_date", "technical_time", "post_sequence", "post_exam", "toefl_score", "tofel_listening", "if_qualified", "nine_result",
				"if_qualifieds", "holds_result", "position_type", "position_name"};
		
		subsql.append("select * from  (select distinct l.*, d3.coding_name posts, d4.coding_name apply_teams from ( select  distinct  l.bsflag,l.labor_id, l.employee_name, d11.coding_name position_name,decode(l.position_type,'0110000021000000003','技能操作类','0110000021000000002','专业技术类','0110000021000000001','管理类','')position_type,decode(l.labor_category, '0', '临时季节性用工', '1', '再就业人员', '2', '劳务派遣人员', '3', '其他用工', l.labor_category) labor_category, nvl(t1.post ,l.post ) post, nvl(t1.apply_team,l.apply_team ) apply_team, l.employee_nation, d1.coding_name employee_nation_name, l.employee_gender, l.owning_org_id, l.owning_subjection_org_id, decode(l.employee_gender, '0', '女', '1', '男', l.employee_gender) employee_gender_name, decode(nvl(l.if_project, 0), '0', '不在项目', '1', '在项目', l.if_project) if_project_name, l.if_project, l.if_engineer, d5.coding_name if_engineer_name, l.cont_num, l.employee_birth_date, l.employee_id_code_no, l.employee_education_level, d2.coding_name employee_education_level_name, l.employee_address, l.phone_num, l.employee_health_info, l.specialty, l.elite_if, l.workerfrom,  case when lt.nu  is null then '否' else '是' end fsflag, case when lt.nu is null then '' else 'red' end bgcolor, nvl(t.years, 0) years,l.create_date  , cft.coding_code as dalei,cft.coding_code_id as xiaolei ,decode(l.labor_distribution,  '0',  '一线员工',  '1',  '境外一线',  '2',  '二线员工',  '4',  '三线员工', '3',  '境外二三线',  l.labor_distribution) labor_distribution,    i.org_name,  l.postal_code,  l.mobile_number,  decode(nvl(l.elite_if, 0), '0', '否', '1', '是', l.elite_if) elite_if_name,    decode(l.household_type, '0', '农业', '1', '非农业') household_type,  d6.coding_name workerfrom_name,  l.technical_title,  d7.coding_name technical_title_name,  d8.coding_name nationality_name,   decode(l.institutions_type, '0', '境外项目', '1', '总部机关') institutions_type,  l.grass_root_unit,  l.go_abroad_time,  l.home_time,  nvl(d10.coding_name, l.present_state) present_state_name,  l.now_start_date,  l.implementation_date,  l.account_place,  l.start_salary_date,  l.technical_time,  l.post_sequence,  l.post_exam,  l.toefl_score,  l.tofel_listening,  decode(l.if_qualified, '0', '是', '1', '否') if_qualified,  l.nine_result,   decode(l.if_qualifieds, '0', '是', '1', '否') if_qualifieds,  l.holds_result  from bgp_comm_human_labor l left join (select lt.labor_id, count(1) nu   from bgp_comm_human_labor_list lt left join  bgp_comm_human_labor l on   l.labor_id = lt.labor_id     where lt.bsflag = '0' and l.bsflag='0'   group by lt.labor_id) lt on l.labor_id = lt.labor_id  left join (select d2.* from (select d1.* from (select d.apply_team, d.post, l1.labor_id, row_number() over(partition by l1.labor_id order by d.start_date desc) numa from bgp_comm_human_deploy_detail d left join bgp_comm_human_labor_deploy l1 on d.labor_deploy_id = l1.labor_deploy_id where d.bsflag = '0') d1 where d1.numa = 1) d2) t1  on l.labor_id = t1.labor_id  left join comm_coding_sort_detail d1 on l.employee_nation = d1.coding_code_id left join comm_coding_sort_detail d2 on l.employee_education_level = d2.coding_code_id left join comm_coding_sort_detail d5 on l.if_engineer = d5.coding_code_id left join comm_org_subjection cn on l.owning_org_id = cn.org_id and cn.bsflag='0'      left join comm_org_information i    on l.owning_org_id = i.org_id   left join comm_coding_sort_detail d6    on l.workerfrom = d6.coding_code_id  left join comm_coding_sort_detail d7    on l.technical_title = d7.coding_code_id  left join comm_coding_sort_detail d8    on l.nationality = d8.coding_code_id  left join comm_coding_sort_detail d10    on l.present_state = d10.coding_code_id   left join comm_coding_sort_detail d11  on l.position_nationality = d11.coding_code_id   left join (select count(distinct to_char(t.start_date, 'yyyy')) years, t.labor_id from bgp_comm_human_labor_deploy t group by t.labor_id) t on l.labor_id = t.labor_id   left join  bgp_comm_human_certificate cft  on cft.employee_id= l.labor_id  and cft.bsflag='0'     where l.bsflag = '0' and l.if_engineer ='").append(ifEngineer).append("' and l.owning_subjection_org_id like '%").append(orgSubId).append("%' ) l  left join comm_coding_sort_detail d3 on l.post = d3.coding_code_id left join comm_coding_sort_detail d4 on l.apply_team = d4.coding_code_id ) t where t.bsflag='0' order by t.create_date desc   ");
        
		List<Map> list =  BeanFactory.getPureJdbcDAO().queryRecords( subsql.toString());
		for (Map map : list) {
			Row row = sheet.createRow(rows++);
			int col = 0;
			for (String s : colName) {
				Cell cell = row.createCell(col++);
				cell.setCellValue((String) map.get(s));
			}
		}

		WSFile wsfile = new WSFile();
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		wb.write(os);
		wsfile.setFileData(os.toByteArray());
		wsfile.setFilename("人员基本信息.xls");
		os.close();
		mqmsgimpl.setFile(wsfile); 
	
	return mqmsgimpl;

}




}

