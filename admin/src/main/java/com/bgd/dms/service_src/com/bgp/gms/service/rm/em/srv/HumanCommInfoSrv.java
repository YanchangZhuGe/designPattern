package com.bgp.gms.service.rm.em.srv;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serializable;
import java.net.URLDecoder;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.swing.JOptionPane;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import net.sf.json.JSONArray;

import com.bgp.gms.service.op.srv.OPCostSrv;
import com.bgp.gms.service.op.util.OPCommonUtil;
import com.bgp.gms.service.rm.em.pojo.BgpCommHumanAllocateTaskA;
import com.bgp.gms.service.rm.em.pojo.BgpCommHumanCertificate;
import com.bgp.gms.service.rm.em.pojo.BgpCommHumanCostDetail;
import com.bgp.gms.service.rm.em.pojo.BgpCommHumanCostreport;
import com.bgp.gms.service.rm.em.pojo.BgpCommHumanReceiveLabor;
import com.bgp.gms.service.rm.em.pojo.BgpCommHumanReceiveProcess;
import com.bgp.gms.service.rm.em.pojo.BgpHumanPrepare;
import com.bgp.gms.service.rm.em.pojo.BgpHumanPrepareHumanDetail;
import com.bgp.gms.service.rm.em.pojo.BgpHumanPreparePostDetail;
import com.bgp.gms.service.rm.em.pojo.BgpProjectHumanProfess;
import com.bgp.gms.service.rm.em.pojo.BgpProjectHumanProfessDeta;
import com.bgp.gms.service.rm.em.pojo.BgpProjectHumanProfessPost;
import com.bgp.gms.service.rm.em.pojo.BgpProjectHumanRelief;
import com.bgp.gms.service.rm.em.pojo.BgpProjectHumanReliefDeta;
import com.bgp.gms.service.rm.em.pojo.BgpProjectHumanReliefdetail;
import com.bgp.gms.service.rm.em.util.EquipmentAutoNum;
import com.bgp.gms.service.rm.em.util.HumanAcceptResourceAssignment;
import com.bgp.gms.service.rm.em.util.PropertiesUtil;
import com.bgp.mcs.service.common.CodeSelectOptionsUtil;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.rm.em.humanRequired.pojo.BgpProjectHumanRelation;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.DataPermission;
import com.cnpc.jcdp.common.IDataPermProcessor;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
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
 * creator: 林彦博
 * 
 * creator time:2010-5-26
 * 
 * description:人力支持平台人员信息查看,人员技能查看
 * 
 */
public class HumanCommInfoSrv extends BaseService {
	

	private static final String[] selectName = { "hrAgeOps", "hrDegreeOps","workYearOps" };
	private static final String eqServOrg = "C6000000005565,C6000000005566,C6000000005567,C6000000005568,C6000000005569,C6000000000042";//仪器物探处下的单位 C6000000005809,wangtaikun用户专用属于装备仪器中心下的项目服务部
	
	
	
	/**
	 * 进入人力成本
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg humanCostPlanView(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		String keyId = reqDTO.getValue("id");
		
		if (keyId == null || "".equals(keyId)) {
			Map map = new HashMap();
			map.put("applicantName", user.getUserName());
			map.put("applicantId", user.getEmpId());
			map.put("applicantOrgName", user.getOrgName());
			map.put("applyCompany", user.getOrgId());
			String applyDate = new SimpleDateFormat("yyyy-MM-dd")
					.format(new Date());
			map.put("applyDate", applyDate);

			
			responseDTO.setValue("applyInfo", map);
			
		} else {

			Map map = new HashMap();
			StringBuffer sb = new StringBuffer(" select r.profess_no,r.project_info_no,t.project_name, ");
			sb.append(" r.apply_company, to_char(r.apply_date,'yyyy-MM-dd') apply_date,r.applicant_id, ");
			sb.append(" r.apply_no,r.apply_state,r.notes,");
			sb.append(" t1.org_name applicant_org_name,t2.employee_name applicant_name ");
			sb.append(" from bgp_project_human_profess r ");
			sb.append(" left join gp_task_project t on r.project_info_no = t.project_info_no and r.bsflag = '0' ");
			sb.append(" left join comm_org_information t1 on r.apply_company = t1.org_id and t1.bsflag = '0' ");
			sb.append(" left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0' ");
			sb.append(" where r.profess_no='").append(keyId).append("' ");
		
			map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
			responseDTO.setValue("applyInfo", map);
			
			// 查询子表信息
			StringBuffer subsql = new StringBuffer(" select p.post_no,p.notes, ");
			subsql.append(" p.people_num,p.own_num,p.deploy_num, ");					
			subsql.append(" p.age,p.culture,p.work_years,p.apply_team,p.post,p.plan_start_date, ");
			subsql.append(" p.plan_end_date,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname ");
			subsql.append(" from bgp_project_human_profess_post p");
			subsql.append(" inner join bgp_project_human_profess r ").append("on p.profess_no= r.profess_no ");
			subsql.append(" left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
			subsql.append(" left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");					
			subsql.append(" where p.bsflag='0' and p.profess_no='").append(keyId).append("' order by p.apply_team,p.post ");
	
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
			responseDTO.setValue("detailInfo", list);
			
			//专业化人员查询分解表
			StringBuffer querySub = new StringBuffer(" select d.post_detail_no,d.apply_team,d.post,d.people_number,d.deploy_org,d.competence,d.age,d.notes, ");
			querySub.append(" d.work_years,d.work_trade_years,d.culture,d.plan_start_date,d.plan_end_date,t1.org_name deploy_org_name,  ");
			querySub.append(" nvl(d3.coding_name,d.culture) culture_name,d1.coding_name postname, d2.coding_name apply_teamname ");
			querySub.append(" from bgp_project_human_profess_deta d ");
			querySub.append(" inner join bgp_project_human_profess_post p on d.post_no = p.post_no and p.bsflag='0' ");
			querySub.append(" inner join bgp_project_human_profess f on p.profess_no=f.profess_no and f.bsflag='0' ");
			querySub.append(" left join comm_org_information t1 on d.deploy_org = t1.org_id ");
			querySub.append(" left join comm_coding_sort_detail d1 on d.post = d1.coding_code_id ");
			querySub.append(" left join comm_coding_sort_detail d2 on d.apply_team = d2.coding_code_id ");
			querySub.append(" left join comm_coding_sort_detail d3 on d.culture = d3.coding_code_id ");
			querySub.append(" where d.bsflag='0' and f.profess_no='").append(keyId).append("' ");
			
			List sublist = BeanFactory.getQueryJdbcDAO().queryRecords(querySub.toString());
			responseDTO.setValue("subDetailInfo", sublist);

		}
		return responseDTO;
	}
	
	/**
	 * 人力成本 保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg savehumanCostPlan(ISrvMsg reqDTO) throws Exception {
		
		String isPass = reqDTO.getValue("isPass");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if(isPass !=null && "pass".equals(isPass)){
		
			UserToken user = reqDTO.getUserToken();
			
			String[] hidEDetailId = {};
			if (reqDTO.getValue("hidEDetailId") != null) {
				hidEDetailId = reqDTO.getValue("hidEDetailId").split(",");
			}
			for (int j = 0; j < hidEDetailId.length; j++) {
				BeanFactory.getPureJdbcDAO().deleteEntity(
						"bgp_project_human_profess_deta", hidEDetailId[j]);
			}
			int equipmentESize = Integer.parseInt(reqDTO.getValue("equipmentESize"));
			String deleteERowFlag = reqDTO.getValue("deleteERowFlag");
			String[] rowEFlag = null;
			Map mapEFlag = new HashMap();
			if (deleteERowFlag != null && !deleteERowFlag.equals("")) {
				rowEFlag = deleteERowFlag.split(",");
				for (int i = 0; i < rowEFlag.length; i++) {
					mapEFlag.put(rowEFlag[i], "true");
				}
			}
			
			Map mapEDetail = new HashMap();
			for (int i = 0; i < equipmentESize; i++) {		
				if (mapEFlag.get(String.valueOf(i)) == null) {
				BgpProjectHumanProfessDeta applyEDetail = new BgpProjectHumanProfessDeta();
				PropertiesUtil.msgToPojo("em" + String.valueOf(i), reqDTO,
						applyEDetail);
				mapEDetail = PropertiesUtil.describe(applyEDetail);	
				
				if(eqServOrg.indexOf(mapEDetail.get("deploy_org").toString()) != -1){
					//待分配任务,,  待分配任务的  不能做调配   分配完的  和不用分配的可以做调配
					mapEDetail.put("deploy_flag", "0"); 
				}else{
					//不用分配任务
					mapEDetail.put("deploy_flag", "2");
				}
				mapEDetail.put("bsflag", "0");
				mapEDetail.put("creator", user.getEmpId());
				mapEDetail.put("create_date", new Date());
				mapEDetail.put("updator", user.getEmpId());
				mapEDetail.put("modifi_date", new Date());
	
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapEDetail,
							"bgp_project_human_profess_deta");
				}
				
			} 
		
		}			
		return responseDTO;
	}
	
	public ISrvMsg queryImportCertList(ISrvMsg reqDTO) throws Exception {
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

				StringBuffer sb = new StringBuffer("select e.employee_id, e.employee_name, i.org_id, i.org_name from comm_human_employee e  inner join comm_human_employee_hr h on e.employee_id=h.employee_id   left join comm_org_information i  on e.org_id = i.org_id ");
				sb.append(" where h.employee_cd ='").append(mes[1]).append("' ");
				Map sbMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());

				if (sbMap != null) {
					
					newstr.append(check[i]).append("@").append(sbMap.get("employeeId"));
					newstr.append("@").append(sbMap.get("employeeName"));
					newstr.append("@").append(sbMap.get("orgId"));
					newstr.append("@").append(sbMap.get("orgName"));
					newstr.append(",");
				}else{
					//str+="第"+(i+1)+"行人员不存在\n";
					str+="第"+(i+1)+"行人员不存在 , ";
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

	/**
	 * 资格证保存方法
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg saveCommHumanCertificate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();		
		MyUcm ucm = new MyUcm();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		
		String coding_code = reqDTO.getValue("coding_code");
		String coding_code_id = reqDTO.getValue("coding_code_id");

		int equipmentSize = Integer.parseInt(reqDTO.getValue("lineNum"));
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

				BgpCommHumanCertificate applyDetail = new BgpCommHumanCertificate();
				PropertiesUtil.msgToPojoEnd("_" + String.valueOf(i), reqDTO,
							applyDetail);
				mapDetail = PropertiesUtil.describe(applyDetail);
				
 			    mapDetail.put("coding_code", coding_code);
 			    mapDetail.put("coding_code_id", coding_code_id);
 			    mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modifi_date", new Date());
				mapDetail.put("bsflag", "0");
				
				for (int j = 0; fileList != null && j < fileList.size(); j++) {
					WSFile fs = fileList.get(j);
					if(fs.getKey().equals("documentId_"+i)){
						String documentId = ucm.uploadFile(fs.getFilename(),fs.getFileData());
						mapDetail.put("document_id", documentId);
						
						if(mapDetail.get("old_document_id")!=null && !"".equals(mapDetail.get("old_document_id"))){
							String old_document_id = (String)mapDetail.get("old_document_id");
							ucm.deleteFile(old_document_id);
						}
					}
					
				}
				
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"bgp_comm_human_certificate");
								
			}
		} 
		
		responseDTO.setValue("codingCode", coding_code);
		
		return responseDTO;
	}
	
	
	public ISrvMsg planTreeView(ISrvMsg reqDTO) throws Exception {
			
			ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
			
			UserToken user = reqDTO.getUserToken();
			
			String projectInfoNo = user.getProjectInfoNo();
			
			if(projectInfoNo == null || "".equals(projectInfoNo)){
				projectInfoNo = "8a9588b63618fc0d01361a93e0bf0018";
			}
			
			String wbsBackUrl = "/rm/em/singleHuman/humanPlan/wbsPlanList.jsp";
			String taskBackUrl = "/rm/em/singleHuman/humanPlan/taskPlanList.jsp";
			String rootBackUrl = "/rm/em/singleHuman/humanPlan/rootPlanList.jsp";
			
			msg.setValue("projectInfoNo", projectInfoNo);
			msg.setValue("wbsBackUrl", wbsBackUrl);
			msg.setValue("taskBackUrl", taskBackUrl);
			msg.setValue("rootBackUrl", rootBackUrl);
			
			return msg;
	}
	/**
	 * 查询人员列表包括本单位和调配到本单位的人员
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCommHumanInfo1(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String params = reqDTO.getValue("params");
//		if (params != null && !params.equals("")) {
//			params = URLDecoder.decode(params, "UTF-8");
//		}

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

//		String funcCode = reqDTO.getValue("funcCode");
		String funcCode = "F_DOC_ADDDOC_001";
		IDataPermProcessor dpProc = (IDataPermProcessor) BeanFactory.getBean("ICGDataPermProcessor");
		// 得到过滤后的sql查询可查看的人员id
		StringBuffer sb = new StringBuffer();
		DataPermission dp = dpProc
				.getDataPermission(
						user,
						funcCode,
						"select hr.employee_cd,e.employee_id,e.org_id,e.employee_name,e.employee_birth_date, e.employee_gender,hr.work_date, hr.post, hr.post_level, e.employee_education_level,hr.spare2,hr.deploy_status, hr.person_status from comm_human_employee e inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' where e.bsflag = '0'"
								+ params);
		DataPermission rdp = dpProc
				.getDataPermission(
						user,
						funcCode,
						"select e.employee_id, hr.relief_org org_id, hr.employee_cd,e.employee_name,e.employee_birth_date,e.employee_gender, hr.work_date, hr.post, hr.post_level, e.employee_education_level,hr.spare2,hr.deploy_status, hr.person_status from comm_human_employee e inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' where e.bsflag = '0' and hr.relief_org is not null"
								+ params);
		sb.append("select distinct c.employee_cd,c.employee_id,c.org_id,c.employee_name,c.employee_birth_date, c.employee_gender,c.work_date, c.post, c.post_level, c.employee_education_level,c.spare2,c.deploy_status,c.person_status from ( ");
		sb.append(
				"select a.employee_cd,a.employee_id,a.org_id,a.employee_name,a.employee_birth_date, a.employee_gender,a.work_date, a.post, a.post_level, a.employee_education_level,a.spare2,a.deploy_status, a.person_status from (")
				.append(dp.getFilteredSql()).append(") a union ");
		sb.append(
				"select b.employee_cd,b.employee_id,b.org_id,b.employee_name,b.employee_birth_date, b.employee_gender,b.work_date, b.post, b.post_level, b.employee_education_level,b.spare2,b.deploy_status, b.person_status from (")
				.append(rdp.getFilteredSql()).append(") b ) c ");

		StringBuffer humanSql = new StringBuffer();
		humanSql.append("select * from (select datas.*,rownum rownum_ from (");
		humanSql.append("select hrtemp.employee_cd,hrtemp.employee_id,hrtemp.org_id,hrtemp.employee_name,decode(hrtemp.employee_gender, '0', '女', '1', '男') employee_gender_name,(to_char(sysdate, 'YYYY') - to_char(hrtemp.employee_birth_date, 'YYYY')) age, hrtemp.work_date,i.org_name, hrtemp.post, hrtemp.post_level, d1.coding_name post_level_name,hrtemp.employee_education_level, d2.coding_name employee_education_level_name,hrtemp.spare2 ");
		humanSql.append("from (").append(sb).append(") hrtemp ");
		humanSql.append("left join comm_org_information i on hrtemp.org_id = i.org_id and i.bsflag = '0'   left join comm_coding_sort_detail d1 on hrtemp.post_level =  d1.coding_code_id and d1.bsflag = '0'   left join comm_coding_sort_detail d2 on hrtemp.employee_education_level = d2.coding_code_id and d2.bsflag = '0' ");
		humanSql.append(" order by hrtemp.org_id ");
		humanSql.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);

		List datas = BeanFactory.getQueryJdbcDAO().queryRecords(humanSql.toString());

		humanSql = new StringBuffer();
		humanSql.append("select count(1) count from ( ");
		humanSql.append(sb).append(")");

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

	
	public ISrvMsg queryCommHumanInfo(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		String orgSubId = reqDTO.getValue("orgSubId");
				
		StringBuffer humanSql = new StringBuffer(
				"select t.*,rownum from ( select hr.employee_cd, e.employee_id, e.org_id, e.employee_name, decode(e.employee_gender, '0', '女', '1', '男') employee_gender_name, (to_char(sysdate, 'YYYY') - to_char(e.employee_birth_date, 'YYYY')) age, hr.work_date, i.org_abbreviation org_name, hr.post, hr.post_level, d1.coding_name post_level_name, e.employee_education_level, d2.coding_name employee_education_level_name, s.org_subjection_id,e.modifi_date,hr.home_address,hr.qq,hr.e_mail from ");
		humanSql.append("  comm_human_employee e inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id left join comm_org_subjection s on e.org_id = s.org_id and s.bsflag = '0' left join comm_org_information i on e.org_id = i.org_id and i.bsflag = '0' left join comm_coding_sort_detail d1 on hr.post_level = d1.coding_code_id and d1.bsflag = '0' left join comm_coding_sort_detail d2 on e.employee_education_level = d2.coding_code_id and d2.bsflag = '0'  ");
		humanSql.append("  where e.bsflag = '0' and hr.bsflag='0' and s.org_subjection_id like '").append(orgSubId).append("%' order by e.modifi_date desc ) t ");

		List datas = BeanFactory.getQueryJdbcDAO().queryRecords(humanSql.toString());
		
		StringBuffer numSql = new StringBuffer();
		numSql.append("select count(1) count from ( ");
		numSql.append(humanSql).append(")");

		String totalRows = "0";
		Map countMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(numSql.toString());
		if (countMap != null) {
			totalRows = (String) countMap.get("count");
			if (totalRows == null || totalRows.equals(""))
				totalRows = "0";
		}

		msg.setValue("datas", datas);
		msg.setValue("totalRows", totalRows);

		int total = Integer.parseInt(totalRows);

		msg.setValue("pageCount", 1);
		msg.setValue("pageSize", total);
		msg.setValue("currentPage", 1);
		
		return msg;
	}
	/**
	 * 人员基本信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCommInfo(ISrvMsg reqDTO) throws Exception {
		
		String employeeId = reqDTO.getValue("employeeId");
		String hrId = reqDTO.getValue("hrId");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer employee = new StringBuffer("select h.* ,   nvl(d11.coding_name, h.set_team) set_team_name,    nvl(d12.coding_name, h.set_post) set_post_name  from ( select e.employee_id,e.bsflag,h.employee_cd, e.employee_name, ");
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
	//	employee.append("e.employee_id_code_no,nvl(d11.coding_name,h.set_team) set_team_name, nvl(d12.coding_name,h.set_post) set_post_name,");
		employee.append("e.employee_id_code_no, nvl(phr.work_post,  h.set_post) set_post,  nvl(phr.team, h.set_team) set_team, ");
		
		employee.append("decode(h.spare7,'0','一线员工','1','境外一线','2','二线员工','4','三线员工','3','境外二三线','') spare7,h.spare2,h.home_address,h.qq,h.e_mail,decode(h.household_type,'0','农业','1','非农业') household_type, ");
		employee.append(" decode(h.person_status,'0','不在项目','1','在项目','不在项目') person_status_name,decode(h.institutions_type,'0','境外项目','1','总部机关') institutions_type,h.grass_root_unit,h.go_abroad_time,h.home_time,nvl(d13.coding_name,h.present_state) present_state_name,h.now_start_date,h.implementation_date, ");
		employee.append("h.account_place,h.start_salary_date,h.technical_time,h.post_sequence,h.post_exam,h.toefl_score,h.tofel_listening,decode(h.if_qualified,'0','是','1','否') if_qualified,h.nine_result, ");
		employee.append(" decode(h.if_qualifieds,'0','是','1','否') if_qualifieds,h.holds_result,h.pin_whether,h.pin_unit,pin2.org_hr_short_name as pin_unit_name  "); 
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
		employee.append("left join comm_coding_sort_detail d13 on h.present_state = d13.coding_code_id  ");
		employee.append("left join comm_org_subjection pin on h.pin_unit = pin.org_subjection_id and pin.bsflag = '0' ");
		employee.append("left join bgp_comm_org_hr_gms pin1 on pin1.org_gms_id=pin.org_id    left join  bgp_comm_org_hr pin2 on pin2.org_hr_id=pin1.org_hr_id ");	
		employee.append(" left join   (    select d2.*  from (select d1.*  from (   select hr.team,hr.work_post,hr.employee_id,    hr.actual_start_date,    hr.actual_end_date , row_number() over(partition by hr.employee_id order by hr.actual_end_date  desc) numa  from bgp_project_human_relation hr      where hr.bsflag='0'  and hr.locked_if='1'  ) d1  where d1.numa = 1) d2   )  phr  on   e.employee_id= phr.employee_id  ");
		employee.append("   )h   left join comm_coding_sort_detail d11    on h.set_team = d11.coding_code_id  left join comm_coding_sort_detail d12    on h.set_post = d12.coding_code_id ");
		employee.append("where h.bsflag = '0' ");

		Map employeeMap = new HashMap();
		if(null != employeeId && !"".equals(employeeId)){
			employee.append("and h.employee_id='").append(employeeId).append("'");
			employeeMap = jdbcDAO.queryRecordBySQL(employee.toString());
		}else if(null != hrId && !"".equals(hrId)){
			employee.append("and h.employee_cd='").append(hrId).append("'");
			employeeMap = jdbcDAO.queryRecordBySQL(employee.toString());
		}
	
		if (employeeMap != null) {
			responseMsg.setValue("employeeMap", employeeMap);
		}

		if(employeeId==null || employeeId.equals("")){
			employeeId = (String)employeeMap.get("employee_id");
		}
		
		// 工作履历
		StringBuffer record = new StringBuffer(
				"select rownum ,r.record_no, r.employee_id,to_char( r.start_date,'yyyy-MM-dd') start_date,decode(to_char(r.end_date,'yyyy'),'9999','至今',to_char( r.end_date,'yyyy-MM-dd')) end_date, ");
		record.append("  r.company,r.administration,r.technology,r.skill,r.post,d1.coding_name skillname from bgp_comm_human_record r ");
		record.append("  left join comm_coding_sort_detail d1 on r.skill = d1.coding_code_id");
		record.append("  where r.bsflag='0' and r.employee_id ='").append(employeeId).append("' order by r.start_date desc ");

		List<Map> recordMap = jdbcDAO.queryRecords(record.toString());
	 
		if (recordMap != null && recordMap.size() > 0) {
			responseMsg.setValue("recordMap", recordMap);
		}

		// 培训信息
//		StringBuffer train = new StringBuffer("select  er.employee_name,ch.employee_id ,ch.employee_cd, tr.class_name,tr.train_content,SUBSTR(tr.train_start_date,0,10) train_start_date,decode(SUBSTR(tr.train_end_date,0,10),'9999-12-31',to_char(sysdate,'yyyy-MM-dd'), SUBSTR(tr.train_end_date,0,10) )train_end_date,tr.unit_level,tr.program_category,tr.train_form,tr.organizer,tr.train_address,tr.train_results from bgp_human_train_hr tr left join comm_human_employee_hr  ch on tr.employee_cd=ch.employee_cd  and ch.bsflag='0' left join comm_human_employee er on er.employee_id=ch.employee_id and er.bsflag='0'  where er.employee_id='").append(employeeId).append("'");
//		  
//		List<Map> trainMap = jdbcDAO.queryRecords(train.toString());
//
//		if (trainMap != null && trainMap.size() > 0) {
//			responseMsg.setValue("trainMap", trainMap);
//		}

		// 项目经历
		StringBuffer project = new StringBuffer(
				"  select re.relation_no,t.project_name,t.project_type,nvl(d3.coding_name,'井中地震') project_type_name ,to_char(nvl(re.plan_start_date,dl.plan_start_date),'yyyy-MM-dd') plan_start_date, ");
		project.append(" to_char(nvl(re.plan_end_date,dl.plan_end_date),'yyyy-MM-dd')plan_end_date, to_char(re.actual_start_date,'yyyy-MM-dd') actual_start_date, ");
		project.append(" to_char(re.actual_end_date,'yyyy-MM-dd') actual_end_date,re.team,re.work_post,d1.coding_name teamname,d2.coding_name postname,re.project_evaluate,d4.coding_name project_evaluate_name from bgp_project_human_relation re ");
		project.append("   left join  bgp_human_prepare_human_detail dl   on dl.employee_id=re.employee_id       and re.team = dl.team      and re.work_post = dl.work_post    and dl.bsflag = '0'  and dl.actual_start_date is not null and dl.actual_end_date is not null  and dl.plan_start_date is not null and dl.plan_end_date is not null       inner    join bgp_human_prepare pt            on dl.prepare_no = pt.prepare_no     and pt.prepare_status = '2'  and pt.bsflag='0'    and pt.project_info_no = re.project_info_no  left join gp_task_project t on re.project_info_no = t.project_info_no");
		project.append(" left join comm_coding_sort_detail d1 on re.team = d1.coding_code_id");
		project.append(" left join comm_coding_sort_detail d2 on re.work_post = d2.coding_code_id");
		project.append(" left join comm_coding_sort_detail d3 on t.project_type = d3.coding_code_id");
		project.append(" left join comm_coding_sort_detail d4 on re.project_evaluate = d4.coding_code_id");
		project.append(" where re.bsflag='0' and re.employee_id ='").append(employeeId).append("' and re.locked_if='1' union all ");
		//针对井中业务项目经历
		project.append(" select re.relation_no,t.project_name,t.project_type,nvl(d3.coding_name,'井中地震') project_type_name ,to_char(re.plan_start_date,'yyyy-MM-dd') plan_start_date, ");
		project.append(" to_char(re.plan_end_date,'yyyy-MM-dd')plan_end_date, to_char(re.actual_start_date,'yyyy-MM-dd') actual_start_date, ");
		project.append(" to_char(re.actual_end_date,'yyyy-MM-dd') actual_end_date,re.team,re.work_post,d1.coding_name teamname,d2.coding_name postname,re.project_evaluate,d4.coding_name project_evaluate_name from bgp_project_human_relation re ");
		project.append("  left join gp_task_project t on re.project_info_no = t.project_info_no");
		project.append(" left join comm_coding_sort_detail d1 on re.team = d1.coding_code_id");
		project.append(" left join comm_coding_sort_detail d2 on re.work_post = d2.coding_code_id");
		project.append(" left join comm_coding_sort_detail d3 on t.project_type = d3.coding_code_id");
		project.append(" left join comm_coding_sort_detail d4 on re.project_evaluate = d4.coding_code_id");
		project.append(" where re.bsflag='0' and re.employee_id ='").append(employeeId).append("' and re.locked_if='1'   and re.spare2='zi'  ");
		
		
		project.append("  union all  select t.ptdetail_id relation_no,   pt.project_name,  pt.project_type,  nvl(d3.coding_name, '井中地震') project_type_name, to_char(t.start_date,'yyyy-MM-dd')  plan_start_date ,to_char(t.end_date,'yyyy-MM-dd')   plan_end_date,  to_char(t.start_date,'yyyy-MM-dd')   actual_start_date,to_char(t.end_date,'yyyy-MM-dd')  actual_end_date, t.team_s team,t.post_s work_post ,t.team_name teamname ,t.work_post_name  postname , t.notes project_evaluate  ,    d4.coding_name project_evaluate_name  from BGP_COMM_HUMAN_PT_DETAIL t    left join gp_task_project pt   on t.bproject_info_no = pt.project_info_no      left join comm_coding_sort_detail d3    on pt.project_type = d3.coding_code_id  left join comm_coding_sort_detail d4    on t.notes  = d4.coding_code_id      where t.bsflag='0' and t.end_date is not null and t.employee_id = '").append(employeeId).append("'");
		
		List<Map> projectMap = jdbcDAO.queryRecords(project.toString());

		if (projectMap != null && projectMap.size() > 0) {
			responseMsg.setValue("projectMap", projectMap);
		}
		//教育经历
		StringBuffer education = new StringBuffer(
				"select to_char(t.start_date,'yyyy-MM-dd') start_date,to_char(t.finish_date,'yyyy-MM-dd') finish_date,t.school_name,t.profess,t.education from bgp_comm_human_education t ");
		education.append("where t.bsflag='0' and t.employee_id ='").append(employeeId).append("' order by t.start_date desc ");
		List<Map> educationMap = jdbcDAO.queryRecords(education.toString());

		if (educationMap != null && educationMap.size() > 0) {
			responseMsg.setValue("educationMap", educationMap);
		}
		//资格证信息
		
		StringBuffer certificate = new StringBuffer("select s.certificate_no,s.certificate_num,s.qualification_name, s.training_institutions, s.issuing_agency, s.issuing_date, s.validity,s.document_id from bgp_comm_human_certificate s ");
		certificate.append(" where s.bsflag = '0' and s.employee_id='").append(employeeId).append("' order by s.modifi_date asc");

		List<Map> certificateMap = jdbcDAO.queryRecords(certificate.toString());

		if (certificateMap != null && certificateMap.size() > 0) {
			responseMsg.setValue("certificateMap", certificateMap);
		}
		
		return responseMsg;
	}
	
	/**
	 * 根据人员的hrid得到hr的组织机构id
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHRDept(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		String hrId = reqDTO.getValue("hrId");
		
		if(hrId!=null && !hrId.trim().equals("")){
			IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

			StringBuilder sb = new StringBuilder();
			sb.append("select t1.org_hr_id from bgp_comm_org_hr_gms t1");
			sb.append(" join comm_human_employee t2 on t1.org_gms_id=t2.org_id");
			sb.append(" join comm_human_employee_hr t3 on t3.employee_id=t2.employee_id");
			sb.append(" and t3.employee_cd='").append(hrId).append("'");
			
			Map data = jdbcDAO.queryRecordBySQL(sb.toString());
			
			if(data!=null){
				responseMsg.setValue("dept_id", data.get("org_hr_id"));
			}
		}
		
		return responseMsg;
	}
	
	/**
	 * 保存人工成本计划主表
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanPlanCost(ISrvMsg reqDTO) throws Exception{
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		UserToken user = reqDTO.getUserToken();
		
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String costState = reqDTO.getValue("costState");
		String twoState = reqDTO.getValue("twoState");
		
		String sql = "select t.plan_id  from bgp_comm_human_plan_cost t where t.project_info_no='"+projectInfoNo+"' and t.cost_state='"+costState+"' and t.bsflag='0' ";
		
		if(twoState != null && !twoState.equals("")){ 
			sql+=" and t.spare5='1' ";
		}else{
			
			sql+=" and t.spare5 is null  ";
		}
		
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		String planId = "";

		if(map != null && map.get("planId")!= null ){
			//提交过，修改
			planId = (String) map.get("planId");

		}else{
			//未提交，新增
			
			Map mapDetail = new HashMap();	

			mapDetail.put("bsflag", "0");
			mapDetail.put("project_info_no", projectInfoNo);
			mapDetail.put("cost_state", costState);
			mapDetail.put("apply_date", new Date());
			mapDetail.put("create_date", new Date());
			mapDetail.put("creator",user.getEmpId());
			mapDetail.put("modifi_date", new Date());
			if(twoState != null && !twoState.equals("")){ 
				mapDetail.put("spare5", "1");
			}
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_comm_human_plan_cost");
			planId = id.toString();
		}
				
		responseDTO.setValue("planId", planId);
		return responseDTO;
	}
	
	/**
	 * 保存人工成本计划主表
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateHumanPlanNo(ISrvMsg reqDTO) throws Exception{
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
 	
		UserToken user = reqDTO.getUserToken();		 
		String planId = reqDTO.getValue("planId");
	 
	  String planNo = EquipmentAutoNum.generateNumberByUserToken(reqDTO.getUserToken(), "RGCB");
	 	Map mapDetail = new HashMap();	
		mapDetail.put("modifi_date", new Date());
		mapDetail.put("plan_id", planId);
	 	mapDetail.put("PLAN_NO", planNo);
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_comm_human_plan_cost");

		return responseDTO;
	}
	
	/**
	 * 保存补充人工成本计划主表
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateHumanPlanNoT(ISrvMsg reqDTO) throws Exception{
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		
		String planId = reqDTO.getValue("planId");
		
	//	String planNo = EquipmentAutoNum.generateNumberByUserToken(
	//			reqDTO.getUserToken(), "RGCB");
		
		Map mapDetail = new HashMap();	
		mapDetail.put("modifi_date", new Date());
		mapDetail.put("plan_id", planId);
	//	mapDetail.put("plan_no", planNo);
		
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_comm_human_plan_cost");

		return responseDTO;
	}
	
	/**
	 * 保存人工成本补充计划主表
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanPlanCostTwo(ISrvMsg reqDTO) throws Exception{
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");		
		UserToken user = reqDTO.getUserToken();		
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");		
		String costState = reqDTO.getValue("costState");
		String twoState = reqDTO.getValue("twoState");
		String plan_id = reqDTO.getValue("plan_id");
		String applyReason = reqDTO.getValue("applyReason");	
		
		applyReason = java.net.URLDecoder.decode(applyReason,"UTF-8"); 

	//	String sql = "select t.plan_id  from bgp_comm_human_plan_cost t where t.project_info_no='"+projectInfoNo+"' and t.cost_state='"+costState+"' and t.bsflag='0' ";
		
	//	if(twoState != null && !twoState.equals("")){ 
	//		sql+=" and t.spare5='1' ";
	//	}else{
			
	//		sql+=" and t.spare5 is null  ";
	//	}
		
	//	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		


//		if(map != null && map.get("planId")!= null ){
//			//提交过，修改
//			planId = (String) map.get("planId");
//
//		}else{
			//未提交，新增
		    String planId = "";
			Map mapDetail = new HashMap();	
			
			if(plan_id ==null){   
				String planNo = EquipmentAutoNum.generateNumberByUserToken(
							reqDTO.getUserToken(), "RGCB");
				   
				mapDetail.put("bsflag", "0");
				mapDetail.put("project_info_no", projectInfoNo);
				mapDetail.put("cost_state", costState);
				mapDetail.put("apply_date", new Date());
				mapDetail.put("create_date", new Date());
				mapDetail.put("creator",user.getEmpId());
				mapDetail.put("modifi_date", new Date());
				mapDetail.put("spare5", "1");
				mapDetail.put("plan_no", planNo);
				mapDetail.put("apply_reason", applyReason);
		 
				Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_comm_human_plan_cost");
				planId = id.toString();
			
			}else{  
				mapDetail.put("plan_id", plan_id);
				mapDetail.put("apply_reason", applyReason);
				mapDetail.put("modifi_date", new Date());
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_comm_human_plan_cost");
				planId=plan_id;
				
			}
			
		//}
			
		 
		responseDTO.setValue("costState", costState);
		responseDTO.setValue("planId", planId);
		return responseDTO;
	}
	
	
	
	/**
	 * 提交人力资源配置计划
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg submitHumanPlan(ISrvMsg reqDTO) throws Exception{
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		UserToken user = reqDTO.getUserToken();
		
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String sql = "select t.plan_id  from bgp_comm_human_plan t where t.project_info_no='"+projectInfoNo+"' and t.spare1 is null   and t.bsflag='0' ";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		String planId = "";
		
		Map mapDetail = new HashMap();	
		if(map != null && map.get("planId")!= null ){
			//提交过，修改
			planId = (String) map.get("planId"); 
			
		}else{
			//未提交，新增
		
			String planNo = EquipmentAutoNum.generateNumberByUserToken(
					reqDTO.getUserToken(), "RPJH");
			mapDetail.put("plan_no", planNo);
			mapDetail.put("bsflag", "0");
			mapDetail.put("project_info_no", projectInfoNo);
			mapDetail.put("apply_company", user.getOrgId());
			mapDetail.put("applicant_id", user.getEmpId());
			mapDetail.put("apply_date", new Date());
			mapDetail.put("create_date", new Date());
			mapDetail.put("modifi_date", new Date());
			
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_comm_human_plan");
			planId = id.toString();
		}
				
		responseDTO.setValue("planId", planId);
		return responseDTO;
	}
	
	

	/**
	 * 提交人力资源配置计划更新提交人信息
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg submitHumanPlanUpdate(ISrvMsg reqDTO) throws Exception{
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		UserToken user = reqDTO.getUserToken();
		
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String sql = "select t.plan_id  from bgp_comm_human_plan t where t.project_info_no='"+projectInfoNo+"' and t.spare1 is null   and t.bsflag='0' ";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		String planId = "";
		
		Map mapDetail = new HashMap();	
		if(map != null && map.get("planId")!= null ){
			//提交过，修改
			planId = (String) map.get("planId"); 
			
			mapDetail.put("plan_id", planId);
			mapDetail.put("apply_company", user.getOrgId());
			mapDetail.put("applicant_id", user.getEmpId());
			mapDetail.put("apply_date", new Date());
			mapDetail.put("modifi_date", new Date());
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_comm_human_plan");
			
		} 
				
		responseDTO.setValue("planId", planId);
		return responseDTO;
	}
	
	
	
	/**
	 * 提交人力资源补充配置计划针对综合业务
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg submitSupplyHumanPlanZh(ISrvMsg reqDTO) throws Exception{
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		UserToken user = reqDTO.getUserToken();
 
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO); 
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String plan_id = reqDTO.getValue("plan_id");
		String mid=reqDTO.getValue("mid");
		
		//查询升请中间表
	    String memo_sql=" select * from GP_MIDDLE_RESOURCES where mid='"+mid+"'";
	    Map memo_map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(memo_sql);
		
		//String shenText = java.net.URLDecoder.decode(reqDTO.getValue("shenText"),"UTF-8") ;
		//String shenText = new String(reqDTO.getValue("shenText").getBytes("ISO8859-1"),"UTF-8");  //避免jsp页面传值乱码情况
		if(memo_map.get("humanId")=="" || memo_map.get("humanId")==null){
			String sql = "select t.plan_id  from bgp_comm_human_plan t where t.project_info_no='"+projectInfoNo+"' and t.spare1='0' and t.bsflag='0' ";
			Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
			String planId = "";

//			if(map != null && map.get("planId")!= null ){
//				//提交过，修改
//				planId = (String) map.get("planId");
	//
//			}else{
				//未提交，新增
			   Map mapDetail = new HashMap();
				if(plan_id ==null){  
					String planNo = EquipmentAutoNum.generateNumberByUserToken(
							reqDTO.getUserToken(), "RPJH");
					mapDetail.put("plan_no", planNo);
					mapDetail.put("bsflag", "0");
					mapDetail.put("project_info_no", projectInfoNo);
					mapDetail.put("apply_company", user.getOrgId());
					mapDetail.put("applicant_id", user.getEmpId());
					mapDetail.put("apply_date", new Date());
					mapDetail.put("create_date", new Date());
					mapDetail.put("modifi_date", new Date());
					mapDetail.put("spare1", "0");		
					mapDetail.put("spare3", memo_map.get("memo"));	
					Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_comm_human_plan");
					planId = id.toString();
				}else{ 
					mapDetail.put("plan_id", plan_id);
					mapDetail.put("spare3", memo_map.get("memo"));	
					mapDetail.put("modifi_date", new Date());
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_comm_human_plan");
					planId=plan_id;
				}
				//生成人力补充计划后修改GP_MIDDLE_RESOURCES中间表
				Map resources=new HashMap();
				resources.put("human_id", planId);
				resources.put("mid", mid);
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(resources,"GP_MIDDLE_RESOURCES");
//			}
					
			responseDTO.setValue("planId", planId);
		}else{
			responseDTO.setValue("planId", memo_map.get("humanId"));
			
		}
		return responseDTO;
	}
	
	
	/**
	 * 提交人力资源补充配置计划
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg submitSupplyHumanPlan(ISrvMsg reqDTO) throws Exception{
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		UserToken user = reqDTO.getUserToken();
 
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO); 
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String plan_id = reqDTO.getValue("plan_id");
		String shenText =reqDTO.getValue("shenText"); 
		
	//	shenText = java.net.URLEncoder.encode(shenText,"UTF-8"); 
		shenText = java.net.URLDecoder.decode(shenText,"UTF-8"); 
		
		//String shenText = java.net.URLDecoder.decode(reqDTO.getValue("shenText"),"UTF-8") ;
		//String shenText = new String(reqDTO.getValue("shenText").getBytes("ISO8859-1"),"UTF-8");  //避免jsp页面传值乱码情况
		String sql = "select t.plan_id  from bgp_comm_human_plan t where t.project_info_no='"+projectInfoNo+"' and t.spare1='0' and t.bsflag='0' ";
		Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		String planId = "";

//		if(map != null && map.get("planId")!= null ){
//			//提交过，修改
//			planId = (String) map.get("planId");
//
//		}else{
			//未提交，新增
		   Map mapDetail = new HashMap();
			if(plan_id ==null){  
				String planNo = EquipmentAutoNum.generateNumberByUserToken(
						reqDTO.getUserToken(), "RPJH");
				mapDetail.put("plan_no", planNo);
				mapDetail.put("bsflag", "0");
				mapDetail.put("project_info_no", projectInfoNo);
				mapDetail.put("apply_company", user.getOrgId());
				mapDetail.put("applicant_id", user.getEmpId());
				mapDetail.put("apply_date", new Date());
				mapDetail.put("create_date", new Date());
				mapDetail.put("modifi_date", new Date());
				mapDetail.put("spare1", "0");		
				mapDetail.put("spare3", shenText);	
				Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_comm_human_plan");
				planId = id.toString();
			}else{ 
				mapDetail.put("plan_id", plan_id);
				mapDetail.put("spare3", shenText);	
				mapDetail.put("modifi_date", new Date());
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,"bgp_comm_human_plan");
				planId=plan_id;
			}
			
//		}
				
		responseDTO.setValue("planId", planId);
		return responseDTO;
	}
	
	
 
	
	/*
	 * 查询项目评价
	 */
	public ISrvMsg queryEvaluateLevel(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);

		String sql = "SELECT t.coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0110000058' and t.bsflag='0' order by t.coding_show_id ";

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}

	/*
	 * 多项目根据用户的组织机构查询班组
	 */
	public ISrvMsg queryApplyTeam(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();		 
		String subId=user.getSubOrgIDofAffordOrg();
		//org_subjection_id（C105008综合物化探、）
		StringBuffer sb = new StringBuffer("SELECT t.coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) <= 2");

		sb.append(" order by t.coding_show_id ");
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}
	/*
	 * 单项目根据项目类型查询班组
	 */
	public ISrvMsg queryApplyTeamP(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();		
		String projectType ="";
		if(reqDTO.getValue("projectType")!=null && !reqDTO.getValue("projectType").equals("null") && !reqDTO.getValue("projectType").equals("")){
			projectType=reqDTO.getValue("projectType"); 
			
		}else{
			projectType=user.getProjectType();
		}
		
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		} 
		if(projectType.equals("5000100004000000002")){
			projectType="5000100004000000001";
		}
		
		StringBuffer sb = new StringBuffer("SELECT t.coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and t.coding_mnemonic_id='"+projectType+"' and length(t.coding_code) <= 2");
		sb.append(" order by t.coding_show_id ");
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}
	/*
	 * 查询岗位列表
	 */
	public ISrvMsg queryApplyPostList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		String applyTeam = reqDTO.getValue("applyTeam");
		applyTeam = URLDecoder.decode(applyTeam, "utf-8");
		applyTeam = URLDecoder.decode(applyTeam, "utf-8");
		UserToken user = reqDTO.getUserToken();		
		
		String projectType ="";
		if(reqDTO.getValue("projectType") !=null && !reqDTO.getValue("projectType").equals("null") && !reqDTO.getValue("projectType").equals("")){
			projectType=reqDTO.getValue("projectType"); 
			
		}else{
			projectType=user.getProjectType();
		}
		
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		} 
		if(projectType.equals("5000100004000000002")){
			projectType="5000100004000000001";
		}
		
		
		StringBuffer sb = new StringBuffer(" SELECT t.coding_code_id AS value, t.coding_name AS label FROM comm_coding_sort_detail t, (select coding_sort_id, coding_code ");
		sb.append(" from comm_coding_sort_detail where (coding_code_id = '").append(applyTeam).append("' or coding_name='").append(applyTeam).append("') and bsflag='0' ) d ");
		sb.append(" where t.coding_sort_id = d.coding_sort_id and t.bsflag = '0' and t.coding_mnemonic_id='"+projectType+"'  and t.coding_code like d.coding_code||'_%'  order by t.coding_show_id ");
		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}
	
	
	/*
	 * 查询资格证
	 */
	public ISrvMsg queryCertificate(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "SELECT t.coding_code_id AS value, t.coding_name AS label   FROM comm_human_coding_sort t  where t.coding_sort_id = '0000000001'   and t.bsflag = '0'    and length(t.coding_code) <= 2 ";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}
	/*
	 * 查询资格证名称
	 */
	public ISrvMsg queryCertificateList(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO =SrvMsgUtil.createResponseMsg(reqDTO);
		String CodingCode = reqDTO.getValue("coding_code");
		
		StringBuffer sb = new StringBuffer("  SELECT   t.coding_code_id AS value, t.coding_name AS label FROM comm_human_coding_sort t where t.coding_lever='2' and t.bsflag = '0' and t.superior_code_id='");
		sb.append(CodingCode).append("'  order by t.coding_show_order  ");
		
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		return responseDTO;
	}


	
	/**
	 * 进入专业化人员需求页面包括新增及修改
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg professApplyView(ISrvMsg reqDTO) throws Exception {

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
		String projectName = reqDTO.getValue("projectName");
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
			
//			// 查询子表信息
//			StringBuffer subsql = new StringBuffer(" select d.apply_team, s1.coding_name apply_teamname, d.post, s2.coding_name postname,d.people_number people_num,d.profess_number profess_num, d.plan_start_date, d.plan_end_date, ");			
//			subsql.append("  nvl(z3,0)+ nvl(z4,0) z3 from ");					
//	
//			
//			subsql.append("( select p.apply_team, p.post,sum(p.people_number) people_number , sum(p.profess_number) profess_number,min(p.plan_start_date) plan_start_date, max(p.plan_end_date) plan_end_date,(max(p.plan_end_date)-min(p.plan_start_date)) nums from ( select d.plan_detail_id,d.task_id,d.apply_team,d.post,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums ");
//			subsql.append(" from bgp_comm_human_plan_detail d  ");
//			subsql.append(" left join bgp_comm_human_plan p on p.project_info_no=d.project_info_no and p.bsflag='0' ");
//			subsql.append(" left join common_busi_wf_middle te on te.business_id=p.plan_id and te.business_type in ('5110000004100000022','5110000004100001057')  and te.bsflag='0' ");
//			subsql.append(" where d.project_info_no='").append(projectInfoNo).append("'  and te.proc_status='3' and d.bsflag='0' ) p group by p.apply_team,p.post ) d ");
//			
//			subsql.append(" left join comm_coding_sort_detail s1 on d.apply_team = s1.coding_code_id and s1.bsflag = '0'  ");
//			subsql.append(" left join comm_coding_sort_detail s2 on d.post = s2.coding_code_id and s2.bsflag = '0' ");
//			
//			subsql.append(" left join (select sum(nvl(p2.own_num,0)) z3,sum(nvl(p2.deploy_num,0)) z4,p2.apply_team,p2.post from bgp_project_human_profess_post p2 ");
//			subsql.append(" inner join bgp_project_human_profess r on p2.profess_no=r.profess_no and r.project_info_no = '").append(projectInfoNo).append("' and r.bsflag='0'     left join common_busi_wf_middle te on    te.business_id=r.profess_no   and te.bsflag='0'  and te.business_type  in ('5110000004100000023','5110000004100001054')   ");			
//			subsql.append(" where p2.bsflag = '0' and te.proc_status='3'   group by p2.apply_team,p2.post) q2 on q2.apply_team=d.apply_team and q2.post = d.post ");
//			
//			subsql.append(" where s1.spare2='0'  and d.profess_number !='0'  order by d.apply_team,d.post ");

			
			// 查询子表信息
			StringBuffer subsql = new StringBuffer(" select * from ( select distinct d.apply_team, s1.coding_name apply_teamname, d.post, s2.coding_name postname,  sum(nvl(d.people_number,0)) people_num, sum(nvl(d.profess_number,0)) profess_num, d.plan_start_date, d.plan_end_date, ");
			subsql.append(" sum(nvl(z1,0))+sum(nvl(hpt.anber, 0)) z3,case when sum(nvl(d.people_number,0))-sum(nvl(d.profess_number,0))-sum(nvl(z1, 0))-sum(nvl(hpt.anber, 0)) <0 then 0 else sum(nvl(d.people_number,0))-sum(nvl(d.profess_number,0))-sum(nvl(z1, 0))-sum(nvl(hpt.anber, 0))  end  z2, sum(nvl(z3, 0)) + sum(nvl(z4, 0)) z1 ");
		//subsql.append(" from ( select p.apply_team, p.post,sum(p.people_number) people_number , sum(p.profess_number) profess_number,min(p.plan_start_date) plan_start_date, max(p.plan_end_date) plan_end_date,(max(p.plan_end_date)-min(p.plan_start_date)) nums from ( select distinct d.plan_detail_id,d.task_id,d.apply_team,d.post,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums ");
			subsql.append(" from ( select distinct d.plan_detail_id,d.task_id,d.apply_team,d.post,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums ");
			subsql.append(" from bgp_comm_human_plan_detail d ");
			subsql.append(" left join bgp_comm_human_plan p on p.project_info_no=d.project_info_no and p.bsflag='0' ");
			subsql.append(" left join common_busi_wf_middle te on te.business_id=p.plan_id and te.business_type in ('5110000004100000022','5110000004100001057')  and te.bsflag='0' ");
			subsql.append(" where d.project_info_no='").append(projectInfoNo).append("' and te.proc_status='3' and d.bsflag='0' ");
			
		//subsql.append(" ) p group by p.apply_team,p.post ) d ");
			subsql.append("  ) d ");
			
			subsql.append(" left join comm_coding_sort_detail s1 on d.apply_team = s1.coding_code_id and s1.bsflag = '0' and s1.coding_mnemonic_id='"+projectInfoType+"' ");
			subsql.append(" left join comm_coding_sort_detail s2 on d.post = s2.coding_code_id and s2.bsflag = '0' and s2.coding_mnemonic_id='"+projectInfoType+"' ");
			subsql.append(" left join (   select  sum(nvl(1, 0)) z1,  d.team,   d.work_post,       p.project_info_no  ,d.plan_start_date,  d.plan_end_date    from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p     on d.prepare_no = p.prepare_no    and p.prepare_status = '2'   left join bgp_project_human_relation r     on d.employee_id = r.employee_id    and p.project_info_no = r.project_info_no    and r.team = d.team    and r.work_post = d.work_post   left join common_busi_wf_middle te     on te.business_id = p.prepare_no    and te.bsflag = '0'   left join bgp_project_human_profess pr1     on pr1.profess_no = p.profess_no    and p.profess_no is not null    and pr1.bsflag = '0'   left join bgp_project_human_requirement pr     on pr.requirement_no = p.requirement_no    and p.requirement_no is not null    and pr.bsflag = '0'   left join bgp_project_human_relief re     on re.human_relief_no = p.human_relief_no    and p.human_relief_no is not null    and re.bsflag = '0'   left join gp_task_project t     on p.project_info_no = t.project_info_no  where p.bsflag = '0'    and d.bsflag = '0'    and p.project_info_no = '").append(projectInfoNo).append("'     and (te.business_id is null or te.proc_status = '3')    and d.actual_start_date is not null    and (d.spare1 is null or d.spare1 = '1')    group by  d.team,d.work_post,p.project_info_no  ,d.plan_start_date,  d.plan_end_date     ) q1   on q1.team = d.apply_team   and q1.work_post = d.post  and q1.plan_start_date=d.plan_start_date  and q1.plan_end_date=d.plan_end_date   ");
		//	subsql.append(" inner join bgp_project_human_requirement r on p1.requirement_no=r.requirement_no and r.project_info_no = '").append(projectInfoNo).append("' and r.bsflag='0'   ");
		//	subsql.append(" where p1.bsflag = '0' group by p1.apply_team,p1.post) q1 on  q1.apply_team=d.apply_team and  q1.post = d.post ");
			subsql.append(" left join (select sum(nvl(p2.own_num,0)) z3,sum(nvl(p2.deploy_num,0)) z4,p2.apply_team,p2.post from bgp_project_human_profess_post p2 ");
			subsql.append(" inner join bgp_project_human_profess r on p2.profess_no=r.profess_no and r.project_info_no = '").append(projectInfoNo).append("'  and r.bsflag='0'  ");
			subsql.append(" where p2.bsflag = '0' group by p2.apply_team,p2.post) q2 on q2.apply_team=d.apply_team and q2.post = d.post  ");
			subsql.append(" left  join (    select  distinct     sum(nvl( p.audit_number,0)) anber ,         p.apply_team,   p.post      from bgp_project_human_post p   inner join bgp_project_human_requirement r      on p.requirement_no = r.requirement_no       and r.bsflag='0'         left join common_busi_wf_middle te       on te.business_id = r.requirement_no          and te.bsflag = '0'    where p.bsflag = '0'  and te.proc_status = '3'  and  r.project_info_no= '").append(projectInfoNo).append("'   group  by  p.apply_team,     p.post    )hpt      on hpt.apply_team = q1.team    and hpt.post = q1.work_post  "); // on hpt.apply_team=d.apply_team    and hpt.post=d.post   ");
			
			subsql.append("     group  by d.apply_team,s1.coding_name, d.post ,  d.plan_start_date,  d.plan_end_date , s2.coding_name   order by d.apply_team,d.post  ) h where   h.profess_num !='0' ");

			 
			List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
			responseDTO.setValue("detailInfo", list);
		} else {
			// 查询主表信息
			Map map = new HashMap();
			StringBuffer sb = new StringBuffer(" select r.profess_no,r.project_info_no,t.project_name, ");
			sb.append(" r.apply_company, to_char(r.apply_date,'yyyy-MM-dd') apply_date,r.applicant_id, ");
			sb.append(" r.apply_no,r.apply_state,r.notes,");
			sb.append(" t1.org_name applicant_org_name,t2.employee_name applicant_name ");
			sb.append(" from bgp_project_human_profess r ");
			sb.append(" left join gp_task_project t on r.project_info_no = t.project_info_no and r.bsflag = '0' ");
			sb.append(" left join comm_org_information t1 on r.apply_company = t1.org_id and t1.bsflag = '0' ");
			sb.append(" left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0' ");
			sb.append(" where r.profess_no='").append(keyId).append("' ");
		
			map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
			responseDTO.setValue("applyInfo", map);
			
			// 查询子表信息
			StringBuffer subsql = new StringBuffer(" select p.post_no,p.notes, ");
			subsql.append(" p.people_num,p.profess_num,p.own_num,p.deploy_num, ");					
			subsql.append(" p.age,p.culture,p.work_years,p.apply_team,p.post,p.plan_start_date, ");
			subsql.append(" p.plan_end_date,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname,   p.spare2,p.spare3 ,");
			subsql.append("  nvl(z3,0)+ nvl(z4,0) z3 ");	
			subsql.append(" from bgp_project_human_profess_post p");
			subsql.append(" inner join bgp_project_human_profess r ").append("on p.profess_no= r.profess_no ");
			subsql.append(" left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id  and d1.bsflag = '0' and d1.coding_mnemonic_id='"+projectInfoType+"' "); 
			subsql.append(" left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id  and d2.bsflag = '0' and d2.coding_mnemonic_id='"+projectInfoType+"' ");
			
			subsql.append(" left join (select sum(nvl(p2.own_num,0)) z3,sum(nvl(p2.deploy_num,0)) z4,p2.apply_team,p2.post from bgp_project_human_profess_post p2 ");
			subsql.append(" inner join bgp_project_human_profess r on p2.profess_no=r.profess_no and r.project_info_no = '").append(projectInfoNo).append("'  and r.bsflag='0'  left join common_busi_wf_middle te on    te.business_id=r.profess_no   and te.bsflag='0'  and te.business_type  in ('5110000004100000023','5110000004100001054')   ");			
			subsql.append(" where p2.bsflag = '0' and te.proc_status='3'   group by p2.apply_team,p2.post) q2 on q2.apply_team=p.apply_team and q2.post = p.post ");
						
			subsql.append(" where p.bsflag='0' and p.profess_no='").append(keyId).append("' order by p.apply_team,p.post ");

			List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
			responseDTO.setValue("detailInfo", list);
			
		}
		
		return responseDTO;
	}
	
	
	public ISrvMsg saveProfessHumanApply(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		Map mapInfo = null;
		BgpProjectHumanProfess applyInfo = new BgpProjectHumanProfess();
		PropertiesUtil.msgToPojo(reqDTO, applyInfo);
		mapInfo = PropertiesUtil.describe(applyInfo);
		
		//申请表主键
		String infoKeyValue = "";
		if (mapInfo.get("profess_no") == null) {// 新增操作			
			String applyNo = EquipmentAutoNum.generateNumberByUserToken(
					reqDTO.getUserToken(), "RZSQ");
			mapInfo.put("apply_no", applyNo);
			mapInfo.put("bsflag", "0");
			mapInfo.put("creator", user.getEmpId());
			mapInfo.put("create_date", new Date());
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			mapInfo.put("apply_date", mapInfo.get("apply_date"));
			
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,"bgp_project_human_profess");
			infoKeyValue = id.toString();
		} else {// 修改或审核操作
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			mapInfo.put("apply_date", mapInfo.get("apply_date"));
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,
					"bgp_project_human_profess");
			infoKeyValue = (String) mapInfo.get("profess_no");
		}

		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));

		Map mapDetail = new HashMap();
		//存放申请单子表信息
		for (int i = 0; i < equipmentSize; i++) {		
				BgpProjectHumanProfessPost applyDetail = new BgpProjectHumanProfessPost();
				PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
						applyDetail);				
				mapDetail = PropertiesUtil.describe(applyDetail);				
				//if(mapDetail.get("check").equals("on")){					
				if (mapInfo.get("profess_no") == null) {
					if("on".equals(mapDetail.get("check"))){
						mapDetail.put("bsflag", "0");
						mapDetail.put("profess_no", infoKeyValue);				
						mapDetail.put("creator", user.getEmpId());
						mapDetail.put("create_date", new Date());
						mapDetail.put("updator", user.getEmpId());
						mapDetail.put("modifi_date", new Date());
						
						BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"bgp_project_human_profess_post");
					}
				}else{
					if("on".equals(mapDetail.get("check"))){
						mapDetail.put("bsflag", "0");	
					}else{					
						mapDetail.put("bsflag", "1");		
					}	
					mapDetail.put("profess_no", infoKeyValue);				
					mapDetail.put("creator", user.getEmpId());
					mapDetail.put("create_date", new Date());
					mapDetail.put("updator", user.getEmpId());
					mapDetail.put("modifi_date", new Date());
					
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
					"bgp_project_human_profess_post");
				}
		} 
	
		return responseDTO;
	}
	
	
	/**
	 * 进入专业化人员审核调配页面
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg professAuditViewwfpg(ISrvMsg reqDTO) throws Exception {

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
		// 申请表主键

		// 查询主表信息
		Map map = new HashMap();
		StringBuffer sb = new StringBuffer(" select r.profess_no,r.project_info_no,t.project_name, ");
		sb.append(" r.apply_company, to_char(r.apply_date,'yyyy-MM-dd') apply_date,r.applicant_id, ");
		sb.append(" r.apply_no,r.apply_state,r.notes,");
		sb.append(" t1.org_name applicant_org_name,t2.employee_name applicant_name ");
		sb.append(" from bgp_project_human_profess r ");
		sb.append(" left join gp_task_project t on r.project_info_no = t.project_info_no and r.bsflag = '0' ");
		sb.append(" left join comm_org_information t1 on r.apply_company = t1.org_id and t1.bsflag = '0' ");
		sb.append(" left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0' ");
		sb.append(" where r.profess_no='").append(keyId).append("' ");
	
		map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
		responseDTO.setValue("applyInfo", map);
		
		// 查询子表信息
		StringBuffer subsql = new StringBuffer(" select p.post_no,p.notes, ");
		subsql.append(" p.people_num,p.own_num,p.deploy_num, ");					
		subsql.append(" p.age,p.culture,p.work_years,p.apply_team,p.post,p.plan_start_date, ");
		subsql.append(" p.plan_end_date,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname ");
		subsql.append(" from bgp_project_human_profess_post p");
		subsql.append(" inner join bgp_project_human_profess r ").append("on p.profess_no= r.profess_no ");
		subsql.append(" left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
		subsql.append(" left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");					
		subsql.append(" where p.bsflag='0' and p.profess_no='").append(keyId).append("' order by p.apply_team,p.post ");

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
		responseDTO.setValue("detailInfo", list);
		
		//专业化人员查询分解表
		StringBuffer querySub = new StringBuffer(" select d.post_detail_no,d.apply_team,d.post,d.people_number,d.deploy_org,d.competence,d.age,d.notes, ");
		querySub.append(" d.work_years,d.work_trade_years,d.culture,d.plan_start_date,d.plan_end_date,t1.org_name deploy_org_name,  ");
		querySub.append(" nvl(d3.coding_name,d.culture) culture_name,d1.coding_name postname, d2.coding_name apply_teamname ");
		querySub.append(" from bgp_project_human_profess_deta d ");
		querySub.append(" inner join bgp_project_human_profess_post p on d.post_no = p.post_no and p.bsflag='0' ");
		querySub.append(" inner join bgp_project_human_profess f on p.profess_no=f.profess_no and f.bsflag='0' ");
		querySub.append(" left join comm_org_information t1 on d.deploy_org = t1.org_id ");
		querySub.append(" left join comm_coding_sort_detail d1 on d.post = d1.coding_code_id ");
		querySub.append(" left join comm_coding_sort_detail d2 on d.apply_team = d2.coding_code_id ");
		querySub.append(" left join comm_coding_sort_detail d3 on d.culture = d3.coding_code_id ");
		querySub.append(" where d.bsflag='0' and f.profess_no='").append(keyId).append("' ");
		
		List sublist = BeanFactory.getQueryJdbcDAO().queryRecords(querySub.toString());
		responseDTO.setValue("subDetailInfo", sublist);

		
		return responseDTO;
	}
	
	/**
	 * 专业化人员审核调配保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg saveProfessAuditwfpa(ISrvMsg reqDTO) throws Exception {
		
		String isPass = reqDTO.getValue("isPass");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		if(isPass !=null && "pass".equals(isPass)){
		
			UserToken user = reqDTO.getUserToken();
			
			String[] hidEDetailId = {};
			if (reqDTO.getValue("hidEDetailId") != null) {
				hidEDetailId = reqDTO.getValue("hidEDetailId").split(",");
			}
			for (int j = 0; j < hidEDetailId.length; j++) {
				BeanFactory.getPureJdbcDAO().deleteEntity(
						"bgp_project_human_profess_deta", hidEDetailId[j]);
			}
			int equipmentESize = Integer.parseInt(reqDTO.getValue("equipmentESize"));
			String deleteERowFlag = reqDTO.getValue("deleteERowFlag");
			String[] rowEFlag = null;
			Map mapEFlag = new HashMap();
			if (deleteERowFlag != null && !deleteERowFlag.equals("")) {
				rowEFlag = deleteERowFlag.split(",");
				for (int i = 0; i < rowEFlag.length; i++) {
					mapEFlag.put(rowEFlag[i], "true");
				}
			}
			
			Map mapEDetail = new HashMap();
			for (int i = 0; i < equipmentESize; i++) {		
				if (mapEFlag.get(String.valueOf(i)) == null) {
				BgpProjectHumanProfessDeta applyEDetail = new BgpProjectHumanProfessDeta();
				PropertiesUtil.msgToPojo("em" + String.valueOf(i), reqDTO,
						applyEDetail);
				mapEDetail = PropertiesUtil.describe(applyEDetail);	
				
				if(eqServOrg.indexOf(mapEDetail.get("deploy_org").toString()) != -1){
					//待分配任务
					mapEDetail.put("deploy_flag", "0");
				}else{
					//不用分配任务
					mapEDetail.put("deploy_flag", "2");
				}
				mapEDetail.put("bsflag", "0");
				mapEDetail.put("creator", user.getEmpId());
				mapEDetail.put("create_date", new Date());
				mapEDetail.put("updator", user.getEmpId());
				mapEDetail.put("modifi_date", new Date());
	
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapEDetail,
							"bgp_project_human_profess_deta");
				}
				
			} 
		
		}			
		return responseDTO;
	}
	
	
	
	/**
	 * 查询调配人员
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg searchProfessPrepare(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		String project_name = reqDTO.getValue("project_name");
		String prepare_status = reqDTO.getValue("prepare_status");
		
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

		StringBuffer sb = new StringBuffer("");
		sb.append(" select c.* from ( select a.* from ( ");
		sb.append(" select r1.apply_no,");
		sb.append("       r1.emp_id,");
		sb.append("       r.profess_no,");
		sb.append("       r1.deploy_org org_id,");
		sb.append("       r.apply_company,");
		sb.append("       i1.org_name deploy_org_name,p.project_type,");
		sb.append("       p.project_name,");
		sb.append("       t2.employee_name applicant_name,");
		sb.append("       i.org_abbreviation applicant_org_name,");
		sb.append("        r.apply_date,");
		sb.append("       pr.prepare_no,");
		sb.append("       pr.prepare_id,");
		sb.append("       pr.applicant_id,");
		sb.append("       t1.employee_name,");
		sb.append("       To_char(pr.deploy_date, 'yyyy-MM-dd') deploy_date,");
		sb.append("       nvl(pr.prepare_status, '0') prepare_status,");
		sb.append("       decode(pr.prepare_status,");
		sb.append("              '0',");
		sb.append("              '待调配',");
		sb.append("              '1',");
		sb.append("              '调配中',");
		sb.append("              '2',");
		sb.append("              '已调配',");
		sb.append("              '待调配') prepare_status_name , decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) flow_name, 'no' pre_flag  ");
		//需调配人员，并且调配到仪器中心的调配单（任务分配到人）
		sb.append("   from (select a.* from (");
		sb.append("        select pro.apply_no, de.deploy_org,a.employee_id emp_id ");
		sb.append("          from bgp_project_human_profess_deta de");
		sb.append("          left join bgp_project_human_profess_post po on po.post_no =");
		sb.append("                                                         de.post_no");
		sb.append("          left join bgp_project_human_profess pro on po.profess_no =");
		sb.append("                                                     pro.profess_no");
		sb.append("          left join bgp_comm_human_allocate_task_a a on de.post_detail_no=a.post_detail_no");
		sb.append("         where pro.bsflag = '0'");
		sb.append("           and po.bsflag = '0'");
		sb.append("           and de.bsflag = '0' and de.deploy_flag = '1' ");
		sb.append("          group by pro.apply_no, de.deploy_org,a.employee_id ");
		sb.append("         order by pro.apply_no) a ");
		//需调配人员，调配到非仪器中心的调配单（没有进行任务调配）
		sb.append("     union all select b.* from ( ");
		sb.append("   select pro.apply_no, de.deploy_org,'' emp_id ");
		sb.append("          from bgp_project_human_profess_deta de");
		sb.append("          left join bgp_project_human_profess_post po on po.post_no =");
		sb.append("                                                         de.post_no");
		sb.append("          left join bgp_project_human_profess pro on po.profess_no =");
		sb.append("                                                     pro.profess_no");
		sb.append("         where pro.bsflag = '0'");
		sb.append("           and po.bsflag = '0'");
		sb.append("           and de.bsflag = '0' and de.deploy_flag ='2'");
		sb.append("         group by pro.apply_no, de.deploy_org ");
		sb.append("         order by pro.apply_no ) b  ");		
		sb.append("  ) r1 ");	
		
		sb.append("  left join bgp_project_human_profess r on r.apply_no = r1.apply_no and r.bsflag='0'");
		sb.append("  left join gp_task_project p on r.project_info_no = p.project_info_no");
		sb.append("                             and p.bsflag = '0'");
		sb.append("  left join bgp_human_prepare pr on r.profess_no = pr.profess_no and pr.prepare_org_id=r1.deploy_org and (r1.emp_id=pr.applicant_id or r1.emp_id is null  )  and pr.bsflag='0' and r.bsflag='0'");
		sb.append("   left join common_busi_wf_middle te on   te.business_id=pr.prepare_no   and te.bsflag='0' and te.business_type  in ('5110000004100000006','5110000004100001052')  left join comm_org_information i on r.apply_company = i.org_id  and i.bsflag = '0'");
		sb.append("   left join common_busi_wf_middle te1 on   te1.business_id=r.profess_no   and te1.bsflag='0' and te1.business_type  in ('5110000004100000023','5110000004100001054') ");
		sb.append("  left join comm_org_information i1 on r1.deploy_org = i1.org_id");
		sb.append("                                  and i1.bsflag = '0'");
		sb.append("  left join comm_human_employee t1 on pr.applicant_id = t1.employee_id");
		sb.append("                                  and t1.bsflag = '0'");
		sb.append("  left join comm_human_employee t2 on r.applicant_id = t2.employee_id");
		sb.append("                                  and t2.bsflag = '0'");

		sb.append("  where r.bsflag = '0' and te1.proc_status='3' ");
		//仪器中心的人 按人过滤
		if(eqServOrg.indexOf(user.getOrgId()) != -1){
			sb.append(" and r1.emp_id ='").append(user.getEmpId()).append("' ");
		}
		sb.append(" ) a ");
		sb.append("  union all ");
		//自有的非专业人员调配单
		sb.append(" select b.* from (select ");
		sb.append("       r.apply_no,");
		sb.append("       '' emp_id,");
		sb.append("       r.profess_no,");
		sb.append("       i.org_id,");
		sb.append("       r.apply_company,");
		sb.append("       i.org_name deploy_org_name,p.project_type,");
		sb.append("       p.project_name,");
		sb.append("       t2.employee_name applicant_name,");
		sb.append("       i.org_abbreviation applicant_org_name,");
		sb.append("        r.apply_date,");
		sb.append("       pr.prepare_no,");
		sb.append("       pr.prepare_id,");
		sb.append("       pr.applicant_id,");
		sb.append("       t1.employee_name,");
		sb.append("       To_char(pr.deploy_date, 'yyyy-MM-dd') deploy_date,");
		sb.append("       nvl(pr.prepare_status, '0') prepare_status,");
		sb.append("       decode(pr.prepare_status,");
		sb.append("              '0',");
		sb.append("              '待调配',");
		sb.append("              '1',");
		sb.append("              '调配中',");
		sb.append("              '2',");
		sb.append("              '已调配',");// 申请单位和调配单位是一个的不走审批流程decode(pr.prepare_status,'2','','' ) flow_name 
		sb.append("              '待调配') prepare_status_name, decode(te.proc_status,   '1',   '待审批',  '3',  '审批通过', '4', '审批不通过',te.proc_status) flow_name,'yes' pre_flag ");
		sb.append("  from bgp_project_human_profess r ");
		
		sb.append(" left join (select nvl(sum(p2.own_num),'0') nu,p2.profess_no");
		sb.append("  from bgp_project_human_profess p1");
		sb.append("  inner join bgp_project_human_profess_post p2 on p1.profess_no=p2.profess_no where p1.bsflag='0' and p2.bsflag='0' ");
		sb.append("  group by p2.profess_no ) t7 on t7.profess_no=r.profess_no ");
		
		sb.append("  left join gp_task_project p on r.project_info_no = p.project_info_no");
		sb.append("                             and p.bsflag = '0'");
		sb.append("  left join bgp_human_prepare pr on r.profess_no = pr.profess_no and pr.prepare_org_id=r.apply_company and pr.bsflag='0' and r.bsflag='0'");
		sb.append("  left join common_busi_wf_middle te on    te.business_id=pr.prepare_no  and te.bsflag='0' and business_type   in ('5110000004100000006','5110000004100001052')   ");
		sb.append("  left join comm_org_information i on r.apply_company = i.org_id and i.bsflag = '0'");
		sb.append("  left join common_busi_wf_middle te1 on   te1.business_id=r.profess_no   and te1.bsflag='0' and te1.business_type  in ('5110000004100000023','5110000004100001054')  ");
		sb.append("  left join comm_human_employee t1 on pr.applicant_id = t1.employee_id");
		sb.append("                                  and t1.bsflag = '0'");
		sb.append("  left join comm_human_employee t2 on r.applicant_id = t2.employee_id");
		sb.append("                                  and t2.bsflag = '0'");	
		sb.append(" where r.bsflag='0'  and t7.nu <> '0' and te1.proc_status='3' ) b");
		sb.append("  ) c  ");
		sb.append(" left join comm_org_subjection s on c.org_id=s.org_id and s.bsflag='0' where s.org_subjection_id like '").append(user.getSubOrgIDofAffordOrg()).append("%' ");
		
		if (project_name != null) {
			sb.append(" and c.project_name like '%").append(project_name).append("%' ");
		} 
		if (prepare_status != null) {
			sb.append(" and  c.prepare_status='").append(prepare_status).append("' ");
		} else {
			sb.append(" and  c.prepare_status in ('1','2','0') ");
			
		}
		
		
		sb.append(" order by  c.prepare_status asc ,c.apply_date desc  ");
		StringBuffer humanSql = new StringBuffer();
		humanSql.append("select * from (select datas.*,rownum rownum_ from (");
		humanSql.append(sb.toString());
		humanSql.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
		
		List datas=BeanFactory.getQueryJdbcDAO().queryRecords(humanSql.toString());

		humanSql = new StringBuffer();
		humanSql.append("select count(1) count from ( ");
		humanSql.append(sb.toString()).append(")");
																								
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
	 * 进入专业化人员分配任务页面
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg humanAllocateView(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
				
		String keyId = reqDTO.getValue("id");
		// 查询主表信息
		Map map = new HashMap();
		StringBuffer sb = new StringBuffer(" select r.profess_no,r.project_info_no,t.project_name, ");
		sb.append(" r.apply_company, to_char(r.apply_date,'yyyy-MM-dd') apply_date,r.applicant_id, ");
		sb.append(" r.apply_no,r.apply_state,r.notes,");
		sb.append(" t1.org_name applicant_org_name,t2.employee_name applicant_name ");
		sb.append(" from bgp_project_human_profess r ");
		sb.append(" left join gp_task_project t on r.project_info_no = t.project_info_no and r.bsflag = '0' ");
		sb.append(" left join comm_org_information t1 on r.apply_company = t1.org_id and t1.bsflag = '0' ");
		sb.append(" left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0' ");
		sb.append(" where r.profess_no='").append(keyId).append("' ");
	
		map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
		responseDTO.setValue("applyInfo", map);
		
		// 查询子表信息
		StringBuffer subsql = new StringBuffer(" select p.post_no,p.notes, ");
		subsql.append(" p.people_num,p.own_num,p.deploy_num, ");					
		subsql.append(" p.age,p.culture,p.work_years,p.apply_team,p.post,p.plan_start_date, ");
		subsql.append(" p.plan_end_date,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname ");
		subsql.append(" from bgp_project_human_profess_post p");
		subsql.append(" inner join bgp_project_human_profess r ").append("on p.profess_no= r.profess_no ");
		subsql.append(" left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
		subsql.append(" left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");					
		subsql.append(" where p.bsflag='0' and p.profess_no='").append(keyId).append("' order by p.apply_team,p.post ");

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
		responseDTO.setValue("detailInfo", list);


		StringBuffer querySub = new StringBuffer(" select d.post_detail_no,d.apply_team,d.post,d.people_number,d.deploy_org,d.competence,d.age,d.notes, ");
		querySub.append(" d.work_years,d.work_trade_years,d.culture,d.plan_start_date,d.plan_end_date,t1.org_name deploy_org_name,  ");
		querySub.append(" nvl(d3.coding_name,d.culture) culture_name,d1.coding_name postname, d2.coding_name apply_teamname ");
		querySub.append(" from bgp_project_human_profess_deta d ");
		querySub.append(" inner join bgp_project_human_profess_post p on d.post_no = p.post_no and p.bsflag='0' ");
		querySub.append(" inner join bgp_project_human_profess f on p.profess_no=f.profess_no and f.bsflag='0' ");
		querySub.append(" left join comm_org_information t1 on d.deploy_org = t1.org_id ");
		querySub.append(" left join comm_coding_sort_detail d1 on d.post = d1.coding_code_id ");
		querySub.append(" left join comm_coding_sort_detail d2 on d.apply_team = d2.coding_code_id ");
		querySub.append(" left join comm_coding_sort_detail d3 on d.culture = d3.coding_code_id ");
		querySub.append(" where d.bsflag='0' and f.profess_no='").append(keyId).append("' ");
		querySub.append(" and d.deploy_org in  (select s.org_id from comm_org_subjection s where s.org_subjection_id like 'C105006002%') ");
		
		List sublist = BeanFactory.getQueryJdbcDAO().queryRecords(querySub.toString());
		responseDTO.setValue("subDetailInfo", sublist);
		

		StringBuffer queryAllocate = new StringBuffer(" select t.post_detail_no, t.task_allocation_id, t.employee_id,t.allocate_type,t.notes,t.apply_team,t.post,d1.coding_name apply_teamname,d2.coding_name postname,d3.employee_name ");
		queryAllocate.append(" from bgp_comm_human_allocate_task_a t inner join bgp_project_human_profess_deta d on ");
		queryAllocate.append(" t.post_detail_no = d.post_detail_no ");
//		queryAllocate.append(" and d.deploy_org in  (select c.org_id from comm_org_information c where c.org_name like '东方地球物理公司装备事业部仪器服务中心%') ");
		queryAllocate.append(" inner join bgp_project_human_profess_post p on d.post_no = p.post_no and p.bsflag='0' ");
		queryAllocate.append(" inner join bgp_project_human_profess pr on p.profess_no = pr.profess_no");
		queryAllocate.append("  left join comm_coding_sort_detail d1 on t.apply_team=d1.coding_code_id ");
		queryAllocate.append("  left join comm_coding_sort_detail d2 on t.post=d2.coding_code_id ");
		queryAllocate.append("  left join comm_human_employee d3 on t.employee_id=d3.employee_id ");
		queryAllocate.append(" where pr.profess_no ='").append(keyId).append("' and pr.bsflag='0' ");
		
		List allocatelist = BeanFactory.getQueryJdbcDAO().queryRecords(queryAllocate.toString());
		responseDTO.setValue("allocatelist", allocatelist);
	
		return responseDTO;
	}
	
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg saveHumanAllocate(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();	

		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		String professNo = reqDTO.getValue("professNo");
		// 处理申请单子表信息
		String[] hidDeatilId = {};
		if (reqDTO.getValue("hidDetailId") != null) {
			hidDeatilId = reqDTO.getValue("hidDetailId").split(",");
		}
		for (int j = 0; j < hidDeatilId.length; j++) {
			BeanFactory.getPureJdbcDAO().deleteEntity(
					"bgp_comm_human_allocate_task_a", hidDeatilId[j]);
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
		Map postDetail = new HashMap();
		//存放申请单子表信息
		for (int i = 0; i < equipmentSize; i++) {		
			if (mapFlag.get(String.valueOf(i)) == null) {

				BgpCommHumanAllocateTaskA applyDetail = new BgpCommHumanAllocateTaskA();
					PropertiesUtil.msgToPojo("al" + String.valueOf(i), reqDTO,
							applyDetail);
				mapDetail = PropertiesUtil.describe(applyDetail);
 			    mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modifi_date", new Date());

				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
						"bgp_comm_human_allocate_task_a");
				
				
				postDetail.put("updator", user.getEmpId());
				postDetail.put("modifi_date", new Date());			
				postDetail.put("deploy_flag", "1");		
				postDetail.put("post_detail_no", mapDetail.get("post_detail_no"));		
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(postDetail,
				"bgp_project_human_profess_deta");
				
			}
		} 
	   
		StringBuffer updateSql = new StringBuffer(" update bgp_project_human_profess_deta set deploy_flag = '0'");
		updateSql.append(" where post_detail_no in (select de.post_detail_no  from bgp_project_human_profess_deta de ");
		updateSql.append(" left join bgp_project_human_profess_post po on po.post_no = de.post_no ");
		updateSql.append(" left join bgp_project_human_profess pro on po.profess_no = pro.profess_no ");
		updateSql.append(" where pro.bsflag = '0' and pro.profess_no ='").append(professNo).append("'");
		updateSql.append(" and po.bsflag = '0' and de.bsflag = '0' and pro.proc_status = '3' ");
		updateSql.append(" and de.deploy_flag <> '2' and not exists  (select 1 ");
		updateSql.append(" from bgp_comm_human_allocate_task_a a where a.post_detail_no = de.post_detail_no)) ");
		
		jdbcDao.getJdbcTemplate().update(updateSql.toString());
	
		return responseDTO;
	}
	
	/**
	 * 进入专业化人员调配
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg professPrepareView(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
 
		String keyId = reqDTO.getValue("id");// 申请表主键
		String project_type = reqDTO.getValue("project_type");
		
		// 查询主表信息
		Map map = new HashMap();
		StringBuffer queryPriSql = new StringBuffer(" select r.profess_no,r.project_info_no,t.project_name, ");
		queryPriSql.append(" r.apply_company, to_char(r.apply_date,'yyyy-MM-dd') apply_date,r.applicant_id, ");
		queryPriSql.append(" r.apply_no,r.apply_state,r.notes,s.org_subjection_id,s.org_subjection_id apply_company_sub, ");
		queryPriSql.append(" t1.org_name applicant_org_name,t2.employee_name applicant_name ");
		queryPriSql.append(" from bgp_project_human_profess r ");
		queryPriSql.append(" left join gp_task_project t on r.project_info_no = t.project_info_no and r.bsflag = '0' ");
		queryPriSql.append(" left join comm_org_subjection s on r.apply_company = s.org_id and s.bsflag = '0'  ");
		queryPriSql.append(" left join comm_org_information t1 on r.apply_company = t1.org_id and t1.bsflag = '0' ");
		queryPriSql.append(" left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0' ");
		queryPriSql.append(" where r.profess_no='").append(keyId).append("' ");
	
		map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(queryPriSql.toString());
		responseDTO.setValue("applyInfo", map);
		
		//判断是新增还是查看修改,新增查询需求子表/查看修改查询调配子表。为空时为新增，为true时为修改
		String update = reqDTO.getValue("update");
		String buttonView = "true";
		  if(reqDTO.getValue("buttonView") !=null && reqDTO.getValue("buttonView") !="null" && !"".equals(reqDTO.getValue("buttonView"))){
		   buttonView = reqDTO.getValue("buttonView");
		  }
		  responseDTO.setValue("buttonView", buttonView);
		  
		Map prepareMap = new HashMap();
		//存放调配主表内容
		if (update == null || "".equals(update)) {
			prepareMap.put("applicantName", user.getUserName());
			prepareMap.put("applicantId", user.getEmpId());
			String applyDate = new SimpleDateFormat("yyyy-MM-dd HH:ss")
					.format(new Date());
			prepareMap.put("deployDate", applyDate);
			prepareMap.put("functionType", "3");

		} else {
			// 查询调配主表信息
			String prepareNo = reqDTO.getValue("prepareNo");
			String prepareMapStr =  "select t.prepare_no," +
									"       t.prepare_id," + 
									"       t.applicant_id," + 
									"       to_char(t.deploy_date,'yyyy-MM-dd hh24:mi') deploy_date,t.notes," + 
									"       t.prepare_status,t.function_type,t.prepare_org_id,t.proc_inst_id," + 
									"       t2.employee_name applicant_name,t.spare2,t.spare3" + 
									"  from bgp_human_prepare t" + 
									"  left join comm_human_employee t2 on t.applicant_id = t2.employee_id" + 
									"  and t2.bsflag = '0' and t.bsflag='0' where t.prepare_no='"+prepareNo+"'";
			prepareMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
					prepareMapStr);
			responseDTO.setValue("update", update);

		}
		
		//传调配信息
		responseDTO.setValue("prepareMap", prepareMap);						
		StringBuffer sb = new StringBuffer();
//		if(null != update && !"".equals(update)){		
//			// 修改查询子表信息
//			String prepareNo = reqDTO.getValue("prepareNo");
//			sb.append("select p.prepare_post_detail_no,p.profess_num, p.own_num,   p.deploy_num,p.post,p.people_number,p.audit_number,al.pre_num,p.prepare_number profess_num,p.notes,r.prepare_org_id,s.org_subjection_id prepare_subjection_id, ");
//			sb.append("p.age,p.culture,p.apply_team,p.plan_start_date,p.plan_end_date,p.work_years,p.work_trade_years,p.spare1,d1.coding_name postname, d2.coding_name apply_teamname ");
//			sb.append("from bgp_human_prepare_post_detail p inner join bgp_human_prepare r on p.prepare_no=r.prepare_no and r.bsflag='0' ");
//			sb.append("left join comm_org_subjection s on r.prepare_org_id = s.org_id and s.bsflag = '0' ");
//			sb.append("left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
//			sb.append("left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");
//			sb.append("left join comm_coding_sort_detail d3 on p.culture = d3.coding_code_id ");
//			sb.append("left join (select count(distinct(t.employee_id)) pre_num, t.work_post post ");
//			sb.append("from bgp_human_prepare_human_detail t ");
//			sb.append("inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' ");
//			sb.append("where p.profess_no='").append(keyId).append("' and p.prepare_status = '2' and t.bsflag = '0' group by ");
//			sb.append(" t.work_post) al on al.post= p.post ");
//			sb.append(" where p.bsflag='0' and r.prepare_no='").append(prepareNo).append("' order by p.apply_team,p.post ");
//System.out.println("修改 sql");
//
//
//		}else{
			sb.append("select p.post,al.pre_num, p.notes, ");
			sb.append("p.people_num,p.own_num,p.deploy_num,p.audit_num people_number,p.profess_num,p.audit_own audit_number,p.audit_deploy, ");
			sb.append("p.age,p.culture,p.spare1,p.apply_team,p.plan_start_date,p.plan_end_date,p.work_years,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname ,  p.spare2,p.spare3  ");
			sb.append("from bgp_project_human_profess_post p ");
			sb.append("inner join bgp_project_human_profess r on p.profess_no=r.profess_no ");
			sb.append("left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
			sb.append("left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");
			sb.append("left join comm_coding_sort_detail d3 on p.culture = d3.coding_code_id ");
			sb.append("left join (select count(distinct(t.employee_id)) pre_num , t.work_post post, p.prepare_org_id ");
			sb.append("from bgp_human_prepare_human_detail t ");
			sb.append("inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' ");
			sb.append("where p.profess_no ='").append(keyId).append("' and p.prepare_status = '2' and t.bsflag = '0' group by  p.prepare_org_id, t.work_post ) al on al.post= p.post  ");
			sb.append("and al.prepare_org_id = r.apply_company ");
			sb.append("where p.bsflag='0' and p.profess_no='").append(keyId).append("' order by p.apply_team,p.post ");
			System.out.println("增加 sql");
			//专业化人员查询分解表
			StringBuffer querySub = new StringBuffer(" select  d.post_no, d.post_detail_no,d.apply_team,d.post,d.people_number,d.deploy_org,d.competence,d.age,d.notes, ");
			querySub.append(" d.work_years,d.work_trade_years,d.culture,d.plan_start_date,d.plan_end_date,t1.org_name deploy_org_name,  ");
			querySub.append(" nvl(d3.coding_name,d.culture) culture_name,d1.coding_name postname, d2.coding_name apply_teamname,t1.org_name deploy_org_name,t2.org_subjection_id deploy_sub_id, ");
			querySub.append(" d.deploy_flag, case when d4.num1 > 0 then 'true' else 'false' end de_flag ");
			
			querySub.append(" from bgp_project_human_profess_deta d ");
			querySub.append(" inner join bgp_project_human_profess_post p on d.post_no = p.post_no and p.bsflag='0' ");
			querySub.append(" inner join bgp_project_human_profess f on p.profess_no=f.profess_no and f.bsflag='0' ");
			
			querySub.append(" left join (select count(t.employee_id) al_num , t.work_post post , p.prepare_org_id ");
			querySub.append(" from bgp_human_prepare_human_detail t ");
			querySub.append(" inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' ");
			querySub.append(" where p.profess_no='")
			.append(keyId).append("'  and t.bsflag = '0' group by  p.prepare_org_id,t.work_post ) al ");
			querySub.append(" on al.post= d.post and al.prepare_org_id=d.deploy_org ");
			
			querySub.append(" left join comm_org_information t1 on d.deploy_org = t1.org_id and t1.bsflag='0' ");
			querySub.append(" left join comm_org_subjection t2 on d.deploy_org = t2.org_id and t2.bsflag='0' ");
			

			querySub.append(" left join comm_coding_sort_detail d1 on d.post = d1.coding_code_id ");
			querySub.append(" left join comm_coding_sort_detail d2 on d.apply_team = d2.coding_code_id ");
			querySub.append(" left join comm_coding_sort_detail d3 on d.culture = d3.coding_code_id ");
			querySub.append(" left join (select d.post_detail_no, count(a.employee_id) num1 ");
			querySub.append(" from bgp_comm_human_allocate_task_a a left join bgp_project_human_profess_deta d on d.post_detail_no = a.post_detail_no ");
			querySub.append(" where a.employee_id = '").append(user.getEmpId()).append("' group by d.post_detail_no) d4 ");
			querySub.append(" on d4.post_detail_no = d.post_detail_no");
			//querySub.append(" where d.bsflag='0'   ");  仪器服务中心的 必须经过"任务分配"才能做调配,没有经过任务分配的不能做调配  任务分配完了  那个falg就是1了，这块不是有个模块 是任务分配么  专门给仪器服务中心用的
			querySub.append(" where d.bsflag='0' and d.deploy_flag in ('1','2') ");  
			querySub.append(" and f.profess_no='").append(keyId).append("' ");
			
			List sublist = BeanFactory.getQueryJdbcDAO().queryRecords(querySub.toString());
			responseDTO.setValue("subDetailInfo", sublist);

	//	}
		//新增时查询需求子表,修改时查询调配子表(内容为岗位信息)
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		
		//如果为修改和查看则查询调配人员信息
		if(null != update && !"".equals(update)){	
			String prepareNo = reqDTO.getValue("prepareNo");
			String huamnStr =  "select '0' qufen, t.human_detail_no," +
								"       t.team," + 
								"       t.work_post," + 
								"       t.employee_id," + 
								"       e.employee_name," + 
								"       t.plan_start_date," + 
								"       t.plan_end_date," + 
								"       (t.plan_end_date- t.plan_start_date + 1) plan_days," + 
								"       (t.actual_end_date- t.actual_start_date + 1) actual_days," + 
								"       t.actual_start_date,d1.coding_name work_post_name, d2.coding_name team_name," + 
								"       t.actual_end_date,t.spare1,t.notes " + 
								"  from bgp_human_prepare_human_detail t" + 
								"  inner join bgp_human_prepare r on t.prepare_no = r.prepare_no and r.bsflag='0' " + 
								"  left join comm_coding_sort_detail d1 on t.work_post = d1.coding_code_id"+
		                        "  left join comm_coding_sort_detail d2 on t.team = d2.coding_code_id"+
								"  left join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag='0'"+
								"  where t.prepare_no='"+prepareNo+"'" +
								"  union all  select distinct   '1' qufen,   t.labor_deploy_id as human_detail_no , d2.apply_team as team, d2.post as work_post ,  t.labor_id as employee_id,   l.employee_name,   t.start_date as plan_start_date ,  t.spare4 as  plan_end_date,  (t.spare4 - t.start_date + 1) plan_days,    (t.end_date -  t.actual_start_date + 1) actual_days,    t.actual_start_date,  d4.coding_name work_post_name,    d3.coding_name team_name,  t.end_date as actual_end_date,   t.spare1,  t.notes        from bgp_comm_human_labor_deploy t   left join bgp_comm_human_deploy_detail d2     on t.labor_deploy_id = d2.labor_deploy_id    and d2.bsflag = '0'   left join bgp_comm_human_labor l     on t.labor_id = l.labor_id    left join comm_coding_sort_detail d3     on d2.apply_team = d3.coding_code_id   left join comm_coding_sort_detail d4     on d2.post = d4.coding_code_id    where t.bsflag = '0'  and   t.spare1= '"+prepareNo+"' ";
			List humanInfoList = BeanFactory.getQueryJdbcDAO().queryRecords(huamnStr);
			responseDTO.setValue("humanInfoList", humanInfoList);
		}
		
		responseDTO.setValue("project_type", project_type);		
		return responseDTO;
	}
	
	/**
	 * 专业化人员调配保存
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */

	public ISrvMsg saveProfessPrepare(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		//人员需求主键
		String professNo = reqDTO.getValue("professNo");
		
		String prePrepareNo = reqDTO.getValue("preprepareNo");
		String prenotes = reqDTO.getValue("prenotes");
	 
		BgpHumanPrepare preparePojo = new BgpHumanPrepare();
		PropertiesUtil.msgToPojo("pre", reqDTO, preparePojo);
		Map prepare = new HashMap();
		prepare = PropertiesUtil.describe(preparePojo);
		
		prepare.put("notes", prenotes);
		prepare.put("profess_no", professNo);
		prepare.put("project_info_no", projectInfoNo);
		prepare.put("deploy_date", (String) prepare.get("deploy_date")+":00");
		prepare.put("bsflag", "0");
		prepare.put("updator", user.getEmpId());
		prepare.put("modifi_date", new Date());
		prepare.put("prepare_status", "1");
		//主表bgp_human_prepare主键值保存值
		String preIn = "";
		//处理调配主表信息为空则为新增
		if(prePrepareNo == null || "".equals(prePrepareNo)){
			String prepareId = EquipmentAutoNum.generateNumberByUserToken(
					reqDTO.getUserToken(), "RZTP");
			//设状态为调配中
			prepare.put("creator", user.getEmpId());
			prepare.put("create_date", new Date());
			prepare.put("prepare_id", prepareId);
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(prepare,"bgp_human_prepare");
			preIn = id.toString();
					
		}else{
			preIn = prePrepareNo;
			prepare.put("prepare_no", prePrepareNo);
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(prepare,"bgp_human_prepare");
		}
		
		
		Map postDetail = new HashMap();
		String deployOrgId="";
		if(reqDTO.getValue("postDetailSize") != null){
			int postDetailSize = Integer.parseInt(reqDTO.getValue("postDetailSize"));								
			for (int i = 0; i < postDetailSize; i++) {
					BgpHumanPreparePostDetail prePostDetail = new BgpHumanPreparePostDetail();
					PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
							prePostDetail);
					postDetail = PropertiesUtil.describe(prePostDetail);
					if("true".equals(postDetail.get("flag"))){
						postDetail.put("prepare_no", preIn);
						postDetail.put("bsflag", "0");
						postDetail.put("creator", user.getEmpId());
						postDetail.put("create_date", new Date());
						postDetail.put("updator", user.getEmpId());
						postDetail.put("modifi_date", new Date());

						//BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(postDetail,	"bgp_human_prepare_post_detail");
					}				
			} 
		}
		
		if(reqDTO.getValue("equipmentESize") != null){
			int equipmentESize = Integer.parseInt(reqDTO.getValue("equipmentESize"));
			for (int i = 0; i < equipmentESize; i++) {
				BgpHumanPreparePostDetail prePostDetail = new BgpHumanPreparePostDetail();
				PropertiesUtil.msgToPojo("em" + String.valueOf(i), reqDTO,
						prePostDetail);
				postDetail = PropertiesUtil.describe(prePostDetail);
				if("true".equals(postDetail.get("flag"))){
					deployOrgId = (String)postDetail.get("deploy_org");
					postDetail.put("prepare_no", preIn);
					postDetail.put("bsflag", "0");
					postDetail.put("creator", user.getEmpId());
					postDetail.put("create_date", new Date());
					postDetail.put("updator", user.getEmpId());
					postDetail.put("modifi_date", new Date());
					postDetail.put("deploy_flag", "1");
					 
				//	BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(postDetail,	"bgp_project_human_profess_deta");
				}				
			} 
		}			
		if(deployOrgId != null && !"".equals(deployOrgId)){				
			String sql = "update bgp_human_prepare set prepare_org_id='"+deployOrgId+"' where prepare_no ='"+preIn+"'";
			jdbcDao.getJdbcTemplate().update(sql);
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
		//	System.out.println("hidDeatilId"+hidDeatilId[j]);
		//	hidDeatilIdQufen= hidDeatilId[j].split("-",0);
		//	System.out.println("hidDeatilIdQufen"+hidDeatilIdQufen.toString());
		//	 qufen= hidDeatilId[j].split("-",1);
	 	 System.out.println("qufens"+qufens[j]);
			 
			 if(qufens[j].equals("0")){
				//删除人员岗位信息时,同事更新人员信息表的 调配状态：未调配,和项目状态为：不在项目中
					String sql = "update comm_human_employee_hr set person_status='0', deploy_status='0' ,spare6='', modifi_date = sysdate where employee_id ='"
							+ employeeIds[j]+ "'";
					jdbcDao.executeUpdate(sql);
					
					BeanFactory.getPureJdbcDAO().deleteEntity("bgp_human_prepare_human_detail",hidDeatilId[j]);
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
				PropertiesUtil.msgToPojo("hu" + String.valueOf(i), reqDTO,
						applyDetail);
				mapDetail = PropertiesUtil.describe(applyDetail);
				String printId =mapDetail.get("employee_id").toString();
			 
			    String  psw=mapDetail.get("psw").toString(); 
			//	System.out.println("printId"+printId);
			 
				
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
							mapDetail.put("spare1", "");//否到岗，接收后将改为1到岗
							mapDetail.put("bsflag", "0");
							mapDetail.put("creator", user.getEmpId());
							mapDetail.put("create_date", new Date());
							mapDetail.put("updator", user.getEmpId());
							mapDetail.put("modifi_date", new Date());
							mapDetail.put("between_param", "1");
					 
							BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
									"bgp_human_prepare_human_detail");
							//调配单保存：人员状态 为不在项目 person_status='0';调配状态改为1调配中;是否到岗spare6为空;
							String sql = "update comm_human_employee_hr set person_status='0', deploy_status='1' ,spare6='', modifi_date = sysdate where employee_id ='"+mapDetail.get("employee_id")+"'";
							jdbcDao.getJdbcTemplate().update(sql);
							 
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
											mapLablorDetail.put("between_param", "1"); 
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
							mapDetail.put("between_param", "1");
							
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
											mapLablorNew.put("between_param", "1");
											
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
	 * 查询调配人员时选择人员
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg searchforHumanInfo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = user.getOrgSubjectionId();
		
		String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+orgSubjectionId+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
 
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String father_id = "";
		String sub_id = "";
		String father_organ_flag = "";
		String organ_flag = "";
	 
		int lengthParam = list.size();
		
		if(list.size()>1){
		 	Map map = (Map)list.get(0); 
		 	father_id = (String)map.get("orgSubId");	  
		 	father_organ_flag = (String)map.get("organFlag");	 
		 	 
	 		Map mapOrg = (Map)list.get(1);
		 	sub_id = (String)mapOrg.get("orgSubId");
		 	organ_flag = (String)mapOrg.get("organFlag"); 
		 	
		 	if(father_organ_flag.equals("0")){
		 		orgSubjectionId = "C105";
		 		organ_flag = "0"; 
	 
		 	}else if(father_organ_flag.equals("1")){   //一个organ_flag都是 1 时,单位 
		  
		 		orgSubjectionId=(String)map.get("orgSubId");	 	
		  
		 		if(organ_flag.equals("1")){ //两个organ_flag都是 1 那么是下属单位
		 			orgSubjectionId=(String)mapOrg.get("orgSubId"); 
		 		 
		 		}
		 	} 
		 	
		}else{		 
		
			orgSubjectionId = "C105";
	 		organ_flag = "0";
	  
		}
		
		String org_id = reqDTO.getValue("org_id");
		String employee_name = reqDTO.getValue("employee_name");
		String employee_cd = reqDTO.getValue("employee_cd");
		String post = reqDTO.getValue("post");
		String employee_gender = reqDTO.getValue("employee_gender");
		String set_apply_team = reqDTO.getValue("set_apply_team");
		String set_post = reqDTO.getValue("set_post");
		String person_status = reqDTO.getValue("person_status");
		String deploy_status = reqDTO.getValue("deploy_status");


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

		StringBuffer sb = new StringBuffer("select  '0' qufen,e.employee_id,  e.employee_name, e.employee_gender, decode(e.employee_gender, '0', '女', '1', '男') employee_gender_name,  decode(hr.person_status, '0', '', '1',i1.org_abbreviation , '') relief_org_name,hr.relief_org,  (to_char(sysdate, 'yyyy') -  to_char(e.employee_birth_date, 'yyyy')) age, e.org_id,  i.org_abbreviation,  i.org_name,  hr.post, hr.spare2,   hr.employee_cd,hr.set_team,hr.set_post,d1.coding_name set_team_name,d2.coding_name set_post_name,decode((to_char(sysdate, 'yyyy') - to_char(hr.work_date, 'yyyy')),  '0', '1',(to_char(sysdate, 'yyyy') - to_char(hr.work_date, 'yyyy'))) work_age,  s.org_subjection_id , decode(nvl(hr.deploy_status,'0'),'0','未调配','1','调配中','2','已调配','') deploy_status_name, nvl(hr.deploy_status,'0') deploy_status, decode(hr.person_status,'0','不在项目','1','在项目','不在项目') person_status ,decode(hr.person_status, '0', '', '1', to_char(t2.plan_end_date,'yyyy-MM-dd'), '') plan_end_date,  t2.team, t2.work_post,t4.actual_start_date,t4.actual_end_date,t4.project_name from comm_human_employee e   inner join comm_human_employee_hr hr on e.employee_id = hr.employee_id   left join comm_org_subjection s on e.org_id = s.org_id   and s.bsflag = '0'   left join comm_org_information i on e.org_id = i.org_id    and i.bsflag = '0'  left join comm_org_information i1 on hr.relief_org = i1.org_id and i1.bsflag = '0'   left join comm_coding_sort_detail d1 on hr.set_team=d1.coding_code_id  left join comm_coding_sort_detail d2 on hr.set_post=d2.coding_code_id left join (select * from (select employee_id,team,work_post, plan_end_date, row_number() over(partition by employee_id order by plan_end_date desc) r  from bgp_human_prepare_human_detail) t1 where t1.r=1) t2 on e.employee_id=t2.employee_id left join (select t3.*,p1.project_name from (select employee_id,project_info_no, actual_start_date,actual_end_date,  row_number() over(partition by employee_id order by actual_start_date desc) r from bgp_project_human_relation where bsflag='0' and locked_if = '1' ) t3 left join gp_task_project p1 on t3.project_info_no = p1.project_info_no  where t3.r = 1) t4 on e.employee_id = t4.employee_id where e.bsflag = '0' ");
		
		if(org_id!= null && !"".equals(org_id)){
			sb.append(" and s.org_subjection_id like '").append(org_id).append("%'");
		}else{
			sb.append(" and s.org_subjection_id like '").append(orgSubjectionId).append("%'");
		}
		if(employee_name!= null && !"".equals(employee_name)){
			sb.append(" and e.employee_name like '%").append(employee_name).append("%'");
		}
		if(employee_cd!= null && !"".equals(employee_cd)){
			sb.append(" and hr.employee_cd like '%").append(employee_cd).append("%'");
		}
		if(post!= null && !"".equals(post)){
			sb.append(" and hr.post like '%").append(post).append("%'");
		}
		if(employee_gender!= null && !"".equals(employee_gender)){
			sb.append(" and e.employee_gender = '").append(employee_gender).append("'");
		}
		if(set_apply_team!= null && !"".equals(set_apply_team)){
			sb.append(" and hr.set_team = '").append(set_apply_team).append("'");
		}
		if(set_post!= null && !"".equals(set_post)){
			sb.append(" and hr.set_post = '").append(set_post).append("'");
		}
		if(person_status!= null && !"".equals(person_status)){
			sb.append(" and hr.person_status = '").append(person_status).append("'");
		}
		if(deploy_status!= null && !"".equals(deploy_status)){
			sb.append(" and hr.deploy_status = '").append(deploy_status).append("'");
		} 
		sb.append(" order by i.org_name desc, hr.deploy_status asc ");
		
		StringBuffer humanSql = new StringBuffer();
		humanSql.append("select * from (select datas.*,rownum rownum_ from (");
		humanSql.append(sb.toString());
		humanSql.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
		
		List datas=BeanFactory.getQueryJdbcDAO().queryRecords(humanSql.toString());

		humanSql = new StringBuffer();
		humanSql.append("select count(1) count from ( ");
		humanSql.append(sb.toString()).append(")");
																								
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
	 * 查询调配临时工人员时选择人员
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg searchforLaborInfo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = user.getOrgSubjectionId();
		String orgSubjectionIdCode = user.getSubOrgIDofAffordOrg();
		String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+orgSubjectionId+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
 
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		String father_id = "";
		String sub_id = "";
		String father_organ_flag = "";
		String organ_flag = "";
	 
		int lengthParam = list.size();
		
		if(list.size()>1){
		 	Map map = (Map)list.get(0); 
		 	father_id = (String)map.get("orgSubId");	  
		 	father_organ_flag = (String)map.get("organFlag");	 
		 	 
	 		Map mapOrg = (Map)list.get(1);
		 	sub_id = (String)mapOrg.get("orgSubId");
		 	organ_flag = (String)mapOrg.get("organFlag"); 
		 	
		 	if(father_organ_flag.equals("0")){
		 		orgSubjectionId = "C105";
		 		organ_flag = "0"; 
	 
		 	}else if(father_organ_flag.equals("1")){   //一个organ_flag都是 1 时,单位 
		  
		 		orgSubjectionId=(String)map.get("orgSubId");	 	
		  
		 		if(organ_flag.equals("1")){ //两个organ_flag都是 1 那么是下属单位
		 			orgSubjectionId=(String)mapOrg.get("orgSubId"); 
		 		 
		 		}
		 	} 
		 	
		}else{		 
		
			orgSubjectionId = "C105";
	 		organ_flag = "0";
	  
		}
		
		String org_id = reqDTO.getValue("org_id");
		System.out.println(org_id);
		String employee_name = reqDTO.getValue("employee_name");
		String employee_cd = reqDTO.getValue("employee_cd");
 
		String employee_gender = reqDTO.getValue("employee_gender");
		String set_apply_team = reqDTO.getValue("set_apply_team");
		String set_post = reqDTO.getValue("set_post");
		String person_status = reqDTO.getValue("person_status");
		String spare = reqDTO.getValue("spare");
		  

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

		StringBuffer sb = new StringBuffer("select distinct l.* ,    d3.coding_name posts,    d4.coding_name apply_teams   from (select  '1' qufen,   l.bsflag, nvl(l.spare1,0) spare1,  l.labor_id employee_id,   l.employee_name,   decode(l.spare1,  '0',   '待调配', '1',   '调配中', '2',  '已调配',  '待调配') spare_Name,  (to_char(sysdate, 'yyyy') - to_char(l.employee_birth_date, 'yyyy')) age,         t4.actual_start_date,    t4.end_date,   t4.project_name,    i.org_abbreviation org_names,   d7.coding_name  labor_category_name,   nvl(t1.post, l.post) post,  nvl(t1.apply_team, l.apply_team) apply_team,   l.employee_nation,   d1.coding_name employee_nation_name,   l.employee_gender,   l.owning_org_id,   l.owning_subjection_org_id,   decode(l.employee_gender, '0',  '女',  '1',   '男',  l.employee_gender) employee_gender_name,   decode(nvl(l.if_project, 0),  '0',  '不在项目',   '1',  '在项目',  l.if_project) if_project_name,   l.if_project,   l.if_engineer,   d5.coding_name if_engineer_name,   l.cont_num,   l.employee_birth_date,   l.employee_id_code_no,   l.employee_education_level,   d2.coding_name employee_education_level_name,   l.employee_address,   l.phone_num,   l.employee_health_info,   l.specialty,   l.elite_if,   l.workerfrom,   nvl(t.years, 0) years,   l.create_date,   cft.coding_code as dalei,   cft.coding_code_id as xiaolei   from bgp_comm_human_labor l  left join  bgp_comm_human_labor_list lt  on l.labor_id = lt.labor_id  and lt.list_id is null  left join (select d2.*     from (select d1.*    from (select d.apply_team,    d.post,    l1.labor_id,  row_number() over(partition by l1.labor_id order by l1.start_date desc) numa          from bgp_comm_human_deploy_detail d      left join bgp_comm_human_labor_deploy l1   on d.labor_deploy_id =   l1.labor_deploy_id    where d.bsflag = '0') d1   where d1.numa = 1) d2) t1 on l.labor_id = t1.labor_id left join comm_coding_sort_detail d1 on l.employee_nation = d1.coding_code_id  left join comm_coding_sort_detail d2  on l.employee_education_level = d2.coding_code_id  left join comm_coding_sort_detail d5  on l.if_engineer = d5.coding_code_id  left join comm_org_subjection cn  on l.owning_org_id = cn.org_id  and cn.bsflag = '0'    left join comm_org_information i   on cn.org_id = i.org_id   and i.bsflag='0'   left join (select count(distinct   to_char(t.start_date, 'yyyy')) years,  t.labor_id      from bgp_comm_human_labor_deploy t    group by t.labor_id) t on l.labor_id = t.labor_id  left join bgp_comm_human_certificate cft  on cft.employee_id = l.labor_id  and cft.bsflag = '0'  left join ( select t3.*, p1.project_name    from (select labor_id,    project_info_no,     nvl(actual_start_date,start_date)actual_start_date,    end_date,    row_number() over(partition by labor_id order by start_date desc) r         from bgp_comm_human_labor_deploy    where bsflag = '0'   ) t3   left join gp_task_project p1       on t3.project_info_no = p1.project_info_no   where t3.r = 1) t4   on l.labor_id = t4.labor_id    left join comm_coding_sort_detail d7    on l.if_engineer = d7.coding_code_id  ) l     left join comm_coding_sort_detail d3    on l.post = d3.coding_code_id  left join comm_coding_sort_detail d4    on l.apply_team = d4.coding_code_id   where l.bsflag = '0' ");
		
		if(org_id!= null && !"".equals(org_id)){
			sb.append(" and l.owning_subjection_org_id like '").append(org_id).append("%'");
		}else{
			sb.append(" and l.owning_subjection_org_id like '").append(orgSubjectionIdCode).append("%'");
		}
		if(employee_name!= null && !"".equals(employee_name)){
			sb.append(" and l.employee_name like '%").append(employee_name).append("%'");
		}
		if(employee_cd!= null && !"".equals(employee_cd)){
			sb.append(" and l.employee_id_code_no like '%").append(employee_cd).append("%'");
		}
	 
		if(employee_gender!= null && !"".equals(employee_gender)){
			sb.append(" and l.employee_gender = '").append(employee_gender).append("'");
		}
		if(set_apply_team!= null && !"".equals(set_apply_team)){
			sb.append(" and l.apply_team = '").append(set_apply_team).append("'");
		}
		if(set_post!= null && !"".equals(set_post)){
			sb.append(" and l.post = '").append(set_post).append("'");
		}
		if(person_status!= null && !"".equals(person_status)){
			sb.append(" and l.if_project = '").append(person_status).append("'");
		}
		 
		if(spare!= null && !"".equals(spare)){
			sb.append(" and l.spare1 = '").append(spare).append("'");
		} 
		 
		
		sb.append(" order by  l.employee_name asc, l.spare1 asc  ");
		
		StringBuffer humanSql = new StringBuffer();
		humanSql.append("select * from (select datas.*,rownum rownum_ from (");
		humanSql.append(sb.toString());
		humanSql.append(") datas where rownum <= ").append(rowEnd).append(") where rownum_ > ").append(rowStart);
		
		List datas=BeanFactory.getQueryJdbcDAO().queryRecords(humanSql.toString());

		humanSql = new StringBuffer();
		humanSql.append("select count(1) count from ( ");
		humanSql.append(sb.toString()).append(")");
																								
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
		String yorn = reqDTO.getValue("yorn");


		String employeeName = reqDTO.getValue("employeeName");
		String apply_team = reqDTO.getValue("apply_team");
		String codeId = reqDTO.getValue("codeId");
		String post = reqDTO.getValue("post");
		
		StringBuffer sql = new StringBuffer(
				"select d.*,cd3.coding_name project_evaluate, (d.plan_end_date-d.plan_start_date +1) days,e.employee_name,t.project_name,p.project_info_no,cd.coding_name team_name, cd2.coding_name work_post_name,h.employee_hr_id,h.employee_cd,h.spare2 employee_spare2_id, ");
		if (orgSubjectionId != null && orgSubjectionId.length() > 6 && orgSubjectionId.substring(0, 7).startsWith("C105006")) {
			sql.append(" su.org_id ");
		} else {
			sql.append(" su.org_id,su1.org_id reorg_id ");
		}
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
		sql.append(" left join comm_coding_sort_detail cd on d.team = cd.coding_code_id ");
		sql.append(" left join comm_coding_sort_detail cd2 on d.work_post = cd2.coding_code_id ");
		sql.append(" left join comm_coding_sort_detail cd3 on r.project_evaluate = cd3.coding_code_id ");
		sql.append(" where p.bsflag = '0'   and d.bsflag='0' ").append(" and p.project_info_no = '").append(projectInfoNo).append("' ");

		if (orgSubjectionId != null && orgSubjectionId.length() > 6 && orgSubjectionId.substring(0, 7).startsWith("C105006")) {
			sql.append(" and su.org_subjection_id like '").append(orgSubjectionId)
					.append("%' and p.requirement_no is null and p.human_relief_no is null  and p.proc_status='3' ");
		} else {
			sql.append(" and (su.org_subjection_id like '").append(orgSubjectionId).append("%' or su1.org_subjection_id like '")
					.append(orgSubjectionId).append("%') ");
			sql.append(" and (p.spare2='2' or p.spare2 is null )");
			sql.append(" and p.profess_no is null ");
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
		
		if (employeeName != null) {
			sql.append(" and e.employee_name like'%").append(employeeName).append("%' ");
		}  
		if (apply_team != null) {
			sql.append(" and d.team='").append(apply_team).append("' ");
		} 
		if (codeId != null) {
			sql.append(" and h.employee_cd like'%").append(codeId).append("%' ");
		} 
		if (post != null) {
			sql.append(" and d.work_post='").append(post).append("' ");
		} 
	  

		sql.append(" order by e.employee_name ");
		
//		List<Map> list = jdbcDAO.queryRecords(sql.toString());
//		if (list != null) {
//			responseMsg.setValue("humanMap", list);
//		}


		
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
	//专业化人员接收查询
public ISrvMsg queryZHumanAcceptReturnList(ISrvMsg reqDTO) throws Exception {
		

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = user.getOrgSubjectionId();
				
		String projectInfoNo = reqDTO.getValue("projectInfoNo");  
		String yorn = reqDTO.getValue("yorn");  //接收状态
		String employeeName = reqDTO.getValue("employeeName");
		String apply_team = reqDTO.getValue("apply_team");
		String codeId = reqDTO.getValue("codeId");
		String post = reqDTO.getValue("post");
		String ids = reqDTO.getValue("ids");
		
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
	 	 // 自己项目人员		
		StringBuffer sql = new StringBuffer(
				" select * from ( select '0' sz_type,'0' type_param,  '正式工' type_name,e.project_evaluate,e.spare2,e.reorg_id,e.org_id,e.project_info_no,e.days, e.employee_hr_id  deploy_detail_id,  e.human_detail_no,  e.employee_id,  e.employee_cd,  e.employee_name,  e.team_name,  e.work_post_name,  e.plan_start_date,  e.plan_end_date,  e.actual_start_date,  e.actual_end_date,  e.team,  e.work_post  from (select distinct d.*,  p.project_info_no,  h.employee_cd,  e.employee_name,  cd.coding_name    team_name,  cd2.coding_name   work_post_name,   cd3.coding_name project_evaluate,  (d.plan_end_date - d.plan_start_date + 1) days,  h.employee_hr_id,  h.spare2         employee_spare2_id,  su.org_id,  su1.org_id       reorg_id  from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p  on d.prepare_no = p.prepare_no  and p.prepare_status = '2'  left join bgp_project_human_relation r  on d.employee_id = r.employee_id  and p.project_info_no = r.project_info_no  and r.team = d.team  and r.work_post = d.work_post  left join common_busi_wf_middle te  on te.business_id = p.prepare_no  and te.bsflag = '0'  left join bgp_project_human_profess pr1  on pr1.profess_no = p.profess_no  and p.profess_no is not null  and pr1.bsflag = '0'  left join comm_org_subjection su2  on pr1.apply_company = su2.org_id  left join bgp_project_human_requirement pr  on pr.requirement_no = p.requirement_no  and p.requirement_no is not null  and pr.bsflag = '0'  left join comm_org_subjection su  on pr.apply_company = su.org_id  left join bgp_project_human_relief re  on re.human_relief_no = p.human_relief_no  and p.human_relief_no is not null  and re.bsflag = '0'  left join comm_org_subjection su1  on re.apply_company = su1.org_id  left join comm_human_employee e  on d.employee_id = e.employee_id  left join comm_human_employee_hr h  on d.employee_id = h.employee_id  left join comm_coding_sort_detail cd  on d.team = cd.coding_code_id  and cd.bsflag = '0'  and cd.coding_mnemonic_id='"+projectType+"'  left join comm_coding_sort_detail cd2  on d.work_post = cd2.coding_code_id  and cd2.bsflag = '0'  and cd2.coding_mnemonic_id='"+projectType+"'   left join comm_coding_sort_detail cd3  on r.project_evaluate = cd3.coding_code_id     ");
 
		sql.append(" where p.bsflag = '0'  and d.between_param='1'  and d.bsflag='0' ").append(" and p.project_info_no = '").append(projectInfoNo).append("' ");
		sql.append(" and ( te.business_id is null or te.proc_status='3' ) ");
 
		//区分 弹出的接收父项目人员的页面
		if (szFather == "0" || "0".equals(szFather)) {
			sql.append("and d.project_father_no is  null ");
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
		
		if (employeeName != null) {
			sql.append(" and e.employee_name like'%").append(employeeName).append("%' ");
		}  
		if (apply_team != null) {
			sql.append(" and d.team='").append(apply_team).append("' ");
		} 
		if (codeId != null) {
			sql.append(" and h.employee_cd like'%").append(codeId).append("%' ");
		} 
		if (post != null) {
			sql.append(" and d.work_post='").append(post).append("' ");
		} 
		 
		
		if (ids != null && !"".equals(ids)) {
			sql.append("and d.human_detail_no in (").append(ids).append(") ");
		}

		sql.append(" order by e.employee_name   ) e   union all   ");
		
		sql.append(" select '0' sz_type, '1' type_param ,'临时工' type_name,'' project_evaluate,'' spare2,'' reorg_id,'' org_id,ttt.project_info_no,ttt.days,ttt.deploy_detail_id,ttt.labor_deploy_id human_detail_no ,ttt.labor_id employee_id ,ttt.employee_id_code_no  employee_cd,ttt.employee_name,ttt.team_name,ttt.work_post_name,ttt.start_date plan_start_date ,ttt.plan_end_date ,  ttt.actual_start_date, ttt.actual_end_date ,  ttt.team,ttt.work_post  from (select distinct t.labor_deploy_id,  t.labor_id,    l.employee_name,  l.employee_id_code_no,  t.project_info_no,  t.start_date,  l.cont_num,  t.end_date,  to_date(to_char(t.spare4, 'yyyy-MM-dd'), 'yyyy-MM-dd') plan_end_date ,t.end_date actual_end_date,  case  when clr.receive_no is null then  t.actual_start_date  else  nvl(t.actual_start_date, t.start_date)  end actual_start_date,  d2.deploy_detail_id,  d2.apply_team team,  d2.post work_post,     d3.coding_name team_name,  d4.coding_name work_post_name,  round(case  when nvl(t.spare4, sysdate) - t.start_date > 0 then  nvl(t.spare4, sysdate) - t.start_date - (-1)  else  0  end) days,  to_date(to_char(t.create_date, 'yyyy-MM-dd'),  'yyyy-MM-dd') create_dates  from bgp_comm_human_labor_deploy t  left join bgp_comm_human_deploy_detail d2  on t.labor_deploy_id = d2.labor_deploy_id  and d2.bsflag = '0'  left join bgp_comm_human_labor l  on t.labor_id = l.labor_id  left join comm_coding_sort_detail d3  on d2.apply_team = d3.coding_code_id  and d3.bsflag = '0'  and d3.coding_mnemonic_id='"+projectType+"'   left join comm_coding_sort_detail d4  on d2.post = d4.coding_code_id  and d4.bsflag = '0'  and d4.coding_mnemonic_id='"+projectType+"'  left join bgp_comm_human_receive_labor clr  on clr.deploy_detail_id = d2.deploy_detail_id  and clr.bsflag = '0'  ");
		sql.append(" where   t.bsflag = '0' and t.between_param='1'    and t.project_info_no ='").append(projectInfoNo).append("' ");
		
		if (employeeName != null) {
			sql.append(" and l.employee_name like'%").append(employeeName).append("%' ");
		}  
		if (apply_team != null) {
			sql.append(" and d2.apply_team='").append(apply_team).append("' ");
		} 
		if (post != null) {
			sql.append(" and d2.post='").append(post).append("' ");
		} 
		
		//区分 弹出的接收父项目人员的页面
		if (szFather == "0" || "0".equals(szFather)) {
			sql.append("and t.project_father_no is  null ");
		}
		
		
		// 已返还
		if (yorn == "3" || "3".equals(yorn)) {
			sql.append("and t.end_date is not null ");
		} 
		if (yorn == "4" || "4".equals(yorn)) {
 
			if(projectTypeJz.equals("5000100004000000008") || projectTypeJz.equals("5000100004000000009") ){
				sql.append("and t.end_date is null  and  t.actual_start_date  is not null ");
			}else{ 
				sql.append("and t.end_date is null  and clr.receive_no is not null ");
			}
			 
			
		} 
		
 
		
//		// 未接收
//		if (yorn == "2" || "2".equals(yorn)) {
//			sql.append(" and t.end_date is null  and clr.receive_no is   null  ");
//		}
//		 
//		// 已接收
//		if (yorn == "1" || "1".equals(yorn)) { 
//		 
//				sql.append(" and clr.receive_no is not null ");
//			 
//		}
		

		// 未接收
		if (yorn == "2" || "2".equals(yorn)) { 
			
			if(projectTypeJz.equals("5000100004000000008") || projectTypeJz.equals("5000100004000000009")){
				sql.append("and t.end_date is null  and  t.actual_start_date  is  null ");
			}else{ 
				sql.append(" and t.end_date is null  and clr.receive_no is   null  ");
			} 
			
		}
		 
		// 已接收
		if (yorn == "1" || "1".equals(yorn)) { 
			
			if(projectTypeJz.equals("5000100004000000008") || projectTypeJz.equals("5000100004000000009")){
				sql.append("and t.end_date is null  and  t.actual_start_date  is not null ");
			}else{ 
				sql.append(" and clr.receive_no is not null ");
			}
			
		}
		
		if (ids != null && !"".equals(ids)) {
			sql.append("and t.labor_deploy_id in (").append(ids).append(") ");
		}
		if (codeId != null) {
			sql.append(" and l.employee_id_code_no like'%").append(codeId).append("%' ");
		} 
		
		sql.append("   order by l.employee_name ) ttt  ) bxm    ");
		
		if (szFather == null || szFather.trim().equals("")) { 
			 if (fatherId !=null && !"".equals(fatherId)){  // 父项目人员
				 
				    sql.append(" union all  select * from ( select '1' sz_type,'0' type_param,  '正式工' type_name,e.project_evaluate,e.spare2,e.reorg_id,e.org_id,e.project_info_no,e.days, e.employee_hr_id  deploy_detail_id,  e.human_detail_no,  e.employee_id,  e.employee_cd,  e.employee_name,  e.team_name,  e.work_post_name,  e.plan_start_date,  e.plan_end_date,  e.actual_start_date,  e.actual_end_date,  e.team,  e.work_post  from (select distinct d.*,  p.project_info_no,  h.employee_cd,  e.employee_name,  cd.coding_name    team_name,  cd2.coding_name   work_post_name,   cd3.coding_name project_evaluate,  (d.plan_end_date - d.plan_start_date + 1) days,  h.employee_hr_id,  h.spare2         employee_spare2_id,  su.org_id,  su1.org_id       reorg_id  from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p  on d.prepare_no = p.prepare_no  and p.prepare_status = '2'  left join bgp_project_human_relation r  on d.employee_id = r.employee_id  and p.project_info_no = r.project_info_no  and r.team = d.team  and r.work_post = d.work_post  left join common_busi_wf_middle te  on te.business_id = p.prepare_no  and te.bsflag = '0'  left join bgp_project_human_profess pr1  on pr1.profess_no = p.profess_no  and p.profess_no is not null  and pr1.bsflag = '0'  left join comm_org_subjection su2  on pr1.apply_company = su2.org_id  left join bgp_project_human_requirement pr  on pr.requirement_no = p.requirement_no  and p.requirement_no is not null  and pr.bsflag = '0'  left join comm_org_subjection su  on pr.apply_company = su.org_id  left join bgp_project_human_relief re  on re.human_relief_no = p.human_relief_no  and p.human_relief_no is not null  and re.bsflag = '0'  left join comm_org_subjection su1  on re.apply_company = su1.org_id  left join comm_human_employee e  on d.employee_id = e.employee_id  left join comm_human_employee_hr h  on d.employee_id = h.employee_id  left join comm_coding_sort_detail cd  on d.team = cd.coding_code_id  and cd.bsflag = '0'  and cd.coding_mnemonic_id='"+projectType+"'  left join comm_coding_sort_detail cd2  on d.work_post = cd2.coding_code_id  and cd2.bsflag = '0'  and cd2.coding_mnemonic_id='"+projectType+"'   left join comm_coding_sort_detail cd3  on r.project_evaluate = cd3.coding_code_id     ");
					 
					sql.append(" where p.bsflag = '0'  and d.between_param='1'  and d.bsflag='0'  and   d.project_father_no='").append(projectInfoNo).append("'  and p.project_info_no = '").append(fatherId).append("' ");
					sql.append(" and ( te.business_id is null or te.proc_status='3' ) ");
			  	
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
					
					if (employeeName != null) {
						sql.append(" and e.employee_name like'%").append(employeeName).append("%' ");
					}  
					if (apply_team != null) {
						sql.append(" and d.team='").append(apply_team).append("' ");
					} 
					if (codeId != null) {
						sql.append(" and h.employee_cd like'%").append(codeId).append("%' ");
					} 
					if (post != null) {
						sql.append(" and d.work_post='").append(post).append("' ");
					} 
					 
					
					if (ids != null && !"".equals(ids)) {
						sql.append("and d.human_detail_no in (").append(ids).append(") ");
					}

					sql.append(" order by e.employee_name   ) e   union all   ");
					
					sql.append(" select '1' sz_type, '1' type_param ,'临时工' type_name,'' project_evaluate,'' spare2,'' reorg_id,'' org_id,ttt.project_info_no,ttt.days,ttt.deploy_detail_id,ttt.labor_deploy_id human_detail_no ,ttt.labor_id employee_id ,ttt.employee_id_code_no  employee_cd,ttt.employee_name,ttt.team_name,ttt.work_post_name,ttt.start_date plan_start_date ,ttt.plan_end_date ,  ttt.actual_start_date, ttt.actual_end_date ,  ttt.team,ttt.work_post  from (select distinct t.labor_deploy_id,  t.labor_id,    l.employee_name,  l.employee_id_code_no,  t.project_info_no,  t.start_date,  l.cont_num,  t.end_date,  to_date(to_char(t.spare4, 'yyyy-MM-dd'), 'yyyy-MM-dd') plan_end_date ,t.end_date actual_end_date,  case  when clr.receive_no is null then  t.actual_start_date  else  nvl(t.actual_start_date, t.start_date)  end actual_start_date,  d2.deploy_detail_id,  d2.apply_team team,  d2.post work_post,     d3.coding_name team_name,  d4.coding_name work_post_name,  round(case  when nvl(t.spare4, sysdate) - t.start_date > 0 then  nvl(t.spare4, sysdate) - t.start_date - (-1)  else  0  end) days,  to_date(to_char(t.create_date, 'yyyy-MM-dd'),  'yyyy-MM-dd') create_dates  from bgp_comm_human_labor_deploy t  left join bgp_comm_human_deploy_detail d2  on t.labor_deploy_id = d2.labor_deploy_id  and d2.bsflag = '0'  left join bgp_comm_human_labor l  on t.labor_id = l.labor_id  left join comm_coding_sort_detail d3  on d2.apply_team = d3.coding_code_id  and d3.bsflag = '0'  and d3.coding_mnemonic_id='"+projectType+"'   left join comm_coding_sort_detail d4  on d2.post = d4.coding_code_id  and d4.bsflag = '0'  and d4.coding_mnemonic_id='"+projectType+"'  left join bgp_comm_human_receive_labor clr  on clr.deploy_detail_id = d2.deploy_detail_id  and clr.bsflag = '0'  ");
					sql.append(" where   t.bsflag = '0' and t.between_param='1'  and   t.project_father_no='").append(projectInfoNo).append("'  and t.project_info_no = '").append(fatherId).append("'  ");
					
					if (employeeName != null) {
						sql.append(" and l.employee_name like'%").append(employeeName).append("%' ");
					}  
					if (apply_team != null) {
						sql.append(" and d2.apply_team='").append(apply_team).append("' ");
					} 
					if (post != null) {
						sql.append(" and d2.post='").append(post).append("' ");
					} 
 
					// 已返还
					if (yorn == "3" || "3".equals(yorn)) {
						sql.append("and t.end_date is not null ");
					} 
					if (yorn == "4" || "4".equals(yorn)) {
			 
						if(projectTypeJz.equals("5000100004000000008") || projectTypeJz.equals("5000100004000000009")){
							sql.append("and t.end_date is null  and  t.actual_start_date  is not null ");
						}else{ 
							sql.append("and t.end_date is null  and clr.receive_no is not null ");
						}
						 
						
					} 
					
					// 未接收
					if (yorn == "2" || "2".equals(yorn)) { 
						
						if(projectTypeJz.equals("5000100004000000008") || projectTypeJz.equals("5000100004000000009")){
							sql.append("and t.end_date is null  and  t.actual_start_date  is  null ");
						}else{ 
							sql.append(" and t.end_date is null  and clr.receive_no is   null  ");
						}
						
						
					}
					 
					// 已接收
					if (yorn == "1" || "1".equals(yorn)) { 
						
						if(projectTypeJz.equals("5000100004000000008") || projectTypeJz.equals("5000100004000000009") ){
							sql.append("and t.end_date is null  and  t.actual_start_date  is not null ");
						}else{ 
							sql.append(" and clr.receive_no is not null ");
						}
						
					}
					
					if (ids != null && !"".equals(ids)) {
						sql.append("and t.labor_deploy_id in (").append(ids).append(") ");
					}
					if (codeId != null) {
						sql.append(" and l.employee_id_code_no like'%").append(codeId).append("%' ");
					} 
					
					sql.append("   order by l.employee_name ) ttt  ) fxm    ");
					
					
			 }
		}
		
		List<Map> list =  BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		page = jdbcDAO.queryRecordsBySQL(sql.toString(), page);
		
		list = page.getData();
		msg.setValue("datas", list);
		msg.setValue("yorn", yorn); 
		msg.setValue("projectInfoNo", projectInfoNo);	 
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
	 
		
		return msg;
	}


	//人员接收返还查询
	public ISrvMsg queryHumanAcceptReturnList(ISrvMsg reqDTO) throws Exception {
		

		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String orgSubjectionId = user.getOrgSubjectionId();
				
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String yorn = reqDTO.getValue("yorn");
		String employeeName = reqDTO.getValue("employeeName");
		String apply_team = reqDTO.getValue("apply_team");
		String codeId = reqDTO.getValue("codeId");
		String post = reqDTO.getValue("post");
		String ids = reqDTO.getValue("ids");
		String paramsType = reqDTO.getValue("paramsType");
		String zyType = reqDTO.getValue("zyType");
		
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
	 	 // 自己项目人员
		StringBuffer sql = new StringBuffer(
				"select d.* from  (   select 'add' emp_type, dt.ptdetail_id human_detail_no,dt.ptransfer_id prepare_no,dt.employee_id,dt.creator,dt.create_date,dt.updator,dt.modifi_date,dt.bsflag,dt.locked_if,dt.notes,dt.spare1,dt.spare2,dt.spare3,dt.spare4,dt.spare5,dt.start_date plan_start_date,nvl(dt.end_date,sysdate) plan_end_date,dt.start_date actual_start_date,dt.end_date actual_end_date,dt.team_s team,dt.post_s work_post,'' team_updator, sysdate team_modifi_date,'' between_param,'' project_father_no, ''job_id ,'' zy_type , case  when dt.locked_if  is null  then '' else 'disabled' end disasss,     '' zy_sf,  '0' sz_type, cd3.coding_name project_evaluate,round(case  when nvl(dt.end_date, sysdate) -   dt.start_date > 0 then   nvl(dt.end_date, sysdate) - dt.start_date - (-1)   else     0    end) days,dt.employee_name,t.project_name,t.project_info_no,  dt.team_name,dt.work_post_name,h.employee_hr_id, dt.employee_gz,dt.employee_cd, '' employee_spare2_id ,'' org_id,'' reorg_id   from  BGP_COMM_HUMAN_PT_DETAIL dt    left join comm_coding_sort_detail cd3 on dt.notes = cd3.coding_code_id  left join comm_human_employee_hr h on dt.employee_id = h.employee_id    left join gp_task_project t on dt.bproject_info_no= t.project_info_no  where dt.bsflag='0' and  dt.pk_ids='add' and dt.bproject_info_no='").append(projectInfoNo).append("'  "); 
	 
		    sql.append("union  all select distinct  'edit' emp_type,  d.*,case  when d.zy_type  is null  then '' else 'disabled' end disasss, case  when d.zy_type  is null  then '' else '是' end zy_sf,'0' sz_type,cd3.coding_name project_evaluate, (d.plan_end_date-d.plan_start_date +1) days,e.employee_name,t.project_name,p.project_info_no,cd.coding_name team_name, cd2.coding_name work_post_name,h.employee_hr_id,h.employee_gz,h.employee_cd,h.spare2 employee_spare2_id, ");
//		if (orgSubjectionId != null && orgSubjectionId.length() > 6 && orgSubjectionId.substring(0, 7).startsWith("C105006")) {
//			sql.append(" su.org_id ");
//		} else {
			sql.append(" su.org_id,su1.org_id reorg_id ");
//		}
		sql.append(" from bgp_human_prepare_human_detail d ");
		sql.append(" inner join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.prepare_status='2'  ");
		sql.append(" left join bgp_project_human_relation r on d.employee_id = r.employee_id  and p.project_info_no = r.project_info_no and r.team=d.team and r.work_post=d.work_post ");
		sql.append(" left join common_busi_wf_middle te on te.business_id=p.prepare_no and te.bsflag='0' ");
//		if (orgSubjectionId != null && orgSubjectionId.length() > 6 && orgSubjectionId.substring(0, 7).startsWith("C105006")) {
			sql.append(" left join bgp_project_human_profess pr1 on pr1.profess_no=p.profess_no and p.profess_no is not null and pr1.bsflag='0' ");
			sql.append(" left join comm_org_subjection su2 on pr1.apply_company=su2.org_id ");
//		} else {
			sql.append(" left join bgp_project_human_requirement pr on pr.requirement_no=p.requirement_no and p.requirement_no is not null and pr.bsflag='0'  ");
			sql.append(" left join comm_org_subjection su on pr.apply_company=su.org_id ");
			sql.append(" left join bgp_project_human_relief re on re.human_relief_no=p.human_relief_no and p.human_relief_no is not null and re.bsflag='0'  ");
			sql.append(" left join comm_org_subjection su1 on re.apply_company=su1.org_id ");
//		}
		sql.append(" left join comm_human_employee e on d.employee_id = e.employee_id ");
		sql.append(" left join comm_human_employee_hr h on d.employee_id = h.employee_id ");
		sql.append(" left join gp_task_project t on p.project_info_no = t.project_info_no ");
		sql.append(" left join comm_coding_sort_detail cd on d.team = cd.coding_code_id  and cd.bsflag='0' and cd.coding_mnemonic_id='"+projectType+"'");
		sql.append(" left join comm_coding_sort_detail cd2 on d.work_post = cd2.coding_code_id  and cd2.bsflag='0' and cd2.coding_mnemonic_id='"+projectType+"'");
		sql.append(" left join comm_coding_sort_detail cd3 on r.project_evaluate = cd3.coding_code_id ");
		sql.append(" where p.bsflag = '0' and d.between_param  is null   and d.bsflag='0' ").append(" and p.project_info_no = '").append(projectInfoNo).append("' ");
		sql.append(" and ( te.business_id is null or te.proc_status='3' ) )  d  where 1 = 1 ");

//		if (orgSubjectionId != null && orgSubjectionId.length() > 6 && orgSubjectionId.substring(0, 7).startsWith("C105006")) {
//			sql.append(" and su.org_subjection_id like '").append(orgSubjectionId)
//					.append("%' and p.requirement_no is null and p.human_relief_no is null  and p.proc_status='3' ");
//		} else {
//			sql.append(" and (su.org_subjection_id like '").append(orgSubjectionId).append("%' or su1.org_subjection_id like '")
//					.append(orgSubjectionId).append("%') ");
//			sql.append(" and (p.spare2='2' or p.spare2 is null )");
//			sql.append(" and p.profess_no is null ");
//		}
		//区分 弹出的接收父项目人员的页面
	 
		if (szFather == "0" || "0".equals(szFather)) {
			sql.append("and d.project_father_no is  null ");
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
			sql.append("and d.actual_end_date is not null  ");
		}
		// 未返还
		if (yorn == "4" || "4".equals(yorn)) {
			sql.append("and d.actual_start_date is not null and (d.spare2 = '0' or d.spare2 is null) and d.actual_end_date is  null ");
		}
		// 未报到
		if (yorn == "5" || "5".equals(yorn)) {
			sql.append(" and d.spare1 = '0'  ");
		} else {
			sql.append(" and (d.spare1 is null or d.spare1='1' )");
		}
		
		if (employeeName != null) {
			sql.append(" and d.employee_name like'%").append(employeeName).append("%' ");
		}  
		if (apply_team != null) {
			sql.append(" and d.team='").append(apply_team).append("' ");
		} 
		if (codeId != null) {
			sql.append(" and d.employee_cd like'%").append(codeId).append("%' ");
		} 
		if (post != null) {
			sql.append(" and d.work_post='").append(post).append("' ");
		} 
		if (paramsType != null) {
			sql.append(" and d.employee_gz='").append(paramsType).append("' ");
		} 
		if (zyType != null) {
			sql.append(" and d.zy_type is null  ");
		} 
		
		if (ids != null && !"".equals(ids)) {
			sql.append("and d.human_detail_no in (").append(ids).append(") ");
		}
		
		if (szFather == null || szFather.trim().equals("")) { 
		 if (fatherId !=null && !"".equals(fatherId)){  // 父项目人员
				sql.append(" union all select distinct 'edit' emp_type, d.*,case  when d.zy_type  is null  then '' else 'disabled' end disasss,case  when d.zy_type  is null  then '' else '是' end zy_sf,'1' sz_type,cd3.coding_name project_evaluate, (d.plan_end_date-d.plan_start_date +1) days,e.employee_name,t.project_name,p.project_info_no,cd.coding_name team_name, cd2.coding_name work_post_name,h.employee_hr_id,h.employee_gz,h.employee_cd,h.spare2 employee_spare2_id, ");
	 			sql.append(" su.org_id,su1.org_id reorg_id ");
 
				sql.append(" from bgp_human_prepare_human_detail d ");
				sql.append(" inner join bgp_human_prepare p on d.prepare_no = p.prepare_no and p.prepare_status='2'  ");
				sql.append(" left join bgp_project_human_relation r on d.employee_id = r.employee_id  and p.project_info_no = r.project_info_no and r.team=d.team and r.work_post=d.work_post ");
				sql.append(" left join common_busi_wf_middle te on te.business_id=p.prepare_no and te.bsflag='0' ");
		 
				sql.append(" left join bgp_project_human_profess pr1 on pr1.profess_no=p.profess_no and p.profess_no is not null and pr1.bsflag='0' ");
				sql.append(" left join comm_org_subjection su2 on pr1.apply_company=su2.org_id ");

				sql.append(" left join bgp_project_human_requirement pr on pr.requirement_no=p.requirement_no and p.requirement_no is not null and pr.bsflag='0'  ");
				sql.append(" left join comm_org_subjection su on pr.apply_company=su.org_id ");
				sql.append(" left join bgp_project_human_relief re on re.human_relief_no=p.human_relief_no and p.human_relief_no is not null and re.bsflag='0'  ");
				sql.append(" left join comm_org_subjection su1 on re.apply_company=su1.org_id ");
	 
				sql.append(" left join comm_human_employee e on d.employee_id = e.employee_id ");
				sql.append(" left join comm_human_employee_hr h on d.employee_id = h.employee_id ");
				sql.append(" left join gp_task_project t on p.project_info_no = t.project_info_no ");
				sql.append(" left join comm_coding_sort_detail cd on d.team = cd.coding_code_id  and cd.bsflag='0' and cd.coding_mnemonic_id='"+projectType+"'");
				sql.append(" left join comm_coding_sort_detail cd2 on d.work_post = cd2.coding_code_id  and cd2.bsflag='0' and cd2.coding_mnemonic_id='"+projectType+"'");
				sql.append(" left join comm_coding_sort_detail cd3 on r.project_evaluate = cd3.coding_code_id ");
				sql.append(" where p.bsflag = '0' and d.between_param  is null   and d.bsflag='0' and   d.project_father_no='").append(projectInfoNo).append("'  and p.project_info_no = '").append(fatherId).append("' ");
				sql.append(" and ( te.business_id is null or te.proc_status='3' ) ");
			 
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
			
			if (employeeName != null) {
				sql.append(" and e.employee_name like'%").append(employeeName).append("%' ");
			}  
			if (apply_team != null) {
				sql.append(" and d.team='").append(apply_team).append("' ");
			} 
			if (codeId != null) {
				sql.append(" and h.employee_cd like'%").append(codeId).append("%' ");
			} 
			if (post != null) {
				sql.append(" and d.work_post='").append(post).append("' ");
			} 
			if (paramsType != null) {
				sql.append(" and h.employee_gz='").append(paramsType).append("' ");
			} 
			if (zyType != null) {
				sql.append(" and d.zy_type is null  ");
			} 
			
			
			if (ids != null && !"".equals(ids)) {
				sql.append("and d.human_detail_no in (").append(ids).append(") ");
			}
			
		 }
	}
		
		//sql.append(" order by e.employee_name ");
	 
//		List datas=BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		List<Map> list =  BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		page = jdbcDAO.queryRecordsBySQL(sql.toString(), page);
		
		list = page.getData();
		msg.setValue("datas", list);
		msg.setValue("yorn", yorn); 
		msg.setValue("projectInfoNo", projectInfoNo);	 
		msg.setValue("totalRows", page.getTotalRow());
		msg.setValue("pageSize", pageSize);
		msg.setValue("paramsType", paramsType);
		
		return msg;
	}
		
	 

	/**
	 * 人员接收保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanAccept(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));
		int lineNum = Integer.parseInt(reqDTO.getValue("lineNum"));
		
		String project_info_no = reqDTO.getValue("project_info_no");
		String params_type = reqDTO.getValue("params_type");
		
		for (int i = 0; i < equipmentSize; i++) {
			
			String actual_start_date = reqDTO.getValue("fy"+i+"actualStartDate");
			String human_detail_no = reqDTO.getValue("fy"+i+"humanDetailNo");
			String employee_id = reqDTO.getValue("fy"+i+"employeeId");

			String sql = "update bgp_human_prepare_human_detail set actual_start_date=to_date('"+actual_start_date+"','yyyy-MM-dd'), modifi_date = sysdate where human_detail_no ='"+human_detail_no+"'";
			jdbcDao.getJdbcTemplate().update(sql);
			
			String sql1 = "update comm_human_employee_hr set person_status='1',deploy_status='2',spare6='1', modifi_date = sysdate where employee_id ='"+employee_id+"'";
			jdbcDao.getJdbcTemplate().update(sql1);
			
			Map mapDetail = new HashMap();
			for (int j = 0; j < lineNum; j++) {
				BgpCommHumanReceiveProcess applyDetail = new BgpCommHumanReceiveProcess();
					PropertiesUtil.msgToPojo("em" + String.valueOf(j), reqDTO,
							applyDetail);
					mapDetail = PropertiesUtil.describe(applyDetail);

					mapDetail.put("project_info_no", project_info_no);
					mapDetail.put("employee_id", employee_id);
					mapDetail.put("creator", user.getEmpId());
					mapDetail.put("create_date", new Date());
					mapDetail.put("updator", user.getEmpId());
					mapDetail.put("modifi_date", new Date());

					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
							"bgp_comm_human_receive_process");
			} 	
			
			
		} 	
		responseDTO.setValue("params", params_type);
		return responseDTO;
	}
	
	

	/**
	 * 专业化人员接收保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveZHumanAccept(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));
		int lineNum = Integer.parseInt(reqDTO.getValue("lineNum"));
		
		String project_info_no = reqDTO.getValue("project_info_no");
	 
		for (int i = 0; i < equipmentSize; i++) {
			
			String actual_start_date = reqDTO.getValue("fy"+i+"actualStartDate");
			String human_detail_no = reqDTO.getValue("fy"+i+"humanDetailNo");//labor_deploy_id
			String employee_id = reqDTO.getValue("fy"+i+"employeeId"); //lablor_id
			String typeParam = reqDTO.getValue("fy"+i+"typeParam");  //0正式工，1临时工
			String employeeHrId = reqDTO.getValue("fy"+i+"employeeHrId"); //临时工deploy_detail_id
			
			
			if(typeParam!=null ){
				if(typeParam.equals("0")){
					String sql = "update bgp_human_prepare_human_detail set actual_start_date=to_date('"+actual_start_date+"','yyyy-MM-dd'), modifi_date = sysdate where human_detail_no ='"+human_detail_no+"'";
					jdbcDao.getJdbcTemplate().update(sql);
					
					String sql1 = "update comm_human_employee_hr set person_status='1',deploy_status='2',spare6='1', modifi_date = sysdate where employee_id ='"+employee_id+"'";
					jdbcDao.getJdbcTemplate().update(sql1);
					
					Map mapDetail = new HashMap();
					for (int j = 0; j < lineNum; j++) {
						BgpCommHumanReceiveProcess applyDetail = new BgpCommHumanReceiveProcess();
							PropertiesUtil.msgToPojo("em" + String.valueOf(j), reqDTO,
									applyDetail);
							mapDetail = PropertiesUtil.describe(applyDetail);

							mapDetail.put("project_info_no", project_info_no);
							mapDetail.put("employee_id", employee_id);
							mapDetail.put("creator", user.getEmpId());
							mapDetail.put("create_date", new Date());
							mapDetail.put("updator", user.getEmpId());
							mapDetail.put("modifi_date", new Date());

							BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
									"bgp_comm_human_receive_process");
					} 	
				}else if (typeParam.equals("1")){
					
					String sql = "update bgp_comm_human_labor_deploy set actual_start_date=to_date('"+actual_start_date+"','yyyy-MM-dd'), modifi_date = sysdate where  labor_deploy_id ='"+human_detail_no+"'";
					jdbcDao.getJdbcTemplate().update(sql);
					
				    	Map mapDetail = new HashMap();
						for (int j = 0; j < lineNum; j++) {
							BgpCommHumanReceiveLabor applyDetail = new BgpCommHumanReceiveLabor();
								PropertiesUtil.msgToPojo("em" + String.valueOf(j), reqDTO,
										applyDetail);
								mapDetail = PropertiesUtil.describe(applyDetail);
	
								mapDetail.put("project_info_no", project_info_no);
								mapDetail.put("deploy_detail_id", employeeHrId);
								mapDetail.put("labor_id", employee_id); 
								mapDetail.put("bsflag", "0"); 
								mapDetail.put("creator", user.getEmpId());
								mapDetail.put("create_date", new Date());
								mapDetail.put("updator", user.getEmpId());
								mapDetail.put("modifi_date", new Date());
						 
								BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
										"bgp_comm_human_receive_labor");
						} 	
				}
				
			}
			
			
			
			
		} 	
		//responseDTO.setValue("params", params_type);
		return responseDTO;
	}
	
	
	 
	

	/**
	 * 临时工接收分配任务保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveLaborAcceptNew(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));
		int lineNum = Integer.parseInt(reqDTO.getValue("lineNum"));
		
		String project_info_no = reqDTO.getValue("project_info_no"); 
		String labor_category = reqDTO.getValue("labor_category");
		
		for (int i = 0; i < equipmentSize; i++) {
			
			String actual_start_date = reqDTO.getValue("fy"+i+"actualStartDate");
			String laborDeployId = reqDTO.getValue("fy"+i+"laborDeployId");
			String laborId = reqDTO.getValue("fy"+i+"laborId");  
			String deployDetailId = reqDTO.getValue("fy"+i+"deployDetailId"); 
		 
			String sql = "update bgp_comm_human_labor_deploy set actual_start_date=to_date('"+actual_start_date+"','yyyy-MM-dd'), modifi_date = sysdate where  labor_deploy_id ='"+laborDeployId+"'";
			jdbcDao.getJdbcTemplate().update(sql);
		 
			Map mapDetail = new HashMap();
			for (int j = 0; j < lineNum; j++) {
				BgpCommHumanReceiveLabor applyDetail = new BgpCommHumanReceiveLabor();
					PropertiesUtil.msgToPojo("em" + String.valueOf(j), reqDTO,
							applyDetail);
					mapDetail = PropertiesUtil.describe(applyDetail);

					mapDetail.put("project_info_no", project_info_no);
					mapDetail.put("deploy_detail_id", deployDetailId);
					mapDetail.put("labor_id", laborId); 
					mapDetail.put("creator", user.getEmpId());
					mapDetail.put("create_date", new Date());
					mapDetail.put("updator", user.getEmpId());
					mapDetail.put("modifi_date", new Date());
			 
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
							"bgp_comm_human_receive_labor");
			} 	
			
			
		} 	
		responseDTO.setValue("laborCategory", labor_category);
		return responseDTO;
	}
	
	
	
	/**
	 * 人员返还保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanReturn(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));
		String params_type = reqDTO.getValue("params_type");
		
		for (int i = 0; i < equipmentSize; i++) {
			
			String actual_end_date = reqDTO.getValue("fy"+i+"actualEndDate");
			String actual_start_date = reqDTO.getValue("fy"+i+"actualStartDate");
			String human_detail_no = reqDTO.getValue("fy"+i+"humanDetailNo");
			String employee_hr_id = reqDTO.getValue("fy"+i+"employeeHrId");
			String sz_type = reqDTO.getValue("fy"+i+"szType");	// 区分父子项目
			String empType = reqDTO.getValue("fy"+i+"empType");	//区分 转移项目
			String projectEvaluate = reqDTO.getValue("fy"+i+"projectEvaluate");	
			if(empType.equals("add")){ //add 状态为年度项目转移人员
				String sql = "update BGP_COMM_HUMAN_PT_DETAIL set end_date=to_date('"+actual_end_date+"','yyyy-MM-dd'),notes='"+projectEvaluate+"', modifi_date = sysdate where ptdetail_id ='"+human_detail_no+"'";
				jdbcDao.getJdbcTemplate().update(sql);
				
				String sql1 = "update comm_human_employee_hr set person_status='0' ,deploy_status='0',spare6='', modifi_date = sysdate where employee_hr_id ='"+employee_hr_id+"' ";
				jdbcDao.getJdbcTemplate().update(sql1); 
 
				String a_date=actual_start_date;
				String le_date=actual_end_date;
				 if(!le_date.equals(null) && !le_date.equals("") ){
				  //添加表是针对井中业务转移人员生成的 子项目经历
				  String sqlpZ = " select p.project_father_no ,p.project_info_no AS project_info_no,    p.project_name AS project_name,  p.project_common AS project_common,   p.project_status AS project_status,  ccsd.coding_name AS manage_org_name,  DECODE(rpt.START_DATE, NULL, p.START_TIME) AS START_TIME,  DECODE(rpt.end_DATE, NULL, p.END_TIME) AS END_TIME,  oi.org_abbreviation AS team_name,  dy.is_main_team AS is_main_team  from gp_task_project p  join gp_task_project_dynamic dy  on dy.project_info_no = p.project_info_no  and dy.bsflag = '0'  and p.bsflag = '0'  and p.project_father_no = '"+user.getProjectInfoNo()+"'  and p.project_type = '5000100004000000008'  and dy.is_main_team = '1'  left join comm_org_information oi  on dy.org_id = oi.org_id  left join comm_coding_sort_detail ccsd  on p.manage_org = ccsd.coding_code_id  and ccsd.bsflag = '0'  LEFT JOIN (SELECT DISTINCT rpt.project_info_no,  rpt.start_date,  rpt.end_date  FROM bgp_ws_daily_report rpt  JOIN COMMON_BUSI_WF_MIDDLE wf  ON wf.BUSINESS_ID = rpt.PROJECT_INFO_NO  AND wf.bsflag = '0'  AND rpt.bsflag = '0'  AND wf.BUSI_TABLE_NAME = 'bgp_ws_daily_report'  AND wf.PROC_STATUS = '3') rpt  ON rpt.project_info_no = p.project_info_no  "; 
					List listP = BeanFactory.getQueryJdbcDAO().queryRecords(sqlpZ);
					Map mapDetail_z = new HashMap(); 
					for(int j=0;j<listP.size();j++){
						Map map = (Map)listP.get(j);  
						DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

						Date aDate = df.parse(a_date);
						Date leDate = df.parse(le_date);
						
						Date sDate = df.parse((String)map.get("startTime"));
						Date eDate = df.parse((String)map.get("endTime")); 
					     if(!sDate.equals(null) && !sDate.equals("") ){
								if (sDate.getTime() >= aDate.getTime() &&  sDate.getTime() <=  leDate.getTime()) {
			
									System.out.println(sDate+"**********"+(String)map.get("projectName"));
			   
										 BgpProjectHumanRelation relaDetail_z = new BgpProjectHumanRelation();
											PropertiesUtil.msgToPojo("fy" + String.valueOf(j), reqDTO, relaDetail_z);
											mapDetail_z = PropertiesUtil.describe(relaDetail_z);
											// spare1保存用人单位
											System.out.println("*******zy*********"+mapDetail_z.get("emp_type").toString()); 
													
												    //父项目人员   生产项目经历项目id保存为本子项目id
											mapDetail_z.put("plan_start_date", (String)map.get("startTime"));
											mapDetail_z.put("plan_end_date", (String)map.get("endTime"));
											mapDetail_z.put("actual_start_date", (String)map.get("startTime"));
											mapDetail_z.put("actual_end_date", (String)map.get("endTime"));
											mapDetail_z.put("spare2", "zi"); 
											mapDetail_z.put("project_info_no",(String)map.get("projectInfoNo")); 
											mapDetail_z.put("bsflag", "0");
											mapDetail_z.put("spare1", mapDetail_z.get("reorg_id"));								 
											mapDetail_z.put("locked_if", "1");											  
											mapDetail_z.put("creator", user.getEmpId());
											mapDetail_z.put("create_date", new Date());
											mapDetail_z.put("updator", user.getEmpId());
											mapDetail_z.put("modifi_date", new Date());
		
													// 保存人员调配子表
													 BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail_z, "bgp_project_human_relation");
										 
											  
											  
								}
					     }
					}
				 }
			
					
					
			} else if  (empType.equals("edit")){
				
				if(sz_type.equals("0")){ // 自己调配人员 
					
					String sql = "update bgp_human_prepare_human_detail set actual_end_date=to_date('"+actual_end_date+"','yyyy-MM-dd'),spare2='1', modifi_date = sysdate where human_detail_no ='"+human_detail_no+"'";
					jdbcDao.getJdbcTemplate().update(sql);
					
					String sql1 = "update comm_human_employee_hr set person_status='0' ,deploy_status='0',spare6='', modifi_date = sysdate where employee_hr_id ='"+employee_hr_id+"' ";
					jdbcDao.getJdbcTemplate().update(sql1);
					
				}else  if(sz_type.equals("1")){  //父项目人员   
					
					String sql = "update bgp_human_prepare_human_detail set actual_end_date='',spare1='', project_father_no='',actual_start_date='', modifi_date = sysdate where human_detail_no ='"+human_detail_no+"'";
					jdbcDao.getJdbcTemplate().update(sql);
					
					String sql1 = "update comm_human_employee_hr set person_status='1',deploy_status='2', modifi_date = sysdate where employee_hr_id ='"+employee_hr_id+"' ";
					jdbcDao.getJdbcTemplate().update(sql1);
					
				}
				
			}
			
			
				
		} 	

		Map mapDetail = new HashMap();
				
		for (int i = 0; i < equipmentSize; i++) {
			BgpProjectHumanRelation relaDetail = new BgpProjectHumanRelation();
			PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO, relaDetail);
			mapDetail = PropertiesUtil.describe(relaDetail);
			// spare1保存用人单位
			System.out.println("*****************"+mapDetail.get("emp_type").toString());
			  if (mapDetail.get("emp_type").toString().equals("edit")) {
				if (mapDetail.get("actual_end_date") != null) {
					
				    //父项目人员   生产项目经历项目id保存为本子项目id
					mapDetail.put("project_info_no",user.getProjectInfoNo()); 
					mapDetail.put("bsflag", "0");
					mapDetail.put("spare1", mapDetail.get("reorg_id"));
				     if (mapDetail.get("emp_type").toString().equals("edit")) {
				    	 	mapDetail.put("locked_if", "0");
				     }else {
				    	 mapDetail.put("locked_if", "1");				    	 
				     }
					mapDetail.put("creator", user.getEmpId());
					mapDetail.put("create_date", new Date());
					mapDetail.put("updator", user.getEmpId());
					mapDetail.put("modifi_date", new Date());

					// 保存人员调配子表
					 BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail, "bgp_project_human_relation");
				}
			  }
			
		}
		responseDTO.setValue("params", params_type);		
		return responseDTO;
	}

	/**
	 * 专业化人员返还保存
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveZHumanReturn(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize")); 
		
		for (int i = 0; i < equipmentSize; i++) {
			
			String actual_end_date = reqDTO.getValue("fy"+i+"actualEndDate");
			String human_detail_no = reqDTO.getValue("fy"+i+"humanDetailNo");
			String employee_hr_id = reqDTO.getValue("fy"+i+"employeeHrId");
			String employeeId = reqDTO.getValue("fy"+i+"employeeId");
			String typeParam = reqDTO.getValue("fy"+i+"typeParam"); 
			
	            String sz_type = reqDTO.getValue("fy"+i+"szType");	// 区分父子项目
			
			if(sz_type.equals("0")){ // 自己调配人员  
				if(typeParam.equals("0")){
					String sql = "update bgp_human_prepare_human_detail set actual_end_date=to_date('"+actual_end_date+"','yyyy-MM-dd'),spare2='1', modifi_date = sysdate where human_detail_no ='"+human_detail_no+"'";
					jdbcDao.getJdbcTemplate().update(sql);
					
					String sql1 = "update comm_human_employee_hr set person_status='0' ,deploy_status='0',spare6='', modifi_date = sysdate where employee_hr_id ='"+employee_hr_id+"' ";
					jdbcDao.getJdbcTemplate().update(sql1);
					
				}else{
					
					//调配后更新调配表主表的状态
					String updateDeloySql = "update bgp_comm_human_labor_deploy d  set d.end_date = to_date('"+actual_end_date+"','yyyy-MM-dd'), d.modifi_date = sysdate where d.project_info_no='"+user.getProjectInfoNo()+"' and d.labor_id = '"+employeeId+"' ";
					jdbcDao.getJdbcTemplate().update(updateDeloySql);	
					
					//调配后更新主表的项目状态
					String updateDeloySql1 = "update bgp_comm_human_labor d  set d.if_project = '0',spare1='0', d.modifi_date = sysdate where d.labor_id = '"+employeeId+"' ";
					jdbcDao.getJdbcTemplate().update(updateDeloySql1);
				}
				
			}else  if(sz_type.equals("1")){  //父项目人员    
				if(typeParam.equals("0")){  
					
					String sql = "update bgp_human_prepare_human_detail set actual_end_date='',spare1='', project_father_no='',actual_start_date='', modifi_date = sysdate where human_detail_no ='"+human_detail_no+"'";
					jdbcDao.getJdbcTemplate().update(sql);
					
					String sql1 = "update comm_human_employee_hr set person_status='1',deploy_status='2', modifi_date = sysdate where employee_hr_id ='"+employee_hr_id+"' ";
					jdbcDao.getJdbcTemplate().update(sql1);
								
				}else{ 
						   //把人员返还到父项目中
						String updateDeloySql = "update bgp_comm_human_labor_deploy d  set d.end_date ='',d.actual_start_date='',d.project_father_no='', d.modifi_date = sysdate where d.project_father_no='"+user.getProjectInfoNo()+"' and d.labor_id = '"+employeeId+"' ";
						jdbcDao.getJdbcTemplate().update(updateDeloySql); 
						  
				} 
				
				
			}
			 
				
		} 	

		Map mapDetail = new HashMap();
				
		for (int i = 0; i < equipmentSize; i++) {
			BgpProjectHumanRelation relaDetail = new BgpProjectHumanRelation();
			PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO, relaDetail);
			mapDetail = PropertiesUtil.describe(relaDetail);
			// spare1保存用人单位
		 
			if(mapDetail.get("type_param").equals("0")){
				if (mapDetail.get("actual_end_date") != null) { 
				    //父项目人员   生产项目经历项目id保存为本子项目id
					mapDetail.put("project_info_no",user.getProjectInfoNo()); 
					mapDetail.put("bsflag", "0");
					mapDetail.put("spare1", mapDetail.get("reorg_id"));
					mapDetail.put("locked_if", "0");
					mapDetail.put("creator", user.getEmpId());
					mapDetail.put("create_date", new Date());
					mapDetail.put("updator", user.getEmpId());
					mapDetail.put("modifi_date", new Date());
	
					// 保存人员调配子表
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail, "bgp_project_human_relation");
				}
			}
		}
	 
		return responseDTO;
	}

	
	 
	
	
	

	/**
	 * 人员返还撤销
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteDeleteSave(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		String ids = reqDTO.getValue("ids");// 字符串
		String projectInfoNo = reqDTO.getValue("projectInfoNo");// 字符串

		String[] ssTemp = ids.split(",");
		for (int i = 0; i < ssTemp.length; i++) {
			
			String sql = "update bgp_human_prepare_human_detail set actual_end_date='',spare2='', modifi_date = sysdate where human_detail_no ='"+ssTemp[i].split("-")[0]+"'";
			jdbcDao.getJdbcTemplate().update(sql);
			
			String deleteSql = " delete from bgp_project_human_relation t where t.project_info_no='"+projectInfoNo+"' and t.employee_id='"+ssTemp[i].split("-")[1]+"' ";				
			jdbcDao.getJdbcTemplate().execute(deleteSql);
		}

		return responseDTO;
	}
	
	/**
	 * 人员返还撤销
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg doHumanReturnafterRelation(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		String relation_nos = reqDTO.getValue("relation_nos");// 字符串

		if (relation_nos != null && !"".equals(relation_nos)) {
			String updateSql = " update comm_human_employee_hr hr set hr.relief_org='',hr.spare1='', hr.modifi_date=sysdate, hr.updator='"+user.getEmpId()+"', hr.person_status='0',hr.deploy_status='0',hr.spare6 ='' where hr.employee_id in ( select d.employee_id from  bgp_project_human_relation d where d.relation_no in ("+relation_nos+") ) ";				
			jdbcDao.getJdbcTemplate().update(updateSql);
		}

		return responseDTO;
	}
	
	/**
	 * 员工返还导入
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanReturnExcle(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);	
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		UserToken user = reqDTO.getUserToken();
		String  paramsType=reqDTO.getValue("paramsType");
		
		SimpleDateFormat datetemp=new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList != null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
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
					for (int m = 2; m <= sheet.getLastRowNum(); m++) {   
						row = sheet.getRow(m);	
						String name = "";
						String id = "";
						String team = "";
						String post = "";
						String startDate = "";
						String endDate = "";
						String projectEvaluate = "";
						int type = 0;
						Map<String, String> tempMap = new HashMap<String, String>();
						for (int j = 0; j < row.getPhysicalNumberOfCells(); j++) {
							Cell ss=row.getCell(j);							
							
							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
									case 0:
																		
										ss.setCellType(1); name=ss.getStringCellValue().trim();
										tempMap.put("employee_name", name);
										break;
									case 1:
										ss.setCellType(1);id=ss.getStringCellValue().trim();
										tempMap.put("employee_cd", id);
										break;
									case 2:
										ss.setCellType(1);team=ss.getStringCellValue().trim();
										tempMap.put("apply_team_name", team);
										break;
									case 3:
										ss.setCellType(1);post=ss.getStringCellValue().trim();
										tempMap.put("post_name", post);
										break;
									case 4:
										type = ss.getCellType();	
										if(type == 0){
											ss.setCellType(0);
											startDate=datetemp.format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											startDate=ss.getStringCellValue().trim();
										}
										
										tempMap.put("actual_start_date",startDate);
										break;
									case 5:
										type = ss.getCellType();	
										if(type == 0){
											ss.setCellType(0);
											endDate=datetemp.format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											endDate=ss.getStringCellValue().trim();
										}
										
										tempMap.put("actual_end_date",endDate);
										break;
									case 6:
										ss.setCellType(1);projectEvaluate=ss.getStringCellValue().trim();
										tempMap.put("project_evaluate_name", projectEvaluate);
										break;
									default:
										break;
								}							
							}
						}	
						
						if(name.equals("") || id.equals("")){
							message.append("第").append(m+1).append("行,姓名或人员编号不能为空!");
						}else{
							String sql = "select t.employee_id from comm_human_employee_hr t where t.employee_cd='"+id+"' and t.bsflag='0'  ";				
							Map laborMap = jdbcDAO.queryRecordBySQL(sql);
							if(laborMap == null){
								message.append("第").append(m+1).append("行,人员不存在!");
							}else{
								//导入处理人员已经项目转移 提示
								//union  all  select dt.employee_id from BGP_COMM_HUMAN_PT_DETAIL dt where dt.bsflag='0' and   dt.pk_ids = 'add' and dt.employee_cd='"+id+"'
								String emp_id= laborMap.get("employee_id").toString();								
								String sqlZy = "select t.zy_type from bgp_human_prepare_human_detail t where t.employee_id='"+emp_id+"' and t.bsflag='0' ";				
								Map zyMap = jdbcDAO.queryRecordBySQL(sqlZy);
								if(zyMap !=null){
									 String zy_type=zyMap.get("zy_type").toString();	
									 if(zy_type.equals("")){
										 tempMap.put("employee_id", laborMap.get("employee_id").toString());
									 }else{
										 message.append("第 ").append(m+1).append(" 行,人员已经项目转移,不能返还!  ");
									 }
								}else{ 
									 tempMap.put("employee_id", laborMap.get("employee_id").toString());
								}
								
								
							}
						}
						if(team.equals("")|| post.equals("")){
							message.append("第").append(m+1).append("行,班组或岗位不能为空!");
						}
						if(startDate.equals("")){
							message.append("第").append(m+1).append("行,实际进入项目时间不能为空!");
						}
						if(endDate.equals("")){
							message.append("第").append(m+1).append("行,实际离开项目时间不能为空!");
						}
						if(projectEvaluate.equals("")){
							message.append("第").append(m+1).append("行,项目评价时间不能为空!");
						}
						if(message.toString().equals("")){
							datelist.add(tempMap);
						}
					}  
				}		
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}
			if(!message.toString().equals("")){
				responseMsg.setValue("message", message.toString());
			}else{
				if(datelist != null && datelist.size()>0){				
					saveImportRetrun(datelist,user); 
				}
				responseMsg.setValue("message", "导入成功!");
			}
		}		
		
		responseMsg.setValue("params", paramsType);
		return responseMsg;		
	}
	
	public void saveImportRetrun(List datelist,UserToken user){
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	    String projectInfoNo = user.getProjectInfoNo();
		
	    String projectType = user.getProjectType();	
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		} 
		if(projectType.equals("5000100004000000002")){
			projectType="5000100004000000001";
		}
		
		
		if(datelist != null && datelist.size()>0){		

			for(int i=0;i<datelist.size();i++){
				 Map map = (HashMap)datelist.get(i);
	
				// 更新本项目的人员
				String sql = "update bgp_human_prepare_human_detail set actual_end_date=to_date('"+map.get("actual_end_date")+"','yyyy-MM-dd'),spare2='1', modifi_date = sysdate where employee_id ='"+map.get("employee_id")+"' and prepare_no in (select prepare_no from bgp_human_prepare where project_info_no ='"+projectInfoNo+"' and bsflag='0')";
				jdbcDao.getJdbcTemplate().update(sql);
				
				String sql1 = "update comm_human_employee_hr set person_status='0' ,deploy_status='0',spare6='', modifi_date = sysdate where employee_id ='"+map.get("employee_id")+"' ";
				jdbcDao.getJdbcTemplate().update(sql1);
				
				
				// 返还到父项目项目的人员
				String sql2 = "update bgp_human_prepare_human_detail set  actual_end_date='',spare1='', project_father_no='',actual_start_date='', modifi_date = sysdate where employee_id ='"+map.get("employee_id")+"' and project_father_no='"+projectInfoNo+"' ";
				jdbcDao.getJdbcTemplate().update(sql2);
			 
				String sql3 = "update comm_human_employee_hr set person_status='1',deploy_status='2', modifi_date = sysdate where employee_id in (	select  t.employee_id  from  bgp_human_prepare_human_detail t  where  t.project_father_no ='"+projectInfoNo+"' and t.bsflag='0' ) ";
				jdbcDao.getJdbcTemplate().update(sql3);
		
				 
				
				String apply_team="";
				String post="";
				String project_evaluate="";
				Map teamMap = jdbcDao.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"+map.get("apply_team_name")+"'  and t.bsflag = '0'  and t.coding_mnemonic_id='"+projectType+"'   and t.coding_sort_id='0110000001' ");				
				if( teamMap != null){						
					apply_team = (String)teamMap.get("coding_code_id");						
				}
				Map postMap = jdbcDao.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"+map.get("post_name")+"' and t.bsflag = '0'  and t.coding_mnemonic_id='"+projectType+"'   and t.coding_sort_id='0110000001' ");				
				if( postMap != null){						
					post = (String)postMap.get("coding_code_id");						
				}
				Map evaluateMap = jdbcDao.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"+map.get("project_evaluate_name")+"' and t.coding_sort_id='0110000058' ");				
				if( teamMap != null){						
					project_evaluate = (String)evaluateMap.get("coding_code_id");						
				}

				
				// 更新转移表的人员
				String sql_zy = "update BGP_COMM_HUMAN_PT_DETAIL set  end_date=to_date('"+map.get("actual_end_date")+"','yyyy-MM-dd'),notes='"+project_evaluate+"', modifi_date = sysdate where employee_id ='"+map.get("employee_id")+"' and bproject_info_no='"+projectInfoNo+"' and   pk_ids = 'add'  and bsflag='0' ";
				jdbcDao.getJdbcTemplate().update(sql_zy);
			 
				String a_date=map.get("actual_start_date").toString();
				String le_date=map.get("actual_end_date").toString();
				  if(!le_date.equals(null) && !le_date.equals("") ){
				  //添加表是针对井中业务的 项目经历
				  String sqlpZ = " select p.project_father_no ,p.project_info_no AS project_info_no,    p.project_name AS project_name,  p.project_common AS project_common,   p.project_status AS project_status,  ccsd.coding_name AS manage_org_name,  DECODE(rpt.START_DATE, NULL, p.START_TIME) AS START_TIME,  DECODE(rpt.end_DATE, NULL, p.END_TIME) AS END_TIME,  oi.org_abbreviation AS team_name,  dy.is_main_team AS is_main_team  from gp_task_project p  join gp_task_project_dynamic dy  on dy.project_info_no = p.project_info_no  and dy.bsflag = '0'  and p.bsflag = '0'  and p.project_father_no = '"+projectInfoNo+"'  and p.project_type = '5000100004000000008'  and dy.is_main_team = '1'  left join comm_org_information oi  on dy.org_id = oi.org_id  left join comm_coding_sort_detail ccsd  on p.manage_org = ccsd.coding_code_id  and ccsd.bsflag = '0'  LEFT JOIN (SELECT DISTINCT rpt.project_info_no,  rpt.start_date,  rpt.end_date  FROM bgp_ws_daily_report rpt  JOIN COMMON_BUSI_WF_MIDDLE wf  ON wf.BUSINESS_ID = rpt.PROJECT_INFO_NO  AND wf.bsflag = '0'  AND rpt.bsflag = '0'  AND wf.BUSI_TABLE_NAME = 'bgp_ws_daily_report'  AND wf.PROC_STATUS = '3') rpt  ON rpt.project_info_no = p.project_info_no "; 
					List listP = BeanFactory.getQueryJdbcDAO().queryRecords(sqlpZ);
				
					for(int j=0;j<listP.size();j++){
						Map map_p = (Map)listP.get(j); 
						Map map_zy = (HashMap)datelist.get(i);
						SimpleDateFormat  df = new SimpleDateFormat("yyyy-MM-dd");
						
						Date aDate= new Date();
						Date leDate= new Date();
						Date sDate= new Date();
						Date eDate= new Date();
						
						try {
						  aDate = df.parse(a_date);
						  leDate= df.parse(le_date);
						  sDate = df.parse((String)map_p.get("startTime"));
						  eDate = df.parse((String)map_p.get("endTime"));
						
						  } catch (ParseException e) {   e.printStackTrace();  }
						  if(!sDate.equals(null) && !sDate.equals("") ){
								if (sDate.getTime() >= aDate.getTime() &&  sDate.getTime() <=  leDate.getTime()) {
									 
									System.out.println("**********"+(String)map_zy.get("projectName"));
							 
									map_zy.put("plan_start_date", (String)map.get("startTime"));
									map_zy.put("plan_end_date", (String)map.get("endTime"));
									map_zy.put("actual_start_date", (String)map.get("startTime"));
									map_zy.put("actual_end_date", (String)map.get("endTime"));
									
									map_zy.put("spare2", "zi"); 
									map_zy.put("project_info_no",(String)map.get("projectInfoNo"));  
									map_zy.put("spare1", user.getOrgId());		
									
									map_zy.put("team", apply_team);				
									map_zy.put("work_post", post);				
									map_zy.put("project_evaluate", project_evaluate);				
	 
									map_zy.put("creator", user.getEmpId());
									map_zy.put("create_date", new Date());
									map_zy.put("updator", user.getEmpId());
									map_zy.put("modifi_date", new Date());
									map_zy.put("bsflag", "0");
									map_zy.put("locked_if", "1");
								
									BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map_zy,"bgp_project_human_relation");
							}
						  }
					}
				  }
				map.put("team", apply_team);				
				map.put("work_post", post);		
				map.put("plan_start_date", (String)map.get("actual_start_date"));
				map.put("plan_end_date", (String)map.get("actual_end_date"));
				map.put("project_evaluate", project_evaluate);				
				map.put("project_info_no", projectInfoNo);
				map.put("creator", user.getEmpId());
				map.put("create_date", new Date());
				map.put("updator", user.getEmpId());
				map.put("modifi_date", new Date());
				map.put("bsflag", "0");
				map.put("locked_if", "0");
				map.put("spare1", user.getOrgId());	
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_project_human_relation");

			}
		}

	}
	

	/**
	 * 专业化员工返还导入
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveZHumanReturnExcle(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);	
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		UserToken user = reqDTO.getUserToken();
	 
		SimpleDateFormat datetemp=new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList != null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
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
					for (int m = 2; m <= sheet.getLastRowNum(); m++) {   
						row = sheet.getRow(m);	
						String name = "";
						String id = "";
						String team = "";
						String post = "";
						String startDate = "";
						String endDate = "";
						String projectEvaluate = "";
						int type = 0;
						Map<String, String> tempMap = new HashMap<String, String>();
						for (int j = 0; j < row.getPhysicalNumberOfCells(); j++) {
							Cell ss=row.getCell(j);							
							
							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
									case 0:
																		
										ss.setCellType(1); name=ss.getStringCellValue().trim();
										tempMap.put("employee_name", name);
										break;
									case 1:
										ss.setCellType(1);id=ss.getStringCellValue().trim();
										tempMap.put("employee_cd", id);
										break;
									case 2:
										ss.setCellType(1);team=ss.getStringCellValue().trim();
										tempMap.put("apply_team_name", team);
										break;
									case 3:
										ss.setCellType(1);post=ss.getStringCellValue().trim();
										tempMap.put("post_name", post);
										break;
									case 4:
//										type = ss.getCellType();	
//										if(type == 0){
//											ss.setCellType(0);
//											startDate=datetemp.format(ss.getDateCellValue());
//										}else{
//											ss.setCellType(1);
//											startDate=ss.getStringCellValue().trim();
//										}
//										
//										tempMap.put("actual_start_date",startDate);
//										break;
										 
										
										if(ss.getCellType()==0){
											startDate=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											startDate = ss.getStringCellValue().trim(); // 对应赋值
										}
 
										startDate=startDate.replace("/", "-");
	 								String[] biths=startDate.split("-");
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
	 								tempMap.put("actual_start_date",temp);
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(temp);
	 								}catch(Exception ex){
	 									
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								}
	 								
	 								
	 								break;
									 
									case 5:
//										type = ss.getCellType();	
//										if(type == 0){
//											ss.setCellType(0);
//											endDate=datetemp.format(ss.getDateCellValue());
//										}else{
//											ss.setCellType(1);
//											endDate=ss.getStringCellValue().trim();
//										}
//										
//										tempMap.put("actual_end_date",endDate);
//										break;
										
										if(ss.getCellType()==0){
											endDate=new SimpleDateFormat("yyyy-MM-dd").format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											endDate = ss.getStringCellValue().trim(); // 对应赋值
										}
 
										endDate=endDate.replace("/", "-");
	 								String[] bithsA=endDate.split("-");
	 								String tempA="";
	 								for(int i=0;i<bithsA.length;i++){
	 									if(bithsA[i].length()==1){
	 									bithsA[i]="0"+bithsA[i];
	 									}
	 									if(i==bithsA.length-1){
	 										tempA+=bithsA[i];
	 									}else{
	 										tempA+=bithsA[i]+"-";
	 									}
	 									
	 								}
	 								tempMap.put("actual_end_date",tempA);
	 								
	 								try{
	 									new SimpleDateFormat("yyyy-MM-dd").parse(tempA);
	 								}catch(Exception ex){ 
	 									message.append("第").append(m + 1).append(
										"行日期格式不正确；");
	 								}
	 								
	 								
	 								break;
										
									case 6:
										ss.setCellType(1);projectEvaluate=ss.getStringCellValue().trim();
										tempMap.put("project_evaluate_name", projectEvaluate);
										break;
									default:
										break;
								}							
							}
						}	
						
						if(name.equals("") || id.equals("")){
							message.append("第").append(m+1).append("行,姓名或人员编号不能为空!");
						}else{
							int idLength=id.length();
							if(idLength == 8){
								System.out.println("正式");
								//正式工
								String sql = "select t.employee_id from comm_human_employee_hr t where t.employee_cd='"+id+"' and t.bsflag='0' ";				
								Map laborMap = jdbcDAO.queryRecordBySQL(sql);
								if(laborMap == null){
									message.append("第").append(m+1).append("行,正式工人员不存在!");
								}else{
									tempMap.put("employee_id", laborMap.get("employee_id").toString());
									tempMap.put("type_param", "0");
								}
								
								if(projectEvaluate.equals("")){
									message.append("第").append(m+1).append("行,正式工项目评价不能为空!");
								}
							}else if (idLength >8){	System.out.println("临时");
								//临时工
								String sql = "select t.labor_id from bgp_comm_human_labor t where t.employee_id_code_no='"+id+"' and t.bsflag='0' ";				
								Map laborMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
								if(laborMap == null){
									message.append("第").append(m+1).append("行,临时工人员不存在!");
								}else{
									tempMap.put("employee_id", laborMap.get("laborId").toString());
									tempMap.put("type_param", "1");
								}
							 
							}
							
						
						}
						if(team.equals("")|| post.equals("")){
							message.append("第").append(m+1).append("行,班组或岗位不能为空!");
						}
						if(startDate.equals("")){
							message.append("第").append(m+1).append("行,实际进入项目时间不能为空!");
						}
						if(endDate.equals("")){
							message.append("第").append(m+1).append("行,实际离开项目时间不能为空!");
						}
						
						if(message.toString().equals("")){
							datelist.add(tempMap);
						}
					}  
				}		
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}
			if(!message.toString().equals("")){
				responseMsg.setValue("message", message.toString());
			}else{
				if(datelist != null && datelist.size()>0){				
					saveZImportRetrun(datelist,user);
				}
				responseMsg.setValue("message", "导入成功!");
			}
		}		
 
		return responseMsg;		
	}
	
	/**
	 * 专业化人员返还导入
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public void saveZImportRetrun(List datelist,UserToken user){
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		String projectInfoNo = user.getProjectInfoNo();
		String projectType = user.getProjectType();	
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		} 
		if(projectType.equals("5000100004000000002")){
			projectType="5000100004000000001";
		}
		
		if(datelist != null && datelist.size()>0){					
			for(int i=0;i<datelist.size();i++){						
				Map mapDetail = (HashMap)datelist.get(i);
				
				if (mapDetail.get("type_param").equals("0")){
					
					Map map = (HashMap)datelist.get(i);
					
					String sql = "update bgp_human_prepare_human_detail set actual_end_date=to_date('"+map.get("actual_end_date")+"','yyyy-MM-dd'),spare2='1', modifi_date = sysdate where employee_id ='"+map.get("employee_id")+"' and prepare_no in (select prepare_no from bgp_human_prepare where project_info_no ='"+projectInfoNo+"' and bsflag='0')";
					jdbcDao.getJdbcTemplate().update(sql);
					
					String sql1 = "update comm_human_employee_hr set person_status='0' ,deploy_status='0',spare6='', modifi_date = sysdate where employee_id ='"+map.get("employee_id")+"' ";
					jdbcDao.getJdbcTemplate().update(sql1);
					
					 
					// 返还到父项目项目的人员
					String sql2 = "update bgp_human_prepare_human_detail set  actual_end_date='',spare1='', project_father_no='',actual_start_date='', modifi_date = sysdate where employee_id ='"+map.get("employee_id")+"' and project_father_no='"+projectInfoNo+"' ";
					jdbcDao.getJdbcTemplate().update(sql2);
				 
					String sql3 = "update comm_human_employee_hr set person_status='1',deploy_status='2', modifi_date = sysdate where employee_id in (	select  t.employee_id  from  bgp_human_prepare_human_detail t  where  t.project_father_no ='"+projectInfoNo+"' and t.bsflag='0' ) ";
					jdbcDao.getJdbcTemplate().update(sql3);
 
					
					
					String apply_team="";
					String post="";
					String project_evaluate="";
					Map teamMap = jdbcDao.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"+map.get("apply_team_name")+"'  and t.bsflag = '0'  and t.coding_mnemonic_id='"+projectType+"'  and t.coding_sort_id='0110000001' ");				
					if( teamMap != null){						
						apply_team = (String)teamMap.get("coding_code_id");						
					}
					Map postMap = jdbcDao.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"+map.get("post_name")+"' and t.bsflag = '0'  and t.coding_mnemonic_id='"+projectType+"'   and t.coding_sort_id='0110000001' ");				
					if( postMap != null){						
						post = (String)postMap.get("coding_code_id");						
					}
					Map evaluateMap = jdbcDao.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"+map.get("project_evaluate_name")+"' and t.coding_sort_id='0110000058' ");				
					if( evaluateMap != null){						
						project_evaluate = (String)evaluateMap.get("coding_code_id");						
					}

					map.put("team", apply_team);				
					map.put("work_post", post);				
					map.put("project_evaluate", project_evaluate);				
					map.put("project_info_no", projectInfoNo);
					map.put("creator", user.getEmpId());
					map.put("create_date", new Date());
					map.put("updator", user.getEmpId());
					map.put("modifi_date", new Date());
					map.put("bsflag", "0");
					map.put("locked_if", "0");
				
					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_project_human_relation");

					
					
				}else if (mapDetail.get("type_param").equals("1")){
//					//调配后更新调配表主表的状态
//					String updateDeloySql = "update bgp_comm_human_labor_deploy d  set d.end_date = to_date('"+mapDetail.get("actual_end_date")+"','yyyy-MM-dd'), d.modifi_date = sysdate where d.project_info_no='"+projectInfoNo+"' and d.labor_id = '"+mapDetail.get("employee_id")+"' ";
//					jdbcDao.getJdbcTemplate().update(updateDeloySql);					
//					
//					//调配后更新主表的项目状态
//					String updateDeloySql1 = "update bgp_comm_human_labor d  set d.if_project = '0',spare1='0', d.modifi_date = sysdate where d.labor_id = '"+mapDetail.get("employee_id")+"' ";
//					jdbcDao.getJdbcTemplate().update(updateDeloySql1);
 	
					
					//调配后更新调配表主表的状态
					String updateDeloySql = "update bgp_comm_human_labor_deploy d  set d.end_date = to_date('"+mapDetail.get("actual_end_date")+"','yyyy-MM-dd'), d.modifi_date = sysdate where d.project_father_no is null and  d.project_info_no='"+projectInfoNo+"' and d.labor_id = '"+mapDetail.get("employee_id")+"' ";
					jdbcDao.getJdbcTemplate().update(updateDeloySql);			
					
					//返回到 父项目
					String updateDeloySqlf = "update bgp_comm_human_labor_deploy d  set d.end_date ='',d.actual_start_date='',d.project_father_no='', d.modifi_date = sysdate  where d.project_father_no ='"+projectInfoNo+"' and d.labor_id = '"+mapDetail.get("employee_id")+"' ";
					jdbcDao.getJdbcTemplate().update(updateDeloySqlf);		 
					
					//调配后更新主表的项目状态
					String updateDeloySql1 = "update bgp_comm_human_labor d  set d.if_project = '0', spare1='0', d.modifi_date = sysdate where d.labor_id  in (select t.labor_id   from bgp_comm_human_labor_deploy t where t.project_father_no is null  and t.labor_id='"+mapDetail.get("employee_id")+"' ) ";  
					jdbcDao.getJdbcTemplate().update(updateDeloySql1);
			
					
					
				}
				
				
			}		
		}
	
	}


	/**
	 * 临时工接收导入
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanLaborAcceptExcle(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);	
		UserToken user = reqDTO.getUserToken();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		String laborCategory = reqDTO.getValue("laborCategory");
		int numSum = Integer.parseInt(reqDTO.getValue("numSum"));
		
		String projectType = user.getProjectType();	
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		} 
		if(projectType.equals("5000100004000000002")){
			projectType="5000100004000000001";
		}
		
		SimpleDateFormat datetemp=new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		StringBuffer messageA = new StringBuffer("");
		
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList != null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
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
					for (int m = 2; m <= sheet.getLastRowNum(); m++) {   
						row = sheet.getRow(m);	
						String name = "";
						String id = "";
						String team = "";
						String post = "";
						String startDate = "";
						String endDate = "";
						int type = 0;
						Map<String, String> tempMap = new HashMap<String, String>();
						for (int j = 0; j < row.getPhysicalNumberOfCells(); j++) {
							Cell ss=row.getCell(j);							
							
							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
									case 0:
																		
										ss.setCellType(1); name=ss.getStringCellValue().trim();
										tempMap.put("employee_name", name);
										break;
									case 1:
										ss.setCellType(1);id=ss.getStringCellValue().trim();
										tempMap.put("employee_id_code_no", id);
										break;
									case 2:
										ss.setCellType(1);team=ss.getStringCellValue().trim();
										tempMap.put("apply_team_name", team);
										break;
									case 3:
										ss.setCellType(1);post=ss.getStringCellValue().trim();
										tempMap.put("post_name", post);
										break;
									case 4:
										type = ss.getCellType();	
										if(type == 0){
											ss.setCellType(0);
											startDate=datetemp.format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											startDate=ss.getStringCellValue().trim();
										}
										
										tempMap.put("start_date",startDate);
										break;
									default:
										break;
								}							
							}
						}	
						
						if(name.equals("") || id.equals("")){
							message.append("第").append(m+1).append("行,姓名或身份证号不能为空!");
						}else{
							String sql = "select t.labor_id,t.cont_num from bgp_comm_human_labor t where t.employee_id_code_no='"+id+"' and t.bsflag='0' ";				
							Map laborMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
							if(laborMap == null){
								message.append("第").append(m+1).append("行,临时工不存在!");
							}else{
								tempMap.put("cont_num", laborMap.get("contNum")+"");
								tempMap.put("labor_id", laborMap.get("laborId").toString());
							}
						}
						if(team.equals("") || post.equals("")){
							message.append("第").append(m+1).append("行,班组或岗位不能为空!");
						}
						if(startDate.equals("")){
							message.append("第").append(m+1).append("行,进入项目时间不能为空!");
						}
						if(message.toString().equals("")){
							datelist.add(tempMap);
						}
					}  
				}		
			}catch(Exception e){
				System.out.println(e.getMessage());
				
			}
			responseMsg.setValue("laborCategory",laborCategory);
			
			
			 String inputMs="";
			 String inputM=""; 
			 String input=""; 
			 int  sumA=0; 
		     int  sumC=0;
			 int  sumD=0; 
			String sumM="";
			
			
			
			if(!message.toString().equals("")){
				responseMsg.setValue("message", message.toString());
			}else{
				if(datelist != null && datelist.size()>0){	
					if(datelist.size()>numSum){
						responseMsg.setValue("message", "现有"+datelist.size()+"条信息,"+"可接收人数为:"+numSum);
					}else{
					//saveImportDeploy(datelist,user);
						 
							for(int i=0;i<datelist.size();i++){
								Map map = (HashMap)datelist.get(i);
								
								String apply_team="";
								String post="";
								String d_id="";
								String dl_id="";
								String p_father_id="";
								String p_p_id="";
								
								Map teamMap = jdbcDAO.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"+map.get("apply_team_name")+"' and t.bsflag = '0'  and t.coding_mnemonic_id='"+projectType+"'  and t.coding_sort_id='0110000001' ");				
								if( teamMap != null){						
									apply_team = (String)teamMap.get("coding_code_id");						
								}
								Map postMap = jdbcDAO.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"+map.get("post_name")+"' and t.bsflag = '0'  and t.coding_mnemonic_id='"+projectType+"'  and t.coding_sort_id='0110000001' ");				
								if( postMap != null){						
									post = (String)postMap.get("coding_code_id");						
								}
								
								Map laborD_Id = jdbcDAO.queryRecordBySQL("select t.labor_deploy_id,dl.deploy_detail_id ,t.project_father_no ,t.project_info_no  from bgp_comm_human_labor_deploy t  left join bgp_comm_human_labor lr on t.labor_id=lr.labor_id and lr.bsflag='0'  left join bgp_comm_human_deploy_detail dl on dl.labor_deploy_id= t.labor_deploy_id and dl.bsflag='0'  where lr.employee_id_code_no= '"+map.get("employee_id_code_no")+"' and t.bsflag='0'     and t.end_date is null     ");				
								if( laborD_Id != null){						
									d_id = (String)laborD_Id.get("labor_deploy_id");				
									dl_id=(String)laborD_Id.get("deploy_detail_id");		
									p_father_id =(String)laborD_Id.get("project_father_no");
									p_p_id =(String)laborD_Id.get("project_info_no");
								}
								 
						        	map.put("labor_deploy_id", d_id);
						        	map.put("apply_team", apply_team);
									map.put("post", post);
									// 查询记录是否有父子关系
									 if (p_father_id !=null && !"".equals(p_father_id)){ 
										 if(p_father_id.equals(user.getProjectInfoNo())){
												map.put("project_info_no", p_p_id);   
										 }else{ 
											 	map.put("project_info_no", user.getProjectInfoNo()); 
										 }
									 }else{ 
											map.put("project_info_no", user.getProjectInfoNo()); 
									 }
								 
									map.put("bsflag", "0");
									 
							  
								 if (d_id !=null && !"".equals(d_id)){ 
										map.put("updator", user.getEmpId());
										map.put("modifi_date", new Date());
										String d_ids ="";
										String dl_ids="";
								 
										Map laborD_Ids = jdbcDAO.queryRecordBySQL("select t.labor_deploy_id,dl.deploy_detail_id  from bgp_comm_human_labor_deploy t  left join bgp_comm_human_labor lr on t.labor_id=lr.labor_id and lr.bsflag='0'  left join bgp_comm_human_deploy_detail dl on dl.labor_deploy_id= t.labor_deploy_id and dl.bsflag='0'  where lr.employee_id_code_no= '"+map.get("employee_id_code_no")+"' and t.bsflag='0'     and t.end_date is null  and t.actual_start_date is  null  ");				
										if( laborD_Ids != null){						
											  d_ids = (String)laborD_Ids.get("labor_deploy_id");				
											  dl_ids=(String)laborD_Ids.get("deploy_detail_id");		
											 
										}
										if (d_ids !=null && !"".equals(d_ids)){ 
											 BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_labor_deploy");
											 if(dl_id !=null && !"".equals(dl_id)){
											  map.put("labor_deploy_id", d_id);
											  map.put("deploy_detail_id", dl_id);						 
											 }else{
											  map.put("labor_deploy_id", d_id);
											  map.put("deploy_detail_id", "");	
											 }
										    BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_deploy_detail"); 
									       System.out.println("接收导入更新");
									       
									       sumA=sumA+1;
									      	
										}else{
											 System.out.println("未返还,实际进入项目时间为空,实际离开时间为空");
											 sumC=sumC+1;
												messageA.append("第").append(i+1).append("行未导入!");
										}
										
									  
								 }else {
								
									 sumD=sumD+1;
									 
									System.out.println("新增");		
										map.put("creator", user.getEmpId());
										map.put("create_date", new Date());
										map.put("updator", user.getEmpId());
										map.put("modifi_date", new Date());
											 
									     Serializable id =  BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_labor_deploy");
									     String laborDeployId = id.toString(); 
											  map.put("labor_deploy_id", laborDeployId);
											  map.put("deploy_detail_id", "");						 
											 BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_deploy_detail");
										  
								 }
							   
								
								//调配后更新主表的项目状态   1 在项目，2 已调配
								String updateDeloySql = "update bgp_comm_human_labor d  set d.if_project = '1', spare1='2', d.modifi_date = sysdate where d.labor_id = '"+map.get("labor_id")+"' ";
								jdbcDao.getJdbcTemplate().update(updateDeloySql);
								
						
							}
							
							   input="导入成功! 更新"+sumA+"条,";
							   inputMs="新增"+sumD+"条,";
							   inputM="未导入"+sumC+"条 ...";
							  sumM=input+inputMs+inputM +messageA;
							 
							//JOptionPane.showMessageDialog(null,sumM);
						 
						 	//PrintWriter out = response.getWriter();  	out.print("<script type='' language='javascript'>alert('登录成功！')</script>");
							
					   
					}
				}
				
				responseMsg.setValue("message", sumM);
			 
			}
		}

		return responseMsg;		
	}
	
	public void saveImportDeploy(List datelist,UserToken user){
 
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		if(datelist != null && datelist.size()>0){		
		     int  sumC=0;
			 int  sumD=0;
			 
			for(int i=0;i<datelist.size();i++){
				Map map = (HashMap)datelist.get(i);
				
				String apply_team="";
				String post="";
				String d_id="";
				String dl_id="";
				Map teamMap = jdbcDAO.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"+map.get("apply_team_name")+"' and t.coding_sort_id='0110000001' ");				
				if( teamMap != null){						
					apply_team = (String)teamMap.get("coding_code_id");						
				}
				Map postMap = jdbcDAO.queryRecordBySQL("select t.coding_code_id from comm_coding_sort_detail t where t.coding_name like '"+map.get("post_name")+"' and t.coding_sort_id='0110000001' ");				
				if( postMap != null){						
					post = (String)postMap.get("coding_code_id");						
				}
				
				Map laborD_Id = jdbcDAO.queryRecordBySQL("select t.labor_deploy_id,dl.deploy_detail_id  from bgp_comm_human_labor_deploy t  left join bgp_comm_human_labor lr on t.labor_id=lr.labor_id and lr.bsflag='0'  left join bgp_comm_human_deploy_detail dl on dl.labor_deploy_id= t.labor_deploy_id and dl.bsflag='0'  where lr.employee_id_code_no= '"+map.get("employee_id_code_no")+"' and t.bsflag='0'     and t.end_date is null     ");				
				if( laborD_Id != null){						
					d_id = (String)laborD_Id.get("labor_deploy_id");				
					dl_id=(String)laborD_Id.get("deploy_detail_id");		
				}
				 
		        	map.put("labor_deploy_id", d_id);
		        	map.put("apply_team", apply_team);
					map.put("post", post);
					map.put("project_info_no", user.getProjectInfoNo());  
					map.put("bsflag", "0");
					 
			  
				 if (d_id !=null && !"".equals(d_id)){ 
						map.put("updator", user.getEmpId());
						map.put("modifi_date", new Date());
						String d_ids ="";
						String dl_ids="";
						String inputMs="";
					
						
						Map laborD_Ids = jdbcDAO.queryRecordBySQL("select t.labor_deploy_id,dl.deploy_detail_id  from bgp_comm_human_labor_deploy t  left join bgp_comm_human_labor lr on t.labor_id=lr.labor_id and lr.bsflag='0'  left join bgp_comm_human_deploy_detail dl on dl.labor_deploy_id= t.labor_deploy_id and dl.bsflag='0'  where lr.employee_id_code_no= '"+map.get("employee_id_code_no")+"' and t.bsflag='0'     and t.end_date is null  and t.actual_start_date is  null  ");				
						if( laborD_Ids != null){						
							  d_ids = (String)laborD_Ids.get("labor_deploy_id");				
							  dl_ids=(String)laborD_Ids.get("deploy_detail_id");		
							 
						}
						if (d_ids !=null && !"".equals(d_ids)){ 
							 BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_labor_deploy");
							 if(dl_id !=null && !"".equals(dl_id)){
							  map.put("labor_deploy_id", d_id);
							  map.put("deploy_detail_id", dl_id);						 
							 }else{
							  map.put("labor_deploy_id", d_id);
							  map.put("deploy_detail_id", "");	
							 }
						    BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_deploy_detail"); 
					       System.out.println("接收导入更新");
					  
						}else{
							 System.out.println("未返还,实际进入项目时间为空,实际离开时间为空");
							 sumC=sumC+i;
						
						}
						
					  
				 }else {
				
					 sumD=sumD+i;
 
					System.out.println("新增");		
						map.put("creator", user.getEmpId());
						map.put("create_date", new Date());
						map.put("updator", user.getEmpId());
						map.put("modifi_date", new Date());
							 
					     Serializable id =  BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_labor_deploy");
					     String laborDeployId = id.toString(); 
							  map.put("labor_deploy_id", laborDeployId);
							  map.put("deploy_detail_id", "");						 
							 BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"bgp_comm_human_deploy_detail");
						  
				 }
			   
				
				//调配后更新主表的项目状态
				String updateDeloySql = "update bgp_comm_human_labor d  set d.if_project = '1', d.modifi_date = sysdate where d.labor_id = '"+map.get("labor_id")+"' ";
				jdbcDao.getJdbcTemplate().update(updateDeloySql);
				
		
			}
			 String inputMs="导入成功"+sumD+"条,";
			 String inputM="未导入成功"+sumC+"条";
			String sumM=inputM+inputMs;
			lazyBuildNode(null);
			//JOptionPane.showMessageDialog(null,sumM);
		 
		 	//PrintWriter out = response.getWriter();  	out.print("<script type='' language='javascript'>alert('登录成功！')</script>");
			
		}
 
	}
	
	public void lazyBuildNode(HttpServletResponse response) {	
		response.setContentType("text/xml;charset=gbk"); 	
		//response.setCharacterEncoding("GBK");  	
		try {			PrintWriter out = response.getWriter();		
		out.print("<script type='' language='javascript'>alert('登录成功！')</script>");
		out.flush();	
		out.close();	
		} catch (IOException e) {	
			e.printStackTrace();	
			}	
	 
	}
	
	/**
	 * 临时工返还导入
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanLaborReturnExcle(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);	
		UserToken user = reqDTO.getUserToken();
		String laborCategory = reqDTO.getValue("laborCategory");
		SimpleDateFormat datetemp=new SimpleDateFormat("yyyy-MM-dd");
		StringBuffer message = new StringBuffer("");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> fileList = mqMsg.getFiles();
		if(fileList != null && fileList.size()>0){
			WSFile fs = fileList.get(0);
			List<Map> datelist = new ArrayList<Map>();
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
					for (int m = 2; m <= sheet.getLastRowNum(); m++) {   
						row = sheet.getRow(m);	
						String name = "";
						String id = "";
						String team = "";
						String post = "";
						String startDate = "";
						String endDate = "";
						int type = 0;
						Map<String, String> tempMap = new HashMap<String, String>();
						for (int j = 0; j < row.getPhysicalNumberOfCells(); j++) {
							Cell ss=row.getCell(j);							
							
							if (ss != null && !"".equals(ss.toString())) {
								switch (j) {
									case 0:
																		
										ss.setCellType(1); name=ss.getStringCellValue().trim();
										tempMap.put("employee_name", name);
										break;
									case 1:
										ss.setCellType(1);id=ss.getStringCellValue().trim();
										tempMap.put("employee_id_code_no", id);
										break;
									case 4:
										type = ss.getCellType();	
										if(type == 0){
											ss.setCellType(0);
											endDate=datetemp.format(ss.getDateCellValue());
										}else{
											ss.setCellType(1);
											endDate=ss.getStringCellValue().trim();
										}
										
										tempMap.put("end_date",endDate);
										break;
									default:
										break;
								}							
							}
						}	
						
						if(name.equals("") || id.equals("")){
							message.append("第").append(m+1).append("行,姓名或身份证号不能为空!");
						}else{
							String sql = "select t.labor_id from bgp_comm_human_labor t where t.employee_id_code_no='"+id+"' and t.bsflag='0' ";				
							Map laborMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
							if(laborMap == null){
								message.append("第").append(m+1).append("行,临时工不存在!");
							}else{

								String sqlZy = "select t.zy_type from bgp_comm_human_labor_deploy t where t.labor_id='"+laborMap.get("laborId").toString()+"'  and t.project_info_no='"+user.getProjectInfoNo()+"'  and t.bsflag='0' ";				
								Map zyMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlZy);
								if(zyMap == null){
									
									tempMap.put("labor_id", laborMap.get("laborId").toString());
								}else{
									
									 String zy_type=zyMap.get("zyType").toString(); 
					                   if(zy_type.equals("")){ 
					                	   tempMap.put("labor_id", laborMap.get("laborId").toString());
					                   }else{
					                		message.append("第").append(m+1).append("行,临时工已经项目转移,不能返还! ");
					                   }
					                   
								}
								
							
							}
						}

						if(endDate.equals("")){
							message.append("第").append(m+1).append("行,离开项目时间不能为空!");
						}
						if(message.toString().equals("")){
							datelist.add(tempMap);
						}
					}  
				}		
			}catch(Exception e){
				System.out.println("抛出"+e.getMessage());
				
			}
			responseMsg.setValue("laborCategory",laborCategory);
			if(!message.toString().equals("")){
				responseMsg.setValue("message", message.toString());
			}else{
				if(datelist != null && datelist.size()>0){		 	
					 saveImportReturn(datelist,user);
				}
				responseMsg.setValue("message", "导入成功!");
			}
		}

		return responseMsg;		
	}
	
	public void saveImportReturn(List datelist,UserToken user){
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		String projectInfoNo = user.getProjectInfoNo();
		
		if(datelist != null && datelist.size()>0){					
			for(int i=0;i<datelist.size();i++){						
				Map mapDetail = (HashMap)datelist.get(i);
				//返回转移表中的人员
				String sql_zy = "update BGP_COMM_HUMAN_PT_DETAIL set end_date=to_date('"+mapDetail.get("end_date")+"','yyyy-MM-dd'),notes='0110000058000000001', modifi_date = sysdate where  employee_id ='"+mapDetail.get("labor_id")+"' and bproject_info_no='"+projectInfoNo+"' and   pk_ids = 'add'  and bsflag='0')";
				jdbcDao.getJdbcTemplate().update(sql_zy);
				 
				
				//调配后更新调配表主表的状态
				String updateDeloySql = "update bgp_comm_human_labor_deploy d  set d.end_date = to_date('"+mapDetail.get("end_date")+"','yyyy-MM-dd'), d.modifi_date = sysdate where d.project_father_no is null and  d.project_info_no='"+projectInfoNo+"' and d.labor_id = '"+mapDetail.get("labor_id")+"' ";
				jdbcDao.getJdbcTemplate().update(updateDeloySql);			
				
				//返回到 父项目
				String updateDeloySqlf = "update bgp_comm_human_labor_deploy d  set d.end_date ='',d.actual_start_date='',d.project_father_no='', d.modifi_date = sysdate  where d.project_father_no ='"+projectInfoNo+"' and d.labor_id = '"+mapDetail.get("labor_id")+"' ";
				jdbcDao.getJdbcTemplate().update(updateDeloySqlf);		 
				
				//调配后更新主表的项目状态
				String updateDeloySql1 = "update bgp_comm_human_labor d  set d.if_project = '0', spare1='0', d.modifi_date = sysdate where d.labor_id  in (select t.labor_id   from bgp_comm_human_labor_deploy t where t.project_father_no is null  and t.labor_id='"+mapDetail.get("labor_id")+"' ) ";  
				jdbcDao.getJdbcTemplate().update(updateDeloySql1);
				
				String apply_team="";
				String post="";
				String cont_num="";
				String a_date="";
				String le_date="";
				
				 //查询此人在返还记录中的班组岗位，以便赋值给子项目经历信息
				  String sqlTeam="select t.cont_num, d2.apply_team,d2.post ,t.end_date,t.start_date  from bgp_comm_human_labor_deploy  t  left join bgp_comm_human_deploy_detail d2 on t.labor_deploy_id = d2.labor_deploy_id and d2.bsflag='0'    where  t.project_info_no='"+projectInfoNo+"' and t.labor_id = '"+mapDetail.get("labor_id")+"'  and t.bsflag='0' union all        select t.employee_cd cont_num, t.team_s apply_team,   t.post_s post,    t.end_date end_date ,  t.start_date start_date   from BGP_COMM_HUMAN_PT_DETAIL t  left join gp_task_project gp  on t.aproject_info_no = gp.project_info_no  and gp.bsflag = '0'  where t.bsflag = '0'  and t.end_date is not null   and t.pk_ids = 'add'  and t.bproject_info_no = '"+projectInfoNo+"'and t.employee_id='"+mapDetail.get("labor_id")+"' ";
					Map laborMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlTeam);
					if(laborMap != null){
						apply_team=laborMap.get("applyTeam").toString();
						post=laborMap.get("post").toString();
						cont_num=laborMap.get("contNum").toString();
						a_date=laborMap.get("startDate").toString();
						le_date=laborMap.get("endDate").toString();
					}
			  if(!le_date.equals(null) && !le_date.equals("") ){
				  //添加表是针对井中业务的 项目经历
				  String sqlpZ = " select p.project_father_no ,p.project_info_no AS project_info_no,    p.project_name AS project_name,  p.project_common AS project_common,   p.project_status AS project_status,  ccsd.coding_name AS manage_org_name,  DECODE(rpt.START_DATE, NULL, p.START_TIME) AS START_TIME,  DECODE(rpt.end_DATE, NULL, p.END_TIME) AS END_TIME,  oi.org_abbreviation AS team_name,  dy.is_main_team AS is_main_team  from gp_task_project p  join gp_task_project_dynamic dy  on dy.project_info_no = p.project_info_no  and dy.bsflag = '0'  and p.bsflag = '0'  and p.project_father_no = '"+projectInfoNo+"'  and p.project_type = '5000100004000000008'  and dy.is_main_team = '1'  left join comm_org_information oi  on dy.org_id = oi.org_id  left join comm_coding_sort_detail ccsd  on p.manage_org = ccsd.coding_code_id  and ccsd.bsflag = '0'  LEFT JOIN (SELECT DISTINCT rpt.project_info_no,  rpt.start_date,  rpt.end_date  FROM bgp_ws_daily_report rpt  JOIN COMMON_BUSI_WF_MIDDLE wf  ON wf.BUSINESS_ID = rpt.PROJECT_INFO_NO  AND wf.bsflag = '0'  AND rpt.bsflag = '0'  AND wf.BUSI_TABLE_NAME = 'bgp_ws_daily_report'  AND wf.PROC_STATUS = '3') rpt  ON rpt.project_info_no = p.project_info_no "; 
					List listP = BeanFactory.getQueryJdbcDAO().queryRecords(sqlpZ);
					 
					for(int j=0;j<listP.size();j++){
						Map map = (Map)listP.get(j); 
						
						SimpleDateFormat  df = new SimpleDateFormat("yyyy-MM-dd");
						
						Date aDate= new Date();
						Date leDate= new Date();
						Date sDate= new Date();
						Date eDate= new Date();
						
						try {
						  aDate = df.parse(a_date);
						  leDate= df.parse(le_date);
						  sDate = df.parse((String)map.get("startTime"));
						  eDate = df.parse((String)map.get("endTime"));
						
						  } catch (ParseException e) {   e.printStackTrace();  }
						  if(!sDate.equals(null) && !sDate.equals("") ){
								if (sDate.getTime() >= aDate.getTime() &&  sDate.getTime() <=  leDate.getTime()) {
									 
									System.out.println("**********"+(String)map.get("projectName"));
									Map taskDetail = new HashMap(); 
									taskDetail.put("creator", user.getEmpId());
									taskDetail.put("create_date", new Date());
									taskDetail.put("updator", user.getEmpId());
									taskDetail.put("modifi_date", new Date());
									taskDetail.put("bsflag", "0");
									taskDetail.put("spare2", "zi"); 
									taskDetail.put("project_info_no", (String)map.get("projectInfoNo"));
									taskDetail.put("labor_id", mapDetail.get("labor_id"));
									taskDetail.put("START_DATE", (String)map.get("startTime"));
									taskDetail.put("end_date",(String)map.get("endTime"));
									taskDetail.put("apply_team", apply_team);
									taskDetail.put("post", post);
									taskDetail.put("CONT_NUM", cont_num); 
									taskDetail.put("ACTUAL_START_DATE", (String)map.get("startTime"));
									
									 BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(taskDetail,"BGP_COMM_HUMAN_LABOR_PROJECT");
							}
						  }
					}
					
			  }
				 
			}		
		}
	
	}

	public ISrvMsg saveLaborAccept(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		String project_info_no = reqDTO.getValue("project_info_no");
		String labor_category = reqDTO.getValue("labor_category");
		
		int lineNum = Integer.parseInt(reqDTO.getValue("equipmentSize"));
		Map mapDetail = new HashMap();
		String laborDeployId = "";
		String deployDetailId = "";
		for (int i = 0; i < lineNum; i++) {
			BgpCommHumanReceiveLabor applyDetail = new BgpCommHumanReceiveLabor();
			
			PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
					applyDetail);
			mapDetail = PropertiesUtil.describe(applyDetail);
			
			String task_id = (String)mapDetail.get("task_id");
			if(task_id != null){
				mapDetail.put("actual_start_date", mapDetail.get("plan_start_date"));
			}
			mapDetail.put("start_date", mapDetail.get("plan_start_date"));
			mapDetail.put("end_date", mapDetail.get("plan_end_date"));
			mapDetail.put("project_info_no", project_info_no);
			mapDetail.put("creator", user.getEmpId());
			mapDetail.put("create_date", new Date());
			mapDetail.put("updator", user.getEmpId());
			mapDetail.put("modifi_date", new Date());

			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
					"bgp_comm_human_labor_deploy");
			laborDeployId = id.toString();

			
			mapDetail.put("deploy_detail_id", "");
			mapDetail.put("labor_deploy_id", laborDeployId);
			Serializable did = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
				"bgp_comm_human_deploy_detail");
			deployDetailId = did.toString();
			
			
			//调配后更新主表的项目状态 1 在项目，2已调配
			String updateDeloySql = "update bgp_comm_human_labor d  set d.if_project = '1', spare1='2',d.modifi_date = sysdate where d.labor_id = '"+mapDetail.get("labor_id")+"' ";
			jdbcDao.getJdbcTemplate().update(updateDeloySql);
			
			 
			if(task_id != null){
				String[] task_ids = task_id.split(",");
				for(int j=0;j<task_ids.length;j++){
					Map taskDetail = new HashMap();
					
					taskDetail.put("creator", user.getEmpId());
					taskDetail.put("create_date", new Date());
					taskDetail.put("updator", user.getEmpId());
					taskDetail.put("modifi_date", new Date());
					taskDetail.put("bsflag", "0");
					taskDetail.put("task_id", task_ids[j]);
					taskDetail.put("deploy_detail_id", deployDetailId);
					taskDetail.put("project_info_no", project_info_no);
					taskDetail.put("labor_id", mapDetail.get("labor_id"));

					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(taskDetail,
					"bgp_comm_human_receive_labor");
				}
			}				
		} 	
		
		responseDTO.setValue("laborCategory", labor_category);
		return responseDTO;
	}
	//临时工返还
	public ISrvMsg saveLaborReturn(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	 
		String project_info_no = reqDTO.getValue("project_info_no");
		String laborCategory = reqDTO.getValue("laborCategory");
		
		int lineNum = Integer.parseInt(reqDTO.getValue("equipmentSize"));
		Map mapDetail = new HashMap();
		for (int i = 0; i < lineNum; i++) {
	 
			BgpCommHumanReceiveLabor applyDetail = new BgpCommHumanReceiveLabor();			
			PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
					applyDetail);
			mapDetail = PropertiesUtil.describe(applyDetail); 
			String p_father_no=(String)mapDetail.get("project_father_no");
			String l_deploy_id=(String)mapDetail.get("labor_deploy_id");
			String emp_type=(String)mapDetail.get("emp_type");
			
			String apply_team="";
			String post="";
			String cont_num="";
			String a_date="";
			String le_date="";
			System.out.println("***********"+emp_type);
			if(p_father_no !=null && p_father_no !="null" &&  !"".equals(p_father_no)){ 
				   //把人员返还到父项目中 
				String updateDeloySql = "update bgp_comm_human_labor_deploy d  set d.end_date ='',d.actual_start_date='',d.project_father_no='', d.modifi_date = sysdate where d.project_father_no='"+project_info_no+"' and d.labor_id = '"+mapDetail.get("labor_id")+"' ";
				jdbcDao.getJdbcTemplate().update(updateDeloySql); 
				
			}else{ //自己项目返还的人员
				
				if(emp_type.equals("add")){		//转移人员返还
					
					String sql = "update BGP_COMM_HUMAN_PT_DETAIL set end_date=to_date('"+mapDetail.get("end_date")+"','yyyy-MM-dd'),notes='"+mapDetail.get("notes")+"', modifi_date = sysdate where ptdetail_id ='"+l_deploy_id+"'";
					jdbcDao.getJdbcTemplate().update(sql);
					
			
					String updateDeloySql1 = "update bgp_comm_human_labor d  set d.if_project = '0', spare1='0', d.modifi_date = sysdate where d.labor_id = '"+mapDetail.get("labor_id")+"' ";
					jdbcDao.getJdbcTemplate().update(updateDeloySql1);
					
					a_date=mapDetail.get("start_date").toString();
					le_date=mapDetail.get("end_date").toString();
					
				}else 	if(emp_type.equals("edit")){
					//调配后更新调配表主表的状态
					String updateDeloySql = "update bgp_comm_human_labor_deploy d  set d.end_date = to_date('"+mapDetail.get("end_date")+"','yyyy-MM-dd'), d.modifi_date = sysdate where d.project_info_no='"+project_info_no+"' and d.labor_id = '"+mapDetail.get("labor_id")+"' ";
					jdbcDao.getJdbcTemplate().update(updateDeloySql);	
					
					//调配后更新主表的项目状态
					String updateDeloySql1 = "update bgp_comm_human_labor d  set d.if_project = '0', spare1='0', d.modifi_date = sysdate where d.labor_id = '"+mapDetail.get("labor_id")+"' ";
					jdbcDao.getJdbcTemplate().update(updateDeloySql1);
			
					
					
					 //查询此人在返还记录中的班组岗位，以便赋值给子项目经历信息
					  String sqlTeam="select t.cont_num, d2.apply_team,d2.post,t.end_date,t.start_date   from bgp_comm_human_labor_deploy  t  left join bgp_comm_human_deploy_detail d2 on t.labor_deploy_id = d2.labor_deploy_id and d2.bsflag='0'    where  t.labor_deploy_id='"+l_deploy_id+"'  and t.bsflag='0'";
						Map laborMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sqlTeam);
						if(laborMap != null){
							apply_team=laborMap.get("applyTeam").toString();
							post=laborMap.get("post").toString();
							cont_num=laborMap.get("contNum").toString();
							a_date=laborMap.get("startDate").toString();
							le_date=laborMap.get("endDate").toString();
							
						}
				}	
				  if(!le_date.equals(null) && !le_date.equals("") ){
					  //添加表是针对井中业务的 项目经历
					  String sqlpZ = " select p.project_father_no ,p.project_info_no AS project_info_no,    p.project_name AS project_name,  p.project_common AS project_common,   p.project_status AS project_status,  ccsd.coding_name AS manage_org_name,  DECODE(rpt.START_DATE, NULL, p.START_TIME) AS START_TIME,  DECODE(rpt.end_DATE, NULL, p.END_TIME) AS END_TIME,  oi.org_abbreviation AS team_name,  dy.is_main_team AS is_main_team  from gp_task_project p  join gp_task_project_dynamic dy  on dy.project_info_no = p.project_info_no  and dy.bsflag = '0'  and p.bsflag = '0'  and p.project_father_no = '"+project_info_no+"'  and p.project_type = '5000100004000000008'  and dy.is_main_team = '1'  left join comm_org_information oi  on dy.org_id = oi.org_id  left join comm_coding_sort_detail ccsd  on p.manage_org = ccsd.coding_code_id  and ccsd.bsflag = '0'  LEFT JOIN (SELECT DISTINCT rpt.project_info_no,  rpt.start_date,  rpt.end_date  FROM bgp_ws_daily_report rpt  JOIN COMMON_BUSI_WF_MIDDLE wf  ON wf.BUSINESS_ID = rpt.PROJECT_INFO_NO  AND wf.bsflag = '0'  AND rpt.bsflag = '0'  AND wf.BUSI_TABLE_NAME = 'bgp_ws_daily_report'  AND wf.PROC_STATUS = '3') rpt  ON rpt.project_info_no = p.project_info_no  "; 
						List listP = BeanFactory.getQueryJdbcDAO().queryRecords(sqlpZ);
						 
						for(int j=0;j<listP.size();j++){
							Map map = (Map)listP.get(j); 
							
							
							DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	 
							Date aDate = df.parse(a_date);
							Date leDate = df.parse(le_date);
							
							Date sDate = df.parse((String)map.get("startTime"));
							Date eDate = df.parse((String)map.get("endTime"));
							  if(!sDate.equals(null) && !sDate.equals("") ){
								if (sDate.getTime() >= aDate.getTime() &&  sDate.getTime() <=  leDate.getTime()) {
			
									System.out.println(sDate+"**********"+(String)map.get("projectName"));
			  
										Map taskDetail = new HashMap(); 
										taskDetail.put("creator", user.getEmpId());
										taskDetail.put("create_date", new Date());
										taskDetail.put("updator", user.getEmpId());
										taskDetail.put("modifi_date", new Date());
										taskDetail.put("bsflag", "0");
										taskDetail.put("spare2", "zi"); 
										taskDetail.put("project_info_no", (String)map.get("projectInfoNo"));
										taskDetail.put("labor_id", mapDetail.get("labor_id"));
										taskDetail.put("START_DATE", (String)map.get("startTime"));
										taskDetail.put("end_date",(String)map.get("endTime"));
										taskDetail.put("apply_team", apply_team);
										taskDetail.put("post", post);
										taskDetail.put("CONT_NUM", cont_num); 
										taskDetail.put("ACTUAL_START_DATE", (String)map.get("startTime"));
										
										 BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(taskDetail,"BGP_COMM_HUMAN_LABOR_PROJECT");
								}
							  }
						}
						
				  }
			
				
			}
			
		} 	
		responseDTO.setValue("laborCategory", laborCategory);
		return responseDTO;
	}
	
	/**
	 * 进入人员调剂页面包括新增及修改
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg reliefApplyView(ISrvMsg reqDTO) throws Exception {

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
		String projectName = reqDTO.getValue("projectName");
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
		
		
		String buttonView = "true";
		if(reqDTO.getValue("buttonView") !=null && reqDTO.getValue("buttonView") !="null" && !"".equals(reqDTO.getValue("buttonView"))){
			buttonView = reqDTO.getValue("buttonView");
		}
		responseDTO.setValue("buttonView", buttonView);
		responseDTO.setValue("projectInfoType", projectInfoType);
		
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
			
		} else {
			// 查询主表信息
			Map map = new HashMap();
			StringBuffer sb = new StringBuffer(" select r.human_relief_no,r.requirement_no,r.project_info_no,t.project_name, ");
			sb.append(" r.apply_company, to_char(r.apply_date,'yyyy-MM-dd') apply_date,r.applicant_id, ");
			sb.append(" r.apply_no,r.apply_state,r.notes,");
			sb.append(" t1.org_name applicant_org_name,t2.employee_name applicant_name ");
			sb.append(" from bgp_project_human_relief r ");
			sb.append(" left join gp_task_project t on r.project_info_no = t.project_info_no and r.bsflag = '0' ");
			sb.append(" left join comm_org_information t1 on r.apply_company = t1.org_id and t1.bsflag = '0' ");
			sb.append(" left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0' ");
			sb.append(" where r.human_relief_no='").append(keyId).append("' ");
		
			map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
			responseDTO.setValue("applyInfo", map);
			
			// 查询子表信息
			StringBuffer subsql = new StringBuffer(" select p.post_no,p.notes,p.people_number, ");				
			subsql.append(" p.age,p.culture,p.work_years,p.apply_team,p.post,p.plan_start_date,(p.plan_end_date-p.plan_start_date +1) spare1, ");
			subsql.append(" p.plan_end_date,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname ");
			subsql.append(" from bgp_project_human_reliefdetail p");
			subsql.append(" inner join bgp_project_human_relief r on p.human_relief_no= r.human_relief_no ");
			subsql.append(" left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id  and d1.bsflag = '0'  and d1.coding_mnemonic_id='"+projectInfoType+"' ");
			subsql.append(" left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id  and d2.bsflag = '0'  and d2.coding_mnemonic_id='"+projectInfoType+"' ");						
			subsql.append(" where p.bsflag='0' and p.human_relief_no='").append(keyId).append("' order by p.apply_team,p.post ");

			List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
			responseDTO.setValue("detailInfo", list);
			
		}
		
		return responseDTO;
	}
	
	
	public ISrvMsg saveReliefHumanApply(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		Map mapInfo = null;
		BgpProjectHumanRelief applyInfo = new BgpProjectHumanRelief();
		PropertiesUtil.msgToPojo(reqDTO, applyInfo);
		mapInfo = PropertiesUtil.describe(applyInfo);
		
		//申请表主键
		String infoKeyValue = "";
		if (mapInfo.get("human_relief_no") == null) {// 新增操作			
			String applyNo = EquipmentAutoNum.generateNumberByUserToken(
					reqDTO.getUserToken(), "RJSQ");
			mapInfo.put("apply_no", applyNo);
			mapInfo.put("bsflag", "0");
			mapInfo.put("creator", user.getEmpId());
			mapInfo.put("create_date", new Date());
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			mapInfo.put("apply_date", mapInfo.get("apply_date"));
			
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,"bgp_project_human_relief");
			infoKeyValue = id.toString();
		} else {// 修改或审核操作
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			mapInfo.put("apply_date", mapInfo.get("apply_date"));
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,
					"bgp_project_human_relief");
			infoKeyValue = (String) mapInfo.get("human_relief_no");
		}

		int equipmentSize = Integer.parseInt(reqDTO.getValue("equipmentSize"));

		Map mapDetail = new HashMap();
		//存放申请单子表信息
		for (int i = 0; i < equipmentSize; i++) {		
			BgpProjectHumanReliefdetail applyDetail = new BgpProjectHumanReliefdetail();
				PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
						applyDetail);				
				mapDetail = PropertiesUtil.describe(applyDetail);								
		    //	mapDetail.put("bsflag", "0");
				mapDetail.put("human_relief_no", infoKeyValue);				
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modifi_date", new Date());
				
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
				"bgp_project_human_reliefdetail");
		} 
	
		return responseDTO;
	}
	
	/**
	 * 进入人员调剂审核调配页面
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg reliefAuditViewwfpg(ISrvMsg reqDTO) throws Exception {

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
		// 申请表主键

		// 查询主表信息
		Map map = new HashMap();
		StringBuffer sb = new StringBuffer(" select r.human_relief_no,r.project_info_no,t.project_name, ");
		sb.append(" r.apply_company, to_char(r.apply_date,'yyyy-MM-dd') apply_date,r.applicant_id, ");
		sb.append(" r.apply_no,r.apply_state,r.notes,");
		sb.append(" t1.org_name applicant_org_name,t2.employee_name applicant_name ");
		sb.append(" from bgp_project_human_relief r ");
		sb.append(" left join gp_task_project t on r.project_info_no = t.project_info_no and r.bsflag = '0' ");
		sb.append(" left join comm_org_information t1 on r.apply_company = t1.org_id and t1.bsflag = '0' ");
		sb.append(" left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0' ");
		sb.append(" where r.human_relief_no='").append(keyId).append("' ");
	
		map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sb.toString());
		responseDTO.setValue("applyInfo", map);
		
		// 查询子表信息
		StringBuffer subsql = new StringBuffer(" select p.post_no,p.notes,p.people_number, ");				
		subsql.append(" p.age,p.culture,p.work_years,p.apply_team,p.post,p.plan_start_date, ");
		subsql.append(" p.plan_end_date,(p.plan_end_date-p.plan_start_date+1) spare1,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname ");
		subsql.append(" from bgp_project_human_reliefdetail p");
		subsql.append(" inner join bgp_project_human_relief r ").append("on p.human_relief_no= r.human_relief_no ");
		subsql.append(" left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
		subsql.append(" left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");					
		subsql.append(" where p.bsflag='0' and p.human_relief_no='").append(keyId).append("' order by p.apply_team,p.post ");

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(subsql.toString());
		responseDTO.setValue("detailInfo", list);
		
		//调剂人员查询分解表
		StringBuffer querySub = new StringBuffer(" select d.post_detail_no,d.apply_team,d.post,d.people_number,d.deploy_org,d.competence,d.age,d.notes, ");
		querySub.append(" d.work_years,d.work_trade_years,d.culture,d.plan_start_date,d.plan_end_date,t1.org_name deploy_org_name,  ");
		querySub.append(" nvl(d3.coding_name,d.culture) culture_name,d1.coding_name postname, d2.coding_name apply_teamname ");
		querySub.append(" from bgp_project_human_relief_deta d ");
		querySub.append(" inner join bgp_project_human_reliefdetail p on d.post_no = p.post_no and p.bsflag='0' ");
		querySub.append(" inner join bgp_project_human_relief f on p.human_relief_no=f.human_relief_no and f.bsflag='0' ");
		querySub.append(" left join comm_org_information t1 on d.deploy_org = t1.org_id ");
		querySub.append(" left join comm_coding_sort_detail d1 on d.post = d1.coding_code_id ");
		querySub.append(" left join comm_coding_sort_detail d2 on d.apply_team = d2.coding_code_id ");
		querySub.append(" left join comm_coding_sort_detail d3 on d.culture = d3.coding_code_id ");
		querySub.append(" where d.bsflag='0' and f.human_relief_no='").append(keyId).append("' ");
		
		List sublist = BeanFactory.getQueryJdbcDAO().queryRecords(querySub.toString());
		responseDTO.setValue("subDetailInfo", sublist);

		
		return responseDTO;
	}
	
	/**
	 * 人员调剂审核调配保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public ISrvMsg saveReliefAuditwfpa(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		String isPass = reqDTO.getValue("isPass");
		
		if(isPass !=null && "pass".equals(isPass)){
	
			String[] hidEDetailId = {};
			if (reqDTO.getValue("hidEDetailId") != null) {
				hidEDetailId = reqDTO.getValue("hidEDetailId").split(",");
			}
			for (int j = 0; j < hidEDetailId.length; j++) {
				BeanFactory.getPureJdbcDAO().deleteEntity(
						"bgp_project_human_relief_deta", hidEDetailId[j]);
			}
			int equipmentESize = Integer.parseInt(reqDTO.getValue("equipmentESize"));
			String deleteERowFlag = reqDTO.getValue("deleteERowFlag");
			String[] rowEFlag = null;
			Map mapEFlag = new HashMap();
			if (deleteERowFlag != null && !deleteERowFlag.equals("")) {
				rowEFlag = deleteERowFlag.split(",");
				for (int i = 0; i < rowEFlag.length; i++) {
					mapEFlag.put(rowEFlag[i], "true");
				}
			}
			
			Map mapEDetail = new HashMap();
			for (int i = 0; i < equipmentESize; i++) {		
				if (mapEFlag.get(String.valueOf(i)) == null) {
				BgpProjectHumanReliefDeta applyEDetail = new BgpProjectHumanReliefDeta();
				PropertiesUtil.msgToPojo("em" + String.valueOf(i), reqDTO,
						applyEDetail);
				mapEDetail = PropertiesUtil.describe(applyEDetail);	
				
				mapEDetail.put("bsflag", "0");
				mapEDetail.put("creator", user.getEmpId());
				mapEDetail.put("create_date", new Date());
				mapEDetail.put("updator", user.getEmpId());
				mapEDetail.put("modifi_date", new Date());
	
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapEDetail,
							"bgp_project_human_relief_deta");
				}
				
			} 
		}		
		return responseDTO;
	}
	
	/**
	 * 进入专业化人员调配
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg reliefPrepareView(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
	
		String keyId = reqDTO.getValue("id");// 申请表主键
		String project_type = reqDTO.getValue("project_type");
		
		// 查询主表信息
		Map map = new HashMap();
		StringBuffer queryPriSql = new StringBuffer(" select r.human_relief_no,r.project_info_no,t.project_name, ");
		queryPriSql.append(" r.apply_company, to_char(r.apply_date,'yyyy-MM-dd') apply_date,r.applicant_id, ");
		queryPriSql.append(" r.apply_no,r.apply_state,r.notes,s.org_subjection_id,s.org_subjection_id apply_company_sub, ");
		queryPriSql.append(" t1.org_name applicant_org_name,t2.employee_name applicant_name ");
		queryPriSql.append(" from bgp_project_human_relief r ");
		queryPriSql.append(" left join gp_task_project t on r.project_info_no = t.project_info_no and r.bsflag = '0' ");
		queryPriSql.append(" left join comm_org_subjection s on r.apply_company = s.org_id and s.bsflag = '0'  ");
		queryPriSql.append(" left join comm_org_information t1 on r.apply_company = t1.org_id and t1.bsflag = '0' ");
		queryPriSql.append(" left join comm_human_employee t2 on r.applicant_id = t2.employee_id and t2.bsflag = '0' ");
		queryPriSql.append(" where r.human_relief_no='").append(keyId).append("' ");
	
		map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(queryPriSql.toString());
		responseDTO.setValue("applyInfo", map);
		
		//判断是新增还是查看修改,新增查询需求子表/查看修改查询调配子表。为空时为新增，为true时为修改
		String update = reqDTO.getValue("update");

		Map prepareMap = new HashMap();
		//存放调配主表内容
		if (update == null || "".equals(update)) {
			prepareMap.put("applicantName", user.getUserName());
			prepareMap.put("applicantId", user.getEmpId());
			String applyDate = new SimpleDateFormat("yyyy-MM-dd HH:ss")
					.format(new Date());
			prepareMap.put("deployDate", applyDate);
			prepareMap.put("functionType", "2");

		} else {
			// 查询调配主表信息
			String prepareNo = reqDTO.getValue("prepareNo");
			String prepareMapStr =  "select t.prepare_no," +
									"       t.prepare_id," + 
									"       t.applicant_id," + 
									"       to_char(t.deploy_date,'yyyy-MM-dd hh24:mi') deploy_date,t.notes," + 
									"       t.prepare_status,t.function_type,t.prepare_org_id,t.proc_inst_id," + 
									"       t2.employee_name applicant_name,t.spare2,t.spare3" + 
									"  from bgp_human_prepare t" + 
									"  left join comm_human_employee t2 on t.applicant_id = t2.employee_id" + 
									"  and t2.bsflag = '0' and t.bsflag='0' where t.prepare_no='"+prepareNo+"'";
			prepareMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(
					prepareMapStr);
			responseDTO.setValue("update", update);

		}
		
		//传调配信息
		responseDTO.setValue("prepareMap", prepareMap);						
		StringBuffer sb = new StringBuffer();
		if(null != update && !"".equals(update)){		
			// 修改查询子表信息
			String prepareNo = reqDTO.getValue("prepareNo");
			sb.append("select p.prepare_post_detail_no,p.post,p.people_number,p.audit_number,al.pre_num,p.prepare_number,p.notes,r.prepare_org_id,s.org_subjection_id prepare_subjection_id, ");
			sb.append("p.age,p.culture,p.apply_team,p.plan_start_date,p.plan_end_date,p.work_years,p.work_trade_years,p.spare1,d1.coding_name postname, d2.coding_name apply_teamname ");
			sb.append("from bgp_human_prepare_post_detail p inner join bgp_human_prepare r on p.prepare_no=r.prepare_no and r.bsflag='0' ");
			sb.append("left join comm_org_subjection s on r.prepare_org_id = s.org_id and s.bsflag = '0' ");
			sb.append("left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
			sb.append("left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");
			sb.append("left join comm_coding_sort_detail d3 on p.culture = d3.coding_code_id ");
			sb.append("left join (select count(distinct(t.employee_id)) pre_num, t.work_post post ");
			sb.append("from bgp_human_prepare_human_detail t ");
			sb.append("inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' ");
			sb.append("where p.human_relief_no='").append(keyId).append("' and p.prepare_status = '2' and t.bsflag = '0' group by ");
			sb.append(" t.work_post) al on al.post= p.post ");
			sb.append(" where p.bsflag='0' and r.prepare_no='").append(prepareNo).append("' order by p.apply_team,p.post ");

		}else{
			sb.append("select p.post,al.pre_num, p.notes,p.people_number, ");
			sb.append("p.age,p.culture,p.spare1,p.apply_team,p.plan_start_date,p.plan_end_date,p.work_years,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname ");
			sb.append("from bgp_project_human_reliefdetail p ");
			sb.append("inner join bgp_project_human_relief r on p.human_relief_no=r.human_relief_no ");
			sb.append("left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id ");
			sb.append("left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id ");
			sb.append("left join comm_coding_sort_detail d3 on p.culture = d3.coding_code_id ");
			sb.append("left join (select count(distinct(t.employee_id)) pre_num , t.work_post post, p.prepare_org_id ");
			sb.append("from bgp_human_prepare_human_detail t ");
			sb.append("inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' ");
			sb.append("where p.human_relief_no ='").append(keyId).append("' and p.prepare_status = '2' and t.bsflag = '0' group by  p.prepare_org_id, t.work_post ) al on al.post= p.post  ");
			sb.append("and al.prepare_org_id = r.apply_company ");
			sb.append("where p.bsflag='0' and p.human_relief_no='").append(keyId).append("' order by p.apply_team,p.post ");
			
			
			StringBuffer querySub = new StringBuffer(" select d.post_detail_no,d.apply_team,d.post,d.people_number,d.deploy_org,d.competence,d.age,d.notes, ");
			querySub.append(" d.work_years,d.work_trade_years,d.culture,d.plan_start_date,d.plan_end_date,t1.org_name deploy_org_name,  ");
			querySub.append(" nvl(d3.coding_name,d.culture) culture_name,d1.coding_name postname, d2.coding_name apply_teamname,t1.org_name deploy_org_name,t2.org_subjection_id deploy_sub_id ");
			
			querySub.append(" from bgp_project_human_relief_deta d ");
			querySub.append(" inner join bgp_project_human_reliefdetail p on d.post_no = p.post_no and p.bsflag='0' ");
			querySub.append(" inner join bgp_project_human_relief f on p.human_relief_no=f.human_relief_no and f.bsflag='0' ");
			
			querySub.append(" left join (select count(t.employee_id) al_num , t.work_post post , p.prepare_org_id ");
			querySub.append(" from bgp_human_prepare_human_detail t ");
			querySub.append(" inner join bgp_human_prepare p on t.prepare_no = p.prepare_no and p.bsflag = '0' ");
			querySub.append(" where p.profess_no='")
			.append(keyId).append("'  and t.bsflag = '0' group by  p.prepare_org_id,t.work_post ) al ");
			querySub.append(" on al.post= d.post and al.prepare_org_id=d.deploy_org ");
			
			querySub.append(" left join comm_org_information t1 on d.deploy_org = t1.org_id and t1.bsflag='0' ");
			querySub.append(" left join comm_org_subjection t2 on d.deploy_org = t2.org_id and t2.bsflag='0' ");
			
			querySub.append(" left join comm_coding_sort_detail d1 on d.post = d1.coding_code_id ");
			querySub.append(" left join comm_coding_sort_detail d2 on d.apply_team = d2.coding_code_id ");
			querySub.append(" left join comm_coding_sort_detail d3 on d.culture = d3.coding_code_id ");
			querySub.append(" where d.bsflag='0'  ");
			querySub.append(" and f.human_relief_no='").append(keyId).append("' ");
			
			List sublist = BeanFactory.getQueryJdbcDAO().queryRecords(querySub.toString());
			responseDTO.setValue("subDetailInfo", sublist);

		}
		//新增时查询需求子表,修改时查询调配子表(内容为岗位信息)
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		responseDTO.setValue("detailInfo", list);
		
		//如果为修改和查看则查询调配人员信息
		if(null != update && !"".equals(update)){	
			String prepareNo = reqDTO.getValue("prepareNo");
			String huamnStr =  "select t.human_detail_no," +
								"       t.team," + 
								"       t.work_post," + 
								"       t.employee_id," + 
								"       e.employee_name," + 
								"       t.plan_start_date," + 
								"       t.plan_end_date," + 
								"       (t.plan_end_date- t.plan_start_date + 1) plan_days," + 
								"       (t.actual_end_date- t.actual_start_date + 1) actual_days," + 
								"       t.actual_start_date,d1.coding_name work_post_name, d2.coding_name team_name," + 
								"       t.actual_end_date,t.spare1,t.notes " + 
								"  from bgp_human_prepare_human_detail t" + 
								"  inner join bgp_human_prepare r on t.prepare_no = r.prepare_no and r.bsflag='0' " + 
								"  left join comm_coding_sort_detail d1 on t.work_post = d1.coding_code_id"+
		                        "  left join comm_coding_sort_detail d2 on t.team = d2.coding_code_id"+
								"  left join comm_human_employee e on t.employee_id = e.employee_id and e.bsflag='0'"+
								"  where t.prepare_no='"+prepareNo+"'";
			List humanInfoList = BeanFactory.getQueryJdbcDAO().queryRecords(huamnStr);
			responseDTO.setValue("humanInfoList", humanInfoList);
		}
		
		responseDTO.setValue("project_type", project_type);		
		return responseDTO;
	}
	
	/**
	 * 专业化人员调配保存
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */

	public ISrvMsg saveReliefPrepare(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		//人员需求主键
		String humanReliefNo = reqDTO.getValue("humanReliefNo");
		
		String prePrepareNo = reqDTO.getValue("preprepareNo");
		
		BgpHumanPrepare preparePojo = new BgpHumanPrepare();
		PropertiesUtil.msgToPojo("pre", reqDTO, preparePojo);
		Map prepare = new HashMap();
		prepare = PropertiesUtil.describe(preparePojo);
		
		prepare.put("human_relief_no", humanReliefNo);
		prepare.put("project_info_no", projectInfoNo);
		prepare.put("deploy_date", (String) prepare.get("deploy_date"));
		prepare.put("bsflag", "0");
		prepare.put("updator", user.getEmpId());
		prepare.put("modifi_date", new Date());
		prepare.put("prepare_status", "1");
		//主表bgp_human_prepare主键值保存值
		String preIn = "";
		//处理调配主表信息为空则为新增
		if(prePrepareNo == null || "".equals(prePrepareNo)){
			String prepareId = EquipmentAutoNum.generateNumberByUserToken(
					reqDTO.getUserToken(), "RJTP");
			//设状态为调配中
			prepare.put("creator", user.getEmpId());
			prepare.put("create_date", new Date());
			prepare.put("prepare_id", prepareId);
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(prepare,"bgp_human_prepare");
			preIn = id.toString();
					
		}else{
			preIn = prePrepareNo;
			prepare.put("prepare_no", prePrepareNo);
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(prepare,"bgp_human_prepare");
		}
		
		
		Map postDetail = new HashMap();
		String deployOrgId="";
		
		if(reqDTO.getValue("equipmentESize") != null){
			int equipmentESize = Integer.parseInt(reqDTO.getValue("equipmentESize"));
			for (int i = 0; i < equipmentESize; i++) {
				BgpHumanPreparePostDetail prePostDetail = new BgpHumanPreparePostDetail();
				PropertiesUtil.msgToPojo("em" + String.valueOf(i), reqDTO,
						prePostDetail);
				postDetail = PropertiesUtil.describe(prePostDetail);
				if("true".equals(postDetail.get("flag"))){
					deployOrgId = (String)postDetail.get("deploy_org");
					postDetail.put("prepare_no", preIn);
					postDetail.put("bsflag", "0");
					postDetail.put("creator", user.getEmpId());
					postDetail.put("create_date", new Date());
					postDetail.put("updator", user.getEmpId());
					postDetail.put("modifi_date", new Date());

					BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(postDetail,
							"bgp_human_prepare_post_detail");
				}				
			} 
		}			
		if(deployOrgId != null && !"".equals(deployOrgId)){				
			String sql = "update bgp_human_prepare set prepare_org_id='"+deployOrgId+"' where prepare_no ='"+preIn+"'";
			jdbcDao.getJdbcTemplate().update(sql);
		}
		
		
		// 人员调配单人员明细BGP_HUMAN_PREPARE_HUMAN_DETAIL
		String[] hidDeatilId = {};
		if (reqDTO.getValue("hidDetailId") != null) {
			hidDeatilId = reqDTO.getValue("hidDetailId").split(",");
		}
		for (int j = 0; j < hidDeatilId.length; j++) {
			BeanFactory.getPureJdbcDAO().deleteEntity("bgp_human_prepare_human_detail", hidDeatilId[j]);
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
				PropertiesUtil.msgToPojo("hu" + String.valueOf(i), reqDTO,
						applyDetail);
				mapDetail = PropertiesUtil.describe(applyDetail);
				
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
				
			}
		} 
		
		
		return responseDTO;
	}
	
	public ISrvMsg updateP6Accept(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
				
    	HumanAcceptResourceAssignment a = new HumanAcceptResourceAssignment();
    	a.saveP6ResourceAssignment();
    	
		return responseDTO;
	}
	
	public ISrvMsg humanPlanViewwfpg(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
    	
		return responseDTO;
	}
	
	
	/**
	 * 班组岗位维护
	 * 
	 * @param reqMsg
	 * @return
	 * @throws Exception
	 */ 

	public ISrvMsg getTeamCodes(ISrvMsg reqDTO) throws Exception {
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao"); 
		String node = reqDTO.getValue("node");
		List list = new ArrayList();
		if(node==null || node.trim().equals("") || node.trim().equals("root")){//展开的是根节点
			StringBuffer sb = new StringBuffer();
			sb.append(" select t.coding_code_id id,'1f' fs,t.coding_code_id||'_fs' coding_code, t.coding_name coding_name ,'' template_id ,'root' parent_id,'' cost_desc ,'root' zip,'false' leaf ")
			  .append(" from comm_coding_sort_detail t where t.bsflag ='0' and t.coding_sort_id like '5000100004' ")
			  .append(" and (t.coding_code_id ='5000100004000000001' or t.coding_code_id ='5000100004000000006' or t.coding_code_id ='5000100004000000008' ")
			  .append(" or t.coding_code_id ='5000100004000000009' or t.coding_code_id ='5000100004000000010') order by t.coding_code_id");
			list = BeanFactory.getQueryJdbcDAO().queryRecords(sb.toString());
		}else{
			
			if(node.trim().startsWith("5000100004")){
				//查询项目类型下的班组
				StringBuffer sql = new StringBuffer("select * from  (select t.coding_code_id ||'_'|| t.coding_mnemonic_id coding_code_id  , t.coding_code ||'_'|| t.coding_mnemonic_id  id,  t.coding_code ||'_'|| t.coding_mnemonic_id coding_code,  ");
				sql.append("case when length(t.coding_code) = 2 then 1 else 2 end fs, ");
				sql.append("t.coding_name, t.coding_show_id, ");
				sql.append("decode(length(t.coding_code),2,'s',substr(t.coding_code,0,2)) parent_id ");
				sql.append("from comm_coding_sort_detail t ");
				sql.append("where t.coding_sort_id = '0110000001' ");
				sql.append("and t.bsflag = '0' and t.spare1 = '0'   and t.coding_mnemonic_id='"+node+"' order by t.coding_code, t.coding_show_id) w  where w.parent_id='s'    ");

				list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString()); 
			}else{
				//查询项目类型下的班组 对应的岗位  
				String [] sNode = node.split("_"); 
				StringBuffer sql = new StringBuffer("select * from  (select t.coding_code_id ||'_'|| t.coding_mnemonic_id coding_code_id  , t.coding_code id,  t.coding_code,");
				sql.append("case when length(t.coding_code) = 2 then 1 else 2 end fs, ");
				sql.append("t.coding_name, t.coding_show_id, ");
				sql.append("decode(length(t.coding_code),2,'s',substr(t.coding_code,0,2)) parent_id ");
				sql.append("from comm_coding_sort_detail t ");
				sql.append("where t.coding_sort_id = '0110000001' ");
				sql.append("and t.bsflag = '0' and t.spare1 = '0'  and t.coding_mnemonic_id='"+sNode[1]+"'  order by t.coding_code, t.coding_show_id) w  where w.parent_id='"+sNode[0]+"'    ");

				list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString()); 
				
			}
		}
		String json = JSONArray.fromObject(list).toString(); 
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("json", json);
		
		return msg;
	}
	/**
	 * 班组岗位 新增保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveTeamPostCodes(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		String coding_name = reqDTO.getValue("coding_name");
		String coding_code_id = reqDTO.getValue("coding_code_id");		
		String coding_code = reqDTO.getValue("coding_code");
		String coding_show_id = reqDTO.getValue("coding_show_id"); 
		String coding_mnemonic = reqDTO.getValue("coding_mnemonic");
		
		coding_name=URLDecoder.decode(coding_name, "utf-8");
		coding_code_id=URLDecoder.decode(coding_code_id, "utf-8");
		coding_code=URLDecoder.decode(coding_code, "utf-8");
		coding_show_id=URLDecoder.decode(coding_show_id, "utf-8");
		coding_mnemonic=URLDecoder.decode(coding_mnemonic, "utf-8");
		StringBuffer sb = new StringBuffer();
		
		sb.append("insert into comm_coding_sort_detail (coding_code_id,coding_sort_id,coding_code,coding_name,coding_show_id,bsflag,spare1,creator,create_date,coding_mnemonic_id) values ");
		sb.append("( '").append(coding_code_id).append("',");
		sb.append("'0110000001',");
		sb.append("'").append(coding_code).append("',");
		sb.append("'").append(coding_name).append("',");
		sb.append("'").append(coding_show_id).append("',");
		sb.append("'0','0',");
		sb.append("'").append(user.getEmpId()).append("',");
		sb.append("sysdate,'").append(coding_mnemonic).append("') ");

	 	jdbcDao.executeUpdate(sb.toString());

		
		return msg;
	}
	
	public ISrvMsg saveCostPlanCodes(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String codingCode = reqDTO.getValue("codingCode");
		String planId = reqDTO.getValue("planId");
				
		String sql = "select coding_code_id from comm_human_coding_sort where coding_code ='"+codingCode.substring(0, 2) +"' and coding_sort_id ='0000000002'";		
		Map subjectIdMap = jdbcDAO.queryRecordBySQL(sql);
		
		String sql2 = "select plan_sala_id from bgp_comm_human_cost_plan_sala s where s.subject_id ='"+subjectIdMap.get("coding_code_id") +"' and   s.spare5 is null and s.plan_id ='"+planId+"'  and s.project_info_no='"+projectInfoNo+"' and s.bsflag='0' ";		
		Map planSalaMap = jdbcDAO.queryRecordBySQL(sql2);
		
		StringBuffer sql1 = new StringBuffer();
		sql1.append(" select s.project_info_no,sum(s.sum_human_cost) sum_human_cost,sum(s.cont_cost) cont_cost,sum(s.mark_cost) mark_cost,sum(s.temp_cost) temp_cost,sum(s.reem_cost) reem_cost,sum(s.serv_cost) serv_cost ");
		sql1.append(" from bgp_comm_human_cost_plan_sala s where s.subject_id in (");
		sql1.append(" select coding_code_id from comm_human_coding_sort t where t.superior_code_id='").append(subjectIdMap.get("coding_code_id")).append("')");
		sql1.append(" and s.project_info_no='").append(projectInfoNo).append("' and s.bsflag='0'  and s.plan_id ='"+planId+"'     and s.spare5 is null group  by s.project_info_no  ");
		
		Map tempMap = jdbcDAO.queryRecordBySQL(sql1.toString());
		
		Map detail = new HashMap();
		detail.put("project_info_no", projectInfoNo);
		detail.put("plan_id", planId);
		detail.put("subject_id", subjectIdMap.get("coding_code_id"));
		detail.put("sum_human_cost", tempMap.get("sum_human_cost"));
		detail.put("cont_cost", tempMap.get("cont_cost"));
		detail.put("mark_cost", tempMap.get("mark_cost"));
		detail.put("temp_cost", tempMap.get("temp_cost"));
		detail.put("reem_cost", tempMap.get("reem_cost"));
		detail.put("serv_cost", tempMap.get("serv_cost"));
		detail.put("create_date", new Date());
		detail.put("modifi_date", new Date());
		detail.put("org_id", user.getOrgId());
		detail.put("org_subjection_id", user.getOrgSubjectionId());
		detail.put("bsflag", "0");
					
		if(planSalaMap != null){
			//update
			detail.put("plan_sala_id", planSalaMap.get("plan_sala_id"));
		}
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(detail,"bgp_comm_human_cost_plan_sala");
				
		return responseDTO;
	}
	
	
	public ISrvMsg saveCostPlanCodeTs(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String codingCode = reqDTO.getValue("codingCode");
		String planId = reqDTO.getValue("planId");
				
		String sql = "select coding_code_id from comm_human_coding_sort where coding_code ='"+codingCode.substring(0, 2) +"' and coding_sort_id ='0000000002'";		
		Map subjectIdMap = jdbcDAO.queryRecordBySQL(sql);
		
		String sql2 = "select plan_sala_id from bgp_comm_human_cost_plan_sala s where s.subject_id ='"+subjectIdMap.get("coding_code_id") +"' and s.project_info_no='"+projectInfoNo+"' and s.bsflag='0' and s.spare5='1'  and s.plan_id ='"+planId+"'   and s.plan_id='"+planId+"' ";		
		Map planSalaMap = jdbcDAO.queryRecordBySQL(sql2);
		
		StringBuffer sql1 = new StringBuffer();
		sql1.append(" select s.project_info_no,sum(s.sum_human_cost) sum_human_cost,sum(s.cont_cost) cont_cost,sum(s.mark_cost) mark_cost,sum(s.temp_cost) temp_cost,sum(s.reem_cost) reem_cost,sum(s.serv_cost) serv_cost ");
		sql1.append(" from bgp_comm_human_cost_plan_sala s where s.subject_id in (");
		sql1.append(" select coding_code_id from comm_human_coding_sort t where t.superior_code_id='").append(subjectIdMap.get("coding_code_id")).append("')");
		sql1.append(" and s.project_info_no='").append(projectInfoNo).append("' and s.bsflag='0' and s.spare5='1'  and s.plan_id='"+planId+"'   group  by s.project_info_no  ");
		
		Map tempMap = jdbcDAO.queryRecordBySQL(sql1.toString());
		
		Map detail = new HashMap();
		detail.put("project_info_no", projectInfoNo);
		detail.put("plan_id", planId);
		detail.put("subject_id", subjectIdMap.get("coding_code_id"));
		detail.put("sum_human_cost", tempMap.get("sum_human_cost"));
		detail.put("cont_cost", tempMap.get("cont_cost"));
		detail.put("mark_cost", tempMap.get("mark_cost"));
		detail.put("temp_cost", tempMap.get("temp_cost"));
		detail.put("reem_cost", tempMap.get("reem_cost"));
		detail.put("serv_cost", tempMap.get("serv_cost"));
		detail.put("create_date", new Date());
		detail.put("modifi_date", new Date());
		detail.put("org_id", user.getOrgId());
		detail.put("org_subjection_id", user.getOrgSubjectionId());
		detail.put("bsflag", "0");
		detail.put("spare5", "1");		
		
		if(planSalaMap != null){
			//update
			detail.put("plan_sala_id", planSalaMap.get("plan_sala_id"));
		}
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(detail,"bgp_comm_human_cost_plan_sala");
				
		return responseDTO;
	}
	
	
	
	
	public ISrvMsg getCostPlanCodes(ISrvMsg reqDTO) throws Exception {
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		
		String costState = reqDTO.getValue("costState");
		String twoState = reqDTO.getValue("twoState");
		String planIds = reqDTO.getValue("planIds");
		
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		StringBuffer sql = new StringBuffer("select t.coding_code_id, t.coding_code, ");
		sql.append(" s.plan_sala_id,s.project_info_no,s.sum_human_cost,s.cont_cost,s.mark_cost,s.temp_cost,s.reem_cost,s.serv_cost,s.subject_id,s.notes notes1, ");
		sql.append(" case when length(t.coding_code) = 2 then 1 when length(t.coding_code) = 4 then 2 else  3 end fs, ");
		sql.append(" t.coding_name, t.coding_show_order, ");
		sql.append(" decode(length(t.coding_code), 2, 's', 4,substr(t.coding_code, 0, 2),substr(t.coding_code, 0, 4)) parent_id ");
		sql.append(" from comm_human_coding_sort t ");
		sql.append(" left join (select s.* from bgp_comm_human_cost_plan_sala s ");
		sql.append("  inner join bgp_comm_human_plan_cost c on s.project_info_no = c.project_info_no and c.bsflag='0' ");
		sql.append("  and s.plan_id = c.plan_id and c.cost_state = '").append(costState).append("'  ");
		if(twoState != null && !twoState.equals("")){ 
			sql.append("  where s.bsflag='0'  and s.spare5='1' and c.spare5='1' and c.plan_id='"+planIds+"' ) s ");
		}else{
			sql.append("  where s.bsflag='0' and s.spare5 is null  and c.spare5 is null ) s ");
		}
	
		sql.append("  on t.coding_code_id = s.subject_id  and s.project_info_no = '").append(projectInfoNo).append("'    ");
		sql.append("  where t.coding_sort_id = '0000000002' and t.bsflag = '0' ");
		sql.append(" order by t.coding_code, t.coding_show_order ");

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		
		StringBuffer rootSql = new StringBuffer(" select sum(s.sum_human_cost) sum_human_cost ");
//		rootSql.append(" ,sum(s.cont_cost) cont_cost, sum(s.mark_cost) mark_cost, sum(s.temp_cost) temp_cost, sum(s.reem_cost) reem_cost, sum(s.serv_cost) serv_cost  ");
		rootSql.append(" from bgp_comm_human_cost_plan_sala s  inner join bgp_comm_human_plan_cost c on s.project_info_no = c.project_info_no  and c.bsflag='0' ");
		rootSql.append(" and s.plan_id = c.plan_id and c.cost_state = '").append(costState).append("' ");
		rootSql.append(" left join comm_human_coding_sort o on s.subject_id = o.coding_code_id ");
		if(twoState != null && !twoState.equals("")){ 
		 
			rootSql.append(" where s.bsflag = '0'   and length(o.coding_code) = 2   and s.spare5='1' and c.spare5='1'  and c.plan_id='"+planIds+"' and s.project_info_no = '").append(projectInfoNo).append("'");
			
		}else{
			rootSql.append(" where s.bsflag = '0'   and length(o.coding_code) = 2   and s.spare5 is null  and c.spare5 is null  and s.project_info_no = '").append(projectInfoNo).append("'");
		}
		
		
		
		Map rootMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(rootSql.toString());
		
		rootMap.put("codingCodeId", "s");
		rootMap.put("codingCode", "s");
		rootMap.put("parentId", "root");
		rootMap.put("codingName", "项目");
		rootMap.put("codingShowOrder", "1");
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
	//人工成本实际加载树
	public ISrvMsg getCostActCodes(ISrvMsg reqDTO) throws Exception {
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		
		String costState = reqDTO.getValue("costState");
		
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		UserToken user = reqDTO.getUserToken();
		
		StringBuffer sql = new StringBuffer("select t.coding_code_id, t.coding_code, ");
		sql.append(" sum(s.sum_human_cost) sum_human_cost, ");
		sql.append(" case when length(t.coding_code) = 2 then 1 when length(t.coding_code) = 4 then 2 else  3 end fs, ");
		sql.append(" t.coding_name, t.coding_show_order, ");
		sql.append(" decode(length(t.coding_code), 2, 's', 4,substr(t.coding_code, 0, 2),substr(t.coding_code, 0, 4)) parent_id ");
		sql.append(" from comm_human_coding_sort t ");
		sql.append(" left join bgp_comm_human_cost_plan_sala s on t.coding_code_id=s.subject_id  and s.bsflag='0' ");
		sql.append(" and s.project_info_no= '").append(projectInfoNo).append("' ").append(" and s.org_subjection_id like '").append(orgSubjectionId).append("%' ");
		sql.append("  inner join  (  select c.plan_id ,te.proc_status  from  bgp_comm_human_plan_cost c  left join common_busi_wf_middle te  on te.business_id = c.plan_id  and te.bsflag = '0'   where c.bsflag='0' and  c.cost_state = '").append(costState).append("'    and te.proc_status='3'   )c  on s.plan_id = c.plan_id  ");
		sql.append(" where t.coding_sort_id = '0000000002'  and t.bsflag = '0'  ");
		sql.append(" group by t.coding_code_id, t.coding_code,t.coding_name, t.coding_show_order  order by t.coding_code, t.coding_show_order ");

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		
		
		Map rootMap = new HashMap();
		rootMap.put("codingCodeId", "s");
		rootMap.put("codingCode", "s");
		rootMap.put("parentId", "root");
		rootMap.put("codingName",user.getProjectName());
		rootMap.put("codingShowOrder", "1");
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
	
	//综合人工成本实际加载树
public ISrvMsg zhGetCostActCodes(ISrvMsg reqDTO) throws Exception {
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		
		String orgSubjectionId = reqDTO.getValue("orgSubjectionId");
		String projectType = reqDTO.getValue("projectType"); 
		String costState = reqDTO.getValue("costState"); 
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		UserToken user = reqDTO.getUserToken();
		
		StringBuffer sql = new StringBuffer("  select  'true' expanded ,t.coding_code_id,  t.coding_lever,  t.superior_code_id,s.project_info_no,  sum( s.sum_human_cost)sum_human_cost,  sum(s.recruit_cost)recruit_cost,  sum( s.worker_cost)worker_cost,  sum(  s.cont_cost)cont_cost,  sum(  s.mark_cost)mark_cost,  sum(  s.temp_cost)temp_cost,  sum(  s.reem_cost)reem_cost,  sum(  s.serv_cost)serv_cost,  s.subject_id, t.coding_name,  decode(t.superior_code_id, '', 's', t.superior_code_id) as parent_id  ,  decode(t.superior_code_id, '', 's', t.superior_code_id) as parent_p   ");
		if(projectType.equals("5000100004000000009")){
			sql.append("   from comm_human_coding_sort t  ");
		}else{
			sql.append("   from comm_human_coding_sort_detail t  ");
		}
		sql.append("      left join (select s.*   from bgp_comm_human_cost_plan_sala s   inner join bgp_comm_human_plan_cost c  on s.project_info_no = c.project_info_no  and c.bsflag = '0'  and s.plan_id = c.plan_id  where s.bsflag = '0'           and s.project_info_no = '").append(projectInfoNo).append("' ) s  on t.coding_code_id = s.subject_id  where t.coding_sort_id = '0000000005'  and t.bsflag = '0'    and  s.sum_human_cost  is not null   ");
		 
		if(!("5000100004000000009").equals(projectType)){ 
			sql.append("   and t.project_info_no =  '").append(projectInfoNo).append("'   ");
		}
		
		 sql.append("  group by  t.coding_code_id,  t.coding_lever,t.superior_code_id,  s.project_info_no,   s.subject_id,t.coding_name,t.superior_code_id order by  t.coding_lever  ");

		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		
		
		Map rootMap = new HashMap();
		rootMap.put("codingCodeId", "s");
		rootMap.put("codingCode", "s");
		rootMap.put("parentId", "root");
		rootMap.put("codingName",user.getProjectName());
		rootMap.put("codingShowOrder", "1");
		rootMap.put("expanded", "true");
		rootMap.put("codingLever", "0"); 
		
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "codingCodeId", "parentId", rootMap);
		 
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


	public ISrvMsg humanCostReportView(ISrvMsg reqDTO) throws Exception {
		
		String reportId = reqDTO.getValue("reportId");	
		
		String update = reqDTO.getValue("update");	
		
		String isProfess = reqDTO.getValue("isProfess");
		
		UserToken user = reqDTO.getUserToken();
			
		String zbOrg = " not like 'C105006%' ";
		if("true".equals(isProfess)){
			zbOrg = " like 'C105006%' ";
		}
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		Map map = new HashMap();
				
		if(reportId != null && !"".equals(reportId) ){
			
			StringBuffer appsql = new StringBuffer("select t.* from bgp_comm_human_costreport t where t.report_id='").append(reportId).append("'");

			map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(appsql.toString());
		}else{
			
			String applyDate = new SimpleDateFormat("yyyy-MM").format(new Date());
			
			map.put("applyDate", applyDate);
		}
		
		responseDTO.setValue("applyInfo", map);
		
		
		List list = new ArrayList();
		List endlist = new ArrayList();
			
		if(update!= null && "true".equals(update)){
						
			StringBuffer sql = new StringBuffer("");
			
			String date = (String)map.get("applyDate");
			
			sql.append(" with temp_mon as (select d_month end_month, add_months(d_month, -1) + 1 start_month ");					
			sql.append(" from (select add_months(to_date(to_char(to_date('").append(date).append("','yyyy-MM'), 'yyyy') || '0101', 'yyyymmdd') - 1, rownum) d_month from dual ");					
			sql.append(" connect by rownum < to_number(to_char(to_date('").append(date).append("','yyyy-MM'),'MM'))+1) where D_MONTH < add_months(sysdate, 1)) ");
			
			sql.append(" select c.*,c.cont_num+c.mark_num+c.temp_num+c.reem_num+c.serv_num sum_num, nvl(s.sum_human_cost,0) sum_cost,nvl(s.cont_cost,0) cont_cost,nvl(s.mark_cost,0) mark_cost,nvl(s.temp_cost,0) temp_cost,nvl(s.reem_cost,0) reem_cost,nvl(s.serv_cost,0) serv_cost,nvl(p1.const_month,0) const_month,to_number(to_char(to_date('").append(date).append("','yyyy-MM'),'MM')) act_month   from (  ");					
			sql.append(" select project_info_no,project_name,trunc(sum(decode(employee_gz,'0110000019000000001',numbs,0)),0) cont_num,trunc(sum(decode(employee_gz,'0110000019000000002',numbs,0)),0) mark_num,trunc(sum(decode(employee_gz,'0110000059000000005',numbs,0)),0) temp_num,trunc(sum(decode(employee_gz,'0110000059000000003',numbs,0)),0) reem_num,trunc(sum(decode(employee_gz,'0110000059000000001',numbs,0)),0) serv_num from (  ");					
			sql.append(" select p.project_info_no, p.project_name,t.employee_gz, sum(case when actual_end_date < start_month then 0 when actual_start_date > end_month then 0  ");					
			sql.append(" else (case when actual_end_date is null then end_month  when end_month > actual_end_date then ");					
			sql.append(" actual_end_date else end_month end) - (case when start_month < actual_start_date then actual_start_date ");					
			sql.append(" else start_month end)+1  end/to_number(to_char(end_month,'dd')))/to_number(to_char(to_date('").append(date).append("','yyyy-MM'),'MM')) numbs ");					
			sql.append(" from gp_task_project p  ");					
			sql.append(" left join view_human_project_relation t on p.project_info_no=t.PROJECT_INFO_NO left join temp_mon m on 1 = 1 ");	
			sql.append(" left join gp_task_project_dynamic d on p.project_info_no=d.project_info_no and d.bsflag='0' ");
			sql.append(" left join comm_org_subjection s on d.org_id=s.org_id and s.bsflag='0' where p.bsflag='0' ");
			
			if(!"true".equals(isProfess)){
				sql.append(" and s.org_subjection_id like '").append(user.getSubOrgIDofAffordOrg()).append("%' ");
			}
			
			sql.append(" and p.project_status in ( @projectStatus )");
			sql.append(" GROUP BY p.project_info_no,p.project_name,t.employee_gz ) ");					
			sql.append(" group by project_info_no,project_name order by project_info_no ) c left join ( select s.project_info_no, ");					
			sql.append(" sum(nvl(s.sum_human_cost,0)) sum_human_cost, sum(nvl(s.cont_cost,0)) cont_cost, sum(nvl(s.mark_cost,0)) mark_cost, sum(nvl(s.temp_cost,0)) temp_cost, sum(nvl(s.reem_cost,0)) reem_cost, sum(nvl(s.serv_cost,0)) serv_cost ");					
			sql.append(" from bgp_comm_human_cost_act_deta s where to_char(s.app_date, 'yyyy-MM') <= '").append(date).append("' and s.org_subjection_id  ").append(zbOrg);					
			sql.append(" group by s.project_info_no ) s on c.project_info_no=s.project_info_no ");					
			sql.append(" left join bgp_comm_human_cost_plan p1 on c.project_info_no=p1.project_info_no and p1.org_subjection_id ").append(zbOrg).append(" and p1.bsflag='0' order  by project_name ");					
								
			list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString().replaceAll("@projectStatus", " '5000100001000000001','5000100001000000002','5000100001000000004' "));
			
			endlist = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString().replaceAll("@projectStatus", " '5000100001000000003','5000100001000000005'  "));
				
		}else{
				
			String listsql = "select t.* from bgp_comm_human_cost_detail t where t.report_id='"+reportId+"' and t.project_state='0' order by t.project_name ";
			String endlistsql = "select t.* from bgp_comm_human_cost_detail t where t.report_id='"+reportId+"' and t.project_state='1' order by t.project_name ";

			list = BeanFactory.getQueryJdbcDAO().queryRecords(listsql);
			
			endlist = BeanFactory.getQueryJdbcDAO().queryRecords(endlistsql);
			
			responseDTO.setValue("view", "true");
			
		}
		
		responseDTO.setValue("list", list);
		
		responseDTO.setValue("endlist", endlist);
		
		return responseDTO;
	}
	
	
	public ISrvMsg saveHumanCostReport(ISrvMsg reqDTO) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		
		Map mapInfo = null;
		BgpCommHumanCostreport applyInfo = new BgpCommHumanCostreport();
		PropertiesUtil.msgToPojo(reqDTO, applyInfo);
		mapInfo = PropertiesUtil.describe(applyInfo);
		//int it=Integer.parseInt(applyInfo.getOrgId());
		//申请表主键
		String infoKeyValue = "";
		if (mapInfo.get("report_id") == null) {// 新增操作			
			String applyNo = EquipmentAutoNum.generateNumberByUserToken(
					reqDTO.getUserToken(), "RYBB");
			mapInfo.put("report_no", applyNo);
			mapInfo.put("org_id", user.getOrgId());
			mapInfo.put("org_subjection_id", user.getOrgSubjectionId());
			mapInfo.put("apply_company", user.getOrgId());
			mapInfo.put("bsflag", "0");
			mapInfo.put("creator", user.getEmpId());
			mapInfo.put("create_date", new Date());
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			
			Serializable id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,"bgp_comm_human_costreport");
			infoKeyValue = id.toString();
		} else {// 修改或审核操作
			mapInfo.put("updator", user.getEmpId());
			mapInfo.put("modifi_date", new Date());
			mapInfo.put("apply_date", mapInfo.get("apply_date"));
			BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapInfo,
					"bgp_comm_human_costreport");
			infoKeyValue = (String) mapInfo.get("report_id");
		}

		int fysize = Integer.parseInt(reqDTO.getValue("fysize"));
		int emsize = Integer.parseInt(reqDTO.getValue("emsize"));

		Map mapDetail = new HashMap();
		//存放申请单子表信息
		for (int i = 0; i < fysize; i++) {		
			BgpCommHumanCostDetail applyDetail = new BgpCommHumanCostDetail();
				PropertiesUtil.msgToPojo("fy" + String.valueOf(i), reqDTO,
						applyDetail);				
				mapDetail = PropertiesUtil.describe(applyDetail);				

				mapDetail.put("report_id", infoKeyValue);				
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modifi_date", new Date());
				
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
				"bgp_comm_human_cost_detail");
				
		} 
	
		for (int i = 0; i < emsize; i++) {		
			BgpCommHumanCostDetail applyDetail = new BgpCommHumanCostDetail();
				PropertiesUtil.msgToPojo("em" + String.valueOf(i), reqDTO,
						applyDetail);				
				mapDetail = PropertiesUtil.describe(applyDetail);				

				mapDetail.put("report_id", infoKeyValue);				
				mapDetail.put("creator", user.getEmpId());
				mapDetail.put("create_date", new Date());
				mapDetail.put("updator", user.getEmpId());
				mapDetail.put("modifi_date", new Date());
				
				BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(mapDetail,
				"bgp_comm_human_cost_detail");
				
		} 
		return responseDTO;
	}

	public ISrvMsg queryOrgId(ISrvMsg reqDTO) throws Exception {
		
		String empId = reqDTO.getValue("empId");
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String sql = "select e.org_id orgid, s.org_subjection_id orgsubid,i.org_name orgname from comm_human_employee e inner join comm_org_information i on e.org_id=i.org_id inner join comm_org_subjection s on e.org_id=s.org_id where i.bsflag='0' and s.bsflag='0' and e.bsflag='0' and e.employee_id='"+empId+"'";
		
		Map org = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
		
		responseDTO.setValue("org", org);
		
		return responseDTO;
	}
	
	

	public ISrvMsg queryBanzu(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String project_id = isrvmsg.getValue("project_id");
		String splan_id = isrvmsg.getValue("splan_id");
		
		String projectType = user.getProjectType();	
		if(projectType.equals("5000100004000000008")){
			projectType="5000100004000000001";
		}
		if(projectType.equals("5000100004000000010")){
			projectType="5000100004000000001";
		} 
		if(projectType.equals("5000100004000000002")){
			projectType="5000100004000000001";
		}
		
		String sql = "select sd1.coding_code_id,   sd1.coding_name,    sum(p.people_number) num from Comm_Coding_Sort_Detail sd1  left join   bgp_comm_human_plan_detail p   on p.apply_team = sd1.coding_code_id  and         p.project_info_no = '"+project_id+"'  "; 
           if(splan_id !=null && !"".equals(splan_id)){
        	   sql = sql + "  and p.spare1='"+splan_id+"' ";        	   
           }else{
        	   sql = sql + "  and p.spare1 is null ";          	   
           }
	           sql = sql + "     and p.bsflag = '0'    where sd1.coding_sort_id='0110000001' and sd1.coding_mnemonic_id='"+projectType+"'   and sd1.bsflag = '0'  and sd1.spare1='0'  and length(sd1.coding_code) <= 2  group by sd1.coding_code_id, sd1.coding_name order by sd1.coding_code_id  ";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		String Str = "<chart caption='人员班组分布图' canvasBorderThickness='0' yAxisName='人数' baseFontSize ='12'  yAxisNameWidth='16' rotateYAxisName='0'  labelDisplay='WRAP'   >";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  codingName = (String)map.get("codingName");
			String  num = (String)map.get("num");
			String  codingCodeId = (String)map.get("codingCodeId");
			Str = Str+"<set value='"+num+"' link='j-getHumanPost-"+codingCodeId+"' label='"+codingName+"' />";
		}
		Str = Str+"</chart>";
		System.out.println("Str = " + Str);
		
		responseDTO.setValue("Str", Str);
		return responseDTO;
	 
		
	}
	
	public ISrvMsg queryBanPost(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		
		String project_id = isrvmsg.getValue("projectInfoNo");
		String s_team = isrvmsg.getValue("team");
		String splan_id = isrvmsg.getValue("splan_id");
		
		String sql = "select  te.coding_code_id,    te.coding_name ,   sum(p.people_number) num from ( SELECT t.coding_code_id,     t.coding_name  FROM comm_coding_sort_detail t,     (select coding_sort_id, coding_code      from comm_coding_sort_detail  "; 
 
	           sql = sql + "      where (coding_code_id = '"+s_team+"')  and bsflag = '0') d   where t.coding_sort_id = d.coding_sort_id    and t.bsflag = '0'   and t.coding_code like d.coding_code || '_%'    )te   left join bgp_comm_human_plan_detail p     on p.post = te.coding_code_id    and p.project_info_no = '"+project_id+"' " ;
	          
	           if(splan_id !=null && !"".equals(splan_id)){
	        	   sql = sql + "  and p.spare1='"+splan_id+"' ";        	   
	           }else {
	        	   sql = sql + "  and p.spare1 is null";     	        	   
	           }
		      
	           sql = sql + "  and p.bsflag = '0'   group by te.coding_code_id, te.coding_name  order by te.coding_code_id  ";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		
		String Str = "<chart caption='人员岗位分布图'  yAxisName='人数' canvasBorderThickness='0' showYAxisValues='0'  baseFontSize ='12'  yAxisNameWidth='16' rotateYAxisName='0'  labelDisplay='WRAP'   >";
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			String  codingName = (String)map.get("codingName");
			String  num = (String)map.get("num");
			String  codingCodeId = (String)map.get("codingCodeId");
			Str = Str+"<set value='"+num+"'  label='"+codingName+"' />";
		}
		Str = Str+"</chart>";
		System.out.println("Str = " + Str);
		
		responseDTO.setValue("Str", Str);
		return responseDTO;
	 
		
	}
	/*
	 * 审批流程页面导出需求计划信息
	 */
	public ISrvMsg exportHumanPlanM(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		//String projectInfoNo = user.getProjectInfoNo(); 
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String plan_id = reqDTO.getValue("plan_id");
		String paramNo = reqDTO.getValue("paramNo");
		String projectInfoType = reqDTO.getValue("projectInfoType");
		
		Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../rm/em/commHumanInfo/humanPlanExcel.xls"));
		Sheet sheet = wb.getSheetAt(0);
		int rows = sheet.getPhysicalNumberOfRows();
		String[] colName = { "row_num", "name", "planned_start_date", "planned_finish_date", "planned_duration", "apply_team_name", "post_name", "people_number", "profess_number", "plan_start_date",
				"plan_end_date", "nums" };
		StringBuilder sb = new StringBuilder(); 
		
		if(paramNo != null && !paramNo.equals("null")){
			if(paramNo.equals("0")){
				sb.append("select  rownum as row_num,p.name,p.planned_start_date, p.planned_finish_date,p.planned_duration,p.apply_team_name,p.post_name,p.people_number,p.profess_number,p.plan_start_date ,p.plan_end_date,p.nums  from (select d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,to_char(d.plan_start_date,'yyyy-MM-dd')plan_start_date,to_char(d.plan_end_date,'yyyy-MM-dd')plan_end_date,(d.plan_end_date-d.plan_start_date) nums,a.name,to_char(a.planned_start_date,'yyyy-MM-dd')planned_start_date,to_char(a.planned_finish_date,'yyyy-MM-dd')planned_finish_date,a.planned_duration from bgp_comm_human_plan_detail d  left join bgp_p6_activity a on d.task_id=a.object_id and a.bsflag='0' left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0'  and s1.coding_mnemonic_id='"+projectInfoType+"' left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0'   and s2.coding_mnemonic_id='"+projectInfoType+"' where d.project_info_no='"+projectInfoNo+"' and d.spare1='"+plan_id+"' and d.bsflag='0' ) p ");
			}
		}else{
			
			sb.append("select rownum as row_num,p.name,p.planned_start_date, p.planned_finish_date,p.planned_duration,p.apply_team_name,p.post_name,p.people_number,p.profess_number,p.plan_start_date ,p.plan_end_date,p.nums  from (select d.task_id,d.apply_team,s1.coding_name apply_team_name,d.post,s2.coding_name post_name,nvl(d.people_number,0) people_number,nvl(d.profess_number,0) profess_number,to_char(d.plan_start_date,'yyyy-MM-dd')plan_start_date,to_char(d.plan_end_date,'yyyy-MM-dd')plan_end_date,(d.plan_end_date-d.plan_start_date) nums,a.name,to_char(a.planned_start_date,'yyyy-MM-dd')planned_start_date,to_char(a.planned_finish_date,'yyyy-MM-dd')planned_finish_date,a.planned_duration from bgp_comm_human_plan_detail d  left join bgp_p6_activity a on d.task_id=a.object_id and a.bsflag='0' left join comm_coding_sort_detail s1 on d.apply_team=s1.coding_code_id and s1.bsflag='0'  and s1.coding_mnemonic_id='"+projectInfoType+"'  left join comm_coding_sort_detail s2 on d.post=s2.coding_code_id and s2.bsflag='0'  and s2.coding_mnemonic_id='"+projectInfoType+"' where d.project_info_no='"+projectInfoNo+"'  and d.spare1 is null  and d.bsflag='0' ) p  ") ;
		}
		 
		List<Map> list =  BeanFactory.getPureJdbcDAO().queryRecords(sb.toString());
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
		wsfile.setFilename("人力需求计划.xls");
		os.close();
		mqmsgimpl.setFile(wsfile);
		return mqmsgimpl;

	}
	
	
	
	/*
	 * 审批流程页面导出物探处人员申请信息
	 */
	public ISrvMsg exportHumanShenqM(ISrvMsg reqDTO) throws Exception {
		MQMsgImpl mqmsgimpl = (MQMsgImpl) SrvMsgUtil.createMQResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		//String projectInfoNo = user.getProjectInfoNo(); 
		String keyId = reqDTO.getValue("id");
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String projectInfoType = reqDTO.getValue("projectInfoType");
		

		StringBuilder subsql = new StringBuilder(); 
		
		if(keyId != null && !keyId.equals("null"))
		  {	 
			
			Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../rm/em/commHumanInfo/humanShenqExcel.xls"));
			Sheet sheet = wb.getSheetAt(0);
			int rows = sheet.getPhysicalNumberOfRows();
			String[] colName = { "apply_teamname", "postname", "plan_start_date", "plan_end_date", "age", "work_years", "culture", "spare2", "spare3", "z1",
					"z2", "people_number", "audit_number" }; 
			
			subsql.append("select  distinct p.post_no,p.notes, p.people_number,p.audit_number,p.spare2,p.spare3, ");
			subsql.append(" p.age,p.culture,p.work_years,p.apply_team,p.post,p.plan_start_date, ");
			subsql.append(" p.plan_end_date,p.work_trade_years,d1.coding_name postname, d2.coding_name apply_teamname, ");
			subsql.append(" nvl(z1, 0)+nvl(hpt.anber, 0) z1 ,case when nvl(p.spare2,0)-nvl(p.spare3,0)-nvl(z1, 0)-nvl(hpt.anber, 0)  <0 then 0 else nvl(p.spare2,0)-nvl(p.spare3,0)-nvl(z1, 0)-nvl(hpt.anber, 0) end  z2, nvl(z3, 0) + nvl(z4, 0) z3 ");
			subsql.append(" from bgp_project_human_post p");
			subsql.append(" inner join bgp_project_human_requirement r ").append("on p.requirement_no= r.requirement_no");
			subsql.append(" left join comm_coding_sort_detail d1 on p.post = d1.coding_code_id  and d1.bsflag = '0'  and d1.coding_mnemonic_id='"+projectInfoType+"' ");
			subsql.append(" left join comm_coding_sort_detail d2 on p.apply_team = d2.coding_code_id  and d2.bsflag = '0'  and d2.coding_mnemonic_id='"+projectInfoType+"' ");
			subsql.append(" left join ( select  sum(nvl(1, 0)) z1,  d.team, d.work_post,    p.project_info_no  ,d.plan_start_date,  d.plan_end_date    from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p     on d.prepare_no = p.prepare_no    and p.prepare_status = '2'   left join bgp_project_human_relation r     on d.employee_id = r.employee_id    and p.project_info_no = r.project_info_no    and r.team = d.team    and r.work_post = d.work_post   left join common_busi_wf_middle te     on te.business_id = p.prepare_no    and te.bsflag = '0'   left join bgp_project_human_profess pr1     on pr1.profess_no = p.profess_no    and p.profess_no is not null    and pr1.bsflag = '0'   left join bgp_project_human_requirement pr     on pr.requirement_no = p.requirement_no    and p.requirement_no is not null    and pr.bsflag = '0'    left join bgp_project_human_relief re     on re.human_relief_no = p.human_relief_no    and p.human_relief_no is not null    and re.bsflag = '0'   left join gp_task_project t     on p.project_info_no = t.project_info_no      where p.bsflag = '0'    and d.bsflag = '0'    and p.project_info_no =  '").append(projectInfoNo).append("'     and (te.business_id is null or te.proc_status = '3')    and d.actual_start_date is not null    and (d.spare1 is null or d.spare1 = '1')      group by  d.team,d.work_post,p.project_info_no  ,d.plan_start_date,  d.plan_end_date  ) q1   on q1.team = p.apply_team  and q1.work_post = p.post   and q1.plan_start_date=p.plan_start_date  and q1.plan_end_date=p.plan_end_date  ");
			subsql.append(" left join (select sum(nvl(p2.own_num,0)) z3,sum(nvl(p2.deploy_num,0)) z4,p2.apply_team,p2.post from bgp_project_human_profess_post p2 ");
			subsql.append(" inner join bgp_project_human_profess r on p2.profess_no=r.profess_no and r.project_info_no = '").append(projectInfoNo).append("' and r.bsflag='0'  ");
			subsql.append(" where p2.bsflag = '0' group by p2.apply_team,p2.post) q2 on q2.apply_team=p.apply_team and q2.post = p.post ");
			subsql.append(" left  join (    select  distinct     sum(nvl( p.audit_number,0)) anber ,         p.apply_team,   p.post      from bgp_project_human_post p   inner join bgp_project_human_requirement r      on p.requirement_no = r.requirement_no       and r.bsflag='0'         left join common_busi_wf_middle te       on te.business_id = r.requirement_no          and te.bsflag = '0'     where p.bsflag = '0'   and te.proc_status = '3'  and  r.project_info_no='").append(projectInfoNo).append("'      group  by  p.apply_team,     p.post    )hpt      on hpt.apply_team = q1.team    and hpt.post = q1.work_post  "); // on hpt.apply_team=p.apply_team    and hpt.post=p.post ");
			subsql.append(" where p.bsflag='0' and p.requirement_no='").append(keyId).append("' order by p.apply_team,p.post ");
			
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
			wsfile.setFilename("人力申请信息查看.xls");
			os.close();
			mqmsgimpl.setFile(wsfile);
			
		   }else {
			  
				Workbook wb = new HSSFWorkbook(OPCostSrv.class.getResourceAsStream("/../../rm/em/commHumanInfo/humanShenqImExcel.xls"));
				Sheet sheet = wb.getSheetAt(0);
				int rows = sheet.getPhysicalNumberOfRows();
				String[] colName = { "rownum","apply_teamname", "postname", "plan_start_date", "plan_end_date",  "spare2", "spare3", "z1",
						"z2", "people_number", "audit_number" };
		 
				
			// 查询子表信息
			   subsql.append(" select rownum ,tt.* from (select distinct d.apply_team, s1.coding_name apply_teamname, d.post, s2.coding_name postname,  sum(nvl(d.people_number,0)) spare2, sum(nvl(d.profess_number,0)) spare3, d.plan_start_date, d.plan_end_date, ");
				subsql.append(" sum(nvl(z1,0))+sum(nvl(hpt.anber, 0)) z1,case when sum(nvl(d.people_number,0))-sum(nvl(d.profess_number,0))-sum(nvl(z1, 0))-sum(nvl(hpt.anber, 0)) <0 then 0 else sum(nvl(d.people_number,0))-sum(nvl(d.profess_number,0))-sum(nvl(z1, 0))-sum(nvl(hpt.anber, 0))  end  z2, sum(nvl(z3, 0)) + sum(nvl(z4, 0)) z3 , '' people_number,'' audit_number ");
			//subsql.append(" from ( select p.apply_team, p.post,sum(p.people_number) people_number , sum(p.profess_number) profess_number,min(p.plan_start_date) plan_start_date, max(p.plan_end_date) plan_end_date,(max(p.plan_end_date)-min(p.plan_start_date)) nums from ( select distinct d.plan_detail_id,d.task_id,d.apply_team,d.post,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums ");
				subsql.append(" from ( select distinct d.plan_detail_id,d.task_id,d.apply_team,d.post,d.people_number,d.profess_number,d.plan_start_date,d.plan_end_date,(d.plan_end_date-d.plan_start_date) nums ");
				subsql.append(" from bgp_comm_human_plan_detail d ");
				subsql.append(" left join bgp_comm_human_plan p on p.project_info_no=d.project_info_no and p.bsflag='0' ");
				subsql.append(" left join common_busi_wf_middle te on te.business_id=p.plan_id and te.business_type in ('5110000004100000022','5110000004100001057')   and te.bsflag='0' ");
				subsql.append(" where d.project_info_no='").append(projectInfoNo).append("' and te.proc_status='3' and d.bsflag='0' ");
				
			//subsql.append(" ) p group by p.apply_team,p.post ) d ");
				subsql.append("  ) d ");
				
				subsql.append(" left join comm_coding_sort_detail s1 on d.apply_team = s1.coding_code_id and s1.bsflag = '0'  ");
				subsql.append(" left join comm_coding_sort_detail s2 on d.post = s2.coding_code_id and s2.bsflag = '0' ");
				subsql.append(" left join (   select  sum(nvl(1, 0)) z1,  d.team,   d.work_post,       p.project_info_no   ,d.plan_start_date,  d.plan_end_date  from bgp_human_prepare_human_detail d  inner join bgp_human_prepare p     on d.prepare_no = p.prepare_no    and p.prepare_status = '2'   left join bgp_project_human_relation r     on d.employee_id = r.employee_id    and p.project_info_no = r.project_info_no    and r.team = d.team    and r.work_post = d.work_post   left join common_busi_wf_middle te     on te.business_id = p.prepare_no    and te.bsflag = '0'   left join bgp_project_human_profess pr1     on pr1.profess_no = p.profess_no    and p.profess_no is not null    and pr1.bsflag = '0'   left join bgp_project_human_requirement pr     on pr.requirement_no = p.requirement_no    and p.requirement_no is not null    and pr.bsflag = '0'   left join bgp_project_human_relief re     on re.human_relief_no = p.human_relief_no    and p.human_relief_no is not null    and re.bsflag = '0'   left join gp_task_project t     on p.project_info_no = t.project_info_no  where p.bsflag = '0'    and d.bsflag = '0'    and p.project_info_no = '").append(projectInfoNo).append("'     and (te.business_id is null or te.proc_status = '3')    and d.actual_start_date is not null    and (d.spare1 is null or d.spare1 = '1')    group by  d.team,d.work_post,p.project_info_no ,d.plan_start_date,  d.plan_end_date      ) q1   on q1.team = d.apply_team   and q1.work_post = d.post   and q1.plan_start_date=d.plan_start_date  and q1.plan_end_date=d.plan_end_date   ");
			//	subsql.append(" inner join bgp_project_human_requirement r on p1.requirement_no=r.requirement_no and r.project_info_no = '").append(projectInfoNo).append("' and r.bsflag='0'   ");
			//	subsql.append(" where p1.bsflag = '0' group by p1.apply_team,p1.post) q1 on  q1.apply_team=d.apply_team and  q1.post = d.post ");
				subsql.append(" left join (select sum(nvl(p2.own_num,0)) z3,sum(nvl(p2.deploy_num,0)) z4,p2.apply_team,p2.post from bgp_project_human_profess_post p2 ");
				subsql.append(" inner join bgp_project_human_profess r on p2.profess_no=r.profess_no and r.project_info_no = '").append(projectInfoNo).append("'  and r.bsflag='0'  ");
				subsql.append(" where p2.bsflag = '0' group by p2.apply_team,p2.post) q2 on q2.apply_team=d.apply_team and q2.post = d.post  ");
				subsql.append(" left  join (    select  distinct     sum(nvl( p.audit_number,0)) anber ,         p.apply_team,   p.post      from bgp_project_human_post p   inner join bgp_project_human_requirement r      on p.requirement_no = r.requirement_no       and r.bsflag='0'         left join common_busi_wf_middle te       on te.business_id = r.requirement_no          and te.bsflag = '0'    where p.bsflag = '0'  and te.proc_status = '3'  and  r.project_info_no= '").append(projectInfoNo).append("'   group  by  p.apply_team,     p.post    )hpt       on hpt.apply_team = q1.team    and hpt.post = q1.work_post  "); //on hpt.apply_team=d.apply_team    and hpt.post=d.post   ");
				
				subsql.append("     group  by d.apply_team,s1.coding_name, d.post ,  d.plan_start_date,  d.plan_end_date , s2.coding_name   order by d.apply_team,d.post ) tt ");

	
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
				wsfile.setFilename("人力申请信息添加.xls");
				os.close();
				mqmsgimpl.setFile(wsfile);
				
			  
		  }
		 
		 
		return mqmsgimpl;

	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 人工成本计划、人工成本补充计划加载树
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getHumanCodingSortDetail(ISrvMsg reqDTO) throws Exception {
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String planIds = reqDTO.getValue("planIds");
		String codeId = reqDTO.getValue("codeId");
		String spare5=reqDTO.getValue("spare5");//补充计划为1 计划为null
		String projectType=reqDTO.getValue("projectType");
	 
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		StringBuffer sql = new StringBuffer("select t.coding_code_id,t.coding_lever,t.superior_code_id,'true' expanded ,");
		sql.append(" s.plan_sala_id,s.project_info_no,s.sum_human_cost,s.recruit_cost,s.worker_cost,s.cont_cost,s.mark_cost,s.temp_cost,s.reem_cost,s.serv_cost,s.subject_id,s.notes notes1, ");
		sql.append(" t.coding_name,");
		sql.append(" decode(t.superior_code_id, '', 's', t.superior_code_id) as parent_id,decode(t.superior_code_id, '', 's', t.superior_code_id) as parent_p ");
		if("5000100004000000009".equals(projectType)){//综合物化探
			sql.append(" from comm_human_coding_sort t ");
		}else{
			sql.append(" from comm_human_coding_sort_detail t ");
		}
	
		sql.append(" left join (select s.* from bgp_comm_human_cost_plan_sala s ");
		sql.append("  inner join bgp_comm_human_plan_cost c on s.project_info_no = c.project_info_no and c.bsflag='0' ");
		sql.append("  and s.plan_id = c.plan_id ");
		if(null!=spare5&&!"".equals(spare5)){ //人工成本补充计划
			sql.append("  where s.bsflag='0' and s.spare5='1' and c.spare5='1' and c.plan_id='"+planIds+"' ) s ");
		}else{ //人工成本计划
			sql.append("  where s.bsflag='0' and s.spare5 is null  and c.spare5 is null and s.project_info_no = '"+projectInfoNo+"') s ");
		}
		sql.append("  on t.coding_code_id = s.subject_id");
		sql.append("  where t.coding_sort_id = '"+codeId+"' and t.bsflag = '0' ");
		if(projectType == null){ 
			sql.append("  and t.project_info_no = '").append(projectInfoNo).append("'    ");
		}
 
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		
		Map rootMap = new HashMap(); 
		rootMap.put("codingCodeId", "s");
		rootMap.put("codingCode", "s");
		rootMap.put("parentId", "root");
		rootMap.put("codingName", "东方公司");
		rootMap.put("codingShowOrder", "1");
		rootMap.put("expanded", "true");
		rootMap.put("codingLever", "0");
		
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list, "codingCodeId", "parentId", rootMap);
 
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

	public ISrvMsg getHumanCostPlanCodes(ISrvMsg reqDTO) throws Exception {
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		String codeId = reqDTO.getValue("codeId");
		StringBuffer sql = new StringBuffer("select t.coding_code_id,t.coding_lever,");
		sql.append("t.coding_name,t.coding_show_order, ");
		sql.append("t.superior_code_id superior_code_id,decode(t.superior_code_id,'','s',t.superior_code_id) as parent_id ");
		sql.append("from comm_human_coding_sort t ");
		sql.append("where t.coding_sort_id = '"+codeId+"' ");
		sql.append("and t.bsflag = '0' order by t.coding_code, t.coding_show_order ");
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql.toString());
		Map rootMap = new HashMap();
		rootMap.put("codingCodeId", "s");
		rootMap.put("parentId", "root");
		rootMap.put("codingName", "东方公司");
		rootMap.put("codingShowId", "1");
		rootMap.put("expanded", "true");
		rootMap.put("superiorCodeId", "");
		rootMap.put("codingLever","0");
		
		Map jsonMap = OPCommonUtil.convertListTreeToJson(list,"codingCodeId","parentId",rootMap);
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
	
	public ISrvMsg saveHumanCostPlanCodes(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		
		String coding_code_id = reqDTO.getValue("coding_code_id");		
		String coding_name = reqDTO.getValue("coding_name");
		String superior_code_id = reqDTO.getValue("superior_code_id");
		String coding_sort_id= reqDTO.getValue("coding_sort_id");
		String coding_lever = reqDTO.getValue("coding_lever");
		StringBuffer sb = new StringBuffer();
		
		sb.append("insert into comm_human_coding_sort (coding_code_id,coding_sort_id,coding_name,superior_code_id,coding_lever,bsflag,creator,create_date) values ");
		sb.append("( '").append(coding_code_id).append("',");
		sb.append("'"+coding_sort_id+"',");
		sb.append("'").append(coding_name).append("',");
		sb.append("'").append(superior_code_id).append("',");
		sb.append("'").append(coding_lever).append("',");
		sb.append("'0',");
		sb.append("'").append(user.getEmpId()).append("',");
		sb.append("sysdate) ");
		jdbcDao.executeUpdate(sb.toString());
		
		return msg;
	}
	
	/**
	 * 人工成本计划、人工成本补充计划保存
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveCostPlanListCodes(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		
		String projectInfoNo = reqDTO.getValue("projectInfoNo");
		String superiorCodeId = reqDTO.getValue("superiorCodeId");
		String planId = reqDTO.getValue("planId");
		String spare5 = reqDTO.getValue("spare5");//补充为 1	
		
		String sql2 ="";
		if(null!=spare5&&!"".equals(spare5)){//人工成本补充计划
			sql2 ="select plan_sala_id from bgp_comm_human_cost_plan_sala s where s.subject_id ='"+superiorCodeId+"' and   s.spare5='1' and s.plan_id ='"+planId+"'  and s.project_info_no='"+projectInfoNo+"' and s.bsflag='0' ";
		}else{//人工成本计划
			sql2 ="select plan_sala_id from bgp_comm_human_cost_plan_sala s where s.subject_id ='"+superiorCodeId+"' and   s.spare5 is null and s.plan_id ='"+planId+"'  and s.project_info_no='"+projectInfoNo+"' and s.bsflag='0' ";
		}
		Map planSalaMap = jdbcDAO.queryRecordBySQL(sql2);
		
		StringBuffer sql1 = new StringBuffer();
		sql1.append(" select s.project_info_no,sum(s.sum_human_cost) sum_human_cost,sum(s.cont_cost) cont_cost,sum(s.mark_cost) mark_cost,sum(s.temp_cost) temp_cost,sum(s.reem_cost) reem_cost,sum(s.serv_cost) serv_cost,sum(s.recruit_cost) recruit_cost,sum(s.worker_cost) worker_cost ");
		sql1.append(" from bgp_comm_human_cost_plan_sala s where s.subject_id in (");
		sql1.append(" select coding_code_id from comm_human_coding_sort t where t.superior_code_id='").append(superiorCodeId).append("')");
		sql1.append(" and s.project_info_no='").append(projectInfoNo).append("' and s.bsflag='0'  and s.plan_id ='"+planId+"' ");
		if(null!=spare5&&!"".equals(spare5)){//人工成本补充计划
			sql1.append(" and s.spare5='1' ");
		}else{
			sql1.append(" and s.spare5 is null ");
		}
		sql1.append(" group  by s.project_info_no  ");
		Map tempMap = jdbcDAO.queryRecordBySQL(sql1.toString());
		
		Map detail = new HashMap();
		detail.put("project_info_no", projectInfoNo);
		detail.put("plan_id", planId);
		detail.put("subject_id",superiorCodeId);
		detail.put("sum_human_cost", tempMap.get("sum_human_cost"));
		detail.put("cont_cost", tempMap.get("cont_cost"));
		detail.put("mark_cost", tempMap.get("mark_cost"));
		detail.put("temp_cost", tempMap.get("temp_cost"));
		detail.put("reem_cost", tempMap.get("reem_cost"));
		detail.put("serv_cost", tempMap.get("serv_cost"));
		detail.put("recruit_cost", tempMap.get("recruit_cost"));
		detail.put("worker_cost", tempMap.get("worker_cost"));
		detail.put("create_date", new Date());
		detail.put("modifi_date", new Date());
		detail.put("org_id", user.getOrgId());
		detail.put("org_subjection_id", user.getOrgSubjectionId());
		detail.put("bsflag", "0");
		if(null!=spare5&&!"".equals(spare5)){//人工成本补充计划
			detail.put("spare5","1");
		}
		if(planSalaMap != null){
			//update
			detail.put("plan_sala_id", planSalaMap.get("plan_sala_id"));
		}
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(detail,"bgp_comm_human_cost_plan_sala");
				
		return responseDTO;
	}
	
	/**
	 * 人工成本计划节点添加修改
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveHumanCodingSortDetail(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		String detailId = (String)reqDTO.getValue("detail_id");
		
		Map map = reqDTO.toMap();
		map.put("bsflag", "0");
		if (detailId == null || "".equals(detailId)) {
			//如果为空 则添加创建人
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
		}
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		Serializable tecnical_id = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"COMM_HUMAN_CODING_SORT_DETAIL");
		
		msg.setValue("message", "success");
		return msg;
	}
	
}
