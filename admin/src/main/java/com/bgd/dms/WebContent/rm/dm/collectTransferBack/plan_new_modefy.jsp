<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.util.DateUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String userName = user.getUserName();
	String devicerepappid = request.getParameter("devicerepappid");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>新建返还单</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend>返还申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >返还申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="repappname" id="repappname" class="input_width" style="width:92%" type="text" />
          	<input name="devicerepappid" id="devicerepappid" class="input_width"  type="hidden" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还申请单号:</td>
          <td class="inquire_form4" >
          	<input name="device_repapp_no" id="device_repapp_no" class="input_width" type="text" value="提交后自动生成..." readonly/>
          </td>
          <td class="inquire_item4">申请时间</td>
          <td class="inquire_form4">
          	<input name="repdate" id="repdate" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">返还单位:</td>
          <td class="inquire_form4">
          	<input name="rep_org_name" id="rep_org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showRepOrgTreePage()"  />
          	<input name="rep_org_id" id="rep_org_id" class="input_width" value="<%=user.getOrgId()%>" type="hidden" />
          </td>
          <td class="inquire_item4">接收单位:</td>
          <td class="inquire_form4">
          	<input name="receive_org_name" id="receive_org_name" class="input_width" type="text" readonly/>
          	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
          	<input name="receive_org_id" id="receive_org_id" class="input_width" type="hidden" />
          </td>
        </tr>
      </table>
      </fieldset>
      <fieldset style="margin-left:2px"><legend>返还申请基本信息</legend>
	      <div id="oprdiv0" name="oprdiv" style="float:left;width:100%;overflow:auto;">
	      	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  	<tr align="right">
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_cdn_name" ></td>
			  		<td class="ali_cdn_input" ></td>
			  		<td class="ali_query">
			    	<auth:ListButton functionId="" css="zj" event="onclick='addCollRows()'" title="添加设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delCollRows()'" title="删除设备"></auth:ListButton>
			    	</td>
				</tr>
			  </table>
		  </div>
		  <div id="resultdiv0" name="resultdiv" style="float:left;height:210px;">
			  <table width="95%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="5%">操作</td>
					<td class="bt_info_even" width="17%">设备名称</td>
					<td class="bt_info_odd" width="16%">规格型号</td>
					<td class="bt_info_even" width="7%">计量单位</td>
					<td class="bt_info_odd" width="7%">完好闲置数量</td>
					<td class="bt_info_even" width="7%">返还数量</td>
				</tr>
		      </table>
		      <div style="height:183px;overflow:auto;">
		      	<table width="95%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable0" name="processtable0" >
			   		</tbody>
		      	</table>
		      </div>
		  </div>
      </fieldset>
    </div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function saveInfo(){
		var repappname = $("#repappname").val();
		if(repappname == ""){
			alert("请输入返还申请单名称!");
			return;
		}
		var receive_org_name = $("#receive_org_name").val();
		if(receive_org_name == ""){
			alert("请输入接收单位!");
			return;
		}
		//必须得添加子记录
		var subsize = $("#processtable0>tr").size();
		if(subsize==0){
			alert("请添加自己录!");
			return;
		}
		//将申报单的名字置为空
		$("#device_repapp_no").val("");
		//给子表的KEY信息拼起来
		var subkeyinfo = "";
		$("input[name='idinfo']").each(function(i){
			if(i==0){
				subkeyinfo = this.id;
			}else{
				subkeyinfo += ","+this.id;			
			}
		});
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/modefyTransforRepCollectAppInfo.srq?state=0&repapptype=2&subkeyinfo="+subkeyinfo;
		document.getElementById("form1").submit();
	}
	function addCollRows(){
		var paramobj = new Object();
		var reporgid = document.getElementById("rep_org_id").value;
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/collectTransferBack/selectAccountForBack.jsp?reporgid="+reporgid,paramobj,"dialogWidth=1024px;dialogHeight=768px");
		if(vReturnValue == undefined){
			return;
		}
		var accountidinfos = vReturnValue.split("|","-1");
		var condition ="(";
		
			for(var index=0;index<accountidinfos.length;index++){
				if(index==0)
					condition += "'"+accountidinfos[index]+"'";
				else
					condition += ",'"+accountidinfos[index]+"'";
				
			}
			condition += ") ";
		
		var devdetSql = "select account.*,unitsd.coding_name as unit_name ";
			devdetSql += "from gms_device_coll_account account ";
			devdetSql += "join comm_coding_sort_detail unitsd on account.dev_unit=unitsd.coding_code_id ";
			devdetSql += "where account.dev_acc_id in "+condition ;
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql);
			var retObj = proqueryRet.datas;
			for(var index=0;index<retObj.length;index++){
				var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' midinfo='"+retObj[index].dev_acc_id+"'>";
				innerhtml += "<td width='5%'><input type='checkbox' name='idinfo' seqinfo='"+index+"' id='"+retObj[index].dev_acc_id+"'/></td>";
				innerhtml += "<td width='17%'><input type='hidden' id='devname"+retObj[index].dev_acc_id+"' name='devname"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_name+"'/>"+retObj[index].dev_name+"</td>";
				innerhtml += "<td width='16%'><input type='hidden' id='devmodel"+retObj[index].dev_acc_id+"' name='devmodel"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_model+"'/>"+retObj[index].dev_model+"</td>";
				innerhtml += "<td width='7%'><input type='hidden' id='devunit"+retObj[index].dev_acc_id+"' name='devunit"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_unit+"'/>"+retObj[index].unit_name+"</td>";
				innerhtml += "<td width='7%'>"+retObj[index].unuse_num+"</td>";
				innerhtml += "<td width='7%'><input type='text' id='sxnum"+retObj[index].dev_acc_id+"' name='sxnum"+retObj[index].dev_acc_id+"' checknum='"+retObj[index].unuse_num+"' onkeyup=checksxnum(this) size='3'/></td>";
				innerhtml += "</tr>";
				$("#processtable0").append(innerhtml);
			}
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
	};
	function checksxnum(obj){
		var maxsxnum = obj.checknum;
		var valueinfo = obj.value;
		var re = /^\+?[1-9][0-9]*$/;
		//检查所有的数量字段 
		if(!re.test(valueinfo)){
			alert("返还数量必须为数字，且大于0!");
			obj.value = "";
			return;
		}else{
			if(parseInt(valueinfo)>parseInt(maxsxnum)){
				alert("返还数量不能大于闲置数量!");
				obj.value = "";
				return;
			}
		}
	}
	function delCollRows(){
		$("input[name='collidinfo']").each(function(){
			if(this.checked){
				$('#tr'+this.id,"#processtable0").remove();
			}
		});
		
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	};
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/collectDevBack/selectOrgHR.jsp?codingSortId=0110000001","test","");
		
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById("receive_org_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("receive_org_id").value = orgId[1];
	}
	/**
	 * 组织机构树选择 返还单位
	 */
	function showRepOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/collectDevBack/selectOrgHR.jsp?codingSortId=0110000001","test","");
		
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById("rep_org_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("rep_org_id").value = orgId[1];
	}
	function refreshData(){
		var retObj;
		//查询明细信息
		var proSql = "select * from gms_device_collrepapp d where d.device_repapp_id='<%=devicerepappid%>'and d.bsflag='0'";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
		retObj = proqueryRet.datas;
		$("#devicerepappid").val(retObj[0].device_repapp_id);
		$("#repappname").val(retObj[0].repapp_name);
		$("#device_repapp_no").val(retObj[0].device_repapp_no);
		$("#repdate").val(retObj[0].repdate);
		$("#rep_org_id").val(retObj[0].rep_org_id);
		$("#rep_org_name").val(getBackOrgName(retObj[0].rep_org_id));
		$("#receive_org_id").val(retObj[0].receive_org_id);
		$("#receive_org_name").val(getBackOrgName(retObj[0].receive_org_id));
		getDevDatas(retObj[0].device_repapp_id);
	}
	function getBackOrgName(id){
		var proSql = "select t1.org_hr_id, t1.org_hr_short_name as org_name, t2.org_gms_id, t3.org_subjection_id as org_gms_sub_id from bgp_comm_org_hr t1 join bgp_comm_org_hr_gms t2 on t1.org_hr_id=t2.org_hr_id join comm_org_subjection t3 on t3.org_id=t2.org_gms_id and t3.bsflag='0' where t2.org_gms_id='"+id+"'";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
		retObj = proqueryRet.datas;
		return retObj[0].org_name;
		}
	
	function getDevDatas(devicerepappid){
		var devdetSql = "select d.*,ca.unuse_num,sd.coding_name as unit_name from GMS_DEVICE_COLLREPAPP_DETAIL d join (gms_device_coll_account ca join comm_coding_sort_detail sd on ca.dev_unit=sd.coding_code_id) on d.dev_acc_id=ca.dev_acc_id where d.device_repapp_id='"+devicerepappid+"' and d.bsflag='0'";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devdetSql);
		var retObj = proqueryRet.datas;
		for(var index=0;index<retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index].dev_acc_id+"' name='tr' midinfo='"+retObj[index].dev_acc_id+"'>";
			innerhtml += "<td width='5%'><input type='checkbox' name='idinfo' seqinfo='"+index+"' id='"+retObj[index].dev_acc_id+"'/></td>";
			innerhtml += "<td width='17%'><input type='hidden' id='devname"+retObj[index].dev_acc_id+"' name='devname"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_name+"'/>"+retObj[index].dev_name+"</td>";
			innerhtml += "<td width='16%'><input type='hidden' id='devmodel"+retObj[index].dev_acc_id+"' name='devmodel"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_model+"'/>"+retObj[index].dev_model+"</td>";
			innerhtml += "<td width='7%'><input type='hidden' id='devunit"+retObj[index].dev_acc_id+"' name='devunit"+retObj[index].dev_acc_id+"' value='"+retObj[index].dev_unit+"'/>"+retObj[index].unit_name+"</td>";
			innerhtml += "<td width='7%'>"+retObj[index].unuse_num+"</td>";
			innerhtml += "<td width='7%'><input type='text' id='sxnum"+retObj[index].dev_acc_id+"' name='sxnum"+retObj[index].dev_acc_id+"' checknum='"+retObj[index].unuse_num+"' onkeyup=checksxnum(this) size='3' value='"+retObj[index].rep_num+"'/></td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
		}
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
		}
	</script>
</html>

