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
    Map map=resultMsg.getMsgElement("marketMap").toMap();
    Map mapType=resultMsg.getMsgElement("mapType").toMap();
    Map mapType2=resultMsg.getMsgElement("mapType2").toMap();
    String content=resultMsg.getValue("content");
    List<MsgElement> fileList = resultMsg.getMsgElements("fileList");
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    String dailyNo = request.getParameter("id");
    
    String action = request.getParameter("action");

%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>物探公司动态</title>
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
	  	<td class="inquire_item">&nbsp;标题：</td>
	    <td class="inquire_form" >
	    	<%=(String)map.get("infomationName") %>
	    </td>
  		<td class="inquire_item">&nbsp;发布日期：</td>
    	<td class="inquire_form">
    		<%=(String)map.get("releaseDate") %>
     </td>
     <tr class="odd">
    	<td class="inquire_item">&nbsp;公司名称：</td>
    	<td class="inquire_form">
    		<%=(String)mapType.get("codeName") %>
      </td>
      <td class="inquire_item">&nbsp;类别：</td>
    	<td class="inquire_form">
    		<%=(String)mapType2.get("codeName") %>
      </td>
    </tr>    
    <tr class="odd">
	  	<td class="inquire_item">&nbsp;摘要：</td>
	    <td class="inquire_form"  colspan="3">
	    	<%=(String)map.get("abstract") %>
	    </td>
	</tr>
    
    <tr class="odd" height="300">
	  	<td class="inquire_item">&nbsp;内容：</td>
	    <td colspan="3"  class="inquire_form" style="text-align: left;">

         	<%=content %>

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
         	<li><a href="<%=contextPath%>/icg/file/DownloadFileAction.srq?pkValue=<%=(String)fileMap.get("fileId")%>"><%=(String)fileMap.get("fileName")%></a></li>
         	<%
         			}
         		}
         	%>
        </td>
      </tr>
      
       <tr class="odd">
    <td colspan="4" class="ali4">
    	<input name="Submit" type="button" class="iButton2"  onClick="cancel();" value="返回" />
    </td>
  </tr> 
</table>
</form>
</body>

<script type="text/javascript">
function cancel()
{
	window.location="<%=contextPath%>/market/marketWtgsPage/MarketWtgsPageList.jsp";
}
</script>
</html>
