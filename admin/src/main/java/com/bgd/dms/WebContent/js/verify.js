//判断是否为0-100之间而且最多两位小数的数
function isRatio4_2(textPropertyName,hintname){
	var reg = /^[0-9]{0,3}(\.[0-9]{1,2})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
 
  if( (temp[0].value>=0) && (temp[0].value<=100) && reg.test(temp[0].value) ) return true;
  else{
   alert(hintname+'应为0到100之间而且最多两位小数的百分数！');
   return false;	
  }
}

//判断必填项是否为空
function isTextPropertyNotNull(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);

  if(Trim(temp[0].value)!=""){
  	return true;
  }else{   
   alert(hintname+'不能为空！');
   return false;	
  }	
}  

function Trim(str) {
 	return str.replace(/(^\s*)|(\s*$)/g,"");
} 

//只能输入1-20个由字母、数字、“-”组成的字符串 
function isWordsNumber20(textPropertyName,hintname)   
{   
	var patrn=/^([a-zA-Z0-9]|[-]){0,19}$/;
	var temp=document.getElementsByName(textPropertyName);
	   
	if (!patrn.exec(temp[0].value)){
		
			alert(hintname+'应为1-20个由字母、数字、“-”组成的字符串！');
		 	return false;  
		}
	else{
			return true ;
	} 
} 

//只能输入1-31个由字母、数字、“-”组成的字符串 
function isWordsNumber31(textPropertyName,hintname)   
{   
	var patrn=/^([a-zA-Z0-9]|[-]){0,31}$/;
	var temp=document.getElementsByName(textPropertyName);
	   
	if (!patrn.exec(temp[0].value)){
		
			alert(hintname+'应为1-32个由字母、数字、“-”组成的字符串！');
		 	return false;  
		}
	else{
			return true ;
	} 
}

//判断是否为0-1之间的数
function isRatio1(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if( (temp[0].value>=0) && (temp[0].value<=1)) return true;
  else{
   alert(hintname+'应为0到1之间！');
   return false;	
  }
}

//判断是否为0-100之间的数
function isRatio(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if( (temp[0].value>=0) && (temp[0].value<=100)) return true;
  else{
   alert(hintname+' 应为0到100之间！');
   return false;	
  }
}

//判断是否为0-180之间的数
function isRatio180(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if( (temp[0].value>=0.0000000000) && (temp[0].value<=180.0000000000)) return true;
  else{
   alert(hintname+' 应为0到180之间！');
   return false;	
  }
}

//输入NUMBER(6,4)的浮点数
function isValidFloatProperty6_4(textPropertyName,hintname){
  var reg = /^[0-9]{0,2}(\.[0-9]{1,4})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为保留4位小数的浮点数其整数部分至多为2位！');
   return false;	
  }
}

//输入NUMBER(7,4)的浮点数
function isValidFloatProperty7_4(textPropertyName,hintname){
  var reg = /^[0-9]{0,3}(\.[0-9]{1,4})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为保留4位小数的浮点数其整数部分至多为3位！');
   return false;	
  }
}

//输入NUMBER(12,9)的浮点数
function isValidFloatProperty12_9(textPropertyName,hintname){
  var reg = /^[0-9]{0,3}(\.[0-9]{1,9})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分最多3位、小数部分最多9位的浮点数！');
   return false;	
  }
}

//判断输入是否为0-20个字符之间
function isLimitB20(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 20)) return true;
  else{
   alert(hintname+'应为0到20个字符之间(一个中文字占两个字符)！');
   return false;	
  }
}

//判断输入是否为0-32个字符之间
function isLimitB32(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 32)) return true;
  else{
   alert(hintname+'应为0到32个字符之间(一个中文字占两个字符)！');
   return false;	
  }
}

//判断输入是否为0-35个字符之间
function isLimitB35(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 35)) return true;
  else{
   alert(hintname+'应为0到35个字符之间(一个中文字占两个字符)！');
   return false;	
  }
}

//判断输入是否为0-40个字符之间
function isLimitB40(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 40)) return true;
  else{
   alert(hintname+'应为0到40个字符之间(一个中文字占两个字符)！');
   return false;	
  }
}

//判断输入是否为0-50个字符之间
function isLimitB50(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 50)) return true;
  else{
   alert(hintname+'应为0到50个字符之间(一个中文字占两个字符)！');
   return false;	
  }
}

//判断输入是否为0-70个字符之间
function isLimitB70(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 70)) return true;
  else{
   alert(hintname+'应为0到70个字符之间(一个中文字占两个字符)！');
   return false;	
  }
}

//判断输入是否为0-100个字符之间
function isLimitB100(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 100)) return true;
  else{
   alert(hintname+'应为0到100个字符之间(一个中文字占两个字符)！');
   return false;	
  }
}

//判断输入是否为0-200个字符之间
function isLimitB200(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 200)) return true;
  else{
   alert(hintname+'应为0到200个字符之间(一个中文字占两个字符)！');
   return false;	
  }
}

//判断输入是否为0-255个字符之间
function isLimitB255(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 255)) return true;
  else{
   alert(hintname+'应为0到255个字符之间(一个中文字占两个字符)！');
   return false;	
  }
}

//判断输入是否为0-300个字符之间
function isLimitB300(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 300)) return true;
  else{
   alert(hintname+'应为0到300个字符之间(一个中文字占2个字符)！');
   return false;	
  }
}

//判断输入是否为0-500个字符之间
function isLimitB500(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 500)) return true;
  else{
   alert(hintname+'应为0到500个字符之间(一个中文字占两个字符)！');
   return false;	
  }
}

//判断输入是否为0-1000个字符之间
function isLimitB1000(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 1000)) return true;
  else{
   alert(hintname+'应为0到1000个字符之间(一个中文字占两个字符)！');
   return false;	
  }
}

//判断输入是否为0-2000个字符之间
function isLimitB2000(textPropertyName,hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  LenB = temp[0].value.replace(/[^\x00-\xff]/g,"**").length;
  if( (LenB >= 0) && (LenB <= 2000)) return true;
  else{
   alert(hintname+'应为0到2000个字符之间(一个中文字占2个字符)！');
   return false;	
  }
}


//输入NUMBER(7,2)的浮点数
function isValidFloatProperty7_2(textPropertyName,hintname){
  var reg = /^[0-9]{0,5}(\.[0-9]{1,2})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分最多5位、小数部分最多2位的浮点数！');
   return false;	
  }
}

//输入NUMBER(8,2)的浮点数
function isValidFloatProperty8_2(textPropertyName,hintname){
  var reg = /^[0-9]{0,6}(\.[0-9]{1,2})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分最多6位、小数部分最多2位的浮点数！');
   return false;	
  }
}

//验证X坐标
function isValidFloatPropertyX(textPropertyName,hintname){
  var reg1 = /^[0-9]{6}(\.[0-9]{1,2})?$/;
  var reg2 = /^[0-9]{8}(\.[0-9]{1,2})?$/;  
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg1.test(temp[0].value)||reg2.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分为6或8位、小数部分最多2位的浮点数！');
   return false;	
  }
}

//验证Y坐标
function isValidFloatPropertyY(textPropertyName,hintname){
  var reg = /^[0-9]{7}(\.[0-9]{1,2})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分7位、小数部分最多2位的浮点数！');
   return false;	
  }
}

//输入NUMBER(9,2)的浮点数
function isValidFloatProperty9_2(textPropertyName,hintname){
  var reg = /^[0-9]{0,7}(\.[0-9]{1,2})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分最多7位、小数部分最多2位的浮点数！');
   return false;	
  }
}

//输入NUMBER(10,2)的浮点数
function isValidFloatProperty10_2(textPropertyName,hintname){
  var reg = /^[0-9]{0,8}(\.[0-9]{1,2})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分最多8位、小数部分最多2位的浮点数！');
   return false;	
  }
}

//输入NUMBER(12,2)的浮点数
function isValidFloatProperty12_2(textPropertyName,hintname){
  var reg = /^[0-9]{0,10}(\.[0-9]{1,2})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分最多10位、小数部分最多2位的浮点数！');
   return false;	
  }
}

//输入NUMBER(16,2)的浮点数
function isValidFloatProperty16_2(textPropertyName,hintname){
  var reg = /^[0-9]{0,13}(\.[0-9]{1,2})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分最多14位、小数部分最多2位的浮点数！');
   return false;	
  }
}

//输入NUMBER(17,2)的浮点数
function isValidFloatProperty17_2(textPropertyName,hintname){
  var reg = /^[0-9]{0,15}(\.[0-9]{1,2})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分最多15位、小数部分最多2位的浮点数！');
   return false;	
  }
}

//输入NUMBER(20,2)的浮点数
function isValidFloatProperty20_2(textPropertyName,hintname){
  var reg = /^[0-9]{0,18}(\.[0-9]{1,2})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分最多18位、小数部分最多2位的浮点数！');
   return false;	
  }
}

//输入NUMBER(7,0)的浮点数
function isValidFloatProperty7_0(textPropertyName,hintname){
  var reg = /^[0-9]{0,7}$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为7位之内的整数！');
   return false;	
  }
}

//输入NUMBER(8,0)的浮点数
function isValidFloatProperty8_0(textPropertyName,hintname){
  var reg = /^[0-9]{0,8}$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为8位之内的整数！');
   return false;	
  }
}

//输入NUMBER(10,0)的浮点数
function isValidFloatProperty10_0(textPropertyName,hintname){
  var reg = /^[0-9]{0,10}$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为10位之内的整数！');
   return false;	
  }
}

//输入NUMBER(12,0)的浮点数
function isValidFloatProperty12_0(textPropertyName,hintname){
  var reg = /^[0-9]{0,12}$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为12位之内的整数！');
   return false;	
  }
}

//输入NUMBER(12,2)的浮点数
function isValidFloatProperty12_2(textPropertyName,hintname){
  var reg = /^[0-9]{0,10}(\.[0-9]{1,2})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 应为整数部分最多10位、小数部分最多两位的浮点数！');
   return false;	
  }
}

//输入NUMBER(20,0)的浮点数
function isValidFloatProperty20_0(textPropertyName,hintname){
  var reg = /^[0-9]{0,19}$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为19位之内的整数！');
   return false;	
  }
}


//另一种格式的验证日期/
function isValidDateProperty2(textPropertyName,hintname){
  var reg = /^[1-2]\d{3}\/[0-1]\d\/[0-3]\d$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;    
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的日期类型!');
   return false;	
  }	
}	

//另一种格式的验证日期-
function isValidDateProperty(textPropertyName,hintname){
  var reg = /^[1-2]\d{3}-[0-1]\d-[0-3]\d$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;    
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的日期类型!');
   return false;	
  }	
}	

function isValidMonthProperty(textPropertyName,hintname){
  var reg = /^[1-2]\d{3}-[0-1]\d$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;    
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的日期类型!');
   return false;	
  }	
}

function isValidDatePropertyNotNull(textPropertyName,hintname){
  var reg = /^[1-2]\d{3}-[0-1]\d-[0-3]\d$/;
  var temp=document.getElementsByName(textPropertyName);
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的日期类型!');
   return false;	
  }	
}	

function isValidTimePropertyNotNull(textPropertyName,hintname){
  var reg = /^[0-2]\d:[0-5]\d:[0-5]\d$/;
  var temp=document.getElementsByName(textPropertyName);
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的日期类型(HH:MI:SS)!');
   return false;	
  }	
}	

function isValidIntProperty(textPropertyName,hintname){
  var reg = /^[0-9]\d{0,5}$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的整数类型！');
   return false;	
  }
}	

function isValidAllIntProperty(textPropertyName,hintname){
  var reg = /^(-{0,1})[0-9]\d{0,5}$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的整数类型！');
   return false;	
  }
}

function isValidLenScope(textPropertyName, len, hintname){
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(temp[0].value.length < len) return true;
  else{
   alert(hintname+' 不是合法的整数类型！');
   return false;	
  }
}

function isValidIntPropertyNotnull(textPropertyName,hintname){
  var reg = /^[0-9]\d{0,5}$/;
  var temp=document.getElementsByName(textPropertyName);
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的整数类型！');
   return false;	
  }
}	

function isValidAllIntPropertyNotnull(textPropertyName,hintname){
  var reg = /^(-{0,1})[0-9]\d{0,5}$/;
  var temp=document.getElementsByName(textPropertyName);
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的整数类型！');
   return false;	
  }
}	


function isValidFloatProperty(textPropertyName,hintname){
  var reg = /^([1-9]\d{0,5}(.\d{1,8}){0,1})|(0.\d{1,8})$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的浮点数类型！');
   return false;	
  }
}

function isValidFloatPropertyNotnull(textPropertyName,hintname){
  var reg = /^([1-9]\d{0,5}(.\d{1,8}){0,1})|(0.\d{1,8})$/;
  var temp=document.getElementsByName(textPropertyName);
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的浮点数类型！');
   return false;	
  }
}

function isValidAllFloatProperty(textPropertyName,hintname){
  var reg = /^((-{0,1})[1-9]\d{0,5}(.\d{1,8}){0,1})|((-{0,1})0.\d{1,8})$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的浮点数类型！');
   return false;	
  }
}

function isValidAllFloatPropertyNotnull(textPropertyName,hintname){
  var reg = /^((-{0,1})[1-9]\d{0,5}(.\d{1,8}){0,1})|((-{0,1})0.\d{1,8})$/;
  var temp=document.getElementsByName(textPropertyName);
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的浮点数类型！');
   return false;	
  }
}		

function verifyOpCode(caty,opcode){
  if(caty=='Mob/Demob'){
    return opcode.indexOf('MD_')==0;	
  }	
  if(caty=='Acquisition'){
    return opcode.indexOf('AC_')==0;	
  }
  if(caty=='StandBy'){
    return opcode.indexOf('SB_')==0;	
  }	
  if(caty=='DownTime'){
    return opcode.indexOf('DT_')==0;	
  }	  	  
}

function checkStartEndDate(sDate, eDate, sDateName, eDateName) {
   var startDate = document.getElementById(sDate).value;
   var endDate = document.getElementById(eDate).value;
   
   //将输入的日期字符串分隔成3部分 (Month, Day & Year)
   if (startDate == "") {
       alert("未输入" + sDateName);
       return false;
   }
   else {
       sSize = startDate.length;
       sIdxBarI = startDate.indexOf("-");
       sIdxBarII= startDate.lastIndexOf("-");
       sStrY = startDate.substring(0,sIdxBarI);
       sStrM = startDate.substring(sIdxBarI+1,sIdxBarII);
       sStrD = startDate.substring(sIdxBarII+1,sSize);
   }
   
   
   if (endDate == "") {
        alert("未输入" + eDateName);
        return false;
   }
   else {
       eSize = endDate.length;
       eIdxBarI = endDate.indexOf("-");
       eIdxBarII= endDate.lastIndexOf("-");
       eStrY = endDate.substring(0,eIdxBarI);
       eStrM = endDate.substring(eIdxBarI+1,eIdxBarII);
       eStrD = endDate.substring(eIdxBarII+1,eSize);
   }
   

   var rValue = 0 ;
    
    for(var i=0 ;i<16 ;i++) {
      if(startDate.charAt(i) < endDate.charAt(i)) {
        rValue = 1 ;
        break ;
      }
      else if(startDate.charAt(i) > endDate.charAt(i)) {
        rValue = -1 ;
        break ;
      }
    }

    if(rValue == -1){
      alert("时间选择错误,请检查！！");
			return false;
    }
   
		return true;

}


function isValidYearProperty(textPropertyName,hintname){
  var reg = /^[1-2]\d{3}$/;
  var temp=document.getElementsByName(textPropertyName);
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+' 不是合法的时间类型！');
   return false;	
  }
}	

//输入NUMBER(13,3)的浮点数
function isValidFloatProperty13_3(textPropertyName,hintname){
  var reg = /^[0-9]{0,10}(\.[0-9]{1,3})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分最多10位、小数部分最多3位的浮点数！');
   return false;	
  }
}

//输入NUMBER(8,3)的浮点数
function isValidFloatProperty8_3(textPropertyName,hintname){
  var reg = /^[0-9]{0,5}(\.[0-9]{1,3})?$/;
  var temp=document.getElementsByName(textPropertyName);
  if(temp[0].value=='') return true;  
  if(reg.test(temp[0].value)) return true;
  else{
   alert(hintname+'应为整数部分最多5位、小数部分最多3位的浮点数！');
   return false;	
  }
}

/*检查日期是否在今天之前*/
function checkDateBeforeToday(checkDate){

	if(checkDate == null || checkDate == ""){
	    return false;
	}

	var curDate = new Date();
	var date1 = checkDate;
	var date2 = curDate.getFullYear()+"-"+(curDate.getMonth()+1)+"-"+curDate.getDate();
	
	var reg = new RegExp("-","g"); //创建正则RegExp对象       

	date1= date1.replace(reg,"\/");
	date2= date2.replace(reg,"\/");
	
	var startMilliseconds = Date.parse(date1);//startDate.getTime();
	var endMilliseconds = Date.parse(date2);//endDate.getTime();

	if(startMilliseconds<endMilliseconds){
		return true;
	}
	return false;
}
