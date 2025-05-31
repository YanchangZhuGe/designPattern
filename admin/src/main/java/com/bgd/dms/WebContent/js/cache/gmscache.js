
//定义gmsCache对象
function gmsCache(isCache,time){
	this._isCache=isCache;
	this._millSecond=time;
}


//获取缓存中的值
gmsCache.prototype.get=function(key,reload){
	var _value=$.jStorage.get(key);
	if(!_value){
		_value=reload();
		$.jStorage.set(key, _value, {TTL:this._millSecond});
	}
	return _value;
};
//设置缓存中的值
gmsCache.prototype.set=function(key,value,millSecond){
	$.jStorage.set(key, value, {TTL:millSecond});
};
//删除缓存中的值
gmsCache.prototype.remove=function(key){
	$.jStorage.deleteKey(key);
};


var gmsCache=new gmsCache(true,1000*60*60*24);
