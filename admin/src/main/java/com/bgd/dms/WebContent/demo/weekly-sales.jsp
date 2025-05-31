<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

        <title>FusionCharts v3.2 - My First Chart </title>
        <script type="text/javascript" src="${applicationScope.fusionChartsURL}/Charts/FusionCharts.js"></script>

        <link href="${applicationScope.fusionChartsURL}/Code/assets/ui/css/style.css" rel="stylesheet" type="text/css" />

        <!--[if IE 6]>
        <script type="text/javascript" src="../assets/ui/js/DD_belatedPNG_0.0.8a-min.js"></script>

<script>
          /* select the element name, css selector, background etc */
          DD_belatedPNG.fix('img');

          /* string argument can be any CSS selector */
        </script>
        <![endif]-->

        <style type="text/css">
            h2.headline {
                font: normal 110%/137.5% "Trebuchet MS", Arial, Helvetica, sans-serif;
                padding: 0;
                margin: 25px 0 25px 0;
                color: #7d7c8b;
                text-align: center;
            }
            p.small {
                font: normal 68.75%/150% Verdana, Geneva, sans-serif;
                color: #919191;
                padding: 0;
                margin: 0 auto;
                width: 664px;
                text-align: center;
            }
        </style>
    </head>
    <body>

        <div id="wrapper">

            <div id="header">
                

               <div class="logo"><a class="imagelink"  href="http://www.fusioncharts.com" target="_blank"><img src="${applicationScope.fusionChartsURL}/Code/assets/ui/images/fusionchartsv3.2-logo.png" width="131" height="75" alt="FusionCharts v3.2 logo" /></a></div>
				 <h1 class="brand-name">FusionCharts</h1>
                <h1 class="logo-text">My First chart using FusionCharts</h1>
            </div>

            <div class="content-area">
                <div id="content-area-inner-main">
                    <h2 class="headline">My First chart showing Weekly Sales Data</h2>

                    <div class="gen-chart-render">

                        <div id="chartContainer">FusionCharts will load here</div>

                        <script type="text/javascript"><!--

                            var myChart = new FusionCharts( "${applicationScope.fusionChartsURL}/Charts/Column3D.swf", "myChartId", "400", "300", "0", "1" );
                            //myChart.setXMLUrl( "${pageContext.request.contextPath}/demo/FusionChartsDataAction.srq" );
                            myChart.setXMLUrl( "Data.jsp" );
                            //myChart.setXMLUrl( "Data.xml" );
                            myChart.render( "chartContainer" );

                            // -->
                        </script>
                        
                    </div>
                    <div class="clear"></div>
                    <p>&nbsp;</p>
                    <p class="small">    </p>
                    <div class="underline-dull"></div>
                </div>
            </div>
        </div>
    </body>
</html>

