/**
 * BGPMCS页面模板工厂
 */
package com.cnpc.jcdp.web.rad.tmpt.bgpmcs;

import com.cnpc.jcdp.web.rad.template.BaseTmpt;
import com.cnpc.jcdp.web.rad.template.BaseTmptFactory;
import com.cnpc.jcdp.web.rad.template.DefaultCmpxCRUTmpt;
import com.cnpc.jcdp.web.rad.tmpt.bgpmcs.ListTmpt;

/**
 * @author rechete
 *
 */
public class BGPMCSTmptFactory extends BaseTmptFactory{
	public BaseTmpt createListTmpt(){
		//return null;
		return new ListTmpt();
	}
	
	public BaseTmpt createCRUTmpt(){
		//return null;
		return new CRUTmpt();
	}
	
	public BaseTmpt createCmpxCRUTmpt(){
		//return null;
		return new DefaultCmpxCRUTmpt();
	}
	
	public BaseTmpt createList2SelectTmpt(){
		//return null;
		return new ListSelectTmpt();
	}
	
	public BaseTmpt createList2LinkTmpt(){	
		//return null;
		return new ListTmpt();
	}	
	
	public BaseTmpt createEntityAndItemsTmpt(){
		//return null;
		return new ListTmpt();
	}
}
