package com.cnpc.sais.ibp.auth2.srv;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.sais.ibp.auth.pojo.PAuthOrg;
import com.cnpc.sais.ibp.auth2.pojo.TreeNode;
import com.cnpc.sais.ibp.auth2.util.AuthConstant;

@SuppressWarnings("unchecked")
public class OrgTreeBO extends BaseTreeBO implements ITreeBO {
	
	public void saveTreeData(ISrvMsg reqDTO) throws Exception {
		String jsonStr = reqDTO.getValue("nodes"),
			   orgId = reqDTO.getValue("id");
		JSONArray jsonArr = JSONArray.fromObject(jsonStr);
		List<PAuthOrg> result = new ArrayList<PAuthOrg>();
		StringBuffer sb = new StringBuffer();
		getSubOrgs(orgId,result);
		for(PAuthOrg org : result){
			sb.append(",'"+org.getOrgId()+"'");
		}
		List<String> execSqls = new ArrayList<String>();
		StringBuffer delOrgRes = new StringBuffer(),
					 delMenu = new StringBuffer(),
					 delFunc = new StringBuffer();
		for(int i = 0 ; i < jsonArr.size() ; i++){
			JSONObject jsonObj = jsonArr.getJSONObject(i);
			boolean checked = jsonObj.getBoolean("checked");
			if(checked){
				List<Map> t = jdbcDao.queryRecords("select distinct 1 from p_auth_org_resource_dms where org_id = '"+orgId+"' and res_id = '"+jsonObj.getString("id")+"'");
				if(t.size() == 0){
					execSqls.add("insert into p_auth_org_resource_dms(ORG_RES_ID,ORG_ID,RES_ID,RES_TYPE) values('"+jdbcDao.generateUUID()+"','"+orgId+"','"+jsonObj.getString("id")+"','"+jsonObj.getString("type")+"')");
				}
			}else{
				String type = jsonObj.getString("type");
				String id = jsonObj.getString("id");
				
				delOrgRes.append("'"+id+"',");
				if(AuthConstant.MENU.equals(type)){
					delMenu.append("'"+id+"',");
					
				}else if(AuthConstant.FUNC.equals(type)){
					delFunc.append("'"+id+"',");
				}
			}
		}
		String sql = "";
		if(delOrgRes.length() > 0){
			sql =	"DELETE FROM p_auth_org_resource_dms " +
					" WHERE RES_ID in ("+delOrgRes.deleteCharAt(delOrgRes.length()-1)+")" + 
					"   AND ORG_ID IN ('"+orgId+"'"+sb+")";
			execSqls.add(sql);
		}
		if(delMenu.length() > 0){
			sql = 	"DELETE FROM p_auth_role_menu_dms \n" +
					" WHERE EXISTS (SELECT 1\n" + 
					"          FROM P_AUTH_ROLE_DMS PR\n" + 
					"         WHERE PR.ROLE_ID = ROLE_ID\n" + 
					"           AND MENU_ID in ("+delMenu.deleteCharAt(delMenu.length()-1)+")" + 
					"           AND PR.USER_ORG_ID IN ('"+orgId+"'"+sb+"))";
			execSqls.add(sql);
//			sql =   "DELETE FROM p_auth_user_defined_menu\n" +
//					" WHERE menu_id IN ("+delMenu+")" + 
//					"   AND EXISTS (SELECT 1\n" + 
//					"          FROM (SELECT pu.user_id\n" + 
//					"                  FROM p_auth_user pu\n" + 
//					"                 WHERE pu.org_id IN ('"+orgId+"'"+sb+")) p\n" + 
//					"         WHERE p.user_id = user_id)";
//			execSqls.add(sql);
		}
		if(delFunc.length() > 0){
			sql = 	"DELETE FROM p_auth_role_func_dms\n" +
					" WHERE EXISTS (SELECT 1\n" + 
					"          FROM P_AUTH_ROLE_DMS PR\n" + 
					"         WHERE PR.ROLE_ID = ROLE_ID\n" + 
					"           AND FUNC_ID in ("+delFunc.deleteCharAt(delFunc.length()-1)+")" + 
					"           AND PR.USER_ORG_ID IN ('"+orgId+"'"+sb+"))";
			execSqls.add(sql);
		}
		if(execSqls.size() > 0){
			jdbcDao.getJdbcTemplate().batchUpdate(execSqls.toArray(new String[execSqls.size()]));
		}
		
	}
	private void getSubOrgs(String orgId,List<PAuthOrg> result){
		List<PAuthOrg> subOrgs = baseDao.queryByHql("from PAuthOrg WHERE parentId='" + orgId + "'");
		result.addAll(subOrgs);
		if(subOrgs.size() > 0 ){
			for(PAuthOrg subOrg : subOrgs){
				getSubOrgs(subOrg.getOrgId(),result);
			}
		}
	}
	public List<TreeNode> getTreeData(ISrvMsg reqDTO) {
		List<TreeNode> result = new ArrayList<TreeNode>();
		try {
			UserToken userToken = reqDTO.getUserToken();
			String userOrgId =  userToken.getOrgId(),
				   orgId = StringUtils.trimToEmpty(reqDTO.getValue("id")),
				   sql = "";
			boolean isSupperAdmin = false;
			if(AuthConstant.ROOT_ORG_ID.equals(userOrgId)){
				isSupperAdmin = true;
			}
			//菜单节点
			if(isSupperAdmin){//超级管理员
				sql = 	"SELECT M.*,\n" +
						"       M.MENU_ID AS "+PRIMARYKEY+",\n" + 
						"       M.MENU_C_NAME AS TEXT,\n" + 
						"       M.MENU_URL AS HREF,\n" + 
						"       '"+AuthConstant.MENU+"' AS TYPE,\n" + 
						"       M.PARENT_MENU_ID AS "+PARENTKEY+",\n" + 
						"       CASE\n" + 
						"         WHEN (SELECT DISTINCT 1\n" + 
						"                 FROM p_auth_org_resource_dms R\n" + 
						"                WHERE R.RES_TYPE = '"+AuthConstant.MENU+"'\n" + 
						"                  AND R.RES_ID = M.MENU_ID\n" + 
						"                  AND R.ORG_ID = '"+orgId+"') IS NOT NULL THEN\n" + 
						"          'true'\n" + 
						"         ELSE\n" + 
						"          'false'\n" + 
						"       END AS CHECKED\n" + 
						"  FROM P_AUTH_MENU_DMS M\n" + 
						" CROSS JOIN P_AUTH_MENU_DMS M1\n" + 
						" WHERE M.PARENT_MENU_ID = M1.MENU_ID\n" + 
						" ORDER BY M.PARENT_MENU_ID, M.ORDER_NUM";
			}else{//非超级管理员
				sql = 	"SELECT M.*,\n" +
						"       M.MENU_ID AS "+PRIMARYKEY+",\n" + 
						"       '"+AuthConstant.MENU+"' AS TYPE,\n" + 
						"       M.MENU_C_NAME AS TEXT,\n" + 
						"       M.MENU_URL AS HREF,\n" + 
						"       M.PARENT_MENU_ID AS "+PARENTKEY+",\n" + 
						"       CASE\n" + 
						"         WHEN (SELECT DISTINCT 1\n" + 
						"                 FROM p_auth_org_resource_dms R\n" + 
						"                WHERE R.RES_TYPE = '"+AuthConstant.MENU+"'\n" + 
						"                  AND R.RES_ID = M.MENU_ID\n" + 
						"                  AND R.ORG_ID = '"+orgId+"') IS NOT NULL THEN\n" + 
						"          'true'\n" + 
						"         ELSE\n" + 
						"          'false'\n" + 
						"       END AS CHECKED\n" + 
						"  FROM p_auth_org_resource_dms PR, P_AUTH_MENU_DMS M\n" + 
						" WHERE PR.ORG_ID = '"+userOrgId+"'\n" + 
						"   AND PR.RES_TYPE = '"+AuthConstant.MENU+"'\n" + 
						"   AND M.MENU_ID = PR.RES_ID ORDER BY M.PARENT_MENU_ID, M.ORDER_NUM";
			}
			List<Map> menusMap = jdbcDao.queryRecords(sql);
			List<TreeNode> menus = covert2TreeNodeList(menusMap,PRIMARYKEY,PARENTKEY);
			//功能节点
			if(isSupperAdmin){
				sql = 	"SELECT F.*,'"+AuthConstant.FUNC+"' AS TYPE,F.FUNC_C_NAME AS TEXT,F.FUNC_ID AS "+PRIMARYKEY+",P.MENU_ID AS "+PARENTKEY+
						",CASE WHEN (SELECT DISTINCT 1 FROM p_auth_org_resource_dms R,p_auth_org_resource_dms R1 WHERE R.RES_TYPE = '"+AuthConstant.FUNC+
						"' AND R.ORG_ID = '"+orgId+
						"' AND R.RES_ID = PF.FUNC_ID AND PF.MENU_ID = R1.RES_ID AND R1.ORG_ID = R.ORG_ID AND R1.RES_TYPE = '"+AuthConstant.MENU+
						"') IS NOT NULL THEN 'true' ELSE 'false' END AS CHECKED FROM p_auth_menu_func_dms PF,P_AUTH_FUNCTION_DMS F,(SELECT M2.MENU_ID FROM P_AUTH_MENU_DMS M1 CROSS JOIN P_AUTH_MENU_DMS M2 WHERE M1.MENU_ID = M2.PARENT_MENU_ID) P WHERE P.MENU_ID = PF.MENU_ID AND PF.FUNC_ID = F.FUNC_ID";
			}else{
				sql =  	"SELECT F.*,'"+AuthConstant.FUNC+"' AS TYPE,\n" +
						"       F.FUNC_ID AS "+PRIMARYKEY+",\n" + 
						"       PF.MENU_ID AS "+PARENTKEY+",F.FUNC_C_NAME AS TEXT,\n" + 
						"       CASE WHEN (SELECT DISTINCT 1\n" + 
						"              FROM p_auth_org_resource_dms R\n" + 
						"             WHERE R.RES_TYPE = '"+AuthConstant.FUNC+"'\n" + 
						"               AND R.ORG_ID = '"+orgId+"'\n" + 
						"               AND R.RES_ID = PR.RES_ID) IS NOT NULL THEN 'true' ELSE 'false' END AS CHECKED\n" + 
						"  FROM p_auth_org_resource_dms PR,p_auth_org_resource_dms PR1 ,P_AUTH_FUNCTION_DMS F, p_auth_menu_func_dms PF\n" + 
						" WHERE PR.RES_TYPE = '"+AuthConstant.FUNC+"'\n" + 
						"   AND PR.ORG_ID = '"+userOrgId+"'\n" + 
						"   AND PR.RES_ID = F.FUNC_ID\n" + 
						"   AND PF.FUNC_ID = F.FUNC_ID AND PR1.RES_TYPE='"+AuthConstant.MENU+"' AND PR1.RES_ID = PF.MENU_ID AND PR1.ORG_ID = PR.ORG_ID";

			}
			List<Map> funcsMap = jdbcDao.queryRecords(sql);
			insertFuncAsNode(menus,funcsMap,PRIMARYKEY,PARENTKEY);
			result = menus;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	protected List<TreeNode> covert2TreeNodeList(List<Map> maps,String primaryKey , String parentKey) {
		TreeNode topNode = new TreeNode();
		List<Map> temp  = new ArrayList<Map>();
		for(Iterator<Map> it = maps.iterator();it.hasNext();){
			Map map = it.next();
			if(!containsKey(maps,primaryKey,(String) map.get(parentKey))){
				topNode.getChildren().add(map2TreeNode(map));
				temp.add(map);
			}
		}
		maps.removeAll(temp);
		for(TreeNode treeNode : topNode.getChildren()){
			buildTree(treeNode,maps,parentKey);
		}
		return topNode.getChildren();
	}
	protected boolean containsKey(List<Map> maps,String key,String value){
		for(Map<String,String> m : maps){
			if(value.equals(m.get(key))){
				return true;
			}
		}
		return false;
	}
	
	protected void buildTree(TreeNode parentNode,List<Map> maps,String parentKey){
		for(Iterator<Map> it = maps.iterator();it.hasNext();){
			Map m = it.next();
			if(m.get(parentKey).equals(parentNode.getId())){
				parentNode.getChildren().add(map2TreeNode(m));
				it.remove();
			}
		}
		if(parentNode.getChildren().size() == 0){
			parentNode.setLeaf(true);
		}
		if(maps.size() == 0){
			return;
		}
		if(parentNode.getChildren().size() > 0){
			for(TreeNode treeNode : parentNode.getChildren()){
				buildTree(treeNode,maps,parentKey);
			}
		}
	}
	protected void insertFuncAsNode (List<TreeNode> menus,List<Map> funcsMap,String primaryKey,String parentkey){
		List<TreeNode> nodes  = new ArrayList<TreeNode>();
		getAllTreeNode(nodes,menus);
		for(TreeNode treeNode : nodes){
			for(Iterator<Map> it = funcsMap.iterator();it.hasNext();){
				Map<String,String> funcMap = it.next();
				if(funcMap.get(parentkey).equals(treeNode.getId())){
					funcMap.put("LEAF", "true");
					treeNode.setLeaf(false);
					treeNode.getChildren().add(map2TreeNode(funcMap));
					it.remove();
				}
			}
		}
		for(TreeNode treeNode : nodes){
			if(treeNode.getChildren().size() == 0){
				treeNode.setLeaf(true);
			}
		}
	}
	protected void getAllTreeNode(List<TreeNode> list,List<TreeNode> menus){
		for(int i = 0 ; i < menus.size() ; i++){
			TreeNode node = menus.get(i);
			list.add(node);
			if(node.getChildren().size() > 0 ){
				getAllTreeNode(list,node.getChildren());
			}
		}
	}
	protected  TreeNode map2TreeNode (Map<String,String> map){
		TreeNode treeNode = new TreeNode();
		for(String key : map.keySet()){
			if("ID".equalsIgnoreCase(key)){
				treeNode.setId(map.get(key));
			}else if("TEXT".equalsIgnoreCase(key)){
				treeNode.setText(map.get(key));
			}else if("HREF".equalsIgnoreCase(key)){
				treeNode.setHref(map.get(key));
			}else if("CHECKED".equalsIgnoreCase(key)){
				treeNode.setChecked(Boolean.valueOf(map.get(key)));
			}else if("LEAF".equalsIgnoreCase(key)){
				treeNode.setLeaf(Boolean.valueOf(map.get(key)));
			}else if("TYPE".equalsIgnoreCase(key)){
				treeNode.setType(map.get(key));
			}else{
				treeNode.getData().put(key.toUpperCase(), map.get(key));
			}
		}
		return treeNode;
	}
}
