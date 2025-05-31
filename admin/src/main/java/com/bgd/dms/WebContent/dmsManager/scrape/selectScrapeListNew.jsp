<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String suborgid = user.getSubOrgIDofAffordOrg();
	int orgidlength = suborgid.length();
	String dev_type=request.getParameter("dev_type");
	String file_type=request.getParameter("file_type");
	String scrape_apply_id=request.getParameter("scrape_apply_id");
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
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

 <title>设备台账详情</title> 
 </head> 


 <body style="background:#F1F2F3;overflow:auto" onload="refreshData()">
      	<div id="list_table">
			<div>
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" >		
			    <tr id='device_hireapp_id_{device_hireapp_id}' name='device_hireapp_id' ondblclick='toModifyDetail(this)' idinfo='{device_hireapp_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{scrape_detailed_id}' id='selectedbox_{scrape_detailed_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
						<td class="bt_info_even" exp="{dev_type}">设备编码</td>
					<td class="bt_info_even" exp="{dev_coding}">ERP设备编号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">设备型号</td>
					<td class="bt_info_even" exp="{producting_date}">投产日期</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{asset_value}">原值</td>
					<td class="bt_info_even" exp="{net_value}">净值</td>
					
					<!--<td class="bt_info_even" exp="{scrape_date}">报废日期</td>
					<td class="bt_info_even" exp="{scrape_apply_no}">报废单号</td>
					<td class="bt_info_even" exp="{bak1}">备注</td>-->
					
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
		 </div>
	<div id="oper_div">
		<span>原值总和:</span>   <input name="asset_value" id="asset_value"  readonly value=""/>
		<span>净值总和:</span>   <input name="net_value" id="net_value" readonly value=""/>
		</br>
    </div>
</body>
<script type="text/javascript">
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ScrapeSrvNew";
	cruConfig.queryOp = "getDivMessage";
	var path = "<%=contextPath%>";

function frameSize(){
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	
 function refreshData(){
	var dev_type='<%=dev_type%>';
	var file_type='<%=file_type%>';
	var scrape_apply_id='<%=scrape_apply_id%>';	
	var obj = window.dialogArguments;
      	var temp = "";
      	if(obj.pageselectedstr != null){
   			temp += "&pageselectedstr="+obj.pageselectedstr;
   		}
		if(typeof dev_type!="undefined" && dev_type!=""){
			temp += "&dev_type="+dev_type;
		}
		if(typeof file_type!="undefined" && file_type!=""){
			temp += "&file_type="+file_type;
		}
		if(typeof scrape_apply_id!="undefined" && scrape_apply_id!=""){
			temp += "&scrape_apply_id="+scrape_apply_id;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
		var baseData = jcdpCallService("ScrapeSrvNew", "getAssetNetValues", temp);
		$("#asset_value").val(baseData.asset_value);
		$("#net_value").val(baseData.net_value);
	}
	
	function loadDataDetail(dev_acc_id){
		$("input[type='checkbox'][name='selectedbox']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][id='selectedbox_"+dev_acc_id+"'][disabled!='disabled']").attr("checked","checked");
    }
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i].disabled==false && obj[i]==cb) obj[i].checked = true; 
            else obj[i].checked = false;
        }
    } 
</script>
</html>