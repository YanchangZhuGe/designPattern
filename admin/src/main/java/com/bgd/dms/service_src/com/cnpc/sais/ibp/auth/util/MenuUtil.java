package com.cnpc.sais.ibp.auth.util;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;


import com.cnpc.jcdp.common.UserToken;
import com.cnpc.sais.ibp.auth.dao.AuthLogicDao;
import com.cnpc.sais.ibp.auth.pojo.PAuthFunction;
import com.cnpc.sais.ibp.auth.pojo.PAuthMenu;
import com.cnpc.sais.ibp.auth.pojo.PAuthMenuFunc;



/**
 * Project��CNLC OMS(Service)
 * 
 * Creator��rechete
 * 
 * Creator Time:2008-4-28 ����10:17:47
 * 
 * Description��System Menu Management Util
 * 
 * Revision history��
 * 
 * 
 * 
 */
public class MenuUtil {
	/**
	 * ���²˵����źŶ���
	 */
	private static Object signal = new Object();
	/**
	 * ����ϵͳ���еĲ˵�
	 */
	private static Map<String,PAuthMenu> allMenus = new Hashtable();
	
	/**
	 * ���˵�
	 */
	private static PAuthMenu rootMenu;
	
	public static PAuthMenu getRootMenu(){
		return rootMenu;
	}
	
	/**
	 * ����menuId��cache�л�ȡMenu����
	 * @return
	 */
	public static PAuthMenu getMenu(String menuId){
		return allMenus.get(menuId);
	}
	
	public static List<PAuthMenu> getChildrenMenusOfRootMenu(UserToken user){		
		return getChildrenMenus(rootMenu.getMenuId(),user);
	}
	
	/**
	 * ��ȡ��ǰ�û���ĳ���˵��µ��Ӳ˵��б�(���ݹ�)
	 * @param parentMenuId
	 * @param user
	 * @return
	 */
	public static List<PAuthMenu> getChildrenMenus(String parentMenuId,UserToken user){
		List<PAuthMenu> allChildrenMenus = getMenu(parentMenuId).getChildrenMenus();
		String funcCodes = RoleUtil.getFunctionCodesByRoleIds(user.getRoleIds());
		
		List<PAuthMenu> userMenus = new ArrayList();
		if(allChildrenMenus!=null)
			for(int i=0;i<allChildrenMenus.size();i++){
				PAuthMenu childrenMenu = allChildrenMenus.get(i);
				if(isRelationMenu(childrenMenu,funcCodes))
					userMenus.add(childrenMenu);
			}
		return userMenus;
	}
	

	
	/**
	 * menu�°���������function�Ƿ�������һ����functions�У������ return true��
	 * ����return false 
	 * @param menu
	 * @param funcs
	 * @return
	 */
	private static boolean isRelationMenu(PAuthMenu menu,String functionCodes){
		if(functionCodes==null) return false;
		
		if(menu.isLeafMenu()){
			Set<PAuthMenuFunc> menuFuncs = menu.getMenuFuncs();
			Iterator<PAuthMenuFunc> iter = menuFuncs.iterator();
			while(iter.hasNext()){
				PAuthFunction func = FunctionUtil.getPAuthFunction(iter.next().getFuncId()); 
				if(func==null) continue;
				if(functionCodes.contains(func.getFuncCode()+",")) return true;
			}
		}
		
		List<PAuthMenu> childrenMenus = menu.getChildrenMenus();
		if(childrenMenus!=null)
			for(int i=0;i<childrenMenus.size();i++){
				if(isRelationMenu(childrenMenus.get(i),functionCodes)) return true;
			}
		return false;
	}
	
	
	/**
	 * load�˵���
	 */
	public static void loadAllMenus(){
		synchronized(signal){
			allMenus.clear();
			AuthLogicDao authDao = new AuthLogicDao();
			List<PAuthMenu> menus = authDao.loadChildrenMenu(AuthConstant.ROOT_MENU_PARENT_MENUID);
			rootMenu = menus.get(0);
			loadAllChildrenMenus(rootMenu,authDao);
		}
	}
	
	/**
	 * �ݹ�load menu
	 * @param menu
	 * @param authInit
	 */
	private static void loadAllChildrenMenus(PAuthMenu menu,AuthLogicDao authDao){
		allMenus.put(menu.getMenuId(), menu);
		if(menu.isLeafMenu()){
			return;
		}
		
		List<PAuthMenu> childrenMenus = authDao.loadChildrenMenu(menu.getMenuId());
		menu.setChildrenMenus(childrenMenus);		
		for(int i=0;i<childrenMenus.size();i++)
			loadAllChildrenMenus(childrenMenus.get(i),authDao);
	}
	
	/**
	 * �����˵��󣬸��»���
	 * @param func
	 */
	public static void addMenu(PAuthMenu menu){
		allMenus.put(menu.getMenuId(), menu);
		AuthLogicDao authDao = new AuthLogicDao();
		List<PAuthMenu> childrenMenus = authDao.loadChildrenMenu(menu.getParentMenuId());
		PAuthMenu parentMenu = getMenu(menu.getParentMenuId());
		parentMenu.setChildrenMenus(childrenMenus);
	}
	
	/**
	 * ɾ���˵��󣬸��»���
	 * @param func
	 */
	public static void deleteMenu(PAuthMenu menu){
		allMenus.remove(menu.getMenuId());
		List<PAuthMenu> childrenMenus = getMenu(menu.getParentMenuId()).getChildrenMenus();
		childrenMenus.remove(menu);		
	}	

	/**
	 * �޸Ĳ˵��󣬸��»���
	 * @param func
	 */	
	public static void updateMenu(PAuthMenu menu){
		allMenus.remove(menu.getMenuId());
		allMenus.put(menu.getMenuId(), menu);
		
		AuthLogicDao authDao = new AuthLogicDao();
		List<PAuthMenu> childrenMenus = authDao.loadChildrenMenu(menu.getMenuId());
		menu.setChildrenMenus(childrenMenus);
	}		
}
