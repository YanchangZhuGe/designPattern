(function($) {

	/**
	 * 根据页面里的验证字段自动添加必填的红星
	 */
	$.fn.renderRequiredLabel = function() {
		jQuery("input,select,textarea,checkbox,radio", $(this)).not(
				":hidden,:button").each(function(i, k) {
			var $obj = jQuery(k);
			if (!!$obj.attr('required')) {
				$obj.parent().prev().prepend("<font color='red' title='红色*表示此项必填'>* </font>");
			}
		});
	};
	/**
	*合并单元格
	*/
	$.extend($.fn.datagrid.methods, {
	    autoMergeCells: function (jq, fields) {
	        return jq.each(function () {
	            var target = $(this);
	            if (!fields) {
	                fields = target.datagrid("getColumnFields");
	            }
	            var rows = target.datagrid("getRows");
	            var i = 0,
	            j = 0,
	            temp = {};
	            for (i; i < rows.length; i++) {
	                var row = rows[i];
	                j = 0;
	                for (j; j < fields.length; j++) {
	                    var field = fields[j];
	                    var tf = temp[field];
	                    if (!tf) {
	                        tf = temp[field] = {};
	                        tf[row[field]] = [i];
	                    } else {
	                        var tfv = tf[row[field]];
	                        if (tfv) {
	                            tfv.push(i);
	                        } else {
	                            tfv = tf[row[field]] = [i];
	                        }
	                    }
	                }
	            }
	            $.each(temp, function (field, colunm) {
	                $.each(colunm, function () {
	                    var group = this;
	 
	                    if (group.length > 1) {
	                        var before,
	                        after,
	                        megerIndex = group[0];
	                        for (var i = 0; i < group.length; i++) {
	                            before = group[i];
	                            after = group[i + 1];
	                            if (after && (after - before) == 1) {
	                                continue;
	                            }
	                            var rowspan = before - megerIndex + 1;
	                            if (rowspan > 1) {
	                                target.datagrid('mergeCells', {
	                                    index: megerIndex,
	                                    field: field,
	                                    rowspan: rowspan
	                                });
	                            }
	                            if (after && (after - before) != 1) {
	                                megerIndex = after;
	                            }
	                        }
	                    }
	                });
	            });
	        });
	    }
	});
	/**
	 * 扩展easyui的验证
	 */
	$.extend($.fn.validatebox.defaults.rules, {
		multipleValidType : {// 多种输入验证
			// 使用方法validType="multipleValidType['chinese','lenRang[2,4]']"
			validator : function(vtype, vparam) {
				var opts = $.fn.validatebox.defaults;
				var returnFlag = true;
				for ( var i = 0; i < vparam.length; i++) {

					var vpo = /([a-zA-Z_]+)(.*)/.exec(vparam[i]);
					var rule = opts.rules[vpo[1]];
					if (vtype && rule) {
						var param = eval(vpo[2]);
						if (!rule["validator"](vtype, param)) {
							returnFlag = false;
							this.message = rule['message'];
							if (param) {
								for ( var i = 0; i < param.length; i++) {
									this.message = this.message.replace(
											new RegExp("\\{" + i + "\\}", "g"),
											param[i]);
								}
							}
							break;
						}
					}

				}
				return returnFlag;
			},
			message : "非法输入"
		},
		lenRang : {// 验证长度范围
			validator : function(value, param) {
				var len = $.trim(value).length;
				return len >= param[0] && len <= param[1];
			},
			message : "输入内容长度必须介于{0}和{1}之间"
		},
		chinese : {// 验证中文
			validator : function(value) {
				return /^[\u0391-\uFFE5]+$/i.test(value);
			},
			message : '请输入中文'
		},
		
		varcharLen : {// 输入长度验证
			validator : function(value, param) {
				return value.len() <= param[0];
			},
			message : '长度不能超过{0}字符，一个汉字占2字符'
		},
		varFileNameLen : {// 附件名称长度验证
			validator : function(value, param) {
				value=value.substr(value.lastIndexOf("\\")+1); 
				return value.len() <= param[0];
			},
			message : '长度不能超过{0}字符，一个汉字占2字符'
		},
		rangFloat : {
			validator : function(value, param) {
				var tv = $.trim(value);
				var _1 = tv;
				var _2 = "";
				if (!!tv) {
					if (tv.indexOf(".") != -1) {
						var v = tv.split(".");
						_1 = v[0];
						_2 = v[1];
					}
				}
				return /^-?\d+(\.\d+)?$/.test(tv)
						&& _1.length <= param[0] && _2.length <= param[1]&&_1[0]>=0;
			},
			message : "最多输入{0}位正整数，{1}位小数的数值"
		},
		rangInteger : {
			validator : function(value, param) {
				var tv = $.trim(value);
				return /^(\d+)$/.test(tv) && tv.length <= param[0];
			},
			message : "输入的正整数位不能多于{0}位"
		},
		intOrFloat : {// 验证整数或小数
			validator : function(value) {
				return /^\d+(\.\d+)?$/i.test(value);
			}, 
			message : '请输入数字或小数'
		},
		number : {// 验证正负整数或小数
			validator : function(value) {
				return /^[-]?\d+(\.\d+)?$/i.test(value);
			}, 
			message : '请输入数字或小数'
		},
		integer : {// 验证整数(不可输入0)
			validator : function(value) {
				return /^[+]?[1-9]+\d*$/i.test(value);
			},
			message : '请输入整数'
		},
		int_zero : {// 验证正整数(可输入0)
			validator : function(value) {
				return /^\+?[0-9][0-9]*$/i.test(value);
			},
			message : '请输入有效数字'
		},
		int : {// 验证整数(正负0)
			validator : function(value) {
				return /^([-]?[1-9]+\d*)|0$/i.test(value);
			},
			message : '请输入整数'
		},
		negative : {// 验证整数或负数
			validator : function(value) {
				return /^[-]?[1-9]+\d*$/i.test(value);
			},
			message : '请输入整数或负数'
		},
		figure : {// 验证数字
			validator : function(value) {
				return /^\d+$/i.test(value);
			},
			message : '请输入数字'
		},
		num : {// 验证编号  
			validator : function(value) {
				return /^[A-Za-z0-9]+$/i.test(value);
			},
			message : '请输入数字或字母'
		},
		card : {// 验证身份证
			 validator : function(value) {            
				 return /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/i.test(value);     
			 },       
				 message : '请输入正确的身份证号码'  
		},
		age : {// 验证年龄
			 validator : function(value) {            
				 return /^(?:[1-9][0-9]?|1[01][0-9]|120)$/i.test(value);     
			 },       
				 message : '年龄必须是0到120之间的整数'  
		},
		
		phone : {// 验证电话号码
			 validator : function(value) {            
				 return /((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)/i.test(value);     
			 },       
				 message : '请输入正确的电话'  
		},
		
		per_centum : {// 验证百分比（小于100的整数或是一位两位的小数，且小数位不超过2位）
			validator : function(value) {  
				if( value>100 ){
					return false ;
				}else{
					return /^(([1-9]?\d(.\d{1,2})?)|(100(.00?)?))$/i.test(value);
				}
			 },       
				 message : '百分比必须是0到100之间的整数或小数，且小数位不超过2位'  
		},
		per_four: {// 验证小数位数4位
			validator : function(value) {            
				 return /^(0|([1-9]?)|([1-9]\d{1,6}?))(\.\d{1,4})?$/i.test(value);  
			 },       
				 message : '请输入数字或小数'  
		},
		per_two: {// 验证小数位数2位
			validator : function(value) {            
				 return /^(0|([1-9]?)|([1-9]\d{1,8}?))(\.\d{1,2})?$/i.test(value);  
			 },       
				 message : '请输入数字或小数'  
		
		},
		per_one: {// 验证小数位数1位
			validator : function(value) {            
				 return /^(0|([1-9]?)|([1-9]\d{1,8}?))(\.\d{1,1})?$/i.test(value);  
			 },       
				 message : '请输入数字或小数'  
		
		},
		per_three: {// 验证小数位数3位
			validator : function(value) {            
				 return /^(0|([1-9]?|([1-9]\d{1,7}?)))(\.\d{1,3})?$/i.test(value);  
			 },       
				 message : '请输入数字或小数'  
		
		},
		unnormal : {// 验证是否包含空格和非法字符
			validator : function(value) {            
				return /.+/i.test(value);        
			},        
				message : '输入值不能为空和包含其他非法字符'   
		}, 
		v_select: {// 验证是否包含空格和非法字符
			validator : function(value, param) {   
				if(value=='请选择'||value ==""){
					return false;
				}else{ 
					return true; 
				}
			},        
			message : '请选择下拉选项'   
		}, 
		
	  	gtStartDate: {  
			 validator: function(value,param){//  
				 var dateA = $.fn.datebox.defaults.parser(value);
				 var dateB = $.fn.datebox.defaults.parser($(param[0]).datebox('getValue'));
				 return  dateA>=dateB;
			 },  
			 message:"结束时间必须大于或等于开始时间"  
	    } ,	
	    
	    gtStartDateAndMsg: {  
			 validator: function(value,param){//  
				 var dateA = $.fn.datebox.defaults.parser(value);
				 var dateB = $.fn.datebox.defaults.parser($(param[0]).datebox('getValue'));
				 return  dateA>=dateB;
			 },  
			 message:"{1}"
	    } ,	
	    
	    v_office: {  
            validator: function(value){  
                 return  /\.(doc|docx|xls|xlsx|ppt|pptx|vsd|pot|pps|rtf|wsp|et|dps|pdf|PDF)$/.test(value);
            },  
        message:"请选择正确文档格式(doc,ppt,xls,pdf...)"  
        },
        
	    v_img: {  
            validator: function(value){//  
            	  
                 return  /\.(jpg|jpeg|gif|bmp|tif|JPG|JPEG|GIF|BMP|png|PNG|TIF)$/.test(value);
            },  
         
 
        message:"请上传图片文件"  
       } ,
       
	    v_SEjy: {  
           validator: function(value){//  
           	  
                return  /\.(s|S|EGY|egy)$/.test(value);
           },  
        

       message:"请上传指定文件文件"  
      } ,
        
        v_doc: {  
            validator: function(value){  
            	value = value.toLowerCase();
                 return  /\.(doc|docx)$/.test(value);
            },  
        message:"请上传word文件 "  
        },
        
        v_ppt: {  
            validator: function(value){ 
            	 value = value.toLowerCase();
                 return  /\.(ppt|pptx|wsp)$/.test(value);
            },  
        message:"请上传ppt文件(ppt,pptx,wsp)"  
        },
        
        v_pdf: {  
            validator: function(value){ 
            	 value = value.toLowerCase();
                 return  /\.(pdf)$/.test(value);
            },  
        message:"请上传pdf文件 "  
        },
      
        v_xls: {  
            validator: function(value){ 
            	 value = value.toLowerCase();
                 return  /\.(xls|xlsx)$/.test(value);
            },  
        message:"请上传excel文件 "  
        }
 
	});
	/**
	 * 为string添加长度函数
	 * 
	 * @returns
	 */
	String.prototype.len = function() {
		return this.replace(/[^\x00-\xff]/g, "aa").length;
	};
	/**
	 * 为array对像添加是否包含e元素
	 * 
	 * @param e
	 *            查找元素
	 * @returns {Boolean}
	 */
	Array.prototype.in_array = function(e) {
		var i = 0;
		for (i = 0; i < this.length && this[i] != e; i++);
		return !(i == this.length);
	};
})(jQuery);

function formVilidate(target){
	if ($.fn.validatebox){
		var t = $(target);
		t.find('.validatebox-text:not(:disabled)').validatebox('validate');
		var invalidbox = t.find('.validatebox-invalid');
		invalidbox.filter(':not(:disabled):first').focus();
		return invalidbox.length == 0;
	}
	return true;
}
/**
 * 页面的tip提示
 */
function tipView(tagname,tagvalue,position){
	$('#'+tagname).tooltip({
		position: position,
		content: '<span style="color:#fff">'+tagvalue+'</span>',
		onShow: function(){
			$(this).tooltip('tip').css({
				backgroundColor: '#5B99DE',
				borderColor: '#5B99DE'
			});
		}
	});
}
//调用此方法，可以实现上下两个table的方式实现表头固定和对齐，参考planMaininfoList.jsp的#detailtitletable和#detailMap
function aligntitle(titletrid,filterobj){
	var titlecells = $("tr",titletrid)[0].cells;
	var contenttr = $("tr",filterobj)[0];
	if(contenttr==undefined)
		return;
	var contentcells = contenttr.cells
	for(var index=0;index<titlecells.length;index++){
		var widthinfo = contentcells[index].offsetWidth;
		if(widthinfo>0){
			titlecells[index].width = widthinfo+'px';
		}
	}
}
