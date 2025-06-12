/**
 * Õ‚º¸—°‘Ò“≥√Ê
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.RADConst.LISTTYPE;

/**
 * @author rechete
 *
 */
public class List2LinkPager extends QueryListPager{
	public List2LinkPager(){
		pmdAction = RADConst.PMDAction.L2L;
	}
	
	protected void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception{
    	super.initPager(request, response);
    	listType = LISTTYPE.List2Link;
    }
	
	protected void printJavaScript(HttpServletRequest request)throws IOException{
		String rowSelFuncName = tlHd.getSingleNodeValue("//RowSelFuncName");
		if(rowSelFuncName==null) rowSelFuncName = "onRowSelect";
		println("var rowSelFuncName='"+rowSelFuncName+"';");
		super.printJavaScript(request);
	}
}
