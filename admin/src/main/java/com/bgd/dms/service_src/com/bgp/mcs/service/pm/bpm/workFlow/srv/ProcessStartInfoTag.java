package com.bgp.mcs.service.pm.bpm.workFlow.srv;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;

/**
 * 作者：邱庆豹
 * 
 * 时间：2012-7-11
 * 
 * 说明: 流程标签类，用于自动生成流程标签
 * 
 */

public class ProcessStartInfoTag extends TagSupport {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8637518377071988963L;

	
	public int doStartTag() throws JspException {
		
		HttpServletRequest request = (HttpServletRequest)this.pageContext.getRequest();
		String contextPath=request.getContextPath();
		StringBuffer sb = new StringBuffer();
		sb.append("<div id=\"inq_tool_box\">");
		sb.append("			<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">");
		sb.append("			<tr>");
		sb.append("				<td width=\"6\"><img src=\""+contextPath+"/images/list_13.png\"width=\"6\" height=\"36\" /></td>");
		sb.append("				<td background=\""+contextPath+"/images/list_15.png\">");
		sb.append("					<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">");
		sb.append("						<tr align=\"right\">");
		sb.append("							<td>&nbsp;</td>");
//		sb.append("		<td class='ali_btn'><span class='ck'><a href='#' onclick='viewProcDoc()'  title='查看流程说明文档'></a></span></td>");

		if(buttonFunctionId==null || buttonFunctionId.equals("") || JcdpMVCUtil.hasPermission(buttonFunctionId, request)){
			sb.append("		<td class='ali_btn'><span class='tj'><a href='#' onclick='submitProcessInfo()'  title='JCDP_btn_submit'></a></span></td>");
		}
		sb.append("		<td class='ali_btn'><span class='ck'><a href='#' onclick='viewProcessInfo()'  title='JCDP_btn_view'></a></span></td>");
		sb.append("						</tr>");
		sb.append("					</table></td>");
		sb.append("				<td width=\"4\"><img src=\""+contextPath+"/images/list_17.png\" width=\"4\" height=\"36\" /></td>");
		sb.append("			</tr>");
		sb.append("		</table>");
		sb.append("	</div>");
		sb.append("	<table id=\"processInfoTab\" width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" class=\"tab_info\" style=\"margin-top:2px;\" >");
		sb.append("		<tr class=\"bt_info\">");
		sb.append("		    <td>业务环节</td>");
		sb.append("			<td>审批情况</td>");
		sb.append("			<td>审批意见</td>");
		sb.append("			<td>审批人</td>");
		sb.append("			<td>审批时间</td>");
		sb.append("		</tr>  ");          
		sb.append("	</table>");
		
		try {
			pageContext.getOut().println(sb.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	private String businessType;
	private String businessTableName;
	private String buttonFunctionId;
	private String title;
	public String getBusinessType() {
		return businessType;
	}
	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}
	public String getBusinessTableName() {
		return businessTableName;
	}
	public void setBusinessTableName(String businessTableName) {
		this.businessTableName = businessTableName;
	}
	public String getButtonFunctionId() {
		return buttonFunctionId;
	}
	public void setButtonFunctionId(String buttonFunctionId) {
		this.buttonFunctionId = buttonFunctionId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	
	
}
