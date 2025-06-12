package com.cnpc.jcdp.web.auth.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.web.tcg.ajax.action.AjaxCallAction;
import com.cnpc.sais.ibp.auth2.util.PasswordUtil;
/**
 * @author rechete
 *
 */
public class AddOrUpdateUserAction extends AjaxCallAction{
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
        // 加密密码
        String user_id = requestDTO.getValue("user_id");
        if(user_id!=null && !user_id.equals("")){// 修改操作
	        String new_user_pwd = requestDTO.getValue("new_user_pwd");
	        if(new_user_pwd!=null && !new_user_pwd.equals("")){// 修改操作，并且输入了新密码
	        	new_user_pwd = PasswordUtil.encrypt(new_user_pwd);
		        requestDTO.replaceValue("user_pwd", new_user_pwd);
	        }
        }else{ // 新增操作
	        String user_pwd = requestDTO.getValue("user_pwd");
	        if(user_pwd!=null && !user_pwd.equals("")){
		        user_pwd = PasswordUtil.encrypt(user_pwd);
		        requestDTO.replaceValue("user_pwd", user_pwd);
	        }
        }
    }
}