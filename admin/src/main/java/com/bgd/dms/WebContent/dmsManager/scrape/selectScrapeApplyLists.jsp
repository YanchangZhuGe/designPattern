<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	//String orgsubid = DevConstants.MIXTYPE_ZHUANGBEI_ORGSUBID;
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String out_org_id= request.getParameter("out_org_id");
	String selectId = request.getParameter("selectId");
	String type = request.getParameter("type");//1代表来自报废汇总、2代表来自报废上报
	if(selectId!=null&&(selectId.equals("undefined")||selectId.equals("null"))){
	 selectId = "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=7"/>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

 <title>报废申请单查询页</title> 
 </head> 
 
 <body style="background:#F1F2F3" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box" style="height:64px;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_131.png" width="6" height="64" /></td>
			    <td background="<%=contextPath%>/images/list_151.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">申请单名称</td>
			    <td class="ali_cdn_input">
			    	<input id="scrape_apply_name" name="scrape_apply_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">申请单号</td>
			    <td class="ali_cdn_input">
			    	<input id="scrape_apply_no" name="scrape_apply_no" type="text" class="input_width" />
			    </td>
			    	<td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			      <td>&nbsp;</td>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_171.png" width="4" height="64" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			    	<tr id='dev_acc_id_{scrape_apply_id}' name='scrape_apply_id' idinfo='{scrape_apply_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_name' value='{scrape_apply_id}' id='rdo_entity_name_{scrape_apply_id}' {selectflag}/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_even" exp={scrape_apply_name}>报废申请单名称</td>
					<td class="bt_info_odd" exp={scrape_apply_no}>报废申请单号</td>
					<td class="bt_info_odd" exp={employee_name}>申请人</td>
					<td class="bt_info_even" exp={org_name}>申请单位</td>
					<td class="bt_info_odd" exp={apply_date}>申请时间</td>
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
		 </div>
	<div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">
	var selectId = "<%=selectId%>";
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var obj = window.dialogArguments;
	function searchDevData(){
		var scrape_apply_name = $("#scrape_apply_name").val();
		var scrape_apply_no = $("#scrape_apply_no").val();
		refreshData(scrape_apply_name,scrape_apply_no);
	}
	
	var out_org_id='<%=out_org_id%>';
	
	var type='<%=type%>';
	// 如果设备 所在单位 为空，则条件 查找 设备 所属单位，否则查找 设备 所在单位
	function refreshData(scrape_apply_name,scrape_apply_no){
		var str = "select * from (select t.*, t2.proc_status apply_status,emp.employee_name,org.org_abbreviation as org_name  from dms_scrape_apply t left join common_busi_wf_middle t2 on t.scrape_apply_id = t2.business_id and t2.bsflag = '0' left join comm_human_employee emp on t.employee_id = emp.employee_id   left join comm_org_information org on t.scrape_org_id = org.org_id where t.bsflag = '0') pp where pp.apply_status = '3' ";
		if(type!=undefined && type!=''){
			if(type==1){
				str +="and pp.SCRAPE_COLLECT_FLAG is null "
			}else if(type=2){
				str +="and pp.SCRAPE_COLLECT_FLAG=1 and pp.SCRAPE_REPORT_FLAG is null "
			}
		}
		if(scrape_apply_name!=undefined && scrape_apply_name!=''){
			str += "and pp.scrape_apply_name like '%"+scrape_apply_name+"%' ";
		}
		if(scrape_apply_no!=undefined && scrape_apply_no!=''){
			str += "and pp.scrape_apply_no like '%"+scrape_apply_no+"%' ";
		}
		
		str += "  order by pp.create_date desc";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
 
	  function submitInfo(){  
		  var ids = "";
		  ids = getSelIds('rdo_entity_name');
	      if (ids == "") {
	         alert("请选择一条记录!");
	         return;
	      }
	      var temp = ids.split(",");
			var wz_ids = "";
			for(var i=0;i<temp.length;i++){
				if(wz_ids!=""){
					wz_ids += ","; 
				}
				wz_ids += "'"+temp[i]+"'";
		  }
		  window.returnValue = wz_ids;
	  	  window.close();
	  }
	  function newClose(){
		  window.close();
	  }
	
 
</script>
</html>