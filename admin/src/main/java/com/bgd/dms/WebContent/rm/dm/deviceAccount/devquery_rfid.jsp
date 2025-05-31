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
<body class="bgColor_f3f3f3" >
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
          <td class="inquire_form4">
          	  <select name="account_stat" class="select_width">
            	  <option value="">--请选择--</option>
            	  <option value="0110000013000000003">在账</option>
      			  <option value="0110000013000000006">不在账</option>
      			  <option value="0110000013000000001">报废</option>
      			  <option value="0110000013000000005">外租</option>
      			  <!--option value="0110000013000000002">处理</option>
      			  <option value="0110000013000000004">已合并</option-->     					
              </select>
          </td>           
        </tr>
		<tr>
		  <td class="inquire_item4">实物标识号:</td>
          <td class="inquire_form4"><input name="rf.dev_sign" class="input_width" type="text" /></td>
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
          <td class="inquire_form4">
          	  <select name="using_stat" class="select_width">
            	  <option value="">--请选择--</option>
            	  <option value="0110000007000000002">闲置</option>
            	  <option value="0110000007000000001">在用</option>
      			  <option value="0110000007000000006">其他</option>
              </select>
          </td>
          <td class="inquire_item4">技术状况:</td>
          <td class="inquire_form4">
          	  <select name="tech_stat" class="select_width">
            	  <option value="">--请选择--</option>
            	  <option value="0110000006000000001">完好</option>
            	  <option value="0110000006000000006">待修</option>
      			  <option value="0110000006000000007">在修</option>
      			  <option value="0110000006000000005">待报废</option>
      			  <option value="0110000006000000013">待验收</option>      					
              </select>
         </td>
        </tr>
        <tr>
		  <td class="inquire_item4">项目名称:</td>
          <td class="inquire_form4"><input name="project_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">ERP设备编号:</td>
          <td class="inquire_form4"><input name="dev_coding" class="input_width" type="text" /></td>
        </tr>
        <tr>
		  <td class="inquire_item4">合同编号:</td>
          <td class="inquire_form4"><input name="cont_num" class="input_width" type="text" /></td>
          <td class="inquire_item4">备注:</td>
          <td class="inquire_form4"><input name="remark" class="input_width" type="text" /></td>
        </tr>
         <tr>
          <td class="inquire_item4">备注1:</td>
          <td class="inquire_form4"><input name="spare1" class="input_width" type="text" /></td>
          <td class="inquire_item4">备注2:</td>
          <td class="inquire_form4"><input name="spare2" class="input_width" type="text" /></td>
        </tr>
         <tr>		  
          <td class="inquire_item4">备注3:</td>
          <td class="inquire_form4"><input name="spare3" class="input_width" type="text" /></td>
          <!-- <td class="inquire_item4">备注4:</td>
          <td class="inquire_form4"><input name="spare4" class="input_width" type="text" /></td> -->
        </tr>
        <tr>
        	<td class="inquire_item4">创建日期:</td>
			<td class="inquire_form4">
			    <input id="start_date" name="start_date" onpropertychange="checkEndDate();" type="text" size="12" readonly/><img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(start_date,tributton1);" />
			    	&nbsp;至&nbsp;
			    <input id="end_date" name="end_date" onpropertychange="checkEndDate();" type="text" size="12" readonly/><img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(end_date,tributton2);" />
			</td>
		</tr>
        </table>
        
      <!-- <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
	       <tr>
			  <td class="inquire_item4">批量查询:</td>
	          <td class="inquire_form4"><input type="file"  id="fileName" name="fileName" onChange="uploadFile()" class="input_width"/></td>
	          <td class="inquire_item4"><a href="javascript:downloadModel('piliangchaxun','批量查询模板')"><font color=red>下载批量查询模板</font></a></td>
	          <td class="inquire_form4"></td>
	        </tr>
      </table> -->
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

	$().ready(function(){
		$("#addProcess").click(function(){
			tr_id = $("#processtable>tbody>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//统计本次的总行数
			$("#detail_count").val(tr_id);
			//动态新增表格
			var innerhtml = "<tr id = 'tr"+tr_id+"' ><td><input type='checkbox' name='idinfo' id='"+tr_id+"'/><input name='devicename"+tr_id+"' value='通过设备编码树选择设备名称' size='12' type='text'/></td><td><input name='devicetype"+tr_id+"' class='input_width' value='设备名称带出类型' size='12' type='text'/></td><td><input name='signtype"+tr_id+"' class='input_width' value='名称和类型带出类别' size='12' type='text'/></td><td><input name='unit"+tr_id+"' class='input_width' type='text'/></td><td><input name='neednum"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='team"+tr_id+"' class='input_width' type='text'/></td><td><input name='purpose"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='startdate"+tr_id+"' class='input_width' type='text'/></td><td><input name='enddate"+tr_id+"' class='input_width' type='text'/></td></tr>";
			
			$("#processtable").append(innerhtml);
			if(tr_id%2 == 0){
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("odd_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("odd_even");
			}else{
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("even_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("even_even");
			}
		});
		$("#delProcess").click(function(){
			$("input[name='idinfo']").each(function(){
				if(this.checked){
					var selected_id = this.id;
					$('#tr'+selected_id).remove();
				}
			});
		});
	});
	function init(){
		var ctt = parent.frames['list'].frames[1];
		document.getElementById("dev_name").value=ctt.document.getElementById("s_dev_name").value;
		document.getElementById("dev_model").value=ctt.document.getElementById("s_dev_model").value;
	}
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
       		//arrayObj.push(t.childNodes(i).childNodes[1].firstChild.value);
      		//arrayObj.push(t.childNodes(i).childNodes[3].firstChild.value);  
    	}
   		arrayObj.push({"label":"owning_sub_id","value":document.getElementById("owning_org_id").value});
    	var ctt = parent.frames['list'].frames[1];var dateobj = new Object();
    	var v_start_date = document.getElementById("start_date").value;
		var v_end_date = document.getElementById("end_date").value;
		if(v_start_date !=""){
			dateobj.start_date = v_start_date;
		}
		if(v_end_date !=""){
			dateobj.end_date = v_end_date;
		}
	    ctt.refreshData(arrayObj,content,dateobj);
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
	function checkEndDate(){
		var startTime = $("#start_date").val();
		var endTime = $("#end_date").val();
		if(startTime!=null&&startTime!=''&&endTime!=null&&endTime!=''){
			var days=(new Date(endTime.replace(/-/g,'/'))-new Date(startTime.replace(/-/g,'/')))/3600/24/1000;
			if(days<0){
				alert("截止时间应大于等于创建时间");
				$("#end_date").val("");
				return false;
			}			
		}
		return true;
	} 
	function uploadFile(){		
		var filename = document.getElementById("fileName").value;
		if(filename !=""){
			if(check(filename)){
				document.getElementById("fileForm").submit();
			}
		}
	} 
	
	function check(filename){
		var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
		type=type.toUpperCase();
		if(type=="XLS" || type=="XLSX"){
		   return true;
		}
		else{
		   alert("上传类型有误，请上传EXCLE文件！");
		   return false;
		}
	}
	
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/rm/em/humanLabor/download.jsp?path=/rm/dm/deviceAccount/"+modelname+".xlsx&filename="+filename+".xlsx";
	}	
</script>
</html>

