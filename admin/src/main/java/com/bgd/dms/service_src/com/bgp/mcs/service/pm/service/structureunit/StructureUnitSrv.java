package com.bgp.mcs.service.pm.service.structureunit;

import java.util.ArrayList;
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

public class StructureUnitSrv extends BaseService{
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	IBaseDao baseDao = BeanFactory.getBaseDao();
	
	/**
	 * 增加构造单元信息
	 * @throws Exception
	 */
	public ISrvMsg addStuctureUnit(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);		
		String structUnitName = reqDTO.getValue("structUnitName");
		String structUnitLevel = reqDTO.getValue("structUnitLevel");
		String structUnitNoP = reqDTO.getValue("structUnitNo1");
		String basin = reqDTO.getValue("basin");
		String divideDate = reqDTO.getValue("divideDate");
		String regionName = reqDTO.getValue("regionName");
		
		String structUnitId = reqDTO.getValue("structUnitId");
		String structUnitArea = reqDTO.getValue("structUnitArea");
		String divideUnit = reqDTO.getValue("divideUnit");
		
		String structUnitNo = jdbcDao.generateUUID();
		
		String strSQLInsert = "INSERT INTO gp_structure_unit(struct_unit_no, struct_unit_name, struct_unit_level, struct_unit_parent, basin, divide_date, region_name,struct_unit_id,struct_unit_area,divide_unit , bsflag) VALUES('"+structUnitNo+"','" + structUnitName+"','" +structUnitLevel+"','"+structUnitNoP+"','"+basin+"','"+divideDate+"','"+regionName+ structUnitId+"','"+structUnitArea+"','"+divideUnit+"','0')";
		jdbcTemplate.execute(strSQLInsert);
		
		return responseMsg;
	}
	

	public ISrvMsg queryStrparent(ISrvMsg reqDTO) throws Exception {
		String currentPage = reqDTO.getValue("SelectForm_p");
		String structUnitLevel = reqDTO.getValue("structUnitLevel");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		StringBuffer sb = new StringBuffer("select * from gp_structure_unit ");
		List<Map> listResult= jdbcDAO.queryRecords(sb.toString());
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("structUnitLevel", structUnitLevel);
		msg.setValue("strparentInfos", listResult);
		msg.setValue("totalRecords", listResult.size());
		return msg;
	}

	/**
	 * 查询指定编号的子级构造单元信息
	 * @throws Exception
	 */
	public ISrvMsg queryChildStructUnit(ISrvMsg reqDTO) throws Exception {

		String p_struct_unit_no = reqDTO.getValue("pStructUnitNo");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		StringBuffer sb = new StringBuffer("select struct_unit_no,struct_unit_name from gp_structure_unit ");
		sb.append(" where bsflag = '0' and struct_unit_parent = '").append(p_struct_unit_no).append("'");
		
		List<Map> structList= jdbcDAO.queryRecords(sb.toString());
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		msg.setValue("strparentInfos", structList);
		return msg;
	}
	
	/**
	 * 获取指定编号的构造单元信息
	 * @throws Exception
	 */
	public ISrvMsg getStuctureUnit(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String stuctureUnitNo = reqDTO.getValue("stuctureUnitNo");		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("select a.struct_unit_no,a.struct_unit_name,a.struct_unit_level,a.struct_unit_parent as struct_unit_parent_no ,(select b.struct_unit_name from gp_structure_unit b where b.struct_unit_no = a.struct_unit_parent) as struct_unit_parent,a.basin , a.divide_date,a.region_name,a.struct_unit_id,a.divide_unit,a.struct_unit_area from gp_structure_unit a ");

		Map stuctureUnit = new HashMap();
		if(null != stuctureUnitNo && !"".equals(stuctureUnitNo)){
			sb.append(" where a.struct_unit_no='").append(stuctureUnitNo).append("'");
			stuctureUnit = jdbcDAO.queryRecordBySQL(sb.toString());
		}
		if (stuctureUnit != null) {
			responseMsg.setValue("stuctureUnit", stuctureUnit);
		}

		return responseMsg;
	}
	
	/**
	 * 修改构造单元信息
	 * @throws Exception
	 */
	public ISrvMsg updateStuctureUnit(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
//		String stuctureUnitNo = reqDTO.getValue("stuctureUnitNo");
//		String struct_unit_level = reqDTO.getValue("struct_unit_level");
//		String struct_unit_parent = reqDTO.getValue("struct_unit_parent_no");
//		String basin = reqDTO.getValue("basin");
//		String divide_date = reqDTO.getValue("divide_date");
//		String region_name = reqDTO.getValue("region_name");
//		String notes = reqDTO.getValue("notes");
		
		String stuctureUnitNo = reqDTO.getValue("stuctureUnitNo");
		String structUnitName = reqDTO.getValue("structUnitName");
		String structUnitLevel = reqDTO.getValue("structUnitLevel");
		String structUnitNoP = reqDTO.getValue("structUnitNo1");
		String basin = reqDTO.getValue("basin");
		String divideDate = reqDTO.getValue("divideDate");
		String regionName = reqDTO.getValue("regionName");		
		String structUnitId = reqDTO.getValue("structUnitId");
		String structUnitArea = reqDTO.getValue("structUnitArea");
		String divideUnit = reqDTO.getValue("divideUnit");
		
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();

		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);

		StringBuffer sb = new StringBuffer("update gp_structure_unit ");
		sb.append(" set struct_unit_name ='"+structUnitName+"'");
		sb.append(" , struct_unit_level ='"+structUnitLevel+"'");
		sb.append(" , struct_unit_parent ='"+structUnitNoP+"'");		
		sb.append(" , basin ='"+basin+"'");
		sb.append(" , divide_date ='"+divideDate+"'");
		sb.append(" , region_name ='"+regionName+"'");
		sb.append(" , struct_unit_id ='"+structUnitId+"'");
		sb.append(" , struct_unit_area ='"+structUnitArea+"'");
		sb.append(" , divide_unit ='"+divideUnit+"'");
		sb.append(" where bsflag='0' and struct_unit_no='"+stuctureUnitNo+"'");
		
		jdbcTemplate.execute(sb.toString());
		
		responseMsg.setValue("actionStatus", "ok");
		return responseMsg;
	}
	
	/**
	 * 删除指定编号的构造单元信息
	 * @throws Exception
	 */
	public ISrvMsg deleteStuctureUnit(ISrvMsg reqDTO) throws Exception {
		UserToken user = reqDTO.getUserToken();
		String stuctureUnitNo = reqDTO.getValue("stuctureUnitNo");
		IPureJdbcDao jdbcDAO = BeanFactory.getPureJdbcDAO();
		ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
		StringBuffer sb = new StringBuffer("update gp_structure_unit set bsflag = '1' ");
		sb.append(" where struct_unit_no='"+stuctureUnitNo+"'");
		
		jdbcTemplate.execute(sb.toString());
		
		responseMsg.setValue("actionStatus", "ok");
		return responseMsg;
	}
}
