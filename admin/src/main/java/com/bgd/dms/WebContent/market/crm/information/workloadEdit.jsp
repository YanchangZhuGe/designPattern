<%@page import="java.text.SimpleDateFormat"%>
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
	String company_name = request.getParameter("company_name");
	//company_name = decode(company_name);
	if(company_name==null){
		company_name = "";
	}
	String workload_id = request.getParameter("workload_id");
	if(workload_id==null){
		workload_id = "";
	}
	SimpleDateFormat sd = new SimpleDateFormat("yyyy");
	int end = Integer.parseInt(sd.format(new Date()));
	
	int start = end - 5;
	
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
<input type="hidden" name="workload_id" id="workload_id" value="<%=workload_id %>"/>
<input type="hidden" name="company_id" id="company_id" value="<%=company_id %>"/>
<input type="hidden" name="user_id" id="user_id" value="<%=user_id %>"/>
<div id="new_table_box" align="center">
	<div id="new_table_box_content"> 
		<div id="new_table_box_bg">
			<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		     	<tr>
			    	<td class="inquire_item4"><font color="red">*</font>记录年度:</td>
			    	<td class="inquire_form4"><select name="workload_year" id="workload_year" class="select_width">
			    			<%for(int i=end ;i>=start ;i--){%>
			    			<option value="<%=i%>"><%=i %></option>
			    			<% }%>
			    		</select></td>
			    	<td class="inquire_item4"><font color="red">*</font>工作量:</td>
			    	<td class="inquire_form4"><input name="workload" id="workload" type="text" class="input_width" value="" /></td>
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
		cruConfig.pageSize = cruConfig.pageSizeMax;
		var querySql ="select t.workload_id ,t.workload_year ,t.workload ,t.company_id ,c.company_short_name"+
		" from bgp_market_workload t" +
		" left join bgp_market_oil_company c on t.company_id = c.company_id and c.bsflag='0' " +
    	" where t.bsflag = '0' and t.workload_id = '<%=workload_id%>'";
    	retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.returnCode=='0'){
			if(retObj.datas != null && retObj.datas.length>0){
				datas = retObj.datas[0];
				document.getElementById("workload").value = datas.workload;
				var obj = document.getElementById("workload_year").options ;
				for(var i=0;i<obj.length;i++){
					var option = obj[i].value;
					if(option == datas.workload_year){
						obj[i].selected = true;
						break;
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
		var workload_id = '<%=workload_id%>';
		var company_id = document.getElementById("company_id").value;
		var user_id = document.getElementById("user_id").value;
		var workload_year = document.getElementById("workload_year").value;
		var workload = document.getElementById("workload").value ;
		if(workload_id!=null && workload_id!=''){
			var substr = "update bgp_market_workload t set t.company_id ='"+company_id+"' ,t.updator_id='"+user_id+"' ,t.modifi_date = sysdate ," +
			" t.workload_year ='"+workload_year+"' ,t.workload ='"+workload+"' ,workload_id='"+workload_id+"'" +
			" where t.workload_id ='"+workload_id+"';" 
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("保存成功!");
					var ctt = top.frames('list');
					ctt.frames[1].workload.refreshData();
					newClose(); 
				}
			}
		}else{
			var substr ="insert into bgp_market_workload(workload_id ,workload_year  ,"+
			" workload ,company_id ,bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
			" values((select lower(sys_guid()) from dual),'"+workload_year+"' ,'"+workload+"' ,'"+company_id+"' ," +
			" '0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');"
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("保存成功!");
					var ctt = top.frames('list');
					ctt.frames[1].workload.refreshData();
					//ctt.frames[1].refreshData();
					newClose(); 
				}
			}
		}
	}
	function checkValue(){
		var obj = document.getElementById("workload") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("工作量不能为空!");
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