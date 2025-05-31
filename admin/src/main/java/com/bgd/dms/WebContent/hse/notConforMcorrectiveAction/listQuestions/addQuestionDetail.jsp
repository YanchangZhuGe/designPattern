<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%> 
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	
	String questions_no="";
	if(request.getParameter("questions_no") != null){
		questions_no=request.getParameter("questions_no");	
		
	}
    String qdetail_no ="";
	if(request.getParameter("qdetail_no") != null){
		qdetail_no=request.getParameter("qdetail_no");	    		
	}
 
 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>w问题描述信息</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

</head>
<body  onload="getHazardBig(); listInfo();exitSelect()" >
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" > 
						<tr>								 
						  <td class="inquire_item6"><font color="red">*</font>体系要素号：</td>
					      	<td class="inquire_form6">
					    	<input type="hidden" id="aa" name="aa" value="" />
					       	<input type="hidden" id="bb" name="bb" value="" />
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					      	<input type="hidden" id="questions_no" name="questions_no"   />
					     	<input type="hidden" id="qdetail_no" name="qdetail_no"   />
					        <select id="system_elements" name="system_elements" class="select_width"  ></select> 	
					      	</td> 
			 		    <td class="inquire_item6">问题类别：</td>
					    <td class="inquire_form6">   
					    <select id="problem_category" name="problem_category" class="select_width">
					       <option value="" >请选择</option>
					       <option value="违章指挥" >违章指挥</option>
					       <option value="违章操作" >违章操作</option>
					       <option value="违反劳动纪律" >违反劳动纪律</option>
					       <option value="监护失误" >监护失误</option>
					       <option value="管理缺陷" >管理缺陷</option>
						</select> 		
					    </td>
					  </tr>		 
						<tr>
						    <td class="inquire_item6">问题性质：</td>  	   
						    <td class="inquire_form6"  align="center" > 
						    <select id="nature" name="nature" class="select_width">
						       <option value="" >请选择</option>
						       <option value="特大" >特大</option>
						       <option value="重大" >重大</option> 
						       <option value="较大" >较大</option>
						       <option value="一般" >一般</option> 
							</select> 	 
						 </tr>	
							 
					     </table>
					  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
					  <tr>
					    <td class="inquire_item6">问题描述：</td> 					   
					    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:450px;" id="problem_des" name="problem_des"   class="textarea" ></textarea></td>
					    <td class="inquire_item6"> </td> 				 
					  </tr>	
					  
					</table>
				</div>
			<div id="oper_div">
				<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
</div>
</div> 
</form>
</body>

<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form';
 var questions_no='<%=questions_no%>';
 var qdetail_no='<%=qdetail_no%>'; 
	function checkJudge(){  
		    var problem_category = document.getElementsByName("problem_category")[0].value;			
		    var system_elements = document.getElementsByName("system_elements")[0].value;		 
		    var nature = document.getElementsByName("nature")[0].value;	 
		if(system_elements==""){
 			alert("体系要素号不能为空，请填写！");
 			return true;
 		} 
 		return false;
 	}
 	
 	
function submitButton(){ 
	if(checkJudge()){
		return;
	}
 
	var rowParams = new Array(); 
		var rowParam = {};			
		var questions_nos = document.getElementsByName("questions_no")[0].value;
		var qdetail_no = document.getElementsByName("qdetail_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;	 
		var bsflag = document.getElementsByName("bsflag")[0].value; 
		var problem_category = document.getElementsByName("problem_category")[0].value;			
		var system_elements = document.getElementsByName("system_elements")[0].value;	 	
		var nature = document.getElementsByName("nature")[0].value;		 
		var problem_des = document.getElementsByName("problem_des")[0].value;
  
		rowParam['problem_category'] = encodeURI(encodeURI(problem_category));
		rowParam['system_elements'] = encodeURI(encodeURI(system_elements));		 
		rowParam['nature'] = encodeURI(encodeURI(nature));
		rowParam['problem_des'] = encodeURI(encodeURI(problem_des));
		
		if(questions_nos!=null && questions_nos !=''){ 
		}else{
			questions_nos=questions_no;
		}
	  if(qdetail_no !=null && qdetail_no !=''){
		    rowParam['questions_no'] = questions_nos;
		    rowParam['qdetail_no'] = qdetail_no;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			
	  }else{
		    rowParam['questions_no'] = questions_nos;
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>'; 
			rowParam['bsflag'] = bsflag;
	  }  				
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_LIST_QUESTIONS_DETAIL",rows);	
		//top.frames('list').getTab3('0');	
		//top.frames('list').frames[0].refreshData();	
		top.frames('list').loadDataDetail(questions_nos);		
		newClose();
}

function afterSave(retObject,successHint,failHint){
	if(successHint==undefined) successHint = '保存成功';
	if(failHint==undefined) failHint = '保存失败';
	if (retObject.returnCode != "0") alert(failHint);
	else{
		alert(successHint);
		//window.opener.refreshData();
		//window.close();
	}
}
 
//得到所有
 
function getHazardBig(){
	var selectObj = document.getElementById("system_elements");  
	document.getElementById("system_elements").innerHTML="";
	selectObj.add(new Option('请选择',""),0);  
	var queryHazardBig=jcdpCallService("HseOperationSrv","queryElements","");	
 
	for(var i=0;i<queryHazardBig.detailInfo.length;i++){
		var templateMap = queryHazardBig.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}   	 
}
 
 


function selectTeam1(){
	
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/rm/em/humanLabor/selectProject.lpmd',teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById("project_id").value = teamInfo.fkValue;
        document.getElementById("project_name").value = teamInfo.value;
    }
}

 
 function exitSelect(){ 
		var selectObj = document.getElementById("system_elements");  
		var aa = document.getElementById("aa").value; 
		var bb = document.getElementById("bb").value;  
	    for(var i = 0; i<selectObj.length; i++){ 
	        if(selectObj.options[i].value == aa){ 
	        	selectObj.options[i].selected = 'selected';     
	        } 
	       }   
 }
 function  listInfo(){
	if(qdetail_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = "  select tr.qdetail_no,      tr.questions_no,     tr.problem_category,  tr.system_elements,   tr.nature,  tr.problem_des,  tr.creator,  tr.create_date,  tr.bsflag    from BGP_LIST_QUESTIONS_DETAIL tr   where tr.bsflag = '0'   and tr.qdetail_no = '"+ qdetail_no +"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){	 
					document.getElementsByName("qdetail_no")[0].value=datas[0].qdetail_no;  
				 	document.getElementsByName("questions_no")[0].value=datas[0].questions_no;  
				 	document.getElementsByName("bsflag")[0].value=datas[0].bsflag; 
	    		 	document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		    document.getElementsByName("creator")[0].value=datas[0].creator;	 
	    			document.getElementsByName("problem_category")[0].value=datas[0].problem_category;			
	    		    document.getElementsByName("system_elements")[0].value=datas[0].system_elements;		
	    		    document.getElementsByName("aa")[0].value=datas[0].system_elements;	     
	    		    document.getElementsByName("problem_des")[0].value=datas[0].problem_des;			
	    		    document.getElementsByName("nature")[0].value=datas[0].nature;	
	    		      
			}					
		
	    	}		
		
	}
 }
</script>
</html>