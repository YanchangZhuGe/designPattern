<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();	
	String score_id=request.getParameter("scoreID");
	String flag=request.getParameter("flag");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>要素评分</title>
<style type="text/css">
.pagination table{
	float:right;
}

.panel .inquire_item{
	text-align:right;
}
.inquire_form{
	width:180px;
}

.tab_line_height {
	border-color: #1C86EE;
 	border-style: dotted;
 	border-width: 2px;
	width:100%;
	line-height:24px;
	height:24px;
	color:#000;
	margin: 0;
    padding: 0;
}
.tab_line_height td {
	border-color: #1C86EE;
	border-style: dotted;
	line-height:24px;
	border-width: 1px;
	height:24px;
	white-space:nowrap;
	word-break:keep-all;
	margin: 0;
    padding: 0;
}
.panel .panel-body{
	font-size: 12px;
}
input,textarea{
	font-size: 12px;
}
</style>
</head>
<body>
	<!-- 最外层layout -->
	<div class="easyui-layout" data-options="fit:true" >
		<!-- 页面上半部分布局 -->
		<!-- <div id="north" data-options="region:'north',split:true" style="height:365px;"> -->
			<div class="easyui-layout" data-options="fit:true">
				<!-- 页面上半部分的内容 -->
				<div data-options="region:'center',border:false,split:false" > 
					<table id="main_grid">
						<thead>
							<tr>
								<th data-options="field:'detail_id',checkbox:false,align:'center',hidden:true" width="10">主键</th>
								<th data-options="field:'monitor_type',align:'center',hidden:true">monitortype</th>
								<th data-options="field:'monitor_pro_type',align:'center',hidden:true">monitorprotype</th>
								<th data-options="field:'assess_name',align:'center',frozen:true" width="25">一级管理要素</th>
								<th data-options="field:'check_content',align:'center',frozen:true" formatter='showRemark' width="30">二级管理要素</th>
								<th data-options="field:'gjktsyb',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="30">国际勘探事业部</th>
								<th data-options="field:'tlmwtc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="25">塔里木物探处</th>
								<th data-options="field:'xjwtc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="20">新疆物探处</th>
								<th data-options="field:'thwtc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="20">吐哈物探处</th>
								<th data-options="field:'qhwtc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="20">青海物探处</th>
								<th data-options="field:'cqwtc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="20">长庆物探处</th>
								<th data-options="field:'dgwtc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="20">海洋物探处</th>
								<th data-options="field:'lhwtc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="20">辽河物探处</th>
								<th data-options="field:'hbwtc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="20">华北物探处</th>
								<th data-options="field:'xxwtkfc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="28">新兴物探开发处</th>
								<th data-options="field:'zhwhtc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="25">综合物化探处</th>
								<th data-options="field:'xnwtc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="25">西南物探处</th>
								<th data-options="field:'dqygs',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="25">大庆物探一公司</th>
								<th data-options="field:'dqegs',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="25">大庆物探二公司</th>
<!-- 							<th data-options="field:'shwtc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="20">深海物探处</th>
 -->							<th data-options="field:'zbfwc',align:'center',sum:'true',editor:{type:'numberbox',options:{precision:2}}" width="20">装备服务处</th>
								<th data-options="field:'standard_score',align:'center',hidden:true" width="10">标准分</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
					<div style="float:left;height:28px;">
						所属年度: 
					 	<select id="score_year" style="width:100px;"   style="height:25px;">
					   	</select>
					   	所属月份:
					   	<select id="score_month" style="width:100px;" style="height:25px;">
					 		<option value="1">1月</option>
					 		<option value="2">2月</option>
					 		<option value="3">3月</option>
					 		<option value="4">4月</option>
					 		<option value="5">5月</option>
					 		<option value="6">6月</option>
					 		<option value="7">7月</option>
					 		<option value="8">8月</option>
					 		<option value="9">9月</option>
					 		<option value="10">10月</option>
					 		<option value="11">11月</option>
					 		<option value="12">12月</option>
					   	</select>
					   	
					</div>
						<div style="float:left;height:28px;" id="tip">
						&nbsp;&nbsp;&nbsp;&nbsp;提示：满分：1000分 (点击"分数"单元格可修改数据，修改完成，请点击"保存"按钮保存数据)
						</div>
						<div style="float:right;height:28px;" id="saveDiv">
							<easyuiAuth:EasyUIButton functionId="" className="fa fa-floppy-o fa-lg" event="save()" text="保存"></easyuiAuth:EasyUIButton>
							&nbsp;&nbsp;&nbsp;&nbsp;						
						</div>						
					</div>
				</div>
			</div>
		<!-- </div> -->
	</div>
	<div id="win"></div>
</body>
<script type="text/javascript">
var selectTabIndex = 0;
var currentId = "";
var queryParams;
var score_id='<%=score_id%>';
var flag='<%=flag%>';
$(function(){
	//查看界面，隐藏提示框，保存按钮
	if('view'==flag){
	$('#saveDiv').hide();
	$('#tip').hide();
	
	}
	if(score_id!=''&&score_id!='null'){
		var baseData = jcdpCallService("AssessPlatInfoSrv", "getAssessInfo", "score_id="+score_id);
		var nowYear = setScoreYear();
		$("#score_year").val(baseData.nowYear);
		$("#score_month").val(baseData.month+"");
	}else{
		//初始化月份
		var date = new Date;
		var month = date.getMonth()+1;
		$("#score_month").val(month+"");
		//设置年度信息，并初始化年度
		var nowYear = setScoreYear();
		$("#score_year").val(nowYear);
	}
	
	$.extend($.fn.datagrid.methods, {
		editCell: function(jq,param){
			return jq.each(function(){
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor1 = col.editor;
					if (fields[i] != param.field){
						col.editor = null;
					}
				}
				$(this).datagrid('beginEdit', param.index);
				for(var i=0; i<fields.length; i++){
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor = col.editor1;
				}
			});
		},
		statistics: function(jq) {
		    var opt = $(jq).datagrid('options').columns;
		    var rows = $(jq).datagrid("getRows");
		    var footer = new Array();
		    footer['sum'] = "";
		    for (var i = 0; i < opt[0].length; i++) {
		        if (opt[0][i].sum) {
		            footer['sum'] = footer['sum'] + sum(opt[0][i].field, 1) + ',';
		        }
		    }
		    var footerObj = new Array();
		    if (footer['sum'] != "") {
		        var tmp = '{' + footer['sum'].substring(0, footer['sum'].length - 1) + "}";
		        var obj = eval('(' + tmp + ')');
		        if (obj[opt[0][0].field] == undefined) {
		            footer['sum'] += '"' + opt[0][4].field + '":"<b>合计:</b>"';
		            obj = eval('({' + footer['sum'] + '})');
		        } else {
		        	obj[opt[0][4].field] = "<b>合计:</b>" + obj[opt[0][4].field];
		        }
		        footerObj.push(obj);
		    }
		    if (footerObj.length > 0) {
		        $(jq).datagrid('reloadFooter', footerObj);
		    }
		    function sum(filed) {
		        var sumNum = 0;
		        var str = "";
		        for (var i = 0; i < rows.length; i++) {
		            var num = rows[i][filed];
		            sumNum += Number(num);
		        }
		        return '"' + filed + '":"' + sumNum.toFixed(2) + '"';
		    }
		}
	});
	//初始单台设备调配信息
	$("#main_grid").datagrid({ 
		method:'post',
		nowrap:false,
		title:"",
		toolbar:'#tb2',
		border:false,
		striped:true,
		singleSelect:true,//是否单选 
		selectOnCheck:true,
		pagination:false,
		fit:true,//自动大小 
		fitColumns:true,
		showFooter: true,
		onClickRow:function(index,data){
		},
		queryParams:{//必需参数
		score_id:score_id
		},
		url:"${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=AssessPlatInfoSrv&JCDP_OP_NAME=queryMinitorScore",
		onClickCell: onClickCell,
		onLoadSuccess : function(data1) {
			$('#main_grid').datagrid('statistics'); //合计
			$("#main_grid").datagrid("autoMergeCells", ['assess_name']);//合并单元格
            for(var i = 0; i < data1.rows.length; i++){
                if(data1.rows[i].spare3!= undefined){
                    var spare3 = data1.rows[i].spare3;
                }
                tipView('remark-' + i,spare3,'right');
            }
        }			
	});
});

//结束编辑
var editIndex = undefined;
function endEditing(){
	if (editIndex == undefined){return true}
	if ($('#main_grid').datagrid('validateRow', editIndex)){
		$('#main_grid').datagrid('endEdit', editIndex);
	 	var row = $('#main_grid').datagrid('getRows')[editIndex];
	  
	 	if(row.gjktsyb>row.standard_score||row.tlmwtc>row.standard_score||row.xjwtc>row.standard_score||row.thwtc>row.standard_score||
	 		row.qhwtc>row.standard_score||row.cqwtc>row.standard_score||row.dgwtc>row.standard_score||
	 		row.lhwtc>row.standard_score||row.hbwtc>row.standard_score||row.xxwtkfc>row.standard_score||
	 		row.zhwhtc>row.standard_score||row.xnwtc>row.standard_score||row.dqygs>row.standard_score||
	 		row.dqegs>row.standard_score||row.zbfwc>row.standard_score)
								 {
	 	$.messager.alert('提示','这项标准分为'+row.standard_score+' 填写分数请在0 ~ '+row.standard_score +' 之间!','info');
		}
		editIndex = undefined;
		
		return true;
	} else {
		return false;
	}
}
//单击编辑
function onClickCell(index, field){
	if(field != 'assess_name' && field != 'check_content'){
	//if (editIndex != index){
		if (endEditing()){
			$('#main_grid').datagrid('selectRow', index)
					.datagrid('editCell', {index:index,field:field});
			editIndex = index;
			$('#main_grid').datagrid('statistics'); //合计
			$("#main_grid").datagrid("autoMergeCells", ['assess_name']);//合并单元格
		}
	//}	
	}
}
//提交保存
function save(){
	endEditing();
	//var rows = $('#main_grid').datagrid('getChanges');
	var rows = $('#main_grid').datagrid('getRows');
 	var jsonObj2 ={ datas: [ ]};
	if(rows.length>0){
		var str = "";
		for(var i=0;i<rows.length;i++){
			var gjktsyb = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "gjktsyb",value:rows[i].gjktsyb};
			jsonObj2.datas.push(gjktsyb);
			
			var tlmwtc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "tlmwtc",value:rows[i].tlmwtc};
			jsonObj2.datas.push(tlmwtc);
			
			var xjwtc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "xjwtc",value:rows[i].xjwtc};
			jsonObj2.datas.push(xjwtc);
			
			var thwtc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "thwtc",value:rows[i].thwtc};
			jsonObj2.datas.push(thwtc);
			
			var qhwtc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "qhwtc",value:rows[i].qhwtc};
			jsonObj2.datas.push(qhwtc);
			
			var cqwtc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "cqwtc",value:rows[i].cqwtc};
			jsonObj2.datas.push(cqwtc);
			
 			var dgwtc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "dgwtc",value:rows[i].dgwtc};
			jsonObj2.datas.push(dgwtc);
			
			var lhwtc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "lhwtc",value:rows[i].lhwtc};
			jsonObj2.datas.push(lhwtc);
			
			var hbwtc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "hbwtc",value:rows[i].hbwtc};
			jsonObj2.datas.push(hbwtc);
			
			var xxwtkfc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "xxwtkfc",value:rows[i].xxwtkfc};
			jsonObj2.datas.push(xxwtkfc);

			var zhwhtc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "zhwhtc",value:rows[i].zhwhtc};
			jsonObj2.datas.push(zhwhtc);
			
			var xnwtc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "xnwtc",value:rows[i].xnwtc};
			jsonObj2.datas.push(xnwtc);
			
			var dqygs = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "dqygs",value:rows[i].dqygs};
			jsonObj2.datas.push(dqygs);
			
			var dqegs = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "dqegs",value:rows[i].dqegs};
			jsonObj2.datas.push(dqegs);
			
			/* var shwtc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "shwtc",value:rows[i].shwtc};
			jsonObj2.datas.push(shwtc); */
			
			var zbfwc = { element_id: rows[i].element_id, detail_id: rows[i].detail_id, name: "zbfwc",value:rows[i].zbfwc};
			jsonObj2.datas.push(zbfwc);
			
		 	
		}
		// alert(JSON.stringify(jsonObj2));
		//return;
	  $.messager.progress({title:'请稍后',msg:'数据保存中....'}); 
	  $.ajax({
	        type: "POST",
	        url:'${pageContext.request.contextPath}/rm/dm/ajaxSaveBySrvAndMethod.srq?JCDP_SRV_NAME=AssessPlatInfoSrv&JCDP_OP_NAME=saveOrUpdateScore',
	        data:{scoreData:JSON.stringify(jsonObj2),sacoreyear: $("#score_year").val(),sacoremonth: $("#score_month").val(),score_id:score_id},
	        dataType:"json",
	        error: function(request) {
	        	$.messager.progress('close');
	        	$.messager.alert('提示','保存出错,请重新保存或稍后重试<br/>如无法解决联系管理员...','error');
	        },
	        success: function(data) {
	        	//simpleSearch();
	        	window.location.href = '${pageContext.request.contextPath}/dmsManager/autoscore/monitorScoreList.jsp';	
	        	$.messager.progress('close');
	        }
	    });
	}else{
		$.messager.alert('提示','没有修改数据无需保存...','info');
	}
	
}
//指标备注说明
function showRemark(value,row,index){
	return '<div id="remark-'+index+'" style="width:auto;">'+value+'</div>';
}
//设置所属年份
function setScoreYear(){
	var d = new Date();
    var nowYear = +d.getFullYear();
    var endYear=nowYear+1;
    var temp = "";
    
    for (var i=0;i<3;i++){
    	temp+="<option value='"+(endYear-i)+"'>"+(endYear-i)+"年</option>";
    }
    $("#score_year").append(temp);
    return nowYear;
}
</script>
</html>