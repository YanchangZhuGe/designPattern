<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String  mixId=request.getParameter("mixId");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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

<script type="text/javascript" src="<%=contextPath %>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/aside.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/listTable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 

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
<title>变更申请单-验收</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
	<input type='hidden' name='selectWzId' id='selectWzId'/>
	<input type='hidden' name='dev_move_id' id='dev_move_id' value="<%=mixId%>"/>
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend>变更申请基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4" >变更单号:</td>
          <td class="inquire_form4" >
          	<input name="move_no" id="move_no" class="input_width" type="text"  value="保存后自动生成..." readonly/>
          </td>
          <td class="inquire_item4" ><font color=red>*</font>变更单名称:</td>
          <td class="inquire_form4" >
          	<input name="move_name" id="move_name" class="input_width" type="text"  value="" readonly/>
          </td>
        </tr>
        <tr>
         <td class="inquire_item4" ><font color=red>*</font>转出单位:</td>
          <td class="inquire_form4" >
          	<input name="out_org_name" id="out_org_name" class="input_width" type="text"  value="" readonly/>
          	<input name="out_org_id" id="out_org_id" class="input_width" type="hidden"  value="" />
          </td>
           <td class="inquire_item4" ><font color=red>*</font>转入单位:</td>
          <td class="inquire_form4" >
          	<input name="in_org_name" id="in_org_name" class="input_width" type="text"  value="" readonly/>
          	<input name="in_org_id" id="in_org_id" class="input_width" type="hidden"  value="" />
          </td>
        </tr>
        <tr>
        </tr>
        <tr>
          <td class="inquire_item4">调剂人</td>
          <td class="inquire_form4">
          	<input name="opertor_id_name" id="opertor_id_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          	<input name="opertor_id" id="opertor_id" class="input_width" value="<%=user.getEmpId()%>" type="hidden" />
        	<td class="inquire_item4"><font color=red>*</font>&nbsp;调剂时间:</td>
          <td class="inquire_form4">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="" readonly/>
          </td>
        </td>
        </tr>
      </table>
      </fieldSet>
    <div style="overflow: auto">
				</div>
	  <fieldSet style="margin-left:2px"><legend>设备接收</legend>
		  <div style="height:220px;overflow:auto">
			  <table style="width:120.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width="4%"><input type='checkbox' id='idinfo' name='idinfo'/></td>
					<td class="bt_info_even" width="5%">设备名称</td>
					<td class="bt_info_odd" width="5%">规格型号</td>
					<td class="bt_info_even" width="5%">转出完好</td>
					<td class="bt_info_odd" width="5%">接收完好</td>
					<td class="bt_info_even" width="5%">转出待报废</td>
					<td class="bt_info_odd" width="5%">接收待报废</td>
					<td class="bt_info_even" width="5%">转出待修</td>
					<td class="bt_info_odd" width="5%">接收出待修</td>
					<td class="bt_info_even" width="5%">转出在修</td>
					<td class="bt_info_odd" width="5%">接收在修</td>
					<td class="bt_info_even" width="5%">转出毁损</td>
					<td class="bt_info_odd" width="5%">接收毁损</td>
					<td class="bt_info_odd" width="5%">接收盘亏</td>
				</tr>
				<tbody id="processtable0" name="processtable0" >
			   		</tbody>
			   </table>
	       </div>
      </fieldSet>
    </div>
    <div id="oper_div">
    	<span class="js_btn"><a href="#" onclick="submitInfo('0')"></a></span>
        <span class="th_btn"><a href="#" onclick="submitInfo('1')"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function submitInfo(info){
		var in_org_id=$("#in_org_id").val();
		var out_org_id=$("#out_org_id").val();
		var move_name=$("#move_name").val();
		var apply_date=$("#apply_date").val();
		if( in_org_id==""||move_name==""||apply_date==""||out_org_id=="")
		{
			alert("请录入变更申请基本信息！");
			return;
		}
		//保留的行信息
		var count = 0;
		var line_infos;
		$("input[type='checkbox'][name='idinfo']").each(function(){
			if(this.checked){
				if(count == 0){
					line_infos = this.id;
				}else{
					line_infos += "~"+this.id;
				}
				count++;
			}
		});
		if(count == 0){
			alert('请录入变更设备信息！');
			return;
		}
		var selectedlines = line_infos.split("~");
		var wronglineinfos = "";
		var allsum = "";
		for(var index=0;index<selectedlines.length;index++){
			var wanhao_num = $("#rwanhao_num"+selectedlines[index]).val();
			var touseless_num = $("#rtouseless_num"+selectedlines[index]).val();
			var weixiu_num = $("#rweixiu_num"+selectedlines[index]).val();
			var zaixiu_num = $("#rzaixiu_num"+selectedlines[index]).val();
			var huisun_num = $("#rhuisun_num"+selectedlines[index]).val();
			var pankui_num = $("#rpankui_num"+selectedlines[index]).val();
			var sum=parseInt(wanhao_num)+parseInt(touseless_num)+parseInt(weixiu_num)+parseInt(zaixiu_num)+parseInt(pankui_num)+parseInt(huisun_num);
			var sum1=$("#allnum"+selectedlines[index]).val();
			if(wanhao_num == "" || touseless_num == "" || weixiu_num == "" || zaixiu_num == "" || huisun_num == ""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
			if(sum!=sum1){
				if(index == 0){
					allsum += (parseInt(selectedlines[index])+1);
				}else{
					allsum += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
		if(wronglineinfos!=""){
			alert("请设置第"+wronglineinfos+"行明细变更设备明细!");
			return;
		}
		if(allsum!=""){
			alert("第"+allsum+"行当前接收数量不等于转出总数量!");
			return;
		}
			if(confirm("提交后不能修改删除,是否提交?")){
				document.getElementById("form1").action = "<%=contextPath%>/rm/dm/receivemoveInfo.srq?count="+count+"&line_infos="+line_infos+"&info="+info;
				document.getElementById("form1").submit();
		}
	}
	var mixId='<%=mixId%>';
	function refreshData()
	{
		if(mixId!='null')
		{
			var baseData;
			 baseData = jcdpCallService("DevProSrv", "getmoveAppsInfo", "mixId="+mixId);
				if(baseData.devMap!=null)
					{
						document.getElementById("move_no").value=baseData.devMap.moveapp_no ;
						document.getElementById("move_name").value=baseData.devMap.moveapp_name ;
						document.getElementById("in_org_name").value=baseData.devMap.inorgname;
						document.getElementById("in_org_id").value=baseData.devMap.in_org_id;
						document.getElementById("out_org_name").value=baseData.devMap.outorgname;
						document.getElementById("out_org_id").value=baseData.devMap.out_org_id;
						document.getElementById("apply_date").value=baseData.devMap.apply_date;
					}
				
				
				if(baseData.datas!=null)
				{
					//通过查询结果动态填充使用情况select;
					for (var i=0; i< baseData.datas.length; i++) {
						tr_id=$("#processtable0 tr").length;
						var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
						innerhtml += "<input name='allnum"+tr_id+"' id='allnum"+tr_id+"'   type='hidden'    value='"+baseData.datas[i].allnum+"'  />";
						innerhtml += "<input name='dev_acc_id"+tr_id+"' id='dev_acc_id"+tr_id+"' value='"+baseData.datas[i].dev_acc_id+"' size='8'  type='hidden' />";
						innerhtml += "<input name='device_id"+tr_id+"' id='device_id"+tr_id+"' value='"+baseData.datas[i].device_id+"' size='8'  type='hidden' />";
						innerhtml += "<input name='move_det_id"+tr_id+"' id='move_det_id"+tr_id+"' value='"+baseData.datas[i].move_det_id+"' size='8'  type='hidden' />";
						innerhtml += "<input name='devid' id='"+baseData.datas[i].dev_acc_id+"' size='8'  type='hidden' />";
						innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
						innerhtml += "<td><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"'   size='8' value='"+baseData.datas[i].dev_name+"' readonly /></td>";
						innerhtml += "<td><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"'   size='8' value='"+baseData.datas[i].dev_model+"' readonly /></td>";
						innerhtml += "<td><input name='wanhao_num"+tr_id+"' id='wanhao_num"+tr_id+"'   size='8' value='"+baseData.datas[i].wanhao_num+"' readonly /></td>";
						innerhtml += "<td><input name='rwanhao_num"+tr_id+"' id='rwanhao_num"+tr_id+"'   size='8' value='"+baseData.datas[i].wanhao_num+"' onkeyup='techAutoCal(this,"+tr_id+")'  />";
						innerhtml += "<td><input name='touseless_num"+tr_id+"' id='touseless_num"+tr_id+"'   size='8' value='"+baseData.datas[i].rtouseless_num+"' readonly /></td>";
						innerhtml += "<td><input name='rtouseless_num"+tr_id+"' id='rtouseless_num"+tr_id+"'   size='8' value='"+baseData.datas[i].rtouseless_num+"'  onkeyup='techAutoCal(this,"+tr_id+")' /></td>";
						innerhtml += "<td><input name='weixiu_num"+tr_id+"' id='weixiu_num"+tr_id+"'  value='"+baseData.datas[i].weixiu_num+"' size='8' readonly /></td>";
						innerhtml += "<td><input name='rweixiu_num"+tr_id+"' id='rweixiu_num"+tr_id+"' value='"+baseData.datas[i].weixiu_num+"' size='8'  onkeyup='techAutoCal(this,"+tr_id+")' /></td>";
						innerhtml += "<td><input name='zaixiu_num"+tr_id+"' id='zaixiu_num"+tr_id+"'  value='"+baseData.datas[i].zaixiu_num+"' size='8' readonly /></td>";
						innerhtml += "<td><input name='rzaixiu_num"+tr_id+"' id='rzaixiu_num"+tr_id+"' value='"+baseData.datas[i].zaixiu_num+"' size='8'  onkeyup='techAutoCal(this,"+tr_id+")'/></td>";
						innerhtml += "<td><input name='huisun_num"+tr_id+"' id='huisun_num"+tr_id+"'  value='"+baseData.datas[i].huisun_num+"' size='8' readonly /></td>";
						innerhtml += "<td><input name='rhuisun_num"+tr_id+"' id='rhuisun_num"+tr_id+"' value='"+baseData.datas[i].huisun_num+"' size='8' onkeyup='techAutoCal(this,"+tr_id+")' /></td>";
						innerhtml += "<td><input name='rpankui_num"+tr_id+"' id='rpankui_num"+tr_id+"' value='0'  onkeyup='techAutoCal(this,"+tr_id+")' size='8'/></td>";
						$("#processtable0").append(innerhtml);
						}
					$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
					$("#processtable0>tr:odd>td:even").addClass("odd_even");
					$("#processtable0>tr:even>td:odd").addClass("even_odd");
					$("#processtable0>tr:even>td:even").addClass("even_even");
					}
				
		}
		
	}
	
	function techAutoCal(obj,index){
		var rname=obj.name;
		var name=rname.substr(1,rname.length);
		var mname='m'+name;
		var value = obj.value;
		var re = /^\+?[0-9][0-9]*$/;
		if(value=="")
			return;
		if(!re.test(value)){
			alert("数量必须为数字!");
			obj.value = "";
        	return false;
		}
	}
	
</script>
</html>

