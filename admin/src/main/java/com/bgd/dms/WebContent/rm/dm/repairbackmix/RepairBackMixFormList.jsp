<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);

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

  <title>开据维修归还调拨单的界面</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">返还调配单号</td>
			    <td class="ali_cdn_input">
			    	<input id="s_repairmixinfo_no" name="s_repairmixinfo_no" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toNewPage()'" title="添加"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelRecord()'" title="删除"></auth:ListButton>
			    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="导出excel"></auth:ListButton>
			    <auth:ListButton functionId="" css="tj" event="onclick='toSumbitPage()'" title="提交"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_mixinfo_id}' name='device_mixinfo_id'>
			        <td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{device_mixinfo_id}' id='selectedbox_{device_mixinfo_id}'  onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{repair_info_no}">维修返还调配单号</td>
					<td class="bt_info_odd" exp="{out_org_name}">转出单位</td>
					<td class="bt_info_even" exp="{in_org_name}">接收单位</td>
					<td class="bt_info_odd" exp="{print_emp_name}">开据人</td>
					<td class="bt_info_even" exp="{submit_date}">开据日期</td>
					<td class="bt_info_odd" exp="{state_desc}">状态</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">审批明细</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">附件</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,5)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="devdetailMap" name="devdetailMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
				    <tr >
				     <td  class="inquire_item6">&nbsp;维修返还调配单号：</td>
				     <td  class="inquire_form6"  ><input id="repair_info_no" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     <td  class="inquire_item6">转出单位：</td>
				     <td  class="inquire_form6"><input id="in_org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;接收单位：</td>
				     <td  class="inquire_form6"><input id="out_org_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>  
				    </tr>
				    <tr>
				     <td  class="inquire_item6">开据人：</td>
				     <td  class="inquire_form6"><input id="print_emp_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">开据日期：</td>
				     <td  class="inquire_form6"><input id="submit_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td> 
				     <td  class="inquire_item6">&nbsp;状态：</td>
				     <td  class="inquire_form6"><input id="state_desc" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" class="tab_box_content" style="display:none">
					<table border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				            <td class="bt_info_even">序号</td>
							<td class="bt_info_odd">设备名称</td>
							<td class="bt_info_even">规格型号</td>
							<td class="bt_info_odd">自编号</td>
							<td class="bt_info_even">牌照号</td>
							<td class="bt_info_odd">实物标识号</td>
							<td class="bt_info_even">送修时间</td>
				        </tr>
				        <tbody id="detailList" name="detailList" ></tbody>
					</table>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">

				</div>
				<div id="tab_box_content4" name="tab_box_content2" class="tab_box_content" style="display:none">
					
				</div>
				<div id="tab_box_content5" name="tab_box_content2" class="tab_box_content" style="display:none">
					
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
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		if(index == 1){
			//动态查询明细
			var currentid ;
			$("input[type='checkbox'][name='selectedbox']").each(function(){
				if(this.checked){
					currentid = this.value;
				}
			});
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				var str = "select rid.device_det_id,rid.dev_acc_id,rid.actual_in_time,";
				str += "dui.dev_name,dui.dev_model,dui.self_num,dui.dev_sign,dui.license_num ";
				str += "from gms_device_repairinfo_detail rid ";
				str += "left join gms_device_account dui on dui.dev_acc_id = rid.dev_acc_id ";
				str += "where rid.device_mixinfo_id = '"+currentid+"' ";
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailList";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}
		$(filternotobj).hide();
		$(filterobj).show();
	}
	
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<datas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].dev_model+"</td>";
			innerHTML += "<td>"+datas[i].self_num+"</td><td>"+datas[i].license_num+"</td><td>"+datas[i].dev_sign+"</td><td>"+datas[i].actual_in_time+"</td>";
			innerHTML += "</tr>";
			
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function searchDevData(){
		var v_backmixinfo_no = document.getElementById("s_backmixinfo_no").value;
		var v_project_name = document.getElementById("s_project_name").value;
		refreshData(v_backmixinfo_no, v_project_name);
	}
	
	function refreshData(v_repairmixinfo_no,v_project_name){
		var str = "select rif.device_mixinfo_id,case rif.state when '0' then '未提交' when '9' then '已提交' else '异常状态' end as state_desc,";
			str += "rif.usage_org_id,inorg.org_abbreviation as in_org_name,rif.own_org_id,outorg.org_abbreviation as out_org_name,rif.repair_info_no,";
			str += "rif.print_emp_id,to_char(rif.modifi_date,'yyyy-mm-dd') as submit_date,mdmemp.employee_name as print_emp_name ";
			str += "from gms_device_repairinfo_form rif ";
			str += "left join comm_human_employee mdmemp on rif.print_emp_id = mdmemp.employee_id ";
			str += "left join comm_org_information inorg on inorg.org_id=rif.usage_org_id ";
			str += "left join comm_org_information outorg on outorg.org_id=rif.own_org_id ";
			str += "where rif.bsflag='0' and rif.repairtype='2' ";
		//TODO 补充名称的查询条件
		if(v_repairmixinfo_no!=undefined && v_repairmixinfo_no!=''){
			str += "and rif.device_backapp_no = '"+v_repairmixinfo_no+"' ";
		}
		str += "order by rif.modifi_date desc ";
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}

	function toNewPage(){
    	popWindow('<%=contextPath%>/rm/dm/repairbackmix/repairBackMixFormNewFill.jsp');
    }
    
    function toModifyPage(){
		var id ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				id = this.value;
			}
		});
    	popWindow('<%=contextPath%>/rm/dm/repairmix/repairMixFormModifyFill.jsp?devicemixinfoid='+id);
    }
    function toDelRecord(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		})
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		//判断状态如果是已提交，那么不能删除
		var str = "select rif.state from gms_device_repairinfo_form rif ";
		str += "where rif.bsflag = '0' and rif.device_mixinfo_id in ("+selectedid+")";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		var stateflag = false;
		for(var index = 0;index<unitRet.datas.length;index++){
			if(unitRet.datas[index].state == '9' ){
				stateflag = true;
			}
		}
		if(stateflag){
			alert("您选择的记录中存在'已提交'状态的数据，不能删除!");
			return;
		}
		//什么状态不能删除，和业务专家确定
		if(confirm("是否执行删除操作?")){
			var sql = "update gms_device_repairinfo_form set bsflag='1' where device_mixinfo_id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
	}
	function toSumbitPage(){
		var length = 0;
		var selectedid = "";
		var devicemixinfoid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				devicemixinfoid = this.value;
				length = length+1;
			}
		})
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		//判断状态如果是已提交，那么不用重复提交
		var str = "select rif.state from gms_device_repairinfo_form rif ";
		str += "where rif.bsflag = '0' and rif.device_mixinfo_id in ("+selectedid+")";
		var unitRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str);
		var stateflag = false;
		for(var index = 0;index<unitRet.datas.length;index++){
			if(unitRet.datas[index].state == '9' ){
				stateflag = true;
			}
		}
		if(stateflag){
			alert("您选择的记录中状态为'已提交'!");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/drepairmix/repairMixFormSubmit.jsp?devicemixinfoid='+devicemixinfoid);
	}
    
    function chooseOne(cb){   
        var obj = document.getElementsByName("selectedbox");   
        for (i=0; i<obj.length; i++){   
            if (obj[i]!=cb) obj[i].checked = false;   
            else obj[i].checked = true;   
        }   
    }
    function loadDataDetail(device_mixinfo_id){
    	var retObj;
		if(device_mixinfo_id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getRepairMixFormInfo", "device_mixinfo_id="+device_mixinfo_id);
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getRepairMixFormInfo", "device_mixinfo_id="+ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.deviceappMap.device_mixinfo_id).attr("checked",'true');
		//取消其他选中的
		$("input[type='checkbox'][name='selectedbox'][id!='selectedbox_"+retObj.deviceappMap.device_mixinfo_id+"']").removeAttr("checked");
		
		//给数据回填
		$("#repair_info_no","#devdetailMap").val(retObj.deviceappMap.repair_info_no);
		$("#in_org_name","#devdetailMap").val(retObj.deviceappMap.in_org_name);
		$("#out_org_name","#devdetailMap").val(retObj.deviceappMap.out_org_name);
		$("#print_emp_name","#devdetailMap").val(retObj.deviceappMap.print_emp_name);
		$("#submit_date","#devdetailMap").val(retObj.deviceappMap.submit_date);
		$("#state_desc","#devdetailMap").val(retObj.deviceappMap.state_desc);
		//重新加载当前标签页信息
		getContentTab(undefined,selectedTagIndex);
    }
</script>
</html>