/**
 * 
 */
package com.cnpc.jcdp.web.rad.template;

import java.io.IOException;

import com.cnpc.jcdp.web.rad.page.AbstractPager;
import com.cnpc.jcdp.web.rad.page.BasePager;
import com.cnpc.jcdp.web.rad.util.RADConst.PAGER_OPEN_TYPE;
import com.cnpc.jcdp.web.rad.util.RADConst.QUERY_CDT_TYPE;
import com.cnpc.jcdp.web.rad.util.RADConst.RECORD_SEL_TYPE;

/**
 * @author rechete
 *
 */
public abstract class BaseTmpt {
	protected BasePager pager;
	protected PAGER_OPEN_TYPE open_type = PAGER_OPEN_TYPE.POP;//POP 弹出页面,LINK 本页面跳转
	protected QUERY_CDT_TYPE cdt_type = QUERY_CDT_TYPE.SELECT;
	protected RECORD_SEL_TYPE sel_type = RECORD_SEL_TYPE.Checkbox;
	
	public RECORD_SEL_TYPE getSel_type() {
		return sel_type;
	}

	public void setSel_type(RECORD_SEL_TYPE sel_type) {
		this.sel_type = sel_type;
	}

	public QUERY_CDT_TYPE getCdt_type() {
		return cdt_type;
	}
	

	/**
	 * for query list page
	 * @return
	 */
	public PAGER_OPEN_TYPE getOPEN_TYPE() {
		return open_type;
	}

	public void setPager(BasePager pager) {
		this.pager = pager;
	}
	
	public abstract void printHeader()throws IOException;
	

	public abstract void printBody()throws IOException;
	
	public String getParentRefreshFunc(){
		return "window.opener.refreshData();";
	}
	
	public String getWindowCloseFunc(){
		return "window.close();";
	}

}
