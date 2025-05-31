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
	String bid_id = request.getParameter("bid_id");
	if(bid_id==null){
		bid_id = "";
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
<input type="hidden" name="bid_id" id="bid_id" value="<%=bid_id %>"/>
<input type="hidden" name="company_id" id="company_id" value="<%=company_id %>"/>
<input type="hidden" name="user_id" id="user_id" value="<%=user_id %>"/>
<div id="new_table_box" align="center">
	<div id="new_table_box_content"> 
		<div id="new_table_box_bg">
			<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		     	<tr>
			    	<td class="inquire_item4"><font color="red">*</font>投标日期:</td>
			    	<td class="inquire_form4"><input name="bid_date" id="bid_date" type="text" class="input_width" value="" readonly="readonly"/>
			   			<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="calDateSelector(bid_date,cal_button7);" src="<%=contextPath %>/images/calendar.gif" /></td>
			   		<td class="inquire_item4"><font color="red">*</font>投标方:</td>
			    	<td class="inquire_form4"><input type="hidden" name="org_id" id="org_id" value="" class="input_width" />
			    	<input name="org_name" id="org_name" type="text" class="input_width" value="" disabled="disabled"/>
					<img onclick="selectOrgHR('orgId','org_id','org_name')" src="<%=contextPath %>/images/images/tree_12.png" width="16" height="16" style="cursor: hand;" /></td> 
			    </tr>
			    <tr>	
			    	<td class="inquire_item4">招投标方式:</td>
			    	<td class="inquire_form4"><select id="bid_type" name="bid_type" class="select_width">
			    		<option value="1">招标</option>
    					<option value="2">议标</option>
			    		</select></td>
			    	<td class="inquire_item4">投标结果:</td>
			    	<td class="inquire_form4"><select id="bid_result" name="bid_result" class="select_width">
			    		<option value="1">中标</option>
			    		<option value="2">弃标</option>
    					<option value="3">落标</option>
			    		</select></td>
			    </tr>
			    <tr>	
			    	<td class="inquire_item4">招标方:</td>
			    	<td class="inquire_form4"><input name="company_name" id="company_name" type="text" class="input_width" value="" readonly="readonly"/></td>
			    	<td class="inquire_item4">项目名称:</td>
			    	<td class="inquire_form4"><input name="project_info_no" id="project_info_no" type="text" class="input_width" value="" /></td> 
			    </tr>
			     <tr>	
			    	<td class="inquire_item4">工作量:</td>
			    	<td class="inquire_form4"><input name="workload" id="workload" type="text" class="input_width" value="" /></td>
			    	<td class="inquire_item4">原因分析:</td>
			    	<td class="inquire_form4"><input name="reason" id="reason" type="text" class="input_width" value="" /></td> 
			    </tr>
			    <tr>
			    	<td class="inquire_item4"><font color="red">*</font>招投标内容:</td>
			    	<td class="inquire_form4" colspan="3"><textarea id="bid_name" name="bid_name" rows="" cols=""  class="textarea" ></textarea></td>
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
		var querySql = "select t.bid_id ,t.bid_name ,t.bid_date ,t.bid_type ,t.bid_result ,t.company_id ,p.company_short_name company_name ,"+
		" t.org_id ,inf.org_abbreviation org_name ,t.workload ,t.reason ,t.project_info_no from bgp_market_bid t" +
		" join comm_org_information inf on t.org_id = inf.org_id and inf.bsflag='0' " +
    	" left join bgp_market_oil_company p on t.company_id = p.company_id and p.bsflag='0' where t.bsflag = '0' and t.bid_id = '<%=bid_id%>'";
    	retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.returnCode=='0'){
			if(retObj.datas != null && retObj.datas.length>0){
				datas = retObj.datas[0];
				document.getElementById("bid_name").value = datas.bid_name;
				document.getElementById("bid_date").value = datas.bid_date;
				document.getElementById("company_name").value = datas.company_name;
				document.getElementById("org_id").value =datas.org_id;
				document.getElementById("org_name").value =datas.org_name;
				document.getElementById("workload").value = datas.workload;
				document.getElementById("reason").value = datas.reason;
				document.getElementById("project_info_no").value = datas.project_info_no;
				var obj = document.getElementById("bid_type").options ;
				for(var i=0;i<obj.length;i++){
					var option = obj[i].value;
					if(option == datas.bid_type){
						obj[i].selected = true;
						break;
					}
				}
				obj = document.getElementById("bid_result").options ;
				for(var i=0;i<obj.length;i++){
					var option = obj[i].value;
					if(option == datas.bid_result){
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
		var bid_id = '<%=bid_id%>';
		var company_id = document.getElementById("company_id").value;
		var user_id = document.getElementById("user_id").value;
		var bid_name = document.getElementById("bid_name").value;
		var bid_date = document.getElementById("bid_date").value ;
		var bid_type = document.getElementById("bid_type").value ;
		var bid_result = document.getElementById("bid_result").value;
		var org_id = document.getElementById("org_id").value ;
		var workload = document.getElementById("workload").value ;
		var reason = document.getElementById("reason").value ;
		var project_info_no = document.getElementById("project_info_no").value ;
		if(bid_id!=null && bid_id!=''){
			var substr = "update bgp_market_bid t set t.company_id ='"+company_id+"' ,t.updator_id='"+user_id+"' ,t.modifi_date = sysdate ," +
			" t.bid_name ='"+bid_name+"', t.bid_date =to_date('"+bid_date+"','yyyy-MM-dd') ,t.org_id='"+org_id+"', t.bid_type ='"+bid_type+"' ," +
			" t.bid_result ='"+bid_result+"' ,t.workload='"+workload+"' ,t.reason='"+reason+"' ,t.project_info_no='"+project_info_no+"'" +
			" where t.bid_id ='"+bid_id+"';" 
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("保存成功!");
					var ctt = top.frames('list');
					ctt.frames[1].bid.refreshData();
					newClose(); 
				}
			}
		}else{
			var substr ="insert into bgp_market_bid(bid_id ,bid_name ,bid_date ,bid_type ,bid_result ,"+
			" workload ,reason ,company_id ,project_info_no ,org_id ,bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
			" values((select lower(sys_guid()) from dual),'"+bid_name+"' ,to_date('"+bid_date+"','yyyy-MM-dd') ,'"+bid_type+"' ,"+
			" '"+bid_result+"' ,'"+workload+"' ,'"+reason+"' ,'"+company_id+"' ,'"+project_info_no+"' ,'"+org_id+"' ," +
			" '0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');"
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("保存成功!");
					var ctt = top.frames('list');
					ctt.frames[1].bid.refreshData();
					newClose(); 
				}
			}
		}
	}
	function checkValue(){
		var obj = document.getElementById("bid_date") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("投标日期不能为空!");
			return false;
		}
		obj = document.getElementById("org_id") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("投标方不能为空!");
			return false;
		}
		obj = document.getElementById("bid_name") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("招投标内容不能为空!");
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