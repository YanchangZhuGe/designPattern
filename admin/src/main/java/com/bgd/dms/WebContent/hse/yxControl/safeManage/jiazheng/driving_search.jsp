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
		var ctt = top.frames('list').frames[1];
		
		var second_org = document.getElementById("second_org").value;
		var third_org = document.getElementById("third_org").value;
		var name = document.getElementById("name").value;  
		var sex = document.getElementById("sex").value;  
		var birthday = document.getElementById("birthday").value;  
		var driving_type = document.getElementById("driving_type").value;  
		var car_type = document.getElementById("car_type").value;  
		var sign_date = document.getElementById("sign_date").value;  
		var expiry_date = document.getElementById("expiry_date").value;  
		var duty = document.getElementById("duty").value;  

		var sql = "select t.hse_driving_id,t.second_org,t.third_org,t.name,t.car_type,t.driving_number, r.notes,oi1.org_abbreviation as second_org_name, oi2.org_abbreviation as third_org_name, t.create_date,t.modifi_date,months_between(t.expiry_date,to_date(to_char(sysdate,'yyyy-MM-dd'),'yyyy-MM-dd')) color  from bgp_hse_control_driving t join comm_org_subjection os1 on t.second_org = os1.org_subjection_id and os1.bsflag = '0' join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0' join comm_org_subjection os2 on t.third_org = os2.org_subjection_id and os2.bsflag = '0' join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join bgp_comm_remark r on t.hse_driving_id = r.foreign_key_id and r.bsflag='0' where t.bsflag = '0'";
		if(second_org!=''&&second_org!=null){
			sql = sql+" and t.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and t.third_org = '"+third_org+"'";
		}
		if(name!=''&&name!=null){
			sql = sql+" and t.name like '%"+name+"%'";
		}
		if(sex!=''&&sex!=null){
			sql = sql+" and t.sex = '"+sex+"'";
		}
		if(birthday!=''&&birthday!=null){
			sql = sql+" and t.birthday = to_date('"+birthday+"','yyyy-MM-dd')";
		}
		if(driving_type!=''&&driving_type!=null){
			sql = sql+" and t.driving_type = '"+driving_type+"'";
		}
		if(car_type!=''&&car_type!=null){
			sql = sql+" and t.car_type = '"+car_type+"'";
		}
		if(sign_date!=''&&sign_date!=null){
			sql = sql+" and t.sign_date = to_date('"+sign_date+"','yyyy-MM-dd')";
		}
		if(expiry_date!=''&&expiry_date!=null){
			sql = sql+" and t.expiry_date = to_date('"+expiry_date+"','yyyy-MM-dd')";
		}
		if(duty!=''&&duty!=null){
			sql = sql+" and t.duty like '%"+duty+"%'";
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
	        <td class="inquire_item6">二级单位：</td>
	      	<td class="inquire_form6">
	      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
	      	<input type="text" id="second_org2" name="second_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
	      	</td>
	     	<td class="inquire_item6">基层单位：</td>
	      	<td class="inquire_form6">
	      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
	      	<input type="text" id="third_org2" name="third_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
	      	</td>
          <td class="inquire_item6">姓名：</td>
      	  <td class="inquire_form6"><input type="text" id="name" name="name" class="input_width" /></td>
        </tr>
        <tr>
          <td class="inquire_item6">性别:</td>
          <td class="inquire_form6">
          	<select id="sex" name="sex" class="select_width">
				<option value="" >请选择</option>
				<option value="1" >男</option>
				<option value="2" >女</option>
			</select>
          </td>
          <td class="inquire_item6">出生年月：</td>
      	  <td class="inquire_form6"><input type="text" id="birthday" name="birthday" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(birthday,tributton1);" />&nbsp;</td>
          <td class="inquire_item6">准驾证类型:</td>
          <td class="inquire_form6">
          	<select id="driving_type" name="driving_type" class="select_width">
				<option value="" >请选择</option>
				<option value="1" >甲类准驾证</option>
				<option value="2" >乙类准驾证</option>
				<option value="3" >丙类准驾证</option>
			</select>
          </td>
        </tr>
        <tr>
          <td class="inquire_item6">准驾车型:</td>
          <td class="inquire_form6">
          	<select id="car_type" name="car_type" class="select_width">
				<option value="" >请选择</option>
			</select>
          </td>
          <td class="inquire_item6">签发日期：</td>
      	  <td class="inquire_form6"><input type="text" id="sign_date" name="sign_date" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(sign_date,tributton2);" />&nbsp;</td>
		   <td class="inquire_item6">有效期：</td>
      	  <td class="inquire_form6"><input type="text" id="expiry_date" name="expiry_date" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(expiry_date,tributton3);" />&nbsp;</td>
        </tr>
        <tr>
          <td class="inquire_item6">人员职务:</td>
          <td class="inquire_form6">
          	<select id="duty" name="duty" class="select_width">
				<option value="" >请选择</option>
				<option value="1" >处级</option>
				<option value="2" >科级</option>
				<option value="3" >其他</option>
			</select>
          </td>
          <td class="inquire_item6"></td>
      	  <td class="inquire_form6"></td>
		  <td class="inquire_item6"></td>
      	  <td class="inquire_form6"></td>
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

