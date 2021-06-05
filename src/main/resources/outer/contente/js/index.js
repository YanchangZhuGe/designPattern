// 工具函数
// 空值判断
function isNull(value) {
	if (value == undefined || value == null || value == "" ||
		value == "undefined" || value == "null") {
		return true;
	} else {
		return false;
	}
}

// 根据指定个数分割数组
function chunkArr(arr, size) {
	//判断如果不是数组(就没有length)，或者size没有传值，size小于1，就返回空数组
	if (!arr.length || !size || size < 1) {
		return [];
	}
	let start = null;
	let end = null;
	let result = [];

	for (let i = 0; i < Math.ceil(arr.length / size); i++) {
		start = i * size
		end = start + size

		let map = {};
		map.id = i;
		map.data = arr.slice(start, end);

		result.push(map)
	}
	return result
}

//按钮个数
function getNumList(start, end) {
	if (!start || !end || start < 1 || end < 1 || start > end) {
		return [];
	}

	let result = [];
	for (let i = start; i <= end; i++) {
		let map = {};
		map.value = i;
		map.label = i;

		result.push(map);
	}
	return result
}
