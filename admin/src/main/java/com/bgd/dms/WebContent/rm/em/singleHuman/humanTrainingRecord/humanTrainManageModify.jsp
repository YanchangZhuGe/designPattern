<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" language="java" pageEncoding="utf-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@ page import="com.cnpc.jcdp.soa.msg.MsgElement"%>
<%@ page import="com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.bgp.gms.service.rm.em.pojo.*"%>
<%@taglib prefix="auth" uri="auth"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String userName = (user==null)?"":user.getEmpId();
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    String curDate = format.format(new Date());
    ISrvMsg resultMsg = OMSMVCUtil.getResponseMsg(request);
    
 
    BgpHumanPlanDetail detailInfo = 
    		(BgpHumanPlanDetail) resultMsg.getMsgElement("detailInfo").toPojo(BgpHumanPlanDetail.class);
    
    List<MsgElement>datelist = new ArrayList<MsgElement>(0);
    if(resultMsg!=null && resultMsg.getMsgElements("datelist") != null){
    	datelist = resultMsg.getMsgElements("datelist");
    }
    
  //  List<MsgElement>trainInfo = new ArrayList<MsgElement>(0);
  //  if(resultMsg!=null && resultMsg.getMsgElements("trainInfo") != null){
    //	trainInfo = resultMsg.getMsgElements("trainInfo");
   // }    
        
    List<MsgElement> list = resultMsg.getMsgElements("trainInfo");
    List<BgpHumanPlanRecord> trainInfo=new ArrayList<BgpHumanPlanRecord>(0);
    if(list!=null){
    	trainInfo = new ArrayList<BgpHumanPlanRecord>(list.size());	
    	for (int i = 0; i < list.size(); i++) {
    		trainInfo.add((BgpHumanPlanRecord) list.get(i).toPojo(
    				BgpHumanPlanRecord.class));
    	}
    }

    
	String message = "";
	String  trainDetailNo="";
	 
	if(resultMsg != null){
		message = resultMsg.getValue("message");
		trainDetailNo=resultMsg.getValue("trainDetailNo");
	 
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/js/rt/rt_add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/rt/ui_dyAdd.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/json.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/extjs/ext-all.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/calendar-zh.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/calendar-setup.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/common.js"></script>
<link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
<link href="<%=contextPath%>/styles/SpryTabbedPanels3.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/style.css" /> 
<link href="<%=contextPath%>/css/common.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/main.css" rel="stylesheet" type="text/css" /> 
<link href="<%=contextPath%>/css/rt_cru.css" rel="stylesheet" type="text/css" /> 
<link rel="stylesheet" href="<%=contextPath%>/skin/cute/style/style.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="all" href="<%=contextPath%>/css/calendar-blue.css" /> 
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/cn/jquery_ui/jquery.ui.all.css" /> 
<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/dialog_open.js"></script> 
<script type="text/javascript" src="<%=contextPath%>/js/table.js"></script> 
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

<!--Remark JavaScript定义-->
<script language="javaScript"> 
	var cruTitle = "地震队人员信息CRU";
	var jcdp_codes_items = null;
	var jcdp_codes = new Array();
	var jcdp_record = null;
	/**
	 表单字段要插入的数据库表定义
	*/
	var tables = new Array(
	['BGP_COMM_HUMAN_TRAINING_RECORD']
	);
	var defaultTableName = 'BGP_COMM_HUMAN_TRAINING_RECORD';
	/**0字段名，1显示label，2是否显示或编辑：Hide,Edit,ReadOnly，
	   3字段类型：TEXT(文本),N(整数),NN(数字),D(日期),EMAIL,ET(英文)，
	             MEMO(备注)，SEL_Codes(编码表),SEL_OPs(自定义下拉列表) ，FK(外键型)，
	   4最大输入长度，
	   5默认值：'CURRENT_DATE'当前日期，'CURRENT_DATE_TIME'当前日期时间，
	           编辑或修改时如果为空表示取0字段名对应的值，'{ENTITY.fieldName}'表示取fieldName对应的值，
	           其他默认值
	   6输入框的长度，7下拉框的值或弹出页面的链接，8 是否非空，取值为non-empty会在输入框后加*
	   9 Column Name，10 Event,11 Table Name
	*/
	      var message = "<%=message%>";
		   	var currentCount=0; //维护的增加序号
			var deviceCount=0;  //序号值不变
			//定义公共变量
			var currentCount1=parseInt('<%=datelist.size()%>');  //维护修改显示序号
			var deviceCount1=parseInt('<%=datelist.size()%>');  //不显示不更改序号
			var currentCount2=parseInt('<%=trainInfo.size()%>');  //维护修改显示序号
			var deviceCount2=parseInt('<%=trainInfo.size()%>');  //不显示不更改序号
			 
			currentCount=currentCount1+currentCount;
			deviceCount=deviceCount1+deviceCount; 

		  function page_init(){
				getObj('cruTitle').innerHTML = cruTitle;
				cruConfig.contextPath = "<%=contextPath%>";
				cruConfig.openerUrl = "/rm/em/singleHuman/humanTrainingRecord/humanTrainManageModify.jsp";
				cru_init();
			 
				var action = 'view';
					 
			
		    }
			if(message != "" && message != 'null'){
				alert(message);
			}

	
			 //动态增加添加控件
			function addLine(){
			    var  train_record_no="";
				var  humanName="";
				var  train_date="";
				var  employee_type=new Array();
				     employee_type[0]="0";
				     employee_type[1]="1";
				     employee_type[2]="2";
				     employee_type[3]="3";
				     employee_type[4]="4";
				     employee_type[5]="5";
				     employee_type[6]="6";
				     
				var  train_result=new Array();
				train_result[0]="0";
				train_result[1]="1";
				var notes="";
				var employee_id=""; //员工编号
				var employee_id_code="";  //身份证号
			
				var rowNum =deviceCount;//不变的值
				
				document.getElementById("trainNumber").value=currentCount+1+currentCount2;
				var endTime = "train_date_"+rowNum;
				var tr = document.getElementById("lineTable").insertRow();
					tr.align="center";		
					tr.id = "row_" + rowNum + "trflag";
					var className = "";
				 			

				  	if(rowNum % 2 == 1){  
				  		tr.className = "odd";
					}else{ 
						tr.className = "even";
					}
				    var tesT=currentCount+1;
						tr.insertCell().innerHTML =tesT+'<input type="hidden" class="input_width" name="train_record_no' + '_' + rowNum +'" value="'+train_record_no+'"/>';
						tr.insertCell().innerHTML ='<input type="text" style="width:110px;" class="input_width" name="humanName' + '_' + rowNum +'" value="'+humanName+'" onFocus="this.select()" readonly="readonly"/>';
						 
						tr.insertCell().innerHTML ='<select  style="width:150px;"  id="employee_type' + '_' + rowNum + '" name="employee_type' + '_' + rowNum + '" onchange="selectChange('+rowNum+')">'+
						                           '<option value="'+employee_type[0]+'" >再就业人员</option><option value="'+employee_type[1]+'">合同化员工</option>'+
						                           '<option value="'+employee_type[2]+'" >市场化用工</option><option value="'+employee_type[3]+'">劳务用工</option>'+
						                           '<option value="'+employee_type[4]+'" >临时工固定期限合同</option><option value="'+employee_type[5]+'">完成一定工作任务</option><option value="'+employee_type[6]+'">非全日制用工</option></select>';
						tr.insertCell().innerHTML ='<input type="hidden" class="input_width" name="employee_id'  + '_' + rowNum +'" id="employee_id' + '_' + rowNum +'" value="'+employee_id+'"/>'+
													'<div id="div1'+'_'+rowNum+'" style="display:none">合同化员工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson('+rowNum+',1)"/></div>'+
													'<input type="hidden" class="input_width" name="employee_id_code' + '_' + rowNum + '" value="'+employee_id_code+'"/>'+
													'<div id="div0'+'_'+rowNum+'" style="display:block">再就业人员<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="selectLabor('+rowNum+',0)" /></div>'+
													'<div id="div3'+'_'+rowNum+'" style="display:none">劳务用工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="selectLabor('+rowNum+',3)" /></div>'+
													'<div id="div4'+'_'+rowNum+'" style="display:none">临时工固定期限合同<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="selectLabor('+rowNum+',4)" /></div>'+
													'<div id="div2'+'_'+rowNum+'" style="display:none">市场化用工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson('+rowNum+',2)"/></div>'+
													'<div id="div5'+'_'+rowNum+'" style="display:none">完成一定工作任务<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectLabor('+rowNum+',5)"/></div>'+
													'<div id="div6'+'_'+rowNum+'" style="display:none">非全日制用工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectLabor('+rowNum+',6)"/></div>'; 
						
						tr.insertCell().innerHTML = '<select  style="width:130px;"  id="train_result' + '_' + rowNum + '" name="train_result' + '_' + rowNum + '"  ><option value="'+train_result[0]+'" >合格</option><option value="'+[1]+'">不合格</option></select>';						
						tr.insertCell().innerHTML ='<input type="text" style="width:250px;"  class="input_width" id="notes' + '_' + rowNum +'"  name="notes' + '_' + rowNum +'" value="'+notes+'"/>';
						tr.insertCell().innerHTML = '<input type="hidden" name="bsflag' + '_' + rowNum + '" value="0"/> <input type="hidden" name="order" value="' + rowNum + '"/>'+'<img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLines('+rowNum+')"/>';
					
				document.getElementById("equipmentSize").value=tesT;
		 		deviceCount+=1;
				currentCount+=1;
			}
			
		    
			
			//删除控件
			function deleteLines(deviceNum){
				var rowDetailId = document.getElementById("hidDetailId").value;
				var rowDeleteId = document.getElementById("train_record_no_"+deviceNum).value;
						if(	rowDeleteId!=""&&rowDeleteId!=null){
							rowDetailId = rowDetailId+rowDeleteId+",";
							document.getElementById("hidDetailId").value = rowDetailId;
						}	
				var rowDevice = document.getElementById("row_"+deviceNum+ "trflag");
				rowDevice.parentNode.removeChild(rowDevice);
				var rowFlag = document.getElementById("deleteRowFlag").value;//序号
				rowFlag=rowFlag+deviceNum+",";
				document.getElementById("deleteRowFlag").value = rowFlag;
				currentCount-=1;
				deleteChangeInfoNum('train_record_no');
				document.getElementById("trainNumber").value=currentCount+currentCount2;
			}
			
			//删除后重新排列序号
			function deleteChangeInfoNum(warehouseDetailId){
				var rowFlag = document.getElementById("deleteRowFlag").value;
				var notCheck=rowFlag.split(",");
				var num=1;
						for(var i=0;i<deviceCount;i++){
							var isCheck=true;
							for(var j=0;notCheck!=""&&j<notCheck.length;j++){
								if(notCheck[j]==i&&notCheck[j]!="") isCheck =false;
							}
							if(isCheck){
								document.getElementById(warehouseDetailId+"_"+i).parentNode.innerHTML=num+document.getElementById(warehouseDetailId+"_"+i).outerHTML;
					 			num+=1;
							}
						}		
			  }
			 function dateOption(){
				 
				 var startDate = document.getElementById("trainStartDate").value;	
				 var endDate = document.getElementById("trainEndDate").value;	
				 if(startDate !="" && endDate !=""){
					 var array1 = startDate.split("-"); 	
					 var array2 = endDate.split("-"); 
					 var dt1 = new Date(); 	
					 dt1.setFullYear(array1[0]); 
					 dt1.setMonth(array1[1] - 1); 
					 dt1.setDate(array1[2]); 	
					 var dt2 = new Date(); 	
					 dt2.setFullYear(array2[0]); 
					 dt2.setMonth(array2[1] - 1); 	
					 dt2.setDate(array2[2]); 		
					 var distance = dt2.getTime() - dt1.getTime(); //毫秒数
					 var days = (distance / (24 * 60 * 60 * 1000)+1)*8;//算出天数 	
					 document.getElementById("trainClass").value = days; 
				 }
			 }
			  //控件验证判断方法
		    function testSave(){
				  if(document.getElementById("trainStartDate").value==""){
					  alert("培训开始日期不能为空！");   return;
				  }
				  if(document.getElementById("trainEndDate").value==""){
					  alert("培训结束日期不能为空！");   return;
				  }
		    	
				var rowFlag = document.getElementById("deleteRowFlag").value;
				var notCheck=rowFlag.split(",");	
					for(var i=0;i<deviceCount;i++){
						var isCheck=true;
						for(var j=0;notCheck!=""&&j<notCheck.length;j++){
							if(notCheck[j]==i) isCheck =false;
						}
							if(isCheck){
							if(document.getElementById("employee_type_"+i).value=="1"){
								if(!notNullForCheck("employee_id_"+i,"姓名")) return false;
							}else if(document.getElementById("employee_type_"+i).value=="0"){
								if(!notNullForCheck("employee_id_code_"+i,"姓名")) return false;
							}else if(document.getElementById("employee_type_"+i).value=="3"){
								if(!notNullForCheck("employee_id_code_"+i,"姓名")) return false;
							}else if(document.getElementById("employee_type_"+i).value=="4"){
								if(!notNullForCheck("employee_id_code_"+i,"姓名")) return false;
							}else if(document.getElementById("employee_type_"+i).value=="2"){
								if(!notNullForCheck("employee_id_"+i,"姓名")) return false;
							}else if(document.getElementById("employee_type_"+i).value=="5"){
								if(!notNullForCheck("employee_id_code_"+i,"姓名")) return false;
							}else if(document.getElementById("employee_type_"+i).value=="6"){
								if(!notNullForCheck("employee_id_code_"+i,"姓名")) return false;
							}
	 
						}
					}
				dosaveTest();  //验证通过调用保存数据方法
				}
		    
			//保存数据
			function dosaveTest(){			
	 			 var train_detail_no=document.getElementById("trainDetailNo").value;//获得 主表id
	 			var train_edit_struts=document.getElementById("TRAIN_EDIT_STRUTS").value;
	 			var trainStartDate=document.getElementById("trainStartDate").value;
	 			var trainEndDate=document.getElementById("trainEndDate").value;
	 			var trainNumber=document.getElementById("trainNumber").value;
	 			var trainClass=document.getElementById("trainClass").value;
	 			
	 			
	 			var path = '<%=request.getContextPath()%>/rad/addOrUpdateEntity.srq';
				var submitStr = 'JCDP_TABLE_NAME=BGP_COMM_HUMAN_TRAINING_DETAIL&JCDP_TABLE_ID='+train_detail_no+'&TRAIN_EDIT_STRUTS=0&TRAIN_START_DATE='+trainStartDate+'&TRAIN_END_DATE='+trainEndDate+'&TRAIN_NUMBER='+trainNumber+'&TRAIN_CLASS='+trainClass;
				syncRequest('Post',path,encodeURI(encodeURI(submitStr)));  
				
				
				var rowFlag = document.getElementById("deleteRowFlag").value;   //记录删除的序号与 不变的序号进行对比判断
				var notCheck=rowFlag.split(",");
				var rowParams = new Array();
					for(var i=0;i<deviceCount;i++){    
						var isCheck=true;
						for(var j=0;notCheck!=""&&j<notCheck.length;j++){
							if(notCheck[j]==i) isCheck =false;
						}
						if(isCheck){
						 
								var rowParam = {};
						       //得到字表动态添加信息 
								var humanName = document.getElementsByName("humanName_"+i)[0].value;      //数据库不添加
							//	var train_date = document.getElementsByName("train_date_"+i)[0].value;  //数据库不添加
								var employee_type = document.getElementsByName("employee_type_"+i)[0].value;
								var train_result = document.getElementsByName("train_result_"+i)[0].value;
								var bsflag = document.getElementsByName("bsflag_"+i)[0].value;
								var notes = document.getElementsByName("notes_"+i)[0].value;
								var employee_id=document.getElementsByName("employee_id_"+i)[0].value; //员工编号
								var employee_id_code=document.getElementsByName("employee_id_code_"+i)[0].value;  //身份证号
								
								//自动添加
								rowParam['creator'] = encodeURI(encodeURI('<%=userName%>'));
								rowParam['updator'] = encodeURI(encodeURI('<%=userName%>'));
								rowParam['create_date'] = '<%=curDate%>';
								rowParam['mondif_date'] = '<%=curDate%>';
								rowParam['bsflag'] = bsflag;

								//子表
								rowParam['employee_type'] = encodeURI(encodeURI(employee_type));
							    rowParam['train_date'] = '<%=curDate%>';
								rowParam['train_result'] = train_result;
								rowParam['train_detail_no'] = encodeURI(encodeURI(train_detail_no));
								rowParam['employee_id']= encodeURI(encodeURI(employee_id));
								rowParam['employee_id_code']=encodeURI(encodeURI(employee_id_code));
								rowParam['notes'] = encodeURI(encodeURI(notes));
								rowParams[rowParams.length] = rowParam;
			              	}
		        	 }
					var rows=JSON.stringify(rowParams);
   
				 
					saveFunc("BGP_COMM_HUMAN_TRAINING_RECORD",rows);	 //字表数据信息保存
					top.frames('list').refreshData();
					newClose();
		     }
			//验证判断通用方法
			function notNullForCheck(filedName,fieldInfo){
				if(document.getElementById(filedName).value==null||document.getElementById(filedName).value==""){
					alert(fieldInfo+"不能为空");
					document.getElementById(filedName).onfocus="true";
					return false;
				}else{
					return true;
				}
			}
			 
			 
			
			 //下拉列表 onchange事件
			function selectChange(rowNum){
				var testType=document.getElementById("employee_type"+ "_"+rowNum);
				var div1=document.getElementById("div1"+"_"+rowNum);
			    var div0=document.getElementById("div0"+"_"+rowNum);
			    var div2=document.getElementById("div2"+"_"+rowNum);
			    var div3=document.getElementById("div3"+"_"+rowNum);
			    var div4=document.getElementById("div4"+"_"+rowNum);			
			    var div5=document.getElementById("div5"+"_"+rowNum);
			    var div6=document.getElementById("div6"+"_"+rowNum);
			    
				var humanName = document.getElementById("humanName_"+rowNum);      //数据库不添加 
				var employee_id=document.getElementById("employee_id_"+rowNum); //员工编号				
				var employee_id_code=document.getElementById("employee_id_code_"+rowNum);  //身份证号
				
					    for(var i=0;i<testType.length;i++){
					    	if(testType.options[i].selected==true){
						    		if(testType.options[i].value =="1"){
						    			div1.style.display="block";
						    			div0.style.display="none";
						    			div2.style.display="none";
						    			div3.style.display="none";
						    			div4.style.display="none"; 
						    			div5.style.display="none"; 
						    			div6.style.display="none"; 
						    			humanName.value=""; 
						    			employee_id_code.value="";
						    		}
	 
						    		if(testType.options[i].value =="0"){
						    			div1.style.display="none";
						    			div0.style.display="block";
						       			div2.style.display="none";
						    			div3.style.display="none";
						    			div4.style.display="none"; 
						    			div5.style.display="none"; 
						    			div6.style.display="none"; 
						    			humanName.value=""; 
						    			employee_id.value="";
						    		}
						    		if(testType.options[i].value =="2"){
						    			div1.style.display="none";
						      			div0.style.display="none";
						    			div2.style.display="block";
						    			div3.style.display="none";
						    			div4.style.display="none"; 
						    			div5.style.display="none"; 
						    			div6.style.display="none"; 
						      			humanName.value=""; 
						    			employee_id_code.value="";
						    		}
						     		if(testType.options[i].value =="3"){
						    			div1.style.display="none";
						      			div0.style.display="none";
						    			div2.style.display="none";
						    			div3.style.display="block";
						    			div4.style.display="none";
						    			div5.style.display="none"; 
						    			div6.style.display="none"; 
						    			humanName.value=""; 
						    			employee_id.value="";
						    		}
						     		if(testType.options[i].value =="4"){
						     			div1.style.display="none";
						      			div0.style.display="none";
						    			div2.style.display="none";
						    			div3.style.display="none";
						    			div4.style.display="block";
						    			div5.style.display="none"; 
						    			div6.style.display="none"; 
						    			humanName.value=""; 
						    			employee_id.value="";
						    		}
						    		
						     		if(testType.options[i].value =="5"){
						     			div1.style.display="none";
						      			div0.style.display="none";
						    			div2.style.display="none";
						    			div3.style.display="none";
						    			div4.style.display="none";
						    			div5.style.display="block"; 
						    			div6.style.display="none"; 
						    			humanName.value=""; 
						    			employee_id.value="";
						    		}
						     		if(testType.options[i].value =="6"){
						     			div1.style.display="none";
						      			div0.style.display="none";
						    			div2.style.display="none";
						    			div3.style.display="none";
						    			div4.style.display="none";
						    			div5.style.display="none"; 
						    			div6.style.display="block"; 
						    			humanName.value=""; 
						    			employee_id.value="";
						    		}
						     		
					    		
					        }
					 }
			  }
					    	
					    	
			//选择项目
			function selectTeam(){
			    var teamInfo = {
			        fkValue:"",
			        value:"" };
			    window.showModalDialog('<%=contextPath%>/common/selectProject.lpmd',teamInfo);
				    if(teamInfo.fkValue!=""){
				        document.getElementById("projectId").value = teamInfo.fkValue;
				        document.getElementById("projectName").value = teamInfo.value;
				    }
			}
			
		//正式工
		 function selectPerson(rowNum,numAll){	 
			 var laborType="";
			 if(numAll =="1"){
				 laborType="0110000019000000001";
			 }
			 if(numAll =="2"){
				 laborType="0110000019000000002";
			 }
			    var result=showModalDialog('<%=contextPath%>/rm/em/singleHuman/humanTrainingRecord/humanListLink.jsp?laborType='+laborType,'','dialogWidth:500px;dialogHeight:500px;status:yes');
			    if(result!="" && result!=undefined){
			    	var checkStr=result.split(",");
			    	for(var i=0;i<checkStr.length-1;i++){
			    		var testTemp = checkStr[i].split("-");  
			    		document.getElementById("employee_id_"+rowNum).value=testTemp[0];
			    		document.getElementById("humanName"+"_"+rowNum).value=testTemp[1];
			       	}	
			   }
	  }
		  
		 
			//临时工页面
		 function selectLabor(rowNum,numAll){
			 var laborType="";
			 if(numAll =="0"){
				 laborType="0110000059000000001";
			 }
			 if(numAll =="3"){
				 laborType="0110000059000000003";
			 }
			 if(numAll =="4"){
				 laborType="0110000059000000005";
			 }
			 if(numAll =="5"){
				 laborType="110000059000000006";
			 }
			 if(numAll =="6"){
				 laborType="0110000059000000002";
			 }
			 
			    var result = showModalDialog('<%=contextPath%>/rm/em/singleHuman/humanTrainingRecord/laborListLink.jsp?laborType='+laborType,'','dialogWidth:500px;dialogHeight:500px;status:yes'); 
				if(result!="" && result!=undefined ){
					 	var testTemp = result.split("-");  
						document.getElementById("employee_id_"+rowNum).value=testTemp[0]; 
						document.getElementById("humanName"+"_"+rowNum).value=testTemp[1];
						document.getElementById("employee_id_code"+"_"+rowNum).value=testTemp[2];
			
			    }
		 }
		function OnEnter(field) { if( field.value == field.defaultValue ) { field.value = ""; } }
		function OnExit(field) { if( field.value == "" ) { field.value = field.defaultValue; } }
		
		function uploadFile(){		
			var filename = document.getElementById("fileName").value;
			if(filename == ""){
				alert("请选择上传附件!");
				return;
			}
			if(check(filename)){
				var trainDetailNo=document.getElementsByName("trainDetailNo")[0].value;
		 
				document.getElementById("fileForm").action = "<%=contextPath%>/rm/em/importExcelTemplateHuman.srq?trainDetailNo="+trainDetailNo;
				document.getElementById("fileForm").submit();
			}
			
		}
		function check(filename){
			var type=filename.match(/^(.*)(\.)(.{1,8})$/)[3];
			type=type.toUpperCase();
			if(type=="XLS" || type=="XLSX"){
			   return true;
			}
			else{
			   alert("上传类型有误，请上传EXCLE文件！");
			   return false;
			}
		}
		 
    	  
	    function downloadModelA(){
	    	var  filename="人员培训记录导入";
	    	filename = encodeURI(filename);
	    	filename = encodeURI(filename);
	    	window.location.href="<%=contextPath%>/pm/wr/projectDynamic/download.jsp?path=/rm/em/singleHuman/humanTrainingRecord/ImpleHumanTrain.xlsx&filename="+filename+".xlsx";
	    }	
 
</script>

</head>
<body onload="" style="BACKGROUND-COLOR:#EEEEEE;overflow-y:auto;">
<form action="" id="fileForm" method="post" enctype="multipart/form-data">
<table border="0"  width="100%"  cellspacing="0" cellpadding="0" class="tab_info" id="equipmentTableInfo" style="BACKGROUND-COLOR:#CCCCCC;">
<tr  >
 <td  align="center" colspan="12"><font color=black size="4px">教学内容及费用</font></td>
 </tr>
<tr  > 
	<TD  class="bt_info_odd" width="26%" >培训内容</TD>
	<TD  class="bt_info_even" width="7%" >分类</TD>
	<TD  class="bt_info_odd"  width="5%">人数</TD>
	<TD class="bt_info_even"  width="5%">学时</TD>
	<TD  class="bt_info_odd"   width="5%"><font color=black>授课费</font></TD>
	<TD class="bt_info_even"  width="5%"><font color=black>交通费</font> </TD>
	<TD  class="bt_info_odd"  width="5%"><font color=black>材料费</font></TD>
	<TD class="bt_info_even"   width="5%"><font color=black>场地费 </font></TD>
	<TD class="bt_info_odd" width="5%"><font color=black>食宿费 </font></TD>
	<TD class="bt_info_even"  width="5%" ><font color=black>其他费用</font> </TD>
	<TD class="bt_info_odd"  width="5%" ><font color=black>费用合计（元）</font>  
	 <input type="hidden" id="TRAIN_EDIT_STRUTS" name="TRAIN_EDIT_STRUTS" value="0" />
	</TD>
	<TD class="bt_info_even"   width="8%"><font color=black>培训开始日期 </font></TD>
	<TD class="bt_info_odd" width="8%"><font color=black>培训结束日期 </font></TD>
 </tr>
	 	<tr class="even" id="trflag"  >
		<td><input type="hidden" name="trainDetailNo" id="trainDetailNo" value="<%=detailInfo.getTrainDetailNo()==null?"":detailInfo.getTrainDetailNo()%>"/> 
		 <input type="text" class="input_width" style="width:270px;color:gray;"  id="trainContent" name="trainContent" value="<%=detailInfo.getTrainContent()==null?"":detailInfo.getTrainContent()%>"   />&nbsp;
		</td>
		<td><input type="text" class="input_width"  style="width:50px;color:gray;"  id="classification" name="classification"     value="<%=detailInfo.getClassification()==null?"":detailInfo.getClassification()%>"  />&nbsp;
		</td>
		<td><input type="text" class="input_width"  style="width:40px;color:gray;"  id="trainNumber" name="trainNumber"     value="<%=trainInfo.size()%>"  />&nbsp;
		</td> 
		<td><input type="text"class="input_width" style="width:40px;color:gray;"  name="trainClass" id="trainClass"    value="<%=detailInfo.getTrainClass()==null?"":detailInfo.getTrainClass()%>"    />&nbsp;</td>
		<td><input type="text" class="input_width" style="width:40px;color:gray;"  name="trainCost"   id="trainCost"       value="<%=detailInfo.getTrainCost()==null?"":detailInfo.getTrainCost()%>" />&nbsp;</td>
		<td><input type="text" class="input_width" style="width:40px;color:gray;"  name="trainTransportation"   id="trainTransportation"      value="<%=detailInfo.getTrainTransportation()==null?"":detailInfo.getTrainTransportation()%>" />&nbsp;</td>
		<td><input type="text" class="input_width"  style="width:40px;color:gray;"  name="trainMaterials"   id="trainMaterials"     value="<%=detailInfo.getTrainMaterials()==null?"":detailInfo.getTrainMaterials()%>"    />&nbsp;</td>
		<td><input type="text" class="input_width"  style="width:40px;color:gray;"  name="trainPlaces"   id="trainPlaces"      value="<%=detailInfo.getTrainPlaces()==null?"":detailInfo.getTrainPlaces()%>" />&nbsp;</td>
		<td><input type="text" class="input_width"  style="width:40px;color:gray;"  name="trainAccommodation"   id="trainAccommodation"       value="<%=detailInfo.getTrainAccommodation()==null?"":detailInfo.getTrainAccommodation()%>" />&nbsp;</td>
		 <td><input type="text" class="input_width"  style="width:40px;color:gray;"  name="trainOther"   id="trainOther"     value="<%=detailInfo.getTrainOther()==null?"":detailInfo.getTrainOther()%>" />&nbsp;</td>
		<td><input type="text"  class="input_width" style="width:70px;color:gray;"   name="trainTotal" readonly="readonly" id="trainTotal"      value="<%=detailInfo.getTrainTotal()==null?"":detailInfo.getTrainTotal()%>" />&nbsp;</td>
		 <td>   <input type="text" id="trainStartDate" name="trainStartDate" class="input_width"   style="width:70px;"  readonly="readonly" onchange="dateOption();" />
		  <img src="<%=contextPath%>/images/calendar.gif" id="tributton1" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(trainStartDate,tributton1);" /> </td>
	 
			<td>  <input type="text" id="trainEndDate" name="trainEndDate" class="input_width"  style="width:70px;"    readonly="readonly"  onchange="dateOption();"  />
			 <img src="<%=contextPath%>/images/calendar.gif" id="tributton2" width="16" height="16" style="cursor: hand;" onmouseover="calDateSelector(trainEndDate,tributton2);" /> </td>
	 
		</tr>	
	  
</table>

<table border="0" cellpadding="0" cellspacing="0" class="form_info" width="100%" style="margin-top:0px;" >
	    <tr class="even" style="BACKGROUND-COLOR:#CCCCCC;">
	      			<td colspan="12" align="right">   
	      		  <%
	      		if(trainInfo!=null && trainInfo.size()>0){
	      			%>
	      			 <auth:ListButton functionId="" css="zj" event="onclick='addLine()'" title="JCDP_btn_add"></auth:ListButton>
	 	      		
	      		 <%
	      		}else{
	      		 %>
	      		 
	      		<font color=red>附件：</font>
      	        <input type="file"  id="fileName" name="fileName" />
      	   
      	        <a style="color:red;"  href="javascript:downloadModelA()" >下载模板</a>&nbsp;
      	 
      	        <auth:ListButton functionId="" css="dr" event="onclick='uploadFile()'" title="导入"></auth:ListButton> 
      	 	    <auth:ListButton functionId="" css="zj" event="onclick='addLine()'" title="JCDP_btn_add"></auth:ListButton>
	      		
	      		 <%
	      		}
	      		 %>
	      		
	      	 	</td>
	    </tr>
</table>
 
	 
<table border="0" cellspacing="0" cellpadding="0" class="tab_info" width="100%"  id="lineTable"  style="BACKGROUND-COLOR:#CCCCCC;">
	    <tr   >
				      <td class="bt_info_even" width="4%">序号</td>
				      <td class="bt_info_odd" width="9%"><font color="red">姓名</font>&nbsp;</td>
				    
				      <td class="bt_info_even" width="14%"><font color="red">用工类别</font>&nbsp;</td>
				      <td class="bt_info_odd" width="8%">选择</td>
				      <td class="bt_info_even" width="12%" ><font color="red">考核结果</font>&nbsp; 
				      <input type="hidden" id="equipmentSize" name="equipmentSize" value="0" />
						<input type="hidden" id="hidDetailId" name="hidDetailId" value=""/>
						<input type="hidden" id="deleteRowFlag" name="deleteRowFlag" value="" />
				      </td>
				      <td class="bt_info_odd" width="22%" ><font color="red">备注</font>&nbsp;</td>  
				      <td class="bt_info_even" width="5%">操作</td> 
	    </tr>
	    <%
		if(trainInfo!=null && trainInfo.size()>0){
			for(int j=0;j<trainInfo.size();j++){
				 
				BgpHumanPlanRecord fileMap = trainInfo.get(j);
				String className = "";
				if (j % 2 == 0) {
					className = "even";
				} else {
					className = "odd";
				}
	    %>
	      <tr  class="<%=className%>"  > 
	             <td><%=j + 1%> </td>

	     <%
	    if(fileMap.getEmployeeType().equals("1")){	
		%>
	             <td width="12%"> <%=fileMap.getLaborName()==null?"":fileMap.getLaborName()%> </td>
	              

	     <%}else if(fileMap.getEmployeeType().equals("0")){  %>
	     		<td width="12%"> <%=fileMap.getLaborName()==null?"":fileMap.getLaborName()%> </td>
	     		  
	     		 <%}else if(fileMap.getEmployeeType().equals("2")){  %>
		     		<td width="12%"> <%=fileMap.getLaborName()==null?"":fileMap.getLaborName()%> </td>
		     		 
		     		 <%}else if(fileMap.getEmployeeType().equals("3")){  %>
			     		<td width="12%"> <%=fileMap.getLaborName()==null?"":fileMap.getLaborName()%> </td>
			     		 
			     		 <%}else if(fileMap.getEmployeeType().equals("4")){  %>
				     		<td width="12%"> <%=fileMap.getLaborName()==null?"":fileMap.getLaborName()%> </td>
				     	 
				     		 <%}else if(fileMap.getEmployeeType().equals("5")){  %>
					     		<td width="12%"> <%=fileMap.getLaborName()==null?"":fileMap.getLaborName()%> </td>
					     		
					     		 <%}else if(fileMap.getEmployeeType().equals("6")){  %>
						     		<td width="12%"> <%=fileMap.getLaborName()==null?"":fileMap.getLaborName()%> </td>
	     		  
	    <%}	%>	
	    <td width="24%">
	    <%
	    if(fileMap.getEmployeeType().equals("1")){	
		%>
		合同化员工
		<%}else if(fileMap.getEmployeeType().equals("0")){  %>
		再就业人员
		<%}else if(fileMap.getEmployeeType().equals("2")){  %>
		市场化用工
		<%}else if(fileMap.getEmployeeType().equals("3")){  %>
		劳务用工
		<%}else if(fileMap.getEmployeeType().equals("4")){  %>
		临时工固定期限合同
		
		<%}else if(fileMap.getEmployeeType().equals("5")){  %>
		完成一定工作任务
		<%}else if(fileMap.getEmployeeType().equals("6")){  %>
		非全日制用工  
 		  <%}	%>	
	 
        </td>

	    <td class="tableHeader" width="5%">	 
	    <%
	    if(fileMap.getEmployeeType().equals("1")){	
		%>
		合同化员工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;"  /> 
		<%}else if(fileMap.getEmployeeType().equals("0")){  %>
		再就业人员<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;"   /> 
			<%}else if(fileMap.getEmployeeType().equals("2")){  %>
			市场化用工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;"   /> 
				<%}else if(fileMap.getEmployeeType().equals("3")){  %>
				劳务用工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;"   /> 
					<%}else if(fileMap.getEmployeeType().equals("4")){  %>
					临时工固定期限合同<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;"   />   
					<%}else if(fileMap.getEmployeeType().equals("5")){  %>
					完成一定工作任务<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;"   />   
					<%}else if(fileMap.getEmployeeType().equals("6")){  %>
					非全日制用工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;"   />  
					 
					<%}	%>	
	 	</td>
		   <td >
		      <%
		    if(fileMap.getTrainResult().equals("0")){	
			%>
			合格
			<%}else if(fileMap.getTrainResult().equals("1")){  %>
			不合格
	 		  <%}	%>	
		 		 
	        </td>
	           	<td width="30%"> <%=fileMap.getNotes()==null?"":fileMap.getNotes()%> </td>
				<td width="10%"><input type="hidden" name="order" value=""/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="alert('不可操作')"/></td>
				<input type="hidden" name="testSize" value="">
		</tr>
			
		<%		
			}
			}
		%>
	    	    	    
	    <%
		if(datelist!=null && datelist.size()>0){
			for(int j=0;j<datelist.size();j++){
				Map fileMap=datelist.get(j).toMap();
				
				String className = "";
				if (j % 2 == 0) {
					className = "even";
				} else {
					className = "odd";
				}
	    %>
	      <tr  class="<%=className%>"   id="row_<%=j%>trflag"> 
	             <td><%=j + 1%><input type="hidden" id="train_record_no_<%=j%>" name="train_record_no_<%=j%>" value="" /></td>

	     <%
	    if(fileMap.get("workType").toString().equals("1")){	
		%>
	             <td width="12%"> <input type="text"  style="width:110px;" class="input_width" name="humanName_<%=j%>"  value="<%=fileMap.get("humanName")==null?"":fileMap.get("humanName").toString()%>" onFocus="this.select()" readonly="readonly"/></td>
	    
	     <%}else if(fileMap.get("workType").toString().equals("0")){  %>
	     		<td width="12%"><input type="text" class="input_width"  style="width:110px;"  name="humanName_<%=j%>" value="<%=fileMap.get("humanName")==null?"":fileMap.get("humanName").toString()%>" readonly="readonly"/></td>
		         
		              <%}else if(fileMap.get("workType").toString().equals("2")){  %>
			     		<td width="12%"><input type="text" class="input_width"  style="width:110px;"  name="humanName_<%=j%>" value="<%=fileMap.get("humanName")==null?"":fileMap.get("humanName").toString()%>" readonly="readonly"/></td>
				         
					     <%}else if(fileMap.get("workType").toString().equals("3")){  %>
					     		<td width="12%"><input type="text" class="input_width"  style="width:110px;"  name="humanName_<%=j%>" value="<%=fileMap.get("humanName")==null?"":fileMap.get("humanName").toString()%>" readonly="readonly"/></td>
						    
							     <%}else if(fileMap.get("workType").toString().equals("4")){  %>
							     		<td width="12%"><input type="text" class="input_width"  style="width:110px;"  name="humanName_<%=j%>" value="<%=fileMap.get("humanName")==null?"":fileMap.get("humanName").toString()%>" readonly="readonly"/></td>
								       
							     		  <%}else if(fileMap.get("workType").toString().equals("5")){  %>
								     		<td width="12%"><input type="text" class="input_width"  style="width:110px;"  name="humanName_<%=j%>" value="<%=fileMap.get("humanName")==null?"":fileMap.get("humanName").toString()%>" readonly="readonly"/></td>
								     		
								     		<%}else if(fileMap.get("workType").toString().equals("6")){  %>
									     		<td width="12%"><input type="text" class="input_width"  style="width:110px;"  name="humanName_<%=j%>" value="<%=fileMap.get("humanName")==null?"":fileMap.get("humanName").toString()%>" readonly="readonly"/></td>
										   
        <%}	%>	
	    <td width="24%">
		<select id="employee_type_<%=j%>" name="employee_type_<%=j%>"  style="width:150px;" onchange="selectChange('<%=j%>')" >
		<option value="0" <%if(fileMap.get("workType").equals("0")){%> selected="selected" <%}%> >再就业人员</option>
		<option value="1" <%if(fileMap.get("workType").equals("1")){%> selected="selected" <%}%> >合同化员工</option>
		<option value="2" <%if(fileMap.get("workType").equals("2")){%> selected="selected" <%}%> >市场化用工</option>
		<option value="3" <%if(fileMap.get("workType").equals("3")){%> selected="selected" <%}%> >劳务用工</option>
		<option value="4" <%if(fileMap.get("workType").equals("4")){%> selected="selected" <%}%> >临时工固定期限合同</option>		
		<option value="5" <%if(fileMap.get("workType").equals("5")){%> selected="selected" <%}%> >完成一定工作任务</option>		
		<option value="6" <%if(fileMap.get("workType").equals("6")){%> selected="selected" <%}%> >非全日制用工</option>		
		</select>
        </td>
	    <td class="tableHeader" width="5%">
		<input type="hidden" class="input_width" name="employee_id_<%=j%>" id="employee_id_<%=j%>" value="<%=fileMap.get("workId").toString()%>"/>
		<div id="div1_<%=j%>" style="display:none">合同化员工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson('<%=j%>',1)"/></div> 
		<input type="hidden" class="input_width" name="employee_id_code_<%=j%>"  value="<%=fileMap.get("codeId")==null?"":fileMap.get("codeId").toString()%>"/>
		<div id="div0_<%=j%>"  style="display:block">再就业人员<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="selectLabor('<%=j%>',0)" /></div>
		<div id="div2_<%=j%>" style="display:none">市场化用工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor:hand;" onclick="selectPerson('<%=j%>',2)"/></div>
		<div id="div3_<%=j%>"  style="display:none">劳务用工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="selectLabor('<%=j%>',3)" /></div>
		<div id="div4_<%=j%>"  style="display:none">临时工固定期限合同<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="selectLabor('<%=j%>',4)" /></div>	
		<div id="div5_<%=j%>"  style="display:none">完成一定工作任务<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="selectLabor('<%=j%>',5)" /></div>		
		<div id="div6_<%=j%>"  style="display:none">非全日制用工<img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: hand;" onclick="selectLabor('<%=j%>',6)" /></div>
		
		</td>
		
		   <td >
			<select id="train_result_<%=j%>" style="width:130px;" name="train_result_<%=j%>"   >
			<option value="0" <%if(fileMap.get("kaohe").equals("0")){%> selected="selected" <%}%> >合格</option>
			<option value="1" <%if(fileMap.get("kaohe").equals("1")){%> selected="selected" <%}%> >不合格</option>
			</select>
	        </td>
	           
				<td width="30%"><input type="text" style="width:250px;" class="input_width" name="notes_<%=j%>" id="notes_<%=j%>" value="<%=fileMap.get("notes")==null?"":fileMap.get("notes").toString()%>" onFocus="this.select()"/></td>
				<td width="10%"><input type="hidden" name="order" value=""/><img src="<%=contextPath%>/images/delete.png" width="16" height="16" style="cursor:hand;" onclick="deleteLines('<%=j%>')"/></td>
				<input type="hidden" name="testSize" value="">
				<input type="hidden" name="bsflag_<%=j%>" value="0"/>
	      </tr>
			
		<%		
			}
			}
		%>
</table>
  
 
<table width="100%" border="0" cellspacing="0" cellpadding="0"   >
<tr>
 
  <td background="<%=contextPath%>/images/list_15.png" >
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr align="center">
 
  <td  >
  <span  class="bc_btn"><a href="#" onclick="testSave(); "></a></span>
  <span class="gb_btn"><a href="#" onclick="newClose();"></a></span>
  </td>
</tr>
</table>
</td>
 
</tr>
</table>
</form>
</body>
<script language="javaScript"> 
if(currentCount1 !=0){document.getElementById("trainNumber").value=currentCount1;}

</script>
</html>

