<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date,java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getUserName();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String today = format.format(new Date());
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>添加页面</title>
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/table.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/calendar-blue.css" />
<link type="text/css" rel="stylesheet" href="<%=contextPath%>/css/bgpmcs_table.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="/BGPMCS/BGP_TS_Forum/js/oc_common.js"></script>
</head>

<body>
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="<%=contextPath%>/market/addContract.srq">
<table border="0" cellpadding="0" cellspacing="0" class="form_info">
	<tr class="odd">
	  	<td class="inquire_item"><font color=red>*</font>&nbsp;合同编号/自编号：</td>
	   <td class="inquire_form">
    		<input type="text" name="contractNo" id="contractNo" value="" class="input_width"/>
     	</td>
     	<td class="inquire_item"><font color=red>*</font>&nbsp;项目名称：</td>
	   <td class="inquire_form">
    		<input type="text" name="contractName" id="contractName" value="" class="input_width"/>
     	</td>
	 </tr>
	 <tr class="odd">
     	<td class="inquire_item"><font color=red>*</font>&nbsp;甲方单位：</td>
    	<td class="inquire_form">
			<input type="text" value="" id="partaOrg" name="partaOrg" class='input_width'></input>
      </td>
     	<td class="inquire_item"><font color=red>*</font>&nbsp;合同执行单位：</td>
     	<td class="inquire_form">
     		<input type="hidden" name="undertakingOrgId" id="undertakingOrgId"/>
    		<input type="text" name="undertakingOrg" id="undertakingOrg" value="" class='input_width' readonly="readonly"></input>
    		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
     	</td>
	</tr>
	<tr class="odd">
		<td class="inquire_item"><font color=red>*</font>&nbsp;合同类型：</td>
    	<td class="inquire_form">
    		<input type="text" name="contractType" id="contractType" value=""  class='input_width'/>
     	</td>
    	<td class="inquire_item"><font color=red>*</font>&nbsp;合同额（万元）：</td>
    	<td class="inquire_form">
    		<input type="text" name="contractMoney" id="contractMoney" value=""  class='input_width'/>
     	</td>
    </tr>
    <tr class="odd">
    	<td class="inquire_item"><font color=red>*</font>&nbsp;工作量（2D/3D）：</td>
    	<td class="inquire_form">
    		<input type="text" name="workload" id="workload" value=""  class='input_width'/>
     	</td>
    	<td class="inquire_item"><font color=red>*</font>&nbsp;单价（万元）：</td>
    	<td class="inquire_form">
    		<input type="text" name="unitPrice" id="unitPrice" value=""  class='input_width'/>
     	</td>
    </tr>   
  	<tr class="odd">
    	<td class="inquire_item"><font color=red>*</font>&nbsp;合同签订日期：</td>
    	<td class="inquire_form">
			<input type="text" value="<%=today %>" id="signedTime" name="signedTime" class='input_width' readonly/>
			&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16"  style="cursor:hand;" onMouseOver="dateSelector(signedTime,tributton1);"/>
		</td>
      	<td class="inquire_item"><font color=red>*</font>&nbsp;（区内/区外）市场：</td>
    	<td class="inquire_form">
			<select id="marketType" name="marketType" >
	          <option value="1" >区内</option>
	          <option value="2" >区外</option>
		    </select>	
      </td>
    </tr>    
    <tr class="odd">
     	<td class="inquire_item"><font color=red>*</font>&nbsp;项目启动日期：</td>
    	<td class="inquire_form">
			<input type="text" value="<%=today %>" id="contractStartDate" name="contractStartDate" class='input_width' readonly/>
			&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16"  style="cursor:hand;" onMouseOver="dateSelector(contractStartDate,tributton2);"/>
		</td>
     	<td class="inquire_item"><font color=red>*</font>&nbsp;项目结束日期：</td>
    	<td class="inquire_form">
			<input type="text" value="<%=today %>" id="contractEndDate" name="contractEndDate" class='input_width' readonly/>
			&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16"  style="cursor:hand;" onMouseOver="dateSelector(contractEndDate,tributton3);"/>
		</td>
	</tr>
	<tr class="odd">
     	<td class="inquire_item">&nbsp;备注：</td>
    	<td class="inquire_form" colspan="3">
			<textarea name="memo" id="memo" max=2000 msg="学习经历不超过2000个汉字"></textarea>
      	</td>
	</tr>
    <tr class="odd">
    <td colspan="4" class="ali4">
		<input name="Submit2" type="button" class="iButton2" onClick="save()" value="保存" />
    	<input name="Submit" type="button" class="iButton2"  onClick="cancel();" value="返回" />
    </td>
  </tr> 
</table>
</form>
</body>

<script type="text/javascript">
function save(){
	if(checkText()){
		return;
	}
	document.getElementById("form1").submit();
	
}
function cancel()
{
	window.location="<%=contextPath%>/market/contractPage/contractPageList.lpmd";
}
function checkText(){
	var contractNo=document.getElementById("contractNo").value;
	var contractName=document.getElementById("contractName").value;
	var undertakingOrg=document.getElementById("undertakingOrg").value;
	var partaOrg=document.getElementById("partaOrg").value;
	var contractType=document.getElementById("contractType").value;
	var contractMoney=document.getElementById("contractMoney").value;
	var workload=document.getElementById("workload").value;
	var unitPrice=document.getElementById("unitPrice").value;
	var marketType=document.getElementById("marketType").value;
	var contractStartDate=document.getElementById("contractStartDate").value;
	var contractEndDate=document.getElementById("contractEndDate").value;
	var signedTime=document.getElementById("signedTime").value;
	
	if(contractNo==""){
		alert("合同编号不能为空，请填写！");
		return true;
	}
	if(contractName==""){
		alert("合同名称不能为空，请填写！");
		return true;
	}
	if(partaOrg==""){
		alert("甲方单位不能为空，请选择！");
		return true;
	}
	if(undertakingOrg==""){
		alert("承担单位不能为空，请选择！");
		return true;
	}
	if(contractType==""){
		alert("合同类型不能为空，请选择！");
		return true;
	}
	if(contractMoney==""){
		alert("合同额不能为空，请选择！");
		return true;
	}
	if(workload==""){
		alert("工作量不能为空，请选择！");
		return true;
	}
	if(unitPrice==""){
		alert("单价不能为空，请选择！");
		return true;
	}
	if(signedTime==""){
		alert("合同签订日期不能为空，请选择！");
		return true;
	}
	if(contractStartDate==""){
		alert("项目启动日期不能为空，请选择！");
		return true;
	}
	if(contractEndDate==""){
		alert("项目结束日期不能为空，请选择！");
		return true;
	}
	
	
	var re = /^[0-9]+.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

    if (!re.test(contractMoney)||!re.test(unitPrice))
   {
       alert("合同额和单价请输入数字！");
       return true;
    }
	return false;
}

//选择申请单位
function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrg.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	 document.getElementById("undertakingOrgId").value = teamInfo.fkValue;
        document.getElementById("undertakingOrg").value = teamInfo.value;
    }
}
</script>
</html>
