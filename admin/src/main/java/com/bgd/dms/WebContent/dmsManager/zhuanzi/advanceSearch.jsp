<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<%@include file="/common/include/quotesresource.jsp"%>
</head>
<body>
	<form name="form1" id="form1" method="post" >
		<div id="new_table_box">
		  <div id="new_table_box_content" style="background-color: rgb(241, 242, 243)">
		    <div id="new_table_box_bg">
			<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
		    <tr>
				<td class="inquire_item4">转资单号：</td>
			    <td class="inquire_form4">
			    	<input id="zzno" class="input_width query" type="text" />
			    </td>
			    <td class="inquire_item4">供应商名称：</td>
			    <td class="inquire_form4">
			    	<input id="lifnrname" class="input_width query" type="text" />
			    </td>
			    <!-- <td class="inquire_item4">转资机构：</td>
			    <td class="inquire_form4">
			    	<input id="zzorgname" class="input_width query" type="text" />
			    </td> -->
		   	</tr>
		   	<tr>
				<td class="inquire_item4">转资起始台数：</td>
			    <td class="inquire_form4">
			    	<input id="zznumstart" class="input_width easyui-validatebox query" validType='intOrFloat' type="text" />
			    </td>
			    <td class="inquire_item4">转资结束台数：</td>
			    <td class="inquire_form4">
			    	<input id="zznumend" class="input_width easyui-validatebox query" validType='intOrFloat' type="text" />
			    </td>
		   	</tr>
		   	<tr>
				<td class="inquire_item4">转资起始总金额：</td>
			    <td class="inquire_form4">
			    	<input id="zzmoneystart" class="input_width easyui-validatebox query" validType='intOrFloat' type="text" />
			    </td>
			    <td class="inquire_item4">转资结束总金额：</td>
			    <td class="inquire_form4">
			    	<input id="zzmoneyend" class="input_width easyui-validatebox query" validType='intOrFloat' type="text" />
			    </td>
		   	</tr>		   	 
		   	<tr>
		   		<td class="inquire_item4">批次计划：</td>
			    <td class="inquire_form4">
			    	<input id="batchplan" class="input_width query"   type="text" />
			    </td>
			   	<td class="inquire_item4">采购单号：</td>
			    <td class="inquire_form4">
			    	<input id="cgordernum" class="input_width query" type="text" />
			    </td>
		   	</tr>
		   	<!-- <tr>
				<td class="inquire_item4">供应商名称：</td>
			    <td class="inquire_form4" colspan="3">
			    	<input id="lifnrname" style="width:92%" class="input_width query" type="text" />
			    </td>
		   	</tr> -->
		   	<tr>
		   		<td class="inquire_item4">创建人：</td>
			    <td class="inquire_form4">
			    	<input id="creatorname" class="input_width query" type="text" />
			    </td>
			    <td class="inquire_item4">转资状态：</td>
			    <td class="inquire_form4">
			    	<select id="zzstate" name="zzstate" class="select_width easyui-combobox querystate" data-options="editable:false,panelHeight:'auto'" style="width:210px;" >
					    <option value="" selected="selected">--请选择--</option>
						<option value="1">创建</option>
						<option value="2">已申请</option>
						<option value="3">未转资</option>
						<option value="4">已转资</option>
					</select>
			    </td>
		   	</tr>
			 <tr>
			    <td class="inquire_item4">创建起始时间：</td>
			    <td class="inquire_form4">
			    	 <input id="zzdatestart" class="input_width easyui-datebox querydate" style="width:210px;height:26px;" editable="false">
			    </td>
			    <td class="inquire_item4">创建结束时间：</td>
			    <td class="inquire_form4">
			    	 <input id="zzdateend" class="input_width easyui-datebox querydate" style="width:210px;height:26px;" editable="false">
			    </td>
			 </tr>
		</table>
		</div>
		    <div id="oper_div" style="padding-top:10px;">
		    	<a href="####" class="easyui-linkbutton" onclick="callBack()"><i class="fa fa-search fa-lg"></i> 查 询&nbsp;&nbsp;</a>
		    	&nbsp;&nbsp;&nbsp;&nbsp;
		    	<a href="####" class="easyui-linkbutton" onclick="newClose()"><i class="fa fa-close fa-lg"></i> 关 闭&nbsp;&nbsp;</a>
		    </div>
		</div>
		</div> 
	</form>
</body>

<script type="text/javascript">
//获取dialog传入的参数
var param = top.dialogVal(window);
$(function(){
	//设置下拉框的值
	checkDate();
})
//保存方法
function callBack(){
	if(formVilidate($("#form1"))){
		//组织查询条件
		var params = {};
		$(".query").each(function(){
			if($(this).val()!=""){
				params[$(this).attr("id")] = $(this).val();
			}
		});
		$(".querystate").each(function(){
			if($(this).combobox('getValue')!=""){
				params[$(this).attr("id")] = $(this).combobox('getValue');
			}
		});
		$(".querydate").each(function(){
			if($(this).datebox('getValue')!=""){
				params[$(this).attr("id")] = $(this).datebox('getValue');
			}
		});	
	 	//如果要返回值这样调用
	 	top.closeDialogAndReturn(window,{params:params}); 
	}  	 
}
//日期判断
function checkDate(){
	//检查时间
	$(".easyui-datebox").datebox({
		onSelect: function(){
			var	startTime = $("#zzdatestart").datebox('getValue');
			var	endTime = $("#zzdateend").datebox('getValue');
			if(startTime!=null&&startTime!=''&&endTime!=null&&endTime!=''){
				var days=(new Date(endTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
				if(days<0){
					$.messager.alert("提示","结束日期应大于起始日期!","warning");
					$("#zzdateend").datebox("setValue","");
				}			
			}
		}
	});
	//禁止日期框手动输入
	$(".datebox :text").attr("readonly","readonly");
}
</script>
</html>