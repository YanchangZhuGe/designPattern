// JavaScript Document

/*** 判断字符是否为空 ***/
function strIsNullOrEmpty(str){
	if( str==undefined || str==null || str=="" || str=="null" ){
		return true ;
	}else{
		return false ;
	}
}

/***  根据项目编号获取项目类型**/
function getProjectTypeByProjectInfoNo(url,project_info_no){
	var project_type = "";
	if( !strIsNullOrEmpty(project_info_no)&&!strIsNullOrEmpty(url) ){
/*		
		$.post(url, { "project_info_no": project_info_no },function(data){
			project_type = data.project_type;  alert("11111  "+project_type);
		},"json");
*/
		$.ajax({
			   type: "POST",
			   url: url,
			   async: false,
			   data: "project_info_no="+project_info_no,
			   success: function(msg){
				 project_type = msg.project_type ;	// alert( "33333 " + project_type );
			    
			   }
			});
	}			//alert("22222 "+project_type);
	return project_type;	
}