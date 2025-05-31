<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.cnpc.jcdp.common.UserToken"%>
<%@page import="com.cnpc.jcdp.webapp.util.OMSMVCUtil"%>
<%
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="<%=contextPath%>/styles/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%=contextPath%>/js/jquery-1.7.1.min.js"></script>
    <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
    <script type="text/javascript" src="<%=contextPath%>/js/gms_list.js"></script>
    <script type="text/javascript" src="<%=contextPath%>/js/dialog_open1.js"></script>
    <title>查询条件</title>
</head>
<body class="bgColor_f3f3f3">
    <form name="form1" id="form1" method="post" action="">
        <input type="hidden" id="detail_count" value="" />
        <div id="new_table_box">
            <div id="new_table_box_content">
                <div id="new_table_box_bg">
                    <table id="table1" width="100%" border="0" cellspacing="0" cellpadding="0" class="tab_line_height">
                      <tr>
                            <td class="inquire_item4">报废单号:</td>
                            <td class="inquire_form4">
                                <input id="s_scrape_apply_no" name="s_scrape_apply_no" type="text" class="input_width" />
                             </td>
                            <td class="inquire_item4">批复单号:</td>
                            <td class="inquire_form4">
                                <input id="s_scrape_report_no" name="s_scrape_report_no" type="text" class="input_width" />
                            </td>
                       </tr>
                       <tr>
                            <td class="inquire_item4">报废原因:</td>
                            <td class="inquire_form4">
                                 <select name="s_scrape_type" id="s_scrape_type" style="width: 197px;">
			    					<option value="">--请选择--</option>
			    					<option value="0">正常报废</option>
			    					<option value="1">技术淘汰</option>
			    					<option value="2">毁损</option>
			    					<option value="3">盘亏</option>
			    				</select>
                             </td>
                            <td class="inquire_item4">资产状况:</td>
                            <td class="inquire_form4">
                                 <select name="s_account_stat" id="s_account_stat" style="width: 197px;">
            						<option value="">--请选择--</option>
      								<option value="0110000013000000001">报废</option>
      								<option value="0110000013000000002">已处置</option>
      								<option value="0110000013000000003">在账</option>
	            				</select>
                            </td>
                       </tr>
                       <tr>
                            <td class="inquire_item4">设备名称:</td>
                            <td class="inquire_form4">
                                <input id="dev_name" name="dev_name" class="input_width" type="text" />
                                </td>
                            <td class="inquire_item4">规格型号:</td>
                            <td class="inquire_form4">
                                <input id="dev_model" name="dev_model" class="input_width" type="text" />
                            </td>
                        </tr>
                        <tr>
                            <td class="inquire_item4">实物标识号:</td>
                            <td class="inquire_form4">
                                <input id="dev_sign" name="dev_sign" class="input_width" type="text" />
                            </td>
                            <td class="inquire_item4">自编号:</td>
                            <td class="inquire_form4">
                                <input id="self_num" name="self_num" class="input_width" type="text" />
                            </td>

                        </tr>
                        <tr>
                            <td class="inquire_item4">牌照号:</td>
                            <td class="inquire_form4">
                                <input id="license_num" name="license_num" class="input_width" type="text" />
                            </td>
                            <td class="inquire_item4">AMIS资产编号:</td>
                            <td class="inquire_form4">
                                <input id="asset_coding" name="asset_coding" class="input_width" type="text" />
                            </td>
                        </tr>
                        <tr>
                            <td class="inquire_item4">数据来源:</td>
                            <td class="inquire_form4">
                                <select name="source_from" id="source_from" class="select_width">
                                    <option value="">--请选择--</option>
                                    <option value="0">经批复</option>
                                    <option value="1">未经批复</option>
                                </select>
                            </td>
                            <td class="inquire_item4">设备类型:</td>
                            <td class="inquire_form4">
                                <input id="dev_type_name" name="dev_type_name" class="input_width" type="text" />
                                <input id="dev_type" name="dev_type" class="input_width" type="hidden" />
                                <img src="<%=contextPath%>/images/magnifier.gif" width="16" height="16"
                                    style="cursor:pointer;" onclick="showDevTreePage()" />
                            </td>
                        </tr>
                        <tr>
                            <td class="inquire_item4">设备名称</td>
                            <td class="inquire_form4">
                                <input id="s_dev_name" name="s_dev_name" class="input_width" type="text" />
                            </td>
                            <td class="inquire_item4">设备编号</td>
                            <td class="inquire_form4">
                                <input id="s_dev_coding" name="s_dev_coding" class="input_width" type="text" />
                            </td>
                        </tr>
                        <tr>
                            <td class="inquire_item4">设备编码</td>
                            <td class="inquire_form4">
                                <input id="s_dev_type" name="s_dev_type" class="input_width" type="text" />
                            </td>
                            <td class="inquire_item4">资产编码</td>
                            <td class="inquire_form4">
                                <input id="s_asset_coding" name="s_asset_coding" class="input_width" type="text" />
                            </td>
                        </tr>
                        <tr>
                            <td class="inquire_item4">所属单位</td>
                            <td class="inquire_form4">
                                <input id="s_org_name" name="s_org_name" class="input_width" type="text" />
                            </td>
                            <td class="inquire_item4">评审时间：</td>
                            <td class="inquire_form4" class="select_width">
                                <select id="collect_date" name="collect_date" class="select_width">
                                    <option value="">全部</option>
                                    <option value="2013">2013</option>
                                    <option value="2014">2014</option>
                                    <option value="2015">2015</option>
                                    <option value="2016">2016</option>
                                    <option value="2017">2017</option>
                                    <option value="2018">2018</option>
                                    <option value="2019">2019</option>
                                    <option value="2020">2020</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                </div>
                <div id="oper_div">
                    <span class="tj_btn"><a href="#" onclick="submitInfo()"></a></span>
                    <span class="gb_btn"><a href="#" onclick="newClose()"></a></span>
                </div>
            </div>
        </div>
    </form>
</body>
<script type="text/javascript">
    $().ready(function () {
        $("#addProcess").click(function () {
            tr_id = $("#processtable>tbody>tr:last").attr("id");
            if (tr_id != undefined) {
                tr_id = parseInt(tr_id.substr(2, 1), 10);
            }
            if (tr_id == undefined) {
                tr_id = 0;
            } else {
                tr_id = tr_id + 1;
            }
            //统计本次的总行数
            $("#detail_count").val(tr_id);
            //动态新增表格
            var innerhtml = "<tr id = 'tr" + tr_id + "' ><td><input type='checkbox' name='idinfo' id='" + tr_id + "'/><input name='devicename" + tr_id + "' value='通过设备编码树选择设备名称' size='12' type='text'/></td><td><input name='devicetype" + tr_id + "' class='input_width' value='设备名称带出类型' size='12' type='text'/></td><td><input name='signtype" + tr_id + "' class='input_width' value='名称和类型带出类别' size='12' type='text'/></td><td><input name='unit" + tr_id + "' class='input_width' type='text'/></td><td><input name='neednum" + tr_id + "' class='input_width' value='' size='8' type='text'/></td><td><input name='team" + tr_id + "' class='input_width' type='text'/></td><td><input name='purpose" + tr_id + "' class='input_width' value='' size='8' type='text'/></td><td><input name='startdate" + tr_id + "' class='input_width' type='text'/></td><td><input name='enddate" + tr_id + "' class='input_width' type='text'/></td></tr>";

            $("#processtable").append(innerhtml);
            if (tr_id % 2 == 0) {
                $("#processtable>tbody>tr[id='tr" + tr_id + "']>td:odd").addClass("odd_odd");
                $("#processtable>tbody>tr[id='tr" + tr_id + "']>td:even").addClass("odd_even");
            } else {
                $("#processtable>tbody>tr[id='tr" + tr_id + "']>td:odd").addClass("even_odd");
                $("#processtable>tbody>tr[id='tr" + tr_id + "']>td:even").addClass("even_even");
            }
        });
        $("#delProcess").click(function () {
            $("input[name='idinfo']").each(function () {
                if (this.checked) {
                    var selected_id = this.id;
                    $('#tr' + selected_id).remove();
                }
            });
        });
    });
    function init() {
        var ctt = parent.frames['list'];
        document.getElementById("dev_name").value = ctt.document.getElementById("s_dev_name").value;
        document.getElementById("dev_model").value = ctt.document.getElementById("s_dev_model").value;
    }
    /**
     * 选择设备树
    **/
    function showDevTreePage() {
        //window.open("<%=contextPath%>/rm/dm/deviceAccount/selectOrg.jsp","test",'toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no,depended=no')
        var returnValue = window.showModalDialog("<%=contextPath%>/rm/dm/tree/selectDeviceTreeForSubNode.jsp", "test", "");
        if (returnValue == undefined) {
            return;
        }
        var strs = new Array(); //定义一数组
        strs = returnValue.split("~"); //字符分割
        var names = strs[0].split(":");
        var name = names[1].split("(")[0];

        //判断是否是根节点
        if (names[1].split("(").length > 1) {
            name = name + "(" + names[1].split("(")[1].split(")")[0] + ")";
        }

        $("#dev_type_name").val(name);
        var codes = strs[1].split(":");
        var code = codes[1];
        code = code.replace('S', '')
        $("#dev_type").val('S' + code);
    }
    function submitInfo() {
        var arrayObj = new Array();
		var objApp= new Array();
		objApp.push({ "label":"app.scrape_apply_no","value":$("#s_scrape_apply_no").val()});
		var objRep= new Array();
		objRep.push({ "label":"rep.scrape_report_no","value":$("#s_scrape_report_no").val()});
		
		arrayObj.push({ "label":"scrape_type","value":$("#s_scrape_type").val()});
		arrayObj.push({ "label":"account_stat","value":$("#s_account_stat").val()});
        arrayObj.push({ "label": "dev_type", "value": $("#dev_type").val() });
        arrayObj.push({ "label": "dev_name", "value": $("#dev_name").val() });
        arrayObj.push({ "label": "dev_model", "value": $("#dev_model").val() });
        arrayObj.push({ "label": "license_num", "value": $("#license_num").val() });
        arrayObj.push({ "label": "asset_coding", "value": $("#asset_coding").val() });
        arrayObj.push({ "label": "dev_sign", "value": $("#dev_sign").val() });
        arrayObj.push({ "label": "self_num", "value": $("#self_num").val() });
        arrayObj.push({ "label": "source_from", "value": $("#source_from").val() });
        
        arrayObj.push({ "label": "dev_name", "value": $("#s_dev_name").val() });
        arrayObj.push({ "label": "dev_type", "value": $("#s_dev_type").val() });
        arrayObj.push({ "label": "dev_coding", "value": $("#s_dev_coding").val() });
        arrayObj.push({ "label": "asset_coding", "value": $("#s_asset_coding").val() });
        arrayObj.push({ "label": "org_name", "value": $("#s_org_name").val() });
        arrayObj.push({ "label": "collect_date", "value": $("#collect_date").val() });
		 
        var indexFrame = top.document.getElementById('indexFrame');
        var list = indexFrame.contentWindow.document.getElementById('list');
        list.contentWindow.refreshData(arrayObj,objApp,objRep);
        newClose();
    }
</script>
</html>

