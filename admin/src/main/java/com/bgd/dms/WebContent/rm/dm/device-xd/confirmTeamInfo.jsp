<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	UserToken user = OMSMVCUtil.getUserToken(request);
	String contextPath = request.getContextPath();
	String dev_acc_id = request.getParameter("dev_acc_id");
	String account_stat = request.getParameter("account_stat");
	String projectType = request.getParameter("projectType")==null?user.getProjectType():request.getParameter("projectType");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>确认启用时间</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action="">
<input type="hidden" id="detail_count" value="" />
<div id="new_table_box" style="height:380px;">
  <div id="new_table_box_content" style="height:380px;">
    <div id="new_table_box_bg" style="height:300px;">
     <fieldset style="margin-left:2px"><legend >基本信息</legend>
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
          <td class="inquire_item4">设备名称:</td>
          <td class="inquire_form4">
          	<input id="dev_name" name="dev_name" type="text" class="input_width" disabled/>
          	<input id="fk_dev_acc_id" name="fk_dev_acc_id" type="hidden" class="input_width" />
          </td>
          <td class="inquire_item4">规格型号:</td>
          <td class="inquire_form4">
          	<input id="dev_model" name="dev_model" type="text" class="input_width" disabled/>
          </td>
        </tr>
       <tr>
          <td class="inquire_item4">自编号:</td>
          <td class="inquire_form4">
          	<%if(account_stat.equals("0110000013000000005")){ %>
          		<input id="self_num" name="self_num" type="text" class="input_width" />
          	<%}else{ %>
          		<input id="self_num" name="self_num" type="text" class="input_width" disabled/>
          	<%} %>
          </td>
          <td class="inquire_item4">实物标识号:</td>
          <td class="inquire_form4">
          	<%if(account_stat.equals("0110000013000000005")){ %>
          		<input id="dev_sign" name="dev_sign" type="text" class="input_width" />
          	<%}else{ %>
          		<input id="dev_sign" name="dev_sign" type="text" class="input_width" disabled/>
          	<%} %>
          </td>
        </tr>
         <tr>
          <td class="inquire_item4">牌照号:</td>
          <td class="inquire_form4">
          	<%if(account_stat.equals("0110000013000000005")){ %>
          		<input id="license_num" name="license_num" type="text" class="input_width" />
          	<%}else{ %>
          		<input id="license_num" name="license_num" type="text" class="input_width" disabled/>
          	<%} %>          	
          </td>
          <td class="inquire_item4">原班组信息:</td>
          <td class="inquire_form4">
          	<input id="old_team_name" name="old_team_name" type="text" class="input_width" disabled/>
          </td>
        </tr>
      </table>
     </fieldset>
     <fieldset style="margin-left:2px"><legend >班组信息</legend>
      <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
         <tr>
          <td class="inquire_item4">班组名称:</td>
          <td class="inquire_form4">
          	<select name='team' id='team' /></select>
          </td>
          <td class="inquire_item4">
          	<span id="realstarttitle">进场时间</span>
          </td>
          <td class="inquire_form4">
          	<input name='realstartdate' id='realstartdate' style='line-height:15px' value='' size='15' type='text' readonly/>
          	<img src='<%=contextPath%>/images/calendar.gif' id='tributton4' width='16' height='16' style='cursor: hand;' onmouseover='calDateSelector(realstartdate,tributton4);'/>
          </td>
        </tr>
      </table>
     </fieldset>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	var dev_acc_id = '<%=dev_acc_id%>';
	var account_stat = '<%=account_stat%>';
	var projectType="<%=projectType%>";
	function refreshData(){
		var retObj;
		var basedatas;
		if('<%=dev_acc_id%>'!=null&&'<%=dev_acc_id%>'!='null'){
			var proSql = "select dui.*,sd.coding_name as old_team_name ";
			proSql += "from gms_device_account_dui dui left join comm_coding_sort_detail sd on dui.dev_team=sd.coding_code_id "; 
			proSql += "where dui.dev_acc_id='"+dev_acc_id+"'";
			var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql+'&pageSize=1000');
			retObj = proqueryRet.datas;
			if(retObj.length>=1){
				$("#dev_name").val(retObj[0].dev_name);
				$("#dev_model").val(retObj[0].dev_name);
				$("#self_num").val(retObj[0].self_num);
				$("#dev_sign").val(retObj[0].dev_sign);
				$("#license_num").val(retObj[0].license_num);
				$("#old_team_name").val(retObj[0].old_team_name);
				//account_stat = retObj[0].account_stat;
			}
			//判断如果account_stat不是外租，给外租的框隐藏
			if('0110000013000000005'!=account_stat){
				$("#realstarttitle").hide();
				$("#realstartdate").hide();
				$("#tributton4").hide();
			}
			
			//回填班组信息
			//查询公共代码，并且回填到界面的班组中
			var teamObj;
			var teamSql = "select t.coding_code_id as value,t.coding_name as label from comm_coding_sort_detail t ";
				teamSql += "where t.coding_sort_id='0110000001' and t.bsflag='0' and t.spare1='0' and length(t.coding_code) = 2 ";
				if(projectType != "5000100004000000009" && projectType != "5000100004000000006"){
					//除了深海项目和综合物化探项目类型班组都使用陆地项目班组
					teamSql += "and t.coding_mnemonic_id='5000100004000000001' ";
				}else{
					teamSql += "and t.coding_mnemonic_id='"+projectType+"' ";
				}
				teamSql += "order by t.coding_show_id ";
			var teamRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+teamSql+'&pageSize=1000');
			teamObj = teamRet.datas;
			var teamoptionhtml = "";
			for(var index=0;index<teamObj.length;index++){
				teamoptionhtml +=  "<option name='teamcode' id='teamcode"+index+"' value='"+teamObj[index].value+"'>"+teamObj[index].label+"</option>";
			}
			$("#team").append(teamoptionhtml);
		}
	}
	function submitInfo(){
		var teaminfo = $("#team option:selected").val();
		var actindate = $("#realstartdate").val();
		var fkdevaccid = $("#fk_dev_acc_id").val();
		var selfnum = $("#self_num").val();
		var devsign = $("#dev_sign").val();
		var licensenum = $("#license_num").val();
    	var ctt = parent.frames['list'].frames;
		newClose();
		ctt.confirmTeamInfo(dev_acc_id,teaminfo,account_stat,actindate,fkdevaccid,selfnum,devsign,licensenum);
	}
</script>
</html>

