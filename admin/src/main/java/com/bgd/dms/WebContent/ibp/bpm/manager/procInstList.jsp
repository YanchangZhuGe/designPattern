	<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK" />


<link rel="stylesheet" href="${pageContext.request.contextPath}/css/rt_table.css" type="text/css" />  
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" type="text/css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" type="text/css" />
<title>�б�ҳ��</title>
</head>

<body >
<!--Remark ����-->
<div id="nav">
    <ul><li id="cruTitle" class="bg_image_onclick"></li></ul>
</div>

<!--Remark ��ť����-->
<div id="div_button">
<table  cellSpacing=0 cellPadding=0 border=0 >
<tr>
<td>
<input class="button general" type="button" value="ȷ��" onClick="proccessTable()">
</td>
</tr>
</table>
</div>

<!--Remark ��ݲ�ѯ����-->
<div id="basicSearch" >
<table class="searchUIBasic" cellSpacing=0 cellPadding=2 width="100%" align=center border=0>
<tr>
<td width="60" align=left noWrap>
	<span><img src="${pageContext.request.contextPath}/images/search.gif" width="25"></span><br>
	<span ><a class="tishi_1txt" href="javascript:divHide('basicSearch');divShow('advanceSearch');">��ϲ�ѯ</a></span>
</td>

<td width="150" class=noWrap>
	<select id=bas_field style="WIDTH: 150px" onChange="updateFieldOption(this, 'bas_cdt','bas_sel','bas_input');" /> 
</td>
<td width="100" class="noWrap">
	<select style='WIDTH: 100px' id="bas_cdt"/>
</td>
<td width="120" class="noWrap">
	<input class=txtBox style="WIDTH:120px" id="bas_input" style="display:none">
	<select class=txtBox id=bas_sel style="WIDTH: 120px"/> 
</td>
<td class="noWrap" align="left">
	<input class="button general" onClick="basicQuery();" type=button value=" ���� " name=submit>&nbsp; 
</td>
<td ></td>
</tr>
</table>
</div>

<!--Remark ��ϲ�ѯ����-->
<div id="advanceSearch" style="display:none">
<table class="searchUIBasic" cellSpacing=0 cellPadding=0 width="100%" align=center border=0>
<tr>
	<td width="60">
	<span><img src="${pageContext.request.contextPath}/images/search.gif" width="25"></span>
	<br>
	<span ><a class="tishi_1txt" href="javascript:divHide('advanceSearch');divShow('basicSearch');">��ݲ�ѯ</a></span>	
	</td>
	
  <td width="380">
  	<div class=small id=fixed style="BORDER-RIGHT: #cccccc 1px solid; PADDING-RIGHT: 0px; BORDER-TOP: #cccccc 1px solid; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; OVERFLOW: auto; BORDER-LEFT: #cccccc 1px solid; WIDTH: 410; PADDING-TOP: 0px; BORDER-BOTTOM: #cccccc 1px solid; POSITION: relative; HEIGHT: 85px; BACKGROUND-COLOR: #FFFFCC">
    <table id="ComplexTable" width="95%" border=0>
      <tr>
        <td><select style="WIDTH: 150px" onChange="updateCmpOption(this)" name='cmp_field'/>
              </td>
        <td><select style='WIDTH: 100px' name='cmp_cdt'/></td>             
        <td width="50%"><input name='cmp_input' style="WIDTH:120px">
        	<select name='cmp_sel' style="WIDTH: 120px"/> 
        </td>
      </tr>
      <tr>
        <td><select style="WIDTH: 150px" onChange="updateCmpOption(this)" name='cmp_field'/>
              </td>
        <td><select style='WIDTH: 100px' name='cmp_cdt'/></td>             
        <td width="50%"><input name='cmp_input' style="WIDTH:120px">
        	<select name='cmp_sel' style="WIDTH: 120px"/> 
        </td>
      </tr>
      <tr>
        <td><select style="WIDTH: 150px" onChange="updateCmpOption(this)" name='cmp_field'/>
              </td>
        <td><select style='WIDTH: 100px' name='cmp_cdt'/></td>             
        <td width="50%"><input name='cmp_input' style="WIDTH:120px">
        	<select name='cmp_sel' style="WIDTH: 120px"/> 
        </td>
      </tr>
    </table>
  </div></td>
  
	<td align=left>
	<table cellSpacing=0 cellPadding=0 align=left border=0>
		<tr>	
		<td height="34" align=center>
		  <input class="button general" onClick="cmpQuery();" type=button value=" ���� "> 
		</td>
		</tr>
		<tr>
		<td height="36" align=center>
		<input class="button other" onClick="addSearchRow()" type=button value="�������" name=more> 
		<input class="button other" onclick=deleteSearchRow() type=button value="��������" name=button>
		</td>
		</tr>
	
		</table>
	</td>
	<td></td>	
</tr>
</table>
</div>

<!--Remark ��ѯָʾ����-->
<div id="rtToolbarDiv">
<table border="0"  cellpadding="0"  cellspacing="0"  class="rtToolbar"  width="100%" >
	<tr>
		<td></td>
	<td>
		<span id="dataRowHint">��0/0ҳ,��0����¼ </span>&nbsp;&nbsp;
		��&nbsp;<input type="text"  id="changePage"  class="rtToolbar_chkboxme">&nbsp;ҳ
		<a href='javascript:changePage()'><img src='${pageContext.request.contextPath}/images/table/bullet_go.gif'    alt='Go' align="absmiddle" /></a>		 </td>
		<td align="right" >
		<table id="navTableId" border="0"  cellpadding="0"  cellspacing="0" >
			<tr>
				<td><img src="${pageContext.request.contextPath}/images/table/firstPageDisabled.gif"  style="border:0"  alt="First" /></td>
				<td><img src="${pageContext.request.contextPath}/images/table/prevPageDisabled.gif"  style="border:0"  alt="Prev" /></td>
				<td><img src="${pageContext.request.contextPath}/images/table/nextPageDisabled.gif"  style="border:0"  alt="Next" /></td>
				<td><img src="${pageContext.request.contextPath}/images/table/lastPageDisabled.gif"  style="border:0"  alt="Last" /></td>				
			</tr>
		</table>
		</td>
	</tr>
</table>
</div>

<!--Remark ��ѯ�����ʾ����-->
<div style="OVERFLOW-y:scroll;">
<table class="rtTable" id="queryRetTable">
<thead>
<tr>

	<td >��������</td>
	<td >����ʵ������</td>
</tr>
</thead>
<tr>

	<td >��������</td>
	<td >����ʵ������</td>
</tr>
</table>
</div>

</body>
</html>
