<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="code" prefix="code"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="java.util.*"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo= user.getProjectInfoNo();
	String org_subjection_id = user.getSubOrgIDofAffordOrg();
	String year = String.valueOf((new Date()).getYear()+1900);
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
<script type="text/javascript" src="<%=contextPath%>/op/costTargetShare/costTargetShareCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<title>油料、小油品费用测算表</title>
</head>

<body style="background:#fff" >
      	<div id="list_table" >
			<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">物探处</td>
			    <td class="ali_cdn_input">
			    <code:codeSelect   name='orgId'  option="orgCommOps" selectedValue="" onchange="refreshData()"  addAll="true"/> 
			    </td>
			    <td class="ali_cdn_name">年度</td>
			    <td class="ali_cdn_input">
			    <select id="year" onchange="refreshData();">
			    	<option value="">请选择</option>
			    	<option value="2010">2010</option>
			    	<option value="2011">2011</option>
			    	<option value="2012">2012</option>
			    	<option value="2013">2013</option>
			    	<option value="2014">2014</option>
			    	<option value="2015">2015</option>
			    	<option value="2016">2016</option>
			    </select>
			    </td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton css="bc" event="onclick='saveDatas()'" title="JCDP_save"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table id="editionList" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
			    	<tr class="bt_info">
			    		<td class="bt_info_odd"><INPUT id="checkbox" name="checkbox" onclick="checkAllNodes()" name=rdo_entity_id  type=checkbox></td>
			    	    <td  class="bt_info_even">序号</td>
			            <td class="bt_info_odd">类型</td>
			            <td  class="bt_info_even">预期指标（万元）</td>
			        </tr>            
			   </table>
			</div>
			<div id="fenye_box" style="display: none;">
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
			            </label></td>
			          <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			        </tr>
			      </table>
			</div>
  </div>
</body>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
var rowsCount=2;
var queryListAction = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=OPCostSrv&JCDP_OP_NAME=getOrgIncomeIndex&projectInfoNo=<%=projectInfoNo%>";
document.getElementById("year").value ='<%=year%>';

document.getElementById("orgId").value ='<%=org_subjection_id%>';
if('<%=org_subjection_id%>'!='C105'){
	document.getElementById("orgId").disabled = true;
}
function simpleSearch(){
	if($("#orgId").val()==''){
		alert("请选择物探处");
		return ;
	}
	if($("#year").val()==''){
		alert("请选择年度");
		return ;
	}
	refreshData();
}

function clearQueryText(){
	$("#orgId").val('');
	$("#year").val('');
	refreshData();
}
refreshData();
function refreshData(ids){
	var submitStr = "currentPage=1&pageSize=10000";
	
	if($("#orgId").val()!=''){
		submitStr+="&orgId="+$("#orgId").val();
	}
	if($("#year").val()!=''){
		submitStr+="&year="+$("#year").val();
	}
	appConfig.queryListAction = queryListAction;
	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,submitStr);
	
	renderNaviTable(tbObj,queryRet);
	
	var datas = queryRet.datas;
	deleteTableTr("editionList");
	if(datas != null&&datas.length>0){
		for (var i = 0; i< queryRet.datas.length; i++) {
			var tr = document.getElementById("editionList").insertRow();		
             	if(i % 2 == 1){  
             		tr.className = "even";
			}else{ 
				tr.className = "odd";
			}
            var td = tr.insertCell();
    		td.innerHTML = '<INPUT id="fy'+i+'checkbox" name="rdo_entity_id" checked="checked"  value="'+datas[i].incomeIndexId+'" type=checkbox>'+
    		 '<input type="hidden" id="fy'+i+'income_index_id" name="fy'+i+'income_index_id" value="'+datas[i].incomeIndexId+'" class="input_width"/>'+
    		 '<input type="hidden" id="fy'+i+'type" name="fy'+i+'type" value="'+datas[i].type+'" class="input_width"/>';;
    		
    		var td = tr.insertCell();
			td.innerHTML = datas[i].rownum;
			
			var td = tr.insertCell();
			if(datas[i].type==0){
				td.innerHTML = '收入指标';
			}else{
				td.innerHTML = '利润指标';
			}
			
			var td = tr.insertCell();
			td.innerHTML =  '<input type="text" id="fy'+i+'money" name="fy'+i+'money" value="'+datas[i].money/10000.0+'" class="input_width"/>';
		}
	}else{
		for (var i = 0; i< 2; i++) {
			var tr = document.getElementById("editionList").insertRow();		
             	if(i % 2 == 1){  
             		tr.className = "even";
			}else{ 
				tr.className = "odd";
			}
            var td = tr.insertCell();
    		td.innerHTML = '<INPUT id="fy'+i+'checkbox" name="rdo_entity_id"  checked="checked"   value="" type=checkbox>'+
    		'<input type="hidden" id="fy'+i+'income_index_id" name="fy'+i+'income_index_id" value="" class="input_width"/>'+
    		'<input type="hidden" id="fy'+i+'type" name="fy'+i+'type" value="'+i+'" class="input_width"/>';
    		
    		var td = tr.insertCell();
			td.innerHTML = i+1;
			
			
			var td = tr.insertCell();
			if(i==0){
				td.innerHTML = '收入指标';
			}else{
				td.innerHTML = '利润指标';
			}
			
			var td = tr.insertCell();
			td.innerHTML =  '<input type="text" id="fy'+i+'money" name="fy'+i+'money" value="" class="input_width"/>' ;
			
		}	
	}
	var tbObj=document.getElementById("editionList");
}

 dataInfo={
		 type:"",
		 money:""
 };
 
 dataInfoForSum={
		 sum_oil_price:"本项目承担油料费(元)",
		 sum_small_oil_price:"本项目承担小油品费用(元)"
 };
 
 function saveDatas(){
	 var submitStr=getCheckTrInfo();
	 submitStr=submitStr+'&orgId='+$("#orgId").val()+'&year='+$("#year").val()
	 if($("#fy0money").val()==''||$("#fy1money").val()==''){
		alert("金额不能为空"); 
		return;
	 }
	 var retObj = jcdpCallService("OPCostSrv", "saveCostIncomeIndex", submitStr);
	 if(retObj!=null && retObj.returnCode=='0'){
		 alert("保存成功");
	 }
	 refreshData();
 }
 
 function getCheckTrInfo(){
		var submitStr="";
		var checkNums="";
		for(var i=0;i<rowsCount;i++){
			checkNums+=i+",";
			for(j in dataInfo){
				dataInfo[j]=document.getElementById('fy'+i+j).value;
			}
			submitStr+=toQueryString("fy"+i,dataInfo);
		}
		if(submitStr!=""){
			submitStr+="&checkNums="+checkNums;
		}
		submitStr+="&dataInfoStrs="+getDataInfo();
		return submitStr;
}
function loadDataDetail(clickId){
	 
 }
 
</script>

</html>

