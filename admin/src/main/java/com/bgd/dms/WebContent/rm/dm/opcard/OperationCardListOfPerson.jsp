<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
 <%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/easyuiresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<style type="text/css">
btn {
	background-image: url("../images/images/gl.png");
}
</style>
	<title>操作证用户信息</title>
</head>
<body style="background:#cdddef">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
					  			<td class="ali_cdn_name">姓名：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_employee_name" name="employee_name" type="text" class="input_width" />
					  			</td>
				   				<td class="ali_cdn_name">身份证：</td>
				  				<td class="ali_cdn_input">
							   		 <input id="q_employee_id" name="employee_id" type="text" class="input_width" />
							  	</td>
							  		<td class="ali_cdn_name">设备类型：</td>
				  				<td class="ali_cdn_input">
							   		 <select style="width:120px;" id="dev_type_name" name="dev_type_name">
														<option value=""></option>
												        </select> 
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevTypeTreePage()"  />
								<input id="dev_type_id" name="dev_type_id" class="" type="hidden" /></td>
							  	</td>
							  	<td class="ali_cdn_input" colspan="3"> 开始时间: 
			 	 <input name="start_time" id="start_time" class="input_width easyui-datebox" type="text"   style="width:100px" editable="false" />
 			 	  结束时间: 
 			 	  <input name="end_time" id="end_time" class="input_width easyui-datebox" type="text"   style="width:100px" editable="false" />
			 	</td>
							  	  <td class="ali_cdn_name">所属单位:</td>
         						 <td class="inquire_form8"><input name="owning_org_name" id='owning_org_name' class="" type="text" />
          							<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showOrgTreePage()"  />
								<input id="owning_sub_id" name="owning_sub_id" class="" type="hidden" />
		  						</td>
		  					
		  						
				  				<td class="ali_query">
				   					<span class="cx"><a href="####" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
								</td>
								<td class="ali_query">
							 		<span class="qc"><a href="####" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
								</td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="dy" event="onclick='submitToAudit()'" title="打印"></auth:ListButton>
					  		</tr>
						</table>
					</td>
				   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
				<tr>
					<td class="bt_info_even" exp="<input type='radio' name='selectedbox'   value='{employee_id_code_no}' id='selectedbox_{employee_id_code_no}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td> 
					<td class="bt_info_even" exp="{employee_name}">姓名</td>
					<td class="bt_info_odd" exp="{employee_gender}">性别</td>
					<td class="bt_info_even" exp="{org_name}">单位</td>
					<td class="bt_info_odd" exp="{employee_id_code_no}">身份证号</td>
					<td class="bt_info_even"exp="{modifi_date1}">有效日期</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
					<td width="50">到 
						<label>
							<input type="text" name="textfield" id="textfield" style="width:20px;" />
						</label>
					</td>
					<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		 <div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="####" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_1"><a href="####" onclick="getContentTab(this,1)">申请单信息</a></li>
			  </ul>
			</div>
		 <div id="tab_box" class="tab_box">
			 <div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
				<td class="inquire_item6">姓名：<input id="employee_name" readonly="readonly"></input></td>
				<td class="inquire_item6">性别：<input id="employee_gender" readonly="readonly"></input></td>															
				<td class="inquire_item6" id="employee_img" rowspan="4"></td>
			 </tr>
			 <tr>
				<td class="inquire_item6">员工编号：<input id="employee_cd" readonly="readonly"></input></td>
				<td class="inquire_item6">身份证：<input id="employee_id" readonly="readonly"></input></td>
			 </tr>
			 <tr>
				<td class="inquire_item6" >参加工作时间：<input id="work_date" readonly="readonly"></input></td>
				<td class="inquire_item6" > 工作单位：<input id="org_name" readonly="readonly"></input></td>
			 </tr>
			 <tr>
				<td class="inquire_item6" >工作岗位：<input id="post" readonly="readonly"></input></td>
				<td class="inquire_item6" >准许操作设备类别：<textarea row="3" cols="20" readonly="readonly" id="op_type"></textarea> </td>
			 </tr>
			 <tr>
				<td class="inquire_item6" >准许操作设备型号：<textarea row="3" cols="20" readonly="readonly" id="op_model"></textarea></td>
				<td class="inquire_item6"  >批准时间：<input readonly="readonly" id="modifi_date"/></td>
			 </tr>
		 </table>
		</div>
			<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
							<td class="bt_info_odd" width="5%">序号</td>
				    		<td class="bt_info_even" width="5%">申请单号</td>
				    		<td class="bt_info_odd" width="5%">培训老师</td>
				    		<td class="bt_info_even" width="10%">培训内容</td>
				        	<td class="bt_info_odd" width="8%">培训开始时间</td>
							<td class="bt_info_even" width="8%">培训结束时间</td>
							<td class="bt_info_odd" width="15%">准许操作设备类别</td>
							<td class="bt_info_even" width="15%">准许操作设备型号</td>
							<td class="bt_info_even" width="15%">附件</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
				</div>
</body>
<script type="text/javascript">
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
		
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	});
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "DevCardSrv";
	cruConfig.queryOp = "queryOp_cardListOfPerson";
	var path = "<%=contextPath%>";
		 
	// 复杂查询
	function refreshData(employee_name,employee_id,dev_type_name,owning_org_name,start_time,end_time){
		var temp = "";
		if(typeof start_time!="undefined" && start_time!=""){
			temp += "&start_time="+start_time;
		}
		if(typeof end_time!="undefined" && end_time!=""){
			temp += "&end_time="+end_time;
		}
		if(typeof employee_name!="undefined" && employee_name!=""){
			temp += "&employee_name="+employee_name;
		}
		if(typeof employee_id!="undefined" && employee_id!=""){
			temp += "&employee_id="+employee_id;
		}
		 if(typeof dev_type_name!="undefined" && dev_type_name!=""){
			temp += "&dev_type_name="+dev_type_name;
		}
		if(typeof owning_org_name!="undefined" && owning_org_name!=""){
			temp += "&owning_org_name="+owning_org_name;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData("","","");	
	
	//简单查询
	function simpleSearch(){
	 	var q_employee_name = $("#q_employee_name").val(); 
	    var q_employee_id = $("#q_employee_id").val();
	 	var dev_type_name=$("#dev_type_name").val();
	 	var owning_org_name=$("#owning_org_name").val();
	 	var start_time=$("#start_time").datebox('getValue');
	 	var end_time=$("#end_time").datebox('getValue');
		refreshData(q_employee_name,q_employee_id,dev_type_name,owning_org_name,start_time,end_time);
	}
	//清空查询条件
	function clearQueryText(){
		document.getElementById("q_employee_name").value = "";
		document.getElementById("q_employee_id").value = "";
		 document.getElementById("dev_type_name").value = "";
		document.getElementById("owning_org_name").value = "";
		$("#start_time").datebox('setValue','');
		$("#end_time").datebox('setValue','');
		refreshData("","");
	}
 
	//点击tab页
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	var selected_id = "";//加载数据时，选中记录id
	var tab_index =0;//tab页索引
	var selected_apply_year=""; //选中记录的申请年度
	//点击tab,显示具体tab
	function getTab(index){
		tab_index=index;
		getTab3(index);
		$(".tab_box_content").hide();
		$("#tab_box_content"+index).show();
		loadDataDetail(selected_id);
	}
	//获取日期
	function getdate() { 
		var now=new Date(); 
		y=now.getFullYear(); 
		m=now.getMonth()+1; 
		d=now.getDate(); 
		m=m <10? "0"+m:m; 
		d=d <10? "0"+d:d; 
		return  y + "-" + m + "-" + d ;
	}
	//加载单条记录的详细信息
     function loadDataDetail(shuaId){
    	var retObj;
		if(shuaId!=null){ 	   
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		}	
		//取消其他选中的
		//$("input[type='radio'][name='selectedbox'][id!='selectedbox_"+shuaId+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='radio'][name='selectedbox'][id='selectedbox_"+shuaId+"']").attr("checked",'true');		 
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		
    }
    function getContentTab(obj,index) { 
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid;
		var employee_id;
		$("input[type='radio'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;				 
				employee_id=currentid;
			}
		});
		 
		if(index == 0){
		loadEmployeeInfo(employee_id);
		}
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				 var baseData = jcdpCallService("DevCardSrv", "getApplyInfoByEmployee_id", "employee_id="+employee_id);
				if (typeof baseData.datas != "undefined"   ) {
					basedatas = baseData.datas;	
					//先清空
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas,employee_id);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}}
		$(filternotobj).hide();
		$(filterobj).show();
		}
    //根据身份证号查询员工信息
	function loadEmployeeInfo(employee_id){
		$("#employee_img").empty();
		var baseData = jcdpCallService("DevCardSrv", "getApplyInfoByEmployee_id", "employee_id="+employee_id);
		if (typeof baseData.datas != "undefined"&&baseData.datas.length!=0){
	 		var map=baseData.datas[0];
	 		$("#modifi_date").val(map.modifi_date1);
		}
		var retObj1 = jcdpCallService("DevCardSrv", "loadEmployeeInfoByApplID", "employee_id="+employee_id);
		if (typeof retObj1.datas != "undefined"&&retObj1.datas.length!=0){
	 		var map=retObj1.datas[0];
	 		$("#employee_name").val(map.employee_name);
	 		$("#employee_gender").val(map.employee_gender);
	 		$("#employee_id").val(map.employee_id_code_no);
	 		$("#employee_cd").val(map.employee_cd);
	 		$("#org_name").val(map.org_name);
	 		$("#work_date").val(map.work_date);
	 		$("#post").val(map.post);
			var html='';
			if(map.employee_cd==''){
				html=html+"<img style='width: 85px; height: 120px' src='<%=contextPath%>/doc/downloadDoc.srq?docId="+map.file_id+"' />";
			}else{
				html=html+" <img style='width: 85px; height: 120px' src='http://10.88.2.241:8080/hr_photo/"+map.employee_cd.substr(0,5)+"/"+map.employee_cd+".JPG' /> ";
			}
			$("#employee_img").append(html);				 
		}
		var retObj1 = jcdpCallService("DevCardSrv", "getApplyDeviceInfoByEmployee_id","employee_id="+employee_id);	
		if (typeof retObj1.data != "undefined"){					
			$("#op_type").val(filterRepeatStr(retObj1.data.type));
			$("#op_model").val(filterRepeatStr(retObj1.data.name));					
		}	
	} 
    //查询详细信息，打印信息
    function submitToAudit(){   
		var ids = getSelIds('selectedbox');
		if(ids==''){ 
			alert("请先选中一条记录!");
	     	return;
		}
		var ids = getSelIds('selectedbox');
      	popWindowAuto('<%=contextPath%>/rm/dm/opcard/OperationCertificateApplyUserInfo.jsp?employee_id_code_no='+ids,'300:100','');
    }
    
    function appendDataToDetailTab(filterobj,datas,employee_id){
		for(var i=0;i<datas.length;i++){
		     var map=datas[i];
			 var html='<tr>';
				 html=html+'<td width="5%">'+map.rowno+'</td>';
				 html=html+'<td width="5%">'+map.apply_no+'</td>';
				 html=html+'<td width="5%">'+map.train_teacher+'</td>';
				 html=html+'<td width="10%">'+map.train_content+'</td>';
				 html=html+'<td width="8%">'+map.train_startdate+'</td>';
			     html=html+'<td width="8%">'+map.train_enddate+'</td>';
				 var retObj1 = jcdpCallService("DevCardSrv", "getApplyDeviceInfoByApply_id","apply_id="+map.apply_id);	
					if (typeof retObj1.data != "undefined"){
						 html=html+'<td   width="15%"><textarea row="3" cols="20" >'+ filterRepeatStr(retObj1.data.type)+'</textarea></td>';
					 	 html=html+'<td   width="15%"><textarea row="3" cols="20" >'+filterRepeatStr(retObj1.data.name)+'</textarea></td>';
					}	
				html=html+"<td><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+map.file_id+"'>"+map.file_name+"</a></td>";						 
			$(filterobj).append(html);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	Array.prototype.unique3 = function(){
 	var res = [];
 	var json = {};
 	for(var i = 0; i < this.length; i++){
  	if(!$.trim(json[this[i]])){
  	 res.push($.trim(this[i]));
  	 json[this[i]] = 1;
  	}
 	}
 	return res;
	}
  	//去除字符串重复字段
    function filterRepeatStr(str){ 	
		var ar2 = str.replace(new RegExp('\n',"gm"),'').split(","); 
		 
		return ar2.unique3();
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
</script>
</html>

