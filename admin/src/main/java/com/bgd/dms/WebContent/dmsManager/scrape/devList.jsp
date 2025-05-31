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
	
	String scrapeType = request.getParameter("scrapeType");
	
	String fileId = request.getParameter("fileId");
	
	String scrape_apply_id = request.getParameter("scrape_apply_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
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
      	<div  style="height:300px">
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
						<auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
					    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
					    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					    <td></td>
					    <td></td>
					    <td></td>
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
			      <td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{scrape_detailed_id}' id='selectedbox_{scrape_detailed_id}'  {file_id} />">选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{dev_name}">设备名称</td>
			      <td class="bt_info_even" exp="{dev_type}">设备编码</td>
			      <td class="bt_info_odd" exp="{dev_coding}">ERP设备编码</td>
			      <td class="bt_info_even" exp="{asset_value}">原值</td>
			       <td class="bt_info_even" exp="{net_value}">净值</td>
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
		  </div>
</body>
<script type="text/javascript">
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
		var fileId = "<%=fileId%>";
		var scrape_apply_id = "<%=scrape_apply_id%>";
		//if(codeId !=null && codeId != rootId && bussId!=null){
			sql += " select t.*,case when d.file_id is not null then 'checked' else '' end as file_id from dms_scrape_detailed t ";
			sql += " left join dms_scrape_detailed_link_file d on t.scrape_detailed_id = d.scrape_detailed_id ";
			if(fileId!=null&&fileId!="null"){
				sql +=" and d.file_id='"+fileId+"'";
			}
			sql += " where bsflag ='0' ";
			if(codeId !=null && codeId != rootId){
				sql += " and t.dev_type='"+codeId+"'";
			}
			//有时候相同的设备编号dev_type对应不同的设备名称，所以将来要加入一个判断设备名称的方法
			
			if(scrapeType!=null){
				sql +=" and scrape_type='"+scrapeType+"' ";
			}
			if(scrape_apply_id!=null){
				sql +=" and scrape_apply_id='"+scrape_apply_id+"'";
			}
			sql +=" order by d.file_id";
		/* }else{
			sql += " select t.*,case when d.file_id is not null then 'checked' else '' end as file_id from dms_scrape_detailed t ";
			sql += " left join dms_scrape_detailed_link_file d on t.scrape_detailed_id = d.scrape_detailed_id ";
			if(scrapeType!=null){
				sql +=" where bsflag ='0'  and scrape_type='"+scrapeType+"' ";
			} 
		}*/
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/dmsManager/scrape/devList.jsp";
		queryData(1);
	}
       function simpleSearch(){
    	   var codeId = getQueryString("codeId");
   			if(codeId =="C105"){
   				codeId="";
   			}
    	   var bussId = "<%=bussId%>";
   		   var scrapeType = "<%=scrapeType%>";
   		   var fileId = "<%=fileId%>";
   		   var scrape_apply_id = "<%=scrape_apply_id%>";
    	   var sql ='';
    	   var wz_name = document.getElementById("s_wz_name").value;
		   var wz_id = document.getElementById("s_wz_id").value;
    	   if(wz_name !='' && wz_name != null || wz_id !='' && wz_id != null){
	    	    sql += " select t.*,case when d.file_id is not null then 'checked' else '' end as file_id from dms_scrape_detailed t ";
				sql += " left join dms_scrape_detailed_link_file d on t.scrape_detailed_id = d.scrape_detailed_id ";
				if(fileId!=null&&fileId!="null"){
					sql +=" and d.file_id='"+fileId+"'";
				}
				sql += " where bsflag ='0' ";
				if(codeId !=null && codeId != rootId){
					sql += " and t.dev_type='"+codeId+"'";
				}
				//有时候相同的设备编号dev_type对应不同的设备名称，所以将来要加入一个判断设备名称的方法
				
				if(scrapeType!=null){
					sql +=" and scrape_type='"+scrapeType+"' ";
				}
				if(scrape_apply_id!=null){
					sql +=" and scrape_apply_id='"+scrape_apply_id+"'";
				}
				if(wz_name !=''){
					sql += " and t.dev_name like'%"+wz_name+"%'";
				}
				if(wz_id !='' && wz_id != null){
					sql += " and t.dev_type like'%"+wz_id+"%'";
				}
				sql +=" order by d.file_id";
			}else{
				alert('请输入查询内容！');
			}
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/dmsManager/scrape/devList.jsp";
			queryData(1);
			
	}
   	
       function clearQueryText(){
   		document.getElementById("s_wz_name").value = "";
   		document.getElementById("s_wz_id").value = "";
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
		var pageSizeSelect = "<select onchange='resetPageSize(this.value)'><option value='10'>10</option><option value='30'>30</option><option value='50'>50</option><option value='100'>100</option><option value='200'>200</option><option value='300'>300</option></select>";
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
</script>
</html>

