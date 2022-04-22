<%@ page import="com.bgd.platform.util.service.SpringContextUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fns" uri="/WEB-INF/tlds/fns.tld" %>
<html>
<head>
    <%
        /*String IS_RZPT = (String) (SpringContextUtil.getSysParamMap()).get("IS_RZPT");
        String dir = "";
        if("1".equals(IS_RZPT)){
            dir = "/rzpt";
        }else{
            dir = "/qkj";
        }*/
        //String USER_AG_ISLEAF = request.getSession().getAttribute("AG_ISLEAF").toString();
    %>
    <meta http-equiv="X-UA-Compatible" content="IE=edge;IE=11;IE=9;IE=8;">
    <link rel="SHORTCUT ICON" href="/bgd.ico">
    <meta charset="UTF-8">
    <title>名录维护</title>
    <!--[if lte IE 8]>
    <script>
        if (!Array.prototype.indexOf){
            Array.prototype.indexOf = function(elt /*, from*/){
                var len = this.length >>> 0;

                var from = Number(arguments[1]) || 0;
                from = (from < 0)
                        ? Math.ceil(from)
                        : Math.floor(from);
                if (from < 0)
                    from += len;

                for (; from < len; from++){
                    if (from in this && this[from] === elt)
                        return from;
                }
                return -1;
            };
        }
    </script>
    <![endif]-->
    <%--bootstrap相关start--%>
    <link href="/third/bootstrap/bootstrap-3.3.7/css/bootstrap.css" rel="stylesheet" type="text/css" media="all">
    <script src="/third/js/html5.js"></script>
    <script src="/third/js/respond.js"></script>
    <script src="/third/js/jquery-1.12.3.min.js"></script>
    <script src="/third/bootstrap/bootstrap-3.3.7/js/bootstrap.min.js"></script>
    <%--bootstrap相关end--%>
    <%--bootstrap插件：icheck start--%>
    <link href="/third/bootstrap/icheck/icheck-1.x/skins/all.css" rel="stylesheet">
    <script src="/third/bootstrap/icheck/icheck-1.x/icheck.min.js"></script>
    <%--bootstrap插件：icheck end--%>
    <%--bootstrap插件：bootstrap-select start--%>
    <link rel="stylesheet" href="/third/bootstrap/bootstrap-select-1.12.3/css/bootstrap-select.min.css">
    <script src="/third/bootstrap/bootstrap-select-1.12.3/js/bootstrap-select.min.js"></script>
    <script src="/third/bootstrap/bootstrap-select-1.12.3/js/i18n/defaults-zh_CN.min.js"></script>
    <%--bootstrap插件：bootstrap-select end--%>
    <%--bootstrap插件：bootstrapValidator start--%>
    <link rel="stylesheet" href="/third/bootstrap/bootstrapValidator-0.5.3/css/bootstrapValidator.min.css">
    <script src="/third/bootstrap/bootstrapValidator-0.5.3/js/bootstrapValidator.min.js"></script>
    <script src="/third/bootstrap/bootstrapValidator-0.5.3/js/language/zh_CN.js"></script>
    <%--bootstrap插件：bootstrapValidator end--%>
    <%--插件：弹出层layer start--%>
    <script src="/third/layer/layer-v3.0.3/layer.js"></script>
    <%--插件：弹出层layer end--%>
    <script src="/third/js/json2.js"></script>
    <%--  下拉树控件 --%>
    <link rel="stylesheet" href="/third/bootstrap/bootstrap-treeview/css/bootstrap-treeview.css">
    <script src="/third/bootstrap/bootstrap-treeview/js/bootstrap-treeview.js"></script>

    <%--<script type="text/javascript" src="/js/commonUtil.js"></script>--%>
    <%--<script src="/third/ext5.1/ext-all.js"></script>--%>
    <script src="/third/js/jquery.form.min.js"></script>
    <%--<script src="/third/ext5.1/packages/ext-locale/build/ext-locale-zh_CN.js"></script>--%>
    <%--<script src="/js/plat/Util.js"></script>--%>
    <%--基础数据--%>
    <%--<script src="/js/plat/ele_store.js"></script>--%>
    <script src="/js/debt/ele_data.js"></script>
    <%--<script src="/js/plat/FieldStylePlugin.js"></script>--%>
    <%--<script src="/js/debt/initLeftTree.js"></script>--%>
    <%--封裝表格控件--%>
    <%--<script src="/js/plat/DSYGrid.js"></script>--%>
    <%--<script src="/js/plat/DSYGridV2.0.js"></script>--%>
    <%--封裝搜索控件--%>
    <%--<script src="/js/plat/DSYSearchTool.js"></script>--%>
    <%--封裝附件控件--%>
    <%--<script src="/js/plat/UploadPanel.js"></script>--%>
    <%--弹出选择框--%>
    <%--<script src="/js/debt/PopupGrid.js"></script>--%>
    <%--下拉表格--%>
    <%--<script src="/js/plat/GridCombobox.js"></script>--%>
    <%--引用自定义--%>
    <%--<script src="/js/plat/dateFormat.js"></script>--%>
    <%--<script src="/js/debt/validatorBlank.js"></script>--%>
    <%--<script src="/js/debt/SetItemReadOnly.js"></script>--%>
    <%--<script src="/js/plat/numberFieldFormat.js"></script>--%>
    <%--封装下拉树--%>
    <%--<script src="/js/plat/TreeCombobox.js"></script>--%>
    <%--<script src="/js/plat/WorkFlowHis.js"></script>--%>
    <%--<script src="/js/plat/ClearComboBox.js"></script>--%>
    <%--<script src="/js/plat/initButtonScreen.js"></script>--%>
    <%--工具类--%>
    <script src="/js/debt/Util.js"></script>
    <%--多选下拉框--%>
    <%--<script src="/js/plat/MultiComboBox.js"></script>--%>
    <%--<script src="/config/config_menu_right_debt.js"></script>--%>
    <%--全口径统计校验方法--%>
    <%--<script src="/js/debt/UnifiedCheck_qkj.js"></script>--%>
    <%--加载名录创建json文件--%>
    <script type="text/javascript" src="/json_file/rzpt/mlglCreate.json"></script>

    <%--<link href="/third/ext5.1/packages/ext-theme-crisp/build/resources/ext-theme-crisp-all.css" rel="stylesheet">--%>
    <link href="/css/common.css" rel="stylesheet">
    <link href="/config/config_gray.css" rel="stylesheet">
    <link href="/css/rzpt.css" rel="stylesheet">
    <style>
        html, body {
            width: 100%;
            height: 100%;
            margin: 0px;
            padding: 0px;
            border: 0px;
        }

        span.required {
            color: red;
            font-size: 100%;
        }
        /*主页面*/
        .dsy-container {
            width: 100%;
            height: 100%;
            background-image: url("/image/rzpt/mlgl/bg_mlcreate.jpg");
            background-position: top center;
            background-repeat: no-repeat;
            background-size: 100% 471px;
        }

        /*顶部标题*/
        .header {
            text-align: center;
            height: 150px;
            padding-top: 20px;
            font-size: 50px;
            font-weight: bolder;
            font-family: SimHei;
            color: #0F7CE5;
        }

        .dsy-col-title {

        }

        #title {
            font-size: 30px;
            letter-spacing: 20px;
            line-height: 1.2em;
            font-family: Helvetica;
            /*width: 100%;
            display: block;
            overflow: visible;
            text-shadow: #0F7CE5 1px 1px 0px, #b2b2b2 1px 2px 0;
            word-spacing: 18px;*/
        }

        /*主要内容区域*/
        .content {
            width: 100%;
        }

        .dsy-panel {
            /*border-width: 1px;
            border-style: solid;
            border-color: #7a7a7a;*/
            margin-bottom: 5px;
            box-shadow: 0 0 1px 1px rgba(0, 0, 0, 0.4);
        }

        /*form元素行间距*/
        .form-group {
            margin-bottom: 10px;
        }

        .form-group p.form-control {
            margin-bottom: 0px !important;
        }

        /*icheck元素*/
        .dsy-col-form-icheck {
            padding-top: 7px;
        }

        button.btn-save {
            width: 20%;
            margin-right: 20px;
        }

        button.btn-submit {
            width: 20%;
            margin-left: 20px;
        }

        /*二维码区域*/
        .dsy-col-qr {
            max-width: 320px;
        }

        /*二维码*/
        .qr-code {
            text-align: center;
            padding-top: 20px;
            width: 100%;
        }

        .qr-code > img {
            width: 100%;
        }

        /*二维码提示*/
        .qr-tip {
            width: 100%;
            text-align: center;
        }

        .qr-tip h3 {
            width: 100%;
            font-weight: bolder;
        }

        /*二维码提示随分辨率变化大小*/
        @media screen and (max-width: 1700px) {
            .qr-tip h3 {
                font-size: 22px;
            }
        }

        @media screen and (max-width: 1601px) {
            .qr-tip h3 {
                font-size: 18px;
            }
        }

        @media screen and (max-width: 1401px) {
            .qr-tip h3 {
                font-size: 17px;
            }
        }

        @media screen and (max-width: 1322px) {
            .qr-tip h3 {
                font-size: 14px;
            }
        }
    </style>
    <style>
        /*标题外框*/
        .box7 {
            margin: 20px auto;
            width: 420px;
            min-height: 100px;
            padding: 10px;
            position: relative;
            background: -webkit-gradient(linear, 0% 20%, 0% 92%, from(#fff), to(#f3f3f3), color-stop(.1, #fff));
            border-top: 1px solid #ccc;
            border-right: 1px solid #ccc;
            border-left: 1px solid #ccc;
            -webkit-box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.2);
        }

        .box7:before {
            content: '';
            position: absolute;
            width: 130px;
            height: 30px;
            border-left: 1px dashed rgba(0, 0, 0, 0.1);
            border-right: 1px dashed rgba(0, 0, 0, 0.1);
            background: -webkit-gradient(linear, 555% 20%, 0% 92%, from(rgba(0, 0, 0, 0.1)), to(rgba(0, 0, 0, 0.0)), color-stop(.1, rgba(0, 0, 0, 0.2)));
            -webkit-box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.2);
            -webkit-transform: translate(-50px, 10px) skew(10deg, 10deg) rotate(-50deg)
        }

        .box7:after {
            content: '';
            position: absolute;
            right: 0;
            bottom: 0;
            width: 130px;
            height: 30px;
            background: -webkit-gradient(linear, 555% 20%, 0% 92%, from(rgba(0, 0, 0, 0.1)), to(rgba(0, 0, 0, 0.0)), color-stop(.1, rgba(0, 0, 0, 0.2)));
            border-left: 1px dashed rgba(0, 0, 0, 0.1);
            border-right: 1px dashed rgba(0, 0, 0, 0.1);
            -webkit-box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.2);
            -webkit-transform: translate(50px, -20px) skew(10deg, 10deg) rotate(-50deg)
        }

        .box6 {
            margin: 20px auto;
            width: 400px;
            min-height: 100px;
            padding: 10px;
            position: relative;
            background: -webkit-gradient(linear, 0% 20%, 0% 92%, from(#fff), to(#f3f3f3), color-stop(.1, #fff));
            border-top: 1px solid #ccc;
            border-right: 1px solid #ccc;
            border-left: 1px solid #ccc;
            -webkit-border-top-left-radius: 60px 5px;
            -webkit-border-top-right-radius: 60px 5px;
            -webkit-border-bottom-right-radius: 60px 60px;
            -webkit-box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.3);

        }

        .box6:before {
            content: '';
            width: 25px;
            height: 20px;
            position: absolute;
            bottom: 0;
            right: 0;
            -webkit-border-bottom-right-radius: 30px;
            -webkit-box-shadow: -2px -2px 5px rgba(0, 0, 0, 0.3);
            -webkit-transform: rotate(-20deg) skew(-40deg, -3deg) translate(-13px, -13px);
        }

        .box6:after {
            content: '';
            z-index: -10;
            width: 100px;
            height: 100px;
            position: absolute;
            bottom: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.2);
            display: inline-block;
            -webkit-box-shadow: 20px 20px 8px rgba(0, 0, 0, 0.2);
            -webkit-transform: rotate(0deg) translate(-45px, -20px) skew(20deg);
        }

        .box6_corner_lf {
            width: 100px;
            height: 100px;
            top: 0;
            left: 0;
            position: absolute;
            z-index: -6;
            display: inline-block;
            -webkit-box-shadow: -10px -10px 10px rgba(0, 0, 0, 0.2);
            -webkit-transform: rotate(2deg) translate(20px, 25px) skew(20deg);
        }

        .box6_corner_rt {
            content: '';
            width: 50px;
            height: 50px;
            top: 0;
            right: 0;
            position: absolute;
            display: inline-block;
            z-index: -6;
            -webkit-box-shadow: 10px -10px 8px rgba(0, 0, 0, 0.2);
            -webkit-transform: rotate(2deg) translate(-14px, 20px) skew(-20deg);
        }

        *:before,
        *:after {
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
        }

        .box11, #box11 {
            margin: 40px auto;
            width: 400px;
            min-height: 100px;
            padding: 10px;
            position: relative;
            background: -webkit-gradient(linear, 0% 20%, 0% 92%, from(#f3f3f3), to(#fff), color-stop(.1, #f3f3f3));
            background: -ms-linear-gradient(top, #f3f3f3 20%, #f3f3f3 92%, #fff);
            /* filter: progid:DXImageTransform.Microsoft.gradient(GradientType = 1, startColorstr =#f3f3f3, endColorstr = #fff);*/
            border-top: 1px solid white;
            border-right: 1px solid #ccc;
            -webkit-border-bottom-right-radius: 60px 60px;
            -webkit-box-shadow: -1px 2px 2px rgba(0, 0, 0, 0.2);
            border-bottom-right-radius: 60px 60px;
            box-shadow: -1px 2px 2px rgba(0, 0, 0, 0.2);

        }

        .box11:before, #box11:before {
            content: '';
            width: 25px;
            height: 20px;
            background: white;
            position: absolute;
            bottom: 0;
            right: 0;
            background: -webkit-gradient(linear, 0% 20%, 50% 40%, from(#fff), to(#eee), color-stop(.1, #fff));
            background: -ms-linear-gradient(top, #fff 20%, #fff 40%, #eee);
            -webkit-border-bottom-right-radius: 30px;
            border-bottom-right-radius: 30px;
            -webkit-box-shadow: -2px -2px 5px rgba(0, 0, 0, 0.3);
            box-shadow: -2px -2px 5px rgba(0, 0, 0, 0.3);
            -webkit-transform: rotate(-20deg) skew(-40deg, -3deg) translate(-13px, -13px);
            transform: rotate(-20deg) skew(-40deg, -3deg) translate(-13px, -13px);
        }

        .box11:after, #box11:after {
            content: '';
            z-index: -1;
            width: 100px;
            height: 100px;
            position: absolute;
            bottom: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.2);
            display: inline-block;
            -webkit-box-shadow: 20px 20px 8px rgba(0, 0, 0, 0.2);
            -webkit-transform: rotate(0deg) translate(-45px, -20px) skew(20deg);
            box-shadow: 20px 20px 8px rgba(0, 0, 0, 0.2);
            transform: rotate(0deg) translate(-45px, -20px) skew(20deg);
        }

        .box11_ribbon, #box11_ribbon {
            position: absolute;
            top: -25px;
            left: 30%;
            width: 130px;
            height: 40px;
            background: -webkit-gradient(linear, 555% 20%, 0% 92%, from(rgba(0, 0, 0, 0.1)), to(rgba(0, 0, 0, 0.0)), color-stop(.1, rgba(0, 0, 0, 0.2)));
            border-left: 1px dashed rgba(0, 0, 0, 0.1);
            border-right: 1px dashed rgba(0, 0, 0, 0.1);
            -webkit-box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.2);
            box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.2);
        }

        .box15_ribbon, #box15_ribbon {
            position: absolute;
            top: 0;
            left: 0;
            width: 130px;
            height: 40px;
            background: -webkit-gradient(linear, 555% 20%, 0% 92%, from(rgba(0, 0, 0, 0.1)), to(rgba(0, 0, 0, 0.0)), color-stop(.1, rgba(0, 0, 0, 0.2)));
            background: -ms-linear-gradient(left, rgba(0, 0, 0, 0.0), rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.0));
            border-left: 1px dashed rgba(0, 0, 0, 0.1) !important;
            border-right: 1px dashed rgba(0, 0, 0, 0.1) !important;
            -webkit-box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.2);
            box-shadow: 0px 0px 12px rgba(0, 0, 0, 0.2);
            -webkit-transform: rotate(-30deg) skew(0, 0) translate(-30px, -20px);
            transform: rotate(-30deg) skew(0, 0) translate(-30px, -20px);
        }

        /*标题字体*/
        .hsl {
            color: hsl(203, 100%, 59%);
            text-shadow: 0 0 1px currentColor,
                /*highlight*/ -1px -1px 1px hsl(184, 80%, 50%),
            0 -1px 1px hsl(184, 80%, 55%),
            1px -1px 1px hsl(184, 80%, 50%),
                /*light shadow*/ 1px 1px 1px hsl(184, 80%, 10%),
            0 1px 1px hsl(184, 80%, 10%),
            -1px 1px 1px hsl(184, 80%, 10%),
                /*outline*/ -2px -2px 1px hsl(184, 80%, 15%),
            -1px -2px 1px hsl(184, 80%, 15%),
            0 -2px 1px hsl(184, 80%, 15%),
            1px -2px 1px hsl(184, 80%, 15%),
            2px -2px 1px hsl(184, 80%, 15%),
            2px -1px 1px hsl(184, 80%, 15%),
            2px 0 1px hsl(184, 80%, 15%),
            2px 1px 1px hsl(184, 80%, 15%),
            -2px 0 1px hsl(184, 80%, 15%),
            -2px -1px 1px hsl(184, 80%, 15%),
            -2px 1px 1px hsl(184, 80%, 15%),
                /*dark shadow*/ 2px 2px 2px hsl(184, 80%, 5%),
            1px 2px 2px hsl(184, 80%, 5%),
            0 2px 2px hsl(184, 80%, 5%),
            -1px 2px 2px hsl(184, 80%, 5%),
            -2px 2px 2px hsl(184, 80%, 5%)
        }

        .dsy-ml-title {
            text-align: center;
            color: hsl(203, 100%, 59%);
        }

        @media screen and (max-width: 1500px) {
            html body {
                font-size: 10px;
                line-height: 1;
            }

            .form-group {
                margin-bottom: 5px;
            }

            .btn-mlcreat {
                font-size: 10px;
            }

            .col-sm-2 {
                padding-left: 10px;
                padding-right: 10px;
            }

            .form-control {
                height: 25px;
                padding-top: 4px;
                line-height: 14px;
            }

            .btn-group-lg > .btn, .btn-lg {
                padding-top: 5px;
                padding-bottom: 5px;
            }

            select.form-control {
                padding-top: 0px;
                padding-bottom: 0px;
            }
        }

        .title-style {
            height: 36px;
            background-color: #f5f5f5;
            padding: 8px;
        }

        .title-style span {
            color: #157fcc;
            font-size: 15px;
        }

        .gqjg-fj-style {
            /*
            IE9设置高度百分比不生效
            height: 35%;*/
            height: 220px;
        }

        .panel-body {
            padding: 15px;
            padding-bottom: 10px;
        }
    </style>
</head>
<body>
<script>
    //获取URL参数
    var node_status = "${fns:getParamValue('node_status')}";
    //是否显示股权结构
    var showGqjg = "${fns:getParamValue('showGqjg')}";
    //是否显示附件
    var showFj = "${fns:getParamValue('showFj')}";
    var isLeaf = '${sessionScope.AG_ISLEAF}';
    if(isLeaf == 0){
        var temp = document.createElement("form");
        temp.action = '/page/debt/rzpt/tool/error.jsp';
        temp.target = "_self";
        temp.method = "post";
        temp.style.display = "none";

        var head = document.createElement("textarea");
        head.name = 'head';
        head.value = '提示信息';
        temp.appendChild(head);

        var info = document.createElement("textarea");
        info.name = 'info';
        info.value = '当前单位非底级单位，无需进行名录信息填报！';
        temp.appendChild(info);

        document.body.appendChild(temp);
        temp.submit();
    }
</script>
<div class="container dsy-container container-1366">
    <%--顶部标题--%>
    <!--<div class="row header">
        <div class="col-lg-8 col-lg-offset-2 ">
            <div class="col-lg-9 dsy-col-title">
                &lt;%&ndash;<span id="title">名录维护</span>&ndash;%&gt;
                <div class="box11" id="box11">
                    <h1 class="hsl" id="title">名录维护</h1>
                    <div class="box15_ribbon" id="box15_ribbon"></div>
                </div>
            </div>
        </div>
    </div>-->
    <h1 class="dsy-ml-title" id="title">名录维护</h1>
    <%--主要内容区域--%>
    <div class="row content">
        <div class="col-lg-12">
            <div class="row">
                <%--二维码区域--%>
                <div class="col-lg-2 dsy-col-qr" id="left-qr" style="display: none">
                    <div class="panel dsy-panel">
                        <div class="panel-body">
                            <div class="qr-code">
                                <img src="/image/rzpt/mlgl/mlqr.jpg" alt="二维码">
                            </div>
                            <div class="qr-tip">
                                <h3>在线帮助&nbsp;&nbsp;&nbsp;咨询客服</h3>
                            </div>
                        </div>
                    </div>
                </div>

                <%--表单区域--%>
                <div class="col-lg-5" id="center-panel" style="width: 60%;margin-left: 15%">
                    <div class="panel dsy-panel">
                        <div class="panel-body" id="aaa" style="padding-right: 15%">
                            <%--form表单--%>
                            <form class="form-horizontal content-form" id="mlForm" role="form">
                                <fieldset>
                                    <input type="hidden" class="form-control" name="AD_CODE">
                                    <input type="hidden" class="form-control" name="AG_ID">
                                    <input type="hidden" class="form-control" name="AG_CODE">
                                    <input type="hidden" class="form-control" name="ML_ID">
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" for="AG_NAME">单位名称</label>
                                        <div class="col-sm-8">
                                            <input type="text" placeholder="单位名称" class="form-control" name="AG_NAME" id="AG_NAME">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" for="AD_NAME">所属行政区划</label>
                                        <div class="col-sm-8">
                                            <p class="form-control" name="AD_NAME" id="AD_NAME"></p>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" for="ZGDW"><span class="required">✶</span>主管部门全称</label>
                                        <div class="col-sm-8">
                                            <input type="text" placeholder="主管单位" class="form-control" name="ZGDW" id="ZGDW">
                                        </div>
                                    </div>
                                    <%--<div class="form-group">
                                        <label class="col-sm-4 control-label" for="ZGDWLX_ID"><span class="required">✶</span>单位类型</label>
                                        <div class="col-sm-8">
                                            <select class=" form-control" name="ZGDWLX_ID" id="ZGDWLX_ID" >
                                            </select>
                                        </div>
                                    </div>--%>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" for="ZGDWLX_ID"><span class="required">✶</span>单位类型</label>
                                        <div class="col-sm-8">
                                            <input type="text" id="ZGDWLX_ID" name="ZGDWLX_ID" style="display: none;">
                                            <input type="text" id="ZGDWLX_NAME" name="ZGDWLX_NAME" class="form-control" value=""
                                                   onclick="$('#treeview1').show()" onkeypress="noPermitInput(event)" placeholder="单位类型"
                                                   style="position:relative;z-index: 1;">
                                            <div id="treeview1" class="form-control" onmouseleave="$('#treeview1').hide()"
                                                 style="display: none;position:absolute;left: 15px;top: 25px;z-index: 99;padding: 0px;"></div>

                                            </table>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" for="ZZJG_CODE">组织机构代码</label>
                                        <div class="col-sm-8">
                                            <input type="text" placeholder="组织机构代码" class="form-control" name="ZZJG_CODE" id="ZZJG_CODE"
                                                   onblur="yzMlxx()"> <%--onblur="yzMlxx()"--%>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" for="TYSHXY_CODE"><span class="required">✶</span>统一社会信用代码</label>
                                        <div class="col-sm-8">
                                            <p class="form-control" name="TYSHXY_CODE" id="TYSHXY_CODE"></p>
                                        </div>
                                    </div>
                                    <div class="form-group" style="display: none">
                                        <label class="col-sm-4 control-label"><span class="required">✶</span>有无公益性资本项目</label>
                                        <div class="col-sm-3 dsy-col-form-icheck" id="IS_GYXZBXM">
                                            <input type="radio" name="IS_GYXZBXM" id="IS_GYXZBXM[1]" value="1" checked>
                                            <label for="IS_GYXZBXM[1]">有</label>
                                            <input type="radio" name="IS_GYXZBXM" id="IS_GYXZBXM[0]" value="0">
                                            <label for="IS_GYXZBXM[0]">无</label>
                                        </div>
                                        <%--<label class="col-sm-3 control-label" for="RZPTLX_ID"><span class="required">✶</span>融资平台分类</label>
                                        <div class="col-sm-3">
                                            <select class=" form-control" name="RZPTLX_ID" id="RZPTLX_ID">
                                            </select>
                                        </div>--%>
                                    </div>
                                    <div class="form-group" style="display: none">
                                        <label class="col-sm-4 control-label" for="RZPTLX_ID"><span class="required">✶</span>融资平台分类</label>
                                        <div class="col-sm-4">
                                            <select class=" form-control" name="RZPTLX_ID" id="RZPTLX_ID">
                                            </select>
                                        </div>
                                    </div>
                                    <%-- <div class="form-group">
                                         <label class="col-sm-3 control-label" for="GQLX_ID"><span class="required">✶</span>股权类型</label>
                                         <div class="col-sm-3">
                                             <select class=" form-control" name="GQLX_ID" id="GQLX_ID">
                                                 <option>---请选择---</option>
                                             </select>
                                         </div>
                                         <label class="col-sm-2 control-label" for="HYLY_ID"><span class="required">✶</span>行业领域</label>
                                         <div class="col-sm-3">
                                             <select class=" form-control" name="HYLY_ID" id="HYLY_ID">
                                                 <option>---请选择---</option>
                                             </select>
                                         </div>
                                     </div>--%>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" for="FRDB_NAME"><span class="required">✶</span>法人代表姓名</label>
                                        <div class="col-sm-8">
                                            <input type="text" placeholder="请输入" class="form-control" name="FRDB_NAME" id="FRDB_NAME" >
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" for="FRDB_TEL"><span class="required">✶</span>法人代表联系电话</label>
                                        <div class="col-sm-8">
                                            <input type="text" placeholder="号码格式为:010-00000000或13711111111" class="form-control" name="FRDB_TEL"
                                                   id="FRDB_TEL">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" for="CWFZR_NAME">财务负责人姓名</label>
                                        <div class="col-sm-8">
                                            <input type="text" placeholder="请输入" class="form-control" name="CWFZR_NAME" id="CWFZR_NAME">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" for="CWFZR_TEL">财务负责人联系电话</label>
                                        <div class="col-sm-8">
                                            <input type="text" placeholder="号码格式为:010-00000000或13711111111" class="form-control" name="CWFZR_TEL"
                                                   id="CWFZR_TEL">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label" for="ADDRESS">平台地址</label>
                                        <div class="col-sm-8">
                                            <input type="text" placeholder="请输入" class="form-control" name="ADDRESS" id="ADDRESS" >
                                        </div>
                                    </div>
                                    <div class="form-group" style="display: none">
                                        <label class="col-sm-4 control-label" for="GIS">位置GIS</label>
                                        <div class="col-sm-8">
                                            <input type="text" placeholder="请输入" class="form-control" name="GIS" id="GIS">
                                        </div>
                                       <%-- <label class="col-sm-2 control-label" for="YG_NUM">员工/在校学生数量</label>
                                        <div class="col-sm-3">
                                            <input type="text" placeholder="请输入" class="form-control" name="YG_NUM" id="YG_NUM">
                                        </div>--%>
                                    </div>
                                    <div class="form-group" style="display: none">
                                        <label class="col-sm-4 control-label">
                                            <span class="required">✶</span>是否名录内
                                        </label>
                                        <div class="col-sm-3 dsy-col-form-icheck" id="IS_MLW" style="width: 22%;">
                                            <input type="radio" name="IS_MLW" id="IS_MLW[1]" value="1" checked>
                                            <label for="IS_MLW[1]">是</label>
                                            <input type="radio" name="IS_MLW" id="IS_MLW[0]" value="0">
                                            <label for="IS_MLW[0]">否</label>
                                        </div>
                                    </div>
                                    <div class="form-group" style="display: none">
                                        <label class="col-sm-4 control-label">
                                            <span class="required">✶</span>是否为2013年6月底审计结果确定的融资平台
                                        </label>
                                        <div class="col-sm-8 dsy-col-form-icheck" id="IS_SJQR">
                                            <input type="radio" name="IS_SJQR" id="IS_SJQR[1]" value="1" checked>
                                            <label for="IS_SJQR[1]">是</label>
                                            <input type="radio" name="IS_SJQR" id="IS_SJQR[0]" value="0">
                                            <label for="IS_SJQR[0]">否</label>
                                        </div>
                                    </div>
                                    <div class="form-group" style="display: none">
                                        <label class="col-sm-4 control-label">
                                            <span class="required">✶</span>认定情况
                                        </label>
                                        <div class="col-sm-8" id="RDQK">
                                            <label class="checkbox-inline">
                                                <input type="checkbox" name="IS_MLW" > 政府认定
                                            </label>
                                            <label class="checkbox-inline">
                                                <input type="checkbox" name="IS_SJQR" > 审计认定
                                            </label>
                                            <label class="checkbox-inline">
                                                <input type="checkbox" name="IS_YJRD" id="IS_YJRD"> 银监认定
                                            </label>
                                        </div>
                                    </div>
                                    <div class="form-group" style="display: none">
                                        <label class="col-sm-4 control-label" for="PTZGLX_ID">平台转型方案</label>
                                        <div class="col-sm-8">
                                            <select class=" form-control" name="PTZGLX_ID" id="PTZGLX_ID">
                                            </select>
                                        </div>
                                    </div>
                                        <!--
                                        <label class="col-sm-3 control-label" style="width: 23%;padding-left: 0;padding-right: 0">
                                            <span class="required">✶</span>是否为2013年6月底审计结果确定的融资平台
                                        </label>
                                        <div class="col-sm-2 dsy-col-form-icheck" style="width: 21%">
                                            <input type="radio" name="IS_SJQR" id="IS_SJQR[1]" value="1" checked>
                                            <label for="IS_SJQR[1]">是</label>
                                            <input type="radio" name="IS_SJQR" id="IS_SJQR[0]" value="0">
                                            <label for="IS_SJQR[0]">否</label>
                                        </div>
                                    </div>
                                      -->
                                    <div class="form-group" style="display: none">
                                        <label class="col-sm-4 control-label">
                                            <span class="required">✶</span>是否为2014年底清理甄别确定的融资平台公司
                                        </label>
                                        <div class="col-sm-8 dsy-col-form-icheck" id="IS_QLZBPT">
                                            <input type="radio" name="IS_QLZBPT" id="IS_QLZBPT[1]" value="1">
                                            <label for="IS_QLZBPT[1]">是</label>
                                            <input type="radio" name="IS_QLZBPT" id="IS_QLZBPT[0]" value="0" checked>
                                            <label for="IS_QLZBPT[0]">否</label>
                                        </div>
                                    </div>
                                    <div class="form-group text-center" style="display: none;" id="buttons">
                                        <button id="saveButton" class="btn btn-lg btn-info btn-save btn-mlcreat" onclick="return saveForm();">暂存
                                        </button>
                                        <button id="submitButton" class="btn btn-lg btn-success btn-submit btn-mlcreat"
                                                onclick="return submitForm();" >提交
                                        </button>
                                    </div>
                                </fieldset>
                            </form>
                        </div>
                        <div class="form-group text-center" style="display: none;" id="backButton">
                            <button id="button" name="cancel" class="btn btn-lg btn-info btn-save btn-mlcreat"  onclick="doWorkFlow(this)">撤销提交
                            </button>
                        </div>
                    </div>
                </div>
                <div class="col-lg-2 dsy-col-qr" id="right-qr" style="display: none">
                    <div class="panel dsy-panel">
                        <div class="panel-body">
                            <div class="qr-code">
                                <img src="/image/rzpt/mlgl/mlqr_expired.jpg" alt="二维码">
                            </div>
                            <div class="qr-tip">
                                <h3>在线帮助&nbsp;&nbsp;&nbsp;咨询客服</h3>
                            </div>
                        </div>
                    </div>
                </div>
                <%--股权结构，附件区域--%>
                <%--<div class="col-lg-5" id="right-panel" style="display: none">
                    <div class="panel dsy-panel" id="mlxxTab">
                        <div class="panel-body">
                            &lt;%&ndash;<span>股权结构</span>&ndash;%&gt;
                            <div class="title-style" id="gqjg-title" style="display: none"><span>股权结构</span></div>
                            <div id="gqjg" class="gqjg-fj-style" style="display: none"></div>
                            <div class="title-style" style="margin-top: 5px" id="fj-title" style="display: none"><span>附件上传</span></div>
                            <div id="fj" class="gqjg-fj-style" style="display: none">
                            </div>
                        </div>
                    </div>
                </div>--%>

            </div>
        </div>
    </div>
</div>
<%
    /*String userCode = (String) request.getSession().getAttribute("USERCODE");//获取登录用户
    String ADCODE = (String) request.getSession().getAttribute("ADCODE");//获取登录用户:区划
    String ADNAME = (String) request.getSession().getAttribute("ADNAME");//获取登录用户：区划
    String AGID = (String) request.getSession().getAttribute("AGID");//获取登录用户：单位
    String AGCODE = (String) request.getSession().getAttribute("AGCODE");//获取登录用户：单位
    String AGNAME = (String) request.getSession().getAttribute("AGNAME");//获取登录用户：单位*/
%>
<script>
    //获取用户信息
    var userCode = '${sessionScope.USERCODE}';
    var AD_CODE = '${sessionScope.ADCODE}';
    var AD_NAME = '${sessionScope.ADNAME}';
    var AG_ID = '${sessionScope.AGID}';
    var AG_CODE = '${sessionScope.AGCODE}';
    var AG_NAME = '${sessionScope.AGNAME}';
</script>
<script src="mlglCreate.js"></script>
<script src="/js/debt/UI_Draw_Lite_Bootstrap.js"></script>
</body>
</html>