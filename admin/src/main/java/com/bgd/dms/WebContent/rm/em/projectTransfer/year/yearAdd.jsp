<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%> 
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@ taglib uri="code" prefix="code"%>  
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.bgp.gms.service.rm.dm.util.DevUtil"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="com.bgp.gms.service.rm.dm.constants.DevConstants"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>

<% 
	String contextPath = request.getContextPath();
	String ptransfer_id = request.getParameter("ptransfer_id");
	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String empId = user.getEmpId();
	String org_id = user.getOrgId();
	String project_no=user.getProjectInfoNo();
	String project_name=user.getProjectName();
	String org_subjection_id = user.getOrgSubjectionId();
	String userName = user.getUserName();
	SimpleDateFormat format =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String curDate = format.format(new Date());	
	SimpleDateFormat format_d =new SimpleDateFormat("yyyy-MM-dd");
	String curDate_d = format_d.format(new Date());	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" /> 
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<script type="text/javascript" src="<%=contextPath %>/js/common.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/aside.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/listTable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/extjs/adapter/ext/ext-base.js"></script> 
<script type="text/javascript" src="<%=contextPath %>/js/extjs/ext-all.js"></script> 

<script type="text/javascript" src="<%=contextPath %>/js/external/jquery.bgiframe-2.1.2.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.mouse.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.draggable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.resizable.js"></script>
<script type="text/javascript" src="<%=contextPath %>/js/ui/jquery.ui.dialog.js"></script>

<link rel="stylesheet" type="text/css" href="<%=contextPath %>/css/cn/jquery_ui/jquery.ui.all.css"/>
<title>转移添加界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshDatas();">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box" style="width:98%">
  <div id="new_table_box_content" style="width:100%">
    <div id="new_table_box_bg" style="width:95%">
      <fieldSet style="margin-left:2px"><legend style="color:#B0B0B0;">转移单据基本信息</legend>
      <table border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr> 
          <td class="inquire_item4"><font color=red>*</font>&nbsp;转移单据名称:</td>
          <td class="inquire_form4" >
            	<input class="input_width" type="hidden" name="zy_id" id="zy_id"  value='<%=ptransfer_id%>'/>
          	<input class="input_width" type="text" name="zy_name" id="zy_name"  value=''/>
          	<input type="hidden" name="showMessage" value=""/>
          </td>
                    <td class="inquire_item4" ><font color=red>*</font>&nbsp;转出项目名称</td>
          <td class="inquire_form4" >
  				   <input name="a_project_info_no" id="a_project_info_no" class="input_width" value="<%=project_no%>" type="hidden" readonly="readonly"/>
	  		    	<input name="a_project_name" id="a_project_name" class="input_width" value="<%=project_name%>" type="text"  readonly="readonly" />   
	  			    <!--  <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam_a()"/>  --> 
	  			  
          </td>
          
        </tr>
        
        <tr>

          <td class="inquire_item4" ><font color=red>*</font>&nbsp;转入项目名称</td>
          <td class="inquire_form4" >
         		<input name="b_project_info_no" id="b_project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>
	  		    <input name="b_project_name" id="b_project_name" class="input_width" value="" type="text" readonly="readonly"  />   
	  			<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectTeam_b()"/> 
          </td>
          
           <td class="inquire_item4">经办人</td>
          <td class="inquire_form4">
          	<input name="back_employee_name" id="back_employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          	<input name="back_employee_id" id="back_employee_id" class="input_width" value="<%=user.getEmpId()%>" type="hidden" />
          	     </td>
        </tr>
         
        
      </table>
      </fieldSet>
      <div style="overflow:auto">
      	<table width="97%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		  	<tr align="right">
		  		<td style="width:90%"></td>
				<td><span class="zj"><a href="#" id="addProcess" name="addProcess" onClick="openSearch()" ></a></span></td>
			    <td style="width:1%"></td>
			</tr>
		  </table>
	  </div>
	  <fieldSet style="margin-left:2px"><legend>转移人员明细</legend>
		  <div style="height:220px;overflow:auto">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" id="employeeTable">
		       <tr>
					<td class="bt_info_odd" width="4%">序号</td>
					<td class="bt_info_even" width="15%">用工性质</td>
					<td class="bt_info_odd" width="10%">姓名</td>
					<td class="bt_info_even" width="10%">班组</td>
					<td class="bt_info_odd" width="15%">岗位</td>
					<td class="bt_info_even" width="20%">员工编号</td>
					
					<td class="bt_info_odd" width="5%">操作<input type="hidden"
					id="equipmentSize" name="equipmentSize"
					value="" />   <input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />
					<input type="hidden" id="pk_ids" name="pk_ids" value="" />  
					<input type="hidden" id="qufens" name="qufens" value="" /> 
					<input type="hidden" id="emtypes" name="emtypes" value="" /> 
					</td>
				
				
				</tr>
			   </table>
				<div style="height:190px;overflow:auto;">
				<table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			  		<tbody id="processtable" name="processtable" >
			   		</tbody>
		      	</table>
		      </div>
	       </div>
      </fieldSet>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">

var currentCount=0;
var deviceCount =0;

	function refreshDatas(){
		var retObj;
		var basedatas;
		var proSql = "select t.ptransfer_id,t.transfer_name,t.aproject_info_no,pt.project_name ap_name ,bt.project_name bp_name ,t.bproject_info_no,t.back_hname,t.back_hid,t.zy_status, t.deploy_date  ,t.spare1,t.spare2  from  bgp_comm_human_ptransfer t  left join gp_task_project  pt  on t.aproject_info_no=pt.project_info_no and pt.bsflag='0'  left  join   gp_task_project  bt  on t.bproject_info_no=bt.project_info_no and bt.bsflag='0'  where  t.bsflag='0' and t.ptransfer_id= '<%=ptransfer_id%>' ";
		var proqueryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+proSql);
		
		if(proqueryRet!=null && proqueryRet.returnCode =='0'){ 
			retObj = proqueryRet.datas; 
			 document.getElementById("zy_id").value = retObj[0].ptransfer_id;
			 document.getElementById("zy_name").value = retObj[0].transfer_name;
			 document.getElementById("a_project_info_no").value = retObj[0].aproject_info_no;
			 document.getElementById("b_project_info_no").value = retObj[0].bproject_info_no;
			 document.getElementById("a_project_name").value = retObj[0].ap_name;
			 document.getElementById("b_project_name").value = retObj[0].bp_name;
			 
			 document.getElementById("back_employee_name").value = retObj[0].back_hname;
			 document.getElementById("back_employee_id").value = retObj[0].back_hid;
			//转入转出项目不可修改 ，隐藏弹出项目页面放大镜
			//$('#img')[0].style.display = "none"; 
				
		}
		
		
		//查询原来的人员接收数据 union all  转移表中的数据
		var querySql1 = "select t.*  from (  select 'add' em_type, '' employee_hr_id, dt.employee_id,'' job_id,dt.ptdetail_id pk_ids,dt.xz_type,dt.employee_name,dt.employee_cd, dt.employee_cd id_code,to_char(dt.start_date , 'yyyy-MM-dd') ACTUAL_START_DATE,to_char(dt.end_date, 'yyyy-MM-dd') ACTUAL_END_DATE ,to_char( dt.start_date, 'yyyy-MM-dd') plan_start_date ,   to_char(nvl(dt.end_date,   sysdate), 'yyyy-MM-dd') plan_end_date,   round(case  when nvl(dt.end_date,  sysdate) -   dt.start_date > 0 then  nvl(dt.end_date, sysdate) -  dt.start_date - (-1)    else  0  end) days,dt.team_s team ,dt.post_s post,dt.team_name,dt.work_post_name, dt.employee_gz,dt.employee_gz_name,'' zy_type from  BGP_COMM_HUMAN_PT_DETAIL   dt  where dt.bsflag='0' and dt.locked_if='<%=ptransfer_id%>'   union all  select distinct  'edit' em_type,t.employee_hr_id, t.EMPLOYEE_ID,t.job_id,t.pk_ids, case  when   t.employee_cd is not null then '1'  when   t.employee_cd is null then  '0'  end xz_type,    t.EMPLOYEE_NAME,  nvl(t.employee_cd,t.id_code) employee_cd,  t.id_code,   to_char( t.ACTUAL_START_DATE, 'yyyy-MM-dd')ACTUAL_START_DATE,   to_char(t.ACTUAL_END_DATE, 'yyyy-MM-dd')ACTUAL_END_DATE,   to_char(t.plan_start_date, 'yyyy-MM-dd')plan_start_date,  to_char( nvl(t.plan_end_date, sysdate),'yyyy-MM-dd') plan_end_date,  round( case when nvl(t.plan_end_date, sysdate) - t.plan_start_date > 0 then nvl(t.plan_end_date, sysdate) - t.plan_start_date  -(-1) else 0 end ) days,  t.TEAM,  t.WORK_POST,  d1.coding_name      team_name,  d2.coding_name      work_post_name,  t.EMPLOYEE_GZ,  d3.coding_name      employee_gz_name , t.zy_type  from view_human_project_relation t  left join comm_coding_sort_detail d1  on t.team = d1.coding_code_id    left join comm_coding_sort_detail d2  on t.work_post = d2.coding_code_id    left join comm_coding_sort_detail d3  on t.EMPLOYEE_GZ = d3.coding_code_id  where   t.zy_type ='<%=ptransfer_id%>'  and t.actual_start_date is not null  and t.ACTUAL_END_DATE is null and t.job_id is null  ) t  where 1 = 1  ";
		var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql1);
		var datas1 = queryRet1.datas;
		
		document.getElementById("equipmentSize").value=queryRet1.datas.length;

		 // currentCount=queryRet1.datas.length;
		 // deviceCount =queryRet1.datas.length;

		if(datas1 != null){	  
		     for (var i = 0; i< queryRet1.datas.length; i++) {   
					addEmployee(datas1[i].pk_ids,datas1[i].xz_type,datas1[i].employee_id,datas1[i].employee_cd,datas1[i].employee_name,datas1[i].team_name,datas1[i].work_post_name,datas1[i].employee_gz_name,datas1[i].zy_type,datas1[i].em_type,datas1[i].team,datas1[i].post,datas1[i].employee_gz,datas1[i].plan_start_date,datas1[i].plan_end_date,datas1[i].employee_hr_id,datas1[i].actual_start_date);
			  
		     } 
		}
		
		
		
	}
	 

	
	
	function openSearch(){
		var zcP=document.getElementById("a_project_info_no").value;
		if (zcP == ""){
			alert("请选择转出项目!");
			return;
		}
		popWindow('<%=contextPath%>/rm/em/projectTransfer/year/selectHumanYear.jsp?projectInfoNo='+zcP,'880:725'); 	
	}
	
	
	function Map() {    
		 var struct = function(key, value) {    
		  this.key = key;    
		  this.value = value;    
		 }    
		     
		 var put = function(key, value){    
		  for (var i = 0; i < this.arr.length; i++) {    
		   if ( this.arr[i].key === key ) {    
		    this.arr[i].value = value;    
		    return;    
		   }    
		  }    
		   this.arr[this.arr.length] = new struct(key, value);    
		 }    
		     
		 var get = function(key) {    
		  for (var i = 0; i < this.arr.length; i++) {    
		   if ( this.arr[i].key === key ) {    
		     return this.arr[i].value;    
		   }    
		  }    
		  return null;    
		 }    
		     
		 var remove = function(key) {    
		  var v;    
		  for (var i = 0; i < this.arr.length; i++) {    
		   v = this.arr.pop();    
		   if ( v.key === key ) {    
		    continue;    
		   }    
		   this.arr.unshift(v);    
		  }    
		 }    
		     
		 var size = function() {    
		  return this.arr.length;    
		 }    
		     
		 var isEmpty = function() {    
		  return this.arr.length <= 0;    
		 }    
		   
		 this.arr = new Array();    
		 this.get = get;    
		 this.put = put;    
		 this.remove = remove;    
		 this.size = size;    
		 this.isEmpty = isEmpty;    
		}
	
	
	
	
	function submitInfo(){ 
		var zy_id=document.getElementById("zy_id").value;
		var zy_name=document.getElementById("zy_name").value;
		var zcP=document.getElementById("a_project_info_no").value;
		var zrP=document.getElementById("b_project_info_no").value;
		var back_employee_name=document.getElementById("back_employee_name").value;
		var back_employee_id=document.getElementById("back_employee_id").value;
		 
		var pk_ids=document.getElementById("pk_ids").value;//删除的id标识
		var qufens=document.getElementById("qufens").value;
		var emtypes=document.getElementById("emtypes").value;
		
		var s_length=document.getElementById("equipmentSize").value;
		
		if(zy_name =="" || zcP=="" || zrP =="" ){
			
			alert("红色标注为必填项 !");
			return;
		}  
        if(zy_id == "null"){   
        	var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';//LOCKED_IF=1 单项目转移
    		var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_PTRANSFER&JCDP_TABLE_ID=&locked_if=1&transfer_name='+zy_name+'&aproject_info_no='+zcP+'&bproject_info_no='+zrP+'&back_hname='+back_employee_name+'&back_hid='+back_employee_id
    		+'&zy_status=2&creator=<%=user.getUserName()%>&updator=<%=user.getUserName()%>&create_date=<%=curDate%>&modifi_date=<%=curDate%>&bsflag=0&spare1=<%=user.getOrgId()%>&spare2=<%=user.getOrgSubjectionId()%>';
    	 
    		var retObject = syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //新增保存主表信息		
    		zy_id =retObject.entity_id; //获得 主表id 	
    
        }else{ 
        	var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
    		var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_PTRANSFER&JCDP_TABLE_ID='+zy_id+'&transfer_name='+zy_name+'&zy_status=2&updator=<%=user.getUserName()%>&modifi_date=<%=curDate%>';
    	 
    		 syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //修改保存主表信息		
    	 
        }
			if(currentCount >0){				
				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
	    		var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_PTRANSFER&JCDP_TABLE_ID='+zy_id+'&zy_status=0'; 
	    		  syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //如果有人转移修改 状态 0 待转移	
	    	 
			}
			var deleteRowFlag=document.getElementById("deleteRowFlag").value;
		 
			var mapFlag = new Map();     
		 
			if (deleteRowFlag != "") {
				 var  rowFlag = deleteRowFlag.split(",");  
				 for (var a = 0; a < rowFlag.length; a++) {  
						mapFlag.put(rowFlag[a], "true");
						
				 }
				  
			} 
		 
			
		for (var i = 0; i<s_length; i++) { 
		var mapValue=mapFlag.get(i+""); 

			if (mapValue == null) { 
				var pk_id_s = document.getElementById("em"+i+"pk_ids").value;
				var xz_type_s = document.getElementById("em"+i+"xz_type").value;
				
				var em_type_s = document.getElementById("em"+i+"em_type").value;
				var em_hr_id_s = document.getElementById("em"+i+"employee_hr_id").value;
				
			 
				var employee_id =document.getElementById("em"+i+"employee_id").value;
				var employee_cd =document.getElementById("em"+i+"employee_cd").value;
				var employee_name = document.getElementById("em"+i+"employee_name").value;
				var team_name = document.getElementById("em"+i+"team_name").value;
				var work_post_name = document.getElementById("em"+i+"work_post_name").value;
				var employee_gz_name =document.getElementById("em"+i+"employee_gz_name").value;
				//var zy_type = document.getElementById("em"+i+"zy_type").value;
			 
				var em_type = document.getElementById("em"+i+"em_type").value;
				var team = document.getElementById("em"+i+"team").value;
				var post = document.getElementById("em"+i+"post").value;
				var employee_gz = document.getElementById("em"+i+"employee_gz").value;
				var plan_start_date = document.getElementById("em"+i+"plan_start_date").value;
				var plan_end_date =document.getElementById("em"+i+"plan_end_date").value;
				var employee_hr_id = document.getElementById("em"+i+"employee_hr_id").value;
				var actual_start_date = document.getElementById("em"+i+"actual_start_date").value;
				
				
				if(em_type_s == "add"){ //新增到 BGP_COMM_HUMAN_PT_DETAIL 转移表中				
					var paths = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
					//赋值转移表中的 id，即假转移，待主记录提交时，赋值离开日期，新增记录
					var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_PT_DETAIL&JCDP_TABLE_ID='+pk_id_s+'&locked_if='+zy_id; 
		    		  syncRequest('Post',paths,encodeURI(encodeURI(submitStr)));  
		    		  
		    		//  var submitStrs = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_PT_DETAIL&JCDP_TABLE_ID=&ptransfer_id='+zy_id+'&aproject_info_no=<%=project_no%>&bproject_info_no='+zrP+'&start_date=<%=curDate_d%>&employee_gz='+employee_gz
			    		//+'&employee_gz_name='+employee_gz_name+'&creator=<%=user.getUserName()%>&updator=<%=user.getUserName()%>&create_date=<%=curDate%>&modifi_date=<%=curDate%>&bsflag=0&team_s='+team+'&post_s='+post+'&team_name='+team_name+'&work_post_name='+work_post_name
			    	 //	+'&employee_name='+employee_name+'&employee_cd='+employee_cd+'&employee_id='+employee_id+'&xz_type='+xz_type_s+'&pk_ids=add';
			    	 //   syncRequest('Post',paths,encodeURI(encodeURI(submitStrs)));  //新增保存主表信息			

		    		  
		    		  
				}else if (em_type_s == "edit") { 
					
					if(xz_type_s == "1"){
						
						var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
			    		var submitStr = 'JCDP_TABLE_NAME=bgp_human_prepare_human_detail&JCDP_TABLE_ID='+pk_id_s+'&zy_type='+zy_id; 
			    		  syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //如果有人转移修改 状态 0 待转移	
			    
					}else{ 
						var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
			    		var submitStr = 'JCDP_TABLE_NAME=bgp_comm_human_labor_deploy&JCDP_TABLE_ID='+pk_id_s+'&zy_type='+zy_id; 
			    		syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //如果有人转移修改 状态 0 待转移	
			 
					}
					
		 
				}
				
				
			} 
		}
		
		
	 	  pk_ids = pk_ids.split(",");	
		  qufens = qufens.split(","); //1正式工 0 临时工 	
		  emtypes = emtypes.split(",");  
		  //删除处理
		for (var j = 0; j < pk_ids.length; j++) {	 
		     if (pk_ids[j] != null ){ 
		    	 
		    	 if(emtypes[j]  == "add"){ 
		    		 
		    		 var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
		    		  var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_PT_DETAIL&JCDP_TABLE_ID='+pk_ids[j]+'&locked_if='; 
		    		  syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //如果有人转移修改 状态 0 待转移	

		    		 
		    	 }else if (emtypes[j]  == "edit") { 
					 if(qufens[j] == "1"){
						//更新 人员接收表中 zy_type 为空 ，空为 未转移 ,id不为空 
					   
							  var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
				    		  var submitStr = 'JCDP_TABLE_NAME=bgp_human_prepare_human_detail&JCDP_TABLE_ID='+pk_ids[j]+'&zy_type='; 
				    		  syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //如果有人转移修改 状态 0 待转移	
	 
						 
					 }else{
						    var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
				    		var submitStr = 'JCDP_TABLE_NAME=bgp_comm_human_labor_deploy&JCDP_TABLE_ID='+pk_ids[j]+'&zy_type='; 
				    		syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //如果有人转移修改 状态 0 待转移	
	 
							 
					 }
					 
		    	 }
			 }
			 
		}
	 
		top.frames('list').refreshData();
		top.frames('list').loadDataDetail(zy_id+",0");alert('保存成功!');
		newClose();
 
		
	}
	
	var editV="<%=ptransfer_id%>";
	function getMessage(arg){
		var result = document.getElementsByName("showMessage")[0].value=arg[0];
		
		if(result!="" && result!=undefined ){ 
			var checkStr = result.split(",");	
			var reCheck = "";	
			var newCheck = "";
			if(deviceCount>0){
				if(editV!=""){
					
					addLines(checkStr);
					
					
				}else{
				var checkNum = deviceCount;
				//人员列表		
				var rowFlag = document.getElementById("deleteRowFlag").value;
				var notCheck = rowFlag.split(",");
				var isRe=true;
				for(var m=0;m<checkNum;m++){
					var isCheck=true;
					for(var j=0;notCheck!=""&&j<notCheck.length;j++){
						if(notCheck[j]==m&&notCheck[j]!="") isCheck =false;
					}
					if(isCheck){
					 
						var id = document.getElementById("em"+m+"employee_id").value;
						var name = document.getElementById("em"+m+"employee_name").value;
						for(var i=0;i<checkStr.length; i++){
							var emplTemp = checkStr[i].split("-");	
							if(id == emplTemp[2]){
								newCheck += i + ",";
								reCheck += emplTemp[4] +",";
								break;
							}						
						}	
					}
				}
				for(var i=0;i<checkStr.length; i++){
					newCheck = "," + newCheck;
					if(newCheck.indexOf(","+i+",") == -1){
						var emplTemp = checkStr[i].split("-");	
						var pk_ids = "";
						var xz_type = "";
						var employee_id = "";
						var employee_cd = "";
						var employee_name = "";
						var team_name = "";
						var work_post_name = "";
						var employee_gz_name = "";
						var zy_type = "";
					 
						var em_type = "";
						var team = "";
						var post = "";
						var employee_gz = "";
						var plan_start_date = "";
						var plan_end_date = "";
						var employee_hr_id = "";
						var actual_start_date = "";
						
							if(emplTemp[0]!=''){
								pk_ids = emplTemp[0];						 
							}								
							if(emplTemp[1]!=''){
								xz_type = emplTemp[1];
							 
							}
							if(emplTemp[2]!=''){
								employee_id = emplTemp[2];
							 
							}
							if(emplTemp[3]!=''){
								employee_cd = emplTemp[3];
							 
							}
							if(emplTemp[4]!=''){
								employee_name = emplTemp[4];
							 
							}
							if(emplTemp[5]!=''){
								team_name = emplTemp[5];
							 
							}
							if(emplTemp[6]!=''){
								work_post_name = emplTemp[6];
							 
							}
							if(emplTemp[7]!=''){
								employee_gz_name = emplTemp[7];
							 
							}
							if(emplTemp[8]!=''){
								zy_type = emplTemp[8];
							 
							}
					 
							if(emplTemp[9]!=''){
								em_type = emplTemp[9];
							 
							}
							if(emplTemp[10]!=''){
								team = emplTemp[10];
							 
							}
							if(emplTemp[11]!=''){
								post = emplTemp[11];
							 
							}
							if(emplTemp[12]!=''){
								employee_gz = emplTemp[12];
							 
							}
							if(emplTemp[13]!=''){
								plan_start_date = emplTemp[13];
							 
							}
							if(emplTemp[14]!=''){
								plan_end_date = emplTemp[14];
							 
							}
							if(emplTemp[15]!=''){
								employee_hr_id = emplTemp[15];
							 
							}
							if(emplTemp[16]!=''){
								actual_start_date = emplTemp[16];
							 
							}
							
							
						//	-{em_type}-{team}-{post}-{employee_gz}-{plan_start_date}-{plan_end_date}
						addEmployee(pk_ids,xz_type,employee_id,employee_cd,employee_name,team_name,work_post_name,employee_gz_name,zy_type,em_type,team,post,employee_gz,plan_start_date,plan_end_date,employee_hr_id,actual_start_date);	
					}					
				}	
				
				}
				
				
			}else{
				//'{pk_ids}-{xz_type}-{employee_id}-{employee_cd}-{employee_name}-{team_name}-{work_post_name}-{employee_gz_name}"
				
				addLines(checkStr);
			
		}
			
			if(reCheck != ""){
				reCheck = reCheck.substring(0,reCheck.length-1);
				alert(reCheck+"已调配");
			} 
			
			
	}
	}
	 
	
	
	function   addLines(checkStr){
		
		for(var i=0;i<checkStr.length; i++){
			var emplTemp = checkStr[i].split("-");	
			
			var pk_ids = "";
			var xz_type = "";
			var employee_id = "";
			var employee_cd = "";
			var employee_name = "";
			var team_name = "";
			var work_post_name = "";
			var employee_gz_name = "";
			var zy_type = "";
			
			var em_type = "";
			var team = "";
			var post = "";
			var employee_gz = "";
			var plan_start_date = "";
			var plan_end_date = "";
			var employee_hr_id = "";
			var actual_start_date = "";
			
				if(emplTemp[0]!=''){
					pk_ids = emplTemp[0];						 
				}								
				if(emplTemp[1]!=''){
					xz_type = emplTemp[1];
				 
				}
				if(emplTemp[2]!=''){
					employee_id = emplTemp[2];
				 
				}
				if(emplTemp[3]!=''){
					employee_cd = emplTemp[3];
				 
				}
				if(emplTemp[4]!=''){
					employee_name = emplTemp[4];
				 
				}
				if(emplTemp[5]!=''){
					team_name = emplTemp[5];
				 
				}
				if(emplTemp[6]!=''){
					work_post_name = emplTemp[6];
				 
				}
				if(emplTemp[7]!=''){
					employee_gz_name = emplTemp[7];
				 
				}
				if(emplTemp[8]!=''){
					zy_type = emplTemp[8];
				 
				}
				 
				if(emplTemp[9]!=''){
					em_type = emplTemp[9];
				 
				}
				if(emplTemp[10]!=''){
					team = emplTemp[10];
				 
				}
				if(emplTemp[11]!=''){
					post = emplTemp[11];
				 
				}
				if(emplTemp[12]!=''){
					employee_gz = emplTemp[12];
				 
				}
				if(emplTemp[13]!=''){
					plan_start_date = emplTemp[13];
				 
				}
				if(emplTemp[14]!=''){
					plan_end_date = emplTemp[14];
				 
				}
				if(emplTemp[15]!=''){
					employee_hr_id = emplTemp[15];
				 
				}
				if(emplTemp[16]!=''){
					actual_start_date = emplTemp[16];
				 
				}
				
				
			addEmployee(pk_ids,xz_type,employee_id,employee_cd,employee_name,team_name,work_post_name,employee_gz_name,zy_type,em_type,team,post,employee_gz,plan_start_date,plan_end_date,employee_hr_id,actual_start_date);	
		
		
    	}
		
		
	}
		//加一行人员需求
		function addEmployee(pk_ids,xz_type,employee_id,employee_cd,employee_name,team_name,work_post_name,employee_gz_name,zy_type,em_type,team,post,employee_gz,plan_start_date,plan_end_date,employee_hr_id,actual_start_date){

			var tr = document.getElementById("employeeTable").insertRow();
			tr.align ="center";
		 
		 	if(deviceCount % 2 == 1){  
		  		tr.className = "odd";
			}else{ 
				tr.className = "even";
			}	
		  
			tr.id = "em"+deviceCount+"trflag"; 
		 
			tr.insertCell().innerHTML = currentCount+1+'<input type="hidden" id="em'+deviceCount+'pk_ids" name="em'+deviceCount+'pk_ids"  value="'+pk_ids+'"/>';
		 
			tr.insertCell().innerHTML = '<input type="text" maxlength="32" id="em'+deviceCount+'employee_gz_name" name="em'+deviceCount+'employee_gz_name"  value="'+employee_gz_name+'" class="input_width" readonly="readonly"/>'+ '<input type="hidden" id="em'+deviceCount+'xz_type" name="em'+deviceCount+'xz_type"  value="'+xz_type+'"/>'+'<input type="hidden" id="em'+deviceCount+'employee_id" name="em'+deviceCount+'employee_id"  value="'+employee_id+'"/>'+'<input type="hidden" id="em'+deviceCount+'em_type" name="em'+deviceCount+'em_type"  value="'+em_type+'"/>'+'<input type="hidden" id="em'+deviceCount+'team" name="em'+deviceCount+'team"  value="'+team+'"/>'+'<input type="hidden" id="em'+deviceCount+'post" name="em'+deviceCount+'post"  value="'+post+'"/>'+'<input type="hidden" id="em'+deviceCount+'employee_gz" name="em'+deviceCount+'employee_gz"  value="'+employee_gz+'"/>'+'<input type="hidden" id="em'+deviceCount+'plan_start_date" name="em'+deviceCount+'plan_start_date"  value="'+plan_start_date+'"/>'+'<input type="hidden" id="em'+deviceCount+'plan_end_date" name="em'+deviceCount+'plan_end_date"  value="'+plan_end_date+'"/>'+'<input type="hidden" id="em'+deviceCount+'employee_hr_id" name="em'+deviceCount+'employee_hr_id"  value="'+employee_hr_id+'"/>'+'<input type="hidden" id="em'+deviceCount+'actual_start_date" name="em'+deviceCount+'actual_start_date"  value="'+actual_start_date+'"/>';
			tr.insertCell().innerHTML = '<input type="text"   id="em'+deviceCount+'employee_name" name="em'+deviceCount+'employee_name"  value="'+employee_name+'" class="input_width" readonly="readonly"/>';
			tr.insertCell().innerHTML = '<input type="text"   id="em'+deviceCount+'team_name" name="em'+deviceCount+'team_name"  value="'+team_name+'" class="input_width" readonly="readonly"/>';
			tr.insertCell().innerHTML = '<input type="text"   id="em'+deviceCount+'work_post_name" name="em'+deviceCount+'work_post_name"  value="'+work_post_name+'" class="input_width" readonly="readonly"/>';
			tr.insertCell().innerHTML = '<input type="text"   id="em'+deviceCount+'employee_cd" name="em'+deviceCount+'employee_cd"  value="'+employee_cd+'" class="input_width" readonly="readonly"/>';
			 
			tr.insertCell().innerHTML = '<input type="hidden" name="orderDrill" value="' + deviceCount + '"/><img src="'+'<%=contextPath%>'+'/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteDevice(' +deviceCount + ')"/>';

			document.getElementById("equipmentSize").value=deviceCount+1;

			deviceCount+=1;
			currentCount+=1;
		}
		
		
		function deleteDevice(deviceNum){

			var rowDetailId = document.getElementById("pk_ids").value;	
			var qufens = document.getElementById("qufens").value;
			var emtypes = document.getElementById("emtypes").value;
			
			var rowDeleteId = document.getElementById("em"+deviceNum+"pk_ids").value;
			var qufen = document.getElementById("em"+deviceNum+"xz_type").value; 
			var emtype = document.getElementById("em"+deviceNum+"em_type").value; 
			 
			if(	rowDeleteId!=""&&rowDeleteId!=null){
				rowDetailId = rowDetailId+rowDeleteId+",";			 
				qufens = qufens+qufen+",";
				emtypes= emtypes+emtype+",";
				
				document.getElementById("pk_ids").value = rowDetailId;
				document.getElementById("qufens").value = qufens;
				document.getElementById("emtypes").value = emtypes;
			}	

			var rowDevice = document.getElementById("em"+deviceNum+"trflag");
			rowDevice.parentNode.removeChild(rowDevice);
			var rowFlag = document.getElementById("deleteRowFlag").value;
			rowFlag=rowFlag+deviceNum+",";  
			document.getElementById("deleteRowFlag").value = rowFlag;

			currentCount-=1;

			//删除后重新排列序号
			deleteChangeInfoNum('pk_ids');

		}

		function deleteChangeInfoNum(warehouseDetailId){
			var rowFlag = document.getElementById("deleteRowFlag").value;
			var notCheck=rowFlag.split(",");
			var num=1;
			for(var i=0;i<deviceCount;i++){
				var isCheck=true;
				for(var j=0;notCheck!=""&&j<notCheck.length;j++){
					if(notCheck[j]==i&&notCheck[j]!="") isCheck =false;
				}
				if(isCheck){
					document.getElementById("em"+i+warehouseDetailId).parentNode.innerHTML=num+document.getElementById("em"+i+warehouseDetailId).outerHTML;
					num+=1;
				}
			}	
		}

		
		
		
		
		
	//转出项目名称
	function selectTeam_a(){

	    var result = window.showModalDialog('<%=contextPath%>/rm/em/projectTransfer/year/yearProject.jsp','');
	    if(result!=""){
	    	var checkStr = result.split("-");	
		        document.getElementById("a_project_info_no").value = checkStr[0];
		        document.getElementById("a_project_name").value = checkStr[1];
	    }
	}
	
	function selectTeam_b(){

	    var result = window.showModalDialog('<%=contextPath%>/rm/em/projectTransfer/year/yearProject.jsp','');
	    if(result!=""){
	    	var checkStr = result.split("-");	
		        document.getElementById("b_project_info_no").value = checkStr[0];
		        document.getElementById("b_project_name").value = checkStr[1];
	    }
	}
	
	 
</script>
</html>

