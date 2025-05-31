<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ taglib uri="code" prefix="code"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgId = user.getSubOrgIDofAffordOrg();
	String orgstrId = user.getOrgId();
	String orgsubId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
	String org_name=user.getOrgName();

	String yearinfostr = new SimpleDateFormat("yyyy").format(Calendar
			.getInstance().getTime());
	int yearinfo = Integer.parseInt(yearinfostr);
	String monthinfostr = new SimpleDateFormat("MM").format(Calendar
			.getInstance().getTime());
			String apply_id=request.getParameter("apply_id");
	int monthinfo = Integer.parseInt(monthinfostr);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/panelTableStyle.css"
	rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/table_fixed.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<style type="text/css">
btn {
	background-image: url("../images/images/gl.png");
}
</style>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript"
	src="${applicationScope.fusionChartsURL}/Tools/FCDataConverter/js/FusionCharts.js"></script>

<title>操作证申请</title>
</head>
<body style="background: #cdddef; overflow-y: auto" onload="get_data()">
 
	<form name="form" id="form" method="post" enctype="multipart/form-data" action="<%=contextPath%>/dmsManager/opcard/saveOrUdateOp_cardApply.srq?flag=add">
	<div id="list_content">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" id="td0">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td></td>
						</tr>
						<tr>
							<td>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="49%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">
													<span class="kb"><a href="####"></a></span>申请时间： <span id="apply_date"></span> 
														&nbsp;&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申请单位 :<span id="apply_unit"></span><span class="gd"><a href="####"></a></span>

												</div>
												<div class="tongyong_box_content_left" id="chartContainer1"
													style="overflow-x: hidden;">
													<table width="100%" border="0" cellspacing="0"
														cellpadding="0" class="tab_info" align="left">
														<tr class="trHeader">
															<td class="bt_info_odd">准许操作设备名称</td>
															<td class="bt_info_even"> <textarea row="3" id="op_type" cols="20"></textarea></td>
															<td class="bt_info_odd">准许操作设备型号</td>
															<td class="bt_info_even"><textarea row="3" id="op_model" cols="20"  ></textarea></td>
														</tr>
														<tr class="trHeader">
														<td class="bt_info_odd" >培训内容</td>
													 
														<td class="bt_info_even" ><input id="train_content"/></td>
														<td class="bt_info_odd" >培训讲师</td>
													 
														<td class="bt_info_even" ><input id="train_teacher"/></td>
														</tr>
														<tr class="trHeader">
														<td class="bt_info_odd" colspan="2">培训时间</td>
														<td class="bt_info_even" colspan="2"> 开始时间:<input   id="start_time" name="start_time" type="text" />
			 	 <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(start_time,tributton1);" />
 			 	  结束时间:<input   id="end_time" name="end_time" type="text" />
			 	 <img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(end_time,tributton2);" /></td>
														</tr>
														<tbody id="device_content"></tbody>
													</table>
												</div>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						 
						<tr>
							<td>
		 					<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="49%">
											<div class="tongyong_box">
												<div class="tongyong_box_title">
													<span class="kb"><a href="####"></a></span>人员详情<span class="gd"><a href="####"></a></span>
							<span class="zj" style="float:right;margin-top:-4px;">
								<a href="####" onclick="addEmployee()" title="添加员工信息"></a>
							</span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer1"
													style="overflow-x: hidden;">
													<table width="100%" border="0" cellspacing="0"
														cellpadding="0" class="tab_info" align="left">
														<tr class="trHeader">
															<td class="bt_info_odd">编号</td>
															<td class="bt_info_even">姓名</td>
															<td class="bt_info_odd">身份证</input></td>
															<td class="bt_info_even">员工编号</td>
															<td class="bt_info_odd">工作单位</input></td>
															<td class="bt_info_even">工作时间</td>
															<td class="bt_info_odd">现在岗位</Td>
															<td class="bt_info_even" >性别</Td>
														 
															<td class="bt_info_even">照片</Td>
															<td class="bt_info_odd">操作</Td>
														</tr>
														<tbody id="device_content1">
														 
														</tbody>
													</table>
												</div>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
				
			</tr>
			<tr>
			<td>
		 <table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td >
											<div class="tongyong_box">
												<div class="tongyong_box_title">
													<span class="kb"><a href="####"></a></span>上传附件<span class="gd"><a href="####"></a></span>

												</div>
												<div>
												<td>
												<tr>
												<tr>
												<td>
												<table>
				<tr>
					<td class="ali_cdn_name"> </td>
					<auth:ListButton functionId="" css="dr"
						event="onclick='excelDataAdd(1)'" title="导入设备"></auth:ListButton>
				</tr>
			</table>
			<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_tablePublic">
				<input name="flag_public" id="flag_public" type="hidden"/>
			</table>
												</td>
												</tr>
												</table>
			<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_tablePublic">
				<input name="flag_public" id="flag_public" type="hidden"/>
			</table>
			</td>
			</tr>
			<tr>
			 
			</tr>
		</table>
		<input id="peoplecount" name="peoplecount" type="hidden"/>
	 	<input id="peopleids" name="peopleids" type="hidden"/>
	 	<input id="peopleidss" name="peopleidss" type="hidden"/>
	 	<input id="ids" name="ids" type="hidden"/>
	 	<input id="noimg" name="noimg" type="hidden"/>
	</div>
	</form>
</body>
 

<script type="text/javascript">

var index=0;
var peoplecount=1;//培训人数
var peopleids='1,';
var peopleidss='';
var ids='';
var noimg='';
	//关闭操作
	function toClose(){
		window.location.href='<%=contextPath %>/dmsManager/opcard/OperationCardList.jsp';	
	}
	//提交方法
	function toSubmit(){
	 alert("没有图片用户:"+noimg);
 	$("#peoplecount").val(peoplecount);
 	$("#peopleids").val(peopleids);
 	$("#peopleidss").val(peopleidss);
 	$("#ids").val(ids);
 	$("#noimg").val(noimg);
		var subForm = $("#form");
		subForm.submit();
	}
function get_data()    /**填充申请单数据**/
{
	//申请单基本数据
 var retObj = jcdpCallService("DevInsSrv", "queryOp_cardList","currentPage=1&pageSize=10&apply_id=<%=apply_id%>");
			if (typeof retObj.datas != "undefined"   ) {
				var data=retObj.datas[0];
				 $("#apply_unit").html(data.apply_unit);
				 $("#apply_date").html(data.apply_date);
				var retObj1 = jcdpCallService("DevInsSrv", "getApplyDeviceInfoByApply_id","currentPage=1&pageSize=10&apply_id=<%=apply_id%>");
			 
				if (typeof retObj1.data != "undefined"   ) {
				  $("#op_type").val(filterRepeatStr(retObj1.data.type));
				  $("#op_model").val(retObj1.data.name);
				}
				 $("#train_content").val(data.train_content);
				 $("#train_teacher").val(data.train_teacher);
				 $("#start_time").val(data.train_startdate);
				 $("#end_time").val(data.train_enddate);
									
			}
			
				var retObj1 = jcdpCallService("DevInsSrv", "loadEmployeeInfoByApplID","apply_id=<%=apply_id%>");
				if (typeof retObj1.datas != "undefined"   ) {
					basedatas = retObj1.datas;	
					for(var i=0;i<basedatas.length;i++){
					var map =basedatas[i];
 					addEmployee();
					$("#employee_name"+index).val(map.employee_name);
					$("#employee_id"+index).val(map.employee_id_code_no);
					$("#employee_cd"+index).val(map.employee_cd);
					$("#sex"+index).val(map.employee_gender);
					if(map.employee_cd!=''){
					
					 document.getElementById("human_image"+index).src = "http://10.88.2.241:8080/hr_photo/"+map.employee_cd.substr(0,5)+"/"+map.employee_cd+".JPG";
					}else{
					document.getElementById("human_image"+index).src ='<%=contextPath%>/doc/downloadDoc.srq?docId='+map.file_id;
					}
					$("#work_part"+index).val(map.org_name);
					$("#org_name"+index).val(map.post);
					$("#start_work_date"+index).val(map.work_date);
					 
					index=index+1;
					}
				}
			
}
	cruConfig.contextPath='<%=contextPath%>';
	//删除用户
	function delEmployee(id){
	peoplecount=peoplecount-1;
	peopleids=peopleids.replace(id+',','');
	peopleidss=peopleidss.replace(id+',','');
	ids=ids.replace($("#employee_id"+id).val()+',','');
		$("#tr"+id).remove();
	}
	//添加用户
	function addEmployee(){
		  // 添加“添加文件”的按钮，
	
		var htmls='<tr id="tr'+index+'">';
		htmls=htmls+'<td class="bt_info_odd">'+index+'</td>';
		htmls=htmls+'<td class="bt_info_even"><input id="employee_name'+index+'" name="employee_name'+index+'"/></td>';
		htmls=htmls+'<td class="bt_info_odd"><input  id="employee_id'+index+'" name="employee_id'+index+'"/></td>';
		htmls=htmls+'<td class="bt_info_even"  ><input id="employee_cd'+index+'" name="employee_cd'+index+'"/></td>';
		htmls=htmls+'<td class="bt_info_odd" ><input id="work_part'+index+'" name="work_part'+index+'"/></td>';
		htmls=htmls+'<td class="bt_info_even"  ><input   id="start_work_date'+index+'" name="start_work_date'+index+'" type="text" />';
		htmls=htmls+'<img src="<%=contextPath%>/images/calendar.gif" id="employeebutton'+index+'" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(start_work_date'+index+',employeebutton'+index+');" /></td>';
		htmls=htmls+'<td class="bt_info_odd" ><input id="org_name'+index+'" name="org_name'+index+'"/></Td>';
		htmls=htmls+'<td class="bt_info_odd" ><input id="sex'+index+'" style="width:30px;" name="sex'+index+'"/></Td>';
		htmls=htmls+"<td class='bt_info_even' id='td"+index+"'> <img  id='human_image"+index+"' style='width: 85px; height: 120px' src='<%=contextPath%>/humanPhoto/zhaopian.JPG' /> <input type='file' name='excel_content_public"+index+"' id='excel_content_public"+index+"' onchange='getFileInfoPublic(this)' style='display:none'/>  </td>";
		htmls=htmls+'<td class="bt_info_odd"><button onclick="delEmployee('+index+')">X</button></td></tr>';
		 
		var device_content = $("#device_content1");
		device_content.append(htmls);
		// uploader.addButton("#filePicker"+id_index);
		//eval(getsql(id_index));
		
		
	}
	
	//根据身份证号查询员工信息
	function loadEmployeeInfo(obj){
		var val=$("#employee_id"+obj).val();
	 
		if(val.length==18){
			
			if(ids.indexOf(val)!=-1){
			 
			//alert("已添加该员工信息");
			//$("#employee_id"+obj).val("");
			}else{
				var retObj = jcdpCallService("DevInsSrv", "loadEmployeeInfo","employee_id="+$("#employee_id"+obj).val());
				if (typeof retObj.data != "undefined"){
					 
					ids=ids+val+",";
					peopleidss=peopleidss+obj+',';
					var map=retObj.data;
					$("#employee_name"+obj).val(map.employee_name);
					$("#employee_id"+obj).val(map.employee_id_code_no);
					$("#employee_cd"+obj).val(map.employee_cd);
					$("#sex"+obj).val(map.employee_gender);
					var retObj1 = jcdpCallService("DevInsSrv", "getApplyDeviceInfoByEmployee_id","employee_id="+$("#employee_id"+obj).val());
					if (typeof retObj1.data != "undefined"){
						
						$("#lb"+obj).append("<textarea row='3' cols='20'>"+filterRepeatStr(retObj1.data.type)+"</textarea></br><textarea row='3' cols='20'>"+filterRepeatStr(retObj1.data.name)+"</textarea>");
					}else{
						
						$("#lb"+obj).append("<span></span>");
					}
					if(map.employee_cd==''){
					noimg=noimg+obj+",";
				$("#td"+obj).empty();
					$("#td"+obj).append("<input type='file' name='excel_content_public"+id_index+"' id='excel_content_public"+id_index+"' onchange='getFileInfoPublic(this)'/>  ");
					}
					$("#work_part"+obj).val(map.org_name);
					$("#org_name"+obj).val(map.post);
					$("#start_work_date"+obj).val(map.work_date);
					document.getElementById("human_image"+obj).src = "http://10.88.2.241:8080/hr_photo/"+map.employee_cd.substr(0,5)+"/"+map.employee_cd+".JPG";
					
				}else{
					$("#td"+obj).empty();
					$("#td"+obj).append("<input type='file' name='excel_content_public"+id_index+"' id='excel_content_public"+id_index+"' onchange='getFileInfoPublic(this)'/>  ");
					noimg=noimg+obj+",";
				}
				
			} 
		}
		 
		
	}
	//打开选择图片
	   function F_Open_dialog(id) 
       { 
            document.getElementById("excel_content_public"+id).click(); 
       } 
	/**
		 * 选择设备类型树
		 */
		 
		function showDevTypeTreePage(){
			var returnValue={
				fkValue:"",
				value:""
			}
			window.showModalDialog("<%=contextPath%>/rm/dm/deviceXZAccount/selectDevTypeSub.jsp",returnValue,"");
			var  innerHtml="";
			$("#dev_type_name").html("");
			 var selectedProjects=returnValue.value;
				var typename = selectedProjects.split(",");
			 for(var i=0;i<typename.length;i++ ){
			
			    innerHtml+="<option>"+typename[i]+"</option>";
			 }
			$("#dev_type_name").append(innerHtml);
			//var orgId = strs[1].split(":");
			document.getElementById("dev_type_id").value = returnValue.fkValue;
			alert(returnValue.fkValue);
			var retObj = jcdpCallService("DevInsSrv", "getApplyDeviceInfo","dev_type_id="+returnValue.fkValue);
			var deviceids='';
			if (typeof retObj.datas != "undefined"){
				for(var i=0;i<retObj.datas.length;i++){
					deviceids=deviceids+retObj.datas[i].name+',';
				}
				alert(deviceids);
				 $("#dev_model").val(deviceids);
			}
		}
		
	 
		function excelDataAdd(status){
			insertTrPublic('file_tablePublic');
		}
	//新增插入文件
	function insertTrPublic(obj){
		var tmp="public";
			$("#"+obj+"").append(
				"<tr id='file_tr_public'>"+
					"<td class='inquire_item5'>附件：</td>"+
		  			"<td class='inquire_form5'><input type='file' name='excel_content_"+tmp+"' id='excel_content_"+tmp+"' onchange='getFileInfoPublic(this)' class='input_width'/></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublic(this)'  title='删除'></a></span></td>"+
				"</tr>"	
			);
		}
		//删除文件
	function deleteFilePublic(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			var tmp=new Date().getTime();
			$("#file_tablePublic").append("<tr><td class='inquire_item6'>附件:</td>"+
	    			"<td class='inquire_form5'><input type='file' name='excel_content_"+tmp+"' id='excel_content_"+tmp+"' onchange='getFileInfoPublic(this)' class='input_width'/></td>"+
	    			"<td class='inquire_form5'>附件名：</td>"+
					"<td class='inquire_form5'><input type='text' readonly='readonly' name='excel_name_"+tmp+"' id='excel_name_"+tmp+"' class='input_width' /><input type='hidden' id='doc_type_"+tmp+"' name='doc_type_"+tmp+"'></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublic(this)'  title='删除'></a></span></td></tr>");
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
				flag_public = 1;
		}
	}	
	//删除行
	function deleteInputPublic(item){
		flag_public = 0;
		$(item).parent().parent().parent().remove();
		
	}
	 
	
	
	  
	//获取图片绝对路径显示
	function getFileInfoPublic(obj){
		            	 
		// checkImg(obj);
	 
	}
	  //去除字符串重复字段
    function filterRepeatStr(str){ 
	var ar2 = str.split(","); 
	var array = new Array(); 
	var j=0 
	for(var i=0;i<ar2.length;i++){ 
	if((array == "" || array.toString().match(new RegExp(ar2[i],"g")) == null)&&ar2[i]!=""){ 
	array[j] =ar2[i]; 
	array.sort(); 
	j++; 
	} 
	} 
	return array.toString(); 
}
</script>

 
</html>

