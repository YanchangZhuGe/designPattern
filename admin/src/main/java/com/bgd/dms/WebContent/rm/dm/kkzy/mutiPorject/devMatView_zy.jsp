<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String usemat_id = request.getParameter("usemat_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>消耗备件页面</title> 
 </head> 
  <body style="background:#F1F2F3;width:98%" onload="refreshData()">
  <input type="hidden" name="export_name"  id="export_name" value="消耗备件信息"/>
      	<div id="list_table">
      	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			</table>
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" >		
			     <tr>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{wz_id}">物资编号</td>
					<!--  <td class="bt_info_odd" exp="{wz_sequence}">序列号</td>-->
					<td class="bt_info_even" exp="{wz_name}">物资名称</td>
					<td class="bt_info_odd" exp="{wz_prickie}">计量单位</td>
					<td class="bt_info_even" exp="{actual_price}">实际价格</td>
					<td class="bt_info_odd" exp="-">库存数量</td>
					<td class="bt_info_odd" exp="{use_num}">消耗数量</td>
					<!-- <td class="bt_info_even" exp="{code_name}">备件用途</td> -->
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
			<div class="lashen" id="line"></div>
		 </div>
</body>
 
<script type="text/javascript">

$(function(){
	$(window).resize(function(){
		
		if(lashened==0){
			$("#table_box").css("height",$(window).height()*0.75);
		}
		$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-10);
		$("#tab_box .tab_box_content").each(function(){
			if($(this).children('iframe').length > 0){
				$(this).css('overflow-y','hidden');
			}
		});
	});
})

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	var usemat_id = "<%=usemat_id%>";

	function refreshData(){
	    var querySql="select x.project_info_id  from gms_device_zy_bywx x  where x.usemat_id='"+usemat_id+"'";
		var queryRet = syncRequest('Post','/gms4'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		var datas = queryRet.datas;
		var str="";
		if(datas!=null){
			var project_info_id=datas[0].project_info_id;
		str="select r.wz_id,i.wz_name,i.wz_prickie,r.actual_price,w.use_num from gms_device_zy_wxbymat w ,  gms_mat_recyclemat_info r , gms_mat_infomation  i  where w.wz_id=r.wz_id and r.wz_type='3' and r.bsflag='0'  and r.project_info_id  is not null  and  r.project_info_id ='"+project_info_id+"' and r.wz_id=i.wz_id and w.usemat_id='"+usemat_id+"'";
		}else{
			str="select r.wz_id,i.wz_name,i.wz_prickie,r.actual_price,w.use_num from gms_device_zy_wxbymat w ,  gms_mat_recyclemat_info r , gms_mat_infomation  i  where w.wz_id=r.wz_id and r.wz_type='3' and r.bsflag='0'  and r.project_info_id  is  null and r.wz_id=i.wz_id and w.usemat_id='"+usemat_id+"'";	
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
</script>
</html>