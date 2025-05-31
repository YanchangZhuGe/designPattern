<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String isProject = request.getParameter("isProject");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<script language="javaScript">
cruConfig.contextPath = "<%=contextPath%>";
	function submit(){
		var ctt = top.frames('list');
		debugger;
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var fourth_org = document.getElementById("fourth_org").value;
		var project_name = document.getElementById("project_name").value; 
		var plan_money = document.getElementById("plan_money").value;  
		var plan_money_flag = document.getElementById("plan_money_flag").value;  
		var input_money = document.getElementById("input_money").value;
		var input_money_flag = document.getElementById("input_money_flag").value;
		var plan_flag = document.getElementById("plan_flag").value;
		var plan_complete = document.getElementById("plan_complete").value;
		var plan_check = document.getElementById("plan_check").value;
		var pass_flag = document.getElementById("pass_flag").value;
		var declare_date = document.getElementById("declare_date").value;  
		var declare_date2 = document.getElementById("declare_date2").value;
		
		var ids = "";
		var selected = document.getElementsByName("selected");
		for(var i=0; i<selected.length;i++){
			if(selected[i].checked){
				if(ids!="") ids += "、";
				ids +=selected[i].value;
			}
		}
		var money_source = ids;
		
		var re = /^\-?[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字    可为小数或者负数
		
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql("hf.");
		}else if(isProject=="2"){
			querySqlAdd = "and hf.project_info_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "select hf.*,decode(fd.plan_flag,'0','是','1','否') plan_flag,fd.input_money,oi1.org_abbreviation second_org_name,oi2.org_abbreviation third_org_name,oi3.org_abbreviation fourth_org_name from bgp_hse_financial hf left join bgp_hse_financial_detail fd on hf.hse_financial_id=fd.hse_financial_id and fd.bsflag='0' left join comm_org_subjection os1 on hf.second_org=os1.org_subjection_id and os1.bsflag='0' left join comm_org_information oi1 on os1.org_id=oi1.org_id and oi1.bsflag='0' left join comm_org_subjection os2 on hf.third_org=os2.org_subjection_id and os2.bsflag='0' left join comm_org_information oi2 on os2.org_id=oi2.org_id and oi2.bsflag='0' left join comm_org_subjection os3 on hf.fourth_org=os3.org_subjection_id and os3.bsflag='0' left join comm_org_information oi3 on os3.org_id=oi3.org_id and oi3.bsflag='0' where hf.bsflag='0' "+querySqlAdd;
		if(second_org!=''&&second_org!=null){
			sql = sql+" and hf.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and hf.third_org = '"+third_org+"'";
		}
		if(fourth_org!=''&&fourth_org!=null){
			sql = sql+" and hf.fourth_org = '"+fourth_org+"'";
		}
		if(project_name!=''&&project_name!=null){
			sql = sql+" and hf.project_name like '%"+project_name+"%'";
		}
		if(plan_money!=''&&plan_money!=null){
			if(plan_money_flag=="1"){
				sql = sql+" and hf.plan_money < '"+plan_money+"'";
			}else if(plan_money_flag=="2"){
				sql = sql+" and hf.plan_money = '"+plan_money+"'";
			}else if(plan_money_flag=="3"){
				sql = sql+" and hf.plan_money > '"+plan_money+"'";
			}
			
		}
		if(input_money!=''&&input_money!=null){
			if(input_money_flag=="1"){
				sql = sql+" and fd.input_money < '"+input_money+"'";
			}else if(input_money_flag=="2"){
				sql = sql+" and fd.input_money = '"+input_money+"'";
			}else if(input_money_flag=="3"){
				sql = sql+" and fd.input_money > '"+input_money+"'";
			}
			
		}
		if(plan_flag!=''&&plan_flag!=null){
			sql = sql+" and fd.plan_flag = '"+plan_flag+"'";
		}
		if(plan_complete!=''&&plan_complete!=null){
			if(plan_complete=="0"){
				sql = sql+" and fd.hse_detail_id is not null";
			}else if(plan_complete=="1"){
				sql = sql+" and fd.hse_detail_id is null";
			}
		}
		if(plan_check!=''&&plan_check!=null){
			if(plan_check=="0"){
				sql = sql+" and hf.pass_flag is not null";
			}else if(plan_check=="1"){
				sql = sql+" and hf.pass_flag is null";
			}
		}
		if(pass_flag!=''&&pass_flag!=null){
			sql = sql+" and hf.pass_flag = '"+pass_flag+"'";
		}
		if(declare_date!=''&&declare_date!=null){
			sql = sql+" and hf.declare_date >= to_date('"+declare_date+"','yyyy-MM-dd')";
		}
		if(declare_date2!=''&&declare_date2!=null){
			sql = sql+" and hf.declare_date <= to_date('"+declare_date2+"','yyyy-MM-dd')";
		}
		if(money_source!=''&&money_source!=null){
			sql = sql+" and hf.money_source like  '%"+money_source+"%'";
		}
		sql = sql+" order by hf.modifi_date desc";
		
		ctt.refreshData2(sql);
		newClose();
	}
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("second_org").value = teamInfo.fkValue;
	        document.getElementById("second_org2").value = teamInfo.value;
	    }
	}

	function selectOrg2(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("second_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("third_org").value = teamInfo.fkValue;
			        document.getElementById("third_org2").value = teamInfo.value;
				}
	   
	}

	function selectOrg3(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var third = document.getElementById("third_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("fourth_org").value = teamInfo.fkValue;
			        document.getElementById("fourth_org2").value = teamInfo.value;
				}
	}
	
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
	        <td class="inquire_item4">单位：</td>
	      	<td class="inquire_form4">
	      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
	      	<input type="text" id="second_org2" name="second_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
	      	</td>
	     	<td class="inquire_item4">基层单位：</td>
	      	<td class="inquire_form4">
	      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
	      	<input type="text" id="third_org2" name="third_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
	      	</td>
        </tr>
        <tr>
			<td class="inquire_item4">下属单位：</td>
			<td class="inquire_form4">
		    	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
		    	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width" />
		    	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
		    </td>
	        <td class="inquire_item4">项目名称:</td>
	        <td class="inquire_form4">
	        	<input type="text" id="project_name" name="project_name" class="input_width"></input>
	        </td>
        </tr>
        <tr>
	          <td class="inquire_item4">计划所需资金(万元):</td>
	          <td class="inquire_form4">
	          	<select id="plan_money_flag" name="plan_money_flag" class="select_width" style="width: 25%;">
					<option value="1" >小于</option>
					<option value="2" >等于</option>
					<option value="3" >大于</option>
				</select>
				&nbsp;<input type="text" id="plan_money" name="plan_money" class="input_width" style="float: none;width: 51%;"></input>
	          </td>
          	 <td class="inquire_item4">投入资金(万元):</td>
	          <td class="inquire_form4">
	          	<select id="input_money_flag" name="input_money_flag" class="select_width" style="width: 25%;">
					<option value="1" >小于</option>
					<option value="2" >等于</option>
					<option value="3" >大于</option>
				</select>
				&nbsp;<input type="text" id="input_money" name="input_money" class="input_width" style="float: none;width: 51%;"></input>
	          </td>
        </tr>
        <tr>
          	  <td class="inquire_item4">是否计划内:</td>
          	  <td class="inquire_form4">
	          	<select id="plan_flag" name="plan_flag" class="select_width" >
	          		<option value="" >请选择</option>
					<option value="0" >是</option>
					<option value="1" >否</option>
				</select>
	          </td>
          	  <td class="inquire_item4">计划是否完成:</td>
          	  <td class="inquire_form4">
	          	<select id="plan_complete" name="plan_complete" class="select_width" >
	          		<option value="" >请选择</option>
					<option value="0" >是</option>
					<option value="1" >否</option>
				</select>
	          </td>
        </tr>
        <tr>
	          <td class="inquire_item4">计划是否验收:</td>
	          <td class="inquire_form4" >
				<select id="plan_check" name="plan_check" class="select_width" >
					<option value="" >请选择</option>
					<option value="0" >是</option>
					<option value="1" >否</option>
				</select>
			  </td>
          	  <td class="inquire_item4">验收意见:</td>
          	  <td class="inquire_form4">
	          	<select id="pass_flag" name="pass_flag" class="select_width" >
					<option value="" >请选择</option>
					<option value="0" >通过</option>
					<option value="1" >未通过</option>
				</select>
	          </td>
	     </tr>
	     <tr>
	          <td class="inquire_item4">申报日期:</td>
	          <td class="inquire_form4" colspan="3"><input type="text" id="declare_date" name="declare_date" class="input_width" value="" style="width: 32%;float: none;" readonly="readonly"/>
				&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(declare_date,tributton1);" />&nbsp;
				至&nbsp;&nbsp;&nbsp;<input type="text" id="declare_date2" name="declare_date2" class="input_width" value="" style="width: 32%;float: none;" readonly="readonly"/>
				&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(declare_date2,tributton2);" />&nbsp;
			  </td>
        </tr>
        <tr>
	          <td class="inquire_item4">资金来源:</td>
	          <td class="inquire_form4" colspan="3">
				<input type="hidden" id="money_source" name="money_source" value=""/>
				<input type="checkbox"  name="selected" value="1">集团公司</input>&nbsp;&nbsp;&nbsp;
				<input type="checkbox"  name="selected" value="2">公司</input>&nbsp;&nbsp;&nbsp;
				<input type="checkbox"  name="selected" value="3">二级单位</input>&nbsp;&nbsp;&nbsp;
				<input type="checkbox"  name="selected" value="4">基层单位</input>&nbsp;&nbsp;&nbsp;
			  </td>
		</tr>
      </table>
     
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submit()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</body>

</html>

