package com.bgp.gms.comm.mail;

 

import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.jfree.util.Log;

import com.cnpc.jcdp.cfg.BeanFactory;
import com.cnpc.jcdp.cfg.PropertyConfig;
import com.cnpc.jcdp.log.ILog;
import com.cnpc.jcdp.log.LogFactory;
import com.cnpc.jcdp.rad.dao.RADJdbcDao;
import com.cnpc.sais.bpm.runtime.entity.inst.ExamineinstEntity;
import com.cnpc.sais.bpm.service.ExamineinstService;

/**
 * @Title: ExamineSendMails.java
 * @Package com.bgp.gms.comm.mail
 * @Description: ���������̷����ʼ�����
 * @author wuhj
 * @date 2014-10-11 ����11:36:26
 * @version V1.0
 */
public class ExamineSendMails
{

	private RADJdbcDao jdbcDao = (RADJdbcDao) BeanFactory.getBean("radJdbcDao");
	
	private SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
	
	private ILog log;
	
	public ExamineSendMails(){
		log = LogFactory.getLogger(ExamineSendMails.class);
	}

	/**
	 * 
	 * @Title: queryFlowTypes
	 * @Description: ��ѯ��Ҫ���������̱���
	 * @param @param flowTypeΪnull����ѯ����ģ�������
	 * @param @return �趨�ļ�
	 * @return List ��������
	 * @throws
	 */
	private List queryFlowTypes(String flowType)
	{
		String sql = null;
		// flowTypeΪnull����ѯ����ģ�������
		if (flowType == null)
		{
			// ��ѯ����ģ������
			sql = "select l.coding_code_id,l.coding_name from comm_coding_sort_detail l where l.coding_sort_id='5110000181' and l.superior_code_id='0'  order by l.coding_code_id asc";

		} else
		{
			sql = "SELECT * FROM COMM_CODING_SORT_DETAIL WHERE CODING_SORT_ID='5110000181' and  SUPERIOR_CODE_ID ='"
					+ flowType
					+ "' and bsflag='0' ORDER  BY  CODING_SHOW_ID desc";
		}
		List<Map> list = jdbcDao.queryRecords(sql);

		return list;
	}

	/**
	 * 
	* @Title: sendFlowInfoMailInfos
	* @Description: �����ʼ�
	* @param @param businessType    �趨�ļ�
	* @return void    ��������
	* @throws
	 */
	public void sendFlowInfoMailInfos(String businessType)
	{

		List businessT = queryFlowTypes(businessType);
 
		//�����ʼ���Ϣ
		Map<String, MailSenderInfo> mailsMap = new HashMap<String, MailSenderInfo>();
		//�ʼ�������־��Ϣ
		Map<String,List>  mailInfos = new HashMap<String,List>();
		
		for (int i = 0; i < businessT.size(); i++)
		{
			Map map = (Map) businessT.get(i);

			String business_type = (String) map.get("coding_code_id");
			String business_name = (String) map.get("coding_name");

			ExamineinstEntity examineinstEntity = (ExamineinstEntity) BeanFactory
					.getBean("Examineinst");

			ExamineinstService examineinstService = examineinstEntity
					.getExamineinstService();

			// ��ѯ�������͵�Ҷ�ӽڵ�
			String sqlBusinessType = "SELECT wm_concat(l.coding_code_id)  businessTypes from comm_coding_sort_detail l where  l.end_if=1 "
					+ " START WITH l.superior_code_id = '"
					+ business_type
					+ "'  CONNECT BY PRIOR l.coding_code_id = l.superior_code_id";

			Map businessTypes = jdbcDao.queryRecordBySQL(sqlBusinessType);

			businessType = (String) businessTypes.get("businesstypes");
			
			//���û��Ҷ�ӽڵ㣬����ȥ��ִ��
			if(businessType.equals("")){
				continue;
			}

			// ��ȡ����ģ��Ĵ���������
			List list = examineinstService
					.queryExamineInstListForMails(businessType);


			//�����ʼ���Ϣ
			for (int j = 0; j < list.size(); j++)
			{
				Map examineInfo = (Map) list.get(j);
 
				String procinstId = (String) examineInfo.get("procinstId");
				String entityId = (String) examineInfo.get("entityId"); 

				String sqlMail = "select st1.entity_id,st1.examine_start_date,er.email,ct.project_info_no,ct.project_name,er.user_name,ce.wf_mail_id,ce.wf_send_count,ce.day_count, to_char(ce.send_date,'yyyy-MM-dd') from wf_r_examineinst st1" +
						" left join  p_auth_user er on st1.examine_user_id=er.user_id "
						+ "left join  wf_r_variableinst nst on nst.procinst_id=st1.procinst_id and   nst.var_name in ('wfVar_projectInfoNo') "
						+ "left join  gp_task_project ct on nst.var_value=ct.project_info_no " +
						" left join WF_D_MAIL_NOTICE ce on st1.entity_id=ce.entity_id "
						+ "where st1.entity_id='" + entityId + "' and (  ce.send_status is null or ce.send_status<>'1' or to_char(ce.send_date,'yyyy-MM-dd')<'"+sf.format(new Date())+"'  )";

				Map mailData = jdbcDao.queryRecordBySQL(sqlMail);
				//�����Ѿ������꣬�鲻������
				if(mailData==null || mailData.isEmpty()){
					continue;
				}
				String email = (String) mailData.get("email"); 
				String projectName = (String) mailData.get("project_name");
				String project_info_no = (String) mailData.get("project_info_no");
				
				try
				{
					String projectInfoNos = getFilterProjectInfoNos();
					//��Ŀ����Ҫ���ʼ���ʾ
					if( ("").equals(project_info_no) || (projectInfoNos != null && projectInfoNos.indexOf(project_info_no)!=-1)){
						log.info("projectInfoNo======"+project_info_no);
						continue;
					}
				} catch (Exception e)
				{ 
					e.printStackTrace();
				}
				
				
				
				//����ʼ�Ϊ�գ������ʼ�֪ͨ
				if(email==null || email.equals("") || projectName==null || projectName.equals("")){
					continue;
				} 

				//�����ʼ���������Ϣ
				MailSenderInfo mailSenderInfo = mailsMap.get(email);
				
				if (mailSenderInfo == null) {
					mailSenderInfo = initMailSenderInfo();
					mailSenderInfo.setToAddress(email);
					String subject = "��̽��Ŀ����ϵͳ��������������Ϣ";
					mailSenderInfo.setSubject(subject);
					String content = "����ҵ����Ϣ��"+business_name+"ģ�飺\r\n" +projectName+"��" + getBusinessInfo(procinstId); 
					mailSenderInfo.setContent(content);
				}  else {
					String content = mailSenderInfo.getContent();
					content = content + ";\r\n" + projectName+"��" + getBusinessInfo(procinstId); 
					mailSenderInfo.setContent(content);
				}  
				
				mailsMap.put(email, mailSenderInfo);
		 
				//���ʼ����ͱ�WF_D_MAIL_NOTICE�����������
				Map mailInfo =  getwfDMailNotice(mailData);
				List infos = mailInfos.get(email);
				if(infos == null){
					infos = new ArrayList(); 
				}  
				infos.add(mailInfo);
				mailInfos.put(email, infos); 				
				
			} 
		}
		SimpleMailSender sms = new SimpleMailSender();
		
		List<String> filterEmail = queryMailFilterInfo();
		//���ʼ�
		Iterator ites = mailsMap.keySet().iterator();
		
		while(ites.hasNext()){
			String email = ites.next().toString();
			//����ʼ��ڹ��˱��У������ʼ�
			if(filterEmail.contains(email)){
				continue;
			}
			MailSenderInfo senderInfo = mailsMap.get(email);
			boolean flag = sms.sendTextMail(senderInfo);
			if(flag){
				List lss = mailInfos.get(email);
				for(int j=0; j<lss.size(); j++){ 
					Map map = (Map)lss.get(j);
					jdbcDao.saveOrUpdateEntity(map,"wf_d_mail_notice");
				}
				
			}
			break;
		}
		

	}
	
	private String getFilterProjectInfoNos() throws Exception{
		
		InputStream confs_is = PropertyConfig.class.getClassLoader().getResourceAsStream("mail_project_filter.properties");
		Properties  pro = new Properties();
		pro.load(confs_is);
		confs_is.close();
		  
		return pro.get("project_info_no").toString();
	}
	
	/**
	 * 
	* @Title: queryMailFilterInfo
	* @Description: �����ʼ�������Ϣ
	* @param @return    �趨�ļ�
	* @return List    ��������
	* @throws
	 */
	private List<String> queryMailFilterInfo(){
		
		String sql =" SELECT l.examine_user_mail FROM WF_D_NOSEND_MAIL l";
		
		List<Map> list = jdbcDao.queryRecords(sql);
		
		List<String> ls = new ArrayList<String> ();
		
		for(Map map:list){
			String examineUserMail = map.get("examine_user_mail").toString();
			ls.add(examineUserMail);
		}
		
		return ls;
	}
	/**
	 * 
	* @Title: getwfDMailNotice
	* @Description: �ʼ�������Ϣ������
	* @param @param mailData
	* @param @return    �趨�ļ�
	* @return Map    ��������
	* @throws
	 */
	private Map getwfDMailNotice(Map mailData){
		
		Map mailInfo = new HashMap();
		 
		String userName = (String) mailData.get("user_name");
		String entityId = (String) mailData.get("entity_id"); 
		String projectName = (String) mailData.get("project_name"); 
		
		mailInfo.put("WF_MAIL_ID", mailData.get("wf_mail_id"));
		mailInfo.put("ENTITY_ID", entityId);
		mailInfo.put("EXAMINE_PEOPLE", userName);
		mailInfo.put("PROJECT_NAME", projectName);
		mailInfo.put("PROJECT_ID",   mailData.get("project_info_no"));
		mailInfo.put("SEND_STATUS", "1"); 
		mailInfo.put("SEND_DATE",sf.format(new Date()));   
		mailInfo.put("SUBMIT_DATE",  mailData.get("examine_start_date"));
		Object sendCount = mailData.get("wf_send_count");
		if(sendCount == null || sendCount.equals("")){
			sendCount="0";
		}
		mailInfo.put("wf_send_count",  (Integer.parseInt(sendCount.toString())+1));
		Object dayCount = mailData.get("day_count");
		if(dayCount == null || dayCount.equals("")){
			dayCount="0";
		}
		mailInfo.put("day_count",  (Integer.parseInt(dayCount.toString())+1)); 
		
		return mailInfo;
	}

	/**
	 * 
	* @Title: getBusinessInfo
	* @Description:  ��ȡҵ����Ϣ
	* @param @param procinstId
	* @param @return    �趨�ļ�
	* @return String    ��������
	* @throws
	 */
	private String getBusinessInfo(String procinstId)
	{
		String sql = "select * from wf_r_variableinst vst where vst.var_name='businessInfo' and vst.procinst_id='"
				+ procinstId + "'";
		Map map = jdbcDao.queryRecordBySQL(sql);
		
		return (String)map.get("var_value");
	}

	/**
	 * 
	 * @Title: initMailSenderInfo
	 * @Description: ��ʼ���ʼ���
	 * @param @return �趨�ļ�
	 * @return MailSenderInfo ��������
	 * @throws
	 */
	private MailSenderInfo initMailSenderInfo()
	{
		MailSenderInfo senderInfo = new MailSenderInfo();
		senderInfo.setMailServerHost("mail.cnpc.com.cn");
		senderInfo.setMailServerPort("25");
		senderInfo.setValidate(true);
		senderInfo.setUserName("wuhaijun01@cnpc.com.cn");
		senderInfo.setPassword("wuhj123");// ������������
		senderInfo.setFromAddress("wuhaijun01@cnpc.com.cn");
		return senderInfo;
	}

}
