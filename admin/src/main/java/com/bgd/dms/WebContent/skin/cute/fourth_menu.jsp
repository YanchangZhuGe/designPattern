<%@ page contentType="text/html;charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%
  response.setContentType("text/html;charset=utf-8");
  response.setHeader("Pragma","No-cache"); 
  response.setHeader("Cache-Control","no-cache"); 
  response.setDateHeader("Expires", 0);
  String contextPath = request.getContextPath();
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/styles/style.css"/>
<link rel="stylesheet" type="text/css" href="<%=contextPath %>/styles/SpryTabbedPanels2.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/aside.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/listTable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 
<title>ePlanet</title>
</head>
<body>
<div id="list_nav"><img src="<%=contextPath %>/images/b.gif" width="12" height="33" class="fl" />
	<DIV id=tag-container_2>
      <UL id=tags class=tags>
        <!--
        <LI class="selectTag"><A href="#" onclick="getTab(this,0)">流程管理</A></LI>
        <LI><A href="#" onclick="getTab(this,0)" >权限管理</A></LI>
        <LI><A href="#" onclick="getTab(this,0)" >SAIS</A></LI>
        <LI><A href="#" onclick="getTab(this,0)" >生产运行</A></LI>
        <LI><A href="#" onclick="getTab(this,0)" >质量管理</A></LI>
        <LI><A href="#"  onclick="getTab(this,0)">文档管理</A></LI>  -->
      </UL>
    </DIV>
</div>
</body>
<script type="text/javascript">

//var parentNodeId = "<%=request.getParameter("menuId") %>";
function loadData(parentNodeId,parentNodeName,parentNodeUrl){
	clearFourthMenu();
	if(parentNodeId!=null && parentNodeId!="null" && parentNodeId!=""){
		Ext.Ajax.request({
			url : "<%=contextPath%>/queryMenus.srq?parentNodeId=" + parentNodeId,
			method : 'Post',
			success : function(resp){
				setFourthMenu(resp,parentNodeName,parentNodeUrl);
			},
			failure : function(){// 失败
			}		
		});
	}
}

var selectedTag;

function setFourthMenu(resp,parentNodeName,parentNodeUrl){
	var container = document.getElementById("tags");

	var datas = eval('(' + resp.responseText + ')');

	if(datas.returnCode!='0'){
		top.location='<%=contextPath%>/login.jsp';
	}
	
	var fourthmenu = datas.nodes;

	if(fourthmenu.length==0){// no fourth data
		
		fourthmenu[0] = {
 			url: parentNodeUrl,
 			name: parentNodeName
		}
	}
	for(var i=0;i<fourthmenu.length;i++){
		
		var li = document.createElement("li");
		
		var a = document.createElement("a");
		a.target = "list";
		a.id = "a_"+fourthmenu[i].id;
		
		if(fourthmenu[i].url!=null && fourthmenu[i].url!="undefined" && fourthmenu[i].url!=""){
			//url后面加上监测传过来的参数
			var _u = fourthmenu[i].url;
			if(fourthmenu[i].url.indexOf("http://")==0 || fourthmenu[i].url.indexOf("https://")==0){
				a.href = _u;
			}else{
				a.href = "<%=contextPath%>/"+_u;
			}
		}else{
			a.href = "about:blank";
		}

		a.innerHTML=fourthmenu[i].name;

		a.onclick=function(){
			getTab(this,0);
		}
		
		li.appendChild(a);
		container.appendChild(li);
	}
	
	$("#tags > li > a").get(0).click();
}

function getTab(obj,index) {
	if(selectedTag!=null){
		selectedTag.className ="";
	}
	
	selectedTag = obj.parentElement;
	selectedTag.className ="selectTag";

	// 设置top页面的topDialogs属性
	top.topDialogs=[];
	top.topDialogs.push( [top.$("#list"), null ] );
}

function clearFourthMenu(){
	document.getElementById("tags").innerHTML="";
}
</script>  
</html>
