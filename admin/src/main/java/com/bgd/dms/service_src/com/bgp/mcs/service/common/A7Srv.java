package com.bgp.mcs.service.common;

import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 作者：屈克将
 * 
 * 时间：2010-4-16
 * 
 * 说明: A7迁移过来后用的一些服务
 * 
 */
public class A7Srv extends BaseService {

	private RADJdbcDao jdbcDao = (RADJdbcDao)BeanFactory.getBean("radJdbcDao");
	
	/**
	 * 往数据库中插入一条记录，只插入主键字段
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg insertPrimaryKey(ISrvMsg reqDTO) throws Exception{
		
		String table = reqDTO.getValue("table");
		String key = reqDTO.getValue("key");
		String value = reqDTO.getValue("value");
		
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		
		StringBuffer sql = new StringBuffer("insert into ");
		sql.append(table).append(" (").append(key).append(")");
		sql.append(" values(").append(value).append(")");
		
		// 新增日报主表
		jdbcTemplate.execute(sql.toString());
				
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	/**
	 * 修改数据库中一条记录，只修改主键字段
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg updatePrimaryKey(ISrvMsg reqDTO) throws Exception{
		
		String table = reqDTO.getValue("table");
		String key = reqDTO.getValue("key");
		String oldValue = reqDTO.getValue("oldValue");
		String newValue = reqDTO.getValue("newValue");
		
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		
		StringBuffer sql = new StringBuffer("update ").append(table);
		sql.append(" set ").append(key).append("='").append(newValue).append("'");
		sql.append(" where ").append(key).append("='").append(oldValue).append("'");
		
		// 新增日报主表
		jdbcTemplate.execute(sql.toString());
				
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}
	
	/**
	 * 获取一个新的组织机构ID,组织机构隶属ID
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getNewOrgId(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		// 上级单位组织机构ID
		String parentOrgId = reqDTO.getValue("parentOrgId");
		
		if(parentOrgId!=null && !parentOrgId.equals("")){
			
			StringBuffer sql = new StringBuffer();
			
			sql.append("select to_char(max(to_number(substr(t.org_id,2)))+1) as neworgid");
			sql.append(" from comm_org_information t");
			sql.append(" where t.org_id like '").append(parentOrgId.substring(0, 4)).append("%'");
			
			Map map = jdbcDao.queryRecordBySQL(sql.toString());
			
			if(map!=null && map.get("neworgid")!=null){

				String neworgid = (String)map.get("neworgid");
				neworgid = parentOrgId.substring(0, 14-neworgid.length())+neworgid;
				
				msg.setValue("newOrgId", neworgid);
			}
			
		}


		// 上级单位组织机构隶属ID
		String parentOrgSubId = reqDTO.getValue("parentOrgSubId");
		
		if(parentOrgSubId!=null && !parentOrgSubId.equals("")){
			
			StringBuffer sql = new StringBuffer();
			
			sql.append("select 'C'||to_char(max(to_number(substr(t.org_subjection_id,2)))+1) as neworgsubid");
			sql.append(" from comm_org_subjection t");
			sql.append(" where (t.father_org_id = '").append(parentOrgSubId).append("' or t.father_org_id is null) and length(t.org_subjection_id)=length(t.father_org_id)+3");
			
			Map map = jdbcDao.queryRecordBySQL(sql.toString());
			
			if(map!=null && map.get("neworgsubid")!=null){

				msg.setValue("newOrgSubId", map.get("neworgsubid"));
			}
			
		}
		
		return msg;
	}
	
	/**
	 * 获取一个新的编码分类ID
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getNewCodingSortId(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		// 上级单位组织机构ID
		String prefix = reqDTO.getValue("prefix");
		
		if(prefix!=null && !prefix.equals("")){
			
			StringBuffer sql = new StringBuffer();
			
			sql.append("select max(to_number(t.coding_sort_id))+1 as newsortid from comm_coding_sort t where t.coding_sort_id like '"+prefix+"%'");
			
			Map map = jdbcDao.queryRecordBySQL(sql.toString());
			
			if(map!=null && map.get("newsortid")!=null){

				String newsortid = (String)map.get("newsortid");
				
				if(newsortid==null) newsortid="5110000001";
				
				msg.setValue("newsortid",newsortid );
			}
			
		}

		return msg;
	}

	/**
	 * 获取一个新的编码明细ID
	 * @param reqDTO
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getNewCodingCodeId(ISrvMsg reqDTO) throws Exception{
		
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		// 编码分类ID
		String codingSortId = reqDTO.getValue("codingSortId");
		
		if(codingSortId!=null && !codingSortId.equals("")){
			
			StringBuffer sql = new StringBuffer();
			
			sql.append("select max(to_number(t.coding_code_id))+1 as newcodeid ,max(t.coding_show_id)+1000 as coding_show_id from comm_coding_sort_detail t where t.coding_sort_id = '"+codingSortId+"'");
			
			Map map = jdbcDao.queryRecordBySQL(sql.toString());
			
			if(map!=null && map.get("newcodeid")!=null){

				String newcodeid = (String)map.get("newcodeid");

				if(newcodeid==null || newcodeid.equals("")) newcodeid=codingSortId+"000000001";
				
				msg.setValue("newcodeid",newcodeid );
				
				String codingShowId = (String)map.get("coding_show_id");
				
				if(codingShowId==null || codingShowId.equals("")) codingShowId="1000";

				msg.setValue("coding_show_id",codingShowId );
				
			}
			
		}

		return msg;
	}
}
