<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg responseDTO = (ISrvMsg)request.getAttribute("responseDTO");
	//需求报表是否保存成功
  	//String operationFlag = responseDTO.getValue("operationFlag");
  	//申请id
  	String applyId = responseDTO.getValue("applyId");
  	//申请年度
  	String applyYear = responseDTO.getValue("applyYear");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/dmsManager/plan/yearPlan/panel.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/css/calendar-blue.css" rel="stylesheet" type="text/css" /> 
	<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
	<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
	<title>市场及分布</title>
</head>

<body style="background:#cdddef"  scroll="no">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
				<td background="<%=contextPath%>/images/list_15.png">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>&nbsp;</td>
							<auth:ListButton functionId="" css="tj" event="onclick='toSubmit()'" title="保存"></auth:ListButton>
							<auth:ListButton functionId="" css="gb" event="onclick='toClose()'" title="关闭"></auth:ListButton>
				  		</tr>
					</table>
				</td>
			   	<td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			</tr>
		</table>
	</div>
	<div id="title_box_0" class="tongyong_box_title">
		<span id="list_div_0_span" style="display:block;text-align:center;">年物探市场预测及分布表</span>
	</div>
	<form name="form" id="form" method="post" action="<%=contextPath%>/dms/plan/yearPlan/saveOrUpdateMarketInfo.srq">
		<!--申请id -->
		<input name="apply_id" id="apply_id" type="hidden" value="<%=applyId%>"/>
		<!--申请年度 -->
		<input name="apply_year" id="apply_year" type="hidden" value="<%=applyYear%>"/>
		<div id="table_box_0" style="overflow-x:hidden;overflow-y:auto;">
			<table  style="table-layout:fixed" width="100%" border="0" cellspacing="0" cellpadding="0"
				class="tab_info" id=queryRetTable_0>
				<thead>
					<tr>
						<td width="5%"  class="bt_info_odd"  rowspan="2"></td>
						<td width="12%" class="bt_info_even" rowspan="2">地形</td>
						<td width="10%" class="bt_info_odd"  rowspan="2">实物工作量(KM)</td>
						<td width="10%" class="bt_info_even" rowspan="2">价值工作量(万元)</td>
						<td width="10%" class="bt_info_odd"  rowspan="2">项目预计开始时间</td>
						<td width="10%" class="bt_info_even" rowspan="2">项目预计结束时间</td>
						<td width="20%" class="bt_info_odd"  colspan="2">经营预测</td>
						<td width="10%" class="bt_info_even"  rowspan="2">设备需求</td>
					</tr>
					<tr>
						<td class="bt_info_odd" >收入</td>
						<td class="bt_info_even">利润</td>
					</tr>
				</thead>
				<tbody id="tbody_land_2D">
					<tr>
						<td class="ali_btn"><span class="zj"><a href="javascript:void(0);" onclick="insertMarTr('tbody_land_2D')"  title="添加"></a></span></td>
						<td>陆上勘探(二维)</td>
						<td class="total_sign_val" style="color:#F00;">0</td>
						<td class="total_value_val" style="color:#F00;">0</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
				<tbody id="tbody_sea_2D">
					<tr>
						<td class="ali_btn"><span class="zj"><a href="javascript:void(0);" onclick="insertMarTr('tbody_sea_2D')"  title="添加"></a></span></td>
						<td>海上勘探(二维)</td>
						<td class="total_sign_val" style="color:#F00;">0</td>
						<td class="total_value_val" style="color:#F00;">0</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
				<tbody id="tbody_land_3D">
					<tr>
						<td class="ali_btn"><span class="zj"><a href="javascript:void(0);" onclick="insertMarTr('tbody_land_3D')"  title="添加"></a></span></td>
						<td>陆上勘探(三维)</td>
						<td class="total_sign_val" style="color:#F00;">0</td>
						<td class="total_value_val" style="color:#F00;">0</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
				<tbody id="tbody_sea_3D">
					<tr>
						<td class="ali_btn"><span class="zj"><a href="javascript:void(0);" onclick="insertMarTr('tbody_sea_3D')"  title="添加"></a></span></td>
						<td>海上勘探(三维)</td>
						<td class="total_sign_val" style="color:#F00;">0</td>
						<td class="total_value_val" style="color:#F00;">0</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
	</form>
</body>
<script type="text/javascript">
	//设置表格高度
	function frameSize(){
		$("#table_box_0").css("height",$(window).height()-$("#inq_tool_box").height()-$("#title_box_0").height()-10);
	}
	//页面初始化信息
	$(function(){ 
		frameSize();
		$(window).resize(function(){
	  		frameSize();
		});
		//申请单id
		var applyId="<%=applyId%>";
		//加载表格标题和表头信息
		loadTableTitleAndHeaderInfo();
		//默认加载物探市场预测及分布表信息
		loadUpdateFormData(applyId);
	});
	
	//加载表格标题和表头信息
	function loadTableTitleAndHeaderInfo(){
		var curYear="<%=applyYear%>";
		$("#list_div_0_span").text(curYear+"年物探市场预测及分布表");
	}
	//加载修改表单数据
	function loadUpdateFormData(applyId){
		var tc0_0=0;//陆上勘探(二维) 收入
		var tc0_1=0;//陆上勘探(二维) 利润
		var tc1_0=0;//海上勘探(二维) 收入
		var tc1_1=0;//海上勘探(二维) 利润
		var tc2_0=0;//陆上勘探(三维) 收入
		var tc2_1=0;//陆上勘探(三维) 利润
		var tc3_0=0;//海上勘探(三维) 收入
		var tc3_1=0;//海上勘探(三维) 利润
		var retObj = jcdpCallService("YearPlanSrv", "getMarketData","applyId="+applyId);
		if(typeof retObj.datas!="undefined"){
			var data = retObj.datas;
			for(var i=0;i<data.length;i++){
				//物探市场预测及分布表
				var ts=insertMarTr(data[i].flag,"old",data[i].market_id);
				var tData=data[i];
				//遍历data[i]数据，给物探市场预测及分布表赋值
				$.each(tData, function(i, n){
					//移除数据标志位,给字段赋值
					if("flag"!=i){
						if(null!=n && ""!=n){
							$("#"+tData.flag+" #"+i+"_"+ts).val(n);
							//计算陆上勘探(二维) 累计收入
							if("tbody_land_2D"==tData.flag && "dev_sign_workload"==i){
								tc0_0=Math.round((parseFloat(tc0_0)+parseFloat(n))*100)/100;
							}
							//计算陆上勘探(二维) 累计利润
							if("tbody_land_2D"==tData.flag && "dev_value_workload"==i){
								tc0_1=Math.round((parseFloat(tc0_1)+parseFloat(n))*100)/100;
							}
							//计算海上勘探(二维) 累计收入
							if("tbody_sea_2D"==tData.flag && "dev_sign_workload"==i){
								tc1_0=Math.round((parseFloat(tc1_0)+parseFloat(n))*100)/100;
							}
							//计算海上勘探(二维) 累计利润
							if("tbody_sea_2D"==tData.flag && "dev_value_workload"==i){
								tc1_1=Math.round((parseFloat(tc1_1)+parseFloat(n))*100)/100;
							}
							//计算陆上勘探(三维) 累计收入
							if("tbody_land_3D"==tData.flag && "dev_sign_workload"==i){
								tc2_0=Math.round((parseFloat(tc2_0)+parseFloat(n))*100)/100;
							}
							//计算陆上勘探(三维) 累计利润
							if("tbody_land_3D"==tData.flag && "dev_value_workload"==i){
								tc2_1=Math.round((parseFloat(tc2_1)+parseFloat(n))*100)/100;
							}
							//计算海上勘探(三维) 累计收入
							if("tbody_sea_3D"==tData.flag && "dev_sign_workload"==i){
								tc3_0=Math.round((parseFloat(tc3_0)+parseFloat(n))*100)/100;
							}
							//计算海上勘探(三维) 累计利润
							if("tbody_sea_3D"==tData.flag && "dev_value_workload"==i){
								tc3_1=Math.round((parseFloat(tc3_1)+parseFloat(n))*100)/100;
							} 
						} 
					}
				});
			}
			$("#tbody_land_2D td[class='total_sign_val']").text(tc0_0);//陆上勘探(二维) 累计收入
			$("#tbody_land_2D td[class='total_value_val']").text(tc0_1);//陆上勘探(二维) 累计利润
			$("#tbody_sea_2D td[class='total_sign_val']").text(tc1_0);//海上勘探(二维) 累计收入
			$("#tbody_sea_2D td[class='total_value_val']").text(tc1_1);//海上勘探(二维) 累计利润
			$("#tbody_land_3D td[class='total_sign_val']").text(tc2_0);//陆上勘探(三维) 累计收入
			$("#tbody_land_3D td[class='total_value_val']").text(tc2_1);//陆上勘探(三维) 累计利润
			$("#tbody_sea_3D td[class='total_sign_val']").text(tc3_0);//海上勘探(三维) 累计收入
			$("#tbody_sea_3D td[class='total_value_val']").text(tc3_1);//海上勘探(三维) 累计利润
		} 
	}
	//计算总计
	function countTotal(item,isFlag,tbodyId,columnName){
		//校验2位实数
		if("0"==isFlag){
			var re =/^-?\d+\.?\d{0,2}$/;
			//检查所有的数量字段 
			if(!re.test(item.value)){
				alert("最多请输入两位小数!");
				item.value = "";
			}
		}
		//校验3位实数
		if("1"==isFlag){
			var re =/^-?\d+\.?\d{0,3}$/;
			//检查所有的数量字段 
			if(!re.test(item.value)){
				alert("最多请输入三位小数!");
				item.value = "";
			}
		}
		if(null!=tbodyId && ""!=tbodyId){
			//实物工作量总量
			if("dev_sign_workload"==columnName){
				var total_sign_val=0;
				var dev_sign_workload=$("#"+tbodyId+" input[name^='dev_sign_workload']");
				if(dev_sign_workload && dev_sign_workload.length>0){
					dev_sign_workload.each(function(i){        
						if(""!=$(this).val()){
							total_sign_val=Math.round((parseFloat(total_sign_val)+parseFloat($(this).val()))*1000)/1000;
						}
					});
					$("#"+tbodyId+" td[class='total_sign_val']").text(total_sign_val);
				}
			}
			//价值工作量总量
			if("dev_value_workload"==columnName){
				var total_value_val=0;
				var dev_value_workload=$("#"+tbodyId+" input[name^='dev_value_workload']");
				if(dev_value_workload && dev_value_workload.length>0){
					dev_value_workload.each(function(i){        
						if(""!=$(this).val()){
							total_value_val=Math.round((parseFloat(total_value_val)+parseFloat($(this).val()))*100)/100;
						}
					});
					$("#"+tbodyId+" td[class='total_value_val']").text(total_value_val);
				}
			}
		}
		
	}
	//添加物探市场预测及分布表行
	function insertMarTr(tbodyId,old,marketId){
		var projectType="";//项目类型
		var terrPhysFtype="";//地形父类
		var insteadId="";//替代主键（传给设备表，作为设备表MARKET_ID值）
		//陆上勘探(二维)
		if("tbody_land_2D"==tbodyId){
			projectType="2D";
			terrPhysFtype="0";
		}
		//海上勘探(二维)
		if("tbody_sea_2D"==tbodyId){
			projectType="2D";
			terrPhysFtype="1";
		}
		//陆上勘探(三维)
		if("tbody_land_3D"==tbodyId){
			projectType="3D";
			terrPhysFtype="0";
		}
		//海上勘探(三维)
		if("tbody_sea_3D"==tbodyId){
			projectType="3D";
			terrPhysFtype="1";
		}
		var timestamp=new Date().getTime();//获取时间戳
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr_"+timestamp+"' class='old' tempindex='"+timestamp+"'>";
			insteadId=marketId;//真实主键
		}else{
			temp +="<tr id='tr_"+timestamp+"' class='new' tempindex='"+timestamp+"'>";
			insteadId=timestamp;//时间戳
		}
		
		temp =temp + ("<td><input name='market_id_"+timestamp+"' id='market_id_"+timestamp+"' type='hidden' />"+
				"<input name='terr_phys_ftype_"+timestamp+"' id='terr_phys_ftype_"+timestamp+"' type='hidden' value='"+terrPhysFtype+"' />"+
				"<input name='project_type_"+timestamp+"' id='project_type_"+timestamp+"' type='hidden' value='"+projectType+"' />"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteMarTr(this,"+timestamp+",\""+tbodyId+"\")'/></td>" +
		"<td><input name='terr_phys_name_"+timestamp+"' id='terr_phys_name_"+timestamp+"' type='text' style='height:18px;width:95%;'/></td>"+
		"<td><input name='dev_sign_workload_"+timestamp+"' id='dev_sign_workload_"+timestamp+"'  type='text' style='height:18px;width:95%;' onkeyup='countTotal(this,\"1\",\""+tbodyId+"\",\"dev_sign_workload\")'/></td>"+
		"<td><input name='dev_value_workload_"+timestamp+"' id='dev_value_workload_"+timestamp+"' type='text' style='height:18px;width:95%;' onkeyup='countTotal(this,\"0\",\""+tbodyId+"\",\"dev_value_workload\")'/></td>"+
		"<td><input name='projet_start_time_"+timestamp+"' id='projet_start_time_"+timestamp+"' type='text' style='height:18px;width:80%;' readonly />"+
			"<img src='<%=contextPath%>/images/calendar.gif' id='date1_"+timestamp+"' width='18' height='18px' style='cursor: hand;' onmouseover='calDateSelector(\"projet_start_time_"+timestamp+"\",\"date1_"+timestamp+"\");'/>"+
		"</td>"+
		"<td><input name='projet_end_time_"+timestamp+"' id='projet_end_time_"+timestamp+"' type='text' style='height:18px;width:80%;' readonly/>"+
			"<img src='<%=contextPath%>/images/calendar.gif' id='date2_"+timestamp+"' width='18' height='18px' style='cursor: hand;' onmouseover='calDateSelector(\"projet_end_time_"+timestamp+"\",\"date2_"+timestamp+"\");'/>"+
		"</td>"+
		"<td><input name='dev_income_"+timestamp+"' id='dev_income_"+timestamp+"'  type='text' style='height:18px;width:95%;' onkeyup='countTotal(this,\"0\")' /> </td>"+
		"<td><input name='dev_profit_"+timestamp+"'  id='dev_profit_"+timestamp+"' type='text' style='height:18px;width:95%;' onkeyup='countTotal(this,\"0\")' /></td>"+
		"<td><div style='text-align:center;'><a style='color:#F00;' onclick='editDevInfo(\""+insteadId+"\")' href='#'>点击添加设备信息</a></div></td>"+
		"</tr>");
		$("#queryRetTable_0 #"+tbodyId).append(temp);
		return timestamp; 
	}
	//删除物探市场预测及分布表行
	function deleteMarTr(item,timestamp,tbodyId){
		//页面修改时要处理的操作
		if($(item).parent().parent().attr("class")=="old"){
			var marketId = $("#market_id_"+timestamp).val();
			var tts=new Date().getTime();
			$("#form").append("<input type='hidden' name='del_mar_"+tts+"' value='"+marketId+"'/>");
		}
		//实物工作量总量
		var total_sign_val=$("#"+tbodyId+" td[class='total_sign_val']").text();
		var dev_sign_workload_val=$("#"+tbodyId+" #dev_sign_workload_"+timestamp).val();
		if(""!=dev_sign_workload_val){
			if(null!=total_sign_val && ""!=total_sign_val){
				total_sign_val=Math.round((parseFloat(total_sign_val)-parseFloat(dev_sign_workload_val))*1000)/1000;
				$("#"+tbodyId+" td[class='total_sign_val']").text(total_sign_val);
			}
		}
		//价值工作量总量
		var total_value_val=$("#"+tbodyId+" td[class='total_value_val']").text();
		var dev_value_workload_val=$("#"+tbodyId+" #dev_value_workload_"+timestamp).val();
		if(""!=dev_value_workload_val){
			if(null!=total_value_val && ""!=total_value_val){
				total_value_val=Math.round((parseFloat(total_value_val)-parseFloat(dev_value_workload_val))*100)/100;
				$("#"+tbodyId+" td[class='total_value_val']").text(total_value_val);
			}
		}
		
		//删除行
		$(item).parent().parent().remove();
	}
	//关闭操作
	function toClose(){
		parent.location.href='<%=contextPath %>/dmsManager/plan/yearPlan/apply_list.jsp';	
	}
	//提交方法
	function toSubmit(){
		//提交表单
		var subForm = $("#form");
		subForm.submit();
	}
	//编辑设备信息
	function editDevInfo(insteadId){
		popWindow('<%=contextPath %>/dmsManager/plan/yearPlan/market_device.jsp?marketId='+insteadId);	
	}
</script>
</html>

