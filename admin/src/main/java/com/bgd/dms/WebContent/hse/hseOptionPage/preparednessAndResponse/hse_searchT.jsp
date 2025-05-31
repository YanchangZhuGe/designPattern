<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String isProject = request.getParameter("isProject");
	if(isProject==null||isProject.equals("")){
		isProject = resultMsg.getValue("isProject");
	}
 
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
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<script language="javaScript">
cruConfig.contextPath = "<%=contextPath%>";
function addSelect(){ 
	   var certificate = document.getElementsByName("participants_range"); 
		var certificate_no = ""; 
		for(var i=0;i<certificate.length;i++){
			if(certificate[i].checked==true){
				certificate_no = certificate_no + certificate[i].value + ";";	
			}
		} 
		document.getElementsByName("participants_ranges")[0].value=certificate_no; 
	}

	function submit(){
		addSelect();  
		var ctt = top.frames('list');		
		var org_sub_id = document.getElementById("second_org").value;
		var second_org = document.getElementById("third_org").value;
		var third_org = document.getElementById("fourth_org").value; 
		
		var participants_range =document.getElementsByName("participants_ranges")[0].value;
		var  practice_category = document.getElementById("practice_category").value;   
		var  s_time = document.getElementById("s_time").value;  
		var d_time = document.getElementById("d_time").value;  
		var d_time2 = document.getElementById("d_time2").value;  
		var isProject = "<%=isProject%>";
		var querySqlAdd = "";
		if(isProject=="1"){
			querySqlAdd = getMultipleSql2("");
		}else if(isProject=="2"){
			querySqlAdd = "and project_no='<%=user.getProjectInfoNo()%>'";
		}
		var sql = ""; 
		    sql = "   select *  from (select cn.training_no as pk_id,   cn.modifi_date,    cn.training_start_time as s_time,       to_date('', '') d_time,       '' p_category,       '' e_plan,       ion.org_abbreviation as org_name,       decode(cn.spare1, '1', '培训') as if_type,       cn.spare1,       oi1.org_abbreviation as second_org_name,       oi2.org_abbreviation as third_org_name,       cn.participants_range,       '' practice_category,         cn.org_sub_id,       cn.second_org,       cn.third_org,       cn.bsflag,cn.project_no  from BGP_EMERGENCY_TRAINING cn  left join comm_org_subjection os1    on cn.second_org = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection os2    on cn.third_org = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_subjection ose    on cn.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id " +
				" union " +
				"  select tr.drill_no as pk_id,     tr.modifi_date,  '' s_time,       tr.drilling_time as d_time,       decode(tr.practice_category, '1', '实战演练', '2', '桌面演练') as p_category,       tr.emergency_plan as e_plan,       ion.org_abbreviation as org_name,       decode(tr.spare1, '2', '演练') as if_type,       tr.spare1,       oi1.org_abbreviation as second_org_name,       oi2.org_abbreviation as third_org_name,   tr.participants_range,       tr. practice_category,         tr.org_sub_id,       tr.second_org,       tr.third_org,       tr.bsflag,tr.project_no  from BGP_EMERGENCY_DRILL tr  left join comm_org_subjection os1    on tr.second_org = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection os2    on tr.third_org = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id  " +
				"  union " +
				"  select tw.train_drill_no as pk_id,   tw.modifi_date,     tw.training_start_time as s_time,       tw.drilling_time as d_time,       decode(tw.practice_category, '1', '实战演练', '2', '桌面演练') as p_category,       tw.emergency_plan as e_plan,       ion.org_abbreviation as org_name,       decode(tw.spare1, '3', '培训和演练') as if_type,       tw.spare1,       oi1.org_abbreviation as second_org_name,       oi2.org_abbreviation as third_org_name,       tw.participants_range,       tw. practice_category,       tw.org_sub_id,       tw.second_org,       tw.third_org,       tw.bsflag,tw.project_no  from BGP_TRAINING_DRILL tw  left join comm_org_subjection os1    on tw.second_org = os1.org_subjection_id   and os1.bsflag = '0'  left join comm_org_information oi1    on oi1.org_id = os1.org_id   and oi1.bsflag = '0'  left join comm_org_subjection os2    on tw.third_org = os2.org_subjection_id   and os2.bsflag = '0'  left join comm_org_information oi2    on oi2.org_id = os2.org_id   and oi2.bsflag = '0'  left join comm_org_subjection ose    on tw.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id )  tr   where tr.bsflag='0'  "+querySqlAdd+sql;
 
		if(org_sub_id!=''&&org_sub_id!=null){
			sql = sql+" and tr.org_sub_id = '"+org_sub_id+"'";
		}
		if(second_org!=''&&second_org!=null){
			sql = sql+" and tr.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and tr.third_org = '"+third_org+"'";
		}
		 
		if(third_org!=''&&third_org!=null){
			sql = sql+" and tr.third_org = '"+third_org+"'";
		}
		
		if(participants_range!=''&&participants_range!=null){
			sql = sql+" and tr.participants_range like '%"+participants_range+"%'";
		}
		
		if(practice_category!=''&&practice_category!=null){
			sql = sql+" and tr.practice_category = '"+practice_category+"'";
		}
		
		if(s_time!=''&&s_time!=null){
			sql = sql+" and tr.s_time  like '%"+s_time+"%'";
		}
		 
		if(d_time!=''&&d_time!=null){
			sql = sql+" and tr.d_time >= to_date('"+d_time+"','yyyy-MM-dd')";
		}
		if(d_time2!=''&&d_time2!=null){
			sql = sql+" and tr.d_time <= to_date('"+d_time2+"','yyyy-MM-dd')";
		}
 
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
	function addSelect(){ 
		   var certificate = document.getElementsByName("participants_range"); 
			var certificate_no = ""; 
			for(var i=0;i<certificate.length;i++){
				if(certificate[i].checked==true){
					certificate_no = certificate_no + certificate[i].value + ";";	
				}
			} 
			document.getElementsByName("participants_ranges")[0].value=certificate_no; 
		}
	
	
	function  setDisAttr(chkObj){  
		  var   chks=document.getElementsByName(chkObj.name);     
			if(chks[0].checked ==true){
				  chks[0].disabled   =  false;
				  chks[1].disabled   =  true;
				  chks[2].disabled   =  true;
				  chks[3].disabled   =  true;
				  chks[4].disabled   =  true;
				  chks[5].disabled   =  true;
			}
			if(chks[0].checked ==false){ 
				  chks[0].disabled   =  false;
				  chks[1].disabled   =  false;
				  chks[2].disabled   =  false;
				  chks[3].disabled   =  false;
				  chks[4].disabled   =  false;
				  chks[5].disabled   =  false; 
			}
				   
	  } 

	function   setDisAttr1(chkObj){  
		  var   chks=document.getElementsByName(chkObj.name);     
			if(chks[1].checked ==true){
				  chks[0].disabled   =  true;
				  chks[1].disabled   =  false;
				  chks[2].disabled   =  false;
				  chks[3].disabled   =  false;
				  chks[4].disabled   =  false;
				  chks[5].disabled   =  false;
			}
			if(chks[1].checked ==false){ 
				if(chks[2].checked ==false && chks[3].checked ==false && chks[4].checked ==false && chks[5].checked ==false ){ 
					  chks[0].disabled   =  false;
				}else{
					
					 chks[0].disabled   =  true;
				}
				 
			}
				   
	}
	function   setDisAttr2(chkObj){  
		  var   chks=document.getElementsByName(chkObj.name);     
			if(chks[2].checked ==true){
				  chks[0].disabled   =  true;
				  chks[1].disabled   =  false;
				  chks[2].disabled   =  false;
				  chks[3].disabled   =  false;
				  chks[4].disabled   =  false;
				  chks[5].disabled   =  false;
			}
			if(chks[2].checked ==false){ 
				if(chks[1].checked ==false && chks[3].checked ==false  && chks[4].checked ==false && chks[5].checked ==false ){ 
					  chks[0].disabled   =  false;
				}else{
					
					 chks[0].disabled   =  true;
				} 
			} 
	}

	function   setDisAttr3(chkObj){  
		  var   chks=document.getElementsByName(chkObj.name);     
			if(chks[3].checked ==true){
				  chks[0].disabled   =  true;
				  chks[1].disabled   =  false;
				  chks[2].disabled   =  false;
				  chks[3].disabled   =  false;
				  chks[4].disabled   =  false;
				  chks[5].disabled   =  false;
			}
			if(chks[3].checked ==false){ 
				if(chks[1].checked ==false && chks[2].checked ==false  && chks[4].checked ==false && chks[5].checked ==false ){ 
					  chks[0].disabled   =  false;
				}else{ 
					 chks[0].disabled   =  true;
				}
				 
			}
				   
	}
	function   setDisAttr4(chkObj){  
		  var   chks=document.getElementsByName(chkObj.name);     
			if(chks[4].checked ==true){
				  chks[0].disabled   =  true;
				  chks[1].disabled   =  false;
				  chks[2].disabled   =  false;
				  chks[3].disabled   =  false;
				  chks[4].disabled   =  false;
				  chks[5].disabled   =  false;
			}
			if(chks[4].checked ==false){ 
				if(chks[1].checked ==false && chks[2].checked ==false  && chks[3].checked ==false && chks[5].checked ==false ){ 
					  chks[0].disabled   =  false;
				}else{ 
					 chks[0].disabled   =  true;
				}
				 
			}
				   
	}
	function   setDisAttr5(chkObj){  
		  var   chks=document.getElementsByName(chkObj.name);     
			if(chks[5].checked ==true){
				  chks[0].disabled   =  true;
				  chks[1].disabled   =  false;
				  chks[2].disabled   =  false;
				  chks[3].disabled   =  false;
				  chks[4].disabled   =  false;
				  chks[5].disabled   =  false;
			}
			if(chks[5].checked ==false){ 
				if(chks[1].checked ==false && chks[2].checked ==false  && chks[3].checked ==false && chks[4].checked ==false ){ 
					  chks[0].disabled   =  false;
				}else{ 
					 chks[0].disabled   =  true;
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
	        <td class="inquire_item6">单位：</td>
	      	<td class="inquire_form6">
	      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
	      	<input type="text" id="second_org2" name="second_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
	      	</td>
	     	<td class="inquire_item6">基层单位：</td>
	      	<td class="inquire_form6">
	      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
	      	<input type="text" id="third_org2" name="third_org2" class="input_width" />
	      	<input type="hidden" id="participants_ranges" name="participants_ranges" value="" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
	      	</td>
	
        </tr>

        <tr>
     	<td class="inquire_item6">下属单位：</td>
      	<td class="inquire_form6">
      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width" />
      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
      	</td>
      	 <td class="inquire_item6"><font color="red">*</font>演练类别：</td>
		    <td class="inquire_form6"> 
		    <select id="practice_category" name="practice_category" class="select_width">
		       <option value="" >请选择</option>
		       <option value="1" >实战演练</option>
		       <option value="2" >桌面演练</option>  
			</select> 
		    </td>	
		   
        </tr>
        
        
        <tr>								 
		   <td class="inquire_item6">参加人员范围：</td>
		    <td class="inquire_form6"  colspan="3">
		    <input type="checkbox"    id="participants_range1"   name="participants_range"  onclick="setDisAttr(this);"  value="全体员工" />全体员工
		    <input type="checkbox"    id="participants_range2"   name="participants_range"   onclick="setDisAttr1(this);"  value="应急人员" />应急人员
		    <input type="checkbox"    id="participants_range3"   name="participants_range"  onclick="setDisAttr2(this);"  value="直线管理人员" />直线管理人员
		    <input type="checkbox"    id="participants_range4"   name="participants_range"  onclick="setDisAttr3(this);"  value="HSE管理人员" />HSE管理人员
		    <input type="checkbox"    id="participants_range5"   name="participants_range"  onclick="setDisAttr4(this);"  value="新上岗转岗人员" />新上岗转岗人员
		    <input type="checkbox"    id="participants_range6"   name="participants_range"  onclick="setDisAttr5(this);"  value="外来人员" />外来人员
		    </td>
		   	    
		</tr>	
		     
        <tr>
          <td class="inquire_item6">培训开始时间：</td>
		  <td class="inquire_form6"><input type="text" id="s_time" name="s_time" class="input_width"  /></td> 
		  <tr>
          <td class="inquire_item6">演练时间：</td>
		  <td class="inquire_form6"><input type="text" id="d_time" name="d_time" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(d_time,tributton3);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="d_time2" name="d_time2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(d_time2,tributton4);" />&nbsp;</td>
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

