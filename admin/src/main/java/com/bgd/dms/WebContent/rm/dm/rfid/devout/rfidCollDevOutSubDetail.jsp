<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	String mixInfoId = request.getParameter("mixInfoId");
	String outInfoId = request.getParameter("outInfoId");
	String outid1 = request.getParameter("outid1");
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>出库设备明细</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend >基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >出库单号:</td>
          <td class="inquire_form4" >
          	<input name="outinfo_no" id="outinfo_no" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >项目名称:</td>
          <td class="inquire_form4" >
          	<input name="project_name" id="project_name" class="input_width" type="text"  value="" readonly/>
          	<%-- <input name="project_info_no" id="project_info_no" class="input_width" type="hidden"  value="" readonly/>
          	<input name="devicemixinfoid" id="devicemixinfoid" type="hidden" value="<%=mixInfoId%>" />
          	<input name="deviceoutinfoid" id="deviceoutinfoid" type="hidden" value="<%=outInfoId%>" />
          	<input name="devouttype" id="devouttype" type="hidden" value="1" /> --%>
          </td>
          <td class="inquire_item4" ></td><td class="inquire_form4" ></td>
        </tr>
        <tr>
          <td class="inquire_item4" >设备名称:</td>
          <td class="inquire_form4" >
          	<input name="device_name" id="device_name" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >设备类型:</td>
          <td class="inquire_form4" >
          	<input name="device_model" id="device_model" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4" >调配数据:</td>
          <td class="inquire_form4" >
          	<input name="mix_num" id="mix_num" class="input_width" type="text"  value="" readonly/>
          </td>
          <td class="inquire_item4" >出库数量:</td>
          <td class="inquire_form4" >
          	<input name="out_num" id="out_num" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
      </table>
      </fieldSet>
      <fieldset>
      	<legend>明细信息</legend>
      		<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_outinfo_id_{device_outinfo_id}' name='device_outinfo_id'>
			     	<%-- <td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' device_outinfo_id='{device_outinfo_id}' outstate='{state}' value='{device_outinfo_id}~{device_mixinfo_id}' id='selectedbox_{device_outinfo_id}~{device_mixinfo_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td> --%>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{dev_ci_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_ci_model}">设备型号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<!-- <td class="bt_info_odd" exp="{mixinfo_no}">调配单号</td>
					<td class="bt_info_even" exp="{mix_date}">调配时间</td>
					<td class="bt_info_even" exp="{out_org_name}">转出单位</td>
					<td class="bt_info_odd" exp="{in_org_name}">接收单位</td>
					<td class="bt_info_odd" exp="{outstate_desc}">出库状态</td>
					<td class="bt_info_even" exp="{outinfo_no}">出库单号</td>
					<td class="bt_info_odd" exp="{employee_name}">经办人</td>
					<td class="bt_info_even" exp="{print_date}">出库时间</td> -->
			     </tr> 
			  </table>
			</div>
			<div id="fenye_box"  style="display:block">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
      </fieldset>
    </div>
    <div id="oper_div">
        <span class="gb_btn"><a href="#" onclick="cwin()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
var _vparam = window.dialogArguments;
var str = "select t.outinfo_no,p.project_name,o.device_name,o.device_model,o.mix_num,o.out_num from GMS_DEVICE_COLL_OUTFORM t join GMS_DEVICE_COLL_OUTSUB o on t.device_outinfo_id=o.device_outinfo_id and o.device_oif_subid='"+_vparam.subid+"'  left join gp_task_project p on t.project_info_no=p.project_info_no where t.device_outinfo_id='"+_vparam.outid+"'";
var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
if(!!unitRet && !!unitRet.datas && !!unitRet.datas[0]){
	$.each(unitRet.datas[0],function(i,k){
		$("#"+i).val(k);
	});
}

cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';

function refreshData(){
	var sql = "select c.dev_ci_name,c.dev_ci_model,c.dev_ci_unit,t.* from GMS_DEVICE_COLL_OUTDET t left join GMS_DEVICE_CODEINFO c on t.type_seq=c.type_seq where t.device_outinfo_id='"+_vparam.outid+"' and t.device_oif_subid='"+_vparam.subid+"'  order by t.create_date desc";
	cruConfig.queryStr = sql;
	queryData(cruConfig.currentPage);
}
function cwin(){
	window.close();
}
</script>
</html>

