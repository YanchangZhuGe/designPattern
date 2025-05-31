<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.bgp.gms.service.op.util.OPCommonUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo= user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/costTargetShare/costTargetShareCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/op/js/opCostCommonJs.js"></script>
<title></title>
</head>
<body style="background:#fff" >






      	<div id="list_table" >
			<div id="inq_tool_box" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name"></td>
			    <td class="ali_cdn_input"></td>
			    <td class="ali_cdn_name"></td>
			    <td class="ali_cdn_input"></td>
			    <td class="ali_query">
				  
			    </td>
			    <td class="ali_query">
				    
				</td>
			    <td>&nbsp;</td>
			    <td align="center" ><font color="red"><span id="sum_value"></span></font></td>
			   
			 
			    <auth:ListButton functionId="OP_TARGET_OIL_EDIT" css="zj" event="onclick='toAdd()'" functionId="OP_TARGET_OIL_EDIT"  title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="OP_TARGET_OIL_EDIT" css="xg" event="onclick='toEdit()'"  functionId="OP_TARGET_OIL_EDIT"  title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="OP_TARGET_OIL_EDIT" css="sc" event="onclick='toDelete()'"  functionId="OP_TARGET_OIL_EDIT"  title="JCDP_btn_delete"></auth:ListButton>
			   
			  </tr>
			   
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box"  >
			  <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    	<tr class="bt_info">

			    		<td class="bt_info_odd" exp="<input type='checkbox' name='para_id' value='{id}' id='para_id_{id}' onclick=doCheck(this)/>" >选择</td>
			    		
			    	    <td  class="bt_info_even" exp="{field_name}" >名称</td>
			            <td class="bt_info_odd" exp="{field_type}" func="getOpValue,paraType">类型</td>
			            <td  class="bt_info_even" exp="{field_order}">序号</td>
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

var paraType = new Array(
		['0','字符'],['1','数字']
		);




function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	//setTabBoxHeight();
	$("#table_box").css("height",$(window).height()*0.9);
}
frameSize();

//$(document).ready(readyForSetHeight);
//$(document).ready(lashen);
	
cruConfig.contextPath =  "<%=contextPath%>";
var rowsCount=0;
var queryListAction = "/tcg/ajaxServiceProxyAction.srq?JCDP_SRV_NAME=OPCostSrv&JCDP_OP_NAME=getDeviceShareInfo&projectInfoNo=<%=projectInfoNo%>";


cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
cruConfig.queryStr = "";
cruConfig.queryService = "WtWorkMethodSrv";
cruConfig.queryOp = "queryWtAfPara";
var projectInfoNo = '<%=projectInfoNo%>';



function refreshData(i){
	queryData(i);
}

refreshData(1);
 
function toAdd(){
	 popWindow(cruConfig.contextPath+"/wt/tm/parameter/afParameterAdd.jsp");
	
}

function toEdit(){
    ids = getSelIds('para_id');
    if(ids==''){ alert("请先选中一条记录!");
     	return;
    }	
    if(ids.split(",").length > 1){
    	alert("只能编辑一条记录");
    	return;
    }
    popWindow(cruConfig.contextPath+"/wt/tm/parameter/afParameterAdd.jsp?paraId="+ids+"&pi="+cruConfig.currentPage);

}


function toDelete(){
	var fileIds = "";
    ids = getSelIds('para_id');
    if(ids==''){ 
    	alert("请先选中一条记录!");
     	return;
    }	

    var params = ids.split(',');    
    for(var i=0;i<params.length;i++){
    	fileIds = fileIds+",'"+params[i]+"'";
    }
    fileIds = fileIds.substring(1,fileIds.length);

    var sql = "delete from GP_WT_PARAMETER_AF_PARA t where  t.id in ("+fileIds+");"
    
	if(confirm('确定要删除吗?')){  
		var retObj = jcdpCallService("WtWorkMethodSrv", "executeBySql", "sql="+sql);
		
		queryData(cruConfig.currentPage);
		ftsn();
		
	}
}


//设置类型
function ftsn(){
	$("span[name^='ftsn']").each(function(i, o){
		if($(o).html()==0){
			$(o).html('字符');
		}else{
			$(o).html('数字');
		}
	});
}


</script>

</html>

