<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userid = user.getOrgId();
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

  <title>RFID列表</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">EPC</td>
			    <td class="ali_cdn_input"><input id="s_epc_code" name="s_epc_code" type="text" /></td>
			    <td class="ali_cdn_name">设备类型</td>
			    <td class="ali_cdn_input"><input id="s_dev_ci_name" name="s_dev_ci_name" type="text" /></td>
			    <td class="ali_cdn_name">&nbsp;</td>
			    <td class="ali_cdn_input">&nbsp;</td>
			    <!-- <td class="ali_cdn_name">调配单号</td>
			    <td class="ali_cdn_input"><input id="s_mixinfo_no" name="s_mixinfo_no" type="text" /></td>
			    <td class="ali_cdn_name">出库单号</td>
			    <td class="ali_cdn_input"><input id="s_outinfo_no" name="s_outinfo_no" type="text" /></td> -->
			    <td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddRFID()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toUpdateRFID()'" title="编辑"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportDataDoc()'" title="导出excel"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
			     	<td class="bt_info_even" exp="<input type='checkbox' name='selectedbox' value='{id}~{dev_acc_id}' id='selectedbox_{id}~{dev_acc_id}'  onclick='loadDataDetail(this);'/>" >选择</td>
					<td class="bt_info_odd" autoOrder="1">序号</td>
					<td class="bt_info_even" exp="{epc_code}">EPC编号</td>
					<td class="bt_info_odd" exp="{tagid}">TAGID</td>
					<td class="bt_info_even" exp="{ctname}">设备类型</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
			     </tr> 
			  </table>
			</div>
			<div id="fenye_box"  style="display:block">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
				  <tr>
				    <td align="right">第1/1页，共0条记录</td>
				    <td width="10">&nbsp;</td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
				    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
				    <td width="50">到 
				      <label><input type="text" name="textfield" id="textfield" style="width:20px;" />
				      </label></td>
				    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				  </tr>
				</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">RFID信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">设备信息</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					  <tr>
						<td class="inquire_item6">EPC编号</td>
						<td class="inquire_form6"><input id="epc_code" name="epc_code" class="input_width" type="text" readonly="readonly"/></td>
						<td class="inquire_item6">TAGID</td>
						<td class="inquire_form6"><input id="tagid" name="tagid" class="input_width" type="text" readonly="readonly" /></td>
						<td class="inquire_item6">创建日期</td>
						<td class="inquire_form6"><input id="create_date" name="create_date" class="input_width" type="text" readonly="readonly" /></td>
					  </tr>
						<tr>
						<td class="inquire_item6">备注</td>
						<td class="inquire_form6" colspan="5"><textarea id="rfid_desc" name="rfid_desc" class="input_width" type="text" readonly="readonly"></textarea></td>
					  </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">设备名称</td>
						    <td class="inquire_form6"><input id="dev_name" name="dev_name"  class="input_width" type="text" readonly="readonly" /></td>
						    <td class="inquire_item6">规格型号</td>
						    <td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" readonly="readonly" /></td>
						    <td class="inquire_item6">设备编码</td>
						    <td class="inquire_form6"><input id="dev_type" name="dev_type" class="input_width" type="text" readonly="readonly" /></td>
						 </tr>
						 <tr>
						    <td class="inquire_item6">实物标识号</td>
						    <td class="inquire_form6"><input id="dev_sign" name="dev_sign" class="input_width" type="text" readonly="readonly" /></td>
						    <td class="inquire_item6">自编号</td>
						    <td class="inquire_form6"><input id="self_num" name="self_num" class="input_width" type="text" readonly="readonly" /></td>
						    <td class="inquire_item6">牌照号</td>
						    <td class="inquire_form6"><input id="license_num" name="license_num" class="input_width" type="text" readonly="readonly" /></td>
						  </tr>
						  <tr>
						    
						    <td class="inquire_item6">资产编号</td>
						    <td class="inquire_form6"><input id="asset_coding" name="asset_coding" class="input_width" type="text" readonly="readonly" /></td>
						    <td class="inquire_item6">发动机号</td>
						    <td class="inquire_form6"><input id="engine_num" name="engine_num" class="input_width" type="text" readonly="readonly" /></td>
						    <td class="inquire_item6">底盘号</td>
						    <td class="inquire_form6"><input id="chassis_num" name="chassis_num" class="input_width" type="text" readonly="readonly" /></td>
						  </tr>
						  <tr>
						    <td class="inquire_item6">出厂编号</td>
						    <td class="inquire_form6"><input id="" name="" class="input_width" type="text" readonly="readonly" /></td>
						    <td class="inquire_item6">出厂日期</td>
						    <td class="inquire_form6"><input id="producting_date" name="producting_date" class="input_width" type="text" readonly="readonly" /></td>
						    <td class="inquire_item6">资产状况</td>
						    <td class="inquire_form6">&nbsp;</td>
						  </tr>
						   <tr>
						    <td class="inquire_item6">技术状况</td>
						    <td class="inquire_form6"><input id="tech_stat_desc" name="tech_stat_desc" class="input_width" type="text" readonly="readonly" /></td>
						    <td class="inquire_item6">使用状况</td>
						    <td class="inquire_form6"><input id="using_stat_desc" name="using_stat_desc" class="input_width" type="text" readonly="readonly" /></td>
						    <td class="inquire_item6">项目名称</td>
						    <td class="inquire_form6"><input id="project_name_desc" name="project_name_desc" class="input_width" type="text" readonly="readonly" /></td>
						  </tr>
						               
			        </table>
				</div>
		 </div>
</div>
</body>
<script type="text/javascript">
	function frameSize(){
		//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
		setTabBoxHeight();
	}
	frameSize();
	
	
	$(function(){
		$(window).resize(function(){
	  		frameSize();
		});
	})

	var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		$(filternotobj).hide();
		$(filterobj).show();
	}

	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	
	function exportDataDoc(){
		//获得当前行的状态，如果不是已提交，那么不能打印
		var shuaId;
		var outstate;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				shuaId = this.value;
				outstate = this.outstate;
			}
		});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		if(outstate=='9' || outstate=='0'){
			
		}//if(outstate!='9')
			
		else{
			alert("本调配单状态不是'已调配'，不能打印!");
			return;
		}
		var info = shuaId.split("~" , -1);
		if(info[0]!=''){
			//调用打印方法
			var path = cruConfig.contextPath+"/rm/dm/common/DmDocToExcel.srq";
			var submitStr = "baseTableName=gms_device_coll_outform&baseid="+info[0]+"&subTableName=gms_device_coll_outsub";
			var retObj = syncRequest("post", path, submitStr);
			var filename=retObj.excelName;
			filename = encodeURI(filename);
			filename = encodeURI(filename);
			var showname=retObj.showName;
			showname = encodeURI(showname);
			showname = encodeURI(showname);
			window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+filename+"&showname="+showname;
			//window.location=cruConfig.contextPath+"/rm/dm/common/download_temp.jsp?filename="+retObj.excelName+"&showname="+retObj.showName;
		}else{
			alert("您尚未开据本申请单对应的调配单，请查看!");
			return;
		}
	}
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	function searchDevData(){
		var s_dev_name = document.getElementById("s_dev_name").value;
		var s_dev_ci_name = document.getElementById("s_dev_ci_name").value;
		var s_epc_code = document.getElementById("s_epc_code").value;
		refreshData(s_dev_name, s_dev_ci_name, s_epc_code);
	}
	
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
    	document.getElementById("s_dev_ci_name").value="";
		document.getElementById("s_epc_code").value="";
    }

	function refreshData(s_dev_name, s_dev_ci_name, s_epc_code){
		var str = "select t.*,a.dev_name,ci.dev_ci_name,ci.dev_ci_model,ct.dev_name ctname,m.dev_acc_id,m.dev_ci_id,m.dev_seq,m.type_seq from GMS_DEVICE_RFID t "
				+ " left join GMS_DEVICE_RFIDMAPPING m on t.id=m.rfid_id "
				+ " left join gms_device_account_b a on m.dev_acc_id=a.dev_acc_id and a.bsflag='0' "
				+ " left join GMS_DEVICE_CODEINFO ci on a.dev_type=ci.dev_ci_code "
				+ " left join GMS_DEVICE_COLL_MAPPING mp on mp.dev_ci_code=ci.dev_ci_code "
				+ " left join GMS_DEVICE_COLLECTINFO ct on ct.device_id=mp.device_id "
				+ " where t.bsflag='0' and t.ownorg_suborg_id like '<%=orgsubid%>%' ";
		if(s_dev_name!=undefined && s_dev_name!=''){
			str += " and a.dev_name like '%"+s_dev_name+"%' ";
		}
		if(s_dev_ci_name!=undefined && s_dev_ci_name!=''){
			str += " and ct.dev_name like '%"+s_dev_ci_name+"%' ";
		}
		if(s_epc_code!=undefined && s_epc_code!=''){
			str += "and t.epc_code like '%"+s_epc_code+"%' ";
		}
		str += " order by t.modifi_date desc";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
	}
	
	function toAddRFID(){
		popWindow('<%=contextPath%>/rm/dm/rfid/rfid/rfidInfoAdd.jsp','700:680');
	}
	function toUpdateRFID(){
		var shuaId;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				shuaId = this.value;
				outstate = this.outstate;
			}
		});
		if(shuaId == undefined){
			alert("请选择一条记录!");
			return;
		}
		var info = shuaId.split("~" , -1);
		popWindow('<%=contextPath%>/rm/dm/rfid/rfid/rfidInfoUpdate.jsp?id='+info[0],'700:680');
	}
	
	function dbclickRow(shuaId){
		var info = shuaId.split("~" , -1);
		popWindow('<%=contextPath%>/rm/dm/rfid/rfid/rfidInfoUpdate.jsp?id='+info[0],'700:680');
	}
	function toDelRecord(){
		var length = 0;
		var idinfo=null;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				length = length+1;
				var curvalue = this.value;
				var curvalues = curvalue.split("~",-1);
				if(idinfo==null){
					idinfo = curvalues[0];
				}else{
					idinfo += "~"+curvalues[0];
				}
			}
		});
		if(length == 0){
			alert("请选择删除的记录！");
			return;
		}
		if(confirm("是否执行删除操作?")){
			var idinfos = idinfo.replace(/[~]/g,"','");
			idinfos = "'"+idinfos+"'";
			alert(idinfos);
			var sql = "update GMS_DEVICE_RFID set bsflag='1',modifier='<%=userid%>',MODIFI_DATE=sysdate where id in ("+idinfos+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			syncRequest('Post',path,params);
			refreshData();
		}
	}

    function loadDataDetail(shuaId){
    	$.each($("input[name='selectedbox']"),function(i,k){
    		if($(k).val()==shuaId){
    			$(k).attr("checked","checked");
    		}else{
    			$(k).removeAttr("checked");
    		}
    	});
    	
	    var idArr = shuaId.split("~");
	    var rfidObj = jcdpCallService("DevCommInfoSrv", "getRFIDInfoByID", "id="+idArr[0]);
	    $.each(rfidObj.rfid,function(m,n){
	    	$("#"+m,"#tab_box_content0").val(n);
	    });
	    if(idArr.length>1 && idArr[1]!=''){
	    	var retObj = jcdpCallService("DevCommInfoSrv", "getRFIDDevAccInfo", "deviceId="+idArr[1]);
		    $.each(retObj.deviceaccMap,function(m,n){
		    	$("#"+m,"#tab_box_content1").val(n);
		    });
	    }else{
	    	$.each($("input","#devMap"),function(i,k){
	    		$(k).val("");
	    	});
	    }
    }
</script>
</html>