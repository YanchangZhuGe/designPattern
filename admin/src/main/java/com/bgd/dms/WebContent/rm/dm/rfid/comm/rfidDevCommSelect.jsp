<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgsubid = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<title>设备下拉列表</title> 
</head>
 
<body style="background:#fff" onload="refreshData('','');">
<div id="list_table">
	<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="ali_cdn_name">选项编码</td>
	    <td class="ali_cdn_input"><input id="dictkey" name="dictkey" type="text" /></td>
	    <td class="ali_cdn_name">选项名称</td>
	    <td class="ali_cdn_input"><input id="dictdesc" name="dictdesc" type="text" /></td>
	    <!-- <td class="ali_cdn_name">调配单号</td>
	    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>
	    <td class="ali_cdn_name">出库单号</td>
	    <td class="ali_cdn_input"><input id="s_outinfo_no" name="s_outinfo_no" type="text" /></td> -->
	    <td class="ali_query"><span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
	    </td>
	    <td class="ali_query"><span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
	    </td>
	    <td>&nbsp;</td>
	    <td class='ali_btn'><span class="zj"><a href="#" id="addaddedbtn" onclick="toAdd();" title="添加"></a></span></td>
	    <td class='ali_btn'><span class="xg"><a href="#" id="modaddedbtn" onclick="toModify();" title="修改"></a></span></td>
	    <td class='ali_btn'><span class="sc"><a href="#" id="deladdedbtn" onclick="toDel();" title="删除"></a></span></td>
	  </tr>
	</table>
	</td>
	    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
	  </tr>
	</table>
	</div>
	<div id="table_box">
	  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
	     <tr id='device_comm_select_{id}' name='device_comm_select'>
	     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' dictkey='{dictkey}' value='{id}' id='selectedbox_{id}~{dictkey}' onclick='chooseOne(this);'/>" >选择</td>
			<td class="bt_info_odd" autoOrder="1">序号</td>
			<td class="bt_info_even" exp="{dictkey}">选项编码</td>
			<td class="bt_info_odd" exp="{dictdesc}">选项名称</td>
	     </tr> 
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
	<div class="lashen" id="line"></div>
</div>
</body>
<script type="text/javascript">
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	function searchDevData(){
		var dictkey = document.getElementById("dictkey").value;
		var dictdesc = document.getElementById("dictdesc").value;
		refreshData(dictkey, dictdesc);
	}
	
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("dictdesc").value="";
    	document.getElementById("dictkey").value="";
    }
    
	function refreshData(dictkey, dictdesc){
		var str = "select t.id,t.dictkey,t.dictdesc from GMS_DEVICE_COMM_DICT t where t.bsflag='0' ";
		if(dictkey!=undefined && dictkey!=''){
			str += " and t.dictkey like '%"+dictkey+"%' ";
		}
		if(dictdesc!=undefined && dictdesc!=''){
			str += " and t.dictdesc like '%"+dictdesc+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
	
	function toAdd(){
		popWindow('<%=contextPath%>/rm/dm/rfid/comm/rfidDevCommSelectAdd.jsp','950:680');
		refreshData("","");
	}
	
	function toModify(){
		var shuaId;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				shuaId = this.value;
			}
		});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/rfid/comm/rfidDevCommSelectUpdate.jsp?id='+shuaId,'970:680');
	}
	
	function dbclickRow(shuaId){
		popWindow('<%=contextPath%>/rm/dm/rfid/comm/rfidDevCommSelectUpdate.jsp?id='+shuaId,'950:680');
	}
	function toDel(){
		//判断状态如果是已提交，那么不能删除,或者没建新纪录，不能删除
		var selectids='';
		var lengt = 0;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				if(selectids==''){
					selectids = this.value;
					lengt = 1;
				}else{
					selectids = selectids + "," + this.value;
					lengt = lengt+1;
				}
			}
		});
		if(lengt == 0){
			alert("请选择删除的记录！");
			return;
		}
		if(confirm("是否执行删除操作?")){
			//var ids = selectids.replace(/[,]/g,"','");
			//ids = "('"+ids+"')";
			$.ajax({
				url:"<%=contextPath%>/rm/dm/rfidCommSelectDel.srq",
				data:{"ids":selectids},
				dataType:"JSON",
				type:"POST",
				success:function(data){
					alert(data.msg);
					refreshData("","");
				},
				error:function(d){
					alert('删除发生错误');
				}
			});
		}
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