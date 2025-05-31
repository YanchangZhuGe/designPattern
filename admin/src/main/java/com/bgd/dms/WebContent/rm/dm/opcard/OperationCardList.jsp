<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	UserToken user = OMSMVCUtil.getUserToken(request);
 
	String apply_id="fasle";
	if(resultMsg!=null){
		apply_id=resultMsg.getValue("apply_id");
	}	 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@include file="/common/include/quotesresource.jsp"%>
	<%@include file="/common/include/easyuiresource.jsp"%>
	<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
	<title>设备操作证管理</title>
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
										<option value="1">待审批</option>
										<option value="3">审批通过</option>
										<option value="4">审批不通过</option>
								    </select>
							  	</td>
							  			<td class="ali_cdn_name">设备类型：</td>
				  				<td class="ali_cdn_input">
							   		 <select style="width:120px;" id="dev_type_name" name="dev_type_name">
														<option value=""></option>
												        </select> 
								<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevTypeTreePage()"  />
								<input id="dev_type_id" name="dev_type_id" class="" type="hidden" /></td>
							  	</td>
							  	<td class="ali_cdn_input" colspan="5"> 申请时间: 
			 	 <input name="start_time" id="start_time" class="input_width easyui-datebox" type="text"   style="width:160px" editable="false" />
 			 	 ---
 			 	  <input name="end_time" id="end_time" class="input_width easyui-datebox" type="text"   style="width:160px" editable="false" />
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
								<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
								<!--<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_add"></auth:ListButton>-->
								<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="删除"></auth:ListButton>
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
					<td class="bt_info_even" exp="<input type='radio' name='selectedbox'   value='{apply_id}' id='selectedbox_{apply_id}' />" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td> 
					<td class="bt_info_even" exp="{apply_no}">申请单号</td>
					<td class="bt_info_even" exp="{persons}">申请人数</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="####" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_1"><a href="####" onclick="getContentTab(this,1)">人员信息</a></li>
			    <li id="tag3_2"><a href="####" onclick="getContentTab(this,2)">审批明细</a></li>
			    <li id="tag3_3"><a href="####" onclick="getContentTab(this,3)">附件</a></li>			      
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
					<table id="detailtitletable" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:1px;background:#efefef"> 
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
					</table>
					<div style="height:70%;overflow:auto;">
				      	<table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					   		<tbody id="detailMap" name="detailMap" >
					   		</tbody>
				      	</table>
			        </div>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
					<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
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
		ZJTJ();
	});
	
	$(document).ready(lashen);

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "DevCardSrv";
	cruConfig.queryOp = "queryOp_cardList";
	var path = "<%=contextPath%>";
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<datas.length;i++){
		     var map=datas[i];
			 var html='<tr>';
				 html=html+'<td width="5%">'+map.rowno+'</td>';
				 html=html+'<td width="5%">'+map.employee_name+'</td>';
				 html=html+'<td width="5%">'+map.employee_gender+'</td>';
				 html=html+'<td width="15%">'+map.employee_id_code_no+'</td>';
				 html=html+'<td width="11%">'+map.employee_cd+'</td>';
				 html=html+'<td width="11%">'+map.org_name+'</td>';
				 html=html+'<td width="10%">'+map.work_date+'</td>';
				 html=html+'<td width="9%">'+map.post1+'</td>';
				 if(map.employee_cd==''){
					html=html+"<td width='20%'><img style='width: 85px; height: 120px' src='<%=contextPath%>/doc/downloadDoc.srq?docId="+map.file_id+"' /></td></tr>";
				 }else{
					html=html+"<td width='20%'><img style='width: 85px; height: 120px' src='http://10.88.248.114:8080/hr_photo/img_all/"+map.employee_cd+".JPG' /></td></tr>";
				 }
			$(filterobj).append(html);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	//直接提交
	function ZJTJ(){
		var applyid='<%=apply_id%>';
		if(applyid!='fasle'&&applyid!=''){	 
			//工作流信息
			var submitdate =getdate();
			var curbusinesstype="";
	    	processNecessaryInfo={        							//流程引擎关键信息
				businessTableName:"dms_device_opcardapply",    			//置入流程管控的业务表的主表表明
				businessType:"5110000181000000023",    				//业务类型 即为之前设置的业务大类
				businessId:applyid,           			//业务主表主键值
				businessInfo:"操作证申请流程",
				applicantDate:submitdate       						//流程发起时间
			};
			processAppendInfo={ 
				apply_id:applyid
			};
			loadProcessHistoryInfo();
			 submitProcessInfo();
			 refreshData("","");
		}else{
			
			refreshData("","","");		
		}
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
		$("input[type='radio'][name='selectedbox']").each(function(){
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
				var retObj = jcdpCallService("DevCardSrv", "queryOp_cardList","currentPage=1&pageSize=10&apply_id="+currentid);
				if (typeof retObj.datas != "undefined") {
					var data=retObj.datas[0];
					 $("#apply_unit").val(data.apply_unit);
					 $("#apply_date").val(data.apply_date);
					var retObj1 = jcdpCallService("DevCardSrv", "getApplyDeviceInfoByApply_id","currentPage=1&pageSize=10&apply_id="+currentid);
				 
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
					var retObj = jcdpCallService("DevCardSrv", "loadEmployeeInfoByApplID","apply_id="+currentid);
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
				loadProcessHistoryInfo();
				//$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
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
		//对标题行的宽度进行设置
		aligntitle("#detailtitletable","#detailMap");
	}
	// 复杂查询
	function refreshData(apply_num,apply_status,dev_type_name,owning_org_name,start_time,end_time){
		var temp = "";
		if(typeof start_time!="undefined" && start_time!=""){
			temp += "&start_time="+start_time;
		}
		if(typeof end_time!="undefined" && end_time!=""){
			temp += "&end_time="+end_time;
		}
		if(typeof dev_type_name!="undefined" && dev_type_name!=""){
			temp += "&dev_type_name="+dev_type_name;
		}
		if(typeof owning_org_name!="undefined" && owning_org_name!=""){
			temp += "&owning_org_name="+owning_org_name;
		}
		if(typeof apply_num!="undefined" && apply_num!=""){
			temp += "&apply_no="+apply_num;
		}
		if(typeof apply_status!="undefined" && apply_status!=""){
			temp += "&status="+apply_status;
		}
		 
		cruConfig.submitStr = temp;	
		queryData(1);
	}
	//简单查询
	function simpleSearch(){
	 	var q_apply_num = $("#q_apply_no").val(); 
	    var q_apply_status = $("#q_apply_status").val();
	    	var dev_type_name=$("#dev_type_name").val();
	 	var owning_org_name=$("#owning_org_name").val();
	 	var start_time=$("#start_time").datebox('getValue');
	 	var end_time=$("#end_time").datebox('getValue');
		refreshData(q_apply_num,q_apply_status,dev_type_name,owning_org_name,start_time,end_time);
	}
	//清空查询条件
	function clearQueryText(){
		$("#q_apply_no").val('');
		$("#q_apply_status").val('');
		$("#dev_type_name").html('');
		$("#owning_org_name").val('');
		$("#start_time").datebox('setValue','');
		$("#end_time").datebox('setValue','');
		refreshData("","");
	}
	//删除操作
	function toDelete(){
		var retObj;
		var baseData;
		var ids = getSelIds('selectedbox');
		if(ids==''){ 
			alert("请先选中一条记录!");
	     	return;
		}
		baseData = jcdpCallService("DevCardSrv", "getScrapeState", "apply_id="+ids);
		if(baseData.deviceappMap.proc_status=='1'){
			alert("您选择的记录中存在状态为'待审批'的单据,不能修改!");
			return;
		}else if(baseData.deviceappMap.proc_status=='3'){
			alert("您选择的记录中存在状态为'审批通过'的单据,不能修改!");
			return;
		}
		if (window.confirm("确认要删除吗?")) {
		baseData = jcdpCallService("DevCardSrv", "delApplyInfoByID", "apply_id="+ids);
		if(baseData.result=='1'){
			alert('删除成功!');
			refreshData("","");
		}
		}
	}
	//修改操作
 	function toEdit(){
 		var retObj;
		var baseData;
		var ids = getSelIds('selectedbox');
		if(ids==''){ 
			alert("请先选中一条记录!");
	     	return;
		}
		baseData = jcdpCallService("DevCardSrv", "getScrapeState", "apply_id="+ids);
		if(baseData.deviceappMap.proc_status=='1'){
			alert("您选择的记录中存在状态为'待审批'的单据,不能修改!");
			return;
		}else if(baseData.deviceappMap.proc_status=='3'){
			alert("您选择的记录中存在状态为'审批通过'的单据,不能修改!");
			return;
		}
		window.location.href='<%=contextPath %>/rm/dm/opcard/OperationCertificateApplyEdit.jsp?apply_id='+ids;	
 	}
	function submitToAudit(){
		var retObj;
		var baseData;
		var ids = getSelIds('selectedbox');
		if(ids==''){ 
			alert("请先选中一条记录!");
	     	return;
		}
		    
		baseData = jcdpCallService("DevCardSrv", "getScrapeState", "apply_id="+ids);
		if(baseData.deviceappMap.proc_status=='1'){
			alert("您选择的记录中存在状态为'待审批'的单据,不能提交!");
			return;
		}else if(baseData.deviceappMap.proc_status=='3'){
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
		window.location.href='<%=contextPath %>/rm/dm/opcard/OperationCertificateApply.jsp?flag=add';	
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
		//工作流信息
		var submitdate =getdate();
		var curbusinesstype="";
    	processNecessaryInfo={        							//流程引擎关键信息
			businessTableName:"dms_device_opcardapply",    			//置入流程管控的业务表的主表表明
			businessType:"5110000181000000023",    				//业务类型 即为之前设置的业务大类
			businessId:shuaId,           			//业务主表主键值
			businessInfo:"操作证申请流程",
			applicantDate:submitdate       						//流程发起时间
		};
		processAppendInfo={ 
			apply_id:shuaId
		};
	
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
		 debugger;
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

