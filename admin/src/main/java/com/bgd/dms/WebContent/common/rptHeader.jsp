<%
    String contextPath = request.getContextPath();
    String firstPageImage = "<img src='" + contextPath + "/images/firstPage.gif' width='35' height='26' border='0'/>";
	String lastPageImage = "<img src='" + contextPath + "/images/lastPage.gif' width='35' height='26' border='0'/>";
	String nextPageImage = "<img src='" + contextPath + "/images/nextPage.gif' width='35' height='26' border='0'/>";
	String prevPageImage = "<img src='" + contextPath + "/images/prevPage.gif' width='35' height='26' border='0'/>";
    String wordImage = "<img src='" + contextPath + "/images/word.gif' width='60' height='30' border='0'/>";
    String printImage = "<img src='" + contextPath + "/images/print.gif' width='60' height='30' border='0'/>";
    String excelImage = "<img src='" + contextPath + "/images/xls.gif' width='60' height='30' border='0'/>";
	String pdfImage = "<img src='" + contextPath + "/images/pdf.gif' width='60' height='30' border='0'/>";
	String rptParams= "";
	if(request.getAttribute("rptParams")!=null){
		rptParams = (String)request.getAttribute("rptParams");
	}
%>  