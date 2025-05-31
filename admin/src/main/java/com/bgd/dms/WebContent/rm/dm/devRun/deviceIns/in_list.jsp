<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();    
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;" />
<%@include file="/common/include/quotesresource.jsp"%>
<%@include file="/common/include/easyuiresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/devDialogOpen.js"></script>
  		<title>日常检查</title> 
 	</head> 
	<body style="background:#cdddef" onload="refreshData()">
     	<div id="list_table">
			<div id="inq_tool_box">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  			<tr>
		    			<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
	    				<td background="<%=contextPath%>/images/list_15.png">
	    					<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  					<tr>
								    <td class="ali_cdn_name">设备名称：</td>
								    <td class="ali_cdn_input" style="width:105px">
								    	<input id="s_dev_name" name="s_dev_name" type="text" />
								    </td>
								    <td class="ali_cdn_name">规格型号：</td>
								    <td class="ali_cdn_input" style="width:105px">
								    	<input id="s_dev_model" name="s_dev_model" type="text" />
								    </td>
								    <td class="ali_cdn_name">自编号：</td>
								    <td class="ali_cdn_input" style="width:105px">
								    	<input id="s_self_num" name="s_self_num" type="text" />
								    </td>
								    <td class="ali_cdn_name">牌照号：</td>
								    <td class="ali_cdn_input" style="width:105px">
								    	<input id="s_license_num" name="s_license_num" type="text" />
								    </td>
								    <td class="ali_cdn_name">实物标识号：</td>
								    <td class="ali_cdn_input" style="width:105px">
								    	<input id="s_dev_sign" name="s_dev_sign" type="text" />
								    </td>
						     			<td class="ali_query">
									    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
								    </td>
						     			 <td class="ali_query">
									    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
								    </td>
								    <td>&nbsp;</td>
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
	  			<table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
	     			<tr>
						<td class="bt_info_even" exp="<input type='checkbox' name='rdo_entity_id' value='{devinspectioin_id}_{type}_{data_source}' id='rdo_entity_id_{devinspectioin_id}'/>" >选择</td>			
						<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
						<td class="bt_info_even" exp="{dev_model}">规格型号</td>
						<td class="bt_info_odd" exp="{self_num}">自编号</td>
						<td class="bt_info_even" exp="{license_num}">牌照号</td>
						<td class="bt_info_odd" exp="{dev_sign}">实物标识号</td>
						<td class="bt_info_even" exp="{t_ins_people}">检查记录人</td>
						<td class="bt_info_odd" exp="{inspectioin_time}">检查记录时间</td>
						<td class="bt_info_even" exp="{inspectioin_update_time}">检查更新时间</td>
						<td class="bt_info_odd" exp="{create_time}">创建时间</td>
						<td class="bt_info_even" exp="{data_source_name}">数据来源</td>
						<td class="bt_info_odd" exp="<a onClick=openW('{devinspectioin_id}','{type}')>查看</a>" >详细</td>
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
					      	</label>
					    </td>
			    		<td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  		</tr>
				</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
		  		<ul id="tags" class="tags">
			    	<li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab(0)">设备信息</a></li>	
			   </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="devMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr>
						    <td class="inquire_item6">设备名称：</td>
						    <td class="inquire_form6">
						    	<input id="dev_name" name="dev_name"  class="input_width" type="text" readonly="readonly"/>
						    </td>
						    <td class="inquire_item6">规格型号：</td>
						    <td class="inquire_form6">
						    	<input id="dev_model" name="dev_model" class="input_width" type="text" readonly="readonly"/>
						    </td>
						    <td class="inquire_item6">自编号：</td>
						    <td class="inquire_form6">
						    	<input id="self_num" name="self_num" class="input_width" type="text" readonly="readonly"/>
						    </td>
						</tr>
						<tr>
						    <td class="inquire_item6">牌照号：</td>
						    <td class="inquire_form6">
						    	<input id="license_num" name="license_num"  class="input_width" type="text" readonly="readonly"/>
						    </td>
						    <td class="inquire_item6">实物标识号：</td>
						    <td class="inquire_form6">
						    	<input id="dev_sign" name="dev_sign" class="input_width" type="text" readonly="readonly"/>
						    </td>
						    <td class="inquire_item6">燃油加油量：</td>
							<td class="inquire_form6">
								<input type="text" name="oil_num" id="oil_num" class="input_width" readonly="readonly"/>
							</td>
						</tr>
						<tr>
						   <td class="inquire_item6">钻井进尺：</td>
							<td class="inquire_form6">
								<input type="text" name="drilling_num" id="drilling_num" class="input_width" readonly="readonly"/>
							</td>
							<td class="inquire_item6">工作小时：</td>
							<td class="inquire_form6">
								<input type="text" name="work_hour" id="work_hour" class="input_width" readonly="readonly"/>
							</td>
							<td class="inquire_item6">当日里程：</td>
							<td class="inquire_form6">
								<input type="text" name="mileage_today" id="mileage_today" class="input_width" readonly="readonly"/>
							</td>
						</tr>
						<tr>
						<td class="inquire_item6">里程表读数：</td>
							<td class="inquire_form6">
								<input type="text" name="mileage_write" id="mileage_write" class="input_width" readonly="readonly"/>
							</td>
						   <td class="inquire_item6">整改人：</td>
							<td class="inquire_form6">
								<input type="text" name="modification_people" id="modification_people" class="input_width" readonly="readonly"/>
							</td>
							<td class="inquire_item6">整改时间：</td>
							<td class="inquire_form6">
								<input type="text" name="modification_time" id="modification_time" class="input_width" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<td class="inquire_item6">整改内容：</td>
							<td class="inquire_form6" colspan="5">
								<textarea id="modification_content" name="modification_content" class="textarea" readonly="readonly"></textarea>
						    </td>
						</tr>
						<tr>
							<td class="inquire_item6">整改结果：</td>
							<td class="inquire_form6" colspan="5">
								<textarea id="modification_result" name="modification_result" class="textarea" readonly="readonly"></textarea>
						    </td>
						</tr>
			        </table>
				</div>
			</div>
		</div>
	</body>
	<script type="text/javascript">
		function frameSize(){
			setTabBoxHeight();
		}
		frameSize();
		$(function(){
			$(window).resize(function(){
		  		frameSize();
			});
		});	
		$(document).ready(lashen);
		
		cruConfig.contextPath =  "<%=contextPath%>";
		cruConfig.cdtType = 'form';
		
		// 复杂查询
		function refreshData(dev_name,dev_model,self_num,license_num,dev_sign){
			var str = "select ins.*,case when ins.data_source='1' then '平台录入' else '手持机' end as data_source_name";
			str += " ,acc.dev_name,acc.dev_model,acc.self_num,acc.license_num,acc.dev_sign,u.user_name as t_ins_people ";
			str += " from gms_device_inspectioin ins ";
			str += " left join gms_device_account acc ";
			str += " on ins.dev_acc_id=acc.dev_acc_id and acc.bsflag='0' ";
			str += " left join p_auth_user u on ins.inspectioin_people=u.user_id and u.bsflag='0' ";
			str += " where ins.bsflag='0' and ins.project_info_no is null and acc.owning_sub_id like '<%=orgSubId%>%' ";
			if(dev_name!=undefined && dev_name!=""){
				str += " and acc.dev_name like '%"+dev_name+"%' ";
			}
			if(dev_model!=undefined && dev_model!=""){
				str += " and acc.dev_model like '%"+dev_model+"%' ";
			}
			if(self_num!=undefined && self_num!=""){
				str += " and acc.self_num like '%"+self_num+"%' ";
			}
			if(license_num!=undefined && license_num!=""){
				str += " and acc.license_num like '%"+license_num+"%' ";
			}
			if(dev_sign!=undefined && dev_sign!=""){
				str += " and acc.dev_sign like '%"+dev_sign+"%' ";
			}
			str += " order by acc.dev_type,acc.self_num,acc.license_num,acc.dev_sign,ins.inspectioin_time desc";
			cruConfig.queryStr = str;
			queryData(cruConfig.currentPage);;
		}
		//简单查询
		function simpleSearch(){
		 	var s_dev_name = $("#s_dev_name").val(); 
		 	var s_dev_model = $("#s_dev_model").val(); 
		 	var s_self_num = $("#s_self_num").val(); 
		 	var s_license_num = $("#s_license_num").val(); 
		 	var s_dev_sign = $("#s_dev_sign").val(); 
			refreshData(s_dev_name,s_dev_model,s_self_num,s_license_num,s_dev_sign);
		}
		//清空查询条件
		function clearQueryText(){
			document.getElementById("s_dev_name").value = "";
			document.getElementById("s_dev_model").value = "";
			document.getElementById("s_self_num").value = "";
			document.getElementById("s_license_num").value = "";
			document.getElementById("s_dev_sign").value = "";
			refreshData("","","","","");
		}
		
		//点击tab页
		var selectedTagIndex = 0;
		var showTabBox = document.getElementById("tab_box_content0");
		var selected_id = "";//加载数据时，选中记录id
		var tab_index =0;//tab页索引
		//点击tab,显示具体tab
		function getTab(index){
			tab_index=index;
			getTab3(index);
			$(".tab_box_content").hide();
			$("#tab_box_content"+index).show();
			loadDataDetail(selected_id);
		}
		//加载单条记录的详细信息
		function loadDataDetail(ids){
			//取消选中框--------------------------------------------------------------------------
	    	var obj = document.getElementsByName("rdo_entity_id");  
		        for (i=0; i<obj.length; i++){   
		            obj[i].checked = false;
		        } 
			//选中这一条checkbox
			$("#rdo_entity_id_"+ids.split('_')[0]).attr("checked","checked");
			//------------------------------------------------------------------------------------
			selected_id=ids;
			if(0==tab_index){
				var uQuerySql = "select t.*,m.inspectioin_item_code,acc.dev_name,acc.dev_model,acc.self_num,acc.dev_sign,acc.license_num from gms_device_inspectioin t "+
				" left join gms_device_inspectioin_item m on t.devinspectioin_id = m.devinspectioin_id and m.bsflag = '0' "+
				" left join gms_device_account acc on t.dev_acc_id = acc.dev_acc_id and acc.bsflag = '0' "+
				" where t.bsflag = '0' and t.devinspectioin_id = '"+ids.split('_')[0]+"'";				 	 
				var uQueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100000&querySql='+encodeURI(encodeURI(uQuerySql)));
				var uDatas = uQueryRet.datas;
				if(uDatas != null&&uDatas!=""){
					document.getElementById("dev_name").value = uDatas[0].dev_name;
					document.getElementById("dev_model").value = uDatas[0].dev_model;
					document.getElementById("self_num").value = uDatas[0].self_num;
					document.getElementById("dev_sign").value = uDatas[0].dev_sign;
					document.getElementById("license_num").value = uDatas[0].license_num;
					document.getElementById("drilling_num").value = uDatas[0].drilling_num;
					document.getElementById("work_hour").value = uDatas[0].work_hour;	
					document.getElementById("mileage_today").value = uDatas[0].mileage_today;
					document.getElementById("mileage_write").value = uDatas[0].mileage_write;
					document.getElementById("oil_num").value = uDatas[0].oil_num;
					document.getElementById("modification_result").value = uDatas[0].modification_result;
					document.getElementById("modification_people").value = uDatas[0].modification_people;
					document.getElementById("modification_time").value = uDatas[0].modification_time;
					document.getElementById("modification_content").value = uDatas[0].modification_content;
				}
			}
		}
	
		//新增
		function toAdd(){
			popWindow('<%=contextPath%>/rm/dm/devRun/deviceIns/rcjc_add.jsp?flag=add','1000:620',"-添加日常检查"); 
		}

		//修改
		function toEdit(){ 
		    ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
		    	alert("请选择记录!");
		     	return;
		    }
		    /* var udata_source=ids.split('_')[2];
		    if(1!=udata_source){
		    	alert("数据来源为手持机,不能进行修改!");
		     	return;
		    } */
		    
		    
			popWindow('<%=contextPath%>/rm/dm/devRun/deviceIns/rcjc_edit.jsp?devinspectioin_id='+ids.split('_')[0]+'&flag=update&type='+ids.split('_')[1],'1000:620',"-修改日常检查"); 
		}
		
		//删除
		function toDelete(){
		    ids = getSelIds('rdo_entity_id');
		    if(ids==''){ 
		    	alert("请选择记录!");
		     	return;
		    }
		    /* var udata_source=ids.split('_')[2];
		    if(1!=udata_source){
		    	alert("数据来源为手持机,不能进行删除!");
		     	return;
		    } */
			if(confirm('确定要删除吗?')){  
				var retObj = jcdpCallService("DevCommInfoSrv", "deleteRcjcInfo", "devinspectioin_id="+ids.split('_')[0]);
				queryData(cruConfig.currentPage);
			}
		}
		//查看
		function openW(ids,type){ 
			if(type=="3"){//运输车辆
				popWindow('<%=contextPath%>/rm/dm/device-xd/searchRcjcYscl.jsp?ids='+ids,'1000:620');
			}else if(type=="1"){//可控震源
			 	popWindow('<%=contextPath%>/rm/dm/device-xd/searchRcjcKkzy.jsp?ids='+ids,'1000:620');
			}else if(type=="2"){//轻便钻机
			 	popWindow('<%=contextPath%>/rm/dm/device-xd/searchRcjcQbzj.jsp?ids='+ids,'1000:620');
			}else if(type=="4"){//车装钻机
			 	popWindow('<%=contextPath%>/rm/dm/device-xd/searchRcjcCzzj.jsp?ids='+ids,'1000:620');
			}
		}
</script>

</html>