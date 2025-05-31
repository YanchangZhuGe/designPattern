<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page  import="java.util.*"%>
<%
    String contextPath = request.getContextPath();
    
    String flag = (String)request.getAttribute("flag");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增工区管理信息</title>
<script src="../js/prototype.js"></script>
<script src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/help.js"></script>

<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/validator.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript">
	function checkForm() { 	
        if (!isTextPropertyNotNull("structUnitName", "构造单元名称")) {
		
			document.form1.structUnitName.focus();
			return false;	
		}
        if (!isLimitB100("structUnitName", "构造单元名称")) {
		
			document.form1.structUnitName.focus();
			return false;	
		}
        if (!isLimitB200("basin", "盆地")) {
		
			document.form1.basin.focus();
			return false;	
		}
        if (!isTextPropertyNotNull("regionName", "行政区名称")){
		
			document.form1.regionName.focus();
			return false;	
		}
        if (!isLimitB200("regionName", "行政区名称")) {
		
			document.form1.regionName.focus();
			return false;	
		}
        if (!isTextPropertyNotNull("structUnitId", "构造单元代码")) {
		
			document.form1.structUnitId.focus();
			return false;	
		}
        if (!isWordsNumber31("structUnitId", "构造单元代码")) {
		
			document.form1.structUnitId.focus();
			return false;	
		}
		if(!isValidFloatProperty12_2("structUnitArea","构造单元面积")) {
		
			document.form1.structUnitArea.focus();
			return false;	
		}
		if (!isLimitB100("divideUnit", "划分单位")) {
		
			document.form1.divideUnit.focus();
			return false;	
		}
		if (!isLimitB255("notes", "备注")) {
		
			document.form1.notes.focus();
			return false;	
		}
		return true;
	}
	
	function insertStructureUnit(){
	
		if (!checkParent()) return;
		if (!checkForm()) return;
		var form = document.forms[0];
		form.action="<%=contextPath%>/gpe/insertStructureUnit.srq";
		form.submit();
	}
		
	function checkParent(){
	
		var structUnitLevel = document.form1.structUnitLevel.value;
		
		var structUnitParent = document.form1.structUnitParent.value;
		
//		alert(structUnitLevel);
//		alert(structUnitParent);
		
		if(structUnitLevel != 1 && (structUnitParent == null ||structUnitParent=="")){
		
			alert("您所设定的构造单元级别要求选择上级构造单元，请选择上级构造单元！");
			
			return false;
		}
		
		return true;
	}
	
	function choosestructParent() 
　　{ 

		var structUnitLevel = document.getElementsByName("structUnitLevel")[0].value - 1;
		var obj = new Object();
		obj.fkValue="";
		obj.value="";
		var resObj = window.showModalDialog('<%=contextPath%>/pm/structureUnit/sUnitParentSelect.jsp?sulevel='+structUnitLevel,window);
　　		//popParentWin = window.open('<%=contextPath%>/structureUnit/sUnitParentSelect.jsp?level='+structUnitLevel,'example01','width=640,height=480,alwaysRaised=1,scrollbars=yes,toolbar=0,menubar=0');
		//popWindow('<%=contextPath%>/gpe/querystrparentinfos.srq?structUnitLevel='+structUnitLevel);
		
		document.getElementById("structUnitNo1").value = resObj.fkValue;		
		document.getElementsByName("structUnitParent")[0].value = resObj.value;
	}
	
	function updatestrparent(index){
	
		var index ;
//		alert(index);
		var strparent = new Array();
		strparent=index.split(",");
		var structUnitNo = strparent[0];
		var structUnitParent = strparent[1];
		document.getElementById("structUnitNo1").value = structUnitNo;	
		document.getElementsByName("structUnitParent")[0].value = structUnitParent;
//		alert(structUnitNo);
//		alert(structUnitParent);
	
	}
	
	function cleanupstructParent(){
	
		document.forms[0].structUnitParent.value="";
	}
	
	function cancle(){
	
		document.forms[0].structUnitName.value="";
	    document.forms[0].structUnitLevel.value="";
	    document.forms[0].structUnitParent.value="";
	    document.forms[0].basin.value="";
	    document.forms[0].divideDate.value="";
	    document.forms[0].regionName.value="";
	    document.forms[0].structUnitId.value="";
	    document.forms[0].structUnitArea.value="";
	    document.forms[0].divideUnit.value="";
	    document.forms[0].notes.value="";
	}
	
</script>
</head>

<body>
<form name="form1" id="CheckForm" action="" method="post" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height"  width="100%">
  <tr>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;构造单元名称：</td>
   <td class="inquire_form4"><input id="structUnitName" name="structUnitName" type="text"　 value="" class="input_width" /></td>
   <td class="inquire_item4"><font color="red">*</font>&nbsp;构造单元级别：</td>
   <td class="inquire_form4"><select id="structUnitLevel" name="structUnitLevel" class="select_width" onchange="cleanupstructParent();">
                             <option selected="selected" value="1">一级</option>
						     <option value="2">二级</option>
						     <option value="3">三级</option>
						     <option value="4">四级</option>
                        </select></td>
  </tr>
  <tr>
    <td class="inquire_item4">上级构造单元：<!-- <input name="findstructParent" type="button" class="iButton2" onclick="choosestructParent();" value="选择" /> --></td>
    <td class="inquire_form4">
    	<input type="hidden" id="structUnitNo1" name="structUnitNo1" id="structUnitNo1" />
	    <input type="text" id="structUnitParent" name="structUnitParent" class="input_width" id="structUnitParent"  readOnly/>&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" onclick="choosestructParent();"/>
    </td>
    <td class="inquire_item4">盆地：</td>
    <td class="inquire_form4"><input id="basin" name="basin" type="text" value="" class="input_width" />
    
    </td>
  </tr>
  <tr>
    <td class="inquire_item4"><font color="red">*</font>&nbsp;划分年度：</td>
    <td class="inquire_form4">
    <select id="divideDate" name="divideDate" class="select_width">
	    <%
	    Date date = new Date();
	    int years = date.getYear()+ 1900 - 10;
	    int year = date.getYear()+1900;
	    for(int i=0; i<20; i++){
	    %>
	    <option value="<%=years %>" <%	if(years == year) {  %> selected="selected" <% } %> > <%=years %> </option>
	    <%
	    years++;
	    }
	     %>
	    	
	    </select>
    
    </td>
    <td class="inquire_item4"><font color="red">*</font>&nbsp;行政区名称：</td>
	<td class="inquire_form4"><input id="regionName" name="regionName" type="text" value="" class="input_width" />
	
	</td>
  </tr>
  <tr>
    <td class="inquire_item4"><font color="red">*</font>&nbsp;构造单元代码：</td>
    <td class="inquire_form4"><input name="structUnitId" type="text" value="" class="input_width" />
    </td>
   	<td class="inquire_item4">构造单元面积：</td>
   	<td class="inquire_form4"><input name="structUnitArea" type="text" value="" class="input_width" /> km&sup2
    </td>
  </tr>
  <tr> 
  	<td class="inquire_item4">划分单位：</td>
   	<td class="inquire_form4"><input name="divideUnit" type="text" value="" class="input_width" />
    </td> 
    <td class="inquire_item4">&nbsp;</td>
    <td class="inquire_form4">&nbsp;</td>
  </tr>
   <tr>   
    <td class="inquire_item4">备注：</td>
    <td class="inquire_form4" colspan="3"><textarea id="notes" name="notes" class="textarea" ></textarea></td>    
  </tr>
</table>
</div>
 <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="insertStructureUnit()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
 </div>
</div></div>
</form>
</body>
</html>