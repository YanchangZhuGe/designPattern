package com.cnpc.sais.ibp.auth2.srv;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.sais.ibp.auth2.pojo.TreeNode;
import com.cnpc.sais.ibp.auth2.util.AuthConstant;

@SuppressWarnings("unchecked")
public class UserTreeBO extends BaseTreeBO implements ITreeBO {
	
	public List<TreeNode> getTreeData(ISrvMsg reqDTO) throws Exception {
		UserToken userToken = reqDTO.getUserToken();
		String userOrgId = userToken.getOrgId(),
			   userId = userToken.getUserId();
		//1.查询菜单节点
		List<Map> menusNode = getMenusNode(userOrgId,userId);
		//2.查询功能节点
		List<Map> funcsNode = getFuncsNode(userOrgId,userId);
		//3.设定checked和leaf属性
		return merge2TreeNodeList(menusNode,funcsNode);
	}
	
	public List<TreeNode> getCollTreeData(ISrvMsg reqDTO) throws Exception {
		UserToken userToken = reqDTO.getUserToken();
		String userOrgId = userToken.getOrgId(),
			   userId = userToken.getUserId();
		//1.查询菜单节点
		List<Map> menusNode = getCollMenusNode(userOrgId,userId);
		//2.查询功能节点
		List<Map> funcsNode = new ArrayList<Map>();
		//3.设定checked和leaf属性
		return merge2TreeNodeList(menusNode,funcsNode);
	}
	public void saveCollTreeData(ISrvMsg reqDTO) throws Exception {
		String jsonStr = reqDTO.getValue("nodes"),
		   	   roleId = reqDTO.getValue("id");
		UserToken user =reqDTO.getUserToken();
		String userId=user.getUserId();
		JSONArray jsonArr = JSONArray.fromObject(jsonStr);
		List<String> execSqls = new ArrayList<String>();
		for(int i = 0 ; i < jsonArr.size() ; i++){
			JSONObject jsonObj = jsonArr.getJSONObject(i);
			boolean checked = jsonObj.getBoolean("checked");
			String type  = jsonObj.getString("type"),id = jsonObj.getString("id");
			if(AuthConstant.MENU.equals(type)){
				if(checked){
						execSqls.add("insert into p_auth_menu_dms_collection(COLL_ID,EMPLOYEE_ID,MENU_ID,ORDER_NUM,CHECK_FLAG) values('"+jdbcDao.generateUUID()+"','"+userId+"','"+id+"',"+i+",'true')");
				}else{
						execSqls.add("DELETE FROM p_auth_menu_dms_collection WHERE EMPLOYEE_ID = '"+userId+"' AND MENU_ID = '"+id+"'");
				}
			}
		}
		if(execSqls.size() > 0){
			jdbcDao.getJdbcTemplate().batchUpdate(execSqls.toArray(new String[execSqls.size()]));
		}
	}
	
	private List<TreeNode> merge2TreeNodeList(List<Map> menusMap, List<Map> funcsMap) {
		menusMap.addAll(funcsMap);
		TreeNode root = new TreeNode();//虚拟根节点
		List<Map> temp = new ArrayList<Map>();
		for(Iterator<Map> it = menusMap.iterator();it.hasNext();){
			Map m = it.next();
			if(isTopNode(m,menusMap)){
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

	private List<Map> getFuncsNode(String orgId, String userId) {
		String sql = "";
		//超级管理员
		if(AuthConstant.SUPER_ADMIN_ID.equals(userId)){
			sql = 	"SELECT pf.func_id AS "+PRIMARYKEY+",\n" +
					"       pm.menu_id AS "+PARENTKEY+",\n" + 
					"       pf.func_c_name AS text,\n" + 
					"       '"+AuthConstant.FUNC+"' AS type,\n" + 
					"       '0' AS leaf,\n" + 
					"       'true' AS checked,\n" + 
					"       pf.*\n" + 
					"  FROM P_AUTH_FUNCTION_DMS pf, P_AUTH_MENU_DMS pm, p_auth_menu_func_dms pmf\n" + 
					" WHERE pf.func_id = pmf.func_id\n" + 
					"   AND pm.menu_id = pmf.menu_id";
		}else{
			sql = 	"SELECT DISTINCT pf.*,\n" +
					"       pf.func_id AS "+PRIMARYKEY+",\n" + 
					"       (SELECT pmf.menu_id\n" + 
					"          FROM p_auth_menu_func_dms pmf\n" + 
					"         WHERE pmf.func_id = pf.func_id) AS "+PARENTKEY+",\n" + 
					"       pf.func_c_name AS text,\n" + 
					"       '"+AuthConstant.FUNC+"' AS type,\n" + 
					"       'true' AS checked,\n" + 
					"       '0' AS leaf\n" + 
					"  FROM (SELECT pf.*\n" + 
					"          FROM P_AUTH_USER_ROLE_DMS pr, p_auth_role_func_dms prf, P_AUTH_FUNCTION_DMS pf\n" + 
					"         WHERE pr.user_id = '"+userId+"'\n" + 
					"           AND pr.role_id = prf.role_id\n" + 
					"           AND pf.func_id = prf.func_id\n" + 
					"        UNION ALL\n" + 
					"        SELECT pf.*\n" + 
					"          FROM P_AUTH_MENU_DMS pm, p_auth_menu_func_dms pmf, P_AUTH_FUNCTION_DMS pf\n" + 
					"         WHERE pm.menu_id = '"+AuthConstant.COMMON_ROLE_ID+"'\n" + 
					"           AND pmf.menu_id = pm.menu_id\n" + 
					"           AND pf.func_id = pmf.func_id) pf";
		}	
		return jdbcDao.queryRecords(sql);
	}

	/**
	 * 返回机构对应的菜单节点
	 * @param userToken
	 * @return
	 */
	private List<Map> getMenusNode(String orgId,String userId) {
		String sql = "";
		//超级管理员
		if(AuthConstant.SUPER_ADMIN_ID.equals(userId)){
			sql = 	"SELECT DISTINCT m.*,\n" +
					"                m.menu_id AS "+PRIMARYKEY+",\n" + 
					"                m.parent_menu_id AS "+PARENTKEY+",\n" + 
					"                m.menu_c_name AS text,\n" + 
					"                m.menu_url AS href,'"+AuthConstant.MENU +"' as type,\n" + 
					"                'true' AS checked,\n" + 
					"                (SELECT COUNT(*)\n" + 
					"                   FROM P_AUTH_MENU_DMS m1\n" + 
					"                  WHERE m1.parent_menu_id = m.menu_id) AS leaf\n" + 
					"  FROM P_AUTH_MENU_DMS m\n" + 
					" WHERE m.parent_menu_id != '"+AuthConstant.ROOT_MENU_PARENT_MENUID+"' ORDER BY "+PARENTKEY+", order_num";
		}else{
			sql = 	"SELECT DISTINCT p.*,\n" +
					"                p.menu_id AS "+PRIMARYKEY+",\n" + 
					"                p.parent_menu_id AS "+PARENTKEY+",\n" + 
					"                p.menu_c_name AS text,\n" + 
					"                p.menu_url AS href,\n" + 
					"                '"+AuthConstant.MENU+"' AS type,\n" + 
					"                'true' AS checked,\n" + 
					"                (SELECT COUNT(*)\n" + 
					"                   FROM P_AUTH_MENU_DMS m1\n" + 
					"                  WHERE m1.parent_menu_id = p.menu_id) AS leaf\n" + 
					"  FROM (SELECT m.*\n" + 
					"          FROM P_AUTH_USER_ROLE_DMS pr, p_auth_role_menu_dms pm, P_AUTH_MENU_DMS m\n" + 
					"         WHERE pr.user_id = '"+userId+"'\n" + 
					"           AND pm.role_id = pr.role_id\n" + 
					"           AND m.menu_id = pm.menu_id\n" + 
					"        UNION\n" + 
					"        SELECT m.*\n" + 
					"          FROM p_auth_role_menu_dms pm, P_AUTH_MENU_DMS m\n" + 
					"         WHERE pm.role_id = '"+AuthConstant.COMMON_ROLE_ID+"'\n" + 
					"           AND pm.menu_id = m.menu_id) p\n" + 
					" ORDER BY "+PARENTKEY+", order_num";
		}		
		return jdbcDao.queryRecords(sql);
	}
	
	private List<Map> getCollMenusNode(String orgId,String userId) {
		String sql = "";
		sql = 	"SELECT DISTINCT p.*,\n" +
					"                p.menu_id AS "+PRIMARYKEY+",\n" + 
					"                p.parent_menu_id AS "+PARENTKEY+",\n" + 
					"                p.menu_c_name AS text,\n" + 
					"                p.menu_url AS href,\n" + 
					"                '"+AuthConstant.MENU+"' AS type,\n" + 
					"                dc.check_flag AS checked,\n" + 
					"                (SELECT COUNT(*)\n" + 
					"                   FROM P_AUTH_MENU_DMS m1\n" + 
					"                  WHERE m1.parent_menu_id = p.menu_id) AS leaf\n" + 
					"  FROM (SELECT m.* ,pr.user_id \n" + 
					"          FROM P_AUTH_USER_ROLE_DMS pr, p_auth_role_menu_dms pm, P_AUTH_MENU_DMS m\n" + 
					"         WHERE pr.user_id = '"+userId+"'\n" + 
					"           AND pm.role_id = pr.role_id\n" + 
					"           AND m.menu_id = pm.menu_id\n" + 
					"        UNION\n" + 
					"        SELECT m.* ,'"+userId+"' as user_id \n" + 
					"          FROM p_auth_role_menu_dms pm, P_AUTH_MENU_DMS m\n" + 
					"         WHERE pm.role_id = '"+AuthConstant.COMMON_ROLE_ID+"'\n" + 
					"           AND pm.menu_id = m.menu_id  ) p left join p_auth_menu_dms_collection dc on p.menu_id=dc.menu_id and dc.employee_id=p.user_id \n" + 
					" ORDER BY "+PARENTKEY+", p.order_num";
		
		return jdbcDao.queryRecords(sql);
	}
	
	public List<Map> getCollLinks(String userId) {
		String sql = "";
		sql = 	"SELECT distinct d.menu_id,d.menu_c_name,d.menu_url,d.order_num FROM  \n" + 
					" P_AUTH_MENU_DMS_COLLECTION c \n" + 
					" left join P_AUTH_MENU_DMS d on c.menu_id=d.menu_id \n" + 
					" where c.employee_id='"+userId+"' \n" + 
					" and d.menu_url is not null";
		
		return jdbcDao.queryRecords(sql);
	}

}
