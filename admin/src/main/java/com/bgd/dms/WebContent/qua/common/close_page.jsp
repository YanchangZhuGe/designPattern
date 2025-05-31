<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String index = resultMsg.getValue("index");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script language="javaScript">
	refreshData();//没有树，但是页面有文档的iframe 或者 流程的iframe
	function refreshData(){
		var index = '<%=index%>';
		var ctt = top.frames['list']; 
		//alert(ctt.frames);
		debugger;
		if(ctt.frames.length == 0){
			
			ctt.refreshData();
			if(index!=null && index!='' && index!='null'){
				ctt.frames[index].refreshData();
			}
		}else{
			debugger;
			if(ctt.frames[0].name == 'mainTopframe'||ctt.frames[0].name == 'menuTopframe' ){
				ctt.frames[1].refreshData();
				if(index!=null && index!='' && index!='null'){
					ctt.frames[1].frames[index].refreshData();
				}
			}else{
				if(index!=null && index!='' && index!='null'){
					ctt.frames[index].refreshData();
				}
				ctt.refreshData();
			}
			
		}
	}
 newClose();
	
</script>
</head>
<body>
</body>
</html>
