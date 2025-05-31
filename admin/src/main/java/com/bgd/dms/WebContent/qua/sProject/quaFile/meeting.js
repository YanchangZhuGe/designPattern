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
	function clearQueryText(){
		document.getElementById("name").value = '';
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
			alert("只能输入数字");
			return false;
		}
	}
	function selectOrgHR(select_type , select_id , select_name){
	    var teamInfo = {
	        fkValue:"",
	        value:""
	    };
	    window.showModalDialog(cruConfig.contextPath+'/qua/common/evaluation_tree.jsp?select='+select_type,teamInfo);
	    if(teamInfo.fkValue!=""){
	        document.getElementById(select_id).value = teamInfo.fkValue;
	        document.getElementById(select_name).value = teamInfo.value;
	    }
	}
	
	/* 修改 */
	function toAdd() {
		popWindow(cruConfig.contextPath+"/qua/sProject/quaFile/meetingEdit.jsp");
	}
	function toEdit() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var report_id = '';
		if(window.confirm("你确定要修改吗?")){
			for (var i = 0;i< objLen ;i++){   
				if (obj [i].checked==true) { 
					report_id=obj [i].value;
					popWindow(cruConfig.contextPath+"/qua/sProject/quaFile/meetingEdit.jsp?report_id="+report_id);
					return;
				}
			}
		} 
		alert("请选择修改的记录!")
	}
	function toDel() {
		var obj = document.getElementsByName("chk_entity_id");
		var objLen= obj.length; 
		var report_id = '';
		if(window.confirm("你确定要删除吗?")){
			var sql = "";
			for (var i = objLen-2;i>0;i--){   
				if (obj [i].checked==true) { 
					report_id=obj [i].value;
					sql =" update bgp_qua_meeting_report t set t.bsflag='1' where t.report_id='"+report_id+"';";
				}   
			} 
			var retObj = jcdpCallService("QualitySrv", "saveQualityBySql", "sql="+sql);
			if(retObj!=null && retObj.returnCode=='0'){
				refreshData();
			}
		}
		
	}
