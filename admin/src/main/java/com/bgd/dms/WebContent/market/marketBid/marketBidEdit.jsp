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
	String market_bid_id = request.getParameter("market_bid_id");
	if(market_bid_id==null){
		market_bid_id = "";
	}
	String type_id = request.getParameter("type_id");
	if(type_id==null){
		type_id = "";
	}
	String type_name = request.getParameter("type_name");
	if(type_name==null){
		type_name = "";
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
<input type="hidden" name="market_bid_id" id="market_bid_id" value="<%=market_bid_id %>" />
<input type="hidden" name="user_id" id="user_id" value="<%=user_id %>"/>
<div id="new_table_box" align="center">
	<div id="new_table_box_content"> 
		<div id="new_table_box_bg">
			<table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		     	<tr>
			    	<td class="inquire_item4"><font color="red">*</font>国家:</td>
			    	<td class="inquire_form4"><input name="country" id="country" type="hidden" class="input_width" value="<%=type_id %>" />
			    		<input name="country_name" id="country_name" type="text" class="input_width" value="<%=type_name %>" readonly="readonly"/>
			    		<input onclick="selectType('1','country','country_name')" type="button" value="..."/></td>
			    	<td class="inquire_item4">工区:</td>
			    	<td class="inquire_form4"><input name="workarea" id="workarea" type="text" class="input_width" value="" /></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4"><font color="red">*</font>甲方:</td>
			    	<td class="inquire_form4"><input name="owner" id="owner" type="hidden" class="input_width" value="" />
			    		<input name="owner_name" id="owner_name" type="text" class="input_width" value="" readonly="readonly"/>
			    		<input onclick="selectType('2','owner','owner_name')" type="button" value="..."/></td>
			    	<td class="inquire_item4">工作量:</td>
			    	<td class="inquire_form4"><input name="workload" id="workload" type="text" class="input_width" value="" /></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4"><font color="red">*</font>邀标时间:</td>
			    	<td class="inquire_form4"><input name="start_bid_date" id="start_bid_date" type="text" class="input_width" value="" disabled="disabled"/>
						<img width="16" height="16" id="cal_button7" style="cursor: hand;" onmouseover="calDateSelector(start_bid_date,cal_button7);" src="<%=contextPath %>/images/calendar.gif" /></td>
			    	<td class="inquire_item4"><font color="red">*</font>闭标时间:</td>
			    	<td class="inquire_form4"><input name="end_bid_date" id="end_bid_date" type="text" class="input_width" value="" disabled="disabled"/>
			    		<img width="16" height="16" id="cal_button8" style="cursor: hand;" onmouseover="calDateSelector(end_bid_date,cal_button8);" src="<%=contextPath %>/images/calendar.gif" /></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4">开工日期:</td>
			    	<td class="inquire_form4"><input name="start_date" id="start_date" type="text" class="input_width" value="" disabled="disabled"/>
						<img width="16" height="16" id="cal_button9" style="cursor: hand;" onmouseover="calDateSelector(start_date,cal_button9);" src="<%=contextPath %>/images/calendar.gif" /></td>
			    	<td class="inquire_item4">立项时间:</td>
			    	<td class="inquire_form4"><input name="approve_date" id="approve_date" type="text" class="input_width" value="" disabled="disabled"/>
						<img width="16" height="16" id="cal_button6" style="cursor: hand;" onmouseover="calDateSelector(approve_date,cal_button6);" src="<%=contextPath %>/images/calendar.gif" /></td>
			    </tr>
			    <tr>
			    	<td class="inquire_item4">评标结果:</td>
			    	<td class="inquire_form4" > <select id="eva_result" name="eva_result">
			    			<option value="1">落标</option>
							<option value="2">弃标</option>
							<option value="3">未揭标</option>
							<option value="4">正在制作</option>
							<option value="5">中标</option>
			    		</select></td>
			    </tr>
			    <tr>
					<td class="inquire_item4">落/弃标原因分析：</td>
					<td class="inquire_form4" colspan="3"><textarea name="reason" id="reason" value="" class="textarea"></textarea></td>
				</tr>
				<tr>
					<td class="inquire_item4">备注：</td>
					<td class="inquire_form4" colspan="3"><textarea name="remark" id="remark" value="" class="textarea"></textarea></td>
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
		var id  = '<%=market_bid_id%>';
		var querySql = "SELECT t.*, decode(t.eva_result,'1','落标','2','弃标','3','未揭标',4,'正在制作','中标') result_name, sd1.type_name country_name, sd2.company_short_name owner_name FROM BGP_MARKET_BID T inner join bgp_market_company_type sd1    on t.country = sd1.type_id inner join bgp_market_oil_company sd2    on t.owner = sd2.company_id WHERE t.BSFLAG = '0' and t.market_bid_id='"+id+"'";				 	 
    	retObj = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj.returnCode=='0'){
			if(retObj.datas != null && retObj.datas.length>0){
				datas = retObj.datas[0];
				document.getElementById("market_bid_id").value = id;
				document.getElementById("country").value = datas.country;
				document.getElementById("country_name").value = datas.country_name;
				document.getElementById("workarea").value = datas.workarea;
				document.getElementById("owner").value = datas.owner;
				document.getElementById("owner_name").value = datas.owner_name;
				document.getElementById("workload").value = datas.workload;
				document.getElementById("start_bid_date").value = datas.start_bid_date;
				document.getElementById("end_bid_date").value =datas.end_bid_date;
				document.getElementById("start_date").value =datas.start_date;
				document.getElementById("approve_date").value =datas.approve_date;
				var index = datas.eva_result;
				document.getElementById("eva_result").options[index-1].selected = true;
				document.getElementById("reason").value =datas.reason;
				document.getElementById("remark").value =datas.remark;
			}
		}
	}
	refreshData();
	function newSubmit() {
		if(checkValue() == false){
			return ;
		}
		var market_bid_id = document.getElementById("market_bid_id").value;
		var user_id = document.getElementById("user_id").value;
		var country = document.getElementById("country").value;
		var workarea = document.getElementById("workarea").value;
		var owner = document.getElementById("owner").value ;
		var workload = document.getElementById("workload").value ;
		var start_bid_date = document.getElementById("start_bid_date").value ;
		var end_bid_date = document.getElementById("end_bid_date").value ;
		var start_date = document.getElementById("start_date").value ;
		var approve_date = document.getElementById("approve_date").value ;
		var eva_result = document.getElementById("eva_result").value ;
		var reason = document.getElementById("reason").value ;
		var remark = document.getElementById("remark").value ;
		if(market_bid_id!=null && market_bid_id!=''){
			var substr = "update bgp_market_bid t set t.market_bid_id ='"+market_bid_id+"' ,t.updator='"+user_id+"' ," +
			" t.modifi_date = sysdate ,t.country ='"+country+"', t.workarea ='"+workarea+"' , t.reason='"+reason+"' ,"+
			" t.owner ='"+owner+"', t.workload ='"+workload+"' ,t.start_bid_date =to_date('"+start_bid_date+"','yyyy-MM-dd') ,"+
			" t.end_bid_date =to_date('"+end_bid_date+"','yyyy-MM-dd') ,t.start_date =to_date('"+start_date+"','yyyy-MM-dd') ,"+
			" t.approve_date =to_date('"+approve_date+"','yyyy-MM-dd') ,t.eva_result ='"+eva_result+"' ,t.remark='"+remark+"'"+
			" where t.market_bid_id ='"+market_bid_id+"';" 
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("保存成功!");
					var ctt = top.frames('list');
					var type_id = '<%=type_id%>';
					var type_name = '<%=type_name%>';
					ctt.frames[1].refreshData(type_id,type_name);
					newClose(); 
				}
			}
		}else{
			var substr = "insert into bgp_market_bid(market_bid_id ,country ,workarea ,owner ,workload ,"+
			" start_bid_date ,end_bid_date ,start_date ,approve_date ,eva_result ,reason ,remark ,"+
			" bsflag ,create_date,creator ,modifi_date ,updator) "+
			" values((select lower(sys_guid()) from dual),'"+country+"' ,'"+workarea+"' ,'"+owner+"','"+workload+"' ," +
			" to_date('"+start_bid_date+"','yyyy-MM-dd'), to_date('"+end_bid_date+"','yyyy-MM-dd'), "+
			" to_date('"+start_date+"','yyyy-MM-dd'), to_date('"+approve_date+"','yyyy-MM-dd'), '"+eva_result+"' ," +
			" '"+reason+"' ,'"+remark+"' ,'0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');"
			
			if(substr!=''){
				var retObj = jcdpCallService("ClientRelationSrv", "saveClientRelation", "sql="+substr);
				if(retObj.returnCode =='0'){
					alert("保存成功!");
					var ctt = top.frames('list');
					var type_id = '<%=type_id%>';
					var type_name = '<%=type_name%>';
					ctt.frames[1].refreshData(type_id,type_name);
					newClose(); 
				}
			}
		}
	}
	function checkValue(){
		var obj = document.getElementById("country") ;
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("国家不能为空!");
			return false;
		}
		obj = document.getElementById("owner") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("甲方不能为空!");
			return false;
		}
		obj = document.getElementById("start_bid_date") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("邀标时间不能为空!");
			return false;
		}
		obj = document.getElementById("end_bid_date") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("闭标时间不能为空!");
			return false;
		}
	}
	function selectType(select ,id ,name){
		var type_id = '<%=type_id%>';
	    var company_type = {
	        fkValue:"",
	        name:"",
	        short_name:""
	    };
	    if(select !=null && select=='1'){
	    	window.showModalDialog('<%=contextPath%>/market/marketBid/selectCountry.jsp?key_id='+type_id,company_type,'dialogWidth=400px;dialogHeight=600px');
	    }else if(select !=null && select=='2'){
	    	var key_id = document.getElementById("country").value;
	    	if(key_id !=null){
	    		type_id = key_id;
	    	}
	    	window.showModalDialog('<%=contextPath%>/market/marketBid/selectCompany.jsp?key_id='+type_id,company_type,'dialogWidth=400px;dialogHeight=600px');
	    }
	    if(company_type.fkValue!=null && company_type.fkValue !=""){
			document.getElementById(id).value = company_type.fkValue;
			document.getElementById(name).value = company_type.short_name;
	    }
	}
</script>
</body>
</html>