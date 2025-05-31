<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String suborgid = user.getSubOrgIDofAffordOrg();
	int orgidlength = suborgid.length(); 
	String scrape_type=new String(request.getParameter("scrape_type").getBytes("ISO-8859-1"),"GB2312");
	String org_name=new String(request.getParameter("org_name").getBytes("ISO-8859-1"),"GB2312");
	String dev_name=new String(request.getParameter("dev_name").getBytes("ISO-8859-1"),"GB2312");
	String dev_type=request.getParameter("dev_type");
	String scrape_apply_id1=request.getParameter("scrape_apply_id1");
	String times=new String(request.getParameter("times").getBytes("ISO-8859-1"),"GB2312");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

 <title>设备台账详情</title> 
 <style type="text/css">
#new_table_box_content {
width:auto;
height:400px;
border:1px #999 solid;
background:#cdddef;
padding:15px;
}
#new_table_box_bg {
width:auto;
height:350px;
border:1px #aebccb solid;
background:#f1f2f3;
padding:10px;
overflow:auto;
}
</style>
 </head> 


 <body style="background:#F1F2F3;overflow:auto" onload="refreshData()">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info">		
			    <tr>
					<td class="bt_info_even">序号</td>
					<td class="bt_info_odd" >附件名称</td>
			     </tr> 
			  </table>
			  <div style="height:400px;overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtablefj" name="processtablefj" >
			   		</tbody>
		      	</table>
			</div>
		 </div>
	</div>
	<div id="oper_div">
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
    </div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})
 function refreshData(){
	var org_name=decodeURI('<%=org_name%>');
	var dev_name=decodeURI('<%=dev_name%>');
	 
	var dev_type='<%=dev_type%>';
	var scrape_apply_id1='<%=scrape_apply_id1%>';
	var scrape_type='<%=scrape_type%>';
	var times=decodeURI('<%=times%>');
	baseData = jcdpCallService("ScrapeSrvNew", "getScrapeFileListCollect", "org_name="+org_name+"&dev_name="+dev_name+"&dev_type="+dev_type+"&times="+times+"&scrape_type="+scrape_type+"&scrape_apply_id1="+scrape_apply_id1);
	if(baseData.fdatafj!=null)
	{
		$("#processtablefj").empty();
		for (var tr_id = 1; tr_id<=baseData.fdatafj.length; tr_id++) {
			insertFilefj(baseData.fdatafj[tr_id-1].file_name,baseData.fdatafj[tr_id-1].file_type,baseData.fdatafj[tr_id-1].file_id,tr_id);
		}
	}
 }
//插入文件
function insertFilefj(name,type,id,tr_id){
	var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
	innerhtml +="<td class='bt_info_even'>"+tr_id+"</td>";
	innerhtml +="<td class='bt_info_odd'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"' class='my_input_width'>"+name+"</a></td>";
	innerhtml +="<input type='hidden' readonly='readonly' name='doc_name__"+id+"' id='doc_name__"+id+"' value="+name+"/>";
	innerhtml +="</tr>";
	$("#processtablefj").append(innerhtml);
	
	$("#processtablefj>tr:odd>td:odd").addClass("odd_odd");
	$("#processtablefj>tr:odd>td:even").addClass("odd_even");
	$("#processtablefj>tr:even>td:odd").addClass("even_odd");
	$("#processtablefj>tr:even>td:even").addClass("even_even");
}
	function newClose(){
		window.close();
	}
</script>
</html>