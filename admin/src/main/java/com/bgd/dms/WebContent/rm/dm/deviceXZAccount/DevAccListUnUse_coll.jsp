<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String projectInfoNo = request.getParameter("projectInfoNo");
  	String code = request.getParameter("code");
  	String is_devicecode = request.getParameter("isDeviceCode");
 
 
	String userSubid = user.getOrgSubjectionId();
	String subOrgId = user.getSubOrgIDofAffordOrg();
	String orgId= user.getOrgId();
	String orgType="";
	String dgOrg="C6000000000039,C6000000000040,C6000000005269,C6000000005280,C6000000005275,C6000000005279,C6000000005278,C6000000007366";
	//大港8个服务中心判断标志
	if(dgOrg.contains(orgId)){
		orgType="Y";
	}else{
		orgType="N";
	}
	String zhEquSub="";
	if(userSubid.startsWith("C105008042")){//综合物化探机动设备服务中心用户显示设备物资科设备
		zhEquSub="Y";
	}
	String dev_name=request.getParameter("dev_name");
	String org_name=request.getParameter("org_name");
  	String country=request.getParameter("country");
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
  <title>多项目-设备台账管理-设备台账管理(单台)</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
  <input id="export_name" name="export_name" value="地震仪器" type='hidden' />
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			      <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="query_dev_name" name="query_dev_name" type="text" class="input_width"/></td>
			    <td class="ali_cdn_name">设备型号</td>
			    <td class="ali_cdn_input">
			    	<input id="type_id" name="type_id" type="text" class="input_width"/>
      			</td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>		
			    <td>&nbsp;</td>
			   <!--<auth:ListButton functionId="" css="yd" event="onclick='toCopy()'" title="调剂"></auth:ListButton>-->
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}' />" >选择</td>
					<td class="bt_info_odd" exp="{dev_name}">采集设备名称</td>
					<td class="bt_info_even" exp="{dev_type}">采集设备类型</td>
					<td class="bt_info_odd" exp="{dev_model}">采集设备型号</td>
					<td class="bt_info_even" exp="{unit_name}">计量单位</td>
					<td class="bt_info_even" exp="{usage_org_name}">所在单位</td>
					<td class="bt_info_odd" exp="{total_num}">总数量</td>
					<td class="bt_info_even" exp="{unuse_num}">闲置数量</td>
					<td class="bt_info_odd" exp="{use_num}">在用数量</td>
					<td class="bt_info_even" exp="{other_num}">其他数量</td>
					<td class="bt_info_odd" exp="{ifcountry}">国内/国外</td>
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
		 
</div>
</body>
<script type="text/javascript">
$(function(){
	$(window).resize(function(){
		
		if(lashened==0){
			$("#table_box").css("height",$(window).height()*0.75);
		}
		$("#tab_box .tab_box_content").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-10);
		$("#tab_box .tab_box_content").each(function(){
			if($(this).children('iframe').length > 0){
				$(this).css('overflow-y','hidden');
			}
		});
	});
})
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var orgtype = '<%=orgType%>';//大港8个专业化中心判断
	var usersubid = '<%=userSubid%>';

	function searchDevData(){
	var query_dev_name = document.getElementById("query_dev_name").value;
		var query_dev_type = document.getElementById("type_id").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":query_dev_name});
		obj.push({"label":"dev_model","value":query_dev_type});	
		refreshData(obj,'');
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
    	document.getElementById("s_dev_model").value="";
		document.getElementById("s_license_num").value="";		
    }
	//点击树节点查询
	var code = '<%=code%>';
	var is_devicecode = '<%=is_devicecode%>';
	var	node_level;
	var org_name='<%=org_name%>';
	var dev_name='<%=dev_name%>';
	var country=decodeURI('<%=country%>');
	function refreshData(arrObj,numObj){
	var sql = "select *from (select aa.*,(aa.unuse_num+aa.use_num+aa.other_num)as total_num from ( "
				+ " select tmp.*,nvl((select sum(dui.unuse_num) from gms_device_coll_account_dui dui "
				+ " left join gp_task_project p on p.project_info_no=dui.project_info_id"
				+ " left join gp_task_project_dynamic dy on dy.project_info_no=dui.project_info_id "
			    + " where dui.bsflag='0' and dui.device_id=tmp.device_id and tmp.org_id is not null "
			    + " and dy.org_subjection_id like '%'||tmp.org_id||'%'),0) as use_num "
				+ " from (select acc.type_id,acc.device_id,acc.dev_acc_id,acc.dev_unit,acc.dev_model,acc.dev_name,"
				+ " nvl(teach.tocheck_num,0) as tocheck_num, nvl(teach.noreturn_num,0)as noreturn_num, "
				+ " teach.good_num as unuse_num,(nvl(teach.touseless_num,0)+nvl(teach.torepair_num,0)+nvl(teach.repairing_num,0)+nvl(teach.tocheck_num,0)+nvl(teach.noreturn_num,0)+nvl(teach.destroy_num, 0)) as other_num, "
				+ " case when acc.ifcountry='000' then '国内' else acc.ifcountry end as ifcountry,ci.dev_code,l.coding_name as dev_type, "
				+ " usageorg.org_abbreviation as usage_org_name,owingorg.org_abbreviation as owning_org_name,unitsd.coding_name as unit_name, org.org_abbreviation as org_name, "
				+ " acc.usage_sub_id,acc.usage_org_id,acc.owning_org_id,acc.owning_sub_id,suborg.org_subjection_id, "
				+ " case when usageorg.org_abbreviation='塔里木作业部' then 'C105001005' "
				+ " when usageorg.org_abbreviation='北疆作业部' then 'C105001002' when usageorg.org_abbreviation='吐哈作业部' then 'C105001003' "
				+ " when usageorg.org_abbreviation='敦煌作业部' then 'C105001004' when usageorg.org_abbreviation='长庆作业部' then 'C105005004' " 
				+ " when usageorg.org_abbreviation='辽河作业部' then 'C105063' when usageorg.org_abbreviation='华北作业部' then 'C105005000' "
				+ " when usageorg.org_abbreviation='新区作业部' then 'C105005001' when usageorg.org_abbreviation='大港作业分部' then 'C105007' "
				+ " when usageorg.org_abbreviation='仪器设备服务中心' then 'C105007' else '' end as org_id "
				+ " from gms_device_coll_account acc left join comm_coding_sort_detail l on l.coding_code_id=acc.type_id and l.coding_sort_id like '5110000031' "
				+ " left join gms_device_collectinfo ci on acc.device_id=ci.device_id "
				+ " left join comm_org_information org on acc.owning_org_id=org.org_id and org.bsflag = '0' "
				+ " left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id and usageorg.bsflag = '0' "
				+ " left join comm_org_information owingorg on acc.owning_org_id=owingorg.org_id and owingorg.bsflag = '0' "
				+ " left join comm_org_subjection suborg on acc.owning_org_id = suborg.org_id and suborg.bsflag = '0' "
				+ " left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id "
				+ " left join gms_device_coll_account_tech teach on teach.dev_acc_id=acc.dev_acc_id ";
			if(orgtype == 'Y'){//大港8个专业化中心只能看到自己中心的数据
				sql += "where acc.bsflag='0' and ci.is_leaf = '1' and acc.usage_sub_id like '"+usersubid+"%'  ";
			}else{
				sql += "where acc.bsflag='0' and ci.is_leaf = '1' and acc.usage_sub_id like '<%=subOrgId%>%'  ";
			}
			
			sql +=	")tmp where 1=1 ";
			debugger;
			if(country!='--全部--'&&country!='null'){
			sql+= "  and ifcountry='"+country+"'";
			}
			sql +=" and (tmp.dev_code like '01%' or tmp.dev_code like '02%'  or tmp.dev_code like '03%' or tmp.dev_code like '05%' ) ";
	 
		for(var key in arrObj){
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				sql += " and tmp."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
			}
		}
		sql += " )aa where 1=1 ";
		if(numObj!=undefined && numObj!=""){
			//总数量
			if(numObj.totalminnum!=undefined && numObj.totalmaxnum!=undefined){
				sql += " and (aa.unuse_num + aa.use_num + aa.other_num) >= "+numObj.totalminnum+" and (aa.unuse_num + aa.use_num + aa.other_num) <= "+numObj.totalmaxnum+"";
			}
			if(numObj.totalminnum!=undefined && numObj.totalmaxnum==undefined){
				sql += " and (aa.unuse_num + aa.use_num + aa.other_num) >= "+numObj.totalminnum+"";
			}
			if(numObj.totalmaxnum!=undefined && numObj.totalminnum==undefined){
				str += " and (aa.unuse_num + aa.use_num + aa.other_num) <= "+numObj.totalmaxnum+"";
			}
			
			//闲置数量
			if(numObj.unuseminnum!=undefined && numObj.unusemaxnum!=undefined){
				sql += " and aa.unuse_num >= "+numObj.unuseminnum+" and aa.unuse_num <= "+numObj.unusemaxnum+"";
			}
			if(numObj.unuseminnum!=undefined && numObj.unusemaxnum==undefined){
				sql += " and aa.unuse_num >= "+numObj.unuseminnum+"";
			}
			if(numObj.unusemaxnum!=undefined && numObj.unuseminnum==undefined){
				sql += " and aa.unuse_num <= "+numObj.unusemaxnum+"";
			}
			
			//在用数量
			if(numObj.useminnum!=undefined && numObj.usemaxnum!=undefined){
				sql += " and aa.use_num >= "+numObj.useminnum+" and aa.use_num <= "+numObj.usemaxnum+"";
			}
			if(numObj.useminnum!=undefined && numObj.usemaxnum==undefined){
				sql += " and aa.use_num >= "+numObj.useminnum+"";
			}
			if(numObj.usemaxnum!=undefined && numObj.useminnum==undefined){
				sql += " and aa.use_num <= "+numObj.usemaxnum+"";
			}
			
			//其他数量
			if(numObj.otherminnum!=undefined && numObj.othermaxnum!=undefined){
				sql += " and aa.other_num >= "+numObj.otherminnum+" and aa.other_num <= "+numObj.othermaxnum+"";
			}
			if(numObj.otherminnum!=undefined && numObj.othermaxnum==undefined){
				sql += " and aa.other_num >= "+numObj.otherminnum+"";
			}
			if(numObj.othermaxnum!=undefined && numObj.otherminnum==undefined){
				sql += " and aa.other_num <= "+numObj.othermaxnum+"";
			}
		}
		sql += " order by usage_org_name,dev_type,"
			 + " case"
			 + " when dev_name = '电源站' then 'A' when dev_name = '交叉站' then 'B'"
			 + " when dev_name = '采集站' then 'C' else 'D' end ) where 1=1 and total_num>0 ";
			 debugger;
			 if(dev_name!=undefined && dev_name!=""&& dev_name!='null'){
			 sql +=" and dev_name ='"+decodeURI(dev_name)+"'";
			 }
			 if(org_name!=undefined && org_name!=""&& dev_name!='null'){
			 sql +=" and usage_org_name='"+decodeURI(org_name)+"'"
			 }
		cruConfig.queryStr = sql;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
	}
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
    

	function excelDataAdd(){
		popWindow('<%=contextPath%>/rm/dm/deviceAccount/devExcelAdd.jsp');
		}
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/dm/xlsmodel/download.jsp?path=/rm/dm/deviceAccount/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	function createNewTitleTable(){
		// 如果是dialog
		if(window.dialogArguments){
			return;
		}
		
		// 如果声明了不出现固定表头
		if(window.showNewTitle==false){
			return;
		}
		
		var newTitleTable = document.getElementById("newTitleTable");
		if(newTitleTable!=null) return;
		var queryRetTable = document.getElementById("queryRetTable");
		if(queryRetTable==null) return;
		var titleRow = queryRetTable.rows(0);
		
		var newTitleTable = document.createElement("table");
		newTitleTable.id = "newTitleTable";
		newTitleTable.className="tab_info";
		newTitleTable.border="0";
		newTitleTable.cellSpacing="0";
		newTitleTable.cellPadding="0";
		newTitleTable.style.width = queryRetTable.clientWidth;
		newTitleTable.style.position="absolute";
		var x = getAbsLeft(queryRetTable);
		newTitleTable.style.left=x+"px";
		var y = getAbsTop(queryRetTable)-4;
		newTitleTable.style.top=y+"px";
		
		
		var tbody = document.createElement("tbody");
		var tr = titleRow.cloneNode(true);
		
		tbody.appendChild(tr);
		newTitleTable.appendChild(tbody);
		document.body.appendChild(newTitleTable);
		// 设置每一列的宽度
		for(var i=0;i<tr.cells.length;i++){
			tr.cells[i].style.width=titleRow.cells[i].clientWidth;
			if(i%2==0){
				tr.cells[i].className="bt_info_odd";
			}else{
				tr.cells[i].className="bt_info_even";
			}
			// 设置是否显示
			if(titleRow.cells[i].isShow=="Hide"){
				tr.cells[i].style.display='none';
			}
		}
		
		document.getElementById("table_box").onscroll = resetNewTitleTablePos;
		
	}
	  /**
	 * 选择组织机构树
	 */
	 
	function showOrgTreePage(){
		var returnValue={
			fkValue:"",
			value:""
		}
		window.showModalDialog("<%=contextPath%>/common/selectOrgSub.jsp",returnValue,"");
		document.getElementById("s_own_org_name").value = returnValue.value;
		
		//var orgId = strs[1].split(":");
		document.getElementById("owning_org_id").value = returnValue.fkValue;
	}
	function toCopy(){
 		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
	     	return;
	    }
	    var temp = ids.split(",");
		var dev_ids = "";
		for(var i=0;i<temp.length;i++){
			if(dev_ids!=""){
				dev_ids += ","; 
			}
			dev_ids += "'"+temp[i]+"'";
		}
		var baseData;
		 baseData = jcdpCallService("DevInsSrv", "gettjCheckInfo", "mixId="+dev_ids);
		unProCount = baseData.devicerecMap.owning_sub_id;
		countSaveFalg= baseData.devicerecMap.name;
		if (unProCount == undefined) {
			return;
		}
		if(countSaveFalg>0)
			{
			alert("正在调剂的设备不能进行调剂!");
			return;
			}
		if(unProCount.indexOf(",")>0)
			{
				alert("请选择同一个物探处的设备进行调剂!");
				return;
			}
		
		if(confirm('确定要将设备进行调剂么?')){  
				popWindow("<%=contextPath%>/rm/dm/deviceXZAccount/devMixForxztjNewApply.jsp?ids="+dev_ids+"&orgId="+unProCount,'950:680'); 
				
		}
	}
</script>
</html>