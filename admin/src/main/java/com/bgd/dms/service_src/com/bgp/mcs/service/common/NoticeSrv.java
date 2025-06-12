package com.bgp.mcs.service.common;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;

/**
 * 标题：东方地球物理公司物探生产管理系统
 * 
 * 公司: 中油瑞飞
 * 
 * 作者：屈克将
 *       
 * 描述：通知提醒和待办事宜的服务
 */
public class NoticeSrv extends BaseService{

	private ILog log;
    private IJdbcDao jdbcDao;
    private IPureJdbcDao pureDao;
    
    public NoticeSrv()
    {
        log = LogFactory.getLogger(NoticeSrv.class);
        jdbcDao = BeanFactory.getQueryJdbcDAO();
        pureDao = BeanFactory.getPureJdbcDAO();
    }
    
	public ISrvMsg notice(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		NoticeUtilBean noticeBean = (NoticeUtilBean)BeanFactory.getBean("NoticeUtilBean");
		
		Map dataMap = new HashMap();
		
		dataMap.put("empId", "0710000010");
		
		dataMap.put("method", "0110000010000000004");
		
		dataMap.put("title", "有消息");//有消息
		
		dataMap.put("content", "短信测试：有消息");//

		dataMap.put("link", "");//

		dataMap.put("sender", "");

		dataMap.put("priority", "1");
		
		noticeBean.notice(dataMap);

		return msg;
	}

	public ISrvMsg getNoticeLog(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		return msg;
	}

	/**
	 * 获取一条待办事宜信息
	 */
	public ISrvMsg getPendingInfo(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
		
		String messageId = reqDTO.getValue("messageId");
		
		NoticeUtilBean noticeBean = (NoticeUtilBean)BeanFactory.getBean("NoticeUtilBean");
		
		msg.setValue("pendingInfo", noticeBean.getPendingInfo(messageId));
		
		return msg;
	}
	/**
	 * 处理一条待办事宜信息
	 */
	public ISrvMsg handlePending(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		NoticeUtilBean noticeBean = (NoticeUtilBean)BeanFactory.getBean("NoticeUtilBean");
		
		String messageId = reqDTO.getValue("messageId");
		
		noticeBean.handlePending(messageId);
		
		String pendingNum = noticeBean.getPendingNum(reqDTO.getUserToken().getEmpId());
		
		msg.setValue("pendingNum", pendingNum);
		
		return msg;
	}
	
	/**
	 * 保存常用联系人
	 */
	public ISrvMsg savePersonalNotifier(ISrvMsg reqDTO) throws Exception {

		ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);

		String notifier = reqDTO.getValue("notifier");
		String parentId = reqDTO.getValue("parentId");
		if(notifier==null || notifier.equals("")){
			return msg;
		}

		UserToken user = reqDTO.getUserToken();

		String[] notifiers = notifier.split(",");
		
		StringBuffer sb = new StringBuffer();
		
		for(int i=0;i<notifiers.length;i++){
			
			sb = new StringBuffer();
			
			sb.append("select count(*) as rowCount from ic_user_favorite_dms t");
			
			sb.append(" where t.bsflag='0' and t.object_type='3.1'  and  t.user_id='").append(user.getUserId()).append("'");
			
			sb.append("and t.object_id='").append(notifiers[i]).append("' and t.spare2='").append(parentId).append("'");
			
			Map countMap = jdbcDao.queryRecordBySQL(sb.toString());
			
			if(countMap==null) continue;
			
			String rowCount = (String)countMap.get("rowcount");
			
			if(rowCount!=null && rowCount.equals("0")){
				
				Map objectMap = new HashMap();

				objectMap.put("object_type", "3.1");
				
				objectMap.put("user_id", user.getUserId());

				objectMap.put("object_id", notifiers[i]);
				
				objectMap.put("spare2", parentId);
				
				objectMap.put("bsflag", "0");

				objectMap.put("creator", user.getUserId());

				objectMap.put("create_date", new Date());

				objectMap.put("updator", user.getUserId());

				objectMap.put("modifi_date", new Date());

				pureDao.saveOrUpdateEntity(objectMap, "ic_user_favorite_dms");

			}
		}
		
		return msg;
	}

}
