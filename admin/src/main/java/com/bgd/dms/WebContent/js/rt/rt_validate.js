var vdInfo = new Array();
vdInfo['CT'] = [/^([\u0391-\uFFE5]|[A-Za-z]|[\d])+$/,'包含非法的文字输入!'];
vdInfo['D'] = [/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/,'日期格式非法!'];
vdInfo['EMAIL'] = [/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/,'Email格式非法!'];
vdInfo['ET'] = [/^[A-Za-z.]+$/,'包含非法的英文字符输入!'];
vdInfo['N'] = [/^[-\+]?\d+$/,'包含非法的整数输入!'];
vdInfo['NN'] = [/^[-\+]?\d+(\.\d+)?$/,'包含非法的数字输入!'];
vdInfo['TEXT'] = [/^([\u0391-\uFFE5]|[A-Za-z]|[\d])+$/,'包含非法的文字输入!'];
vdInfo['pswd'] = [/^([-`=\\\[\];',.\/~!@#$%^&*()_+|{}:"<>?]|[A-Za-z]|[\d])+$/,'包含非法的文字输入!'];

/**
	inFd:输入框对象
	fdType:数据类型，参考vdInfo数组定义
	用到了cruConfig.contextPath
*/
function isUniqueField(inFd,fdType){
	var fdValue = inFd.value+"";
	if(fdValue=="") return;
	
	fdValue = fdValue.replace(/\\/,"\\\\");	
	fdValue = encodeURI(fdValue);
	fdValue = encodeURI(fdValue);
	var submitStr = inFd.name+"="+fdValue;
	submitStr += "&JCDP_TABLE_NAME="+(fields[0][0]=="JCDP_TABLE_NAME" ? fields[0][5] : defaultTableName); 
	if(cruConfig.cruAction=='edit')
		submitStr += "&"+fields[1][0]+"="+fields[1][5];

	var path = cruConfig.contextPath+"/rad/isUniqueEntity.srq";
	var retObject = syncRequest('Post',path,submitStr);
	if (retObject.returnCode != "0") return;
	if(retObject.isUnique=='false'){
		alert(inFd.value+"已经存在!");
		inFd.focus();				
	}	
}

/**
  验证CRU的输入字段，提交前
*/
function cuValidate(inputObj,field){
	if(field[8]=='non-empty')
		if(inputObj.value==''||inputObj.value.length==0){
			if(field[2]=='Edit') inputObj.focus();
			alert("请输入"+field[1]+"!");
			return false;			
		}
	
	if(field[3]=='FK') return true;
	
	return commValidate(inputObj,field[3]);
}

function commValidate(inputObj,type){//alert(type);
	var value = inputObj.value;
		
	if(value==''||value.length==0) return true;
	if(type=='TEXT') return true;
	var reg = vdInfo[type][0];
	if(!reg.test(value)) {
		inputObj.focus();
		alert(vdInfo[type][1]);
		return false;
	}
	return true;	
}


function enTextValidate(input){
	var value = input.value;
		
	if(value==''||value.length==0) return true;
	var reg = /^[A-Za-z]+$/;
	if(!reg.test(value)) {
		input.focus();
		alert('包含非法的英文字符输入!');
		return false;
	}
	return true;
}

function intValidate(input,outPuts){
	var value = input.value;
		
	if(value==''||value.length==0) return true;
	var reg = /^[-\+]?\d+$/;
	if(!reg.test(value)) {
		input.focus();
		//alert(outPuts);
		if(outPuts==undefined){
			alert('包含非法的整数输入!');
		}else{
			alert(outPuts);
		}
		return false;
	}
	return true;
}

function doubleValidate(input){
	var value = input.value;
		
	if(value==''||value.length==0) return true;
	var reg = /^[-\+]?\d+(\.\d+)?$/;
	if(!reg.test(value)) {
		input.focus();
		alert('包含非法的数字输入!');
		return false;
	}
	return true;
}

function validateBusiCsst(funcCode,ids,hint){
	var ret = false;
	var submitStr = "ids="+ids+"&funcCode="+funcCode;
	var returnObj = jcdpCallService("IBPAuthEntitySrv","validateBusiCsst",submitStr);
	if(returnObj.returnCode!="0"){
		alert(returnObj.returnMsg);
	}
	else {
		if(returnObj.validateRet=='false'){
			alert(returnObj.validateMsg);
		}
		else ret =true;
	}
	return ret;
}

function makeCallThis(phone){   
	   var flag = false;   
	   var reg0 =  /^(([0\+]\d{2,3}-)?(0\d{2,3})-)?(\d{7,8})(-(\d{3,}))?$/;   //判断 固话   
	   var reg1 =/^((\(\d{2,3}\))|(\d{3}\-))?(13|15|18)\d{9}$/;                     //判断 手机   
	   if (reg0.test(phone)) flag=true;    
	   if (reg1.test(phone)) flag=true;    
	   if(!flag){   
	    alert("电话号码格式不对！请正确输入");
	    return false;
	   }else{   
	    return true;  
	   }
	   
} 