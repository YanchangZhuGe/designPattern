<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@ page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String week_date = request.getParameter("week_date");
	String week_end_date = request.getParameter("week_end_date");
	String org_id = request.getParameter("org_id");
	Date now = new Date();
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

<body class="bgColor_f3f3f3"  onload="refreshData()">
      	<fieldSet style="margin-left:2px"><legend>下属单位信息</legend>
      	<div id="list_table" >
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
			      <td class="bt_info_even" autoOrder="1" exp="<input type='hidden' name='qwe' value='{work_hour_id}' id='' onclick='loadDataDetail();'/>">序号</td> 
			      <td class="bt_info_odd" exp="{org_name}">单位</td>
			      <td class="bt_info_even" exp="{safe_times}">安全观察沟通次数/周</td>
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
		  </div>
		  </fieldSet>
</body>

<script type="text/javascript">
$("#table_box").css("height",$(window).height()-55);
	cruConfig.contextPath =  "<%=contextPath%>";
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select ws.*,i.org_abbreviation as org_name from bgp_hse_common c join bgp_hse_week_safe ws on c.hse_common_id=ws.hse_common_id  join comm_org_subjection s on c.org_id = s.org_subjection_id and s.bsflag='0' join comm_org_information i on s.org_id=i.org_id and i.bsflag='0' where c.bsflag='0' and s.father_org_id='<%=org_id%>' and c.week_start_date=to_date('<%=week_date%>','yyyy-MM-dd') order by c.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("rdo_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	function clearQueryText(){
		document.getElementById("accidentName").value = "";
	}
	
	function loadDataDetail(shuaId){
		var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("HseSrv", "viewAccident", "hse_accident_id="+shuaId);
			
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("HseSrv", "viewAccident", "hse_accident_id="+ids);
		}
		document.getElementById("hse_accident_id").value =retObj.map.hseAccidentId;
		document.getElementById("second_org").value =retObj.map.secondOrg;
		document.getElementById("third_org").value =retObj.map.thirdOrg;
		document.getElementById("second_org2").value =retObj.map.secondOrgName;
		document.getElementById("third_org2").value =retObj.map.thirdOrgName;
		document.getElementById("accident_name").value =retObj.map.accidentName;
		document.getElementById("accident_type").value = retObj.map.accidentType;
		document.getElementById("accident_date").value = retObj.map.accidentDate;
		document.getElementById("accident_place").value = retObj.map.accidentPlace;
		document.getElementById("workplace_flag").value = retObj.map.workplaceFlag;
		document.getElementById("out_flag").value = retObj.map.outFlag;
		document.getElementById("out_type").value = retObj.map.outType;
		document.getElementById("out_name").value = retObj.map.outName;
		document.getElementById("accident_money").value = retObj.map.accidentMoney;
		document.getElementById("number_die").value = retObj.map.numberDie;
		document.getElementById("number_harm").value = retObj.map.numberHarm;
		document.getElementById("number_injure").value = retObj.map.numberInjure;
		document.getElementById("number_lose").value = retObj.map.numberLose;
		document.getElementById("accident_process").value = retObj.map.accidentProcess;
		document.getElementById("accident_reason").value = retObj.map.accidentReason;
		document.getElementById("accident_result").value = retObj.map.accidentResult;
		document.getElementById("accident_sugg").value = retObj.map.accidentSugg;
		document.getElementById("write_date").value = retObj.map.writeDate;
		document.getElementById("write_name").value = retObj.map.writeName;
		document.getElementById("duty_name").value = retObj.map.dutyName;
		
	}

	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/accidentNews/addAccident.jsp");
		
	}
	
	function toEdit(){  
		var hse_accident_id = document.getElementById("hse_accident_id").value;
	  	if(hse_accident_id==''||hse_accident_id==null){  
	  		alert("请选择一条信息!");  
	  		return;  
	  	}  
	  	popWindow("<%=contextPath%>/hse/viewAccident.srq?hse_accident_id="+hse_accident_id);
	  	
	} 
	
	function toUpdate(){  
		var form = document.getElementById("form");
		form.action="<%=contextPath%>/hse/accident/updateNewsInfo.srq";
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
		form.submit();
	} 
	
	
	function checkText0(){
		var second_org=document.getElementById("second_org").value;
		var third_org=document.getElementById("third_org").value;
		var accident_name=document.getElementById("accident_name").value;
		var accident_type=document.getElementById("accident_type").value;
		var accident_date=document.getElementById("accident_date").value;
		var accident_place=document.getElementById("accident_place").value;
		var workplace_flag = document.getElementById("workplace_flag").value;
		var accident_money = document.getElementById("accident_money").value;
		var out_flag = document.getElementById("out_flag").value;
		var out_name = document.getElementById("out_name").value;
		var out_type = document.getElementById("out_type").value;
		if(second_org==""){
			alert("二级单位不能为空，请填写！");
			return true;
		}
		if(third_org==""){
			alert("基层单位不能为空，请填写！");
			return true;
		}
		if(accident_name==""){
			alert("事故名称不能为空，请填写！");
			return true;
		}
		if(accident_type==""){
			alert("事故类型不能为空，请选择！");
			return true;
		}
		if(accident_date==""){
			alert("事故日期不能为空，请填写！");
			return true;
		}
		if(accident_place==""){
			alert("事故地点不能为空，请填写！");
			return true;
		}
		if(workplace_flag==""){
			alert("是否属于工作场所不能为空，请选择！");
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
			if(out_type==""){
				alert("承包商类型不能为空，请选择！");
				return true;
			}
		}
		if(accident_money==""){
			alert("初步估计经济损失不能为空，请填写！");
			return true;
		}
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

	    if (!re.test(accident_money))
	   {
	       alert("初步估计经济损失请输入数字！");
	       return true;
	    }
		return false;
	}

	function checkText1(){
		var number_die = document.getElementById("number_die").value;
		var number_harm=document.getElementById("number_harm").value;
		var number_injure=document.getElementById("number_injure").value;
		var number_lose=document.getElementById("number_lose").value;
		var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

	    
		if(number_die==""){
			alert("死亡人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_die))
		   {
		       alert("死亡人数请输入数字！");
		       return true;
		    }
		if(number_harm==""){
			alert("重伤人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_harm))
		   {
		       alert("重伤人数请输入数字！");
		       return true;
		    }
		if(number_injure==""){
			alert("轻伤人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_injure))
		   {
		       alert("轻伤人数请输入数字！");
		       return true;
		    }
		if(number_lose==""){
			alert("失踪人数不能为空，请填写！");
			return true;
		}
		if (!re.test(number_lose))
		   {
		       alert("失踪人数请输入数字！");
		       return true;
		    }
		return false;
	}

	function checkText2(){
		debugger;
		var write_date=document.getElementById("write_date").value;
		var write_name=document.getElementById("write_name").value;
		var duty_name = document.getElementById("duty_name").value;
		var accident_process=document.getElementById("accident_process").value;
		var accident_reason=document.getElementById("accident_reason").value;
		var accident_result=document.getElementById("accident_result").value;
		var accident_sugg=document.getElementById("accident_sugg").value;
		if(write_date==""){
			alert("填报日期不能为空，请填写！");
			return true;
		}
		if(write_name==""){
			alert("填报人不能为空，请填写！");
			return true;
		}
		if(duty_name==""){
			alert("负责人不能为空，请填写！");
			return true;
		}
		if(accident_process==""){
			alert("事故简要经过不能为空，请填写！");
			return true;
		}
		if(accident_process.length<50){
			alert("事故简要经过不得小于50字！");
			return true;
		}
		if(accident_reason==""){
			alert("初步原因分析不能为空，请填写！");
			return true;
		}
		if(accident_reason.length<30){
			alert("初步原因分析不得小于30字！");
			return true;
		}
		if(accident_result==""){
			alert("目前处理情况不能为空，请填写！");
			return true;
		}
		if(accident_sugg==""){
			alert("意见不能为空，请选择！");
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
			var retObj = jcdpCallService("HseSrv", "deleteAccident", "hse_accident_id="+ids);
			queryData(cruConfig.currentPage);
		}
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/accidentNews/accident_search.jsp");
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

