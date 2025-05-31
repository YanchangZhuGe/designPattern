<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

  <title>单项目-外租离场</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
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
			    <auth:ListButton functionId="" css="jh" event="onclick='toFillLeavePage()'" title="确定离场"></auth:ListButton>
			     <auth:ListButton functionId="" css="xg" event="onclick='toModefyDatas()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='dev_acc_id_{dev_acc_id}' name='dev_acc_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{dev_acc_id}' id='selectedbox_{dev_acc_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{total_num}">总数量</td>
					<td class="bt_info_odd" exp="{unuse_num}">在队数量</td>
					<td class="bt_info_odd" exp="{use_num}">离队数量</td>
					<td class="bt_info_even" exp="{actual_in_time}">实际进场时间</td>
					<td class="bt_info_odd" exp="{planning_out_time}">计划离场时间</td>
					<td class="bt_info_even" exp="{actual_out_time}">实际离场时间</td>
					<td class="bt_info_odd" exp="{is_leaving_desc}">是否离场</td>
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
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <!--<li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>-->
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="detailMap" name="detailMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">设备名称：</td>
				      <td  class="inquire_form6" ><input id="dev_ci_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;规格型号：</td>
				      <td  class="inquire_form6"><input id="dev_ci_model" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">是否离场：</td>
				      <td  class="inquire_form6"><input id="is_leaving_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">总数量:</td>
				     <td  class="inquire_form6"><input id="total_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td  class="inquire_item6">在队数量：</td>
				     <td  class="inquire_form6"><input id="unuse_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td  class="inquire_item6">离队数量：</td>
				     <td  class="inquire_form6"><input id="use_num" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				     <td  class="inquire_item6">&nbsp;计划离场时间：</td>
				     <td  class="inquire_form6"><input id="planning_out_time" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">实际离场时间：</td>
				     <td  class="inquire_form6"><input id="actual_out_time" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    <td  class="inquire_item6">实际进场时间：</td>
				     <td  class="inquire_form6"><input id="actual_in_time" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none;">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>
			</div>
			<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
			</div>
			<div id="tab_box_content5" name="tab_box_content5" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
			</div>
		 </div>
</div>
</body>
<script type="text/javascript">
	function frameSize(){
		//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
		setTabBoxHeight();
	}
	frameSize();

	function getContentTab(obj,index) { 
		$("LI","#tag-container_3").removeClass("selectTag");
		var contentSelectedTag = obj.parentElement;
		contentSelectedTag.className ="selectTag";

		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
			}
		});
		if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}

	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})	

	$(document).ready(lashen);

</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNos = '<%=projectInfoNo%>';
	var projectType="<%=projectType%>";
	var ret;
	var retFatherNo;
	var sonFlag = null;//是否为子项目标志

	$().ready(function(){

		//井中地震获取子项目的父项目编号 
		if(projectInfoNos!=null && projectType == "5000100004000000008"){
			ret = jcdpCallService("DevCommInfoSrv", "getFatherNoInfo", "projectInfoNo="+projectInfoNos);
			retFatherNo = ret.deviceappMap.project_father_no;
		}

		//井中地震子项目屏蔽新增、修改、删除、提交、编辑明细按钮
	    if(projectType == "5000100004000000008" && retFatherNo.length>=1){
	    	sonFlag = 'Y';
	    	$(".jh").hide();
	    	$(".xg").hide();
	    }else{
	    	sonFlag = 'N';
	    }
	});

	function searchDevData(){
		var v_dev_ci_name = document.getElementById("s_dev_ci_name").value;
		var v_dev_ci_model = document.getElementById("s_dev_ci_model").value;
		refreshData(v_dev_ci_name, v_dev_ci_model);
	}
	function clearQueryText(){
		document.getElementById("s_dev_ci_name").value = "";
		document.getElementById("s_dev_ci_model").value = "";
	}
	function refreshData(v_dev_ci_name,v_dev_ci_model){
		var str = "select account.dev_acc_id ,account.total_num,  account.unuse_num,   account.use_num,";
			str += "account.actual_in_time,account.planning_out_time,account.actual_out_time,";
			str += "account.dev_name,account.dev_model,case account.is_leaving when '0' then '未离场' else '已离场' end as is_leaving_desc ";
			str += "from gms_device_coll_account_dui account ";
			//str += "where account.project_info_id='"+projectInfoNos+"' and account.account_stat='0110000013000000005' ";

			//井中地震 
			if(projectType == "5000100004000000008" && retFatherNo.length >= 1)//子项目
			{
				str += "where account.project_info_id='"+retFatherNo+"' and account.account_stat='0110000013000000005' ";
			}else{
	        	str += "where account.project_info_id='"+projectInfoNos+"' and account.account_stat='0110000013000000005' ";
		     }
			
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and account.dev_name like '"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and account.dev_model like '"+v_dev_ci_model+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
		
	}
</script>
<script type="text/javascript">	
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    }   

    function loadDataDetail(device_backdet_id){
    	var retObj;
    	var devicebackdetid;
		if(device_backdet_id!=null){
			devicebackdetid = device_backdet_id;
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    devicebackdetid = ids;
		}
		
		var str = "select account.dev_acc_id, account.total_num,  account.unuse_num,   account.use_num, ";
		str += "account.actual_in_time,account.planning_out_time,account.actual_out_time, ";
		str += "account.dev_name,account.dev_model,case account.is_leaving when '0' then '未离场' else '已离场' end as is_leaving_desc ";
		str += "from gms_device_coll_account_dui account ";
		str += "where account.project_info_id='"+projectInfoNos+"' and account.account_stat='0110000013000000005' ";
		str += "and account.dev_acc_id='"+devicebackdetid+"'";
		
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = unitRet.datas;
		$("#dev_ci_name","#detailMap").val(retObj[0].dev_name);
		$("#dev_ci_model","#detailMap").val(retObj[0].dev_model);
		$("#total_num","#detailMap").val(retObj[0].total_num);
		$("#use_num","#detailMap").val(retObj[0].use_num);
		$("#unuse_num","#detailMap").val(retObj[0].unuse_num);
		$("#actual_in_time","#detailMap").val(retObj[0].actual_in_time);
		$("#planning_out_time","#detailMap").val(retObj[0].planning_out_time);
		$("#actual_out_time","#detailMap").val(retObj[0].actual_out_time);
		$("#is_leaving_desc","#detailMap").val(retObj[0].is_leaving_desc);
		//选中这一条checkbox
		$("#selectedbox_"+retObj[0].dev_acc_id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].dev_acc_id+"']").removeAttr("checked");
    }
    
   function toFillLeavePage(){
    	if(sonFlag == 'Y'){
				return;
		  }
		  var ids = getSelIds('selectedbox');  
	  	if(ids==''){
	  		alert("请选择一条记录!");
	  		return;
	  	}
	  	selId = ids.split(','); 
	  	var idss = "";
			var querysql = "select * from gms_device_coll_account_dui dui where dui.is_leaving='1' ";
				querysql += "and dui.dev_acc_id in (";		
			for(var i=0;i<selId.length;i++){
				if(idss!="") idss += ",";
				idss += "'"+selId[i]+"'";
			}
			querysql = querysql+idss+")";
		
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querysql+'&pageSize=1000');
			var basedatas = queryRet.datas;
		
			if(basedatas.length == 0){
				popWindow('<%=contextPath%>/rm/dm/devrentleft/devrentleftJBQFill.jsp?devaccid='+selId,'950:680');
			}else{
				alert("存在已离场的设备！");
				return;
			}
	 }
	function dbclickRow(shuaId){
		if(sonFlag == 'Y'){
			return;
		}
		var querysql="select * from gms_device_account_dui dui where dui.dev_acc_id = '"+shuaId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querysql);
		var basedatas = queryRet.datas;
		if(basedatas[0].is_leaving=='0'){
			popWindow('<%=contextPath%>/rm/dm/devrentleft/devrentleftFill.jsp?devaccid='+shuaId,'950:680');
		}else{
			alert("该设备已经离场！");
			return;
		}
	}
	function toModefyDatas(obj){
		var ids = getSelIds('selectedbox');  
	  	if(ids==''){
	  		alert("请选择一条记录!");
	  		return;
	  	}
	  	selId = ids.split(','); 

		popWindow('<%=contextPath%>/rm/dm/devrentleft/devModefyJBQFill.jsp?devaccid='+selId,'950:680');
	}
</script>
</html>