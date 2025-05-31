<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="gms" uri="/WEB-INF/tld/ep.tld"%>
<%@taglib prefix="auth" uri="/WEB-INF/tld/auth.tld"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%> 
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.soa.msg.MsgElement"%>

<%
  String contextPath = request.getContextPath();
  UserToken user = OMSMVCUtil.getUserToken(request);
  String superior_code_id = request.getParameter("superior_code_id");
  String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
</head>
<body onload='refreshData()'>
<form name="form1" id="form1" method="post" action="">
<input name="superior_code_id" id="superior_code_id" type="hidden"  value="<%=superior_code_id%>"/>
<div id="new_table_box">
<div id="new_table_box_content">
<div id="new_table_box_bg">
		<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			      <td class="ali_cdn_name">保养类型:</td>
		 	    <td class="ali_cdn_input"><select name="s_code_type" id="s_code_type" class="selected_width"   onchange="refreshData()"
				></selected></td>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
      <div id="table_box" >
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="lineTable">
          <tr>
          <td class="bt_info_even"><input type='checkbox' name='rdo_entity_name' value='' onclick='check()'/></td>
          <td class="bt_info_odd">序号</td>
          <td class="bt_info_even">检查保养内容</td>
          </tr>
        </table>
      </div>
      <table id="fenye_box_table">
      </table>

</div>
    
<div id="oper_div"><span class="tj_btn"><a href="#"
  onclick="save()"></a></span> <span class="gb_btn"><a href="#"
  onclick="newClose()"></a></span></div>
</div>
</div>
</form>
</body>
<script type="text/javascript">
  cruConfig.contextPath =  "<%=contextPath%>";
  cruConfig.cdtType = 'form';
  cruConfig.queryStr = "";
  var obj = window.dialogArguments;
  var checked = false;
	function check(){
		var chk = document.getElementsByName("rdo_entity_name");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
  
  function refreshData(){
	var superior_code_id=$("#superior_code_id").val();
	if($("#s_code_type").val()==null)
	{
		var retObj,queryRet;
		//回填保养类型
		var bysql = "select coding_name,coding_code_id,superior_code_id from comm_coding_sort_detail where coding_sort_id='5110000190' and SUPERIOR_CODE_ID in ('0', '1')  and bsflag = '0'  order by coding_show_id";
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+bysql);
		retObj = queryRet.datas;
		if(retObj!=undefined && retObj.length>=1){
			//回填信息
			var optionhtml = "";
			for(var index=0;index<retObj.length;index++){
				if(superior_code_id!='null')
					{
						if(superior_code_id==retObj[index].coding_code_id)
							{
							optionhtml +=  "<option name='codeType' id='codeType"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
							}
					}
				else
					{
				optionhtml +=  "<option name='codeType' id='codeType"+index+"' value='"+retObj[index].coding_code_id+"'>"+retObj[index].coding_name+"</option>";
					}
			}
			$("#s_code_type").append(optionhtml);
		}
	}
		 var table=document.getElementById("lineTable");
		  var autoOrder = document.getElementById("lineTable").rows.length;
		  for(var i=autoOrder-1;i>0;i--){
			  table.deleteRow(i);
		  }
		  var table=document.getElementById("lineTable");
		  var autoOrder = document.getElementById("lineTable").rows.length;
		  for(var i=autoOrder-1;i>0;i--){
			  table.deleteRow(i);
		  }
		var result=$("#s_code_type").val();
		var retObjList,retObjList;
		var bysql = "select coding_name,coding_code_id from comm_coding_sort_detail where coding_sort_id='5110000190' and SUPERIOR_CODE_ID in ('"+result+"')  and bsflag = '0' ";
	
		if(obj.pageselectedstr != null){
			bysql +=" and coding_code_id not in("+obj.pageselectedstr+") ";
		}
		bysql+="order by coding_show_id ";
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+bysql);
		retObjList = queryRet.datas;
		if(retObjList!=undefined && retObjList.length>=1){
			//回填信息
			for(var index=0;index<retObjList.length;index++){
				var table=document.getElementById("lineTable");
				var autoOrder = document.getElementById("lineTable").rows.length;
				var newTR = document.getElementById("lineTable").insertRow(autoOrder);
				var tdClass = 'even';
				if(autoOrder%2==0){
					tdClass = 'odd';
				}
				var td = newTR.insertCell(0);
				td.innerHTML = "<input type='checkbox' name='rdo_entity_name' value='" + retObjList[index].coding_code_id + "'/>";
				td.className = tdClass+'_odd';
				   if(autoOrder%2==0){
					td.style.background = "#f6f6f6";
				}else{
					td.style.background = "#e3e3e3";
				}
				   
				td = newTR.insertCell(1);
				td.innerHTML = index+1;
				td.className =tdClass+'_even'
				   if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}   
				
				td = newTR.insertCell(2);
				td.innerHTML = retObjList[index].coding_name;
				td.className =tdClass+'_even'
				   if(autoOrder%2==0){
					td.style.background = "#FFFFFF";
				}else{
					td.style.background = "#ebebeb";
				}   
				
			}
		}
		
		
		
 
  }
  function save(){  
    //if (!checkForm()) return;
    var ids = "";
    ids = getSelIds('rdo_entity_name');
      if (ids == "") {
        alert("请选择一条记录!");
        return;
      }
      var temp = ids.split(",");
		var wz_ids = "";
		for(var i=0;i<temp.length;i++){
			if(wz_ids!=""){
				wz_ids += ","; 
			}
			wz_ids += "'"+temp[i]+"'";
		}
      window.returnValue = wz_ids;
  	  window.close();
  }
  
  function newClose(){
	  var wz_ids = "";

	  window.returnValue = wz_ids;
	  window.close();
  }
  
  
</script>
</html>