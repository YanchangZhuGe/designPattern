/**
 * 
 */
package com.cnpc.sais.ibp.auth2.dao;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.sais.ibp.auth.pojo.PAuthMenu;
import com.cnpc.sais.ibp.auth.pojo.PAuthOrg;
import com.cnpc.sais.ibp.auth2.util.AuthConstant;

/**
 * @author dingyongli
 *
 */
@SuppressWarnings("unchecked")
public class AuthDao {
	private IBaseDao baseDao = BeanFactory.getBaseDao();
//	private IJdbcDao jdbcDao = BeanFactory.getQueryJdbcDAO();
	
	
	public List<PAuthMenu> querySubMenus(String parentId) {
		Criteria criteria = baseDao.createCriteria(PAuthMenu.class);
		if (StringUtils.isEmpty(parentId)) {
			criteria.add(Restrictions.eq("parentMenuId", AuthConstant.ROOT_MENU_PARENT_MENUID));
		} else {
			criteria.add(Restrictions.eq("parentMenuId", parentId));
		}
		criteria.addOrder(Order.asc("orderNum"));
		return criteria.list();
	}
	
	public List<PAuthOrg> querySubOrgs(String parentId) {
		Criteria criteria = baseDao.createCriteria(PAuthOrg.class);
		if (StringUtils.isEmpty(parentId)) {
			criteria.add(Restrictions.eq("parentId", AuthConstant.ROOT_ORG_ID));
		} else {
			criteria.add(Restrictions.eq("parentId", parentId));
		}
		criteria.addOrder(Order.asc("orgCode"));
		return criteria.list();
	}
	
}
