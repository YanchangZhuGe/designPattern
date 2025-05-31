<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
    Map map=resultMsg.getMsgElement("marketMap").toMap();
    Map mapType=resultMsg.getMsgElement("mapType").toMap();
    String content=resultMsg.getValue("content");
    List<MsgElement> fileList = resultMsg.getMsgElements("fileList");
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    
    String dailyNo = request.getParameter("id");
    
    String action = request.getParameter("action");
    String twoType = (String)map.get("twoTypeId");
    String twoTypeStr = twoType.substring(0,5);
	System.out.println("------------------------------"+twoTypeStr);
    String ttt=(String)map.get("twoTypeId");
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>物探公司动态</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<script type="text/javascript" src="<%=contextPath%>/js/kindeditor/kindeditor.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/kindeditor/lang/zh_CN.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<link href="<%=contextPath%>/js/oc/oc_upload.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/oc/oc_common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/oc/oc_upload.js"></script>
</head>

<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/updateWtgs.srq">
<table border="0" cellpadding="0" cellspacing="0" width="95%" height="800" class="form_info">
	 <input name="infomation_id" type="hidden" value="<%=(String)map.get("infomationId") %>"/>
	 <input name="file_id" type="hidden" value="<%=(String)map.get("fileId") %>"/>
	 <input type="hidden"  name="deletedFiles" id="deletedFiles"/>
	<tr class="odd">
	  	<td class="inquire_item"><font color=red>*</font>&nbsp;标题：</td>
	    <td class="inquire_form">
	    	<input type="text" name="infomation_name" value="<%=(String)map.get("infomationName") %>" class="input_width"/>	    
	    </td>
	      <td class="inquire_item"><font color=red>*</font>&nbsp;发布日期：</td>
    	<td class="inquire_form"><input type="text" id="release_date" class="input_width"  name="release_date" value="<%=(String)map.get("releaseDate") %>">
      &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16"  style="cursor:hand;" onMouseOver="dateSelector(release_date,tributton2);"></td>
	    
	</tr>
  	<tr class="odd">
    	<td class="inquire_item"><font color=red>*</font>&nbsp;一级分类：</td>
    	<td class="inquire_form">
    	<% 
    		String sql = "select t.code,t.code_name from bgp_infomation_type_info t where t.father_code='106' order by t.code";
    		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
    		for(int i= 0;i<list.size();i++){
    			Map mapC1=(Map)list.get(i);
    			String code = (String)mapC1.get("code");
    			String codeName = (String)mapC1.get("codeName");
    			%>
    			<input type="radio" name="two_type_id" id="two_type_id" onclick="changeType(this)" value="<%=code %>"><%=codeName %>
    	<%		
    		}
    	%>
		</td>
      <td class="inquire_item"><font color=red>*</font>&nbsp;公司名称：</td>
    	<td class="inquire_form"><select name="comm" id="comm" class="select_width">
	   
      </td>
    </tr>    
    <tr class="odd">
    	<td class="inquire_item"><font color=red>*</font>&nbsp;二级分类：</td>
    	<td class="inquire_form" colspan="3">
    	<% 
    		String sql2 = "select t.code,t.code_name from bgp_infomation_type_info t where t.father_code='10802' order by t.code";
    		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
    		for(int i= 0;i<list2.size();i++){
    			Map map2=(Map)list2.get(i);
    			String code2 = (String)map2.get("code");
    			String codeName2 = (String)map2.get("codeName");
    			if(code2.equals("10802002")){
    			%>
    			<input type="radio" name="three_type_id" id="three_type_id" value="<%=code2 %>"><%=codeName2 %>
    	<%		}
    		}
    	%>
      </td>
    </tr>    
    <tr class="odd">
	  	<td class="inquire_item">&nbsp;摘要：</td>
	    <td class="inquire_form"  colspan="3">
	    	<input type="text" name="abstract" id="abstract" value="<%=(String)map.get("abstract") %>" class="input_width"/>	    
	    </td>
	</tr>
    
    <tr class="odd" height="300">
	  	<td class="inquire_item">&nbsp;内容：</td>
	    <td colspan="3"  class="inquire_form">
	     <textarea id="editor_id" name="content" style="width:95%;height:500px;"><%=content %>
	    </textarea>
	    </td>
	</tr>
      </tr>
      
       <tr class="odd">
        <td class="inquire_item">相关附件：</td>
        <input type="hidden" id="infoId" name="infoId" class="input_width" value="<%=map.get("fileId")==null?"":map.get("fileId")%>"/>
        <td  colspan="3"  class="inquire_form" height="28px;">
          <label>
         	<script type="text/javascript">ocUpload.init(6);</script>
          </label>
          <%
         		if(fileList!=null && fileList.size()>0){
         			for(int j=0;j<fileList.size();j++){
         				Map fileMap=fileList.get(j).toMap();
         				String name = (String)fileMap.get("fileName");
        			  	String id = (String)fileMap.get("fileId");
         	%>
			<div id="<%=id%>"><%=name%>
			<input type=button onclick="delfiles('<%=id%>')"  value="删除">
			</div>
         	<%
         			}
         		}
         	%>
        </td>
      </tr>
      
       <tr class="odd">
    <td colspan="4" class="ali4">
    	<input name="Submit2" type="button" class="iButton2" onClick="save()" value="保存" />
    	<input name="Submit" type="button" class="iButton2"  onClick="window.history.back();" value="返回" />
    </td>
  </tr> 
</table>
</form>
</body>

<script type="text/javascript">
var editor;
KindEditor.ready(function(K) {
        editor = K.create('#editor_id');
});

//document.getElementById("two_type_id").value=<%=(String)map.get("twoTypeId")%>;

	var two = document.getElementsByName("two_type_id");
	for(var i=0; i<two.length; i++){
		if(two[i].value==<%=twoTypeStr %>){
			if(two[i].checked="checked"){
				changeType(two[i]);	
			}
		}
	}
	document.getElementById("comm").value=<%=twoType %>;
	var three = document.getElementsByName("three_type_id");
	
	for(var i=0;i<three.length;i++){
		if(three[i].value==<%=(String)map.get("threeTypeId") %>){
			three[i].checked="checked";
		}
	}

	function delfiles(id) {
		if(confirm("确定要删除此附件?")) {
	    	var id1=id;
	     	document.getElementById('deletedFiles').value+=id1 +',';
	     	document.getElementById(id).style.display='none';
	  	} else {
	    	return false;
	 	}	
	}
	
	function changeType(ob){
		if("10601"==ob.value){
			document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION selected value=>请选择</OPTION><OPTION value=10601001>大庆物探一公司</OPTION><OPTION value=10601002>大庆物探二公司</OPTION><OPTION value=10601003>川庆钻探物探公司</OPTION></SELECT>";
		}else if("10602"==ob.value){
			document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION selected value=>请选择</OPTION><OPTION value=10602001>胜利物探公司</OPTION><OPTION value=10602002>江汉物探公司</OPTION><OPTION value=10602003>江苏物探公司</OPTION><OPTION value=10602004>河南物探公司</OPTION>"
				+"<OPTION value=10602005>中原物探公司</OPTION><OPTION value=10602006>南方物探公司</OPTION><OPTION value=10602007>第一物探公司</OPTION><OPTION value=10602008>西南二物</OPTION><OPTION value=10602009>中南五物</OPTION><OPTION value=10602010>东北物探公司</OPTION><OPTION value=10602011>华北物探公司</OPTION>"
				+"<OPTION value=10602012>华东物探公司</OPTION><OPTION value=10602013>西北物探公司</OPTION></SELECT>";
		}else if("10603"==ob.value){
			document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION selected value=10603001>中海油物探公司</OPTION></SELECT>";
		}else if("10604"==ob.value){
			document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION value=10604001>延长石油集团油气勘探公司</OPTION></SELECT>";
		}else if("10605"==ob.value){
			document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION selected value=>请选择</OPTION><OPTION value=10605001>CGGVeritas </OPTION><OPTION value=10605002>Schlumberger</OPTION><OPTION value=10605003>PGS</OPTION><OPTION value=10605004>TGS</OPTION><OPTION value=10605005>Geokinetics</OPTION>"
				+"<OPTION value=10605006>Fugro</OPTION><OPTION value=10605007>SeaBird</OPTION><OPTION value=10605008>Global</OPTION></SELECT>";
			}else if("10606"==ob.value){
				document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION value=10606001>其他物探公司</OPTION></SELECT>";
			}
	}
	
	
	
function cancel()
{
	window.location="<%=contextPath%>/market/MarketManagePageList.jsp";
}

function save(){
	if(checkText()){
		return;
	};
	document.getElementById("editor_id").value=editor.html();
	document.getElementById("form1").submit();
	
}

function getEditorContents(editor){
    var oEditor = FCKeditorAPI.GetInstance(editor);
	return oEditor.GetXHTML(true);
}

function checkText(){
	var infomation_name=document.getElementById("infomation_name").value;
	var release_date=document.getElementById("release_date").value;
	var two=document.getElementsByName("two_type_id");
	var three=document.getElementsByName("three_type_id");
	var abstract123=document.getElementById("abstract").value;
	var comm = document.getElementById("comm").value;
	var twoCount=0;
	var threeCount=0;
	
	if(infomation_name==""){
		alert("标题不能为空，请填写！");
		return true;
	}
	if(release_date==""){
		alert("发布日期不能为空，请选择！");
		return true;
	}
	if(comm==""){
		alert("请选择分公司！");
		return true;
	}
	for(var i=0; i<two.length;i++){
		if(two[i].checked==true){
			twoCount= twoCount+1;
		}
	}
	if(twoCount!=1){
		alert("一级分类不能为空，请填写！");
		return true;
	}
	
	for(var i=0; i<three.length;i++){
		if(three[i].checked==true){
			threeCount=threeCount+1;
		}
	}
	if(threeCount!=1){
		alert("二级分类不能为空，请填写！");
		return true;
	}
	return false;
}


</script>
</html>
