package com.bgp.mcs.web.common.tag;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.BodyTagSupport;

/**
 * EXT风格标签选项卡容器标签-公共标签
 * @author 
 * @version eRedUI V0.1
 */

@SuppressWarnings("unchecked")
public class ExtTabsTag extends BodyTagSupport{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String tabsId;
	private String activeTab;
	private String width;
	private String height;
	private String autoScroll;
	private String toolbar;
	@SuppressWarnings("rawtypes")
	private List tabs;

	@SuppressWarnings("rawtypes")
	public ExtTabsTag(){
		super();
		tabs = new ArrayList();
	}
	
	/**
	 * 标签开始:Do Nothing!
	 */
	@SuppressWarnings("static-access")
	public int doStartTag() throws JspException{
		tabs.clear();
		HttpServletRequest request = (HttpServletRequest)this.pageContext.getRequest();
		String tabNo = (String)request.getAttribute("active");
		this.activeTab = (tabNo == null || tabNo == "") ? "0" : tabNo;
		return super.EVAL_BODY_BUFFERED;
	}
	
	/**
	 * 标签结束：输出代码描述字符流
	 */
	public int doEndTag() throws JspException{
		JspWriter writer = pageContext.getOut();
        try {
        	String tabsDivStart = "<div id=\"tabs\">";
			writer.println(tabsDivStart);
			for(int i = 0; i < tabs.size(); i++){
				ExtTab tab = (ExtTab)tabs.get(i);
				String tabDivStart = "<div id=\"" + tab.getTabId() + "\" class=\"x-hide-display\">";
				writer.println(tabDivStart);
				String tabDivContent = tab.getContent();
				writer.println(tabDivContent);
				String tabDivEnd = "</div>";
				writer.println(tabDivEnd);
			}
        	String tabsDivEnd = "</div>";
			writer.println(tabsDivEnd);
			String scriptStart = "<script type=\"text/javascript\">";
			writer.println(scriptStart);
			String tabsScriptStart = "Ext.onReady(function(){var " + this.getTabsId() + " = new Ext.TabPanel({";
			tabsScriptStart = tabsScriptStart + "renderTo: '" + this.getTabsId() + "',";
			tabsScriptStart = tabsScriptStart + "width:" + (this.width == null ? "780" : this.width) + ",";
			tabsScriptStart = tabsScriptStart + "activeTab:" + (this.activeTab == null ? "0" : this.activeTab) + ",";
			tabsScriptStart = tabsScriptStart + "frame:true,";
			tabsScriptStart = tabsScriptStart + "buttonAlign:'right',";
			tabsScriptStart = tabsScriptStart + "autoScroll:true,";
			if(this.toolbar==null){
			tabsScriptStart = tabsScriptStart + "tbar:new Ext.Toolbar({items:[{xtype:'button',text:'确定',handler:function nodeCheck(){confirmchoose();}}]}),";
			}
			if(this.height != null)
				tabsScriptStart = tabsScriptStart + "height:" + this.height + ",";
			if(this.autoScroll != null)
				tabsScriptStart = tabsScriptStart + "autoScroll:" + this.autoScroll + ",";
			tabsScriptStart = tabsScriptStart + "defaults:{autoHeight: true},";
			tabsScriptStart = tabsScriptStart + "items:[";
			writer.println(tabsScriptStart);
			String tabScriptStart = "";
			for(int i = 0; i < tabs.size(); i++){
				ExtTab tab = (ExtTab)tabs.get(i);
			    tabScriptStart = tabScriptStart + "{contentEl:'" + tab.getTabId() + "',";
			    if(tab.getDisabled() != null)
			    	tabScriptStart = tabScriptStart + "disabled:" + tab.getDisabled() + ",";
			    if(tab.getOnclick() != null)
			    	tabScriptStart = tabScriptStart + "listeners: {activate:" + tab.getOnclick() + "},";
			    tabScriptStart = tabScriptStart + "title: '" + tab.getTitle();
			    tabScriptStart = tabScriptStart + "'},";
			}
			String tabScriptStart2 = tabScriptStart.substring(0, tabScriptStart.length() - 1);
			writer.println(tabScriptStart2);
			String tabScriptEnd = "]";
			writer.println(tabScriptEnd);
			String tabsScriptEnd = "});});";
			writer.println(tabsScriptEnd);
			String scriptEnd = "</script>";
			writer.println(scriptEnd);
		} catch (IOException e) {
			e.printStackTrace();
		}
        return super.doEndTag();
	}
	
	/**
	 * 添加Tab卡片
	 */
	public void addTab(ExtTabTag pTab){
		tabs.add(pTab);
	}
	
	/**
	 * 添加Tab卡片
	 */
	public void addTab(ExtTab pTab){
		tabs.add(pTab);
	}
	
	/**
	 * 释放资源
	 */
	public void release(){
		super.release();
		this.activeTab = null;
		this.tabsId = null;
		this.width = null;
		this.height = null;
	}
	
	public String getTabsId() {
		return tabsId;
	}
	public void setTabsId(String tabsId) {
		this.tabsId = tabsId;
	}
	public String getActiveTab() {
		return activeTab;
	}
	public void setActiveTab(String activeTab) {
		this.activeTab = activeTab;
	}
	public String getWidth() {
		return width;
	}
	public void setWidth(String width) {
		this.width = width;
	}

	public void setHeight(String height) {
		this.height = height;
	}

	public void setAutoScroll(String autoScroll) {
		this.autoScroll = autoScroll;
	}

	public String getToolbar() {
		return toolbar;
	}

	public void setToolbar(String toolbar) {
		this.toolbar = toolbar;
	}
	
}

