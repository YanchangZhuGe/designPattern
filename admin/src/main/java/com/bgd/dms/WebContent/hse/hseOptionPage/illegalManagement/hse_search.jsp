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
 
		var sites_post = document.getElementById("sites_post").value;   
		var   hazard_center= document.getElementById("hazard_center").value; 
		var   staff_name= document.getElementById("staff_name").value;
		var   illegal_level= document.getElementById("illegal_level").value;
		var   found_way= document.getElementById("found_way").value;
		var   process_level= document.getElementById("process_level").value;
		var  process_mode = document.getElementById("process_mode").value;
		var  administrative_process = document.getElementById("administrative_process").value;
		var   fine_amount= document.getElementById("fine_amount").value; 
		
		var violation_time = document.getElementById("violation_time").value;  
		var violation_time2 = document.getElementById("violation_time2").value;   
 
		var isProject = "<%=isProject%>";
		var sql = ""; 
		if(isProject=="1"){
			sql = getMultipleSql2("tr.");
		}else if(isProject=="2"){
			sql = "and tr.project_no='<%=user.getProjectInfoNo()%>'";
		}
		
		var sql = "  select decode(tr.process_mode,'1','行政处理','2','经济处罚','3','行政处理+经济处罚') process_mode,cdl.coding_name, decode(tr.administrative_process,'1','警告','2','记过','3','记大过','4','降级','5','降职','6','撤职','7','留用察看','8','开除')a_process,decode(tr.illegal_level,'0','特大','1','重大','2','较大','3','一般')illegal_lname, tr.org_sub_id,tr.illegal_no,tr.sites_post,tr.hazard_class,tr.staff_name,tr.illegal_post,tr.illeagl_code,tr.illeagl_personnel_level,tr.lllegal_description,tr.illegal_level,tr.found_way  ,tr.process_level,tr.process_time,tr.administrative_process,tr.fine_amount,tr.process_state ,tr.violation_time,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.bsflag,  oi1.org_abbreviation as second_org_name,oi2.org_abbreviation as third_org_name  from BGP_ILLEGAL_MANAGEMENT tr left  join comm_org_subjection os1 on tr.second_org = os1.org_subjection_id and os1.bsflag = '0' left join comm_org_information oi1 on oi1.org_id = os1.org_id and oi1.bsflag = '0'  left  join comm_org_subjection os2 on tr.third_org = os2.org_subjection_id and os2.bsflag = '0' left join comm_org_information oi2 on oi2.org_id = os2.org_id and oi2.bsflag = '0' left join comm_org_subjection ose on tr.org_sub_id = ose.org_subjection_id and ose.bsflag = '0' left join comm_org_information ion on ion.org_id = ose.org_id left join comm_coding_sort_detail cdl on cdl.coding_code_id=tr.hazard_class and cdl.bsflag='0'   where tr.bsflag='0'   "+sql;
 
		if(org_sub_id!=''&&org_sub_id!=null){
			sql = sql+" and tr.org_sub_id = '"+org_sub_id+"'";
		}
		if(second_org!=''&&second_org!=null){
			sql = sql+" and tr.second_org = '"+second_org+"'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and tr.third_org = '"+third_org+"'";
		}
		           
		
		if( sites_post!=''&& sites_post!=null){
			sql = sql+" and tr.sites_post like '%"+sites_post+"%'";
		}
		if( hazard_center!=''&& hazard_center!=null){
			sql = sql+" and tr.hazard_center = '"+hazard_center+"'";
		}
		if( staff_name!=''&& staff_name!=null){
			sql = sql+" and tr.staff_name like '%"+staff_name+"%'";
		}
		if( illegal_level!=''&& illegal_level!=null){
			sql = sql+" and tr.illegal_level = '"+illegal_level+"'";
		}
		if( found_way!=''&& found_way!=null){
			sql = sql+" and tr.found_way = '"+found_way+"'";
		}
		if( process_level!=''&& process_level!=null){
			sql = sql+" and tr.process_level = '"+process_level+"'";
		}
		if( process_mode!=''&& process_mode!=null){
			sql = sql+" and tr.process_mode = '"+process_mode+"'";
		}
		if( administrative_process!=''&& administrative_process!=null){
			sql = sql+" and tr.administrative_process = '"+administrative_process+"'";
		}
		if( fine_amount!=''&& fine_amount!=null){
			sql = sql+" and tr.fine_amount = '"+fine_amount+"'";
		}
		 
		
		if(violation_time!=''&&violation_time!=null){
			sql = sql+" and tr.violation_time >= to_date('"+violation_time+"','yyyy-MM-dd')";
		}
		if(violation_time2!=''&&violation_time2!=null){
			sql = sql+" and tr.violation_time <= to_date('"+violation_time2+"','yyyy-MM-dd')";
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
	
	 
	function getHazardCenter(){
	    var hazardBig = "hazardBig="+"5110000032000000003";   
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

	
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3"  onload="getHazardCenter();" >
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
	        <td class="inquire_item6">作业场所/岗位：</td>
		    <td class="inquire_form6">
		    <input type="text" id="sites_post" name="sites_post" class="input_width"   />    					    
		    </td>	  
		    <td class="inquire_item6">隐患危害类型：</td>
		    <td class="inquire_form6"> <select id="hazard_center" name="hazard_center" class="select_width"></td>		 
     	     <td class="inquire_item6">违章人员姓名：</td>
		    <td class="inquire_form6">  
		    <input type="text" id="staff_name" name="staff_name" class="input_width"    />
		    </td>	 
        </tr>    
  	  <tr>
        <td class="inquire_item6">违章级别：</td> 					   
	    <td class="inquire_form6"  align="center" >   
	    <select id="illegal_level" name="illegal_level" class="select_width">
	       <option value="" >请选择</option>
	       <option value="0" >特大</option>
	       <option value="1" >重大</option>
	       <option value="2" >较大</option> 
	       <option value="3" >一般</option> 
		</select> 	
	    </td>  
		  <td class="inquire_item6">发现方式：</td>
		    <td class="inquire_form6"> 
		    <select id="found_way" name="found_way" class="select_width">
		       <option value="" >请选择</option>
		       <option value="1" >安全检查</option>
		       <option value="2" >员工举报</option> 
		       <option value="3" >其他</option> 
			</select> 		
		    </td>
		    <td class="inquire_item6">处理级别：</td>
		    <td class="inquire_form6" >	
		    <select id="process_level" name="process_level" class="select_width">
		       <option value="" >请选择</option>
		       <option value="1" >公司</option>
		       <option value="2" >二级单位</option> 
		       <option value="3" >基层单位</option> 
		       <option value="4" >基层单位下属单位</option> 
			</select> 
		    </td>	 
		    </tr>	
		  	  <tr>
			    <td class="inquire_item6">处理方式：</td>
			    <td class="inquire_form6"><select id="process_mode" name="process_mode" onchange="selectChang()" class="select_width">
			       <option value="" >请选择</option>
			       <option value="1" >行政处理</option>
			       <option value="2" >经济处罚</option> 
			       <option value="3" >行政处理+经济处罚</option> 
				</select> 
			    </td>	
			    <td class="inquire_item6">行政处理： </td>
			    <td class="inquire_form6" >	 
			    <select id="administrative_process" name="administrative_process" class="select_width">
			       <option value="" >请选择</option>
			       <option value="1" >警告</option>
			       <option value="2" >记过</option> 
			       <option value="3" >记大过</option> 
			       <option value="4" >降级</option>
			       <option value="5" >降职</option> 
			       <option value="6" >撤职</option> 
			       <option value="7" >留用察看</option>  
			       <option value="8" >开除</option> 
				</select>  
			    </td>
			    <td class="inquire_item6">罚款金额(元)：</td> 					   
			    <td class="inquire_form6"  align="center" >  
			    <input type="text" id="fine_amount" name="fine_amount" class="input_width"  /> 
			    </td> 
		    </tr>	
		
        <tr>
          <td class="inquire_item6">违章时间：</td>
		  <td class="inquire_form6"><input type="text" id="violation_time" name="violation_time" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(violation_time,tributton1);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="violation_time2" name="violation_time2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(violation_time2,tributton2);" />&nbsp;</td>
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

