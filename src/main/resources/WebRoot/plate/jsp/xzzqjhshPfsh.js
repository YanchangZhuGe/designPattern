var fontSize_xeksh = "'font-size:13px;'";//设置生成的评分配置表格字体
var mergeTd_xeksh = [1, 2];//设置生成的评分配置表格需要合并的列
var inputRadioTd_xeksh = [8];//设置需要添加radio控件的列
var inputText_xeksh = [9];//设置需要添加文本输入框控件的列
var gridItemId_xeksh = 'xekshPf_grid';
var formItemId_xeksh = 'xekshPf_form';

/**
 * 初始化限额库审核，项目评分form
 */
function initWindow_input_contentForm_xeksh(bill_id, flag, zqlx_id) {
    return Ext.create('Ext.form.Panel', {
        width: '100%',
        height: '100%',
        layout: 'vbox',
        itemId: formItemId_xeksh,
        fileUpload: true,
        padding: '2 5 0 5',
        border: false,
        defaults: {
            width: '98%'
        },
        defaultType: 'textfield',
        items: [initContentPsdfGrid_xeksh(bill_id, flag, zqlx_id)]
    });
}

/**
 * 初始化右侧主表格:汇总单表
 */
function initContentPsdfGrid_xeksh(bill_id, flag, zqlx_id) {
    var headerJson = [

        {
            dataIndex: "PFBZ_ID",
            type: "string",
            width: 130,
            hidden: true,
            text: "评分配置ID"
        },
        {
            dataIndex: "ZQLX_ID",
            type: "string",
            width: 130,
            hidden: true,
            text: "项目类型ID"
        },
        {
            dataIndex: "PFBZ_ORDER",
            type: "string",
            width: 60,
            text: "序号",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },
        {
            dataIndex: "ENTRY_LEV1",
            type: "string",
            width: 80,
            align: "center",
            text: "一级条目",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },

        {
            dataIndex: "ENTRY_LEV2",
            type: "string",
            width: 80,
            align: "center",
            text: "二级条目",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },
        {
            dataIndex: "REVIEW_DESC",
            type: "string",
            width: 150,
            align: "center",
            text: "评审内容",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },
        {
            dataIndex: "REVIEW_STANDARD",
            type: "string",
            width: 150,
            align: "center",
            text: "评审标准",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },
        {
            dataIndex: "SCORE_TYPE",
            type: "string",
            width: 80,
            align: "center",
            text: "评分选项",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";

                return "<span style=" + fontSize_xeksh + ">" + (value == '2' ? '是/否' : value) + "</span>";
            }
        },
        {
            dataIndex: "FILE_NAME",
            type: "string",
            width: 100,
            align: "center",
            text: "所在文件名称",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                var data = '<span style="+fontSize_xeksh+">' + value + '</span>';
                var fileId = record.data.FILE_ID;
                var fileName = record.data.FILE_NAME;
                var fileExt = fileName.substring(fileName.lastIndexOf('.') + 1);
                //pdfPreviewFile
                var result = '<a href="#" onclick="pdfPreviewFile(\'' + fileId + '\',\'' + fileExt + '\')" style="color:#3329ff;">' + data + '</a>';
                return result;
            }
        },
        {
            dataIndex: "FILE_PLACE",
            type: "string",
            width: 100,
            align: "center",
            text: "所在文件位置",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },
        {
            text: "评审得分",
            dataIndex: "SCORE",
            width: 80,
            align: "center",
            type: "string",
            editor: 'textfield',
            tdCls: 'grid-cell',
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },
        {
            dataIndex: "XMBZ_ID",
            type: "string",
            width: 130,
            hidden: true,
            text: "评分配置ID"
        },
        {
            text: "评审意见",
            dataIndex: "PSYJ",
            width: 150,
            align: "center",
            type: "string",
            editor: 'textfield',
            tdCls: 'grid-cell',
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },
        {
            dataIndex: "REMARK",
            type: "string",
            width: 100,
            align: "center",
            text: "备注",
            menuDisabled: true,//禁止显示右侧排序菜单
            sortable: false,//是否可排序
            renderer: function (value, meta, record) {
                meta.style = 'white-space:normal;word-break:break-all;';
                meta.tdStyle = "vertical-align:middle;";
                return "<span style=" + fontSize_xeksh + ">" + value + "</span>";
            }
        },
        {
            dataIndex: "FILE_ID",
            type: "string",
            width: 120,
            align: "left",
            hidden: true,
            text: "附件ID"
        }
    ];
    var pspzGrid = DSYGrid.createGrid({
        itemId: gridItemId_xeksh,
        headerConfig: {
            headerJson: headerJson,
            columnAutoWidth: true,
            columnCls: 'normal'
        },
        // checkBox: true,
        border: false,
        autoLoad: true,
        height: '50%',
        pageConfig: {
            enablePage: false
        },
        flex: 1,
        params: {
            ZQLX_ID: zqlx_id,
            BILL_ID: bill_id,
            IS_SH: 'true' //只在项目遴选审核的时候传递该参数，获取对应的项目评分信息
        },
        plugins: [
            {
                ptype: 'cellediting',
                clicksToEdit: 1,
                pluginId: 'cellEdit',
                clicksToMoveEditor: 1
            }
        ],
        dataUrl: '/getPfbzGridCp.action'
    });
    pspzGrid.getStore().on("load", function () {
        getAllTables_xeksh(pspzGrid, flag);
    });
    return pspzGrid;
}

/**
 * 合并Grid的每行的table
 * ext4版本grid为一个table，ext5版本grid每一行为一个table，需要将所有table进行合并
 */
function getAllTables_xeksh(grid, flag) {
    var gridView = document.getElementById(grid.getId());
    var div = gridView.children[1];
    var tables = div.getElementsByTagName('table');
    // if(tables.length==1){
    //     return;
    // }
    //如果为一个table，则不需要进行合并
    mergeTables_xeksh(div, tables, flag);
    //合并数据列
    mergeGrid_xeksh(grid, mergeTd_xeksh, false);
}

function mergeTables_xeksh(div, tables, flag) {
    if (tables.length > 0) {
        //记录获取行数据的所有table
        var tableId = new Array();
        var newtable = document.createElement("table");
        newtable.cellSpacing = 0;
        newtable.cellPadding = 0;
        newtable.border = "1px";
        newtable.id = "gridview-1159-record-660";
        newtable.class = "x-grid-item";
        newtable.width = "100%";
        newtable.style = "TABLE-LAYOUT: fixed";
        newtable.appendChild(document.createElement("tbody"));
        //将所有table中的行数据插入到新table中
        for (var i = 0; i < tables.length; i++) {
            var table = tables[i];
            var rows = table.rows;
            var row = rows[0];
            //添加点击事件，生成radio
            for (var i1 = 0; i1 < inputRadioTd_xeksh.length; i1++) {
                row.children[inputRadioTd_xeksh[i1]].onclick = function (value) {
                    if (flag) {
                        return;
                    }
                    var td = value.currentTarget;
                    if (td.getElementsByTagName('input').length == 0) {
                        td.children[0].hidden = true;
                        var oldValue = td.children[0].children[0].innerText;
                        //如果radio存在，则删除并把选择的值赋值到grid
                        radioBlur_xeksh();
                        //添加radio
                        var div = document.createElement('div');
                        div.setAttribute("style", "text-align: center;");
                        div.id = "td_radio_xeksh";
                        var _radio = document.createElement("input");
                        _radio.type = "radio";
                        _radio.name = "_radio";
                        _radio.value = "是";
                        if (!oldValue) {
                            _radio.checked = "checked";
                        } else if (oldValue == '是') {
                            _radio.checked = "checked";
                        }
                        div.appendChild(_radio);
                        var label = document.createElement("label");
                        label.innerHTML = "是";
                        div.appendChild(label);
                        _radio = document.createElement("input");
                        _radio.type = "radio";
                        _radio.name = "_radio";
                        _radio.value = "否";
                        if (oldValue == '否') {
                            _radio.checked = "checked";
                        }
                        div.appendChild(_radio);
                        var label = document.createElement("label");
                        label.innerHTML = "否";
                        div.appendChild(label);
                        td.appendChild(div);
                        //鼠标移出事件
                        td.onmouseleave = function () {
                            //如果radio存在，则删除并把选择的值赋值到grid
                            radioBlur_xeksh();
                        }
                    } else {
                        td.getElementsByTagName('input')[0].focus();
                    }
                }
            }
            for (var i2 = 0; i2 < inputText_xeksh.length; i2++) {
                row.children[inputText_xeksh[i2]].onclick = function (value) {
                    var td = value.currentTarget;
                    var oldValue = td.children[0].children[0].innerText;
                    if (td.getElementsByTagName('input').length == 0) {//若未构造input
                        //隐藏第一个显示值的div
                        td.children[0].hidden = true;
                        var pname = document.createElement("input");
                        pname.type = "text";
                        pname.setAttribute("style", "width:100%;line-height:100%;border:none;overflow:hidden;text-align:center;");
                        if (!oldValue) {
                            pname.value = '';
                        } else {
                            pname.value = oldValue;
                        }
                        pname.id = "td_input_xeksh";
                        pname.onblur = function (event) {
                            //input失去焦点事件
                            inputOnblur_xeksh();
                        };
                        td.appendChild(pname);
                        pname.focus();
                    } else {
                        //若已经构造好，则配置焦点直接使用
                        td.getElementsByTagName('input')[0].focus();
                    }
                }
            }
            newtable.children[0].appendChild(row);
            tableId.push(table.id);
        }
        tables[0].parentNode.appendChild(newtable);
        //根据记录tableId删除无用table
        for (var j = 0; j < tableId.length; j++) {
            removeNode(document.getElementById(tableId[j]));
        }
        //将table中每个单元格添加边框
        var tdArray = div.getElementsByTagName('td');
        for (var m = 0; m < tdArray.length; m++) {
            var td = tdArray[m];
            td.style.borderTop = "1px solid #ccc";
            td.style.borderLeft = "1px solid #ccc";
            td.style.borderRight = "1px solid #ccc";
            td.style.borderBottom = "1px solid #ccc";
        }
    }
}

/**
 * radio移出事件
 */
function radioBlur_xeksh() {
    var radioDiv = $("#td_radio_xeksh");
    if (radioDiv.length > 0) {
        var radioVal = $("input[name='_radio']:checked").val();
        var radtdDiv = radioDiv.parent();
        removeNode(radtdDiv.children()[1]);
        if (radioVal) {
            radtdDiv.children()[0].children[0].innerText = radioVal;
            var tr = radtdDiv.parent();
            var radrowNum = parseInt(tr.children()[0].innerText);
            var grid = DSYGrid.getGrid(gridItemId_xeksh);
            var pspzStore = grid.getStore();
            pspzStore.data.items[radrowNum - 1].data.SCORE = radioVal;
        }
        radtdDiv.children()[0].hidden = false;
    }
}

/**
 * input框移出事件
 */
function inputOnblur_xeksh() {
    var inputDiv = $("input#td_input_xeksh");
    var inputValue = inputDiv.val();
    var tdDiv = inputDiv.parent();
    //移除input框
    removeNode(tdDiv.children()[1]);
    // if(inputValue){
    tdDiv.children()[0].children[0].innerText = inputValue;
    var tr = tdDiv.parent();
    var rowNum = parseInt(tr.children()[0].innerText);
    var grid = DSYGrid.getGrid(gridItemId_xeksh);
    var pspzStore = grid.getStore();
    //将输入框中值赋值到grid中
    pspzStore.data.items[rowNum - 1].data.PSYJ = inputValue;
    // }
    tdDiv.children()[0].hidden = false;
}

/**
 * 合并Grid的数据列
 * @param grid {Ext.Grid.Panel} 需要合并的Grid
 * @param colIndexArray {Array} 需要合并列的Index(序号)数组；从0开始计数，序号也包含。
 * @param isAllSome {Boolean} 是否2个tr的colIndexArray必须完成一样才能进行合并。true：完成一样；false：不完全一样
 */
function mergeGrid_xeksh(grid, colIndexArray, isAllSome) {
    isAllSome = isAllSome == undefined ? true : isAllSome; // 默认为true

    // 1.是否含有数据
    var gridView = document.getElementById(grid.getId());
    if (gridView == null) {
        return;
    }

    // 2.获取Grid的所有tr
    var trArray = [];
    if (grid.layout.type == 'table') { // 若是table部署方式，获取的tr方式如下
        trArray = gridView.children[1].childNodes;
    } else {
        trArray = gridView.children[1].getElementsByTagName('tr');
    }

    // 3.进行合并操作
    if (isAllSome) { // 3.1 全部列合并：只有相邻tr所指定的td都相同才会进行合并
        var lastTr = trArray[0]; // 指向第一行
        // 1)遍历grid的tr，从第二个数据行开始
        for (var i = 1, trLength = trArray.length; i < trLength; i++) {
            var thisTr = trArray[i];
            var isPass = true; // 是否验证通过
            // 2)遍历需要合并的列
            for (var j = 0, colArrayLength = colIndexArray.length; j < colArrayLength; j++) {
                var colIndex = colIndexArray[j];
                // 3)比较2个td的列是否匹配，若不匹配，就把last指向当前列
                if (lastTr.childNodes[colIndex].innerText != thisTr.childNodes[colIndex].innerText) {
                    lastTr = thisTr;
                    isPass = false;
                    break;
                }
            }

            // 4)若colIndexArray验证通过，就把当前行合并到'合并行'
            if (isPass) {
                for (var j = 0, colArrayLength = colIndexArray.length; j < colArrayLength; j++) {
                    var colIndex = colIndexArray[j];
                    // 5)设置合并行的td rowspan属性
                    if (lastTr.childNodes[colIndex].hasAttribute('rowspan')) {
                        var rowspan = lastTr.childNodes[colIndex].getAttribute('rowspan') - 0;
                        rowspan++;
                        lastTr.childNodes[colIndex].setAttribute('rowspan', rowspan);
                    } else {
                        lastTr.childNodes[colIndex].setAttribute('rowspan', '2');
                    }
                    // lastTr.childNodes[colIndex].style['text-align'] = 'center';; // 水平居中
                    lastTr.childNodes[colIndex].style['vertical-align'] = 'middle'; // 纵向居中
                    thisTr.childNodes[colIndex].style.display = 'none';
                }
            }
        }
    } else { // 3.2 逐个列合并：每个列在前面列合并的前提下可分别合并
        // 1)遍历列的序号数组
        for (var i = 0, colArrayLength = colIndexArray.length; i < colArrayLength; i++) {
            var colIndex = colIndexArray[i];
            var lastTr = trArray[0]; // 合并tr，默认为第一行数据
            // 2)遍历grid的tr，从第二个数据行开始
            for (var j = 1, trLength = trArray.length; j < trLength; j++) {
                var thisTr = trArray[j];
                // 3)2个tr的td内容一样
                if (lastTr.childNodes[colIndex].innerText == thisTr.childNodes[colIndex].innerText) {
                    if (i == colIndexArray.length - 1) {
                        if (lastTr.childNodes[colIndex].innerText != "" && thisTr.childNodes[colIndex].innerText != "") {
                            // 4)若前面的td未合并，后面的td都不进行合并操作
                            if (i > 0 && thisTr.childNodes[colIndexArray[i - 1]].style.display != 'none') {
                                lastTr = thisTr;
                                continue;
                            } else {
                                // 5)符合条件合并td
                                if (lastTr.childNodes[colIndex].hasAttribute('rowspan')) {
                                    var rowspan = lastTr.childNodes[colIndex].getAttribute('rowspan') - 0;
                                    rowspan++;
                                    lastTr.childNodes[colIndex].setAttribute('rowspan', rowspan);
                                } else {
                                    lastTr.childNodes[colIndex].setAttribute('rowspan', '2');
                                }
                                // lastTr.childNodes[colIndex].style['text-align'] = 'center';; // 水平居中
                                lastTr.childNodes[colIndex].style['vertical-align'] = 'middle';
                                ; // 纵向居中
                                thisTr.childNodes[colIndex].style.display = 'none'; // 当前行隐藏
                            }
                        }
                    } else {
                        // 4)若前面的td未合并，后面的td都不进行合并操作
                        if (i > 0 && thisTr.childNodes[colIndexArray[i - 1]].style.display != 'none') {
                            lastTr = thisTr;
                            continue;
                        } else {
                            // 5)符合条件合并td
                            if (lastTr.childNodes[colIndex].hasAttribute('rowspan')) {
                                var rowspan = lastTr.childNodes[colIndex].getAttribute('rowspan') - 0;
                                rowspan++;
                                lastTr.childNodes[colIndex].setAttribute('rowspan', rowspan);
                            } else {
                                lastTr.childNodes[colIndex].setAttribute('rowspan', '2');
                            }
                            // lastTr.childNodes[colIndex].style['text-align'] = 'center';; // 水平居中
                            lastTr.childNodes[colIndex].style['vertical-align'] = 'middle';
                            ; // 纵向居中
                            thisTr.childNodes[colIndex].style.display = 'none'; // 当前行隐藏
                        }
                    }
                } else {
                    // 5)2个tr的td内容不一样
                    lastTr = thisTr;
                }
            }
        }
    }
}

function removeNode(obj) {
    if (isIE() || isIE11()) {
        obj.removeNode(true)
    } else {
        obj.remove();
    }
}

function isIE() {
    if (!!window.ActiveXObject || "ActiveXObject" in window) {
        return true;
    } else {
        return false;
    }
}

function isIE11() {
    if ((/Trident\/7\./).test(navigator.userAgent)) {
        return true;
    } else {
        return false;
    }
}