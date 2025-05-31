<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String deviceId = request.getParameter("device_id");
	String userOrgId = user == null || user.getOrgId() == null ? "" : user.getOrgId().trim();
	String subOrgId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>项目页面</title> 
<meta charset="utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
 </head> 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">采集设备名称</td>
			    <td class="ali_cdn_input"><input id="query_dev_name" name="query_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">设备规格型号</td>
			    <td class="ali_cdn_input">
			    <input id="type_id" name="type_id" type="text" />
      			</td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>
			          			
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="gl" event="onclick='newSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
					<td class="bt_info_odd" exp="{dev_name}">采集设备名称</td>
					<td class="bt_info_even" exp="{dev_type}">采集设备类型</td>
					<td class="bt_info_odd" exp="{dev_model}">采集设备型号</td>
					<td class="bt_info_even" exp="{unit_name}">计量单位</td>
					<td class="bt_info_odd" exp="{usage_org}">所在单位</td>
					<td class="bt_info_even" exp="{total_num}">总数量</td>
					<td class="bt_info_odd" exp="{unuse_num}">闲置数量</td>
					<td class="bt_info_even" exp="{use_num}">在用数量</td>
					<td class="bt_info_odd" exp="{other_num}">其他数量</td>
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
				      <label>
				        <input type="text" name="textfield" id="textfield" style="width:20px;" />
				      </label></td>
				    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
				  </tr>
				</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1)">技术状况</a></li>
			    <li id="tag3_2" ><a href="#" onclick="getTab3(2)">台账变更记录</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	 <tr>
						    <td class="inquire_item6">采集设备名称</td>
						    <td class="inquire_form6"><input id="dev_name" name="dev_name"  class="input_width" type="text" /></td>
						    <td class="inquire_item6">采集设备类型</td>
						    <td class="inquire_form6"><input id="dev_type" name="dev_type" class="input_width" type="text" /></td>
						    <td class="inquire_item6">采集设备型号</td>
						    <td class="inquire_form6"><input id="dev_model" name="dev_model" class="input_width" type="text" /></td>
						 </tr>
						 <tr>
						    <td class="inquire_item6">所在单位</td>
						    <td class="inquire_form6"><input id="usage_org" name="usage_org" class="input_width" type="text" /></td>
						     <td class="inquire_item6">计量单位</td>
						    <td class="inquire_form6"><input id="unit_name" name="unit_name" class="input_width" type="text" /></td>
						    <td class="inquire_item6">所在位置</td>
						    <td class="inquire_form6"><input id="dev_position" name="dev_position" class="input_width" type="text" /></td>
						 </tr>
						 <tr>
						    <td class="inquire_item6">总数量</td>
						    <td class="inquire_form6"><input id="total_num" name="total_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">闲置数量</td>
						    <td class="inquire_form6"><input id="unuse_num" name="unuse_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">在用数量</td>
						    <td class="inquire_form6"><input id="use_num" name="use_num" class="input_width" type="text" /></td>
						 </tr>
						  <tr>
						    <td class="inquire_item6">其它数量</td>
						    <td class="inquire_form6"><input id="other_num" name="other_num" class="input_width" type="text" /></td>
						 </tr>
			        </table>
				</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
				  	<tr align="right">
				  		<td class="ali_cdn_name" ></td>
				  		<td class="ali_cdn_input" ></td>
				  		<td class="ali_cdn_name" ></td>
				  		<td class="ali_cdn_input" ></td>
				  		<td>&nbsp;</td>
						<auth:ListButton functionId="" css="xg" event="onclick='toEditTech()'" title="JCDP_btn_edit"></auth:ListButton>
					</tr>
				</table>
				<table id="tab_dev_tech" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">完好</td>
						    <td class="inquire_form6"><input id="good_num" name="good_num"  class="input_width" type="text" /></td>
						    <td class="inquire_item6">待报废</td>
						    <td class="inquire_form6"><input id="touseless_num" name="touseless_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">维修</td>
						    <td class="inquire_form6"><input id="torepair_num" name="torepair_num" class="input_width" type="text" /></td>
						</tr>
						<tr>    
						    <td class="inquire_item6">盘亏</td>
						    <td class="inquire_form6"><input id="tocheck_num" name="tocheck_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">毁损</td>
						    <td class="inquire_form6"><input id="destroy_num" name="destroy_num" class="input_width" type="text" /></td>
						 </tr>
				</table>
			</div>
			<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<table id="tab_dev_rec" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    <tr class="bt_info">
			    		<td class="bt_info_odd" width="5%">序号</td>
						<td class="bt_info_even" width="11%">操作类型</td>
						<td class="bt_info_odd" width="11%">操作时间</td>
						<td class="bt_info_even" width="11%">操作数量</td>
						<td class="bt_info_odd" width="11%">总数量</td>
						<td class="bt_info_even" width="6%">闲置数量</td>
						<td class="bt_info_odd" width="6%">在用数量</td>
						<td class="bt_info_even" width="6%">其他数量</td>
						<td class="bt_info_odd" width="6%">完好数量</td>
						<td class="bt_info_even" width="6%">维修数量</td>
						<td class="bt_info_odd" width="6%">盘亏数量</td>
						<td class="bt_info_even" width="6%">毁损数量</td>
			        </tr>
			        <tbody id="recDetailList" name="recDetailList" ></tbody>
				</table>
			</div>
		 </div>
</div>
<script  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script  src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script  src="<%=contextPath%>/js/gms_list.js"></script>
<script  src="<%=contextPath%>/js/dialog_open1.js"></script>
<script >
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var deviceId = '<%=deviceId%>';
	var userOrgId = '<%=userOrgId%>';
	var selectedTagIndex = 0;
	//下拉时查询
	function selectRefreshData(){
	    searchDevData();
	}
	function searchDevData(){
		var query_dev_name = document.getElementById("query_dev_name").value;
		var query_dev_type = document.getElementById("type_id").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":query_dev_name});
		obj.push({"label":"dev_model","value":query_dev_type});		
		refreshData(obj);
	}
	//点击树节点查询
	function refreshData(arrObj){
		var str =  ( deviceId == ""  || deviceId == 'root') ? '' : " and gc1.node_parent_id ='"+deviceId+"'";
		var sql = "select ga.*,gc1.dev_name as dev_type,usageorg.org_abbreviation as usage_org,";
		sql += "unitsd.coding_name as unit_name ";
		sql += "from gms_device_coll_account ga ";
		sql += "left join gms_device_collectinfo gc1 on ga.device_id=gc1.device_id ";
		sql += "left join comm_org_information usageorg on ga.usage_org_id=usageorg.org_id ";
		sql += "left join comm_coding_sort_detail unitsd on ga.dev_unit=unitsd.coding_code_id ";
		sql += "where gc1.is_leaf = '1' and ga.usage_sub_id like '<%=subOrgId%>%' and ga.bsflag='0' ";
		sql += str;
		for(var key in arrObj) { 
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
					sql += " and ga."+arrObj[key].label+" like '%"+arrObj[key].value+"%'";
			}
		}
		cruConfig.queryStr = sql;
		queryData(cruConfig.currentPage);
	}
	//打开新增界面
	function toAdd(){   
		popWindow("<%=contextPath%>/rm/dm/collectTree/toAdd.jsp"); 
	}
    //修改界面
    function toEdit(){  
     	 ids = getSelIds('rdo_entity_id');  
	 	 if(ids==''){  alert("请选择一条信息!");  return;  }  
	 	 selId = ids.split(',')[0]; 
	 	 editUrl = "<%=contextPath%>/rm/dm/collectTree/toEdit.jsp?id={id}";  
	 	 editUrl = editUrl.replace('{id}',selId); 
 
		 //editUrl += '&pagerAction=edit2Edit';
	 	 popWindow(editUrl); 
	  } 
	  //选择一条记录
	  function chooseOne(cb){   
        var obj = document.getElementsByName("rdo_entity_id");  
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else 
             {obj[i].checked = true;  
              checkvalue = obj[i].value;
             } 
        }   
	  }   
	
    //点击记录查询明细信息
    function loadDataDetail(shuaId){
    	var retObj;
		if(shuaId!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getCollectDevAccInfo", "deviceAccId="+shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    shuaId = ids;
		    retObj = jcdpCallService("DevCommInfoSrv", "getCollectDevAccInfo", "deviceAccId="+ids);
		}
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
        for (i=0; i<obj.length; i++){   
            obj[i].checked = false;   
        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+retObj.deviceaccMap.dev_acc_id).attr("checked","checked");
		//------------------------------------------------------------------------------------
		for(var i in retObj.deviceaccMap){
			if(i == 'type_id'){
				continue;
			}
			$("#"+i).val(retObj.deviceaccMap[i]);
		}
		//给变更记录也回填
		var detSql = "select * from gms_device_coll_record where dev_acc_id='"+shuaId+"' order by create_date";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+detSql+"&pageSize=1000");
		basedatas = queryRet.datas;
		if(basedatas!=undefined && basedatas.length>=1){
			//先清空
			var filtermapid = "#recDetailList";
			$(filtermapid).empty();
			appendDataToDetailTab(filtermapid,basedatas);
		}else{
			var filtermapid = "#recDetailList";
			$(filtermapid).empty();
		}
    }
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].rectype+"</td><td>"+datas[i].recdate+"</td>";
			innerHTML += "<td>"+datas[i].opr_num+"</td><td>"+datas[i].total_num+"</td>";
			innerHTML += "<td>"+datas[i].unuse_num+"</td><td>"+datas[i].use_num+"</td><td>"+datas[i].other_num+"</td>";
			innerHTML += "<td>"+datas[i].wanhao_num+"</td><td>"+datas[i].weixiu_num+"</td>";
			innerHTML += "<td>"+datas[i].pankui_num+"</td><td>"+datas[i].huisun_num+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	function toDelete(){
 		var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ alert("请先选中一条记录!");
		     	return;
		    }	
			    
			if(confirm('确定要删除吗?')){
				var path = "<%=contextPath%>/rad/asyncUpdateEntitiesBySql.srq";
				var sql = "update GMS_DEVICE_COLL_ACCOUNT set bsflag = '1' where dev_acc_id = '{id}'";
				var paramStr = "sql="+sql+"&ids="+ids;
				syncRequest('post',path,paramStr); 
				queryData(cruConfig.currentPage);
				
			}

	}
	//打开查询条件页面
    function newSearch(){
    	popWindow('<%=contextPath%>/rm/dm/collectTree/devquery.jsp');
    }    
    //清空查询条件
    function clearQueryText(){
    	document.getElementById("query_dev_name").value="";
		document.getElementById("type_id").value="";
    }
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
		if(userOrgId == ""){
			parent.window.location.href = '<%=contextPath%>';
		}
		//增加select下面的option
		var sql = "select  distinct dev_name , device_id  from gms_device_collectinfo  where is_leaf != 1";
		var result = jcdpQueryRecords(sql);
		if(result["returnCode"] == 0){
			var datas = result.datas;
			for(var i=0 , length = datas.length ; i < length ; i++){
				$("#type_id").append("<option value="+datas[i]["device_id"]+">"+datas[i]["dev_name"]+"</option>");
			}
		}
		$(window).resize(function(){
	  		frameSize();
		});
	})	
	$(document).ready(lashen);
	
	function toEditTech(){
		
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    popWindow('<%=contextPath%>/rm/dm/collectTree/editTech.jsp?devaccid='+ids); 
		
	}
</script>
</body>
</html>