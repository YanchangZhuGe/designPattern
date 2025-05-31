<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/easyuiresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen2.js"></script>
<title>查询条件</title>
</head>
<body class="bgColor_f3f3f3" >
<form name="searchform" id="searchform" method="post" action=""> 
<div id="new_table_box">
  <div id="new_table_box_content" style="background-color: rgb(241, 242, 243)">
    <div id="new_table_box_bg">
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
            <tr>
				<td class="inquire_item6">&nbsp;设备名称</td>
				<td class="inquire_form6">
					<input id="dev_name" name="dev_name" class="input_width  query" type="text"  />
				</td>
				<td class="inquire_item6">&nbsp;规格型号</td>
				<td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width query" type="text"    /></td>
				<td class="inquire_item6">&nbsp;管理单位</td>
				<td class="inquire_form6">
					<input id="usage_org_name"    class="input_width  " type="text" readonly   />
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showOrgTreePage1()"  />
					<input id="usage_org_id" name="usage_org_id" class="" type="hidden" />
					<input id="usage_sub_id" name="usage_sub_id" class="" type="hidden" />
					 
				</td>
			  </tr>
				<tr>
				<td class="inquire_item6"> &nbsp;出厂/管道编号</td>
				<td class="inquire_form6">
				<input id="dev_num" name="dev_num" class="input_width  query" type="text"   />	 
				</td>
				<td class="inquire_item6"> &nbsp;实物标识号</td>
				<td class="inquire_form6"><input id="dev_sign" name="dev_sign" class="input_width query " type="text"   /></td>
				<td class="inquire_item6"> &nbsp;ERP编号</td>
				<td class="inquire_form6"><input id="dev_coding" name="dev_coding" class="input_width query " type="text"   /></td>				
			  </tr>
			  	<tr>
				<td class="inquire_item6"> &nbsp;档案编号</td>
				<td class="inquire_form6">
				<input id="RECORD_NUM" name="RECORD_NUM" class="input_width query " type="text"   />	 
				</td>
				<td class="inquire_item6"> &nbsp;使用证编号</td>
				<td class="inquire_form6"><input id="USE_NUM" name="USE_NUM" class="input_width query " type="text"   /></td>
				<td class="inquire_item6"> &nbsp;单位内部编号</td>
				<td class="inquire_form6"><input id="INTERNAL_NUM" name="INTERNAL_NUM" class="input_width query " type="text"   /></td>				
			  </tr>
			  <tr>
				<td class="inquire_item6"> &nbsp;主要用途</td>
				<td class="inquire_form6">
				<input id="MAIN_USEINFO" name="MAIN_USEINFO" class="input_width query " type="text"   />	 
				</td>
				<td class="inquire_item6"> &nbsp;设备安装地点</td>
				<td class="inquire_form6"><input id="INSTALLTION_PLACE" name="INSTALLTION_PLACE" class="input_width query " type="text"   /></td>
				<td class="inquire_item6"> &nbsp;注册码</td>
				<td class="inquire_form6"><input id="REGISTRATION_CODE" name="REGISTRATION_CODE" class="input_width query " type="text"   /></td>				
			  </tr>
			  <tr>
				<td class="inquire_item6">注册状态</td>
				<td class="inquire_form6"><select  id="zc_stat" name="zc_stat" class="input_width queryselect" type="text" >
					<option value="">--请选择--</option>
					<option value="0">未注册</option>
					<option value="1">已注册</option>
				</select></td>
				<td class="inquire_item6">&nbsp;所属单位</td>
				<td class="inquire_form6">
					<input id="owning_org_name"    class="input_width  " type="text" readonly   />
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showOrgTreePage()"  />
					<input id="owning_org_id" name="owning_org_id" class="" type="hidden" />
					<input id="owning_sub_id" name="owning_sub_id" class="" type="hidden" />
					 <input id="devaccid" name="devaccid" class="input_width" type="hidden" />
				</td>
				<td class="inquire_item6">使用情况</td>
				<td class="inquire_form6"><select id="using_stat" name="using_stat" class="input_width queryselect" type="text"   >
				  <option value="">--请选择--</option>
            	  <option value="0110000007000000002">闲置</option>
            	  <option value="0110000007000000001">在用</option>
            	  <option value="0110000007000000003">停用</option>
      			  <option value="0110000007000000006">其他</option>
				</select></td>				
			  </tr>
			  <tr>
			  	<td class="inquire_item6">技术状况</td>
				<td class="inquire_form6"><select type="text" name="tech_stat" id="tech_stat" value="" readonly="readonly" class="input_width   queryselect">
				  <option value="">--请选择--</option>
				  <option value="0110000006000000001">完好</option>
            	  <option value="0110000006000000006">待修</option>
      			  <option value="0110000006000000007">在修</option>
      			  <option value="0110000006000000005">待报废</option>
				</select>
				</td>
			    <td class="inquire_item6">&nbsp;国内/国外</td>
				<td class="inquire_form6">
					<select type="text" name="ifcountry" id="ifcountry" value="" readonly="readonly" class="input_width  queryselect">
						<option value="">--请选择--</option>
						<option value="0">国内</option>
						<option value="1">国外</option>
					</select>
				</td>
			 	<td class="inquire_item6">&nbsp;检验将到期的设备</td>
				<td class="inquire_form6">
					 是<input type="radio" name="lastdate" value="0"> &nbsp;&nbsp;&nbsp; 否<input type="radio" name="lastdate" value="1">
				</td>
				</tr>
				<tr>
				  <td class="inquire_item6" >&nbsp;下次检验日期</td>
				  <td class="inquire_form6" colspan="3">
				  <input type="text" name="start_date" id="start_date"   class="input_width easyui-datebox querydate se" style="width:130px" editable="false" required/>
				  	&nbsp;至&nbsp;
				   <input type="text" name="end_date" id="end_date"   class="input_width easyui-datebox querydate se" style="width:130px" editable="false" required/>
				  </td>
			  </tr>
        </table>
    </div>
    <div id="oper_div" style="padding-top:10px;">
    <a href="####" class="easyui-linkbutton" onclick="submitInfo()"><i class="fa fa-search fa-lg"></i> 查 询&nbsp;&nbsp;</a>
		    	&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="####" class="easyui-linkbutton" onclick="newClose()"><i class="fa fa-close fa-lg"></i> 关 闭&nbsp;&nbsp;</a>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	var content = "";
	$().ready(function(){
		checkDate();
		$("#table1").find("input[type='text']:first").focus();
	});
	//将表单数据转为json
        function form2Json(id) {
 
            var arr = $("#" + id).serializeArray()
            var jsonStr = "";
 
            jsonStr += '{';
            for (var i = 0; i < arr.length; i++) {
                jsonStr += '"' + 'query_'+arr[i].name + '":"' + arr[i].value + '",'
            }
            jsonStr = jsonStr.substring(0, (jsonStr.length - 1));
            jsonStr += '}'
 
            var json = JSON.parse(jsonStr)
            return json
        }
	//提交查询
	function submitInfo(){
	
    var indexFrame=top.document.getElementById('indexFrame');
	//获取iframe(id='indexFrame')页面下的iframe(id='list')
	var list=indexFrame.contentWindow.document.getElementById('list');
	//调用刷新方法
	list.contentWindow.searchDevData1(form2Json("searchform"));
	newClose();
	}
	//选择组织机构树 
	function showOrgTreePage(){
		var returnValue={
			fkValue:"",
			value:""
		}
		window.showModalDialog("<%=contextPath%>/common/selectOrgSub.jsp",returnValue,"");
		document.getElementById("owning_org_name").value = returnValue.value;
		document.getElementById("owning_sub_id").value = returnValue.fkValue;
		tipView('owning_org_name',returnValue.value,'top');
	}
	//选择组织机构树 
	function showOrgTreePage1(){
		var returnValue={
			fkValue:"",
			value:""
		}
		window.showModalDialog("<%=contextPath%>/common/selectOrgSub.jsp",returnValue,"");
		document.getElementById("usage_org_name").value = returnValue.value;
		document.getElementById("usage_sub_id").value = returnValue.fkValue;
		tipView('usage_org_name',returnValue.value,'top');
	}
	//日期判断
	function checkDate(){
		//检查时间
		$(".easyui-datebox.se").datebox({
			onSelect: function(){
				var	startTime = $("#start_date").datebox('getValue');
				var	endTime = $("#end_date").datebox('getValue');
				if(startTime!=null&&startTime!=''&&endTime!=null&&endTime!=''){
					var days=(new Date(endTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
					if(days<0){
						$.messager.alert("提示","结束日期应大于开始日期!","warning");
						$("#end_date").datebox("setValue","");
					}			
				}
			}
		});
	 
	}
</script>
</html>

