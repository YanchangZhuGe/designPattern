<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String suborgid = user.getSubOrgIDofAffordOrg();
	int orgidlength = suborgid.length();
	String handleFlag = request.getParameter("handleFlag");
	String hflag = request.getParameter("hflag");
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

 <title>查询多项目的设备台账</title> 
 </head> 


 <body style="background:#F1F2F3;overflow:auto" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box" style="height:64px;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_131.png" width="6" height="64" /></td>
			    <td background="<%=contextPath%>/images/list_151.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="dev_name" name="dev_name" type="text" /></td>
			     <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input"><input id="dev_model" name="dev_model" type="text" /></td>
			    <td class="ali_cdn_name">牌照号</td>
			    <td class="ali_cdn_input"><input id="license_num" name="license_num" type="text" /></td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_171.png" width="4" height="64" /></td>
			  </tr>
			</table>
			</div>
			<div>
			  <table border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable" >		
			    <tr id='device_hireapp_id_{device_hireapp_id}' name='device_hireapp_id' ondblclick='toModifyDetail(this)' idinfo='{device_hireapp_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{scrape_detailed_id}' id='selectedbox_{scrape_detailed_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_type}">设备编号</td>
					<td class="bt_info_even" exp="{dev_model}">设备型号</td>
					<td class="bt_info_even" exp="{asset_coding}">资产编号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{asset_value}">原值</td>
					<td class="bt_info_even" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_even" exp="{producting_date}">投产日期</td>
					<td class="bt_info_even" exp="{scrape_date}">报废日期</td>
					<td class="bt_info_even" exp="{scrape_apply_no}">报废单号</td>
					<td class="bt_info_even" exp="{bak1}">备注</td>
					<td class="bt_info_even" exp="{dev_coding}">ERP设备编号</td>
					<td class="bt_info_even" exp="{net_value}">净值</td>
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
	</div>
	<div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	cruConfig.queryService = "ScrapeSrv";
	cruConfig.queryOp = "queryScrapeList";
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
function searchDevData(){
		var dev_name = document.getElementById("dev_name").value;
		var dev_model = document.getElementById("dev_model").value;
		var license_num = document.getElementById("license_num").value;
		refreshData(dev_name, dev_model,license_num);
	}
	function clearQueryText(){
		var dev_name = document.getElementById("dev_name").value="";
		var dev_model = document.getElementById("dev_model").value="";
		var license_num = document.getElementById("license_num").value="";
		refreshData("", "", "");
	}
 function refreshData(dev_name, dev_model,license_num){
 var handleFlag = <%=handleFlag%>;
  var hflag = <%=hflag%>;
 var obj = window.dialogArguments;
      	var temp = "";
		if(typeof dev_name!="undefined" && dev_name!=""){
			temp += "&dev_name="+dev_name;
		}
		if(typeof dev_model!="undefined" && dev_model!=""){
			temp += "&dev_model="+dev_model;
		}
		if(typeof license_num!="undefined" && license_num!=""){
			temp += "&license_num="+license_num;
		}
		if(obj!= null){
			if(obj.pageselectedstr != null){
				temp += "&pageselectedstr="+obj.pageselectedstr;
			}
		}
		if(handleFlag != null){
		temp += "&handleFlag="+handleFlag;
		}
		if(hflag != null){
		temp += "&hflag="+hflag;
		}
		cruConfig.submitStr = temp;	
		queryData(1);
	}
	
	function submitInfo(){
		var obj = document.getElementsByName("selectedbox");
		var count = 0;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				count ++;
			}
		}
		if(count == 0){
			alert("请选择一条记录!");
			return;
		}
		var selectedids = null;
		var columnsObj = null;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				selectedids = selectedobj.value;
				columnsObj = selectedobj.parentNode.parentNode.cells;
				break;
			}
		}
		//返回信息是  类别id + 设备编码 + 设备名称 + 规格型号 +
		selectedids += "~"+columnsObj[2].innerText+"~"+columnsObj[3].innerText+"~"+columnsObj[4].innerText+"~"+columnsObj[7].innerText+"~"+columnsObj[10].innerText+"~"+columnsObj[12].innerText+"~"+columnsObj[13].innerText+"~"+columnsObj[14].innerText;
		window.returnValue = selectedids;
		window.close();
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