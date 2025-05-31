<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<style type="text/css">
.vilderrorcss{
	color:#ffffff;
	background-color:rgb(244,119,89);
	border-right:1px dashed #FF0000;
	border-top:1px dashed #FF0000;
	border-left:1px dashed #FF0000;
	border-bottom:1px dashed #FF0000;
}
</style>
<title>添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="ininData();">
<form name="form1" id="form1" method="post" action="">
<input name="id" id="id" type="hidden"/>
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >选项编号:</td>
          <td class="inquire_form4" >
          	<input name="dictkey" id="dictkey" class="input_width" type="text" onchange="validLen(this,300);"/>
          </td>
          <td class="inquire_item4" >选项名称:</td>
          <td class="inquire_form4" >
          	<input name="dictdesc" id="dictdesc" class="input_width" type="text" onchange="validLen(this,400);"/>
          </td>
        </tr>
      </table>
      </fieldSet>
	  <fieldSet style="margin-left:2px"><legend>选项信息</legend>
		  <div style="overflow:auto">
			  <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <span class="zj"><a href="#" id="addaddedbtn" onclick="toAddOpt();" title="添加"></a></span><span class="sc"><a href="#" id="deladdedbtn" onclick="toDelOpt();" title="删除"></a></span>
		       <tr>
					<td class="bt_info_even" width="10%">选择</td>
					<td class="bt_info_even" width="30%">选项编码</td>
					<td class="bt_info_odd" width="40%">选项名称</td>
					<td class="bt_info_even" width="20%">选项序号</td>
				</tr>
			   </table>
			<div style="height:120px;overflow:auto;">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="table-layout: auto">
				   	<tbody id="processtable" name="processtable" >
				   	</tbody>
	      		</table>
	      	</div>
	       </div>
      </fieldSet>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="submitInfo(0)"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
<script type="text/javascript">
function ininData(){
	var sql = "select * from gms_device_comm_dict t where t.id='${param.id}'";
	var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql);
	var retObj = unitRet.datas;
	debugger;
	$("#dictkey").val(retObj[0].dictkey);
	$("#dictdesc").val(retObj[0].dictdesc);
	$("#id").val(retObj[0].id);
	var sql1 = "select * from gms_device_comm_dict_item i where i.dict_id='${param.id}' order by i.displayorder";
	var unitRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql1+'&pageSize=1000');
	var i1 = unitRet1.datas;
	$.each(i1,function(i,k){
		var tr = $("<tr></tr>");
		var td0 = $("<td></td>").append($("<input name='chkbox' type='checkbox'/>"));
		var td1 = $("<td></td>").append($("<input name='optionvalue' value='"+k.optionvalue+"' onChange='validLen(this,300);'/>"));
		var td2 = $("<td></td>").append($("<input name='optiondesc' value='"+k.optiondesc+"' onChange='validLen(this,400);'/>"));
		var td3 = $("<td></td>").append($("<input name='displayorder' value='"+k.displayorder+"' onChange='validfun(this);'/>"));
		tr.append(td0).append(td1).append(td2).append(td3);
		$("#processtable").append(tr);
	});
	$("#processtable>tr:odd>td:odd").addClass("odd_odd");
	$("#processtable>tr:odd>td:even").addClass("odd_even");
	$("#processtable>tr:even>td:odd").addClass("even_odd");
	$("#processtable>tr:even>td:even").addClass("even_even");
}
function toAddOpt(){
	var tr = $("<tr></tr>");
	var td0 = $("<td></td>").append($("<input name='chkbox' type='checkbox'/>"));
	var td1 = $("<td></td>").append($("<input name='optionvalue' value='' onChange='validLen(this,300);'/>"));
	var td2 = $("<td></td>").append($("<input name='optiondesc' value='' onChange='validLen(this,400);'/>"));
	var td3 = $("<td></td>").append($("<input name='displayorder' value='' onChange='validfun(this);'/>"));
	tr.append(td0).append(td1).append(td2).append(td3);
	$("#processtable").append(tr);
	$("#processtable>tr:odd>td:odd").addClass("odd_odd");
	$("#processtable>tr:odd>td:even").addClass("odd_even");
	$("#processtable>tr:even>td:odd").addClass("even_odd");
	$("#processtable>tr:even>td:even").addClass("even_even");
}
function toDelOpt(){
	$("input[name='chkbox']:checked").each(function(i,k){
		$(k).parent().parent().remove();
	});
}
function validfun(obj){
	var reg = /^\d{1,4}$/;
	var _v = obj.value;
	if(!_v){
		return true;
	}else{
		var _r = reg.test(_v);
		if(!_r){
			alert('排序字段只能输入数字！');
			obj.value='';
		}
	}
}
function validLen(obj,len){
	var _v = obj.value;
	if(!_v){
		return true;
	}
	if(_v.len()>len){
		obj.value='';
		alert('长度超长');
	}
}
	function submitInfo(state){
		//验证
		var flag = false;
		var f = false;//验证是否有明细
		$("#processtable>tr>td").children().not(":checkbox").each(function(i,k){
			f=true;
			if(!($(k).val())){
				$(k).attr("title","不能为空").click(function(){$(this).removeClass("vilderrorcss");}).addClass("vilderrorcss");
				flag=true;
			}
		});
		var i1 = $("#dictkey");
		var i2 = $("#dictdesc");
		if(!(i1.val())){
			flag=true;
			i1.attr("title","不能为空").click(function(){$(this).removeClass("vilderrorcss");}).addClass("vilderrorcss");
		}
		if(!(i2.val())){
			flag=true;
			i2.attr("title","不能为空").click(function(){$(this).removeClass("vilderrorcss");}).addClass("vilderrorcss");
		}
		if(flag){
			alert("数据不能为空");
			return false;
		}
		if(!f){
			alert("请添加下拉选项明细数据");
			return false;
		}
		var submiturl = "<%=contextPath%>/rm/dm/rfidCommSelectUpdate.srq";
		document.getElementById("form1").action = submiturl;
		document.getElementById("form1").submit();
	}

	String.prototype.len = function() {
		return this.replace(/[^\x00-\xff]/g, "aa").length;
	};
</script>
</body>
</html>