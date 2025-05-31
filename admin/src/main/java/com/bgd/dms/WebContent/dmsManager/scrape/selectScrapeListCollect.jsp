<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String suborgid = user.getSubOrgIDofAffordOrg();
	int orgidlength = suborgid.length();
	String org_name=new String(request.getParameter("org_name").getBytes("ISO-8859-1"),"GB2312");
	String org_id=request.getParameter("org_id");
	String dev_name=new String(request.getParameter("dev_name").getBytes("ISO-8859-1"),"GB2312");
	String dev_type=request.getParameter("dev_type");
	String times=new String(request.getParameter("times").getBytes("ISO-8859-1"),"GB2312");
	String dev_model = new String(request.getParameter("dev_model").getBytes("ISO-8859-1"),"GB2312");
	String scrape_apply_id = request.getParameter("scrape_apply_id");
	String scrape_type = request.getParameter("scrape_type");
	String project_name=new String(request.getParameter("project_name").getBytes("ISO-8859-1"),"GB2312");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<!-- ext -->
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 
 <title>设备台账详情</title>
<script type= "text/javascript">
var scrapeType1 = new Array(
          [ '0', '正常报废'],
          [ '1', '技术淘汰'],
          [ '2', '毁损'],
          [ '3', '盘亏']
          );
</script>
  
 </head> 


 <body style="background:#F1F2F3;overflow:auto" onload="refreshData('','','','')">
      	<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
      	<input name="scrape_detailed_ids" id="scrape_detailed_ids" type="hidden"/>
      	<div id="list_table">
      	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="query_dev_name" name="query_dev_name" type="text" class="input_width"/>
			    </td>
			    <td class="ali_cdn_name">ERP设备编号</td>
			    <td class="ali_cdn_input">
			    	<input id="query_dev_coding" name="query_dev_coding" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">排序字段</td>
			    <td class="ali_cdn_input">
			    	<select  id="query_order_num" name="query_order_num">
			    		<option value="" selected="selected">--请选择--</option>
						<option value="dev_name">设备名称</option>
						<option value="dev_coding">ERP设备编号</option>
						<option value="owning_org_name_desc">所属单位</option>
			    	</select>
			    </td>
			    <td class="ali_cdn_input">
			    	<select  id="query_order_type" name="query_order_type">
						<option value="asc" selected="selected">升序</option>
						<option value="desc">降序</option>
			    	</select>
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div>
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" >		
			    <tr id='device_hireapp_id_{device_hireapp_id}' name='device_hireapp_id' ondblclick='toModifyDetail(this)' idinfo='{device_hireapp_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{scrape_detailed_id}' id='selectedbox_{scrape_detailed_id}'/>" >
			     		选择
			     	</td>
					<td class="bt_info_even" exp="{asset_coding}">资产编号</td>
					<td class="bt_info_even" exp="{dev_type}">设备编号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{producting_date}">启用时间</td>
					<td class="bt_info_even" exp="{dev_date}">折旧年限</td>
					<td class="bt_info_even" exp="/">事业部</td>
					<td class="bt_info_even" exp="/">经理部</td>
					<td class="bt_info_even" exp="/">部门/小队</td>
					<td class="bt_info_even" exp="1">数量</td>
  					<td class="bt_info_even" exp="{asset_value}">原值</td>
					<td class="bt_info_even" exp="/">累计折旧</td>
					<td class="bt_info_even" exp="/">减值准备</td>
					<td class="bt_info_even" exp="{net_value}">净额</td>
 					<td class="bt_info_even" exp="{scrape_type}" func= "getOpValue,scrapeType1">报废原因</td>
					<td class="bt_info_even" exp="{org_name}">责任单位</td>
			     </tr> 
			  </table>
			</div>
			<div style="display:block">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="">
			  		<tr>
			  			<td width="10">&nbsp;</td>
						<td>全选&nbsp;<input type='checkbox' id='checkedAll' name='checkedAll' onclick="changeSelect();"/></td>
					</tr>
				</table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
	</div>
	<div id="oper_div">
        <span class="tg_btn"><a href="#" onclick="saveInfo()" title=""></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
   </form>
</body>
<script type="text/javascript">

function changeSelect(){
	var checkvalue = document.getElementById('checkedAll');//
	$("input[type='checkbox'][name^='selectedbox']").attr('checked',checkvalue.checked);
};
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ScrapeSrv";
	cruConfig.queryOp = "getDivMessage";
	var path = "<%=contextPath%>";

function frameSize(){
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
function searchDevData(){
	var query_dev_name = document.getElementById("query_dev_name").value;
	var query_dev_coding = document.getElementById("query_dev_coding").value;
	var query_order_num = document.getElementById("query_order_num").value;
	var query_order_type = document.getElementById("query_order_type").value;
	//query_dev_name,query_dev_coding ,query_order_num,query_order_type;
	refreshData(query_dev_name,query_dev_coding ,query_order_num,query_order_type);
}
 function refreshData(query_dev_name,query_dev_coding ,query_order_num,query_order_type){
	var scrape_apply_id = '<%=scrape_apply_id%>';
	var org_name=decodeURI('<%=org_name%>');
	var org_id='<%=org_id%>';
	var dev_name=decodeURI('<%=dev_name%>');
	var dev_type='<%=dev_type%>';
	var times=decodeURI('<%=times%>');
	var dev_model = decodeURI('<%=dev_model%>');
	var scrape_type = '<%=scrape_type%>';
	var project_name='<%=project_name%>';
      	var temp = "";
      	if(typeof project_name!="undefined" && project_name!=""){
			temp += "&project_name="+project_name;
		}
      	if(typeof scrape_apply_id!="undefined" && scrape_apply_id!=""){
			temp += "&scrape_apply_id="+scrape_apply_id;
		}
      	if(typeof org_name!="undefined" && org_name!=""){
			temp += "&org_name="+org_name;
		}
      	//if(typeof org_id!="undefined" && org_id!=""){
		//	temp += "&org_id="+org_id;
		//}
      	if(typeof dev_name!="undefined" && dev_name!=""){
			temp += "&dev_name="+dev_name;
		}
		if(typeof dev_type!="undefined" && dev_type!=""){
			temp += "&dev_type="+dev_type;
		}
		if(typeof times!="undefined" && times!=""){
			temp += "&times="+times;
		}
		if(typeof dev_model!="undefined" && dev_model!=""){
			temp += "&dev_model="+dev_model;
		}
		if(typeof query_dev_name!="undefined" && query_dev_name!=""){
			temp += "&query_dev_name="+query_dev_name;
		}if(typeof query_dev_coding!="undefined" && query_dev_coding!=""){
			temp += "&query_dev_coding="+query_dev_coding;
		}if(typeof query_order_num!="undefined" && query_order_num!=""){
			temp += "&query_order_num="+query_order_num;
		}if(typeof query_order_type!="undefined" && query_order_type!=""){
			temp += "&query_order_type="+query_order_type;
		}
		if(typeof scrape_type!="undefined" && scrape_type!=""){
			temp += "&scrape_type="+scrape_type;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}
//add by zzb
	function saveInfo(){
		var ids = getSelectedNow();
		if(ids==""){
			alert("未选中任何信息");
			return;
		}
		$("#scrape_detailed_ids").val(ids);
		//zjb start
		Ext.MessageBox.wait('正在操作','请稍后...');
		Ext.Ajax.request({
					url : "<%=contextPath%>/dmsManager/scrape/updateDetailed.srq",
					method : 'Post',
					isUpload : true,  
					async :  true,
					form : "form1",
					success : function(resp){
						 Ext.MessageBox.hide();
						 window.returnValue = "1";
					  	 window.close();
					},
					callback :function(){
						 Ext.MessageBox.hide();
						 window.returnValue = "2";
					  	 window.close();
					},
					failure : function(resp){// 失败
						 Ext.MessageBox.hide();
						 window.returnValue = "3";
					  	 window.close();
						/* Ext.MessageBox.confirm('提示','保存失败！'); */
					}
				});
		//zjb end
		//折损部分结束
	}
	function getSelectedNow(){
		var ids = "";
		var obj = document.getElementsByName("selectedbox");  
		for (i=0; i<obj.length; i++){
			if(obj[i].checked){
				ids +="'"+obj[i].value+"',";
			} 
		}
		return ids;
	}
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i].disabled==false && obj[i]==cb) obj[i].checked = true; 
            else obj[i].checked = false;
        }
    } 
</script>
</html>