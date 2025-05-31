var selectedTagIndex =0;
function getTab3(index) {  
	var selectedTag = document.getElementById("tag3_"+selectedTagIndex);
	var selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex)
	selectedTag.className ="";
	selectedTabBox.style.display="none";

	selectedTagIndex = index;
	
	selectedTag = document.getElementById("tag3_"+selectedTagIndex);
	selectedTabBox = document.getElementById("tab_box_content"+selectedTagIndex);
	selectedTag.className ="selectTag";
	selectedTabBox.style.display="block";
}
function loadDataDetail(){
	var rules_id = document.getElementById("rules_id").value;
	retObj = jcdpCallService("HseOperationSrv", "getTablesList", "rules_id="+rules_id);
	if(retObj.returnCode =='0'){
		if(retObj.analysisList!=null){
			var list = retObj.analysisList;
			loadAnalysis(list);
		}
		if(retObj.evaluate1List!=null){
			var list = retObj.evaluate1List;
			loadEvaluate1(list);
		}
		if(retObj.evaluate2List!=null){
			var list = retObj.evaluate2List;
			loadEvaluate2(list);
		}
		if(retObj.historyList!=null){
			var list = retObj.historyList;
			loadHistory(list);
		}
	}
}
function refreshData(){
	var rules_id = document.getElementById("rules_id").value;
	var retObj = jcdpCallService("HseOperationSrv", "getOperationRules", "rules_id="+rules_id);
	if(retObj.returnCode =='0'){
		if(retObj.data!=null){
			var map = retObj.data;
			document.getElementById("rules_id").value =rules_id;
			document.getElementById("second_org").value =map.second_org;
			document.getElementById("third_org").value =map.second_org;
			document.getElementById("second_org2").value =map.second_name;
			document.getElementById("third_org2").value =map.third_name;
			document.getElementById("rules_analy_date").value = map.rules_analy_date;
			document.getElementById("rules_check_date").value = map.rules_check_date;
			document.getElementById("analysis_code").value =map.analysis_code;
			document.getElementById("analysis_date").value =map.analysis_date;
			document.getElementById("analysis_depart").value =map.analysis_depart;
			document.getElementById("analysis_describe").value =map.analysis_describe;
			var analysis_type = map.analysis_type;
			var obj = document.getElementsByName("analysis_type");
			for(var i =0;analysis_type!=null && analysis_type!=''&&i<obj.length;i++){
				var value = obj[i].value;
				if(analysis_type.indexOf(value)!=-1){
					obj[i].checked = true;
				}
			}
			document.getElementById("analysis_employee").value = map.analysis_employee;
			document.getElementById("analysis_licence").value =map.analysis_licence;
			document.getElementById("analysis_task").value =map.analysis_task;
			document.getElementById("evaluate_name").value =map.evaluate_name;
			document.getElementById("evaluate_class").value =map.evaluate_class;
			document.getElementById("evaluate_opearater").value =map.evaluate_opearater;
			document.getElementById("evaluate_discuss").value = map.evaluate_discuss;
			var evaluate_defend = map.evaluate_defend;
			var obj = document.getElementsByName("evaluate_defend");
			for(var i =0;evaluate_defend!=null && evaluate_defend!=''&&i<obj.length;i++){
				var value = obj[i].value;
				if(evaluate_defend.indexOf(value)!=-1){
					obj[i].checked = true;
				}
			}
			document.getElementById("defend_describe").value = map.defend_describe;
			var evaluate_get = map.evaluate_get;
			var obj = document.getElementsByName("evaluate_get");
			for(var i =0;evaluate_get!=null && evaluate_get!=''&&i<obj.length;i++){
				var value = obj[i].value;
				if(evaluate_get.indexOf(value)!=-1){
					obj[i].checked = true;
				}
			}
			document.getElementById("get_describe").value =map.get_describe;
			var evaluate_suit = map.evaluate_suit;
			var obj = document.getElementsByName("evaluate_suit");
			for(var i =0;evaluate_suit!=null && evaluate_suit!=''&&i<obj.length;i++){
				var value = obj[i].value;
				if(evaluate_suit.indexOf(value)!=-1){
					obj[i].checked = true;
				}
			}
			document.getElementById("suit_describe").value =map.suit_describe;
			var evaluate_ask = map.evaluate_ask;
			var obj = document.getElementsByName("evaluate_ask");
			for(var i =0;evaluate_ask!=null && evaluate_ask!=''&&i<obj.length;i++){
				var value = obj[i].value;
				if(evaluate_ask.indexOf(value)!=-1){
					obj[i].checked = true;
				}
			}
			document.getElementById("ask_describe").value =map.ask_describe;
			var operation = map.operation;
			var obj = document.getElementsByName("operation");
			for(var i =0;operation!=null && operation!=''&&i<obj.length;i++){
				var value = obj[i].value;
				if(operation.indexOf(value)!=-1){
					obj[i].checked = true;
				}
			}
			document.getElementById("evaluate_suggestion").value =map.evaluate_suggestion;
			document.getElementById("evaluate_present").value = map.evaluate_present;
			document.getElementById("evaluate_fill").value = map.evaluate_fill;
			document.getElementById("evaluate_audit").value =map.evaluate_audit;
			document.getElementById("evaluate_date").value =map.evaluate_date;
			document.getElementById("history_class").value =map.history_class;
			document.getElementById("history_date").value =map.history_date;
		}
	}
}

function submitButton(isProject){
	var isProject = isProject;
	var form = document.getElementById("form");
	if(checkText0(isProject)){
		return;
	}
	window.close();
}
var substr = "";
function checkText0(isProject){
	var second_org=document.getElementById("second_org").value;
	var second_org2=document.getElementById("second_org2").value;
	var third_org=document.getElementById("third_org").value;
	var third_org2=document.getElementById("third_org2").value;
	var isProject = isProject ? isProject : "";
	if(second_org==""){
		document.getElementById("second_org2").value = "";
		alert("单位不能为空，请填写！");
		return true;
	}
	if(third_org==""){
		document.getElementById("third_org2").value="";
		alert("基层单位不能为空，请填写！");
		return true;
	}
	
	var rules_analy_date=document.getElementById("rules_analy_date").value;
	var rules_check_date=document.getElementById("rules_check_date").value;
	if(rules_analy_date==""){
		alert("工作安全分析日期不能为空，请填写！");
		return true;
	}
	if(rules_check_date==""){
		alert("工作循环检查日期不能为空，请填写！");
		return true;
	}
	
	var rules_id = document.getElementById("rules_id").value;	
	var submitstr = 'second_org='+second_org+'&third_org='+third_org +
	'&rules_check_date='+rules_check_date+'&rules_analy_date='+rules_analy_date+'&isProject='+isProject;
	var analysis_code=document.getElementById("analysis_code").value;
	if(analysis_code!=''){
		submitstr = submitstr +'&analysis_code='+analysis_code;
	}
	var analysis_date=document.getElementById("analysis_date").value;
	if(analysis_date!=''){
		submitstr = submitstr +'&analysis_date='+analysis_date;
	}
	var analysis_depart=document.getElementById("analysis_depart").value;
	if(analysis_depart!=''){
		submitstr = submitstr +'&analysis_depart='+analysis_depart;
	}
	var analysis_describe=document.getElementById("analysis_describe").value;
	if(analysis_describe!=''){
		submitstr = submitstr +'&analysis_describe='+analysis_describe;
	}
	var obj = document.getElementsByName("analysis_type");
	var analysis_type = '';
	for(var i=0;i<obj.length ;i++){
		if(obj[i].checked ==true){
			analysis_type = analysis_type + obj[i].value+'-';
		}
	}
	submitstr = submitstr +'&analysis_type='+analysis_type;
	var analysis_employee=document.getElementById("analysis_employee").value;
	if(analysis_employee!=''){
		submitstr = submitstr +'&analysis_employee='+analysis_employee;
	}
	var analysis_licence=document.getElementById("analysis_licence").value;
	if(analysis_licence!=''){
		submitstr = submitstr +'&analysis_licence='+analysis_licence;
	}
	var analysis_task=document.getElementById("analysis_task").value;
	if(analysis_task!=''){
		submitstr = submitstr +'&analysis_task='+analysis_task;
	}
	
	
	var evaluate_name=document.getElementById("evaluate_name").value;
	if(evaluate_name!=''){
		submitstr = submitstr +'&evaluate_name='+evaluate_name;
	}
	var evaluate_class=document.getElementById("evaluate_class").value;
	if(evaluate_class!=''){
		submitstr = submitstr +'&evaluate_class='+evaluate_class;
	}
	var evaluate_opearater=document.getElementById("evaluate_opearater").value;
	if(evaluate_opearater!=''){
		submitstr = submitstr +'&evaluate_opearater='+evaluate_opearater;
	}
	var evaluate_discuss=document.getElementById("evaluate_discuss").value;
	if(evaluate_discuss!=''){
		submitstr = submitstr +'&evaluate_discuss='+evaluate_discuss;
	}
	obj = document.getElementsByName("evaluate_defend");
	var evaluate_defend = '';
	for(var i=0;i<obj.length ;i++){
		if(obj[i].checked ==true){
			evaluate_defend = evaluate_defend + obj[i].value+'-';
		}
	}
	submitstr = submitstr +'&evaluate_defend='+evaluate_defend;
	var defend_describe=document.getElementById("defend_describe").value;
	if(defend_describe!=''){
		submitstr = submitstr +'&defend_describe='+defend_describe;
	}
	obj = document.getElementsByName("evaluate_get");
	var evaluate_get = '';
	for(var i=0;i<obj.length ;i++){
		if(obj[i].checked ==true){
			evaluate_get = evaluate_get + obj[i].value+'-';
		}
	}
	submitstr = submitstr +'&evaluate_get='+evaluate_get;
	var get_describe =document.getElementById("get_describe").value;
	if(get_describe!=''){
		submitstr = submitstr +'&get_describe='+get_describe;
	}
	obj = document.getElementsByName("evaluate_suit");
	var evaluate_suit = '';
	for(var i=0;i<obj.length ;i++){
		if(obj[i].checked ==true){	
			evaluate_suit = evaluate_suit + obj[i].value+'-';
		}
	}
	submitstr = submitstr +'&evaluate_suit='+evaluate_suit;
	var suit_describe=document.getElementById("suit_describe").value;
	if(suit_describe!=''){
		submitstr = submitstr +'&suit_describe='+suit_describe;
	}
	obj = document.getElementsByName("evaluate_ask");
	var evaluate_ask = '';
	for(var i=0;i<obj.length ;i++){
		if(obj[i].checked ==true){
			evaluate_ask = evaluate_ask + obj[i].value+'-';
		}
	}
	submitstr = submitstr +'&evaluate_ask='+evaluate_ask;
	var ask_describe=document.getElementById("ask_describe").value;
	if(ask_describe!=''){
		submitstr = submitstr +'&ask_describe='+ask_describe;
	}
	obj = document.getElementsByName("operation");
	var operation = '';
	for(var i=0;i<obj.length ;i++){
		if(obj[i].checked ==true){
			operation = operation + obj[i].value+'-';
		}
	}
	submitstr = submitstr +'&operation='+evaluate_defend;
	var operation_describe=document.getElementById("operation_describe").value;
	if(operation_describe!=''){
		submitstr = submitstr +'&operation_describe='+operation_describe;
	}
	var evaluate_suggestion=document.getElementById("evaluate_suggestion").value;
	if(evaluate_suggestion!=''){
		submitstr = submitstr +'&evaluate_suggestion='+evaluate_suggestion;
	}
	var evaluate_present=document.getElementById("evaluate_present").value;
	if(evaluate_present!=''){
		submitstr = submitstr +'&evaluate_present='+evaluate_present;
	}
	
	var evaluate_fill=document.getElementById("evaluate_fill").value;
	if(evaluate_fill!=''){
		submitstr = submitstr +'&evaluate_fill='+evaluate_fill;
	}
	var evaluate_audit=document.getElementById("evaluate_audit").value;
	if(evaluate_audit!=''){
		submitstr = submitstr +'&evaluate_audit='+evaluate_audit;
	}
	var evaluate_date=document.getElementById("evaluate_date").value;
	if(evaluate_date!=''){
		submitstr = submitstr +'&evaluate_date='+evaluate_date;
	}
	
	var history_class=document.getElementById("history_class").value;
	if(history_class!=''){
		submitstr = submitstr +'&history_class='+history_class;
	}
	var history_date=document.getElementById("history_date").value;
	if(history_date!=''){
		submitstr = submitstr +'&history_date='+history_date;
	}
	if(rules_id!=null && rules_id!=''){
		submitstr = submitstr +'&rules_id='+rules_id;
	}
	var obj = jcdpCallService("HseOperationSrv", "saveOperationRules", submitstr);
	if(obj.returnCode == '0'){
		document.getElementById("rules_id").value = obj.rules_id;
		if(checkAnalysis()){
			return;
		}
		if(checkEvaluate1()){
			return;
		}
		if(checkEvaluate2()){
			return;
		}
		if(checkHistory()){
			return;
		}
		if(substr!=''){
			var retObj = jcdpCallService("HseOperationSrv", "saveEvaluationStaff", "sql="+substr);
		}
		alert("保存成功!");	
	}
	
	return false;
}

function checkAnalysis(){
	var rules_id = document.getElementById("rules_id").value;	
	var autoOrder = document.getElementById("analysis").rows.length;
	for(var i =2 ; i<= autoOrder-1 ;i++){
		var tr = document.getElementById("analysis").rows[i];
		var analysis_id = tr.cells[1].children[0].value;
		if(analysis_id!=null && analysis_id!=''){
			substr = substr + "update bgp_hse_operation_analysis t set t.rules_id ='"+rules_id+"' ,t.updator_id='"+user_id+"' ," +
			" t.modifi_date = sysdate ,t.work_step ='?', t.danger ='?' ,t.aftermath='?' ,t.control_step='?' ,"+
			" t.possibility='?',t.ponderance='?',t.riskiness='?',t.improve_step='?' ,t.results='?',"+
			" t.project_info_no='"+project_info_no+"' where t.analysis_id ='"+analysis_id+"';" 
		}else{
			substr = substr + "insert into bgp_hse_operation_analysis(analysis_id ,rules_id ,work_step ,danger ,"+
			" aftermath ,control_step ,possibility ,ponderance ,riskiness ,improve_step ,results ,"+
			" project_info_no ,bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
			" values((select lower(sys_guid()) from dual),'"+rules_id+"' ,'?' ,'?' ,'?' ,'?' ,'?' ,'?' ,'?' ,'?' ,'?' ," +
			" '"+project_info_no+"' ,'0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');"
		}
		var work_step = tr.cells[0].firstChild.value;
		if(work_step==""){
			alert("工作步骤不能为空，请填写！");
			return true;
		}
		substr = substr.replace('?',work_step);
		
		var danger = tr.cells[1].children[1].value;
		if(danger ==null){
			danger ='';
		}
		substr = substr.replace('?',danger);
		
		var aftermath = tr.cells[2].firstChild.value;
		if(aftermath ==null){
			aftermath ='';
		}
		substr = substr.replace('?',aftermath);
		
		var control_step = tr.cells[3].firstChild.value;
		if(control_step ==null){
			control_step ='';
		}
		substr = substr.replace('?',control_step);
		
		var possibility = tr.cells[4].firstChild.value;
		if(possibility ==null){
			possibility ='';
		}
		substr = substr.replace('?',possibility);
		
		var ponderance = tr.cells[5].firstChild.value;
		if(ponderance ==null){
			ponderance ='';
		}
		substr = substr.replace('?',ponderance);
		
		var riskiness = tr.cells[6].firstChild.value;
		if(riskiness ==null){
			riskiness ='';
		}
		substr = substr.replace('?',riskiness);
		
		var improve_step = tr.cells[7].firstChild.value;
		if(improve_step ==null){
			improve_step ='';
		}
		substr = substr.replace('?',improve_step);
		
		var results = tr.cells[8].firstChild.value;
		if(results ==null){
			results ='';
		}
		substr = substr.replace('?',results);
		
	}
}
function checkEvaluate1(){
	var rules_id = document.getElementById("rules_id").value;	
	var autoOrder = document.getElementById("evaluate1").rows.length;
	for(var i =1 ; i<= autoOrder-1 ;i++){
		var tr = document.getElementById("evaluate1").rows[i];
		var evaluate_id = tr.cells[1].children[0].value;
		debugger;
		if(evaluate_id!=null && evaluate_id!=''){
			substr = substr + "update bgp_hse_operation_evaluate t set t.rules_id ='"+rules_id+"' ,t.updator_id='"+user_id+"' ," +
			" t.modifi_date =sysdate ,t.operation_step ='?', t.key_point ='?' ,t.fault_risk='?' ,"+
			" t.project_info_no='"+project_info_no+"' where t.evaluate_id ='"+evaluate_id+"';" 
		}else{
			substr = substr + "insert into bgp_hse_operation_evaluate(evaluate_id ,rules_id ,operation_step ,key_point ,fault_risk ,"+
			" project_info_no ,bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
			" values((select lower(sys_guid()) from dual),'"+rules_id+"' ,'?' ,'?' ,'?' ," +
			" '"+project_info_no+"','0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');"
		}
		var operation_step = tr.cells[1].children[1].value;
		if(operation_step==""){
			alert("操作步骤不能为空，请填写！");
			return true;
		}
		substr = substr.replace('?',operation_step);
		
		var key_point = tr.cells[2].firstChild.value;
		if(key_point ==null){
			key_point ='';
		}
		substr = substr.replace('?',key_point);
		
		var fault_risk = tr.cells[3].firstChild.value;
		if(fault_risk ==null){
			fault_risk ='';
		}
		substr = substr.replace('?',fault_risk);
		
	}
}
function checkEvaluate2(){
	var rules_id = document.getElementById("rules_id").value;	
	var autoOrder = document.getElementById("evaluate2").rows.length;
	for(var i =2 ; i<= autoOrder-2 ;i++){
		var tr = document.getElementById("evaluate2").rows[i];
		var suggest_id = tr.cells[1].children[0].value;
		if(suggest_id!=null && suggest_id!=''){
			substr = substr + "update bgp_hse_operation_evaluates t set t.rules_id ='"+rules_id+"' ,t.updator_id='"+user_id+"' ," +
			" t.modifi_date =sysdate ,t.suggestion ='?', t.introducer ='?' ,"+
			" t.project_info_no='"+project_info_no+"' where t.suggest_id ='"+suggest_id+"';" 
		}else{
			substr = substr + "insert into bgp_hse_operation_evaluates(suggest_id ,rules_id ,suggestion ,introducer ,"+
			" project_info_no ,bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
			" values((select lower(sys_guid()) from dual),'"+rules_id+"' ,'?' ,'?' ," +
			" '"+project_info_no+"' ,'0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');"
		}
		var suggestion = tr.cells[1].children[1].value;
		if(suggestion==""){
			alert("建议内容不能为空，请填写！");
			return true;
		}
		substr = substr.replace('?',suggestion);
		
		var introducer = tr.cells[2].firstChild.value;
		if(introducer ==null){
			introducer ='';
		}
		substr = substr.replace('?',introducer);
		
	}
}
function checkHistory(){
	var rules_id = document.getElementById("rules_id").value;	
	var autoOrder = document.getElementById("history").rows.length;
	for(var i =2 ; i<= autoOrder-2 ;i++){
		var tr = document.getElementById("history").rows[i];
		var history_id = tr.cells[1].children[0].value;
		if(history_id!=null && history_id!=''){
			substr = substr + "update bgp_hse_operation_history t set t.rules_id ='"+rules_id+"' ,t.updator_id='"+user_id+"' ," +
			" t.modifi_date =sysdate ,t.operation_staff ='?' ,t.program ='?' ,t.execute_date =to_date('?','yyyy-MM-dd') ,"+
			" t.execute_result ='?' ,t.note ='?' ,t.project_info_no='"+project_info_no+"' where t.history_id ='"+history_id+"';" 
		}else{
			substr = substr + "insert into bgp_hse_operation_history(history_id ,rules_id ,operation_staff ,program ,"+
			" execute_date ,execute_result ,note ,project_info_no ,bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
			" values((select lower(sys_guid()) from dual),'"+rules_id+"' ,'?' ,'?' ,to_date('?','yyyy-MM-dd') ,'?' ,'?' ," +
			" '"+project_info_no+"' ,'0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');"
		}
		var operation_staff = tr.cells[1].children[1].value;
		if(operation_staff==""){
			alert("操作人员不能为空，请填写！");
			return true;
		}
		substr = substr.replace('?',operation_staff);
		
		var program = tr.cells[2].firstChild.value;
		if(program ==null){
			program ='';
		}
		substr = substr.replace('?',program);
		
		var execute_date = tr.cells[3].firstChild.value;
		if(execute_date ==null){
			execute_date ='';
		}
		substr = substr.replace('?',execute_date);
		
		var execute_result = tr.cells[4].firstChild.value;
		if(execute_result ==null){
			execute_result ='';
		}
		substr = substr.replace('?',execute_result);
		
		var note = tr.cells[5].firstChild.value;
		if(note ==null){
			note ='';
		}
		substr = substr.replace('?',note);
		
	}
}
/*工作安全分析表*/
function loadAnalysis(list){
	for(var i =0;i<list.length;i++){
		var map = list[i];
		var autoOrder = document.getElementById("analysis").rows.length;

		var newTR = document.getElementById("analysis").insertRow(autoOrder);
	    var td = newTR.insertCell(0);
	    td.innerHTML = "<input name='work_step'  type='text' value='"+map.work_step+"' class='input_width'/>";
	    
	    td = newTR.insertCell(1);
	    td.innerHTML = "<input type='hidden' name='analysis_id' class='input_width' value='"+map.analysis_id+"'/>"+
	    	"<input name='danger'  type='text' class='input_width' value='"+map.danger+"'/>";
	    
	    td = newTR.insertCell(2);
	    td.innerHTML = "<input name='aftermath' type='text' value='"+map.aftermath+"' class='input_width'/>";
	    
	    td = newTR.insertCell(3);
	    td.innerHTML = "<input name='control_step'  type='text'  value='"+map.control_step+"' class='input_width'/>";
	    
	    td = newTR.insertCell(4);
	    td.innerHTML = "<input name='possibility' type='text' value='"+map.possibility+"' class='input_width'/>";
	    
	    td = newTR.insertCell(5);
	    td.innerHTML = "<input name='ponderance' type='text' value='"+map.ponderance+"' class='input_width'/>";
	    
	    td = newTR.insertCell(6);
	    td.innerHTML = "<input name='riskiness' type='text'  value='"+map.riskiness+"' class='input_width'/>";
	    
	    td = newTR.insertCell(7);
	    td.innerHTML = "<input name='improve_step' type='text' value='"+map.improve_step+"' class='input_width'/>";
	    
	    td = newTR.insertCell(8);
	    td.innerHTML = "<input name='results' type='text' value='"+map.results+"' class='input_width'/>";
	    
	    td = newTR.insertCell(9);
	    td.innerHTML = "<span class='sc'><a href='#' onclick=deleteRules('bgp_hse_operation_analysis','analysis','analysis_id',2)  title='删除'></a></span>";
	}
	
    
}
/*工作循环检查评估表*/
function loadEvaluate1(list){
	for(var i =0;i<list.length;i++){
		var map = list[i];
		var autoOrder = document.getElementById("evaluate1").rows.length;
	
		var newTR = document.getElementById("evaluate1").insertRow(autoOrder);
	    var td = newTR.insertCell(0);
	    td.innerHTML = autoOrder;
	    td.align ='center';
	    
	    td = newTR.insertCell(1);
	    td.innerHTML = "<input type='hidden' name='evaluate_id' class='input_width' value='"+map.evaluate_id+"'/>"+
	    	"<input name='operation_step'  type='text' value='"+map.operation_step+"' class='input_width'/>";
	    
	    td = newTR.insertCell(2);
	    td.innerHTML = "<input name='key_point' type='text' value='"+map.key_point+"' class='input_width'/>";
	    
	    td = newTR.insertCell(3);
	    td.innerHTML = "<input name='fault_risk'  type='text'  value='"+map.fault_risk+"' class='input_width'/>";
	    
	    td = newTR.insertCell(4);
	    td.innerHTML = "<span class='sc'><a href='#' onclick=deleteRules('bgp_hse_operation_evaluate','evaluate1','evaluate_id',1)  title='删除'></a></span>";
	}
}
/*工作循环检查评估表*/
function loadEvaluate2(list){
	for(var i =0;i<list.length;i++){
		var map = list[i];
		var autoOrder = document.getElementById("evaluate2").rows.length-1;
	
		var newTR = document.getElementById("evaluate2").insertRow(autoOrder);
	    var td = newTR.insertCell(0);
	    td.innerHTML = (autoOrder-1);
	    td.align ='center';
	    
	    td = newTR.insertCell(1);
	    td.innerHTML = "<input type='hidden' name='suggest_id' value='"+map.suggest_id+"' class='input_width'/>"+
	    	"<input name='suggestion' colspan='4' type='text' value='"+map.suggestion+"' class='input_width'/>";
	    td.colSpan="4"
	    	
	    td = newTR.insertCell(2);
	    td.innerHTML = "<input name='introducer' type='text' value='"+map.introducer+"' class='input_width'/>";
	    
	    td = newTR.insertCell(3);
	    td.innerHTML = "<span class='sc'><a href='#' onclick=deleteRules('bgp_hse_operation_evaluates','evaluate2','suggest_id',2)  title='删除'></a></span>";
	}
}
/*工作循环检查历史记录表*/
function loadHistory(list){
	for(var i =0;i<list.length;i++){
		var map = list[i];
		var autoOrder = document.getElementById("history").rows.length-1;
	
		var newTR = document.getElementById("history").insertRow(autoOrder);
	    var td = newTR.insertCell(0);
	    td.innerHTML = (autoOrder-1);
	    td.align ='center';
	    
	    td = newTR.insertCell(1);
	    td.innerHTML = "<input type='hidden' name='history_id' class='input_width' value='"+map.history_id+"'/>"+
	    	"<input name='operation_staff'  type='text' value='"+map.operation_staff+"' class='input_width'/>";
	    
	    td = newTR.insertCell(2);
	    td.innerHTML = "<input name='program' type='text' value='"+map.program+"' class='input_width'/>";
	    
	    td = newTR.insertCell(3);
	    td.innerHTML = "<input id='execute_date"+(autoOrder-1)+"' name='execute_date"+(autoOrder-1)+"' type='text'  value='"+map.execute_date+"' class='input_width' readonly/>"+
	    "&nbsp;<img src='/images/calendar.gif' id='history"+(autoOrder-1)+"' name='history"+(autoOrder-1)+"' width='16' "+
	    "height='16' style='cursor: hand;' onmouseover='calDateSelector(execute_date"+(autoOrder-1)+",history"+(autoOrder-1)+");' />";
	    
	    td = newTR.insertCell(4);
	    td.innerHTML = "<input name='execute_result' type='text' value='"+map.execute_result+"' class='input_width'/>";
	    
	    td = newTR.insertCell(5);
	    td.innerHTML = "<input name='note' type='text' value='"+map.note+"' class='input_width'/>";
	    
	    td = newTR.insertCell(6);
	    td.innerHTML = "<span class='sc'><a href='#' onclick=deleteRules('bgp_hse_operation_history','history','history_id',2)  title='删除'></a></span>";
	}
}
/*工作安全分析表*/
function addAnalysis(){
	var autoOrder = document.getElementById("analysis").rows.length;

	var newTR = document.getElementById("analysis").insertRow(autoOrder);
    var td = newTR.insertCell(0);
    td.innerHTML = "<input name='work_step'  type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(1);
    td.innerHTML = "<input type='hidden' name='analysis_id' class='input_width'/>"+
    	"<input name='danger'  type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(2);
    td.innerHTML = "<input name='aftermath' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(3);
    td.innerHTML = "<input name='control_step'  type='text'  value='' class='input_width'/>";
    
    td = newTR.insertCell(4);
    td.innerHTML = "<select name='possibility' class='select_width' ><option value=''>请选择</option><option value='A'>A</option><option value='B'>B</option><option value='C'>C</option><option value='D'>D</option><option value='E'>E</option><select>";
    
    td = newTR.insertCell(5);
    td.innerHTML = "<select name='ponderance' class='select_width' onchange='autoRisk();' ><option value=''>请选择</option><option value='0'>0</option><option value='1'>1</option><option value='2'>2</option><option value='3'>3</option><option value='4'>4</option><option value='5'>5</option><select>";
    
    td = newTR.insertCell(6);
    td.innerHTML = "<input name='riskiness' type='text'  value='' class='input_width' readonly/>";
    
    td = newTR.insertCell(7);
    td.innerHTML = "<input name='improve_step' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(8);
    td.innerHTML = "<input name='results' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(9);
    td.innerHTML = "<span class='sc'><a href='#' onclick=deleteRules('bgp_hse_operation_analysis','analysis','analysis_id',2)  title='删除'></a></span>";
    
}

function autoRisk(){
	var autoOrder = document.getElementById("analysis").rows.length;
	var td = event.srcElement;
	var trRows = td.parentElement.parentElement.rowIndex;
		
	var possibility = document.getElementsByName("possibility")[trRows-2].value;
	if(possibility==""){
		alert("请先选择可能性!");
		document.getElementsByName("ponderance")[trRows-2].value= "";
		return;
	}
	var ponderance = document.getElementsByName("ponderance")[trRows-2].value;
	document.getElementsByName("riskiness")[trRows-2].value = possibility + ponderance;
	var groundColor = "";
	if(possibility=="A"){
		if(ponderance=="5"){
			groundColor = "orange";
		}else{
			groundColor = "green";
		}
	}else if(possibility=="B"){
		if(ponderance=="4"){
			groundColor = "orange";
		}else if(ponderance=="5"){
			groundColor = "red";
		}else{
			groundColor = "green";
		}
		
	}else if(possibility=="C"){
		if(ponderance=="3"){
			groundColor = "orange";
		}else if(ponderance=="4"||ponderance=="5"){
			groundColor = "red";
		}else{
			groundColor = "green";
		}
	}else if(possibility=="D"){
		if(ponderance=="2"||ponderance=="3"){
			groundColor = "orange";
		}else if(ponderance=="4"||ponderance=="5"){
			groundColor = "red";
		}else{
			groundColor = "green";
		}
	}else if(possibility=="E"){
		if(ponderance=="0"){
			groundColor = "green";
		}else if(ponderance=="1"||ponderance=="2"){
			groundColor = "orange";
		}else{
			groundColor = "red";
		}
	}
	
	 document.getElementsByName("riskiness")[trRows-2].style.background = groundColor;
	
}

/*工作循环检查评估表*/
function addEvaluate1(){
	var autoOrder = document.getElementById("evaluate1").rows.length;

	var newTR = document.getElementById("evaluate1").insertRow(autoOrder);
    var td = newTR.insertCell(0);
    td.innerHTML = autoOrder;
    td.align ='center';
    
    td = newTR.insertCell(1);
    td.innerHTML = "<input type='hidden' name='evaluate_id' value='' class='input_width'/>"+
    	"<input name='operation_step'  type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(2);
    td.innerHTML = "<input name='key_point' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(3);
    td.innerHTML = "<input name='fault_risk'  type='text'  value='' class='input_width'/>";
    
    td = newTR.insertCell(4);
    td.innerHTML = "<span class='sc'><a href='#' onclick=deleteRules('bgp_hse_operation_evaluate','evaluate1','evaluate_id',1)  title='删除'></a></span>";
    
}
/*工作循环检查评估表*/
function addEvaluate2(){
	var autoOrder = document.getElementById("evaluate2").rows.length-1;

	var newTR = document.getElementById("evaluate2").insertRow(autoOrder);
    var td = newTR.insertCell(0);
    td.innerHTML = (autoOrder-1);
    td.align ='center';
    
    td = newTR.insertCell(1);
    td.innerHTML = "<input type='hidden' name='suggest_id' value='' class='input_width'/>"+
    	"<input name='suggestion' colspan='4' type='text' value='' class='input_width'/>";
    td.colSpan="4"
    	
    td = newTR.insertCell(2);
    td.innerHTML = "<input name='introducer' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(3);
    td.innerHTML = "<span class='sc'><a href='#' onclick=deleteRules('bgp_hse_operation_evaluates','evaluate2','suggest_id',2)  title='删除'></a></span>";
    
}
/*工作循环检查历史记录表*/
function addHistory(){
	var autoOrder = document.getElementById("history").rows.length-1;

	var newTR = document.getElementById("history").insertRow(autoOrder);
    var td = newTR.insertCell(0);
    td.innerHTML = (autoOrder-1);
    td.align ='center';
    
    td = newTR.insertCell(1);
    td.innerHTML = "<input type='hidden' name='history_id' class='input_width'/>"+
    	"<input name='operation_staff'  type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(2);
    td.innerHTML = "<input name='program' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(3);
    td.innerHTML = "<input id='execute_date"+(autoOrder-1)+"' name='execute_date"+(autoOrder-1)+"' type='text'  value='' class='input_width' readonly/>"+
    "&nbsp;<img src='/images/calendar.gif' id='history"+(autoOrder-1)+"' name='history"+(autoOrder-1)+"' width='16' "+
    "height='16' style='cursor: hand;' onmouseover='calDateSelector(execute_date"+(autoOrder-1)+",history"+(autoOrder-1)+");' />";
    
    td = newTR.insertCell(4);
    td.innerHTML = "<input name='execute_result' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(5);
    td.innerHTML = "<input name='note' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(6);
    td.innerHTML = "<span class='sc'><a href='#' onclick=deleteRules('bgp_hse_operation_history','history','history_id',2)  title='删除'></a></span>";

}
function deleteRules(table , tableName , column,index){
	var obj = event.srcElement.parentNode.parentNode.parentNode;
	var rowIndex = obj.rowIndex;
	var key_id = obj.cells[1].firstChild.value;
	if(key_id !=null && key_id !=''){
		var sql = "update "+table+" t set t.bsflag='1' where t."+column+" ='"+key_id+"'"
		var retObj = jcdpCallService("HseOperationSrv", "saveEvaluationStaff", "sql="+sql);;
	}
	document.getElementById(tableName).deleteRow(rowIndex);
	if(tableName!= null && tableName=='history' ){
		changeHistory();
	}else if(tableName!= null && tableName!='analysis'){
		changeAutoOrder(tableName ,index);
	}
}

function changeAutoOrder(tableName , index){
	var autoOrder = document.getElementById(tableName).rows.length-index;
	var start = 1;
	for(var i =index ;i<= autoOrder ;i++){
		var tr = document.getElementById(tableName).rows[i];
		tr.cells[0].innerHTML = start;
		start++;
	}
}
function changeHistory(){
	var autoOrder = document.getElementById('history').rows.length-2;
	var start = 1;
	for(var i =2 ;i<= autoOrder ;i++){
		var tr = document.getElementById('history').rows[i];
		tr.cells[0].innerHTML = start;
		var value =tr.cells[3] .firstChild.value;
		tr.cells[3].innerHTML = "<input id='execute_date"+start+"' name='execute_date"+start+"' type='text'  value='"+value+"' class='input_width' readonly='readonly'/>"+
	    "&nbsp;<img src='/images/calendar.gif' id='history"+start+"' name='history"+start+"' width='16' "+
	    "height='16' style='cursor: hand;' onmouseover='calDateSelector(execute_date"+start+",history"+start+");' />";
		start++;
	}
}