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
import java.net.URLDecoder;
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

import org.apache.commons.collections.MapUtils;
import org.apache.commons.compress.archivers.ArchiveException;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.xml.resolver.apps.resolver;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate; 
import org.springframework.jdbc.core.PreparedStatementSetter;

import com.bgp.dms.util.CommonConstants;
import com.bgp.dms.util.CommonUtil;
import com.bgp.dms.util.EquipmentStants;
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
import com.cnpc.jcdp.util.DateUtil;
import com.cnpc.sais.ibp.auth.pojo.PAuthMenu;
import com.cnpc.sais.ibp.auth2.srv.AuthManagerUtil;
import com.cnpc.sais.ibp.auth2.util.MenuUtil;

/**
 * project: 东方物探设备体系信息化系统
 * 
 * creator: zjb
 * 
 * creator time:2016-1-16
 * 
 * description:设备报废申请业务类
 * 
 */
@SuppressWarnings("unchecked")
public class ScrapeSrvNew extends BaseService {
	
	
	
	IBaseDao baseDao = BeanFactory.getBaseDao();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private IJdbcDao ijdbcDao = BeanFactory.getQueryJdbcDAO();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	
	/**
	 * 通过wsfile 解析excel 获取excel中的信息
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
							mapColumnInfoIn.put(n, cell.getNumericCellValue());
							break;
						case 3:
							blankflag++;
							break;
						}
					}
					if (n == 15 && blankflag < 15) {
						Map map = new HashMap();
						map.put("0", mapColumnInfoIn.get(0));
						map.put("1", mapColumnInfoIn.get(1));
						map.put("2", mapColumnInfoIn.get(2));
						map.put("3", mapColumnInfoIn.get(3));
						map.put("4", mapColumnInfoIn.get(4));
						map.put("5", mapColumnInfoIn.get(5));
						map.put("6", mapColumnInfoIn.get(6));
						map.put("7", mapColumnInfoIn.get(7));
						map.put("8", mapColumnInfoIn.get(8));
						map.put("9", mapColumnInfoIn.get(9));
						map.put("10", mapColumnInfoIn.get(10));
						map.put("11", mapColumnInfoIn.get(11));
						map.put("12", mapColumnInfoIn.get(12));
						map.put("13", mapColumnInfoIn.get(13));
						map.put("14", mapColumnInfoIn.get(14));
						map.put("15", mapColumnInfoIn.get(15));
						dataList.add(map);
					}
				}
				if (blankflag ==9)
					break;
			}
		}
		return dataList;
	}
	/**
	 *  页面展示产品基本信息
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg getScrapeApplyWzInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//厂家详细信息
		String scrape_apply_wz_id=msg.getValue("scrape_apply_wz_id");
		StringBuffer queryAssetForDeviceSql = new StringBuffer();
		queryAssetForDeviceSql.append("select * from SCRAPE_APPLY_WZ d where ");
		if (StringUtils.isNotBlank(scrape_apply_wz_id)) {
			queryAssetForDeviceSql.append(" d.scrape_apply_wz_id  = '"+scrape_apply_wz_id+"'");
		}		
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryAssetForDeviceSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("deviceappMap", deviceappMap);
		}
		
		// 查询文件表
		String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ scrape_apply_wz_id + "' and t.bsflag='0' and t.is_file='1' ";
		// + "and order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2 = jdbcDao.queryRecords(sqlFiles);
		// 文件数据
		responseDTO.setValue("fdataPublic", list2);// 选型申请表对应附件

		
		return responseDTO;
	}
	/**
	 * 物料报废列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg queryScrapeApplyWzList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		/*UserToken user = isrvmsg.getUserToken();*/
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
		String apply_unit = isrvmsg.getValue("apply_unit");		// 申请单位
		String project_name = isrvmsg.getValue("project_name");			// 产品名称
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select * from SCRAPE_APPLY_WZ t where t.bsflag='0' ");
		// 申请单名称
		//if (StringUtils.isNotBlank(apply_unit)) {
		//	querySql.append(" and t.apply_unit  like '%"+apply_unit+"%'");
		//}
		// 申请单号
		//if (StringUtils.isNotBlank(project_name)) {
		//	querySql.append(" and t.project_name  like '%"+project_name+"%'");
		//}
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
	 * 新增/修改物料报废申请
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes" })
	public ISrvMsg addScrapeApplyWz(ISrvMsg isrvmsg) throws Exception {
		UserToken user = isrvmsg.getUserToken();
		Map<String, Object> strMap = new HashMap<String, Object>();
		String scrape_apply_wz_id = isrvmsg.getValue("scrape_apply_wz_id");
		String scrape_apply_wz_title = isrvmsg.getValue("scrape_apply_wz_title");
		String scrape_apply_wz_content = isrvmsg.getValue("scrape_apply_wz_content");
		String scrape_apply_wz_asset_value = isrvmsg.getValue("scrape_apply_wz_asset_value");
		String createdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		// 新增
		if (scrape_apply_wz_id.equals("null") || scrape_apply_wz_id.equals("") || scrape_apply_wz_id==null) {
		 
			strMap.put("scrape_apply_title", scrape_apply_wz_title);
			strMap.put("asset_value", scrape_apply_wz_asset_value);
			strMap.put("scrape_apply_content", scrape_apply_wz_content);
			strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
			strMap.put("creator", user.getEmpId());
			strMap.put("create_date", createdate);
			scrape_apply_wz_id   =(String)jdbcDao.saveOrUpdateEntity(strMap, "SCRAPE_APPLY_WZ");
		}
		// 修改操作
		else {
			strMap.put("scrape_apply_wz_id", scrape_apply_wz_id);
			strMap.put("scrape_apply_title", scrape_apply_wz_title);
			strMap.put("asset_value", scrape_apply_wz_asset_value);
			strMap.put("scrape_apply_content", scrape_apply_wz_content);
			strMap.put("bsflag", EquipmentStants.BSFLAG_ZC);
			strMap.put("updatetor", user.getEmpId());
			strMap.put("modify_date", createdate);
			jdbcDao.saveOrUpdateEntity(strMap, "SCRAPE_APPLY_WZ");
		}

		// 附件上传
		MQMsgImpl mqMsgOther = (MQMsgImpl) isrvmsg;
		List<WSFile> filesOther = mqMsgOther.getFiles();
		Map<String, Object> doc = new HashMap<String, Object>();
		MyUcm ucm = new MyUcm();
		String filename = "";
		String fileOrder = "";
		String ucmDocId = "";
		try {
			// 处理附件
			for (WSFile file : filesOther) {
				filename = file.getFilename();
				fileOrder = file.getKey().toString().split("__")[0];
				if("5110000215000000004".equals(fileOrder)){
					//插入明细
					List<Map> datalist= getDEVExcelDataByWSFile(file);
					List<String> infoList=new ArrayList<String>();
					for (Map map : datalist) {
						String sql="insert into DMS_SCRAPE_DETAILED_WZ(SCRAPE_DETAILED_WZ_ID,WZ_ID,WZ_NAME,WZ_PRICKIE,WZ_WAREHOUSE,WZ_ENTREPOT,WZ_PRICE,WZ_COUNT,WZ_MONEY,WZ_SLOTTING,WZ_TYPE,WZ_FROM,DEVICE_NAME,SCRAPETIME,HANDLE_FLAG,REMARK,SCRAPE_APPLY_WZ_ID,BSFLAG) "
								+ "values('"+jdbcDao.generateUUID()+"','"+map.get("1")+"','"+map.get("2")+"','"+map.get("3")+"','"+map.get("4")+"','"+map.get("5")+"','"+map.get("6")+"','"+map.get("7")+"','"+map.get("8")+"','"+map.get("9")+"','"+map.get("10")+"','"+map.get("11")+"','"+map.get("12")+"','"+map.get("13")+"','"+map.get("14")+"','"+map.get("15")+"','"+scrape_apply_wz_id+"','0')";
						System.out.println(sql);
						if(!"null".equals(map.get("2"))&&StringUtils.isNotBlank((String)map.get("2"))){
						infoList.add(sql);
						}
					}
					String [] inserinfoSqls= infoList.toArray(new String[infoList.size()]);
					if(inserinfoSqls.length!=0){
						jdbcDao.getJdbcTemplate().batchUpdate(inserinfoSqls);
					}
					continue;
				}
				ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
				doc.put("ucm_id", ucmDocId);
				doc.put("is_file", "1");
				doc.put("relation_id", scrape_apply_wz_id);
				doc.put("file_type", fileOrder);
				doc.put("file_name", filename);
				doc.put("bsflag", EquipmentStants.BSFLAG_ZC);
				doc.put("creator_id", user.getUserId());
				doc.put("org_id", user.getOrgId());
				doc.put("UPLOAD_DATE", createdate);
				doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
				// 附件表
				String docId = (String) jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
				// 日志表
				ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(), user.getCodeAffordOrgID(),
						user.getSubOrgIDofAffordOrg(), filename);
				ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),
						user.getCodeAffordOrgID(), user.getSubOrgIDofAffordOrg(), filename);
			}

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("插入附件异常");
		}

		return isrvmsg;

	}
	/**
	 * 查询报废申请关联附件情况
	 */
	public ISrvMsg getScrapeFileInfo(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String scrape_type=msg.getValue("scrape_type");
		if("01".equals(scrape_type)){
			scrape_type=" and  scrape_type in ('0', '1')";
		}else{
			scrape_type=" and  scrape_type in ('2', '3')";
		}
		String sql="select nvl(wm_concat(distinct msg),'false') msg  from (select t.dev_name||'-'||t.dev_type msg,f.file_id "
				+" from dms_scrape_detailed t left join dms_scrape_detailed_link_file f  "
				+" on t.scrape_detailed_id=f.scrape_detailed_id"
				+" where t.scrape_apply_id = '"+scrape_apply_id+"' "
				+" "+scrape_type+" ) where file_id is null";
		Map map=jdbcDao.queryRecordBySQL(sql);
		 
		responseDTO.setValue("msg", map.get("msg"));
		 
		
		return responseDTO;
	}
	/**
	 * 查询报废申请是否有事业部为空的
	 */
	public ISrvMsg getScrapeOrgIdIsNull(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
	 
		String sql="select '报废申请明细中有' || count(*) || '条数据 事业部 为空，不能提交!' msg, count(scrape_apply_id) flag from dms_scrape_detailed t where t.scrape_apply_id = '"+scrape_apply_id+"' and t.org_id is null";
		Map map=jdbcDao.queryRecordBySQL(sql);
		responseDTO.setValue("msg", map.get("msg"));
		responseDTO.setValue("flag", map.get("flag"));
		
		return responseDTO;
	}
	
	/**
	 * 查询报废申请关联附件情况New
	 */
	public ISrvMsg getScrapeFileInfoNew(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
	 
		String sql="select nvl(wm_concat(msg),'false') msg from(select decode(scrape_type,'0','正常报废','1','技术淘汰','2','毁损','盘亏') ||'有' ||count(*)||'台设备未关联,不能提交!' msg from ( select * from dms_scrape_detailed t left join dms_scrape_detailed_link_file f on t.scrape_detailed_id=f.scrape_detailed_id where t.scrape_apply_id = '"+scrape_apply_id+"') where file_id is null group by scrape_type )";
		Map map=jdbcDao.queryRecordBySQL(sql);
		responseDTO.setValue("msg", map.get("msg"));
		 
		
		return responseDTO;
	}
	
	/**
	 * NEWMETHOD 显示物理详细信息显示
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getWZScrapeMainInfo(ISrvMsg reqDTO) throws Exception {		
		String devAccId = reqDTO.getValue("devaccid");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer()
				.append("select * from dms_scrape_detailed_wz where scrape_detailed_wz_id='"+devAccId+"'");
		Map devMap = jdbcDao.queryRecordBySQL(sb.toString());
		if (MapUtils.isNotEmpty(devMap)) {
			responseMsg.setValue("data", devMap);
		}
		return responseMsg;
	}
	/**
	 * 查询物料报废台账(单台) 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryWZScrapeList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryWZScrapeList");
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
		String wz_name=isrvmsg.getValue("query_wz_name");
		String wz_type=isrvmsg.getValue("query_wz_type");
	    String scrape_apply_wz_id=isrvmsg.getValue("scrape_apply_wz_id");
		String sortField = isrvmsg.getValue("sort");
		String sortOrder = isrvmsg.getValue("order");
		StringBuffer querySql = new StringBuffer();
		querySql.append("select * from dms_scrape_detailed_wz  where 1=1");
		if(StringUtils.isNotBlank(wz_name)){
			querySql.append(" and wz_name like '%"+wz_name+"%'");
		}
		if(StringUtils.isNotBlank(wz_type)){
			querySql.append(" and wz_type like '%"+wz_type+"%'");
		}
		if(StringUtils.isNotBlank(scrape_apply_wz_id)){
			querySql.append(" and scrape_apply_wz_id like '%"+scrape_apply_wz_id+"%'");
		}
		if(StringUtils.isNotBlank(sortField)){
			querySql.append(" order by "+sortField+" "+sortOrder+"   ");
		}else{
			querySql.append(" order by wz_name  ");
		}
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List list = page.getData();
		responseDTO.setValue("datas", list);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	/**
	 * 查询报废申请固定资产信息
	 */
	public ISrvMsg getScrapeAssetInfoNew(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String queryAssetInfoSql="select app.* ,asset.* from dms_scrape_apply app left join dms_scrape_asset asset on  app.scrape_apply_id=" +
				"asset.scrape_apply_id where app.scrape_apply_id='"+scrape_apply_id+"'";
		Map deviceAssetMap = jdbcDao.queryRecordBySQL(queryAssetInfoSql.toString());
		if(deviceAssetMap!=null){
			responseDTO.setValue("deviceAssetMap", deviceAssetMap);
			
			String queryAssetForDeviceSql="select * from dms_scrape_detailed detailed where detailed.scrape_asset_id='"+deviceAssetMap.get("scrape_asset_id")+"'";
			List<Map> list = new ArrayList<Map>();
			list = jdbcDao.queryRecords(queryAssetForDeviceSql);
			responseDTO.setValue("datas", list);
		}
		//查询文件表
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type ='excel_content_asset' order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2= jdbcDao.queryRecords(sqlFiles);
		//文件数据
		responseDTO.setValue("fdataAsset", list2);//折损表对应附件
		
		String scrape_detailed_id =msg.getValue("scrape_detailed_id");
		String wz_name =msg.getValue("wz_name");
		String wz_id =msg.getValue("wz_id");
		String wz_scrape_type =msg.getValue("wz_scrape_type");
		String wz_dutyUnit =msg.getValue("wz_dutyUnit");
		String selectAllFlag =msg.getValue("selectAllFlag");
		String parameterSql = "";
		if(selectAllFlag!=null){
			if(selectAllFlag.equals("true")){//true 表示全选
				parameterSql +="and lf.scrape_detailed_id in(select d.scrape_detailed_id from dms_scrape_detailed d where scrape_type in('0','1') ";
				if(!wz_name.equals("")){
					parameterSql += " and dev_name like'%"+wz_name+"%'";
				}
				if(!wz_id.equals("")){
					parameterSql += " and dev_type like'%"+wz_id+"%'";
				}
				if(!wz_scrape_type.equals("")){
					parameterSql += " and scrape_type='"+wz_scrape_type+"'";
				}
				if(!wz_dutyUnit.equals("")){
					parameterSql += " and duty_unit like'%"+wz_dutyUnit+"%'";
				}
				parameterSql += "and scrape_apply_id='"+scrape_apply_id+"')";
			}else{//false 表示选个别设备
				if(scrape_detailed_id==null){
					parameterSql = " and 1=2";
				}else{
					scrape_detailed_id = "'"+scrape_detailed_id.replace(",", "','")+"'";
					parameterSql="and lf.scrape_detailed_id in("+scrape_detailed_id+")";
				}
			}
		}else{
			if(scrape_detailed_id==null){
				parameterSql = " and 1=2";
			}else{
				scrape_detailed_id = "'"+scrape_detailed_id.replace(",", "','")+"'";
				parameterSql="and lf.scrape_detailed_id in("+scrape_detailed_id+")";
			}
		}
		String sqlfile="select distinct t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t,DMS_SCRAPE_DETAILED_LINK_FILE lf "
				+ "where t.file_id=lf.file_id and t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type is null "+parameterSql;
		List<Map> fileListfj = new ArrayList<Map>();
		fileListfj= jdbcDao.queryRecords(sqlfile);
		responseDTO.setValue("fdatafj", fileListfj);//其他附件
		return responseDTO;
	}
	/**
	 * 查询报废申请固定资产信息
	 */
	public ISrvMsg getScrapeDamageInfoNew(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String queryAssetInfoSql="select app.* ,asset.* from dms_scrape_apply app left join dms_scrape_damage asset on  app.scrape_apply_id=" +
				"asset.scrape_apply_id where app.scrape_apply_id='"+scrape_apply_id+"'";
		Map deviceAssetMap = jdbcDao.queryRecordBySQL(queryAssetInfoSql.toString());
		if(deviceAssetMap!=null){
			responseDTO.setValue("deviceAssetMap", deviceAssetMap);
			
			String queryAssetForDeviceSql="select * from dms_scrape_detailed detailed where detailed.scrape_asset_id='"+deviceAssetMap.get("scrape_asset_id")+"'";
			List<Map> list = new ArrayList<Map>();
			list = jdbcDao.queryRecords(queryAssetForDeviceSql);
			responseDTO.setValue("datas", list);
		}
		//查询文件表
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type ='excel_content_damage' order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2= jdbcDao.queryRecords(sqlFiles);
		//文件数据
		responseDTO.setValue("fdataAsset", list2);//折损表对应附件
		
		String scrape_detailed_id =msg.getValue("scrape_detailed_id");
		String wz_name =msg.getValue("wz_name");
		String wz_id =msg.getValue("wz_id");
		String wz_scrape_type =msg.getValue("wz_scrape_type");
		String wz_dutyUnit =msg.getValue("wz_dutyUnit");
		String selectAllFlag =msg.getValue("selectAllFlag");
		String parameterSql = "";
		if(selectAllFlag!=null){
			if(selectAllFlag.equals("true")){//true 表示全选
				parameterSql +="and lf.scrape_detailed_id in(select d.scrape_detailed_id from dms_scrape_detailed d where scrape_type in('2','3')";
				if(!wz_name.equals("")){
					parameterSql += " and dev_name like'%"+wz_name+"%'";
				}
				if(!wz_id.equals("")){
					parameterSql += " and dev_type like'%"+wz_id+"%'";
				}
				if(!wz_scrape_type.equals("")){
					parameterSql += " and scrape_type='"+wz_scrape_type+"'";
				}
				if(!wz_dutyUnit.equals("")){
					parameterSql += " and duty_unit like'%"+wz_dutyUnit+"%'";
				}
				parameterSql += ")";
			}else{//false 表示选个别设备
				if(scrape_detailed_id==null){
					parameterSql = " and 1=2";
				}else{
					scrape_detailed_id = "'"+scrape_detailed_id.replace(",", "','")+"'";
					parameterSql="and lf.scrape_detailed_id in("+scrape_detailed_id+")";
				}
			}
		}else{
			if(scrape_detailed_id==null){
				parameterSql = " and 1=2";
			}else{
				scrape_detailed_id = "'"+scrape_detailed_id.replace(",", "','")+"'";
				parameterSql="and lf.scrape_detailed_id in("+scrape_detailed_id+")";
			}
		}
		String sqlfile="select distinct t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t,DMS_SCRAPE_DETAILED_LINK_FILE lf "
				+ "where t.file_id=lf.file_id and t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type is null "+parameterSql;
		List<Map> fileListfj = new ArrayList<Map>();
		fileListfj= jdbcDao.queryRecords(sqlfile);
		responseDTO.setValue("fdatafj", fileListfj);//其他附件
		return responseDTO;
	}
	//解决IN 参数超过1000问题
	private static String getString(String id,List<String> list){
		StringBuffer sb=new StringBuffer();
		String returnString="";
		if(list.size()==0||null==list){
		returnString=sb.append(id).append("=''").toString();
		} 
		for(int i=0;i<list.size();i++){
		if(i==0){
		sb.append(id);
		sb.append(" in (");
		}
		sb.append("'");
		sb.append(list.get(i).toString());
		sb.append("'");
		if(i>=900&&i<list.size()-1){
		if(i%900==0){
		sb.append(") or ");
		sb.append(id);
		sb.append(" in (");
		}else{
		sb.append(",");
		}
		}else{
		if(i<list.size()-1){
		sb.append(",");
		}
		}
		if(i==list.size()-1){
		sb.append(")");
		}
		}
		returnString=sb.toString();
		return returnString;
		}
	/**
	 *添加报废申请单基本信息
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg addScrapeListNew(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg respMsg = SrvMsgUtil.createResponseMsg(isrvmsg);
 		List publicList1 = new ArrayList();
		MQMsgImpl mqMsgAsset1 = (MQMsgImpl) isrvmsg;
		String errorMes = "";
		Boolean returnflag = false;//是否进入进入正常流程
		List<WSFile> filesAsset1 = mqMsgAsset1.getFiles();
		List<String> dev_codings=new ArrayList<String>();
		List<String> zcbfdev_codings=new ArrayList<String>();//正常报废erp编码集合
		List<String> otherdev_codings=new ArrayList<String>();//其他类型erp编码集合
		Map <String,String> key_dev_codings=new HashMap<String, String>();
		try {
			//处理附件
			for (WSFile file : filesAsset1) {
				String fileOrder = file.getKey().toString();
				if(fileOrder.equals("excel_content_public")){
					String filename = file.getFilename();
					//对比提交申请的excel上传的数据与审批的excel的数据是否存在差异
					publicList1 = getAllExcelDataByWSFile(file);
				 
					for(int i=0;i<publicList1.size();i++){
						Map map = (Map)publicList1.get(i);
						String erpId = map.get("dev_coding").toString();
						String scrape_type = map.get("scrape_type").toString();//报废类型
						if(scrape_type.equals("正常报废")){
							zcbfdev_codings.add(erpId);
						}else if(scrape_type.equals("毁损")||scrape_type.equals("盘亏")||scrape_type.equals("技术淘汰")){
							otherdev_codings.add(erpId);
						}
						dev_codings.add(erpId);
						key_dev_codings.put(erpId, "");
					}
					 
					//查看该erpid是否已经存在于台账表，如果在该表中已存在则允许系一步
					String queryScrapeInfoSql  ="select dev_coding  from (select dev_coding from gms_device_account_b "
							+ "union all "
							+ "select dev_coding from gms_device_account) account where  "+getString("dev_coding", dev_codings);
					List<Map> deviceMap = jdbcDao.queryRecords(queryScrapeInfoSql);
					if(deviceMap==null){
						errorMes = "名为《"+filename+"》的文件中全部的数据在台账中不存在，不能导入，请核实请核实后重新申请。";
						respMsg.setValue("errorMes",errorMes);
						returnflag = true;
						 
					}else{
						for (Map map : deviceMap) {
							key_dev_codings.remove(map.get("dev_coding"));
						}
						if(key_dev_codings.size()>0){
							 for (String entry : key_dev_codings.keySet()) {
									errorMes = "名为《"+filename+"》的文件中,编码为"+entry+"的数据在台账中不存在，不能导入，请核实请核实后重新申请。";
									respMsg.setValue("errorMes",errorMes);
									returnflag = true;
						            break;
						     }
						
						}
					}
					
//					//查看该erpid是否已经存在于详情表dtail，如果在该表中已存在并且审批通过则跳过
						String queryScrapesInfoSql ="select dev_coding  from dms_scrape_detailed dsd where (dsd.sp_pass_flag is null or dsd.sp_pass_flag='0') and dsd.bsflag='0' and  ("+getString("dev_coding", dev_codings)+" )";
						List<Map> devicesMap = jdbcDao.queryRecords(queryScrapesInfoSql);
					if(devicesMap!=null){
						errorMes = "名为《"+filename+"》的文件中,编码为"+devicesMap.get(0).get("dev_coding")+"的数据已存在，不能导入，请核实后重新申请。";
						respMsg.setValue("errorMes",errorMes);
						returnflag = true;
						 
					}
					
					String queryAccountNetValue1="select dev_coding1 dev_coding from(select table1.dev_coding dev_coding1,table2.dev_coding dev_coding2 from (with temp as (select "+ getString("", otherdev_codings).replace("in", "").replace("'", "").replace("(", "('").replace(")", "')") +"dev_coding from dual) select regexp_substr(dev_coding, '[0-9]+', 1, rn) dev_coding from temp t1, (select level rn from dual connect by rownum <= (select length(dev_coding) - length(replace(dev_coding, ',', '')) + 1 from temp)) t2) table1 left join (select dev_coding,net_value,ASSET_VALUE from gms_device_account acc where "+getString("dev_coding", otherdev_codings)+") table2 on table1.dev_coding = table2.dev_coding and table2.net_value!=0 ) where dev_coding2 is null ";
					List<Map> netValueMap1 = jdbcDao.queryRecords(queryAccountNetValue1);
					if(netValueMap1!=null){
						errorMes = "名为《"+filename+"》的文件中,编码为"+netValueMap1.get(0).get("dev_coding")+"的数据净值为空，请修改为正常报废类型！";
						respMsg.setValue("errorMes",errorMes);
						returnflag = true;
						 
					}
					
					String queryAccountNetValue="select dev_coding1 dev_coding from(select table1.dev_coding dev_coding1,table2.dev_coding dev_coding2 from (with temp as (select "+ getString("", zcbfdev_codings).replace("in", "").replace("'", "").replace("(", "('").replace(")", "')") +"dev_coding from dual) select regexp_substr(dev_coding, '[0-9]+', 1, rn) dev_coding from temp t1, (select level rn from dual connect by rownum <= (select length(dev_coding) - length(replace(dev_coding, ',', '')) + 1 from temp)) t2) table1 left join (select dev_coding,net_value,ASSET_VALUE from gms_device_account acc where "+getString("dev_coding", zcbfdev_codings)+") table2 on table1.dev_coding = table2.dev_coding and table2.net_value=0 ) where dev_coding2 is null ";
					List<Map> netValueMap = jdbcDao.queryRecords(queryAccountNetValue);
					if(netValueMap!=null){
						errorMes = "名为《"+filename+"》的文件中,编码为"+netValueMap.get(0).get("dev_coding")+"的数据净值不为空，请修改为非正常报废类型！";
						respMsg.setValue("errorMes",errorMes);
						returnflag = true;
						 
					}
					returnflag = true;
					
					
					 
				}
			}
			
		} catch (Exception e) {
			
		}
		if(returnflag)
		return respMsg;
		UserToken user = isrvmsg.getUserToken();
		Map<String,Object> mainMap = new HashMap<String,Object>();
		//获得报废申请单名称
		String scrape_apply_name=isrvmsg.getValue("scrape_apply_name");
		String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");
		String apply_date=isrvmsg.getValue("apply_date");
		String proStatus=isrvmsg.getValue("proStatus");
		//生成基本信息
		String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
		String scrape_apply_no = isrvmsg.getValue("scrape_apply_no");
		String scrapeApplyId="";//存储新增的插入的主键
		//如果是新增操作
		if("null".equals(scrape_apply_id)){
			//scrape_apply_no = CommonUtil.getScrapeAppNo();
			String sqlEmp="select decode(max(to_number(p.no)),null,'0',max(to_number(p.no))) as no"
					+ " from DMS_SCRAPE_APPLY p where p.bsflag='0' ";
			Map no = new HashMap();
			no= jdbcDao.queryRecordBySQL(sqlEmp);
			int nos = Integer.valueOf(no.get("no").toString())+1;
			scrape_apply_no = CommonUtil.getScrapeAppNoWithOrgName(user.getOrgName(),nos);
			mainMap.put("no", nos);
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
			//mainMap.put("employee_id", user.getEmpId());
			//mainMap.put("scrape_org_id", user.getOrgId());
			mainMap.put("modify_date", currentdate);
			mainMap.put("updatetor", user.getEmpId());
			mainMap.put("bsflag", CommonConstants.BSFLAG_NORMAL);
			//6.向数据库写入信息
			jdbcDao.saveOrUpdateEntity(mainMap, "DMS_SCRAPE_APPLY");
		}
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
						List qcList = new ArrayList();
						HashSet set = new HashSet();
						for(int i=0;i<publicList.size();i++){
							Map map = (Map)publicList.get(i);
							String scrape_type = map.get("scrape_type").toString();//
							//查看该erpid是否已经存在于详情表dtail，如果在该表中已存在并且审批通过则跳过
							String erpId = map.get("dev_coding").toString();
							//以下7行去重复erp编码程序
							qcList.add(erpId);
							set.addAll(qcList);
							if(set.size()!=qcList.size()){
								qcList.clear();
								qcList.addAll(set);
								continue;
							}
							//StringBuffer queryScrapeInfoSql = new StringBuffer();
							//queryScrapeInfoSql.append("select * from dms_scrape_detailed dsd where (dsd.sp_pass_flag is null or dsd.sp_pass_flag='0') and dsd.bsflag='0' and dev_coding ='"+erpId+"'");
							//Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
							//if(deviceMap!=null){
							//	continue;
							//}
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
		//filesAssetflag=true 表示添加了附件
		if(filesAssetflag||flag_public.equals("1")){
			long s_asset=new Date().getTime();
			GroupingHandle(assetList,assetId,null,scrapeApplyId,user);
			GroupingHandle(damageList,null,damageId,scrapeApplyId,user);
			long systime = System.currentTimeMillis();
			long e_asset=new Date().getTime();
			respMsg.setValue("time_asset",e_asset-s_asset);
			System.out.println("开始时间:"+s_asset+",结束时间:"+e_asset+",time:"+(e_asset-s_asset)+",系统时间:"+systime);
		}
		respMsg.setValue("proStatus",proStatus);
		return respMsg;
	}
	//分组处理方法
		public void GroupingHandle(final List<Map> assetLists,Serializable id,Serializable damageId,String scrape_apply_id,UserToken user){
			LinkedList<Map> subll = new LinkedList<Map>();// 下发的名单序列
			String userid=user.getSubOrgIDofAffordOrg();//所属单位隶属关系id
			int listcounts = 500;// 设定一次发送的条数
			if(userid.length()>10){
				userid=userid.substring(0, 10);
			}
			// 该递归循环用于每次发送<=1k条数据，当数据量大于1k时进行递归调用
			//account.owning_sub_id like '"+userid+"%' and 导入报废设备不区分部门 update 2016-12-01 by zjb
			//筛选时应加上设备状态using_stat是闲置0110000007000000002一条，以免把在用的设备给报废了。
			if (assetLists.size() > listcounts) {
				subll.addAll(assetLists.subList(0, listcounts));// 截取一次发送条数
				assetLists.removeAll(subll);// 除去发送的list
				for(int i = 0;i < subll.size(); i++){
					String dev_coding = subll.get(i).get("dev_coding").toString();//Amis资产编码
					StringBuffer queryScrapeInfoSql = new StringBuffer();
					queryScrapeInfoSql.append("select * from ("
							+ "select asset_coding,owning_sub_id,dev_name,asset_value,net_value,dev_sign,dev_type,license_num,producting_date,owning_org_id,dev_acc_id,dev_model,dev_coding "
							+ "from gms_device_account_b "
							+ "union all "
							+ "select asset_coding,owning_sub_id,dev_name,asset_value,net_value,dev_sign,dev_type,license_num,producting_date,owning_org_id,dev_acc_id,dev_model,dev_coding "
							+ "from gms_device_account) account "
							+ "where account.dev_coding='"+dev_coding+"'");
					Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
					if(deviceMap==null){
						assetLists.remove(i);
						i--;
					}else{
						subll.get(i).put("dev_name", (String) deviceMap.get("dev_name"));
						subll.get(i).put("asset_coding", (String) deviceMap.get("asset_coding"));
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
				}
				exebatchupdate(subll, id,damageId, scrape_apply_id);
				GroupingHandle(assetLists, id,damageId, scrape_apply_id,user);// 递归循环
			} else {// 当发送条数少于1k时发送完毕，结束，不再递归调用
				subll.addAll(assetLists);
				for(int i = 0;i < assetLists.size(); i++){
					String dev_coding = assetLists.get(i).get("dev_coding").toString();//Amis资产编码
					StringBuffer queryScrapeInfoSql = new StringBuffer();
					queryScrapeInfoSql.append("select * from ("
							+ "select asset_coding,owning_sub_id,dev_name,asset_value,net_value,dev_sign,dev_type,license_num,producting_date,owning_org_id,dev_acc_id,dev_model,dev_coding "
							+ "from gms_device_account_b "
							+ "union all "
							+ "select asset_coding,owning_sub_id,dev_name,asset_value,net_value,dev_sign,dev_type,license_num,producting_date,owning_org_id,dev_acc_id,dev_model,dev_coding "
							+ "from gms_device_account) account "
							+ "where account.dev_coding='"+dev_coding+"'");
					Map deviceMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
					if(deviceMap==null){
						assetLists.remove(i);
						i--;
					}else{
						assetLists.get(i).put("dev_name", (String) deviceMap.get("dev_name"));
						assetLists.get(i).put("asset_coding", (String) deviceMap.get("asset_coding"));
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
					+ "("+type+",SCRAPE_APPLY_ID,DEV_NAME,DEV_CODING,ASSET_CODING,"
					+ "ASSET_VALUE,DEV_SIGN,DEV_TYPE,LICENSE_NUM,PRODUCTING_DATE,"
					+ "SCRAPE_FLAG,ORG_ID,bak1,FOREIGN_DEV_ID,BSFLAG,"
					+ "SCRAPE_DETAILED_ID,DUTY_UNIT,SCRAPE_TYPE,DEV_MODEL,NET_VALUE,"
					+ "TEAM_NAME,PROJECT_NAME) "
					+ "values('"+id.toString()+"','"+scrape_apply_id+"',?,?,?,"
							+ "?,?,?,?,to_date(?,'yyyy-mm-dd'),"
							+ "'0',?,?,?,'"+CommonConstants.BSFLAG_NORMAL+"',"
							+ "?,?,?,?,?,"
							+ "?,?)";
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
					 
					String scrape_type = map.get("scrape_type").toString();//
					String duty_unit = map.get("duty_unit").toString();
					if(scrape_type.equals("正常报废")){
						scrape_type="0";
					}else if(scrape_type.equals("技术淘汰")){
						scrape_type="1";
					}else if(scrape_type.equals("毁损")){
						scrape_type="2";
					}else if(scrape_type.equals("盘亏")){
						scrape_type="3";
					}
					 
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
					String project_name = map.get("project_name").toString();//新增项目名和国家名
					ps.setString(1, dev_name);
					ps.setString(2, dev_coding);
					ps.setString(3, "");
					ps.setString(4, asset_value); 
					ps.setString(5, dev_sign);
					ps.setString(6,dev_type);
					ps.setString(7,license_num);
					ps.setString(8,producting_date);
					ps.setString(9,owning_org_id);
					ps.setString(10, "");
					ps.setString(11,dev_acc_id);
					ps.setString(12, UUID.randomUUID().toString().replaceAll("-", ""));
					ps.setString(13, duty_unit);
 					ps.setString(14,scrape_type);
					ps.setString(15,dev_model);
					ps.setString(16,net_value);
					ps.setString(17,"");
					ps.setString(18,project_name);
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
				Row row = sheet0.getRow(4);
				for (int m = 5; m < rows; m++) {
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
						if (n == 4 && blankflag < 4) {
							if(mapColumnInfoIn.get(1)==null){
								continue;
							}
							Map map = new HashMap();
							map.put("dev_name", mapColumnInfoIn.get(0)==null?"":mapColumnInfoIn.get(0));
							map.put("dev_coding", mapColumnInfoIn.get(1)==null?"":mapColumnInfoIn.get(1));//ERP设备编码
							map.put("scrape_type", mapColumnInfoIn.get(2)==null?"":mapColumnInfoIn.get(2));//
							map.put("duty_unit", mapColumnInfoIn.get(3)==null?"":mapColumnInfoIn.get(3));//责任单位
							map.put("project_name", mapColumnInfoIn.get(4)==null?"":mapColumnInfoIn.get(4));//项目名或者国家名
							dataList.add(map);
						}
					}
					if (blankflag == 4)
						break;
				}
			}
			return dataList;
		}
		/**
		 * 设备详情表关联专家、资产描述、资产报废及附件
		 * @param msg
		 * @return
		 * @throws Exception
		 */
		public ISrvMsg devLinkEmpAndFileNew(ISrvMsg msg) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
			UserToken user = msg.getUserToken();
			String scrape_type=msg.getValue("scrape_type");//报废类别 01 正常报废技术淘汰  23盘亏毁损
			String tableName = "";
			if(scrape_type.equals("01")){
				tableName = "dms_scrape_asset";
			}else if(scrape_type.equals("23")){
				tableName = "dms_scrape_damage";
			}
			//报废申请
			String scrape_apply_id=msg.getValue("scrape_apply_id");// 报废申请单ID
			String scrape_asset_id=msg.getValue("scrape_asset_id");// 报废固定资产ID
			String scrape_detailed_id=msg.getValue("scrape_detailed_id");//报废台账ID
			String asset_now_desc=msg.getValue("asset_now_desc");//资产现状描述
			String scrape_reason=msg.getValue("scrape_reason");//报废原因
			String duty_unit=msg.getValue("duty_unit");//责任单位
			//关联
			//将专家信息保存到专家表
			String expert_id=msg.getValue("expert_id");//专家表主键
			String expert_leader=msg.getValue("expert_leader");// 专家名称字符串
			String expert_leader_id=msg.getValue("expert_leader_id");//专家id
			//将专家信息更新到asset表中
			String updateAccountSql="update "+tableName+" asset set "
					+ "asset.asset_now_desc='"+asset_now_desc+"',"
					+ "asset.scrape_reason='"+scrape_reason+"',"
 					+ "asset.expert_leader='"+expert_leader+"',"
					+ "asset.expert_leader_id='"+expert_leader_id+"' "
					+ "where asset.scrape_apply_id ='"+scrape_apply_id+"'";
			jdbcDao.executeUpdate(updateAccountSql);
			//取消所有专家表
			/*
			String sub[] = scrape_detailed_id.substring(0, scrape_detailed_id.length()).split(",");
			List list = new ArrayList();
			List<HashMap<String, Object>> mapList = new ArrayList<HashMap<String,Object>>();
			for(int i=0;i<sub.length;i++){
				list.add(sub[i]);
			}
			if(list.size()>0)
			for(int i=0;i<list.size();i++){
				HashMap<String,Object> linkMap = new HashMap<String,Object>();
				Map<String,Object> expertMap = new HashMap<String,Object>();
				String deleteEmpSql = "delete DMS_SCRAPE_EMPLOYEE emp where emp.scrape_detailed_id = '"+list.get(i)+"'";
				jdbcDao.executeUpdate(deleteEmpSql);
				String deleteLinkSql = "delete DMS_SCRAPE_DETAILED_LINK_EMP t where t.scrape_detailed_id = '"+list.get(i)+"'";
				jdbcDao.executeUpdate(deleteLinkSql);
				expertMap.put("scrape_detailed_id", list.get(i).toString());
				expertMap.put("employee_id", expert_leader_id);
				expertMap.put("employee_name", expert_leader);
				expertMap.put("asset_now_desc", asset_now_desc);
				expertMap.put("scrape_reason", scrape_reason);
				expertMap.put("duty_unit", duty_unit);
				Serializable expertNewId= jdbcDao.saveOrUpdateEntity(expertMap, "DMS_SCRAPE_EMPLOYEE");
				linkMap.put("scrape_detailed_id", list.get(i).toString());
				linkMap.put("emp_id", expertNewId.toString());
				mapList.add(linkMap);
			}
			if(mapList.size()>0)
			for(int j=0;j<mapList.size();j++){
				String updateSql="insert into DMS_SCRAPE_DETAILED_LINK_EMP t (scrape_detailed_id,emp_id) values('"+mapList.get(j).get("scrape_detailed_id").toString()+"','"+mapList.get(j).get("emp_id").toString()+"')";;
				jdbcDao.executeUpdate(updateSql);
			}*/
			//保存附件并建立与设备的关联
			this.saveLinkdyncNew(msg);
			responseDTO.setValue("scrape_apply_id", scrape_apply_id);
		    return responseDTO;
		}
		
		/**
		 * 添加报废申请固定资产信息
		 * @param msg
		 * @return
		 * @throws Exception
		 */
		public ISrvMsg addScrapeAssetInfoNew(ISrvMsg msg) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
			UserToken user = msg.getUserToken();
			//报废申请
			String scrape_apply_id=msg.getValue("scrape_apply_id");// 报废申请单ID
			String scrape_asset_id=msg.getValue("scrape_asset_id");// 报废固定资产ID
			String proStatus=msg.getValue("proStatus");
			//固定资产报废台账信息保存
			Map<String,Object> assetMap = new HashMap<String,Object>();
			String currentdate = DateUtil.convertDateToString(DateUtil.getCurrentDate(),"yyyy-MM-dd HH:mm:ss");
			if(scrape_asset_id!=""&&scrape_asset_id.length()>0){
				assetMap.put("SCRAPE_ASSET_ID", scrape_asset_id);
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
			responseDTO.setValue("proStatus", proStatus);
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
		public ISrvMsg saveLinkdyncNew(ISrvMsg reqDTO) throws Exception {
			ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
			String currentdate = DateUtil.convertDateToString(
					DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
			UserToken user = reqDTO.getUserToken();
			String scrape_apply_id = reqDTO.getValue("scrape_apply_id");
			String scrape_type = reqDTO.getValue("scrape_type");
			String scrape_detailed_id = reqDTO.getValue("scrape_detailed_id");
			String wz_name =reqDTO.getValue("wz_name")==null?"":reqDTO.getValue("wz_name");
			wz_name = URLDecoder.decode(wz_name,"UTF-8");
			String wz_id =reqDTO.getValue("wz_id")==null?"":reqDTO.getValue("wz_id");
			String wz_scrape_type =reqDTO.getValue("wz_scrape_type")==null?"":reqDTO.getValue("wz_scrape_type");
			String wz_dutyUnit =reqDTO.getValue("wz_dutyUnit")==null?"":reqDTO.getValue("wz_dutyUnit");
			String emp_id =reqDTO.getValue("emp_id")==null?"":reqDTO.getValue("emp_id");
			String s_project_name =reqDTO.getValue("s_project_name")==null?"":reqDTO.getValue("s_project_name");
			s_project_name=URLDecoder.decode(s_project_name,"UTF-8");
			wz_dutyUnit = URLDecoder.decode(wz_dutyUnit,"UTF-8");
			emp_id=URLDecoder.decode(emp_id,"UTF-8");
			String selectAllFlag =reqDTO.getValue("selectAllFlag")==null?"":reqDTO.getValue("selectAllFlag");
			String parameterSql = "";
			List<Map> userList = new ArrayList<Map>();
			if(selectAllFlag!=null){//全选不为空则判定查询所有的设备
				if(selectAllFlag.equals("true")){//true 表示全选
					parameterSql +="select distinct scrape_detailed_id  from (select t.*,      case   when d.file_id is not null then      '已关联'    else   '未关联'      end as emp_id   from dms_scrape_detailed t  left join dms_scrape_detailed_link_file d    on t.scrape_detailed_id = d.scrape_detailed_id where bsflag = '0'";
					parameterSql += "and scrape_apply_id='"+scrape_apply_id+"'";
					 
					if(!wz_name.equals("")){
						parameterSql += " and dev_name like'%"+wz_name+"%'";
					}
					if(!wz_id.equals("")){
						parameterSql += " and dev_type like'%"+wz_id+"%'";
					}
					if(!wz_scrape_type.equals("")){
						parameterSql += " and scrape_type='"+wz_scrape_type+"'";
					}
					if(!("").equals(s_project_name)){
						parameterSql += " and PROJECT_NAME like '%"+s_project_name+"%'";
					}
					if(!wz_dutyUnit.equals("")){
						parameterSql += " and duty_unit like'%"+wz_dutyUnit+"%'";
					}
					parameterSql += " )";
					if(!emp_id.equals("")){
						parameterSql += " where emp_id ='"+emp_id+"'";
					}
					userList = jdbcDao.queryRecords(parameterSql);
					List<String> infoList=new ArrayList<String>();
					for (Map map : userList) {
						String sql = "delete from DMS_SCRAPE_DETAILED_LINK_FILE where scrape_detailed_id='"+map.get("scrape_detailed_id")+"'";
						infoList.add(sql);
					}
					String [] inserinfoSql= infoList.toArray(new String[infoList.size()]);
					if(inserinfoSql.length!=0){
						jdbcDao.getJdbcTemplate().batchUpdate(inserinfoSql);
					}
 				}else{//false 表示选个别设备
					String sub[] = scrape_detailed_id.substring(0, scrape_detailed_id.length()).split(",");
					for(String uid: sub){
						Map map =new HashMap();
						map.put("scrape_detailed_id", uid);
						userList.add(map);
					}
				}
			}else{//非全选获取scrape_detailed_id的数量
				String sub[] = scrape_detailed_id.substring(0, scrape_detailed_id.length()).split(",");
				for(String uid: sub){
					Map map =new HashMap();
					map.put("scrape_detailed_id", uid);
					userList.add(map);
				}
			}
			MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
			List<WSFile> files = mqMsg.getFiles();
			String idinfos = reqDTO.getValue("idinfos");//已有的附件的id
			//如果已经有附件，采取更新操作（先删除，再添加）
			if(files!=null&&files.size()>0){
				//处理附件
				try {
					//有新增的附件
					String file_type=jdbcDao.generateUUID();
					for (WSFile file : files) {
						String filename = file.getFilename();
						String fileOrder = file.getKey().toString().split("__")[1];
						MyUcm ucm = new MyUcm();
						String ucmDocId = ucm.uploadFile(file.getFilename(), file.getFileData());
		
						Map doc = new HashMap();
						doc.put("file_name", filename);
						//String fileType = reqDTO.getValue("doc_type__"+fileOrder);
						doc.put("file_type",file_type );
						doc.put("ucm_id", ucmDocId);
						doc.put("is_file", "1");
						doc.put("relation_id", scrape_apply_id);
						doc.put("bsflag", CommonConstants.BSFLAG_NORMAL);
						doc.put("create_date",currentdate);
						doc.put("creator_id",user.getUserId());
						doc.put("doc_common",wz_scrape_type);
						doc.put("org_id", user.getOrgId());
						doc.put("org_subjection_id", user.getSubOrgIDofAffordOrg());
						String docId = (String)jdbcDao.saveOrUpdateEntity(doc, "BGP_DOC_GMS_FILE");
						ucm.docVersion(docId, "1.0", ucmDocId, user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
						ucm.docLog(docId, "1.0", 1, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),filename);
						if(userList.size()>0){
							final List<Map> list =  userList;
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
									ps.setString(1, list.get(i).get("scrape_detailed_id").toString());
								}
								public int getBatchSize() {
									return list.size();
								}
							};
							int a[] = jdbcTemplate.batchUpdate(sql, setter);
							System.out.println(a.length);
						}
					}
					//历史附件的关联
					reqMsg.isSuccessRet();
				} catch (Exception e) {
					
				}
			}else{
				if(null!=idinfos){//已有的附件的id
					//删除操作
					String idinfo[] = idinfos.substring(0, idinfos.length()).split(",");
					String idinfoSql="";
					if(idinfo.length>0){
						idinfoSql+=" and file_id in(";
						for(int i=0;i<idinfo.length;i++){
							if(i==idinfo.length-1){
								idinfoSql+="'"+idinfo[i].toString()+"'";
							}else{
								idinfoSql+="'"+idinfo[i].toString()+"',";
							}
						}
						idinfoSql+=")";
					}else{
						idinfoSql=" and 1=2";
					}
					String deleteSql = "delete DMS_SCRAPE_DETAILED_LINK_FILE detailed where 1=1 "+idinfoSql;
					jdbcDao.executeUpdate(deleteSql);
					//添加操作
					for(int a=0;a<idinfo.length;a++){
						if(userList.size()>0&&""!=idinfo[a].toString()){
 							final List<Map> list =  userList;
							//去重
							HashSet h  =   new  HashSet(list); 
						    list.clear(); 
						    list.addAll(h);
						    System.out.println(list.size());
							JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
							String sql = "insert into DMS_SCRAPE_DETAILED_LINK_FILE"
									+ "(scrape_detailed_id,"
									+ "file_id) "
									+ "values(?,'"+idinfo[a]+"')";
							BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
								public void setValues(PreparedStatement ps, int i) throws SQLException {
									ps.setString(1, list.get(i).get("scrape_detailed_id").toString());
								}
								public int getBatchSize() {
									return list.size();
								}
							};
							int size[] = jdbcTemplate.batchUpdate(sql, setter);
							System.out.println(size.length);
						}
					}
				}
			}
			List<GmsDevice> nodes = new ArrayList<GmsDevice>();
			reqMsg.setValue("nodes", nodes);
			return reqMsg;
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
			String scrape_apply_id = msg.getValue("scrape_apply_id");
			String dev_type=msg.getValue("dev_type");
			String file_type=msg.getValue("file_type");
			String times=msg.getValue("times");
			StringBuffer querySql = new StringBuffer();
			String userid=user.getSubOrgIDofAffordOrg();
			
	String querysgllSql = "select distinct d.* from DMS_SCRAPE_DETAILED d,dms_scrape_detailed_link_file lf,bgp_doc_gms_file gf where d.bsflag = 0 and lf.scrape_detailed_id=d.scrape_detailed_id and gf.file_id=lf.file_id"
					+" and SCRAPE_APPLY_ID ='"+scrape_apply_id+"'"
					+" and file_type = '"+file_type+"'"
					+ "and SCRAPE_TYPE='"+dev_type+"'";
			page = pureJdbcDao.queryRecordsBySQL(querysgllSql, page);
			List docList = page.getData();
			responseDTO.setValue("datas", docList);
			responseDTO.setValue("totalRows", page.getTotalRow());
			responseDTO.setValue("pageSize", pageSize);
			return responseDTO;
		}
		 /**
		  * 获取原值净值总和根据条件
		  * @param msg
		  * @return
		  * @throws Exception
		  */
		public ISrvMsg getAssetNetValues(ISrvMsg msg) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
			UserToken user = msg.getUserToken();
			 
			String scrape_apply_id = msg.getValue("scrape_apply_id");
			String dev_type=msg.getValue("dev_type");
			String file_type=msg.getValue("file_type");
			String times=msg.getValue("times");
			StringBuffer querySql = new StringBuffer();
			String userid=user.getSubOrgIDofAffordOrg();
			
			String querysgllSql = " select sum(t1.asset_value) asset_value,sum(t1.net_value) net_value from gms_device_account t1, (select distinct d.* from DMS_SCRAPE_DETAILED d,dms_scrape_detailed_link_file lf,bgp_doc_gms_file gf where d.bsflag = 0 and lf.scrape_detailed_id=d.scrape_detailed_id and gf.file_id=lf.file_id"
					+" and SCRAPE_APPLY_ID ='"+scrape_apply_id+"'"
					+" and file_type = '"+file_type+"'"
					+ "and SCRAPE_TYPE='"+dev_type+"' ) t2 where t1.dev_coding=t2.dev_coding";
			Map map=jdbcDao.queryRecordBySQL(querysgllSql);
			responseDTO.setValue("asset_value", map.get("asset_value"));
			responseDTO.setValue("net_value", map.get("net_value"));
			return responseDTO;
		}
		
		/**
		 * 查询报废申请盘亏信息
		 * 查询报废申请固定资产信息 综合方法
		 */
		public ISrvMsg getScrapeAllInfoNew(ISrvMsg msg)throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
			//报废申请单号
			String scrape_apply_id=msg.getValue("scrape_apply_id");
			String queryAssetInfoSql="select app.* ,asset.* from dms_scrape_apply app left join dms_scrape_asset asset on  app.scrape_apply_id=" +
					"asset.scrape_apply_id where app.scrape_apply_id='"+scrape_apply_id+"'";
			Map deviceAssetMap = jdbcDao.queryRecordBySQL(queryAssetInfoSql.toString());
			if(deviceAssetMap!=null){
				responseDTO.setValue("deviceAssetMap", deviceAssetMap);//固定资产设备表
			}
			String queryAssetForDeviceSql=" select file_name,employee_name,coding_code_id,file_type,sum(asset_value)asset_value,sum(net_value)net_value,sum(count1)count,'('||scrape_type||')'||sum(count1)||'条'as code_name from(select count(distinct mm.dev_coding)count1,replace(wm_concat(distinct mm.employee_name),',','<br/>')as employee_name,wm_concat(distinct mm.file_id||'&'||mm.file_name)as file_name,case when wm_concat(distinct doc_common)='0'then'正常报废'when wm_concat(distinct doc_common)='1'then'技术淘汰'when wm_concat(distinct doc_common)='2'then'毁损'else'盘亏'end scrape_type,wm_concat(distinct file_type)file_type,wm_concat(distinct doc_common)coding_code_id,sum(asset_value)asset_value,sum(net_value)net_value from(select distinct(t.dev_coding),t.dev_name,t.dev_type,t.scrape_detailed_id,case when t.scrape_type='0'or t.scrape_type='1'then(select sa.expert_leader from DMS_SCRAPE_ASSET sa where sa.scrape_apply_id=t.scrape_apply_id)else(select sd.expert_leader from dms_scrape_damage sd where sd.scrape_apply_id=t.scrape_apply_id)end employee_name,filelink.file_id,filelink.file_name,filelink.doc_common,filelink.file_type,t.asset_value,t.net_value from dms_scrape_detailed t left join(select bdgf.*,files.scrape_detailed_id from dms_scrape_detailed_link_file files,bgp_doc_gms_file bdgf where files.file_id=bdgf.file_id and bdgf.bsflag='0')filelink on t.scrape_detailed_id=filelink.scrape_detailed_id where t.scrape_apply_id='"+scrape_apply_id+"'order by t.dev_name)mm group by doc_common,file_type order by mm.dev_name)group by file_name,employee_name,scrape_type,coding_code_id,file_type order by coding_code_id ";
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
			//查询申请单所有设备原值，净值
			String sql="select sum(asset_value) asset_value,sum(net_value) net_value from dms_scrape_detailed t where t.scrape_apply_id='"+scrape_apply_id+"'";
			Map map=jdbcDao.queryRecordBySQL(sql);
			responseDTO.setValue("asset_value", map.get("asset_value"));
			responseDTO.setValue("net_value", map.get("net_value"));
			return responseDTO;
		}
		/**
		 * 查询申请单报废信息
		 * 
		 */
	public ISrvMsg getScrapeInfoByEmployee(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		StringBuffer queryScrapeInfoSql = new StringBuffer();
		String userName=user.getUserName();// 登录人姓名
		queryScrapeInfoSql.append("select count(scrape_apply_id) as num from dms_scrape_apply p where p.scrape_apply_id in (select d.scrape_apply_id"
				+ " from (select a.expert_leader,a.scrape_apply_id,a.expert_desc from dms_scrape_asset  a"
				+ " union all select b.expert_leader,b.scrape_apply_id,b.expert_desc from dms_scrape_damage b) d"
				+ " where d.expert_desc is null and d.expert_leader   ='"+userName+"')");
		Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("num", deviceappMap.get("num").toString());
		}else{
			responseDTO.setValue("num",0);
		}
		return responseDTO;
	}
	/**
	 * 查询报废结果信息
	 * 
	 */
public ISrvMsg getDisposeInfoByEmployee(ISrvMsg isrvmsg) throws Exception {
	ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
	UserToken user = isrvmsg.getUserToken();
	StringBuffer queryScrapeInfoSql = new StringBuffer();
	String userName=user.getUserName();// 登录人姓名
	queryScrapeInfoSql.append("select count(dispose_method_id) as num from DMS_DISPOSE_METHOD p where  p.JIANDU_FLAG is null and p.jianduer_name='"+userName+"'");
	Map deviceappMap = jdbcDao.queryRecordBySQL(queryScrapeInfoSql.toString());
	if(deviceappMap!=null){
		responseDTO.setValue("num", deviceappMap.get("num").toString());
	}else{
		responseDTO.setValue("num",0);
	}
	return responseDTO;
}
	/**
	 * 相关专家查询报废申请列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapeApplyListForEmp(ISrvMsg isrvmsg) throws Exception {
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
		String scrape_apply_name = isrvmsg.getValue("scrape_apply_name");// 报废申请单名称
		String scrape_apply_no = isrvmsg.getValue("scrape_apply_no");// 报废申请单号
		String scrape_collect_id = isrvmsg.getValue("scrape_collect_id");// 报废汇总名称
		String scrape_report_id = isrvmsg.getValue("scrape_report_id");// 报废上报名称
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
		// 汇总单号
		if (StringUtils.isNotBlank(scrape_collect_id)) {
			querySql.append(" and t.scrape_collect_id  = '"+scrape_collect_id+"'");
		}
		// 上报单号
		if (StringUtils.isNotBlank(scrape_report_id)) {
			querySql.append(" and t.scrape_report_id  = '"+scrape_report_id+"'");
		}
		querySql.append(" and t.scrape_apply_id in (select d.scrape_apply_id"
				+ " from (select a.expert_desc,a.expert_leader,a.scrape_apply_id from dms_scrape_asset  a"
				+ " union all select b.expert_desc,b.expert_leader,b.scrape_apply_id from dms_scrape_damage b) d"
				+ " where d.expert_desc is null and d.expert_leader ='"+userName+"')");
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
	 * 查询报废申请的专家是否全部会签
	 */
	public ISrvMsg getScrapeEmpOpinionByEmp(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String userName=user.getUserName();// 登录人姓名
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
			queryScrapeInfoSql.append(" and 1=2 ");
		}
		queryScrapeInfoSql.append(" and employee_name='"+userName+"'");
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
	 * 查询指定设备下关联到的附件的信息
	 * **/
	public ISrvMsg getScrapeFileListCollect(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String org_name=msg.getValue("org_name");
		String dev_name=msg.getValue("dev_name");
		String dev_type=msg.getValue("dev_type");
		String project_name=msg.getValue("project_name");
		String scrape_type=msg.getValue("scrape_type");
		String scrape_apply_id1=msg.getValue("scrape_apply_id1");
		String times=msg.getValue("times");
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
		String querysgllSql = "select * from (select distinct bdgf.* from dms_scrape_detailed_link_file files,bgp_doc_gms_file bdgf where files.file_id = bdgf.file_id and "
				+ "files.scrape_detailed_id in (select scrape_detailed_id from DMS_SCRAPE_DETAILED where  1=1"
				+" and SCRAPE_APPLY_ID ='"+scrape_apply_id1+"'"
				+" and dev_name = '"+dev_name+"'"
				+" and dev_type = '"+dev_type+"'";
				if(StringUtils.isNotBlank(project_name)){
					querysgllSql+=" and project_name='"+project_name+"' ";
				}
				querysgllSql+=" and scrape_type='"+scrape_type+"'  ))";
		List docList = jdbcDao.queryRecords(querysgllSql);
		responseDTO.setValue("fdatafj", docList);
		return responseDTO;
	}
	/**
	 * 查询指定设备下关联到的附件数量
	 * **/
	public ISrvMsg getScrapeFileListCollectCount(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		String org_name=msg.getValue("org_name");
		String dev_name=msg.getValue("dev_name");
		String dev_type=msg.getValue("dev_type");
		String times=msg.getValue("times");
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
		String querysgllSql = "select count(distinct filelink.file_id) as num from (select bdgf.*, files.scrape_detailed_id from dms_scrape_detailed_link_file files,bgp_doc_gms_file bdgf where files.file_id = bdgf.file_id) filelink  where  filelink.scrape_detailed_id in (select scrape_detailed_id from DMS_SCRAPE_DETAILED where bsflag=0 "
				+" and SCRAPE_APPLY_ID in"
				+"(select SCRAPE_APPLY_ID from dms_scrape_apply app where app.scrape_org_id in (select org.org_id from comm_org_information org where org.org_name = '"+org_name+"'))"
				+" and dev_name = '"+dev_name+"'"
				+" and dev_type = '"+dev_type+"'"
				+" and to_char(sysdate, 'yyyy') - to_char(producting_date, 'yyyy') >= '"+time_start+"'"
				+" and to_char(sysdate, 'yyyy') - to_char(producting_date, 'yyyy') < '"+time_end+"')";
		Map deviceappMap = jdbcDao.queryRecordBySQL(querysgllSql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("num", deviceappMap.get("num").toString());
		}else{
			responseDTO.setValue("num",0);
		}
		return responseDTO;
	}
	//更新设备详情的审批通过状态
	public ISrvMsg updateDetailed(ISrvMsg isrvmsg) throws Exception{
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_detailed_ids=isrvmsg.getValue("scrape_detailed_ids");// 报废设备详情ID
		scrape_detailed_ids = scrape_detailed_ids.replace("'", "");
		final String sub[] = scrape_detailed_ids.substring(0, scrape_detailed_ids.length()-1).split(",");
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		String sql = "update DMS_SCRAPE_DETAILED set "
				+ "SP_PASS_FLAG = '0' "
		+ " where SCRAPE_DETAILED_ID=?";
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int a) throws SQLException {
					ps.setString(1, sub[a]);
			}
			public int getBatchSize() {
				return sub.length;
			}
		};
		jdbcTemplate.batchUpdate(sql, setter);
		return responseDTO;
	}
	/**
	 * 为时间轴查询报废上报列表信息
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
		String scrape_report_id = isrvmsg.getValue("scrape_report_id");// 报废申请主键
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
		//申请单id
		if (StringUtils.isNotBlank(scrape_report_id)&&!scrape_report_id.equals("null")) {
			querySql.append(" and t.scrape_report_id  = '"+scrape_report_id+"'");
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
	 * 根据总台账设备id获取设备详情表id
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevId(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String foreign_dev_id = isrvmsg.getValue("foreign_dev_id");// 总台账设备id
		StringBuffer querySql = new StringBuffer();
		querySql.append("select scrape_detailed_id from dms_scrape_detailed where bsflag=0 ");
		// 申请单名称
		if (StringUtils.isNotBlank(foreign_dev_id)) {
			querySql.append(" and foreign_dev_id = '"+foreign_dev_id+"'");
		}
		Map deviceappMap = jdbcDao.queryRecordBySQL(querySql.toString());
		if(deviceappMap!=null){
			responseDTO.setValue("scrape_detailed_id", deviceappMap.get("scrape_detailed_id").toString());
		}else{
			responseDTO.setValue("scrape_detailed_id",0);
		}
		return responseDTO;
	}
	/**
	 * 根据设备详情表id查询设备的报废申请信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getScrapeDisposeAllInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_detailed_id = isrvmsg.getValue("scrape_detailed_id");// 总台账设备id
		
//报废申请		
		StringBuffer queryScrapeAppSql = new StringBuffer();
		queryScrapeAppSql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as apply_status,emp.employee_name,org.org_name as org_name  from dms_scrape_apply t  left join common_busi_wf_middle t2 on t.scrape_apply_id=t2.business_id  and t2.bsflag='0'   left join comm_human_employee emp on t.employee_id = emp.employee_id  left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag='0'  ");
		/*queryScrapeAppSql.append("and t.scrape_org_id ='C6000000000045' ");*/
		if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryScrapeAppSql.append("and t.scrape_apply_id=(select detail.scrape_apply_id from DMS_SCRAPE_DETAILED detail where detail.bsflag=0 and detail.scrape_detailed_id ='"+scrape_detailed_id+"') ");
		}
		else{
			queryScrapeAppSql.append(" and 1=2 ");
		}
		queryScrapeAppSql.append("order by t.create_date desc");
		Map scrapeAppMap;//报废申请结果集
		scrapeAppMap = jdbcDao.queryRecordBySQL(queryScrapeAppSql.toString());
		responseDTO.setValue("scrapeAppMap",scrapeAppMap);
		
		StringBuffer queryScrapeAppEmpSql = new StringBuffer();
		queryScrapeAppEmpSql.append("select * from DMS_SCRAPE_EMPLOYEE p where 1 = 1 ");
		if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryScrapeAppEmpSql.append("and scrape_detailed_id  = '"+scrape_detailed_id+"'");
		}else{
			queryScrapeAppEmpSql.append("and 1=2 ");
		}
		Map scrapeAppEmpMap;//报废申请专家信息
		scrapeAppEmpMap = jdbcDao.queryRecordBySQL(queryScrapeAppEmpSql.toString()); 
		responseDTO.setValue("scrapeAppEmpMap",scrapeAppEmpMap);
		
		StringBuffer queryScrapeAppFlowSql = new StringBuffer();
		queryScrapeAppFlowSql.append("select t4.entity_id,t4.proc_name,t4.create_user_name,t3.node_name,decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState,t2.examine_user_name,t2.examine_start_date,subStr(t2.examine_end_date, 0, 16) examine_end_date,t1.is_open,t2.examine_info from wf_r_taskinst t1 inner join (select max(taskinst_id) taskinst_id,wmsys.wm_concat(examine_user_name) examine_user_name,max(examine_start_date) examine_start_date,max(examine_end_date) examine_end_date,max(examine_info) examine_info from wf_r_examineinst group by procinst_id, node_id) t2 on t1.entity_id = t2.taskinst_id ");
		/*queryScrapeAppSql.append("and t.scrape_org_id ='C6000000000045' ");*/
		if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryScrapeAppFlowSql.append("and t1.procinst_id =(select t.proc_inst_id from COMMON_BUSI_WF_MIDDLE t where business_id= (select detail.scrape_apply_id from DMS_SCRAPE_DETAILED detail where detail.scrape_detailed_id ='"+scrape_detailed_id+"')) ");
		}
		/*if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryScrapeAppFlowSql.append("and t1.procinst_id ='8ad830fb547a6e4801547ad889610018'");
		}*/
		else{
			queryScrapeAppFlowSql.append(" and 1=2 ");
		}
		queryScrapeAppFlowSql.append("inner join wf_d_node t3 on t1.node_id = t3.entity_id inner join wf_r_procinst t4 on t1.procinst_id = t4.entity_id order by t2.examine_end_date asc");
		List scrapeAppFlowList;//报废申请结果集
		scrapeAppFlowList = jdbcDao.queryRecords(queryScrapeAppFlowSql.toString());
		responseDTO.setValue("scrapeAppFlowList",scrapeAppFlowList);
		
//报废上报申请		
		StringBuffer queryScrapeRepSql = new StringBuffer();
		queryScrapeRepSql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as report_status,emp.employee_name,org.org_name as org_name  from dms_scrape_report t  left join common_busi_wf_middle t2 on t.scrape_report_id=t2.business_id  and t2.bsflag='0'   left join comm_human_employee emp on t.employee_id = emp.employee_id  left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag='0' ");
		/*queryScrapeRepSql.append("and t.scrape_org_id ='C6000000000045' ");*/

		if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryScrapeRepSql.append("and t.scrape_report_id=(select scrape_report_id  from dms_scrape_apply where   scrape_apply_id=(select detail.scrape_apply_id from DMS_SCRAPE_DETAILED detail where detail.scrape_detailed_id ='"+scrape_detailed_id+"')) ");
		}
		else{
			queryScrapeRepSql.append(" and 1=2 ");
		}
		queryScrapeRepSql.append("order by t.create_date desc");
		Map scrapeRepMap;//报废申请结果集
		scrapeRepMap = jdbcDao.queryRecordBySQL(queryScrapeRepSql.toString());
		responseDTO.setValue("scrapeRepMap",scrapeRepMap);
	
		StringBuffer queryscrapeRepFlowSql = new StringBuffer();
		queryscrapeRepFlowSql.append("select t4.entity_id,t4.proc_name,t4.create_user_name,t3.node_name,decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState,t2.examine_user_name,t2.examine_start_date,subStr(t2.examine_end_date, 0, 16) examine_end_date,t1.is_open,t2.examine_info from wf_r_taskinst t1 inner join (select max(taskinst_id) taskinst_id,wmsys.wm_concat(examine_user_name) examine_user_name,max(examine_start_date) examine_start_date,max(examine_end_date) examine_end_date,max(examine_info) examine_info from wf_r_examineinst group by procinst_id, node_id) t2 on t1.entity_id = t2.taskinst_id ");
		/*queryScrapeRepSql.append("and t.scrape_org_id ='C6000000000045' ");*/

		if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryscrapeRepFlowSql.append("and t1.procinst_id =(select t.proc_inst_id from COMMON_BUSI_WF_MIDDLE t where business_id=(select scrape_report_id  from dms_scrape_apply where   scrape_apply_id=(select detail.scrape_apply_id from DMS_SCRAPE_DETAILED detail where detail.scrape_detailed_id ='"+scrape_detailed_id+"'))) ");
		}
		/*if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryscrapeRepFlowSql.append("and t1.procinst_id ='8ad830fb547a6e4801547ad889610018'");
		}*/
		else{
			queryscrapeRepFlowSql.append(" and 1=2 ");
		}
		queryscrapeRepFlowSql.append("inner join wf_d_node t3 on t1.node_id = t3.entity_id inner join wf_r_procinst t4 on t1.procinst_id = t4.entity_id order by t2.examine_end_date asc");
		List scrapeRepFlowList;//报废申请结果集
		scrapeRepFlowList = jdbcDao.queryRecords(queryscrapeRepFlowSql.toString());
		responseDTO.setValue("scrapeRepFlowList",scrapeRepFlowList);
		
//报废处置申请		
		StringBuffer queryScrapeDisSql = new StringBuffer();
		queryScrapeDisSql.append("select t.*,(case when t2.proc_status='1' then '待审批' when t2.proc_status='3' then '审批通过' when t2.proc_status='4' then '审批不通过' else '未提交' end ) as dispose_status,emp.employee_name,org.org_name as org_name  from dms_dispose_apply t  left join common_busi_wf_middle t2 on t.dispose_apply_id=t2.business_id  and t2.bsflag='0'   left join comm_human_employee emp on t.employee_id = emp.employee_id  left join comm_org_information org on t.dispose_org_id = org.org_id where t.bsflag='0'");
		/*queryScrapeDisSql.append("and t.scrape_org_id ='C6000000000045' ");*/

		if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryScrapeDisSql.append(" and t.dispose_apply_id=(select detail.dispose_apply_id from DMS_SCRAPE_DETAILED detail where detail.scrape_detailed_id ='"+scrape_detailed_id+"') ");
		}
		else{
			queryScrapeDisSql.append(" and 1=2 ");
		}
		queryScrapeDisSql.append(" order by t.create_date desc");
		Map scrapeDisMap;//报废申请结果集
		scrapeDisMap = jdbcDao.queryRecordBySQL(queryScrapeDisSql.toString());
		responseDTO.setValue("scrapeDisMap",scrapeDisMap);
	
		StringBuffer queryscrapeDisFlowSql = new StringBuffer();
		queryscrapeDisFlowSql.append("select t4.entity_id,t4.proc_name,t4.create_user_name,t3.node_name,decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState,t2.examine_user_name,t2.examine_start_date,subStr(t2.examine_end_date, 0, 16) examine_end_date,t1.is_open,t2.examine_info from wf_r_taskinst t1 inner join (select max(taskinst_id) taskinst_id,wmsys.wm_concat(examine_user_name) examine_user_name,max(examine_start_date) examine_start_date,max(examine_end_date) examine_end_date,max(examine_info) examine_info from wf_r_examineinst group by procinst_id, node_id) t2 on t1.entity_id = t2.taskinst_id ");
		/*queryScrapeDisSql.append("and t.scrape_org_id ='C6000000000045' ");*/

		if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryscrapeDisFlowSql.append("and t1.procinst_id =(select t.proc_inst_id from COMMON_BUSI_WF_MIDDLE t where business_id= (select detail.dispose_apply_id from DMS_SCRAPE_DETAILED detail where detail.scrape_detailed_id ='"+scrape_detailed_id+"')) ");
		}
		/*if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryscrapeDisFlowSql.append("and t1.procinst_id ='8ad830fb547a6e4801547ad889610018'");
		}*/
		else{
			queryscrapeDisFlowSql.append(" and 1=2 ");
		}
		queryscrapeDisFlowSql.append("inner join wf_d_node t3 on t1.node_id = t3.entity_id inner join wf_r_procinst t4 on t1.procinst_id = t4.entity_id order by t2.examine_end_date asc");
		List scrapeDisFlowList;//报废申请结果集
		scrapeDisFlowList = jdbcDao.queryRecords(queryscrapeDisFlowSql.toString());
		responseDTO.setValue("scrapeDisFlowList",scrapeDisFlowList);
		
		return responseDTO;
	}
	/**
	 * 因特殊原因无法利用系统提供的报废申请审批明细信息，故添加这个方法
	 * 根据报废申请单号，获取报废审批明细
	 * **/
	public  ISrvMsg getScrapeApplyInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");// 总台账设备id
		
		StringBuffer queryScrapeAppFlowSql = new StringBuffer();
		queryScrapeAppFlowSql.append("select t4.entity_id,t4.proc_name,t4.create_user_name,t3.node_name,decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState,t2.examine_user_name,t2.examine_info,t2.examine_start_date,subStr(t2.examine_end_date, 0, 16) examine_end_date,t1.is_open,t2.examine_info from wf_r_taskinst t1 inner join (select max(taskinst_id) taskinst_id,wmsys.wm_concat(examine_user_name) examine_user_name,max(examine_start_date) examine_start_date,max(examine_end_date) examine_end_date,max(examine_info) examine_info from wf_r_examineinst group by procinst_id, node_id) t2 on t1.entity_id = t2.taskinst_id ");
		/*queryScrapeAppSql.append("and t.scrape_org_id ='C6000000000045' ");*/
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			queryScrapeAppFlowSql.append("and t1.procinst_id in (select t.proc_inst_id from COMMON_BUSI_WF_MIDDLE t where business_id='"+scrape_apply_id+"') ");
		}
		/*if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryScrapeAppFlowSql.append("and t1.procinst_id ='8ad830fb547a6e4801547ad889610018'");
		}*/
		else{
			queryScrapeAppFlowSql.append(" and 1=2 ");
		}
		queryScrapeAppFlowSql.append("inner join wf_d_node t3 on t1.node_id = t3.entity_id inner join wf_r_procinst t4 on t1.procinst_id = t4.entity_id order by t2.examine_end_date asc");
		List scrapeAppFlowList;//报废申请结果集
		scrapeAppFlowList = jdbcDao.queryRecords(queryScrapeAppFlowSql.toString());
		responseDTO.setValue("scrapeAppFlowList",scrapeAppFlowList);
		return responseDTO;
	}
	/**
	 * 更新报废设备所属单位 
	 * 2016年10月19日16:24:11
	 * zjb
	 */
	public ISrvMsg updateScrapeAccountOwn(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String ids=isrvmsg.getValue("ids");// 专家表ID
		String owning_org_id=isrvmsg.getValue("owning_org_id");//所属单位id
		String owning_sub_id=isrvmsg.getValue("owning_sub_id");//所属单位隶属关系
		String updateAccountSql="update gms_device_account account set account.owning_org_id='"+owning_org_id+"',account.owning_sub_id='"+owning_sub_id+"'  where account.dev_acc_id = '"+ids+"'";
		jdbcDao.executeUpdate(updateAccountSql);
		String updateAccountbSql="update gms_device_account_b account set account.owning_org_id='"+owning_org_id+"',account.owning_sub_id='"+owning_sub_id+"' where account.dev_acc_id = '"+ids+"'";
		jdbcDao.executeUpdate(updateAccountbSql);
		return responseDTO;
	}
	/**
	 * 查询报废申请固定资产信息--关联所有的本类设备01
	 */
	public ISrvMsg getScrapeAssetInfoNewAll(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String queryAssetInfoSql="select app.* ,asset.* from dms_scrape_apply app left join dms_scrape_asset asset on  app.scrape_apply_id=" +
				"asset.scrape_apply_id where app.scrape_apply_id='"+scrape_apply_id+"'";
		Map deviceAssetMap = jdbcDao.queryRecordBySQL(queryAssetInfoSql.toString());
		if(deviceAssetMap!=null){
			responseDTO.setValue("deviceAssetMap", deviceAssetMap);
			String queryAssetForDeviceSql="select * from dms_scrape_detailed detailed where detailed.scrape_type<2 and detailed.scrape_asset_id='"+deviceAssetMap.get("scrape_asset_id")+"'";
			List<Map> list = new ArrayList<Map>();
			list = jdbcDao.queryRecords(queryAssetForDeviceSql);
			responseDTO.setValue("datas", list);
		}
		//查询文件表
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type ='excel_content_asset' order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2= jdbcDao.queryRecords(sqlFiles);
		//文件数据
		responseDTO.setValue("fdataAsset", list2);//折损表对应附件
		
		String sqlEmp="select * from DMS_SCRAPE_EMPLOYEE t where 1=1 and t.id in( select  emp_id from ("
			+" select tmp.scrape_detailed_id, tmp.emp_id, row_number() over(partition by emp_id order by scrape_detailed_id desc) as seq"
			+" from (select e.emp_id,wmsys.wm_concat(e.scrape_detailed_id) over(partition by e.emp_id order by e.scrape_detailed_id) as scrape_detailed_id"
			+" from dms_scrape_detailed_link_emp e where e.scrape_detailed_id in (select scrape_detailed_id from "
			+ "dms_scrape_detailed detailed where detailed.scrape_type<2 and detailed.scrape_apply_id='"+scrape_apply_id+"')"
			+ ") tmp) tmp2"
			+" where tmp2.seq = 1)";
			
		List<Map> ListEmp = new ArrayList<Map>();
		String expert_ids="";
		String employee_names ="";
		String employee_ids="";
		ListEmp= jdbcDao.queryRecords(sqlEmp);
		if(ListEmp.size()>0){
			responseDTO.setValue("deviceEmpMap", ListEmp.get(0));//其他附件
		}else{
			responseDTO.setValue("deviceEmpMap", "");//其他附件
		}
		
		String sqlfile="select distinct t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t,DMS_SCRAPE_DETAILED_LINK_FILE lf "
				+ "where t.file_id=lf.file_id and t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type is null and lf.scrape_detailed_id in(select scrape_detailed_id from "
			+ "dms_scrape_detailed detailed where detailed.scrape_type<2 and detailed.scrape_apply_id='"+scrape_apply_id+"')";
		List<Map> fileListfj = new ArrayList<Map>();
		fileListfj= jdbcDao.queryRecords(sqlfile);
		responseDTO.setValue("fdatafj", fileListfj);//其他附件
		return responseDTO;
	}
	/**
	 * 查询报废申请固定资产信息--关联所有的本类设备23
	 */
	public ISrvMsg getScrapeDamageInfoNewAll(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		//报废申请单号
		String scrape_apply_id=msg.getValue("scrape_apply_id");
		String queryAssetInfoSql="select app.* ,asset.* from dms_scrape_apply app left join dms_scrape_damage asset on  app.scrape_apply_id=" +
				"asset.scrape_apply_id where app.scrape_apply_id='"+scrape_apply_id+"'";
		Map deviceAssetMap = jdbcDao.queryRecordBySQL(queryAssetInfoSql.toString());
		if(deviceAssetMap!=null){
			responseDTO.setValue("deviceAssetMap", deviceAssetMap);
			String queryAssetForDeviceSql="select * from dms_scrape_detailed detailed where detailed.scrape_type<2 and detailed.scrape_asset_id='"+deviceAssetMap.get("scrape_asset_id")+"'";
			List<Map> list = new ArrayList<Map>();
			list = jdbcDao.queryRecords(queryAssetForDeviceSql);
			responseDTO.setValue("datas", list);
		}
		//查询文件表
		String sqlFiles="select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type ='excel_content_asset' order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2= jdbcDao.queryRecords(sqlFiles);
		//文件数据
		responseDTO.setValue("fdataAsset", list2);//折损表对应附件
		
		String sqlEmp="select * from DMS_SCRAPE_EMPLOYEE t where 1=1 and t.id in( select  emp_id from ("
			+" select tmp.scrape_detailed_id, tmp.emp_id, row_number() over(partition by emp_id order by scrape_detailed_id desc) as seq"
			+" from (select e.emp_id,wmsys.wm_concat(e.scrape_detailed_id) over(partition by e.emp_id order by e.scrape_detailed_id) as scrape_detailed_id"
			+" from dms_scrape_detailed_link_emp e where e.scrape_detailed_id in (select scrape_detailed_id from "
			+ "dms_scrape_detailed detailed where detailed.scrape_type>=2 and detailed.scrape_apply_id='"+scrape_apply_id+"')"
			+ ") tmp) tmp2"
			+" where tmp2.seq = 1)";
			
		List<Map> ListEmp = new ArrayList<Map>();
		String expert_ids="";
		String employee_names ="";
		String employee_ids="";
		ListEmp= jdbcDao.queryRecords(sqlEmp);
		if(ListEmp.size()>0){
			responseDTO.setValue("deviceEmpMap", ListEmp.get(0));//其他附件
		}else{
			responseDTO.setValue("deviceEmpMap", "");//其他附件
		}
		
		String sqlfile="select distinct t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t,DMS_SCRAPE_DETAILED_LINK_FILE lf "
				+ "where t.file_id=lf.file_id and t.relation_id='"+scrape_apply_id+"' and t.bsflag='0' and t.is_file='1' "
				+ "and t.file_type is null and lf.scrape_detailed_id in(select scrape_detailed_id from "
			+ "dms_scrape_detailed detailed where detailed.scrape_type>=2 and detailed.scrape_apply_id='"+scrape_apply_id+"')";
		List<Map> fileListfj = new ArrayList<Map>();
		fileListfj= jdbcDao.queryRecords(sqlfile);
		responseDTO.setValue("fdatafj", fileListfj);//其他附件
		return responseDTO;
	}
	/**
	 * 设备详情表关联专家、资产描述、资产报废及附件-zjb 不区分导入的设备id 只找到类别和在该申请单id下的设备
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg devLinkEmpAndFileNewAll(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		UserToken user = msg.getUserToken();
		//报废申请
		String scrape_apply_id=msg.getValue("scrape_apply_id");// 报废申请单ID
		String scrape_asset_id=msg.getValue("scrape_asset_id");// 报废固定资产ID
		//String scrape_detailed_id=msg.getValue("scrape_detailed_id");//报废台账ID
		String asset_now_desc=msg.getValue("asset_now_desc");//资产现状描述
		String scrape_reason=msg.getValue("scrape_reason");//报废原因
		String duty_unit=msg.getValue("duty_unit");//责任单位
		String scrape_type=msg.getValue("scrape_type");//报废类别 01 正常报废技术淘汰  23盘亏毁损
		if(scrape_type.equals("01")){
			scrape_type = " and d.scrape_type <2";
		}else if(scrape_type.equals("23")){
			scrape_type = " and d.scrape_type >=2";
		}else{
			scrape_type = "";
		}
		//关联
		//将专家信息保存到专家表
		String expert_id=msg.getValue("expert_id");//专家表主键
		String expert_leader=msg.getValue("expert_leader");// 专家名称字符串
		String expert_leader_id=msg.getValue("expert_leader_id");//专家id
		List<Map> list = new ArrayList();
		final List<HashMap<String, Object>> mapList = new ArrayList<HashMap<String,Object>>();
		String sqlDetail="select d.scrape_detailed_id from DMS_SCRAPE_DETAILED d "
				+ "where d.scrape_apply_id='"+scrape_apply_id+"'"+scrape_type;
		list= jdbcDao.queryRecords(sqlDetail);
		String deleteEmpSql = "delete DMS_SCRAPE_EMPLOYEE emp where "
				+ "emp.scrape_detailed_id in(select d.scrape_detailed_id from DMS_SCRAPE_DETAILED d where d.scrape_apply_id='"+scrape_apply_id+"'"+scrape_type+")";
		jdbcDao.executeUpdate(deleteEmpSql);
		String deleteLinkSql = "delete DMS_SCRAPE_DETAILED_LINK_EMP t where "
				+ "t.scrape_detailed_id in(select d.scrape_detailed_id from DMS_SCRAPE_DETAILED d where d.scrape_apply_id='"+scrape_apply_id+"'"+scrape_type+")";
		jdbcDao.executeUpdate(deleteLinkSql);
		if(list.size()>0)
		for(int i=0;i<list.size();i++){
			HashMap<String,Object> linkMap = new HashMap<String,Object>();
			Map<String,Object> expertMap = new HashMap<String,Object>();
			expertMap.put("scrape_detailed_id", list.get(i).get("scrape_detailed_id").toString());
			expertMap.put("employee_id", expert_leader_id);
			expertMap.put("employee_name", expert_leader);
			expertMap.put("asset_now_desc", asset_now_desc);
			expertMap.put("scrape_reason", scrape_reason);
			expertMap.put("duty_unit", duty_unit);
			expertMap.put("employee_opinion", "符合报废条件,同意报废");
			Serializable expertNewId= jdbcDao.saveOrUpdateEntity(expertMap, "DMS_SCRAPE_EMPLOYEE");
			linkMap.put("scrape_detailed_id", list.get(i).get("scrape_detailed_id").toString());
			linkMap.put("emp_id", expertNewId.toString());
			mapList.add(linkMap);
		}
		/*批处理*/
		if(mapList.size()>0)
			this.exebatchupdateDetLinkEmp(mapList);
//		for(int j=0;j<mapList.size();j++){
//			String updateSql="insert into DMS_SCRAPE_DETAILED_LINK_EMP t (scrape_detailed_id,emp_id) values('"+mapList.get(j).get("scrape_detailed_id").toString()+"','"+mapList.get(j).get("emp_id").toString()+"')";;
//			jdbcDao.executeUpdate(updateSql);
//		}
		this.saveLinkdyncNewAll(msg,list);
		responseDTO.setValue("scrape_apply_id", scrape_apply_id);
	    return responseDTO;
	}
	public void exebatchupdateDetLinkEmp(final List<HashMap<String, Object>> assetLists){
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		String type="";
		String sqls = "insert into DMS_SCRAPE_DETAILED_LINK_EMP(scrape_detailed_id,emp_id) "
				+ "values(?,?)";
		long starttime=new Date().getTime();
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map map = null;
				try {
					map = (Map)assetLists.get(i);
				} catch (Exception e) {
				}
				String scrape_detailed_id = map.get("scrape_detailed_id").toString();
				String emp_id = map.get("emp_id").toString();//ERP设备编码
				ps.setString(1, scrape_detailed_id);
				ps.setString(2, emp_id);
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
	 * 保存附件并建立与设备的关联
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 * @author zjb
	 */
	public ISrvMsg saveLinkdyncNewAll(ISrvMsg reqDTO,List<Map> detailList) throws Exception {
		final List<Map> list = detailList;
		ISrvMsg reqMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		UserToken user = reqDTO.getUserToken();
		String scrape_apply_id = reqDTO.getValue("scrape_apply_id");
		MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
		List<WSFile> files = mqMsg.getFiles();
		String idinfos = reqDTO.getValue("idinfos");//已有的附件的id
		//如果已经有附件，采取更新操作（先删除，再添加）
		if(files!=null&&files.size()>0){
			//处理附件
			try {
				//有新增的附件
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
					if(list.size()>0){
						JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
						String sql = "insert into DMS_SCRAPE_DETAILED_LINK_FILE"
								+ "(scrape_detailed_id,"
								+ "file_id) "
								+ "values(?,'"+docId+"')";
						BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
							public void setValues(PreparedStatement ps, int i) throws SQLException {
								ps.setString(1, list.get(i).get("scrape_detailed_id").toString());
							}
							public int getBatchSize() {
								return list.size();
							}
						};
						int a[] = jdbcTemplate.batchUpdate(sql, setter);
						System.out.println(a.length);
					}
				}
				//历史附件的关联
				reqMsg.isSuccessRet();
			} catch (Exception e) {
				
			}
		}else{
			if(null!=idinfos){//已有的附件的id
				//删除操作
				String idinfo[] = idinfos.substring(0, idinfos.length()).split(",");
				String idinfoSql="";
				if(idinfo.length>0){
					idinfoSql+=" and file_id in(";
					for(int i=0;i<idinfo.length;i++){
						if(i==idinfo.length-1){
							idinfoSql+="'"+idinfo[i].toString()+"'";
						}else{
							idinfoSql+="'"+idinfo[i].toString()+"',";
						}
					}
					idinfoSql+=")";
				}else{
					idinfoSql=" and 1=2";
				}
				String deleteSql = "delete DMS_SCRAPE_DETAILED_LINK_FILE detailed where 1=1 "+idinfoSql;
				jdbcDao.executeUpdate(deleteSql);
				//添加操作
				for(int a=0;a<idinfo.length;a++){
					if(list.size()>0&&""!=idinfo[a].toString()){
					    System.out.println(list.size());
						JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
						String sql = "insert into DMS_SCRAPE_DETAILED_LINK_FILE"
								+ "(scrape_detailed_id,"
								+ "file_id) "
								+ "values(?,'"+idinfo[a]+"')";
						BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
							public void setValues(PreparedStatement ps, int i) throws SQLException {
								ps.setString(1, list.get(i).get("scrape_detailed_id").toString());
							}
							public int getBatchSize() {
								return list.size();
							}
						};
						int size[] = jdbcTemplate.batchUpdate(sql, setter);
						System.out.println(size.length);
					}
				}
			}
		}
		List<GmsDevice> nodes = new ArrayList<GmsDevice>();
		reqMsg.setValue("nodes", nodes);
		return reqMsg;
	}
	/**
	 * 查询报废设备信息 zjb
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryScrapeInfoNew(ISrvMsg isrvmsg) throws Exception {
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
		String scrape_report_id = isrvmsg.getValue("scrape_report_id");// 报废申请主键
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
		//申请单id
		if (StringUtils.isNotBlank(scrape_report_id)&&!scrape_report_id.equals("null")) {
			querySql.append(" and t.scrape_report_id  = '"+scrape_report_id+"'");
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
	 * 根据报废申请单号查询公司部分的审批信息
	 * zjb 2017年11月20日17:02:32
	 * **/
	public  ISrvMsg getScrapeApplyCompanyInfo(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String scrape_apply_id = isrvmsg.getValue("scrape_apply_id");// 总台账设备id
		
		StringBuffer queryScrapeAppFlowSql = new StringBuffer();
		queryScrapeAppFlowSql.append("select "
				+ "'' as entity_id,"
				+ "'' as proc_name,"
				+ "'' as create_user_name,"
				+ "'报废评审(设备物资科)' as node_name, "
				+ "decode(app.scrape_collect_id, '', '未评审', '已评审') curState,"
				+ "'' as examine_user_name,"
				+ "'' as examine_start_date,"
				+ "'' as examine_end_date, "
				+ "'' as is_open,"
				+ "'' as examine_info from dms_scrape_apply app where app.scrape_apply_id='"+scrape_apply_id+"'");
		queryScrapeAppFlowSql.append(" union all select"
				+ " '' as entity_id,"
				+ " '' as proc_name,"
				+ " '' as create_user_name,"
				+ " '报废批复(设备物资科)' as node_name,"
				+ " (case"
				+ " when t2.proc_status = '1' then '待审批，详情如下'"
				+ " when t2.proc_status = '3' then '审批通过，详情如下'"
				+ " when t2.proc_status = '4' then '审批不通，过详情如下'"
				+ " else '未提交' end) as curState,"
				+ " '' as examine_user_name,"
				+ " '' as examine_start_date,"
				+ " '' as examine_end_date,"
				+ " '' as is_open,"
				+ " '' as examine_info"
				+ " from dms_scrape_apply app"
				+ " left join common_busi_wf_middle t2 on t2.business_id = app.scrape_report_id "
				+ " and t2.business_id in(select scrape_report_id"
				+ " from dms_scrape_apply a"
				+ " where a.scrape_apply_id ='"+scrape_apply_id+"')" 
				+ " where app.scrape_apply_id ='"+scrape_apply_id+"'");
		queryScrapeAppFlowSql.append(" union all select * from(select "
				+ "t4.entity_id,"
				+ "t4.proc_name,"
				+ "t4.create_user_name,"
				+ "t3.node_name,"
				+ "decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState,"
				+ "t2.examine_user_name,"
				+ "t2.examine_start_date,"
				+ "subStr(t2.examine_end_date, 0, 16) examine_end_date,"
				+ "t1.is_open,"
				+ "t2.examine_info from wf_r_taskinst t1 inner join (select max(taskinst_id) taskinst_id,wmsys.wm_concat(examine_user_name) examine_user_name,max(examine_start_date) examine_start_date,max(examine_end_date) examine_end_date,max(examine_info) examine_info from wf_r_examineinst group by procinst_id, node_id) t2 on t1.entity_id = t2.taskinst_id ");
		/*queryScrapeAppSql.append("and t.scrape_org_id ='C6000000000045' ");*/
		if (StringUtils.isNotBlank(scrape_apply_id)) {
			queryScrapeAppFlowSql.append("and t1.procinst_id in (select t.proc_inst_id from COMMON_BUSI_WF_MIDDLE t where "
					+ "business_id in(select scrape_report_id from dms_scrape_apply app where app.scrape_apply_id='"+scrape_apply_id+"')) ");
		}
		/*if (StringUtils.isNotBlank(scrape_detailed_id)) {
			queryScrapeAppFlowSql.append("and t1.procinst_id ='8ad830fb547a6e4801547ad889610018'");
		}*/
		else{
			queryScrapeAppFlowSql.append(" and 1=2 ");
		}
		queryScrapeAppFlowSql.append("inner join wf_d_node t3 on t1.node_id = t3.entity_id inner join wf_r_procinst t4 on t1.procinst_id = t4.entity_id order by t2.examine_end_date asc)");
		List scrapeAppFlowList;//报废申请结果集
		scrapeAppFlowList = jdbcDao.queryRecords(queryScrapeAppFlowSql.toString());
		responseDTO.setValue("scrapeAppFlowList",scrapeAppFlowList);
		return responseDTO;
	}
}
