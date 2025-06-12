/**
 * 
 */
package com.cnpc.jcdp.web.rad.template;

import com.cnpc.jcdp.web.rad.tmpt.wrms.CRUTmpt;
import com.cnpc.jcdp.web.rad.tmpt.wrms.ListSelectTmpt;
import com.cnpc.jcdp.web.rad.tmpt.wrms.ListTmpt;

/**
 * @author rechete
 *
 */
public class WRMSTmptFactory extends BaseTmptFactory{
	public BaseTmpt createListTmpt(){
		return new ListTmpt();
	}
	
	public BaseTmpt createCRUTmpt(){
		return new CRUTmpt();
	}
	
	public BaseTmpt createCmpxCRUTmpt(){
		return new DefaultCmpxCRUTmpt();
	}
	
	public BaseTmpt createList2SelectTmpt(){
		return new ListSelectTmpt();
	}
	
	public BaseTmpt createList2LinkTmpt(){	
		return new ListTmpt();
	}	
	
	public BaseTmpt createEntityAndItemsTmpt(){	
		return new ListTmpt();
	}	
}
