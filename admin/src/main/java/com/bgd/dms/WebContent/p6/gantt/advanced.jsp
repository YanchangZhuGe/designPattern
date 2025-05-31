<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%
String contextPath = request.getContextPath();
String projectInfoNo = request.getParameter("projectInfoNo");

String rootBackUrl = request.getParameter("rootBackUrl");
String wbsBackUrl = request.getParameter("wbsBackUrl");
String taskBackUrl = request.getParameter("taskBackUrl");

String epsObjectId = request.getParameter("epsObjectId");

String customKey = request.getParameter("customKey");
String customValue = request.getParameter("customValue");

String[] temp = customKey.split(",");
String[] temp1 = customValue.split(",");

int i =0;

String customString = "";

for(;i<temp.length && i <temp1.length; i++) {
	customString += "&"+temp[i]+"="+temp1[i];
}

String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");

String wbsObjectId = request.getParameter("wbsObjectId");
String projectObjectId = request.getParameter("projectObjectId");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <!--Ext and ux styles -->
    <link href="../../js/ext-min/resources/css/ext-all.css" rel="stylesheet" type="text/css" />

	<!--Scheduler styles-->
    <link href="../css/sch-gantt-all.css" rel="stylesheet" type="text/css" />

	<!--Implementation specific styles-->
    <link href="advanced.css" rel="stylesheet" type="text/css" />
    <link href="../css/examples.css" rel="stylesheet" type="text/css" />
      
	<!--Ext lib and UX components-->
    <script src="../../js/ext-min/ext-all.js" type="text/javascript"></script>

	<!--Gantt components-->
    <script src="../gnt-all-debug.js" type="text/javascript"></script>

    <!--Application files-->
    <script src="advanced.js" type="text/javascript"></script>
    
    
    <!--中文语言包-->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
    <script src="../../js/ext-min/locale/ext-lang-zh_CN.js" type="text/javascript"></script>
    <script src="../sch-lang-zh_CN.js" type="text/javascript"></script>
    
    <!--Application files-->
    <script src="DemoGanttPanel.js" type="text/javascript"></script>
    
    <!--rt_base files-->
    <script type="text/javascript" src="<%=contextPath%>/js/rt/rt_base.js"></script>
<script type="text/javascript">
Ext.ns('App');

Ext.Loader.setConfig({ 
    enabled: true, 
    disableCaching : true,
    paths : {
        'Gnt'   : '../../gantt/js/Gnt',
        'Sch'   : '../../gantt/js/Sch',
        'MyApp' : '.'
    }
});

Ext.require([
    'MyApp.DemoGanttPanel'
]);

Ext.onReady(function() {
    Ext.QuickTips.init();
    
    App.Gantt.init();
});

App.Gantt = {
    
    // Initialize application
    init : function(serverCfg) {        
        this.gantt = this.createGantt();
        
        var vp = Ext.create("Ext.Viewport", {
            layout  : 'border',
            items   : [
                {
                    region      : 'north',
                    contentEl   : 'north',
                    bodyStyle   : 'padding:0px'
                },
                this.gantt
            ]
        });
    },
    
    createGantt : function() {
        
        Ext.define('MyTaskModel', {
            extend : 'Gnt.model.Task',

            // A field in the dataset that will be added as a CSS class to each rendered task element
            clsField : 'TaskType',
            fields : [
                {name : 'TaskType', type : 'string'},
                {name : 'orderId',type:'int'},
                {name : 'TaskId', type : 'string'},
                {name : 'other1'},
        		{name : 'isWbs'},
        		{name : 'isRoot'},
        		{name : 'isTask'},
        		{name : 'StartDate', type : 'date', dateFormat : 'Y-m-d' },
        		{name : 'EndDate', type : 'date', dateFormat : 'Y-m-d' },
          		{name : 'BaselineStartDate', type : 'date', dateFormat : 'Y-m-d'},
          		{name : 'BaselineEndDate', type : 'date', dateFormat : 'Y-m-d'},
          		{name : 'plannedStartDate', type : 'string' },
          		{name : 'plannedEndDate', type : 'string' },
          		{name : 'PlannedDuration', type : 'string' },
          		{name : 'RemainingDuration', type : 'string' },
          		{name : 'actualStartDate', type : 'string' },
          		{name : 'actualEndDate', type : 'string' },
          		{name : 'showBaselineStartDate', type : 'string'},
          		{name : 'showBaselineEndDate', type : 'string'}
            ]
        });

        var taskStore = Ext.create("Gnt.data.TaskStore", {
            model : 'MyTaskModel',
            sorters : 'isWbs',
            proxy : {
                type : 'ajax',
                method: 'GET',
                url: '',
                reader: {
                    type : 'json'
                },
                api : {
					read : '<%= contextPath %>/p6/resourceAssignment/getTasksGannt.srq?epsObjectId=<%=epsObjectId %>&projectInfoNo=<%=projectInfoNo%>&projectObjectId=<%=projectObjectId %>&wbsObjectId=<%=wbsObjectId %>&method=load'
				}
            }
        });
        
        var dependencyStore = Ext.create("Gnt.data.DependencyStore", {
            autoLoad : true,
            proxy: {
                type : 'ajax',
                url: '<%= contextPath %>/p6/resourceAssignment/getDependencies.srq?epsObjectId=<%=epsObjectId %>&projectInfoNo=<%=projectInfoNo%>&projectObjectId=<%=projectObjectId %>&wbsObjectId=<%=wbsObjectId %>',
                method: 'GET',
                reader: {
                    type : 'json'
                }
            }
        });
        
        var start = new Date(2010, 0, 1);//2010-01-01
        
        <%
        if (startDate != null && !"".equals(startDate) && startDate != "null"){
      	  //开始时间有值
       %>
       		start = new Date(<%=startDate.subSequence(0,4)%>, <%=Integer.parseInt(startDate.subSequence(5,7).toString())-1%>, <%=startDate.subSequence(8,10)%>);
       		start = Sch.util.Date.add(start, Sch.util.Date.WEEK, -2)
       <%
        }
        %>
         var end = Sch.util.Date.add(start, Sch.util.Date.MONTH, 10);
         
         <%
         if (endDate != null && !"".equals(endDate) && startDate != "null"){
       	  //结束时间有值
        %>
        		end = new Date(<%=endDate.subSequence(0,4)%>, <%=Integer.parseInt(endDate.subSequence(5,7).toString())-1%>, <%=endDate.subSequence(8,10)%>);
        <%
         }
         %>
         end = Sch.util.Date.add(end, Sch.util.Date.MONTH, 2);
        
        var g = Ext.create("MyApp.DemoGanttPanel", {
            region          : 'center',
            selModel        : new Ext.selection.TreeModel({ ignoreRightMouseSelection : false, mode     : 'MULTI'}),
            taskStore       : taskStore,
            dependencyStore : dependencyStore,
            //snapToIncrement : true,    // Uncomment this line to get snapping behavior for resizing/dragging.
            
            startDate       : start, 
            endDate         : end, 
            showBaseline    : true,
            viewPreset      : 'weekAndDayLetter'
        });
        
        g.on({

        	taskcontextmenu : function(gantt,clickedDate){
	        	  //alert(clickedDate.data.Name);
	        	  //alert("1");
	          },
	          select : function(gantt,clickedDate){
		        	    
		          		var isWbs = clickedDate.data.isWbs;
		                var taskObjectId = clickedDate.data.other1;
		                var isRoot = clickedDate.data.isRoot;
		                var isTask = clickedDate.data.isTask;
		                var taskId = clickedDate.data.Id;
		                var taskName = clickedDate.data.Name;
		          		if(isWbs == "true"){
		          			//wbs or root
		          			if(isRoot == "true"){
		          				//root
		          				if('<%=rootBackUrl %>'=='null'){
		          					
		          				} else {
		          					parent.mainDownframe.location.href = "<%= contextPath%><%=rootBackUrl %>?taskObjectId="+taskObjectId+"&taskId="+taskId+"&projectInfoNo=<%=projectInfoNo %>&taskName="+taskName+"<%=customString %>";
		          				}
		          			} else {
		          				//wbs
		          				if('<%=wbsBackUrl %>'=='null'){
		          					
		          				} else {
		          					parent.mainDownframe.location.href = "<%= contextPath%><%=wbsBackUrl %>?taskObjectId="+taskObjectId+"&taskId="+taskId+"&projectInfoNo=<%=projectInfoNo %>&taskName="+taskName+"<%=customString %>";
		          				}
		          			}
		          		} else if (isTask == "true"){
		          			//任务
		          			if('<%=taskBackUrl %>'=='null'){
		          				
		          			} else {
		          				parent.mainDownframe.location.href = "<%= contextPath%><%=taskBackUrl %>?taskObjectId="+taskObjectId+"&taskId="+taskId+"&projectInfoNo=<%=projectInfoNo %>&taskName="+taskName+"<%=customString %>";
		          			}
		          		}
		          },
              scope : this
          });
        
        return g;
    }
};

</script>

  </head>
  
  <body>
    <div id="north">         

    </div>
  </body>
</html>
