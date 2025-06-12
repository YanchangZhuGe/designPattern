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

//	//�⺣��������ΪA7�ĵ�����
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
//        //���û�û�е�¼ʱ��ͨ���������Ĳ����ж��û��Ƿ���Ҫ���أ�ΪA7�ĵ������ã�
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
//			// ���û���Ϣ�ŵ�Session����
//			JcdpMVCUtil.setUserToken(request, userToken0); 
//            
//            Map mapUserProfile = (Map) map.get("userProfile");
//			// ���û�ƽ̨��Ϣ�ŵ�Session����
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
        out.flush(); //ǿ����������� 
        out.close();
        //д�����ص���־
        if(logFileId!=""&&logFileId!=null){
        	//action���ǿ�ֵ����ʾ�ǲ鿴  action�ǿ�ֵ����ʾ��������2,�鿴��5
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
