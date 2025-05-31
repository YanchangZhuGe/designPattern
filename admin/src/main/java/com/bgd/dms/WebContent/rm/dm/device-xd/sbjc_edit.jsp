<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	//增加，修改标志
	String flag=request.getParameter("flag");
	//设备检查id
	String id=request.getParameter("id");
	//当前项目号
	String project_info_no=request.getParameter("project_info_no");
	//检查类型
	String inspection_type=request.getParameter("inspection_type");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>设备检查</title> 
 </head>
<body style="background:#cdddef">
<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
<!-- 主键 -->
<input  type ="hidden" id="inspection_id" name="inspection_id" class="input_width" />
<div id="new_table_box" >
  <div id="new_table_box_content">
    <div id="new_table_box_bg" >
    	  <fieldset>
	  	<legend>设备信息</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tr>
			  	<td class="inquire_item6">设备名称</td>
				<td class="inquire_form6">
					<!--队级台账ID-->
					<input id="device_account_id" name="device_account_id" type ="hidden"  class="input_width"/>
					<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
					<img width="16" height="16" style="cursor: hand;" onclick="showDevPage()" src="<%=contextPath%>/images/magnifier.gif"/>
				</td>
		  		<td class="inquire_item6">规格型号</td>
				<td class="inquire_form6"><input id="dev_model" name="dev_model"  class="input_width" type="text" readonly/></td>
		  </tr>
		  <tr>
		  		<td class="inquire_item6">自编号</td>
				<td class="inquire_form6">
					<input id="self_num" name="self_num"  class="input_width" type="text" readonly/>
				</td>
		  		<td class="inquire_item6">牌照号</td>
				<td class="inquire_form6"><input name="license_num" id="license_num"  class="input_width" type="text" readonly /></td>
		  </tr>
	 	</table>
	  </fieldset>
      <fieldset>
      	<legend>设备检查</legend>
		  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
				<td class="inquire_item6">项目名称</td>
				<td class="inquire_form6">
					<!-- 项目号 -->
					<input  type ="hidden" id="project_info_no" name="project_info_no"  class="input_width" />
					<input id="project_name" name="project_name"  class="input_width" type="text" readonly/>
				</td>
				<td class="inquire_item6">检查类型</td>
				<td class="inquire_form6">
					<select id="inspection_type" name="inspection_type" class="select_width">
						
					</select>
				</td>
			  </tr>
			  <tr>
			  	<td class="inquire_item6">检查人</td>
				<td class="inquire_form6"><input name="inspector" id="inspector" value="<%=user.getUserName()%>"  class="input_width" type="text"  /></td>
				<td class="inquire_item6">检查日期</td>
				<td class="inquire_form6">
					<input id="inspection_date" name="inspection_date"  class="input_width" type="text" readonly/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(inspection_date,tributton3);"/>
				</td>
			  </tr>
			  <tr>
			  	<td class="inquire_item6">检查内容</td>
				<td class="inquire_form6" colspan="3">
					<textarea rows="2" cols="59" id="inspection_content" name="inspection_content" class="textarea" style="height:50px"></textarea>
				</td>
			  </tr>
			  <tr id="f_tr">
			    <td class="inquire_item6">附件:</td>
			    <td class="inquire_item6" colspan="3">
			    	<input type="file" name="apply_file" id="apply_file" value="" class="input_width" />
			    	<input type="hidden" id="file_name" name="file_name" value=""/>
			    </td>
			  </tr>
		  </table>
	  </fieldset>
	  <fieldset>
	  	<legend>整改信息</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tr>
			  	<td class="inquire_item6">整改期限</td>
				<td class="inquire_form6">
					<input name="rectification_period" id="rectification_period"  class="input_width" type="text"  />
				</td>
				<td class="inquire_item6">责任人</td>
				<td class="inquire_form6">
					<input id="CHARGE_PERSON" name="charge_person"  class="input_width" type="text" />
				</td>
		  	</tr>
		  	<tr>
			  	<td class="inquire_item6">是否合格</td>
				<td class="inquire_form6">
					<select id="spare1" name="spare1" class="select_width">
						<option value="">--请选择--</option>
						<option value="1">是</option>
						<option value="0">否</option>
					</select>
				</td>
		  	</tr>
			<tr>
				<td class="inquire_item6">整改问题</td>
				<td class="inquire_form6" colspan="3">
					<textarea rows="2" cols="59" id="inspection_result" name="inspection_result" class="textarea" style="height:50px"></textarea>
				</td>
		  </tr>
	 	</table>
	  </fieldset>
	  <fieldset>
	  	<legend>整改情况检查</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tr>
			  	<td class="inquire_item6">整改时间</td>
				<td class="inquire_form6">
					<input id="rectify_date" name="rectify_date"  class="input_width" type="text" readonly/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton33" width='16' height='16' style="cursor: hand;" onmouseover="calDateSelector(rectify_date,tributton33);"/>
				</td>
				<td class="inquire_item6">整改人</td>
				<td class="inquire_form6">
					<input id="rectify_person" name="rectify_person"  class="input_width" type="text" />
				</td>
		  	</tr>
		  	<tr>
			  	<td class="inquire_item6">整改结果</td>
				<td class="inquire_form6" colspan="3">
					<textarea rows="2" cols="59" id="rectify_content" name="rectify_content" class="textarea" style="height:50px"></textarea>
				</td>
		 	</tr>
	 	</table>
	  </fieldset>
	</div>
		  <div id="oper_div" style="margin-bottom:5px">
		 	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
		    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		  </div>
    </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	var flag='<%=flag%>';
	var id='<%=id%>';
	var project_info_no='<%=project_info_no%>';
	var inspection_type='<%=inspection_type%>';
	$(function(){
		var inspection_type_text="";
		if("0110000047000000002"==inspection_type){
			inspection_type_text="巡回检查";
		}
		if("0110000047000000003"==inspection_type){
			inspection_type_text="定期检查";
		}
		$("#inspection_type").append("<option value='"+inspection_type+"'>"+inspection_type_text+"</option>");
		//修改
		if(flag=="edit"){
			var retObj = jcdpCallService("DevInsSrv", "getDevInsInfo", "id="+id);
			var data = retObj.data;
			$(".input_width , .select_width , .textarea").each(function(){
				var temp = this.id;
				$("#"+this.id).val(data[temp] != undefined ? data[temp]:"");
			});
			//项目号
			project_info_no=data.project_info_no;
			var fdata = retObj.fdata;
			if(typeof fdata!="undefined" && fdata!=""){
				//alert(fdata);
				insertFile(fdata.file_name,fdata.file_type,fdata.file_id);
			}
		}else{
			var retObj = jcdpCallService("DevInsSrv", "getProjInfo", "project_info_no="+project_info_no);
			var data = retObj.data;
			$("#project_info_no").val(data.project_info_no != undefined ? data.project_info_no:"");
			$("#project_name").val(data.project_name != undefined ? data.project_name:"");
		}
	});
	//插入文件
	function insertFile(name,type,id){
		$("#f_tr").empty();
		$("#f_tr").append(
					"<td class='inquire_item6'>附件:</td>"+
	      			"<td class='inquire_item6' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick=deleteFile(this,\""+id+"\") title='删除'></a></span></td>"
			);
	}
	//删除文件
	function deleteFile(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			$("#f_tr").append("<td class='inquire_item6'>附件:</td>"+
				    "<td class='inquire_item6' colspan='3'><input type='file' name='apply_file' id='apply_file' value='' class='input_width'/>"+
	    			"<input type='hidden' id='file_name' name='file_name' value=''/></td>");
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
		}
	}
	function submitInfo(){
		var obj = document.getElementById("apply_file");
		if(obj != null && value != ''){
			var value = obj.value ;
			var start = value.lastIndexOf('\\');
			var end = value.lastIndexOf('.');
			value = value.substring(start+1,end);
			document.getElementById("file_name").value = value;
		}
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveOrUpdateDevInsInfo.srq?flag="+flag;
		document.getElementById("form1").submit();
	}
	function showDevPage(){
		var projectinfono=project_info_no;
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectAccount.jsp?projectinfono="+projectinfono,"","dialogWidth=950px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			//返回信息是 队级台账id + AMIS资产编号+ 设备名称 + 规格型号 + 自编号 + 实物标识号 + 牌照号  + 设备编码
			$("#device_account_id").val(returnvalues[0]);
			$("#dev_name").val(returnvalues[2]);
			$("#dev_model").val(returnvalues[3]);
			$("#self_num").val(returnvalues[4]);
			$("#license_num").val(returnvalues[6]);
		}
	}

</script>
</html>
 