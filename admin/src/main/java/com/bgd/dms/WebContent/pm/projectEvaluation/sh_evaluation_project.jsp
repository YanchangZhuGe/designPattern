<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String project_info_no = user.getProjectInfoNo();
	String project_name = user.getProjectName();
	String userId = user.getUserId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
</head>
<body style="background:#fff" onload="loadData()">
<div id="list_table">
	<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			    <td width="6"><img src="<%=contextPath %>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
			    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						    <td class="" align="center"><font size="4"><%=project_name %>(总分:<strong><span id="total_score"></span></strong>)</font></td>
						    <td>&nbsp;</td>
						    <auth:ListButton functionId="F_DOC_008" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
						    <auth:ListButton functionId="F_PM_EVALUATION_EDIT" css="tj" event="onclick='toSubmit()'" title="JCDP_btn_submit"></auth:ListButton>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div id="table_box">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
	    <tr>
	      <td class="bt_info_odd" exp="{spare1}">项目</td> 
	      <td class="bt_info_even" exp="{name}">指标名称</td>
	      <td class="bt_info_odd" exp="{spare1}">明细指标</td>
	      <td class="bt_info_even" exp="{name}">单位</td>
	      <td class="bt_info_odd" exp="{spare1}">目标值</td>
	      <td class="bt_info_even" exp="{name}">实际值</td>
	      <td class="bt_info_odd" exp="{spare1}">分值</td>
	      <td class="bt_info_even" exp="{name}">考核标准</td>
	      <td class=bt_info_odd exp="{spare1}">考核部门</td>
	      <td class="bt_info_even" exp="{name}">实际得分</td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;" rowspan="11">考核指标</td>
	    	<td style="border: black 1px solid;" rowspan="5">动遣指标</td>
	    	<td style="border: black 1px solid;">航行</td>
	    	<td style="border: black 1px solid;">天</td>
	    	<td style="border: black 1px solid;"><input name="hx_target_value" id="hx_target_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    	<td style="border: black 1px solid;"><input name="hx_actual_value" id="hx_actual_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    	<td style="border: black 1px solid;" rowspan="5">30</td>
	    	<td style="border: black 1px solid;" rowspan="5">动遣总时间不超不扣分；<br/>超出1天扣5分，扣完为止。</td>
	    	<td style="border: black 1px solid;" rowspan="7">项目运作部</td>
	    	<td style="border: black 1px solid;" rowspan="5"><input name="dq_score" id="dq_score" type="text" value="" style="text-align: center; width:50px" onchange="countSum()"/></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">靠港（包括补给、清关、审计等）</td>
	    	<td style="border: black 1px solid;">天</td>
	    	<td style="border: black 1px solid;"><input name="chkg_target_value" id="chkg_target_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    	<td style="border: black 1px solid;"><input name="chkg_actual_value" id="chkg_actual_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">放缆（包括航行到工区、试验等）</td>
	    	<td style="border: black 1px solid;">天</td>
	    	<td style="border: black 1px solid;"><input name="fl_target_value" id="fl_target_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    	<td style="border: black 1px solid;"><input name="fl_actual_value" id="fl_actual_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">收缆（包括航行到遣散港口）</td>
	    	<td style="border: black 1px solid;">天</td>
	    	<td style="border: black 1px solid;"><input name="sl_target_value" id="sl_target_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    	<td style="border: black 1px solid;"><input name="sl_actual_value" id="sl_actual_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">靠港（补给、清关等）</td>
	    	<td style="border: black 1px solid;">天</td>
	    	<td style="border: black 1px solid;"><input name="rwwckg_target_value" id="rwwckg_target_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    	<td style="border: black 1px solid;"><input name="rwwckg_actual_value" id="rwwckg_actual_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;" rowspan="2">效率指标</td>
	    	<td style="border: black 1px solid;">采集天数(不含Standby)</td>
	    	<td style="border: black 1px solid;">天</td>
	    	<td style="border: black 1px solid;"><input name="cjts_target_value" id="cjts_target_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    	<td style="border: black 1px solid;"><input name="cjts_actual_value" id="cjts_actual_value" type="text" value="" style="text-align: center; width:50px" onchange="checkInt(this)"/></td>
	    	<td style="border: black 1px solid;">50</td>
	    	<td style="border: black 1px solid;">不超时间不扣分，超过1天扣10分，扣完为止。</td>
	    	<td style="border: black 1px solid;"><input name="cjts_score" id="cjts_score" type="text" value="" style="text-align: center; width:50px" onchange="countSum()"/></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">Downtime率<br/>（计算基数为首末炮之间的所有时间）</td>
	    	<td style="border: black 1px solid;">%</td>
	    	<td style="border: black 1px solid;"><input name="downtime_target_value" id="downtime_target_value" type="text" value="" style="text-align: center; width:50px"/></td>
	    	<td style="border: black 1px solid;"><input name="downtime_actual_value" id="downtime_actual_value" type="text" value="" style="text-align: center; width:50px"/></td>
	    	<td style="border: black 1px solid;">20</td>
	    	<td style="border: black 1px solid;">Downtime率<=考核目标值，不扣分；<br/>高1%扣5分，扣完为止。</td>
	    	<td style="border: black 1px solid;"><input name="downtime_score" id="downtime_score" type="text" value="" style="text-align: center; width:50px" onchange="countSum()"/></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;" rowspan="3">一票否决指标</td>
	    	<td style="border: black 1px solid;">安全：LTI事件；严重环境污染事件</td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;">无</td>
	    	<td style="border: black 1px solid;">
	    	<select id="safe">
		    	<option value="0">无</option>
		    	<option value="1">有</option>
	    	</select>
	    	</td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;">发生LTI事件或严重环境污染事件，一票否决</td>
	    	<td style="border: black 1px solid;">HSSE部</td>
	    	<td style="border: black 1px solid;"></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">质量：质量事故</td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;">无</td>
	    	<td style="border: black 1px solid;">
	    	<select id="quality">
		    	<option value="0">无</option>
		    	<option value="1">有</option>
	    	</select>
	    	</td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;">发生较大及以上质量事故，一票否决。
	    	<br/>质量事故的划分参考东方公司勘〔2010〕<br/>43号《东方地球物理公司质量事故管理规定 》</td>
	    	<td style="border: black 1px solid;">技术质量部</td>
	    	<td style="border: black 1px solid;"></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">行为：瞒报虚报行为</td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;">无</td>
	    	<td style="border: black 1px solid;">
	    	<select id="behavior">
		    	<option value="0">无</option>
		    	<option value="1">有</option>
	    	</select>
	    	</td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;">发现Downtime等数据瞒报虚报行为，一票否决</td>
	    	<td style="border: black 1px solid;">项目运作部</td>
	    	<td style="border: black 1px solid;"></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">合计</td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;">100</td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"><input name="sum" id="sum" type="text" value="" style="text-align: center; width:50px" readonly="readonly"/></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;" rowspan="4">非考核指标</td>
	    	<td style="border: black 1px solid;" rowspan="4">观察指标</td>
	    	<td style="border: black 1px solid;">Standby率</td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"><input name="standby_target_value" id="standby_target_value" type="text" value="" style="text-align: center; width:50px" onchange="checkNum(this)"/></td>
	    	<td style="border: black 1px solid;"><input name="standby_actual_value" id="standby_actual_value" type="text" value="" style="text-align: center; width:50px" onchange="checkNum(this)"/></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">平均作业船速</td>
	    	<td style="border: black 1px solid;">节/小时</td>
	    	<td style="border: black 1px solid;"><input name="pjzycs_target_value" id="pjzycs_target_value" type="text" value="" style="text-align: center; width:50px" onchange="checkNum(this)"/></td>
	    	<td style="border: black 1px solid;"><input name="pjzycs_actual_value" id="pjzycs_actual_value" type="text" value="" style="text-align: center; width:50px" onchange="checkNum(this)"/></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">平均换线时间</td>
	    	<td style="border: black 1px solid;">小时</td>
	    	<td style="border: black 1px solid;"><input name="pjhxsj_target_value" id="pjhxsj_target_value" type="text" value="" style="text-align: center; width:50px" onchange="checkNum(this)"/></td>
	    	<td style="border: black 1px solid;"><input name="pjhxsj_actual_value" id="pjhxsj_actual_value" type="text" value="" style="text-align: center; width:50px" onchange="checkNum(this)"/></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    </tr>
	    <tr align="center" style="background: #e3e3e3">
	    	<td style="border: black 1px solid;">Infill率</td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"><input name="infill_target_value" id="infill_target_value" type="text" value="" style="text-align: center; width:50px" onchange="checkNum(this)"/></td>
	    	<td style="border: black 1px solid;"><input name="infill_actual_value" id="infill_actual_value" type="text" value="" style="text-align: center; width:50px" onchange="checkNum(this)"/></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    	<td style="border: black 1px solid;"></td>
	    </tr>
	  </table>
	</div>
  </div>
<script type="text/javascript">
	var tabledata;
	cruConfig.contextPath =  '<%=contextPath%>';
	var project_info_no = '<%=project_info_no%>';
	$("#table_box").css("height",$(window).height()-$("#inq_tool_box").height());
	function loadData(){
		var sql = " select hx_target_value,"+
						    "hx_actual_value,"+
							"chkg_target_value,"+
							"chkg_actual_value,"+
							"fl_target_value,"+
							"fl_actual_value,"+
							"sl_target_value,"+
							"sl_actual_value,"+
							"rwwckg_target_value,"+
							"rwwckg_actual_value,"+
							"cjts_target_value,"+
							"cjts_actual_value,"+
							"downtime_target_value,"+
							"downtime_actual_value,"+
							"nvl(safe,0) safe,"+
							"nvl(quality,0) quality,"+
							"nvl(behavior,0) behavior,"+
							"standby_target_value,"+
							"standby_actual_value,"+
							"pjzycs_target_value,"+
							"pjzycs_actual_value,"+
							"pjhxsj_target_value,"+
							"pjhxsj_actual_value,"+
							"infill_target_value,"+
							"infill_actual_value,"+
							"nvl(dq_score,0) dq_score,"+
							"nvL(cjts_score,0) cjts_score,"+
							"nvl(downtime_score,0) downtime_score,bsflag from bgp_pm_evaluate_project_sea where evaluate_project_id = '"+project_info_no+"'";
		var retObj = syncRequest('post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+sql);
		if(retObj!=null&& retObj.returnCode =='0' && retObj.datas.length>0){
			tabledata = retObj;
			if(retObj.datas[0]!=null){
				var map = retObj.datas[0];
				with(map){
					document.getElementById("hx_target_value").value = hx_target_value;
					document.getElementById("hx_actual_value").value = hx_actual_value;
					document.getElementById("chkg_target_value").value = chkg_target_value;
					document.getElementById("chkg_actual_value").value = chkg_actual_value;
					document.getElementById("fl_target_value").value = fl_target_value;
					document.getElementById("fl_actual_value").value = fl_actual_value;
					document.getElementById("sl_target_value").value = sl_target_value;
					document.getElementById("sl_actual_value").value = sl_actual_value;
					document.getElementById("rwwckg_target_value").value = rwwckg_target_value;
					document.getElementById("rwwckg_actual_value").value = rwwckg_actual_value;
					document.getElementById("cjts_target_value").value = cjts_target_value;
					document.getElementById("cjts_actual_value").value = cjts_actual_value;
					document.getElementById("downtime_target_value").value = downtime_target_value;
					document.getElementById("downtime_actual_value").value = downtime_actual_value;
					document.getElementById("safe").value = safe;
					document.getElementById("quality").value = quality;
					document.getElementById("behavior").value = behavior;
					document.getElementById("standby_target_value").value = standby_target_value;
					document.getElementById("standby_actual_value").value = standby_actual_value;
					document.getElementById("pjzycs_target_value").value = pjzycs_target_value;
					document.getElementById("pjzycs_actual_value").value = pjzycs_actual_value;
					document.getElementById("pjhxsj_target_value").value = pjhxsj_target_value;
					document.getElementById("pjhxsj_actual_value").value = pjhxsj_actual_value;
					document.getElementById("infill_target_value").value = infill_target_value;
					document.getElementById("infill_actual_value").value = infill_actual_value;
					document.getElementById("dq_score").value = dq_score;
					document.getElementById("cjts_score").value = cjts_score;
					document.getElementById("downtime_score").value = downtime_score;
					document.getElementById("sum").value = parseInt(dq_score)+parseInt(cjts_score)+parseInt(downtime_score);
					document.getElementById("total_score").innerHTML = parseInt(dq_score)+parseInt(cjts_score)+parseInt(downtime_score);
				}
			}
		}else{
			document.getElementById("total_score").innerHTML ='未评价';
		}
	}
	
	
	function toSubmit(){
		var retObj;
		var hx_target_value = document.getElementById("hx_target_value").value;
		if(hx_target_value==""){
			alert("航行指标目标值不能为空");
			document.getElementById("hx_target_value").focus();
			return false;
		}
		var hx_actual_value = document.getElementById("hx_actual_value").value;
		if(hx_actual_value==""){
			alert("航行指标实际值不能为空");
			document.getElementById("hx_actual_value").focus();
			return false;
		}
		var chkg_target_value = document.getElementById("chkg_target_value").value;
		if(chkg_target_value==""){
			alert("靠港指标目标值不能为空");
			document.getElementById("chkg_target_value").focus();
			return false;
		}
		var chkg_actual_value = document.getElementById("chkg_actual_value").value;
		if(chkg_actual_value==""){
			alert("靠港指标实际值不能为空");
			document.getElementById("chkg_actual_value").focus();
			return false;
		}
		var fl_target_value = document.getElementById("fl_target_value").value;
		if(fl_target_value==""){
			alert("放缆指标目标值不能为空");
			document.getElementById("fl_target_value").focus();
			return false;
		}
		var fl_actual_value = document.getElementById("fl_actual_value").value;
		if(fl_actual_value==""){
			alert("放缆指标实际值不能为空");
			document.getElementById("fl_actual_value").focus();
			return false;
		}
		var sl_target_value = document.getElementById("sl_target_value").value;
		if(sl_target_value==""){
			alert("收缆指标目标值不能为空");
			document.getElementById("sl_target_value").focus();
			return false;
		}
		var sl_actual_value = document.getElementById("sl_actual_value").value;
		if(sl_actual_value==""){
			alert("收缆指标实际值不能为空");
			document.getElementById("sl_actual_value").focus();
			return false;
		}
		var rwwckg_target_value = document.getElementById("rwwckg_target_value").value;
		if(rwwckg_target_value==""){
			alert("靠港指标目标值不能为空");
			document.getElementById("rwwckg_target_value").focus();
			return false;
		}
		var rwwckg_actual_value = document.getElementById("rwwckg_actual_value").value;
		if(rwwckg_actual_value==""){
			alert("靠港指标实际值不能为空");
			document.getElementById("rwwckg_actual_value").focus();
			return false;
		}
		var cjts_target_value = document.getElementById("cjts_target_value").value;
		if(cjts_target_value==""){
			alert("采集天数指标目标值不能为空");
			document.getElementById("cjts_target_value").focus();
			return false;
		}
		var cjts_actual_value = document.getElementById("cjts_actual_value").value ;
		if(cjts_actual_value==""){
			alert("采集天数指标实际值不能为空");
			document.getElementById("cjts_actual_value").focus();
			return false;
		}
		var downtime_target_value = document.getElementById("downtime_target_value").value;
		if(downtime_target_value==""){
			alert("Downtime率指标目标值不能为空");
			document.getElementById("downtime_target_value").focus();
			return false;
		}
		var downtime_actual_value = document.getElementById("downtime_actual_value").value;
		if(downtime_actual_value==""){
			alert("Downtime率指标实际值不能为空");
			document.getElementById("downtime_actual_value").focus();
			return false;
		}
		var safe = document.getElementById("safe").value ;
		var quality = document.getElementById("quality").value;
		var behavior = document.getElementById("behavior").value ;
		var standby_target_value = document.getElementById("standby_target_value").value;
		var standby_actual_value = document.getElementById("standby_actual_value").value;
		var pjzycs_target_value = document.getElementById("pjzycs_target_value").value;
		var pjzycs_actual_value = document.getElementById("pjzycs_actual_value").value;
		var pjhxsj_target_value = document.getElementById("pjhxsj_target_value").value;
		var pjhxsj_actual_value = document.getElementById("pjhxsj_actual_value").value ;
		var infill_target_value = document.getElementById("infill_target_value").value ;
		var infill_actual_value = document.getElementById("infill_actual_value").value;
		var dq_score = document.getElementById("dq_score").value;
		if(dq_score==""){
			alert("动遣指标实际得分不能为空");
			document.getElementById("dq_score").focus();
			return false;
		}
		var cjts_score = document.getElementById("cjts_score").value;
		if(cjts_score==""){
			alert("采集天数实际得分不能为空");
			document.getElementById("cjts_score").focus();
			return false;
		}
		var downtime_score = document.getElementById("downtime_score").value;
		if(downtime_score==""){
			alert("Downtime率实际得分不能为空");
			document.getElementById("downtime_score").focus();
			return false;
		}
		
		var updatesql = " update bgp_pm_evaluate_project_sea set hx_target_value='"+hx_target_value+"',"+
						  "  hx_actual_value='"+hx_actual_value+"',"+
						  "  chkg_target_value='"+chkg_target_value+"',"+
						  "  chkg_actual_value='"+chkg_actual_value+"',"+
						  "  fl_target_value='"+fl_target_value+"',"+
						  "  fl_actual_value='"+fl_actual_value+"',"+
						  "  sl_target_value='"+sl_target_value+"',"+
						  "  sl_actual_value='"+sl_actual_value+"',"+
						  "  rwwckg_target_value='"+rwwckg_target_value+"',"+
						  "  rwwckg_actual_value='"+rwwckg_actual_value+"',"+
						  "  cjts_target_value='"+cjts_target_value+"',"+
						  "  cjts_actual_value='"+cjts_actual_value+"',"+
						  "  downtime_target_value='"+downtime_target_value+"',"+
						  "  downtime_actual_value='"+downtime_actual_value+"',"+
						  "  safe='"+safe+"',"+
						  "  quality='"+quality+"',"+
						  "  behavior='"+behavior+"',"+
						  "  standby_target_value='"+standby_target_value+"',"+
						  "  standby_actual_value='"+standby_actual_value+"',"+
						  "  pjzycs_target_value='"+pjzycs_target_value+"',"+
						  "  pjzycs_actual_value='"+pjzycs_actual_value+"',"+
						  "  pjhxsj_target_value='"+pjhxsj_target_value+"',"+
						  "  pjhxsj_actual_value='"+pjhxsj_actual_value+"',"+
						  "  infill_target_value='"+infill_target_value+"',"+
						  "  infill_actual_value='"+infill_actual_value+"',"+
						  "  dq_score='"+dq_score+"',"+
						  "  cjts_score='"+cjts_score+"',"+
						  "  downtime_score='"+downtime_score+"' where evaluate_project_id = '"+project_info_no+"'";
		var insertsql = " insert into bgp_pm_evaluate_project_sea (evaluate_project_id,hx_target_value,hx_actual_value,chkg_target_value,chkg_actual_value,fl_target_value,fl_actual_value,sl_target_value,sl_actual_value,rwwckg_target_value,rwwckg_actual_value,cjts_target_value,cjts_actual_value,downtime_target_value,"+
				" downtime_actual_value,safe,quality,behavior,standby_target_value,standby_actual_value,pjzycs_target_value,pjzycs_actual_value,pjhxsj_target_value,pjhxsj_actual_value,infill_target_value,infill_actual_value,dq_score,cjts_score,downtime_score) "+
				" values('"+project_info_no+"','"+
						hx_target_value+"','"+
						hx_actual_value+"','"+
						chkg_target_value+"','"+
						chkg_actual_value+"','"+
						fl_target_value+"','"+
						fl_actual_value+"','"+
						sl_target_value+"','"+
						sl_actual_value+"','"+
						rwwckg_target_value+"','"+
						rwwckg_actual_value+"','"+
						cjts_target_value+"','"+
						cjts_actual_value+"','"+
						downtime_target_value+"','"+
						downtime_actual_value+"','"+
						safe+"','"+
						quality+"','"+
						behavior+"','"+
						standby_target_value+"','"+
						standby_actual_value+"','"+
						pjzycs_target_value+"','"+
						pjzycs_actual_value+"','"+
						pjhxsj_target_value+"','"+
						pjhxsj_actual_value+"','"+
						infill_target_value+"','"+
						infill_actual_value+"','"+
						dq_score+"','"+
						cjts_score+"','"+
						downtime_score+"')";
		if(tabledata!=null){
			retObj = jcdpCallService("ProjectEvaluationSrv", "saveDatasBySql", "sql="+updatesql);
		}else{
			retObj = jcdpCallService("ProjectEvaluationSrv", "saveDatasBySql", "sql="+insertsql);
		}
		if(retObj!=null && retObj.returnCode=='0'){
			alert("保存成功!");
			loadData();
		}else{
			alert("保存失败!");
		}
	}
	//计算汇总分数
	function countSum(){
		var sum = new Number();
		var dq_score = document.getElementById("dq_score").value;
		if(isNaN(dq_score)||dq_score>30){
			alert("请输入小于30的数字");
			document.getElementById("dq_score").value="";
			return false;
		}else{
			sum+=Number(dq_score)
		}
		var cjts_score = document.getElementById("cjts_score").value;
		if(isNaN(cjts_score)||cjts_score>50){
			alert("请输入小于50的数字");
			document.getElementById("cjts_score").value="";
			return false;
		}else{
			sum+=Number(cjts_score)
		}
		var downtime_score = document.getElementById("downtime_score").value;
		if(isNaN(downtime_score)||downtime_score>20){
			alert("请输入小于20的数字");
			document.getElementById("downtime_score").value="";
			return false;
		}else{
			sum+=Number(downtime_score)
		}
		document.getElementById("sum").value=sum;
	}
	//判断输入是否为整数
	function checkInt(obj){
		var value = obj.value;
		if(parseInt(value)!=value){
			alert("请输入整数!");
			obj.value="";
			return false;
		}else{
			return true;
		}
	}
	function checkNum(obj){
		var value = obj.value;
		if(isNaN(value)){
			alert("请输入数字");
			obj.value="";
			return false;
		}else{
			return true;
		}
	}
	
	function toAdd(){
		popWindow('<%=contextPath%>/pm/projectEvaluation/file_list.jsp');
	}
</script>
</body>
</html>