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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

  <title>单项目-设备接收-设备接收(采集站)</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input"><input id="s_device_app_name" name="s_device_app_name" type="text" /></td>
			    <td class="ali_cdn_name">出库单号</td>
			    <td class="ali_cdn_input"><input id="s_outinfo_no" name="s_outinfo_no" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="jh" event="onclick='toDetailPage()'" title="JCDP_btn_submit"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_outinfo_id_{device_outinfo_id}' name='device_outinfo_id'>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{device_outinfo_id}_{device_app_id}' id='selectedbox_{device_outinfo_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{device_app_name}">申请单名称</td>
					<td class="bt_info_even" exp="{outinfo_no}">出库单号</td>
					<td class="bt_info_odd" exp="{outinfodesc}">出库单类别</td>
					<td class="bt_info_even" exp="{in_org_name}">接收单位</td>
					<td class="bt_info_even" exp="{out_org_name}">出库单位</td>
					<td class="bt_info_odd" exp="{employee_name}">开据人</td>
					<td class="bt_info_even" exp="{print_date}">申请时间</td>
					<td class="bt_info_odd" exp="{oprstate_desc}">处理状态</td>
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
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_5"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			  <tr>
				<td class="inquire_item6">项目名称</td>
				<td class="inquire_form6"><input id="dev_project_name" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">出库单号</td>
				<td class="inquire_form6"><input id="dev_outinfo_no" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">转入单位</td>
				<td class="inquire_form6"><input id="dev_in_org" name="" class="input_width" type="text" /></td>
			  </tr>
				<tr>
				<td class="inquire_item6">转出单位</td>
				<td class="inquire_form6"><input id="dev_out_org" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">开据人</td>
				<td class="inquire_form6"><input id="dev_print_emp" name="" class="input_width" type="text" /></td>
				<td class="inquire_item6">接收状态</td>
				<td class="inquire_form6"><input id="dev_state" name="" class="input_width" type="text" /></td>
			  </tr>
			</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">出库数量</td>
							<td class="bt_info_odd" width="13%">接收状态</td>
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
					</table>
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
	
	
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})

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
		//动态查询明细
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				currentid = this.value;
				currentid = currentid.split("_")[0];
			}
		});
		if(index == 1){
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
// 				var prosql = "select cos.device_name,cos.device_model,cos.out_num,cos.receive_state,";
// 				prosql += "case cos.receive_state when '0' then '未接受' when '1' then '接收中' when '9' then '接收完毕' else '异常状态' end as recstate_desc ";
// 				prosql += "from gms_device_coll_outsub cos ";
// 				prosql += "left join gms_device_coll_outform cof on cos.device_outinfo_id=cof.device_outinfo_id ";
// 				prosql += "where cof.device_outinfo_id='"+currentid+"'";

var str = "select device_oif_subid,device_name,device_model,out_num,detail.coding_name as unit_name,"+
			"case sub.receive_state when '0' then '未接收' when '1' then '已接收' end as recstate_desc "+
			"from gms_device_coll_outsub sub "+
			"left join comm_coding_sort_detail detail on sub.unit_id = detail.coding_code_id "+
			"where sub.device_outinfo_id='"+currentid+"'";
				var queryRet = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				basedatas = queryRet.datas;
				
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailList";
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
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].device_name+"</td><td>"+datas[i].device_model+"</td>";
			innerHTML += "<td>"+datas[i].out_num+"</td><td>"+datas[i].recstate_desc+"</td>";
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
	    }else{
	    	sonFlag = 'N';
	    }
	});

	function searchDevData(){
		var v_device_app_name = document.getElementById("s_device_app_name").value;
		var v_outinfo_no = document.getElementById("s_outinfo_no").value;
		refreshData(v_device_app_name, v_outinfo_no);
	}
	
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_device_app_name").value="";
		document.getElementById("s_outinfo_no").value="";
    }
	
	function refreshData(v_device_app_name,v_outinfo_no){
// 		var str = "select devapp.device_app_id,devapp.device_app_name,he.employee_name,tp.project_name,inorg.org_abbreviation as in_org_name,"
// 		+"outorg.org_abbreviation as out_org_name,cof.devouttype,"
// 		+"cof.outinfo_no,to_char(cof.modifi_date,'yyyy-mm-dd') as print_date,cof.device_outinfo_id, "
// 		+"case cof.devouttype when '1' then '调配出库单' when '2' then '抵修出库单' else '其他出库单' end as outinfodesc," 
// 		+"case cof.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc "
// 		+"from gms_device_coll_outform cof " 
// 		+"left join gms_device_collmix_form mif on cof.device_mixinfo_id=mif.device_mixinfo_id "
// 		+"left join gms_device_collapp devapp on devapp.device_app_id=mif.device_app_id "
// 		+"left join gp_task_project tp on cof.project_info_no=tp.project_info_no " 
// 		+"left join comm_human_employee he on cof.print_emp_id=he.employee_id "
// 		+"left join comm_org_information inorg on cof.in_org_id=inorg.org_id "
// 		+"left join comm_org_information outorg on cof.org_id=outorg.org_id "
// 		+"where cof.project_info_no='"+projectInfoNos+"' and cof.state='9' and cof.bsflag='0' ";
		var str = "select * from(select * from(select devapp.device_app_id,devapp.device_app_name,he.employee_name,pro.project_name,";
			str += "inorg.org_abbreviation as in_org_name,outorg.org_abbreviation ";
			str +="as out_org_name,cof.devouttype,cof.outinfo_no,to_char(cof.modifi_date,'yyyy-mm-dd') ";
			str +="as print_date,cof.device_outinfo_id, ";
			str +="case cof.devouttype when '1' then '调配出库单' when '2' then '抵修出库单' else '其他出库单' end ";
			str +="as outinfodesc,case cof.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end ";
			str +="as oprstate_desc ";
			str +="from gms_device_coll_outform cof ";
			str +="left join gms_device_collmix_form mif on cof.device_mixinfo_id=mif.device_mixinfo_id ";
			str +="left join gms_device_collapp devapp on devapp.device_app_id=mif.device_app_id ";
			str +="left join gms_device_allapp allapp on devapp.device_allapp_id = allapp.device_allapp_id ";
			//str +="left join gp_task_project tp on cof.project_info_no=tp.project_info_no ";
			str +="left join comm_human_employee he on cof.print_emp_id=he.employee_id ";
			str +="left join comm_org_information inorg on cof.in_org_id=inorg.org_id ";
			str +="left join comm_org_information outorg on cof.out_org_id=outorg.org_id ";

			//井中地震 
			if(projectType == "5000100004000000008" && retFatherNo.length >= 1){//子项目
				str += "left join gp_task_project pro on cof.project_info_no = pro.project_info_no and pro.bsflag = '0' and pro.project_type = '5000100004000000008' ";
				str += "where cof.state='9' and (allapp.allapp_type = 'S1405' or allapp.allapp_type is null) and cof.bsflag='0' and cof.devouttype!='2' and cof.project_info_no = '" +retFatherNo+"' )";
			}else if(projectType == "5000100004000000008" && retFatherNo.length <= 0){
	        	str += "left join gp_task_project pro on cof.project_info_no = pro.project_info_no and pro.bsflag = '0' and pro.project_father_no is null and pro.project_type = '5000100004000000008' ";
	        	str += "where cof.state='9' and (allapp.allapp_type = 'S1405' or allapp.allapp_type is null) and cof.bsflag='0' and cof.devouttype!='2' and cof.project_info_no='"+projectInfoNos+"' )";
	         }else{
	        	str += "left join gp_task_project pro on cof.project_info_no = pro.project_info_no and pro.bsflag = '0' ";
	        	str += "where cof.state='9' and (allapp.allapp_type = 'S1405' or allapp.allapp_type is null) and cof.bsflag='0' and cof.devouttype!='2' and cof.project_info_no='"+projectInfoNos+"' )";
		     }
			
			//str +="where cof.project_info_no='"+projectInfoNos+"' and cof.state='9' and cof.devouttype!='2' ";
			//str +="and cof.bsflag='0'  ) ";
			str +="union all select * from(";
			str +="select devapp.device_app_id,cmf.backapp_name as device_app_name,he.employee_name,pro.project_name,";
			str +="inorg.org_abbreviation as in_org_name,outorg.org_abbreviation ";
			str +="as out_org_name,cof.devouttype,cof.outinfo_no,to_char(cof.modifi_date,'yyyy-mm-dd') ";
			str +="as print_date,cof.device_outinfo_id, ";
			str +="case cof.devouttype when '1' then '调配出库单' when '2' then '抵修出库单' else '其他出库单' end ";
			str +="as outinfodesc,case cof.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end ";
			str +="as oprstate_desc ";
			str +="from  gms_device_coll_outform cof ";
			str +="left join gms_device_collbackapp cmf on cof.device_mixinfo_id=cmf.device_backapp_id ";
			//str +="left join gp_task_project tp on cof.project_info_no=tp.project_info_no ";
			str +="left join comm_human_employee he on cof.print_emp_id=he.employee_id ";
			str +="left join comm_org_information inorg on cof.in_org_id=inorg.org_id ";
			str +="left join comm_org_information outorg on cof.out_org_id=outorg.org_id ";
			str +="left join gms_device_collmix_form mif on cof.device_mixinfo_id=mif.device_mixinfo_id ";
			str +="left join gms_device_collapp devapp on devapp.device_app_id=mif.device_app_id ";

			//井中地震 
			if(projectType == "5000100004000000008" && retFatherNo.length >= 1)//子项目
			{
				str += "left join gp_task_project pro on cof.project_info_no = pro.project_info_no and pro.bsflag = '0' and pro.project_type = '5000100004000000008' ";
				str += "where cof.state='9' and cof.bsflag='0' and cof.devouttype='2' and cof.project_info_no = '" +retFatherNo+"' ";
			}else if(projectType == "5000100004000000008" && retFatherNo.length <= 0){
	        	str += "left join gp_task_project pro on cof.project_info_no = pro.project_info_no and pro.bsflag = '0' and pro.project_father_no is null and pro.project_type = '5000100004000000008' ";
	        	str += "where cof.state='9' and cof.bsflag='0' and cof.devouttype='2' and cof.project_info_no='"+projectInfoNos+"' ";
	         }else{
	        	str += "left join gp_task_project pro on cof.project_info_no = pro.project_info_no and pro.bsflag = '0' ";
	        	str += "where cof.state='9' and cof.bsflag='0' and cof.devouttype='2' and cof.project_info_no='"+projectInfoNos+"' ";
		     }
			
			//str +="where cof.project_info_no='"+projectInfoNos+"' and cof.state='9' and cof.devouttype='2' ";
			str +=")) where 1=1 ";
		if(v_device_app_name!=undefined && v_device_app_name!=''){
			str += "and device_app_name like '%"+v_device_app_name+"%' ";
		}
		if(v_outinfo_no!=undefined && v_outinfo_no!=''){
			str += "and outinfo_no like '%"+v_outinfo_no+"%' ";
		}
			str += "order by oprstate_desc,print_date desc ";
		cruConfig.queryStr = str;
		debugger;
		queryData(cruConfig.currentPage);
	}
	
	function toDetailPage(){
    	var shuaId ;
    	$("input[type='checkbox'][name='selectedbox']").each(function(){
    		if(this.checked == true){
    			shuaId = this.value;
    		}
    	});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		window.location.href='<%=contextPath%>/rm/dm/rfid/devrecieve/rfidCollSubDevReceiveList.jsp?outInfoId='+shuaId+'&sonFlag='+sonFlag;
    }
	
	function dbclickRow(shuaId){
		window.location.href='<%=contextPath%>/rm/dm/rfid/devrecieve/rfidCollSubDevReceiveList.jsp?outInfoId='+shuaId+'&sonFlag='+sonFlag;
	}
	
    function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }   

    function loadDataDetail(shuaId){
    	var retObj;
    	var ids;
		if(shuaId!=null){
			ids = shuaId.split("_")[0];
		}else{
			ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		}
		//根据ids去查找
		var str = "select he.employee_name,tp.project_name,inorg.org_abbreviation as in_org_name,outorg.org_abbreviation as out_org_name,";
			str += "cof.outinfo_no,cof.modifi_date as print_date,cof.device_outinfo_id, ";
			str += "case cof.receive_state when '0' then '未接受' when '1' then '接收中' when '9' then '接收完毕' else '异常状态' end as recstate_desc ";
			str += "from gms_device_coll_outform cof  "
			+"left join gp_task_project tp on cof.project_info_no=tp.project_info_no " 
			+"left join comm_human_employee he on cof.print_emp_id=he.employee_id "
			+"left join comm_org_information inorg on cof.in_org_id=inorg.org_id "
			+"left join comm_org_information outorg on cof.out_org_id=outorg.org_id "
			+"where cof.bsflag='0' and cof.device_outinfo_id='"+ids+"'";
		var unitRet = encodeAndsyncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		retObj = unitRet.datas;
		//取消选中框--------------------------------------------------------------------------
		//选中这一条checkbox
		$("#selectedbox_"+retObj[0].device_outinfo_id).attr("checked",'true');
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_outinfo_id+"']").removeAttr("checked");
		//------------------------------------------------------------------------------------
		$("#dev_project_name").val(retObj[0].project_name);
		$("#dev_outinfo_no").val(retObj[0].outinfo_no);
		$("#dev_in_org").val(retObj[0].in_org_name);
		$("#dev_out_org").val(retObj[0].out_org_name);
		$("#dev_print_emp").val(retObj[0].employee_name);
		$("#dev_create_date").val(retObj[0].create_date);
		$("#dev_state").val(retObj[0].recstate_desc);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
</script>
</html