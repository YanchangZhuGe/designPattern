var contextPath =  getContextPath();

function refreshData(){
	
	var retObj = jcdpCallService("HseOperationSrv", "getEvaluationStaff", "hse_evaluation_id="+hse_evaluation_id);
	if(retObj.returnCode =='0'){
		if(retObj.datas!=null){
			for(var i =0;i<retObj.datas.length;i++){
				var data = retObj.datas[i];
				debugger;
				var autoOrder = document.getElementById("staff").rows.length-2;
				/*if(autoOrder >5){
					var tr = document.getElementById("staff").rows[autoOrder-1];
					var hse_evaluation_staff = tr.cells[0].children[0].value;
					var staff_name = tr.cells[0].children[1].value;
					tr.cells[0].innerHTML = "<input type='hidden' name='hse_evaluation_staff' class='input_width' value='"+hse_evaluation_staff+"'/>"+
					"<input type='text' name='staff_name' class='input_width' value ='"+staff_name+"'/>"
				}*/
				var hse_evaluation_staff = data.hse_evaluation_staff;
				var staff_name = data.staff_name;
				var newTR = document.getElementById("staff").insertRow(autoOrder);
			    var td = newTR.insertCell(0);
			    td.innerHTML = "<input type='hidden' name='hse_evaluation_staff' value='"+hse_evaluation_staff+"' class='input_width'/>"+
					"<input type='text' name='staff_name' class='input_width' value='"+staff_name+"'/>"+
					"<img src='"+contextPath+"/images/magnifier.gif' width='16' height='16' style='cursor:hand' onclick='selectOrg3()'/>";
			    
			    var staff_position = data.staff_position;
			    td = newTR.insertCell(1);
			    td.innerHTML = "<input name='staff_position'  type='text' value='"+staff_position+"' class='input_width'/>";
			    
			    var staff_health = data.staff_health;
			    td = newTR.insertCell(2);
			    td.innerHTML = "<input name='staff_health' type='text' value='"+staff_health+"' class='input_width'/>";
			    
			    var constraindication = data.constraindication;
			    td = newTR.insertCell(3);
			    td.innerHTML = "<input name='constraindication'  type='text'  value='"+constraindication+"' class='input_width'/>";
			    
			    var degrees = data.degrees;
			    td = newTR.insertCell(4);
			    td.innerHTML = "<input name='degrees' type='text' value='"+degrees+"' class='input_width'/>";
			    
			    var work_experience = data.work_experience;
			    td = newTR.insertCell(5);
			    td.innerHTML = "<input name='work_experience' type='text' value='"+work_experience+"' class='input_width'/>";
			    
			    var interview = data.interview;
			    td = newTR.insertCell(6);
			    td.innerHTML = "<input name='interview' type='text'  value='"+interview+"' class='input_width'/>";
			    
			    var qualification = data.qualification;
			    td = newTR.insertCell(7);
			    td.innerHTML = "<input name='qualification' type='text' value='"+qualification+"' class='input_width'/>";
			    
			    var exam = data.exam;
			    td = newTR.insertCell(8);
			    td.innerHTML = "<input name='exam' type='text' value='"+exam+"' onkeydown='javascript:return checkIfNum(event);' onblur='checkNum(event)' class='input_width'/>";
			    
			    var subversion = data.subversion;
			    td = newTR.insertCell(9);
			    td.innerHTML = "<select name='subversion' class='select_width' ><option value='' >请选择</option>"+
					"<option value='1' >合格</option><option value='0' >不合格</option></select>";
			    var option = td.firstChild.options;
			    for(var j= 0;j<option.length ;j++){
			    	if(subversion == option[j].value){
			    		option[j].selected = true;
			    	}
			    }
			    var work_ethic = data.work_ethic;
				td = newTR.insertCell(10);
			    td.innerHTML = "<input name='work_ethic' type='text' value='"+work_ethic+"' class='input_width'/>";
			    
			    var emergency_power = data.emergency_power;
			    td = newTR.insertCell(11);
			    td.innerHTML = "<input name='emergency_power' type='text' value='"+emergency_power+"' class='input_width'/>";
			    
			    var competent = data.competent;
			    td = newTR.insertCell(12);
			    td.innerHTML = "<select name='competent' class='select_width' ><option value='' >请选择</option>"+
					"<option value='1' >√</option><option value='0' >X</option></select>";
			    option = td.firstChild.options;
			    for(var k= 0;k<option.length ;k++){
			    	if(competent == option[k].value){
			    		option[k].selected = true;
			    	}
			    }
			    
			    td = newTR.insertCell(13);
			    td.innerHTML = "<span class='sc'><a href='#' onclick='toDelete()'  title='删除'></a></span>";
			}
		}
	}
	
}
function addOne(name){
	var autoOrder = document.getElementById("staff").rows.length-2;
	/*if(autoOrder >5){
		var tr = document.getElementById("staff").rows[autoOrder-1];
		var hse_evaluation_staff = tr.cells[0].children[0].value;
		var staff_name = tr.cells[0].children[1].value;
		tr.cells[0].innerHTML = "<input type='hidden' name='hse_evaluation_staff' class='input_width' value='"+hse_evaluation_staff+"'/>"+
		"<input type='text' name='staff_name' class='input_width' value ='"+staff_name+"'/>"
	}*/
	
	var newTR = document.getElementById("staff").insertRow(autoOrder);
    var td = newTR.insertCell(0);
    td.innerHTML = "<input type='hidden' name='hse_evaluation_staff' class='input_width'/>"+
		"<input type='text' name='staff_name' class='input_width' value='"+name+"'/>"+
		"<img src='"+contextPath+"/images/magnifier.gif' width='16' height='16' style='cursor:hand' onclick='selectOrg3()'/>";
    
    td = newTR.insertCell(1);
    td.innerHTML = "<input name='staff_position'  type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(2);
    td.innerHTML = "<input name='staff_health' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(3);
    td.innerHTML = "<input name='constraindication'  type='text'  value='' class='input_width'/>";
    
    td = newTR.insertCell(4);
    td.innerHTML = "<input name='degrees' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(5);
    td.innerHTML = "<input name='work_experience' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(6);
    td.innerHTML = "<input name='interview' type='text'  value='' class='input_width'/>";
    
    td = newTR.insertCell(7);
    td.innerHTML = "<input name='qualification' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(8);
    td.innerHTML = "<input name='exam' type='text' value='' onkeydown='javascript:return checkIfNum(event);' onblur='checkNum(event)' class='input_width'/>";
    
    td = newTR.insertCell(9);
    td.innerHTML = "<select name='subversion' class='select_width' ><option value='' >请选择</option>"+
		"<option value='1' >合格</option><option value='0' >不合格</option></select>";

	td = newTR.insertCell(10);
    td.innerHTML = "<input name='work_ethic' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(11);
    td.innerHTML = "<input name='emergency_power' type='text' value='' class='input_width'/>";
    
    td = newTR.insertCell(12);
    td.innerHTML = "<select name='competent' class='select_width' ><option value='' >请选择</option>"+
		"<option value='1' >√</option><option value='0' >X</option></select>";
    
    td = newTR.insertCell(13);
    td.innerHTML = "<span class='sc'><a href='#' onclick='toDelete()'  title='删除'></a></span>";
    
}


function addOnes(staff_names,staff_positions,staff_healths,constraindications,degreess,work_experiences,interviews,qualifications,exams, subversions, work_ethics, emergency_powers, competents){
	var staff_name="";
	var staff_position="";
	var staff_health="";
	var constraindication="";
	var degrees="";
	var work_experience="";	
	var interview="";
	var qualification="";
	var exam="";
	var subversion="";
	var work_ethic="";
	var emergency_power="";
	var competent="";
	
	if(staff_names != null && staff_names != ""){
		staff_name =staff_names;
	}	
	if(staff_positions != null && staff_positions != ""){
		staff_position =staff_positions;
	}	
	if(staff_healths != null && staff_healths != ""){
		staff_health =staff_healths;
	}	
	if(constraindications != null && constraindications != ""){
		constraindication =constraindications;
	}	
	if(degreess != null && degreess != ""){
		degrees =degreess;
	}	
	if(work_experiences != null && work_experiences != ""){
		work_experience =work_experiences;
	}	
	if(interviews != null && interviews != ""){
		interview =interviews;
	}	
	
 
	if(qualifications != null && qualifications != ""){
		qualification =qualifications;
	}	
	if(exams != null && exams != ""){
		exam =exams;
	}	
	if(subversions != null && subversions != ""){
		subversion =subversions;
	}	
	
	if(work_ethics != null && work_ethics != ""){
		work_ethic =work_ethics;
	}	
	if(emergency_powers != null && emergency_powers != ""){
		emergency_power =emergency_powers;
	}	
	if(competents != null && competents != ""){
		competent =competents;
	}	
 
	
	var autoOrder = document.getElementById("staff").rows.length-2; 
	var newTR = document.getElementById("staff").insertRow(autoOrder);
    var td = newTR.insertCell(0);
    td.innerHTML = "<input type='hidden' name='hse_evaluation_staff' class='input_width'/>"+
		"<input type='text' name='staff_name' class='input_width' value='"+staff_name+"'/>"+
		"<img src='"+contextPath+"/images/magnifier.gif' width='16' height='16' style='cursor:hand' onclick='selectOrg3()'/>";
    
    td = newTR.insertCell(1);
    td.innerHTML = "<input name='staff_position'  type='text' value='"+staff_position+"' class='input_width'/>";
    
    td = newTR.insertCell(2);
    td.innerHTML = "<input name='staff_health' type='text' value='"+staff_health+"' class='input_width'/>";
    
    td = newTR.insertCell(3);
    td.innerHTML = "<input name='constraindication'  type='text'  value='"+constraindication+"' class='input_width'/>";
    
    td = newTR.insertCell(4);
    td.innerHTML = "<input name='degrees' type='text' value='"+degrees+"'  class='input_width'/>";
    
    td = newTR.insertCell(5);
    td.innerHTML = "<input name='work_experience' type='text' value='"+work_experience+"'  class='input_width'/>";
    
    td = newTR.insertCell(6);
    td.innerHTML = "<input name='interview' type='text'  value='"+interview+"'  class='input_width'/>";
    
    td = newTR.insertCell(7);
    td.innerHTML = "<input name='qualification' type='text' value='"+qualification+"'  class='input_width'/>";
    
    td = newTR.insertCell(8);
    td.innerHTML = "<input name='exam' type='text' value='"+exam+"'  onkeydown='javascript:return checkIfNum(event);' onblur='checkNum(event)' class='input_width'/>";
    
    if(subversion!="" && subversion!=null){
    	if(subversion=="合格"){
    	    td = newTR.insertCell(9);
    	    td.innerHTML = "<select name='subversion' class='select_width' ><option value='' >请选择</option>"+
    			"<option value='1' selected >合格</option><option value='0' >不合格</option></select>";
        }else if(subversion=="不合格"){
        	
            td = newTR.insertCell(9);
            td.innerHTML = "<select name='subversion' class='select_width' ><option value='' >请选择</option>"+
        		"<option value='1' >合格</option><option value='0' selected >不合格</option></select>";
        }
    	
    }else{    
    td = newTR.insertCell(9);
    td.innerHTML = "<select name='subversion' class='select_width' ><option value='' >请选择</option>"+
		"<option value='1' >合格</option><option value='0' >不合格</option></select>";

    }
	td = newTR.insertCell(10);
    td.innerHTML = "<input name='work_ethic' type='text' value='"+work_ethic+"'  class='input_width'/>";
    
    td = newTR.insertCell(11);
    td.innerHTML = "<input name='emergency_power' type='text' value='"+emergency_power+"'  class='input_width'/>";
    
    
    if(competent!="" && competent!=null){
    	if(competent=="√"){
    	    td = newTR.insertCell(12);
    	    td.innerHTML = "<select name='competent' class='select_width' ><option value='' >请选择</option>"+
    			"<option value='1' selected >√</option><option value='0' >X</option></select>";
    	    
        }else if(competent=="X"){
            td = newTR.insertCell(12);
            td.innerHTML = "<select name='competent' class='select_width' ><option value='' >请选择</option>"+
        		"<option value='1' >√</option><option value='0' selected >X</option></select>";
            
        }
    	
    }else{    
        td = newTR.insertCell(12);
        td.innerHTML = "<select name='competent' class='select_width' ><option value='' >请选择</option>"+
    		"<option value='1' >√</option><option value='0' >X</option></select>";
        
    }
     

    td = newTR.insertCell(13);
    td.innerHTML = "<span class='sc'><a href='#' onclick='toDelete()'  title='删除'></a></span>";
    
}





function toDelete(){
	var obj = event.srcElement.parentNode.parentNode.parentNode;
	var rowIndex = obj.rowIndex;
	var hse_evaluation_staff = obj.cells[0].firstChild.value;
	if(hse_evaluation_staff !=null && hse_evaluation_staff !=''){
		var sql = "update bgp_hse_evaluation_staff t set t.bsflag='1' where t.hse_evaluation_staff ='"+hse_evaluation_staff+"'"
		var retObj = jcdpCallService("HseOperationSrv", "saveEvaluationStaff", "sql="+sql);;
	}
	document.getElementById("staff").deleteRow(rowIndex);
}
/* 输入的是否是数字 */
function checkIfNum(event){
	var element = event.srcElement;
	if(element.value != null && element.value =='0' && (event.keyCode>=48 && event.keyCode<=57)){
		element.value = '';
	}
	if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode ==8 || event.keyCode ==37 || event.keyCode ==39 || event.keyCode ==9){
		return true;
	}
	else{
		return false;
	}
}
/* 输入的是否<70 */
function checkNum(event){
	var element = event.srcElement;
	if(element.tagName.toLowerCase() == 'input'){
	if(element.value != null && element.value !='' && element.value <'70'){
		var tr = element.parentNode.parentNode;
		var cell = tr.cells[12].firstChild;
		cell.options[2].selected =true;
	}
	}else if(element.tagName.toLowerCase() == 'select'){
		var tr = element.parentNode.parentNode;
		var value = tr.cells[8].value;
		if(value != null && value !='' && value <'70'){
			alert("理论考试低于70!");
			var cell = tr.cells[12].firstChild;
			cell.options[2].selected =true;
		}
	}
}
function checkText0(){
	var staff_org=document.getElementById("staff_org").value;
	var appraiser=document.getElementById("appraiser").value;
	var evaluation_date=document.getElementById("evaluation_date").value;
	if(staff_org==""){
		alert("单位不能为空，请填写！");
		return true;
	}
	if(appraiser==""){
		alert("评价人不能为空，请填写！");
		return true;
	}
	var obj = document.getElementById("staff");
	var autoOrder = obj.rows.length;
	var substr = "";
	debugger;
	var hse_evaluation_id = document.getElementById("hse_evaluation_id").value;
	var project_info_no = document.getElementById("project_info_no").value;
	var user_id = document.getElementById("user_id").value;
	for(var i =5 ; i< autoOrder-2 ;i++){
		var tr = document.getElementById("staff").rows[i];
		var hse_evaluation_staff = tr.cells[0].children[0].value;
		if(hse_evaluation_staff!=null && hse_evaluation_staff!=''){
			substr = substr + "update bgp_hse_evaluation_staff t set t.hse_evaluation_id ='"+hse_evaluation_id+"',t.staff_org ='"+staff_org+"' ," +
			" t.modifi_date =to_date('"+evaluation_date+"' ,'yyyy-MM-dd') ,t.staff_name ='?',"+
			" t.staff_position ='?' ,t.staff_health='?' ,t.constraindication='?',"+
			" t.degrees='?',t.work_experience='?',t.interview='?',t.qualification='?',"+
			" t.exam='?',t.subversion='?',t.work_ethic='?',t.emergency_power='?',"+
			" t.competent='?',t.project_info_no='"+project_info_no+"' where t.hse_evaluation_staff ='"+hse_evaluation_staff+"';"
		}else{
			substr = substr + "insert into bgp_hse_evaluation_staff(hse_evaluation_staff ,hse_evaluation_id ,staff_org ,staff_name ,"+
			" staff_position ,staff_health ,constraindication ,degrees ,work_experience ,interview ,qualification ,exam ,subversion ,"+
			" work_ethic ,emergency_power ,competent ,project_info_no ,bsflag ,create_date,creator_id ,modifi_date ,updator_id) "+
			" values((select lower(sys_guid()) from dual),'"+hse_evaluation_id+"' ,'"+staff_org+"' ,'?' ,'?' ,'?' ,'?' ,'?' ,'?' ,'?' ,'?' ,'?' ," +
			" '?' ,'?' ,'?' ,'?' ,'"+project_info_no+"' ,'0' ,sysdate ,'"+user_id+"' ,to_date('"+evaluation_date+"','yyyy-MM-dd') ,'"+user_id+"');"
		}
		var staff_name = tr.cells[0].children[1].value;
		if(staff_name==""){
			alert("姓名不能为空，请填写！");
			return true;
		}
		substr = substr.replace('?',staff_name);
		var staff_position = tr.cells[1].firstChild.value;
		substr = substr.replace('?',staff_position);
		var staff_health = tr.cells[2].firstChild.value;
		substr = substr.replace('?',staff_health);
		var constraindication = tr.cells[3].firstChild.value;
		substr = substr.replace('?',constraindication);
		var degrees = tr.cells[4].firstChild.value;
		substr = substr.replace('?',degrees);
		var work_experience = tr.cells[5].firstChild.value;
		substr = substr.replace('?',work_experience);
		var interview = tr.cells[6].firstChild.value;
		substr = substr.replace('?',interview);
		var qualification = tr.cells[7].firstChild.value;
		substr = substr.replace('?',qualification);
		var exam = tr.cells[8].firstChild.value;
		substr = substr.replace('?',exam);
		var subversion = tr.cells[9].firstChild.value;
		substr = substr.replace('?',subversion);
		var subversion = tr.cells[10].firstChild.value;
		substr = substr.replace('?',subversion);
		var emergency_power = tr.cells[11].firstChild.value;
		substr = substr.replace('?',emergency_power);
		var competent = tr.cells[12].firstChild.value;
		if(competent==""){
			alert("能否胜任不能为空，请填写！");
			return true;
		}
		substr = substr.replace('?',competent);
	}
	substr = substr + "update bgp_hse_evaluation t set t.appraiser ='"+appraiser+"' where t.hse_evaluation_id = '"+hse_evaluation_id+"'";
	var retObj = jcdpCallService("HseOperationSrv", "saveEvaluationStaff", "sql="+substr);
//	var dia = window.dialogArguments;
//	var par = window.parent.top.frames('list');
//	par.refreshData();
//	window.dialogArguments.refreshData();
//	window.dialogArguments.location=contextPath+"/hse/orgAndResource/staffEvaluation/evaluation_list.jsp?isProject="+isProject;
	window.close();
	return false;
}


