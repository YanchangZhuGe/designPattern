<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String scrape_apply_id = request.getParameter("scrape_apply_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 
<title>报废汇总表</title>
<style type="text/css">
table tr{
 height:40px;       /*把table标签的行高设定为固定值*/
}
#new_table_box_bg {
	width:auto;
	border:1px #aebccb solid;
	background:#f1f2f3;
	padding:10px;
	overflow:auto;
}
@media Print { .noprint { DISPLAY: none }}
</style>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
    <div id="new_table_box_bg">
     	<div align="right" class="noprint">
     	 	<span class='dy'><a href='####' onclick='myprint()'  title='打印'></a></span>
     	 	<span class='bc'><a href='####' onclick='toEditEmp()'  title='保存'></a></span>
    	</div>
    	<div><p align="center"><font style="FONT-SIZE: 24px">盘亏、毁损设备报废审批表</font></p><br/></div>
	      <div id='scrape_apply' name='scrape_apply'>
	      	  <table width="95%" border="0" cellspacing="0" cellpadding="0"  align="center">
	      	  	<tr><td>
	      	  		<div><b>填报单位(盖章)：</b> </div>
	      	  	</td></tr>
	      	  </table>
		      <table width="95%" border="1" cellspacing="0" cellpadding="0"  align="center">
		        <tr>
		          <td class="inquire_item6">设备名称</td>
		          <td class="inquire_form6" id="dev_name">
 		          </td>
		          <td class="inquire_item6">规格型号</td>
		          <td class="inquire_form6">见附表</td>
		          <td class="inquire_item6">固定资产编号</td>
		          <td class="inquire_form6">见附表</td>
		        </tr>
		        <tr>
		          <td class="inquire_item6">原值</td>
		          <td class="inquire_form6" id="asset_value"></td>
		          <td class="inquire_item6">实物标记号</td>
		          <td class="inquire_form6"></td>
		          <td class="inquire_item6">设备编号</td>
		          <td class="inquire_form6"></td>
		        </tr>
		        <tr>
		          <td class="inquire_item6">牌照号</td>
		          <td class="inquire_form6"></td>
		          <td class="inquire_item6">投产日期</td>
		          <td class="inquire_form6">见附表</td>
		          <td class="inquire_item6">报废原因</td>
		          <td class="inquire_form6" id="scrape_type"></td>
		        </tr>
		        <tr style="height:150px">
		          <td class="inquire_item6">损失原因</td>
		          <td class="inquire_form6"  colspan="5" id="lose_dev_reasons">
					<textarea rows="6" style="height: 150px;" name="lose_dev_reason" id="lose_dev_reason" class="textarea"  value=""></textarea>
		          </td>
		        </tr>
		        <tr>
		          <td style="text-align:center;align:center" colspan="2">资产所属单位</td>
		          <td style="text-align:center;align:center" colspan="2">资产所属单位<br/>财务资产管理部门</td>
		          <td style="text-align:center;align:center" colspan="2">资产所属单位<br/>设备管理部门</td>
		        </tr>
		        <tr style="height:250px">
		          <td colspan="2">
		          	<div id="dwfzr" name="dwfzr" style="border:none" readonly>单位负责人:</div><br/>
		          </td>
		          <td colspan="2">
		          	<div id="zkjs" name="zkjs" style="border:none" readonly>总会计师:</div><br/></td>
		          <td colspan="2">
		          	<div id="sbglbmfzr" name="sbglbmfzr" style="border:none" readonly>设备管理部门负责人:</div><br/>
		          </td>
		        </tr>
		      </table>
		      <table width="95%" border="1" cellspacing="0" cellpadding="0"  align="center">
			      <tr>
			          <td style="text-align:center;align:center" colspan="3">公司财务资产处</td>
			          <td style="text-align:center;align:center" colspan="3">公司设备物资处</td>
		          </tr>
			      <tr style="height:250px">
			          <td colspan="3">
			          	<div>负责人:唐士俊<br/><br/><br/><div style="float:right">年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;</div></div></td>
			          <td colspan="3">
			          	<div>负责人:范国仓<br/><br/><br/><div style="float:right">年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;&nbsp;</div></div></td>
			        </tr>
		      </table>
	       </div>
    </div>
</form>
</body>
<script type="text/javascript">
function refreshData(){
	var baseData;
	if('<%=scrape_apply_id%>'!='null'){
		baseData = jcdpCallService("ScrapeSrv", "getScrapeDamageMessage", "scrape_apply_id="+'<%=scrape_apply_id%>');
		if(baseData.scrapeDetailMap!=null){
			$("#dev_name").append(baseData.scrapeDetailMap.dev_name);
			$("#dev_name").attr("title",baseData.scrapeDetailMap.dev_name_title);
			$("#asset_value").append(baseData.scrapeDetailMap.asset_value);
			$("#scrape_type").append(baseData.scrapeDetailMap.scrape_type);
			$("#lose_dev_reason").val(baseData.scrapeDetailMap.lose_dev_reason);
		}else{
			$("#scrape_apply").empty();
			$("#scrape_apply").append("暂无数据");
		}
		spmx('<%=scrape_apply_id%>');
	}
}
/**
 * 审批明细************************************************************************************************************************
 */
function spmx(shuaId){
	if (shuaId != null) {
		var baseData = jcdpCallService("ScrapeSrvNew", "getScrapeApplyInfo", "scrape_apply_id="+shuaId);
		var retObj = baseData.scrapeAppFlowList;
		var size = $("#spmx_body", "#tab_box_content2").children("tr").size();
		if (size > 0) {
			$("#spmx_body", "#tab_box_content2").children("tr").remove();
		}
		if (retObj != undefined) {
			for (var i = 0; i < retObj.length; i++) {
				//动态新增表格retObj[i].examine_end_date
				if(retObj[i].node_name=='单位负责人审批'&&retObj[i].curstate=='审核通过'){
					$("#dwfzr").append(retObj[i].examine_user_name+"<br/><br/><br/><div style='float:right'>"+getDateType(retObj[i].examine_end_date)+"</div>");
				}else if(retObj[i].node_name=='总会计师审批'&&retObj[i].curstate=='审核通过'){
					$("#zkjs").append(retObj[i].examine_user_name+"<br/><br/><br/><div style='float:right'>"+getDateType(retObj[i].examine_end_date)+"</div>");
				}else if(retObj[i].node_name=='设备管理部门负责人审批'&&retObj[i].curstate=='审核通过'){
					$("#sbglbmfzr").append(retObj[i].examine_user_name+"<br/><br/><br/><div style='float:right'>"+getDateType(retObj[i].examine_end_date)+"</div>");
				}
			}
		}
	}
}
function getDateType(str){
	    var year =str.substr(0,4)+"年";
	    var month = str.substr(5,2)+"月";
	    var day = str.substr(8,2)+"日";
	    return year+month+day;
}
//打印
function myprint()
{
	 var lose_dev_reason = $("#lose_dev_reason").val();
	 $("#lose_dev_reasons").empty();
	 $("#lose_dev_reasons").append(lose_dev_reason);
	 document.body.innerHTML=document.getElementById('new_table_box_bg').innerHTML;
	 window.print();
	 location.reload();
}
//打开保养计划修改界面
function toEditEmp(){
	var scrape_apply_id='<%=scrape_apply_id%>';
	if('<%=scrape_apply_id%>'!='null'){
	 if($("#lose_dev_reason").val().length>50){
		 alert("鉴定信息长度不能超过50字符");
		 return;
	 }else if($("#lose_dev_reason").val()!="")
		Ext.MessageBox.wait('请等待','处理中');
		Ext.Ajax.request({
			url : "/DMS/dmsManager/scrape/UpdateLoseDevReason.srq",
			method : 'Post',
			isUpload : true,  
			params : {
				scrape_apply_id :scrape_apply_id,
				lose_dev_reason :$("#lose_dev_reason").val(),
				type:'damage'
			},
			success : function(resp){
				alert("保存成功!");
				Ext.MessageBox.hide();
			},
			failure : function(resp){// 失败
				alert("保存失败！");
				Ext.MessageBox.hide();
			}
		});
	}
}
</script>
</html>