/**
 * 经营管理多列树公共属性抽取
 */

Ext.require([
             'Ext.data.*',
             'Ext.grid.*',
             'Ext.tree.*',
             'Ext.util.*'
]);
var task=Ext.define('Task', {
    extend: 'Ext.data.Model',
    fields: [
        {name : 'costName',type: 'string'},
        {name : 'costDesc', type : 'String'},
        {name : 'gpCostTempId', type : 'String'},
        {name : 'zip', type : 'String'},
        {name : 'orderCode', type : 'String'}
    ]
});

var store = Ext.create('Ext.data.TreeStore', {
	autoLoad: true,
    model: 'Task',
    proxy: {
   	 type : 'ajax',
        method: 'get',
        url: '<%=contextPath%>/op/OpCostSrv/getCostTemplate.srq?costType='+costType,
        reader: {
            type : 'json'
        }
    },
    folderSort: true
});