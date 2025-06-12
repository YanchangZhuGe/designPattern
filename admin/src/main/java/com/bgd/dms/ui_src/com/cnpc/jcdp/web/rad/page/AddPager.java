/**
 *
 * 单个实体的新增页面
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.RADConst.PAGER_OPEN_TYPE;

/**
 * @author rechete
 *
 */
public class AddPager extends EditPager{	
	public AddPager(){
		pmdAction = RADConst.PMDAction.S_C;
	}
	
  	protected void printPageInit()throws IOException{
  		if(pmdJsFuncNames.get("page_init()")!=null) return;
  		print("\r\n");
        print("function page_init(){\r\n");
        print("\tgetObj('cruTitle').innerHTML = cruTitle;\r\n");
        print("\tcruConfig.contextPath = \"");
        print(contextPath);
        print("\";\r\n");
        String backUrl = request.getParameter("backUrl");
        if(backUrl!=null)
        	println("\tcruConfig.openerUrl = \""+request.getParameter("backUrl")+"\";");
        if("1".equals(lineRange))
        	print("\tcruConfig.lineRange = '1';\r\n");        
        print("\tcru_init();\r\n");
        print("}\r\n");  		
  	} 
  	
/*  	protected void printSubmitJs()throws IOException{
  		if(pmdJsFuncNames.get("submitFunc()")!=null) return;
        print("\r\n");
        print("function submitFunc(){\r\n");
        //多表修改
        if(tlHd.selectNodes("//Tables/Table")!=null){
        	println("	var submitStr = \"jcdp_tables=\"+tables.toJSONString();");
			println("	for(var i=0;i<tables.length;i++){");
			println("	  var tableName = tables[i][0];");
			println("	  var tSubmitStr = '';");
			println("	  if(tableName==defaultTableName) tSubmitStr = getSubmitStr();");
			println("	  else 	tSubmitStr = getSubmitStr(tableName);");
			println("		submitStr += \"&\"+tableName+\"=\"+submitStr2Array(tSubmitStr).toJSONString();");
			println("	}");
			println("	");
			println("	var path = cruConfig.contextPath+cruConfig.addMulTableAction;");
			println("	var retObject = syncRequest('Post',path,submitStr);");
        }else{//单表修改        
	        print("\tvar path = cruConfig.contextPath+cruConfig.addAction;\r\n");
	        print("\tsubmitStr = getSubmitStr();\r\n");
	        print("\tif(submitStr == null) return;\r\n");        
	        print("\tvar retObject = syncRequest('Post',path,submitStr);\r\n");
        }
        println("\tafterSubmit(retObject);");
        print("}\r\n");
        print("\r\n"); 	
  	}*/
}
