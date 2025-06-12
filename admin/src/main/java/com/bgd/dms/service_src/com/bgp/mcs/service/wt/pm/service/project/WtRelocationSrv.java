package com.bgp.mcs.service.wt.pm.service.project;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;

import com.bgp.mcs.service.doc.service.MyUcm;
import com.bgp.mcs.service.pm.service.project.WtProjectMCSBean;
import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.common.UserToken;
import com.cnpc.jcdp.common.WSFile;
import com.cnpc.jcdp.dao.PageModel;
import com.cnpc.jcdp.icg.dao.IPureJdbcDao;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.jcdp.soa.msg.ISrvMsg;
import com.cnpc.jcdp.soa.msg.MQMsgImpl;
import com.cnpc.jcdp.soa.msg.SrvMsgUtil;
import com.cnpc.jcdp.soa.srvMng.BaseService;


public class WtRelocationSrv  extends BaseService {




		static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
		private JdbcTemplate dao = ((RADJdbcDao) BeanFactory.getBean("radJdbcDao"))
				.getJdbcTemplate();
		IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();

		// private RADJdbcDao jdbcDao = (RADJdbcDao)
		// BeanFactory.getBean("radJdbcDao");
		// private JdbcTemplate jdbcTemplate = jdbcDao.getJdbcTemplate();
		// private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
		/**
		 * ����
		 * 
		 * @param reqMsg
		 * @return
		 * @throws Exception
		 */
		public ISrvMsg executeBySql(ISrvMsg reqDTO) throws Exception {
			ISrvMsg msg = SrvMsgUtil.createResponseMsg(reqDTO);
			String sqls = reqDTO.getValue("sql");
			System.out.println(sqls);
			String sql[] = sqls.split(";");
			for (int i = 0; i < sql.length; i++) {
				dao.execute(sql[i]);
			}
			msg.setValue("returnCode", "0");
			return msg;
		}
		
		/**
		 * ��ѯ��Ǩ��Ŀ�����Ϣ
		 * @param reqDTO
		 * @return
		 * @throws Exception
		 */
		public ISrvMsg getRelocationAddData(ISrvMsg reqDTO) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
			
			UserToken user = reqDTO.getUserToken();
			String projectInfoNo = user.getProjectInfoNo();
			
			Map rsMap = new HashMap();
			
			
			
			String sql ="select * from gp_task_project t where t.project_info_no='"+projectInfoNo+"'";
			Map tempMap = dao.queryForMap(sql);
			
			rsMap.put("project_name", tempMap.get("project_name"));//��Ŀ����
			
			rsMap.put("construction_area", "");//ʩ������
			
			rsMap.put("method_code", tempMap.get("exploration_method"));//��̽����
			rsMap.put("work_team", tempMap.get("vsp_team_no"));//ʩ������
			rsMap.put("team_manager", tempMap.get("vsp_team_leader"));//�Ӿ���
			
//			Date sqdate = new Date();
//			SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd");
//			rsMap.put("create_date",sd.format(sqdate) );//��������
//			
//			rsMap.put("creator", user.getUserName());//������
//			
//			rsMap.put("status", "");//����״̬
			
			rsMap.put("technical_data", "");//��Ҫ���������嵥
			rsMap.put("relocation_plan", "");//��Ǩ�ƻ�
	          

			
			
			
			
			responseDTO.setValue("rsMap", rsMap);

			
			
			return responseDTO;
		}
		
		/**
		 * ��ѯ��Ǩ��Ŀ��Ϣ
		 * @param reqDTO
		 * @return
		 * @throws Exception
		 */
		public ISrvMsg getRelocationData(ISrvMsg reqDTO) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
			
			UserToken user = reqDTO.getUserToken();
			String projectInfoNo = user.getProjectInfoNo();
			//String businessType = reqDTO.getValue("businessType");
			//String sql ="select decode(te.proc_status,'1','������','3','����ͨ��','4','������ͨ��',te.proc_status) proc_status_name,te.proc_status,t.* from gp_wt_project_relocation t left join common_busi_wf_middle te on te.business_id = t.id and te.bsflag = '0' and te.business_type = '5110000004100000093' where t.project_info_no='"+projectInfoNo+"'";
			
			String sql ="select decode(te.proc_status,'1','������','3','����ͨ��','4','������ͨ��','δ�ύ����') proc_status_name,te.proc_status,t.*,(select wm_concat(coding_name) as coding_name from comm_coding_sort_detail where coding_code_id in (select s_value from table(Split(t.method_code, ','))) and bsflag = '0') as method_name from gp_wt_project_relocation t left join common_busi_wf_middle te on te.business_id = t.id and te.bsflag = '0' and te.business_type = '5110000004100000093' where t.project_info_no='"+projectInfoNo+"'";
			
			
			
			Map relocationMap = pureDao.queryRecordBySQL(sql);
			
			

			responseDTO.setValue("relocationMap", relocationMap);
			
			return responseDTO;
		}
		
		/**
		 * ����޸�ҳ��  ��ѯ��Ǩ��Ŀ��Ϣ
		 * @param reqDTO
		 * @return
		 * @throws Exception
		 */
		public ISrvMsg getAddPageData(ISrvMsg reqDTO) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
			UserToken user = reqDTO.getUserToken();
			String projectInfoNo = user.getProjectInfoNo();
			Map relocationMap = null;
			String id = reqDTO.getValue("id");
			if(id!=null&&!id.equals("")){
				//�޸�
				//���ڶ�Ǩ����id  ɾ��������Ŀno��ѯ����//String sql ="select decode(te.proc_status,'1','������','3','����ͨ��','4','������ͨ��','δ�ύ����') proc_status_name,t.* from gp_wt_project_relocation t left join common_busi_wf_middle te on te.business_id = t.id and te.bsflag = '0' and te.business_type = '5110000004100000093' where t.project_info_no='"+projectInfoNo+"' and t.id='"+id+"'";
				String sql ="select decode(te.proc_status,'1','������','3','����ͨ��','4','������ͨ��','δ�ύ����') proc_status_name,t.* from gp_wt_project_relocation t left join common_busi_wf_middle te on te.business_id = t.id and te.bsflag = '0' and te.business_type = '5110000004100000093' where t.id='"+id+"'";
				relocationMap = pureDao.queryRecordBySQL(sql);
			}else{
				
				//����
				
				relocationMap = new HashMap();
				//ȡ��ԭ��ϵͳ����Ŀ��Դ���üƻ����� �����ܴ�gp project resources��ȡ������
				//����--���ӹ�����GP_PROJECT_RESOURCES����öӾ����ֶ�
				//String sql ="select r.team_manager,di.workarea,t.* from gp_task_project t left join gp_workarea_diviede di on di.workarea_no = t.workarea_no  left join gp_project_resources r on r.project_info_no = t.project_info_no where t.project_info_no='"+projectInfoNo+"'";
				String sql ="select di.workarea,gp.team_manager,t.* from gp_task_project t left join gp_workarea_diviede di on di.workarea_no = t.workarea_no left join GP_PROJECT_RESOURCES gp on t.project_info_no=gp.project_info_no where t.project_info_no='"+projectInfoNo+"'";
				Map tempMap = dao.queryForMap(sql);
				
				relocationMap.put("project_name", tempMap.get("project_name"));//��Ŀ����
				relocationMap.put("project_info_no", projectInfoNo);//��Ŀno
				relocationMap.put("construction_area", getByNull(tempMap.get("workarea")));//ʩ������
				relocationMap.put("team_manager", getByNull(tempMap.get("team_manager")));//�Ӿ���
				relocationMap.put("creator", user.getUserName());//������
				//relocationMap.put("status", "0");//����״̬ ����
				
				Map gpeName = getProjectExploration(projectInfoNo);
				relocationMap.put("method_code", gpeName.get("exploration_method_name"));//��̽����
				
				Map gpoName = getProjectOrgNames(projectInfoNo);
				relocationMap.put("work_team", gpoName.get("org_name"));//ʩ������
				
				Date sqdate = new Date();
				SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd");
				relocationMap.put("create_date",sd.format(sqdate) );//��������
				
			}
			

			responseDTO.setValue("relocationMap", relocationMap);
			return responseDTO;
		}
		
		private WtProjectMCSBean projectMCSBean=(WtProjectMCSBean) BeanFactory.getBean("WtProjectMCSBean");
		
		/**
		 * ��ÿ�̽��������
		 * @param reqDTO
		 * @return
		 * @throws Exception
		 */
		private Map getProjectExploration(String projectInfoNo) throws Exception{
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("projectInfoNo", projectInfoNo);
			PageModel page = new PageModel();
			page = projectMCSBean.quertProject(map, page);
			List list = page.getData();
			
			String methodIds="";
			
			if (list != null && list.size() != 0) {
				map = (Map) list.get(0);
				if(null!=map.get("exploration_method")&&""!=map.get("exploration_method")){
					String[] methodId=map.get("exploration_method").toString().split(",");
					
					for(int i=0;i<methodId.length;i++){
						if(i==(methodId.length)-1){
							methodIds+="'"+methodId[i]+"'";
						}else{
							methodIds+="'"+methodId[i]+"',";
						}
					}
					//���ҿ�̽��������methodIds��Ϊ��ֵ����','���� '0300100014000000017','0300100014000000018'������XXXXX,XXXXXXXX
					page = projectMCSBean.getExplorationMethodNames(methodIds,page);
					list = page.getData();
					if (list != null && list.size() != 0) {
						Map map1 =(Map)list.get(0);
						map.put("exploration_method",map1.get("coding_code_id"));
						map.put("exploration_method_name",map1.get("coding_name"));
						map.put("exploration_method_super",map1.get("superior_code_id"));
					}
					
				}
			}
			return map;
		}
		/**
		 * ���ʩ����������
		 * @param reqDTO
		 * @return
		 * @throws Exception
		 */
		private Map getProjectOrgNames(String projectInfoNo) throws Exception{
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("projectInfoNo", projectInfoNo);
			PageModel page = new PageModel();
			page = projectMCSBean.quertProject(map, page);
			List list = page.getData();
			
			if (list != null && list.size() != 0) {
				map = (Map) list.get(0);
				if(null!=map.get("org_id")&&""!=map.get("org_id")){
					String[] orgId=map.get("org_id").toString().split(",");
					String orgIds="";
					for(int i=0;i<orgId.length;i++){
						if(i==(orgId.length)-1){
							orgIds+="'"+orgId[i]+"'";
						}else{
							orgIds+="'"+orgId[i]+"',";
						}
					}
					//����ʩ���������� orgIds��Ϊ��ֵ����','���� 'C6000000007066','C6000000000014','C6000000000008'������XXXXX,XXXXX,XXXXXXX
					page = projectMCSBean.getDynamicOrgNames(orgIds,page);
					list = page.getData();
					if (list != null && list.size() != 0) {
						Map map1 =(Map)list.get(0);
						map.put("org_name",map1.get("org_name"));
					}
				}
			}
			return map;
		}
		
		
		
		
		private String getByNull(Object o){
			if(o==null){
				return "";
			}
			return (String)o;
		}
		
		


		
		/**
		 * ɾ����Ǩ��Ŀ�����Ϣ
		 * @param reqDTO
		 * @return
		 * @throws Exception
		 */
		public ISrvMsg delRelocationData(ISrvMsg reqDTO) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
			String rid = reqDTO.getValue("rid");
			
			String sql ="delete from gp_wt_project_relocation t where t.id='"+rid+"'";
			dao.execute(sql);
			
			responseDTO.setValue("issuccess", "ok");
			
			return responseDTO;
			
		}
		
		/**
		 * ���涯Ǩ��Ŀ�����Ϣ
		 * @param reqDTO
		 * @return
		 * @throws Exception
		 */
		public ISrvMsg saveRelocationData(ISrvMsg reqDTO) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
			String sadsad=reqDTO.getValue("team_manager");
			UserToken user = reqDTO.getUserToken();
			String projectInfoNo = user.getProjectInfoNo();
			
			Map rsMap = new HashMap();
			
			String rid = reqDTO.getValue("rid");
			if(rid!=null&&!rid.equals("")){
				rsMap.put("id", rid);
			}
			
			//String sql ="select * from gp_task_project t where t.project_info_no='"+projectInfoNo+"'";
			//Map tempMap = dao.queryForMap(sql);
			
			rsMap.put("project_name", reqDTO.getValue("project_name"));//��Ŀ����
			rsMap.put("project_info_no", projectInfoNo);//��Ŀno
			rsMap.put("construction_area", reqDTO.getValue("construction_area"));//ʩ������
			rsMap.put("method_code", reqDTO.getValue("method_code"));//��̽����
			rsMap.put("work_team", reqDTO.getValue("work_team"));//ʩ������
			rsMap.put("team_manager", reqDTO.getValue("team_manager"));//�Ӿ���
			Date sqdate = new Date();
			SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd");
			//rsMap.put("create_date",sd.format(sqdate) );//��������
			//rsMap.put("creator", user.getUserName());//������
			rsMap.put("create_date",reqDTO.getValue("create_date") );//��������
			rsMap.put("creator", reqDTO.getValue("creator"));//������
			
			//rsMap.put("status", "0");//����״̬   ����
			
			
			
			//�����ļ�
			MQMsgImpl mqMsg = (MQMsgImpl) reqDTO;
			List<WSFile> fileList = mqMsg.getFiles();
			if(fileList.size()!=0){
				
				for (WSFile uploadFile:fileList) {
					if(uploadFile.getKey().equals("technical_data")){
						byte[] uploadData = uploadFile.getFileData();
						String fileUcmId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
						rsMap.put("technical_data", fileUcmId);//��Ҫ���������嵥
						rsMap.put("technical_data_filename", uploadFile.getFilename());
					}else if(uploadFile.getKey().equals("relocation_plan")){
						byte[] uploadData = uploadFile.getFileData();
						String fileUcmId = myUcm.uploadFile(uploadFile.getFilename(), uploadData);
						rsMap.put("relocation_plan", fileUcmId);//��Ǩ�ƻ�
						rsMap.put("relocation_plan_filename", uploadFile.getFilename());
					}
				}
			}
			
			pureDao.saveOrUpdateEntity(rsMap, "gp_wt_project_relocation");
			
			
			//responseDTO.setValue("afParaMap", afParaMap);

			
			
			return responseDTO;
		}
		
		/**
		 * ��ѯ�˹���Դ�����ֶ�
		 * @param reqDTO
		 * @return
		 * @throws Exception
		 */
		public ISrvMsg queryWtAfPara(ISrvMsg reqDTO) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
			
			UserToken user = reqDTO.getUserToken();
			
			
			String currentPage = reqDTO.getValue("currentPage");
			if (currentPage == null || currentPage.trim().equals("")){
				currentPage = "1";
			}

			PageModel page = new PageModel();
			page.setCurrPage(Integer.parseInt(currentPage));
			page.setPageSize(10);
			
			String querySql ="select * from gp_wt_parameter_af_para t order by t.field_order";
			
			
			page = pureDao.queryRecordsBySQL(querySql,page);
			List paraList = page.getData();
			responseDTO.setValue("datas", paraList);
			responseDTO.setValue("totalRows", page.getTotalRow());
			responseDTO.setValue("pageSize", page.getPageSize());
			
			
			return responseDTO;
		}
		
		/**
		 * ��ѯ�˹���Դ�����ֶ�
		 * @param reqDTO
		 * @return
		 * @throws Exception
		 */
		public ISrvMsg getAllWtAfPara(ISrvMsg reqDTO) throws Exception {
			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
			
			String querySql ="select * from gp_wt_parameter_af_para t order by t.field_order";
			
			List allwtaf = pureDao.queryRecords(querySql);
			responseDTO.setValue("allwtaf", allwtaf);
			
			
			return responseDTO;
		}

		/**
		 * ������Ʋ���
		 * 
		 * @param reqDTO
		 * @return
		 * @throws Exception
		 */
		public ISrvMsg saveWtWorkMethod(ISrvMsg reqDTO) throws Exception {

			Map<String,Map<String,String>> orow = new HashMap();//�������� ����������
			List<Map> afrow = new ArrayList<Map>();//�˹���Դ����
			
			UserToken user = reqDTO.getUserToken();
			String project_info_no = user.getProjectInfoNo();
			Map rs = reqDTO.toMap();
			
			
			for (Iterator i = rs.entrySet().iterator(); i.hasNext();) {
				Map.Entry entry=(Map.Entry)i.next();
				String name = (String)entry.getKey();
				String names[] = name.split("-");
				if(names.length==2){
					
						//������̽��������
						if(orow.get(names[1])==null){
							Map<String,String> rowMap =  new HashMap<String,String>();
							rowMap.put(names[0], (String)entry.getValue());
							orow.put(names[1],rowMap);
						}else{
							((Map)orow.get(names[1])).put(names[0], (String)entry.getValue());
						}
					
					
				}else if(names.length==3){
					//names[0] para_value              names[1] ��̽����code        names[3] para_id
					if("para_value".equals(names[0])){
						//�˹���Դ����
						Map<String,String> rowMap =  new HashMap<String,String>();
						rowMap.put("para_value", (String)entry.getValue());
						rowMap.put("para_id", names[2]);
						rowMap.put("method_code", names[1]);
						rowMap.put("project_info_no", project_info_no);
						
						afrow.add(rowMap);
						
						
					}
				}
				
			}
			
			//����
			for (Iterator i = orow.entrySet().iterator(); i.hasNext();) {
				Map.Entry entry=(Map.Entry)i.next();
				String code = (String)entry.getKey();
				Map rowm = (Map)entry.getValue();
				rowm.put("method_code", code);
				rowm.put("project_info_no", project_info_no);
				
				pureDao.saveOrUpdateEntity(rowm, "gp_wt_parameter");
			}
			
			//���� �˹�
			dao.execute("delete from gp_wt_parameter_af t where t.project_info_no='"+project_info_no+"'");//ɾ��ԭ��
			for (int i=0;i<afrow.size();i++) {
				Map rowm = (Map)afrow.get(i);
				pureDao.saveOrUpdateEntity(rowm, "gp_wt_parameter_af");
			}
			
			
			
			
		
			//���� ֱ�ӱ���  ����method code
			
			Map clMap = new HashMap();
			String coordinate = reqDTO.getValue("coordinate") != null ? reqDTO
					.getValue("coordinate") : "";
			String high_work = reqDTO.getValue("high_work") != null ? reqDTO
					.getValue("high_work") : "";
			String shadow_method = reqDTO.getValue("shadow_method") != null ? reqDTO
					.getValue("shadow_method")
					: "";
			String observe_method = reqDTO.getValue("observe_method") != null ? reqDTO
					.getValue("observe_method")
					: "";
			String static_observe_method = reqDTO.getValue("static_observe_method") != null ? reqDTO
					.getValue("static_observe_method")
					: "";
			String rtk = reqDTO.getValue("rtk") != null ? reqDTO.getValue("rtk")
					: "";
			String center_control_radius = reqDTO.getValue("center_control_radius") != null ? reqDTO
					.getValue("center_control_radius")
					: "";
			String measuring_line = reqDTO.getValue("measuring_line") != null ? reqDTO
					.getValue("measuring_line")
					: "";
			String measure_precision_target = reqDTO
					.getValue("measure_precision_target") != null ? reqDTO
					.getValue("measure_precision_target") : "";
			String quality_target = reqDTO.getValue("quality_target") != null ? reqDTO
					.getValue("quality_target")
					: "";
					
			String idcl = reqDTO.getValue("idcl");//id		
			if(idcl!=null&&!idcl.equals("")){	
				clMap.put("id", idcl);//��¼id
			}
			clMap.put("project_info_no", project_info_no);//��Ŀid
			clMap.put("coordinate", coordinate);
			clMap.put("high_work", high_work);
			clMap.put("shadow_method", shadow_method);
			clMap.put("observe_method", observe_method);
			clMap.put("static_observe_method", static_observe_method);
			clMap.put("rtk", rtk);
			clMap.put("center_control_radius", center_control_radius);
			clMap.put("measuring_line", measuring_line);
			clMap.put("measure_precision_target", measure_precision_target);
			clMap.put("quality_target", quality_target);

			pureDao.saveOrUpdateEntity(clMap, "gp_wt_parameter");

			ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(reqDTO);
			responseDTO.setValue("saveResult", "1");
			return responseDTO;
		}

		/**
		 * ��ȡ��������
		 * 
		 * @throws Exception
		 */

		public ISrvMsg getWtWorkMethod(ISrvMsg reqDTO) throws Exception {
	 		UserToken user = reqDTO.getUserToken();
			String project_info_no = user.getProjectInfoNo();
			//String project_info_no = reqDTO.getValue("projectInfoNo");
			ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
			String sql = "select * from gp_wt_parameter t where t.project_info_no='"+ project_info_no + "' order by t.method_code";//����
			List<Map> methodDataList = pureDao.queryRecords(sql);
			responseMsg.setValue("methodDataList", methodDataList);
			
			Map<String,String> afRsMap = new HashMap<String,String>();
			sql = "select * from gp_wt_parameter_af t where t.project_info_no='"+ project_info_no + "'";//�˹���Դ
			List<Map> afList = pureDao.queryRecords(sql);
			for (int i = 0; i < afList.size(); i++) {
				Map orow = afList.get(i);
				String key="para_value-"+orow.get("method_code")+"-"+orow.get("para_id");
				String value=(String)orow.get("para_value");
				afRsMap.put(key, value);
			}
			responseMsg.setValue("afRsMap", afRsMap);
			
			return responseMsg;
		}
		
		/**
		 * ��ȡuser��Ŀ��Ӧ�Ŀ�̽����
		 * 
		 * @throws Exception
		 */

		public ISrvMsg getProjectMethod(ISrvMsg reqDTO) throws Exception {
			
			
			List methodMapList = new ArrayList();
			
			UserToken user = reqDTO.getUserToken();
			String project_info_no = user.getProjectInfoNo();
			//String project_info_no = reqDTO.getValue("projectInfoNo");
			ISrvMsg responseMsg = SrvMsgUtil.createResponseMsg(reqDTO);
			String sql = "select t.exploration_method from gp_task_project t where t.project_info_no='"+ project_info_no + "'";
			Map rs = pureDao.queryRecordBySQL(sql);
			String paratemp = "";
			if(rs!=null){
				String em = (String)rs.get("exploration_method");
				String emt[] = em.split(",");
				
				for (int i = 0; i < emt.length; i++) {
					paratemp+="'"+emt[i]+"',";
				}
				
				paratemp=paratemp.substring(0,paratemp.length()-1);
				
				sql = "select t.superior_code_id,t.coding_name,t.coding_code_id from comm_coding_sort_detail t where t.coding_code_id in ("+paratemp+") order by t.coding_code_id";
				List rl = pureDao.queryRecords(sql);
				for (Iterator iterator = rl.iterator(); iterator.hasNext();) {
					rs = (Map) iterator.next();
					Map methodNameMap = new HashMap();
					methodNameMap.put("coding_name",rs.get("coding_name"));
					methodNameMap.put("coding_code_id", rs.get("coding_code_id"));
					methodNameMap.put("superior_code_id", rs.get("superior_code_id"));
					methodMapList.add(methodNameMap);
				}
				
			}
			
			responseMsg.setValue("methodMapList", methodMapList);
			
		
			return responseMsg;
		}
		

	

}
