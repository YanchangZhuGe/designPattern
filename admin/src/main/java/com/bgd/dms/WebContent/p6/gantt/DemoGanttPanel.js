Ext.define("MyApp.DemoGanttPanel", {
    extend : "Gnt.panel.Gantt", 
    requires : [
        'Gnt.plugin.TaskContextMenu',
        'Gnt.column.StartDate',
        'Gnt.column.EndDate',
        'Gnt.column.Duration',
        'Gnt.column.PercentDone',
        'Gnt.column.ResourceAssignment',
        'Sch.plugin.TreeCellEditing',
        'Sch.plugin.Pan'
    ],
    rightLabelField : 'Responsible',
    highlightWeekends : false,
    showTodayLine : true,
    loadMask : true,
    enableProgressBarResize : true,
    readOnly : true,

    initComponent : function() {

        Ext.apply(this, {

            lockedGridConfig : {
                width: 500,
                title : '任务',
                collapsible : true
            },

            // Experimental
            schedulerConfig : {
                collapsible : true,
                title : '甘特图'
            },

            leftLabelField : {
                dataIndex : 'Name',
                editor : { xtype : 'textfield' }
            },
            
            // Add some extra functionality
            plugins : [
                Ext.create("Gnt.plugin.TaskContextMenu"), 
                Ext.create("Sch.plugin.Pan"), 
                Ext.create('Sch.plugin.TreeCellEditing', { clicksToEdit: 2 })
            ],

            // Define an HTML template for the tooltip
            tooltipTpl : new Ext.XTemplate(
                '<h4 class="tipHeader">{Name}</h4>',
                '<table class="taskTip">', 
                    '<tr><td>实际开始:</td> <td align="right">{[Ext.Date.format(values.StartDate, "Y-m-d")]}</td></tr>',
                    '<tr><td>实际结束:</td> <td align="right">{[Ext.Date.format(Ext.Date.add(values.EndDate, Ext.Date.MILLI, -1), "Y-m-d")]}</td></tr>',
                    '<tr><td>进度:</td><td align="right">{PercentDone}%</td></tr>',
                    '<tr><td>计划开始:</td> <td align="right">{[Ext.Date.format(values.BaselineStartDate, "Y-m-d")]}</td></tr>',
                    '<tr><td>计划结束:</td> <td align="right">{[Ext.Date.format(Ext.Date.add(values.BaselineEndDate, Ext.Date.MILLI, -1), "Y-m-d")]}</td></tr>',
                '</table>'
            ).compile(),
            
            // Define the static columns
            columns : [
                {
                    xtype : 'treecolumn',
                    header: '编号',
                    sortable: true,
                    dataIndex: 'TaskId',
                    width: 200,
                    field: {
                        allowBlank: false
                    },
                    renderer : function(v, meta, r) {
                        if (!r.data.leaf) meta.tdCls = 'sch-gantt-parent-cell';

                        return v;
                    }
                },
                {
                    header: '任务名',
                    dataIndex: 'Name'
                },
                {
                	dataIndex : 'actualStartDate',
                    header: '实际开始'
                },
                {
                	dataIndex : 'actualEndDate',
                    header: '实际完成'
                },
                {
                	dataIndex : 'plannedStartDate',
                    header: '计划开始'
                },
                {
                	dataIndex : 'plannedEndDate',
                    header: '计划完成'
                },
                {
                	dataIndex : 'showBaselineStartDate',
                    header: '目标开始'
                },
                {
                	dataIndex : 'showBaselineEndDate',
                    header: '目标完成'
                },
                {
                	dataIndex : 'RemainingDuration',
                    header: '尚需工期'
                },
                {
                	dataIndex : 'PlannedDuration',
                    header: '原定工期'
                },
                {
                    xtype : 'percentdonecolumn',
                    header: '实际完成百分比'
                }
            ],
            
             // Define the buttons that are available for user interaction
            tbar : this.createToolbar()
        });
        
        this.callParent(arguments);
    },

    createToolbar : function() {
        return [
        {
            xtype: 'buttongroup',
            columns: 5,
            items: [{
                    text: '6周',
                    scope : this,
                    handler : function() {
                        this.switchViewPreset('weekAndMonth');
                    }
                },
                {
                    text: '10周',
                    scope : this,
                    handler : function() {
                        this.switchViewPreset('weekAndDayLetter');
                    }
                },
                {
                    text: '1年',
                    scope : this,
                    handler : function() {
                        this.switchViewPreset('monthAndYear');
                    }
                },
                {
                    text: '5年',
                    scope : this,
                    handler : function() {
                        var start = new Date(this.getStart().getFullYear(), 0);

                        this.switchViewPreset('monthAndYear', start, Ext.Date.add(start, Ext.Date.YEAR, 5));
                    }
                },{
	                text : '合适大小',
	                iconCls : 'zoomfit',
	                handler : function() {
	                    this.zoomToFit();
	                },
	                scope : this
                }
            ]},
            {
                xtype: 'buttongroup',
                columns: 5,
                items: [{
	                	text : '显示全部',
	                    iconCls : 'icon-fullscreen',
	                    disabled : !this._fullScreenFn,
	                    handler : function() {
	                        this.showFullScreen();
	                    },
	                    scope : this
                    },
                    {
                    	text : '全部展开',
                        iconCls : 'icon-expandall',
                        scope : this,
                        handler : function() {
                            this.expandAll();
                        }
                    },
                    {
                    	text : '全部收起',
                        iconCls : 'icon-collapseall',
                        scope : this,
                        handler : function() {
                            this.collapseAll();
                        }
                    },
                    {
                    	text : '返回',
                        scope : this,
                        handler : function() {
                        	parent.location.href = getContextPath()+'/p6/projectTask/index.jsp?backUrl=/p6/projectTask/projectList.jsp';
                        }
                    }
                ]}
        ];
    },
    
    applyPercentDone : function(value) {
        this.getSelectionModel().selected.each(function(task) { task.setPercentDone(value); });
    },

    showFullScreen : function() {
        this.el.down('.x-panel-body').dom[this._fullScreenFn]();
    },
    
    _fullScreenFn : (function() {
        var docElm = document.documentElement;
        
        if (docElm.requestFullscreen) {
            return "requestFullscreen";
        }
        else if (docElm.mozRequestFullScreen) {
            return "mozRequestFullScreen";
        }
        else if (docElm.webkitRequestFullScreen) {
            return "webkitRequestFullScreen";
        }
    })()
});