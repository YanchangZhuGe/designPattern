package com.bgp.dms.assess;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import com.bgp.dms.device.DeviceAnalSrv;
import com.bgp.gms.service.rm.dm.bean.DeviceMCSBean;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;
import com.bgp.gms.service.rm.dm.constants.DevConstants;

/**
 * project: �豸��ϵ��Ϣ������
 * 
 * creator: dz
 * 
 * creator time:2015-5-6
 * 
 * description:�豸���˲�ѯ��ط���
 * 
 */
@Service("DeviceAssessSrv")
@SuppressWarnings({"unchecked","unused"})
public class DeviceAssessInfoSrv extends BaseService {
	
	public DeviceAssessInfoSrv() {
		log = LogFactory.getLogger(DeviceAssessInfoSrv.class);
	}
	
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	
	/**
	 * NEWMETHOD
	 * ҳ�濼��ָ����Ϣ��ʾ
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryAssessList(ISrvMsg msg) throws Exception {
		log.info("queryAssessList");
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
		String assessname = msg.getValue("assess_name");//ָ������
		StringBuffer querySql = new StringBuffer();
		querySql.append("select main.assess_mainid,det.coding_name as assess_name,"
				+ " create_org_id,org.org_name as create_org_name,main.creator,"
				+ " emp.employee_name as creator_name,"
				+ " main.create_date from dms_device_assess_main main "
				+ " left join comm_org_information org on main.create_org_id=org.org_id and org.bsflag='0' "
				+ " left join comm_human_employee emp on main.creator = emp.employee_id "
				+ " left join comm_coding_sort_detail det on main.assess_type = det.coding_code_id "
				+ " where main.bsflag='0' ");
		// ָ������
		if (StringUtils.isNotBlank(assessname)) {
			querySql.append(" and det.coding_name like '%" + assessname + "%'");
		}
		querySql.append(" order by main.modify_date desc");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * ���˽����Ϣ��ʾ
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessSqlInfo(ISrvMsg msg) throws Exception {
		log.info("getAssessSqlInfo");
		String pageFlag = msg.getValue("pageFlag");
		
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		
		String sqlStart = " and device_type in (select device_code from dms_device_tree where ";
		String sqlEnd = " and device_code is not null ) ";
		String perStr = "(dev_tree_id like '";
		String useStr = "(dev_tree_id like '";
		String gnStr = "����";
		String gwStr = "����";
		
		//�����
		StringBuffer perfect_str = new StringBuffer()
					.append("select main.assess_dev_type,main.assess_account_stat,main.assess_ifproduction,")
					.append("main.assess_ifcountry from dms_device_assess_main main where main.bsflag='0' ")
					.append("and main.assess_type='"+DevConstants.DMS_ASSESS_PERFECT_RATE+"' ");
		Map assessPerMap = jdbcDao.queryRecordBySQL(perfect_str.toString());
		//�豸����
		String devTypePerTemp = (String)assessPerMap.get("assess_dev_type");
		String[] devTypePerLen = devTypePerTemp.split(",",-1);
		if(pageFlag != null && "1".equals(pageFlag)){
			for(int i = 0; i < devTypePerLen.length; i++) {			
				if(i==devTypePerLen.length-1){
					perStr += devTypePerLen[i]+"%25')";
				}else{
					perStr += devTypePerLen[i] +"%25' or dev_tree_id like '";
				}
			}
		}else{
			for(int i = 0; i < devTypePerLen.length; i++) {			
				if(i==devTypePerLen.length-1){
					perStr += devTypePerLen[i]+"%')";
				}else{
					perStr += devTypePerLen[i] +"%' or dev_tree_id like '";
				}
			}
		}
		
		//�ʲ�״̬
		String accountPerStr = " and account_stat in ( '";		
		String accountPerTemp = (String)assessPerMap.get("assess_account_stat");
		String[] accountPerPerLen = accountPerTemp.split(",",-1);
		for(int i = 0; i < accountPerPerLen.length; i++) {			
			if(i==accountPerPerLen.length-1){
				accountPerStr += accountPerPerLen[i]+"')";
			}else{
				accountPerStr += accountPerPerLen[i] +"','";
			}
		}
		
		//�Ƿ������豸
		String ifproductionPerStr = " and ifproduction in ( '";
		String ifproductionPerTemp = (String)assessPerMap.get("assess_ifproduction");
		String[] ifproductionPerPerLen = ifproductionPerTemp.split(",",-1);
		for(int i = 0; i < ifproductionPerPerLen.length; i++) {			
			if(i==ifproductionPerPerLen.length-1){
				ifproductionPerStr += ifproductionPerPerLen[i]+"')";
			}else{
				ifproductionPerStr += ifproductionPerPerLen[i] +"','";
			}
		}
		
		// ����/�����ʶ
		String ifcountryPerStr = " and country in ( '";
		String ifcountryPerTemp = (String)assessPerMap.get("assess_ifcountry");
		String[] ifcountryPerLen = ifcountryPerTemp.split(",",-1);
		if(pageFlag != null && "1".equals(pageFlag)){
			for(int i = 0; i < ifcountryPerLen.length; i++) {			
				if(i==ifcountryPerLen.length-1){
					if(DevConstants.DMS_ASSESS_INCOUNTRY.equals(ifcountryPerLen[i])){
						ifcountryPerStr += java.net.URLEncoder.encode(gnStr, "GBK")+"')";
					}else{
						ifcountryPerStr += java.net.URLEncoder.encode(gwStr, "GBK")+"')";
					}				
				}else{
					if(DevConstants.DMS_ASSESS_INCOUNTRY.equals(ifcountryPerLen[i])){
						ifcountryPerStr += java.net.URLEncoder.encode(gnStr, "GBK") +"','";
					}else{
						ifcountryPerStr += java.net.URLEncoder.encode(gwStr, "GBK") +"','";
					}				
				}
			}
		}else{
			for(int i = 0; i < ifcountryPerLen.length; i++) {			
				if(i==ifcountryPerLen.length-1){
					if(DevConstants.DMS_ASSESS_INCOUNTRY.equals(ifcountryPerLen[i])){
						ifcountryPerStr += gnStr +"')";
					}else{
						ifcountryPerStr += gwStr +"')";
					}				
				}else{
					if(DevConstants.DMS_ASSESS_INCOUNTRY.equals(ifcountryPerLen[i])){
						ifcountryPerStr += gnStr +"','";
					}else{
						ifcountryPerStr += gwStr +"','";
					}				
				}
			}
		}
		
		String perSql = sqlStart + perStr + sqlEnd + ifproductionPerStr + ifcountryPerStr + accountPerStr;
		//������
		StringBuffer use_str = new StringBuffer()
					.append("select main.assess_dev_type,main.assess_account_stat,main.assess_ifproduction,")
					.append("main.assess_ifcountry from dms_device_assess_main main where main.bsflag='0' ")
					.append("and main.assess_type='"+DevConstants.DMS_ASSESS_USE_RATE+"' ");
		Map assessUseMap = jdbcDao.queryRecordBySQL(use_str.toString());
		//�豸����
		String devTypeUseTemp = (String)assessUseMap.get("assess_dev_type");
		String[] devTypeUseLen = devTypeUseTemp.split(",",-1);
		if(pageFlag != null && "1".equals(pageFlag)){
			for(int j = 0; j < devTypeUseLen.length; j++) {
				if(j==devTypeUseLen.length-1){
					useStr += devTypeUseLen[j]+"%25')";
				}else{
					useStr += devTypeUseLen[j] +"%25' or dev_tree_id like '";
				}
			}
		}else{
			for(int j = 0; j < devTypeUseLen.length; j++) {
				if(j==devTypeUseLen.length-1){
					useStr += devTypeUseLen[j]+"%')";
				}else{
					useStr += devTypeUseLen[j] +"%' or dev_tree_id like '";
				}
			}
		}
		
		//�ʲ�״̬
		String accountUseStr = " and account_stat in ( '";
		String accountUseTemp = (String)assessPerMap.get("assess_account_stat");
		String[] accountUsePerLen = accountUseTemp.split(",",-1);
		for(int i = 0; i < accountUsePerLen.length; i++) {			
			if(i==accountUsePerLen.length-1){
				accountUseStr += accountUsePerLen[i]+"')";
			}else{
				accountUseStr += accountUsePerLen[i] +"','";
			}
		}
		
		//�Ƿ������豸
		String ifproductionUseStr = " and ifproduction in ( '";
		String ifproductionUseTemp = (String)assessPerMap.get("assess_ifproduction");
		String[] ifproductionUsePerLen = ifproductionUseTemp.split(",",-1);
		for(int i = 0; i < ifproductionUsePerLen.length; i++) {			
			if(i==ifproductionUsePerLen.length-1){
				ifproductionUseStr += ifproductionUsePerLen[i]+"')";
			}else{
				ifproductionUseStr += ifproductionUsePerLen[i] +"','";
			}
		}
		
		// ����/�����ʶ
		String ifcountryUseStr = " and country in ( '";
		String ifcountryUseTemp = (String)assessPerMap.get("assess_ifcountry");
		String[] ifcountryUseLen = ifcountryPerTemp.split(",",-1);
		if(pageFlag != null && "1".equals(pageFlag)){
			for(int i = 0; i < ifcountryUseLen.length; i++) {			
				if(i==ifcountryUseLen.length-1){
					if(DevConstants.DMS_ASSESS_INCOUNTRY.equals(ifcountryUseLen[i])){
						ifcountryUseStr += java.net.URLEncoder.encode(gnStr, "GBK")+"')";
					}else{
						ifcountryUseStr += java.net.URLEncoder.encode(gwStr, "GBK")+"')";
					}				
				}else{
					if(DevConstants.DMS_ASSESS_INCOUNTRY.equals(ifcountryUseLen[i])){
						ifcountryUseStr += java.net.URLEncoder.encode(gnStr, "GBK") +"','";
					}else{
						ifcountryUseStr += java.net.URLEncoder.encode(gwStr, "GBK") +"','";
					}				
				}
			}
		}else{
			for(int i = 0; i < ifcountryUseLen.length; i++) {			
				if(i==ifcountryUseLen.length-1){
					if(DevConstants.DMS_ASSESS_INCOUNTRY.equals(ifcountryUseLen[i])){
						ifcountryUseStr += gnStr +"')";
					}else{
						ifcountryUseStr += gwStr +"')";
					}				
				}else{
					if(DevConstants.DMS_ASSESS_INCOUNTRY.equals(ifcountryUseLen[i])){
						ifcountryUseStr += gnStr +"','";
					}else{
						ifcountryUseStr += gwStr +"','";
					}				
				}
			}
		}
		
		String useSql = sqlStart + useStr + sqlEnd + ifproductionUseStr + ifcountryUseStr +accountUseStr;
		System.out.println("perSql == "+perSql);
		System.out.println("useSql == "+useSql);
		responseMsg.setValue("perSql", perSql);
		responseMsg.setValue("useSql",useSql);
		return responseMsg;
	}
	/**
	 * NEWMETHOD
	 * ��λ����ָ����Ϣ��ʾ
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryOrgAssessList(ISrvMsg msg) throws Exception {
		log.info("queryOrgAssessList");
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
		String assessname = msg.getValue("assess_name");//ָ������
		String assessorgid = msg.getValue("assess_org_id");//��λ����
		StringBuffer querySql = new StringBuffer();
		querySql.append("select dms.assess_id,det.coding_name as assess_name,create_org_id,wtc.org_abbreviation as wtc_org_name,"
				+ " nvl(dms.assess_value,0) assess_value,org.org_name as create_org_name,dms.creator,emp.employee_name as creator_name,dms.create_date,"
				+ " nvl(dms.assess_org_ceiling,0) assess_org_ceiling,nvl(dms.assess_org_floor,0) assess_org_floor  from dms_device_org_assess dms"
				+ " left join comm_org_information org on dms.create_org_id=org.org_id and org.bsflag='0'"
				+ " left join comm_org_subjection sub on sub.org_id = dms.assess_org_id and sub.bsflag = '0'"
				+ " left join bgp_comm_org_wtc wtc on dms.assess_org_id = wtc.org_id and wtc.bsflag = '0'"
				+ " left join comm_human_employee emp on dms.creator = emp.employee_id"
				+ " left join comm_coding_sort_detail det on dms.assess_type = det.coding_code_id"
				+ " where dms.bsflag='0' ");
		if(!DevConstants.COMM_COM_ORGSUBID.equals(user.getSubOrgIDofAffordOrg())){
			querySql.append(" and sub.org_subjection_id like '" + user.getSubOrgIDofAffordOrg() + "%'");
		}
		// ָ������
		if (StringUtils.isNotBlank(assessname)) {
			querySql.append(" and det.coding_name like '%" + assessname + "%'");
		}
		// ָ�굥λ
		if (StringUtils.isNotBlank(assessorgid)) {
			querySql.append(" and dms.assess_org_id = '" + assessorgid + "' ");
		}
		querySql.append(" order by dms.modify_date desc");
		page = pureDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD
	 * ��ѯ��λָ��Ȩ����Ϣ
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOrgAssessBaseInfo(ISrvMsg msg) throws Exception {
		log.info("getOrgAssessBaseInfo");
		String assess_id = msg.getValue("assessid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String[] temp = assess_id.split(",");
		String assessids = "";
		
		for(int i=0;i<temp.length;i++){
			if(assessids!="") assessids += ",";
			assessids += "'"+temp[i]+"'";
		}
		
		StringBuffer sb = new StringBuffer()
					.append("select dms.assess_id,det.coding_name as assess_name,dms.create_org_id,wtc.org_abbreviation as wtc_org_name,")
					.append("nvl(dms.assess_value,0) assess_value,org.org_name as create_org_name,dms.creator,emp.employee_name as creator_name,dms.create_date,")
					.append("dms.remark,nvl(dms.assess_org_ceiling,0) assess_org_ceiling,nvl(dms.assess_org_floor,0) assess_org_floor from dms_device_org_assess dms ")
					.append("left join comm_org_information org on dms.create_org_id = org.org_id and org.bsflag = '0' ")
					.append("left join bgp_comm_org_wtc wtc on dms.assess_org_id = wtc.org_id and wtc.bsflag = '0' ")
					.append("left join comm_human_employee emp on dms.creator = emp.employee_id ")
					.append("left join comm_coding_sort_detail det on dms.assess_type = det.coding_code_id ")
					.append("where dms.bsflag = '0' and dms.assess_id in ("+assessids+" )");
		
		List<Map> assessOrgList = jdbcDao.queryRecords(sb.toString());
		if(assessOrgList!=null){
			responseMsg.setValue("assessOrgList", assessOrgList);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD
	 * ��ѯָ����ϸ��Ϣ
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessBaseInfo(ISrvMsg msg) throws Exception {
		log.info("getAssessBaseInfo");
		String assess_mainid = msg.getValue("assessmainid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		
		StringBuffer sb = new StringBuffer()
					.append("select main.assess_ceiling,main.assess_floor,main.assess_mainid,main.assess_type,det.coding_name as assess_name,create_org_id,org.org_name as create_org_name,main.creator,")
					.append("main.assess_dev_type,main.assess_account_stat,main.assess_ifproduction,main.assess_ifcountry,")
					.append("emp.employee_name as creator_name,main.create_date from dms_device_assess_main main ")
					.append("left join comm_org_information org on main.create_org_id=org.org_id and org.bsflag='0' ")
					.append("left join comm_human_employee emp on main.creator = emp.employee_id ")
					.append("left join comm_coding_sort_detail det on main.assess_type = det.coding_code_id ")
					.append("where main.bsflag='0' and  main.assess_mainid='"+assess_mainid+"' ");
		Map assessMainMap = jdbcDao.queryRecordBySQL(sb.toString());
		//�豸����
		String devtype = assessMainMap.get("assess_dev_type").toString();
		String devtype_name = "";
		String[] devtypeLen = devtype.split(",",-1);
		for(int i = 0; i < devtypeLen.length; i++) {
            Map<String,Object> devTypeMap = 
            	jdbcDao.queryRecordBySQL("select tree.device_name from dms_device_tree tree where tree.bsflag='0' and tree.dev_tree_id='"+devtypeLen[i]+"' ");
            devtype_name =devtype_name+","+devTypeMap.get("device_name").toString();
        }		
        assessMainMap.put("dev_type_name", devtype_name.replaceAll(",(.*)","$1"));
        
        //�ʲ�״��
		String accountstat = assessMainMap.get("assess_account_stat").toString();
		String accountstat_name = "";
		String[] accountstatLen = accountstat.split(",",-1);
		for (int i = 0; i < accountstatLen.length; i++) {
            Map<String,Object> accountStatMap = 
            	jdbcDao.queryRecordBySQL("select l.coding_name from comm_coding_sort_detail l where l.bsflag='0' and l.coding_code_id ='"+accountstatLen[i]+"' ");
            accountstat_name =accountstat_name+","+accountStatMap.get("coding_name").toString();
        }		
        assessMainMap.put("account_stat_name", accountstat_name.replaceAll(",(.*)","$1"));
        
        //�����豸
		String ifproduction = assessMainMap.get("assess_ifproduction").toString();
		String ifproduction_name = "";
		String[] ifproductionLen = ifproduction.split(",",-1);
		for (int i = 0; i < ifproductionLen.length; i++) {
            Map<String,Object> ifproductionMap = 
            	jdbcDao.queryRecordBySQL("select l.coding_name from comm_coding_sort_detail l where l.bsflag='0' and l.coding_code_id ='"+ifproductionLen[i]+"' ");
            ifproduction_name =ifproduction_name+","+ifproductionMap.get("coding_name").toString();
        }		
        assessMainMap.put("ifproduction_name", ifproduction_name.replaceAll(",(.*)","$1"));
        
        //����/����
		String ifcountry = assessMainMap.get("assess_ifcountry").toString();
		String ifcountry_name = "";
		String[] ifcountryLen = ifcountry.split(",",-1);
		for (int i = 0; i < ifcountryLen.length; i++) {
            Map<String,Object> ifcountryMap = 
            	jdbcDao.queryRecordBySQL("select l.coding_name from comm_coding_sort_detail l where l.bsflag='0' and l.coding_code_id ='"+ifcountryLen[i]+"' ");
            ifcountry_name =ifcountry_name+","+ifcountryMap.get("coding_name").toString();
        }		
        assessMainMap.put("ifcountry_name", ifcountry_name.replaceAll(",(.*)","$1"));
                
		if(assessMainMap != null){
			responseMsg.setValue("assessMainMap", assessMainMap);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD
	 * ��ѯָ�������Ƿ����
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessExist(ISrvMsg msg) throws Exception {
		log.info("getAssessExist");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String assessType = msg.getValue("assesstype");
		String exist_tmp = "0";//�����ڱ�ʶ
		//�����
		StringBuffer assess_str = new StringBuffer()
					.append("select main.assess_mainid from dms_device_assess_main main ")
					.append("where main.bsflag = '0' and main.assess_type='"+assessType+"' ");
		Map existMap = jdbcDao.queryRecordBySQL(assess_str.toString());
		if(existMap != null){
			exist_tmp = "1";//����
		}
		responseMsg.setValue("existtmp", exist_tmp);
		return responseMsg;
	}
	/**
	 * NEWMETHOD
	 * ��ѯ��λָ���Ƿ����
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getOrgAssessExist(ISrvMsg msg) throws Exception {
		log.info("getOrgAssessExist");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String assessOrg = msg.getValue("assessorg");
		String assessType = msg.getValue("assesstype");
		String exist_tmp = "0";//�����ڱ�ʶ
		//�����
		StringBuffer assess_str = new StringBuffer()
					.append("select ass.assess_id from dms_device_org_assess ass ")
					.append("where ass.bsflag = '0' and ass.assess_org_id = '"+assessOrg+"' ")
					.append("and ass.assess_type = '"+assessType+"'");
		Map existMap = jdbcDao.queryRecordBySQL(assess_str.toString());
		if(existMap!=null){
			exist_tmp = "1";//����
		}
		responseMsg.setValue("existtmp", exist_tmp);
		return responseMsg;
	}
	/**
	 * NEWMETHOD
	 * ��ѯȫ��ָ��
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAllAssessInfo(ISrvMsg msg) throws Exception {
		log.info("getAllAssessInfo");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
					.append("select t.coding_code_id as value,t.coding_name as label ")
					.append("from comm_coding_sort_detail t ")
					.append("where t.coding_sort_id='"+DevConstants.DMS_ASSESS_FATHER_CODE+"' and t.bsflag='0' order by t.coding_show_id ");
		List<Map> assesslist = jdbcDao.queryRecords(sb.toString());
                
		if(assesslist!=null){
			responseMsg.setValue("assesslist", assesslist);
		}
		return responseMsg;
	}
	/**
	 * NEWMETHOD
	 * ��ѯָ����λ��ָ��
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getAssessOrgInfo(ISrvMsg msg) throws Exception {
		log.info("getAssessOrgInfo");
		UserToken user = msg.getUserToken();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		String select_org = msg.getValue("selectorg");
		StringBuffer sb = null;
		if((select_org!=null&&!"".equals(select_org)
				&&select_org.equals(user.getCodeAffordOrgID()))
					||((select_org!=null&&!"".equals(select_org))
							&&DevConstants.COMM_COM_ORGSUBID.equals(user.getSubOrgIDofAffordOrg()))){
			sb = new StringBuffer()
				.append("select wtc.org_id as value,wtc.org_abbreviation as label ")
				.append("from bgp_comm_org_wtc wtc ")
				.append("where wtc.bsflag = '0' and wtc.org_id ='"+select_org+"' ");
		}else{
			sb = new StringBuffer()
				.append("select wtc.org_id as value,wtc.org_abbreviation as label ")
				.append("from bgp_comm_org_wtc wtc where wtc.bsflag = '0' ")		
				.append("and wtc.org_subjection_id like '" + user.getSubOrgIDofAffordOrg() + "%' ")
				.append("order by wtc.order_num desc");
		}
		
		List<Map> assessOrglist = jdbcDao.queryRecords(sb.toString());
                
		if(assessOrglist!=null){
			responseMsg.setValue("assessOrglist", assessOrglist);
		}
		return responseMsg;
	}
}
