package com.cnpc.sais.ibp.auth2.srv;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import net.sf.json.JSONArray;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.TreeNodeData;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.CommonUtil;
import com.cnpc.sais.ibp.auth.pojo.PAuthMenu;
import com.cnpc.sais.ibp.auth2.pojo.TreeNode;

public class MenuTreeSrv extends BaseService {
	private static final String ORG = "1";
	private static final String ROLE = "2";
	private static final String USER = "3";
	
	public ISrvMsg saveMenuTreeData(ISrvMsg reqDTO) throws Exception{
			ISrvMsg respDTO = SrvMsgUtil.createResponseMsg(reqDTO);
			String type = StringUtils.trimToEmpty(reqDTO.getValue("type"));
			ITreeBO treeBO = getTreeBO(type);
			if(treeBO != null){
				treeBO.saveTreeData(reqDTO);
			}
			return respDTO;
	}
	
	public ISrvMsg saveCollMenuTreeData(ISrvMsg reqDTO) throws Exception{
		ISrvMsg respDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		String type = StringUtils.trimToEmpty(reqDTO.getValue("type"));
		UserTreeBO treeBO = (UserTreeBO)BeanFactory.getBean("UserTreeBO");;
		if(treeBO != null){
			treeBO.saveCollTreeData(reqDTO);
		}
		return respDTO;
}
	public ISrvMsg getMenuTreeData(ISrvMsg reqDTO) throws Exception{
			ISrvMsg respDTO = SrvMsgUtil.createResponseMsg(reqDTO);
			String type = StringUtils.trimToEmpty(reqDTO.getValue("type"));
			List<TreeNode> treeNodes = new ArrayList<TreeNode>();
			ITreeBO treeBO = getTreeBO(type);
			if(treeBO != null){
				treeNodes = treeBO.getTreeData(reqDTO);
			}
			JSONArray arr = new JSONArray();
			arr.addAll(treeNodes);
			respDTO.setValue("nodes",arr.toString());
			return respDTO;
	}
	public ISrvMsg getCollMenuTreeData(ISrvMsg reqDTO) throws Exception{
		ISrvMsg respDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		List<TreeNode> treeNodes = new ArrayList<TreeNode>();
		UserTreeBO treeBO =  (UserTreeBO) BeanFactory.getBean("UserTreeBO");
		if(treeBO != null){
			treeNodes = treeBO.getCollTreeData(reqDTO);
		}
		JSONArray arr = new JSONArray();
		arr.addAll(treeNodes);
		respDTO.setValue("nodes",arr.toString());
		return respDTO;
}
	
public ISrvMsg query4CollLinks(ISrvMsg reqDTO) throws Exception{
		
		UserToken user = reqDTO.getUserToken();
		log.info("query4CollNodes... ’≤ÿº–......username="+user.getUserName().toString());
		UserTreeBO treeBO =  (UserTreeBO) BeanFactory.getBean("UserTreeBO");
		
		List<Map> links = treeBO.getCollLinks(user.getUserId());
		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		msg.isSuccessRet();
		
		msg.setValue("links", links);
		return msg;
	}

	private ITreeBO getTreeBO(String type){
		ITreeBO treeBO = null;
		if(ORG.equals(type)){
			treeBO = (ITreeBO) BeanFactory.getBean("OrgTreeBO");
		}else if(ROLE.equals(type)){
			treeBO = (ITreeBO) BeanFactory.getBean("RoleTreeBO");
		}else if(USER.equals(type)){
			treeBO = (ITreeBO) BeanFactory.getBean("UserTreeBO");
		}
		return treeBO;
	}
}
