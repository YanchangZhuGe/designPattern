<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String devicerepappid = request.getParameter("devicerepappid");
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
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>装备内部返还</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
		<fieldSet style="margin-left:0px"><legend >内部返还基本信息</legend>
	      	<table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	        	<tr>
	        		<td class="inquire_item4" >调剂申请单名称:</td>
	          		<td class="inquire_form4" ><input type="text" id="txt_repapp_name" class="input_width" readonly/></td>
	          		<td class="inquire_item4" >调剂申请单号:</td>
	          		<td class="inquire_form4" ><input type="text" id="txt_repapp_no" class="input_width" readonly/></td>
	        	</tr>
	        	<tr>
	        		<td class="inquire_item4" >申请单位名称:</td>
	          		<td class="inquire_form4" ><input type="text" id="txt_rep_org"  class="input_width" readonly/></td>
	          		<td class="inquire_item4" >接收单位名称</td>
	          		<td class="inquire_form4" ><input type="text" id="txt_receive_org"  class="input_width" readonly/></td>
	        	</tr>
	        </table>
	      </fieldSet>
		  <fieldSet style="margin-left:0px"><legend >内部返还明细信息</legend>
				<div >
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
				     <tr id='device_appdet_id_{device_app_detid}' name='device_app_detid'>
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">设备名称</td>
						<td class="bt_info_even">设备型号</td>
						<td class="bt_info_odd">计量单位</td>
						<td class="bt_info_even">返还数量</td>
				     </tr>
				     <tbody id="detlist"></tbody>
				  </table>
				</div>
			</fieldSet>
			<fieldSet style="margin-left:0px"><legend >审批信息</legend>
				<form name="form1" id="form1" method="post" action="">
				<table>
					<tr>
						<td width="20%" align="right" valign="top">意见:</td>
						<td width="80%">
						<input type="hidden" name="device_repapp_id" value="<%=devicerepappid%>">
						<textarea id="leaderinfo" name="leaderinfo" cols="60" rows="2"></textarea></td>
					</tr>
				</table>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none;">
					<wf:getProcessInfo />
				</div>
				</form>
			</fieldSet>
		 </div>
		 <div id="oper_div">
	     	<span class="qc" title="审批不通过"><a href="#" onclick="submitInfo(0)"></a></span>
		   	<span class="tj" title="审批通过"><a href="#" onclick="submitInfo(1)"></a></span>
		 </div>
 	</div>
 </div>
</body>
<script type="text/javascript">
    var selectedTagIndex=0;
	function frameSize(){
		//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
		setTabBoxHeight();
	}
	frameSize();
	
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

	var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
	}
	
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}
	
    function refreshData(){
    	//查询基本信息
    	var basestr = "select repapp.device_repapp_id,repapp.device_repapp_no,repapp.repapp_name, "+
    		"reporg.org_name as rep_org_name,receiveorg.org_name as receive_org_name from gms_device_collrepapp repapp "+
    		"left join comm_org_information reporg on repapp.rep_org_id=reporg.org_id "+
    		"left join comm_org_information receiveorg on repapp.receive_org_id=receiveorg.org_id "+
    		"where repapp.device_repapp_id='<%=devicerepappid%>'";
    		alert(basestr);
    	var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+basestr);
		retObj = queryRet.datas;
		//回填基本信息
		if(retObj!=undefined&&retObj.length>0){
			$("#txt_repapp_name").val(retObj[0].repapp_name);
			$("#txt_repapp_no").val(retObj[0].device_repapp_no);
			
			$("#txt_rep_org").val(retObj[0].rep_org_name);
			$("#txt_receive_org").val(retObj[0].receive_org_name);
		}
    	//查询明细信息
		var str = "select collrepdet.dev_acc_id,collrepdet.dev_name,collrepdet.dev_model,collrepdet.rep_num,sd.coding_name as unit_name "+
			"from gms_device_collrepapp_detail collrepdet "+
			"left join comm_coding_sort_detail sd on collrepdet.dev_unit=sd.coding_code_id ";
		str += "where collrepdet.device_repapp_id = '<%=devicerepappid%>' ";
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = queryRet.datas;
		if(retObj!=undefined&&retObj.length>0){
			for(var index=0;index<retObj.length;index++){
				var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' >";
				innerhtml += "<td>"+(index+1)+"</td>";
				innerhtml += "<td>"+retObj[index].dev_name+"</td>";
				innerhtml += "<td>"+retObj[index].dev_model+"</td>";
				innerhtml += "<td>"+retObj[index].unit_name+"</td>";
				innerhtml += "<td>"+retObj[index].rep_num+"</td>";
				innerhtml += "</tr>";
				$("#detlist").append(innerhtml);
			}
			//样式
			$("#detlist>tr:odd>td:odd").addClass("odd_odd");
			$("#detlist>tr:odd>td:even").addClass("odd_even");
			$("#detlist>tr:even>td:odd").addClass("even_odd");
			$("#detlist>tr:even>td:even").addClass("even_even");
		}
	}
	function loadDataDetail(devicerepappid){
    }
	
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }
    
    function submitInfo(oprinfo){
		var oprstate;
		if(oprinfo==1){
			oprstate = "pass";
		}else{
			oprstate = "notPass";
		}
		var leaderinfo = document.getElementById("leaderinfo").value;
		if(leaderinfo == ""){
			alert("请填写意见项!");
			return;
		}
		document.getElementById("isPass").value=oprstate;
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveCollAccRepairBackInfowfpa.srq?oprstate="+oprstate;;
		document.getElementById("form1").submit();
	}
</script>
</html>