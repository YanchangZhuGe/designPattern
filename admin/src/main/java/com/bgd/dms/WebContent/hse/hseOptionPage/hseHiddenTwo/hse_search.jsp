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
	function submit(){
		var ctt = top.frames('list');		
		var org_sub_id = document.getElementById("second_org").value;
		var second_org = document.getElementById("third_org").value;
		var third_org = document.getElementById("fourth_org").value; 
		
		var operation_post = document.getElementsByName("operation_post")[0].value;
		var hidden_name = document.getElementsByName("hidden_name")[0].value;		
		var identification_method = document.getElementsByName("identification_method")[0].value;			
		var hazard_big = document.getElementsByName("hazard_big")[0].value;		
		var hazard_center = document.getElementsByName("hazard_center")[0].value;		
		var recognition_people = document.getElementsByName("recognition_people")[0].value;
		
	    var risk_levels=document.getElementsByName("risk_levels")[0].value;		
		var rectification_state=document.getElementsByName("rectification_state")[0].value;	 
		var reward_state= document.getElementsByName("reward_state")[0].value;		
			
		var report_date = document.getElementById("report_date").value;  
		var report_date2 = document.getElementById("report_date2").value;   
 
		var isProject = "<%=isProject%>";
		var sql = ""; 
		if(isProject=="1"){
			sql = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			sql = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "  select tr.* from (select  case when length(tr.hidden_description)<= 35 then tr.hidden_description else concat(substr(tr.hidden_description,0,35),'...') end  hse_hidden_description,tr.project_no, hdl.reward_state,hdl.risk_levels risk_levels_value, cdl.coding_name  risk_levels,nvl(hdl.rectification_state,'2') r_state,decode(hdl.rectification_state ,'1','已整改','2','未整改','3','正在整改')rectification_state,tr.hidden_no,tr.operation_post,tr.hidden_name,tr.identification_method,tr.hazard_big,tr.hazard_center,tr.whether_new,tr.recognition_people,  tr.report_date, tr.hidden_description  ,tr.org_sub_id,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_HSE_HIDDEN_INFORMATION tr       left join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left  join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id  left join BGP_HIDDEN_INFORMATION_DETAIL hdl  on hdl.hidden_no=tr.hidden_no and hdl.bsflag='0'  left join comm_coding_sort_detail cdl on  cdl.coding_code_id=hdl.risk_levels  and cdl.bsflag='0'   )tr  where tr.bsflag = '0'    "+sql;
 
		if(org_sub_id!=''&&org_sub_id!=null){
			sql = sql+" and tr.org_sub_id = '"+org_sub_id+"'";
		}
		if(second_org!=''&&second_org!=null){
			sql = sql+" and tr.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and tr.third_org = '"+third_org+"'";
		}
		if(operation_post!=''&&operation_post!=null){
			sql = sql+" and tr.operation_post  like '%"+operation_post+"%'";
		}
		if( hidden_name!=''&& hidden_name!=null){
			sql = sql+" and tr.hidden_description like '%"+hidden_name +"%'";
		}
 
		if( identification_method!=''&& identification_method!=null){
			sql = sql+" and tr.identification_method  = '"+ identification_method+"'";
		}
		if( hazard_big!=''&& hazard_big!=null){
			sql = sql+" and tr.hazard_big  = '"+hazard_big +"'";
		}
		if( hazard_center!=''&& hazard_center!=null){
			sql = sql+" and tr.hazard_center  = '"+hazard_center +"'";
		}
		if( recognition_people!=''&& recognition_people!=null){
			sql = sql+" and tr.recognition_people  = '"+recognition_people +"'";
		}
		
		if( risk_levels!=''&& risk_levels!=null){
			sql = sql+" and tr.risk_levels_value  = '"+risk_levels +"'";
		}
		if( rectification_state!=''&& rectification_state!=null){
			sql = sql+" and tr.r_state  = '"+rectification_state +"'";
		}
		 
		if( reward_state!=''&& reward_state!=null){
			sql = sql+" and tr.reward_state  = '"+reward_state +"'";
		}
		 
 
		if(report_date!=''&&report_date!=null){
			sql = sql+" and tr.report_date >= to_date('"+report_date+"','yyyy-MM-dd')";
		}
		if(report_date2!=''&&report_date2!=null){
			sql = sql+" and tr.report_date <= to_date('"+report_date2+"','yyyy-MM-dd')";
		}
		 
		sql = sql+" order by tr.r_state desc";
 
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
	
 
	 
	function getHazardBig(){
		var selectObj = document.getElementById("hazard_big"); 
		document.getElementById("hazard_big").innerHTML="";
		selectObj.add(new Option('请选择',""),0);

		var queryHazardBig=jcdpCallService("HseOperationSrv","queryHazardBig","");	
	 
		for(var i=0;i<queryHazardBig.detailInfo.length;i++){
			var templateMap = queryHazardBig.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}   	
		var selectObj1 = document.getElementById("hazard_center");
		document.getElementById("hazard_center").innerHTML="";
		selectObj1.add(new Option('请选择',""),0);
	}

	function getHazardCenter(){
	    var hazardBig = "hazardBig="+document.getElementById("hazard_big").value;   
		var HazardCenter=jcdpCallService("HseOperationSrv","queryHazardCenter",hazardBig);	

		var selectObj = document.getElementById("hazard_center");
		document.getElementById("hazard_center").innerHTML="";
		selectObj.add(new Option('请选择',""),0);
		if(HazardCenter.detailInfo!=null){
			for(var i=0;i<HazardCenter.detailInfo.length;i++){
				var templateMap = HazardCenter.detailInfo[i];
				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
			}
		}
	}
	function getRiskLevels(){
		var selectObj = document.getElementById("risk_levels"); 
		document.getElementById("risk_levels").innerHTML="";
		selectObj.add(new Option('请选择',""),0);

		var queryHazardBig=jcdpCallService("HseOperationSrv","queryRiskLevels","");	
	 
		for(var i=0;i<queryHazardBig.detailInfo.length;i++){
			var templateMap = queryHazardBig.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}   	
		 
	}
	
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3" onload="getHazardBig();getRiskLevels();" >
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
	     	<td class="inquire_item6">下属单位：</td>
	      	<td class="inquire_form6">
	      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
	      	<input type="text" id="fourth_org2" name="fourth_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
	      	</td>
        </tr>
        <tr>
	        <td class="inquire_item6"> 作业场所/岗位：</td>
		    <td class="inquire_form6">
		    <input type="text" id="operation_post" name="operation_post" class="input_width"   />    					    
		    </td>	
		    <td class="inquire_item6">隐患描述：</td>
		    <td class="inquire_form6"><input type="text" id="hidden_name" name="hidden_name" class="input_width"    /></td>					 
		    <td class="inquire_item6"> 识别方式：</td>
		    <td class="inquire_form6">  
		    <select id="identification_method" name="identification_method" class="select_width">
		       <option value="" >请选择</option>
		       <option value="1" >集中识别</option>
		       <option value="2" >随机识别</option>
		       <option value="3" >专项识别</option>
		       <option value="4" >来访者识别</option>
		       <option value="5" >安全观察与沟通</option>
		       <option value="6" >工作安全分析</option>
		       <option value="7" >工艺安全分析等</option>
		       <option value="8" >其它</option>
			</select> 		
		    </td>
        </tr>     
        
        <tr>
		    <td class="inquire_item6">隐患危害类型（大类）：</td> 					   
		    <td class="inquire_form6"  align="center" > 
		    <select id="hazard_big" name="hazard_big" class="select_width" onchange="getHazardCenter()"></select> 	
		    </td>
		    <td class="inquire_item6">隐患危害类型（小类）：</td>
		    <td class="inquire_form6"> 
		    <select id="hazard_center" name="hazard_center" class="select_width">
			</select> 			
		    </td>
		    <td class="inquire_item6"> 识别人：</td>
		    <td class="inquire_form6"> 
		    <input type="text" id="recognition_people" name="recognition_people" class="input_width"   />    		
		    </td>
	    </tr>	
	    <tr>
		    <td class="inquire_item6">风险等级：</td> 					   
		    <td class="inquire_form6"  align="center" > 
		    <select id="risk_levels" name="risk_levels" class="select_width">
 
			</select> 	
		    </td>		    
		    <td class="inquire_item6">整改状态：</td>
		    <td class="inquire_form6">
		    <select id="rectification_state" name="rectification_state" class="select_width">
		       <option value="" >请选择</option>
		       <option value="1" >已整改</option>
		       <option value="2" >未整改</option> 
		       <option value="3" >正在整改</option>  
			</select> 
		    </td>	 	 
		    <td class="inquire_item6"> 奖励状态：</td> 					   
		    <td class="inquire_form6"  align="center" > 
		    <select id="reward_state" name="reward_state" class="select_width">
		       <option value="" >请选择</option>
		       <option value="已奖励" >已奖励</option>
		       <option value="未奖励" >未奖励</option> 
			</select> 		    
		    </td>		    
	    </tr>	
	    
        <tr>
          <td class="inquire_item6">上报日期：</td>
		  <td class="inquire_form6"><input type="text" id="report_date" name="report_date" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(report_date,tributton1);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="report_date2" name="report_date2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(report_date2,tributton2);" />&nbsp;</td>
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

