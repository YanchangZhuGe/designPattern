<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%@ page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %> 
<%@ taglib prefix="auth" uri="auth"%>
 
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%> 


<%
	String contextPath = request.getContextPath(); 
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
 
	String ids = request.getParameter("ids");
 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>日常检查对应编码</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json2.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body  onload=""   style="height:560px;">
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box"  style="height:560px;">
  <div id="new_table_box_content"   style="height:530px;" >
    <div id="new_table_box_bg" style="height:460px;">
    			
    			<table  border="0" cellpadding="0" cellspacing="0" id='tab_line_height' name='tab_line_height' class="tab_line_height" width="100%">
    					<tr>
					    	<td class="inquire_item6">当日里程：</td>
					      	<td class="inquire_form6"><input type="text" name="mileage_today" id="mileage_today" class="input_width" value="" readonly/></td>
					    	<td class="inquire_item6">里程表读数：</td>
					      	<td class="inquire_form6"><input type="text" name="mileage_write" id="mileage_write" class="input_width" value="" readonly/></td>
					      	<td class="inquire_item6">燃油加油量：</td>
					      	<td class="inquire_form6"><input type="text" name="oil_num" id="oil_num" class="input_width" value="" readonly/></td>
					    </tr>
					    <tr>
					    	<td class="inquire_item6">整改结果：</td>
					      	<td class="inquire_form6"><input type="text" name="modification_result" id="modification_result" class="input_width" value="" readonly/></td>
					      	<td class="inquire_item6">整改人：</td>
					      	<td class="inquire_form6"><input type="text" name="modification_people" id="modification_people" class="input_width" value="" readonly/></td>
					      	<td class="inquire_item6">整改时间：</td>
					      	<td class="inquire_form6"><input type="text" name="modification_time" id="modification_time" class="input_width" value="" readonly/></td>
					    </tr>
					    <tr>
					    	<td class="inquire_item6">整改内容：</td>
					      	<td class="inquire_form6" colspan="5"><textarea id="modification_content" name="modification_content" class="textarea" readonly="readonly"></textarea></td>
					    </tr>
    			</table>
    
		  		<table id="rcMap" width="250%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
	 					
	 					
					  <tr id="tr0" >   
						<td class="bt_info_odd"> &nbsp;&nbsp;&nbsp;</td>          
					    <td class="bt_info_even" >发动机部分</td>
					    <td class="bt_info_odd">底盘部分</td>
					    <td class="bt_info_even">相关工作</td>
					    <td class="bt_info_odd">车载发电机部分</td>
					    <td class="bt_info_even">车载吊车部分</td>
			 
					  </tr>
					  <tr  id="tr1"   >   
						<td  style="border-bottom:black solid 1px;" align="center">启动前</td>   
						<td  style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  	
							<%
							 String sql = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000006'   and dl.bsflag = '0' order by dl.coding_code_id ";
	 
							  List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql); 
									for (int i = 0; i < list.size(); i++) {
										Map map = (Map)list.get(i);
										String codingName = (String)map.get("codingName");
										String codingCodeId = (String)map.get("codingCodeId");
							%>
						  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span> </br>
				           <%
				           				}
				           %>
				        
			           </td>
			           <td style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
				           <%
							 String sqlA = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000009'   and dl.bsflag = '0'  order by dl.coding_code_id ";
	
							  List listA = BeanFactory.getQueryJdbcDAO().queryRecords(sqlA); 
								  for (int i = 0; i < listA.size(); i++) {
										Map map = (Map)listA.get(i);
										String codingName = (String)map.get("codingName");
										String codingCodeId = (String)map.get("codingCodeId");
							%>
						  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/>  <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>  </br>
				           <%
				           				}
				           %>
			           </td>
			           <td  style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
			           <%
						 String sqlB = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000012'   and dl.bsflag = '0'  order by dl.coding_code_id ";

						  List listB = BeanFactory.getQueryJdbcDAO().queryRecords(sqlB); 
							  for (int i = 0; i < listB.size(); i++) {
									Map map = (Map)listB.get(i);
									String codingName = (String)map.get("codingName");
									String codingCodeId = (String)map.get("codingCodeId");
						%>
					  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>   </br>
			           <%
			           				}
			           %>
			           </td>
			           <td  style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
			           <%
						 String sqlC = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000015'   and dl.bsflag = '0' order by dl.coding_code_id ";

						  List listC = BeanFactory.getQueryJdbcDAO().queryRecords(sqlC); 
							  for (int i = 0; i < listC.size(); i++) {
									Map map = (Map)listC.get(i);
									String codingName = (String)map.get("codingName");
									String codingCodeId = (String)map.get("codingCodeId");
						%>
					  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>  </br>
			           <%
			           				}
			           %>
			           </td>
			           <td  style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
			           <%
						 String sqlD = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000018'   and dl.bsflag = '0' order by dl.coding_code_id ";

						  List listD = BeanFactory.getQueryJdbcDAO().queryRecords(sqlD); 
							  for (int i = 0; i < listD.size(); i++) {
									Map map = (Map)listD.get(i);
									String codingName = (String)map.get("codingName");
									String codingCodeId = (String)map.get("codingCodeId");
						%>
					  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>  </br>
			           <%
			           				}
			           %>
			           </td>
					  </tr>
					  <tr  id="tr2" > 
						<td  style="border-bottom:black solid 1px;" align="center" >启动后</td>   
						<td  style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  	
							<%
							 String sqlE = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000007'   and dl.bsflag = '0'  order by dl.coding_code_id ";
	 
							  List listE = BeanFactory.getQueryJdbcDAO().queryRecords(sqlE); 
									for (int i = 0; i < listE.size(); i++) {
										Map map = (Map)listE.get(i);
										String codingName = (String)map.get("codingName");
										String codingCodeId = (String)map.get("codingCodeId");
							%>
						  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>   </br>
				           <%
				           				}
				           %>
				        
			           </td>
			           <td  style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
				           <%
							 String sqlF = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000010'   and dl.bsflag = '0' order by dl.coding_code_id  ";
	
							  List listF = BeanFactory.getQueryJdbcDAO().queryRecords(sqlF); 
							  for (int i = 0; i < listF.size(); i++) {
									Map map = (Map)listF.get(i);
									String codingName = (String)map.get("codingName");
									String codingCodeId = (String)map.get("codingCodeId");
							%>
						  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>   </br>
				           <%
				           				}
				           %>
			           </td>
			           <td  style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
			           <%
						 String sqlG = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000013'   and dl.bsflag = '0' order by dl.coding_code_id  ";

						  List listG = BeanFactory.getQueryJdbcDAO().queryRecords(sqlG); 
							  for (int i = 0; i < listG.size(); i++) {
									Map map = (Map)listG.get(i);
									String codingName = (String)map.get("codingName");
									String codingCodeId = (String)map.get("codingCodeId");
						%>
					  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>   </br>
			           <%
			           				}
			           %>
			           </td>
			           <td style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
			           <%
						 String sqlH = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000016'   and dl.bsflag = '0' order by dl.coding_code_id  ";

						  List listH = BeanFactory.getQueryJdbcDAO().queryRecords(sqlH); 
						  for (int i = 0; i < listH.size(); i++) {
								Map map = (Map)listH.get(i);
								String codingName = (String)map.get("codingName");
								String codingCodeId = (String)map.get("codingCodeId");
						%>
					  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>   </br>
			           <%
			           				}
			           %>
			           </td>
			           <td style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
			           <%
						 String sqlJ = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000019'   and dl.bsflag = '0' order by dl.coding_code_id  ";

						  List listJ = BeanFactory.getQueryJdbcDAO().queryRecords(sqlJ); 
						  for (int i = 0; i < listJ.size(); i++) {
								Map map = (Map)listJ.get(i);
								String codingName = (String)map.get("codingName");
								String codingCodeId = (String)map.get("codingCodeId");
						%>
					  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>   </br>
			           <%
			           				}
			           %>
			           </td>
					  
					  </tr>
					  
					  <tr id="tr3" >   
						<td  style="border-bottom:black solid 1px;"  align="center">停机后</td>   
						<td  style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  	
							<%
							 String sqlK = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000008'   and dl.bsflag = '0' order by dl.coding_code_id  ";
	 
							  List listK = BeanFactory.getQueryJdbcDAO().queryRecords(sqlK); 
							  for (int i = 0; i < listK.size(); i++) {
									Map map = (Map)listK.get(i);
									String codingName = (String)map.get("codingName");
									String codingCodeId = (String)map.get("codingCodeId");
							%>
						  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>  </br>
				           <%
				           				}
				           %>
				        
			           </td>
			           <td  style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
				           <%
							 String sqlL = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000011'   and dl.bsflag = '0' order by dl.coding_code_id  ";
	
							  List listL = BeanFactory.getQueryJdbcDAO().queryRecords(sqlL); 
							  for (int i = 0; i < listL.size(); i++) {
									Map map = (Map)listL.get(i);
									String codingName = (String)map.get("codingName");
									String codingCodeId = (String)map.get("codingCodeId");
							%>
						  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"    value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>   </br>
				           <%
				           				}
				           %>
			           </td>
			           <td  style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
			           <%
						 String sqlM = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000014'   and dl.bsflag = '0' order by dl.coding_code_id  ";

						  List listM = BeanFactory.getQueryJdbcDAO().queryRecords(sqlM); 
						  for (int i = 0; i < listM.size(); i++) {
								Map map = (Map)listM.get(i);
								String codingName = (String)map.get("codingName");
								String codingCodeId = (String)map.get("codingCodeId");
						%>
					  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"   value="<%=codingCodeId%>" checked="checked"/><span id="szyk<%=codingCodeId%>"> <%=codingName%> </span>  </br>
			           <%
			           				}
			           %>
			           </td>
			           <td style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
			           <%
						 String sqlN = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000017'   and dl.bsflag = '0' order by dl.coding_code_id  ";

						  List listN = BeanFactory.getQueryJdbcDAO().queryRecords(sqlN); 
						  for (int i = 0; i < listN.size(); i++) {
								Map map = (Map)listN.get(i);
								String codingName = (String)map.get("codingName");
								String codingCodeId = (String)map.get("codingCodeId");
						%>
					  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"      value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"  >  <%=codingName%> </span> </br>
			           <%
			           				}
			           %>
			           </td> 
			           
			           <td style="border-bottom:black solid 1px;padding-left: 10px;" align="left" valign="top">  
			           <%
						 String sqlO = " SELECT  dl.superior_code_id,dl.coding_sort_id, dl.coding_code_id, dl.coding_name  FROM COMM_CODING_SORT_DETAIL dl WHERE dl.CODING_SORT_ID = '5110000162'   and dl.superior_code_id = '5110000162000000020'   and dl.bsflag = '0' order by dl.coding_code_id  ";

						  List listO = BeanFactory.getQueryJdbcDAO().queryRecords(sqlO); 
						  for (int i = 0; i < listO.size(); i++) {
								Map map = (Map)listO.get(i);
								String codingName = (String)map.get("codingName");
								String codingCodeId = (String)map.get("codingCodeId");
						%>
					  <input type="checkbox"    id="zyk<%=codingCodeId%>"   name="zyk"      value="<%=codingCodeId%>" checked="checked"/> <span id="szyk<%=codingCodeId%>"  >  <%=codingName%> </span> </br>
			           <%
			           				}
			           %>
			           </td> 
						 
					  </tr>
					 
				 </table>
				</div>
			<div id="oper_div"  >
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
 var ids='<%=ids%>';
  	
 		
	if(ids !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		//手持机传的数据，是没有选中的选项存在表中
		querySql = "select t.mileage_today,t.mileage_write,t.drilling_num,t.work_hour,t.oil_num,t.modification_people,t.modification_result,t.modification_time,t.modification_content,m.inspectioin_item_code from GMS_DEVICE_INSPECTIOIN t left join GMS_DEVICE_INSPECTIOIN_ITEM m on t.devinspectioin_id = m.devinspectioin_id and m.bsflag = '0' where t.bsflag = '0' and t.devinspectioin_id = '"+ids+"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+encodeURI(encodeURI(querySql)));
 
			datas = queryRet.datas;
		debugger;
			if(datas != null&&datas!=""){
				document.getElementById("mileage_today").value = datas[0].mileage_today;
				document.getElementById("mileage_write").value = datas[0].mileage_write;
				document.getElementById("oil_num").value = datas[0].oil_num;
				document.getElementById("modification_result").value = datas[0].modification_result;
				document.getElementById("modification_people").value = datas[0].modification_people;
				document.getElementById("modification_time").value = datas[0].modification_time;
				document.getElementById("modification_content").value = datas[0].modification_content;
					 var zyk = document.getElementsByName("zyk");
					 for(var j=0;j<zyk.length;j++){
						for(var i=0;i<datas.length;i++){
			  				if(zyk[j].value == datas[i].inspectioin_item_code){	
				  				zyk[j].checked=false;
			  					//zyk[j].style.display="none";
			  					//zyk[j].checked=false;
			  				}//document.getElementById("szyk"+j).style.color="red";
			  				 
					 }
				}
	    		 
			}					
		 	
		
	}
  
</script>
</html>