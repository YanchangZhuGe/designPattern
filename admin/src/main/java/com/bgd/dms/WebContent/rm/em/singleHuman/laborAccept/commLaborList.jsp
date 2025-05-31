<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = request.getParameter("orgSubId");
	if(orgSubId==null || orgSubId.equals("")) orgSubId = user.getOrgSubjectionId();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css"
	href="<%=contextPath%>/css/cn/style.css" />
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/table.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_list.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/rt_list_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_search.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/rt_search_var.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cute/rt_list_new.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cn/updateListTable.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/js/cute/kdy_search.js"></script>
<script type="text/javascript">
   var pageTitle = "人员基本信息列表"; 
   cruConfig.contextPath = "<%=contextPath%>";
   var nationOps = new Array(
   ['01','汉'],['02','满'],['03','蒙'],['04','回'],['05','壮'],['05','维'],['99','其他']
   );

   var genderOps = new Array(
   ['1','男'],['0','女']
   );

   var degreeOps = new Array(
   ['0','本科'],['1','硕士'],['2','博士'],['3','其它']
   );
   
	cruConfig.cdtType = 'form';
//	cruConfig.queryService = "HumanCommInfoSrv";
//	cruConfig.queryOp = "searchforHumanInfo";
		
	var jcdp_codes_items = null;
	var jcdp_codes = new Array();
	
	function page_init() {
		var titleObj = getObj("cruTitle");
		if (titleObj != undefined)
			titleObj.innerHTML = pageTitle;
		cruConfig.queryStr = " select  l.labor_id,l.employee_name, l.employee_gender, l.employee_nation, l.employee_birth_date, l.employee_id_code_no, l.employee_education_level, l.employee_address,l.phone_num, l.employee_health_info, l.specialty, l.elite_if, l.workerfrom ,d3.coding_name posts,  d2.coding_name technical_title_name   from bgp_comm_human_labor l  left join comm_coding_sort_detail d3    on l.post = d3.coding_code_id  left join comm_coding_sort_detail d2    on l.technical_title = d2.coding_code_id    left join bgp_comm_human_labor_list lt on l.labor_id = lt.labor_id and lt.bsflag='0'  where l.bsflag='0' and lt.list_id is null  and l.owning_subjection_org_id like '<%=user.getSubOrgIDofAffordOrg() %>%' order by lt.create_date desc ";
		cruConfig.currentPageUrl = "/rm/em/commHumanInfo/commHumanList.lpmd";
		queryData(1);
	}
	
	
	//保存的checkbox拼接的值
	var checked="";

	function doCheck(id){
		
	    //先取得同name的chekcBox的集合物件   
	    var obj = document.getElementsByName("chx_entity_id");   
	    for (i=0; i<obj.length; i++){   
	        if (obj[i]!=id) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    } 
	    checked = id.value;
 
	}

	function head_chx_box_changed(headChx){
		var chxBoxes = document.getElementsByName("chx_entity_id");
		if(chxBoxes==undefined) return;
		for(var i=0;i<chxBoxes.length;i++){
		  if(!chxBoxes[i].disabled){
				chxBoxes[i].checked = headChx.checked;	
				doCheck(chxBoxes[i]);
		  }
		  
		}
	}
	

	function JcdpButton0OnClick(){
		if(checked == ""){
			alert("请选择一条记录!");
			return;
		}

		window.returnValue = checked;
		window.close();  
	}

	function JcdpButton1OnClick(){
		window.returnValue = "";
		window.close(); 
	}

</script>
  <title>列表页面</title> 
 </head> 
 <body class="bgColor" onload="page_init();">  
  <div class="dataList wrap"> 
   <div class="tt"> 
    <h2 id="cruTitle">数据列表</h2> 
   </div> 
   <div class="ctt"> 
   
    <div id="buttonDiv" class="ctrlBtn"> 
     <input id=" " type="button" value="提交" onclick="JcdpButton0OnClick()" style="" /> 
     <input id=" " type="button" value="返回" onclick="JcdpButton1OnClick()" style="" /> 

    </div> 
    <div class="pageNumber" id="pageNumDiv"> 
     <a href="#" class="first fl"></a> 
     <a href="#" class="prev fl"></a> 
     <div class="pageNumber_cur fl" id="dataRowHint">
       第 
      <input id="changePage" type="text" size="2" onkeydown="javascript:changePage()" /> 页 共 5 页 
     </div> 
     <a href="#" class="next fl"></a> 
     <a href="#" class="last fl"></a> 
     <div class="clear"></div> 
    </div> 
    <!--end table_pageNumber--> 
    <!--Remark 查询结果显示区域--> 
    <div class="tableWrap"> 
     <table id="queryRetTable" class="table_list" cellpadding="0" cellspacing="0"> 
	
      <tr>
       <th exp="<input type='checkbox' name='chx_entity_id' value='{labor_id}-{employee_name}-{employee_id_code_no}-{posts}-{technical_title_name}' onclick=doCheck(this) >" ></th>
       <th exp="{employee_name}">姓名</th>      
       <th exp="{employee_id_code_no}">身份证号</th>      
       <th exp="{employee_gender}" func="getOpValue,genderOps">性别</th>
       <th exp="{employee_nation}" func="getOpValue,nationOps">民族</th>
       <th exp="{employee_education_level}" func="getOpValue,degreeOps">文化程度</th>
       <th exp="{phone_num}">联系电话</th>
       <th exp="{posts}">岗位</th>
       <th exp="{technical_title_name}">技术职称</th>
      </tr>
     </table> 
    </div> 
    <!--end table_body--> 
   </div> 
   <!--end ctt--> 
  </div> 
  <!--end dataList--> 
      <div id="oper_div">
        <span class="bc_btn"><a href="#" onclick="JcdpButton0OnClick()"></a></span>
        <span class="gb_btn"><a href="#" onclick="JcdpButton1OnClick()"></a></span>
    </div>
 </body>
</html>