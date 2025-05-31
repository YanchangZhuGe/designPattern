<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
    String projectInfoNo = user.getProjectInfoNo();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    String businessType = request.getParameter("businessType")==null?"":request.getParameter("businessType");
    String parent_file_id = request.getParameter("parent_file_id")==null?"":request.getParameter("parent_file_id");
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

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
	
}

function save(){
	if (!checkForm()) return;
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/ws/toSaveworkAcceptanceDoc.srq?businessType=<%=businessType%>";
	form.submit();
	newClose();
}
var fileId = '<%=request.getParameter("id")%>';	
function checkForm(){
	if (!isTextPropertyNotNull("title", "标题")) return false;	
	if (!isLimitB100("title","标题")) return false;  
	if (!isLimitB20("writer","参加人员")) return false; 
	if (!isLimitB20("auditor","负责人")) return false;


	if(fileId!='null'){ 
		if (!isTextPropertyNotNull("pk_0110000061100000013", "收工验收报告")) return false;	
	}else{
		if (!isTextPropertyNotNull("0110000061100000013", "收工验收报告")) return false;	
		
	}
	
	return true;
}

function page_init(){

	var businessType = '<%=businessType%>';	
	var fileAbbr = '<%=request.getParameter("fileAbbr")%>';	

	if(fileId!='null'){
  
		
		var querySql = " select * from(select  b.business_type, b.tecnical_id,b.title,b.written_time,b.writer,b.auditor from gp_ws_tecnical_basic b  )m where     m.tecnical_id ='"+fileId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
			if(datas!=null && datas.length>0){
				document.getElementById("tecnical_id").value = datas[0].tecnical_id;
				document.getElementById("title").value = datas[0].title;
				document.getElementById("written_time").value = datas[0].written_time;
				document.getElementById("writer").value = datas[0].writer;
				document.getElementById("auditor").value = datas[0].auditor;
				
			 
			}
			var querySqlA = " select * from(select t.file_id,t.ucm_id,t.file_abbr,b.business_type,t.doc_file_type,t.file_name,b.tecnical_id,b.line_no,b.title,b.writer,b.point ,t.create_date  from gp_ws_tecnical_basic b left join bgp_doc_gms_file t on  b.tecnical_id = t.relation_id and t.bsflag='0')m where   m.doc_file_type='0110000061100000131'  and  m.tecnical_id ='"+fileId+"'  order by  create_date asc ";
			var queryRetA = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySqlA);
			var datasA = queryRetA.datas;
			if(datasA!=null && datasA.length>0){
	 
				for(var i=0;i<datasA.length;i++){
					if(""!=datasA[i].ucm_id){
						var ucmIdA=datasA[i].ucm_id;
						if(i>=1){
							addRow();
						}
						
						document.getElementById("pk_0110000061100000131_"+i).value =ucmIdA;
						var str=datasA[i].file_name==""?"":datasA[i].file_name.substr(0,10)+'...';
						$("#down_0110000061100000131_"+i).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmIdA+"&emflag=0>"+str+"</a>");
	 
					}
				}
			}
			
			var querySqlB = " select * from(select t.file_id,t.ucm_id,t.file_abbr,b.business_type,t.doc_file_type,t.file_name,b.tecnical_id,b.title,b.written_time,b.writer,b.auditor from gp_ws_tecnical_basic b left join bgp_doc_gms_file t on  b.tecnical_id = t.relation_id and t.bsflag='0')m where  m.doc_file_type='0110000061100000013'  and m.tecnical_id ='"+fileId+"'";
			var queryRetB = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySqlB);
			var datasB = queryRetB.datas;
				if(datasB!=null && datasB.length>0){ 
					for(var i=0;i<datasB.length;i++){
						if(""!=datasB[i].ucm_id){
							var ucmIdB=datasB[i].ucm_id; 
							
							document.getElementById("pk_"+datasB[i].doc_file_type).value =ucmIdB;
							$("#down_"+datasB[i].doc_file_type).html("");
							$("#down_"+datasB[i].doc_file_type).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmIdB+"&emflag=0>"+datasB[i].file_name+"</a>");
						}
					}
				}
		
		 
		
	}else{
		document.getElementById("business_type").value = businessType;
		document.getElementById("file_abbr").value = fileAbbr;
	}		
}


 
var i=0;
function addRow(){ 
	var num=++i;
	var tr=document.all.tableDoc.insertRow();
  	tr.insertCell(0).innerHTML="<input type='hidden' id='pk_0110000061100000131_"+num+"' name='pk_0110000061100000131_"+num+"' value=''/>";
  	
	var td = tr.insertCell(1);
	td.setAttribute("colspan",3);
	td.innerHTML="<input type='file' name='0110000061100000131_"+num+"' id='0110000061100000131_"+num+"' class='input_width'/><div id='down_0110000061100000131_"+num+"'></div>";

	tr.insertCell(2).innerHTML="";
	tr.insertCell(3).innerHTML="<img name='"+num+"' onclick='delRow()' src='<%=contextPath%>/images/delete.png' width='20' height='20' style='cursor: hand;'/>";
	
}

function delRow(){
	//获得当前点击标签的附件ucm_id值 
    var oldUcmId=$("#pk_0110000061100000131_"+event.srcElement.name).val();
    //如果存在旧文件，则先删除
	if(""!=oldUcmId&&null!==oldUcmId){
		if (!window.confirm("确认要删除吗?")) {
			return;
		}	
		var sql =" update bgp_doc_gms_file t set t.bsflag='1' where ucm_id="+oldUcmId;
		retObj = jcdpCallService("ProjectEvaluationSrv", "saveDatasBySql", "sql="+sql);
	}
	                          
	document.all.tableDoc.deleteRow(window.event.srcElement.parentElement.parentElement.rowIndex);
}


</script>
</head>
<body onload="page_init();">
	<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
			<div id="new_table_box_content">
				<div id="new_table_box_bg" >
					<div id="tab_box" class="tab_box">
						<div id="tab_box_content0" class="tab_box_content">
							<table id="tableDoc"   width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
									<td class="inquire_item4"></td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>标题：</td>
									<td class="inquire_form4" colspan="2">
									<input name="tecnical_id" id="tecnical_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>           
							           	<input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>
							           	 <input name="parent_file_id" id="parent_file_id" class="input_width" value="<%=parent_file_id%>" type="hidden" readonly="readonly"/>
										<input type="text" id="title" name="title" value="" style="width:92%;height:24px;line-height: 24px;border:#a4b2c0 1px solid;background-color:#FFF;"/>
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">参加人员：</td>
									<td class="inquire_form4"><input type="text" id="writer" name="writer" value="" class="input_width"/></td>
									<td class="inquire_item4">验收时间：</td>
									<td class="inquire_form4">
										<input type="text" id="written_time" name="written_time" value="" class="input_width" readonly="readonly"/>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(written_time,tributton1);" />
									</td>
								</tr>
								<tr>
									<td class="inquire_item4">负责人：</td>
									<td class="inquire_form4"><input type="text" id="auditor" name="auditor" value="" class="input_width" /></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td class="inquire_item4"><span class="red_star">*</span>收工验收报告：</td>
									<td colspan="2">
										<input type="hidden" id="pk_0110000061100000013" name="pk_0110000061100000013" value=""/>
										<input type="file" name="0110000061100000013" id="0110000061100000013" class="input_width"/>
					    				<div id="down_0110000061100000013"></div>
									</td>
									<td class="inquire_form4"></td>
								</tr>
								<tr>
								<td class="inquire_item4">收工验收检查表：</td>
								<td colspan="2">
									<input type="hidden" id="pk_0110000061100000131_0" name="pk_0110000061100000131_0" value=""/>
									<input type="file" name="0110000061100000131_0" id="0110000061100000131_0" class="input_width"/>
									<div id="down_0110000061100000131_0"></div>
								</td>
			 
								<td  class="inquire_form4" ><img onclick="addRow()" src="<%=contextPath%>/images/images/zj.png" width="20" height="20" style="cursor: hand;"/></td>
							</tr>
							</table>
						</div>
					</div>
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="save()"></a>
						</span> <span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
				</div>
			</div>
	</form>
</body>
</html>
