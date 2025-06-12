package com.bgp.dms.keeping;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.util.CommonConstants;
import com.bgp.dms.util.ServiceUtils;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
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
import com.cnpc.jcdp.util.DateUtil;

public class DevInfoConf extends BaseService{

	public DevInfoConf() {
		log = LogFactory.getLogger(DevInfoConf.class);
	}
	
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	
	/**
	 * 判断是否重复数据(特种设备)
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addDevFlag(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		String addFlag = "0";
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String sql="select * from gms_device_account_s where DEV_SIGN='"+isrvmsg.getValue("devsign")+"' and bsflag='0'";
		try {
			Map appMap=jdbcDao.queryRecordBySQL(sql);
			if(MapUtils.isNotEmpty(appMap)){
				addFlag = "1";//此实物标识号设备存在
			}
		} catch (Exception e) {
			// TODO: handle exception
			addFlag = "3";//查询失败
		}
		responseDTO.setValue("datas", addFlag);
		return responseDTO;
	}
	/**
	 * 查询设备台账(单台) 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryCheckList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryCheckList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String dev_acc_id = isrvmsg.getValue("dev_acc_id");// 车牌号码
		
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,(select wm_concat(number1) from gms_device_check_items i where i.item_code = dev_type and father_num is null) types from (select c.check_id,c.ischeck, case when dev_type like 'S1507%' then 'DT' when dev_type like 'S07010201%' then 'DC' when dev_type like 'S080601%' then 'S080601' else dev_type end dev_type, decode(c.actual_out_date, null, c.create_date, actual_out_date) actual_out_date, decode(c.checkperson, null, (select u.user_name from p_auth_user u where u.user_id = c.creator), c.checkperson) checkperson, data_from from GMS_DEVICE_CHECK c, gms_device_account_s s where c.dev_acc_id = s.dev_acc_id and c.dev_acc_id='"+dev_acc_id+"') t order by actual_out_date desc ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询设备台账(单台) 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String orgSubId = user.getOrgSubjectionId();// 所属机构单位
		if(StringUtils.isNotBlank(orgSubId)){
			orgSubId=user.getSubOrgIDofAffordOrg();
		}
		String start_date=isrvmsg.getValue("start_date");
		String end_date=isrvmsg.getValue("end_date");
		String lastdate=null;
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select * from (select nvl(floor(sysdate -(select max(next_date) from GMS_DEVICE_DEVSPECIAL where acc.dev_acc_id = dev_acc_id)), -9999) days, (select max(next_date) from GMS_DEVICE_DEVSPECIAL where acc.dev_acc_id = dev_acc_id) next_date, acc.*,substr(acc.registration_code,0,6)  registration_code_desc,substr(acc.INSTALLTION_PLACE,0,6) INSTALLTION_PLACE_desc, decode(dev_type_s, '1', '电梯', '2', '叉车', '3', '电瓶车', '起重机') dev_type2, info.org_abbreviation, info.org_name, info1.org_abbreviation org_abbreviation1, info1.org_name org_name1, decode(acc.zc_stat, '0', '未注册', null, '未注册', '已注册') zc, decode(acc.dev_type_s, '1', 'DT', '2', 'CC', '3', 'GL', 'DC') dev_type1, d.coding_name from gms_device_account_s acc left join comm_org_information info on info.bsflag = '0' and acc.owning_org_id = info.org_id left join comm_org_information info1 on info1.bsflag = '0' and acc.usage_org_id = info1.org_id left join comm_coding_sort_detail d on d.coding_code_id = acc.using_stat and d.bsflag = '0' where acc.bsflag = '0' and acc.ifcountry = '国内'  and (acc.account_stat = '0110000013000000003' or acc.account_stat='0110000013000000006') ");
		
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and (acc.owning_sub_id  like '"+orgSubId+"%'  or acc.usage_sub_id like '"+orgSubId+"%')" );
			}
		}
		Map maps=isrvmsg.toMap();
		Set set= maps.keySet();
		for (Object key : set) {
			String keys=(String) key;
			if(keys.startsWith("query_")){
		  String 	value= (String) maps.get(key);
		  if(StringUtils.isNotBlank(value)){
			
			  if("start_date".equals(keys.substring(6).toLowerCase())){
				start_date=value;
			  }else if("end_date".equals(keys.substring(6).toLowerCase())){
				end_date=value;
			  }else if("lastdate".equals(keys.substring(6).toLowerCase())){
				  lastdate=value;
			  }else{
			  querySql.append(" and "+ keys.substring(6) +" like '%"+value+"%'");
			  }
		  }
		}
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ) where 1=1");
		}else{
			querySql.append(" order by decode(coding_name, '在用', 1, '停用', 2),next_date nulls first,days desc,org_abbreviation,dev_sign) where 1=1");
		}
		
		  if(StringUtils.isNotBlank(start_date)){
			  querySql.append(" and  next_date >= to_date('"+start_date+"','yyyy-MM-dd')");}
		 if(StringUtils.isNotBlank(end_date)){
			  querySql.append(" and  next_date <= to_date('"+end_date+"','yyyy-MM-dd')");}
		 if(StringUtils.isNotBlank(lastdate)){
			 if("0".equals(lastdate)){
				querySql.append(" and days>=-30 ");
			 }else{
				querySql.append(" and days<-30 ");
			 }
		 }
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询电梯维保信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryListOfDtbywx(ISrvMsg isrvmsg) throws Exception {
		log.info("queryListOfDtbywx");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String dev_acc_id=isrvmsg.getValue("dev_acc_id");
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.*,bf.file_id,bf.file_name from gms_device_dtbywx d left join BGP_DOC_GMS_FILE bf on d.dtbywx_id=bf.relation_id and bf.bsflag='0' where d.BSFLAG = '0' ");
		 if(StringUtils.isNotBlank(dev_acc_id)){
			 querySql.append(" and dev_acc_id='"+dev_acc_id+"'");
		 }
		 querySql.append(" order by bywx_date ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询特种设备检验信息
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryListOfDEVSPECIAL(ISrvMsg isrvmsg) throws Exception {
		log.info("queryList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String dev_acc_id=isrvmsg.getValue("dev_acc_id");
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.*,bf.file_id,bf.file_name from GMS_DEVICE_DEVSPECIAL d left join BGP_DOC_GMS_FILE bf on d.devspecial_id=bf.relation_id and bf.bsflag='0' where d.BSFLAG = '0' ");
		 if(StringUtils.isNotBlank(dev_acc_id)){
			 querySql.append(" and dev_acc_id='"+dev_acc_id+"'");
		 }
		 querySql.append(" order by next_date ");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 加载详细信息
	 * 
	 */
	public ISrvMsg getKeepingDevInfo(ISrvMsg msg) throws Exception {
		String keeping_id = msg.getValue("keeping_id");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
			.append("select t.*,info.org_abbreviation out_org_name from dms_device_keeping t "
				+ "left join comm_org_information info on t.sub_org_id = info.org_id "
				+ "left join comm_org_subjection sub on t.sub_org_id = sub.org_id "
				+ "where t.bsflag = '0' and t.keeping_id='"+keeping_id+"'");
		Map mixMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mixMap)) {
			responseMsg.setValue("data", mixMap);
		}
		return responseMsg;
	}
	
	public ISrvMsg getKeepingDev(ISrvMsg msg) throws Exception {
		String dev_acc_id = msg.getValue("dev_acc_id");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		StringBuffer sb = new StringBuffer()
			.append("select * from gms_device_account account where account.dev_acc_id='"+dev_acc_id+"'");
		Map mixMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(mixMap)) {
			responseMsg.setValue("data", mixMap);
		}
		return responseMsg;
	}
	/**
	 * 设置特种设备
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg savedevSpecial(ISrvMsg msg) throws Exception {
		String dev_acc_id = msg.getValue("dev_acc_id");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		List<String> infoList=new ArrayList<String>();
		String [] ids=dev_acc_id.split("@");
		for (int i = 0; i < ids.length; i++) {
			if(StringUtils.isNotBlank(ids[i])){
				String inserinfoSql="update gms_device_account acc set acc.spare6='1' where acc.dev_acc_id='"+ids[i]+"'";
				infoList.add(inserinfoSql);
			}
			
		}
			String [] inserinfoSqls= infoList.toArray(new String[infoList.size()]);
			if(inserinfoSqls.length!=0){
				try {
					jdbcDao.getJdbcTemplate().batchUpdate(inserinfoSqls);
					responseMsg.setValue("result", 0);//操作成功
					responseMsg.setValue("msg","操作成功");//操作成功
				} catch (Exception e) {
					e.printStackTrace();
					responseMsg.setValue("result", 1);//操作成功
					responseMsg.setValue("msg","操作失败");//操作成功
				}
			}
		return responseMsg;
	}
	/**
	 * 删除特种设备
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updatedevSpecial(ISrvMsg msg) throws Exception {
		String dev_acc_id = msg.getValue("dev_acc_id");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(msg);
		List<String> infoList=new ArrayList<String>();
		String inserinfoSql="update gms_device_account_s acc set acc.bsflag='1' where acc.dev_acc_id='"+dev_acc_id+"'";
				try {
					jdbcDao.executeUpdate(inserinfoSql) ;
					responseMsg.setValue("result", 0);//操作成功
					responseMsg.setValue("msg","操作成功");//操作成功
				} catch (Exception e) {
					e.printStackTrace();
					responseMsg.setValue("result", 1);//操作成功
					responseMsg.setValue("msg","操作失败");//操作成功
				}
		 
		return responseMsg;
	}
	/**
	 * 查询设备出入库信息 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryKeepingDevList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryKeepingDevList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("page");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("rows");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String dev_num = isrvmsg.getValue("q_dev_num");// 车牌号码
		String dev_type = isrvmsg.getValue("q_dev_type");// 设备类别
		String dev_name = isrvmsg.getValue("q_dev_name");// 设备名称
		String thing_type = isrvmsg.getValue("q_thing_type");// 业务类型
		String orgSubId = user.getSubOrgIDofAffordOrg();// 所属机构单位
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.dev_id as dev_acc_id,t.keeping_id,t.dev_name,t.dev_tname,t.dev_num,t.turn_date,"
				+ "t.keeping_date,info.org_abbreviation sub_org_id,t.dev_sign,t.self_num,"
				+ "case when t.thing_type = '1' then '入库' when t.thing_type = '-1' then '出库' else 'error' end as thing_type,"
				+ "case when t.dev_type like 'S0808%' then '船舶' " 		//船舶
				+ "when t.dev_type like 'S14050101%' then '地震仪器主机' "   //地震仪器主机
				+ "when t.dev_type like 'S0623%' then '可控震源' "       //可控震源
				+ "when t.dev_type like 'S1404%' then '测量设备' "       //测量设备
				+ "when t.dev_type like 'S060101%' then '车装钻机' "     //车装钻机
				+ "when t.dev_type like 'S060102%' then '人抬化钻机' "     //人抬化钻机
				+ "when t.dev_type like 'S070301%' then '推土机' "     //推土机
				+ "when t.dev_type like 'S0622%' then '仪器车' "       //仪器车
				+ "when t.dev_type like 'S08%' then '运输设备' "         //运输设备
				+ "when t.dev_type like 'S0901%' then '发电机组' "      //发电机组
				+ "end as dev_type "
				+ "from dms_device_keeping t "
				+ "left join comm_org_information info "
				+ "on t.sub_org_id = info.org_id "
				+ "left join comm_org_subjection sub "
				+ "on t.sub_org_id = sub.org_id "
				+ "where t.bsflag = '0'");

		if (StringUtils.isNotBlank(dev_num)) {
			querySql.append(" and t.dev_num like '%" + dev_num + "%'");
		}
		if (StringUtils.isNotBlank(dev_type)) {
			querySql.append(" and t.dev_type like '%" + dev_type + "%'");
		}
		if (StringUtils.isNotBlank(dev_name)) {
			querySql.append(" and t.dev_name like '%" + dev_name + "%'");
		}
		if (StringUtils.isNotBlank(thing_type)) {
			querySql.append(" and t.thing_type = '" + thing_type + "' ");
		}
		if(!"C105".equals(orgSubId)){
			// 所属机构单位
			if (StringUtils.isNotBlank(orgSubId)) {
				querySql.append(" and sub.org_subjection_id  like '"+orgSubId+"%' " );
			}
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by t.create_date desc,t.modify_date desc,t.keeping_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * NEWMETHOD 显示特种设备主页面信息显示
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevSpecialMainInfo(ISrvMsg reqDTO) throws Exception {		
		String devAccId = reqDTO.getValue("devaccid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select acc.dev_name,ee.employee_name,acc.dev_model,acc.dev_type,acc.ifcountry,acc.dev_num,"
						+ " acc.dev_sign,acc.dev_coding,acc.PRODUCTING_DATE,acc.RECORD_NUM,"
						+ " acc.USE_NUM,acc.internal_num,acc.MAIN_USEINFO,acc.INSTALLTION_PLACE,"
						+ " uc.coding_name using_stat,tc.coding_name tech_stat,ac.coding_name account_stat,info.org_abbreviation,"
						+ " info.org_name,info1.org_abbreviation org_abbreviation1,info1.org_name org_name1,decode(acc.ZC_STAT, '0','未注册',null,'未注册', '已注册') ZC_STAT,acc.REGISTRATION_CODE,acc.spare1,acc.spare2,acc.spare3,acc.remark"
						+ " from gms_device_account_s acc"
						+ " left join comm_org_information info on acc.owning_org_id = info.org_id and info.bsflag = '0'"
						+ " left join comm_org_information info1 on acc.usage_org_id = info1.org_id and info1.bsflag = '0'"
						+ " left join comm_coding_sort_detail uc on uc.coding_code_id = acc.using_stat and uc.bsflag = '0'"
						+ " left join comm_coding_sort_detail tc on tc.coding_code_id = acc.tech_stat and tc.bsflag = '0'"
						+ " left join comm_coding_sort_detail ac on ac.coding_code_id = acc.account_stat and ac.bsflag = '0'"
						+ " left join comm_human_employee ee on ee.EMPLOYEE_ID = acc.usage_EMPLOYEE_ID and ee.bsflag = '0'"
						+ " where acc.dev_acc_id = '"+devAccId+"'");
		Map devMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devMap)) {
			responseMsg.setValue("data", devMap);
		}
		return responseMsg;
	}
}
