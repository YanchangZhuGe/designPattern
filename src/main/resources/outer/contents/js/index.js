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

// 按钮个数
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

// 获取链接列表-文件
function getContentList(url, refresh) {
    let list = [];
    // 判断浏览器是否支持
    if (typeof (Storage) !== "undefined") {
        // 强制刷新或首次加载
        if ("ForceRefresh" == refresh || isNull(localStorage.getItem("urlIDS"))) {
            // 同步执行
            $.ajaxSettings.async = false;
            $.getJSON(url, function (res) {
                let ids = [];
                res.data.forEach(e => {
                    ids.push(e.id)
                    // 存入浏览器缓存
                    localStorage.setItem(e.id, JSON.stringify(e));
                });
                // 保存全量id
                localStorage.setItem("urlIDS", ids.toString());
            });
        }
    } else {
        document.getElementById("app").innerHTML = "Sorry, your browser does not support Web Storage...";
    }
    // 从缓存取出数据
    let idArr = localStorage.getItem("urlIDS").split(",");
    idArr.forEach(e => {
        list.push(JSON.parse(localStorage.getItem(e)));
    })
    return list;
}