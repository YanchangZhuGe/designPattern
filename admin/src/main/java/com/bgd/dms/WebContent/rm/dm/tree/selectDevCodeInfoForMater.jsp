<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>

 <title>查询设备类别的叶子节点信息</title> 
 </head> 
 
 <body style="background:#F1F2F3" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">设备编码</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_code" name="s_dev_ci_code" type="text" class="input_width" />
			    </td>
			  	<td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_name" name="s_dev_ci_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_dev_ci_model" name="s_dev_ci_model" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td>&nbsp;</td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='dev_ci_id_{dev_ci_id}' name='dev_ci_id' idinfo='{dev_ci_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{dev_ci_id}' id='selectedbox_{dev_ci_id}' />" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{dev_ci_code}">设备编码</td>
					<td class="bt_info_even" exp="{dev_ci_name}">设备名称</td>
					<td class="bt_info_odd" exp="{dev_ci_model}">规格型号</td>
					<td class="bt_info_even" exp="{dev_ci_unit}">单位</td>
			     </tr>
			    <tbody id="detaillist" name="detaillist" >
			   </tbody>
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
	</div>
	<div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function searchDevData(){
		var v_dev_ci_name = $("#s_dev_ci_name").val();
		var v_dev_ci_model = $("#s_dev_ci_model").val();
		var v_dev_ci_code = $("#s_dev_ci_code").val();
		refreshData(v_dev_ci_name,v_dev_ci_model,v_dev_ci_code);
	}

	function refreshData(v_dev_ci_name,v_dev_ci_model,v_dev_ci_code){
	
		var str = "select dev_ci_id,dev_ci_code,dev_ci_name,dev_ci_model,dev_ci_unit ";
		str += "from gms_device_codeinfo ";
		str += "where 1=1 ";
		if(v_dev_ci_name!=undefined && v_dev_ci_name!=''){
			str += "and dev_ci_name like '%"+v_dev_ci_name+"%' ";
		}
		if(v_dev_ci_model!=undefined && v_dev_ci_model!=''){
			str += "and dev_ci_model like '%"+v_dev_ci_model+"%' ";
		}
		if(v_dev_ci_code!=undefined && v_dev_ci_code!=''){
			str += "and dev_ci_code like '%"+v_dev_ci_code+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
		/*
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		var retObj = proqueryRet.datas;
		$("#detaillist").empty();
		for(var index=0;index<retObj.length;index++){
			var innerhtml = "<tr id='tr"+retObj[index].dev_ci_id+"' name='tr' midinfo='"+retObj[index].dev_ci_id+"'>";
			innerhtml += "<td><input type='checkbox' name='idinfo' id='"+retObj[index].dev_ci_id+"' value='"+retObj[index].dev_ci_id+"'/></td>";
			innerhtml += "<td>"+retObj[index].dev_ci_code+"</td>";
			innerhtml += "<td>"+retObj[index].dev_ci_name+"</td>" ;
			innerhtml += "<td>"+retObj[index].dev_ci_model+"</td>";
			innerhtml += "<td>"+retObj[index].dev_ci_unit+"</td>";
			innerhtml += "</tr>";
			$("#detaillist").append(innerhtml);
		}
		$("#detaillist>tr:odd>td:odd").addClass("odd_odd");
		$("#detaillist>tr:odd>td:even").addClass("odd_even");
		$("#detaillist>tr:even>td:odd").addClass("even_odd");
		$("#detaillist>tr:even>td:even").addClass("even_even");
		*/
	}
	function dbclickRow(shuaId){
		var obj = document.getElementsByName("selectedbox");
		var count = 0;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				count ++;
			}
		}
		if(count != 1){
			alert("请选择一条记录!");
			return;
		}
		var selectedids = null;
		var columnsObj = null;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				selectedids = selectedobj.value;
				columnsObj = selectedobj.parentNode.parentNode.cells;
				break;
			}
		}
		//返回信息是  类别id + 设备编码 + 设备名称 + 规格型号
		selectedids += "~"+columnsObj[2].innerText+"~"+columnsObj[3].innerText+"~"+columnsObj[4].innerText;
		window.returnValue = selectedids;
		window.close();
	} 
	function submitInfo(){
		var obj = document.getElementsByName("selectedbox");
		var count = 0;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				count ++;
			}
		}
		if(count != 1){
			alert("请选择一条记录!");
			return;
		}
		var selectedids = null;
		var columnsObj = null;
		for(var index = 0;index<obj.length;index++){
			var selectedobj = obj[index];
			if(selectedobj.checked == true){
				selectedids = selectedobj.value;
				columnsObj = selectedobj.parentNode.parentNode.cells;
				break;
			}
		}
		//返回信息是  类别id + 设备编码 + 设备名称 + 规格型号 
		selectedids += "~"+columnsObj[2].innerText+"~"+columnsObj[3].innerText+"~"+columnsObj[4].innerText;
		window.returnValue = selectedids;
		window.close();
	}
	function newClose(){
		window.close();
	}
	function loadDataDetail(dev_ci_id){
		$("input[type='checkbox'][name='selectedbox']").removeAttr("checked");
		//选中这一条checkbox
		$("#selectedbox_"+dev_ci_id).attr("checked","checked");
    }
	function chooseOne(cb){
        var obj = document.getElementsByName("selectedbox");
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }
    } 
</script>
</html>