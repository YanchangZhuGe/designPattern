<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userOrgId = user.getSubOrgIDofAffordOrg();
	ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/hse/js/hseCommon.js"></script>
<script language="javaScript">
cruConfig.contextPath = "<%=contextPath%>";
var userOrgId='<%=userOrgId%>';

	function submit(){
		var ctt = top.frames('list');		
		var org_sub_id = document.getElementById("second_org2").value;
		var second_org = document.getElementById("third_org2").value;
		var third_org = document.getElementById("fourth_org").value; 
		var facilities_name = document.getElementById("facilities_name").value;  
		var specifications = document.getElementById("specifications").value;   
		var use_situation = document.getElementById("use_situation").value;   
		var technical_conditions = document.getElementById("technical_conditions").value;   
		var paizhaohao = document.getElementById("paizhaohao").value;   
		var equipment_one = document.getElementById("equipment_one").value;   
		var equipment_two = document.getElementById("equipment_two").value;   
		var release_date = document.getElementById("release_date").value;  
		var release_date2 = document.getElementById("release_date2").value;   
  
		var sqlSelect="";
		if(userOrgId=='C105'){
			sqlSelect="   (select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name, (case when t.owning_sub_id like 'C105001005%' then '塔里木物探处' else (case when t.owning_sub_id like 'C105001002%' then '新疆物探处'else(case when t.owning_sub_id like 'C105001003%' then '吐哈物探处'else(case when t.owning_sub_id like 'C105001004%' then '青海物探处'else(case when t.owning_sub_id like 'C105005004%' then '长庆物探处'else(case when t.owning_sub_id like 'C105005000%' then '华北物探处'else(case when t.owning_sub_id like 'C105005001%' then '新兴物探开发处'else(case when t.owning_sub_id like 'C105007%' then '大港物探处'else(case when t.owning_sub_id like 'C105063%' then '辽河物探处'else(case when t.owning_sub_id like 'C105006%' then '装备服务处'else (case when t.owning_sub_id like 'C105002%' then '国际勘探事业部'else (case when t.owning_sub_id like 'C105003%' then '研究院'else (case when t.owning_sub_id like 'C105008%' then '综合物化处'else (case when t.owning_sub_id like 'C105015%' then '井中地震中心'  else (case when t.owning_sub_id like 'C105017%' then '矿区服务事业部' else '' end) end) end) end) end) end) end) end) end) end) end) end) end) end) end) as org_name   ";
		}else{
			
			sqlSelect=" (select org_abbreviation  from comm_org_information org  where t.owning_org_id = org.org_id) as second_org_name , ( select  cit.org_abbreviation   from comm_org_subjection c  left join comm_org_information cit  on c.org_id=cit.org_id and cit.bsflag='0'  where c.org_subjection_id='<%=userOrgId%>' and c.bsflag='0' ) as org_name ";
		}
			
		
		var sql = "";  
		var sql =  "  select *  from ( select t.dev_acc_id as pk_id,     t.owning_org_id as org_sub_id,  '' second_org,  '' third_org,    t.bsflag,  t.using_stat as use_situation,     t.tech_stat as technical_conditions,  et.equipment_one as e_one,   et.equipment_two as e_two,"+sqlSelect+" ,t.dev_name as facilities_name,t.dev_model as specifications, (select coding_name  from comm_coding_sort_detail c  where t.using_stat = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where t.tech_stat = c.coding_code_id) as tech_stat_desc,t.producting_date as release_date,t.license_num as paizhaohao,(select coding_name  from comm_coding_sort_detail c  where et.equipment_one = c.coding_code_id) as equipment_one,   (select coding_name  from comm_coding_sort_detail c  where et.equipment_two = c.coding_code_id) as equipment_two ,'1'spare1,et.eq_id  from GMS_DEVICE_ACCOUNT t left join gms_device_account_equipment et on t.dev_acc_id=et.dev_acc_id  where t.bsflag = '0'  and t.dev_type like 'S08%' and substr(t.dev_type,2,4)!='0809' and substr(t.dev_type,2,4)!='0808'     and (t.owning_sub_id like '<%=userOrgId%>%' OR   t.USAGE_SUB_ID like '<%=userOrgId%>%')    "
			+" union "+
			"  select  tr.facilities_no as pk_id,         tr.org_sub_id,tr.second_org,tr.third_org,  tr.bsflag,     tr.use_situation,     tr.technical_conditions,    tr.equipment_one as e_one,    tr.equipment_two as e_two,    oi1.org_abbreviation as second_org_name, ion.org_abbreviation as org_name, tr.facilities_name,tr.specifications,  (select coding_name  from comm_coding_sort_detail c  where tr.use_situation = c.coding_code_id) as using_stat_desc,  (select coding_name  from comm_coding_sort_detail c  where tr.technical_conditions = c.coding_code_id) as tech_stat_desc,   tr.release_date,tr.paizhaohao,(select coding_name  from comm_coding_sort_detail c  where tr.equipment_one = c.coding_code_id) as equipment_one,   (select coding_name  from comm_coding_sort_detail c  where tr.equipment_two = c.coding_code_id) as equipment_two ,tr.spare1 ,tr.creator as eq_id  from BGP_FACILITIES_STANDBOOK tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'  left  join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'  left  join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'    left join comm_org_subjection ose    on tr.org_sub_id = ose.org_subjection_id   and ose.bsflag = '0'  join comm_org_information ion    on ion.org_id = ose.org_id     where tr.bsflag = '0'    order by spare1 desc  ) tr where tr.bsflag = '0'  "+sql;
 
		if(org_sub_id!=''&&org_sub_id!=null){
			sql = sql+" and tr.org_name  like '%"+org_sub_id+"%'";
		}
		if(second_org!=''&&second_org!=null){
			sql = sql+" and tr.second_org_name like '%"+second_org+"%'";
		}
		if(third_org!=''&&third_org!=null){
			sql = sql+" and tr.third_org = '"+third_org+"'";
		}
		if(facilities_name!=''&&facilities_name!=null){
			sql = sql+" and tr.facilities_name  like '%"+facilities_name+"%'";
		}
		
		if(specifications!=''&&specifications!=null){
			sql = sql+" and tr.specifications = '"+specifications+"'";
		}
		if(use_situation!=''&&use_situation!=null){
			sql = sql+" and tr.use_situation = '"+use_situation+"'";
		}
 
		if(technical_conditions!=''&&technical_conditions!=null){
			sql = sql+" and tr.technical_conditions = '"+technical_conditions+"'";
		}
		if(paizhaohao!=''&&paizhaohao!=null){
			sql = sql+" and tr.paizhaohao = '"+paizhaohao+"'";
		}
		
 
		if(equipment_one!=''&&equipment_one!=null){
			sql = sql+" and tr.e_one = '"+equipment_one+"'";
		}
		if(equipment_two!=''&&equipment_two!=null){
			sql = sql+" and tr.e_two = '"+equipment_two+"'";
		}
		
		if(release_date!=''&&release_date!=null){
			sql = sql+" and tr.release_date >= to_date('"+release_date+"','yyyy-MM-dd')";
		}
		if(release_date2!=''&&release_date2!=null){
			sql = sql+" and tr.release_date <= to_date('"+release_date2+"','yyyy-MM-dd')";
		}
		 
	 
		ctt.refreshData2(sql);
		newClose();
	}
	
	function selectOrg(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
	    if(teamInfo.fkValue!=""){
	    	document.getElementById("second_org").value = teamInfo.fkValue;
	        document.getElementById("second_org2").value = teamInfo.value;
	    }
	}
	
	function selectOrg2(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var second = document.getElementById("second_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+second+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("third_org").value = teamInfo.fkValue;
			        document.getElementById("third_org2").value = teamInfo.value;
				}
	   
	}
	
	function selectOrg3(){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    var third = document.getElementById("third_org").value;
		var org_id="";
			var checkSql="select t.org_id from comm_org_subjection t where t.bsflag='0' and t.org_subjection_id='"+third+"'";
		   	var queryRet = syncRequest('Post','<%=request.getContextPath()%>'+appConfig.queryListAction,'querySql='+checkSql);
			var datas = queryRet.datas;
			if(datas==null||datas==""){
			}else{
				org_id = datas[0].org_id; 
		    }
			    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp?orgId='+org_id,teamInfo);
			    if(teamInfo.fkValue!=""){
			    	 document.getElementById("fourth_org").value = teamInfo.fkValue;
			        document.getElementById("fourth_org2").value = teamInfo.value;
				}
	}
	
	/**
	 * 选择设备树
	**/
	function showDevTreePage(){
		//window.open("<%=contextPath%>/rm/dm/deviceAccount/selectOrg.jsp","test",'toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no,depended=no')
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTreeForSubNode.jsp","test","");
		var strs= new Array(); //定义一数组
		strs=returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var name = names[1].split("(")[0];
		var model = names[1].split("(")[1].split(")")[0];
		//alert(returnValue);
		document.getElementById("facilities_name").value = name;
		document.getElementById("specifications").value = model; 
	}
	
	 /**
	 * 使用情况下拉框变化事件，技术状况跟使用情况有关联
	 */
	function selectUse(){
		document.getElementById("technical_conditions").options.length=0;
		if(document.getElementById("use_situation").value=='0110000007000000001' || document.getElementById("use_situation").value=='0110000007000000002')
		{
			document.getElementById("technical_conditions").options.add(new Option("完好","0110000006000000001"));
		}
		else{
			document.getElementById("technical_conditions").options.add(new Option("待报废","0110000006000000005"));
			document.getElementById("technical_conditions").options.add(new Option("待修","0110000006000000006"));
			document.getElementById("technical_conditions").options.add(new Option("在修","0110000006000000007"));
			document.getElementById("technical_conditions").options.add(new Option("验收","0110000006000000013"));
		}
	}
	
	function getEquipmentOne(){
		var selectObj = document.getElementById("equipment_one"); 
		document.getElementById("equipment_one").innerHTML="";
		selectObj.add(new Option('请选择',""),0);

		var queryEquipmentOne=jcdpCallService("HseOperationSrv","queryeQuipmentOne","");	
	 
		for(var i=0;i<queryEquipmentOne.detailInfo.length;i++){
			var templateMap = queryEquipmentOne.detailInfo[i];
			selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
		}   	
		var selectObj1 = document.getElementById("equipment_two");
		document.getElementById("equipment_two").innerHTML="";
		selectObj1.add(new Option('请选择',""),0);
	}

	
	function getEquipmentTwo(){
	    var EquipmentOne = "equipmentOne="+document.getElementById("equipment_one").value;   
		var EquipmentTwo=jcdpCallService("HseOperationSrv","queryQuipmentTwo",EquipmentOne);	

		var selectObj = document.getElementById("equipment_two");
		document.getElementById("equipment_two").innerHTML="";
		selectObj.add(new Option('请选择',""),0);
		if(EquipmentTwo.detailInfo!=null){
			for(var i=0;i<EquipmentTwo.detailInfo.length;i++){
				var templateMap = EquipmentTwo.detailInfo[i];
				selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
			}
		}
	}
	 function pageInit(){ 
			//通过查询结果动态填充使用情况select;
			var querySql="select * from comm_coding_sort_detail where coding_sort_id='0110000007' and bsflag='0'";
			var queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+querySql);
			usingdatas = queryRet.datas; 
			var testOption=document.getElementById("use_situation");
			testOption.add(new Option('请选择',""),0);
			if(usingdatas != null){
				for (var i = 0; i< queryRet.datas.length; i++) {
					
					document.getElementById("use_situation").options.add(new Option(usingdatas[i].coding_name,usingdatas[i].coding_code_id)); 
				}
			}
			//技术状况默认完好
			//document.getElementById("technical_conditions").options.add(new Option("完好","0110000006000000001"));
			document.getElementById("technical_conditions").options.add(new Option("请选择",""));
		}
	 
</script>
<title>无标题文档</title>
</head>
<body class="bgColor_f3f3f3"   onload="pageInit();getEquipmentOne();">
<div id="new_table_box">
  <div id="new_table_box_content">
    <div id="new_table_box_bg">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
        <tr>
	        <td class="inquire_item6">单位：</td>
	      	<td class="inquire_form6">
	      	<input type="hidden" id="second_org" name="second_org" class="input_width" />
	      	<input type="text" id="second_org2" name="second_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
	      	</td>
	     	<td class="inquire_item6">基层单位：</td>
	      	<td class="inquire_form6">
	      	<input type="hidden" id="third_org" name="third_org" class="input_width" />
	      	<input type="text" id="third_org2" name="third_org2" class="input_width" />
	      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
	     
	      	<input type="hidden" id="fourth_org" name="fourth_org" class="input_width" />
	      	<input type="hidden" id="fourth_org2" name="fourth_org2" class="input_width" />
	     
	      	</td>
	      	 <td class="inquire_item6">设备设施名称：</td>
	 	    <td class="inquire_form6">
	 	    <input type="text" id="facilities_name" name="facilities_name" class="input_width"   />    	
	 	    <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="showDevTreePage()"  />
	 	    </td>	
		    
        </tr>
        <tr>
       
	    <td class="inquire_item6">规格型号：</td>
	    <td class="inquire_form6"><input type="text" id="specifications" name="specifications" class="input_width"    /></td>					 
	    <td class="inquire_item6">使用状况：</td> 					   
	    <td class="inquire_form6"  align="center" > 
	    <select id="use_situation" name="use_situation" class="select_width" onchange="selectUse()"> 
		</select> 	
	    </td>  
	    <td class="inquire_item6">技术状况：</td>
	    <td class="inquire_form6">  
	    <select id="technical_conditions" name="technical_conditions" class="select_width">
		</select> 		
	    </td> 
	    
        </tr>  
        
        <tr> 

	    <td class="inquire_item6">牌照号：</td>
	    <td class="inquire_form6"> 
	    <input type="text" id="paizhaohao" name="paizhaohao" class="input_width"   />    		
	    </td>
	    <td class="inquire_item6">设备设施类别一：</td> 					   
	    <td class="inquire_form6"  align="center" > 
	    <select id="equipment_one" name="equipment_one" class="select_width" onchange="getEquipmentTwo()" ></select> 	
	    </td>
        <td class="inquire_item6">设备设施类别二：</td>
	    <td class="inquire_form6"> 
	    <select id="equipment_two" name="equipment_two" class="select_width">
		</select> 			
	    </td>
	    
	    </tr>
        
        <tr>

	    
          <td class="inquire_item6">出厂日期时间：</td>
		  <td class="inquire_form6"><input type="text" id="release_date" name="release_date" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(release_date,tributton1);" />&nbsp;</td>
		  <td class="inquire_item6">至</td>
		  <td class="inquire_form6"><input type="text" id="release_date2" name="release_date2" class="input_width" readonly="readonly"/>
		  &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(release_date2,tributton2);" />&nbsp;</td>
        </tr>
        
      </table>
     
    </div>
    <div id="oper_div">
     	<span class="tj_btn"><a href="#" onclick="submit()"></a></span>
        <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
    </div>
  </div>
</div>
</body>

</html>

