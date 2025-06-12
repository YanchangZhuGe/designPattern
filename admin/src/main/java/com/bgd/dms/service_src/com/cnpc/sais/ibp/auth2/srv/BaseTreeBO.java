package com.cnpc.sais.ibp.auth2.srv;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.BaseDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.sais.ibp.auth2.pojo.TreeNode;

@SuppressWarnings("unchecked")
public class BaseTreeBO {
	
	protected BaseDao baseDao = (BaseDao) BeanFactory.getBaseDao();
	protected RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	protected static final String PARENTKEY = "parentid";
	protected static final String PRIMARYKEY = "id";
	
	/**
	 * 返回最终需要的树节点，filterNodesMap用来设定nodesMap中的leaf和checked属性
	 * @param nodesMap
	 * @param filterNodesMap
	 * @return
	 */
	public List<TreeNode> merge2TreeNode(Map<String,Map> nodesMap,Map<String,Map> filterNodesMap){
		List<TreeNode> temp = new ArrayList<TreeNode>();
		for(String key : nodesMap.keySet()){
			TreeNode treeNode = map2TreeNode(nodesMap.get(key), TreeNode.class, null);
			if(filterNodesMap.containsKey(key)){
				treeNode.setChecked(true);
			}
			temp.add(treeNode);
		}
		return builderTree(temp);
	}
	private List<TreeNode> builderTree(List<TreeNode> nodes) {
		TreeNode topNode = new TreeNode();
		for(Iterator<TreeNode> it = nodes.iterator();it.hasNext();){
			TreeNode node  = it.next();
			if(isRootNode(node,nodes)){
				topNode.getChildren().add(node);
				it.remove();
			}
		}
		for(TreeNode treeNode : topNode.getChildren()){
			_buildTree(treeNode,nodes);
		}
		return topNode.getChildren();
	}
	private boolean isRootNode(TreeNode node, List<TreeNode> nodes) {
		for(TreeNode tn : nodes){
			if(node.getData().get(PARENTKEY.toUpperCase()).equals(tn.getId())){
				return false;
			}
		}
		return true;
	}
	private void _buildTree(TreeNode parentNode,List<TreeNode> nodes){
		for (Iterator<TreeNode> it = nodes.iterator(); it.hasNext();) {
			TreeNode node = it.next();
			if (node.getData().get(PARENTKEY.toUpperCase()).equals(parentNode.getId())) {
				parentNode.getChildren().add(node);
				it.remove();
			}
		}
		if (parentNode.getChildren().size() == 0) {
			parentNode.setLeaf(true);
		}
		if (nodes.size() == 0) {
			return;
		}
		if (parentNode.getChildren().size() > 0) {
			for (TreeNode treeNode : parentNode.getChildren()) {
				_buildTree(treeNode, nodes);
			}
		}
	}
	protected List<TreeNode> convert2TreeNodeList(List<Map> maps,String primaryKey , String parentKey) {
		TreeNode topNode = new TreeNode();
		List<Map> temp  = new ArrayList<Map>();
		for(Iterator<Map> it = maps.iterator();it.hasNext();){
			Map map = it.next();
			if(!containsKey(maps,primaryKey,(String) map.get(parentKey))){
				topNode.getChildren().add(map2TreeNode(map,TreeNode.class,null));
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
				parentNode.getChildren().add(map2TreeNode(m,TreeNode.class,null));
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
	/**
	 * 现在返回TreeNode，根据TreeNode的属性来封装,
	 * 额外属性放在data属性里面
	 * @param map
	 * @return
	 * TODO 后续改造成动态指定额外属性，通用的封装POJO的方法
	 */

	protected <T> T  map2TreeNode (Map<String,String> map,Class<T> clazz,String extraProperty){
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
				if(Integer.valueOf(map.get(key)) > 0){
					treeNode.setLeaf(false);
				}else{
					treeNode.setLeaf(true);
				}
			}else if("TYPE".equalsIgnoreCase(key)){
				treeNode.setType(map.get(key));
				
			}else if("MENU_HINT".equalsIgnoreCase(key)){
				//提示信息  吴海军修改 2013年11月26日
				Object menuHint = map.get(key);
				if (menuHint == null)
					menuHint = "";
				treeNode.setQtip(menuHint.toString());
			}else{
				if(extraProperty == null)
					treeNode.getData().put(key.toUpperCase(), map.get(key));
			}
		}
		return (T) treeNode;
	}
	public List<TreeNode> getTreeData(ISrvMsg reqDTO) throws Exception{
		return new ArrayList<TreeNode>();
	}
	public void saveTreeData(ISrvMsg reqDTO) throws Exception{
		
	}
}
