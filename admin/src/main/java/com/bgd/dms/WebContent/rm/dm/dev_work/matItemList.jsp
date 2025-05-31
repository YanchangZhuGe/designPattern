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

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">物资名称：</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_name" name="s_wz_name" type="text" /></td>
		 	    <td class="ali_cdn_name">物资编码：</td>
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
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input name = 'rdo_entity_name' id='rdo_entity_id' type='checkbox' value='{wz_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_even" exp="{coding_code_id}">物资分类码</td>
			      <td class="bt_info_odd" exp="{wz_id}">物资编码</td>
			      <td class="bt_info_even" exp="{wz_name}">物资名称</td>
			      <td class="bt_info_odd" exp="{wz_prickie}">计量单位</td>
			      <td class="bt_info_even" exp="{wz_price}">参考单价</td>
			      <td class="bt_info_odd" exp="{code_name}">分类</td>
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
		
			<div id="oper_div">
		     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
		        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
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
//	$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-40);
	setTabBoxHeight();
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
		debugger;
		var bussId = "<%=bussId%>";
		if(codeId !=null && codeId != rootId && bussId!=null){
		  //if(userId == 'C105'){
			sql += "select g.*, c.code_name from gms_mat_infomation g inner join GMS_MAT_CODING_CODE c on g.coding_code_id = c.coding_code_id and g.bsflag='0' and c.bsflag='0' ";
			if(bussId=='M105'){
				sql += " join gms_mat_buss_infomation i on g.wz_id=i.wz_id and i.bsflag='0' and i.mat_menu_id='<%=bussId %>'"; 
			}
			sql += " where g.coding_code_id like'"+codeId+"%' order by g.coding_code_id asc,g.wz_id asc";
		 // }else{
			//sql +="select c.code_name, g.wz_id ,g.coding_code_id,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price from gms_mat_infomation_wtc  w inner join gms_mat_infomation g on g.wz_id = w.wz_id inner join GMS_MAT_CODING_CODE c on g.coding_code_id = c.coding_code_id and g.bsflag='0'and c.bsflag='0' and w.bsflag ='0' where g.coding_code_id like'"+codeId+"%' order by g.coding_code_id asc,g.wz_id asc";
			 // }
	}
		else
			{
			//if(userId =='C105'){
			sql += "select g.*, c.code_name from gms_mat_infomation g inner join GMS_MAT_CODING_CODE c on g.coding_code_id = c.coding_code_id and g.bsflag='0' and c.bsflag='0'";
			if(bussId=='M105'){
				sql += " join gms_mat_buss_infomation i on g.wz_id=i.wz_id and i.bsflag='0' and i.mat_menu_id='<%=bussId %>'"; 
			}
			sql += " order by g.coding_code_id asc,g.wz_id asc";
				//}else{
			//sql +="select c.code_name, g.wz_id ,g.coding_code_id,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price from gms_mat_infomation_wtc  w inner join gms_mat_infomation g on g.wz_id = w.wz_id inner join GMS_MAT_CODING_CODE c on g.coding_code_id = c.coding_code_id and g.bsflag='0'and c.bsflag='0' and w.bsflag ='0' order by g.coding_code_id asc,g.wz_id asc";
					//}
			}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/multiproject/matLedger/matItemList.jsp";
		queryData(1);
	}

	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!= undefined){
			 retObj = jcdpCallService("MatItemSrv", "getMatLedger", "laborId="+shuaId);
			
		}else{
			var ids = document.getElementById('rdo_entity_id').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("MatItemSrv", "getMatLedger", "laborId="+ids);
		}
		    
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			if(userId == 'C105'){
				var retObj = jcdpCallService("MatItemSrv", "deleteMatLedger", "matId="+ids);
			}
			else{
				var retObj = jcdpCallService("MatItemSrv", "deleteMatLedgerWTC", "matId="+ids);
				}
			queryData(cruConfig.currentPage);
		}  
	}

	  function toAdd(){ 
//		  if(userId == 'C105'){
//			  if(codeId==null){
//				confirm("请选择物资分类!");
//			  }else{
//				popWindow("<%=contextPath%>/mat/multiproject/matLedger/matLedgerEdit.jsp?bussId=<%=bussId %>&codeName="+getQueryString("codeName"));
//			  }
//		  }else{
			  
			  popWindow("<%=contextPath%>/mat/multiproject/matLedger/matLedgerMenuWTC.jsp?bussId=<%=bussId %>","1000:700");
//		  }

	 }  
	  
	 function toAddNew(){
		  if(codeId==null){
			confirm("请选择物资分类!");
		  }else{
			popWindow("<%=contextPath%>/mat/multiproject/matLedger/matLedgerEdit.jsp?codeName="+getQueryString("codeName"));
		  }
	 } 
	  
	  function toEdit(){ 
		  ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
				 popWindow('<%=contextPath%>/mat/multiproject/matLedger/queryMatLedger.srq?laborId='+ids);
			
		}
	
       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }  
       function simpleSearch(){
    	   var sql ="select g.*, c.code_name from gms_mat_infomation g inner join GMS_MAT_CODING_CODE c on g.coding_code_id = c.coding_code_id and g.bsflag='0' and c.bsflag='0'";
			var wz_name = document.getElementById("s_wz_name").value;
			var wz_id = document.getElementById("s_wz_id").value;
			if(wz_name !='' && wz_name != null || wz_id !='' && wz_id != null){
				if(wz_name !=''){
					sql += " and g.wz_name like'%"+wz_name+"%'";
				}
				if(wz_id !='' && wz_id != null){
					sql += " and g.wz_id like'%"+wz_id+"%'";
					}
			}
			else{
				alert('请输入查询内容！');
				}  
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/multiproject/matLedger/matItemList.jsp";
			queryData(1);
			
	}
   	
     function clearQueryText(){
 		document.getElementById("s_wz_name").value = "";
 		document.getElementById("s_wz_id").value = "";
   	} 
     
    function submitInfo(){
 		var obj = document.getElementsByName("rdo_entity_id");
 		var count = 0;
 		var selectedids = "('";
 		for(var index = 0;index<obj.length;index++){
 			var selectedobj = obj[index];
 			if(selectedobj.checked == true){
 				if(index==0){
 					selectedids += obj[index].value;
 				}
 				else{
 					selectedids += "','"+obj[index].value;
 				}
 				count ++;
 				
 			}
 		}
 		selectedids +="')";
 		if(count == 0){
 			alert("请选择记录!");
 			return;
 		}
 		
 		window.returnValue = selectedids;
 		window.close();
 	}
 	function newClose(){
 		window.close();
 	}
       
</script>

</html>

