package com.bgp.dms.assess;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import com.bgp.dms.assess.IServ.IAssessNodeServ;
import com.bgp.dms.assess.IServ.IElementDetailServ;
import com.bgp.dms.assess.IServ.IElementServ;
import com.bgp.dms.assess.IServ.IModelServ;
import com.bgp.dms.assess.IServ.IReportMarkServ;
import com.bgp.dms.assess.IServ.IReportServ;
import com.bgp.dms.assess.IServ.ITemplateServ;
import com.bgp.dms.assess.IServ.impl.AssessNodeServ;
import com.bgp.dms.assess.IServ.impl.AssessNodeServ2;
import com.bgp.dms.assess.IServ.impl.ElementDetailServ;
import com.bgp.dms.assess.IServ.impl.ElementServ;
import com.bgp.dms.assess.IServ.impl.ModelServ;
import com.bgp.dms.assess.model.AssessBorad;
import com.bgp.dms.assess.model.AssessInfo;
import com.bgp.dms.assess.model.TemplateInfo;
import com.bgp.dms.assess.util.AssessTools;
import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.ConfigFactory;
import com.cnpc.jcdp.cfg.ConfigHandler;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.jcdp.util.DateUtil;

/**
 * project: 设备体系信息化建设
 * 
 * creator: gaoyunpeng
 * 
 * creator time:2015-9-7
 * 
 * description:考核查询相关服务
 * 
 */
@Service("AssessPlatServ")
public class AssessPlatSrv extends BaseService {
	public AssessPlatSrv() {

		log = LogFactory.getLogger(AssessPlatSrv.class);
		log.info("AssessPlatServ init");
	}

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private IModelServ modelServ = new ModelServ();
	private IElementServ elementServ = new ElementServ();
	private IElementDetailServ elementDetailServ = new ElementDetailServ();
	
	private IReportServ reportServ;
	private IReportMarkServ reportMarkServ;

	/**
	 * 保存模板
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveModel(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		Map map = msg.toMap();
		modelServ.saveModel(map);
		return responseDTO;
	}
	/**
	 * 查询所有模板
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findAllModel(ISrvMsg msg) throws Exception {
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		log.info("findAllModel");
		String sql = "";
		StringBuffer buffer = new StringBuffer();
		buffer.append("select MODEL_ID as id,MODEL_NAME as modelname, ");
		buffer.append("MODEL_TYPE as modeltype,MODEL_TITLE as modeltitle, ");
		buffer.append("MODEL_VERSION as modelversion,CREATOR as modelcreator, ");
		buffer.append("CREATE_ORG_ID as modelorgid, CREATE_DATE as createdate");
		buffer.append(" from dms_assess_plat_model ");
		buffer.append("order by CREATE_DATE desc");
		sql = buffer.toString();
		List<Map<String, Object>> list = jdbcTemplate.queryForList(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	/**
	 * 根据id查询model
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findModelID(ISrvMsg msg) throws Exception {
		String modelID = msg.getValue("modelID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		Map<String, Object> map = modelServ.findModelByID(modelID);
		responseDTO.setValue("data", map);
		return responseDTO;
	}

	

	

	/**
	 * 根据要素id查询要素
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findElementByID(ISrvMsg msg) throws Exception {
		String elementID = msg.getValue("elementID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		Map map = elementServ.findElementByID(elementID);
		responseDTO.setValue("data", map);
		return responseDTO;
	}

	

	/**
	 * 根据模板id查询该模板id下所有要素
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findElementListByModelID(ISrvMsg msg) throws Exception {
		String modelID = msg.getValue("modelID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}

	/**
	 * 查询考核要素明细
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findElementDetailByID(ISrvMsg msg) throws Exception {
		log.info("findElementDetailByID");
		String detailID = msg.getValue("detailID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		Map map = elementDetailServ.findElementDetailByID(detailID);
		responseDTO.setValue("data", map);
		return responseDTO;
	}

	/**
	 * 查询考核要素下所有考核明细
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg findElementDetailListByEleID(ISrvMsg msg) throws Exception {
		log.info("findElementDetailListByEleID");
		String eleid = msg.getValue("eleID");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		
		return responseDTO;
	}

	/**
	 * 删除考核要素明细
	 * 
	 * @param msg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg delElementDetailByID(ISrvMsg msg) throws Exception {
		log.info("delElementDetailByID");
		String currentdate = DateUtil.convertDateToString(
				DateUtil.getCurrentDate(), "yyyy-MM-dd HH:mm:ss");
		UserToken user = msg.getUserToken();
		// 当前登录用户的ID
		String employee_id = user.getEmpId();
		String detailID = msg.getValue("detailID");
		
		// 5.回写成功消息
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(msg);
		elementDetailServ.deleteElementDetailByID(detailID);

		return responseDTO;
	}
}
