package com.bgp.mcs.service.pm.bpm.workFlow.srv;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.sais.bpm.pojo.WfDNode;


/**
 * 作者：邱庆豹
 * 
 * 时间：2012-6-7
 * 
 * 说明: 流程标签类，用于自动生成流程展示信息
 * 
 */


@SuppressWarnings({ "rawtypes", "serial" })
public class ProcessGetInfoTag extends TagSupport {


	/*
	 * 处理标签，通过pageContext生成相关DTO以及userToken,接受流程引擎切入信息,
	 * 
	 */
	public int doStartTag() throws JspException {
		ISrvMsg resultMsg = (ISrvMsg) (pageContext.getRequest().getAttribute("responseDTO"));
		
		try {
			UserToken user = (UserToken)pageContext.getSession().getAttribute("SYS_USER_TOKEN_ID");
			userId = user.getUserId();
			procinstID = resultMsg.getValue("procinstId");
		/*	if(procinstID == null){
				procinstID =  pageContext.getRequest().getParameter("procinstID");
			} */
			examineinstID = resultMsg.getValue("examineinstId");
		/*	if(examineinstID == null){
				examineinstID =  pageContext.getRequest().getParameter("examineinstID");
			} */
			businessType = resultMsg.getValue("businessType");
/*			if(businessType == null || businessType.equals("null")){
				businessType =  pageContext.getRequest().getParameter("businessType");
			} */
			businessId = resultMsg.getValue("businessId");
			/*if(businessId == null){
				businessId =   pageContext.getRequest().getParameter("procinstID");
			} */
			String isFirst=resultMsg.getValue("isFirstApplyNode");
			WFCommonBean wfBean = new WFCommonBean();
			
			// 获取审批信息
			Map map = wfBean.getWFProcessInfo(user, businessType, procinstID, examineinstID);
			String backNodeId=wfBean.getBackNode((String) map.get("nodeId"));
			if(backNodeId==null){
				backNodeId=(String) map.get("startNode");
			}
			// 获取审批历史信息examineinInfo
			examineHistoryList = wfBean.getProcHistory(procinstID);
			nodeList = (List) map.get("nodeList");
			List examineinInfoList=(List) map.get("examineinInfo");
			Map examineinInfoMap=new HashMap();
			if(examineinInfoList!=null&&examineinInfoList.size()>0){
				examineinInfoMap=(Map) examineinInfoList.get(0);
			}
			StringBuffer sb = new StringBuffer();
			sb.append("<table id=\"examine\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"form_info\">");
			sb.append("<tr>");
			sb.append("<td class=\"rtCDTFdName\" colspan=\"1\">&nbsp;审批意见：</td>");
			sb.append("<td class=\"rtCDTFdValue\" colspan=\"3\"><textarea name=\"examineInfo\" rows=\"2\" cols=\"68\" class=\"textarea\"></textarea></td>");
			sb.append("</tr>");
			sb.append("<tr>");
			sb.append("<td class=\"rtCDTFdName\" colspan=\"1\">&nbsp;下一步：</td>");
			sb.append("<td align=\"left\" colspan=\"1\" class=\"rtCDTFdValue\">");
			sb.append("<input type=\"hidden\" id=\"isPass\" name=\"isPass\" value=\"\">");
			sb.append("<input type=\"hidden\" id=\"moveNodeId\" name=\"moveNodeId\" value=\""+backNodeId+"\">");
			sb.append("<input type=\"hidden\" id=\"isFirst\" name=\"isFirst\" value=\""+isFirst+"\">");
			sb.append("<input type=\"hidden\" id=\"procinstID\" name=\"procinstID\" value=\"" + examineinInfoMap.get("procinstId") + "\">");
			sb.append("<input type=\"hidden\" id=\"examineinstID\" name=\"examineinstID\" value=\"" + examineinInfoMap.get("examineinstId") + "\">");
			sb.append("<input type=\"hidden\" id=\"businessId\" name=\"businessId\" value=\"" + businessId + "\">");
			sb.append("<input type=\"hidden\" id=\"taskinstId\" name=\"taskinstId\" value=\"" + examineinInfoMap.get("taskinstId") + "\">");
			sb.append("<select  name=\"nextNodeID\" class=\"select_width\">");
			if (nodeList != null) {
				for (int j = 0; j < nodeList.size(); j++) {
					WfDNode wfDNode=(WfDNode) nodeList.get(j);
					sb.append("<option value=\"" + wfDNode.getEntityId() + "\">" + wfDNode.getNodeName() + "</option>");
					if(wfDNode.getNodeName().trim().equals("结束"))
					{
					sb.append("<input type=\"hidden\" id=\"nextNodeType\" value=\"END_NODE\">");
					}
				}
			} else {
				sb.append("<option value=\"999\">无下级节点</option>");
			}
			sb.append("</select>");
			sb.append("</td>");
			sb.append("<td class=\"rtCDTFdName\" colspan=\"1\">&nbsp;</td>");
			sb.append("<td align=\"left\" colspan=\"1\" class=\"rtCDTFdValue\">&nbsp;</td>");
			sb.append("</tr>");
			sb.append("</table>");

			sb.append("<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"tab_info\">");
			sb.append("<tr  class=\"bt_info\">");
			sb.append("<td class=\"bt_info_odd\">业务环节</td>");
			sb.append("<td class=\"bt_info_even\">审批情况</td>");
			sb.append("<td class=\"bt_info_odd\">审批意见</td>");
			sb.append("<td class=\"bt_info_even\">审批人</td>");
			sb.append("<td class=\"bt_info_odd\">审批时间</td>");
			sb.append("</tr>");
			for (int i = 0; examineHistoryList != null && i < examineHistoryList.size(); i++) {
				Map mapExa = (Map) examineHistoryList.get(i);
				String className1 = "";
				if (i % 2 == 0) {
					className1 = "even";
				} else {
					className1 = "odd";
				}
				sb.append("<tr  class=\"" + className1 + "\">");
				sb.append("<td >" + (mapExa.get("node_name") == null ? " " : mapExa.get("node_name").toString()) + "&nbsp;</td>");
				sb.append("<td >" + (mapExa.get("curstate") == null ? " " : mapExa.get("curstate").toString()) + "&nbsp;</td>");
				sb.append("<td >" + (mapExa.get("examine_info") == null ? " " : mapExa.get("examine_info").toString()) + "&nbsp;</td>");
				sb.append("<td >" + (mapExa.get("examine_user_name") == null ? " " : mapExa.get("examine_user_name").toString()) + "&nbsp;</td>");
				sb.append("<td >" + (mapExa.get("examine_end_date") == null ? " " : mapExa.get("examine_end_date").toString()) + "&nbsp;</td>");
				sb.append("</tr>");
			}
			sb.append("</table>");
			
			pageContext.getOut().println(sb.toString());

		} catch (Exception e) {
			e.printStackTrace();
		}

		return 0;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getProcinstID() {
		return procinstID;
	}

	public void setProcinstID(String procinstID) {
		this.procinstID = procinstID;
	}

	public String getExamineinstID() {
		return examineinstID;
	}

	public void setExamineinstID(String examineinstID) {
		this.examineinstID = examineinstID;
	}

	public String getBusinessType() {
		return businessType;
	}

	public void setBusinessType(String businessType) {
		this.businessType = businessType;
	}

	public String getBusinessId() {
		return businessId;
	}

	public void setBusinessId(String businessId) {
		this.businessId = businessId;
	}

	public String getTaskinstId() {
		return taskinstId;
	}

	public void setTaskinstId(String taskinstId) {
		this.taskinstId = taskinstId;
	}
	
	private String userId;
	private String procinstID;
	private String examineinstID;
	private String businessType;

	private String businessId;
	private String taskinstId;

	private List nodeList;
	private List examineHistoryList;

}
