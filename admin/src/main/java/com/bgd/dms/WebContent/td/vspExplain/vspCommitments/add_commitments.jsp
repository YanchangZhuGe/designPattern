<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
	String userName = (user==null)?"":user.getUserName();
    String projectInfoNo = user.getProjectInfoNo();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
 
    String businessType = request.getParameter("docType")==null?"":request.getParameter("docType");
    String parent_file_id = request.getParameter("parent_file_id")==null?"":request.getParameter("parent_file_id");
    String id = request.getParameter("id")==null?"":request.getParameter("id");
    String fileAbbr = request.getParameter("fileAbbr")==null?"":request.getParameter("fileAbbr");
    String p_type = request.getParameter("p_type")==null?"":request.getParameter("p_type");
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/verify.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" />
<!--Remark JavaScript定义-->

</head>
<body onload="page_init();">
	<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
					<div id="tab_box" class="tab_box">
						<div id="tab_box_content0" class="tab_box_content">
							<table id="tableDoc" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4">文档编号： </td>
									<td class="inquire_form4"> <input  name="ucm_id_a" id="ucm_id_a" class="input_width" value="自动生成" type="text" readonly="readonly"/></td>
									<td class="inquire_item4">项目名称：</td>
									<td class="inquire_form4"> <input name="project_name" id="project_name" class="input_width" value="" type="text" readonly="readonly"/></td> 
				 
								</tr>
								<tr>
									<td class="inquire_item4">采集资料上交清单：</td>
									<td class="inquire_form4"  >
									<input name="commitments_id" id="commitments_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="doc_type" id="doc_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="" type="hidden" readonly="readonly"/>           
							           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="outsourcing" id="outsourcing" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="status_type" id="status_type" class="input_width" value="1" type="hidden" readonly="readonly"/>
							           	<input name="s_id" id="s_id" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="s_name" id="s_name" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="a_s_id" id="a_s_id" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	<input name="a_s_name" id="a_s_name" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	 <input name="parent_file_id" id="parent_file_id" class="input_width" value="<%=parent_file_id%>" type="hidden" readonly="readonly"/>
								 		<div id="down_0110000061100000024"></div>
									</td>
									<td  class="inquire_item4"><span class="red_star">*</span>处理解释任务书</td>
									<td  class="inquire_form4" >
									    <input type="hidden" id="pk_0110000061200000001" name="pk_0110000061200000001" value=""/>
										<input type="file" name="0110000061200000001" id="0110000061200000001" class="input_width"/>
					    				<div id="down_0110000061200000001"></div>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">下达人：</td>
									<td class="inquire_form4">
										<input type="text" id="give_people" name="give_people" value="" class="input_width" />
										 
									</td>
									<td class="inquire_item4"><span class="red_star">*</span>是否为外协人员：</td>
									<td class="inquire_form4"> 	否 <input type="radio" name="radioType" value="1" id="radioType1" onclick="radioValue()"/>  是<input type="radio" name="radioType" value="2" id="radioType2" onclick="radioValue()"/>  </td>
					 
								</tr>
								 <tr id="tr00">
									<td class="inquire_item4"><span class="red_star">*</span>处理人员：</td>
									<td class="inquire_form4">
										<input type="hidden" id="todeal_people_s_0" name="todeal_people_s_0" value=""/>	 <input type="hidden" id="bsflag_0" name="bsflag_0" value="0"/> 
								 		<input name="todeal_people_0" id="todeal_people_0" class="input_width" value="" type="text" readonly="readonly"/>
								 				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPeople('todeal_people',0)"/> 
									</td>
									<td></td>
									<td><img onclick="addRow('todeal_people',4)" src="<%=contextPath%>/images/images/zj.png" width="20" height="20" style="cursor: hand;"/></td>
					 
								</tr>
								<tr id="tr5">
									<td class="inquire_item4">处理计划开始时间：</td>
									<td class="inquire_form4">
									 	<input type="text" id="t_start_time" name="t_start_time" value="" class="input_width" readonly="readonly"/>
										 	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(t_start_time,tributton1);" />
									</td>
									<td class="inquire_item4">处理计划完成时间：</td>
									<td class="inquire_form4"> 
											 <input type="text" id="t_end_time" name="t_end_time" value="" class="input_width" readonly="readonly"/>
										 	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(t_end_time,tributton2);" /></td>
								</tr>
								  <tr id="tr10">
									<td class="inquire_item4"><span class="red_star">*</span>解释人员：</td>
									<td class="inquire_form4">
										<input type="hidden" id="explain_people_s_0" name="explain_people_s_0" value=""/> <input type="hidden" id="a_bsflag_0" name="a_bsflag_0" value="0"/> 
								 		<input name="explain_people_0" id="explain_people_0" class="input_width" value="" type="text" readonly="readonly"/>
								 				<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPeople('explain_people',0)"/>
									</td>
									<td></td>
									<td><img onclick="addRowA('explain_people',6)" src="<%=contextPath%>/images/images/zj.png" width="20" height="20" style="cursor: hand;"/></td>
					 
								</tr>
									<tr id="tr7">
									<td class="inquire_item4">解释计划开始时间：</td>
									<td class="inquire_form4">
									 	<input type="text" id="e_start_time" name="e_start_time" value="" class="input_width" readonly="readonly"/>
										 	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton3" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(e_start_time,tributton3);" />
								
										 
									</td>
									<td class="inquire_item4">解释计划完成时间：</td>
									<td class="inquire_form4"> 
									<input type="text" id="e_end_time" name="e_end_time" value="" class="input_width" readonly="readonly"/>
										 	&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton4" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(e_end_time,tributton4);" />
								
									</td>
					 
								</tr>
					 
									<tr id="tr8">
									<td class="inquire_item4">外协单位：</td>
									<td  colspan="3">
									  <input type="text" id="outsourcing_personnel" name="outsourcing_personnel" value=""  style="width:92%;height:24px;line-height: 24px;border:#a4b2c0 1px solid;background-color:#FFF;" />
										 
									</td>
					 
					 
								</tr>
								 <tr  >
									<td class="inquire_item4"> </td>
									<td  colspan="3">
									   	 
									</td> 
					 
								</tr>
								 
							</table>
						</div>
					</div>
					
				</div><div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="save()"></a>
						</span> <span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
			</div>
	</form>
</body>

<script language="javaScript">
var cruTitle = "资格证信息";
var jcdp_codes_items = null;
var jcdp_codes = new Array(
);

var jcdp_record = null;
/**
 表单字段要插入的数据库表定义
*/
var tables = new Array(
['comm_coding_sort_deatil']
);
var defaultTableName = 'comm_coding_sort_deatil';
/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，
   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，
             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，
   4最大输入长度，
   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，
           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，
           其他默认值
   6输入框的长度，7下拉框的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*
   9 Column Name，10 Event,11 Table Name
*/
	
cruConfig.contextPath =  "<%=contextPath%>";
var p_type = '<%=p_type%>';	

var fileId = '<%=id%>'
function checkForm(){
/* 	if (!isTextPropertyNotNull("writer", "上交人")) return false;
	if (!isLimitB20("writer","上交人")) return false; 
	  */
		var radioType= document.getElementById("outsourcing").value;
	  
  	if(p_type=='1'){ 
		if (!isTextPropertyNotNull("pk_0110000061200000001", "处理解释任务书")) return false;
		if(radioType =='1'){
			if (!isTextPropertyNotNull("s_id", "处理人员")) return false;
			if (!isTextPropertyNotNull("a_s_id", "解释人员")) return false;
		}
	}else{
		if (!isTextPropertyNotNull("0110000061200000001", "处理解释任务书新增")) return false;
		if(radioType =='1'){
			if (!isTextPropertyNotNull("s_id", "处理人员")) return false;
			if (!isTextPropertyNotNull("a_s_id", "解释人员")) return false;
		}
	}  
	
	return true;
}

function page_init(){
 
	var businessType = '<%=businessType%>';	
	var fileAbbr = '<%=fileAbbr%>';	

	
	if(fileId !='null'){
		var querySql = " select t.* from ( select  t.commitments_id, t.outsourcing_personnel,t.doc_type, to_char( t.give_time,'yyyy') year_s,t.project_info_no,  p.project_name,  t.tecnical_id,decode(t.status_type,   '1',   '未下达',  '2',  '已下达', t.status_type) proc_status_name,  t.give_people,t.outsourcing,t.todeal_people,t.todeal_people_s,t.t_start_time,t.t_end_time,t.explain_people,t.explain_people_s,t.e_start_time,t.e_end_time,t.give_time,t.status_type , f.file_id,  f.ucm_id ,  f.file_name,f2.file_id file_id_a, f2.file_abbr file_abbr_a, f2.ucm_id as ucm_id_a,  f2.file_name as file_name_a  from GP_WS_VSP_COMMITMENTS t  left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '0110000061100000024'  and bsflag = '0'  group by relation_id,  doc_file_type)) f  on t.tecnical_id = f.relation_id   left join (select *  from bgp_doc_gms_file  where ucm_id in  (select max(ucm_id)  from bgp_doc_gms_file  where doc_file_type =  '0110000061200000001'  and bsflag = '0'  group by relation_id,  doc_file_type)) f2  on t.commitments_id = f2.relation_id   left join gp_task_project p  on p.project_info_no = t.project_info_no  and p.bsflag = '0'  where t.bsflag = '0'  and t.doc_type = '0110000061200000001'   and t.commitments_id='"+fileId+"'   ) t ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas!=null && datas.length>0){
			document.getElementById("commitments_id").value = datas[0].commitments_id;
			document.getElementById("doc_type").value = datas[0].doc_type;
			document.getElementById("business_type").value = "<%=businessType%>";
 
			if(datas[0].ucm_id_a ==""){
				document.getElementById("ucm_id_a").value ="           ----自动生成----";
			}else{
				document.getElementById("ucm_id_a").value = datas[0].ucm_id_a;
			}
			document.getElementById("project_name").value = datas[0].project_name;
			document.getElementById("project_info_no").value = datas[0].project_info_no;
			document.getElementById("file_abbr").value = "<%=fileAbbr%>";
			document.getElementById("parent_file_id").value = "<%=parent_file_id%>";
			
			if(datas[0].status_type ==""){
				document.getElementById("status_type").value ="1";
			}else{
				document.getElementById("status_type").value =  datas[0].status_type;
			}
			
		
 
			var str=datas[0].file_name==""?"":datas[0].file_name.substr(0,30)+'...';
			$("#down_0110000061100000024").append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+datas[0].ucm_id+"&emflag=0>"+str+"</a>");
 
			if(datas[0].ucm_id_a!=""){
				document.getElementById("pk_0110000061200000001").value =datas[0].ucm_id_a;
				var str_a=datas[0].file_name_a==""?"":datas[0].file_name_a.substr(0,30)+'...';
				$("#down_0110000061200000001").append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+datas[0].ucm_id_a+"&emflag=0>"+str_a+"</a>");
	  		 }
			if(datas[0].give_people ==""){
				document.getElementById("give_people").value ="<%=userName%>";
			}else{
				document.getElementById("give_people").value = datas[0].give_people;
			}
			
			
			if (datas[0].outsourcing!=""){
				if(datas[0].outsourcing=="1"){ //否
					document.getElementById("radioType1").checked=true ;
					radioValue();
				}else{
					document.getElementById("radioType2").checked=true ;
					radioValue();
				}
				
			} else{
				document.getElementById("radioType1").checked=true ;
				radioValue();
			}
		 
			var t_people_s=datas[0].todeal_people_s.split(",");
			var t_people_name=datas[0].todeal_people.split(",");
	            if(t_people_s!=""){
					for(var i=0;i<t_people_s.length;i++){
						if(i>=1){
							addRow('todeal_people',4);
						}
					
						document.getElementById("todeal_people_s_"+i).value = t_people_s[i];
						document.getElementById("todeal_people_"+i).value = t_people_name[i];
					 
					}
	            }
				document.getElementById("t_start_time").value = datas[0].t_start_time;
				document.getElementById("t_end_time").value = datas[0].t_end_time;
				
				var e_people_s=datas[0].explain_people_s.split(",");
				var e_people_name=datas[0].explain_people.split(",");
			     if(e_people_s!=""){
					for(var j=0;j<e_people_s.length;j++){
						if(j>=1){
							addRowA('explain_people',6);
						}
					
						document.getElementById("explain_people_s_"+j).value = e_people_s[j];
						document.getElementById("explain_people_"+j).value = e_people_name[j];
					 
					}
			     }
					document.getElementById("e_start_time").value = datas[0].e_start_time;
					document.getElementById("e_end_time").value = datas[0].e_end_time;
					
					
					document.getElementById("outsourcing_personnel").value = datas[0].outsourcing_personnel;
		}
		 
	} 	<%-- else{
		document.getElementById("status_type").value = "1";
		document.getElementById("file_abbr").value = "<%=fileAbbr%>";
		document.getElementById("parent_file_id").value = "<%=parent_file_id%>";
		document.getElementById("commitments_id").value = fileId;
		document.getElementById("business_type").value = "<%=businessType%>";
		document.getElementById("doc_type").value = "<%=businessType%>";
		document.getElementById("give_people").value = datas[0].give_people;
	} --%>
	 
}

var ii=0;
var i_s=6;
var i_w=0;
function addRow(names,trNum){ 
	var num=++ii;
 
	i_s=++i_w; 
	var tr=document.all.tableDoc.insertRow(trNum);
	tr.id="tr0"+num;
  	tr.insertCell(0).innerHTML="<input type='hidden' id='"+names+"_s_"+num+"' name='"+names+"_s_"+num+"' value=''/><input type='hidden' id='bsflag_"+num+"' name='bsflag_"+num+"' value='0'/>";
 
	var td = tr.insertCell(1); 
	
	td.innerHTML="<input type='text' name='"+names+"_"+num+"' id='"+names+"_"+num+"' value='' readonly='readonly' class='input_width'/> <img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick="+"selectPeople('"+names+"',"+num+") />";

	tr.insertCell(2).innerHTML="";
	tr.insertCell(3).innerHTML="<img name='"+num+"'  onclick="+"delRow('"+names+"',"+num+")"+"  src='<%=contextPath%>/images/delete.png' width='20' height='20' style='cursor: hand;'/>";
	
}
 
var jj=0;
function addRowA(names,trNum){
	var num=++jj;
	var tr=document.all.tableDoc.insertRow(trNum+i_s);
	tr.id="tr1"+num;
  	tr.insertCell(0).innerHTML="<input type='hidden' id='"+names+"_s_"+num+"' name='"+names+"_s_"+num+"' value=''/> <input type='hidden' id='a_bsflag_"+num+"' name='a_bsflag_"+num+"' value='0'/>";
 
	var td = tr.insertCell(1); 
	td.innerHTML="<input type='text' name='"+names+"_"+num+"' id='"+names+"_"+num+"' value='' readonly='readonly' class='input_width'/> <img src='<%=contextPath%>/images/magnifier.gif' width='16' height='16' style='cursor:hand;' onclick="+"selectPeople('"+names+"',"+num+") />";

	tr.insertCell(2).innerHTML=""; 
	tr.insertCell(3).innerHTML="<img name='"+num+"' onclick="+"delRowA('"+names+"',"+num+")"+"  src='<%=contextPath%>/images/delete.png' width='20' height='20' style='cursor: hand;'/>";
	 
}
 

function selectPeople(names,num){  
    var result=showModalDialog('<%=contextPath%>/td/vspExplain/vspCommitments/vsp_human.jsp','','dialogWidth:500px;dialogHeight:500px;status:yes');
 
    if(result!="" && result!=undefined){
    	var checkStr=result.split(",");
    	for(var i=0;i<checkStr.length-1;i++){
    		var testTemp = checkStr[i].split("-");
    
	        document.getElementById(names+"_s_"+num).value=testTemp[5]; 
    	    document.getElementsByName(names+"_"+num)[0].value=testTemp[1];
  
       	}	
   }
 }

 

var str_s="";
function delRow(names,num){  

	//获得当前点击标签的附件ucm_id值 
   // var oldUcmId=$("#"+names+"_"+event.srcElement.name).val();
    str_s=num+","+str_s;
	document.getElementById("tr0"+num).style.display = "none";
    document.getElementById("bsflag_"+num).value="1";
    
	//alert(window.event.srcElement.parentElement.parentElement.rowIndex);
    //如果存在旧文件，则先删除
/* 	if(""!=oldUcmId&&null!==oldUcmId){
		if (!window.confirm("确认要删除吗?")) {
			return;
		}	
		var sql =" update bgp_doc_gms_file t set t.bsflag='1' where ucm_id="+oldUcmId;
		retObj = jcdpCallService("ProjectEvaluationSrv", "saveDatasBySql", "sql="+sql);
	} */
	                          
	//document.all.tableDoc.deleteRow(window.event.srcElement.parentElement.parentElement.rowIndex);--i_s;--i_w;

}

var a_str_s="";
function delRowA(names,num){  
	a_str_s=num+","+a_str_s;
	document.getElementById("tr1"+num).style.display = "none";
    document.getElementById("a_bsflag_"+num).value="1";
   
}

function delRowRadio(names,names_a,num){  
    for ( c=0;c<num;c++){  
		document.getElementById(names+c).style.display = "none";
	    document.getElementById(names_a+"_"+c).value="1";
    }
}

function delRowRadio_A(names,names_a,num){  
    for ( c=0;c<num;c++){  
		document.getElementById(names+c).style.display = "";
	    document.getElementById(names_a+"_"+c).value="0";
    }
}


function radioValue(){  
	 l=document.getElementsByName("radioType")  
	 for(i=0;i<l.length;i++)  
	 {  
		 if(l[i].checked)  
		 {
		 	 if(l[i].value =='1'){
		 		delRowRadio_A('tr0','bsflag',ii+1);
		 		delRowRadio_A('tr1','a_bsflag',jj+1);
		 		document.getElementById("outsourcing").value = "1";
		 		document.getElementById("tr00").style.display = "";
		 		document.getElementById("tr5").style.display = "";
		 		document.getElementById("tr10").style.display = "";
		 		document.getElementById("tr7").style.display = "";
		 		document.getElementById("tr8").style.display = "none";
		 		
		 	 
		 	 }
			 if(l[i].value =='2'){ 
			 
			 delRowRadio('tr0','bsflag',ii+1);
			 delRowRadio('tr1','a_bsflag',jj+1);
 
			 		document.getElementById("outsourcing").value = "2";
			 		document.getElementById("tr00").style.display = "none";
			 		document.getElementById("tr5").style.display = "none";
			 		document.getElementById("tr10").style.display = "none";
			 		document.getElementById("tr7").style.display = "none";
			 		document.getElementById("tr8").style.display = "";
			 		
			 }
			 			 
		 }

	 }  
	 
}  
function save(){
	//处理保存name，id格式
	//ii 点击按钮次数
	//str_s 为删除 标识 ，数组类型
 
	var s_id="";  
	var s_name="";  
	var str_A=str_s.split(","); 
	for(var a=0;a<=ii;a++){  
		var bsflag=document.getElementById("bsflag_"+a).value;
		if(bsflag=="0"){
			var id=document.getElementById("todeal_people_s_"+a).value ;
			var name=document.getElementById("todeal_people_"+a).value ;
			s_id=s_id+","+id;
			s_name=s_name+","+name;
		}
 
	}
	var reg=/,$/gi;
	if (s_name.substr(0,1)==',')  s_name=s_name.substr(1); s_name=s_name.replace(reg,"");
	if (s_id.substr(0,1)==',') s_id=s_id.substr(1);  s_id=s_id.replace(reg,""); 
  
	
	var a_s_id="";  
	var a_s_name="";  
	var a_str_A=a_str_s.split(","); 
	for(var b=0;b<=jj;b++){  
		var a_bsflag=document.getElementById("a_bsflag_"+b).value;
		if(a_bsflag=="0"){
			var a_id=document.getElementById("explain_people_s_"+b).value ;
			var a_name=document.getElementById("explain_people_"+b).value ;
			a_s_id=a_s_id+","+a_id;
			a_s_name=a_s_name+","+a_name;
		}
 
	}
 
	if (a_s_name.substr(0,1)==',') a_s_name=a_s_name.substr(1); a_s_name=a_s_name.replace(reg,""); 
	if (a_s_id.substr(0,1)==',') a_s_id=a_s_id.substr(1); a_s_id=a_s_id.replace(reg,""); 
	
	
	document.getElementById("s_id").value =s_id;
	document.getElementById("s_name").value =s_name;
	document.getElementById("a_s_id").value =a_s_id;
	document.getElementById("a_s_name").value =a_s_name;
	 
	
 	if (!checkForm()) return;
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/ws/toSaveVspListDoc.srq?businessType=<%=businessType%>";
	form.submit();
	newClose(); 
}
 

</script>

</html>
