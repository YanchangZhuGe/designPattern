<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String user_id = user.getUserId();
	String company_id = request.getParameter("company_id");
	if(company_id==null){
		company_id = "";
	}
	String contract_id = request.getParameter("contract_id");
	if(contract_id==null){
		contract_id = "";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head> 
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
		<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
		<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
		<script type="text/JavaScript" src="<%=contextPath%>/js/calendar-zh.js"></script>
		<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
  	<title></title> 
	</head> 
<body>
<input type="hidden" name="contract_id" id="contract_id" value="<%=contract_id %>"/>
<input type="hidden" name="company_id" id="company_id" value="<%=company_id %>"/>
<input type="hidden" name="user_id" id="user_id" value="<%=user_id %>"/>
<div id="new_table_box" align="center">
	<div id="new_table_box_content"> 
		<div id="new_table_box_bg">
			<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		     	<tr>
			    	<td class="inquire_item4"><font color="red">*</font>合同名称:</td>
			    	<td class="inquire_form4"><input name="contract_name" id="contract_name" type="text" class="input_width" value="" /></td>
			    	<td class="inquire_item4"><font color="red">*</font>乙方单位:</td>
			    	<td class="inquire_form4"><input type="hidden" name="org_id" id="org_id" value="" class="input_width" />
			    	<input name="org_name" id="org_name" type="text" class="input_width" value="" disabled="disabled"/>
					<img onclick="selectOrgHR('orgId','org_id','org_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td> 
			 	</tr>
			    <tr>
			    	<td class="inquire_item4">合同金额(万元):</td>
			    	<td class="inquire_form4"><input name="contract_money" id="contract_money" type="text" class="input_width" value="" /></td>
			    	<td class="inquire_item4"><font color="red">*</font>项目名称:</td>
			    	<td class="inquire_form4"><input name="project_info_no" id="project_info_no" type="text" class="input_width" value="" /></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4">是否招投标:</td>
			    	<td class="inquire_form4"><select id="contract_bid" name="contract_bid" class="select_width">
			    		<option value="1">是</option>
			    		<option value="0">否</option>
			    		</select></td>
			    	<td class="inquire_item4">工作量:</td>
			    	<td class="inquire_form4"><input name="workload" id="workload" type="text" class="input_width" value="" /></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4">开始时间:</td>
			    	<td class="inquire_form4"><input name="start_date" id="start_date" type="text" class="input_width" value="" readonly="readonly"/>
			   			<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="calDateSelector(start_date,cal_button7);" src="<%=contextPath %>/images/calendar.gif" /></td>
			    	<td class="inquire_item4">执行单位:</td>
			    	<td class="inquire_form4"><input name="execution" id="execution" type="text" class="input_width" value="" /></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4">结束时间:</td>
			    	<td class="inquire_form4"><input name="end_date" id=end_date type="text" class="input_width" value="" readonly="readonly"/>
			   			<img width="16" height="16" id="cal_button8" style="cursor: hand;" onmouseover="calDateSelector(end_date,cal_button8);" src="<%=contextPath %>/images/calendar.gif" /></td>
			    	<td class="inquire_item4">合同地点:</td>
			    	<td class="inquire_form4"><input name="contract_place" id="contract_place" type="text" class="input_width" value="" /></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4">合同变更:</td>
			    	<td class="inquire_form4"><input name="contract_change" id="contract_change" type="text" class="input_width" value="" /></td>
			    </tr>
		    </table> 
		</div> 
		<div id="oper_div">
			<span class="tj_btn"><a href="#" onclick="newSubmit()"></a></span>
			<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
	</div> 
</div>
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function refreshData(){
		var id  = '<%=company_id%>';
		var querySql ="select t.contract_id ,t.contract_name ,t.contract_money ,t.contract_bid ,t.workload ,t.execution ,t.start_date ,t.end_date ,"+
		" t.contract_change ,t.contract_place ,t.project_info_no ,t.company_id ,t.org_id ,inf.org_abbreviation org_name ,t.org_subjection_id "+
		" from bgp_market_contract t" +
    	" join comm_org_information inf on t.org_id = inf.org_id and inf.bsflag='0' where t.bsflag = '0' and t.contract_id = '<%=contract_id%>'";
    	retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.returnCode=='0'){
			if(retObj.datas != null && retObj.datas.length>0){
				datas = retObj.datas[0];
				document.getElementById("company_id").value = id;
				document.getElementById("contract_name").value = datas.contract_name;
				document.getElementById("contract_money").value = datas.contract_money;
				document.getElementById("workload").value = datas.workload;
				document.getElementById("execution").value = datas.execution;
				document.getElementById("start_date").value = datas.start_date;
				document.getElementById("end_date").value = datas.end_date;
				document.getElementById("contract_change").value =datas.contract_change;
				document.getElementById("contract_place").value =datas.contract_place;
				document.getElementById("project_info_no").value =datas.project_info_no;
				document.getElementById("org_id").value =datas.org_id;
				document.getElementById("org_name").value =datas.org_name;
				var obj = document.getElementById("contract_bid").options ;
				for(var i=0;i<obj.length;i++){
					var option = obj[i].value;
					if(option == datas.contract_bid){
						obj[i].selected = true;
						return;
					}
				}
			}
		}
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var contract_id = '<%=contract_id%>';
		var company_id = document.getElementById("company_id").value;
		var user_id = document.getElementById("user_id").value;
		var contract_name = document.getElementById("contract_name").value;
		var contract_money = document.getElementById("contract_money").value;
		var contract_bid = document.getElementById("contract_bid").value ;
		var workload = document.getElementById("workload").value ;
		var execution = document.getElementById("execution").value ;
		var start_date = document.getElementById("start_date").value ;
		var end_date = document.getElementById("end_date").value ;
		var contract_change = document.getElementById("contract_change").value ;
		var contract_place = document.getElementById("contract_place").value ;
		var project_info_no = document.getElementById("project_info_no").value ;
		var org_id = document.getElementById("org_id").value ;
		if(contract_id!=null && contract_id!=''){
			var substr = "update bgp_market_contract t set t.company_id ='"+company_id+"' ,t.updator_id='"+user_id+"' ,t.modifi_date = sysdate ," +
			" t.contract_name ='"+contract_name+"', t.contract_money ='"+contract_money+"' , t.contract_bid ='"+contract_bid+"', t.workload ='"+workload+"' ,"+
			" t.execution ='"+execution+"' ,t.start_date=to_date('"+start_date+"','yyyy-MM-dd'), t.end_date=to_date('"+end_date+"','yyyy-MM-dd'),t.contract_change ='"+contract_change+"' ,"+
			" t.contract_place ='"+contract_place+"' ,project_info_no='"+project_info_no+"' ,contract_id='"+contract_id+"'" +
			" where t.contract_id ='"+contract_id+"';" 
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("保存成功!");
					var ctt = top.frames('list');
					ctt.frames[1].contract.refreshData();
					ctt.frames[1].refreshData();
					newClose(); 
				}
			}
		}else{
			var substr ="insert into bgp_market_contract(contract_id ,contract_name ,contract_money ,contract_bid ,workload ,"+
			" execution ,start_date ,end_date ,contract_change ,contract_place ,project_info_no ,company_id ,org_id ," +
			" bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
			" values((select lower(sys_guid()) from dual),'"+contract_name+"' ,'"+contract_money+"' ,'"+contract_bid+"' ,'"+contract_bid+"' ,'"+execution+"' ,"+
			" to_date('"+start_date+"','yyyy-MM-dd') ,to_date('"+end_date+"','yyyy-MM-dd') ,'"+contract_change+"' , '" +contract_place+"' ,'"+project_info_no+"' ,'"+company_id+"' ,'"+org_id+"' ," +
			" '0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');"
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("保存成功!");
					var ctt = top.frames('list');
					ctt.frames[1].contract.refreshData();
					ctt.frames[1].refreshData();
					newClose(); 
				}
			}
		}
	}
	function checkValue(){
		var obj = document.getElementById("contract_name") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("合同名称不能为空!");
			return false;
		}
		obj = document.getElementById("org_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("乙方单位不能为空!");
			return false;
		}
		obj = document.getElementById("project_info_no") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("项目名称不能为空!");
			return false;
		}
	}
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgHR.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
</script>
</body>
</html>