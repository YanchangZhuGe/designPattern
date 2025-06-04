package com.bgp.dms.assess.IServ.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.dms.assess.IServ.IAssessNodeServ;
import com.bgp.dms.assess.model.AssessBorad;
import com.bgp.dms.assess.model.AssessInfo;
import com.bgp.dms.assess.util.AssessTools;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class AssessNodeServ2 implements IAssessNodeServ{
	ILog log = null;

	public AssessNodeServ2() {
		log = LogFactory.getLogger(AssessNodeServ.class);
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	@Override
	public void saveAssess(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateAssess(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteAssesById(String assessInfoID) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public AssessInfo findAssessByID(String assessInfoID) {
		// TODO Auto-generated method stub
		String sql = "";
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer querySql = new StringBuffer();
		querySql.append("select * from DMS_ASSESS_plat_Tree ");
		querySql.append("where Assessid='").append(assessInfoID).append("'");
		sql = querySql.toString();
		log.info("sql=" + sql);
		Map<String, Object> map = jdbcTemplate.queryForMap(sql);
		AssessInfo assessInfo = new AssessInfo();
		return null;
	}

	@Override
	public List<AssessInfo> findChildAssessListByID(String assessInfoID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AssessInfo> findChildAssessListByName(String assessName) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AssessInfo> findLeafListBySuperiorID(String superiorID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AssessInfo> findLeafListByTemplateId(String templateID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AssessInfo> findRootList() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean checkIsLeaf(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean checkIsRoot(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean checkIsRowHeader(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean checkIsColHeader(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean checkIsSheetHeader(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public List<AssessInfo> getSheetListByRootID(String rootID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String createAssessNodeCode(List<AssessInfo> superiorNodes,
			int nodeLevel) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public AssessInfo findSuperiorRowHeaderInfoByID(String assessInfoID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean isExistSuperiorRowHeaderInfoByID(String assessInfoID) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public AssessInfo findSuperiorColHeaderInfoByID(String assessInfoID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean isExistSuperiorColHeaderInfoByID(String assessInfoID) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public AssessInfo findAssessByName(String assessInfoName, int level) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void changeLeafToBranch(String assessInfoID) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void changeBranchToLeaf(String assessInfoID) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public AssessInfo findRootAssess(String rootID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AssessInfo> findAllSheetList() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AssessInfo> findAllSheetListByRootID(String rootID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AssessInfo> findAllColHeadListBysheetID(String sheetID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AssessInfo> findAllRowHeadListBysheetID(String sheetID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public AssessInfo findSheetAssessByID(String sheetID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public AssessInfo findColHeaderByID(String colHeaderID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public AssessInfo findRowHeaderByID(String rowHeaderID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AssessInfo> findSuperiorAssessInfosByID(String assessInfoID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<AssessInfo> findSuperiorAssessInfosByName(String assessInfoID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String createRootNodeCode() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public AssessInfo findAssessBySheetID(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public AssessBorad createBoradBySheetID(String sheetID) {
		// TODO Auto-generated method stub
		AssessBorad assessBorad = new AssessBorad();
		List<Map<String, List>> lineList = new ArrayList<Map<String,List>>();
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		String sql = "";
		StringBuffer sqlbuBuffer = new StringBuffer();
		
		String columnSql = "";
		StringBuffer columnSqlBuffer = new StringBuffer();
		
		String lineSql = "";
		StringBuffer lineSqlBuffer = new StringBuffer();
		
		//≤È—ØexcelÕ∑
		sqlbuBuffer.append("select * from DMS_ASSESS_plat_sheet d where ");
		sqlbuBuffer.append("d.sheetid='").append(sheetID).append("'");
		sql = sqlbuBuffer.toString();
		Map<String, Object> sheetMap = jdbcTemplate.queryForMap(sql);
		String title = AssessTools.valueOf(sheetMap.get("title"), "");
		
		columnSqlBuffer.append("select * from DMS_ASSESS_plat_head where ");
		columnSqlBuffer.append(" TYPS='C' and");
		columnSqlBuffer.append(" SHEETID='").append(sheetID).append("'");
		columnSqlBuffer.append(" order by DISPLAYINDEX desc");
		columnSql = columnSqlBuffer.toString();
		List<Map<String, Object>> cList = jdbcTemplate.queryForList(columnSql);
		
		lineSqlBuffer.append("select * from DMS_ASSESS_plat_head where ");
		lineSqlBuffer.append(" TYPS='L' and");
		lineSqlBuffer.append(" SHEETID='").append(sheetID).append("'");
		lineSql = lineSqlBuffer.toString();
		List<Map<String, Object>> lList = jdbcTemplate.queryForList(lineSql);
		
		for (Iterator iterator = lList.iterator(); iterator.hasNext();) {
			Map<String, Object> l_map = (Map<String, Object>) iterator.next();
			String lineID = AssessTools.valueOf(l_map.get("HEADID"), "");
			Map<String, List> conentMap = new HashMap<String, List>();
			for (Iterator iterator2 = cList.iterator(); iterator2.hasNext();) {
				Map<String, Object> c_map = (Map<String, Object>) iterator2
						.next();
				String cid = AssessTools.valueOf(c_map.get("HEADID"), "");
				StringBuffer contentBuffer = new StringBuffer();
				contentBuffer.append("select * from DMS_ASSESS_PLAT_CONTENT where ");
				contentBuffer.append(" COLUMID='").append(cid).append("'");
				contentBuffer.append(" and LINEID='").append(lineID).append("'");
				contentBuffer.append(" order by displayindex desc");
				String contentSql = contentBuffer.toString();
				List<Map<String, Object>> list = jdbcTemplate.queryForList(contentSql);
				
				conentMap.put(lineID, list);
			}
			lineList.add(conentMap);
		}
		assessBorad.setColumnHeadList(cList);
		assessBorad.setLineList(lineList);
		assessBorad.setSheetid(sheetID);
		return assessBorad;
	}

	@Override
	public Map<String, Object> findHeadByID(String headID) {
		// TODO Auto-generated method stub
		StringBuffer sqlBuffer = new StringBuffer();
		sqlBuffer.append("select * from DMS_ASSESS_PLAT_HEAD");
		sqlBuffer.append(" where HEADID='");
		sqlBuffer.append(headID).append("'");
		String sql = sqlBuffer.toString();
		System.out.println("sql=" + sql);
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		Map<String, Object> map = jdbcTemplate.queryForMap(sql);
		return map;
	}

	@Override
	public List findContentByLineID(String lineID) {
		// TODO Auto-generated method stub
		StringBuffer sqlBuffer = new StringBuffer();
		sqlBuffer.append("select * from DMS_ASSESS_plat_content");
		sqlBuffer.append(" where LINEID='");
		sqlBuffer.append(lineID).append("'");
		String sql = sqlBuffer.toString();
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		List<Map<String, Object>> list = jdbcTemplate.queryForList(sql);
		return list;
	}
}
