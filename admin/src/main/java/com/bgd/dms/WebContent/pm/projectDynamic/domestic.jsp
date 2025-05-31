<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String contextPath = request.getContextPath();
	String mapPath = contextPath + "/pm/projectDynamic";
	String orgSubId = user.getOrgSubjectionId();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<title>国内项目</title>
<script type="text/javascript">
cruConfig.contextPath='<%=contextPath%>';
var orgSubId = "<%=orgSubId%>";
	document.onmousemove = getxy;   
	var x=0;
	var y=0;    
	function getxy(e)   {     
	    var x= event.offsetX ;
	    var y= event.offsetY ;
	    if (x < 0){x = 0}
	    if (y < 0){y = 0}
	    window.status=x+','+y ;
	    return true;
	} 

	var deptInfos = new Array(
			['长庆物探处','C6000000000045','C105005004','588','440'],
			['华北物探处','C0000000000232','C105005000','705','335'],
			['新兴物探开发处','C6000000000060','C105005001','696','323'],
			['海上勘探事业部','C6000000000008','C105007','728','331'],
			['塔里木经理部','C6000000000010','C105001005','218','251'],
			['北疆经理部','C6000000000011','C105001002','240','198'],
			['敦煌经理部','C6000000000012','C105001004','350','304'],
			['吐哈经理部','C6000000000013','C105001003','356','265'],
			['辽河物探分公司','C6000000001888','C105063','800','270'],
			['川东经理部','C3000000000344','C102030004','530','516'],
			['重庆经理部','C3000000000345','C102030005','534','539'],
			['川西经理部','C3000000000346','C102030006','487','516'],
			['山地分公司','C3000000000348','C102030008','503','516'],
			['大庆钻探物探一公司','C2000000000240','C101004','814','139'],
			['大庆钻探物探二公司','C2000000001672','C101019','808','185']
	);
	
	function onload()//初始化项目节点
	{
	     // 经理部
	     for(var i=0;i<deptInfos.length;i++){
		     if(deptInfos[i][2].indexOf('<%=orgSubId%>')>=0)
	     		document.getElementById("div1").appendChild(CreatDep(deptInfos[i][3],deptInfos[i][4],"dep.gif",deptInfos[i][0],deptInfos[i][1],deptInfos[i][2]));             
	     }
		 
    	// 正在启动、运行、暂停的项目
    	var retObj = jcdpCallService("ProjectDynamicSrv","queryDynamicProject","orgSubId="+orgSubId+"&country=1");
   		if(retObj.projectList != null){
    		var xs = new Array();
    		var ys = new Array();
    		// 加入经理部坐标，避免项目与经理部重复
    		xs[0]=588;ys[0]=440;
    		xs[1]=705;ys[1]=335;
    		xs[2]=696;ys[2]=323;
    		xs[3]=728;ys[3]=331;
    		xs[4]=218;ys[4]=251;
    		xs[5]=240;ys[5]=198;
    		xs[6]=350;ys[6]=304;
    		xs[7]=356;ys[7]=265;
    		xs[8]=800;ys[8]=270;
    		var xShift = [0,-10,0,10,0,-10,10,10,-10];
    		var yShift = [0,0,-10,0,10,-10,-10,10,10];
    		var handledLength = 9;
    		var shiftLength = xShift.length;
    	
    		for(var i=0;i<retObj.projectList.length;i++){
    			var project = retObj.projectList[i];
    			var focusX = project.focus_x;
	   			var focusY = project.focus_y;
	   		 	if((focusX < 73.59 || focusX > 134.74 ) && ( focusY < 4 || focusY > 53.33 )){
	   				var temp = focusX;
	   			 	focusX = focusY;
	   			 	focusY = temp;
	   		 	}
	   		 	focusX = 15.45 * focusX - 1100;
	   		 	focusY = 1180 - 21.87 * focusY;
			
	   			//去除坐标重复，防止覆盖
				for(var k=0; k<shiftLength; k++){
					var fugai = false;
					focusX += xShift[k];
				 	focusY += yShift[k];
				 	for(var j=0; j<handledLength; j++){
						var distance = (focusX-xs[j])*(focusX-xs[j]) + (focusY-ys[j])*(focusY-ys[j]);
						if(distance <= 100){
							fugai = true;
							break;
					 	}
			 	 	}
					if(fugai == true){
						focusX -= xShift[k];
						focusY -= yShift[k];
				 	}else{
						break;
				 	}
	   			}
	   		
	   		 	if(handledLength<100){
					xs[handledLength]=focusX;
					ys[handledLength]=focusY;
					handledLength++;
	   		 	}
	   		 
	   		 	var projectIcon = "project.gif";
	   		 	var projectStatus = project.project_status;
	   		 	if("5000100001000000001" == projectStatus){
	   				projectIcon = "project1.gif";
	   		 	}else if("5000100001000000004" == projectStatus){
	   				projectIcon = "project2.gif"; 
	   		 	} 
   			 document.getElementById("div1").appendChild(CreatNod(focusX,focusY,project.project_info_no,projectIcon,project.project_name,orgSubId,project.project_type));
    		}
    	}
    }
	
	function CreatNod(X,Y,projectInfoNo,imageName,projectName,orgSubId,projectType)//创建项目显示节点X,Y是经纬度坐标,ALT显示的项目信息
	{
		 //X = 15.45 * X - 1100;//X = 15.45 * X - 1136.73
		 //Y = 1180 - 21.87 * Y;//Y = 1184.576 - 21.87 * Y
	     var DIV=document.createElement("div");
	     var strHTML = "<a href='<%=mapPath%>/projectDailyStat.jsp?orgSubId="+orgSubId+"&projectInfoNo=" + projectInfoNo + "&projectType=" + projectType + "' target='_blank'><img border='0' src='<%=mapPath%>/images/" + imageName + "'  align='center' alt='"+projectName+"' style='position:absolute;z-index:6;left:"+X+"px;top:"+Y+"px;' ></a>";
	     DIV.innerHTML= strHTML ;
	     return DIV;
	}
	
	function CreatDep(X,Y,imageName,orgName,orgId,orgSubId)//创建经理部节点，X和Y是距离页面左上角的像素值
	{
	     var DIV=document.createElement("div");
	     var strHTML = "<a target='_blank' href='#'><img border='0' src='<%=mapPath%>/images/" + imageName + "' align='center' alt='"+orgName+"' style='position:absolute;z-index:6;left:"+(X-6)+"px;top:"+(Y-6)+"px;' ></a>";
	     DIV.innerHTML= strHTML ;
	     return DIV;
	}
</script>
</head>
<body style="overflow-y: auto" leftmargin="0" topmargin="0" id="body" onload="onload()">
<div id="div1" style="position:absolute;left:0px; top:0px;width: 0px; height: 0px">
  <!--地图层 -->
  <div id="map" style="position:absolute; z-index:3; left:0px; top:0px; width:620px; height:512px;" >
    <p> <img id="mapimg" border="0" src="<%=mapPath%>/images/china.gif" width="960" height="801"></p>
  </div>
</div>
<div id="cot_tl_fixed" style="position:absolute; left:5px; top:570px; width:145px; height:54px; z-index:30">
<STYLE type=text/css>
P {
	LINE-HEIGHT: 150%
}
TD {
	FONT-SIZE: 12px
}
</STYLE> 
<table width="129" border="0" cellSpacing=1 cellPadding=3  bgColor=#87A4E8>
  <tr> 
    <td colspan="2" bgColor=#f6f6f6>图例：</td>
  </tr>
  <tr bgColor=#f6f6f6> 
    <td width="11%"><img src="<%=mapPath%>/images/dep.gif" width="12" height="11"></td>
    <td width="89%">经理部/物探公司</td>
  </tr>
  <tr bgColor=#f6f6f6> 
    <td><a href="#" target="_blank"><img src="<%=mapPath%>/images/project1.gif" width="15" height="15" border="0"></a></td>
    <td><a href="#" target="_blank">正在准备的项目</a></td>
  </tr>
  <tr bgColor=#f6f6f6> 
    <td><a href="#" target="_blank"><img src="<%=mapPath%>/images/project.gif" width="15" height="15" border="0"></a></td>
    <td><a href="#" target="_blank">正在施工的项目</a></td>
  </tr>
  <tr bgColor=#f6f6f6> 
    <td><a href="#" target="_blank"><img src="<%=mapPath%>/images/project2.gif" width="15" height="15" border="0"></a></td>
    <td><a href="#" target="_blank">暂停的项目</a></td>
  </tr>
</table>
</div>
</body>
</html>