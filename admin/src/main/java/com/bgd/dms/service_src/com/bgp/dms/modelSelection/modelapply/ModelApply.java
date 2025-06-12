package com.bgp.dms.modelSelection.modelapply;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

@SuppressWarnings("unused")
public class ModelApply extends BaseService{
	IBaseDao baseDao = BeanFactory.getBaseDao();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private IJdbcDao ijdbcDao = BeanFactory.getQueryJdbcDAO();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	
	
	/**
	 * 供应商列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg addeditEvaluate(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		 
		String [] ids=isrvmsg.getValue("ids").split(",");
	 
		StringBuffer querySql = new StringBuffer();
		querySql.append("select d.coding_name,coding_code_id from comm_coding_sort_detail d where d.coding_sort_id='5110000227'");
		List<Map> maps=jdbcDao.queryRecords(querySql.toString());
		for (Map map : maps) {
			for( int i=0;i<ids.length;i++){
				if(StringUtils.isNotBlank(ids[i])){
					map.put("aa"+ids[i], "0");
				}
			}
		}
		responseDTO.setValue("datas", maps);
		return responseDTO;
	}
	/**
	 * 供应商列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg queryModelList(ISrvMsg isrvmsg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		 
		//获取当前页
	 
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
		String enterprise_name = isrvmsg.getValue("enterprise_name");		// 供应商名称
	 
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select  company_code company_id,t.enterprise_name from dms_selection_company t where t.bsflag = '0' ");
		// 供应商名称
		if (StringUtils.isNotBlank(enterprise_name)) {
			querySql.append(" and t.enterprise_name  like '%"+enterprise_name+"%'");
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
	 * 选型申请列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg queryModelApplyList(ISrvMsg isrvmsg) throws Exception {
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
		String opi_name = isrvmsg.getValue("opi_name");			// 产品名称
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select t.* from dms_selection_opi t where t.bsflag='0' ");
		// 申请单名称
		if (StringUtils.isNotBlank(apply_unit)) {
			querySql.append(" and t.apply_unit  like '%"+apply_unit+"%'");
		}
		// 申请单号
		if (StringUtils.isNotBlank(opi_name)) {
			querySql.append(" and t.opi_name  like '%"+opi_name+"%'");
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
	 * 设备改造申请列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg queryModelChangeList(ISrvMsg isrvmsg) throws Exception {
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
		querySql.append(" select t.* from dms_device_modelchange t where t.bsflag='0' ");
		// 申请单名称
		if (StringUtils.isNotBlank(apply_unit)) {
			querySql.append(" and t.apply_unit  like '%"+apply_unit+"%'");
		}
		// 申请单号
		if (StringUtils.isNotBlank(project_name)) {
			querySql.append(" and t.project_name  like '%"+project_name+"%'");
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
	 * 主要成员列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg queryMainMemberList(ISrvMsg isrvmsg) throws Exception {
		
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
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select t.* from DMS_SELECTION_COMPANY_PER t where t.bsflag='0' ");
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
	 * 主要设备列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg queryMainEquipmentList(ISrvMsg isrvmsg) throws Exception {

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
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select t.* from DMS_SELECTION_COMPANY_EQU t where t.bsflag='0' ");
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
	 * 获取企业列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg queryEquipmentInfoList(ISrvMsg isrvmsg) throws Exception {
		
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
		StringBuffer querySql = new StringBuffer();
		String companyName=isrvmsg.getValue("companyName");
		querySql.append(" select t.* from dms_selection_company t where t.bsflag='0' ");
		if(StringUtils.isNotBlank(companyName)){
			querySql.append(" and t.enterprise_name like '%"+companyName+"%'");
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
	 * 评审列表信息
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg queryReviewList(ISrvMsg isrvmsg) throws Exception {
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
		String opi_name = isrvmsg.getValue("opi_name");			// 产品名称
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select t.* from dms_selection_opi t where t.bsflag='0' and review_state like '%评审%'");
		// 申请单名称
		if (StringUtils.isNotBlank(apply_unit)) {
			querySql.append(" and t.apply_unit  like '%"+apply_unit+"%'");
		}
		// 申请单号
		if (StringUtils.isNotBlank(opi_name)) {
			querySql.append(" and t.opi_name  like '%"+opi_name+"%'");
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
	 * 设备参数
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg queryEquipmentPar(ISrvMsg isrvmsg) throws Exception {
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
		String parameter_name = isrvmsg.getValue("parameter_name");		// 设备名称
		StringBuffer querySql = new StringBuffer();
		querySql.append(" select p.* from dms_equipment_parameters p where p.bsflag='0' ");
		// 申请单名称
		if (StringUtils.isNotBlank(parameter_name)) {
			querySql.append(" and p.parameter_name = '"+parameter_name+"'");
		}
		String id = isrvmsg.getValue("id");		// 查询设备类型id
		if(id !=null){
			if(id.equals("1")){
				id ="";
			}
		}
		// 根据当前菜单节点id查询
		if (StringUtils.isNotBlank(id)) {
			querySql.append(" and p.CURRENT_DEVICE_TYPE_ID = '"+id+"'");
		}
		//添加排序
		querySql.append(" order by p.no asc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * 勘探名录
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("rawtypes")
	public ISrvMsg queryExplorationList(ISrvMsg isrvmsg) throws Exception {
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
		String parameter_name = isrvmsg.getValue("parameter_name");		// 参数名称
		StringBuffer querySql = new StringBuffer();
		querySql.append("select * from DMS_EXPLORATION_LIST l  where l.bsflag='0' ");
		// 申请单名称
		if (StringUtils.isNotBlank(parameter_name)) {
			querySql.append(" and l.equipment_name  like '%"+parameter_name+"%'");
		}
		String id = isrvmsg.getValue("id");		// 查询设备类型id
		if(id !=null){
			if(id.equals("1")){
				id ="";
			}
		}
		// 设备类型
		if (StringUtils.isNotBlank(id)) {
			querySql.append(" and l.current_device_type_id = '"+id+"'");
		}
		//添加排序
		querySql.append(" order by l.equipment_id desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		
		
		// 查询文件表
		/*String sqlFiles = "select t.file_id,t.file_name,t.file_type from bgp_doc_gms_file t where t.relation_id='"
				+ opi_id + "' and t.bsflag='0' and t.is_file='1' ";
		// + "and order by t.order_num";
		List<Map> list2 = new ArrayList<Map>();
		list2 = jdbcDao.queryRecords(sqlFiles);
		// 文件数据
		responseDTO.setValue("fdataPublic", list2);
*/		return responseDTO;
	}
	
}
