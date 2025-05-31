var task_ids = '';//作业拼接字符串
var task_names = ''//作业名称拼接字符串
var id = '';//工序
var name = '';//工序名称
var rows = 1; //table中总行数
var rowIndex = 0;//选中的行号
var modify = false;//修改
var add = false; //添加行
var modifyIndex = 0;//待修改的行号
var total = 0; //不合格数量(总)
var summary_num = 0; //不合格数量(本次)
var total_shot = 0; //二级品数量(总)
var shot = 0; //二级品数量(本次)
function getTab(obj,index) { 
	if(project_type!='5000100004000000009'){
		if(name!=null && name!='' && name.indexOf('采集')!=-1 ){
			var liTag=document.getElementsByTagName("li");
			liTag[2].style.display ='block';
		}else{
			var liTag=document.getElementsByTagName("li");
			liTag[2].style.display ='none';
		}
	}else{
		if(name!=null && name!='' && (name.indexOf('人工场源电磁法')!=-1 || name.indexOf('天然场源电磁法')!=-1) ){//"人工场源电磁法、天然场源电磁法"才有资料评价
			var liTag=document.getElementsByTagName("li");
			liTag[2].style.display ='block';
		}else{
			var liTag=document.getElementsByTagName("li");
			liTag[2].style.display ='none';
		}
	}
	
	var liTag=document.getElementsByTagName("li");
	for(var j =0 ;j<liTag!=null && j<liTag.length;j++){
		var selectedTag = liTag[j];
		if(selectedTag!=null){
			selectedTag.className ="";
		}
	}
	selectedTag = obj.parentElement;
	selectedTag.className ="selectTag";
	var showContent = 'tab_box_content'+index;
	for(var i=1; j=document.getElementById("tab_box_content"+i); i++){
		if(j!=null){
			j.style.display = "none";
		}
	}
	document.getElementById(showContent).style.display = "block";
	if(index == 2 ){
		document.getElementById('check').style.display = "block";
		document.getElementById('shot').style.display = "none";
		document.getElementById('usual_check').style.display = "block";
		document.getElementById('usual_shot').style.display = "none";
	}
	if(index == 3){
		document.getElementById('check').style.display = "none";
		document.getElementById('shot').style.display = "block";
		document.getElementById('usual_check').style.display = "none";
		document.getElementById('usual_shot').style.display = "block";
	}
}
//提交汇总信息
function newSubmit(){
	var index = task_ids.indexOf(',');
	if(index!=-1){
		alert("多条作业不允许修改");
		return;
	}
	
	var temp = document.getElementById("check").style.display;
	if(temp == 'block'){
		var quality_num = document.getElementById("quality_num").value;
		if(quality_num ==null || quality_num=='' || quality_num<=0){
			alert("检查量不能为0或者为空");
			return;
		}
		var summary_date = document.getElementById("summary_date").value;
		if(summary_date ==null || summary_date=='' ){
			alert("汇总日期不能空");
			return;
		}
		if(window.confirm("确定保存'常用'、'填报'标签下的内容?")){
			var autoOrder = document.getElementById("summaryTable").rows.length;
			var str = '';
			str = str + "summarier=" + document.getElementById("summarier").value;
			str = str + "&summary_date=" + document.getElementById("summary_date").value;
			str = str + "&check_date=" + document.getElementById("check_date").value;
			/*str = str + "&quality_num=" + document.getElementById("quality_num").value;
			str = str + "&summary_num=" + document.getElementById("summary_num").value;*/
			str = str + "&quality_num=" + document.getElementById("quality_num").value;
			str = str + "&summary_num=" + summary_num;
			str = str + "&table_name=bgp_qua_summary_history";
			var summary_history_id = '';
			var retObj = jcdpCallService("QualitySrv", "saveQualityByMap", str);
			if(retObj!=null && retObj.returnCode =='0'){
				if(retObj.table_id!=null){
					summary_history_id = retObj.table_id;
				}
			}
			var substr = '';
			var row = document.getElementById("summaryTable").rows;
			for(var i = 1 ; i < autoOrder ; i++){
				var record_name = row[i].cells[2].innerHTML;
				var record_num = row[i].cells[3].firstChild.value;
				var unit_id = row[i].cells[5].firstChild.value;
				var notes = row[i].cells[6].firstChild.value;
				substr = substr + "insert into bgp_qua_record_summary(summary_id ,project_info_no ,object_id ,object_name ,"+
				" task_id ,task_name ,record_name ,record_num ,unit_id ,notes ,summary_history_id ,org_id ,org_subjection_id ,"+
				" bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
				" values((select lower(sys_guid()) from dual),'"+project_info_no+"' ,'"+id+"' ,'"+name+"' ,'"+task_ids+"' ,'"+task_names+"' ,"+
				" '"+record_name+"' ,'"+record_num+"' ,'"+unit_id+"' ,'"+notes+"' ,'"+summary_history_id+"' ,'"+org_id+"' ," +
				" '"+org_subjection_id+"' ,'0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');";
			}
			if(substr!=null && substr!=''){
				substr="sql="+substr;
				retObj = jcdpCallService("QualitySrv", "saveQualityBySql", substr);
			}
			cleanTables();
			showSummaryTable(id , name , task_ids , task_names);
		}
	}else{
		var shot_date = document.getElementById("shot_date").value;
		if(shot_date ==null || shot_date=='' ){
			alert("汇总日期不能空");
			return;
		}
		var content = "确定保存'常用'、'单炮评价'标签下的内容?";
		if(project_type!=null && project_type=='5000100004000000009'){
			content = "确定保存'常用'、'资料评价'标签下的内容?";
		}
		if(window.confirm(content)){
			var autoOrder = document.getElementById("shotTable").rows.length;
			//var str = "object_id=" + id + "&object_name=单炮&task_id=" + task_ids + "&task_name=" + task_names;
			var str = '';
			str = str + "&checker=" + document.getElementById("evaluate_id").value;
			str = str + "&check_date=" + document.getElementById("evaluate_date").value;
			str = str + "&summarier=" + document.getElementById("shot_id").value;
			str = str + "&summary_date=" + document.getElementById("shot_date").value;
			str = str + "&shot_num=" + document.getElementById("shot_num").value;
			str = str + "&first_num=" + document.getElementById("first_num").value;
			str = str + "&second_num=" + document.getElementById("second_num").value;
			str = str + "&abandon_num=" + document.getElementById("abandon_num").value;
			str = str + "&table_name=bgp_qua_summary_history";
			var summary_history_id = '';
			var retObj = jcdpCallService("QualitySrv", "saveQualityByMap", str);
			if(retObj!=null && retObj.returnCode =='0'){
				if(retObj.table_id!=null){
					summary_history_id = retObj.table_id;
				}
			}
			var substr = '';
			var row = document.getElementById("shotTable").rows;
			for(var i = 1 ; i < autoOrder ; i++){
				var record_name = row[i].cells[2].innerHTML;
				var record_num = row[i].cells[3].firstChild.value;
				var notes = row[i].cells[5].firstChild.value;
				substr = substr + "insert into bgp_qua_record_summary(summary_id ,project_info_no ,object_id ,object_name ,"+
				" task_id ,task_name ,record_name ,record_num ,unit_id ,notes ,summary_history_id ,org_id ,org_subjection_id ,"+
				" bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
				" values((select lower(sys_guid()) from dual),'"+project_info_no+"' ,'"+id+"' ,'单炮' ,'"+task_ids+"' ,'"+task_names+"' ,"+
				" '"+record_name+"' ,'"+record_num+"' ,'' ,'"+notes+"' ,'"+summary_history_id+"' ,'"+org_id+"' ," +
				" '"+org_subjection_id+"' ,'0' ,sysdate ,'"+user_id+"' ,sysdate ,'"+user_id+"');";
			}
			if(substr!=null && substr!=''){
				substr="sql="+substr;
				retObj = jcdpCallService("QualitySrv", "saveQualityBySql", substr);
			}
			cleanTables();
			showSummaryTable(id , name , task_ids , task_names);
		}
	}
} 


cruConfig.cdtType = 'form';
cruConfig.queryStr = "";
cruConfig.queryService = "QualitySrv";
cruConfig.queryOp = "toCheckSummary";  //cruConfig.queryOp = "toCheckSummary";
function cleanTables(){ //清空所有的table
	var length = document.getElementById("summaryTable").rows.length;
	for(var i =length-1 ; i > 0 ; i--){
		document.getElementById("summaryTable").deleteRow(i);
	}
	length = document.getElementById("summaryTableView").rows.length;
	for(var i =length-1 ; i > 0 ; i--){
		document.getElementById("summaryTableView").deleteRow(i);
	}
	length = document.getElementById("shotTable").rows.length;
	for(var i =length-1 ; i > 0 ; i--){
		document.getElementById("shotTable").deleteRow(i);
	}
	length = document.getElementById("shotTableView").rows.length;
	for(var i =length-1 ; i > 0 ; i--){
		document.getElementById("shotTableView").deleteRow(i);
	}
}
//通过工序找到检查项
function showSummaryTable(objectId , objectName , taskIds , taskNames){
	if(taskIds==null || taskIds==''){
		alert("请选择作业!");
		return;
	}
	cleanTables();
	historySrc(objectName,taskIds,objectId);
	var liTag=document.getElementsByTagName("li")[0].firstChild;
	document.getElementById('check').style.display = "block";
	document.getElementById('shot').style.display = "none";
	document.getElementById('usual_check').style.display = "block";
	document.getElementById('usual_shot').style.display = "none";
	id = objectId;
	name = objectName;
	task_ids = taskIds;
	task_names = taskNames;
	getTab(liTag,1);
	if(name != undefined && name!=''){
		document.getElementById("object_name").value = objectName;
		if(name.indexOf('钻井') !=-1 ){
			document.getElementById("unit").innerHTML = '机组号';
			document.getElementById("unit1").innerHTML = '机组号';
		}else{
			document.getElementById("unit").innerHTML = '小组编号';
			document.getElementById("unit1").innerHTML = '小组编号';
		}
	}
	if(objectName != undefined ){
		document.getElementById("object_name1").value = objectName;
	}
	var sql = "";
	if(project_type!=null && project_type=='5000100004000000009'){
		sql = "select substr(max(sys_connect_by_path(dd.duty_person,';')),2) duty_person from ("+
		" select t.duty_person,rownum row_num1,rownum+1 row_num2 from bgp_qua_plan t where t.bsflag='0' and t.project_info_no='"+project_info_no+"' "+
		" and t.object_id in(select object_id from bgp_p6_activity a where a.bsflag ='0' and a.id in('"+taskIds+"') "+
		" and a.project_object_id = (select object_id from bgp_p6_project p where p.bsflag ='0' and p.project_info_no='"+project_info_no+"')) "+
		" and t.object_name like'%"+objectName+"%' ) dd start with dd.row_num1 = 1 connect by prior dd.row_num2 = dd.row_num1";
	}else{
		sql = "select t.duty_person from bgp_qua_plan t "+
		" where t.bsflag='0' and t.project_info_no='"+project_info_no+"' and t.object_id ='"+objectId+"' and t.object_name like'%"+objectName+"%'";
	}
	var obj = syncRequest('Post',cruConfig.contextPath + appConfig.queryListAction,'querySql='+encodeURI(encodeURI(sql)));
	if(obj!=null && obj.returnCode =="0"){
		if(obj.datas!=null && obj.datas.length>0){
			var data = obj.datas[0];
			var duty_name = data.duty_person;
			document.getElementById("checker_name").value = duty_name;
			document.getElementById("checker_name1").value = duty_name;
		}
	}
	debugger;
	var usual = false;
	var retObj = jcdpCallService("QualitySrv", "getRecordList", "objectName="+objectName + "&task_id=" + taskIds+"&project_type="+project_type);//project_type项目类型
	if(retObj.returnCode =='0'){
		for(var i =0;retObj.typeList!=null && retObj.typeList.length>0 &&retObj.typeList[i]!=null;i++){
			var record_name = retObj.typeList[i].record_name;
			
			var autoOrder = document.getElementById("summaryTable").rows.length;
			var newTR = document.getElementById("summaryTable").insertRow(autoOrder);
			var tdClass = 'even';
			if(autoOrder%2==0){
				tdClass = 'odd';
			}
	        var td = newTR.insertCell(0);
	        td.innerHTML = "<input type='checkbox' name='chk_entity_id' value=''/>";
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        
	        td = newTR.insertCell(1);
	        td.innerHTML = autoOrder;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	        
	        td = newTR.insertCell(2);
	        td.innerHTML = record_name;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}

	        td = newTR.insertCell(3);
	        td.innerHTML = "<input name='record_num' type='text'  value='' onfocus='' onkeyup='changerValue(event)' onkeydown='javascript:return checkIfNum(event);'/>";
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	        
	        td = newTR.insertCell(4);
	        td.innerHTML = '';
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        
	        td = newTR.insertCell(5);
	        td.innerHTML = "<input name='unit_id' type='text' value=''/>";
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	        
	        td = newTR.insertCell(6);
	        td.innerHTML = "<input name='notes' type='text' value='' />";
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
		}
		showSummaryTableView(objectId , objectName , retObj.recordList);
		showQualityMap(objectId , objectName , retObj.qualityMap);
		showShotTable();
	}
	getSummaryNum();
	resizeNewTitleTable();
	if(project_type!=null && project_type=='5000100004000000009'){
		var querySql = "select nvl(sum(t.shot_num),0) shot_num,nvl(sum(t.first_num),0) first_num from bgp_qua_summary_history t"+
		" where t.bsflag ='0' and t.summary_history_id in(select distinct summary_history_id from bgp_qua_record_summary s "+
		" where s.bsflag ='0' and s.project_info_no ='"+project_info_no+"' and s.task_id in('"+taskIds+"'))";
		var retObj = syncRequest('Post',cruConfig.contextPath+appConfig.queryListAction,'querySql='+encodeURI(encodeURI(querySql)));
		if(retObj!=null && retObj.returnCode=='0' && retObj.datas!=null && retObj.datas[0]!=null){
			var shot_num1 = retObj.datas[0].shot_num ==null?"0":retObj.datas[0].shot_num;
			document.getElementById("shot_num1").value = shot_num1;
			var first_num1 = retObj.datas[0].first_num ==null?"0":retObj.datas[0].first_num;
			document.getElementById("first_num1").value = first_num1;
		}
	}
}
function showQualityMap(objectId , objectName , map){
	if(map!=null){
		document.getElementById("quality_num1").value =  map.quality_num;
		document.getElementById("summary_num1").value =  map.summary_num;
		document.getElementById("quality_num_old").value =  map.quality_num;
		//document.getElementById("summary_num").value =  map.summary_num;
		document.getElementById("check_date1").value =  map.check_date;
		document.getElementById("summarier1").value =  map.summarier;
		document.getElementById("summary_date1").value =  map.summary_date;
	}else{
		document.getElementById("quality_num1").value = "0";
		document.getElementById("summary_num1").value = "0";
		document.getElementById("quality_num_old").value = "0";
		document.getElementById("check_date1").value = "";
		document.getElementById("summarier1").value = "";
		document.getElementById("summary_date1").value =  "";
	}
	document.getElementById("quality_num").value = "0";
	document.getElementById("summary_num").value = "0";
	document.getElementById("check_date").value = "";
	document.getElementById("summarier").value = "";
	document.getElementById("summary_date").value =  "";
}
function showSummaryTableView(objectId , objectName , list){
	for(var i=0;list!=null && list.length>0 &&list[i];i++){
		var retObj = list[i];
		
		var record_name = retObj.record_name;
		var record_num = retObj.record_num;
		var unit_id = retObj.unit_id;
		if(unit_id==null) unit_id ='';
		var notes = retObj.notes;
		if(notes == null ) notes = '';
		var autoOrder = document.getElementById("summaryTableView").rows.length;
		var newTR = document.getElementById("summaryTableView").insertRow(autoOrder);
		var tdClass = 'even';
		if(autoOrder%2==0){
			tdClass = 'odd';
		}
	    var td = newTR.insertCell(0);
	    td.innerHTML = "<input type='checkbox' name='chk_entity_id' value='"+record_num+"'/>";
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	    
	    td = newTR.insertCell(1);
	    td.innerHTML = autoOrder;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
	    
	    td = newTR.insertCell(2);
	    td.innerHTML = record_name;
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	    
	    td = newTR.insertCell(3);
	    td.innerHTML = record_num ;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
	    
	    td = newTR.insertCell(4);
	    td.innerHTML = '';
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	    
	    td = newTR.insertCell(5);
	    td.innerHTML = unit_id;
	    td.className =tdClass+'_even'
	    if(autoOrder%2==0){
			td.style.background = "#FFFFFF";
		}else{
			td.style.background = "#ebebeb";
		}
	    
	    td = newTR.insertCell(6);
	    td.innerHTML = notes;
	    td.className = tdClass+'_odd';
	    if(autoOrder%2==0){
			td.style.background = "#f6f6f6";
		}else{
			td.style.background = "#e3e3e3";
		}
	}
	
}
//单炮评价
function showShotTable(){
	var usual = false;
	var retObj = jcdpCallService("QualitySrv", "getShotList", "objectName=单炮&task_id=" + task_ids);
	debugger;
	if(retObj.returnCode =='0' &&retObj.typeList!=null && retObj.typeList.length>0){
		for(var i =0;retObj.shotList[i]!=null;i++){
			var record_name = retObj.shotList[i].record_name;
			var autoOrder = document.getElementById("shotTable").rows.length;
			var newTR = document.getElementById("shotTable").insertRow(autoOrder);
			var tdClass = 'even';
			if(autoOrder%2==0){
				tdClass = 'odd';
			}
	        var td = newTR.insertCell(0);
	        td.innerHTML = "<input type='checkbox' name='shot_entity_id' value=''/>";
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        
	        td = newTR.insertCell(1);
	        td.innerHTML = autoOrder;
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	        
	        td = newTR.insertCell(2);
	        td.innerHTML = record_name;
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        var second_num = document.getElementById("second_num").value;

	        td = newTR.insertCell(3);
	        td.innerHTML = "<input name='record_shot_num' type='text'  value='' onfocus='checkIfZero(event)' onkeyup='shotChangeValue(event)' onkeydown='javascript:return checkIfNum(event);'/>";
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
	        
	        td = newTR.insertCell(4);
	        td.innerHTML = '';
	        td.className = tdClass+'_odd';
	        if(autoOrder%2==0){
				td.style.background = "#f6f6f6";
			}else{
				td.style.background = "#e3e3e3";
			}
	        
	        td = newTR.insertCell(5);
	        td.innerHTML = "<input name='notes' type='text' value='' />";
	        td.className =tdClass+'_even'
	        if(autoOrder%2==0){
				td.style.background = "#FFFFFF";
			}else{
				td.style.background = "#ebebeb";
			}
		}
		showShotTableView(retObj.shotList);
		debugger;
		showShotMap(retObj.shotMap);
	}
	
	getSecondNum();
	//showFirstPercent();
	//showShotPercent();
	resizeNewTitleTable();
}
function showShotMap(map){
	debugger;
	if(map!=null){
		var shot_num = 0;
		if(map.shot_num!=null ){
			shot_num = map.shot_num;
		}
		document.getElementById("shot_num1").value =  shot_num;
		document.getElementById("shot_num").value =  shot_num;
		var first_num = 0;
		if(map.first_num!=null ){
			first_num = map.first_num;
		}
		document.getElementById("first_num1").value =  first_num;
		document.getElementById("first_num").value =  first_num;
		var second_num = 0;
		if(map.second_num!=null ){
			second_num = map.second_num;
		}
		document.getElementById("second_num1").value =  second_num;
		document.getElementById("second_num").value =  second_num;
		var abandon_num = 0;
		if(map.abandon_num!=null ){
			abandon_num = map.abandon_num;
		}
		document.getElementById("abandon_num1").value =  abandon_num;
		document.getElementById("abandon_num").value =  abandon_num;
		document.getElementById("evaluate_name1").value =  map.checker;
		document.getElementById("evaluate_date1").value =  map.check_date;
		document.getElementById("shot_name1").value =  map.summarier;
		document.getElementById("shot_date1").value =  map.summary_date;
	}else{
		document.getElementById("shot_num1").value =  "0";
		document.getElementById("shot_num").value =  "0";
		document.getElementById("first_num1").value =  "0";
		document.getElementById("first_num").value =  "0";
		document.getElementById("second_num1").value =  "0";
		document.getElementById("second_num").value =  "0";
		document.getElementById("abandon_num1").value =  "0";
		document.getElementById("abandon_num").value =  "0";
		document.getElementById("evaluate_name1").value =  "";
		document.getElementById("evaluate_date1").value =  "";
		document.getElementById("shot_name1").value =  "";
		document.getElementById("shot_date1").value =  "";
	}
	document.getElementById("evaluate_id").value =  "";
	document.getElementById("evaluate_date").value =  "";
	document.getElementById("shot_id").value =  "";
	document.getElementById("shot_date").value =  "";
}
function showShotTableView(list){
	 for(var i =0;list!=null && list.length>0 && list[i]!=null;i++){
		 var retObj = list[i];
		 var record_name = retObj.record_name;
		 
		 var record_num = retObj.record_num;
		 if(record_num==null) record_num ='';
		 var notes = retObj.notes;
		 if(notes == null ) notes = '';
		 var autoOrder = document.getElementById("shotTableView").rows.length;
		 var newTR = document.getElementById("shotTableView").insertRow(autoOrder);
		 var tdClass = 'even';
		 if(autoOrder%2==0){
		 	tdClass = 'odd';
		 }
		 var td = newTR.insertCell(0);
		 td.innerHTML = "<input type='checkbox' name='shot1_entity_id' value='"+record_num+"'/>";
		 td.className = tdClass+'_odd';
		 if(autoOrder%2==0){
		 	td.style.background = "#f6f6f6";
		 }else{
		 	td.style.background = "#e3e3e3";
		 }
	    
		 td = newTR.insertCell(1);
		 td.innerHTML = autoOrder;
		 td.className =tdClass+'_even'
		 if(autoOrder%2==0){
		 	td.style.background = "#FFFFFF";
		 }else{
		 	td.style.background = "#ebebeb";
		 }
	    
	     td = newTR.insertCell(2);
	     td.innerHTML = record_name;
	     td.className = tdClass+'_odd';
	     if(autoOrder%2==0){
		 	td.style.background = "#f6f6f6";
		 }else{
		 	td.style.background = "#e3e3e3";
		 }
	     td = newTR.insertCell(3);
	     td.innerHTML = record_num ;
	     td.className =tdClass+'_even'
	     if(autoOrder%2==0){
		 	td.style.background = "#FFFFFF";
		 }else{
		 	td.style.background = "#ebebeb";
		 }
	    
	     td = newTR.insertCell(4);
	     td.innerHTML = '';
	     td.className = tdClass+'_odd';
	     if(autoOrder%2==0){
		 	td.style.background = "#f6f6f6";
		 }else{
		 	td.style.background = "#e3e3e3";
		 }
	    
	     td = newTR.insertCell(5);
	     td.innerHTML = notes;
	     td.className =tdClass+'_even'
	     if(autoOrder%2==0){
		 	td.style.background = "#FFFFFF";
		 }else{
		 	td.style.background = "#ebebeb";
		 }
	 }
	
}
function checkIfZero(event){
	event.srcElement.style.imeMode='disabled';
	var record_num = event.srcElement.value;
	if(record_num =='0'){
		event.srcElement.value= '';
	}
}
/* 输入的是否是数字 */
function checkIfNum(event){
	/*var element = event.srcElement;
	if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
		element.value = '';
	}
	if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
		return true;
	}
	else{
		return false;
	}*/
	
	var key = String.fromCharCode(event.keyCode);
	if(event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9 || !isNaN(key) ){
		return true;
	}else{
		return false;
	}
}
function change(id){
	if(id!=null && id=='quality_num'){
		var value = document.getElementById('quality_num').value;
		var old = document.getElementById('quality_num_old').value;
		document.getElementById('quality_num1').value = value-(-old);
	}else{
		var value = document.getElementById(id).value;
		document.getElementById(id + "1").value = value;
	}
}
function changerValue(event){
	var value =  event.srcElement.value;
	var cellIndex = event.srcElement.parentElement.cellIndex;
	var rowIndex = event.srcElement.parentElement.parentElement.rowIndex;
	var old = document.getElementById("summaryTableView").rows[rowIndex].cells[0].firstChild.value;
	document.getElementById("summaryTableView").rows[rowIndex].cells[cellIndex].innerHTML = value -(-old);
	getSummaryNum();
}
function getSummaryNum(){
	var table  = document.getElementById('summaryTableView');
	total = 0;
	for(var i =1;i<table.rows.length;i++){
		var tr = table.rows[i];
		total = tr.cells[3].innerHTML -(-total);
	}
	var record_num = document.getElementsByName("record_num");
	summary_num = 0;
	for(var i =0 ; i< record_num.length;i++){
		summary_num =   record_num[i].value - (-summary_num);
	}
	document.getElementById("summary_num1").value = total;
	document.getElementById("summary_num").value = summary_num;
	showPercent();
}
function showPercent(){
	var quality_num = document.getElementById("quality_num").value ;
	if(quality_num != null && quality_num != 0){
		var per = ((summary_num/quality_num)*100).toFixed(2)+"%";
		document.getElementById("percent").value = per;
	}
	var old = document.getElementById("quality_num_old").value ;
	document.getElementById("quality_num1").value = quality_num-(-old);
	var quality_num1 = document.getElementById("quality_num1").value ;
	if(quality_num1 != null && quality_num1 != 0){
		var per = ((total/quality_num1)*100).toFixed(2)+"%";
		document.getElementById("percent1").value = per;
	}
	var rows = document.getElementById("summaryTable").rows;
	if(rows.length == 1){
		return;
	}else{
		var sum = 0;
		var j = 1;
		var get = false;
		var percent =0;
		for(var i = rows.length - 1; i >=1 ;i--){
			var record_num = rows[i].cells[3].firstChild.value;
			percent = 0;
			if(summary_num != 0){
				if(record_num != 0){
					if(!get){
						j = i;
						get = true;
						continue;
					}
				}
				sum = sum - (-((record_num/summary_num)*100).toFixed(2));
				percent = ((record_num/summary_num)*100).toFixed(2)+"%";
			}
			rows[i].cells[4].innerHTML = percent;
		}
		if(sum == 0 && get==false){
			percent = '0.00%';
		}else if(sum == 0 && get==true){
			percent = '100%';
		}else{
			percent = (100 - sum).toFixed(2) + "%";
		}
		if(get){
			rows[j].cells[4].innerHTML = percent;
		}
	}
	
	rows = document.getElementById("summaryTableView").rows;
	if(rows.length == 1){
		return;
	}else{
		var sum = 0;
		var j = 1;
		var get = false;
		for(var i = rows.length - 1; i >=1 ;i--){
			var record_num = rows[i].cells[3].innerHTML;
			var percent = 0;
			if(total != 0){
				if(record_num != 0){
					if(!get){
						j = i;
						get = true;
						continue;
					}
				}
				sum = sum - (-((record_num/total)*100).toFixed(2));
				percent = ((record_num/total)*100).toFixed(2)+"%";
			}
			rows[i].cells[4].innerHTML = percent;
		}
		if(sum == 0 && get==false){
			percent = '0.00%';
		}else if(sum == 0 && get==true){
			percent = '100%';
		}else{
			percent = (100 - sum).toFixed(2) + "%";
		}
		if(get){
			rows[j].cells[4].innerHTML = percent;
		}
	}
	resizeNewTitleTable();
}
function showShotPercent(){
	var second_num = document.getElementById("second_num").value ;
	var rows = document.getElementById("shotTable").rows;
	if(rows.length == 1){
		return;
	}else{
		var sum = 0;
		var j = 1;
		var get = false;
		var percent = '0.00%';
		for(var i = rows.length - 1; i >= 1 ;i--){
			var record_num = rows[i].cells[3].firstChild.value;
			percent = '0.00%';
			if(shot != 0 ){
				if(record_num != 0){
					if(!get){
						j = i;
						get = true;
						continue;
					}
				}
				sum = sum - (-((record_num/shot)*100).toFixed(2));
				percent = ((record_num/shot)*100).toFixed(2)+"%";
			}else{
				percent = '0.00%';
			}
			rows[i].cells[4].innerHTML = percent;
		}
		if(sum == 0){
			percent = '0.00%';
		}else{
			percent = (100 - sum).toFixed(2) + "%";
		}
		if(get){
			rows[j].cells[4].innerHTML = percent;
		}
		
	}
	
	rows = document.getElementById("shotTableView").rows;
	if(rows.length == 1){
		return;
	}else{
		var sum = 0;
		var j = 0;
		var get = false;
		var percent = '0.00%';
		for(var i = rows.length - 1; i >= 1 ;i--){
			var record_num = rows[i].cells[3].innerHTML;
			percent = '0.00%';
			if(total_shot != 0 ){
				if(record_num != 0){
					if(!get){
						j = i;
						get = true;
						continue;
					}
				}
				sum = sum - (-((record_num/total_shot)*100).toFixed(2));
				percent = ((record_num/total_shot)*100).toFixed(2)+"%";
			}else{
				percent = '0.00%';
			}
			rows[i].cells[4].innerHTML = percent;
		}
		if(sum == 0){
			percent = '0.0%';
		}else{
			percent = (100 - sum).toFixed(2) + "%";
		}
		if(get){
			rows[j].cells[4].innerHTML = percent;
		}
		
	}
	
	resizeNewTitleTable();
}
function showFirstPercent(){
	var  first_num= document.getElementById("first_num").value;
	/*document.getElementById("first_num1").value = first_num;
	var second_num =  document.getElementById("second_num").value;
	var abandon_num =  document.getElementById("abandon_num").value;
	document.getElementById("abandon_num1").value = abandon_num;
	var shot_num = first_num - (-second_num) - (-abandon_num); */
	var total_num = document.getElementById("shot_num").value ;
	if(total_num != null && total_num != 0){
		var per = ((first_num/total_num)*100).toFixed(2)+"%";
		document.getElementById("first_percent1").value = per;
	}else{
		document.getElementById("first_percent1").value = '0.00%';
	}
}
function shotChangeValue(event){
	var value =  event.srcElement.value;
	var cellIndex = event.srcElement.parentElement.cellIndex;
	var rowIndex = event.srcElement.parentElement.parentElement.rowIndex;
	var old = document.getElementById("shotTableView").rows[rowIndex].cells[0].firstChild.value;
	document.getElementById("shotTableView").rows[rowIndex].cells[cellIndex].innerHTML = old -(-value);
	getSecondNum();
	var num = document.getElementById("second_num").value;
	if(total_shot!=null && num!=null){
		if(num=='' || num =='0'){
			event.srcElement.value = '';
			document.getElementById("shotTableView").rows[rowIndex].cells[cellIndex].innerHTML = old;
			return ;
		}else{
			if(num < total_shot){
				value = value.substr(0,value.length-1);
				event.srcElement.value = value;
				document.getElementById("shotTableView").rows[rowIndex].cells[cellIndex].innerHTML = old -(-value);
				getSecondNum();
			}
		}
	}else{
		event.srcElement.value = '';
		document.getElementById("shotTableView").rows[rowIndex].cells[cellIndex].innerHTML = old;
		return ;
	}
}
function getSecondNum(){
	var table  = document.getElementById('shotTableView');
	total_shot = 0;
	for(var i =1;i<table.rows.length;i++){
		var tr = table.rows[i];
		total_shot = tr.cells[3].innerHTML -(-total_shot);
	}
	var record_num = document.getElementsByName("record_shot_num");
	shot = 0;
	for(var i =0 ; i< record_num.length;i++){
		shot =   record_num[i].value - (-shot);
	}
	showFirstPercent();
	showShotPercent();
}
function saveCode(){
	if(!add && !modify){
		return;
	}
	var index = task_ids.indexOf(',');
	if(index!=-1){
		alert("多条作业不允许修改");
		return;
	}
	if(event.keyCode==13)
    {
		if(window.confirm('你确定保存所修改的内容吗?')){
			var value = document.getElementById("name").value;
			var tr = document.getElementById("checkTable").rows[modifyIndex];
			var summary_id = tr.cells[0].firstChild.value;
			var str = "object_id=" + id + "&object_name=" + name +"&task_id=" + task_ids + "&task_name=" + task_names;
			str = str + "&summarier=" + document.getElementById("summarier").value;
			str = str + "&summary_date=" + document.getElementById("summary_date").value;
			str = str + "&check_date=" + document.getElementById("check_date").value;
			var submitStr =str +  "&summary_id=" + summary_id + "&record_name=" + value;
			var retObj = jcdpCallService("QualitySrv", "saveCheckTable", submitStr);
			if(retObj.returnCode=='0'){
				var tr = document.getElementById("checkTable").rows[modifyIndex];
				tr.cells[2].innerHTML = value;
			}
			modify = false;
			add = false;
			modifyIndex = 0;
			cleanTables();
			showSummaryTable(id , name , task_ids , task_names);
        }
    }
}
function toSubmit(){
	if(!add && !modify){
		return;
	}
	var index = task_ids.indexOf(',');
	if(index!=-1){
		alert("多条作业不允许修改");
		return;
	}
	if(window.confirm('你确定保存所修改的内容吗?')){
		var value = document.getElementById("name").value;
		var tr = document.getElementById("checkTable").rows[modifyIndex];
		var summary_id = tr.cells[0].firstChild.value;
		var str = "object_id=" + id + "&object_name=" + name +"&task_id=" + task_ids + "&task_name=" + task_names;
		str = str + "&summarier=" + document.getElementById("summarier").value;
		str = str + "&summary_date=" + document.getElementById("summary_date").value;
		str = str + "&check_date=" + document.getElementById("check_date").value;
		var submitStr =str +  "&summary_id=" + summary_id + "&record_name=" + value;
		var retObj = jcdpCallService("QualitySrv", "saveCheckTable", submitStr);
		if(retObj.returnCode=='0'){
			var tr = document.getElementById("checkTable").rows[modifyIndex];
			tr.cells[2].innerHTML = value;
		}
		modify = false;
		add = false;
		modifyIndex = 0;
		cleanTables();
		showSummaryTable(id , name , task_ids , task_names);
    }
}
function selectOrgHR(select_type , select_id , select_name){
    var teamInfo = {
        fkValue:"",
        value:""
    };
    window.showModalDialog(cruConfig.contextPath+'/common/selectOrgHR.jsp?select='+select_type,teamInfo);
    if(teamInfo.fkValue!=""){
        document.getElementById(select_id).value = teamInfo.fkValue;
        document.getElementById(select_name).value = teamInfo.value;
    }
}