/**
 * 主子表页面2
 * 主子表在同一编辑页面
 */
package com.cnpc.jcdp.web.rad.page;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.util.RADConst;

/**
 * @author rechete
 *
 */
public class ViewCpmxPager extends EditCpmxPager{ 
	public ViewCpmxPager(){
		pmdAction = RADConst.PMDAction.C_R;
	}
  	protected void printSubmitJs()throws IOException{
  		
  	}
  	
  	protected void printOtherJs()throws IOException{
  		println("");
  		println("function initItems(itemDatas){");
  		println("\tif(cruConfig.cruAction!='view' && (itemDatas==undefined || itemDatas.length==0)){");
  		println("\t\taddItem();");
  		println("\t\treturn;");
  		println("\t}");
  		println("");
  		println("\tvar itemsTable = getObj(\"itemsTable\");");
  		println("\tfor(var i=0;i<itemDatas.length;i++){");
  		println("\t\taddItem();");
  		println("\t\tvar vTr = itemsTable.rows[itemsTable.rows.length-1];");
  		println("\t\tfor(var j=0;j<vTr.all.length;j++){");
  		println("\t\t\tvar obj = vTr.all(j);");
  		println("\t\t\tif (obj.tagName == \"INPUT\" && obj.name!=null) {");
  		println("\t\t\t\tobj.value = eval('itemDatas[i].'+obj.name);");
  		println("\t\t\t\tobj.readOnly = true;");
  		println("\t\t\t}");
  		println("\t\t}");
  		println("\t}");  		
  		println("}");
  		println("");
  	}  	
}
