<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/Calendar1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>查询条件</title>
</head>
<body class="bgColor_f3f3f3">
<form name="fileForm" id="fileForm" method="post" action="<%=contextPath%>/rm/dm/deviceAccount/importFile_t.jsp" enctype="multipart/form-data" target="targetIframe"> 
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
          <td class="inquire_item4">设备名称:</td>
          <td class="inquire_form4"><input name="dev_name" id="dev_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">规格型号:</td>
          <td class="inquire_form4"><input name="dev_model" id="dev_model" class="input_width" type="text" /></td>
        </tr>
        
        <tr>
          <td class="inquire_item4">设备编码:</td>
          <td class="inquire_form4"><input name="dev_type" class="input_width" type="text" /></td>
          <td class="inquire_item4">资产状况:</td>
          <td class="inquire_form4"><select name="account_stat" class="select_width">
            			<option value="">--请选择--</option>
      					<option value="0110000013000000001">报废</option>
            </select></td> 
          
        </tr>
		<tr>
		  <td class="inquire_item4">实物标识号:</td>
          <td class="inquire_form4"><input name="dev_sign" class="input_width" type="text" /></td>
          <td class="inquire_item4">自编号:</td>
          <td class="inquire_form4"><input name="self_num" class="input_width" type="text" /></td>
          
        </tr>
		<tr>
		  <td class="inquire_item4">牌照号:</td>
          <td class="inquire_form4"><input name="license_num" class="input_width" type="text" /></td>
          <td class="inquire_item4">AMIS资产编号:</td>
          <td class="inquire_form4"><input name="asset_coding" class="input_width" type="text" /></td>
        </tr>
        <tr>
		  <td class="inquire_item4">所属单位:</td>
          <td class="inquire_form4"><input name="owning_org_name" id='owning_org_name' class="input_width" type="text" />
          <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
			<input id="owning_org_id" name="owning_org_id" class="" type="hidden" />
			</td>
          <td class="inquire_item4">投产日期:</td>
          <td class="inquire_form4"><input name="producting_date" class="input_width" type="text" /></td>
        </tr>
		<tr>
		  <td class="inquire_item4">使用情况:</td>
          <td class="inquire_form4"><select name="using_stat" class="select_width">
            			<option value="">--请选择--</option>
            			<option value="0110000007000000002">闲置</option>
            			<option value="0110000007000000001">在用</option>
      					<option value="0110000007000000006">其他</option>
            </select></td>
          <td class="inquire_item4">技术状况:</td>
          <td class="inquire_form4"><select name="tech_stat" class="select_width">
            			<option value="">--请选择--</option>
            			<option value="0110000006000000001">完好</option>
            			<option value="0110000006000000006">待修</option>
      					<option value="0110000006000000007">在修</option>
      					<option value="0110000006000000005">待报废</option>
      					<option value="0110000006000000013">待验收</option>
      					
            </select></td>
        </tr>
        <tr>
          <td class="inquire_item4">ERP设备编号:</td>
          <td class="inquire_form4"><input name="dev_coding" class="input_width" type="text" /></td>
          <td class="inquire_item4">合同编号:</td>
          <td class="inquire_form4"><input name="cont_num" class="input_width" type="text" /></td>
        </tr>
      </table>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
<iframe id="targetIframe" name="targetIframe" style="display: none">
</iframe>
</body>
<script type="text/javascript"> 

	var content = "";
	function submitInfo(){
		var arrayObj = new Array();
		var t=document.getElementById("table1").childNodes.item(0);
   		for(var i=0;i< t.childNodes.length;i++){
    		for(var j=1;j<t.childNodes(i).childNodes.length;j=j+2){
    	       if(t.childNodes(i).childNodes[j].firstChild.name !='owning_org_name' 
        	       && t.childNodes(i).childNodes[j].firstChild.name !='start_date'){
          			arrayObj.push({"label":t.childNodes(i).childNodes[j].firstChild.name,"value":t.childNodes(i).childNodes[j].firstChild.value}); 
    	       }
          }
    	}
   		arrayObj.push({"label":"owning_sub_id","value":document.getElementById("owning_org_id").value});
    	var ctt = parent.frames['list'].frames[0];
	    ctt.refreshData(arrayObj,content);
		newClose();
	}
	 /**
	 * 选择组织机构树
	 */
	 
	function showOrgTreePage(){
		var returnValue={
			fkValue:"",
			value:""
		}
		window.showModalDialog("<%=contextPath%>/common/selectOrgSub.jsp",returnValue,"");
		document.getElementById("owning_org_name").value = returnValue.value;
		
		//var orgId = strs[1].split(":");
		document.getElementById("owning_org_id").value = returnValue.fkValue;
	}	
</script>
</html>

