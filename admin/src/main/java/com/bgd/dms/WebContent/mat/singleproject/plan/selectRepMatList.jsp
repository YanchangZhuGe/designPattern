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

<body onload = "refreshData()" style="overflow-x:hidden;overflow-y:visible;background:#fff">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">物资名称</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_tamplate_name" name="s_tamplate_name" type="text" /></td>
		 	    <td class="ali_cdn_name">物资编号</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="wz_id" name="wz_id" type="text" /></td>
		 	     <td class="ali_cdn_name">物资分类码</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="coding_code_id" name="coding_code_id" type="text" /></td>
			    <td >
				   <auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    </td>
			    <td >
			    	<auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    </td>
			    <td>
			    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			    </td>
			    <td><auth:ListButton functionId="" css="tj" event="onclick='saveBake()'" title="JCDP_btn_submit"></auth:ListButton></td>
			    <td></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			        <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox'  value='{wz_id}' {disabled} onclick='loadDataDetail();'/>"> <input type='checkbox' name='rdo_entity_name' value='' onclick='check()'/></td>
			        <td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{wz_id}">物资编码</td>
					<td class="bt_info_even" exp="{coding_code_id}">物资分类码</td>
					<td class="bt_info_odd" exp="{wz_name}">物资名称</td>
					<td class="bt_info_even" exp="{wz_prickie}">物资单位</td>
					<td class="bt_info_odd" exp="{wz_price}">物资单价</td>
					<td class="bt_info_even" exp="{note}">备注</td>
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
    var submiteNumber = getQueryString("submiteNumber");
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.pageSize ='50';
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	var ids = getQueryString("ids");
	function refreshData(value){
		cruConfig.queryService = "MatItemSrv";
		cruConfig.queryOp = "getRepTemLeaf";
			cruConfig.submitStr ="ids="+ids+"&value="+value;
			queryData(1);
	}
       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  
       function simpleSearch(){
    	    cruConfig.queryService = "";
   			cruConfig.queryOp = "";
			var tamplate_name = document.getElementById("s_tamplate_name").value;
			var wz_id = document.getElementById("wz_id").value;
			var coding_code_id = document.getElementById("coding_code_id").value;
			if(tamplate_name =='' && wz_id =='' && coding_code_id==''){
							
							alert("请输入查询信息！") 
							
						}else{
							
							if(tamplate_name !='' && wz_id !='' && coding_code_id!=''){
						    	cruConfig.queryService = "MatItemSrv";
								cruConfig.queryOp = "queryMatLeaf";
								cruConfig.submitStr ="tamplate_name="+tamplate_name+"&wz_id="+wz_id+"&coding_code_id="+coding_code_id+"&ids="+ids;
								queryData(1);
								//cruConfig.queryStr = "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_name like '%"+tamplate_name+"%'and t.wz_id like'%"+wz_id+"%'and t.coding_code_id like'%"+coding_code_id+"%'";
								
								return ;
					    	
					    }else if(tamplate_name !='' && wz_id =='' && coding_code_id==''){
						    	cruConfig.queryService = "MatItemSrv";
								cruConfig.queryOp = "queryMatLeaf";
								cruConfig.submitStr ="tamplate_name="+tamplate_name+"&wz_id="+wz_id+"&coding_code_id="+coding_code_id+"&ids="+ids;
								queryData(1);
								//cruConfig.queryStr = "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_name like '%"+tamplate_name+"%'";
								
								return ;
						 }else  if(tamplate_name =='' && wz_id !='' && coding_code_id==''){ 
							 	cruConfig.queryService = "MatItemSrv";
								cruConfig.queryOp = "queryMatLeaf";
								cruConfig.submitStr ="tamplate_name="+tamplate_name+"&wz_id="+wz_id+"&coding_code_id="+coding_code_id+"&ids="+ids;
								//cruConfig.queryStr = "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_id like '%"+wz_id+"%'";
								queryData(1);
								return ;
						 }else  if(tamplate_name =='' && wz_id =='' && coding_code_id!=''){ 
							 	cruConfig.queryService = "MatItemSrv";
								cruConfig.queryOp = "queryMatLeaf";
								cruConfig.submitStr ="tamplate_name="+tamplate_name+"&wz_id="+wz_id+"&coding_code_id="+coding_code_id+"&ids="+ids;
								//cruConfig.queryStr = "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.coding_code_id like '%"+coding_code_id+"%'";
								queryData(1);
								return ;
						 } else  if(tamplate_name !='' && wz_id !='' && coding_code_id==''){ 
							 	cruConfig.queryService = "MatItemSrv";
								cruConfig.queryOp = "queryMatLeaf";
								cruConfig.submitStr ="tamplate_name="+tamplate_name+"&wz_id="+wz_id+"&coding_code_id="+coding_code_id+"&ids="+ids;
								//cruConfig.queryStr = "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_name like '%"+tamplate_name+"%'and t.wz_id like'%"+wz_id+"%'";
								queryData(1);
								return ;
						 } else  if(tamplate_name !='' && wz_id =='' && coding_code_id!=''){ 
							 	cruConfig.queryService = "MatItemSrv";
								cruConfig.queryOp = "queryMatLeaf";
								cruConfig.submitStr ="tamplate_name="+tamplate_name+"&wz_id="+wz_id+"&coding_code_id="+coding_code_id+"&ids="+ids;
								//cruConfig.queryStr = "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_name like '%"+tamplate_name+"%'and t.coding_code_id like'%"+coding_code_id+"%'";
								queryData(1);
								return ;
						 } else  if(tamplate_name =='' && wz_id !='' && coding_code_id!=''){ 
							 	cruConfig.queryService = "MatItemSrv";
								cruConfig.queryOp = "queryMatLeaf";
								cruConfig.submitStr ="tamplate_name="+tamplate_name+"&wz_id="+wz_id+"&coding_code_id="+coding_code_id+"&ids="+ids;
								//cruConfig.queryStr = "select t.*,c.code_name from gms_mat_infomation t inner join gms_mat_coding_code c on t.coding_code_id = c.coding_code_id and t.bsflag='0'and c.bsflag='0' and t.wz_id like'%"+wz_id+"%'and t.coding_code_id like'%"+coding_code_id+"%'";
								queryData(1);
								return ;
						 } 
			
			}
       }
     function saveBake(){
    	 ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
			else{
				if(submiteNumber!=null){
					var retObj = jcdpCallService("MatItemSrv", "savePlanEdit", "matId="+ids+"&submiteNumber="+submiteNumber);
					window.returnValue ="id:"+ids;
			     	window.close();
					}
				else{
			    	window.returnValue ="id:"+ids;
			     	window.close();
				}
			}
         }
     var checked = false;
 	function check(){
 		var chk = document.getElementsByName("rdo_entity_name");
 		for(var i = 0; i < chk.length; i++){ 
 	 		
	 			if(!checked){ 
	 				chk[i].checked = true; 
	 			}
	 			else{
	 				chk[i].checked = false;
	 			}
	 		} 
	 		if(checked){
	 			checked = false;
	 		}
	 		else{
	 			checked = true;
	 		}
 		
 	}
 	function clearQueryText(){
 		document.getElementById("s_tamplate_name").value = "";
 	 	}
	 	
</script>

</html>

