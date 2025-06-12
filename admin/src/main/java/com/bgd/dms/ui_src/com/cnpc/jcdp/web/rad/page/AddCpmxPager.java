/**
 * 主子表页面2
 * 主子表在同一编辑页面
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.util.RADConst;

/**
 * @author rechete
 *
 */
public class AddCpmxPager extends EditCpmxPager{
	public AddCpmxPager(){
		pmdAction = RADConst.PMDAction.C_C;
	}
	
  	protected void printPageInit()throws IOException{
  		print("\r\n");
        print("function page_init(){\r\n");
        print("\tgetObj('cruTitle').innerHTML = cruTitle;\r\n");
        print("\tcruConfig.contextPath = \"");
        print(contextPath);
        print("\";\r\n");
        if("1".equals(lineRange))
        	print("\tcruConfig.lineRange = '1';\r\n");        
        print("\tcru_init();\r\n");
        print("\taddItem();\r\n");
        print("}\r\n");  		
  	} 
  	
  	protected void printSubmitJs()throws IOException{
        print("\r\n");
        print("function submitFunc(){\r\n");
        print("\tvar path = cruConfig.contextPath+cruConfig.addCmpxAction;\r\n");
        print("\tsubmitStr = getSubmitStr();\r\n");
        print("\tif(submitStr == null) return;\r\n"); 
        println("\tsubmitStr = \"entityParam=\"+convertSubmitStr2JSONObj(submitStr).toJSONString();");
        println("\tvar itemsParam = getItemsParam();");
        println("\tsubmitStr += \"&itemsParam=\"+itemsParam.toJSONString();");
        String itemTableName = tlHd.getSingleNodeValue("QueryItemsSQL/tableName");
        String itemTableFk = tlHd.getSingleNodeValue("QueryItemsSQL/fkName");
        println("\tsubmitStr += \"&itemTableName="+itemTableName+"&itemTableFk="+itemTableFk+"\";");
        print("\tvar retObject = syncRequest('Post',path,submitStr);\r\n");
        print("\tif (retObject.returnCode != \"0\") alert(\"新增失败!\");\r\n");
        print("\telse{\r\n");
        print("\t\talert(\"新增成功!\");\r\n");
        print("\t\twindow.opener.refreshData();\r\n");
        print("\t\twindow.close();\r\n");
        print("\t}\r\n");
        print("}\r\n");
        print("\r\n");  	
  	}

  	protected void printOtherJs()throws IOException{
  		
  	}
}
