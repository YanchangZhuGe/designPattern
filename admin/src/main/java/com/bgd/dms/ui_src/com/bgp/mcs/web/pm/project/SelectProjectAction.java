package com.bgp.mcs.web.pm.project;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.mvc.action.ActionForm;
import com.cnpc.jcdp.mvc.action.ActionForward;
import com.cnpc.jcdp.mvc.action.ActionMapping;
import com.cnpc.jcdp.mvc.action.WSAction;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.webapp.constant.MVCConstant;
import com.cnpc.jcdp.webapp.util.JcdpMVCUtil;
import com.cnpc.jcdp.webapp.util.MVCConstants;
import com.cnpc.jcdp.webapp.util.OMSMVCUtil;

public class SelectProjectAction extends WSAction {

	public ActionForward executeResponse(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ISrvMsg respDTO = (ISrvMsg) request
				.getAttribute(MVCConstants.RESPONSE_DTO);
		
		UserToken user = OMSMVCUtil.getUserToken(request);
		
		String projectInfoNo = respDTO.getValue("projectInfoNo");
		String projectName = respDTO.getValue("projectName");
		String explorationMethod = respDTO.getValue("explorationMethod");
		String projectId = respDTO.getValue("projectId");
		String projectObjectId = respDTO.getValue("projectObjectId"); 
		String projectType = respDTO.getValue("projectType"); 
		String teamOrgId = respDTO.getValue("teamOrgId");
		String projectCommon = respDTO.getValue("projectCommon");

		user.setProjectInfoNo(projectInfoNo);
		user.setProjectName(projectName);
		user.setProjectId(projectId);
		user.setExplorationMethod(explorationMethod);
		//吴海军 添加项目类型
		user.setProjectType(projectType);
		//吴海军 添加项目施工队伍
		user.setTeamOrgId(teamOrgId);
		//吴海军 添加项目常规和非常规信息
		user.setProjectCommon(projectCommon);
		if (projectObjectId == null || "".equals(projectObjectId)) {
			
		} else {
			user.setProjectObjectId(Integer.parseInt(projectObjectId));
		}

		JcdpMVCUtil.setUserToken(request, user);

		ActionForward forward = mapping.findForward(MVCConstant.FORWARD_SUCESS);
		return forward;
	}
}