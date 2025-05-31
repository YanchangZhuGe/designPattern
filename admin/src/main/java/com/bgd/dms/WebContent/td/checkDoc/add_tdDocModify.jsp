<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.bgp.gms.service.td.pojo.BgpDocTdFileCheck"%>
<%@page import="com.bgp.gms.service.td.pojo.BgpDocTdFileCheckData"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userId = (user==null)?"":user.getEmpId();
    String projectInfoNo = user.getProjectInfoNo();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    

	//处理申请单信息
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	BgpDocTdFileCheck applyInfo = (BgpDocTdFileCheck) resultMsg
			.getMsgElement("applyInfo").toPojo(
					BgpDocTdFileCheck.class);

	List<MsgElement> list = resultMsg.getMsgElements("detailInfo");
	List<BgpDocTdFileCheckData> beanList=new ArrayList<BgpDocTdFileCheckData>(0);
	if(list!=null){
		beanList = new ArrayList<BgpDocTdFileCheckData>(list.size());	
		for (int i = 0; i < list.size(); i++) {
			beanList.add((BgpDocTdFileCheckData) list.get(i).toPojo(
					BgpDocTdFileCheckData.class));
		}
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
	<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
  <link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
  <link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
  <link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
  <link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
  <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
  <script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
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
	cruConfig.openerUrl = "/td/doc/tdDocList.jsp";
	cru_init();
	
}

function save(){
	if(checkForm()){
		var form = document.getElementById("CheckForm");
		form.action = "<%=contextPath%>/td/toSaveCheckDoc.srq";
		form.submit();
		newClose();
	}
}

function notNullForCheck(filedName,fieldInfo){

	if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
		alert(fieldInfo+"不能为空");
		document.getElementById(filedName).onfocus="true";
		return false;
	}else{
		return true;
	}
}

function checkForm(){
//	if(!notNullForCheck("docType","文档类型")) return false;

   var checkId = document.getElementById("checkId").value;
   var projectInfoNo = document.getElementById("projectInfoNo").value;
   var uploadDate = document.getElementById("uploadDate").value;
   var docType = document.getElementById("docType").value;
   
   if(checkId == ''){
  	    var querySql = "select t.check_id from bgp_doc_td_file_check t where t.bsflag = '0'  and t.project_info_no = '"+projectInfoNo+"' and t.doc_type = '"+docType+"' and t.upload_date = to_date('"+uploadDate+"','yyyy-MM-dd') ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas != null && queryRet.datas.length>0){
			alert("检查日期已存在!");
			   return false;
		}
   }
   var rowNum = document.getElementById("equipmentSize").value;	
   var check=true;
   for(var i=0;i<rowNum;i++){
	   var one = document.getElementById("fy"+i+"check");
	   if(one.checked){
		   check=false;
	   }	   
   }
   if(check){
	   alert("请选择检查项!");
	   return false;
   }
     
   return true;

}

function addLine(){
	
	var rowNum = document.getElementById("equipmentSize").value;	

	var tr = document.getElementById("lineTable").insertRow();
	
	tr.align="center";		

	tr.id = "fy" + rowNum + "trflag";
	
	if(rowNum % 2 == 1){  
  		classCss = "even_";
	}else{ 
		classCss = "odd_";
	}
	
	var td = tr.insertCell(0);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="checkbox" name="fy'+ rowNum +'check" id="fy'+ rowNum +'check" />'+'<input type="hidden" name="fy'+ rowNum + 'dataId" id="fy'+ rowNum + 'dataId"  value=""/>';
			
	var td = tr.insertCell(1);
	td.className=classCss+"even";
	td.innerHTML = '<input type="text" name="fy'+ rowNum + 'checkCodeName" id="fy'+ rowNum + 'checkCodeName"  class="input_width" value=""/>';
		
	var td = tr.insertCell(2);
	td.className=classCss+"odd";
	td.innerHTML = '<select class="select_width" name="fy'+ rowNum + 'isComplete" id="fy'+ rowNum + 'isComplete" > <option value="0">是</option><option value="1" style="color:red" >否</option> </select>';

	var td = tr.insertCell(3);
	td.className=classCss+"even";
	td.innerHTML = '<select class="select_width" name="fy'+ rowNum + 'isPass" id="fy'+ rowNum + 'isPass" > <option value="0">是</option><option value="1" style="color:red" >否</option> </select>';

	var td = tr.insertCell(4);
	td.className=classCss+"odd";
	td.innerHTML = '<input type="text" name="fy'+ rowNum + 'notes" id="fy'+ rowNum + 'notes"  class="input_width" value=""/>';
	
	var td = tr.insertCell(5);
	td.className=classCss+"even";
	td.innerHTML = '<span class="sc"><a href="#"  onclick="deleteLine(\'fy' + rowNum +'\')"></a></span>';
	
	document.getElementById("equipmentSize").value = parseInt(rowNum) + 1;
}

function deleteLine(lineId){		

	var check = document.getElementById(lineId+"check");		
	var line = document.getElementById(lineId+"trflag");		
	
	check.checked=false;
	line.style.display = 'none';
	
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
</script>
</head>
<body style="overflow-y:auto">
<form id="CheckForm" action="" method="post" target="list" enctype="multipart/form-data">
    <div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
 	 <tr>
 	       <td class="inquire_item4">检查人：</td>
           <td class="inquire_form4">
           <input name="docType" id="docType" class="input_width" value="<%=applyInfo.getDocType()==null?"":applyInfo.getDocType()%>" type="hidden" readonly="readonly"/>
           <input name="checkId" id="checkId" class="input_width" value="<%=applyInfo.getCheckId()==null?"":applyInfo.getCheckId()%>" type="hidden" readonly="readonly"/>
           <input name="uploadId" id="uploadId" class="input_width" value="<%=applyInfo.getUploadId()==null?"":applyInfo.getUploadId()%>" type="hidden" readonly="readonly"/>
           <input name="uploadName" id="uploadName" class="input_width" value="<%=applyInfo.getUploadName()==null?"":applyInfo.getUploadName()%>" type="text" readonly="readonly"/>           
           <input name="projectInfoNo" id="projectInfoNo" class="input_width" value="<%=applyInfo.getProjectInfoNo()==null?"":applyInfo.getProjectInfoNo()%>" type="hidden" readonly="readonly"/>
           </td>
           <td class="inquire_item4">检查日期：</td>
           <td class="inquire_form4">
           <input name="uploadDate" id="uploadDate" class="input_width" value="<%=applyInfo.getUploadDate()==null?curDate:applyInfo.getUploadDate()%>" type="text" />    
           <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;"
			onmouseover="calDateSelector(uploadDate,tributton1);" />      
           </td>
	  </tr>	           
 	</table>
	</div>  
	<div style="width:100%;overflow-x:scroll;overflow-y:scroll;"> 	
	
		<div id="inq_tool_box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
		    <td background="<%=contextPath%>/images/list_15.png">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr align="right">
			<td width="88%">&nbsp;</td>
		    <td>
		    <span class="zj" ><a href="#" onclick="addLine()"></a></span>
		    </td>
		  </tr>
		</table>
		</td>
		    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
		  </tr>
		</table>
	  </div>
			
	<table id="lineTable" width="100%" border="0" cellspacing="0" cellpadding="0"  style="margin-top:2px;" >
    	<tr>
    	    <td class="bt_info_odd">选择</td>
    	    <td class="bt_info_even">检查项目</td>
            <td class="bt_info_odd">是否齐全</td>
            <td class="bt_info_even">是否合格</td>		
            <td class="bt_info_odd">备注</td>
            <td class="bt_info_even">操作 <input type="hidden" id="equipmentSize" name="equipmentSize" value="<%=beanList.size()%>" /></td>
        </tr>
        
       <%
		for (int i = 0; i < beanList.size(); i++) {
			String className = "";
			if (i % 2 == 0) {
				className = "odd_";
			} else {
				className = "even_";
			}
			BgpDocTdFileCheckData applyDetailInfo = beanList.get(i);
			String ss="fy"+String.valueOf(i)+"deviceUnit";
	  %>
		<tr id="fy<%=i%>trflag">
		<td class="<%=className%>odd">
		 <input type="checkbox"  id="fy<%=i%>check" name="fy<%=i%>check" <%if(applyDetailInfo.getDataId()!=null){ %>checked="checked"<% }%>/>
		 <input type="hidden" value="<%=applyDetailInfo.getDataId()==null?"":applyDetailInfo.getDataId()%>" id="fy<%=i%>dataId" name="fy<%=i%>dataId" class="input_width" />
		</td>
		<td class="<%=className%>even">
		<input type="hidden" value="<%=applyDetailInfo.getCheckCode()==null?"":applyDetailInfo.getCheckCode()%>" id="fy<%=i%>checkCode" name="fy<%=i%>checkCode" class="input_width" />
		<input type="text" value="<%=applyDetailInfo.getCheckCodeName()==null?"":applyDetailInfo.getCheckCodeName()%>" id="fy<%=i%>checkCodeName" name="fy<%=i%>checkCodeName" class="input_width" />
		</td>
		<td class="<%=className%>odd">
		<select  id="fy<%=i%>isComplete" name="fy<%=i%>isComplete" class="select_width"  >
		<option value='0' <%if("0".equals(applyDetailInfo.getIsComplete())){ %>  selected="selected" <% }%>>是</option>
		<option value='1' <%if("1".equals(applyDetailInfo.getIsComplete())){ %>  selected="selected" <% }%> style="color:red"> 否</option>
		</select>
		</td>
		<td class="<%=className%>even">
		<select  id="fy<%=i%>isPass" name="fy<%=i%>isPass" class="select_width"  >
		<option value='0' <%if("0".equals(applyDetailInfo.getIsPass())){ %>  selected="selected" <% }%>>是</option>
		<option value='1' <%if("1".equals(applyDetailInfo.getIsPass())){ %>  selected="selected" <% }%> style="color:red">否</option>
		</select>
		</td>
		<td class="<%=className%>odd">
		<input id="fy<%=i%>notes" name="fy<%=i%>notes" type="text" value="<%=applyDetailInfo.getNotes()==null?"":applyDetailInfo.getNotes()%>" class="input_width" type="text" />
		</td>
		<td class="<%=className%>even">
		<span class="sc"><a href="#" onclick="deleteLine('fy<%=i%>')"></a></span>
		</td>		
		</tr>	
	 <%
		}
	  %>
     </table>
     </div>
    <div id="oper_div">
		<span class="tj_btn"><a href="#" onclick="save()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</form>
</body>
</html>
