<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	String userId = request.getParameter("userid");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String addUpFlag = request.getParameter("addupflag");	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>填写用户信息</title>
</head>
<body class="bgColor_f3f3f3">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content" style="background-color: rgb(241, 242, 243)">
    <div id="new_table_box_bg">
      <fieldset style="margin:2px;padding:2px;"><legend>用户基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
       <tr>
          <td class="inquire_item4">&nbsp;选择人员:</td>
          <td class="inquire_form4" >
          	<input name="username" id="username" class="input_width easyui-tooltip easyui-validatebox" type="text" value="" data-options="tipPosition:'top'" readonly required/>
          	<input name="empid" id="empid" class="input_width" type="hidden" value=""/>
          	<input name="userid" id="userid" class="input_width" type="hidden"  value="" />
          	<img id="orgimg" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showUserPage()"  />
          </td>
          <td class="inquire_item4">&nbsp;登录ID:</td>
		  <td class="inquire_form4">
		  	  <input name="loginid" id="loginid" class="input_width easyui-validatebox" type="text" value="" required/>
		  </td>
        </tr>
		<tr>
			<td class="inquire_item4">&nbsp;组织机构:</td>
            <td class="inquire_form4">
	          	<input name="orgname" id="orgname" class="input_width easyui-validatebox" type="text" value="" data-options="tipPosition:'top'" readonly required/>
	          	<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showOrgTreePage()" />
	          	<input name="orgid" id="orgid" class="input_width" type="hidden"  value="" />
          	</td>
		  <td class="inquire_item4">&nbsp;邮箱:</td>
		  <td class="inquire_form4">
		  	  <input name="email" id="email" class="input_width easyui-validatebox" validType='email' data-options="tipPosition:'top'" type="text" value="" />
		  </td>
        </tr>
        <tr>
       		<td class="inquire_item4"><font color=red>*</font>&nbsp;&nbsp;用户类型:</td>
       		<td class="inquire_form4">
				<select id="usertype" name="usertype" class="select_width easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="width:225px;" >
					<option value="3">普通用户</option>
					<!-- <option value="2">物探处管理员</option> -->
				</select>
			</td>
        </tr>
      </table>
      </fieldset>
    </div>
      <div id="oper_div" style="padding-top:6px;">
		 <a href="####" id="submitButton" class="easyui-linkbutton" onclick="save()"><i class="fa fa-floppy-o fa-lg"></i> 保 存 </a>
		 &nbsp;&nbsp;&nbsp;&nbsp;
		 <a href="####" class="easyui-linkbutton" onclick='newClose()'><i class="fa fa-times fa-lg"></i> 关 闭 </a>
	</div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var idinfo = '<%=userId%>';
	var addupflag = '<%=addUpFlag%>';

	$(document).ready(function() {
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
		//为必填项添加红星
		$("#form1").renderRequiredLabel();
		if(addupflag == 'up'){
			$("#orgimg").hide();//用户名不能修改
		}
		refreshData();
	});
	//选择人员
	function showUserPage(){
		var teamInfo = {fkValue:"",value:""};
		window.showModalDialog('<%=contextPath%>/common/selectEmployee.jsp',teamInfo,'scrollbars=yes');
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
	 //选择用户组织机构树
	function showOrgTreePage(){
		var obj = new Object();
		window.showModalDialog("<%=contextPath%>/common/selectOrg.jsp",obj);
		if(obj.value!=undefined){
			$("#orgname").val(obj.value);
			$("#orgid").val(obj.fkValue);
			tipView('orgname',obj.value,'top');
		}
	}
	//提交保存
	function save(){
		if(formVilidate($("#form1"))){
			var empid = $("#empid").val();
			var username = $("#username").val();
			var loginid = $.trim($("#loginid").val());
			var userid = $("#userid").val();
			var email = $("#email").val();
			//判断用户是否存在	
			var retObj = jcdpCallService("AuthEntitySrv", "opUserInfo", 
					"opflag=ex&addupflag="+addupflag+"&userid="+userid+"&loginid="+loginid+"&email="+email+"&empid="+empid);
			if(typeof retObj.datas!="undefined"){
				var opflag = retObj.datas;
				if("4" == opflag || "5" == opflag){
					$.messager.alert("提示","不能对超级管理员做任何操作!","warning");
					return;
				}
				if("1" == opflag){
					$.messager.alert("提示","用户 '"+username+"' 已经存在，不能新增!","warning");
					return;
				}
				if("2" == opflag){
					$.messager.alert("提示","登录用户名 '"+loginid+"' 已经存在，不能新增!","warning");
					return;
				}
				if("6" == opflag){
					$.messager.alert("提示","邮箱 '"+email+"' 已经存在，不能新增!","warning");
					return;
				}
				if("3" == opflag){
					$.messager.alert("提示","操作失败!","error");
					return;
				}
			}
			$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
	            if (data) {
	            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
	    			$("#submitButton").attr({"disabled":"disabled"});
	    			document.getElementById("form1").action = "<%=contextPath%>/ibp/auth2/toSaveOrUpdateUserInfo.srq?addupflag="+addupflag;
	    			document.getElementById("form1").submit();
	            }
	        });
		}
	}
	//修改时加载用户信息
	function refreshData(){
		if(idinfo != 'null' && idinfo!=''){
			var retObj = jcdpCallService("AuthEntitySrv", "getUserMainInfo", "userid="+idinfo);
			if(typeof retObj.data!="undefined"){
				//回填基本信息
				$("#username").val(retObj.data.user_name);
				$("#empid").val(retObj.data.emp_id);
				$("#userid").val(retObj.data.user_id);
				$("#loginid").val(retObj.data.login_id);
				$("#email").val(retObj.data.email);
				$("#orgname").val(retObj.data.shortorgname);
				$("#orgid").val(retObj.data.org_id);
				$("#usertype").combobox("setValue", retObj.data.user_type);
				tipView('username',retObj.data.user_name,'top');
				tipView('orgname',retObj.data.org_name,'top');
			}
		}
	}
</script>
</html>
