<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
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
<script language="javaScript">
	function submit(){
		var ctt = top.frames('list');
		
		var danger_name = document.getElementById("danger_name").value;
		var danger_level = document.getElementById("danger_level").value;
		var danger_place = document.getElementById("danger_place").value;
		var modify_type = document.getElementById("modify_type").value;
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var danger_date = document.getElementById("danger_date").value;  
		var reward_type = document.getElementById("reward_type").value;
		
		var sql = "select t.*,oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name from bgp_hse_danger t join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' and t.bsflag = '0'";
		if(danger_name!=''&&danger_name!=null){
			sql = sql+" and t.danger_name like '%"+danger_name+"%'";
		}
		if(danger_level!=''&&danger_level!=null){
			sql = sql+" and t.danger_level like '%"+danger_level+"%'";
		}
		if(danger_place!=''&&danger_place!=null){
			sql = sql+" and t.danger_place like '%"+danger_place+"%'";
		}
		if(modify_type!=''&&modify_type!=null){
			sql = sql+" and t.modify_type like '%"+modify_type+"%'";
		}
		if(second_org!=''&&second_org!=null){
			sql = sql+" and t.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and t.third_org = '"+third_org+"'";
		}
		if(danger_date!=''&&danger_date!=null){
			sql = sql+" and t.danger_date = to_date('"+danger_date+"','yyyy-MM-dd')";
		}
		if(reward_type!=''&&reward_type!=null){
			sql = sql+" and t.reward_type = '"+reward_type+"'";
		}
		sql = sql+" order by t.modifi_date desc";
		
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
	    if(second==""||second==null){
	    	alert("请先选择二级单位！");
	    }else{
		    var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
		    var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				var org_id = datas[0].org_id; 
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("third_org").value = teamInfo.fkValue;
			        document.getElementById("third_org2").value = teamInfo.value;
			    }
			}
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
          <td class="inquire_item4">隐患名称:</td>
          <td class="inquire_form4"><input id="danger_name"  name="danger_name" class="input_width" type="text" /></td>
          <td class="inquire_item4">隐患级别型:</td>
          <td class="inquire_form4">
          	<select id="danger_level" name="danger_level" class="select_width" >
				<option value="" >请选择</option>
				<option value="一般" >一般</option>
				<option value="较大" >较大</option>
				<option value="重大" >重大</option>
				<option value="特大" >特大</option>
			</select>
          </td>
        </tr>
        <tr>
	        <td class="inquire_item4">二级单位：</td>
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
          <td class="inquire_item4">上报日期：</td>
      	  <td class="inquire_form4"><input type="text" id="danger_date" name="danger_date" class="input_width"  readonly="readonly"/>
      	  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(danger_date,tributton1);" />&nbsp;</td>
          <td class="inquire_item4">作业场所:</td>
          <td class="inquire_form4"><input id="danger_place" name="danger_place" class="input_width" type="text" /></td>
        </tr>
        <tr>
          <td class="inquire_item4">整改状态:</td>
          <td class="inquire_form4">
          	<select id="modify_type" name="modify_type" class="select_width">
				<option value="" >请选择</option>
				<option value="已整改" >已整改</option>
				<option value="未整改" >未整改</option>
			</select>
          </td>
          <td class="inquire_item4">奖励场所:</td>
          <td class="inquire_form4">
			<select id="reward_type" name="reward_type" class="select_width">
		        <option value="" >请选择</option>
				<option value="已奖励" >已奖励</option>
				<option value="未奖励" >未奖励</option>
			</select>
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

