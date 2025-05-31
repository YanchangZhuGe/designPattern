<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="java.util.Date"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	String keeping_id = request.getParameter("keeping_id");
	UserToken user = OMSMVCUtil.getUserToken(request);
	String addUpFlag = request.getParameter("addupflag");
	if(null==addUpFlag){
		addUpFlag="add";
	}
	String thing_type = request.getParameter("thing_type");
	String appDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date());
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
<title>设备出入库界面</title>
</head>
<body class="bgColor_f3f3f3" onload="refreshData();">
<form name="form1" id="form1" method="post" action=""  enctype="multipart/form-data">
<div id="new_table_box" style="width:98%" >
 <div id="new_table_box_content" style="background-color: rgb(241, 242, 243)">
    <div id="new_table_box_bg" style="width:95%">
      <fieldset style="margin:2px;padding:2px;"><legend>设备出入库基本信息</legend>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
       <tr>
       	  <input name="dev_type"    id="dev_type"    type="hidden" value="" class="main"/>
          <input name="dev_tname"   id="dev_tname"   type="hidden" value="" class="main"/>
          <input name="dev_id" 	    id="dev_id"      type="hidden" value="" class="main"/>
          <input name="provpos"     id="provpos"     type="hidden" value="" class="main"/>
		  <input name="provposcode" id="provposcode" type="hidden" value="" class="main"/>
		  <td class="inquire_item4" ><font color=red>*</font>&nbsp;设备名称</td>
          <td class="inquire_form4" >
          	<input name="dev_name" id="dev_name" class="input_width easyui-tooltip main" type="text" value=""  style="width:130px"  readonly/>
          	<%if("1".equals(thing_type)){ %>
          		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevTreePage()"  />
          	<%}else{ %>
          		<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:pointer;" onclick="showDevPage()"  />
          	<%} %>
          </td>
          <td class="inquire_item4" >&nbsp;号牌号码</td>
          <td class="inquire_form4" >
          	<input name="dev_num" id="dev_num" class="input_width easyui-tooltip main" type="text" value=""  style="width:130px"  readonly/>
          </td>
          <td class="inquire_item4" >&nbsp;自编号</td>
          <td class="inquire_form4" >
          	<input name="self_num" id="self_num" class="input_width easyui-tooltip main" type="text" value="" style="width:130px"  readonly/>
          </td>
        </tr>
        <tr>
        	<td class="inquire_item4">&nbsp;实物标识号:</td>
		  	<td class="inquire_form4" >
          	<input name="dev_sign" id="dev_sign" class="input_width easyui-tooltip main" type="text" value="" style="width:130px"  readonly/>
          	</td>
          	<td class="inquire_item4" >&nbsp;业务类型:</td>
          	<td class="inquire_form4" >
			<select id="thing_type" name="thing_type" class="input_width easyui-combobox" style="width:130px;float:none;" disabled>
						 		<option value="">---请选择---</option>
								<option value="1">入库</option>
								<option value="-1">出库</option>
			</select>		
            </td>
			<td class="inquire_item4">进/出库时间:</td>
            <td class="inquire_form4">
				<input type="text" name="keeping_date" id="keeping_date" value="<%=appDate %>" class="input_width easyui-datebox" style="width:130px" editable="false" required/>
		    </td>
		</tr>
        <tr>
        	<td class="inquire_item4">调配日期:</td>
			<td class="inquire_form4">
				<input type="text" name="turn_date" id="turn_date" value="<%=appDate %>" class="input_width easyui-datebox" style="width:130px" editable="false" required/>
			</td>
			<td class="inquire_item4">&nbsp;经办单位:</td>
          	<td class="inquire_form4">
          	<input name="out_org_name" id="out_org_name" class="input_width main" style="width:130px" type="text" value="<%=user.getOrgName() %>" readonly/>
          		<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showOrgTreePage()" />
          	<input name="sub_org_id" id="sub_org_id" class="input_width main" type="hidden"  value="<%=user.getOrgId() %>" />
          	<input name="out_sub_id" id="out_sub_id" class="input_width main" type="hidden"  value="" />
          	</td>
          	<td class="inquire_item4">&nbsp;交接经办人:</td>
          	<td class="inquire_form4"><input name="turn_pp" id="turn_pp" class="input_width main" style="width:130px" type="text" value="" required/></td>
		</tr>
        <tr>
		  <td class="inquire_item4">&nbsp;设备调拨单号:</td>
          <td class="inquire_form4"><input name="dev_turn_num" id="dev_turn_num" class="input_width main" style="width:130px"  type="text" value="" required/></td>
          <td class="inquire_item4">&nbsp;签发人:</td>
          <td class="inquire_form4"><input name="given_pp" id="given_pp" class="input_width main" type="text" style="width:130px" value="" required/></td>
          <td class="inquire_item4">&nbsp;库房经办人:</td>
          <td class="inquire_form4"><input name="keeping_pp" id="keeping_pp" class="input_width main" style="width:130px" type="text" value="<%=user.getUserName()%>" required/></td>
        </tr>
        <tr>
		  <td class="inquire_item4">&nbsp;整车卫生:</td>
          <td class="inquire_form4">
	          <select name="dev_clean" id="dev_clean" class="input_width easyui-combobox" style="width:130px;float:none;" editable="false">
		 		<option value="合格">合格</option>
				<option value="一般">一般</option>
				<option value="略差">略差</option>
			  </select>
		  </td>
          <td class="inquire_item4">牌照数量:</td>
          <td class="inquire_form4">
	          <select name="mark_num" id="mark_num" class="input_width easyui-combobox" style="width:130px;float:none;" editable="false">
		 		<option value="无">无</option>
		 		<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
			  </select>
		  </td>
          <td class="inquire_item4">&nbsp;车辆证件数量:</td>
          <td class="inquire_form4">
	          <select name="port_num" id="port_num" class="input_width easyui-combobox" style="width:130px;float:none;" editable="false">
		 		<option value="无">无</option>
		 		<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
			  </select>
		  </td>
        </tr>
        <tr>
		  <td class="inquire_item4">&nbsp;车钥匙数量:</td>
		  <td class="inquire_form4">
			  <select name="key_num" id="key_num" class="input_width easyui-combobox" style="width:130px;float:none;" editable="false">
		 		<option value="无">无</option>
		 		<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
			  </select>
		  </td>
          <td class="inquire_item4">&nbsp;随车工具数量:</td>
          <td class="inquire_form4">
	          <select name="tool_num" id="tool_num" class="input_width easyui-combobox" style="width:130px;float:none;" editable="false">
		 		<option value="无">无</option>
		 		<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
			  </select>
		  </td>
          <td class="inquire_item4">防冻液冰点:</td>
          <td class="inquire_form4">
	          <select name="freezing_point" id="freezing_point" class="input_width easyui-combobox" style="width:130px;float:none;" editable="false">
		 		<option value="-10℃~-20℃">-10℃~-20℃</option>
		 		<option value="-20℃~-30℃">-20℃~-30℃</option>
				<option value="-30℃~-40℃">-30℃~-40℃</option>
				<option value="-40℃~-50℃">-40℃~-50℃</option>
				<option value="-50℃~-60℃">-50℃~-60℃</option>
			  </select>
		  </td>
        </tr>
        <tr>
          <td class="inquire_item4">&nbsp;备胎数量:</td>
          <td class="inquire_form4">
	          <select name="spare_tire_num" id="spare_tire_num" class="input_width easyui-combobox" style="width:130px;float:none;" editable="false">
		 		<option value="无">无</option>
		 		<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
			  </select>
		  </td>
          <td class="inquire_item4">灭火器数量:</td>
          <td class="inquire_form4">
	          <select name="fire_extinguisher" id="fire_extinguisher" class="input_width easyui-combobox" style="width:130px;float:none;" editable="false">
		 		<option value="无">无</option>
		 		<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
			  </select>
		  </td>
          <td class="inquire_item4">&nbsp;其他缺件登记:</td>
          <td class="inquire_form4"><input name="other" id="other" class="input_width main" type="text" style="width:130px" value="" required/></td>
        </tr>
        <tr>
		   <td class="inquire_item4"><font color=red>*</font>&nbsp;省/资产库:</td>
           <td class="inquire_form4"><input name="province" class="input_width" id="province" style="width:130px;" /></td>         
           <td class="inquire_item4">市/单位:</td>
           <td class="inquire_form4"><input name="city" class="input_width" id="city" style="width:130px;" /></td>                                             
           <td class="inquire_item4">县区/库房:</td>
           <td class="inquire_form4"><input name="county" class="input_width" id="county" style="width:130px;" /></td>
		</tr>
        <tr>
		  <td class="inquire_item4">&nbsp;存档资料:</td>
		  <auth:ListButton functionId="" css="dr" event="onclick='excelDataAdd(1)'"></auth:ListButton>
		</tr>
		<tr>
	   	  <td colspan="3">
		 	<table style="width:97.9%"  border="0" cellspacing="0" cellpadding="0" id="keeping_post">
				<input name="keeping_post_" style="width:150px" id="keeping_post_" type="hidden" />
		 	</table>
	   	  </td>
		</tr>
      </table>
      </fieldset>
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
	var contextpath= "<%=contextPath%>";
	//通知表ID
	var keeping_id= "<%=keeping_id%>";
	//增加修改标志
	var flag="<%=addUpFlag%>";
	
	var pos_id = "";
	
	//加载数据
	function loadDate(){
		var baseData; 
		var retObj ;
		baseData = jcdpCallService("DevKeeping", "getKeepingConfInfo", "keeping_id=<%=keeping_id%>");
		var thing_type = <%=thing_type%>
		$("#thing_type").combobox("setValue",thing_type);
		if(typeof baseData.fdataPublic!="undefined"){ 
			// 有附件显示附件
			for (var tr_id = 1; tr_id<=baseData.fdataPublic.length; tr_id++) {
				if(baseData.fdataPublic[tr_id-1].file_type =="keeping_post"){
					insertFilePublic(baseData.fdataPublic[tr_id-1].file_name,baseData.fdataPublic[tr_id-1].file_id);
					flag_public=1;
				}
			}
		}
		if("up"==flag){
			retObj = jcdpCallService("DevKeeping", "getKeepingConfInfo","keeping_id=<%=keeping_id%>");
			if(typeof retObj.data!="undefined"){
				var _ddata = retObj.data;
				$(".main").each(function(){
					var temp = this.id;
					$("#"+temp).val(_ddata[temp] != undefined ? _ddata[temp]:"");
				});
			}
			$("#thing_type").combobox("setValue", retObj.data.thing_type);
			$("#keeping_date").datebox("setValue", retObj.data.keeping_date);
			$("#turn_date").datebox("setValue", retObj.data.turn_date);
			$("#dev_clean").combobox("setValue", retObj.data.dev_clean);
			$("#mark_num").combobox("setValue", retObj.data.mark_num);
			$("#port_num").combobox("setValue", retObj.data.port_num);
			$("#key_num").combobox("setValue", retObj.data.key_num);
			$("#tool_num").combobox("setValue", retObj.data.tool_num);
			$("#freezing_point").combobox("setValue", retObj.data.freezing_point);
			$("#spare_tire_num").combobox("setValue", retObj.data.spare_tire_num);
			$("#fire_extinguisher").combobox("setValue", retObj.data.fire_extinguisher);
		}
	}

	$(function() {        
	    // 下拉框选择控件，下拉框的内容是动态查询数据库信息  
		$('#province').combobox({ 
			url:'<%=contextPath%>/rm/dm/toGetJsonDevPos.srq?posflag=S',
			editable:false, //不可编辑状态
			cache: false,//设置为false将不会从浏览器缓存中加载请求信息
			valueField:'code',   
			textField:'note',
			value:'请选择...', 
			onLoadSuccess: function(){
				if("add"==flag){
					$("#province").combobox("select","910000");
				}else{
					var retObj = jcdpCallService("DevKeeping", "getKeepingConfInfo","keeping_id=<%=keeping_id%>");
					var strs= new Array(); //定义一数组
					strs = retObj.data.keeping_position.split("-");
					var cc = jcdpCallService("DevKeeping", "getProvinceConfInfo","pos_name="+strs[0]);
					$("#province").combobox("select",cc.data.pos_id);
				}
				var province = $('#province').combobox('getValue');
				if(province!=''){
					$.ajax({
						type: "POST",
						url: "<%=contextPath%>/rm/dm/toGetJsonDevPos.srq?posvalue="+province,
						cache: false,
						dataType : "json",
						success: function(data){
							debugger;
							$("#city").combobox("loadData",data);
							if("add"==flag){
								retObj = jcdpCallService("DevKeeping", "getKeepingPosition","");
								$("#city").combobox("select",retObj.data.code);
							}else{
								var cc = jcdpCallService("DevKeeping", "getProvinceConfInfo","pos_name="+strs[1]);
								$("#city").combobox("select",cc.data.pos_id);
							}
							var city = $('#city').combobox('getValue');
							if(city!=''){
								$.ajax({
									type: "POST",
									url: "<%=contextPath%>/rm/dm/toGetJsonDevPos.srq?posvalue="+city,
									cache: false,
									dataType : "json",
									success: function(data){
										$("#county").combobox("loadData",data);
										if("up"==flag){
											var cc = jcdpCallService("DevKeeping", "getProvinceConfInfo","pos_name="+strs[2]);
											$("#county").combobox("select",cc.data.pos_id);
										}
						        	}
					         	});
							}
			        	}
		         	});
		        }
			},
			onHidePanel: function(){
		    	$("#city").combobox("setValue",'');
		    	$("#county").combobox("setValue",'');
		    	$("#county").combobox('loadData', {});
				var province = $('#province').combobox('getValue');	
				if(province!=''){
					$.ajax({
						type: "POST",
						url: "<%=contextPath%>/rm/dm/toGetJsonDevPos.srq?posvalue="+province,
						cache: false,
						dataType : "json",
						success: function(data){
							$("#city").combobox("loadData",data);
			        	}
		         	});
		        }
		    }
	    });
		$('#city').combobox({
		    editable:false, //不可编辑状态
		    cache: false,
		    valueField:'code',   
		    textField:'note',
		    onHidePanel: function(){
		    	$("#county").combobox("setValue",'');
				var city = $('#city').combobox('getValue');	
				if(city!=''){
					$.ajax({
						type: "POST",
						url: "<%=contextPath%>/rm/dm/toGetJsonDevPos.srq?posvalue="+city,
							cache: false,
							dataType : "json",
							success: function(data){
								$("#county").combobox("loadData",data);
					        }
				     }); 	
		         }
		     }
		});
	 	$('#county').combobox({ 
		    editable:false, //不可编辑状态
		    cache: false,
		    valueField:'code',   
		    textField:'note',
		    onHidePanel: function(){
	        	var str=$('#county').combobox('getText');
	        }
		 });			
	});  

	$().ready(function(){
		//第一次进入页面移除验证提示
		$('.validatebox-text').removeClass('validatebox-invalid');
	})
	cruConfig.contextPath = "<%=contextPath%>";
	cruConfig.cdtType = 'form1';
	
	$(function(){
		loadDate();
	});
	
	//选择单位设备
	function showDevTreePage(){
		var out_org_id = $("#out_sub_id").val();
		var returnValue = window.showModalDialog("<%=contextPath%>/rm/dm/devSpecial/add_devpage.jsp?out_org_id="+out_org_id,"","dialogWidth=1200px;dialogHeight=480px");			
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("@");
		document.getElementById("dev_id").value = strs[0];
		var retObj = jcdpCallService("DevInfoConf", "getKeepingDev","dev_acc_id="+strs[0]);
		document.getElementById("dev_num").value = retObj.data.license_num;
		document.getElementById("dev_type").value = retObj.data.dev_type;
		document.getElementById("self_num").value = retObj.data.self_num;
		document.getElementById("dev_name").value = retObj.data.dev_name;
		document.getElementById("dev_tname").value = retObj.data.dev_model;
		document.getElementById("dev_sign").value = retObj.data.dev_sign;
	}
	
	//选择单位设备
	function showDevPage(){
		var out_org_id = $("#out_sub_id").val();
		var returnValue = window.showModalDialog("<%=contextPath%>/dmsManager/safekeeping/selectBYKeeping.jsp?out_org_id="+out_org_id,"","dialogWidth=1200px;dialogHeight=480px");			
		var strs= new Array(); //定义一数组
		debugger;
		if(!returnValue){
			return;
		}
		strs = returnValue.split("@"); //字符分割
		document.getElementById("dev_id").value = strs[0];
		retObj = jcdpCallService("DevInfoConf", "getKeepingDev","dev_acc_id="+strs[0]);
		document.getElementById("dev_num").value = retObj.data.license_num;
		document.getElementById("dev_type").value = retObj.data.dev_type;
		document.getElementById("self_num").value = retObj.data.self_num;
		document.getElementById("dev_name").value = retObj.data.dev_name;
		document.getElementById("dev_tname").value = retObj.data.dev_model;
		document.getElementById("dev_sign").value = retObj.data.dev_sign;
	}
	
	//选择调配单位机构树
	function showOrgTreePage(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var outorgname = $("#out_org_name").val();
		if( outorgname != names[1] ){
			$("#processtable").empty();
		}
		document.getElementById("out_org_name").value = names[1];
		
		var orgId = strs[1].split(":");
		document.getElementById("sub_org_id").value = orgId[1];
		
		var orgSubId = strs[2].split(":");
		document.getElementById("out_sub_id").value = orgSubId[1];
	}
	 
	//提交保存
	function submitInfo(){
		//保留的行信息
		debugger;
		var dev_id = $.trim($("#dev_id").val());
		var dev_num = $.trim($("#dev_num").val());
		var sub_org_id = $.trim($("#sub_org_id").val());
		var turn_pp = $.trim($("#turn_pp").val());
		var keeping_pp = $.trim($("#keeping_pp").val());
		var given_pp = $.trim($("#given_pp").val());
		var province_text = "";//省份名称
		var province_code = "";//省份编码
		var city_text = "";//市名称
		var city_code = "";//市编码
		var county_text = "";//县区名称
		var county_code = "";//县区编码
		var provpos = "";
		var provposcode = "";
		province_text = $.trim($('#province').combobox('getText'));
		province_code = $('#province').combobox('getValue');
		
		city_text = $.trim($('#city').combobox('getText'));
		city_code = $('#city').combobox('getValue');
		
		county_text = $.trim($('#county').combobox('getText'));
		county_code = $('#county').combobox('getValue');
		if(province_text=='' || province_text=='请选择...'){
			$.messager.alert("提示","请选择设备存放地信息!","warning");
			return;
		}
		//选择设备资产库必须填写完成
		if(province_code == '910000'){
			if(city_text == ''){
				$.messager.alert("提示","请选择库房单位!","warning");
				return;
			}
			if(county_code == ''){
				$.messager.alert("提示","请选择具体库房!","warning");
				return;
			}
		}
		provposcode = province_code;
		provpos = province_text;
		if(city_text != ''){
			provpos = provpos + "-" + city_text;
			provposcode = city_code;
		}
		if(county_text != ''){
			provpos = provpos + "-" + county_text;
			provposcode = county_code;
		}
	    
	    $("#provpos").attr("value",provpos);
	    $("#provposcode").attr("value",provposcode);
		
		if("up"!=flag){
			var Obj = jcdpCallService("DevKeeping", "getKeepingDevInfo", "dev_id="+dev_id);
			if(typeof Obj.data!="undefined"){
				var x = Obj.data["thing_type"]
				if(x>0 && thing_type>=0 && x != ""){
					$.messager.alert("提示","设备已经在库!","warning");
					return;
				}
			}
		}
		$.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
            if (data) {
            	$.messager.progress({title:'请稍后',msg:'数据保存中....'});
    			$("#submitButton").attr({"disabled":"disabled"});
    			document.getElementById("form1").action = "<%=contextPath%>/dmsManager/safekeeping/saveOrUpdateKeepingConfInfo.srq?flag="+flag+"&keeping_id="+keeping_id;
    			document.getElementById("form1").submit();
            }
        });
	}

	//日期判断
	function disInput(index){
		//重新渲染加入的日期框
		$.parser.parse($("#tr"+index));
		//第一次进入移除验证
		$('.validatebox-text').removeClass('validatebox-invalid');
	}
	
	//新增附件
	function excelDataAdd(status){
			insertTrPublic('keeping_post');
	}
	
	//新增插入文件
	var orders = 0;
	function insertTrPublic(obj){
		var tmp="public";
		$("#"+obj+"").append(
			"<tr id='keeping_post'>"+
				"<td class='inquire_item' style='width:25%;text-align:right;' >附件：</td>"+
	  			"<td class='inquire_form'><input type='file' name='keeping_post__"+tmp+orders+"' id='ck_post__"+tmp+orders+"' onchange='getFileInfoPublic(this)' class='input_width' style='width:100%;text-align:left'/></td>"+
				"<td class='ali_btn'><span class='sc'><a href='javascript:void(0);' onclick='deleteInputPublic(this)'  title='删除'></a></span></td>"+
			"</tr>"	
		);
		orders++;
	}
	
	//显示已插入的文件
	function insertFilePublic(name,id){
		$("#keeping_post").append(
			"<tr>"+
			"<td class='inquire_form4' style='width:25%;text-align:right;'>附件:</td>"+
     			"<td class='inquire_form4' colspan='4' style='text-align:left;width:35%'><a href='<%=contextPath%>/doc/downloadDoc.srq?docId="+id+"'>"+name+"</a></td>"+
			"<td class='inquire_form4' style='width:40%'><span class='sc'><a href='javascript:void(0);' onclick=deleteFilePublic(this,\""+id+"\") title='删除'></a></span></td>"+
			"</tr>"
		);
	}
	
	//删除文件
	function deleteFilePublic(item,id){
		var tmp="public";
		$.messager.confirm("操作提示", "您确定要执行删除操作吗？", function (data) {
			if(data){
			$(item).parent().parent().parent().empty();
			jcdpCallService("ucmSrv", "deleteFile", "docId="+id);
			flag_public = 1;
			}
        });
	}
	
	// 获取文件信息
	function getFileInfoPublics(item){
		var docPath = $(item).val();
		var order = $(item).attr("id").split("_")[1];
		var docName = docPath.substring(docPath.lastIndexOf("\\")+1);
		var docTitle = docName.substring(0,docName.lastIndexOf("\."));
		$("#keeping_post_"+order).val(docTitle);//文件name
	}
	
	//删除行
	function deleteInputPublic(item){
		flag_public = 0;
		$(item).parent().parent().parent().remove();	
	}
</script>
</html>