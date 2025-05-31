<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String code = request.getParameter("code");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<title>项目列表</title>
<script language="javaScript">

function frameSize(){
	$("#table_box").css("height",$(window).height()*0.85);
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})
var projectInfoNo = "<%=projectInfoNo%>";
var code = "<%=code%>";
cruConfig.contextPath =  "<%=contextPath%>";
function refreshData(){
	debugger;
	var sql = "select dev_name,dev_model,license_num,self_num,dev_sign,sum(oil_total) as total_charge,sum(oil_quantity) as quantiy_charge from ("+
					"select tmp1.*,sum(oil_quantity) over(order by fill_date) as oil_sum_quantity, "+
					"sum(oil_total) over(order by fill_date) as oil_sum_total "+
					"from "+
					"  (select b.dev_name,b.dev_model,b.license_num,b.self_num,b.dev_sign, "+
					"	(select coding_name from comm_coding_sort_detail where coding_code_id=a.OIL_NAME)as OIL_NAME1,"+
					"   (select coding_name from comm_coding_sort_detail where coding_code_id=a.OIL_MODEL)as OIL_MODEL1,"+
					"   b.owning_org_name,c.project_name,a.oil_info_id,a.device_account_id,a.fill_date,"+
					"   a.oil_unit,a.oil_quantity,a.oil_unit_price,a.oil_total,'false' as checktype "+
					"   from bgp_comm_device_oil_info a "+
					"   left join gms_device_account_dui b on a.device_account_id=b.dev_acc_id "+
					"   left join gp_task_project c on b.project_info_id=c.project_info_no "+
					"   where a.bsflag='0' and b.project_info_id='"+projectInfoNo+"' "+
					"    and b.dev_type like 'S"+code+"%' and a.oil_name in ('0110000043000000001','0110000043000000002') "+
					"    union "+
					"   select dui.dev_name,dui.dev_model,dui.license_num,dui.self_num,dui.dev_sign ,"+
					"    i.wz_name as oil_name1,'' as oil_model1,t.org_id as owning_org_name,"+
					"    pro.project_name,t.teammat_out_id as oil_info_id,t.dev_acc_id as device_account_id,t.outmat_date as fill_date,"+
					"    i.wz_prickie,d.oil_num, d.actual_price,d.total_money,'true' as checktype "+
					"    from gms_mat_teammat_out t "+
					"    inner join GMS_MAT_TEAMMAT_OUT_DETAIL d "+
					"    inner join gms_mat_infomation i on d.wz_id=i.wz_id on t.teammat_out_id = d.teammat_out_id "+
					"    left join gp_task_project pro on t.project_info_no=pro.project_info_no "+
					"     left join gms_device_account_dui dui on d.dev_acc_id=dui.dev_acc_id "+
					"    where t.out_type='3' and t.project_info_no='"+projectInfoNo+"' "+
					"   and dui.dev_type like 'S"+code+"%') "+
					"   tmp1 "+
					") group by dev_name,dev_model,license_num,self_num,dev_sign ";
	
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = sql;
	cruConfig.currentPageUrl = "/mat/panel/wtcwycz.jsp";
	queryData(1);
}

function exportDataDoc(exportFlag){
	//调用导出方法
	var path = cruConfig.contextPath+"/rm/dm/common/DmZhfxToExcel.srq";
	var submitStr = "projectInfoNo=<%=projectInfoNo%>&code=<%=code%>&exportFlag="+exportFlag;
	var retObj = syncRequest("post", path, submitStr);
	var filename=retObj.excelName;
	filename = encodeURI(filename);
	filename = encodeURI(filename);
	var showname=retObj.showName;
	showname = encodeURI(showname);
	showname = encodeURI(showname);
	window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
}
</script>
</head>
<body onload="refreshData()" style="background:#cdddef">
		<div id="list_table">
			<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<input type="hidden" id="hse_danger_id" name="hse_danger_id"></input>
					<tr>
						<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
						<td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						
						<td>&nbsp;</td>
						<td class='ali_btn'><span class='dc'><a href='#' onclick='exportDataDoc("sbdjryxhmx")'  title='导出excel'></a></span></td>
						</tr>
						</table>
						</td>
						<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
					 </tr>
				</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{dev_name}">设备名称</td>
			      <td class="bt_info_odd" exp="{dev_model}" >规格型号</td>
			      <td class="bt_info_even" exp="{self_num}" >自编号</td>
			      <td class="bt_info_odd" exp="{dev_sign}" >实物标识号</td>
			      <td class="bt_info_even" exp="{license_num}" >牌照号</td>
			      <td class="bt_info_odd" exp="{total_charge}" >燃油消耗金额</td>
			      <td class="bt_info_even" exp="{quantiy_charge}" >油料消耗量</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			<div id="tab_box" class="tab_box"></div>
</div>
</body>
</html>