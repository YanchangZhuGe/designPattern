package com.bgp.gms.service.rm.em.srv;

import java.io.ByteArrayInputStream;
import java.io.Serializable;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.bgp.gms.service.rm.em.pojo.BgpHumanPlanDetail;
import com.bgp.gms.service.rm.em.pojo.BgpHumanPrepare;
import com.bgp.gms.service.rm.em.pojo.BgpHumanPrepareHumanDetail;
import com.bgp.gms.service.rm.em.pojo.BgpHumanPreparePostDetail;
import com.bgp.gms.service.rm.em.pojo.BgpHumanTrainingPlan;
import com.bgp.gms.service.rm.em.pojo.BgpProjectHumanPost;
import com.bgp.gms.service.rm.em.pojo.BgpProjectHumanRequirement;
import com.bgp.gms.service.rm.em.util.EquipmentAutoNum;
import com.bgp.gms.service.rm.em.util.PropertiesUtil;
import com.bgp.mcs.service.common.CodeSelectOptionsUtil;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WorkFlowBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.DataPermission;
import com.cnpc.jcdp.common.IDataPermProcessor;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IJdbcDao;
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
 * creator time:2012-6-18
 * 
 * description:人员申请及审核公共服务
 * 
 */
public class HumanRequiredSrv extends BaseService {
	// 保存所要操作的业务表的信息包括表名,主键名
	private static final String[] infoKeyName = { "requirement_no",
			"human_relief_no", "profess_no" };

	private static final String[] operType = { "RPTP", "RJTP", "RZTP" };
	private static final String[] infoTableName = {
			"bgp_project_human_requirement", "bgp_project_human_relief",
			"bgp_project_human_profess" };
	private static final String[] detailTableName = { "bgp_project_human_post",
			"bgp_project_human_reliefdetail", "bgp_project_human_profess_post" };
	private static final String[] detaTableName = { "",
			"bgp_project_human_relief_deta", "bgp_project_human_profess_deta" };

	// 保存所要操作的下列列表
	private static final String[] selectName = { "hrAgeOps", "hrDegreeOps",
			"workYearOps" };

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IJdbcDao queryJdbcDao = BeanFactory.getQueryJdbcDAO();

	/**
	 * 点击新增页面查询 页面自带数据
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg humanApplyView(ISrvMsg reqDTO) throws Exception {

		UserToken user = reqDTO.getUserToken();
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer employee = new StringBuffer(
				"select rownum, r.proc_status, decode(r.proc_status,  '1',        '待审核',        '3',        '审核通过',        '4',        '审核不通过',        '未提交') proc_status_name, r.requirement_no, p.project_name, i.org_id, r.apply_company, i.org_name applicant_org_name, r.applicant_id, t2.employee_name applicant_name, To_char(r.apply_date, 'yyyy-MM-dd hh24:mi') apply_date, To_char(r.create_date, 'yyyy-MM-dd hh24:mi') create_date, r.apply_no, t6.notice_way, t6.notice_user_id, t6.notice_user_name, t5.update_status from bgp_project_human_requirement r  left join gp_task_project p on r.project_info_no = p.project_info_no   and p.bsflag = '0' left join comm_org_information i on r.apply_company = i.org_id and i.bsflag = '0' left join comm_human_employee t2 on r.applicant_id = t2.employee_id      and t2.bsflag = '0' left outer join (select distinct Replace(wmsys.wm_concat(t3.notifier_method),    ',',    '@') notice_way,   Replace(wmsys.wm_concat(distinct   t2.employee_id),',', '@') notice_user_id, Replace(wmsys.wm_concat(distinct t4.employee_name),  ',',  '@') notice_user_name,  business_key  from bgp_comm_notifer_info t1  inner join bgp_comm_notifer_detail t2 on t1.notifer_info_id =   t2.notifer_info_id  and t1.bsflag = '0'  and t1.business_assistant_key =   'humanApply'  and t2.bsflag = '0'  inner join bgp_comm_notifier_method t3 on t2.notifer_detail_id =    t3.notifer_detail_id  and t3.bsflag = '0'  left outer join comm_human_employee t4 on t2.employee_id =     t4.employee_id  and t4.bsflag = '0' group by business_key) t6 on r.requirement_no =        t6.business_key  left join (select t1.requirement_no,  decode(nvl(sum(abs(t2.people_number -  nvl(t2.audit_number, t2.people_number))),0),  0,  '无',  '有') update_status  from bgp_project_human_requirement t1  left join bgp_project_human_post t2 on t1.requirement_no =  t2.requirement_no   and t1.bsflag = '0' and t2.bsflag='0'  group by t1.requirement_no) t5 on r.requirement_no = t5.requirement_no  where r.bsflag = '0' and r.proflag= '0' ");

		Map HumanApplyMap = new HashMap();
		if (null != projectInfoNo && !"".equals(projectInfoNo)) {
			employee.append("  and r.project_info_no='").append(projectInfoNo)
					.append("'");
			HumanApplyMap = jdbcDAO.queryRecordBySQL(employee.toString());
		}

		if (HumanApplyMap != null) {
			responseMsg.setValue("HumanApplyMap", HumanApplyMap);
		}

		return responseMsg;
	}

	/**
	 * 进入人员需求/调剂需求页面包括新增及修改
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "unchecked", "rawtypes" })
	public ISrvMsg getHumanApplyInfo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		if(selectName != null){
			for(int i= 0;i < selectName.length; i++){
				List<Map> selectCode = CodeSelectOptionsUtil.getOptionByName(selectName[i]);
				String selectStr = "";
				for (int j = 0; selectCode != null && j < selectCode.size(); j++) {
					
					selectStr += (String) selectCode.get(j).get("value") + ","
							+ (String) selectCode.get(j).get("label") + "@";
				}
				if (!"".equals(selectStr)) {
					selectStr = selectStr.substring(0, selectStr.length() - 1);
					switch(i){
						case 0:responseDTO.setValue("ageStr", selectStr); break;
						case 1:responseDTO.setValue("degreeStr", selectStr); break;
						case 2:responseDTO.setValue("workYearStr", selectStr); break;
						default:break;
					}
				}
			}			
		}
		
		String keyId = reqDTO.getValue("id");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String projectInfoType = reqDTO.getValue("projectInfoType");
		if(reqDTO.getValue("projectInfoType") !=null && reqDTO.getValue("projectInfoType") !="null" && !"".equals(reqDTO.getValue("projectInfoType"))){
			projectInfoType = reqDTO.getValue("projectInfoType"); 
		}else{
			projectInfoType = user.getProjectType(); 
			if(projectInfoType.equals("5000100004000000008")){
				projectInfoType="5000100004000000001";
			}
			if(projectInfoType.equals("5000100004000000010")){
				projectInfoType="5000100004000000001";
			} 
			if(projectInfoType.equals("5000100004000000002")){
				projectInfoType="5000100004000000001";
			}
		}
		
		//工作流中控制页面按钮使用
		String buttonView = "true";
		if(reqDTO.getValue("buttonView") !=null && reqDTO.getValue("buttonView") !="null" && !"".equals(reqDTO.getValue("buttonView"))){
			buttonView = reqDTO.getValue("buttonView");
		}
		responseDTO.setValue("buttonView", buttonView);
		// 申请表主键

		if (keyId == null || "".equals(keyId)) {
			Map map = new HashMap();
			map.put("applicantName", user.getUserName());
			map.put("applicantId", user.getEmpId());
			map.put("applicantOrgName", user.getOrgName());
			map.put("applyCompany", user.getOrgId());
			String applyDate = new SimpleDateFormat("yyyy-MM-dd")
					.format(new Date());
			map.put("applyDate", applyDate);
			map.put("projectInfoNo", projectInfoNo);
			
			String sql="select t.project_name from gp_task_project t where t.project_info_no = '"+projectInfoNo+"'";
			Map pro = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
			map.put("projectName", pro.get("projectName"));

			responseDTO.setValue("applyInfo", map);

			// 查询子表信息
			//StringBuffer subsql = new StringBuffer(" select distinct d.apply_team, s1.coding_name apply_teamname, d.post, s2.coding_name postname,  sum(nvl(d.people_number,0)) spare2, sum(nvl(d.profess_number,0)) spare3, d.plan_start_date, d.plan_end_date, ");
			//subsql.append(" sum(nvl(z1,0)) z1,case when sum(nvl(d.people_number,0))-sum(nvl(d.profess_number,0))-sum(nvl(z1, 0))  <0 then 0 else sum(nvl(d.people_number,0))-sum(nvl(d.profess_number,0))-sum(nvl(z1, 0))  end  z2, sum(nvl(z3, 0)) + sum(nvl(z4, 0)) z3 ");
			
			   StringBuffer subsql = new StringBuffer("select t.* , sum(nvl(q1.z1, 0)) z1,   case  when nvl(t.spare2, 0) -  nvl(t.spare3, 0)  - sum(nvl(q1.z1, 0)) < 0 then  0     else    nvl(t.spare2, 0)  -  nvl(t.spare3, 0)  - sum(nvl(q1.z1, 0))   end z2     from       (select distinct d.apply_team,  s1.coding_name apply_teamname,    d.post,    s2.coding_name postname,sum(nvl(d.people_number, 0)) spare2,   sum(nvl(d.profess_number, 0)) spare3,  d.plan_start_date,  d.plan_end_date ,  sum(nvl(q2.z3, 0)) + sum(nvl(q2.z4, 0)) z3 ");  
			
			subsql.append(" from ( select distinct d.plan_detail_id,d.task_id,d.apply_team,d.post,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums ");
			subsql.append(" from bgp_comm_human_plan_detail d ");
			subsql.append(" left join bgp_comm_human_plan p on p.project_info_no=d.project_info_no and p.bsflag='0' ");
			subsql.append(" left join common_busi_wf_middle te on te.business_id=p.plan_id and te.business_type in ('5110000004100000022','5110000004100001057')  and te.bsflag='0' ");
			subsql.append(" where d.project_info_no='").append(projectInfoNo).append("' and te.proc_status='3' and d.bsflag='0'  ");
			//根据综合物化探需求修改  加入生产管理模块中录入的人力信息
			//subsql.append(" left join common_busi_wf_middle te  on (te.business_id = p.project_info_no or te.business_id = p.plan_id) and te.business_type in('5110000004100000095','5110000004100000022') and te.bsflag='0' ");
			//配置   
			//生产模块，综合类型项目配置计划流程编码为 5110000004100000095
			subsql.append(" union select distinct d.plan_detail_id,d.task_id,d.apply_team,d.post,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date - d.plan_start_date) nums ");
			subsql.append("from  bgp_comm_human_plan p left join bgp_comm_human_plan_detail d on p.project_info_no = d.project_info_no and p.bsflag = '0' and d.spare1 is null ");
			subsql.append("left join common_busi_wf_middle te on te.business_id = p.project_info_no  and te.bsflag = '0' ");
			subsql.append("where d.project_info_no = '"+projectInfoNo+"' and te.proc_status = '3' and d.bsflag = '0' and p.spare1 is null ");
			//补充配置
			subsql.append("union select distinct d.plan_detail_id,d.task_id,d.apply_team,d.post,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date - d.plan_start_date) nums ");
			subsql.append("from gp_middle_resources r left join   bgp_comm_human_plan p on p.plan_id=r.human_id and p.bsflag='0' left join  bgp_comm_human_plan_detail d ");
			subsql.append("on p.plan_id=d.spare1 and p.bsflag = '0' left join common_busi_wf_middle te on te.business_id = r.mid and te.bsflag = '0' ");
			subsql.append("where d.project_info_no = '"+projectInfoNo+"' and te.proc_status = '3' and d.bsflag = '0' and p.spare1 is not null ");		
			
			subsql.append("  ) d ");			
			subsql.append(" left join comm_coding_sort_detail s1 on d.apply_team = s1.coding_code_id and s1.bsflag = '0'  and s1.coding_mnemonic_id='"+projectInfoType+"' ");
			subsql.append(" left join comm_coding_sort_detail s2 on d.post = s2.coding_code_id and s2.bsflag = '0' and s2.coding_mnemonic_id='"+projectInfoType+"' ");		
			subsql.append(" left join (select sum(nvl(p2.own_num,0)) z3,sum(nvl(p2.deploy_num,0)) z4,p2.apply_team,p2.post from bgp_project_human_profess_post p2 ");
			subsql.append(" inner join bgp_project_human_profess r on p2.profess_no=r.profess_no and r.project_info_no = '").append(projectInfoNo).append("'  and r.bsflag='0'  ");
			subsql.append(" where p2.bsflag = '0' group by p2.apply_team,p2.post) q2 on q2.apply_team=d.apply_team and q2.post = d.post  ");
			//subsql.append(" left  join (    select  distinct     sum(nvl( p.audit_number,0)) anber ,         p.apply_team,   p.post      from bgp_project_human_post p   inner join bgp_project_human_requirement r      on p.requirement_no = r.requirement_no       and r.bsflag='0'         left join common_busi_wf_middle te       on te.business_id = r.requirement_no          and te.bsflag = '0'    where p.bsflag = '0'  and te.proc_status = '3'  and  r.project_info_no= '").append(projectInfoNo).append("'   group  by  p.apply_team,     p.post    )hpt       on hpt.apply_team = q1.team    and hpt.post = q1.work_post  "); //on hpt.apply_team=d.apply_team    and hpt.post=d.post   ");
			
			subsql.append("     group  by d.apply_team,s1.coding_name, d.post ,  d.plan_start_date,  d.plan_end_date , s2.coding_name   order by d.apply_team,d.post ");
			
			subsql.append(" ) t   left join (   select  sum(nvl(1, 0)) z1,  d.team,   d.work_post,       p.project_info_no   ,d.plan_start_date,  d.plan_end_date  from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p     on d.prepare_no = p.prepare_no    and p.prepare_status = '2'   left join bgp_project_human_relation r     on d.employee_id = r.employee_id    and p.project_info_no = r.project_info_no    and r.team = d.team    and r.work_post = d.work_post   left join common_busi_wf_middle te     on te.business_id = p.prepare_no    and te.bsflag = '0'   left join bgp_project_human_profess pr1     on pr1.profess_no = p.profess_no    and p.profess_no is not null    and pr1.bsflag = '0'   left join bgp_project_human_requirement pr     on pr.requirement_no = p.requirement_no    and p.requirement_no is not null    and pr.bsflag = '0'   left join bgp_project_human_relief re     on re.human_relief_no = p.human_relief_no    and p.human_relief_no is not null    and re.bsflag = '0'   left join gp_task_project t     on p.project_info_no = t.project_info_no  where p.bsflag = '0'    and d.bsflag = '0'    and p.project_info_no = '").append(projectInfoNo).append("'     and (te.business_id is null or te.proc_status = '3')    and d.actual_start_date is not null   and d.actual_end_date  is null    and (d.spare1 is null or d.spare1 = '1')    group by  d.team,d.work_post,p.project_info_no ,d.plan_start_date,  d.plan_end_date        ");
			//新增逻辑  已申请人数=已经调配接收正式工+ 申请临时工人数 
			subsql.append(" union all     select  distinct     sum(nvl( p.audit_number,0)) z1 ,         p.apply_team team,   p.post   work_post,   r.project_info_no,p.plan_start_date,p.plan_end_date     from bgp_project_human_post p   inner join bgp_project_human_requirement r      on p.requirement_no = r.requirement_no       and r.bsflag='0'         left join common_busi_wf_middle te       on te.business_id = r.requirement_no          and te.bsflag = '0'    where p.bsflag = '0'  and te.proc_status = '3'  and  r.project_info_no= '").append(projectInfoNo).append("'   group  by  p.apply_team,     p.post   ,  r.project_info_no,p.plan_start_date,p.plan_end_date    ) q1   on q1.team = t.apply_team   and q1.work_post = t.post and q1.plan_start_date=t.plan_start_date  and q1.plan_end_date=t.plan_end_date   ");//   
			subsql.append("   group by  t.apply_team,   t.apply_teamname,  t.post,  t.plan_start_date,   t.plan_end_date,  t.postname,t.z3,t.spare2, t.spare3 ");
		
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
			responseDTO.setValue("detailInfo", list);
		} else {
			// 查询主表信息
			Map map = new HashMap();
			StringBuffer sb = new StringBuffer(" select r.requirement_no,r.project_info_no,t.project_name, ");
			sb.append(" r.apply_company, to_char(r.apply_date,'yyyy-MM-dd') apply_date,r.applicant_id, ");
			sb.append(" r.apply_no,r.apply_state,r.notes,");
			sb.append(" t1.org_name applicant_org_name,t2.employee_name applicant_name ");
			sb.append(" from bgp_project_human_requirement r ");
			sb.append(" left join gp_task_project t on r.project_info_no = t.project_info_no and r.bsflag = '0' ");
			sb.append(" left join comm_org_information t1 on r.apply_company = t1.org_id and t1.bsflag = '0' ");
			sb.append(" left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0' ");
			sb.append(" where r.requirement_no='").append(keyId).append("' ");

			map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
			responseDTO.setValue("applyInfo", map);

			// 查询子表信息
			StringBuffer subsql = new StringBuffer("  select  distinct p.post_no,p.notes, ");
			subsql.append(" p.people_number,p.audit_number,   nvl(p.spare2, 0)  spare2,p.spare3, ");
			subsql.append(" p.age,p.culture,p.work_years,p.apply_team,p.post,p.plan_start_date, ");
			subsql.append(" p.plan_end_date,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname, ");
			//subsql.append(" nvl(z1, 0)+nvl(hpt.anber, 0) z1 ,case when nvl(p.spare2,0)-nvl(p.spare3,0)-nvl(z1, 0)-nvl(hpt.anber, 0)  <0 then 0 else nvl(p.spare2,0)-nvl(p.spare3,0)-nvl(z1, 0)-nvl(hpt.anber, 0) end  z2, nvl(z3, 0) + nvl(z4, 0) z3 ");
			subsql.append("   sum( nvl(z1, 0) ) z1 ,case when nvl(p.spare2,0)-nvl(p.spare3,0)-  sum( nvl(z1, 0) ) <0 then 0 else nvl(p.spare2,0)-nvl(p.spare3,0)-  sum( nvl(z1, 0) ) end  z2,   sum( nvl(z3, 0)) +   sum( nvl(z4, 0) )z3 ");
			subsql.append(" from bgp_project_human_post p");
			subsql.append(" inner join bgp_project_human_requirement r ").append("on p.requirement_no= r.requirement_no");
			subsql.append(" left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id  and d1.bsflag = '0'  and d1.coding_mnemonic_id='"+projectInfoType+"' ");
			subsql.append(" left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id  and d2.bsflag = '0'  and d2.coding_mnemonic_id='"+projectInfoType+"' ");
			
			//subsql.append(" left join (select sum(nvl(p1.people_number,0)) z1,p1.apply_team,p1.post from bgp_project_human_post p1 ");
			//subsql.append(" inner join bgp_project_human_requirement r on p1.requirement_no=r.requirement_no and r.project_info_no = '").append(projectInfoNo).append("'  and r.bsflag='0'  ");
			//subsql.append(" where p1.bsflag = '0' group by p1.apply_team,p1.post) q1 on  q1.apply_team=p.apply_team and  q1.post = p.post ");
			subsql.append(" left join ( select  sum(nvl(1, 0)) z1,  d.team, d.work_post,    p.project_info_no  ,d.plan_start_date,  d.plan_end_date    from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p     on d.prepare_no = p.prepare_no    and p.prepare_status = '2'   left join bgp_project_human_relation r     on d.employee_id = r.employee_id    and p.project_info_no = r.project_info_no    and r.team = d.team    and r.work_post = d.work_post   left join common_busi_wf_middle te     on te.business_id = p.prepare_no    and te.bsflag = '0'   left join bgp_project_human_profess pr1     on pr1.profess_no = p.profess_no    and p.profess_no is not null    and pr1.bsflag = '0'   left join bgp_project_human_requirement pr     on pr.requirement_no = p.requirement_no    and p.requirement_no is not null    and pr.bsflag = '0'    left join bgp_project_human_relief re     on re.human_relief_no = p.human_relief_no    and p.human_relief_no is not null    and re.bsflag = '0'   left join gp_task_project t     on p.project_info_no = t.project_info_no      where p.bsflag = '0'    and d.bsflag = '0'    and p.project_info_no =  '").append(projectInfoNo).append("'     and (te.business_id is null or te.proc_status = '3')    and d.actual_start_date is not null  and d.actual_end_date  is null  and (d.spare1 is null or d.spare1 = '1')      group by  d.team,d.work_post,p.project_info_no  ,d.plan_start_date,  d.plan_end_date  ");
			//新增逻辑  已申请人数=已经调配接收正式工+ 申请临时工人数 
			subsql.append(" union all     select  distinct     sum(nvl( p.audit_number,0)) anber ,         p.apply_team team,   p.post   work_post,   r.project_info_no,p.plan_start_date,p.plan_end_date     from bgp_project_human_post p   inner join bgp_project_human_requirement r      on p.requirement_no = r.requirement_no       and r.bsflag='0'         left join common_busi_wf_middle te       on te.business_id = r.requirement_no          and te.bsflag = '0'    where p.bsflag = '0'  and te.proc_status = '3'  and  r.project_info_no= '").append(projectInfoNo).append("'   group  by  p.apply_team,     p.post   ,  r.project_info_no,p.plan_start_date,p.plan_end_date    ) q1   on q1.team = p.apply_team   and q1.work_post = p.post and q1.plan_start_date=p.plan_start_date  and q1.plan_end_date=p.plan_end_date   ");//   
		
			subsql.append(" left join (select sum(nvl(p2.own_num,0)) z3,sum(nvl(p2.deploy_num,0)) z4,p2.apply_team,p2.post from bgp_project_human_profess_post p2 ");
			subsql.append(" inner join bgp_project_human_profess r on p2.profess_no=r.profess_no and r.project_info_no = '").append(projectInfoNo).append("' and r.bsflag='0'  ");
			subsql.append(" where p2.bsflag = '0' group by p2.apply_team,p2.post) q2 on q2.apply_team=p.apply_team and q2.post = p.post ");
			//subsql.append(" left  join (    select  distinct     sum(nvl( p.audit_number,0)) anber ,         p.apply_team,   p.post      from bgp_project_human_post p   inner join bgp_project_human_requirement r      on p.requirement_no = r.requirement_no       and r.bsflag='0'         left join common_busi_wf_middle te       on te.business_id = r.requirement_no          and te.bsflag = '0'     where p.bsflag = '0'   and te.proc_status = '3'  and  r.project_info_no='").append(projectInfoNo).append("'      group  by  p.apply_team,     p.post    )hpt      on hpt.apply_team = q1.team    and hpt.post = q1.work_post  "); // on hpt.apply_team=p.apply_team    and hpt.post=p.post ");
			subsql.append(" where p.bsflag='0' and p.requirement_no='").append(keyId).append("'  group by   p.post_no,  p.notes,  p.people_number,  p.audit_number,  p.spare2,  p.spare3,  p.age,  p.culture,  p.work_years,  p.apply_team,  p.post,  p.plan_start_date,  p.plan_end_date,  p.work_trade_years,  d1.coding_name  ,  d2.coding_name    order by p.apply_team,p.post ");

			List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
			responseDTO.setValue("detailInfo", list);

		}
		responseDTO.setValue("keyId", keyId);
		responseDTO.setValue("projectInfoNo", projectInfoNo);
		responseDTO.setValue("projectInfoType", projectInfoType);
		
		return responseDTO;
	}
	
	/**
	 * 进入人员需求/调剂需求页面包括新增及修改
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "unchecked", "rawtypes" })
	public ISrvMsg getHumanApplyInfowfpg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		if(selectName != null){
			for(int i= 0;i < selectName.length; i++){
				List<Map> selectCode = CodeSelectOptionsUtil.getOptionByName(selectName[i]);
				String selectStr = "";
				for (int j = 0; selectCode != null && j < selectCode.size(); j++) {
					
					selectStr += (String) selectCode.get(j).get("value") + ","
							+ (String) selectCode.get(j).get("label") + "@";
				}
				if (!"".equals(selectStr)) {
					selectStr = selectStr.substring(0, selectStr.length() - 1);
					switch(i){
						case 0:responseDTO.setValue("ageStr", selectStr); break;
						case 1:responseDTO.setValue("degreeStr", selectStr); break;
						case 2:responseDTO.setValue("workYearStr", selectStr); break;
						default:break;
					}
				}
			}			
		}
		
		String keyId = reqDTO.getValue("id");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		//工作流中控制页面按钮使用
		String buttonView = "true";
		if(reqDTO.getValue("buttonView") !=null && reqDTO.getValue("buttonView") !="null" && !"".equals(reqDTO.getValue("buttonView"))){
			buttonView = reqDTO.getValue("buttonView");
		}
		responseDTO.setValue("buttonView", buttonView);
		// 申请表主键

		if (keyId == null || "".equals(keyId)) {
			Map map = new HashMap();
			map.put("applicantName", user.getUserName());
			map.put("applicantId", user.getEmpId());
			map.put("applicantOrgName", user.getOrgName());
			map.put("applyCompany", user.getOrgId());
			String applyDate = new SimpleDateFormat("yyyy-MM-dd")
					.format(new Date());
			map.put("applyDate", applyDate);
			map.put("projectInfoNo", projectInfoNo);
			
			String sql="select t.project_name from gp_task_project t where t.project_info_no = '"+projectInfoNo+"'";
			Map pro = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
			map.put("projectName", pro.get("projectName"));

			responseDTO.setValue("applyInfo", map);

			// 查询子表信息
			StringBuffer subsql = new StringBuffer(" select d.apply_team, s1.coding_name apply_teamname, d.post, s2.coding_name postname,  nvl(d.people_number,0) spare2, nvl(d.profess_number,0) spare3, d.plan_start_date, d.plan_end_date, ");
			subsql.append(" nvl(z1,0) z1,case when nvl(d.people_number,0)-nvl(d.profess_number,0)-nvl(z1, 0) <0 then 0 else nvl(d.people_number,0)-nvl(d.profess_number,0)-nvl(z1, 0) end  z2, nvl(z3, 0) + nvl(z4, 0) z3 ");
			subsql.append(" from ( select p.apply_team, p.post,sum(p.people_number) people_number , sum(p.profess_number) profess_number,min(p.plan_start_date) plan_start_date, max(p.plan_end_date) plan_end_date,(max(p.plan_end_date)-min(p.plan_start_date)) nums from ( select distinct d.plan_detail_id,d.task_id,d.apply_team,d.post,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums ");
			subsql.append(" from bgp_comm_human_plan_detail d ");
			subsql.append(" left join bgp_comm_human_plan p on p.project_info_no=d.project_info_no and p.bsflag='0' ");
			subsql.append(" left join common_busi_wf_middle te on te.business_id=p.plan_id and te.business_type in ('5110000004100000022','5110000004100001057')   and te.bsflag='0' ");
			subsql.append(" where d.project_info_no='").append(projectInfoNo).append("' and te.proc_status='3' and d.bsflag='0' ");
			
			subsql.append(" ) p group by p.apply_team,p.post ) d ");
			
			subsql.append(" left join comm_coding_sort_detail s1 on d.apply_team = s1.coding_code_id and s1.bsflag = '0'  ");
			subsql.append(" left join comm_coding_sort_detail s2 on d.post = s2.coding_code_id and s2.bsflag = '0' ");
			subsql.append(" left join (select sum(nvl(p1.people_number,0)) z1,p1.apply_team,p1.post from bgp_project_human_post p1 ");
			subsql.append(" inner join bgp_project_human_requirement r on p1.requirement_no=r.requirement_no and r.project_info_no = '").append(projectInfoNo).append("' ");
			subsql.append(" where p1.bsflag = '0' group by p1.apply_team,p1.post) q1 on  q1.apply_team=d.apply_team and  q1.post = d.post ");
			subsql.append(" left join (select sum(nvl(p2.own_num,0)) z3,sum(nvl(p2.deploy_num,0)) z4,p2.apply_team,p2.post from bgp_project_human_profess_post p2 ");
			subsql.append(" inner join bgp_project_human_profess r on p2.profess_no=r.profess_no and r.project_info_no = '").append(projectInfoNo).append("' ");
			subsql.append(" where p2.bsflag = '0' group by p2.apply_team,p2.post) q2 on q2.apply_team=d.apply_team and q2.post = d.post ");
			subsql.append(" order by d.apply_team,d.post ");

			List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
			responseDTO.setValue("detailInfo", list);
		} else {
			// 查询主表信息
			Map map = new HashMap();
			StringBuffer sb = new StringBuffer(" select r.requirement_no,r.project_info_no,t.project_name, ");
			sb.append(" r.apply_company, to_char(r.apply_date,'yyyy-MM-dd') apply_date,r.applicant_id, ");
			sb.append(" r.apply_no,r.apply_state,r.notes,");
			sb.append(" t1.org_name applicant_org_name,t2.employee_name applicant_name ");
			sb.append(" from bgp_project_human_requirement r ");
			sb.append(" left join gp_task_project t on r.project_info_no = t.project_info_no and r.bsflag = '0' ");
			sb.append(" left join comm_org_information t1 on r.apply_company = t1.org_id and t1.bsflag = '0' ");
			sb.append(" left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0' ");
			sb.append(" where r.requirement_no='").append(keyId).append("' ");

			map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
			responseDTO.setValue("applyInfo", map);

			// 查询子表信息
			StringBuffer subsql = new StringBuffer(" select p.post_no,p.notes, ");
			subsql.append(" p.people_number,p.audit_number,p.spare2,p.spare3, ");
			subsql.append(" p.age,p.culture,p.work_years,p.apply_team,p.post,p.plan_start_date, ");
			subsql.append(" p.plan_end_date,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname, ");
			subsql.append(" nvl(z1,0) z1,case when nvl(p.spare2,0)-nvl(p.spare3,0)-nvl(z1, 0) <0 then 0 else nvl(p.spare2,0)-nvl(p.spare3,0)-nvl(z1, 0) end  z2, nvl(z3, 0) + nvl(z4, 0) z3 ");
			subsql.append(" from bgp_project_human_post p");
			subsql.append(" inner join bgp_project_human_requirement r ").append("on p.requirement_no= r.requirement_no");
			subsql.append(" left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
			subsql.append(" left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");
			
			subsql.append(" left join (select sum(nvl(p1.people_number,0)) z1,p1.apply_team,p1.post from bgp_project_human_post p1 ");
			subsql.append(" inner join bgp_project_human_requirement r on p1.requirement_no=r.requirement_no and r.project_info_no = '").append(projectInfoNo).append("' ");
			subsql.append(" where p1.bsflag = '0' group by p1.apply_team,p1.post) q1 on  q1.apply_team=p.apply_team and  q1.post = p.post ");
			subsql.append(" left join (select sum(nvl(p2.own_num,0)) z3,sum(nvl(p2.deploy_num,0)) z4,p2.apply_team,p2.post from bgp_project_human_profess_post p2 ");
			subsql.append(" inner join bgp_project_human_profess r on p2.profess_no=r.profess_no and r.project_info_no = '").append(projectInfoNo).append("' ");
			subsql.append(" where p2.bsflag = '0' group by p2.apply_team,p2.post) q2 on q2.apply_team=p.apply_team and q2.post = p.post ");
			
			subsql.append(" where p.bsflag='0' and p.requirement_no='").append(keyId).append("' order by p.apply_team,p.post ");

			List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
			responseDTO.setValue("detailInfo", list);

		}

		return responseDTO;
	}

	/**
	 * 物探处人员申请修改保存方法
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanRequired(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		//附件字段
		String ucmId = reqDTO.getValue("ucmId");
		String fileId = reqDTO.getValue("fileId");
		 
		Map mapInfo = null;
		BgpProjectHumanRequirement applyInfo = new BgpProjectHumanRequirement();
		PropertiesUtil.msgToPojo(reqDTO, applyInfo);
		mapInfo = PropertiesUtil.describe(applyInfo);

		// 申请表主键
		String infoKeyValue = "";
		if (mapInfo.get("requirement_no") == null) {// 新增操作
			String applyNo = EquipmentAutoNum.generateNumberByUserToken(reqDTO
					.getUserToken(), "RPSQ");
			mapInfo.put("apply_no", applyNo);
			mapInfo.put("bsflag", "0");
			mapInfo.put("proflag", "0");
			mapInfo.put("creator", user.getEmpId());
			mapInfo.put("create_date", new Date());
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			mapInfo.put("apply_date", mapInfo.get("apply_date"));
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
					mapInfo, "bgp_project_human_requirement");
			infoKeyValue = id.toString();
			  
			Map mapDetail = new HashMap(); 
			mapDetail.put("creator_id", user.getEmpId());
			mapDetail.put("create_date", new Date());
			mapDetail.put("modifi_date", new Date());
			//mapDetail.put("file_name", "人员申请文档");
			mapDetail.put("project_info_no", user.getProjectInfoNo());
			mapDetail.put("relation_id", infoKeyValue);
			mapDetail.put("bsflag", "0");
			//主键存不为空修改，为空新增
			if(fileId!=null && !"".equals(fileId)){
				mapDetail.put("file_id", fileId);
				mapDetail.put("updator_id", user.getEmpId());		
			}			 
			MyUcm ucm = new MyUcm();
			MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
			List<WSFile> fileList = mqMsg.getFiles();
			String documentId = "";
			if(fileList!= null && fileList.size()>0){
				WSFile fs = fileList.get(0);
				documentId = ucm.uploadFile(fs.getFilename(),fs.getFileData());
				 mapDetail.put("file_name", fs.getFilename());
				mapDetail.put("ucm_id", documentId);			
				if(ucmId!=null && !"".equals(ucmId)){
					ucm.deleteFile(ucmId);					
					String update =" update bgp_doc_gms_file set bsflag='1' where ucm_id='"+ucmId+"'";
					jdbcDao.getJdbcTemplate().update(update);
				} 
			}
			 
			String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_doc_gms_file").toString();
	  			
		} else {// 修改或审核操作

			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			mapInfo.put("apply_date", mapInfo.get("apply_date"));
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,
					"bgp_project_human_requirement");
			infoKeyValue = (String) mapInfo.get("requirement_no");
			
			Map mapDetail = new HashMap(); 
			mapDetail.put("creator_id", user.getEmpId());
			mapDetail.put("create_date", new Date());
			mapDetail.put("modifi_date", new Date());
		//	mapDetail.put("file_name", "人员申请文档");
			mapDetail.put("project_info_no", user.getProjectInfoNo());
			mapDetail.put("relation_id", infoKeyValue);
			mapDetail.put("bsflag", "0");
			//主键存不为空修改，为空新增
			if(fileId!=null && !"".equals(fileId)){
				mapDetail.put("file_id", fileId);
				mapDetail.put("updator_id", user.getEmpId());		
			}			 
			MyUcm ucm = new MyUcm();
			MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
			List<WSFile> fileList = mqMsg.getFiles();
			String documentId = "";
			if(fileList!= null && fileList.size()>0){
				WSFile fs = fileList.get(0);
				documentId = ucm.uploadFile(fs.getFilename(),fs.getFileData());
				 mapDetail.put("file_name", fs.getFilename());
				mapDetail.put("ucm_id", documentId);			
				if(ucmId!=null && !"".equals(ucmId)){
					ucm.deleteFile(ucmId);					
					String update =" update bgp_doc_gms_file set bsflag='1' where ucm_id='"+ucmId+"'";
					jdbcDao.getJdbcTemplate().update(update);
				} 
			}
			 
			String doc_pk_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_doc_gms_file").toString();
		}

		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));

		Map mapDetail = new HashMap();
		// 存放申请单子表信息
		for (int i = 0; i < equipmentSize; i++) {

			BgpProjectHumanPost applyDetail = new BgpProjectHumanPost();
			PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
					applyDetail);
			mapDetail = PropertiesUtil.describe(applyDetail);

			if (mapInfo.get("requirement_no") == null) {

				if ("on".equals(mapDetail.get("check"))) {
					mapDetail.put("bsflag", "0");
					mapDetail.put("requirement_no", infoKeyValue);
					mapDetail.put("creator", user.getEmpId());
					mapDetail.put("create_date", new Date());
					mapDetail.put("updator", user.getEmpId());
					mapDetail.put("modifi_date", new Date());

					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
							"bgp_project_human_post");
				}
			} else {
				if ("on".equals(mapDetail.get("check"))) {
					mapDetail.put("bsflag", "0");
				} else {
					mapDetail.put("bsflag", "1");
				}
				mapDetail.put("requirement_no", infoKeyValue);
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modifi_date", new Date());

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"bgp_project_human_post");
			}

		}

		return responseDTO;
	}
	/**
	 * 物探处人员申请流程修改保存方法
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanRequiredwfpa(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		Map mapInfo = null;
		BgpProjectHumanRequirement applyInfo = new BgpProjectHumanRequirement();
		PropertiesUtil.msgToPojo(reqDTO, applyInfo);
		mapInfo = PropertiesUtil.describe(applyInfo);

		// 申请表主键
		String infoKeyValue = "";
		if (mapInfo.get("requirement_no") == null) {// 新增操作
			String applyNo = EquipmentAutoNum.generateNumberByUserToken(reqDTO
					.getUserToken(), "RPSQ");
			mapInfo.put("apply_no", applyNo);
			mapInfo.put("bsflag", "0");
			mapInfo.put("proflag", "0");
			mapInfo.put("creator", user.getEmpId());
			mapInfo.put("create_date", new Date());
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			mapInfo.put("apply_date", mapInfo.get("apply_date"));
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
					mapInfo, "bgp_project_human_requirement");
			infoKeyValue = id.toString();
		} else {// 修改或审核操作

			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			mapInfo.put("apply_date", mapInfo.get("apply_date"));
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,
					"bgp_project_human_requirement");
			infoKeyValue = (String) mapInfo.get("requirement_no");
		}

		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));

		Map mapDetail = new HashMap();
		// 存放申请单子表信息
		for (int i = 0; i < equipmentSize; i++) {

			BgpProjectHumanPost applyDetail = new BgpProjectHumanPost();
			PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
					applyDetail);
			mapDetail = PropertiesUtil.describe(applyDetail);

			if (mapInfo.get("requirement_no") == null) {
				System.out.println(mapDetail.get("check") + "4444444444");

				if ("on".equals(mapDetail.get("check"))) {
					mapDetail.put("bsflag", "0");
					mapDetail.put("requirement_no", infoKeyValue);
					mapDetail.put("creator", user.getEmpId());
					mapDetail.put("create_date", new Date());
					mapDetail.put("updator", user.getEmpId());
					mapDetail.put("modifi_date", new Date());

					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
							"bgp_project_human_post");
				}
			} else {
				if ("on".equals(mapDetail.get("check"))) {
					mapDetail.put("bsflag", "0");
				} else {
					mapDetail.put("bsflag", "1");
				}
				mapDetail.put("requirement_no", infoKeyValue);
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modifi_date", new Date());

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"bgp_project_human_post");
			}

		}

		return responseDTO;
	}
	/**
	 * 人员培训计划页面包括新增及修改
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "unchecked", "rawtypes" })
	public ISrvMsg getHumanPlanInfo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String keyId = reqDTO.getValue("id");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		//工作流中控制页面按钮使用
		String buttonView = "true";
		if(reqDTO.getValue("buttonView") !=null && reqDTO.getValue("buttonView") !="null" && !"".equals(reqDTO.getValue("buttonView"))){
			buttonView = reqDTO.getValue("buttonView");
		}
		responseDTO.setValue("buttonView", buttonView);
		// 申请表主键

		if (keyId == null || "".equals(keyId)) {
			Map map = new HashMap();
			map.put("applicantName", user.getUserName());
			map.put("creator", user.getEmpId());

			String createDate = new SimpleDateFormat("yyyy-MM-dd HH:ss")
					.format(new Date());
			map.put("createDate", createDate);
			map.put("projectInfoNo", projectInfoNo);
			String sql="select t.project_name from gp_task_project t  where t.bsflag='0' and t.project_info_no = '"+projectInfoNo+"'";
			Map pro = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
			map.put("projectName", pro.get("projectName"));
			
			String orgSql="select d.org_id,i.org_name from gp_task_project t left join gp_task_project_dynamic d on t.project_info_no = d.project_info_no and d.bsflag = '0' left join comm_org_information i on d.org_id = i.org_id and i.bsflag = '0' where t.bsflag = '0' and t.project_info_no = '"+projectInfoNo+"' order by i.org_name";
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(orgSql);
			if(list!=null && list.size()>0){
				Map org = (Map)list.get(0);
				String org_ids =org.get("orgId").toString();
				String org_sub="";  //处理过的多个orgid
				String[] org_idsSub = org_ids.split(",");
				for (int i = 0; i < org_idsSub.length; i++) {	
					org_sub=org_sub + "," + "'" +org_idsSub[i]+ "'";
 
				} 
				
				String orgNameSql=" select wm_concat(org_abbreviation) as org_name,wm_concat(org_id) as org_id from comm_org_information where org_id in("+org_sub.substring(1)+") and bsflag = '0' ";
				List listA = BeanFactory.getQueryJdbcDAO().queryRecords(orgNameSql);
				if(listA!=null && listA.size()>0){
					Map orgA = (Map)listA.get(0);
					map.put("applicantOrgName",orgA.get("orgName"));
					map.put("spare1",orgA.get("orgId"));
				}

			}
						
			responseDTO.setValue("applyInfo", map);
			
			Map mapSum = new HashMap();
			responseDTO.setValue("sumAll", mapSum);
			
			
		} else {
			// 查询主表信息
			Map map = new HashMap();
			StringBuffer sb = new StringBuffer(
					" select pn.train_object,pn.train_address,pn.train_purpose,pn.train_cycle,pn.train_plan_no, pn.plan_number,pn.project_info_no,nvl(pn.train_amount,'0') train_amount,nvl(pn.proc_status, '0') proc_status, p.project_name,  i.org_id,       pn.org_name  applicant_org_name,       decode(pn.proc_status,     '0',    '待审核',     '1',     '审核不通过',   '2',    '审核通过',  '未提交') proc_status_name,pn.creator,       To_char(pn.create_date, 'yyyy-MM-dd hh24:mi') create_date,pn.spare1 ,  t2.employee_name applicant_name  from BGP_COMM_HUMAN_TRAINING_PLAN  pn                left join gp_task_project p    on pn.project_info_no = p.project_info_no   and p.bsflag = '0'    left join comm_org_information i    on pn.spare1 = i.org_id   and i.bsflag = '0'       left join comm_human_employee t2    on pn.creator = t2.employee_id   and t2.bsflag = '0'  where pn.bsflag='0'  ");
			sb.append("  and pn.train_plan_no='").append(keyId).append("' ");

			map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
			responseDTO.setValue("applyInfo", map);
			
			// 查询主表信息
			Map mapSum = new HashMap();
			StringBuffer sbSum = new StringBuffer(
			" select      sum(nvl(dl.train_class,'0'))  train_class,      sum(nvl(dl.train_cost,'0'))  train_cost,         sum(nvl(dl.train_transportation,'0'))   train_transportation,      sum(nvl(dl.train_materials,'0'))   train_materials,      sum(nvl(dl.train_places,'0'))   train_places,     sum(nvl(dl.train_accommodation,'0'))   train_accommodation,     sum(nvl(dl.train_other,'0'))    train_other,     sum(nvl(dl.train_total,'0'))   train_total  from BGP_COMM_HUMAN_TRAINING_DETAIL dl inner join BGP_COMM_HUMAN_TRAINING_PLAN pn    on dl.train_plan_no = pn.train_plan_no   and pn.bsflag = '0' where dl.bsflag = '0'  ");
			sbSum.append("  and pn.train_plan_no = '").append(keyId).append("' ");
			mapSum = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sbSum.toString());
			responseDTO.setValue("sumAll", mapSum);
			

			// 查询子表信息
			StringBuffer subsql = new StringBuffer(
					" select dl.train_detail_no,  dl.bsflag,dl.train_content,dl.classification,dl.train_number,dl.train_class ,dl.train_cost ,dl.train_transportation,dl.train_materials,dl.train_places,dl.train_accommodation,dl.train_other,dl.train_total  from BGP_COMM_HUMAN_TRAINING_DETAIL dl  inner join BGP_COMM_HUMAN_TRAINING_PLAN pn on dl.train_plan_no=pn.train_plan_no  and pn.bsflag='0'  where dl.bsflag='0'");

			subsql.append("  and pn.train_plan_no='").append(
					keyId).append("' order by dl.train_total desc ");

			List list = BeanFactory.getQueryJdbcDAO().queryRecords(
					subsql.toString());
			responseDTO.setValue("detailInfo", list);

		}

		return responseDTO;
	}

	public ISrvMsg saveHumanPlan(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		Map mapInfo = null;
		BgpHumanTrainingPlan applyInfo = new BgpHumanTrainingPlan();
		PropertiesUtil.msgToPojo(reqDTO, applyInfo);
		mapInfo = PropertiesUtil.describe(applyInfo);

		// 申请表主键
		String infoKeyValue = "";
		if (mapInfo.get("train_plan_no") == null) {// 新增操作
			String planNumber = EquipmentAutoNum.generateNumberByUserToken(	reqDTO.getUserToken(), "RYPX");
			mapInfo.put("org_name", mapInfo.get("applicant_org_name"));
			mapInfo.put("plan_number", planNumber);
			mapInfo.put("spare3", user.getOrgSubjectionId());
			mapInfo.put("bsflag", "0");
			mapInfo.put("proc_status", "0");
			mapInfo.put("creator", user.getEmpId());
			mapInfo.put("create_date", new Date());
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
					mapInfo, "BGP_COMM_HUMAN_TRAINING_PLAN");
			infoKeyValue = id.toString();
		} else {// 修改或审核操作
			mapInfo.put("org_name", mapInfo.get("applicant_org_name"));
			mapInfo.put("spare3", user.getOrgSubjectionId());
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,
					"BGP_COMM_HUMAN_TRAINING_PLAN");
			infoKeyValue = (String) mapInfo.get("train_plan_no");
		}

		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));

		Map mapDetail = new HashMap();
		// 存放申请单子表信息
		for (int i = 0; i < equipmentSize; i++) {

			BgpHumanPlanDetail applyDetail = new BgpHumanPlanDetail();
			PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
					applyDetail);
			mapDetail = PropertiesUtil.describe(applyDetail);
			System.out.println(mapDetail);
			if (mapInfo.get("train_plan_no") == null) {
				
				mapDetail.put("spare3", user.getOrgSubjectionId());
				mapDetail.put("train_plan_no", infoKeyValue);
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modify_date", new Date());
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"BGP_COMM_HUMAN_TRAINING_DETAIL");

			} else {

				mapDetail.put("spare3", user.getOrgSubjectionId());
				mapDetail.put("train_plan_no", infoKeyValue);
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modify_date", new Date());

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"BGP_COMM_HUMAN_TRAINING_DETAIL");
			}

		}

		return responseDTO;
	}
	
	public ISrvMsg saveHumanPlanDetail(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		Map mapInfo = null;
		BgpHumanTrainingPlan applyInfo = new BgpHumanTrainingPlan();
		PropertiesUtil.msgToPojo(reqDTO, applyInfo);
		mapInfo = PropertiesUtil.describe(applyInfo);

		// 申请表主键
		String infoKeyValue = "";
		if (mapInfo.get("train_plan_no") == null) {// 新增操作
		 
		} else {// 修改或审核操作
 
		}

		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize")); 
		Map mapDetail = new HashMap();
		// 存放申请单子表信息
		for (int i = 0; i < equipmentSize; i++) {

			BgpHumanPlanDetail applyDetail = new BgpHumanPlanDetail();
			PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
					applyDetail);
			mapDetail = PropertiesUtil.describe(applyDetail);
	 
			if (mapInfo.get("train_plan_no") == null) { 
				mapDetail.put("org_name", mapInfo.get("applicant_org_name"));
				mapDetail.put("spare3", user.getOrgSubjectionId());
				mapDetail.put("train_plan_no", "");
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modify_date", new Date());
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"BGP_COMM_HUMAN_TRAINING_DETAIL");

			} else { 
				mapDetail.put("train_plan_no", "");
				mapDetail.put("org_name", mapInfo.get("applicant_org_name"));
				mapDetail.put("spare3", user.getOrgSubjectionId());
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modify_date", new Date());

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"BGP_COMM_HUMAN_TRAINING_DETAIL");
			}

		}

		return responseDTO;
	}
	
	 
	/**
	 * 人员培训记录页面包括新增及修改
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "unchecked", "rawtypes" })
	public ISrvMsg getHumanRecordInfo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String keyId = reqDTO.getValue("id");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String projectName = reqDTO.getValue("projectName");
		// 申请表主键

		if (keyId != null) {
			Map map = new HashMap();
		//	map.put("applicantName", user.getUserName());
		//	map.put("creator", user.getEmpId());
		//	map.put("applicantOrgName", user.getOrgName());
		//	map.put("spare1", user.getOrgId());
		//	String createDate = new SimpleDateFormat("yyyy-MM-dd HH:ss")
				//	.format(new Date());
		//	map.put("createDate", createDate);
			map.put("projectInfoNo", projectInfoNo);
			map.put("projectName", projectName);
			responseDTO.setValue("applyInfo", map);
			// 查询主表信息
			Map mapSum = new HashMap();
			StringBuffer sbSum = new StringBuffer(
			" select dl.train_detail_no,dl.train_start_date,dl.train_end_date, decode(dl.classification,   '1',   '质量',  '2',  'HSE', '3', '其他',dl.classification) classification,  dl.train_content,dl.train_number,dl.train_class ,nvl(dl.train_cost ,'0') train_cost,nvl(dl.train_transportation,'0')train_transportation,nvl(dl.train_materials,'0') train_materials,nvl(dl.train_places,'0') train_places,nvl(dl.train_accommodation,'0') train_accommodation,nvl(dl.train_other,'0') train_other,nvl(dl.train_total,'0') train_total  from BGP_COMM_HUMAN_TRAINING_DETAIL dl    where dl.bsflag='0' ");
			sbSum.append("  and dl.train_detail_no='").append(keyId).append("' ");
			mapSum = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sbSum.toString());
			responseDTO.setValue("detailInfo", mapSum);
			
			StringBuffer subsql = new StringBuffer(
			" select d.train_detail_no,d.employee_id,d.employee_id_code,d.train_record_no,d.employee_type,    d.train_result,d.notes,     d.train_date,  decode(ls.employee_name,'',es.employee_name,ls.employee_name) labor_name  from BGP_COMM_HUMAN_TRAINING_RECORD d  left  join  BGP_COMM_HUMAN_TRAINING_DETAIL l  on d.train_detail_no=l.train_detail_no  left join bgp_comm_human_labor ls on d.employee_id = ls.labor_id left join comm_human_employee es on d.employee_id = es.employee_id where d.bsflag = '0'   ");

			subsql.append("and d.train_detail_no = '").append(
			keyId).append("'  order by d.create_date desc  ");

			List list = BeanFactory.getQueryJdbcDAO().queryRecords(
			subsql.toString());
			responseDTO.setValue("trainInfo", list);
		}  

		return responseDTO;
	}
	/**
	 * 培训人员批量导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public ISrvMsg importExcelTemplateHuman(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String trainDetailNo = reqDTO.getValue("trainDetailNo"); // 主表表信息 
		if (trainDetailNo != null) {
			// 查询主表信息
		Map mapSum = new HashMap();
		StringBuffer sbSum = new StringBuffer(
		" select dl.train_detail_no,   dl.train_content,dl.train_number,dl.train_class ,nvl(dl.train_cost ,'0') train_cost,nvl(dl.train_transportation,'0')train_transportation,nvl(dl.train_materials,'0') train_materials,nvl(dl.train_places,'0') train_places,nvl(dl.train_accommodation,'0') train_accommodation,nvl(dl.train_other,'0') train_other,nvl(dl.train_total,'0') train_total,dl.train_start_date,dl.train_end_date  from BGP_COMM_HUMAN_TRAINING_DETAIL dl  left join BGP_COMM_HUMAN_TRAINING_PLAN pn on dl.train_plan_no=pn.train_plan_no  and pn.bsflag='0'  where dl.bsflag='0' ");
		sbSum.append("  and dl.train_detail_no='").append(trainDetailNo).append("' ");
		mapSum = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sbSum.toString());
		responseDTO.setValue("detailInfo", mapSum);
		
		StringBuffer subsql = new StringBuffer(
	  "  select d.train_detail_no,d.employee_id,d.employee_id_code,d.train_record_no,d.employee_type,    d.train_result,d.notes,     d.train_date,  decode(ls.employee_name,'',es.employee_name,ls.employee_name) labor_name  from BGP_COMM_HUMAN_TRAINING_RECORD d  left  join  BGP_COMM_HUMAN_TRAINING_DETAIL l  on d.train_detail_no=l.train_detail_no  left join bgp_comm_human_labor ls on d.employee_id = ls.labor_id left join comm_human_employee es on d.employee_id = es.employee_id where d.bsflag = '0'  ");
	//	" select d.train_detail_no,d.employee_id,d.employee_id_code,d.train_record_no,d.employee_type,    d.train_result,d.notes,     d.train_date,    ls.labor_name,     es.train_name  from BGP_COMM_HUMAN_TRAINING_RECORD d  left  join  BGP_COMM_HUMAN_TRAINING_DETAIL l  on d.train_detail_no=l.train_detail_no  left join (select lt.list_id,  l.labor_id,    l.employee_name as labor_name,   l.employee_id_code_no from bgp_comm_human_labor l  left join bgp_comm_human_labor_list lt  on l.labor_id = lt.labor_id                and lt.bsflag = '0'  where l.bsflag = '0'         and lt.list_id is null) ls   on d.employee_id_code = ls.employee_id_code_no  left join (select e.employee_id,                    e.employee_name as train_name,  e.employee_id_code_no  from comm_human_employee e   where e.bsflag = '0') es   on d.employee_id = es.employee_id where d.bsflag = '0'   "
		subsql.append("and d.train_detail_no = '").append(
				trainDetailNo).append("'  order by d.create_date desc  ");

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(
		subsql.toString());
		responseDTO.setValue("trainInfo", list);
	  }  

		
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
					book = new XSSFWorkbook(new ByteArrayInputStream(fs.getFileData()));
					sheet = book.getSheetAt(0);
				}
				if (sheet != null) {
					for (int m = 3; m <= sheet.getLastRowNum(); m++) {
						row = sheet.getRow(m);
						String humanName = "";
						String trainDate="";
						String workType = "";
						String workId = "";
						String codeId = "";
						String kaohe = "";
 						String notes = "";

						Map<String, String> tempMap = new HashMap<String, String>(); // 把excel数据保存到map								
						for (int j = 0; j < row.getPhysicalNumberOfCells(); j++) {
							Cell ss = row.getCell(j);
							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
								case 0:
									ss.setCellType(1);
									humanName = ss.getStringCellValue().trim(); // 对应赋值
									tempMap.put("humanName", humanName);
									break;
//								case 1:
//									ss.setCellType(1);
//								trainDate = ss.getStringCellValue().trim(); // 对应赋值
//								
//								 if (trainDate.indexOf("/") > 0) {      
//									 trainDate = trainDate.replace("/", "-");      
//									 }      
//								
//						    	tempMap.put("trainDate", trainDate);
							//	 Date date = ss.getDateCellValue();
							 
							 		//trainDate = datetemp.format(ss.getDateCellValue()); // 日期处理
  
								//	tempMap.put("trainDate",trainDate);	
									
								//	break;
								case 1:
									ss.setCellType(1);
									workType = ss.getStringCellValue().trim();
									if (workType.equals("")) {

									} else {
										if (workType.equals("合同化员工")) {
											tempMap.put("workType", "1");
										} else if (workType.equals("再就业人员")) {
											tempMap.put("workType", "0");
										}else if (workType.equals("市场化用工")) {
											tempMap.put("workType", "2");
										}else if (workType.equals("劳务用工")) {
											tempMap.put("workType", "3");
										}else if (workType.equals("临时工固定期限合同")) {
											tempMap.put("workType", "4");
										}else if (workType.equals("完成一定工作任务")) {
											tempMap.put("workType", "5");
										}else if (workType.equals("非全日制用工")) {
											tempMap.put("workType", "6");
										}
										
									}
									break;
								case 2:
									ss.setCellType(1);
									workId = ss.getStringCellValue().trim();
									//tempMap.put("workId", workId);
									break;
 
								case 3:
									ss.setCellType(1);
									codeId = ss.getStringCellValue().trim();
									tempMap.put("codeId", codeId);
									break;
								case 4:
									ss.setCellType(1);
									kaohe = ss.getStringCellValue().trim();
									if (kaohe.equals("")) {

									} else {
										if (kaohe.equals("不合格")) {
											tempMap.put("kaohe", "1");
										} else if (kaohe.equals("合格")) {
											tempMap.put("kaohe", "0");
										}
									}
									break;
								case 5:
									ss.setCellType(1);
									notes = ss.getStringCellValue().trim();
									tempMap.put("notes", notes);
									break;
								default:
									break;
								}
							}
						}
						// 判断必填项处理
						if (humanName.equals("") 
								|| workType.equals("")  || kaohe.equals("")) {
							message.append("第").append(m + 1).append("行红色标注项不能为空!");
							responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
						}				
//						 if(trainDate !=null || trainDate !=""){
//							 if(trainDate.length()!=10){
//								  message.append("第").append(m + 1).append("行日期格式必须为（yyyy-MM-dd或yyyy/MM/dd）!");
//									responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
//								 								 
//							 }						 
//							 int valueLength = 0;
//							 StringBuffer sb = new StringBuffer();
//							  for (int i = 0; i < trainDate.length(); i++) {
//						         
//						            String temp = trainDate.substring(i, i + 1);
//						            /* 判断是否为-下划线 */
//						            if (temp.matches("-")) {
//						                /* 是的话加1 */
//						                valueLength += 1;
//						            } 
//						        }
//						  if(valueLength !=2){
//							  
//							  message.append("第").append(m + 1).append("行日期格式不正确!");
//								responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
//							  
//						  }
							   
						 						 
						// }
						// System.out.println("33333333333333"+trainDate);
						 
						if(workType.equals("合同化员工")){									
							String sql="select e.employee_id,e.employee_name, e.employee_gender,decode(e.employee_gender, '1', '男', '0', '女')employee_gender_name,e.employee_id_code_no  from comm_human_employee e  inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id  where e.bsflag='0' and hr.employee_cd='"+workId+"'";
							Map testM =queryJdbcDao.queryRecordBySQL(sql);
							if(testM ==null || testM.size()<0){  
								message.append("第").append(m+1).append("行此用户不存在，请正确填入员工编号!");
								responseDTO.setValue("message", message.toString()); 
							}else{
							 
								workId = (String)testM.get("employeeId");
								tempMap.put("workId", workId);
							}
						}else if(workType.equals("再就业人员")) {
							String sqls=" select l.labor_id  from bgp_comm_human_labor l  left join bgp_comm_human_labor_list lt on l.labor_id = lt.labor_id and lt.bsflag='0' where l.bsflag='0' and lt.list_id is null and l.employee_id_code_no='"+codeId+"'";
							Map testMs = queryJdbcDao.queryRecordBySQL(sqls);
							if(testMs ==null || testMs.size()<0){ 
							message.append("第").append(m+1).append("行此用户不存在，请正确填身份证号!");
							responseDTO.setValue("message", message.toString()); 
							}else{ 
								workId = (String)testMs.get("laborId");	 
								tempMap.put("workId", workId);
							}
						}else if(workType.equals("市场化用工")){									
							String sql="select e.employee_id,e.employee_name, e.employee_gender,decode(e.employee_gender, '1', '男', '0', '女')employee_gender_name,e.employee_id_code_no  from comm_human_employee e  inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id  where e.bsflag='0' and hr.employee_cd='"+workId+"'";
							Map testM =queryJdbcDao.queryRecordBySQL(sql);
							if(testM ==null || testM.size()<0){  
								message.append("第").append(m+1).append("行此用户不存在，请正确填入员工编号!");
								responseDTO.setValue("message", message.toString()); 
							}else{ 
								workId = (String)testM.get("employeeId");	 
								tempMap.put("workId", workId);
							}
						}else if(workType.equals("劳务用工")) {
							String sqls=" select l.labor_id  from bgp_comm_human_labor l  left join bgp_comm_human_labor_list lt on l.labor_id = lt.labor_id and lt.bsflag='0' where l.bsflag='0' and lt.list_id is null and l.employee_id_code_no='"+codeId+"'";
							Map testMs = queryJdbcDao.queryRecordBySQL(sqls);
							if(testMs ==null || testMs.size()<0){ 
							message.append("第").append(m+1).append("行此用户不存在，请正确填身份证号!");
							responseDTO.setValue("message", message.toString()); 
							}else{
								workId = (String)testMs.get("laborId");  
								tempMap.put("workId", workId);
							}
						}else if(workType.equals("临时工固定期限合同")) {
							String sqls=" select l.labor_id  from bgp_comm_human_labor l  left join bgp_comm_human_labor_list lt on l.labor_id = lt.labor_id and lt.bsflag='0' where l.bsflag='0' and lt.list_id is null and l.employee_id_code_no='"+codeId+"'";
							Map testMs = queryJdbcDao.queryRecordBySQL(sqls);
							if(testMs ==null || testMs.size()<0){ 
							message.append("第").append(m+1).append("行此用户不存在，请正确填身份证号!");
							responseDTO.setValue("message", message.toString()); 
							}else{
								workId = (String)testMs.get("laborId");	 
								tempMap.put("workId", workId);
							}
						}else if(workType.equals("完成一定工作任务")) {
							String sqls=" select l.labor_id  from bgp_comm_human_labor l  left join bgp_comm_human_labor_list lt on l.labor_id = lt.labor_id and lt.bsflag='0' where l.bsflag='0' and lt.list_id is null and l.employee_id_code_no='"+codeId+"'";
							Map testMs = queryJdbcDao.queryRecordBySQL(sqls);
							if(testMs ==null || testMs.size()<0){ 
							message.append("第").append(m+1).append("行此用户不存在，请正确填身份证号!");
							responseDTO.setValue("message", message.toString()); 
							}else{
								workId = (String)testMs.get("laborId");	 
								tempMap.put("workId", workId);
							}
						}else if(workType.equals("非全日制用工")) {
							String sqls=" select l.labor_id  from bgp_comm_human_labor l  left join bgp_comm_human_labor_list lt on l.labor_id = lt.labor_id and lt.bsflag='0' where l.bsflag='0' and lt.list_id is null and l.employee_id_code_no='"+codeId+"'";
							Map testMs = queryJdbcDao.queryRecordBySQL(sqls);
							if(testMs ==null || testMs.size()<0){ 
							message.append("第").append(m+1).append("行此用户不存在，请正确填身份证号!");
							responseDTO.setValue("message", message.toString()); 
							}else{
								workId = (String)testMs.get("laborId");	 
								tempMap.put("workId", workId);
							}
						}
						 
						
						if (message.toString().equals("")) {

							datelist.add(tempMap);
						} // 必填项不为空 则把数据放入 集合中
					}
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
			}
			if (!message.toString().equals("")) {
				System.out.println(message.toString());
				responseDTO.setValue("message", message.toString()); // 必填项为空则在页面弹出提示
			} else {
			
				if (datelist != null && datelist.size() > 0) {
					responseDTO.setValue("datelist", datelist);
				}
			}
		}
		
		
		responseDTO.setValue("trainDetailNo", trainDetailNo);
 
		return responseDTO;

	}

	/**
	 * 进入人员调配和调剂调配的查看和修改页面
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg humanPrepareView(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String keyId = reqDTO.getValue("id");// 申请表主键
		String func = reqDTO.getValue("func");// 调配状态 2 已调配，0待调配
		String addF=reqDTO.getValue("addF");
		String project_type=reqDTO.getValue("project_type");
		String projectInfoNo=reqDTO.getValue("projectInfoNo");
 
		
		Map map = new HashMap();
		// 存放申请主表信息
		String queryPriSql = "select r.requirement_no,"
				+ "       r.spare1,"
				+ "       r.project_info_no,s.org_subjection_id,"
				+ "       r.apply_company,s.org_subjection_id apply_company_sub, "
				+ "       to_char(r.apply_date, 'yyyy-MM-dd hh24:mi' ) apply_date,"
				+ "       r.applicant_id,"
				+ "       r.apply_no,"
				+ "       r.apply_state,"
				+ "       r.notes,"
				+ "       r.proc_inst_id,"
				+ "       t.project_name,"
				+ "       t1.org_name applicant_org_name,"
				+ "       t1.org_abbreviation applicant_org_sub_name,"
				+ "       t2.employee_name applicant_name"
				+ "  from bgp_project_human_requirement r "
				+ "  left join gp_task_project t on r.project_info_no = t.project_info_no"
				+ "                             and r.bsflag = '0'"
				+ "  left join comm_org_subjection s on r.apply_company = s.org_id and s.bsflag = '0' "
				+ "  left join comm_org_information t1 on r.apply_company = t1.org_id"
				+ "                                   and t1.bsflag = '0'"
				+ "  left join comm_human_employee t2 on r.applicant_id = t2.employee_id"
				+ "                                  and t2.bsflag = '0'"
				+ " where r.requirement_no='" + keyId + "'";

		map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(queryPriSql);

		responseDTO.setValue("applyInfo", map);
		
		String update = reqDTO.getValue("update");
		// 判断是新增还是查看修改,新增查询需求子表/查看修改查询调配子表。为空时为新增，为true时为为false时为

		Map prepareMap = new HashMap();
		// 存放调配主表内容
		if (update == null || "".equals(update)) {
			
			if(func.equals("0")){  //待调配状态
				if(addF ==null || "".equals(addF)){ //调配单号为空新增
					prepareMap.put("applicantName", user.getUserName());
					prepareMap.put("applicantId", user.getEmpId());
					String applyDate = new SimpleDateFormat("yyyy-MM-dd HH:ss")
							.format(new Date());
					prepareMap.put("deployDate", applyDate);
					responseDTO.setValue("prepareMap", prepareMap);
				}else{ //调配单号不为空覆盖原来信息
					String prepareMapStr = "select t.prepare_no,"
						+ "       t.prepare_id,"
						+ "       t.applicant_id,"
						+ "       to_char(t.deploy_date,'yyyy-MM-dd hh24:mi') deploy_date,t.notes,"
						+ "       t.prepare_status,t.function_type,t.prepare_org_id,t.proc_inst_id,"
						+ "       t2.employee_name applicant_name,t.spare2,t.spare3"
						+ "  from bgp_human_prepare t"
						+ "  left join comm_human_employee t2 on t.applicant_id = t2.employee_id"
						+ "  and t2.bsflag = '0' and t.bsflag='0' where t.prepare_no='"
						+ addF + "'";
			    	prepareMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
						prepareMapStr);
					responseDTO.setValue("prepareMap", prepareMap); 
				}
				
			}
			
			if(func.equals("2")){ 
				prepareMap.put("applicantName", user.getUserName());
				prepareMap.put("applicantId", user.getEmpId());
				String applyDate = new SimpleDateFormat("yyyy-MM-dd HH:ss")
						.format(new Date());
				prepareMap.put("deployDate", applyDate);
				responseDTO.setValue("prepareMap", prepareMap); 
			} 
			
			
		} else {
			// 查询调配主表信息
			String prepareNo = reqDTO.getValue("prepareNo");
			String prepareMapStr = "select t.prepare_no,"
					+ "       t.prepare_id,"
					+ "       t.applicant_id,"
					+ "       to_char(t.deploy_date,'yyyy-MM-dd hh24:mi') deploy_date,t.notes,"
					+ "       t.prepare_status,t.function_type,t.prepare_org_id,t.proc_inst_id,"
					+ "       t2.employee_name applicant_name,t.spare2,t.spare3"
					+ "  from bgp_human_prepare t"
					+ "  left join comm_human_employee t2 on t.applicant_id = t2.employee_id"
					+ "  and t2.bsflag = '0' and t.bsflag='0' where t.prepare_no='"
					+ prepareNo + "'";
			prepareMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
					prepareMapStr);
			responseDTO.setValue("update", update);

		}
		// 传调配信息
		responseDTO.setValue("prepareMap", prepareMap);
		StringBuffer sb = new StringBuffer();
		if (null != update && !"".equals(update)) {
			// 修改查询子表信息
			String prepareNo = reqDTO.getValue("prepareNo");
			sb
					.append("select p.prepare_post_detail_no,p.post,p.people_number,p.audit_number,al.pre_num,p.prepare_number,p.notes,r.prepare_org_id,s.org_subjection_id prepare_subjection_id, ");
			sb
					.append("p.age,p.culture,p.apply_team,p.plan_start_date,p.plan_end_date,p.work_years,p.work_trade_years,p.spare1,d1.coding_name postname, d2.coding_name apply_teamname ");
			sb
					.append("from bgp_human_prepare_post_detail p inner join bgp_human_prepare r on p.prepare_no=r.prepare_no and r.bsflag='0' ");
			sb
					.append("left join comm_org_subjection s on r.prepare_org_id = s.org_id and s.bsflag = '0' ");
			sb
					.append("left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
			sb
					.append("left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");
			sb
					.append("left join comm_coding_sort_detail d3 on p.culture = d3.coding_code_id ");
			sb
					.append("left join (select count(distinct(t.employee_id)) pre_num, t.work_post post ");
			sb.append("from bgp_human_prepare_human_detail t ");
			sb
					.append("inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' ");
			sb
					.append("where p.requirement_no")
					.append("='")
					.append(keyId)
					.append(
							"' and p.prepare_status = '2' and t.bsflag = '0' group by ");
			sb.append(" t.work_post) al on al.post= p.post ");
			sb.append(" where p.bsflag='0' and r.prepare_no='").append(
					prepareNo).append("' order by p.apply_team,p.post ");

		} else {

			sb.append("select p.post,nvl(al.pre_num,0)pre_num , p.notes, ");
			sb.append("  p.people_number,p.audit_number, ");
			sb
					.append("p.age,p.culture,(p.plan_end_date-p.plan_start_date + 1 ) spare1,p.apply_team,p.plan_start_date,p.plan_end_date,p.work_years,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname ");
			sb.append("from bgp_project_human_post p ");
			sb.append("inner join bgp_project_human_requirement r on p.requirement_no = r.requirement_no");
			sb
					.append(" left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
			sb
					.append(" left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");
			sb
					.append(" left join comm_coding_sort_detail d3 on p.culture = d3.coding_code_id ");
			sb
					.append(" left join (select count(distinct(t.employee_id)) pre_num , t.work_post post ");
			sb.append(" from bgp_human_prepare_human_detail t ");
			sb
					.append(" inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' ");
			sb.append("  where p.requirement_no").append(" ='").append(keyId)
					.append(
							"' and t.bsflag = '0' group by  ");

			sb.append("  t.work_post ) al on al.post= p.post ");

			sb.append(" where p.bsflag='0' and p.requirement_no").append("='").append(keyId).append(
					"' order by p.apply_team,p.post ");

		}	
		// 新增时查询需求子表,修改时查询调配子表(内容为岗位信息)
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);

		// 如果为修改和查看则查询调配人员信息
		if (null != update && !"".equals(update)) {
			String prepareNo = reqDTO.getValue("prepareNo");
			String huamnStr = "select '0' qufen,  t.human_detail_no,"
					+ "       t.team,"
					+ "       t.work_post,"
					+ "       t.employee_id,"
					+ "       e.employee_name,"
					+ "       t.plan_start_date,"
					+ "       t.plan_end_date,"
					+ "       (t.plan_end_date- t.plan_start_date + 1) plan_days,"
					+ "       (t.actual_end_date- t.actual_start_date + 1) actual_days,"
					+ "       t.actual_start_date,d1.coding_name work_post_name, d2.coding_name team_name,"
					+ "       t.actual_end_date,t.spare1,t.notes "
					+ "  from bgp_human_prepare_human_detail t"
					+ "  inner join bgp_human_prepare r on t.prepare_no = r.prepare_no and r.bsflag='0' "
					+ "  left join comm_coding_sort_detail d1 on t.work_post = d1.coding_code_id"
					+ "  left join comm_coding_sort_detail d2 on t.team = d2.coding_code_id"
					+ "  left join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag='0'"
					+ "  where t.prepare_no='" + prepareNo + "' and t.bsflag='0'  " +
					"  union all  select distinct   '1' qufen,   t.labor_deploy_id as human_detail_no , d2.apply_team as team, d2.post as work_post ,  t.labor_id as employee_id,   l.employee_name,   t.start_date as plan_start_date ,  t.spare4 as  plan_end_date,  (t.spare4 - t.start_date + 1) plan_days,    (t.end_date -  t.actual_start_date + 1) actual_days,    t.actual_start_date,  d4.coding_name work_post_name,    d3.coding_name team_name,  t.end_date as actual_end_date,   t.spare1,  t.notes        from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2     on t.labor_deploy_id = d2.labor_deploy_id    and d2.bsflag = '0'   left join bgp_comm_human_labor l     on t.labor_id = l.labor_id    left join comm_coding_sort_detail d3     on d2.apply_team = d3.coding_code_id   left join comm_coding_sort_detail d4     on d2.post = d4.coding_code_id    where t.bsflag = '0'  and   t.spare1= '"+prepareNo+"' ";
			List humanInfoList = BeanFactory.getQueryJdbcDAO().queryRecords(
					huamnStr);
			responseDTO.setValue("humanInfoList", humanInfoList);
		}



		responseDTO.setValue("project_type", project_type);
		responseDTO.setValue("projectInfoNo", projectInfoNo);
		return responseDTO;
	}
	
	/**
	 * 进入人员调配和调剂调配的查看和修改页面
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg humanPrepareViewwfpg(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String keyId = reqDTO.getValue("id");// 申请表主键
		String func = reqDTO.getValue("func");// 申请表判断参数
		String auditStatus = "0";// 自有调配还是其他调配 0自有1非自有
		String stateNone = reqDTO.getValue("stateNone");
		if (reqDTO.getValue("auditStatus") != null) {
			auditStatus = reqDTO.getValue("auditStatus");
		}
		responseDTO.setValue("auditStatus", auditStatus);
		int arrayLoc = 0;
		if ("2".equals(func)) {
			arrayLoc = 1;
		} else if ("3".equals(func)) {
			arrayLoc = 2;
		}// 1普通调配2调剂3专业化

		Map map = new HashMap();
		// 存放申请主表信息
		String queryPriSql = "select r."
				+ infoKeyName[arrayLoc]
				+ " requirement_no,r.spare1,"
				+ "       r.project_info_no,s.org_subjection_id,"
				+ "       r.apply_company,s.org_subjection_id apply_company_sub, "
				+ "       to_char(r.apply_date, 'yyyy-MM-dd hh24:mi' ) apply_date,"
				+ "       r.applicant_id,"
				+ "       r.apply_no,"
				+ "       r.apply_state,"
				+ "       r.notes,"
				+ "       r.proc_inst_id,"
				+ "       t.project_name,"
				+ "       t1.org_name applicant_org_name,"
				+ "       t1.org_abbreviation applicant_org_sub_name,"
				+ "       t2.employee_name applicant_name"
				+ "  from "
				+ infoTableName[arrayLoc]
				+ " r"
				+ "  left join gp_task_project t on r.project_info_no = t.project_info_no"
				+ "                             and r.bsflag = '0'"
				+ "  left join comm_org_subjection s on r.apply_company = s.org_id and s.bsflag = '0' "
				+ "  left join comm_org_information t1 on r.apply_company = t1.org_id"
				+ "                                   and t1.bsflag = '0'"
				+ "  left join comm_human_employee t2 on r.applicant_id = t2.employee_id"
				+ "                                  and t2.bsflag = '0'"
				+ " where r." + infoKeyName[arrayLoc] + "='" + keyId + "'";

		map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(queryPriSql);

		String update = reqDTO.getValue("update");
		// 判断是新增还是查看修改,新增查询需求子表/查看修改查询调配子表。为空时为新增，为true时为为false时为
		System.out.println(update + "--------------");
		Map prepareMap = new HashMap();
		// 存放调配主表内容
		if (update == null || "".equals(update)) {
			prepareMap.put("applicantName", user.getUserName());
			prepareMap.put("applicantId", user.getEmpId());
			String applyDate = new SimpleDateFormat("yyyy-MM-dd HH:ss")
					.format(new Date());
			prepareMap.put("deployDate", applyDate);
			prepareMap.put("functionType", func);
			responseDTO.setValue("prepareMap", prepareMap);
		} else {
			// 查询调配主表信息
			String prepareNo = reqDTO.getValue("prepareNo");
			String prepareMapStr = "select t.prepare_no,"
					+ "       t.prepare_id,"
					+ "       t.applicant_id,"
					+ "       to_char(t.deploy_date,'yyyy-MM-dd hh24:mi') deploy_date,t.notes,"
					+ "       t.prepare_status,t.function_type,t.prepare_org_id,t.proc_inst_id,"
					+ "       t2.employee_name applicant_name,t.spare2,t.spare3"
					+ "  from bgp_human_prepare t"
					+ "  left join comm_human_employee t2 on t.applicant_id = t2.employee_id"
					+ "  and t2.bsflag = '0' and t.bsflag='0' where t.prepare_no='"
					+ prepareNo + "'";
			prepareMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
					prepareMapStr);
			responseDTO.setValue("update", update);

		}
		// 传调配信息
		responseDTO.setValue("prepareMap", prepareMap);
		StringBuffer sb = new StringBuffer();
		if (null != update && !"".equals(update)) {
			// 修改查询子表信息
			String prepareNo = reqDTO.getValue("prepareNo");
			sb
					.append("select p.prepare_post_detail_no,p.post,p.people_number,p.audit_number,al.pre_num,p.prepare_number,p.notes,r.prepare_org_id,s.org_subjection_id prepare_subjection_id, ");
			sb
					.append("p.age,p.culture,p.apply_team,p.plan_start_date,p.plan_end_date,p.work_years,p.work_trade_years,p.spare1,d1.coding_name postname, d2.coding_name apply_teamname ");
			sb
					.append("from bgp_human_prepare_post_detail p inner join bgp_human_prepare r on p.prepare_no=r.prepare_no and r.bsflag='0' ");
			sb
					.append("left join comm_org_subjection s on r.prepare_org_id = s.org_id and s.bsflag = '0' ");
			sb
					.append("left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
			sb
					.append("left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");
			sb
					.append("left join comm_coding_sort_detail d3 on p.culture = d3.coding_code_id ");
			sb
					.append("left join (select count(distinct(t.employee_id)) pre_num, t.work_post post ");
			sb.append("from bgp_human_prepare_human_detail t ");
			sb
					.append("inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' ");
			sb
					.append("where p.")
					.append(infoKeyName[arrayLoc])
					.append("='")
					.append(keyId)
					.append(
							"' and p.prepare_status = '2' and t.bsflag = '0' group by ");
			sb.append(" t.work_post) al on al.post= p.post ");
			sb.append(" where p.bsflag='0' and r.prepare_no='").append(
					prepareNo).append("' order by p.apply_team,p.post ");

		} else {

			sb.append("select p.post,al.pre_num, p.notes, ");
			if (arrayLoc == 2) {
				sb
						.append(" p.people_num,p.own_num,p.deploy_num,p.audit_num people_number,p.audit_own audit_number,p.audit_deploy, ");
			} else {
				sb.append("  p.people_number,p.audit_number, ");
			}
			sb
					.append("p.age,p.culture,(p.plan_end_date-p.plan_start_date + 1 ) spare1,p.apply_team,p.plan_start_date,p.plan_end_date,p.work_years,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname ");
			sb.append("from ").append(detailTableName[arrayLoc]).append(" p ");
			sb.append("inner join ").append(infoTableName[arrayLoc]).append(
					" r on p.").append(infoKeyName[arrayLoc]).append(" = r.")
					.append(infoKeyName[arrayLoc]);
			sb
					.append(" left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
			sb
					.append(" left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");
			sb
					.append(" left join comm_coding_sort_detail d3 on p.culture = d3.coding_code_id ");
			sb
					.append(" left join (select count(distinct(t.employee_id)) pre_num , t.work_post post ");
			if (arrayLoc != 0) {
				sb.append(", p.prepare_org_id ");
			}
			sb.append(" from bgp_human_prepare_human_detail t ");
			sb
					.append(" inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' ");
			sb
					.append("  where p.")
					.append(infoKeyName[arrayLoc])
					.append(" ='")
					.append(keyId)
					.append(
							"' and p.prepare_status = '2' and t.bsflag = '0' group by  ");
			if (arrayLoc != 0) {
				sb.append(" p.prepare_org_id, ");
			}
			sb.append("  t.work_post ) al on al.post= p.post ");
			if (arrayLoc != 0) {
				sb.append(" and al.prepare_org_id = r.apply_company ");
			}
			sb.append(" where p.bsflag='0' and p.").append(
					infoKeyName[arrayLoc]).append("='").append(keyId).append(
					"' order by p.apply_team,p.post ");

			if (arrayLoc == 2 || arrayLoc == 1) {

				// 专业化、调剂人员查询分解表
				StringBuffer querySub = new StringBuffer(
						" select d.post_detail_no,d.apply_team,d.post,d.people_number,al.al_num,d.deploy_org,d.competence,d.age,d.spare1, ");
				querySub
						.append("d.work_years,d.work_trade_years,d.culture,d.plan_start_date,d.plan_end_date,t1.org_name deploy_org_name,t2.org_subjection_id deploy_sub_id,  ");
				querySub
						.append("nvl(d3.coding_name,d.culture) culture_name,d1.coding_name postname, d2.coding_name apply_teamname  ");
				if (arrayLoc == 2) {
					querySub
							.append(",d.deploy_flag, case when d4.num1 > 0 then 'true' else 'false' end de_flag ");
				}
				querySub.append("from ").append(detaTableName[arrayLoc])
						.append(" d ");
				querySub.append(" inner join ").append(
						detailTableName[arrayLoc]).append(
						" p on d.post_no = p.post_no and p.bsflag='0' ");
				querySub.append(" inner join ").append(infoTableName[arrayLoc])
						.append(" f on p.").append(infoKeyName[arrayLoc])
						.append(" = f.").append(infoKeyName[arrayLoc]).append(
								" and f.bsflag='0' ");
				querySub
						.append(" left join (select count(t.employee_id) al_num , t.work_post post , p.prepare_org_id ");
				querySub.append(" from bgp_human_prepare_human_detail t ");
				querySub
						.append(" inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' and p.spare2 <> '3' ");
				querySub
						.append(" where p.")
						.append(infoKeyName[arrayLoc])
						.append("='")
						.append(keyId)
						.append(
								"' and p.prepare_status = '2' and t.bsflag = '0' group by  p.prepare_org_id,t.work_post ) al ");
				querySub
						.append(" on al.post= d.post and al.prepare_org_id=d.deploy_org ");
				querySub
						.append(" left join comm_org_information t1 on d.deploy_org = t1.org_id and t1.bsflag='0' ");
				querySub
						.append(" left join comm_org_subjection t2 on d.deploy_org = t2.org_id and t2.bsflag='0' ");
				querySub
						.append(" left join comm_coding_sort_detail d1 on d.post = d1.coding_code_id and d1.bsflag='0'");
				querySub
						.append(" left join comm_coding_sort_detail d2 on d.apply_team = d2.coding_code_id and d2.bsflag='0'");
				querySub
						.append(" left join comm_coding_sort_detail d3 on d.culture = d3.coding_code_id and d3.bsflag='0'");
				if (arrayLoc == 2) {
					querySub
							.append(" left join (select d.post_detail_no, count(a.employee_id) num1 ");
					querySub
							.append(" from bgp_comm_human_allocate_task_a a left join bgp_project_human_profess_deta d on d.post_detail_no = a.post_detail_no ");
					querySub.append(" where a.employee_id = '").append(
							user.getEmpId()).append(
							"' group by d.post_detail_no) d4 ");
					querySub.append(" on d4.post_detail_no = d.post_detail_no");
				}
				querySub.append(" where d.bsflag='0'");
				if (arrayLoc == 2) {
					querySub.append(" and d.deploy_flag in ('1','2') ");
				}
				querySub.append(" and f.").append(infoKeyName[arrayLoc])
						.append("='").append(keyId).append(
								"' order by d.apply_team ");

				List sublist = BeanFactory.getQueryJdbcDAO().queryRecords(
						querySub.toString());

				responseDTO.setValue("subDetailInfo", sublist);

			}
		}
		// 新增时查询需求子表,修改时查询调配子表(内容为岗位信息)
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);

		// 如果为修改和查看则查询调配人员信息
		if (null != update && !"".equals(update)) {
			String prepareNo = reqDTO.getValue("prepareNo");
			String huamnStr = "select t.human_detail_no,"
					+ "       t.team,"
					+ "       t.work_post,"
					+ "       t.employee_id,"
					+ "       e.employee_name,"
					+ "       t.plan_start_date,"
					+ "       t.plan_end_date,"
					+ "       (t.plan_end_date- t.plan_start_date + 1) plan_days,"
					+ "       (t.actual_end_date- t.actual_start_date + 1) actual_days,"
					+ "       t.actual_start_date,d1.coding_name work_post_name, d2.coding_name team_name,"
					+ "       t.actual_end_date,t.spare1,t.notes "
					+ "  from bgp_human_prepare_human_detail t"
					+ "  inner join bgp_human_prepare r on t.prepare_no = r.prepare_no and r.bsflag='0' "
					+ "  left join comm_coding_sort_detail d1 on t.work_post = d1.coding_code_id"
					+ "  left join comm_coding_sort_detail d2 on t.team = d2.coding_code_id"
					+ "  left join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag='0'"
					+ "  where t.prepare_no='" + prepareNo + "'";
			List humanInfoList = BeanFactory.getQueryJdbcDAO().queryRecords(
					huamnStr);
			responseDTO.setValue("humanInfoList", humanInfoList);
		}

		// 查询附件信息
		String queryFileSql = "select t2.info_id,t3.file_id,t3.creator,t3.create_date,t4.org_name,t3.file_name  from "
				+ infoTableName[arrayLoc]
				+ " t1 inner join p_file_index t2 on t1.document_id = t2.info_id  inner join p_file_content t3 on t2.info_id =t3.info_id and t3.bsflag='0'"
				+ " inner join comm_org_information t4 on t3.org_id = t4.org_id "
				+ " left outer join comm_human_employee t5 on t5.employee_id = t4.creator "
				+ " where t1." + infoKeyName[arrayLoc] + " = '" + keyId + "'";
		List listFile = BeanFactory.getQueryJdbcDAO()
				.queryRecords(queryFileSql);
		responseDTO.setValue("fileInfo", listFile);

		// 处理审核模板信息
		String audit_info = reqDTO.getValue("audit_info");
		if (audit_info != null && !"".equals(audit_info)) {

			WorkFlowBean workFlowBean = (WorkFlowBean) BeanFactory
					.getBean("workFlowBean");
			workFlowBean.getExamineInfo(reqDTO, responseDTO);
		}
		// 获取审批历史信息
		if (map.get("procInstId") != null) {
			WorkFlowBean workFlowBean = (WorkFlowBean) BeanFactory
					.getBean("workFlowBean");
			List listProcHistory = workFlowBean.getProcHistory((String) map
					.get("procInstId"));
			responseDTO.setValue("listProcHistory", listProcHistory);
		}

		// 获取调配审批历史信息
		if (prepareMap.get("procInstId") != null) {
			WorkFlowBean workFlowBean = (WorkFlowBean) BeanFactory
					.getBean("workFlowBean");
			List listProcHistory = workFlowBean
					.getProcHistory((String) prepareMap.get("procInstId"));
			responseDTO.setValue("listProcHistory1", listProcHistory);
		}

		String busKey = "humanPrepare";// 默认普通调配
		if ("2".equals(func)) {
			busKey = "reliefPrepare";// 调剂调配
		} else if ("3".equals(func)) {
			busKey = "professionPrepare";// 专业化调配
		}

		// 获取通知信息
		if (audit_info == null || "".equals(audit_info)) {
			String prepareNo = reqDTO.getValue("prepareNo");
			StringBuffer queryNoticeSql = new StringBuffer();
			queryNoticeSql
					.append(
							"select distinct wmsys.wm_concat(t3.notifier_method)  notice_way,")
					.append(
							" wmsys.wm_concat(distinct t2.employee_id) notice_user_id,  ")
					.append(
							" wmsys.wm_concat(distinct t4.employee_name) notice_user_name  ")
					.append(" from bgp_comm_notifer_info t1  ")
					.append(
							" inner join bgp_comm_notifer_detail t2 on t1.notifer_info_id =  ")
					.append(" t2.notifer_info_id  ")
					.append(" and t1.bsflag = '0'  and t1.business_key='")
					.append(prepareNo)
					.append("' and t1.business_assistant_key='")
					.append(busKey)
					.append("' ")
					.append("  and t2.bsflag = '0'  ")
					.append(
							" inner join bgp_comm_notifier_method t3 on t2.notifer_detail_id =  ")
					.append(" t3.notifer_detail_id  ")
					.append("  and t3.bsflag = '0'")
					.append(
							" left outer join comm_human_employee t4 on t2.employee_id = t4.employee_id and t4.bsflag='0'");
			Map mapNotcieInfo = queryJdbcDao.queryRecordBySQL(queryNoticeSql
					.toString());
			map.put("noticeUserId", mapNotcieInfo.get("noticeUserId"));
			map.put("noticeWay", mapNotcieInfo.get("noticeWay"));
			map.put("noticeUser", mapNotcieInfo.get("noticeUserName"));
		}
		responseDTO.setValue("applyInfo", map);
		// 查询所有岗位不包含班组
		StringBuffer sql = new StringBuffer(
				"select team.coding_code_id team,team.coding_name teamname, pos.coding_code_id apply_post,");
		sql
				.append(" pos.coding_name apply_postname from (SELECT t.coding_sort_id, t.coding_code_id, t.coding_code,t.coding_name");
		sql
				.append(" FROM comm_coding_sort_detail t  where t.coding_sort_id = '0110000001' and t.bsflag = '0'");
		sql.append(" and t.spare1='0' and length(t.coding_code) = 2  ");
		if (arrayLoc == 2) {
			// 专业化人员申请
			sql.append(" and t.spare2='0'");
		}
		sql
				.append(" order by t.coding_show_id) team, comm_coding_sort_detail pos where team.coding_sort_id = pos.coding_sort_id and length(pos.coding_code) > 2");
		sql.append(" and team.coding_code = Substr(pos.coding_code,0,2)");

		List postList = BeanFactory.getQueryJdbcDAO().queryRecords(
				sql.toString());
		responseDTO.setValue("postList", postList);
		// 查询所有班组不含岗位
		String psql = "SELECT t.coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) = 2 ";
		if (arrayLoc == 2) {
			// 专业化人员申请
			psql += " and t.spare2='0' order by t.coding_show_id";
		} else {
			// 人员申请
			psql += " order by t.coding_show_id";
		}
		List teamlist = BeanFactory.getQueryJdbcDAO().queryRecords(psql);
		responseDTO.setValue("teamList", teamlist);
		responseDTO.setValue("stateNone", stateNone);
		return responseDTO;
	}

	/**
	 * 查询调配人员时选择人员
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg searchforHumanInfo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String params = reqDTO.getValue("params");
		if (params != null && !params.equals("")) {
			params = URLDecoder.decode(params, "UTF-8");
		}

		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		int currentPage2 = Integer.parseInt(currentPage);
		int pageSize2 = Integer.parseInt(pageSize);
		int rowStart = (currentPage2 - 1) * pageSize2;
		int rowEnd = currentPage2 * pageSize2;

		String funcCode = reqDTO.getValue("funcCode");
		IDataPermProcessor dpProc = (IDataPermProcessor) BeanFactory
				.getBean("ICGDataPermProcessor");
		// 得到过滤后的sql查询可查看的人员id
		String sql = "select e.employee_id,  e.employee_name, e.employee_gender, decode(e.employee_gender, '0', '女', '1', '男') employee_gender_name,  decode(hr.person_status, '0', '', '1',i1.org_abbreviation , '') relief_org_name,hr.relief_org,  (to_char(sysdate, 'yyyy') -  to_char(e.employee_birth_date, 'yyyy')) age, e.org_id,  i.org_abbreviation,  i.org_name,  hr.post, hr.spare2,   hr.employee_cd,hr.set_team,hr.set_post,d1.coding_name set_team_name,d2.coding_name set_post_name,decode((to_char(sysdate, 'yyyy') - to_char(hr.work_date, 'yyyy')),  '0', '1',(to_char(sysdate, 'yyyy') - to_char(hr.work_date, 'yyyy'))) work_age,  s.org_subjection_id , decode(nvl(hr.deploy_status,'0'),'0','','1','调配中','2','已调配','') deploy_status_name, nvl(hr.deploy_status,'0') deploy_status, decode(hr.person_status,'0','不在项目','1','在项目','不在项目') person_status ,decode(hr.person_status, '0', '', '1', to_char(t2.plan_end_date,'yyyy-MM-dd'), '') plan_end_date,  t2.team, t2.work_post,t4.actual_start_date,t4.actual_end_date,t4.project_name from comm_human_employee e   inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id   left join comm_org_subjection s on e.org_id = s.org_id   and s.bsflag = '0'   left join comm_org_information i on e.org_id = i.org_id    and i.bsflag = '0'  left join comm_org_information i1 on hr.relief_org = i1.org_id and i1.bsflag = '0'   left join comm_coding_sort_detail d1 on hr.set_team=d1.coding_code_id  left join comm_coding_sort_detail d2 on hr.set_post=d2.coding_code_id left join (select * from (select employee_id,team,work_post, plan_end_date, row_number() over(partition by employee_id order by plan_end_date desc) r  from bgp_human_prepare_human_detail) t1 where t1.r=1) t2 on e.employee_id=t2.employee_id left join (select t3.*,p1.project_name from (select employee_id,project_info_no, actual_start_date,actual_end_date,  row_number() over(partition by employee_id order by actual_start_date desc) r from bgp_project_human_relation where bsflag='0' and locked_if = '1' ) t3 left join gp_task_project p1 on t3.project_info_no = p1.project_info_no  where t3.r = 1) t4 on e.employee_id = t4.employee_id where e.bsflag = '0' ";
		DataPermission dp = dpProc.getDataPermission(user, funcCode, sql);

		StringBuffer humanSql = new StringBuffer();
		humanSql.append("select * from (select datas.*,rownum rownum_ from (");
		humanSql.append(dp.getFilteredSql()).append(params);
		humanSql.append(") datas where rownum <= ").append(rowEnd).append(
				") where rownum_ > ").append(rowStart);

		List datas = BeanFactory.getQueryJdbcDAO().queryRecords(
				humanSql.toString());

		humanSql = new StringBuffer();
		humanSql.append("select count(1) count from ( ");
		humanSql.append(dp.getFilteredSql()).append(params).append(")");

		String totalRows = "0";
		Map countMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
				humanSql.toString());
		if (countMap != null) {
			totalRows = (String) countMap.get("count");
			if (totalRows == null || totalRows.equals(""))
				totalRows = "0";
		}

		msg.setValue("datas", datas);
		msg.setValue("totalRows", totalRows);

		int total = Integer.parseInt(totalRows);
		int pageCount = total / pageSize2;
		pageCount += ((total % pageSize2) == 0 ? 0 : 1);

		msg.setValue("pageCount", pageCount);
		msg.setValue("pageSize", pageSize);
		msg.setValue("currentPage", currentPage);

		return msg;
	}

	/*
	 * 查询申请队所有人员
	 */
	public ISrvMsg queryImportHumanList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		String isSet = reqDTO.getValue("isSet");
		String projectType = reqDTO.getValue("project_type");
		String checked = reqDTO.getValue("checked");
		checked = URLDecoder.decode(checked, "utf-8");
		checked = URLDecoder.decode(checked, "utf-8");
		
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000002")){
			projectType="5000100004000000001";
		}
		
		String str = "";
		List postList = new ArrayList();
		if (checked != null && !"".equals(checked)) {
			String[] check = checked.split(",");
			for (int i = 0; i < check.length; i++) {
				String[] mes = check[i].split("@");
				String team = "";
				String workPost = "";
				if (mes[2] != null && !"".equals(mes[2])) {
					Map prepare = jdbcDao
							.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
									+ mes[2]
									+ "' and t.coding_sort_id='0110000001' and t.coding_mnemonic_id='"+projectType+"'  and t.bsflag='0' ");
					if (prepare != null) {
						team = (String) prepare.get("coding_code_id");
					}
				}
				if (mes[3] != null && !"".equals(mes[3])) {
					Map prepare = jdbcDao
							.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
									+ mes[3]
									+ "' and t.coding_sort_id='0110000001' and t.coding_mnemonic_id='"+projectType+"'  and t.bsflag='0' ");
					if (prepare != null) {
						workPost = (String) prepare.get("coding_code_id");
					}
				}

				StringBuffer sb = new StringBuffer(
						"select '0' qufen,  e.employee_id,e.employee_name,nvl(hr.deploy_status,'0') deploy_status,nvl(hr.person_status,'0' ) person_status, ");
				if ("2".equals(isSet)) {
					// 上次调配的班组岗位优先
					sb
							.append("decode(nvl(t2.team,''),'',hr.set_team,t2.team) team, decode(nvl(t2.work_post,''),'',hr.set_post,t2.work_post) work_post ");
				} else {
					// 设置的班组岗位优先
					sb
							.append("decode(nvl(hr.set_team,''),'',t2.team,hr.set_team) team, decode(nvl(hr.set_post,''),'',t2.work_post,hr.set_post) work_post ");
				}
				sb
						.append("  from comm_human_employee e inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id  and hr.bsflag = '0' ");
				sb
						.append("  left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' ");
				sb
						.append("  left join comm_org_information i on e.org_id = i.org_id and i.bsflag = '0' ");
				sb
						.append(" left join (select *  from (select employee_id,team,work_post, plan_end_date, ");
				sb
						.append(" row_number() over(partition by employee_id order by plan_end_date desc) r ");
				sb
						.append("  from bgp_human_prepare_human_detail) t1  where t1.r = 1) t2 on e.employee_id = t2.employee_id ");
				sb.append("  where e.bsflag = '0' ");
				sb.append(" and hr.employee_cd ='").append(mes[0]).append("' ");
				Map sbMap = jdbcDao.queryRecordBySQL(sb.toString());

				if (sbMap != null) {
					if (team != "" && workPost != "") {
						sbMap.put("team", team);
						sbMap.put("work_post", workPost);

						if (mes.length >= 5 && mes[4] != null
								&& !"".equals(mes[4])) {
							sbMap.put("start_date", mes[4]);
						} else {
							sbMap.put("start_date", "");
						}
						if (mes.length >= 6 && mes[5] != null
								&& !"".equals(mes[5])) {
							sbMap.put("end_date", mes[5]);
						} else {
							sbMap.put("end_date", "");
						}
					}
					postList.add(sbMap);
				}else{
					str+="第"+(i+1)+"行人员不存在\n";
				}

			}
		}

		if (postList != null) {
			responseDTO.setValue("peopleList", postList);
		}
		if (str != null && !"".equals(str)) {
			responseDTO.setValue("str", str);
		}
		return responseDTO;
	}

	/*
	 * 查询综合业务申请队所有人员临时和正式
	 */
	public ISrvMsg queryImportHumanListZh(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		String isSet = reqDTO.getValue("isSet");
		String projectType = reqDTO.getValue("project_type");
		String checked = reqDTO.getValue("checked");
		checked = URLDecoder.decode(checked, "utf-8");
		checked = URLDecoder.decode(checked, "utf-8");
		
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000002")){
			projectType="5000100004000000001";
		}
		
		String str = "";
		List postList = new ArrayList();
		if (checked != null && !"".equals(checked)) {
			String[] check = checked.split(",");
			for (int i = 0; i < check.length; i++) {
				String[] mes = check[i].split("@");
				String team = "";
				String workPost = "";
				if (mes[2] != null && !"".equals(mes[2])) {
					Map prepare = jdbcDao
							.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
									+ mes[2]
									+ "' and t.coding_sort_id='0110000001' and t.coding_mnemonic_id='"+projectType+"'  and t.bsflag='0' ");
					if (prepare != null) {
						team = (String) prepare.get("coding_code_id");
					}
				}
				if (mes[3] != null && !"".equals(mes[3])) {
					Map prepare = jdbcDao
							.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"
									+ mes[3]
									+ "' and t.coding_sort_id='0110000001' and t.coding_mnemonic_id='"+projectType+"'  and t.bsflag='0' ");
					if (prepare != null) {
						workPost = (String) prepare.get("coding_code_id");
					}
				}
				//根据身份证号, 人员编号分别进行判断查询
		 
				StringBuffer sb = new StringBuffer(
						"select '0' qufen, e.employee_id,e.employee_name,nvl(hr.deploy_status,'0') deploy_status,nvl(hr.person_status,'0' ) person_status, ");
				if ("2".equals(isSet)) {
					// 上次调配的班组岗位优先
					sb
							.append("decode(nvl(t2.team,''),'',hr.set_team,t2.team) team, decode(nvl(t2.work_post,''),'',hr.set_post,t2.work_post) work_post ");
				} else {
					// 设置的班组岗位优先
					sb
							.append("decode(nvl(hr.set_team,''),'',t2.team,hr.set_team) team, decode(nvl(hr.set_post,''),'',t2.work_post,hr.set_post) work_post ");
				}
				sb
						.append("  from comm_human_employee e inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id  and hr.bsflag = '0' ");
				sb
						.append("  left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' ");
				sb
						.append("  left join comm_org_information i on e.org_id = i.org_id and i.bsflag = '0' ");
				sb
						.append(" left join (select *  from (select employee_id,team,work_post, plan_end_date, ");
				sb
						.append(" row_number() over(partition by employee_id order by plan_end_date desc) r ");
				sb
						.append("  from bgp_human_prepare_human_detail) t1  where t1.r = 1) t2 on e.employee_id = t2.employee_id ");
				sb.append("  where e.bsflag = '0' ");
				sb.append(" and hr.employee_cd ='").append(mes[0]).append("'  union all  select '1' qufen, lr.labor_id as employee_id ,lr.employee_name,    nvl(lr.spare1, '0') deploy_status, nvl(lr.if_project, '0') person_status   ,  decode(nvl(lr.apply_team, ''), '', t2.team, lr.apply_team) team,  decode(nvl(lr.post, ''), '', t2.work_post, lr.post) work_post     from  bgp_comm_human_labor  lr     left join (select *  from (select dl.labor_id,  dy.apply_team  team,  dy.post work_post,  dl.spare4 plan_end_date,  row_number() over(partition by dl.labor_id order by dl.spare4  desc) r   from bgp_comm_human_labor_deploy  dl left join bgp_comm_human_deploy_detail dy  on dl.labor_deploy_id  = dy.labor_deploy_id  and dl.bsflag='0'  ) t1  where t1.r = 1) t2  on lr.labor_id =t2.labor_id  where lr.bsflag='0'   and lr.employee_id_code_no='").append(mes[0]).append("' ");
				System.out.println(sb.toString());
				Map sbMap = jdbcDao.queryRecordBySQL(sb.toString());

				if (sbMap != null) {
					if (team != "" && workPost != "") {
						sbMap.put("team", team);
						sbMap.put("work_post", workPost);

						if (mes.length >= 5 && mes[4] != null
								&& !"".equals(mes[4])) {
							sbMap.put("start_date", mes[4]);
						} else {
							sbMap.put("start_date", "");
						}
						if (mes.length >= 6 && mes[5] != null
								&& !"".equals(mes[5])) {
							sbMap.put("end_date", mes[5]);
						} else {
							sbMap.put("end_date", "");
						}
					}
			 
					postList.add(sbMap);
				}else{
					str+="第"+(i+1)+"行人员不存在\n";
				}

			}
		}

		if (postList != null) {
			responseDTO.setValue("peopleList", postList);
		}
		if (str != null && !"".equals(str)) {
			responseDTO.setValue("str", str);
		}
		return responseDTO;
	}
	
	
	/*
	 * 查询班组
	 */
	public ISrvMsg queryApplyTeam(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String spare2 = reqDTO.getValue("spare2");
		String projectType = reqDTO.getValue("project_type");
		UserToken user = reqDTO.getUserToken();

		//String projectType=user.getProjectType();
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000002")){
			projectType="5000100004000000001";
		}
		
		StringBuffer sb = new StringBuffer(
				"SELECT t.coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.coding_mnemonic_id='"+projectType+"' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) <= 2");
		if (spare2 != null && !"".equals(spare2)) {
			sb.append(" and t.spare2='").append(spare2).append("'");
		}
		sb.append(" order by t.coding_show_id ");
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
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
		sb
				.append(" where t.coding_sort_id = d.coding_sort_id and t.bsflag = '0' and t.coding_code like d.coding_code||'_%'  order by t.coding_show_id ");

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}
	/**
	 * 人员调配和调剂调配的保存和修改保存
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */

	public ISrvMsg humanPrepareSave(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		// 人员需求主键
		String requirementNo = reqDTO.getValue("requirementNo");

		String prePrepareNo = reqDTO.getValue("preprepareNo");

		BgpHumanPrepare preparePojo = new BgpHumanPrepare();
		PropertiesUtil.msgToPojo("pre", reqDTO, preparePojo);
		Map prepare = new HashMap();
		prepare = PropertiesUtil.describe(preparePojo);

		prepare.put("requirement_no", requirementNo);
		prepare.put("project_info_no", projectInfoNo);
		prepare.put("deploy_date", (String) prepare.get("deploy_date") + ":00");
		prepare.put("bsflag", "0");
		prepare.put("updator", user.getEmpId());
		prepare.put("modifi_date", new Date());
		prepare.put("prepare_status", "1");
		// 主表bgp_human_prepare主键值保存值
		String preIn = "";
		// 处理调配主表信息为空则为新增
		if (prePrepareNo == null || "".equals(prePrepareNo)) {
			String prepareId = EquipmentAutoNum.generateNumberByUserToken(
					reqDTO.getUserToken(), "RPTP");
			// 设状态为调配中
			prepare.put("creator", user.getEmpId());
			prepare.put("create_date", new Date());
			prepare.put("prepare_id", prepareId);
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
					prepare, "bgp_human_prepare");
			preIn = id.toString();

		} else {
			preIn = prePrepareNo;
			prepare.put("prepare_no", prePrepareNo);
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(prepare,
					"bgp_human_prepare");
		}
		
		// 处理人员调配单岗位明细BGP_HUMAN_PREPARE_POST_DETAIL
		int postDetailSize = Integer.parseInt(reqDTO
				.getValue("postDetailSize"));
		int changeNum=0;
		int changeNumSum=0;
  
		Map postDetail = new HashMap();
		for (int i = 0; i < postDetailSize; i++) {
			BgpHumanPreparePostDetail prePostDetail = new BgpHumanPreparePostDetail(); 
			PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
					prePostDetail); 
			postDetail = PropertiesUtil.describe(prePostDetail); 

			postDetail.put("prepare_no", preIn);
			postDetail.put("bsflag", "0");
			postDetail.put("creator", user.getEmpId());
			postDetail.put("create_date", new Date());
			postDetail.put("updator", user.getEmpId());
			postDetail.put("modifi_date", new Date());
	
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(postDetail,
					"bgp_human_prepare_post_detail"); 

			String Snum=postDetail.get("prepare_number").toString();
			changeNum=Integer.parseInt(Snum);
			changeNumSum+=changeNum;
		 
			 
		}		 System.out.println(changeNumSum);
		  //如果调配人数为0时,保存主信息时把bgp_human_prepare ”调配中 “ 的调配状态改为 待调配
		if(changeNumSum==0){ 
	    		String sql = "update bgp_human_prepare set prepare_status='0' ,modifi_date = sysdate where prepare_no ='"
					+ preIn + "'";
			    jdbcDao.executeUpdate(sql);
	   
		}
	
		// 人员调配单人员明细BGP_HUMAN_PREPARE_HUMAN_DETAIL
		String[] hidDeatilId = {};
		String[] employeeIds = {};
		String[]  qufens = {};
		
		if (reqDTO.getValue("hidDetailId") != null) {
			hidDeatilId = reqDTO.getValue("hidDetailId").split(",");
			employeeIds = reqDTO.getValue("employeeIds").split(",");
			qufens = reqDTO.getValue("qufens").split(",");
		}
		
		
		for (int j = 0; j < hidDeatilId.length; j++) {
			 System.out.println("qufens"+qufens[j]);
			 if(qufens[j].equals("0")){
				//删除人员岗位信息时,同事更新人员信息表的 调配状态：未调配,和项目状态为：不在项目中
				String sql = "update comm_human_employee_hr set person_status='0', deploy_status='0' ,spare6='', modifi_date = sysdate where employee_id ='"
						+ employeeIds[j]+ "'";
				jdbcDao.executeUpdate(sql);
				
				BeanFactory.getPureJdbcDAO().deleteEntity("bgp_human_prepare_human_detail", hidDeatilId[j]);
			 }else{
					//删除人员岗位信息时,同事更新人员信息表的 调配状态：未调配,和项目状态为：不在项目中
					String sql = "update bgp_comm_human_labor set if_project='0',spare1='0', modifi_date = sysdate where labor_id ='"
							+ employeeIds[j]+ "'";
					jdbcDao.executeUpdate(sql); 
					String sqlA = "update bgp_comm_human_labor_deploy set bsflag='1',spare1='', modifi_date = sysdate where labor_deploy_id ='"
						+ hidDeatilId[j]+ "'";
				    jdbcDao.executeUpdate(sqlA);  
			 }
			 
		}
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
				
				Map mapDetail = new HashMap();
				Map mapLablorDetail = new HashMap();
				Map mapLablorNew = new HashMap();
				Map mapLablorD = new HashMap();
				
				for (int i = 0; i < equipmentSize; i++) {
					if (mapFlag.get(String.valueOf(i)) == null) {
						BgpHumanPrepareHumanDetail applyDetail = new BgpHumanPrepareHumanDetail();
						PropertiesUtil.msgToPojo("em" + String.valueOf(i), reqDTO,
								applyDetail);
						mapDetail = PropertiesUtil.describe(applyDetail);
						
						String printId =mapDetail.get("employee_id").toString(); 
					    String  psw=mapDetail.get("psw").toString(); 
					    
						String qufenId="";
						if(mapDetail.get("qufen").toString().equals("")){
							qufenId="2";
						}else{ 
							qufenId=mapDetail.get("qufen").toString();
						}
						 if (psw.equals("u")){   
							 if(qufenId.equals("0")){
							 System.out.println("正式工保存");
							mapDetail.put("prepare_no", preIn);
							mapDetail.put("spare1", "");// 否到岗，接收后将改为1到岗
							mapDetail.put("bsflag", "0");
							mapDetail.put("creator", user.getEmpId());
							mapDetail.put("create_date", new Date());
							mapDetail.put("updator", user.getEmpId());
							mapDetail.put("modifi_date", new Date());
			
							BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
									"bgp_human_prepare_human_detail");
							// 调配单保存：人员状态 为不在项目 person_status='0';调配状态改为1调配中;是否到岗spare6为空;
							String sql = "update comm_human_employee_hr set person_status='0', deploy_status='1' ,spare6='', modifi_date = sysdate where employee_id ='"
									+ mapDetail.get("employee_id") + "'";
							jdbcDao.executeUpdate(sql);
						}else if(qufenId.equals("1")){
					        System.out.println("临时工保存"); 
					     
								   String human_detail_nos=mapDetail.get("human_detail_no").toString();
								   
						        	mapLablorDetail.put("labor_deploy_id", human_detail_nos);
									mapLablorDetail.put("labor_id", mapDetail.get("employee_id")); 
									mapLablorDetail.put("start_date", mapDetail.get("plan_start_date"));
								//	mapLablorDetail.put("end_date", mapDetail.get("plan_end_date")); 
									mapLablorDetail.put("project_info_no", projectInfoNo); 
									mapLablorDetail.put("creator", user.getEmpId());
									mapLablorDetail.put("create_date", new Date());
									mapLablorDetail.put("updator", user.getEmpId());
									mapLablorDetail.put("modifi_date", new Date());
									mapLablorDetail.put("spare1", preIn);  // 专业化调配 id, prepare_no
									mapLablorDetail.put("spare4", mapDetail.get("plan_end_date"));  //临时工预计离开时间 
									mapLablorDetail.put("bsflag", "0"); 
								 
									Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapLablorDetail,
									"bgp_comm_human_labor_deploy");
							 
							 
							//   mapLablorNew=null;
							//调配后更新主表的项目状态
							String updateDeloySql = "update bgp_comm_human_labor d  set d.if_project = '0',spare1='1', d.modifi_date = sysdate where d.labor_id = '"+mapDetail.get("employee_id")+"' ";
							jdbcDao.getJdbcTemplate().update(updateDeloySql);
							 
					
						} 
						
						   } else if (psw.equals("a")){  
							   
							   if(qufenId.equals("0")){
									 System.out.println("正式工保存");
						 
									mapDetail.put("prepare_no", preIn);
									mapDetail.put("spare1", "");//否到岗，接收后将改为1到岗
									mapDetail.put("bsflag", "0");
									mapDetail.put("creator", user.getEmpId());
									mapDetail.put("create_date", new Date());
									mapDetail.put("updator", user.getEmpId());
									mapDetail.put("modifi_date", new Date());
						 
									BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
											"bgp_human_prepare_human_detail");
									//调配单保存：人员状态 为不在项目 person_status='0';调配状态改为1调配中;是否到岗spare6为空;
									String sql = "update comm_human_employee_hr set person_status='0', deploy_status='1' ,spare6='', modifi_date = sysdate where employee_id ='"+mapDetail.get("employee_id")+"'";
									jdbcDao.getJdbcTemplate().update(sql);
									 
								}else if(qufenId.equals("1")){
									        System.out.println("临时工保存"); 
									     
										        	mapLablorNew.put("labor_id", mapDetail.get("employee_id")); 
										        	mapLablorNew.put("start_date", mapDetail.get("plan_start_date"));
										        	mapLablorNew.put("project_info_no", projectInfoNo); 
										        	mapLablorNew.put("creator", user.getEmpId());
										        	mapLablorNew.put("create_date", new Date());
										        	mapLablorNew.put("updator", user.getEmpId());
										        	mapLablorNew.put("modifi_date", new Date());
										        	mapLablorNew.put("spare1", preIn);  // 专业化调配 id, prepare_no
													mapLablorNew.put("spare4", mapDetail.get("plan_end_date"));  //临时工预计离开时间 
													mapLablorNew.put("bsflag", "0"); 
											 
													Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapLablorNew,
													"bgp_comm_human_labor_deploy");
													
									        	 String newId= id.toString();
									        	 mapLablorD.put("spare1", preIn); 
									        	 mapLablorD.put("start_date", mapDetail.get("plan_start_date"));
									        	 mapLablorD.put("spare4", mapDetail.get("plan_end_date"));
									        	 mapLablorD.put("creator", user.getEmpId());
									        	 mapLablorD.put("create_date", new Date());
									        	 mapLablorD.put("updator", user.getEmpId());
									        	 mapLablorD.put("modifi_date", new Date());
									        	 mapLablorD.put("bsflag", "0");
									     //   	 mapLablorD.put("deploy_detail_id", "");
									        	 mapLablorD.put("labor_deploy_id", newId);
									        	 mapLablorD.put("apply_team", mapDetail.get("team")); 
									        	 mapLablorD.put("post", mapDetail.get("work_post"));  
												Serializable did = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapLablorD,
													"bgp_comm_human_deploy_detail");
												String deployDetailId = did.toString(); 
												
									      
											//   mapLablorNew=null;
											//调配后更新主表的项目状态
											String updateDeloySql = "update bgp_comm_human_labor d  set d.if_project = '0',spare1='1', d.modifi_date = sysdate where d.labor_id = '"+mapDetail.get("employee_id")+"' ";
											jdbcDao.getJdbcTemplate().update(updateDeloySql);
											 
									
								    
							   
						           }
						   }
		
					} 
				}
	     
		
		
		return responseDTO;
	}
	/**
	 * 人员调配和调剂调配的保存和修改保存
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */

	public ISrvMsg humanPrepareSavewfpa(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		// 人员需求主键
		String requirementNo = reqDTO.getValue("requirementNo");
		// 1-普通调配 2-调剂调配3-专业化人员调配
		String function = reqDTO.getValue("prefunctionType");

		String prePrepareNo = reqDTO.getValue("preprepareNo");

		int arrayLoc = 0;// 默认普通调配
		if ("2".equals(function)) {
			arrayLoc = 1;// 调剂调配
		} else if ("3".equals(function)) {
			arrayLoc = 2;// 调剂调配
		}

		BgpHumanPrepare preparePojo = new BgpHumanPrepare();
		PropertiesUtil.msgToPojo("pre", reqDTO, preparePojo);
		Map prepare = new HashMap();
		prepare = PropertiesUtil.describe(preparePojo);

		prepare.put(infoKeyName[arrayLoc], requirementNo);
		prepare.put("project_info_no", projectInfoNo);
		prepare.put("deploy_date", (String) prepare.get("deploy_date") + ":00");
		prepare.put("bsflag", "0");
		prepare.put("updator", user.getEmpId());
		prepare.put("modifi_date", new Date());
		prepare.put("prepare_status", "1");
		// 主表bgp_human_prepare主键值保存值
		String preIn = "";
		// 处理调配主表信息为空则为新增
		if (prePrepareNo == null || "".equals(prePrepareNo)) {
			String prepareId = EquipmentAutoNum.generateNumberByUserToken(
					reqDTO.getUserToken(), operType[arrayLoc]);
			// 设状态为调配中
			prepare.put("creator", user.getEmpId());
			prepare.put("create_date", new Date());
			prepare.put("prepare_id", prepareId);
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
					prepare, "bgp_human_prepare");
			preIn = id.toString();

		} else {
			preIn = prePrepareNo;
			prepare.put("prepare_no", prePrepareNo);
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(prepare,
					"bgp_human_prepare");
		}
		if ("3".equals(function)) {
			Map postDetail = new HashMap();
			String deployOrgId = "";
			if (reqDTO.getValue("postDetailSize") != null) {
				int postDetailSize = Integer.parseInt(reqDTO
						.getValue("postDetailSize"));
				for (int i = 0; i < postDetailSize; i++) {
					BgpHumanPreparePostDetail prePostDetail = new BgpHumanPreparePostDetail();
					PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
							prePostDetail);
					postDetail = PropertiesUtil.describe(prePostDetail);
					if ("true".equals(postDetail.get("flag"))) {
						postDetail.put("prepare_no", preIn);
						postDetail.put("bsflag", "0");
						postDetail.put("creator", user.getEmpId());
						postDetail.put("create_date", new Date());
						postDetail.put("updator", user.getEmpId());
						postDetail.put("modifi_date", new Date());

						BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
								postDetail, "bgp_human_prepare_post_detail");
					}
				}
			}

			if (reqDTO.getValue("equipmentESize") != null) {
				int equipmentESize = Integer.parseInt(reqDTO
						.getValue("equipmentESize"));
				for (int i = 0; i < equipmentESize; i++) {
					BgpHumanPreparePostDetail prePostDetail = new BgpHumanPreparePostDetail();
					PropertiesUtil.msgToPojo("hu" + String.valueOf(i), reqDTO,
							prePostDetail);
					postDetail = PropertiesUtil.describe(prePostDetail);
					if ("true".equals(postDetail.get("flag"))) {
						deployOrgId = (String) postDetail.get("deploy_org");
						postDetail.put("prepare_no", preIn);
						postDetail.put("bsflag", "0");
						postDetail.put("creator", user.getEmpId());
						postDetail.put("create_date", new Date());
						postDetail.put("updator", user.getEmpId());
						postDetail.put("modifi_date", new Date());

						BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
								postDetail, "bgp_human_prepare_post_detail");
					}
				}
			}
			if (deployOrgId != null && !"".equals(deployOrgId)) {
				String sql = "update bgp_human_prepare set prepare_org_id='"
						+ deployOrgId + "' where prepare_no ='" + preIn + "'";
				jdbcDao.executeUpdate(sql);
			}
		} else if ("1".equals(function)) {
			// 处理人员调配单岗位明细BGP_HUMAN_PREPARE_POST_DETAIL
			int postDetailSize = Integer.parseInt(reqDTO
					.getValue("postDetailSize"));
			Map postDetail = new HashMap();
			for (int i = 0; i < postDetailSize; i++) {
				BgpHumanPreparePostDetail prePostDetail = new BgpHumanPreparePostDetail();
				PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
						prePostDetail);
				postDetail = PropertiesUtil.describe(prePostDetail);

				postDetail.put("prepare_no", preIn);
				postDetail.put("bsflag", "0");
				postDetail.put("creator", user.getEmpId());
				postDetail.put("create_date", new Date());
				postDetail.put("updator", user.getEmpId());
				postDetail.put("modifi_date", new Date());

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(postDetail,
						"bgp_human_prepare_post_detail");

			}
		} else {
			// 调剂调配只保存人员岗位分解表
			Map postDetail = new HashMap();
			String deployOrgId = "";
			if (reqDTO.getValue("equipmentESize") != null) {
				int equipmentESize = Integer.parseInt(reqDTO
						.getValue("equipmentESize"));
				for (int i = 0; i < equipmentESize; i++) {
					BgpHumanPreparePostDetail prePostDetail = new BgpHumanPreparePostDetail();
					PropertiesUtil.msgToPojo("hu" + String.valueOf(i), reqDTO,
							prePostDetail);
					postDetail = PropertiesUtil.describe(prePostDetail);
					if ("true".equals(postDetail.get("flag"))) {
						deployOrgId = (String) postDetail.get("deploy_org");
						postDetail.put("prepare_no", preIn);
						postDetail.put("bsflag", "0");
						postDetail.put("creator", user.getEmpId());
						postDetail.put("create_date", new Date());
						postDetail.put("updator", user.getEmpId());
						postDetail.put("modifi_date", new Date());

						BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
								postDetail, "bgp_human_prepare_post_detail");
					}
				}
			}
			if (deployOrgId != null && !"".equals(deployOrgId)) {
				String sql = "update bgp_human_prepare set prepare_org_id='"
						+ deployOrgId + "' where prepare_no ='" + preIn + "'";
				jdbcDao.executeUpdate(sql);
			}
		}

		// 人员调配单人员明细BGP_HUMAN_PREPARE_HUMAN_DETAIL
		String[] hidDeatilId = {};
		if (reqDTO.getValue("hidDetailId") != null) {
			hidDeatilId = reqDTO.getValue("hidDetailId").split(",");
		}
		for (int j = 0; j < hidDeatilId.length; j++) {
			BeanFactory.getPureJdbcDAO().deleteEntity(
					"bgp_human_prepare_human_detail", hidDeatilId[j]);
		}
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

		Map mapDetail = new HashMap();
		for (int i = 0; i < equipmentSize; i++) {
			if (mapFlag.get(String.valueOf(i)) == null) {
				BgpHumanPrepareHumanDetail applyDetail = new BgpHumanPrepareHumanDetail();
				PropertiesUtil.msgToPojo("em" + String.valueOf(i), reqDTO,
						applyDetail);
				mapDetail = PropertiesUtil.describe(applyDetail);

				mapDetail.put("prepare_no", preIn);
				mapDetail.put("spare1", "");// 否到岗，接收后将改为1到岗
				mapDetail.put("bsflag", "0");
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modifi_date", new Date());

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"bgp_human_prepare_human_detail");
				// 调配单保存：人员状态 为不在项目 person_status='0';调配状态改为1调配中;是否到岗spare6为空;
				String sql = "update comm_human_employee_hr set person_status='0', deploy_status='1' ,spare6='', modifi_date = sysdate where employee_id ='"
						+ mapDetail.get("employee_id") + "'";
				jdbcDao.executeUpdate(sql);

			}
		}
		String infoKeyValue = preIn;
		String busKey = "humanPrepare";// 默认普通调配
		if ("2".equals(function)) {
			busKey = "reliefPrepare";// 调剂调配
		} else if ("3".equals(function)) {
			busKey = "professionPrepare";// 专业化调配
		}

		return responseDTO;
	}

	/**
	 * 改变调配单中人员的调配状态
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteHumanPrepareFlag(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		String prepareNo = reqDTO.getValue("prepareNo");
		String func = reqDTO.getValue("func");

		String huamnStr = "  select t.employee_id"
				+ "  from bgp_human_prepare_human_detail t"
				+ "  inner join bgp_human_prepare r on t.prepare_no = r.prepare_no and r.bsflag='0' "
				+ "  left join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag='0'"
				+ "  where t.prepare_no='" + prepareNo + "' union all     select     t.labor_id as employee_id        from bgp_comm_human_labor_deploy t      left join bgp_comm_human_deploy_detail d2    on t.labor_deploy_id = d2.labor_deploy_id        and d2.bsflag = '0'      left join bgp_comm_human_labor l        on t.labor_id = l.labor_id      left join comm_coding_sort_detail d3     on d2.apply_team = d3.coding_code_id       left join comm_coding_sort_detail d4     on d2.post = d4.coding_code_id    where t.bsflag = '0'    and t.spare1 ='" + prepareNo + "' ";

		List humanInfoList = BeanFactory.getQueryJdbcDAO().queryRecords(
				huamnStr);
		if (humanInfoList != null && humanInfoList.size() > 0) {
			for (int i = 0; i < humanInfoList.size(); i++) {
				Map humanMap = (Map) humanInfoList.get(i);
				// 调配单删除回到初始状态：人员状态 为不在项目person_status=0
				// ;调配状态改为已调配deploy_status='2';是否到岗为否spare6='0';
				String sql = "update comm_human_employee_hr set person_status='',deploy_status='' ,spare6='', modifi_date = sysdate , relief_org ='' where employee_id ='"
						+ humanMap.get("employeeId") + "'";
				jdbcDao.executeUpdate(sql);
				
				String sql2 = "update BGP_COMM_HUMAN_LABOR set spare1='0',if_project='0' , modifi_date = sysdate  where labor_id ='"
					+ humanMap.get("employeeId") + "'";
				jdbcDao.executeUpdate(sql2);
			
			}
		}

		return responseDTO;
	}

	/**
	 *  如果调配岗位中的申请人数和临时工人数相等,那么单据为已调配
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg submitHumanPrepare(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String requirementStr = "select *  from (select r.requirement_no,r.project_info_no, pr.prepare_no, nvl(pr.prepare_status, '0') prepare_status  from bgp_project_human_requirement r  join gp_task_project p  on r.project_info_no = p.project_info_no  and p.bsflag = '0'  left join bgp_human_prepare pr  on r.requirement_no = pr.requirement_no  and pr.bsflag = '0'  left join common_busi_wf_middle te  on te.business_id = pr.prepare_no  and te.business_type = '5110000004100000020'  and te.bsflag = '0'  left join common_busi_wf_middle te1  on te1.business_id = r.requirement_no  and te1.business_type in  ('5110000004100000021', '5110000004100001055')  and te1.bsflag = '0'  left join comm_org_information i  on r.apply_company = i.org_id  and i.bsflag = '0'  left join comm_org_subjection cosb  on i.org_id = cosb.org_id  and cosb.bsflag = '0'             where r.bsflag = '0'  and cosb.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'  and te1.proc_status = '3'  union all  select r.requirement_no, r.project_info_no, pr.prepare_no,  nvl(pr.prepare_status, '0') prepare_status  from bgp_project_human_requirement r  join gp_task_project p  on r.project_info_no = p.project_info_no  and p.bsflag = '0'  left join bgp_human_prepare pr  on r.requirement_no = pr.requirement_no  and pr.bsflag = '0'  left join common_busi_wf_middle te  on te.business_id = pr.prepare_no  and te.business_type = '5110000004100000020'  and te.bsflag = '0'  left join comm_org_information i  on r.apply_company = i.org_id  and i.bsflag = '0'  left join comm_org_subjection cosb  on i.org_id = cosb.org_id  and cosb.bsflag = '0'   where r.bsflag = '0'  and cosb.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'  and r.notes = '1') t  where t.prepare_status = '0' ";
		List requirementList = BeanFactory.getQueryJdbcDAO().queryRecords(
				requirementStr);
		if (requirementList != null && requirementList.size() > 0) {
			for (int i = 0; i < requirementList.size(); i++) {
				Map requirementMap = (Map) requirementList.get(i);
				String detailStr="select nvl(sum(p.people_number),0) p_number, nvl(sum(p.audit_number),0) a_number  from bgp_project_human_post p  where p.requirement_no = '"+requirementMap.get("requirementNo")+"'   and p.bsflag = '0'";
				List detailList = BeanFactory.getQueryJdbcDAO().queryRecords(detailStr); 
				if (detailList != null && detailList.size() > 0) {
					Map detailMap = (Map) detailList.get(0);
					int p_number=Integer.parseInt(detailMap.get("pNumber").toString());
					int a_number=Integer.parseInt(detailMap.get("aNumber").toString());
					if(p_number == a_number){  
					//	String sql = "update bgp_human_prepare t set t.prepare_status='2' ,t.modifi_date = sysdate  where  t.prepare_no ='"	+ requirementMap.get("prepareNo") + "' ";
						//jdbcDao.executeUpdate(sql);

						BgpHumanPrepare preparePojo = new BgpHumanPrepare();
						PropertiesUtil.msgToPojo("pre", reqDTO, preparePojo);
						Map prepare = new HashMap();
						prepare = PropertiesUtil.describe(preparePojo);  
						prepare.put("requirement_no", requirementMap.get("requirementNo"));
						prepare.put("project_info_no", requirementMap.get("projectInfoNo"));
						prepare.put("deploy_date", new Date());
						prepare.put("bsflag", "0");
						prepare.put("updator", user.getEmpId());
						prepare.put("modifi_date", new Date());
						prepare.put("prepare_status", "2");
						prepare.put("notes", "detailAdd");
						// 主表bgp_human_prepare主键值保存值
						prepare.put("applicant_id", user.getEmpId()); 
						String prepareId = EquipmentAutoNum.generateNumberByUserToken(
							reqDTO.getUserToken(), "RPTP"); 
							prepare.put("creator", user.getEmpId());
							prepare.put("create_date", new Date());
							prepare.put("prepare_id", prepareId);
							Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(
									prepare, "bgp_human_prepare");
							  
					}
					
				}
				
			}
		}	
		return responseDTO;
	}
	/**
	 * 改变调配单中人员的调配状态
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg changeHumanPrepareFlag(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);

		String prepareNo = reqDTO.getValue("prepareNo");
		String func = reqDTO.getValue("func");
		String applyCompany = reqDTO.getValue("applyCompany");

		String sqlSta = "update bgp_human_prepare set prepare_status='2' where prepare_no ='"
				+ prepareNo + "'";
		jdbcDao.executeUpdate(sqlSta);

		String huamnStr = "  select t.employee_id,t.team,t.work_post from bgp_human_prepare_human_detail t "
				+ "  inner join bgp_human_prepare r on t.prepare_no = r.prepare_no and r.bsflag='0' "
				+ "  left join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag='0'"
				+ "  where t.prepare_no='" + prepareNo + "'";

		List humanInfoList = BeanFactory.getQueryJdbcDAO().queryRecords(
				huamnStr);
		if (humanInfoList != null && humanInfoList.size() > 0) {
			for (int i = 0; i < humanInfoList.size(); i++) {
				Map humanMap = (Map) humanInfoList.get(i);
				// 调配单提交：人员状态 为不在项目person_status=0
				// ;调配状态改为已调配deploy_status='2';是否到岗为否spare6='0';
				StringBuffer sb = new StringBuffer(
						"update comm_human_employee_hr set person_status='0',deploy_status='2',spare6='0', modifi_date = sysdate, ");
				sb.append("relief_org ='").append(applyCompany).append(
						"',set_team='").append(humanMap.get("team")).append(
						"', ").append("set_post ='").append(
						humanMap.get("workPost")).append("' ").append(
						"where employee_id ='").append(
						humanMap.get("employeeId")).append("' ");

				jdbcDao.executeUpdate(sb.toString());
			}
		}

		return responseDTO;
	}
	
	
	/**
	 * 查询人员接收和返还的数据
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryHumanAcceptAndReturn(ISrvMsg reqDTO) throws Exception {

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = user.getOrgSubjectionId();
		
		String currentPage = reqDTO.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = reqDTO.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		int currentPage2 = Integer.parseInt(currentPage);
		int pageSize2 = Integer.parseInt(pageSize);
		int rowStart = (currentPage2 - 1) * pageSize2;
		int rowEnd = currentPage2 * pageSize2;
		

		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String taskId = reqDTO.getValue("taskId");
		String yorn = reqDTO.getValue("yorn");
		String flieName = reqDTO.getValue("flieName");




		StringBuffer sql = new StringBuffer(
				" select d.human_detail_no ,    d.work_post,d.team,    h.employee_id,     '' labor_deploy_id,    h.employee_cd,     '' employee_id_code_no,     e.employee_name,    p.project_info_no, cd.coding_name team_name,  cd2.coding_name work_post_name,        d.actual_start_date as start_date ,d.actual_end_date as end_date  ");
	 
		sql.append(" from bgp_human_prepare_human_detail d ");
		sql.append(" inner join bgp_human_prepare p on d.prepare_no = p.prepare_no  ");
		sql.append(" left join bgp_project_human_relation r on d.employee_id = r.employee_id  and p.project_info_no = r.project_info_no and r.team=d.team and r.work_post=d.work_post ");

		if (orgSubjectionId != null && orgSubjectionId.length() > 6 && orgSubjectionId.substring(0, 7).startsWith("C105006")) {
			sql.append(" left join bgp_project_human_profess pr on pr.profess_no=p.profess_no and p.profess_no is not null and pr.bsflag='0' ");
			sql.append(" left join comm_org_subjection su on pr.apply_company=su.org_id ");
		} else {
			sql.append(" left join bgp_project_human_requirement pr on pr.requirement_no=p.requirement_no and p.requirement_no is not null and pr.bsflag='0'  ");
			sql.append(" left join comm_org_subjection su on pr.apply_company=su.org_id ");
			sql.append(" left join bgp_project_human_relief re on re.human_relief_no=p.human_relief_no and p.human_relief_no is not null and re.bsflag='0'  ");
			sql.append(" left join comm_org_subjection su1 on re.apply_company=su1.org_id ");
		}
		sql.append(" left join comm_human_employee e on d.employee_id = e.employee_id ");
		sql.append(" left join comm_human_employee_hr h on d.employee_id = h.employee_id ");
		sql.append(" left join gp_task_project t on p.project_info_no = t.project_info_no ");
		sql.append(" left join bgp_comm_human_receive_process sp on t.project_info_no = sp.project_info_no  ");
		sql.append(" left join comm_coding_sort_detail cd on d.team = cd.coding_code_id ");
		sql.append(" left join comm_coding_sort_detail cd2 on d.work_post = cd2.coding_code_id ");
		sql.append(" left join comm_coding_sort_detail cd3 on r.project_evaluate = cd3.coding_code_id  ");
		sql.append(" where p.bsflag = '0' and d.bsflag='0' ").append(" and p.project_info_no = '").append(projectInfoNo).append("' ");
 
		if (orgSubjectionId != null && orgSubjectionId.length() > 6 && orgSubjectionId.substring(0, 7).startsWith("C105006")) {
			sql.append(" and su.org_subjection_id like '").append(orgSubjectionId)
					.append("%' and p.requirement_no is null and p.human_relief_no is null  and p.proc_status='3' ");
		} else {
			sql.append(" and (su.org_subjection_id like '").append(orgSubjectionId).append("%' or su1.org_subjection_id like '")
					.append(orgSubjectionId).append("%') ");
			sql.append(" and (p.spare2='2' or p.spare2 is null )");
			sql.append(" and p.profess_no is null ");
		}
		if(flieName !=null){			
			sql.append(" and e.employee_name like '%").append(flieName).append("%' ");			
		}
		// 已接收
		if (yorn == "1" || "1".equals(yorn)) {
			sql.append("and d.actual_start_date is not null ");
		}
		// 未接收
		if (yorn == "2" || "2".equals(yorn)) {
			sql.append("and d.actual_start_date is null ");
		}
		// 已返还
		if (yorn == "3" || "3".equals(yorn)) {
			sql.append("and d.actual_end_date is not null and d.spare2='1' ");
		}
		// 未返还
		if (yorn == "4" || "4".equals(yorn)) {
			sql.append("and d.actual_start_date is not null and (d.spare2 = '0' or d.spare2 is null) ");
		}
		// 未报到
		if (yorn == "5" || "5".equals(yorn)) {
			sql.append(" and d.spare1 = '0'  ");
		} else {
			sql.append(" and (d.spare1 is null or d.spare1='1' )");
		}

		sql.append("  union   select d2.deploy_detail_id , d2.post as work_post,   d2.apply_team as team,  t.labor_id as employee_id,   t.labor_deploy_id,    '' employee_cd,     l.employee_id_code_no,   l.employee_name, t.project_info_no,     d3.coding_name team_name,     d4.coding_name work_post_name,     t.start_date,    t.end_date  from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2 on t.labor_deploy_id = d2.labor_deploy_id and d2.bsflag='0'  left join bgp_comm_human_labor l on t.labor_id = l.labor_id   left join comm_coding_sort_detail d3 on d2.apply_team = d3.coding_code_id   left join comm_coding_sort_detail d4 on d2.post = d4.coding_code_id  where t.bsflag = '0' and t.project_info_no ='").append(projectInfoNo).append("'  and t.end_date is null ");
		if(flieName !=null){			
			sql.append(" and l.employee_name like '%").append(flieName).append("%' ");			
		}
//		List<Map> list = jdbcDAO.queryRecords(sql.toString());
//		if (list != null) {
//			responseMsg.setValue("humanMap", list);
//		}


		System.out.println(sql.toString());
		StringBuffer humanSql = new StringBuffer();
		humanSql.append("select * from (select datas.*,rownum rownum_ from (");
		humanSql.append(sql.toString());
		humanSql.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
		
		List datas=BeanFactory.getQueryJdbcDAO().queryRecords(humanSql.toString());

		humanSql = new StringBuffer();
		humanSql.append("select count(1) count from ( ");
		humanSql.append(sql.toString()).append(")");
																								
		String totalRows = "0";
		Map countMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(humanSql.toString());
		if (countMap != null) {
			totalRows = (String) countMap.get("count");
			if (totalRows == null || totalRows.equals(""))
				totalRows = "0";
		}

		msg.setValue("datas", datas);
		msg.setValue("totalRows", totalRows);

		int total = Integer.parseInt(totalRows);
		int pageCount = total / pageSize2;
		pageCount += ((total % pageSize2) == 0 ? 0 : 1);

		msg.setValue("pageCount", pageCount);
		msg.setValue("pageSize", pageSize);
		msg.setValue("currentPage", currentPage);
		
		return msg;
	}
	
	/**
	 * 岗位变更新增及修改
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings( { "unchecked", "rawtypes" })
	public ISrvMsg getHumanPositionInfo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();

		String employeeId = reqDTO.getValue("employeeId");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");

		String sql = "select distinct t.EMPLOYEE_ID,t.EMPLOYEE_NAME,t.ACTUAL_START_DATE,t.ACTUAL_END_DATE,t.TEAM,t.WORK_POST,d1.coding_name team_name,d2.coding_name work_post_name,t.EMPLOYEE_GZ,d3.coding_name employee_gz_name  from view_human_project_relation t  left join comm_coding_sort_detail d1 on t.team = d1.coding_code_id  left join comm_coding_sort_detail d2 on t.work_post = d2.coding_code_id left join comm_coding_sort_detail d3 on t.EMPLOYEE_GZ=d3.coding_code_id where t.project_info_no =  '"+projectInfoNo+"' and t.employee_id =  '"+employeeId+"' and t.actual_start_date is not null and  t.actual_end_date is null order by t.EMPLOYEE_GZ,t.EMPLOYEE_NAME ";

		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		StringBuffer sb = new StringBuffer("SELECT pc.position_no,pc.team,pc.work_post,pc.evaluation, d3.coding_name team_name, ");
		sb.append(" d4.coding_name work_post_name, pc.actual_start_date, pc.actual_end_date,d1.coding_name evaluation_name ");
		sb.append(" FROM bgp_human_position_change pc ");
		sb.append(" left join comm_coding_sort_detail d1 on pc.evaluation = d1.coding_code_id ");
		sb.append(" left join comm_coding_sort_detail d3 on pc.team = d3.coding_code_id ");
		sb.append(" left join comm_coding_sort_detail d4 on pc.work_post = d4.coding_code_id ");
		sb.append(" where pc.bsflag = '0'  and pc.project_info_no = '").append(projectInfoNo).append("'");
		sb.append(" and pc.employee_id ='").append(employeeId).append("'  order by pc.actual_start_date ");
		
				
		List listPosition = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
				
		
		responseDTO.setValue("employeeId", employeeId);
		responseDTO.setValue("projectInfoNo", projectInfoNo);
		responseDTO.setValue("map", map);
		responseDTO.setValue("listPosition", listPosition);

		return responseDTO;
	}
	
	
	
	public ISrvMsg queryImportTrainList(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO); 
		String checked = reqDTO.getValue("checked");
		checked = URLDecoder.decode(checked, "utf-8");
		checked = URLDecoder.decode(checked, "utf-8");
		StringBuffer newstr = new StringBuffer();
		
		String str = "";
		if (checked != null && !"".equals(checked)) {
			String[] check = checked.split(",");
			for (int i = 0; i < check.length; i++) {
				String[] mes = check[i].split("@");
                if(!"".equals(mes[1]) || !"".equals(mes[2]) ){ 
					newstr.append("@").append(mes[1]);
					newstr.append("@").append(mes[2]);
					newstr.append("@").append(mes[3]);
					newstr.append("@").append(mes[4]);
					newstr.append("@").append(mes[5]);
					newstr.append("@").append(mes[6]);
					newstr.append("@").append(mes[7]);
					newstr.append("@").append(mes[8]);
					newstr.append("@").append(mes[9]);
					newstr.append("@").append(mes[10]); 
					newstr.append(",");
				}else{
					str+="第"+(i+1)+"行红色标注不能为空!\n";
				}

			}
		}

		if (newstr != null) {
			responseDTO.setValue("newstr", newstr.toString());
		}
		if (str != null && !"".equals(str)) {
			responseDTO.setValue("str", str);
		}
		return responseDTO;
	}
	
	
	
}