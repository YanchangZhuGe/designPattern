/*计量设备检测*/
	var checked = false;
	function check(){
		var chk = document.getElementsByName("chk_entity_id");
		for(var i = 0; i < chk.length; i++){ 
			if(!checked){ 
				chk[i].checked = true; 
			}
			else{
				chk[i].checked = false;
			}
		} 
		if(checked){
			checked = false;
		}
		else{
			checked = true;
		}
	}
	function getTab(obj,index) {
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
			j.style.display = "none";
		}
		document.getElementById(showContent).style.display = "block";
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
	/* 输入的是否是数字 */
	function checkIfNum(){
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
	/* 详细信息 */
	function loadDataDetail(){
		var obj = event.srcElement; 
    	if(obj.tagName.toLowerCase() == "td"){   
    		var   tr   =  obj.parentNode ;
    		tr.cells[0].firstChild.checked = true;
    	} 
	}
	function historyDetail(history_id){
		var retObj = jcdpCallService("QualityItemsSrv","getAndSaveHistory", "history_id="+history_id);
		if(retObj.returnCode =='0'){
			var map = retObj.historyMap;
			if(map!=null){
				document.getElementById("history_id").value =  map.history_id;
				document.getElementById("org_id").value = map.org_id;
				document.getElementById("org_name").value = map.org_name;
				document.getElementById("report_title").value = map.report_title;
				document.getElementById("report_date").value = map.report_date;
				document.getElementById("report_code").value = map.report_code;
				document.getElementById("report_maker").value = map.report_maker;
			}else{
				document.getElementById("history_id").value =  "";
				document.getElementById("org_id").value = "";
				document.getElementById("org_name").value = "";
				document.getElementById("report_title").value = "监视和测量设备台账";
				document.getElementById("report_date").value = "";
				document.getElementById("report_code").value = "BGP/Q/JL7.6-1";
				document.getElementById("report_maker").value = "";
			}
		}
	}
	function toAdd(){
		var history_id = document.getElementById("history_id").value;
		popWindow(cruConfig.contextPath+"/qua/sProject/quaFile/equipEdit.jsp?history_id="+history_id);
	}
	function toEdit(){
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var monitor_id = '';
		for (var i = objLen-1 ;i > 0 ; i--){
	    	if ( obj [i].checked == true) { 
	    		monitor_id=obj[i].value;
        		if(monitor_id != ''){
        			popWindow(cruConfig.contextPath+"/qua/sProject/quaFile/equipEdit.jsp?monitor_id=" + monitor_id);
        		}
        	}
        }
	}
	function toDelete(){
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var sql = '';
		if(window.confirm("您确定要删除?")){
			for (var i = objLen-2 ;i > 0 ; i--){
		    	if ( obj [i].checked == true) { 
		    		var monitor_id = obj[i].value;
	        		if(monitor_id != ''){
	        			sql = sql + "update bgp_qua_monitor_equipment t set t.bsflag='1' where t.monitor_id='"+monitor_id+"';";
	        		}
		        }
			}
			var retObj = jcdpCallService("QualityItemsSrv","saveQuality", "sql="+sql);
			if(retObj!=null && retObj.returnCode =='0'){
				alert("删除成功!");
				refreshData();
			}
		}
	}
	
	function refresh(){
		var equip_name = document.getElementById("equip_name").value;
		if(equip_name==null){
			equip_name = '';
		}
		cruConfig.submitStr = "&equip_name="+equip_name;
		setTabBoxHeight();
		queryData(1);
		historyDetail('');
	}
	function checkValue(){
		var obj = document.getElementById("report_title");
		var value = obj.value ;
		if(obj ==null || value==''){
			alert("填报标题不能为空!");
			return false;
		}
		obj = document.getElementById("report_date");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("填报日期不能为空!");
			return false;
		}
		obj = document.getElementById("report_code");
		value = obj.value ;
		if(obj ==null || value==''){
			alert("填报编号不能为空!");
			return false;
		}
		obj = document.getElementById("report_maker") ;
		value = obj.value ;
		if(obj ==null || value==''){
			alert("填写人不能为空!");
			return false;
		}
	}
	
	function changeTab2(history_id){
		window.location=cruConfig.contextPath+"/qua/sProject/quaFile/equipment.jsp?history_id="+history_id;
		window.parent.frames("fourthMenuFrame").getTab(window.parent.frames("fourthMenuFrame").document.getElementsByTagName("a")[1]);
	}
	/*质量分析会*/