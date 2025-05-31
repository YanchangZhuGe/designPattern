package com.bgp.dms.assess.IServ.impl;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.DateUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCallback;

import com.bgp.dms.assess.IServ.IAssessNodeServ;
import com.bgp.dms.assess.model.AssessBorad;
import com.bgp.dms.assess.model.AssessInfo;
import com.bgp.dms.assess.util.AssessTools;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;

public class AssessNodeServ implements IAssessNodeServ {
	ILog log = null;

	public AssessNodeServ() {
		log = LogFactory.getLogger(AssessNodeServ.class);
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	@Override
	public void saveAssess(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer buffer = new StringBuffer();
		buffer.append("insert into DMS_ASSESS_plat_Tree(");
		buffer.append("Assessid, assessCode, assessName, Nodetypes,");
		buffer.append("Nodelevel, Remarks, Rootid, Fullscore, ");
		buffer.append("Qualifiedscore, Exceldimensiontype, Isdisplay, ");
		buffer.append("Displayorder, Bsflag, Create_Date, ");
		buffer.append(" Creater, Updator)");

		buffer.append(" values(");
		buffer.append(" ?,?,?,?,");
		buffer.append(" ?,?,?,?,");
		buffer.append(" ?,?,?,");
		buffer.append(" ?,'0',sysdate,");
		buffer.append(" ?,?");
		buffer.append(" )");
		System.out.println(buffer.toString());
		final String Assessid = jdbcDao.generateUUID();
		log.info("saveAssess assessInfo=" + assessInfo);
		final String assessCode = createAssessNodeCode(assessInfo.getSuperiorAssessInfos(),assessInfo.getLevel());
		final String assessName = assessInfo.getAssessInfoName();
		final String Nodetypes = assessInfo.getNodetypes();

		final int Nodelevel = assessInfo.getLevel();
		final String Remarks = assessInfo.getRemarks();
		String rootID = null;
		if (assessInfo.getRootNode() == null) {
			rootID = Assessid;
		} else {
			rootID = assessInfo.getRootNode().getAssessInfoID();
		}
		final String Rootid = rootID;
		final double Fullscore = assessInfo.getFullScore();
		
		final double Qualifiedscore = assessInfo.getQualifiedScore();
		final String excelType = assessInfo.getExcelType();
		final String Isdisplay = assessInfo.getIsdisplay();

		final int Displayorder = assessInfo.getDisplayOrder();
		final String Creater = assessInfo.getIsdisplay();
		final String Updator = assessInfo.getUPDATOR();
		jdbcTemplate.execute(buffer.toString(),
				new PreparedStatementCallback<Integer>() {

					@Override
					public Integer doInPreparedStatement(PreparedStatement ps)
							throws SQLException, DataAccessException {
						// TODO Auto-generated method stub
						ps.setString(1, Assessid);
						ps.setString(2, assessCode);
						ps.setString(3, assessName);
						ps.setString(4, Nodetypes);

						ps.setInt(5, Nodelevel);
						ps.setString(6, Remarks);
						ps.setString(7, Rootid);
						ps.setDouble(8, Fullscore);

						ps.setDouble(9, Qualifiedscore);
						ps.setString(10, excelType);
						ps.setString(11, Isdisplay);

						ps.setInt(12, Displayorder);
						ps.setString(13, Creater);
						ps.setString(14, Updator);
						return ps.executeUpdate();
					}

				});
		saveAssess2Super(assessInfo);
		log.info("保存完毕");
	}

	/**
	 * 向多对多的上级中间表添加数据
	 * @param assessInfo 子集节点
	 */
	private void saveAssess2Super(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer assess2SuperBuffer = new StringBuffer();
		assess2SuperBuffer.append("insert into DMS_ASSESS_PLAT_RELAX");
		assess2SuperBuffer.append("(AssessId,superiorId) ");
		assess2SuperBuffer.append("values(?,?)");
		final String Assessid = assessInfo.getAssessInfoID();
		final List<AssessInfo> superList = assessInfo.getSuperiorAssessInfos();
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter(){

			@Override
			public int getBatchSize() {
				// TODO Auto-generated method stub
				return 0;
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				// TODO Auto-generated method stub
				ps.setString(1, Assessid);
				ps.setString(2, superList.get(i).getAssessInfoID());
			}
			
		};
		try {
			jdbcTemplate.batchUpdate(assess2SuperBuffer.toString(), setter);
			int size = setter.getBatchSize();
			AssessTools.printLoginfo("assess", "assess2Super size=" + size, true);
		} catch (Exception e) {
			// TODO: handle exception
			AssessTools.printLoginfo("assess", "insert assess2Super exception=" + e, true);
			e.printStackTrace();
		}
	}
	/**
	 * 向多对多的上级中间表添加数据
	 * @param assessInfo 子集节点
	 */
	private void updateAssess2Super(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer assess2SuperBuffer = new StringBuffer();
		assess2SuperBuffer.append("update DMS_ASSESS_PLAT_RELAX");
		assess2SuperBuffer.append("set superiorId=? where AssessId=? ");
		final String Assessid = assessInfo.getAssessInfoID();
		final List<AssessInfo> superList = assessInfo.getSuperiorAssessInfos();
		BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter(){

			@Override
			public int getBatchSize() {
				// TODO Auto-generated method stub
				return 0;
			}

			@Override
			public void setValues(PreparedStatement ps, int i)
					throws SQLException {
				// TODO Auto-generated method stub
				ps.setString(1, superList.get(i).getAssessInfoID());
				ps.setString(2, Assessid);
			}
			
		};
		try {
			jdbcTemplate.batchUpdate(assess2SuperBuffer.toString(), setter);
			int size = setter.getBatchSize();
			AssessTools.printLoginfo("assess", "assess2Super size=" + size, true);
		} catch (Exception e) {
			// TODO: handle exception
			AssessTools.printLoginfo("assess", "update assess2Super exception=" + e, true);
			e.printStackTrace();
		}
	}

	@Override
	public void updateAssess(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer buffer = new StringBuffer();
		buffer.append("update DMS_ASSESS_plat_Tree set ");
		buffer.append("assessName=?, Nodetypes=?,");
		buffer.append("Nodelevel=?, Remarks=?, Rootid=?, Fullscore=?, ");
		buffer.append("Qualifiedscore=?, Exceldimensiontype=?, Isdisplay=?, ");
		buffer.append("Displayorder=?, Bsflag=?, ");
		buffer.append("Modify_Date=sysdate,  Updator=?");

		buffer.append(" where Assessid=?");

		final String Assessid = assessInfo.getAssessInfoID();
		final String assessName = assessInfo.getAssessInfoName();
		final String Nodetypes = assessInfo.getNodetypes();

		final int Nodelevel = assessInfo.getLevel();
		final String Remarks = assessInfo.getRemarks();
		String rootID = null;
		if (assessInfo.getRootNode() == null) {
			rootID = Assessid;
		} else {
			rootID = assessInfo.getRootNode().getAssessInfoID();
		}
		final String Rootid = rootID;
		final double Fullscore = assessInfo.getFullScore();

		final double Qualifiedscore = assessInfo.getQualifiedScore();
		final String excelType = assessInfo.getExcelType();
		final String Isdisplay = assessInfo.getIsdisplay();

		final int Displayorder = assessInfo.getDisplayOrder();
		final String Updator = assessInfo.getUPDATOR();
		jdbcTemplate.execute(buffer.toString(),
				new PreparedStatementCallback<Integer>() {

					@Override
					public Integer doInPreparedStatement(PreparedStatement ps)
							throws SQLException, DataAccessException {
						// TODO Auto-generated method stub
						ps.setString(1, assessName);
						ps.setString(2, Nodetypes);

						ps.setInt(3, Nodelevel);
						ps.setString(4, Remarks);
						ps.setString(5, Rootid);
						ps.setDouble(6, Fullscore);

						ps.setDouble(7, Qualifiedscore);
						ps.setString(8, excelType);
						ps.setString(9, Isdisplay);

						ps.setInt(10, Displayorder);
						ps.setString(11, Updator);
						ps.setString(12, Assessid);
						return ps.executeUpdate();
					}

				});
		updateAssess2Super(assessInfo);

	}

	
	@Override
	public void deleteAssesById(String assessInfoID) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		
		deleteChildrenByID(assessInfoID);
		
		StringBuffer buffer = new StringBuffer();
		buffer.append("update DMS_ASSESS_plat_Tree set ");
		buffer.append(" bsflag='1'");
		buffer.append(" where Assessid=?");
		final String Assessid = assessInfoID;
		jdbcTemplate.execute(buffer.toString(),
				new PreparedStatementCallback<Integer>() {

					@Override
					public Integer doInPreparedStatement(PreparedStatement ps)
							throws SQLException, DataAccessException {
						// TODO Auto-generated method stub
						ps.setString(1, Assessid);
						return ps.executeUpdate();
					}

				});
		
	}

	private void deleteChildrenByID(String assessInfoID) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer sqlBuffer = new StringBuffer();
		sqlBuffer.append("select assessId from DMS_ASSESS_PLAT_RELAX where ");
		sqlBuffer.append("superiorId='");
		sqlBuffer.append(assessInfoID);
		sqlBuffer.append("'");
		List<String> childrenIDs = jdbcTemplate.queryForList(sqlBuffer.toString(), String.class);
		List<AssessInfo> list = new ArrayList<AssessInfo>();
		if(childrenIDs!=null){
			for (Iterator iterator = childrenIDs.iterator(); iterator.hasNext();) {
				String AssessId = (String) iterator.next();
				deleteAssesById(AssessId);
			}
		}
	}

	/**
	 * 查询考核数据
	 * @param assessInfoID
	 * @return
	 */
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
		assessInfo.setAssessInfoCode(AssessTools.valueOf(map.get("assessCode"), ""));
		assessInfo.setAssessInfoID(AssessTools.valueOf(map.get(""), "assessid"));
		assessInfo.setAssessInfoName(AssessTools.valueOf(map.get("assessName"), ""));
		String nodeType = AssessTools.valueOf(map.get("nodeTypes"), "");
		String excelType = AssessTools.valueOf(map.get("EXCELNODETYPE"), "");
		if(("R".equals(nodeType))||("B".equals(nodeType))){
			log.info("nodeType=" + nodeType);
			List<AssessInfo> childAssessInfos = findChildAssessListByID(assessInfoID);
			assessInfo.setChildAssessInfos(childAssessInfos);
		}
		if(("Y".equals(nodeType))||("B".equals(nodeType))){
			log.info("nodeType=" + nodeType);
			List<AssessInfo> superiorAssessInfos = findSuperiorAssessInfosByID(assessInfoID);
			assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		}
		
		assessInfo.setDisplayOrder(Integer.parseInt(AssessTools.valueOf(
				map.get("displayOrder"), "0")));
		
		assessInfo.setCREATER(AssessTools.valueOf(map.get("CREATER"), ""));
		assessInfo.setUPDATOR(AssessTools.valueOf(map.get("updator"), ""));
		assessInfo.setRootNode(findRootAssess(AssessTools.valueOf(map.get("rootID"), "")));
		return assessInfo;
	}

	/**
	 * 在中间表中，根据下级节点查找对应的上级节点集合
	 * @param assessInfoID
	 * @return
	 */
	@Override
	public List<AssessInfo> findSuperiorAssessInfosByID(String assessInfoID) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer querySuperiorsBuffer = new StringBuffer();
		querySuperiorsBuffer.append("select superiorId from DMS_ASSESS_PLAT_RELAX ");
		querySuperiorsBuffer.append(" where AssessId='");
		querySuperiorsBuffer.append(assessInfoID);
		querySuperiorsBuffer.append("'");
		String sql = querySuperiorsBuffer.toString();
		log.info("----------------------findSuperiorAssessInfosByID-------------------------");
		log.info("sql=" + sql);
		log.info("----------------------findSuperiorAssessInfosByID-------------------------");
		List<String> superiorIDs = jdbcTemplate.queryForList(sql, String.class);
		List<AssessInfo> list = new ArrayList<AssessInfo>();
		for (Iterator iterator = superiorIDs.iterator(); iterator.hasNext();) {
			String superiorID = (String) iterator.next();
			AssessInfo superior = findAssessByID(superiorID);
			if(!("R".equals(superior.getAssessInfoID()))){
				
			}else{
				list.add(superior);
			}
			
		}
		return list;
	}
	/**
	 * 在中间表中，根据下级节点查找对应的上级节点集合
	 * @param assessInfoID
	 * @return
	 */
	@Override
	public List<AssessInfo> findSuperiorAssessInfosByName(String assessInfoName) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer sqlBuffer = new StringBuffer();
		sqlBuffer.append("select ds.superiorId from DMS_ASSESS_PLAT_RELAX ds,DMS_ASSESS_plat_Tree d where ");
		sqlBuffer.append("d.assessid=ds.AssessID and");
		sqlBuffer.append("d.assessName='");
		sqlBuffer.append(assessInfoName);
		sqlBuffer.append("'");
		String sql = sqlBuffer.toString();
		log.info("---------------------------------------");
		List<String> superiorIDs = jdbcTemplate.queryForList(sql, String.class);
		List<AssessInfo> list = new ArrayList<AssessInfo>();
		for (Iterator iterator = superiorIDs.iterator(); iterator.hasNext();) {
			String superiorID = (String) iterator.next();
			list.add(findAssessByID(superiorID));
		}
		return list;
	}
	/**
	 * 在中间表中，根据上级节点查找对应的下级节点集合
	 * @param assessInfoID
	 * @return
	 */
	@Override
	public List<AssessInfo> findChildAssessListByID(String superiorId) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer sqlBuffer = new StringBuffer();
		sqlBuffer.append("select assessId from DMS_ASSESS_PLAT_RELAX where ");
		sqlBuffer.append("superiorId='");
		sqlBuffer.append(superiorId);
		sqlBuffer.append("'");
		String sql = sqlBuffer.toString();
		log.info("----------------------findChildAssessListByID-------------------------");
		log.info("sql=" + sql);
		log.info("----------------------findChildAssessListByID-------------------------");
		List<String> childrenIDs = jdbcTemplate.queryForList(sql, String.class);
		List<AssessInfo> list = new ArrayList<AssessInfo>();
		if(childrenIDs!=null){
			for (Iterator iterator = childrenIDs.iterator(); iterator.hasNext();) {
				String AssessId = (String) iterator.next();
				AssessInfo child = findAssessByID(AssessId);
				String nodeType = child.getNodetypes();
				if(!("Y".equals(nodeType))){
					findChildAssessListByID(child.getAssessInfoID());
				}else{
					list.add(child);
				}
				
			}
		}
		return list;
	}
	@Override
	public List<AssessInfo> findChildAssessListByName(String assessName) {
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer sqlBuffer = new StringBuffer();
		sqlBuffer.append("select ds.assessId from DMS_ASSESS_PLAT_RELAX ds,DMS_ASSESS_plat_Tree d where ");
		sqlBuffer.append("d.assessid=ds.AssessID and");
		sqlBuffer.append("d.assessName='");
		sqlBuffer.append(assessName);
		sqlBuffer.append("'");
		List<String> childrenIDs = jdbcTemplate.queryForList(sqlBuffer.toString(), String.class);
		List<AssessInfo> list = new ArrayList<AssessInfo>();
		if(childrenIDs!=null){
			for (Iterator iterator = childrenIDs.iterator(); iterator.hasNext();) {
				String AssessId = (String) iterator.next();
				list.add(findAssessByID(AssessId));
			}
		}
		return list;
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
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer countBuffer = new StringBuffer();
		countBuffer.append("select count(*) from DMS_ASSESS_plat_Tree d where ");
		countBuffer.append("d.nodelevel=0");
		int count = jdbcTemplate.queryForInt(countBuffer.toString());
		if(count==0){
			return null;
		}
		
		StringBuffer sqlBuffer = new StringBuffer();
		sqlBuffer.append("select d.assessid from DMS_ASSESS_plat_Tree d where ");
		sqlBuffer.append("d.nodelevel=0");
		List<String> ids = jdbcTemplate.queryForList(sqlBuffer.toString(), String.class);
		List<AssessInfo> list = new ArrayList<AssessInfo>();
		if(ids!=null){
			for (Iterator iterator = ids.iterator(); iterator.hasNext();) {
				String AssessId = (String) iterator.next();
				list.add(findAssessByID(AssessId));
			}
		}
		return list;
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
	public String createAssessNodeCode(List<AssessInfo> superiorNodes, int nodeLevel) {
		// TODO Auto-generated method stub
		String codeBuffer = null;
		String superiorCode = null;
		if(nodeLevel==0){
			String rootNodeCode = createRootNodeCode();
			return rootNodeCode;
		}
		
		if(nodeLevel>0){
			superiorCode = findSuperCode(superiorNodes);
		}
		codeBuffer = createNodeCode(nodeLevel,superiorCode);
		return codeBuffer;
	}

	private String createNodeCode(int nodeLevel,String superiorCode) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer nodeCodeBuffer = new StringBuffer();
		StringBuffer maxNodeSqlBuffer = new StringBuffer();
		int nodeCodeNumber = 0;
		maxNodeSqlBuffer.append("select max(to_number(substr(assessCode,length(assessCode)-3,length(assessCode))))");
		maxNodeSqlBuffer.append(" from DMS_ASSESS_plat_Tree ");
		maxNodeSqlBuffer.append("where substr(assessCode,0,length(assessCode)-2)=" + superiorCode);
		maxNodeSqlBuffer.append(" and  nodeLevel= " + nodeLevel);
		int assessCode = jdbcTemplate.queryForInt(maxNodeSqlBuffer.toString());
		nodeCodeNumber = assessCode + 1;
		if(nodeCodeNumber<10){
			nodeCodeBuffer.append("0").append(nodeCodeNumber);
		}else{
			nodeCodeBuffer.append(nodeCodeNumber);
		}
		return nodeCodeBuffer.toString();
	}

	/**
	 * 查找上级目录编码
	 * @param superiorNodes
	 * @return
	 */
	private String findSuperCode(List<AssessInfo> superiorNodes) {
		String superiorCode = null;
			AssessInfo superiorNode = null;
			if(superiorNodes!=null){
				int superSize = superiorNodes.size();
				if(superSize==1){
					superiorNode = superiorNodes.get(0);
				}else{
					for (Iterator iterator = superiorNodes.iterator(); iterator
							.hasNext();) {
						AssessInfo assessInfo = (AssessInfo) iterator.next();
						if("L".equals(assessInfo.getNodetypes())){
							superiorNode = assessInfo;
						}
					}
				}
				
				superiorCode = superiorNode.getAssessInfoCode();
			}
			
		return superiorCode;
	}

	public String createRootNodeCode() {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer nodeCodeBuffer = new StringBuffer();
		StringBuffer maxNodeSqlBuffer = new StringBuffer();
		int nodeCodeNumber = 0;
		maxNodeSqlBuffer.append("select max(to_number(assessCode)) from DMS_ASSESS_plat_Tree where nodeLevel=0");
		int assessCode = jdbcTemplate.queryForInt(maxNodeSqlBuffer.toString());
		nodeCodeNumber = assessCode+1;
		if(nodeCodeNumber<10){
			nodeCodeBuffer.append("0").append(nodeCodeNumber);
		}else{
			nodeCodeBuffer.append(nodeCodeNumber);
		}
		return nodeCodeBuffer.toString();
	}
	@Override
	public AssessInfo findSuperiorRowHeaderInfoByID(String assessInfoID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public AssessInfo findSuperiorColHeaderInfoByID(String assessInfoID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean isExistSuperiorRowHeaderInfoByID(String assessInfoID) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean isExistSuperiorColHeaderInfoByID(String assessInfoID) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public AssessInfo findAssessByName(String assessInfoName, int level) {
		// TODO Auto-generated method stub
				JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
				StringBuffer countSql = new StringBuffer();
				countSql.append("select count(*) from DMS_ASSESS_plat_Tree ");
				countSql.append("where assessName='").append(assessInfoName).append("'");
				countSql.append(" and NODELEVEL=" ).append(level);
				int count = jdbcTemplate.queryForInt(countSql.toString());
				if(count==0){
					return null;
				}
				StringBuffer querySql = new StringBuffer();
				querySql.append("select * from DMS_ASSESS_plat_Tree ");
				querySql.append("where assessName='").append(assessInfoName).append("'");
				querySql.append(" and NODELEVEL=" ).append(level);
				System.out.println("findAssessByName sql=" + querySql.toString());
				
				Map<String, Object> map = jdbcTemplate.queryForMap(querySql.toString());
				AssessInfo assessInfo = new AssessInfo();
				assessInfo.setAssessInfoCode(AssessTools.valueOf(map.get("assessCode"), ""));
				assessInfo.setAssessInfoID(AssessTools.valueOf(map.get(""), "assessid"));
				assessInfo.setAssessInfoName(AssessTools.valueOf(map.get("assessName"), ""));
				String nodeType = AssessTools.valueOf(map.get("nodeTypes"), "");
				if(!("L".equals(nodeType))){
					List<AssessInfo> childAssessInfos = findChildAssessListByName(assessInfoName);
					assessInfo.setChildAssessInfos(childAssessInfos);
				}
				if(!("R".equals(nodeType))){
					List<AssessInfo> superiorAssessInfos = findSuperiorAssessInfosByName(assessInfoName);
					assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
				}
				
				assessInfo.setDisplayOrder(Integer.parseInt(AssessTools.valueOf(
						map.get("displayOrder"), "0")));
				
				assessInfo.setCREATER(AssessTools.valueOf(map.get("CREATER"), ""));
				assessInfo.setUPDATOR(AssessTools.valueOf(map.get("updator"), ""));
				assessInfo.setRootNode(findRootAssess(AssessTools.valueOf(map.get("rootID"), "")));
				return assessInfo;
	}

	@Override
	public void changeLeafToBranch(String assessInfoID) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer sqlBuffer = new StringBuffer();
		sqlBuffer.append("update DMS_ASSESS_plat_Tree set nodeTypes='B' where assessid='");
		sqlBuffer.append(assessInfoID).append("'");
		jdbcTemplate.execute(sqlBuffer.toString());
	}

	@Override
	public void changeBranchToLeaf(String assessInfoID) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer sqlBuffer = new StringBuffer();
		sqlBuffer.append("update DMS_ASSESS_plat_Tree set nodeTypes='L' where assessid='");
		sqlBuffer.append(assessInfoID).append("'");
		jdbcTemplate.execute(sqlBuffer.toString());
	}

	@Override
	public AssessInfo findRootAssess(String rootID) {
		// TODO Auto-generated method stub
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer sqlBuffer = new StringBuffer();
		sqlBuffer.append("select * from DMS_ASSESS_plat_Tree where ");
		sqlBuffer.append(" nodeLevel=0 and nodeTypes='R' and ");
		sqlBuffer.append(" assessid='");
		sqlBuffer.append(rootID).append("'");
		Map<String, Object> map = jdbcTemplate.queryForMap(sqlBuffer.toString());
		AssessInfo assessInfo = new AssessInfo();
		assessInfo.setAssessInfoCode(AssessTools.valueOf(map.get("assessCode"), ""));
		assessInfo.setAssessInfoID(rootID);
		assessInfo.setAssessInfoName(AssessTools.valueOf(map.get("assessName"), ""));
		assessInfo.setCREATER(AssessTools.valueOf(map.get("CREATER"), ""));
		assessInfo.setUPDATOR(AssessTools.valueOf(map.get("UPDATOR"), ""));
		assessInfo.setNodetypes("R");
		assessInfo.setIsRoot(true);
		assessInfo.setLevel(0);
		
		String createdate = AssessTools.valueOf(map.get("CREATE_DATE"), "").substring(0, 10);
		log.info("createdate=" + createdate);
		Date create_date = DateUtil.parseYYYYMMDDDate(createdate);
		assessInfo.setCREATE_DATE(create_date);
		String modifydate = AssessTools.valueOf(map.get("MODIFY_DATE"), "").substring(0, 10);
		log.info("modifydate=" + modifydate);
		Date modefy_date = DateUtil.parseYYYYMMDDDate(modifydate);
		assessInfo.setMODIFY_DATE(modefy_date);
		assessInfo.setBSFLAG(AssessTools.valueOf(map.get("BSFLAG"), ""));
		assessInfo.setRemarks(AssessTools.valueOf(map.get("remarks"), ""));
		List<AssessInfo> superiorAssessInfos = new ArrayList<AssessInfo>();
		superiorAssessInfos.add(assessInfo);
		assessInfo.setSuperiorAssessInfos(superiorAssessInfos);
		List<AssessInfo> childrenList = findChildAssessListByID(rootID);
		assessInfo.setChildAssessInfos(childrenList);
		return assessInfo;
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
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		StringBuffer sqlBuffer = new StringBuffer();
		sqlBuffer.append("select * from DMS_ASSESS_plat_Tree where ");
		sqlBuffer.append(" nodeTypes='S' and ");
		sqlBuffer.append(" assessid='");
		sqlBuffer.append(sheetID).append("'");
		
		Map<String, Object> map = jdbcTemplate.queryForMap(sqlBuffer.toString());
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
	public AssessInfo findAssessBySheetID(AssessInfo assessInfo) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public AssessBorad createBoradBySheetID(String sheetID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Map<String, Object> findHeadByID(String headID) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List findContentByLineID(String hEADID) {
		// TODO Auto-generated method stub
		return null;
	}

}
