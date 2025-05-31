<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String projectInfoNo = user.getProjectInfoNo();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String usemat_id=request.getParameter("usemat_id");
	String wx_ids=request.getParameter("wx_ids");
	String self_num = request.getParameter("self_num");
	String dev_acc_id=request.getParameter("dev_acc_id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
<title></title>
<style type="text/css">
.inputWidth{
width: 220px;
}
</style>
</head>
<body class="bgColor_f3f3f3" onload="load()">

	<form name="form1" id="form1" method="post" action="">
		<input type='hidden' name='selectWzId' id='selectWzId' />
		<div id="new_table_box" style="width: 100%">
			<div id="new_table_box_content" style="width: 100%">
				<div id="new_table_box_bg" style="width: 95%">
					<div style="overflow: auto">
						<table width="97%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height">
							<tr align="right">
								<td style="width: 90%"></td>
								<auth:ListButton id="zj1" functionId="" css="zj" event="onclick='toAdd()'" title="添加故障"></auth:ListButton>

								<td align='center'><span class="sc"><a href="#" id="delProcess" name="delXgllEq" onclick="deleteMatHave()"></a></span></td>
								<td style="width: 1%"></td>
							</tr>
						</table>
					</div>
					<fieldset style="margin-left: 2px">
						<legend>故障列表</legend>
						<div style="height: 300px; overflow: auto">
							<table width="97%" border="0" cellspacing="0" cellpadding="0"
								class="tab_line_height">
								<tr>
									<td class="bt_info_odd" style="width: 1%"><input
										type='checkbox' id='hirechecked' name='hirechecked' /></td>
									<td class="bt_info_odd" style="width: 20%">故障大类</td>
									<td class="bt_info_even" style="width: 20%">故障小类</td>
									<td class="bt_info_odd" style="width: 20%">故障现象</td>
									<td class="bt_info_odd" style="width: 7.5%">是否已解决</td>
									<!-- <td class="bt_info_even" style="width: 20%">故障解决方式</td> -->
									<td class="bt_info_odd" style="width: 20%">故障原因及解决方法</td>
									<td class="bt_info_even" style="width: 7.5%">更换备件</td>
									<!-- <td class="bt_info_odd" style="width: 7.5%">故障分类</td> -->
								</tr>
								<tbody id="processtable0" name="processtable0">
								</tbody>
							</table>
						</div>
					</fieldset>


				</div>
				<div id="oper_div">
					<span class="bc_btn"><a href="#" onclick="submitInfo()"></a></span>
					<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
				</div>
			</div>
		</div>
		</form>
</body>
<script type="text/javascript">
var tr_id=0;
function load()
{
	var self_num='<%=self_num%>';//自编号
	var usemat_id='<%=usemat_id%>';//唯一标识
		var baseData;
		 baseData = jcdpCallService("DevInsSrv", "getGzInfoForWx", "usemat_id="+usemat_id+"&self_num="+self_num);
			if(baseData.datas!=null)
			{
				//通过查询结果动态填充使用情况select;
				var querySql="select t.* from GMS_DEVICE_ZY_FALUT_CATEGORY t  where t.parent_falut_id = 'root' order by t.order_num";
				var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
				usingdatas = queryRet.datas;
				for (var i=0; i< baseData.datas.length; i++) {
					tr_id=$("#processtable0 tr").length;
					var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
					innerhtml += "<input name='usemat_id"+tr_id+"' id='usemat_id"+tr_id+"' value='"+baseData.datas[i].usemat_id+"' size='16'  type='hidden' />";
					innerhtml += "<input name='gz_bj_id"+tr_id+"' id='gz_bj_id"+tr_id+"' value='"+baseData.datas[i].gz_bj_id+"' size='16'  type='hidden' />";
					innerhtml += "<input name='falut_source"+tr_id+"' id='falut_source"+tr_id+"' value='"+baseData.datas[i].falut_source+"' size='16'  type='hidden' />";
					innerhtml += "<input name='id"+tr_id+"' id='id"+tr_id+"' value='"+baseData.datas[i].id+"' size='16'  type='hidden' />";
					innerhtml += "<input name='falut_source"+tr_id+"'id='falut_source"+tr_id+"' value='"+baseData.datas[i].falut_source+"' size='16'  type='hidden' />";
					innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
					//故障分类1
					innerhtml += "<td align='center'>&nbsp;<select name='parent_falut_id"+tr_id+"' id='parent_falut_id"+tr_id+"' onchange='changeGz("+tr_id+")'>";
					if(usingdatas != null){
						for (var j = 0; j< usingdatas.length; j++) {
							if(baseData.datas[i].parent_falut_id==usingdatas[j].falut_id){
								innerhtml +=  "<option selected value='"+usingdatas[j].falut_id+"'>"+usingdatas[j].falut_name+"</option>";
							}else{
								innerhtml +=  "<option value='"+usingdatas[j].falut_id+"'>"+usingdatas[j].falut_name+"</option>";
							}
						}
					}
					innerhtml +="</select></td>";
					//故障分类2
					if(usingdatas != null){
						innerhtml += "<td align='center'>&nbsp;<select name='falut_group_id"+tr_id+"' id='falut_group_id"+tr_id+"' onchange='changeGz2("+tr_id+")' >";
						innerhtml +=  "<option selected value='"+baseData.datas[i].falut_group_id+"'>"+baseData.datas[i].falut_name+"</option>";
						innerhtml +="</select></td>";
					//故障现象
						innerhtml += "<td align='center'>&nbsp;<select style='width:150px;z-index:-1' name='falut_desc"+tr_id+"' id='falut_desc"+tr_id+"' onkeydown='writeDwon(this)' onkeypress='writeSelect(this)'>";
						innerhtml +=  "<option value=''></option><option selected value='"+baseData.datas[i].deal_id+"'>"+baseData.datas[i].deal_name+"</option>";
						innerhtml +="</select></td>";
					}
					if(baseData.datas[i].falut_deal_flag=='0'){//0未解决，1已解决
						innerhtml +="<td> <input type='radio' name='falut_deal_flag"+tr_id+"' value='0' id='falut_deal_flag1' checked onclick='res_falut_case("+tr_id+",1)'/>否";
						innerhtml +="<input type='radio' name='falut_deal_flag"+tr_id+"' value='1' id='falut_deal_flag2' onclick='res_falut_case("+tr_id+",0)'/>是</td>";
					 }else if(baseData.datas[i].falut_deal_flag=='1'){
						innerhtml +="<td> <input type='radio' name='falut_deal_flag"+tr_id+"' value='0' id='falut_deal_flag1' onclick='res_falut_case("+tr_id+",1)'/>否";
						innerhtml +="<input type='radio' name='falut_deal_flag"+tr_id+"' value='1' id='falut_deal_flag2' checked onclick='res_falut_case("+tr_id+",0)'/>是</td>";
					 }
					//故障解决方式0现场解决、1维修解决
					/* if(baseData.datas[i].falut_case=='1'){
						innerhtml += "<td align='center'>&nbsp;<select name='falut_case"+tr_id+"' id='falut_case"+tr_id+"'>";
						innerhtml +=  "<option   value='1' selected>维修解决</option>";
						innerhtml +="</select></td>";
					} */
					//故障解决办法
					innerhtml += "<td align='center'><input class='inputWidth' name='falut_reason"+tr_id+"' id='falut_reason"+tr_id+"' value='"+baseData.datas[i].falut_reason+"' size='16' /></td>";
					innerhtml += "<td><input type='button' id='xuanze"+tr_id+"' value='更换备件' onclick='selectMatData("+tr_id+")'/></td>";
					$("#processtable0").append(innerhtml);
					}
			
				$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable0>tr:odd>td:even").addClass("odd_even");
				$("#processtable0>tr:even>td:odd").addClass("even_odd");
				$("#processtable0>tr:even>td:even").addClass("even_even");
				}
}
function toAdd()
{
	var querySql="select t.* from GMS_DEVICE_ZY_FALUT_CATEGORY t  where t.parent_falut_id = 'root' order by t.order_num";
	var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
	usingdatas = queryRet.datas;
	tr_id=$("#processtable0 tr").length;
	var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
	innerhtml += "<input name='usemat_id"+tr_id+"' id='usemat_id"+tr_id+"' value='<%=usemat_id%>' size='16'  type='hidden' />";
	innerhtml += "<input name='gz_bj_id"+tr_id+"' id='gz_bj_id"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<input name='falut_source"+tr_id+"' id='falut_source"+tr_id+"' value='1' size='16'  type='hidden' />";
	innerhtml += "<input name='id"+tr_id+"' id='id"+tr_id+"' value='' size='16'  type='hidden' />";
	innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
	//故障分类1
	innerhtml += "<td align='center'>&nbsp;<select name='parent_falut_id"+tr_id+"' id='parent_falut_id"+tr_id+"' onchange='changeGz("+tr_id+")' >";
	if(usingdatas != null){
		for (var j = 0; j< usingdatas.length; j++) {
			innerhtml +=  "<option   value='"+usingdatas[j].falut_id+"'>"+usingdatas[j].falut_name+"</option>";
		}
	}
	innerhtml +="</select></td>";
	//故障分类2
	innerhtml += "<td align='center'>&nbsp;<select name='falut_group_id"+tr_id+"' id='falut_group_id"+tr_id+"' onchange='changeGz2("+tr_id+")' >";
	innerhtml +="</select></td>";
	//故障现象
	innerhtml += "<td align='center'>&nbsp;<select style='width:150px;z-index:-1' name='falut_desc"+tr_id+"' id='falut_desc"+tr_id+"' onkeydown='writeDwon(this)' onkeypress='writeSelect(this)'>";
	innerhtml +=" <option value=''></option></select></td>";
	//故障是否解决
	innerhtml +="<td> <input type='radio' name='falut_deal_flag"+tr_id+"' value='0' id='falut_deal_flag1' />否";
	innerhtml +="<input type='radio' name='falut_deal_flag"+tr_id+"' value='1' id='falut_deal_flag2' checked/>是</td>";
	//故障解决方式0现场解决、1维修解决
	/* innerhtml += "<td align='center'>&nbsp;<select name='falut_case"+tr_id+"' id='falut_case"+tr_id+"'>";
	innerhtml +=  "<option   value='1' selected>维修解决</option>";
	innerhtml +="</select></td>"; */
	//故障解决办法
	innerhtml += "<td align='center'>&nbsp;<input class='inputWidth' name='falut_reason"+tr_id+"' id='falut_reason"+tr_id+"' value='' size='16' /></td>";
	innerhtml += "<td><input type='button' id='xuanze"+tr_id+"' value='更换备件' onclick='selectMatData("+tr_id+")'/></td>";
	$("#processtable0").append(innerhtml);	
}
/**点击更换备件使用的方法，
该方法生成唯一系统id，
使它作为保养主表与备件信息间的唯一关联标识，
该标识也将用在保养主表与保养项目间作为唯一标识**/
function selectMatData(i)
{
	var gz_bj_id=document.getElementById("gz_bj_id"+i+"").value;
	if(gz_bj_id==null || gz_bj_id=='' || gz_bj_id=='undefined'){
		var sql = "select lower(sys_guid()) devicebackappid from dual";
		var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
		if(retObj!=null && retObj.returnCode=='0'){
			gz_bj_id = retObj.datas[0].devicebackappid;
		}
		document.getElementById("gz_bj_id"+i+"").value = gz_bj_id;
	}
	var parent_falut_id = $("#parent_falut_id"+i).val();//故障大类
	//根据故障大类获取备件类别id
	var sql = "select bjlb_id from GMS_DEVICE_ZY_GZDL_RE_BJLB where gzdl_id='"+parent_falut_id+"' and bsflag=0";
	var retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=1');
	var	bjlb_id = retObj.datas[0].bjlb_id;
	//自编号
	var self_num = '<%=self_num%>';//自编号
	var usemat_id = '<%=usemat_id%>';
	/* var zcj_type=document.getElementById("zcj_type"+i+"").value; */
	/* var work_hours = document.getElementById("work_hours"+i+"").value; */
	var selected;
	selected = window.showModalDialog("<%=contextPath%>/rm/dm/kkzy/mutiPorject/selectMatList-zy1.jsp?self_num="+self_num+"&bywx_type=2&selectWzId="+usemat_id+"&gz_bj_id="+gz_bj_id+"&bjlb_id="+bjlb_id,"","dialogWidth=1240px;dialogHeight=680px");
	<%-- selected = window.showModalDialog("<%=contextPath%>/rm/dm/kkzy/zcjMatList-zy.jsp?selectWzId="+usemat_id,"","dialogWidth=1240px;dialogHeight=680px"); --%>
	if(selected=='true'){
		document.getElementById("xuanze"+i+"").value="已提交";
	}
}
function changeGz(i){
	var parent_falut_id = "";
	parent_falut_id = $("#parent_falut_id"+i).val();
	if(parent_falut_id == ""){
		alert('故障大类不能为空！');
		var innerhtml =  "";
		$("#falut_group_id"+i).empty();
		$("#falut_group_id"+i).append(innerhtml);
		return;
	}
	var querySql="select t.* from GMS_DEVICE_ZY_FALUT_CATEGORY t  where t.parent_falut_id = '"+parent_falut_id+"' order by to_number(t.order_num)";
	var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
	usingdatas = queryRet.datas;
	if(usingdatas != null){
		var innerhtml =  "";
		for (var j = 0; j< usingdatas.length; j++) {
			if(j==0){
				innerhtml +=  "<option selected  value='"+usingdatas[j].falut_id+"'>"+usingdatas[j].falut_name+"</option>";
			}else{
				innerhtml +=  "<option   value='"+usingdatas[j].falut_id+"'>"+usingdatas[j].falut_name+"</option>";
			}
		}
		 $("#falut_group_id"+i).empty();
		 $("#falut_group_id"+i).append(innerhtml);  
		 changeGz2(0);//默认查询小类中第一条数据的故障现象
		//autoShowSelect("falut_group_id"+i);
	}
	
}
function changeGz2(i){
	var falut_group_id = "";
	falut_group_id = $("#falut_group_id"+i).val();
	if(falut_group_id == ""){
		alert('故障小类不能为空！');
		var innerhtml =  "";
		$("#falut_desc"+i).empty();
		$("#falut_desc"+i).append(innerhtml);
		return;
	}
	var querySql="select t.* from GMS_DEVICE_ZY_FALUT_DEAL t  where t.falut_id = '"+falut_group_id+"' and t.deal_name is not null order by to_number(t.order_num)";
	var queryRet = syncRequest('Post','/DMS'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
	usingdatas = queryRet.datas;
	if(usingdatas != null){
		var innerhtml =  "<option value=''></option>";
		for (var j = 0; j< usingdatas.length; j++) {
			if(j==0){
				innerhtml +=  "<option selected value='"+usingdatas[j].deal_id+"'>"+usingdatas[j].deal_name+"</option>";
			}else{
				innerhtml +=  "<option   value='"+usingdatas[j].deal_id+"'>"+usingdatas[j].deal_name+"</option>";
			}
		}
		 $("#falut_desc"+i).empty();
		 $("#falut_desc"+i).append(innerhtml);  
		//autoShowSelect("falut_desc"+i);
	}
	
}
function autoShowSelect(id){
	document.getElementById(id).focus();
    var WshShell = new ActiveXObject("Wscript.Shell");
    try {
        WshShell.SendKeys("%{DOWN}");
    } catch(e){}         
    WshShell.Quit;
}
function writeDown(obj){
	if(event.keyCode == 8){
		obj.options[0].text = "";
		obj.selectedIndex = -1;  
	}
}
function writeSelect(obj){
	obj.options[0].selected = "select";
	if(event.keyCode == 8){
		obj.options[0].text = "";
		obj.selectedIndex = -1;  
	}else{
		obj.options[0].text = obj.options[0].text + String.fromCharCode(event.keyCode);
	}
	event.returnValue=false;
	return obj.options[0].text;
}
/**提交之前先检测是否为新增的问题解决办法，如果是需要新增操作**/
function beforesubmit(count){
	var falut_desc_id = document.getElementById("falut_desc"+count).value;//故障现象原因id
	var falut_desc_name = "";
	var falut_group_id = document.getElementById("falut_group_id"+count).value;//小类id
	if(falut_desc_id==""){//故障现象原因id为空说明他是新增的数据，进行保存的操作
		falut_desc_name = writeSelect(document.getElementById("falut_desc"+count));
		var submitStr = "falut_group_id="+falut_group_id+"&falut_desc_name="+falut_desc_name;
		var retObject = jcdpCallService("DevInsSrv","saveGzFalutDeal",submitStr);//获取保存后的故障现象原因id
		falut_desc_id = retObject.falut_desc_id;
		var innerhtml =  "<option value='"+falut_desc_id+"' selected>"+falut_desc_name+"</option>";
		$("#falut_desc"+count).append(innerhtml);
	}
}
var has_falut_deal_flag = false;
function submitInfo()
{
	//保留的行信息
	var count = 0;
	var line_infos ="";
	var usemat_id ="";
	var falut_source ="";
	var falut_desc =""; 
	var falut_reason="";
	var falut_case="";
	var falut_group_id="";
	var id ="";
	var gz_bj_id = "";
	$("input[type='checkbox'][name='idinfo']").each(function(){
		if(this.checked){
			beforesubmit(count);
			var my_falut_deal_flag = "";
			var radionum = document.getElementsByName("falut_deal_flag"+count);
			for(var i=0;i<radionum.length;i++){
				  if(radionum[i].checked){
					  my_falut_deal_flag = radionum[i].value;
					  if(my_falut_deal_flag=='0'){//只要存在未解决的故障就赋值
						  has_falut_deal_flag = true;
					  }
				  }
			}
			if(count == 0){
				line_infos = this.id;
				usemat_id = document.getElementById("usemat_id"+count).value;
				falut_source = document.getElementById("falut_source"+count).value;
				falut_desc = document.getElementById("falut_desc"+count).value;
				falut_reason = document.getElementById("falut_reason"+count).value;
				falut_case = "1";
				falut_group_id = document.getElementById("falut_group_id"+count).value;
				id = document.getElementById("id"+count).value;
				gz_bj_id = document.getElementById("gz_bj_id"+count).value;
				falut_deal_flag = my_falut_deal_flag;
			}else{
				line_infos += "~"+this.id;
				usemat_id += "~"+document.getElementById("usemat_id"+count).value;
				falut_source += "~"+document.getElementById("falut_source"+count).value;
				falut_desc += "~"+document.getElementById("falut_desc"+count).value;
				falut_reason += "~"+document.getElementById("falut_reason"+count).value;
				falut_case += "~1";
				falut_group_id += "~"+document.getElementById("falut_group_id"+count).value;
				id += "~"+document.getElementById("id"+count).value;
				gz_bj_id += "~"+document.getElementById("gz_bj_id"+count).value;
				falut_deal_flag += "~"+ my_falut_deal_flag;
			}
			count++;
		}
	});
	if(count == 0){
		alert('请录入设备故障信息！');
		return;
	}
	var selectedlines = line_infos.split("~");
	var wronglineinfos = "";
	for(var index=0;index<selectedlines.length;index++){
		/* if(document.getElementById("falut_group_id"+count).value==''){
			alert('第'+(count+1)+'行故障小类不能为空！');
			return;
		}
		if(document.getElementById("falut_desc"+count).value==''){
			alert('第'+(count+1)+'行故障现象不能为空！');
			return;
		}
		if(document.getElementById("falut_case"+count).value=='0'&&document.getElementById("falut_reason"+count).value==''){//0现场解决，1维修解决
			alert('第'+(count+1)+'行故障现场解决时，故障解决办法不能为空！');
			return;
		} */
		//故障现象
		var falut_desc1 = $("#falut_desc"+selectedlines[index]).val();
		//故障解决方式
		var falut_case1 = "1";
		//故障原因
		var falut_reason1 = $("#falut_reason"+selectedlines[index]).val();
		//故障分组id
		var falut_group_id1 = $("#falut_group_id"+selectedlines[index]).val();
		if(falut_desc1 == "" || (falut_case1=='0'&&falut_reason1 == "") || falut_group_id1==""){
			if(index == 0){
				wronglineinfos += (parseInt(selectedlines[index])+1);
			}else{
				wronglineinfos += ","+(parseInt(selectedlines[index])+1);
			}
		}
	}
		
	if(wronglineinfos!=""){
		alert("请设置第"+wronglineinfos+"行明细的故障记录!");
		return;
	}
	var wx_ids= '<%=usemat_id%>';
	var dev_acc_id='<%=dev_acc_id%>';//台账id
	var submitStr = "has_falut_deal_flag="+has_falut_deal_flag+"&dev_acc_id="+dev_acc_id+"&count="+count+"&line_infos="+line_infos+"&usemat_id="+usemat_id+"&falut_source="+falut_source+"&falut_desc="+falut_desc+"&falut_reason="+falut_reason+"&falut_case="+falut_case+"&falut_group_id="+falut_group_id+"&id="+id+"&falut_deal_flag="+falut_deal_flag+"&wx_ids="+wx_ids+"&gz_bj_id="+gz_bj_id;
	var retObject = jcdpCallService("DevInsSrv","saveGzInfo",submitStr);
	window.returnValue = "true";
	window.returnValue = has_falut_deal_flag;
	alert('保存成功');
	newClose();
}
function deleteMatHave(){
	var ids = getSelIds('idinfo');
    if(ids==''){ 
    	alert("请选择一条记录");
 		return;
    }
	if(confirm("是否执行删除操作?")){
		var gz_ids = "";
		$("input[name='idinfo']").each(function(){
			if(this.checked == true){
				var falut_source = document.getElementById("falut_source"+this.id).value;
				if(falut_source=="1"){
					if(gz_ids!=""){
						gz_ids += ","; 
					}
					gz_ids += "'"+document.getElementById("id"+this.id).value+"'";
					$('#tr'+this.id,"#processtable0").remove();
				}else{
					alert("第"+(parseInt(this.id)+1)+"行为保养发现故障，维修时不能删除");
				}
			}
		});
		retObj = jcdpCallService("DevInsSrv", "deleteGzInfo", "gz_ids="+gz_ids);
	}
	$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
	$("#processtable0>tr:odd>td:even").addClass("odd_even");
	$("#processtable0>tr:even>td:odd").addClass("even_odd");
	$("#processtable0>tr:even>td:even").addClass("even_even");
}

function newClose(){
	  window.close();
}
</script>
</html>