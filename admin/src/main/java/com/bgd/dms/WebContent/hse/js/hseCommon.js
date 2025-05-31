//选择多项目的时候，查询列表的条件   单位：second_org   基层单位：third_org  下属单位： fourth_org
function getMultipleSql(paramName){
	var paramName = paramName ? paramName : "";
	retObj = jcdpCallService("HseSrv", "queryOrg", "");
	var sql = "";
	if(retObj.flag!="false"){
		var len = retObj.list.length;
		if(len>0){
			if(retObj.list[0].organFlag!="0"){
				sql = " and "+paramName+"second_org = '" + retObj.list[0].orgSubId +"'";
				if(len>1){
					if(retObj.list[1].organFlag!="0"){
						sql = " and "+paramName+"third_org = '" + retObj.list[1].orgSubId +"'";
						if(len>2){
							if(retObj.list[2].organFlag!="0"){
								sql = " and "+paramName+"fourth_org = '" + retObj.list[2].orgSubId +"'";
							}
						}
					}
				}
			}
		}
	}
    return sql;
}

//申做的 ，单位：org_sub_id   基层单位：second_org  下属单位： third_org
function getMultipleSql2(paramName){
	var paramName = paramName ? paramName : "";
	retObj = jcdpCallService("HseSrv", "queryOrg", "");
	var sql = "";
	if(retObj.flag!="false"){
		var len = retObj.list.length;
		if(len>0){
			if(retObj.list[0].organFlag!="0"){
				sql = " and "+paramName+"org_sub_id = '" + retObj.list[0].orgSubId +"'";
				if(len>1){
					if(retObj.list[1].organFlag!="0"){
						sql = " and "+paramName+"second_org = '" + retObj.list[1].orgSubId +"'";
						if(len>2){
							if(retObj.list[2].organFlag!="0"){
								sql = " and "+paramName+"third_org = '" + retObj.list[2].orgSubId +"'";
							}
						}
					}
				}
			}
		}
	}
    return sql;
}


//绩效考核   -----------------单位，基层单位，下属单位不是创建人的
function getMultipleSql3(paramName,org_subjection_id){
	var paramName = paramName ? paramName : "";
	var org_subjection_id = org_subjection_id ? org_subjection_id : "";
	retObj = jcdpCallService("HseSrv", "queryOrg", "");
	var sql = " and "+paramName+"org_subjection_id like '" +org_subjection_id+"%'";
	if(retObj.flag!="false"){
		var len = retObj.list.length;
		if(len>0){
			if(retObj.list[0].organFlag=="0"){
				sql = " and "+paramName+"org_subjection_id like 'C105%'";
			}else{
				if(len>1){
					if(retObj.list[1].organFlag=="0"){
						sql = " and "+paramName+"org_subjection_id like '" + retObj.list[0].orgSubId +"%'";
					}else{
						if(len>2){
							if(retObj.list[2].organFlag=="0"){
								sql = " and "+paramName+"org_subjection_id like '" + retObj.list[1].orgSubId +"%'";
							}
						}
					}
				}
			}
		}
	}
    return sql;
}