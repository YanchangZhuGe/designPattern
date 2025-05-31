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
	String project_info_no = user.getProjectInfoNo();
	
	String paraId = request.getParameter("paraId")!=null?request.getParameter("paraId"):"";
	String pi = request.getParameter("pi")!=null?request.getParameter("pi"):"1";
	
	
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
 <body><!-- class="bgColor_f3f3f3"  onload="page_init()"> --> 
 <form name="fileForm" id="fileForm" method="post" action=""> <!--target="hidden_frame" enctype="multipart/form-data" --> 
 <div id="new_table_box" align="center">
  <div id="new_table_box_content"> 
  	<div id="new_table_box_bg">
    <table  width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
   		<input name="paraId" id="paraId" type="hidden" class="input_width" value="<%=paraId%>" />
    
     	<tr>
	    	<td class="inquire_item4"><font color="red">*</font>名称:</td>
	    	<td class="inquire_form4"><input name="field_name" id="field_name" type="text" class="input_width" value="" /></td>
	    </tr>
	    <tr>	
	    	<td class="inquire_item4"><font color="red">*</font>类型:</td>
			<td class="inquire_form4"><select id="field_type" name="field_type" class="select_width"><option value="0">字符</option><option value="1">数字</option></select></td>
	    </tr>
    	<tr>	
	    	<td class="inquire_item4"><font color="red">*</font>序号:</td>
	    	<td class="inquire_form4"><input name="field_order" id="field_order" type="text" class="input_width" value="" /></td>
	    </tr>
    	
    </table> 
  </div> 
  <div id="oper_div">
	<span class="bc_btn"><a href="#" onclick="newSubmit()"></a></span>
 	<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
  </div>
  </div> 
  </div>
</form> 
<script type="text/javascript">

cruConfig.contextPath = '<%=contextPath%>';
var	project_info_no = '<%=project_info_no%>';

var paraId = '<%=paraId%>';
if(paraId!=""&&paraId!='null'){
	getDataInfo(paraId);
}	
//读取数据
function getDataInfo(id){
	var retObj = jcdpCallService("WtWorkMethodSrv", "queryWtAfParaById", "paraId="+id);
	document.getElementById("field_name").value= retObj.afParaMap.FIELD_NAME != undefined ? retObj.afParaMap.FIELD_NAME:"";
	document.getElementById("field_type").value= retObj.afParaMap.FIELD_TYPE != undefined ? retObj.afParaMap.FIELD_TYPE:"";
	document.getElementById("field_order").value= retObj.afParaMap.FIELD_ORDER != undefined ? retObj.afParaMap.FIELD_ORDER:"";

}



	

	function oilTypeChange(){
		var daily_oil_type = document.getElementById("daily_oil_type").value;
		if(daily_oil_type=='1'){
			document.getElementById("oil_unit_price").value = price_unit1;
		}else if(daily_oil_type=='2'){
			document.getElementById("oil_unit_price").value = price_unit2;
		}
	}
	function checkIfNum(){
		var element = event.srcElement;
		if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
			element.value = '';
		}
		if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
			return true;
		}
		else{
			alert("只能输入数字");
			return false;
		}
	}




	//提交
	var pi = '<%=pi%>';
	//alert(pi+"##########3");

	function newSubmit() {
		if (!checkValue()) return;
		
		var field_name = document.getElementById("field_name").value ;
		var field_type = document.getElementById("field_type").value;
		var field_order = document.getElementById("field_order").value ;
		var paraId = document.getElementById("paraId").value ;
		
		var sql = "";
		if(paraId!=null && paraId!=''){
			
			sql = "update gp_wt_parameter_af_para t set t.field_name='"+field_name+"',t.field_type='"+field_type+"',t.field_order='"+field_order+"' "+" where t.id='"+paraId+"'";
		}else{
			sql = "insert into GP_WT_PARAMETER_AF_PARA(id,field_name,field_type,field_order) values((lower(sys_guid())),'"+field_name+"','"+field_type+"','"+field_order+"');";
		}
		var retObj = jcdpCallService("WtWorkMethodSrv","executeBySql", "sql="+sql);
		if(retObj!=null && retObj.returnCode == '0'){
			alert("保存成功!");
			top.frames['list'].refreshData(pi);
			
			newClose();
		}
	}
	function checkValue(){

		var field_name = document.getElementById("field_name").value ;
		var field_order = document.getElementById("field_order").value ;
		
		if(field_name ==null || field_name==''){
			alert("名称不能为空!");
			return false;
		}

		
				var pattern =/^[0-9]{1,9}$/;
				if(!pattern.exec(field_order)){
					alert("序号请输入数字");
					return false;
				}else{
					return true;
				}
			
		
	}
</script>
</body>
</html>