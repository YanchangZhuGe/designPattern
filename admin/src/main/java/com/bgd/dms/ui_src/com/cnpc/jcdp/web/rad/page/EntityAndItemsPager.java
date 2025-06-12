/**
 * 
 */
package com.cnpc.jcdp.web.rad.page;

import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.cfg.ICfgNode;
import com.cnpc.jcdp.web.rad.util.RADConst;
import com.cnpc.jcdp.web.rad.util.RADUtil;

/**
 * @author rechete
 *
 */
@SuppressWarnings({ "unchecked", "serial" })
public class EntityAndItemsPager extends BasePager{
	public EntityAndItemsPager(){
		pmdAction = RADConst.PMDAction.M_S;
	}
    
	protected void initPager(HttpServletRequest request, HttpServletResponse response)throws Exception{   	
		Map<String,String> maps = request.getParameterMap();
		for(String key : maps.keySet()){
			if("id".equals(key) && "toJsp".equals(action)){
				params.put("id", "<%=id%>");
				continue;
			}
			params.put(key, request.getParameter(key));
		}
    }
    
  public void process(HttpServletRequest request, HttpServletResponse response)
  	throws java.io.IOException, ServletException {
	  try {
		  String pageTitle = tlHd.getSingleNodeValue("//MainEntity/PageTitle");
		  String editPmd = tlHd.getSingleNodeValue("//MainEntity/EditPMD");
		  String[] strs = this.stlReq.getFileName().split("/");
		  String itemsPmd = strs[strs.length-1];	  
		  String height = tlHd.getSingleNodeValue("//MainEntity/EditPMD_Height");
		  if(height==null || "".equals(height.trim())){
			  String fullEditPmd = stlReq.getFileName().replaceFirst(itemsPmd, editPmd);
			  height = countHeight(fullEditPmd)+"";		  
		  }
		  
		  ConfigHandler cfgHdl = ConfigFactory.getCfgHandler();
		  String heightOffset = cfgHdl.getSingleNodeValue("app_config/Templete/EntityAndItems/HeightOffset");
		  if(StringUtils.isNotEmpty(heightOffset)){
			  height = String.valueOf(Integer.parseInt(height) + Integer.parseInt(heightOffset));
		  }
		  response.setContentType("text/html;charset=GBK");
	      print("\t\r\n");
		  print("<frameset rows=\""+height+",*\" cols=\"*\" frameborder=\"no\" border=\"0\" framespacing=\"0\">\r\n");
		  print("\t<frame src=\""+editPmd+"?id="+params.get("id"));
		  if(!"false".equals(request.getParameter("noCloseButton"))){
			  print("&noCloseButton=true");
		  }
		  if(request.getParameter("pagerAction")!=null)
			  print("&pagerAction="+request.getParameter("pagerAction"));
		  //if("true".equals(request.getParameter("noCloseButton"))) print("&noCloseButton=true");
		  print("&pageTitle="+pageTitle+"\" name=\"topFrame\" frameborder=\"no\" scrolling=\"No\" noresize=\"noresize\" id=\"mainTopframe\"/>\r\n");
		  
		  String itemsPage = tlHd.getSingleNodeValue("//ItemsEntity/ItemsPage");
		  if(itemsPage!=null) print("\t<frame src=\""+itemsPage+"?");
		  else print("\t<frame src=\""+itemsPmd+"?pagerAction=listItems&");
	      println("parent_id="+params.get("id")+new Object(){
	    	  private String getUrlParam(Map<String,String> params){
	    		  params.remove("id");
	    		  StringBuffer sb = new StringBuffer();
	    		  for(String key : params.keySet()){
	    			  sb.append("&"+key+"="+params.get(key));
	    		  }
	    		  return sb.toString();
	    	  }
	      }.getUrlParam(params)+"\" name=\"topFrame\" frameborder=\"no\" scrolling=\"No\" noresize=\"noresize\" id=\"mainDownframe\"/>");
		  print("</frameset>\r\n");
	  } catch (Throwable t) {
		  log.error(t);
	  } finally {
		 flush();
	  }
  }
  
  private int countHeight(String editPmd){
	  int ret = 37;
	  float rows = 0;
	  try{
		  ConfigHandler hd = RADUtil.getConfigHandler(editPmd);
		  List<ICfgNode> nodes = hd.selectNodes("//EntityFields/field");
		  for(int i=0;i<nodes.size();i++){
			  ICfgNode node = nodes.get(i);
			  String fieldAction = node.getAttrValue("action");
			  if(fieldAction!=null && fieldAction.indexOf("R")<0) continue;
			  String isShow = node.getAttrValue("isShow");
			  if(!"Hide".equals(isShow)){
				  String type = node.getAttrValue("type");
				  if("MEMO".equals(type)){	    	
					  String size = node.getAttrValue("size");
					  if(size==null) size = RADConst.DEFAULT_MEMO_COLS+":"+RADConst.DEFAULT_MEMO_ROWS;
					  else if(size.indexOf(":")<=0) size += ":"+RADConst.DEFAULT_MEMO_ROWS;
					  ret +=  5+15*Integer.parseInt(size.substring(size.indexOf(":")+1,size.length()));
	  	    		rows = Math.round(rows);
	  	    	  }else rows += 0.5;				  
			  }		  
		  }
		  ret += Math.round(rows)*25;
		  
	  }catch(Exception ex){
		  log.error(ex);
	  }
	  return ret;
  }


}
