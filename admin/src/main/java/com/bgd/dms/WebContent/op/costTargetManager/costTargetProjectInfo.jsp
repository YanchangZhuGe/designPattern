<%@ page contentType="text/html;charset=utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ taglib uri="auth" prefix="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String projectInfoNo = user.getProjectInfoNo();
	String targetBasicId=request.getParameter("targetBasicId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/pm/bpm/common/processInfoCommon.js"></script>

  <title>项目费用方案管理</title>
 </head>

 <body style="background:#fff" onload="refreshData()">
      	<div id="list_table">
		<div id="table_box"  style="height: 580px">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			  	<tr>
			  		<th  class="bt_info_odd">序号</th>
			  		<th  class="bt_info_even">项目</th>
			  		<th  class="bt_info_odd" colspan="3">内容</th>
			  	</tr>
			     <tr>
			     	<td  class="odd_odd">一</td>
			     	<td  class="odd_even">甲方名称</td>
			     	<td  class="odd_odd" colspan="3" id="coding_name"></td>
			     </tr>
			      <tr>
			     	<td  class="even_odd">二</td>
			     	<td  class="even_even">施工单位</td>
			     	<td  class="even_odd" colspan="3" id="org_name"></td>
			     </tr>
			      <tr>
			     	<td  class="odd_odd">三</td>
			     	<td  class="odd_even">项目名称</td>
			     	<td  class="odd_odd" colspan="3" id="project_name"></td>
			     </tr>
			      <tr>
			     	<td  class="even_odd">四</td>
			     	<td  class="even_even">地类</td>
			     	<td  class="even_odd" colspan="3" id="struct_unit_name"></td>
			     </tr>
			      <tr>
			     	<td  class="odd_odd">五</td>
			     	<td  class="odd_even">工作量</td>
			     	<td  class="odd_odd" colspan="3" id="work_load"></td>
			     </tr>
			      <tr>
			     	<td  class="even_odd">六</td>
			     	<td  class="even_even">地表条件</td>
			     	<td  class="even_odd" colspan="3"  id="work_situation"></td>
			     </tr>
			     
			      <tr>
			     	<td  class="odd_odd">七</td>
			     	<td  class="odd_even">施工因素</td>
			     	<td  class="odd_odd" colspan="3"  id="work_factor"></td>
			     </tr>
			      <tr>
			     	<td  class="even_odd">八</td>
			     	<td  class="even_even">影响施工效率的主要因素</td>
			     	<td  class="even_odd" colspan="3"  id="work_reason"></td>
			     </tr>
			     
			     <tr>
			     	<td  class="odd_odd">九</td>
			     	<td  class="odd_even">用工人数及工期</td>
			     	<td  class="odd_odd" colspan="3"  id="work_person"></td>
			     </tr>
			      <tr>
			     	<td  class="even_odd">十</td>
			     	<td  class="even_even">设备投入情况</td>
			     	<td  class="even_odd" colspan="3"  id="work_device"></td>
			     </tr>
			     <tr>
			     	<td  class="odd_odd">十一</td>
			     	<td  class="odd_even">费用名称</td>
			     	<td  class="odd_odd">金额</td>
			     	<td  class="odd_even">计算依据</td>
			     	<td  class="odd_odd">占采集直接成本比例(%)</td>
			     </tr>
			  </table>
			</div>
			<div id="fenye_box"  style="display:none"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
</div>
</body>

<script type="text/javascript">
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	var projectInfoNo = '<%=projectInfoNo%>';
	var targetBasicId='<%=targetBasicId%>';
	function refreshData(){
		//获取项目基本信息
		var querySql="select pb.*,ccsd.coding_name, oi.org_name, gp.project_name, su.struct_unit_name"+
  " from bgp_op_target_project_basic pb inner join gp_task_project gp "+
  " on pb.project_info_no = gp.project_info_no and gp.bsflag='0' "+
  " left outer join gp_task_project_dynamic dy on gp.project_info_no = dy.project_info_no and dy.bsflag = '0' "+
  " left outer join comm_org_information oi on oi.org_id = dy.org_id and oi.bsflag = '0' "+
  " left outer join gp_workarea_diviede wd on wd.workarea_no = gp.workarea_no and wd.bsflag = '0' "+
  " left join comm_coding_sort_detail ccsd on ccsd.coding_code_id = gp.manage_org and ccsd.bsflag = '0' "+
  " left join gp_structure_unit su on su.struct_unit_no = wd.struct_unit_first and ccsd.bsflag = '0' "+
  " where pb.tartget_basic_id='"+targetBasicId+"'";
		var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
		var datas = queryRet.datas;
		if(datas != null&&datas.length>0){
			
			document.getElementById("coding_name").innerHTML=datas[0].coding_name;
			document.getElementById("org_name").innerHTML=datas[0].org_name;
			document.getElementById("project_name").innerHTML=datas[0].project_name;
			document.getElementById("struct_unit_name").innerHTML=datas[0].struct_unit_name;
			
			
			document.getElementById("work_load").innerHTML=breakword(datas[0].work_load);
			document.getElementById("work_situation").innerHTML=breakword(datas[0].work_situation);
			document.getElementById("work_factor").innerHTML=breakword(datas[0].work_factor);
			
			document.getElementById("work_reason").innerHTML=breakword(datas[0].work_reason);
			document.getElementById("work_person").innerHTML=breakword(datas[0].work_person);
			document.getElementById("work_device").innerHTML=breakword(datas[0].work_device);
		}
		//载入费用信息
		var submitStr='projectInfoNo=<%=projectInfoNo%>';
		var retObject=jcdpCallService('OPCostSrv','getCostTargetProject',submitStr);
		var datas=retObject.datas;
		
		for(var i=0;i<datas.length;i++){
			var tr = document.getElementById("queryRetTable").insertRow();		
			if(i % 2 == 1){  
          		tr.className = "odd";
			}else{ 
				tr.className = "even";
			}
			var td = tr.insertCell(0);
			td.innerHTML = datas[i].pathPoint;
			var td = tr.insertCell(1);
			td.innerHTML = datas[i].costName;
			var td = tr.insertCell(2);
			td.innerHTML = datas[i].costDetailMoney;
			var td = tr.insertCell(3);
			td.innerHTML = datas[i].costDetailDesc;
			var td = tr.insertCell(4);
			td.innerHTML = '&nbsp;';
		}
	}
	function loadDataDetail(){

	}
    //chooseOne()函式，參數為觸發該函式的元素本身
    function chooseOne(cb){
        //先取得同name的chekcBox的集合物件
        var obj = document.getElementsByName("rdo_entity_id");
        for (i=0; i<obj.length; i++){
            //判斷obj集合中的i元素是否為cb，若否則表示未被點選
            if (obj[i]!=cb) obj[i].checked = false;
            //若是 但原先未被勾選 則變成勾選；反之 則變為未勾選
            //else  obj[i].checked = cb.checked;
            //若要至少勾選一個的話，則把上面那行else拿掉，換用下面那行
            else obj[i].checked = true;
        }
    }
    
    function breakword(strContent){
    	var strTemp="";
    	var intLen=40;
		while(strContent.length>intLen){
			strTemp+=strContent.substr(0,intLen)+'<br>';  
			strContent=strContent.substr(intLen,strContent.length);  
		}
		strTemp+=strContent;
		return strTemp;
    }
</script>
</html>