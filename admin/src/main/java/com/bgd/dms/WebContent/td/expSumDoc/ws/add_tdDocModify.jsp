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
    String projectType = user.getProjectType();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    String action=request.getParameter("action")==null?"":request.getParameter("action");
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
var action="<%=action%>";
var projectType="<%=projectType%>";

function page_init(){
	getObj('cruTitle').innerHTML = cruTitle;
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
	
}

function save(){
	if (!checkForm()) return;
	var form = document.getElementById("CheckForm");
	form.action = "<%=contextPath%>/td/ws/toSaveExpSumDoc.srq";
	form.submit();
	newClose();
}

function checkForm(){
	if (!isTextPropertyNotNull("title", "标题")) return false;	
	if (!isLimitB100("title","标题")) return false;  
	if (!isLimitB20("test_project","项目名称")) return false; 
	return true;
}

function page_init(){
	var fileId = '<%=request.getParameter("id")%>';	
	var businessType = '<%=request.getParameter("businessType")%>';	
	var fileAbbr = '<%=request.getParameter("fileAbbr")%>';	
	var docType = '<%=request.getParameter("docType")%>';	
	
	if(fileId!='null'){
		var querySql = " select * from(select t.file_id,t.ucm_id,t.file_abbr,b.business_type,t.doc_file_type,t.file_name,t.doc_type,b.tecnical_id,b.title,b.test_project,b.test_start_date,b.test_end_date from gp_ws_tecnical_basic b left join bgp_doc_gms_file t on  b.tecnical_id = t.relation_id and t.bsflag='0')m where m.tecnical_id ='"+fileId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas!=null && datas.length>0){
			document.getElementById("tecnical_id").value = datas[0].tecnical_id;
			document.getElementById("title").value = datas[0].title;
			document.getElementById("test_project").value = datas[0].test_project;
			document.getElementById("test_start_date").value = datas[0].test_start_date;
			document.getElementById("test_end_date").value = datas[0].test_end_date;
			document.getElementById("doc_type").value = datas[0].doc_type;
			var ii=-1;
			var jj=-1;
			for(var i=0;i<datas.length;i++){
				if(""!=datas[i].ucm_id){
					var ucmId=datas[i].ucm_id;
					if("0110000061100000014"==datas[i].doc_file_type&&null!=datas[i].doc_file_type){
						++ii;
						if(ii>=1){
							addRow();
						}
						document.getElementById("pk_0110000061100000014_"+ii).value =ucmId;
						var str=datas[i].file_name==""?"":datas[i].file_name.substr(0,10)+'...';
						$("#down_0110000061100000014_"+ii).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>"+str+"</a>");
					}else if("0110000061100000015"==datas[i].doc_file_type&&null!=datas[i].doc_file_type){
						++jj;
						if(jj>=1){
							addRow1();
						}
						document.getElementById("pk_0110000061100000015_"+jj).value =ucmId;
						var str=datas[i].file_name==""?"":datas[i].file_name.substr(0,10)+'...';
						$("#down_0110000061100000015_"+jj).append("&nbsp;<a style='color:blue;'  href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+ucmId+"&emflag=0>"+str+"</a>");
					}
				}
			}
		}
	}else{
		document.getElementById("business_type").value = businessType;
		document.getElementById("file_abbr").value = fileAbbr;
		document.getElementById("doc_type").value = docType;
	}		
}


var i=0;
var j=0;
function addRow(){
	var num=++i;
	var tr=document.all.tableDoc.insertRow(4);
  	tr.insertCell(0).innerHTML="<input type='hidden' id='pk_0110000061100000014_"+num+"' name='pk_0110000061100000014_"+num+"' value=''/>";
  	
	var td = tr.insertCell(1);
	td.setAttribute("colspan",3);
	td.innerHTML="<input type='file' name='0110000061100000014_"+num+"' id='0110000061100000014_"+num+"' class='input_width'/><div id='down_0110000061100000014_"+num+"'></div>";

	tr.insertCell(2).innerHTML="";
	if("view"!=action){
		tr.insertCell(3).innerHTML="<img name='"+num+"' id='0110000061100000014' onclick='delRow()' src='<%=contextPath%>/images/delete.png' width='20' height='20'/>";
	}
	
}

function addRow1(){
	var num=++j;
	var tr=document.all.tableDoc.insertRow();
  	tr.insertCell(0).innerHTML="<input type='hidden' id='pk_0110000061100000015_"+num+"' name='pk_0110000061100000015_"+num+"' value=''/>";
  	
	var td = tr.insertCell(1);
	td.setAttribute("colspan",3);
	td.innerHTML="<input type='file' name='0110000061100000015_"+num+"' id='0110000061100000015_"+num+"' class='input_width'/><div id='down_0110000061100000015_"+num+"'></div>";

	tr.insertCell(2).innerHTML="";
	if("view"!=action){
		tr.insertCell(3).innerHTML="<img name='"+num+"' id='0110000061100000015' onclick='delRow()' src='<%=contextPath%>/images/delete.png' width='20' height='20' style='cursor: hand;'/>";
	}
}

function delRow(){
	//获得当前点击标签的附件ucm_id值 
    var oldUcmId=$("#pk_"+event.srcElement.id+"_"+event.srcElement.name).val();
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
							<table id="tableDoc" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
								<tr>
									<td class="inquire_item6"><span class="red_star">*</span>标题：</td>
									<td class="inquire_form6" colspan="3">
									<input name="tecnical_id" id="tecnical_id" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input name="business_type" id="business_type" class="input_width" value="" type="hidden" readonly="readonly"/>
							            <input name="file_id" id="file_id" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="project_info_no" id="project_info_no" class="input_width" value="<%=projectInfoNo%>" type="hidden" readonly="readonly"/>           
								     	<input name="doc_type" id="doc_type" class="input_width" value="" type="hidden" readonly="readonly"/>
								        <input name="file_abbr" id="file_abbr" class="input_width" value="" type="hidden" readonly="readonly"/>
										<input type="text" id="title" name="title" value="" style="width:92%;height:24px;line-height: 24px;border:#a4b2c0 1px solid;background-color:#FFF;"/>
									</td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td class="inquire_item6">试验项目：</td>
									<td class="inquire_form6" colspan="3">
										<input type="text" id="test_project" name="test_project" value="" style="width:92%;height:24px;line-height: 24px;border:#a4b2c0 1px solid;background-color:#FFF;"/>
									</td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td class="inquire_item6">试验开始日期：</td>
									<td class="inquire_form6">
										<input type="text" id="test_start_date" name="test_start_date" value="" class="input_width" readonly="readonly"/>
										<%if(!"view".equals(action)){%>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(test_start_date,tributton1);" />
										<%}%>
									</td>
									<td class="inquire_item6">试验结束日期：</td>
									<td class="inquire_form6">
										<input type="text" id="test_end_date" name="test_end_date" value="" class="input_width" readonly="readonly"/>
										<%if(!"view".equals(action)){%>
										&nbsp;&nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(test_end_date,tributton2);" />
										<%}%>
									</td>
									<td class="inquire_item6"></td>
									<td class="inquire_form6"></td>
								</tr>
								<tr>
									<td class="inquire_item6"><label id="labelName" name="labelName" >试验数据：</label></td>
									<td colspan="3">
										<input type="hidden" id="pk_0110000061100000014_0" name="pk_0110000061100000014_0" value=""/>
										<input type="file" name="0110000061100000014_0" id="0110000061100000014_0" class="input_width"/>
										<div id="down_0110000061100000014_0"></div>
									</td>
									<td></td>
									<td><img id="add_1" onclick="addRow()" src="<%=contextPath%>/images/images/zj.png" width="20" height="20" style="cursor: hand;"/></td>
								</tr>
								<tr>
									<td class="inquire_item6">试验图件：</td>
									<td colspan="3">
										<input type="hidden" id="pk_0110000061100000015_0" name="pk_0110000061100000015_0" value=""/>
										<input type="file" name="0110000061100000015_0" id="0110000061100000015_0" class="input_width"/>
										<div id="down_0110000061100000015_0"></div>
									</td>
									<td></td>
									<td><img id="add_2" onclick="addRow1()" src="<%=contextPath%>/images/images/zj.png" width="20" height="20" style="cursor: hand;"/></td>
								</tr>
							</table>
						</div>
					</div>
					<%if(!"view".equals(action)){%>
					<div id="oper_div">
						<span class="tj_btn"><a href="#" onclick="save()"></a>
						</span> <span class="gb_btn"><a href="#" onclick="newClose()"></a>
						</span>
					</div>
					<%}%>
				</div>
			</div>
	</form>
<script type="text/javascript">
//审批页面 隐藏添加图片按钮
if("view"==action){
	$("[id^=add_]").css("display","none");
}

if("5000100004000000008" == projectType){
	document.getElementById("labelName").innerText="审查意见书"; 
}
</script>
</body>
</html>
