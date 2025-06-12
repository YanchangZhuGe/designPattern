/**
 * ���ӱ�ҳ��2
 * ���ӱ���ͬһ�༭ҳ��
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
public class ViewPager extends EditPager{ 
	public ViewPager(){
		pmdAction = RADConst.PMDAction.S_R;
	}
	
  	protected void printSubmitJs()throws IOException{
  		
  	}
  	
  	protected void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception{
  		super.initPager(request,response);
  		if("true".equals(request.getParameter("noSubmit"))) noSubmitButton = true;
  	}
}
