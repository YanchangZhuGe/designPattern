package com.bgp.dms.zz;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WFCommonBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * project: ������̽�豸��ϵ��Ϣ��ϵͳ
 * 
 * creator: �³�
 * 
 * creator time:2015-9-7
 * 
 * description:�豸ת����ֵҵ����
 * 
 */
public class ZzSrv  extends BaseService{
	IBaseDao baseDao = BeanFactory.getBaseDao();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	private WFCommonBean wfBean;
	
	public ZzSrv() {
		wfBean = (WFCommonBean) BeanFactory.getBean("WFCommonBean");
	}
	/**
	 * ��ѯת���б���Ϣ
	 * 1������
		2��������
		3��δת��
		4����ת��
		5��ɾ��
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryZzList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//��ȡ��ǰҳ
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
		String zz_no = isrvmsg.getValue("zz_no");// ת�ʵ���
		String cg_order_num = isrvmsg.getValue("cg_order_num");// �ɹ�����
		String zz_state = isrvmsg.getValue("zz_state");// ת��״̬
		String flag = isrvmsg.getValue("flag");// δת�ʱ�ʶ 1 Ϊδת�� nullΪ��ת��
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_id,f.zz_no,f.cg_order_num," +
				"f.zz_date,f.zz_money,f.lifnr_name," +
				"f.zz_num,f.batch_plan,f.creator," +
				"z.org_abbreviation as org_name," +
				"case when f.zz_state='1' then '����' " +
				"when f.zz_state='2' then '������' " +
				"when f.zz_state='3' then 'δת��' " +
				"when f.zz_state='4' then '��ת��' end as zz_state_desc " +
				"from dms_zz_info f ");
		querySql.append("left join comm_org_information z on f.org_id=z.org_id  where f.bsflag='0' ");
		log.info("flag=" + flag);
		if("1".equals(flag)){
			querySql.append(" and  (f.zz_state = '1' or f.zz_state = '2' or f.zz_state = '3' or f.zz_state = '4') ");
		}else{
			querySql.append(" and  f.zz_state = '4' ");
		}
		
		
		// ת�ʵ���
		if (StringUtils.isNotBlank(zz_no)) {
			querySql.append(" and f.zz_no  like '%"+zz_no+"'%");
		}
		// �ɹ�����
		if (StringUtils.isNotBlank(cg_order_num)) {
			querySql.append(" and f.cg_order_num  like '%"+cg_order_num+"%'");
		}
		// ת��״̬
		if (StringUtils.isNotBlank(zz_state)) {
			querySql.append(" and f.zz_state='"+zz_state+"'");
		}
		// ת��״̬
		if (StringUtils.isNotBlank(flag)) {
		querySql.append(" and f.cg_order_num is null");
		}
		querySql.append(" order by  f.zz_state, f.zz_date desc ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * ��ѯת�ʻ�����Ϣ
	 * 
	 */
	public ISrvMsg getZzInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		
		String zz_id = isrvmsg.getValue("zz_id");// ת�ʵ���
		String cg_order_num = isrvmsg.getValue("cg_order_num");// �ɹ�����
		String zz_state = isrvmsg.getValue("zz_state");// ת��״̬
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_id,f.zz_no,f.cg_order_num,f.zz_date,f.zz_money,f.lifnr_name,f.zz_num,f.batch_plan,f.creator,z.org_abbreviation as org_name,case when f.zz_state='1' then '����' when f.zz_state='2' then '������' when f.zz_state='3' then 'δת��' when f.zz_state='4' then '��ת��' end as zz_state_desc from dms_zz_info f ");
		querySql.append(" left join comm_org_subjection s on f.org_sub_id=s.org_subjection_id left join comm_org_information z on z.org_id=s.org_id  ");
		querySql.append("  where f.bsflag='0' and f.zz_state!='5' ");
		// ���뵥ID
		if (StringUtils.isNotBlank(zz_id)) {
			querySql.append(" and f.zz_id  = '"+zz_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(querySql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceMap", deviceappMap);
		}
		return responseDTO;
	}

	/**
	 * ��ѯת���豸��Ϣ
	 * 
	 */
	public ISrvMsg getZzDetailInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String zz_id = isrvmsg.getValue("zz_id");// ת�ʵ���
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select d.*,i.org_abbreviation org_name from dms_zz_detailed d  left join dms_zz_info f on f.zz_id=d.zz_id ")
		.append(" left join bgp_comm_erp_org_info e on d.zzssdw=e.erp_org_info_id and e.bsflag='0' ")
		.append(" left join comm_org_information i on e.gms_org_id=i.org_id and i.bsflag='0' ")
		.append(" where d.bsflag='0' ");
		// ���뵥ID
		if (StringUtils.isNotBlank(zz_id)) {
			querySql.append(" and f.zz_id  = '"+zz_id+"'");
		}
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querySql.toString());
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ��ѯת���б���Ϣ
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryzAddList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//��ȡ��ǰҳ
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
		String valueadd_id = isrvmsg.getValue("valueadd_id");// ��ֵ����
		String bsflag = isrvmsg.getValue("bsflag");// ��ֵ״̬
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.*,case when f.bsflag='1' then '����' when f.bsflag='2' then '������' when f.bsflag='3' then 'δ��ֵ' when f.bsflag='4' then '����ֵ' end as bsflag_desc, case when f.isdevice='0' then '����' when f.isdevice='1' then '�豸' else '' end as isdevice_desc from Dms_Equi_Valueadd_Info f where f.bsflag!='5' ");
		// ��ֵ����
		if (StringUtils.isNotBlank(valueadd_id)) {
			querySql.append(" and f.valueadd_id  like '%"+valueadd_id+"%'");
		}
		// ��ֵ״̬
		if (StringUtils.isNotBlank(bsflag)) {
			querySql.append(" and f.bsflag='"+bsflag+"'");
		}
		querySql.append(" order by  f.bsflag, f.create_date desc ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ѯ��ֵ������Ϣ
	 * 
	 */
	public ISrvMsg getzAddInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String zz_info_id = isrvmsg.getValue("zz_info_id");// ת�ʵ���
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.*,case when f.bsflag='1' then '����' when f.bsflag='2' then '������' when f.bsflag='3' then 'δ��ֵ' when f.bsflag='4' then '����ֵ' end as bsflag_desc, case when f.isdevice='0' then '����' when f.isdevice='1' then '�豸' else '' end as isdevice_desc from Dms_Equi_Valueadd_Info f where f.bsflag!='5' and f.zz_info_id='"+zz_info_id+"' ");
		Map deviceappMap = jdbcDao.queryRecordBySQL(querySql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceMap", deviceappMap);
		}
		return responseDTO;
	}
	
	/**
	 * ��ѯ��ֵ�豸��Ϣ
	 * 
	 */
	public ISrvMsg getzAddDetailInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String zz_info_id = isrvmsg.getValue("zz_info_id");// ת�ʵ���
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select * from Dms_Equi_Valueadd_Detail d " +
				" join Dms_Equi_Valueadd_Info f on f.zz_info_id=d.zz_info_id ");
		// ��ֵ��ID
		if (StringUtils.isNotBlank(zz_info_id)) {
			querySql.append(" and f.zz_info_id  = '"+zz_info_id+"'");
		}
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querySql.toString());
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	/**
	 * ��ѯת���б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryTranAssetList(ISrvMsg msg) throws Exception {
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
		String zzNo = msg.getValue("zzno");// ת�ʵ���
		String zzOrgName = msg.getValue("zzorgname");// ת�ʻ�������
		String cgOrderNum = msg.getValue("cgordernum");// �ɹ�����
		String lifnrName = msg.getValue("lifnrname");// ��Ӧ������
		String zzState = msg.getValue("zzstate");// ת��״̬
		String batchPlan = msg.getValue("batchplan");// ���μƻ�
		String creatorName = msg.getValue("creatorname");// ������
		String zzNumStart = msg.getValue("zznumstart");// ת����ʼ̨��
		String zzNumEnd = msg.getValue("zznumend");// ת�ʽ���̨��
		String zzMoneyStart = msg.getValue("zzmoneystart");// ת����ʼ�ܽ��
		String zzMoneyend = msg.getValue("zzmoneyend");// ת�ʽ����ܽ��
		String zzDateStart = msg.getValue("zzdatestart");// ������ʼʱ��
		String zzDateEnd = msg.getValue("zzdateend");// ��������ʱ��
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_id,f.zz_no,f.cg_order_num,f.zz_money,f.lifnr_name,"
					+ " case when f.creator like '8%' then emp.employee_name else f.creator end as creator,"
					+ " to_char(to_date(f.zz_date, 'yyyymmdd'),'yyyy-mm-dd') as zz_date,"
					+ " f.zz_num,f.batch_plan,info.org_abbreviation as zz_org_name,info.org_name,"
					+ " case when f.zz_state = '1' then '����' when f.zz_state = '2' then '������'"
					+ " when f.zz_state = '3' then 'δת��' when f.zz_state = '4' then '��ת��' end as zz_state_desc"
					+ " from dms_zz_info f"
					+ " left join comm_human_employee_hr hr on f.creator = hr.employee_cd and hr.bsflag = '0'"
	                + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					+ " left join comm_org_information info on f.org_id = info.org_id and info.bsflag = '0'"
					+ " where f.bsflag = '0'");				
		// ת�ʵ���
		if (StringUtils.isNotBlank(zzNo)) {
			querySql.append(" and f.zz_no  like '%"+zzNo+"%'");
		}
		// ת�ʻ���
		if (StringUtils.isNotBlank(zzOrgName)) {
			querySql.append(" and info.org_name like '%"+zzOrgName+"%'");
		}
		// �ɹ�����
		if (StringUtils.isNotBlank(cgOrderNum)) {
			querySql.append(" and f.cg_order_num like '%"+cgOrderNum+"%'");
		}
		// ��Ӧ������
		if (StringUtils.isNotBlank(lifnrName)) {
			querySql.append(" and f.lifnr_name like '%"+lifnrName+"%'");
		}
		// ���μƻ�
		if (StringUtils.isNotBlank(batchPlan)) {
			querySql.append(" and f.batch_plan like '%"+batchPlan+"%'");
		}
		// ������
		if (StringUtils.isNotBlank(creatorName)) {
			querySql.append(" and (emp.employee_name like '%"+creatorName+"%' or f.creator like '%"+creatorName+"%')");
		}
		// ת��״̬
		if (StringUtils.isNotBlank(zzState)) {
			querySql.append(" and f.zz_state = '"+zzState+"'");
		}
		//ת��̨��
		if(StringUtils.isNotBlank(zzNumStart) && StringUtils.isNotBlank(zzNumEnd)){
			querySql.append(" and f.zz_num >= '"+zzNumStart+"' and f.zz_num <= '"+zzNumEnd+"'");
		}
		if(StringUtils.isNotBlank(zzNumStart) && StringUtils.isBlank(zzNumEnd)){
			querySql.append(" and f.zz_num >= '"+zzNumStart+"'");
		}
		if(StringUtils.isBlank(zzNumStart) && StringUtils.isNotBlank(zzNumEnd)){
			querySql.append(" and f.zz_num <= '"+zzNumEnd+"'");
		}
		//ת���ܽ��
		if(StringUtils.isNotBlank(zzMoneyStart) && StringUtils.isNotBlank(zzMoneyend)){
			querySql.append(" and f.zz_money >= '"+zzMoneyStart+"' and f.zz_money <= '"+zzMoneyend+"'");
		}
		if(StringUtils.isNotBlank(zzMoneyStart) && StringUtils.isBlank(zzMoneyend)){
			querySql.append(" and f.zz_money >= '"+zzMoneyStart+"'");
		}
		if(StringUtils.isBlank(zzMoneyStart) && StringUtils.isNotBlank(zzMoneyend)){
			querySql.append(" and f.zz_money <= '"+zzMoneyend+"'");
		}
		//��������
		if(StringUtils.isNotBlank(zzDateStart) && StringUtils.isNotBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') >= to_date('"+zzDateStart+"','yyyy-mm-dd')"
						  + " and to_date(f.zz_date, 'yyyymmdd') <= to_date('"+zzDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(zzDateStart) && StringUtils.isBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') >= to_date('"+zzDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(zzDateStart) && StringUtils.isNotBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') <= to_date('"+zzDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by f.zz_state, f.zz_date desc ");
		}	
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ת�ʵ�����ҳ����Ϣ��ʾ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssetMainInfo(ISrvMsg reqDTO) throws Exception {		
		String zzId = reqDTO.getValue("zzid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select f.zz_id,f.zz_no,f.cg_order_num,f.zz_money,f.lifnr_name,"
						+ " case when f.creator like '8%' then emp.employee_name else f.creator end as creator,"
						+ " to_char(to_date(f.zz_date, 'yyyymmdd'),'yyyy-mm-dd') as zz_date,"
						+ " f.zz_num,f.batch_plan,info.org_abbreviation as zz_org_name,"
						+ " case when f.zz_state = '1' then '����' when f.zz_state = '2' then '������'"
						+ " when f.zz_state = '3' then 'δת��' when f.zz_state = '4' then '��ת��' end as zz_state_desc"
						+ " from dms_zz_info f"
						+ " left join comm_human_employee_hr hr on f.creator = hr.employee_cd and hr.bsflag = '0'"
		                + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
						+ " left join comm_org_information info on info.org_id = f.org_id and info.bsflag = '0'"
						+ " where f.bsflag = '0' and f.zz_state != '5'"
						+ " and f.zz_id = '"+zzId+"'");
		Map zzMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(zzMap)) {
			responseMsg.setValue("data", zzMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD ת�ʵ����豸��ϸ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAssetDevDet(ISrvMsg msg) throws Exception {	
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
		String zzId = msg.getValue("zzid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append( "select d.zzd_id,d.eqktx,d.typbz,d.dev_coding,d.answt,"
					+ " to_char(to_date(d.inbdt, 'yyyymmdd'), 'yyyy-mm-dd') as inbdt,"
					+ " info.org_abbreviation as own_org_name,info.org_name"
					+ " from dms_zz_detailed d"
					+ " left join comm_org_information info on info.org_id = d.org_id and info.bsflag = '0'"
					+ " where d.bsflag = '0' and d.zz_id = '"+zzId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.create_date desc,d.zzd_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ��ֵ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryIncreaseValueList(ISrvMsg msg) throws Exception {
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
		String valueId = msg.getValue("valueid");// ��ֵ����
		String valueContent = msg.getValue("valuecontent");// ��ֵ����
		String valueState = msg.getValue("valuestate");// ��ֵ״̬
		String creatorName = msg.getValue("creatorname");// ������
		String valueMoneyStart = msg.getValue("valuemoneystart");// ��ֵ��ʼ�ܽ��
		String valueMoneyend = msg.getValue("valuemoneyend");// ��ֵ�����ܽ��
		String createDateStart = msg.getValue("createdatestart");// ������ʼʱ��
		String createDateEnd = msg.getValue("createdateend");// ��������ʱ��
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_info_id,f.valueadd_id,f.valueadd_content,f.amount_money,"
				      + " case when f.creater like '8%' then emp.employee_name else f.creater end as creater,"
					  + " to_char(to_date(f.create_date, 'yyyymmdd'), 'yyyy-mm-dd') as create_date,"
				      + " case when f.bsflag = '1' then '����' when f.bsflag = '2' then '������'"
					  + " when f.bsflag = '3' then '����ֵ' when f.bsflag = '4' then '����ֵ' end as bsflag_desc"
					  + " from dms_equi_valueadd_info f"
					  + " left join comm_human_employee_hr hr on f.creater = hr.employee_cd and hr.bsflag = '0'"
					  + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
				      + " where f.bsflag!='5' ");				
		// ��ֵ����
		if (StringUtils.isNotBlank(valueId)) {
			querySql.append(" and f.valueadd_id  like '%"+valueId+"%'");
		}
		// ��ֵ����
		if (StringUtils.isNotBlank(valueContent)) {
			querySql.append(" and f.valueadd_content like '%"+valueContent+"%'");
		}
		// ������
		if (StringUtils.isNotBlank(creatorName)) {
			querySql.append(" and (emp.employee_name like '%"+creatorName+"%' or f.creater like '%"+creatorName+"%')");
		}
		// ��ֵ״̬
		if (StringUtils.isNotBlank(valueState)) {
			querySql.append(" and f.bsflag = '"+valueState+"'");
		}
		//��ֵ�ܽ��
		if(StringUtils.isNotBlank(valueMoneyStart) && StringUtils.isNotBlank(valueMoneyend)){
			querySql.append(" and f.amount_money >= '"+valueMoneyStart+"' and f.amount_money <= '"+valueMoneyend+"'");
		}
		if(StringUtils.isNotBlank(valueMoneyStart) && StringUtils.isBlank(valueMoneyend)){
			querySql.append(" and f.amount_money >= '"+valueMoneyStart+"'");
		}
		if(StringUtils.isBlank(valueMoneyStart) && StringUtils.isNotBlank(valueMoneyend)){
			querySql.append(" and f.amount_money <= '"+valueMoneyend+"'");
		}
		//��������
		if(StringUtils.isNotBlank(createDateStart) && StringUtils.isNotBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') >= to_date('"+createDateStart+"','yyyy-mm-dd')"
						  + " and to_date(f.create_date, 'yyyymmdd') <= to_date('"+createDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(createDateStart) && StringUtils.isBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') >= to_date('"+createDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(createDateStart) && StringUtils.isNotBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') <= to_date('"+createDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by f.create_date desc,f.bsflag,f.zz_info_id");
		}	
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ֵ������ҳ����Ϣ��ʾ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIncreaseMainInfo(ISrvMsg reqDTO) throws Exception {		
		String zzInfoId = reqDTO.getValue("zzinfoid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select f.zz_info_id,f.valueadd_id,f.valueadd_content,f.amount_money,"
				       + " case when f.creater like '8%' then emp.employee_name else f.creater end as creater,"
					   + " to_char(to_date(f.create_date, 'yyyymmdd'), 'yyyy-mm-dd') as create_date,"
				       + " case when f.bsflag = '1' then '����' when f.bsflag = '2' then '������'"
					   + " when f.bsflag = '3' then '����ֵ' when f.bsflag = '4' then '����ֵ' end as bsflag_desc"
					   + " from dms_equi_valueadd_info f"
					   + " left join comm_human_employee_hr hr on f.creater = hr.employee_cd and hr.bsflag = '0'"
					   + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					   + " where f.zz_info_id = '"+zzInfoId+"'");
		Map valueMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(valueMap)) {
			responseMsg.setValue("data", valueMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD ��ֵ�����豸��ϸ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryIncreaseDevDet(ISrvMsg msg) throws Exception {	
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
		String zzInfoId = msg.getValue("zzinfoid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.dev_name,d.dev_coding,d.typbz,d.zz_detail_id,d.zzzjitem,"
					  + " d.cg_order_num,d.contract_num,d.valueadd_money"
					  + " from dms_equi_valueadd_detail d"
					  + " where d.zz_info_id = '"+zzInfoId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.create_date,d.zz_detail_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯת�����뵥״̬
	 */
	public ISrvMsg getZzState(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String zz_id=isrvmsg.getValue("zz_id");// ���ϴ������뵥ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select zzinfo.zz_id, nvl(wfmiddle.proc_status, '') as proc_status  from dms_zz_info_apply zzinfo ");
		queryScrapeInfoSql.append("join common_busi_wf_middle wfmiddle on zzinfo.zz_id = wfmiddle.business_id ");
		// ���뵥ID
		if (StringUtils.isNotBlank(zz_id)) {
			queryScrapeInfoSql.append(" and zz_id  = '"+zz_id+"'");
		}
		Map zzMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(zzMap!=null){
			responseDTO.setValue("zzMap", zzMap);
		}
		return responseDTO;
	}
	/**
	 * ��ѯת�������б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryzhuanziApplyList(ISrvMsg msg) throws Exception {
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
		String zzNo = msg.getValue("zzno");// ת�ʵ���
		String zzOrgName = msg.getValue("zzorgname");// ת�ʻ�������
		String cgOrderNum = msg.getValue("cgordernum");// �ɹ�����
		String lifnrName = msg.getValue("lifnrname");// ��Ӧ������
		String zzState = msg.getValue("zzstate");// ת��״̬
		String batchPlan = msg.getValue("batchplan");// ���μƻ�
		String creatorName = msg.getValue("creatorname");// ������
		String zzNumStart = msg.getValue("zznumstart");// ת����ʼ̨��
		String zzNumEnd = msg.getValue("zznumend");// ת�ʽ���̨��
		String zzMoneyStart = msg.getValue("zzmoneystart");// ת����ʼ�ܽ��
		String zzMoneyend = msg.getValue("zzmoneyend");// ת�ʽ����ܽ��
		String zzDateStart = msg.getValue("zzdatestart");// ������ʼʱ��
		String zzDateEnd = msg.getValue("zzdateend");// ��������ʱ��
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_id,f.zz_no,f.cg_order_num,f.zz_money,f.lifnr_name,"
					+ " case when f.creator like '8%' then emp.employee_name else f.creator end as creator,"
					+ " to_char(to_date(f.zz_date, 'yyyymmdd'),'yyyy-mm-dd') as zz_date,"
					+ " f.zz_num,f.batch_plan,info.org_abbreviation as zz_org_name,info.org_name,"
					+ " case when f.zz_state = '1' then '����' when f.zz_state = '2' then '������'"
					+ " when f.zz_state = '3' then 'δת��' when f.zz_state = '4' then '��ת��' end as zz_state_desc,"
					+ " case when t2.proc_status = '1' then '������' when t2.proc_status = '3' THEN '����ͨ��' "
					+ " when t2.proc_status = '4' then '������ͨ��' else 'δ�ύ' end as apply_status"
					+ " from dms_zz_info_apply f"
					+ " left join comm_human_employee_hr hr on f.creator = hr.employee_cd and hr.bsflag = '0'"
	                + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					+ " left join comm_org_information info on f.org_id = info.org_id and info.bsflag = '0'"
	                + " left join common_busi_wf_middle t2 on f.zz_id= t2.business_id and t2.bsflag = '0'"
					+ " where f.bsflag = '0'");
		// ת�ʵ���
		if (StringUtils.isNotBlank(zzNo)) {
			querySql.append(" and f.zz_no  like '%"+zzNo+"%'");
		}
		// ת�ʻ���
		if (StringUtils.isNotBlank(zzOrgName)) {
			querySql.append(" and info.org_name like '%"+zzOrgName+"%'");
		}
		// �ɹ�����
		if (StringUtils.isNotBlank(cgOrderNum)) {
			querySql.append(" and f.cg_order_num like '%"+cgOrderNum+"%'");
		}
		// ��Ӧ������
		if (StringUtils.isNotBlank(lifnrName)) {
			querySql.append(" and f.lifnr_name like '%"+lifnrName+"%'");
		}
		// ���μƻ�
		if (StringUtils.isNotBlank(batchPlan)) {
			querySql.append(" and f.batch_plan like '%"+batchPlan+"%'");
		}
		// ������
		if (StringUtils.isNotBlank(creatorName)) {
			querySql.append(" and (emp.employee_name like '%"+creatorName+"%' or f.creator like '%"+creatorName+"%')");
		}
		// ����״̬
		if (StringUtils.isNotBlank(zzState)) {
			if("2".equals(zzState.toString())) {
				querySql.append(" and (t2.proc_status IS NULL OR t2.proc_status!='2') ");
			}else {
				querySql.append(" and t2.proc_status = '"+zzState+"'");
			}
			
		}
		//ת��̨��
		if(StringUtils.isNotBlank(zzNumStart) && StringUtils.isNotBlank(zzNumEnd)){
			querySql.append(" and f.zz_num >= '"+zzNumStart+"' and f.zz_num <= '"+zzNumEnd+"'");
		}
		if(StringUtils.isNotBlank(zzNumStart) && StringUtils.isBlank(zzNumEnd)){
			querySql.append(" and f.zz_num >= '"+zzNumStart+"'");
		}
		if(StringUtils.isBlank(zzNumStart) && StringUtils.isNotBlank(zzNumEnd)){
			querySql.append(" and f.zz_num <= '"+zzNumEnd+"'");
		}
		//ת���ܽ��
		if(StringUtils.isNotBlank(zzMoneyStart) && StringUtils.isNotBlank(zzMoneyend)){
			querySql.append(" and f.zz_money >= '"+zzMoneyStart+"' and f.zz_money <= '"+zzMoneyend+"'");
		}
		if(StringUtils.isNotBlank(zzMoneyStart) && StringUtils.isBlank(zzMoneyend)){
			querySql.append(" and f.zz_money >= '"+zzMoneyStart+"'");
		}
		if(StringUtils.isBlank(zzMoneyStart) && StringUtils.isNotBlank(zzMoneyend)){
			querySql.append(" and f.zz_money <= '"+zzMoneyend+"'");
		}
		//��������
		if(StringUtils.isNotBlank(zzDateStart) && StringUtils.isNotBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') >= to_date('"+zzDateStart+"','yyyy-mm-dd')"
						  + " and to_date(f.zz_date, 'yyyymmdd') <= to_date('"+zzDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(zzDateStart) && StringUtils.isBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') >= to_date('"+zzDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(zzDateStart) && StringUtils.isNotBlank(zzDateEnd)){
			querySql.append(" and to_date(f.zz_date, 'yyyymmdd') <= to_date('"+zzDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by f.zz_state, f.zz_date desc ");
		}	
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ת�ʵ���������ҳ����Ϣ��ʾ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZhuanZiMainInfo(ISrvMsg reqDTO) throws Exception {		
		String zzId = reqDTO.getValue("zzid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select f.zz_id,f.zz_no,f.cg_order_num,f.zz_money,f.lifnr_name,"
						+ " case when f.creator like '8%' then emp.employee_name else f.creator end as creator,"
						+ " to_char(to_date(f.zz_date, 'yyyymmdd'),'yyyy-mm-dd') as zz_date,"
						+ " f.zz_num,f.batch_plan,info.org_abbreviation as zz_org_name,"
						+ " case when f.zz_state = '1' then '����' when f.zz_state = '2' then '������'"
						+ " when f.zz_state = '3' then 'δת��' when f.zz_state = '4' then '��ת��' end as zz_state_desc"
						+ " from dms_zz_info_apply f"
						+ " left join comm_human_employee_hr hr on f.creator = hr.employee_cd and hr.bsflag = '0'"
		                + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
						+ " left join comm_org_information info on info.org_id = f.org_id and info.bsflag = '0'"
						+ " where f.bsflag = '0' and f.zz_state != '5'"
						+ " and f.zz_id = '"+zzId+"'");
		Map zzMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(zzMap)) {
			responseMsg.setValue("data", zzMap);
		}
		return responseMsg;
	}
	/**
	 * ת�ʵ��������豸��ϸ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryZhuanZiDevDet(ISrvMsg msg) throws Exception {	
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
		String zzId = msg.getValue("zzid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append( "select d.zzd_id,d.eqktx,d.typbz,d.dev_coding,d.answt,"
					+ " to_char(to_date(d.inbdt, 'yyyymmdd'), 'yyyy-mm-dd') as inbdt,"
					+ " d.org_name"
					+ " from dms_zz_detailed_apply d"
					+ " left join comm_org_information info on info.org_id = d.org_id and info.bsflag = '0'"
					+ " where d.bsflag = '0' and d.zz_id = '"+zzId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.create_date desc,d.zzd_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ת�ʵ��������ϸ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProcHistory(ISrvMsg msg) throws Exception {
		
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
		
		String zzId = msg.getValue("zzid");	
		// ��ȡ������ʷ��Ϣ
		StringBuffer querySql = new StringBuffer();
		querySql.append("select proc_inst_id from common_busi_wf_middle where bsflag = '0' and business_id='"+zzId+"'");
		List<Map> procInstId = pureJdbcDao.queryRecords(querySql.toString());
		for (Map map : procInstId) {
			List listExamine = wfBean.getProcHistory(map.get("proc_inst_id").toString());
			responseDTO.setValue("datas", listExamine);
		}
		responseDTO.setValue("totalRows",1);
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ת���ļ��б�
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getFileList(ISrvMsg msg) throws Exception {
		
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
		
		String zzId = msg.getValue("zzid");	
		//�ļ�����
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.ucm_id as file_id, t.file_name,"
				+ " case when t.file_type = 'contract_purchase' then '�ɹ���ͬ'"
				+ " when t.file_type ='contract_device' THEN '�豸���յ�'"
				+ " when t.file_type ='contract_transfer' THEN '�豸�̶��ʲ�ת�����뵥'"
				+ " when t.file_type ='contract_claim' THEN '�豸ת�ʱ���Ʊ������' end as file_type"
				+ " from bgp_doc_gms_file t WHERE  t.bsflag = '0' and t.relation_id='"+zzId+"'");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas",list);
		responseDTO.setValue("totalRows",page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ��ֵ�����б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryIncreaseApplyValueList(ISrvMsg msg) throws Exception {
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
		String valueId = msg.getValue("valueid");// ��ֵ����
		String valueContent = msg.getValue("valuecontent");// ��ֵ����
		String valueState = msg.getValue("valuestate");// ��ֵ״̬
		String creatorName = msg.getValue("creatorname");// ������
		String valueMoneyStart = msg.getValue("valuemoneystart");// ��ֵ��ʼ�ܽ��
		String valueMoneyend = msg.getValue("valuemoneyend");// ��ֵ�����ܽ��
		String createDateStart = msg.getValue("createdatestart");// ������ʼʱ��
		String createDateEnd = msg.getValue("createdateend");// ��������ʱ��
		String zengzhiState = msg.getValue("zengzhiState");//���״̬
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.zz_info_id,f.valueadd_id,f.valueadd_content,f.amount_money,"
				      + " case when f.creater like '8%' then emp.employee_name else f.creater end as creater,"
					  + " to_char(to_date(f.create_date, 'yyyymmdd'), 'yyyy-mm-dd') as create_date,"
				      + " case when f.bsflag = '1' then '����' when f.bsflag = '2' then '������'"
					  + " when f.bsflag = '3' then '����ֵ' when f.bsflag = '4' then '����ֵ' end as bsflag_desc,"
					  + " case when t2.proc_status = '1' then '������' when t2.proc_status = '3' THEN '����ͨ��' "
					  + " when t2.proc_status = '4' then '������ͨ��' else 'δ�ύ' end as apply_status"
					  + " from dms_equi_valueadd_info_apply f"
					  + " left join comm_human_employee_hr hr on f.creater = hr.employee_cd and hr.bsflag = '0'"
					  + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					  + " left join common_busi_wf_middle t2 on f.zz_info_id= t2.business_id and t2.bsflag = '0'"
				      + " where f.bsflag ='0' ");				
		// ��ֵ����
		if (StringUtils.isNotBlank(valueId)) {
			querySql.append(" and f.valueadd_id  like '%"+valueId+"%'");
		}
		// ��ֵ����
		if (StringUtils.isNotBlank(valueContent)) {
			querySql.append(" and f.valueadd_content like '%"+valueContent+"%'");
		}
		// ������
		if (StringUtils.isNotBlank(creatorName)) {
			querySql.append(" and (emp.employee_name like '%"+creatorName+"%' or f.creater like '%"+creatorName+"%')");
		}
		// ��ֵ״̬
		if (StringUtils.isNotBlank(valueState)) {
			querySql.append(" and f.bsflag = '"+valueState+"'");
		}
		// ����״̬
		if (StringUtils.isNotBlank(zengzhiState)) {
			if("2".equals(zengzhiState.toString())) {
				querySql.append(" and (t2.proc_status IS NULL OR t2.proc_status!='2') ");
			}else {
				querySql.append(" and t2.proc_status = '"+zengzhiState+"'");
			}			
		}
		//��ֵ�ܽ��
		if(StringUtils.isNotBlank(valueMoneyStart) && StringUtils.isNotBlank(valueMoneyend)){
			querySql.append(" and f.amount_money >= '"+valueMoneyStart+"' and f.amount_money <= '"+valueMoneyend+"'");
		}
		if(StringUtils.isNotBlank(valueMoneyStart) && StringUtils.isBlank(valueMoneyend)){
			querySql.append(" and f.amount_money >= '"+valueMoneyStart+"'");
		}
		if(StringUtils.isBlank(valueMoneyStart) && StringUtils.isNotBlank(valueMoneyend)){
			querySql.append(" and f.amount_money <= '"+valueMoneyend+"'");
		}
		//��������
		if(StringUtils.isNotBlank(createDateStart) && StringUtils.isNotBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') >= to_date('"+createDateStart+"','yyyy-mm-dd')"
						  + " and to_date(f.create_date, 'yyyymmdd') <= to_date('"+createDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(createDateStart) && StringUtils.isBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') >= to_date('"+createDateStart+"','yyyy-mm-dd')");
		}
		if(StringUtils.isBlank(createDateStart) && StringUtils.isNotBlank(createDateEnd)){
			querySql.append(" and to_date(f.create_date, 'yyyymmdd') <= to_date('"+createDateEnd+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by f.create_date desc,f.bsflag,f.zz_info_id");
		}	
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ��ֵ���뵥״̬
	 */
	public ISrvMsg getZengzState(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String zz_id=isrvmsg.getValue("zz_id");// ���ϴ������뵥ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select zzinfo.zz_info_id, nvl(wfmiddle.proc_status, '') as proc_status  from dms_equi_valueadd_info_apply zzinfo ");
		queryScrapeInfoSql.append("join common_busi_wf_middle wfmiddle on zzinfo.zz_info_id = wfmiddle.business_id ");
		// ���뵥ID
		if (StringUtils.isNotBlank(zz_id)) {
			queryScrapeInfoSql.append(" and zz_info_id  = '"+zz_id+"'");
		}
		Map zzMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(zzMap!=null){
			responseDTO.setValue("zzMap", zzMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ֵ���뵥����ҳ����Ϣ��ʾ
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIncreaseApplyMainInfo(ISrvMsg reqDTO) throws Exception {		
		String zzInfoId = reqDTO.getValue("zzinfoid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select f.zz_info_id,f.valueadd_id,f.valueadd_content,f.amount_money,"
				       + " case when f.creater like '8%' then emp.employee_name else f.creater end as creater,"
					   + " to_char(to_date(f.create_date, 'yyyymmdd'), 'yyyy-mm-dd') as create_date,"
				       + " case when f.bsflag = '1' then '����' when f.bsflag = '2' then '������'"
					   + " when f.bsflag = '3' then '����ֵ' when f.bsflag = '4' then '����ֵ' end as bsflag_desc,"
					   + " case when t2.proc_status = '1' then '������' when t2.proc_status = '3' THEN '����ͨ��' "
					   + " when t2.proc_status = '4' then '������ͨ��' else 'δ�ύ' end as apply_status"
					   + " from dms_equi_valueadd_info_apply f"
					   + " left join comm_human_employee_hr hr on f.creater = hr.employee_cd and hr.bsflag = '0'"
					   + " left join comm_human_employee emp on hr.employee_id = emp.employee_id and emp.bsflag = '0'"
					   + " left join common_busi_wf_middle t2 on f.zz_info_id= t2.business_id and t2.bsflag = '0'"
					   + " where f.zz_info_id = '"+zzInfoId+"'");
		Map valueMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(valueMap)) {
			responseMsg.setValue("data", valueMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD ��ֵ���뵥���豸��ϸ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryIncreaseApplyDevDet(ISrvMsg msg) throws Exception {	
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
		String zzInfoId = msg.getValue("zzinfoid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.dev_name,d.dev_coding,d.typbz,d.zz_detail_id,d.zzzjitem,"
					  + " d.cg_order_num,d.contract_num,d.valueadd_money"
					  + " from dms_equi_valueadd_detail_apply d"
					  + " where d.zz_info_id = '"+zzInfoId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by d.create_date,d.zz_detail_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ֵ���������ϸ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getProcZengZHistory(ISrvMsg msg) throws Exception {
		
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
		
		String zzId = msg.getValue("zz_info_id");	
		// ��ȡ������ʷ��Ϣ
		StringBuffer querySql = new StringBuffer();
		querySql.append("select proc_inst_id from common_busi_wf_middle where bsflag = '0' and business_id='"+zzId+"'");
		List<Map> procInstId = pureJdbcDao.queryRecords(querySql.toString());
		for (Map map : procInstId) {
			List listExamine = wfBean.getProcHistory(map.get("proc_inst_id").toString());
			responseDTO.setValue("datas", listExamine);
		}
		responseDTO.setValue("totalRows",1);
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ֵ�ļ��б�
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZengZFileList(ISrvMsg msg) throws Exception {
		
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
		
		String zzId = msg.getValue("zz_info_id");	
		//�ļ�����
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.ucm_id as file_id, t.file_name, t.create_date"
				+ " from bgp_doc_gms_file t WHERE  t.bsflag = '0' and t.relation_id='"+zzId+"'");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas",list);
		responseDTO.setValue("totalRows",page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��ѯ��Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryMessageList(ISrvMsg msg) throws Exception {
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
		
		String content = msg.getValue("content");//��Ϣ����
		
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select f.*"
					+ " from dms_msg_info f"
					+ " where f.bsflag = '0'");
		//��Ϣ����
		if (StringUtils.isNotBlank(content)) {
			querySql.append(" and f.content  like '%"+content+"%'");
		}
		
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��Ϣ�ļ��б�
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMsgFileList(ISrvMsg msg) throws Exception {
		
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
		
		String msg_id = msg.getValue("msg_id");	
		//�ļ�����
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.ucm_id as file_id, t.file_name, t.create_date"
				+ " from bgp_doc_gms_file t WHERE  t.bsflag = '0' and t.file_type = 'msg_purchase' and t.relation_id='"+msg_id+"'");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas",list);
		responseDTO.setValue("totalRows",page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * ��Ϣ  ��ѯ��Ϣ֪ͨ
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getMsgInfoData(ISrvMsg isrvmsg) throws Exception {
		log.info("getMsgInfoData");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		StringBuffer queryopiInfoSql = new StringBuffer();
		queryopiInfoSql.append("SELECT * FROM DMS_MSG_INFO dmi WHERE TO_CHAR(dmi.SHOW_DATE) >= TO_CHAR(SYSDATE) and dmi.bsflag = '0'");
		List<Map> deviceappMap = jdbcDao.queryRecords(queryopiInfoSql.toString());
		responseDTO.setValue("data", deviceappMap);
		return responseDTO;
	}
}
