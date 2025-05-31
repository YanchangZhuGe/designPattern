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
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	 String projectInfoNo ="";
 	if(request.getParameter("projectInfoNo") != null){
 		projectInfoNo=request.getParameter("projectInfoNo");	    		
 	}
	
	String facilities_no="";
	if(request.getParameter("facilities_no") != null){
		facilities_no=request.getParameter("facilities_no");	
		
	}
 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>设备设施台账</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
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
<body  onload="queryOrg();pageInit();getEquipmentOne();listInfo();exitSelect();" >
<form name="form" id="form"  method="post" action="" >
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
					  <tr>						   
						  <td class="inquire_item6">单位：</td>
				        	<td class="inquire_form6">
				        	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />					     
					      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
				        	<%} %>
				        	</td>
				          	<td class="inquire_item6">基层单位：</td>
				        	<td class="inquire_form6">
				        	 <input type="hidden" id="second_org" name="second_org" class="input_width" />
					    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
				        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
				        	<%} %>
				        	</td>    	  
					  </tr>					  
						<tr>								 
						  <td class="inquire_item6"><font color="red">*</font>设备设施名称：</td>
					      	<td class="inquire_form6">
					    	<input type="hidden" id="aa" name="aa" value="" />
					       	<input type="hidden" id="bb" name="bb" value="" />
					    	<input type="hidden" id="project_no" name="project_no" value="" />
				 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
					      	<input type="hidden" id="create_date" name="create_date" value="" />
					      	<input type="hidden" id="creator" name="creator" value="" />
					      	<input type="hidden" id="facilities_no" name="facilities_no"   />
					     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
					      	<input type="hidden" id="third_org2" name="third_org2" class="input_width"   />
					      
						    <input type="text" id="facilities_name" name="facilities_name" class="input_width"   />    	
						    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" readonly="readonly" onclick="showDevTreePage()"  />
						    </td>			
						    
						    <td class="inquire_item6">牌照号：</td>
						    <td class="inquire_form6"> 
						    <input type="text" id="paizhaohao" name="paizhaohao" class="input_width"   />    		
						    </td>
						</tr>						
					  <tr>	
					    <td class="inquire_item6">规格型号：</td>
					    <td class="inquire_form6"><input type="text" id="specifications" name="specifications"  readonly="readonly" class="input_width"    /></td>					 
					    <td class="inquire_item6">使用状况：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <select id="use_situation" name="use_situation" class="select_width" onchange="selectUse()" > 
						</select> 	
					    </td>  
					   </tr>		 
					
						  <tr> 
						    <td class="inquire_item6">技术状况：</td>
						    <td class="inquire_form6">  
						    <select id="technical_conditions" name="technical_conditions" class="select_width" >
							</select> 		
						    </td>
						    <td class="inquire_item6">出厂日期：</td> 					   
						    <td class="inquire_form6"  align="center" > 
						    <input type="text" id="release_date" name="release_date" class="input_width"    readonly="readonly" />
						    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(release_date,tributton1);" />&nbsp;</td>
						  </tr>	
						  <tr> 
				
							    <td class="inquire_item6"><font color="red">*</font>设备设施类别一：</td> 					   
							    <td class="inquire_form6"  align="center" > 
							    <select id="equipment_one" name="equipment_one" class="select_width" onchange="getEquipmentTwo()"></select> 	
							    </td>
							 
							    <td class="inquire_item6"><font color="red">*</font>设备设施类别二：</td>
							    <td class="inquire_form6"> 
							    <select id="equipment_two" name="equipment_two" class="select_width">
								</select> 			
							    </td>
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
 var facilities_no='<%=facilities_no%>';
 var projectInfoNo='<%=projectInfoNo%>';
 
 function pageInit(){ 
		//通过查询结果动态填充使用情况select;     use_situation  technical_conditions
		var querySql="select * from comm_coding_sort_detail where coding_sort_id='0110000007' and bsflag='0'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		usingdatas = queryRet.datas; 
		if(usingdatas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				document.getElementById("use_situation").options.add(new Option(usingdatas[i].coding_name,usingdatas[i].coding_code_id)); 
			}
		}
		//技术状况默认完好
		document.getElementById("technical_conditions").options.add(new Option("完好","0110000006000000001"));
	}
 
   /**
	 * 使用情况下拉框变化事件，技术状况跟使用情况有关联
	 */
	function selectUse(){
		document.getElementById("technical_conditions").options.length=0;
		if(document.getElementById("use_situation").value=='0110000007000000001' || document.getElementById("use_situation").value=='0110000007000000002')
		{
			document.getElementById("technical_conditions").options.add(new Option("完好","0110000006000000001"));
		}
		else{
			document.getElementById("technical_conditions").options.add(new Option("待报废","0110000006000000005"));
			document.getElementById("technical_conditions").options.add(new Option("待修","0110000006000000006"));
			document.getElementById("technical_conditions").options.add(new Option("在修","0110000006000000007"));
			document.getElementById("technical_conditions").options.add(new Option("验收","0110000006000000013"));
		}
	}
	
//键盘上只有删除键，和左右键好用
 function noEdit(event){
 	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
 		return true;
 	}else{
 		return false;
 	}
 }

 	function queryOrg(){
 		if(facilities_no!=null && facilities_no!=""){
 		 	
 		}else{
	 		retObj = jcdpCallService("HseSrv", "queryOrg", "");
	 		if(retObj.flag=="true"){
	 			var len = retObj.list.length;
	 			if(len>0){
	 				document.getElementById("org_sub_id").value=retObj.list[0].orgSubId;
	 				document.getElementById("org_sub_id2").value=retObj.list[0].orgAbbreviation;
	 			}
	 			if(len>1){
	 				document.getElementById("second_org").value=retObj.list[1].orgSubId;
	 				document.getElementById("second_org2").value=retObj.list[1].orgAbbreviation;
	 			}
	 			if(len>2){
	 				document.getElementById("third_org").value=retObj.list[2].orgSubId;
	 				document.getElementById("third_org2").value=retObj.list[2].orgAbbreviation;
	 			}
	 		}
 		
 		}
 	}

 	/**
	 * 选择设备树
	**/
	function showDevTreePage(){
		//window.open("<%=contextPath%>/rm/dm/deviceAccount/selectOrg.jsp","test",'toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no,depended=no')
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTreeForSubNode.jsp","test","");
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var name = names[1].split("(")[0];
		var model = names[1].split("(")[1].split(")")[0];
		//alert(returnValue);
		document.getElementById("facilities_name").value = name;
		document.getElementById("specifications").value = model; 
	}
	 
	function checkJudge(){
 		var org_sub_id = document.getElementsByName("org_sub_id2")[0].value;
		var second_org = document.getElementsByName("second_org2")[0].value;			
		var third_org = document.getElementsByName("third_org2")[0].value;			
		
		var facilities_name = document.getElementsByName("facilities_name")[0].value;
		var equipment_one = document.getElementsByName("equipment_one")[0].value;		
		var equipment_two = document.getElementsByName("equipment_two")[0].value;
		
 		if(org_sub_id==""){
 			document.getElementById("org_sub_id").value = "";
 		}
 		if(second_org==""){
 			document.getElementById("second_org").value="";
 		}
 		if(third_org==""){
 			document.getElementById("third_org").value="";
 		}
 		if(facilities_name==""){
 			alert("设备设施名称不能为空，请填写！");
 			return true;
 		}
 		if(equipment_one==""){
 			alert("设备设施类别一不能为空，请选择！");
 			return true;
 		}
 		if(equipment_two==""){
 			alert("设备设施类别二不能为空，请填写！");
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
		var facilities_no = document.getElementsByName("facilities_no")[0].value;
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;		
		var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
		var bsflag = document.getElementsByName("bsflag")[0].value;
		var second_org = document.getElementsByName("second_org")[0].value;			
		var third_org = document.getElementsByName("third_org")[0].value;			
		
		var facilities_name = document.getElementsByName("facilities_name")[0].value;
		var specifications = document.getElementsByName("specifications")[0].value;		
		var technical_conditions = document.getElementsByName("technical_conditions")[0].value;			
		var equipment_one = document.getElementsByName("equipment_one")[0].value;		
		var equipment_two = document.getElementsByName("equipment_two")[0].value;		
		var use_situation = document.getElementsByName("use_situation")[0].value;	 
		var release_date = document.getElementsByName("release_date")[0].value;
		var paizhaohao = document.getElementsByName("paizhaohao")[0].value;		
		var project_no = document.getElementsByName("project_no")[0].value;		
		
		
  
		rowParam['org_sub_id'] = org_sub_id;
		rowParam['second_org'] = second_org;
		rowParam['third_org'] = third_org;			
		
		rowParam['facilities_name'] = encodeURI(encodeURI(facilities_name));
		rowParam['specifications'] = encodeURI(encodeURI(specifications));
		rowParam['technical_conditions'] = encodeURI(encodeURI(technical_conditions));
		rowParam['equipment_one'] = encodeURI(encodeURI(equipment_one));		 		
		rowParam['equipment_two'] = encodeURI(encodeURI(equipment_two));
		rowParam['use_situation'] = encodeURI(encodeURI(use_situation)); 
		rowParam['release_date'] = encodeURI(encodeURI(release_date)); 
		rowParam['paizhaohao'] = encodeURI(encodeURI(paizhaohao));
 
	  if(facilities_no !=null && facilities_no !=''){
		  if(project_no !=null && project_no !='' ){
				rowParam['project_no'] =project_no;	
			}else{
				rowParam['project_no'] ='<%=projectInfoNo%>';
			}
		  
		    rowParam['facilities_no'] = facilities_no;
			rowParam['creator'] = encodeURI(encodeURI(creator));
			rowParam['create_date'] =create_date;
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			rowParam['spare1'] = '2';
	  }else{
		    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
			rowParam['create_date'] ='<%=curDate%>';
			rowParam['modifi_date'] = '<%=curDate%>';		
			rowParam['bsflag'] = bsflag;
			rowParam['spare1'] = '2';
			rowParam['project_no'] ='<%=projectInfoNo%>';
	  }  				
  
		rowParams[rowParams.length] = rowParam; 
		var rows=JSON.stringify(rowParams);	 
		saveFunc("BGP_FACILITIES_STANDBOOK",rows);	
		top.frames('list').refreshData();	
		newClose();
	
}
 
//得到所有
 
function getEquipmentOne(){
	var selectObj = document.getElementById("equipment_one"); 
	document.getElementById("equipment_one").innerHTML="";
	selectObj.add(new Option('请选择',""),0);

	var queryEquipmentOne=jcdpCallService("HseOperationSrv","queryeQuipmentOne","");	
 
	for(var i=0;i<queryEquipmentOne.detailInfo.length;i++){
		var templateMap = queryEquipmentOne.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}   	
	var selectObj1 = document.getElementById("equipment_two");
	document.getElementById("equipment_two").innerHTML="";
	selectObj1.add(new Option('请选择',""),0);
}

function getEquipmentTwo(){
    var EquipmentOne = "equipmentOne="+document.getElementById("equipment_one").value;   
	var EquipmentTwo=jcdpCallService("HseOperationSrv","queryQuipmentTwo",EquipmentOne);	

	var selectObj = document.getElementById("equipment_two");
	document.getElementById("equipment_two").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	if(EquipmentTwo.detailInfo!=null){
		for(var i=0;i<EquipmentTwo.detailInfo.length;i++){
			var templateMap = EquipmentTwo.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}
	}
}

 

function selectOrg(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
    if(teamInfo.fkValue!=""){
    	document.getElementById("org_sub_id").value = teamInfo.fkValue;
        document.getElementById("org_sub_id2").value = teamInfo.value;
    }
}

function selectOrg2(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var second = document.getElementById("org_sub_id").value;
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
		    	 document.getElementById("second_org").value = teamInfo.fkValue; 
		        document.getElementById("second_org2").value = teamInfo.value;
			}
   
}

function selectOrg3(){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    var third = document.getElementById("second_org").value;
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
		    	 document.getElementById("third_org").value = teamInfo.fkValue;
		        document.getElementById("third_org2").value = teamInfo.value;
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

function checkText0(){
	var second_org=document.getElementById("second_org").value;
	 
	if(second_org==""){
		alert("二级单位不能为空，请填写！");
		return true;
	}
	 
	var re = /^[0-9]+\.?[0-9]*$/;   //判断字符串是否为数字     //判断正整数 /^[1-9]+[0-9]*]*$/  

    if (!re.test(second_org))
   {
       alert("初步估计经济损失请输入数字！");
       return true;
    }
	return false;
}
 function exitSelect(){ 
		var selectObj = document.getElementById("equipment_one");  
		var aa = document.getElementById("aa").value; 
		var bb = document.getElementById("bb").value;  
	    for(var i = 0; i<selectObj.length; i++){ 
	        if(selectObj.options[i].value == aa){ 
	        	selectObj.options[i].selected = 'selected';     
	        } 
	       }  
	    var EquipmentOne = "equipmentOne="+ document.getElementById("aa").value;
	    var EquipmentTwo=jcdpCallService("HseOperationSrv","queryQuipmentTwo",EquipmentOne);		 
		var selectObj2 = document.getElementById("equipment_two");
		document.getElementById("equipment_two").innerHTML="";
		selectObj2.add(new Option('请选择',""),0);

		if(EquipmentTwo.detailInfo!=null){
			for(var t=0;t<EquipmentTwo.detailInfo.length;t++){
				var templateMap = EquipmentTwo.detailInfo[t];
				selectObj2.add(new Option(templateMap.label,templateMap.value),t+1);
			}
		}
	    for(var j = 0; j<selectObj2.length; j++){ 
	        if(selectObj2.options[j].value == bb){ 
	        	selectObj2.options[j].selected = 'selected';     
	        } 
	       }  
	     
 }
 function  listInfo(){
	if(facilities_no !=null){
		var querySql = "";
		var queryRet = null;
		var  datas =null;		
		
		querySql = "   select  tr.project_no, tr.org_sub_id,tr.facilities_no,tr.facilities_name,tr.specifications,tr.technical_conditions,tr.use_situation,tr.release_date,tr.paizhaohao,tr.equipment_one,tr.equipment_two ,tr.second_org,tr.third_org,ion.org_abbreviation as org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_FACILITIES_STANDBOOK tr     left   join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'  left  join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   left join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   left join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  left join comm_org_information ion    on ion.org_id = ose.org_id      where tr.bsflag = '0' and tr.facilities_no='"+ facilities_no +"'";				 	 
		queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(queryRet.returnCode=='0'){
			datas = queryRet.datas;
			if(datas != null){				 
				 document.getElementsByName("facilities_no")[0].value=datas[0].facilities_no; 
	    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
	    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
	    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
	    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
	    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
	    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
	    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
	  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
	    		 document.getElementsByName("creator")[0].value=datas[0].creator;	
	    	 	
	    		     document.getElementsByName("equipment_one")[0].value=datas[0].equipment_one;		
	    		     document.getElementsByName("aa")[0].value=datas[0].equipment_one;	    		    
	    			 document.getElementsByName("equipment_two")[0].value=datas[0].equipment_two;	
	    			 document.getElementsByName("bb")[0].value=datas[0].equipment_two;	
	    	 	
	    			 document.getElementsByName("facilities_name")[0].value=datas[0].facilities_name;
	    			 document.getElementsByName("specifications")[0].value=datas[0].specifications;		
	    		 	 document.getElementsByName("technical_conditions")[0].value=datas[0].technical_conditions;	 
	    			 document.getElementsByName("use_situation")[0].value=datas[0].use_situation;	 
	    			 document.getElementsByName("release_date")[0].value=datas[0].release_date;
	    			 document.getElementsByName("paizhaohao")[0].value=datas[0].paizhaohao;		
	    			   document.getElementsByName("project_no")[0].value=datas[0].project_no;		
	    			      
	    			 selectUse();
			}					
		
	    	}		
		
	}
 }
</script>
</html>