<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants,com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String orgSubId = user.getSubOrgIDofAffordOrg();
	String subId = user.getOrgSubjectionId();
	String orgId = user.getOrgId();
	String projectType = user.getProjectType();	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>	

<title>送修单申请</title>
</head>

<body style="background: #fff" onload="refreshData()">
<form name="form" id="form" method="post" action="">
	<div id="list_table">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png"
						width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png"><table
							width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="ali_cdn_name">送外维修单号</td>
								<td class="ali_cdn_input"><input
									id="s_device_repair_app_no" name="s_device_repair_app_no"
									type="text" class="input_width" /></td>
								<td class="ali_cdn_name">送修单名称</td>
								<td class="ali_cdn_input"><input
									id="s_device_repair_app_name" name="s_device_repair_app_name"
									type="text" class="input_width" /></td>
								<td class="ali_query"><span class="cx"><a href="#"
										onclick="searchDevData()" title="查询"></a></span></td>
								<td class="ali_query"><span class="qc"><a href="#"
										onclick="clearQueryText()" title="清除"></a></span></td>
								<td>&nbsp;</td>
								<auth:ListButton functionId="" css="zj"
									event="onclick='toAddDevSendRepairPage()'" title="新增"></auth:ListButton>
								<auth:ListButton functionId="" css="xg"
									event="onclick='toModifyDevRepairPage()'" title="修改"></auth:ListButton>
								<auth:ListButton functionId="" css="sc"
									event="onclick='toDelDevRepairPage()'" title="删除"></auth:ListButton>
								<!-- 
								<auth:ListButton functionId="" css="dc"
									event="onclick='exportData()'" title="导出excel"></auth:ListButton>
									 -->
								<auth:ListButton functionId="" css="tj"
									event="onclick='toSumbitRepairSend()'" title="提交"></auth:ListButton>
							</tr>
						</table></td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png"
						width="4" height="36" /></td>
				</tr>
			</table>
		</div>
		<div id="table_box">
			<table style="width: 98.5%" border="0" cellspacing="0"
				cellpadding="0" class="tab_info" id="queryRetTable">
				<tr id='id_{id}' name='id'
					idinfo='{id}'>
					<td class="bt_info_odd" 
						exp="<input type='checkbox' name='selectedbox' value='{id}'	pro_desc='{pro_desc}' id='selectedbox_{id}' onclick='chooseOne(this)'/>">选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{repair_form_no}">送外维修单号</td>
					<td class="bt_info_odd" exp="{repair_form_name}">送修单名称</td>
					<td class="bt_info_even" exp="{project_name}">所属项目</td>
					<td class="bt_info_odd" exp="{req_comp_name}">送修单位</td>
					<td class="bt_info_even" exp="{service_company}">维修单位</td>
					<!-- 刘广 start -->
					<td class="bt_info_even" exp="{apply_date}">申请日期</td>
					<td class="bt_info_even" exp="{buget_our}">预计原币金额</td>
					<td class="bt_info_even" exp="{buget_local}">预计本币金额</td>
					<td class="bt_info_even" exp="{currency_name}">币种</td>
					<td class="bt_info_even" exp="{rate}">汇率</td>
					<!-- 刘广 end -->
					<td class="bt_info_odd" exp="{creator_name}">创建人</td>
					<td class="bt_info_even" exp="{create_date}">创建日期</td>
					<td class="bt_info_odd" exp="{pro_desc}">状态</td>
				</tr>
			</table>
		</div>
		<div id="fenye_box" style="display: block">
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				id="fenye_box_table">
				<tr>
					<td align="right">第1/1页，共0条记录</td>
					<td width="10">&nbsp;</td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_01.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_02.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_03.png"
						width="20" height="20" /></td>
					<td width="30"><img src="<%=contextPath%>/images/fenye_04.png"
						width="20" height="20" /></td>
					<td width="50">到 <label> <input type="text"
							name="textfield" id="textfield" style="width: 20px;" />
					</label></td>
					<td align="left"><img
						src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				</tr>
			</table>
		</div>
		<div class="lashen" id="line"></div>
		<div id="tag-container_3">
			<ul id="tags" class="tags">
				<li class="selectTag" id="tag3_0"><a href="#"
					onclick="getContentTab(this,0)">基本信息</a></li>
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
				
				
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
				<!--  
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
				-->
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
				<!--  
				<li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
				-->
			</ul>
		</div>
		<div id="tab_box" class="tab_box">
			<div id="tab_box_content0" name="tab_box_content0"
				class="tab_box_content">
				<table id="projectMap" name="projectMap" border="0" cellpadding="0"
					cellspacing="0" class="tab_line_height" width="100%"
					style="margin-top: 10px; background: #efefef">
					<td class="inquire_item6">&nbsp;送外维修单号：</td>
					<td class="inquire_form6"><input id="repair_form_no"
						class="input_width" type="text" value="" disabled /> &nbsp;</td>
					<td class="inquire_item6">送修单名称：</td>
					<td class="inquire_form6"><input id="repair_form_name"
						class="input_width" type="text" value="" disabled /> &nbsp;</td>
					<td class="inquire_item6">所属项目：</td>
					<td class="inquire_form6"><input id="project_name"
						class="input_width" type="text" value="" disabled /> &nbsp;</td>
					</tr>
					<tr>
						<td class="inquire_item6">&nbsp;送修单位：</td>
						<td class="inquire_form6"><input id="req_comp_name"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
						<td class="inquire_item6">维修单位：</td>
						<td class="inquire_form6"><input id="service_company"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
						<td class="inquire_item6">申请日期：</td>
						<td class="inquire_form6"><input id="apply_date"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
					</tr>
					<tr>
						<td class="inquire_item6">&nbsp;预计原币金额：</td>
						<td class="inquire_form6"><input id="buget_our"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
						<td class="inquire_item6">预计本币金额：</td>
						<td class="inquire_form6"><input id="buget_local"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
						<td class="inquire_item6">币种：</td>
						<td class="inquire_form6"><input id="currency_name"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
					</tr>
					<tr>
						<td class="inquire_item6">&nbsp;汇率：</td>
						<td class="inquire_form6"><input id="rate"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
						<td class="inquire_item6">&nbsp;创建人：</td>
						<td class="inquire_form6"><input id="creator_name"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
						<td class="inquire_item6">创建日期：</td>
						<td class="inquire_form6"><input id="create_date"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
					</tr>
					<tr>
						<td class="inquire_item6">状态：</td>
						<td class="inquire_form6"><input id="pro_desc"
							class="input_width" type="text" value="" disabled /> &nbsp;</td>
					</tr>
				</table>
			</div>
			<div id="tab_box_content1" name="tab_box_content1" idinfo=""
				class="tab_box_content" style="display: none">
				<table border="0" cellpadding="0" cellspacing="0"
					class="tab_line_height" width="100%"
					style="margin-top: 10px; background: #efefef">
					<tr class="bt_info">
						<td class="bt_info_even">序号</td>
						<td class="bt_info_odd">设备名称</td>
						<td class="bt_info_even">规格型号</td>
						<td class="bt_info_odd">实物标识号</td>
						<td class="bt_info_odd">故障类别</td>
						<td class="bt_info_even">故障现象</td>
						 <td class="bt_info_even">备注</td>
					</tr>
					<tbody id="detailMap" name="detailMap"></tbody>
				</table>
			</div>
			<div id="tab_box_content2" name="tab_box_content2"
				class="tab_box_content" style="display: none;">
				<wf:startProcessInfo buttonFunctionId="F_OP_002" title="" />
			</div>
			<div id="tab_box_content3" name="tab_box_content3"
				class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="attachement"
					id="attachement" frameborder="0" src="" marginheight="0"
					marginwidth="0"></iframe>
			</div>
			<div id="tab_box_content4" name="tab_box_content4"
				class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="remark" id="remark"
					frameborder="0" src="" marginheight="0" marginwidth="0"></iframe>
			</div>
			<div id="tab_box_content5" name="tab_box_content5"
				class="tab_box_content" style="display: none;">
				<iframe width="100%" height="100%" name="codeManager"
					id="codeManager" frameborder="0" src="" marginheight="0"
					marginwidth="0" scrolling="auto" style="overflow: scroll;"></iframe>
			</div>
		</div>
	</div>
	</form>
</body>
<script type="text/javascript">
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
	cruConfig.contextPath = "<%=contextPath%>";
	var projectType ="<%=projectType%>";
	var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				currentid = this.value;
			}
		});
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = 
					"SELECT ACC.DEV_NAME AS DEV_NAME,ACC.DEV_MODEL AS DEV_MODEL, ACC.DEV_TYPE AS DEV_TYPE,DECODE(SUB.ERROR_TYPE,'0','无故障','1','普通','2','特殊','') as ERROR_TYPE\n" +
					" ,DECODE(SUB.ERROR_DESC,'0','无故障','1','不通','2','数传','3','死站','4','年检不过','5','单边通','6','本道不通','7',"+
					"'共摸','8','本道','9','初始化不过','10','漏电','11','畸变不过','12','单边不通','13','短路','14','物理损坏','15','共模不过','') AS ERROR_DESC" +
					" ,ACC.DEV_SIGN AS DEV_SIGN,DECODE(SUB.DEV_STATUS,'0','待修','1','在修','2','待仪器检测','3','无法修复','4','完好','') AS DEV_STATUS,SUB.REMARK AS REMARK"+
					"  FROM GMS_DEVICE_COLL_SEND_SUB SUB, GMS_DEVICE_ACCOUNT_B ACC,GMS_DEVICE_COLL_REPAIR_SEND SEND\n" + 
					" WHERE SUB.BSFLAG = '0'\n" + 
					"   AND ACC.BSFLAG = '0'\n" + 
					"   AND SUB.DEV_ACC_ID = ACC.DEV_ACC_ID(+)\n" + 
					"   AND SUB.SEND_FORM_ID = SEND.ID(+)\n" + 
					"   AND SEND.ID = '"+currentid+"'";
				var queryRet = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}
		else if(index == 3){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 4){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 5){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td>";
			innerHTML += "<td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].dev_sign+"</td>";
			innerHTML += "<td>"+datas[i].error_type+"</td><td>"+datas[i].error_desc+"</td>";
			innerHTML += "<td>"+datas[i].remark+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	$(document).ready(lashen);
</script>

<script type="text/javascript">
	var projectInfoNos = '<%=projectInfoNo%>';
	var projectName = '<%=projectName%>';
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
	};
	function searchDevData(){
		var v_device_repair_app_no = document.getElementById("s_device_repair_app_no").value;
		var v_device_repair_app_name = document.getElementById("s_device_repair_app_name").value;
		refreshData(v_device_repair_app_no, v_device_repair_app_name);
	};
	function clearQueryText(){
		document.getElementById("s_device_repair_app_no").value = "";
		document.getElementById("s_device_repair_app_name").value = "";
	};
    function refreshData(v_device_repair_app_no, v_device_repair_app_name){
		var str = 
			"SELECT SEND.*,\n" +
			"       DECODE(SEND.CURRENCY, <%=DevUtil.getDecodeStr(DevConstants.DECODE_KEY_CURRENCY)%>) AS CURRENCY_NAME,\n" + 
			"       EMP.EMPLOYEE_NAME AS CREATOR_NAME,\n" + 
			"       PRO.PROJECT_NAME,\n" + 
			"       REQORG.ORG_ABBREVIATION AS REQ_COMP_NAME,\n" + 
			"  case wfmiddle.proc_status\n" +
			"         when '1' then\n" + 
			"          '待审批'\n" + 
			"         when '3' then\n" + 
			"          '审批通过'\n" + 
			"         when '4' then\n" + 
			"          '审批不通过'\n" + 
			"         else\n" + 
			"          '未提交'\n" + 
			"       end as pro_desc, " +
			"       DECODE(SEND.STATUS, 0, '编制', 1, '生效' ，2, '作废', '无效状态') AS STATUS_DESC\n" + 
			"  FROM GMS_DEVICE_COLL_REPAIR_SEND SEND,\n" + 
			"       GP_TASK_PROJECT             PRO,\n" + 
			"       COMM_ORG_INFORMATION        REQORG,\n" + 
			"       COMM_HUMAN_EMPLOYEE         EMP,\n" +
			"common_busi_wf_middle       wfmiddle" +
			" WHERE 1 = 1\n" + 
			"   AND SEND.BSFLAG = 0\n" + 
			"   AND SEND.OWN_PROJECT = PRO.PROJECT_INFO_NO(+)\n" + 
			"   AND SEND.APPLY_ORG = REQORG.ORG_ID(+)\n" + 
			"   AND SEND.CREATOR = EMP.EMPLOYEE_ID(+)\n" +
			" AND SEND.ID = wfmiddle.business_id(+)\n" +
			"   and (wfmiddle.bsflag = '0' or wfmiddle.bsflag is null)" +
			"   AND SEND.APPLY_ORG = '<%=orgId%>' \n" ; 
		if(v_device_repair_app_no!=undefined && v_device_repair_app_no!=''){//根据送修单号查询
			str += " AND SEND.REPAIR_FORM_NO like '%"+v_device_repair_app_no+"%' ";
		}
		if(v_device_repair_app_name!=undefined && v_device_repair_app_name!=''){//根据送修单名称查询
			str += " and SEND.REPAIR_FORM_NAME like '%"+v_device_repair_app_name+"%' ";
		}
			str += " ORDER BY SEND.CREATE_DATE DESC";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	};
    function loadDataDetail(id){
    	var retObj;
		if(id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevSendRepairBaseInfo", "repair_send_id="+id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevSendRepairBaseInfo", "repair_send_id="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceSendRepairMap.id).attr("checked","checked");
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceSendRepairMap.id+"']").removeAttr("checked");
		//给数据回填
		$("#repair_form_no","#projectMap").val(retObj.deviceSendRepairMap.repair_form_no);
		$("#repair_form_name","#projectMap").val(retObj.deviceSendRepairMap.repair_form_name);
		$("#project_name","#projectMap").val(retObj.deviceSendRepairMap.project_name);
		$("#req_comp_name","#projectMap").val(retObj.deviceSendRepairMap.req_comp_name);
		$("#service_company","#projectMap").val(retObj.deviceSendRepairMap.service_company);
		$("#apply_date","#projectMap").val(retObj.deviceSendRepairMap.apply_date);
		$("#buget_our","#projectMap").val(retObj.deviceSendRepairMap.buget_our);
		$("#buget_local","#projectMap").val(retObj.deviceSendRepairMap.buget_local);
		$("#rate","#projectMap").val(retObj.deviceSendRepairMap.rate);
		$("#currency_name","#projectMap").val(retObj.deviceSendRepairMap.currency_name);
		$("#creator_name","#projectMap").val(retObj.deviceSendRepairMap.creator_name);
		$("#create_date","#projectMap").val(retObj.deviceSendRepairMap.create_date);
		$("#pro_desc","#projectMap").val(retObj.deviceSendRepairMap.pro_desc);
		var device_repair_name = retObj.deviceSendRepairMap.repair_form_name;
		var device_repair_no = retObj.deviceSendRepairMap.toModifyDevRepairPage;
		var curbusinesstype = "";
		if(projectType == '5000100004000000008'){//井中
			curbusinesstype = "5110000004100001059";
		}else{
			curbusinesstype = "5110000004100001038";
		}
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
		//**************liug  加入审批流*****//
		processNecessaryInfo={         
            businessTableName:"gms_device_coll_repair_send",    //置入流程管控的业务表的主表表明
            businessType:curbusinesstype,        //业务类型 即为之前设置的业务大类
            businessId:id.split("-")[0],         //业务主表主键值
            businessInfo:"送外维修申请审批",        //用于待审批界面展示业务信息
            applicantDate:'<%=appDate%>'       //流程发起时间
          }; 
          processAppendInfo={ 
              projectInfoNo:'<%=projectInfoNo%>',
              id: id.split("-")[0],
              buttonView:"false",
  			  projectInfoType:'<%=projectType%>',
          	  projectName:'<%=user.getProjectName()%>' 
     
          }; 
          loadProcessHistoryInfo();
		//*******************//
    };
	function toAddDevSendRepairPage(){
		popWindow('<%=contextPath%>/rm/dm/devRepair/repairSendNewApply.jsp');
	};
	function toModifyDevRepairPage(){
		var length = 0;
		var selectedid = "";
		var pro_desc = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
					
				}
				pro_desc += this.pro_desc;
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录!");
			return;
		}else if(length != 1 ){
			alert("请选择一条记录!");
			return;
		}
		//判断状态
		var stateflag = false;
		var alertinfo ;
		if(pro_desc != '未提交'){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'"+pro_desc+"'的单据,不能修改!";
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		/*********
		//判断状态
		var querySql = 
			"SELECT T.STATUS FROM GMS_DEVICE_COLL_REPAIR_SEND T\n" +
			"WHERE T.ID IN ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].status == '1' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'生效'的单据,不能修改!";
				break;
			}else if(basedatas[index].status == '2' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'作废'的单据,不能修改!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		**********/
		var id ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				id = this.value;
			}
		});
		popWindow('<%=contextPath%>/rm/dm/devRepair/repairSendModify.jsp?id='+id);
	};
	function toDelDevRepairPage(){
		var length = 0;
		var selectedid = "";
		var pro_desc = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
					
				}
				pro_desc += this.pro_desc;
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录!");
			return;
		}else if(length != 1 ){
			alert("请选择一条记录!");
			return;
		}
		//判断状态
		var stateflag = false;
		var alertinfo ;
		if(pro_desc != '未提交'){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'"+pro_desc+"'的单据,不能删除!";
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		/*************
		//判断状态
		var querySql = 
			"SELECT T.STATUS FROM GMS_DEVICE_COLL_REPAIR_SEND T\n" +
			"WHERE T.ID IN ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].status == '1' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'生效'的单据,不能删除!";
				break;
			}else if(basedatas[index].status == '2' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'作废'的单据,不能删除!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		*************/
		//什么状态不能删除，和业务专家确定
		if(confirm("是否执行删除操作?")){
			var sql = "update GMS_DEVICE_COLL_REPAIR_SEND set bsflag='1' where id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	};
	function toSumbitRepairSend(){
		var length = 0;
		var selectedid = "";
		var pro_desc = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
					
				}
				pro_desc += this.pro_desc;
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		//判断状态
		var stateflag = false;
		var alertinfo ;
		if(pro_desc != '未提交'){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'"+pro_desc+"'的单据,不能提交!";
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		/**********
		var querySql = 
			"SELECT T.STATUS FROM GMS_DEVICE_COLL_REPAIR_SEND T\n" +
			"WHERE T.ID IN ("+selectedid+")";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		
		var stateflag = false;
		var alertinfo ;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].status == '1' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'生效'的单据,不能提交!";
				break;
			}else if(basedatas[index].status == '2' ){
				stateflag = true;
				alertinfo = "您选择的记录中存在状态为'作废'的单据,不能提交!";
				break;
			}
		}
		if(stateflag){
			alert(alertinfo);
			return;
		}
		*********/
		//查看是否添加了明细
		var querySql = "SELECT COUNT(1) as SUMNUM FROM GMS_DEVICE_COLL_SEND_SUB T\n" +
			"WHERE T.BSFLAG = 0 AND T.SEND_FORM_ID in("+selectedid+") ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var basedatas = queryRet.datas;
		var detflag = false;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].sumnum == 0 ){
				detflag = true;
				alertinfo = "您选择的记录中未添加明细,不能提交!";
			}
		}
		/*******************************验证送修单位 维修单位是否填写***/
		var orgSql = "SELECT T.* FROM GMS_DEVICE_COLL_REPAIR_SEND T WHERE t.ID in ("+selectedid+") ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+orgSql);
		var basedatas = queryRet.datas;
		for(var index = 0;index<basedatas.length;index++){
			if(basedatas[index].apply_org == ""){
				detflag = true;
				alertinfo = "您选择的记录中送修单位为空,不能提交!";
				break;
			}
			if(basedatas[index].service_company == ""){
				detflag = true;
				alertinfo = "您选择的记录中维修单位为空,不能提交!";
				break;
			}
		}
		/*******************************验证送修单位 维修单位是否填写***/
		if(detflag){
			alert(alertinfo);
			return;
		}
		if (window.confirm("确认要提交吗?")) {
			//将送修表的编制状态改为生成
			var sql = "update GMS_DEVICE_COLL_REPAIR_SEND set status='1' where ID in ("+selectedid+")";
			var accsql = 
				"UPDATE GMS_DEVICE_ACCOUNT_B ACC\n" +
				"   SET ACC.TECH_STAT = '0110000006000000007', ACC.USING_STAT = '0110000007000000006'\n" + 
				" WHERE EXISTS (SELECT 1\n" + 
				"          FROM GMS_DEVICE_COLL_SEND_SUB    SUB,\n" + 
				"               GMS_DEVICE_COLL_REPAIR_SEND SEND\n" + 
				"         WHERE ACC.DEV_ACC_ID = SUB.DEV_ACC_ID(+)\n" + 
				"           AND SUB.SEND_FORM_ID = SEND.ID(+)\n" + 
				"           AND SEND.ID IN ("+selectedid+")) ";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			var accparams = "deleteSql="+accsql;
			params += "&ids=";
			accparams += "&ids=";
			syncRequest('Post',path,params);
			syncRequest('Post',path,accparams);
			///将明细信息的设备状态 修改为  设备状态 一保存时为 待修
			var subsql = "update GMS_DEVICE_COLL_SEND_SUB set DEV_STATUS='<%=DevConstants.DEV_REPAIR_REPAIRSTATE0 %>' where SEND_FORM_ID in ("+selectedid+")";
			var subparams = "deleteSql="+subsql;
			subparams += "&ids=";
			syncRequest('Post',path,subparams);
			//向设备动态表添加数据
			//document.getElementById("form1").action = "<%=contextPath%>/rm/dm/devRepair/repairSendListSubmit.srq?formid="+selectedid;
			//document.getElementById("form1").submit();
			retObj = jcdpCallService("DevCommInfoSrv", "repairSendListSubmit", "formid="+selectedid);
			submitProcessInfo();
			alert('提交成功!');
			refreshData();
		}
	};
	
	function toModifyDetail(obj){
		alert("88");
		var idinfo = null;
		if(obj!=undefined){
			idinfo = obj.idinfo;
		}else{
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					idinfo = this.value;
				}
			});
		}
		window.location.href='<%=contextPath%>/rm/dm/hireplan/hirePlanDetailList.jsp?projectInfoNo=<%=projectInfoNo%>&devicehireappid='+idinfo;
	}; 
	function chooseOne(cb) {
		var obj = document.getElementsByName("rdo_entity_id");
		for (i = 0; i < obj.length; i++) {
			if (obj[i] != cb)
				obj[i].checked = false;
			else
				obj[i].checked = true;
		}
	}
</script>
</html>