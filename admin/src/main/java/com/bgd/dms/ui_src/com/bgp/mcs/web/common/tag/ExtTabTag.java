package com.bgp.mcs.web.common.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;

/**
 * EXT����ǩѡ���ǩ-������ǩ
 * @author 
 * @version eRedUI V0.1
 */
public class ExtTabTag extends BodyTagSupport{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String tabId;
	private String title;
	private String disabled;
	private String onclick;
	public ExtTabTag(){}
	
	/**
	 * ��ǩ��ʼ:Do Nothing!
	 */
	@SuppressWarnings("static-access")
	public int doStartTag() throws JspException{
		return super.EVAL_BODY_BUFFERED;
	}
	
	/**
	 * ��ǩ������������������ַ���
	 */
	public int doEndTag() throws JspException{
		String content = this.bodyContent.getString();
		ExtTabsTag tabs = (ExtTabsTag)findAncestorWithClass(this, ExtTabsTag.class);
		ExtTab tab = new ExtTab();
		tab.setTabId(this.getTabId());
		tab.setTitle(this.getTitle());
		tab.setContent(content);
		tab.setDisabled(this.getDisabled());
		tab.setOnclick(this.getOnclick());
		tabs.addTab(tab);
		//tabs.addTab(this);
        return super.doEndTag();
	}
	
	/**
	 * �ͷ���Դ
	 */
	public void release(){
		super.release();
        this.tabId = null;
        this.title = null;
	}
	
	public String getTabId() {
		return tabId;
	}
	public void setTabId(String tabId) {
		this.tabId = tabId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}

	public void setDisabled(String disabled) {
		this.disabled = disabled;
	}

	public void setOnclick(String onclick) {
		this.onclick = onclick;
	}

	public String getDisabled() {
		return disabled;
	}

	public String getOnclick() {
		return onclick;
	}
}

