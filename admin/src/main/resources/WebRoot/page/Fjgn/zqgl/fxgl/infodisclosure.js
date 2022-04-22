Ext.require([
    'Ext.tree.*',
    'Ext.data.*',
    'Ext.layout.container.HBox',
    'Ext.dd.*',
    'Ext.window.MessageBox'
]);
Ext.onReady(function () {
    //定义右键菜单
    var panel = new Ext.panel.Panel({
        renderTo: 'infodisclosure',
        height: '100%',
        layout: 'border',
        defaults: {
            split: true,                  //是否有分割线
            collapsible: false           //是否可以折叠
        },
        height: '100%',
        border: false,
        items: [
            initTree(),//初始化左侧树
            initContentRightPanel()//初始化右侧2个表格
        ]

    });
    /**
     * 初始化左侧树
     */
    function initTree() {
        Ext.define('treeModel', {
            extend: 'Ext.data.Model',
            fields: [
                {name: 'text'},
                {name: 'code'},
                {name: 'id'},
                {name: 'leaf'}
            ]
        });
        var store = Ext.create('Ext.data.TreeStore', {
            model: 'treeModel',
            proxy: {
                type: 'ajax',
                actionMethods: 'POST',
                url: 'getFxpcTree.action',
                reader: {
                    type: 'json'
                    //   root: 'data'
                }
            },
            autoLoad: true
        });
        var tree = new Ext.panel.Panel({
            itemId: 'exrateTree',
            region: 'west',
            layout: 'hbox',
            height: '100%',
            flex: 1,
            border: true,
            items: [{
                xtype: 'treepanel',
                width: '100%',
                height: '100%',
                border: true,
                store: store,
                rootVisible: false,
                listeners: {
                    itemclick: function (view, record, item, index, e, eOpts) {
                        //取资源对象编码作为资源信息查询参数
                        var id = record.get('id');
                        var code = record.get('code');
                        var text = record.get('text');
                        var panel = Ext.ComponentQuery.query('panel#fxpcxxpl_upload')[0];
                        panel.removeAll(true);
                        panel.add(xxplUpload(id, true));

                        var infoDiscStore = DSYGrid.getGrid('infoDiscGrid').getStore();
                        //增加查询参数
                        infoDiscStore.getProxy().extraParams["id"] = id; //
                        infoDiscStore.load();
                    }
                }
            }
            ]
        });
        return tree;
    }
    /**
     * 初始化右侧panel，放置2个表格
     */
    function initContentRightPanel() {
        return Ext.create('Ext.form.Panel', {
            height: '100%',
            flex: 5,
            region: 'center',
            layout: {
                type: 'vbox',
                align: 'stretch',
                flex: 1
            },
//            layout: 'anchor',
//            layout: 'border',
            border: false,
            items: [
                initxzGrid(),
                initplGrid()

            ]
        });
    }
    /**
     * 初始化右侧主表格
     */
    function initxzGrid() {
        var panel = Ext.create('Ext.panel.Panel', {
            layout: 'fit',
            flex: 1,
            itemId: 'fxpcxxpl_upload',
            width: '100%',
            height: '50%',
            items: [xxplUpload('fxpcid', false)]
        });
        return panel;
    }
    function xxplUpload(fxpcid, edit) {
        return UploadPanel.createGrid({
            busiId: fxpcid,//业务ID
            height: '100%',
            width: '100%',
            editable: edit,//是否可以修改附件内容，默认为ture
            gridConfig: {
                itemId: 'window_fapcxxpl_contentForm_tab_upload_grid'//若无，会自动生成，建议填写，特别是出现多个附件上传时
            }
        });
    }
    /**
     * 初始化右侧主表格
     */
    function initplGrid() {
        var headerJson = [
            {xtype: 'rownumberer', width: 35},
            {
                "dataIndex": "FIRST_ZQ_ID",
                "type": "string",
                "text": "债券FIRST_ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            }, {
                "dataIndex": "ZQ_ID",
                "type": "string",
                "text": "债券ID",
                "fontSize": "15px",
                "width": 150,
                hidden: true
            }, {
                "dataIndex": "ZQ_CODE",
                "type": "string",
                "text": "债券编码",
                "fontSize": "15px",
                "width": 150
            }, {
                "dataIndex": "ZQ_NAME",
                "type": "string",
                "width": 250,
                "text": "债券名称",
                renderer: function (data, cell, record) {
                    /*var hrefUrl = '/page/debt/zqgl/fxgl/zqzlYhsMain.jsp?ZQ_ID=' + record.get('FIRST_ZQ_ID') + '&AD_CODE=' + record.get('AD_CODE');
                    return '<a href="' + hrefUrl + '" target="_blank" style="color:#3329ff;">' + data + '</a>';*/
                    var url='/page/debt/zqgl/fxgl/zqzlYhsMain.jsp';
                    var paramNames=new Array();
                    paramNames[0]="ZQ_ID";
                    paramNames[1]="AD_CODE";
                    var paramValues=new Array();
                    paramValues[0]=record.get('FIRST_ZQ_ID');
                    paramValues[1]=record.get('AD_CODE');
                    var result='<a href="#" onclick="urlCt(\''+url+'\',\''+paramNames+'\',\''+paramValues+'\');" style="color:#3329ff;">'+data+'</a>';
                    return result;
                }
            }, {
                "dataIndex": "ZQ_JC",
                "width": 250,
                "type": "string",
                "text": "债券简称"
            }, {
                "dataIndex": "ZQLB_NAME",
                "type": "string",
                "text": "债券类型",
                "fontSize": "15px",
                "width": 150
            }, {
                "dataIndex": "ZQPZ_NAME",
                "width": 150,
                "type": "string",
                "text": "债券品种",
                hidden: true
            }, {
                "dataIndex": "AD_CODE",
                "width": 150,
                "type": "string",
                "text": "区划",
                hidden: true

            }, {
                "dataIndex": "PLAN_FX_AMT",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": "计划发行量（亿）"
            }, {
                "dataIndex": "FX_AMT",
                "width": 150,
                "type": "float",
                "align": 'right',
                "text": "实际发行额（亿）"
            }, {
                "dataIndex": "ZQQX_NAME",
                "width": 150,
                "type": "string",
                "text": "期限"
            }, {
                "dataIndex": "QX_DATE",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "起息日"
            }, {
                "dataIndex": "DQDF_DATE",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "到期兑付日"
            }, {
                "dataIndex": "FX_START_DATE",
                "width": 150,
                "type": "string",
                "align": 'left',
                "text": "发行时间"
            }];
        return DSYGrid.createGrid({
            itemId: 'infoDiscGrid',
            headerConfig: {
                headerJson: headerJson,
                columnAutoWidth: false
            },
            checkBox: true,
            rowNumber: true,
            border: false,
            autoLoad: false,
            height: '50%',
            width: '100%',
            flex: 1,
//            region:'center',
            dataUrl: 'getzqByFxpc.action',
            pageConfig: {
                enablePage: false
            }
        });
    }
});
