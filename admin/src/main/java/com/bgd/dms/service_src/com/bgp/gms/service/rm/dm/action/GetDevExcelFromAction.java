
package com.bgp.gms.service.rm.dm.action;

import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.jxls.common.Context;
import org.jxls.util.JxlsHelper;
import org.springframework.jdbc.core.JdbcTemplate;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.jxls.transformer.XLSTransformer;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.dao.IBaseDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.mvc.config.ServiceCallConfig;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.webapp.constant.MVCConstant;
import com.cnpc.jcdp.webapp.srvclient.IServiceCall;
import com.cnpc.jcdp.webapp.srvclient.ServiceCallFactory;

/**
 * project: 东方物探生产管理系统
 * 
 * creator: dz
 * 
 * creator time:2016-7-12
 * 
 * description:利用jxls实现多sheet页的导出
 * 
 */
@SuppressWarnings({ "unchecked", "unused" })
public class GetDevExcelFromAction extends WSAction {
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
	@Override
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		response.setContentType("application/x-json; charset=utf-8");
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
		String modelName = msg.getValue("modelname");
		String modelPath = msg.getValue("modelpath");
		String listName = msg.getValue("listname");
		String[] splitListName = listName.split(",",-1);
		
		InputStream is = new FileInputStream(request.getSession().getServletContext().getRealPath(modelPath));
		OutputStream os = response.getOutputStream();
		Context context = new Context();
		
		for(int i = 0;i < splitListName.length; i++){
			String sql=msg.getValue(splitListName[i]);
			System.out.println(splitListName[i]+"::"+sql);
			List<Map<String, Object>> strList = jdbcTemplate.queryForList(sql);
			context.putVar(splitListName[i], strList);
		}
		try {
			GetDevExcelFromAction.excelDownloadFile(modelName+".xls",request,response);
			JxlsHelper.getInstance().processTemplate(is, os, context);
		} finally {
			if(os!=null){
		       os.close();
		    }
		}
		return null;
	}
	/**
	 * 导出设备档案excel
	 * 
	 * @param reqDTO
	 * @return
	 * @throws Exception
	*/
	public static void  excelDownloadFile(String fileName,
	    		HttpServletRequest request,
	    		HttpServletResponse response) throws UnsupportedEncodingException{
	    	response.setCharacterEncoding("utf-8");  
		    response.setContentType("multipart/form-data");  
		    
	    	// Disable browser cache
			response.setHeader("Expires", "Sat, 6 May 1971 12:00:00 GMT");
			response.setHeader("Cache-Control", "must-revalidate");
			response.addHeader("Cache-Control", "no-store, no-cache, must-revalidate");
			response.addHeader("Cache-Control", "post-check=0, pre-check=0");
			response.setHeader("Pragma", "no-cache");
			
	    	//针对不同浏览器对文件名进行编码
			String userAgent = request.getHeader("User-Agent"); 
			if (userAgent.contains("MSIE")||userAgent.contains("Trident")) {
				//针对IE或者以IE为内核的浏览器：
				fileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", " ");
			} else if (userAgent.contains("iphone") || userAgent.contains("ipad")) {
				//doNothing
			} else if(userAgent.contains("android")){
				//安卓
				fileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", " ");
			}else{
				fileName = new String(fileName.getBytes("UTF-8"),"ISO-8859-1");
			}
			//文件名加双引号避免非ie浏览器因为空格截断文件名
	 	    response.setHeader("Content-Disposition", "attachment;fileName=\""+fileName+"\"");  
	    } 
}
