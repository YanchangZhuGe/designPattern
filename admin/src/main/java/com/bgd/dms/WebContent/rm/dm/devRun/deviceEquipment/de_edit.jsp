<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String oil_info_id=request.getParameter("oil_info_id");
	String dev_appdet_id = request.getParameter("ids");
	
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
  <title>定人定机</title> 
 </head>
<body style="background:#cdddef" onload="loadDataDetail()">
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="">
<div id="new_table_box" style="width:705px">
  <div id="new_table_box_content">
    <div id="new_table_box_bg" style="height:380px">
      <fieldset><legend>定人定机</legend>
	  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  <tr>
			<td class="inquire_item6">设备名称</td>
			<td class="inquire_form6">
				<input id="dev_appdet_id" name="dev_appdet_id" type ="hidden" value="<%=dev_appdet_id%>"/>
				<input id="dev_name" name="dev_name" class="input_width"  type="text" readonly/>
			</td>
			<td class="inquire_item6">规格型号</td>
			<td class="inquire_form6"><input id="dev_model" name="dev_model"  class="input_width" type="text" readonly/></td>
		  </tr>
		  <tr>		 	
		  	
			<td class="inquire_item6">自编号</td>
			<td class="inquire_form6">
				<input id="self_num" name="self_num"  class="input_width" type="text" readonly/>
			</td>
			<td class="inquire_item6">牌照号</td>
			<td class="inquire_form6"><input name="license_num" id="license_num"  class="input_width" type="text" readonly /></td>		    			
		  </tr>
	  </table>	  
	  </fieldset>
	  <div style="overflow:auto">
      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  	<tr align="right">
		  		<td class="ali_cdn_name" ></td>
		  		<td class="ali_cdn_input" ></td>
		  		<td class="ali_cdn_name" ></td>
		  		<td class="ali_cdn_input" ></td>
		  		<td>&nbsp;</td>
		    	<auth:ListButton functionId="" css="zj" event="onclick='addrow()'" title="增加"></auth:ListButton>
		    	<auth:ListButton functionId="" css="sc" event="onclick='removrow()'" title="删除"></auth:ListButton>
			</tr>
		  </table>
	  </div>
	  <fieldset><legend>操作手</legend>
	  	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	  		<tbody id="OPERATOR_body">
		  		<tr>
			  		<td class="inquire_item6">操作手1</td>
					<td class="inquire_form6">
						<input name="operator_id" id="operator_id"  class="input_width" type="hidden" />
						<input name="operator_name1" id="operator_name1"  class="input_width" type="text" />
						<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgPage(this)" />
					</td>
				</tr>
			</tbody>
	  	</table>
	  </fieldset>
	   <fieldSet style="margin:2px:padding:2px;"><legend>变更记录</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4"><font style="color:red">*</font>变更原因:</td>
          <td class="inquire_form4">
              <textarea id="bak" name="bak"  class="textarea" ></textarea>
          </td>
        </tr>
				 <tr id="proof_file_tr">
            <td class="inquire_item6">附件:</td>
			    <td class="inquire_item6">
	<input type="file" name="proof_file_" id="proof_file_" value="" class="input_width" onchange='getFileInfo(this,"proof_file")'  />
			    	<input type="hidden" id="proof_file" name="proof_file" value=""/>
			    	</td>
        </tr>
      </table>
      </fieldSet>
	</div>
	<div id="oper_div" style="margin-bottom:5px">
		<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
		<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
	</div>
    </div>   
</div>
</form>
</body>
<script type="text/javascript"> 
function getFileInfo(item,textname){
	var docPath = $(item).val();
	var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
	var docTitle = docName.substring(0,docName.lastIndexOf("\."));
	$("#"+textname).val(docTitle);//文件name
}
	var dev_appdet_id='<%=dev_appdet_id%>';
	var oil_info_id='<%=oil_info_id%>';
	function showNewInfo(){
		$("#device_mix_id").val("");
		$("#in_org_name").val($("#in_org_name_info").val());
		$("#in_org_id").val($("#in_org_id_info").val());
		$("#modify_table").show();
	}
		
	function submitInfo(){
		if($("#bak").val()=="")
			{
			alert("变更原因不能为空!");
			return;
			}
		if($("#operator_name1").val()=="")
		{
		alert("请至少添加一个操作手!");
		return;
		}
		
		if(confirm("提交后数据不能修改，确认提交？")){
			//调配数量提交operator_name
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveDE.srq?ids="+dev_appdet_id+"&optnum="+optnum;
			document.getElementById("form1").submit();
		}
	}
	
	var PROJECT_INFO_ID;
	
	function loadDataDetail(){
		if(oil_info_id=="null"){
			var str = "select t.*,t.dev_coding as erp_id,org.org_abbreviation,";
			str += "usingsd.coding_name as using_stat_desc,";
			str += "techsd.coding_name as tech_stat_desc,";
			str += "accountsd.coding_name as account_stat_desc,oprtbl.operator_name as alloprinfo ";
			str += "from gms_device_account t ";
			str += "left join (select device_account_id,operator_name from ( ";
			str += "select tmp.device_account_id,tmp.operator_name,row_number() ";
			str += "over(partition by device_account_id order by length(operator_name) desc ) as seq " ;
			str += "from (select device_account_id,wmsys.wm_concat(operator_name) ";
			str += "over(partition by device_account_id order by operator_name) as operator_name ";
			str += "from gms_device_equipment_operator where bsflag='0' ) tmp ) tmp2 where tmp2.seq=1) oprtbl on t.dev_acc_id = oprtbl.device_account_id ";
			str += "left join comm_coding_sort_detail usingsd on t.using_stat=usingsd.coding_code_id ";
			str += "left join comm_coding_sort_detail techsd on t.tech_stat=techsd.coding_code_id ";
			str += "left join comm_coding_sort_detail accountsd on t.account_stat=accountsd.coding_code_id ";
			str += "left join comm_org_information org on t.owning_org_id=org.org_id ";
			str += "where t.bsflag='0'  and t.dev_acc_id='<%=dev_appdet_id%>' ";	
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
			var basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			var sum=basedatas[0].alloprinfo;
			var strs= new Array(); 
			if(sum!="")
			{
				strs=sum.split(",");
			$("#operator_name1").val(strs[0]);
			for (i=1;i<strs.length ;i++ ) 
			{ 
				var arrayObj = {"label":strs[i],"value":strs[i]}; 
				addrow(arrayObj);
			} 
		}

		}else{
			var querySql="select a.*,d.employee_id,d.employee_name,b.dev_name,b.dev_model,b.self_num,b.license_num,c.PROJECT_NAME,b.owning_org_name,b.usage_org_name,b.using_stat,b.tech_stat,b.project_info_id from GMS_DEVICE_EQUIPMENT_OPERATOR a left join GMS_DEVICE_ACCOUNT_DUI b on a.DEVICE_ACCOUNT_ID=b.dev_acc_id left join gp_task_project c on b.PROJECT_INFO_ID=c.project_info_no left join comm_human_employee d on a.OPERATOR_ID=d.employee_id where a.DEVICE_ACCOUNT_ID='"+dev_appdet_id+"'" ;
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			$("#dev_name")[0].value=basedatas[0].dev_name;
			$("#dev_model")[0].value=basedatas[0].dev_model;
			$("#self_num")[0].value=basedatas[0].self_num;
			$("#license_num")[0].value=basedatas[0].license_num;
			$("#PROJECT_NAME")[0].value=basedatas[0].project_name;
			PROJECT_INFO_ID=basedatas[0].project_info_id;
			removrow();
			for(var i=0;i<basedatas.length;i++){
				var arrayObj = {"label":basedatas[i].operator_name,"value":basedatas[i].employee_id}; 
				addrow(arrayObj);
			}			
		}			
	}
	function  getOILMODEL(obj){
		var obj1=$("#OIL_MODEL");
		if(obj.value=="0110000043000000001"){
			
			var querySql="SELECT coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0100400025' and t.bsflag='0' order by t.coding_show_id"
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			var basedatas = queryRet.datas;
			obj1[0].options.length=0;
			obj1[0].options.add(new Option("--请选择--",""));  
			for(var i=0;i<basedatas.length;i++){
				obj1[0].options.add(new Option(basedatas[i].label,basedatas[i].value));  
			}
		}else if(obj.value=="0110000043000000002" ){
			var querySql="SELECT coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0100400026' and t.bsflag='0' order by t.coding_show_id"
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
			var basedatas = queryRet.datas;
			obj1[0].options.length=0;
			obj1[0].options.add(new Option("--请选择--","")); 
			for(var i=0;i<basedatas.length;i++){
				obj1[0].options.add(new Option(basedatas[i].label,basedatas[i].value));  
			}
		}else{
			var querySql="SELECT coding_code_id AS value,t.coding_name AS label FROM comm_coding_sort_detail t where t.coding_sort_id='0100400040' and t.bsflag='0' order by t.coding_show_id"
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var basedatas = queryRet.datas;
			obj1[0].options.length=0;
			obj1[0].options.add(new Option("--请选择--",""));  
			for(var i=0;i<basedatas.length;i++){
				obj1[0].options.add(new Option(basedatas[i].label,basedatas[i].value));  
			}
		}
	}
	var optnum=1;
	function addrow(obj){
		
		optnum++;
		
		var newTr=OPERATOR_body.insertRow();
		var newTd=newTr.insertCell();
		newTd.className="inquire_item6";
		newTd.innerHTML="操作手"+optnum;
		var newTd=newTr.insertCell();
		newTd.className="inquire_form6";
		if(obj==undefined){
			newTd.innerHTML="<input name=operator_id id=operator_id  class=input_width type=hidden  /><input name=operator_name"+optnum+" id=operator_name"+optnum+"  class=input_width type=text /><img src=<%=contextPath%>/images/magnifier.gif width=16 height=16 style=cursor:hand; onclick=showOrgPage(this) />";
		}else{
			newTd.innerHTML="<input name=operator_id id=operator_id  class=input_width type=hidden value="+obj.value+"  /><input name=operator_name"+optnum+" id=operator_name"+optnum+"  class=input_width type=text value='"+obj.label+"'  readonly /><img src=<%=contextPath%>/images/magnifier.gif width=16 height=16 style=cursor:hand; onclick=showOrgPage(this) />";
		}
		
	}
	function removrow(){
		
		if(optnum>0){
			$("#OPERATOR_body  tr:last").remove(); 
			optnum--;
		}
		
	}
	
	
	function showOrgPage(oo){
		var obj = new Object();
		var vReturnValue = window.showModalDialog("<%=contextPath%>/rm/dm/device-xd/searchZHOperatorList.jsp",obj,"dialogWidth=880px;dialogHeight=480px");
		if(vReturnValue!=undefined){
			var returnvalues = vReturnValue.split('~');
			var ips=oo.parentNode.getElementsByTagName("input");
			ips
			ips[0].value=returnvalues[0];
			ips[1].value=returnvalues[1];
		}
	}
</script>
</html>
 