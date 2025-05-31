<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
	String str = "测试";
%>
<chart caption='<%=str%>' 
   xAxisName='Week' yAxisName='Sales' numberPrefix='$'> 
      <set label='Week 1' value='14400' /> 
      <set label='Week 2' value='19600' /> 
      <set label='Week 3' value='24000' /> 
      <set label='Week 4' value='15700' /> 
</chart>