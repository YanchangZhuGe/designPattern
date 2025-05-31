<%@ page contentType="text/html;charset=utf-8"%>
<html>
<head>
<%
response.setContentType("text/html;charset=utf-8");
  response.setHeader("Pragma","No-cache"); 
  response.setHeader("Cache-Control","no-cache"); 
  response.setDateHeader("Expires", 0);
String contextPath = request.getContextPath();
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>nav</title>
<link rel="stylesheet" href="style/style.css" type="text/css" media="screen" />
<script type="text/javascript" src="<%=contextPath %>/js/rt/rt_list.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath %>/skin/cute/js/jquery.js"></script>
<script type="text/javascript" src="<%=contextPath %>/skin/cute/js/easySlider1.7.js"></script>
<script type="text/javascript" src="<%=contextPath %>/skin/cute/js/png.js"></script>
<script type="text/javascript" src="<%=contextPath %>/skin/cute/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath %>/skin/cute/js/menu.js"></script>

<script type="text/javascript">
	
	
$(document).ready(function(){
	$("#navSubSlider").css("height",$(window).height()-10);
	$("#navMainSlider").easySlider({
	});
});	

function init(){
if(document.getElementById('menu1Index').value != ''){
menuConfig.selMenu1Index = document.getElementById('menu1Index').value;
}
if(document.getElementById('menu2Index').value != ''){
menuConfig.selMenu2Index = document.getElementById('menu2Index').value;
}
menu1_create();
menu2_create();

}
function menu1_create(){
	var menu1List = queryMenu1();
	for(i=0;i<menu1List.length;i++){
		if(menu1List[i].imgUrl == null || menu1List[i].imgUrl == '')
			continue;
		var menu1_li = document.createElement("li");
		document.getElementById("menu1_parent").appendChild(menu1_li);
		var menu1_a = document.createElement("a");
		menu1_a.href = "#";
		menu1_li.appendChild(menu1_a);
		var picHtml = "<img name=\""+ menu1List[i].id +"\" id=\"menu1Pic"+(i)+"\" pic=\""+menu1List[i].imgUrl+"\" src=\"images/m1_"+menu1List[i].imgUrl+"_n.jpg\""
					+" onClick=\"menu1_click(this)\""
					+" onMouseOver=\"menu1_hover(this)\" onMouseOut=\"menu1_out(this)\" />";
		menu1_a.innerHTML = picHtml;
		var menu1_div = document.createElement("div");
		menu1_div.className = "arrow";
		menu1_li.appendChild(menu1_div);
		//alert(menu1_li.innerHTML);
	}
	
	delete(Object.prototype.toJSONString);
//	$("#menu1Pic0").attr("src","images/m1_"+ menu1List[0].imgUrl + "_c.jpg");
	var selPic = "#menu1Pic" + menuConfig.selMenu1Index; 
	$(selPic).attr("src","images/m1_"+ menu1List[menuConfig.selMenu1Index].imgUrl + "_c.jpg");
	$("div.arrow:eq("+menuConfig.selMenu1Index+")").css("display","block");
	
}
function menu2_create(){
	delete(Object.prototype.toJSONString);
	$("#menu2_parent").html(""); //清空二级菜单
	var menu2List = queryMenu2();   //一次将所有二级菜单全部查出来
	for(i=0;i<menu2List.length;i++){
		var menu2_li = document.createElement("li");
		document.getElementById("menu2_parent").appendChild(menu2_li);
		var menu2_a = document.createElement("a");
		menu2_a.target = "list";
		menu2_a.href = '<%=contextPath%>/'+ menu2List[i].url;
		menu2_a.innerHTML = menu2List[i].name;
		menu2_a.onclick = function(){menu2_click(this);};
		menu2_a.onkeydown = function(){if(event.keyCode==13){return false;}};
		menu2_a.index = i;
		menu2_a.id = "menu2_id"+(i);
		menu2_li.appendChild(menu2_a);
	}
	if(document.getElementById('menu2Index').value != ''){
		var selId2 = "#menu2_id"+menuConfig.selMenu2Index;
		$(selId2).addClass("menu2_c");
	}
}

function menu1_click(obj){
	//deselect last selected menu1
	var lastSelImg = document.getElementById("menu1Pic"+menuConfig.selMenu1Index);
	lastSelImg.src = "images/m1_"+lastSelImg.pic+"_n.jpg";	
	var selPic = obj.id;
	var index = selPic.substr(selPic.length-1);
	menuConfig.selMenu1Index = index;
	document.getElementById('menu1Index').value = menuConfig.selMenu1Index;
	menuConfig.selMenu2Index = 0;
	document.getElementById('menu2Index').value = '';
	obj.src = "images/m1_"+obj.pic+"_c.jpg";
	$("div.arrow").css("display","none");
	$("div.arrow:eq("+index+")").css("display","block");
	menu2_create();
}

function menu1_hover(obj){
	var selPic = obj.src;
	if(selPic.substr(selPic.length-6) == "_c.jpg") return;	
	obj.src = "images/m1_"+obj.pic+"_h.jpg";
}

function menu1_out(obj){
	var selPic = obj.src;
	if(selPic.substr(selPic.length-6) == "_c.jpg") return;
	obj.src = "images/m1_"+obj.pic+"_n.jpg";
}

function menu2_click(obj){
	//deselect last selected menu1
	var lastSelMenu2 = document.getElementById("menu2_id"+menuConfig.selMenu2Index);
	lastSelMenu2.className = "";
	menuConfig.selMenu2Index = obj.index;
	document.getElementById('menu2Index').value = menuConfig.selMenu2Index;
	obj.className = "menu2_c";
}
</script>
</head>
<body onLoad="init()">
<input type='hidden' id='menu1Index' name ='menu1Index' value='<%= request.getParameter("menu1") == null ? "" : request.getParameter("menu1") %>'/>
<input type='hidden' id='menu2Index' name='menu2Index' value='<%= request.getParameter("menu2") == null ? "" : request.getParameter("menu2") %>'/>
<div id="mask" class="mask"></div>
<div id="nav">
<div id="navMain">
  <div id="navMainPrev" class="navMainPrev"><a href="#" class="prevBtn"></a></div>
  <div id="navMainSlider">
    <ul id="menu1_parent">
		<!--<li><a href="#"><img id="menu1Pic0" pic="test" src="images/test_n.gif" onClick="menu1_click(this)" onMouseOver="menu1_hover(this)" onMouseOut="menu1_out(this)" /></a><div class="arrow"></div></li>-->      
    </ul>   
  </div>
  <div id="navMainNext" class="navMainNext"><a href="#" class="nextBtn"></a></div> 
</div>
<div id="navSub">
  <div id="navSubSlider">
    <ul id="menu2_parent">
      <!--<li><a index="0" id="menu2_id0" href="p1.html" target="mainFrame" onClick="menu2_click(this)">二级菜单01</a></li>-->
    </ul>
  </div>
</div>
</div>
<div style='display:none;' id='cp' value='<%=contextPath%>' />
</body>
</html>
