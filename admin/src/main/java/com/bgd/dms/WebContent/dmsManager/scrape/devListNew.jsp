<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%
String contextPath = request.getContextPath();
UserToken user = OMSMVCUtil.getUserToken(request);
String userId = user.getSubOrgIDofAffordOrg();
ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String codeId = "";
	codeId = request.getParameter("codeId");
	
	String bussId = request.getParameter("bussId");
	
	String scrape_apply_id = request.getParameter("scrape_apply_id");
	
	String scrapeType = request.getParameter("scrapeType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript">
var scrapeType1 = new Array(
		['0','正常报废'],
		['1','技术淘汰'],
		['2','毁损'],
		['3','盘亏']
		);
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>无标题文档</title>
</head>

<body onload="refreshData()">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	    <td background="<%=contextPath%>/images/list_15.png">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_name" name="s_wz_name" type="text" /></td>
		 	    <td class="ali_cdn_name">设备编码：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_id" name="s_wz_id" type="text" /></td>
		 	      <td class="ali_cdn_name">项目名/国家名：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_project_name" name="s_project_name" type="text" /></td>
		 	    <td class="ali_cdn_name">报废原因</td>
			    <td class="ali_cdn_input" style="width: 130px;">
			    	<select id="s_scrape_type">
			    	 
			    	
			    	</select>
			    </td>
			     <td class="ali_cdn_name">关联状态</td>
			    <td class="ali_cdn_input" style="width: 130px;">
			    	<select id="emp_id">
			    		<option value="">--请选择--</option>
			    		<option value="已关联">已关联</option>
			    		<option value="未关联">未关联</option>
			    		 
			    	</select>
			    </td>
				<td class="ali_cdn_name">责任单位：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_duty_unit" name="s_duty_unit" type="text" /></td>
				<auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			    <td></td>
			    <td></td>
			    <td><font color="red">*</font></td>
			    <auth:ListButton functionId="" css="dk" event="onclick='setlink()'" title="鉴定及关联附件"></auth:ListButton>
			  </tr>
			</table>
		</td>
	    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
	  </tr>
	</table>
	</div>
	<div id="table_box">
	  <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	    <tr>
	      <td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{scrape_detailed_id}'/>"><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
	      <td class="bt_info_even" exp="{project_name}">项目名/国家名</td>
	      <td class="bt_info_even" exp="{duty_unit}">责任单位</td>
	      <td class="bt_info_even" exp="{dev_coding}">设备编号</td>
	      <td class="bt_info_odd" exp="{dev_type}">设备编码</td>
	      <td class="bt_info_even" exp="{dev_name}">设备名称</td>
	      <td class="bt_info_odd" exp="{dev_model}">规格型号</td>
	      <td class="bt_info_even" exp="{license_num}">牌照号</td>
	      <td class="bt_info_odd" exp="{producting_date}">启用时间</td>
	      <td class="bt_info_even" exp="{dev_date}">折旧年限</td>
	      <td class="bt_info_odd" exp="/">事业部</td>
	      <td class="bt_info_even" exp="/">经理部</td>
	      <td class="bt_info_odd" exp="/">部门/小队</td>
	      <td class="bt_info_even" exp="1">数量</td>
	      <td class="bt_info_odd" exp="{asset_value}">原值</td>
	      <td class="bt_info_even" exp="/">累计折旧</td>
	      <td class="bt_info_odd" exp="/">减值准备</td>
	      <td class="bt_info_even" exp="{net_value}">净额</td>
	      <td class="bt_info_odd" exp="{scrape_type}" func="getOpValue,scrapeType1">报废原因</td>
	      <td class="bt_info_odd" exp="{emp_id}">关联状态</td>
	    </tr>
	  </table>
	</div>
	<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
</body>
<script type="text/javascript">
var selectAllFlag=false;
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		selectAllFlag = checkvalue;
		$("input[type='checkbox'][name^='selectedbox']").attr('checked',checkvalue);
	});
});
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }

function frameSize(){
	setTabBoxHeight();
}
function setTabBoxHeight(){
	if(lashened==0){
		$("#table_box").css("height",$(window).height()*0.76);
	}
	$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height()-10);
	$("#tab_box .tab_box_content").each(function(){
		if($(this).children('iframe').length > 0){
			$(this).css('overflow-y','hidden');
		}
	});
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">
	var rootId = "8ad889f13759d014013759d3de520003";
	cruConfig.contextPath =  "<%=contextPath%>";
	var userId = '<%=userId%>';
	function getQueryString(name) {
	    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	    var r = window.location.search.substr(1).match(reg);
	    if (r != null) return unescape(r[2]);
	    return null;
	    }
	
	function refreshData(){
		var codeId = getQueryString("codeId");
		if(codeId =="C105"){
			codeId="";
		}
		var sql ='';
		var bussId = "<%=bussId%>";
		var scrapeType = "<%=scrapeType%>";
		if(scrapeType=='01'){
		$("#s_scrape_type").empty(); 
		$("#s_scrape_type").append("<option value='0'>正常报废</option>"); //为Select追加一个Option(下拉项) 
		$("#s_scrape_type").append("<option value='1'>技术淘汰</option>"); //为Select追加一个Option(下拉项) 
			    		
		}else if(scrapeType=='23'){
		$("#s_scrape_type").empty(); 
		$("#s_scrape_type").append("<option value='2'>毁损</option>"); //为Select追加一个Option(下拉项) 
		$("#s_scrape_type").append("<option value='3'>盘亏</option>"); //为Select追加一个Option(下拉项) 
		
			    		
		}
 		
		var scrape_apply_id = "<%=scrape_apply_id%>";
		//if(codeId !=null && codeId != rootId && bussId!=null){
			sql += " select distinct t.*, ";
			sql += "case  when to_char(sysdate,'yyyy') - to_char(t.producting_date,'yyyy')>=8 and to_char(sysdate,'yyyy') - to_char(t.producting_date,'yyyy') <100 then '八年及以上' ";
	        sql += "when to_char(sysdate,'yyyy') - to_char(t.producting_date,'yyyy')>=5 and to_char(sysdate,'yyyy') - to_char(t.producting_date,'yyyy') <8 then '五年到八年' ";
	        sql += "when to_char(sysdate,'yyyy') - to_char(t.producting_date,'yyyy')>=3 and to_char(sysdate,'yyyy') - to_char(t.producting_date,'yyyy') <5 then '三年到五年' ";
	        sql += "when to_char(sysdate,'yyyy') - to_char(t.producting_date,'yyyy')>=1 and to_char(sysdate,'yyyy') - to_char(t.producting_date,'yyyy') <3 then '一年到三年' ";
			sql += "when to_char(sysdate,'yyyy') - to_char(t.producting_date,'yyyy')>=0 and to_char(sysdate,'yyyy') - to_char(t.producting_date,'yyyy') <1 then '一年以内' ";
			sql += "else '未知时段' end as dev_date, ";
			sql +="case when d.file_id is not null then '已关联' else '未关联' end as emp_id from dms_scrape_detailed t ";
			sql += " left join dms_scrape_detailed_link_file d on t.scrape_detailed_id = d.scrape_detailed_id ";
			sql += " where bsflag ='0' ";
			if(codeId !=null && codeId != rootId){
				sql += " and t.dev_type='"+codeId+"'";
			}
			if(scrape_apply_id!=null){
				sql +=" and scrape_apply_id='"+scrape_apply_id+"'";
			}
			if(scrapeType!=null)
			{
				if(scrapeType=='01'){
					sql +=" and scrape_type in('0')";
					$("#s_scrape_type").val('0');
				}else if(scrapeType=='23'){
					sql +=" and scrape_type in('2')";
					$("#s_scrape_type").val('2');
				}
			}
			sql +=" order by t.dev_coding desc";
		 
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/dmsManager/scrape/devListNew.jsp";
		cruConfig.pageSize='100';
		queryData(1);
	}
       function simpleSearch(){
    	   var codeId = getQueryString("codeId");
   			if(codeId =="C105"){
   				codeId="";
   			}
    	   var bussId = "<%=bussId%>";
    	   var scrapeType = "<%=scrapeType%>";
   		   var scrape_apply_id = "<%=scrape_apply_id%>";
    	   var sql ='';
    	   var project_name=$("#s_project_name").val();
    	   var wz_name = document.getElementById("s_wz_name").value;
		   var wz_id = document.getElementById("s_wz_id").value;
		   var wz_scrape_type = document.getElementById("s_scrape_type").value;
		   var wz_dutyUnit = document.getElementById("s_duty_unit").value;
		   var emp_id=$("#emp_id").val();
		   sql += "select distinct * from ( select t.*,case when d.file_id is not null then '已关联' else '未关联' end as emp_id from dms_scrape_detailed t ";
		   sql += " left join dms_scrape_detailed_link_file d on t.scrape_detailed_id = d.scrape_detailed_id ";
		   sql += " where bsflag ='0' ";
			if(codeId !=null && codeId != rootId){
				sql += " and t.dev_type='"+codeId+"'";
			}
			//有时候相同的设备编号dev_type对应不同的设备名称，所以将来要加入一个判断设备名称的方法
			if(scrape_apply_id!=null){
				sql +=" and scrape_apply_id='"+scrape_apply_id+"'";
			}
			if(scrapeType!=null)
			{
				if(scrapeType=='01'){
					sql +=" and scrape_type in('0','1')";
				}else if(scrapeType=='23'){
					sql +=" and scrape_type in('2','3')";
				}
			}
		   if(project_name !='' && project_name != null ||wz_name !='' && wz_name != null || wz_id !='' && wz_id != null|| wz_scrape_type !='' && wz_scrape_type != null|| wz_dutyUnit !='' && wz_dutyUnit != null){
				if(wz_name !=''){
					sql += " and t.dev_name like'%"+wz_name+"%'";
				}
				if(wz_id !='' && wz_id != null){
					sql += " and t.dev_type like'%"+wz_id+"%'";
				}
				if(wz_scrape_type !='' && wz_scrape_type != null){
					sql += " and t.scrape_type='"+wz_scrape_type+"'";
				}if(wz_dutyUnit !='' && wz_dutyUnit != null){
					sql += " and t.duty_unit like'%"+wz_dutyUnit+"%'";
				}
				if(project_name !='' && project_name != null){
					sql += " and t.project_name like'%"+project_name+"%'";
				}
			}
		 	sql+=" ) ";
		 	if(emp_id){
		 	sql+=" where emp_id='"+emp_id+"'";
		 	}
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/dmsManager/scrape/devList.jsp";
			queryData(1);
			
	}
   	
       function clearQueryText(){
   		document.getElementById("s_wz_name").value = "";
   		document.getElementById("s_wz_id").value = "";
   		document.getElementById("s_duty_unit").value = "";
   		document.getElementById("s_scrape_type").value = "";
   	} 
     //获取选中的设备方法1原始备用版
	function getSelected(){
		var ids = "";
		var count = 0;
		var obj = document.getElementsByName("selectedbox");  
		for (i=0; i<obj.length; i++){
			if(obj[i].checked){
				 count++;
				 if(count==1){
				 	ids +=	obj[i].value;
				 }else{
					ids +=	","+obj[i].value;
				 }
			}  
		}
		return ids;
	} 
	  //获取选中的设备方法现用
	function getSelectedNow(){
		var ids = "";
		var obj = document.getElementsByName("selectedbox");  
		for (i=0; i<obj.length; i++){
			if(obj[i].checked){
				ids +=obj[i].value+",";
			} 
		}
		return ids;
	}
	 //获取选中的设备方法1-升级版
	 var idsPlus ="";
	 var fenyeFlag = "";
	function getSelectedPlus(){
		fenyeFlag="1";
		var ids = "";
		var obj = document.getElementsByName("selectedbox");  
		for (i=0; i<obj.length; i++){
			if(obj[i].checked){
				ids +=obj[i].value+",";
			}
		}
		idsPlus +=ids;
	}
     //获取选中的设备方法2
	function getSelected2(){
		var ids = "";
		 var count = 0;
		$("input[name='selectedbox']").each(function(i){
		 if(this.checked){
			 count++;
			 if(count==1){
			 	ids +=	this.value;
			 }else{
				ids +=	","+this.value;
			 }
		 }
		});
		return ids;
	}
	/*
	*重写 查询导航栏的显示
	*/
	function renderNaviTable(tbObj,tbCfg){ 
		if(tbCfg.totalRows==0){
			tbCfg.pageCount = 0;
			tbCfg.currentPage = 1;
		}
		else{
			tbCfg.pageCount = Math.ceil(tbCfg.totalRows/tbCfg.pageSize);
			if(tbCfg.currentPage==0) tbCfg.currentPage = 1;
		}
		
		// 如果要查询的页数大于总页数，重新查询第一页
		if(tbCfg.pageCount>0 ){
			if(tbCfg.pageCount<tbCfg.currentPage){
				queryData(1);
			}
		}else{
			tbCfg.currentPage=1;
		}
		
		var navTableRow = getObj("fenye_box_table").rows[0];
		
		if(navTableRow==undefined) return;
		
		// 条数选择下拉框的html
		var pageSizeSelect = "<select onchange='resetPageSize(this.value)'><option value='100'>100</option><option value='500'>500</option><option value='1000'>1000</option><option value='3000'>3000</option><option value='5000'>5000</option><option value='10000'>10000</option></select>";
		// 在当前每页条数的option上添加selected，使用字符串替换的方式，比如把value='10'替换成 value='10' selected
		var searchValue = "value='"+cruConfig.pageSize+"'";
		var replaceValue = searchValue + ' selected';
		pageSizeSelect = pageSizeSelect.replace(searchValue, replaceValue);
		
		navTableRow.cells[0].innerHTML = "第"+tbCfg.currentPage+"/"+tbCfg.pageCount+"页，共"+tbCfg.totalRows+"条记录，每页条数"+pageSizeSelect;
		/*var navTableRow = getObj(tbCfg.navTable_id).rows(0);*/
		if(tbCfg.currentPage<=1){//当前是第一页
			navTableRow.cells[2].innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_01.png'  style='border:0'  alt='First' />";
			navTableRow.cells[3].innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_02.png'  style='border:0'  alt='Prev' />";
		}else{
			navTableRow.cells[2].innerHTML = "<a href='javascript:getSelectedPlus();queryData(1)'><img src='"+cruConfig.contextPath+"/images/fenye_01.png'  style='border:0'  alt='First' /></a>";
			navTableRow.cells[3].innerHTML = "<a href='javascript:getSelectedPlus();queryData("+(tbCfg.currentPage-1)+")'><img src='"+cruConfig.contextPath+"/images/fenye_02.png'  style='border:0'  alt='Prev' /></a>";
		}
		if(tbCfg.currentPage>=tbCfg.pageCount){//当前是最后一页
			navTableRow.cells[4].innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_03.png'  style='border:0'  alt='Next' />";
			navTableRow.cells[5].innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_04.png'  style='border:0'  alt='Last' />";
		}else{
			navTableRow.cells[4].innerHTML = "<a href='javascript:getSelectedPlus();queryData("+(tbCfg.currentPage+1)+")'><img src='"+cruConfig.contextPath+"/images/fenye_03.png'  style='border:0'  alt='Next' /></a>";
			navTableRow.cells[5].innerHTML = "<a href='javascript:getSelectedPlus();queryData("+(tbCfg.pageCount)+")'><img src='"+cruConfig.contextPath+"/images/fenye_04.png'  style='border:0'  alt='Last' /></a>";
		}
		navTableRow.cells[6].innerHTML = "到 <label> <input type='text' name='textfield' id='textfield' value='" + tbCfg.currentPage +"' maxValue='"+tbCfg.pageCount+"' style='width:20px;' onmouseover='selectPageNum()' onclick='selectPageNum()'/> </label>";
		navTableRow.cells[7].innerHTML = "<img src='"+cruConfig.contextPath+"/images/fenye_03.png' style='cursor: hand;border:0' onclick='getSelectedPlus();gotopage()'/> ";
	}
	function setlink(){
		//根据selectAllFlag来区分
		var scrape_apply_id = "<%=scrape_apply_id%>";
		var parameter = "type=1&scrape_apply_id="+scrape_apply_id;
		parameter += "&selectAllFlag="+selectAllFlag;
	  	var wz_name = encodeURI(encodeURI(document.getElementById("s_wz_name").value));
	  	var wz_id = document.getElementById("s_wz_id").value;
	   
	  	var emp_id = encodeURI(encodeURI(document.getElementById("emp_id").value));
	  	var wz_scrape_type = document.getElementById("s_scrape_type").value;
	  	var wz_dutyUnit = encodeURI(encodeURI(document.getElementById("s_duty_unit").value));
	  	var s_project_name = encodeURI(encodeURI(document.getElementById("s_project_name").value));
	  	parameter+="&wz_name="+wz_name+"&wz_id="+wz_id+"&wz_scrape_type="+wz_scrape_type+"&wz_dutyUnit="+wz_dutyUnit+"&emp_id="+emp_id+"&s_project_name="+s_project_name;
		var scrape_detailed_id=getSelected();
		//parameter+="&scrape_detailed_id="+scrape_detailed_id;
		if(scrape_detailed_id==''){
			alert("请选择要关联的设备！");
			return;
		}
		var scrapeType = "<%=scrapeType%>";
		var selected ="";
		if(scrapeType!=null)
		{
			if(scrapeType=='01'){
				selected = window.showModalDialog("<%=contextPath%>/dmsManager/scrape/scrapeApplyLinkAsset.jsp?"+parameter,"","dialogWidth=1240px;dialogHeight=480px");
			}else if(scrapeType=='23'){
				 
				selected = window.showModalDialog("<%=contextPath%>/dmsManager/scrape/scrapeApplyLinkDamage.jsp?"+parameter,"","dialogWidth=1240px;dialogHeight=480px");
			}
			simpleSearch();
		}
		<%-- var dev_filename = document.getElementById("doc_name__"+tmp).value;
		if(dev_filename !=""){
			Ext.MessageBox.wait('请等待','处理中');
			Ext.Ajax.request({
				url : "<%=contextPath%>/dmsManager/scrape/saveLinkdync.srq",
				method : 'Post',
				isUpload : true,  
				form : "form1",
				success : function(resp){
					var myData = eval("("+resp.responseText+")");
					var nodes = myData.nodes;
					alert(myData.returnMsg);
					Ext.MessageBox.hide();
					//刷新附件列表
					
				},
				failure : function(resp){// 失败
					var myData = eval("("+resp.responseText+")");
					alert(myData.returnMsg);
				}
			}); 
		}else{
			alert("请上传附件！");
			return;
		}
		var ininfo = $("#idinfo_"+tr_id).val();//获取当前行附件的id值 --%>
		//方法提交
	}
</script>
</html>

