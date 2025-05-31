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
	String paramS = request.getParameter("paramS");
	
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
	function submit(){
		var ctt = top.frames('list');		
		var org_sub_id = document.getElementById("second_org").value;
		var second_org = document.getElementById("third_org").value;
		  
		var check_unit_org = document.getElementById("check_unit_id").value;  
		var check_roots_org = document.getElementById("check_roots_id").value;   		
		var check_parts = document.getElementById("check_parts").value;   
		var check_type = document.getElementById("check_type").value;   
		var contact = document.getElementById("contact").value;   
		var leadership_led = document.getElementById("leadership_led").value;   
		var led_leadership = document.getElementById("led_leadership").value;   
		var check_name = document.getElementById("check_name").value;   
		var fuHao = document.getElementById("fuHao").value;   
		var number_problems = document.getElementById("number_problems").value;   
		
		var check_start_time = document.getElementById("check_start_time").value;   
		var check_start_time2 = document.getElementById("check_start_time2").value;  
		var check_end_time = document.getElementById("check_end_time").value;  
		var check_end_time2 = document.getElementById("check_end_time2").value;   
 
		var isProject = "<%=isProject%>";
		var sql = ""; 
		if(isProject=="1"){	
			retObj = jcdpCallService("HseSrv", "queryOrg", ""); 
			if(retObj.flag!="false"){
				var len = retObj.list.length;
				if(len>0){
					if(retObj.list[0].organFlag!="0"){
						sql = " and (tr.org_sub_id = '<%=user.getOrgSubjectionId()%>' or tr.check_unit_org like '%<%=user.getOrgSubjectionId()%>%' or tr.check_roots_org like '%<%=user.getOrgSubjectionId()%>%')";
						if(len>1){
							if(retObj.list[1].organFlag!="0"){
								sql = " and (tr.second_org = '<%=user.getOrgSubjectionId()%>' or tr.check_unit_org like '%<%=user.getOrgSubjectionId()%>%' or tr.check_roots_org like '%<%=user.getOrgSubjectionId()%>%')";
							}
						}
					}
				}
			}
		}else if(isProject=="2"){
			sql = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		var paramS = "<%=paramS%>"; 
		if(paramS=="1"){	 
			sql = " and tr.leadership_led='1'  ";
		}else if(paramS=="2"){
			sql = " and tr.check_type='3' ";
		}
		var sql = " select tr.check_no,case when length(tr.check_unit_org)<= 6 then tr.check_unit_org else concat(substr(tr.check_unit_org,0,6),'...') end check_unit_org, decode(tr.check_type,'1','日常检查','2','专项检查','3','联系点到位','','其他') check_typename, decode(tr.leadership_led,'1','是','2','否') leadership_ledname , case when length(tr.check_roots_org)<= 6 then tr.check_roots_org else concat(substr(tr.check_roots_org,0,6),'...') end check_roots_org,tr.check_parts,tr.check_type,tr.if_contractor_team,tr.contact,tr.leadership_led, tr.led_leadership,tr.check_members,tr.check_start_time,tr.check_end_time,tr.check_name,tr.number_problems,tr.verifier,tr.verifier_time,tr.verifier_opinion,  tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag, tr.modifi_date, tr.updator,oi1.org_abbreviation as second_org_name   from BGP_HSE_CHECK tr  left join comm_org_subjection os1   on tr.second_org = os1.org_subjection_id  and os1.bsflag = '0'  left join comm_org_information oi1  on oi1.org_id = os1.org_id  and oi1.bsflag = '0'      left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'   left join comm_org_information ion    on ion.org_id = ose.org_id   where tr.bsflag = '0'   "+sql;
 
		if(org_sub_id!=''&&org_sub_id!=null){
			sql = sql+" and tr.org_sub_id = '"+org_sub_id+"'";
		}
		if(second_org!=''&&second_org!=null){
			sql = sql+" and tr.second_org = '"+second_org+"'";
		}
		            
		if(check_unit_org!=''&&check_unit_org!=null){
			sql = sql+" and tr.check_unit_id  like '%"+check_unit_org+"%'";
		}
		if(check_roots_org!=''&&check_roots_org!=null){
			sql = sql+" and tr.check_roots_id  like '%"+check_roots_org+"%'";
		}
		if(check_parts!=''&&check_parts!=null){
			sql = sql+" and tr.check_parts like '%"+check_parts+"%'";
		}
		if(check_type!=''&&check_type!=null){
			sql = sql+" and tr.check_type = '"+check_type+"'";
		}
		if(contact!=''&&contact!=null){
			sql = sql+" and tr.contact like '%"+contact+"%'";
		}
		
		if(leadership_led!=''&&leadership_led!=null){
			sql = sql+" and tr.leadership_led = '"+leadership_led+"'";
		}
		if(led_leadership!=''&&led_leadership!=null){
			sql = sql+" and tr.led_leadership like '%"+led_leadership+"%'";
		}
		if(check_name!=''&&check_name!=null){
			sql = sql+" and tr.check_name like '%"+check_name+"%'";
		}
		
		if(fuHao!=''&&fuHao!=null){
			if(number_problems!=''&&number_problems!=null){
			sql = sql+" and tr.number_problems"+fuHao+"'"+number_problems+"'";
			}
			
		}
		if(check_start_time!=''&&check_start_time!=null){
			sql = sql+" and tr.check_start_time >= to_date('"+check_start_time+"','yyyy-MM-dd')";
		}
		if(check_start_time2!=''&&check_start_time2!=null){
			sql = sql+" and tr.check_start_time <= to_date('"+check_start_time2+"','yyyy-MM-dd')";
		}
		
		if(check_end_time!=''&&check_end_time!=null){
			sql = sql+" and tr.check_end_time >= to_date('"+check_end_time+"','yyyy-MM-dd')";
		}
		if(check_end_time2!=''&&check_end_time2!=null){
			sql = sql+" and tr.check_end_time <= to_date('"+check_end_time2+"','yyyy-MM-dd')";
		}
		 
		sql = sql+" order by tr.modifi_date desc";
 
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
	
	function selectOrgs(){
		  var teamInfo = {
			        fkValue:"",
			        value:""
			    };
	    var check_unit_org = document.getElementById("check_unit_org").value;
	    window.showModalDialog('<%=contextPath%>/hse/hseOptionPage/hseCheck/selectOrgHR.jsp?multi=true&select=orgid',teamInfo);
	    if(teamInfo.fkValue!=""){
	   	 document.getElementById("check_unit_org2").value = teamInfo.fkValue;
	       document.getElementById("check_unit_org").value = teamInfo.value;
	       document.getElementById("check_unit_id").value = teamInfo.fkValue;
	   }
	}

	function selectOrgs2(){
		  var teamInfo = {
			        fkValue:"",
			        value:""
			    };
	  var check_unit_org = document.getElementById("check_roots_org").value;
	  window.showModalDialog('<%=contextPath%>/hse/hseOptionPage/hseCheck/selectOrgHR.jsp?multi=true&select=orgid',teamInfo);
	  if(teamInfo.fkValue!=""){
	 	 document.getElementById("check_roots_org2").value = teamInfo.fkValue;
	 	  document.getElementById("check_roots_id").value = teamInfo.fkValue;
	     document.getElementById("check_roots_org").value = teamInfo.value;
	    
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
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
	      	</td>
	        <td class="inquire_item6">被检查单位：</td>
	      	<td class="inquire_form6">				    
	      	<input type="hidden" id="check_unit_id" name="check_unit_id" class="input_width"    />
	      	<input type="text" id="check_unit_org" name="check_unit_org" class="input_width"    readonly="readonly"/>
	      	<input type="hidden" id="check_unit_org2" name="check_unit_org2" class="input_width"    readonly="readonly"/>
	      	 <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs()"/>
	      	</td>
        </tr> 
        <tr>
        <td class="inquire_item6">被检查基层单位：</td>
      	<td class="inquire_form6">				     
     	<input type="hidden" id="check_roots_id" name="check_roots_id" class="input_width"    />
      	<input type="text" id="check_roots_org" name="check_roots_org" class="input_width"    readonly="readonly"/>
    	<input type="hidden" id="check_roots_org2" name="check_roots_org2" class="input_width"    readonly="readonly"/>
      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrgs2()"/>
      	</td>
      	<td class="inquire_item6">被检查部门/部位：</td>					 
	    <td class="inquire_form6"> 
	    <input type="text" id="check_parts" name="check_parts" class="input_width"   />     </td>	 	  
	    
	    <td class="inquire_item6">检查类别：</td>					 
	    <td class="inquire_form6"> 
	    <select id="check_type" name="check_type" class="select_width"  >
	       <option value="" >请选择</option>
	       <option value="1" >日常检查</option>
	       <option value="2" >专项检查</option>
	       <option value="3" >联系点到位</option>
		</select>   </td>	
		 				    
	    </td>
        </tr>  
         
        <tr>
        <td class="inquire_item6">联系人：</td>
	    <td class="inquire_form6">
	    <input type="text" id="contact" name="contact"    class="input_width"/>
	    </td>	
	    <td class="inquire_item6">领导带队：</td>
	    <td class="inquire_form6"> 
	    <select id="leadership_led" name="leadership_led" class="select_width">
	       <option value="" >请选择</option>
	       <option value="1" >是</option>
	       <option value="2" >否</option>					      
		</select>
	    </td>
	    <td class="inquire_item6">带队领导：</td>
	    <td class="inquire_form6">
	    <input type="text" id="led_leadership" name="led_leadership" class="input_width" />
	    </td>		
	    
        </tr>
        <tr>
        <td class="inquire_item6">检查名称：</td>
	    <td class="inquire_form6"><input type="text" id="check_name" name="check_name" class="input_width"  /></td>
 
	    <td class="inquire_item6">问题数量：</td>
	    <td class="inquire_form6">
	    <select id="fuHao" name="fuHao" class="select_width">
	       <option value="" >请选择</option>
	       <option value=">=" >大于 </option>
	       <option value="<=" >小于</option>			
	       <option value="=" >等于</option>	
		</select>
	   </td>
	    <td class="inquire_item6"><input type="text" id="number_problems" name="number_problems" class="input_width"   /></td>
 
        </tr>
        <tr>
          <td class="">检查开始时间：</td>
		  <td class=""><input type="text" id="check_start_time" name="check_start_time"  style="width:100px;"   readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_start_time,tributton1);" />&nbsp;</td>
		  <td class="" colspan="4" >  &nbsp;&nbsp; 至：&nbsp;&nbsp;  <input type="text" id="check_start_time2" name="check_start_time2"  style="width:100px;"    readonly="readonly"/>&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_start_time2,tributton2);" />&nbsp;</td>
		  </tr>
        <tr>
        <td class="">检查结束时间：</td>
		  <td class=""><input type="text" id="check_end_time" name="check_end_time"   style="width:100px;"    readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_end_time,tributton3);" />&nbsp; </td>
		  <td class="" colspan="4" >  &nbsp;&nbsp; 至：&nbsp;&nbsp;
		     <input type="text" id="check_end_time2" name="check_end_time2"  style="width:100px;"     readonly="readonly"/>&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(check_end_time2,tributton4);" />&nbsp;</td>
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

