<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	String contextPath = request.getContextPath(); 
	Date now = new Date();	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
		//(user==null)?"":user.getEmpId();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
	String father_id = request.getParameter("father_id");
	String sub_id = request.getParameter("sub_id");
	String org_subjection_id = request.getParameter("org_subjection_id");
	String org_type = request.getParameter("org_type");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>图像信息：</title>
</head>
 
<body class="bgColor_f3f3f3"   onload="page_init();" >       
<div id="list_table" >
	<div id="inq_tool_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png">
		    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
				    <td>&nbsp;</td>
					<input type="hidden" id="typeShow" name="typeShow"  value="0" class="input_width" />
				  <div id="divShow" style="dispaly:none" >  <auth:ListButton functionId="" id="zj" css="zj" event="onclick='toOption()'" title="维护添加"></auth:ListButton></div>
				    <auth:ListButton functionId="" id="bc" css="bc" event="onclick='toAdd()'" title="保存"></auth:ListButton>
				    
				  </tr>
				</table>
			</td>
		    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
		</table>
   </div>
	   <div id="table_box" >
	   <table width="100%" height="700px" border="1" cellpadding="0" cellspacing="0" class="tab_info" id="queryRetTable">
	   <tr class="bt_info">
	       <td colspan="5" >
	        <div id="idContainer" style="background-image:url(Images/1.gif);background-repeat:no-repeat;" >
					   <img src="http://www.dreamdu.com/images/html_table.png" id="human_image"    usemap="#Map" />
						   <div id="idDrag">   </div>  
						   <div id="idDrags">  </div>
							<map name="Map" id="Map">
							<area shape="rect" href="page.html" coords="140,20,280,60">
							   <area shape="poly" href="image.html" coords="100,100,180,80,200,140">
							   <area shape="circle" href="new.html" coords="80,100,60">

					        </map>
					  </div> 
				  	</td>
			  	</tr>
			  
			  </table>
		  </div>

 </div> 
</body>

<script type="text/javascript"> 
 
	cruConfig.contextPath =  "<%=contextPath%>";	 
	cruConfig.cdtType = 'form';	 
	var  org_id="<%=father_id%>";
	var  org_subjection_id="<%=org_subjection_id%>";
	var  org_type="<%=org_type%>";
	function page_init(){		
		if(org_type=='2'){
			
		}else if(org_type=='1'){
			document.getElementById("divShow").style.display="block";	
			
			var querySql = " select t.pmain_id, t.ucm_id, t.creator_id, e.employee_name from BGP_HSE_PICTURE_MAIN t left join comm_human_employee e on t.creator_id = e.employee_id  and e.bsflag = '0'   where  t.bsflag='0'  ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			var datas = queryRet.datas;		
			if(queryRet.returnCode=='0'){
				if(datas != null && datas != ''  ){	
				    //	<img src="http://www.dreamdu.com/images/html_table.png" id="human_image"    />
					//document.getElementById("idContainer").style.backgroundImage = "url(<%=contextPath%>/doc/downloadDocByUcmId.srq?emflag=0&docId="+datas[0].ucm_id+")";
				    //	document.getElementById("human_image").src = "http://10.88.2.241/hr_photo/"+employee_cd.substr(0,5)+"/"+employee_cd+".JPG";
		           document.getElementById("human_image").src = "<%=contextPath%>/doc/downloadDocByUcmId.srq?emflag=0&docId="+datas[0].ucm_id;
		
				}else{
					document.getElementById("human_image").src = "<%=contextPath%>/hse/hseOptionPage/hsePicture/worryP.jpg";
					alert("请先上传机关图片!");
				}
			}
		 
		 }else if(org_type=='0'){
			 
				var querySql = " select t.pmain_id, t.ucm_id, t.creator_id, e.employee_name from BGP_HSE_PICTURE_MAIN t left join comm_human_employee e on t.creator_id = e.employee_id  and e.bsflag = '0'   where  t.bsflag='0' and  t.org_id like '%"+org_id+"%' and t.org_subjection_id like '%"+org_subjection_id+"%' ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
				var datas = queryRet.datas;		
				if(queryRet.returnCode=='0'){
					if(datas != null && datas != ''  ){	
					    document.getElementById("human_image").src = "<%=contextPath%>/doc/downloadDocByUcmId.srq?emflag=0&docId="+datas[0].ucm_id;
			
					}else{
						  document.getElementById("typeShow").value="1";
						document.getElementById("human_image").src = "<%=contextPath%>/hse/hseOptionPage/hsePicture/worryP.jpg";
						
					}
				}
			 
			 }
	}
	
	
	function toOption(){
		 var typeShow=document.getElementById("typeShow").value;
		 if(typeShow=='1'){
			 alert("上级机关未上传图片,编辑失败!");
		 }else {
		 
		 }
	}
	
 // $("#table_box").css("height",$(window).height()-20);
	//   $("#idContainer").css("height",$(window).height()-$("#inq_tool_box").height()-80);
	  
</script>
 
 

</html>

