<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
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
	String gz_bj_id=request.getParameter("gz_bj_id");
	String bywx_type=request.getParameter("bywx_type");//保养维修类型 2 保养
	String self_num = request.getParameter("self_num");//自编号
	String projectInfoNo=user.getProjectInfoNo();
	//保存结果 1 保存成功
		ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
		String info = null;
		if(respMsg!=null&&respMsg.getValue("info") != null){
			info = respMsg.getValue("info");
		}
	String bjlb_id = request.getParameter("bjlb_id");//备件类别
		
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
	<input type='hidden' name='selectWzId' id='selectWzId'/>
	<div id="new_table_box" style="width: 100%">
		<div id="new_table_box_content" style="width: 100%">
		
		<div id="new_table_box_bg_new" style="width: 95%">
		<div style="overflow: auto">
						<table width="97%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr align="right">
								<td style="width: 90%"></td>
								<auth:ListButton id="zj0" functionId="" css="zj"
									event="onclick='toAddzy()'" title="选择备件"></auth:ListButton>
							</tr>
						</table>
					</div>
				<fieldset style="margin-left: 2px">
					<legend>已选择消耗备件</legend>
					<div style="height: 50%; overflow: auto">
						<table width="97%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height" >
							<tr>
						  <td class="bt_info_odd"  style="width:1%"><input type='checkbox' id='hirechecked' name='hirechecked' /></td>
						 
					<td class="bt_info_odd" style="width:12.5%">物资编号</td>
					<!-- <td class="bt_info_odd" style="width:12.5%">序列号</td> -->
					<td class="bt_info_even" style="width:12.5%">物资名称</td>
					<td class="bt_info_even" style="width:12.5%">计量单位</td>
					<td class="bt_info_even" style="width:12.5%">实际价格</td>
					<td class="bt_info_even" style="width:12.5%">库存数量</td>
					<td class="bt_info_even" style="width:12.5%">消耗数量</td>
					<td class="bt_info_even" style="width:12.5%" id='zcjlb_td'>总成件类别</td>
					<!-- <td class="bt_info_even" style="width:12.5%" id='zcjxh_td'>总成件型号</td> -->
					<td class="bt_info_odd" style="width:12.5%" id='xlh_td'>系列号</td><!--520系列号-->
					<td class="bt_info_even" style="width:12.5%"></td>
							</tr>
							<tbody id="processtable0" name="processtable0">
							</tbody>
						</table>
					</div>
				</fieldset>
			</div>
			<div id="oper_div">
				<span class="bc_btn"><a href="#" onclick="submitInfo()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
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
var bywx_type = '<%=bywx_type%>';
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});
function submitInfo()
{
	var bjlb_id = '<%=bjlb_id%>';//备件类别默认从故障大类中得到
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
		if(bywx_type=="2"){//维修
			var zcj_code_id = $("#zcj_code_id"+selectedlines[index]).val();
		}
		if(use_num == ""){
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
			//需要设备自编号
			var self_num = '<%=self_num%>';
			var bywx_type = '<%=bywx_type%>';
			var  use_num=document.getElementById("use_num"+this.id).value;
			var  zcj_code_id="";
			var  zcj_model_id="";
			if(bywx_type=="2"){//维修
				zcj_code_id=document.getElementById("zcj_code_id"+this.id).value;//总成件id
				//zcj_model_id=document.getElementById("zcj_model_id"+this.id).value;//总成件型号id
			}
			var wxbymat_id=document.getElementById("wxbymat_id"+this.id).value;
			var wz_id=document.getElementById("wz_id"+this.id).value;
			var usemat_id=document.getElementById("usemat_id"+this.id).value;
			var wz_sequences=document.getElementById("wz_sequences"+this.id).value;//520系列号
			var gz_bj_id=document.getElementById("gz_bj_id"+this.id).value;//故障关联备件id
			var submitStr = "wxbymat_id="+wxbymat_id+"&use_num="+use_num+"&coding_code_id="+bjlb_id+"&zcj_code_id="+zcj_code_id+"&wz_id="+wz_id+"&usemat_id="+usemat_id+"&bywx_type="+bywx_type+"&self_num="+self_num+"&wz_sequences="+wz_sequences+"&gz_bj_id="+gz_bj_id;
			retObject = jcdpCallService("DevInsSrv","savewxbyMat",submitStr);
			//如果系列号不为空并且总成件类型不为空则更换设备总成件型号
			if(zcj_code_id!=""){
				var arrStr = "self_num="+self_num+"&wz_sequences="+wz_sequences+"&zcj_code_id="+zcj_code_id;
				jcdpCallService("DevZcjByItemSrv","updateZcjModelSeq",arrStr);
			}
		}
	});
	 window.returnValue = "true";
	newClose();
	<%-- document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveBywxMatInfo.srq?count="+count+"&line_infos="+line_infos; --%>
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
	function deleteTr(btn,i){
		var usemat_id=document.getElementById("usemat_id"+i).value;
		var wz_id=$(btn).attr("id").split("~")[1];
		if(confirm("是否执行删除操作?")){
			jcdpCallService("DevInsSrv", "deleteMatInfo", "usemat_id="+usemat_id+"&wz_id="+wz_id);
		}
		$('#tr'+wz_id,"#processtable0").remove();
	}
	function load()
	{
		var bywx_type = '<%=bywx_type%>';
		if(bywx_type=="2"){//维修
			//查询该备件有没有上次保养过，并确定本次是否需要跟换备件
			//需要设备自编号
			var self_num = '<%=self_num%>';
			var mybaseData = jcdpCallService("DevInsSrv", "findwxbyMat", "self_num="+self_num);
			var bybj = "";
			if(mybaseData.datas!=null){
			for (var num = 0; num < mybaseData.datas.length; num++) {
				if(num==mybaseData.datas.length-1){
					bybj+=mybaseData.datas[num].wz_name;
				}else{
					bybj+=mybaseData.datas[num].wz_name+",";
				}
			}
			alert("该设备此次有"+mybaseData.datas.length+"条备件需要更换,它们是："+bybj+"。请确认处理！！");
		  }
		}else{
			document.getElementById("xlh_td").style.display = "none";	
			document.getElementById("zcjlb_td").style.display = "none";
			/* document.getElementById("zcjxh_td").style.display = "none";	 */
		}
		var baseData;
		var wz_name=$("#s_wz_name").val();
		var gz_bj_id = '<%=gz_bj_id%>';//故障与备件关联的id
		 baseData = jcdpCallService("DevInsSrv", "getSelwxbyMatInfo", "wz_name="+wz_name+"&gz_bj_id="+gz_bj_id);
				if(baseData.datas!=null)
				{
					//通过查询结果动态填充使用情况select(改为总成件类别);
					var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000187' and bsflag='0' and coding_code_id not in('5110000187000000015','5110000187000000016','5110000187000000017') order by coding_code_id";
					var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
					usingdatas = queryRet.datas;
					for (var i = 0; i< baseData.datas.length; i++) {
						tr_id=$("#processtable0 tr").length;
						var matId=baseData.datas[tr_id].wz_id+"";
						var innerhtml = "<tr id='tr"+baseData.datas[i].wz_id+"' name='tr"+baseData.datas[i].wz_id+"' seq='"+tr_id+"'>";
						innerhtml += "<input name='bj_id"+tr_id+"' id='bj_id"+tr_id+"' value='' size='16'  type='hidden' />";
						innerhtml += "<input name='stock_num"+tr_id+"' id='stock_num"+tr_id+"' value='' size='16'  type='hidden' />";
						innerhtml += "<input name='usemat_id"+tr_id+"' id='usemat_id"+tr_id+"' value='<%=wx_ids%>' size='16'  type='hidden' />";
						innerhtml += "<input name='gz_bj_id"+tr_id+"' id='gz_bj_id"+tr_id+"' value='<%=gz_bj_id%>' size='16'  type='hidden' />";
						innerhtml += "<input name='wz_id"+tr_id+"' id='wz_id"+tr_id+"' value='"+baseData.datas[i].wz_id+"' size='16'  type='hidden' />";
						innerhtml += "<input name='wxbymat_id"+tr_id+"' id='wxbymat_id"+tr_id+"' value='"+baseData.datas[i].wxbymat_id+"' size='16'  type='hidden' />";
						innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' value=''  onclick='changeColor("+tr_id+")' checked/></td>";
						innerhtml += "<td>"+baseData.datas[i].wz_id+"</td>";
						/* innerhtml += "<td>"+baseData.datas[i].wz_sequence+"</td>"; */
						innerhtml += "<td>"+baseData.datas[i].wz_name+"</td>";
						innerhtml += "<td>"+baseData.datas[i].wz_prickie+"</td>";
						innerhtml += "<td>"+baseData.datas[i].actual_price+"</td>";
						innerhtml += "<td>-</td>";
						innerhtml += "<td><input name='use_num"+tr_id+"' id='use_num"+tr_id+"' value='1' size='16' onblur='checkUse_num("+tr_id+")'/></td>";
						if(bywx_type=="2"){//维修
							innerhtml += "<td><select name='zcj_code_id"+tr_id+"' id='zcj_code_id"+tr_id+"' onchange='changeZcj("+tr_id+")'><option selected>请选择</option></select></td>";
							//innerhtml += "<td><select name='zcj_model_id"+tr_id+"' id='zcj_model_id"+tr_id+"'></select></td>";
							innerhtml += "<td><input name='wz_sequences"+tr_id+"' id='wz_sequences"+tr_id+"' size='16' /></td>";//520系列号
						}else{
							innerhtml += "<input type='hidden' name='wz_sequences"+tr_id+"' id='wz_sequences"+tr_id+"' size='16'/>";//520系列号
						}
						innerhtml += "<td><input type='button' seq='"+tr_id+"' id='del~"+baseData.datas[i].wz_id+"' value ='删除' onclick='deleteTr(this,"+tr_id+")' /></td></tr>";
 						$("#processtable0").append(innerhtml);
 						if(bywx_type=="2"){//维修
	 						if(usingdatas != null){
								var optionhtml = "";
								
								for (var j = 0; j< usingdatas.length; j++) {
									if(usingdatas[j].coding_code_id==baseData.datas[i].zcj_code_id){
										optionhtml +=  "<option selected  value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
										//getZcjModel(usingdatas[j].coding_code_id,baseData.datas[i].zcj_model_id,tr_id);
									}else{
										optionhtml +=  "<option   value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
									}
								}
								
								$("#zcj_code_id"+tr_id).append(optionhtml);
								//$("#zcj_code_id2"+tr_id).append(optionhtml);
							}
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
/*检测系列号是否存在*/
function checkSeq(num){
	var zcj_code_id=document.getElementById("zcj_code_id"+num).value;
	var wz_sequences=document.getElementById("wz_sequences"+num).value;
	if(zcj_code_id==""){
		alert("请选择总成件类别");
		return ;
	}
	if(wz_sequences==""){
		alert("请输入系列号");
		return ;
	}
	baseData = jcdpCallService("DevZcjByItemSrv", "getZySeq",
			"wz_sequences=" + wz_sequences);
	if (baseData.data == null) {
		alert("请输入有效的系列号!");
		document.getElementById("wz_sequences" + num).value = "";
		//document.getElementById("wz_sequences" + num).focus();
		return false;
	}
}
function toAddzy(){
	var selectWzId = document.getElementById("selectWzId").value;
	var selected = window.showModalDialog("<%=contextPath%>/rm/dm/kkzy/mutiPorject/selectMatList-bx.jsp","","dialogWidth=1240px;dialogHeight=480px");
	var wz_id = selected;
	document.getElementById("selectWzId").value = wz_id;
	if(selected!=null&&selected!=""){
		refreshData('');
	}
}
//更新页面刷新时的显示列表
function refreshData(){
	var selectWzId = document.getElementById("selectWzId").value;
	var bywx_type = '<%=bywx_type%>';
	var baseData;
	baseData = jcdpCallService("DevInsSrv", "getwxbyMatInfoBywzid", "wz_id="+selectWzId);
	if(baseData.datas!=null){
		//通过查询结果动态填充使用情况select;
		var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000187' and bsflag='0' and coding_code_id not in('5110000187000000015','5110000187000000016','5110000187000000017') order by coding_code_id";
		var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		var usingdatas = queryRet.datas;
		for (var i = 0; i< baseData.datas.length; i++) {
			var matId=baseData.datas[i].wz_id+"";
			var tr_id=$("#processtable0 tr").length;
			var innerhtml = "<tr id='tr"+baseData.datas[i].wz_id+"' name='tr"+baseData.datas[i].wz_id+"' seq='"+tr_id+"'>";
			innerhtml += "<input name='bj_id"+tr_id+"' id='bj_id"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='stock_num"+tr_id+"' id='stock_num"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='usemat_id"+tr_id+"' id='usemat_id"+tr_id+"' value='<%=wx_ids%>' size='16'  type='hidden' />";
			innerhtml += "<input name='gz_bj_id"+tr_id+"' id='gz_bj_id"+tr_id+"' value='<%=gz_bj_id%>' size='16'  type='hidden' />";
			innerhtml += "<input name='wz_id"+tr_id+"' id='wz_id"+tr_id+"' value='"+baseData.datas[i].wz_id+"' size='16'  type='hidden' />";
			innerhtml += "<input name='wxbymat_id"+tr_id+"' id='wxbymat_id"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' value=''  onclick='changeColor("+tr_id+")' checked/></td>";
			innerhtml += "<td>"+baseData.datas[i].wz_id+"</td>";
			innerhtml += "<td>"+baseData.datas[i].wz_name+"</td>";
			innerhtml += "<td>"+baseData.datas[i].wz_prickie+"</td>";
			innerhtml += "<td>"+baseData.datas[i].wz_price+"</td>";
			innerhtml += "<td>-</td>";
			innerhtml += "<td><input name='use_num"+tr_id+"' id='use_num"+tr_id+"' value='1' size='16' onblur='checkUse_num("+tr_id+")'/></td>";
			if(bywx_type=="2"){//维修
				innerhtml += "<td><select name='zcj_code_id"+tr_id+"' id='zcj_code_id"+tr_id+"'  onchange='changeZcj("+tr_id+")'><option selected>请选择</option></select></td>";
				//innerhtml += "<td><select name='zcj_model_id"+tr_id+"' id='zcj_model_id"+tr_id+"'><option selected>请选择</option></select></td>";
				innerhtml += "<td><input name='wz_sequences"+tr_id+"' id='wz_sequences"+tr_id+"' size='16' /></td>";//520系列号
			}else{
				innerhtml += "<input type='hidden' name='wz_sequences"+tr_id+"' id='wz_sequences"+tr_id+"' size='16'/>";//520系列号
			}
			innerhtml += "<td><input type='button' seq='"+tr_id+"' id='del~"+baseData.datas[i].wz_id+"' value ='删除' onclick='deleteTr(this,"+tr_id+")' /></td></tr>";
			$("#processtable0").append(innerhtml);
			if(bywx_type=="2"){//维修
				if(usingdatas != null){
					var optionhtml = "";
					
					for (var j = 0; j< usingdatas.length; j++) {
						if(usingdatas[j].coding_code_id==baseData.datas[i].zcj_code_id){
							optionhtml +=  "<option selected  value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
						}else{
							optionhtml +=  "<option   value='"+usingdatas[j].coding_code_id+"'>"+usingdatas[j].coding_name+"</option>";
						}
					}
					
					$("#zcj_code_id"+tr_id).append(optionhtml);
					//$("#zcj_code_id2"+tr_id).append(optionhtml);
				}
			}
		}
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	}
}
function changeZcj(i){/* 
	$("#zcj_model_id"+i).empty();
	var zcj_code_id = "";
	zcj_code_id = $("#zcj_code_id"+i).val();
	if(zcj_code_id == ""){
		alert('故障大类不能为空！');
		var innerhtml =  "";
		$("#zcj_model_id"+i).empty();
		$("#zcj_model_id"+i).append(innerhtml);
		return;
	}
	usingdatas = jcdpCallService("DevZcjByItemSrv", "getZcjModel","zcj_id=" + zcj_code_id).datas;
	//var querySql="select t.zcj_model_id as falut_id,t.zcj_model_name as falut_name from gms_device_zy_zcj_model t where t.zcj_id = '"+zcj_code_id+"'";
	//var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql); 
	//usingdatas = queryRet.datas;
	if(usingdatas != null){
		var innerhtml =  "";
		for (var j = 0; j< usingdatas.length; j++) {
			innerhtml +=  "<option   value='"+usingdatas[j].zcj_model_id+"'>"+usingdatas[j].zcj_model_name+"</option>";
		}
		 $("#zcj_model_id"+i).append(innerhtml);  
		 if(usingdatas.length>0){
			 autoShowSelect("zcj_model_id"+i);
		 }
	} */
}
function autoShowSelect(id){
	document.getElementById(id).focus();
    var WshShell = new ActiveXObject("Wscript.Shell");
    try {
        WshShell.SendKeys("%{DOWN}");
    } catch(e){}         
    WshShell.Quit;
}
function getZcjModel(zcj_code_id,zcj_model_id,tr_id){/* 
	modeldatas = jcdpCallService("DevZcjByItemSrv", "getZcjModel","zcj_id=" + zcj_code_id).datas;
	if(modeldatas != null){
		var innerhtml =  "";
		for (var j = 0; j< modeldatas.length; j++) {
			if(modeldatas[j].zcj_model_id==zcj_model_id){
				innerhtml +=  "<option selected  value='"+modeldatas[j].zcj_model_id+"'>"+modeldatas[j].zcj_model_name+"</option>";
			}else{
				innerhtml +=  "<option   value='"+modeldatas[j].zcj_model_id+"'>"+modeldatas[j].zcj_model_name+"</option>";
			}
		}
		 $("#zcj_model_id"+tr_id).append(innerhtml);  
	} */
}
</script>
</html>