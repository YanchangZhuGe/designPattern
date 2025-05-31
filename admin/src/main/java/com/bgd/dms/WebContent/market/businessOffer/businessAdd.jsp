<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="code" prefix="code"%> 
<%
	String contextPath = request.getContextPath(); 
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
 
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	
	String orgSubId = request.getParameter("orgSubId");	 
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
	
	String virtualproject_id_s="";
	if(request.getParameter("virtualproject_id_s") != null){
		virtualproject_id_s=request.getParameter("virtualproject_id_s");	
		
	}
	String id = request.getParameter("id"); 
	if(id!= null){
      if(virtualproject_id_s.equals("")){
    	  virtualproject_id_s=id;
      } 
	}
 
%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>新建项目</title>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>


</head>
<body  onload="getSurfaceType(); listInfo();exitSelect();" >
<form name="form" id="form"  method="post" action="" >
<input type="hidden" id="virtualproject_id_s" name="virtualproject_id_s" value="<%=virtualproject_id_s %>"/>
 
<div id="new_table_box">
	<div id="new_table_box_content">
    	<div id="new_table_box_bg">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style="margin-top: 10px;">
				<tr>
			     	<td class="inquire_item6"><font color="red">*</font>项目名称：</td>
			      	<td class="inquire_form6">
			      	<input type="text" id="project_name" name="project_name" class="input_width" style="color:gray;" />
			     	<input type="hidden" id="bsflag" name="bsflag" value="0" />
			      	<input type="hidden" id="create_date" name="create_date" value="" />
			      	<input type="hidden" id="creator" name="creator" value="" />
			      	
			      	</td>
			     	<td class="inquire_item6"><font color="red">*</font>甲方单位：</td>
			      	<td class="inquire_form6">
			      	<input type="text" id="jiafang" name="jiafang" class="input_width"  style="color:gray;" />
			      	<input type="hidden" id="jiafang_org" name="jiafang_org" class="input_width" readOnly="readonly"/>
		 
			    	<img src="<%= request.getContextPath() %>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectCoding('0100100014','jiafang_org','jiafang');" />
		
			      	</td>
			      	<td class="inquire_item6">区域划分：</td>
			      	<td class="inquire_form6">
			      	<input type="text" id="c_team" name="c_team" class="input_width" style="color:gray;"  />
			    	<input id="c_team_id" name="c_team_id" value="" type="hidden" class="input_width" />

					&nbsp;&nbsp;<img src="<%=contextPath%>/images/magnifier.gif" style="cursor:hand;" border="0" onclick="selectTeam()" />
			
			      	</td>
			     </tr>
				 <tr>
			     	<td class="inquire_item6">地表类型：</td>
			      	<td class="inquire_form6">
			      	<input type="hidden" id="aa" name="aa" value=""  />
			      	<select id="surface_type" name="surface_type" class="select_width" style="color:gray;"  > 
					</select>
			      	</td>
			    	<td class="inquire_item6"><font color="red">*</font>招标时间：</td>
			      	<td class="inquire_form6"><input type="text" style="color:gray;"  id="bidding_time" name="bidding_time" class="input_width"    readonly="readonly"/>
			      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(bidding_time,tributton1);" />&nbsp;</td>
			      	<td class="inquire_item6"><font color="red">*</font>投标时间：</td>
			      	<td class="inquire_form6"><input type="text" style="color:gray;"   id="bid_time" name="bid_time" class="input_width"    readonly="readonly"/>
			      	&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(bid_time,tributton2);" />&nbsp;</td>
			      	</tr>
			        <tr> 
		      		<td class="inquire_item6"><font color="red">*</font>项目成本预算：</td>
		      		<td class="inquire_form6">
		      	 	<input type="text" id="cost_budget" name="cost_budget" class="input_width"  onblur="calculateCost()" />
		      		</td>
		    		<td class="inquire_item6"><font color="red">*</font>项目利润比例：</td>
		      		<td class="inquire_form6"><input type="text" id="profit_share" name="profit_share" class="input_width"  onblur="calculateCost()" />&nbsp;(%)
		     
	    		   <td class="inquire_item6">项目投标价格：</td>
	      		   <td class="inquire_form6"><input type="text" id="bid_price" name="bid_price" class="input_width"     readonly="readonly"/>
	      		 
	             </tr>  
			</table>
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >	
			  <tr>
			    <td class="inquire_item6"> 备注：</td> 					   
			    <td class="inquire_form6" colspan="5" align="center" ><textarea  style="width:450px; height:80px;" id="note_s" name="note_s"   class="textarea" ></textarea></td>
			    <td class="inquire_item6"> </td> 				 
			  </tr>		
			</table>
			
		</div>
		<% 
		   String buttonView = request.getParameter("buttonView");
		   if("true".equals(buttonView)){
		%>
		
		<div id="oper_div">
			<span class="tj_btn"><a href="#" onclick="submitButton()"></a></span>
			<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
		</div>
		
		 <%} %>
	</div>
</div> 
</form>
</body>

<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";
cruConfig.cdtType = 'form'; 
var virtualproject_ids = '<%=virtualproject_id_s%>'; 
 
	function submitButton(){ 
		if(checkText0()){
			return;
		}
		var rowParams = new Array(); 
		var rowParam = {};		
		
		var virtualproject_id_s=document.getElementById("virtualproject_id_s").value;
		
		var cost_budget=document.getElementById("cost_budget").value;
		var profit_share=document.getElementById("profit_share").value;
		var bid_price=document.getElementById("bid_price").value;
		var note_s=document.getElementById("note_s").value;
  
	
		var create_date = document.getElementsByName("create_date")[0].value;
		var creator = document.getElementsByName("creator")[0].value;		
		var bsflag = document.getElementsByName("bsflag")[0].value;
 
		 if(virtualproject_ids !=null && virtualproject_ids !=''){
			 
			    rowParam['virtualproject_id_s'] = virtualproject_id_s;
			     
			    rowParam['note_s'] = encodeURI(encodeURI(note_s));
			    rowParam['cost_budget'] =cost_budget;
			    rowParam['profit_share'] =profit_share;
			    rowParam['bid_price'] =bid_price;
			    
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';	
				rowParam['second_org'] = '<%=orgSubId%>';
				rowParam['bsflag'] = bsflag; 
				 
		  }else{
			    rowParam['note_s'] = encodeURI(encodeURI(note_s));
			    rowParam['cost_budget'] =cost_budget;
			    rowParam['profit_share'] =profit_share;
			    rowParam['bid_price'] =bid_price;
			    
			    rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';
				rowParam['modifi_date'] = '<%=curDate%>';	
				rowParam['second_org'] = '<%=orgSubId%>';	
				rowParam['bsflag'] = bsflag;
			 
		  }  				

			rowParams[rowParams.length] = rowParam; 
			var rows=JSON.stringify(rowParams); 
			saveFunc("BGP_MARKET_VIRTUALPROJECT_D",rows);	
			top.frames('list').frames[1].refreshData();	
			newClose();
		 
	}
	
	function checkNum(numids){

		 var pattern =/^[0-9]+([.]\d{1,2})?$/;
		 var str = document.getElementById(numids).value;

		 if(str!=""){
			 if(!pattern.test(str)){
			     alert("请输入数字(例:0.00),最高保留2位小数");
			     document.getElementById(numids).value="";
			     return false;
			 }else{
				 return true;
			 }
		  }else{
			  return true;
		  }
	}

	function calculateCost(){
		
		var sumTotalCharge=0;

		var cost_budget=document.getElementById("cost_budget").value;
		var profit_share=document.getElementById("profit_share").value;
	 
 
		if(cost_budget != '' && checkNum("cost_budget")){
			
			if(profit_share != '' && checkNum("profit_share")){
				 
				sumTotalCharge =  parseFloat(cost_budget)* (1+parseFloat(profit_share)*0.01);
			} 
			
		} 
		
		document.getElementById("bid_price").value=substrin(sumTotalCharge);
			
	}

	function substrin(str)
	{ 
		str = Math.round(str * 10000) / 10000;
		return(str); 
	 }
	
	
	function closeButton(){
		var ctt = top.frames('list');
		ctt.refreshData();
		newClose();
	}
	
	function selectCoding(codingSortId,objId,objName){
		var obj = new Object();
		obj.fkValue="";
		obj.value="";
		var resObj = window.showModalDialog('<%=contextPath%>/pm/workarea/selectcode.jsp?codeSort='+codingSortId,window);
		if(objId!=""){
			document.getElementById(objId).value = resObj.fkValue;
		}
		document.getElementById(objName).value = resObj.value;
	}
	
	function selectTeam(){
		var teamInfo = {
			fkValue:"",
			value:""
		};
		window.showModalDialog('<%=contextPath%>/common/selectOrg.jsp',teamInfo);
		if(teamInfo.fkValue!=""){
			document.getElementById('c_team_id').value = teamInfo.fkValue;
			document.getElementById('c_team').value = teamInfo.value;
		}
	}
	
	function getSurfaceType(){
		var selectObj = document.getElementById("surface_type"); 
		document.getElementById("surface_type").innerHTML="";
		selectObj.add(new Option('请选择',""),0);

		var retObj=jcdpCallService("WorkAreaSrv","getSurfaceType","");	
	 
//		for(var i=0;i<queryHazardBig.detailInfo.length;i++){
//			var templateMap = queryHazardBig.detailInfo[i];
//			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
//		}   	
 	
		if(retObj.surfaceType != null){
			for(var i=0;i<retObj.surfaceType.length;i++){
				var record = retObj.surfaceType[i];
				var item = new Option(record.coding_name.replace(/\-/g," "),record.coding_code_id);
				selectObj.add(item);
			 
			}
		}
		 
 
	}
	
	function checkText0(){
 
		var cost_budget=document.getElementById("cost_budget").value;
		var profit_share=document.getElementById("profit_share").value;
	 
		if(cost_budget==""){
			alert("项目成本预算不能为空，请填写!");
			return true;
		}
		if(profit_share==""){
			alert("项目利润比例不能为空，请填写!");
			return true;
		}
		 
		return false;
	}
	
	 function exitSelect(){ 
			var selectObj = document.getElementById("surface_type");  
			var aa = document.getElementById("aa").value; 
	  
		    for(var i = 0; i<selectObj.length; i++){ 
		        if(selectObj.options[i].value == aa){ 
		        	selectObj.options[i].selected = 'selected';     
		        } 
		       }  
		   
	 }
	 function  listInfo(){ 
		 
		if(virtualproject_ids !=null  && virtualproject_ids !=''){
			var querySql = "";
			var queryRet = null;
			var  datas =null;		
					 
			querySql = " select  t.virtualproject_id_s,vt.virtualproject_id,vt.jiafang,vt.project_name,vt.c_team,vt.surface_type,vt.bidding_time,vt.bid_time,t.bsflag, t.creator,t.create_date,t.modifi_date, t.updator, t.second_org ,     oi.org_abbreviation as c_team_name,   ccsd.coding_name as jiafang_name,  ccsl.coding_name as surface_type_name  ,  t.cost_budget,     t.profit_share,  t.bid_price,  t.note_s    from BGP_MARKET_VIRTUALPROJECT_D t  left join BGP_MARKET_VIRTUALPROJECT vt    on t.virtualproject_id= vt.virtualproject_id   and vt.bsflag = '0'    left join comm_org_information oi on oi.org_id = vt.c_team  and oi.bsflag = '0'    left join comm_coding_sort_detail ccsd on vt.jiafang = ccsd.coding_code_id and ccsd.bsflag = '0'   left join comm_coding_sort_detail ccsl on vt.surface_type =ccsl.coding_code_id and ccsl.bsflag='0'  where t.bsflag = '0' and t.virtualproject_id_s='"+ virtualproject_ids +"'"; 			 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){	 
		            document.getElementById("virtualproject_id_s").value=datas[0].virtualproject_id_s;
		     		
		     		document.getElementById("project_name").value=datas[0].project_name;
		     		document.getElementById("jiafang").value=datas[0].jiafang_name;
		     		document.getElementById("jiafang_org").value=datas[0].jiafang;
		     		 
		     		document.getElementById("c_team").value=datas[0].c_team_name;
		     		document.getElementById("c_team_id").value=datas[0].c_team;
		     	  
		     		document.getElementById("surface_type").value=datas[0].surface_type;
		    		document.getElementById("aa").value=datas[0].surface_type;
		    		
		     		document.getElementById("bidding_time").value=datas[0].bidding_time;
		     		document.getElementById("bid_time").value=datas[0].bid_time;
		     		
		     		document.getElementById("cost_budget").value=datas[0].cost_budget;
		     		document.getElementById("profit_share").value=datas[0].profit_share;
		     		document.getElementById("bid_price").value=datas[0].bid_price;
		     		document.getElementById("note_s").value=datas[0].note_s;
		      
		     		document.getElementsByName("create_date")[0].value=datas[0].create_date;
		     		document.getElementsByName("creator")[0].value=datas[0].creator;		
		     		document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		     		
			         
			    	}					
			
		    	}		
			
		}
	 }
</script>
</html>