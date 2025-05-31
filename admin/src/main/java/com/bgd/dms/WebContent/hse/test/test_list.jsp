<%@page contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>无标题文档</title>
</head>

<body style="background:#fff"  onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">属性1</td>
			    <td class="ali_cdn_input"><input id="eventName" name="eventName" type="text" /></td>
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='toSerach()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{hse_event_id}' id='rdo_entity_id_{hse_enent_id}' onclick='loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td> 
			      <td class="bt_info_odd" exp="{}">属性1</td>
			      <td class="bt_info_even" exp="{}">属性2</td>
			      <td class="bt_info_odd" exp="{}">属性3</td>
			      <td class="bt_info_even" exp="{}">属性4</td>
			      <td class="bt_info_odd" exp="{}">属性5</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">属性1</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">属性2</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">属性3</a></li>
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
			<input type="hidden" id="hse_event_id" name="hse_event_id"></input>
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>属性1：</td>
					    <td class="inquire_form6"><input type="text" id="number_owner" name="number_owner" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性2：</td>
					    <td class="inquire_form6"><input type="text" id="number_out" name="number_out" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性3：</td>
					    <td class="inquire_form6"><input type="text" id="number_stock" name="number_stock" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>属性4：</td>
					    <td class="inquire_form6"><input type="text" id="number_owner" name="number_owner" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性5：</td>
					    <td class="inquire_form6"><input type="text" id="number_out" name="number_out" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性6：</td>
					    <td class="inquire_form6"><input type="text" id="number_stock" name="number_stock" class="input_width" /></td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					 <tr>
					    <td class="inquire_item6"><font color="red">*</font>属性11：</td>
					    <td class="inquire_form6"><input type="text" id="number_owner" name="number_owner" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性22：</td>
					    <td class="inquire_form6"><input type="text" id="number_out" name="number_out" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性33：</td>
					    <td class="inquire_form6"><input type="text" id="number_stock" name="number_stock" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>属性44：</td>
					    <td class="inquire_form6"><input type="text" id="number_owner" name="number_owner" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性55：</td>
					    <td class="inquire_form6"><input type="text" id="number_out" name="number_out" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性66：</td>
					    <td class="inquire_form6"><input type="text" id="number_stock" name="number_stock" class="input_width" /></td>
					</table>
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>属性111：</td>
					    <td class="inquire_form6"><input type="text" id="number_owner" name="number_owner" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性222：</td>
					    <td class="inquire_form6"><input type="text" id="number_out" name="number_out" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性333：</td>
					    <td class="inquire_form6"><input type="text" id="number_stock" name="number_stock" class="input_width" /></td>
					  </tr>
					  <tr>
					    <td class="inquire_item6"><font color="red">*</font>属性444：</td>
					    <td class="inquire_form6"><input type="text" id="number_owner" name="number_owner" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性555：</td>
					    <td class="inquire_form6"><input type="text" id="number_out" name="number_out" class="input_width" /></td>
					    <td class="inquire_item6"><font color="red">*</font>属性666：</td>
					    <td class="inquire_form6"><input type="text" id="number_stock" name="number_stock" class="input_width" /></td>
					  </tr>
					</table>
				</div>
				</form>
			</div>
		  </div>

</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">


	cruConfig.contextPath =  "<%=contextPath%>";
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "";
		cruConfig.currentPageUrl = "/hse/event/event_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/event/event_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
			var eventName = document.getElementById("eventName").value;
				if(eventName!=''&&eventName!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "select t.hse_event_id,t.second_org,t.third_org,t.event_name,t.event_date,t.event_place,decode(t.event_type,'1','工业生产安全事件','2','火灾事件','3','道路交通事件','4','其他事件') as event_type,decode(t.event_property,'1','限工事件','2','医疗事件','3','急救箱事件','4','经济损失事件','5','未遂事件') as event_property,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name,t.create_date,t.modifi_date from bgp_hse_event t join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' where t.bsflag = '0' and t.event_name like '%"+eventName+"%' order by t.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/event/event_list.jsp";
					queryData(1);
				}else{
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("eventName").value = "";
	}
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "viewEvent", "hse_event_id="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "viewEvent", "hse_event_id="+ids);
		}
		document.getElementById("hse_event_id").value =retObj.map.hseEventId;
		document.getElementById("second_org").value =retObj.map.secondOrg;
		document.getElementById("third_org").value =retObj.map.thirdOrg;
		document.getElementById("second_org2").value =retObj.map.secondOrgName;
		document.getElementById("third_org2").value =retObj.map.thirdOrgName;
		document.getElementById("event_name").value =retObj.map.eventName;
		document.getElementById("event_type").value = retObj.map.eventType;
		document.getElementById("event_property").value = retObj.map.eventProperty;
		document.getElementById("event_date").value = retObj.map.eventDate;
		document.getElementById("event_place").value = retObj.map.eventPlace;
		document.getElementById("write_date").value = retObj.map.writeDate;
		document.getElementById("out_flag").value = retObj.map.outFlag;
		document.getElementById("out_name").value = retObj.map.outName;
		document.getElementById("report_name").value = retObj.map.reportName;
		document.getElementById("report_date").value = retObj.map.reportDate;
		
		document.getElementById("number_owner").value = retObj.map.numberOwner;
		document.getElementById("number_out").value = retObj.map.numberOut;
		document.getElementById("number_stock").value = retObj.map.numberStock;
		document.getElementById("number_group").value = retObj.map.numberGroup;
		document.getElementById("number_hours").value = retObj.map.numberHours;
		
		document.getElementById("event_process").value = retObj.map.eventProcess;
		document.getElementById("event_reason").value = retObj.map.eventReason;
		document.getElementById("event_result").value = retObj.map.eventResult;
		document.getElementById("event_describe").value = retObj.map.eventDescribe;
		document.getElementById("analyze_name").value = retObj.map.analyzeName;
		document.getElementById("analyze_work").value = retObj.map.analyzeWork;
		document.getElementById("result_date").value = retObj.map.resultDate;
		document.getElementById("duty_name").value = retObj.map.dutyName;
		
		document.getElementById("first_money").value = retObj.map.firstMoney;
		document.getElementById("second_money").value = retObj.map.secondMoney;
		document.getElementById("all_money").value = retObj.map.allMoney;
		
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/event/addEvent.jsp");
		
	}
	
	function toEdit(){  
		var hse_event_id = document.getElementById("hse_event_id").value;
	  	if(hse_event_id==''||hse_event_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	popWindow("<%=contextPath%>/hse/viewEvent.srq?hse_event_id="+hse_event_id);
	  	
	} 
	
	function outMust(){
		if(document.getElementById("out_flag").value=="1"){
			document.getElementById("out_must").style.display="";
		}else{
			document.getElementById("out_must").style.display="none";
		}
	}
	
	function addMoney(){
		var first_money = document.getElementById("first_money").value;
		var second_money = document.getElementById("second_money").value;
		first_money = Number(first_money);
		second_money = Number(second_money);
		document.getElementById("all_money").value=first_money+second_money;
	}
	
	function toUpdate(){  
		var form = document.getElementById("form");
		form.action="<%=contextPath%>/hse/accident/updateEvent.srq";
		if(document.getElementById("tab_box_content0").style.display==""||document.getElementById("tab_box_content0").style.display=="block"){
			if(checkText0()){
				return;
			}
		}
		if(document.getElementById("tab_box_content1").style.display==""||document.getElementById("tab_box_content1").style.display=="block"){
			if(checkText1()){
				return;
			}
		}
		if(document.getElementById("tab_box_content2").style.display==""||document.getElementById("tab_box_content2").style.display=="block"){
			if(checkText2()){
				return;
			}
		}
		if(document.getElementById("tab_box_content3").style.display==""||document.getElementById("tab_box_content3").style.display=="block"){
			if(checkText3()){
				return;
			}
		}
		form.submit();
	} 
	
	
	function checkText0(){
		var second_org=document.getElementById("second_org").value;
		var third_org=document.getElementById("third_org").value;
		var event_name=document.getElementById("event_name").value;
		var event_type=document.getElementById("event_type").value;
		var event_property=document.getElementById("event_property").value;
		var event_date=document.getElementById("event_date").value;
		var event_place=document.getElementById("event_place").value;
		var write_date=document.getElementById("write_date").value;
		var out_flag = document.getElementById("out_flag").value;
		var out_name = document.getElementById("out_name").value;
		if(second_org==""){
			alert("二级单位不能为空，请填写！");
			return true;
		}
		if(third_org==""){
			alert("基层单位不能为空，请填写！");
			return true;
		}
		if(event_name==""){
			alert("事件名称不能为空，请填写！");
			return true;
		}
		if(event_type==""){
			alert("事件类型不能为空，请选择！");
			return true;
		}
		if(event_property==""){
			alert("事件性质不能为空，请选择！");
			return true;
		}
		if(event_date==""){
			alert("事件日期不能为空，请填写！");
			return true;
		}
		if(event_place==""){
			alert("事件地点不能为空，请填写！");
			return true;
		}
		if(write_date==""){
			alert("填报日期不能为空，请填写！");
			return true;
		}
		if(out_flag==""){
			alert("是否为承包商不能为空，请选择！");
			return true;
		}
		if(out_flag=="1"){
			if(out_name==""){
				alert("承包商名称不能为空，请填写！");
				return true;
			}
		}
		return false;
	}

	function checkText1(){
		var number_owner = document.getElementById("number_owner").value;
		var number_out=document.getElementById("number_out").value;
		var number_stock=document.getElementById("number_stock").value;
		var number_group=document.getElementById("number_group").value;
		var number_hours=document.getElementById("number_hours").value;
		var re = /^[0-9]+.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

	    
		if(number_owner==""){
			alert("本企业伤害人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_owner))
		   {
		       alert("本企业伤害人数请输入数字！");
		       return true;
		    }
		if(number_out==""){
			alert("外部承包商伤害人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_out))
		   {
		       alert("外部承包商伤害人数请输入数字！");
		       return true;
		    }
		if(number_stock==""){
			alert("股份承包商伤害人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_stock))
		   {
		       alert("股份承包商伤害人数请输入数字！");
		       return true;
		    }
		if(number_group==""){
			alert("集团承包商伤害人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_group))
		   {
		       alert("集团承包商伤害人数请输入数字！");
		       return true;
		    }
		if(number_hours==""){
			alert("限工工时不能为空，请填写！");
			return true;
		}
		if (!re.test(number_hours))
		   {
		       alert("限工工时请输入数字！");
		       return true;
		    }
		return false;
	}

	function checkText2(){
		var result_date=document.getElementById("result_date").value;
		var duty_name=document.getElementById("duty_name").value;
		var event_process=document.getElementById("event_process").value;
		var event_reason = document.getElementById("event_reason").value;
		var event_describe=document.getElementById("event_describe").value;
		var event_result=document.getElementById("event_result").value;
		if(result_date==""){
			alert("纠正预防措施完成时间不能为空，请填写！");
			return true;
		}
		if(duty_name==""){
			alert("责任人不能为空，请填写！");
			return true;
		}
		if(event_process==""){
			alert("事件经过描述不能为空，请填写！");
			return true;
		}
		if(event_reason==""){
			alert("事件原因不能为空，请填写！");
			return true;
		}
		if(event_describe==""){
			alert("事件原因描述不能为空，请填写！");
			return true;
		}
		if(event_result==""){
			alert("采取的纠正预防措施不能为空，请填写！");
			return true;
		}
		return false;
	}

	function checkText3(){
		var first_money = document.getElementById("first_money").value;
		var second_money = document.getElementById("second_money").value;
		var all_money = document.getElementById("all_money").value;
		var re = /^[0-9]+.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

	    
		if(first_money==""){
			alert("直接经济损失不能为空，请填写！");
			return true;
		}
		if (!re.test(first_money))
		   {
		       alert("直接经济损失请输入数字！");
		       return true;
		    }
		if(second_money==""){
			alert("间接经济损失不能为空，请填写！");
			return true;
		}
		if (!re.test(second_money))
		   {
		       alert("间接经济损失请输入数字！");
		       return true;
		    }
		if(all_money==""){
			alert("经济损失合计不能为空，请填写！");
			return true;
		}
		if (!re.test(all_money))
		   {
		       alert("经济损失合计请输入数字！");
		       return true;
		    }
		return false;
	}
	

	function toDelete(){
 		
	    ids = getSelIds('rdo_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
		    
		if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("HseSrv", "deleteEvent", "hse_event_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/event/event_search.jsp");
	}
	
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second_orgId = document.getElementById("second_org").value;
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	 document.getElementById("second_org").value = teamInfo.fkValue;
	        document.getElementById("second_org2").value = teamInfo.value;
	        if(second_orgId!=teamInfo.fkValue){
	        	document.getElementById("third_org").value = "";
		        document.getElementById("third_org2").value = "";
	        }
	    }
	}
	
	function selectOrg2(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    
	    var second = document.getElementById("second_org").value;
	    if(second==""||second==null){
	    	alert("请先选择二级单位！");
	    }else{
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgSubId='+second,teamInfo);
		    if(teamInfo.fkValue!=""){
		    	 document.getElementById("third_org").value = teamInfo.fkValue;
		        document.getElementById("third_org2").value = teamInfo.value;
		    }
	    }
	}
	
</script>

</html>

