/**
 * 
 */
package com.cnpc.jcdp.web.rad.template;

/**
 * @author rechete
 *
 */
public class BaseTmptFactory {
	public BaseTmpt createListTmpt(){
		return new DefaultListTmpt();
	}
	
	public BaseTmpt createCRUTmpt(){
		return new DefaultCRUTmpt();
	}
	
	public BaseTmpt createCmpxCRUTmpt(){
		return new DefaultCmpxCRUTmpt();
	}
	
	public BaseTmpt createList2SelectTmpt(){
		return new DefaultListTmpt();
	}
	
	public BaseTmpt createList2LinkTmpt(){	
		return new DefaultListTmpt();
	}
	
	public BaseTmpt createEntityAndItemsTmpt(){	
		return new DefaultListTmpt();
	}
}
