<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>

<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	String userOrgId = user == null || user.getOrgId() == null ? "" : user.getOrgId().trim();
	String subOrgId = user.getSubOrgIDofAffordOrg();
	String wx_ids=request.getParameter("selectWzId");
	String projectInfoNo=user.getProjectInfoNo();
	//保存结果 1 保存成功
		ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
		String info = null;
		if(respMsg!=null&&respMsg.getValue("info") != null){
			info = respMsg.getValue("info");
		}
		
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet"
	type="text/css" />
<link rel="stylesheet" type="text/css" media="all"
	href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title></title>
</head>
<body class="bgColor_f3f3f3" onload="load()">
<form name="form1" id="form1" method="post"
	action="">
		<div id="inq_tool_box">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="6"><img src="<%=contextPath%>/images/list_13.png"
						width="6" height="36" /></td>
					<td background="<%=contextPath%>/images/list_15.png"><table
							width="100%" border="0" cellspacing="0" cellpadding="0">
							
							<tr>
								<td class="ali_cdn_name">物资名称</td>
								<td class="ali_cdn_input"><input id="s_wz_name"
									name="s_wz_name" type="text" /></td>
								<td class="ali_query"><span class="cx"><a href="#"
										onclick="searchDevData()" title="查询"></a></span> 
								<td class="ali_query"><span class="qc"><a href="#"
										onclick="clearQueryText()" title="清除"></a></span></td>
								<td>&nbsp;</td>
							</tr>
						</table></td>
					<td width="4"><img src="<%=contextPath%>/images/list_17.png"
						width="4" height="36" /></td>
				</tr>
			</table>
		</div>
	<input type='hidden' name='selectWzId' id='selectWzId'/>
	<div id="new_table_box" style="width: 100%">
		<div id="new_table_box_content" style="width: 100%">
			<div id="new_table_box_bg" style="width: 95%">
				<fieldset style="margin-left: 2px">
					<legend>消耗备件选择</legend>
					<div style="height: 100%; overflow: auto">
						<table width="97%" border="0" cellspacing="0" cellpadding="0"
							class="tab_line_height" >
							<tr>
						  <td class="bt_info_odd"  style="width:1%"></td>
					<td class="bt_info_odd" style="width:7.5%">物资编号</td>
					<td class="bt_info_odd" style="width:7.5%">序列号</td>
					<td class="bt_info_even" style="width:7.5%">物资名称</td>
					<td class="bt_info_even" style="width:7.5%">计量单位</td>
					<td class="bt_info_even" style="width:7.5%">实际价格</td>
					<td class="bt_info_even" style="width:7.5%">库存数量</td>
					<td class="bt_info_even" style="width:7.5%">消耗数量</td>
					<td class="bt_info_even" style="width:7.5%">备件用途</td>
							</tr>
							<tbody id="processtable0" name="processtable0">
							</tbody>
						</table>
					</div>
				</fieldset>


			</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
		</div>
	</div>

</body>
<script type="text/javascript">
	function frameSize() {
		//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
		setTabBoxHeight();
	}
	frameSize();

	$(function() {
		$(window).resize(function() {
			frameSize();
		});
	});
	$(document).ready(lashen);
</script>
<script type="text/javascript">
$().ready(function(){
	$("#hirechecked").change(function(){
		var checkvalue = this.checked;
		$("input[type='checkbox'][name^='idinfo']").attr('checked',checkvalue);
	});
});
//选择一条记录
function chooseOne(cb){   
      var obj = document.getElementsByName("hirechecked");  
      for (i=0; i<obj.length; i++){   
          if (obj[i]!=cb) obj[i].checked = false;   
          else 
           {obj[i].checked = true;  
            checkvalue = obj[i].value;
           } 
      }   
  } 

function submitInfo()
{
	
	//保留的行信息
	var count = 0;
	var line_infos;
	$("input[type='checkbox'][name='idinfo']").each(function(){
		if(this.checked){
			if(count == 0){
				line_infos = this.id;
			}else{
				line_infos += "~"+this.id;
			}
			count++;
		}
	});
	if(count == 0){
		alert('请选择维修备件！');
		return;
	}
	var selectedlines = line_infos.split("~");
	var wronglineinfos = "";
	for(var index=0;index<selectedlines.length;index++){
		var use_num = $("#use_num"+selectedlines[index]).val();
		var maintenance_level = $("#maintenance_level"+selectedlines[index]).val();
		if(use_num == "" || maintenance_level == "" ){
			if(index == 0){
				wronglineinfos += (parseInt(selectedlines[index])+1);
			}else{
				wronglineinfos += ","+(parseInt(selectedlines[index])+1);
			}
		}
	}
	if(wronglineinfos!=""){
		alert("请设置第"+wronglineinfos+"行明细的备件消耗明细及物资类别!");
		return;
	}
	
	$("input[type='checkbox'][name='idinfo']").each(function(){
		if(this.checked){
			
			var  use_num=document.getElementById("use_num"+this.id).value;
			var  coding_code_id=document.getElementById("coding_code_id"+this.id).value;
			var wz_id=document.getElementById("wz_id"+this.id).value;
			var usemat_id=document.getElementById("usemat_id"+this.id).value;
			  var submitStr = "use_num="+use_num+"&coding_code_id="+coding_code_id+"&wz_id="+wz_id+"&usemat_id="+usemat_id;
			  retObject = jcdpCallService("DevInsSrv","savewxbyMat",submitStr);
		}
	});
	 window.returnValue = "true";
	newClose();
	//document.getElementById("form1").action = "<%=contextPath%>/rm/dm/saveBywxMatInfo.srq?count="+count+"&line_infos="+line_infos;
	//document.getElementById("form1").submit();
	//  window.returnValue = 'true';
	  //window.close();
}

var checked = false;
	function check(){
	var chk = document.getElementsByName("rdo_entity_id");
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
	function load()
	{
		var projectInfoNo='<%=projectInfoNo%>';
		var sql="";
	 	sql +="select i.*, c.code_name, tt.stock_num,tt.actual_price,tt.wz_sequence from (select  t.wz_id,t.wz_sequence,sum(t.stock_num) stock_num,round(sum(t.stock_num * t.actual_price)/case when sum(t.stock_num)=0 then 1 else sum(t.stock_num) end,3) actual_price from gms_mat_recyclemat_info t where t.bsflag = '0' and t.wz_type = '3'   and t.project_info_id='"+projectInfoNo+"'    group by t.wz_id,wz_sequence) tt inner join (gms_mat_infomation i inner join gms_mat_coding_code c on i.coding_code_id=c.coding_code_id and i.bsflag='0' and c.bsflag='0') on tt.wz_id=i.wz_id order by i.coding_code_id asc ,i.wz_id asc";
		var baseData = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+sql+'&pageSize=10000');
				if(baseData.datas!=null)
				{
					//通过查询结果动态填充使用情况select;
					var querySql="select * from comm_coding_sort_detail where coding_sort_id='5110000188' and bsflag='0'";
					var queryRet = syncRequest('Post','/gms4'+appConfig.queryListAction,'pageSize=100000&querySql='+querySql);
					usingdatas = queryRet.datas;
					for (var tr_id = 0; tr_id< baseData.datas.length; tr_id++) {
						var innerhtml = "<tr id='tr"+tr_id+"' name='tr"+tr_id+"' seq='"+tr_id+"'>";
						innerhtml += "<input name='bj_id"+tr_id+"' id='bj_id"+tr_id+"' value='' size='16'  type='hidden' />";
						innerhtml += "<input name='stock_num"+tr_id+"' id='stock_num"+tr_id+"' value='' size='16'  type='hidden' />";
						innerhtml += "<input name='usemat_id"+tr_id+"' id='usemat_id"+tr_id+"' value='<%=wx_ids%>' size='16'  type='hidden' />";
						innerhtml += "<input name='wz_id"+tr_id+"' id='wz_id"+tr_id+"' value='"+baseData.datas[tr_id].wz_id+"' size='16'  type='hidden' />";
						innerhtml += "<input name='wxbymat_id"+tr_id+"' id='wxbymat_id"+tr_id+"' value='' size='16'  type='hidden' />";
						innerhtml += "<td><input type='checkbox' name='idinfo' id='"+tr_id+"' value='' onclick='chooseOne(this);'/></td>";
						innerhtml += "<td>"+baseData.datas[tr_id].wz_id+"</td>";
						innerhtml += "<td>"+baseData.datas[tr_id].wz_sequence+"</td>";
						innerhtml += "<td>"+baseData.datas[tr_id].wz_name+"</td>";
						innerhtml += "<td>"+baseData.datas[tr_id].wz_prickie+"</td>";
						innerhtml += "<td>"+baseData.datas[tr_id].actual_price+"</td>";
						innerhtml += "<td>-</td>";
						innerhtml += "<td><input name='use_num"+tr_id+"' id='use_num"+tr_id+"' value='' size='16' onkeyup='checkUse_num("+tr_id+")'/></td>";
						innerhtml += "<td><select name='coding_code_id"+tr_id+"' id='coding_code_id"+tr_id+"'></select></td>";
						$("#processtable0").append(innerhtml);
						if(usingdatas != null){
							var optionhtml = "";
							for (var i = 0; i< usingdatas.length; i++) {
								optionhtml +=  "<option  name='wxlb' id='wxlb"+i+"' value='"+usingdatas[i].coding_code_id+"'>"+usingdatas[i].coding_name+"</option>";
							}
							$("#coding_code_id"+tr_id).append(optionhtml);
						}
						}
					$("#processtable0>tr:odd>td:odd").addClass("odd_odd");
					$("#processtable0>tr:odd>td:even").addClass("odd_even");
					$("#processtable0>tr:even>td:odd").addClass("even_odd");
					$("#processtable0>tr:even>td:even").addClass("even_even");
					}
		
	}


function newClose(){
	  window.close();
}
function checkUse_num(tr_id)
{
var use_num=document.getElementById("use_num"+tr_id).value;
	//只能输入数字
	 var re =/^[0-9]{0}([0-9]|[.])+$/;  
	 if(use_num.length>0)
		 {
   if (!re.test(use_num))   
  	{   
       alert("请输入数字!");   
       document.getElementById("use_num"+tr_id).value="";
       document.getElementById("use_num"+tr_id).focus();   
      return false;   
  	 }
	//取消选中框--------------------------------------------------------------------------
	var obj = document.getElementsByName("idinfo");  
       for (i=0; i<obj.length; i++){   
           obj[i].checked = false;
       } 
   document.getElementById(tr_id).checked=true;
	 }
}

//选择一条记录
function chooseOne(cb){   
      var obj = document.getElementsByName("idinfo");  
      for (i=0; i<obj.length; i++){   
          if (obj[i]!=cb) obj[i].checked = false;   
          else 
           {obj[i].checked = true;  
            checkvalue = obj[i].value;
           } 
      }   
  }   


</script>
</html>