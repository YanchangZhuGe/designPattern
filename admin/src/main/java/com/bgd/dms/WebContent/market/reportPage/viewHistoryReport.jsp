<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
    Map map=resultMsg.getMsgElement("reportMap").toMap();
    Map orgMap=resultMsg.getMsgElement("orgMap").toMap();
    List<MsgElement> fileList = resultMsg.getMsgElements("fileList");
    String orgId = request.getParameter("orgId");
    String button = resultMsg.getValue("button");
 
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>查看页面</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/styles/forum.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<link href="/BGPMCS/BGP_TS_Forum/include/oc_upload.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/BGPMCS/BGP_TS_Forum/js/oc_common.js"></script>
<script type="text/javascript" src="/BGPMCS/BGP_TS_Forum/js/oc_upload.js"></script>
</head>

<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" >
<table border="0" cellpadding="0" cellspacing="0" width="95%" height="800" class="form_info">
	 <input name="infomation_id" type="hidden" value=""/>
	<tr class="odd">
	  	<td class="inquire_item">&nbsp;名称：</td>
	    <td class="inquire_form" >
	    	<%=(String)map.get("title") %>    
	    </td>
	    <td class="inquire_item">&nbsp;类型：</td>
    	<td class="inquire_form">
    		<%=(String)map.get("type") %>
     	</td>
	</tr>
  	<tr class="odd">
  		<td class="inquire_item">&nbsp;年度：</td>
    	<td class="inquire_form">
    		<%=(String)map.get("recordYear") %>
     </td>
    	<td class="inquire_item">&nbsp;月份：</td>
    	<td class="inquire_form">
    		<%=(String)map.get("month") %>
      </td>
    </tr>    
    <tr class="odd">
	  	<td class="inquire_item">&nbsp;备注：</td>
	    <td class="inquire_form"  colspan="3">
	    	<%=(String)map.get("memo") %>    
	    </td>
	</tr>
	   <tr class="odd">
        <td class="inquire_item">相关附件：</td>
        <td  colspan="3"  class="inquire_form" height="28px;">
          <%
         		if(fileList!=null && fileList.size()>0){
         			for(int j=0;j<fileList.size();j++){
         				Map fileMap=fileList.get(j).toMap();
         	%>
         	<li><a href="<%=contextPath%>/market/DownloadFileAction.srq?pkValue=<%=(String)fileMap.get("attachId")%>"><%=(String)fileMap.get("attachName")%></a></li>
         	<%
         			}
         		}
         	%>
        </td>
      </tr>
       <% 
       if(button!=null&&button.equals("return")){ 
       %>
       <tr class="odd">
    	<td colspan="4" class="ali4">
   
    	<input name="Submit" type="button" class="iButton2"  onClick="cancel();" value="返回" />
    	
    </td>
  </tr> 
  <%}%>
</table>
</form>
</body>
<script type="text/javascript">
	function cancel()
	{
		window.location="<%=contextPath%>/market/startReport.srq?orgId=<%=orgId%>";
	}

</script>
</html>
