<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
    String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    String codingCodeId = request.getParameter("codingCodeId");
    String action = request.getParameter("action");


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
	cruConfig.openerUrl = "/rm/em/commCertificate/humanCertificateList.lpmd";
	cru_init();
	
}


function update(){

	var coding_code_id = document.getElementById("coding_code_id").value;	
	var coding_name = document.getElementById("coding_name").value;
	var coding_mnemonic = document.getElementById("coding_mnemonic").value;
	
	var rowParams = new Array();
	var rowParam = {};
	rowParam['coding_code_id'] = coding_code_id;		
	rowParam['coding_name'] = encodeURI(encodeURI(coding_name));		
	rowParam['coding_mnemonic_id'] = coding_mnemonic;	
	
	rowParam['create_date'] = '<%=curDate%>';
	rowParam['modifi_date'] = '<%=curDate%>';
	rowParam['bsflag'] = '0';

	rowParams[rowParams.length] = rowParam;
	var rows=JSON.stringify(rowParams);

	saveFunc("comm_coding_sort_detail",rows);	

	top.frames('list').refreshTree();
	newClose();
}

function save(){
	
	var coding_code_id = document.getElementById("coding_code_id").value;
	var coding_name = document.getElementById("coding_name").value;
	var coding_show_id = document.getElementById("coding_show_id").value;
	var coding_code = document.getElementById("coding_code").value;
	var coding_mnemonic = document.getElementById("coding_mnemonic").value;
	
    var submitStr = "coding_code_id="+coding_code_id+"&coding_name="+coding_name+"&coding_show_id="+coding_show_id+"&coding_code="+coding_code+"&coding_mnemonic="+coding_mnemonic;  
	submitStr = encodeURI(submitStr);
	submitStr = encodeURI(submitStr);
 
	var applyPost=jcdpCallService("HumanCommInfoSrv","saveTeamPostCodes",submitStr);
	alert('添加成功!');
	top.frames('list').refreshTree();
	newClose();
	
}

var codingSortId="0110000001";

function page_init(){

	var codingCodeId = '<%=request.getParameter("codingCodeId")%>';	
	var codingCode = '<%=request.getParameter("codingCode")%>';	
	
	if(codingCodeId!='null'){//修改 
		var querySql = "select t.* from comm_coding_sort_detail t where t.coding_mnemonic_id='"+codingCodeId.split('_')[1]+"' and  t.coding_code_id='"+codingCodeId.split('_')[0]+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		
		if(datas!=null){
			document.getElementById("coding_code").value=datas[0].coding_code;
			document.getElementById("coding_code_id").value=datas[0].coding_code_id;
			document.getElementById("coding_name").value=datas[0].coding_name;
			document.getElementById("coding_show_id").value=datas[0].coding_show_id;
			document.getElementById("coding_mnemonic").value=datas[0].coding_mnemonic_id;
			
		}
		
	}else if(codingCode!='null'){ //添加 
		if(codingCode.split('_')[1] == 'fs'){  //项目类型的根目录 添加班组
		 	//alert('班组'+codingCode);
			var querySql = " select max(t.coding_code)+1 coding_code,max(t.coding_show_id)+1 coding_show_id from comm_coding_sort_detail t where t.coding_sort_id='0110000001' and length(t.coding_code)=2 ";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			var datas = queryRet.datas;

			if(datas!=null){
				var coding_code_temp = datas[0].coding_code;
				document.getElementById("coding_code").value=coding_code_temp;
				document.getElementById("coding_show_id").value=datas[0].coding_show_id;
				document.getElementById("coding_code_id").value=codingSortId+"00100"+coding_code_temp+"01"; 
				document.getElementById("coding_mnemonic").value=codingCode.split('_')[0]; //获取项目类型id
			}
						
		}else{ //班组目录 添加岗位
			// alert('岗位'+codingCode); 
			var querySql1 = " select substr(max(t.coding_code)+1,-2,2) coding_code, max(t.coding_show_id)+1 coding_show_id from comm_coding_sort_detail t where t.coding_sort_id='0110000001' and length(t.coding_code)=4    and t.coding_code like '"+codingCode.split('_')[0]+"__'  ";			
			var queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql1);
			var datas1 = queryRet1.datas;
					 
			if(datas1!=null){
				var coding_code_temp = datas1[0].coding_code;
				var coding_show_id_temp = datas1[0].coding_show_id;
				if(coding_code_temp == ''){
					coding_code_temp = "02";
				}
				if(coding_show_id_temp == ''){
					coding_show_id_temp = "2";
				}
				document.getElementById("coding_code").value=codingCode.split('_')[0]+coding_code_temp;
				document.getElementById("coding_show_id").value=coding_show_id_temp;
				document.getElementById("coding_code_id").value=codingSortId+"00100"+codingCode.split('_')[0]+coding_code_temp;
				document.getElementById("coding_mnemonic").value=codingCode.split('_')[1];  //获取项目类型id
			}
		}

		
	}

}

 
</script>
<script type="text/JavaScript" src="/BGPMCS/js/calendar-zh.js"></script>
</head>
<body onload="page_init();">

    <div style="border:1px #aebccb solid;background:#f1f2f3;padding:10px;width:98%">
 	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
 	 <tr>
 	       <td class="inquire_item4">编码：</td>
           <td class="inquire_form4"><input name="coding_code_id" id="coding_code_id" class="input_width" value="" type="text" readonly="readonly"/></td>
           <td class="inquire_item4">名称：</td>
           <td class="inquire_form4">
           <input name="coding_name" id="coding_name" class="input_width" value="" type="text" />          
           <input name="coding_show_id" id="coding_show_id" class="input_width" value="" type="hidden" />
           <input name="coding_code" id="coding_code" class="input_width" value="" type="hidden" />
           <input name="coding_mnemonic" id="coding_mnemonic" class="input_width" value="" type="hidden" />
           </td>
	  </tr>
	           
 	</table>
</div>  

    <div id="oper_div">
     	<%if("add".equals(action)){ %>
      	  <span class="bc_btn"><a href="#" onclick="save()"></a></span>
        <%}else{ %>
      	  <span class="bc_btn"><a href="#" onclick="update()"></a></span>
        <%} %>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
</body>
</html>
