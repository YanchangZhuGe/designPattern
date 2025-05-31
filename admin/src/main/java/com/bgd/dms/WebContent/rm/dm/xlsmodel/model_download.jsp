<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<title>模板下载功能</title>
</head>
<body style="background:#fff" >
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_app_id' name='dev_ci_id' >
					<td class="bt_info_even" >序号</td>
					<td class="bt_info_odd" >模板名称</td>
					<td class="bt_info_even" >下载</td>
			     </tr>
			     <tr id='device_app_id1' name='dev_ci_id' >
					<td class="even_even" >1</td>
					<td class="even_odd" >设备考勤模板</td>
					<td class="even_even" ><a href="javascript:downloadModel('kq_model','设备考勤模板')">下载</a></td>
			     </tr>
			     <!-- 
			     <tr id='device_app_id2' name='dev_ci_id' >
					<td class="odd_even" >2</td>
					<td class="odd_odd" >油水记录模板</td>
					<td class="odd_even" ><a href="javascript:downloadModel('ys_model','油水记录模板')">下载</a></td>
			     </tr>
			      -->
			     <tr id='device_app_id3' name='dev_ci_id' >
					<td class="even_odd" >3</td>
					<td class="even_even" >运转记录模板</td>
					<td class="even_odd" ><a href="javascript:downloadModel('yz_model','运转记录模板')">下载</a></td>
			     </tr>
			     <tr id='device_app_id3' name='dev_ci_id' >
					<td class="even_odd" >4</td>
					<td class="even_even" >装备物资设备管理移动应用-车装钻机APK</td>
					<td class="even_odd" ><a href="javascript:downloadModel('chezhuang','装备物资设备管理移动应用-车装钻机')">下载</a></td>
			     </tr>
			     <tr id='device_app_id3' name='dev_ci_id' >
					<td class="even_odd" >5</td>
					<td class="even_even" >装备物资设备管理移动应用-轻便钻机APK</td>
					<td class="even_odd" ><a href="javascript:downloadModel('qingbian','装备物资设备管理移动应用-轻便钻机')">下载</a></td>
			     </tr>
			     <tr id='device_app_id3' name='dev_ci_id' >
					<td class="even_odd" >6</td>
					<td class="even_even" >装备物资设备管理移动应用-运输车辆APK</td>
					<td class="even_odd" ><a href="javascript:downloadModel('yunshu','装备物资设备管理移动应用-运输车辆')">下载</a></td>
			     </tr>
			     <tr id='device_app_id3' name='dev_ci_id' >
					<td class="even_odd" >7</td>
					<td class="even_even" >装备物资设备管理移动应用-可控震源APK</td>
					<td class="even_odd" ><a href="javascript:downloadModel('kekong','装备物资设备管理移动应用-可控震源')">下载</a></td>
			     </tr>
			     <tr id='device_app_id3' name='dev_ci_id' >
					<td class="even_odd" >8</td>
					<td class="even_even" >装备物资设备管理移动应用-现场管理APK</td>
					<td class="even_odd" ><a href="javascript:downloadModel('xianchang','装备物资设备管理移动应用-现场管理')">下载</a></td>
			     </tr>
			     <tr id='device_app_id3' name='dev_ci_id' >
					<td class="even_odd" >9</td>
					<td class="even_even" >装备物资设备管理移动应用用户手册</td>
					<td class="even_odd" ><a href="javascript:downloadModel('yonghushouce','装备物资设备管理移动应用用户手册v1.3')">下载</a></td>
			     </tr>
			  </table>
			</div>
		 </div>
</div>
</body>
<script type="text/javascript">
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		if("kq_model"==modelname){
			window.location.href="<%=contextPath%>/rm/dm/xlsmodel/download.jsp?path=/rm/dm/xlsmodel/"+modelname+".xls&filename="+filename+".xls";
		}else if("chezhuang"==modelname||"qingbian"==modelname||"yunshu"==modelname||"xianchang"==modelname||"kekong"==modelname){
			window.location.href="<%=contextPath%>/rm/dm/xlsmodel/download.jsp?path=/rm/dm/xlsmodel/"+modelname+".apk&filename="+filename+".apk";
		}else if("yonghushouce"==modelname){
			window.location.href="<%=contextPath%>/rm/dm/xlsmodel/download.jsp?path=/rm/dm/xlsmodel/"+modelname+".doc&filename="+filename+".doc";
		}else{
			window.location.href="<%=contextPath%>/rm/dm/xlsmodel/download.jsp?path=/rm/dm/xlsmodel/"+modelname+".xlsx&filename="+filename+".xlsx";
		}
		
	}
</script>
</html>