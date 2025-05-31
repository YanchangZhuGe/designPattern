<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String projectName = user.getProjectName();
	String orgName = user.getOrgName();
	String  sql = "select oi.org_abbreviation org_name from gp_task_project_dynamic d join comm_org_information oi on d.org_id = oi.org_id and oi.bsflag='0' where d.bsflag='0' and d.project_info_no='"+projectInfoNo+"'";
	Map map = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(sql);
	if(map!=null){
		orgName = (String)map.get("orgName");
	}
	
	String procure_no = "";
	Date date = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	String today = sdf.format(date);
	String autoSql = "select procure_no from gms_mat_out_info t where t.project_info_no='"+ projectInfoNo+ "' and t.bsflag='0' and t.out_type = '2' and t.procure_no like '"+today+"%' order by procure_no desc";
	Map  autoMap = BeanFactory.getQueryJdbcDAO().queryRecordBySQL(autoSql);
	if(autoMap!=null&&autoMap.size()!=0){
		String input_nos = (String)autoMap.get("procureNo");
		String[] temp = input_nos.split("-");
		String nos = String.valueOf(Integer.parseInt(temp[1])+1);
		if(nos.length()==1){
			nos = "00"+nos;
		}else if(nos.length()==2){
			nos = "0"+nos;
		}
		procure_no = today + "-" +nos;
	}else{
		procure_no = today + "-001";
	}
	
	String sql1="select org_id,org_name,org_abbreviation from comm_org_information  where org_id= 'C6000000000039' and bsflag='0' or org_id= 'C6000000000040' and bsflag='0' or org_id= 'C6000000005269' and bsflag='0' or org_id= 'C6000000005275' and bsflag='0' or org_id= 'C6000000005279' and bsflag='0' or org_id= 'C6000000005280' and bsflag='0'or org_id= 'C6000000005278' and bsflag='0'  or org_id= 'C6000000005370' and bsflag='0'";
	List orgList=BeanFactory.getQueryJdbcDAO().queryRecords(sql1);
	
	
	String org_id = user.getOrgId();
	String wz_type = "";
	if(org_id!=null&&(org_id.equals("C6000000000039")||org_id.equals("C6000000000040")||org_id.equals("C6000000005275")||org_id.equals("C6000000005277")||org_id.equals("C6000000005278")||org_id.equals("C6000000005279")||org_id.equals("C6000000005280"))){
		wz_type = "11";
	}else{
		wz_type = "22";
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body onload='refreshData()'>
<form name="form1" id="form1" method="post"
	action="">
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
<table border="0" cellpadding="0" cellspacing="0"
	class="tab_line_height" width="100%">
	<input type='hidden' name = 'wzType' id='wzType' value='<%=wz_type %>'/>
	<tr>
    	<td colspan="6" align="center">退库</td>
    </tr>
	<tr>
		<td class="inquire_item6">项目名称：</td>
		<td class="inquire_item6"><input type="text"
			name="project_name" id="project_name" class="input_width"
			value="<%=projectName %>"  readonly/></td>
		<td class="inquire_item6">退库单位：</td>
		<td class="inquire_item6"><input type="text"
			name="org_name" id="org_name" class="input_width"
			value="<%=orgName %>" readonly />
			</td>
		<td class="inquire_item6">接受单位：</td>
		<td class="inquire_item6">
			<select id="input_storeroom" name="input_storeroom" value="">
			 	    	<option value="">全部</option>
			 	    	<option value="C6000000000039">船舶管理服务中心</option>
			 	    	<option value="C6000000000040">仪器设备服务中心</option>
			 	    	<option value="C6000000005275">采集项目支持中心</option>
			 	    	<option value="C6000000005277">人力资源中心</option>
			 	    	<option value="C6000000005278">滩海运载设备服务中心</option>
			 	    	<option value="C6000000005279">小车服务中心</option>
			 	    	<option value="C6000000005280">运输设备服务中心</option>
			</select>
		</td> 
	
	</tr>
	<tr>
			<td class="inquire_item6">编号：</td>
		<td class="inquire_item6"><input type="text"
			name="procure_no" id="procure_no" class="input_width"
			value="<%=procure_no %>" />
			</td>
		<td class="inquire_item6">退库时间：</td>
		<td class="inquire_item6"><input type="text" name="out_date" id="out_date"
			class="input_width"
			value="" readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(out_date,tributton1);" />
			</td>
		<td class="inquire_item6">发料库房：</td>
		<td class="inquire_item6"><input type="text" name="storeroom" id="storeroom"
			class="input_width" value="" /></td>
	</tr>
	<tr>
		<td class="inquire_item6">发料单位：</td>
		<td class="inquire_item6"><input type="text"
			name="input_org" id="input_org" class="input_width"
			value=""  /></td>
		<td class="inquire_item6">合计金额：</td>
		<td class="inquire_item6"><input type="text" name="total_money" id="total_money"
			class="input_width"
			value="" readonly/></td>
		<td class="inquire_item6">项数：</td>
		<td class="inquire_item6"><input type="text" name="terms_num" id="terms_num"
			class="input_width" value="" readonly/></td>
	</tr>
	<tr>
		<td class="inquire_item6">经办：</td>
		<td class="inquire_item6"><input type="text"
			name="operator" id="operator" class="input_width"
			value=""  /></td>
		<td class="inquire_item6">发料：</td>
		<td class="inquire_item6"><input type="text" name="storage" id="storage"
			class="input_width"
			value="" />
		</td>
		<td class="inquire_item6">提货：</td>
		<td class="inquire_item6"><input type="text" name="pickupgoods" id="pickupgoods"
			class="input_width" value="" />
		</td>
	</tr>
	<tr>
		<td class="inquire_item6">运输方式：</td>
		<td class="inquire_item6"><input type="text"
			name="transport_type" id="transport_type" class="input_width"
			value=""  /></td>
		<td class="inquire_item6">备注：</td>
		<td class="inquire_item6"><input type="text" name="note" id="note"
			class="input_width"
			value="" />
		</td>
	</tr>
</table>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input name = 'rdo_entity_id' id = 'rdo_entity_id' type='checkbox' checked='true' value='{wz_id}_{goods_allocation}' onclick='loadDataDetail();sumChecked()'/>" ><input type='checkbox' name='wzinfo' id='wzinfo'/></td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_even" exp="{wz_id}">物资编码</td>
				<td class="bt_info_odd" exp="{wz_name}">名称</td>
				<td class="bt_info_even" exp="{wz_prickie}">计量单位</td>
				<td class="bt_info_odd" exp="{stock_num}">库存数量</td>
				<td class="bt_info_even" exp="<input type='text' name='mat_num_{wz_id}_{goods_allocation}'  style='width:40px' value='' onkeyup='loadDataDetail()' readonly/>">退库数量</td>
				<td class="bt_info_odd"exp="<input name='wz_price_{wz_id}_{goods_allocation}' type='text'  style='width:40px' value='{wz_price}' onkeyup='loadDataDetail()'/>">单价</td>
				<td class="bt_info_even"exp="<input type='text' name='total_money_{wz_id}_{goods_allocation}' style='width:40px' value='{total_money}'readonly/>">金额</td>
	<!-- 		<td class="bt_info_odd"exp="<input type='text' name='org_id_{wz_id}_' style='display:none' value='{org_id}'/>{org_abbreviation}">出库单位</td> -->
			</tr>
		</table>
	</div>
	<table id="fenye_box_table">
	</table>
</div>
		
<div id="oper_div"><span class="bc_btn"><a href="#"
	onclick="save()"></a></span> <span class="gb_btn"><a href="#"
	onclick="newClose()"></a></span></div>
</div>
</div>
</form>
</body>
<script type="text/javascript">
	$().ready(function (){
		$("#wzinfo").change(function(){
			var wzId = this.checked;
			$("input[type='checkbox'][name=rdo_entity_id]").attr('checked',wzId);
			});
		});
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	cruConfig.queryStr = "";
	//cruConfig.queryService = "MatItemSrv";
	//cruConfig.queryOp = "getTracLeaf";
	cruConfig.queryService = "MatItemSrv";
	cruConfig.queryOp = "getOtherRepOut_Dg";
	var checkIds="";
	function refreshData(){
		cruConfig.submitStr ="isRecyclemat=0";
		queryData(1);
		checkIds=getSelIds('rdo_entity_id');
		sumChecked();
		var tab =document.getElementById("queryRetTable");
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			if(row[i].cells[6].firstChild.value != undefined){
			row[i].cells[6].firstChild.value=row[i].cells[5].innerHTML;
			}
		}
		loadDataDetail();
	}							
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
		 if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		 else{
			var input_storeroom = document.getElementById("input_storeroom").value;
			if(input_storeroom==null||input_storeroom==""){
				alert("请选择接收单位!");
				return;
			}
			document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouseDg/out/rettrac/saveMatOutDg.srq?laborId="+ids;
			document.getElementById("form1").submit();
		 }
	}
	function sumChecked(){
		var tab =document.getElementById("queryRetTable");
		var row = tab.rows;
		var sum=0;
		for(var i=0;i<row.length;i++){
			var cell = row[i].cells[0];
			if(cell.firstChild.checked==true)
				sum+=1;
			}
		document.getElementById("terms_num").value=sum;
		}
	function loadDataDetail(){
		debugger;
		var tab =document.getElementById("queryRetTable");
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			var cell_1=row[i].cells[0].firstChild;
			if(cell_1.checked==true){
				var sj_num=row[i].cells[5].innerHTML;
				var cell_6 = row[i].cells[6].firstChild.value;
				var cell_7 = row[i].cells[7].firstChild.value;
				if(cell_6!=undefined && cell_7!=undefined){
					
						if(cell_6==""){
							outNum=0;
							}
						else{
							outNum=cell_6;
							}
						
						if(cell_7==""){
							wzPrice=0;
							}
						else{
							wzPrice=cell_7;
							}
						if(sj_num !='&nbsp' && sj_num !=""){
							if(cell_6>sj_num){
									alert("退库量不能大于库存量！");
								}
							}
					row[i].cells[8].firstChild.value=outNum*wzPrice;
					totalMoney+=parseInt(row[i].cells[8].firstChild.value);
				}


				}
				
		}
		document.getElementById("total_money").value=Math.round(totalMoney*1000)/1000;
	}
</script>
</html>