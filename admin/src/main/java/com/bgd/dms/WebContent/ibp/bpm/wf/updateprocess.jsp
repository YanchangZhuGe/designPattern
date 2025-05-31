<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="java.util.Map"%>
<html xmlns:v="urn:schemas-microsoft-com:vml">
<%
     String contextPath=request.getContextPath();
     String path =contextPath+"/auth/org/orgSelectTree.jsp";
     %>
<head>
<meta http-equiv="keywords" content="xio">
		<meta http-equiv="keywords" content="WorkFlow xio javascript">
		<meta http-equiv="description" content="XiorkFlow is a WorkFlow Designer based javascript.">
		<meta http-equiv="copyright" content="Copyright &copy;2006 www.xio.name">

		<meta http-equiv="content-type" content="text/html; charset=UTF-8">

		<script charset="UTF-8" src="<%=contextPath%>/XorkFlowInfo/js/XiorkFlowWorkSpace.js" language="javascript"></script>
		<script charset="UTF-8" src="updateprocess.js" language="javascript"></script>
		   <script>
	   function openPersonWindow(nodeId)
	   {
		 window.open("/RFITMS/department/getDepartmentRootForCheckWf.srq?nodeId="+nodeId+"","","height=500,width=300,scrollbars=yes");
	   }
        function getValue(orgId,orgName,nodeId){
          document.getElementById(nodeId).value = orgName;
			//document.getElementById(nodeId).value = orgId;
			//document.getElementById("orgName").value = orgName;
        }
        
        function returnPersonInfos(persons,nodeId) {
       
        var userId="";
        var userName="";
		if(persons.length>0)
		{
			for(var i=0;i<persons.length;i++){
				var person = persons[i];
				var emplId = getNotNullValue(person.id);
				var emplName = getNotNullValue(person.text);
				var deptId = getNotNullValue(person.parentNode.id);
				var deptName = getNotNullValue(person.parentNode.text);
				var email = getNotNullValue(person.attributes.email);
                userId=userId+emplId+",";	
                userName=userName+emplName+",";		
			}
			if(userId.length>0)
			{
			 userId=userId.substring(0,userId.length-1);
			}
			if(userName.length>0)
			{
			 userName=userName.substring(0,userName.length-1);
			}
			  document.getElementById(nodeId+"USERVIEW").value = userName;
			   document.getElementById(nodeId).value = userId;
		}		
	}
		function getNotNullValue(from) {
		var to = "";
		if(from != null) {
			to = from;
		} 
		return to;
	}
	
	function trim(value){
		for(var  i  =  0  ;  i<value.length  &&  value.charAt(i)==" "  ;  i++  )  ;
	    for(var  j  =value.length;  j>0  &&  value.charAt(j-1)==" "  ;  j--)  ;
	    if(i>j)  return  "";  
	    return  value.substring(i,j);  
	}
        </script>
<title>Insert title here</title>
</head>
	<body onload="init()" onselectstart="return false;" style="margin: 0px;">

		<div id="designer" style="width: 100%;height: 100%;border: #e0e0e0 1px solid;"></div>

</body>
</html>