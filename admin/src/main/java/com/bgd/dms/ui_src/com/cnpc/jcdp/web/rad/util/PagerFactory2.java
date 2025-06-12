package com.cnpc.jcdp.web.rad.util;


import com.cnpc.jcdp.web.rad.page.AddCpmxPager;
import com.cnpc.jcdp.web.rad.page.BasePager;
import com.cnpc.jcdp.web.rad.page.EditCpmxPager;
import com.cnpc.jcdp.web.rad.page.EntityAndItemsPager;
import com.cnpc.jcdp.web.rad.page.ViewCpmxPager;
import com.cnpc.jcdp.web.rad.template.BaseTmpt;
import com.cnpc.jcdp.web.rad2.page.AddPager2;
import com.cnpc.jcdp.web.rad2.page.EditPager2;
import com.cnpc.jcdp.web.rad2.page.List2LinkPager2;
import com.cnpc.jcdp.web.rad2.page.ListSelectPager2;
import com.cnpc.jcdp.web.rad2.page.QueryListPager2;
import com.cnpc.jcdp.web.rad2.page.ViewPager2;

public class PagerFactory2 extends PagerFactory {
	/**
	 * 获取相应的pager处理器
	 * @param stlReq
	 * @return
	 */
	public static BasePager getPMDPager(PMDRequest stlReq){
		String pmdAction = stlReq.getTlHd().getSingleNodeValue("//PagerAction");
		BasePager pager = null;
	
		//CRU页面
		if("Edit".equals(pmdAction)||"CRU".equals(pmdAction)){
			if("edit2Add".equals(stlReq.getPagerAction())){
				stlReq.setFileName(convertFileName(stlReq.getFileName(),"edit","add"));
				pager = new AddPager2();				
			}				
			else if("edit2Edit".equals(stlReq.getPagerAction())){
				pager = new EditPager2();				
			}	
			else{//默认进入查看页面 
				stlReq.setFileName(convertFileName(stlReq.getFileName(),"edit","view"));
				pager = new ViewPager2();	
			}
		}		
		//主子表CRU页面，同一页面对主子表进行操作
		else if("CmpxEntityCRU".equals(pmdAction)){
			if("edit2Add".equals(stlReq.getPagerAction())){
				stlReq.setFileName(convertFileName(stlReq.getFileName(),"edit","add"));
				pager = new AddCpmxPager();				
			}				
			else if("edit2Edit".equals(stlReq.getPagerAction())){
				pager = new EditCpmxPager();				
			}	
			else{//默认进入查看页面 
				stlReq.setFileName(convertFileName(stlReq.getFileName(),"edit","view"));
				pager = new ViewCpmxPager();					
			} 	
		}	
		//主从表显示页面
		else if("EntityAndItems".equals(pmdAction)){
			if("listItems".equals(stlReq.getPagerAction())){
				pager = new QueryListPager2();
			}
			else pager = new EntityAndItemsPager();			
		}
		else if("ListSelect".equals(pmdAction))	pager = new ListSelectPager2();		
		else if("List2Link".equals(pmdAction)) pager = new List2LinkPager2();	
		//列表页面
		else pager = new QueryListPager2();	
		
//		BaseTmpt tpt = getBaseTmpt(pmdAction,tptId);
//		tpt.setPager(pager);
//		pager.setTpt(tpt);			
		return pager;
	}
	
	@SuppressWarnings("unused")
	private static BaseTmpt getBaseTmpt(String pmdAction,String tptId){
		BaseTmpt ret = null;	
//		BaseTmptFactory tptFact = tptId==null?null:getTmptFactories().get(tptId);
//		if(tptFact==null) tptFact = getTmptFactories().get(defaultTptCode);
//		
//		if("Edit".equals(pmdAction)||"CRU".equals(pmdAction))
//			ret = tptFact.createCRUTmpt(); 
//		else if("CmpxEntityCRU".equals(pmdAction)) 
//			ret = tptFact.createCmpxCRUTmpt(); 
//		else if("ListSelect".equals(pmdAction))
//			ret = tptFact.createList2SelectTmpt();
//		else if("List2Link".equals(pmdAction))
//			ret = tptFact.createList2LinkTmpt();
//		else if("EntityAndItems".equals(pmdAction))
//			ret = tptFact.createEntityAndItemsTmpt();				
//		else ret = tptFact.createListTmpt();
		return ret;
	}
	
	private static String convertFileName(String fileName,String regex, String replacement){
		String[] strs = fileName.split("/");
		String pureFileName = strs[strs.length-1];
		if(pureFileName.startsWith(regex)) pureFileName = replacement+pureFileName.substring(4);
		else pureFileName = replacement+"_"+pureFileName;
		StringBuffer sb = new StringBuffer();
		for(int i=1;i<=strs.length-2;i++) sb.append("/"+strs[i]);
		sb.append("/"+pureFileName);	
		return sb.toString();
	}
	
}
