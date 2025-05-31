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
	userId = "C105001";
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

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">资源名称</td>
		 	    <td class="ali_cdn_input"><input class="input_width" id="s_wz_name" name="s_wz_name" type="text" /></td>
				<auth:ListButton functionId="" css="cx" event="onclick='simpleSearch()'" title="JCDP_btn_query"></auth:ListButton>
			    <auth:ListButton functionId="" css="qc" event="onclick='clearQueryText()'" title="JCDP_btn_clear"></auth:ListButton>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			    
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
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
			      <td class="bt_info_even" exp="{wz_name}">资源名称</td>
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
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">常用</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">使用详情</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">备注</a></li>
			    <li id="tag3_3"><a href="#" onclick="getTab3(3)">附件</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table  border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="background:#efefef"> 
				    <tr>
				      <td   class="inquire_item6">资源名称：</td>
				      <td   class="inquire_form6" ><input id="wz_name" class="input_width_no_color" type="text" value=""/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;计量单位：</td>
				      <td  class="inquire_form6"  ><input id="wz_prickie" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;库存数量：</td>
				      <td  class="inquire_form6"  ><input id="stock_num" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				     </tr>
				     <tr >
				     <td  class="inquire_item6">物资分类：</td>
				     <td  class="inquire_form6"><input id="coding_code_id" class="input_width_no_color" type="text"  value=""/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;参考单价：</td>
				     <td  class="inquire_form6"><input id="wz_price" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				      <td  class="inquire_item6">&nbsp;实际单价：</td>
				     <td  class="inquire_form6"><input id="actual_price" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				    </tr>
				    <tr>
				     <td  class="inquire_item6">&nbsp;描述：</td>
				     <td  class="inquire_form6"  ><input id="describe" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>
				     <td  class="inquire_item6">&nbsp;备注：</td>
				     <td  class="inquire_form6"><input id="note" class="input_width_no_color" type="text"  value=""/> &nbsp;</td>  
				    </tr>
				  </table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				   <table id="projectMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	<tr>
			    	    <td  class="bt_info_odd">序号</td>
			            <td  class="bt_info_even">使用单位</td>
			            <td class="bt_info_odd">消耗数量</td>
			        </tr>
			        </table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				   <iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				   </iframe>	

				</div>
				<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				   <table id="projectMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height"  >
			    	
			        </table>
				</div>
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
	var codeId = getQueryString("codeId");
	function refreshData(){
		var sql ='';
		if(codeId !=null && codeId != rootId){
		  
			sql +="select c.code_name, g.wz_id ,g.coding_code_id,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price,t.stock_num,t.actual_price from GMS_MAT_RECYCLEMAT_INFO  t inner join gms_mat_infomation g on g.wz_id = t.wz_id inner join GMS_MAT_CODING_CODE c on g.coding_code_id = c.coding_code_id and t.bsflag ='0'and g.bsflag='0'and c.bsflag='0' and g.coding_code_id like'"+codeId+"%'";
			 
	}
		else
			{
			
			sql +="select c.code_name, g.wz_id ,g.coding_code_id,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price,t.stock_num,t.actual_price from GMS_MAT_RECYCLEMAT_INFO  t inner join gms_mat_infomation g on g.wz_id = t.wz_id inner join GMS_MAT_CODING_CODE c on g.coding_code_id = c.coding_code_id and t.bsflag ='0'and g.bsflag='0'and c.bsflag='0'";
					
			}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/multiproject/repMatLedger/repMatItemList.jsp";
		queryData(1);
	}

	function loadDataDetail(shuaId){
		document.getElementById("remark").src="<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+shuaId
		var retObj;
		if(shuaId!= undefined){
			 retObj = jcdpCallService("MatItemSrv", "getRepMatLedger", "laborId="+shuaId);
			
		}else{
			var ids = document.getElementById('rdo_entity_id').value;
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("MatItemSrv", "getRepMatLedger", "laborId="+ids);
		}
		document.getElementById("wz_name").value = retObj.matInfo.wzName;
		document.getElementById("wz_prickie").value = retObj.matInfo.wzPrickie;
		document.getElementById("describe").value = retObj.matInfo.describe;
		document.getElementById("coding_code_id").value = retObj.matInfo.codingCodeId;
		document.getElementById("wz_price").value = retObj.matInfo.wzPrice;
		document.getElementById("note").value = retObj.matInfo.note;
		document.getElementById("stock_num").value = retObj.matInfo.stockNum;
		document.getElementById("actual_price").value = retObj.matInfo.actualPrice;
		    
	}
	
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			
			var retObj = jcdpCallService("MatItemSrv", "deleteRepMatLedger", "matId="+ids);
				
			queryData(cruConfig.currentPage);
		}  
	}

	  function toAdd(){ 
		
			  popWindow("<%=contextPath%>/mat/multiproject/repeatMatLedger/matLedgerAddMenu.jsp");
			 
	 }  
	  
	  function toEdit(){ 
		  ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				alert("请选择一条记录!");
				return;
			}
				 popWindow('<%=contextPath%>/mat/multiproject/repeatMatLedger/queryMatLedger.srq?laborId='+ids);
			
		}
	
       function chooseOne(cb){   
	        var obj = document.getElementsByName("rdo_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    } 
       function simpleSearch(){
    	   var sql ='';
			var wz_name = document.getElementById("s_wz_name").value;
			sql +="select c.code_name, g.wz_id ,g.coding_code_id,g.wz_name,g.wz_prickie,g.wz_code,g.wz_price,t.stock_num,t.actual_price from GMS_MAT_RECYCLEMAT_INFO  t inner join gms_mat_infomation g on g.wz_id = t.wz_id inner join GMS_MAT_CODING_CODE c on g.coding_code_id = c.coding_code_id and t.bsflag ='0'and g.bsflag='0'and c.bsflag='0' and g.wz_name like'%"+wz_name+"%'";
			cruConfig.cdtType = 'form';
			cruConfig.queryStr = sql;
			cruConfig.currentPageUrl = "/mat/multiproject/repMatLedger/repMatItemList.jsp";
			queryData(1);
			
	}
       function clearQueryText(){
   		document.getElementById("s_wz_name").value = "";
   	}  
       
</script>

</html>

