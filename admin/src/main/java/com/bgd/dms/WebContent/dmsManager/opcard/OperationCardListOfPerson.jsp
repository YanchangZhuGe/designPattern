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
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
	<title>年度投资建议计划信息</title>
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
							 
				  				 
				  				<td class="ali_query">
				   					<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
								</td>
								<td class="ali_query">
							 		<span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
								</td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="tj" event="onclick='submitToAudit()'" title="查看"></auth:ListButton>
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
					<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox'   value='{employee_id_code_no}' id='selectedbox_{employee_id_code_no}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td> 
					<td class="bt_info_even" exp="{employee_name}">姓名</td>
					<td class="bt_info_even" exp="{employee_gender}">性别</td>
					<td class="bt_info_odd" exp="{org_name}">单位</td>
					<td class="bt_info_even" exp="{post}">部门</td>
					<td class="bt_info_odd" exp="{employee_id_code_no}">身份证号</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">申请单信息</a></li>
			  </ul>
			</div>
		 <div id="tab_box" class="tab_box">
			 <div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
															<td class="inquire_item6">姓名：<input id="employee_name" readonly="readonly"></input></td>
															<td class="inquire_item6">性别：<input id="employee_gender" readonly="readonly"></input></td>
															
															<td class="inquire_item6" id="employee_img" rowspan="4">   </td>
														</tr>
														<tr  >
														<td class="inquire_item6">员工编号：<input id="employee_cd" readonly="readonly"></input></td>
														<td class="inquire_item6">身份证：<input id="employee_id" readonly="readonly"></input></td>
													
														
														 
														</tr>
														<tr  >
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
													 	<tr>
													 	<td class="inquire_item6"  id="status_date">审验周期：<input readonly="readonly" value="24月"/></td>
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
	cruConfig.queryService = "DevInsSrv";
	cruConfig.queryOp = "queryOp_cardListOfPerson";
	var path = "<%=contextPath%>";
	
	var selectedTagIndex = 0;
	 
	// 复杂查询
	function refreshData(employee_name,employee_id){
		var temp = "";
		if(typeof employee_name!="undefined" && employee_name!=""){
			temp += "&employee_name="+employee_name;
		}
		if(typeof employee_id!="undefined" && employee_id!=""){
			temp += "&employee_id="+employee_id;
		}
		 
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData("","","");
	
	
	//简单查询
	function simpleSearch(){
	 	var q_employee_name = $("#q_employee_name").val(); 
	    var q_employee_id = $("#q_employee_id").val();
	 
		refreshData(q_employee_name,q_employee_id);
	}
	//清空查询条件
	function clearQueryText(){
		document.getElementById("q_apply_no").value = "";
		document.getElementById("q_apply_status").value = "";
		 
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
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
 //加载单条记录的详细信息
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
			$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+shuaId+"']").removeAttr("checked");
			//选中这一条checkbox
			$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+shuaId+"']").attr("checked",'true');
		 
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
		var currentid ;
		var employee_id;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
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
				 var baseData = jcdpCallService("DevInsSrv", "getApplyInfoByEmployee_id", "employee_id="+employee_id);
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
		var baseData = jcdpCallService("DevInsSrv", "getApplyInfoByEmployee_id", "employee_id="+employee_id);
		if (typeof baseData.datas != "undefined"&&baseData.datas.length!=0){
	 		var map=baseData.datas[0];
	 		$("#modifi_date").val(map.modifi_date);
			}
				var retObj1 = jcdpCallService("DevInsSrv", "loadEmployeeInfoByApplID", "employee_id="+employee_id);
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
				var retObj1 = jcdpCallService("DevInsSrv", "getApplyDeviceInfoByEmployee_id","employee_id="+employee_id);	
					if (typeof retObj1.data != "undefined"){
					
					 $("#op_type").val(filterRepeatStr(retObj1.data.type));
					 $("#op_model").val(filterRepeatStr(retObj1.data.name));
					
					}	
	} 
    function submitToAudit(){
    
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    var ids = getSelIds('selectedbox');
    		//var apply_id=ids.split('_')[0];
    		//var employee_id=ids.split('_')[1];
      		popWindowAuto('<%=contextPath%>/dmsManager/opcard/OperationCertificateApplyUserInfo.jsp?employee_id_code_no='+ids,'300:200',''); 
		 
   
    }
    
    function appendDataToDetailTab(filterobj,datas,employee_id){
		for(var i=0;i<datas.length;i++){
		     var map=datas[i];
			 var html='<tr>';
							html=html+'<td   width="5%">'+map.rowno+'</td>';
							html=html+'<td   width="5%">'+map.apply_no+'</td>';
							html=html+'<td   width="5%">'+map.train_teacher+'</td>';
				        	html=html+'<td   width="10%">'+map.train_content+'</td>';
							html=html+'<td   width="8%">'+map.train_startdate+'</td>';
							html=html+'<td   width="8%">'+map.train_enddate+'</td>';
						    var retObj1 = jcdpCallService("DevInsSrv", "getApplyDeviceInfoByApply_id","apply_id="+map.apply_id);	
					if (typeof retObj1.data != "undefined"){
					 html=html+'<td   width="15%"><textarea row="3" cols="20" >'+ filterRepeatStr(retObj1.data.type)+'</textarea></td>';
					 html=html+'<td   width="15%"><textarea row="3" cols="20" >'+filterRepeatStr(retObj1.data.name)+'</textarea></td>';
					}	
							 
			$(filterobj).append(html);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
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

