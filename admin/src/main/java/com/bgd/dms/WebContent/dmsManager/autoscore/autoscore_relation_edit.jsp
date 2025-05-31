<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	String relation_id=request.getParameter("relation_id");
	if(null==relation_id){
		relation_id="";
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@include file="/common/include/quotesresource.jsp"%>
	<link href="<%=contextPath%>/dmsManager/plan/yearPlan/panel.css" rel="stylesheet" type="text/css" />
	<title>自动评分编辑信息</title>
</head>
<body style="background:#cdddef">
	<form name="form" id="form" method="post" action="<%=contextPath%>/dms/autoscore/saveOrUpdateAutoScoreRelation.srq?flag=<%=flag%>" enctype="multipart/form-data">
		<div id="new_table_box">
			<div id="new_table_box_content" style="background-color: rgb(241, 242, 243)">
		    	<div id="new_table_box_bg">
		    		<!-- 关联表ID -->
		    		<input type="hidden" id="relation_id" class="main" name="relation_id" />
					<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
						<tr>
							<td class="inquire_item6"><font color=red>*</font>&nbsp;考核表：</td>
			    			<td class="inquire_form6">
			    				<select name="assess_id" id="assess_id" class="select_width easyui-validatebox main" editable="false" >
			    					<option value="">请选择</option>
								</select>
							</td>
							<td class="inquire_item6"></td>
			    			<td class="inquire_form6"></td>
			        	</tr>
						<tr>
					  		<td class="inquire_item6"><font color=red>*</font>&nbsp;考核项名称：</td>
			    			<td class="inquire_form6">
			    				<input type="hidden" id="business_id" name="business_id" class="main"/>
			    				<input type="text" id="assess_name" name="assess_name" class="input_width main" readonly/>
			    				<img id="org_button" src="<%=contextPath%>/images/magnifier.gif"  width="20px" height="20px" style="cursor:pointer;" onclick="selectAssessInfo()" />
			    			</td>
							<td class="inquire_item6"><font color=red>*</font>&nbsp;评分配置名称：</td>
			    			<td class="inquire_form6">
			    				<input type="hidden" id="conf_id" name="conf_id" class="main"/>
			    				<input type="text" id="conf_name" name="conf_name" class="input_width main" readonly/>
			    				<img id="org_button" src="<%=contextPath%>/images/magnifier.gif"  width="20px" height="20px" style="cursor:pointer;" onclick="selectConfInfo()" />
							</td>
			        	</tr>
			        	<tr class="hd_co_view">
					  		<td class="inquire_item6">评分条件：</td>
			    			<td class="inquire_form6" colspan="3">
			    				<textarea id="score_condition" name="score_condition" class="textarea main" style="height:80px" required></textarea>
							</td>
			        	</tr>
					</table>
				</div> 
				<div>
				<div id="oper_div" style="padding-top:6px;">
					 <a href="####" id="submitButton" class="easyui-linkbutton" onclick="toSubmit()"><i class="fa fa-floppy-o fa-lg"></i> 保 存 </a>
					 &nbsp;&nbsp;&nbsp;&nbsp;
					 <a href="####" class="easyui-linkbutton" onclick='toClose()'><i class="fa fa-times fa-lg"></i> 关 闭 </a>
				</div>
				</div>
			</div>
		</div>
	</form>
</body>
<script type="text/javascript">
	var contextpath = "<%=contextPath%>";
	//关联ID
	var relation_id = "<%=relation_id%>";
	//增加修改标志
	var flag = "<%=flag%>";
	$(function(){
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
		//考核表
		var aretObj = jcdpCallService("AutoScoreSrv", "getAssessInfo", "");
		if(typeof aretObj.datas!="undefined"){
			var adatas = aretObj.datas;
			for(var i=0;i<adatas.length;i++){
				var adata=adatas[i];
				$("#assess_id").append("<option value='"+adata.id+"'>"+adata.name+"</option>");
			}
		}
		if("update"==flag){
			var retObj = jcdpCallService("AutoScoreSrv", "getAutoScoreRelationInfo", "relation_id="+relation_id);
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(data[temp] != undefined ? data[temp]:"");
					//考核项名称提示
					if(temp == 'assess_name'){
						tipView('assess_name',data['assess_name'],'top');
					}
					//配置名称提示
					if(temp == 'conf_name'){
						tipView('conf_name',data['conf_name'],'top');
					}
				});
			}
		}
	});
	
	//保存
	function toSubmit(){
		var sassess_name=$("#assess_name").val();
		var sconf_name=$("#conf_name").val();
		if(null==sassess_name || ""==sassess_name){
			$.messager.alert("提示","考核项名称不能为空!","warning");
			return;
		}
		if(null==sconf_name || ""==sconf_name){
			$.messager.alert("提示","评分配置名称不能为空!","warning");
			return;
		}
		var subForm = $("#form");
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
            	subForm.submit();
            }
        });
	}
	
	//关闭
	function toClose(){
		newClose();
	}
	
	//选择指标名称
	function selectAssessInfo(){
		var assessId= $("#assess_id").val();
		if(""==assessId){
			$.messager.alert("提示","请选择考核表!","warning");
			return;
		}
		var obj = new Object();
		obj.assessId = assessId;
		window.showModalDialog("<%=contextPath%>/dmsManager/autoscore/selectAssessInfo.jsp",obj,"dialogWidth=550px;dialogHeight=480px");
		$("#business_id").val(obj.id);
		$("#assess_name").val(obj.name);
		//考核项名称提示
		tipView('assess_name',obj.name,'top');
	}
	
	//选择配置名称
	function selectConfInfo(){
		var obj =new Object();
		window.showModalDialog("<%=contextPath%>/dmsManager/autoscore/selectConfInfo.jsp",obj,"dialogWidth=550px;dialogHeight=480px");
		$("#conf_id").val(obj.id);
		$("#conf_name").val(obj.name);
		//配置名称提示
		tipView('conf_name',obj.name,'top');
	}
</script>
</html>