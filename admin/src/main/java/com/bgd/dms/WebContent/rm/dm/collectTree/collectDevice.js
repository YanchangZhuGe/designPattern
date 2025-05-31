var devCodeStatus = true;
DevicePanel = function(config) {
	DevicePanel.superclass.constructor.call(this, config);
}
Ext.extend(DevicePanel, Ext.FormPanel, {
	title : '采集设备信息',
	buttonAlign : 'center',
	labelAlign : 'right',
	initComponent : function() {
	
 	var store = new Ext.data.JsonStore({
 		url : _path + "/rm/dm/getSBTypeCode.srq",
        fields:['node_type','node_type_id'],
        autoLoad:true,
        root:'root'
	});
		var deviceNameField = new Ext.form.TextField({
					fieldLabel : '设备名称',
					emptyText : '请输入设备名称',
					name : 'dev_name',
					id : 'dev_name',
					allowBlank : false
				}), deviceModelField = new Ext.form.TextField({
					fieldLabel : '规格型号',
					emptyText : '请输入设备型号',
					name : 'dev_model',
					id : 'dev_model'
				}), deviceIdField = new Ext.form.TextField({
					hideLabel : true,
					hidden : true,
					id : 'device_id'
				}), deviceCodeField = new Ext.form.TextField({
					fieldLabel : '设备编码',
					emptyText : '请输入设备编码',
					parentDevCode : this.parent_dev_code,
					name : 'dev_code',
					oldDevCode : this.dev_code,
					id : 'dev_code',
					allowBlank : false
				}), deviceSlotNumField = new Ext.form.NumberField({
					fieldLabel : '设备槽道数',
					emptyText : '请输入设备槽道数',
					name : 'dev_slot_num',
					id : 'dev_slot_num'
				}), deviceTypeField = new Ext.form.TextField({
					fieldLabel : '设备类型',
					emptyText : '请输入设备类型',
					name : 'dev_name',
					id : 'dev_name',
					allowBlank : false
				}), parentIdField = new Ext.form.TextField({
					hideLabel : true,
					hidden : true,
					name : 'node_parent_id',
					id : 'node_parent_id',
					value : this.parent_device_id == 'root' ? '' : this.parent_device_id
				}),deviceNodeTypeField = new Ext.form.ComboBox({
					fieldLabel : '设备型号',
					store:store,
					displayField : 'node_type',
					valueField: 'node_type_id',
					triggerAction:"all",
					mode:'local',
					allowBlank:false,
					hiddenName:'node_type_id',
					forceSelection:true,
					editable :false
				}),pa = this.pageAction,
				   nl = this.node_level,
				   parDeId = this.parent_device_id,
				   deId = this.device_id,
				   parDeCode = this.parent_dev_code,
				   deCode = this.dev_code;
		deviceCodeField.validator = function(value){
			if(value == this.oldDevCode){
				return true;
			}else{
				var parDeCode = this.parentDevCode,regexp = new RegExp("^"+parDeCode+".+"),scope = this;
				if(regexp.test(value)){
					top.Ext.getBody().mask("验证中,请等待...");
					Ext.Ajax.request({
						url : _path + "/rad/asyncQueryList.srq",
						params : {
							querySql : "select dev_code from gms_device_collectinfo where dev_code = '"
									+ value + "'"
						},
						callback : function(option,bool,response){
							top.Ext.getBody().unmask();
							var o =  Ext.decode(response.responseText);
							if(o["returnCode"] != 0){
								devCodeStatus = false;
								this.markInvalid(o["returnMsg"]);
							}else if(o.datas.length > 0 ){
								devCodeStatus = false;
								this.markInvalid("编码"+value+"已经存在");
							}else{
								devCodeStatus = true;
								this.clearInvalid();
							}
						},
						scope : scope
					})
				}else{
					var msg = parDeCode == "" ? "" : "设备编码必须以"+parDeCode+"开始,";
					return (msg+"至少为"+(parDeCode.length+1)+"位");
				}
				return devCodeStatus;
			}
		}
		var fieldSet = new Ext.form.FieldSet({
					labelWidth : 90,
					bodyStyle : Ext.isIE
							? 'padding:0 0 5px 15px;'
							: 'padding:10px 15px;',
					style : {
						"margin-left" : "10px",
						"margin-right" : Ext.isIE6 ? (Ext.isStrict
								? "-10px"
								: "-13px") : "0"
					},
					autoHeight : true,
					defaults : {
						width : 190,
						border : true
					},
					items : [deviceIdField, parentIdField]
				});
		if (pa == 'add') {
			fieldSet.title = '新增';
		} else if (pa == 'modify') {
			fieldSet.title = '修改'
		}
 		if (nl == "2") {//暂时支持node_level为2
			fieldSet.add(deviceNameField);
			fieldSet.add(deviceModelField);
			fieldSet.add(deviceCodeField);
			fieldSet.add(deviceSlotNumField);
			fieldSet.add(deviceNodeTypeField);
		}else {
			fieldSet.add(deviceTypeField);
			fieldSet.add(deviceCodeField);
		}
		this.items = [fieldSet];
		this.addButton({
			text : '保存',
			handler : function(btn, e) {
				if (this.getForm().isValid()) {
					top.Ext.getBody().mask("加载中,请等待...", "x-mask-loading");
					this.getForm().submit({
						url : _path + "/rad/addOrUpdateEntity.srq",
						params : {
							JCDP_TABLE_NAME : 'gms_device_collectinfo',
							node_level : nl,
							is_leaf : nl == "2" ? "1" : "0"
						},
						success : function(form, action) {
							top.Ext.getBody().unmask();
						},
						failure : function(form, action) {
							
							var result = action.result;
							if (result["returnCode"] != 0) {
								top.Ext.getBody().unmask();
								top.Ext.Msg.alert("错误", "<font color='red'>"
												+ result["returnMsg"]
												+ "</font>");
							} else {
								var el = Ext.getCmp("dev_code"),
									value = el.getValue(),
									oldDevCode = el.oldDevCode;
								if(pa == 'modify' && nl != "2" && oldDevCode != value){
									var path = _path + "/rad/asyncUpdateEntitiesBySql.srq";
									var sql = 	"UPDATE gms_device_collectinfo t\n" +
												"   SET t.dev_code = REPLACE(t.dev_code, '"+oldDevCode+"', '"+value+"')\n" + 
												" WHERE t.dev_code LIKE '"+oldDevCode+"%'";
									var params =  encodeURI("sql=" + sql + "&ids=");
									var retObject = syncRequest('post', path,params);
								}
								top.Ext.getBody().unmask();
								top.Ext.Msg.alert("完成", "保存成功!", function() {
											
											parent.mainleftframe.window.location.reload();
										});

							}
						}
					});
				}
			},
			scope : this
		});
		fieldSet.on('afterlayout', function(container, layout) {
			if (pa == 'modify' && deId != null) {
				top.Ext.getBody().mask("加载中,请等待...", "x-mask-loading");
				this.getForm().load({
					url : _path + "/rad/asyncQueryList.srq",
					params : {
						querySql : "select a.device_id,a.dev_name, a.dev_model,a.dev_code,a.node_level, a.node_parent_id,a.dev_slot_num, a.is_leaf, a.node_type_id, b.coding_name as node_type from gms_device_collectinfo a join comm_coding_sort_detail b on a.node_type_id = b.coding_code_id where device_id = '"
								+ deId + "'"
					},
					success : function(form, action) {
						top.Ext.getBody().unmask();
					},
					failure : function(form, action) {
						top.Ext.getBody().unmask();
						var result = action.result;
						if (result["returnCode"] != 0) {
							top.Ext.Msg.alert("错误", "<font color='red'>"
											+ result["returnMsg"] + "</font>");
						} else {
							var data = result.datas[0];
							form.setValues(data);
							form.isValid();
						}
					}
				});

			}
		}, this)
		DevicePanel.superclass.initComponent.call(this);
	}
});
Ext.onReady(function() {
			Ext.BLANK_IMAGE_URL = _path + "/js/extjs/resources/images/default/s.gif";
			Ext.QuickTips.init();
			Ext.form.Field.prototype.msgTarget = 'side';
			Ext.apply(Ext.form.VTypes, {
			    devCode:  function(v,field) {
			        return true;
			    },
			    devCodeText: 'Must be a numeric IP address'
			});
			var urlParam = Ext.urlDecode(location.search.substring(1));
			var devicePanel = new DevicePanel(urlParam);
			new Ext.Viewport({
						items : [devicePanel],
						layout : 'fit'
					});
		});