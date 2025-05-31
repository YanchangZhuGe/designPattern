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
				<td class="inquire_item4">设备名称：</td>
			    <td class="inquire_form4">
			    	<input id="devname" class="input_width query" type="text" />
			    </td>
			    <td class="inquire_item4">规格型号：</td>
			    <td class="inquire_form4">
			    	<input id="devmodel" class="input_width query" type="text" />
			    </td>
		   	</tr>
		   	<tr>
				<td class="inquire_item4">牌照号：</td>
			    <td class="inquire_form4">
			    	<input id="licensenum" class="input_width query" type="text" />
			    </td>
			    <td class="inquire_item4">自编号：</td>
			    <td class="inquire_form4">
			    	<input id="selfnum" class="input_width query" type="text" />
			    </td>
		   	</tr>
		   	<tr>
				<td class="inquire_item4">实物标识号：</td>
			    <td class="inquire_form4">
			    	<input id="devsign" class="input_width query" type="text" />
			    </td>
			    <td class="inquire_item4">ERP编号：</td>
			    <td class="inquire_form4">
			    	<input id="devcoding" class="input_width query" type="text" />
			    </td>
		   	</tr>
		   	<tr>
				<td class="inquire_item4">所属单位：</td>
			    <td class="inquire_form4">
			    	<input id="owningorgname" class="input_width" type="text" readonly   />
					<img src="${pageContext.request.contextPath}/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showOrgTreePage()"  />
					<input id="owningsubid" name="owningsubid" class="query" type="hidden" />
			    </td>
			    <td class="inquire_item4">维修单位：</td>
			    <td class="inquire_form4">
			    	<input id="repairpostion" class="input_width query" type="text" />
			    </td>
		   	</tr>
		   	<tr>
				<td class="inquire_item4">承修人：</td>
			    <td class="inquire_form4">
			    	<input id="repairer" class="input_width query" type="text" />
			    </td>
			    <td class="inquire_item4">验收人：</td>
			    <td class="inquire_form4">
			    	<input id="accepter" class="input_width query" type="text" />
			    </td>
		   	</tr>
		   	<tr>
		   		<td class="inquire_item4">创建人：</td>
			    <td class="inquire_form4">
			    	<input id="creator" class="input_width query" type="text" />
			    </td>
				<td class="inquire_item4">工单号：</td>
			    <td class="inquire_form4">
			    	<input id="aufnr" class="input_width query" type="text" />
			    </td>
		   	</tr>
		   	<tr>
		   		<td class="inquire_item4">维修详情：</td>
			    <td class="inquire_form4">
			    	<input id="repairdetail" class="input_width query" type="text" />
			    </td>
				<td class="inquire_item4">项目描述：</td>
			    <td class="inquire_form4">
			    	<input id="projectname" class="input_width query" type="text" />
			    </td>			    
		   	</tr>
		   	<tr>
				<td class="inquire_item4">维修类型：</td>
			    <td class="inquire_form4">
			    	<input id="repairtype" class="easyui-combobox querystate" data-options="editable:false,panelHeight:'auto'" style="width:225px;float:none;">
			    </td>
			    <td class="inquire_item4">维修级别：</td>
			    <td class="inquire_form4">
			    	<input id="repairlevel" class="easyui-combobox querystate" data-options="editable:false,panelHeight:'auto'" style="width:225px;float:none;">
			    </td>
		   	</tr>
		   	<tr>
				<td class="inquire_item4">单据状态：</td>
			    <td class="inquire_form4">
			    	<input id="recordstatus" class="easyui-combobox querystate" data-options="editable:false,panelHeight:'auto'" style="width:225px;float:none;">
			    </td>
			    <td class="inquire_item4">数据来源：</td>
			    <td class="inquire_form4">
			    	<select id="datafrom" name="datafrom" class="select_width easyui-combobox querystate" data-options="editable:false,panelHeight:'auto'" style="width:210px;" >
					    <option value="" selected="selected">请选择...</option>
						<option value="SAP">SAP</option>
						<option value="YD">手持机</option>
						<option value="WTSC">平台录入</option>
					</select>
			    </td>
		   	</tr>
		   	<tr>
				<td class="inquire_item4">工时费开始金额：</td>
			    <td class="inquire_form4">
			    	<input id="humancoststart" class="input_width easyui-validatebox query" validType='intOrFloat' type="text" />
			    </td>
			    <td class="inquire_item4">工时费结束金额：</td>
			    <td class="inquire_form4">
			    	<input id="humancostend" class="input_width easyui-validatebox query" validType='intOrFloat' type="text" />
			    </td>
		   	</tr>
		   	<tr>
				<td class="inquire_item4">材料费开始金额：</td>
			    <td class="inquire_form4">
			    	<input id="materialcoststart" class="input_width easyui-validatebox query" validType='intOrFloat' type="text" />
			    </td>
			    <td class="inquire_item4">材料费结束金额：</td>
			    <td class="inquire_form4">
			    	<input id="materialcostend" class="input_width easyui-validatebox query" validType='intOrFloat' type="text" />
			    </td>
		   	</tr>
			 <tr>
			    <td class="inquire_item4">送修起始时间：</td>
			    <td class="inquire_form4">
			    	 <input id="repairstartdatestart" class="input_width easyui-datebox querydate se" style="width:210px;height:26px;" editable="false">
			    </td>
			    <td class="inquire_item4">送修结束时间：</td>
			    <td class="inquire_form4">
			    	 <input id="repairstartdateend" class="input_width easyui-datebox querydate se" style="width:210px;height:26px;" editable="false">
			    </td>
			 </tr>
			 <tr>
			    <td class="inquire_item4">验收起始时间：</td>
			    <td class="inquire_form4">
			    	 <input id="repairenddatestart" class="input_width easyui-datebox querydate mm" style="width:210px;height:26px;" editable="false">
			    </td>
			    <td class="inquire_item4">验收结束时间：</td>
			    <td class="inquire_form4">
			    	 <input id="repairenddateend" class="input_width easyui-datebox querydate mm" style="width:210px;height:26px;" editable="false">
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
	//维修类别
	$('#repairtype').combobox({ 
		url:'${pageContext.request.contextPath}/rm/dm/toGetJsonPurch.srq?purchcode=0100400027',
		editable:false, //不可编辑状态
		cache: false,
		valueField:'code',   
		textField:'note',
		value:'请选择...'
     });
	//维修级别
	$('#repairlevel').combobox({ 
		url:'${pageContext.request.contextPath}/rm/dm/toGetJsonPurch.srq?purchcode=5110000197',
		editable:false, //不可编辑状态
		cache: false,
		valueField:'code',   
		textField:'note',
		value:'请选择...'
     });
	//单据状态
	$('#recordstatus').combobox({ 
		url:'${pageContext.request.contextPath}/rm/dm/toGetJsonPurch.srq?purchcode=5110000225',
		editable:false, //不可编辑状态
		cache: false,
		valueField:'code',   
		textField:'note',
		value:'请选择...'
     });
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
// 选择组织机构树	 	 
function showOrgTreePage(){
	var returnValue = window.showModalDialog("${pageContext.request.contextPath}/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
	var strs= new Array(); //定义一数组
	if(!returnValue){
		return;
	}
	strs = returnValue.split("~"); //字符分割
	var names = strs[0].split(":");
	$("#owningorgname").val(names[1]);
	
	var orgSubId = strs[2].split(":");
	$("#owningsubid").val(orgSubId[1]);
	tipView('owningorgname',names[1],'top');
}
//日期判断
function checkDate(){
	//检查时间
	$(".easyui-datebox.se").datebox({
		onSelect: function(){
			var	startTime = $("#repairstartdatestart").datebox('getValue');
			var	endTime = $("#repairstartdateend").datebox('getValue');
			if(startTime!=null&&startTime!=''&&endTime!=null&&endTime!=''){
				var days=(new Date(endTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
				if(days<0){
					$.messager.alert("提示","结束日期应大于开始日期!","warning");
					$("#repairstartdateend").datebox("setValue","");
				}			
			}
		}
	});
	//检查时间
	$(".easyui-datebox.mm").datebox({
		onSelect: function(){
			var	startTime = $("#repairenddatestart").datebox('getValue');
			var	endTime = $("#repairenddateend").datebox('getValue');
			if(startTime!=null&&startTime!=''&&endTime!=null&&endTime!=''){
				var days=(new Date(endTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
				if(days<0){
					$.messager.alert("提示","结束日期应大于开始日期!","warning");
					$("#repairenddateend").datebox("setValue","");
				}			
			}
		}
	});
	//禁止日期框手动输入
	$(".datebox :text").attr("readonly","readonly");
}
</script>
</html>