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
<title>新建送修单</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin-left:2px"><legend>送修申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >送修申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="repappname" id="repappname" class="input_width" style="width:92%" type="text" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">送修申请单号:</td>
          <td class="inquire_form4" >
          	<input name="device_repapp_no" id="device_repapp_no" class="input_width" type="text" value="提交后自动生成..." readonly/>
          </td>
          <td class="inquire_item4">申请时间</td>
          <td class="inquire_form4">
          	<input name="repdate" id="repdate" class="input_width" type="text" value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">送修单位:</td>
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
      <fieldset style="margin-left:2px"><legend>送修申请基本信息</legend>
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
					<td class="bt_info_odd" width="7%">维修数量</td>
					<td class="bt_info_even" width="7%">送修数量</td>
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
			alert("请输入送修申请单名称!");
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
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveTransforRepCollectAppInfo.srq?state=0&repapptype=1&subkeyinfo="+subkeyinfo;
		document.getElementById("form1").submit();
	}
	function addCollRows(){
		var paramobj = new Object();
		var reporgid = document.getElementById("rep_org_id").value;
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/collectTransfer/selectAccountForRep.jsp?reporgid="+reporgid,paramobj,"dialogWidth=820px;dialogHeight=380px");
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
		
		var devdetSql = "select account.*,tech.torepair_num,unitsd.coding_name as unit_name ";
			devdetSql += "from gms_device_coll_account account ";
			devdetSql += "join gms_device_coll_account_tech tech on account.dev_acc_id=tech.dev_acc_id ";
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
				innerhtml += "<td width='7%'>"+retObj[index].torepair_num+"</td>";
				innerhtml += "<td width='7%'><input type='text' id='sxnum"+retObj[index].dev_acc_id+"' name='sxnum"+retObj[index].dev_acc_id+"' checknum='"+retObj[index].torepair_num+"' onkeyup=checksxnum(this) size='3'/></td>";
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
			alert("送修数量必须为数字，且大于0!");
			obj.value = "";
			return;
		}else{
			if(parseInt(valueinfo)>parseInt(maxsxnum)){
				alert("送修数量不能大于维修数量!");
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
	 * 组织机构树选择 送修单位
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
		var proSql = "select to_char(sysdate,'yyyy-mm-dd') as repdate from dual ";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
		retObj = proqueryRet.datas;
		$("#repdate").val(retObj[0].repdate);
	}
</script>
</html>

