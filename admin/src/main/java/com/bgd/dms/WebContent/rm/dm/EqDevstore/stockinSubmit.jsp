<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/css/jquery.autocomplete.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery.autocomplete.min.js"></script>

<title>装备设备入库明细</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<input type="hidden" id="device_backdet_id" name="device_backdet_id"></input>
<input type="hidden" id="devBackAppId" name="devBackAppId"></input>
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">     		
		<fieldset style="margin-left:2px"><legend>验收信息</legend>
			 <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
			   <tr>
			  	<td class="inquire_item6">存放地(省份+库房)</td>
				<td class="inquire_form6" colspan="3">
				<input class="input_width"  id="province"  name="province" style="width: 30%; float: none;margin-bottom: 7px;height:20px;line-height:20px;"/>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<input id="dev_position" name="dev_position" class="input_width" type="text" style="width: 60%; float: none;margin-bottom: 7px;"/>
				</td>
			  </tr>
			  <tr>
				<td class="inquire_item6">技术状况</td>
				<td class="inquire_form6">
				<select type="text" name="tech_stat" id="tech_stat" value="" readonly="readonly" class="select_width">
					<option value="0110000006000000001">完好</option>
					<option value="0110000006000000006">待修</option>
 			   <!-- <option value="0110000006000000007">在修</option> -->
					<option value="0110000006000000005">待报废</option>
			   <!-- <option value="0110000006000000013">验收</option> -->
				</select>
				</td>
				<td class="inquire_item6">验收时间</td>
				<td class="inquire_form6">
					<input type="text" name="actual_out_date" id="actual_out_date" value="" readonly="readonly" class="input_width"/>
					<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
					onmouseover="calDateSelector(actual_out_date,tributton1);" />
				</td>
			  </tr>
      		 </table>
      	</fieldset>     	
      	<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_appdet_id_{device_backapp_id}' name='device_backapp_id'>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{dev_name}">设备名称</td>
					<td class="bt_info_even" exp="{dev_model}">规格型号</td>
					<td class="bt_info_odd" exp="{self_num}">自编号</td>
					<td class="bt_info_even" exp="{dev_sign}">实物标识号</td>
					<td class="bt_info_odd" exp="{license_num}">牌照号</td>
					<td class="bt_info_even" exp="{stat_desc}">资产状况</td>
					<td class="bt_info_odd" exp="{planning_out_time}">计划离场时间</td>
					<td class="bt_info_even" exp="{actual_in_time}">实际离场时间</td>
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
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a id="submitButton" href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript"> 
$(function() {
    $('#province').autocomplete(emails, {
        max: 120000,    //列表里的条目数
        minChars: 0,    //自动完成激活之前填入的最小字符
        width: 170,     //提示的宽度，溢出隐藏
        scrollHeight: 300,   //提示的高度，溢出显示滚动条
        matchContains: true,    //包含匹配，就是data参数里的数据，是否只要包含文本框里的数据就显示
        autoFill: false,    //自动填充
        formatItem: function(row, i, max) {
            return row.name;
        },
        formatMatch: function(row, i, max) {
            return row.name;
        },
        formatResult: function(row) {
            return row.name;
        }
    }).result(function(event, row, formatted) {
    });
});
var emails = [
              { name: "塔中资产库" },
              { name: "库车资产库"},
              { name: "阿克苏资产库" },
              { name: "库尔勒资产库"},
              { name: "乌鲁木齐设备资产库"},
              { name: "哈密资产库" },
              { name: "鄯善资产库"},
              { name: "二连浩特资产库（吐哈）" },
              { name: "敦煌资产库"},
              { name: "花土沟资产库"},
              { name: "任丘资产库"},
              { name: "电子中心库房(华北)"},
              { name: "锡林浩特办事处"},
              { name: "大港油田大港物探处设备库"},
              { name: "银川石油城资产库"},
              { name: "辽河车场"},
              { name: "新疆21队车场"},
              { name: "霸州资产库"},
              { name: "塔里木作业部库房"},
              { name: "北疆作业部库房"},
              { name: "吐哈作业部库房"},
              { name: "敦煌作业部库房"},
              { name: "长庆作业部库房"},
              { name: "辽河作业部库房"},
              { name: "华北作业部库房"},
              { name: "新区作业部库房"},
              { name: "测量服务中心大港作业分部库房"},
              { name: "安徽省"},
              { name: "澳门特别行政区"},
              { name: "北京市"},
              { name: "重庆市"},
              { name: "福建省"},
              { name: "甘肃省"},
              { name: "广东省"},
              { name: "广西壮族自治区"},
              { name: "贵州省"},
              { name: "海南省"},
              { name: "河北省"},
              { name: "黑龙江省"},
              { name: "河南省"},
              { name: "湖北省"},
              { name: "湖南省"},
              { name: "江苏省"},
              { name: "江西省"},
              { name: "吉林省"},
              { name: "辽宁省"},
              { name: "内蒙古"},
              { name: "宁夏回族自治区"},
              { name: "青海省"},
              { name: "陕西省"},
              { name: "山东省"},
              { name: "上海市"},
              { name: "山西省"},
              { name: "四川省"},
              { name: "台湾"},
              { name: "天津市"},
              { name: "香港特别行政区"},
              { name: "新疆维吾尔族自治区"},
              { name: "西藏自治区"},
              { name: "云南省"},
              { name: "浙江省"}
          ];

	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';

	$().ready(function(){
		$("#addProcess").click(function(){
			tr_id = $("#processtable>tbody>tr:last").attr("id");
			if(tr_id != undefined){
				tr_id = parseInt(tr_id.substr(2,1),10);
			}
			if(tr_id == undefined){
				tr_id = 0;
			}else{
				tr_id = tr_id+1;
			}
			//统计本次的总行数
			$("#detail_count").val(tr_id);
			//动态新增表格
			var innerhtml = "<tr id = 'tr"+tr_id+"' ><td><input type='checkbox' name='idinfo' id='"+tr_id+"'/><input name='devicename"+tr_id+"' value='通过设备编码树选择设备名称' size='12' type='text'/></td><td><input name='devicetype"+tr_id+"' class='input_width' value='设备名称带出类型' size='12' type='text'/></td><td><input name='signtype"+tr_id+"' class='input_width' value='名称和类型带出类别' size='12' type='text'/></td><td><input name='unit"+tr_id+"' class='input_width' type='text'/></td><td><input name='neednum"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='team"+tr_id+"' class='input_width' type='text'/></td><td><input name='purpose"+tr_id+"' class='input_width' value='' size='8' type='text'/></td><td><input name='startdate"+tr_id+"' class='input_width' type='text'/></td><td><input name='enddate"+tr_id+"' class='input_width' type='text'/></td></tr>";
			
			$("#processtable").append(innerhtml);
			if(tr_id%2 == 0){
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("odd_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("odd_even");
			}else{
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:odd").addClass("even_odd");
				$("#processtable>tbody>tr[id='tr"+tr_id+"']>td:even").addClass("even_even");
			}
		});
		$("#delProcess").click(function(){
			$("input[name='idinfo']").each(function(){
				if(this.checked){
					var selected_id = this.id;
					$('#tr'+selected_id).remove();
				}
			});
		});
	});

	function loadDataDetail(){
		
		var device_backdet_id = '<%=request.getParameter("id")%>';
		var device_backapp_id = '<%=request.getParameter("devBakAppId")%>';
		document.getElementById("device_backdet_id").value = device_backdet_id;
		document.getElementById("devBackAppId").value = device_backapp_id;
		var temp = device_backdet_id.split(",");
		var idss = "";		
		var retObj;
		if(device_backdet_id!=null){
		    var querySql="select backdet.*,dui.dev_name,dui.fk_dev_acc_id,dui.dev_model,dui.project_info_id,";
		    	querySql+="sd.coding_name as stat_desc ";
		    	querySql+="from gms_device_backapp_detail backdet ";
		    	querySql+="left join gms_device_account_dui dui on backdet.dev_acc_id=dui.dev_acc_id ";
		    	querySql+="left join comm_coding_sort_detail sd on dui.asset_stat = sd.coding_code_id ";
				querySql+="where backdet.bsflag='0' ";				
				querySql+="and backdet.device_backdet_id in (";
				for(var i=0;i<temp.length;i++){
					if(idss!="") idss += ",";
					idss += "'"+temp[i]+"'";
				}
				querySql = querySql+idss+")";				
				cruConfig.queryStr = querySql;
				queryData(cruConfig.currentPage);;					
		}		
	}
	
	function submitInfo(){
		if(document.getElementById("actual_out_date").value==""){
			alert("验收时间不能为空！");
			return;
		}
		if(confirm("确认提交吗？")){			
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/pro/saveEqDevRStock.srq";
			document.getElementById("form1").submit();
			document.getElementById("submitButton").onclick = "";
		}		
	}	
</script>
</html>

