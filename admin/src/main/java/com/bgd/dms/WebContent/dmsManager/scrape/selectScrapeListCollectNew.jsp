<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String suborgid = user.getSubOrgIDofAffordOrg();
	int orgidlength = suborgid.length();
 
	String scrape_apply_id = request.getParameter("scrape_apply_id");
	String scrape_type = request.getParameter("scrape_type");
	String file_type = request.getParameter("file_type");
 
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<%@include file="/common/include/quotesresource.jsp"%>
 <title>设备台账详情</title>
 <style>
.datagrid-row-selected {
  background: #00bbee;
  color: #fff;
}
</style>
<script type= "text/javascript">
var ISTONGGUO = [{ "value": "通过", "text": "通过" }, { "value": "不通过", "text": "不通过" }];  
</script>
  
 </head> 


 <body style="background:#F1F2F3;overflow:auto" >
      	<div id="list_table" style="height:520px;">
			  	<table    id="queryRetTable">
						<thead>
							<tr>
								<th data-options="field:'scrape_detailed_id',checkbox:true,align:'center',dc:false" width="10">主键</th>
								<th data-options="field:'asset_coding',align:'center',sortable:'true'" width="30">设备编号</th>
								<th data-options="field:'dev_coding',align:'center',sortable:'true'" width="30">ERP设备编码</th>
								<th data-options="field:'dev_name',align:'center',sortable:'true'" width="35">设备名称</th>
								<th data-options="field:'dev_model',align:'center',sortable:'true'" width="30">规格型号</th>
								<th data-options="field:'license_num',align:'center',sortable:'true'" width="30">牌照号</th>
								<th data-options="field:'producting_date',align:'center',sortable:'true'" width="30">启用时间</th>
								<th data-options="field:'asset_value',align:'center',sortable:'true'" width="20">原值</th>
								<th data-options="field:'net_value',align:'center',sortable:'true'" width="15">净额</th>
								<th data-options="field:'duty_unit1',align:'center',sortable:'true'" width="45" >责任单位</th>
								<th data-options="field:'sp_pass_flag',align:'center',sortable:'true',editor:{ type:'combobox',options:{ data: ISTONGGUO, valueField: 'value', textField: 'text'} }" width="40" formatter="isTongGuo">是否通过</th>
								<th data-options="field:'sp_bak1',align:'center',editor:{type:'text'}" width="40" >意见</th>
							</tr>
						</thead>
				</table>
				 <div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">
						 
							&nbsp;&nbsp;设备名称：<input id="dev_name" name="dev_name" class="input_width query" style="width:80px;float:none;">		
							&nbsp;&nbsp;规格型号：<input id="dev_model" name="dev_model" class="input_width query" style="width:80px;float:none;">	
							&nbsp;&nbsp;启用时间：  <input type="text" name="start_date" id="start_date"   class="input_width easyui-datebox" style="width:130px" editable="false" />
				  			&nbsp;至&nbsp;
				  			<input type="text" name="end_date" id="end_date"   class="input_width easyui-datebox" style="width:130px" editable="false" />
							&nbsp;&nbsp;责任单位：<input id="duty_unit" name="dev_model" class="input_width query" style="width:80px;float:none;">			
							&nbsp;&nbsp;评审状态：<select id="pass_flag"><option value="0">请选择</option><option value="1">未评审</option><option value="2">评审通过</option><option value="3">评审不通过</option></select>
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
							<a href="####" class="easyui-linkbutton" onclick="batch()"><i class="fa fa-minus-square fa-lg"></i>批量操作</a>
						</div>
						</div>
		 </div>
	</div>
	<div id="oper_div">
        <span class="tj_btn"><a href="#" onclick="saveInfo()" title=""></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">

$(function(){
	//$("#list_table").css("height",+document.body.offsetWidth-500+"px")
	 
	$("#queryRetTable").datagrid({ 
		method:'post',
		nowrap:false,
		rownumbers:true,//行号 
		title:"",
		toolbar:'#tb2',
		border:false,
		singleSelect:false,//是否单选 
		pagination:true,//分页控件 
		selectOnCheck:true,
		onClickRow: onClickRow,
		fit:true,//自动大小 
		fitColumns:true, 
		queryParams: {
        scrape_type: '<%=scrape_type%>',
        file_type: '<%=file_type%>',
        scrape_apply_id: '<%=scrape_apply_id%>'},
		pageList: [ 50, 100,500,1000,2000,4000],
		url:"${pageContext.request.contextPath}/dmsManager/safekeeping/queryKeepingConfInfoList.srq?JCDP_SRV_NAME=ScrapeSrv&JCDP_OP_NAME=getDivMessageNew",
	});
})	
 
//add by zzb
	function saveInfo(){
		 
		$("#queryRetTable").datagrid('endEdit',lastIndex);//结束编辑数据
        var allRows=$("#queryRetTable").datagrid('getSelections');   //获取所有被选中的行
        debugger;
    	lastIndex=-1;
    	var jsonstr=JSON.stringify(allRows);
	    var retObj = jcdpCallService("ScrapeSrv", "updateCollectScrapeDetailedInfo", "jsonstr="+jsonstr); 
	    searchDevData();
	    alert('操作成功');
	}
	function isTongGuo(value,row,index){
		if(value == ""||value=='0') {
		    return "通过";
		 }else  {
		    return "不通过";
		 }
	}
	
	var lastIndex;
	function onClickRow(rowIndex){
			 
			if (lastIndex != rowIndex){
						$(this).datagrid('endEdit', lastIndex);
						$(this).datagrid('beginEdit', rowIndex);
			}
			lastIndex = rowIndex;
		} 
    //查询及返回刷新
	function searchDevData(){
		//组织查询条件
		var params = {};
		params["pass_flag"] = $("#pass_flag").val(); 
		params["dev_name"] = $("#dev_name").val(); 
		params["dev_model"] = $("#dev_model").val(); 
		params["start_date"] = $("#start_date").datebox('getValue'); 
		params["end_date"] = $("#end_date").datebox('getValue'); 
		params["duty_unit"] = $("#duty_unit").val(); 
		params["scrape_type"] = '<%=scrape_type%>'; 
		params["file_type"] = '<%=file_type%>'; 
		params["scrape_apply_id"] = '<%=scrape_apply_id%>'; 
	//必须条件
	queryParams = params;
	$("#queryRetTable").datagrid('reload',queryParams);
	 
}
	function clearQueryText(){
		$("#dev_name").val(''); 
		$("#dev_model").val(''); 
		$("#start_date").datebox('setValue',''); 
		$("#end_date").datebox('setValue',''); 
		$("#duty_unit").val(''); 
		}
	function batch(){
	debugger;
	   $("#queryRetTable").datagrid('endEdit',lastIndex);//结束编辑数据
	   var allRows=$("#queryRetTable").datagrid('getRows');   //获取所有被选中的行
	   var pass=allRows[0].sp_pass_flag;
	   if(pass=='通过'){
	   pass="0";
	   }else{
	   pass="1";
	   }
	   var sp_bak1=allRows[0].sp_bak1;
	   for(var i=0;i<allRows.length;i++){
	    $('#queryRetTable').datagrid('updateRow',{
 		index: i,
 		row: {
 		sp_pass_flag: pass,
 		sp_bak1: sp_bak1
 		}});
	   }
	   $('#queryRetTable').datagrid('selectAll');
	  
	}
</script>
</html>