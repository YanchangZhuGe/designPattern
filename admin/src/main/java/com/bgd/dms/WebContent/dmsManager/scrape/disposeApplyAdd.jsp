<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String dispose_apply_id = request.getParameter("dispose_apply_id");
    java.util.Calendar c=java.util.Calendar.getInstance();    
    java.text.SimpleDateFormat f=new java.text.SimpleDateFormat("yyyy-MM-dd");   
    String nowTime=f.format(c.getTime());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>报废处置申请录入</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post"  enctype="multipart/form-data"  action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
    <fieldSet style="margin:2px:padding:2px;"><legend>报废处置申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="dispose_apply_id" id="dispose_apply_id" type="hidden" value="<%=dispose_apply_id%>" />
      		<input name="disfiles" id="disfiles" type="hidden" value=""/>
      			<input name="parmeter" id="parmeter" type="hidden" value=""/>
        <tr>
          <td class="inquire_item4">报废处置申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="app_name" id="app_name" class="input_width" type="text" value="" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">报废处置申请单号:</td>
          <td class="inquire_form4">
          	<input name="app_no" id="app_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="<%=nowTime%>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          </td>
          <td class="inquire_item4">申请人:</td>
          <td class="inquire_form4">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden" value="<%=user.getEmpId()%>" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          </td>
        </tr>
      </table>    
      </fieldSet>
        <fieldSet style="margin-left:2px"><legend>报废处置详细信息</legend>
      	<input name="colnum" id="colnum" class="input_width" type="hidden" value="" readonly/>
	  	  <div>
	  	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	  		<tr>
	  	  			<td><font color="red">注：此处导入的设备必须设备报废-信息查询菜单里面的数据，否则不能添加成功</font></td>
	  	  			<td class="ali_cdn_name" ><a href="javascript:downloadModel('dispose_model','设备报废处置申请明细')">处置申请模板</a></td>
			    	<auth:ListButton functionId="" css="dr" event="onclick='excelDataAdd()'" title="导入设备"></auth:ListButton>
	  	  			<auth:ListButton functionId="" css="zj" event="onclick='addRows()'" title="添加设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delRows()'" title="删除设备"></auth:ListButton>
	  	  		</tr>
	  	  	</table>
	  	  </div>
		  <div style="overflow:auto">
			  <table style="width:100%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" ><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
					<td class="bt_info_even">设备名称</td>
					<td class="bt_info_odd" >规格型号</td>
					<td class="bt_info_even">设备编号</td>
					<td class="bt_info_odd">ERP编码</td>
					<td class="bt_info_even">原值</td>
					<td class="bt_info_odd">净值</td>
					<td class="bt_info_even">报废日期</td>
					<td class="bt_info_odd">备注</td>
				</tr>
				</table>
			   <div style="height:190px;overflow:auto;">
		      	<table style="width:97.9%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   		<tbody id="processtable0" name="processtable0" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
      </fieldSet>
       <fieldSet style="margin:2px:padding:2px;"><legend>其他说明</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
          <td class="inquire_item4">备注:</td>
          <td class="inquire_form4" colspan="3">
            <textarea id="bak" name="bak"  class="textarea" ></textarea>			  
          </td>
        </tr>
            <tr>
          	<table style="margin-left:40px;">
			<tr >
				<td>&nbsp;</td>
				<td colspan="1" ><span style="font-size:12px;">添加附件</span></td>
				<td class='ali_btn' colspan="2"><span class='zj'><a href='javascript:void(0);' onclick='insertTr("file_table6")'  title='添加'></a></span></td>
			</tr>
		</table>
			<table id="file_table6" border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%"></table>
        </tr>
      </table>    
      </fieldSet>
	</div>
    <div id="oper_div">
     	<span class="bc_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});
	function saveInfo(){
	
	if($("#app_name").val()=="")
			{
			alert("报废处置申请单名称不能为空!");
			return;
			}
		//保留的行信息
		var count = 0;
		var result= 0;
		var line_infos;
		var idinfos ;
		var text="";
		$("input[type='checkbox'][name='idinfo']").each(function(){
			text=text+","+this.id;
			if(this.checked){
				if(count == 0){
					line_infos = this.id;
					idinfos = this.value;
				}else{
					line_infos += "~"+this.id;
					idinfos += "~"+this.value;
				}
				count++;
			}
			result++;
		});
		if(count == 0){
			alert('请选择设备明细信息！');
			return;
		}
		$("#colnum").val(result-1);
		if (text.substr(0,1)==',') text=text.substr(1);
		$("#parmeter").val(text);
		var selectedlines = line_infos.split("~");
		var wronglineinfos = "";debugger;
		for(var index=0;index<selectedlines.length;index++){
			var valueinfo = $("#detdev_ci_code"+selectedlines[index]).val();
			if(valueinfo == ""){
				if(index == 0){
					wronglineinfos += (parseInt(selectedlines[index])+1);
				}else{
					wronglineinfos += ","+(parseInt(selectedlines[index])+1);
				}
			}
		}
		if(wronglineinfos!=""){
			alert("请选择第"+wronglineinfos+"行设备明细信息!");
			return;
		}
		$("#app_no").val("");
		document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/addDisposeInfo.srq";
		document.getElementById("form1").submit();
	}
	/**设备报废处置明细模板方法**/
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/dmsManager/common/download.jsp?path=/dmsManager/scrape/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	/**导入设备报废处置明细方法**/
	function excelDataAdd(){
		var nodes= window.showModalDialog('<%=contextPath%>/dmsManager/scrape/disAppExcelAdd.jsp','ceshi','dialogHeight=10;dialogWidth=45;resizable=no;menuba=no;resizable=no');
		//{"dev_model":"BPS-TP","dev_name":"二次定位传感器","scrape_detailed_id":"8ad899dc5141cb3c015141cdf56d0006","set_value":"2787","scrape_date":"2015/11/26","dev_type":"0154013000001"}
		/* for(var a= 0;a<nodes.length;a++){
			alert(nodes[a]);
			alert(nodes[a].scrape_detailed_id);
			alert(nodes[a].dev_name);
			alert(nodes[a].dev_model);
			alert(nodes[a].dev_type);
			alert(nodes[a].set_value);
			alert(nodes[a].scrape_date);
		} */
		
		refreshDataDync(nodes);
	}
	function refreshDataDync(nodes){
		for (var tr_id = 0; tr_id< nodes.length; tr_id++) {
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<input name='detdev_ci_code"+tr_id+"' id='detdev_ci_code"+tr_id+"' value='"+nodes[tr_id].scrape_detailed_id+"' size='16'  type='hidden' />";
			/* innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";*/
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>"; 
			innerhtml += "<td width=3%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='"+nodes[tr_id].dev_name+"' size='12' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePage("+tr_id+")' />";
			innerhtml += "</td>";
			innerhtml += "<td><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='"+nodes[tr_id].dev_model+"' size='10'  type='text' readonly /></td>";
			innerhtml += "<td><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='"+nodes[tr_id].dev_type+"' size='12' type='text' readonly/>";
			innerhtml += "<td><input name='dev_coding"+tr_id+"' id='dev_coding"+tr_id+"' value='"+nodes[tr_id].dev_coding+"' size='12' type='text' readonly/></td>";
			innerhtml += "<td><input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='"+nodes[tr_id].asset_value+"' size='7' type='text' readonly/></td>";
			innerhtml += "<td><input name='net_value"+tr_id+"' id='net_value"+tr_id+"' value='"+nodes[tr_id].net_value+"' size='7' type='text' readonly/></td>";
			innerhtml += "<td><input name='scrape_date"+tr_id+"' id='scrape_date"+tr_id+"' value='"+nodes[tr_id].scrape_date+"' size='9' type='text' readonly/></td>";
			innerhtml += "<td><input name='bak"+tr_id+"' id='bak"+tr_id+"'  size='7'  type='text' value=''  readonly/></td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
		}
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
	}
		
	<%-- function g_OpenWindow(pageURL, innerWidth, innerHeight)
	{    
	    var ScreenWidth = screen.availWidth
	    var ScreenHeight = screen.availHeight
	    var StartX = (ScreenWidth - innerWidth) / 2
	    var StartY = (ScreenHeight - innerHeight) / 2
	    window.open(pageURL, '', 'left='+ StartX + ', top='+ StartY + ', Width=' + innerWidth +', height=' + innerHeight + ', resizable=no, scrollbars=yes, status=no, toolbar=no, menubar=no, location=no')
	 }
	function excelDataAdd(){
		this.g_OpenWindow('<%=contextPath%>/dmsManager/scrape/disAppExcelAdd.jsp','400','150');
	} --%>
	function addRows(value){
		tr_id = $("#processtable0>tr:last").attr("id");
		if(tr_id != undefined){
			tr_id = parseInt(tr_id.substr(2,1),10);
		}
		if(tr_id == undefined){
			tr_id = 0;
		}else{
			tr_id = tr_id+1;
		}
		$("#colnum").val(tr_id);
		//动态新增表格
		var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
		innerhtml += "<input name='detdev_ci_code"+tr_id+"' id='detdev_ci_code"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
		innerhtml += "<td width='3%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='' size='9' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePage("+tr_id+")' />";
		innerhtml += "</td>";
		innerhtml += "<td><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='' size='9'  type='text' readonly /></td>";
		innerhtml += "<td><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='' size='11' type='text' readonly/></td>";
		innerhtml += "<td><input name='dev_coding"+tr_id+"' id='dev_coding"+tr_id+"' value='' size='11' type='text' readonly/></td>";
		innerhtml += "<td><input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='' size='6' type='text' readonly/></td>";
		innerhtml += "<td><input name='net_value"+tr_id+"' id='net_value"+tr_id+"' value='' size='6' type='text' readonly/></td>";
		innerhtml += "<td><input name='scrape_date"+tr_id+"' id='scrape_date"+tr_id+"' value='' size='8' type='text' readonly/></td>";
		innerhtml += "<td><input name='bak"+tr_id+"' id='bak"+tr_id+"' value='' size='6'  type='text' readonly /></td>";
		innerhtml += "</tr>";
		$("#processtable0").append(innerhtml);
		$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
		$("#processtable0>tr:odd>td:even").addClass("odd_even");
		$("#processtable0>tr:even>td:odd").addClass("even_odd");
		$("#processtable0>tr:even>td:even").addClass("even_even");
};
function delRows(){
	$("input[name='idinfo']").each(function(){
		if(this.checked == true){
			$('#tr'+this.id,"#processtable0").remove();
		}
	});
	$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
	$("#processtable0>tr:odd>td:even").addClass("odd_even");
	$("#processtable0>tr:even>td:odd").addClass("even_odd");
	$("#processtable0>tr:even>td:even").addClass("even_even");
};
function showDevCodePage(index){
	var obj = new Object();
	var pageselectedstr = null;
	var checkstr = 0;
	$("input[name^='detdev_ci_code'][type='hidden']").each(function(i){
		if(this.value!=null&&this.value!=''){
			if(checkstr == 0){
				pageselectedstr = "'"+this.value;
			}else{
				pageselectedstr += "','"+this.value;
			}
			checkstr++;
		}
	});
	if(pageselectedstr!=null){
		pageselectedstr = pageselectedstr + "'";
	}
	obj.pageselectedstr = pageselectedstr;
	var returnval = window.showModalDialog("<%=contextPath%>/dmsManager/scrape/selectScrapeList.jsp?hflag='is null'",obj,"dialogWidth=950px;dialogHeight=480px");
	//返回信息是  类别id + 设备编码 + 设备名称 + 规格型号
	if(returnval!=undefined){
		var returnvals = returnval.split("~",-1);
		$("#detdev_ci_code"+index).val(returnvals[0]);
		$("#dev_name"+index).val(returnvals[1]);
		$("#dev_model"+index).val(returnvals[3]);
		$("#dev_type"+index).val(returnvals[2]);
		$("#asset_value"+index).val(returnvals[4]);
		$("#scrape_date"+index).val(returnvals[5]);
		$("#bak"+index).val(returnvals[6]);
		$("#dev_coding"+index).val(returnvals[7]);
		$("#net_value"+index).val(returnvals[8]);
	}
}


function refreshData(){
	var baseData;
	if('<%=dispose_apply_id%>'!='null'){
		 baseData = jcdpCallService("ScrapeSrv", "getDisposeInfo", "dispose_apply_id="+$("#dispose_apply_id").val());
		$("#app_no").val(baseData.deviceMap.app_no);
		$("#app_name").val(baseData.deviceMap.app_name);
		$("#apply_date").val(baseData.deviceMap.apply_date);
		$("#bak").val(baseData.deviceMap.bak);
		$("#disfiles").val(baseData.deviceMap.disfiles);
		if(baseData.datas!=null)
		{
		for (var tr_id = 0; tr_id< baseData.datas.length; tr_id++) {
			var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
			innerhtml += "<input name='detdev_ci_code"+tr_id+"' id='detdev_ci_code"+tr_id+"' value='"+baseData.datas[tr_id].scrape_detailed_id+"' size='16'  type='hidden' />";
			innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
			innerhtml += "<td width='3%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='"+baseData.datas[tr_id].dev_name+"' size='12' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePage("+tr_id+")' />";
			innerhtml += "</td>";
			innerhtml += "<td><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='"+baseData.datas[tr_id].dev_model+"' size='10'  type='text' readonly /></td>";
			innerhtml += "<td><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='"+baseData.datas[tr_id].dev_type+"' size='12' type='text' readonly/>";
			innerhtml += "<td ><input name='dev_coding"+tr_id+"' id='dev_coding"+tr_id+"' value='"+baseData.datas[tr_id].dev_coding+"' size='12' type='text' readonly/></td>";
			innerhtml += "<td ><input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='"+baseData.datas[tr_id].asset_value+"' size='7' type='text' readonly/></td>";
			innerhtml += "<td><input name='net_value"+tr_id+"' id='net_value"+tr_id+"' value='"+baseData.datas[tr_id].net_value+"' size='7' type='text' readonly/></td>";
			innerhtml += "<td ><input name='scrape_date"+tr_id+"' id='scrape_date"+tr_id+"' value='"+baseData.datas[tr_id].scrape_date+"' size='9' type='text' readonly/></td>";
			innerhtml += "<td><input name='bak"+tr_id+"' id='bak"+tr_id+"'  size='7'  type='text' value='"+baseData.datas[tr_id].bak1+"'  readonly/></td>";
			innerhtml += "</tr>";
			$("#processtable0").append(innerhtml);
			}
			$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
			$("#processtable0>tr:odd>td:even").addClass("odd_even");
			$("#processtable0>tr:even>td:odd").addClass("even_odd");
			$("#processtable0>tr:even>td:even").addClass("even_even");
			}
		if(baseData.fdata!=null)
		{
		$("#file_table6").empty();
		for (var tr_id = 1; tr_id<=baseData.fdata.length; tr_id++) {
			insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id);
		}
		}
}
	
}

//插入行
function insertTr(obj){
var tmp=new Date().getTime();
	$("#"+obj+"").append(
		"<tr class='file_tr'>"+
			"<td class='inquire_item5'>附件：</td>"+
  			"<td class='inquire_form5'><input type='file' name='doc_content__"+tmp+"' id='doc_content__"+tmp+"' onchange='getFileInfo(this)' class='input_width'/></td>"+
			"<td class='inquire_item5'>附件名：</td>"+
			"<td class='inquire_form5'><input type='text' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"' class='input_width' /><input type='hidden' id='doc_type__"+tmp+"' name='doc_type__"+tmp+"'></td>"+
			"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInput(this)'  title='删除'></a></span></td>"+
		"</tr>"	
	);

}
//删除行
function deleteInput(item){
	$(item).parent().parent().parent().remove();
	checkInfoList();
	
}
function getFileInfo(item){
	var docPath = $(item).val();
	var order = $(item).attr("id").split("__")[1];
	var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
	var docTitle = docName.substring(0,docName.lastIndexOf("\."));
	$("#doc_name__"+order).val(docTitle);//文件name
	
}

	//插入文件
function insertFile(name,type,id){
	
		$("#file_table6").append(
					"<tr>"+
					"<td class='inquire_form5'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"<td class='inquire_form5'><span class='sc'><a href='javascript:void(0);' onclick=deleteFile(this,\""+id+"\") title='删除'></a></span></td>"+
					"</tr>"
			);
}
//删除文件
	function deleteFile(item,id){
		if(confirm('确定要删除吗?')){  
			$(item).parent().parent().parent().empty();
			var tmp=new Date().getTime();
			$("#file_table6").append("<tr><td class='inquire_item6'>附件:</td>"+
	    			"<td class='inquire_form5'><input type='file' name='doc_content__"+tmp+"' id='doc_content__"+tmp+"' onchange='getFileInfo(this)' class='input_width'/></td>"+
	    			"<td class='inquire_form5'>附件名：</td>"+
					"<td class='inquire_form5'><input type='text' readonly='readonly' name='doc_name__"+tmp+"' id='doc_name__"+tmp+"' class='input_width' /><input type='hidden' id='doc_type__"+tmp+"' name='doc_type__"+tmp+"'></td>"+
					"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInput(this)'  title='删除'></a></span></td></tr>");
				jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
		}
	}

</script>
</html>

