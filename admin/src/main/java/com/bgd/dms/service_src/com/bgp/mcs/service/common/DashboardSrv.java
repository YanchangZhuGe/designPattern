package com.bgp.mcs.service.common;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.BatchPreparedStatementSetter;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 作者：屈克将
 * 
 * 时间：2012-8-9
 * 
 * 说明: 仪表盘服务
 * 
 */
public class DashboardSrv extends BaseService {

	private RADJdbcDao jdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

	/**
	 * 保存用户配置的仪表盘
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveUserDashboard(ISrvMsg reqDTO) throws Exception{
		
		String boardId = reqDTO.getValue("boardId");
		if(boardId==null || boardId.equals("")){// 创建仪表盘主记录
			String boardName = reqDTO.getValue("boardName");

			String creatorId = reqDTO.getValue("creatorId");
			
			String boardType = reqDTO.getValue("boardType");

			String boardWidth = reqDTO.getValue("boardWidth");
			
			Map board = new HashMap();
			
			board.put("board_name", boardName);
			board.put("board_type", boardType);
			board.put("bsflag", "0");
			board.put("creator_id", creatorId);
			board.put("create_date", new Date(System.currentTimeMillis()));
			board.put("modifi_date", new Date(System.currentTimeMillis()));
			board.put("updator_id", creatorId);
			board.put("board_width", boardWidth);
			
			boardId = (String)jdbcDao.saveOrUpdateEntity(board, "bgp_comm_board_dms");
			
		}else{

			String boardWidth = reqDTO.getValue("boardWidth");
			
			Map board = new HashMap();
			board.put("board_id", boardId);
			board.put("modifi_date", new Date(System.currentTimeMillis()));
			board.put("board_width", boardWidth);
			
			jdbcDao.saveOrUpdateEntity(board, "bgp_comm_board_dms");
			
			// 删除子记录
			jdbcDao.executeUpdate("delete from bgp_comm_board_cell_dms where board_id='"+boardId+"'");
		}

		String datas = reqDTO.getValue("datas");
		
		final JSONArray jsons = JSONArray.fromObject(datas);
		
		if(jsons.size()>0){
		
			String sql = "insert into bgp_comm_board_cell_dms values (?,?,?,?,?,?,?,?,?)";
			
			final RADJdbcDao radDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");

			final String fBoardId = boardId;
			
			BatchPreparedStatementSetter setter = new BatchPreparedStatementSetter() {
				public void setValues(PreparedStatement ps, int i) throws SQLException {
					
					JSONObject data = jsons.getJSONObject(i);

					ps.setString(1, radDao.generateUUID());
					
					ps.setString(2, fBoardId);
					
					ps.setString(3, data.getString("board_index"));
					ps.setString(4, data.getString("board_height"));
					ps.setString(5, data.getString("col_index"));
					ps.setString(6, data.getString("col_width"));
					ps.setString(7, data.getString("cell_index"));
					ps.setString(8, data.getString("cell_height"));
					ps.setString(9, data.getString("menu_id"));
				}

				public int getBatchSize() {
					return jsons.size();
				}
			};
			
			radDao.getJdbcTemplate().batchUpdate(sql, setter);

		}
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.setValue("boardId", boardId);
		
		return msg;
	}
	
	/**
	 * 读取用户配置的仪表盘
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg readUserDashboard(ISrvMsg reqDTO) throws Exception{

		String boardType = reqDTO.getValue("boardType");
		
		String creatorId = reqDTO.getValue("creatorId");
		
		String isUser = reqDTO.getValue("isUser");
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		String boardId = "";
		String boardOldWidth = "";
		List datas = new ArrayList();
		
		String boardSql = "select t.board_id, t.board_width from bgp_comm_board_dms t where t.creator_id='"+creatorId+"'";
		Map map = jdbcDao.queryRecordBySQL(boardSql);
		
		if(isUser.equals("1") && map==null){// 用户未设置仪表盘
			
			UserToken user = reqDTO.getUserToken();
			// 读取用户的第一个角色
			String roleSql = "select role_id from P_AUTH_USER_ROLE_DMS where user_id='"+user.getUserId()+"' and rownum=1";
			Map roleMap = jdbcDao.queryRecordBySQL(roleSql);
			if(roleMap!=null){
				creatorId = (String)roleMap.get("role_id");
				
				boardSql = "select t.board_id, t.board_width from bgp_comm_board_dms t where t.creator_id='"+creatorId+"'";
				
				map = jdbcDao.queryRecordBySQL(boardSql);
			}
		}else{
			boardId = (String)map.get("board_id");
		}
		
		if(map!=null){
			boardOldWidth = (String)map.get("board_width");
			
			StringBuffer sb = new StringBuffer();
			
			sb.append("select t1.board_width, t2.board_id, t2.board_index, t2.board_height, t2.col_index, t2.col_width, t2.cell_index, t2.cell_height, t2.menu_id, m.portlet_name, m.portlet_url from bgp_comm_board_dms t1");
			sb.append(" join bgp_comm_board_cell_dms t2 on t1.board_id=t2.board_id and t1.creator_id='").append(creatorId);
			sb.append("' and t1.board_type='").append(boardType).append("' and t1.bsflag='0'");
			sb.append(" left join bgp_comm_portlet_dms m on t2.menu_id=m.portlet_id order by t2.board_index, t2.col_index, t2.cell_index");
			
			datas = jdbcDao.queryRecords(sb.toString());
		}
		
		msg.setValue("boardId", boardId);
		msg.setValue("boardOldWidth", boardOldWidth);

		msg.setValue("datas", datas);
		
		return msg;
	}
}
