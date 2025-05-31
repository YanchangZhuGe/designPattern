<%@ page contentType="text/html;charset=GBK"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
%>
<html>
 <head> 
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
  <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/JCDP_SAIS_CSS/style.css" /> 
  <script type="text/javascript" src="js/json.js"></script> 
  <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script> 
  <script type="text/javascript" src="js/dialog_open.js"></script> 
  <script type="text/javascript" src="js/table.js"></script> 
  <title>列表页面</title> 
 </head> 
 <body class="bgColor" onload="page_init()"> 
  <div id="searchDiv" class="searchBar wrap"> 
   <div class="tt"> 
    <h2>JCDP_cz_cn</h2> 
   </div> 
   <div class="ctt"> 
    <form> 
     <div class="searchList fl"> 
      <table id="ComplexTable" class="table_search" cellpadding="0" cellspacing="0" onkeydown="if(event.keyCode==13){return false;}"> 
       <tbody>
        <tr> 
         <td><select onchange="updateCmpOption(this)" name="cmp_field"> </select></td> 
         <td><select name="cmp_cdt"> </select></td> 
         <td><input type="text" name="cmp_input" /><select name="cmp_sel"></select></td> 
        </tr> 
       </tbody>
      </table> 
     </div> 
     <div class="searchBtn fl"> 
      <input type="button" value="" class="btn btn_search" onclick="cmpQuery()" /> 
      <input type="button" value="" class="btn btn_addSR" onclick="addSearchRow()" /> 
      <input type="button" value="" class="btn btn_delSR" onclick="deleteSearchRow()" /> 
     </div> 
     <div class="clear"></div> 
    </form> 
   </div> 
  </div> 
  <div class="dataList wrap"> 
   <div class="tt"> 
    <h2 id="cruTitle">数据列表</h2> 
   </div> 
   <div class="ctt"> 
    <div id="buttonDiv" class="ctrlBtn"> 
     <input id="btn_add" type="button" class="btn btn_add" value=" " onclick="dialogOpen('添加',660,540,'dialog/sample_dialog_table_form.html')" style="display:none" /> 
     <input id="btn_edit" type="button" class="btn btn_edit" value=" " onclick="alert(1)" style="display:none" /> 
     <input id="btn_del" type="button" class="btn btn_del" value=" " onclick="alert(2)" style="display:none" /> 
     <input id="btn_submit" type="button" class="btn btn_submit" value=" " onclick="" style="display:none" /> 
     <input id="btn_back" type="button" class="btn btn_back" value=" " onclick="" style="display:none" /> 
     <input id="btn_close" type="button" class="btn btn_close" value=" " onclick="" style="display:none" /> 
     <input id="btn_normal" type="button" class="btn btn_normal" value=" " onclick="" style="display:none" /> 
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
       <th exp="<input type='radio' name='chx_entity_id' value='{config_id}'>">选择</th>
       <th exp="{business_type_name}">业务名称</th>
      </tr>
     </table> 
    </div> 
    <!--end table_body--> 
   </div> 
   <!--end ctt--> 
  </div> 
  <!--end dataList--> 
  <script type="text/javascript">
function popWindow(url,size){
		var path = cruConfig.currentPageUrl;
		if(path.indexOf("/epcomp") == 0){   //如果是组件包里的pmd文件
			path = path.substr("/epcomp".length);
		}	
		if(url.indexOf('/') == 0){
			if(url.indexOf(cruConfig.contextPath) != 0){
				url = cruConfig.contextPath + url; 
			}
		}
		else {
				path = path.substr(0,path.lastIndexOf("/")+1);
				if(path.lastIndexOf("/") == (path.length - 1)){
						url = cruConfig.contextPath + path + url;
				}
				else url = cruConfig.contextPath + path + '/' + url;
		}
		var height = 680;
		var width = 740;
		if(size != null){
			if(typeof size=='number'){
				height=size;
				}
			if(typeof size=='string'&&size.indexOf(':')>0){
				height = eval(size.split(':')[1]);
			  width = eval(size.split(':')[0]);
		  }
		}
		dialogOpen("",width,height,url);
	}

  </script>   
 </body>
</html>