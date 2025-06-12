/**
 * 
 */
package com.cnpc.jcdp.web.rad.util;

import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.web.rad.page.AddCpmxPager;
import com.cnpc.jcdp.web.rad.page.AddPager;
import com.cnpc.jcdp.web.rad.page.BasePager;
import com.cnpc.jcdp.web.rad.page.EditCpmxPager;
import com.cnpc.jcdp.web.rad.page.EditPager;
import com.cnpc.jcdp.web.rad.page.EntityAndItemsPager;
import com.cnpc.jcdp.web.rad.page.List2LinkPager;
import com.cnpc.jcdp.web.rad.page.ListSelectPager;
import com.cnpc.jcdp.web.rad.page.QueryListPager;
import com.cnpc.jcdp.web.rad.page.ViewCpmxPager;
import com.cnpc.jcdp.web.rad.page.ViewPager;
import com.cnpc.jcdp.web.rad.template.BaseTmpt;
import com.cnpc.jcdp.web.rad.template.BaseTmptFactory;
import com.cnpc.jcdp.webapp.srvclient.IServiceCall;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

/**
 * @author rechete
 *
 */
@SuppressWarnings("unchecked")
public class PagerFactory {
	private static ILog log = LogFactory.getLogger(PagerFactory.class);
	private static Map<String,String> options = new Hashtable(); 
	private static Map<String,ICfgNode> codeNodes = new Hashtable(); 
	
	public static Map<String,BaseTmptFactory> tptFacts = new Hashtable();
	public static Map<String,String> tptMainPages = new Hashtable();
	public static String defaultTptCode = null;
	public static String defaultMainPage = null;
	
	static{
		try{
			//String classPath = RADConst.WEB_ROOT+"WEB-INF/classes/";
			ConfigHandler codeHd = ConfigFactory.getXMLHandlerByFilename("codeLib.xml");
			List<ICfgNode> nodes = codeHd.selectNodes("Code");
			for(int i=0;i<nodes.size();i++){
				codeNodes.put(nodes.get(i).getAttrValue("name"), nodes.get(i));
			}
			
			ConfigHandler selectHd = ConfigFactory.getXMLHandlerByFilename("selectLib.xml");
			List<ICfgNode> selNodes = selectHd.selectNodes("Select");
			if(selNodes!=null)
				for(int i=0;i<selNodes.size();i++){
					StringBuffer sb = new StringBuffer();
					ICfgNode selNode = selNodes.get(i);
//					System.out.println(selNode.getAttrValue("name")+"--------------------");
					List<ICfgNode> opNodes = selNode.selectNodes("option");
					for(int j=0;j<opNodes.size();j++){
						ICfgNode opNode = opNodes.get(j);
						if(j>0) sb.append(",");
						sb.append("['"+opNode.getAttrValue("value")+"','"+opNode.getValue()+"']");
					}
					options.put(selNode.getAttrValue("name"), sb.toString());
				}
			
			ConfigHandler cfg = ConfigFactory.getCfgHandler();
			defaultTptCode = cfg.getSingleNodeValue("app_config/default_tmp_code");
			getTmptFactories();
		}catch(Exception ex){
			log.error(ex);
		}
	}
	
	private synchronized static Map<String,BaseTmptFactory> getTmptFactories(){
		if(tptFacts.size()==0){
			try {		
				IServiceCall caller = ServiceCallFactory.getIServiceCall();
				ISrvMsg reqMsg = SrvMsgUtil.createISrvMsg("queryTmpts");
				String url = "RADProdConfig/queryTmpts";
				ISrvMsg resMsg = caller.callWithDTO(null,reqMsg, url);
				List<MsgElement> msgs = resMsg.getMsgElements("tmpts");
				for(int i=0;i<msgs.size();i++){
					try{
						Map map = msgs.get(i).toMap();
						BaseTmptFactory ft = (BaseTmptFactory)Class.forName(map.get("factory_class").toString()).newInstance();
						tptFacts.put(map.get("entity_id").toString(), ft);
						tptMainPages.put(map.get("entity_id").toString(), map.get("main_page").toString());  //加载模板首页
						if(defaultTptCode.equals(map.get("tmpt_code"))) {
							defaultTptCode = map.get("entity_id").toString();
							defaultMainPage = map.get("main_page").toString();
						}
					}catch(Exception ex)
					{
						log.error(ex);
					}
				}
			} catch (Exception e) {
				log.error(e);
			}			
		}
		return tptFacts;
	}
	
	public static ConfigHandler getConfigHandler(String reqFile)throws Exception{
		if(reqFile.startsWith("/") || reqFile.startsWith("\\")) reqFile = reqFile.substring(1);
		
 	    String fullFileName = RADConst.WEB_ROOT+reqFile;
 	    return ConfigFactory.getXMLHandlerByFullFilename(fullFileName);
	}	
	
	public static ICfgNode getCodeNode(String codeName){
		return codeNodes.get(codeName);
	}
	
	public static String getOptionsStr(String selName){
		return options.get(selName);
	}
	/**
	 * 获取相应的pager处理器
	 * @param stlReq
	 * @return
	 */
	public static BasePager getPMDPager(PMDRequest stlReq){
		String pmdAction = stlReq.getTlHd().getSingleNodeValue("//PagerAction");
		String tptId = stlReq.getTptId();
		BasePager pager = null;
	
		//CRU页面
		if("Edit".equals(pmdAction)||"CRU".equals(pmdAction)){
			if("edit2Add".equals(stlReq.getPagerAction())){
				stlReq.setFileName(convertFileName(stlReq.getFileName(),"edit","add"));
				pager = new AddPager();				
			}				
			else if("edit2Edit".equals(stlReq.getPagerAction())){
				pager = new EditPager();				
			}	
			else{//默认进入查看页面 
				stlReq.setFileName(convertFileName(stlReq.getFileName(),"edit","view"));
				pager = new ViewPager();	
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
				pager = new QueryListPager();
			}
			else pager = new EntityAndItemsPager();			
		}
		else if("ListSelect".equals(pmdAction))	pager = new ListSelectPager();		
		else if("List2Link".equals(pmdAction)) pager = new List2LinkPager();	
		//列表页面
		else pager = new QueryListPager();	
		
		BaseTmpt tpt = getBaseTmpt(pmdAction,tptId);
		tpt.setPager(pager);
		pager.setTpt(tpt);			
		return pager;
	}
	
	private static BaseTmpt getBaseTmpt(String pmdAction,String tptId){
		BaseTmpt ret = null;	
		BaseTmptFactory tptFact = tptId==null?null:getTmptFactories().get(tptId);
		if(tptFact==null) tptFact = getTmptFactories().get(defaultTptCode);
		
		if("Edit".equals(pmdAction)||"CRU".equals(pmdAction))
			ret = tptFact.createCRUTmpt(); 
		else if("CmpxEntityCRU".equals(pmdAction)) 
			ret = tptFact.createCmpxCRUTmpt(); 
		else if("ListSelect".equals(pmdAction))
			ret = tptFact.createList2SelectTmpt();
		else if("List2Link".equals(pmdAction))
			ret = tptFact.createList2LinkTmpt();
		else if("EntityAndItems".equals(pmdAction))
			ret = tptFact.createEntityAndItemsTmpt();				
		else ret = tptFact.createListTmpt();
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
