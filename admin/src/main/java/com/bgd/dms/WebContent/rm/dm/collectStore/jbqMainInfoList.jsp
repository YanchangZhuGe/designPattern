<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
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
  <title>多项目-收工验收-收工验收(检波器)</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">项目名称</td>
			    <td class="ali_cdn_input"><input id="s_project_name" name="s_project_name" type="text"/></td>
			    <td>返还申请单名称</td>
			    <td class="ali_cdn_input"><input id="s_backmixinfo_name" name="s_backmixinfo_name" type="text"/></td>
			    <td class="ali_cdn_name">返还申请单号</td>
			    <td class="ali_cdn_input"><input id="s_backmixinfo_no" name="s_backmixinfo_no" type="text"/></td>
			    <td class="ali_cdn_name">返还单位名称</td>
			    <td class="ali_cdn_input"><input id="s_usage_org_name" name="s_usage_org_name" type="text"/></td>
			     <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
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
			     <tr>
			     	<td class="bt_info_odd" exp="<input type='checkbox' id='selectedbox_{device_coll_mixinfo_id}' name='selectedbox' value='{device_coll_mixinfo_id}' stateinfo='{state}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{project_name}">项目名称</td>
					<td class="bt_info_even"  exp="{device_backapp_no}">返还申请单号</td>
					<td class="bt_info_odd" exp="{backapp_name}">返还申请单名称</td>
					<td class="bt_info_even" exp="{back_org_name}">返还单位名称</td>
					<td class="bt_info_odd" exp="{receive_org_name}">接收单位名称</td>
					<td class="bt_info_even" exp="{employee_name}">申请人</td>
					<td class="bt_info_odd" exp="{backdate}">离场时间</td>
					<td class="bt_info_even" exp="{oprstate_desc}">处理状态</td>
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
			    <li id="tag3_2"><a href="#" onclick="getContentTab(this,2)">附件</a></li>
			    <li id="tag3_3"><a href="#" onclick="getContentTab(this,3)">备注</a></li>
			    <li id="tag3_4"><a href="#" onclick="getContentTab(this,4)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td   class="inquire_item6">项目名称：</td>
				      <td   class="inquire_form6" ><input id="project_name" class="input_width" type="text"  value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">返还申请单号：</td>
				      <td  class="inquire_form6" ><input id="device_backapp_no" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">返还申请单名称</td>
				      <td  class="inquire_form6"><input id="backapp_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>  
				     </tr>
				    <tr>
				      
				     <td  class="inquire_item6">返还单位：</td>
				     <td  class="inquire_form6"><input id="back_org_name" class="input_width" type="text"  value="" disabled/>&nbsp;</td>
				     <td  class="inquire_item6">接收单位：</td>
				     <td  class="inquire_form6"><input id="receive_org_name" class="input_width" type="text"  value="" disabled/>&nbsp;</td>
				     <td  class="inquire_item6">申请人：</td>
				     <td  class="inquire_form6"><input id="back_employee_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				    </tr>
				    <tr>
				      
				     <td  class="inquire_item6">离场时间：</td>
				     <td  class="inquire_form6"><input id="backdate" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				      
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				    		<td class="bt_info_odd" width="5%">序号</td>
							<td class="bt_info_even" width="11%">设备名称</td>
							<td class="bt_info_odd" width="11%">规格型号</td>
							<td class="bt_info_even" width="10%">单位</td>
							<td class="bt_info_odd" width="9%">返还数量</td>
							<td class="bt_info_even" width="11%">总数量</td>
							<td class="bt_info_odd" width="13%">在队数量</td>
							<td class="bt_info_even" width="13%">离队数量</td>
							<td class="bt_info_odd" width="13%">实际进场时间</td>
							<td class="bt_info_even" width="13%">计划离场时间</td>
				        </tr>
				        <tbody id="detailMap" name="detailMap" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
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
    function toStockDetailPage(obj){
    	window.location.href = "subStockin.jsp?id="+obj;
    }

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
		if(index == 1){
			//动态查询明细
			var currentid;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					currentid = this.value;
				}
			});
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = "select t.back_num as mix_num,backdet.*, account.dev_unit,account.total_num,account.unuse_num,account.use_num,account.actual_in_time,sd.coding_name as unit_name from gms_device_coll_back_detail t left join gms_device_collbackapp_detail backdet on t.device_backdet_id = backdet.device_backdet_id left join gms_device_coll_account_dui account on backdet.dev_acc_id = account.dev_acc_id left join comm_coding_sort_detail sd on account.dev_unit = sd.coding_code_id where t.device_coll_mixinfo_id='"+currentid+"'";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
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
		else if(index == 2){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 3){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 4){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td><td>"+datas[i].unit_name+"</td>";
			innerHTML += "<td>"+datas[i].mix_num+"</td><td>"+datas[i].total_num+"</td><td>"+datas[i].unuse_num+"</td>";
			innerHTML += "<td>"+datas[i].use_num+"</td>";
			innerHTML += "<td>"+datas[i].actual_in_time+"</td><td>"+datas[i].planning_out_time+"</td>";
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
    
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else 
	             {obj[i].checked = true;  
	              checkvalue = obj[i].value;
	             } 
	        }      
    }
    function loadDataDetail(devicebackappid){
    	var retObj;
    	var querySql = "select t.device_coll_mixinfo_id,gp.project_name,t.device_mixapp_no,";
    	querySql += "collback.device_backapp_no,collback.backapp_name,i.org_abbreviation as back_org_name,";
    	querySql += "org.org_abbreviation as receive_org_name,mixorg.org_abbreviation as mix_org_name,emp.employee_name,";
    	querySql += "collback.backdate,case t.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc ";
    	querySql += "from gms_device_coll_backinfo_form t left join gp_task_project gp on t.project_info_id=gp.project_info_no and gp.bsflag='0' ";
    	querySql += "left join (gms_device_collbackapp collback left join comm_org_information i on collback.back_org_id = i.org_id and i.bsflag='0' ";
    	querySql += "left join comm_human_employee emp on collback.back_employee_id = emp.employee_id) on t.device_backapp_id = collback.device_backapp_id ";
    	querySql += "and collback.bsflag='0' left join comm_org_information org on t.receive_org_id= org.org_id ";
    	querySql += "and org.bsflag='0' left join comm_org_information mixorg on t.backmix_org_id =mixorg.org_id and mixorg.bsflag='0' ";
		if(devicebackappid!=null){
			querySql += " where t.device_coll_mixinfo_id='"+devicebackappid+"' and t.state='9'and t.bsflag='0'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    querySql += "where t.device_coll_mixinfo_id='"+ids+"' and t.state='9'and t.bsflag='0'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			
		}
		retObj = queryRet.datas;
		//取消其他选中的 
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj[0].device_coll_mixinfo_id+"']").removeAttr("checked");
		//选中这一条checkbox
		$("input[type='checkbox'][name='selectedbox'][id='selectedbox_"+retObj[0].device_coll_mixinfo_id+"']").attr("checked",'checked');
		//给数据回填
		$("#project_name","#projectMap").val(retObj[0].project_name);
		$("#device_backapp_no","#projectMap").val(retObj[0].device_backapp_no);
		$("#backapp_name","#projectMap").val(retObj[0].backapp_name);
		$("#back_org_name","#projectMap").val(retObj[0].back_org_name);
		$("#receive_org_name","#projectMap").val(retObj[0].receive_org_name);
		$("#back_employee_name","#projectMap").val(retObj[0].employee_name);
		
		$("#backdate","#projectMap").val(retObj[0].backdate);
		$("#state","#projectMap").val(retObj[0].state_desc);
		
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }

	function searchDevData(){
		var v_project_name = document.getElementById("s_project_name").value;
		var v_backmixinfo_no = document.getElementById("s_backmixinfo_no").value;
		var v_usage_org_name = document.getElementById("s_usage_org_name").value;
		var v_backmixinfo_name = document.getElementById("s_backmixinfo_name").value;
		refreshData(v_project_name,v_backmixinfo_no, v_usage_org_name,v_backmixinfo_name);
	}
	//清空查询条件
	  function clearQueryText(){
	    	document.getElementById("s_project_name").value="";
	    	document.getElementById("s_backmixinfo_no").value="";
			document.getElementById("s_usage_org_name").value="";
			document.getElementById("s_backmixinfo_name").value="";
	  }
	function refreshData(v_project_name,v_backmixinfo_no,v_usage_org_name,v_backmixinfo_name){
		var str = "select t.device_coll_mixinfo_id,gp.project_name,t.device_mixapp_no,";
			str += "collback.device_backapp_no,collback.backapp_name,i.org_abbreviation as back_org_name,";
			str += "org.org_abbreviation as receive_org_name,mixorg.org_abbreviation as mix_org_name,emp.employee_name,";
			str += "collback.backdate,case t.opr_state when '1' then '处理中' when '9' then '已处理' else '未处理' end as oprstate_desc ";
			str += "from gms_device_coll_backinfo_form t left join gp_task_project gp on t.project_info_id=gp.project_info_no and gp.bsflag='0' ";
			str += "left join (gms_device_collbackapp collback left join comm_org_information i on collback.back_org_id = i.org_id and i.bsflag='0' ";
			str += "left join comm_human_employee emp on collback.back_employee_id = emp.employee_id) on t.device_backapp_id = collback.device_backapp_id ";
			str += "and collback.bsflag='0' left join comm_org_information org on t.receive_org_id= org.org_id ";
			str += "and org.bsflag='0' left join comm_org_information mixorg on t.backmix_org_id =mixorg.org_id and mixorg.bsflag='0' ";
			str += "where t.state='9'and t.bsflag='0' and t.back_dev_type='S14050208' and t.org_subjection_id like '<%=orgsubid%>%' ";
			
		//加机构权限
		//补充查询条件
		if(v_backmixinfo_no!=undefined && v_backmixinfo_no!=''){
			str += "and collback.device_backapp_no like '%"+v_backmixinfo_no+"%' ";
		}
		if(v_usage_org_name!=undefined && v_usage_org_name!=''){
			str += "and i.org_abbreviation like '%"+v_usage_org_name+"%' ";
		}
		if(v_backmixinfo_name!=undefined && v_backmixinfo_name!=''){
			str += "and collback.backapp_name like '%"+v_backmixinfo_name+"%' ";
		}
		if(v_project_name!=undefined && v_project_name!=''){
			str += "and gp.project_name like '%"+v_project_name+"%' ";
		}
		str += "order by t.opr_state desc,collback.backdate desc ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	function toDetailPage(){
    	var shuaId ;
    	$("input[type='checkbox'][name='selectedbox']").each(function(){
    		if(this.checked){
    			shuaId = this.value;
    		}
    	});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		window.location.href='<%=contextPath%>/rm/dm/collectStore/subJbqStockin.jsp?id='+shuaId;
    }
	function dbclickRow(shuaId){
		window.location.href='<%=contextPath%>/rm/dm/collectStore/subJbqStockin.jsp?id='+shuaId;
	}
	
</script>
</html>