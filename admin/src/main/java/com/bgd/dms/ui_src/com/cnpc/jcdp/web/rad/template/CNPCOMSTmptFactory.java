/**
 * 
 */
package com.cnpc.jcdp.web.rad.template;

/**
 * @author rechete
 *
 */
public class CNPCOMSTmptFactory extends BaseTmptFactory{
	public BaseTmpt createListTmpt(){
		return new CNPCOMSListTmpt();
	}
	
	public BaseTmpt createCRUTmpt(){
		return new CNPCOMSCRUTmpt();
	}
	
	public BaseTmpt createCmpxCRUTmpt(){
		return new DefaultCmpxCRUTmpt();
	}
	
	public BaseTmpt createList2SelectTmpt(){
		return new CNPCOMSListTmpt();
	}
	
	public BaseTmpt createList2LinkTmpt(){	
		return new CNPCOMSListTmpt();
	}	
}
