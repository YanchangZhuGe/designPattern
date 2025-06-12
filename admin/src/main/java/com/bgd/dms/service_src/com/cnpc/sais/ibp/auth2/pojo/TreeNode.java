package com.cnpc.sais.ibp.auth2.pojo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("serial")
public class TreeNode implements Serializable {
	
	public final static String UNCHOOSED = "0";
	public final static String PARCHOOSED = "1";//��ѡ״̬
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
	 * ��ʾ���ڵ������
	 */
	private String type;
	/**
	 * �Ƿ���ʾCheckBox
	 * true��ʾѡ��
	 * false ��ʾ��ѡ��
	 */
	private Boolean checked = null;
	/**
	 * �Ƿ��ֹѡ��
	 */
	private boolean disabled;
	/**
	 * ��ʾ�Ƿ�ΪҶ�ӽڵ�
	 */
	private boolean leaf;
	/**
	 * ��ʾ�ڵ��ѡ��״̬, ��checkedΪtrue��1 ��ʾ��ѡ �� 2 ��ʾѡ�� 
	 * ��checkedΪfalse,ֻ��Ϊ0 ��ʾδѡ��
	 * ��checkedΪnull,ֻ��Ϊnull��ʾû��ѡ��
	 */
	private String checkState = null;
	/**
	 * �Ƿ�����
	 */
	private Boolean hidden = false;
	/***
	 * �ڵ��Ψһ��ʾ
	 */
	private String id;
	/***
	 * ҳ���Ͻڵ�ı�ʾ�ı�
	 */
	private String text;
	/**
	 * �ڵ��ͼ��·��
	 */
	private String icon ;
	/**
	 * �ڵ��CSS��ʽ
	 */
	private String iconCls;
	/**
	 * ����ڵ���������ӵ�ַ
	 */
	private String href;
	/**
	 * ���ӵ�ַĿ���frame
	 */
	private String hrefTarget;

	/**
	 * �������ӽڵ�
	 */
	private List<TreeNode> children = new ArrayList<TreeNode>();

	/**
	 * �ڵ�ĸ��ڵ�
	 */
	private TreeNode parentTreeNode;

	/**
	 * ��Žڵ��Զ������ ���磺tpath �ڵ������е�·������ʾ���磺0.1.2,�˲����������û����ã��ɳ����Զ����� 0��ʾ���ڵ㣬1
	 * ��ʾ���ڵ�����ĵڶ����ڵ㣬2��ʾ�ڶ����ڵ������ ��3���ڵ�, ��������Ѹ�ٶ�λ�ڵ�Ĳ�ι�ϵ
	 */
	private Map<String, String> params = new HashMap<String,String>();
	/**
	 * ��Žڵ�������Զ�������
	 */
	private Map<String, String> data = new HashMap<String,String>();

	/**
	 * ��Žڵ��������Ĳ���
	 */
	private Map<String, String> treeParams = new HashMap<String,String>();
	
	/**
	 * �˵���ʾ��Ϣ
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
