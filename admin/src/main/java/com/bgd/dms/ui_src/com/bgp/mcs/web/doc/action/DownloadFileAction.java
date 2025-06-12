package com.bgp.mcs.web.doc.action;

import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;

public class DownloadFileAction extends WSAction {

//	//吴海军新增，为A7文档下载
//    public void setDTOValue(
//            ISrvMsg requestDTO ,
//            ActionMapping mapping,
//            ActionForm form,
//            HttpServletRequest request,
//            HttpServletResponse response)
//            throws Exception {    	
//        if( requestDTO  == null )
//        	return;
//        
//        UserToken userToken = JcdpMVCUtil.getUserToken(request);
//        
//        //当用户没有登录时，通过传过来的参数判断用户是否需要下载（为A7文档下载用）
//        if(userToken  == null){
//        	
//            String loginId = request.getParameter("loginId");
//            String remoteAddr = request.getRemoteAddr();
//            
//            LoginAndMenuTreeSrv loginAndMenuTree = (LoginAndMenuTreeSrv) BeanFactory
//					.getBean("IBPLoginAndMenuTree");
//
//            
//            Map map = loginAndMenuTree.updateUserLoginBGPSFRZ(loginId,
//					remoteAddr, "UTF-8");
//        	UserToken userToken0 = (UserToken) map.get("userToken");
//			// 把用户信息放到Session里面
//			JcdpMVCUtil.setUserToken(request, userToken0); 
//            
//            Map mapUserProfile = (Map) map.get("userProfile");
//			// 把用户平台信息放到Session里面
//			if (mapUserProfile != null && !mapUserProfile.isEmpty())
//			{
//				String userMainPage = PagerFactory.defaultMainPage;
//
//				UserProfile userProfile = new UserProfile();
//				userProfile.setTptId((String) mapUserProfile
//						.get("tmptId"));
//
//				userMainPage = PagerFactory.tptMainPages
//						.get(userProfile.getTptId());
//
//				if (userMainPage != null
//						&& !userMainPage.trim().equals("")
//						&& !userMainPage.trim().startsWith("/"))
//				{
//					userMainPage = "/" + userMainPage;
//				}
//				JcdpMVCUtil.setUserProfile(request, userProfile);
//			}
//        }
//         
//        setRequestValuesToDTO( requestDTO, mapping, form, request, response);
//    }
//    
	MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	
	@Override
	public ActionForward executeResponse(ActionMapping actionmapping, ActionForm actionform,
			HttpServletRequest httpservletrequest, HttpServletResponse httpservletresponse) throws Exception {
		ISrvMsg isrvmsg = (ISrvMsg)httpservletrequest.getAttribute("responseDTO");
		
		String docId = isrvmsg.getValue("docid");
		String logFileId = isrvmsg.getValue("logFileId");
		String userId = isrvmsg.getValue("userId");
		String orgId = isrvmsg.getValue("orgId");
		String orgSubId = isrvmsg.getValue("orgSubId");
		String docAction = isrvmsg.getValue("docaction");		
		
		String docTitle = myUcm.getDocTitle(docId);
		byte[] docData = myUcm.getFile(docId);
		
		httpservletresponse.setContentType("application/x-msdownload");
		httpservletresponse.setHeader("Content-Disposition",
                           "attachment;" + "filename="+ new String(docTitle.getBytes(), "ISO-8859-1"));
        
        OutputStream out = httpservletresponse.getOutputStream();
           
 	    out.write(docData);
        out.flush(); //强制清出缓冲区 
        out.close();
        //写入下载的日志
        if(logFileId!=""&&logFileId!=null){
        	//action不是空值，表示是查看  action是空值，表示是下载是2,查看是5
        	String fileVersion = isrvmsg.getValue("fileVersion");
        	if("view".equals(docAction)){
        		myUcm.docLog(logFileId, fileVersion,5, userId, userId, userId,orgId,orgSubId,docTitle);
        	}else{
        		myUcm.docLog(logFileId, fileVersion, 2, userId, userId, userId,orgId,orgSubId,docTitle);
        	}
                   	
        }              
		return null;
	}	
}
