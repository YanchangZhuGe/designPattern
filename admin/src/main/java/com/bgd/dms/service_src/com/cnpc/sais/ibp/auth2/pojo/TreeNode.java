package com.cnpc.sais.ibp.auth2.pojo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("serial")
public class TreeNode implements Serializable {
	
	public final static String UNCHOOSED = "0";
	public final static String PARCHOOSED = "1";//半选状态
	public final static String CHOOSED = "2";
	
	public TreeNode(){
		this(null,null);
	}
	public TreeNode(String id,String text){
		this(id,text,null);
	}
	public TreeNode(String id,String text ,String type){
		this.id = id;
		this.text = id;
		this.type = type;
	}
	/**
	 * 表示树节点的类型
	 */
	private String type;
	/**
	 * 是否显示CheckBox
	 * true表示选中
	 * false 表示不选中
	 */
	private Boolean checked = null;
	/**
	 * 是否禁止选中
	 */
	private boolean disabled;
	/**
	 * 表示是否为叶子节点
	 */
	private boolean leaf;
	/**
	 * 表示节点的选择状态, 在checked为true，1 表示半选 ， 2 表示选中 
	 * 在checked为false,只能为0 表示未选中
	 * 在checked为null,只能为null表示没有选中
	 */
	private String checkState = null;
	/**
	 * 是否隐藏
	 */
	private Boolean hidden = false;
	/***
	 * 节点的唯一表示
	 */
	private String id;
	/***
	 * 页面上节点的表示文本
	 */
	private String text;
	/**
	 * 节点的图标路径
	 */
	private String icon ;
	/**
	 * 节点的CSS样式
	 */
	private String iconCls;
	/**
	 * 点击节点调到的链接地址
	 */
	private String href;
	/**
	 * 链接地址目标的frame
	 */
	private String hrefTarget;

	/**
	 * 包含的子节点
	 */
	private List<TreeNode> children = new ArrayList<TreeNode>();

	/**
	 * 节点的父节点
	 */
	private TreeNode parentTreeNode;

	/**
	 * 存放节点自定义参数 比如：tpath 节点在树中的路径，表示比如：0.1.2,此参数不能由用户设置，由程序自动生成 0表示根节点，1
	 * 表示根节点下面的第二个节点，2表示第二个节点下面的 第3个节点, 参数可以迅速定位节点的层次关系
	 */
	private Map<String, String> params = new HashMap<String,String>();
	/**
	 * 存放节点包含的自定义数据
	 */
	private Map<String, String> data = new HashMap<String,String>();

	/**
	 * 存放节点所属树的参数
	 */
	private Map<String, String> treeParams = new HashMap<String,String>();
	
	/**
	 * 菜单提示信息
	 */
	private String qtip ;

	public String getQtip()
	{
		return qtip;
	}
	public void setQtip(String qtip)
	{
		this.qtip = qtip;
	}
	public Boolean getChecked() {
		return checked;
	}

	public void setChecked(Boolean checked) {
		this.checked = checked;
	}

	public boolean isDisabled() {
		return disabled;
	}
	public void setDisabled(boolean disabled) {
		this.disabled = disabled;
	}
	public boolean isLeaf() {
		return leaf;
	}
	public void setLeaf(boolean leaf) {
		this.leaf = leaf;
	}
	public String getCheckState() {
		return checkState;
	}

	public void setCheckState(String checkState) {
		this.checkState = checkState;
	}

	public Boolean getHidden() {
		return hidden;
	}

	public void setHidden(Boolean hidden) {
		this.hidden = hidden;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getIconCls() {
		return iconCls;
	}

	public void setIconCls(String iconCls) {
		this.iconCls = iconCls;
	}

	public String getHref() {
		return href;
	}

	public void setHref(String href) {
		this.href = href;
	}

	public String getHrefTarget() {
		return hrefTarget;
	}

	public void setHrefTarget(String hrefTarget) {
		this.hrefTarget = hrefTarget;
	}

	public List<TreeNode> getChildren() {
		return children;
	}

	public void setChildren(List<TreeNode> children) {
		this.children = children;
	}

	public TreeNode getParentTreeNode() {
		return parentTreeNode;
	}

	public void setParentTreeNode(TreeNode parentTreeNode) {
		this.parentTreeNode = parentTreeNode;
	}

	public Map<String, String> getParams() {
		return params;
	}

	public void setParams(Map<String, String> params) {
		this.params = params;
	}

	public Map<String, String> getData() {
		return data;
	}

	public void setData(Map<String, String> data) {
		this.data = data;
	}

	public Map<String, String> getTreeParams() {
		return treeParams;
	}

	public void setTreeParams(Map<String, String> treeParams) {
		this.treeParams = treeParams;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getIcon() {
		return icon;
	}
	public void setIcon(String icon) {
		this.icon = icon;
	}
	
}
