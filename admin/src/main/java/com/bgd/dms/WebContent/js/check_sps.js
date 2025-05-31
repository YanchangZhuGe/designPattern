/**
* 功能：判断上传的sps文件是不是和需要的文件类型匹配，如需要s文件，则检查上传的是不是s文件
* 
* 参数：f_name 文件框的id，f_type 要检查文件的类型(文件类型用大写字母表示"S",如要检查是S文件还是R文件)
*
* 作者：马祥
*
* 时间：2008-3-13
*/
function checkSps(f_name,f_type){
	// 获得文件框对象
	var obj = document.getElementById(f_name);

	// 获得文件框对象的值
	var obj_value = obj.value;

	// 如果文件框内没有信息,不进行验证
	if("" == obj_value){
		return true;
	}
	
	// 按照 "." 拆分文件名
	var file_names = obj_value.split(".");
	
	// 如果文件有后缀名
	if(file_names.length > 1){
		// 获得按 "." 拆分文件名后的数组长度
		var file_name_length = file_names.length;

		// 获得文件的后缀名，并且转换为大写字母（获取数组的最后一位值）
		var file_postfix = file_names[file_name_length - 1].toUpperCase();
		
		// 如果文件的后缀名的长度超过1，获得该后缀名的第一个字母
		if(file_postfix.length > 1){
			file_postfix = file_postfix.substring(0,1);
		}
		
		// 如果文件类型和文件的后缀名相匹配，返回 true
		if(f_type == file_postfix){
			return true;
		// 如果文件类型和文件的后缀名不匹配，返回 false
		}else{
			alert(f_type + "文件上传的类型不匹配,请重新上传!");

			return false;
		}
	// 如果文件没有后缀名,认为此文件是不合法的
	}else{
		alert(f_type + "文件上传的类型不匹配,请重新上传!");

		return false;
	}
}