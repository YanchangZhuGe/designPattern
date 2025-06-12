package com.bgp.gms.service.rm.dm;

import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.collections.MapUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

import com.bgp.gms.android.srv.DeviceDataSrv;
import com.bgp.mcs.service.doc.service.MyUcm;
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
import com.cnpc.jcdp.webapp.upload.WebPathUtil;

/**
 * project: ������̽��Ŀ����ϵͳ
 * 
 * @author dushuai * description:������ģ����ز鿴��ά������
 * 
 */
@Service("DevInsSrv")
@SuppressWarnings({ "unchecked", "unused" })
public class DevTeamCheckSrv extends BaseService {

	public DevTeamCheckSrv() {
		log = LogFactory.getLogger(DevTeamCheckSrv.class);
	}
	private IPureJdbcDao pureJdbcDao = BeanFactory.getPureJdbcDAO();
	static MyUcm myUcm = (MyUcm) BeanFactory.getBean("myUcm");
	private IPureJdbcDao pureDao = BeanFactory.getPureJdbcDAO();
	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	//�豸ģ���ֳֻ���̨�������
	private DeviceDataSrv deviceDataSrv = (DeviceDataSrv) BeanFactory.getBean("DeviceDataSrv");
	

	/**
	 * ��ѯ��������Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevTeamCheckList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryDevTeamCheckList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String teamId = isrvmsg.getValue("teamId");// ����
		String dataSource = isrvmsg.getValue("dataSource");// ������Դ
		StringBuffer querySql = new StringBuffer();
		querySql.append("select t.*, case when t.data_source='0' then 'ƽ̨¼��' else '�ֳֻ�ͬ��' end as data_source_name ,sd.coding_name as team_name "
				+ " from bgp_device_inspection_team t "
				+ " left join comm_coding_sort_detail sd on t.team_id = sd.coding_code_id and sd.bsflag='0' "
				+ " where t.bsflag='0' ");
		// ����
		if (StringUtils.isNotBlank(teamId)) {
			querySql.append(" and t.team_id = '" + teamId + "'");
		}
		// ������Դ
		if (StringUtils.isNotBlank(dataSource)) {
			if("0".equals(dataSource)){
				querySql.append(" and t.data_source ='0' ");
			}
			if("1".equals(dataSource)){
				querySql.append(" and t.data_source is null ");
			}
		}
		querySql.append(" and t.project_info_no='"+user.getProjectInfoNo()+"' ");
		querySql.append(" order by t.check_date desc");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * �������޸İ�������Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveOrUpdateDevTeamCheckInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateDevTeamCheckInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Map map = isrvmsg.toMap();
		String flag=map.get("flag").toString();//�����޸ı�־
		Date date = new Date();
		try {
			//����ʱ���洴���ˣ�����ʱ�䣬�޸��ˣ��޸�ʱ�䣬ɾ����־���޸�ʱֻ���޸ģ��޸��ˣ��޸�ʱ��
			if("add".equals(flag)){
				map.put("project_info_no", user.getProjectInfoNo());//������Ŀ
				map.put("creator_id", user.getUserId());//������
				map.put("create_date", date);//����ʱ��
				map.put("bsflag", "0");//ɾ����־
				map.put("data_source", "0");//��ʾ���ݴ�ƽ̨¼��
			}
			map.put("updator_id", user.getUserId());//�޸���
			map.put("modifi_date", date);//�޸�ʱ��
			jdbcDao.saveOrUpdateEntity(map, "bgp_device_inspection_team");
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ��ȡ��������Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getDevTeamCheckInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getDevTeamCheckInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String id = isrvmsg.getValue("id");
		String msql = "select t.* from bgp_device_inspection_team t where t.bsflag='0' and t.inspection_team_id='"+id+"'";
		Map map=jdbcDao.queryRecordBySQL(msql);
		responseDTO.setValue("data", map);
		return responseDTO;
	}
	
	/**
	 * ��ȡ������Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getTeamInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getTeamInfo");
		UserToken user = isrvmsg.getUserToken();
		String projectType = user.getProjectType();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String sql = "select de.coding_code_id as id,de.coding_name as name"
				+ " from comm_coding_sort_detail de"
				+ " where de.bsflag = '0' and de.spare1 = '0' and de.coding_sort_id = '0110000001'";
		if("5000100004000000009".equals(projectType)||"5000100004000000006".equals(projectType)){
			//�������Ŀ���ۺ��ﻯ̽��Ŀ���Ͱ��鶼ʹ��½����Ŀ����
			sql += "and de.coding_mnemonic_id = '"+projectType+"' ";			
		}else{
			sql += "and de.coding_mnemonic_id = '5000100004000000001' ";
		}
			sql += " and length(de.coding_code)=2 order by de.coding_code, de.coding_show_id ";
		List<Map> list=jdbcDao.queryRecords(sql);
		responseDTO.setValue("datas", list);
		return responseDTO;
	}
	
	/**
	 * ɾ����������Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteDevTeamCheckfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteDevTeamCheckfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String id = isrvmsg.getValue("id");
		try{
			//ɾ���ϴ��ļ���Ϣ
			String fileName = "";
			String updateSql = "";
			String updateVersion = "";
			String updateLog = "";
			List<Map> listucmIds = (List<Map>) jdbcDao
					.queryRecords("select df.file_id,df.file_name from bgp_doc_gms_file df where df.is_file = '1' and df.bsflag='0' and df.relation_id in"
							+ "(select ins.inspection_id from bgp_comm_device_inspection ins where ins.bsflag = '0' and ins.inspection_team_id = '"
							+ id + "')");
			for(Map temp : listucmIds){
				String file_id=temp.get("file_id").toString();
				updateSql = "update bgp_doc_gms_file g set g.bsflag='1' where g.file_id='"+file_id+"'";
				updateVersion = "update bgp_doc_file_version g set g.bsflag='1' where g.file_id='"+file_id+"'";
				updateLog = "update bgp_doc_file_log g set g.bsflag='1' where g.file_id='"+file_id+"'";
				if(jdbcDao.executeUpdate(updateSql)>0){
					Map vmap=jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '0' and bfv.file_id= '"+file_id+"'");
					String fileVersion = "";
					if(MapUtils.isNotEmpty(vmap)){
						fileVersion = vmap.get("file_version").toString();	
					}
					System.out.println("delete, the fileVersion is:"+fileVersion);
					myUcm.docLog(file_id, fileVersion,4, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),fileName);
					jdbcDao.executeUpdate(updateVersion);
					jdbcDao.executeUpdate(updateLog);
				}
			}
			//ɾ�����������Ϣ
			String delSql0 = "update bgp_comm_device_inspection set bsflag='1',updator='"+user.getUserId()+"',modifi_date=sysdate where inspection_team_id ='"+id+"'";
			jdbcDao.executeUpdate(delSql0);
			//ɾ����λָ������Ϣ��
			String delSql = "update bgp_device_inspection_team set bsflag='1',updator_id='"+user.getUserId()+"',modifi_date=sysdate where inspection_team_id ='"+id+"'";
			jdbcDao.executeUpdate(delSql);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ��ѯ�豸��������Ϣ�б�
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg queryDevCheckList(ISrvMsg isrvmsg) throws Exception {
		log.info("queryDevCheckList");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String currentPage = isrvmsg.getValue("currentPage");
		if (currentPage == null || currentPage.trim().equals(""))
			currentPage = "1";
		String pageSize = isrvmsg.getValue("pageSize");
		if (pageSize == null || pageSize.trim().equals("")) {
			ConfigHandler cfgHd = ConfigFactory.getCfgHandler();
			pageSize = cfgHd.getSingleNodeValue("//pagination/pageSize");
		}
		PageModel page = new PageModel();
		page.setCurrPage(Integer.parseInt(currentPage));
		page.setPageSize(Integer.parseInt(pageSize));
		String inspectionTeamId = isrvmsg.getValue("inspectionTeamId");// �����������
		String teamId = isrvmsg.getValue("teamId");// ����
		String devSign = isrvmsg.getValue("devSign");// ʵ���ʶ��
		String selfNum = isrvmsg.getValue("selfNum");// �Ա��
		String licenseNum = isrvmsg.getValue("licenseNum");// ���պ�
		StringBuffer querySql = new StringBuffer();
		querySql.append("select * from (select t.dev_acc_id,t.dev_name,t.license_num,t.self_num,t.dev_model,t.dev_sign,t.actual_in_time,"
				+ " m.plan_date,t.bsflag,t.mix_type_id,t.dev_type,t.dev_team,t.modifi_date,"
				+ " row_number() over(partition by t.dev_acc_id order by m.plan_date asc) asd,"
				+ " case when ins.device_account_id is null then '0' else '1' end as dev_state,"
				+ " case when ins.device_account_id is null then 'δ���' else '�Ѽ��' end as dev_state_name,"
				+ " ins.inspection_id"
				+ " from gms_device_account_dui t"
				+ " left join gms_device_maintenance_plan m on t.dev_acc_id = m.dev_acc_id and m.plan_date > sysdate"
				+ " inner join gp_task_project p on t.project_info_id = p.project_info_no"
				+ " left join bgp_comm_device_inspection ins on t.dev_acc_id=ins.device_account_id and ins.bsflag='0' " 
				+ " and ins.inspection_team_id='"+inspectionTeamId+"'"
				+ " where p.project_id = '"+user.getProjectId()+"' and t.actual_out_time is null"
				+ " and (t.dev_type like 'S0601%' or t.dev_type like 'S0622%' or t.dev_type like 'S0623%' or t.dev_type like 'S07010101%' or"
				+ " t.dev_type like 'S070301%' or t.dev_type like 'S0801%' or t.dev_type like 'S0808%' or t.dev_type like 'S0802%' or t.dev_type like 'S0803%' or"
				+ " t.dev_type like 'S0804%' or t.dev_type like 'S080503%' or t.dev_type like 'S080504%' or t.dev_type like 'S080601%' or"
				+ " t.dev_type like 'S080604%' or t.dev_type like 'S080607%' or t.dev_type like 'S0901%') and t.dev_team='"+teamId+"' ");
				
		// ʵ���ʶ��
		if (StringUtils.isNotBlank(devSign)) {
			querySql.append(" and t.dev_sign like '%" + devSign + "%'");
		}
		// �Ա��
		if (StringUtils.isNotBlank(selfNum)) {
			querySql.append(" and t.self_num like '%" + selfNum + "%'");
		}
		// ���պ�
		if (StringUtils.isNotBlank(licenseNum)) {
			querySql.append(" and t.license_num like '%" + licenseNum + "%'");
		}
		querySql.append(" order by dev_state,t.dev_type,t.self_num) where asd = 1");
		page = pureJdbcDao.queryRecordsBySQL(querySql.toString(), page);
		List docList = page.getData();
		responseDTO.setValue("datas", docList);
		responseDTO.setValue("totalRows", page.getTotalRow());
		responseDTO.setValue("pageSize", pageSize);
		return responseDTO;
	}
	
	/**
	 * ��ȡ����豸��Ϣ��Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg getCheckDevInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("getCheckDevInfo");
		UserToken user = isrvmsg.getUserToken();
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		String inspectionTeamId = isrvmsg.getValue("inspectionTeamId");//������id
		String devAccId = isrvmsg.getValue("devAccId");//�豸̨��id
		String msql = "select t.* from bgp_device_inspection_team t where t.bsflag='0' and t.inspection_team_id='"+inspectionTeamId+"'";
		Map map=jdbcDao.queryRecordBySQL(msql);
		String dsql = "select dui.* from gms_device_account_dui dui where dui.bsflag='0' and dui.dev_acc_id='"+devAccId+"'";
		Map dmap=jdbcDao.queryRecordBySQL(dsql);
		responseDTO.setValue("teamdata", map);
		responseDTO.setValue("devdata", dmap);
		return responseDTO;
	}
	
	/**
	 * �������������Ϣ
	 * 
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg saveInspectionInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("saveOrUpdateInspectionInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		Date date = new Date();
		SimpleDateFormat sdf22 = new SimpleDateFormat("yyyyMMddHHmmss");
		String today_time = sdf22.format(date);
		String id="";
		String devType=isrvmsg.getValue("dev_type").toString();//�豸����
		String projectInfoNo=isrvmsg.getValue("project_info_no").toString();//��Ŀid
		String dev_acc_id=isrvmsg.getValue("device_account_id").toString();//�豸̨��id
		String inspection_team_id=isrvmsg.getValue("inspection_team_id").toString();//�����������
		String inspection_date=isrvmsg.getValue("inspection_date").toString();//�������
		String inspector=isrvmsg.getValue("inspector").toString();//�����
		String inspection_content=isrvmsg.getValue("inspection_content").toString();//�������
		String checked_items=isrvmsg.getValue("checked_items").toString();//���������
		String path = WebPathUtil.getWebProjectPath();
		System.out.println("path == "+path);
		String user_id=user.getUserId();
		String outFilePath="";//�ļ���ʱ����·��
		String file_name="";//�ļ����� 
		try {
			Map map=new HashMap();
			map.put("inspection_id", "");//����
			map.put("bsflag", "0");//ɾ����־
			map.put("creator", user_id);//������
			map.put("create_date", date);//����ʱ��
			map.put("updator", user_id);//�޸���
			map.put("modifi_date", date);//�޸�ʱ��
			map.put("bsflag", "0");//ɾ����־
			map.put("inspector", inspector);///�����
			map.put("inspection_date", inspection_date);//�������
			map.put("inspection_content", inspection_content);//�������
			map.put("device_account_id", dev_acc_id);//�豸̨��id
			map.put("inspection_team_id", inspection_team_id);//�����������
			//���浥�����
			id=(String)jdbcDao.saveOrUpdateEntity(map, "bgp_comm_device_inspection");
			//�����豸�����excel
			if(devType.startsWith("S060101")||devType.startsWith("S060199")){//��װ������
				outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"��װ���"+today_time+".xls";
				file_name = "��װ���"+today_time+".xls";
				deviceDataSrv.savechezhuangzuanjiexcel(getCheckItemJsonData(checked_items),outFilePath,dev_acc_id,inspection_date,inspection_content);
			}
			if(devType.startsWith("S060102")){//���������
				outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"������"+today_time+".xls";
				file_name = "������"+today_time+".xls";
				deviceDataSrv.saveqingbianzhuanjiexcel(getCheckItemJsonData(checked_items),outFilePath,dev_acc_id,inspection_date,inspection_content);
			}
			if(devType.startsWith("S070301")){//���������
				outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"������"+today_time+".xls";
				System.out.println("outFilePath == "+outFilePath);
				file_name = "������"+today_time+".xls";
				deviceDataSrv.savetuituji(getCheckItemJsonData(checked_items),outFilePath,dev_acc_id,inspection_date,inspection_content);
			}
			if(devType.startsWith("S08") && (!devType.startsWith("S0808"))){//���䳵�����
				outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"���䳵��"+today_time+".xls";
				file_name = "���䳵��"+today_time+".xls";
				deviceDataSrv.saveexcel(getCheckItemJsonData(checked_items),outFilePath,dev_acc_id,inspection_date,inspection_content);
			}
			if(devType.startsWith("S0808") && (!devType.startsWith("S080805"))){//���䴬�����
				outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"���䴬��"+today_time+".xls";
				file_name = "���䴬��"+today_time+".xls";
				deviceDataSrv.saveYunshuchuanboExcel(getCheckItemJsonData(checked_items),outFilePath,dev_acc_id,inspection_date,inspection_content);
			}
			if(devType.startsWith("S0623")){//�ɿ���Դ
				outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"�ɿ���Դ"+today_time+".xls";
				file_name = "�ɿ���Դ"+today_time+".xls";
				deviceDataSrv.saveKekongzhenyuanExcel(getCheckItemJsonData(checked_items),outFilePath,dev_acc_id,inspection_date,inspection_content);
			}
			if(devType.startsWith("S08080501")){//�һ�
				outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"�һ�"+today_time+".xls";
				file_name = "�һ�"+today_time+".xls";
				deviceDataSrv.saveGuajiExcel(getCheckItemJsonData(checked_items),outFilePath,dev_acc_id,inspection_date,inspection_content);
			}
			if(devType.startsWith("S0901")){//�������
				outFilePath = path + File.separator + WebPathUtil.file_path+File.separator + user_id+File.separator+"�������"+today_time+".xls";
				file_name = "�������"+today_time+".xls";
				deviceDataSrv.saveFadianjizuExcel(getCheckItemJsonData(checked_items),outFilePath,dev_acc_id,inspection_date,inspection_content);
			}
			//�ϴ��ļ���ucm
			File fl = new File(outFilePath);
			byte by[] = new byte[200000];
			FileInputStream sn = new FileInputStream(fl);
			sn.read(by);
			String ucmDocId = "";
			ucmDocId = myUcm.uploadFile(fl.getName(),by);
			String file_id = jdbcDao.generateUUID();	
			String relation_id = id.toString();
			if(file_name==null || file_name.trim().equals("")){
				file_name = "";
			}
			StringBuffer sb = new StringBuffer();
			String folder_id = "";
			StringBuffer sbSql = new StringBuffer();
			sbSql = new StringBuffer("Insert into bgp_doc_gms_file(file_id,file_name,ucm_id,relation_id,project_info_no,bsflag,create_date,creator_id,modifi_date,updator_id,is_file,org_id,org_subjection_id,parent_file_id,file_number)");
			sbSql.append("values('").append(file_id).append("','").append(file_name).append("','").append(ucmDocId).append("','").append(relation_id).append("','").append(projectInfoNo).append("','0',sysdate,'")
			.append(user_id).append("',sysdate,'").append(user_id).append("','1','").append("").append("','").append("").append("','"+folder_id+"','')");
			jdbcDao.executeUpdate(sbSql.toString());
			myUcm.docVersion(file_id, "1.0", ucmDocId, user_id, user_id,"","",file_name);
			myUcm.docLog(file_id, "1.0", 1, user_id, user_id, user_id,"","",file_name);
			sn.close();
		} catch (Exception e) {
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
	
	/**
	 * ��ȡ�����json����
	 * @return
	 */
	public JSONArray getCheckItemJsonData(String checkedItems){
		 JSONArray jsonArray=new JSONArray();
		 if(!"".equals(checkedItems)){
			 String [] checkedItemsArr=checkedItems.split(",");
			 for(String str:checkedItemsArr){
				 JSONObject jsonObject = new JSONObject();
				 jsonObject.put("code_id",str);
				 jsonArray.add(jsonObject);
			 }
		 }
		 return jsonArray;
	}
	
	/**
	 * ɾ�����������Ϣ
	 * @param isrvmsg
	 * @return
	 * @throws Exception
	 */
	public ISrvMsg deleteInspectionInfo(ISrvMsg isrvmsg) throws Exception {
		log.info("deleteInspectionInfo");
		ISrvMsg responseDTO = SrvMsgUtil.createResponseMsg(isrvmsg);
		UserToken user = isrvmsg.getUserToken();
		String operationFlag = "success";
		String id = isrvmsg.getValue("id");
		try{
			//ɾ���ϴ��ļ���Ϣ
			String fileName = "";
			String updateSql = "";
			String updateVersion = "";
			String updateLog = "";
			List<Map> listucmIds = (List<Map>) jdbcDao.queryRecords("select df.file_id,df.file_name from bgp_doc_gms_file df where df.is_file = '1' and df.bsflag='0' and df.relation_id = '"+id+"'");					
			for(Map temp : listucmIds){
				String file_id=temp.get("file_id").toString();
				updateSql = "update bgp_doc_gms_file g set g.bsflag='1' where g.file_id='"+file_id+"'";
				updateVersion = "update bgp_doc_file_version g set g.bsflag='1' where g.file_id='"+file_id+"'";
				updateLog = "update bgp_doc_file_log g set g.bsflag='1' where g.file_id='"+file_id+"'";
				if(jdbcDao.executeUpdate(updateSql)>0){
					Map vmap=jdbcDao.queryRecordBySQL("select bfv.file_version from bgp_doc_file_version bfv where bfv.bsflag = '0' and bfv.file_id= '"+file_id+"'");
					String fileVersion = "";
					if(MapUtils.isNotEmpty(vmap)){
						fileVersion = vmap.get("file_version").toString();	
					}
					System.out.println("delete, the fileVersion is:"+fileVersion);
					myUcm.docLog(file_id, fileVersion,4, user.getUserId(), user.getUserId(), user.getUserId(),user.getCodeAffordOrgID(),user.getSubOrgIDofAffordOrg(),fileName);
					jdbcDao.executeUpdate(updateVersion);
					jdbcDao.executeUpdate(updateLog);
				}
			}
			//ɾ�����������Ϣ
			String delSql = "update bgp_comm_device_inspection set bsflag='1',updator='"+user.getUserId()+"',modifi_date=sysdate where inspection_id ='"+id+"'";
			jdbcDao.executeUpdate(delSql);
		}catch(Exception e){
			operationFlag = "failed";
		}
		responseDTO.setValue("operationFlag", operationFlag);
		return responseDTO;
	}
}	