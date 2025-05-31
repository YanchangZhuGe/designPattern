<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	String flag=request.getParameter("flag");
	if(null==flag){
		flag="add";
	}
	String conf_id=request.getParameter("conf_id");
	if(null==conf_id){
		conf_id="";
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
	<form name="form" id="form" method="post" action="<%=contextPath%>/dms/autoscore/saveOrUpdateAutoScore.srq?flag=<%=flag%>" enctype="multipart/form-data">
		<div id="new_table_box">
			<div id="new_table_box_content" style="background-color: rgb(241, 242, 243)">
		    	<div id="new_table_box_bg">
		    		<!-- 配置表ID -->
		    		<input type="hidden" id="conf_id" class="main" name="conf_id" />
		    		<fieldset style="margin-left:2px">
		    			<legend>配置基本信息</legend>
						<table border="0" cellpadding="0" cellspacing="0" class="tab_line_height" width="100%">
							<tr>
								<td class="inquire_item6">配置表类型：</td>
				    			<td class="inquire_form6">
				    				<select name="conf_table_type" id="conf_table_type" class="select_width main">
										<option value="0">配置评分表</option>
										<option value="1">考核表</option>
									</select>
								</td>
								<td class="inquire_item6"></td>
				    			<td class="inquire_form6"></td>
				        	</tr>
							<tr>
						  		<td class="inquire_item6">配置名称：</td>
				    			<td class="inquire_form6">
				    				<input type="text" id="conf_name" name="conf_name" class="input_width main"/>
				    			</td>
								<td class="inquire_item6">配置内容类型：</td>
				    			<td class="inquire_form6">
				    				<select name="conf_content_type" id="conf_content_type" class="select_width main" onchange="confSelect(this.value)">
										<option value="0">简单表配置</option>
										<option value="1">复杂表配置</option>
									</select>
								</td>
				        	</tr>
				        	<tr class="dp_sim_table">
						  		<td class="inquire_item6">配置表名称：</td>
				    			<td class="inquire_form6">
				    				<input type="text" id="conf_table_name" name="conf_table_name" class="input_width main"/>
				    			</td>
								<td class="inquire_item6">配置查询列：</td>
				    			<td class="inquire_form6">
				    				<input type="text" id="conf_column_name" name="conf_column_name" class="input_width main"/>
				    			</td>
				        	</tr>
				        	<tr class="hd_co_view">
						  		<td class="inquire_item6">复杂表配置内容：</td>
				    			<td class="inquire_form6" colspan="3">
				    				<textarea id="conf_content" name="conf_content" class="textarea main" style="height:160px"></textarea>
								</td>
				        	</tr>
						</table>
					</fieldset>
					<fieldset style="margin-left:2px;height:240px;overflow-y:auto;" class="dp_sim_table" >
						<legend>配置项条件信息</legend>
						<table  style="table-layout:fixed;" width="100%" border="0" cellspacing="0" cellpadding="0"
							class="tab_info" id="itemTable">
							<tr>
								<td width="5%" class="ali_btn">
									<span class="zj"><a href="javascript:void(0);" onclick="insertTr()" title="添加"></a></span>
								</td>
								<td width="15%">条件连接类型</td>
								<td width="15%">配置列类型</td>
								<td width="15%">配置列名称</td>
								<td width="15%">列值连接类型</td>
								<td width="20%">列值</td>
								<td width="15%">日期类型格式</td>
							</tr>
						</table>
					</fieldset>
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
	var contextpath= "<%=contextPath%>";
	//配置表ID
	var conf_id= "<%=conf_id%>";
	//增加修改标志
	var flag="<%=flag%>";
	$(function(){
		if("update"==flag){
			var retObj = jcdpCallService("AutoScoreSrv", "getAutoScoreInfo", "conf_id="+conf_id);
			if(typeof retObj.data!="undefined"){
				var data = retObj.data;
				if('0'==data.conf_content_type){
					$(".dp_sim_table").show();
					$(".hd_co_view").hide();
				}
				if('1'==data.conf_content_type){
					$(".dp_sim_table").hide();
					$(".hd_co_view").show();
				}
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(data[temp] != undefined ? data[temp]:"");
				});
			}
			if(typeof retObj.datas!="undefined"){
				var datas = retObj.datas;
				for(var i=0;i<datas.length;i++){
					var ts=insertTr("old");
					var data=datas[i];
					$.each(data, function(k, v){
						if(null!=v && ""!=v){
							$("#itemTable #"+k+"_"+ts).val(v);
						}
					});
				}
			}
		}else{
			$(".hd_co_view").hide();
			$("#conf_column_name").val("*");
		}
	});
	
	//保存
	function toSubmit(){
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
	//指标项序号
	var order = 0;
	//添加指标项行
	function insertTr(old){
		order++;
		var timestamp=new Date().getTime();//获取时间戳
		var temp = "";
		if(old=="old"){
			temp +="<tr id='tr_"+order+"' class='old' tempindex='"+timestamp+"'>";
		}else{
			temp +="<tr id='tr_"+order+"' class='new' tempindex='"+timestamp+"'>";
		}
		temp =temp + ("<td>"+
				"<input name='conf_filter_id_"+timestamp+"' id='conf_filter_id_"+timestamp+"' type='hidden'/>"+
				"<img src='<%=contextPath%>/images/delete.png' width='16' height='16' style='cursor:hand;' onclick='deleteTr(this)'/>"+
			"</td>"+
			"<td>"+
				"<select name='connect_type_"+timestamp+"' id='connect_type_"+timestamp+"' style='height:20px;width:98%;' >"+
					"<option value='and'>and</option>"+
					"<option value='or'>or</option>"+
				"</select>"+
			"</td>"+
			"<td>"+
				"<select name='filter_column_type_"+timestamp+"' id='filter_column_type_"+timestamp+"' style='height:20px;width:98%;' >"+
					"<option value='string'>字符</option>"+
					"<option value='number'>数值</option>"+
					"<option value='date'>日期</option>"+
				"</select>"+
			"</td>"+
			"<td>"+
				"<input name='filter_column_name_"+timestamp+"' id='filter_column_name_"+timestamp+"' type='text' style='height:20px;width:98%;' />"+
			"</td>"+
			"<td>"+
				"<select name='query_type_"+timestamp+"' id='query_type_"+timestamp+"' style='height:20px;width:98%;' >"+
					"<option value='='>=</option>"+
					"<option value='<>'><></option>"+
					"<option value='>'>></option>"+
					"<option value='>='>>=</option>"+
					"<option value='<'><</option>"+
					"<option value='<='><=</option>"+
					"<option value='like'>like</option>"+
					"<option value='in'>in</option>"+
				"</select>"+
			"</td>"+
			"<td>"+
				"<input name='filter_column_value_"+timestamp+"' id='filter_column_value_"+timestamp+"' type='text' style='height:20px;width:98%;' />"+
			"</td>"+
			"<td>"+
				"<input name='date_type_format_"+timestamp+"' id='date_type_format_"+timestamp+"' type='text' style='height:20px;width:98%;' />"+
			"</td>"+
		"</tr>");
		$("#itemTable").append(temp);
		return timestamp; 
	}
	//删除指标项行
	function deleteTr(item){
		//页面修改时要处理的操作
		if($(item).parent().parent().attr("class")=="old"){
			var confFilterId = $(item).parent().children("input").first().val();
			var tts = new Date().getTime();//获取时间戳
			$("#form").append("<input type='hidden' name='del_tr_"+tts+"' value='"+confFilterId+"'/>");
		}
		//获取行id
		var temp = $(item).parent().parent().attr("id");
		//删除行
		$(item).parent().parent().remove();
		//序号重新排序
		var _index = parseInt(temp.split("_")[1]);
		for(var j=_index;j<order;j++){
			//给tr 属性 赋值
			$("#tr_"+(j+1)).attr("id","tr_"+j);
		}
		//索引减一
		order=order-1;
	}
	function confSelect(v){
		if('0'==v){
			$(".dp_sim_table").show();
			$(".hd_co_view").hide();
			$("#conf_content").val("");
		}
		if('1'==v){
			$(".dp_sim_table").hide();
			$(".hd_co_view").show();
			$("#conf_table_name").val("");
			$("#conf_column_name").val("");
		}
	}
</script>
</html>