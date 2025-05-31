<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String devappid = request.getParameter("devappid");
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>多项目-计划审批-自有设备申请-分配出库-大港自有地震仪器明细出库查看页面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend >基本信息</legend>
      	<table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" />
          	<input name="deviceappid" id="deviceappid" type="hidden" value="<%=devappid%>" />
          </td>
          <td class="inquire_item4" >&nbsp;转出单位:</td>
          <td class="inquire_form4" >
          	<input name="out_org_name" id="out_org_name" class="input_width" type="text"  value="" readonly/>
          </td>
      	</table>
      </fieldSet>
	  <fieldSet style="margin-left:2px"><legend>调配明细</legend>
		  <div style="overflow:auto">
			  <table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_even">班组</td>
					<td class="bt_info_odd">设备名称</td>
					<td class="bt_info_even">规格型号</td>
					<td class="bt_info_odd">计量单位</td>
					<td class="bt_info_even">调配数量</td>
					<!-- <td class="bt_info_odd">备注</td> -->
				</tr>
			   <tbody id="processtable" name="processtable" >
			   </tbody>
		      </table>		     
	       </div>
      </fieldSet>
      <fieldSet style="margin-left:2px"><legend>附属设备</legend>
		  <div style="overflow:auto;">
				<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			       <tr>
						<td class="bt_info_even">班组</td>
						<td class="bt_info_odd">设备名称</td>
						<td class="bt_info_even">规格型号</td>
						<td class="bt_info_odd">计量单位</td>
						<td class="bt_info_even">调配数量</td>
						<!-- <td class="bt_info_odd">备注</td> -->
				   </tr>
				   <tbody id="addeddetailtable" name="addeddetailtable" >
			   	   </tbody>
				</table>
				
			</div>
       </fieldSet>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function refreshData(){
		var retObj;
		var devObj;
		if('<%=devappid%>'!=null){
			//回填信息
			var prosql = "select pro.project_name,info.org_abbreviation as out_org_name,cms.device_app_detid,cms.device_detsubid,cms.device_id,cms.device_name,cms.device_model,cms.device_num as applynum,";
				prosql += "nvl(temp.mixednum,0) mixednum,cms.unit_id,unitsd.coding_name as unit_name,";
				prosql += "cd.team,teamsd.coding_name as team_name ";
				prosql += "from gms_device_app_colldetsub cms ";
				prosql += "left join (select device_detsubid,out_org_id,sum(mix_num) as mixednum from gms_device_coll_mixsub mixsub,gms_device_collmix_form collform ";
				prosql += "where collform.device_mixinfo_id=mixsub.device_mixinfo_id and collform.bsflag='0' ";
				prosql += "group by device_detsubid,out_org_id) temp on temp.device_detsubid=cms.device_detsubid ";
				prosql += "left join gms_device_app_colldetail cd on cms.device_app_detid = cd.device_app_detid ";
				prosql += "left join comm_coding_sort_detail unitsd on unitsd.coding_code_id=cms.unit_id ";
				prosql += "left join comm_coding_sort_detail teamsd on teamsd.coding_code_id=cd.team ";
				prosql += "left join comm_org_information info on info.org_id = temp.out_org_id ";
				prosql += "left join gp_task_project pro on cd.project_info_no = pro.project_info_no ";
				prosql += "where cd.device_app_id='<%=devappid%>' and cd.bsflag='0'";
				prosql += "order by cms.device_id ";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+prosql);
			retObj = proqueryRet.datas;
			if(retObj!=undefined && retObj.length>0){
				$("#project_name").val(retObj[0].project_name);
				$("#out_org_name").val(retObj[0].out_org_name);
			}
			//回填附属设备信息
			var devsql = "select * from gms_device_coll_mixsubadd mix left join comm_coding_sort_detail d on mix.team=d.coding_code_id where mix.device_mixinfo_id='"+retObj[0].device_app_detid+"'";
			var devqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+devsql);
			devObj = devqueryRet.datas;
		}
		if(retObj!=undefined){
			for(var index=0;index<retObj.length;index++){
				//动态新增表格
				var innerhtml = "<tr id='tr"+index+"' name='tr"+index+"' seq='"+index+"'>";
				innerhtml += "<td>"+retObj[index].team_name+"</td>";
				innerhtml += "<td>"+retObj[index].device_name+"</td>";
				innerhtml += "<td>"+retObj[index].device_model+"</td>";
				innerhtml += "<td>"+retObj[index].unit_name+"</td>";				
				innerhtml += "<td>"+retObj[index].applynum+"</td>";
				innerhtml += "</tr>";
				$("#processtable").append(innerhtml);
			}
			$("#processtable>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable>tr:odd>td:even").addClass("odd_even");
			$("#processtable>tr:even>td:odd").addClass("even_odd");
			$("#processtable>tr:even>td:even").addClass("even_even");
		}
		if(devObj!=undefined){
			for(var index=0;index<devObj.length;index++){
				var innerhtml = "<tr id='traddedseq"+index+"' name='traddedseq"+index+"' seq='"+index+"' is_added='false'>";
				innerhtml += "<td>"+devObj[index].coding_name+"</td>";
				innerhtml += "<td>"+devObj[index].device_name+"</td>";
				innerhtml += "<td>"+devObj[index].device_model+"</td>";
				innerhtml += "<td>"+devObj[index].unit_name+"</td>";
				innerhtml += "<td>"+devObj[index].device_num+"</td>";
				//innerhtml += "<td>"+devObj[index].devremark+"</td>";
				innerhtml += "</tr>";
				$("#addeddetailtable").append(innerhtml);
			}
			$("#addeddetailtable>tr:odd>td:odd").addClass("odd_odd");
			$("#addeddetailtable>tr:odd>td:even").addClass("odd_even");
			$("#addeddetailtable>tr:even>td:odd").addClass("even_odd");
			$("#addeddetailtable>tr:even>td:even").addClass("even_even");
		}
	}
</script>
</html>

