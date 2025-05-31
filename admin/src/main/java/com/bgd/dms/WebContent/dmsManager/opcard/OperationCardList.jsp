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
					  			<td class="ali_cdn_name">单号：</td>
					  			<td class="ali_cdn_input">
					   				<input id="q_apply_no" name="apply_no" type="text" class="input_width" />
					  			</td>
				   				<td class="ali_cdn_name">审批状态：</td>
				  				<td class="ali_cdn_input">
							   		<select id="q_apply_status" name="apply_status" type="text" class="select_width">
								    	<option value="">请选择</option>
								    <option value="0">未提交</option>
						<option value="2">待审批</option>
						<option value="1">审批通过</option>
						<option value="3">审批不通过</option>
								    </select>
							  	</td>
							 
				  				 
				  				<td class="ali_query">
				   					<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
								</td>
								<td class="ali_query">
							 		<span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
								</td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
								<!--<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>-->
								<!--<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>-->
								<auth:ListButton functionId="" css="tj" event="onclick='submitToAudit()'" title="提交"></auth:ListButton>
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
						<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox'   value='{apply_id}' id='selectedbox_{apply_id}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td> 
					<td class="bt_info_even" exp="{apply_no}">申请单号</td>
					<td class="bt_info_odd" exp="{apply_unit}">申请单位</td>
					<td class="bt_info_even" exp="{apply_date}">申请日期</td>
					<td class="bt_info_odd" exp="{apply_person}">申请人</td>
					<td class="bt_info_even" exp="{status}">状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">人员信息</a></li>
			     <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
			     <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			      
			  </ul>
			</div>
		<div id="tab_box" class="tab_box">
			 <div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
				<td class="inquire_item6">申请单位</td>
				<td class="inquire_form6"><input id="apply_unit" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">申请时间</td>
				<td class="inquire_form6"><input id="apply_date" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">准许操作设备名称</td>
				<td class="inquire_form6"><textarea rows="3" cols="30" id="op_type"  ></textarea></td>
				
			  </tr>
				<tr>
				<td class="inquire_item6">准许操作设备型号</td>
				<td class="inquire_form6"><textarea id="op_model"  rows="3" cols="30"></textarea></td>
				<td class="inquire_item6">培训内容</td>
				<td class="inquire_form6"><input id="train_content" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">培训老师</td>
				<td class="inquire_form6"><input id="train_teacher" name="" class="input_width" type="text" /></td>
			  </tr>
				<tr>
				<td class="inquire_item6">培训开始时间</td>
				<td class="inquire_form6"><input id="train_startdate" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">培训结束</td>
				<td class="inquire_form6"><input id="train_enddate" name="" class="input_width" type="text" /></td>
			  </tr>
			</table>
		</div>
		
		<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
							<td class="bt_info_odd" width="5%">序号</td>
				    		<td class="bt_info_even" width="5%">姓名</td>
				    		<td class="bt_info_odd">性别</td>
				        	<td class="bt_info_even" width="15%">身份证</td>
							<td class="bt_info_odd" width="11%">员工编号</td>
							<td class="bt_info_even" width="11%">工作单位</td>
							<td class="bt_info_odd" width="10%">工作时间</td>
							<td class="bt_info_even" width="9%">现在岗位</td>
						 	<td class="bt_info_odd" width="20%">照片</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
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
	cruConfig.queryOp = "queryOp_cardList";
	var path = "<%=contextPath%>";
	
	var selectedTagIndex = 0;
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<datas.length;i++){
		     var map=datas[i];
			 var html='<tr>';
							html=html+'<td   width="5%">'+map.rowno+'</td>';
							html=html+'<td   width="5%">'+map.employee_name+'</td>';
							html=html+'<td   width="5%">'+map.employee_gender+'</td>';
				        	html=html+'<td   width="15%">'+map.employee_id_code_no+'</td>';
							html=html+'<td   width="11%">'+map.employee_cd+'</td>';
							html=html+'<td   width="11%">'+map.org_name+'</td>';
							html=html+'<td   width="10%">'+map.work_date+'</td>';
							html=html+'<td   width="9%">'+map.post+'</td>';
							if(map.employee_cd==''){
							html=html+"<td width='20%'><img style='width: 85px; height: 120px' src='<%=contextPath%>/doc/downloadDoc.srq?docId="+map.file_id+"' /></td></tr>";
							}else{
							html=html+"<td width='20%'><img style='width: 85px; height: 120px' src='http://10.88.2.241:8080/hr_photo/"+map.employee_cd.substr(0,5)+"/"+map.employee_cd+".JPG' /></td></tr>";
							}
			$(filterobj).append(html);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
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
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
				currentid = currentid.split("_")[0];
			}
		});
		 
		if(index == 0){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var retObj = jcdpCallService("DevInsSrv", "queryOp_cardList","currentPage=1&pageSize=10&apply_id="+currentid);
			if (typeof retObj.datas != "undefined"   ) {
				var data=retObj.datas[0];
				 $("#apply_unit").val(data.apply_unit);
				 $("#apply_date").val(data.apply_date);
				// $("#op_type").val(data.op_type);
				// $("#op_model").val(data.op_model);
				var retObj1 = jcdpCallService("DevInsSrv", "getApplyDeviceInfoByApply_id","currentPage=1&pageSize=10&apply_id="+currentid);
			 
				if (typeof retObj1.data != "undefined"   ) {
				  $("#op_type").val(filterRepeatStr(retObj1.data.type));
				  $("#op_model").val(retObj1.data.name);
				}
				 $("#train_content").val(data.train_content);
				 $("#train_teacher").val(data.train_teacher);
				 $("#train_startdate").val(data.train_startdate);
				 $("#train_enddate").val(data.train_enddate);
									
			}
			
			}
			}
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
					var retObj = jcdpCallService("DevInsSrv", "loadEmployeeInfoByApplID","apply_id="+currentid);
				if (typeof retObj.datas != "undefined"   ) {
					basedatas = retObj.datas;	
					//先清空
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
		 
			}
				
			}	 
		if(index == 2){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
			}}
		if(index == 3){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
			}}
		$(filternotobj).hide();
		$(filterobj).show();
		}
	// 复杂查询
	function refreshData(apply_num,apply_status){
		var temp = "";
		if(typeof apply_num!="undefined" && apply_num!=""){
			temp += "&apply_no="+apply_num;
		}
		if(typeof apply_status!="undefined" && apply_status!=""){
			temp += "&status="+apply_status;
		}
		 
		cruConfig.submitStr = temp;	
		queryData(1);
	}

	refreshData("","","");
	
	
	//简单查询
	function simpleSearch(){
	 	var q_apply_num = $("#q_apply_no").val(); 
	    var q_apply_status = $("#q_apply_status").val();
	 
		refreshData(q_apply_num,q_apply_status);
	}
	//清空查询条件
	function clearQueryText(){
		document.getElementById("q_apply_no").value = "";
		document.getElementById("q_apply_status").value = "";
		 
		refreshData("","");
	}
 
	function submitToAudit(){
			var retObj;
			var baseData;
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    
		baseData = jcdpCallService("DevInsSrv", "getScrapeState", "apply_id="+ids);
		if(baseData.deviceappMap.proc_status=='1')
		{
			alert("您选择的记录中存在状态为'待审批'的单据,不能提交!");
			return;
		}
			else if(baseData.deviceappMap.proc_status=='3')
		{
			alert("您选择的记录中存在状态为'审批通过'的单据,不能提交!");
			return;
		}
		if (window.confirm("确认要提交吗?")) {
			submitProcessInfo();
			alert('提交成功!');
			refreshData("","");
		}
	
	}
	
	//新增
	function toAdd(){
		window.location.href='<%=contextPath %>/dmsManager/opcard/OperationCertificateApply.jsp?flag=add';	
	}
	
	 
	//清空表格
	function clearCommonInfo(){
		var qTable = getObj('commonInfoTable');
		for (var i=0;i<qTable.all.length; i++) {
			var obj = qTable.all[i];
			if(obj.name==undefined || obj.name=='') continue;
			
			if (obj.tagName == "INPUT") {
				if(obj.type == "text") 	obj.value = "";		
			}
		}
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
		//工作流信息
		var submitdate =getdate();
		var curbusinesstype="";
    	processNecessaryInfo={        							//流程引擎关键信息
			businessTableName:"dms_device_opcardappply",    			//置入流程管控的业务表的主表表明
			businessType:"5110000181000000023",    				//业务类型 即为之前设置的业务大类
			businessId:shuaId,           			//业务主表主键值
			businessInfo:"操作证申请流程",
			applicantDate:submitdate       						//流程发起时间
		};
		processAppendInfo={ 
			apply_id:shuaId
		};
		loadProcessHistoryInfo();
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

