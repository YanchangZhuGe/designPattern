<%@ page contentType="text/html;charset=UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%@taglib prefix="easyuiAuth" uri="easyuiAuth"%>
<%@page import="java.util.*,com.cnpc.jcdp.soa.msg.ISrvMsg"%>
<%@taglib prefix="auth" uri="auth"%>
<%@ page import="com.cnpc.jcdp.cfg.BeanFactory"%>
<%
	String contextPath = request.getContextPath();
	UserToken user = OMSMVCUtil.getUserToken(request);
	String orgSubId = user.getSubOrgIDofAffordOrg();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/common/include/quotesresource.jsp"%>
<title>验收准备</title>
<style type="text/css">
.pagination table{
	float:right;
}

.panel .inquire_item{
	text-align:right;
}
.inquire_form{
	width:180px;
}

.tab_line_height {
	border-color: #1C86EE;
 	border-style: dotted;
 	border-width: 2px;
	width:100%;
	line-height:24px;
	height:24px;
	color:#000;
	margin: 0;
    padding: 0;
}
.tab_line_height td {
	border-color: #1C86EE;
	border-style: dotted;
	line-height:24px;
	border-width: 1px;
	height:24px;
	white-space:nowrap;
	word-break:keep-all;
	margin: 0;
    padding: 0;
}
.panel .panel-body{
	font-size: 12px;
}
input,textarea{
	font-size: 12px;
}
</style>
</head>
<body>
	<!-- 最外层layout -->
	<div class="easyui-layout" data-options="fit:true" >
		<!-- 页面上半部分布局 -->
		<div id="north" data-options="region:'north',split:true" style="height:325px;">
			<div class="easyui-layout" data-options="fit:true">
				<!-- 页面上半部分的内容 -->
				<div data-options="region:'center',border:false,split:false" > 
					<table id="backapp_grid">
						<thead>
							<tr>
								<th data-options="field:'ck_id',checkbox:true,align:'center'" width="10">主键</th>
								<th data-options="field:'ck_cid',align:'center',sortable:'true'" width="16">验收单号</th>
								<th data-options="field:'apply_num',align:'center',sortable:'true'" width="16">需求计划单号</th>
								<th data-options="field:'pact_num',align:'center',sortable:'true'" width="14">合同号</th>
								<th data-options="field:'ck_company',align:'center',sortable:'true'" width="14">供应商</th>
								<th data-options="field:'ck_sectors',align:'center',sortable:'true'" width="10">验收单位</th>
								<th data-options="field:'ck_outcome',align:'center',sortable:'true'" width="10">验收结果</th>
								<th data-options="field:'ck_date',align:'center',sortable:'true'" width="10">验收时间</th>
							</tr>
						</thead>
					</table>
					<div id="tb2" style="height:28px;">
						<div style="float:left;height:28px;">						
							&nbsp;&nbsp;验收单号：<input id="ck_cid" class="input_width query" style="width:75px;float:none;">
							&nbsp;&nbsp;需求计划单号：<input id="apply_num" class="input_width query" style="width:75px;float:none;">
							&nbsp;&nbsp;合同号：<input id="pact_num" class="input_width query" style="width:75px;float:none;">
							&nbsp;&nbsp;验收单位：<input id="ck_sector" class="query" hidden>
							<input id="ck_sectors" class="input_width query" style="width:75px;float:none;" readonly="readonly">
							<img id="show-btn" src="<%=contextPath%>/images/magnifier.gif" width="16" height="16" style="cursor: pimter;" onclick="showOrgTreePage1()" />
							&nbsp;&nbsp;验收结果：
							<select id="ck_outcome" class="input_width query" style="width:60px;float:none;">
								<option value="合格">合格</option>
								<option value="不合格">不合格</option>
							</select>
						</div>
						<div style="float:left;height:28px;">
							&nbsp;&nbsp;&nbsp;
							<a href="####" class="easyui-linkbutton" onclick="searchDevData()"><i class="fa fa-search fa-lg"></i> 查询</a>
							<a href="####" class="easyui-linkbutton" onclick="clearQueryText()"><i class="fa fa-minus-square fa-lg"></i> 清除</a>
						</div>
						<div style="float:right;height:28px;">
							<a href="####" class="easyui-linkbutton" onclick="showCheckStandard()"><i class="fa fa-search fa-lg"></i>验收标准查看</a>
							<easyuiAuth:EasyUIButton functionId="yszb_add" className="fa fa-plus-circle fa-lg son" event="toAddMixPlanPage()" text="添加"></easyuiAuth:EasyUIButton>
							<easyuiAuth:EasyUIButton functionId="yszb_upd" className="fa fa-pencil-square fa-lg" event="toModifyMixPlanPage()" text="修改"></easyuiAuth:EasyUIButton>
							<easyuiAuth:EasyUIButton functionId="yszb_del" className="fa fa-trash-o fa-lg" event="toDelMixPlanPage()" text="删除"></easyuiAuth:EasyUIButton>
						</div>						
					</div>
				</div>
			</div>
		</div>
		<!-- 页面下半部分 -->
		<div id="center" data-options="region:'center',title:'',split:true">	
			  <div id="tab" class="easyui-tabs" data-options="fit:true,plain:true">
                <div title="设备列表">
                	<table id="backinfo_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'dev_id',align:'center',hidden:true" width="30">主键</th>
								<th nowrap="false" data-options="field:'dev_name',align:'center',sortable:'true'" width="20">设备名称</th>
								<th nowrap="false" data-options="field:'dev_model',align:'center',sortable:'true'" width="40">型号</th>
								<th nowrap="false" data-options="field:'dev_num',align:'center',sortable:'true'" width="10">数量</th>
								<th nowrap="false" data-options="field:'dev_producer',align:'center',sortable:'true'" width="50">生产厂家</th>
								<th nowrap="false" data-options="field:'dev_type',align:'center',sortable:'true'" width="10">计量单位</th>
							</tr>
						</thead>
					</table>
                </div>
                <div title="验收小组" >
					<table id="backinfos_grid">
						<thead>
							<tr>
								<th nowrap="false" data-options="field:'ps_id',align:'center',hidden:true" width="20">主键</th>
								<th nowrap="false" data-options="field:'ps_name',align:'center',sortable:'true'" width="15">姓名</th>
								<th nowrap="false" data-options="field:'ps_sex',align:'center',sortable:'true'" width="15">性别</th>
								<th nowrap="false" data-options="field:'ps_sectors',align:'center',sortable:'true'" width="40">所在单位</th>
								<th nowrap="false" data-options="field:'ps_job',align:'center',sortable:'true'" width="20">职称</th>
							</tr>
						</thead>
					</table>
                </div>
                <div title="供货商评价" style="padding:10px;">
                	<div id="checkapp_detail" data-options="fit:true" class="easyui-panel" title="" style="padding:10px;">
						<table id="csiInfo" width="100" height="100"  style="overflow:hidden;"  class="tab_line_height">
							 <tr>
								 <td class="inquire_item">验收单号：</td>
							     <td>
							    	<input type="text" id="ck_cid" class="easyui-validatebox only_read main" style="width:100%" readonly="readonly"/>
							     </td>
							     <td class="inquire_item">供货商：</td>
							     <td>
							    	<input type="text" id="ck_company" class="easyui-validatebox only_read main" style="width:100%" readonly="readonly"/>
							     </td>
							     <td class="inquire_item">满意度：</td>
							     <td>
							    	<input type="text" id="ck_company_score" class="easyui-validatebox only_read main" style="width:200px" readonly="readonly"/>
							     </td>
							 </tr>
					 	</table>
                	</div>
                </div>
                <div title="上报资料" >
                	<iframe id="attachement" scrolling="yes" frameborder="0"  src="" style="width:100%;height:100%;"></iframe>
                </div>               
           	 </div>
		</div>
	</div>
	<div id="win"></div>
</body>
<script type="text/javascript">
    var selectTabIndex = 0;
    var currentId = "";
    var queryParams;
    var orgSubId = "<%=orgSubId%>";

    $(function () {
        //设置样式
        $(".only_read").attr("readonly", "true");
        $(".only_read").css("border", "0").css("color", "blue").css("background-color", "transparent");
        $("#detail tr").each(function (index) {
            if (index % 2 == 0) {
                $(this).addClass("datagrid-row-alt");
            }
        });
        //如果有行被选中，则加载选中标签的内容
        $('#tab').tabs({
            onSelect: function (title, index) {
                selectTabIndex = index;
                var row = $('#backapp_grid').datagrid('getSelected').ck_id;
                if (row) {
                    if (selectTabIndex == 0) {
                        // 验收设备
                        loadMixCollInfo(row);
                    } else if (selectTabIndex == 1) {
                        // 验收小组
                        loadMixCollDetial(row);
                    } else if (selectTabIndex == 2) {
                    	// 供货商评价
    					loadCsiInfo(row);
                    } else if (selectTabIndex == 3) {
                    	// 上报资料
                    	loadDocList(row);
                    }
                }
            }
        });
        //初始单台设备调配信息
        $("#backapp_grid").datagrid({
            method: 'post',
            nowrap: false,
            rownumbers: true,//行号 
            title: "",
            toolbar: '#tb2',
            border: false,
            striped: true,
            singleSelect: true,//是否单选 
            pagination: true,//分页控件 
            selectOnCheck: true,
            fit: true,//自动大小 
            fitColumns: true,
            onClickRow: function (index, data) {
                currentId = data.ck_id;
                if (selectTabIndex == 0) {
                    // 设置基本信息
                    loadMixCollInfo(currentId);
                } else if (selectTabIndex == 1) {
                    // 保养项目
                    loadMixCollDetial(currentId);
                } else if (selectTabIndex == 2) {
                	// 供货商评价
					loadCsiInfo(currentId);
                } else if (selectTabIndex == 3) {
                	// 上报资料
                	loadDocList(currentId);
                }
            },
            queryParams: {//必需参数
                'orgSubId': orgSubId
            },
            url: "${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=CheckDevReady&JCDP_OP_NAME=queryCheckReadyInfoList"
        });
        //初始化保养项目信息,消耗备件信息
        $("#backinfo_grid").datagrid({
            method: 'post',
            rownumbers: true,
            toolbar: '',
            border: false,
            striped: true,
            singleSelect: true,
            pagination: true,
            fit: true,
            fitColumns: true
        });
        //初始化保养项目信息,消耗备件信息
        $("#backinfos_grid").datagrid({
            method: 'post',
            rownumbers: true,
            toolbar: '',
            border: false,
            striped: true,
            singleSelect: true,
            pagination: true,
            fit: true,
            fitColumns: true
        });
        //初始化保养项目信息,消耗备件信息
        $("#bg").datagrid({

        });
    });

    //加载验收设备基本信息
    function loadMixCollInfo(ck_id) {
        $("#backinfo_grid").datagrid({
            queryParams: { 'ck_id': ck_id },
            url: "${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=CheckPersonDev&JCDP_OP_NAME=queryCheckDevList",
        });
    }
    // 加载验收小组基本信息
    function loadMixCollDetial(ck_id) {
        $("#backinfos_grid").datagrid({
            queryParams: { 'ck_id': ck_id },
            url: "${pageContext.request.contextPath}/rm/dm/getListDataBySrvAndMethod.srq?JCDP_SRV_NAME=CheckPersonDev&JCDP_OP_NAME=queryCheckPersonList",
        });
    }
    //添加
    function toAddMixPlanPage() {
        popWindow('${pageContext.request.contextPath}/dmsManager/check/checkready_add.jsp', "950:580", "-填写验收准备");
    }
    //修改
    function toModifyMixPlanPage() {
        var row = $('#backapp_grid').datagrid('getSelected');
        if (row) {
            popWindow('${pageContext.request.contextPath}/dmsManager/check/checkready_add.jsp?flag=update&ck_id=' + row.ck_id, '950:580', '-修改验收准备');
        } else {
            $.messager.alert('提示', '请选择记录!', 'warning');
        }
    }

    //删除单据
    function toDelMixPlanPage() {
        var row = $('#backapp_grid').datagrid('getSelected');
        if (row) {
            $.messager.confirm("操作提示", "您确定要执行操作吗？", function (data) {
                if (data) {
                    if (row.ck_status == '已验收') {
                        $.messager.alert('提示', '已验收不能删除!', 'warning');
                        return;
                    }
                    var retObj = jcdpCallService("CheckDevReady", "deleteCheckConfInfo", "ck_id=" + row.ck_id);
                    queryData(cruConfig.currentPage);
                }
                searchDevData();
            });
        } else {
            $.messager.alert('提示', '请选择记录!', 'warning');
        }
    }

    //清空查询条件
    function clearQueryText() {
        $(".query").val("");
        setFirstPage("#backapp_grid");
        searchDevData();
    }
    //返回首页
    function setFirstPage(ids) {
        var opts = $(ids).datagrid('options');
        var pager = $(ids).datagrid('getPager');
        opts.pageNumber = 1;
        opts.pageSize = opts.pageSize;
        pager.pagination('refresh', {
            pageNumber: 1,
            pageSize: opts.pageSize
        });
    }
    //查询及返回刷新
    function searchDevData() {
        //组织查询条件
        var params = {};
        $(".query").each(function () {
            if ($(this).val() != "") {
                params[$(this).attr("id")] = $(this).val();
            }
        });
        //必须条件
        queryParams = params;
        $("#backapp_grid").datagrid('reload', queryParams);
    }

    // 显示验收标准
    function showCheckStandard() {
    	popWindow('${pageContext.request.contextPath}/dmsManager/check/checkstandard.jsp', "950:190", "-验收标准");
    }
    
  	//加载附件
    function loadDocList(ck_id){
    	$("#attachement").attr("src",'${pageContext.request.contextPath}/doc/common/common_doc_list.jsp?relationId='+ck_id);
    }
  	// 加载供货商评价
    function loadCsiInfo(ck_id) {
        var retObj = jcdpCallService("CheckPersonDev", "getCheckCsiInfo", "ck_id=" + ck_id);
        var dictionary =
        {
       	"1": "非常满意",
       	"2": "满意",
       	"3": "一般",
       	"4": "不满意",
       	"5": "非常不满意",
        };
        if (typeof retObj.data != "undefined") {
            var data = retObj.data;
            $(".main").each(function () {
                var temp = this.id;
                $("#" + temp).val(data[temp] != undefined ? data[temp] : "");
                if (temp == 'ck_company_score') {
                    $('#ck_company_score').val(data[temp] != undefined ? dictionary[data[temp]] : "");
                }
            });
        }
    }
  	//选择机构树
	function showOrgTreePage1(){
		var returnValue=window.showModalDialog("<%=contextPath%>/rm/dm/deviceAccount/selectOrgHR2.jsp?codingSortId=0110000001","test","");
		var strs= new Array(); //定义一数组
		if(!returnValue){
			return;
		}
		strs = returnValue.split("~"); //字符分割
		var names = strs[0].split(":");
		var id = strs[1].split(":");
		document.getElementById("ck_sectors").value = names[1];
		document.getElementById("ck_sector").value = id[1];
	}
</script>
</html>