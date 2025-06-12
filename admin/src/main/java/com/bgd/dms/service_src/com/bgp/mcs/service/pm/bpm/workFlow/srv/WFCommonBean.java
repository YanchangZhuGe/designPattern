package com.bgp.mcs.service.pm.bpm.workFlow.srv;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.gms.service.rm.dm.constants.DevConstants;
import com.bgp.gms.service.rm.dm.util.DevUtil;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.dao.IJdbcDao;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.srvMng.BaseService;
import com.cnpc.sais.bpm.IProcInstSrv;
import com.cnpc.sais.bpm.ProcInstSrv;
import com.cnpc.sais.bpm.cache.MemberCache;
import com.cnpc.sais.bpm.pojo.WfDNode;
import com.cnpc.sais.bpm.pojo.WfRVariableinst;
import com.cnpc.sais.bpm.runtime.entity.inst.ExamineinstEntity;
import com.cnpc.sais.bpm.runtime.entity.inst.ProcInstEntity;
import com.cnpc.sais.bpm.service.ExamineinstService;
import com.cnpc.sais.bpm.service.ProcInstService;

@SuppressWarnings({ "unchecked", "rawtypes" })
public class WFCommonBean extends BaseService
{

	private ILog log;
	private IJdbcDao jdbcDao;
	private IPureJdbcDao pureDao;
	private JdbcTemplate jdbcTemplate;

	public WFCommonBean()
	{
		log = LogFactory.getLogger(WorkFlowBean.class);
		jdbcDao = BeanFactory.getQueryJdbcDAO();
		pureDao = BeanFactory.getPureJdbcDAO();
		jdbcTemplate = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao"))
				.getJdbcTemplate();
	}

	// 发起审批
	public String startWFProcess(WFVarBean wfVar) throws Exception
	{

		log.info("=========================================================================>>开始发起审批");
		String procInstId = null;
		String businessType = wfVar.getBusinessType();
		UserToken user = wfVar.getUser();
		if (businessType != null && !"".equals(businessType))
		{

			// 根据业务流程配置 提取流程信息
			StringBuffer queryProcName = new StringBuffer();
			queryProcName
					.append(" select view1.org_id,view1.org_subjection_id,wf.proc_e_name,wf.proc_version from ");
			queryProcName
					.append(" (select os.org_id,os.org_subjection_id from comm_org_subjection os  where os.bsflag='0'");
			queryProcName.append(" start with os.org_subjection_id='")
					.append(user.getOrgSubjectionId()).append("'");
			queryProcName
					.append(" connect by prior os.father_org_id =  os.org_subjection_id) view1 ");
			queryProcName
					.append(" join ic_user_favorite_dms uf on view1.org_id=uf.user_id ");
			queryProcName
					.append(" join wf_d_procdefine wf on uf.object_id=wf.proc_e_name");
			queryProcName
					.append(" where wf.proc_type='")
					.append(businessType)
					.append("' and uf.object_type='4' and uf.bsflag='0' and wf.state='0'");
			queryProcName.append(" order by view1.org_subjection_id desc");
			Map map = jdbcDao.queryRecordBySQL(queryProcName.toString());
			if (map != null)
			{
				String procEName = (String) map.get("procEName");
				String procVersion = (String) map.get("procVersion");
				String queryProc = "select t.entity_id from wf_d_procdefine t where t.proc_e_name='"
						+ procEName
						+ "' and t.proc_version='"
						+ procVersion
						+ "'";
				Map procMap = jdbcDao.queryRecordBySQL(queryProc);
				if (procMap != null)
				{
					String procId = (String) procMap.get("entityId");

					// 流程实例变量添加到变量表
					Map varMap = wfVar.getWfVarMap();
					List variables = new ArrayList();
					if (varMap != null)
					{
						Iterator it = varMap.keySet().iterator();
						WfRVariableinst localWfRVariableinst = null;
						while (it.hasNext())
						{
							String key = (String) it.next();
							localWfRVariableinst = new WfRVariableinst();
							String value = URLDecoder.decode(
									(String) varMap.get(key), "UTF-8");
							localWfRVariableinst.setVarName(key);
							localWfRVariableinst.setVarValue(value);
							variables.add(localWfRVariableinst);
						}
					}

					// 业务主键添加到实例变量表
					WfRVariableinst variableBusinessId = new WfRVariableinst();
					variableBusinessId.setVarName("businessId");
					variableBusinessId.setVarValue(wfVar.getBusinessId());
					variables.add(variableBusinessId);
					// 业务类型添加到实例变量表
					WfRVariableinst variableBusinessType = new WfRVariableinst();
					variableBusinessType.setVarName("businessType");
					variableBusinessType.setVarValue(wfVar.getBusinessType());
					variables.add(variableBusinessType);
					// 业务抽取信息添加到实例变量表中
					WfRVariableinst variableBusinessInfo = new WfRVariableinst();
					String businessInfo = wfVar.getBusinessInfo();
					if (businessInfo != null && !"".equals(businessInfo))
					{
						businessInfo = URLDecoder.decode(businessInfo, "UTF-8");
					}
					variableBusinessInfo.setVarName("businessInfo");
					variableBusinessInfo.setVarValue(businessInfo);
					variables.add(variableBusinessInfo);

					// 得到IProcInstSrv流程调用接口
					IProcInstSrv procInstSrv = MemberCache.getInstance()
							.getProcInstSrv();

					// 调用启动流程实例接口 null为抄送 null 为组织机构的ID ORG_ID
					ProcInstEntity entity = procInstSrv.startProc(procEName,
							procVersion, variables, user.getUserId(),
							user.getUserName(), null, null);

					// 同步更新业务流程中间表
					// 将之前相同的提交记录设置为无效
					String sqlUpdateBsflag = "update common_busi_wf_middle set  bsflag='1' where proc_id='"
							+ procId
							+ "' and business_id='"
							+ wfVar.getBusinessId()
							+ "' and business_type='"
							+ wfVar.getBusinessType() + "'";
					jdbcTemplate.execute(sqlUpdateBsflag);
					procInstId = entity.getWfRProcinst().getEntityId();
					procId = entity.getWfRProcinst().getProcId();
					String procState = entity.getWfRProcinst().getState();
					Map busiWfMap = new HashMap();
					busiWfMap.put("proc_inst_id", procInstId);
					busiWfMap.put("proc_id", procId);
					busiWfMap.put("proc_status", procState);
					busiWfMap.put("business_id", wfVar.getBusinessId());
					busiWfMap.put("business_type", wfVar.getBusinessType());
					busiWfMap.put("bsflag", "0");
					busiWfMap.put("busi_table_name",
							wfVar.getBusinessTableName());
					busiWfMap.put("modifi_date", new Date());
					busiWfMap.put("create_date", new Date());
					pureDao.saveOrUpdateEntity(busiWfMap,
							"common_busi_wf_middle");
				}
			}
		}

		if (procInstId == null)
		{
			log.error("=========================================================================>>发起审批失败");
		} else
		{
			log.info("=========================================================================>>发起审批成功");
		}
		return procInstId;
	}

	// 获取审批列表信息
	public List getWFProcessList(String businessType, UserToken user,
			String isDone) throws Exception
	{
		// 从前台页面得到参数
		String userId = user.getUserId();
		// 得到调用接口
		ProcInstSrv procInstSrv = (ProcInstSrv) MemberCache.getInstance()
				.getProcInstSrv();
		// 通过接口得到待审批列表
		// 若businessType不为空 则根据其过滤流程,否则取所有流程
		List result = new ArrayList();
		if (businessType != null && businessType.contains(","))
		{
			for (String s : businessType.split(","))
			{
				if ("1".equals(isDone))
				{
					result.addAll(procInstSrv.queryJoinInstByUser(userId, "",
							null, "", s));
				} else
				{
					result.addAll(procInstSrv.getExamineInstListByUserID(
							userId, s, "", "", ""));
				}
			}
		} else
		{
			if ("1".equals(isDone))
			{
				result = procInstSrv.queryJoinInstByUser(userId, "", null, "",
						businessType);
			} else
			{
				result = procInstSrv.getExamineInstListByUserID(userId,
						businessType, "", "", "");
			}
		}

		return result;
	}

	// 获取审批列表信息
		public PageModel getWFProcessListForPage(String businessType,
				UserToken user, String isDone, PageModel page,String noFilter) throws Exception{
			// 从前台页面得到参数
			String userId = user.getUserId();
			// 得到调用接口
			// ProcInstSrv procInstSrv = (ProcInstSrv)
			// MemberCache.getInstance().getProcInstSrv();

			ExamineinstEntity examineinstEntity = (ExamineinstEntity) BeanFactory.getBean("Examineinst");

			ExamineinstService examineinstService = examineinstEntity.getExamineinstService();

			ProcInstEntity procInstEntity = (ProcInstEntity) BeanFactory.getBean("ProcInst");
			
			ProcInstService procInstService = procInstEntity.getProcInstService();
			// 通过接口得到待审批列表
			// 若businessType不为空 则根据其过滤流程,否则取所有流程
			// List result=new ArrayList();
			if (businessType != null && businessType.contains(",")){
				String businessTypes = processBusinessTypes(businessType);
				if ("1".equals(isDone)){
					page = procInstService.queryJoinProcInstByUserForPage(userId,"", null, "", businessTypes, page);
				} else{
					//不需要过滤用户
					if(noFilter!=null && noFilter.equals("1")){
						userId = "";
					}
					page = examineinstService.queryExamineInstListForPage(businessTypes, userId, "", "", page,noFilter);
				}
			} else{
				if ("1".equals(isDone)){
					// result=procInstSrv.queryJoinInstByUser(userId, "", null, "",
					// businessType);
					// 2014年6月27日 吴海军 增加流程查询类型
					String busTypes = null;
					if (businessType != null){
						String sql = "select  wm_concat(l.coding_code_id)  as businessTypes from comm_coding_sort_detail l  where l.superior_code_id in ('"+ businessType + "')";
						Map map = jdbcDao.queryRecordBySQL(sql);
						if (map != null && map.get("businesstypes").toString().length()!=0){
							busTypes = businessType + ","+ map.get("businesstypes");
						}else {
							busTypes = businessType;
						}
					}
					page = procInstService.queryJoinProcInstByUserForPage(userId,"", null, "", busTypes, page);
				} else{
					// 2014年6月27日 吴海军 增加流程查询类型
					String busTypes = null;
					if (businessType != null)
					{
						String sql = "select  wm_concat(l.coding_code_id)  as businessTypes from comm_coding_sort_detail l  where l.superior_code_id in ('"
								+ businessType + "')";
						Map map = jdbcDao.queryRecordBySQL(sql);
						if (map != null && !map.isEmpty())
						{
							busTypes = businessType + ","
									+ map.get("businesstypes");
						}else {
							busTypes = businessType;
						}
					}
					//不需要过滤用户
					if(noFilter!=null && noFilter.equals("1")){
						userId = "";
					}
					page = examineinstService.queryExamineInstListForPage(
							busTypes, userId, "", "", page,noFilter);
					// result.addAll(page.getData());
					// result= procInstSrv.getExamineInstListByUserID(userId,
					// businessType, "", "", "");
				}
			}

			return page;
		}

	/**
	 * 
	 * @Title: processBusinessTypes
	 * @Description: 处理多个流程模版ID的查询条件
	 * @param @param businessType
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @throws
	 */
	private String processBusinessTypes(String businessType)
	{

		StringBuffer sb = new StringBuffer();
		// 业务多流程模版ID用，分开
		String businessTypes[] = businessType.split(",");
		for (int i = 0; i < businessTypes.length; i++)
		{
			if (i == 0)
			{
				sb.append("'" + businessTypes[i] + "'");
			} else
			{
				sb.append(",'" + businessTypes[i] + "'");
			}
		}

		return sb.toString();
	}

	// 获取审批信息
	public Map getWFProcessInfo(UserToken userToken, String businessType,
			String procinstId, String examineinstId) throws Exception
	{
		String userId = userToken.getUserId();
		Map returnMap = new HashMap();

		// 得到流程IProcInstSrv调用接口
		IProcInstSrv procInstSrv = MemberCache.getInstance().getProcInstSrv();
		// 得到流程详细信息显示页面接口
		Map map = procInstSrv.getExamineInfo(procinstId, examineinstId,
				businessType, userId);

		List list = new ArrayList();
		list.add(map.get("examineinInfo"));
		// 下级节点--用户SELECT选择使用
		List listNode = new ArrayList();
		if (map.get("nodeList") != null)
		{
			listNode = (List) map.get("nodeList");
			int len = listNode.size();
			for (int i = 0; i < len / 2; i++)
			{
				Object oo = listNode.get(i);
				listNode.set(i, listNode.get(len - i - 1));
				listNode.set(len - i - 1, oo);
			}
		}
		// 是否是第一级审批节点--用户能否回退
		returnMap.put("isFirstApplyNode", map.get("isFirstApplyNode"));
		// 审批信息显示
		returnMap.put("examineinInfo", list);
		returnMap.put("nodeList", listNode);
		returnMap.put("nodeId", map.get("nodeId"));
		// 是否能够直接通过
		returnMap.put("isCanPass", map.get("isCanPass"));
		returnMap.put("startNode", map.get("startNode"));
		returnMap.put("businessType", businessType);

		return returnMap;
	}

	// 获取流程实例变量信息
	public Map getProcessVarInfo(String procinstId) throws Exception
	{
		Map map = new HashMap();
		String sql = "select * from wf_r_variableinst where  procinst_id = '"
				+ procinstId + "'";
		List list = jdbcDao.queryRecords(sql);
		if (list != null && list.size() > 0)
		{
			for (Object obj : list)
			{
				Map tempMap = (Map) obj;
				String varName = (String) tempMap.get("varName");
				String varValue = (String) tempMap.get("varValue");
				map.put(varName, varValue);
			}
		}
		return map;
	}

	// 获取回退节点
	public String getBackNode(String nodeId) throws Exception
	{
		IProcInstSrv procInstSrv = MemberCache.getInstance().getProcInstSrv();
		List list = procInstSrv.queryBackNode(nodeId);
		String backNodeId = null;
		if (list != null && list.size() > 0)
		{
			backNodeId = ((WfDNode) list.get(0)).getEntityId();
		}
		return backNodeId;
	}

	// 审批操作
	public String doWfProcess(UserToken userToken, String nextNodeId,
			String examineInfo, String isPassstr, String examineinstId,
			String procinstId, String taskinstId, String moveNodeId,
			String businessId) throws Exception{
		// 从前台得到需要参数

		// 得到流程IProcInstSrv接口
		IProcInstSrv procInstSrv = MemberCache.getInstance().getProcInstSrv();
		String proc_status = "";

		if (moveNodeId == null){
			moveNodeId = "";
		}
		// 后退还有待修改
		if ("back1".equals(isPassstr)||"back".equals(isPassstr)){// 第一级节点回退
			proc_status = procInstSrv.moveNodeProcInst(examineinstId,examineInfo, moveNodeId, procinstId, taskinstId, userToken);
		} else{
			// 调用审批接口
			Map map = procInstSrv.examineNode(nextNodeId, examineInfo,isPassstr, examineinstId, procinstId,userToken.getUserName(), taskinstId, userToken.getUserId(),null);
			proc_status = (String) map.get("procInstState");
		}
		if ("6".equals(proc_status)){
			proc_status = "4";
		}
		// 把状态写入到业务流程中间表
		String sql = "update common_busi_wf_middle set proc_status='"
				+ proc_status + "',modifi_date=sysdate where proc_inst_id = '" + procinstId
				+ "' and business_id ='" + businessId + "'";
		jdbcTemplate.execute(sql);
		return proc_status;
	}

	// 获取审批历史信息
	public List getProcHistory(String procInstId)
	{

		StringBuffer sql = new StringBuffer("select t4.entity_id, ")
				.append(" t4.proc_name, ")
				.append(" t4.create_user_name, ")
				.append(" t3.node_name, ")
				.append(" decode(t1.state, '2', '审核通过', '5', '退回', '1', '待审核') curState, ")
				.append(" t2.examine_user_name, ")
				.append(" t2.examine_start_date, ")
				.append("  subStr(t2.examine_end_date,0,16) examine_end_date, ")
				.append(" t1.is_open, ")
				.append(" t2.examine_info ")
				.append(" from wf_r_taskinst t1 ")
				.append(" inner join (select max(taskinst_id) taskinst_id, wmsys.wm_concat(examine_user_name) examine_user_name,max(examine_start_date) examine_start_date,max(examine_end_date) examine_end_date,max(examine_info) examine_info from wf_r_examineinst  group by procinst_id,node_id) t2 on t1.entity_id = t2.taskinst_id ")
				.append("    and t1.procinst_id = ")
				.append("'")
				.append(procInstId)
				.append("' ")
				.append("  inner join wf_d_node t3 on t1.node_id = t3.entity_id ")
				.append("  inner join wf_r_procinst t4 on t1.procinst_id = t4.entity_id ")
				.append("  order by t2.examine_end_date asc");
		return BeanFactory.getPureJdbcDAO().queryRecords(sql.toString());
	}

	// 根据业务类型获取定制化查询条件及列表项
	public Map getCustomQueryListInfo(String businessType) throws Exception
	{
		String sql = "select * from common_busi_wf_config  where business_type = '"
				+ businessType + "' and bsflag='0'";
		Map mapConfig = jdbcDao.queryRecordBySQL(sql);
		if (mapConfig != null)
		{

			mapConfig.remove("businessType");
		}
		return mapConfig;
	}

	// 根据业务类型获取定制化的业务表单
	public String getCustomBusinessForm(String businessType) throws Exception
	{
		String formUrl = null;
		String sql = "select * from common_busi_wf_config  where business_type = '"
				+ businessType + "' and bsflag='0'";
		Map mapConfig = jdbcDao.queryRecordBySQL(sql);
		if (mapConfig != null)
		{
			formUrl = (String) mapConfig.get("businessLinks");
		}
		return formUrl;
	}

	// copy map将MAP中指定开头的字段copy到另一个MAP中
	public Map copyMapFromStartMap(Map map, String startStr)
			throws UnsupportedEncodingException
	{
		Map returnMap = new HashMap();
		if (map != null)
		{
			Iterator it = map.keySet().iterator();
			while (it.hasNext())
			{
				String key = (String) it.next();
				String value = (String) map.get(key);
				if (value != null && !"".equals(value))
				{
					value = URLDecoder.decode(value, "UTF-8");
				} else
				{
					value = " ";
				}
				if (key != null && key.startsWith(startStr))
				{
					returnMap.put(key, value);
				}
			}
		}
		return returnMap;
	}

	/**
	 * 检查map中的值是否满足对应名称的给定值
	 * 
	 * @param map
	 * @param paramName
	 * @param paramValue
	 * @return
	 */
	public boolean check(Map map, String[] paramName, String[] paramValue)
	{
		int length = paramName.length;

		for (int i = 0; i < length; i++)
		{
			String value = (String) map.get(paramName[i]);
			if (!"".equals(paramValue[i])
					&& (value == null || value.indexOf(paramValue[i]) < 0))
			{
				return false;
			}
		}

		return true;
	}

	/*
	 * 复制MAP中的值到reqDTO中
	 */
	public void copyMapToDTO(Map map, ISrvMsg responseDTO) throws Exception
	{
		if (map != null && map.size() > 0)
		{
			Iterator it = map.keySet().iterator();
			while (it.hasNext())
			{
				String key = (String) it.next();
				// String value = URLDecoder.decode((String) varMap.get(key),
				// "UTF-8");
				responseDTO.setValue(key, map.get(key));
			}
		}
	}

	// 获取当前审批节点的node_link以及node_link_param
	public Map getWFNodeConfigId(String procInstId, String examineInstId)
			throws Exception{
		String sql = "";
		Map map = new HashMap();
		String sqlNode = "select d.coding_sort_id, t1.entity_id, t1.procinst_id, t2.urls"
					   + " from wf_r_examineinst t1"
					   + " inner join wf_d_node t2 on t1.node_id = t2.entity_id"
					   + " and t1.entity_id = '" + examineInstId + "'"
					   + " left join comm_coding_sort_detail d on t1.proc_type = d.coding_code_id";
		Map mapNode = jdbcDao.queryRecordBySQL(sqlNode);
		String nodeConfigId = (String) mapNode.get("urls");
		if(DevUtil.isValueNotNull((String) mapNode.get("codingSortId"), DevConstants.WORK_FLOW_CODE_GMS)){
			sql = "select * from common_busi_node_config"
				+ " where bsflag = '0' and node_config_id = '" + nodeConfigId + "'";
		}else{
			sql = "select * from common_busi_node_config_dms"
				+ " where bsflag = '0' and node_config_id = '" + nodeConfigId + "'";
		}
		/*String sql = "select * from common_busi_node_config_dms where bsflag='0' and node_config_id = '"
				+ nodeConfigId + "'";*/
		Map mapNodeConfig = jdbcDao.queryRecordBySQL(sql);
		String nodeLink = "";
		String nodeLinkParam = "";
		String nodeLinkType = "";
		if (mapNodeConfig != null)
		{
			nodeLink = (String) mapNodeConfig.get("nodeLink");
			nodeLinkParam = (String) mapNodeConfig.get("nodeLinkParam");
			nodeLinkType = (String) mapNodeConfig.get("nodeLinkType");
		}
		map.put("nodeLink", nodeLink);
		map.put("nodeLinkParam", nodeLinkParam);
		map.put("nodeLinkType", nodeLinkType);

		return map;
	}

}
