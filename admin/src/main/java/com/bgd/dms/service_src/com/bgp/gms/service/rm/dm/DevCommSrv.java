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
 * creator time:2015-8-28
 * 
 * description:�豸���ά������
 * 
 */
@Service("DevCommSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class DevCommSrv extends BaseService{
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private IWtcDevSrv wtcDevSrv = new WtcPubDevSrv();
	
	/**
	 * �����豸�ճ����ͳ����ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRiChangjcDs(ISrvMsg msg) throws Exception {
		log.info("queryRiChangjcDs");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		String dev_acc_id=msg.getValue("dev_acc_id");
		String start_date=msg.getValue("startdate");
		String end_date=msg.getValue("enddate");
		String sql=" select t.* from(select c.check_id, decode(c.actual_out_date, null, c.create_date, actual_out_date) actual_out_date, decode(c.checkperson, null, (select u.user_name from p_auth_user u where u.user_id = c.creator), c.checkperson) checkperson, data_from from GMS_DEVICE_CHECK c where c.dev_acc_id = '"+dev_acc_id+"' and c.create_date between to_date('"+start_date+"','yyyy-MM-dd') and to_date('"+end_date+"','yyyy-MM-dd')) t order by actual_out_date desc ";
		 
		List<Map> indiList = jdbcDao.queryRecords(sql);
		 
		responseDTO.setValue("datas", indiList);
		responseDTO.setValue("totalRows", indiList.size());
		return responseDTO;
	}
	/**
	 * �����豸�ճ����ͳ����ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRiChangjcDList(ISrvMsg msg) throws Exception {
		log.info("queryRiChangjcDList");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		String sub_id=msg.getValue("wtcsubid");
		String type=msg.getValue("type");
		String start_date=msg.getValue("startdate");
		String end_date=msg.getValue("enddate");
		String sql="select s.dev_acc_id,s.dev_name,s.dev_coding,s.dev_sign,s.dev_num,count(c.check_id) counts from gms_device_account_s s, gms_device_check c where s.dev_acc_id = c.dev_acc_id and s.dev_type like '"+type+"%' and c.create_date between to_date('"+start_date+"','yyyy-MM-dd') and to_date('"+end_date+"','yyyy-MM-dd') and s.owning_sub_id like '"+sub_id+"%' group by s.dev_acc_id,s.dev_name,s.dev_coding,s.dev_sign,s.dev_num ";
		if(StringUtils.isNotBlank(sortField)){
			sql+=" order by "+sortField+" "+sortOrder+" ";
		}else{
			sql+=" order by counts";
		}

		List<Map> indiList = jdbcDao.queryRecords(sql);
		 
		responseDTO.setValue("datas", indiList);
		responseDTO.setValue("totalRows", indiList.size());
		return responseDTO;
	}
	/**
	 * �����豸�ճ����ͳ��
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryRiChangjcList(ISrvMsg msg) throws Exception {
		log.info("queryRiChangjcList");
		UserToken user = msg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String currentPage = msg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		PageModel page = new PageModel();
		String pageSize = msg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		String sub_id=msg.getValue("sub_id");
		String start_date=msg.getValue("start_date");
		String end_date=msg.getValue("end_date");
		StringBuffer queryIndiSql = new StringBuffer();
		queryIndiSql.append("select orgsubidtoname(s.owning_sub_id) org_name,OrgSubIdToshortid(s.owning_sub_id) sub_id, sum(CASE WHEN s.dev_type like 'S1507%' THEN 1 ELSE 0 END) dt, sum(CASE WHEN s.dev_type like 'S07010201%' THEN 1 ELSE 0 END) dc, sum(CASE WHEN s.dev_type like 'S080601%' THEN 1 ELSE 0 END) cc from gms_device_account_s s, gms_device_check c where s.dev_acc_id = c.dev_acc_id "  );
		queryIndiSql.append(" and  c.CREATE_DATE between to_date('"+start_date+"','yyyy-MM-dd') and to_date('"+end_date+"','yyyy-MM-dd')");		
		queryIndiSql.append("  group by orgsubidtoname(s.owning_sub_id),OrgSubIdToshortid(s.owning_sub_id)   ");
		if(StringUtils.isNotBlank(sortField)){
			queryIndiSql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			queryIndiSql.append(" order by org_name");
		}

		List<Map> indiList = jdbcDao.queryRecords(queryIndiSql.toString());
		 
		responseDTO.setValue("datas", indiList);
		responseDTO.setValue("totalRows", indiList.size());
		return responseDTO;
	}
	/**
	 * ��ȡ���� �豸�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIdleKDevList(ISrvMsg isrvmsg) throws Exception {
		log.info("getIdleKDevList");
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
		 
		//λ��
		 String postion_id = isrvmsg.getValue("postion_id");
		 if (StringUtils.isBlank(postion_id)) {
			 postion_id = "";
		 }
		// �ʲ�״̬
		 String account_stat = isrvmsg.getValue("account_stat");
		 if (StringUtils.isBlank(account_stat)) {
			 account_stat = "";
		 }// ��̽��
		String wutanorg = isrvmsg.getValue("wutanorg");
		if (StringUtils.isBlank(wutanorg)) {
			wutanorg = "";
		}
		// ������
		String parentCode = isrvmsg.getValue("parentCode");
		if (StringUtils.isBlank(parentCode)) {
			parentCode = "";
		}
		// ͳ�����
		String analType = isrvmsg.getValue("analType");
		if (StringUtils.isBlank(analType)) {
			analType = "";
		}
		// ���ڹ���
		String ifCountry = isrvmsg.getValue("ifCountry");
		String country = "";
		if (StringUtils.isBlank(ifCountry)) {
			country = "";
		} else {
			if ("in".equals(ifCountry)) {
				country = "����";
			}
			if ("out".equals(ifCountry)) {
				country = "����";
			}
		}
		
		String sql="  select acc.* from gms_device_account acc "
        +"  left join dms_device_tree dt "
        +"    on dt.device_code = acc.dev_type"
        +"  where acc.using_stat = '0110000007000000002'"
        +"    and acc.account_stat like '"+account_stat+"%'"
       +"     and dt.dev_tree_id like '"+parentCode+"%'"
        +"    and acc.owning_sub_id like '"+wutanorg+"%'"
        +"    and acc.ifcountry = '"+country+"'"
         +"   and acc.position_id like '"+postion_id+"%' "
         +"   and acc.bsflag = '0'";
		
		page = pureDao.queryRecordsBySQL(sql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * ��ѯ��Ҫ�رյ��ݵ�δ���յ��豸
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCloseDevInfo(ISrvMsg msg) throws Exception {
		log.info("getCloseDevInfo");
		String devMixId = msg.getValue("devmixid");
		// ��ǰ��¼�û���ID
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		
		StringBuffer sb = new StringBuffer()
					.append("select da.dev_acc_id from gms_device_mixinfo_form dm ")
					.append("join gms_device_appmix_main dam on dm.device_mixinfo_id = dam.device_mixinfo_id ")
					.append("join gms_device_appmix_detail dad on dam.device_mix_subid = dad.device_mix_subid ")
					.append("join gms_device_account da on dad.dev_acc_id = da.dev_acc_id  ")
					.append("where dm.device_mixinfo_id = '"+devMixId+"' and dm.bsflag = '0' and (dad.state is null or dad.state != '1') ")
					.append("union ")
					.append("select da.dev_acc_id from gms_device_mixinfo_form dm ")
					.append("join gms_device_appmix_detail dad on dad.device_mix_subid = dm.device_mixinfo_id ")
					.append("join gms_device_account da on dad.dev_acc_id = da.dev_acc_id ")
					.append("where dm.device_mixinfo_id = '"+devMixId+"' and dm.bsflag = '0' and (dad.state is null or dad.state != '1')");
		
		List<Map> devInfoList = jdbcDao.queryRecords(sb.toString());
		if(CollectionUtils.isNotEmpty(devInfoList)){
			for (Map devMap : devInfoList) {
				String upSql = "update gms_device_account set saveflag='0',usage_org_id='',"
					+ " usage_sub_id='',modifi_date=to_date('"+DevUtil.getCurrentTime()+"','yyyy-mm-dd hh24:mi:ss'),"
					+ " modifier='"+employee_id+"',using_stat='"+DevConstants.DEV_USING_XIANZHI+"',"
					+ " check_time=to_date('"+DevUtil.getCurrentDate()+"','yyyy-mm-dd') "
					+ " where dev_acc_id='"+devMap.get("dev_acc_id")+"' ";
				jdbcDao.executeUpdate(upSql);
			}
			jdbcDao.executeUpdate("update gms_device_mixinfo_form set opr_state='4',modifi_date=to_date('"+DevUtil.getCurrentTime()+"','yyyy-mm-dd hh24:mi:ss'),"
								+ "updator_id='"+employee_id+"' where device_mixinfo_id = '"+devMixId+"' ");
		}
		return responseMsg;
	}

	/**
	 * NEWMETHOD ���汨ͣ�ƻ���ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevOSAppInfosForProcwfpg(ISrvMsg msg) throws Exception {
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		return responseMsg;
	}
	/**
	 * NEWMETHOD ���汨ͣ�ƻ����뵥��Ϣ(��̽���е��豸)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOsAppDetailInfo(ISrvMsg msg) throws Exception {
		// 1.��û�����Ϣ
		String project_info_no = msg.getValue("project_info_no");
		// 2.�û���ʱ����Ϣ
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		String state = msg.getValue("state");
		// -- �ȱ��������
		Map<String, Object> mainMap = new HashMap<String, Object>();
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("osapp_org_id", user.getOrgId());
		mainMap.put("osapp_name", msg.getValue("osapp_name"));
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("os_employee_id", employee_id);
		mainMap.put("osappdate", DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd"));
		mainMap.put("state", state);
		mainMap.put("create_date", currentdate);
		mainMap.put("creator_id", employee_id);
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updator_id", employee_id);
		mainMap.put("org_id", user.getOrgId());
		mainMap.put("org_subjection_id", user.getOrgSubjectionId());
		if ("".equals(msg.getValue("device_osapp_no"))) {
			mainMap.put("device_osapp_no", DevUtil.getOSAppInfoNo());
		}
		// ����Ѿ�����id����ô�������map�У�ʵ���޸Ĺ���
		Serializable mainid = null;
		String deviceosappid = msg.getValue("deviceosappid");
		if (deviceosappid != null && !"".equals(deviceosappid)) {
			mainMap.put("device_osapp_id", deviceosappid);
			mainid = deviceosappid;
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_osapp");
		} else {
			// ������mainid��Ϣ
			mainid = jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_osapp");
		}
		// 3.1 ���ڴ�����ϸ��Ϣ�Ķ�ȡ(��̨)
		int count = Integer.parseInt(msg.getValue("count"));
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		String[] idinfos = msg.getValue("idinfos").split("~", -1);
		// �ȸ��ӱ�Ķ�ɾ�ˣ���ȫ������
		jdbcDao.executeUpdate("delete from gms_device_osapp_detail where device_osapp_id='"
				+ mainid + "' ");
		for (int i = 0; i < count; i++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[i];
			String dev_acc_id = idinfos[i];
			dataMap.put("dev_acc_id", dev_acc_id);
			// ��ѯ������Ϣ
			Map<String, Object> tempMap = jdbcDao
					.queryRecordBySQL("select dev_name,dev_model,actual_in_time as act_in_time,dev_unit,out_org_id,asset_coding as dev_coding,self_num,dev_sign,license_num from gms_device_account_dui dui where dui.dev_acc_id='"
							+ dev_acc_id + "'");
			dataMap.putAll(tempMap);
			// ����
			int osnum = 1;
			dataMap.put("osnum", osnum);
			// ��ͣԭ��
			String reason = msg.getValue("reason" + keyid);
			dataMap.put("reason", reason);
			// �ƻ���ͣʱ��
			String startdate = msg.getValue("startdate" + keyid);
			dataMap.put("start_date", startdate);
			// �ƻ�����ʱ��
			String enddate = msg.getValue("enddate" + keyid);
			dataMap.put("plan_end_date", enddate);
			// �ɼ����
			dataMap.put("devtype", DevConstants.OS_DANTAI);
			// �����ID
			dataMap.put("device_osapp_id", mainid);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_osapp_detail");
		}
		// 3.2 ���ڴ�����ϸ��Ϣ�Ķ�ȡ(XX��)
		int collcount = Integer.parseInt(msg.getValue("collcount"));
		String[] collidinfos = msg.getValue("collidinfos").split("~", -1);
		for (int i = 0; i < collcount; i++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = collidinfos[i];

			Map<String, Object> tempMap = jdbcDao
					.queryRecordBySQL("select dev_acc_id, dev_name,dev_model, unuse_num from gms_device_coll_account_dui dui where dui.dev_acc_id='"
							+ keyid + "'");
			dataMap.putAll(tempMap);

			// ����
			int osnum = 1;
			dataMap.put("osnum", msg.getValue("collneednum" + i));
			// ��ͣԭ��
			String reason = msg.getValue("collreason" + i);
			dataMap.put("reason", reason);
			// �ƻ���ͣʱ��
			String startdate = msg.getValue("collstartdate" + i);
			dataMap.put("start_date", startdate);
			// �ƻ�����ʱ��
			String enddate = msg.getValue("collenddate" + i);
			dataMap.put("plan_end_date", enddate);
			// �ɼ����� �����
			// dataMap.put("dev_name", msg.getValue("colldevicetype"+i));
			// �ɼ����
			dataMap.put("devtype", DevConstants.OS_PILIANG);
			// ������λ
			dataMap.put("out_org_id", msg.getValue("collorgid" + i));
			// �����ID
			dataMap.put("device_osapp_id", mainid);
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_osapp_detail");
		}

		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}
	/**
	 * NEWMETHOD �����ƻ����õ����������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDuiAccValidInfo(ISrvMsg msg) throws Exception {
		String dev_acc_id = msg.getValue("dev_acc_id");
		String restartdate = msg.getValue("restartdate");
		jdbcDao.executeUpdate("update gms_device_account_dui set using_stat='0110000007000000001',"
				+ "restart_date=to_date('"+restartdate+"','yyyy-mm-dd') where dev_acc_id='" + dev_acc_id + "'");
		// ���������һ���豸ͣ�õĻ����� ����������ʵ������ʱ������Ϊ����
		Map<String, Object> dataMap = jdbcDao
				.queryRecordBySQL("select device_osdet_id from (select row_number() over(partition by osp.dev_acc_id"
						+ " order by osp.start_date desc) rn,osp.device_osdet_id from gms_device_osapp_detail osp"
						+ " where osp.dev_acc_id='"+dev_acc_id+"' and osp.act_end_date is null) where rn = 1");
		Object device_osdet_id = dataMap.get("device_osdet_id");
		jdbcDao.executeUpdate("update gms_device_osapp_detail set act_end_date=to_date('"
				+ restartdate
				+ "','yyyy-mm-dd') where device_osdet_id='"
				+ device_osdet_id + "'");
		// 7.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����豸������λ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryUnitCode(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String sql = "select sd.coding_code_id,coding_name from comm_coding_sort_detail sd"
					+ " where sd.bsflag = '0' and sd.coding_sort_id ='5110000038'"
					+ " order by (case coding_name when '̨' then 'A' when '��' then 'B'"
					+ " when '��' then 'C' when '��' then 'D' when '��' then 'E' end)";
		List<Map> unitList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", unitList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��õ�������ģ����Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCollModel(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String sql = "select model_mainid,model_name from gms_device_collmodel_main main where main.bsflag = '0' ";
		List<Map> modelList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", modelList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��õ�������ģ������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCollModelDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//ģ��ID
		String modelId = msg.getValue("modelid");
		String sql = "select sub.device_id,sub.device_name,sub.device_model,sub.unit_id,"
				   + " detail.coding_name as unit_name,sub.device_slot_num from gms_device_collmodel_sub sub"
				   + " left join gms_device_collmodel_main main on main.model_mainid=sub.model_mainid"
				   + " left join comm_coding_sort_detail detail on sub.unit_id=detail.coding_code_id and detail.bsflag='0'"
				   + " where main.bsflag='0' and sub.model_mainid = '"+modelId+"'"
				   + " order by (case sub.device_name when '��Դվ' then 'A' when '�ɼ�վ' then 'B'"
				   + " when '����վ' then 'C' when '������' then 'D' when '���е���' then 'E' end)";
		List<Map> modelDetList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", modelDetList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ʹ��ģ�嵥����ӵ�������ʱȡ��������������λ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCollDetInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//��������������ID
		String deviceId = msg.getValue("deviceid");
		String sql = "select nvl(dev_slot_num,0) as device_slot_num from gms_device_collectinfo info"
			       + " where info.device_id = '"+deviceId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ������ĿprojectType��ð���
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryProjectTeam(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		List<Map> unitList = null;
		//��Ŀ���
		String projectInfoNo = msg.getValue("projectInfoNo");
		String projectType = msg.getValue("project_type");
		if(!DevUtil.isValueNotNull(projectType)){
			projectType = "5000100004000000001";//Ĭ��Ϊ½����Ŀ����(����������Ŀ����Ŀ����,Ĭ��½����Ŀ)
		}
		String sql = "select t.coding_code_id as value,t.coding_name as label"
			       + " from comm_coding_sort_detail t"
				   + " where t.coding_sort_id = '0110000001' and t.bsflag = '0'"
				   + " and t.spare1 = '0' and length(t.coding_code) = '2' ";			
		if(!"5000100004000000009".equals(projectType) 
				&& !"5000100004000000006".equals(projectType)){
			//�������Ŀ���ۺ��ﻯ̽��Ŀ���Ͱ��鶼ʹ��½����Ŀ����
			sql += "and t.coding_mnemonic_id = '5000100004000000001' ";
		}else{
			sql += "and t.coding_mnemonic_id = '"+projectType+"' ";
				
		}
		unitList = jdbcDao.queryRecords(sql);		
		responseDTO.setValue("datas", unitList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ���ش����̽���ĳ��ⵥλ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDgOutOrg(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		List<Map> unitList = null;
		String sql = "select org_id as value, org_abbreviation as label"
				   + " from comm_org_information"
				   + " where (org_id = 'C6000000000039' or org_id = 'C6000000000040'"
				   + " or org_id = 'C6000000005279' or org_id = 'C6000000005532'"
				   + " or org_id = 'C6000000005278' or org_id = 'C6000000005269'"
				   + " or org_id = 'C6000000005275' or org_id = 'C6000000007366') and bsflag = '0'";			
		unitList = jdbcDao.queryRecords(sql);		
		responseDTO.setValue("datas", unitList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����װ����ҵ���������������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateCollDevInfo(ISrvMsg msg) throws Exception {
		
		UserToken user = msg.getUserToken();
		String project_info_no = msg.getValue("projectInfoNo");
		String device_app_name = msg.getValue("device_app_name");
		String employeeId = msg.getValue("employee_id");
		String projectOrgId = msg.getValue("projectOrgId");
		String addUpFlag = msg.getValue("addupflag");//���/�޸ı�ʶ
		String remarks = msg.getValue("remarks");//��ע
		
		Map<String, Object> mainMap = new HashMap<String, Object>();
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("device_app_name", device_app_name);
		mainMap.put("mix_type_id", DevConstants.MIXTYPE_ZHUANGBEI_DZYQ);//��������
		mainMap.put("mix_org_id", DevConstants.MIXTYPE_ZHUANGBEI_ORGID);
		mainMap.put("remark", msg.getValue("remark"));
		mainMap.put("app_org_id", projectOrgId);//��Ŀ����С��org_id
		mainMap.put("appdate", msg.getValue("appdate"));
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("state", DevConstants.STATE_SAVED);
		mainMap.put("mix_org_type", "1");//װ����ҵ���ύ������
		mainMap.put("remark", remarks);//װ����ҵ���ύ��������д�ı�ע
		String device_app_no = "";
		if(addUpFlag != null && "add".equals(addUpFlag)){//����
			device_app_no = DevUtil.getCollDevAppNo();
			mainMap.put("create_date", DevUtil.getCurrentTime());
			mainMap.put("creator_id", user.getEmpId());
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
			mainMap.put("employee_id", employeeId);//������ID(װ����ҵ����Ա)
			mainMap.put("org_id", user.getOrgId());//�����˵�λorg_id(װ����ҵ����λ)
			mainMap.put("org_subjection_id", user.getOrgSubjectionId());//�����˵�λsub_id(װ����ҵ����λ)
		}else{//�޸�
			device_app_no = msg.getValue("device_app_no");
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
		}
		mainMap.put("device_app_no", device_app_no);
		String device_app_id = msg.getValue("device_app_id");
		if (device_app_id != null && !"".equals(device_app_id)) {
			mainMap.put("device_app_id", device_app_id);
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_collapp");
		}else{
			device_app_id = (String)jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_collapp");
		}		

		// �ӱ���ɾ��
		String sublineinfo = msg.getValue("sub_line_infos");
		jdbcDao.executeUpdate("delete from gms_device_app_colldetsub where device_app_detid='"
					+ device_app_id + "'");

		if(sublineinfo!=null && !sublineinfo.equals("undefined")){
			String[] detailsubinfos = sublineinfo.split("@", -1);
			// ����ϸ��Ϣ�����浽List�У����ڴ洢�ӱ�
			List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
			for (int j = 0; j < detailsubinfos.length; j++) {
				Map<String, Object> subdataMap = new HashMap<String, Object>();
				subdataMap.put("device_app_detid", device_app_id);
				subdataMap.put("device_id", msg.getValue("device_id" + detailsubinfos[j]));
				subdataMap.put("device_name", msg.getValue("devicename" + detailsubinfos[j]));
				subdataMap.put("device_model", msg.getValue("devicemodel" + detailsubinfos[j]));
				subdataMap.put("device_slot_num", msg.getValue("devslotnum" + detailsubinfos[j]));
				subdataMap.put("device_num", msg.getValue("apply_num" + detailsubinfos[j]));
				subdataMap.put("unit_id", msg.getValue("unitList" + detailsubinfos[j]));
				devDetailList.add(subdataMap);
			}
			DeviceMCSBean bean = new DeviceMCSBean();
			bean.saveNewCollMixDetailSubInfo(devDetailList);
		}

		//��������ϸ��Ϣ
		int addedcount = Integer.parseInt(msg.getValue("addedcount"));
		String[] addedline_infos = msg.getValue("addedline_info").split("~", -1);
		jdbcDao.executeUpdate("delete from gms_device_coll_mixsubadd where device_mixinfo_id='"
					+ device_app_id + "'");
		for (int k = 0; k < addedcount; k++) {
			Map<String, Object> addeddataMap = new HashMap<String, Object>();
			String keyId = addedline_infos[k];			
			addeddataMap.put("device_num", msg.getValue("addedassignnum" + keyId));
			addeddataMap.put("device_name",msg.getValue("addeddevicename" + keyId));
			addeddataMap.put("device_model",msg.getValue("addeddevicetype" + keyId));
			addeddataMap.put("unit_name", msg.getValue("addedunit" + keyId));
			addeddataMap.put("devremark",msg.getValue("addedremark" + keyId));
			addeddataMap.put("team", msg.getValue("addedteam" + keyId));
			addeddataMap.put("device_mixinfo_id", device_app_id);//�����ID
			jdbcDao.saveOrUpdateEntity(addeddataMap, "gms_device_coll_mixsubadd");
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����װ����ҵ��������Դ���������������豸��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateZCDevInfo(ISrvMsg msg) throws Exception {
		
		UserToken user = msg.getUserToken();
		String project_info_no = msg.getValue("projectInfoNo");
		String projectOrgId = msg.getValue("projectOrgId");
		String device_app_name = msg.getValue("device_app_name");
		String remarks = msg.getValue("remarks");
		String employeeId = msg.getValue("employee_id");
		String addUpFlag = msg.getValue("addupflag");//���/�޸ı�ʶ
		String zcFlag = msg.getValue("zcflag");//��Դ/�����豸��ʶ: zy����Դ     cl������   yqc��������
		
		Map<String, Object> mainMap = new HashMap<String, Object>();
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("device_app_name", device_app_name);
		if("zy".equals(zcFlag)){//�ɿ���Դ
			mainMap.put("mix_type_id", DevConstants.MIXTYPE_ZHENYUAN);
		}else if("yqc".equals(zcFlag)){//������
			mainMap.put("mix_type_id", DevConstants.MIXTYPE_YIQICHE);
		}else{//�����豸
			mainMap.put("mix_type_id", DevConstants.MIXTYPE_CELIANG);
		}
		mainMap.put("mix_org_id", DevConstants.MIXTYPE_ZHUANGBEI_ORGID);
		mainMap.put("remark", remarks);
		mainMap.put("app_org_id", projectOrgId);//��Ŀ����С��org_id
		mainMap.put("appdate", msg.getValue("appdate"));
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("state", DevConstants.STATE_SAVED);
		mainMap.put("mix_org_type", "1");//װ����ҵ���ύ������
		String device_app_no = "";
		if(addUpFlag != null && "add".equals(addUpFlag)){//����
			device_app_no = DevUtil.getZCDevAppNo(zcFlag);			
			mainMap.put("create_date", DevUtil.getCurrentTime());
			mainMap.put("creator_id", user.getEmpId());
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
			mainMap.put("employee_id", employeeId);//������ID(װ����ҵ����Ա)
			mainMap.put("org_id", user.getOrgId());//�����˵�λorg_id(װ����ҵ����λ)
			mainMap.put("org_subjection_id", user.getOrgSubjectionId());//�����˵�λsub_id(װ����ҵ����λ)
		}else{//�޸�
			device_app_no = msg.getValue("device_app_no");
			mainMap.put("modifi_date", DevUtil.getCurrentTime());
			mainMap.put("updator_id", user.getEmpId());
		}
		mainMap.put("device_app_no", device_app_no);
		String device_app_id = msg.getValue("device_app_id");
		if (device_app_id != null && !"".equals(device_app_id)) {
			mainMap.put("device_app_id", device_app_id);
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_app");
		}else{
			device_app_id = (String)jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_app");
		}
				
		// 3.���ڴ�����ϸ��Ϣ�Ķ�ȡ
		int count = Integer.parseInt(msg.getValue("count"));
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		jdbcDao.executeUpdate("delete from gms_device_app_detail where device_app_id='"
				+ device_app_id + "'");
		// ����ϸ��Ϣ�����浽List�У����ڴ洢�ӱ�
		List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < count; i++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[i];
			dataMap.put("device_app_id", device_app_id);// �����ID
			dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);// ɾ�����			
			dataMap.put("dev_name", msg.getValue("devicename" + keyid));// �豸����
			dataMap.put("dev_type", msg.getValue("devicetype" + keyid));// �豸�ͺ�
			dataMap.put("apply_num", msg.getValue("neednum" + keyid));
			dataMap.put("approve_num", msg.getValue("neednum" + keyid));
			dataMap.put("plan_start_date", msg.getValue("startdate" + keyid));
			dataMap.put("plan_end_date", msg.getValue("enddate" + keyid));
			dataMap.put("unitinfo", msg.getValue("unit" + keyid));
			dataMap.put("project_info_no", project_info_no);// ��Ŀ��ID
			dataMap.put("team", msg.getValue("team" + keyid));// ����ID
			dataMap.put("create_date", DevUtil.getCurrentTime());// ����ʱ��			
			dataMap.put("employee_id", employeeId);// ������
			dataMap.put("purpose", msg.getValue("purpose" + keyid));// ��;purpose
			devDetailList.add(dataMap);
		}
		// 4.�����ӱ���Ϣ
		DeviceMCSBean devbean = new DeviceMCSBean();
		if (count > 0) {
			devbean.saveNewMixAppDetailInfo(devDetailList);
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ�������������������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollDevBaseInfo(ISrvMsg msg) throws Exception {
		String device_app_id = msg.getValue("deviceappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select dev.pro_sub_name || '-' || dev.dui_org_name as sub_org_name,dev.*"
						+ " from (select info.org_abbreviation as dui_org_name,pro.project_name,devapp.project_info_no,"
						+ " devapp.device_app_no,devapp.device_app_name,devapp.appdate,devapp.create_date,pro.project_type,"
						+ " case wfmiddle.proc_status"
						+ " when '1' then '������'"
						+ " when '3' then '����ͨ��'"
						+ " when '4' then '������ͨ��'"
						+ " else 'δ�ύ' end as state_desc,devapp.device_app_id,"
						+ " org.org_abbreviation as org_name,emp.employee_name,"
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
						+ " when sub.org_subjection_id like 'C105008%' then '�ۺ��ﻯ��'"
						+ " when sub.org_subjection_id like 'C105002%' then '���ʿ�̽��ҵ��'"
						+ " else info.org_abbreviation end as pro_sub_name"
						+ " from gms_device_collapp devapp"
						+ " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id and wfmiddle.bsflag = '0'"
						+ " left join comm_org_information org on devapp.org_id = org.org_id and org.bsflag = '0'"
						+ " left join comm_human_employee emp on devapp.employee_id = emp.employee_id and emp.bsflag = '0' "
						+ " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
						+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
						+ " left join comm_org_information info on info.org_id = dy.org_id and info.bsflag = '0'"
						+ " left join comm_org_subjection sub on sub.org_id = info.org_id and sub.bsflag = '0'"
						+ " where devapp.bsflag = '0' and devapp.mix_org_type = '1' and devapp.device_app_id = '"+device_app_id+"') dev");
		Map deviceappMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(deviceappMap)) {
			responseMsg.setValue("deviceappMap", deviceappMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD װ����ҵ��������Դ�������豸������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZCDevBaseInfo(ISrvMsg msg) throws Exception {
		String device_app_id = msg.getValue("deviceappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select dev.pro_sub_name || '-' || dev.dui_org_name as sub_org_name,dev.*"
						+ " from (select info.org_abbreviation as dui_org_name,pro.project_name,devapp.project_info_no,"
						+ " devapp.device_app_no,devapp.device_app_name,devapp.appdate,devapp.create_date,"
						+ " case wfmiddle.proc_status"
						+ " when '1' then '������'"
						+ " when '3' then '����ͨ��'"
						+ " when '4' then '������ͨ��'"
						+ " else 'δ�ύ' end as state_desc,devapp.device_app_id,"
						+ " org.org_abbreviation as org_name,emp.employee_name,"
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
						+ " when sub.org_subjection_id like 'C105008%' then '�ۺ��ﻯ��'"
						+ " when sub.org_subjection_id like 'C105002%' then '���ʿ�̽��ҵ��'"
						+ " else info.org_abbreviation end as pro_sub_name"
						+ " from gms_device_app devapp"
						+ " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id and wfmiddle.bsflag = '0'"
						+ " left join comm_org_information org on devapp.org_id = org.org_id and org.bsflag = '0'"
						+ " left join comm_human_employee emp on devapp.employee_id = emp.employee_id and emp.bsflag = '0' "
						+ " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
						+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
						+ " left join comm_org_information info on info.org_id = dy.org_id and info.bsflag = '0'"
						+ " left join comm_org_subjection sub on sub.org_id = info.org_id and sub.bsflag = '0'"
						+ " where devapp.bsflag = '0' and devapp.mix_org_type = '1' and devapp.device_app_id = '"+device_app_id+"') dev");
		Map deviceappMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(deviceappMap)) {
			responseMsg.setValue("deviceappMap", deviceappMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD װ����ҵ����������������Ϣ��ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCollDevMainInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
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
		String viewFlag = msg.getValue("viewflag");//Y:�鿴����     N:����
		if(StringUtils.isEmpty(viewFlag)){
			viewFlag = "N";
		}
		String projectName = msg.getValue("projectname");
		String deviceAppName = msg.getValue("deviceappname");
		String proOrgName = msg.getValue("proorgname");
		String appOrgId = msg.getValue("apporgid");
		String projectNo = msg.getValue("projectno");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select dev.pro_sub_name || '-' || dev.dui_org_name as sub_org_name,"
				+ " case when length(dev.project_name) > 16 then substr(dev.project_name, 0, 16) || '...'"
				+ " else dev.project_name end as proname,"
				+ " case when length(dev.device_app_name) > 16 then substr(dev.device_app_name, 0, 16) || '...'"
				+ " else dev.device_app_name end as devappname,dev.*"
				+ " from (select info.org_abbreviation as dui_org_name,pro.project_name,devapp.device_app_id,"
				+ " devapp.device_app_no,devapp.device_app_name,devapp.project_info_no,devapp.org_id,devapp.org_subjection_id,"
				+ " devapp.employee_id,devapp.appdate,devapp.create_date,devapp.modifi_date,wfmiddle.proc_status,devapp.opr_state,"
				+ " case wfmiddle.proc_status"
				+ " when '1' then '������'"
				+ " when '3' then '����ͨ��'"
				+ " when '4' then '������ͨ��'"
				+ " else 'δ�ύ' end as state_desc,"
				+ " org.org_abbreviation as org_name,emp.employee_name,"
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
				+ " when sub.org_subjection_id like 'C105008%' then '�ۺ��ﻯ��'"
				+ " when sub.org_subjection_id like 'C105002%' then '���ʿ�̽��ҵ��'"
				+ " else info.org_abbreviation end as pro_sub_name"
				+ " from gms_device_collapp devapp"
				+ " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id and wfmiddle.bsflag = '0'"
				+ " left join comm_org_information org on devapp.org_id = org.org_id and org.bsflag = '0'"
				+ " left join comm_human_employee emp on devapp.employee_id = emp.employee_id and emp.bsflag = '0' "
				+ " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
				+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
				+ " left join comm_org_information info on info.org_id = dy.org_id and info.bsflag = '0'"
				+ " left join comm_org_subjection sub on sub.org_id = info.org_id and sub.bsflag = '0'"
				+ " where devapp.bsflag = '0' and devapp.mix_org_type = '1' ");
		if("Y".equals(viewFlag)){//�鿴���䵥
			querySql.append(" ) dev where 1 = 1");
		}else{
			querySql.append(" and devapp.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%') dev where 1 = 1");
		}
		//��Ŀ����
		if (StringUtils.isNotBlank(projectName)) {
			querySql.append(" and project_name like '%"+projectName+"%'");
		}
		//���뵥����
		if (StringUtils.isNotBlank(deviceAppName)) {
			querySql.append(" and device_app_name like '%"+deviceAppName+"%'");
		}
		//��Ŀ������λ
		if (StringUtils.isNotBlank(proOrgName)) {
			querySql.append(" and dev.pro_sub_name || '-' || dev.dui_org_name like '%"+proOrgName+"%'");
		}
		//���뵥λ����
		if (StringUtils.isNotBlank(appOrgId)) {
			querySql.append(" and org_subjection_id like '%"+appOrgId+"%'");
		}
		//��Ŀ���
		if (StringUtils.isNotBlank(projectNo)) {
			querySql.append(" and project_info_no = '"+projectNo+"'");
		}
		
		querySql.append(" order by proc_status nulls first,create_date desc,org_id,project_info_no ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ����Դ�����豸������Ϣ��ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryZCDevMainInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
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
		String zcFlag = msg.getValue("zcflag");//zy:��Դ�豸����  cl:�����豸����
		String viewFlag = msg.getValue("viewflag");//Y:�鿴����     N:����
		if(StringUtils.isEmpty(viewFlag)){
			viewFlag = "N";
		}
		String projectName = msg.getValue("projectname");
		String deviceAppName = msg.getValue("deviceappname");
		String proOrgName = msg.getValue("proorgname");
		String appOrgId = msg.getValue("apporgid");
		String projectNo = msg.getValue("projectno");
		StringBuffer querySql = new StringBuffer();
			querySql.append("select dev.pro_sub_name || '-' || dev.dui_org_name as sub_org_name,"
					+ " case when length(dev.project_name) > 16 then substr(dev.project_name, 0, 16) || '...'"
					+ " else dev.project_name end as proname,"
					+ " case when length(dev.device_app_name) > 16 then substr(dev.device_app_name, 0, 16) || '...'"
					+ " else dev.device_app_name end as devappname,dev.*"
					+ " from (select info.org_abbreviation as dui_org_name,pro.project_name,devapp.device_app_id,devapp.opr_state,"
					+ " devapp.device_app_no,devapp.device_app_name,devapp.project_info_no,devapp.org_id,devapp.org_subjection_id,"
					+ " devapp.employee_id,devapp.appdate,devapp.create_date,devapp.modifi_date,wfmiddle.proc_status,"
					+ " case wfmiddle.proc_status"
					+ " when '1' then '������'"
					+ " when '3' then '����ͨ��'"
					+ " when '4' then '������ͨ��'"
					+ " else 'δ�ύ' end as state_desc,"
					+ " org.org_abbreviation as org_name,emp.employee_name,"
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
					+ " when sub.org_subjection_id like 'C105008%' then '�ۺ��ﻯ��'"
					+ " when sub.org_subjection_id like 'C105002%' then '���ʿ�̽��ҵ��'"
					+ " else info.org_abbreviation end as pro_sub_name"
					+ " from gms_device_app devapp"
					+ " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id and wfmiddle.bsflag = '0'"
					+ " left join comm_org_information org on devapp.org_id = org.org_id and org.bsflag = '0'"
					+ " left join comm_human_employee emp on devapp.employee_id = emp.employee_id and emp.bsflag = '0' "
					+ " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
					+ " left join gp_task_project_dynamic dy on dy.project_info_no = pro.project_info_no"
					+ " left join comm_org_information info on info.org_id = dy.org_id and info.bsflag = '0'"
					+ " left join comm_org_subjection sub on sub.org_id = info.org_id and sub.bsflag = '0'"
					+ " where devapp.bsflag = '0' and devapp.mix_org_type = '1'");
			if("zy".equals(zcFlag)){//�ɿ���Դ
				querySql.append(" and devapp.mix_type_id = '"+DevConstants.MIXTYPE_ZHENYUAN+"'");
			}else if("yqc".equals(zcFlag)){//������
				querySql.append(" and devapp.mix_type_id = '"+DevConstants.MIXTYPE_YIQICHE+"'");
			}else{//�����豸
				querySql.append(" and devapp.mix_type_id = '"+DevConstants.MIXTYPE_CELIANG+"'");
			}
			if("Y".equals(viewFlag)){//�鿴���䵥
				querySql.append(" ) dev where 1 = 1");
			}else{
				querySql.append(" and devapp.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%') dev where 1 = 1");
			}
		//��Ŀ����
		if (StringUtils.isNotBlank(projectName)) {
			querySql.append(" and project_name like '%"+projectName+"%'");
		}
		//���뵥����
		if (StringUtils.isNotBlank(deviceAppName)) {
			querySql.append(" and device_app_name like '%"+deviceAppName+"%'");
		}
		//��Ŀ������λ
		if (StringUtils.isNotBlank(proOrgName)) {
			querySql.append(" and dev.pro_sub_name || '-' || dev.dui_org_name like '%"+proOrgName+"%'");
		}
		//���뵥λ����
		if (StringUtils.isNotBlank(appOrgId)) {
			querySql.append(" and org_subjection_id like '%"+appOrgId+"%'");
		}
		//��Ŀ���
		if (StringUtils.isNotBlank(projectNo)) {
			querySql.append(" and project_info_no like '%"+projectNo+"%'");
		}
		
		querySql.append(" order by proc_status nulls first,create_date desc,org_id,project_info_no ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ���������������ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCollApplyDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devAppId = msg.getValue("devappid");
		String sql = "select app.remark,cds.device_name,cds.device_model,detail.coding_name as unitname,"
				   + " nvl(cds.device_num, 0) as device_num"
				   + " from gms_device_app_colldetsub cds"
				   + " left join gms_device_collapp app on cds.device_app_detid = app.device_app_id"
				   + " left join comm_coding_sort_detail detail on detail.coding_code_id = cds.unit_id"
			       + " where cds.device_app_detid = '"+devAppId+"' and nvl(cds.device_num, 0) > 0"
			       + " union all"
			       + " select app.remark,mix.device_name,mix.device_model,det.coding_name as unitname,"
			       + " nvl(mix.device_num, 0) as device_num"
			       + " from gms_device_coll_mixsubadd mix"
			       + " left join gms_device_collapp app on mix.device_mixinfo_id = app.device_app_id"
			       + " left join comm_coding_sort_detail det on mix.unit_name = det.coding_code_id"
			       + " where mix.device_mixinfo_id = '"+devAppId+"' and nvl(mix.device_num, 0) > 0";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ��������Դ�������豸��ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryZCApplyDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devAppId = msg.getValue("devappid");
		String sql = "select app.remark,sd.coding_name as unitname,teamsd.coding_name as teamname,"
				   + " appdet.dev_name as dev_ci_name,appdet.dev_type as dev_ci_model,"
				   + " appdet.apply_num,appdet.approve_num,"
				   + " appdet.purpose,appdet.plan_start_date,appdet.plan_end_date"
				   + " from gms_device_app_detail appdet"
				   + " left join gms_device_app app on app.device_app_id = appdet.device_app_id"
				   + " left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id"
				   + " left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id"
				   + " where appdet.device_app_id = '"+devAppId+"' ";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ɾ��װ����ҵ�����������������
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delCollDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String userSubOrg = user.getOrgSubjectionId();
		String delFlag = "0";
		String procState = "";
		String devAppId = msg.getValue("devappid");
		String opFlag = msg.getValue("opflag");
		try{
			String appSql = "select wf.proc_status from gms_device_collapp devapp"
						  + " left join common_busi_wf_middle wf on devapp.device_app_id=wf.business_id and wf.bsflag = '0'"
						  + " where devapp.bsflag = '0' and devapp.device_app_id = '"+devAppId+"' ";
			Map appMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(appMap)){
				procState = appMap.get("proc_status").toString();
				if("3".equals(procState)){
					delFlag = "1";//����ͨ���ĵ��ݲ���ɾ��/�޸�/�ύ
				}else if("1".equals(procState)){
					delFlag = "2";//�������ĵ��ݲ���ɾ��/�޸�/�ύ
				}else{
					if("tj".equals(opFlag)&&
							!userSubOrg.startsWith("C105006001")&&//������������
							!userSubOrg.startsWith("C105006002")&&//������������
							!userSubOrg.startsWith("C105006003")&&//��Դ��������
							!userSubOrg.startsWith("C105006004")&&//������ҵ��
							!userSubOrg.startsWith("C105006005")&&//������ҵ��
							!userSubOrg.startsWith("C105006006")&&//�ػ���ҵ��
							!userSubOrg.startsWith("C105006007")&&//������ҵ��
							!userSubOrg.startsWith("C105006008")&&//����ľ��ҵ��
							!userSubOrg.startsWith("C105006009")&&//�¹���ҵ��
							!userSubOrg.startsWith("C105006011")&&//������ҵ��
							!userSubOrg.startsWith("C105006029")){//�ɺ���ҵ��
						delFlag = "4";//�û����ڵ�λ�����ύ����					
					}else if("del".equals(opFlag)){
						String delSql = "update gms_device_collapp set bsflag='1',updator_id='"+user.getEmpId()+"',modifi_date = sysdate where device_app_id='"+devAppId+"'";
						jdbcDao.executeUpdate(delSql);
					}
				}
			}else{
				delFlag = "3";//ɾ��/�ύ/�޸�ʧ��
			}
		}catch(Exception e){
			delFlag = "3";//ɾ��/�޸�ʧ��
		}
		responseDTO.setValue("datas", delFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �ر�״̬��װ���豸���뵥���Ǵ��ڵ��䵥
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg zbMixedFlag(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String mixedFlag = "0";
		String mixedState = "";
		String devAppId = msg.getValue("devappid");
		String devType = msg.getValue("devtype");//coll����������    cl:�����豸
		String appSql = "";
		try{
			if("coll".equals(devType)){
				appSql = "select count(1) as app_num from gms_device_collmix_form mif"
					   + " left join gms_device_collapp devapp on mif.device_app_id = devapp.device_app_id"
					   + " where (mif.bsflag is null or mif.bsflag = '0') and devapp.state = '9'"
					   + " and devapp.bsflag = '0' and devapp.device_app_id = '"+devAppId+"' ";
			}else{
				appSql = "select count(1) as app_num from gms_device_mixinfo_form mif"
					   + " left join gms_device_app devapp on mif.device_app_id = devapp.device_app_id"
					   + " where devapp.bsflag = '0' and (mif.bsflag is null or mif.bsflag = '0')"
					   + " and devapp.bsflag = '0' and devapp.device_app_id = '"+devAppId+"' ";
			}
			Map appMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(appMap)){
				mixedState = appMap.get("app_num").toString();
				if("0".equals(mixedState)){
					mixedFlag = "1";//û�г��ߵ��䵥
				}
			}else{
				mixedFlag = "3";//��ѯ���ݵ���״̬ʧ��
			}
		}catch(Exception e){
			mixedFlag = "3";//��ѯ���ݵ���״̬ʧ��
		}
		responseDTO.setValue("datas", mixedFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ɾ��װ����ҵ��������Դ�������豸����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delZCDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String userSubOrg = user.getOrgSubjectionId();
		String delFlag = "0";
		String procState = "";
		String devAppId = msg.getValue("devappid");
		String opFlag = msg.getValue("opflag");
		try{
			String appSql = "select wf.proc_status from gms_device_app devapp"
						  + " left join common_busi_wf_middle wf on devapp.device_app_id=wf.business_id and wf.bsflag = '0'"
						  + " where devapp.bsflag = '0' and devapp.device_app_id = '"+devAppId+"' ";
			Map appMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(appMap)){
				procState = appMap.get("proc_status").toString();
				if("3".equals(procState)){
					delFlag = "1";//����ͨ���ĵ��ݲ���ɾ��/�޸�/�ύ
				}else if("1".equals(procState)){
					delFlag = "2";//�������ĵ��ݲ���ɾ��/�޸�/�ύ
				}else{
					if("tj".equals(opFlag)&&
							!userSubOrg.startsWith("C105006001")&&//������������
							!userSubOrg.startsWith("C105006002")&&//������������
							!userSubOrg.startsWith("C105006003")&&//��Դ��������
							!userSubOrg.startsWith("C105006004")&&//������ҵ��
							!userSubOrg.startsWith("C105006005")&&//������ҵ��
							!userSubOrg.startsWith("C105006006")&&//�ػ���ҵ��
							!userSubOrg.startsWith("C105006007")&&//������ҵ��
							!userSubOrg.startsWith("C105006008")&&//����ľ��ҵ��
							!userSubOrg.startsWith("C105006009")&&//�¹���ҵ��
							!userSubOrg.startsWith("C105006011")&&//������ҵ��
							!userSubOrg.startsWith("C105006029")){//�ɺ���ҵ��
						delFlag = "4";//�û����ڵ�λ�����ύ����					
					}else if("del".equals(opFlag)){
						String delSql = "update gms_device_app set bsflag='1',updator_id='"+user.getEmpId()+"',modifi_date = sysdate where device_app_id='"+devAppId+"'";
						jdbcDao.executeUpdate(delSql);
					}
				}
			}else{
				delFlag = "3";//ɾ��/�ύ/�޸�ʧ��
			}
		}catch(Exception e){
			delFlag = "3";//ɾ��/�޸�ʧ��
		}
		responseDTO.setValue("datas", delFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ת��¼��д�ж�ÿ��ֻ����дһ������
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg yzDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String yzFlag = "0";
		String devAccId = msg.getValue("devaccid");
		String modifyDate = msg.getValue("modifydate");
		String projectInfoNo = msg.getValue("projectinfono");
		try{
			String appSql = "select operation_info_id from gms_device_operation_info"
						  + " where to_char(modify_date, 'yyyy-MM-dd') = to_char(to_date('"+modifyDate+"','yyyy-MM-dd'),'yyyy-MM-dd')"
						  + " and project_info_no = '"+projectInfoNo+"' and dev_acc_id = '"+devAccId+"'";
			List<Map> checkResult = jdbcDao.queryRecords(appSql);
			if(checkResult.size() >= 1){
				yzFlag = "1";//���ڵ�����ת��¼
			}
		}catch(Exception e){
			yzFlag = "3";//��ѯʧ��
		}
		responseDTO.setValue("datas", yzFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ������������������޸Ĳ���������뵥��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollMainInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devappid = msg.getValue("devappid");
		StringBuffer sb = new StringBuffer()
			.append( "select pro.project_name,devapp.project_info_no,devapp.device_app_no,devapp.device_app_id,"
					  + " devapp.device_app_name,emp.employee_name,devapp.employee_id,info.org_name,devapp.appdate,"
					  + " pro.project_type,devapp.app_org_id,devapp.remark from gms_device_collapp devapp"
					  + " left join gp_task_project pro on pro.project_info_no = devapp.project_info_no"
					  + " left join comm_human_employee emp on devapp.employee_id = emp.employee_id and emp.bsflag = '0'"
					  + " left join comm_org_information info on info.org_id = devapp.org_id and info.bsflag = '0'"
				      + " where devapp.bsflag = '0' and devapp.device_app_id = '"+devappid+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (mainMap != null) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ��������Դ/�����豸�����޸Ĳ���������뵥��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZCMainInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devappid = msg.getValue("devappid");
		StringBuffer sb = new StringBuffer()
			.append( "select pro.project_name,devapp.project_info_no,devapp.device_app_no,devapp.device_app_id,"
					  + " devapp.device_app_name,emp.employee_name,devapp.employee_id,info.org_name,devapp.appdate,"
					  + " pro.project_type,devapp.app_org_id,devapp.remark from gms_device_app devapp"
					  + " left join gp_task_project pro on pro.project_info_no = devapp.project_info_no"
					  + " left join comm_human_employee emp on devapp.employee_id = emp.employee_id and emp.bsflag = '0'"
					  + " left join comm_org_information info on info.org_id = devapp.org_id and info.bsflag = '0'"
				      + " where devapp.bsflag = '0' and devapp.device_app_id = '"+devappid+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (mainMap != null) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ���������ʱ��ʾ��ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollAppMainInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devappid = msg.getValue("devappid");
		StringBuffer sb = new StringBuffer()
			.append( "select devapp.device_app_no,devapp.project_info_no,devapp.app_org_id as in_org_id,"
					  + " devapp.appdate,tp.project_name,inorg.org_abbreviation as in_org_name,devapp.remark"
					  + " from gms_device_collapp devapp"
					  + " left join gp_task_project tp on devapp.project_info_no=tp.project_info_no"
					  + " left join comm_org_information inorg on devapp.app_org_id=inorg.org_id and inorg.bsflag = '0'"
				      + " where devapp.device_app_id = '"+devappid+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (mainMap != null) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ��������䵥̨ʱ��ʾ��ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevAppMainInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devappid = msg.getValue("devappid");
		StringBuffer sb = new StringBuffer()
			.append( "select devapp.device_app_id,devapp.device_app_no,devapp.project_info_no,devapp.app_org_id as in_org_id,"
					  + " to_char(devapp.appdate,'yyyy-mm-dd') as appdate,tp.project_name,inorg.org_abbreviation as in_org_name,"
					  + " devapp.mix_org_id,devapp.mix_type_id,devapp.mix_type_name,devapp.mix_user_id,dmf.device_mixinfo_id,"
					  + " devapp.remark,dmf.out_org_id,outorg.org_abbreviation as out_org_name,dmf.mixinfo_no from gms_device_app devapp"
					  + " left join gms_device_mixinfo_form dmf on devapp.device_app_id = dmf.device_app_id and dmf.bsflag='0'"
					  + " left join comm_org_information outorg on dmf.out_org_id=outorg.org_id"
					  + " left join gp_task_project tp on devapp.project_info_no=tp.project_info_no "
					  + " left join comm_org_information inorg on devapp.app_org_id=inorg.org_id "
				      + " where devapp.device_app_id = '"+devappid+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (mainMap != null) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ����������豸ʱ��ʾ���ڵ�λ���豸������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOrgCollDevNum(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devappid = msg.getValue("devappid");
		String usageOrgId = msg.getValue("usageorgid");
		String sql = "select acc.usage_org_id,acc.device_id,nvl(teach.good_num, 0) - nvl(ms.wanhao_num, 0) as unuse_num"
				   + " from gms_device_coll_account acc"
				   + " left join (select d.out_dev_id,sum(nvl(d.wanhao_num, 0)) as wanhao_num"
				   + " from gms_device_moveapp_detail d"
				   + " left join gms_device_moveapp p on p.moveapp_id = d.moveapp_id"
				   + " where p.state = '0' and p.bsflag = '0' and p.move_type = '2' group by d.out_dev_id) ms on acc.dev_acc_id = ms.out_dev_id"
			  	   + " left join gms_device_coll_account_tech teach on teach.dev_acc_id = acc.dev_acc_id"
			       + " where acc.usage_org_id = '"+usageOrgId+"' and acc.bsflag='0'"
			       + " and acc.ifcountry !='����' and acc.device_id in"
				   + " (select device_id from gms_device_app_colldetsub sub"
			       + " where nvl(sub.device_num, 0) > 0 and sub.device_app_detid = '"+devappid+"' )";
		List<Map> numList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", numList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ�������������豸�ͺ�ʱ��ʾ���ڵ�λ���豸������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOrgCollDevAddNum(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String deviceId = msg.getValue("deviceid");
		String usageOrgId = msg.getValue("usageorgid");
		String sql = "select usage_org_id,device_id,teach.good_num as unuse_num from gms_device_coll_account account"
			       + " left join gms_device_coll_account_tech teach on teach.dev_acc_id=account.dev_acc_id"
			       + " where account.usage_org_id = '"+usageOrgId+"' and account.bsflag='0'"
			       + " and (account.ifcountry !='����' or account.ifcountry is null)"
		           + " and account.device_id = '"+deviceId+"' ";
		List<Map> numList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", numList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ������������������޸Ĳ���������뵥��ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollDetSub(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devappid = msg.getValue("devappid");
		String sql = "select cds.device_id,cds.device_name,cds.device_model,detail.coding_name as unitname,"
				   + " unit_id,cds.device_slot_num,cds.device_num,device_slot_num*device_num as apply_num"
				   + " from gms_device_app_colldetsub cds"
				   + " left join comm_coding_sort_detail detail on detail.coding_code_id = cds.unit_id"
			       + " where cds.device_app_detid = '"+devappid+"' and nvl(cds.device_num, 0) > 0";
		List<Map> subList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", subList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ������������������޸Ĳ���������뵥�����豸��ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollAdded(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devappid = msg.getValue("devappid");
		String sql = "select teamsd.coding_name as teamname,mix.team,mix.device_name,mix.device_model,"
				   + " mix.unit_name as unit_id,tail.coding_name as unit_name,"
				   + " mix.device_num,mix.mix_num,mix.devremark from gms_device_coll_mixsubadd mix"
				   + " left join comm_coding_sort_detail teamsd on mix.team = teamsd.coding_code_id"
				   + " left join comm_coding_sort_detail tail on mix.unit_name = tail.coding_code_id"
			       + " left join comm_coding_sort_detail d on mix.team=d.coding_code_id"
			       + " where mix.device_mixinfo_id = '"+devappid+"' ";
		List<Map> addedList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", addedList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ����������������ݵ���ʱ��ʾ��ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollDetSubInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devappid = msg.getValue("devappid");
		String sql = "select cms.device_app_detid,cms.device_detsubid,cms.device_id,cms.device_name,"
				   + " cms.device_model,cms.device_num as applynum,nvl(temp.mixednum,0) mixednum,cms.unit_id,"
				   + " unitsd.coding_name as unit_name from gms_device_app_colldetsub cms"
				   + " left join (select device_detsubid,sum(mix_num) as mixednum from gms_device_coll_mixsub mixsub,"
				   + " gms_device_collmix_form collform"
				   + " where collform.device_mixinfo_id=mixsub.device_mixinfo_id and collform.bsflag='0'"
				   + " group by device_detsubid) temp on temp.device_detsubid=cms.device_detsubid"
				   + " left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=cms.unit_id"
			       + " where cms.device_app_detid = '"+devappid+"' and nvl(cms.device_num,0)>0"
			       + " order by cms.device_id ";
		List<Map> addedList = jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", addedList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ����������������ݵ���ʱ��ʾ�����豸��ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getMixSubAdded(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devappid = msg.getValue("devappid");
		String sql = "select mix.device_mif_subid,mix.device_name,mix.device_model,nvl(mix.device_slot_num, 0) as device_slot_num,"
				   + " nvl(mix.device_num, 0) as device_num,nvl(mix.mix_num, 0) as mix_num,tail.coding_name as unit_name,"
				   + " mix.team,mix.devremark,d.coding_name,mix.unit_name as unit from gms_device_coll_mixsubadd mix"
				   + " left join comm_coding_sort_detail tail on mix.unit_name = tail.coding_code_id"
				   + " left join comm_coding_sort_detail d on mix.team = d.coding_code_id"
			       + " where mix.device_mixinfo_id = '"+devappid+"' and nvl(mix.device_num, 0)>0";
		List<Map> addedList = jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", addedList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ�����뵥̨�豸����ʱ��ʾ��ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevAppDet(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devappid = msg.getValue("devappid");
		String sql = "select appdet.device_app_detid,appdet.team,appdet.approve_num,appdet.purpose,appdet.isdevicecode,"
					 + " appdet.plan_start_date,appdet.plan_end_date,appdet.teamid,appdet.unitinfo,nvl(tmp.mixed_num,0) mixed_num,"
					 + " appdet.dev_name as dev_ci_name,appdet.dev_type as dev_ci_model,"
					 + " appdet.dev_ci_code,unitsd.coding_name as unit_name,teamsd.coding_name as team_name "
					 + " from gms_device_app_detail appdet"
					 + " left join (select device_app_detid,sum(assign_num) as mixed_num from gms_device_appmix_main amm"
					 + " where amm.bsflag='0' group by device_app_detid) tmp on tmp.device_app_detid = appdet.device_app_detid"
					 + " left join comm_coding_sort_detail teamsd on teamsd.coding_code_id=appdet.team"
					 + " left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=appdet.unitinfo"
					 + " where appdet.bsflag='0' and appdet.device_app_id='"+devappid+"'"
					 + " order by appdet.dev_ci_code";
		List<Map> devList = jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", devList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ��������Դ�������豸�����޸Ĳ�����������豸��ϸ��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getZCDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devappid = msg.getValue("devappid");
		String sql = "select appdet.purpose,sd.coding_name as unitname,teamsd.coding_name as teamname,"
				   + " appdet.team,appdet.dev_name as dev_ci_name,appdet.dev_type as dev_ci_model,"
				   + " appdet.unitinfo,appdet.apply_num,appdet.approve_num,appdet.device_app_detid,"
				   + " appdet.purpose,appdet.plan_start_date,appdet.plan_end_date"
				   + " from gms_device_app_detail appdet"
				   + " left join comm_coding_sort_detail teamsd on appdet.team = teamsd.coding_code_id"
				   + " left join comm_coding_sort_detail sd on appdet.unitinfo = sd.coding_code_id"
				   + " where appdet.device_app_id = '"+devappid+"' and appdet.bsflag='0' "
				   + " order by appdet.dev_name ";
		List<Map> addedList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", addedList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ���������������������
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveZBCollDevAuditInfowfpa(ISrvMsg msg) throws Exception {
		
		String oprstate = msg.getValue("oprstate");
		String device_app_id = msg.getValue("deviceappid");

		if ("pass".equals(oprstate)) {
			String sublineinfo = msg.getValue("sub_line_infos");
			jdbcDao.executeUpdate("delete from gms_device_app_colldetsub where device_app_detid='"
					+ device_app_id + "'");

			if(sublineinfo!=null && !sublineinfo.equals("undefined")){
				String[] detailsubinfos = sublineinfo.split("@", -1);
				List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
				for (int j = 0; j < detailsubinfos.length; j++) {
					Map<String, Object> subdataMap = new HashMap<String, Object>();
					subdataMap.put("device_app_detid", device_app_id);
					subdataMap.put("device_id", msg.getValue("device_id" + detailsubinfos[j]));
					subdataMap.put("device_name", msg.getValue("devicename" + detailsubinfos[j]));
					subdataMap.put("device_model", msg.getValue("devicemodel" + detailsubinfos[j]));
					subdataMap.put("device_slot_num", msg.getValue("devslotnum" + detailsubinfos[j]));
					subdataMap.put("device_num", msg.getValue("apply_num" + detailsubinfos[j]));
					subdataMap.put("unit_id", msg.getValue("unitList" + detailsubinfos[j]));
					devDetailList.add(subdataMap);
				}
				DeviceMCSBean bean = new DeviceMCSBean();
				bean.saveNewCollMixDetailSubInfo(devDetailList);
			}
			
			//��������ϸ
			int addedcount = Integer.parseInt(msg.getValue("addedcount"));
			String[] addedline_infos = msg.getValue("addedline_info").split("~", -1);
			jdbcDao.executeUpdate("delete from gms_device_coll_mixsubadd where device_mixinfo_id='"
					+ device_app_id + "'");
			for (int k = 0; k < addedcount; k++) {
				Map<String, Object> addeddataMap = new HashMap<String, Object>();
				String keyId = addedline_infos[k];
				addeddataMap.put("device_num", msg.getValue("addedassignnum" + keyId));
				addeddataMap.put("device_name",msg.getValue("addeddevicename" + keyId));
				addeddataMap.put("device_model",msg.getValue("addeddevicetype" + keyId));
				addeddataMap.put("unit_name", msg.getValue("addedunit" + keyId));
				addeddataMap.put("devremark",msg.getValue("addedremark" + keyId));
				addeddataMap.put("team", msg.getValue("addedteam" + keyId));
				addeddataMap.put("device_mixinfo_id", device_app_id);
				jdbcDao.saveOrUpdateEntity(addeddataMap, "gms_device_coll_mixsubadd");
			}
		}
		
		//�����������������Ϊ�ύ״̬
		String sql = "update gms_device_collapp set state='9' where device_app_id='"
				+ device_app_id + "' ";
		jdbcDao.executeUpdate(sql);
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD װ����ҵ��������Դ�������豸��������
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveZBZCDevAuditInfowfpa(ISrvMsg msg) throws Exception {
		
		UserToken user = msg.getUserToken();
		String oprState = msg.getValue("oprstate");
		String devAppId = msg.getValue("deviceappid");

		if ("pass".equals(oprState)) {
			// 3.���ڴ�����ϸ��Ϣ�Ķ�ȡ
			int count = Integer.parseInt(msg.getValue("count"));
			String[] lineinfos = msg.getValue("line_infos").split("~", -1);
			// ����ϸ��Ϣ�����浽List�У����ڴ洢�ӱ�
			List<Map<String, Object>> devDetailList = new ArrayList<Map<String, Object>>();
			for (int i = 0; i < count; i++) {
				Map<String, Object> dataMap = new HashMap<String, Object>();
				String keyid = lineinfos[i];
				dataMap.put("device_app_detid", msg.getValue("deviceappdetid" + keyid));
				dataMap.put("approve_num", msg.getValue("approvenum" + keyid));
				devDetailList.add(dataMap);
			}
			// 4.�����ӱ���Ϣ
			DeviceMCSBean devbean = new DeviceMCSBean();
			if (count > 0) {
				devbean.saveNewMixAppDetailInfo(devDetailList);
			}
		}
		
		//�����������������Ϊ�ύ״̬
		String sql = "update gms_device_collapp set state='9' where device_app_id='"
				+ devAppId + "' ";
		jdbcDao.executeUpdate(sql);
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ������䵥��Ϣ(װ������)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveEQBatchMixFormDetailInfo(ISrvMsg msg) throws Exception {
		// 1.��û�����Ϣ
		String project_info_no = msg.getValue("project_info_no");
		String deviceappid = msg.getValue("deviceappid");
		// 2.�û���ʱ����Ϣ
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String state = msg.getValue("state");
		// -- �ȱ��������
		String in_org_id = msg.getValue("in_org_id");
		String out_org_id = msg.getValue("out_org_id");
		String own_org_id = msg.getValue("owning_org_id");
		Map<String, Object> mainMap = new HashMap<String, Object>();
		mainMap.put("device_app_id", deviceappid);
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("in_org_id", in_org_id);
		mainMap.put("out_org_id", out_org_id);
		mainMap.put("own_org_id", own_org_id);
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("print_emp_id", employee_id);
		mainMap.put("state", state);
		mainMap.put("create_date", DevUtil.getCurrentTime());
		mainMap.put("creator_id", employee_id);
		mainMap.put("modifi_date", DevUtil.getCurrentTime());
		mainMap.put("updator_id", employee_id);
		mainMap.put("org_id", user.getOrgId());
		mainMap.put("org_subjection_id", user.getOrgSubjectionId());
		mainMap.put("opr_state", DevConstants.STATE_SAVED);
		if ("".equals(msg.getValue("mixinfo_no"))) {
			mainMap.put("mixinfo_no", DevUtil.getCollMixInfoNo());
		}
		// ����Ѿ�����id����ô�������map�У�ʵ���޸Ĺ���
		Serializable mainid = null;
		String devicemixinfoid = msg.getValue("devicemixinfoid");
		if (devicemixinfoid != null && !"".equals(devicemixinfoid)) {
			mainMap.put("device_mixinfo_id", devicemixinfoid);
			mainid = devicemixinfoid;
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_collmix_form");
		} else {
			// ������mainid��Ϣ
			mainid = jdbcDao.saveOrUpdateEntity(mainMap,"gms_device_collmix_form");
		}
		// 3.1 ���ڴ�����ϸ��Ϣ�Ķ�ȡ
		int count = Integer.parseInt(msg.getValue("count"));
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		String[] idinfos = msg.getValue("idinfos").split("~", -1);
		for (int i = 0; i < count; i++) {
			if (i == 0) {
				// ɾ�����е��ӱ���Ϣ
				String delsql = "delete from gms_device_coll_mixsub where device_mixinfo_id='"
						+ mainid + "' ";
				jdbcDao.executeUpdate(delsql);
			}
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[i];
			String device_detsubid = idinfos[i];
			dataMap.put("device_detsubid", device_detsubid);
			// �豸���
			String deviceid = msg.getValue("deviceid" + keyid);
			// �������豸���
			String deviceidnew = msg.getValue("deviceidnew" + keyid);
			if (deviceidnew != null && !"".equals(deviceidnew)) {
				dataMap.put("device_id", deviceidnew);
			} else {
				dataMap.put("device_id", deviceid);
			}			
			String devicename = msg.getValue("devicename" + keyid);// �豸����
			dataMap.put("device_name", devicename);			
			String devicemodel = msg.getValue("devicemodel" + keyid);// �豸�ͺ�			
			String devicemodelnew = msg.getValue("devicemodelnew" + keyid);// �������豸�ͺ�
			if (devicemodelnew != null && !"".equals(devicemodelnew)) {
				dataMap.put("device_model", devicemodelnew);
			} else {
				dataMap.put("device_model", devicemodel);
			}			
			String applynum = msg.getValue("applynum" + keyid);// ��������
			dataMap.put("device_num", applynum);			
			String unitid = msg.getValue("unitid" + keyid);// ��λID
			dataMap.put("unit_id", unitid);			
			String mix_num = msg.getValue("mixnum" + keyid);// ��������
			dataMap.put("mix_num", mix_num);			
			String team = msg.getValue("team" + keyid);// ����
			dataMap.put("team", team);
			String devremark = msg.getValue("devremark" + keyid);
			dataMap.put("devremark", devremark);			
			dataMap.put("device_mixinfo_id", mainid);// �����ID

			Serializable collMixSunId = jdbcDao.saveOrUpdateEntity(dataMap,
					"gms_device_coll_mixsub");
			Map appMap = new HashMap();
			appMap.put("device_app_detid", collMixSunId);			
			appMap.put("device_id", deviceid);// �豸���
			appMap.put("device_name", devicename);// �豸����
			appMap.put("device_model", devicemodel);// �豸���
			appMap.put("device_num", applynum);// ��������
			appMap.put("unit_id", unitid);// ��λID
			appMap.put("mix_num", mix_num);// ��������
			jdbcDao.saveOrUpdateEntity(appMap, "gms_device_app_colldetsub");
		}
		// 2013-1-9 ��������ϸ��Ϣ
		int addedcount = Integer.parseInt(msg.getValue("addedcount"));
		String[] addedline_infos = msg.getValue("addedline_info")
				.split("~", -1);
		jdbcDao.executeUpdate("delete from gms_device_coll_mixsubadd where device_mixinfo_id='"
				+ mainid + "'");
		for (int i = 0; i < addedcount; i++) {
			Map<String, Object> addeddataMap = new HashMap<String, Object>();
			String keyid = addedline_infos[i];
			// ��������
			String mix_Num_Tmp = msg.getValue("addedmixnum" + keyid);
			String device_Mif_SubId_Tmp = msg.getValue("addedmifsubid" + keyid);

			addeddataMap.put("mix_num", mix_Num_Tmp);
			// ���ơ�����ͺš�������λ����ע������
			addeddataMap.put("device_name",
					msg.getValue("addeddevicename" + keyid));
			addeddataMap.put("device_model",
					msg.getValue("addeddevicetype" + keyid));
			addeddataMap.put("unit_name", msg.getValue("addedunit" + keyid));
			addeddataMap.put("devremark", msg.getValue("addedremark" + keyid));
			addeddataMap.put("team", msg.getValue("addedteam" + keyid));
			// �����ID
			addeddataMap.put("device_mixinfo_id", mainid);
			String upSubSql = "update gms_device_coll_mixsubadd set mix_num=nvl(mix_num,0)+'"
					+ mix_Num_Tmp + "' ";
			upSubSql += "where device_mif_subid='" + device_Mif_SubId_Tmp
					+ "' ";
			jdbcDao.executeUpdate(upSubSql);
			// ����Ѿ�����subid����ô�������map�У�ʵ���޸Ĺ���
			jdbcDao.saveOrUpdateEntity(addeddataMap,
					"gms_device_coll_mixsubadd");
		}
		String zbFlag = msg.getValue("zbflag");//1����ҵ�������������   0:С�������������
		if (DevConstants.STATE_SUBMITED.equals(state)) {
			String updatesql1 = null;
			String updatesql2 = null;
			if("1".equals(zbFlag)){//��ҵ�������������
				updatesql1 = "update gms_device_collapp devapp set opr_state='1' "
						+ "where (exists (select 1 from gms_device_app_colldetsub devappdetsub "
						+ "left join (select device_detsubid,nvl(sum(mix_num),0) as assignnum from gms_device_coll_mixsub dam "
						+ "where exists(select 1 from gms_device_app_colldetsub dad "
						+ "where dad.device_detsubid=dam.device_detsubid and dad.device_app_detid='"
						+ deviceappid
						+ "') "
						+ "and exists(select 1 from gms_device_collmix_form mif where mif.device_mixinfo_id=dam.device_mixinfo_id and mif.state='9') "
						+ "group by device_detsubid) assign "
						+ "on devappdetsub.device_detsubid = assign.device_detsubid "
						+ "where devappdetsub.device_num>nvl(assign.assignnum,0) and devappdetsub.device_app_detid='"
						+ deviceappid
						+ "') "
						+ "or exists (select 1 from (select nvl(sum(mix.device_num), 0) as add_device_num,nvl(sum(mix.mix_num), 0) as add_mix_num "
						+ "from gms_device_coll_mixsubadd mix where mix.device_mixinfo_id='"
						+ deviceappid
						+ "' ) tmp "
						+ "where nvl(tmp.add_device_num, 0) > nvl(add_mix_num, 0))) "
						+ "and devapp.device_app_id = '" + deviceappid + "' ";

				updatesql2 = "update gms_device_collapp devapp set opr_state='9' "
						+ "where (not exists (select 1 from gms_device_app_colldetsub devappdetsub "
						+ "left join (select device_detsubid,nvl(sum(mix_num),0) as assignnum from gms_device_coll_mixsub dam "
						+ "where exists(select 1 from gms_device_app_colldetsub dad "
						+ "where dad.device_app_detid ='"
						+ deviceappid
						+ "') "
						+ "and exists(select 1 from gms_device_collmix_form mif where mif.device_mixinfo_id=dam.device_mixinfo_id and mif.state='9') "
						+ "group by device_detsubid) assign "
						+ "on devappdetsub.device_detsubid=assign.device_detsubid "
						+ "where devappdetsub.device_num>nvl(assign.assignnum,0) and devappdetsub.device_app_detid='"
						+ deviceappid
						+ "') "
						+ "and not exists (select 1 from (select nvl(sum(mix.device_num), 0) as add_device_num,nvl(sum(mix.mix_num), 0) as add_mix_num "
						+ "from gms_device_coll_mixsubadd mix "
						+ "where mix.device_mixinfo_id='"
						+ deviceappid
						+ "' ) tmp "
						+ "where nvl(tmp.add_device_num, 0) > nvl(add_mix_num, 0))) "
						+ "and devapp.device_app_id = '" + deviceappid + "'";				
			}else{
				updatesql1 = "update gms_device_collapp devapp set opr_state='1' "
						+ "where (exists (select 1 from gms_device_app_colldetsub devappdetsub "
						+ "join gms_device_app_colldetail devcd on devappdetsub.device_app_detid=devcd.device_app_detid and devcd.device_app_id='"
						+ deviceappid
						+ "' "
						+ "left join (select device_detsubid,nvl(sum(mix_num),0) as assignnum from gms_device_coll_mixsub dam "
						+ "where exists(select 1 from gms_device_app_colldetsub dad join gms_device_app_colldetail cd on dad.device_app_detid=cd.device_app_detid "
						+ "where dad.device_detsubid=dam.device_detsubid "
						+ "and cd.device_app_id='"
						+ deviceappid
						+ "') "
						+ "and exists(select 1 from gms_device_collmix_form mif where mif.device_mixinfo_id=dam.device_mixinfo_id and mif.state='9') "
						+ "group by device_detsubid) assign "
						+ "on devappdetsub.device_detsubid=assign.device_detsubid "
						+ "where devappdetsub.device_num>nvl(assign.assignnum,0) and devcd.device_app_id='"
						+ deviceappid
						+ "') "
						+ "or exists (select 1 from (select nvl(sum(mix.device_num), 0) as add_device_num,nvl(sum(mix.mix_num), 0) as add_mix_num "
						+ "from gms_device_coll_mixsubadd mix left join gms_device_app_colldetail tail on mix.device_mixinfo_id = tail.device_app_detid "
						+ "where tail.device_app_id='"
						+ deviceappid
						+ "' ) tmp "
						+ "where nvl(tmp.add_device_num, 0) > nvl(add_mix_num, 0))) "
						+ "and devapp.device_app_id = '" + deviceappid + "' ";
	
				updatesql2 = "update gms_device_collapp devapp set opr_state='9' "
						+ "where (not exists (select 1 from gms_device_app_colldetsub devappdetsub "
						+ "join gms_device_app_colldetail devcd on devappdetsub.device_app_detid=devcd.device_app_detid and devcd.device_app_id='"
						+ deviceappid
						+ "' "
						+ "left join (select device_detsubid,nvl(sum(mix_num),0) as assignnum from gms_device_coll_mixsub dam "
						+ "where exists(select 1 from gms_device_app_colldetsub dad join gms_device_app_colldetail cd on dad.device_app_detid=cd.device_app_detid "
						+ "where dad.device_detsubid=dam.device_detsubid "
						+ "and cd.device_app_id='"
						+ deviceappid
						+ "') "
						+ "and exists(select 1 from gms_device_collmix_form mif where mif.device_mixinfo_id=dam.device_mixinfo_id and mif.state='9') "
						+ "group by device_detsubid) assign "
						+ "on devappdetsub.device_detsubid=assign.device_detsubid "
						+ "where devappdetsub.device_num>nvl(assign.assignnum,0) and devcd.device_app_id='"
						+ deviceappid
						+ "') "
						+ "and not exists (select 1 from (select nvl(sum(mix.device_num), 0) as add_device_num,nvl(sum(mix.mix_num), 0) as add_mix_num "
						+ "from gms_device_coll_mixsubadd mix left join gms_device_app_colldetail tail on mix.device_mixinfo_id = tail.device_app_detid "
						+ "where tail.device_app_id='"
						+ deviceappid
						+ "' ) tmp "
						+ "where nvl(tmp.add_device_num, 0) > nvl(add_mix_num, 0))) "
						+ "and devapp.device_app_id = '" + deviceappid + "'";
			}
			jdbcDao.executeUpdate(updatesql1);
			jdbcDao.executeUpdate(updatesql2);
		}
		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}
	/**
	 * NEWMETHOD ������䵥��Ϣ(װ���豸)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveEQMixFormAllInfo(ISrvMsg msg) throws Exception {
		String project_info_no = msg.getValue("project_info_no");
		String deviceappid = msg.getValue("deviceappid");
		UserToken user = msg.getUserToken();
		String employee_id = user.getEmpId();
		String state = msg.getValue("state");
		// -- �ȱ��������
		String in_org_id = msg.getValue("in_org_id");
		String out_org_id = msg.getValue("out_org_id");
		// �걨���������Ϣ �������ã�Ϊ�����ֵ���͵���
		String mixform_type = msg.getValue("mixform_type");
		Map<String, Object> mainMap = new HashMap<String, Object>();
		// �������ĵ��䵥�����Ϣ�ӵ�mainmap��
		mainMap.put("mixform_type", mixform_type);
		mainMap.put("device_app_id", deviceappid);
		mainMap.put("project_info_no", project_info_no);
		mainMap.put("in_org_id", in_org_id);
		mainMap.put("out_org_id", out_org_id);
		mainMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
		mainMap.put("print_emp_id", employee_id);
		mainMap.put("state", state);
		mainMap.put("create_date", DevUtil.getCurrentTime());
		mainMap.put("creator_id", employee_id);
		mainMap.put("modifi_date", DevUtil.getCurrentTime());
		mainMap.put("updator_id", employee_id);
		mainMap.put("org_id", user.getOrgId());
		mainMap.put("org_subjection_id", user.getOrgSubjectionId());
		mainMap.put("opr_state", DevConstants.STATE_SAVED);
		if ("".equals(msg.getValue("mixinfo_no"))) {
			mainMap.put("mixinfo_no", DevUtil.getEqMixInfoNo());
		}
		/** ���������뵥�Ĵ�����Ϣ���浽���䵥�� */
		mainMap.put("mix_org_id", user.getOrgId());
		mainMap.put("mix_type_id", msg.getValue("mix_type_id"));
		mainMap.put("mix_type_name", msg.getValue("mix_type_name"));
		mainMap.put("mix_user_id", msg.getValue("mix_user_id"));
		// ����Ѿ�����id����ô�������map�У�ʵ���޸Ĺ���
		Serializable mainid = null;
		String mixInfoId = msg.getValue("mixInfoId");
		if (mixInfoId != null && !"".equals(mixInfoId)) {
			mainMap.put("device_mixinfo_id", mixInfoId);
			mainid = mixInfoId;
			jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_mixinfo_form");
		} else {
			// ������mainid��Ϣ
			mainid = jdbcDao.saveOrUpdateEntity(mainMap,
					"gms_device_mixinfo_form");
		}
		// 3.1 ���ڴ�����ϸ��Ϣ�Ķ�ȡ
		int count = Integer.parseInt(msg.getValue("count"));
		String[] lineinfos = msg.getValue("line_infos").split("~", -1);
		String[] idinfos = msg.getValue("idinfos").split("~", -1);
		// 2012-10-30 ����ǰ������ӱ���Ϣ
		jdbcDao.executeUpdate("delete from gms_device_appmix_main where device_mixinfo_id='"
				+ mainid + "'");
		for (int i = 0; i < count; i++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			String keyid = lineinfos[i];
			String device_app_detid = idinfos[i];
			dataMap.put("device_app_detid", device_app_detid);
			// �豸���
			String devcicode = msg.getValue("devcicode" + keyid);
			dataMap.put("dev_ci_code", devcicode);
			String isdevicecode = msg.getValue("isdevicecode" + keyid);
			dataMap.put("isdevicecode", isdevicecode);
			// ��������
			String mix_num = msg.getValue("mixnum" + keyid);
			dataMap.put("assign_num", mix_num);
			// �Ƿ������ϸ
			dataMap.put("is_add_detail", "Y");
			// ɾ�����
			dataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			// �����ID
			dataMap.put("device_mixinfo_id", mainid);
			// 2012-10-30 ��ע��Ϣ
			dataMap.put("devremark", msg.getValue("devremark" + keyid));
			// ����Ѿ�����subid����ô�������map�У�ʵ���޸Ĺ���
			jdbcDao.saveOrUpdateEntity(dataMap, "gms_device_appmix_main");
		}
		// 2013-1-9 ��������ϸ��Ϣ
		int addedcount = Integer.parseInt(msg.getValue("addedcount"));
		String[] addedline_infos = msg.getValue("addedline_info")
				.split("~", -1);
		jdbcDao.executeUpdate("delete from gms_device_appmix_added where device_mixinfo_id='"
				+ mainid + "'");
		for (int i = 0; i < addedcount; i++) {
			Map<String, Object> addeddataMap = new HashMap<String, Object>();
			String keyid = addedline_infos[i];
			// ��������
			String mix_num = msg.getValue("addedassignnum" + keyid);
			addeddataMap.put("assign_num", mix_num);
			// ���ơ�����ͺš�������λ����ע������
			addeddataMap.put("dev_name",
					msg.getValue("addeddevicename" + keyid));
			addeddataMap.put("dev_model",
					msg.getValue("addeddevicetype" + keyid));
			addeddataMap.put("dev_unit", msg.getValue("addedunit" + keyid));
			addeddataMap.put("devremark", msg.getValue("addedremark" + keyid));
			addeddataMap.put("team", msg.getValue("addedteam" + keyid));
			addeddataMap.put("bsflag", DevConstants.BSFLAG_NORMAL);
			// �����ID
			addeddataMap.put("device_mixinfo_id", mainid);
			// ����Ѿ�����subid����ô�������map�У�ʵ���޸Ĺ���
			jdbcDao.saveOrUpdateEntity(addeddataMap, "gms_device_appmix_added");
		}
		String zbFlag = msg.getValue("zbflag");//1����ҵ�������������   0:С�������������
		if (DevConstants.STATE_SUBMITED.equals(state)) {
			String updatesql1 = null;
			String updatesql2 = null;
			if("1".equals(zbFlag)){//��ҵ��������Դ�������豸
				updatesql1 = "update gms_device_app devapp set opr_state='1' "
						+ "where exists (select 1 from gms_device_app_detail devappdet "
						+ "left join (select device_app_detid,nvl(sum(assign_num),0) as assignnum from gms_device_appmix_main dam "
						+ "where exists(select 1 from gms_device_app_detail dad where dad.device_app_detid=dam.device_app_detid "
						+ "and dad.device_app_id='"
						+ deviceappid
						+ "') "
						+ "and exists(select 1 from gms_device_mixinfo_form mif where mif.device_mixinfo_id=dam.device_mixinfo_id and mif.state='9') "
						+ "group by device_app_detid) assign "
						+ "on devappdet.device_app_detid=assign.device_app_detid and devappdet.bsflag='0' "
						+ "and devappdet.device_app_id='"
						+ deviceappid
						+ "' "
						+ "where devappdet.approve_num>nvl(assign.assignnum,0) and devappdet.device_app_id ='"
						+ deviceappid
						+ "') "
						+ "and devapp.device_app_id = '"
						+ deviceappid + "'";
	
				updatesql2 = "update gms_device_app devapp set opr_state='9' "
						+ "where not exists (select 1 from gms_device_app_detail devappdet "
						+ "left join (select device_app_detid,nvl(sum(assign_num),0) as assignnum from gms_device_appmix_main dam "
						+ "where exists(select 1 from gms_device_app_detail dad where dad.device_app_detid=dam.device_app_detid "
						+ "and dad.device_app_id='"
						+ deviceappid
						+ "') "
						+ "and exists(select 1 from gms_device_mixinfo_form mif where mif.device_mixinfo_id=dam.device_mixinfo_id and mif.state='9') "
						+ "group by device_app_detid) assign "
						+ "on devappdet.device_app_detid=assign.device_app_detid and devappdet.bsflag='0' "
						+ "and devappdet.device_app_id='"
						+ deviceappid
						+ "' "
						+ "where devappdet.approve_num>nvl(assign.assignnum,0) and devappdet.device_app_id ='"
						+ deviceappid
						+ "') "
						+ "and devapp.device_app_id = '"
						+ deviceappid + "'";
			}else{
				updatesql1 = "update gms_device_app devapp set opr_state='1' "
					+ "where exists (select 1 from gms_device_app_detail devappdet "
					+ "left join (select device_app_detid,nvl(sum(assign_num),0) as assignnum from gms_device_appmix_main dam "
					+ "where exists(select 1 from gms_device_app_detail dad where dad.device_app_detid=dam.device_app_detid "
					+ "and dad.device_app_id='"
					+ deviceappid
					+ "') "
					+ "and exists(select 1 from gms_device_mixinfo_form mif where mif.device_mixinfo_id=dam.device_mixinfo_id and mif.state='9') "
					+ "group by device_app_detid) assign "
					+ "on devappdet.device_app_detid=assign.device_app_detid and devappdet.bsflag='0' "
					+ "and devappdet.device_app_id='"
					+ deviceappid
					+ "' "
					+ "where devappdet.apply_num>nvl(assign.assignnum,0) and devappdet.device_app_id ='"
					+ deviceappid
					+ "') "
					+ "and devapp.device_app_id = '"
					+ deviceappid + "'";

			updatesql2 = "update gms_device_app devapp set opr_state='9' "
					+ "where not exists (select 1 from gms_device_app_detail devappdet "
					+ "left join (select device_app_detid,nvl(sum(assign_num),0) as assignnum from gms_device_appmix_main dam "
					+ "where exists(select 1 from gms_device_app_detail dad where dad.device_app_detid=dam.device_app_detid "
					+ "and dad.device_app_id='"
					+ deviceappid
					+ "') "
					+ "and exists(select 1 from gms_device_mixinfo_form mif where mif.device_mixinfo_id=dam.device_mixinfo_id and mif.state='9') "
					+ "group by device_app_detid) assign "
					+ "on devappdet.device_app_detid=assign.device_app_detid and devappdet.bsflag='0' "
					+ "and devappdet.device_app_id='"
					+ deviceappid
					+ "' "
					+ "where devappdet.apply_num>nvl(assign.assignnum,0) and devappdet.device_app_id ='"
					+ deviceappid
					+ "') "
					+ "and devapp.device_app_id = '"
					+ deviceappid + "'";
			}
			jdbcDao.executeUpdate(updatesql1);
			jdbcDao.executeUpdate(updatesql2);
		}
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);

		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ѯ�����豸���ͱ���
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevCodeInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
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
		String devName = msg.getValue("devname");
		String devCode = msg.getValue("devcode");
		String devModel = msg.getValue("devmodel");
		String devCtCode = msg.getValue("devctcode");
		String devCtName = msg.getValue("devctname");
		StringBuffer querySql = new StringBuffer();
			querySql.append("select info.dev_ci_id,info.dev_ci_code,info.dev_ci_name,info.dev_ci_model,info.dev_ct_code,pe.dev_ct_name"
					+ " from gms_device_codeinfo info left join gms_device_codetype pe on info.dev_ct_code = pe.dev_ct_code");
		//�豸����
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and info.dev_ci_name like '%"+devName+"%'");
		}
		//�豸����
		if (StringUtils.isNotBlank(devCode)) {
			querySql.append(" and info.dev_ci_code like '%"+devCode+"%'");
		}
		//����ͺ�
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and info.dev_ci_model like '%"+devModel+"%'");
		}
		//�豸���
		if (StringUtils.isNotBlank(devCtCode)) {
			querySql.append(" and info.dev_ct_code like '%"+devCtCode+"%'");
		}
		//�������
		if (StringUtils.isNotBlank(devCtName)) {
			querySql.append(" and pe.dev_ct_name like '%"+devCtName+"%'");
		}
		
		querySql.append(" order by info.dev_ci_code,info.dev_ci_name,info.dev_ci_model,info.dev_ct_code ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ѯ�豸����Ļ�����Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevCodeBaseInfo(ISrvMsg msg) throws Exception {
		String dev_ci_id = msg.getValue("devciid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select info.dev_ci_id,info.dev_ci_code,info.dev_ci_name,info.dev_ci_model,info.dev_ct_code,pe.dev_ct_name"
						+ " from gms_device_codeinfo info left join gms_device_codetype pe on info.dev_ct_code = pe.dev_ct_code"
						+ " where info.dev_ci_id = '"+dev_ci_id+"'");
		Map devCodeMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devCodeMap)) {
			responseMsg.setValue("devCodeMap", devCodeMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD �����豸����
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDevCodeInfo(ISrvMsg msg) throws Exception {
		String codeSql = "select info.dev_ci_id,info.dev_ci_code from gms_device_codeinfo info"
			          + " where info.dev_ct_code is null order by info.dev_ci_code";
		List<Map> dataList = jdbcDao.queryRecords(codeSql);
		for (Map dataMap : dataList) {
			System.out.println(dataMap.get("dev_ci_code").toString().substring(1));
		}
		// 5.��д�ɹ���Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	
	/**
	 * �����޸��豸ģ����Ŀ
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateModeProject(ISrvMsg reqDTO) throws Exception{
		UserToken user = reqDTO.getUserToken();
		Map map = reqDTO.toMap();//������
		String flag=map.get("flag").toString();//�����޸�ɾ��
		String org_id = (String) map.get("org_id");//��֯����
		String org_subjection_id="";//��֯��������
		Map oMap = jdbcDao.queryRecordBySQL("select org_subjection_id from comm_org_subjection where org_id = '"+org_id+"' and bsflag = '0' ");
		if (MapUtils.isNotEmpty(oMap)) {
			org_subjection_id=oMap.get("org_subjection_id").toString();
		}
		String project_info_no="";//��Ŀ����
		if("add".equals(flag)){
			//��ѯ��ǰ���װ��ģ����Ŀ����
			Calendar a=Calendar.getInstance();
			int cYear=a.get(Calendar.YEAR);
			Map pMap = jdbcDao.queryRecordBySQL("select count(*) as proj_count from gp_task_project where bsflag = '2' and project_year ='"+cYear+"'");
			Integer proj_count=Integer.parseInt(pMap.get("proj_count").toString())+1;
			String project_id="zbxnxm-"+cYear+"-"+proj_count;
			map.put("project_id", project_id);//ģ����Ŀ���
			map.put("bsflag", "2");//ģ����Ŀ
			map.put("creator", user.getEmpId());//������
			map.put("create_date", new Date());//����ʱ��
			map.put("updator", user.getEmpId());//�޸���
			map.put("modifi_date", new Date());//�޸�ʱ��
			project_info_no = (String)jdbcDao.saveOrUpdateEntity(map,"gp_task_project");//������Ŀ����Ϣ
		}else{
			project_info_no=map.get("project_info_no").toString();
			map.put("updator", user.getEmpId());//�޸���
			map.put("modifi_date", new Date());//�޸�ʱ��
			jdbcDao.saveOrUpdateEntity(map,"gp_task_project");//������Ŀ����Ϣ
			//ɾ����Ŀ��̬����Ϣ
			jdbcDao.executeUpdate("delete from gp_task_project_dynamic where project_info_no='"+project_info_no+"'");
		}
		//������Ŀ��̬��Ϣ
		Map dMap=new HashMap();
		dMap.put("project_info_no", project_info_no);//��Ŀ����
		dMap.put("org_id", org_id);//��֯����
		dMap.put("org_subjection_id", org_subjection_id);//��֯��������
		dMap.put("bsflag", "2");//ģ����Ŀ
		dMap.put("creator", user.getEmpId());//������
		dMap.put("create_date", new Date());//����ʱ��
		dMap.put("updator", user.getEmpId());//�޸���
		dMap.put("modifi_date", new Date());//�޸�ʱ��
		jdbcDao.saveOrUpdateEntity(dMap,"gp_task_project_dynamic");//������Ŀ��̬����Ϣ
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		return responseDTO;
	}	
	/**
	 * ɾ��ģ����Ŀ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteModeProj(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteModeProj");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String delFlag = "0";
		String proInfoNo = isrvmsg.getValue("project_info_no");// ��Ŀid
		try{
			String appSql = "select accdui.dev_acc_id from gms_device_account_dui accdui"
						  + " where accdui.project_info_id = '"+proInfoNo+"'"
						  + " union all"
						  + " select colldui.dev_acc_id"
						  + " from gms_device_coll_account_dui colldui"
						  + " where colldui.project_info_id = '"+proInfoNo+"'";
			List<Map> checkResult = jdbcDao.queryRecords(appSql);
			if (checkResult.size() >= 1) {
				delFlag = "1";// �Ӽ�̨�˻������豸(������Ŀת����ʽ��Ŀ���豸������)
			}else{
				String appSql1 = "select mix.device_mixinfo_id from gms_device_mixinfo_form mix"
						   + " left join gp_task_project pro on mix.project_info_no = pro.project_info_no"
						   + " where mix.state = '9' and mix.bsflag = '0' and pro.bsflag = '2'"
						   + " and mix.opr_state != '9' and mix.opr_state != '4' and mix.project_info_no = '"+proInfoNo+"'"
						   + " union all"
						   + " select cmf.device_mixinfo_id from gms_device_collmix_form cmf"
						   + " left join gp_task_project tp on cmf.project_info_no = tp.project_info_no"
						   + " where cmf.state = '9' and cmf.bsflag = '0' and tp.bsflag = '2'"
						   + " and cmf.opr_state != '9' and cmf.opr_state != '4' and cmf.project_info_no = '"+proInfoNo+"'";
				List<Map> checkResult1 = jdbcDao.queryRecords(appSql1);
				if (checkResult1.size() >= 1) {
					delFlag = "2";// �Ƿ��е����к�δ����ĵ���
				}else{
					String appSql2 = "select devapp.device_app_id from gms_device_collapp devapp"
					  	   + " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id and wfmiddle.bsflag = '0'"
					  	   + " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
					  	   + " where devapp.bsflag = '0' and devapp.mix_org_type = '1' and pro.bsflag = '2'"
					  	   + " and wfmiddle.proc_status != '3' and wfmiddle.proc_status != '4' and devapp.project_info_no = '"+proInfoNo+"'"
					  	   + " union all"
					  	   + " select devapp.device_app_id from gms_device_app devapp"
					  	   + " left join common_busi_wf_middle wfmiddle on wfmiddle.business_id = devapp.device_app_id and wfmiddle.bsflag = '0'"
					  	   + " left join gp_task_project pro on devapp.project_info_no = pro.project_info_no"
					  	   + " where devapp.bsflag = '0' and devapp.mix_org_type = '1'"
					  	   + " and (devapp.mix_type_id = 'S1404' or devapp.mix_type_id = 'S0623' or devapp.mix_type_id = 'S0622')"
					  	   + " and pro.bsflag = '2' and wfmiddle.proc_status != '3' and wfmiddle.proc_status != '4' and devapp.project_info_no = '"+proInfoNo+"'";

					List<Map> checkResult2 = jdbcDao.queryRecords(appSql2);
					if (checkResult2.size() >= 1) {
						delFlag = "4";// �ж��Ƿ���δ�ύ�ʹ������ĵ���
					}
				}
			}			
		}catch(Exception e){
			delFlag = "3";
		}
		if("0".equals(delFlag)){
			//ɾ����Ŀ��̬��
			String delSql = "update gp_task_project_dynamic dy set dy.bsflag = '"+DevConstants.BSFLAG_DELETE+"',"
					      + " updator='"+user.getEmpId()+"',modifi_date=sysdate,"
					      + " dy.notes = '"+DevConstants.PROJECT_DELXN_MAN+"' where dy.project_info_no='"+proInfoNo+"'";
			jdbcDao.executeUpdate(delSql);
			//ɾ����Ŀ��
			String delSql2 = "update gp_task_project pro set pro.bsflag = '"+DevConstants.BSFLAG_DELETE+"',"
					 	   + " updator='"+user.getEmpId()+"',modifi_date=sysdate,"
					       + " pro.notes = '"+DevConstants.PROJECT_DELXN_MAN+"' where pro.project_info_no='"+proInfoNo+"'";
			jdbcDao.executeUpdate(delSql2);
		}
		responseDTO.setValue("datas", delFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �жϵ���Ŀ���������Ƿ����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg collRecvFlag(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String recvFlag = "0";
		String recvState = "";
		String deviceOifSubId = msg.getValue("deviceoifsubid");
		try{
			String appSql = "select sub.receive_state from gms_device_coll_outsub sub"
						  + " where sub.device_oif_subid = '"+deviceOifSubId+"' ";
			Map appMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(appMap)){
				recvState = appMap.get("receive_state").toString();
				if("0".equals(recvState)){
					recvFlag = "1";//�ɼ��豸δ����
				}else if("1".equals(recvState)){
					recvFlag = "2";//�ɼ��豸�ѽ���
				}
			}else{
				recvFlag = "3";//����ʧ��
			}
		}catch(Exception e){
			recvFlag = "3";//����ʧ��
		}
		responseDTO.setValue("datas", recvFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �жϼ첨���Ƿ����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg jbqRecvFlag(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String recvFlag = "0";
		String recvState = "";
		String deviceMixSubId = msg.getValue("devicemixsubid");
		try{
			String appSql = "select nvl(t.state,'0') state from gms_device_appmix_main t"
						  + " where t.device_mix_subid = '"+deviceMixSubId+"' ";
			Map appMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(appMap)){
				recvState = appMap.get("state").toString();
				if("0".equals(recvState)){
					recvFlag = "1";//�첨��δ����
				}else if("9".equals(recvState)){
					recvFlag = "2";//�첨���ѽ���
				}
			}else{
				recvFlag = "3";//����ʧ��
			}
		}catch(Exception e){
			recvFlag = "3";//����ʧ��
		}
		responseDTO.setValue("datas", recvFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ���������չ�����
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkCollMainInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
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
		String projectName = msg.getValue("projectname");
		String oprStateDesc = msg.getValue("oprstatedesc");
		String deviceBackAppNo = msg.getValue("devicebackappno");
		String backOrgName = msg.getValue("backorgname");
		StringBuffer querySql = new StringBuffer();
			querySql.append("select case when length(gp.project_name) > 16 then substr(gp.project_name, 0, 16) || '...'"
					+ " else gp.project_name end as proname,"
					+ " case when length(collback.backapp_name) > 16 then substr(collback.backapp_name, 0, 16) || '...'"
					+ " else collback.backapp_name end as backappname,t.device_coll_mixinfo_id,gp.project_name,"
					+ " t.device_mixapp_no,collback.device_backapp_no,collback.backapp_name,"
					+ " i.org_abbreviation as back_org_name,org.org_abbreviation as receive_org_name,"
					+ " mixorg.org_abbreviation as mix_org_name,emp.employee_name,collback.backdate,"
					+ " case t.opr_state when '1' then '������' when '2' then '����δ����' when '9' then '�Ѵ���' else 'δ����' end as oprstate_desc"
					+ " from gms_device_coll_backinfo_form t"
					+ " left join gp_task_project gp on t.project_info_id = gp.project_info_no"
					+ " left join gms_device_collbackapp collback on t.device_backapp_id = collback.device_backapp_id and collback.bsflag = '0'"
					+ " left join comm_org_information i on collback.back_org_id = i.org_id and i.bsflag = '0'"
					+ " left join comm_human_employee emp on collback.back_employee_id = emp.employee_id"
					+ " left join comm_org_information org on t.receive_org_id = org.org_id and org.bsflag = '0'"
					+ " left join comm_org_information mixorg on t.backmix_org_id = mixorg.org_id and mixorg.bsflag = '0'"
					+ " left join comm_org_subjection orgsub on orgsub.org_id = t.receive_org_id and orgsub.bsflag = '0'"
					+ " where t.state = '9' and t.bsflag = '0' and t.back_dev_type = 'S9000'"
					+ " and orgsub.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
					//���δ����̽���Ĳɼ��豸���գ������̽��Ϊ�����Ĳɼ��豸���ղ˵�
					+ " and orgsub.org_subjection_id not like 'C105007%'");
		//��Ŀ����
		if (StringUtils.isNotBlank(projectName)) {
			querySql.append(" and gp.project_name like '%"+projectName+"%'");
		}
		//���봦��״̬
		if (StringUtils.isNotBlank(oprStateDesc)) {
			querySql.append(" and t.opr_state = '"+oprStateDesc+"' ");
		}
		//�������뵥��
		if (StringUtils.isNotBlank(deviceBackAppNo)) {
			querySql.append(" and collback.device_backapp_no like '%"+deviceBackAppNo+"%'");
		}
		//������λ����
		if (StringUtils.isNotBlank(backOrgName)) {
			querySql.append(" i.org_abbreviation like '%"+backOrgName+"%'");
		}
		
		querySql.append(" order by t.opr_state nulls first,collback.backdate desc,t.device_coll_mixinfo_id ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ���������չ�����(ȥ��gms_device_coll_backinfo_form����������ǰ����)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkCollBackMainInfo(ISrvMsg msg) throws Exception {
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
		String backDevType = msg.getValue("backdevtype");
		String orgSubId = msg.getValue("orgsubid");
		String oprState = msg.getValue("oprstate");
		String backAppInfoNo = msg.getValue("backappinfono");
		String backOrgName = msg.getValue("backorgname");
		String projectName = msg.getValue("projectname");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
			querySql.append("select * from(select 'back' as backtype,backapp.backdevtype,backapp.backapp_name,pro.project_name,backapp.device_backapp_id,"
					+ " backapp.device_backapp_no,backapp.project_info_id,backapp.back_org_id,backapp.receive_org_id,"
					+ " backorg.org_abbreviation as backorgname,reorg.org_abbreviation as rcvorgname,reorg.org_name,"
					+ " case backapp.opr_state when '1' then '������' when '9' then '�Ѵ���' when '2' then '����δ����'"
					+ " else 'δ����' end as oprstate_desc,emp.employee_name as back_username,"
					+ " to_char(backapp.backdate, 'yyyy-mm-dd') as backappdate,backapp.opr_state"
					+ " from gms_device_collbackapp backapp"
					+ " left join comm_org_information backorg on backapp.back_org_id = backorg.org_id and backorg.bsflag = '0'"
					+ " left join comm_human_employee emp on backapp.back_employee_id = emp.employee_id"
					+ " left join gp_task_project pro on backapp.project_info_id = pro.project_info_no"
					+ " left join comm_org_subjection orgsub on backapp.receive_org_id = orgsub.org_id and orgsub.bsflag = '0'"
					+ " left join comm_org_information reorg on reorg.org_id = backapp.receive_org_id and reorg.bsflag = '0'"
					+ " where backapp.bsflag = '0' and backapp.state = '9' and backapp.backdevtype = 'S9000'"
					+ " and backapp.backapptype = '4' and backapp.receive_org_id is not null"					
					+ " and orgsub.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
					+ " union all"
					+ " select 'mix' as backtype,collback.backdevtype,collback.backapp_name,gp.project_name,"
					+ " t.device_coll_mixinfo_id,collback.device_backapp_no,collback.project_info_id,"
					+ " t.back_org_id,t.receive_org_id,i.org_abbreviation as backorgname,org.org_abbreviation as rcvorgname,org.org_name,"
					+ " case t.opr_state when '1' then '������' when '2' then '����δ����' when '9' then'�Ѵ���'"
					+ " else 'δ����' end as oprstate_desc,emp.employee_name as back_username,"
					+ " to_char(collback.backdate, 'yyyy-mm-dd') as backappdate,t.opr_state"
					+ " from gms_device_coll_backinfo_form t"
					+ " left join gp_task_project gp on t.project_info_id = gp.project_info_no"
					+ " left join gms_device_collbackapp collback on t.device_backapp_id = collback.device_backapp_id and collback.bsflag = '0'"
					+ " left join comm_org_information i on collback.back_org_id = i.org_id and i.bsflag = '0'"
					+ " left join comm_human_employee emp on collback.back_employee_id = emp.employee_id"
					+ " left join comm_org_information org on t.receive_org_id = org.org_id and org.bsflag = '0'"
					+ " left join comm_org_information mixorg on t.backmix_org_id = mixorg.org_id and mixorg.bsflag = '0'"
					+ " left join comm_org_subjection orgsub on orgsub.org_id = t.receive_org_id and orgsub.bsflag = '0'"
					+ " where t.state = '9' and t.bsflag = '0' and t.back_dev_type = 'S9000'"
					+ " and orgsub.org_subjection_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
					//���δ����̽���Ĳɼ��豸���գ������̽��Ϊ�����Ĳɼ��豸���ղ˵�
					+ " and orgsub.org_subjection_id not like 'C105007%' ) where 1=1 ");
			//����״̬
			if (StringUtils.isNotBlank(oprState)) {
				if("1".equals(oprState)){//������
					querySql.append(" and opr_state = '1' ");
				}else if("9".equals(oprState)){//�Ѵ���
					querySql.append(" and opr_state = '9' ");
				}else if("2".equals(oprState)){//����δ����
					querySql.append(" and opr_state = '2' ");
				}else{//δ����
					querySql.append(" and opr_state = '0' ");
				}
			}
			//��������
			if (StringUtils.isNotBlank(backAppInfoNo)) {
				querySql.append(" and device_backapp_no like '%"+backAppInfoNo+"%'");
			}
			//������λ����
			if (StringUtils.isNotBlank(backOrgName)) {
				querySql.append(" and org_name like '%"+backOrgName+"%'");
			}
			//��Ŀ����
			if (StringUtils.isNotBlank(projectName)) {
				querySql.append(" and project_name like '%"+projectName+"%'");
			}		
			if(StringUtils.isNotBlank(sortField)){
				querySql.append(" order by "+sortField+" "+sortOrder+" ");
			}else{
				querySql.append(" order by opr_state nulls first,backappdate desc");
			}		
			page = pureDao.queryRecordsBySQL(querySql.toString(), page);
			List list = page.getData();
			responseDTO.setValue("datas", list);
			responseDTO.setValue("totalRows", page.getTotalRow());
			responseDTO.setValue("pageSize", pageSize);
			return responseDTO;
	}
	/**
	 * NEWMETHOD ������������������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCheckCollBaseInfo(ISrvMsg msg) throws Exception {
		String devCollMixInfoId = msg.getValue("devicebackappid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select t.device_coll_mixinfo_id,gp.project_name,t.device_mixapp_no,collback.device_backapp_no,"
						 + " collback.backapp_name,i.org_abbreviation as back_org_name,org.org_abbreviation as receive_org_name,"
	    				 + " mixorg.org_abbreviation as mix_org_name,emp.employee_name,collback.backdate,"
	    	             + " case t.opr_state when '1' then '������' when '9' then '�Ѵ���' when '2' then '����δ����' else 'δ����' end as oprstate_desc"
	    				 + " from gms_device_coll_backinfo_form t"
	    				 + " left join gp_task_project gp on t.project_info_id=gp.project_info_no and gp.bsflag='0'"
	    				 + " left join gms_device_collbackapp collback on t.device_backapp_id = collback.device_backapp_id and collback.bsflag='0'"
	    				 + " left join comm_org_information i on collback.back_org_id = i.org_id and i.bsflag = '0'"
	    				 + " left join comm_human_employee emp on collback.back_employee_id = emp.employee_id"
	    				 + " left join comm_org_information org on t.receive_org_id= org.org_id and org.bsflag='0'"
	    				 + " left join comm_org_information mixorg on t.backmix_org_id =mixorg.org_id and mixorg.bsflag='0'"
						 + " where t.state = '9' and t.bsflag = '0' and t.device_coll_mixinfo_id = '"+devCollMixInfoId+"' ");
		Map devCheckMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devCheckMap)) {
			responseMsg.setValue("data", devCheckMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD �������չ�������ϸ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkCollDetail(ISrvMsg msg) throws Exception {
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
		String devCollMixInfoId = msg.getValue("devicebackappid");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();	
		querySql.append("select t.device_coll_backdet_id as account_id,backdet.dev_name,backdet.dev_model,sd.coding_name as unit_name,"
			 	   + " t.back_num,acc.total_num,acc.unuse_num,acc.use_num, acc.actual_in_time,backdet.planning_out_time"
			 	   + " from gms_device_coll_back_detail t"
			       + " left join gms_device_collbackapp_detail backdet on t.device_backdet_id = backdet.device_backdet_id"
			       + " left join gms_device_coll_account_dui acc on backdet.dev_acc_id = acc.dev_acc_id"
			       + " left join comm_coding_sort_detail sd on acc.dev_unit = sd.coding_code_id"
				   + " where t.device_coll_mixinfo_id = '"+devCollMixInfoId+"'");
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by backdet.create_date desc,t.device_coll_backdet_id");
		}
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �жϵ��������չ������Ƿ��Ѵ���
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg collCheckFlag(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String checkFlag = "0";
		String checkState = "";
		String devCollMixInfoId = msg.getValue("devicecollmixinfoid");
		String backType  = msg.getValue("backtype");
		String appSql = "";
		try{
			if(DevUtil.isValueNotNull(backType, "back")){
				appSql = "select opr_state from gms_device_collbackapp"
						  + " where device_backapp_id = '"+devCollMixInfoId+"' ";
			}else{
				appSql = "select opr_state from gms_device_coll_backinfo_form"
						  + " where device_coll_mixinfo_id = '"+devCollMixInfoId+"' ";
			}
			Map appMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(appMap)){
				checkState = appMap.get("opr_state").toString();
				if("0".equals(checkState)){
					checkFlag = "1";//����δ����
				}else{
					checkFlag = "2";//�����Ѵ���
				}
			}else{
				checkFlag = "3";//����ʧ��
			}
		}catch(Exception e){
			checkFlag = "3";//����ʧ��
		}
		responseDTO.setValue("datas", checkFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �޸����յ�λ����ʾ��������
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollModOrgMainInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devCollMixInfoId = msg.getValue("devicecollmixinfoid");
		String backType = msg.getValue("backtype");
		StringBuffer sb = new StringBuffer();
		if(DevUtil.isValueNotNull(backType, "back")){//����ֱ�����ղ���Ҫ����gms_device_coll_backinfo_form
			sb.append("select gp.project_name,t.device_backapp_no,t.backapp_name,"
					 + " i.org_abbreviation as back_org_name,org.org_abbreviation as receive_org_name,"
					 + " t.backdate,t.receive_org_id"
					 + " from gms_device_collbackapp t"
					 + " left join gp_task_project gp on t.project_info_id=gp.project_info_no and gp.bsflag='0'"
					 + " left join comm_org_information i on t.back_org_id = i.org_id and i.bsflag = '0'"
					 + " left join comm_org_information org on t.receive_org_id= org.org_id and org.bsflag='0'"
					 + " where t.device_backapp_id = '"+devCollMixInfoId+"' ");
		}else{//ԭ�����豸����������Ҫ����gms_device_coll_backinfo_form
			sb.append("select gp.project_name,collback.device_backapp_no,collback.backapp_name,"
					 + " i.org_abbreviation as back_org_name,org.org_abbreviation as receive_org_name,"
					 + " collback.backdate,t.receive_org_id"
					 + " from gms_device_coll_backinfo_form t"
					 + " left join gp_task_project gp on t.project_info_id=gp.project_info_no and gp.bsflag='0'"
					 + " left join gms_device_collbackapp collback on t.device_backapp_id = collback.device_backapp_id and collback.bsflag='0'"
					 + " left join comm_org_information i on collback.back_org_id = i.org_id and i.bsflag = '0'"
					 + " left join comm_org_information org on t.receive_org_id= org.org_id and org.bsflag='0'"
					 + " where t.device_coll_mixinfo_id = '"+devCollMixInfoId+"' ");
		}		
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mainMap)) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD ���������չ�������ϸ��ʾҳ��
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkCollDetInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
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
		String devCollMixinfoid = msg.getValue("devicecollmixinfoid");
		String devCiName = msg.getValue("devciname");
		String devCiModel = msg.getValue("devcimodel");
		StringBuffer querySql = new StringBuffer();
			querySql.append("select t.device_coll_backdet_id,t.back_num as mix_num,acc.dev_name,acc.dev_model,"
					+ " case t.is_leaving when '0' then 'δ����' when '1' then '������' when '2' then '������'"
					+ " when '3' then '������' end as isleaving,"
					+ " acc.dev_unit,acc.total_num,acc.unuse_num,acc.use_num,acc.actual_in_time,"
					+ " unitsd.coding_name as dev_unit_name,t.in_date as alter_date"
					+ " from gms_device_coll_back_detail t"
					+ " left join gms_device_coll_account_dui acc on t.dev_acc_id2 = acc.dev_acc_id"
					+ " left join comm_coding_sort_detail unitsd on acc.dev_unit = unitsd.coding_code_id"
					+ " where t.device_coll_mixinfo_id = '"+devCollMixinfoid+"' ");
		//�豸����
		if (StringUtils.isNotBlank(devCiName)) {
			querySql.append(" and acc.dev_name like '%"+devCiName+"%'");
		}
		//�豸�ͺ�
		if (StringUtils.isNotBlank(devCiModel)) {
			querySql.append(" and acc.dev_model like '%"+devCiModel+"%'");
		}
		
		querySql.append(" order by t.is_leaving nulls first,t.device_coll_backdet_id ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����������ϸ��������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCheckCollDetInfo(ISrvMsg msg) throws Exception {
		String devCollBackDetId = msg.getValue("devicecollbackdetid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select t.device_coll_backdet_id,t.back_num as mix_num,acc.dev_name,acc.dev_model,"
						+ " case t.is_leaving when '0' then 'δ����' when '1' then '������' end as isleaving,"
					    + " acc.dev_unit,acc.total_num,acc.unuse_num,acc.use_num,acc.actual_in_time,"
					    + " backdet.planning_out_time,unitsd.coding_name as dev_unit_name"
					    + " from gms_device_coll_back_detail t"
					    + " left join gms_device_collbackapp_detail backdet on t.device_backdet_id = backdet.device_backdet_id"
					    + " left join gms_device_coll_account_dui acc on backdet.dev_acc_id = acc.dev_acc_id"
					    + " left join comm_coding_sort_detail unitsd on acc.dev_unit = unitsd.coding_code_id "
						+ " where t.device_coll_backdet_id = '"+devCollBackDetId+"'");
		Map devDetMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devDetMap)) {
			responseMsg.setValue("devDetMap", devDetMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD �������չ�������ϸ��Ϣ������¼�Ļ�����Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkCollDetailInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devCollBackDetId = msg.getValue("devicecollbackdetid");
		String sql = "select firm.good_num,firm.torepair_num,firm.tocheck_num,firm.destroy_num,"
				   + " firm.noreturn_num,firm.create_date as check_date,emp.employee_name"
				   + " from gms_device_coll_account_firm firm"
				   + " left join comm_human_employee emp on firm.creator = emp.employee_id"
				   + " where firm.device_backdet_id = '"+devCollBackDetId+"'"
				   + " order by create_date desc";
		List<Map> detList= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", detList);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �жϵ�������������ϸ�Ƿ�����
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg collCheckDetFlag(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String checkFlag = "";
		String devCollBackDetId = msg.getValue("devicecollbackdetid");
		try{
			String appSql = "select is_leaving from gms_device_coll_back_detail"
						  + " where device_coll_backdet_id = '"+devCollBackDetId+"' ";
			Map appMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(appMap)){
				checkFlag = appMap.get("is_leaving").toString();
				if(checkFlag.equals("3")){
					checkFlag = "0";
				}
			}else{
				checkFlag = "3";//����ʧ��
			}
		}catch(Exception e){
			checkFlag = "3";//����ʧ��
		}
		responseDTO.setValue("datas", checkFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����������ϸ��Ϣ��д��ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCheckCollFillInfo(ISrvMsg msg) throws Exception {
		String devCollBackDetId = msg.getValue("devicecollbackdetid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select outacc.dev_acc_id as acc_dev_acc_id,accdui.dev_acc_id as dui_dev_acc_id,acc.dev_acc_id as back_dev_acc_id,"
						+ " backdet.dev_name,backdet.dev_model,tech.tech_id as back_tech_id,backdet.back_num,outtech.tech_id as acc_tech_id,"
				    	+ " backdet.devremark,t.back_num as mixnum,t.device_coll_mixinfo_id,unitsd.coding_name as dev_unit_name,"
				    	+ " outacc.device_id,outacc.type_id,accdui.dev_unit,apporg.org_id as apporg_id,apporg.org_abbreviation as apporg_name,"
				    	+ " f.receive_org_id as revorg_id,usesub.org_subjection_id as usage_sub_id,revorg.org_abbreviation as revorg_name,"
				    	+ " app.project_info_id as project_info_no,outacc.owning_org_id as owning_org_id,ownorg.org_abbreviation as owning_org_name,"
				    	+ " ownsub.org_subjection_id as owning_sub_id,accdui.out_org_id,oldorg.org_abbreviation as oldorg_name,"
				    	+ " nvl(outtech.good_num, 0) as bk_good_num,nvl(outtech.touseless_num, 0) as bk_touseless_num,"
				    	+ " nvl(outtech.torepair_num, 0) as bk_torepair_num,nvl(outtech.tocheck_num, 0) as bk_tocheck_num,"
				    	+ " nvl(outtech.destroy_num, 0) as bk_destroy_num,nvl(outtech.noreturn_num, 0) as bk_noreturn_num,"
				    	+ " nvl(tech.good_num,0) as good_num,nvl(tech.touseless_num,0)as touseless_num,"//ԭ����
				    	+ " nvl(tech.torepair_num,0) as torepair_num,nvl(tech.tocheck_num,0) as tocheck_num,nvl(tech.destroy_num,0) as destroy_num,"
				    	+ " nvl(tech.noreturn_num,0) as noreturn_num,app.device_backapp_no,nvl(in_num,0) as in_num "
				    	+ " from gms_device_coll_back_detail t"
				    	+ " left join gms_device_coll_backinfo_form backfor on t.device_coll_mixinfo_id = backfor.device_coll_mixinfo_id"
				    	+ " left join gms_device_collbackapp_detail backdet on t.device_backdet_id = backdet.device_backdet_id"
				    	+ " left join gms_device_collbackapp app on app.device_backapp_id = backdet.device_backapp_id"
				    	+ " left join comm_org_information apporg on app.back_org_id = apporg.org_id and apporg.bsflag = '0'"//�������뵥λ
				    	+ " left join gms_device_coll_account_dui accdui on backdet.dev_acc_id = accdui.dev_acc_id"
				    	+ " left join comm_coding_sort_detail unitsd on accdui.dev_unit = unitsd.coding_code_id"
				    	+ " left join comm_org_information oldorg on accdui.out_org_id = oldorg.org_id and oldorg.bsflag = '0'"//ת����λ��ԭ���ڵ�λ
				    	+ " left join gms_device_coll_account acc on accdui.device_id = acc.device_id and acc.ifcountry != '����'"
				    	+ " and acc.bsflag = '0' and backfor.receive_org_id = acc.usage_org_id "//��˾��̨��ʹ��״̬
				    	+ " left join gms_device_coll_account_tech tech on tech.dev_acc_id = acc.dev_acc_id"
				    	+ " left join gms_device_coll_account outacc on accdui.fk_dev_acc_id = outacc.dev_acc_id "//��˾��̨��ʹ��״̬
				    	+ " left join gms_device_coll_account_tech outtech on outtech.dev_acc_id = outacc.dev_acc_id"
				    	+ " left join gms_device_coll_backinfo_form f on t.device_coll_mixinfo_id = f.device_coll_mixinfo_id"
				    	+ " left join comm_org_information revorg on f.receive_org_id = revorg.org_id and revorg.bsflag = '0'"//��˾��̨�˼���״��
				    	+ " left join comm_org_subjection usesub on f.receive_org_id = usesub.org_id and usesub.bsflag = '0'"
				    	+ " left join comm_org_information ownorg on outacc.owning_org_id = ownorg.org_id and ownorg.bsflag = '0'"
				    	+ " left join comm_org_subjection ownsub on outacc.owning_org_id = ownsub.org_id and ownsub.bsflag = '0' "
						+ " where t.device_coll_backdet_id = '"+devCollBackDetId+"'");
		Map devFillMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devFillMap)) {
			responseMsg.setValue("devFillMap", devFillMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD ���ռ첨����ϸ��Ϣ��д��ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCheckJBQFillInfo(ISrvMsg msg) throws Exception {
		String devBackDetId = msg.getValue("devbackdetid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select acc.dev_acc_id as acc_dev_acc_id,backdet.dev_acc_id as dui_dev_acc_id,backdet.dev_name,backdet.dev_model, backdet.back_num,"
						+ " tech.tech_id,acc.device_id,acc.type_id,apporg.org_id as apporg_id,apporg.org_abbreviation as apporg_name,"
				    	+ " app.receive_org_id as revorg_id,revsub.org_subjection_id as revsub_id,revorg.org_abbreviation  as revorg_name,"
				    	+ " app.project_info_id,accdui.out_org_id,outorg.org_abbreviation as oldorg_name,nvl(acc.total_num,0) as old_total_num,"
				    	+ " nvl(acc.unuse_num,0) as old_unusing_num,nvl(acc.use_num,0) as old_using_num,nvl(acc.other_num,0) as old_other_num,"
				    	+ " nvl(tech.good_num,0) as old_good_num,nvl(tech.torepair_num,0) as old_torepair_num,nvl(tech.tocheck_num,0) as old_tocheck_num,"
				    	+ " nvl(tech.destroy_num,0) as old_destroy_num,nvl(backdet.checked_num, 0) as checked_num,app.device_backapp_id,"
				    	+ " backdet.device_backdet_id,det.coding_name as dev_unit_name"
				    	+ " from gms_device_collbackapp_detail backdet"
				    	+ " left join gms_device_collbackapp app on app.device_backapp_id = backdet.device_backapp_id"
				    	+ " left join comm_org_information apporg on app.back_org_id = apporg.org_id and apporg.bsflag = '0'"
				    	+ " left join gms_device_coll_account_dui accdui on backdet.dev_acc_id = accdui.dev_acc_id"
				    	+ " left join comm_org_information outorg on accdui.out_org_id = outorg.org_id and outorg.bsflag = '0'"
				    	+ " left join gms_device_coll_account acc on accdui.fk_dev_acc_id = acc.dev_acc_id"
				    	+ " left join comm_coding_sort_detail det on det.coding_code_id = acc.dev_unit"
				    	+ " left join gms_device_coll_account_tech tech on tech.dev_acc_id = acc.dev_acc_id"
				    	+ " left join comm_org_information revorg on app.receive_org_id = revorg.org_id and revorg.bsflag = '0'"
				    	+ " left join comm_org_subjection revsub on revsub.org_id = app.receive_org_id and revsub.bsflag = '0'"
						+ " where backdet.device_backdet_id = '"+devBackDetId+"'");
		Map devFillMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devFillMap)) {
			responseMsg.setValue("devFillMap", devFillMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD ��������������ϸ��Ϣ��д��ʾ(ȥ��gms_device_coll_backinfo_form)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollCheckFillInfo(ISrvMsg msg) throws Exception {
		String devBackDetId = msg.getValue("devbackdetid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select outacc.dev_acc_id as acc_dev_acc_id,accdui.dev_acc_id as dui_dev_acc_id,acc.dev_acc_id as back_dev_acc_id,"
						+ " t.dev_name,t.dev_model,tech.tech_id as back_tech_id,t.back_num,outtech.tech_id as acc_tech_id,"
				    	+ " t.devremark,t.back_num as mixnum,t.device_backapp_id,unitsd.coding_name as dev_unit_name,"
				    	+ " outacc.device_id,outacc.type_id,accdui.dev_unit,apporg.org_id as apporg_id,apporg.org_abbreviation as apporg_name,"
				    	+ " f.receive_org_id as revorg_id,usesub.org_subjection_id as usage_sub_id,revorg.org_abbreviation as revorg_name,"
				    	+ " app.project_info_id as project_info_no,outacc.owning_org_id as owning_org_id,ownorg.org_abbreviation as owning_org_name,"
				    	+ " ownsub.org_subjection_id as owning_sub_id,accdui.out_org_id,oldorg.org_abbreviation as oldorg_name,"
				    	+ " nvl(outtech.good_num, 0) as bk_good_num,nvl(outtech.touseless_num, 0) as bk_touseless_num,"
				    	+ " nvl(outtech.torepair_num, 0) as bk_torepair_num,nvl(outtech.tocheck_num, 0) as bk_tocheck_num,"
				    	+ " nvl(outtech.destroy_num, 0) as bk_destroy_num,nvl(outtech.noreturn_num, 0) as bk_noreturn_num,"
				    	+ " nvl(tech.good_num,0) as good_num,nvl(tech.touseless_num,0)as touseless_num,"//ԭ����
				    	+ " nvl(tech.torepair_num,0) as torepair_num,nvl(tech.tocheck_num,0) as tocheck_num,nvl(tech.destroy_num,0) as destroy_num,"
				    	+ " nvl(tech.noreturn_num,0) as noreturn_num,app.device_backapp_no,nvl(t.checked_num,0) as in_num "
				    	+ " from gms_device_collbackapp_detail t"
				    	+ " left join gms_device_collbackapp app on app.device_backapp_id = t.device_backapp_id"
				    	+ " left join comm_org_information apporg on app.back_org_id = apporg.org_id and apporg.bsflag = '0'"
				    	+ " left join gms_device_coll_account_dui accdui on t.dev_acc_id = accdui.dev_acc_id"
				    	+ " left join comm_coding_sort_detail unitsd on accdui.dev_unit = unitsd.coding_code_id"
				    	+ " left join comm_org_information oldorg on accdui.out_org_id = oldorg.org_id and oldorg.bsflag = '0'"
				    	+ " left join gms_device_coll_account acc on accdui.device_id = acc.device_id and acc.ifcountry != '����'"
				    	+ " and acc.bsflag = '0' and app.receive_org_id = acc.usage_org_id"
				    	+ " left join gms_device_coll_account_tech tech on tech.dev_acc_id = acc.dev_acc_id"
				    	+ " left join gms_device_coll_account outacc on accdui.fk_dev_acc_id = outacc.dev_acc_id"
				    	+ " left join gms_device_coll_account_tech outtech on outtech.dev_acc_id = outacc.dev_acc_id"
				    	+ " left join gms_device_collbackapp f on t.device_backapp_id = f.device_backapp_id"
				    	+ " left join comm_org_information revorg on f.receive_org_id = revorg.org_id and revorg.bsflag = '0'"
				    	+ " left join comm_org_subjection usesub on f.receive_org_id = usesub.org_id and usesub.bsflag = '0'"
				    	+ " left join comm_org_information ownorg on outacc.owning_org_id = ownorg.org_id and ownorg.bsflag = '0'"
				    	+ " left join comm_org_subjection ownsub on outacc.owning_org_id = ownsub.org_id and ownsub.bsflag = '0'"
						+ " where t.device_backdet_id = '"+devBackDetId+"'");
		Map devFillMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devFillMap)) {
			responseMsg.setValue("devFillMap", devFillMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD ������������δ������ϸ��Ϣ��д��ʾ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCheckCollNoRetFillInfo(ISrvMsg msg) throws Exception {
		String devCollBackDetId = msg.getValue("devicecollbackdetid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select outacc.dev_acc_id as acc_dev_acc_id,accdui.dev_acc_id as dui_dev_acc_id,acc.dev_acc_id as back_dev_acc_id,"
						+ " backdet.dev_name,backdet.dev_model,tech.tech_id as back_tech_id,backdet.is_leaving,"
						+ " outtech.tech_id as acc_tech_id,t.back_num as mixnum,t.device_coll_mixinfo_id,unitsd.coding_name as dev_unit_name,"
				    	+ " outacc.device_id,outacc.type_id,accdui.dev_unit,apporg.org_id as apporg_id,apporg.org_abbreviation as apporg_name,"
				    	+ " f.receive_org_id as revorg_id,usesub.org_subjection_id as usage_sub_id,revorg.org_abbreviation as revorg_name,"
				    	+ " app.project_info_id as project_info_no,outacc.owning_org_id as owning_org_id,ownorg.org_abbreviation as owning_org_name,"
				    	+ " ownsub.org_subjection_id as owning_sub_id,accdui.out_org_id,oldorg.org_abbreviation as oldorg_name,"
				    	+ " nvl(outtech.good_num, 0) as bk_good_num,nvl(outtech.touseless_num, 0) as bk_touseless_num,nvl(in_num,0) as in_num,"
				    	+ " nvl(outtech.torepair_num, 0) as bk_torepair_num,nvl(outtech.tocheck_num, 0) as bk_tocheck_num,"
				    	+ " nvl(outtech.destroy_num, 0) as bk_destroy_num,nvl(outtech.noreturn_num, 0) as bk_noreturn_num,"
				    	+ " nvl(tech.good_num,0) as good_num,nvl(tech.touseless_num,0)as touseless_num,nvl(tech.torepair_num,0) as torepair_num,"//ԭ����
				    	+ " nvl(tech.tocheck_num,0) as tocheck_num,nvl(tech.destroy_num,0) as destroy_num,nvl(tech.noreturn_num,0) as noreturn_num,"
				    	+ " nvl(firm.good_num, 0) as firm_good_num,nvl(firm.torepair_num, 0) as firm_torepair_num,nvl(firm.tocheck_num, 0) as firm_tocheck_num,"
				    	+ " nvl(firm.destroy_num, 0) as firm_destroy_num,nvl(firm.noreturn_num, 0) as firm_noreturn_num,app.device_backapp_no "
				    	+ " from gms_device_coll_back_detail t"
				    	+ " left join gms_device_coll_backinfo_form backfor on t.device_coll_mixinfo_id = backfor.device_coll_mixinfo_id"
				    	+ " left join gms_device_collbackapp_detail backdet on t.device_backdet_id = backdet.device_backdet_id"
				    	+ " left join gms_device_collbackapp app on app.device_backapp_id = backdet.device_backapp_id"
				    	+ " left join comm_org_information apporg on app.back_org_id = apporg.org_id and apporg.bsflag = '0'"//�������뵥λ
				    	+ " left join gms_device_coll_account_dui accdui on backdet.dev_acc_id = accdui.dev_acc_id"
				    	+ " left join comm_coding_sort_detail unitsd on accdui.dev_unit = unitsd.coding_code_id"
				    	+ " left join comm_org_information oldorg on accdui.out_org_id = oldorg.org_id and oldorg.bsflag = '0'"//ת����λ��ԭ���ڵ�λ
				    	+ " left join gms_device_coll_account acc on accdui.device_id = acc.device_id and acc.ifcountry != '����'"
				    	+ " and acc.bsflag = '0' and backfor.receive_org_id = acc.usage_org_id "//��˾��̨��ʹ��״̬
				    	+ " left join gms_device_coll_account_tech tech on tech.dev_acc_id = acc.dev_acc_id"
				    	+ " left join gms_device_coll_account outacc on accdui.fk_dev_acc_id = outacc.dev_acc_id "//��˾��̨��ʹ��״̬
				    	+ " left join gms_device_coll_account_tech outtech on outtech.dev_acc_id = outacc.dev_acc_id"
				    	+ " left join gms_device_coll_backinfo_form f on t.device_coll_mixinfo_id = f.device_coll_mixinfo_id"
				    	+ " left join comm_org_information revorg on f.receive_org_id = revorg.org_id and revorg.bsflag = '0'"//��˾��̨�˼���״��
				    	+ " left join comm_org_subjection usesub on f.receive_org_id = usesub.org_id and usesub.bsflag = '0'"
				    	+ " left join comm_org_information ownorg on outacc.owning_org_id = ownorg.org_id and ownorg.bsflag = '0'"
				    	+ " left join comm_org_subjection ownsub on outacc.owning_org_id = ownsub.org_id and ownsub.bsflag = '0'"
				    	+ " left join gms_device_coll_account_firm firm on firm.device_backdet_id = t.device_coll_backdet_id"
						+ " where t.device_coll_backdet_id = '"+devCollBackDetId+"' order by firm.create_date desc");
		Map devFillMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devFillMap)) {
			responseMsg.setValue("devFillMap", devFillMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD ������������δ������ϸ��Ϣ��д��ʾ(ȥ��gms_device_coll_backinfo_form)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCollCheckNoRetFillInfo(ISrvMsg msg) throws Exception {
		String devBackDetId = msg.getValue("devbackdetid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
				.append("select * from(select outacc.dev_acc_id as acc_dev_acc_id,accdui.dev_acc_id as dui_dev_acc_id,acc.dev_acc_id as back_dev_acc_id,"
						+ " t.dev_name,t.dev_model,tech.tech_id as back_tech_id,t.back_num,outtech.tech_id as acc_tech_id,"
				    	+ " t.devremark,t.device_backapp_id,unitsd.coding_name as dev_unit_name,"
				    	+ " outacc.device_id,outacc.type_id,accdui.dev_unit,apporg.org_id as apporg_id,apporg.org_abbreviation as apporg_name,"
				    	+ " f.receive_org_id as revorg_id,usesub.org_subjection_id as usage_sub_id,revorg.org_abbreviation as revorg_name,"
				    	+ " app.project_info_id as project_info_no,outacc.owning_org_id as owning_org_id,ownorg.org_abbreviation as owning_org_name,"
				    	+ " ownsub.org_subjection_id as owning_sub_id,accdui.out_org_id,oldorg.org_abbreviation as oldorg_name,"
				    	+ " nvl(outtech.good_num, 0) as bk_good_num,nvl(outtech.touseless_num, 0) as bk_touseless_num,"
				    	+ " nvl(outtech.torepair_num, 0) as bk_torepair_num,nvl(outtech.tocheck_num, 0) as bk_tocheck_num,"
				    	+ " nvl(outtech.destroy_num, 0) as bk_destroy_num,nvl(outtech.noreturn_num, 0) as bk_noreturn_num,"
				    	+ " nvl(tech.good_num,0) as good_num,nvl(tech.touseless_num,0)as touseless_num,"//ԭ����
				    	+ " nvl(tech.torepair_num,0) as torepair_num,nvl(tech.tocheck_num,0) as tocheck_num,nvl(tech.destroy_num,0) as destroy_num,"
				    	+ " nvl(tech.noreturn_num,0) as noreturn_num,app.device_backapp_no,nvl(t.checked_num,0) as checked_num,"
				    	+ " nvl(firm.good_num, 0) as firm_good_num,nvl(firm.torepair_num, 0) as firm_torepair_num,"
				    	+ " nvl(firm.tocheck_num, 0) as firm_tocheck_num,nvl(firm.destroy_num, 0) as firm_destroy_num,"
				    	+ " nvl(firm.noreturn_num, 0) as firm_noreturn_num"
				    	+ " from gms_device_collbackapp_detail t"
				    	+ " left join gms_device_collbackapp app on app.device_backapp_id = t.device_backapp_id"
				    	+ " left join comm_org_information apporg on app.back_org_id = apporg.org_id and apporg.bsflag = '0'"
				    	+ " left join gms_device_coll_account_dui accdui on t.dev_acc_id = accdui.dev_acc_id"
				    	+ " left join comm_coding_sort_detail unitsd on accdui.dev_unit = unitsd.coding_code_id"
				    	+ " left join comm_org_information oldorg on accdui.out_org_id = oldorg.org_id and oldorg.bsflag = '0'"
				    	+ " left join gms_device_coll_account acc on accdui.device_id = acc.device_id and acc.ifcountry != '����'"
				    	+ " and acc.bsflag = '0' and app.receive_org_id = acc.usage_org_id"
				    	+ " left join gms_device_coll_account_tech tech on tech.dev_acc_id = acc.dev_acc_id"
				    	+ " left join gms_device_coll_account outacc on accdui.fk_dev_acc_id = outacc.dev_acc_id"
				    	+ " left join gms_device_coll_account_tech outtech on outtech.dev_acc_id = outacc.dev_acc_id"
				    	+ " left join gms_device_collbackapp f on t.device_backapp_id = f.device_backapp_id"
				    	+ " left join comm_org_information revorg on f.receive_org_id = revorg.org_id and revorg.bsflag = '0'"
				    	+ " left join comm_org_subjection usesub on f.receive_org_id = usesub.org_id and usesub.bsflag = '0'"
				    	+ " left join comm_org_information ownorg on outacc.owning_org_id = ownorg.org_id and ownorg.bsflag = '0'"
				    	+ " left join comm_org_subjection ownsub on outacc.owning_org_id = ownsub.org_id and ownsub.bsflag = '0'"
				    	+ " left join gms_device_coll_account_firm firm on firm.device_backdet_id = t.device_backdet_id"
						+ " where t.device_backdet_id = '"+devBackDetId+"' order by firm.create_date desc ) WHERE ROWNUM = 1");
		Map devFillMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devFillMap)) {
			responseMsg.setValue("devFillMap", devFillMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD �豸̨�������豸ʱ���ж�
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addDevFlag(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String addFlag = "0";
		String devSign = msg.getValue("devsign");
		String owningSubId = msg.getValue("owningsubid");
		String devType = msg.getValue("devtype");
		String accountStat = msg.getValue("accountstat");
		String devAccId = msg.getValue("devaccid");
		try{
			String appSql = "select dev_acc_id from gms_device_account"
						  + " where dev_sign = '"+devSign+"' and owning_sub_id like '"+owningSubId+"%'"
						  + " and dev_type = '"+devType+"' and bsflag = '0'";
			//�޸��豸�Ǳ���ʵ���ʶ���ظ�����
			if(DevUtil.isValueNotNull(devAccId)){
				appSql += " and dev_acc_id != '"+devAccId+"'";
			}
			Map appMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(appMap)){
				addFlag = "1";//��ʵ���ʶ���豸����
			}
		}catch(Exception e){
			addFlag = "3";//��ѯʧ��
		}
		responseDTO.setValue("datas", addFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ѯ�豸�������Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevMainInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devAccId = msg.getValue("devaccid");
		StringBuffer sb = new StringBuffer()
			.append( "select acc.dev_acc_id,acc.dev_type,acc.dev_name, acc.dev_model,acc.dev_sign,acc.self_num,acc.cont_num,"
					  + " acc.account_stat,accstat.coding_name as account_stat_name,acc.asset_coding,acc.license_num,acc.engine_num,"
					  + " acc.chassis_num,acc.owning_org_id,acc.owning_sub_id,ownorg.org_abbreviation as owning_org_name_desc,"
					  + " case acc.ifcountry when '����' then '0' when '����' then '1' else '0' end as ifcountry_desc,"
					  + " acc.ifcountry,acc.usage_org_id,acc.usage_sub_id,usageorg.org_abbreviation as usage_org_name_desc,"
					  + " acc.using_stat,acc.tech_stat,acc.remark,acc.spare1,acc.spare2,acc.spare3,techstat.coding_name as techstat_desc"
					  + " from gms_device_account acc"
					  + " left join comm_coding_sort_detail accstat on accstat.coding_code_id = acc.account_stat"
					  + " left join comm_org_information ownorg on ownorg.org_id = acc.owning_org_id and ownorg.bsflag = '0'"
					  + " left join comm_org_information usageorg on usageorg.org_id = acc.usage_org_id and usageorg.bsflag = '0'"
					  + " left join comm_coding_sort_detail techstat on techstat.coding_code_id = acc.tech_stat"
				      + " where acc.dev_acc_id = '"+devAccId+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (mainMap != null) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	//����Ŀ��ҳ�ճ����ͳ��
			public ISrvMsg queryWXTJ(ISrvMsg msg) throws Exception {
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
				String dev_type = msg.getValue("dev_type");// ���뵥��
				String startdate = msg.getValue("startdate");
				String enddate= msg.getValue("enddate");
				String dev_team=msg.getValue("dev_team");
				String sortField = msg.getValue("sort");
				String sortOrder = msg.getValue("order");
				StringBuffer querySql = new StringBuffer();
				querySql.append("with ");
				//�豸������Ϣ
						querySql.append(" temp as (select ");
						querySql.append(" rownum,to_char(tt01.celiangDate,'yyyy-mm-dd') as start_date,to_char(nvl(tp.project_end_time, tp.acquire_end_time),'yyyy-mm-dd') as end_date,acc.dev_acc_id,acc.dev_type,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,oprtbl.operator_name,acc.actual_in_time,acc.actual_out_time,acc.remark,acc.stop_date,teamsd.coding_name as team_name");
						querySql.append(" from gms_device_account_dui acc ");
						querySql.append(" left join gms_device_account_dui dui on acc.dev_acc_id = dui.dev_acc_id");
						querySql.append(" left join (select device_account_id,operator_name from ( ");
						querySql.append("      select tmp.device_account_id,tmp.operator_name,row_number() ");
						querySql.append("      over(partition by device_account_id order by length(operator_name) desc ) as seq  ");
						querySql.append("      from (select device_account_id,wmsys.wm_concat(operator_name) ");
						querySql.append("      over(partition by device_account_id order by operator_name) as operator_name ");
						querySql.append("      from gms_device_equipment_operator where BSFLAG='0' and PROJECT_INFO_ID='"+user.getProjectInfoNo()+"') tmp ) tmp2 where tmp2.seq=1) oprtbl  on acc.dev_acc_id = oprtbl.device_account_id ");
						querySql.append(" left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = acc.dev_team");
						querySql.append(" left join  GP_TASK_PROJECT tp on ");
						querySql.append("  tp.project_info_no = acc.project_info_id");
						querySql.append("  and tp.BSFLAG = '0'");
						querySql.append("  and tp.PROJECT_TYPE = '5000100004000000001'");
						querySql.append("  and tp.PROJECT_NAME not like '%��Ŀ�ƻ�ģ��%'");
						querySql.append(" left join (select min(dai.PRODUCE_DATE) as celiangDate,");
						querySql.append("                    dai.PROJECT_INFO_NO");
						querySql.append("               from GP_OPS_DAILY_REPORT dai");
						querySql.append("               left join GP_OPS_DAILY_PRODUCE_SIT sit");
						querySql.append("                 on dai.DAILY_NO = sit.DAILY_NO");
						querySql.append("                and sit.BSFLAG = '0'");
						querySql.append("               left join COMMON_BUSI_WF_MIDDLE wf");
						querySql.append("                 on dai.PROJECT_INFO_NO = wf.BUSINESS_ID");
						querySql.append("                and wf.BSFLAG = '0'");
						querySql.append("              where dai.BSFLAG = '0'");
						querySql.append("                and wf.PROC_STATUS = '3'");
						querySql.append("                and sit.SURVEY_PROCESS_STATUS = '2'");
						querySql.append("              group by dai.PROJECT_INFO_NO) tt01");
						querySql.append("    on tt01.PROJECT_INFO_NO = acc.project_info_id ");
						querySql.append(" where acc.bsflag='0'");
						querySql.append("and acc.dev_team='"+dev_team+"' and  acc.account_stat!='0110000013000000005' and (acc.dev_type like 'S0601%' or acc.dev_type like 'S0622%' or acc.dev_type like 'S0623%' ");
						querySql.append("          or acc.dev_type like 'S07010101%' or acc.dev_type like 'S070301%' ");
						querySql.append("          or acc.dev_type like 'S0801%' or acc.dev_type like 'S0802%' or acc.dev_type like 'S0803%' or acc.dev_type like 'S0804%' ");
						querySql.append("          or acc.dev_type like 'S080503%' or acc.dev_type like 'S080504%' or acc.dev_type like 'S080601%' or acc.dev_type like 'S080604%' ");
						querySql.append("          or acc.dev_type like 'S080607%' or acc.dev_type like 'S090101%')");
						querySql.append(" and  acc.project_info_id='"+	user.getProjectInfoNo()+"'  and acc.actual_in_time<=to_date('"+enddate+"','yyyy-MM-dd')),");
						//ά�޷���");
						querySql.append("wx as ( ");
						querySql.append("select device_account_id,sum(material_cost) wx_total_money from (select   A.DEVICE_ACCOUNT_ID,A.MATERIAL_COST ");
						querySql.append("  from BGP_COMM_DEVICE_REPAIR_INFO a ");
						querySql.append(" where a.repair_level <> '605' ");
						querySql.append(" and a.create_date<= to_date('"+enddate+"','yyyy-MM-dd') and a.create_date>= to_date('"+startdate+"','yyyy-MM-dd') and  a.project_info_no='"+	user.getProjectInfoNo()+"'");
						querySql.append(" order by a.repair_start_date desc)  group by device_account_id) ");
						querySql.append("select temp.dev_name,dev_model,self_num,license_num,dev_sign,operator_name,wx.* from  temp  ");
						querySql.append(" left join wx");
						querySql.append(" on temp.dev_acc_id=wx.device_account_id where wx.wx_total_money>0");
						if(StringUtils.isNotBlank(sortField)){
							querySql.append(" order by "+sortField+" "+sortOrder+" ");
						}else{
							querySql.append(" 	order by wx.wx_total_money desc ");
						}
					
	          page = pureDao.queryRecordsBySQL(querySql.toString(), page);
						List docList = page.getData();
						responseDTO.setValue("datas", docList);
						responseDTO.setValue("totalRows", page.getTotalRow());
						responseDTO.setValue("pageSize", pageSize);
						return responseDTO;
			} 
	//����Ŀ��ҳ�ճ����ͳ��
		public ISrvMsg queryRCJCTJ(ISrvMsg msg) throws Exception {
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
			String dev_type = msg.getValue("dev_type");// ���뵥��
			String startdate = msg.getValue("startdate");
			String enddate= msg.getValue("enddate");
			String dev_team=msg.getValue("dev_team");
			String sortField = msg.getValue("sort");
			String sortOrder = msg.getValue("order");
			StringBuffer querySql = new StringBuffer();
	 
			//�豸������Ϣ
					querySql.append("  select t3.*,(t3.nums-t3.num_zc) nums_zg from ( select count(t1.dev_acc_id)num_zc,t2.dev_name,t2.dev_model,t2.license_num,t2.self_num,t2.dev_sign,t2.nums from gms_device_inspectioin t1 inner join (select * from ( select  temp.dev_name,dev_model,self_num,license_num,dev_sign, n.dev_acc_id,count(n.dev_acc_id) nums ");
					querySql.append("  from gms_device_inspectioin n ");
					querySql.append("  left join gms_device_account_dui temp ");
					querySql.append("    on temp.dev_acc_id = n.dev_acc_id ");
					querySql.append(" where n.INSPECTIOIN_TIME<= to_date('"+enddate+"','yyyy-MM-dd') and n.INSPECTIOIN_TIME>= to_date('"+startdate+"','yyyy-MM-dd') and temp.dev_team='"+dev_team+"' and  n.bsflag = '0' ");
					querySql.append("   and n.type = '3' ");
					querySql.append(" and temp.project_info_id='"+	user.getProjectInfoNo()+"'  and temp.actual_in_time<=to_date('"+enddate+"','yyyy-MM-dd')");
							querySql.append(" group by n.dev_acc_id,dev_name,dev_model,license_num,self_num,dev_sign) )t2  on    t1.dev_acc_id=t2.dev_acc_id where  t1.modification_content is null  and t1.bsflag = '0' and t1.type = '3'and  t1.INSPECTIOIN_TIME <=to_date('"+enddate+"','yyyy-MM-dd') and t1.INSPECTIOIN_TIME >=to_date('"+startdate+"','yyyy-MM-dd')    group by t1.dev_acc_id,dev_name, dev_model,license_num,self_num,dev_sign,nums ) t3");
							
							if(StringUtils.isNotBlank(sortField)){
								querySql.append(" order by "+sortField+" "+sortOrder+" ");
							}else{
								querySql.append(" 	  order by nums desc ");
							}
							page = pureDao.queryRecordsBySQL(querySql.toString(), page);
					List docList = page.getData();
					responseDTO.setValue("datas", docList);
					responseDTO.setValue("totalRows", page.getTotalRow());
					responseDTO.setValue("pageSize", pageSize);
					return responseDTO;
		} 
	//����Ŀ��������ͳ��ͼ
	public ISrvMsg queryOilTJ(ISrvMsg msg) throws Exception {
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
		String dev_type = msg.getValue("dev_type");// ���뵥��
		String startdate = msg.getValue("startdate");
		String enddate= msg.getValue("enddate");
		String dev_team=msg.getValue("dev_team");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("with ");
		//�豸������Ϣ
				querySql.append(" temp as (select ");
				querySql.append(" rownum,to_char(tt01.celiangDate,'yyyy-mm-dd') as start_date,to_char(nvl(tp.project_end_time, tp.acquire_end_time),'yyyy-mm-dd') as end_date,acc.dev_acc_id,acc.dev_type,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,oprtbl.operator_name,acc.actual_in_time,acc.actual_out_time,acc.remark,acc.stop_date,teamsd.coding_name as team_name");
				querySql.append(" from gms_device_account_dui acc ");
				querySql.append(" left join gms_device_account_dui dui on acc.dev_acc_id = dui.dev_acc_id");
				querySql.append(" left join (select device_account_id,operator_name from ( ");
				querySql.append("      select tmp.device_account_id,tmp.operator_name,row_number() ");
				querySql.append("      over(partition by device_account_id order by length(operator_name) desc ) as seq  ");
				querySql.append("      from (select device_account_id,wmsys.wm_concat(operator_name) ");
				querySql.append("      over(partition by device_account_id order by operator_name) as operator_name ");
				querySql.append("      from gms_device_equipment_operator where BSFLAG='0' and PROJECT_INFO_ID='"+user.getProjectInfoNo()+"') tmp ) tmp2 where tmp2.seq=1) oprtbl  on acc.dev_acc_id = oprtbl.device_account_id ");
				querySql.append(" left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = acc.dev_team");
				querySql.append(" left join  GP_TASK_PROJECT tp on ");
				querySql.append("  tp.project_info_no = acc.project_info_id");
				querySql.append("  and tp.BSFLAG = '0'");
				querySql.append("  and tp.PROJECT_TYPE = '5000100004000000001'");
				querySql.append("  and tp.PROJECT_NAME not like '%��Ŀ�ƻ�ģ��%'");
				querySql.append(" left join (select min(dai.PRODUCE_DATE) as celiangDate,");
				querySql.append("                    dai.PROJECT_INFO_NO");
				querySql.append("               from GP_OPS_DAILY_REPORT dai");
				querySql.append("               left join GP_OPS_DAILY_PRODUCE_SIT sit");
				querySql.append("                 on dai.DAILY_NO = sit.DAILY_NO");
				querySql.append("                and sit.BSFLAG = '0'");
				querySql.append("               left join COMMON_BUSI_WF_MIDDLE wf");
				querySql.append("                 on dai.PROJECT_INFO_NO = wf.BUSINESS_ID");
				querySql.append("                and wf.BSFLAG = '0'");
				querySql.append("              where dai.BSFLAG = '0'");
				querySql.append("                and wf.PROC_STATUS = '3'");
				querySql.append("                and sit.SURVEY_PROCESS_STATUS = '2'");
				querySql.append("              group by dai.PROJECT_INFO_NO) tt01");
				querySql.append("    on tt01.PROJECT_INFO_NO = acc.project_info_id ");
				querySql.append(" where acc.bsflag='0'");
				querySql.append(" and acc.dev_team='"+dev_team+"' and   acc.account_stat!='0110000013000000005' and (acc.dev_type like 'S0601%' or acc.dev_type like 'S0622%' or acc.dev_type like 'S0623%' ");
				querySql.append("          or acc.dev_type like 'S07010101%' or acc.dev_type like 'S070301%' ");
				querySql.append("          or acc.dev_type like 'S0801%' or acc.dev_type like 'S0802%' or acc.dev_type like 'S0803%' or acc.dev_type like 'S0804%' ");
				querySql.append("          or acc.dev_type like 'S080503%' or acc.dev_type like 'S080504%' or acc.dev_type like 'S080601%' or acc.dev_type like 'S080604%' ");
				querySql.append("          or acc.dev_type like 'S080607%' or acc.dev_type like 'S090101%')");
				querySql.append(" and acc.project_info_id='"+	user.getProjectInfoNo()+"'  and acc.actual_in_time<=to_date('"+enddate+"','yyyy-MM-dd')),");
				//ȼ�ͷ���");
				querySql.append("oil as ( ");
				querySql.append("   select id1,  sum(total_money) oil_total_money,sum(oil_num) oil_num_total from (  ");
				querySql.append("        select d.dev_acc_id  id1,d.total_money,d.oil_num ");
				querySql.append("        from gms_mat_teammat_out t     ");
				querySql.append("        inner join GMS_MAT_TEAMMAT_OUT_DETAIL d     ");
				querySql.append("        inner join gms_mat_infomation i on d.wz_id=i.wz_id on t.teammat_out_id = d.teammat_out_id and t.bsflag='0'    ");
				querySql.append("        left join gp_task_project pro on t.project_info_no=pro.project_info_no     ");
				querySql.append("        where t.out_type='3' and d.create_date<= to_date('"+enddate+"','yyyy-MM-dd') and d.create_date>= to_date('"+startdate+"','yyyy-MM-dd') and d.project_info_no='"+	user.getProjectInfoNo()+"'   )  group by id1 ");
				querySql.append(" ), ");
				// ��ת��¼��Ϣ");
				querySql.append(" yzjl as (select dev_acc_id,COALESCE(mileage_total,drilling_footage_total,work_hour_total) yxsj from (select dev_acc_id,sum(mileage) mileage_total, ");
				querySql.append("       sum(drilling_footage) drilling_footage_total, ");
				querySql.append("       sum(work_hour) work_hour_total ");
				querySql.append("  from (select t.operation_info_id, ");
				querySql.append("               t.dev_acc_id, ");
				querySql.append("               t.modify_date, ");
				querySql.append("               round(t.mileage, 2) mileage, ");
				querySql.append("               ");
				querySql.append("               round(t.drilling_footage, 2) drilling_footage, ");
				querySql.append("               ");
				querySql.append("               round(t.work_hour, 2) work_hour ");
				querySql.append("        ");
				querySql.append("          from GMS_DEVICE_OPERATION_INFO t ");
				querySql.append("         where t.MODIFY_DATE<= to_date('"+enddate+"','yyyy-MM-dd') and t.MODIFY_DATE>= to_date('"+startdate+"','yyyy-MM-dd') and t.PROJECT_INFO_NO='"+	user.getProjectInfoNo()+"'");
				querySql.append("         ) group by dev_acc_id)) ");
				querySql.append("  select temp.dev_name,dev_model,self_num,license_num,dev_sign,operator_name,oil.*,yzjl.* from  temp ");
				querySql.append(" left join  oil ");
				querySql.append(" on oil.id1=temp.dev_acc_id ");
				querySql.append(" left join yzjl");
				querySql.append(" on temp.dev_acc_id=yzjl.dev_acc_id  where oil.oil_num_total>0 and yzjl.yxsj>0    ");
				if(StringUtils.isNotBlank(sortField)){
					querySql.append(" order by "+sortField+" "+sortOrder+" ");
				}else{
					querySql.append(" 	order by oil.oil_num_total desc,yzjl.yxsj  ");
				}
				
				page = pureDao.queryRecordsBySQL(querySql.toString(), page);
				List docList = page.getData();
				responseDTO.setValue("datas", docList);
				responseDTO.setValue("totalRows", page.getTotalRow());
				responseDTO.setValue("pageSize", pageSize);
				return responseDTO;
	} 
	/**
	 * �����豸��ѯ
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevTop(ISrvMsg msg) throws Exception {
		log.info("queryDevTop");
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
		String dev_type = msg.getValue("dev_type");// ���뵥��
		String startdate = msg.getValue("startdate");
		String enddate= msg.getValue("enddate");
		StringBuffer querySql = new StringBuffer();
		querySql.append("with ");
		//�豸������Ϣ
		querySql.append(" temp as (select ");
		querySql.append(" rownum,to_char(tt01.celiangDate,'yyyy-mm-dd') as start_date,to_char(nvl(tp.project_end_time, tp.acquire_end_time),'yyyy-mm-dd') as end_date,acc.dev_acc_id,acc.dev_type,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,oprtbl.operator_name,acc.actual_in_time,acc.actual_out_time,acc.remark,acc.stop_date,teamsd.coding_name as team_name");
		querySql.append(" from gms_device_account_dui acc ");
		querySql.append(" left join gms_device_account_dui dui on acc.dev_acc_id = dui.dev_acc_id");
		querySql.append(" left join (select device_account_id,operator_name from ( ");
		querySql.append("      select tmp.device_account_id,tmp.operator_name,row_number() ");
		querySql.append("      over(partition by device_account_id order by length(operator_name) desc ) as seq  ");
		querySql.append("      from (select device_account_id,wmsys.wm_concat(operator_name) ");
		querySql.append("      over(partition by device_account_id order by operator_name) as operator_name ");
		querySql.append("      from gms_device_equipment_operator  where BSFLAG='0' and PROJECT_INFO_ID='"+user.getProjectInfoNo()+"') tmp ) tmp2 where tmp2.seq=1) oprtbl  on acc.dev_acc_id = oprtbl.device_account_id ");
		querySql.append(" left join comm_coding_sort_detail teamsd on teamsd.coding_code_id = acc.dev_team");
		querySql.append(" left join  GP_TASK_PROJECT tp on ");
		querySql.append("  tp.project_info_no = acc.project_info_id");
		querySql.append("  and tp.BSFLAG = '0'");
		querySql.append("  and tp.PROJECT_TYPE = '5000100004000000001'");
		querySql.append("  and tp.PROJECT_NAME not like '%��Ŀ�ƻ�ģ��%'");
		querySql.append(" left join (select min(dai.PRODUCE_DATE) as celiangDate,");
		querySql.append("                    dai.PROJECT_INFO_NO");
		querySql.append("               from GP_OPS_DAILY_REPORT dai");
		querySql.append("               left join GP_OPS_DAILY_PRODUCE_SIT sit");
		querySql.append("                 on dai.DAILY_NO = sit.DAILY_NO");
		querySql.append("                and sit.BSFLAG = '0'");
		querySql.append("               left join COMMON_BUSI_WF_MIDDLE wf");
		querySql.append("                 on dai.PROJECT_INFO_NO = wf.BUSINESS_ID");
		querySql.append("                and wf.BSFLAG = '0'");
		querySql.append("              where dai.BSFLAG = '0'");
		querySql.append("                and wf.PROC_STATUS = '3'");
		querySql.append("                and sit.SURVEY_PROCESS_STATUS = '2'");
		querySql.append("              group by dai.PROJECT_INFO_NO) tt01");
		querySql.append("    on tt01.PROJECT_INFO_NO = acc.project_info_id ");
		querySql.append(" where acc.bsflag='0'");
		querySql.append(" and  acc.account_stat!='0110000013000000005' and (acc.dev_type like 'S0601%' or acc.dev_type like 'S0622%' or acc.dev_type like 'S0623%' ");
		querySql.append("          or acc.dev_type like 'S07010101%' or acc.dev_type like 'S070301%' ");
		querySql.append("          or acc.dev_type like 'S0801%' or acc.dev_type like 'S0802%' or acc.dev_type like 'S0803%' or acc.dev_type like 'S0804%' ");
		querySql.append("          or acc.dev_type like 'S080503%' or acc.dev_type like 'S080504%' or acc.dev_type like 'S080601%' or acc.dev_type like 'S080604%' ");
		querySql.append("          or acc.dev_type like 'S080607%' or acc.dev_type like 'S090101%')");
		querySql.append(" and acc.project_info_id='"+	user.getProjectInfoNo()+"'  and acc.actual_in_time<=to_date('"+enddate+"','yyyy-MM-dd')),");
		//�豸����");
		querySql.append("  kq as(select distinct  t.device_account_id, sum(case when t.timesheet_symbol='5110000041000000001' then 1 else 0 end) count1 , ");
		querySql.append(" sum(case when t.timesheet_symbol='5110000041000000002' then 1 else 0 end) count2, ");
		querySql.append("  sum(case when t.timesheet_symbol='5110000041000000003' then 1 else 0 end) count3 ");
		querySql.append("from (select distinct device_account_id,bsflag,timesheet_symbol,timesheet_date from BGP_COMM_DEVICE_TIMESHEET ) t ");
		querySql.append("where t.timesheet_date >= to_date('"+startdate+"','yyyy-MM-dd') ");
		querySql.append("and t.timesheet_date <= to_date('"+enddate+"','yyyy-MM-dd') ");
		querySql.append("and t.bsflag='0' ");
		querySql.append("group by  device_account_id), ");
		//�ƶ�̨����");
		querySql.append("  ts as (select dui.dev_acc_id , ");
		querySql.append("case when dui.actual_out_time between  to_date('"+startdate+"','yyyy-MM-dd') and to_date('"+enddate+"','yyyy-MM-dd') ");
		querySql.append(" and dui.actual_in_time<to_date('"+startdate+"','yyyy-MM-dd') ");
		querySql.append(" then dui.actual_out_time - to_date('"+startdate+"','yyyy-MM-dd') ");
		querySql.append(" when dui.actual_out_time<= to_date('"+enddate+"','yyyy-MM-dd')  ");
		querySql.append(" and dui.actual_in_time>= to_date('"+startdate+"','yyyy-MM-dd') ");
		querySql.append(" then dui.actual_out_time - dui.actual_in_time ");
		querySql.append("  when (dui.actual_out_time > to_date('"+enddate+"','yyyy-MM-dd') ");
		querySql.append(" or dui.actual_out_time is null )     ");
		querySql.append("and  dui.actual_in_time< to_date('"+startdate+"','yyyy-MM-dd') ");
		querySql.append(" then to_date('"+enddate+"','yyyy-MM-dd')-to_date('"+startdate+"','yyyy-MM-dd')+1 ");
		querySql.append("   when (dui.actual_out_time> to_date('"+enddate+"','yyyy-MM-dd') or dui.actual_out_time is null ) ");
		querySql.append(" and dui.actual_in_time between  to_date('"+startdate+"','yyyy-MM-dd') and to_date('"+enddate+"','yyyy-MM-dd') ");
		querySql.append(" then to_date('"+enddate+"','yyyy-MM-dd') - dui.actual_in_time +1 ");
		querySql.append("   else 0 ");
		querySql.append("   end as sumDate ");
		querySql.append(" from gms_device_account_dui dui ");
		querySql.append("where dui.bsflag='0' ");
		querySql.append("and dui.project_info_id ='"+	user.getProjectInfoNo()+"'), ");
		//ȼ�ͷ���");
		querySql.append("oil as ( ");
		querySql.append("   select id1,  sum(total_money) oil_total_money,sum(oil_num) oil_num_total from (  ");
		querySql.append("        select d.dev_acc_id  id1,d.total_money,d.oil_num ");
		querySql.append("        from gms_mat_teammat_out t     ");
		querySql.append("        inner join GMS_MAT_TEAMMAT_OUT_DETAIL d     ");
		querySql.append("        inner join gms_mat_infomation i on d.wz_id=i.wz_id on t.teammat_out_id = d.teammat_out_id and t.bsflag='0'    ");
		querySql.append("        left join gp_task_project pro on t.project_info_no=pro.project_info_no     ");
		querySql.append("        where t.out_type='3'  and d.oil_num!=0 and d.oil_num is not null and d.create_date<= to_date('"+enddate+"','yyyy-MM-dd') and d.create_date>= to_date('"+startdate+"','yyyy-MM-dd') and   d.project_info_no='"+	user.getProjectInfoNo()+"'   )  group by id1 ");
		querySql.append(" ), ");
		//ά�޷���");
		querySql.append("wx as ( ");
		querySql.append("select device_account_id,sum(material_cost) wx_total_money from (select   A.DEVICE_ACCOUNT_ID,A.MATERIAL_COST ");
		querySql.append("  from BGP_COMM_DEVICE_REPAIR_INFO a ");
		querySql.append(" where a.repair_level <> '605' ");
		querySql.append(" and a.create_date<= to_date('"+enddate+"','yyyy-MM-dd') and a.create_date>= to_date('"+startdate+"','yyyy-MM-dd') and  a.project_info_no='"+	user.getProjectInfoNo()+"'");
		querySql.append(" order by a.repair_start_date desc)  group by device_account_id), ");
		// ��ת��¼��Ϣ");
		querySql.append(" yzjl as (select * from (select dev_acc_id,sum(mileage) mileage_total, ");
		querySql.append("       sum(drilling_footage) drilling_footage_total, ");
		querySql.append("       sum(work_hour) work_hour_total ");
		querySql.append("  from (select t.operation_info_id, ");
		querySql.append("               t.dev_acc_id, ");
		querySql.append("               t.modify_date, ");
		querySql.append("               round(t.mileage, 2) mileage, ");
		querySql.append("               ");
		querySql.append("               round(t.drilling_footage, 2) drilling_footage, ");
		querySql.append("               ");
		querySql.append("               round(t.work_hour, 2) work_hour ");
		querySql.append("        ");
		querySql.append("          from GMS_DEVICE_OPERATION_INFO t ");
		querySql.append("         where  t.MODIFY_DATE<= to_date('"+enddate+"','yyyy-MM-dd') and t.MODIFY_DATE>= to_date('"+startdate+"','yyyy-MM-dd') and  t.PROJECT_INFO_NO='"+	user.getProjectInfoNo()+"'");
		querySql.append("         ) group by dev_acc_id) where   COALESCE(mileage_total,drilling_footage_total,work_hour_total)!=0), ");
		querySql.append(" fy as (");
		querySql.append("select * from ( select temp.dev_name,dev_model,self_num,license_num,dev_sign,operator_name,(select count(*) from BGP_COMM_DEVICE_ACCIDENT_INFO sg where sg.device_account_id=temp.dev_acc_id) sg,(count1+count3) wh,count1,count2,count3,trunc(nvl(((count1+count3)*100/decode(sumdate,0,null,sumdate )),0),2)  whl,trunc(nvl(((count1*100)/decode(sumdate,0,null,sumdate ) ),0),2)  lyl, oil.oil_total_money , wx.wx_total_money,yzjl.*,trunc(oil_num_total/mileage_total*100,2) c1,trunc(oil_num_total/drilling_footage_total*100,2) c2,trunc(oil_num_total/work_hour_total*100,2) c3" );
		querySql.append("  from temp ");
		querySql.append(" left join   kq  ");
		querySql.append(" on temp.dev_acc_id=kq.device_account_id");
		querySql.append(" left join  ts");
		querySql.append(" on temp.dev_acc_id=ts.dev_acc_id");
		querySql.append(" left join yzjl");
		querySql.append(" on temp.dev_acc_id=yzjl.dev_acc_id");
		querySql.append(" left join wx");
		querySql.append(" on wx.device_account_id=temp.dev_acc_id");
		querySql.append(" inner join oil");
		querySql.append(" on oil.id1=temp.dev_acc_id where 1=1");
		if(StringUtils.isNotBlank(dev_type)){
			querySql.append(" and temp.dev_type like '%"+dev_type+"%' ") ;
		}
		 querySql.append(" ) order by  nvl(mileage_total,0) desc , nvl(drilling_footage_total,0) desc, nvl(work_hour_total,0) desc)");
		 querySql.append(" select * from (select tttt.*,rank() over(order by wx_total_money desc) rn2,((newscore+rank() over(order by wx_total_money desc)*2)+TRUNC(whl*40/100)+TRUNC(lyl*40/100)) newscore2,lyl||'%' lyl1, whl||'%' whl1 from (select *");
		 querySql.append(" from (select ttt.*,rank() over(order by oil_total_money desc) rn1,");
		 querySql.append(" (score + rank() over(order by oil_total_money desc) * 2) newscore");
		 querySql.append(" from (SELECT *");
		 querySql.append("  FROM (SELECT A.*,");
		 querySql.append("               ROWNUM RN,");
		 querySql.append("                decode(operator_name, null, 0, 10) + (sg * -5) +");
		 querySql.append("                (ROWNUM * -2 + 42) score");
		 querySql.append("          FROM (select * from (fy)) A");
		 querySql.append("         WHERE ROWNUM <= 20)");
		 querySql.append("     WHERE RN >= 1) ttt");
		 querySql.append(" order by oil_total_money desc)");
		 querySql.append(" order by newscore desc ) tttt order by nvl(wx_total_money,0) desc) order by newscore2 desc ");

		log.info(querySql);
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ʾ�����豸(��̽��������̨��)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevAccData(ISrvMsg msg) throws Exception {
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
		String zhEquFlag = msg.getValue("zhequflag");//�Ƿ�Ϊ�ۺ��ﻯ̽
		String addEd = msg.getValue("added");//�Ƿ�Ϊ�����豸
		String collFlag = msg.getValue("collflag");//�Ƿ�Ϊװ������"��װ���������ѡ������װ�������豸
		String outOrgId = msg.getValue("outorgid");
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String selfNum = msg.getValue("selfnum");
		String devSign = msg.getValue("devsign");
		String licenseNum = msg.getValue("licensenum");
		String ownOrgName = msg.getValue("ownorgname");
		String devCoding = msg.getValue("devcoding");
		String assetCoding = msg.getValue("assetcoding");
		String objData = msg.getValue("objdata");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select org.org_abbreviation as own_org_name,acc.* from gms_device_account acc"
						+ " left join comm_org_information org on acc.owning_org_id = org.org_id and org.bsflag = '0' "
				 		+ " where acc.bsflag = '0' and saveflag = '0' "
				 		+ " and using_stat = '"+DevConstants.DEV_USING_XIANZHI+"'"
				 		+ " and tech_stat = '"+DevConstants.DEV_TECH_WANHAO+"'"
				 		+ " and (account_stat = '"+DevConstants.DEV_ACCOUNT_ZAIZHANG+"'"
				 		+ " or account_stat = '"+DevConstants.DEV_ACCOUNT_BUZAIZHANG+"'"
				 		+ " or (account_stat = '"+DevConstants.DEV_ACCOUNT_BAOFEI+"'"
				 		+ " and ifscrapleft = '"+DevConstants.IFSCRAPLEFT_FLAG_1+"'))");
		if(DevUtil.isValueNotNull(outOrgId)){
			if(DevUtil.isValueNotNull(zhEquFlag,"Y")){//�ۺ��ﻯ̽�����豸���������û���ʾ�豸���ʿ��豸
				querySql.append(" and (acc.owning_sub_id like 'C105008042%' or acc.owning_sub_id like 'C105008013%' ) ");
			}else{
				if(DevUtil.isValueNotNull(collFlag,"Y")){//װ������
					querySql.append(" and acc.owning_sub_id like 'C105006%' ");
				}else{
					querySql.append(" and acc.owning_sub_id like '"+outOrgId+"%' ");
				}
			}		
		}
		if(DevUtil.isValueNotNull(addEd,"Y")){//װ��Ҫ�󲹳��豸���ܳ���Դֻ���Ǹ����豸
			querySql.append(" and acc.dev_type not like 'S0623%' ");
		}
		//�豸����
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and acc.dev_name like '%"+devName+"%'");
		}
		//�豸�ͺ�
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and acc.dev_model like '%"+devModel+"%'");
		}
		//�Ա��
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and acc.self_num like '%"+selfNum+"%'");
		}
		//ʵ���ʶ��
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and acc.dev_sign like '%"+devSign+"%'");
		}
		//���պ�
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and acc.license_num like '%"+licenseNum+"%'");
		}
		//���ڵ�λ
		if (StringUtils.isNotBlank(ownOrgName)) {
			querySql.append(" and org.org_abbreviation like '%"+ownOrgName+"%'");
		}
		//ERP�豸���
		if (StringUtils.isNotBlank(devCoding)) {
			querySql.append(" and acc.dev_coding like '%"+devCoding+"%'");
		}
		//AMIS�ʲ����
		if (StringUtils.isNotBlank(assetCoding)) {
			querySql.append(" and acc.asset_coding like '%"+assetCoding+"%'");
		}
		if(DevUtil.isValueNotNull(objData)){
			querySql.append(" and acc.dev_acc_id not in("+objData+")");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+",acc.dev_acc_id ");
		}else{
			if(DevUtil.isValueNotNull(collFlag,"Y")){
				querySql.append(" order by case"
						+ " when dev_type like 'S0808%' then 1" 		//����
						+ " when dev_type like 'S14050101%' then 2"   //������������
						+ " when dev_type like 'S0623%' then 3"       //�ɿ���Դ
						+ " when dev_type like 'S1404%' then 4"       //�����豸
						+ " when dev_type like 'S060101%' then 5"     //��װ���
						+ " when dev_type like 'S060102%' then 6"     //��̧�����
						+ " when dev_type like 'S070301%' then 7"     //������
						+ " when dev_type like 'S0622%' then 8"       //������
						+ " when dev_type like 'S08%' then 9"         //�����豸
						+ " when dev_type like 'S0901%' then 10"      //�������
						+ " else 11 end,acc.dev_model,acc.dev_sign,acc.dev_acc_id ");
			}else{
				querySql.append(" order by case"
						+ " when dev_type like 'S08%' then 1" 		  //����
						+ " when dev_type like 'S070301%' then 2"     //������
						+ " when dev_type like 'S060101%' then 3"     //��װ���
						+ " when dev_type like 'S060102%' then 4"     //��̧�����
						+ " when dev_type like 'S0901%' then 5"       //�������
						+ " when dev_type like 'S1404%' then 6"       //�����豸
						+ " when dev_type like 'S14050101%' then 7"   //������������
						+ " when dev_type like 'S0623%' then 8"       //�ɿ���Դ
						+ " when dev_type like 'S0622%' then 9"       //������
						+ " else 10 end,acc.dev_model,acc.dev_sign,acc.dev_acc_id ");
			}
		}

		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ʾ�����豸(����Ŀ�豸��̨ת�ơ�)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevAccBackData(ISrvMsg msg) throws Exception {
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
		String zbFlag = msg.getValue("zbflag");//�Ƿ�Ϊװ��������Ա��¼
		String orgSubId = msg.getValue("orgsubid");
		String projectInfoNo = msg.getValue("projectinfono");
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String selfNum = msg.getValue("selfnum");
		String devSign = msg.getValue("devsign");
		String licenseNum = msg.getValue("licensenum");
		String devCoding = msg.getValue("devcoding");
		String objData = msg.getValue("objdata");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select account.dev_acc_id,account.asset_coding,account.dev_coding,"
						+ " account.self_num,account.dev_sign,account.license_num,account.actual_in_time,"
						+ " account.planning_out_time,account.dev_name,account.dev_model"
						+ " from gms_device_account_dui account"
						+ " left join gms_device_account acc on acc.dev_acc_id = account.fk_dev_acc_id and acc.bsflag = '0'"
						+ " where account.project_info_id = '"+projectInfoNo+"' and account.actual_out_time is null"
						+ " and (account.repair_state != '1' or account.repair_state is null)"
						+ " and account.bsflag='0' and account.is_leaving='0'"
						+ " and (account.transfer_state != '2' or account.transfer_state is null or account.transfer_state = '4') ");
		if(DevUtil.isValueNotNull(zbFlag,"Y")){
			querySql.append(" and acc.owning_sub_id like '"+orgSubId+"%' ");
		}	
		//�豸����
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and account.dev_name like '%"+devName+"%'");
		}
		//�豸�ͺ�
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and account.dev_model like '"+devModel+"%'");
		}
		//�Ա��
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and account.self_num like '%"+selfNum+"%'");
		}
		//ʵ���ʶ��
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and account.dev_sign like '%"+devSign+"%'");
		}
		//���պ�
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and account.license_num like '%"+licenseNum+"%'");
		}
		//ERP�豸���
		if (StringUtils.isNotBlank(devCoding)) {
			querySql.append(" and account.dev_coding like '%"+devCoding+"%'");
		}
		if(DevUtil.isValueNotNull(objData)){
			querySql.append(" and account.dev_acc_id not in("+objData+")");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by account.dev_type,account.license_num,account.self_num,account.dev_sign,account.dev_coding ");
		}

		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��̽�������豸�����޸Ĳ�����õ��䵥��Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDuiDevInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String devAccId = msg.getValue("devaccid");
		StringBuffer sb = new StringBuffer()
				.append("select dui.dev_name,dui.dev_model,dui.license_num,dui.self_num,"
					  + " dui.dev_sign,sd.coding_name as old_team_name,dui.actual_in_time"
					  + " from gms_device_account_dui dui"
					  + " left join comm_coding_sort_detail sd on dui.dev_team = sd.coding_code_id"
					  + " where dui.dev_acc_id = '"+devAccId+"' ");
		Map mainMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mainMap)) {
			responseDTO.setValue("mainMap", mainMap);
		}
		return responseDTO;
	}
	/**
	 * NEWMETHOD ����Ŀ�Ӽ�̨���豸�޸Ľ�����Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateDuiDevInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String devAccId = msg.getValue("devaccid");
		String realStartDate = msg.getValue("realstartdate");
		String accountStat = msg.getValue("accountstat");
		String devTeam = msg.getValue("team");

		Map mainMap = new HashMap();
		mainMap.put("dev_acc_id", devAccId);
		mainMap.put("dev_team", devTeam);
		mainMap.put("actual_in_time", realStartDate);
		mainMap.put("modifi_date", DevUtil.getCurrentTime());
		mainMap.put("modifier", user.getEmpId());
		//�����豸�ɸ��³��ƺš�ʵ���ʶ�š��Ա��
		if(accountStat.equals(DevConstants.DEV_ACCOUNT_WAIZU)){
			mainMap.put("license_num", msg.getValue("license_num"));
			mainMap.put("self_num", msg.getValue("self_num"));
			mainMap.put("dev_sign", msg.getValue("dev_sign"));
		}
		jdbcDao.saveOrUpdateEntity(mainMap, "gms_device_account_dui");

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ʾ�����豸(��̽�� ����������ʾ�ڶ��豸��)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryBackDevAccData(ISrvMsg msg) throws Exception {
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
		String backDevType = msg.getValue("backdevtype");
		String checkOrg = msg.getValue("checkorg");
		String projectInfoNo = msg.getValue("projectinfono");
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String selfNum = msg.getValue("selfnum");
		String devSign = msg.getValue("devsign");
		String licenseNum = msg.getValue("licensenum");
		String ownOrgName = msg.getValue("ownorgname");
		String devCoding = msg.getValue("devcoding");
		String objData = msg.getValue("objdata");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select dui.dev_acc_id,dui.asset_coding,dui.dev_coding,dui.self_num,dui.dev_model,"
						+ " dui.dev_sign,dui.license_num,dui.dev_name,dui.actual_in_time,dui.planning_out_time"
						+ " from gms_device_account_dui dui"
						+ " left join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id"
						+ " where dui.bsflag = '0' and dui.is_leaving = '0'"
						+ " and dui.project_info_id = '"+projectInfoNo+"'"
						+ " and dui.actual_out_time is null"
				 		+ " and dui.account_stat != '"+DevConstants.DEV_ACCOUNT_WAIZU+"' ");
		if(DevUtil.isValueNotNull(backDevType,DevConstants.MIXTYPE_YIQI)
				||DevUtil.isValueNotNull(backDevType,DevConstants.MIXTYPE_YIQI_FUSHU)
					||DevUtil.isValueNotNull(backDevType,DevConstants.MIXTYPE_ZHUANGBEI_DZYQ)){
			querySql.append(" and (dui.mix_type_id = '"+DevConstants.MIXTYPE_YIQI+"'"
						  + " or dui.mix_type_id = '"+DevConstants.MIXTYPE_YIQI_FUSHU+"'"
						  + " or dui.mix_type_id = '"+DevConstants.MIXTYPE_YIQICHE+"') ");
		}else if(DevUtil.isValueNotNull(backDevType,DevConstants.MIXTYPE_COMMON)
				|| DevUtil.isValueNotNull(backDevType,DevConstants.MIXTYPE_SWAP)){//�����豸���������豸
			querySql.append(" and dui.mix_type_id = '"+backDevType+"' ");
			
			if(DevUtil.isValueNotNull(checkOrg)){
				querySql.append(" and dui.owning_org_id = '"+checkOrg+"' ");
			}					 	  
		}else{
			querySql.append(" and dui.mix_type_id = '"+backDevType+"' ");
		}		
		//�豸����
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and dui.dev_name like '%"+devName+"%'");
		}
		//�豸�ͺ�
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and dui.dev_model like '"+devModel+"%'");
		}
		//�Ա��
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and dui.self_num like '%"+selfNum+"%'");
		}
		//ʵ���ʶ��
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and dui.dev_sign like '%"+devSign+"%'");
		}
		//���պ�
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and dui.license_num like '%"+licenseNum+"%'");
		}
		//ERP�豸���
		if (StringUtils.isNotBlank(devCoding)) {
			querySql.append(" and dui.dev_coding like '%"+devCoding+"%'");
		}
		if(DevUtil.isValueNotNull(objData)){
			querySql.append(" and dui.dev_acc_id not in("+objData+")");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+",dui.dev_acc_id ");
		}else{
			querySql.append(" order by dui.dev_type,dui.dev_acc_id ");
		}

		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}

	/**
	 * ��ÿɿ���Դ��������
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSparePartConsume(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// �Ա��
		String selfNums = reqDTO.getValue("selfNums");
		if(null==selfNums || StringUtils.isBlank(selfNums)){
			selfNums="";
		}
		String inSelectStr=StringUtil.getInSelectStr(selfNums);
		// ��ʼʱ��
		String startDate = reqDTO.getValue("startDate");
		if(null==startDate || StringUtils.isBlank(startDate)){
			startDate="";
		}
		// ����ʱ��
		String endDate = reqDTO.getValue("endDate");
		if(null==endDate || StringUtils.isBlank(endDate)){
			endDate="";
		}
		// ���
		String amount = reqDTO.getValue("amount");
		if(null==amount || StringUtils.isBlank(amount)){
			amount="";
		}
		StringBuilder sql = new StringBuilder(
				" select tmp3.bjlb_id as coding_code_id,tmp3.coding_name,nvl(t.use_num,0) as use_num  from ("
						+ " select tmp1.coding_code_id,sum(nvl(tmp1.use_num,0)) as use_num,sum(nvl(tmp1.use_num,0)*nvl(tmp2.actual_price,0)) as amount "
						+ " from (select zm.wxbymat_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,wb.bywx_date"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_wxbymat zm on wb.usemat_id = zm.usemat_id"
						+ " and zm.bsflag = '0' and zm.gz_bj_id is null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account acc on wb.dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.project_info_id is null and wb.usemat_id is not null"
						+ " union select zm.wxbymat_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,wb.bywx_date"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_wxbymat zm on wb.usemat_id = zm.usemat_id"
						+ " and zm.bsflag = '0' and zm.gz_bj_id is null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account_dui dui on wb.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1'"
						+ " inner join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.project_info_id is not null and wb.usemat_id is not null"
						+ " union select zm.wxbymat_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,wb.bywx_date"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_falut zf on wb.usemat_id = zf.usemat_id and zf.bsflag = '0'"
						+ " inner join gms_device_zy_wxbymat zm on zm.gz_bj_id = zf.gz_bj_id"
						+ " and zm.bsflag = '0' and zm.gz_bj_id is not null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account acc on wb.dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.usemat_id is not null and wb.project_info_id is null"
						+ " union select zm.wxbymat_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,wb.bywx_date"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_falut zf on wb.usemat_id = zf.usemat_id and zf.bsflag = '0'"
						+ " inner join gms_device_zy_wxbymat zm on zm.gz_bj_id = zf.gz_bj_id"
						+ " and zm.bsflag = '0' and zm.gz_bj_id is not null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account_dui dui on wb.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1'"
						+ " inner join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.usemat_id is not null and wb.project_info_id is not null) tmp1"
						+ " inner join (select distinct r.wz_id,case when r.actual_price is null then i.wz_price else r.actual_price end as actual_price"
						+ " from gms_mat_recyclemat_info r"
						+ " left join gms_mat_infomation i on i.wz_id = r.wz_id and i.bsflag = '0'"
						+ " where r.bsflag = '0' and r.wz_type = '3' and r.project_info_id is null) tmp2"
						+ " on tmp1.wz_id = tmp2.wz_id where 1=1");
		// �Ա��
		if(StringUtils.isNotBlank(inSelectStr)){
			sql.append(" and tmp1.self_num in " +inSelectStr);
		}
		// ��ʼʱ��
		if(StringUtils.isNotBlank(startDate)){
			sql.append(" and tmp1.bywx_date>=to_date('" + startDate + "','yyyy-mm-dd') ");
		}
		// ����ʱ��
		if(StringUtils.isNotBlank(endDate)){
			sql.append(" and tmp1.bywx_date<=to_date('" + endDate + "','yyyy-mm-dd') ");
		}
		// ����
		sql.append(" group by tmp1.coding_code_id ");
		// ���
		if(StringUtils.isNotBlank(amount)){
			sql.append(" having sum(nvl(tmp1.use_num,0)*nvl(tmp2.actual_price,0))>="+amount);
		}
		sql.append(" ) t right join (select rb.bjlb_id, sd.coding_name"
				+ " from gms_device_zy_gzdl_re_bjlb rb"
				+ " left join comm_coding_sort_detail sd on rb.bjlb_id = sd.coding_code_id and sd.bsflag = '0' and sd.coding_sort_id = '5110000188'"
				+ " where rb.bsflag = '0') tmp3 on t.coding_code_id=tmp3.bjlb_id");
		// ����
		sql.append(" order by tmp3.bjlb_id ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				set.addAttribute("label", map.get("coding_name").toString());
				set.addAttribute("value", map.get("use_num").toString());
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * ��ÿɿ���Դ��������by �ܳɼ�
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSparePartConsumeByZcj(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// �Ա��
		String selfNums = reqDTO.getValue("selfNums");
		if(null==selfNums || StringUtils.isBlank(selfNums)){
			selfNums="";
		}
		String inSelectStr=StringUtil.getInSelectStr(selfNums);
		// ��ʼʱ��
		String startDate = reqDTO.getValue("startDate");
		if(null==startDate || StringUtils.isBlank(startDate)){
			startDate="";
		}
		// ����ʱ��
		String endDate = reqDTO.getValue("endDate");
		if(null==endDate || StringUtils.isBlank(endDate)){
			endDate="";
		}
		// ���
		String amount = reqDTO.getValue("amount");
		if(null==amount || StringUtils.isBlank(amount)){
			amount="";
		}
		StringBuilder sql = new StringBuilder(
				" select tmp3.zcj_code_id as coding_code_id,tmp3.coding_name,nvl(t.use_num,0) as use_num  from ("
						+ " select tmp1.zcj_code_id,sum(nvl(tmp1.use_num,0)) as use_num,sum(nvl(tmp1.use_num,0)*nvl(tmp2.actual_price,0)) as amount "
						+ " from (select zm.wxbymat_id,zm.zcj_code_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,wb.bywx_date"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_wxbymat zm on wb.usemat_id = zm.usemat_id"
						+ " and zm.bsflag = '0' and zm.zcj_code_id is not null and zm.gz_bj_id is null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account acc on wb.dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.project_info_id is null and wb.usemat_id is not null"
						+ " union select zm.wxbymat_id,zm.zcj_code_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,wb.bywx_date"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_wxbymat zm on wb.usemat_id = zm.usemat_id"
						+ " and zm.bsflag = '0' and zm.zcj_code_id is not null and zm.gz_bj_id is null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account_dui dui on wb.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1'"
						+ " inner join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.project_info_id is not null and wb.usemat_id is not null"
						+ " union select zm.wxbymat_id,zm.zcj_code_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,wb.bywx_date"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_falut zf on wb.usemat_id = zf.usemat_id and zf.bsflag = '0'"
						+ " inner join gms_device_zy_wxbymat zm on zm.gz_bj_id = zf.gz_bj_id"
						+ " and zm.bsflag = '0' and zm.zcj_code_id is not null and zm.gz_bj_id is not null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account acc on wb.dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.usemat_id is not null and wb.project_info_id is null"
						+ " union select zm.wxbymat_id,zm.zcj_code_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,wb.bywx_date"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_falut zf on wb.usemat_id = zf.usemat_id and zf.bsflag = '0'"
						+ " inner join gms_device_zy_wxbymat zm on zm.gz_bj_id = zf.gz_bj_id"
						+ " and zm.bsflag = '0' and zm.zcj_code_id is not null and zm.gz_bj_id is not null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account_dui dui on wb.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1'"
						+ " inner join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.usemat_id is not null and wb.project_info_id is not null) tmp1"
						+ " inner join (select distinct r.wz_id,case when r.actual_price is null then i.wz_price else r.actual_price end as actual_price"
						+ " from gms_mat_recyclemat_info r"
						+ " left join gms_mat_infomation i on i.wz_id = r.wz_id and i.bsflag = '0'"
						+ " where r.bsflag = '0' and r.wz_type = '3' and r.project_info_id is null) tmp2"
						+ " on tmp1.wz_id = tmp2.wz_id where 1=1");
		// �Ա��
		if(StringUtils.isNotBlank(inSelectStr)){
			sql.append(" and tmp1.self_num in " +inSelectStr);
		}
		// ��ʼʱ��
		if(StringUtils.isNotBlank(startDate)){
			sql.append(" and tmp1.bywx_date>=to_date('" + startDate + "','yyyy-mm-dd') ");
		}
		// ����ʱ��
		if(StringUtils.isNotBlank(endDate)){
			sql.append(" and tmp1.bywx_date<=to_date('" + endDate + "','yyyy-mm-dd') ");
		}
		// ����
		sql.append(" group by tmp1.zcj_code_id ");
		// ���
		if(StringUtils.isNotBlank(amount)){
			sql.append(" having sum(nvl(tmp1.use_num,0)*nvl(tmp2.actual_price,0))>="+amount);
		}
		sql.append(" ) t right join (select sd.coding_code_id as zcj_code_id, sd.coding_name"
				+ " from  comm_coding_sort_detail sd"
				+ " where sd.bsflag = '0'"
                + " and sd.coding_sort_id = '5110000187'"
                + " and sd.coding_code_id not in"
                + " ('5110000187000000015', '5110000187000000016', '5110000187000000017')) tmp3"
                + " on t.zcj_code_id = tmp3.zcj_code_id"
                + " order by tmp3.zcj_code_id");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				set.addAttribute("label", map.get("coding_name").toString());
				set.addAttribute("value", map.get("use_num").toString());
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * ��ÿɿ���Դ����ͳ�Ʒ���
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getFaultStatAnal(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// �Ա��
		String selfNums = reqDTO.getValue("selfNums");
		if(null==selfNums || StringUtils.isBlank(selfNums)){
			selfNums="";
		}
		String inSelectStr=StringUtil.getInSelectStr(selfNums);
		// ��ʼʱ��
		String startDate = reqDTO.getValue("startDate");
		if(null==startDate || StringUtils.isBlank(startDate)){
			startDate="";
		}
		// ����ʱ��
		String endDate = reqDTO.getValue("endDate");
		if(null==endDate || StringUtils.isBlank(endDate)){
			endDate="";
		}
		// ��Ŀid
		String projectInfoIds = reqDTO.getValue("projectInfoIds");
		if(null==projectInfoIds || StringUtils.isBlank(projectInfoIds)){
			projectInfoIds="";
		}
		String proIdInSelectStr=StringUtil.getInSelectStr(projectInfoIds);
		// ��Դ�ͺ�
		String devModel = reqDTO.getValue("devModel");
		if(null==devModel || StringUtils.isBlank(devModel)){
			devModel="";
		}
		String devModelInSelectStr=StringUtil.getInSelectStr(devModel);
		StringBuilder sql = new StringBuilder(
				" select c.falut_id,c.falut_name,nvl(t.count_num, 0) as count_num"
						+ " from (select tmp.parent_falut_id, count(tmp.id) as count_num"
						+ " from (select zf.id,acc.self_num,acc.dev_model,fc.parent_falut_id,wb.bywx_date,wb.project_info_id"
						+ " from gms_device_zy_falut zf"
						+ " inner join gms_device_zy_bywx wb on zf.usemat_id = wb.usemat_id and wb.bsflag = '0' and wb.project_info_id is null"
						+ " inner join gms_device_account acc on wb.dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " inner join gms_device_zy_falut_category fc on zf.falut_group_id = fc.falut_id and fc.bsflag = '0' and fc.parent_falut_id != '011'"
						+ " where zf.bsflag = '0'"
						+ " union select zf.id,acc.self_num,acc.dev_model,fc.parent_falut_id,wb.bywx_date,wb.project_info_id"
						+ " from gms_device_zy_falut zf"
						+ " inner join gms_device_zy_bywx wb on zf.usemat_id = wb.usemat_id and wb.bsflag = '0' and wb.project_info_id is not null"
						+ " inner join gms_device_account_dui dui on wb.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1'"
						+ " inner join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " inner join gms_device_zy_falut_category fc on zf.falut_group_id = fc.falut_id and fc.bsflag = '0' and fc.parent_falut_id != '011'"
						+ " where zf.bsflag = '0') tmp"
						+ " where 1 = 1");
		// �Ա��
		if(StringUtils.isNotBlank(inSelectStr)){
			sql.append(" and tmp.self_num in " +inSelectStr);
		}
		// ��ʼʱ��
		if(StringUtils.isNotBlank(startDate)){
			sql.append(" and tmp.bywx_date>=to_date('" + startDate + "','yyyy-mm-dd') ");
		}
		// ����ʱ��
		if(StringUtils.isNotBlank(endDate)){
			sql.append(" and tmp.bywx_date<=to_date('" + endDate + "','yyyy-mm-dd') ");
		}
		// ��Ŀid
		if(StringUtils.isNotBlank(proIdInSelectStr)){
			sql.append(" and tmp.project_info_id in " +proIdInSelectStr);
		}
		// ��Դ�ͺ�
		if(StringUtils.isNotBlank(devModelInSelectStr)){
			sql.append(" and tmp.dev_model in "+devModelInSelectStr);
		}
		// ����
		sql.append(" group by tmp.parent_falut_id");
		sql.append(" ) t right join gms_device_zy_falut_category c on t.parent_falut_id = c.falut_id"
				+ " where c.bsflag = '0' and c.parent_falut_id = 'root' and c.falut_id != '011'");
		// ����
		sql.append(" order by c.falut_id ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String falutName = map.get("falut_name").toString();
				String countNum = map.get("count_num").toString();
				set.addAttribute("label", falutName);
				set.addAttribute("value", countNum);
				if(Integer.parseInt(countNum)>0){
					String falutId = map.get("falut_id").toString();
					set.addAttribute("link", "JavaScript:popSecondFaultInfo('"+falutId+"','"+selfNums+"','"+startDate+"','"+endDate+"','"+projectInfoIds+"','"+devModel+"')");
				}
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * ��ÿɿ���Դ�Ӽ�����ͳ�Ʒ���
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSecondFaultStatAnal(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// ����id
		String falutId = reqDTO.getValue("falutId");
		// �Ա��
		String selfNums = reqDTO.getValue("selfNums");
		if(null==selfNums || StringUtils.isBlank(selfNums)){
			selfNums="";
		}
		String inSelectStr=StringUtil.getInSelectStr(selfNums);
		// ��ʼʱ��
		String startDate = reqDTO.getValue("startDate");
		if(null==startDate || StringUtils.isBlank(startDate)){
			startDate="";
		}
		// ����ʱ��
		String endDate = reqDTO.getValue("endDate");
		if(null==endDate || StringUtils.isBlank(endDate)){
			endDate="";
		}
		// ��Ŀid
		String projectInfoIds = reqDTO.getValue("projectInfoIds");
		if(null==projectInfoIds || StringUtils.isBlank(projectInfoIds)){
			projectInfoIds="";
		}
		String proIdInSelectStr=StringUtil.getInSelectStr(projectInfoIds);
		// ��Դ�ͺ�
		String devModel = reqDTO.getValue("devModel");
		if(null==devModel || StringUtils.isBlank(devModel)){
			devModel="";
		}
		String devModelInSelectStr=StringUtil.getInSelectStr(devModel);
		StringBuilder sql = new StringBuilder(
				" select c.falut_id,c.falut_name,nvl(t.count_num, 0) as count_num"
						+ " from (select tmp.falut_group_id, count(tmp.id) as count_num"
						+ " from (select zf.id,zf.falut_group_id,acc.self_num,acc.dev_model,wb.bywx_date,wb.project_info_id"
						+ " from gms_device_zy_falut zf"
						+ " inner join gms_device_zy_bywx wb on zf.usemat_id = wb.usemat_id and wb.bsflag = '0' and wb.project_info_id is null"
						+ " inner join gms_device_account acc on wb.dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " inner join gms_device_zy_falut_category fc on zf.falut_group_id = fc.falut_id and fc.bsflag = '0' and fc.parent_falut_id = '"+falutId+"'"
						+ " where zf.bsflag = '0'"
						+ " union select zf.id,zf.falut_group_id,acc.self_num,acc.dev_model,wb.bywx_date,wb.project_info_id"
						+ " from gms_device_zy_falut zf"
						+ " inner join gms_device_zy_bywx wb on zf.usemat_id = wb.usemat_id and wb.bsflag = '0' and wb.project_info_id is not null"
						+ " inner join gms_device_account_dui dui on wb.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1'"
						+ " inner join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " inner join gms_device_zy_falut_category fc on zf.falut_group_id = fc.falut_id and fc.bsflag = '0' and fc.parent_falut_id = '"+falutId+"'"
						+ " where zf.bsflag = '0') tmp"
						+ " where 1 = 1");
		// �Ա��
		if(StringUtils.isNotBlank(inSelectStr)){
			sql.append(" and tmp.self_num in " +inSelectStr);
		}
		// ��ʼʱ��
		if(StringUtils.isNotBlank(startDate)){
			sql.append(" and tmp.bywx_date>=to_date('" + startDate + "','yyyy-mm-dd') ");
		}
		// ����ʱ��
		if(StringUtils.isNotBlank(endDate)){
			sql.append(" and tmp.bywx_date<=to_date('" + endDate + "','yyyy-mm-dd') ");
		}
		// ��Ŀid
		if(StringUtils.isNotBlank(proIdInSelectStr)){
			sql.append(" and tmp.project_info_id in " +proIdInSelectStr);
		}
		// ��Դ�ͺ�
		if(StringUtils.isNotBlank(devModelInSelectStr)){
			sql.append(" and tmp.dev_model in "+devModelInSelectStr);
		}
		// ����
		sql.append(" group by tmp.falut_group_id");
		sql.append(" ) t right join gms_device_zy_falut_category c on t.falut_group_id = c.falut_id"
				+ " where c.bsflag = '0' and c.parent_falut_id = '"+falutId+"'");
		// ����
		sql.append(" order by c.falut_id ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				String falutName = map.get("falut_name").toString();
				String countNum = map.get("count_num").toString();
				set.addAttribute("label", falutName);
				set.addAttribute("value", countNum);
				if(Integer.parseInt(countNum)>0){
					String _falutId = map.get("falut_id").toString();
					set.addAttribute("link", "JavaScript:popFaultInfoList('"+_falutId+"','"+selfNums+"','"+startDate+"','"+endDate+"','"+projectInfoIds+"','"+devModel+"')");
				}
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * ��ȡ�ɿ���Դ�����ƻ�
	 * ���������0��ʼ���ۼ� �豸��ת��¼��ʱ����/�������������豸Ϊ����Ƶ����������ʱ����Ը�ֵ������Ƽ�������
	 * @param isrvmsg ttmp0.min_work_hours
	 * @return 
	 * @throws Exception
	 */
	public ISrvMsg getKkzySparePartPlanList(ISrvMsg isrvmsg) throws Exception {
		log.info("getKkzySparePartPlanList");
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
		// �Ա��
		String selfNums = isrvmsg.getValue("selfNums");
		if(null==selfNums || StringUtils.isBlank(selfNums)){
			selfNums="";
		}
		String inSelectStr=StringUtil.getInSelectStr(selfNums);
		// Сʱ��
		int iHours=1;
		String hours = isrvmsg.getValue("hours");
		if(null!=hours && StringUtils.isNotBlank(hours)){
			iHours=Integer.parseInt(hours);
		}
		StringBuffer querySql = new StringBuffer();
		querySql.append("select ttmp0.dev_acc_id,ttmp0.self_num,ttmp0.dev_name,ttmp0.dev_model,ttmp0.wz_id,ttmp2.wz_name,ttmp0.use_num,"
				+ " trunc((ttmp1.cur_work_hours - 0)/ttmp0.use_num,0) as ghpc,"
				+ " trunc(ttmp0.use_num * "+iHours+" /(ttmp1.cur_work_hours - 0),0) as plan_num "
				+ " from (select tmp.wz_id,tmp.self_num,tmp.dev_name,tmp.dev_model,tmp.dev_acc_id,sum(tmp.use_num) use_num,min(tmp.work_hours) min_work_hours "
				+ " from (select m.wz_id,m.use_num,w.work_hours,w.dev_acc_id,acc.self_num,acc.dev_name,acc.dev_model "
				+ " from gms_device_zy_wxbymat m "
				+ " inner join gms_device_zy_bywx w on m.usemat_id = w.usemat_id and w.bsflag = '0' and w.project_info_id is null "
				+ " inner join gms_device_account acc on w.dev_acc_id = acc.dev_acc_id and acc.bsflag != '1' "
				+ " where m.bsflag = '0' and m.wz_id not like '%zy%'  "
				+ " union all select m.wz_id,m.use_num,w.work_hours,acc.dev_acc_id,acc.self_num,acc.dev_name,acc.dev_model "
				+ " from gms_device_zy_wxbymat m "
				+ " inner join gms_device_zy_bywx w on m.usemat_id = w.usemat_id and w.bsflag = '0' and w.project_info_id is not null "
				+ " inner join gms_device_account_dui dui on w.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1' "
				+ " inner join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag != '1' "
				+ " where m.bsflag = '0' and m.wz_id not like '%zy%') tmp "
				+ " group by tmp.wz_id,tmp.dev_acc_id,tmp.self_num,tmp.dev_name,tmp.dev_model) ttmp0 "
				+ " inner join (select sum(otmp.work_hour) as cur_work_hours, otmp.dev_acc_id "
				+ " from (select nvl(oi.work_hour, 0) as work_hour, acc.dev_acc_id "
				+ " from gms_device_operation_info oi "
				+ " inner join gms_device_account acc on oi.dev_acc_id = acc.dev_acc_id and acc.bsflag != '1' and acc.dev_type like 'S062301%' "
				+ " union all select nvl(oi.work_hour, 0) as work_hour,dui.fk_dev_acc_id as dev_acc_id "
				+ " from gms_device_operation_info oi "
				+ " inner join gms_device_account_dui dui on oi.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1' and dui.dev_type like 'S062301%') otmp "
				+ " group by otmp.dev_acc_id) ttmp1 " 
				+ " on ttmp0.dev_acc_id = ttmp1.dev_acc_id "
				+ " left join (select distinct r.wz_id, i.wz_name from gms_mat_recyclemat_info r "
				+ " left join gms_mat_infomation i on i.wz_id = r.wz_id and i.bsflag = '0' "
				+ " where r.bsflag = '0' and r.wz_type = '3' and r.project_info_id is null) ttmp2 "
				+ " on ttmp0.wz_id = ttmp2.wz_id "
				+ " where (ttmp1.cur_work_hours - 0) > 0 ");
		// �Ա��
		if(StringUtils.isNotBlank(inSelectStr)){
			querySql.append(" and ttmp0.self_num in " +inSelectStr);
		}
		// Сʱ��
		querySql.append(" and trunc(ttmp0.use_num * "+iHours+" /(ttmp1.cur_work_hours - 0),0) > 0 ");
		querySql.append(" order by ttmp0.self_num,ttmp0.use_num/(ttmp1.cur_work_hours - 0) desc ");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ÿɿ���Դ��������
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSparePartAnal(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// �Ա��
		String type = reqDTO.getValue("type");
		if(null==type || StringUtils.isBlank(type)){
			type="";
		}
		// �Ա��
		String selfNums = reqDTO.getValue("selfNums");
		if(null==selfNums || StringUtils.isBlank(selfNums)){
			selfNums="";
		}
		String inSelectStr=StringUtil.getInSelectStr(selfNums);
		// ��ʼʱ��
		String startDate = reqDTO.getValue("startDate");
		if(null==startDate || StringUtils.isBlank(startDate)){
			startDate="";
		}
		// ����ʱ��
		String endDate = reqDTO.getValue("endDate");
		if(null==endDate || StringUtils.isBlank(endDate)){
			endDate="";
		}
		// ��Ŀid
		String projectInfoIds = reqDTO.getValue("projectInfoIds");
		if(null==projectInfoIds || StringUtils.isBlank(projectInfoIds)){
			projectInfoIds="";
		}
		String proIdInSelectStr=StringUtil.getInSelectStr(projectInfoIds);
		// ��Դ�ͺ�
		String devModel = reqDTO.getValue("devModel");
		if(null==devModel || StringUtils.isBlank(devModel)){
			devModel="";
		}
		String devModelInSelectStr=StringUtil.getInSelectStr(devModel);
		StringBuilder sql = new StringBuilder(
				" select tmp3.bjlb_id as coding_code_id,tmp3.coding_name,nvl(t.use_num,0) as use_num,round(nvl(t.amount, 0)/10000,2) as amount  from ("
						+ " select tmp1.coding_code_id,sum(nvl(tmp1.use_num,0)) as use_num,sum(nvl(tmp1.use_num,0)*nvl(tmp2.actual_price,0)) as amount "
						+ " from (select zm.wxbymat_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,acc.dev_model,wb.bywx_date,wb.project_info_id"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_wxbymat zm on wb.usemat_id = zm.usemat_id"
						+ " and zm.bsflag = '0' and zm.gz_bj_id is null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account acc on wb.dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.project_info_id is null and wb.usemat_id is not null"
						+ " union select zm.wxbymat_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,acc.dev_model,wb.bywx_date,wb.project_info_id"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_wxbymat zm on wb.usemat_id = zm.usemat_id"
						+ " and zm.bsflag = '0' and zm.gz_bj_id is null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account_dui dui on wb.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1'"
						+ " inner join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.project_info_id is not null and wb.usemat_id is not null"
						+ " union select zm.wxbymat_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,acc.dev_model,wb.bywx_date,wb.project_info_id"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_falut zf on wb.usemat_id = zf.usemat_id and zf.bsflag = '0'"
						+ " inner join gms_device_zy_wxbymat zm on zm.gz_bj_id = zf.gz_bj_id"
						+ " and zm.bsflag = '0' and zm.gz_bj_id is not null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account acc on wb.dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.usemat_id is not null and wb.project_info_id is null"
						+ " union select zm.wxbymat_id,zm.wz_id,zm.use_num,zm.coding_code_id,acc.self_num,acc.dev_model,wb.bywx_date,wb.project_info_id"
						+ " from gms_device_zy_bywx wb"
						+ " inner join gms_device_zy_falut zf on wb.usemat_id = zf.usemat_id and zf.bsflag = '0'"
						+ " inner join gms_device_zy_wxbymat zm on zm.gz_bj_id = zf.gz_bj_id"
						+ " and zm.bsflag = '0' and zm.gz_bj_id is not null and zm.usemat_id is not null and zm.coding_code_id is not null"
						+ " inner join gms_device_account_dui dui on wb.dev_acc_id = dui.dev_acc_id and dui.bsflag != '1'"
						+ " inner join gms_device_account acc on dui.fk_dev_acc_id = acc.dev_acc_id and acc.bsflag != '1'"
						+ " where wb.bsflag = '0' and wb.usemat_id is not null and wb.project_info_id is not null) tmp1"
						+ " inner join (select distinct r.wz_id,case when r.actual_price is null then i.wz_price else r.actual_price end as actual_price"
						+ " from gms_mat_recyclemat_info r"
						+ " left join gms_mat_infomation i on i.wz_id = r.wz_id and i.bsflag = '0'"
						+ " where r.bsflag = '0' and r.wz_type = '3' and r.project_info_id is null) tmp2"
						+ " on tmp1.wz_id = tmp2.wz_id where 1=1");
		// �Ա��
		if(StringUtils.isNotBlank(inSelectStr)){
			sql.append(" and tmp1.self_num in " +inSelectStr);
		}
		// ��ʼʱ��
		if(StringUtils.isNotBlank(startDate)){
			sql.append(" and tmp1.bywx_date>=to_date('" + startDate + "','yyyy-mm-dd') ");
		}
		// ����ʱ��
		if(StringUtils.isNotBlank(endDate)){
			sql.append(" and tmp1.bywx_date<=to_date('" + endDate + "','yyyy-mm-dd') ");
		}
		// ��Ŀid
		if(StringUtils.isNotBlank(proIdInSelectStr)){
			sql.append(" and tmp1.project_info_id in " +proIdInSelectStr);
		}
		// ��Դ�ͺ�
		if(StringUtils.isNotBlank(devModelInSelectStr)){
			sql.append(" and tmp1.dev_model in "+devModelInSelectStr);
		}
		// ����
		sql.append(" group by tmp1.coding_code_id ");
		sql.append(" ) t right join (select rb.bjlb_id, sd.coding_name"
				+ " from gms_device_zy_gzdl_re_bjlb rb"
				+ " left join comm_coding_sort_detail sd on rb.bjlb_id = sd.coding_code_id and sd.bsflag = '0' and sd.coding_sort_id = '5110000188'"
				+ " where rb.bsflag = '0') tmp3 on t.coding_code_id=tmp3.bjlb_id");
		// ����
		sql.append(" order by tmp3.bjlb_id ");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		if("num".equals(type)){
			root.addAttribute("yAxisName", "����(��)");
		}
		if("money".equals(type)){
			root.addAttribute("yAxisName", "���(��Ԫ)");
		}
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				set.addAttribute("label", map.get("coding_name").toString());
				if("num".equals(type)){
					set.addAttribute("value", map.get("use_num").toString());
				}
				if("money".equals(type)){
					set.addAttribute("value", map.get("amount").toString());
				}
				set.addAttribute("link", "JavaScript:popSparePartAnalList('"+map.get("coding_code_id").toString()+"','"+selfNums+"','"+startDate+"','"+endDate+"','"+projectInfoIds+"','"+devModel+"')");
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * ��ȡ�ɿ���Դ�豸�ͺ�����
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getKkzyDevModelData(ISrvMsg reqDTO) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuilder sql = new StringBuilder(
				"select t.dev_model as id,t.dev_model as name,t.ifcountry as mgroup from ( "
						+ " select nvl(acc.ifcountry,'����') as ifcountry,acc.dev_model from gms_device_account acc "
						+ " where acc.bsflag='0' and acc.dev_type like 'S062301%' "
						+ " and ( acc.account_stat = '0110000013000000003' or acc.spare4 = '1' ) "
						+ " ) t group by t.ifcountry,t.dev_model order by t.ifcountry,t.dev_model");
		List<Map> data = jdbcDao.queryRecords(sql.toString());
		JSONArray jsonArray = JSONArray.fromObject(data);
		responseDTO.setValue("data", jsonArray.toString());
		return responseDTO;
	}
	
	/**
	 * ��ȡ���������ͺ�
	 * @throws Exception 
	 * 
	 * 
	 */
	public ISrvMsg getModelType(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String sql = "select l.coding_name as name,l.coding_code_id as id from comm_coding_sort_detail l where l.coding_sort_id = '5110000031'";
		List<Map> data = jdbcDao.queryRecords(sql.toString());
		if(data.size() > 0){
			Map<String, Object> map1 = new HashMap<String, Object>();
			Map<String, Object> map2 = new HashMap<String, Object>();
			Map<String, Object> map3 = new HashMap<String, Object>();
			map1.put("id", "Z-LAND");
			map1.put("name", "Z-LAND");
			
			map2.put("id", "508");
			map2.put("name", "508");
			
			map3.put("id", "ION DigiSTREAMER");
			map3.put("name", "ION DigiSTREAMER");
			
			data.add(map1);
			data.add(map2);
			data.add(map3);
			
		}
		JSONArray jsonArray = JSONArray.fromObject(data);
		responseDTO.setValue("data", jsonArray.toString());
		return responseDTO;
		
	}
	/**
	 * ��ÿɿ���Դ��������(�����豸����)
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getKkzyAmountAnal(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String type=reqDTO.getValue("type");
		String sql = 
				" select * "
						+ " from (select '0' as using_stat,'����' as using_stat_desc,count(*) as using_count "
						+ " from gms_device_account t ";
						if(StringUtils.isNotBlank(type)){//�ж��Ƿ�Ϊ�����豸
							sql+= " where t.bsflag = '0' and t.dev_type in (select device_code from dms_device_tree t   where dev_tree_id like 'D007%' and device_code is not null)";
						}
						else{//��Դ�豸
							sql+= " where t.bsflag = '0' and t.dev_type like 'S062301%' ";
						}
						sql+= " and (t.account_stat = '0110000013000000003' or t.spare4 = '1') "
						+ " and (ifcountry is null or ifcountry = '����') and t.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
						+ " union "
						+ " select t.using_stat,u.coding_name as using_stat_desc,count(*) as using_count"
						+ " from gms_device_account t "
						+ " left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat and u.bsflag = '0' ";
						if(StringUtils.isNotBlank(type)){//�ж��Ƿ�Ϊ�����豸
							sql+= " where t.bsflag = '0' and t.dev_type in (select device_code from dms_device_tree t   where dev_tree_id like 'D007%' and device_code is not null)";
						}
						else{//��Դ�豸
							sql+= " where t.bsflag = '0' and t.dev_type like 'S062301%' ";
						}
						sql+= " and (t.account_stat = '0110000013000000003' or t.spare4 = '1') "
						+ " and (ifcountry is null or ifcountry = '����') and t.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
						+ " group by t.using_stat, u.coding_name ) tmp "
						+ " order by tmp.using_stat";
		List<Map> list = jdbcDao.queryRecords(sql);
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
	
	
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("yAxisName", "̨��(��)");
		Element categories = root.addElement("categories");
		Element category = categories.addElement("category");
		if(StringUtils.isNotBlank(type)){//�ж��Ƿ�Ϊ�����豸
			root.addAttribute("caption", "�����豸����");
			category.addAttribute("label", "�����豸ʹ�����");
		}else{//��Դ
			root.addAttribute("caption", "��Դ����");
			category.addAttribute("label", "��Դʹ�����");
		}
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
		    	Element dataset = root.addElement("dataset");
		    	dataset.addAttribute("seriesName", map.get("using_stat_desc").toString());
		    	Element set = dataset.addElement("set");
		    	set.addAttribute("value", map.get("using_count").toString());
		    	set.addAttribute("toolText", map.get("using_stat_desc").toString()+","+map.get("using_count").toString());
		    	//���ã�������Դ
		    	if("0110000007000000001".equals(map.get("using_stat").toString()) || "0110000007000000002".equals(map.get("using_stat").toString())){
		    		set.addAttribute("link", "JavaScript:popSecondKkzyAmountAnal('"+map.get("using_stat").toString()+"')");
		    	}
		    	//������Դ
		    	if("0110000007000000006".equals(map.get("using_stat").toString())){
		    		set.addAttribute("link", "JavaScript:popOtherKkzyList('"+map.get("using_stat").toString()+"')");
		    	}
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * ��ȡ�����ɿ���Դ�б�(�����豸����)
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOtherKkzyList(ISrvMsg isrvmsg) throws Exception {
		log.info("getOtherKkzyList");
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
		String type=isrvmsg.getValue("type");
		String params="";
		if(StringUtils.isNotBlank(type)){//�ж��Ƿ�Ϊ�����豸
			params= "   t.dev_type in (select device_code from dms_device_tree t   where dev_tree_id like 'D007%' and device_code is not null)";
		}
		else{//��Դ�豸
			params= "    t.dev_type like 'S062301%' ";
		}
		// ʹ�����
		String useStat = isrvmsg.getValue("useStat");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,i.org_abbreviation usage_org_name_desc,c.coding_name as tech_stat_desc,u.coding_name as using_stat_desc,"
						+ " case when t.owning_sub_id like 'C105002%' then '���ʿ�̽��ҵ��' "
						+ " when t.owning_sub_id like 'C105005004%' then '������̽��' "
						+ " when t.owning_sub_id like 'C105001005%' then '����ľ��̽��' "
						+ " when t.owning_sub_id like 'C105001002%' then '�½���̽��' "
						+ " when t.owning_sub_id like 'C105001003%' then '�¹���̽��' "
						+ " when t.owning_sub_id like 'C105001004%' then '�ຣ��̽��' "
						+ " when t.owning_sub_id like 'C105007%' then '�����̽��' "
						+ " when t.owning_sub_id like 'C105063%' then '�ɺ���̽��' "
						+ " when t.owning_sub_id like 'C105005000%' then '������̽��' "
						+ " when t.owning_sub_id like 'C105005001%' then '������̽������' "
						+ " when t.owning_sub_id like 'C105086%' then '���̽��' "
						+ " when t.owning_sub_id like 'C105006%' then 'װ������' "
						+ " when t.owning_sub_id like 'C105008%' then '�ۺ��ﻯ��' end as owning_org_name_desc "
						+ " from gms_device_account t "
						+ " left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0' "
						+ " left join comm_coding_sort_detail c on c.coding_code_id = t.tech_stat and c.bsflag='0' "
						+ " left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat and u.bsflag='0' "
						+ " where t.bsflag = '0' and  " + params+
						" and (t.account_stat = '0110000013000000003' or t.spare4 = '1') "
						+ " and (ifcountry is null or ifcountry = '����') and t.using_stat = '"+useStat+"' ");
		querySql.append(" order by t.self_num");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ������ÿɿ���Դ��������(�����豸����)
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getUseKkzyAmountAnal(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String type=reqDTO.getValue("type");
		String params="";
		if(StringUtils.isNotBlank(type)){//�����豸
			params=" t.dev_type in ( select t.device_code from dms_device_tree t   where dev_tree_id like 'D007%' and device_code is not null) ";
		}else{//��Դ
			params=" t.dev_type like 'S062301%' ";
		}
		StringBuilder sql = new StringBuilder(
				" select tmp.org_id,tmp.org_name from ( "
						+ " select t.dev_acc_id, "
						+ " case when t.usage_sub_id like 'C105002%' then 'C105002' "
						+ " when t.usage_sub_id like 'C105005004%' then 'C105005004' "
						+ " when t.usage_sub_id like 'C105001005%' then 'C105001005' "
						+ " when t.usage_sub_id like 'C105001002%' then 'C105001002' "
						+ " when t.usage_sub_id like 'C105001003%' then 'C105001003' "
						+ " when t.usage_sub_id like 'C105001004%' then 'C105001004' "
						+ " when t.usage_sub_id like 'C105007%' then 'C105007' "
						+ " when t.usage_sub_id like 'C105063%' then 'C105063' "
						+ " when t.usage_sub_id like 'C105005000%' then 'C105005000' "
						+ " when t.usage_sub_id like 'C105005001%' then 'C105005001' "
						+ " when t.usage_sub_id like 'C105086%' then 'C105086' "
						+ " when t.usage_sub_id like 'C105006%' then 'C105006' "
						+ " when t.usage_sub_id like 'C105008%' then 'C105008' end as org_id, "
						+ " case when t.usage_sub_id like 'C105002%' then '���ʿ�̽��ҵ��' "
						+ " when t.usage_sub_id like 'C105005004%' then '������̽��' "
						+ " when t.usage_sub_id like 'C105001005%' then '����ľ��̽��' "
						+ " when t.usage_sub_id like 'C105001002%' then '�½���̽��' "
						+ " when t.usage_sub_id like 'C105001003%' then '�¹���̽��' "
						+ " when t.usage_sub_id like 'C105001004%' then '�ຣ��̽��' "
						+ " when t.usage_sub_id like 'C105007%' then '�����̽��' "
						+ " when t.usage_sub_id like 'C105063%' then '�ɺ���̽��' "
						+ " when t.usage_sub_id like 'C105005000%' then '������̽��' "
						+ " when t.usage_sub_id like 'C105005001%' then '������̽������' "
						+ " when t.usage_sub_id like 'C105086%' then '���̽��' "
						+ " when t.usage_sub_id like 'C105006%' then 'װ������' "
						+ " when t.usage_sub_id like 'C105008%' then '�ۺ��ﻯ��' end as org_name "
						+ " from gms_device_account t "
						+ " where t.bsflag = '0' and  " + params+
 						" and (t.account_stat = '0110000013000000003' or t.spare4 = '1')  and t.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
						+ " and (ifcountry is null or ifcountry = '����') and t.using_stat = '0110000007000000001' "
						+ " ) tmp group by tmp.org_id,tmp.org_name order by tmp.org_id");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		StringBuilder sql2 = new StringBuilder(
				" select distinct t.dev_model "
						+ " from gms_device_account t "
						+ " where t.bsflag = '0' and  " + params+
						" and (t.account_stat = '0110000013000000003' or t.spare4 = '1')  and t.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
						+ " and (ifcountry is null or ifcountry = '����') and t.using_stat = '0110000007000000001' order by t.dev_model ");
		List<Map> list2 = jdbcDao.queryRecords(sql2.toString());
		StringBuilder sql3 = new StringBuilder(
				" select tmp.org_id,tmp.dev_model,count(*) u_count from ( "
						+ " select t.dev_acc_id,dev_model, "
						+ " case when t.usage_sub_id like 'C105002%' then 'C105002' "
						+ " when t.usage_sub_id like 'C105005004%' then 'C105005004' "
						+ " when t.usage_sub_id like 'C105001005%' then 'C105001005' "
						+ " when t.usage_sub_id like 'C105001002%' then 'C105001002' "
						+ " when t.usage_sub_id like 'C105001003%' then 'C105001003' "
						+ " when t.usage_sub_id like 'C105001004%' then 'C105001004' "
						+ " when t.usage_sub_id like 'C105007%' then 'C105007' "
						+ " when t.usage_sub_id like 'C105063%' then 'C105063' "
						+ " when t.usage_sub_id like 'C105005000%' then 'C105005000' "
						+ " when t.usage_sub_id like 'C105005001%' then 'C105005001' "
						+ " when t.usage_sub_id like 'C105086%' then 'C105086' "
						+ " when t.usage_sub_id like 'C105006%' then 'C105006' "
						+ " when t.usage_sub_id like 'C105008%' then 'C105008' end as org_id "
						+ " from gms_device_account t "
						+ " where t.bsflag = '0' and  " + params+
						" and (t.account_stat = '0110000013000000003' or t.spare4 = '1') "
						+ " and (ifcountry is null or ifcountry = '����') and t.using_stat = '0110000007000000001' and t.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
						+ " ) tmp group by tmp.org_id,tmp.dev_model order by tmp.org_id,tmp.dev_model");
		List<Map> list3 = jdbcDao.queryRecords(sql3.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("caption", "����");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("yAxisName", "̨��(��)");
		Element categories = root.addElement("categories");
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element category = categories.addElement("category");
				category.addAttribute("label", map.get("org_name").toString());
		    }
		}
		if(CollectionUtils.isNotEmpty(list2)){
			for(Map map2:list2){
		    	Element dataset = root.addElement("dataset");
		    	dataset.addAttribute("seriesName", map2.get("dev_model").toString());
		    	for(Map map:list){
		    		Element set = dataset.addElement("set");
		    		String value="";
		    		for(Map map3:list3){
			    		if((map.get("org_id").toString().equals(map3.get("org_id").toString())) && (map2.get("dev_model").toString().equals(map3.get("dev_model").toString()))){
			    			value=map3.get("u_count").toString();
			    		}
		    		}
		    		set.addAttribute("value", value);
		    		set.addAttribute("link", "JavaScript:popUseKkzyList('"+map.get("org_id").toString()+"','"+map2.get("dev_model").toString()+"')");
		    	}
	    	}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * ��ȡ���ÿɿ���Դ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getUseKkzyList(ISrvMsg isrvmsg) throws Exception {
		log.info("getUseKkzyList");
		
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
		// ��̽��id
		String orgId = isrvmsg.getValue("orgId");
		if(null==orgId || StringUtils.isBlank(orgId)){
			orgId="";
		}
		// �豸�ͺ�
		String devModel = isrvmsg.getValue("devModel");
		if(null==devModel || StringUtils.isBlank(devModel)){
			devModel="";
		}
		String type=isrvmsg.getValue("type");
		String params="";
		if(StringUtils.isNotBlank(type)){//�����豸
			params=" t.dev_type in ( select t.device_code from dms_device_tree t   where dev_tree_id like 'D007%' and device_code is not null) ";
		}else{//��Դ
			params=" t.dev_type like 'S062301%' ";
		}
		StringBuffer querySql = new StringBuffer();
		querySql.append("select tmp.*,p.project_name from ( "
						+ " select t.dev_acc_id,t.dev_name,t.self_num,t.dev_model,t.project_info_no,"
						+ " case when t.usage_sub_id like 'C105002%' then 'C105002' "
						+ " when t.usage_sub_id like 'C105005004%' then 'C105005004' "
						+ " when t.usage_sub_id like 'C105001005%' then 'C105001005' "
						+ " when t.usage_sub_id like 'C105001002%' then 'C105001002' "
						+ " when t.usage_sub_id like 'C105001003%' then 'C105001003' "
						+ " when t.usage_sub_id like 'C105001004%' then 'C105001004' "
						+ " when t.usage_sub_id like 'C105007%' then 'C105007' "
						+ " when t.usage_sub_id like 'C105063%' then 'C105063' "
						+ " when t.usage_sub_id like 'C105005000%' then 'C105005000' "
						+ " when t.usage_sub_id like 'C105005001%' then 'C105005001' "
						+ " when t.usage_sub_id like 'C105086%' then 'C105086' "
						+ " when t.usage_sub_id like 'C105006%' then 'C105006' "
						+ " when t.usage_sub_id like 'C105008%' then 'C105008' end as org_id "
						+ " from gms_device_account t "
						+ " where t.bsflag = '0' " 
						+ " and (t.account_stat = '0110000013000000003' or t.spare4 = '1') "
						+ " and (ifcountry is null or ifcountry = '����') and t.using_stat = '0110000007000000001' "
						+ " ) tmp left join gp_task_project p on tmp.project_info_no = p.project_info_no  where 1=1 ");
		// ��̽��
		if(StringUtils.isNotBlank(orgId)){
			querySql.append(" and tmp.org_id = '" +orgId+ "'");
		}
		// �豸�ͺ�
		if(StringUtils.isNotBlank(devModel)){
			querySql.append(" and tmp.dev_model = '" +devModel+ "'");
		}
		querySql.append(" order by tmp.project_info_no,tmp.self_num");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ������ÿɿ���Դ��������(�����豸����)
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIdleKkzyAmountAnal(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		UserToken user = reqDTO.getUserToken();
		String type=reqDTO.getValue("type");
		String params="";
		if(StringUtils.isNotBlank(type)){//�����豸
			params=" t.dev_type in ( select t.device_code from dms_device_tree t   where dev_tree_id like 'D007%' and device_code is not null) ";
		}else{//��Դ
			params=" t.dev_type like 'S062301%' ";
		}
		StringBuilder sql = new StringBuilder(
				" select tmp.position_id,tmp.dev_position from (  "
						+ " select t.dev_acc_id, "
						+ " case when t.position_id is null then '9' "
						+ " else t.position_id end as position_id, "
						+ " case when t.position_id is null then '��' "
						+ " else t.dev_position end as dev_position "
						+ " from gms_device_account t "
						+ " where t.bsflag = '0' and  " + params+
						"and (t.account_stat = '0110000013000000003' or t.spare4 = '1') "
						+ " and (ifcountry is null or ifcountry = '����') and t.using_stat = '0110000007000000002' and t.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
						+ " ) tmp group by tmp.position_id,tmp.dev_position order by tmp.position_id");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		StringBuilder sql2 = new StringBuilder(
				" select distinct t.dev_model "
						+ " from gms_device_account t "
						+ " where t.bsflag = '0' and   " + params+
						"and (t.account_stat = '0110000013000000003' or t.spare4 = '1') "
						+ " and (ifcountry is null or ifcountry = '����') and t.using_stat = '0110000007000000002'  and t.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%' order by t.dev_model ");
		List<Map> list2 = jdbcDao.queryRecords(sql2.toString());
		StringBuilder sql3 = new StringBuilder(
				" select tmp.position_id,tmp.dev_model,count(*) as u_count from ( "
						+ " select t.dev_acc_id,dev_model, "
						+ " case when t.position_id is null then '9' "
						+ " else t.position_id end as position_id "
						+ " from gms_device_account t "
						+ " where t.bsflag = '0' and   " + params+
						"and (t.account_stat = '0110000013000000003' or t.spare4 = '1') "
						+ " and (ifcountry is null or ifcountry = '����') and t.using_stat = '0110000007000000002'  and t.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
						+ " ) tmp group by tmp.position_id,tmp.dev_model order by tmp.position_id,tmp.dev_model");
		List<Map> list3 = jdbcDao.queryRecords(sql3.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("caption", "����");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		root.addAttribute("yAxisName", "̨��(��)");
		Element categories = root.addElement("categories");
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element category = categories.addElement("category");
				category.addAttribute("label", map.get("dev_position").toString());
		    }
		}
		if(CollectionUtils.isNotEmpty(list2)){
			for(Map map2:list2){
		    	Element dataset = root.addElement("dataset");
		    	dataset.addAttribute("seriesName", map2.get("dev_model").toString());
		    	for(Map map:list){
		    		Element set = dataset.addElement("set");
		    		String value="";
		    		for(Map map3:list3){
			    		if((map.get("position_id").toString().equals(map3.get("position_id").toString())) && (map2.get("dev_model").toString().equals(map3.get("dev_model").toString()))){
			    			value=map3.get("u_count").toString();
			    		}
		    		}
		    		set.addAttribute("value", value);
		    		set.addAttribute("link", "JavaScript:popIdleKkzyList('"+map.get("position_id").toString()+"','"+map2.get("dev_model").toString()+"')");
		    	}
	    	}
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	
	/**
	 * ��ȡ���ÿɿ���Դ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getIdleKkzyList(ISrvMsg isrvmsg) throws Exception {
		log.info("getIdleKkzyList");
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
		// ����λ��id
		String positionId = isrvmsg.getValue("positionId");
		if(null==positionId || StringUtils.isBlank(positionId)){
			positionId="";
		}
		// �豸�ͺ�
		String devModel = isrvmsg.getValue("devModel");
		if(null==devModel || StringUtils.isBlank(devModel)){
			devModel="";
		}
		String type=isrvmsg.getValue("type");
		String params="";
		if(StringUtils.isNotBlank(type)){//�����豸
			params=" t.dev_type in ( select t.device_code from dms_device_tree t   where device_code is not null) ";
		}else{//��Դ
			params=" t.dev_type like 'S062301%' ";
		}
		StringBuffer querySql = new StringBuffer();
		querySql.append("select tmp.* from (  "
						+ " select t.dev_position, t.position_id,t.tech_stat,t.dev_acc_id,t.dev_name,t.self_num,t.dev_model,t.project_info_no,"
						+ " case when t.usage_sub_id like 'C105002%' then 'C105002' "
						+ " when t.usage_sub_id like 'C105005004%' then 'C105005004' "
						+ " when t.usage_sub_id like 'C105001005%' then 'C105001005' "
						+ " when t.usage_sub_id like 'C105001002%' then 'C105001002' "
						+ " when t.usage_sub_id like 'C105001003%' then 'C105001003' "
						+ " when t.usage_sub_id like 'C105001004%' then 'C105001004' "
						+ " when t.usage_sub_id like 'C105007%' then 'C105007' "
						+ " when t.usage_sub_id like 'C105063%' then 'C105063' "
						+ " when t.usage_sub_id like 'C105005000%' then 'C105005000' "
						+ " when t.usage_sub_id like 'C105005001%' then 'C105005001' "
						+ " when t.usage_sub_id like 'C105086%' then 'C105086' "
						+ " when t.usage_sub_id like 'C105006%' then 'C105006' "
						+ " when t.usage_sub_id like 'C105008%' then 'C105008' end as org_id "
						+ " from gms_device_account t "
						+ " where t.bsflag = '0' and   " + params+
						"and (t.account_stat = '0110000013000000003' or t.spare4 = '1') "
						+ " and (ifcountry is null or ifcountry = '����') and t.using_stat = '0110000007000000002' "
						+ " and t.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'"
						+ " ) tmp left join comm_coding_sort_detail sd on tmp.tech_stat=sd.coding_code_id and sd.bsflag='0' where 1=1 ");
		// ����λ��id
		if(positionId.equals("9")){//9����null
			querySql.append(" and tmp.position_id is null ");
		}else{
			querySql.append(" and tmp.position_id = '" +positionId+ "'");
		}
		// �豸�ͺ�
		if(StringUtils.isNotBlank(devModel)){
			querySql.append(" and tmp.project_info_no is null and tmp.dev_model = '" +devModel+ "'");
		}
		querySql.append(" order by tmp.tech_stat");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ʾ���б����豸(�����豸���ù���)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapDevAccData(ISrvMsg msg) throws Exception {
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
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String selfNum = msg.getValue("selfnum");
		String devSign = msg.getValue("devsign");
		String licenseNum = msg.getValue("licensenum");
		String devCoding = msg.getValue("devcoding");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select org.org_abbreviation as own_org_name,acc.* from gms_device_account acc"
						+ " left join comm_org_information org on acc.owning_org_id = org.org_id and org.bsflag = '0' "
				 		+ " where acc.bsflag = '"+DevConstants.BSFLAG_NORMAL+"'"
				 		+ " and acc.account_stat = '"+DevConstants.DEV_ACCOUNT_BAOFEI+"'"
				 		+ " and acc.ifscrapleft is null"
				 		//+ " and acc.ifproduction = '"+DevConstants.DEV_PRODUCTION_YES+"'"
						+ " and acc.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'");
		//�豸����
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and acc.dev_name like '%"+devName+"%'");
		}
		//�豸�ͺ�
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and acc.dev_model like '%"+devModel+"%'");
		}
		//�Ա��
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and acc.self_num like '%"+selfNum+"%'");
		}
		//ʵ���ʶ��
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and acc.dev_sign like '%"+devSign+"%'");
		}
		//���պ�
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and acc.license_num like '%"+licenseNum+"%'");
		}
		//ERP�豸���
		if (StringUtils.isNotBlank(devCoding)) {
			querySql.append(" and acc.dev_coding like '%"+devCoding+"%'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+",acc.dev_acc_id ");
		}else{
			querySql.append(" order by case"
					+ " when dev_type like 'S08%' then 1" 		  //����
					+ " when dev_type like 'S070301%' then 2"     //������
					+ " when dev_type like 'S060101%' then 3"     //��װ���
					+ " when dev_type like 'S060102%' then 4"     //��̧�����
					+ " when dev_type like 'S0901%' then 5"       //�������
					+ " when dev_type like 'S1404%' then 6"       //�����豸
					+ " when dev_type like 'S14050101%' then 7"   //������������
					+ " when dev_type like 'S0623%' then 8"       //�ɿ���Դ
					+ " when dev_type like 'S0622%' then 9"       //������
					+ " end,acc.dev_model,acc.dev_sign,acc.dev_acc_id ");
		}

		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ʾ���б��������豸(�����豸���ù���)
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapLeftDevData(ISrvMsg msg) throws Exception {
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
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String selfNum = msg.getValue("selfnum");
		String devSign = msg.getValue("devsign");
		String licenseNum = msg.getValue("licensenum");
		String devCoding = msg.getValue("devcoding");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select org.org_abbreviation as own_org_name,"
						+ " acc.* from gms_device_account acc"
						+ " left join comm_org_information org on acc.owning_org_id = org.org_id and org.bsflag = '0' "
				 		+ " where acc.bsflag = '"+DevConstants.BSFLAG_NORMAL+"'"
				 		+ " and acc.ifscrapleft = '"+DevConstants.IFSCRAPLEFT_FLAG_1+"'"
						+ " and acc.owning_sub_id like '"+user.getSubOrgIDofAffordOrg()+"%'");
		//�豸����
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and acc.dev_name like '%"+devName+"%'");
		}
		//�豸�ͺ�
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and acc.dev_model like '%"+devModel+"%'");
		}
		//�Ա��
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and acc.self_num like '%"+selfNum+"%'");
		}
		//ʵ���ʶ��
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and acc.dev_sign like '%"+devSign+"%'");
		}
		//���պ�
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and acc.license_num like '%"+licenseNum+"%'");
		}
		//ERP�豸���
		if (StringUtils.isNotBlank(devCoding)) {
			querySql.append(" and acc.dev_coding like '%"+devCoding+"%'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+",acc.dev_acc_id ");
		}else{
			querySql.append(" order by case"
					+ " when dev_type like 'S08%' then 1" 		  //����
					+ " when dev_type like 'S070301%' then 2"     //������
					+ " when dev_type like 'S060101%' then 3"     //��װ���
					+ " when dev_type like 'S060102%' then 4"     //��̧�����
					+ " when dev_type like 'S0901%' then 5"       //�������
					+ " when dev_type like 'S1404%' then 6"       //�����豸
					+ " when dev_type like 'S14050101%' then 7"   //������������
					+ " when dev_type like 'S0623%' then 8"       //�ɿ���Դ
					+ " when dev_type like 'S0622%' then 9"       //������
					+ " end,acc.dev_model,acc.dev_sign,acc.dev_acc_id ");
		}

		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �жϱ��������豸�Ƿ����ã���������豸���ܳ�������״̬
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg revokeDevFlag(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String devAccIds = msg.getValue("devaccids");
		String revokeFlag = "0";
		String idss = "";
		String[] detInfo = devAccIds.substring(0,devAccIds.length() - 1).split(",",-1);
		try{
			String appSql = "select * from gms_device_account acc"
						  + " where acc.using_stat = '"+DevConstants.DEV_USING_ZAIYONG+"'"
						  + " and acc.dev_acc_id in (";
			for(int i=0;i<detInfo.length;i++){
				if(!"".equals(idss)){
					idss += ",";
				}
				idss += "'"+detInfo[i]+"'";
			}
			appSql = appSql+idss+")";
			
			Map recMap = jdbcDao.queryRecordBySQL(appSql);
			if(MapUtils.isNotEmpty(recMap)){
				revokeFlag = "1";//�������õ��豸
			}else{
				String upSql = "update gms_device_account"
							 + " set ifscrapleft = '',"
							 + " modifier = '"+ user.getEmpId() + "',"
							 + " modifi_date = sysdate"
							 + " where dev_acc_id in (";
				upSql = upSql+idss+")";
				jdbcDao.executeUpdate(upSql);
			}
		}catch(Exception e){
			revokeFlag = "3";//����ʧ��
		}
		responseDTO.setValue("datas", revokeFlag);
		return responseDTO;
	}
	/**
	 * NEWMETHOD ��ӱ��������豸
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveScrapDevInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String[] devAccIds = msg.getValue("devaccids").split(",", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < devAccIds.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("dev_acc_id", devAccIds[index]);
			dataMap.put("using_stat", DevConstants.DEV_USING_XIANZHI);
			dataMap.put("tech_stat", DevConstants.DEV_TECH_WANHAO);
			dataMap.put("modifier", user.getEmpId());
			datasList.add(dataMap);
		}
		String upSql = "update gms_device_account set"
					 + " ifscrapleft = ?,using_stat = ?,tech_stat = ?,"
					 + " modifier = ?,modifi_date = sysdate where dev_acc_id = ?";
		jdbcDao.getJdbcTemplate().batchUpdate(upSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> roleSaveMap = datasList.get(i);
						ps.setString(1, DevConstants.IFSCRAPLEFT_FLAG_1);
						ps.setString(2, (String) roleSaveMap.get("using_stat"));
						ps.setString(3, (String) roleSaveMap.get("tech_stat"));
						ps.setString(4, (String) roleSaveMap.get("modifier"));
						ps.setString(5, (String) roleSaveMap.get("dev_acc_id"));
					}

					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �����豸��ŵ���Ϣ
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveDevPositionInfo(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		String[] devAccIds = msg.getValue("devaccids").split(",", -1);
		final List<Map<String, Object>> datasList = new ArrayList<Map<String, Object>>();
		for (int index = 0; index < devAccIds.length; index++) {
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("dev_acc_id", devAccIds[index]);			
			dataMap.put("position_id", msg.getValue("provposcode"));
			dataMap.put("dev_position", msg.getValue("provpos"));
			dataMap.put("modifier", user.getEmpId());
			datasList.add(dataMap);
		}
		String upSql = "update gms_device_account set"
					 + " position_id = ?,dev_position = ?,"
					 + " modifier = ?,modifi_date = sysdate"
					 + " where dev_acc_id = ?";
		jdbcDao.getJdbcTemplate().batchUpdate(upSql,
				new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						Map<String, Object> roleSaveMap = datasList.get(i);
						ps.setString(1, (String) roleSaveMap.get("position_id"));
						ps.setString(2, (String) roleSaveMap.get("dev_position"));
						ps.setString(3, (String) roleSaveMap.get("modifier"));
						ps.setString(4, (String) roleSaveMap.get("dev_acc_id"));
					}

					@Override
					public int getBatchSize() {
						return datasList.size();
					}
				});

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		return responseDTO;
	}
	/**
	 * NEWMETHOD �жϵ��������Ƿ����
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg opCollIfExist(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String userSubOrg = user.getOrgSubjectionId();
		String existFlag = "0";
		String deviceId = msg.getValue("deviceid");
		String usageOrgId = msg.getValue("usageorgid");
		String devType = msg.getValue("devtype");
		try {
			String collSql = "select * from gms_device_coll_account"
					+ " where bsflag = '0' and device_id = '"+deviceId+"' and usage_org_id = '"+usageOrgId+"'";
			Map collMap = jdbcDao.queryRecordBySQL(collSql);
			if (MapUtils.isNotEmpty(collMap)) {
				existFlag = "1";// �Ѿ����ڴ��豸
			}
		} catch (Exception e) {
			e.printStackTrace();
			existFlag = "3";// ��ѯʧ��
		}
		responseDTO.setValue("datas", existFlag);
		return responseDTO;
	}
	/**
	 * ��ÿɿ���Դ��������
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getSparePartAnalByBj(ISrvMsg reqDTO) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		// �Ա��
		String type = reqDTO.getValue("type");
		if(null==type || StringUtils.isBlank(type)){
			type="";
		}
		// �Ա��
		String selfNums = reqDTO.getValue("selfNums");
		if(null==selfNums || StringUtils.isBlank(selfNums)){
			selfNums="";
		}
		String inSelectStr=StringUtil.getInSelectStr(selfNums);
		// ��ʼʱ��
		String startDate = reqDTO.getValue("startDate");
		if(null==startDate || StringUtils.isBlank(startDate)){
			startDate="";
		}
		// ����ʱ��
		String endDate = reqDTO.getValue("endDate");
		if(null==endDate || StringUtils.isBlank(endDate)){
			endDate="";
		}
		// ��Ŀid
		String projectInfoIds = reqDTO.getValue("projectInfoIds");
		if(null==projectInfoIds || StringUtils.isBlank(projectInfoIds)){
			projectInfoIds="";
		}
		String proIdInSelectStr=StringUtil.getInSelectStr(projectInfoIds);
		// ��Դ�ͺ�
		String devModel = reqDTO.getValue("devModel");
		if(null==devModel || StringUtils.isBlank(devModel)){
			devModel="";
		}
		String devModelInSelectStr=StringUtil.getInSelectStr(devModel);
		String actual_price = reqDTO.getValue("actual_price");
		StringBuilder sql = new StringBuilder(" select wz_name as coding_name,wz_id as coding_code_id,round(nvl(actual_price*sum(wz_use_num), 0)/10000,2) as amount,sum(wz_use_num) as use_num from ("
				+ " select i.wz_name,t.actual_price,nvl(tt1.wz_use_num,0) as wz_use_num,c.code_name,t.alias,t.recyclemat_info,t.wz_sequence,t.wz_id,t.postion,t.stock_num,i.wz_prickie,i.wz_price,i.coding_code_id"
				+ " from gms_mat_recyclemat_info t"
				+ " inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on t.wz_id=i.wz_id "
				+ " inner join (select m.wz_id, count(m.wxbymat_id) as wz_use_num from gms_device_zy_wxbymat m "
				+ " inner join gms_device_zy_bywx wb on wb.usemat_id = m.usemat_id "
				+ " inner join gms_device_account acc on (wb.fk_dev_acc_id = acc.dev_acc_id or wb.dev_acc_id = acc.dev_acc_id) and acc.bsflag != '1' "
				+ " where m.bsflag = '0' and m.wz_id not like '%zy%' ");
				// �Ա��
				if(StringUtils.isNotBlank(inSelectStr)){
					sql.append(" and acc.self_num in " +inSelectStr);
				}
				// ��ʼʱ��
				if(StringUtils.isNotBlank(startDate)){
					sql.append(" and wb.bywx_date>=to_date('" + startDate + "','yyyy-mm-dd') ");
				}
				// ����ʱ��
				if(StringUtils.isNotBlank(endDate)){
					sql.append(" and wb.bywx_date<=to_date('" + endDate + "','yyyy-mm-dd') ");
				}
				// ��Ŀid
				if(StringUtils.isNotBlank(proIdInSelectStr)){
					sql.append(" and wb.project_info_id in " +proIdInSelectStr);
				}
				// ��Դ�ͺ�
				if(StringUtils.isNotBlank(devModelInSelectStr)){
					sql.append(" and acc.dev_model in "+devModelInSelectStr);
				}
				sql.append("group by m.wz_id ) tt1 on t.wz_id=tt1.wz_id"
				+ " where t.bsflag='0'and t.wz_type='3' and t.project_info_id is null and t.wz_id not like '%zy%' ) tmp where 1=1 ");
				if(StringUtils.isNotBlank(actual_price)){
					sql.append("and tmp.actual_price > '"+actual_price+"'");
				}
				sql.append(" group by tmp.wz_id,tmp.wz_name,tmp.actual_price order by  tmp.wz_id asc");
		List<Map> list = jdbcDao.queryRecords(sql.toString());
		// ����xml����
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("chart");
		root.addAttribute("bgColor", "F3F5F4,DEE6EB");
		root.addAttribute("formatNumberScale", "0");
		root.addAttribute("baseFontSize", "12");
		if("num".equals(type)){
			root.addAttribute("yAxisName", "����(��)");
		}
		if("money".equals(type)){
			root.addAttribute("yAxisName", "���(��Ԫ)");
		}
		// ��������
		if(CollectionUtils.isNotEmpty(list)){
		    for (Map map:list) {
				Element set = root.addElement("set");
				set.addAttribute("label", map.get("coding_name").toString());
				if("num".equals(type)){
					set.addAttribute("value", map.get("use_num").toString());
				}
				if("money".equals(type)){
					set.addAttribute("value", map.get("amount").toString());
				}
		    }
		}
		responseDTO.setValue("Str", document.asXML());
		return responseDTO;
	}
	/**
	 * NEWMETHOD �豸̨��
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevAccList(ISrvMsg msg) throws Exception {
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
		String orgSubId = user.getSubOrgIDofAffordOrg();
		String devName = msg.getValue("devname");
		String devModel = msg.getValue("devmodel");
		String selfNum = msg.getValue("selfnum");
		String devSign = msg.getValue("devsign");
		String licenseNum = msg.getValue("licensenum");
		String devCoding = msg.getValue("devcoding");
		String sortField = msg.getValue("sort");
		String sortOrder = msg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		//DevConstants.COMM_COM_ORGSUBID
		if(orgSubId.equals(DevConstants.COMM_COM_ORGSUBID)){
			querySql.append("select u.coding_name as using_stat_desc,t.ifcountry,c.coding_name as tech_stat_desc,t.dev_coding,"
					+ " p.project_name as project_name_desc,t.dev_acc_id,t.dev_name,t.dev_model,t.dev_sign,t.self_num,t.license_num,t.dev_type,"
					+ " t.producting_date,t.asset_value,t.net_value,t.dev_position,t.asset_coding,t.cont_num,t.turn_num,t.using_stat,t.saveflag,"
					+ " t.spare1,t.spare2,t.spare3,t.spare4,"
					+ " case when t.owning_sub_id like 'C105001005%' then '����ľ��̽��' when t.owning_sub_id like 'C105001002%' then '�½���̽��'"
					+ " when t.owning_sub_id like 'C105001003%' then '�¹���̽��' when t.owning_sub_id like 'C105001004%' then '�ຣ��̽��'"
					+ " when t.owning_sub_id like 'C105005004%' then '������̽��' when t.owning_sub_id like 'C105005000%' then '������̽��'"
					+ " when t.owning_sub_id like 'C105005001%' then '������̽������' when t.owning_sub_id like 'C105007%' then '�����̽��'"
					+ " when t.owning_sub_id like 'C105063%' then '�ɺ���̽��' when t.owning_sub_id like 'C105086%' then '���̽��'"
					+ " when t.owning_sub_id like 'C105008%' then '�ۺ��ﻯ��' when t.owning_sub_id like 'C105002%' then '���ʿ�̽��ҵ��'"
					+ " when t.owning_sub_id like 'C105006%' then 'װ������' when t.owning_sub_id like 'C105003%' then '�о�Ժ'"
					+ " when t.owning_sub_id like 'C105017%' then '����������ҵ��' else info.org_abbreviation end as owning_org_name_desc,"
					+ " i.org_abbreviation usage_org_name_desc,co.coding_name as account_stat_desc,"
					+ " case when t.ifyellowlabel = '1' then '��' else '��' end as ifyellowlabel_desc"
					+ " from gms_device_account t "
					+ " left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0'"
					+ " left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0'"
					+ " left join gp_task_project p on t.project_info_no = p.project_info_no"
					+ " left join comm_coding_sort_detail co on co.coding_code_id = t.account_stat"
					+ " left join comm_coding_sort_detail c on c.coding_code_id = t.tech_stat"
					+ " left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat");
		}else{
			querySql.append("select u.coding_name as using_stat_desc,t.ifcountry,c.coding_name as tech_stat_desc,"
					+ " t.dev_coding,p.project_name as project_name_desc,t.dev_acc_id,t.dev_name,"
					+ " t.dev_model,t.dev_sign,t.self_num,t.license_num,t.dev_type,t.producting_date,"
					+ " t.asset_value,t.net_value,t.dev_position,t.asset_coding,t.cont_num,t.turn_num,t.using_stat,"
					+ " t.saveflag,t.spare1,t.spare2,t.spare3,t.spare4,info.org_abbreviation as owning_org_name_desc,"
					+ " i.org_abbreviation usage_org_name_desc,co.coding_name as account_stat_desc,"
					+ " case when t.ifyellowlabel = '1' then '��' else '��' end as ifyellowlabel_desc"
					+ " from gms_device_account t "
					+ " left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag = '0' "
					+ " left join comm_org_information info on t.owning_org_id = info.org_id and info.bsflag = '0' "
					+ " left join gp_task_project p on t.project_info_no = p.project_info_no "
					+ " left join comm_coding_sort_detail co on co.coding_code_id = t.account_stat "
					+ " left join comm_coding_sort_detail c on c.coding_code_id = t.tech_stat"
					+ " left join comm_coding_sort_detail u on u.coding_code_id = t.using_stat");
		}//��ʾ�ʲ�״̬�����ˡ�������(�ֹ�¼��δת��)���������õ��豸
		querySql.append(" where t.bsflag = '"+DevConstants.BSFLAG_NORMAL+"'"
				    + " and (t.account_stat = '"+DevConstants.DEV_ACCOUNT_ZAIZHANG+"'"
				    + " or t.account_stat = '"+DevConstants.DEV_ACCOUNT_BUZAIZHANG+"'"
				    + " or (t.account_stat = '"+DevConstants.DEV_ACCOUNT_BAOFEI+"'"
				    + " and t.ifscrapleft = '"+DevConstants.IFSCRAPLEFT_FLAG_1+"'))");
		
		//�豸����
		if (StringUtils.isNotBlank(devName)) {
			querySql.append(" and acc.dev_name like '%"+devName+"%'");
		}
		//�豸�ͺ�
		if (StringUtils.isNotBlank(devModel)) {
			querySql.append(" and acc.dev_model like '%"+devModel+"%'");
		}
		//�Ա��
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and acc.self_num like '%"+selfNum+"%'");
		}
		//ʵ���ʶ��
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and acc.dev_sign like '%"+devSign+"%'");
		}
		//���պ�
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and acc.license_num like '%"+licenseNum+"%'");
		}
		//ERP�豸���
		if (StringUtils.isNotBlank(devCoding)) {
			querySql.append(" and acc.dev_coding like '%"+devCoding+"%'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+",t.dev_acc_id ");
		}else{
			querySql.append(" order by t.dev_type,t.owning_sub_id,t.using_stat,t.license_num,"
					+ " t.self_num,t.dev_sign,t.account_stat desc");
		}

		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
}
