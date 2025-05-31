<%@page contentType="text/html;charset=utf-8" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userId = user.getUserId();
	String userName = user.getUserName();
	String projectInfoNo = user.getProjectInfoNo();
	String str = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date()); 
	String projectType = user.getProjectType();
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
<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<title>设备新添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();getApplyTeam();getConUse()">
<form name="form" id="form" method="post" action="">
<input type="hidden" id="out_type" name="out_type" class="input_width"  value="4"/>
<input type="hidden" id="wz_type" name="wz_type" value=""></input>
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%;overflow: hidden;">
      <fieldSet style="margin-left:2px"><legend>基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
			<td class="inquire_item4">分包商:</td>
		 	<td class="inquire_form4">
		      	<input type="text" id="drawer" name="drawer" class="input_width"  value=""/>
			</td>
			</td>
       		<td class="inquire_item4"><font color="red">*</font>油料来源:</td>
		 	<td class="inquire_form4">
				<select id="oil_from" name="oil_from" class="select_width" onchange="showOilNum(this.value)">
		 		<option value=''>请选择</option>
		 		<option value='0'>油库</option>
		 		<option value='1'>加油站</option>
		 		</select>
			</td>
        </tr>
        <tr>
			<td class="inquire_item4"><font color="red">*</font>使用班组:</td>
		 	<td class="inquire_form4">
		 		<select id="team_id" name="team_id"  class="select_width">
				</select>
		 	</td>
       		<td class="inquire_item4"><font color="red">*</font>油料用途:</td>
		 	<td class="inquire_form4">
				<select id="use_user" name="use_user" class="select_width">
				</select>
			</td>
        </tr>
        <tr>
       	   <td class="inquire_item4"><font color="red">*</font>油品名称:</td>
		 	<td class="inquire_form4">
		 		<select id='oil_type' name='oil_type' class='select_width' style="width: 30%;" onchange="selectOilType()">
				        <option value='1'>车用汽油</option>
				 		<option value='2'>轻柴油</option>
				</select>
		 		<select id="wz_id" name="wz_id" class="select_width" style="width: 50%;"  onchange="ifOilNum()">
<!-- 		 		<option value=''>请选择</option>
		 		<option value='11000051822'>车用汽油 90#</option>
		 		<option value='10001037161'>车用汽油 92#</option>
		 		<option value='11004534305'>车用汽油 93#</option>
		 		<option value='10000189078'>车用汽油 95#</option>
		 		<option value='11000062340'>车用汽油 97#</option>
		 		<option value='11003426794'>轻柴油 0# 多元</option>
		 		<option value='11003308799'>轻柴油 RC-0℃</option>
		 		<option value='11003308800'>轻柴油 RC-10℃</option>
		 		<option value='11003308801'>轻柴油 RC-20℃</option>
		 		<option value='11003308804'>轻柴油 RC-30℃</option>
		 		<option value='11003308802'>轻柴油 RC-35℃</option>
		 		<option value='11003308803'>轻柴油 RC-50℃</option>
		 		<option value='11003308805'>轻柴油 RC+5</option>
-->
		 		</select>
		 	</td>
       		<td class="inquire_item6"><font color="red">*</font>加油时间:</td>
		<td class="inquire_item6"><input type="text" name="outmat_date" id="outmat_date"
			class="input_width"
			value="<%=str %>"  />
			<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(outmat_date,tributton1);" />
			</td>
        </tr>
         <tr>
       	   	<td class="inquire_item4"><font color="red">*</font>油品单价(升):</td>
		 	<td class="inquire_form4">
		 				<input type="text" id="actual_price" name="actual_price" class="input_width" onkeyup="changevalue()"  value=""/>
		 	</td>
<!-- 		<td class="inquire_item4">油品单位:</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="wz_priceik" name="wz_priceik" class="input_width"  value="升" readonly/>
			</td>
 -->       			
         	<td class="inquire_item4"><font color="red">*</font>使用数量(升):</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="oil_num" name="oil_num" class="input_width"  value="" onkeyup="changevalue()" readonly="readonly"/>
			</td>
        </tr>
         <tr>
       	   	<td class="inquire_item4">使用数量(吨):</td>
		 	<td class="inquire_form4">
		 				<input type="text" id="mat_num" name="mat_num" class="input_width"  value="" readonly/>
		 	</td>
         	<td class="inquire_item4">消耗金额:</td>
		 	<td class="inquire_form4">
				      	<input type="text" id="total_money" name="total_money" class="input_width"  value="" readonly/>
			</td>
        </tr>
      </table>
      </fieldSet>
      <div style="display:none" id="iDBody1">
      	<fileset>
	      	<table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      		<tr>
					<td class="inquire_item4">汽油库存量:</td>
					<td class=""><input type="text" id="total_ulp_num" name="total_ulp_num" class="input_width"  value="" readonly/></td>
					<td class="inquire_item4">柴油库存量:</td>
					<td class=""><input type="text" id="total_diesel_num" name="total_diesel_num" class="input_width"  value="" readonly/></td>
				</tr>
			</table>
		</fileset>
	 </div>
    </div>
    <div id="oper_div">
     	<span class="bc_btn" ><a id="subButton" href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
<div id="dialog-modal" title="正在执行" style="display:none;">
	请不要关闭
</div>
</form>
</body>
<script type="text/javascript"> 
cruConfig.contextPath =  "<%=contextPath%>";
selectOilType();
function submitInfo(){
	var oil_id = document.getElementById("wz_id").value;
	if(checkText()){
		return;
	};
	//判断是否油库，油库wz_type=0
	var oil_from = document.getElementById("oil_from").value;
	if(oil_from=="0"){
		document.getElementById("wz_type").value="0";
	}
	var form = document.getElementById("form");
	form.action="<%=contextPath%>/mat/singleproject/oilconother/addConsumption.srq";
	form.submit();
}

function checkText(){
	
	var re = /^[0-9]+(.[0-9]{1,4})?$/;
	var wz_id=document.getElementById("wz_id").value;
	var team_id=document.getElementById("team_id").value;
	var use_user=document.getElementById("use_user").value;
	var mat_num=document.getElementById("mat_num").value;
	var actual_price=document.getElementById("actual_price").value;
	var oil_from=document.getElementById("oil_from").value;
	var outmat_date = document.getElementById("outmat_date").value;
	var use_user = document.getElementById("use_user").value;
	var oil_type = document.getElementById("oil_type").value;
	if(oil_from==""){
		alert("油料来源不能为空！");
		return true;
	}
	if(team_id==""){
		alert("班组不能为空！");
		return true;
	}
	if(use_user==""){
		alert("油料用途不能为空！");
		return true;
	}
	if(wz_id==""){
		alert("油品名称不能为空！");
		return true;
	}
	if(outmat_date==""){
		alert("加油时间不能为空！");
		return true;
	}
	if(actual_price==""){
		alert("单价不能为空！");
		return true;
	}
	if(!re.test(actual_price)){
		alert("单价必须为数字，且大于0，小数位不能超过4位！");
		return true;
	}
	if(mat_num==""){
		alert("使用数量不能为空！");
		return true;
	}
	if(!re.test(mat_num)){
		alert("使用数量必须为数字，且大于0,小数位不能超过4位！");
		return true;
	}
	if(oil_from=="0"){
		if(oil_type=="1"){
			var total_ulp_num = document.getElementById("total_ulp_num").value;
			if(Number(mat_num)>Number(total_ulp_num)){
				alert("使用数量不能大于库存数量！");
				return true;
			}
		}else{
			var total_diesel_num = document.getElementById("total_diesel_num").value;
			if(Number(mat_num)>Number(total_diesel_num)){
				alert("使用数量不能大于库存数量！");
				return true;
			}
		}
	}
	return false;
}
function getConUse(){
	var selectObj = document.getElementById("use_user"); 
	document.getElementById("use_user").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	
	var retObj=jcdpCallService("MatItemSrv","queryConUse","");	
	var taskList = retObj.matInfo;
	for(var i =0; taskList!=null && i < taskList.length; i++){
		selectObj.add(new Option(taskList[i].lable,taskList[i].value),i+1);
	}
	}
function getApplyTeam(){
	var selectObj = document.getElementById("team_id"); 
	document.getElementById("team_id").innerHTML="";
	selectObj.add(new Option('请选择',""),0);

//	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeam","");	
	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","projectType=<%=projectType%>");
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}   	
	selectObj.add(new Option("储备","CB001"),applyTeamList.detailInfo.length+1);
	selectObj.add(new Option("配件","PJ001"),applyTeamList.detailInfo.length+2);
}
function changevalue(){
	var wzId = document.getElementById("wz_id").value;
	var oil_price = document.getElementById("actual_price").value;
	var oil_num = document.getElementById("oil_num").value;
	var oil_type = document.getElementById("oil_type").value;
	var mat_num=0;
	if(oil_num ==""){
		oil_num = 0;
		}
	if(oil_price ==""){
		oil_price = 0;
		}
	if(wzId == ""){
		mat_num=0;
		}
	else if(oil_type=="1"){
		mat_num=Math.round((oil_num*0.75/1000)*10000)/10000;
	}
	else{
		mat_num=Math.round((oil_num*0.86/1000)*10000)/10000;
	}
	document.getElementById("mat_num").value=mat_num;
	
	document.getElementById("total_money").value = Math.round((oil_num*oil_price)*1000)/1000;
}
function showOilNum(value){
	if(value=='0'){
		 document.getElementById('iDBody1').style.display = "";
		 //var querySql = "select a.coding_code_id, sum(a.stock_num) as stock_num from(select dd.coding_name, i.wz_id,i.coding_code_id, i.wz_name,i.wz_prickie,i.wz_price,t.stock_num,t.mat_num,t.out_num from (select aa.wz_id,aa.mat_num,bb.out_num,(aa.mat_num- case when bb.out_num is null then 0 else bb.out_num end) stock_num,i.coding_code_id,i.wz_name,i.wz_prickie,i.note,aa.project_info_no from ( select tid.project_info_no,tid.wz_id,sum(tid.mat_num) mat_num from gms_mat_teammat_invoices mti inner join gms_mat_teammat_info_detail tid on mti.invoices_id=tid.invoices_id and tid.bsflag='0' where mti.bsflag='0' and mti.project_info_no='<%=user.getProjectInfoNo()%>' and mti.if_input='0' group by tid.wz_id,tid.project_info_no )aa left join ( select tod.wz_id,sum(tod.mat_num) out_num from gms_mat_teammat_out mto inner join gms_mat_teammat_out_detail tod on mto.teammat_out_id=tod.teammat_out_id and tod.bsflag='0' where mto.bsflag='0' and mto.project_info_no='<%=user.getProjectInfoNo()%>' group by tod.wz_id ) bb on aa.wz_id=bb.wz_id inner join gms_mat_infomation i on aa.wz_id = i.wz_id and i.bsflag='0') t inner join gms_mat_infomation i on t.wz_id = i.wz_id and i.bsflag = '0' left join((select d.wz_id,s.coding_name from gms_mat_demand_plan_detail d  inner join(gms_mat_demand_plan_bz b inner join comm_coding_sort_detail s on b.plan_type = s.coding_code_id) on d.submite_number = b.submite_number where b.bsflag = '0' and b.project_info_no = '<%=user.getProjectInfoNo()%>' group by d.wz_id,s.coding_name) dd) on t.wz_id = dd.wz_id where t.stock_num > '0' and t.project_info_no = '<%=user.getProjectInfoNo()%>'and (i.coding_code_id like'07030102%'or i.coding_code_id like '07030301%')) a group by a.coding_code_id";
		 
		 var retObj=jcdpCallService("MatItemSrv","queryOilNum","");	
		 var taskList = retObj.matInfo;
			for(var i =0; taskList!=null && i < taskList.length; i++){
				if(taskList[i].codingCodeId =='07030102'){
					document.getElementById("total_ulp_num").value=taskList[i].stockNum;
					}
				if(taskList[i].codingCodeId =='07030301'){
					//document.getElementById("total_diesel_num").value=taskList[i].stockNum;
					$("#total_diesel_num").val(taskList[i].stockNum);
					}
			}
		}
	else{
		document.getElementById('iDBody1').style.display = "none";
			}
	
}


function ifOilNum(){
	var wz_id = document.getElementById("wz_id").value;
	var oil_from = document.getElementById("oil_from").value;
	var oil_type = document.getElementById("oil_type").value;
	if(wz_id!=null&&wz_id!=""){
		document.getElementById("oil_num").readOnly = false;
		if(oil_from!=null&&oil_from=="0"){
			var retObj=jcdpCallService("MatItemSrv","queryOilNum","wz_id="+wz_id);
			if(retObj.map!=null){
				var wz_price = retObj.map.wzPrice;	
				debugger;
				if(oil_type=="1"){
					document.getElementById("actual_price").value=Math.round(Number(wz_price)/1000*0.75*1000)/1000;
				}
				else{
//					mat_num=Math.round((oil_num*0.86/1000)*10000)/10000;
					document.getElementById("actual_price").value=Math.round(Number(wz_price)/1000*0.86*1000)/1000;
				}
			}
		}
	}else{
		document.getElementById("oil_num").readOnly = true;
	}
}

function selectOilType(){
	var oil_type = document.getElementById("oil_type").value;
	debugger;
	document.getElementById("wz_id").innerHTML = "";
	var retObj=jcdpCallService("MatItemSrv","selectOilType","oil_type="+oil_type);
	if(retObj.list!=null){
		for (var i = 0; i< retObj.list.length; i++) {
			document.getElementById("wz_id").options.add(new Option(retObj.list[i].wzName,retObj.list[i].wzId)); 
		}
	}
}

</script>
</html>

