<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String code = request.getParameter("code");
	String is_leaf = request.getParameter("is_leaf");
	String node_level = request.getParameter("node_level");
	String userOrgId = user == null || user.getOrgId() == null ? "" : user.getOrgId().trim();
	String subOrgId = user.getSubOrgIDofAffordOrg();
	
	String userSubid = user.getOrgSubjectionId();
	//String orgId= user.getOrgId();
	String orgType="";
	String dgOrg="C6000000000039,C6000000000040,C6000000005269,C6000000005280,C6000000005275,C6000000005279,C6000000005278,C6000000007366";
	//大港8个服务中心判断标志
	if(dgOrg.contains(userOrgId)){
		orgType="Y";
	}else{
		orgType="N";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>项目页面</title> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open2.js"></script>
<link id="artDialogSkin" href="<%=contextPath %>/js/artDialog/skins/blue.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/artDialog.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/artDialog/iframeTools.js"></script>
 </head> 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input"><input id="query_dev_name" name="query_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">设备型号</td>
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
			    <auth:ListButton functionId="collect_add" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="collect_upd" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
			    <auth:ListButton functionId="collect_del" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' total_num='{total_num}' unuse_num='{unuse_num}' use_num='{use_num}' other_num='{other_num}' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}' />" >选择</td>
					<td class="bt_info_odd" exp="{dev_name}">采集设备名称</td>
					<td class="bt_info_even" exp="{dev_type}">采集设备类型</td>
					<td class="bt_info_odd" exp="{dev_model}">采集设备型号</td>
					<td class="bt_info_even" exp="{unit_name}">计量单位</td>
					<td class="bt_info_even" exp="{usage_org_name}">所在单位</td>
					<td class="bt_info_odd" exp="{total_num}">总数量</td>
					<td class="bt_info_even" exp="{unuse_num}">闲置数量</td>
					<td class="bt_info_odd" exp="{use_num}">在用数量</td>
					<td class="bt_info_even" exp="{other_num}">其他数量</td>
					<td class="bt_info_odd" exp="{ifcountry}">国内/国外</td>
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
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">基本信息</a></li>
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1)">技术状况</a></li>
			    <li id="tag3_2" ><a href="#" onclick="getTab3(2)">台账变更记录</a></li>
			    <li id="tag3_3" ><a href="#" onclick="getTab3(3)">项目分布</a></li>
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
						<!--<auth:ListButton functionId="" css="xg" event="onclick='toEditTech()'" title="JCDP_btn_edit"></auth:ListButton>-->
					</tr>
				</table>
				<table id="tab_dev_tech" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">完好</td>
						    <td class="inquire_form6"><input id="good_num" name="good_num"  class="input_width" type="text" /></td>
						    <td class="inquire_item6">待报废</td>
						    <td class="inquire_form6"><input id="touseless_num" name="touseless_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">待修</td>
						    <td class="inquire_form6"><input id="torepair_num" name="torepair_num" class="input_width" type="text" /></td>
						</tr>
						<tr>   
						 <td class="inquire_item6">在修</td>
						    <td class="inquire_form6"><input id="repairing_num" name="repairing_num" class="input_width" type="text" /></td> 
						    <td class="inquire_item6">盘亏</td>
						    <td class="inquire_form6"><input id="tocheck_num" name="tocheck_num" class="input_width" type="text" /></td>
						    <td class="inquire_item6">毁损</td>
						    <td class="inquire_form6"><input id="destroy_num" name="destroy_num" class="input_width" type="text" /></td>
						 </tr>
						 <tr>
						   <td class="inquire_item6">未交回</td>
						    <td class="inquire_form6"><input id="noreturn_num" name="noreturn_num" class="input_width" type="text" /></td>
						 </tr>
				</table>
			</div>
			<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<table id="tab_dev_rec" width="130%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    <tr class="bt_info">
			    		<td class="bt_info_odd" width="5%">序号</td>
						<td class="bt_info_even" width="10%">操作类型</td>
						<td class="bt_info_odd" width="10%">操作时间</td>
						<td class="bt_info_even" width="10%">操作数量</td>
						<td class="bt_info_odd" width="6%">完好</td>
						<td class="bt_info_even" width="6%">待修</td>
						<td class="bt_info_even" width="6%">在修</td>
						<td class="bt_info_odd" width="6%">盘亏</td>
						<td class="bt_info_even" width="6%">毁损</td>
						<td class="bt_info_even" width="6%">待报废</td>
						<td class="bt_info_even" width="6%">未交回</td>
						<td class="bt_info_even" width="6%">备注</td>
			        </tr>
			        <tbody id="recDetailList" name="recDetailList"  width="130%" ></tbody>
				</table>
			</div>
			<div id="tab_box_content3" class="tab_box_content" style="display:none;">
				<table id="tab_dev_rec" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    <tr class="bt_info">
			    		<td class="bt_info_odd" width="5%">序号</td>
						<td class="bt_info_even" width="11%">项目名称</td>
						<td class="bt_info_odd" width="11%">在用数量</td>
						<td class="bt_info_even" width="11%">所在单位</td>
						<td class="bt_info_odd" width="11%">实际进场时间</td>
			        </tr>
			        <tbody id="proDetailList" name="proDetailList" ></tbody>
				</table>
			</div>
		 </div>
</div>

<script >
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var orgtype = '<%=orgType%>';//大港8个专业化中心判断
	var usersubid = '<%=userSubid%>';
	var node_level = '<%=node_level%>';
	var is_leaf = '<%=is_leaf%>';
	var code = '<%=code%>';
	var userOrgId = '<%=userOrgId%>';
	var selectedTagIndex = 0;
	var userid = '<%=subOrgId%>';
	var orgLength = userid.length;
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
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("query_dev_name").value="";
		document.getElementById("type_id").value="";
    }
	//点击树节点查询
	function refreshData(arrObj){

		var sql = "select aa.*,(aa.unuse_num+aa.use_num+aa.other_num)as total_num from ( "
				+ "select tmp.*,nvl((select sum(dui.unuse_num) from gms_device_coll_account_dui dui "
				+ "left join gp_task_project p on p.project_info_no=dui.project_info_id left join gp_task_project_dynamic dy on dy.project_info_no=dui.project_info_id "
			    + "where dui.bsflag='0' and dui.device_id=tmp.device_id and tmp.org_id is not null and dy.org_subjection_id like '%'||tmp.org_id||'%'),0) as use_num "
				+ "from (select acc.device_id,acc.dev_acc_id,acc.dev_unit,acc.dev_model,acc.dev_name, nvl(teach.tocheck_num,0) as tocheck_num, nvl(teach.noreturn_num,0)as noreturn_num, "
				+ "teach.good_num as unuse_num,(nvl(teach.touseless_num,0)+nvl(teach.torepair_num,0)+nvl(teach.repairing_num,0)+nvl(teach.tocheck_num,0)+nvl(teach.noreturn_num,0)+nvl(teach.destroy_num, 0)) as other_num, "
				+ "case when acc.ifcountry='000' then '国内' else acc.ifcountry end as ifcountry,ci.dev_code,l.coding_name as dev_type, "
				+ "usageorg.org_abbreviation as usage_org_name,owingorg.org_abbreviation as owning_org_name,unitsd.coding_name as unit_name, org.org_abbreviation as org_name, "
				+ "acc.usage_sub_id,acc.usage_org_id,acc.owning_org_id,acc.owning_sub_id,suborg.org_subjection_id, "
				+ "case when usageorg.org_abbreviation='塔里木作业部' then 'C105001005' "
				+ "when usageorg.org_abbreviation='北疆作业部' then 'C105001002' when usageorg.org_abbreviation='吐哈作业部' then 'C105001003' "
				+ "when usageorg.org_abbreviation='敦煌作业部' then 'C105001004' when usageorg.org_abbreviation='长庆作业部' then 'C105005004' " 
				+ "when usageorg.org_abbreviation='辽河作业部' then 'C105063' when usageorg.org_abbreviation='华北作业部' then 'C105005000' "
				+ "when usageorg.org_abbreviation='新区作业部' then 'C105005001' when usageorg.org_abbreviation='大港作业分部' then 'C105007' "
				+ "when usageorg.org_abbreviation='仪器设备服务中心' then 'C105007' else '' end as org_id "
				+ "from gms_device_coll_account acc left join comm_coding_sort_detail l on l.coding_code_id=acc.type_id and l.coding_sort_id like '5110000031' "
				+ "left join gms_device_collectinfo ci on acc.device_id=ci.device_id "
				+ "left join comm_org_information org on acc.owning_org_id=org.org_id and org.bsflag = '0' "
				+ "left join comm_org_information usageorg on acc.usage_org_id=usageorg.org_id and usageorg.bsflag = '0' "
				+ "left join comm_org_information owingorg on acc.owning_org_id=owingorg.org_id and owingorg.bsflag = '0' "
				+ "left join comm_org_subjection suborg on acc.owning_org_id = suborg.org_id and suborg.bsflag = '0' "
				+ "left join comm_coding_sort_detail unitsd on acc.dev_unit=unitsd.coding_code_id "
				+ "left join gms_device_coll_account_tech teach on teach.dev_acc_id=acc.dev_acc_id ";
			if(orgtype == 'Y'){//大港8个专业化中心只能看到自己中心的数据
				sql += "where acc.bsflag='0' and ci.is_leaf = '1' and acc.usage_sub_id like '"+usersubid+"%'  ";
			}else{
				sql += "where acc.bsflag='0' and ci.is_leaf = '1' and acc.usage_sub_id like '<%=subOrgId%>%'  ";
			}
			
			sql +=	")tmp where 1=1 and (tmp.dev_code like '01%' or tmp.dev_code like '02%'  or tmp.dev_code like '03%' or tmp.dev_code like '05%' ) ";
		if(node_level=='null'||node_level=='0'){
		}else if(node_level=='0'){
		}else if(node_level=='1'){
			//如果是叶子节点，那么用code拼=
			sql += "and tmp.dev_code like '"+code+"%' ";
		}else if(node_level=='2'){
			//如果是叶子节点，那么用code拼=
			sql += "and tmp.dev_code like '"+code+"%' ";
		}else{
			sql += "and tmp.dev_code like '"+code+"%' ";
		}
		
		for(var key in arrObj){
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				sql += " and tmp."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
			}
		}
		sql+=" )aa ";
		cruConfig.queryStr = sql;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
	}
	//打开新增界面
	function toAdd(){   
		popWindow("<%=contextPath%>/rm/dm/collectTreeNew/toAdddzyq.jsp"); 
	}
    //修改界面
    function toEdit(){  
     	 ids = getSelIds('rdo_entity_id');  
	 	 if(ids==''){  alert("请选择一条信息!");  return;  }  
	 	 selId = ids.split(',')[0]; 
		 var unuse_num=$("#rdo_entity_id_"+ids).attr('use_num');
		 var total_num=$("#rdo_entity_id_"+ids).attr('total_num');

	 	 editUrl = "<%=contextPath%>/rm/dm/collectTreeNew/toEditdzyq.jsp?id={id}";  
	 	 editUrl = editUrl.replace('{id}',selId); 
		 editUrl += '&unuse_num='+unuse_num;
		 editUrl += '&total_num='+total_num;
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
			 retObj = jcdpCallService("DevProSrv", "getCollectDevAccInfo", "deviceAccId="+shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    shuaId = ids;
		    retObj = jcdpCallService("DevProSrv", "getCollectDevAccInfo", "deviceAccId="+ids);
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
		$("#total_num").val($("#rdo_entity_id_"+retObj.deviceaccMap.dev_acc_id).attr('total_num'));
		$("#other_num").val($("#rdo_entity_id_"+retObj.deviceaccMap.dev_acc_id).attr('other_num'));
		$("#unuse_num").val($("#rdo_entity_id_"+retObj.deviceaccMap.dev_acc_id).attr('unuse_num'));
		$("#use_num").val($("#rdo_entity_id_"+retObj.deviceaccMap.dev_acc_id).attr('use_num'));

		//给变更记录也回填
		var detSql = "select * from gms_device_coll_record where dev_acc_id='"+shuaId+"' order by create_date desc";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+detSql+"&pageSize=1000");
		basedatas = queryRet.datas;
	
		//项目分布
		var queryProRet = jcdpCallService("DevProSrv", "getProJectInfo", "deviceId="+shuaId);
			basedatasPro = queryProRet.datas;
		if(basedatas!=undefined && basedatas.length>=1){
			//先清空
			var filtermapid = "#recDetailList";
			$(filtermapid).empty();
			appendDataToDetailTab(filtermapid,basedatas);
			var filtermapproid = "#proDetailList";
			$(filtermapproid).empty();
			if(basedatasPro!=undefined && basedatasPro.length>=1){
				appendDataToDetailPro(filtermapproid,basedatasPro);
			}
		}else if(basedatasPro!=undefined && basedatasPro.length>=1){
			//先清空
			var filtermapid = "#recDetailList";
			$(filtermapid).empty();
			appendDataToDetailTab(filtermapid,basedatas);
			var filtermapproid = "#proDetailList";
			$(filtermapproid).empty();
			appendDataToDetailPro(filtermapproid,basedatasPro);
		}else{
			var filtermapid = "#recDetailList";
			$(filtermapid).empty();
			var filtermapproid = "#proDetailList";
			$(filtermapproid).empty();
		}
		var good_num=$("#good_num").val();
		var use_num=$("#use_num").val();
		var sum=parseInt(use_num)+parseInt(good_num);
		$("#good_num").val(sum);
    }
    function dialogClose(str){
    	if(str!=''){
    		art.dialog.list['KDf435'].close();
    	}
    }
    function dialogValue(str){
    	if(str!=''){
    	 art.dialog({
    		 id:'KDf435',
    		 left:200,
    		 opacity: 0.17,
    		    padding: 0,
    		    width: '300',
    		    height: 80,
    		    title: '台帐变更明细',
    		    content: str   
    		});
    	}
    }
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr style='cursor:hand' onmouseout='dialogClose("+"\""+datas[i].remark+"\""+")' onmouseover='dialogValue("+"\""+datas[i].remark+"\""+")' >";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].rectype+"</td><td>"+datas[i].recdate+"</td>";
			innerHTML += "<td>"+datas[i].opr_num+"</td>";
			innerHTML += "<td>"+datas[i].wanhao_num+"</td><td>"+datas[i].weixiu_num+"</td><td>"+datas[i].zaixiu_num+"</td>";
			innerHTML += "<td>"+datas[i].pankui_num+"</td><td>"+datas[i].huisun_num+"</td><td>"+datas[i].touseless_num+"</td><td>"+datas[i].noreturn_num+"</td><td>"+datas[i].bak+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	function appendDataToDetailPro(filterobj,datas){
		for(var i=0;i<datas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td>";
			innerHTML += "<td>"+datas[i].project_name+"</td><td>"+datas[i].unuse_num+"</td>";
			innerHTML += "<td>"+datas[i].org_abbreviation+"</td><td>"+datas[i].actual_in_time+"</td>";
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
		if(ids==''){ 
			alert("请先选中一条记录!");
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
    	popWindow('<%=contextPath%>/rm/dm/collectTreeNew/devquery.jsp');
    }
	function frameSize(){
		setTabBoxHeight();
	}
	frameSize();
	$(function(){
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
		 popWindow('<%=contextPath%>/rm/dm/collectTreeNew/editTech.jsp?devaccid='+ids); 		
	}
	function createNewTitleTable(){
		// 如果是dialog
		if(window.dialogArguments){
			return;
		}
		
		// 如果声明了不出现固定表头
		if(window.showNewTitle==false){
			return;
		}
		
		var newTitleTable = document.getElementById("newTitleTable");
		if(newTitleTable!=null) return;
		var queryRetTable = document.getElementById("queryRetTable");
		if(queryRetTable==null) return;
		var titleRow = queryRetTable.rows(0);
		
		var newTitleTable = document.createElement("table");
		newTitleTable.id = "newTitleTable";
		newTitleTable.className="tab_info";
		newTitleTable.border="0";
		newTitleTable.cellSpacing="0";
		newTitleTable.cellPadding="0";
		newTitleTable.style.width = queryRetTable.clientWidth;
		newTitleTable.style.position="absolute";
		var x = getAbsLeft(queryRetTable);
		newTitleTable.style.left=x+"px";
		var y = getAbsTop(queryRetTable);
		newTitleTable.style.top=y+"px";
				
		var tbody = document.createElement("tbody");
		var tr = titleRow.cloneNode(true);
		
		tbody.appendChild(tr);
		newTitleTable.appendChild(tbody);
		document.body.appendChild(newTitleTable);
		// 设置每一列的宽度
		for(var i=0;i<tr.cells.length;i++){
			tr.cells[i].style.width=titleRow.cells[i].clientWidth;
			if(i%2==0){
				tr.cells[i].className="bt_info_odd";
			}else{
				tr.cells[i].className="bt_info_even";
			}
			// 设置是否显示
			if(titleRow.cells[i].isShow=="Hide"){
				tr.cells[i].style.display='none';
			}
		}
		
		document.getElementById("table_box").onscroll = resetNewTitleTablePos;		
	}
	function showOrgTreePage(){

		var returnValue = window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var orgidnames = names[1];
		document.getElementById("s_own_org_name").value = orgidnames;
		
		var orgId = strs[1].split(":");
		var orgidvalue = orgId[1];
		document.getElementById("owning_org_id").value = orgidvalue;

		var orgSubId = strs[2].split(":");
		var orgSubIdValue = orgSubId[1];
		document.getElementById("owning_sub_org_id").value = orgSubIdValue;
	}
</script>
</body>
</html>