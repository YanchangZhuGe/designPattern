<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	
	String orgSubId = request.getParameter("orgSubId");
	String codingCode = request.getParameter("codingCode");
	if(codingCode == null || codingCode.equals("")){
		codingCode = resultMsg.getValue("codingCode");
	}
	if (orgSubId == null || orgSubId.equals("")){
		orgSubId = user.getOrgSubjectionId();
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>

<title>资格证信息</title>
</head>

<body style="background:#fff" onload="refreshData();queryCertificateList();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png">
				    <table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td class="ali_cdn_name">资格证书类别</td>
					    <td class="ali_cdn_input"><select  class="select_width" id="coding_code_id"  name="coding_code_id" ></select></td>
					    <td class="ali_query">
				    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    		</td>
					    <td class="ali_query">
						    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
						</td>
					    <td>&nbsp;</td>
						<auth:ListButton functionId="" css="xz" event="onclick='toDownload()'" title="JCDP_btn_download"></auth:ListButton>
					    <auth:ListButton functionId="" css="dc" event="onclick='exportData()'" title="JCDP_btn_export"></auth:ListButton>

					  </tr>
					</table>
				</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>
		      		<td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{coding_code_id}' id='rdo_entity_id'  />" >选择</td>
					 <td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{coding_name}">资格证书类别</td>
					<td class="bt_info_even" exp="{sumnum}">总计</td>
					<td class="bt_info_odd" exp="{later}">过期</td>
			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
			  <tr>
			    <td align="right">第1/1页，共0条记录</td>
			    <td width="10">&nbsp;</td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_01.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_02.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_03.png" width="20" height="20" /></td>
			    <td width="30"><img src="<%=contextPath%>/images/fenye_04.png" width="20" height="20" /></td>
			    <td width="50">到 
			      <label>
			        <input type="text" name="textfield" id="textfield" style="width:20px;" />
			      </label></td>
			    <td align="left"><img src="<%=contextPath%>/images/fenye_go.png" width="22" height="22" /></td>
			  </tr>
			</table>
			</div>
			<div class="lashen" id="line"></div>
			<div id="tag-container_3">
			  <ul id="tags" class="tags">
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">人员</a></li>

			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">备注</a></li>
			    <li id="tag3_2"><a href="#" onclick="getTab3(2)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
					<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
					    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
					    <td background="<%=contextPath%>/images/list_15.png">
						    <table width="100%" border="0" cellspacing="0" cellpadding="0">
							  <tr>
							    <td>&nbsp;</td>
								    <auth:ListButton functionId="F_HUMAN_001" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
								    <auth:ListButton functionId="F_HUMAN_001" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton>
					    			<auth:ListButton functionId="F_HUMAN_001" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
					    			
							  </tr>
							</table>
						</td>
					    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
					  </tr>
					</table>
					</div>
			
					<table id="certificateMap" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" style="margin-top:2px;" >
				    	<tr class="bt_info">
				    	    <td>选择</td>
				            <td>姓名</td>
				            <td>工作单位</td>		
				            <td>资格证名称</td>
				            <td>资格证编号</td>
				            <td>培训机构</td>			
				            <td>签发单位</td>          
				            <td>签发日期</td>
				            <td>有效期</td>
				            <td>附件</td>
				        </tr>            
			        </table>
				</div>


				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>
				<div id="tab_box_content2" class="tab_box_content" style="display:none;">
				<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
				
			</div>
		  </div>

</body>
<script type="text/javascript">


function testRefresh(){
	alert();
}
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();

$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>
<script type="text/javascript">
cruConfig.contextPath =  "<%=contextPath%>";

//	cruConfig.queryStr = "";
//	cruConfig.queryService = "ucmSrv";
//	cruConfig.queryOp = "getDocsInFolder";
//  cruConfig.queryRetTable_id = "";
	var orgSubId = "<%=orgSubId%>";	
	var codingCode = "<%=codingCode%>";	
	
	function refreshData(id){
		if(id!=undefined){
			orgSubId = id;
		}
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "select t.coding_code_id, t.coding_name, count(s.certificate_no) sumnum, count(s1.certificate_no) later from comm_human_coding_sort t left join bgp_comm_human_certificate s on t.coding_code_id = s.coding_code_id and t.coding_lever = '2' and s.bsflag = '0' left join bgp_comm_human_certificate s1 on t.coding_code_id = s1.coding_code_id and t.coding_lever = '2' and s1.bsflag = '0' and s1.validity < sysdate  and s.certificate_no=s1.certificate_no left join comm_human_employee e on s.employee_id = e.employee_id and e.bsflag = '0' left join comm_org_subjection su on s.work_unit = su.org_id and su.bsflag='0'  left join comm_org_subjection su1 on s.work_unit = su1.org_id  and su1.bsflag = '0' where t.bsflag = '0' and t.superior_code_id='"+codingCode+"' and  (su.org_subjection_id like '"+orgSubId+"%' or su1.org_subjection_id like '"+orgSubId+"%') group by t.coding_code_id, t.coding_name";
		cruConfig.currentPageUrl = "/rm/em/commCertificate/commCertificateList.jsp";
		queryData(1);		
		deleteTableTr("certificateMap");
	}
	
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	
	function loadDataDetail(ids){
	    
	    document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+ids;
	    
	    document.getElementById("codeManager").src = "<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=6&relationId="+ids;
		
		var querySql = "select s.certificate_no,e.employee_name,e.employee_id, i.org_name, s.certificate_num, s.qualification_name,s.training_institutions, s.issuing_agency, s.issuing_date, s.validity,s.document_id,h.employee_gz from bgp_comm_human_certificate s left join comm_human_employee e on s.employee_id = e.employee_id and e.bsflag = '0' left join comm_human_employee_hr h on e.employee_id = h.employee_id and h.bsflag = '0' left join comm_org_information i on s.work_unit = i.org_id  and i.bsflag = '0' left join comm_org_subjection su on s.work_unit= su.org_id and su.bsflag = '0' where s.bsflag = '0' and s.coding_code_id='"+ids+"' and  su.org_subjection_id like '"+orgSubId+"%25' order by s.modifi_date asc";
		querySql=encodeURI(querySql);
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		
		deleteTableTr("certificateMap");
		if(datas != null){
			for (var i = 0; i< queryRet.datas.length; i++) {
				
				var tr = document.getElementById("certificateMap").insertRow();		
				
              	if(i % 2 == 1){  
              		tr.className = "odd";
				}else{ 
					tr.className = "even";
				}
            	
              	var employee_id = datas[i].employee_id;
              	var employee_gz = datas[i].employee_gz;
				var td = tr.insertCell(0);
				td.innerHTML = "<input type='checkbox' onclick=chooseCert(this) name='certificate_no'  value='"+datas[i].certificate_no+"' /> <input type='hidden'  id='ids_id' name='ids_id'  value='"+ids+"' />";
				
				var td = tr.insertCell(1);
				td.innerHTML = "<a href=javascript:commHumanView('"+employee_id+"-"+employee_gz+"')>"+datas[i].employee_name+"</a>";
				
				var td = tr.insertCell(2);
				td.innerHTML = datas[i].org_name;

				
				var td = tr.insertCell(3);
				td.innerHTML = datas[i].qualification_name;
				
				
				var td = tr.insertCell(4);
				td.innerHTML = datas[i].certificate_num;
				
				var td = tr.insertCell(5);
				td.innerHTML = datas[i].training_institutions;
				
				var td = tr.insertCell(6);
				td.innerHTML = datas[i].issuing_agency;
				
				var td = tr.insertCell(7);
				td.innerHTML = datas[i].issuing_date;
				
				var td = tr.insertCell(8);
				td.innerHTML = datas[i].validity;
				
				var td = tr.insertCell(9);
				var document_id = datas[i].document_id;
				if(document_id !=''){
					td.innerHTML = "<a href=<%=contextPath%>/doc/downloadDocByUcmId.srq?docId="+datas[i].document_id+"&emflag=0>下载</a>";
				}else{
					td.innerHTML = "";
				}
				
			}
		}		
	}
	
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	
	 function commHumanView(ids){

		 popWindow('<%=contextPath%>/rm/em/humanChart/commHumanView.jsp?ids='+ids,'800:700');
	 }
	 
	function toAdd(){
		ids = getSelectedValue();

		if(codingCode == '0000000001000000020'){
			popWindow('<%=contextPath%>/rm/em/commCertificate/add_otherCertificate.jsp?codingCode='+codingCode+'&codingCodeId='+ids,'900:700');
		}else if(codingCode == '0000000001000000019'){
			popWindow('<%=contextPath%>/rm/em/commCertificate/add_optionCertificate.jsp?codingCode='+codingCode+'&codingCodeId='+ids,'900:700');
		}else{
			popWindow('<%=contextPath%>/rm/em/commCertificate/add_certificateModify.jsp?codingCode='+codingCode+'&codingCodeId='+ids,'900:700');
		}
	}
	
	function toView(){

		var certificate = document.getElementsByName("certificate_no");
		var certificate_no = "";
		for(var i=0;i<certificate.length;i++){
			if(certificate[i].checked==true){
				certificate_no = certificate[i].value;
			}
		}

		if(certificate_no == ""){
			alert("请选择一条记录!");
		}else{
			var ids = getSelIds('rdo_entity_id');
			if(codingCode == '0000000001000000020'){
				popWindow('<%=contextPath%>/rm/em/commCertificate/add_otherCertificate.jsp?action=view&id='+certificate_no+'&codingCode='+codingCode+'&codingCodeId='+ids,'900:700');
			}else if(codingCode == '0000000001000000019'){
				popWindow('<%=contextPath%>/rm/em/commCertificate/add_optionCertificate.jsp?action=view&id='+certificate_no+'&codingCode='+codingCode+'&codingCodeId='+ids,'900:700');
			}else{
				popWindow('<%=contextPath%>/rm/em/commCertificate/add_certificateModify.jsp?action=view&id='+certificate_no+'&codingCode='+codingCode+'&codingCodeId='+ids,'900:700');
			}			
		}

	}
	
	function toEdit(){
		var certificate = document.getElementsByName("certificate_no");
		var certificate_no = "";
		for(var i=0;i<certificate.length;i++){
			if(certificate[i].checked==true){
				certificate_no = certificate[i].value;
			}
		}

		if(certificate_no == ""){
			alert("请选择一条记录!");
		}else{

			ids = getSelectedValue();
			
			if(codingCode == '0000000001000000020'){
				popWindow('<%=contextPath%>/rm/em/commCertificate/add_otherCertificate.jsp?id='+certificate_no+'&codingCode='+codingCode+'&codingCodeId='+ids,'900:700');
			}else if(codingCode == '0000000001000000019'){
				popWindow('<%=contextPath%>/rm/em/commCertificate/add_optionCertificate.jsp?id='+certificate_no+'&codingCode='+codingCode+'&codingCodeId='+ids,'900:700');
			}else{
				popWindow('<%=contextPath%>/rm/em/commCertificate/add_certificateModify.jsp?id='+certificate_no+'&codingCode='+codingCode+'&codingCodeId='+ids,'900:700');
			}			
		}

	}
	function toDelete(){

		var certificate = document.getElementsByName("certificate_no");
		var ids_id = document.getElementById("ids_id").value;
	 
		var certificate_no = "";
		for(var i=0;i<certificate.length;i++){
			if(certificate[i].checked==true){
				certificate_no = certificate[i].value;
			}
		}
		if(certificate_no == ""){
			alert("请选择一条记录!");
		}else{
			if (!window.confirm("确认要删除吗?")) {
				return;
			}
			var sql = "update bgp_comm_human_certificate set bsflag='1' where certificate_no ='"+certificate_no+"'";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids="+certificate_no;
			var retObject = syncRequest('Post',path,params);

		}
		refreshData();
		loadDataDetail(ids_id);
		
	}
	

	function queryCertificateList(){
		
		var querySql = "SELECT t.coding_code_id AS value, t.coding_name AS label FROM comm_human_coding_sort t where t.coding_lever='2' and t.bsflag = '0' and t.superior_code_id='<%=codingCode%>' order by t.coding_show_order ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=10000&querySql='+querySql);
		var datas = queryRet.datas;
		var selectObj = document.getElementById("coding_code_id");
		document.getElementById("coding_code_id").innerHTML="";
		selectObj.add(new Option('请选择',""),0);
		if(datas!=null){
			for(var i=0;i<datas.length;i++){
				var option = new Option(datas[i].label,datas[i].value);
				selectObj.add(option,i+1);
			}
		}
	}
	
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseCert(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("certificate_no");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    }
	
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){   
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("rdo_entity_id");   
        for (i=0; i<obj.length; i++){   
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選   
            if (obj[i]!=cb) obj[i].checked = false;   
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選   
            //else  obj[i].checked = cb.checked;   
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行   
            else obj[i].checked = true;   
        }   
    }   
    
	// 简单查询
	function simpleSearch(){
		var coding_code_id = document.getElementById("coding_code_id").value;
		
		if(coding_code_id!=''){
			
			cruConfig.cdtStr = "coding_code_id like '"+coding_code_id+"%' ";
		}else{
			cruConfig.cdtStr = "";
		}

		refreshData(undefined);
	}
	
	function clearQueryText(){ 
		document.getElementById("coding_code_id").value='';
	}
	
	function toDownload(){
		var elemIF = document.createElement("iframe");  
		
		elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/rm/em/commCertificate/"+codingCode+".xls&filename="+codingCode+".xls";
		elemIF.style.display = "none";  
		document.body.appendChild(elemIF);  
	}
	
	function importData(){
		popWindow('<%=contextPath%>/rm/em/singleHuman/laborAccept/humanPlanImportFile.jsp','700:600');
		
	}
	
</script>
</html>