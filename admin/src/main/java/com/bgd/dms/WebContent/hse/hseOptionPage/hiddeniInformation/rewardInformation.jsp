<%@page contentType="text/html;charset=utf-8" pageEncoding="UTF-8"%>
<%@taglib prefix="auth" uri="auth"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@ page import="java.util.Map"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cnpc.jcdp.webapp.util.JcdpMVCUtil" %>
<%
	String contextPath = request.getContextPath();	
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getUserName();
	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	String curDate = format.format(new Date());	
	String orgSubId =(user==null)?"":user.getOrgSubjectionId();	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.core.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.widget.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.mouse.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/calendar_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_cru.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_cru_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/proc_base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/fujian.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_validate.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/cn/rt_validate_lan.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_edit.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
 
<title>奖励信息</title>
</head>

<body style="background:#fff"  onload="refreshData();">
      	<div id="list_table">
			<div id="inq_tool_box"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td width="6"><img src="<%=contextPath%>/images/list_13.png" width="6" height="36" /></td>
			    <td background="<%=contextPath%>/images/list_15.png"><table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			    <td class="ali_cdn_name">奖励状态</td>
			    <td class="inquire_form6">	 
			    <select id="changeName" name="changeName" class="select_width">
			       <option value="" >请选择</option>
			       <option value="已奖励" >已奖励</option>
			       <option value="未奖励" >未奖励</option> 
				</select> 	
			    </td>
 				<td class="ali_query">
				    <span class="cx"><a href="#" onclick="simpleSearch()" title="JCDP_btn_query"></a></span>
			    </td>
			    <td class="ali_query">
				    <span class="qc"><a href="#" onclick="clearQueryText()" title="JCDP_btn_clear"></a></span>
				</td>

			    <td>&nbsp;</td>
			     <auth:ListButton functionId="" css="gl" event="onclick='toSearch()'" title="JCDP_btn_filter"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="zj" event="onclick='toAdd()'" title="JCDP_btn_add"></auth:ListButton>
			    <auth:ListButton functionId="F_HSE_AUTH_001,F_HSE_AUTH_002" css="sc" event="onclick='toDelete()'" title="JCDP_btn_delete"></auth:ListButton>
			  </tr>
			</table>
			</td>
			    <td width="4"><img src="<%=contextPath%>/images/list_17.png" width="4" height="36" /></td>
			  </tr>
			</table>
			</div>
			<div id="table_box">
			  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_info" id="queryRetTable">
			    <tr>    
			      <td class="bt_info_even" exp="<input type='checkbox' name='chx_entity_id' id='chx_entity_id_{reward_no}' value='{reward_no}' onclick='chooseOne(this);loadDataDetail();'/>" >选择</td>
			      <td class="bt_info_odd" autoOrder="1">序号</td> 
			      <td class="bt_info_even" exp="{org_name}">单位</td> 
			      <td class="bt_info_odd" exp="{second_org_name}">基层单位</td>
			      <td class="bt_info_even" exp="{third_org_name}">下属单位</td>
			      <td class="bt_info_odd" exp="{reward_numbers}">奖励编号</td>
			      <td class="bt_info_even" exp="{reward_level}">奖励级别</td>
			      <td class="bt_info_odd" exp="{reward_amount}">奖励金额（元）</td>
			      <td class="bt_info_even" exp="{cash_date}">兑现日期</td>
			      <td class="bt_info_odd" exp="{reward_state}">奖励状态</td>

			    </tr>
			  </table>
			</div>
			<div id="fenye_box"><table width="100%" border="0" cellspacing="0" cellpadding="0" id="fenye_box_table">
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
			    <li class="selectTag" id="tag3_0"><a href="#" onclick="getTab3(0)">奖励隐患列表</a></li>
			    <li id="tag3_1"><a href="#" onclick="getTab3(1)">奖励信息</a></li>	
			   </ul>
			</div>
			
			<div id="tab_box" class="tab_box">
			<form name="form" id="form"  method="post" action="">
 
				<div id="tab_box_content0" class="tab_box_content">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
	                <tr align="right" height="30">
	                  <td>&nbsp;</td>
	                  <td width="60" id="buttonDis1" >
	                <span class='zj'><a href='#' onclick='openAdd()'  title='新增'></a></span>		 		                
	                <span class="bc"  onclick="toUpdate1()"><a href="#"></a></span> 
	                  </td>
	                  <td width="5"></td>
	                </tr>
	              </table>
	              <table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info"   id="hseTableInfo">
	          	<tr > 	 
	          	    <TD  class="bt_info_even"  width="21%"><font color=red>隐患名称</font></TD>
	          		<TD  class="bt_info_odd" width="21%" ><font color=red>上报日期</font></TD>
	          	   <TD  class="bt_info_even"  width="21%"><font color=red>整改状态</font></TD>
	        		<TD  class="bt_info_odd" width="21%" ><font color=red>风险级别</font></TD>
	          		<input type="hidden" id="equipmentSize" name="equipmentSize"   value="0" />
	          		<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
	          		<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />	
	          		<input type="hidden" id="lineNum" value="0"/>
	          		<TD class="bt_info_even" width="5%">操作</TD>
	          	</tr>
	          		 
	          </table>	 
	             	  
				</div>
			 
				
		  <div id="tab_box_content1" class="tab_box_content" style="display:none;">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr align="right" height="30">
                  <td>&nbsp;</td>
                  <td width="30"><span class="bc"><a href="#" onclick="toUpdate()"></a></span></td>
                  <td width="5"></td>
                </tr>
         	   </table>
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height" >					
				  <tr>						   
					  <td class="inquire_item6">单位：</td>
			        	<td class="inquire_form6">
			        	<input type="hidden" id="org_sub_id" name="org_sub_id" class="input_width" />					     
				      	<input type="text" id="org_sub_id2" name="org_sub_id2" class="input_width"   <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %> readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_003", request)){ %>
			        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg()"/>
			        	<%} %>
			        	</td>
			          	<td class="inquire_item6">二级单位：</td>
			        	<td class="inquire_form6">
			        	 <input type="hidden" id="second_org" name="second_org" class="input_width" />
				    	  <input type="text" id="second_org2" name="second_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)||!JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
			        	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)&&JcdpMVCUtil.hasPermission("F_HSE_ORG_002", request)){ %>
			        	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg2()"/>
			        	<%} %>
			        	</td>    	  
				  </tr>					  
					<tr>								 
					  <td class="inquire_item6"><font color="red">*</font>基层单位：</td>
				      	<td class="inquire_form6">
			 	      	<input type="hidden" id="bsflag" name="bsflag" value="0" />
				      	<input type="hidden" id="create_date" name="create_date" value="" />
				      	<input type="hidden" id="creator" name="creator" value="" />
				      	<input type="hidden" id="reward_no" name="reward_no"   />
				     	<input type="hidden" id="third_org" name="third_org" class="input_width" />
				      	<input type="text" id="third_org2" name="third_org2" class="input_width"  <%if(!JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>readonly="readonly"<%} %> onkeydown="return noEdit(event)"/>
				      	<%if(JcdpMVCUtil.hasPermission("F_HSE_ORG_001", request)){ %>
				      	<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectOrg3()"/>
				      	<%}%>
				      	</td> 
				      	 <td class="inquire_item6"><font color="red">*</font>奖励编号：</td>
						    <td class="inquire_form6">
						    <input type="text" id="reward_numbers" name="reward_numbers" class="input_width"  style="color:gray;" value="自动生成"   readonly="readonly" />    					    
						 </td>						    
					</tr>						
				  <tr>  
				  <td class="inquire_item6"><font color="red">*</font>奖励级别：</td>
				    <td class="inquire_form6">
				    <select id="reward_level" name="reward_level" class="select_width">
				       <option value="" >请选择</option>
				       <option value="1" >公司</option>
				       <option value="2" >二级单位</option> 
				       <option value="3" >基层单位</option>  
				       <option value="4" >基层单位下属单位</option>  
					</select> 
				    </td>	 	 
				    <td class="inquire_item6"><font color="red">*</font>奖励金额(元)：</td> 					   
				    <td class="inquire_form6"  align="center" > 
				    <input type="text" id="reward_amount" name="reward_amount" class="input_width"    />
				    </td>   

				    </tr>	
					  <tr>	
					    <td class="inquire_item6"><font color="red">*</font>兑现日期：</td>
					    <td class="inquire_form6">
					    <input type="text" id="cash_date" name="cash_date" class="input_width"    readonly="readonly"/>
					    &nbsp;<img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(cash_date,tributton1);" />&nbsp;</td>	 
					    <td class="inquire_item6"><font color="red">*</font>奖励状态：</td> 					   
					    <td class="inquire_form6"  align="center" > 
					    <input type="text" id="reward_state" name="reward_state" class="input_width" value=""   readonly="readonly" />
					    </td>
					  </tr>	 
			   </table>
			  
				  </div> 
				</form>
			</div>
		  </div>

</body>
<script type="text/javascript">
function frameSize(){
	//$("#tab_box").children("div").css("height",$(window).height()-$("#inq_tool_box").height()-$("#table_box").height()-$("#fenye_box").height()-$("#line").height()-$("#tag-container_3").height());
	setTabBoxHeight();
}
frameSize();


$(function(){
	$(window).resize(function(){
  		frameSize();
	});
})	

$(document).ready(lashen);
</script>

<script type="text/javascript">

 
	cruConfig.contextPath =  "<%=contextPath%>";
	cruConfig.cdtType = 'form';
	
	// 复杂查询
	function refreshData(){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = "   select  tr.org_sub_id,tr.reward_no,tr.reward_numbers,decode(tr.reward_level,'1','公司','2','二级单位','3','基层单位','4','基层单位下属单位') reward_level,tr.reward_amount,tr.cash_date,tr.reward_state ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_REWARD_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0' order by tr.modifi_date desc";
		cruConfig.currentPageUrl = "/hse/hseOptionPage/hiddeniInformation/rewardInformation.jsp";
		queryData(1);
	}
	
	function refreshData2(sql){
		cruConfig.cdtType = 'form';
		cruConfig.queryStr = sql;
		cruConfig.currentPageUrl = "/hse/accidentNews/accident_list.jsp";
		queryData(1);
	}
	
	function chooseOne(cb){   
	    var obj = document.getElementsByName("chx_entity_id");   
	    for (i=0; i<obj.length; i++){   
	       	if (obj[i]!=cb) obj[i].checked = false;   
	        else obj[i].checked = true;   
	    }   
	}   
	
	// 简单查询
	function simpleSearch(){
			var changeName = document.getElementById("changeName").value;
				if(changeName!=''&& changeName!=null){
					cruConfig.cdtType = 'form';
					cruConfig.queryStr = "    select  tr.org_sub_id,tr.reward_no,tr.reward_numbers,decode(tr.reward_level,'1','公司','2','二级单位','3','基层单位','4','基层单位下属单位') reward_level,tr.reward_amount,tr.cash_date,tr.reward_state ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_REWARD_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0'  and tr.reward_state='"+ changeName +"'  order by tr.modifi_date desc";
					cruConfig.currentPageUrl = "/hse/hseOptionPage/hiddeniInformation/rewardInformation.jsp";
					queryData(1);
				}else{
					alert('请输入查询内容！');
					refreshData();
				}
	}
	
	function clearQueryText(){
		document.getElementById("changeName").value = "";
	}
 
	function loadDataDetail(shuaId){ 
		if(shuaId !=null){
			var querySql = "";
			var queryRet = null;
			var  datas =null;	
			querySql = "    select  tr.org_sub_id,tr.reward_no,tr.reward_numbers,tr.reward_level,tr.reward_amount,tr.cash_date,tr.reward_state ,tr.second_org,tr.third_org,ion.org_name,tr.creator,tr.create_date,tr.bsflag,  oi1.org_abbreviation as second_org_name,     oi2.org_abbreviation as third_org_name  from BGP_REWARD_INFORMATION tr     join comm_org_subjection os1     on tr.second_org = os1.org_subjection_id    and os1.bsflag = '0'   join comm_org_information oi1     on oi1.org_id = os1.org_id    and oi1.bsflag = '0'   join comm_org_subjection os2     on tr.third_org = os2.org_subjection_id    and os2.bsflag = '0'   join comm_org_information oi2     on oi2.org_id = os2.org_id    and oi2.bsflag = '0'   join comm_org_information ion     on ion.org_id = os1.org_id     where tr.bsflag = '0'  and tr.reward_no='"+ shuaId +"'";	 				 	 
			queryRet = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
			if(queryRet.returnCode=='0'){
				datas = queryRet.datas;
				if(datas != null){				 
					 document.getElementsByName("reward_no")[0].value=datas[0].reward_no; 
		    		 document.getElementsByName("org_sub_id")[0].value=datas[0].org_sub_id;
		    		 document.getElementsByName("org_sub_id2")[0].value=datas[0].org_name; 
		    		 document.getElementsByName("bsflag")[0].value=datas[0].bsflag;
		    		 document.getElementsByName("second_org")[0].value=datas[0].second_org;			
		    		 document.getElementsByName("second_org2")[0].value=datas[0].second_org_name;		
		    	     document.getElementsByName("third_org")[0].value=datas[0].third_org;		
		    	     document.getElementsByName("third_org2")[0].value=datas[0].third_org_name;	
		  		     document.getElementsByName("create_date")[0].value=datas[0].create_date;
		    		 document.getElementsByName("creator")[0].value=datas[0].creator;	 
 
		    		 document.getElementsByName("reward_numbers")[0].value=datas[0].reward_numbers;
		    		 document.getElementsByName("reward_level")[0].value=datas[0].reward_level;	 
	    		     document.getElementsByName("reward_amount")[0].value=datas[0].reward_amount;	    		    
	    			 document.getElementsByName("cash_date")[0].value=datas[0].cash_date;	

		    		    if(datas[0].reward_state ==""){
		    		    	document.getElementsByName("reward_state")[0].value="未奖励";
		    		    }else{
			    		    document.getElementsByName("reward_state")[0].value=datas[0].reward_state;
		    		    	
		    		    }
  
		         	}					
			
		    	}		
				
				 var querySql1="";
				 var queryRet1=null;
				 var datas1 =null;
				 deleteTableTr("hseTableInfo");
		    	 document.getElementById("lineNum").value="0";	
		     
				   querySql1 = "select  cdl.rdetail_no,cdl.reward_no,cdl.hidden_no,cdl.rhidden_name,cdl.rreport_date,cdl.rrisk_levels ,cdl.reward_state, cdl.creator,cdl.create_date,cdl.updator,cdl.modifi_date,cdl.bsflag  from BGP_REWARD_DETAIL cdl  where cdl.bsflag='0' and cdl.reward_no='" + shuaId + "'  order by  cdl.modifi_date";
				   queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
					if(queryRet1.returnCode=='0'){
					  datas1 = queryRet1.datas;	 
						if(datas1 != null && datas1 != ''){							 
						  						 
							for(var i = 0; i<datas1.length; i++){	 
					     addLine1(datas1[i].rdetail_no,datas1[i].reward_no,datas1[i].hidden_no,datas1[i].rhidden_name,datas1[i].rreport_date,datas1[i].rrisk_levels,datas1[i].reward_state,datas1[i].creator,datas1[i].create_date,datas1[i].updator,datas1[i].modifi_date,datas1[i].bsflag);
					       				      
							}
							
						}
				    }	
			
		 
		}
 
	}
	 
	var selectedTagIndex = 0;//document.getElementById("tag3_0").parentElement;
	var showTabBox = document.getElementById("tab_box_content0");
	
	
	function deleteTableTr(tableID){
		var tb = document.getElementById(tableID);
	     var rowNum=tb.rows.length;
 
	     for (i=1;i<rowNum;i++)
	     {
	         tb.deleteRow(i);
	         rowNum=rowNum-1;
	         i=i-1;
	     }
	}
	
	
	function toAdd(){
		popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/addReward.jsp");
		
	}
 
	function selectTeam1(){
		
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog('<%=contextPath%>/rm/em/humanLabor/selectProject.lpmd',teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById("project_id").value = teamInfo.fkValue;
	        document.getElementById("project_name").value = teamInfo.value;
	    }
	}

	function toEdit(){  
	 	  	
	  	ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     return;
	    } 
	  
	  	popWindow("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/addReward.jsp?reward_no="+ids);
	  	
	} 
	
	 
	function toDelete(){ 		
	    ids = getSelIds('chx_entity_id');
	    if(ids==''){ alert("请先选中一条记录!");
	     	return;
	    }	
	     var querySql1="";
         var queryRet1=null;
         var datas1 =null; 
         querySql1 = "select dil.hidden_no  from BGP_REWARD_DETAIL dil left join  BGP_REWARD_INFORMATION  ion on ion.REWARD_NO=dil.REWARD_NO and dil.bsflag='0' where ion.bsflag='0'  and  ion.reward_no='"+ ids +"'";;
         queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
        
	       	if(queryRet1.returnCode=='0'){
	       	  datas1 = queryRet1.datas;	 
	       		if(datas1 != null && datas1 != ''){	 	     
	       			var reward_state="";
	       			for(var i = 0; i<datas1.length; i++){ 
	       				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
	       				var submitStr = 'JCDP_TABLE_NAME=BGP_HIDDEN_INFORMATION&JCDP_TABLE_ID='+datas1[i].hidden_no +'&reward_state='+reward_state
	       				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
	       			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
	        
	       			}
	
	       		}
	       		
	       	}
		deleteEntities("update BGP_REWARD_INFORMATION  e set e.bsflag='1' where e.reward_no='"+ids+"'");
	 
	}

	function toSearch(){
		popWindow("<%=contextPath%>/hse/accidentNews/accident_search.jsp");
	}
	 function chooseOne(cb){   
	        var obj = document.getElementsByName("chx_entity_id");   
	        for (i=0; i<obj.length; i++){   
	            if (obj[i]!=cb) obj[i].checked = false;   
	            else obj[i].checked = true;   
	        }   
	    }   
	
	 
	 
	//键盘上只有删除键，和左右键好用
	 function noEdit(event){
	 	if(event.keyCode==8|| event.keyCode ==37 || event.keyCode ==39){
	 		return true;
	 	}else{
	 		return false;
	 	}
	 }
	 
	 
	 function selectOrg(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    window.showModalDialog('<%=contextPath%>/common/selectOrgSub.jsp',teamInfo);
		    if(teamInfo.fkValue!=""){
		    	document.getElementById("org_sub_id").value = teamInfo.fkValue;
		        document.getElementById("org_sub_id2").value = teamInfo.value;
		    }
		}

		function selectOrg2(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var second = document.getElementById("org_sub_id").value;
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
				    	 document.getElementById("second_org").value = teamInfo.fkValue; 
				        document.getElementById("second_org2").value = teamInfo.value;
					}
		   
		}

		function selectOrg3(){
		    var teamInfo = {
		        fkValue:"",
		        value:""
		    };
		    var third = document.getElementById("second_org").value;
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
				    	 document.getElementById("third_org").value = teamInfo.fkValue;
				        document.getElementById("third_org2").value = teamInfo.value;
					}
		}

		
	function toUpdate(){		
		var rowParams = new Array(); 
		var rowParam = {};				
		var reward_no = document.getElementsByName("reward_no")[0].value;						 
		  if(reward_no !=null && reward_no !=''){		
				var reward_no = document.getElementsByName("reward_no")[0].value;
				var create_date = document.getElementsByName("create_date")[0].value;
				var creator = document.getElementsByName("creator")[0].value;		
				var org_sub_id = document.getElementsByName("org_sub_id")[0].value;
				var bsflag = document.getElementsByName("bsflag")[0].value;
				var second_org = document.getElementsByName("second_org")[0].value;			
				var third_org = document.getElementsByName("third_org")[0].value;		
			
				var reward_numbers= document.getElementsByName("reward_numbers")[0].value;
				var reward_level= document.getElementsByName("reward_level")[0].value;
				var reward_amount= document.getElementsByName("reward_amount")[0].value;		    
				var cash_date= document.getElementsByName("cash_date")[0].value;	
				var reward_state= document.getElementsByName("reward_state")[0].value;
 
				 if(cash_date !=""){
					 reward_state="已奖励";
				 }else{ 
					 reward_state="未奖励";
				 }
				  
			     
	             var querySql1="";
	             var queryRet1=null;
	             var datas1 =null; 
	              querySql1 = "select dil.hidden_no  from BGP_REWARD_DETAIL dil left join  BGP_REWARD_INFORMATION  ion on ion.REWARD_NO=dil.REWARD_NO and dil.bsflag='0' where ion.bsflag='0'  and  ion.reward_no='"+ reward_no +"'";;
	              queryRet1 = syncRequest('Post','<%=contextPath%>'+appConfig.queryListAction,'pageSize=100&querySql='+encodeURI(encodeURI(querySql1)));
	             
	            	if(queryRet1.returnCode=='0'){
	            	  datas1 = queryRet1.datas;	 
	            		if(datas1 != null && datas1 != ''){	 	            			 
	            			for(var i = 0; i<datas1.length; i++){ 
	            				var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
	            				var submitStr = 'JCDP_TABLE_NAME=BGP_HIDDEN_INFORMATION&JCDP_TABLE_ID='+datas1[i].hidden_no +'&reward_state='+reward_state
	            				+'&updator=<%=userName%>&modifi_date=<%=curDate%>';
	            			   syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  //保存主表信息		
	             
	            			}
 
	            		}
	            		
	            	}
	            	
				rowParam['org_sub_id'] = org_sub_id;
				rowParam['second_org'] = second_org;
				rowParam['third_org'] = third_org;							
				rowParam['reward_numbers'] = encodeURI(encodeURI(reward_numbers));
				rowParam['reward_level'] = encodeURI(encodeURI(reward_level));
				rowParam['reward_amount'] =reward_amount;
				rowParam['cash_date'] = encodeURI(encodeURI(cash_date));
				rowParam['reward_state'] = encodeURI(encodeURI(reward_state));
 
				
			    rowParam['reward_no'] = reward_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;
	 		  
				rowParams[rowParams.length] = rowParam; 
				var rows=JSON.stringify(rowParams);	 
				saveFunc("BGP_REWARD_INFORMATION",rows);	
			    refreshData();	
				alert(保存成功！);
				  
		  }else{			  
			  alert("请先选中一条记录!");
		     	return;		
		  }
		  			
	}

	function toUpdate1(){	
		var rowNum = document.getElementById("lineNum").value;			
		var rowParams = new Array();
		var reward_nos = document.getElementsByName("reward_no")[0].value;	
					
		 if(reward_nos !=null && reward_nos !=''){
		for(var i=0;i<rowNum;i++){
			var rowParam = {};		 
			var rdetail_no =document.getElementsByName("rdetail_no_"+i)[0].value; 
			var reward_no =document.getElementsByName("reward_no_"+i)[0].value;
			var hidden_no = document.getElementsByName("hidden_no_"+i)[0].value;
			var rhidden_name = document.getElementsByName("rhidden_name_"+i)[0].value;
			var rreport_date =document.getElementsByName("rreport_date_"+i)[0].value;
			var rrisk_levels =document.getElementsByName("rrisk_levels_"+i)[0].value;			
			var reward_state =document.getElementsByName("reward_state_"+i)[0].value;
			
			var creator = document.getElementsByName("creator_"+i)[0].value;
			var create_date = document.getElementsByName("create_date_"+i)[0].value;
			var updator = document.getElementsByName("updator_"+i)[0].value;
			var modifi_date =document.getElementsByName("modifi_date_"+i)[0].value;
			var bsflag =document.getElementsByName("bsflag_"+i)[0].value;
			if(rdetail_no !=null && rdetail_no !=''){			
 				rowParam['rhidden_name'] = encodeURI(encodeURI(rhidden_name));
				rowParam['rreport_date'] = encodeURI(encodeURI(rreport_date));
				rowParam['rrisk_levels'] = encodeURI(encodeURI(rrisk_levels));			
				rowParam['reward_state'] = encodeURI(encodeURI(reward_state));		
				rowParam['hidden_no'] = encodeURI(encodeURI(hidden_no));
		 
			    rowParam['rdetail_no'] = rdetail_no;
			    rowParam['reward_no'] = reward_no;
				rowParam['creator'] = encodeURI(encodeURI(creator));
				rowParam['create_date'] =create_date;
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;	
				
			}else{
 				rowParam['rhidden_name'] = encodeURI(encodeURI(rhidden_name));
				rowParam['rreport_date'] = encodeURI(encodeURI(rreport_date));
				rowParam['rrisk_levels'] = encodeURI(encodeURI(rrisk_levels));			
				rowParam['reward_state'] = encodeURI(encodeURI(reward_state));		
				rowParam['hidden_no'] = encodeURI(encodeURI(hidden_no));
			 		
			    rowParam['reward_no'] = reward_nos;
				rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['create_date'] ='<%=curDate%>';	
				rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
				rowParam['modifi_date'] = '<%=curDate%>';		
				rowParam['bsflag'] = bsflag;		 
			}
				rowParams[rowParams.length] = rowParam; 
 
		}
			var rows=JSON.stringify(rowParams);			 
			saveFunc("BGP_REWARD_DETAIL",rows);	
			frames[3].refreshData();
			alert('保存成功！');	
			
      }else{			  
			  alert("请先选中一条记录!");
		     	return;		
      }				
		
}
	
	function openAdd(){
		 window.open("<%=contextPath%>/hse/hseOptionPage/hiddeniInformation/RhomeFrame.jsp?optionP=1",'homeMain','height=500,width=1000px,left=100px,top=100px,menubar=no,status=no,toolbar=no ', '');
		
	}
	
 	function addLine1(rdetail_nos,reward_nos,hidden_nos,rhidden_names,rreport_dates,rrisk_levelss,reward_states,creators,create_dates,updators,modifi_dates,bsflags){

		var rdetail_no = "";
		var reward_no = "";
		var hidden_no = "";
		var rhidden_name = "";
		var rreport_date = "";
		var rrisk_levels = "";
		var reward_state = "";
		
		var creator = "";
		var create_date = "";
		var updator = "";
		var modifi_date = "";
		var bsflag = "";
		
		
		if(rdetail_nos != null && rdetail_nos != ""){
			rdetail_no=rdetail_nos;
		}
		if(reward_nos != null && reward_nos != ""){
			reward_no=reward_nos;
		}
		if(hidden_nos != null && hidden_nos != ""){
			hidden_no=hidden_nos;
		}
		
		if(rhidden_names != null && rhidden_names != ""){
			rhidden_name=rhidden_names;
		}
		if(rreport_dates != null && rreport_dates != ""){
			rreport_date=rreport_dates;
		}
		
		if(rrisk_levelss != null && rrisk_levelss != ""){
			rrisk_levels=rrisk_levelss;
		}
		if(reward_states != null && reward_states != ""){
			reward_state=reward_states;
		}
		
		if(creators != null && creators != ""){
			creator=creators;
		}
		
		if(create_dates != null && create_dates != ""){
			create_date=create_dates;
		}
		if(updators != null && updators != ""){
			updator=updators;
		}
		if(modifi_dates != null && modifi_dates != ""){
			modifi_date=modifi_dates;
		}
		if(bsflags != null && bsflags != ""){
			bsflag=bsflags;
		}
 
		var rowNum = document.getElementById("lineNum").value;	
		var tr = document.getElementById("hseTableInfo").insertRow();
		
		tr.align="center";		
 
	  	if(rowNum % 2 == 1){  
	  		tr.className = "odd";
		}else{ 
			tr.className = "even";
		}	
		tr.id = "row_" + rowNum + "_";   
	
		tr.insertCell().innerHTML = '<input type="hidden"  name="rdetail_no' + '_' + rowNum + '" value="'+rdetail_no+'"/>'+'<input type="text" style="width:260px;" class="input_width" name="rhidden_name' + '_' + rowNum + '" value="'+rhidden_name+'" readonly="readonly"  />'+'<input type="hidden"  name="reward_no' + '_' + rowNum + '" value="'+reward_no+'"/>'+'<input type="hidden"  name="bsflag' + '_' + rowNum + '" value="0"/>'+'<input type="hidden"  name="creator' + '_' + rowNum + '" value="'+creator+'"/>'+'<input type="hidden"  name="create_date' + '_' + rowNum + '" value="'+create_date+'"/>'+'<input type="hidden"  name="updator' + '_' + rowNum + '" value="'+updator+'"/>'+'<input type="hidden"  name="modifi_date' + '_' + rowNum + '" value="'+modifi_date+'"/>';
		tr.insertCell().innerHTML = '<input type="hidden"  name="hidden_no' + '_' + rowNum + '" value="'+hidden_no+'"/>'+'<input type="text" style="width:200px;" class="input_width" name="rreport_date' + '_' + rowNum + '" value="'+rreport_date+'"  readonly="readonly" />';
		tr.insertCell().innerHTML = '<input type="text" style="width:230px;" class="input_width" name="rrisk_levels' + '_' + rowNum + '" value="'+rrisk_levels+'"  readonly="readonly" />';
		tr.insertCell().innerHTML = '<input type="text" style="width:230px;" class="input_width" name="reward_state' + '_' + rowNum + '" value="'+reward_state+'"  readonly="readonly" />';
 
		var td = tr.insertCell(); 
		td.style.display = "";
		td.innerHTML = '<input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="'+'<%=contextPath%>'+'/images//delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLine(\'' + tr.id + '\')"/>';
		
		document.getElementById("lineNum").value = parseInt(rowNum) + 1;			 
		
	}
 	
 	
	 function deleteLine(lineId){		
			var rowNum = lineId.split('_')[1];
			var line = document.getElementById(lineId);		

			var bsflag = document.getElementsByName("bsflag_"+rowNum)[0].value;
			if(bsflag!=""){
				line.style.display = 'none';
				document.getElementsByName("bsflag_"+rowNum)[0].value = '1';
			}else{
				line.parentNode.removeChild(line);
			}	
		}

</script>

</html>

