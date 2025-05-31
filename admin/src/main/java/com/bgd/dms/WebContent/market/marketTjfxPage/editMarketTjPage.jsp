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
    
    String twoType = (String)map.get("twoTypeId");
    String twoTypeStr = twoType.substring(0,5);
    System.out.println(">>>>>>>>>>>>"+twoType);
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>统计分析</title>
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
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/updateTj.srq">
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
    	<td class="inquire_form"  colspan="3">
    	<% 
    		String sql = "select t.code,t.code_name from bgp_infomation_type_info t where t.father_code='102' order by t.code";
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
      
    </tr>   
    <tr class="odd">
	   <td class="inquire_item"><font color=red>*</font>&nbsp;二级分类：</td>
    	<td class="inquire_form" colspan="3">
    	<div id="three_type_id" style="display:block;">
    	</div> 
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
    	<input name="Submit" type="button" class="iButton2"  onClick="cancel();" value="返回" />
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

	var two = document.getElementsByName("two_type_id");
	for(var i=0; i<two.length; i++){
		if(two[i].value==<%=twoTypeStr %>){
			if(two[i].checked="checked"){
				changeType(two[i]);
			}
		}
	}
	
	var three = document.getElementsByName("three_type_id");
	for(var i=0; i<three.length; i++){
		if(three[i].value==<%=twoType %>){
			three[i].checked="checked";
		}
	}
		



function changeType(ob){
	if("10201"==ob.value){
		document.getElementById("three_type_id").innerHTML="";
	}else if("10202"==ob.value){
		document.getElementById("three_type_id").innerHTML="";
	}else if("10203"==ob.value){
		document.getElementById("three_type_id").innerHTML="<input type=radio id=three_type_id name=three_type_id value=10203001>市场周报<input type=radio id=three_type_id name=three_type_id value=10203003>市场月报<input type=radio id=three_type_id name=three_type_id value=10203005>市场季报<input type=radio id=three_type_id name=three_type_id value=10203002>油气市场一周综述<input type=radio id=three_type_id name=three_type_id value=10203004>市场动态月度专报<input type=radio id=three_type_id name=three_type_id value=10203006>油气勘探综合信息";
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


function cancel()
{
	window.location="<%=contextPath%>/market/marketTjfxPage/MarketTjPageList.jsp";
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
