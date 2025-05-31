<%@ page language="java" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.webapp.util.ActionUtils"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	List<MsgElement> listAuditInfo=resultMsg.getMsgElements("wfList");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<link href="<%=contextPath%>/dialog/jquery_dialog.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cute/rt_list_new.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/dialog/jquery_dialog.js"></script>

<title>仪表盘</title>
 <script type="text/javascript">
 	  cruConfig.contextPath = "<%=contextPath%>";
 </script>
</head>
<body style="background:#fff;">
<div id="list_content" style="margin-top:0px;">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
 			 <tr>
    			<td><div class="tongyong_box">
          <div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">生产</a><span class="gd"><a href="#"></a></span></div>
          <div class="tongyong_box_content_left" id="tongyong_box_content_left_form" style="height:142px;">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info">
              <tr>
                <td class="bt_info_odd">&nbsp;</td>
                <td class="bt_info_even">内容1</td>
                <td class="bt_info_odd">内容2</td>
                <td class="bt_info_even">内容3</td>
                <td class="bt_info_odd">内容4</td>
                <td class="bt_info_even">内容5</td>
              </tr>
              <tr>
                <td class="odd_odd"><input type="checkbox" name="checkbox" id="checkbox" /></td>
                <td class="odd_even">内容内容</td>
                <td class="odd_odd">内容内容</td>
                <td class="odd_even">&nbsp;</td>
                <td class="odd_odd">&nbsp;</td>
                <td class="odd_even">&nbsp;</td>
              </tr>
              <tr>
                <td class="even_odd"><input type="checkbox" name="checkbox2" id="checkbox2" /></td>
                <td class="even_even">内容内容</td>
                <td class="even_odd">内容内容</td>
                <td class="even_even">&nbsp;</td>
                <td class="even_odd">&nbsp;</td>
                <td class="even_even">&nbsp;</td>
              </tr>
              <tr>
                <td class="odd_odd"><input type="checkbox" name="checkbox3" id="checkbox3" /></td>
                <td class="odd_even">内容内容</td>
                <td class="odd_odd">内容内容</td>
                <td class="odd_even">&nbsp;</td>
                <td class="odd_odd">&nbsp;</td>
                <td class="odd_even">&nbsp;</td>
              </tr>
            </table>
          </div>
        </div></td>
  </tr>
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td ><div class="tongyong_box">
          <div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">生产</a><span class="gd"><a href="#"></a></span></div>
          <div class="tongyong_box_content_left"  style="height:100px;">
           
          </div>
        </div></td>
    <td width="11"></td>
    <td width="26%"><div class="tongyong_box">
          <div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">生产</a><span class="gd"><a href="#"></a></span></div>
          <div class="tongyong_box_content_left"  style="height:100px;">
           
          </div>
        </div></td>
    <td width="11"></td>
    <td width="26%"><div class="tongyong_box">
          <div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">生产</a><span class="gd"><a href="#"></a></span></div>
          <div class="tongyong_box_content_left"  style="height:100px;">
           
          </div>
        </div></td>
  </tr>
</table>
</td>
  </tr>
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><div class="tongyong_box">
          <div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">生产</a><span class="gd"><a href="#"></a></span></div>
          <div class="tongyong_box_content_left"  style="height:100px;">
           
          </div>
        </div></td>
    <td width="11"></td>
    <td width="26%"><div class="tongyong_box">
          <div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">生产</a><span class="gd"><a href="#"></a></span></div>
          <div class="tongyong_box_content_left"  style="height:100px;">
           
          </div>
        </div></td>
    <td width="11"></td>
    <td width="26%"><div class="tongyong_box">
          <div class="tongyong_box_title"><span class="kb"><a href="#"></a></span><a href="#">生产</a><span class="gd"><a href="#"></a></span></div>
          <div class="tongyong_box_content_left"  style="height:100px;">
           
          </div>
        </div></td>
  </tr>
</table></td>
  </tr>
</table>
</td>
      <td width="11"></td>
      <td valign="top" width="220"><div class="tongyong_box">
          <div class="tongyong_box_title"><a href="#">搜索</a></div>
          <div class="tongyong_box_content">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
              <tr>
                <td>请选择：
                  <input name="" type="radio" value=""  style="padding-left:15px;"/>
                  项目
                  <input name="" type="radio" value="" style="padding-left:15px;"/>
                  工区 </td>
              </tr>
              <tr>
                <td><input name="input" type="text"  size="28"/></td>
              </tr>
              <tr>
                <td><span class="qd"><a href="#"></a></span> <span class="cz"><a href="#"></a></span></td>
              </tr>
            </table>
          </div>
        </div>
        <div class="tongyong_box" style="height: 250px">
           <div class="tongyong_box_title"><a href="#">待办事宜</a></div>
          <div class="tongyong_box_content">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" >
              <tr>
                <td >
                	<% if(listAuditInfo!=null&&listAuditInfo.size()>0) {
	                		for(int i=0;i<listAuditInfo.size();i++){
	                		Map  map=((MsgElement)listAuditInfo.get(i)).toMap();
                	%>
            					<p class="daib"><a href=javascript:viewLink('<%=map.get("businessId")%>','<%=map.get("entityId")%>','<%=map.get("procinstId")%>','<%=map.get("taskinstId")%>','<%=map.get("businessType")%>','<%=map.get("nodeLink")%>','<%=map.get("nodeLinkType")%>') > <%=map.get("businessInfo")%> </a></p>
            		<%	
            				}
                		}
                	%>
              </tr>
              <tr>
            </table>
          </div>
        </div>
        <div class="tongyong_box" >
          <div class="tongyong_box_title"><a href="#">探区天气</a></div>
          <div class="tongyong_box_content" style="height:90px;">
            <table  border="0" cellspacing="0" cellpadding="0" class="tab_info" >
              <tr class="bt_info">
                <td>探区</td>
                <td>天气</td>
                <td>温度</td>
              </tr>
              <tr>
                <td>哈德逊</td>
                <td><img src="<%=contextPath%>/images/d01.gif" width="21" height="15" /></td>
                <td>-2°C</td>
              </tr>
              <tr>
                <td>哈拉哈塘</td>
                <td><img src="<%=contextPath%>/images/n22.gif" width="21" height="15" /></td>
                <td>-2°C</td>
              </tr>
              <tr>
                <td>塔中</td>
                <td><img src="<%=contextPath%>/images/d01.gif" width="21" height="15" /></td>
                <td>-2°C</td>
              </tr>
              <tr>
                <td>轮古</td>
                <td><img src="<%=contextPath%>/images/d03.gif" width="21" height="15" /></td>
                <td>12°C</td>
              </tr>
            </table>
          </div>
        </div></td>
      <td width="11"></td>
    </tr>
  </table>
</div>
</body>
<script type="text/javascript">

function frameSize(){
	
	var width = $(window).width()-256;	
	$("#tongyong_box_content_left_form").css("width",width);
	
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
});	


function  viewLink(businessId,entityId,procinstId,taskinstId,businessType,nodeLink,nodeLinkType){
	if(nodeLinkType!='1'){
		var editUrl = "/bpm/common/toGetProcessInfo.srq?taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId;
		//window.showModalDialog('<%=contextPath%>'+editUrl,"dialogHeight: 768px; dialogWidth: 1024px");
		//popWindow('<%=contextPath%>'+editUrl,'1024:768');
		dialogOpen('','1024','768','<%=contextPath%>'+editUrl);
	}else{
		nodeLink=nodeLink+"&taskinstId="+taskinstId+"&businessId="+businessId+"&examineinstID="+entityId+"&procinstID="+procinstId;
		//popWindow('<%=contextPath%>'+nodeLink,'1024:768');
		//window.showModalDialog('<%=contextPath%>'+nodeLink,"dialogHeight: 768px; dialogWidth: 1024px");
		dialogOpen('','1024','768','<%=contextPath%>'+nodeLink);
	}
}
</script>
</html>
