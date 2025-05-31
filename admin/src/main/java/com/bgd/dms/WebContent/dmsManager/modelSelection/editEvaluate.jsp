<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%
	String contextPath = request.getContextPath();
	String score_id = request.getParameter("score_id");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String addUpFlag = request.getParameter("addupflag");	
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<style>
.datagrid-row-selected {
  background: #00bbee;
  color: #fff;
}
</style>
<title>填写用户信息</title>
</head>
<body class="bgColor_f3f3f3">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content" style="background-color: rgb(241, 242, 243)">
    <div id="new_table_box_bg">
      <fieldset style="margin:2px;padding:2px;"><legend>基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
       <tr>
          
          <td class="inquire_item4">&nbsp;填写日期:</td>
		  <td class="inquire_form4">
		  	  <input type="text" name="in_date" id="in_date" value="<%=appDate %>" class="input_width easyui-datebox" style="width:130px" editable="false" required/>
		  </td>
      
			<td class="inquire_item4">&nbsp;组织机构:</td>
            <td class="inquire_form4">
	          	<input name="orgname" id="orgname" class="input_width easyui-validatebox" type="text" value="" data-options="tipPosition:'top'" readonly required/>
	          	<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showOrgTreePage()" />
	          	<input name="orgid" id="orgid" class="input_width" type="hidden"  value="" />
          	</td>
		  
        </tr>
        <tr>
         <td class="inquire_item4">&nbsp;选择供应商</td>
		  <td class="inquire_form4">
		  		<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showselectEnterpriseEvaluate()" />
		  </td>
        </tr>
      </table>
      </fieldset>
       <fieldset style="margin:2px;padding:2px;"><legend>评价信息</legend>
       <div id="tabsMain">
         
       </div>
       </fieldset>
    </div>
      <div id="oper_div" style="padding-top:6px;">
      	<input id="score_id" name="score_id" type="hidden" value='<%=score_id%>'>
      	<input id="jsonobj" name="jsonobj" type="hidden">
      	<input id="company_id" name="company_id" type="hidden">
      
		 <a href="####" id="submitButton" class="easyui-linkbutton" onclick="save()"><i class="fa fa-floppy-o fa-lg"></i> 保 存 </a>
		 &nbsp;&nbsp;&nbsp;&nbsp;
		 <a href="####" class="easyui-linkbutton" onclick='newClose()'><i class="fa fa-times fa-lg"></i> 关 闭 </a>
	</div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	 
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var score_id = '<%=score_id%>';
	var addupflag = '<%=addUpFlag%>';

	$(document).ready(function() {
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
		//为必填项添加红星
		$("#form1").renderRequiredLabel();
		if(addupflag == 'up'){
			$("#orgimg").hide();//用户名不能修改
		}
		refreshData();
	});
	 
	 //选择用户组织机构树
	function showOrgTreePage(){
		var obj = new Object();
		window.showModalDialog("<%=contextPath%>/common/selectOrg.jsp",obj);
		if(obj.value!=undefined){
			$("#orgname").val(obj.value);
			$("#orgid").val(obj.fkValue);
			tipView('orgname',obj.value,'top');
		}
	}
	 //选择供应商
	function showselectEnterpriseEvaluate(){
		var obj = new Object();
		window.showModalDialog("<%=contextPath%>/common/selectEnterpriseEvaluate.jsp",obj);
		if(obj.ids!=undefined){
		 $("#tabsMain").html('');
		 var retAddedObj = jcdpCallService("ModelApply","addeditEvaluate","ids="+obj.idss);
			debugger;
			var columns= [];
			var columndevname={};
			columndevname["field"]="coding_name";
			columndevname["title"]="指标";
			columndevname["width"]=20;
			columns.push(columndevname);
			var coding_code_id={};
			coding_code_id["field"]="coding_code_id";
			coding_code_id["title"]="id";
			coding_code_id["width"]=20;
			coding_code_id["hidden"]=true;
			columns.push(coding_code_id);
			for(var i=0;i<obj.names.length;i++){
			$("#company_id").val($("#company_id").val()+obj.ids[i]+",");
			var column={};
			column["field"]="aa"+obj.ids[i];
			column["title"]=obj.names[i];
			column["width"]=20;
			//column["editor"]={type:'numberbox'};
			columns.push(column);
			}
	
   			 
    var dynamicTable = $('<table id="tbTest"></table>');
    //这里一定要先添加到currentTabPanel中，因为dynamicTable.datagrid()函数需要调用到parent函数
    $("#tabsMain").html(dynamicTable);
    dynamicTable.datagrid({  
   	    nowrap:false,  
		fitColumns:true,   
        columns:[columns ],
        onClickRow: onClickRow,
		singleSelect:true
        });
        debugger;
        $("#tbTest").datagrid('loadData',retAddedObj.datas);  
      		for(var i=0;i<obj.names.length;i++){
			var e = $("#tbTest").datagrid('getColumnOption', "aa"+obj.ids[i]); 
			e.editor = {type:'numberbox'};
     	 	}
		}
	}
	//提交保存
	function save(){
		 	$("#tbTest").datagrid('endEdit',lastIndex);//结束编辑数据
            var allRows=$("#tbTest").datagrid('getRows');   //获取所有被选中的行
    		lastIndex=-1;
    		$("#jsonobj").val(JSON.stringify(allRows));
    		//$(allRows).each(function(index,element){ 
    		//    var score=element.oil_num;
    		//});
			$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	            if (data) {
	            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
	    			$("#submitButton").attr({"disabled":"disabled"});
	    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/modelSelection/companyscore.srq";
	    			document.getElementById("form1").submit();
	            }
	        });
		 
	}
	//修改时加载用户信息
	function refreshData(){
		if(score_id != 'null' && score_id!=''){
			var retObj = jcdpCallService("EquipmentSelectionApply", "getCompanyScoreInfoByScoreId", "score_id="+score_id);
			debugger;
			if(typeof retObj.ids!="undefined"){
			$("#in_date").datebox('setValue',retObj.apply.in_date);
			$("#orgname").val(retObj.apply.org_name);
			$("#orgid").val(retObj.apply.in_org_id);
			var ids=retObj.ids.split(",");
			var names=retObj.names.split(",");
			var columns= [];
			var columndevname={};
			columndevname["field"]="coding_name";
			columndevname["title"]="指标";
			columndevname["width"]=20;
			columns.push(columndevname);
			var coding_code_id={};
			coding_code_id["field"]="coding_code_id";
			coding_code_id["title"]="id";
			coding_code_id["width"]=20;
			coding_code_id["hidden"]=true;
			columns.push(coding_code_id);
			for(var i=0;i<names.length;i++){
			$("#company_id").val($("#company_id").val()+ids[i]+",");
			var column={};
			column["field"]="aa"+ids[i];
			column["title"]=names[i];
			column["width"]=20;
			columns.push(column);
			}
	
   			 
    var dynamicTable = $('<table id="tbTest"></table>');
    //这里一定要先添加到currentTabPanel中，因为dynamicTable.datagrid()函数需要调用到parent函数
    $("#tabsMain").html(dynamicTable);
    dynamicTable.datagrid({  
   	    nowrap:false,  
		fitColumns:true,   
        columns:[columns ],
        onClickRow: onClickRow,
		singleSelect:true,
		showFooter: true
        });
        debugger;
        $("#tbTest").datagrid('loadData',retObj.datas);  
        $('#tbTest').datagrid('reloadFooter',retObj.footer);  
           
      		for(var i=0;i<ids.length;i++){
			var e = $("#tbTest").datagrid('getColumnOption', "aa"+ids[i]); 
			e.editor = {type:'numberbox'};
     	 	}
	 
			}
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
</script>
</html>
