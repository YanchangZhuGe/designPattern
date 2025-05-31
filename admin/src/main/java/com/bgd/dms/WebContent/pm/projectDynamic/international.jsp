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
    <title>国际项目展示</title>
	<style type="text/css">
		a.{ font: 9pt "宋体"; cursor: hand; font-size: 9pt ; color: #000000; text-decoration: none;TEXT-DECORATION: none}
		a:active{ font: 9pt "宋体"; cursor: hand; color: #FF0033;TEXT-DECORATION: none}
		a.cc:hover{ font: 9pt "宋体"; cursor: hand; color: #FF0033;TEXT-DECORATION: none}
		.box{ font: 9pt "宋体"; position: absolute;  background: #87A4E8 }
	</style>
	<script type="text/javascript">
	  //document.onmousemove   =   getxy;   
	  var   x=0   
	  var   y=0     
	  function   getxy(e)   {     
	      var   x= event.offsetX ;
	      var   y= event.offsetY ;
	      //   x=event.x   +   document.body.scrollLeft   
	      //   y=event.y   +   document.body.scrollTop 
	      if   (x   <   0){x   =   0}   
	      if   (y   <   0){y   =   0}       
	      window.status=x+','+y   
	      return   true   
	  } 

	  var depInfo = [
			["C105002000", "C0000000000233", "俄罗斯项目经理部", "719", "101"],
			["C105002001", "C0000000000234", "深海业务经理部", "765", "165"],
			["C105002004000", "C6000000000211", "肯尼亚项目经理部", "565", "285"],
			["C105002004003", "C6000000000205", "马达加斯加项目经理部", "588", "343"],
			["C105002004004", "C6000000000273", "乌干达项目组", "550", "279"],
			["C105002004005", "C6000000000288", "莫桑比克项目经理部", "566", "331"],
			["C105002004006", "C6000000000199", "坦桑尼亚项目经理部", "557", "304"],
			["C105002006000", "C6000000000224", "泰国项目组", "735", "237"],
			["C105002006001", "C6000000000222", "文莱项目经理部", "773", "272"],
			["C105002006003", "C6000000005227", "孟加拉项目组", "703", "215"],
			["C105002006004", "C6000000000263", "印尼项目组", "776", "291"],
			["C105002006005", "C6000000005720", "越南项目组", "745", "220"],
			["C105002007001", "C6000000000146", "刚果项目组", "505", "285"],
			["C105002007002", "C6000000000232", "尼日利亚项目经理部", "484", "258"],
			["C105002007006", "C6000000005250", "喀麦隆项目组", "496", "272"],
			["C105002008", "C6000000000227", "苏丹项目经理部", "544", "243"],
			["C105002009002", "C6000000000255", "厄瓜多尔项目经理部", "248", "290"],
			["C105002009003", "C6000000000249", "墨西哥项目经理部", "194", "213"],
			["C105002035", "C6000000000266", "哈萨克斯坦项目经理部", "630", "136"],
			["C105002036", "C6000000000271", "土库曼项目经理部", "610", "162"],
			["C105002037", "C6000000000201", "乌兹别克项目经理部", "625", "159"],
			["C105002038", "C6000000000143", "叙利亚项目经理部", "562", "177"],
			["C105002039", "C6000000000241", "阿曼项目经理部", "613", "225"],
			["C105002040", "C6000000000238", "也门项目组", "590", "238"],
			["C105002041", "C6000000000236", "沙特项目经理部", "581", "212"],
			["C105002042", "C6000000000256", "伊朗项目经理部", "607", "188"],
			["C105002043", "C6000000000272", "伊拉克项目组", "576", "183"],
			["C105002044", "C6000000000243", "巴基斯坦项目经理部", "644", "196"],
			["C105002045", "C6000000000173", "尼日尔项目经理部", "489", "231"],
			["C105002046", "C6000000000153", "乍得项目经理部", "513", "237"],
			["C105002047", "C6000000000147", "利比亚项目经理部", "512", "204"],
			["C105002048", "C6000000000157", "阿尔及利亚项目经理部", "470", "201"],
			["C105002049", "C6000000000171", "毛里塔尼亚项目经理部", "436", "225"],
			//东非,秘鲁,委内瑞拉,没有下属队伍
			["C105002009008", "C6000000006743", "委内瑞拉项目组", "285", "260"],
			["C105002009000", "C6000000000269", "秘鲁项目组", "252", "312"]
	  ];
	  
	  function onload()//初始化项目节点
	  {
	       for(var i=0;i<depInfo.length;i++){
	    	   if(depInfo[i][0].indexOf('<%=orgSubId%>')>=0)
		       	document.getElementById("div1").appendChild(CreatDep(depInfo[i][3],depInfo[i][4],"project.gif",depInfo[i][2],depInfo[i][1],depInfo[i][0]));              
	       }
	  }
	
	  function CreatDep(X,Y,imageName,orgName,orgId,orgSubId)//创建经理部节点，X和Y是距离页面左上角的像素值
	  {
	       var DIV=document.createElement("div");
	       var strHTML = "<a target='_blank' href='#'><img border='0' src='<%=mapPath%>/images/" + imageName + "' align='center' alt='"+orgName+"' style='position:absolute;z-index:6;left:"+(X-6)+"px;top:"+(Y-6)+"px;' ></a>";
	       DIV.innerHTML= strHTML ;
	       return DIV;
	  }
	  
	  ////隐藏所有菜单的js函数
	  function hiddenAllTable(){
	
	  
	  }
	  ////结束-----隐藏所有菜单的js函数
	  
	  ///开始弹出某个菜单的函数
	  function popUp(orgId) 
	  {
	    hiddenAllTable();
	  }
	  ///结束弹出某个菜单的函数
	</script>
</head>
<body style="overflow-y: auto" leftmargin="0" topmargin="0" id="body" onload="onload()">

<div id="div1" style="position:absolute;left:0px; top:0px;width: 0px; height: 0px"> 
  <!--地图层 -->
  <div id="map" style="position:absolute; z-index:3; left:0px; top:0px; width:620px; height:512px" > 
    <p>
      <img id="mapimg" border="0" onclick="javaScript:hiddenAllTable();" src="images/world.gif" width="980" height="548" align="center" >
    </p>
  </div>
</div>
<div id="cot_tl_fixed" style="position:absolute; left:5px; top:520px; width:145px; height:54px; z-index:30">
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
    <td width="11%"><img src="images/dep.gif" width="12" height="11"></td>
    <td width="89%">经理部/物探公司</td>
  </tr>
</table>
</div>
</body>
</html>
