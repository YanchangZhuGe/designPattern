<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dev_appdet_id = request.getParameter("device_acc_id");
	String ye= request.getParameter("ye");
	String me= request.getParameter("me");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>单设备类型的调配调剂</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:750px">
  <div id="new_table_box_content">
    <div id="new_table_box_bg" style="height:420px">
      <fieldset><legend>申请信息</legend>
	  <table id="monthofday" width="97%" border="0" cellspacing="0" cellpadding="0"  class="tab_info" align="center">
		  
	  </table>
	  </fieldset>
	  	
  	</div>
  </div>   
</div>
</form>
</body>
<script type="text/javascript"> 
	var dev_appdet_id='<%=dev_appdet_id%>';
	var ye='<%=ye%>';
	var me='<%=me%>';
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
	
	
	function submitInfo(){
		if(confirm("提交后数据不能修改，确认提交？")){
			//调配数量提交
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/deviceRepairInfo.srq?state=9";
			document.getElementById("form1").submit();
		}
	}
	var rownum=0;
	function addrow(){
		
		var materialUnitStr = '1,个@2,台@3,只';
		var optionStr=materialUnitStr.split("@");
		var ge_str='<option value="">请选择</option>';
		for(var i=0;i<optionStr.length;i++){
			ge_str+='<option value="'+optionStr[i].split(",")[0]+'" >'+optionStr[i].split(",")[1]+'</option>';
		}
		var material_str="<option value= >请选择</option><option value=0110000039000000001>滤芯类</option><option value=0110000039000000002>维修配件</option><option value=0110000039000000003>汽车轮胎</option><option value=0110000039000000004>其他材料</option><option value=0110000039000000005>可重复使用</option>";
		var newTr=assign_body.insertRow()
		newTr.insertCell().innerHTML="<input type=button value=删除 onclick=removrow(this)><input type=hidden name=rows id=rows"+rownum+" value="+rownum+">";
		newTr.insertCell().innerHTML="<select id=MATERIAL_TYPE"+rownum+" name=MATERIAL_TYPE"+rownum+">"+material_str+"</select>";
		newTr.insertCell().innerHTML="<input type=text id=MATERIAL_NAME"+rownum+" name=MATERIAL_NAME"+rownum+">";
		newTr.insertCell().innerHTML="<input type=text id=MATERIAL_SPEC"+rownum+" name=MATERIAL_SPEC"+rownum+">";
		newTr.insertCell().innerHTML="<input type=text id=MATERIAL_CODING"+rownum+" name=MATERIAL_CODING"+rownum+">";
		newTr.insertCell().innerHTML="<input type=text id=MATERIAL_AMOUT"+rownum+" name=MATERIAL_AMOUT"+rownum+">";
		newTr.insertCell().innerHTML="<select id=MATERIAL_UNIT"+rownum+" name=MATERIAL_UNIT"+rownum+">"+ge_str+"</select>";
		newTr.insertCell().innerHTML="<input type=text id=UNIT_PRICE"+rownum+" name=UNIT_PRICE"+rownum+">";
		newTr.insertCell().innerHTML="<input type=text id=TOTAL_CHARGE"+rownum+" name=TOTAL_CHARGE"+rownum+">";
		newTr.insertCell().innerHTML="<input type=text id=MATERIAL_USER"+rownum+" name=MATERIAL_USER"+rownum+">";
		newTr.insertCell().innerHTML="<input type=text id=MATERIAL_DISPATCHER"+rownum+" name=MATERIAL_DISPATCHER"+rownum+">";
		newTr.insertCell().innerHTML="<input type=text id=SPARE3"+rownum+" name=SPARE3"+rownum+">";
		
		$("#assign_body>tr:odd>td:odd").addClass("odd_odd");
		$("#assign_body>tr:odd>td:even").addClass("odd_even");
		$("#assign_body>tr:even>td:odd").addClass("even_odd");
		$("#assign_body>tr:even>td:even").addClass("even_even");
		rownum++;
	}
	function removrow(obj){
	
		obj.parentNode.parentNode.removeNode(true);
	}
	function loadDataDetail(){

		var row=monthofday.insertRow();
		var timp;
		for(var i=1;i<=35;i++){
			if(i<=31){
				timp=row.insertCell()
				timp.innerText=i;
				timp.align="center";
				if(i<10){
					timp.id="0"+i;
				}else{
					timp.id=i;
				}
			}
			
			if(i%7==0){
				row=monthofday.insertRow();
			}
		}
	
		
		
		//to_char(a.next_maintain_date,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month,to_char(a.NEXT_MAINTAIN_DATE,'dd') as day
		//where a.device_account_id='"+dev_appdet_id+" and to_char(a.NEXT_MAINTAIN_DATE,'yyyy')='"+ye+"' and to_char(a.NEXT_MAINTAIN_DATE,'mm')='"+me+"'"
		var querySql="select to_char(a.next_maintain_date,'yyyy') as Year,to_char(a.NEXT_MAINTAIN_DATE,'mm') as month,to_char(a.NEXT_MAINTAIN_DATE,'dd') as day,a.* from BGP_COMM_DEVICE_MAINTAIN a where a.device_account_id='"+dev_appdet_id+"' and to_char(a.NEXT_MAINTAIN_DATE,'yyyy')='"+ye+"' and to_char(a.NEXT_MAINTAIN_DATE,'mm')='"+me+"'";
		//var querySql="select dev_acc_id, dev_name,dev_model,dev_sign,self_num,license_num,asset_coding,owning_org_name,usage_org_name,dev_position,using_stat,tech_stat,asset_value,net_value,case account_stat when '0' then '账内' when '1' then '账外' else '外租' end as stat_desc from GMS_DEVICE_ACCOUNT_DUI where dev_acc_id='"+dev_appdet_id+"'" ;
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			var temp;
			for(var i=0;i<basedatas.length;i++){
				temp=document.getElementById(basedatas[i].day);
				
				temp.style.backgroundColor='red'
			}
		
	}
</script>
</html>
 