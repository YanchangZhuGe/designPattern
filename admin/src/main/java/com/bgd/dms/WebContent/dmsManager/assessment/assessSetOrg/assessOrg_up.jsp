<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	String assessids = request.getParameter("assessids");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String selectOrg = request.getParameter("selectorg");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<link rel="stylesheet" href="<%=contextPath%>/js/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script>
	<title>单位指标权重修改页面</title>
</head>
<body class="bgColor_f3f3f3" onload="loadDataDetail()">
<form name="form1" id="form1" method="post" action="">
<div id="new_table_box">
  <div id="new_table_box_content" style="height: 500px;">
    <div id="new_table_box_bg" style="height: 350px;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
      <tr>
      	<td>
      		<fieldset style="margin-left:2px"><legend>指标明细</legend>
			  <table style="width:100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
		       <tr>
					<td class="bt_info_odd" width='4%'>序号</td>
					<td class="bt_info_even" width='8%'>单位名称</td>
					<td class="bt_info_odd" width='10%'>指标名称</td>
					<td class="bt_info_even" width='10%'>指标权重</td>
					<td class="bt_info_odd" width='10%'>指标值上限(%)</td>
					<td class="bt_info_even" width='10%'>指标值下限(%)</td>
				</tr>
			   </table>
				<div style="height:290px;overflow:auto;">
				<table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" style='table-layout: auto'>
			  		<tbody id="assesstable" name="assesstable" >
			   		</tbody>
		      	</table>
		      </div>
      	   </fieldset>
      	</td>
      </tr>
    </table>
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a id="submitButton" href="####" onclick="submitInfo()"></a></span>
        <span class="gb_btn"><a href="####" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</form>
</body>
<script type="text/javascript">
	var select_org = '<%=selectOrg%>';
	
	function loadDataDetail(){
		var assess_ids = '<%=assessids%>';
		
		if(assess_ids!=null){
			retObj = jcdpCallService("DeviceAssessInfoSrv", "getOrgAssessBaseInfo", "assessid="+assess_ids);
			
			if(retObj!=null && retObj.returnCode=='0'){
				for(var index=0;index<retObj.assessOrgList.length;index++){
					//动态新增表格
					var innerhtml = "<tr id='tr"+retObj.assessOrgList[index].assess_id+"' name='tr' lined='"+index+"' midinfo='"+retObj.assessOrgList[index].assess_id+"'>";
					innerhtml += "<td width='8%' align='center'>"+(index+1)+"</td>";
					innerhtml += "<td width='15%' align='center'>"+retObj.assessOrgList[index].wtc_org_name+"</td>";
					innerhtml += "<td width='18%' align='center'>"+retObj.assessOrgList[index].assess_name+"</td>";
					innerhtml += "<td width='18%' align='center'><input type='text' id=assess_num"+index+" assid='"+retObj.assessOrgList[index].assess_id+"' name=assess_num"+index+" value='"+retObj.assessOrgList[index].assess_value+"' size='12' onBlur='checkAssessNum(this,"+"\"ass\""+",\""+index+"\")'></td>";
					innerhtml += "<td width='18%' align='center'><input type='text' id=assess_cei_num"+index+" assceiid='"+retObj.assessOrgList[index].assess_id+"' name=assess_cei_num"+index+" value='"+retObj.assessOrgList[index].assess_org_ceiling+"' size='12' onBlur='checkAssessNum(this,"+"\"cei\""+",\""+index+"\")'></td>";
					innerhtml += "<td width='18%' align='center'><input type='text' id=assess_flo_num"+index+" assfloid='"+retObj.assessOrgList[index].assess_id+"' name=assess_flo_num"+index+" value='"+retObj.assessOrgList[index].assess_org_floor+"' size='12' onBlur='checkAssessNum(this,"+"\"flo\""+",\""+index+"\")'></td>";			
					innerhtml += "</tr>";
					$("#assesstable").append(innerhtml);
				}
				$("#processtable>tr:odd>td:odd").addClass("odd_odd");
				$("#processtable>tr:odd>td:even").addClass("odd_even");
				$("#processtable>tr:even>td:odd").addClass("even_odd");
				$("#processtable>tr:even>td:even").addClass("even_even");
			}				
		}		
	}
	function submitInfo(){
		//保留的行信息
		var count = 0;
		var idinfos;
		var assessnums;
		var assessceinums;
		var assessflonums;
		$("tr","#assesstable").each(function(){
			if(count == 0){
				idinfos = this.midinfo;
				assessnums = $("input[id^='assess_num'][assid='"+this.midinfo+"']").val();
				assessceinums = $("input[id^='assess_cei_num'][assceiid='"+this.midinfo+"']").val();
				assessflonums = $("input[id^='assess_flo_num'][assfloid='"+this.midinfo+"']").val();
			}else{
				idinfos = idinfos+"~"+this.midinfo;
				assessnums = assessnums+"~"+$("input[id^='assess_num'][assid='"+this.midinfo+"']").val();
				assessceinums = assessceinums+"~"+$("input[id^='assess_cei_num'][assceiid='"+this.midinfo+"']").val();
				assessflonums = assessflonums+"~"+$("input[id^='assess_flo_num'][assfloid='"+this.midinfo+"']").val();
			}
			count++;
		});
		if(count == 0){
			alert('请添加单位权重明细信息！');
			return;
		}

		if(confirm("确认提交？")){
			Ext.MessageBox.wait('请等待...','处理中...');
			$("#submitButton").attr({"disabled":"disabled"});
			document.getElementById("form1").action = "<%=contextPath%>/rm/dm/toUpOrgAssessInfo.srq?count="+count+"&idinfos="+idinfos+"&assessnums="+assessnums+"&assessceinums="+assessceinums+"&assessflonums="+assessflonums+"&selectorg="+select_org;
			document.getElementById("form1").submit();
		}
	}
	
	function checkAssessNum(obj,str,index){
		var assessValue = obj.value;
		var re = /^(?:(?:[1-9]\d*)|(?:0))$/;
		if(assessValue==""){
			if(str=="ass"){
				$("#assess_num"+index).val("");
				alert("权重值不能为空!");
			}
			return;
		}else{
			var assessValue = parseInt(assessValue,10);
			if(str=="cei"){
				if(!re.test(assessValue)){
					$("#assess_cei_num"+index).val("");
					alert("指标值上限必须为数字!");
					return;
				}
				if(assessValue > 100){
					$("#assess_org_ceiling").val("");
					alert("指标值上限不能超过100!");
					return;
				}
				var flo = $("#assess_flo_num"+index).val();
				if((assessValue>0) && (flo>assessValue)){
					$("#assess_cei_num"+index).val("");
					alert("指标值下限不能大于上限!");
					return;
				}					
			}else if(str=="flo"){
				if(!re.test(assessValue)){
					$("#assess_flo_num"+index).val("");
					alert("指标值下限必须为数字!");
					return;
				}
				var cei = $("#assess_cei_num"+index).val();
				if((cei>0) && (assessValue>cei)){
					$("#assess_flo_num"+index).val("");
					alert("指标值下限不能大于上限!");
					return;
				}
			}else if(str=="ass"&&!re.test(assessValue)){
				$("#assess_num"+index).val("");
				alert("权重值必须为数字!");
				return;
			}
			
		}
	}
</script>
</html>

