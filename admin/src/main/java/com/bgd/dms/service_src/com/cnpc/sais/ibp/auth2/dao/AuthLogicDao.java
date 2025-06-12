package com.cnpc.sais.ibp.auth2.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.soa.exception.ServiceException;
import com.cnpc.sais.ibp.auth.pojo.PAuthMenu;
import com.cnpc.sais.ibp.auth.pojo.PAuthUser;

/**
 * 
 * Creator：rechete
 * 
 * Creator Time:2008-5-5 上午10:17:47
 * 
 * Description： 
 * 
 * Revision history：
 * 
 * 
 * 
 */
@SuppressWarnings({"unchecked","unused"})
public class AuthLogicDao{
	protected ILog log = LogFactory.getLogger(this.getClass());
	private IBaseDao baseDao = BeanFactory.getBaseDao();
	public IBaseDao getBaseDao() {
		return baseDao;
	}

	public IJdbcDao getJdbcDao() {
		return jdbcDao;
	}

	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();


	
	/**
	 * 根据loginId从库表中获取用户信息
	 * @param loginId
	 * @return
	 */
	public PAuthUser getUserByLoginId(String loginId){
		Criteria criteria = baseDao.createCriteria(PAuthUser.class);
		criteria.add(Restrictions.eq("loginId", loginId));	
		List users = criteria.list();
		if(users!=null && users.size()==1) return (PAuthUser)users.get(0);
		else return null;
	}
	

	public List<PAuthMenu> loadChildrenMenu(String parentMenuId){
		Criteria criteria = baseDao.createCriteria(PAuthMenu.class);
		criteria.add(Restrictions.eq("parentMenuId", parentMenuId));
		criteria.addOrder(Order.asc("orderNum"));
		return criteria.list();
	}	
	
	
	/**
	 * 根据用户登陆id获取用户角色id(角色、角色组映射)，重复的角色id只返回一个
	 * @param loginId
	 * @return
	 */
	public List<String> getUserRoleIds(String loginId)throws ServiceException{
		String sql = "SELECT distinct ur.role_id " +
				"from p_auth_user u,P_AUTH_USER_ROLE_DMS ur "+
				"where u.login_id='"+loginId+"' and u.user_id=ur.user_id ";
		List<Map> data = jdbcDao.queryRecords(sql);
		List roleIds = new ArrayList();
		if(data!=null)
			for(int i=0;i<data.size();i++){
				Map map = (Map)data.get(i);
				roleIds.add(map.get("roleId"));
			}		
//		List<String> roleIds1 = getUserRoleIdsByRolegp(loginId);
//		for(int i=0;i<roleIds1.size();i++){
//			String roleId = roleIds1.get(i);
//			if(!roleIds.contains(roleId)) roleIds.add(roleId);			
//		}
		return roleIds;
	}
	
	/**
	 * 用户-〉用户角色组-〉角色
	 * @param loginId
	 * @return
	 */
	private List<String> getUserRoleIdsByRolegp(String loginId)throws ServiceException{
		StringBuffer sb = new StringBuffer("");
		sb.append("select distinct rgpr.role_id from ");
		sb.append("p_auth_user u,p_auth_user_rolegp urgp,p_auth_role_group rgp,p_auth_rolegp_role rgpr ");
		sb.append("where u.login_id='"+loginId+"' ");
		sb.append("and u.user_id=urgp.user_id ");
		sb.append("and urgp.role_group_id=rgp.role_group_id ");
		sb.append("and rgp.role_group_id=rgpr.role_group_id ");
		log.debug(sb.toString());
		PageModel model = jdbcDao.queryRecordsBySQL(sb.toString());
		List data =  model.getData();
		List roleIds = new ArrayList();
		if(data!=null)
			for(int i=0;i<data.size();i++){
				Map map = (Map)data.get(i);
				roleIds.add(map.get("roleId"));
			}
		return roleIds;
	}
	
	public boolean hasRole(String roleEName)throws ServiceException{
		String sql = "SELECT * FROM P_AUTH_ROLE_DMS WHERE role_e_name=':role_e_name'"; 
		Map params = new HashMap();
		params.put("role_e_name",roleEName);
		List list = jdbcDao.queryRecordsByParamSQL(sql, params, null).getData();
		if(list!=null && list.size()>0)	return true;
		else return false;
	}

}
