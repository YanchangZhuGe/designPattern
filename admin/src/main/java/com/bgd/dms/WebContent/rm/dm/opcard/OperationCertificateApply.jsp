<%@page contentType="text/html;charset=UTF-8"%>
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
	int monthinfo = Integer.parseInt(monthinfostr);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html;   />
  <%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/easyuiresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<style type="text/css">
btn {
	background-image: url("../images/images/gl.png");
}
</style>
 
<title>操作证申请</title>
</head>
<body style="background: #cdddef; overflow-y: auto" onload="get_time()"> 
	<form name="form" id="form" method="post" enctype="multipart/form-data" action="<%=contextPath%>/rm/dm/opcard/saveOrUdateOp_cardApply.srq?flag=add">
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
													<span class="kb"><a href="####"></a></span>申请时间： <span id="apply_date1"></span><input type="hidden" id="apply_date" name="apply_date"/>
														&nbsp;&nbsp;&nbsp;&nbsp;	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申请单位 :<span id="org_name01"><%=org_name %></span>
														<input type="hidden" name="org_name" value="<%=org_name %>"/><span class="gd"><a href="####"></a>
													</span>
												</div>
												<div class="tongyong_box_content_left" id="chartContainer1"
													style="overflow-x: hidden;">
													<table width="100%" border="0" cellspacing="0"
														cellpadding="0" class="tab_info" align="left">
														<tr class="trHeader">
															<td class="bt_info_odd">准许操作设备名称</td>
															<td class="bt_info_even"> <select style="width:120px;" id="dev_type_name" name="dev_type_name">
														<option value=""></option>
												        </select> 
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevTypeTreePage()"  />
								<input id="dev_type_id" name="dev_type_id" class="" type="hidden" /></td>
															<td class="bt_info_odd">准许操作设备型号</td>
															<td class="bt_info_even"><input readonly="readonly" name="dev_model" id="dev_model"></input></td>
														</tr>
														<tr class="trHeader">
														<td class="bt_info_odd" >培训内容</td>
													 
														<td class="bt_info_even" ><input name="train_content" id="train_content"/></td>
														<td class="bt_info_odd" >培训讲师</td>
													 
														<td class="bt_info_even" ><input name="train_teacher"/></td>
														</tr>
														<tr class="trHeader">
														<td class="bt_info_odd"  >培训时间</td>
														<td class="bt_info_even" colspan="3"> 开始时间: 
			 	 <input name="start_time" id="start_time" class="input_width easyui-datebox" type="text"   style="width:160px" editable="false" />
 			 	  结束时间: 
 			 	  <input name="end_time" id="end_time" class="input_width easyui-datebox" type="text"   style="width:160px" editable="false" />
			 	</td>
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
							<span class="dr" style="float:right;margin-top:-4px;">
								<a href="####" onclick="AddExcelData()" title="导入excel"></a>
							</span>
							
								<span   style="float:right;margin-top:-4px;">
								<a href="####"  >&nbsp;&nbsp;&nbsp;</a>
							</span>
							<span  style="float:right;margin-top:-4px;">
								  <a  href="javascript:downloadModel('personinfo','操作证人员信息模板')">下载操作证人员信息模板</a>
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
															<td class="bt_info_odd">准许操作类别，型号</td>
															<td class="bt_info_even">照片</Td>
															<td class="bt_info_odd">操作</Td>
														</tr>
														<tbody id="device_content1">
														<tr id="tr1">
														<td class="bt_info_odd">1</td>
															<td class="bt_info_even"><input id="employee_name1" name="employee_name1"/></td>
															<td class="bt_info_odd"><input id="employee_id1" name="employee_id1" onkeyup="loadEmployeeInfo(1)"/></td>
															<td class="bt_info_even"  ><input id="employee_cd1" name="employee_cd1"/></td>
															<td class="bt_info_odd" ><input id="work_part1" name="work_part1"/></td>
															<td class="bt_info_even"  ><input   id="start_work_date1" name="start_work_date1" style="width:160px" class="input_width easyui-datebox" type="text" /></td>
															<td class="bt_info_odd" ><input id="org_name1" name="org_name1"/></Td>
															<td class="bt_info_even"  ><input id="sex1" name="sex1" style="width:30px;"></input></td>
															<td class="bt_info_even" id="lb1"></td>
															<td class="bt_info_odd" id="td1" >   <img  onclick="F_Open_dialog(1)" id="human_image1"  style="width: 45px; height: 60px;"  src="<%=contextPath%>/humanPhoto/zhaopian.JPG"
							style="width: 85px; height: 120px"  /></div>   <input type='file' name='excel_content_public1' id='excel_content_public1' style="display:none;"/></td>
															<td class="bt_info_even"><button onclick="delEmployee(1)">X</button></td></tr>
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
						event="onclick='excelDataAdd(1)'" title="导入考核成绩文件"></auth:ListButton>
				</tr>
			</table>
			<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_tablePublic">
				<input name="flag_public" id="flag_public" type="hidden"/>
			</table>
												</td>
												</tr>
												 <tr><td><div class="tongyong_box">
												<div class="tongyong_box_title">
												<span style="color:red">提示 ： 上传考试成绩文件</span>
												<div>
												<div>
												</td>
												</td>
												</table>
			<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_tablePublic">
				<input name="flag_public" id="flag_public" type="hidden"/>
			</table>
			</td>
			</tr>
			<tr>
			<td  align="center">
			 
				<input type="checkbox" checked="checked" id="zjtj"></input>保存直接提交			
				<span class="bc_btn"><a id="submitButton" href="####" onclick="toSubmit()"></a></span>
	        	<span class="gb_btn"><a href="####" onclick="toClose()"></a></span></td>
			</tr>
		</table>
		<input id="peoplecount" name="peoplecount" type="hidden"/>
	 	<input id="peopleids" name="peopleids" type="hidden"/>
	 	<input id="peopleidss" name="peopleidss" type="hidden"/>
	 	<input id="ids" name="ids" type="hidden"/>
	 	<input id="noimg" name="noimg" type="hidden"/>
	 	<input id="sftj" name="sftj" type="hidden"/>
	</div>
	</form>
</body>
 

<script type="text/javascript">

var id_index=1;
var peoplecount=1;//培训人数
var peopleids='1,';
var peopleidss='';
var ids='';
var noimg='';
	//关闭操作
	function toClose(){
		window.location.href='<%=contextPath %>/rm/dm/opcard/OperationCardList.jsp';	
	}
	
	//提交方法
	function toSubmit(){
	if($('#dev_model').val()==''){
	alert('请选择设备操作类型');
	return ;
	}
	//培训内容长度限制20
	if($('#train_content').val().length>20){
	alert('培训内容字数限制20个');
	return ;
	}
	//时间判断
	if(!dateCompare($("#start_time").datebox('getValue'),$("#end_time").datebox('getValue'))){
	alert('开始时间不能大于结束时间');
	return;
	}
	
	if($("#employee_id").val()=="")
		{
		alert("请至少添加一个人员信息!");
		return;
		}
		
		if(peopleids==''){
		alert("请至少添加一个人员信息!");
		return;
		}
		var idss=peopleids.split(',');
		 
		var flag = true;
		var i=0;
		$("#device_content1 > tr").each(function(){
			var employee_name = $("#employee_name"+idss[i]).val();
			var employee_id = $("#employee_id"+idss[i]).val();
			var employee_cd = $("#employee_cd"+idss[i]).val();
			var work_part = $("#work_part"+idss[i]).val();
			var start_work_date = $("#start_work_date"+idss[i]).datebox('getValue');
			var org_name = $("#org_name"+idss[i]).val();
			var sex = $("#sex"+idss[i]).val();
			var human_image = $("#human_image"+idss[i]).attr("src");
		 	var human_image1 = $("#excel_content_public"+idss[i]).val();
			if(employee_name == ""){
				alert("第"+(i+1)+"行，姓名不允许为空");
				flag = false;
				return false;
			}
			if(employee_id == ""){
				alert("第"+(i+1)+"行，身份证不允许为空");
				flag = false;
				return false;
			}
			if(employee_cd == ""){
			//	alert("第"+(i+1)+"行，员工编号不允许为空");
			//	flag = false;
			//	return false;
			}
			if(work_part == ""){
				alert("第"+(i+1)+"行，工作部门不允许为空");
				flag = false;
				return false;
			}
			if(start_work_date == ""){
				//alert("第"+(i+1)+"行，工作时间不允许为空");
				//flag = false;
				//return false;
			}
			if(org_name == ""){
				//alert("第"+(i+1)+"行，现在岗位不允许为空");
				//flag = false;
				//return false;
			}
			if(sex == ""){
				alert("第"+(i+1)+"行，性别不允许为空");
				flag = false;
				return false;
			}
			if(human_image1==""&&human_image==undefined){
				alert("第"+(i+1)+"行，图片不允许为空");
				flag = false;
				return false;
			}
			i++;
		});
		if(!flag){
			return;
		}
	var file=$("#excel_content_public").val();
	if(file==""||file==undefined){
	alert("考试成绩附件不允许为空");
	return ;
	}
 
	if(document.getElementById("zjtj").checked){
    $("#sftj").val('yes');
	}else{
	$("#sftj").val('no');
	}
 	$("#peoplecount").val(peoplecount);
 	$("#peopleids").val(peopleids);
 	$("#peopleidss").val(peopleidss);
 	$("#ids").val(ids);
 	$("#noimg").val(noimg);
 		 
 		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			 var subForm = $("#form");
				 subForm.submit();
            }
        });
		
		
	}
	function get_time(){    /**获取当前时间**/	
		var date=new Date();
		var year="",month="",day="",week="",hour="",minute="",second="";
		year=date.getFullYear();
		month=date.getMonth()+1;
		day=date.getDate();
		$("#apply_date1").html(" "+year+"年"+month+"月"+day+"日");
		$("#apply_date").val(" "+year+"年"+month+"月"+day+"日");
	}
	cruConfig.contextPath='<%=contextPath%>';
	//删除用户
	function delEmployee(id){
	peoplecount=peoplecount-1;
	peopleids=peopleids.replace(id+',','');
	peopleidss=peopleidss.replace(id+',','');
	ids=ids.replace($("#employee_id"+id).val()+',','');
		$("#tr"+id).remove();
		debugger;
	}
	//添加用户
	function addEmployee(){
		  // 添加“添加文件”的按钮，
	   
		id_index=id_index+1;
		peoplecount=peoplecount+1;
		peopleids=(peopleids+id_index)+","; 
		var htmls='<tr id="tr'+id_index+'">';
		htmls=htmls+'<td class="bt_info_odd">'+id_index+'</td>';
		htmls=htmls+'<td class="bt_info_even"><input id="employee_name'+id_index+'" name="employee_name'+id_index+'"/></td>';
		htmls=htmls+'<td class="bt_info_odd"><input onkeyup="loadEmployeeInfo('+id_index+')" id="employee_id'+id_index+'" name="employee_id'+id_index+'"/></td>';
		htmls=htmls+'<td class="bt_info_even"  ><input id="employee_cd'+id_index+'" name="employee_cd'+id_index+'"/></td>';
		htmls=htmls+'<td class="bt_info_odd" ><input id="work_part'+id_index+'" name="work_part'+id_index+'"/></td>';
		htmls=htmls+'<td class="bt_info_even"  ><input   id="start_work_date'+id_index+'" name="start_work_date'+id_index+'" type="text" style="width:160px;" class="input_width easyui-datebox" />';
		htmls=htmls+'<td class="bt_info_odd" ><input id="org_name'+id_index+'" name="org_name'+id_index+'"/></Td>';
		htmls=htmls+'<td class="bt_info_odd" ><input id="sex'+id_index+'" style="width:30px;" name="sex'+id_index+'"/></Td>';
		htmls=htmls+"<td class='bt_info_even' id='lb"+id_index+"'></td>";
		htmls=htmls+"<td class='bt_info_even' id='td"+id_index+"'> <img  id='human_image"+id_index+"' style='width: 45px; height: 60px' src='<%=contextPath%>/humanPhoto/zhaopian.JPG' /> <input type='file' name='excel_content_public"+id_index+"' id='excel_content_public"+id_index+"' onchange='getFileInfoPublic(this)' style='display:none'/>  </td>";
		htmls=htmls+'<td class="bt_info_odd"><button onclick="delEmployee('+id_index+')">X</button></td></tr>';
		 	
		var device_content = $("#device_content1");
		var targetObj = $(htmls);
	    $.parser.parse(targetObj);
		device_content.append(targetObj);
	 	  
		// uploader.addButton("#filePicker"+id_index);
		//eval(getsql(id_index));
	}
	
	//根据身份证号查询员工信息
	function loadEmployeeInfo(obj,infos){
	
		var val=$("#employee_id"+obj).val();
	 	
		if(val.length==18){		
				var retObj = jcdpCallService("DevCardSrv", "loadEmployeeInfo","employee_id="+$("#employee_id"+obj).val()+"&time="+new Date().getTime());
				 	  $("#employee_name"+obj).val('');
					//$("#employee_id"+obj).val('');
					  $("#employee_cd"+obj).val('');
					  $("#sex"+obj).val('');
					  $("#work_part"+obj).val('');
					  $("#org_name"+obj).val('');
				      $("#start_work_date"+obj).datebox('setValue','');
				      $("#lb"+obj).empty();
				      //清空人员信息
				 debugger;
				if (typeof retObj.data != "undefined"){
					
				    
					ids=ids+val+",";
					peopleidss=peopleidss+obj+',';
					var map=retObj.data;
					$("#employee_name"+obj).val(map.employee_name);
					$("#employee_id"+obj).val(map.employee_id_code_no);
					$("#employee_cd"+obj).val(map.employee_cd);
					$("#sex"+obj).val(map.employee_gender);
					var retObj1 = jcdpCallService("DevCardSrv", "getApplyDeviceInfoByEmployee_id","employee_id="+$("#employee_id"+obj).val()+"&newdate="+new Date());
					$("#lb"+obj).empty();
					if (typeof retObj1.data != "undefined"){						
						$("#lb"+obj).append("<textarea row='3' cols='20'>"+filterRepeatStr(retObj1.data.type)+"</textarea></br><textarea row='3' cols='20'>"+filterRepeatStr(retObj1.data.name)+"</textarea>");
					}else{						
						$("#lb"+obj).append("<span></span>");
					}
					if(map.employee_cd==''){
						noimg=noimg+obj+",";
						$("#td"+obj).empty();
						$("#td"+obj).append("<input type='file' name='excel_content_public"+id_index+"' id='excel_content_public"+id_index+"' onchange='getFileInfoPublic(this)'/>  ");
					}else{
				 
					
					if($("#human_image"+obj).length==0){
				 
						$("#td"+obj).empty();
						$("#td"+obj).append("<img  id='human_image"+obj+"' style='width: 85px; height: 120px'  />");
					}
					} 
					$("#work_part"+obj).val(map.org_name);
					$("#org_name"+obj).val(map.post);
					$("#start_work_date"+obj).datebox('setValue',map.work_date);
					document.getElementById("human_image"+obj).src = "http://10.88.248.114:8080/hr_photo/img_all/"+map.employee_cd+".JPG";					
				}else{
					$("#td"+obj).empty();
					$("#td"+obj).append("<input type='file' name='excel_content_public"+id_index+"' id='excel_content_public"+id_index+"' onchange='getFileInfoPublic(this)'/>  ");
					noimg=noimg+obj+",";
					 
					if(typeof(infos)!="undefined"&&infos!=null)  {
						 $("#employee_id"+obj).val(infos[0]);
					  $("#employee_name"+obj).val(infos[1]);
					  //$("#employee_cd"+obj).val(infos[2]);
					  $("#sex"+obj).val(infos[6]);
					  $("#work_part"+obj).val(infos[5]);
					 // $("#org_name"+obj).val(infos[5]);
				    //  $("#start_work_date"+obj).datebox('setValue',infos[4]);
				       
					}
				}				
			} 
		 	
	}
	//打开选择图片
	function F_Open_dialog(id){ 
       document.getElementById("excel_content_public"+id).click(); 
    } 
	//选择设备类型树
	function showDevTypeTreePage(){
		var returnValue={
			fkValue:"",
			value:""
		}
		window.showModalDialog("<%=contextPath%>/rm/dm/deviceXZAccount/selectDevTypeSubCZZ.jsp?type=CZZ",returnValue,"");
		var innerHtml="";
		$("#dev_type_name").html("");
	 
		var selectedProjects=returnValue.value;
		var typename = selectedProjects.split(",");
		for(var i=0;i<typename.length;i++ ){			
			innerHtml+="<option>"+typename[i]+"</option>";
		}
		$("#dev_type_name").append(innerHtml);
		document.getElementById("dev_type_id").value = returnValue.fkValue;
		var retObj = jcdpCallService("DevCardSrv", "getApplyDeviceInfo","dev_type_id="+returnValue.fkValue);
			var deviceids='';
			if (typeof retObj.datas != "undefined"){
				for(var i=0;i<retObj.datas.length;i++){
				 
					if (retObj.datas[i].name=='其他'){	
					 $("#dev_model").removeAttr("readonly");//去除input元素的readonly属性
					}else{
					deviceids=deviceids+retObj.datas[i].name+',';
				}
				}
				 
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
		var j=0; 
		for(var i=0;i<ar2.length;i++){ 
		if((array == "" || array.toString().match(new RegExp(ar2[i],"g")) == null)&&ar2[i]!=""){ 
			array[j] =ar2[i]; 
			array.sort(); 
			j++; 
			} 
		} 
		return array.toString(); 
	}
	//比较时间大小
	function dateCompare(startdate,enddate){   
	var arr=startdate.split("-");    
	var starttime=new Date(arr[0],arr[1],arr[2]);    
	var starttimes=starttime.getTime();   
	var arrs=enddate.split("-");    
	var lktime=new Date(arrs[0],arrs[1],arrs[2]);    
	var lktimes=lktime.getTime();   
  
	if(starttimes>lktimes)    
	{   
	return false;   
	}   
	else  
	return true;   
	}  
	//下载人员信息模板
	function downloadModel(modelname,filename){
			filename = encodeURI(filename);
			filename = encodeURI(filename); 
			window.location.href="<%=contextPath%>/rm/dm/xlsmodel/download.jsp?path=/rm/dm/opcard/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	function AddExcelData(){
		
		 var obj=window.showModalDialog('<%=contextPath%>/rm/dm/opcard/planExcelAdd.jsp',"","dialogHeight:500px;dialogWidth:600px");
		obj = decodeURI(obj,'UTF-8');
		obj = decodeURI(obj,'UTF-8');
	   	var infos=obj.split(',');
	   
	   	for(var i=0;i<infos.length;i++){
	  		if(i==0&&id_index==1){
	  		}else{
	  		addEmployee();
	  		}
	  		var infoss=infos[i].split('@');
	  		if(typeof(infoss[0])!="undefined"&&infoss[0]!=null)  {
	  		$("#employee_id"+id_index).val(infoss[0]);
	  		debugger;
	  		loadEmployeeInfo(id_index,infoss);
	  		}
	   	}
		}
</script>
</html>

