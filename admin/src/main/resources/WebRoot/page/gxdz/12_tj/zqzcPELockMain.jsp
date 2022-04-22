<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bgd.platform.util.service.SpringContextUtil" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<%
    SpringContextUtil.checkUserUrlCode(request, response);
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <meta charset="UTF-8">
    <title>天津债券支出期间锁定管理页面</title>
    <style type="text/css">
        html, body {
            height: 100%;
            width: 100%;
            margin: 0;
        }
        .x-grid-back-green {
            background: #00ff00;
        }
    </style>
</head>
<body>
<!-- 重要：引入统一extjs -->
<script type="text/javascript" src="/js/commonUtil.js"></script>
<script type="text/javascript">
    var today = Ext.Date.format(new Date(),'Y-m-d');
    var LOCK_DATE_A_END = today;
    var LOCK_DATE_B_START = today;
    var LOCK_DATE_B_END = today;
    //区划
    var adStore = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getRegTreeDataNoCache.action',
            reader: {
                type: 'json'
            }
        },
        root: 'nodelist',
        model: 'treeModel',
        autoLoad: true
    });
    //单位
    var agStore = Ext.create('Ext.data.TreeStore', {
        proxy: {
            type: 'ajax',
            method: 'POST',
            url: 'getUnitTreeData.action',
            reader: {
                type: 'json'
            }
        },
        root: {
            expanded: true,
            text: "ROOT",
            children: [
                {text: "单位", code: "单位", leaf: true}
            ]
        },
        model: 'treeModel'
    });
    /*页面初始化*/
    $(document).ready(function(){
        initContent();
    });
    function initContent(){
        Ext.create('Ext.panel.Panel',{
            layout:'border',
            default:{
                split:true,
                collapsible:false,
                border:false
            },
            height:'100%',
            renderTo:Ext.getBody(),
            tbar:[
                {
                    xtype:'button',
                    name:'SEARCH',
                    text:'查询',
                    icon:'/image/sysbutton/search.png',
                    handler:function(btn){
                        reloadGrid();
                    }
                },
                {
                    xtype:'button',
                    name:'LOCK_PE_A',
                    text:'锁定期间',
                    icon:'/image/sysbutton/add.png',
                    handler:function(btn){
                        init_lock_windowA({'TITLE':'锁定期间','PE_TYPE':'0'});
                    }
                },
                {
                    xtype:'button',
                    name:'LOCK_PE_B',
                    text:'解锁期间',
                    icon:'/image/sysbutton/edit.png',
                    handler:function(btn){
                        init_lock_windowA({'TITLE':'解锁期间','PE_TYPE':'1'});
                    }
                },
                {
                    xtype:'button',
                    name:'UN_LOCK',
                    text:'期间失效',
                    icon:'/image/sysbutton/delete.png',
                    handler:function(btn){
                        unlock(btn);
                    }
                }
            ],
            items:[
                initContentTree(),
                initContentRightPanel()
            ]
        });
    }
    /*页面主窗口*/
    function initContentRightPanel(){
        return Ext.create('Ext.panel.Panel',{
            itemId:'mainPanel',
            region:'center',
            layout:'fit',
            flex:5,
            height:'100%',
            items:[
                initContentPanelGrid()
            ]
        });
    }
    /*主面板表格*/
    function initContentPanelGrid(){
        var headJson = [
            {xtype: 'rownumberer',width:40},
            {dataIndex:'AD_CODE',text:'区划编码',type:'string',hidden:true},
            {dataIndex:'AD_NAME',text:'区划名称',type:'string',width:200},
            {dataIndex:'AG_ID',text:'单位id',type:'string',hidden:true},
            {dataIndex:'AG_NAME',text:'单位名称',type:'string',width:400},
            {dataIndex:'PE_ID',text:'期间编码',type:'string',hidden:true},
            {dataIndex:'PE_TYPE',text:'期间类别ID',type:'string',hidden:true},
            {dataIndex:'PE_TYPE_NAME',text:'期间类别',type:'string',width:120},
            {dataIndex:'STATUS',text:'期间状态ID',type:'string',hidden:true},
            {dataIndex:'STATUS_NAME',text:'期间状态',type:'string',
                width: 120,
                renderer:function(value,metaData){
                    if (value.indexOf('启用中') >= 0){
                        metaData.css = 'x-grid-back-green';
                    }
                    return value;
                }
            },
            {dataIndex:'START_DATE',text:'开始期间',width:120,type:'string'},
            {dataIndex:'END_DATE',text:'结束时间',width:120,type:'string'}
        ];
        var grid =  DSYGrid.createGrid({
            itemId:'mainPanelGrid',
            headerConfig:{
                headerJson:headJson,
                columnAutoWidth:false
            },
            autoLoad:false,
            checkBox:true,
            pageConfig:{
                enablePage:false
            },
            dataUrl:'/tj/queryPELog.action',
            params:{}
        });
        return grid;
    }
    /**
     * 刷新页面主表格
     */
    function reloadGrid(){
        var store = DSYGrid.getGrid('mainPanelGrid').getStore();
        store.getProxy().extraParams.AD_CODE = AD_CODE;
        store.getProxy().extraParams.AG_ID = AG_ID;
        store.reload();
    }
    /**
     * 弹出窗口设定锁定期间
     */
    function init_lock_windowA(config){
        Ext.create('Ext.window.Window', {
            itemId:'LOCK_WINDOW_A',
            title: config.TITLE,
            height:document.body.clientWidth * 0.2,
            width: document.body.clientWidth * 0.4,
            layout: 'fit',
            items: {
                xtype:'form',
                layout:'fit',
                items:[
                    init_lock_formPanelA(config)
                ]
            },
            buttons:[
                {
                    xtype:'button',
                    text:'保存',
                    name:'SAVE',
                    handler:function(btn){
                        var form = btn.up('window').down('form');
                        if(!form.isValid()){
                            Ext.toast({
                                html: "请检查必填项，以及未通过校验项！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            return;
                        }
                        //请求后台
                        Ext.Ajax.request({
                            url: '/tj/savePE.action',
                            method: 'POST',
                            params: {
                                DATA: '[' + Ext.JSON.encode(form.getValues()) + ']'
                            },
                            success: function (response) {
                                data = Ext.JSON.decode(response.responseText)
                                if (data.success) {
                                    Ext.toast({
                                        html: "期间锁定成功！",
                                        closable: false,
                                        align: 't',
                                        slideInDuration: 400,
                                        minWidth: 400
                                    });
                                    btn.up("window").close();
                                    reloadGrid();
                                } else {
                                    Ext.Msg.alert('提示', data.msg);
                                }
                            },
                            failure: function () {
                                Ext.Msg.alert('错误', '数据传输错误！');
                            }
                        });
                    }
                },
                {
                    xtype:'button',
                    text:'取消',
                    name:'CANCEL',
                    handler:function(btn){
                        btn.up('window').close();
                    }
                }
            ]
        }).show();
    }

    /**
     * 期间锁定面板
     */
    function init_lock_formPanelA(config){
        return Ext.create('Ext.form.Panel',{
            itemId:'LOCK_FORM_A',
            layout:'anchor',
            width:'100%',
            height:'100%',
            items:[
                {
                    xtype:'textarea',
                    name:'message',
                    width:'100%',
                    editable:false,
                    readOnly:true,
                    fieldStyle: 'background:#E6E6E6',
                    value:'请注意！期间选定后，将按照期间来严格控制债券项目相关支出进度录入！若将期间失效，则期间锁定控制也相应失效。'
                },
                {
                  xtype:'textfield',
                  name:'PE_TYPE',
                  value:config.PE_TYPE,
                  hidden:true
                },
                {//分割线
                    xtype: 'menuseparator',
                    margin: '5 0 5 0',
                    width:'100%',
                    border: true
                },
                {
                    layout: 'column',
                    anchor: '100% 100%',
                    defaultType: 'textfield',
                    defaults: {
                        margin: '2 5 2 5',
                        columnWidth: .49,
                    },
                  items:[
                      {
                          xtype: 'treecombobox',
                          fieldLabel: '<span class="required">✶</span>选择区划',
                          name: 'AD_CODE',
                          itemId:'AD_CODE',
                          displayField: 'text',
                          valueField: 'code',
                          rootVisible: false,
                          allowBlank:false,
                          editable: false, //禁用编辑
                          lines: false,
                          selectModel: 'all',
                          store: adStore,
                          value: AD_CODE,
                          listeners:{
                              change:function ($this,newValue,oldValue) {
                                  if (newValue!=oldValue) {
                                      //刷新下方树
                                      flushUnitTree($this,newValue);
                                  }
                              },
                              afterrender:function(self){
                                  //刷新下方树
                                  var newValue = self.getValue();
                                  flushUnitTree(self,newValue);
                              }
                          }
                      },
                      {
                          xtype: 'treecombobox',
                          fieldLabel: '选择单位',
                          name: 'AG_ID',
                          itemId:'AG_ID',
                          displayField: 'text',
                          valueField: 'id',
                          rootVisible: false,
                          editable: false, //禁用编辑
                          lines: false,
                          selectModel: 'all',
                          checkModel:'multi',
                          store: agStore,
                          value:!!AG_ID?AG_ID:''
                      },
                      {
                          xtype: "datefield",
                          name: "START_DATE",
                          itemId:'START_DATE',
                          fieldLabel: '<span class="required">✶</span>'+'开始时间',
                          allowBlank: config.PE_TYPE=='0',
                          format: 'Y-m-d',
                          value: config.PE_TYPE=='0'?'':LOCK_DATE_B_START,
                          readOnly:config.PE_TYPE=='0',
                          fieldStyle:config.PE_TYPE=='0'?'background:#E6E6E6':'',
                          listeners:{
                              change:function(opt,newValue,oldValue){
                                  if(newValue!=oldValue) {
                                      LOCK_DATE_B_START = newValue;
                                  }
                                  if(config.PE_TYPE=='1'){
                                      var endDate = opt.nextSibling('#END_DATE');
                                      if(endDate!=null){
                                          var endDateValue = endDate.getValue();
                                          if(endDateValue!=null && newValue>endDateValue){
                                              Ext.Msg.alert('警告','期间开始时间不能大于期间结束时间！');
                                              opt.setValue(oldValue);
                                              return;
                                          }
                                      }
                                  }
                              }
                          }
                      },
                      {
                          xtype: "datefield",
                          name: "END_DATE",
                          itemId:'END_DATE',
                          fieldLabel: '<span class="required">✶</span>'+'结束时间',
                          allowBlank: false,
                          format: 'Y-m-d',
                          value: config.PE_TYPE=='0'?LOCK_DATE_A_END:LOCK_DATE_B_END,
                          listeners:{
                              change:function(opt,newValue,oldValue){
                                  if(newValue!=oldValue) {
                                      if ('0' == config.PE_TYPE) {
                                          LOCK_DATE_A_END = newValue
                                      } else {
                                          LOCK_DATE_B_END = newValue;
                                          if(config.PE_TYPE=='1'){
                                              var endDate = opt.previousSibling('#START_DATE');
                                              if(endDate!=null){
                                                  var endDateValue = endDate.getValue();
                                                  if(endDateValue!=null && newValue<endDateValue){
                                                      Ext.Msg.alert('警告','期间开始时间不能大于期间结束时间！');
                                                      opt.setValue(oldValue);
                                                      return;
                                                  }
                                              }
                                          }
                                      }
                                  }
                              }
                          }
                      }
                  ]
                }
            ]
        });
    }
    /**
     * 根据区划刷新单位树
     * @param btn
     */
    function flushUnitTree(self,adCode){
        var unit_tree = self.nextSibling('#AG_ID');
        if(unit_tree!=null){
            var unit_store = unit_tree.getStore();
            unit_store.getProxy().extraParams = {
                AD_CODE: adCode
            };
            unit_store.load();
        }
    }
    /**
     * 强制期间失效
     * @param btn
     */
    function unlock(btn){
        var records = DSYGrid.getGrid('mainPanelGrid').getSelection();
        if(records.length<=0){
            Ext.Msg.alert('提示','请选择有效期间！');
        }else{
            var peIds = [];
            records.forEach(function(record){
                if(!('1'==record.data.STATUS)){
                    Ext.Msg.alert('提示','请选择有效期间！');
                    return;
                }
                peIds.push(record.data.PE_ID);
            });
            if(peIds.length>0){
                Ext.Ajax.request({
                    url: '/tj/unlock.action',
                    method: 'POST',
                    params: {
                        DATA: Ext.JSON.encode(peIds)
                    },
                    success: function (response) {
                        data = Ext.JSON.decode(response.responseText)
                        if (data.success) {
                            Ext.toast({
                                html: "期间已强制失效！",
                                closable: false,
                                align: 't',
                                slideInDuration: 400,
                                minWidth: 400
                            });
                            reloadGrid();
                        } else {
                            Ext.Msg.alert('提示', data.msg);
                        }
                    },
                    failure: function () {
                        Ext.Msg.alert('错误', '数据传输错误！');
                    }
                });
            }
        }
    }
</script>
</body>
</html>