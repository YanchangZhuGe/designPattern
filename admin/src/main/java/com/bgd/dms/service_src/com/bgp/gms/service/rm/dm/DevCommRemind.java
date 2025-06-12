package com.bgp.gms.service.rm.dm;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;

/**
 * project: ������̽��������ϵͳ
 * 
 * creator: dz
 * 
 * creator time:2016-1-7
 * 
 * description:�豸������ѷ���
 * 
 */
@Service("DevCommSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class DevCommRemind extends BaseService{
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	
	/**
	 * ��ѯ��ʣ�������ʵ���Ŀ��
	 * 
	 * @param reqDTO
	 * @return ��Ŀ��
	 * @throws Exception
	 * @author wangzheqin 2015-1-7
	 */
	public ISrvMsg getHaveMatProjectCount(ISrvMsg msg) throws Exception {
		log.info("getHaveMatProjectCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);

		String orgSubId = msg.getValue("orgSubId");
		String sb="select B,sum(n) sums from(select ROWNUM as A, tt.project_name B, tt.wz_price as J, tt.coding_code_id D, tt.wz_id E, tt.wz_name F, tt.wz_prickie G, tt.mat_num K, tt.out_num L, tt.stock_num M, round(((case when tt.stock_num is null then 0 else tt.stock_num end) * tt.wz_price),2) N from (select aa.project_name, aa.wz_id, aa.mat_num, case when bb.out_num is null then 0 else bb.out_num end as out_num, (aa.mat_num - case when bb.out_num is null then 0 else bb.out_num end) stock_num, i.coding_code_id, i.wz_name, i.wz_prickie, i.wz_price from (select tid.wz_id, sum(tid.mat_num) mat_num, gp.project_name from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id = tid.invoices_id and tid.bsflag = '0' left join gp_task_project gp on mti.project_info_no = gp.project_info_no left join comm_org_information org on mti.org_id = org.org_id where mti.bsflag = '0' and mti.project_info_no in (select t.project_info_no from (select p.* from gp_task_project p left join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method where 1 = 1 and p.bsflag = '0' and dy.org_subjection_id like '"+orgSubId+"%' and project_year='2017' and project_status='5000100001000000005') t where 1 = 1 and t.project_type in ('5000100004000000001', '5000100004000000002', '5000100004000000010', '5000100004000000007')) and mti.if_input = '0' group by tid.wz_id, gp.project_name) aa left join (select tod.wz_id, sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id = tod.teammat_out_id and tod.bsflag = '0' where mto.bsflag = '0' and mto.project_info_no in (select t.project_info_no from (select p.* from gp_task_project p left join gp_task_project_dynamic dy on dy.bsflag = '0' and dy.project_info_no = p.project_info_no and dy.exploration_method = p.exploration_method where 1 = 1 and p.bsflag = '0' and dy.org_subjection_id like '"+orgSubId+"%' and project_year='2017' and project_status='5000100001000000005') t where 1 = 1 and t.project_type in ('5000100004000000001', '5000100004000000002', '5000100004000000010', '5000100004000000007')) group by tod.wz_id) bb on aa.wz_id = bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag = '0' order by i.coding_code_id asc, aa.wz_id asc) tt ) group by b";
		String proCount = "";// ��Ŀ��

		// ��ѯʩ����������Ŀ����δ��ɷ�������Ŀ��
		
				  

		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(map)) {
			proCount = map.get("sums").toString();
		}

		responseMsg.setValue("procount", proCount);
		return responseMsg;
	}
	/**
	 * ��ѯ����Ŀ��Ŀ������ʩ������δ�����豸��Ŀ����Ŀ��
	 * 
	 * @param reqDTO
	 * @return ��Ŀ����
	 * @throws Exception
	 * @author wangzheqin 2015-1-7
	 */
	public ISrvMsg getDeviceHireProjectCount(ISrvMsg msg) throws Exception {
		log.info("getDeviceHireProjectCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);

		String orgSubId = msg.getValue("orgSubId");
		StringBuffer sb = new StringBuffer();
		String proCount = "";// ��Ŀ��

		// ��ѯʩ����������Ŀ����δ��ɷ�������Ŀ��
		sb.append(
				"select count(*) as proCount from ( select dui.project_info_id from Gp_Task_Project t ")
				.append("join gms_device_account_dui dui on t.project_info_no = dui.project_info_id and dui.bsflag='0' and dui.actual_out_time is null ")
				.append("left join Gp_Task_Project_Dynamic pd on pd.project_info_no = t.project_info_no ")
				.append("where t.project_status in ('5000100001000000005','5000100001000000003') ")
				.append("and pd.org_subjection_id like '")
				.append(orgSubId)
				.append("%' ")
				.append("union select coldui.project_info_id from Gp_Task_Project t join gms_device_coll_account_dui coldui on t.project_info_no = coldui.project_info_id and coldui.bsflag='0' and coldui.unuse_num>0  ")
				.append("left join Gp_Task_Project_Dynamic pd on pd.project_info_no = t.project_info_no ")
				.append("where t.project_status in ('5000100001000000005','5000100001000000003') ")
				.append("and pd.org_subjection_id like '").append(orgSubId)
				.append("%') ");

		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(map)) {
			proCount = map.get("procount").toString();
		}

		responseMsg.setValue("procount", proCount);
		return responseMsg;
	}
	/**
	 * ��ѯͬ���豸
	 * 
	 * @param reqDTO
	 * @return ��Ŀ����
	 * @throws Exception
	 * @author wangzheqin 2015-1-7
	 */
	public ISrvMsg getDeviceSynsCount(ISrvMsg msg) throws Exception {
		log.info("getDeviceSynsCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);

		String orgSubId = msg.getValue("orgSubId");
		int orgLength = orgSubId.length();
		String count = "";// �豸����
		String str = "";
		// ��ѯͬ���豸
		str = "select count(*) as devcount from gms_device_account t"
			+ " where t.bsflag='I' and t.owning_sub_id like '" + orgSubId+ "%' ";
		Map map = jdbcDao.queryRecordBySQL(str);
		if (MapUtils.isNotEmpty(map)) {
			count = map.get("devcount") == null ? "0" : map.get("devcount")
					.toString();
		}
		responseMsg.setValue("count", count);
		return responseMsg;
	}
	/**
	 * ��ѯ����Ŀ��Ŀ������ʩ������δ�����豸��Ŀ���豸����
	 * 
	 * @param reqDTO
	 * @return ��̨δ�����豸��,����δ�����豸��
	 * @throws Exception
	 * @author wangzheqin 2015-1-8
	 */
	public ISrvMsg getDeviceHireDeviceCount(ISrvMsg msg) throws Exception {
		log.info("getDeviceHireDeviceCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String projectInfoNo = msg.getValue("projectInfoNo");

		StringBuffer sb = new StringBuffer();
		String deviceCount = "";// ��̨�豸��
		String deviceCollCount = "";// �����豸�ڶ�����
		// ��ѯ����Ŀʩ����������Ŀ����δ��ɷ����豸��(��̨)
		sb.append(
				"select count(*) as devicecount from gms_device_account_dui dui left join gp_task_project t on dui.project_info_id = t.project_info_no  ")
				.append("where dui.bsflag='0' and dui.actual_out_time is null and t.project_status in ('5000100001000000005','5000100001000000003')  ")
				.append("and dui.project_info_id = '").append(projectInfoNo)
				.append("'");
		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(map)) {
			deviceCount = map.get("devicecount").toString();
		}

		// ��ѯ����Ŀʩ����������Ŀ����δ��ɷ����豸��(�����ڶ�����)
		sb.setLength(0);// ���StringBuffer
		sb.append(
				"select sum(dui.unuse_num) as devicecollcount from gms_device_coll_account_dui dui ")
				.append("left join Gp_Task_Project t on t.project_info_no = dui.project_info_id  ")
				.append("where dui.bsflag='0' and dui.unuse_num>0 and t.project_status in ('5000100001000000005','5000100001000000003') ")
				.append("and dui.project_info_id = '").append(projectInfoNo)
				.append("' ");

		Map colMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(colMap)) {
			deviceCollCount = colMap.get("devicecollcount").toString();
		}

		responseMsg.setValue("deviceCount", deviceCount);
		responseMsg.setValue("deviceCollCount", deviceCollCount);

		return responseMsg;
	}
	/**
	 * ��ѯ����Ŀ��Ŀ������ʩ������δ����װ���豸��Ŀ����Ŀ��
	 * 
	 * @param reqDTO
	 * @return ��Ŀ����
	 * @throws Exception
	 * @author 
	 */
	public ISrvMsg getZBDevProjectCount(ISrvMsg msg) throws Exception {
		log.info("getZBDevProjectCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String orgSubId = msg.getValue("orgSubId");
		String proZBCount = "";// ��Ŀ��
		String zbSubId = "";
		//����ľ--����ľ��ҵ��
		if("C105006008".equals(orgSubId)){
			zbSubId = "C105001005";
		}else if("C105006005".equals(orgSubId)){//�½���̽��--������ҵ��
			zbSubId = "C105001002";
		}else if("C105006009".equals(orgSubId)){//�¹���̽��--�¹���ҵ��
			zbSubId = "C105001003";
		}else if("C105006006".equals(orgSubId)){//�ຣ��̽��--�ػ���ҵ��
			zbSubId = "C105001004";
		}else if("C105006004".equals(orgSubId)){//������̽��--������ҵ��
			zbSubId = "C105005004";
		}else if("C105006029".equals(orgSubId)){//�ɺ���̽��--�ɺ���ҵ��
			zbSubId = "C105063";
		}else if("C105006007".equals(orgSubId)){//������̽��--������ҵ��
			zbSubId = "C105005000";
		}else if("C105006011".equals(orgSubId)){//������̽��--������ҵ��
			zbSubId = "C105005001";
		}else if("C105007".equals(orgSubId)){//�����̽��--�����������Ĵ����ҵ�ֲ�
			zbSubId = "C105007";
		}else{
			zbSubId = "C105";
		}
		// ��ѯʩ����������Ŀ����δ��ɷ�������Ŀ��
		StringBuffer sb = new StringBuffer()
			.append("select count(*) as procount from (select dui.project_info_id from gms_device_account_dui dui"
					+ " left join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id"
					+ " left join gp_task_project pro on dui.project_info_id = pro.project_info_no"
					+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
					+ " where pro.project_status in ('5000100001000000005', '5000100001000000003')"
					+ " and dui.actual_out_time is null and dui.bsflag = '0' and acc.owning_sub_id like 'C105006%'"
					+ " and pro.bsflag = '0' and dy.org_subjection_id like '"+zbSubId+"%' group by dui.project_info_id"
					+ " union"
					+ " select colldui.project_info_id from gms_device_coll_account_dui colldui"
					+ " left join gms_device_coll_account collacc on colldui.fk_dev_acc_id = collacc.dev_acc_id"
					+ " left join gp_task_project pro on colldui.project_info_id = pro.project_info_no"
					+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
					+ " where pro.project_status in ('5000100001000000005', '5000100001000000003')"
					+ " and colldui.unuse_num > 0 and colldui.bsflag = '0' and collacc.owning_sub_id like 'C105006%' "
					+ " and dy.org_subjection_id like '"+zbSubId+"%' group by colldui.project_info_id)");
		Map map = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(map)) {
			proZBCount = map.get("procount").toString();
		}
		responseMsg.setValue("prozbCount", proZBCount);
		return responseMsg;
	}
	/**
	 * NEWMETHOD ���δ����װ���豸����Ŀ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryZBDevProInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		String orgSubId = user.getSubOrgIDofAffordOrg();
		String zbSubId = "";
		//����ľ--����ľ��ҵ��
		if("C105006008".equals(orgSubId)){
			zbSubId = "C105001005";
		}else if("C105006005".equals(orgSubId)){//�½���̽��--������ҵ��
			zbSubId = "C105001002";
		}else if("C105006009".equals(orgSubId)){//�¹���̽��--�¹���ҵ��
			zbSubId = "C105001003";
		}else if("C105006006".equals(orgSubId)){//�ຣ��̽��--�ػ���ҵ��
			zbSubId = "C105001004";
		}else if("C105006004".equals(orgSubId)){//������̽��--������ҵ��
			zbSubId = "C105005004";
		}else if("C105006029".equals(orgSubId)){//�ɺ���̽��--�ɺ���ҵ��
			zbSubId = "C105063";
		}else if("C105006007".equals(orgSubId)){//������̽��--������ҵ��
			zbSubId = "C105005000";
		}else if("C105006011".equals(orgSubId)){//������̽��--������ҵ��
			zbSubId = "C105005001";
		}else if("C105007".equals(orgSubId)){//�����̽��--�����������Ĵ����ҵ�ֲ�
			zbSubId = "C105007";
		}else{
			zbSubId = "C105";
		}
		StringBuffer querySql = new StringBuffer();
		querySql.append("select project_name,usage_sub_name || '-' || org_abbreviation as org_abbreviation"
				+ " from (select case"
				+ " when org_subjection_id like 'C105001005%' then '����ľ��̽��'"
				+ " when org_subjection_id like 'C105001002%' then '�½���̽��'"
				+ " when org_subjection_id like 'C105001003%' then '�¹���̽��'"
				+ " when org_subjection_id like 'C105001004%' then '�ຣ��̽��'"
				+ " when org_subjection_id like 'C105005004%' then '������̽��'"
				+ " when org_subjection_id like 'C105005000%' then '������̽��'"
				+ " when org_subjection_id like 'C105005001%' then '������̽������'"
				+ " when org_subjection_id like 'C105007%' then '�����̽��'"
				+ " when org_subjection_id like 'C105063%' then '�ɺ���̽��'"
				+ " when org_subjection_id like 'C105086%' then '���̽��'"
				+ " when org_subjection_id like 'C105008%' then '�ۺ��ﻯ̽��'"
				+ " when org_subjection_id like 'C105002%' then '���ʿ�̽��ҵ��'"
				+ " else org_abbreviation end as usage_sub_name,project_name,org_abbreviation"
				+ " from (select dui.project_info_id,pro.project_name,info.org_abbreviation,sub.org_subjection_id"
				+ " from gms_device_account_dui dui"
				+ " left join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id"
				+ " left join gp_task_project pro on dui.project_info_id = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no "
				+ " left join comm_org_information info on dy.org_id = info.org_id and info.bsflag = '0'"
				+ " left join comm_org_subjection sub on sub.org_id = info.org_id and sub.bsflag = '0'"
				+ " where pro.project_status in ('5000100001000000005', '5000100001000000003') and dui.actual_out_time is null "
				+ " and dui.bsflag = '0' and acc.owning_sub_id like 'C105006%' and dy.org_subjection_id like '"+zbSubId+"%' and pro.bsflag = '0' "
				+ " group by dui.project_info_id,pro.project_name,info.org_abbreviation,sub.org_subjection_id"
				+ " union"
				+ " select colldui.project_info_id,pro.project_name,info.org_abbreviation,sub.org_subjection_id"
				+ " from gms_device_coll_account_dui colldui "
				+ " left join gms_device_coll_account collacc on colldui.fk_dev_acc_id = collacc.dev_acc_id"
				+ " left join gp_task_project pro on colldui.project_info_id = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no "
				+ " left join comm_org_information info on dy.org_id = info.org_id and info.bsflag = '0'"
				+ " left join comm_org_subjection sub on sub.org_id = info.org_id and sub.bsflag = '0'"
				+ " where pro.project_status in ('5000100001000000005', '5000100001000000003') and colldui.unuse_num > 0"
				+ " and colldui.bsflag = '0' and collacc.owning_sub_id like 'C105006%' and dy.org_subjection_id like '"+zbSubId+"%'"
				+ " and pro.bsflag = '0' group by colldui.project_info_id,pro.project_name,info.org_abbreviation,sub.org_subjection_id))");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by project_name,org_abbreviation ");
		}		
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ�豸����(װ����̨)δ����ĵ�������
	 * 
	 * @param reqDTO
	 * @return �豸����(װ����̨)δ����ĵ�������
	 * @throws Exception
	 * @author dz 2016-5-11
	 */
	public ISrvMsg getZBDevOutUntreCount(ISrvMsg msg) throws Exception {
		log.info("getZBDevOutUntreCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);

		String orgSubId = msg.getValue("orgSubId");
		int orgLength = orgSubId.length();
		String mixcount = "";// δ����������
		// ��ѯδ����ĵ���
		 String str = "select count(*) as mixcount from gms_device_mixinfo_form mix"
				 	+ " left join comm_org_subjection orgsub on mix.out_org_id = orgsub.org_id"
					+ " and orgsub.bsflag = '0'"
					+ " where mix.state = '9' and mix.bsflag = '0' and mix.mix_type_id != 'S0000'"
					+ " and mix.mix_type_id != 'S14059999'  and mix.opr_state = '0'"
					+ " and orgsub.org_subjection_id like '"+orgSubId+"%' ";
		Map map = jdbcDao.queryRecordBySQL(str);
		if (MapUtils.isNotEmpty(map)) {
			mixcount = map.get("mixcount") == null ? "0" : map.get("mixcount")
					.toString();
		}
		responseMsg.setValue("mixcount", mixcount);
		return responseMsg;
	}
	/**
	 * ��ѯ�豸����(װ��������)δ����ĵ�������
	 * 
	 * @param reqDTO
	 * @return �豸����(װ��������)δ����ĵ�������
	 * @throws Exception
	 * @author dz 2016-5-11
	 */
	public ISrvMsg getZBCollOutUntreCount(ISrvMsg msg) throws Exception {
		log.info("getZBCollOutUntreCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);

		String orgSubId = msg.getValue("orgSubId");
		int orgLength = orgSubId.length();
		String mixcollcount = "";// δ����������
		// ��ѯδ����ĵ���
		String str = "select count(*) as mixcollcount"
				   + " from (select cmf.opr_state from gms_device_collmix_form cmf"
				   + " left join comm_org_subjection orgsub on cmf.out_org_id = orgsub.org_id "
				   + " and orgsub.bsflag = '0'"
				   + " where cmf.state = '9' and cmf.bsflag = '0' and orgsub.org_subjection_id like '"+orgSubId+"%'"
				   + " and cmf.opr_state = '0'"
				   + " union all"
				   + " select mix.opr_state"
				   + " from gms_device_mixinfo_form mix"
				   + " left join comm_org_subjection orgsub on mix.out_org_id = orgsub.org_id and orgsub.bsflag = '0'"
				   + " where mix.state = '9' and mix.bsflag = '0' and mix.mix_type_id = 'S14059999'"
				   + " and orgsub.org_subjection_id like '"+orgSubId+"%' and mix.opr_state = '0' ) ";
		Map map = jdbcDao.queryRecordBySQL(str);
		if (MapUtils.isNotEmpty(map)) {
			mixcollcount = map.get("mixcollcount") == null ? "0" : map.get("mixcollcount")
					.toString();
		}
		responseMsg.setValue("mixcollcount", mixcollcount);
		return responseMsg;
	}
	/**
	 * ��ѯ����δ�����豸���ݵ���Ŀ
	 * 
	 * @param reqDTO
	 * @return ��Ŀ����
	 * @throws Exception
	 * @author dz 2016-5-13
	 */
	public ISrvMsg getDevNoRecvProjectCount(ISrvMsg msg) throws Exception {
		log.info("getDevNoRecvProjectCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);

		String orgSubId = msg.getValue("orgSubId");
		String proCount = "";// ��Ŀ��

		String str = "select count(*) as norecvcount"
			   + " from (select pro.project_name from gms_device_mixinfo_form m"
			   + " left join gp_task_project pro on m.project_info_no = pro.project_info_no"
			   + " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
			   + " where m.opr_state = '0' and m.bsflag = '0' and (m.state = '1' or m.state = '9')"
			   + " and (m.mix_type_id = 'S0000' or m.mix_type_id = 'S14050208')"
			   + " and dy.org_subjection_id like '"+orgSubId+"%'"
			   + " union"
			   + " select pro.project_name from gms_device_equ_outform outform"
			   + " left join gp_task_project pro on outform.project_info_no = pro.project_info_no"
			   + " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
			   + " where outform.bsflag = '0' and outform.state = '9' and outform.opr_state = '0'"
			   + " and pro.bsflag = '0' and exists"
			   + " (select 1 from gms_device_equ_outdetail amd"
			   + " left join gms_device_equ_outsub amm on amd.device_oif_subid = amm.device_oif_subid"
			   + " where outform.device_outinfo_id = amm.device_outinfo_id)"
			   + " and dy.org_subjection_id like '"+orgSubId+"%'"
			   + " union"
			   + " select pro.project_name from gms_device_hireapp devapp"
			   + " left join common_busi_wf_middle wf on wf.business_id = devapp.device_hireapp_id and wf.bsflag = '0'"
			   + " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
			   + " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
			   + " where devapp.bsflag = '0' and devapp.opr_state = '0' and pro.bsflag = '0'"
			   + " and (wf.proc_status = '3' or devapp.state = '1')"
			   + " and dy.org_subjection_id like '"+orgSubId+"%'"
			   + " union"
			   + " select pro.project_name from gms_device_coll_outform cof"
			   + " left join gp_task_project pro on cof.project_info_no = pro.project_info_no"
			   + " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
			   + " where cof.bsflag = '0' and cof.devouttype != '2' and cof.opr_state = '0'"
			   + " and pro.bsflag = '0' and exists (select 1"
			   + " from gms_device_coll_outsub sub where sub.device_outinfo_id = cof.device_outinfo_id)"
			   + " and dy.org_subjection_id like '"+orgSubId+"%'"
			   + " union"
			   + " select pro.project_name from gms_device_coll_outform cof"
			   + " left join gp_task_project pro on cof.project_info_no = pro.project_info_no"
			   + " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
			   + " where cof.bsflag = '0' and cof.devouttype = '2' and cof.opr_state = '0'"
			   + " and pro.bsflag = '0' and dy.org_subjection_id like '"+orgSubId+"%'"
			   + " union"
			   + " select tp.project_name from gms_device_mixinfo_form dm"
			   + " left join gp_task_project tp on dm.project_info_no = tp.project_info_no"
			   + " left join gp_task_project_dynamic dy on tp.project_info_no = dy.project_info_no"
			   + " where dm.state = '1' and dm.opr_state = '0' and dm.bsflag = '0' and dm.mix_type_id = 'S1405'"
			   + " and dm.mixform_type = '7' and dy.org_subjection_id like '"+orgSubId+"%') ";

		Map map = jdbcDao.queryRecordBySQL(str);
		if (MapUtils.isNotEmpty(map)) {
			proCount = map.get("norecvcount").toString();
		}

		responseMsg.setValue("procount", proCount);
		return responseMsg;
	}
	/**
	 * NEWMETHOD ����Ŀ��˾���Ǳ�����ʾ����δ�����豸����Ŀ(������������Ŀ)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryNotRecvProInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select pro_sub_name || '-' || org_abbreviation as sub_org_name,project_name,"
				+ " decode(org_abbreviation,'',pro_sub_name,org_abbreviation) as dui_org_name from (select"
				+ " case"
				+ " when sub.org_subjection_id like 'C105001005%' then '����ľ��̽��'"
				+ " when sub.org_subjection_id like 'C105001002%' then '�½���̽��'"
				+ " when sub.org_subjection_id like 'C105001003%' then '�¹���̽��'"
				+ " when sub.org_subjection_id like 'C105001004%' then '�ຣ��̽��'"
				+ " when sub.org_subjection_id like 'C105005004%' then '������̽��'"
				+ " when sub.org_subjection_id like 'C105005000%' then '������̽��'"
				+ " when sub.org_subjection_id like 'C105005001%' then '������̽������'"
				+ " when sub.org_subjection_id like 'C105007%' then '�����̽��'"
				+ " when sub.org_subjection_id like 'C105063%' then '�ɺ���̽��'"
				+ " when sub.org_subjection_id like 'C105086%' then '���̽��'"
				+ " when sub.org_subjection_id like 'C105008%' then '�ۺ��ﻯ̽��'"
				+ " when sub.org_subjection_id like 'C105002%' then '���ʿ�̽��ҵ��'"
				+ " else org_abbreviation end as pro_sub_name,"
				+ " project_name,org_abbreviation,project_year from ("
				+ " select pro.project_year,pro.project_name,oi.org_abbreviation,dy.org_subjection_id"
				+ " from gms_device_mixinfo_form m"
				+ " left join gp_task_project pro on m.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
				+ " left join comm_org_information oi on dy.org_id = oi.org_id and oi.bsflag = '0'"
				+ " where m.opr_state = '0' and m.bsflag = '0' and (m.state = '1' or m.state = '9')"
				+ " and (m.mix_type_id = 'S0000' or m.mix_type_id = 'S14050208')"
				+ " and dy.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
				+ " union"
				+ " select pro.project_year,pro.project_name,oi.org_abbreviation,dy.org_subjection_id"
				+ " from gms_device_equ_outform outform"
				+ " left join gp_task_project pro on outform.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
				+ " left join comm_org_information oi on dy.org_id = oi.org_id and oi.bsflag = '0'"
				+ " where outform.bsflag = '0' and outform.state = '9' and outform.opr_state = '0'"
				+ " and pro.bsflag = '0' and exists (select 1"
				+ " from gms_device_equ_outdetail amd "
				+ " left join gms_device_equ_outsub amm on amd.device_oif_subid = amm.device_oif_subid"
				+ " where outform.device_outinfo_id = amm.device_outinfo_id)"
				+ " and dy.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
				+ " union"
				+ " select pro.project_year,pro.project_name,oi.org_abbreviation,dy.org_subjection_id"
				+ " from gms_device_hireapp devapp"
				+ " left join common_busi_wf_middle wf on wf.business_id = devapp.device_hireapp_id and wf.bsflag = '0'"
				+ " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
				+ " left join comm_org_information oi on dy.org_id = oi.org_id and oi.bsflag = '0'"
				+ " where devapp.bsflag = '0' and devapp.opr_state = '0' and pro.bsflag = '0'"
				+ " and (wf.proc_status = '3' or devapp.state = '1')"
				+ " and dy.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
				+ " union"
				+ " select pro.project_year,pro.project_name,oi.org_abbreviation,dy.org_subjection_id"
				+ " from gms_device_coll_outform cof"
				+ " left join gp_task_project pro on cof.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
				+ " left join comm_org_information oi on dy.org_id = oi.org_id and oi.bsflag = '0'"
				+ " where cof.bsflag = '0' and cof.devouttype != '2' and cof.opr_state = '0'"
				+ " and pro.bsflag = '0' and exists (select 1 from gms_device_coll_outsub sub"
				+ " where sub.device_outinfo_id = cof.device_outinfo_id)"
				+ " and dy.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
				+ " union"
                + " select pro.project_year,pro.project_name,oi.org_abbreviation,dy.org_subjection_id"
                + " from gms_device_mixinfo_form cof"
                + " left join gp_task_project pro on cof.project_info_no = pro.project_info_no"
                + " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
                + " left join comm_org_information oi on dy.org_id = oi.org_id and oi.bsflag = '0'"
                + " where cof.state = '1' and cof.opr_state = '0' and cof.bsflag = '0'"
                + " and cof.mix_type_id = 'S1405' and cof.mixform_type = '7' and pro.bsflag = '0'"
                + " and dy.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
				+ " union"
				+ " select pro.project_year,pro.project_name,oi.org_abbreviation,dy.org_subjection_id"
				+ " from gms_device_coll_outform cof"
				+ " left join gp_task_project pro on cof.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
				+ " left join comm_org_information oi on dy.org_id = oi.org_id and oi.bsflag = '0'"
				+ " where cof.bsflag = '0' and cof.devouttype = '2' and cof.opr_state = '0' and pro.bsflag = '0'"
				+ " and dy.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%' )sub)");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by project_year ");
		}
		
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ����δ�����豸���ݵ���Ŀ(����������Ŀ)
	 * 
	 * @param reqDTO
	 * @return ��Ŀ����
	 * @throws Exception
	 * @author dz 2016-5-13
	 */
	public ISrvMsg getZBDevNoRecvProjectCount(ISrvMsg msg) throws Exception {
		log.info("getZBDevNoRecvProjectCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);

		String orgSubId = msg.getValue("orgSubId");
		String proCount = "";// ��Ŀ��

		String str = "select count(*) as norecvcount"
			   + " from ("
			   + " select pro.project_name from gms_device_equ_outform outform"
			   + " left join gp_task_project pro on outform.project_info_no = pro.project_info_no"
			   + " where outform.bsflag = '0' and outform.state = '9' and outform.opr_state = '0'"
			   + " and pro.bsflag != '1' and exists"
			   + " (select 1 from gms_device_equ_outdetail amd"
			   + " left join gms_device_equ_outsub amm on amd.device_oif_subid = amm.device_oif_subid"
			   + " where outform.device_outinfo_id = amm.device_outinfo_id)"
			   + " union"
			   + " select pro.project_name from gms_device_coll_outform cof"
			   + " left join gp_task_project pro on cof.project_info_no = pro.project_info_no"
			   + " where cof.bsflag = '0' and cof.devouttype != '2' and cof.opr_state = '0'"
			   + " and pro.bsflag = '0' and exists (select 1"
			   + " from gms_device_coll_outsub sub where sub.device_outinfo_id = cof.device_outinfo_id)"
			   + " union"
			   + " select pro.project_name from gms_device_coll_outform cof"
			   + " left join gp_task_project pro on cof.project_info_no = pro.project_info_no"
			   + " where cof.bsflag = '0' and cof.devouttype = '2' and cof.opr_state = '0'"
			   + " and pro.bsflag = '0' ) ";

		Map map = jdbcDao.queryRecordBySQL(str);
		if (MapUtils.isNotEmpty(map)) {
			proCount = map.get("norecvcount").toString();
		}

		responseMsg.setValue("procount", proCount);
		return responseMsg;
	}
	/**
	 * NEWMETHOD װ��������Ŀ��˾���Ǳ�����ʾ����δ�����豸����Ŀ(����������Ŀ)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryZBNotRecvProInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select pro_sub_name || '-' || org_abbreviation as sub_org_name,project_name,"
				+ " decode(org_abbreviation,'',pro_sub_name,org_abbreviation) as dui_org_name from (select"
				+ " case"
				+ " when sub.org_subjection_id like 'C105001005%' then '����ľ��̽��'"
				+ " when sub.org_subjection_id like 'C105001002%' then '�½���̽��'"
				+ " when sub.org_subjection_id like 'C105001003%' then '�¹���̽��'"
				+ " when sub.org_subjection_id like 'C105001004%' then '�ຣ��̽��'"
				+ " when sub.org_subjection_id like 'C105005004%' then '������̽��'"
				+ " when sub.org_subjection_id like 'C105005000%' then '������̽��'"
				+ " when sub.org_subjection_id like 'C105005001%' then '������̽������'"
				+ " when sub.org_subjection_id like 'C105007%' then '�����̽��'"
				+ " when sub.org_subjection_id like 'C105063%' then '�ɺ���̽��'"
				+ " when sub.org_subjection_id like 'C105086%' then '���̽��'"
				+ " when sub.org_subjection_id like 'C105008%' then '�ۺ��ﻯ̽��'"
				+ " when sub.org_subjection_id like 'C105002%' then '���ʿ�̽��ҵ��'"
				+ " else org_abbreviation end as pro_sub_name,"
				+ " project_name,org_abbreviation,project_year from ("
				+ " select pro.project_year,pro.project_name,oi.org_abbreviation,dy.org_subjection_id"
				+ " from gms_device_equ_outform outform"
				+ " left join gp_task_project pro on outform.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
				+ " left join comm_org_information oi on dy.org_id = oi.org_id"
				+ " where outform.bsflag = '0' and outform.state = '9' and outform.opr_state = '0'"
				+ " and pro.bsflag != '1' and exists (select 1"
				+ " from gms_device_equ_outdetail amd "
				+ " left join gms_device_equ_outsub amm on amd.device_oif_subid = amm.device_oif_subid"
				+ " where outform.device_outinfo_id = amm.device_outinfo_id)"
				+ " union"
				+ " select pro.project_year,pro.project_name,oi.org_abbreviation,dy.org_subjection_id"
				+ " from gms_device_coll_outform cof"
				+ " left join gp_task_project pro on cof.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
				+ " left join comm_org_information oi on dy.org_id = oi.org_id"
				+ " where cof.bsflag = '0' and cof.devouttype != '2' and cof.opr_state = '0'"
				+ " and pro.bsflag = '0' and exists (select 1 from gms_device_coll_outsub sub"
				+ " where sub.device_outinfo_id = cof.device_outinfo_id)"
				+ " union"
				+ " select pro.project_year,pro.project_name,oi.org_abbreviation,dy.org_subjection_id"
				+ " from gms_device_coll_outform cof"
				+ " left join gp_task_project pro on cof.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on pro.project_info_no = dy.project_info_no"
				+ " left join comm_org_information oi on dy.org_id = oi.org_id"
				+ " where cof.bsflag = '0' and cof.devouttype = '2' and cof.opr_state = '0' and pro.bsflag = '0')sub)");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by project_year ");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ����δ�����豸���ݵ���Ŀ(�Ӽ��Ǳ���)
	 * 
	 * @param reqDTO
	 * @return ��Ŀ����
	 * @throws Exception
	 * @author dz 2016-5-13
	 */
	public ISrvMsg getDuiDevNoRecvProCount(ISrvMsg msg) throws Exception {
		log.info("getDuiDevNoRecvProjectCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);

		String projectInfoNo = msg.getValue("projectInfoNo");
		String duiProCount = "";// ��Ŀ��

		String str = "select count(*) as duiprocount"
			    + " from ("
				+ " select m.project_info_no from gms_device_mixinfo_form m"
				+ " where m.opr_state = '0' and m.bsflag = '0' and m.state != '8'"
				+ " and m.state != '0' and (m.mix_type_id = 'S0000' or m.mix_type_id = 'S14050208')"
				+ " and m.project_info_no = '"+projectInfoNo+"'"
				+ " union all"
				+ " select outform.project_info_no from gms_device_equ_outform outform"
				+ " where outform.bsflag = '0' and outform.state = '9' and outform.opr_state = '0'"
				+ " and exists (select 1"
				+ " from gms_device_equ_outdetail amd "
				+ " left join gms_device_equ_outsub amm on amd.device_oif_subid = amm.device_oif_subid"
				+ " where outform.device_outinfo_id = amm.device_outinfo_id)"
				+ " and outform.project_info_no = '"+projectInfoNo+"'"
				+ " union all"
				+ " select devapp.project_info_no from gms_device_hireapp devapp"
				+ " left join common_busi_wf_middle wf on wf.business_id = devapp.device_hireapp_id and wf.bsflag = '0'"
				+ " where devapp.bsflag = '0' and devapp.opr_state = '0'"
				+ " and (wf.proc_status = '3' or devapp.state = '1')"
				+ " and devapp.project_info_no = '"+projectInfoNo+"'"
				+ " union all"
				+ " select cof.project_info_no from gms_device_coll_outform cof"
				+ " where cof.bsflag = '0' and cof.devouttype != '2' and cof.opr_state = '0'"
				+ " and exists (select 1 from gms_device_coll_outsub sub"
				+ " where sub.device_outinfo_id = cof.device_outinfo_id)"
				+ " and cof.project_info_no = '"+projectInfoNo+"'"
				+ " union all"
				+ " select cof.project_info_no from gms_device_mixinfo_form cof"
				+ " where cof.state = '1' and cof.opr_state = '0' and cof.bsflag = '0'"
				+ " and cof.mix_type_id = 'S1405' and cof.mixform_type = '7'"
				+ " and cof.project_info_no = '"+projectInfoNo+"'"
				+ " union all"
				+ " select cof.project_info_no from gms_device_coll_outform cof"
				+ " where cof.bsflag = '0' and cof.devouttype = '2' and cof.opr_state = '0'"
				+ " and cof.project_info_no = '"+projectInfoNo+"' ) ";

		Map map = jdbcDao.queryRecordBySQL(str);
		if (MapUtils.isNotEmpty(map)) {
			duiProCount = map.get("duiprocount").toString();
		}

		responseMsg.setValue("duiprocount", duiProCount);
		return responseMsg;
	}
	/**
	 * NEWMETHOD ����Ŀ��˾���Ǳ�����ʾ��Ŀ�ѽ���δ�����豸����Ŀ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryNotReturnProInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select pro_sub_name || '-' || org_abbreviation as sub_org_name,project_name,"
				+ " decode(org_abbreviation,'',pro_sub_name,org_abbreviation) as dui_org_name from (select"
				+ " case"
				+ " when sub.org_subjection_id like 'C105001005%' then '����ľ��̽��'"
				+ " when sub.org_subjection_id like 'C105001002%' then '�½���̽��'"
				+ " when sub.org_subjection_id like 'C105001003%' then '�¹���̽��'"
				+ " when sub.org_subjection_id like 'C105001004%' then '�ຣ��̽��'"
				+ " when sub.org_subjection_id like 'C105005004%' then '������̽��'"
				+ " when sub.org_subjection_id like 'C105005000%' then '������̽��'"
				+ " when sub.org_subjection_id like 'C105005001%' then '������̽������'"
				+ " when sub.org_subjection_id like 'C105007%' then '�����̽��'"
				+ " when sub.org_subjection_id like 'C105063%' then '�ɺ���̽��'"
				+ " when sub.org_subjection_id like 'C105086%' then '���̽��'"
				+ " when sub.org_subjection_id like 'C105008%' then '�ۺ��ﻯ̽��'"
				+ " when sub.org_subjection_id like 'C105002%' then '���ʿ�̽��ҵ��'"
				+ " else org_abbreviation end as pro_sub_name,"
				+ " project_name,org_abbreviation,project_year from ("
				+ " select t.project_year,t.project_name,oi.org_abbreviation,pd.org_subjection_id"
				+ " from gms_device_account_dui dui"
				+ " left join gp_task_project t on t.project_info_no = dui.project_info_id"
				+ " left join gp_task_project_dynamic pd on t.project_info_no = pd.project_info_no"
				+ " left join comm_org_information oi on pd.org_id = oi.org_id "
				+ " where dui.bsflag = '0' and dui.actual_out_time is null and t.project_status in "
				+ " ('5000100001000000005', '5000100001000000003') " 
				+ " and pd.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
				+ " union"
				+ " select t.project_year,t.project_name,org_abbreviation,pd.org_subjection_id "
				+ " from gms_device_coll_account_dui coldui"
				+ " left join gp_task_project t on t.project_info_no = coldui.project_info_id"
				+ " left join gp_task_project_dynamic pd on t.project_info_no = pd.project_info_no"
				+ " left join comm_org_information oi on pd.org_id = oi.org_id "
				+ " where coldui.unuse_num > 0 and t.project_status in "
				+ " ('5000100001000000005', '5000100001000000003') " 
				+ " and pd.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%' )sub)");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by project_year ");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ�ճ���鳬3��δ����鵥������
	 * 
	 * @param reqDTO
	 * @return �ճ���鳬������ Ŀǰ3��Ϊ����
	 * @throws Exception
	 * @author dz 2017-7-6
	 */
	public ISrvMsg getRcjcOutTimeCount(ISrvMsg msg) throws Exception {
		log.info("getRcjcOutTimeCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		//gms_device_inspectioin
		String orgSubId = msg.getValue("orgSubId");
		int orgLength = orgSubId.length();
		String outtimecount = "";// ����δ�������
		// ��ѯ�����豸
		String str = "select count(*) as outtimecount from (select owning_org_name_desc,project_name_desc,ins.create_time,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign from ("
				+ "select c.* from ("
				+ "select t.*,row_number() over(partition by t.dev_acc_id order by t.create_time desc) rn "
				+ "from gms_device_inspectioin t) c where rn=1 and "
				+ "to_char(c.create_time,'yyyy-MM-dd')<to_char(sysdate-3,'yyyy-MM-dd')) ins "
				+ "left join p_auth_user u on ins.inspectioin_people=u.user_id and u.bsflag='0'  "
				+ "inner join (select "
				+ "pro.project_name as project_name_desc,"
				+ "case when t.owning_sub_id like 'C105001005%' then '����ľ��̽��' when t.owning_sub_id like 'C105001002%' then '�½���̽��' "
				+ "when t.owning_sub_id like 'C105001003%' then '�¹���̽��' when t.owning_sub_id like 'C105001004%' then '�ຣ��̽��' "
				+ "when t.owning_sub_id like 'C105005004%' then '������̽��' when t.owning_sub_id like 'C105005000%' then '������̽��' "
				+ "when t.owning_sub_id like 'C105005001%' then '������̽������' when t.owning_sub_id like 'C105007%' then '�����̽��' "
				+ "when t.owning_sub_id like 'C105063%' then '�ɺ���̽��' when t.owning_sub_id like 'C105086%' then '���̽��' "
				+ "when t.owning_sub_id like 'C105008%' then '�ۺ��ﻯ��' when t.owning_sub_id like 'C105002%' then '���ʿ�̽��ҵ��' "
				+ "when t.owning_sub_id like 'C105006%' then 'װ������' when t.owning_sub_id like 'C105003%' then '�о�Ժ' "
				+ "when t.owning_sub_id like 'C105017%' then '����������ҵ��' else info.org_abbreviation end as owning_org_name_desc, "
				+ "t.* from (select owning_org_id,project_info_no,dev_name,dev_model,self_num,license_num,dev_sign,dev_acc_id,bsflag,owning_sub_id,dev_type from gms_device_account "
				+ "union all select owning_org_id,project_info_id as project_info_no,dev_name,dev_model,self_num,license_num,dev_sign,dev_acc_id,bsflag,owning_sub_id,dev_type from gms_device_account_dui dui where dui.is_leaving='0')t left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0' left join gp_task_project pro on t.project_info_no = pro.project_info_no)acc on ins.dev_acc_id=acc.dev_acc_id and acc.bsflag='0' "
				+ "where acc.project_info_no is not null and acc.owning_sub_id like '"+orgSubId+"%' and ins.bsflag='0' order by owning_org_name_desc desc,project_name_desc desc,ins.create_time desc)";
		Map map = jdbcDao.queryRecordBySQL(str);
		if (MapUtils.isNotEmpty(map)) {
			outtimecount = map.get("outtimecount") == null ? "0" : map.get("outtimecount")
					.toString();
		}
		responseMsg.setValue("outtimecount", outtimecount);
		return responseMsg;
	}
	/**
	 * ��ѯ�ճ���鳬3��δ����鵥������
	 * 
	 * @param reqDTO
	 * @return ��ת��¼�������� Ŀǰ3��Ϊ����
	 * @throws Exception
	 * @author dz 2017-7-6
	 */
	public ISrvMsg getYzjlOutTimeCount(ISrvMsg msg) throws Exception {
		log.info("getYzjlOutTimeCount");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		//gms_device_inspectioin
		String orgSubId = msg.getValue("orgSubId");
		int orgLength = orgSubId.length();
		String outtimecount = "";// ����δ�������
		// ��ѯ�����豸
		String str = "select count(*) as outtimecount from (select * from ("
				+ " select otmp.*,row_number() over(partition by otmp.dev_acc_id order by otmp.modify_time desc) as row_flg"
				+ " from (select dui.self_num,oi.modify_time,dui.fk_dev_acc_id as dev_acc_id,dui.dev_name,dui.asset_coding,oi.project_info_no"
				+ " from gms_device_work_information oi inner join gms_device_account_dui dui on oi.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1' and dui.is_leaving='0' and dui.dev_type like 'S062301%') otmp"
				+ ") where row_flg=1 and to_date(to_char(sysdate - interval '3' day,'YYYY/MM/DD'),'YYYY/MM/DD')>= modify_time)";
		Map map = jdbcDao.queryRecordBySQL(str);
		if (MapUtils.isNotEmpty(map)) {
			outtimecount = map.get("outtimecount") == null ? "0" : map.get("outtimecount")
					.toString();
		}
		responseMsg.setValue("outtimecount", outtimecount);
		return responseMsg;
	}
	/**
	 * ��ѯ�ճ���鳬3��δ����鵥��
	 * 
	 * @param reqDTO
	 * @return �ճ���鳬������ Ŀǰ3��Ϊ����
	 * @throws Exception
	 * @author dz 2017-7-6
	 */
	public ISrvMsg queryRcjcOutTimeInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String orgSubId = msg.getValue("orgSubId");
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String str = "select owning_org_name_desc,project_name_desc,ins.create_time,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign from ("
				+ "select c.* from ("
				+ "select t.*,row_number() over(partition by t.dev_acc_id order by t.create_time desc) rn "
				+ "from gms_device_inspectioin t) c where rn=1 and "
				+ "to_char(c.create_time,'yyyy-MM-dd')<to_char(sysdate-3,'yyyy-MM-dd')) ins "
				+ "left join p_auth_user u on ins.inspectioin_people=u.user_id and u.bsflag='0'  "
				+ "inner join (select "
				+ "pro.project_name as project_name_desc,"
				+ "case when t.owning_sub_id like 'C105001005%' then '����ľ��̽��' when t.owning_sub_id like 'C105001002%' then '�½���̽��' "
				+ "when t.owning_sub_id like 'C105001003%' then '�¹���̽��' when t.owning_sub_id like 'C105001004%' then '�ຣ��̽��' "
				+ "when t.owning_sub_id like 'C105005004%' then '������̽��' when t.owning_sub_id like 'C105005000%' then '������̽��' "
				+ "when t.owning_sub_id like 'C105005001%' then '������̽������' when t.owning_sub_id like 'C105007%' then '�����̽��' "
				+ "when t.owning_sub_id like 'C105063%' then '�ɺ���̽��' when t.owning_sub_id like 'C105086%' then '���̽��' "
				+ "when t.owning_sub_id like 'C105008%' then '�ۺ��ﻯ��' when t.owning_sub_id like 'C105002%' then '���ʿ�̽��ҵ��' "
				+ "when t.owning_sub_id like 'C105006%' then 'װ������' when t.owning_sub_id like 'C105003%' then '�о�Ժ' "
				+ "when t.owning_sub_id like 'C105017%' then '����������ҵ��' else info.org_abbreviation end as owning_org_name_desc, "
				+ "t.* from (select owning_org_id,project_info_no,dev_name,dev_model,self_num,license_num,dev_sign,dev_acc_id,bsflag,owning_sub_id,dev_type from gms_device_account "
				+ "union all select owning_org_id,project_info_id as project_info_no,dev_name,dev_model,self_num,license_num,dev_sign,dev_acc_id,bsflag,owning_sub_id,dev_type from gms_device_account_dui dui where dui.is_leaving='0')t left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0' left join gp_task_project pro on t.project_info_no = pro.project_info_no)acc on ins.dev_acc_id=acc.dev_acc_id and acc.bsflag='0' "
				+ "where acc.project_info_no is not null and acc.owning_sub_id like '"+orgSubId+"%' and ins.bsflag='0' order by owning_org_name_desc desc,project_name_desc desc,ins.create_time desc";
		page = pureDao.queryRecordsBySQL(str.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ��ת��¼��3��δ����鵥��
	 * 
	 * @param reqDTO
	 * @return ��ת��¼�������� Ŀǰ3��Ϊ����
	 * @throws Exception
	 * @author zjb 2017-7-27
	 */
	public ISrvMsg queryYzjlOutTimeInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String orgSubId = msg.getValue("orgSubId");
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String str = "select * from ("
				+ " select otmp.*,row_number() over(partition by otmp.dev_acc_id order by otmp.modify_time desc) as row_flg"
				+ " from ( select p.project_name as project_name_desc,i.org_abbreviation usage_org_name_desc,dui.self_num,oi.modify_time,dui.fk_dev_acc_id as dev_acc_id,dui.dev_name,dui.asset_coding,dui.dev_model,oi.project_info_no"
				+ " from gms_device_work_information oi inner join gms_device_account_dui dui on oi.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1' and dui.is_leaving='0' and dui.dev_type like 'S062301%' "
				+ " left join comm_org_information i on dui.usage_org_id = i.org_id and i.bsflag = '0' left join gp_task_project p on dui.project_info_id = p.project_info_no) otmp"
				+ " ) where row_flg=1 and to_date(to_char(sysdate - interval '3' day,'YYYY/MM/DD'),'YYYY/MM/DD')>= modify_time order by self_num desc";
		page = pureDao.queryRecordsBySQL(str.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����Ŀ��˾���Ǳ�����ʾװ����̨δ������
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryEqOutInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select pro.project_name,devapp.device_app_name,inorg.org_abbreviation as in_org_name,"
					  + " OrgSubIdToName(orgsub.org_subjection_id)|| '-' || inorg.org_abbreviation as sub_org_name,"
					  + " mix.device_mixinfo_id,outorg.org_abbreviation as out_org_name"
					  + " from gms_device_mixinfo_form mix"
					  + " left join gms_device_app devapp on mix.device_app_id = devapp.device_app_id"
					  + " left join gp_task_project pro on mix.project_info_no = pro.project_info_no"
					  + " left join comm_org_information inorg on mix.in_org_id = inorg.org_id and inorg.bsflag = '0'"
					  + " left join comm_org_information outorg on mix.out_org_id = outorg.org_id and outorg.bsflag = '0'"
					  + " left join comm_org_subjection orgsub on mix.in_org_id = orgsub.org_id and orgsub.bsflag = '0'"
					  + " left join comm_org_subjection outsub on mix.out_org_id = outsub.org_id and outsub.bsflag = '0'"
					  + " where mix.state = '9' and mix.bsflag = '0' and mix.mix_type_id != 'S0000'"
					  + " and mix.mix_type_id != 'S14059999' and outsub.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
					  + " and orgsub.org_subjection_id not like 'C105007%' and mix.opr_state = '0'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by mix.modifi_date desc,mix.project_info_no ");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����Ŀ��˾���Ǳ�����ʾװ������δ������
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCollOutInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select pro.project_name,collapp.device_app_name,inorg.org_abbreviation as in_org_name,"
					  + " OrgSubIdToName(orgsub.org_subjection_id)|| '-' || inorg.org_abbreviation as sub_org_name,"
					  + " cmf.device_mixinfo_id,outorg.org_abbreviation as out_org_name"
					  + " from gms_device_collmix_form cmf"
					  + " left join gms_device_collapp collapp on cmf.device_app_id = collapp.device_app_id"
					  + " left join gp_task_project pro on cmf.project_info_no = pro.project_info_no"
					  + " left join comm_org_information inorg on cmf.in_org_id = inorg.org_id and inorg.bsflag = '0'"
					  + " left join comm_org_information outorg on cmf.out_org_id = outorg.org_id and outorg.bsflag = '0'"
					  + " left join comm_org_subjection orgsub on cmf.in_org_id = orgsub.org_id and orgsub.bsflag = '0'"
					  + " left join comm_org_subjection outsub on cmf.out_org_id = outsub.org_id and outsub.bsflag = '0'"
					  + " where cmf.state = '9' and cmf.bsflag = '0' and cmf.opr_state = '0'"
					  + " and outsub.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by cmf.modifi_date desc,cmf.project_info_no ");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
}
