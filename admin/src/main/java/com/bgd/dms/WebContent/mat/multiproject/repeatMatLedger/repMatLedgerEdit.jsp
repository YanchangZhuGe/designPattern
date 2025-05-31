<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
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
<form name="form1" id="form1" method="post" action="<%=contextPath%>/mat/multiproject/repMatLedger/updateRepMatLedger.srq">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
	<table  border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
	<input type="hidden" name="recyclemat_info" class="input_width" value="<gms:msg msgTag="matInfo" key="recyclematInfo"/>"/>
  	<tr>
    	<td colspan="4" align="center">物资台账编辑</td>
    </tr>
    <tr>
    	<td class="inquire_item4">物资分类</td>
    	<td class="inquire_form4"><input type="text" name="coding_code_id" id="coding_code_id" class="input_width" value="" readonly/></td>
    </tr>
    <tr>
    	<td class="inquire_item4"><font color="red">*</font>物资名称：</td>
      	<td class="inquire_form4"><input type="text" name="wz_name" class="input_width" value="<gms:msg msgTag="matInfo" key="wzName" />" readonly/></td>
      	<td class="inquire_item4">物资编码：</td>
      	<td class="inquire_form4"><input type="text" name="wz_code" class="input_width" value="<gms:msg msgTag="matInfo" key="wzCode" />" readonly/></td>
    </tr>
    <tr>
    	<td class="inquire_item4">计量单位：</td>
      	<td class="inquire_form4"><input type="text" name="wz_prickie" class="input_width" value="<gms:msg msgTag="matInfo" key="wzPrickie" />" readonly/></td>
		<td class="inquire_item4">参考单价：</td>
      	<td class="inquire_form4"><input type="text" name="wz_price" class="input_width" value="<gms:msg msgTag="matInfo" key="wzPrice" />" readonly/></td>
    </tr>    
   <tr>
      	<td class="inquire_item4">使用描述</td>
      	<td class="inquire_form4"><input type="text" name="describe" class="input_width" value="<gms:msg msgTag="matInfo" key="describe"/>" readonly/></td>
      	<td class="inquire_item4">库存数量</td>
      	<td class="inquire_form4"><input type="text" name="stock_num" class="input_width" value="<gms:msg msgTag="matInfo" key="stockNum"/>"/></td>
    </tr> 
    <tr>
		<td class="inquire_item4">备注：</td>
      	<td class="inquire_form4"><input type="text" name="note" class="input_width" value="<gms:msg msgTag="matInfo" key="note"/>" readonly/></td>
      	<td class="inquire_item4">实际单价</td>
      	<td class="inquire_form4"><input type="text" name="actual_price" class="input_width" value="<gms:msg msgTag="matInfo" key="actualPrice"/>"/></td>
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
		
		document.getElementById("form1").submit();
	}
	function checkForm(){ 	
	
		if (!isTextPropertyNotNull("wz_name", "物资名称")) {		
			document.form1.doc_number.focus();
			return false;	
		}
		return true;
	}		
</script>
</html>