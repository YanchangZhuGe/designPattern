package com.bgp.dms.plan;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.util.ServiceUtils;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 
 * @author dushuai
 * 
 */
public class YearPlanSrv extends BaseService {

	public YearPlanSrv() {
		log = LogFactory.getLogger(YearPlanSrv.class);
	}

	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");

	/**
	 * ��ѯ��ȼƻ���Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryYearPlanList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryYearPlanList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
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
		String apply_num = isrvmsg.getValue("apply_num");// ����
		String apply_status = isrvmsg.getValue("apply_status");// ����״̬
		String apply_year = isrvmsg.getValue("apply_year");// ���
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t1.user_name as fill_per_name,t3.org_abbreviation as org_id_name,(case when t2.proc_status='1' then '������' when t2.proc_status='3' then '����ͨ��' when t2.proc_status='4' then '������ͨ��' else 'δ�ύ' end ) as apply_status "
				+ " from dms_yearplan_apply t "
				+ " left join p_auth_user_dms t1 on t.fill_per=t1.user_id "
				+ " left join common_busi_wf_middle t2 on t.apply_id=t2.business_id  and t2.bsflag='0'  "
				+ " left join comm_org_information t3 on t.org_id=t3.org_id "
				+ " where t.bsflag='0' ");
		// ����
		if (StringUtils.isNotBlank(apply_num)) {
			querySql.append(" and t.apply_num ='" + apply_num + "'");
		}
		// ����״̬
		if (StringUtils.isNotBlank(apply_status)) {
			if ("0".equals(apply_status)) {
				querySql.append(" and t2.proc_status is null");
			} else {
				querySql.append(" and t2.proc_status = '" + apply_status + "'");
			}
		}
		// ���
		if (StringUtils.isNotBlank(apply_year)) {
			querySql.append(" and t.apply_year = '" + apply_year + "'");
		}
		querySql.append(" order by t.modify_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ѯ�����豸�������ڴ�̯���ñ���Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryConfigDevInfoList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryConfigDevInfoList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
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
		String dev_name = isrvmsg.getValue("dev_name");// �豸����
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.* from dms_comm_devname_config t  where t.bsflag='0' ");
		// �豸����
		if (StringUtils.isNotBlank(dev_name)) {
			querySql.append(" and t.dev_name like '%" + dev_name + "%'");
		}
		querySql.append(" order by t.order_num ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ѯ��������ҳ��
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg querySuppData(ISrvMsg isrvmsg) throws Exception {
		log.info("queryMarket");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//���뵥id
		String applyId = isrvmsg.getValue("applyId");
		//�������
		String applyYear =isrvmsg.getValue("applyYear");
		responseDTO.setValue("applyId", applyId);
		responseDTO.setValue("applyYear", applyYear);
		return responseDTO;
	}
	
	/**
	 * ��ѯ��ĿͶ��Ч�����۱��б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg querySuppDataFileList(ISrvMsg isrvmsg) throws Exception {
		log.info("querySuppDataFileList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
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
		String applyId = isrvmsg.getValue("applyId");// ����id
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t1.user_name as creater from bgp_doc_gms_file t"
				+ " left join p_auth_user_dms t1 on t.creator_id=t1.user_id "
				+ " where t.bsflag='0' ");
		// ����id
		if (StringUtils.isNotBlank(applyId)) {
			querySql.append(" and t.relation_id ='" + applyId + "'");
		}
		querySql.append(" order by t.order_num ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ȡ���󱨱���Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRequireReportData(ISrvMsg isrvmsg) throws Exception {
		log.info("getRequireReportData");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String applyId = isrvmsg.getValue("applyId");
		List<Map> lists=new ArrayList<Map>();
		//��ѯ�ǰ�װ�豸Ͷ�ʽ���ƻ�������
		String sql0 = "select 'true' as noninstal,t.noninstall_id,t.dev_name,t.purchase_property,t.dev_model,t.purchase_num,t.order_time,"
				+ "t.arrival_time,t.total_invest,t.current_year_plan,t.remark "
				+ "from dms_yearplan_noninstall t where t.apply_id='"+ applyId+ "'";
		List<Map> list0= jdbcDao.queryRecords(sql0);
		lists.addAll(list0);
		//��ѯ���ڴ�̯���ñ�����
		String sql1 = "select 'true' as longterm,t.longtermp_id,t.dev_name,t.last_year_num,t.last_year_money,"
				+ "t.this_year_num,t.this_year_money,t.next_year_num,t.next_year_money,t.remark "
				+ "from dms_yearplan_longterm t where t.apply_id='" + applyId + "'";
		List<Map> list1 = jdbcDao.queryRecords(sql1);
		lists.addAll(list1);
		responseDTO.setValue("datas", lists);
		return responseDTO;
	}
	
	/**
	 * ��ȡ�ǰ�װ�豸Ͷ�ʽ���ƻ�����Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getNoninstallData(ISrvMsg isrvmsg) throws Exception {
		log.info("getNoninstallData");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String applyId = isrvmsg.getValue("applyId");
		List<Map> lists=new ArrayList<Map>();
		//��ѯ�ǰ�װ�豸Ͷ�ʽ���ƻ�������
		String sql = "select t.* from dms_yearplan_noninstall t where t.apply_id='"+ applyId+ "'";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ��ȡ���ڴ�̯���ñ�����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAddLongtermData(ISrvMsg isrvmsg) throws Exception {
		log.info("getAddLongtermData");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		//��ѯ���ڴ�̯���ñ�����
		String sql0 = "select t.* from dms_comm_devname_config t where t.bsflag='0' order by t.order_num";
		List<Map> list= jdbcDao.queryRecords(sql0);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ��ȡ��̽�г�Ԥ�⼰�ֲ�����Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMarketData(ISrvMsg isrvmsg) throws Exception {
		log.info("getMarketData");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String applyId = isrvmsg.getValue("applyId");
		//��ѯ��̽�г�Ԥ�⼰�ֲ�������
		String sql = "select t.market_id,t.terr_phys_ftype,t.terr_phys_type,t.terr_phys_name,t.dev_sign_workload,t.dev_value_workload,t.poject_name,t.projet_start_time,t.projet_end_time,t.dev_income,t.dev_profit,t.project_type,"
				+ " (case "
				+ " when (t.project_type = '2D' and t.terr_phys_ftype='0') then "
				+ " 'tbody_land_2D' "
				+ " when (t.project_type = '2D' and t.terr_phys_ftype='1') then "
				+ " 'tbody_sea_2D' "
				+ " when (t.project_type = '3D' and t.terr_phys_ftype='0') then "
				+ " 'tbody_land_3D' "
				+ " when (t.project_type = '3D' and t.terr_phys_ftype='1') then "
				+ " 'tbody_sea_3D' " + " else " + " '' " + " end) as flag "
				+ " from dms_yearplan_market t where t.apply_id='" + applyId
				+ "'";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ��ȡ��̽�г�Ԥ�⼰�ֲ����豸��Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMarketDeviceData(ISrvMsg isrvmsg) throws Exception {
		log.info("getMarketDeviceData");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String marketId = isrvmsg.getValue("marketId");
		//��ѯ��̽�г�Ԥ�⼰�ֲ����豸������
		String sql = "select t.* from dms_yearplan_market_device t where t.market_id='" + marketId + "'";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ��ȡ�豸��״��������Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDeviceAnalData(ISrvMsg isrvmsg) throws Exception {
		log.info("getDeviceAnalData");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String applyId = isrvmsg.getValue("applyId");
		//��ѯ�豸��״����������
		String sql = "select t.* from dms_yearplan_deviceanal t where t.apply_id='" + applyId + "' order by t.dev_type";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ���ݵ�̨�豸��������ȡ�豸��״��������Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevAnalDataBySCode(ISrvMsg isrvmsg) throws Exception {
		log.info("getDevAnalDataBySCode");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String devTypeStr = isrvmsg.getValue("devTypeStr");
		String sql = " select t2.dev_ct_code as dev_g_type, "
				+ " t2.dev_ct_name as dev_g_name, "
				+ " case  "
				+ " when t3.dev_ct_code is not null then t3.dev_ct_code "
				+ " else t2.dev_ct_code "
				+ " end as dev_m_type, "
				+ " case   "
				+ " when t3.dev_ct_name is not null then t3.dev_ct_name "
				+ " else t2.dev_ct_name "
				+ " end as dev_m_name, "
				+ " case   "
				+ " when t4.dev_ct_code is not null then t4.dev_ct_code "
				+ " when t4.dev_ct_code is null then t3.dev_ct_code "
				+ " when t3.dev_ct_code is null then t2.dev_ct_code "
				+ " end as dev_s_type, "
				+ " case  "
				+ " when t4.dev_ct_name is not null then t4.dev_ct_name "
				+ " when t4.dev_ct_name is null then t3.dev_ct_name "
				+ " when t3.dev_ct_name is null then t2.dev_ct_name "
				+ " end dev_s_name, "
				+ " case  "
				+ " when t5.dev_ct_code is not null then t5.dev_ct_code "
				+ " when t5.dev_ct_code is null then t4.dev_ct_code "
				+ " when t4.dev_ct_code is null then t3.dev_ct_code "
				+ " when t3.dev_ct_code is null then t2.dev_ct_code "
				+ " end as dev_ls_type, "
				+ " case  "
				+ " when t5.dev_ct_name is not null then t5.dev_ct_name "
				+ " when t5.dev_ct_name is null then t4.dev_ct_name "
				+ " when t4.dev_ct_name is null then t3.dev_ct_name "
				+ " when t3.dev_ct_name is null then t2.dev_ct_name "
				+ " end as dev_ls_name, "
				+ " t1.dev_ci_name as dev_name, "
				+ " t1.dev_ci_model as dev_model, "
				+ " tt.* "
				+ " from "
				+ " (select t.dev_type as dev_type, "
				+ " count(*) as total_number, "
				+ " nvl(sum(t.asset_value),0) as tatal_orig_value, "
				+ " nvl(sum(t.net_value),0) as tatal_net_value, "
				+ " count(case "
				+ " when months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12<=6 "
				+ " and months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12>=4 "
				+ " then 'f_s'  "
				+ " end) as f_s_number,  "
				+ " nvl(sum(case   "
				+ " when months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12<=6 "
				+ " and months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12>=4 "
				+ " then t.asset_value "
				+ " end),0) as f_s_orig_value, "
				+ " nvl(sum(case   "
				+ " when months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12<=6 "
				+ " and months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12>=4 "
				+ " then t.net_value "
				+ " end) ,0) as f_s_net_value, "
				+ " count(case   "
				+ " when months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12<=8 "
				+ " and months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12>=7 "
				+ " then 's_e'  "
				+ " end) as s_e_number,  "
				+ " nvl(sum(case   "
				+ " when months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12<=8 "
				+ " and months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12>=7 "
				+ " then t.asset_value "
				+ " end),0) as s_e_orig_value, "
				+ " nvl(sum(case   "
				+ " when months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12<8 "
				+ " and months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12>7 "
				+ " then t.net_value "
				+ " end) ,0) as s_e_net_value, "
				+ " count(case   "
				+ " when months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12>8 "
				+ " then 'e_more'  "
				+ " end) as e_more_number, "
				+ " nvl(sum(case "
				+ " when months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12>8 "
				+ " then t.asset_value "
				+ " end),0) as e_more_orig_value, "
				+ " nvl(sum(case   "
				+ " when months_between(to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd'),t.producting_date)/12>8 "
				+ " then t.net_value "
				+ " end) ,0) as e_more_net_value "
				+ " from gms_device_account t "
				+ " where t.dev_type in (" + devTypeStr + ") "
				+ " and t.bsflag='0' "
				+ " group by t.dev_type order by dev_type )tt "
				+ " left join gms_device_codeinfo t1 "
				+ " on tt.dev_type=t1.dev_ci_code "
				+ " left join gms_device_codetype t2 "
				+ " on substr(t1.dev_ct_code,1,2)=t2.dev_ct_code "
				+ " left join gms_device_codetype t3 "
				+ " on substr(t1.dev_ct_code,1,4)=t3.dev_ct_code "
				+ " left join gms_device_codetype t4 "
				+ " on substr(t1.dev_ct_code,1,6)=t4.dev_ct_code "
				+ " left join gms_device_codetype t5 "
				+ " on substr(t1.dev_ct_code,1,8)=t5.dev_ct_code ";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ��ȡ��ĿͶ��Ч�����۱���Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getFileInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getFileInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String applyId = isrvmsg.getValue("applyId");
		//��ѯ�ļ�������
		String fileSql="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+applyId+"' and t.bsflag='0' order by t.order_num";
		List<Map> list = jdbcDao.queryRecords(fileSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ��ȡ����˵����Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getRemarkInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getRemarkInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String applyId = isrvmsg.getValue("applyId");
		List<Map> list = new ArrayList<Map>();
		//��ѯ����˵��������
		String rSql = "select t.*, '0' as is_file from dms_yearplan_remark t "
				+ "where t.apply_id='" + applyId +"'";
		Map map=jdbcDao.queryRecordBySQL(rSql);
		if(MapUtils.isNotEmpty(map)){
			list.add(map);
			//��ѯ������
			String fileSql = "select t.file_id,t.file_name,t.file_type,'1' as is_file from bgp_doc_gms_file t "
					+ "where t.bsflag='0' and t.relation_id='" + map.get("remark_id").toString() + "' order by t.order_num";
			List<Map> fileList = jdbcDao.queryRecords(fileSql);
			list.addAll(fileList);
		}
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ��ѯ���뵥״̬
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getApplyState(ISrvMsg isrvmsg) throws Exception {
		log.info("getApplyState");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		// ���뵥ID
		String applyId = isrvmsg.getValue("applyId");
		StringBuffer sql = new StringBuffer();
		sql.append("select t.apply_id, nvl(t1.proc_status, '') as proc_status  from dms_yearplan_apply t ");
		sql.append(" left join common_busi_wf_middle t1 on t.apply_id = t1.business_id  where t.bsflag='0' ");
		// ���뵥ID
		if (StringUtils.isNotBlank(applyId)) {
			sql.append(" and t.apply_id  = '" + applyId + "'");
		}
		Map map = jdbcDao.queryRecordBySQL(sql.toString());
		if (MapUtils.isNotEmpty(map)) {
			responseDTO.setValue("data", map);
		}
		return responseDTO;
	}
	
	/**
	 * ��ѯ�����豸�������ڴ�̯���ñ���Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getConfigDevInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getConfigDevInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String id = isrvmsg.getValue("id");
		StringBuffer sql = new StringBuffer();
		sql.append("select t.* from dms_comm_devname_config t where t.bsflag='0' ");
		// ���뵥ID
		if (StringUtils.isNotBlank(id)) {
			sql.append(" and t.devname_config_id  = '" + id + "'");
		}
		Map map = jdbcDao.queryRecordBySQL(sql.toString());
		if (MapUtils.isNotEmpty(map)) {
			responseDTO.setValue("data", map);
		}
		return responseDTO;
	}
	
	/**
	 * �������޸���ȼƻ�-���󱨱���Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateRequireReportInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateRequireReportInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String flag = isrvmsg.getValue("flag");
		Map map = isrvmsg.toMap();
		//���뵥id
		String applyId="";
		//�������
		String applyYear ="";
		//���Ҫ���棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		try {
			if("add".equals(flag)){//�������
				//���屣�������map
				Map mainMap=new HashMap();
				//��ȡ���뵥��
				String applyNum=getApplyNum();
				mainMap.put("apply_num", applyNum);//���뵥��
				mainMap.put("org_id", user.getOrgId());//������λ
				//��ȡ��ǰ���
				Calendar c = Calendar.getInstance();
				Integer year = c.get(Calendar.YEAR); 
				mainMap.put("apply_year",year);//���
				mainMap.put("fill_per",user.getUserId());//���
				mainMap.put("fill_date", new Date());//�����
				ServiceUtils.setCommFields(mainMap, "apply_id", user);
				applyId = (String) jdbcDao.saveOrUpdateEntity(mainMap, "dms_yearplan_apply");
				applyYear=year.toString();
			}else{//�޸Ĳ���
				//����id�ӱ����ݻ�ȡ
				applyId=map.get("apply_id").toString();
				//������ȴӱ����ݻ�ȡ
				applyYear=map.get("apply_year").toString();
				//�����޸������map
				Map umainMap=new HashMap();
				umainMap.put("apply_id", applyId);
				ServiceUtils.setCommFields(umainMap, "apply_id", user);
				jdbcDao.saveOrUpdateEntity(umainMap, "dms_yearplan_apply");
			}
			//�������id��Ϊ��
			if(StringUtils.isNotBlank(applyId)){
				//�������󱨱���Ϣ
				for (Object key : map.keySet()) {
					//�������Ҫɾ���ķǰ�װ�豸Ͷ�ʽ���ƻ������ݣ�������ɾ��sql
					if(((String)key).startsWith("del_non")){
						Map delMap = new HashMap();
						delMap.put("noninstall_id", (String)map.get(key));
						sqlList.add(assembleDelSql("noninstall_id",delMap,"dms_yearplan_noninstall"));
					}
					//����ǰ�װ�豸Ͷ�ʽ���ƻ�����ӣ��޸�sql
					if(((String)key).startsWith("noninstall_id")){
						int index=((String)key).lastIndexOf("_");
						String indexStr=((String)key).substring(index+1);
						Map nonMap = new HashMap();
						nonMap.put("noninstall_id", (String)map.get("noninstall_id_"+indexStr));
						nonMap.put("apply_id", applyId);
						nonMap.put("dev_name", (String)map.get("dev_name_"+indexStr));
						nonMap.put("purchase_property", (String)map.get("purchase_property_"+indexStr));
						nonMap.put("dev_model", (String)map.get("dev_model_"+indexStr));
						nonMap.put("purchase_num", (String)map.get("purchase_num_"+indexStr));
						nonMap.put("order_time", (String)map.get("order_time_"+indexStr));
						nonMap.put("arrival_time", (String)map.get("arrival_time_"+indexStr));
						nonMap.put("total_invest", (String)map.get("total_invest_"+indexStr));
						nonMap.put("current_year_plan", (String)map.get("current_year_plan_"+indexStr));
						nonMap.put("remark", (String)map.get("remark_"+indexStr));
						//�������ɵ�sql������Ϊ��ֵ����������޸�
						if(null==map.get("noninstall_id_"+indexStr) || StringUtils.isBlank(map.get("noninstall_id_"+indexStr).toString())){
							sqlList.add(assembleInsertOrUpdateSql(nonMap,"dms_yearplan_noninstall",user.getUserId(),"add"));
						}else{
							sqlList.add(assembleInsertOrUpdateSql(nonMap,"dms_yearplan_noninstall",user.getUserId(),"update"));
						}
					}
					//���泤�ڴ�̯���ñ���ӣ��޸�sql
					if(((String)key).startsWith("longtermp_id")){
						int index=((String)key).lastIndexOf("_");
						String indexStr=((String)key).substring(index+1);
						Map lonMap = new HashMap();
						lonMap.put("longtermp_id", (String)map.get("longtermp_id_"+indexStr));
						lonMap.put("apply_id", applyId);
						lonMap.put("dev_name", (String)map.get("dev_name_"+indexStr));
						lonMap.put("last_year_num", (String)map.get("last_year_num_"+indexStr));
						lonMap.put("last_year_money", (String)map.get("last_year_money_"+indexStr));
						lonMap.put("this_year_num", (String)map.get("this_year_num_"+indexStr));
						lonMap.put("this_year_money", (String)map.get("this_year_money_"+indexStr));
						lonMap.put("next_year_num", (String)map.get("next_year_num_"+indexStr));
						lonMap.put("next_year_money", (String)map.get("next_year_money_"+indexStr));
						lonMap.put("remark", (String)map.get("remark_"+indexStr));
						//�������ɵ�sql������Ϊ��ֵ����������޸�
						if(null==map.get("longtermp_id_"+indexStr) || StringUtils.isBlank(map.get("longtermp_id_"+indexStr).toString())){
							sqlList.add(assembleInsertOrUpdateSql(lonMap,"dms_yearplan_longterm",user.getUserId(),"add"));
						}else{
							sqlList.add(assembleInsertOrUpdateSql(lonMap,"dms_yearplan_longterm",user.getUserId(),"update"));
						}
					}
				}
				if(CollectionUtils.isNotEmpty(sqlList)){
					String str[]=new String[sqlList.size()];
					String strings[]=sqlList.toArray(str);
					//���������
					jdbcTemplate.batchUpdate(strings);
				}
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		responseDTO.setValue("applyId", applyId);
		responseDTO.setValue("applyYear", applyYear);
		//responseDTO.setValue("tabFlag", "0");//��ת����������tabҳ������ҳ�±�
		return responseDTO;
	}
	
	/**
	 * �����޸ķǰ�װ�豸Ͷ�ʽ���ƻ���������Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateAppNonInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateAppNonInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		//���Ҫ���棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		try {
			for (Object key : map.keySet()) {
				//����ǰ�װ�豸Ͷ�ʽ���ƻ����޸�sql
				if(((String)key).startsWith("noninstall_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					//����
					String noninstall_id_=(String)map.get("noninstall_id_"+indexStr);
					//����sql
					String updateSql="update dms_yearplan_noninstall set approve_num=";
					//��������
					if(StringUtils.isNotBlank(map.get("approve_num_"+indexStr).toString())){
						updateSql+=map.get("approve_num_"+indexStr).toString();
					}else{
						updateSql+="null";
					}
					//������Ͷ��
					if(StringUtils.isNotBlank(map.get("approve_total_invest_"+indexStr).toString())){
						updateSql+=",approve_total_invest="+map.get("approve_total_invest_"+indexStr).toString();
					}else{
						updateSql+=",approve_total_invest=null";
					}
					updateSql+=" where noninstall_id='"+noninstall_id_+"'";
					sqlList.add(updateSql);
				}
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//���������
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * �������޸���̽�г�Ԥ�⼰�ֲ���
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateMarketInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateMarketInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		//���뵥id
		String applyId = map.get("apply_id").toString();
		//�������
		String applyYear =map.get("apply_year").toString();
		//���Ҫɾ�������棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		try {
			for (Object key : map.keySet()) {
				//�������Ҫɾ������̽�г�Ԥ�⼰�ֲ������ݣ�������ɾ��sql
				if(((String)key).startsWith("del_mar")){
					Map delMap = new HashMap();
					delMap.put("market_id", (String)map.get(key));
					//ɾ����̽�г�Ԥ�⼰�ֲ����豸����
					sqlList.add(assembleDelSql("market_id",delMap,"dms_yearplan_market_device"));
					//ɾ����̽�г�Ԥ�⼰�ֲ�������
					sqlList.add(assembleDelSql("market_id",delMap,"dms_yearplan_market"));
				}
				//������̽�г�Ԥ�⼰�ֲ�����ӣ��޸�sql
				if(((String)key).startsWith("market_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					Map marMap = new HashMap();
					//devMap.put("market_id", (String)map.get("market_id_"+indexStr));
					marMap.put("apply_id", (String)map.get("apply_id"));
					marMap.put("terr_phys_ftype", (String)map.get("terr_phys_ftype_"+indexStr));
					marMap.put("terr_phys_type", (String)map.get("terr_phys_type_"+indexStr));
					marMap.put("terr_phys_name", (String)map.get("terr_phys_name_"+indexStr));
					marMap.put("dev_sign_workload", (String)map.get("dev_sign_workload_"+indexStr));
					marMap.put("dev_value_workload", (String)map.get("dev_value_workload_"+indexStr));
					marMap.put("projet_start_time", (String)map.get("projet_start_time_"+indexStr));
					marMap.put("projet_end_time", (String)map.get("projet_end_time_"+indexStr));
					marMap.put("dev_income", (String)map.get("dev_income_"+indexStr));
					marMap.put("dev_profit", (String)map.get("dev_profit_"+indexStr));
					marMap.put("project_type", (String)map.get("project_type_"+indexStr));
					//�������ɵ�sql������Ϊ��ֵ����������޸�
					if(null==map.get("market_id_"+indexStr) || StringUtils.isBlank(map.get("market_id_"+indexStr).toString())){
						String muuid = UUID.randomUUID().toString().replaceAll("-", "");
						marMap.put("market_id", muuid);
						//������̽�г�Ԥ�⼰�ֲ�������
						sqlList.add(assembleInsertOrUpdateSql(marMap,"dms_yearplan_market",user.getUserId(),"add"));
						//�޸���̽�г�Ԥ�⼰�ֲ����豸���ݣ��޸���market_id,Ŀǰ�䱣��Ϊʱ���ֵ��
						String udSql=" update dms_yearplan_market_device set market_id='"+muuid+"' where market_id='"+indexStr+"'";
						sqlList.add(udSql);
					}else{
						//��ȡ����
						marMap.put("market_id", (String)map.get("market_id_"+indexStr));
						sqlList.add(assembleInsertOrUpdateSql(marMap,"dms_yearplan_market",user.getUserId(),"update"));
					}
				}
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//���������
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		responseDTO.setValue("applyId", applyId);
		responseDTO.setValue("applyYear", applyYear);
		//responseDTO.setValue("tabFlag", "0");//��ת����������tabҳ������ҳ�±�
		return responseDTO;
	}
	
	/**
	 * �������޸���̽�г�Ԥ�⼰�ֲ����豸��Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateMarketDeviceInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateMarketDeviceInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		//���Ҫ���棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		try {
			for (Object key : map.keySet()) {
				//�������Ҫɾ������̽�г�Ԥ�⼰�ֲ����豸��Ϣ��������ɾ��sql
				if(((String)key).startsWith("del_dev")){
					Map delMap = new HashMap();
					delMap.put("device_id", (String)map.get(key));
					sqlList.add(assembleDelSql("device_id",delMap,"dms_yearplan_market_device"));
				}
				//������̽�г�Ԥ�⼰�ֲ����豸��Ϣ��ӣ��޸�sql
				if(((String)key).startsWith("device_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					Map devMap = new HashMap();
					devMap.put("device_id", (String)map.get("device_id_"+indexStr));
					devMap.put("market_id", (String)map.get("market_id_"+indexStr));
					devMap.put("dev_ct_code", (String)map.get("dev_ct_code_"+indexStr));
					devMap.put("dev_model", (String)map.get("dev_model_"+indexStr));
					devMap.put("dev_num", (String)map.get("dev_num_"+indexStr));
					//�������ɵ�sql������Ϊ��ֵ����������޸�
					if(null==map.get("device_id_"+indexStr) || StringUtils.isBlank(map.get("device_id_"+indexStr).toString())){
						sqlList.add(assembleInsertOrUpdateSql(devMap,"dms_yearplan_market_device",user.getUserId(),"add"));
					}else{
						sqlList.add(assembleInsertOrUpdateSql(devMap,"dms_yearplan_market_device",user.getUserId(),"update"));
					}
				}
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//���������
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * �������޸��豸��״������
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateDeviceAnalInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateDeviceAnalInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		//���뵥id
		String applyId = map.get("apply_id").toString();
		//�������
		String applyYear =map.get("apply_year").toString();
		//���Ҫɾ�������棬�޸ĵ�sql
		List<String> sqlList = new ArrayList<String>();
		try {
			for (Object key : map.keySet()) {
				//�������Ҫɾ�����豸��״���������ݣ�������ɾ��sql
				if(((String)key).startsWith("del_devanal")){
					Map delMap = new HashMap();
					delMap.put("deviceanal_id", (String)map.get(key));
					//ɾ���豸��״����������
					sqlList.add(assembleDelSql("deviceanal_id",delMap,"dms_yearplan_deviceanal"));
				}
				//�����豸��״��������ӣ��޸�sql
				if(((String)key).startsWith("deviceanal_id")){
					int index=((String)key).lastIndexOf("_");
					String indexStr=((String)key).substring(index+1);
					Map devAnalMap = new HashMap();
					//�������ɵ�sql������Ϊ��ֵ����������޸�
					if(null==map.get("deviceanal_id_"+indexStr) || StringUtils.isBlank(map.get("deviceanal_id_"+indexStr).toString())){
						String muuid = UUID.randomUUID().toString().replaceAll("-", "");
						devAnalMap.put("deviceanal_id", muuid);
						devAnalMap.put("apply_id", (String)map.get("apply_id"));
						devAnalMap.put("dev_g_type", (String)map.get("dev_g_type_"+indexStr));
						devAnalMap.put("dev_g_name", (String)map.get("dev_g_name_"+indexStr));
						devAnalMap.put("dev_m_type", (String)map.get("dev_m_type_"+indexStr));
						devAnalMap.put("dev_m_name", (String)map.get("dev_m_name_"+indexStr));
						devAnalMap.put("dev_s_type", (String)map.get("dev_s_type_"+indexStr));
						devAnalMap.put("dev_s_name", (String)map.get("dev_s_name_"+indexStr));
						devAnalMap.put("dev_ls_type", (String)map.get("dev_ls_type_"+indexStr));
						devAnalMap.put("dev_ls_name", (String)map.get("dev_ls_name_"+indexStr));
						devAnalMap.put("dev_name", (String)map.get("dev_name_"+indexStr));
						devAnalMap.put("dev_model", (String)map.get("dev_model_"+indexStr));
						devAnalMap.put("dev_type", (String)map.get("dev_type_"+indexStr));
						devAnalMap.put("total_number", (String)map.get("total_number_"+indexStr));
						devAnalMap.put("tatal_orig_value", (String)map.get("tatal_orig_value_"+indexStr));
						devAnalMap.put("tatal_net_value", (String)map.get("tatal_net_value_"+indexStr));
						devAnalMap.put("f_s_number", (String)map.get("f_s_number_"+indexStr));
						devAnalMap.put("f_s_orig_value", (String)map.get("f_s_orig_value_"+indexStr));
						devAnalMap.put("f_s_net_value", (String)map.get("f_s_net_value_"+indexStr));
						devAnalMap.put("s_e_number", (String)map.get("s_e_number_"+indexStr));
						devAnalMap.put("s_e_orig_value", (String)map.get("s_e_orig_value_"+indexStr));
						devAnalMap.put("s_e_net_value", (String)map.get("s_e_net_value_"+indexStr));
						devAnalMap.put("e_more_number", (String)map.get("e_more_number_"+indexStr));
						devAnalMap.put("e_more_orig_value", (String)map.get("e_more_orig_value_"+indexStr));
						devAnalMap.put("e_more_net_value", (String)map.get("e_more_net_value_"+indexStr));
						//�����豸��״����������
						sqlList.add(assembleInsertOrUpdateSql(devAnalMap,"dms_yearplan_deviceanal",user.getUserId(),"add"));
					}
					/* else{ //���޸Ĳ���
						//��ȡ����
						devAnalMap.put("deviceanal_id", (String)map.get("deviceanal_id_"+indexStr));
						sqlList.add(assembleInsertOrUpdateSql(devAnalMap,"dms_yearplan_deviceanal",user.getUserId(),"update"));
					}*/
				}
			}
			if(CollectionUtils.isNotEmpty(sqlList)){
				String str[]=new String[sqlList.size()];
				String strings[]=sqlList.toArray(str);
				//���������
				jdbcTemplate.batchUpdate(strings);
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		responseDTO.setValue("applyId", applyId);
		responseDTO.setValue("applyYear", applyYear);
		//responseDTO.setValue("tabFlag", "1");//��ת����������tabҳ������ҳ�±�
		return responseDTO;
	}
	
	/**
	 * ������ĿͶ��Ч�����۱���Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateSuppDataFile(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateSuppDataFile");
		UserToken user = isrvmsg.getUserToken();
		Map map = isrvmsg.toMap();
		String operationFlag = "success";
		String applyId= isrvmsg.getValue("apply_id");//����id
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> files = mqMsg.getFiles();
		try {
			//��ʼorder_num
			int num=1;
			StringBuffer strBuf = new StringBuffer("select max(order_num) as num from bgp_doc_gms_file where  relation_id = '"+applyId+"' and bsflag='0'");
			Map map2 = jdbcDao.queryRecordBySQL(strBuf.toString());
			if (StringUtils.isNotBlank((String)map2.get("num"))) {
				num = Integer.parseInt((String)map2.get("num")) +1;
			}
			if(CollectionUtils.isNotEmpty(files)){
				//������
				for (WSFile file : files) {
					String filename = file.getFilename();
					String fileOrder = file.getKey().toString().split("__")[1];
					MyUcm ucm = new MyUcm();
					String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
					Map doc = new HashMap();
					doc.put("file_name", filename);
					String fileType = isrvmsg.getValue("doc_type__"+fileOrder);
					doc.put("file_type",fileType );
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", applyId);//����id
					doc.put("order_num", num);
					//���湫����Ϣ
					Date date = new Date();
					doc.put("bsflag", "0");
					doc.put("creator_id", user.getUserId());
					doc.put("create_date", date);
					doc.put("updator_id", user.getUserId());
					doc.put("modifi_date", date);
					jdbcDao.saveOrUpdateEntity(doc, "bgp_doc_gms_file");
					num++;
				}
			}
		} catch (Exception e) {
			operationFlag="failed";
			e.printStackTrace();
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		responseDTO.setValue("operationFlag", operationFlag);
		responseDTO.setValue("applyId", applyId);
		return responseDTO;
	}
	
	/**
	 * ��������˵������Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateRemarkInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateRemarkInfo");
		UserToken user = isrvmsg.getUserToken();
		Map map = isrvmsg.toMap();
		String operationFlag = "success";
		//����id
		String applyId= isrvmsg.getValue("apply_id");
		//�������
		String applyYear= isrvmsg.getValue("apply_year");
		//����˵����id
		String remarkId="";
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> files = mqMsg.getFiles();
		try {
			//��������˵��������
			remarkId = (String) jdbcDao.saveOrUpdateEntity(map, "dms_yearplan_remark");
			//��ʼorder_num
			int num=1;
			StringBuffer strBuf = new StringBuffer("select max(order_num) as num from bgp_doc_gms_file where  relation_id = '"+remarkId+"' and bsflag='0'");
			Map map2 = jdbcDao.queryRecordBySQL(strBuf.toString());
			if (StringUtils.isNotBlank((String)map2.get("num"))) {
				num = Integer.parseInt((String)map2.get("num")) +1;
			}
			if(CollectionUtils.isNotEmpty(files)){
				//������
				for (WSFile file : files) {
					String filename = file.getFilename();
					String fileOrder = file.getKey().toString().split("__")[1];
					MyUcm ucm = new MyUcm();
					String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
					Map doc = new HashMap();
					doc.put("file_name", filename);
					String fileType = isrvmsg.getValue("doc_type__"+fileOrder);
					doc.put("file_type",fileType );
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", remarkId);//����id
					doc.put("order_num", num);
					//���湫����Ϣ
					Date date = new Date();
					doc.put("bsflag", "0");
					doc.put("creator_id", user.getUserId());
					doc.put("create_date", date);
					doc.put("updator_id", user.getUserId());
					doc.put("modifi_date", date);
					jdbcDao.saveOrUpdateEntity(doc, "bgp_doc_gms_file");
					num++;
				}
			}
		} catch (Exception e) {
			operationFlag="failed";
			e.printStackTrace();
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		responseDTO.setValue("operationFlag", operationFlag);
		responseDTO.setValue("applyId", applyId);
		responseDTO.setValue("applyYear", applyYear);
		return responseDTO;
	}
	
	/**
	 * �������޸��豸�������ڴ�̯���ñ�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateConfigDevInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateConfigDevInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String flag=isrvmsg.getValue("flag");
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		try {
			if("add".equals(flag)){
				Integer orderNum=getOrderNum();
				map.put("order_num", orderNum);
			}
			ServiceUtils.setCommFields(map, "devname_config_id", user);
			jdbcDao.saveOrUpdateEntity(map, "dms_comm_devname_config");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ɾ����ȼƻ���Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteYearPlan(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteYearPlan");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String applyId = isrvmsg.getValue("applyId");
		try{
			//ɾ���ǰ�װ�豸Ͷ�ʽ���ƻ���
			String delSql0 = "delete from dms_yearplan_noninstall where apply_id='"+applyId+"'";
			jdbcDao.executeUpdate(delSql0);
			//ɾ�����ڴ�̯���ñ�
			String delSql1 = "delete from dms_yearplan_longterm where apply_id='"+applyId+"'";
			jdbcDao.executeUpdate(delSql1);
			//ɾ����̽�г�Ԥ�⼰�ֲ���-�豸��
			String delSql2 = "delete from dms_yearplan_market_device where market_id in ( "
					+ "select market_id from dms_yearplan_market where APPLY_ID='"
					+ applyId + "' )";
			jdbcDao.executeUpdate(delSql2);
			//ɾ����̽�г�Ԥ�⼰�ֲ���
			String delSql3 = "delete from dms_yearplan_market where apply_id='"+applyId+"'";
			jdbcDao.executeUpdate(delSql3);
			//ɾ���豸��״������
			String delSql4 = "delete from dms_yearplan_deviceanal where apply_id='"+applyId+"'";
			jdbcDao.executeUpdate(delSql4);
			//ɾ���ļ��������������
			String ids=applyId;
			//��ѯ����˵����id(������ɾ����Ӧ���ļ�����)
			String remarkSql = "select t.remark_id from dms_yearplan_remark t where t.apply_id='" + applyId +"'";
			Map remarkMap=jdbcDao.queryRecordBySQL(remarkSql);
			if(MapUtils.isNotEmpty(remarkMap)){
				if(StringUtils.isNotBlank(remarkMap.get("remark_id").toString())){
					ids+=","+remarkMap.get("remark_id").toString();
				}
			}
			String[] idStrings = ids.split(",");
			for(String id : idStrings){
				String theUcmId = "";
				String fileName = "";
				String updateSql = "";
				String updateVersion = "";
				String updateLog = "";
				List<Map> listucmIds = (List<Map>) jdbcDao.queryRecords("select df.file_id,df.file_name from bgp_doc_gms_file df where df.is_file = '1' and df.bsflag='0' and df.relation_id = '"+id+"'");					
				for(Map temp : listucmIds){
					String file_id=temp.get("file_id").toString();
					updateSql = "update bgp_doc_gms_file g set g.bsflag='1' where g.file_id='"+file_id+"'";
					updateVersion = "update bgp_doc_file_version g set g.bsflag='1' where g.file_id='"+file_id+"'";
					updateLog = "update bgp_doc_file_log g set g.bsflag='1' where g.file_id='"+file_id+"'";
					if(jdbcDao.executeUpdate(updateSql)>0){
						Map vmap=jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '0' and bfv.file_id= '"+file_id+"'");
						String fileVersion = "";
						if(MapUtils.isNotEmpty(vmap)){
							fileVersion = vmap.get("file_version").toString();	
						}
						System.out.println("delete, the fileVersion is:"+fileVersion);
						myUcm.docLog(file_id, fileVersion,4, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),fileName);
						jdbcDao.executeUpdate(updateVersion);
						jdbcDao.executeUpdate(updateLog);
					}
				}
			}
			//ɾ������˵����
			String delSql5 = "delete from dms_yearplan_remark where apply_id='"+applyId+"'";
			jdbcDao.executeUpdate(delSql5);
			//ɾ����ȼƻ���
			String dt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
			String sql = "update dms_yearplan_apply set bsflag='1',updator='"
					+ user.getUserId() + "',modify_date=to_date('" + dt
					+ "','yyyy-mm-dd hh24:mi:ss') where apply_id = '" + applyId
					+ "'";
			jdbcDao.executeUpdate(sql);
		}catch(Exception e){
			operationFlag = "failed";
		}
		return responseDTO;
	}
	
	/** 
	 * ɾ���ļ�
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteFile(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteFile");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);				
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String ids = isrvmsg.getValue("id");
		String[] idStrings = ids.split(",");
		try {
			for(String id : idStrings){
				String theUcmId = "";
				String fileName = "";
				String updateSql = "";
				String updateVersion = "";
				String updateLog = "";
				updateSql = "update bgp_doc_gms_file g set g.bsflag='1' where g.file_id='"+id+"'";
				updateVersion = "update bgp_doc_file_version g set g.bsflag='1' where g.file_id='"+id+"'";
				updateLog = "update bgp_doc_file_log g set g.bsflag='1' where g.file_id='"+id+"'";
				if(jdbcDao.executeUpdate(updateSql)>0){
					Map vmap=jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '0' and bfv.file_id= '"+id+"'");
					String fileVersion = "";
					if(MapUtils.isNotEmpty(vmap)){
						fileVersion = vmap.get("file_version").toString();	
					}
					System.out.println("delete, the fileVersion is:"+fileVersion);
					myUcm.docLog(id, fileVersion,4, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),fileName);
					jdbcDao.executeUpdate(updateVersion);
					jdbcDao.executeUpdate(updateLog);
				}
			}
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationflag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ɾ���豸�������ڴ�̯���ñ�
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteConfigDev(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteConfigDev");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String id = isrvmsg.getValue("id");
		try{
			//ɾ���豸�������ڴ�̯���ñ�
			String dt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
			String sql = "update dms_comm_devname_config set bsflag='1',updator='"
					+ user.getUserId() + "',modify_date=to_date('" + dt
					+ "','yyyy-mm-dd hh24:mi:ss') where devname_config_id = '" + id
					+ "'";
			jdbcDao.executeUpdate(sql);
		}catch(Exception e){
			operationFlag = "failed";
		}
		return responseDTO;
	}
	
	/**
	 * ���ɸ��»����sql���
	 * @param data
	 * @param tableName
	 * @param userId
	 * @param flag
	 * @return
	 */
	public String assembleInsertOrUpdateSql(Map data,String tableName,String userId,String flag){
		StringBuffer sqlString =new StringBuffer();
		//�ǰ�װ�豸Ͷ�ʽ���ƻ���
		if(tableName.equals("dms_yearplan_noninstall")){
			if ("update".equals(flag)) {// ����
				sqlString.append("update dms_yearplan_noninstall set " );
				sqlString.append(appendUpdateSql(data.get("dev_name"),"varchar","dev_name",false));
				sqlString.append(appendUpdateSql(data.get("purchase_property"),"varchar","purchase_property",false));
				sqlString.append(appendUpdateSql(data.get("dev_model"),"varchar","dev_model",false));
				sqlString.append(appendUpdateSql(data.get("purchase_num"),"number","purchase_num",false));
				sqlString.append(appendUpdateSql(data.get("order_time"),"date","order_time",false));
				sqlString.append(appendUpdateSql(data.get("arrival_time"),"date","arrival_time",false));
				sqlString.append(appendUpdateSql(data.get("total_invest"),"number","total_invest",false));
				sqlString.append(appendUpdateSql(data.get("current_year_plan"),"varchar","current_year_plan",false));
				sqlString.append(appendUpdateSql(data.get("remark"),"varchar","remark",true));
				sqlString.append(" where noninstall_id='"+data.get("noninstall_id")+ "'");
			} else {// ����
				String uuid = UUID.randomUUID().toString().replaceAll("-", "");
				sqlString.append("insert into dms_yearplan_noninstall (noninstall_id,apply_id,dev_name,purchase_property,dev_model,purchase_num,order_time,arrival_time,total_invest,current_year_plan,remark) values "
						+ "('"+ uuid+ "','"+ (String) data.get("apply_id")+ "',");
				sqlString.append(appendAddSql(data.get("dev_name"),"varchar",false));
				sqlString.append(appendAddSql(data.get("purchase_property"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_model"),"varchar",false));
				sqlString.append(appendAddSql(data.get("purchase_num"),"number",false));
				sqlString.append(appendAddSql(data.get("order_time"),"date",false));
				sqlString.append(appendAddSql(data.get("arrival_time"),"date",false));
				sqlString.append(appendAddSql(data.get("total_invest"),"number",false));
				sqlString.append(appendAddSql(data.get("current_year_plan"),"varchar",false));
				sqlString.append(appendAddSql(data.get("remark"),"varchar",true));
				sqlString.append(")");	
			}
		}
		//���ڴ�̯���ñ�
		if(tableName.equals("dms_yearplan_longterm")){
			if ("update".equals(flag)) {// ����
				sqlString.append("update dms_yearplan_longterm set " );
				sqlString.append(appendUpdateSql(data.get("dev_name"),"varchar","dev_name",false));
				sqlString.append(appendUpdateSql(data.get("last_year_num"),"number","last_year_num",false));
				sqlString.append(appendUpdateSql(data.get("last_year_money"),"number","last_year_money",false));
				sqlString.append(appendUpdateSql(data.get("this_year_num"),"number","this_year_num",false));
				sqlString.append(appendUpdateSql(data.get("this_year_money"),"number","this_year_money",false));
				sqlString.append(appendUpdateSql(data.get("next_year_num"),"number","next_year_num",false));
				sqlString.append(appendUpdateSql(data.get("next_year_money"),"number","next_year_money",false));
				sqlString.append(appendUpdateSql(data.get("remark"),"varchar","remark",true));
				sqlString.append(" where longtermp_id='"+data.get("longtermp_id")+ "'");
			} else {// ����
				String uuid = UUID.randomUUID().toString().replaceAll("-", "");
				sqlString.append("insert into dms_yearplan_longterm (longtermp_id,apply_id,dev_name,last_year_num,last_year_money,this_year_num,this_year_money,next_year_num,next_year_money,remark) values "
						+ "('"+ uuid+ "','"+ (String) data.get("apply_id")+ "'," );
				sqlString.append(appendAddSql(data.get("dev_name"),"varchar",false));
				sqlString.append(appendAddSql(data.get("last_year_num"),"number",false));
				sqlString.append(appendAddSql(data.get("last_year_money"),"number",false));
				sqlString.append(appendAddSql(data.get("this_year_num"),"number",false));
				sqlString.append(appendAddSql(data.get("this_year_money"),"number",false));
				sqlString.append(appendAddSql(data.get("next_year_num"),"number",false));
				sqlString.append(appendAddSql(data.get("next_year_money"),"number",false));
				sqlString.append(appendAddSql(data.get("remark"),"varchar",true));
				sqlString.append(")");	
			}
		}
		//��̽�г�Ԥ�⼰�ֲ���
		if(tableName.equals("dms_yearplan_market")){
			if ("update".equals(flag)) {// ����
				sqlString.append("update dms_yearplan_market set " );
				sqlString.append(appendUpdateSql(data.get("terr_phys_ftype"),"varchar","terr_phys_ftype",false));
				sqlString.append(appendUpdateSql(data.get("terr_phys_type"),"varchar","terr_phys_type",false));
				sqlString.append(appendUpdateSql(data.get("terr_phys_name"),"varchar","terr_phys_name",false));
				sqlString.append(appendUpdateSql(data.get("dev_sign_workload"),"number","dev_sign_workload",false));
				sqlString.append(appendUpdateSql(data.get("dev_value_workload"),"number","dev_value_workload",false));
				sqlString.append(appendUpdateSql(data.get("projet_start_time"),"date","projet_start_time",false));
				sqlString.append(appendUpdateSql(data.get("projet_end_time"),"date","projet_end_time",false));
				sqlString.append(appendUpdateSql(data.get("dev_income"),"number","dev_income",false));
				sqlString.append(appendUpdateSql(data.get("dev_profit"),"number","dev_profit",false));
				sqlString.append(appendUpdateSql(data.get("project_type"),"varchar","project_type",true));
				sqlString.append(" where market_id='"+data.get("market_id")+ "'");
			} else {// ����
				sqlString.append("insert into dms_yearplan_market (market_id,apply_id,terr_phys_ftype,terr_phys_type,terr_phys_name,dev_sign_workload,dev_value_workload,projet_start_time,projet_end_time,dev_income,dev_profit,project_type) values (");
				sqlString.append(appendAddSql(data.get("market_id"),"varchar",false));
				sqlString.append(appendAddSql(data.get("apply_id"),"varchar",false));
				sqlString.append(appendAddSql(data.get("terr_phys_ftype"),"varchar",false));
				sqlString.append(appendAddSql(data.get("terr_phys_type"),"varchar",false));
				sqlString.append(appendAddSql(data.get("terr_phys_name"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_sign_workload"),"number",false));
				sqlString.append(appendAddSql(data.get("dev_value_workload"),"number",false));
				sqlString.append(appendAddSql(data.get("projet_start_time"),"date",false));
				sqlString.append(appendAddSql(data.get("projet_end_time"),"date",false));
				sqlString.append(appendAddSql(data.get("dev_income"),"number",false));
				sqlString.append(appendAddSql(data.get("dev_profit"),"number",false));
				sqlString.append(appendAddSql(data.get("project_type"),"varchar",true));
				sqlString.append(")");	
			}
		}
		//��̽�г�Ԥ�⼰�ֲ����豸��Ϣ
		if(tableName.equals("dms_yearplan_market_device")){
			if ("update".equals(flag)) {// ����
				sqlString.append("update dms_yearplan_market_device set " );
				sqlString.append(appendUpdateSql(data.get("dev_ct_code"),"varchar","dev_ct_code",false));
				sqlString.append(appendUpdateSql(data.get("dev_model"),"varchar","dev_model",false));
				sqlString.append(appendUpdateSql(data.get("dev_num"),"number","dev_num",true));
				sqlString.append(" where device_id='"+data.get("device_id")+ "'");
			} else {// ����
				String uuid = UUID.randomUUID().toString().replaceAll("-", "");
				sqlString.append("insert into dms_yearplan_market_device (device_id,market_id,dev_ct_code,dev_model,dev_num) values "
						+ "('"+ uuid+ "'," );
				sqlString.append(appendAddSql(data.get("market_id"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_ct_code"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_model"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_num"),"number",true));
				sqlString.append(")");	
			}
		}
		//�豸��״������
		if(tableName.equals("dms_yearplan_deviceanal")){
			if ("update".equals(flag)) {// ����
				sqlString.append("update dms_yearplan_deviceanal set " );
				sqlString.append(appendUpdateSql(data.get("dev_g_type"),"varchar","dev_g_type",false));
				sqlString.append(appendUpdateSql(data.get("dev_g_name"),"varchar","dev_g_name",false));
				sqlString.append(appendUpdateSql(data.get("dev_m_type"),"varchar","dev_m_type",false));
				sqlString.append(appendUpdateSql(data.get("dev_m_name"),"varchar","dev_m_name",false));
				sqlString.append(appendUpdateSql(data.get("dev_s_type"),"varchar","dev_s_type",false));
				sqlString.append(appendUpdateSql(data.get("dev_s_name"),"varchar","dev_s_name",false));
				sqlString.append(appendUpdateSql(data.get("dev_ls_type"),"varchar","dev_ls_type",false));
				sqlString.append(appendUpdateSql(data.get("dev_ls_name"),"varchar","dev_ls_name",false));
				sqlString.append(appendUpdateSql(data.get("dev_name"),"varchar","dev_name",false));
				sqlString.append(appendUpdateSql(data.get("dev_model"),"varchar","dev_model",false));
				sqlString.append(appendUpdateSql(data.get("dev_type"),"varchar","dev_type",false));
				sqlString.append(appendUpdateSql(data.get("total_number"),"number","total_number",false));
				sqlString.append(appendUpdateSql(data.get("tatal_orig_value"),"number","tatal_orig_value",false));
				sqlString.append(appendUpdateSql(data.get("tatal_net_value"),"number","tatal_net_value",false));
				sqlString.append(appendUpdateSql(data.get("f_s_number"),"number","f_s_number",false));
				sqlString.append(appendUpdateSql(data.get("f_s_orig_value"),"number","f_s_orig_value",false));
				sqlString.append(appendUpdateSql(data.get("f_s_net_value"),"number","f_s_net_value",false));
				sqlString.append(appendUpdateSql(data.get("s_e_number"),"number","s_e_number",false));
				sqlString.append(appendUpdateSql(data.get("s_e_orig_value"),"number","s_e_orig_value",false));
				sqlString.append(appendUpdateSql(data.get("s_e_net_value"),"number","s_e_net_value",false));
				sqlString.append(appendUpdateSql(data.get("e_more_number"),"number","e_more_number",false));
				sqlString.append(appendUpdateSql(data.get("e_more_orig_value"),"number","e_more_orig_value",false));
				sqlString.append(appendUpdateSql(data.get("e_more_net_value"),"number","e_more_net_value",true));
				sqlString.append(" where deviceanal_id='"+data.get("deviceanal_id")+ "'");
			} else {// ����
				sqlString.append("insert into dms_yearplan_deviceanal (deviceanal_id,apply_id,dev_g_type,dev_g_name,dev_m_type,dev_m_name,dev_s_type,dev_s_name,dev_ls_type,dev_ls_name,dev_name,dev_model,dev_type," +
						"total_number,tatal_orig_value,tatal_net_value,f_s_number,f_s_orig_value,f_s_net_value,s_e_number,s_e_orig_value,s_e_net_value,e_more_number,e_more_orig_value,e_more_net_value) values (");
				sqlString.append(appendAddSql(data.get("deviceanal_id"),"varchar",false));
				sqlString.append(appendAddSql(data.get("apply_id"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_g_type"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_g_name"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_m_type"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_m_name"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_s_type"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_s_name"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_ls_type"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_ls_name"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_name"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_model"),"varchar",false));
				sqlString.append(appendAddSql(data.get("dev_type"),"varchar",false));
				sqlString.append(appendAddSql(data.get("total_number"),"number",false));
				sqlString.append(appendAddSql(data.get("tatal_orig_value"),"number",false));
				sqlString.append(appendAddSql(data.get("tatal_net_value"),"number",false));
				sqlString.append(appendAddSql(data.get("f_s_number"),"number",false));
				sqlString.append(appendAddSql(data.get("f_s_orig_value"),"number",false));
				sqlString.append(appendAddSql(data.get("f_s_net_value"),"number",false));
				sqlString.append(appendAddSql(data.get("s_e_number"),"number",false));
				sqlString.append(appendAddSql(data.get("s_e_orig_value"),"number",false));
				sqlString.append(appendAddSql(data.get("s_e_net_value"),"number",false));
				sqlString.append(appendAddSql(data.get("e_more_number"),"number",false));
				sqlString.append(appendAddSql(data.get("e_more_orig_value"),"number",false));
				sqlString.append(appendAddSql(data.get("e_more_net_value"),"number",true));
				sqlString.append(")");	
			}
		}
		return sqlString.toString();
	}
	
	/**
	 * ͨ���д�ֵ�����͡�����б�־��ƴ�����sql
	 * @param columnValue
	 * @param columnType
	 * @param isLastColumn
	 * @return
	 */
	public String appendAddSql(Object columnValue,String columnType,boolean isLastColumn){
		String sql="";
		if(null==columnValue || StringUtils.isBlank(columnValue.toString())){
			sql="null,";
		}else{
			if("varchar".equals(columnType)){
				sql="'"+columnValue.toString()+"',";
			}
			if("number".equals(columnType)){
				sql=columnValue.toString()+",";
			}
			if("date".equals(columnType)){
				sql="to_date('"+columnValue.toString()+"','yyyy-mm-dd'),";
			}
		}
		if(isLastColumn){
			sql=sql.substring(0, sql.lastIndexOf(","));
		}
		return sql;
	}
	
	/**
	 * ͨ����ֵ�����͡����ơ�����б�־��ƴ���޸�sql
	 * @param columnValue
	 * @param columnType
	 * @param columnName
	 * @param isLastColumn
	 * @return
	 */
	public String appendUpdateSql(Object columnValue,String columnType,String columnName,boolean isLastColumn){
		String sql="";
		if(null==columnValue || StringUtils.isBlank(columnValue.toString())){
			sql=columnName+"=null,";
		}else{
			if("varchar".equals(columnType)){
				sql=columnName+"='"+columnValue.toString()+"',";
			}
			if("number".equals(columnType)){
				sql=columnName+"="+columnValue.toString()+",";
			}
			if("date".equals(columnType)){
				sql=columnName+"=to_date('"+columnValue.toString()+"','yyyy-mm-dd'),";
			}
		}
		if(isLastColumn){
			sql=sql.substring(0, sql.lastIndexOf(","));
		}
		return sql;
	}
	
	/**
	 *  ����ɾ��sql���
	 * @param pkName
	 * @param data
	 * @param tableName
	 * @return
	 */
	public String assembleDelSql(String pkName,Map data,String tableName){
		String tempSql="";
		tempSql="delete from "+tableName+" where "+pkName+"='"+data.get(pkName).toString()+"'";
		return tempSql;
	}
	
	/**
	 * ��ȡ���뵥��
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public String getApplyNum() throws Exception {
		Date d=new Date(); 
		SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd"); 
		String today = df.format(d); 
		//��ѯ�������뵥����
		String queryRescource = "select count(*) as num from dms_yearplan_apply t where t.create_date>=to_date('"+today+"','yyyy-mm-dd') and t.bsflag='0'";
		Map map=jdbcDao.queryRecordBySQL(queryRescource);
		//���뵥��
		String strNo = "���Ͷ�ʽ���ƻ�"+today.replace("-", "");
		int num=0;
		if(MapUtils.isNotEmpty(map)){
			if(StringUtils.isNotEmpty(map.get("num").toString())){
				 num= Integer.parseInt(map.get("num").toString());
			}
		}
		num++;
		if(num<10){
			strNo += "0"+num;
		}else {
			strNo += num;
		}
		return strNo;
	}
	
	/**
	 * ��ȡ�����豸��ź�
	 * @return
	 * @throws Exception
	 */
	public Integer getOrderNum() throws Exception {
		//��ѯ������
		String queryRescource = "select nvl(max(t.order_num),0) as num from dms_comm_devname_config t where t.bsflag='0'";
		Map map=jdbcDao.queryRecordBySQL(queryRescource);
		//���뵥��
		int num=0;
		if(MapUtils.isNotEmpty(map)){
			if(StringUtils.isNotEmpty(map.get("num").toString())){
				 num= Integer.parseInt(map.get("num").toString())+1;
			}
		}
		return num;
	}
}
