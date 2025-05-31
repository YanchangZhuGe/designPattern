<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectinfono = request.getParameter("projectinfono");
	String device_backdet_id = request.getParameter("device_backdet_id");
	String device_acc_id_dui = request.getParameter("dui_acc_id");
	
	ResourceBundle rb = ResourceBundle.getBundle("devCodeDesc");
	String[] backTypeIDs = rb.getString("BackTypeID").split("~", -1);
	String backtypewaizu = backTypeIDs[0];
	String backtypeziyou = backTypeIDs[1];
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>

 <title>查询队级返还页面</title> 
 </head> 
 
 <body style="background:#F1F2F3" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_name" name="s_dev_ci_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_model" name="s_dev_ci_model" type="text" class="input_width" />
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
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='dev_acc_id_head' name='dev_acc_id'>
			     	<td class="bt_info_odd"><input type='checkbox' id='collbackinfo' name='collbackinfo'/></td>
					<td class="bt_info_odd">设备名称</td>
					<td class="bt_info_even">规格型号</td>
					<td class="bt_info_odd">实物标识号</td>
					<td class="bt_info_even">实际进场时间</td>
			     </tr>
			    <tbody id="detaillist" name="detaillist" >
			   </tbody>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			 <table>
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
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">

	var projectInfoNos = '<%=projectinfono%>';
	var device_backdet_id = '<%=device_backdet_id %>';
	var device_acc_id_dui = '<%=device_acc_id_dui%>';
	function refreshData(v_dev_ci_name,v_dev_ci_model){
		var str = "select d.device_id,d.dev_name,d.dev_model,b.dev_sign,d.actual_in_time,b.dev_acc_id from gms_device_coll_account_dui d ";
		str += " join GMS_DEVICE_COLL_ACC_DUI_DETAIL s on d.dev_acc_id=s.dev_acc_dui_id left join gms_device_account_b b ";
		str += " on s.dev_acc_id=b.dev_acc_id where d.dev_acc_id='"+device_acc_id_dui+"' ";
		/* str += " on s.dev_acc_id=b.dev_acc_id where d.dev_acc_id='"+device_acc_id_dui+"' and (d.is_leaving is null or d.is_leaving='0') "; */
		str += " and s.dev_acc_id not in(select bdet.dev_acc_id from GMS_DEVICE_COLL_BACK_DETAIL bsub join ";
		str += " GMS_DEVICE_RFCOLINFORM_DET bdet on bsub.device_coll_backdet_id=bdet.device_coll_backdet_id where ";
		str += " bsub.device_coll_backdet_id='"+device_backdet_id+"')";
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and d.dev_name like '"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and d.dev_model like '"+v_dev_ci_model+"%' ";
		}
		
		var proqueryRet = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		var retObj = proqueryRet.datas;
		$("#detaillist").empty();
		for(var index=0;index<retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' midinfo='"+retObj[index].dev_acc_id+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' did='"+retObj[index].device_id+"' id='"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_acc_id+"'/></td>";
			innerhtml += "<td>"+retObj[index].dev_name+"</td>" ;
			innerhtml += "<td>"+retObj[index].dev_model+"</td>";
			innerhtml += "<td>"+retObj[index].dev_sign+"</td>";
			innerhtml += "<td>"+retObj[index].actual_in_time+"</td>";
			innerhtml += "</tr>";
			$("#detaillist").append(innerhtml);
		}
		$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
		$("#detaillist>tr:odd>td:even").addClass("odd_even");
		$("#detaillist>tr:even>td:odd").addClass("even_odd");
		$("#detaillist>tr:even>td:even").addClass("even_even");
	}
	function submitInfo(){
		var length = 0;
		var selectedids = "";
		var did = "";
		$("input[type='checkbox'][name='idinfo']").each(function(i,k){
			if(k.checked == true){
				if(length != 0){
					selectedids += ",";
					did += ",";
				}
				selectedids += k.value;
				did += k.did;
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录!");
			return;
		}
		var r = {"id":selectedids,"did":did};
		window.returnValue = r;
		window.close();
	}
	function newClose(){
		window.close();
	}
	$().ready(function(){
		$("#collbackinfo").change(function(){
			var checkvalue = this.checked;
			$("input[type='checkbox'][name='idinfo']").attr('checked',checkvalue);
		});
		
		
	});
</script>
</html>