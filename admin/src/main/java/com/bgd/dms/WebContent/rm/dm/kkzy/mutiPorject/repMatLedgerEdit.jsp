<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubjectionId = request.getParameter("orgSubjectionId");
	String orgId = request.getParameter("orgId");
	String ifOrgSubjectionId = "";
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>物资台账编辑管理</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels2.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
</head>
<body onload=init()>
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<input type="hidden" name="recyclemat_info" id='recyclemat_info'class="input_width" value="<gms:msg msgTag="matInfo" key="recyclemat_info"/>"/>
  	<tr>
    	<td colspan="4" align="center">可控震源台账编辑</td>
    </tr>
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>物资编码：</td>
      	<td class="inquire_form4"><input type="text" name="wz_id" id = 'wz_id' class="input_width" value="<gms:msg msgTag="matInfo" key="wz_id"/>" readonly="readonly"/><img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="toChoseWz()"/></td>
      	<td class="inquire_item4">计量单位</td>
      	<td class="inquire_form4"><input type="text" name="wz_prickie" id='wz_prickie' class="input_width" value="<gms:msg msgTag="matInfo" key="wz_prickie"/>"  readonly/></td>
    </tr>
    <tr>
    	<td class="inquire_item4">实际单价：</td>
      	<td class="inquire_form4"><input type="text" name="actual_price" id ='actual_price'class="input_width" value="<gms:msg msgTag="matInfo" key="actual_price"/>"/></td>
		<td class="inquire_item4">数量：</td>
      	<td class="inquire_form4"><input type="text" name="stock_num" id = 'stock_num' class="input_width" value="<gms:msg msgTag="matInfo" key="stock_num"/>"/></td>
    </tr>  

     <tr>
     <td class="inquire_item4">序列号：</td>
      	<td class="inquire_form4"><input type="text" name="wz_sequence" id ='wz_sequence'class="input_width" value="<gms:msg msgTag="matInfo" key="wz_sequence"/>"/></td>
    </tr>
</table>
</div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">

	function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
    }
    
    function init(){
        if(getQueryString("codeName")==null){
        	document.getElementById("coding_code_id").value = "<gms:msg msgTag="matInfo" key="codingCodeId"/>";
            }
        else{
		document.getElementById("coding_code_id").value = getQueryString("codeName");
        }
        }								
	function save(){	
		if (!checkForm()) return;
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toSaveSparePartsAllInfos.srq";
		document.getElementById("form1").submit();	
	}
	
	function toChoseWz(){
		var obj = new Object();
		var vReturnValue = window.showModalDialog('<%=contextPath%>/mat/multiproject/matLed/repmat/selectMatList.jsp',obj,'dialogWidth=1024px;dialogHigth=400px');
		if(vReturnValue!=undefined){
			var ids = vReturnValue.split(",");
			var wz_id = ids[0];
			var wz_prickie = ids[1];
			
			document.getElementById("wz_id").value = wz_id;
			document.getElementById("wz_prickie").value = wz_prickie;
			}
	}
	
	
	function checkForm(){ 	
		if (!isTextPropertyNotNull("wz_id", "物资编码")) {		
			document.form1.doc_number.focus();
			return false;	
		}
		return true;
	}		
</script>
</html>