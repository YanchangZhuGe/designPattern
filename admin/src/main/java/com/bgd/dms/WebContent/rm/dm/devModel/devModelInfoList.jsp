<%@page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="auth" uri="auth"%>
<%@taglib uri="wf" prefix="wf"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
  <title>配置计划申请</title> 
 </head> 
 
 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  </tr>
			  <tr>
			  	<td class="ali_cdn_name">模板名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_project_name" name="s_dev_model_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_cdn_name">创建单位名称</td>
			    <td class="ali_cdn_input">
			    	<input id="s_org_name" name="s_org_name" type="text" class="input_width" />
			    </td>
			    <td class="ali_query">
			    	<span class="cx"><a href="#" onclick="searchDevData()" title="查询"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="清除"></a></span>
			    </td>
			    <td>&nbsp;</td>
			    <auth:ListButton functionId="" css="zj" event="onclick='toAddMainPlanPage()'" title="新增"></auth:ListButton>
			    <auth:ListButton functionId="" css="xg" event="onclick='toModifyMainPlanPage()'" title="修改"></auth:ListButton>
			    <auth:ListButton functionId="" css="sc" event="onclick='toDelPlanPage()'" title="删除"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">		
			     <tr id='device_model_id_{dev_model_id}' name='dev_model_id' idinfo='{dev_model_id}'>
			     	<td class="bt_info_odd" exp="<input type='checkbox' name='selectedbox' value='{dev_model_id}~{model_type}' id='selectedbox_{dev_model_id}' onclick='chooseOne(this)'/>" >选择</td>
					<td class="bt_info_even" autoOrder="1">序号</td>
					<td class="bt_info_odd" exp="{dev_model_name}">模板名称</td>
					<td class="bt_info_even" exp="{org_abbreviation}">创建单位</td>
					<td class="bt_info_odd" exp="{user_name}"> 创建人</td>
					<td class="bt_info_even" exp="{create_date}">创建时间</td>
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
			    <li class="selectTag" id="tag3_0" ><a href="#" onclick="getContentTab(this,0)">基本信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,1)">明细信息</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,2)">附件</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,3)">备注</a></li>
			    <li id="tag3_1"><a href="#" onclick="getContentTab(this,4)">分类码</a></li>
			  </ul>
			</div>
			<div id="tab_box" class="tab_box">
				<div id="tab_box_content0" name="tab_box_content0" class="tab_box_content">
					<table id="projectMap" name="projectMap" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" width="100%" style="margin-top:10px;background:#efefef"> 
					<tr>
				      <td  class="inquire_item6">模板名称：</td>
				      <td  class="inquire_form6" ><input id="dev_model_name" class="input_width" type="text" value="" disabled/>&nbsp;</td>
				      <td  class="inquire_item6">创建单位：</td>
				      <td  class="inquire_form6"><input id="org_abbreviation" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				      <td  class="inquire_item6">&nbsp;创建人：</td>
				      <td  class="inquire_form6"  ><input id="user_name" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				     </tr>
				    <tr >
				     <td  class="inquire_item6">创建时间：</td>
				      <td  class="inquire_form6"  ><input id="create_date" class="input_width" type="text"  value="" disabled/> &nbsp;</td>
				    </tr>
					</table>
				</div>
				<div id="tab_box_content1" name="tab_box_content1" idinfo="" class="tab_box_content" style="display:none">
					<table id="detailtitletable" border="0" cellpadding="0" cellspacing="0"  class="tab_line_height" style="width:98.5%;margin-top:10px;background:#efefef"> 
						<tr class="bt_info">
				            <td class="bt_info_even">序号</td>
							<td class="bt_info_odd">设备名称</td>
							<td class="bt_info_even">规格型号</td>
							<td class="bt_info_odd">单位</td>
							<td class="bt_info_even">备注</td>
				        </tr>
					</table>
					<div style="height:70%;overflow:auto;">
				      	<table style="width:98.5%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
					   		<tbody id="detailMap" name="detailMap" >
					   		</tbody>
				      	</table>
			        </div>
				</div>
				<div id="tab_box_content2" name="tab_box_content2" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="attachement" id="attachement" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content3" name="tab_box_content3" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="remark" id="remark" frameborder="0" src="" marginheight="0" marginwidth="0" ></iframe>
				</div>
				<div id="tab_box_content4" name="tab_box_content4" class="tab_box_content" style="display:none">
					<iframe width="100%" height="100%" name="codeManager" id="codeManager" frameborder="0" src="" marginheight="0" marginwidth="0"  scrolling="auto" style="overflow: scroll;"></iframe>
				</div>
		 </div>
</div>
</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-60);
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

	var selectedTagIndex = 0;
	function getContentTab(obj,index) { 
		selectedTagIndex = index;
		if(obj!=undefined){
			$("LI","#tag-container_3").removeClass("selectTag");
			var contentSelectedTag = obj.parentElement;
			contentSelectedTag.className ="selectTag";
		}
		var filterobj = ".tab_box_content[name=tab_box_content"+index+"]";
		var filternotobj = ".tab_box_content[name!=tab_box_content"+index+"]";
		var currentid ;
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				currentid = this.value;
			}
		});
		if(index == 1){
			//动态查询明细
			var idinfo = $(filterobj).attr("idinfo");
			if(currentid != undefined && idinfo == currentid){
				//已经有值，且完成钻取，那么不再钻取
			}else{
				//先进行查询
				currentid = currentid.substr(0,currentid.length-2);
				var str = "select d.*,sd.coding_name,nvl(csd.coding_name,d.dev_type)as devtype from gms_dev_model_detail d left join comm_coding_sort_detail sd on d.unit=sd.coding_code_id left join comm_coding_sort_detail csd on d.dev_type=csd.coding_code_id  where d.gms_dev_model_id ='"+currentid+"' ";
				
				var param = new Object();
				
				var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+str+'&pageSize=10000');
				basedatas = queryRet.datas;
				if(basedatas!=undefined && basedatas.length>=1){
					//先清空
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					appendDataToDetailTab(filtermapid,basedatas);
					//设置当前标签页显示的主键
					$(filterobj).attr("idinfo",currentid);
				}else{
					var filtermapid = "#detailMap";
					$(filtermapid).empty();
					$(filterobj).attr("idinfo",currentid);
				}
			}
		}else if(index == 2){
			$("#attachement").attr("src","<%=contextPath%>/doc/common/common_doc_list.jsp?relationId="+currentid);
		}else if(index == 3){
			$("#remark").attr("src","<%=contextPath%>/common/remark/relatedOperation.srq?foreignKeyId="+currentid);
		}else if(index == 4){
			$("#codeManager").attr("src","<%=contextPath%>/pm/projectCode/projectCodeAssignment.jsp?owner=5&relationId="+currentid);
		}
		$(filternotobj).hide();
		$(filterobj).show();
		//对标题行的宽度进行设置
		var titletrid = "#detailtitletable";
		var contentid = "#detailMap";
		aligntitle(titletrid,contentid);
	}
	function appendDataToDetailTab(filterobj,datas){
		for(var i=0;i<basedatas.length;i++){
			var innerHTML = "<tr>";
			innerHTML += "<td>"+(i+1)+"</td><td>"+datas[i].dev_name+"</td><td>"+datas[i].devtype+"</td>";
			innerHTML += "<td>"+datas[i].coding_name+"</td><td>"+datas[i].purpose+"</td>";
			innerHTML += "</tr>";
			$(filterobj).append(innerHTML);
		}
		$(filterobj+">tr:odd>td:odd").addClass("odd_odd");
		$(filterobj+">tr:odd>td:even").addClass("odd_even");
		$(filterobj+">tr:even>td:odd").addClass("even_odd");
		$(filterobj+">tr:even>td:even").addClass("even_even");
	}
	//调用此方法，可以实现上下两个table的方式实现表头固定和对齐，参考planMaininfoList.jsp的#detailtitletable和#detailMap
	function aligntitle(titletrid,filterobj){
		var titlecells = $("tr",titletrid)[0].cells;
		var contenttr = $("tr",filterobj)[0];
		if(contenttr==undefined)
			return;
		var contentcells = contenttr.cells
		for(var index=0;index<titlecells.length;index++){
			var widthinfo = contentcells[index].offsetWidth;
			if(widthinfo>0){
				titlecells[index].width = widthinfo+'px';
			}
		}
	}
	$(document).ready(lashen);
</script>
 
<script type="text/javascript">
	var projectInfoNos = '<%=projectInfoNo%>';
	
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	function clearQueryText(){
		$("#s_dev_model_name").val("");
		$("#s_org_name").val("");
	}
	function searchDevData(){
		var v_s_dev_model_name = document.getElementById("s_dev_model_name").value;
		var v_org_name = document.getElementById("s_org_name").value;
		refreshData(v_s_dev_model_name, v_org_name);
	}
	function getdate() { 
		var   now=new   Date() 
		y=now.getFullYear() 
		m=now.getMonth()+1 
		d=now.getDate() 
		m=m <10? "0"+m:m 
		d=d <10? "0"+d:d 
		return   y + "-" + m + "-" + d ;
	}
	
    function refreshData(v_s_dev_model_name,v_org_name){
		var str = "select m.dev_model_id,m.model_type,m.dev_model_name,o.org_abbreviation,u.user_name,m.create_date from gms_dev_model m left join comm_org_information o on m.org_id=o.org_id and o.bsflag='0' left join p_auth_user u on m.creator_id=u.user_id and u.bsflag='0' where m.bsflag='0'";
		if(v_s_dev_model_name!=undefined && v_s_dev_model_name!=''){
			str += "and m.dev_model_name like '%"+v_s_dev_model_name+"%' ";
		}
		if(v_org_name!=undefined && v_org_name!=''){
			str += "and o.org_name like '%"+v_org_name+"%' ";
		}
		cruConfig.queryStr = str;
		queryData(cruConfig.currentPage);;
	}
    function loadDataDetail(dev_model_id){
    	var devmodelid = dev_model_id.substr(0,dev_model_id.length-2);
    	var retObj;
		if(dev_model_id!=null){
			 retObj = jcdpCallService("DevCommInfoSrv", "getDevModelBaseInfo", "devmodelid="+devmodelid);
			 chooseOne(dev_model_id);
			
		}else{
			var ids = getSelIds('selectedbox');
		    if(ids==''){ 
			    alert("请先选中一条记录!");
	     		return;
		    }
		    retObj = jcdpCallService("DevCommInfoSrv", "getDevModelBaseInfo", "devmodelid="+ids);
		    chooseOne(ids);
		}
		//选中这一条checkbox
		$("#selectedbox_"+retObj.devModelMap.dev_model_id).attr("checked","checked");
		//给数据回填
		$("#dev_model_name","#projectMap").val(retObj.devModelMap.dev_model_name);
		$("#org_abbreviation","#projectMap").val(retObj.devModelMap.org_abbreviation);
		$("#user_name","#projectMap").val(retObj.devModelMap.user_name);
		$("#create_date","#projectMap").val(retObj.devModelMap.create_date);
    }
	function toAddMainPlanPage(){
		popWindow('<%=contextPath%>/rm/dm/devModel/devmodel_new.jsp');
	}
	function toModifyMainPlanPage(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += ""+this.value+"";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		popWindow('<%=contextPath%>/rm/dm/devModel/devmodel_modefy.jsp?projectInfoNo=<%=projectInfoNo%>&devmodelid='+selectedid);
	}
	function toDelPlanPage(){
		var length = 0;
		var selectedid = "";
		$("input[type='checkbox'][name='selectedbox']").each(function(){
			if(this.checked == true){
				if(length!=0){
					selectedid += ",";
				}
				selectedid += "'"+this.value+"'";
				length = length+1;
			}
		});
		if(length == 0){
			alert("请选择记录！");
			return;
		}
		if(confirm("是否执行删除操作?")){
			var sql = "update gms_dev_model set bsflag='1' where dev_model_id in ("+selectedid+")";
			var path = cruConfig.contextPath+"/rad/asyncDelete.srq";
			var params = "deleteSql="+sql;
			params += "&ids=";
			var retObject = syncRequest('Post',path,params);
			refreshData();
		}
}
	
    //chooseOne()函式，參數為觸發該函式的元素本身   
    function chooseOne(cb){
        //先取得同name的chekcBox的集合物件   
        var obj = document.getElementsByName("selectedbox");
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