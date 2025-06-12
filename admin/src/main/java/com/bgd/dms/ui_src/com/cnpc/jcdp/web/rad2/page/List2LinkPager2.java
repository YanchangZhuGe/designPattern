package com.cnpc.jcdp.web.rad2.page;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.nodes.Element;

import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.RADConst.LISTTYPE;

public class List2LinkPager2 extends QueryListPager2 {
	public List2LinkPager2(){
		pmdAction = RADConst.PMDAction.L2L;
	}

	protected void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception{
    	super.initPager(request, response);
    	listType = LISTTYPE.List2Link;
    }
	
	protected void printJavaScript(Element em, HttpServletRequest request)throws IOException{
		String rowSelFuncName = tlHd.getSingleNodeValue("//RowSelFuncName");
		if(rowSelFuncName==null) rowSelFuncName = "onRowSelect";
		em.appendText("var rowSelFuncName='"+rowSelFuncName+"';\r\n");
		super.printJavaScript(em,request);
	}
}
