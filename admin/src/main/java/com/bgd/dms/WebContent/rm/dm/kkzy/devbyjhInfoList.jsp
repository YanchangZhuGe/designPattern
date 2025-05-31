<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String project_name =user.getProjectName();
	SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
	String nowDate = df.format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript">
  function submitInfo(tag){
	  var tr = $(tag).parent().parent().parent();
	  var byjb;
	  var dev_acc_id;
	  var runtime;
	  tr.find("input[name='rdo_entity_id']").each(function(i){
		   if(i==0){
			   dev_acc_id=$(this).val();
		   }else if(i==1){
			   runtime=$(this).val();  
		   }
	  });
	  
	  tr.find("select[name='rdo_entity_id']").each(function(i){
		  byjb=$(this).val();
	  });
	  if(byjb=="请选择"||runtime=="")
		  {
			alert("请输入完整!");
			return;
		  }
	//只能输入数字
		 var re =/^[0-9]{0}([0-9]|[.])+$/;  
	
	   if (!re.test(runtime))   
	  	{   
	       alert("进场累计工作小时输入错误!");   
	     
	      return false;   
	  	 }

	  var submitStr = "dev_acc_id="+dev_acc_id+"&byjb="+byjb+"&runtime="+runtime;
	  retObject = jcdpCallService("DevInsSrv","saveByjhInfo",submitStr);
	  refreshData();
  }
</script>
  <title>项目页面</title> 
 </head> 
 
 <body style="background:#cdddef" onload="refreshData();show();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">自编号</td>
			    <td class="ali_cdn_input"><input id="s_self_num" name="s_self_num" type="text" /></td>
      			<td class="ali_query">
				    <span class="cx"><a href="#" onclick="searchDevData()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
			    </td>			          			
			    <td>&nbsp;</td>
			    
			     <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
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
					<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{dev_acc_id}' id='rdo_entity_id_{dev_acc_id}'  onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
				 	<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_odd"  exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_even"  exp="{dev_name}">设备名称</td>
					<td class="bt_info_odd"  exp="{dev_model}">设备型号</td>
					<td class="bt_info_odd"   exp="<input type='text' name='rdo_entity_id'  value='{lasttime}'/>  ">上次保养累计工作小时</td>
					<td class="bt_info_odd"  exp="{time}">上次保养日期</td>
					<td class="bt_info_odd"  exp="<select name='rdo_entity_id'  id='{bysx}'> 
					<option>请选择</option>
					<option>BBBC</option><option>BBCB</option><option>BCBB</option><option>CBBB</option><option>BBBD</option><option>BBDB</option><option>BDBB</option><option>DBBB</option></select>">下次保养级别顺序</td>
						<td class="bt_info_odd"  exp="<span class='tj_btn'><a href='#' onclick='submitInfo(this)' name='{dev_sign}'></a></span>"></td>
					<!-- <td class="bt_info_even" exp="{dev_position}">所在项目</td> -->
					 <td class="bt_info_even"  exp="{submitor}" >提交人</td>
					  <td class="bt_info_even"  exp="{create_date}" >提交时间</td>
					 <td class="bt_info_even"  exp="<%=project_name %>" >所在项目</td>
				
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
			    <li id="tag3_1" ><a href="#" onclick="getTab3(1);loaddata('',1)">保养计划</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">设备名称</td>
						    <td class="inquire_form6"><input id="dev_acc_name" name=""  class="input_width" type="text" /></td>
						    <td class="inquire_item6">设备型号</td>
						    <td class="inquire_form6"><input id="dev_acc_model" name="" class="input_width" type="text" /></td>
						 	<td class="inquire_item6">使用状况</td>
						    <td class="inquire_form6"><input id="dev_acc_using_stat" name="" class="input_width" type="text" /></td>
						 </tr>
						 <tr>
						    <td class="inquire_item6">资产编号</td>
						    <td class="inquire_form6"><input id="dev_acc_assetcoding" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">实物标识号</td>
						    <td class="inquire_form6"><input id="dev_acc_sign" name="" class="input_width" type="text" /></td>
						    <td class="inquire_item6">自编号</td>
						    <td class="inquire_form6"><input id="dev_acc_self" name="" class="input_width" type="text" /></td>
						  </tr>
						               
			        </table>
				</div>
			<div id="tab_box_content1" class="tab_box_content" style="display:none;">
						<table id="yzMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
					    <tr>   
						<td class="bt_info_odd">序号</td>
						<td class="bt_info_even">自编号</td>
					    <td class="bt_info_odd">设备名称</td>
						<td class="bt_info_odd">下次累计工作小时</td>
						<td class="bt_info_odd">下次保养级别</td>
						<td class="bt_info_even">下次保养时间</td>
					 </tr>	
					<tbody id="assign_body"></tbody>
				</table>
			</div>
		 </div>
</div>
</body>
<script type="text/javascript">
function mouseover(){
	alert("sdfsdf");
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
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	function searchDevData(){
		var v_self_num = document.getElementById("s_self_num").value;
		refreshData(v_self_num);
	}
	 //清空查询条件
    function clearQueryText(){
		document.getElementById("s_self_num").value="";
    }
	 
	function refreshData(v_self_num){
		var sql = "select work_hour from gms_device_zy_project p where p.project_info_id='<%=projectInfoNo%>'";
		var retObj1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
		if(retObj1.datas.length=="0")
			{
				alert("请填写项目施工履历信息!");
				return false;
			}
		var str = "";
		var projectInfoNo='<%=projectInfoNo%>';
		str+="select tt.*,(case when tt.hours is null then tt.runtime else tt.hours end )  as  lasttime from (   select t.self_num,t.dev_acc_id, runtime,";
		str+="(select bywxtime  from  (select max(bywx_date) as bywxtime,dev_acc_id from gms_device_zy_bywx  where project_info_id='"+projectInfoNo+"'   group by dev_acc_id) tt where tt.dev_acc_id=t.dev_acc_id) as time,";
		str+="(select max(work_hours) from  (select work_hours,kk.dev_acc_id";
		str+="		  from gms_device_zy_bywx kk,";
	    str+="		       (select dev_acc_id, max(bywx_date) as bywx_date";
		str+="	          from gms_device_zy_bywx   where project_info_id='"+projectInfoNo+"'";
		str+="	         group by dev_acc_id) k";
		str+="	 where kk.dev_acc_id = k.dev_acc_id";
		str+="	   and kk.bywx_date = k.bywx_date) s where s.dev_acc_id=t.dev_acc_id ) as hours,";
		str+="t.dev_sign,";
	    str+="t.dev_name,";
	    str+="t.dev_model,";
		str+="t.dev_position, b.bysx,";
		str+="(select coding_name from comm_coding_sort_detail co where co.coding_code_id=t.account_stat) as account_stat_desc,";
	    str+="(select coding_name from comm_coding_sort_detail c where t.using_stat=c.coding_code_id) as using_stat_desc,";
		str+="(select coding_name from comm_coding_sort_detail c where t.tech_stat=c.coding_code_id) as tech_stat_desc,";
	    str+="owning_org_name as owning_org_name_desc, (select task.project_name from gp_task_project task where task.project_info_no=t.project_info_id ) as pname,";
		str+="usage_org_name as usage_org_name_desc,b.creator,b.create_date,(case  when  b.submitor is null  then  (select t.projecter  from gms_device_zy_project t where t.project_info_id='"+projectInfoNo+"')   else  b.submitor  end ) submitor ";
	    str+=" from gms_device_account_dui t";
	    str+=" left outer join gms_device_zy_by b  on t.dev_acc_id=b.dev_acc_id and b.isnewbymsg='0'";
	    str+=" where  t.dev_type like 'S062301%' and t.project_info_id='<%=projectInfoNo%>' ";
	    
       if(v_self_num!=undefined&&v_self_num!=""){
    	   str+=" and t.self_num like '%"+v_self_num+"%'";
	    }
       str+=" )tt  order by self_num asc ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);
		  $("select[name='rdo_entity_id']").each(function(i){
			var selectedValue=$(this).attr('id');
			$(this).val(selectedValue);
		  });
		
	}
	
	function show()
	{
		var project_info_id ='<%=projectInfoNo%>';
		
		var querySql = "select zy.by_nexttime,zy.by_nexthours,zy.byjb,dui.dev_name,dui.self_num from gms_device_zy_by zy  left join gms_device_account_dui dui on dui.dev_acc_id=zy.dev_acc_id  where dui.project_info_id ='"+project_info_id+"'  and  zy.isnewbymsg='0'  and (zy.by_nexttime < sysdate + 2  or   zy.by_nexthours <=( (select sum(t.work_hour)  from GMS_DEVICE_OPERATION_INFO t  ";
		querySql+=" where dev_acc_id =zy.dev_acc_id)+(select p.work_hour from gms_device_zy_project p where p.project_info_id='<%=projectInfoNo%>')*2))";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		retObj= queryRet.datas;
		if(retObj!=null&&retObj!="")
			{
			var obj = new Object();
			
			window.showModalDialog('<%=contextPath%>/rm/dm/kkzy/devbyjhtx.jsp',obj,'dialogWidth=1024px;dialogHigth=400px');
	 
		    
		    }
	}
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
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
	
	  var selectedTagIndex = 0;
    //点击记录查询明细信息
    function loadDataDetail(shuaId){       
        var retObj;
		if(shuaId!=null){		     
			 retObj = jcdpCallService("DevInsSrv", "getDevAccInfo", "deviceId="+shuaId);	
			 byjh(shuaId);
		}else{
			var ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		     retObj = jcdpCallService("DevInsSrv", "getDevAccInfo", "deviceId="+ids);
			 byjh(ids);
		}
		
		document.getElementById("dev_acc_name").value =retObj.deviceaccMap.dev_name;
		document.getElementById("dev_acc_sign").value =retObj.deviceaccMap.dev_sign;
		document.getElementById("dev_acc_model").value =retObj.deviceaccMap.dev_model;
		document.getElementById("dev_acc_self").value =retObj.deviceaccMap.self_num;
		document.getElementById("dev_acc_assetcoding").value =retObj.deviceaccMap.asset_coding;
		document.getElementById("dev_acc_using_stat").value =retObj.deviceaccMap.using_stat_desc;
						
   }
	

    /**
	 * 延迟加载*****************************************************************************************************************************
	 * @param {Object} index
	 */
	function loaddata(ids,index){		
		if (ids == "") {			
			ids = getSelIds('rdo_entity_id');
			if (ids == '') {
				return;
			}
		}
		
		if(index==1){
		
		}
		
	}
	//保养计划
	function byjh(id){	 
		var retObj;
		var querySql = "select zy.by_nexttime,zy.by_nexthours,zy.byjb,dui.dev_name,dui.self_num from gms_device_zy_by zy  left join gms_device_account_dui dui on dui.dev_acc_id=zy.dev_acc_id  where zy.isnewbymsg='0' and zy.dev_acc_id='"+id+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
		retObj= queryRet.datas;
		var size = $("#assign_body", "#tab_box_content1").children("tr").size();
		if (size > 0) {
			$("#assign_body", "#tab_box_content1").children("tr").remove();
		}
		var by_body1 = $("#assign_body", "#tab_box_content1")[0];
		if (retObj != undefined) {
			for (var i = 0; i < retObj.length; i++) {
				var columnsObj ;
				$("input[type='checkbox']", "#queryRetTable").each(function(){
					if(this.checked){
						columnsObj = this.parentNode.parentNode.cells;
					}
				});
			var newTr = by_body1.insertRow();
					
			var newTd = newTr.insertCell();
			newTd.innerText = i+1;
			var newTd1 = newTr.insertCell();
			newTd1.innerText = retObj[i].self_num;
			var newTd2 = newTr.insertCell();
			newTd2.innerText = retObj[i].dev_name;
			var newTd3 = newTr.insertCell();
			newTd3.innerText = retObj[i].by_nexthours;
			newTr.insertCell().innerText=retObj[i].byjb;
			newTr.insertCell().innerText=retObj[i].by_nexttime;
			}
		}
	
		$("#assign_body>tr:odd>td:odd",'#tab_box_content1').addClass("odd_odd");
		$("#assign_body>tr:odd>td:even",'#tab_box_content1').addClass("odd_even");
		$("#assign_body>tr:even>td:odd",'#tab_box_content1').addClass("even_odd");
		$("#assign_body>tr:even>td:even",'#tab_box_content1').addClass("even_even");
	}  
</script>
</html>