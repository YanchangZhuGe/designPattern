 
<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = request.getParameter("orgSubId");
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getOrgSubjectionId();
%>
<html >

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 
	 <link rel="stylesheet" type="text/css" href="<%=contextPath%>/rm/em/humanLabor/styless.css" media="screen"><!--<![endif]-->
	
	<title>Pure CSS collapsible tree menu | The CSS Ninja</title>
<style>
body, form, ul, li, p, h1, h2, h3, h4, h5
{
	margin: 0;
	padding: 0;
    FONT-SIZE: 13px;
}
a{ color:#111111;}
body {color:#111111; margin: 0; }
img { border: none; }
p
{
	font-size: 1em;
	margin: 0 0 1em 0;
}

html { font-size: 100%; /* IE hack */ }
body { font-size: 1em; /* Sets base font size to 16px */ }
table { font-size: 100%; /* IE hack */ }
input, select, textarea, th, td { font-size: 1em; }
	
/* CSS Tree menu styles */
ol.tree
{
	padding: 0 0 0 2px;
	width: 200px;
    
}
	li 
	{ 
		position: relative; 
		margin-left: -15px;
		list-style: none;
	}
	li.file
	{
		margin-left: -1px !important;
	}
		li.file a
		{
			background: url(<%=contextPath%>/rm/em/humanLabor/document.png) 0 0 no-repeat;
			color: #111111;
			padding-left: 21px;
			text-decoration: none;
			display: block;
		}
		li.file a[href *= '.pdf']	{ background: url(<%=contextPath%>/rm/em/humanLabor/document.png) 0 0 no-repeat; }
		li.file a[href *= '.html']	{ background: url(<%=contextPath%>/rm/em/humanLabor/document.png) 0 0 no-repeat; }
		li.file a[href $= '.css']	{ background: url(<%=contextPath%>/rm/em/humanLabor/document.png) 0 0 no-repeat; }
		li.file a[href $= '.js']		{ background: url(<%=contextPath%>/rm/em/humanLabor/document.png) 0 0 no-repeat; }
	li input
	{
		position: absolute;
		left: 0;
		margin-left: 0;
		opacity: 0;
		z-index: 2;
		cursor: pointer;
		height: 1em;
		width: 1em;
		top: 0;
	}
	li input + ol
	{
		background: url(<%=contextPath%>/rm/em/humanLabor/toggle-small-expand.png) 40px 0 no-repeat;
		margin: -0.938em 0 0 -44px; /* 15px */
		xdisplay: block;
		height: 1em;
	}
	li input + ol > li { height: 0; overflow: hidden; margin-left: -14px !important; padding-left: 1px; }
li label
{
	background: url(<%=contextPath%>/rm/em/humanLabor/folder-horizontal.png) 15px 1px no-repeat;
	cursor: pointer;
	display: block;
	padding-left: 27px;
}

li input:checked + ol
{
	background: url(<%=contextPath%>/rm/em/humanLabor/toggle-small.png) 40px 5px no-repeat;
	margin: -1.25em 0 0 -44px; /* 20px */
	padding: 1.563em 0 0 80px;
	height: auto;
}
	li input:checked + ol > li { height: auto; margin: 0 0 0.125em;  /* 2px */}
	li input:checked + ol > li:last-child { margin: 0 0 0.063em; /* 1px */ }
</style>
</head>
<script type="text/javascript">
function dbClickNode(orgId){
	 
	 self.parent.frames["mainFrame"].location="<%=contextPath %>/rm/em/humanLabor/doc_list2.jsp?orgSubId="+orgId; 
	
}
</script>
<body>
	
	<ol class="tree">
		<li>
			<label for="folder1" onclick="dbClickNode('C105')">&nbsp;&nbsp; 东方地球物理勘探有限公司 </label>  </br>
			<ol> 
				<li class="file"><a href="#" onclick="dbClickNode('C105001002')">新疆物探处</a></li>
				<li class="file"><a href="#"  onclick="dbClickNode('C105001004')">青海物探处</a></li>
				<li class="file"><a href="#"  onclick="dbClickNode('C105001003')">吐哈物探处</a></li>
				<li class="file"><a href="#"  onclick="dbClickNode('C105001005')">塔里木物探处</a></li>
				<li class="file"><a href="#"  onclick="dbClickNode('C105005004')">长庆物探处</a></li>
				<li class="file"><a href="#"  onclick="dbClickNode('C105063')">辽河物探处</a></li>
				<li class="file"><a href="#"  onclick="dbClickNode('C105005000')">华北物探处</a></li>
				<li class="file"><a href="#"  onclick="dbClickNode('C105007')">大港物探处</a></li>
				<li class="file"><a href="#"  onclick="dbClickNode('C105005001')">新兴物探开发区</a></li>
				 
			</ol>
		</li>
	 
		 
	</ol>
 
</body>
</html>
