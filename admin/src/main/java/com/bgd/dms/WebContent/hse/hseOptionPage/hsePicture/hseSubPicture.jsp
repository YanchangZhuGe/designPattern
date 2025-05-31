<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="java.util.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	ISrvMsg respMsg = OMSMVCUtil.getResponseMsg(request);
	String doc_main_id = "";
	if(respMsg != null){
		doc_main_id = respMsg.getValue("doc_main_id");
	}

	UserToken user = OMSMVCUtil.getUserToken(request);	
	String org_subjection_id = user.getOrgSubjectionId();
	String sql = "select t.org_sub_id,t.organ_flag,os.org_id,oi.org_abbreviation from bgp_hse_org t join comm_org_subjection os on os.org_subjection_id=t.org_sub_id and os.bsflag='0' join comm_org_information oi on os.org_id=oi.org_id and oi.bsflag='0' where t.org_sub_id <> 'C105' start with t.org_sub_id = '"+org_subjection_id+"'  connect by t.org_sub_id = prior t.father_org_sub_id  order by level desc";
	System.out.println("sql:"+sql);
	List list = BeanFactory.getQueryJdbcDAO().queryRecords(sql);
	String father_id = "";
	String sub_id = "";
	String father_organ_flag = "";
	String organ_flag = "";
	
	String org_sub_id="hse001";
	String second_org="hse002"; 
	String third_org="hse003";
	String org_type="0";
	int lengthParam = list.size();
	
	if(list.size()>1){
	 	Map map = (Map)list.get(0); 
	 	father_id = (String)map.get("orgSubId");	  
	 	father_organ_flag = (String)map.get("organFlag");	 
	 	 
 		Map mapOrg = (Map)list.get(1);
	 	sub_id = (String)mapOrg.get("orgSubId");
	 	organ_flag = (String)mapOrg.get("organFlag"); 
	 	
	 	if(father_organ_flag.equals("0")){
	 		father_id = "C105";
	 		organ_flag = "0";
	 		org_type="0";
 
	 	}else if(father_organ_flag.equals("1")){   //一个organ_flag都是 1 时,单位 
	 		org_sub_id=(String)map.get("orgSubId");	 	
	 		org_type="1";
	 		if(organ_flag.equals("1")){ //两个organ_flag都是 1 那么是下属单位
	 			second_org=(String)mapOrg.get("orgSubId"); 
	 			org_type="2";
	 		}
	 	} 
	 	
	}else{		
//	 	Map map = (Map)list.get(0);   
//	 	father_organ_flag = (String)map.get("organFlag");	
//	 	if(father_organ_flag.equals("1")){  
//		 	father_id = (String)map.get("orgSubId");
//	 		org_sub_id=(String)map.get("orgSubId");	 	
//	 		org_type="1";
//	 	} 
		father_id = "C105";
 		organ_flag = "0";
 		org_type="0";
	  
	}
	 
%>

<frameset rows="*" cols="0,*" frameborder="no" border="0" framespacing="0">  
<frame src="<%=contextPath %>/hse/hseOptionPage/hsePicture/tree.jsp?father_id=<%=father_id %>&sub_id=<%=sub_id %>&org_subjection_id=<%=org_subjection_id%>&org_type=<%=org_type%>&org_sub_id=<%=org_sub_id%>&second_org=<%=second_org%>" name="mainLeftframe" frameborder="no" scrolling="auto" id="mainLeftframe"  style="border-right: 2px solid #5796DD; cursor: w-resize;"/>
<%
if(doc_main_id != "" && doc_main_id != null){
%>  
<frame src="<%=contextPath %>/hse/hseOptionPage/hsePicture/one.jsp?father_id=<%=father_id %>&sub_id=<%=sub_id %>&org_subjection_id=<%=org_subjection_id%>&org_type=<%=org_type%>&org_sub_id=<%=org_sub_id%>&second_org=<%=second_org%>&doc_main_id=<%=doc_main_id%>" name="mainRightframe" frameborder="no" scrolling="no" id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
<%
}else{
%>
<frame src="<%=contextPath %>/hse/hseOptionPage/hsePicture/oldOne.jsp?father_id=<%=father_id %>&sub_id=<%=sub_id %>&org_subjection_id=<%=org_subjection_id%>&org_type=<%=org_type%>&org_sub_id=<%=org_sub_id%>&second_org=<%=second_org%>" name="mainRightframe" frameborder="no" scrolling="no" id="mainRightframe" style="border-left: 2px solid #5796DD; cursor: w-resize;"/>
 <%
}
 %>
  </frameset>
