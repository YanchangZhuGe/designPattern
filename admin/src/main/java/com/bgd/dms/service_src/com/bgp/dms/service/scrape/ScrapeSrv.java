package com.bgp.dms.service.scrape; 
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.soap.SOAPException;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.collections.MapUtils;
import org.apache.commons.compress.archivers.ArchiveException;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import com.cnpc.jcdp.util.AppCrypt;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate; 
import org.springframework.jdbc.core.PreparedStatementSetter;
import org.springframework.stereotype.Service;

import com.bgp.dms.util.CommonConstants;
import com.bgp.dms.util.CommonUtil;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.FtpUtil;
import com.bgp.mcs.service.common.excelIE.util.ExcelExceptionHandler;
import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WFCommonBean;
import com.bgp.mcs.service.pm.bpm.workFlow.srv.WFVarBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.TreeNodeData;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.AppCrypt;
import com.cnpc.jcdp.util.DateUtil;
import com.cnpc.sais.ibp.auth.pojo.PAuthMenu;
import com.cnpc.sais.ibp.auth2.srv.AuthManagerUtil;
import com.cnpc.sais.ibp.auth2.util.MenuUtil;

/**
 * project: 东方物探设备体系信息化系统
 * 
 * creator: 陈冲
 * 
 * creator time:2015-2-5
 * 
 * description:设备报废申请业务类
 * 
 */
@Service("ScrapeSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class ScrapeSrv extends BaseService {
	
	
	
	IBaseDao baseDao = BeanFactory.getBaseDao();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private IJdbcDao ijdbcDao = BeanFactory.getQueryJdbcDAO();
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	/**
	 *评审保存设备通过状态信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateCollectScrapeDetailedInfo(ISrvMsg isrvmsg) throws Exception {
			String jsonstr=isrvmsg.getValue("jsonstr");
			JSONArray  jsonArray = JSONArray.fromObject(jsonstr);
			List<String> sqllist=new ArrayList<String>(); 
			for (int i = 0; i < jsonArray.size(); i++) {
				JSONObject object=  (JSONObject) jsonArray.get(i) ;	
				String pass_flag=object.get("sp_pass_flag").toString();
				String bsflag="0";
				if("通过".equals(pass_flag)||"".equals(pass_flag)||"0".equals(pass_flag)){
					pass_flag="0";
				} else{
					pass_flag="1";
					bsflag="1";
				}
				String d_Sql=" update   dms_scrape_detailed t set t.bsflag='"+bsflag+"',t.sp_pass_flag='"+pass_flag+"' ,t.sp_bak1='"+object.get("sp_bak1")+"' where t.scrape_detailed_id='"+object.get("scrape_detailed_id")+"' ";
				sqllist.add(d_Sql); 
				
			}
			if(CollectionUtils.isNotEmpty(sqllist)){
				String str[]=new String[sqllist.size()];
				String strings[]=sqllist.toArray(str);
				//批处理操作保存打分明细
				jdbcTemplate.batchUpdate(strings);
			}
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		return respMsg;
	}
	/**
	 *添加报废申请单基本信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeList(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//获得报废申请单名称
		String scrape_apply_name=isrvmsg.getValue("scrape_apply_name");
		String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");
		String apply_date=isrvmsg.getValue("apply_date");
		//生成基本信息
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String scrape_apply_no = isrvmsg.getValue("scrape_apply_no");
		String scrapeApplyId="";//存储新增的插入的主键
		//如果是新增操作
		if("null".equals(scrape_apply_id)){
			scrape_apply_no = CommonUtil.getScrapeAppNo();
			mainMap.put("scrape_apply_name", scrape_apply_name);
			mainMap.put("apply_date", apply_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("scrape_apply_no", scrape_apply_no);
			mainMap.put("create_date", currentdate);
			mainMap.put("creater", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//6.向数据库写入信息
			Serializable id=jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_APPLY");
			scrapeApplyId=id.toString();
		}
		//修改操作
		else
		{	
			scrapeApplyId=scrape_apply_id;
			mainMap.put("scrape_apply_id", scrapeApplyId);
			mainMap.put("scrape_apply_name", scrape_apply_name);
			mainMap.put("apply_date", apply_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("modify_date", currentdate);
			mainMap.put("updatetor", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//6.向数据库写入信息
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_APPLY");
		}
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		respMsg.setValue("scrape_apply_id", scrapeApplyId);
////////2、固有资产开始
		//报废申请
		String scrape_asset_id=isrvmsg.getValue("scrape_asset_id");// 报废固定资产ID
		String scrape_damage_id=isrvmsg.getValue("scrape_damage_id");//盘亏、折损
		List assetList = new ArrayList();
		List publicList = new ArrayList();
		List damageList = new ArrayList();
		//附件上传
		Boolean filesAssetflag = false;
		MQMsgImpl mqMsgAsset = (MQMsgImpl) isrvmsg;
		List<WSFile> filesAsset = mqMsgAsset.getFiles();
		try {
				//处理附件
				for (WSFile file : filesAsset) {
					String fileOrder = file.getKey().toString();
					if(fileOrder.equals("excel_content_public")){
						filesAssetflag = true;
						String filename = file.getFilename();
						//对比提交申请的excel上传的数据与审批的excel的数据是否存在差异
						publicList = getAllExcelDataByWSFile(file);
						for(int i=0;i<publicList.size();i++){
							Map map = (Map)publicList.get(i);
							String scrape_type = map.get("scrape_type").toString();//
							//查看该erpid是否已经存在于详情表dtail，如果在该表中已存在并且审批通过则跳过
							String erpId = map.get("dev_coding").toString();
							StringBuffer queryScrapeInfoSql = new StringBuffer();
							queryScrapeInfoSql.append("select * from dms_scrape_detailed dsd where (dsd.sp_pass_flag is null or dsd.sp_pass_flag='0') and dsd.bsflag='0' and dev_coding ='"+erpId+"'");
							Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
							if(deviceMap!=null){
								continue;
							}
							if(scrape_type.equals("正常报废")||scrape_type.equals("技术淘汰")){
								assetList.add(map);
							}else if(scrape_type.equals("毁损")||scrape_type.equals("盘亏")){
								damageList.add(map);
							}
						}
						MyUcm ucm = new MyUcm();
						String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
	
						Map doc = new HashMap();
						doc.put("file_name", filename);
						doc.put("file_type",fileOrder);
						doc.put("ucm_id", ucmDocId);
						doc.put("is_file", "1");
						doc.put("relation_id", scrapeApplyId);
						doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
						doc.put("create_date",currentdate);
						doc.put("creator_id",user.getUserId());
						doc.put("org_id", user.getOrgId());
						doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
						String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
						ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
						ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
						break;
					}
				}
			
		} catch (Exception e) {
			
		}
		//附件上传
		//固定资产报废台账信息保存
		Map<String,Object> assetMap = new HashMap<String,Object>();
		Map<String,Object> damageMap = new HashMap<String,Object>();
		if(scrape_asset_id!=null&&scrape_asset_id!=""&&scrape_asset_id.length()>0)
		{
			assetMap.put("SCRAPE_ASSET_ID", scrape_asset_id);
			respMsg.setValue("scrape_asset_id", scrape_asset_id);
			//删除之前的所有报废的设备信息,避免重复添加
//			String deleteSql = "delete dms_scrape_detailed detailed where detailed.scrape_asset_id='"+scrape_asset_id+"'";
//			jdbcDao.executeUpdate(deleteSql);
		}
		//固定资产
		assetMap.put("SCRAPE_APPLY_ID", scrapeApplyId);
		assetMap.put("create_date", currentdate);
		assetMap.put("creater", user.getEmpId());
		assetMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
		Serializable assetId= jdbcDao.saveOrUpdateEntity(assetMap, "DMS_SCRAPE_ASSET");
		respMsg.setValue("scrape_asset_id", assetId.toString());
		if(scrape_damage_id!=null&&scrape_damage_id!=""&&scrape_damage_id.length()>0)
		{
			damageMap.put("SCRAPE_DAMAGE_ID", scrape_damage_id);
			respMsg.setValue("scrape_damage_id", scrape_damage_id);
			//删除之前的所有报废的设备信息,避免重复添加
//			String deleteSql = "delete dms_scrape_detailed detailed where detailed.scrape_damage_id='"+scrape_damage_id+"'";
//			jdbcDao.executeUpdate(deleteSql);
		}
		//盘亏毁损
		damageMap.put("SCRAPE_APPLY_ID", scrapeApplyId);
		damageMap.put("create_date", currentdate);
		damageMap.put("creater", user.getEmpId());
		damageMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
		Serializable damageId= jdbcDao.saveOrUpdateEntity(damageMap, "DMS_SCRAPE_DAMAGE");
		respMsg.setValue("scrape_damage_id", damageId.toString());
		//如果上传的附件的话,调整添加设备的方式
		String  flag_public = isrvmsg.getValue("flag_public");
		if(flag_public==null){
			flag_public = "unknown";
		}
		if(filesAssetflag||flag_public.equals("1")){
			long s_asset=new Date().getTime();
			GroupingHandle(assetList,assetId,null,scrapeApplyId,user);
			GroupingHandle(damageList,null,damageId,scrapeApplyId,user);
			long systime = System.currentTimeMillis();
			long e_asset=new Date().getTime();
			respMsg.setValue("time_asset",e_asset-s_asset);
			System.out.println("开始时间:"+s_asset+",结束时间:"+e_asset+",time:"+(e_asset-s_asset)+",系统时间:"+systime);
		}else{
			//添加报废设备数量
			int count = Integer.parseInt(isrvmsg.getValue("colnum"));
			String parmeter=isrvmsg.getValue("parmeter");
		    String par[]=parmeter.split(",");
			for(int i=0;i<=count;i++)
			{
				Map<String,Object> dataMap = new HashMap<String,Object>();
				//获取设备台账的ID
				//String dev_id=isrvmsg.getValue("detdev_ci_code_asset"+par[i]);
				//erp编号
				String dev_coding=isrvmsg.getValue("dev_coding_asset"+par[i]);
				//设备台账ID查询设备相关信息
				StringBuffer queryScrapeInfoSql = new StringBuffer();
				//queryScrapeInfoSql.append("select * from gms_device_account account where account.dev_acc_id='"+dev_id+"'");
				queryScrapeInfoSql.append("select * from (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) account where account.dev_coding='"+dev_coding+"'");
				Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
				if(deviceMap!=null)
				{
					//报废申请单ID
					dataMap.put("SCRAPE_APPLY_ID", scrapeApplyId);
					//报废设备类型
					dataMap.put("SCRAPE_TYPE", isrvmsg.getValue("scrape_type_asset"+par[i]));
					//设备名称
					dataMap.put("DEV_NAME",deviceMap.get("dev_name"));
					//规格型号
					dataMap.put("DEV_MODEL",deviceMap.get("dev_model"));
					//ERP设备编码
					dataMap.put("DEV_CODING",dev_coding);
					//固定资产编号
					dataMap.put("ASSET_CODING",deviceMap.get("asset_coding"));
					//设备原值
					dataMap.put("ASSET_VALUE",deviceMap.get("asset_value"));
					//设备净值
					dataMap.put("NET_VALUE",deviceMap.get("net_value"));
					//实物标记号
					dataMap.put("DEV_SIGN",deviceMap.get("dev_sign"));
					//设备编号
					dataMap.put("DEV_TYPE",deviceMap.get("dev_type"));
					//牌照号
					dataMap.put("LICENSE_NUM",deviceMap.get("license_num"));
					//投产日期
					dataMap.put("PRODUCTING_DATE",deviceMap.get("producting_date"));
					//报废标示
					dataMap.put("SCRAPE_FLAG","0");
					//所属机构
					dataMap.put("ORG_ID",deviceMap.get("owning_org_id"));
					//备注
					dataMap.put("bak1", isrvmsg.getValue("bak_asset"+par[i]));
					//固定资产申请ID
					dataMap.put("SCRAPE_ASSET_ID", assetId.toString());
					dataMap.put("SCRAPE_DAMAGE_ID", damageId.toString());
					//设备台账ID
					//dataMap.put("FOREIGN_DEV_ID",dev_id);
					dataMap.put("FOREIGN_DEV_ID",deviceMap.get("dev_acc_id"));
					dataMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
					jdbcDao.saveOrUpdateEntity(dataMap, "DMS_SCRAPE_DETAILED");
				}
			}
		}
////////2、固有资产结束
		return respMsg;
	}
	/**
	 * 查询报废申请列表信息 OA 专家填写意见组员
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapeApplyForOAEasyui(ISrvMsg isrvmsg) throws Exception {
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
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		String expert_leader_id = isrvmsg.getValue("expert_leader_id");// 鉴定组长名称
	    String sql="select p.scrape_apply_name,types,apply_date,scrape_apply_no,scrapeid,scrape_apply_id, e.employee_name from(select ap.scrape_apply_name, ap.apply_date, ap.scrape_apply_no, ap.employee_id, a.scrape_asset_id as scrapeid, ap.scrape_apply_id, '正常报废/技术淘汰' types, a.asset_now_desc, a.expert_desc as employee_opinion, a.scrape_reason, a.expert_leader as employee_name, a.expert_members as bak, a.expert_leader_id from dms_scrape_asset a inner join dms_scrape_apply ap on a.scrape_apply_id = ap.scrape_apply_id and ap.scrape_apply_id in (select distinct t.scrape_apply_id from dms_scrape_detailed t where t.bsflag = '0') union all select ap.scrape_apply_name, ap.apply_date, ap.scrape_apply_no, ap.employee_id, b.scrape_damage_id as scrapeid, ap.scrape_apply_id, '盘亏/毁损' types, b.asset_now_desc, b.expert_desc as employee_opinion, b.scrape_reason, b.expert_leader as employee_name, b.expert_members as bak, b.expert_leader_id from dms_scrape_damage b inner join dms_scrape_apply ap on b.scrape_apply_id = ap.scrape_apply_id and ap.scrape_apply_id in (select distinct t.scrape_apply_id from dms_scrape_detailed t where t.bsflag = '0')) p left join comm_human_employee e on p.employee_id=e.employee_id where p.employee_name is not null and bak is null and employee_opinion is null and expert_leader_id=(select emp_id from p_auth_user where login_id='"+expert_leader_id+"') ";

	 
		page = pureJdbcDao.queryRecordsBySQL(sql, page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	 
	 
	}
	/**
	 * 查询报废申请列表信息 OA 专家填写意见组员
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapeApplyForOA(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String expert_leader_id = isrvmsg.getValue("expert_leader_id");// 鉴定组长名称
	    String sql="select p.scrape_apply_name,types,apply_date,scrape_apply_no,scrapeid,scrape_apply_id, e.employee_name from(select ap.scrape_apply_name, ap.apply_date, ap.scrape_apply_no, ap.employee_id, a.scrape_asset_id as scrapeid, ap.scrape_apply_id, '正常报废/技术淘汰' types, a.asset_now_desc, a.expert_desc as employee_opinion, a.scrape_reason, a.expert_leader as employee_name, a.expert_members as bak, a.expert_leader_id from dms_scrape_asset a inner join dms_scrape_apply ap on a.scrape_apply_id = ap.scrape_apply_id and ap.scrape_apply_id in (select distinct t.scrape_apply_id from dms_scrape_detailed t where t.bsflag = '0') union all select ap.scrape_apply_name, ap.apply_date, ap.scrape_apply_no, ap.employee_id, b.scrape_damage_id as scrapeid, ap.scrape_apply_id, '盘亏/毁损' types, b.asset_now_desc, b.expert_desc as employee_opinion, b.scrape_reason, b.expert_leader as employee_name, b.expert_members as bak, b.expert_leader_id from dms_scrape_damage b inner join dms_scrape_apply ap on b.scrape_apply_id = ap.scrape_apply_id and ap.scrape_apply_id in (select distinct t.scrape_apply_id from dms_scrape_detailed t where t.bsflag = '0')) p left join comm_human_employee e on p.employee_id=e.employee_id where p.employee_name is not null and bak is null and employee_opinion is null and expert_leader_id=(select emp_id from p_auth_user where login_id='"+expert_leader_id+"') ";
	    page = pureJdbcDao.queryRecordsBySQL(sql, page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询报废申请列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapeApplyList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String scrape_apply_name = isrvmsg.getValue("scrape_apply_name");// 报废申请单名称
		String scrape_apply_no = isrvmsg.getValue("scrape_apply_no");// 报废申请单号
		String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");// 报废申请单主键
		String scrape_collect_id = isrvmsg.getValue("scrape_collect_id");// 报废汇总名称
		String scrape_report_id = isrvmsg.getValue("scrape_report_id");// 报废上报名称
		String procStatus = isrvmsg.getValue("procStatus");//审批状态值
		String report_dev_type = isrvmsg.getValue("report_dev_type");//是否已批复0未批复1已批复
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,decode((select count(*) from dms_scrape_detailed d where d.bsflag='0' and d.scrape_apply_id=t.scrape_apply_id and d.sp_pass_flag is null),0,'已评审','未评审') status,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name ");
		querySql.append(" from dms_scrape_apply t  left join common_busi_wf_middle t2 on t.scrape_apply_id=t2.business_id  and t2.bsflag='0'  ");
		querySql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		querySql.append(" left join comm_org_information org on t.scrape_org_id = org.org_id  where t.bsflag='0' ");
		// 申请单名称
		if (StringUtils.isNotBlank(scrape_apply_name)) {
			querySql.append(" and t.scrape_apply_name  like '%"+scrape_apply_name+"%'");
		}
		// 申请单号
		if (StringUtils.isNotBlank(scrape_apply_no)) {
			querySql.append(" and t.scrape_apply_no  like '%"+scrape_apply_no+"%'");
		}
		//申请单id
		if (StringUtils.isNotBlank(scrape_apply_id)&&!scrape_apply_id.equals("null")) {
			querySql.append(" and t.scrape_apply_id  = '"+scrape_apply_id+"'");
		}
		// 汇总单号
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			querySql.append(" and t.scrape_collect_id  = '"+scrape_collect_id+"'");
		}
		// 上报单号
		if (StringUtils.isNotBlank(scrape_report_id)) {
			querySql.append(" and t.scrape_report_id  = '"+scrape_report_id+"'");
		}
		if (StringUtils.isNotBlank(report_dev_type)) {
			if(report_dev_type.equals("0")){
				querySql.append(" and t.scrape_report_id is null ");
			}else if(report_dev_type.equals("1")){
				querySql.append(" and t.scrape_report_id is not null ");
			}
			
		}
//		querySql.append(" and t.scrape_org_id in (select n1.org_subjection_id from comm_org_information n, comm_org_subjection n1 where n.bsflag = '0' and n.bsflag = '0' and n.org_id = n1.org_id and n1.org_subjection_id like '"+user.getOrgCode()+"%' ) order by t.create_date desc");
		//如果是超级管理员的话不做所属单位数据筛选，查询全部的单位数据
		if(!user.getSubOrgIDofAffordOrg().equals("C105")){
			querySql.append(" and t.scrape_org_id in ");
			String my_org_id = getOrgMessage(user);
			if(my_org_id.equals("C6000000005263")){//大港
				querySql.append("('C6000000005263','C6000000000008')");
			}else if(my_org_id.equals("C6000000005358")){//物资供应中心
				querySql.append("('C6000000005358','C6000000005362')");
			}else if(my_org_id.equals("C6000000000007")){//装备服务处
				querySql.append("('C6000000000007','C6000000005519')");
			}else{
				querySql.append("('"+my_org_id+"')");
			}
		}
		if (StringUtils.isNotBlank(procStatus)) {
			querySql.append(" and t2.proc_status='3' ");
		}
		//添加排序
		querySql.append(" and t.scrape_apply_id in(select distinct t.scrape_apply_id from dms_scrape_detailed t where t.bsflag='0') order by t.create_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询盘亏报废申请列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapeApplyDamageList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String scrape_apply_name = isrvmsg.getValue("scrape_apply_name");// 报废申请单名称
		String scrape_apply_no = isrvmsg.getValue("scrape_apply_no");// 报废申请单号
		String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");// 报废申请单主键
		String scrape_collect_id = isrvmsg.getValue("scrape_collect_id");// 报废汇总名称
		String scrape_report_id = isrvmsg.getValue("scrape_report_id");// 报废上报名称
		String procStatus = isrvmsg.getValue("procStatus");//审批状态值
		String report_dev_type = isrvmsg.getValue("report_dev_type");//是否已批复0未批复1已批复
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name ");
		querySql.append(" from dms_scrape_apply t  left join common_busi_wf_middle t2 on t.scrape_apply_id=t2.business_id  and t2.bsflag='0'  ");
		querySql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		querySql.append(" left join comm_org_information org on t.scrape_org_id = org.org_id  where t.bsflag='0' ");
		// 申请单名称
		if (StringUtils.isNotBlank(scrape_apply_name)) {
			querySql.append(" and t.scrape_apply_name  like '"+scrape_apply_name+"%'");
		}
		// 申请单号
		if (StringUtils.isNotBlank(scrape_apply_no)) {
			querySql.append(" and t.scrape_apply_no  like '"+scrape_apply_no+"%'");
		}
		//申请单id
		if (StringUtils.isNotBlank(scrape_apply_id)&&!scrape_apply_id.equals("null")) {
			querySql.append(" and t.scrape_apply_id  = '"+scrape_apply_id+"'");
		}
		// 汇总单号
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			querySql.append(" and t.scrape_collect_id  = '"+scrape_collect_id+"'");
		}
		// 上报单号
		if (StringUtils.isNotBlank(scrape_report_id)) {
			querySql.append(" and t.scrape_report_id  = '"+scrape_report_id+"'");
		}
		if (StringUtils.isNotBlank(report_dev_type)) {
			if(report_dev_type.equals("0")){
				querySql.append(" and t.scrape_report_id is null ");
			}else if(report_dev_type.equals("1")){
				querySql.append(" and t.scrape_report_id is not null ");
			}
			
		}
//		querySql.append(" and t.scrape_org_id in (select n1.org_subjection_id from comm_org_information n, comm_org_subjection n1 where n.bsflag = '0' and n.bsflag = '0' and n.org_id = n1.org_id and n1.org_subjection_id like '"+user.getOrgCode()+"%' ) order by t.create_date desc");
		//如果是超级管理员的话不做所属单位数据筛选，查询全部的单位数据
		if(!user.getOrgCode().equals("C105")){
			querySql.append(" and t.scrape_org_id ='"+user.getOrgId()+"'");
		}
		if (StringUtils.isNotBlank(procStatus)) {
			querySql.append(" and t2.proc_status='3' ");
		}
		//添加排序
		querySql.append(" and t.scrape_apply_id in(select distinct t.scrape_apply_id from dms_scrape_detailed t where t.bsflag='0' and scrape_damage_id is not null) order by t.create_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询技术淘汰报废申请列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapeApplyEliminateList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String scrape_apply_name = isrvmsg.getValue("scrape_apply_name");// 报废申请单名称
		String scrape_apply_no = isrvmsg.getValue("scrape_apply_no");// 报废申请单号
		String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");// 报废申请单主键
		String scrape_collect_id = isrvmsg.getValue("scrape_collect_id");// 报废汇总名称
		String scrape_report_id = isrvmsg.getValue("scrape_report_id");// 报废上报名称
		String procStatus = isrvmsg.getValue("procStatus");//审批状态值
		String report_dev_type = isrvmsg.getValue("report_dev_type");//是否已批复0未批复1已批复
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name ");
		querySql.append(" from dms_scrape_apply t  left join common_busi_wf_middle t2 on t.scrape_apply_id=t2.business_id  and t2.bsflag='0'  ");
		querySql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		querySql.append(" left join comm_org_information org on t.scrape_org_id = org.org_id  where t.bsflag='0' ");
		// 申请单名称
		if (StringUtils.isNotBlank(scrape_apply_name)) {
			querySql.append(" and t.scrape_apply_name  like '"+scrape_apply_name+"%'");
		}
		// 申请单号
		if (StringUtils.isNotBlank(scrape_apply_no)) {
			querySql.append(" and t.scrape_apply_no  like '"+scrape_apply_no+"%'");
		}
		//申请单id
		if (StringUtils.isNotBlank(scrape_apply_id)&&!scrape_apply_id.equals("null")) {
			querySql.append(" and t.scrape_apply_id  = '"+scrape_apply_id+"'");
		}
		// 汇总单号
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			querySql.append(" and t.scrape_collect_id  = '"+scrape_collect_id+"'");
		}
		// 上报单号
		if (StringUtils.isNotBlank(scrape_report_id)) {
			querySql.append(" and t.scrape_report_id  = '"+scrape_report_id+"'");
		}
		if (StringUtils.isNotBlank(report_dev_type)) {
			if(report_dev_type.equals("0")){
				querySql.append(" and t.scrape_report_id is null ");
			}else if(report_dev_type.equals("1")){
				querySql.append(" and t.scrape_report_id is not null ");
			}
			
		}
//		querySql.append(" and t.scrape_org_id in (select n1.org_subjection_id from comm_org_information n, comm_org_subjection n1 where n.bsflag = '0' and n.bsflag = '0' and n.org_id = n1.org_id and n1.org_subjection_id like '"+user.getOrgCode()+"%' ) order by t.create_date desc");
		//如果是超级管理员的话不做所属单位数据筛选，查询全部的单位数据
		if(!user.getOrgCode().equals("C105")){
			querySql.append(" and t.scrape_org_id ='"+user.getOrgId()+"'");
		}
		if (StringUtils.isNotBlank(procStatus)) {
			querySql.append(" and t2.proc_status='3' ");
		}
		//添加排序
		querySql.append(" and t.scrape_apply_id in(select distinct t.scrape_apply_id from dms_scrape_detailed t where t.bsflag='0' and scrape_asset_id is not null and t.scrape_type = '1') order by t.create_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询申请单报废信息
	 * 
	 */
	public ISrvMsg getScrapeInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		queryScrapeInfoSql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name ");
		queryScrapeInfoSql.append(" from dms_scrape_apply t  left join common_busi_wf_middle t2 on t.scrape_apply_id=t2.business_id  and t2.bsflag='0'  ");
		queryScrapeInfoSql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		queryScrapeInfoSql.append(" left join comm_org_information org on t.scrape_org_id = org.org_id  where t.bsflag='0' ");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			queryScrapeInfoSql.append(" and t.scrape_apply_id  = '"+scrape_apply_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		//查询文件表
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type ='excel_content_public' order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2= jdbcDao.queryRecords(sqlFiles);
		//文件数据
		responseDTO.setValue("fdataPublic", list2);//折损表对应附件
		
		//获取报废和盘亏的对应数据
		String assetSql = "select * from dms_scrape_asset where scrape_apply_id = '"+scrape_apply_id+"'";
		List<Map> listAsset = jdbcDao.queryRecords(assetSql);
		responseDTO.setValue("listAsset", listAsset);
		
		//获取报废和盘亏的对应数据
		String damagetSql = "select * from dms_scrape_damage where scrape_apply_id = '"+scrape_apply_id+"'";
		List<Map> listDamage = jdbcDao.queryRecords(damagetSql);
		responseDTO.setValue("listDamage", listDamage);
		
		
		return responseDTO;
	}
	/**
	 * 查询报废申请单是否添加设备报废明细信息
	 */
	
	public ISrvMsg getScrapeDetail(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select count(1) as result from dms_scrape_detailed where BSFLAG='0'");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			queryScrapeInfoSql.append(" and scrape_apply_id  = '"+scrape_apply_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	/**
	 * 查询报废申请单状态
	 */
	public ISrvMsg getScrapeState(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select devapp.scrape_apply_id, nvl(wfmiddle.proc_status, '') as proc_status  from dms_scrape_apply devapp ");
		queryScrapeInfoSql.append(" left join common_busi_wf_middle wfmiddle on devapp.scrape_apply_id = wfmiddle.business_id ");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			queryScrapeInfoSql.append(" and scrape_apply_id  = '"+scrape_apply_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	/**
	 * 删除报废申请单
	 */
	public ISrvMsg deleteScrapeInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		Map<String,Object> mainMap = new HashMap<String,Object>();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		mainMap.put("employee_id", user.getEmpId());
		mainMap.put("scrape_org_id", user.getOrgId());
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updatetor", user.getEmpId());
		mainMap.put("scrape_apply_id", scrape_apply_id);
		mainMap.put("bsflag", CommonConstants.BSFLAG_DELETE);
		//删除关联的报废设备详情		
		String deleteDetailedSql = "update dms_scrape_detailed detailed set detailed.bsflag='1' where detailed.scrape_apply_id='"+scrape_apply_id+"'";
		jdbcDao.executeUpdate(deleteDetailedSql);
		//删除关联固定资产信息
		String deleteSql = "update dms_scrape_asset asset set asset.bsflag='1' where asset.scrape_apply_id='"+scrape_apply_id+"'";
		jdbcDao.executeUpdate(deleteSql);
		//删除关联盘亏毁损信息
		String deleteDamageSql = "update dms_scrape_damage damage set damage.bsflag='1' where damage.scrape_apply_id='"+scrape_apply_id+"'";
		jdbcDao.executeUpdate(deleteDamageSql);
		//6.向数据库写入信息
		jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_APPLY");
		return responseDTO;
	}
	/**
	 * 查询报废申请是否添加了技术专家
	 */
	public ISrvMsg getScrapeEmpOpinionCount(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		String message = "";
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			message = " and scrape_apply_id  = '"+scrape_apply_id+"'";
		}else{
			message = " and 1=2";
		}
		queryScrapeInfoSql.append("select distinct '01' as type from dms_scrape_detailed d where d.scrape_asset_id=(select a.scrape_asset_id from dms_scrape_asset a "
				+ "where 1=1 "+message+" and a.expert_leader_id is null) "
				+ "union all "
				+ "select distinct '23' as type from dms_scrape_detailed d where d.scrape_damage_id=(select d.scrape_damage_id from dms_scrape_damage d "
				+ "where 1=1 "+message+" and d.expert_leader_id is null)");
		// 申请单ID
		List<Map> deviceappList = jdbcDao.queryRecords(queryScrapeInfoSql.toString());
		responseDTO.setValue("deviceappList",deviceappList);
		return responseDTO;
	}
	/**
	 * 查询报废申请的专家是否全部会签
	 */
	public ISrvMsg getScrapeEmpOpinion(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select * from DMS_SCRAPE_ASSET p where p.expert_desc is null and p.scrape_asset_id in (select d.scrape_asset_id from dms_scrape_detailed d where d.scrape_apply_id in (select scrape_apply_id from dms_scrape_apply where"
				+ " 1 = 1");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			queryScrapeInfoSql.append(" and scrape_apply_id  = '"+scrape_apply_id+"'))");
		}else{
			queryScrapeInfoSql.append(" and 1=2 ))");
		}
		List<Map> deviceappMap = jdbcDao.queryRecords(queryScrapeInfoSql.toString());
		if(deviceappMap.size()>0){
			responseDTO.setValue("count", deviceappMap.size());
		}else{
			responseDTO.setValue("count", 0);
		}
		responseDTO.setValue("deviceappMap",deviceappMap);
		return responseDTO;
	}
	/**
	 * 查询报废申请的专家是否全部会签 OA鉴定组长填写意见组员
	 */
	public ISrvMsg getScrapeEmpOpinionAllforOA(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrapeid=isrvmsg.getValue("scrapeid");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select p.*, e.employee_name from(select ap.scrape_apply_name, ap.apply_date, ap.scrape_apply_no, ap.employee_id, a.scrape_asset_id as scrapeid, ap.scrape_apply_id, '正常报废/技术淘汰' types, 'asset' types1, a.asset_now_desc, a.expert_desc as employee_opinion, a.scrape_reason, a.expert_leader as employee_name, a.expert_members as bak, a.expert_leader_id from dms_scrape_asset a inner join dms_scrape_apply ap on a.scrape_apply_id = ap.scrape_apply_id and ap.scrape_apply_id in (select distinct t.scrape_apply_id from dms_scrape_detailed t where t.bsflag = '0') union all select ap.scrape_apply_name, ap.apply_date, ap.scrape_apply_no, ap.employee_id, b.scrape_damage_id as scrapeid, ap.scrape_apply_id, '盘亏/毁损' types, 'damage' types1, b.asset_now_desc, b.expert_desc as employee_opinion, b.scrape_reason, b.expert_leader as employee_name, b.expert_members as bak, b.expert_leader_id from dms_scrape_damage b inner join dms_scrape_apply ap on b.scrape_apply_id = ap.scrape_apply_id and ap.scrape_apply_id in (select distinct t.scrape_apply_id from dms_scrape_detailed t where t.bsflag = '0')) p left join comm_human_employee e on p.employee_id = e.employee_id where p.employee_name is not null and bak is null and employee_opinion is null ");
		// 申请单ID
		if (StringUtils.isNotBlank(scrapeid)) {
			queryScrapeInfoSql.append("    and scrapeid= '"+scrapeid+"'");
		} 
		List<Map> deviceappMap = jdbcDao.queryRecords(queryScrapeInfoSql.toString());
		if(deviceappMap.size()>0){
			responseDTO.setValue("count", deviceappMap.size());
		}else{
			responseDTO.setValue("count", 0);
		}
		responseDTO.setValue("deviceappMap",deviceappMap);
		return responseDTO;
	}
	/**
	 * 查询报废申请的专家是否全部会签
	 */
	public ISrvMsg getScrapeEmpOpinionAll(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select p.* from ("
				+ "select a.scrape_apply_id,a.scrape_asset_id  as scrapeid,'asset'  types,a.asset_now_desc,a.expert_desc as employee_opinion,a.scrape_reason,a.expert_leader as employee_name,a.expert_members as bak "
				+ "from dms_scrape_asset a "
				+ "union all "
				+ "select b.scrape_apply_id,b.scrape_damage_id as scrapeid,'damage' types,b.asset_now_desc,b.expert_desc as employee_opinion,b.scrape_reason,b.expert_leader as employee_name,b.expert_members as bak "
				+ "from dms_scrape_damage b) p "
				+ "where p.employee_name is not null");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			queryScrapeInfoSql.append(" and scrape_apply_id  = '"+scrape_apply_id+"'");
		}else{
			queryScrapeInfoSql.append(" and 1=2 )");
		}
		List<Map> deviceappMap = jdbcDao.queryRecords(queryScrapeInfoSql.toString());
		if(deviceappMap.size()>0){
			responseDTO.setValue("count", deviceappMap.size());
		}else{
			responseDTO.setValue("count", 0);
		}
		responseDTO.setValue("deviceappMap",deviceappMap);
		return responseDTO;
	}
	/**
	 * 查询报废申请的专家信息
	 */
	public ISrvMsg getScrapeEmp(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String id=isrvmsg.getValue("id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select * from DMS_SCRAPE_EMPLOYEE p where "
				+ " 1 = 1");
		// 申请单ID
		if (StringUtils.isNotBlank(id)) {
			queryScrapeInfoSql.append(" and id  = '"+id+"'");
		}else{
			queryScrapeInfoSql.append(" and 1=2");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		responseDTO.setValue("deviceappMap",deviceappMap);
		return responseDTO;
	}
	/**
	 * 更新报废申请的专家信息意见
	 */
	public ISrvMsg updateScrapeEmp(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String id=isrvmsg.getValue("id");// 专家表ID
		String employee_opinion=isrvmsg.getValue("employee_opinion");// 专家名称意见
		Map<String,Object> expertMap = new HashMap<String,Object>();
		expertMap.put("id", id);
		expertMap.put("employee_opinion",employee_opinion);
		Serializable expertId= jdbcDao.saveOrUpdateEntity(expertMap, "DMS_SCRAPE_EMPLOYEE");
		return responseDTO;
	}
	
	/**
	 * 批量更新报废申请的专家信息意见
	 */
	public ISrvMsg batUpdateScrapeEmp(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String employee_opinions=isrvmsg.getValue("employee_opinions");// 专家名称意见
		String baks=isrvmsg.getValue("baks");// 专家名称意见
		String scrapeids = isrvmsg.getValue("scrapeids");//报废id 来自asset或damage
		String types = isrvmsg.getValue("types");//报废种类 asset或damage
		String employee_opinion[]=null;
		if(employee_opinions!=""&&employee_opinions!=null){
			employee_opinion =employee_opinions.substring(0, employee_opinions.length()-1).split("&");
		}
		String scrapeid[]=null;
		if(scrapeids!=""&&scrapeids!=null){
			scrapeid =scrapeids.substring(0, scrapeids.length()-1).split("&");
		}
		String type[] = null;
		if(types!=""&&types!=null){
			type =types.substring(0, types.length()-1).split("&");
		}
		String bak[]=null;
		if(baks!=""&&baks!=null){
			bak =baks.substring(0, baks.length()-1).split("&");
		}
		for(int i=0;i<scrapeid.length;i++){
			if(type[i].equals("asset")){//属于正常报废和技术淘汰的专家意见
				String updateAssetSql="update dms_scrape_asset asset  set "
						+ " asset.expert_members='"+bak[i]+"',asset.expert_desc='"+employee_opinion[i]+"' "
						+ "where asset.scrape_asset_id='"+scrapeid[i]+"'";
				jdbcDao.executeUpdate(updateAssetSql);
			}
			if(type[i].equals("damage")){//属于盘亏和毁损的专家意见
				String updateDamageSql="update dms_scrape_damage damage  set "
						+ " damage.expert_members='"+bak[i]+"',damage.expert_desc='"+employee_opinion[i]+"' "
						+ "where damage.scrape_damage_id='"+scrapeid[i]+"'";
				jdbcDao.executeUpdate(updateDamageSql);
			}
		}
		return responseDTO;
	}
	/**
	 * 添加报废申请固定资产信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeAssetInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		//报废申请
		String scrape_apply_id=msg.getValue("scrape_apply_id");// 报废申请单ID
		String scrape_asset_id=msg.getValue("scrape_asset_id");// 报废固定资产ID
		//固定资产报废台账信息保存
		Map<String,Object> assetMap = new HashMap<String,Object>();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		if(scrape_asset_id!=""&&scrape_asset_id.length()>0)
		{
			assetMap.put("SCRAPE_ASSET_ID", scrape_asset_id);
			//删除之前的所有报废的设备信息,避免重复添加
//			String deleteSql = "delete dms_scrape_detailed detailed where detailed.scrape_asset_id='"+scrape_asset_id+"'";
//			jdbcDao.executeUpdate(deleteSql);
		}
		assetMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
		/*assetMap.put("ASSET_NOW_DESC", msg.getValue("asset_now_desc"));
		assetMap.put("SCRAPE_REASON", msg.getValue("scrape_reason"));
		assetMap.put("expert_desc", msg.getValue("expert_desc"));
		assetMap.put("EXPERT_LEADER",msg.getValue("expert_leader"));
		assetMap.put("EXPERT_LEADER_ID",msg.getValue("expert_leader_id"));
		assetMap.put("EXPERT_MEMBERS",msg.getValue("expert_members"));
		assetMap.put("APPRAISAL_DATE",msg.getValue("appraisal_date"));*/
		assetMap.put("create_date", currentdate);
		assetMap.put("creater", user.getEmpId());
		assetMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
		Serializable id= jdbcDao.saveOrUpdateEntity(assetMap, "DMS_SCRAPE_ASSET");
		//将专家信息保存到专家表
		String expert_ids=msg.getValue("expert_ids");//专家表主键
		String employee_names=msg.getValue("employee_names");// 专家名称字符串
		String employee_ids=msg.getValue("employee_ids");//专家id
		String expert_id[]=expert_ids.split(",");
		String employee_name[]=employee_names.split(",");
		String employee_id[]=employee_ids.split(",");
		for(int i=0;i<employee_id.length;i++){
			if(employee_id[0].equals(""))continue;
			Map<String,Object> expertMap = new HashMap<String,Object>();
			if(expert_id.length>i){
				if(expert_id[i]!=""&&expert_id[i].length()>0){
					expertMap.put("id", expert_id[i]);
				}
			}
			expertMap.put("scrape_id", id);
			expertMap.put("employee_id", employee_id[i]);
			expertMap.put("employee_name", employee_name[i]);
			Serializable expertId= jdbcDao.saveOrUpdateEntity(expertMap, "DMS_SCRAPE_EMPLOYEE");
		}
		responseDTO.setValue("scrape_apply_id", scrape_apply_id);
	    return responseDTO;
	}
	
	
	/**
	 * 添加报废申请盘亏毁损信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeDamageInfo(ISrvMsg msg) throws Exception {
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		//报废申请
		String scrape_apply_id=msg.getValue("scrape_apply_id");// 报废申请单ID
		String scrape_damage_id=msg.getValue("scrape_damage_id");// 报废盘亏亏损ID
		String specialized_unit_flag=msg.getValue("specialized_unit_flag");// 专业化服务单位设备
		String else_unit_flag=msg.getValue("else_unit_flag");// 其他单位设备
		Map<String,Object> assetMap = new HashMap<String,Object>();
		//上传附件
		MQMsgImpl mqMsg = (MQMsgImpl) msg;
		List<WSFile> files = mqMsg.getFiles();
		//证明材料
		String proof_file=msg.getValue("proof_file");
		//赔付证明
		String payment_proof_file=msg.getValue("payment_proof_file");
		//责任人处理
		String dev_photo_file=msg.getValue("dev_photo_file");
		//毁损照片
		String person_handling_file=msg.getValue("person_handling_file");
		if(proof_file!=null)
		{
			proof_file=jdbcDao.generateUUID();
			assetMap.put("proof_file", proof_file);
		}
		if(payment_proof_file!=null)
		{
			payment_proof_file=jdbcDao.generateUUID();
			assetMap.put("payment_proof_file", payment_proof_file);
		}
		if(dev_photo_file!=null)
		{
			dev_photo_file=jdbcDao.generateUUID();
			assetMap.put("dev_photo_file", dev_photo_file);
		}
		if(person_handling_file!=null)
		{
			person_handling_file=jdbcDao.generateUUID();
			assetMap.put("person_handling_file", person_handling_file);
		}
		try {
				//处理附件
				for (WSFile file : files) {
					String filename = file.getFilename();
					String fileOrder = file.getKey().toString();
					MyUcm ucm = new MyUcm();
					String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
					Map doc = new HashMap();
					if(fileOrder.equals("proof_file_"))
					{
						fileOrder=proof_file;
					}
					if(fileOrder.equals("payment_proof_file_"))
					{
						fileOrder=payment_proof_file;
					}
					if(fileOrder.equals("dev_photo_file_"))
					{
						fileOrder=dev_photo_file;
					}
					if(fileOrder.equals("person_handling_file_"))
					{
						fileOrder=person_handling_file;
					}
					doc.put("relation_id", scrape_apply_id);
					doc.put("file_name", filename);
					doc.put("file_type",fileOrder);
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("create_date",currentdate);
					doc.put("creator_id",user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
	/*				//只有在新增文件时才写历史 
					if((StringUtils.isEmpty(isrvmsg.getValue("paper_id"))) ){
					
					}*/
				}
			
		} catch (Exception e) {
			
		}
		

		//固定资产报废台账信息保存
		if(scrape_damage_id!=null)
		{
		if(scrape_damage_id!=""&&scrape_damage_id.length()>0)
		{
			assetMap.put("SCRAPE_DAMAGE_ID", scrape_damage_id);
			//删除之前的所有报废的设备信息,避免重复添加
//			String deleteSql = "delete dms_scrape_detailed detailed where detailed.scrape_damage_id='"+scrape_damage_id+"'";
//			jdbcDao.executeUpdate(deleteSql);
		}
		}
		assetMap.put("specialized_unit_flag", specialized_unit_flag);
		assetMap.put("else_unit_flag", else_unit_flag);
		assetMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
		assetMap.put("LOSS_REASON", msg.getValue("loss_reason"));
		assetMap.put("create_date", currentdate);
		assetMap.put("creater", user.getEmpId());
		assetMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
		Serializable id= jdbcDao.saveOrUpdateEntity(assetMap, "DMS_SCRAPE_DAMAGE");
		
		//添加报废设备数量
		/*int count = Integer.parseInt(msg.getValue("colnum"));
		String parmeter=msg.getValue("parmeter");
	    String par[]=parmeter.split(",");
		for(int i=0;i<=count;i++)
		{
			Map<String,Object> dataMap = new HashMap<String,Object>();
			//获取设备台账的ID
			String dev_id=msg.getValue("detdev_ci_code"+par[i]);
			//设备台账ID查询设备相关信息
			StringBuffer queryScrapeInfoSql = new StringBuffer();
			queryScrapeInfoSql.append("select * from gms_device_account account where account.dev_acc_id='"+dev_id+"'");
			Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
			if(deviceMap!=null)
			{
				//报废申请单ID
				dataMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
				//报废设备类型
				dataMap.put("SCRAPE_TYPE", msg.getValue("scrape_type"+par[i]));
				//设备名称
				dataMap.put("DEV_NAME",deviceMap.get("dev_name"));
				//规格型号
				dataMap.put("DEV_MODEL",deviceMap.get("dev_model"));
				//固定资产编号
				dataMap.put("ASSET_CODING",deviceMap.get("asset_coding"));
				//设备原值
				dataMap.put("ASSET_VALUE",deviceMap.get("asset_value"));
				//实物标记号
				dataMap.put("DEV_SIGN",deviceMap.get("dev_sign"));
				//设备编号
				dataMap.put("DEV_TYPE",deviceMap.get("dev_type"));
				//牌照号
				dataMap.put("LICENSE_NUM",deviceMap.get("license_num"));
				//投产日期
				dataMap.put("PRODUCTING_DATE",deviceMap.get("producting_date"));
				//报废标示
				dataMap.put("SCRAPE_FLAG","0");
				//所属机构
				dataMap.put("ORG_ID",deviceMap.get("owning_org_id"));
				//备注
				dataMap.put("bak1", msg.getValue("bak"+par[i]));
				//固定资产申请ID
				dataMap.put("SCRAPE_DAMAGE_ID", id.toString());
				//设备台账ID
				dataMap.put("FOREIGN_DEV_ID",dev_id);
				dataMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
				jdbcDao.saveOrUpdateEntity(dataMap, "DMS_SCRAPE_DETAILED");
			}
		}*/
		responseDTO.setValue("scrape_apply_id", scrape_apply_id);
	    return responseDTO;
	}
	
	/**
	 * 查询报废申请固定资产信息
	 */
	public ISrvMsg getScrapeAssetInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String queryAssetInfoSql="select app.* ,asset.* from dms_scrape_apply app left join dms_scrape_asset asset on  app.scrape_apply_id=" +
				"asset.scrape_apply_id where app.scrape_apply_id='"+scrape_apply_id+"'";
		Map deviceAssetMap = jdbcDao.queryRecordBySQL(queryAssetInfoSql.toString());
		String queryAssetForDeviceSql="select * from dms_scrape_detailed detailed where detailed.scrape_asset_id='"+deviceAssetMap.get("scrape_asset_id")+"'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryAssetForDeviceSql);
		responseDTO.setValue("datas", list);
		
		if(deviceAssetMap!=null){
			responseDTO.setValue("deviceAssetMap", deviceAssetMap);
		}
		//查询文件表
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type ='excel_content_asset' order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2= jdbcDao.queryRecords(sqlFiles);
		//文件数据
		responseDTO.setValue("fdataAsset", list2);//折损表对应附件
		
		String sqlFilesfj="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type is null  order by t.order_num";
		List<Map> fileListfj = new ArrayList<Map>();
		fileListfj= jdbcDao.queryRecords(sqlFilesfj);
		responseDTO.setValue("fdatafj", fileListfj);//其他附件
		
		String sqlEmp="select * from DMS_SCRAPE_EMPLOYEE t where t.scrape_id='"+deviceAssetMap.get("scrape_asset_id")+"'";
		List<Map> ListEmp = new ArrayList<Map>();
		String expert_ids="";
		String employee_names ="";
		String employee_ids="";
		ListEmp= jdbcDao.queryRecords(sqlEmp);
		for(int i= 0; i<ListEmp.size();i++){
			expert_ids+=ListEmp.get(i).get("id")+",";
			employee_names+=ListEmp.get(i).get("employee_name")+",";
			employee_ids+=ListEmp.get(i).get("employee_id")+",";
		}
		Map employees = new HashMap();
		if(!expert_ids.equals(""))
		employees.put("expert_ids",expert_ids.substring(0, expert_ids.length()-1));
		if(!employee_names.equals(""))
		employees.put("employee_names",employee_names.substring(0, employee_names.length()-1));
		if(!employee_ids.equals(""))
		employees.put("employee_ids",employee_ids.substring(0, employee_ids.length()-1));
		responseDTO.setValue("deviceEmpMap", employees);//其他附件
		
		return responseDTO;
	}
	/**
	 * 查询报废申请盘亏信息
	 * 查询报废申请固定资产信息 综合方法
	 */
	public ISrvMsg getScrapeAllInfo(ISrvMsg msg)throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String queryAssetInfoSql="select app.* ,asset.* from dms_scrape_apply app left join dms_scrape_asset asset on  app.scrape_apply_id=" +
				"asset.scrape_apply_id where app.scrape_apply_id='"+scrape_apply_id+"'";
		Map deviceAssetMap = jdbcDao.queryRecordBySQL(queryAssetInfoSql.toString());
		if(deviceAssetMap!=null){
			responseDTO.setValue("deviceAssetMap", deviceAssetMap);//固定资产设备表
		}
		String queryAssetForDeviceSql="select * from dms_scrape_detailed detailed where detailed.scrape_asset_id='"+deviceAssetMap.get("scrape_asset_id")+"'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryAssetForDeviceSql);
		responseDTO.setValue("datas", list);//固定资产信息
		//查询固定资产文件表
		String sqlFilesAsset="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1'  "
				+ "and t.file_type='excel_content_asset' order by t.order_num";
		List<Map> fileListAsset = new ArrayList<Map>();
		fileListAsset= jdbcDao.queryRecords(sqlFilesAsset);
		//固定资产文件数据
		responseDTO.setValue("fdataAsset", fileListAsset);//固定资产附件
		
		
		String queryDamageInfoSql="select app.* ,damage.* from dms_scrape_apply app left join dms_scrape_damage damage on  app.scrape_apply_id=" +
				"damage.scrape_apply_id where app.scrape_apply_id='"+scrape_apply_id+"'";
		Map deviceDamageMap = jdbcDao.queryRecordBySQL(queryDamageInfoSql.toString());
		responseDTO.setValue("deviceDamageMap", deviceDamageMap);//折损设备表
		String queryDamageForDeviceSql="select * from dms_scrape_detailed detailed where detailed.scrape_damage_id='"+deviceDamageMap.get("scrape_damage_id")+"'";
		List<Map> listDamage = new ArrayList<Map>();
		listDamage = jdbcDao.queryRecords(queryDamageForDeviceSql);
		responseDTO.setValue("datasDamage", listDamage);//折损设备表
		//查询文件表
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type is not null and t.file_type!='excel_content_asset' and t.file_type!='excel_content_damage' order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2= jdbcDao.queryRecords(sqlFiles);
		//文件数据
		responseDTO.setValue("fdata", list2);//折损表对应附件
		//查询文件表
		String sqlFilesDamage="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type='excel_content_damage' order by t.order_num";
		List<Map> fileListDamage = new ArrayList<Map>();
		fileListDamage= jdbcDao.queryRecords(sqlFilesDamage);
		//文件数据
		responseDTO.setValue("fdataDamage", fileListDamage);//固定资产附件
		//other
		String queryOtherForDeviceSql="select * from dms_scrape_apply where scrape_apply_id='"+scrape_apply_id+"'";
		List<Map> listOther = new ArrayList<Map>();
		Map deviceApplyMap =  jdbcDao.queryRecordBySQL(queryOtherForDeviceSql);
		responseDTO.setValue("deviceApplyMap", deviceApplyMap);
		//查询文件表
		String sqlFilesOther="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' order by t.order_num";
		List<Map> listOther2 = new ArrayList<Map>();
		listOther2= jdbcDao.queryRecords(sqlFilesOther);
		//文件数据
		responseDTO.setValue("fdataOther", listOther2);//其他附件
		
		//人员信息
		String sqlEmp="select * from DMS_SCRAPE_EMPLOYEE t where t.scrape_id='"+deviceAssetMap.get("scrape_asset_id")+"'";
		List<Map> ListEmp = new ArrayList<Map>();
		String expert_ids="";
		String employee_names ="";
		String employee_ids="";
		ListEmp= jdbcDao.queryRecords(sqlEmp);
		for(int i= 0; i<ListEmp.size();i++){
			expert_ids+=ListEmp.get(i).get("id")+",";
			employee_names+=ListEmp.get(i).get("employee_name")+",";
			employee_ids+=ListEmp.get(i).get("employee_id")+",";
		}
		Map employees = new HashMap();
		if(!expert_ids.equals(""))
		employees.put("expert_ids",expert_ids.substring(0, expert_ids.length()-1));
		if(!employee_names.equals(""))
		employees.put("employee_names",employee_names.substring(0, employee_names.length()-1));
		if(!employee_ids.equals(""))
		employees.put("employee_ids",employee_ids.substring(0, employee_ids.length()-1));
		responseDTO.setValue("deviceEmpMap", employees);//其他附件
		
		return responseDTO;
	}
	/**
	 * 查询报废申请盘亏信息
	 */
	public ISrvMsg getScrapeDamageInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String queryAssetInfoSql="select app.* ,asset.* from dms_scrape_apply app left join dms_scrape_damage asset on  app.scrape_apply_id=" +
				"asset.scrape_apply_id where app.scrape_apply_id='"+scrape_apply_id+"'";
		Map deviceAssetMap = jdbcDao.queryRecordBySQL(queryAssetInfoSql.toString());
		String queryAssetForDeviceSql="SELECT *  FROM (SELECT QUERYED_DATAS_.*, ROWNUM ROWNUM_ FROM (select * from dms_scrape_detailed detailed where detailed.scrape_damage_id='"+deviceAssetMap.get("scrape_damage_id")+"' ) QUERYED_DATAS_         WHERE ROWNUM <= 100) WHERE ROWNUM_ >= 1";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryAssetForDeviceSql);
		responseDTO.setValue("datas", list);
		
		if(deviceAssetMap!=null){
			responseDTO.setValue("deviceAssetMap", deviceAssetMap);
		}
		//查询文件表
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1'    and t.file_type is not null order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2= jdbcDao.queryRecords(sqlFiles);
		//文件数据
		responseDTO.setValue("fdata", list2);
		
		String sqlFilesfj="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type is null  order by t.order_num";
		List<Map> fileListfj = new ArrayList<Map>();
		fileListfj= jdbcDao.queryRecords(sqlFilesfj);
		responseDTO.setValue("fdatafj", fileListfj);//其他附件
		
		return responseDTO;
	}
	/**
	 * 查询报废设备明细(全部 通过或不通过) OA鉴定专家 查看
	 */
	public ISrvMsg getScrapeDetailInfoAllForOA(ISrvMsg msg) throws Exception {
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
		//报废申请单号
		String scrapeid=msg.getValue("scrapeid");
	 
		
		StringBuffer querySql = new StringBuffer();
		querySql.append("select '/' jlb,'/' bm,'/' ljzj,'/' jzzb,'1' sl,dev_type,dev_coding,asset_coding,dev_name,dev_model,license_num,producting_date,asset_value,net_value,scrape_type,duty_unit,org_name,case  "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <100 then '八年及以上' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <8 then '五年到八年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <5 then '三年到五年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <3 then '一年到三年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <1 then '一年以内' "
				+ "else '未知时段' end as dev_date ,detailed.team_name as team_name "
				+ "from dms_scrape_detailed detailed "
				+ "left join comm_org_information n on n.org_id = detailed.org_id where 1=1   ");
				if(StringUtils.isNotBlank(scrapeid)){
					querySql.append(" and detailed.scrape_asset_id='"+scrapeid+"' or detailed.scrape_damage_id='"+scrapeid+"' ");
				}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by detailed.scrape_detailed_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询报废设备明细(全部 通过或不通过)
	 */
	public ISrvMsg getScrapeDetailInfoAll(ISrvMsg msg) throws Exception {
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
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String scrape_collect_id=msg.getValue("scrape_collect_id");
		String scrape_report_id=msg.getValue("scrape_report_id");
		String scrape_type = msg.getValue("scrape_type");// 报废设备类别0123正常报废、技术淘汰、盘亏、毁损
		StringBuffer querySql = new StringBuffer();
		querySql.append("select '/' jlb,'/' bm,'/' ljzj,'/' jzzb,'1' sl,dev_type,dev_coding,asset_coding,dev_name,dev_model,license_num,producting_date,asset_value,net_value,scrape_type,duty_unit,org_name,case  "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <100 then '八年及以上' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <8 then '五年到八年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <5 then '三年到五年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <3 then '一年到三年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <1 then '一年以内' "
				+ "else '未知时段' end as dev_date ,detailed.team_name as team_name "
				+ "from dms_scrape_detailed detailed "
				+ "left join comm_org_information n on n.org_id = detailed.org_id where 1=1   ");
		if (StringUtils.isNotBlank(scrape_type)) {
			if(scrape_type.equals("1")){
				querySql.append(" and detailed.scrape_type='1'");
			}else{
				querySql.append(" and detailed.scrape_type in('2','3')");
			}
		}
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			querySql.append(" and detailed.scrape_apply_id  = '"+scrape_apply_id+"'");
		}	
		// 汇总单号
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			querySql.append(" and detailed.scrape_apply_id in(select scrape_apply_id  from dms_scrape_apply where scrape_collect_id  = '"+scrape_collect_id+"')");
		}
		// 上报单号
		if (StringUtils.isNotBlank(scrape_report_id)) {
			querySql.append(" and detailed.scrape_apply_id in(select scrape_apply_id  from dms_scrape_apply where scrape_report_id  = '"+scrape_report_id+"') and detailed.sp_pass_flag = '0' ");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by detailed.scrape_detailed_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询报废设备明细(通过)
	 */
	public ISrvMsg getScrapeDetailInfo(ISrvMsg msg) throws Exception {
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
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String scrape_collect_id=msg.getValue("scrape_collect_id");
		String scrape_report_id=msg.getValue("scrape_report_id");
		String scrape_type = msg.getValue("scrape_type");// 报废设备类别0123正常报废、技术淘汰、盘亏、毁损
		StringBuffer querySql = new StringBuffer();
		querySql.append("select '/' jlb,'/' bm,'/' ljzj,'/' jzzb,'1' sl,dev_type,dev_coding,temp.asset_coding,dev_name,dev_model,license_num,producting_date,asset_value,net_value,scrape_type,duty_unit,   orgsubidtoname(os.org_subjection_id) org_name,case  "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <100 then '八年及以上' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <8 then '五年到八年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <5 then '三年到五年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <3 then '一年到三年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <1 then '一年以内' "
				+ "else '未知时段' end as dev_date ,detailed.team_name as team_name ,detailed.project_name "
				+ "from dms_scrape_detailed detailed   left join  (select dev_acc_id,asset_coding from gms_device_account union select dev_acc_id,asset_coding from  gms_device_account_b) temp  on detailed.foreign_dev_id=temp.dev_acc_id "
				+ "left join comm_org_information n on n.org_id = detailed.org_id   left join comm_org_subjection os    on n.org_id = os.org_id and os.bsflag='0'  where 1=1 and detailed.sp_pass_flag='0' and detailed.bsflag='0' ");
		if (StringUtils.isNotBlank(scrape_type)) {
			if(scrape_type.equals("1")){
				querySql.append(" and detailed.scrape_type='1'");
			}else{
				querySql.append(" and detailed.scrape_type in('2','3')");
			}
		}
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			querySql.append(" and detailed.scrape_apply_id  = '"+scrape_apply_id+"'");
		}	
		// 汇总单号
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			querySql.append(" and detailed.scrape_apply_id in(select scrape_apply_id  from dms_scrape_apply where scrape_collect_id  = '"+scrape_collect_id+"')");
		}
		// 上报单号
		if (StringUtils.isNotBlank(scrape_report_id)) {
			querySql.append(" and detailed.scrape_apply_id in(select scrape_apply_id  from dms_scrape_apply where scrape_report_id  = '"+scrape_report_id+"') and detailed.sp_pass_flag = '0' ");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by detailed.scrape_detailed_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询报废设备其他说明
	 */
	public ISrvMsg getScrapeOtherInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String queryAssetForDeviceSql="select * from dms_scrape_apply where scrape_apply_id='"+scrape_apply_id+"'";
		List<Map> list = new ArrayList<Map>();
		Map deviceApplyMap =  jdbcDao.queryRecordBySQL(queryAssetForDeviceSql);
		responseDTO.setValue("deviceApplyMap", deviceApplyMap);
		//查询文件表
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2= jdbcDao.queryRecords(sqlFiles);
		//文件数据
		responseDTO.setValue("fdata", list2);
		return responseDTO;
	}
	/**
	 *添加报废申请单基本信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeother(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//获得报废申请单ID
		String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");
		System.out.println("申请单ID==========="+scrape_apply_id);
		//其他说明
		String bak=isrvmsg.getValue("bak");
		//多附件
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
			mainMap.put("scrape_apply_id", scrape_apply_id);
			mainMap.put("bak", bak);
			mainMap.put("modify_date", currentdate);
			mainMap.put("updatetor", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//6.向数据库写入信息
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_APPLY");
			
			MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
			
			List<WSFile> files = mqMsg.getFiles();
			try {
					//处理附件
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
						doc.put("relation_id", scrape_apply_id);
						doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
						doc.put("create_date",currentdate);
						doc.put("creator_id",user.getUserId());
						doc.put("org_id", user.getOrgId());
						doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
						String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
						ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
						ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
		/*				//只有在新增文件时才写历史 
						if((StringUtils.isEmpty(isrvmsg.getValue("paper_id"))) ){
							
						
						}*/
					}
				
			} catch (Exception e) {
				
			}
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		return respMsg;
	}
	
	/**
	 *添加报废申请单所有信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeall(ISrvMsg isrvmsg) throws Exception {
//		1、基本
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//获得报废申请单名称
		String scrape_apply_name=isrvmsg.getValue("scrape_apply_name");
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		String apply_date=isrvmsg.getValue("apply_date");
		//生成基本信息
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String scrape_apply_no = isrvmsg.getValue("scrape_apply_no");
		//如果是新增操作
		if("null".equals(scrape_apply_id)){
			scrape_apply_no = CommonUtil.getScrapeAppNo();
			mainMap.put("scrape_apply_name", scrape_apply_name);
			mainMap.put("apply_date", apply_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("scrape_apply_no", scrape_apply_no);
			mainMap.put("create_date", currentdate);
			mainMap.put("creater", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//6.向数据库写入信息
			Serializable id=jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_APPLY");
			scrape_apply_id=id.toString();
		}
		//修改操作
		else
		{	
			mainMap.put("scrape_apply_id", scrape_apply_id);
			mainMap.put("scrape_apply_name", scrape_apply_name);
			mainMap.put("apply_date", apply_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("modify_date", currentdate);
			mainMap.put("updatetor", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//6.向数据库写入信息
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_APPLY");
		}
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		respMsg.setValue("scrape_apply_id", scrape_apply_id);
////////2、固有资产开始
		//报废申请
		String scrape_asset_id=isrvmsg.getValue("scrape_asset_id");// 报废固定资产ID
		List assetList = new ArrayList();
		//附件上传
		Boolean filesAssetflag = false;
		MQMsgImpl mqMsgAsset = (MQMsgImpl) isrvmsg;
		List<WSFile> filesAsset = mqMsgAsset.getFiles();
		try {
				//处理附件
				for (WSFile file : filesAsset) {
					String fileOrder = file.getKey().toString();
					if(fileOrder.equals("excel_content_asset")){
						filesAssetflag = true;
						String filename = file.getFilename();
						//对比提交申请的excel上传的数据与审批的excel的数据是否存在差异
						assetList = getAllExcelDataByWSFile(file);
						MyUcm ucm = new MyUcm();
						String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
	
						Map doc = new HashMap();
						doc.put("file_name", filename);
						doc.put("file_type",fileOrder);
						doc.put("ucm_id", ucmDocId);
						doc.put("is_file", "1");
						doc.put("relation_id", scrape_apply_id);
						doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
						doc.put("create_date",currentdate);
						doc.put("creator_id",user.getUserId());
						doc.put("org_id", user.getOrgId());
						doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
						String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
						ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
						ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
						break;
					}
				}
			
		} catch (Exception e) {
			
		}
		//附件上传
		//固定资产报废台账信息保存
		Map<String,Object> assetMap = new HashMap<String,Object>();
		if(scrape_asset_id!=null&&scrape_asset_id!=""&&scrape_asset_id.length()>0)
		{
			assetMap.put("SCRAPE_ASSET_ID", scrape_asset_id);
			//删除之前的所有报废的设备信息,避免重复添加
			String deleteSql = "delete dms_scrape_detailed detailed where detailed.scrape_asset_id='"+scrape_asset_id+"'";
			jdbcDao.executeUpdate(deleteSql);
		}
		assetMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
		/*assetMap.put("ASSET_NOW_DESC", isrvmsg.getValue("asset_now_desc"));
		assetMap.put("SCRAPE_REASON", isrvmsg.getValue("scrape_reason"));
		assetMap.put("expert_desc", isrvmsg.getValue("expert_desc"));
		assetMap.put("EXPERT_LEADER",isrvmsg.getValue("expert_leader"));
		assetMap.put("EXPERT_MEMBERS",isrvmsg.getValue("expert_members"));
		assetMap.put("APPRAISAL_DATE",isrvmsg.getValue("appraisal_date"));*/
		assetMap.put("create_date", currentdate);
		assetMap.put("creater", user.getEmpId());
		assetMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
		Serializable id= jdbcDao.saveOrUpdateEntity(assetMap, "DMS_SCRAPE_ASSET");
		//如果上传的附件的话,调整添加设备的方式
		String  flag_asset = isrvmsg.getValue("flag_asset");
		if(filesAssetflag||flag_asset.equals("1")){
			long s_asset=new Date().getTime();
			GroupingHandle(assetList,id,null,scrape_apply_id,user);
			long systime = System.currentTimeMillis();
			long e_asset=new Date().getTime();
			respMsg.setValue("time_asset",e_asset-s_asset);
			System.out.println("开始时间:"+s_asset+",结束时间:"+e_asset+",time:"+(e_asset-s_asset)+",系统时间:"+systime);
		}else{
			//添加报废设备数量
			int count = Integer.parseInt(isrvmsg.getValue("colnum"));
			String parmeter=isrvmsg.getValue("parmeter");
		    String par[]=parmeter.split(",");
			for(int i=0;i<=count;i++)
			{
				Map<String,Object> dataMap = new HashMap<String,Object>();
				//获取设备台账的ID
				//String dev_id=isrvmsg.getValue("detdev_ci_code_asset"+par[i]);
				//erp编号
				String dev_coding=isrvmsg.getValue("dev_coding_asset"+par[i]);
				//设备台账ID查询设备相关信息
				StringBuffer queryScrapeInfoSql = new StringBuffer();
				//queryScrapeInfoSql.append("select * from gms_device_account account where account.dev_acc_id='"+dev_id+"'");
				queryScrapeInfoSql.append("select * from (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) account where account.dev_coding='"+dev_coding+"'");
				Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
				if(deviceMap!=null)
				{
					//报废申请单ID
					dataMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
					//报废设备类型
					dataMap.put("SCRAPE_TYPE", isrvmsg.getValue("scrape_type_asset"+par[i]));
					//设备名称
					dataMap.put("DEV_NAME",deviceMap.get("dev_name"));
					//规格型号
					dataMap.put("DEV_MODEL",deviceMap.get("dev_model"));
					//ERP设备编码
					dataMap.put("DEV_CODING",dev_coding);
					//固定资产编号
					dataMap.put("ASSET_CODING",deviceMap.get("asset_coding"));
					//设备原值
					dataMap.put("ASSET_VALUE",deviceMap.get("asset_value"));
					//设备原值
					dataMap.put("NET_VALUE",deviceMap.get("net_value"));
					//实物标记号
					dataMap.put("DEV_SIGN",deviceMap.get("dev_sign"));
					//设备编号
					dataMap.put("DEV_TYPE",deviceMap.get("dev_type"));
					//牌照号
					dataMap.put("LICENSE_NUM",deviceMap.get("license_num"));
					//投产日期
					dataMap.put("PRODUCTING_DATE",deviceMap.get("producting_date"));
					//报废标示
					dataMap.put("SCRAPE_FLAG","0");
					//所属机构
					dataMap.put("ORG_ID",deviceMap.get("owning_org_id"));
					//备注
					dataMap.put("bak1", isrvmsg.getValue("bak_asset"+par[i]));
					//固定资产申请ID
					dataMap.put("SCRAPE_ASSET_ID", id.toString());
					//设备台账ID
					//dataMap.put("FOREIGN_DEV_ID",dev_id);
					dataMap.put("FOREIGN_DEV_ID",deviceMap.get("dev_acc_id"));
					dataMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
					jdbcDao.saveOrUpdateEntity(dataMap, "DMS_SCRAPE_DETAILED");
				}
			}
		}
////////2、固有资产结束
////////3、毁损开始
		//报废申请
		String scrape_damage_id=isrvmsg.getValue("scrape_damage_id");// 报废盘亏亏损ID
		List damageList = new ArrayList();
		//附件上传
		Boolean filesDamageflag = false;
		String specialized_unit_flag=isrvmsg.getValue("specialized_unit_flag");// 专业化服务单位设备
		String else_unit_flag=isrvmsg.getValue("else_unit_flag");// 其他单位设备
		Map<String,Object> damageMap = new HashMap<String,Object>();
		//上传附件
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> files = mqMsg.getFiles();
		//证明材料
		String proof_file=isrvmsg.getValue("proof_file");
		//赔付证明
		String payment_proof_file=isrvmsg.getValue("payment_proof_file");
		//责任人处理
		String dev_photo_file=isrvmsg.getValue("dev_photo_file");
		//毁损照片
		String person_handling_file=isrvmsg.getValue("person_handling_file");
		
		String doc_content_damage=isrvmsg.getValue("doc_content_damage");
		if(proof_file!=null)
		{
			proof_file=jdbcDao.generateUUID();
			assetMap.put("proof_file", proof_file);
		}
		if(payment_proof_file!=null)
		{
			payment_proof_file=jdbcDao.generateUUID();
			assetMap.put("payment_proof_file", payment_proof_file);
		}
		if(dev_photo_file!=null)
		{
			dev_photo_file=jdbcDao.generateUUID();
			assetMap.put("dev_photo_file", dev_photo_file);
		}
		if(person_handling_file!=null)
		{
			person_handling_file=jdbcDao.generateUUID();
			assetMap.put("person_handling_file", person_handling_file);
		}
		if(doc_content_damage!=null)
		{
			doc_content_damage=jdbcDao.generateUUID();
			assetMap.put("doc_content_damage", doc_content_damage);
		}
		try {
				//处理附件
				for (WSFile file : files) {
					String filename = file.getFilename();
					String fileOrder = file.getKey().toString();
					if(fileOrder.equals("excel_content_asset")){
						continue;
					}else if(fileOrder.equals("excel_content_damage")){
						filesDamageflag = true;
						damageList = getAllExcelDataByWSFile(file);
					}else if(fileOrder.split("__").length>1){
						continue;
					}
					MyUcm ucm = new MyUcm();
					String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
					Map doc = new HashMap();
					if(fileOrder.equals("proof_file_"))
					{
						fileOrder=proof_file;
					}
					if(fileOrder.equals("payment_proof_file_"))
					{
						fileOrder=payment_proof_file;
					}
					if(fileOrder.equals("dev_photo_file_"))
					{
						fileOrder=dev_photo_file;
					}
					if(fileOrder.equals("person_handling_file_"))
					{
						fileOrder=person_handling_file;
					}
					doc.put("relation_id", scrape_apply_id);
					doc.put("file_name", filename);
					doc.put("file_type",fileOrder);
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("create_date",currentdate);
					doc.put("creator_id",user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
	/*				//只有在新增文件时才写历史 
					if((StringUtils.isEmpty(isrvmsg.getValue("paper_id"))) ){
					
					}*/
				}
			
		} catch (Exception e) {
			
		}
		

		//固定资产报废台账信息保存
		if(scrape_damage_id!=null)
		{
		if(scrape_damage_id!=""&&scrape_damage_id.length()>0)
		{
			assetMap.put("SCRAPE_DAMAGE_ID", scrape_damage_id);
			//删除之前的所有报废的设备信息,避免重复添加
			String deleteSql = "delete dms_scrape_detailed detailed where detailed.scrape_damage_id='"+scrape_damage_id+"'";
			jdbcDao.executeUpdate(deleteSql);
		}
		}
		assetMap.put("specialized_unit_flag", specialized_unit_flag);
		assetMap.put("else_unit_flag", else_unit_flag);
		assetMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
		assetMap.put("LOSS_REASON", isrvmsg.getValue("loss_reason"));
		assetMap.put("create_date", currentdate);
		assetMap.put("creater", user.getEmpId());
		assetMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
		Serializable idDamage= jdbcDao.saveOrUpdateEntity(assetMap, "DMS_SCRAPE_DAMAGE");
		
		String  flag_damage = isrvmsg.getValue("flag_damage");
		if(filesDamageflag||flag_damage.equals("1")){
			//附件处理
			for(int j = 0;j<damageList.size();j++){
				Map<String,Object> dataMap = new HashMap<String,Object>();
				Map map = (Map)damageList.get(j);
				String dev_name = map.get("dev_name").toString();
				String dev_coding = map.get("dev_coding").toString();//ERP设备编码
				String asset_coding = map.get("asset_coding").toString();//Amis资产编码
				String scrape_type = map.get("scrape_type").toString();//
				String bak = map.get("bak").toString();
				StringBuffer queryScrapeInfoSql = new StringBuffer();
				//queryScrapeInfoSql.append("select * from gms_device_account account where account.dev_acc_id='"+dev_id+"'");
				queryScrapeInfoSql.append("select * from (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) account where account.dev_coding='"+dev_coding+"'");
				Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
				if(deviceMap!=null)
				{
					//报废申请单ID
					dataMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
					//报废设备类型
	//					dataMap.put("SCRAPE_TYPE", isrvmsg.getValue("scrape_type_damage"+par[i]));
					//设备名称
					dataMap.put("DEV_NAME",dev_name);
					//规格型号
					dataMap.put("DEV_MODEL",deviceMap.get("dev_model"));
					//ERP设备编码
					dataMap.put("DEV_CODING",dev_coding);
					//固定资产编号
					dataMap.put("ASSET_CODING",asset_coding);
					//设备原值
					dataMap.put("ASSET_VALUE",deviceMap.get("asset_value"));
					//设备净值
					dataMap.put("NET_VALUE",deviceMap.get("net_value"));
					//实物标记号
					dataMap.put("DEV_SIGN",deviceMap.get("dev_sign"));
					//设备编号
					dataMap.put("DEV_TYPE",deviceMap.get("dev_type"));
					//牌照号
					dataMap.put("LICENSE_NUM",deviceMap.get("license_num"));
					//投产日期
					dataMap.put("PRODUCTING_DATE",deviceMap.get("producting_date"));
					//报废标示
					dataMap.put("SCRAPE_FLAG","0");
					//所属机构
					dataMap.put("ORG_ID",deviceMap.get("owning_org_id"));
					//备注
					dataMap.put("bak1", bak);
					//固定资产申请ID
					dataMap.put("SCRAPE_DAMAGE_ID", idDamage.toString());
					//设备台账ID
					//dataMap.put("FOREIGN_DEV_ID",dev_id);
					dataMap.put("FOREIGN_DEV_ID",deviceMap.get("dev_acc_id"));
					dataMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
					jdbcDao.saveOrUpdateEntity(dataMap, "DMS_SCRAPE_DETAILED");
				}
			}
			System.out.println("导入毁损资产数据条数:"+damageList.size()+"条。");
		}else{
		//添加报废设备数量
		int countDamange = Integer.parseInt(isrvmsg.getValue("colnumdamage"));
		String parmeterDamage=isrvmsg.getValue("parmeterdamage");
	    String parDamage[]=parmeterDamage.split(",");
		for(int i=0;i<=countDamange;i++)
		{
			Map<String,Object> dataMap = new HashMap<String,Object>();
			//获取设备台账的ID
			//String dev_id=isrvmsg.getValue("detdev_ci_code_damage"+parDamage[i]);
			//erp编号
			String dev_coding=isrvmsg.getValue("dev_coding_damage"+parDamage[i]);
			//设备台账ID查询设备相关信息
			StringBuffer queryScrapeInfoSql = new StringBuffer();
			//queryScrapeInfoSql.append("select * from gms_device_account account where account.dev_acc_id='"+dev_id+"'");
			queryScrapeInfoSql.append("select * from (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) account where account.dev_coding='"+dev_coding+"'");
			Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
			if(deviceMap!=null)
			{
				//报废申请单ID
				dataMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
				//报废设备类型
				dataMap.put("SCRAPE_TYPE", isrvmsg.getValue("scrape_type_damage"+parDamage[i]));
				//设备名称
				dataMap.put("DEV_NAME",deviceMap.get("dev_name"));
				//规格型号
				dataMap.put("DEV_MODEL",deviceMap.get("dev_model"));
				//ERP设备编码
				dataMap.put("DEV_CODING",dev_coding);
				//固定资产编号
				dataMap.put("ASSET_CODING",deviceMap.get("asset_coding"));
				//设备原值
				dataMap.put("ASSET_VALUE",deviceMap.get("asset_value"));
				//设备净值
				dataMap.put("NET_VALUE",deviceMap.get("net_value"));
				//实物标记号
				dataMap.put("DEV_SIGN",deviceMap.get("dev_sign"));
				//设备编号
				dataMap.put("DEV_TYPE",deviceMap.get("dev_type"));
				//牌照号
				dataMap.put("LICENSE_NUM",deviceMap.get("license_num"));
				//投产日期
				dataMap.put("PRODUCTING_DATE",deviceMap.get("producting_date"));
				//报废标示
				dataMap.put("SCRAPE_FLAG","0");
				//所属机构
				dataMap.put("ORG_ID",deviceMap.get("owning_org_id"));
				//备注
				dataMap.put("bak1", isrvmsg.getValue("bak_damage"+parDamage[i]));
				//固定资产申请ID
				dataMap.put("SCRAPE_DAMAGE_ID", idDamage.toString());
				//设备台账ID
				//dataMap.put("FOREIGN_DEV_ID",dev_id);
				dataMap.put("FOREIGN_DEV_ID",deviceMap.get("dev_acc_id"));
				dataMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
				jdbcDao.saveOrUpdateEntity(dataMap, "DMS_SCRAPE_DETAILED");
			}
		}
		}
////////3、毁损结束
////////4、其他开始
		//其他说明
		String bak=isrvmsg.getValue("bak");
		//多附件
			mainMap.put("scrape_apply_id", scrape_apply_id);
			mainMap.put("bak", bak);
			mainMap.put("modify_date", currentdate);
			mainMap.put("updatetor", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//6.向数据库写入信息
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_APPLY");
			
			MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
			
			List<WSFile> filesOther = mqMsgOther.getFiles();
			try {
					//处理附件
					for (WSFile file : filesOther) {
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
						doc.put("relation_id", scrape_apply_id);
						doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
						doc.put("create_date",currentdate);
						doc.put("creator_id",user.getUserId());
						doc.put("org_id", user.getOrgId());
						doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
						String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
						ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
						ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
		/*				//只有在新增文件时才写历史 
						if((StringUtils.isEmpty(isrvmsg.getValue("paper_id"))) ){
							
						
						}*/
					}
				
			} catch (Exception e) {
				
			}
		return respMsg;
	}
	/**
	 *自定义审批-审批设备报废申请单
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkScrapeApplyInfo(ISrvMsg reqDTO) throws Exception {
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
	
		return msg;
	}
	
	
	/**
	 *自定义审批-审批设备报废申请单--更新申请单设备状态
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateScrapeApplyInfo(ISrvMsg isrvmsg) throws Exception {
			String scrapeApplyId=isrvmsg.getValue("scrapeApplyId");
			String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd");
//			String updateSql="update dms_scrape_detailed set scrape_flag='1',scrape_date=to_date('"+currentdate+"','yyyy-mm-dd') where scrape_apply_id='"+scrapeApplyId+"'";
//			jdbcDao.executeUpdate(updateSql);
//			//更新设备台账使用状态，改为待报废
//			String updateAccountSql="update gms_device_account account  set  account.using_stat='0110000007000000006'  where account.dev_acc_id in( select d.foreign_dev_id from dms_scrape_detailed d where d.scrape_apply_id='"+scrapeApplyId+"')";
//			jdbcDao.executeUpdate(updateAccountSql);
			
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		return respMsg;
	}
	
	
	/**
	 * 查询报废设备列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapeList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String dev_name = isrvmsg.getValue("dev_name");// 设备名称
		String dev_model = isrvmsg.getValue("dev_model");// 设备型号
		String license_num = isrvmsg.getValue("license_num");// 牌照号
		String pageselectedstr=isrvmsg.getValue("pageselectedstr");//可配置查询条件
		String handleFlag=isrvmsg.getValue("handleFlag");//报废标示
		String hflag=isrvmsg.getValue("hflag");//报废处置设备标示
		StringBuffer querySql = new StringBuffer();
		String userid=user.getSubOrgIDofAffordOrg();
		
//			querySql.append("select t.*,apply.scrape_apply_no,dispose.app_no,  ");
//			querySql.append(" (case when t.org_id like 'C105001005%' then '塔里木物探处' else (case when t.org_id like 'C105001002%' ") ;
//			querySql.append(" then '新疆物探处'else(case when t.org_id like 'C105001003%' then '吐哈物探处'else(case when t.org_id like " ) ;
//			querySql.append(" 'C105001004%' then '青海物探处'else(case when t.org_id like 'C105005004%' then '长庆物探处'else(case when t.org_id like ") ;
//			querySql.append(" 'C105005000%' then '华北物探处'else(case when t.org_id like 'C105005001%' then '新兴物探开发处'else(case when t.org_id like " ) ;
//			querySql.append(" 'C105007%' then '大港物探处'else(case when t.org_id like 'C105063%' then '辽河物探处'else(case when t.org_id like 'C105006%' " ) ;
//			querySql.append(" then '装备服务处'else (case when t.org_id like 'C105002%' then '国际勘探事业部'else (case when t.org_id like 'C105003%' then " ) ;
//			querySql.append(" '研究院'else (case when t.org_id like 'C105008%' then '综合物化处'else (case when t.org_id like 'C105015%' then '井中地震中心'  " ) ;
//			querySql.append(" else (case when t.org_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name_desc");
//			querySql.append(" from dms_scrape_detailed t");
//			querySql.append(" left join dms_scrape_apply apply on apply.scrape_apply_id=t.scrape_apply_id");
//			querySql.append(" left join dms_dispose_apply dispose on dispose.dispose_apply_id=t.dispose_apply_id");
//			querySql.append(" where t.scrape_flag='1' and t.bsflag='0'");
			querySql.append("select t.*,apply.scrape_apply_no,dispose.app_no, ");
			querySql.append(" org.org_name as owning_org_name_desc ");
			querySql.append(" from dms_scrape_detailed t left join comm_org_information org on org.org_id=t.org_id");
			querySql.append(" left join dms_scrape_apply apply on apply.scrape_apply_id=t.scrape_apply_id");
			querySql.append(" left join dms_dispose_apply dispose on dispose.dispose_apply_id=t.dispose_apply_id");
			querySql.append(" left join (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) dui on dui.dev_acc_id=t.foreign_dev_id");
			querySql.append(" where t.scrape_flag='1' and t.bsflag='0' and sp_pass_flag = '0'  and dui.owning_sub_id like '"+userid+"%' ");
			// 设备名称
			if (StringUtils.isNotBlank(dev_name)) {
				querySql.append(" and t.dev_name  like '"+dev_name+"%'");
			}
			// 设备型号
			if (StringUtils.isNotBlank(dev_model)) {
				querySql.append(" and t.dev_model  like '"+dev_model+"%'");
			}
			// 牌照号
			if (StringUtils.isNotBlank(license_num)) {
				querySql.append(" and t.license_num  like '"+license_num+"%'");
			}
			// 可配置查询条件
			if (StringUtils.isNotBlank(pageselectedstr)) {
				querySql.append(" and t.SCRAPE_DETAILED_ID not in ("+pageselectedstr+")");
			}
			//报废标示
			if (StringUtils.isNotBlank(handleFlag)) {
				querySql.append(" and t.handle_flag ='"+handleFlag+"'");
			}
			//报废处置设备标示
			if (StringUtils.isNotBlank(hflag)) {
				querySql.append(" and t.handle_flag is null");
			}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 根据报废设备台账主键查询报废设备信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getScrapeDetailedInfo(ISrvMsg msg) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
			//报废台账ID
			String scrape_detailed_id=msg.getValue("scrape_detailed_id");
			StringBuffer querySql = new StringBuffer();
			UserToken user = msg.getUserToken();
			String suborgid=user.getSubOrgIDofAffordOrg();
			querySql.append("select t.*,apply.scrape_apply_no,dispose.app_no, ");
			querySql.append(" org.org_name as owning_org_name_desc, ");
			querySql.append("  (case when t.scrape_type='0' then '正常报废' when t.scrape_type='1' then '技术淘汰' when t.scrape_type='2' then '毁损' when t.scrape_type='2' then '盘亏' else  '' end) as scrapename, ");
			querySql.append(" (case when t.dispose_method_flag='0' then '拍卖(变现)' when t.dispose_method_flag='1' then '交回公司' when t.scrape_type='3' then '其他' else '未处置' end) as disposemethodename ");
			querySql.append(" from dms_scrape_detailed t left join comm_org_information org on org.org_id=t.org_id");
			querySql.append(" left join gms_device_account dui on dui.dev_acc_id=t.foreign_dev_id");
			querySql.append(" left join dms_scrape_apply apply on apply.scrape_apply_id=t.scrape_apply_id");
			querySql.append(" left join dms_dispose_apply dispose on dispose.dispose_apply_id=t.dispose_apply_id");
			querySql.append(" where t.scrape_flag='1' and t.bsflag='0'");
			querySql.append(" and t.scrape_detailed_id='"+scrape_detailed_id+"'  and owning_sub_id like '"+suborgid+"%' ");
			Map deviceMap = jdbcDao.queryRecordBySQL(querySql.toString());
			responseDTO.setValue("deviceMap", deviceMap);
			return responseDTO;
		}

	/**
	 * 设备报废处置申请添加操作
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addDisposeInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		Map map= isrvmsg.toMap();
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//获得报废处置申请单名称
		String app_name=isrvmsg.getValue("app_name");
		String dispose_apply_id = isrvmsg.getValue("dispose_apply_id");
		String apply_date=isrvmsg.getValue("apply_date");
		String bak=isrvmsg.getValue("bak");//其他说明
		String disFiles=isrvmsg.getValue("disFiles");//多附件列表
		//生成基本信息
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String app_no = isrvmsg.getValue("app_no");
		String disposeApplyId="";//存储新增的插入的主键
		//如果是新增操作
		if("null".equals(dispose_apply_id)){
			app_no = CommonUtil.getDisposeAppNo();
			mainMap.put("app_name", app_name);
			mainMap.put("apply_date", apply_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("dispose_org_id", user.getOrgId());
			mainMap.put("app_no", app_no);
			mainMap.put("bak", bak);
			mainMap.put("disfiles", disFiles);
			mainMap.put("create_date", currentdate);
			mainMap.put("creator", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//向数据库写入信息
			Serializable id=jdbcDao.saveOrUpdateEntity(mainMap, "DMS_DISPOSE_APPLY");
			disposeApplyId=id.toString();
			
		}
		//修改操作
		else
		{	
			//删除之前的所有报废的设备信息,避免重复添加
			String deleteSql = "update dms_scrape_detailed set dispose_apply_id='' where dispose_apply_id='"+dispose_apply_id+"'";
			jdbcDao.executeUpdate(deleteSql);
			disposeApplyId=dispose_apply_id;
			mainMap.put("dispose_apply_id", dispose_apply_id);
			mainMap.put("app_name", app_name);
			mainMap.put("apply_date", apply_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("dispose_org_id", user.getOrgId());
			mainMap.put("bak", bak);
			mainMap.put("disfiles", disFiles);
			mainMap.put("modify_date", currentdate);
			mainMap.put("updater", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//6.向数据库写入信息
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_DISPOSE_APPLY");
		}
		

		//更新报废标示
		int count = Integer.parseInt(isrvmsg.getValue("colnum"));
		String parmeter=isrvmsg.getValue("parmeter");
	    String par[]=parmeter.split(",");
		for(int i=0;i<=count;i++)
		{
			Map<String,Object> dataMap = new HashMap<String,Object>();
			//获取报废设备台账的ID
			String dev_id=isrvmsg.getValue("detdev_ci_code"+par[i]);
			//报废台账ID
			dataMap.put("SCRAPE_DETAILED_ID", dev_id);
			//报废处置申请表ID
			dataMap.put("DISPOSE_APPLY_ID", disposeApplyId);
			jdbcDao.saveOrUpdateEntity(dataMap, "DMS_SCRAPE_DETAILED");
		}
		
	MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		
		List<WSFile> files = mqMsg.getFiles();
		try {
				//处理附件
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
					doc.put("relation_id", disposeApplyId);
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("create_date",currentdate);
					doc.put("creator_id",user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
	/*				//只有在新增文件时才写历史 
					if((StringUtils.isEmpty(isrvmsg.getValue("paper_id"))) ){
						
					
					}*/
				}
			/*//检测本次是否累计超过1000W，如果小于此值则直接更新处置状态为待处置
			String sql =  "select sum(d.asset_value) sum_asset,dispose_apply_id from dms_scrape_detailed d "
					+ "where d.dispose_apply_id = '"+dispose_apply_id+"' group by d.dispose_apply_id";
			Map sum_assetMap = jdbcDao.queryRecordBySQL(sql.toString());
			if(sum_assetMap!=null){
				double sum_asset = Double.valueOf(sum_assetMap.get("sum_asset").toString());
				if(sum_asset<=10000000){
					this.updateDisposeInfo(disposeApplyId);
				}
			}*/
		} catch (Exception e) {
			
		}
		return responseDTO;
	}
	
	
	/**
	 * 查询报废处置申请列表
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDisposeList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String app_name = isrvmsg.getValue("app_name");// 报废申请单名称
		String app_no = isrvmsg.getValue("app_no");// 报废申请单号
		String dispose_apply_id = isrvmsg.getValue("dispose_apply_id");// 报废上报名称
		String start_date = isrvmsg.getValue("start_date");//开始时间
		String end_date = isrvmsg.getValue("end_date");//结束时间

		StringBuffer querySql = new StringBuffer();
		//添加累计原值进列表显示中
		querySql.append("select dt.sum_asset,t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name ");
		querySql.append(" from dms_dispose_apply t  left join common_busi_wf_middle t2 on t.dispose_apply_id=t2.business_id  and t2.bsflag='0'  ");
		querySql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		querySql.append(" left join (select sum(d.asset_value) sum_asset,dispose_apply_id from dms_scrape_detailed d where d.dispose_apply_id is not null group by d.dispose_apply_id) dt on t.dispose_apply_id = dt.dispose_apply_id");
		querySql.append(" left join comm_org_information org on t.dispose_org_id = org.org_id  where t.bsflag='0' ");

		// 申请单名称
		if (StringUtils.isNotBlank(app_name)) {
			querySql.append(" and t.app_name  like '"+app_name+"%'");
		}
		// 申请单号
		if (StringUtils.isNotBlank(app_no)) {
			querySql.append(" and t.app_no  like '"+app_no+"%'");
		}
		//处置申请单id
		if (StringUtils.isNotBlank(dispose_apply_id)&&!dispose_apply_id.equals("null")) {
			querySql.append(" and t.dispose_apply_id  = '"+dispose_apply_id+"'");
		}
		if(StringUtils.isNotBlank(start_date)){
			querySql.append(" and t.apply_date>=to_date('"+start_date+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(end_date)){
			querySql.append(" and t.apply_date<=to_date('"+end_date+"','yyyy-mm-dd')");
		}
		//如果是超级管理员的话不做所属单位数据筛选，查询全部的单位数据
		if(!user.getSubOrgIDofAffordOrg().equals("C105")){
			querySql.append(" and t.dispose_org_id in ");
			String my_org_id = getOrgMessage(user);
			if(my_org_id.equals("C6000000005263")){//大港
				querySql.append("('C6000000005263','C6000000000008')");
			}else if(my_org_id.equals("C6000000005358")){//物资供应中心
				querySql.append("('C6000000005358','C6000000005362')");
			}else if(my_org_id.equals("C6000000000007")){//装备服务处
				querySql.append("('C6000000000007','C6000000005519')");
			}else{
				querySql.append("('"+my_org_id+"')");
			}
		}
		//添加排序
		querySql.append(" order by t.create_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	public String getOrgMessage(UserToken user){
		String sql =  "select case"
				 +" when org_subjection_id like 'C105093%' then 'C6000000008359'" //大庆二
				 +" when org_subjection_id like 'C105092%' then 'C6000000008191'" //大庆一
				 +" when org_subjection_id like 'C105087%' then 'C6000000008025'"
				 +" when org_subjection_id like 'C105001005%' then 'C6000000005303'"
				 +" when org_subjection_id like 'C105001002%' then 'C6000000005625'"
				 +" when org_subjection_id like 'C105001003%' then 'C6000000000013'"
				 +" when org_subjection_id like 'C105001004%' then 'C6000000005183'"
				 +" when org_subjection_id like 'C105005004%' then 'C6000000005119'"
				 +" when org_subjection_id like 'C105005000%' then 'C6000000005135'"
				 +" when org_subjection_id like 'C105005001%' then 'C6000000005156'"
				 +" when org_subjection_id like 'C105007%' then 'C6000000005263'"
				 +" when org_subjection_id like 'C105063%' then 'C6000000001935'"
				 +" when org_subjection_id like 'C105008%' then 'C6000000005584'"
				 +" when org_subjection_id like 'C105006%' then 'C6000000000007'"
				 +" when org_subjection_id like 'C105002%' then 'C6000000000003'"
				 +" when org_subjection_id like 'C105003%' then 'C6000000005423'"
				 +" when org_subjection_id like 'C105015%' then '井中地震中心'"
				 +" when org_subjection_id like 'C105086%' then 'C6000000005232'"
				 +" when org_subjection_id like 'C105017%' then 'C6000000005929'"
				 +" when org_subjection_id like 'C105014%' then 'C6000000000015'"
				 +" when org_subjection_id like 'C105016%' then 'C6000000007452'"
				 +" when org_subjection_id like 'C105005%' then '东方地球物理公司东部勘探'"
				 +" when org_subjection_id like 'C105075%' then 'C6000000005088'"
				 +" when org_subjection_id like 'C105004%' then 'C6000000006721'"
				 +" when org_subjection_id like 'C105078%' then 'C6000000005358'"
				 +" when org_subjection_id like 'C105013%' then 'C6000000005163'"
				 +" when org_subjection_id like 'C105082%' then 'C6000065089821'"
				 +" when org_subjection_id like 'C105090%' then 'C6000000006017'"
				 +" else '' end as my_org_id  from comm_org_subjection d where d.bsflag='0' and d.org_id ='"+user.getOrgId()+"'";
		Map orgMap = jdbcDao.queryRecordBySQL(sql.toString());
		return (String) orgMap.get("my_org_id");
	}
	/**
	 * 查询报废处置申请单信息
	 */
	public ISrvMsg getDisposeInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废处置申请单号
		String dispose_apply_id=msg.getValue("dispose_apply_id");
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		 queryScrapeInfoSql.append("select t.*,emp.employee_name,org.org_name as org_name from dms_dispose_apply t ");
		queryScrapeInfoSql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		queryScrapeInfoSql.append(" left join comm_org_information org on t.dispose_org_id = org.org_id   ");
		queryScrapeInfoSql.append("	where  t.bsflag='0' and DISPOSE_APPLY_ID='"+dispose_apply_id+"'");
		Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		String queryAssetForDeviceSql="select detailed.*,case  when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <100 then '八年及以上' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <8 then '五年到八年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <5 then '三年到五年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <3 then '一年到三年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <1 then '一年以内' else '未知时段' end as dev_date,account.*,n.org_name from dms_scrape_detailed detailed left join gms_device_account account on account.dev_acc_id=detailed.foreign_dev_id left join comm_org_information n on n.org_id = detailed.org_id where 1=1 "
				+ "and detailed.dispose_apply_id='"+dispose_apply_id+"'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryAssetForDeviceSql.toString());
		responseDTO.setValue("datas", list);
		
		if(deviceMap!=null){
			responseDTO.setValue("deviceMap", deviceMap);
		}
		//查询文件表
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+dispose_apply_id+"' and t.bsflag='0' and t.is_file='1' order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2= jdbcDao.queryRecords(sqlFiles);
		//文件数据
		responseDTO.setValue("fdata", list2);
		
		
		return responseDTO;
	}
	
	/**
	 * 查询报废申请单状态
	 */
	public ISrvMsg getDisposeState(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String dispose_apply_id=isrvmsg.getValue("dispose_apply_id");// 报废处置申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select devapp.dispose_apply_id, nvl(wfmiddle.proc_status, '') as proc_status  from dms_dispose_apply devapp ");
		queryScrapeInfoSql.append(" left join common_busi_wf_middle wfmiddle on devapp.dispose_apply_id = wfmiddle.business_id ");
		// 申请单ID
		if (StringUtils.isNotBlank(dispose_apply_id)) {
			queryScrapeInfoSql.append(" and dispose_apply_id  = '"+dispose_apply_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		//检测本次是否累计超过1000W，如果小于此值则直接更新处置状态为待处置
		String sql =  "select sum(d.asset_value) sum_asset,dispose_apply_id from dms_scrape_detailed d "
				+ "where d.dispose_apply_id = '"+dispose_apply_id+"' group by d.dispose_apply_id";
		Map sum_assetMap = jdbcDao.queryRecordBySQL(sql.toString());
		double sum_asset =0l;
		if(sum_assetMap!=null){
			sum_asset = Double.valueOf(sum_assetMap.get("sum_asset").toString());
		}
		responseDTO.setValue("sum_asset", sum_asset);
		return responseDTO;
	}
	/**
	 * 删除报废申请单
	 */
	public ISrvMsg deleteDisposeInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String dispose_apply_id=isrvmsg.getValue("dispose_apply_id");// 报废申请单ID
		Map<String,Object> mainMap = new HashMap<String,Object>();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		mainMap.put("employee_id", user.getEmpId());
		mainMap.put("scrape_org_id", user.getOrgId());
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updater", user.getEmpId());
		mainMap.put("dispose_apply_id", dispose_apply_id);
		mainMap.put("bsflag", CommonConstants.BSFLAG_DELETE);
		//6.向数据库写入信息
		jdbcDao.saveOrUpdateEntity(mainMap, "DMS_DISPOSE_APPLY");
		return responseDTO;
	}
	
	/**
	 * 查询设备处置结果设备列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDisposeResultList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String dispose_method_name = isrvmsg.getValue("dispose_method_name");// 报废处置结果名称
		String dispose_method_no = isrvmsg.getValue("dispose_method_no");// 报废处置结果单号
		String dispose_method_id = isrvmsg.getValue("dispose_method_id");// 报废处置结果单号
		String start_date = isrvmsg.getValue("start_date");//开始时间
		String end_date = isrvmsg.getValue("end_date");//结束时间
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,emp.employee_name,org.org_name as org_name ");
		querySql.append(" from dms_dispose_method t");
		querySql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		querySql.append(" left join comm_org_information org on t.method_org_id = org.org_id  where t.bsflag='0' ");
		// 报废处置结果名称
		if (StringUtils.isNotBlank(dispose_method_name)) {
			querySql.append(" and t.dispose_method_name  like '"+dispose_method_name+"%'");
		}
		// 报废处置结果单号
		if (StringUtils.isNotBlank(dispose_method_no)) {
			querySql.append(" and t.dispose_method_no  like '"+dispose_method_no+"%'");
		}
		//处置申请单id
		if (StringUtils.isNotBlank(dispose_method_id)&&!dispose_method_id.equals("null")) {
			querySql.append(" and t.dispose_method_id  = '"+dispose_method_id+"'");
		}
		if(StringUtils.isNotBlank(start_date)){
			querySql.append(" and t.dispose_date>=to_date('"+start_date+"','yyyy-mm-dd')");
		}
		if(StringUtils.isNotBlank(end_date)){
			querySql.append(" and t.dispose_date<=to_date('"+end_date+"','yyyy-mm-dd')");
		}
		//如果是超级管理员的话不做所属单位数据筛选，查询全部的单位数据
		if(!user.getSubOrgIDofAffordOrg().equals("C105")){
			querySql.append(" and t.method_org_id in ");
			String my_org_id = getOrgMessage(user);
			if(my_org_id.equals("C6000000005263")){//大港
				querySql.append("('C6000000005263','C6000000000008')");
			}else if(my_org_id.equals("C6000000005358")){//物资供应中心
				querySql.append("('C6000000005358','C6000000005362')");
			}else if(my_org_id.equals("C6000000000007")){//装备服务处
				querySql.append("('C6000000000007','C6000000005519')");
			}else{
				querySql.append("('"+my_org_id+"')");
			}
		}
		//添加排序
		querySql.append(" order by t.DISPOSE_DATE desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 监督人查询设备处置结果设备列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDisposeResultListForJianduer(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String userName=user.getUserName();// 登录人姓名
		//获取当前页
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
		String dispose_method_name = isrvmsg.getValue("dispose_method_name");// 报废处置结果名称
		String dispose_method_no = isrvmsg.getValue("dispose_method_no");// 报废处置结果单号
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,t.jianduer_name as employee_name,org.org_name as org_name ");
		querySql.append(" from dms_dispose_method t");
		querySql.append(" left join comm_org_information org on t.method_org_id = org.org_id  where t.bsflag='0'   and t.jianduer_name='"+userName+"' ");
		// 报废处置结果名称
		if (StringUtils.isNotBlank(dispose_method_name)) {
			querySql.append(" and t.dispose_method_name  like '"+dispose_method_name+"%'");
		}
		// 报废处置结果单号
		if (StringUtils.isNotBlank(dispose_method_no)) {
			querySql.append(" and t.dispose_method_no  like '"+dispose_method_no+"%'");
		}
		//添加排序
		querySql.append(" order by t.DISPOSE_DATE desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 *自定义审批-审批设备报废处置申请单
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg checkDisposeInfo(ISrvMsg isrvmsg) throws Exception {
			String disposeApplyId=isrvmsg.getValue("disposeApplyId");
			this.updateDisposeInfo(disposeApplyId);
			//设备处置申请通过，删除设备台账的设备 gms_device_account
			//String updateAccountSql="update gms_device_account account set account.bsflag='1' where account.dev_acc_id in(select d.foreign_dev_id from dms_scrape_detailed d where d.dispose_apply_id='"+disposeApplyId+"')";
			//jdbcDao.executeUpdate(updateAccountSql);
			//设备处置申请通过，删除设备台账的设备 gms_device_account_b
			//String updateAccountbSql="update gms_device_account_b account set account.bsflag='1' where account.dev_acc_id in(select d.foreign_dev_id from dms_scrape_detailed d where d.dispose_apply_id='"+disposeApplyId+"')";
			//jdbcDao.executeUpdate(updateAccountbSql);
			
			//设备处置申请通过，更新设备台账的设备 gms_device_account表 account_stat状态为0110000013000000002 （已处置)
			//String updateAccountSql="update gms_device_account account set account.account_stat='0110000013000000002' where account.dev_acc_id in(select d.foreign_dev_id from dms_scrape_detailed d where d.dispose_apply_id='"+disposeApplyId+"')";
			//jdbcDao.executeUpdate(updateAccountSql);
			//设备处置申请通过，更新设备台账的设备 gms_device_accountb表 account_stat状态为0110000013000000002 (已处置)
			//String updateAccountbSql="update gms_device_account_b account set account.account_stat='0110000013000000002' where account.dev_acc_id in(select d.foreign_dev_id from dms_scrape_detailed d where d.dispose_apply_id='"+disposeApplyId+"')";
			//jdbcDao.executeUpdate(updateAccountbSql);
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		return respMsg;
	}
	//根据处置申请单更新设备详情表处置状态 0 未处置 1已处置 null默认
	public int updateDisposeInfo(String disposeApplyId){
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd");
		String updateSql="update dms_scrape_detailed set handle_flag='0' where dispose_apply_id='"+disposeApplyId+"'";
		int num = jdbcDao.executeUpdate(updateSql);
		return num;
	}
	
	/**处置结果方法
	 * 添加处置收入入账凭证号 dispose_income_no 和备注字段
	 * */
	public ISrvMsg addDisposeResult(ISrvMsg msg) throws Exception {
		UserToken user = msg.getUserToken();
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(msg);
		//报废处置结果录入
		String dispose_method_id=msg.getValue("dispose_method_id");// 报废处置结果ID
		
		String dispose_income_no=msg.getValue("dispose_income_no");//处置收入入账凭证号
		String remark=msg.getValue("remark");//备注
		String dispose_date=msg.getValue("dispose_date");//处置日期
		String dispose_place=msg.getValue("dispose_place");//处置地点
		String province=msg.getValue("province");//处置省份
		String dispose_method_name=msg.getValue("dispose_method_name");//报废处置结果名称
		String dispose_method_no=msg.getValue("dispose_method_no");//报废处置结果名称
		String jianduer_id=msg.getValue("jianduer_id");//报废处置结果名称
		String jianduer_name=msg.getValue("jianduer_name");//报废处置结果名称
		String paimainum=msg.getValue("dispose_paimai_num");
		String paimaimoney=msg.getValue("dispose_paimai_money");
		String companynum=msg.getValue("dispose_company_num");
		String companymoney=msg.getValue("dispose_company_money");
		String othernum=msg.getValue("dispose_other_num");
		String othermoney=msg.getValue("dispose_other_money");
		String sumnum=msg.getValue("dispose_sum_num");
		String summoney=msg.getValue("dispose_sum_money");
		Map<String,Object> methodMap = new HashMap<String,Object>();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		//新增操作
		if("null".equals(dispose_method_id)){
			//生成报废处置结果单号
			dispose_method_no=CommonUtil.getDisposeResultNo();
			methodMap.put("dispose_method_name", dispose_method_name);
			methodMap.put("dispose_method_no", dispose_method_no);
			methodMap.put("method_org_id",user.getOrgId());
			methodMap.put("check_date",currentdate);
			methodMap.put("check_date",currentdate);
			methodMap.put("employee_id",user.getEmpId());
			methodMap.put("dispose_income_no",dispose_income_no);//处置收入入账凭证号
			methodMap.put("remark",remark);//备注
			methodMap.put("dispose_date", dispose_date);
			methodMap.put("dispose_place", dispose_place);
			methodMap.put("province", province);
			methodMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			methodMap.put("jianduer_id", jianduer_id);
			methodMap.put("jianduer_name", jianduer_name);
			methodMap.put("paimainum", paimainum);
			methodMap.put("paimaimoney", paimaimoney);
			methodMap.put("companynum", companynum);
			methodMap.put("companymoney", companymoney);
			methodMap.put("othernum", othernum);
			methodMap.put("othermoney", othermoney);
			methodMap.put("sumnum", sumnum);
			methodMap.put("summoney", summoney);
			Serializable id= jdbcDao.saveOrUpdateEntity(methodMap, "DMS_DISPOSE_METHOD");
			dispose_method_id=id.toString();
			
		}
		//修改操作
		else
		{
			methodMap.put("dispose_method_name", dispose_method_name);
			methodMap.put("method_org_id",user.getOrgId());
			methodMap.put("check_date",currentdate);
			methodMap.put("employee_id",user.getEmpId());
			methodMap.put("dispose_method_id", dispose_method_id);
			methodMap.put("dispose_income_no",dispose_income_no);//处置收入入账凭证号
			methodMap.put("remark",remark);//备注
			methodMap.put("dispose_date", dispose_date);
			methodMap.put("dispose_place", dispose_place);
			methodMap.put("province", province);
			methodMap.put("dispose_method_id", dispose_method_id);
			methodMap.put("jianduer_id", jianduer_id);
			methodMap.put("jianduer_name", jianduer_name);
			methodMap.put("paimainum", paimainum);
			methodMap.put("paimaimoney", paimaimoney);
			methodMap.put("companynum", companynum);
			methodMap.put("companymoney", companymoney);
			methodMap.put("othernum", othernum);
			methodMap.put("othermoney", othermoney);
			methodMap.put("sumnum", sumnum);
			methodMap.put("summoney", summoney);
			jdbcDao.saveOrUpdateEntity(methodMap, "DMS_DISPOSE_METHOD");
			//删除之前的设备处置信息及处置人员信息
			//根据设备报废ID更新设备处置状态
			String updateSql="update dms_scrape_detailed set handle_flag='0',handle_date=null,dispose_method_id=null,dispose_method_flag=null,batch_number=null where dispose_method_id='"+dispose_method_id+"'";
			jdbcDao.executeUpdate(updateSql);
			String deleteSql="delete from DMS_DISPOSE_ATTENDEE where dispose_method_id='"+dispose_method_id+"'";
			jdbcDao.executeUpdate(deleteSql);
		}
		//添加报废设备数量
		int count = Integer.parseInt(msg.getValue("colnum"));
		String parmeter=msg.getValue("parmeter");
	    String par[]=parmeter.split(",");
		for(int i=0;i<=count;i++)
		{
			//根据设备报废ID更新设备处置状态
			String updateSql="update dms_scrape_detailed set handle_flag='1',handle_date=to_date('"+dispose_date+"','yyyy-mm-dd'),dispose_method_id='"+dispose_method_id+"',dispose_method_flag='"+msg.getValue("dispose_method_flag"+par[i])+"',batch_number='"+msg.getValue("batch_number"+par[i])+"' where SCRAPE_DETAILED_ID='"+msg.getValue("detdev_ci_code"+par[i])+"'";
			jdbcDao.executeUpdate(updateSql);
		}
		MQMsgImpl mqMsg = (MQMsgImpl) msg;
		
		List<WSFile> files = mqMsg.getFiles();
		try {
				//处理附件
				for (WSFile file : files) {
					String filename = file.getFilename();
					String fileOrder = file.getKey().toString().split("__")[1];
					MyUcm ucm = new MyUcm();
					String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());

					Map doc = new HashMap();
					doc.put("file_name", filename);
					String fileType = msg.getValue("doc_type__"+fileOrder);
					doc.put("file_type",fileType );
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", dispose_method_id);
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("create_date",currentdate);
					doc.put("creator_id",user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
	/*				//只有在新增文件时才写历史 
					if((StringUtils.isEmpty(isrvmsg.getValue("paper_id"))) ){
						
					
					}*/
				}
			
		} catch (Exception e) {
			
		}

		return respMsg;
	}
	
	/**
	 * 报废处置结果信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDisposeMethodInfo(ISrvMsg msg) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
			//报废台账ID
			String dispose_method_id=msg.getValue("dispose_method_id");
			StringBuffer querySql = new StringBuffer();
			querySql.append("select t.*,emp.employee_name,org.org_name as org_name ");
			querySql.append(" from dms_dispose_method t");
			querySql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
			querySql.append(" left join comm_org_information org on t.method_org_id = org.org_id  where t.bsflag='0' ");
			querySql.append(" and t.dispose_method_id='"+dispose_method_id+"'");
			Map deviceMap = jdbcDao.queryRecordBySQL(querySql.toString());
			responseDTO.setValue("deviceMap", deviceMap);
			String queryAssetForDeviceSql="select * from dms_scrape_detailed detailed where detailed.dispose_method_id='"+dispose_method_id+"'";
			List<Map> list = new ArrayList<Map>();
			list = jdbcDao.queryRecords(queryAssetForDeviceSql);
			responseDTO.setValue("datas", list);
			
			/*String queryMenSql="select * from dms_dispose_attendee detailed where detailed.dispose_method_id='"+dispose_method_id+"'";
			List<Map> list1 = new ArrayList<Map>();
			list1 = jdbcDao.queryRecords(queryMenSql);
			responseDTO.setValue("datas1", list1);*/
			//查询文件表
			String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+dispose_method_id+"' and t.bsflag='0' and t.is_file='1' order by t.order_num";
			List<Map> list2 = new ArrayList<Map>();
			list2= jdbcDao.queryRecords(sqlFiles);
			//文件数据
			responseDTO.setValue("fdata", list2);
			
			return responseDTO;
		}
	
	
	/**
	 * 查询报废处置结果设备明细
	 */
	public ISrvMsg getDisposeResultInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String dispose_method_id=msg.getValue("dispose_method_id");
		String queryAssetForDeviceSql="select detailed.*,case  when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <100 then '八年及以上' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <8 then '五年到八年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <5 then '三年到五年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <3 then '一年到三年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <1 then '一年以内' else '未知时段' end as dev_date,case when detailed.dispose_method_flag='0' then '拍卖' when detailed.dispose_method_flag='1' then '交回公司' else '其他' end as dispose_method_type,account.*,n.org_name from dms_scrape_detailed detailed left join gms_device_account account on account.dev_acc_id=detailed.foreign_dev_id left join comm_org_information n on n.org_id = detailed.org_id where 1=1 "
				+ " and detailed.dispose_method_id='"+dispose_method_id+"'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryAssetForDeviceSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	/**
	 * 查询报废处置人员信息
	 */
	public ISrvMsg getDisposeMenInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String dispose_method_id=msg.getValue("dispose_method_id");
		String queryAssetForDeviceSql="select * from dms_dispose_attendee d where d.dispose_method_id='"+dispose_method_id+"'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(queryAssetForDeviceSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * 报废处置申请对应的附件操作方法
	 * 
	 * @param IN
	 *            :file wsFile文件、columnList xml配置的excel导入配置信息
	 * 
	 * @param Out
	 *            :List 将excel解析的数据集放置到list中
	 */
	private List getDEVExcelDataByWSFile(WSFile file) throws IOException,
			ExcelExceptionHandler {
		List dataList = new ArrayList();
		// String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}

			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			Row row = sheet0.getRow(0);
			for (int m = 1; m < rows; m++) {
				int columns = row.getPhysicalNumberOfCells();
				System.out.println(columns);
				Map mapColumnInfoIn = new HashMap();
				int blankflag = 0;
				for (int n = 0; n < columns; n++) {
					Cell cell = sheet0.getRow(m).getCell(n);
					if (cell == null) {
						mapColumnInfoIn.put(n, "");
					} else {
						int cellType = cell.getCellType();
						switch (cellType) {
						case 1:
							mapColumnInfoIn.put(n, cell.getStringCellValue());
							break;
						case 0:
							DecimalFormat df = new DecimalFormat("0");  
							String whatYourWant = df.format(cell.getNumericCellValue());  
							mapColumnInfoIn.put(n, whatYourWant);
							break;
						case 3:
							blankflag++;
							break;
						}
					}
					if (n == 5 && blankflag < 9) {
						Map map = new HashMap();
						map.put("dev_name", mapColumnInfoIn.get(0)==null?"":mapColumnInfoIn.get(0));//设备名称
						map.put("dev_coding", mapColumnInfoIn.get(1)==null?"":mapColumnInfoIn.get(1));//ERP设备编码
						map.put("dev_model", mapColumnInfoIn.get(2)==null?"":mapColumnInfoIn.get(2));//规格型号
						map.put("dev_type", mapColumnInfoIn.get(3)==null?"":mapColumnInfoIn.get(3));//设备编码
						map.put("asset_value", mapColumnInfoIn.get(4)==null?"":mapColumnInfoIn.get(4));//原值
						map.put("scrape_date", mapColumnInfoIn.get(5)==null?"":mapColumnInfoIn.get(5));//报废日期
						dataList.add(map);
					}
				}
				if (blankflag == 9)
					break;
			}
		}
		return dataList;
	}
	/**
	 * 处理申请设备数据导入
	 * update 只修改本单位的数据  p.owning_sub_id like 'C105%' 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * update 不关联是否在台账中（再次添加并且必须是报废设备2017年11月30日）
	 *  	+ " and t.dev_coding in(select dev_coding from (select dev_coding,owning_sub_id from GMS_DEVICE_ACCOUNT union all select dev_coding,owning_sub_id from GMS_DEVICE_ACCOUNT_b) p where p.owning_sub_id like '"+userid+"%' "
			+ " and dev_coding='"+map.get("dev_coding").toString()+"')";
	 * @author zjb
	 */
	public ISrvMsg saveDisAppExcel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		UserToken user = reqDTO.getUserToken();
		String userid=user.getSubOrgIDofAffordOrg();//所属单位隶属关系id
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = getDEVExcelDataByWSFile(file);
			}
			reqMsg.isSuccessRet();
			List<GmsDevice> nodes = new ArrayList<GmsDevice>();
			int count_success = 0;//统计导入成功数量
			int count_error = 0;//统计导入失败数量
			String error_print = "";//打印不能成功的设备编码
			for(int j = 0;j<dataList.size();j++){
				Map map = (Map)dataList.get(j);
				GmsDevice gmsDevice = new GmsDevice();
				//添加按照erp编码向设备详细表里查询的
				//查询报废标识scrape_flag=1上报后 变成1已报废的
				 String querySql ="select t.* from dms_scrape_detailed t"
						+ " where t.scrape_flag='1' and t.bsflag='0' and t.sp_pass_flag = '0'"
						+ " and (t.handle_flag is null or t.handle_flag =0)"
						+ " and (t.dispose_apply_id is null or  (select bsflag from dms_dispose_apply a where a.dispose_apply_id=t.dispose_apply_id)='1') "//已经关联处置申请不能再次提交 删除后可以提交
						+ " and dev_coding='"+map.get("dev_coding").toString()+"'"
						+ " and dev_coding in(select dev_coding from (select account_stat,dev_coding,owning_sub_id from GMS_DEVICE_ACCOUNT union all select account_stat,dev_coding,owning_sub_id from GMS_DEVICE_ACCOUNT_b) p where  "
						//+ "p.owning_sub_id like '"+userid+"%' and" 去掉只能修改本单位数据
						+ "  p.dev_coding='"+map.get("dev_coding").toString()+"' and p.account_stat='0110000013000000001')";
				Map deviceappMap = jdbcDao.queryRecordBySQL(querySql);
				if(deviceappMap!=null){
					gmsDevice.setScrape_detailed_id(deviceappMap.get("scrape_detailed_id").toString());
					gmsDevice.setDev_name(deviceappMap.get("dev_name").toString());
					gmsDevice.setDev_coding(deviceappMap.get("dev_coding").toString());
					//gmsDevice.setAsset_coding(deviceappMap.get("asset_coding").toString());
					gmsDevice.setDev_model(deviceappMap.get("dev_model").toString());//规格型号
					gmsDevice.setDev_type(deviceappMap.get("dev_type").toString());
					gmsDevice.setAsset_value(deviceappMap.get("asset_value").toString());
					gmsDevice.setNet_value(deviceappMap.get("net_value").toString());
					gmsDevice.setScrape_date(map.get("scrape_date").toString());
					nodes.add(gmsDevice);
					count_success++;
				}else{
					error_print += map.get("dev_coding").toString()+",";
					count_error++;
				}
			}
			System.out.println("不能成功申请处置的设备编码:"+error_print);
			reqMsg.setValue("count_success", count_success);
			reqMsg.setValue("count_error", count_error);
			reqMsg.setValue("nodes", nodes);
		}
		
		System.out.println(dataList.size());
		return reqMsg;
	}
	/**
	 * 通过wsfile 解析excel 获取excel中的信息
	 * 
	 * @param IN
	 *            :file wsFile文件、columnList xml配置的excel导入配置信息
	 * 
	 * @param Out
	 *            :List 将excel解析的数据集放置到list中
	 */
	private List getSRCExcelDataByWSFile(WSFile file) throws IOException,
			ExcelExceptionHandler {
		List dataList = new ArrayList();
		// String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}

			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			Row row = sheet0.getRow(0);
			for (int m = 1; m < rows; m++) {
				int columns = row.getPhysicalNumberOfCells();
				System.out.println(columns);
				Map mapColumnInfoIn = new HashMap();
				int blankflag = 0;
				for (int n = 0; n < columns; n++) {
					Cell cell = sheet0.getRow(m).getCell(n);
					if (cell == null) {
						mapColumnInfoIn.put(n, "");
					} else {
						int cellType = cell.getCellType();
						switch (cellType) {
						case 1:
							mapColumnInfoIn.put(n, cell.getStringCellValue());
							break;
						case 0:
							DecimalFormat df = new DecimalFormat("0");  
							String whatYourWant = df.format(cell.getNumericCellValue());  
							mapColumnInfoIn.put(n, whatYourWant);
							break;
						case 3:
							blankflag++;
							break;
						}
					}
					if (n == 4 && blankflag < 9) {
						Map map = new HashMap();
						map.put("scrape_detailed_id",  mapColumnInfoIn.get(0)==null?"":mapColumnInfoIn.get(0)); 
						map.put("dev_name",  mapColumnInfoIn.get(1)==null?"":mapColumnInfoIn.get(1));
						map.put("dev_model",  mapColumnInfoIn.get(2)==null?"":mapColumnInfoIn.get(2));
						map.put("dev_type",  mapColumnInfoIn.get(3)==null?"":mapColumnInfoIn.get(3));
						map.put("scrape_type",  mapColumnInfoIn.get(4)==null?"":mapColumnInfoIn.get(4));
						map.put("bak", mapColumnInfoIn.get(5)==null?"":mapColumnInfoIn.get(5));
						/*map.put("asset_value", mapColumnInfoIn.get(4));
						map.put("scrape_date", mapColumnInfoIn.get(5));*/
						dataList.add(map);
					}
				}
				if (blankflag == 9)
					break;
			}
		}
		return dataList;
	}
	/**
	 * 设备数据导入
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg saveSrcExcel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		UserToken user = reqDTO.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = getSRCExcelDataByWSFile(file);
			}
			reqMsg.isSuccessRet();
			List<GmsDevice> nodes = new ArrayList<GmsDevice>();
			for(int j = 0;j<dataList.size();j++){
				Map map = (Map)dataList.get(j);
				GmsDevice gmsDevice = new GmsDevice();
				gmsDevice.setScrape_detailed_id(map.get("scrape_detailed_id").toString());
				gmsDevice.setDev_name(map.get("dev_name").toString());
				gmsDevice.setDev_model(map.get("dev_model").toString());
				gmsDevice.setDev_type(map.get("dev_type").toString());
				if(map.get("scrape_type").toString().equals("正常报废")){
					gmsDevice.setScrape_type("0");
				}else if(map.get("scrape_type").toString().equals("技术淘汰")){
					gmsDevice.setScrape_type("1");
				}else if(map.get("scrape_type").toString().equals("毁损")){
					gmsDevice.setScrape_type("2");
				}else if(map.get("scrape_type").toString().equals("盘亏")){
					gmsDevice.setScrape_type("3");
				}
				gmsDevice.setBak(map.get("bak").toString());
				/*gmsDevice.setAsset_value(map.get("asset_value").toString());
				gmsDevice.setScrape_date(map.get("scrape_date").toString());*/
				nodes.add(gmsDevice);
			}
			
			reqMsg.setValue("nodes", nodes);
		}
		
		System.out.println(dataList.size());
		return reqMsg;
	}
	
	/**
	 * 通过wsfile 解析excel 获取excel中的信息
	 * 
	 * @param IN
	 *            :file wsFile文件、columnList xml配置的excel导入配置信息
	 * 
	 * @param Out
	 *            :List 将excel解析的数据集放置到list中
	 */
	private List getRESExcelDataByWSFile(WSFile file) throws IOException,
			ExcelExceptionHandler {
		List dataList = new ArrayList();
		// String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}

			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			Row row = sheet0.getRow(0);
			for (int m = 1; m < rows; m++) {
				int columns = row.getPhysicalNumberOfCells();
				System.out.println(columns);
				Map mapColumnInfoIn = new HashMap();
				int blankflag = 0;
				for (int n = 0; n < columns; n++) {
					Cell cell = sheet0.getRow(m).getCell(n);
					if (cell == null) {
						mapColumnInfoIn.put(n, "");
					} else {
						int cellType = cell.getCellType();
						switch (cellType) {
						case 1:
							mapColumnInfoIn.put(n, cell.getStringCellValue());
							break;
						case 0:
							DecimalFormat df = new DecimalFormat("0");  
							String whatYourWant = df.format(cell.getNumericCellValue());  
							mapColumnInfoIn.put(n, whatYourWant);
							break;
						case 3:
							blankflag++;
							break;
						}
					}
					if (n == 6 && blankflag < 9) {
						Map map = new HashMap();
						map.put("dev_name", mapColumnInfoIn.get(0)==null?"":mapColumnInfoIn.get(0));//设备名称
						map.put("dev_coding", mapColumnInfoIn.get(1)==null?"":mapColumnInfoIn.get(1));//ERP设备编码
						map.put("dev_model", mapColumnInfoIn.get(2)==null?"":mapColumnInfoIn.get(2));
						map.put("dev_type",  mapColumnInfoIn.get(3)==null?"":mapColumnInfoIn.get(3));
						map.put("asset_value", mapColumnInfoIn.get(4)==null?"":mapColumnInfoIn.get(4));
						map.put("scrape_date", mapColumnInfoIn.get(5)==null?"":mapColumnInfoIn.get(5));
						map.put("dispose_method_flag", mapColumnInfoIn.get(6)==null?"":mapColumnInfoIn.get(6));
						dataList.add(map);
					}
				}
				if (blankflag == 9)
					break;
			}
		}
		return dataList;
	}
	/**
	 * 处置结果设备数据导入
	 * 不再限制是不是本二级单位的设备，因为经常有装备的设备在其他物探处报废
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg saveDisResExcel(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		UserToken user = reqDTO.getUserToken();
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		// 获得excel信息
		List<WSFile> files = mqMsg.getFiles();
		List dataList = new ArrayList();
		if (files != null && !files.isEmpty()) {
			for (int i = 0; i < files.size(); i++) {
				WSFile file = files.get(i);
				dataList = getRESExcelDataByWSFile(file);
			}
			reqMsg.isSuccessRet();
			List<GmsDevice> nodes = new ArrayList<GmsDevice>();
			int count_success = 0;//统计导入成功数量
			int count_error = 0;//统计导入失败数量
			for(int j = 0;j<dataList.size();j++){
				Map map = (Map)dataList.get(j);
				GmsDevice gmsDevice = new GmsDevice();
				//添加按照erp编码向设备详细表里查询的
				String userid=user.getSubOrgIDofAffordOrg();
				String querySql ="select t.* from dms_scrape_detailed t "
						+ " where t.scrape_flag='1' and t.bsflag='0' and sp_pass_flag = '0'"
						+ " and t.handle_flag = '0'"
						+ " and dev_coding='"+map.get("dev_coding").toString()+"'";
				Map deviceappMap = jdbcDao.queryRecordBySQL(querySql);
				if(deviceappMap!=null){
					gmsDevice.setScrape_detailed_id(deviceappMap.get("scrape_detailed_id").toString());
					gmsDevice.setDev_name(deviceappMap.get("dev_name").toString());
					gmsDevice.setDev_model(deviceappMap.get("dev_model").toString());
					gmsDevice.setDev_type(deviceappMap.get("dev_type").toString());
					gmsDevice.setAsset_value(deviceappMap.get("asset_value").toString());
					gmsDevice.setNet_value(deviceappMap.get("net_value").toString());
					gmsDevice.setScrape_date(map.get("scrape_date").toString());
					if(map.get("dispose_method_flag").toString().equals("拍卖")){
						gmsDevice.setDispose_method_flag("0");
					}else if(map.get("dispose_method_flag").toString().equals("交回公司")){
						gmsDevice.setDispose_method_flag("1");
					}else if(map.get("dispose_method_flag").toString().equals("其他")){
						gmsDevice.setDispose_method_flag("2");
					}
					nodes.add(gmsDevice);
					count_success++;
				}else{
					count_error++;
				}
			}
			reqMsg.setValue("count_success", count_success);
			reqMsg.setValue("count_error", count_error);
			reqMsg.setValue("nodes", nodes);
		}
		
		System.out.println(dataList.size());
		return reqMsg;
	}
	/**
	 * 通过wsfile 解析excel 获取excel中的信息 用于附件导入设备使用
	 * 整体提交及审批业务时修改附件中的审批意见
	 */
	private List getAllExcelDataByWSFile(WSFile file) throws IOException,
			ExcelExceptionHandler {
		List dataList = new ArrayList();
		// String s = file.getFilename();
		if (file.getFilename().endsWith(".xlsx")
				|| file.getFilename().endsWith(".xls")) {
			InputStream is = new ByteArrayInputStream(file.getFileData());
			Workbook book = null;
			if (file.getFilename().endsWith(".xlsx")) {
				book = new XSSFWorkbook(is);
			} else {
				book = new HSSFWorkbook(is);
			}

			Sheet sheet0 = book.getSheetAt(0);
			int rows = sheet0.getPhysicalNumberOfRows();
			Row row = sheet0.getRow(0);
			for (int m = 1; m < rows; m++) {
				int columns = row.getPhysicalNumberOfCells();
				System.out.println(columns);
				Map mapColumnInfoIn = new HashMap();
				int blankflag = 0;
				for (int n = 0; n < columns; n++) {
					Cell cell = sheet0.getRow(m).getCell(n);
					if (cell == null) {
						mapColumnInfoIn.put(n, "");
					} else {
						int cellType = cell.getCellType();
						switch (cellType) {
						case 1:
							mapColumnInfoIn.put(n, cell.getStringCellValue());
							break;
						case 0:
							DecimalFormat df = new DecimalFormat("0");  
							String whatYourWant = df.format(cell.getNumericCellValue());  
							mapColumnInfoIn.put(n, whatYourWant);
							break;
						case 3:
							blankflag++;
							break;
						}
					}
					if (n == 4 && blankflag < 9) {
						Map map = new HashMap();
						map.put("dev_name", mapColumnInfoIn.get(0)==null?"":mapColumnInfoIn.get(0));
						map.put("dev_coding", mapColumnInfoIn.get(1)==null?"":mapColumnInfoIn.get(1));//ERP设备编码
						map.put("asset_coding", mapColumnInfoIn.get(2)==null?"":mapColumnInfoIn.get(2));//Amis资产编码
						map.put("scrape_type", mapColumnInfoIn.get(3)==null?"":mapColumnInfoIn.get(3));//
						map.put("bak", mapColumnInfoIn.get(4)==null?"":mapColumnInfoIn.get(4));
						/*map.put("sp_pass_flag", mapColumnInfoIn.get(5)==null?"":mapColumnInfoIn.get(5));//审批是否通过
						map.put("sp_bak", mapColumnInfoIn.get(6)==null?"":mapColumnInfoIn.get(6));//审批意见
*/						dataList.add(map);
					}
				}
				if (blankflag == 9)
					break;
			}
		}
		return dataList;
	}
	/**
	 *添加报废申请单所有信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeallProc(ISrvMsg isrvmsg) throws Exception {
//		1、基本
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//获得报废申请单名称
		String scrape_apply_name=isrvmsg.getValue("scrape_apply_name");
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		String apply_date=isrvmsg.getValue("apply_date");
		//生成基本信息
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String scrape_apply_no = isrvmsg.getValue("scrape_apply_no");
		long s_asset=0,e_asset=0,s_damage=0,e_damage=0;
		Date dt= new Date();
		//如果是新增操作
		if("null".equals(scrape_apply_id)){
			scrape_apply_no = CommonUtil.getScrapeAppNo();
			mainMap.put("scrape_apply_name", scrape_apply_name);
			mainMap.put("apply_date", apply_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("scrape_apply_no", scrape_apply_no);
			mainMap.put("create_date", currentdate);
			mainMap.put("creater", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//6.向数据库写入信息
			Serializable id=jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_APPLY");
			scrape_apply_id=id.toString();
		}
		//修改操作
		else
		{	
			mainMap.put("scrape_apply_id", scrape_apply_id);
			mainMap.put("scrape_apply_name", scrape_apply_name);
			mainMap.put("apply_date", apply_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("modify_date", currentdate);
			mainMap.put("updatetor", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//6.向数据库写入信息
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_APPLY");
		}
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		respMsg.setValue("scrape_apply_id", scrape_apply_id);
////////2、固有资产开始
		//报废申请
		String scrape_asset_id=isrvmsg.getValue("scrape_asset_id");// 报废固定资产ID
		List assetList = new ArrayList();
		//附件上传
		Boolean filesAssetflag = false;
		MQMsgImpl mqMsgAsset = (MQMsgImpl) isrvmsg;
		List<WSFile> filesAsset = mqMsgAsset.getFiles();
		try {
				//处理附件
				for (WSFile file : filesAsset) {
					String fileOrder = file.getKey().toString();
					if(fileOrder.equals("excel_content_asset")){
						filesAssetflag = true;
						String filename = file.getFilename();
						assetList = getAllExcelDataByWSFile(file);
						String queryAssetByAppIdSql="select * from dms_scrape_detailed detailed where detailed.SCRAPE_ASSET_ID is not null and detailed.scrape_apply_id='"+scrape_apply_id+"'";
						List<Map> list = new ArrayList<Map>();
						list = jdbcDao.queryRecords(queryAssetByAppIdSql);
						//对比提交申请的excel上传的数据与审批的excel的数据是否存在差异
						s_asset=new Date().getTime();
						for(int j = 0;j<assetList.size();j++){
							Map map = (Map)assetList.get(j);
							String dev_name = map.get("dev_name").toString();
							String dev_coding = map.get("dev_coding").toString();//ERP设备编码
							
							Map map1 = (Map)list.get(j);
							String dev_name1 = map1.get("dev_name").toString();
							String dev_coding1 = map1.get("dev_coding").toString();//ERP设备编码
							if(!dev_coding.equals(dev_coding1)){
								respMsg.setValue("flag_asset", "f");
								return respMsg;
							}
						}
						long systime = System.currentTimeMillis();
						e_asset=new Date().getTime();
						respMsg.setValue("time_asset",e_asset-s_asset);
						System.out.println("开始时间:"+s_asset+",结束时间:"+e_asset+",time:"+(e_asset-s_asset)+",系统时间:"+systime);
						MyUcm ucm = new MyUcm();
						String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
	
						Map doc = new HashMap();
						doc.put("file_name", filename);
						doc.put("file_type",fileOrder);
						doc.put("ucm_id", ucmDocId);
						doc.put("is_file", "1");
						doc.put("relation_id", scrape_apply_id);
						doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
						doc.put("create_date",currentdate);
						doc.put("creator_id",user.getUserId());
						doc.put("org_id", user.getOrgId());
						doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
						String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
						ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
						ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
						break;
					}
				}
			
		} catch (Exception e) {
			respMsg.setValue("flag_asset", "f");
		}
		//附件上传
		//固定资产报废台账信息保存
		Map<String,Object> assetMap = new HashMap<String,Object>();
		if(scrape_asset_id!=null&&scrape_asset_id!=""&&scrape_asset_id.length()>0)
		{
			assetMap.put("SCRAPE_ASSET_ID", scrape_asset_id);
			//删除之前的所有报废的设备信息,避免重复添加
			String deleteSql = "delete dms_scrape_detailed detailed where detailed.scrape_asset_id='"+scrape_asset_id+"'";
			jdbcDao.executeUpdate(deleteSql);
		}
		assetMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
		/*assetMap.put("ASSET_NOW_DESC", isrvmsg.getValue("asset_now_desc"));
		assetMap.put("SCRAPE_REASON", isrvmsg.getValue("scrape_reason"));
		assetMap.put("expert_desc", isrvmsg.getValue("expert_desc"));
		assetMap.put("EXPERT_LEADER",isrvmsg.getValue("expert_leader"));
		assetMap.put("EXPERT_MEMBERS",isrvmsg.getValue("expert_members"));
		assetMap.put("APPRAISAL_DATE",isrvmsg.getValue("appraisal_date"));*/
		assetMap.put("create_date", currentdate);
		assetMap.put("creater", user.getEmpId());
		assetMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
		Serializable id= jdbcDao.saveOrUpdateEntity(assetMap, "DMS_SCRAPE_ASSET");
		//如果上传的附件的话,调整添加设备的方式
		String  flag_asset = isrvmsg.getValue("flag_asset");
		if(filesAssetflag||flag_asset.equals("1")){
			//附件处理
			final List assetLists = assetList;
			JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
			String sql = "update DMS_SCRAPE_DETAILED set "
					+ "SCRAPE_APPLY_ID='"+scrape_apply_id+"',"
					+ "DEV_NAME =? , "
					+ "DEV_CODING =? , "
					+ "ASSET_CODING =? , "
					+ "ASSET_VALUE =? , "
					+ "DEV_SIGN =? , "
					+ "DEV_TYPE =? , "
					+ "LICENSE_NUM =? , "
					+ "PRODUCTING_DATE =? , "
					+ "SCRAPE_FLAG='0' , "
					+ "ORG_ID =? , "
					+ "bak1 =? , "
					+ "FOREIGN_DEV_ID =? , "
					+ "BSFLAG ='"+CommonConstants.BSFLAG_NORMAL+"',"
					+ "SP_PASS_FLAG = ? , "
					+ "SP_BAK1 = ?"
			+ " where SCRAPE_APPLY_ID='"+scrape_apply_id+"'"
			+" and SCRAPE_ASSET_ID='"+id.toString()+"'"
			+" and DEV_CODING=?";
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				public void setValues(PreparedStatement ps, int i) throws SQLException {
					Map map = null;
					try {
						map = (Map)assetLists.get(i);
					} catch (Exception e) {
					}
					String dev_name = map.get("dev_name").toString();
					String dev_coding = map.get("dev_coding").toString();//ERP设备编码
					String asset_coding = map.get("asset_coding").toString();//Amis资产编码
					String scrape_type = map.get("scrape_type").toString();//
					String bak = map.get("bak").toString();
					String sp_pass_flag = map.get("sp_pass_flag").toString();//审批意见
					String sp_bak = map.get("sp_bak").toString();//审批备注
					StringBuffer queryScrapeInfoSql = new StringBuffer();
					queryScrapeInfoSql.append("select * from (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) account where account.dev_coding='"+dev_coding+"'");
					Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
					if(deviceMap!=null){
						ps.setString(1, dev_name);
						ps.setString(2, dev_coding);
						ps.setString(3, asset_coding);
						ps.setString(4, (String) deviceMap.get("asset_value"));
						ps.setString(5, (String) deviceMap.get("dev_sign"));
						ps.setString(6,(String) deviceMap.get("dev_type"));
						ps.setString(7,(String) deviceMap.get("license_num"));
						ps.setString(8,(String) deviceMap.get("producting_date"));
						ps.setString(9,(String) deviceMap.get("owning_org_id"));
						ps.setString(10, bak);
						ps.setString(11, (String)deviceMap.get("dev_acc_id"));
						ps.setString(12, sp_pass_flag);
						ps.setString(13, sp_bak);
						ps.setString(14,dev_coding);
					}
				}
				public int getBatchSize() {
					return assetLists.size();
				}
			};

			jdbcTemplate.batchUpdate(sql, setter);
			/*for(int j = 0;j<assetList.size();j++){
				Map<String,Object> dataMap = new HashMap<String,Object>();
				Map map = (Map)assetList.get(j);
				String dev_name = map.get("dev_name").toString();
				String dev_coding = map.get("dev_coding").toString();//ERP设备编码
				String asset_coding = map.get("asset_coding").toString();//Amis资产编码
				String scrape_type = map.get("scrape_type").toString();//
				String bak = map.get("bak").toString();
				StringBuffer queryScrapeInfoSql = new StringBuffer();
				//queryScrapeInfoSql.append("select * from gms_device_account account where account.dev_acc_id='"+dev_id+"'");
				queryScrapeInfoSql.append("select * from (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) account where account.dev_coding='"+dev_coding+"'");
				Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
				if(deviceMap!=null)
				{
					//报废申请单ID
					dataMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
					//报废设备类型
//					dataMap.put("SCRAPE_TYPE", isrvmsg.getValue("scrape_type_asset"+par[i]));
					//设备名称
					dataMap.put("DEV_NAME",dev_name);
					//规格型号
//					dataMap.put("DEV_MODEL",deviceMap.get("dev_model"));
					//ERP设备编码
					dataMap.put("DEV_CODING",dev_coding);
					//固定资产编号
					dataMap.put("ASSET_CODING",asset_coding);
					//设备原值
					dataMap.put("ASSET_VALUE",deviceMap.get("asset_value"));
					//实物标记号
					dataMap.put("DEV_SIGN",deviceMap.get("dev_sign"));
					//设备编号
					dataMap.put("DEV_TYPE",deviceMap.get("dev_type"));
					//牌照号
					dataMap.put("LICENSE_NUM",deviceMap.get("license_num"));
					//投产日期
					dataMap.put("PRODUCTING_DATE",deviceMap.get("producting_date"));
					//报废标示
					dataMap.put("SCRAPE_FLAG","0");
					//所属机构
					dataMap.put("ORG_ID",deviceMap.get("owning_org_id"));
					//备注
					dataMap.put("bak1", bak);
					//固定资产申请ID
					dataMap.put("SCRAPE_ASSET_ID", id.toString());
					//设备台账ID
					//dataMap.put("FOREIGN_DEV_ID",dev_id);
					dataMap.put("FOREIGN_DEV_ID",deviceMap.get("dev_acc_id"));
					dataMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
					jdbcDao.saveOrUpdateEntity(dataMap, "DMS_SCRAPE_DETAILED");
				}
			}*/
		}else{
			//添加报废设备数量
			int count = Integer.parseInt(isrvmsg.getValue("colnum"));
			String parmeter=isrvmsg.getValue("parmeter");
		    String par[]=parmeter.split(",");
			for(int i=0;i<=count;i++)
			{
				Map<String,Object> dataMap = new HashMap<String,Object>();
				//获取设备台账的ID
				//String dev_id=isrvmsg.getValue("detdev_ci_code_asset"+par[i]);
				//erp编号
				String dev_coding=isrvmsg.getValue("dev_coding_asset"+par[i]);
				//设备台账ID查询设备相关信息
				StringBuffer queryScrapeInfoSql = new StringBuffer();
				//queryScrapeInfoSql.append("select * from gms_device_account account where account.dev_acc_id='"+dev_id+"'");
				queryScrapeInfoSql.append("select * from (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) account where account.dev_coding='"+dev_coding+"'");
				Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
				if(deviceMap!=null)
				{
					//报废申请单ID
					dataMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
					//报废设备类型
					dataMap.put("SCRAPE_TYPE", isrvmsg.getValue("scrape_type_asset"+par[i]));
					//设备名称
					dataMap.put("DEV_NAME",deviceMap.get("dev_name"));
					//规格型号
					dataMap.put("DEV_MODEL",deviceMap.get("dev_model"));
					//ERP设备编码
					dataMap.put("DEV_CODING",dev_coding);
					//固定资产编号
					dataMap.put("ASSET_CODING",deviceMap.get("asset_coding"));
					//设备原值
					dataMap.put("ASSET_VALUE",deviceMap.get("asset_value"));
					//设备净值
					dataMap.put("NET_VALUE",deviceMap.get("net_value"));
					//实物标记号
					dataMap.put("DEV_SIGN",deviceMap.get("dev_sign"));
					//设备编号
					dataMap.put("DEV_TYPE",deviceMap.get("dev_type"));
					//牌照号
					dataMap.put("LICENSE_NUM",deviceMap.get("license_num"));
					//投产日期
					dataMap.put("PRODUCTING_DATE",deviceMap.get("producting_date"));
					//报废标示
					dataMap.put("SCRAPE_FLAG","0");
					//所属机构
					dataMap.put("ORG_ID",deviceMap.get("owning_org_id"));
					//备注
					dataMap.put("bak1", isrvmsg.getValue("bak_asset"+par[i]));
					//审批结果
					dataMap.put("sp_pass_flag", isrvmsg.getValue("sp_pass_flag"+par[i]));
					//审批备注
					dataMap.put("sp_bak1", isrvmsg.getValue("sp_bak_asset"+par[i]));
					//固定资产申请ID
					dataMap.put("SCRAPE_ASSET_ID", id.toString());
					//设备台账ID
					//dataMap.put("FOREIGN_DEV_ID",dev_id);
					dataMap.put("FOREIGN_DEV_ID",deviceMap.get("dev_acc_id"));
					dataMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
					jdbcDao.saveOrUpdateEntity(dataMap, "DMS_SCRAPE_DETAILED");
				}
			}
		}
////////2、固有资产结束
////////3、毁损开始
		//报废申请
		String scrape_damage_id=isrvmsg.getValue("scrape_damage_id");// 报废盘亏亏损ID
		List damageList = new ArrayList();
		//附件上传
		Boolean filesDamageflag = false;
		String specialized_unit_flag=isrvmsg.getValue("specialized_unit_flag");// 专业化服务单位设备
		String else_unit_flag=isrvmsg.getValue("else_unit_flag");// 其他单位设备
		Map<String,Object> damageMap = new HashMap<String,Object>();
		//上传附件
		MQMsgImpl mqMsg = (MQMsgImpl) isrvmsg;
		List<WSFile> files = mqMsg.getFiles();
		//证明材料
		String proof_file=isrvmsg.getValue("proof_file");
		//赔付证明
		String payment_proof_file=isrvmsg.getValue("payment_proof_file");
		//责任人处理
		String dev_photo_file=isrvmsg.getValue("dev_photo_file");
		//毁损照片
		String person_handling_file=isrvmsg.getValue("person_handling_file");
		
		String doc_content_damage=isrvmsg.getValue("doc_content_damage");
		if(proof_file!=null)
		{
			proof_file=jdbcDao.generateUUID();
			assetMap.put("proof_file", proof_file);
		}
		if(payment_proof_file!=null)
		{
			payment_proof_file=jdbcDao.generateUUID();
			assetMap.put("payment_proof_file", payment_proof_file);
		}
		if(dev_photo_file!=null)
		{
			dev_photo_file=jdbcDao.generateUUID();
			assetMap.put("dev_photo_file", dev_photo_file);
		}
		if(person_handling_file!=null)
		{
			person_handling_file=jdbcDao.generateUUID();
			assetMap.put("person_handling_file", person_handling_file);
		}
		if(doc_content_damage!=null)
		{
			doc_content_damage=jdbcDao.generateUUID();
			assetMap.put("doc_content_damage", doc_content_damage);
		}
		try {
				//处理附件
				for (WSFile file : files) {
					String filename = file.getFilename();
					String fileOrder = file.getKey().toString();
					if(fileOrder.equals("excel_content_asset")){
						continue;
					}else if(fileOrder.equals("excel_content_damage")){
						filesDamageflag = true;
						damageList = getAllExcelDataByWSFile(file);
						String queryDamageByAppIdSql="select * from dms_scrape_detailed detailed where detailed.SCRAPE_DAMAGE_ID is not null and detailed.scrape_apply_id='"+scrape_apply_id+"'";
						List<Map> list = new ArrayList<Map>();
						list = jdbcDao.queryRecords(queryDamageByAppIdSql);
						//对比提交申请的excel上传的数据与审批的excel的数据是否存在差异
						s_damage = new Date().getTime();
						for(int j = 0;j<damageList.size();j++){
							Map map = (Map)damageList.get(j);
							String dev_name = map.get("dev_name").toString();
							String dev_coding = map.get("dev_coding").toString();//ERP设备编码
							
							Map map1 = (Map)list.get(j);
							String dev_name1 = map1.get("dev_name").toString();
							String dev_coding1 = map1.get("dev_coding").toString();//ERP设备编码
							if(!dev_coding.equals(dev_coding1)){
								respMsg.setValue("flag_damage", "f");
								return respMsg;
							}
						}
						e_damage=new Date().getTime();
						respMsg.setValue("time_damage",e_damage-s_damage);
					}else if(fileOrder.split("__").length>1){
						continue;
					}
					MyUcm ucm = new MyUcm();
					String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
					Map doc = new HashMap();
					if(fileOrder.equals("proof_file_"))
					{
						fileOrder=proof_file;
					}
					if(fileOrder.equals("payment_proof_file_"))
					{
						fileOrder=payment_proof_file;
					}
					if(fileOrder.equals("dev_photo_file_"))
					{
						fileOrder=dev_photo_file;
					}
					if(fileOrder.equals("person_handling_file_"))
					{
						fileOrder=person_handling_file;
					}
					doc.put("relation_id", scrape_apply_id);
					doc.put("file_name", filename);
					doc.put("file_type",fileOrder);
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("create_date",currentdate);
					doc.put("creator_id",user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
	/*				//只有在新增文件时才写历史 
					if((StringUtils.isEmpty(isrvmsg.getValue("paper_id"))) ){
					
					}*/
				}
			
		} catch (Exception e) {
			respMsg.setValue("flag_damage", "f");
		}
		

		//固定资产报废台账信息保存
		if(scrape_damage_id!=null)
		{
		if(scrape_damage_id!=""&&scrape_damage_id.length()>0)
		{
			assetMap.put("SCRAPE_DAMAGE_ID", scrape_damage_id);
			//删除之前的所有报废的设备信息,避免重复添加
			String deleteSql = "delete dms_scrape_detailed detailed where detailed.scrape_damage_id='"+scrape_damage_id+"'";
			jdbcDao.executeUpdate(deleteSql);
		}
		}
		assetMap.put("specialized_unit_flag", specialized_unit_flag);
		assetMap.put("else_unit_flag", else_unit_flag);
		assetMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
		assetMap.put("LOSS_REASON", isrvmsg.getValue("loss_reason"));
		assetMap.put("create_date", currentdate);
		assetMap.put("creater", user.getEmpId());
		assetMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
		Serializable idDamage= jdbcDao.saveOrUpdateEntity(assetMap, "DMS_SCRAPE_DAMAGE");
		
		String  flag_damage = isrvmsg.getValue("flag_damage");
		if(filesDamageflag||flag_damage.equals("1")){
			//附件处理
			for(int j = 0;j<damageList.size();j++){
				Map<String,Object> dataMap = new HashMap<String,Object>();
				Map map = (Map)damageList.get(j);
				String dev_name = map.get("dev_name").toString();
				String dev_coding = map.get("dev_coding").toString();//ERP设备编码
				String asset_coding = map.get("asset_coding").toString();//Amis资产编码
				String scrape_type = map.get("scrape_type").toString();//
				String bak = map.get("bak").toString();
				StringBuffer queryScrapeInfoSql = new StringBuffer();
				//queryScrapeInfoSql.append("select * from gms_device_account account where account.dev_acc_id='"+dev_id+"'");
				queryScrapeInfoSql.append("select * from (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) account where account.dev_coding='"+dev_coding+"'");
				Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
				if(deviceMap!=null)
				{
					//报废申请单ID
					dataMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
					//报废设备类型
	//					dataMap.put("SCRAPE_TYPE", isrvmsg.getValue("scrape_type_damage"+par[i]));
					//设备名称
					dataMap.put("DEV_NAME",dev_name);
					//规格型号
	//					dataMap.put("DEV_MODEL",deviceMap.get("dev_model"));
					//ERP设备编码
					dataMap.put("DEV_CODING",dev_coding);
					//固定资产编号
					dataMap.put("ASSET_CODING",asset_coding);
					//设备原值
					dataMap.put("ASSET_VALUE",deviceMap.get("asset_value"));
					//设备净值
					dataMap.put("NET_VALUE",deviceMap.get("net_value"));
					//实物标记号
					dataMap.put("DEV_SIGN",deviceMap.get("dev_sign"));
					//设备编号
					dataMap.put("DEV_TYPE",deviceMap.get("dev_type"));
					//牌照号
					dataMap.put("LICENSE_NUM",deviceMap.get("license_num"));
					//投产日期
					dataMap.put("PRODUCTING_DATE",deviceMap.get("producting_date"));
					//报废标示
					dataMap.put("SCRAPE_FLAG","0");
					//所属机构
					dataMap.put("ORG_ID",deviceMap.get("owning_org_id"));
					//备注
					dataMap.put("bak1", bak);
					//固定资产申请ID
					dataMap.put("SCRAPE_DAMAGE_ID", idDamage.toString());
					//设备台账ID
					//dataMap.put("FOREIGN_DEV_ID",dev_id);
					dataMap.put("FOREIGN_DEV_ID",deviceMap.get("dev_acc_id"));
					dataMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
					jdbcDao.saveOrUpdateEntity(dataMap, "DMS_SCRAPE_DETAILED");
				}
			}
		}else{
		//添加报废设备数量
		int countDamange = Integer.parseInt(isrvmsg.getValue("colnumdamage"));
		String parmeterDamage=isrvmsg.getValue("parmeterdamage");
	    String parDamage[]=parmeterDamage.split(",");
		for(int i=0;i<=countDamange;i++)
		{
			Map<String,Object> dataMap = new HashMap<String,Object>();
			//获取设备台账的ID
			//String dev_id=isrvmsg.getValue("detdev_ci_code_damage"+parDamage[i]);
			//erp编号
			String dev_coding=isrvmsg.getValue("dev_coding_damage"+parDamage[i]);
			//设备台账ID查询设备相关信息
			StringBuffer queryScrapeInfoSql = new StringBuffer();
			//queryScrapeInfoSql.append("select * from gms_device_account account where account.dev_acc_id='"+dev_id+"'");
			queryScrapeInfoSql.append("select * from (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) account where account.dev_coding='"+dev_coding+"'");
			Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
			if(deviceMap!=null)
			{
				//报废申请单ID
				dataMap.put("SCRAPE_APPLY_ID", scrape_apply_id);
				//报废设备类型
				dataMap.put("SCRAPE_TYPE", isrvmsg.getValue("scrape_type_damage"+parDamage[i]));
				//设备名称
				dataMap.put("DEV_NAME",deviceMap.get("dev_name"));
				//规格型号
				dataMap.put("DEV_MODEL",deviceMap.get("dev_model"));
				//ERP设备编码
				dataMap.put("DEV_CODING",dev_coding);
				//固定资产编号
				dataMap.put("ASSET_CODING",deviceMap.get("asset_coding"));
				//设备原值
				dataMap.put("ASSET_VALUE",deviceMap.get("asset_value"));
				//设备原值
				dataMap.put("NET_VALUE",deviceMap.get("net_value"));
				//实物标记号
				dataMap.put("DEV_SIGN",deviceMap.get("dev_sign"));
				//设备编号
				dataMap.put("DEV_TYPE",deviceMap.get("dev_type"));
				//牌照号
				dataMap.put("LICENSE_NUM",deviceMap.get("license_num"));
				//投产日期
				dataMap.put("PRODUCTING_DATE",deviceMap.get("producting_date"));
				//报废标示
				dataMap.put("SCRAPE_FLAG","0");
				//所属机构
				dataMap.put("ORG_ID",deviceMap.get("owning_org_id"));
				//备注
				dataMap.put("bak1", isrvmsg.getValue("bak_damage"+parDamage[i]));
				//固定资产申请ID
				dataMap.put("SCRAPE_DAMAGE_ID", idDamage.toString());
				//设备台账ID
				//dataMap.put("FOREIGN_DEV_ID",dev_id);
				dataMap.put("FOREIGN_DEV_ID",deviceMap.get("dev_acc_id"));
				dataMap.put("BSFLAG",CommonConstants.BSFLAG_NORMAL);
				jdbcDao.saveOrUpdateEntity(dataMap, "DMS_SCRAPE_DETAILED");
			}
		}
		}
////////3、毁损结束
////////4、其他开始
		//其他说明
		String bak=isrvmsg.getValue("bak");
		//多附件
			mainMap.put("scrape_apply_id", scrape_apply_id);
			mainMap.put("bak", bak);
			mainMap.put("modify_date", currentdate);
			mainMap.put("updatetor", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//6.向数据库写入信息
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_APPLY");
			
			MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
			
			List<WSFile> filesOther = mqMsgOther.getFiles();
			try {
					//处理附件
					for (WSFile file : filesOther) {
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
						doc.put("relation_id", scrape_apply_id);
						doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
						doc.put("create_date",currentdate);
						doc.put("creator_id",user.getUserId());
						doc.put("org_id", user.getOrgId());
						doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
						String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
						ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
						ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
		/*				//只有在新增文件时才写历史 
						if((StringUtils.isEmpty(isrvmsg.getValue("paper_id"))) ){
							
						
						}*/
					}
				
			} catch (Exception e) {
				
			}
		return respMsg;
	}
	/**
	 * 查询报废汇总列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapeCollectList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String scrape_collect_name = isrvmsg.getValue("scrape_collect_name");// 报废申请单名称
		String scrape_collect_no = isrvmsg.getValue("scrape_collect_no");// 报废申请单号
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,emp.employee_name,org.org_name as org_name ");
		querySql.append(" from dms_scrape_collect t");
		querySql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		querySql.append(" left join comm_org_information org on t.scrape_org_id = org.org_id  where t.bsflag='0' ");
		// 申请单名称
		if (StringUtils.isNotBlank(scrape_collect_name)) {
			querySql.append(" and t.scrape_collect_name  like '"+scrape_collect_name+"%'");
		}
		// 申请单号
		if (StringUtils.isNotBlank(scrape_collect_no)) {
			querySql.append(" and t.scrape_collect_no  like '"+scrape_collect_no+"%'");
		}
		//如果是超级管理员的话不做所属单位数据筛选，查询全部的单位数据
		if(!user.getOrgCode().equals("C105")){
			querySql.append(" and t.scrape_org_id ='"+user.getOrgId()+"'");
		}
		//添加排序
		querySql.append(" order by t.create_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询报废申请单信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg getDmsScrapeApplyInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String ids = msg.getValue("ids");
		String querysgllSql = "select * from (select t.*, t2.proc_status apply_status,emp.employee_name,org.org_name as org_name  from dms_scrape_apply t "
				+ "left join common_busi_wf_middle t2 on t.scrape_apply_id = t2.business_id and t2.bsflag = '0' "
				+ "left join comm_human_employee emp on t.employee_id = emp.employee_id   "
				+ "left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag = '0') pp "
				+ "where pp.apply_status = '3' and pp.scrape_apply_id in ("+ids + ") ";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	/**
	 *添加报废申请单所有信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeallCollect(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//获得报废申请单名称
		String scrape_collect_name=isrvmsg.getValue("scrape_collect_name");
		//报废汇总单ID
		String scrape_collect_id=isrvmsg.getValue("scrape_collect_id");
		//汇总时间
		String collect_date=isrvmsg.getValue("apply_date");
		//生成基本信息
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		//报废汇总单号
		String scrape_collect_no = "";
		//备注
		String bak=isrvmsg.getValue("bak");
		//专家组
		String experts=isrvmsg.getValue("experts");
		String scrape_type=isrvmsg.getValue("scrape_type");
		String flag=isrvmsg.getValue("flag");//判断是修改还是添加
		
		//1、报废汇总主表操作增加或修改
		if("add".equals(flag)){
			scrape_collect_no = CommonUtil.getScrapeCollectNo();
			mainMap.put("scrape_collect_name", scrape_collect_name);
			mainMap.put("collect_date", collect_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("scrape_collect_no", scrape_collect_no);
			mainMap.put("create_date", currentdate);
			mainMap.put("creater", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			mainMap.put("bak", bak);
			mainMap.put("experts", experts);
			mainMap.put("scrape_collect_id", scrape_collect_id);
			jdbcDao.saveEntity(mainMap, "DMS_SCRAPE_COLLECT");
			//scrape_collect_id=id.toString();
		}else{
			mainMap.put("scrape_collect_id", scrape_collect_id);
			mainMap.put("scrape_collect_name", scrape_collect_name);
			mainMap.put("collect_date", collect_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("modify_date", currentdate);
			mainMap.put("updatetor", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			mainMap.put("bak", bak);
			mainMap.put("experts", experts);
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_COLLECT");
		}
		
		//2、建立汇总表与申请表的关联
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		Map<String,Object> ApplyMap = new HashMap<String,Object>();
		String applyIdsql = "select SCRAPE_APPLY_ID from dms_scrape_apply app where app.scrape_collect_id='"+scrape_collect_id+"'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(applyIdsql);
		if(null==scrape_apply_id){
			scrape_apply_id="";
		}else{
			scrape_apply_id+=",";
		}
		if(list.size()>0){
			for(int j=0;j<list.size();j++)
			scrape_apply_id+=list.get(j).get("scrape_apply_id")+",";
		}
		if(scrape_apply_id.length()==0){
			scrape_apply_id=",";
		}
		scrape_apply_id = scrape_apply_id.replace("'", "");
		String sub[] = scrape_apply_id.substring(0, scrape_apply_id.length()-1).split(",");
		for(int i=0;i<sub.length;i++){
			ApplyMap.put("scrape_collect_id", scrape_collect_id.toString());
			ApplyMap.put("SCRAPE_APPLY_ID", sub[i].toString());
			ApplyMap.put("scrape_collect_flag", "1");
			jdbcDao.saveOrUpdateEntity(ApplyMap, "DMS_SCRAPE_APPLY");
		}
	 
		
		//设备台账详情表操作
		int devCount = Integer.parseInt(isrvmsg.getValue("devCount"));//设备的数量
		List<Map> listMap = new ArrayList<Map>();
		for(int i = 0;i<devCount;i++){
			Map map =new HashMap();
			map.put("org_name",isrvmsg.getValue("org_name"+i));//申请单位
			map.put("dev_name",isrvmsg.getValue("dev_name"+i));//设备名称
			map.put("dev_type",isrvmsg.getValue("dev_type"+i));//设备类别
			map.put("sp_pass_flag",isrvmsg.getValue("sp_pass_flag"+i));//是否通过
			map.put("scrape_type", isrvmsg.getValue("scrape_type"+i));//报废类型
			map.put("project_name1", isrvmsg.getValue("project_name"+i));//项目名和国家名project_name0
			map.put("duty_unit", isrvmsg.getValue("duty_unit"+i));//责任单位
			System.out.println(isrvmsg.getValue("project_name"+i)+"xxxxxxxxxxxxxxxxxxxxxxxxx");
			if(isrvmsg.getValue("sp_pass_flag"+i).equals("1")){
				map.put("bsflag","1");//删除标识 0 正常 1删除
			}else{
				map.put("bsflag","0");//删除标识 0 正常 1删除
			}
			map.put("sp_bak1",isrvmsg.getValue("sp_bak1"+i)==null?"":isrvmsg.getValue("sp_bak1"+i));//意见
			String time =isrvmsg.getValue("times"+i);//时间段
			if("八年及以上".equals(time)){//<time_end  >=time_start
				map.put("time_start",8);
				map.put("time_end",100);
			}else if("五年到八年".equals(time)){
				map.put("time_start",5);
				map.put("time_end",8);
			}else if("三年到五年".equals(time)){
				map.put("time_start",3);
				map.put("time_end",5);
			}else if("一年到三年".equals(time)){
				map.put("time_start",1);
				map.put("time_end",3);
			}else if("一年以内".equals(time)){
				map.put("time_start",0);
				map.put("time_end",1);
			}
			listMap.add(map);
		}
		final List<Map> listMaps =listMap;
		for(int i = 0;i<sub.length;i++){
			JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
			String sql = "update DMS_SCRAPE_DETAILED set "
					+ "SP_PASS_FLAG = ? , "
					+ "SP_BAK1 = ? , "
					+ "BSFLAG = ? "
			+ " where SCRAPE_APPLY_ID ='"+sub[i]+"'"
			+" and SCRAPE_APPLY_ID in( select SCRAPE_APPLY_ID from dms_scrape_apply app where app.scrape_org_id in(select org.org_id from comm_org_information org where org.org_name=?)) "
			+" and dev_name=? "
			+" and dev_type=? "
			//+" and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=?"
			//+" and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')<?"
			+" and SCRAPE_TYPE=? and project_name=? and duty_unit=?";
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				public void setValues(PreparedStatement ps, int a) throws SQLException {
						ps.setString(1, listMaps.get(a).get("sp_pass_flag").toString());
						ps.setString(2, listMaps.get(a).get("sp_bak1").toString());//意见
						ps.setString(3, listMaps.get(a).get("bsflag").toString());//删除标识 1删除 0正常
						ps.setString(4, listMaps.get(a).get("org_name").toString());//申请单位
						ps.setString(5, listMaps.get(a).get("dev_name").toString());//设备名称
						ps.setString(6, listMaps.get(a).get("dev_type").toString());//设备类别
						//ps.setString(7, listMaps.get(a).get("time_start").toString());//设备名称
						//ps.setString(8, listMaps.get(a).get("time_end").toString());//设备类别
						ps.setString(7, listMaps.get(a).get("scrape_type").toString());//报废类型
						ps.setString(8, listMaps.get(a).get("project_name1").toString());//项目名
						ps.setString(9, listMaps.get(a).get("duty_unit").toString());//责任单位
				}
				public int getBatchSize() {
					return listMaps.size();
				}
			};
			jdbcTemplate.batchUpdate(sql, setter);
		}
		//多附件
		MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
		List<WSFile> filesOther = mqMsgOther.getFiles();
		try {
			//处理附件
			for (WSFile file : filesOther) {
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
				doc.put("relation_id", scrape_collect_id);
				doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
				doc.put("create_date",currentdate);
				doc.put("creator_id",user.getUserId());
				doc.put("org_id", user.getOrgId());
				doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
				ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
				ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
			}
		} catch (Exception e) {
		}
		 
		System.out.println(scrape_collect_id+"xxxxxxxxxxxxxxx");
		respMsg.setValue("scrape_collect_id", scrape_collect_id);//返回汇总单ID
		return respMsg;
	}/**
	 *添加报废申请单所有信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeallCollectNew(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//获得报废申请单名称
		String scrape_collect_name=isrvmsg.getValue("scrape_collect_name");
		//报废汇总单ID
		String scrape_collect_id=isrvmsg.getValue("scrape_collect_id");
		//汇总时间
		String collect_date=isrvmsg.getValue("apply_date");
		//生成基本信息
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		//报废汇总单号
		String scrape_collect_no = "";
		//备注
		String bak=isrvmsg.getValue("bak");
		//专家组
		String experts=isrvmsg.getValue("experts");
		String scrape_type=isrvmsg.getValue("scrape_type");
		String flag=isrvmsg.getValue("flag");//判断是修改还是添加
		
		//1、报废汇总主表操作增加或修改
		if("add".equals(flag)){
			scrape_collect_no = CommonUtil.getScrapeCollectNo();
			mainMap.put("scrape_collect_name", scrape_collect_name);
			mainMap.put("collect_date", collect_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("scrape_collect_no", scrape_collect_no);
			mainMap.put("create_date", currentdate);
			mainMap.put("creater", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			mainMap.put("bak", bak);
			mainMap.put("experts", experts);
			mainMap.put("scrape_collect_id", scrape_collect_id);
			jdbcDao.saveEntity(mainMap, "DMS_SCRAPE_COLLECT");
			//scrape_collect_id=id.toString();
		}else{
			mainMap.put("scrape_collect_id", scrape_collect_id);
			mainMap.put("scrape_collect_name", scrape_collect_name);
			mainMap.put("collect_date", collect_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("modify_date", currentdate);
			mainMap.put("updatetor", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			mainMap.put("bak", bak);
			mainMap.put("experts", experts);
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_COLLECT");
		}
		
		//2、建立汇总表与申请表的关联
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		Map<String,Object> ApplyMap = new HashMap<String,Object>();
		String applyIdsql = "select SCRAPE_APPLY_ID from dms_scrape_apply app where app.scrape_collect_id='"+scrape_collect_id+"'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(applyIdsql);
		if(null==scrape_apply_id){
			scrape_apply_id="";
		}else{
			scrape_apply_id+=",";
		}
		if(list.size()>0){
			for(int j=0;j<list.size();j++)
			scrape_apply_id+=list.get(j).get("scrape_apply_id")+",";
		}
		if(scrape_apply_id.length()==0){
			scrape_apply_id=",";
		}
		scrape_apply_id = scrape_apply_id.replace("'", "");
		String sub[] = scrape_apply_id.substring(0, scrape_apply_id.length()-1).split(",");
		for(int i=0;i<sub.length;i++){
			ApplyMap.put("scrape_collect_id", scrape_collect_id.toString());
			ApplyMap.put("SCRAPE_APPLY_ID", sub[i].toString());
			ApplyMap.put("scrape_collect_flag", "1");
			jdbcDao.saveOrUpdateEntity(ApplyMap, "DMS_SCRAPE_APPLY");
		}
	 
		
		 
		//多附件
		MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
		List<WSFile> filesOther = mqMsgOther.getFiles();
		try {
			//处理附件
			for (WSFile file : filesOther) {
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
				doc.put("relation_id", scrape_collect_id);
				doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
				doc.put("create_date",currentdate);
				doc.put("creator_id",user.getUserId());
				doc.put("org_id", user.getOrgId());
				doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
				ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
				ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
			}
		} catch (Exception e) {
		}
		 
		System.out.println(scrape_collect_id+"xxxxxxxxxxxxxxx");
		respMsg.setValue("scrape_collect_id", scrape_collect_id);//返回汇总单ID
		return respMsg;
	}
	/**
	 * 查询报废汇总单时间 判断哪个页面显示
	 */
	public ISrvMsg getScrapeCollectDate(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_collect_id=isrvmsg.getValue("scrape_collect_id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select case when sysdate-to_date('2018-01-01','yyyy-MM-dd')>0 then '1' else  '0'  end day from dms_scrape_collect where scrape_collect_id = '"+scrape_collect_id+"'");
		Map map=jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		responseDTO.setValue("result", map.get("day").toString());
		return responseDTO;
	}
	/**
	 * 查询报废汇总单状态
	 */
	public ISrvMsg getScrapeCollectState(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_collect_id=isrvmsg.getValue("scrape_collect_id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select devapp.scrape_collect_id, nvl(wfmiddle.proc_status, '') as proc_status  from dms_scrape_collect devapp ");
		queryScrapeInfoSql.append(" left join common_busi_wf_middle wfmiddle on devapp.scrape_collect_id = wfmiddle.business_id ");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			queryScrapeInfoSql.append(" and scrape_collect_id  = '"+scrape_collect_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		
		StringBuffer queryReportSql = new StringBuffer();
		queryReportSql.append("select * from DMS_SCRAPE_APPLY where scrape_collect_id  = '"+scrape_collect_id+"' and SCRAPE_REPORT_ID is not null");
		List<Map> list = jdbcDao.queryRecords(queryReportSql.toString());
		if(list.size()>0){
			responseDTO.setValue("flag", 1);
		}else{
			responseDTO.setValue("flag", 0);
		}
		return responseDTO;
	}
	/**
	 * 查询申请单报废信息
	 * 
	 */
	public ISrvMsg getScrapeCollectInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		String scrape_collect_id=isrvmsg.getValue("scrape_collect_id");// 报废汇总单ID
		queryScrapeInfoSql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name ");
		queryScrapeInfoSql.append(" from dms_scrape_collect t  left join common_busi_wf_middle t2 on t.scrape_collect_id=t2.business_id  and t2.bsflag='0'  ");
		queryScrapeInfoSql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		queryScrapeInfoSql.append(" left join comm_org_information org on t.scrape_org_id = org.org_id  where t.bsflag='0' ");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			queryScrapeInfoSql.append(" and t.scrape_collect_id  = '"+scrape_collect_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	/**
	 * 删除报废申请单
	 * 2017年8月16日10:22:25 修改，删除时，一并清除其绑定的报废申请中的scrape_collect_id和scrape_collect_flag的值
	 */
	public ISrvMsg deleteScrapeCollectInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String scrape_collect_id=isrvmsg.getValue("scrape_collect_id");// 报废申请单ID
		Map<String,Object> mainMap = new HashMap<String,Object>();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		mainMap.put("employee_id", user.getEmpId());
		mainMap.put("scrape_org_id", user.getOrgId());
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updatetor", user.getEmpId());
		mainMap.put("scrape_collect_id", scrape_collect_id);
		mainMap.put("bsflag", CommonConstants.BSFLAG_DELETE);
		String updateApplySql="update dms_scrape_apply set scrape_collect_flag = null,scrape_collect_id = null  where scrape_collect_id='"+scrape_collect_id+"'";
		jdbcDao.executeUpdate(updateApplySql);
		//6.向数据库写入信息
		jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_COLLECT");
		return responseDTO;
	}
	/**
	 * 查询报废申请单是否添加设备报废明细信息
	 */
	
	public ISrvMsg getScrapeCollectDetail(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_collect_id=isrvmsg.getValue("scrape_collect_id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select count(1) as result from dms_scrape_detailed where BSFLAG='0'");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			queryScrapeInfoSql.append(" and scrape_apply_id  in (select scrape_apply_id from  dms_scrape_apply where scrape_collect_id='"+scrape_collect_id+"')");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	/**
	 * 查询报废申请盘亏信息
	 * 查询报废申请固定资产信息 综合方法
	 */
	public ISrvMsg getScrapeCollectAllInfoNew(ISrvMsg msg)throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废汇总单号
		String scrape_collect_id=msg.getValue("scrape_collect_id");
		
		//汇总主题信息
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name ");
		queryScrapeInfoSql.append(" from dms_scrape_collect t  left join common_busi_wf_middle t2 on t.scrape_collect_id=t2.business_id  and t2.bsflag='0'  ");
		queryScrapeInfoSql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		queryScrapeInfoSql.append(" left join comm_org_information org on t.scrape_org_id = org.org_id  where t.bsflag='0' ");
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			queryScrapeInfoSql.append(" and t.scrape_collect_id  = '"+scrape_collect_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		
		//关联的报废申请单设备信息
		String queryApplySql= "select * from (select t.*, t2.proc_status apply_status,emp.employee_name,org.org_name as org_name  from dms_scrape_apply t "
				+ "left join common_busi_wf_middle t2 on t.scrape_apply_id = t2.business_id and t2.bsflag = '0' "
				+ "left join comm_human_employee emp on t.employee_id = emp.employee_id   "
				+ "left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag = '0') pp "
				+ "where pp.apply_status = '3' and pp.scrape_collect_id  ='"+scrape_collect_id+"'";
		List<Map> listApply = new ArrayList<Map>();
		listApply = jdbcDao.queryRecords(queryApplySql);
		responseDTO.setValue("datasApply", listApply);
		
		String querysgllSql = "select file_name, coding_code_id, '(' || scrape_type || ')' || sum(count1) || '条' as code_name, duty_unit, scrape_apply_id, file_type, sum(asset_value) asset_value, sum(net_value) net_value from(select count(distinct mm.dev_coding) count1, wm_concat(distinct mm.file_id || '&' || mm.file_name) as file_name, case when wm_concat(distinct doc_common) = '0' then '正常报废' when wm_concat(distinct doc_common) = '1' then '技术淘汰' when wm_concat(distinct doc_common) = '2' then '毁损' else '盘亏' end scrape_type, wm_concat(distinct doc_common) coding_code_id, wm_concat(distinct duty_unit) duty_unit, wm_concat(distinct scrape_apply_id) scrape_apply_id, wm_concat(distinct file_type) file_type, sum(asset_value) asset_value, sum(net_value) net_value from(select distinct (t.dev_coding), t.dev_name, t.dev_type, t.scrape_detailed_id, orgsubidtoname(i.org_subjection_id) duty_unit, t.scrape_apply_id, case when t.scrape_type = '0' or t.scrape_type = '1' then (select sa.expert_leader from DMS_SCRAPE_ASSET sa where sa.scrape_apply_id = t.scrape_apply_id) else (select sd.expert_leader from dms_scrape_damage sd where sd.scrape_apply_id = t.scrape_apply_id) end employee_name, filelink.file_id, filelink.file_name, filelink.doc_common, filelink.file_type, t.asset_value,t.net_value from dms_scrape_detailed t inner join comm_org_subjection i on t.org_id = i.org_id and i.bsflag = '0' left join (select bdgf.*, files.scrape_detailed_id from dms_scrape_detailed_link_file files, bgp_doc_gms_file bdgf where files.file_id = bdgf.file_id and bdgf.bsflag = '0') filelink on t.scrape_detailed_id = filelink.scrape_detailed_id where t.bsflag='0' and t.scrape_apply_id in (select scrape_apply_id from dms_scrape_apply app where app.scrape_collect_id='"+scrape_collect_id+"') order by t.dev_name) mm group by duty_unit, doc_common, file_type order by mm.dev_name) group by file_name, scrape_type, coding_code_id, duty_unit, scrape_apply_id, file_type order by duty_unit, coding_code_id ";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		
		//查询汇总文件表
		String sqlFilesAsset="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_collect_id+"' and t.bsflag='0' and t.is_file='1'  "
				+ "and t.file_type='excel_content_collect' order by t.order_num";
		List<Map> fileListCollect = new ArrayList<Map>();
		fileListCollect= jdbcDao.queryRecords(sqlFilesAsset);
		responseDTO.setValue("fdataCollect", fileListCollect);//固定资产附件
		
		
		//其他附件信息
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_collect_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type is null order by t.order_num";
		List<Map> fileListOther = new ArrayList<Map>();
		fileListOther= jdbcDao.queryRecords(sqlFiles);
		responseDTO.setValue("fdataOther", fileListOther);//其他附件
		
		//附件汇总
		//String filetotal="select scrape_apply_id ||'_'||project_name || '_' || org_name || '_' || dev_name || '_' || dev_type || '_' || scrape_type key, count(*) num from(select distinct org_name, dev_name, dev_type, d.project_name, d.scrape_type, d.scrape_apply_id,lf.file_id from dms_scrape_detailed_link_file lf, bgp_doc_gms_file bdgf, DMS_SCRAPE_DETAILED d, dms_scrape_apply app, comm_org_information org where lf.file_id = bdgf.file_id and app.scrape_org_id = org.org_id and d.scrape_detailed_id = lf.scrape_detailed_id and d.scrape_apply_id = app.scrape_apply_id) group by scrape_apply_id||'_'|| project_name || '_' || org_name || '_' || dev_name || '_' || dev_type || '_' || scrape_type ";
		//List<Map> filetotallist = new ArrayList<Map>();
		//filetotallist= jdbcDao.queryRecords(filetotal);
		//responseDTO.setValue("filetotallist", filetotallist);
		return responseDTO;
	}
	/**
	 * 查询报废申请盘亏信息
	 * 查询报废申请固定资产信息 综合方法
	 */
	public ISrvMsg getScrapeCollectAllInfo(ISrvMsg msg)throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废汇总单号
		String scrape_collect_id=msg.getValue("scrape_collect_id");
		
		//汇总主题信息
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name ");
		queryScrapeInfoSql.append(" from dms_scrape_collect t  left join common_busi_wf_middle t2 on t.scrape_collect_id=t2.business_id  and t2.bsflag='0'  ");
		queryScrapeInfoSql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		queryScrapeInfoSql.append(" left join comm_org_information org on t.scrape_org_id = org.org_id  where t.bsflag='0' ");
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			queryScrapeInfoSql.append(" and t.scrape_collect_id  = '"+scrape_collect_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		
		//关联的报废申请单设备信息
		String queryApplySql= "select * from (select t.*, t2.proc_status apply_status,emp.employee_name,org.org_name as org_name  from dms_scrape_apply t "
				+ "left join common_busi_wf_middle t2 on t.scrape_apply_id = t2.business_id and t2.bsflag = '0' "
				+ "left join comm_human_employee emp on t.employee_id = emp.employee_id   "
				+ "left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag = '0') pp "
				+ "where pp.apply_status = '3' and pp.scrape_collect_id  ='"+scrape_collect_id+"'";
		List<Map> listApply = new ArrayList<Map>();
		listApply = jdbcDao.queryRecords(queryApplySql);
		responseDTO.setValue("datasApply", listApply);
		
		String querysgllSql = "select  alldev.duty_unit,alldev.org_name,alldev.org_id,alldev.scrape_type,case when alldev.scrape_type='0' then '正常报废' when alldev.scrape_type='1' then '技术淘汰' when alldev.scrape_type='2' then '毁损' when alldev.scrape_type='3' then '盘亏' else '其他' end as scrape_types,"
				+ "alldev.dev_name,alldev.dev_type,alldev.dev_model,alldev.times,count(alldev.dev_type) as counts,sum(alldev.ASSET_VALUE) as asset_value,sum(alldev.NET_VALUE) as net_value,alldev.sp_pass_flag,alldev.sp_bak1, alldev. scrape_apply_id1 from ("
				+ "select case "
				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <100 then '八年及以上' "
				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <8 then '五年到八年' "
				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <5 then '三年到五年' "
				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <3 then '一年到三年' "
				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <1 then '一年以内' "
				+ "else '未知时段' end as times, "
				+ "detail.*,  detail.scrape_apply_id scrape_apply_id1,pp.* from dms_scrape_detailed detail,(select t.*, t2.proc_status apply_status,emp.employee_name,org.org_name as org_name  from dms_scrape_apply t "
				+ "left join common_busi_wf_middle t2 on t.scrape_apply_id = t2.business_id and t2.bsflag = '0' "
				+ "left join comm_human_employee emp on t.employee_id = emp.employee_id "
				+ "left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag = '0') pp "
				+ "where detail.scrape_apply_id=pp.scrape_apply_id and "
				+ "pp.apply_status = '3' and pp.scrape_apply_id in (select scrape_apply_id from dms_scrape_apply where scrape_collect_id='"+scrape_collect_id+"') ) alldev "
				+ "where 1=1 group by alldev.duty_unit,alldev.org_name,alldev.dev_type,alldev.dev_model,alldev.dev_name,alldev.times,alldev.sp_pass_flag,alldev.sp_bak1, alldev.scrape_type, alldev.org_id,scrape_apply_id1 order by alldev.org_name";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		
		//查询汇总文件表
		String sqlFilesAsset="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_collect_id+"' and t.bsflag='0' and t.is_file='1'  "
				+ "and t.file_type='excel_content_collect' order by t.order_num";
		List<Map> fileListCollect = new ArrayList<Map>();
		fileListCollect= jdbcDao.queryRecords(sqlFilesAsset);
		responseDTO.setValue("fdataCollect", fileListCollect);//固定资产附件
		
		
		//其他附件信息
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_collect_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type is null order by t.order_num";
		List<Map> fileListOther = new ArrayList<Map>();
		fileListOther= jdbcDao.queryRecords(sqlFiles);
		responseDTO.setValue("fdataOther", fileListOther);//其他附件
		return responseDTO;
	}
	/**
	 *自定义审批-审批设备报废汇总单--更新汇总单设备状态
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateScrapeCollectInfo(ISrvMsg isrvmsg) throws Exception {
			String scrape_collect_id=isrvmsg.getValue("scrape_collect_id");
			String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd");
			//scrape_flag 报废标示 0未报废 1已报废 
			//SP_PASS_FLAG 审批结果0通过，1不通过
			/*
			 * 汇总的时候不变更报废标示，交给上报处操作
			 * String updateSql="update dms_scrape_detailed set scrape_flag='1',scrape_date=to_date('"+currentdate+"','yyyy-mm-dd') where SP_PASS_FLAG ='0' and scrape_apply_id in (select scrape_apply_id from dms_scrape_apply where scrape_collect_id='"+scrape_collect_id+"')";
			jdbcDao.executeUpdate(updateSql);*/
			//添加修改报废申请单为已使用状态
			String updateApplySql="update dms_scrape_apply set scrape_collect_flag='1'  where scrape_collect_id='"+scrape_collect_id+"'";
			jdbcDao.executeUpdate(updateApplySql);
			//更新设备台账使用状态，改为待报废
			//using_stat 0110000007000000006
			/*
			 * 汇总的时候不变更台账使用状态，交给上报处操作
			 * String updateAccountSql="update gms_device_account account  set  account.using_stat='0110000007000000006',account.tech_stat='0110000006000000005'  where account.dev_coding in( select d.dev_coding from dms_scrape_detailed d where d.SP_PASS_FLAG ='0' and d.scrape_apply_id in(select scrape_apply_id from dms_scrape_apply where scrape_collect_id='"+scrape_collect_id+"'))";
			jdbcDao.executeUpdate(updateAccountSql);
			
			String updateAccountSql1="update gms_device_account_b account  set  account.using_stat='0110000007000000006',account.tech_stat='0110000006000000005'  where account.dev_coding in( select d.dev_coding from dms_scrape_detailed d where d.SP_PASS_FLAG ='0' and d.scrape_apply_id in(select scrape_apply_id from dms_scrape_apply where scrape_collect_id='"+scrape_collect_id+"'))";
			jdbcDao.executeUpdate(updateAccountSql1);*/
			
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		return respMsg;
	}
	//分组处理方法
	public void GroupingHandle(final List<Map> assetLists,Serializable id,Serializable damageId,String scrape_apply_id,UserToken user){
		LinkedList<Map> subll = new LinkedList<Map>();// 下发的名单序列
		String userid=user.getSubOrgIDofAffordOrg();//所属单位隶属关系id
		int listcounts = 500;// 设定一次发送的条数
		// 该递归循环用于每次发送<=1k条数据，当数据量大于1k时进行递归调用
		if (assetLists.size() > listcounts) {
			subll.addAll(assetLists.subList(0, listcounts));// 截取一次发送条数
			assetLists.removeAll(subll);// 除去发送的list
			for(int i = 0;i < subll.size(); i++){
				String dev_coding = subll.get(i).get("dev_coding").toString();//Amis资产编码
				StringBuffer queryScrapeInfoSql = new StringBuffer();
				queryScrapeInfoSql.append("select * from (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) account where account.dev_coding in(select dev_coding from (select dev_coding,owning_sub_id from GMS_DEVICE_ACCOUNT union all select dev_coding,owning_sub_id from GMS_DEVICE_ACCOUNT_b) p where p.owning_sub_id like '"+userid+"%' and dev_coding='"+dev_coding+"')");
				Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
				subll.get(i).put("dev_name", (String) deviceMap.get("dev_name"));
				subll.get(i).put("asset_value", (String) deviceMap.get("asset_value"));
				subll.get(i).put("net_value", (String) deviceMap.get("net_value"));
				subll.get(i).put("dev_sign", (String) deviceMap.get("dev_sign"));
				subll.get(i).put("dev_type",(String) deviceMap.get("dev_type"));
				subll.get(i).put("license_num",(String) deviceMap.get("license_num"));
				subll.get(i).put("producting_date",(String) deviceMap.get("producting_date"));
				subll.get(i).put("owning_org_id",(String) deviceMap.get("owning_org_id"));
				subll.get(i).put("dev_acc_id",(String)deviceMap.get("dev_acc_id"));
				//补充规格型号
				subll.get(i).put("dev_model",(String)deviceMap.get("dev_model"));
			}
			exebatchupdate(subll, id,damageId, scrape_apply_id);
			GroupingHandle(assetLists, id,damageId, scrape_apply_id,user);// 递归循环
		} else {// 当发送条数少于1k时发送完毕，结束，不再递归调用
			for(int i = 0;i < assetLists.size(); i++){
				String dev_coding = assetLists.get(i).get("dev_coding").toString();//Amis资产编码
				StringBuffer queryScrapeInfoSql = new StringBuffer();
				queryScrapeInfoSql.append("select * from (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) account where account.dev_coding in(select dev_coding from (select dev_coding,owning_sub_id from GMS_DEVICE_ACCOUNT union all select dev_coding,owning_sub_id from GMS_DEVICE_ACCOUNT_b) p where p.owning_sub_id like '"+userid+"%' and dev_coding='"+dev_coding+"')");
				Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
				if(deviceMap==null){
					assetLists.remove(i);
					i--;
				}else{
					
					assetLists.get(i).put("dev_name", (String) deviceMap.get("dev_name"));
					assetLists.get(i).put("asset_value", (String) deviceMap.get("asset_value"));
					assetLists.get(i).put("net_value", (String) deviceMap.get("net_value"));
					assetLists.get(i).put("dev_sign", (String) deviceMap.get("dev_sign"));
					assetLists.get(i).put("dev_type",(String) deviceMap.get("dev_type"));
					assetLists.get(i).put("license_num",(String) deviceMap.get("license_num"));
					assetLists.get(i).put("producting_date",(String) deviceMap.get("producting_date"));
					assetLists.get(i).put("owning_org_id",(String) deviceMap.get("owning_org_id"));
					assetLists.get(i).put("dev_acc_id",(String)deviceMap.get("dev_acc_id"));
					//补充规格型号
					assetLists.get(i).put("dev_model",(String)deviceMap.get("dev_model"));
				}
			}
			if(assetLists.size()>0)
				exebatchupdate(assetLists, id,damageId, scrape_apply_id);
		}
	}
	public void exebatchupdate(final List<Map> assetLists,Serializable id,Serializable damageId,String scrape_apply_id){
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		String type="";
		if(id==null){
			type="SCRAPE_DAMAGE_ID";
			id = damageId;
		}else{
			type="SCRAPE_ASSET_ID";
		}
		String sqls = "insert into DMS_SCRAPE_DETAILED"
				+ "("+type+","
				+ "SCRAPE_APPLY_ID,"
				+ "DEV_NAME,"
				+ "DEV_CODING,"
				+ "ASSET_CODING,"
				+ "ASSET_VALUE,"
				+ "DEV_SIGN,"
				+ "DEV_TYPE,"
				+ "LICENSE_NUM,"
				+ "PRODUCTING_DATE,"
				+ "SCRAPE_FLAG,"
				+ "ORG_ID,"
				+ "bak1,"
				+ "FOREIGN_DEV_ID,"
				+ "BSFLAG,"
				+ "SCRAPE_DETAILED_ID,"
				/*+ "SP_PASS_FLAG,"
				+ "SP_BAK1,"*/
				+ "SCRAPE_TYPE,"
				+ "DEV_MODEL,"
				+ "NET_VALUE) "
				+ "values('"+id.toString()+"','"+scrape_apply_id+"',?,?,?,?,?,?,?,?,'0',?,?,?,'"+CommonConstants.BSFLAG_NORMAL+"',?,?,?,?)";
		long starttime=new Date().getTime();
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map map = null;
				try {
					map = (Map)assetLists.get(i);
				} catch (Exception e) {
				}
				String dev_name = map.get("dev_name").toString();
				String dev_coding = map.get("dev_coding").toString();//ERP设备编码
				String asset_coding = map.get("asset_coding").toString();//Amis资产编码
				String scrape_type = map.get("scrape_type").toString();//
				if(scrape_type.equals("正常报废")){
					scrape_type="0";
				}else if(scrape_type.equals("技术淘汰")){
					scrape_type="1";
				}else if(scrape_type.equals("毁损")){
					scrape_type="2";
				}else if(scrape_type.equals("盘亏")){
					scrape_type="3";
				}
				String bak = map.get("bak").toString();
				/*String sp_pass_flag = map.get("sp_pass_flag").toString();//审批意见
				String sp_bak = map.get("sp_bak").toString();//审批备注
*/				String asset_value = map.get("asset_value").toString();
				String net_value = map.get("net_value").toString();
				String dev_sign = map.get("dev_sign").toString();
				String dev_type = map.get("dev_type").toString();
				String license_num = map.get("license_num").toString();
				String producting_date = map.get("producting_date").toString();
				String owning_org_id = map.get("owning_org_id").toString();
				String dev_acc_id = map.get("dev_acc_id").toString();
				String dev_model = map.get("dev_model").toString();//
				ps.setString(1, dev_name);
				ps.setString(2, dev_coding);
				ps.setString(3, asset_coding);
				ps.setString(4, asset_value); 
				ps.setString(5, dev_sign);
				ps.setString(6,dev_type);
				ps.setString(7,license_num);
				if(!producting_date.equals("")){
					StringTokenizer  st  =  new  StringTokenizer(producting_date, "-");     
					java.sql.Date date=new  java.sql.Date(Integer.parseInt(st.nextToken()));  
					ps.setDate(8,date);
				}else{
					ps.setDate(8,null);
				}
				ps.setString(9,owning_org_id);
				ps.setString(10, bak);
				ps.setString(11,dev_acc_id);
				ps.setString(12, UUID.randomUUID().toString().replaceAll("-", ""));
				/*ps.setString(13, sp_pass_flag);
				ps.setString(14,sp_bak);*/
				ps.setString(13,scrape_type);
				ps.setString(14,dev_model);
				ps.setString(15,net_value);
			}
			public int getBatchSize() {
				return assetLists.size();
			}
		};
		long endtime=new Date().getTime();
		System.out.println("批量准备耗时："+(endtime-starttime)+"毫秒");
		jdbcTemplate.batchUpdate(sqls, setter);
		long rapetime=new Date().getTime();
		System.out.println("导入固有资产数据条数:"+assetLists.size()+"条。耗时"+(rapetime-endtime));
	}
	/**
	 * 构建物资树形列表
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg devqueryTree(ISrvMsg reqDTO) throws Exception {

		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String parentId = reqDTO.getValue("node");
		
		String scrapeType = reqDTO.getValue("scrapeType");
		String scrape_apply_id = reqDTO.getValue("scrape_apply_id");
		String json = "[]";
		if ("root".equals(parentId)) {
			StringBuffer sqlBuffer = new StringBuffer("select * from (select t.dev_name||',累计：'||count(t.dev_type)||'台' as code_name,t.dev_type as coding_code_id,'true' as leaf,'self' as parent_code,'' as description,'' as note  from dms_scrape_detailed t  ");
			if(!"".equals(scrapeType)){
				sqlBuffer.append(" where t.scrape_type = "+scrapeType);
			}
			if(!"".equals(scrape_apply_id)){
				sqlBuffer.append(" and t.scrape_apply_id = '"+scrape_apply_id+"'");
			}
			sqlBuffer.append(" group by t.dev_type,dev_name order by t.dev_name)");
			List list = ijdbcDao.queryRecords(sqlBuffer.toString());
			// 根节点值
			Map map = new HashMap();
			map.put("codingCodeId", "C105");
			map.put("parentCode", "self");
			map.put("codeName", "物资分类");
			map.put("description", "");
			map.put("note", "");
			map.put("expanded", "true");
			map.put("children", list);
			JSONArray retJson = null;
			retJson = JSONArray.fromObject(map);
			JSONArray.fromObject(map);
			json = retJson.toString();
		}
		responseDTO.setValue("json", json);
		return responseDTO;
	}
	/**
	 * 保存附件并建立与设备的关联
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg saveLinkdync(ISrvMsg reqDTO) throws Exception {
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		UserToken user = reqDTO.getUserToken();
		String scrape_apply_id = reqDTO.getValue("scrape_apply_id");
		String scrape_detailed_id = reqDTO.getValue("scrape_detailed_id");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> files = mqMsg.getFiles();
		String file_id = reqDTO.getValue("file_id");
		//如果已经有附件，采取更新操作（先删除，再添加）
		if(files!=null&&files.size()>0){
			//处理附件
			try {
				for (WSFile file : files) {
					String filename = file.getFilename();
					String fileOrder = file.getKey().toString().split("__")[1];
					MyUcm ucm = new MyUcm();
					String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
	
					Map doc = new HashMap();
					doc.put("file_name", filename);
					String fileType = reqDTO.getValue("doc_type__"+fileOrder);
					doc.put("file_type",fileType );
					doc.put("ucm_id", ucmDocId);
					doc.put("is_file", "1");
					doc.put("relation_id", scrape_apply_id);
					doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
					doc.put("create_date",currentdate);
					doc.put("creator_id",user.getUserId());
					doc.put("org_id", user.getOrgId());
					doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
					String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
					ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
					ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
	/*				//只有在新增文件时才写历史 
					if((StringUtils.isEmpty(isrvmsg.getValue("paper_id"))) ){
						
					
					}*/
					if(!"null".equals(scrape_detailed_id)){
						final String sub[] = scrape_detailed_id.substring(0, scrape_detailed_id.length()).split(",");
						final List list = new ArrayList();
						for(int i=0;i<sub.length;i++){
							list.add(sub[i]);
						}
						//去重
						HashSet h  =   new  HashSet(list); 
					    list.clear(); 
					    list.addAll(h);
					    System.out.println(list.size());
						JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
						String sql = "insert into DMS_SCRAPE_DETAILED_LINK_FILE"
								+ "(scrape_detailed_id,"
								+ "file_id) "
								+ "values(?,'"+docId+"')";
						BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
							public void setValues(PreparedStatement ps, int i) throws SQLException {
								ps.setString(1, list.get(i).toString());
							}
							public int getBatchSize() {
								return list.size();
							}
						};
						int a[] = jdbcTemplate.batchUpdate(sql, setter);
						System.out.println(a.length);
					}
				}
				//附件关联设备
				
				reqMsg.isSuccessRet();
			} catch (Exception e) {
				
			}
		}else{
			if(null!=file_id){
				//删除操作
				String deleteSql = "delete DMS_SCRAPE_DETAILED_LINK_FILE detailed where detailed.file_id='"+file_id+"'";
				jdbcDao.executeUpdate(deleteSql);
				//添加操作
				if(!"null".equals(scrape_detailed_id)){
					final String sub[] = scrape_detailed_id.substring(0, scrape_detailed_id.length()).split(",");
					final List list = new ArrayList();
					for(int i=0;i<sub.length;i++){
						if("".equals(sub[i]))continue;
						list.add(sub[i]);
					}
					//去重
					HashSet h  =   new  HashSet(list); 
				    list.clear(); 
				    list.addAll(h);
				    System.out.println(list.size());
					JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
					String sql = "insert into DMS_SCRAPE_DETAILED_LINK_FILE"
							+ "(scrape_detailed_id,"
							+ "file_id) "
							+ "values(?,'"+file_id+"')";
					BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
						public void setValues(PreparedStatement ps, int i) throws SQLException {
							ps.setString(1, list.get(i).toString());
						}
						public int getBatchSize() {
							return list.size();
						}
					};
					int a[] = jdbcTemplate.batchUpdate(sql, setter);
					System.out.println(a.length);
				}
			}
		}
		List<GmsDevice> nodes = new ArrayList<GmsDevice>();
		reqMsg.setValue("nodes", nodes);
		return reqMsg;
	}
	/**
	 * 删除专家
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteEmp(ISrvMsg isrvmsg) throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String empId = isrvmsg.getValue("empId");		
		if(!"".equals(empId)){
			String deleteSql = "delete DMS_SCRAPE_EMPLOYEE emp where emp.id='"+empId+"'";
			jdbcDao.executeUpdate(deleteSql);
		}
		return responseDTO;

	}
	
	/**
	 * 查询报废申请单汇总信息列表
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg getScrapeApplyCollectNew(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String ids = msg.getValue("ids");
		String wz_name = msg.getValue("wz_name");//设备名称
		String dev_model = msg.getValue("dev_model");//设备型号
		String scrape_type = msg.getValue("scrape_type");
		String s_dutyUnit = msg.getValue("s_dutyUnit");
		String s_org_name = msg.getValue("s_org_name");
		String s_project_name=msg.getValue("s_project_name");
		String scrape_collect_id = msg.getValue("scrape_collect_id");
		String sql=" select file_name, coding_code_id, '(' || scrape_type || ')' || sum(count1) || '条' as code_name, duty_unit, scrape_apply_id, file_type, sum(asset_value) asset_value, sum(net_value) net_value from(select count(distinct mm.dev_coding) count1, wm_concat(distinct mm.file_id || '&' || mm.file_name) as file_name, case when wm_concat(distinct doc_common) = '0' then '正常报废' when wm_concat(distinct doc_common) = '1' then '技术淘汰' when wm_concat(distinct doc_common) = '2' then '毁损' else '盘亏' end scrape_type, wm_concat(distinct doc_common) coding_code_id, wm_concat(distinct duty_unit) duty_unit, wm_concat(distinct scrape_apply_id) scrape_apply_id, wm_concat(distinct file_type) file_type, sum(asset_value) asset_value, sum(net_value) net_value from (select distinct (t.dev_coding), t.dev_name, t.dev_type, t.scrape_detailed_id, orgsubidtoname(i.org_subjection_id) duty_unit, t.scrape_apply_id, case when t.scrape_type = '0' or t.scrape_type = '1' then (select sa.expert_leader from DMS_SCRAPE_ASSET sa where sa.scrape_apply_id = t.scrape_apply_id) else (select sd.expert_leader from dms_scrape_damage sd where sd.scrape_apply_id = t.scrape_apply_id) end employee_name, filelink.file_id, filelink.file_name, filelink.doc_common, filelink.file_type, t.asset_value,t.net_value from dms_scrape_detailed t inner join comm_org_subjection i on t.org_id = i.org_id and i.bsflag='0' left join (select bdgf.*, files.scrape_detailed_id from dms_scrape_detailed_link_file files, bgp_doc_gms_file bdgf where files.file_id = bdgf.file_id and bdgf.bsflag = '0') filelink on t.scrape_detailed_id = filelink.scrape_detailed_id";
				if(StringUtils.isNotBlank(ids)){
					sql+=" where t.bsflag='0' and  t.scrape_apply_id in ("+ids+") " ;
				}else{
					sql+=" where t.bsflag='0' and  t.scrape_apply_id in ( select scrape_apply_id from dms_scrape_apply a where a.scrape_collect_id='"+scrape_collect_id+"') " ;	
				}
				if(StringUtils.isNotBlank(scrape_type)){
					sql+=" and scrape_type='"+scrape_type+"'";
				}
					sql+="   order by t.dev_name) mm  " ;
				if(StringUtils.isNotBlank(s_dutyUnit)){
					sql+=" where duty_unit like '%"+s_dutyUnit+"%'";
				}
					sql+="  group by duty_unit, doc_common, file_type order by mm.dev_name) group by file_name, scrape_type, coding_code_id, duty_unit, scrape_apply_id, file_type order by duty_unit, coding_code_id  ";
		List<Map> list= jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	/**
	 * 查询报废申请单汇总信息列表
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg getScrapeApplyCollect(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String ids = msg.getValue("ids");
		String pid = "";//预处理申请单id
		if(!ids.equals("")){
			pid = " and pp.scrape_apply_id in ("+ids + ")";
		}
		String wz_name = msg.getValue("wz_name");//设备名称
		String dev_model = msg.getValue("dev_model");//设备型号
		//String times = msg.getValue("times");
		String scrape_type = msg.getValue("scrape_type");
		String s_dutyUnit = msg.getValue("s_dutyUnit");
		String s_org_name = msg.getValue("s_org_name");
		String s_project_name=msg.getValue("s_project_name");
		String scrape_collect_id = msg.getValue("scrape_collect_id");
		String cid = "";//预处理申请单id
		if(!"null".equals(scrape_collect_id)){
			cid = " and pp.scrape_collect_id = '"+scrape_collect_id+"'";
		}
		String querysgllSql = "select * from (select alldev.scrape_apply_id1,alldev.project_name,alldev.duty_unit,alldev.org_name,alldev.scrape_type,case when alldev.scrape_type='0' then '正常报废' when alldev.scrape_type='1' then '技术淘汰' when alldev.scrape_type='2' then '毁损' when alldev.scrape_type='3' then '盘亏' else '其他' end as scrape_types,"
				+ "alldev.dev_name,alldev.dev_type,alldev.dev_model,count(alldev.dev_type) as counts,sum(alldev.ASSET_VALUE) as asset_value,sum(alldev.NET_VALUE) as net_value,alldev.sp_pass_flag,alldev.sp_bak1 from ("
				+ "select  "
//				+ "select case "
//				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <100 then '八年及以上' "
//				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <8 then '五年到八年' "
//				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <5 then '三年到五年' "
//				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <3 then '一年到三年' "
//				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <1 then '一年以内' "
//				+ "else '未知时段' end as times, "
				+ "detail.*,pp.*,detail.scrape_apply_id scrape_apply_id1 from dms_scrape_detailed detail,(select t.*, t2.proc_status apply_status,emp.employee_name,org.org_name as org_name  from dms_scrape_apply t "
				+ "left join common_busi_wf_middle t2 on t.scrape_apply_id = t2.business_id and t2.bsflag = '0' "
				+ "left join comm_human_employee emp on t.employee_id = emp.employee_id "
				+ "left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag = '0') pp "
				+ "where detail.scrape_apply_id=pp.scrape_apply_id and "
				+ "pp.apply_status = '3' " + cid + pid + " ) alldev "
				+ "where 1=1 group by alldev.scrape_apply_id1,alldev.org_name,alldev.dev_type,alldev.dev_model,alldev.dev_name,alldev.sp_pass_flag,alldev.sp_bak1,alldev.scrape_type,alldev.duty_unit,alldev.project_name order by alldev.project_name,alldev.org_name) sc where 1=1";
		if(StringUtils.isNotBlank(wz_name)){
			querysgllSql += " and sc.dev_name  like '"+wz_name+"%'";
		}
		if(StringUtils.isNotBlank(dev_model)){
			querysgllSql += " and sc.dev_model  like '"+dev_model+"%'";
		}
		//if (StringUtils.isNotBlank(times)) {
		//	querysgllSql += " and sc.times ='"+times+"'";
		//}
		if (StringUtils.isNotBlank(scrape_type)) {
			querysgllSql += " and sc.scrape_type ='"+scrape_type+"'";
		}
		if (StringUtils.isNotBlank(s_org_name)) {
			querysgllSql += " and sc.org_name like '%"+s_org_name+"%'";
		}
		if (StringUtils.isNotBlank(s_dutyUnit)) {
			querysgllSql += " and sc.duty_unit like '%"+s_dutyUnit+"%'";
		}
		if (StringUtils.isNotBlank(s_project_name)) {
			querysgllSql += " and sc.project_name like '%"+s_project_name+"%'";
		}
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		//附件汇总
				String filetotal="select scrape_apply_id ||'_'||project_name || '_' || org_name || '_' || dev_name || '_' || dev_type || '_' || scrape_type key, count(*) num from(select distinct org_name, dev_name, dev_type, d.project_name, d.scrape_type, d.scrape_apply_id,lf.file_id from dms_scrape_detailed_link_file lf, bgp_doc_gms_file bdgf, DMS_SCRAPE_DETAILED d, dms_scrape_apply app, comm_org_information org where lf.file_id = bdgf.file_id and app.scrape_org_id = org.org_id and d.scrape_detailed_id = lf.scrape_detailed_id and d.scrape_apply_id = app.scrape_apply_id) group by scrape_apply_id||'_'|| project_name || '_' || org_name || '_' || dev_name || '_' || dev_type || '_' || scrape_type ";
				List<Map> filetotallist = new ArrayList<Map>();
				filetotallist= jdbcDao.queryRecords(filetotal);
				responseDTO.setValue("filetotallist", filetotallist);
		return responseDTO;
	}
	/**
	 * 查询报废上报列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapeReportList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String scrape_report_name = isrvmsg.getValue("scrape_report_name");// 报废申请单名称
		String scrape_report_no = isrvmsg.getValue("scrape_report_no");// 报废申请单号
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name ");
		querySql.append(" from dms_scrape_report t  left join common_busi_wf_middle t2 on t.scrape_report_id=t2.business_id  and t2.bsflag='0'  ");
		querySql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		querySql.append(" left join comm_org_information org on t.scrape_org_id = org.org_id  where t.bsflag='0' ");
		// 申请单名称
		if (StringUtils.isNotBlank(scrape_report_name)) {
			querySql.append(" and t.scrape_report_name  like '"+scrape_report_name+"%'");
		}
		// 申请单号
		if (StringUtils.isNotBlank(scrape_report_no)) {
			querySql.append(" and t.scrape_report_no  like '"+scrape_report_no+"%'");
		}
		//如果是超级管理员的话不做所属单位数据筛选，查询全部的单位数据
		if(!user.getOrgCode().equals("C105")){
			querySql.append(" and t.scrape_org_id ='"+user.getOrgId()+"'");
		}
		//添加排序
		querySql.append(" order by t.create_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
/**
	 *添加报废上报单所有信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeallReport(ISrvMsg isrvmsg) throws Exception {
		
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//获得报废申请单名称
		String scrape_report_name=isrvmsg.getValue("scrape_report_name");
		// 报废上报单ID
		String scrape_report_id=isrvmsg.getValue("scrape_report_id");
		//上报日期
		String report_date=isrvmsg.getValue("apply_date");
		//生成基本信息
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		//报废上报单号 
		String scrape_report_no = "";
		//备注
		String bak=isrvmsg.getValue("bak");
		//专家组
		String experts=isrvmsg.getValue("experts");
		
		String scrape_report_type = isrvmsg.getValue("scrape_report_type");//上报类别
		
		Date dt= new Date();
		//1、报废上报主表操作新增或修改
		if("null".equals(scrape_report_id)){
			scrape_report_no = CommonUtil.getScrapeReportNo();
			mainMap.put("scrape_report_name", scrape_report_name);
			mainMap.put("report_date", report_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("scrape_report_no", scrape_report_no);
			mainMap.put("create_date", currentdate);
			mainMap.put("creater", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			mainMap.put("bak", bak);
			mainMap.put("experts", experts);
			mainMap.put("scrape_report_type", scrape_report_type);
			Serializable id=jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_REPORT");
			scrape_report_id=id.toString();
		}else{
			mainMap.put("scrape_report_id", scrape_report_id);
			mainMap.put("scrape_report_name", scrape_report_name);
			mainMap.put("report_date", report_date);
			mainMap.put("employee_id", user.getEmpId());
			mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("modify_date", currentdate);
			mainMap.put("updatetor", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			mainMap.put("bak", bak);
			mainMap.put("experts", experts);
			mainMap.put("scrape_report_type", scrape_report_type);
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_REPORT");
		}
		
		//2、报废上报数据与报废申请关联
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_collect_id=isrvmsg.getValue("scrape_collect_id");// 报废申请单ID
		Map<String,Object> ApplyMap = new HashMap<String,Object>();
		String applyIdsql = "select SCRAPE_APPLY_ID from dms_scrape_apply app where app.scrape_report_id='"+scrape_report_id+"'";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(applyIdsql);
		if(null==scrape_collect_id){
			scrape_collect_id="";
		}else{
			scrape_collect_id+=",";
		}
		if(list.size()>0){
			for(int j=0;j<list.size();j++)
				scrape_collect_id+=list.get(j).get("scrape_collect_id")+",";
		}
		if(scrape_collect_id.length()==0){
			scrape_collect_id=",";
		}
		scrape_collect_id = scrape_collect_id.replace("'", "");
		final String sub[] = scrape_collect_id.substring(0, scrape_collect_id.length()-1).split(",");
//		for(int i=0;i<sub.length;i++){
//			ApplyMap.put("scrape_report_id", scrape_report_id.toString());
//			ApplyMap.put("SCRAPE_APPLY_ID", sub[i].toString());
//			jdbcDao.saveOrUpdateEntity(ApplyMap, "DMS_SCRAPE_APPLY");
//		}
		if(sub.length>0){
			JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
			String sql = "update DMS_SCRAPE_APPLY set "
					+ "scrape_report_id = '"+scrape_report_id.toString()+"' "
			+ " where scrape_collect_id =?";
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				public void setValues(PreparedStatement ps, int a) throws SQLException {
						ps.setString(1, sub[a].toString());
				}
				public int getBatchSize() {
					return sub.length;
				}
			};
			jdbcTemplate.batchUpdate(sql, setter);
		}
		respMsg.setValue("scrape_report_id", scrape_report_id);
		
		//3、设备台账详细表操作
		//上报时不需要更新是否通过，汇总时已经操作
		/*int devCount = Integer.parseInt(isrvmsg.getValue("devCount"));//设备的数量
		List<Map> listMap = new ArrayList<Map>();
		for(int i = 0;i<devCount;i++){
			Map map =new HashMap();
			map.put("org_name",isrvmsg.getValue("org_name"+i));//申请单位
			map.put("dev_name",isrvmsg.getValue("dev_name"+i));//设备名称
			map.put("dev_type",isrvmsg.getValue("dev_type"+i));//设备类别
			map.put("sp_pass_flag",isrvmsg.getValue("sp_pass_flag"+i));//是否通过
			map.put("sp_bak1",isrvmsg.getValue("sp_bak1"+i)==null?"":isrvmsg.getValue("sp_bak1"+i));//意见
			String time =isrvmsg.getValue("times"+i);//时间段
			if("八年及以上".equals(time)){//<time_end  >=time_start
				map.put("time_start",8);
				map.put("time_end",100);
			}else if("五年到八年".equals(time)){
				map.put("time_start",5);
				map.put("time_end",8);
			}else if("三年到五年".equals(time)){
				map.put("time_start",3);
				map.put("time_end",5);
			}else if("一年到三年".equals(time)){
				map.put("time_start",1);
				map.put("time_end",3);
			}else if("一年以内".equals(time)){
				map.put("time_start",0);
				map.put("time_end",1);
			}
			listMap.add(map);
		}
		final List<Map> listMaps =listMap;
		for(int i = 0;i<sub.length;i++){
			JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
			String sql = "update DMS_SCRAPE_DETAILED set "
					+ "SP_PASS_FLAG = ? , "
					+ "SP_BAK1 = ?"
			+ " where SCRAPE_APPLY_ID ='"+sub[i]+"'"
			+" and SCRAPE_APPLY_ID in( select SCRAPE_APPLY_ID from dms_scrape_apply app where app.scrape_org_id in(select org.org_id from comm_org_information org where org.org_abbreviation=?)) "
			+" and dev_name=? "
			+" and dev_type=? "
			+" and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=?"
			+" and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')<?";
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				public void setValues(PreparedStatement ps, int a) throws SQLException {
						ps.setString(1, listMaps.get(a).get("sp_pass_flag").toString());
						ps.setString(2, listMaps.get(a).get("sp_bak1").toString());//意见
						ps.setString(3, listMaps.get(a).get("org_name").toString());//申请单位
						ps.setString(4, listMaps.get(a).get("dev_name").toString());//设备名称
						ps.setString(5, listMaps.get(a).get("dev_type").toString());//设备类别
						ps.setString(6, listMaps.get(a).get("time_start").toString());//设备名称
						ps.setString(7, listMaps.get(a).get("time_end").toString());//设备类别
				}
				public int getBatchSize() {
					return listMaps.size();
				}
			};
			jdbcTemplate.batchUpdate(sql, setter);
		}*/
		
		//4、多附件
		MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
		List<WSFile> filesOther = mqMsgOther.getFiles();
		try {
			//处理附件
			for (WSFile file : filesOther) {
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
				doc.put("relation_id", scrape_report_id);
				doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
				doc.put("create_date",currentdate);
				doc.put("creator_id",user.getUserId());
				doc.put("org_id", user.getOrgId());
				doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
				ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
				ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
			}
			
		} catch (Exception e) {
		}
		return respMsg;
	}
	/**
	 * 查询报废上报单状态
	 */
	public ISrvMsg getScrapeReportState(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_report_id=isrvmsg.getValue("scrape_report_id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select devapp.scrape_report_id,devapp.scrape_report_type, nvl(wfmiddle.proc_status, '') as proc_status  from dms_scrape_report devapp ");
		queryScrapeInfoSql.append(" left join common_busi_wf_middle wfmiddle on devapp.scrape_report_id = wfmiddle.business_id ");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_report_id)) {
			queryScrapeInfoSql.append(" where scrape_report_id  = '"+scrape_report_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	/**
	 * 查询上报单报废信息
	 * 
	 */
	public ISrvMsg getScrapeReportInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		String scrape_report_id=isrvmsg.getValue("scrape_report_id");// 报废上报单ID
		queryScrapeInfoSql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name ");
		queryScrapeInfoSql.append(" from dms_scrape_report t  left join common_busi_wf_middle t2 on t.scrape_report_id=t2.business_id  and t2.bsflag='0'  ");
		queryScrapeInfoSql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		queryScrapeInfoSql.append(" left join comm_org_information org on t.scrape_org_id = org.org_id  where t.bsflag='0' ");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_report_id)) {
			queryScrapeInfoSql.append(" and t.scrape_report_id  = '"+scrape_report_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	/**
	 * 删除报废上报单
	 */
	public ISrvMsg deleteScrapeReportInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String scrape_report_id=isrvmsg.getValue("scrape_report_id");// 报废申请单ID
		Map<String,Object> mainMap = new HashMap<String,Object>();
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		mainMap.put("employee_id", user.getEmpId());
		mainMap.put("scrape_org_id", user.getOrgId());
		mainMap.put("modifi_date", currentdate);
		mainMap.put("updatetor", user.getEmpId());
		mainMap.put("scrape_report_id", scrape_report_id);
		mainMap.put("bsflag", CommonConstants.BSFLAG_DELETE);
		//6.向数据库写入信息
		jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_REPORT");
		//在删除上报申请的时候，需要把报废申请表的上报id清除
		String updateAccountSql="update DMS_SCRAPE_APPLY app  set  app.scrape_report_id='',app.scrape_report_flag=''  where app.scrape_report_id='"+scrape_report_id+"'";
		jdbcDao.executeUpdate(updateAccountSql);
		
		return responseDTO;
	}
	/**
	 * 查询报废上报单是否添加设备报废明细信息
	 */
	
	public ISrvMsg getScrapeReportDetail(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_report_id=isrvmsg.getValue("scrape_report_id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select count(1) as result from dms_scrape_detailed where BSFLAG='0'");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_report_id)) {
			queryScrapeInfoSql.append(" and scrape_apply_id  in (select scrape_apply_id from  dms_scrape_apply where scrape_report_id='"+scrape_report_id+"')");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	/**
	 * 评审汇总提交之前判断是否全部操作
	 * @return
	 */
	public ISrvMsg isAllPassDone(ISrvMsg msg)throws Exception {
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String sql="select wm_concat(desc1) desc1 from(select duty_unit||'有'||scrape_type||count||'设备没评审' desc1 from (select duty_unit,scrape_type,count(scrape_type) count from (select orgsubidtoname(i.org_subjection_id) duty_unit, case when t.scrape_type = '0' then '正常报废' when t.scrape_type = '1' then '技术淘汰' when t.scrape_type = '2' then '毁损' else '盘亏' end scrape_type from dms_scrape_detailed t inner join comm_org_subjection i on t.org_id = i.org_id and i.bsflag='0' where t.scrape_apply_id in ("+scrape_apply_id+") and t.sp_pass_flag is null order by scrape_type) group by duty_unit,scrape_type)) ";
		Map map=jdbcDao.queryRecordBySQL(sql);
		if(MapUtils.isNotEmpty(map)){
			String message=(String) map.get("desc1");
			responseDTO.setValue("message", message.replaceAll(",", "\r\n"));
		}
		return responseDTO;
	}
	/**
	 * 查询报废申请盘亏信息
	 * 查询报废上报固定资产信息 综合方法
	 */
	public ISrvMsg getScrapeReportAllInfo(ISrvMsg msg)throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废上报单号
		String scrape_report_id=msg.getValue("scrape_report_id");
		
		//上报主题信息
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,emp.employee_id,org.org_name as org_name ");
		queryScrapeInfoSql.append(" from dms_scrape_report t  left join common_busi_wf_middle t2 on t.scrape_report_id=t2.business_id  and t2.bsflag='0'  ");
		queryScrapeInfoSql.append(" left join comm_human_employee emp on t.employee_id = emp.employee_id ");
		queryScrapeInfoSql.append(" left join comm_org_information org on t.scrape_org_id = org.org_id  where t.bsflag='0' ");
		if (StringUtils.isNotBlank(scrape_report_id)) {
			queryScrapeInfoSql.append(" and t.scrape_report_id  = '"+scrape_report_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		
		//关联的报废申请单设备信息
		String queryApplySql= "select * from (select t.*, t2.proc_status apply_status,emp.employee_name,org.org_name as org_name  from dms_scrape_apply t "
				+ "left join common_busi_wf_middle t2 on t.scrape_apply_id = t2.business_id and t2.bsflag = '0' "
				+ "left join comm_human_employee emp on t.employee_id = emp.employee_id   "
				+ "left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag = '0') pp "
				+ "where pp.apply_status = '3' and pp.scrape_report_id  ='"+scrape_report_id+"'";
		List<Map> listApply = new ArrayList<Map>();
		listApply = jdbcDao.queryRecords(queryApplySql);
		responseDTO.setValue("datasApply", listApply);
		
		String querysgllSql = "select alldev.org_name,alldev.scrape_apply_id,count(alldev.dev_type) as counts,sum(alldev.ASSET_VALUE) as asset_value,sum(alldev.NET_VALUE) as net_value from ("
				+ "select pp.scrape_apply_id,pp.org_name,detail.dev_type,detail.asset_value,detail.net_value,detail.sp_pass_flag from dms_scrape_detailed detail,(select t.*, t2.proc_status apply_status,emp.employee_name,org.org_name as org_name  from dms_scrape_apply t "
				+ "left join common_busi_wf_middle t2 on t.scrape_apply_id = t2.business_id and t2.bsflag = '0' "
				+ "left join comm_human_employee emp on t.employee_id = emp.employee_id "
				+ "left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag = '0') pp "
				+ "where detail.scrape_apply_id=pp.scrape_apply_id and "
				+ "detail.sp_pass_flag='0' and "
				+ "pp.apply_status = '3' and pp.scrape_apply_id in (select scrape_apply_id from dms_scrape_apply where scrape_report_id='"+scrape_report_id+"') ) alldev "
				+ "where 1=1 group by alldev.org_name,alldev.scrape_apply_id,alldev.sp_pass_flag order by alldev.org_name";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		
		//查询上报文件表
		String sqlFilesAsset="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_report_id+"' and t.bsflag='0' and t.is_file='1'  "
				+ "and t.file_type='excel_content_report' order by t.order_num";
		List<Map> fileListReport = new ArrayList<Map>();
		fileListReport= jdbcDao.queryRecords(sqlFilesAsset);
		responseDTO.setValue("fdataReport", fileListReport);//固定资产附件
		
		
		//其他附件信息
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_report_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type is null  order by t.order_num";
		List<Map> fileListOther = new ArrayList<Map>();
		fileListOther= jdbcDao.queryRecords(sqlFiles);
		responseDTO.setValue("fdataOther", fileListOther);//其他附件
		return responseDTO;
	}
	/**
	 *自定义审批-审批设备报废上报单--更新上报单设备状态
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updateScrapeReportInfo(ISrvMsg isrvmsg) throws Exception {
			String scrape_report_id=isrvmsg.getValue("scrape_report_id");
			String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd");
			//scrape_flag 报废标示 0未报废 1已报废 
			//SP_PASS_FLAG 审批结果0通过，1不通过
			String updateSql="update dms_scrape_detailed set scrape_flag='1',scrape_date=to_date('"+currentdate+"','yyyy-mm-dd') where SP_PASS_FLAG ='0' and scrape_apply_id in (select scrape_apply_id from dms_scrape_apply where scrape_report_id='"+scrape_report_id+"')";
			jdbcDao.executeUpdate(updateSql);
			//添加修改报废申请单为已使用状态
			String updateApplySql="update dms_scrape_apply set scrape_report_flag='1'  where scrape_report_id='"+scrape_report_id+"'";
			jdbcDao.executeUpdate(updateApplySql);
			//更新设备台账使用状态，改为待报废
			//using_stat 0110000007000000006
			String updateAccountSql="update gms_device_account account  set  account.using_stat='0110000007000000006',account.tech_stat='0110000006000000005'  where account.dev_coding in( select d.dev_coding from dms_scrape_detailed d where d.SP_PASS_FLAG ='0' and d.scrape_apply_id in(select scrape_apply_id from dms_scrape_apply where scrape_report_id='"+scrape_report_id+"'))";
			jdbcDao.executeUpdate(updateAccountSql);
			
			String updateAccountSql1="update gms_device_account_b account  set  account.using_stat='0110000007000000006',account.tech_stat='0110000006000000005'  where account.dev_coding in( select d.dev_coding from dms_scrape_detailed d where d.SP_PASS_FLAG ='0' and d.scrape_apply_id in(select scrape_apply_id from dms_scrape_apply where scrape_report_id='"+scrape_report_id+"'))";
			jdbcDao.executeUpdate(updateAccountSql1);
			
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		return respMsg;
	}
	/**
	 * 查询报废申请单上报信息列表
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg getScrapeApplyReport(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String ids = msg.getValue("ids");
		String querysgllSql = "select  alldev.org_name,alldev.dev_name,alldev.dev_type,alldev.dev_model,alldev.times,count(alldev.dev_type) as counts,sum(alldev.ASSET_VALUE) as asset_value,alldev.sp_pass_flag,alldev.sp_bak1 from ("
				+ "select case "
				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <100 then '八年及以上' "
				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <8 then '五年到八年' "
				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <5 then '三年到五年' "
				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <3 then '一年到三年' "
				+ "when to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(producting_date,'yyyy') <1 then '一年以内' "
				+ "else '未知时段' end as times, "
				+ "detail.*,pp.* from dms_scrape_detailed detail,(select t.*, t2.proc_status apply_status,emp.employee_name,org.org_name as org_name  from dms_scrape_apply t "
				+ "left join common_busi_wf_middle t2 on t.scrape_apply_id = t2.business_id and t2.bsflag = '0' "
				+ "left join comm_human_employee emp on t.employee_id = emp.employee_id "
				+ "left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag = '0') pp "
				+ "where detail.scrape_apply_id=pp.scrape_apply_id and "
				+ "detail.sp_pass_flag='0' and "
				+ "pp.apply_status = '3' and pp.scrape_apply_id in ("+ids + ") ) alldev "
				+ "where 1=1 group by alldev.org_name,alldev.dev_type,alldev.dev_model,alldev.dev_name,alldev.times,alldev.sp_pass_flag,alldev.sp_bak1 order by alldev.dev_name";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	public ISrvMsg getDivMessageNew(ISrvMsg isrvmsg) throws Exception {
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
	

		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");
		String scrape_type = isrvmsg.getValue("scrape_type");
		String file_type = isrvmsg.getValue("file_type");
		String dev_name=isrvmsg.getValue("dev_name");
		String dev_model=isrvmsg.getValue("dev_model");
		String start_date=isrvmsg.getValue("start_date");
		String end_date=isrvmsg.getValue("end_date");
		String duty_unit=isrvmsg.getValue("duty_unit");
		String pass_flag=isrvmsg.getValue("pass_flag");
		String querysgllSql = " select * from(select distinct t.scrape_detailed_id,(select tt.ASSET_CODING from gms_device_account tt where tt.DEV_CODING=t.dev_coding and tt.bsflag='0')ASSET_CODING,t.dev_name,t.dev_model,t.dev_coding,t.license_num,t.producting_date,t.asset_value,t.net_value,sp_pass_flag,sp_bak1,case when i.org_subjection_id like 'C105001005%' then '塔里木物探处' when i.org_subjection_id like 'C105001002%' then '新疆物探处' when i.org_subjection_id like 'C105001003%' then '吐哈物探处' when i.org_subjection_id like 'C105001004%' then '青海物探处' when i.org_subjection_id like 'C105005004%' then '长庆物探处' when i.org_subjection_id like 'C105005000%' then '华北物探处' when i.org_subjection_id like 'C105005001%' then '新兴物探开发处' when i.org_subjection_id like 'C105007%' then '大港物探处' when i.org_subjection_id like 'C105063%' then '辽河物探处' when i.org_subjection_id like 'C105008%' then '综合物化处' when i.org_subjection_id like 'C105006%' then '装备服务处' when i.org_subjection_id like 'C105002%' then '国际勘探事业部' when i.org_subjection_id like 'C105003%' then '研究院' when i.org_subjection_id like 'C105015%' then '井中地震中心' when i.org_subjection_id like 'C105086%' then '深海物探处' when i.org_subjection_id like 'C105017%' then '矿区服务事业部' when i.org_subjection_id like 'C105014%' then '信息技术中心(中油瑞飞)' when i.org_subjection_id like 'C105016%' then '西安物探装备分公司' when i.org_subjection_id like 'C105005%' then '东方地球物理公司东部勘探' when i.org_subjection_id like 'C105075%' then '物探培训中心' when i.org_subjection_id like 'C105004%' then '物探技术研究中心' when i.org_subjection_id like 'C105078%' then '物资供应中心' when i.org_subjection_id like 'C105013%' then '采集技术支持部' when i.org_subjection_id like 'C105082%' then '油藏地球物理研究中心' else '' end duty_unit,t.duty_unit duty_unit1 from dms_scrape_detailed t,comm_org_subjection i,dms_scrape_detailed_link_file f,bgp_doc_gms_file bf where f.file_id=bf.file_id and t.scrape_detailed_id=f.scrape_detailed_id and t.org_id=i.org_id and i.bsflag='0'and t.scrape_apply_id = '"+scrape_apply_id+"'"
				+"  and t.scrape_type = '"+scrape_type+"'"
				+"  and bf.doc_common='"+scrape_type+"'"	
				+"  and bf.file_type='"+file_type+"'";
		if(StringUtils.isNotBlank(pass_flag)&&!"0".equals(pass_flag)){
			 if("1".equals(pass_flag)){
				querysgllSql+=" and SP_PASS_FLAG is null ";
			}else if("2".equals(pass_flag)){
				querysgllSql+=" and SP_PASS_FLAG = '0' ";
			}else{
				querysgllSql+=" and SP_PASS_FLAG = '1' ";
			}
		}
		if(StringUtils.isNotBlank(dev_name)){
			querysgllSql+=" and dev_name like '%"+dev_name+"%'";
		}
		if(StringUtils.isNotBlank(dev_model)){
			querysgllSql+=" and dev_model like '%"+dev_model+"%'";
		}
		if(StringUtils.isNotBlank(start_date)){
			querysgllSql+=" and  t.producting_date >=to_date('"+start_date+"','yyyy-MM-dd') ";
		}
		if(StringUtils.isNotBlank(end_date)){
			querysgllSql+=" and  t.producting_date <=to_date('"+end_date+"','yyyy-MM-dd') ";
		}
		if(StringUtils.isNotBlank(sortField)){
			querysgllSql+=" order by "+sortField+" "+sortOrder+" )";
		}else{
			querysgllSql+=" order by dev_name )";
		}
		if(StringUtils.isNotBlank(duty_unit)){
			querysgllSql+=" where duty_unit1 like '%"+duty_unit+"%'";
		}
		page = pureJdbcDao.queryRecordsBySQL(querysgllSql, page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
		 
	}
	public ISrvMsg getDivMessage(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		//获取当前页
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
		String scrape_collect_id =msg.getValue("scrape_collect_id");
		String scrape_apply_id = msg.getValue("scrape_apply_id");
		String org_name=msg.getValue("org_name");
		String org_id=msg.getValue("org_id");
		String dev_name=msg.getValue("dev_name");
		String dev_type=msg.getValue("dev_type");
		String times=msg.getValue("times");
		String dev_model = msg.getValue("dev_model");
		String scrape_type = msg.getValue("scrape_type");
		String query_dev_name=msg.getValue("query_dev_name");
		String query_dev_coding=msg.getValue("query_dev_coding");
		String query_order_num=msg.getValue("query_order_num");
		String query_order_type=msg.getValue("query_order_type");
		String project_name=msg.getValue("project_name");
		int time_start =0,time_end =0;
		String sp_pass_flag=msg.getValue("sp_pass_flag");
		String sp_bak1=msg.getValue("sp_bak1");
		if("八年及以上".equals(times)){//<time_end  >=time_start
			time_start=8;
			time_end=100;
		}else if("五年到八年".equals(times)){
			time_start=5;
			time_end=8;
		}else if("三年到五年".equals(times)){
			time_start=3;
			time_end=5;
		}else if("一年到三年".equals(times)){
			time_start=1;
			time_end=3;
		}else if("一年以内".equals(times)){
			time_start=0;
			time_end=1;
		}
		StringBuffer querySql = new StringBuffer();
		String userid=user.getSubOrgIDofAffordOrg();
		
String querysgllSql = "select detailed.*,case  when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <100 then '八年及以上' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <8 then '五年到八年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <5 then '三年到五年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <3 then '一年到三年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <1 then '一年以内' else '未知时段' end as dev_date,n.org_name from dms_scrape_detailed detailed left join gms_device_account account on account.dev_acc_id=detailed.foreign_dev_id left join comm_org_information n on n.org_id = detailed.org_id where 1=1 "
				+" and detailed.SCRAPE_APPLY_ID in"
				+"(select SCRAPE_APPLY_ID from dms_scrape_apply app where     detailed.bsflag=0 and  app.scrape_org_id in (select org.org_id from comm_org_information org where org.org_name = '"+org_name+"'))";
	//if(project_name!=null&&!"null".equals(project_name)){
	//	querysgllSql+=" and detailed.project_name='"+project_name+"' ";
	//}
	if(dev_name!=null&&!"null".equals(dev_name))
		querysgllSql +=" and detailed.dev_name = '"+dev_name+"'";
	if(org_id!=null&&!"null".equals(org_id))
		querysgllSql +=" and detailed.org_id = '"+org_id+"'";
	if(dev_type!=null&&!"null".equals(dev_type))
		querysgllSql +=" and detailed.dev_type = '"+dev_type+"'";
	if(dev_model!=null&&!"null".equals(dev_model))
		querysgllSql +=" and detailed.dev_model = '"+dev_model+"'";
	if(scrape_type!=null&&!"null".equals(scrape_type))
		querysgllSql +=" and detailed.scrape_type = '"+scrape_type+"'";
	if(0!=time_start)
		querysgllSql +=" and to_char(sysdate, 'yyyy') - to_char(detailed.producting_date, 'yyyy') >= '"+time_start+"'";
	if(0!=time_end)
		querysgllSql +=" and to_char(sysdate, 'yyyy') - to_char(detailed.producting_date, 'yyyy') < '"+time_end+"'";;
	if(query_dev_name!=null&&!"null".equals(query_dev_name))
		querysgllSql +=" and dev_name like '%"+query_dev_name+"%'";
	if(scrape_apply_id!=null&&!"null".equals(scrape_apply_id))
		querysgllSql +=" and SCRAPE_APPLY_ID = '"+scrape_apply_id+"'";
	if(query_dev_coding!=null&&!"null".equals(query_dev_coding))
		querysgllSql +=" and dev_coding = '"+query_dev_coding+"'";
	if(query_order_num!=null&&!"null".equals(query_order_num))
		querysgllSql +=" order by "+query_order_num+" "+query_order_type;
		page = pureJdbcDao.queryRecordsBySQL(querysgllSql, page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
		/*ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		//获取当前页
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
		String dev_name = isrvmsg.getValue("dev_name");// 设备名称
		String dev_model = isrvmsg.getValue("dev_model");// 设备型号
		String license_num = isrvmsg.getValue("license_num");// 牌照号
		String pageselectedstr=isrvmsg.getValue("pageselectedstr");//可配置查询条件
		String handleFlag=isrvmsg.getValue("handleFlag");//报废标示
		String hflag=isrvmsg.getValue("hflag");//报废处置设备标示
		StringBuffer querySql = new StringBuffer();
		String userid=user.getSubOrgIDofAffordOrg();
		
//			querySql.append("select t.*,apply.scrape_apply_no,dispose.app_no,  ");
//			querySql.append(" (case when t.org_id like 'C105001005%' then '塔里木物探处' else (case when t.org_id like 'C105001002%' ") ;
//			querySql.append(" then '新疆物探处'else(case when t.org_id like 'C105001003%' then '吐哈物探处'else(case when t.org_id like " ) ;
//			querySql.append(" 'C105001004%' then '青海物探处'else(case when t.org_id like 'C105005004%' then '长庆物探处'else(case when t.org_id like ") ;
//			querySql.append(" 'C105005000%' then '华北物探处'else(case when t.org_id like 'C105005001%' then '新兴物探开发处'else(case when t.org_id like " ) ;
//			querySql.append(" 'C105007%' then '大港物探处'else(case when t.org_id like 'C105063%' then '辽河物探处'else(case when t.org_id like 'C105006%' " ) ;
//			querySql.append(" then '装备服务处'else (case when t.org_id like 'C105002%' then '国际勘探事业部'else (case when t.org_id like 'C105003%' then " ) ;
//			querySql.append(" '研究院'else (case when t.org_id like 'C105008%' then '综合物化处'else (case when t.org_id like 'C105015%' then '井中地震中心'  " ) ;
//			querySql.append(" else (case when t.org_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name_desc");
//			querySql.append(" from dms_scrape_detailed t");
//			querySql.append(" left join dms_scrape_apply apply on apply.scrape_apply_id=t.scrape_apply_id");
//			querySql.append(" left join dms_dispose_apply dispose on dispose.dispose_apply_id=t.dispose_apply_id");
//			querySql.append(" where t.scrape_flag='1' and t.bsflag='0'");
			querySql.append("select t.*,apply.scrape_apply_no,dispose.app_no, ");
			querySql.append(" org.org_abbreviation as owning_org_name_desc ");
			querySql.append(" from dms_scrape_detailed t left join comm_org_information org on org.org_id=t.org_id");
			querySql.append(" left join dms_scrape_apply apply on apply.scrape_apply_id=t.scrape_apply_id");
			querySql.append(" left join dms_dispose_apply dispose on dispose.dispose_apply_id=t.dispose_apply_id");
			querySql.append(" left join (select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account_b union all select dev_acc_id,dev_coding,dev_name,asset_stat,dev_model,self_num,dev_sign,dev_type,dev_unit,asset_coding,turn_num,order_num,requ_num,asset_value,net_value,cont_num,currency,tech_stat,using_stat,capital_source,owning_org_id,owning_org_name,owning_sub_id,usage_org_id,usage_org_name,usage_sub_id,dev_position,manu_factur,producting_date,account_stat,dev_photo,license_num,chassis_num,engine_num,bsflag,remark,creator,create_date,modifier,modifi_date,search_id,rentalprice,project_info_no,check_time,foreign_key,ifcountry,saveflag,spare1,spare2,spare3,spare4,spare5,spare6,dev_supplier,dev_supplier_desc,produce_country,ifproduction,manage_level,ifunused from gms_device_account) dui on dui.dev_acc_id=t.foreign_dev_id");
			querySql.append(" where t.scrape_flag='1' and t.bsflag='0' and sp_pass_flag = '0'  and dui.owning_sub_id like '"+userid+"%' ");
			// 设备名称
			if (StringUtils.isNotBlank(dev_name)) {
				querySql.append(" and t.dev_name  like '"+dev_name+"%'");
			}
			// 设备型号
			if (StringUtils.isNotBlank(dev_model)) {
				querySql.append(" and t.dev_model  like '"+dev_model+"%'");
			}
			// 牌照号
			if (StringUtils.isNotBlank(license_num)) {
				querySql.append(" and t.license_num  like '"+license_num+"%'");
			}
			// 可配置查询条件
			if (StringUtils.isNotBlank(pageselectedstr)) {
				querySql.append(" and t.SCRAPE_DETAILED_ID not in ("+pageselectedstr+")");
			}
			//报废标示
			if (StringUtils.isNotBlank(handleFlag)) {
				querySql.append(" and t.handle_flag ='"+handleFlag+"'");
			}
			//报废处置设备标示
			if (StringUtils.isNotBlank(hflag)) {
				querySql.append(" and t.handle_flag is null");
			}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;*/
	}
	/**
	 * 查询报废申请单上报信息列表
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg getScrapeCollectReport(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		String ids = msg.getValue("ids");
		String querysgllSql = "select  alldev.org_name,alldev.scrape_apply_id,count(alldev.dev_type) as counts,sum(alldev.ASSET_VALUE) as asset_value,sum(alldev.NET_VALUE) as net_value from ("
				+ "select pp.scrape_apply_id,pp.org_name,detail.dev_type,detail.asset_value,detail.net_value,detail.sp_pass_flag from dms_scrape_detailed detail,(select t.*, t2.proc_status apply_status,emp.employee_name,org.org_name as org_name  from dms_scrape_apply t "
				+ "left join common_busi_wf_middle t2 on t.scrape_apply_id = t2.business_id and t2.bsflag = '0' "
				+ "left join comm_human_employee emp on t.employee_id = emp.employee_id "
				+ "left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag = '0') pp "
				+ "where detail.scrape_apply_id=pp.scrape_apply_id and "
				+ "detail.sp_pass_flag='0' and "
				+ "pp.apply_status = '3' and pp.scrape_apply_id in (select scrape_apply_id from dms_scrape_apply where dms_scrape_apply.scrape_collect_id in ("+ids + "))) alldev "
				+ "where 1=1 group by alldev.org_name,alldev.scrape_apply_id,alldev.sp_pass_flag order by alldev.org_name";
		List<Map> list = new ArrayList<Map>();
		list = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	/**
	 * 批量更新报废申请的专家信息意见
	 */
	public ISrvMsg updateScrapeNumber(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ids=isrvmsg.getValue("ids");// 专家表ID
		String scrape_number=isrvmsg.getValue("scrape_number");// 专家名称意见
		String updateScrapeNumber="update DMS_SCRAPE_REPORT report  set  report.scrape_number='"+scrape_number+"' where report.SCRAPE_REPORT_ID = '"+ids+"'";
		jdbcDao.executeUpdate(updateScrapeNumber);
		return responseDTO;
	}
	
	/**
	 * 新增查询报废设备 不通过明细信息
	 */
	public ISrvMsg getScrapeDetailNotGoInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String scrape_collect_id=msg.getValue("scrape_collect_id");
		String scrape_report_id=msg.getValue("scrape_report_id");
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
		//报废申请单号
		StringBuffer querySql = new StringBuffer();
		querySql.append("select '/' jlb,'/' bm,'/' ljzj,'/' jzzb,'1' sl,dev_type,dev_coding,temp.asset_coding,dev_name,dev_model,license_num,producting_date,asset_value,net_value,scrape_type,duty_unit, orgsubidtoname(os.org_subjection_id)   org_name,case  when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <100 then '八年及以上' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <8 then '五年到八年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <5 then '三年到五年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <3 then '一年到三年' when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <1 then '一年以内' else '未知时段' end as dev_date ,detailed.team_name as team_name ,detailed.project_name from dms_scrape_detailed detailed left join  (select dev_acc_id,asset_coding from gms_device_account union select dev_acc_id,asset_coding from  gms_device_account_b) temp  on detailed.foreign_dev_id=temp.dev_acc_id "
				+ "left join comm_org_information n on n.org_id = detailed.org_id     left join comm_org_subjection os    on n.org_id = os.org_id and os.bsflag='0' "
				+ "where 1=1 and detailed.sp_pass_flag='1' and detailed.bsflag='1' ");
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			querySql.append("and detailed.scrape_apply_id  = '"+scrape_apply_id+"'");
		}
		// 汇总单号
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			querySql.append(" and detailed.scrape_apply_id in(select scrape_apply_id  from dms_scrape_apply where scrape_collect_id  = '"+scrape_collect_id+"')");
		}
		// 上报单号
		if (StringUtils.isNotBlank(scrape_report_id)) {
			querySql.append(" and detailed.scrape_apply_id in(select scrape_apply_id  from dms_scrape_apply where scrape_report_id  = '"+scrape_report_id+"') and detailed.sp_pass_flag = '0' ");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by detailed.scrape_detailed_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	
	}
	
	/**
	 * 新增查询报废申请是否通过的状态
	 */
	public ISrvMsg getScrapeAppleState(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 报废申请单ID
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		queryScrapeInfoSql.append("select d.sp_pass_flag,d.* from dms_scrape_apply devapp ");
		queryScrapeInfoSql.append("left join dms_scrape_detailed d on d.scrape_apply_id = devapp.scrape_apply_id ");
		queryScrapeInfoSql.append("where devapp.bsflag='0' ");
		// 申请单ID
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			queryScrapeInfoSql.append(" and devapp.scrape_apply_id  = '"+scrape_apply_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		return responseDTO;
	}
	/**
	 * 评审通过信息查看
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeListSee(ISrvMsg isrvmsg) throws Exception {
		String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");
		String proStatus=isrvmsg.getValue("proStatus");
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
		respMsg.setValue("scrape_apply_id", scrape_apply_id);
		respMsg.setValue("proStatus",proStatus);
		return respMsg;
	}
	/**
	 * 评审通未过信息查看
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeAssetInfoSee(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String scrape_apply_id=msg.getValue("scrape_apply_id");// 报废申请单ID
		String proStatus=msg.getValue("proStatus");
		responseDTO.setValue("scrape_apply_id", scrape_apply_id);
		responseDTO.setValue("proStatus", proStatus);
	    return responseDTO;
	}
	/**
	 * 查询盘亏毁损设备明细
	 * @since 2017年2月7日10:10:28
	 * @author zjb
	 */
	public ISrvMsg getScrapeDamageMessage(ISrvMsg isrvmsg) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
			String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");// 报废申请单id
			//报废设备详情及损失原因
			StringBuffer queryScrapeDetailSql = new StringBuffer();
			queryScrapeDetailSql.append("select substr(wm_concat(distinct t.dev_name),0,15)||'...等' as dev_name,wm_concat(distinct t.dev_name) as dev_name_title,sum(t.asset_value)||'元' as asset_value,wm_concat(distinct decode(t.scrape_type,2,'毁损','盘亏')) as scrape_type,wm_concat(distinct a.lose_dev_reason) as lose_dev_reason from dms_scrape_detailed t , dms_scrape_damage a where t.scrape_apply_id=a.scrape_apply_id and t.scrape_type in(2,3) and t.bsflag='0'");
			if (StringUtils.isNotBlank(scrape_apply_id)) {
				queryScrapeDetailSql.append("and t.scrape_apply_id='"+scrape_apply_id+"'");
			}else{
				queryScrapeDetailSql.append(" and 1=2 ");
			}
			Map scrapeDetailMap;//报废设备详情
			scrapeDetailMap = jdbcDao.queryRecordBySQL(queryScrapeDetailSql.toString());
			responseDTO.setValue("scrapeDetailMap",scrapeDetailMap);
			/*//报废申请		
			StringBuffer queryScrapeAppSql = new StringBuffer();
			queryScrapeAppSql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name  from dms_scrape_apply t  left join common_busi_wf_middle t2 on t.scrape_apply_id=t2.business_id  and t2.bsflag='0'   left join comm_human_employee emp on t.employee_id = emp.employee_id  left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag='0'  ");
			if (StringUtils.isNotBlank(scrape_apply_id)) {
				queryScrapeAppSql.append("and t.scrape_apply_id='"+scrape_apply_id+"'");
			}else{
				queryScrapeAppSql.append(" and 1=2 ");
			}
			queryScrapeAppSql.append("order by t.create_date desc");
			Map scrapeAppMap;//报废申请结果集
			scrapeAppMap = jdbcDao.queryRecordBySQL(queryScrapeAppSql.toString());
			responseDTO.setValue("scrapeAppMap",scrapeAppMap);
			//报废审批信息
			StringBuffer queryScrapeAppFlowSql = new StringBuffer();
			queryScrapeAppFlowSql.append("select t4.entity_id,t4.proc_name,t4.create_user_name,t3.node_name,decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState,t2.examine_user_name,t2.examine_start_date,subStr(t2.examine_end_date, 0, 16) examine_end_date,t1.is_open,t2.examine_info from wf_r_taskinst t1 inner join (select max(taskinst_id) taskinst_id,wmsys.wm_concat(examine_user_name) examine_user_name,max(examine_start_date) examine_start_date,max(examine_end_date) examine_end_date,max(examine_info) examine_info from wf_r_examineinst group by procinst_id, node_id) t2 on t1.entity_id = t2.taskinst_id ");
			if (StringUtils.isNotBlank(scrape_apply_id)) {
				queryScrapeAppFlowSql.append("and t1.procinst_id =(select t.proc_inst_id from COMMON_BUSI_WF_MIDDLE t where business_id='"+scrape_apply_id+"') ");
			}else{
				queryScrapeAppFlowSql.append(" and 1=2 ");
			}
			queryScrapeAppFlowSql.append("inner join wf_d_node t3 on t1.node_id = t3.entity_id inner join wf_r_procinst t4 on t1.procinst_id = t4.entity_id order by t2.examine_end_date asc");
			List scrapeAppFlowList;//报废申请结果集
			scrapeAppFlowList = jdbcDao.queryRecords(queryScrapeAppFlowSql.toString());
			responseDTO.setValue("scrapeAppFlowList",scrapeAppFlowList);
			
			//报废上报申请		
			StringBuffer queryScrapeRepSql = new StringBuffer();
			queryScrapeRepSql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as report_status,emp.employee_name,org.org_name as org_name  from dms_scrape_report t  left join common_busi_wf_middle t2 on t.scrape_report_id=t2.business_id  and t2.bsflag='0'   left join comm_human_employee emp on t.employee_id = emp.employee_id  left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag='0' ");
			if (StringUtils.isNotBlank(scrape_apply_id)) {
				queryScrapeRepSql.append("and t.scrape_report_id=(select scrape_report_id  from dms_scrape_apply where   scrape_apply_id='"+scrape_apply_id+"') ");
			}else{
				queryScrapeRepSql.append(" and 1=2 ");
			}
			queryScrapeRepSql.append("order by t.create_date desc");
			Map scrapeRepMap;//报废申请结果集
			scrapeRepMap = jdbcDao.queryRecordBySQL(queryScrapeRepSql.toString());
			responseDTO.setValue("scrapeRepMap",scrapeRepMap);
			//报废上报
			StringBuffer queryscrapeRepFlowSql = new StringBuffer();
			queryscrapeRepFlowSql.append("select t4.entity_id,t4.proc_name,t4.create_user_name,t3.node_name,decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState,t2.examine_user_name,t2.examine_start_date,subStr(t2.examine_end_date, 0, 16) examine_end_date,t1.is_open,t2.examine_info from wf_r_taskinst t1 inner join (select max(taskinst_id) taskinst_id,wmsys.wm_concat(examine_user_name) examine_user_name,max(examine_start_date) examine_start_date,max(examine_end_date) examine_end_date,max(examine_info) examine_info from wf_r_examineinst group by procinst_id, node_id) t2 on t1.entity_id = t2.taskinst_id ");
			if (StringUtils.isNotBlank(scrape_apply_id)) {
				queryscrapeRepFlowSql.append("and t1.procinst_id =(select t.proc_inst_id from COMMON_BUSI_WF_MIDDLE t where business_id=(select scrape_report_id  from dms_scrape_apply where   scrape_apply_id='"+scrape_apply_id+"')) ");
			}else{
				queryscrapeRepFlowSql.append(" and 1=2 ");
			}
			queryscrapeRepFlowSql.append("inner join wf_d_node t3 on t1.node_id = t3.entity_id inner join wf_r_procinst t4 on t1.procinst_id = t4.entity_id order by t2.examine_end_date asc");
			List scrapeRepFlowList;//报废申请结果集
			scrapeRepFlowList = jdbcDao.queryRecords(queryscrapeRepFlowSql.toString());
			responseDTO.setValue("scrapeRepFlowList",scrapeRepFlowList);*/
			return responseDTO;
		}
	/**
	 * 查询技术淘汰设备明细
	 * @since 2017年2月7日10:10:28
	 * @author zjb
	 */
	public ISrvMsg getScrapeEliminateMessage(ISrvMsg isrvmsg) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
			String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");// 报废申请单id
			//报废设备详情及损失原因
			StringBuffer queryScrapeDetailSql = new StringBuffer();
			queryScrapeDetailSql.append("select substr(wm_concat(distinct t.dev_name),0,15)||'...等' as dev_name,wm_concat(distinct t.dev_name) as dev_name_title,sum(t.asset_value)||'元' as asset_value,wm_concat(distinct decode(t.scrape_type,1,'技术淘汰','正常报废')) as scrape_type,wm_concat(distinct a.lose_dev_reason) as lose_dev_reason from dms_scrape_detailed t , dms_scrape_damage a where t.scrape_apply_id=a.scrape_apply_id and t.scrape_type='1' and t.bsflag='0'");
			if (StringUtils.isNotBlank(scrape_apply_id)) {
				queryScrapeDetailSql.append("and t.scrape_apply_id='"+scrape_apply_id+"'");
			}else{
				queryScrapeDetailSql.append(" and 1=2 ");
			}
			Map scrapeDetailMap;//报废设备详情
			scrapeDetailMap = jdbcDao.queryRecordBySQL(queryScrapeDetailSql.toString());
			responseDTO.setValue("scrapeDetailMap",scrapeDetailMap);
			return responseDTO;
		}
	/**
	 * 更新设备盘亏毁损损失原因
	 */
	public ISrvMsg UpdateLoseDevReason(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_apply_id=isrvmsg.getValue("scrape_apply_id");// 专家名称意见
		String lose_dev_reason=isrvmsg.getValue("lose_dev_reason");// 专家名称意见
		String type=isrvmsg.getValue("type");// 专家名称意见
		/*if(types!=""&&types!=null){
			type =types.substring(0, types.length()-1).split("&");
		}*/
		if(type.equals("asset")){//属于正常报废和技术淘汰的专家意见
			String updateAssetSql="update dms_scrape_asset asset  set "
					+ " asset.lose_dev_reason='"+lose_dev_reason+"'"
					+ "where asset.scrape_apply_id='"+scrape_apply_id+"'";
			jdbcDao.executeUpdate(updateAssetSql);
		}
		if(type.equals("damage")){//属于盘亏和毁损的专家意见
			String updateDamageSql="update dms_scrape_damage damage  set "
					+ " damage.lose_dev_reason='"+lose_dev_reason+"'"
					+ "where damage.scrape_apply_id='"+scrape_apply_id+"'";
			jdbcDao.executeUpdate(updateDamageSql);
		}
		return responseDTO;
	}
	/**
	 * 查询报废设备明细根据设备类别
	 */
	public ISrvMsg getScrapeDetailInfoBydevType(ISrvMsg msg) throws Exception {
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
		//报废申请单号
		String dev_type=msg.getValue("dev_type");
		String collect_date = msg.getValue("collect_date");
		String scrape_collect_id=msg.getValue("scrape_collect_id");
		String scrape_report_id=msg.getValue("scrape_report_id");
		String scrape_type = msg.getValue("scrape_type");// 报废设备类别0123正常报废、技术淘汰、盘亏、毁损
		StringBuffer querySql = new StringBuffer();
		querySql.append("select '/' jlb,'/' bm,'/' ljzj,'/' jzzb,'1' sl,dev_type,dev_coding,asset_coding,dev_name,dev_model,license_num,producting_date,asset_value,net_value,scrape_type,duty_unit,  orgsubidtoname(os.org_subjection_id) org_name,case  "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <100 then '八年及以上' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <8 then '五年到八年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <5 then '三年到五年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <3 then '一年到三年' "
				+ "when to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(detailed.producting_date,'yyyy') <1 then '一年以内' "
				+ "else '未知时段' end as dev_date ,detailed.team_name as team_name ,detailed.project_name"
				+ "from dms_scrape_detailed detailed "
				+ "left join comm_org_information n on n.org_id = detailed.org_id    left join comm_org_subjection os    on n.org_id = os.org_id"
				+ "left join dms_scrape_apply app on app.scrape_apply_id = detailed.scrape_apply_id "
				+ "where 1=1 and detailed.bsflag='0' ");
		UserToken user = msg.getUserToken();
		if(!user.getOrgCode().equals("C105")){
			querySql.append(" and app.scrape_org_id ='"+user.getOrgId()+"'");
		}
		if(collect_date!=null && collect_date!=""){
			querySql.append(" and to_char(detailed.scrape_date,'yyyy') = "+collect_date);
		}
		if (StringUtils.isNotBlank(scrape_type)) {
			if(scrape_type.equals("1")){
				querySql.append(" and detailed.scrape_type='1'");
			}else{
				querySql.append(" and detailed.scrape_type in('2','3')");
			}
		}
		if (StringUtils.isNotBlank(dev_type)) {
			if(dev_type.equals("other")){
				querySql.append(" and detailed.dev_type not like 'S08%'"
							  + " and detailed.dev_type not like 'S0601%'"
							  + " and detailed.dev_type not like 'S070301%'"
							  + " and detailed.dev_type not like 'S14050301%'"
							  + " and detailed.dev_type not like 'S140501%' "
							  + " and detailed.dev_type not like 'S0623%'");
			}else{
				querySql.append(" and detailed.dev_type like '"+dev_type+"%'");
			}
		}
		
		// 汇总单号
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			querySql.append(" and detailed.scrape_apply_id in(select scrape_apply_id  from dms_scrape_apply where scrape_collect_id  = '"+scrape_collect_id+"')");
		}
		// 上报单号
		if (StringUtils.isNotBlank(scrape_report_id)) {
			querySql.append(" and detailed.scrape_apply_id in(select scrape_apply_id  from dms_scrape_apply where scrape_report_id  = '"+scrape_report_id+"') and detailed.sp_pass_flag = '0' ");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+" ");
		}else{
			querySql.append(" order by detailed.scrape_detailed_id");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
}
