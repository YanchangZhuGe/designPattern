package com.bgp.mcs.service.pm.service.workarea;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

public class WorkAreaSrv extends BaseService{
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	IBaseDao baseDao = BeanFactory.getBaseDao();
	
	/**
	 * 根据指定工区编码查询工区信息
	 * @param workareaNo
	 * @throws Exception
	 */
	public ISrvMsg getWorkArea(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String workareaNo = reqDTO.getValue("workareaNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer("select w.workarea_no, w.workarea, w.workarea_id ,w.start_year ,w.basin,w.spare2,w.block,w.region_name");
		sb.append(",(select coding_name from comm_coding_sort_detail where coding_code_id = w.surface_type) as surface_type");
		sb.append(",(select coding_name from comm_coding_sort_detail where coding_code_id = w.second_surface_type) as second_surface_type");
		sb.append(",(select struct_unit_name from gp_structure_unit where struct_unit_no = w.struct_unit_first) as struct_unit_first_name");
		sb.append(",(select struct_unit_name from gp_structure_unit where struct_unit_no = w.struct_unit_second) as struct_unit_second_name");
		sb.append(",w.focus_x,w.focus_y");
		sb.append(",w.surface_condition");
		sb.append(", w.oil_region");
		sb.append(",(select coding_name from comm_coding_sort_detail where coding_code_id=w.crop_area_type) as crop_area_type");
		sb.append(",(select coding_name from comm_coding_sort_detail where coding_code_id=w.country) as country_name");
		sb.append(",w.struct_unit_first,w.struct_unit_second,w.country,w.notes");
		sb.append(" from gp_workarea_diviede w where w.bsflag = '0' ");

		Map workarea = new HashMap();
		if(null != workareaNo && !"".equals(workareaNo)){
			sb.append(" and w.workarea_no='").append(workareaNo).append("'");
			workarea = jdbcDAO.queryRecordBySQL(sb.toString());
		}
	
		if (workarea != null) {
			responseMsg.setValue("workarea", workarea);
		}

		return responseMsg;
	}
	
	
	/**
	 * 获取作物区类型信息
	 * @throws Exception
	 */
	public ISrvMsg getCropreaType(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer("select coding_code_id,coding_code, coding_name ,'1' as is_leaf from comm_coding_sort_detail where coding_sort_id='5000100010' and bsflag='0' order by coding_code");
		
		List<Map> cropAreaType = jdbcDAO.queryRecords(sb.toString());
	
		if (cropAreaType != null) {
			responseMsg.setValue("cropAreaType", cropAreaType);
		}
		return responseMsg;
	}
	
	/**
	 * 获取地表类型信息
	 * @throws Exception
	 */
	public ISrvMsg getSurfaceType(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer("select coding_code_id,coding_code, case length(coding_code) when 2 then coding_name when 5 then '--'||coding_name  when 8 then '----'||coding_name  when 11 then '------'||coding_name end as coding_name ,'1' as is_leaf from comm_coding_sort_detail where coding_sort_id='0101600001' and bsflag='0' order by coding_code");
		
		List<Map> surfaceType = jdbcDAO.queryRecords(sb.toString());
	
		if (surfaceType != null) {
			responseMsg.setValue("surfaceType", surfaceType);
		}
		return responseMsg;
	}
	/**
	 * 新增工区信息
	 * @param workarea
	 * @throws Exception
	 */
	public ISrvMsg addWorkArea(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String workareaNo = "";
		String workarea = reqDTO.getValue("workarea");
		String workareaId = reqDTO.getValue("workareaId");
		String startYear = reqDTO.getValue("startYear");
		String basin = reqDTO.getValue("basin");
		String block = reqDTO.getValue("block");
		String spare2 = reqDTO.getValue("spare2");
		String regionName = reqDTO.getValue("regionName");
		String surfaceType = reqDTO.getValue("surface_type");
		String secondSurfaceType = reqDTO.getValue("second_surface_type");
		String structUnitFirst = reqDTO.getValue("structUnitFirst");
		String structUnitSecond = reqDTO.getValue("structUnitSecond");
		String focusX = reqDTO.getValue("focusX");
		String focusY = reqDTO.getValue("focusY");
		String surfaceCondition = reqDTO.getValue("surfaceCondition");
		String oilRegion = reqDTO.getValue("oilRegion");
		String crop_area_type = reqDTO.getValue("crop_area_type");
		String country = reqDTO.getValue("country");
		String notes = reqDTO.getValue("notes");
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		workareaNo =jdbcDao.generateUUID();
		StringBuffer sbInsert = new StringBuffer("INSERT INTO gp_workarea_diviede(workarea_no,workarea_id,workarea,start_year,basin,block,spare2,region_name,surface_type,second_surface_type,struct_unit_first,struct_unit_second,focus_x,focus_y,surface_condition,oil_region,crop_area_type,country,notes,creator,bsflag)");
		sbInsert.append("values('").append(workareaNo).append("'");
		sbInsert.append(",'").append(workareaId).append("'");
		sbInsert.append(",'").append(workarea).append("'");
		sbInsert.append(",'").append(startYear).append("'");
		sbInsert.append(",'").append(basin).append("'");
		sbInsert.append(",'").append(block).append("'");
		sbInsert.append(",'").append(spare2).append("'");
		sbInsert.append(",'").append(regionName).append("'");
		sbInsert.append(",'").append(surfaceType).append("'");
		sbInsert.append(",'").append(secondSurfaceType).append("'");
		sbInsert.append(",'").append(structUnitFirst).append("'");
		sbInsert.append(",'").append(structUnitSecond).append("'");
		sbInsert.append(",'").append(focusX).append("'");
		sbInsert.append(",'").append(focusY).append("'");
		sbInsert.append(",'").append(surfaceCondition).append("'");		
		sbInsert.append(",'").append(oilRegion).append("'");
		sbInsert.append(",'").append(crop_area_type).append("'");
		sbInsert.append(",'").append(country).append("'");
		sbInsert.append(",'").append(notes).append("'");
		sbInsert.append(",'").append(user.getEmpId()).append("'");
		sbInsert.append(",'0')");
		
		jdbcTemplate.execute(sbInsert.toString());
		
		return responseMsg;
	}

	/**
	 * 更新工区信息
	 * @param workarea
	 * @throws Exception
	 */
	public ISrvMsg updateWorkArea(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String workareaNo = reqDTO.getValue("workareaNo");
		String workarea = reqDTO.getValue("workarea");
		String workareaId = reqDTO.getValue("workareaId");
		String startYear = reqDTO.getValue("startYear");
		String basin = reqDTO.getValue("basin");
		String block = reqDTO.getValue("block");
		String spare2 = reqDTO.getValue("spare2");
		String regionName = reqDTO.getValue("regionName");
		String surfaceType = reqDTO.getValue("surface_type");
		String secondSurfaceType = reqDTO.getValue("second_surface_type");
		String structUnitFirst = reqDTO.getValue("structUnitFirst");
		String structUnitSecond = reqDTO.getValue("structUnitSecond");
		String focusX = reqDTO.getValue("focusX");
		String focusY = reqDTO.getValue("focusY");
		String surfaceCondition = reqDTO.getValue("surfaceCondition");
		String oilRegion = reqDTO.getValue("oilRegion");
		String crop_area_type = reqDTO.getValue("crop_area_type");
		String country = reqDTO.getValue("country");
		String notes = reqDTO.getValue("notes");
		
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		StringBuffer sbUpdate = new StringBuffer("update gp_workarea_diviede");
		sbUpdate.append(" set workarea='").append(workarea).append("'");
		sbUpdate.append(" ,workarea_id='").append(workareaId).append("'");		
		sbUpdate.append(" ,start_year='").append(startYear).append("'");
		sbUpdate.append(" ,basin='").append(basin).append("'");
		sbUpdate.append(" ,block='").append(block).append("'");
		sbUpdate.append(" ,spare2='").append(spare2).append("'");
		sbUpdate.append(" ,region_name='").append(regionName).append("'");
		sbUpdate.append(" ,surface_type='").append(surfaceType).append("'");
		sbUpdate.append(" ,second_surface_type='").append(secondSurfaceType).append("'");
		sbUpdate.append(" ,struct_unit_first='").append(structUnitFirst).append("'");
		sbUpdate.append(" ,struct_unit_second='").append(structUnitSecond).append("'");
		sbUpdate.append(" ,focus_x='").append(focusX).append("'");
		sbUpdate.append(" ,focus_y='").append(focusY).append("'");
		sbUpdate.append(" ,surface_condition='").append(surfaceCondition).append("'");
		sbUpdate.append(" ,oil_region='").append(oilRegion).append("'");
		sbUpdate.append(" ,crop_area_type='").append(crop_area_type).append("'");
		sbUpdate.append(" ,country='").append(country).append("'");
		sbUpdate.append(" ,notes='").append(notes).append("'");
		sbUpdate.append(" ,updator='").append(user.getEmpId()).append("'");
		sbUpdate.append(" where bsflag='0' and workarea_no='").append(workareaNo).append("'");
		
		jdbcTemplate.execute(sbUpdate.toString());
		
		return responseMsg;
	}
	
	public ISrvMsg saveOrUpdateWorkarea(ISrvMsg reqDTO) throws Exception {

		Map map = reqDTO.toMap();
		
		String project_info_no = (String) map.get("project_info_no");
		
		UserToken user = reqDTO.getUserToken();
		map.put("bsflag", "0");
		map.put("updator", user.getEmpId());
		map.put("modifi_date", new Date());
		
		String workareaNo = reqDTO.getValue("workarea_no");
		if (workareaNo == null || "".equals(workareaNo)) {
			//如果为空 则添加创建人
			map.put("creator", user.getEmpId());
			map.put("create_date", new Date());
		}
		
		Serializable workarea_no = BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_WORKAREA_DIVIEDE");
		
		map.clear();
		map.put("workarea_no", workarea_no);
		map.put("project_info_no", project_info_no);
		BeanFactory.getPureJdbcDAO().saveOrUpdateEntity(map,"GP_TASK_PROJECT");
		
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		responseMsg.setValue("message", "success");
		
		return responseMsg;
	}
	
	public ISrvMsg getWorkarea(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String workareaNo = reqDTO.getValue("workareaNo");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer("select w.*");
		sb.append(",(select coding_name from comm_coding_sort_detail where coding_code_id = w.surface_type) as surface_type_name");
		sb.append(",(select coding_name from comm_coding_sort_detail where coding_code_id = w.second_surface_type) as second_surface_type_name");
		sb.append(",(select struct_unit_name from gp_structure_unit where struct_unit_no = w.struct_unit_first) as struct_unit_first_name");
		sb.append(",(select struct_unit_name from gp_structure_unit where struct_unit_no = w.struct_unit_second) as struct_unit_second_name");
		sb.append(",(select coding_name from comm_coding_sort_detail where coding_code_id=w.crop_area_type) as crop_area_type_name");
		sb.append(",(select coding_name from comm_coding_sort_detail where coding_code_id=w.country) as country_name");
		sb.append(",w.struct_unit_first,w.struct_unit_second,w.country,w.notes");
		sb.append(" from gp_workarea_diviede w where w.bsflag = '0' ");

		Map workarea = new HashMap();
		if(null != workareaNo && !"".equals(workareaNo)){
			sb.append(" and w.workarea_no='").append(workareaNo).append("'");
			workarea = jdbcDAO.queryRecordBySQL(sb.toString());
		}
	
		if (workarea != null) {
			responseMsg.setValue("workarea", workarea);
		}

		return responseMsg;
	}
	
	/**
	 * 删除工区信息
	 * @param workarea
	 * @throws Exception
	 */
	public ISrvMsg deleteWorkArea(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		//
		String workareaNo = reqDTO.getValue("workareaNo");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		jdbcTemplate.execute("update gp_workarea_diviede set bsflag='1' where workarea_no = '"+workareaNo+"'");
		
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		responseMsg.setValue("actionStatus", "ok");
		return responseMsg;
	}
}
