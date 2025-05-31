<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String appDate = df.format(new Date());
	String projectInfoNo = user.getProjectInfoNo();
	String fileAbbr = request.getParameter("fileAbbr");
	if(fileAbbr==null || "".equals(fileAbbr)){
		fileAbbr = resultMsg.getValue("fileAbbr");
	}	
	String isSingle = request.getParameter("isSingle")==null?"":request.getParameter("isSingle");
	if(isSingle==null || "".equals(isSingle)){
		if(resultMsg != null && resultMsg.getValue("isSingle") != null ){
			isSingle = resultMsg.getValue("isSingle")==null?"":resultMsg.getValue("isSingle");
		}
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
<title>综合工区完成边框</title> 
</head> 
 
 <body style="background:#fff" onload="refreshData('');">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td class="ali_cdn_name">拐点编号</td>
			    <td class="ali_cdn_input"><input class="input_width" id="s_title_name" name="s_title_name" type="text"  /></td>
			    <td class="ali_query">
		    		<span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
	    		</td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>
			    <td>&nbsp;</td>
			  	<auth:ListButton functionId="" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>	  		
  				<auth:ListButton functionId="" css="xg" event="onclick='toEdit()'" title="JCDP_btn_edit"></auth:ListButton> 
  				<auth:ListButton functionId="" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
  				<auth:ListButton functionId="" css="dr" event="onclick='excelDataAdd()'" title="导入excel模板"></auth:ListButton>
  				<auth:ListButton functionId="" css="xz" event="onclick='excelDataDown()'" title="下载excel模板"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box" >
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr>
			      <td class="bt_info_odd" exp="<input type='checkbox' name='rdo_entity_id' value='{tecnical_id}-{plan_id}' id='rdo_entity_id_{tecnical_id}'  onclick='chooseOne(this);'/>" >选择</td>
			      <td class="bt_info_even" autoOrder="1">序号</td>
			      <td class="bt_info_odd" exp="{title}">拐点编号</td>	
			      <td class="bt_info_even" exp="{north_location}">X坐标</td>
			      <td class="bt_info_odd" exp="{south_location}">Y坐标</td>
			     </tr> 			        
			  </table>
			</div>
			<div id="fenye_box"  style="display:block"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getTab3(0)">备注</a></li>	
			  </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" class="tab_box_content">
				<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" >
				</iframe>	
				</div>
				<div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<wf:startProcessInfo  buttonFunctionId="F_OP_002" title=""/>		
				</div>
		 	</div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
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
	cruConfig.cdtType = 'form';
	var fileAbbr = '<%=fileAbbr%>';
	var businessType="5110000057000000012";
	var planId = "";
	projectInfoNo="<%=projectInfoNo%>";
	projectName="";
	var selectedTagIndex = 0;
	var showTabBox = document.getElementById("tab_box_content0");
	
	function refreshData(str){
		//获得plan_id
		var querySql ="select w.plan_id from gp_ws_tecnical_plan w where w.bsflag = '0' and w.project_info_no = '"+projectInfoNo+"' and w.business_type = '"+businessType+"' ";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(null!=datas&&datas.length>0){
			planId = datas[0].plan_id;
		}
		
		//填充列表
		var str=str==null?"":str;
		cruConfig.queryStr = "select w.plan_id,t.project_info_no,t.tecnical_id,t.title,t.north_location,t.south_location,p.project_name "+
		    "from gp_ws_tecnical_plan w left join gp_ws_tecnical_basic t on w.project_info_no=t.project_info_no and t.bsflag='0' and t.business_type='"+businessType+"' "+
			"left join gp_task_project p on t.project_info_no = p.project_info_no and p.bsflag = '0' "+
			"where w.bsflag = '0' and w.project_info_no = '"+projectInfoNo+"' and w.business_type = '"+businessType+"' "+str+" order by t.modifi_date desc ";
		queryData(1);

		document.getElementById("remark").src = "<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+planId;
	}

    function toAdd(){
    	popWindow('<%=contextPath%>/td/doc/workResultDoc/wt/add_tdDocModify.jsp?businessType='+businessType+'&fileAbbr='+fileAbbr,'750:680');
    }
    
	function toEdit() {
		id = getSelIds("rdo_entity_id").split("-")[0];
		if (""==id) {
			alert("请选择一条记录!");
			return;
		}
		popWindow('<%=contextPath%>/td/doc/workResultDoc/wt/add_tdDocModify.jsp?businessType='+businessType+'&fileAbbr='+fileAbbr+'&id='+id,'750:680');
	}
	
	function toDelete(){
		id = getSelIds("rdo_entity_id").split("-")[0];
		if (""==id) {
			alert("请选择一条记录!");
			return;
		}
	    if(confirm('确定要删除吗?')){  
			var retObj = jcdpCallService("WsTecnicalBasicSrv", "deleteTdDoc", "ids="+id);
			queryData(cruConfig.currentPage);
		}
		refreshData('');
		
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

	// 简单查询
	function simpleSearch(){
		var title_name = document.getElementById("s_title_name").value;
		
		var str = "";

		if(title_name!=''){
			str += " and t.title like '%"+title_name+"%' ";
		}
		refreshData(str);
	}
	
	function clearQueryText(){ 
		document.getElementById("s_title_name").value='';
	}

	function excelDataAdd(){
		popWindow('<%=contextPath%>/td/doc/workResultDoc/wt/excelDataAdd.jsp?businessType='+businessType);
	}
	
	function excelDataDown(){
		var elemIF = document.createElement("iframe");  

		var iName ="工区完成边框模板";  
		iName = encodeURI(iName);
		iName = encodeURI(iName);
		
		elemIF.src = "<%=contextPath%>/rm/em/humanRequest/download.jsp?path=/td/doc/workResultDoc/wt/workResultList.xls&filename="+iName+".xls";
		elemIF.style.display = "none";  
		document.body.appendChild(elemIF);
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
</script>
</html>