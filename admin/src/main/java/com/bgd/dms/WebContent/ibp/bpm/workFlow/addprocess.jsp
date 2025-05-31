<%@ page contentType="text/html;charset=UTF-8"%>
<html xmlns:v="urn:schemas-microsoft-com:vml">
	<head>
		<title>添加流程模板</title>

    <%
     String contextPath=request.getContextPath();
     String path =contextPath+"/auth/org/orgSelectTree.jsp";
     %>

		<meta http-equiv="keywords" content="xio">
		<meta http-equiv="keywords" content="WorkFlow xio javascript">
		<meta http-equiv="description" content="XiorkFlow is a WorkFlow Designer based javascript.">
		<meta http-equiv="copyright" content="Copyright &copy;2006 www.xio.name">

		<meta http-equiv="content-type" content="text/html; charset=UTF-8">

		<script charset="UTF-8" src="../XorkFlowInfo/js/XiorkFlowWorkSpace.js" language="javascript"></script>
		<script charset="UTF-8" src="addprocess.js" language="javascript"></script>
        <script>
	   function openPersonWindow(nodeId)
	   {
		 window.open("/BPM/ibp/bpm/carapply/userList.jsp?nodeId="+nodeId+"","","height=500,width=500,scrollbars=yes");
	   }
       
        
        function returnPersonInfos(persons,ids,nodeId) {
			   document.getElementById(nodeId+"USERVIEW").value = persons;
			   document.getElementById(nodeId).value = ids;
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
	</head>

	<body onload="init()" onselectstart="return false;" style="margin: 0px;overflow: hidden;">

		<div id="designer" style="width: 100%;height: 100%;border: #e0e0e0 1px solid;"></div>
		<div id="message"></div>
		<input type="hidden" id="aa" value="dsds">
		<input type="hidden" id="orgId" value="">
		<input type="hidden" id="orgName" value="">
	</body>
</html>
