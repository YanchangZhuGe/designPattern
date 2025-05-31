<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
  	String scrape_apply_id = request.getParameter("scrape_apply_id");
    java.util.Calendar c=java.util.Calendar.getInstance();    
    java.text.SimpleDateFormat f=new java.text.SimpleDateFormat("yyyy-MM-dd");   
    String nowTime=f.format(c.getTime());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>报废申请盘亏毁损录入</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" enctype="multipart/form-data" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldSet style="margin:2px:padding:2px;"><legend>报废申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="scrape_apply_id" id="scrape_apply_id" type="hidden" value="<%=scrape_apply_id%>" />
      		<input name="scrape_damage_id" id="scrape_damage_id" type="hidden" />
      			<input name="colnum" id="colnum" class="input_width" type="hidden" value="" readonly/>
      				<input name="parmeter" id="parmeter" type="hidden" value=""/>
        <tr>
          <td class="inquire_item4">报废申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="scrape_apply_name" id="scrape_apply_name" class="input_width" type="text" value="" raadonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">报废申请单号:</td>
          <td class="inquire_form4">
          	<input name="scrape_apply_no" id="scrape_apply_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
   			<td class="inquire_item4">申请单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" value="<%=user.getOrgName()%>" readonly/>
          </td>
          
          </td>
        </tr>
      </table>    
      </fieldSet>
        <fieldSet style="margin-left:2px"><legend>盘亏、毁损设备报废明细</legend>
	  	  <div>
	  	  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  	  		<tr>
	  	  			<td>&nbsp;</td>
	  	  			<auth:ListButton functionId="" css="zj" event="onclick='addRows()'" title="添加设备"></auth:ListButton>
			    	<auth:ListButton functionId="" css="sc" event="onclick='delRows()'" title="删除设备"></auth:ListButton>
	  	  		</tr>
	  	  	</table>
	  	  </div>
		  <div style="overflow:auto">
			  <table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" ><input type='checkbox' id='hirechecked'name='hirechecked'/></td>
					<td class="bt_info_even">设备名称</td>
					<td class="bt_info_odd" >规格型号</td>
					<td class="bt_info_even">设备编号</td>
					<td class="bt_info_even">报废原因</td>
					<td class="bt_info_even">备注</td>
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
       <fieldSet style="display:none;margin:2px:padding:2px;"><legend>盘亏、毁损报废申请单</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      <tr>
             <td class="inquire_item4">专业化服务设备:</td>
          <td class="inquire_item4" align="left"> 是 
			 <input type="radio" name="specialized_unit_flag" value="0" id="specialized_unit_flag1" />
					    </td>
		 <td class="inquire_item4"> 否
					    <input type="radio" name="specialized_unit_flag" value="1" id="specialized_unit_flag2" />  		
					    </td>
		   <td class="inquire_item4" >其他单位设备:</td>
          <td class="inquire_item4" align="left"> 是 
			 <input type="radio" name="else_unit_flag" value="0" id="else_unit_flag1" />
					    </td>
		 <td class="inquire_item4"> 否
					    <input type="radio" name="else_unit_flag" value="1" id="else_unit_flag2" />  		
					    </td>			    
        </tr>
        <tr>
        
          <td class="inquire_item4">损失原因:</td>
          <td class="inquire_form4" colspan="6" >
              <textarea id="loss_reason" name="loss_reason"  class="textarea" readonly></textarea>
          </td>
        </tr>
         <tr id="proof_file_tr">
            <td class="inquire_item6">证明材料:</td>
			    <td class="inquire_item6" colspan="3">
	<input type="file" name="proof_file_" id="proof_file_" value="" class="input_width" onchange='getFileInfo(this,"proof_file")'  />
			    	<input type="hidden" id="proof_file" name="proof_file" value=""/>
			    	</td>
        </tr>
           <tr  id="payment_proof_file_tr"> 
          	 <td class="inquire_item6">赔付证明:</td>
			    <td class="inquire_item6" colspan="3">
	<input type="file" name="payment_proof_file_" id="payment_proof_file_" value="" class="input_width"  />
			    	<input type="hidden" id="payment_proof_file" name="payment_proof_file" value=""/>
			    	</td>
        </tr>
        <tr id="dev_photo_file_tr">
              	 <td class="inquire_item6">毁损设备照片:</td>
			    <td class="inquire_item6" colspan="3">
	<input type="file" name="dev_photo_file_" id="dev_photo_file_" value="" class="input_width"  />
			    	<input type="hidden" id="dev_photo_file" name="dev_photo_file" value=""/>
			    	</td>
        </tr>
			<tr id="person_handling_file_tr">
				     <td class="inquire_item6">责任人处理:</td>
			    <td class="inquire_item6" colspan="3">
	<input type="file" name="person_handling_file_" id="person_handling_file_" value="" class="input_width"   />
			    	<input type="hidden" id="person_handling_file" name="person_handling_file" value=""/>
			    	</td>
			</tr>
		</table>
      </fieldSet>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	function saveInfo(){
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
		var wronglineinfos = "";
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
		/* if($('input[name="specialized_unit_flag"]:checked').val()== undefined)
			{
				alert("请选择是否为专业化服务设备!");
				return;
			}
		if($('input[name="else_unit_flag"]:checked').val()== undefined)
		{
			alert("请选择是否为其他单位设备!");
			return;
		} */
		document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/addScrapeDamageInfo.srq";
		document.getElementById("form1").submit();
	}
	function refreshData(){
		if('<%=scrape_apply_id%>'!='null'){
			 baseData = jcdpCallService("ScrapeSrv", "getScrapeDamageInfo", "scrape_apply_id="+$("#scrape_apply_id").val());
				$("#scrape_apply_no").val(baseData.deviceAssetMap.scrape_apply_no);
				$("#scrape_asset_id").val(baseData.deviceAssetMap.scrape_asset_id);
				$("#scrape_apply_name").val(baseData.deviceAssetMap.scrape_apply_name);
				$("#apply_date").val(baseData.deviceAssetMap.apply_date);
				$("#scrape_damage_id").val(baseData.deviceAssetMap.scrape_damage_id);
				$("#loss_reason").val(baseData.deviceAssetMap.loss_reason);
				if(baseData.deviceAssetMap.specialized_unit_flag=='0')
				{
				 document.getElementById("specialized_unit_flag1").checked=true; 
				 }
				 if(baseData.deviceAssetMap.specialized_unit_flag=='1')
				{
				 document.getElementById("specialized_unit_flag2").checked=true; 
				 }
				 	if(baseData.deviceAssetMap.else_unit_flag=='0')
				{
				 document.getElementById("else_unit_flag1").checked=true; 
				 }
				 if(baseData.deviceAssetMap.else_unit_flag=='1')
					{
				 document.getElementById("else_unit_flag2").checked=true; 
					 }
				if(baseData.datas!=null)
				{
				for (var tr_id = 0; tr_id< baseData.datas.length; tr_id++) {
					var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
					innerhtml += "<input name='detdev_ci_code"+tr_id+"' id='detdev_ci_code"+tr_id+"' value='"+baseData.datas[tr_id].foreign_dev_id+"' size='16'  type='hidden' />";
					innerhtml += "<input name='asset_coding"+tr_id+"' id='asset_coding"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
					innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
					innerhtml += "<td width='27%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='"+baseData.datas[tr_id].dev_name+"' size='20' type='text' readonly />";
					innerhtml += "</td>"
					innerhtml += "<td width='17%'><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='"+baseData.datas[tr_id].dev_model+"' size='20'  type='text' readonly /></td>";
					innerhtml += "<td width='17%'><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='"+baseData.datas[tr_id].dev_type+"' size='25' type='text' readonly/>";
					if(baseData.datas[tr_id].scrape_type==2)
						{
						innerhtml += "<td width='17%'><select name='scrape_type"+tr_id+"' id='scrape_type"+tr_id+"'><option  value='2' selected >毁损</option></select></td>";
						}
					if(baseData.datas[tr_id].scrape_type==3)
					{
					innerhtml += "<td width='17%'><select name='scrape_type"+tr_id+"' id='scrape_type"+tr_id+"'><option value='3' selected>盘亏</option></select></td>";
					}
					
					innerhtml += "<td width='9%'><input name='bak"+tr_id+"' id='bak"+tr_id+"'  size='9'  type='text' value='"+baseData.datas[tr_id].bak1+"' readonly /></td>";
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
					for (var tr_id = 1; tr_id<=baseData.fdata.length; tr_id++) {
					//证明材料
					if(baseData.deviceAssetMap.proof_file==baseData.fdata[tr_id-1].file_type)
					{
						$("#proof_file_tr").empty();
						insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id,'proof_file_tr','证明材料','proof_file');
					}
					//赔付证明
					if(baseData.deviceAssetMap.payment_proof_file==baseData.fdata[tr_id-1].file_type)
					{
					$("#payment_proof_file_tr").empty();
						insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id,'payment_proof_file_tr','赔付证明','payment_proof_file');
					}
					//毁损照片
					if(baseData.deviceAssetMap.dev_photo_file==baseData.fdata[tr_id-1].file_type)
					{
						$("#dev_photo_file_tr").empty();
						insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id,'dev_photo_file_tr','毁损照片','dev_photo_file');
					}
					//责任人处理
					if(baseData.deviceAssetMap.person_handling_file==baseData.fdata[tr_id-1].file_type)
					{
						$("#person_handling_file_tr").empty();
						insertFile(baseData.fdata[tr_id-1].file_name,baseData.fdata[tr_id-1].file_type,baseData.fdata[tr_id-1].file_id,'person_handling_file_tr','责任人处理','person_handling_file');
					}
					}
				}
	
	}
	}
	
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
		innerhtml += "<input name='asset_value"+tr_id+"' id='asset_value"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='dev_sign"+tr_id+"' id='dev_sign"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='producting_date"+tr_id+"' id='producting_date"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<input name='license_num"+tr_id+"' id='license_num"+tr_id+"' value='' size='16'  type='hidden' />";
		innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' checked/></td>";
		innerhtml += "<td width='27%'><input name='dev_name"+tr_id+"' id='dev_name"+tr_id+"' style='line-height:15px' value='' size='15' type='text' readonly /><img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick='showDevCodePage("+tr_id+")' />";
		innerhtml += "</td>"
		innerhtml += "<td width='17%'><input name='dev_model"+tr_id+"' id='dev_model"+tr_id+"' value='' size='16'  type='text' readonly /></td>";
		innerhtml += "<td width='17%'><input name='dev_type"+tr_id+"' id='dev_type"+tr_id+"' value='' size='16' type='text' readonly/>";
		innerhtml += "<td width='17%'><select name='scrape_type"+tr_id+"' id='scrape_type"+tr_id+"'><option value='2' >毁损</option><option value='3'>盘亏</option></select></td>";
		innerhtml += "<td width='9%'><input name='bak"+tr_id+"' id='bak"+tr_id+"' value='' size='9'  type='text' readonly/></td>";
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
	var returnval = window.showModalDialog("<%=contextPath%>/dmsManager/scrape/selectAllAccountForMix.jsp",obj,"dialogWidth=950px;dialogHeight=480px");
	//返回信息是  类别id + 设备编码 + 设备名称 + 规格型号
	if(returnval!=undefined){
		var returnvals = returnval.split("~",-1);
		$("#dev_name"+index).val(returnvals[2]);
		$("#dev_model"+index).val(returnvals[3]);
		$("#detdev_ci_code"+index).val(returnvals[0]);
		$("#dev_type"+index).val(returnvals[1]);
	}
}
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});

//插入文件
function insertFile(name,type,id,f_tr,context,hiddenname){
	$("#"+f_tr).empty();
	$("#"+f_tr).append(
				"<td class='inquire_item6'>"+context+":</td>"+
      			"<td class='inquire_item6' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
				"<td class='ali_btn'></td>"
		);
}
//删除文件
function deleteFile(item,id,f_tr,context,hiddenname){
	if(confirm('确定要删除吗?')){  
		$(item).parent().parent().parent().empty();
		$("#"+f_tr).append(
				"<td class='inquire_item6'>"+context+":</td>"+
      			"<td class='inquire_item6' colspan='3'><input type='file' name='"+hiddenname+"_' id='"+hiddenname+"_' value='' class='input_width' onchange='getFileInfo(this,\""+hiddenname+"\")' />"+
				"<input type='hidden' id="+hiddenname+" name="+hiddenname+" value=''/></td>"
		);
			//jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
		}
	
}

//删除行
function deleteInput(item,order){
	$(item).parent().parent().parent().remove();
}
function getFileInfo(item,textname){
	var docPath = $(item).val();
	var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
	var docTitle = docName.substring(0,docName.lastIndexOf("\."));
	$("#"+textname).val(docTitle);//文件name
}

</script>
</html>

