<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String taskId = request.getParameter("taskId");
	String projectInfoNo = request.getParameter("projectInfoNo");
  	String code = request.getParameter("code");
  	String is_devicecode = request.getParameter("isDeviceCode");
	String userOrgId = user.getSubOrgIDofAffordOrg();
	String userSubid = user.getOrgSubjectionId();
	String orgId= user.getOrgId();
	String orgType="";
	String dgOrg="C6000000000039,C6000000000040,C6000000005269,C6000000005280,C6000000005275,C6000000005279,C6000000005278,C6000000007366";
	//大港8个服务中心判断标志
	if(dgOrg.contains(orgId)){
		orgType="Y";
	}else{
		orgType="N";
	}
	String zhEquSub="";
	if(userSubid.startsWith("C105008042")){//综合物化探机动设备服务中心用户显示设备物资科设备
		zhEquSub="Y";
	}
	
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
  <title>多项目-二线设备台账列表</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
 <form name="form1" id="form1" method="post" action="">
 </form>
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">设备名称</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_name" name="s_dev_name" type="text" /></td>
			    <td class="ali_cdn_name">规格型号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_dev_model" name="s_dev_model" type="text" /></td>
			    <td class="ali_cdn_name" >牌照号</td>
			    <td class="ali_cdn_input" style="width:110px;"><input id="s_license_num" name="s_license_num" type="text" /></td>
			    <td class="ali_cdn_name">所属单位</td>
			    <td class="ali_cdn_input" style="width:110px;">
			    	<input id="s_own_org_name" name="s_own_org_name" type="text" />
			    </td>
			    <td class="ali_cdn_input" style="width:50px;">
					<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()"  />
					<input id="owning_org_id" name="owning_org_id" class="" type="hidden" />
			    </td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
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
			  <table style="width:98.5%" border="0" cellspacing="0" class="tab_info" id="queryRetTable">		
			     <tr >
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}~{spare4}' id='rdo_entity_id_{dev_acc_id}' />" >选择</td>
					<td class="bt_info_even" exp="{dev_type}">设备编码</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{license_num}">牌照号</td>
					<td class="bt_info_odd" exp="{producting_date}">投产日期</td>
					<td class="bt_info_even" exp="{asset_value}">固定资产原值</td>
					<td class="bt_info_even" exp="{owning_org_name_desc}">所属单位</td>
					<td class="bt_info_odd" exp="{usage_org_name_desc}">所在单位</td>
					<td class="bt_info_even" exp="{using_stat_desc}">使用情况</td>
					<td class="bt_info_odd" exp="{tech_stat_desc}">技术状况</td>
					<td class="bt_info_odd" exp="{dev_position}">所在位置</td>
					<td class="bt_info_even" exp="{ifcountry_tmp}">国内/国外</td>
					<td class="bt_info_odd" exp="{asset_coding}">AMIS资产编号</td>
					<td class="bt_info_even" exp="{cont_num}">合同编号</td>
					<td class="bt_info_odd" exp="{turn_num}">转资单号</td>
					<td class="bt_info_even" exp="{requ_num}">调拨单号</td>
					<td class="bt_info_odd" exp="{erp_id}">ERP设备编号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{account_stat_desc}">资产状况</td>
					<td class="bt_info_even" exp="{spare1}">备注1</td>
					<td class="bt_info_odd" exp="{spare2}">备注2</td>
					<td class="bt_info_even" exp="{spare3}">备注3</td>
					<!-- <td class="bt_info_odd" exp="{spare4}">备注4</td> -->
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
	<div id="oper_div" style="margin-bottom:5px">
			 	<span class="tj_btn"><a href="#" onclick="toCopy()"></a></span>
			    <span class="gb_btn"><a href="#" onclick="newCloseF()"></a></span>
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

$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var orgtype = '<%=orgType%>';//大港8个专业化中心判断
	var zhequsub = '<%=zhEquSub%>';
	var usersubid = '<%=userSubid%>';
	var taskIds = '<%=taskId%>';
	var projectInfoNos = '<%=projectInfoNo%>';

	function searchDevData(){
		var v_dev_name = document.getElementById("s_dev_name").value;
		var v_dev_model = document.getElementById("s_dev_model").value;
		var v_license_num = document.getElementById("s_license_num").value;
		//var v_dev_asset_stat = document.getElementById("s_dev_account_stat").value;
		var owning_org_id = document.getElementById("owning_org_id").value;
		var obj = new Array();
		obj.push({"label":"dev_name","value":v_dev_name});
		//obj.push({"label":"account_stat","value":v_dev_asset_stat});
		obj.push({"label":"dev_model","value":v_dev_model});
		obj.push({"label":"owning_sub_id","value":owning_org_id});
		obj.push({"label":"license_num","value":v_license_num});
		refreshData(obj);
	}
	//清空查询条件
    function clearQueryText(){
    	document.getElementById("s_dev_name").value="";
    	document.getElementById("s_dev_model").value="";
		document.getElementById("s_own_org_name").value="";
		document.getElementById("s_license_num").value="";		
    }
	//点击树节点查询
	var code = '<%=code%>';
	var is_devicecode = '<%=is_devicecode%>';
	//code = code.replace("S","");//点根节点时去除S,只有根节点带S
	
	function refreshData(arrObj,content){
		
		var userid = '<%=userOrgId%>';
		var orgLength = userid.length;
		var str = "";
		if(orgLength==4){
			str += "select aa.*,(case when aa.owning_org_name_desc=aa.use_name then '' else aa.use_name end)use_name_desc from (select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, "+
			" nvl(t.ifcountry, '国内') as ifcountry_tmp,(select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,t.*,substr(t.foreign_key,8) as erp_id,"+
			" (select pro.project_name from gp_task_project pro where pro.project_info_no=t.project_info_no) as project_name_desc,"+
			" (case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探开发处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'  else (case when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as owning_org_name_desc ,i.org_abbreviation usage_org_name_desc ,nvl(pi.org_abbreviation,org.org_abbreviation) use_name,"+
			" (select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc "+
			" from gms_device_account t inner join (comm_org_subjection s inner join comm_org_information org on s.org_id=org.org_id) on t.owning_sub_id=s.org_subjection_id "+
			" left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag ='0'"+
			" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'"+
			" left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and d.bsflag ='0' "+
			" left join comm_org_information pi on d.org_id = pi.org_id and pi.bsflag ='0'";
		}else{
			str += "select aa.*,aa.use_name use_name_desc from (select (select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc, "+
			" nvl(t.ifcountry, '国内') as ifcountry_tmp,(select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,t.*,substr(t.foreign_key,8) as erp_id,"+
			" (select pro.project_name from gp_task_project pro where pro.project_info_no=t.project_info_no) as project_name_desc,"+
			" org.org_abbreviation as owning_org_name_desc ,i.org_abbreviation usage_org_name_desc ,pi.org_abbreviation use_name,"+
			" (select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc "+
			" from gms_device_account t inner join (comm_org_subjection s inner join comm_org_information org on s.org_id=org.org_id) on t.owning_sub_id=s.org_subjection_id "+
			" left join comm_org_information i on t.usage_org_id = i.org_id and i.bsflag ='0'"+
			" left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag ='0'"+
			" left join gp_task_project_dynamic d on p.project_info_no = d.project_info_no and d.bsflag ='0' "+
			" left join comm_org_information pi on d.org_id = pi.org_id and pi.bsflag ='0'";
		}
		if(orgtype == 'Y'){//大港8个专业化中心只能看到自己中心的数据
			if(code =='08'){
				str += " where t.bsflag='0' and (t.dev_type like 'S0801%' or t.dev_type like 'S0802%' or t.dev_type like 'S0803020015%' or t.dev_type like 'S080304%' or t.dev_type like 'S0804%' or t.dev_type like 'S080503%' or t.dev_type like 'S08060701%') and t.owning_sub_id like '"+usersubid+"%' ";
			}else if(code == ''){
				str += " where t.bsflag='0' and t.owning_sub_id like '"+usersubid+"%' ";
			}else{
				if(is_devicecode=='Y'){
					//如果是非叶子节点，那么用code拼like
					str += " where t.bsflag='0' and t.dev_type like"+"'S"+code+"%' and t.owning_sub_id like '"+usersubid+"%' ";			
				}else{
					str += " where t.bsflag='0' and t.dev_type like"+"'"+code+"%' and t.owning_sub_id like '"+usersubid+"%' ";
				}
			}
		}else{
			if(code =='08'){
				if(zhequsub == 'Y'){//综合物化探机械设备服务中心
					str += " where t.bsflag='0' and (t.dev_type like 'S0801%' or t.dev_type like 'S0802%' or t.dev_type like 'S0803020015%' or t.dev_type like 'S080304%' or t.dev_type like 'S0804%' or t.dev_type like 'S080503%' or t.dev_type like 'S08060701%') and (t.owning_sub_id like 'C105008042%' or t.owning_sub_id like 'C105008013%' )";
				}else{
					if(orgLength==4){
						str += " where t.bsflag='0' and (t.dev_type like 'S0801%' or t.dev_type like 'S0802%' or t.dev_type like 'S0803020015%' or t.dev_type like 'S080304%' or t.dev_type like 'S0804%' or t.dev_type like 'S080503%' or t.dev_type like 'S08060701%') and t.owning_sub_id like '"+userid+"%' ";
					}else{
						str += " where t.bsflag='0' and (t.dev_type like 'S0801%' or t.dev_type like 'S0802%' or t.dev_type like 'S0803020015%' or t.dev_type like 'S080304%' or t.dev_type like 'S0804%' or t.dev_type like 'S080503%' or t.dev_type like 'S08060701%') and t.owning_sub_id like '"+usersubid+"%' ";
					}
				}
			}else if(code == ''){
				if(zhequsub == 'Y'){//综合物化探机械设备服务中心
					str += " where t.bsflag='0' and (t.owning_sub_id like 'C105008042%' or t.owning_sub_id like 'C105008013%' )";
				}else{
					if(orgLength==4){
						str += " where t.bsflag='0' and t.owning_sub_id like '"+userid+"%' ";
					}else{
						str += " where t.bsflag='0' and t.owning_sub_id like '"+usersubid+"%' ";
					}
				}
			}else{
				if(is_devicecode=='Y'){
					//如果是非叶子节点，那么用code拼like
					if(zhequsub == 'Y'){//综合物化探机械设备服务中心
						str += " where t.bsflag='0' and t.dev_type like"+"'S"+code+"%' and (t.owning_sub_id like 'C105008042%' or t.owning_sub_id like 'C105008013%' )";
					}else{
						if(orgLength==4){
							str += " where t.bsflag='0' and t.dev_type like"+"'S"+code+"%' and t.owning_sub_id like '"+userid+"%' ";
						}else{
							str += " where t.bsflag='0' and t.dev_type like"+"'S"+code+"%' and t.owning_sub_id like '"+usersubid+"%' ";
						}
					}			
				}else{
					if(zhequsub == 'Y'){//综合物化探机械设备服务中心
						str += " where t.bsflag='0' and t.dev_type like"+"'"+code+"%' and (t.owning_sub_id like 'C105008042%' or t.owning_sub_id like 'C105008013%' )";
					}else{
						if(orgLength==4){
							str += " where t.bsflag='0' and t.dev_type like"+"'"+code+"%' and t.owning_sub_id like '"+userid+"%' ";
						}else{
							str += " where t.bsflag='0' and t.dev_type like"+"'"+code+"%' and t.owning_sub_id like '"+usersubid+"%' ";
						}						
					}
				}
			}
		}
		
		for(var key in arrObj) { 
			if(arrObj[key].value!=undefined && arrObj[key].value!=''){
				if(arrObj[key].label!='project_name'){
					str += "and t."+arrObj[key].label+" like '%"+arrObj[key].value+"%' ";
				}else{
					str += "and p.project_name like '%"+arrObj[key].value+"%' ";
				}
				//else{
				//	str += "and t.project_info_no in (select project_info_no from gp_task_project where project_name like '%"+arrObj[key].value+"%' and bsflag='0' ) ";
				//}
			}
		}
		debugger;
		if(content!=null&&content!=""){
			str += content;
		}
		str +="and t.account_stat !='0110000013000000005'  and t.using_stat='0110000007000000002' and t.project_info_no is null";
		str += ")aa ";
		debugger;
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		createNewTitleTable();
	}
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
	

    //修改界面
    function toEdit(){  
		ids = getSelIds('rdo_entity_id');  
		if(ids==''){  alert("请选择一条信息!");  return;  }  
		
		var columnsObj ;
		$("input[type='checkbox']", "#queryRetTable").each(function(){
			if(this.checked){
				columnsObj = this.parentNode.parentNode.cells;
			}
		});
		//if(columnsObj(22).innerText=="在账"){
		//	alert("此设备为在账设备，不允许修改!");
		//	return;
		//}

		selId = ids.split('~',-1);
		if(selId[1] != '1'){
		    alert("ERP同步设备不能修改!");
		    return;
		}
		editUrl = "<%=contextPath%>/rm/dm/deviceAccount/toEdit.jsp?id={id}";  
		editUrl = editUrl.replace('{id}',selId[0]); 
 
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
    	var info = shuaId.split("~" , -1);
		if(info[0]!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+info[0]);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("DevCommInfoSrv", "getDevAccInfo", "deviceId="+info[0]);
		}
		//取消选中框--------------------------------------------------------------------------
    	var obj = document.getElementsByName("rdo_entity_id");  
        for (i=0; i<obj.length; i++){   
            obj[i].checked = false;   
             
        } 
		//选中这一条checkbox
		$("#rdo_entity_id_"+retObj.deviceaccMap.dev_acc_id).attr("checked","checked");
		//选中这一条checkbox
		//$("#rdo_entity_id"+retObj.deviceaccMap.dev_acc_id).attr("checked","checked");
		//取消其他选中的
		//$("input[type='checkbox'][name='rdo_entity_id'][id!='selectedbox_"+retObj.deviceaccMap.dev_acc_id+"']").removeAttr("checked");
		//------------------------------------------------------------------------------------
	
    }
	
	function toCopy(){
 		ids = getSelIds('rdo_entity_id');
	    if(ids==''){ 
		    alert("请先选中一条记录!");
	     	return;
	    }
	    info = ids.split("~",-1);
	    var querySql="select count(*) as unpro_count from GMS_DEVICE_ACCOUNT_UNPRO p where p.fk_dev_acc_id='"+info[0]+"' and p.IS_LEAVING='0'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		unProCount = queryRet.datas;
	
		if (unProCount == undefined) {
			return;
		}
		if(unProCount[0].unpro_count>0)
		{
			alert("改设备已在非生产单位现场管理中,请勿重复选择！");
			return;
		}
			var retObj = jcdpCallService("DevInsSrv", "copyToUnPro", "deviceId="+info[0]);
			var result=retObj.info;
			if(result!=undefined)
			{
				if(result=='转入成功')
				{
					alert("导入成功!");
					var devId=retObj.devId;
					if(confirm('是否对该设备设置保养计划?')){  
					popWindow("<%=contextPath%>/rm/dm/device-xd/dev_byjh.jsp?ids="+devId); 
					return;
				}
				
					refreshData();
					
			}
			else
			{
				alert("未知错误！");
			}
				refreshData();
			
		}
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
		document.getElementById("s_own_org_name").value = returnValue.value;
		
		//var orgId = strs[1].split(":");
		document.getElementById("owning_org_id").value = returnValue.fkValue;
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
		var y = getAbsTop(queryRetTable)-4;
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
	

	function  newCloseF()
	{
		document.getElementById("form1").action = "<%=contextPath%>/rm/dm/closeAddUnProDevice.srq";
		document.getElementById("form1").submit();
	}
	
</script>
</html>