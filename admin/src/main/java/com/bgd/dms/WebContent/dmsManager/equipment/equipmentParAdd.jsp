<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	String deviceappid = request.getParameter("deviceappid");
	String parameter_ids = request.getParameter("parameter_ids");
	String id = request.getParameter("id");
	String pid = request.getParameter("pid");
	String whole = request.getParameter("whole");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备参数添加</title>
<style type="text/css">
#new_table_box_content {
	width:auto;
	height:620px;
	border:1px #999 solid;
	background:#cdddef;
	padding:15px;
	}
	#new_table_box_bg {
	width:auto;
	height:487px;
	border:1px #aebccb solid;
	background:#f1f2f3;
	padding:10px;
	overflow:auto;
}
</style>
</head>
<body class="bgColor_f3f3f3" onload="refreshData('<%=whole%>'),loadDataDetail('<%=parameter_ids%>');">
<form name="form1" id="form1" method="post" action="" >
	<div id="new_table_box">
	<div id="new_table_box_content">
	<div id="new_table_box_bg">
	<fieldSet style="margin:2px:padding:2px;"><legend>设备参数添加</legend>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
       <tr>
       	  <td width="25%" align="center">当前设备类型:</td><td><input name="current_device_type" id="current_device_type" class="input_width" type="text" value="" disabled="disabled"/></td>
       </tr>
      </table>
       <fieldset style="margin:2px;padding:2px;">
       <h5 align="center"><font size="15px" style="text-align: center; font-size: 15px">设备参数添加</font></h5>
    	 <table  style="table-layout:fixed;text-align:center;" width="100%" border="0" cellspacing="0" cellpadding="0"class="tab_info" id="itemTable">
			<tr>
				<td width="10%" class="ali_btn" style="position: center;">
					<span class="zj"><a href="javascript:void(0);" onclick="insertTr()" title="添加"></a></span>
				</td>
				<td width="20%">序号</td>
				<td width="70%">参数名称</td>
			</tr>
		</table>
      </fieldset>
		<div id="oper_div" style="text-align: right">
	     	<span class="bc_btn"><a href="####" id="submitButton" onclick="saveInfo()"></a></span>
	        <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
   		</div>	
   	</fieldSet>
   </div>
 </div>
</div>
</form>
</body>

<script type="text/javascript">
cruConfig.contextPath = "<%=contextPath%>";
cruConfig.cdtType = 'form';
	cruConfig.queryStr = ""; 
	cruConfig.queryService = "ModelApply";
	var flag="<%=flag%>";
	var id ="<%=id%>";
	var whole ="<%=whole%>";
	var pid ="<%=pid%>";
	var parameter_ids = "<%=parameter_ids%>";
	//指标项序号
	var order = 0;
	//添加指标项行
	function insertTr(old){
		order++;
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr_"+order+"' class='old' tempindex='"+order+"'>";
		}else{
			temp +="<tr id='tr_"+order+"' class='new' tempindex='"+order+"'>";
		}
		temp =temp + ("<td><input name='parameter_ids_"+order+"' id='parameter_ids_"+order+"' type='hidden'/>"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr(this)'/></td>" +
		"<td>"+order+"</td> "+
		"<td><input name='parameter_name_"+order+"' id='parameter_name_"+order+"' type='text' style='height:20px;width:90%;' class='easyui-validatebox' data-options=\"validType:'length[0,100]'\" maxlength='100' required/></td>"+
		"</tr>");
		$("#itemTable").append(temp);
		return order; 
	}
	
	
	//删除指标项行
	function deleteTr(item){
		//页面修改时要处理的操作
		if($(item).parent().parent().attr("class")=="old"){
			var itemId = $(item).parent().children("input").first().val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_tr_"+tts+"' value='"+itemId+"'/>");
		}
		if(whole=="null"){
			$.messager.alert("提示","没有选择菜单项不能被删除！");
			return;
		}
		 if(confirm('确定要删除吗?')){
			var retObj = jcdpCallService("EquipmentParMan", "deleteEquPar", "parameter_ids="+itemId);				
			if(typeof retObj.operationFlag!="undefined"){
				var dOperationFlag=retObj.operationFlag;
				if(''!=dOperationFlag){
					if("failed"==dOperationFlag){
						$.messager.alert("提示","删除失败！");
					}	
					if("success"==dOperationFlag){
						alert("删除成功！");
						//获取行id
						var temp = $(item).parent().parent().attr("id");
						//删除行
						$(item).parent().parent().remove();
						//序号重新排序
						var _index = parseInt(temp.split("_")[1]);
						for(var j=_index;j<order;j++){
							//给隐藏域序号赋值
							$("#tr_"+(j+1)).children().eq(0).children().eq(1).val(j);
							//给序号赋值
							var order_td = $("#tr_"+(j+1)).children().eq(1);
							order_td.html(j);
							//给tr 属性 赋值
							$("#tr_"+(j+1)).attr("id","tr_"+j);
						}
						//索引减一
						order=order-1;
					}
				}
			} 
		}
	}
	
	function refreshData(whole){
	var baseData;
	if(whole != "null" && whole !=""){
		baseData = jcdpCallService("EquipmentParMan", "getEquipmentType", "whole="+whole); 
	  //给数据回填
	  $("#current_device_type").val(baseData.str.name);
	   }
	}
	
	function loadDataDetail(parameter_ids){
	var baseData;
	if(parameter_ids != "null"){
		baseData = jcdpCallService("EquipmentParMan", "getCurrentType", "parameter_ids="+parameter_ids); 
	  //给数据回填
		$("#current_device_type").val(baseData.str.current_device_type);
		if(typeof baseData.deviceappMap!="undefined"){
			var datas = baseData.deviceappMap;
			for(var i=0;i<datas.length;i++){
				var ts=insertTr("old");
				var data=datas[i];
				$.each(data, function(k, v){
					if(null!=v && ""!=v){
						$("#itemTable #"+k+"_"+ts).val(v);
					}
				});
			}
			orader=datas.length;
		}
	   }
	}
	
	
	function saveInfo(){
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
			if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/modelSelection/equipmentParAdd.srq?flag="+flag+"&whole="+whole+"&ids="+parameter_ids;
    			document.getElementById("form1").submit();
            }
        });
	}
	
	
</script>
</html>

