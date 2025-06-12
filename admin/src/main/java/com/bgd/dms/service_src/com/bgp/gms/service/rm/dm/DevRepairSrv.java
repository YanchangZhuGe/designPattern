package com.bgp.gms.service.rm.dm;

import java.io.Serializable;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.soap.SOAPException;

import net.sf.json.JSONArray;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.bgp.gms.service.rm.dm.util.StringUtil;
import com.bgp.mcs.service.util.mail.SimpleMailSender;
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
 * creator time:2017-11-15
 * 
 * description:�豸ά����ط���
 * 
 */
@Service("DevRepairSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class DevRepairSrv extends BaseService{
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private IWtcDevSrv wtcDevSrv = new WtcPubDevSrv();
	
	/**
	 * �豸ά����Ϣ�鿴
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevRepairList(ISrvMsg msg) throws Exception {
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
		String devName = msg.getValue("devname");//�豸����
		String devModel = msg.getValue("devmodel");//����ͺ�
		String licenseNum = msg.getValue("licensenum");//���պ�
		String selfNum = msg.getValue("selfnum");//�Ա��
		String devSign = msg.getValue("devsign");//ʵ���ʶ��
		String devCoding = msg.getValue("devcoding");//ERP���
		String owningSubId = msg.getValue("owningsubid");//������λ
		String repairPostion = msg.getValue("repairpostion");//ά�޵�λ
		String repairEr = msg.getValue("repairer");//������
		String acceptEr = msg.getValue("accepter");//������
		String aufNr = msg.getValue("aufnr");//������
		String repairDetail = msg.getValue("accepter");//ά������
		String creatOr = msg.getValue("creator");//������
		String projectName = msg.getValue("projectname");//��Ŀ����
		String humanCostStart = msg.getValue("humancoststart");//��ʱ�ѿ�ʼ���
		String humanCostEnd = msg.getValue("humancostend");//��ʱ�ѽ������
		String materialCostStart = msg.getValue("materialcoststart");//���Ϸѿ�ʼ���
		String materialCostEnd = msg.getValue("materialcosttend");//���Ϸѽ������
		String repairStartDateStart = msg.getValue("repairstartdatestart");//������ʼʱ��
		String repairStartDateEnd = msg.getValue("repairstartdateend");//���޽���ʱ��
		String repairEndDateStart = msg.getValue("repairenddatestart");//������ʼʱ��
		String repairEndDateEnd = msg.getValue("repairenddateend");//���ս���ʱ��
		String dataFrom = msg.getValue("datafrom");// ������Դ
		String repairType = msg.getValue("repairtype");// ά������
		String repairLevel = msg.getValue("repairlevel");// ά�޼���
		String recordStatus = msg.getValue("recordstatus");// ����״̬
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer conditionSql = new StringBuffer();//����SQL
		
		StringBuffer sumAvgStartSql = new StringBuffer();		
		sumAvgStartSql.append("select nvl(round(sum(human_cost),3),0) as sumhumancost,nvl(round(sum(material_cost),3),0) as summaterialcost,"
							+ " nvl(round(avg(human_cost),3),0) as avghumancost,nvl(round(avg(material_cost),3),0) as avgmaterialcost from (");
		StringBuffer sumAvgEndSql = new StringBuffer();
		sumAvgEndSql.append(" )");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select * from (select 'M' as msflag,info.repair_detail,acc.dev_name,org.org_name,info.accepter,"
				+ " case"
                + " when acc.owning_sub_id like 'C105001005%' then '����ľ��̽��'"
                + " when acc.owning_sub_id like 'C105001002%' then '�½���̽��'"
                + " when acc.owning_sub_id like 'C105001003%' then '�¹���̽��'"
                + " when acc.owning_sub_id like 'C105001004%' then '�ຣ��̽��'"
                + " when acc.owning_sub_id like 'C105005004%' then '������̽��'"
                + " when acc.owning_sub_id like 'C105005000%' then '������̽��'"
                + " when acc.owning_sub_id like 'C105005001%' then '������̽������'"
                + " when acc.owning_sub_id like 'C105007%' then '�����̽��'"
                + " when acc.owning_sub_id like 'C105063%' then '�ɺ���̽��'"
                + " when acc.owning_sub_id like 'C105008%' then '�ۺ��ﻯ��'"
                + " when acc.owning_sub_id like 'C105006%' then 'װ������'"
                + " when acc.owning_sub_id like 'C105002%' then '���ʿ�̽��ҵ��'"
                + " when acc.owning_sub_id like 'C105003%' then '�о�Ժ'"
                + " when acc.owning_sub_id like 'C105015%' then '���е�������'"
                + " when acc.owning_sub_id like 'C105086%' then '���̽��'"
                + " when acc.owning_sub_id like 'C105017%' then '����������ҵ��'"
                + " when acc.owning_sub_id like 'C105014%' then '��Ϣ��������(�������)'"
                + " when acc.owning_sub_id like 'C105016%' then '������̽װ���ֹ�˾'"
                + " when acc.owning_sub_id like 'C105005%' then '������������˾������̽'"
                + " when acc.owning_sub_id like 'C105075%' then '��̽��ѵ����'"
                + " when acc.owning_sub_id like 'C105004%' then '��̽�����о�����'"
                + " when acc.owning_sub_id like 'C105078%' then '���ʹ�Ӧ����'"
                + " when acc.owning_sub_id like 'C105013%' then '�ɼ�����֧�ֲ�'"
                + " when acc.owning_sub_id like 'C105082%' then '�Ͳص��������о�����'"
                + " else org.org_abbreviation end as org_abbreviation,org.org_abbreviation as abbrevname,"
				+ " case when datafrom = 'YD' then '�ֳֻ�' when datafrom = 'SAP' then 'SAP' else 'ƽ̨¼��' end as data_from_name,"		
				+ " acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,dtype.coding_name as repairtype,info.repair_info,"
				+ " ditem.coding_name as repairitem,dlevel.coding_name as repairlevel,info.repair_start_date,info.repair_postion,"
				+ " info.repair_end_date,info.repairer,info.human_cost,info.material_cost,info.project_name,"
				+ " info.bsflag,acc.owning_sub_id,acc.dev_type,acc.dev_coding,info.repair_type,info.record_status,info.datafrom,"
				+ " emp.employee_name,info.aufnr,info.repair_level"
				+ " from bgp_comm_device_repair_info info"
				+ " left join gms_device_account acc on acc.dev_acc_id = info.device_account_id"
				+ " left join comm_org_information org on org.org_id = acc.owning_org_id and org.bsflag = '0'"
				+ " left join comm_coding_sort_detail dtype on dtype.coding_code_id = info.repair_type"
				+ " left join comm_coding_sort_detail ditem on ditem.coding_code_id = info.repair_item"
				+ " left join comm_coding_sort_detail dlevel on dlevel.coding_code_id = info.repair_level"
				+ " left join comm_human_employee emp on emp.employee_id = info.creator"
				+ " union all"
				+ " select 'S' as msflag,info.repair_detail,acc.dev_name,org.org_name,info.accepter,"
				+ " case"
                + " when acc.owning_sub_id like 'C105001005%' then '����ľ��̽��'"
                + " when acc.owning_sub_id like 'C105001002%' then '�½���̽��'"
                + " when acc.owning_sub_id like 'C105001003%' then '�¹���̽��'"
                + " when acc.owning_sub_id like 'C105001004%' then '�ຣ��̽��'"
                + " when acc.owning_sub_id like 'C105005004%' then '������̽��'"
                + " when acc.owning_sub_id like 'C105005000%' then '������̽��'"
                + " when acc.owning_sub_id like 'C105005001%' then '������̽������'"
                + " when acc.owning_sub_id like 'C105007%' then '�����̽��'"
                + " when acc.owning_sub_id like 'C105063%' then '�ɺ���̽��'"
                + " when acc.owning_sub_id like 'C105008%' then '�ۺ��ﻯ��'"
                + " when acc.owning_sub_id like 'C105006%' then 'װ������'"
                + " when acc.owning_sub_id like 'C105002%' then '���ʿ�̽��ҵ��'"
                + " when acc.owning_sub_id like 'C105003%' then '�о�Ժ'"
                + " when acc.owning_sub_id like 'C105015%' then '���е�������'"
                + " when acc.owning_sub_id like 'C105086%' then '���̽��'"
                + " when acc.owning_sub_id like 'C105017%' then '����������ҵ��'"
                + " when acc.owning_sub_id like 'C105014%' then '��Ϣ��������(�������)'"
                + " when acc.owning_sub_id like 'C105016%' then '������̽װ���ֹ�˾'"
                + " when acc.owning_sub_id like 'C105005%' then '������������˾������̽'"
                + " when acc.owning_sub_id like 'C105075%' then '��̽��ѵ����'"
                + " when acc.owning_sub_id like 'C105004%' then '��̽�����о�����'"
                + " when acc.owning_sub_id like 'C105078%' then '���ʹ�Ӧ����'"
                + " when acc.owning_sub_id like 'C105013%' then '�ɼ�����֧�ֲ�'"
                + " when acc.owning_sub_id like 'C105082%' then '�Ͳص��������о�����'"
                + " else org.org_abbreviation end as org_abbreviation,org.org_abbreviation as abbrevname,"
				+ " case when datafrom = 'YD' then '�ֳֻ�' when datafrom = 'SAP' then 'SAP' else 'ƽ̨¼��' end as data_from_name,"		
				+ " acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,dtype.coding_name as repairtype,info.repair_info,"
				+ " ditem.coding_name as repairitem,dlevel.coding_name as repairlevel,info.repair_start_date,info.repair_postion,"
				+ " info.repair_end_date,info.repairer,info.human_cost,info.material_cost,info.project_name,"
				+ " info.bsflag,acc.owning_sub_id,acc.dev_type,acc.dev_coding,info.repair_type,info.record_status,info.datafrom,"
				+ " emp.employee_name,info.aufnr,info.repair_level"
				+ " from bgp_comm_device_repair_info info"
				+ " left join gms_device_account_dui dui on dui.dev_acc_id = info.device_account_id"
				+ " left join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id"
				+ " left join comm_org_information org on org.org_id = acc.owning_org_id and org.bsflag = '0'"
				+ " left join comm_coding_sort_detail dtype on dtype.coding_code_id = info.repair_type"
				+ " left join comm_coding_sort_detail ditem on ditem.coding_code_id = info.repair_item"
				+ " left join comm_coding_sort_detail dlevel on dlevel.coding_code_id = info.repair_level"
				+ " left join comm_human_employee emp on emp.employee_id = info.creator)"
				+ " where bsflag = '"+DevConstants.BSFLAG_NORMAL+"'"
				+ " and owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'");
		// �豸����
		if (StringUtils.isNotBlank(devName)) {
			conditionSql.append(" and dev_name like '%"+devName+"%'");
		}
		// ����ͺ�
		if (StringUtils.isNotBlank(devModel)) {
			conditionSql.append(" and dev_model like '%"+devModel+"%'");
		}
		// ���պ�
		if (StringUtils.isNotBlank(licenseNum)) {
			conditionSql.append(" and license_num like '%"+licenseNum+"%'");
		}
		// �Ա��
		if (StringUtils.isNotBlank(selfNum)) {
			conditionSql.append(" and self_num like '%"+selfNum+"%'");
		}
		// ʵ���ʶ��
		if (StringUtils.isNotBlank(devSign)) {
			conditionSql.append(" and dev_sign like '%"+devSign+"%'");
		}
		// ERP���
		if (StringUtils.isNotBlank(devCoding)) {
			conditionSql.append(" and dev_coding like '%"+devCoding+"%'");
		}
		// ������λ����
		if (StringUtils.isNotBlank(owningSubId)) {
			conditionSql.append(" and owning_sub_id like '%"+owningSubId+"%'");
		}
		// ά�޵�λ
		if (StringUtils.isNotBlank(repairPostion)) {
			conditionSql.append(" and repair_postion like '%"+repairPostion+"%'");
		}
		// ������
		if (StringUtils.isNotBlank(repairEr)) {
			conditionSql.append(" and repairer like '%"+repairEr+"%'");
		}
		// ������
		if (StringUtils.isNotBlank(acceptEr)) {
			conditionSql.append(" and accepter like '%"+acceptEr+"%'");
		}
		// ������
		if (StringUtils.isNotBlank(creatOr)) {
			conditionSql.append(" and employee_name like '%"+creatOr+"%'");
		}
		// ��Ŀ����
		if (StringUtils.isNotBlank(projectName)) {
			conditionSql.append(" and project_name like '%"+projectName+"%'");
		}
		// ������
		if (StringUtils.isNotBlank(aufNr)) {
			conditionSql.append(" and aufnr like '%"+aufNr+"%'");
		}
		// ά������
		if (StringUtils.isNotBlank(repairDetail)) {
			conditionSql.append(" and repair_detail like '%"+repairDetail+"%'");
		}
		//��ʱ��
		if(StringUtils.isNotBlank(humanCostStart) && StringUtils.isNotBlank(humanCostEnd)){
			conditionSql.append(" and human_cost >= '"+humanCostStart+"' and human_cost <= '"+humanCostEnd+"'");
		}
		if(StringUtils.isNotBlank(humanCostStart) && StringUtils.isBlank(humanCostEnd)){
			conditionSql.append(" and human_cost >= '"+humanCostStart+"'");
		}
		if(StringUtils.isBlank(humanCostStart) && StringUtils.isNotBlank(humanCostEnd)){
			conditionSql.append(" and human_cost <= '"+humanCostEnd+"'");
		}
		//���Ϸ�
		if(StringUtils.isNotBlank(materialCostStart) && StringUtils.isNotBlank(materialCostEnd)){
			conditionSql.append(" and material_cost >= '"+materialCostStart+"' and material_cost <= '"+materialCostEnd+"'");
		}
		if(StringUtils.isNotBlank(materialCostStart) && StringUtils.isBlank(materialCostEnd)){
			conditionSql.append(" and material_cost >= '"+materialCostStart+"'");
		}
		if(StringUtils.isBlank(materialCostStart) && StringUtils.isNotBlank(materialCostEnd)){
			conditionSql.append(" and material_cost <= '"+materialCostEnd+"'");
		}
		//��������
		if(StringUtils.isNotBlank(repairStartDateStart) && StringUtils.isNotBlank(repairStartDateEnd)){
			conditionSql.append(" and repair_start_date >= to_date('"+repairStartDateStart+"','yyyy-mm-dd')"
								+ " and repair_start_date <= to_date('"+repairStartDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(repairStartDateStart) && StringUtils.isBlank(repairStartDateEnd)){
			conditionSql.append(" and repair_start_date >= to_date('"+repairStartDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(repairStartDateStart) && StringUtils.isNotBlank(repairStartDateEnd)){
			conditionSql.append(" and repair_start_date <= to_date('"+repairStartDateEnd+"','yyyy-mm-dd')");
		}
		//��������
		if(StringUtils.isNotBlank(repairEndDateStart) && StringUtils.isNotBlank(repairEndDateEnd)){
			conditionSql.append(" and repair_end_date >= to_date('"+repairEndDateStart+"','yyyy-mm-dd')"
								+ " and repair_end_date <= to_date('"+repairEndDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(repairEndDateStart) && StringUtils.isBlank(repairEndDateEnd)){
			conditionSql.append(" and repair_end_date >= to_date('"+repairEndDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(repairEndDateStart) && StringUtils.isNotBlank(repairEndDateEnd)){
			conditionSql.append(" and repair_end_date <= to_date('"+repairEndDateEnd+"','yyyy-mm-dd')");
		}
		// ������Դ
		if (StringUtils.isNotBlank(dataFrom)&&!"��ѡ��...".equals(dataFrom)) {
			conditionSql.append(" and datafrom = '"+dataFrom+"'");	
		}
		// ά������
		if (StringUtils.isNotBlank(repairType)&&!"��ѡ��...".equals(repairType)) {
			conditionSql.append(" and repair_type = '"+repairType+"'");	
		}
		// ά�޼���
		if (StringUtils.isNotBlank(repairLevel)&&!"��ѡ��...".equals(repairLevel)) {
			conditionSql.append(" and repair_level = '"+repairLevel+"'");	
		}
		// ����״̬
		if (StringUtils.isNotBlank(recordStatus)&&!"��ѡ��...".equals(recordStatus)) {
			conditionSql.append(" and record_status = '"+recordStatus+"'");	
		}
		if(StringUtils.isNotBlank(sortField)){
			conditionSql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			conditionSql.append(" order by repair_start_date desc,dev_type,owning_sub_id,repair_info");
		}
		querySql.append(conditionSql);
		sumAvgStartSql.append(querySql).append(sumAvgEndSql);
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		List pageFooter = new ArrayList();
		Map sumFooter = new HashMap();
		Map avgFooter = new HashMap();
		Map sumAvgMap = jdbcDao.queryRecordBySQL(sumAvgStartSql.toString());
		if(MapUtils.isNotEmpty(sumAvgMap)){
			sumFooter.put("human_cost", sumAvgMap.get("sumhumancost"));
			sumFooter.put("material_cost", sumAvgMap.get("summaterialcost"));
			if(user.getSubOrgIDofAffordOrg().equals(DevConstants.COMM_COM_ORGSUBID)){
				sumFooter.put("org_abbreviation", "�ϼ�(Ԫ)");
				avgFooter.put("org_abbreviation", "ƽ��(Ԫ)");
			}else{
				sumFooter.put("abbrevname", "�ϼ�(Ԫ)");
				avgFooter.put("abbrevname", "ƽ��(Ԫ)");
			}
			avgFooter.put("human_cost", sumAvgMap.get("avghumancost"));
			avgFooter.put("material_cost", sumAvgMap.get("avgmaterialcost"));			
			pageFooter.add(avgFooter);
			pageFooter.add(sumFooter);
		}
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		responseDTO.setValue("footer", pageFooter);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �豸ά����Ϣ��ҳ����Ϣ��ʾ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevRepairMainInfo(ISrvMsg reqDTO) throws Exception {		
		String repairInfo = reqDTO.getValue("repairinfo");
		String msFlag = reqDTO.getValue("msflag");//������Ŀ¼�뻹�Ƕ���Ŀ¼���ά�ޱ�����¼
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer startSql = new StringBuffer()
				.append("select acc.dev_name,acc.dev_model,acc.self_num,org.org_name,info.accepter,emp.employee_name,"
						+ "	dstatus.coding_name as record_status_desc,acc.dev_coding,info.project_name,"
						+ " case when datafrom = 'YD' then '�ֳֻ�' when datafrom = 'SAP' then 'SAP' else 'ƽ̨¼��' end as data_from_name,"		
						+ " acc.license_num,acc.dev_sign,dtype.coding_name as repairtype,info.repair_detail,info.repair_postion,"
						+ " ditem.coding_name as repairitem,dlevel.coding_name as repairlevel,info.repair_start_date,"
						+ " info.repair_end_date,info.repairer,info.human_cost,info.material_cost,info.aufnr"
						+ " from bgp_comm_device_repair_info info");
		StringBuffer middleSql = new StringBuffer();
		if(DevUtil.isValueNotNull(msFlag,"M")){//����Ŀ¼��
			middleSql.append(" left join gms_device_account acc on acc.dev_acc_id = info.device_account_id");
		}else{//����Ŀ¼��
			middleSql.append(" left join gms_device_account_dui dui on dui.dev_acc_id = info.device_account_id"
						   + " left join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id");
		}
		StringBuffer endSql = new StringBuffer()
				.append(" left join comm_org_information org on org.org_id = acc.owning_org_id and org.bsflag = '0'"
					  + " left join comm_coding_sort_detail dtype on dtype.coding_code_id = info.repair_type"
					  + " left join comm_coding_sort_detail ditem on ditem.coding_code_id = info.repair_item"
					  + " left join comm_coding_sort_detail dlevel on dlevel.coding_code_id = info.repair_level"
					  + " left join comm_coding_sort_detail dstatus on dstatus.coding_code_id = info.record_status"
					  + " left join comm_human_employee emp on emp.employee_id = info.creator"
					  + " where info.repair_info = '"+repairInfo+"'");
		Map repairMap = jdbcDao.queryRecordBySQL(startSql.append(middleSql).append(endSql).toString());
		if (MapUtils.isNotEmpty(repairMap)) {
			responseMsg.setValue("data", repairMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD �豸ά�����ı�����ϸ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevRepairDet(ISrvMsg msg) throws Exception {	
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
		String repairInfo = msg.getValue("repairinfo");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.repair_detail_id,d.material_name,d.material_coding,"
					  + " d.unit_price,d.material_amout,d.total_charge,d.name_text,"
					  + " d.material_unit,det.coding_name as repairitemname"
					  + " from bgp_comm_device_repair_detail d"
					  + " left join comm_coding_sort_detail det on d.repair_item = det.coding_code_id"
					  + " where d.repair_info = '"+repairInfo+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.create_date desc,d.repair_detail_id");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
}
