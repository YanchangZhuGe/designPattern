<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	java.util.Calendar c=java.util.Calendar.getInstance();    
    java.text.SimpleDateFormat f=new java.text.SimpleDateFormat("yyyy-MM-dd");   
    String nowTime=f.format(c.getTime());
    
  	String scrape_apply_id = request.getParameter("scrape_apply_id");
  	String proStatus = request.getParameter("proStatus");//审批状态
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<title>报废申请表</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" enctype="multipart/form-data" action="">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <fieldSet style="margin:2px:padding:2px;"><legend>报废申请基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      	<input name="scrape_apply_id" id="scrape_apply_id" type="hidden" value="<%=scrape_apply_id%>" />
      	<input name="scrape_asset_id" id="scrape_asset_id" type="hidden"/>
      	<input name="scrape_damage_id" id="scrape_damage_id" type="hidden"/>
      	<input name="colnum" id="colnum" class="input_width" type="hidden" value="0" readonly/>
      	<input name="parmeter" id="parmeter" type="hidden" value="1"/>
      	<input name="proStatus" id="proStatus" type="hidden"/>
        <tr>
          <td class="inquire_item4">报废申请单名称:</td>
          <td class="inquire_form4" colspan="3">
          	<input name="scrape_apply_name" id="scrape_apply_name" class="input_width" type="text" value="" />
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">报废申请单号:</td>
          <td class="inquire_form4">
          	<input name="scrape_apply_no" id="scrape_apply_no" class="input_width" type="text" value="保存后自动生成.." style="color:#DDDDDD;" readonly/>
          </td>
          <td class="inquire_item4">申请时间:</td>
          <td class="inquire_form4">
          	<input name="apply_date" id="apply_date" class="input_width" type="text" value="<%=nowTime%>" readonly/>
          </td>
        </tr>
        <tr>
          <td class="inquire_item4">申请单位名称:</td>
          <td class="inquire_form4">
          	<input name="org_id" id="org_id" class="input_width" type="hidden" value="<%=user.getOrgId()%>"/>
          	<input name="org_name" id="org_name" class="input_width" type="text" title="<%=user.getOrgName()%>" value="<%=user.getOrgName()%>" readonly/>
          </td>
          <td class="inquire_item4">申请人:</td>
          <td class="inquire_form4">
          	<input name="employee_id" id="employee_id" class="input_width" type="hidden" value="<%=user.getEmpId()%>" />
          	<input name="employee_name" id="employee_name" class="input_width" type="text" value="<%=user.getUserName()%>" readonly/>
          </td>
        </tr>
      </table>    
      </fieldSet>
      <fieldSet style="margin-left:2px"><legend>设备报废导入</legend>
			<table>
				<tr>
					<td class="ali_cdn_name"><a
						href="javascript:downloadModel('scrape_model','资产设备报废明细')">报废模板下载</a></td>
				</tr>
			</table>
			<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="file_tablePublic">
				<input name="flag_public" id="flag_public" type="hidden"/>
			</table>
	  </fieldSet>
    </div>
    <div id="oper_div">
     	<span class="xyb_btn"><a href="#" onclick="saveInfo()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
var flag_public = 0;//固定资产附件标示
	function saveInfo(){
		<%-- var scrape_apply_id = '<%=scrape_apply_id%>';
		var proStatus= '<%=proStatus%>'
		popWindow('<%=contextPath%>/dmsManager/scrape/scrapeApply_addAssetSee2.jsp?scrape_apply_id='+scrape_apply_id+'&proStatus='+proStatus,'840:650','评审通过明细查看'); --%>
		$("#scrape_apply_no").val("");
		if($("#scrape_apply_name").val()=="")
			{
			alert("报废申请单名称不能为空!");
			return;
			}
		if($("#apply_date").val()=="")
		{
			alert("申请日期不能为空!");
			return;
		}
		if(($("#excel_content_public").val()==undefined||$("#excel_content_public").val()=='')&&flag_public==0&&'<%=scrape_apply_id%>'=='null'){
			alert('请选择设备明细信息！');
			return;
		}else{
			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/scrape/addScrapeListSee2.srq";
			document.getElementById("form1").submit();
	}
	}
	function refreshData(){
		var baseData;
		if('<%=scrape_apply_id%>'!='null'){
			 baseData = jcdpCallService("ScrapeSrv", "getScrapeInfo", "scrape_apply_id="+$("#scrape_apply_id").val());
			$("#scrape_apply_no").val(baseData.deviceappMap.scrape_apply_no);
			$("#scrape_apply_name").val(baseData.deviceappMap.scrape_apply_name);
			$("#apply_date").val(baseData.deviceappMap.apply_date);
			if(baseData.listDamage!=null){
				$("#scrape_damage_id").val(baseData.listDamage[0].scrape_damage_id);
			}
			if(baseData.listAsset!=null){
				$("#scrape_asset_id").val(baseData.listAsset[0].scrape_asset_id);
			}
			$("#scrape_apply_name").val(baseData.deviceappMap.scrape_apply_name);
			$("#scrape_apply_name").val(baseData.deviceappMap.scrape_apply_name);
			if(baseData.fdataPublic!=null){
				//有附件不显示设备详情而是显示附件
				for (var tr_id = 1; tr_id<=baseData.fdataPublic.length; tr_id++) {
					insertFilePublic(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_type,baseData.fdataPublic[tr_id-1].file_id);
					flag_public=1;
				}
			}
			var proStatus= '<%=proStatus%>'
			if(proStatus=='1'||proStatus=='3'){
				$("#scrape_apply_name").attr("readonly","readonly");
				$("#proStatus").val(proStatus);
			}
		}
	}
	/**设备报废处置明细模板方法**/
	function downloadModel(modelname,filename){
		filename = encodeURI(filename);
		filename = encodeURI(filename);
		window.location.href="<%=contextPath%>/dmsManager/common/download.jsp?path=/dmsManager/scrape/"+modelname+".xlsx&filename="+filename+".xlsx";
	}
	/**导入设备报废处置明细方法**/
	function excelDataAdd(status){
		insertTrPublic('file_tablePublic');
	}
	//显示已插入的文件
	function insertFilePublic(name,type,id){
		$("#file_tablePublic").append(
					"<tr>"+
					"<td class='inquire_form5'>附件:</td>"+
	      			"<td class='inquire_form5' colspan='2' style='text-align:left;'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
					"</tr>"
			);
	}
</script>
</html>

