/**
 * 根据项目类型加载班组
 * @param projectType
 * @return
 */
function loadApplyTeam(projectType){
	var selectObj = document.getElementById("s_apply_team"); 
	document.getElementById("s_apply_team").innerHTML="";
	selectObj.add(new Option('请选择',""),0);
	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","projectType="+projectType);
	if(null==applyTeamList.detailInfo)return;
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		selectObj.add(new Option(templateMap.label,templateMap.value),i+1);
	}   	
	var selectObj1 = document.getElementById("s_post");
	document.getElementById("s_post").innerHTML="";
	selectObj1.add(new Option('请选择',""),0);
}

/**
 * 选中已选班组
 * @param selectValue
 * @return
 */
function getApplyTeam(selectValue){
	var applyTeamList=jcdpCallService("HumanCommInfoSrv","queryApplyTeamP","projectType="+projectType);	
	var applypost_str='<option value="">请选择</option>';
	if(null==applyTeamList.detailInfo)return;
	for(var i=0;i<applyTeamList.detailInfo.length;i++){
		var templateMap = applyTeamList.detailInfo[i];
		//选择当前班组
		if(templateMap.value == selectValue || templateMap.label == selectValue){
			applypost_str+='<option value="'+templateMap.value+'" selected="selected" >'+templateMap.label+'</option>';			
		}else{
			applypost_str+='<option value="'+templateMap.value+'" >'+templateMap.label+'</option>';
		}
	}
	return applypost_str;
}

/**
 * 根据岗位值获得下拉框的值
 * @param apply_team,post
 * @return
 */
function getPostForList(apply_team,post){
	var applyTeam = "applyTeam="+apply_team;   
	content = encodeURI(applyTeam);
	content = encodeURI(applyTeam);
	var applyPost=jcdpCallService("HumanCommInfoSrv","queryApplyPostList",applyTeam);	
	if(null==applyPost.detailInfo)return;
	var apppost_str='<option value="">请选择</option>';
	for(var i=0;i<applyPost.detailInfo.length;i++){
		var templateMap = applyPost.detailInfo[i];
		if(templateMap.value == post || templateMap.label== post){
			apppost_str+='<option value="'+templateMap.value+'" selected="selected">'+templateMap.label+'</option>';
		}else{
			apppost_str+='<option value="'+templateMap.value+'"  >'+templateMap.label+'</option>';
		}
	}
	return apppost_str;
}