package com.bgp.gms.service.pss.srv;

import java.util.HashMap;
import java.util.Map;
 

import net.sf.json.JSONObject;

import org.springframework.stereotype.Service;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.soaf.util.Operation;
import com.cnpc.sais.ibp.auth2.util.PasswordUtil;

/**
 * 
* @ClassName: GmsServiceForPSS
* @Description: 为生产监控提供用户登录验证服务
* @author wuhj
* @date 2014-8-11 下午3:22:36
*
 */
@Service("GmsServiceForPss")
public class GmsServiceForPSS extends BaseService
{

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");

	@Operation(input = "userName,userPwd", output = "infos")
	public ISrvMsg gainProjectInfos(ISrvMsg reqDTO) throws Exception
	{
		//获取用户名和密码
		String userName = reqDTO.getValue("userName");
		String userPwd = reqDTO.getValue("userPwd");
		
		Map<String, String> params = new HashMap<String, String>();
		params.put("userName", userName);
		params.put("userPwd", PasswordUtil.encrypt(userPwd));
		//查询用户信息的SQL
		String sql ="select  r.login_id,r.user_name,r.emp_id,r.email,r.org_id from p_auth_user r where r.login_id='[:userName]' and r.user_pwd = '[:userPwd]' ";
		 
		Map map = jdbcDao.queryRecordByParamSQL(sql, params);
		//验证用户是否正确 
		if(map!=null && !map.isEmpty()&& map.get("login_id")!=null){
			//验证通过
			map.put("RetCode", "0");
		} else {
			map = new HashMap();
			//验证失败
			map.put("RetCode", "1");
		}
		
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
		//返回json数据格式数据
		String infos = JSONObject.fromMap(map).toString(); 
 
		responseDTO.setValue("infos", infos);
		return responseDTO;

	}
	 
}
