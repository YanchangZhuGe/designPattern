/**
 * 
 */
package com.cnpc.jcdp.web.auth2.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserProfile;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.mvc.Globals;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MsgElement;
import com.cnpc.jcdp.web.auth2.filter.MenuUrlFilter;
import com.cnpc.jcdp.web.rad.util.PagerFactory;
import com.cnpc.jcdp.webapp.constant.MVCConstant;
import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;

/**
 * @author rechete
 *
 */
public class LoginAction extends WSAction{
	public void setDTOValue(
            ISrvMsg requestDTO ,
            ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws Exception {    	
        if( requestDTO  == null )
        	return;
        super.setDTOValue(requestDTO, mapping, form, request, response);
        String charset =request.getSession().getAttribute(Globals.LOCALE_KEY).toString();
        requestDTO.setValue("loginIp", request.getRemoteAddr());
        requestDTO.setValue("charset", charset);
    }
	
	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		UserToken user=new UserToken();
		ISrvMsg msg = (ISrvMsg) request.getAttribute(MVCConstant.RESPONSE_DTO);
		if(msg==null || msg.isDefaultFailedRet()){
			loginLog(user, request);
			return mapping.findForward(MVCConstant.FORWARD_FAILED);
		} else if(msg.isSuccessRet()){
			MsgElement userMsg = msg.getMsgElement("userToken");
			user = (UserToken)userMsg.toPojo(UserToken.class);
			log.debug(user.getUserId()+" has logined!");
			JcdpMVCUtil.setUserToken(request,user);
			
			MsgElement userProfileMsg = msg.getMsgElement("userProfile");
			String userMainPage = null;// PagerFactory.defaultMainPage;
			if(userProfileMsg!=null){
				UserProfile userProfile = (UserProfile)userProfileMsg.toPojo(UserProfile.class);
				userProfile.setTptId(userProfileMsg.getValue("tmptId"));
//				userMainPage = PagerFactory.tptMainPages.get(userProfile.getTptId());
				JcdpMVCUtil.setUserProfile(request,userProfile);
			}
			
			String funcCodes = msg.getValue("funCodes");
			log.debug("User function codes is:"+funcCodes);
			if(funcCodes!=null){
				JcdpMVCUtil.setUserFuncCodes(request, funcCodes);
			}
			
			ActionForward forward =  mapping.findForward(MVCConstant.FORWARD_SUCESS);
			
			if(StringUtils.isNotEmpty(userMainPage)){
				try{
					forward.setPath(userMainPage);
				}catch(Exception e){
					e.printStackTrace();
				}
			}
//			MenuUrlFilter.refreshMenuUserCache();
			loginLog(user, request);
			return forward;
		} else {
			loginLog(user, request);
			return mapping.findForward(MVCConstant.FORWARD_BUSI_EX);
		}
		
	}
	//插入登录操作
	private void loginLog(UserToken user,HttpServletRequest request){
		RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
		String sql="insert into gms_dev_log("
				+ "id, "
				+ "user_id, "
				+ "login_id, "
				+ "email, "
				+ "operation, "
				+ "time, "
				+ "method, "
				+ "params, "
				+ "ip, "
				+ "create_date, "
				+ "org_id, "
				+ "org_sub_id, "
				+ "login_sys, "
				+ "login_type) "
				+ "values"
				+ "(sys_guid(), "
				+ "'"+(StringUtils.isNotBlank(user.getUserId())?user.getUserId():"")+"', "
				+ "'"+(StringUtils.isNotBlank(user.getLoginId())?user.getLoginId():"")+"', "
				+ "'', "
				+ "'"+DevConstants.LOG_LOGIN_DESC+"', "
				+ "'', "
				+ "'', "
				+ "'', "
				+ "'"+DevUtil.getIpAddr(request) +"', "
				+ "sysdate, "
				+ "'"+(StringUtils.isNotBlank(user.getOrgId())?user.getOrgId():"")+"', "
				+ "'"+(StringUtils.isNotBlank(user.getOrgSubjectionId())?user.getOrgSubjectionId():"")+"', "
				+ "'"+DevConstants.LOG_LOGIN_SYS_DMS+"', "
				+ "'"+DevConstants.LOG_LOGIN_TYPE_PC+"' )";
		jdbcDao.executeUpdate(sql);//插入登录日志
	}
	
}