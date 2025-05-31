<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	String addupflag=request.getParameter("addupflag");
	String dev_acc_id=request.getParameter("dev_acc_id");
	if(dev_acc_id==null){
	dev_acc_id="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
 <%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备添加</title>
</head>
<body class="bgColor_f3f3f3">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content" style="background-color: rgb(241, 242, 243)">
    <div id="new_table_box_bg">
    <fieldset><legend>基本信息&nbsp;&nbsp;  </legend> 
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
				<td class="inquire_item6">&nbsp;设备名称</td>
				<td class="inquire_form6">
					<input id="dev_name" name="dev_name" class="input_width easyui-validatebox" type="text" required/>
				</td>
				<td class="inquire_item6">&nbsp;规格型号</td>
				<td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width easyui-validatebox" type="text" required  /></td>
				  <td class="inquire_item6">&nbsp;管理单位</td>
				<td class="inquire_form6">
					<input id="usage_org_name" name="usage_org_name"  class="input_width easyui-validatebox" type="text" readonly required />
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showOrgTreePage1()"  />
					<input id="usage_org_id" name="usage_org_id" class="" type="hidden" />
					<input id="usage_sub_id" name="usage_sub_id" class="" type="hidden" />
				</td>
			  </tr>
				<tr>
				<td class="inquire_item6"> &nbsp;出厂/管道编号</td>
				<td class="inquire_form6">
				<input id="dev_num" name="dev_num" class="input_width" type="text"   />	 
				</td>
				<td class="inquire_item6"> &nbsp;实物标识号</td>
				<td class="inquire_form6"><input id="dev_sign" name="dev_sign" class="input_width easyui-validatebox" type="text" required /></td>
				<td class="inquire_item6"> &nbsp;ERP编号</td>
				<td class="inquire_form6"><input id="dev_coding" name="dev_coding" class="input_width " type="text"  /></td>				
			  </tr>
			  	<tr>
				<td class="inquire_item6"> &nbsp;档案编号</td>
				<td class="inquire_form6">
				<input id="RECORD_NUM" name="RECORD_NUM" class="input_width " type="text"  />	 
				</td>
				<td class="inquire_item6"> &nbsp;使用证编号</td>
				<td class="inquire_form6"><input id="USE_NUM" name="USE_NUM" class="input_width " type="text"  /></td>
				<td class="inquire_item6"> &nbsp;单位内部编号</td>
				<td class="inquire_form6"><input id="INTERNAL_NUM" name="INTERNAL_NUM" class="input_width " type="text"  /></td>				
			  </tr>
			  <tr>
				<td class="inquire_item6"> &nbsp;主要用途</td>
				<td class="inquire_form6">
				<input id="MAIN_USEINFO" name="MAIN_USEINFO" class="input_width " type="text"  />	 
				</td>
				<td class="inquire_item6"> &nbsp;设备安装地点</td>
				<td class="inquire_form6"><input id="INSTALLTION_PLACE" name="INSTALLTION_PLACE" class="input_width " type="text"   /></td>
				<td class="inquire_item6"> &nbsp;注册码</td>
				<td class="inquire_form6"><input id="REGISTRATION_CODE" name="REGISTRATION_CODE" class="input_width " type="text"  /></td>				
			  </tr>
			  <tr>
				<td class="inquire_item6">注册状态</td>
				<td class="inquire_form6"><select  id="zc_stat" name="zc_stat" class="input_width easyui-validatebox" type="text" >
					<option value="0">未注册</option>
					<option value="1">已注册</option>
				</select></td>
				<td class="inquire_item6">&nbsp;所属单位</td>
				<td class="inquire_form6">
					<input id="owning_org_name" name="owning_org_name"  class="input_width easyui-validatebox" type="text" readonly required />
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showOrgTreePage()"  />
					<input id="owning_org_id" name="owning_org_id" class="" type="hidden" />
					<input id="owning_sub_id" name="owning_sub_id" class="" type="hidden" />
					 <input id="devaccid" name="devaccid" class="input_width" type="hidden" />
				</td>
				<td class="inquire_item6">使用情况</td>
				<td class="inquire_form6"><select id="using_stat" name="using_stat" class="input_width" type="text" onchange="selectChange()"  required/></td>				
			  </tr>
			  <tr>
			  	<td class="inquire_item6">技术状况</td>
				<td class="inquire_form6"><select type="text" name="tech_stat" id="tech_stat" value="" readonly="readonly" class="input_width" required/>
				</td>
			    <td class="inquire_item6">&nbsp;国内/国外</td>
				<td class="inquire_form6">
					<select type="text" name="ifcountry" id="ifcountry" value="" readonly="readonly" class="input_width" required>
						<option value="0">国内</option>
						<option value="1">国外</option>
					</select>
				</td>
				  <td class="inquire_item6">&nbsp;投产日期</td>
				  <td class="inquire_form6">
				  <input type="text" name="PRODUCTING_DATE" id="PRODUCTING_DATE" value="<%=appDate %>" class="input_width easyui-datebox" style="width:130px" editable="false" required/>
				  </td>
			  </tr>
			  <tr>
			  	<td class="inquire_item6">资产状态</td>
				<td class="inquire_form6">
					<select type="text" name="account_stat" id="account_stat" value="" readonly="readonly" class="input_width" required>
						<option value="0110000013000000003">在帐</option>
						<option value="0110000013000000006">不在帐</option>
					</select>
				</td>
				 <td class="inquire_item6">&nbsp;实际送检时间</td>
				  <td class="inquire_form6">
				  <input type="text" name="CURRENT_CHECK_DATE" id="CURRENT_CHECK_DATE"  class="input_width easyui-datebox" style="width:130px" editable="false" />
				  </td>
				  <td class="inquire_item6"> &nbsp;资产原值</td>
					<td class="inquire_form6">
					<input id="ASSET_VALUE" name="ASSET_VALUE" class="input_width easyui-validatebox" type="text"  required/>	 
				 </td>
			  </tr>
			  <tr>
			<td class="inquire_item4">&nbsp;日检人员:</td>
          <td class="inquire_form4" >
          	<input name="username" id="username" class="input_width easyui-tooltip easyui-validatebox" type="text" value="" data-options="tipPosition:'top'" readonly required/>
          	<input name="empid" id="empid" class="input_width" type="hidden" value=""/>
          	<input name="userid" id="userid" class="input_width" type="hidden"  value="" />
          	<img id="orgimg" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showUserPage()"  />
          </td>
            <td class="inquire_item6"></font>&nbsp;设备编码</td>
				  <td class="inquire_form6">
					<input id="dev_type" name="dev_type"  class="input_width easyui-validatebox" type="text" readonly required/>
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevTreePage()"  />
					<font color=red>*请选择相近的设备类型*<font>
				</td>
			  </tr>
      </table>
       </fieldset>
      <fieldset><legend>备注</legend>
	      <table id="table2" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
		      	<td>
		      		<textarea id='remark' name='remark' rows="2" cols="74"></textarea>
		      	</td>
	      	</tr>
	      </table>
       </fieldset>
       <fieldset><legend>备注1</legend>
       <table id="table3" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
		      	<td>
		      		<textarea id='spare1' name='spare1' rows="2" cols="74"></textarea>
		      	</td>
	      	</tr>
	      </table>
       </fieldset>
      <fieldset><legend>备注2</legend>
       <table id="table4" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
		      	<td>
		      		<textarea id='spare2' name='spare2' rows="2" cols="74"></textarea>
		      	</td>
	      	</tr>
	      </table>
       </fieldset>
      <fieldset><legend>备注3</legend>
       <table id="table5" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
		      	<td>
		      		<textarea id='spare3' name='spare3' rows="2" cols="74"></textarea>
		      	</td>
	      	</tr>
	      </table>
       </fieldset>
      <!-- <fieldset><legend>备注4</legend>
       <table id="table6" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	      	<tr>
		      	<td>
		      		<textarea id='spare4' name='spare4' rows="5" cols="74"></textarea>
		      	</td>
	      	</tr>
	      </table>
      </fieldset> -->
    </div>
    <div id="oper_div" style="padding-top:6px;">
		 <a href="####" id="submitButton" class="easyui-linkbutton" onclick="submitInfo()"><i class="fa fa-floppy-o fa-lg"></i> 保 存 </a>
		 &nbsp;&nbsp;&nbsp;&nbsp;
		 <a href="####" class="easyui-linkbutton" onclick='newClose()'><i class="fa fa-times fa-lg"></i> 关 闭 </a>
	</div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
	
	var buttons = $.extend([], $.fn.datebox.defaults.buttons);
	buttons.splice(1, 0, {
	text: '清空',
	handler : function(target) {
		$(target).combo("setValue", "").combo("setText", ""); // 设置空值
		$(target).combo("hidePanel"); // 点击清空按钮之后关闭日期选择面板
	}
	});
	$.fn.datebox.defaults.buttons = buttons;
 	
	$().ready(function(){
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
		//为必填项添加红星
		$("#form1").renderRequiredLabel();
		pageInit();
	});
	
	function pageInit(){
				
		//通过查询结果动态填充使用情况select;
		var querySql="select * from comm_coding_sort_detail where coding_sort_id='0110000007' and bsflag='0' and coding_code in('01','03') order by coding_show_id ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		usingdatas = queryRet.datas;
		
		if(usingdatas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				document.getElementById("using_stat").options.add(new Option(usingdatas[i].coding_name,usingdatas[i].coding_code_id)); 
			}
		}
		//使用状况默认闲置
		document.getElementById("using_stat").options[0].selected=true;
		//技术状况默认完好
		document.getElementById("tech_stat").options.add(new Option("完好","0110000006000000001"));
		var dev_acc_id='<%=dev_acc_id%>';
		if(dev_acc_id!=''){
		var querySql="select acc.*,(select employee_name from comm_human_employee  where EMPLOYEE_ID=usage_EMPLOYEE_ID ) employee_name, (select org_abbreviation from comm_org_information where acc.owning_org_id=org_id )org_abbreviation,(select org_abbreviation from  comm_org_information where acc.usage_org_id=org_id )org_abbreviation1,decode(acc.ifcountry,'国内','0','1') country from gms_device_account_s acc   where  acc.dev_acc_id='"+dev_acc_id+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		datas = queryRet.datas;
		debugger;
		document.getElementById("username").value=datas[0].employee_name;
		document.getElementById("empid").value=datas[0].usage_employee_id;
		document.getElementById("devaccid").value=datas[0].dev_acc_id;
		document.getElementById("dev_name").value=datas[0].dev_name;
		document.getElementById("dev_model").value=datas[0].dev_model;
 		document.getElementById("dev_type").value=datas[0].dev_type;
		document.getElementById("owning_org_name").value=datas[0].org_abbreviation;
		document.getElementById("owning_org_id").value=datas[0].owning_org_id;
		document.getElementById("owning_sub_id").value=datas[0].owning_sub_id;
		document.getElementById("usage_org_name").value=datas[0].org_abbreviation1;
		document.getElementById("usage_org_id").value=datas[0].usage_org_id;
		document.getElementById("usage_sub_id").value=datas[0].usage_sub_id;
		document.getElementById("ifcountry").value=datas[0].country;
		document.getElementById("dev_num").value=datas[0].dev_num;
		document.getElementById("dev_sign").value=datas[0].dev_sign;
		document.getElementById("dev_coding").value=datas[0].dev_coding;
		$("#zc_stat").val(datas[0].zc_stat);
		$("#account_stat").val(datas[0].account_stat);
		document.getElementById("using_stat").value=datas[0].using_stat;
		document.getElementById("tech_stat").value=datas[0].tech_stat;
		$("#PRODUCTING_DATE").datebox('setValue',datas[0].producting_date);
		document.getElementById("remark").value=datas[0].remark;
		document.getElementById("spare1").value=datas[0].spare1;
		document.getElementById("spare2").value=datas[0].spare2;
		document.getElementById("spare3").value=datas[0].spare3;
		document.getElementById("RECORD_NUM").value=datas[0].record_num;
		document.getElementById("ASSET_VALUE").value=datas[0].asset_value;
		document.getElementById("USE_NUM").value=datas[0].use_num;
		document.getElementById("INTERNAL_NUM").value=datas[0].internal_num;
		document.getElementById("MAIN_USEINFO").value=datas[0].main_useinfo;
		document.getElementById("INSTALLTION_PLACE").value=datas[0].installtion_place;
		document.getElementById("REGISTRATION_CODE").value=datas[0].registration_code;
		$("#CURRENT_CHECK_DATE").datebox('setValue',datas[0].current_check_date);
		
		}
		

	}
	/**
	 * 选择组织机构树
	 */
	function showOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		if(returnValue == undefined){
			return;
		}
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById("owning_org_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("owning_org_id").value = orgId[1];

		var orgSubId = strs[2].split(":");
		document.getElementById("owning_sub_id").value = orgSubId[1];
	}
	/**
	 * 选择组织机构树管理单位
	 */
	function showOrgTreePage1(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR2.jsp?codingSortId=0110000001","test","");
		if(returnValue == undefined){
			return;
		}
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		document.getElementById("usage_org_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("usage_org_id").value = orgId[1];

		var orgSubId = strs[2].split(":");
		document.getElementById("usage_sub_id").value = orgSubId[1];
	}
	
	/**
	 * 提交
	 */
	function submitInfo(){
		var addupflag='<%=addupflag%>';
		if(formVilidate($("#form1"))){
			 
			if(addupflag=='add'){
			//判断状态	是否重复数据	
			var retObj = jcdpCallService("DevInfoConf", "addDevFlag", 
								"devsign="+$('#dev_sign').val());
			if(typeof retObj.datas!="undefined"){
				var addflag = retObj.datas;
				if("1" == addflag){
					$.messager.alert("提示","此实物标识号设备已存在!","warning");
					return;
				}
				if("3" == addflag){
					$.messager.alert("提示","操作失败!","error");
					return;
				}
			}
			}
			$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	            if (data) {
	            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
	    			$("#submitButton").attr({"disabled":"disabled"});
	    			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSubmitAccount_S.srq";
    				document.getElementById("form1").submit();
	            }
	        });
		}
	}
	/**
	 * 使用情况下拉框变化事件，技术状况跟使用情况有关联
	 */
	function selectChange(){
		document.getElementById("tech_stat").options.length=0;
		if(document.getElementById("using_stat").value=='0110000007000000001' || document.getElementById("using_stat").value=='0110000007000000002'){
			document.getElementById("tech_stat").options.add(new Option("完好","0110000006000000001"));
		}else{
			document.getElementById("tech_stat").options.add(new Option("完好","0110000006000000001"));
			document.getElementById("tech_stat").options.add(new Option("待报废","0110000006000000005"));
			document.getElementById("tech_stat").options.add(new Option("待修","0110000006000000006"));
			document.getElementById("tech_stat").options.add(new Option("在修","0110000006000000007"));
			//document.getElementById("tech_stat").options.add(new Option("验收","0110000006000000013"));
		}
	}
	/**
	 * 选择设备树
	**/
	function showDevTreePage(){
		//window.open("<%=contextPath%>/rm/dm/deviceAccount/selectOrg.jsp","test",'toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no,depended=no')
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTreeForSubNode.jsp","test","");
		if(returnValue == undefined){
			return;
		}
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var name = names[1].split("(")[0];
		//判断是否是根节点
		if(names[1].split("(").length==1){
		$.messager.alert("提示","请选择根节点具体型号设备!","warning");
		return;
		}
		var model = names[1].split("(")[1].split(")")[0];
		var codes = strs[1].split(":");
		var code = codes[1];
		document.getElementById("dev_type").value = code;
	}
	//选择人员
	function showUserPage(){
		var teamInfo = {fkValue:"",value:""};
		window.showModalDialog('<%=contextPath%>/common/selectEmployee.jsp?orgId=C6000000000001',teamInfo,'scrollbars=yes');
		if(teamInfo.fkValue!=""){
			$("#username").val(teamInfo.value);
			tipView('username',teamInfo.value,'top');
			$("#empid").val(teamInfo.fkValue);
			var retObj = jcdpCallService("AuthEntitySrv","queryUserInfo","empid="+teamInfo.fkValue);
			if(typeof retObj.mainMap!="undefined"){
				$("#orgname").val(retObj.mainMap.org_abbreviation);
				tipView('orgname',retObj.mainMap.org_abbreviation,'top');
				$("#orgid").val(retObj.mainMap.org_id);
			}
		}
	}
</script>
</html>

