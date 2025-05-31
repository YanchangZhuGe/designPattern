<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String today = format.format(new Date());
    
    String dailyNo = request.getParameter("id");
    
    String action = request.getParameter("action");

%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>油公司动态</title>
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
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/addYtgs.srq">
<table border="0" cellpadding="0" cellspacing="0" class="form_info">
	 <input name="infomation_id" type="hidden" value=""/>
	<tr class="odd">
	  	<td class="inquire_item"><font color=red>*</font>&nbsp;标题：</td>
	    <td class="inquire_form">
	    	<input type="text" name="infomation_name" id="infomation_name" value="" class="input_width"/>	    
	    </td>
	    <td class="inquire_item"><font color=red>*</font>&nbsp;发布日期：</td>
    	<td class="inquire_form"><input type="text" id="release_date" class="input_width"  name="release_date" value="<%=today %>" readonly>
      &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16"  style="cursor:hand;" onMouseOver="dateSelector(release_date,tributton2);"/></td>
    </tr>    
    
    <tr class="odd">
    <td class="inquire_item"><font color=red>*</font>&nbsp;一级分类：</td>
    	<td class="inquire_form">
    	<%
    	String sql = "select t.code,t.code_name from bgp_infomation_type_info t where t.father_code='105' order by t.code";
		List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
		for(int i= 0;i<list.size();i++){
			Map map=(Map)list.get(i);
			String code = (String)map.get("code");
			String codeName = (String)map.get("codeName");
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
    	<td class="inquire_form"  colspan="3">
    	<%
    	String sql2 = "select t.code,t.code_name from bgp_infomation_type_info t where t.father_code='10801' order by t.code";
		List list2 = BeanFactory.getQueryJdbcDAO().queryRecords(sql2);
		for(int i= 0;i<list2.size();i++){
			Map map2=(Map)list2.get(i);
			String code2 = (String)map2.get("code");
			String codeName2 = (String)map2.get("codeName");
			if(code2.equals("10801001")||code2.equals("10801002")){
			%>
			<input type="radio" name="three_type_id" id="three_type_id" value="<%=code2 %>"><%=codeName2 %>
		<%	
			}
			}
		%>
      </td>
    </tr>
    
    <tr class="odd">
	  	<td class="inquire_item">&nbsp;摘要：</td>
	    <td class="inquire_form"  colspan="3">
	    	<input type="text" name="abstract" id="abstract" value="" class="input_width"/>	    
	    </td>
	</tr>
    
    <tr class="odd">
	  	<td class="inquire_item">&nbsp;内容：</td>
	    <td colspan="3"  class="inquire_form">
         <textarea id="editor_id" name="content" style="width:95%;height:500px;">
	    </textarea>
	    </td>
	</tr>
	
	   <tr class="odd">
        <td class="inquire_item">附件：</td>
        <td  colspan="3"  class="inquire_form" height="28px;">
          <label>
            <script type="text/javascript">ocUpload.init(6);</script>
          </label>
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

function changeType(ob){
	if("10501"==ob.value){
		document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION selected value=>请选择</OPTION><OPTION value=10501001>勘探与生产分公司</OPTION><OPTION value=10501002>大庆油田分公司</OPTION><OPTION value=10501003>辽河油田分公司</OPTION><OPTION value=10501004>吉林油田分公司</OPTION>"
			+"<OPTION value=10501005>冀东油田分公司</OPTION><OPTION value=10501006>大港油田分公司</OPTION><OPTION value=10501007>华北油田分公司</OPTION><OPTION value=10501008>长庆油田分公司</OPTION><OPTION value=10501009>塔里木油田分公司</OPTION><OPTION value=10501010>新疆油田分公司</OPTION><OPTION value=10501011>吐哈油田分公司</OPTION>"
			+"<OPTION value=10501012>青海油田分公司</OPTION><OPTION value=10501013>玉门油田分公司</OPTION><OPTION value=10501014>西南油气田分公司</OPTION><OPTION value=10501015>浙江油田分公司</OPTION><OPTION value=10501016>南方石油勘探公司</OPTION><OPTION value=10501017>煤层气公司</OPTION><OPTION value=10501018>西气东输管道公司</OPTION></SELECT>";
	}else if("10502"==ob.value){
		document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION selected value=>请选择</OPTION><OPTION value=10502001>胜利油田分公司</OPTION><OPTION value=10502002>中原油田分公司</OPTION><OPTION value=10502003>河南油田分公司</OPTION><OPTION value=10502004>江汉油田分公司</OPTION>"
			+"<OPTION value=10502005>江苏油田分公司</OPTION><OPTION value=10502006>西北油田分公司</OPTION><OPTION value=10502007>上海海洋石油分公司</OPTION><OPTION value=10502008>西南分公司</OPTION><OPTION value=10502009>东北分公司</OPTION><OPTION value=10502010>华北分公司</OPTION><OPTION value=10502011>华东分公司</OPTION>"
			+"<OPTION value=10502012>中南分公司</OPTION><OPTION value=10502013>天然气分公司</OPTION><OPTION value=10502014>东北勘探新区项目部</OPTION><OPTION value=10502015>勘探分公司</OPTION><OPTION value=10502016>勘探南方分公司</OPTION><OPTION value=10502017>石油物探技术研究院</OPTION></SELECT>";
	}else if("10503"==ob.value){
		document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION selected value=>请选择</OPTION><OPTION value=10503001>中国海洋石油有限公司</OPTION><OPTION value=10503002>上海分公司</OPTION><OPTION value=10503003>深圳分公司</OPTION><OPTION value=10503004>天津分公司</OPTION>"
			+"<OPTION value=10503005>湛江分公司</OPTION></SELECT>";
	}else if("10504"==ob.value){
		document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION value=10504001>延长石油集团油气勘探公司</OPTION></SELECT>";
	}else if("10505"==ob.value){
		document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION selected value=>请选择</OPTION><OPTION value=10505001>壳牌石油公司</OPTION><OPTION value=10505002>道达尔石油公司</OPTION><OPTION value=10505003>英国石油公司</OPTION><OPTION value=10505004>埃尼石油公司</OPTION>"
			+"<OPTION value=10505005>雷普索尔石油公司</OPTION><OPTION value=10505006>康菲石油公司</OPTION><OPTION value=10505007>美孚石油公司</OPTION><OPTION value=10505008>雪佛龙石油公司</OPTION><OPTION value=10505009>沙特国家石油公司</OPTION><OPTION value=10505010>阿尔及利亚国家石油公司</OPTION><OPTION value=10505011>利比亚国家石油公司</OPTION>"
			+"<OPTION value=10505012>墨西哥国家石油公司</OPTION><OPTION value=10505013>厄瓜多尔国家石油公司</OPTION><OPTION value=10505014>委内瑞拉国家石油公司</OPTION><OPTION value=10505015>伊朗国家石油公司</OPTION><OPTION value=10505016>尼日利亚国家石油公司</OPTION><OPTION value=10505017>安哥拉国家石油公司</OPTION></SELECT>";
	}else if("10506"==ob.value){
		document.getElementById("comm").parentNode.innerHTML="<SELECT id=comm name=comm class=select_width><OPTION selected value=>请选择</OPTION><OPTION value=10506001>淮南煤矿</OPTION><OPTION value=10506002>中联煤</OPTION><OPTION value=10506003>中澳煤层气</OPTION></SELECT>";
	}
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
function cancel()
{
	window.location="<%=contextPath%>/market/markertYtgsPage/MarketYtgsPageList.jsp";
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
	for(var i=0; i<two.length;i++){
		if(two[i].checked==true){
			twoCount= twoCount+1;
		}
	}
	if(twoCount!=1){
		alert("一级分类不能为空，请填写！");
		return true;
	}
	if(comm==""){
		alert("请选择分公司！");
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
