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
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
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
	<input type='hidden' id='out_info_id' name='out_info_id' value='<gms:msg msgTag="matInfo" key="out_info_id"/>'/>
	<input type='hidden' id='wzType' name='wzType' value='<gms:msg msgTag="matInfo" key="wz_type"/>'/>
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
<table border="0" cellpadding="0" cellspacing="0"
	class="tab_line_height" width="100%">
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
		<td class="inquire_item6">接收库：</td>
		<td class="inquire_item6">
			<input type="hidden" name="input_storeroom" id="input_storeroom" class="input_width" value="<gms:msg msgTag="matInfo" key="input_storeroom"/>" readonly="readonly"/>
			<input type="text" name="input_store" id="input_store class="input_width" value="<gms:msg msgTag="matInfo" key="input_store"/>" readonly="readonly"/>
		</td>
	
	</tr>
	<tr>
		
		<td class="inquire_item6">退库单号：</td>
		<td class="inquire_item6"><input type="text" name="procure_no" id="procure_no" class="input_width" value="<gms:msg msgTag="matInfo" key="procure_no"/>" />
		</td>
		<td class="inquire_item6"><font color="red">*</font>退库时间：</td>
		<td class="inquire_item6"><input type="text" name="out_date" id="out_date"
			class="input_width"
			value="<gms:msg msgTag="matInfo" key="out_date"/>" readonly />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(out_date,tributton1);" />
			</td>
		<td class="inquire_item6">合计金额：</td>
		<td class="inquire_item6"><input type="text" name="total_money" id="total_money"
			class="input_width" value="" readonly/></td>
	</tr>
	<tr>		
		<td class="inquire_item6">项数：</td>
		<td class="inquire_item6"><input type="text" name="terms_num" id="terms_num"
			class="input_width" value="<gms:msg msgTag="matInfo" key="terms_num"/>" readonly/></td>
		<td class="inquire_item6">经办：</td>
		<td class="inquire_item6"><input type="text"
			name="operator" id="operator" class="input_width"
			value="<gms:msg msgTag="matInfo" key="operator"/>"  /></td>
		<td class="inquire_item6">发料：</td>
		<td class="inquire_item6"><input type="text" name="storage" id="storage"
			class="input_width"
			value="<gms:msg msgTag="matInfo" key="storage"/>" />
		</td>
	</tr>
	<tr>
		<td class="inquire_item6">提货：</td>
		<td class="inquire_item6"><input type="text" name="pickupgoods" id="pickupgoods"
			class="input_width" value="<gms:msg msgTag="matInfo" key="pickupgoods"/>" />
		</td>
		<td class="inquire_item6">运输方式：</td>
		<td class="inquire_item6"><input type="text"
			name="transport_type" id="transport_type" class="input_width"
			value="<gms:msg msgTag="matInfo" key="transport_type"/>"  /></td>
		<td class="inquire_item6">备注：</td>
		<td class="inquire_item6"><input type="text" name="note" id="note"
			class="input_width"
			value="<gms:msg msgTag="matInfo" key="note"/>" />
		</td>
	</tr>
</table>
	<div id="table_box" >
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" id="queryRetTable">
			<tr>
				<td class="bt_info_odd" exp="<input name = 'rdo_entity_id' id = 'rdo_entity_id' type='checkbox' checked='true' value='{wz_id}_{goods_allocation}' onclick='loadDataDetail();sumChecked()'/>" >选择</td>
				<td class="bt_info_even" autoOrder="1">序号</td>
				<td class="bt_info_even" exp="{wz_id}">物资编码</td>
				<td class="bt_info_odd" exp="{wz_name}">名称</td>
				<td class="bt_info_even" exp="{wz_prickie}">计量单位</td>
				<td class="bt_info_odd" exp="{stock_num}">库存数量</td>
				<td class="bt_info_even" exp="<input type='text' name='mat_num_{wz_id}_{goods_allocation}'  style='width:40px' value='{out_num}' onkeyup='loadDataDetail()'/>">退库数量</td>
				<td class="bt_info_odd"exp="<input name='wz_price_{wz_id}_{goods_allocation}' type='text'  style='width:40px' value='{out_price}' onkeyup='loadDataDetail()'/>">单价</td>
				<td class="bt_info_even"exp="<input type='text' name='total_money_{wz_id}_{goods_allocation}' style='width:40px' value='{total_money}'readonly/>">金额</td>
				<td class="bt_info_odd"exp="<input type='text' name='goods_allocation_{wz_id}_{goods_allocation}' style='width:40px' value='{goods_allocation}'/>">货位</td>
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
	cruConfig.contextPath =  "<%=contextPath%>";
	var checkIds="";
	function refreshData(){
		debugger;
		var value="<gms:msg msgTag="matInfo" key="out_info_id"/>";
		var total_money = "<gms:msg msgTag="matInfo" key="total_money"/>";
		var wzType = "<gms:msg msgTag="matInfo" key="wz_type"/>";
//		var sql ="select * from gms_mat_out_info t inner join (gms_mat_out_info_detail d inner join (gms_mat_infomation i inner join GMS_MAT_TEAMMAT_INFO m on i.wz_id=m.wz_id and m.bsflag='0') on d.wz_id=i.wz_id and d.bsflag='0' and i.bsflag='0')on t.out_info_id=d.out_info_id and t.bsflag='0'and t.out_info_id='"+value+"'and t.project_info_no='<%=projectInfoNo%>'";
//		var sql = "select * from gms_mat_out_info_detail t inner join gms_mat_out_info mi on t.out_info_id=mi.out_info_id and mi.bsflag='0' left join gms_mat_infomation i on t.wz_id = i.wz_id  and i.bsflag = '0' left join GMS_MAT_TEAMMAT_INFO m on t.wz_id=m.wz_id and m.bsflag='0'    where t.bsflag='0' and t.out_info_id = '"+value+"' and t.project_info_no = '<%=projectInfoNo%>'";
		var sql = "";
		if(wzType=='0'){//在帐
			sql +="select tt.coding_name,mi.wz_id,mi.wz_name,mi.wz_prickie,mi.wz_price,nvl(tt.stock_num,0)+nvl(od.out_num,0) as stock_num,tt.mat_num,od.goods_allocation,od.out_num,od.out_price,od.total_money from gms_mat_out_info_detail od left join (select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.invoices_type !='2' and mti.project_info_no='<%=projectInfoNo%>' and mti.if_input='0' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='"+wzType+"' and mto.project_info_no='<%=projectInfoNo%>' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '<%=projectInfoNo%>' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '<%=projectInfoNo%>') a order by a.wz_id asc) tt  on tt.wz_id = od.wz_id and od.bsflag='0' join gms_mat_infomation mi on mi.wz_id=od.wz_id and mi.bsflag='0' where od.out_info_id = '"+value+"' and od.project_info_no='<%=projectInfoNo%>'";
			}
		else{//可重复
			sql +="select tt.coding_name,mi.wz_id,mi.wz_name,mi.wz_prickie,mi.wz_price,nvl(tt.stock_num,0)+nvl(od.out_num,0) as stock_num,tt.mat_num,od.goods_allocation,od.out_num,od.out_price,od.total_money from gms_mat_out_info_detail od left join (select a.coding_name,a.wz_id,a.wz_name,a.wz_prickie,a.wz_price,a.stock_num,a.mat_num,a.out_num from(select dd.coding_name, i.wz_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.invoices_type ='2' and mti.project_info_no='<%=projectInfoNo%>' and mti.if_input='0' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.wz_type='"+wzType+"' and mto.project_info_no='<%=projectInfoNo%>' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '<%=projectInfoNo%>' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '<%=projectInfoNo%>') a order by a.wz_id asc) tt  on tt.wz_id = od.wz_id and od.bsflag='0' join gms_mat_infomation mi on mi.wz_id=od.wz_id and mi.bsflag='0' where od.out_info_id = '"+value+"' and od.project_info_no='<%=projectInfoNo%>'";
			}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/mat/singleproject/warehouse/out/rettrac/matOutEdit.jsp";
		queryData(1);
		checkIds=getSelIds('rdo_entity_id');
		sumChecked();
		document.getElementById("total_money").value = total_money;
		loadDataDetail();
	}							
	function save(){	
		//if (!checkForm()) return;
		ids = getSelIds('rdo_entity_id');
		 if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		 var out_date = document.getElementById("out_date").value;
		 if(out_date==""){
			 alert("退库时间不能为空!");
			 return;
		 }
		 if(loadDataDetail()){
			document.getElementById("form1").action="<%=contextPath%>/mat/singleproject/warehouse/out/rettrac/updateMatOut.srq?laborId="+ids+"&checkIds="+checkIds;
			document.getElementById("form1").submit();
			$("#new_table_box_content").mask("请等待...");
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
	function loadDataDetail(shuaId){
		var tab =document.getElementById("queryRetTable");
		var outNum=0;
		var wzPrice=0;
		var totalMoney=0;
		var flag = true;
		var row = tab.rows;
		for(var i=1;i<row.length;i++){
			var cell_6 = row[i].cells[6].firstChild.value;
			var cell_7 = row[i].cells[7].firstChild.value;
			var cell_5 = row[i].cells[5].innerHTML;
			if(cell_6!=undefined && cell_7!=undefined){
				
					if(cell_6==""){
						outNum=0;
						}
					else{
						outNum=cell_6;
						}
					if(Number(outNum)>Number(cell_5)){
						alert("退库数量不能大于库存数量!");
						flag = false;
						return;
					}
					
					if(cell_7==""){
						wzPrice=0;
						}
					else{
						wzPrice=cell_7;
						}
					
				row[i].cells[8].firstChild.value=Math.round(outNum*wzPrice*1000)/1000;
				if(row[i].cells[0].firstChild.checked == true){
					totalMoney+=Number(row[i].cells[8].firstChild.value);
				}
			}
		}
		document.getElementById("total_money").value=Math.round(totalMoney*1000)/1000;
		return flag;
	}
</script>
</html>