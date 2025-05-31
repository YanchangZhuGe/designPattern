<%-- <%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
%>
 <frameset  cols="50%,*"  frameborder="yes" border="0" framespacing="0">
  <frame src="<%=contextPath %>/qua/mProject/notice/project_tree.jsp" name="mainTopframe" frameborder="no" scrolling="auto" style="border-right: 2px solid #5796DD; cursor: w-resize;" id="mainTopframe"/>
  <frame src="<%=contextPath %>/qua/mProject/notice/notice_list.jsp" name="menuFrame" frameborder="no" scrolling="auto" style="border-left: 2px solid #5796DD; cursor: w-resize;" id="menuFrame"/>
 </frameset> --%>
 <%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String user_id = user.getUserId();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
 <head> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
</head> 
<body><!-- class="bgColor_f3f3f3"  onload="page_init()"> --> 
	<div id="new_table_box" align="center">
		<div id="new_table_box_content"> 
			<div id="new_table_box_bg">
				<table width="100%" style="height: 100%" border="0" cellspacing="0" cellpadding="0" class=""><!-- tab_line_height -->
			     	<tr style="width: 100%;height: 100%">
				    	<td width="50%" height="100%"><iframe src="<%=contextPath %>/qua/mProject/notice/project_tree.jsp" name="mainTopframe" frameborder="no" scrolling="auto"  id="mainTopframe" width="100%" height="100%"></iframe></td><!-- style="border-right: 2px solid #5796DD; cursor: w-resize;" -->
				    	<td width="50%" height="100%"><iframe src="<%=contextPath %>/qua/mProject/notice/notice_list.jsp" name="menuFrame" frameborder="no" scrolling="auto"  id="menuFrame" width="100%" height="100%"></iframe></td> <!-- style="border-left: 2px solid #5796DD; cursor: w-resize;" -->
				    </tr>
			    </table>
			</div> 
			<div id="oper_div">
				<span class="bc_btn"><a href="#" onclick="newSubmit()"></a></span>
				<span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
			</div>
		</div> 
	</div>
<script type="text/javascript">
	cruConfig.contextPath = '<%=contextPath%>';
	function newSubmit() {
		var substr ='';
		var user_id ='<%=user_id%>';
		var org_array = window.mainTopframe.getAllChecked();
		var file_ids = window.menuFrame.getAllChecked();
		var reg=new RegExp(",","g"); 
		var ids = file_ids.replace(reg,"','");
		ids = "'"+ids+"'";
		file_ids = file_ids.split(",");
		debugger;
		for(var i =0 ;i<org_array.length;i++){
			var org_id = org_array[i].org_id;
			var org_subjection_id = org_array[i].org_subjection_id;
			var project_info_no = org_array[i].project_info_no;
			
			if(project_info_no!=null && project_info_no!=''){
				if(ids==null || ids==''){
					substr = substr + "delete from bgp_qua_notice t where t.project_info_no = '"+project_info_no+"';";
				}else{
					substr = substr + "delete from bgp_qua_notice t where t.project_info_no = '"+project_info_no+"' and t.file_id not in("+ids+");";
				}
			}else{
				if(ids==null || ids ==''){
					substr = substr + "delete from bgp_qua_notice t where t.org_subjection_id = '"+org_subjection_id+"' ;";
				}else{
					substr = substr + "delete from bgp_qua_notice t where t.org_subjection_id = '"+org_subjection_id+"' and t.file_id not in("+ids+");";
				}
			}
			for(var j =0;j<file_ids.length ;j++){
				if(file_ids[j]==null || file_ids[j]==''){
					continue;
				}
				var file_id = file_ids[j];
				var sql = "select * from bgp_qua_notice t where t.bsflag ='0' "+
				" and t.file_id ='"+file_id+"' and t.org_id = '"+org_id+"' and t.org_subjection_id ='"+org_subjection_id+"'";
				if(project_info_no!=null && project_info_no!=''){
					sql = sql + " and t.project_info_no ='"+project_info_no+"' ";
				}
				var retObj = syncRequest("Post",cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
				if(retObj!=null && retObj.returnCode =='0'){
					if(retObj.datas!=null && retObj.datas.length>0){
						continue;
					}
				}
				substr = substr + "insert into bgp_qua_notice(notice_id,project_info_no,file_id,org_id,org_subjection_id,"+
				" bsflag,creator_id,create_date,updator_id,modifi_date)"+
				" values((select lower(sys_guid()) from dual),'"+project_info_no+"' ,'"+file_id+"' ,'"+org_id+"' ,'"+org_subjection_id+"' ," +
				" '0' ,'"+user_id+"',sysdate,'"+user_id+"' ,sysdate );";
			}
		}
		if(substr!=null && substr!=''){
			var retObj = jcdpCallService("QualityItemsSrv", "saveQuality", "sql="+substr);
			if(retObj!=null && retObj.returnCode =='0'){
				alert("保存成功!");
				newClose();
			}
		}
	}
</script>
</body>
</html>