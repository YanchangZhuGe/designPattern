<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String userOrgId = user == null || user.getOrgId() == null ? "" : user.getOrgId().trim();
	String subOrgId = user.getSubOrgIDofAffordOrg();
	String wx_ids=request.getParameter("selectWzId");
	String projectInfoNo=user.getProjectInfoNo();
	//保存结果 1 保存成功
		ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
		String info = null;
		if(respMsg!=null&&respMsg.getValue("info") != null){
			info = respMsg.getValue("info");
		}
		
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title></title>
<style type="text/css">
#new_table_box_bg_new {
width:auto;
height:200px;
border:1px #aebccb solid;
background:#f1f2f3;
padding:10px;
overflow:auto;
}
#new_table_box_bg_new_next{
width:auto;
height:400px;
border:1px #aebccb solid;
background:#f1f2f3;
padding:10px;
overflow:auto;
}
#new_table_box {
width:auto;
height:670px;
}
</style>
</head>
<body class="bgColor_f3f3f3" onload="load()">
<form name="form1" id="form1" method="post"
	action="">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png"
						width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png"><table
							width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">物资名称</td>
								<td class="ali_cdn_input"><input id="s_wz_name"
									name="s_wz_name" type="text" /></td>
								<td class="ali_query"><span class="cx"><a href="#"
										onclick="searchDevData()" title="查询"></a></span> 
								<td class="ali_query"><span class="qc"><a href="#"
										onclick="clearQueryText()" title="清除"></a></span></td>
								<td>&nbsp;</td>
							</tr>
						</table></td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png"
						width="4" height="36" /></td>
				</tr>
			</table>
		</div>
	<input type='hidden' name='selectWzId' id='selectWzId'/>
	<div id="new_table_box" style="width: 100%">
		<div id="new_table_box_content" style="width: 100%">
		
		<div id="new_table_box_bg_new" style="width: 95%">
				<fieldset style="margin-left: 2px">
					<legend>已选择消耗备件</legend>
					<div style="height: 50%; overflow: auto">
						<table width="97%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height" >
							<tr>
						  <td class="bt_info_odd"  style="width:1%"><input type='checkbox' id='hirechecked' name='hirechecked' /></td>
						 
					<td class="bt_info_odd" style="width:7.5%">物资编号</td>
					<td class="bt_info_odd" style="width:7.5%">序列号</td>
					<td class="bt_info_even" style="width:7.5%">物资名称</td>
					<td class="bt_info_even" style="width:7.5%">计量单位</td>
					<td class="bt_info_even" style="width:7.5%">实际价格</td>
					<td class="bt_info_even" style="width:7.5%">库存数量</td>
					<td class="bt_info_even" style="width:7.5%">消耗数量</td>
					<td class="bt_info_even" style="width:7.5%">备件类别</td>
					<td class="bt_info_even" style="width:7.5%"></td>
							</tr>
							<tbody id="processtable0" name="processtable0">
							</tbody>
						</table>
					</div>
				</fieldset>


			</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
			
			
			<div id="new_table_box_bg_new_next" style="width: 95%">
				<fieldset style="margin-left: 2px">
					<legend>消耗备件选择</legend>
					<div style="height: 100%; overflow: auto">
						<table width="97%" border="1" cellspacing="0" cellpadding="0"
							class="tab_line_height" >
							<tr  >
						  <td class="bt_info_odd"  style="width:1%;border: 0px"><input type='checkbox' id='hirechecked' name='hirechecked' /></td>
					 <td  align="center" class="bt_info_even">序号</td>
					<td class="bt_info_odd" style="width:10%">物资编号</td>
					<td class="bt_info_odd" style="width:10%">序列号</td>
					<td class="bt_info_even" style="width:10%">物资名称</td>
					<td class="bt_info_even" style="width:10%">计量单位</td>
					<td class="bt_info_even" style="width:10%">实际价格</td>
					<td class="bt_info_even" style="width:10%">库存数量</td>
					<td class="bt_info_even" style="width:5%">排序号</td>
					
					<!--<td  class="bt_info_even" style="width:7.5%">消耗数量</td>
					<td class="bt_info_even" style="width:7.5%">备件类别</td>  -->
							</tr>
							<tbody id="processtable1" name="processtable1">
							</tbody>
						</table>
					</div>
				</fieldset>


			</div>
			
		</div>
	</div>
	</form>

</body>
<script type="text/javascript">
	function frameSize() {
		//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
		setTabBoxHeight();
	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	});
	$(document).ready(lashen);
</script>
<script type="text/javascript">
function searchDevData(){
	queryData();
}
function queryData()
{
	$("#processtable1").html("");
	var baseData;
	var wz_name=$("#s_wz_name").val();
	 baseData = jcdpCallService("DevInsSrv", "getwxbyMatInfo", "wz_name="+wz_name);
			if(baseData.datas!=null)
			{
				//通过查询结果动态填充使用情况select;
				var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000188' and bsflag='0'";
				var queryRet = syncRequest('Post','/gms4'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
				usingdatas = queryRet.datas;
				for (var tr_id = 0; tr_id< baseData.datas.length; tr_id++) {
					var matId=baseData.datas[tr_id].wz_id+"";
					var innerhtml2 = "<tr   id='tr2"+tr_id+"' name='tr2"+tr_id+"' seq='"+tr_id+"'>";
					innerhtml2 += "<input name='bj_id2"+tr_id+"' id='bj_id2"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml2 += "<input name='stock_num2"+tr_id+"' id='stock_num2"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml2 += "<input name='usemat_id2"+tr_id+"' id='usemat_id2"+tr_id+"' value='<%=wx_ids%>' size='16'  type='hidden' />";
					innerhtml2 += "<input name='wz_id2"+tr_id+"' id='wz_id2"+tr_id+"' value='"+baseData.datas[tr_id].wz_id+"' size='16'  type='hidden' />";
					innerhtml2 += "<input name='wxbymat_id2"+tr_id+"' id='wxbymat_id2"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml2 += "<td><input type='checkbox' name='idinfo2' id='cb"+tr_id+"' value=''  onclick='changeColor("+tr_id+")'/></td>";
					innerhtml2 += "<td  align='center' width='3%'>"+(tr_id+1)+"</td>";
					innerhtml2 += "<td>"+baseData.datas[tr_id].wz_id+"</td>";
					innerhtml2 += "<td>"+baseData.datas[tr_id].wz_sequence+"</td>";
					innerhtml2 += "<td>"+baseData.datas[tr_id].wz_name+"</td>";
					innerhtml2 += "<td>"+baseData.datas[tr_id].wz_prickie+"</td>";
					innerhtml2 += "<td>"+baseData.datas[tr_id].actual_price+"</td>";
					innerhtml2 += "<td>-</td>";
					innerhtml2 += "<td><input matId='"+matId+"' name='postion2"+tr_id+"' id='postion2"+tr_id+"' value='"+baseData.datas[tr_id].postion+"' size='16' onblur='wzOrder("+tr_id+","+baseData.datas[tr_id].wz_id+")'/></td>";
					//innerhtml2 += "<td><input name='use_num2"+tr_id+"' id='use_num2"+tr_id+"' value='1' size='16' onblur='checkUse_num("+tr_id+")'/></td>";
					//innerhtml2 += "<td><select name='coding_code_id2"+tr_id+"' id='coding_code_id2"+tr_id+"'><option selected> 请选择</option></select></td>";
					$("#processtable1").append(innerhtml2);
					//if(usingdatas != null){
						//var optionhtml = "";
						
						//for (var i = 0; i< usingdatas.length; i++) {
						//	optionhtml +=  "<option  name='wxlb' id='wxlb"+i+"' value='"+usingdatas[i].coding_code_id+"'>"+usingdatas[i].coding_name+"</option>";
						//}
						//$("#coding_code_id2"+tr_id).append(optionhtml);
					//}
					}
				$("#processtable1>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable1>tr:odd>td:even").addClass("odd_even");
				$("#processtable1>tr:even>td:odd").addClass("even_odd");
				$("#processtable1>tr:even>td:even").addClass("even_even");
				}
	
}
function clearQueryText(){
	document.getElementById("s_wz_name").value="";
}
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});
function submitInfo()
{
	debugger;
	//保留的行信息
	var count = 0;
	var line_infos;
	$("input[type='checkbox'][name='idinfo']").each(function(){
		if(this.checked){
			if(count == 0){
				line_infos = this.id;
			}else{
				line_infos += "~"+this.id;
			}
			count++;
		}
	});
	if(count == 0){
		alert('请选择维修备件！');
		return;
	}
	var selectedlines = line_infos.split("~");
	var wronglineinfos = "";
	for(var index=0;index<selectedlines.length;index++){
		var use_num = $("#use_num"+selectedlines[index]).val();
		var coding_code_id = $("#coding_code_id"+selectedlines[index]).val();
		if(use_num == "" || coding_code_id == "请选择" ){
			if(index == 0){
				wronglineinfos += (parseInt(selectedlines[index])+1);
			}else{
				wronglineinfos += ","+(parseInt(selectedlines[index])+1);
			}
		}
	}
	if(wronglineinfos!=""){
		alert("请选择物资类别!");
		return;
	}
	
	$("input[type='checkbox'][name='idinfo']").each(function(){
		if(this.checked){
			
			var  use_num=document.getElementById("use_num"+this.id).value;
			var  coding_code_id=document.getElementById("coding_code_id"+this.id).value;
			var wz_id=document.getElementById("wz_id"+this.id).value;
			var usemat_id=document.getElementById("usemat_id"+this.id).value;
			  var submitStr = "use_num="+use_num+"&coding_code_id="+coding_code_id+"&wz_id="+wz_id+"&usemat_id="+usemat_id;
			  retObject = jcdpCallService("DevInsSrv","savewxbyMat",submitStr);
		}
	});
	 window.returnValue = "true";
	newClose();
	//document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveBywxMatInfo.srq?count="+count+"&line_infos="+line_infos;
	//document.getElementById("form1").submit();
	//  window.returnValue = 'true';
	  //window.close();
}

var checked = false;
	function check(){
	var chk = document.getElementsByName("rdo_entity_id");
	for(var i = 0; i < chk.length; i++){ 
		if(!checked){ 
			chk[i].checked = true; 
		}
		else{
			chk[i].checked = false;
		}
	} 
	if(checked){
		checked = false;
	}
	else{
		checked = true;
	}
}
	
	function changeColor(tr_id){
		//$("#"+trId).parent().parent().find("tr").css('background-color','yellow');
		//$("#tr"+tr_id).show();
		if($("#cb"+tr_id).attr("checked")=='checked'){
			var wz_id=$("#tr2"+tr_id).find("input[name^='wz_id'][type='hidden']").val();
			$("#"+wz_id).show();
		  var checkId=$("#"+wz_id).attr("seq");
		  $("#"+checkId).attr("checked","checked");
		}
		
		
	}
	function deleteTr(btn){
		
		var wz_id=$(btn).attr("id").split("~")[1];
		var tr_id=$(btn).attr("seq");
		
		var ll="#"+tr_id;
		$(ll).attr("checked",false);
		$("#"+wz_id).hide();
	}
	function load()
	{
		$("#processtable0").html("");
		var baseData;
		var wz_name=$("#s_wz_name").val();
		 baseData = jcdpCallService("DevInsSrv", "getwxbyMatInfo", "wz_name="+wz_name);
				if(baseData.datas!=null)
				{
					//通过查询结果动态填充使用情况select;
					var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000188' and bsflag='0'";
					var queryRet = syncRequest('Post','/gms4'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
					usingdatas = queryRet.datas;
					for (var tr_id = 0; tr_id< baseData.datas.length; tr_id++) {
						var matId=baseData.datas[tr_id].wz_id+"";
						var innerhtml = "<tr  style='display:none' id='"+baseData.datas[tr_id].wz_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
						innerhtml += "<input name='bj_id"+tr_id+"' id='bj_id"+tr_id+"' value='' size='16'  type='hidden' />";
						innerhtml += "<input name='stock_num"+tr_id+"' id='stock_num"+tr_id+"' value='' size='16'  type='hidden' />";
						innerhtml += "<input name='usemat_id"+tr_id+"' id='usemat_id"+tr_id+"' value='<%=wx_ids%>' size='16'  type='hidden' />";
						innerhtml += "<input name='wz_id"+tr_id+"' id='wz_id"+tr_id+"' value='"+baseData.datas[tr_id].wz_id+"' size='16'  type='hidden' />";
						innerhtml += "<input name='wxbymat_id"+tr_id+"' id='wxbymat_id"+tr_id+"' value='' size='16'  type='hidden' />";
						innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' value=''  onclick='changeColor("+tr_id+")'/></td>";
						innerhtml += "<td>"+baseData.datas[tr_id].wz_id+"</td>";
						innerhtml += "<td>"+baseData.datas[tr_id].wz_sequence+"</td>";
						innerhtml += "<td>"+baseData.datas[tr_id].wz_name+"</td>";
						innerhtml += "<td>"+baseData.datas[tr_id].wz_prickie+"</td>";
						innerhtml += "<td>"+baseData.datas[tr_id].actual_price+"</td>";
						innerhtml += "<td>-</td>";
						innerhtml += "<td><input name='use_num"+tr_id+"' id='use_num"+tr_id+"' value='1' size='16' onblur='checkUse_num("+tr_id+")'/></td>";
						innerhtml += "<td><select name='coding_code_id"+tr_id+"' id='coding_code_id"+tr_id+"'><option selected>请选择</option></select></td>";
						innerhtml += "<td><input type='button' seq='"+tr_id+"' id='del~"+baseData.datas[tr_id].wz_id+"' value ='删除' onclick='deleteTr(this)' /></td>";
						
						
						
						
						
						var innerhtml2 = "<tr   id='tr2"+tr_id+"' name='tr2"+tr_id+"' seq='"+tr_id+"'>";
						innerhtml2 += "<input name='bj_id2"+tr_id+"' id='bj_id2"+tr_id+"' value='' size='16'  type='hidden' />";
						innerhtml2 += "<input name='stock_num2"+tr_id+"' id='stock_num2"+tr_id+"' value='' size='16'  type='hidden' />";
						innerhtml2 += "<input name='usemat_id2"+tr_id+"' id='usemat_id2"+tr_id+"' value='<%=wx_ids%>' size='16'  type='hidden' />";
						innerhtml2 += "<input name='wz_id2"+tr_id+"' id='wz_id2"+tr_id+"' value='"+baseData.datas[tr_id].wz_id+"' size='16'  type='hidden' />";
						innerhtml2 += "<input name='wxbymat_id2"+tr_id+"' id='wxbymat_id2"+tr_id+"' value='' size='16'  type='hidden' />";
						innerhtml2 += "<td  align='center'><input type='checkbox' name='idinfo2' id='cb"+tr_id+"' value=''  onclick='changeColor("+tr_id+")'/></td>";
						innerhtml2 += "<td  width='2%'>"+(tr_id+1)+"</td>";
						innerhtml2 += "<td  align='center'>"+baseData.datas[tr_id].wz_id+"</td>";
						innerhtml2 += "<td  align='center'>"+baseData.datas[tr_id].wz_sequence+"</td>";
						innerhtml2 += "<td  align='center'>"+baseData.datas[tr_id].wz_name+"</td>";
						innerhtml2 += "<td  align='center'>"+baseData.datas[tr_id].wz_prickie+"</td>";
						innerhtml2 += "<td align='center'>"+baseData.datas[tr_id].actual_price+"</td>";
						innerhtml2 += "<td  align='center'>-</td>";
						innerhtml2 += "<td><input  matId='"+matId+"'   name='postion2"+tr_id+"' id='postion2"+tr_id+"' value='"+baseData.datas[tr_id].postion+"' size='16' onblur='wzOrder("+tr_id+","+baseData.datas[tr_id].wz_id+")'/></td>";
						//innerhtml2 += "<td><input name='use_num2"+tr_id+"' id='use_num2"+tr_id+"' value='1' size='16' onblur='checkUse_num("+tr_id+")'/></td>";
						//innerhtml2 += "<td><select name='coding_code_id2"+tr_id+"' id='coding_code_id2"+tr_id+"'><option selected> 请选择</option></select></td>";
						
						
						
						$("#processtable0").append(innerhtml);
						$("#processtable1").append(innerhtml2);
						if(usingdatas != null){
							var optionhtml = "";
							
							for (var i = 0; i< usingdatas.length; i++) {
								optionhtml +=  "<option  name='wxlb' id='wxlb"+i+"' value='"+usingdatas[i].coding_code_id+"'>"+usingdatas[i].coding_name+"</option>";
							}
							
							$("#coding_code_id"+tr_id).append(optionhtml);
							//$("#coding_code_id2"+tr_id).append(optionhtml);
						}
						}
					$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
					$("#processtable0>tr:odd>td:even").addClass("odd_even");
					$("#processtable0>tr:even>td:odd").addClass("even_odd");
					$("#processtable0>tr:even>td:even").addClass("even_even");
					}
		
	}


function newClose(){
	  window.close();
}
function checkUse_num(tr_id)
{
var use_num=document.getElementById("use_num"+tr_id).value;
	//只能输入数字
	 var re =/^[0-9]{0}([0-9]|[.])+$/;  
	 if(use_num.length>0)
		 {
   if (!re.test(use_num))   
  	{   
       alert("请输入数字!");   
       document.getElementById("use_num"+tr_id).value="";
       document.getElementById("use_num"+tr_id).focus();   
      return false;   
  	 }
   document.getElementById(tr_id).checked=true;
	 }
}

function  wzOrder(tr_id,wz_id){
	
	var project_info_id='<%=projectInfoNo%>';
	var orderNo=document.getElementById("postion2"+tr_id).value;
	wz_id=$("#postion2"+tr_id).attr("matId");
	 var re =/^[0-9]{0}([0-9]|[.])+$/;  
	 if(orderNo.length>0){
		 if (!re.test(orderNo))   
		  	{   
		       alert("请输入数字!");   
		       document.getElementById("postion2"+tr_id).value="";
		       document.getElementById("postion2"+tr_id).focus();   
		    
		  	 } else{
		  		jcdpCallService("DevInsSrv", "zyWzOrder", "project_info_id="+project_info_id+"&wz_id="+wz_id+"&postion="+orderNo);
		  		queryData();
		  	 }
	 }
	
	
}
</script>
</html>