<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dispose_method_id = request.getParameter("dispose_method_id");
    java.util.Calendar c=java.util.Calendar.getInstance();    
    java.text.SimpleDateFormat f=new java.text.SimpleDateFormat("yyyy-MM-dd");   
    String nowTime=f.format(c.getTime());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>报废处置申请录入</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
       <fieldSet style="margin:2px:padding:2px;"><legend>报废处置结果信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="dispose_method_id" id="dispose_method_id" type="hidden" value="<%=dispose_method_id%>" />
        <tr>
          <td class="inquire_item4">报废处置结果名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="dispose_method_name" id="dispose_method_name" class="input_width" type="text" value="" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">报废处置结果单号:</td>
          <td class="inquire_form4">
          	<input name="dispose_method_no" id="dispose_method_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
          <td class="inquire_item4">操作时间:</td>
          <td class="inquire_form4">
          	<input name="check_date" id="check_date" class="input_width" type="text"  readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">操作单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="org_id" class="input_width" type="hidden"  />
          	<input name="org_name" id="org_name" class="input_width" type="text"    readonly/>
          </td>
          <td class="inquire_item4">操作人:</td>
          <td class="inquire_form4">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden"   />
          	<input name="employee_name" id="employee_name" class="input_width" type="text"   readonly/>
          </td>
        </tr>
      </table>    
      </fieldSet>
        <fieldSet style="margin-left:2px"><legend>报废处置详细信息</legend>
      	<input name="colnum" id="colnum" class="input_width" type="hidden" value="" readonly/>
      	<input name="parmeter" id="parmeter" type="hidden" value=""/>
      	<input name="colnum_1" id="colnum_1" class="input_width" type="hidden" value="" readonly/>
	  	  <div>
	  	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	  		<tr>
	  	  			<td>&nbsp;</td>
	  	  			<td class="ali_cdn_name" ><a href="javascript:downloadModel('dispose_result_model','设备报废处置结果明细')">处置结果模板</a></td>
			    	<auth:ListButton functionId="" css="dr" event="onclick='excelDataAdd()'" title="导入设备"></auth:ListButton>
	  	  			<auth:ListButton functionId="" css="zj" event="onclick='addRows()'" title="添加设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delRows()'" title="删除设备"></auth:ListButton>
	  	  		</tr>
	  	  	</table>
	  	  </div>
		  <div style="overflow:auto">
			  <table style="width:107.9%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" ><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
					<td class="bt_info_even">设备名称</td>
					<td class="bt_info_odd" >规格型号</td>
					<td class="bt_info_even">设备编号</td>
					<td class="bt_info_odd">原值</td>
					<td class="bt_info_even">净值</td>
					<td class="bt_info_odd">报废日期</td>
					<td class="bt_info_even">处置方式</td>
					<td class="bt_info_odd">公文编号</td>
				</tr>
				</table>
			   <div style="height:190px;">
		      	<table style="width:107.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable0" name="processtable0" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
      </fieldSet>
       <fieldSet style="margin:2px:padding:2px;"><legend>报废处置明细</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      <tr>
       	<td class="inquire_item4"><font color="red">*</font>处置时间:</td>
	    	<td class="inquire_form4"><input name="dispose_date" id="dispose_date" type="text" class="input_width" value="" readonly="readonly" />
	    		<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="calDateSelector(dispose_date,cal_button7);" 
	    		src="<%=contextPath %>/images/calendar.gif" /></td>
	   </tr>
	    		<tr>
	    		<td class="inquire_item4"><font color="red">*</font>处置地点:</td>
	    	 	<td class="inquire_item4" colspan="4">
	    			<select id="province" name="province" class="select_width" style="width: 30%;" onchange='copyexpert()'> 
					<option value="安徽省">安徽省</option>
					<option value="澳门特别行政区">澳门特别行政区</option>
					<option value="北京市">北京市</option>
					<option value="重庆市">重庆市</option>
					<option value="福建省">福建省</option>
					<option value="甘肃省">甘肃省</option>
					<option value="广东省">广东省</option>
					<option value="广西壮族自治区">广西壮族自治区</option>
					<option value="贵州省">贵州省</option>
					<option value="海南省">海南省</option>
					<option value="河北省">河北省</option>
					<option value="黑龙江省">黑龙江省</option>
					<option value="河南省">河南省</option>
					<option value="湖北省">湖北省</option>
					<option value="湖南省">湖南省</option>
					<option value="江苏省">江苏省</option>
					<option value="江西省">江西省</option>
					<option value="吉林省">吉林省</option>
					<option value="辽宁省">辽宁省</option>
					<option value="内蒙古">内蒙古</option>
					<option value="宁夏回族自治区">宁夏回族自治区</option>
					<option value="青海省">青海省</option>
					<option value="陕西省">陕西省</option>
					<option value="山东省">山东省</option>
					<option value="上海市">上海市</option>
					<option value="山西省">山西省</option>
					<option value="四川省">四川省</option>
					<option value="台湾">台湾</option>
					<option value="天津市">天津市</option>
					<option value="香港特别行政区">香港特别行政区</option>
					<option value="新疆维吾尔族自治区">新疆维吾尔族自治区</option>
					<option value="西藏自治区">西藏自治区</option>
					<option value="云南省">云南省</option>
					<option value="浙江省">浙江省</option>
				</select>&nbsp;&nbsp;&nbsp;&nbsp;
				<input id="dispose_place" name="dispose_place" class="input_width" type="text" style="width: 60%; float: none;margin-bottom: 7px;"/>
			</td>
				</tr>
				<tr >
					<td class="bt_info_odd">处置方式</td>
					<td class="bt_info_odd">拍卖(变现)</td>
					<td class="bt_info_odd">交回公司</td>
					<td class="bt_info_odd">其他</td>
					<td class="bt_info_odd">合计</td>
				</tr>
				<tr>
				<td class="inquire_item4">处置数量(台、套)</td>
				<td class="inquire_item4">	<input id="dispose_paimai_num" name="dispose_paimai_num" class="input_width" type="text" value="" readonly></td>
					<td class="inquire_item4">	<input id="dispose_company_num" name="dispose_company_num" class="input_width" type="text" value="" readonly></td>
						<td class="inquire_item4">	<input id="dispose_other_num" name="dispose_other_num" class="input_width" type="text" value="" readonly></td>
							<td class="inquire_item4">	<input id="dispose_sum_num" name="dispose_sum_num" class="input_width" type="text" value="" readonly></td>
				</tr>
				<tr>
				<td class="inquire_item4">处置金额(元) </td>
				<td class="inquire_item4">	<input id="dispose_paimai_money" name="dispose_paimai_money" class="input_width" type="text" value="" readonly></td>
				<td class="inquire_item4">	<input id="dispose_company_money" name="dispose_company_money" class="input_width" type="text" value="" readonly></td>
				<td class="inquire_item4">	<input id="dispose_other_money" name="dispose_other_money" class="input_width" type="text" value="" readonly></td>
				<td class="inquire_item4">	<input id="dispose_sum_money" name="dispose_sum_money" class="input_width" type="text" value="" readonly></td>
				</tr>
		</table>
        </tr>
      </table>    
      </fieldSet>
	   <fieldset><legend>监督人员</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tbody id="jianduer_body" id="OPERATOR_body">
		  		<tr id='tr1' name='tr1' seq='1'>
			  		<td class="inquire_item4">监督人员</td>
					<td class='inquire_form4'>
						<input type='hidden' id='jianduer_id' name='jianduer_id'/>
						<input type='text' readonly='readonly' id='jianduer_name' name='jianduer_name'></input>
						<img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='selectPerson(this)'/>
					 </td>
				 </tr>
			</tbody>
	  	</table>
	  </fieldset>
	  	  <fieldset><legend>附件</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tr >
				<td>&nbsp;</td>
				<td colspan="1" ><span style="font-size:12px;"> 添加附件</span></td>
				<td class='ali_btn' colspan="2"><span class='zj'><a href='javascript:void(0);' onclick='insertTr("file_table6")'  title='添加'></a></span></td>
			</tr>
		</table>
			<table id="file_table6" border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"></table>
        </tr>
		</table>
        </tr>
			</tbody>
	  	</table>
	  </fieldset>
	</div>
    </div>
    <div id="oper_div">
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
	
});
	function saveInfo(){
		if($("#dispose_method_name").val()=="")
			{
			alert("报废处置结果名称不能为空!");
			return;
			}
			var wrong="";
		//保留的行信息
		var count = 0;
		var result= 0;
		var line_infos;
		var idinfos ;
		var text1="";
		$("input[type='checkbox'][name='idinfo']").each(function(){
			text1=text1+","+this.id;
			if(this.checked){
				if(count == 0){
					line_infos = this.id;
					idinfos = this.value;
				}else{
					line_infos += "~"+this.id;
					idinfos += "~"+this.value;
				}
				count++;
			}
			result++;
		});
		if(count == 0){
			alert('请选择设备明细信息！');
			return;
		}
		$("#colnum").val(result-1);
		if (text1.substr(0,1)==',') text1=text1.substr(1);
		$("#parmeter").val(text1);
		var selectedlines = line_infos.split("~");
		var wronglineinfos = "";
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#detdev_ci_code"+selectedlines[index]).val();
			if(valueinfo == ""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
		if(wronglineinfos!=""){
			alert("请选择第"+wronglineinfos+"行设备明细信息!");
			return;
		}
		if($("#dispose_date").val()=="")
		{
			alert("处置日期不能为空!");
			return;
		}
		if($("#dispose_placce").val()=="")
		{
			alert("处置地点不能为空!");
			return;
		}
		if(optnum == 0)
		{
			alert("请添加处置人员信息!");
			return;
		}
		for(var num=1;num<=optnum;num++)
			{
			if($("#name_"+num+"").val()== undefined || $("#name_"+num+"").val()== "" || $("#org_name_"+num+"").val()== "" ||$("#org_name_"+num+"").val()== undefined || $("#position_"+num+"").val()== "" ||$("#position_"+num+"").val()== undefined )
				{
				if(num == 1){
					wrong += num;
				}else{
					wrong += ","+num;
				}
				
				}
		}
		if(wrong!="")
		{
			if (wrong.substr(0,1)==',') wrong=wrong.substr(1);
			alert("参与处置人员信息,第"+wrong+"行数据不能为空!");
			return;
		}
		$("#colnum_1").val(optnum);
		$("#dispose_method_no").val("");
		document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/addDisposeResult.srq";
		document.getElementById("form1").submit();
	}
	/**设备报废处置明细模板方法**/
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/dmsManager/common/download.jsp?path=/dmsManager/scrape/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	/**导入设备报废处置明细方法**/
	function excelDataAdd(){
		var nodes= window.showModalDialog('<%=contextPath%>/dmsManager/scrape/disResExcelAdd.jsp','ceshi','dialogHeight=10;dialogWidth=45;resizable=no;menuba=no;resizable=no');
		//{"dev_model":"BPS-TP","dev_name":"二次定位传感器","scrape_detailed_id":"8ad899dc5141cb3c015141cdf56d0006","set_value":"2787","scrape_date":"2015/11/26","dev_type":"0154013000001"}
		/* for(var a= 0;a<nodes.length;a++){
			alert(nodes[a]);
			alert(nodes[a].scrape_detailed_id);
			alert(nodes[a].dev_name);
			alert(nodes[a].dev_model);
			alert(nodes[a].dev_type);
			alert(nodes[a].set_value);
			alert(nodes[a].scrape_date);
		} */
		
		refreshDataDync(nodes);
	}
	function refreshDataDync(nodes){
		for (var tr_id = 0; tr_id< nodes.length; tr_id++) {
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<input name='detdev_ci_code"+tr_id+"' id='detdev_ci_code"+tr_id+"' value='"+nodes[tr_id].scrape_detailed_id+"' size='16'  type='hidden' />";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>"; 
			innerhtml += "<td width='27%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='"+nodes[tr_id].dev_name+"' size='15' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePage("+tr_id+")' />";
			innerhtml += "</td>";
			innerhtml += "<td width='17%'><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='"+nodes[tr_id].dev_model+"' size='14'  type='text' readonly /></td>";
			innerhtml += "<td width='17%'><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='"+nodes[tr_id].dev_type+"' size='12' type='text' readonly/>";
			innerhtml += "<td ><input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='"+nodes[tr_id].asset_value+"' size='11' type='text' readonly/></td>";
			innerhtml += "<td ><input name='net_value"+tr_id+"' id='net_value"+tr_id+"' value='"+nodes[tr_id].net_value+"' size='11' type='text' readonly/></td>";
			innerhtml += "<td ><input name='scrape_date"+tr_id+"' id='scrape_date"+tr_id+"' value='"+nodes[tr_id].scrape_date+"' size='9' type='text' readonly/></td>";
			if(nodes[tr_id].dispose_method_flag==0){
				innerhtml += "<td width='17%'><select name='dispose_method_flag"+tr_id+"' id='dispose_method_flag"+tr_id+"' onchange='checkInfoList()'><option  value='0' selected >拍卖</option><option value='1'>交回公司</option><option value='2'>其他</option></select></td>";
			}
			if(nodes[tr_id].dispose_method_flag==1){
				innerhtml += "<td width='17%'><select name='dispose_method_flag"+tr_id+"' id='dispose_method_flag"+tr_id+"' onchange='checkInfoList()'><option  value='0'  >拍卖</option><option value='1' selected>交回公司</option><option value='2'>其他</option></select></td>";
			}
			if(nodes[tr_id].dispose_method_flag==2){
				innerhtml += "<td width='17%'><select name='dispose_method_flag"+tr_id+"' id='dispose_method_flag"+tr_id+"' onchange='checkInfoList()'><option  value='0'  >拍卖</option><option value='1' >交回公司</option><option value='2' selected>其他</option></select></td>";
			}
			innerhtml += "<td width='9%'><input name='batch_number"+tr_id+"' id='batch_number"+tr_id+"'  size='11'  type='text' value='"+nodes[tr_id].batch_number+"'  /></td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
			checkInfoList();
		}
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	}
	function addRows(value){
		tr_id = $("#processtable0>tr:last").attr("id");
		if(tr_id != undefined){
			tr_id = parseInt(tr_id.substr(2,1),10);
		}
		if(tr_id == undefined){
			tr_id = 0;
		}else{
			tr_id = tr_id+1;
		}
		$("#colnum").val(tr_id);
		//动态新增表格
		var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
		innerhtml += "<input name='detdev_ci_code"+tr_id+"' id='detdev_ci_code"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
		innerhtml += "<td width='3%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:12px' value='' size='12' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePage("+tr_id+")' />";
		innerhtml += "</td>"
		innerhtml += "<td ><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='' size='10'  type='text' readonly /></td>";
		innerhtml += "<td ><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='' size='11' type='text' readonly/>";
		innerhtml += "<td ><input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='' size='9' type='text' readonly/></td>";
		innerhtml += "<td ><input name='net_value"+tr_id+"' id='net_value"+tr_id+"' value='' size='9' type='text' readonly/></td>";
		innerhtml += "<td ><input name='scrape_date"+tr_id+"' id='scrape_date"+tr_id+"' value='' size='9' type='text' readonly/></td>";
		innerhtml += "<td width='17%'><select name='dispose_method_flag"+tr_id+"' id='dispose_method_flag"+tr_id+"' onchange='checkInfoList()'><option  value='0'>拍卖</option><option value='1'>交回收公司</option><option value='2'>其他</option></select></td>";
		innerhtml += "<td ><input name='batch_number"+tr_id+"' id='batch_number"+tr_id+"' value='' size='11'  type='text'  /></td>";
		innerhtml += "</tr>";
		$("#processtable0").append(innerhtml);
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
};
function delRows(){
	$("input[name='idinfo']").each(function(){
		if(this.checked == true){
			$('#tr'+this.id,"#processtable0").remove();
		}
	});
	$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
	$("#processtable0>tr:odd>td:even").addClass("odd_even");
	$("#processtable0>tr:even>td:odd").addClass("even_odd");
	$("#processtable0>tr:even>td:even").addClass("even_even");
};

function showDevCodePage(index){
	var obj = new Object();
	var pageselectedstr = null;
	var checkstr = 0;
	$("input[name^='detdev_ci_code'][type='hidden']").each(function(i){
		if(this.value!=null&&this.value!=''){
			if(checkstr == 0){
				pageselectedstr = "'"+this.value;
			}else{
				pageselectedstr += "','"+this.value;
			}
			checkstr++;
		}
	});
	if(pageselectedstr!=null){
		pageselectedstr = pageselectedstr + "'";
	}
	obj.pageselectedstr = pageselectedstr;
	var returnval = window.showModalDialog("<%=contextPath%>/dmsManager/scrape/selectScrapeList.jsp?handleFlag=0",obj,"dialogWidth=950px;dialogHeight=480px");

	//返回信息是  类别id + 设备编码 + 设备名称 + 规格型号
	if(returnval!=undefined){
		var returnvals = returnval.split("~",-1);
		$("#dev_name"+index).val(returnvals[1]);
		$("#dev_model"+index).val(returnvals[3]);
		$("#detdev_ci_code"+index).val(returnvals[0]);
		$("#dev_type"+index).val(returnvals[2]);
		$("#asset_value"+index).val(returnvals[4]);
		$("#net_value"+index).val(returnvals[7]);
		$("#scrape_date"+index).val(returnvals[5]);
		$("#bak"+index).val(returnvals[6]);
		checkInfoList();
	}
}
function copyexpert()
{
	$("#dispose_place").val($("#province").val());
}

 function checkInfoList ()
 {
//拍卖处置数量
var paimainum=0;
//拍卖处置金额
var paimaimoney=0;
//交回公司数量
var companynum=0;
//交回公司金额
var companymoney=0;
//其他处置数量
var othernum=0;
//其他处置金额
var othermoney=0;
//合计数量
var sumnum=0;
//合计金额
var summoney=0;
$("input[type='checkbox'][name='idinfo']").each(function(){
var dispose_method_flag=$("#dispose_method_flag"+this.id).val();
if(dispose_method_flag == 0)
{
	paimainum++;
	paimaimoney=parseInt(paimaimoney)+parseInt($("#asset_value"+this.id).val());
	
}
if(dispose_method_flag == 1)
{
	companynum++;
	companymoney=parseInt(companymoney)+parseInt($("#asset_value"+this.id).val());
}
if(dispose_method_flag == 2)
{
	othernum++;
	othermoney=parseInt(othermoney)+parseInt($("#asset_value"+this.id).val());
}
			
});
$("#dispose_paimai_num").val(paimainum);
$("#dispose_paimai_money").val(paimaimoney);
$("#dispose_company_num").val(companynum);
$("#dispose_company_money").val(companymoney);
$("#dispose_other_num").val(othernum);
$("#dispose_other_money").val(othermoney);
sumnum=parseInt(paimainum)+parseInt(companynum)+parseInt(othernum);
summoney=parseInt(paimaimoney)+parseInt(companymoney)+parseInt(othermoney);
$("#dispose_sum_num").val(sumnum);
$("#dispose_sum_money").val(summoney);

}

function refreshData(){
	var baseData;
	if('<%=dispose_method_id%>'!='null'){
		 baseData = jcdpCallService("ScrapeSrv", "getDisposeMethodInfo", "dispose_method_id="+$("#dispose_method_id").val());
		$("#dispose_method_no").val(baseData.deviceMap.dispose_method_no);
		$("#dispose_method_name").val(baseData.deviceMap.dispose_method_name);
		$("#dispose_date").val(baseData.deviceMap.dispose_date);
		$("#dispose_place").val(baseData.deviceMap.dispose_place);
		$("#province").val(baseData.deviceMap.province);
		$("#jianduer_id").val(baseData.deviceMap.jianduer_id);
		$("#jianduer_name").val(baseData.deviceMap.jianduer_name);
		$("#dispose_paimai_num").val(baseData.deviceMap.paimainum);
		$("#dispose_paimai_money").val(baseData.deviceMap.paimaimoney);
		$("#dispose_company_num").val(baseData.deviceMap.companynum);
		$("#dispose_company_money").val(baseData.deviceMap.companymoney);
		$("#dispose_other_num").val(baseData.deviceMap.othernum);
		$("#dispose_other_money").val(baseData.deviceMap.othermoney);
		$("#dispose_sum_num").val(baseData.deviceMap.sumnum);
		$("#dispose_sum_money").val(baseData.deviceMap.summoney);
		
		$("#employee_name").val(baseData.deviceMap.employee_name);
		$("#org_name").val(baseData.deviceMap.org_name);
		$("#check_date").val(baseData.deviceMap.check_date);
		if(baseData.datas!=null)
		{
		for (var tr_id = 0; tr_id< baseData.datas.length; tr_id++) {
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<input name='detdev_ci_code"+tr_id+"' id='detdev_ci_code"+tr_id+"' value='"+baseData.datas[tr_id].scrape_detailed_id+"' size='16'  type='hidden' />";
			innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
			innerhtml += "<td width='4%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='"+baseData.datas[tr_id].dev_name+"' size='12' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePage("+tr_id+")' />";
			innerhtml += "</td>"
			innerhtml += "<td ><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='"+baseData.datas[tr_id].dev_model+"' size='10'  type='text' readonly /></td>";
			innerhtml += "<td ><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='"+baseData.datas[tr_id].dev_type+"' size='11' type='text' readonly/>";
			innerhtml += "<td ><input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='"+baseData.datas[tr_id].asset_value+"' size='9' type='text' readonly/></td>";
			innerhtml += "<td ><input name='net_value"+tr_id+"' id='net_value"+tr_id+"' value='"+baseData.datas[tr_id].net_value+"' size='9' type='text' readonly/></td>";
			innerhtml += "<td ><input name='scrape_date"+tr_id+"' id='scrape_date"+tr_id+"' value='"+baseData.datas[tr_id].scrape_date+"' size='9' type='text' readonly/></td>";
			if(baseData.datas[tr_id].dispose_method_flag==0)
			{
			innerhtml += "<td width='17%'><select name='dispose_method_flag"+tr_id+"' id='dispose_method_flag"+tr_id+"' onchange='checkInfoList()'><option  value='0' selected >拍卖</option><option value='1'>交回公司</option><option value='2'>其他</option></select></td>";
			}
			if(baseData.datas[tr_id].dispose_method_flag==1)
			{
			innerhtml += "<td width='17%'><select name='dispose_method_flag"+tr_id+"' id='dispose_method_flag"+tr_id+"' onchange='checkInfoList()'><option  value='0'  >拍卖</option><option value='1' selected>交回公司</option><option value='2'>其他</option></select></td>";
			}
			if(baseData.datas[tr_id].dispose_method_flag==2)
			{
			innerhtml += "<td width='17%'><select name='dispose_method_flag"+tr_id+"' id='dispose_method_flag"+tr_id+"' onchange='checkInfoList()'><option  value='0'  >拍卖</option><option value='1' >交回公司</option><option value='2' selected>其他</option></select></td>";
			}
			innerhtml += "<td width='9%'><input name='batch_number"+tr_id+"' id='batch_number"+tr_id+"'  size='11'  type='text' value='"+baseData.datas[tr_id].batch_number+"'  /></td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
			
			}
	
		$("#colnum").val(baseData.datas.length);
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
		}
		if(baseData.fdata!=null)
		{
	
		$("#file_table6").empty();
		for (var tr_id = 1; tr_id<=baseData.fdata.length; tr_id++) {
			insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id);
		}
		}
		}
	//checkInfoList();
}
//插入行
function insertTr(obj){
var tmp=new Date().getTime();
	$("#"+obj+"").append(
		"<tr class='file_tr'>"+
			"<td class='inquire_item5'>附件：</td>"+
  			"<td class='inquire_form5'><input type='file' name='doc_content__"+tmp+"' id='doc_content__"+tmp+"' onchange='getFileInfo(this)' class='input_width'/></td>"+
			"<td class='inquire_item5'>附件名：</td>"+
			"<td class='inquire_form5'><input type='text' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"' class='input_width' /><input type='hidden' id='doc_type__"+tmp+"' name='doc_type__"+tmp+"'></td>"+
			"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInput(this)'  title='删除'></a></span></td>"+
		"</tr>"	
	);

}
//删除行
function deleteInput(item){
	$(item).parent().parent().parent().remove();
	checkInfoList();
	
}
function getFileInfo(item){
	var docPath = $(item).val();
	var order = $(item).attr("id").split("__")[1];
	var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
	var docTitle = docName.substring(0,docName.lastIndexOf("\."));
	$("#doc_name__"+order).val(docTitle);//文件name
	
}

	//插入文件
function insertFile(name,type,id){
	
		$("#file_table6").append(
					"<tr>"+
					"<td class='inquire_form5'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5'><span class='sc'><a href='javascript:void(0);' onclick=deleteFile(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
}
//删除文件
	function deleteFile(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			var tmp=new Date().getTime();
			$("#file_table6").append("<tr><td class='inquire_item6'>附件:</td>"+
	    			"<td class='inquire_form5'><input type='file' name='doc_content__"+tmp+"' id='doc_content__"+tmp+"' onchange='getFileInfo(this)' class='input_width'/></td>"+
	    			"<td class='inquire_form5'>附件名：</td>"+
					"<td class='inquire_form5'><input type='text' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"' class='input_width' /><input type='hidden' id='doc_type__"+tmp+"' name='doc_type__"+tmp+"'></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInput(this)'  title='删除'></a></span></td></tr>");
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
		}
	}
	//选择申请人
	function selectPerson(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/dmsManager/scrape/selectEmployee.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    		document.getElementById("jianduer_id").value = teamInfo.fkValue;
	 	        document.getElementById("jianduer_name").value = teamInfo.value;
	    }
	}
</script>
</html>

