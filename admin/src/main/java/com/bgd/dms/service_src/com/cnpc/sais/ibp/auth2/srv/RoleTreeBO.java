package com.cnpc.sais.ibp.auth2.srv;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.soa.exception.RetCodeException;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.sais.ibp.auth2.pojo.TreeNode;
import com.cnpc.sais.ibp.auth2.util.AuthConstant;

@SuppressWarnings("unchecked")
public class RoleTreeBO extends BaseTreeBO implements ITreeBO {
	
	public List<TreeNode> getTreeData(ISrvMsg reqDTO) throws Exception {
		
		UserToken userToken = reqDTO.getUserToken();
		String userOrgId = userToken.getOrgId(),roleId = reqDTO.getValue("id");
		//1.用户的授权认证,必须为管理员才能操作角色
		validateUser(userToken);
		//2.查询菜单节点
		List<Map> menusNode = getMenusNode(userOrgId,roleId);
		//3.查询功能节点
		List<Map> funcsNode = getFuncsNode(userOrgId,roleId);
		//4.设定checked和leaf属性
		return merge2TreeNodeList(menusNode,funcsNode);
	}
	
	
	private List<TreeNode> merge2TreeNodeList(List<Map> menusMap, List<Map> funcsMap) {
		menusMap.addAll(funcsMap);
		TreeNode root = new TreeNode();//虚拟根节点
		List<Map> temp = new ArrayList<Map>();
		for(Iterator<Map> it = menusMap.iterator();it.hasNext();){
			Map m = it.next();
			Object isLeaf = m.get("is_leaf");
			if(isTopNode(m,menusMap) && isLeaf!=null && isLeaf.toString().equals("0") && m.get("parent_menu_id").equals("INIT_AUTH_MENU_012345678900000")){ 
				root.getChildren().add(map2TreeNode(m, TreeNode.class, null));
				temp.add(m);
			}
		}
		menusMap.removeAll(temp);//删除顶级节点
		for(TreeNode  node : root.getChildren()){
			buildTreeNodeList(node,menusMap);
		}
		
		return root.getChildren();
	}

	private void buildTreeNodeList(TreeNode parentNode, List<Map> maps) {
		for(Iterator<Map> it = maps.iterator();it.hasNext();){
			Map m = it.next();
			if(m.get(PARENTKEY).equals(parentNode.getId())){
				parentNode.getChildren().add(map2TreeNode(m, TreeNode.class, null));
				it.remove();
			}
		}
		if(parentNode.getChildren().size() > 0){
			parentNode.setLeaf(false);
		}
		if(maps.size() == 0){
			return;
		}
		if(parentNode.getChildren().size() > 0){
			for(TreeNode treeNode : parentNode.getChildren()){
				buildTreeNodeList(treeNode,maps);
			}
		}
		
		
	}

	private boolean isTopNode(Map m,List<Map> menusMap) {

		for(Map map : menusMap){
         
			if(m.get(PARENTKEY).equals(map.get(PRIMARYKEY))){
				return false;
			}   
		}
		
		return true;
	}

	private List<Map> getFuncsNode(String orgId, String roleId) {
		String sql = "";
		if(AuthConstant.ROOT_ORG_ID.equals(orgId)){
			sql = 	"SELECT f.func_id AS "+PRIMARYKEY+",\n" +
					"       m.menu_id AS "+PARENTKEY+",\n" + 
					"       f.func_c_name AS text,\n" + 
					"       '0' AS leaf,\n" + 
					"       '"+AuthConstant.FUNC+"' AS type,\n" + 
					"       CASE\n" + 
					"         WHEN (SELECT DISTINCT 1\n" + 
					"                 FROM p_auth_role_func_dms pf\n" + 
					"                WHERE pf.role_id = '"+roleId+"'\n" + 
					"                  AND pf.func_id = f.func_id) IS NULL THEN\n" + 
					"          'false'\n" + 
					"         ELSE\n" + 
					"          'true'\n" + 
					"       END AS checked,\n" + 
					"       f.*\n" + 
					"  FROM P_AUTH_FUNCTION_DMS f, p_auth_menu_func_dms mf, P_AUTH_MENU_DMS m\n" + 
					" WHERE m.parent_menu_id != '"+AuthConstant.ROOT_MENU_PARENT_MENUID+"'\n" + 
					"   AND f.func_id = mf.func_id\n" + 
					"   AND mf.menu_id = m.menu_id";
		}else{
			sql = 	"SELECT f.func_id AS "+PRIMARYKEY+",\n" +
					"       f.func_c_name AS text,\n" + 
					"       '0' AS leaf,\n" + 
					"       t.res_type AS type,\n" + 
					"       pf.menu_id AS "+PARENTKEY+",\n" + 
					"       CASE\n" + 
					"         WHEN (SELECT DISTINCT 1\n" + 
					"                 FROM p_auth_role_func_dms rf\n" + 
					"                WHERE rf.role_id = '"+roleId+"'\n" + 
					"                  AND rf.func_id = f.func_id) IS NULL THEN\n" + 
					"          'false'\n" + 
					"         ELSE\n" + 
					"          'true'\n" + 
					"       END AS checked,\n" + 
					"       f.*\n" + 
					"  FROM p_auth_org_resource_dms t,\n" + 
					"       P_AUTH_FUNCTION_DMS     f,\n" + 
					"       p_auth_menu_func_dms    pf,\n" + 
					"       p_auth_org_resource_dms t1\n" + 
					" WHERE t.org_id = '"+orgId+"'\n" + 
					"   AND t1.org_id = t.org_id\n" + 
					"   AND t1.res_type = '"+AuthConstant.MENU+"'\n" + 
					"   AND t1.res_id = pf.menu_id\n" + 
					"   AND t.res_type = '"+AuthConstant.FUNC+"'\n" + 
					"   AND f.func_id = t.res_id\n" + 
					"   AND pf.func_id = f.func_id";

		}	
		return jdbcDao.queryRecords(sql);
	}

	/**
	 * 返回机构对应的菜单节点
	 * @param userToken
	 * @return
	 */
	private List<Map> getMenusNode(String orgId,String roleId) {
		String sql = "";
		if(AuthConstant.ROOT_ORG_ID.equals(orgId)){
			sql = 	"SELECT t.*,\n" +
					"       (SELECT COUNT(*)\n" + 
					"          FROM (SELECT M1.PARENT_MENU_ID FROM P_AUTH_MENU_DMS M1, P_AUTH_MENU_DMS M2 WHERE M1.PARENT_MENU_ID = M2.MENU_ID) p\n" + 
					"         WHERE p.parent_menu_id = t.menu_id) AS leaf\n" + 
					"  FROM (SELECT m.menu_id AS "+PRIMARYKEY+",\n" + 
					"               m.parent_menu_id AS "+PARENTKEY+",\n" + 
					"               m.menu_c_name AS text,\n" + 
					"               m.menu_url AS href,\n" + 
					"               m.img_url AS icon,\n" + 
					"               '"+AuthConstant.MENU+"' AS type,\n" + 
					"               CASE\n" + 
					"                 WHEN (SELECT DISTINCT 1\n" + 
					"                         FROM p_auth_role_menu_dms rm\n" + 
					"                        WHERE rm.menu_id = m.menu_id\n" + 
					"                          AND rm.role_id = '"+roleId+"') IS NULL THEN\n" + 
					"                  'false'\n" + 
					"                 ELSE\n" + 
					"                  'true'\n" + 
					"               END AS checked,\n" + 
					"               m.*\n" + 
					"          FROM P_AUTH_MENU_DMS m , P_AUTH_MENU_DMS m1 where m.parent_menu_id = m1.menu_id) t\n" + 
					" ORDER BY t."+PARENTKEY+", t.order_num";


		}else{
			sql = 	"SELECT t.*,\n" +
					"       (SELECT COUNT(*)\n" + 
					"          FROM (SELECT m.parent_menu_id\n" + 
					"                  FROM p_auth_org_resource_dms t, P_AUTH_MENU_DMS m\n" + 
					"                 WHERE t.org_id = '"+orgId+"'\n" + 
					"                   AND t.res_type = '"+AuthConstant.MENU+"'\n" + 
					"                   AND m.menu_id = t.res_id) p\n" + 
					"         WHERE p.parent_menu_id = t.menu_id) AS leaf\n" + 
					"  FROM (SELECT m.menu_id AS "+PRIMARYKEY+",\n" + 
					"               m.parent_menu_id AS "+PARENTKEY+",\n" + 
					"               m.menu_c_name AS text,\n" + 
					"               m.menu_url AS href,\n" + 
					"               m.img_url AS icon,\n" + 
					"               r.res_type AS type,\n" + 
					"               CASE\n" + 
					"                 WHEN (SELECT DISTINCT 1\n" + 
					"                         FROM p_auth_role_menu_dms rm\n" + 
					"                        WHERE rm.role_id = '"+roleId+"'\n" + 
					"                          AND rm.menu_id = m.menu_id) IS NULL THEN\n" + 
					"                  'false'\n" + 
					"                 ELSE\n" + 
					"                  'true'\n" + 
					"               END AS checked,\n" + 
					"               m.*\n" + 
					"          FROM p_auth_org_resource_dms r, P_AUTH_MENU_DMS m\n" + 
					"         WHERE r.org_id = '"+orgId+"'\n" + 
					"           AND r.res_type = '"+AuthConstant.MENU+"'\n" + 
					"           AND m.menu_id = r.res_id) t\n" + 
					" ORDER BY "+PARENTKEY+", order_num";


		}		
		return jdbcDao.queryRecords(sql);
	}
	
	public void saveTreeData(ISrvMsg reqDTO) throws Exception {
		String jsonStr = reqDTO.getValue("nodes"),
		   	   roleId = reqDTO.getValue("id");
		JSONArray jsonArr = JSONArray.fromObject(jsonStr);
		List<String> execSqls = new ArrayList<String>();
		for(int i = 0 ; i < jsonArr.size() ; i++){
			JSONObject jsonObj = jsonArr.getJSONObject(i);
			boolean checked = jsonObj.getBoolean("checked");
			String type  = jsonObj.getString("type"),id = jsonObj.getString("id");
			if(checked){
				if(AuthConstant.MENU.equals(type)){
					execSqls.add("insert into p_auth_role_menu_dms(ROLE_MENU_ID,ROLE_ID,MENU_ID) values('"+jdbcDao.generateUUID()+"','"+roleId+"','"+id+"')");
				}else if(AuthConstant.FUNC.equals(type)){
					execSqls.add("insert into p_auth_role_func_dms(ROLE_FUNC_ID,ROLE_ID,FUNC_ID) values('"+jdbcDao.generateUUID()+"','"+roleId+"','"+id+"')");
				}
			}else{
				if(AuthConstant.MENU.equals(type)){
					execSqls.add("DELETE FROM p_auth_role_menu_dms WHERE ROLE_ID = '"+roleId+"' AND MENU_ID = '"+id+"'");
//					execSqls.add("DELETE FROM p_auth_user_defined_menu WHERE user_id in (select user_id from p_auth_user_role where ROLE_ID = '"+roleId+"') AND MENU_ID = '"+id+"'");
				}else if(AuthConstant.FUNC.equals(type)){
					execSqls.add("DELETE FROM p_auth_role_func_dms WHERE ROLE_ID = '"+roleId+"' AND FUNC_ID = '"+id+"'");
				}
			}
		}
		if(execSqls.size() > 0){
			jdbcDao.getJdbcTemplate().batchUpdate(execSqls.toArray(new String[execSqls.size()]));
		}
	}
	private void  validateUser(UserToken userToken) throws RetCodeException{
		
	}
	
}
